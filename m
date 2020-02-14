Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16BA15DA29
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgBNPDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15014 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729491AbgBNPDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:19 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF15gD013950;
        Fri, 14 Feb 2020 07:03:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=MPJ2Jc8JIu3IUHuXoKb4GJJz6+JkH21/Rg7fBYqashw=;
 b=g46BhnvhnExTmKhHz/GaepQNLOu9KU3ACkEEtmaja+9mzaiYV2HZXgeCu2Vz+5XrCS5q
 e5jBOmYvmcgCZ1+sjrbX+B2n+zWocydMqYs20ERDkg2LzX4c98OVL1FwpLyLPVzXf/t+
 1jeB0+r+NzDmymfEKRPLffrk+1cjR5vzOVO+fK1e3alyvQseLZDijiQLVlKgeMvAgd5F
 LH8+g+XrCeRLL+HVh2+YW0xUvB33hCRQcTk21qlmQXMDqP15oSUVr/9JZP9TMQlV1FN6
 7d+1lUyx0XiodLhcbdLI5ULiv6kOABRpvoqxhOGaUVLWw0tbX7wQAUCBIF8hN5mzQuX2 Xg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5k3gr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:15 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:13 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:12 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:12 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id DF03F3F703F;
        Fri, 14 Feb 2020 07:03:10 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 02/18] net: add a reference to MACsec ops in net_device
Date:   Fri, 14 Feb 2020 18:02:42 +0300
Message-ID: <20200214150258.390-3-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214150258.390-1-irusskikh@marvell.com>
References: <20200214150258.390-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
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
index a9c6b5c61d27..01b90c290779 100644
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
@@ -1802,6 +1804,8 @@ enum netdev_priv_flags {
  *				that follow this device when it is moved
  *				to another network namespace.
  *
+ *	@macsec_ops:    MACsec offloading ops
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
@@ -2096,6 +2100,11 @@ struct net_device {
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

