Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071F6180101
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgCJPEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:04:04 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3794 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726295AbgCJPED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:04:03 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AF1i5C007742;
        Tue, 10 Mar 2020 08:04:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=MZu/pZK/mY+5Sc6p0LZu+RbZTjbxW2KMCE8pifDTjU8=;
 b=X3apCl4XsGJ2CNcKyCdq9OUAlJtSqd0ET25YF654nuhBWWr1g/48NxrhcFJ95oytWyjW
 VJRSEbby79puxHva7Yo6SymgN63PbR1PpOlkQXaf203+r/UwJ4qFL2/+UcsKe8K4UC//
 zOUKhB8VkjdOEn5Uc2AETVVPp/p1V/VABfr/u1Z9ugW5V98QV+tHZxRSU26sfGo9sYI/
 ufkIALLFAjs7bcFF6ge1IgNct0pVVE9he3xdL75XyweNXxWLQc5HsIcWLuT21C49veCV
 OS6Uu8hmTbtXIC88UREEd7ZD3leTyd4eqiYQbT7ikFtGoluStY75T7mmI6fEic1Aev/k AQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwpm5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:04:00 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:03:59 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:03:59 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id F38033F703F;
        Tue, 10 Mar 2020 08:03:57 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [RFC v2 02/16] net: add a reference to MACsec ops in net_device
Date:   Tue, 10 Mar 2020 18:03:28 +0300
Message-ID: <20200310150342.1701-3-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310150342.1701-1-irusskikh@marvell.com>
References: <20200310150342.1701-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_08:2020-03-10,2020-03-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

This patch adds a reference to MACsec ops to the net_device structure,
allowing net device drivers to implement offloading operations for
MACsec.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 include/linux/netdevice.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 654808bfad83..b521500b244d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -53,6 +53,8 @@ struct netpoll_info;
 struct device;
 struct phy_device;
 struct dsa_port;
+struct macsec_context;
+struct macsec_ops;
 
 struct sfp_bus;
 /* 802.11 specific */
@@ -1819,6 +1821,8 @@ enum netdev_priv_flags {
  *				that follow this device when it is moved
  *				to another network namespace.
  *
+ *	@macsec_ops:    MACsec offloading ops
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
@@ -2113,6 +2117,11 @@ struct net_device {
 	unsigned		wol_enabled:1;
 
 	struct list_head	net_notifier_list;
+
+#if IS_ENABLED(CONFIG_MACSEC)
+	/* MACsec management functions */
+	const struct macsec_ops *macsec_ops;
+#endif
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
-- 
2.17.1

