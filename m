Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14202F9B9B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKLVMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:12:32 -0500
Received: from orthanc.universe-factory.net ([104.238.176.138]:40918 "EHLO
        orthanc.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726697AbfKLVMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:12:32 -0500
Received: from localhost.localdomain (unknown [IPv6:2001:19f0:6c01:100::2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by orthanc.universe-factory.net (Postfix) with ESMTPSA id 254DD1F56D;
        Tue, 12 Nov 2019 22:12:30 +0100 (CET)
From:   Matthias Schiffer <mschiffer@universe-factory.net>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        Matthias Schiffer <mschiffer@universe-factory.net>
Subject: [PATCH net-next v2 0/2] Implement get_link_ksettings for VXLAN and bridge
Date:   Tue, 12 Nov 2019 22:12:23 +0100
Message-Id: <cover.1573591594.git.mschiffer@universe-factory.net>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mesh routing protocol batman-adv (in particular the new BATMAN_V algorithm)
uses the link speed reported by get_link_ksettings to determine a path
metric for wired links. In the mesh framework Gluon [1], we layer VXLAN
and sometimes bridge interfaces on our Ethernet links.

These patches implement get_link_ksettings for these two interface types.
While this is obviously not accurate for bridges with multiple active
ports, it's much better than having no estimate at all (and in the
particular setup of Gluon, bridges with a single port aren't completely
uncommon).


[1] https://github.com/freifunk-gluon/gluon

Matthias Schiffer (2):
  vxlan: implement get_link_ksettings ethtool method
  bridge: implement get_link_ksettings ethtool method

 drivers/net/vxlan.c    | 24 ++++++++++++++++++++++--
 net/bridge/br_device.c | 36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 4 deletions(-)

-- 
2.24.0

