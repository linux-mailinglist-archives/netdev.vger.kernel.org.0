Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1F33CBF4E
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 00:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhGPWjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 18:39:32 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:11597 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229823AbhGPWjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 18:39:31 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Jul 2021 15:36:30 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.3])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id D4C1B208C7;
        Fri, 16 Jul 2021 15:36:35 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id C680DAA043; Fri, 16 Jul 2021 15:36:35 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/7] vmxnet3: upgrade to version 6
Date:   Fri, 16 Jul 2021 15:36:19 -0700
Message-ID: <20210716223626.18928-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmxnet3 emulation has recently added several new features which includes
increase in queues supported, remove power of 2 limitation on queues,
add RSS for ESP IPv6, etc. This patch series extends the vmxnet3 driver
to leverage these new features.

Compatibility is maintained using existing vmxnet3 versioning mechanism as
follows:
- new features added to vmxnet3 emulation are associated with new vmxnet3
   version viz. vmxnet3 version 6.
- emulation advertises all the versions it supports to the driver.
- during initialization, vmxnet3 driver picks the highest version number
supported by both the emulation and the driver and configures emulation
to run at that version.

In particular, following changes are introduced:

Patch 1:
  This patch introduces utility macros for vmxnet3 version 6 comparison
  and updates Copyright information.

Patch 2:
  This patch adds support to increase maximum Tx/Rx queues from 8 to 32.

Patch 3:
  This patch removes the limitation of power of 2 on the queues.

Patch 4:
  Uses existing get_rss_hash_opts and set_rss_hash_opts methods to add
  support for ESP IPv6 RSS.

Patch 5:
  This patch reports correct RSS hash type based on the type of RSS
  performed.

Patch 6:
  This patch updates maximum configurable mtu to 9190.

Patch 7:
  With all vmxnet3 version 6 changes incorporated in the vmxnet3 driver,
  with this patch, the driver can configure emulation to run at vmxnet3
  version 6.

Ronak Doshi (7):
  vmxnet3: prepare for version 6 changes
  vmxnet3: add support for 32 Tx/Rx queues
  vmxnet3: remove power of 2 limitation on the queues
  vmxnet3: add support for ESP IPv6 RSS
  vmxnet3: set correct hash type based on rss information
  vmxnet3: increase maximum configurable mtu to 9190
  vmxnet3: update to version 6

 drivers/net/vmxnet3/Makefile          |   2 +-
 drivers/net/vmxnet3/upt1_defs.h       |   2 +-
 drivers/net/vmxnet3/vmxnet3_defs.h    |  50 ++++++--
 drivers/net/vmxnet3/vmxnet3_drv.c     | 221 ++++++++++++++++++++++++----------
 drivers/net/vmxnet3/vmxnet3_ethtool.c |  20 +++
 drivers/net/vmxnet3/vmxnet3_int.h     |  22 +++-
 6 files changed, 235 insertions(+), 82 deletions(-)

-- 
2.11.0

