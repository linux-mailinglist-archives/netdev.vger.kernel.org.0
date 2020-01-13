Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F048139152
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgAMMrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:47:18 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:61024 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgAMMrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 07:47:17 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: RD4p/Wg+s1Laumdya/IjaXylg/7ZCLAE8POnUovvK7mjCITdUEFX5WeqxXwUiT1Mt+S8OQTp7p
 C8zCjVv4bZeICrSIbGOK7168IZNK/7foDCdBWKEpEvQ3s3tYCaxQvvBwtTH3FVFIz4UwiiVYLI
 y75HfoqtxAH3n3Z4IJZ85M/x8wZ1O4JOYZdYe3b/BcDO/bY9qUOweg4AEOH8sCuSw6WE8s495F
 DeRr3yBB/nipE5ecKFUkwrtwn+PlE+2zDMOVvzyxvcsesOv0aoX1hDpoIRFskOoXHYKSy4D6FW
 Iuo=
X-IronPort-AV: E=Sophos;i="5.69,429,1571727600"; 
   d="scan'208";a="63055957"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2020 05:47:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jan 2020 05:47:05 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 13 Jan 2020 05:47:01 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <jakub.kicinski@netronome.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <anirudh.venkataramanan@intel.com>,
        <andrew@lunn.ch>, <dsahern@gmail.com>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next Patch v2 0/4] net: bridge: mrp: Add support for Media Redundancy Protocol(MRP)
Date:   Mon, 13 Jan 2020 13:46:16 +0100
Message-ID: <20200113124620.18657-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the discussion on the first RFC[1], we have created a new RFC showing
what we were expecting to offload to HW.

This patch series contains the same patches plus another one which adds MRP
support to switchdev. MRP can now offload to HW the process of sending and
terminating MRP_Test frames. But based on the discussions from the previous
version, we decided to try to implement this in user space and extend bridge
netlink interface to be able to offload to HW the creation, sending and the
termination of the MRP_Test frames. Therefor this patch series is more like a
future reference.

We were thinking to extend the bridge netlink in such a way to be able to
offload to HW using switchdev. We were thinking to extend the families IFLA_BR_
and IFLA_BRPORT to add MRP support. Do you think that would be OK? Or should we
create a new family for the MRP?

changes from V2:
- Extend the patch series with another patch. The new patches extends switchdev
  interface for MRP. MRP will offload to HW the creating and sending of the
  MRP_Test frames.

[1] https://www.spinics.net/lists/netdev/msg623647.html

Horatiu Vultur (4):
  net: bridge: mrp: Add support for Media Redundancy Protocol
  net: bridge: mrp: Integrate MRP into the bridge
  net: bridge: mrp: Add netlink support to configure MRP
  net: bridge: mrp: switchdev: Add HW offload

 include/net/switchdev.h        |   52 ++
 include/uapi/linux/if_bridge.h |   27 +
 include/uapi/linux/if_ether.h  |    1 +
 include/uapi/linux/rtnetlink.h |    7 +
 net/bridge/Kconfig             |   12 +
 net/bridge/Makefile            |    2 +
 net/bridge/br.c                |   19 +
 net/bridge/br_device.c         |    3 +
 net/bridge/br_forward.c        |    1 +
 net/bridge/br_if.c             |   10 +
 net/bridge/br_input.c          |   22 +
 net/bridge/br_mrp.c            | 1543 ++++++++++++++++++++++++++++++++
 net/bridge/br_mrp_switchdev.c  |  180 ++++
 net/bridge/br_mrp_timer.c      |  258 ++++++
 net/bridge/br_netlink.c        |    9 +
 net/bridge/br_private.h        |   30 +
 net/bridge/br_private_mrp.h    |  224 +++++
 security/selinux/nlmsgtab.c    |    5 +-
 18 files changed, 2404 insertions(+), 1 deletion(-)
 create mode 100644 net/bridge/br_mrp.c
 create mode 100644 net/bridge/br_mrp_switchdev.c
 create mode 100644 net/bridge/br_mrp_timer.c
 create mode 100644 net/bridge/br_private_mrp.h

-- 
2.17.1

