Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C5F15DA26
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgBNPDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:15 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39152 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729412AbgBNPDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:14 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF074A019190;
        Fri, 14 Feb 2020 07:03:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=4bDD4n1Kiz0F55nRs8+Sc4wdfI9RUyS3wolOANB9630=;
 b=u/FIUc4jeRQF8v/S4/lzTpQIdFnQYOcr6An4xjSwswiEpMQbcB1KFrmuLsOVqDIplxn7
 tgMlBbIsdAg+hNlOYdSR0GpmYAubqIZYPsr4ZOhxzMB80Ts2K49qBcqHVvJvgwHaAJDI
 d0QWs4m8SonKhyrOO4C6UzXCIjFFcToU0v8ciDP1OKDSUjlBmelC2LwEcWq6KuZFzSSi
 40FbScZD0N/0DE/7nlC865ZtnQOOBU7B8jrFplJITkDv38mWizbcfTprju/89Uo3lNEq
 ToGHjfxwVMfjEDiYgwNL6N1Mqk8xD1pQ7YvfGHCvP0LLxzrchryzOoRAVPUAXxB/z9Y6 iQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2n5jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:11 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:10 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:10 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id B96453F7041;
        Fri, 14 Feb 2020 07:03:08 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 01/18] net: introduce the MACSEC netdev feature
Date:   Fri, 14 Feb 2020 18:02:41 +0300
Message-ID: <20200214150258.390-2-irusskikh@marvell.com>
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

This patch introduce a new netdev feature, which will be used by drivers
to state they can perform MACsec transformations in hardware.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 include/linux/netdev_features.h | 3 +++
 net/ethtool/common.c            | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 34d050bb1ae6..9d53c5ad272c 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -83,6 +83,8 @@ enum {
 	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
 	NETIF_F_GRO_FRAGLIST_BIT,	/* Fraglist GRO */
 
+	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
+
 	/*
 	 * Add your fresh new feature above and remember to update
 	 * netdev_features_strings[] in net/core/ethtool.c and maybe
@@ -154,6 +156,7 @@ enum {
 #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
 #define NETIF_F_GRO_FRAGLIST	__NETIF_F(GRO_FRAGLIST)
 #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
+#define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 636ec6d5110e..b203e6cef4f8 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -60,6 +60,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
 	[NETIF_F_GRO_FRAGLIST_BIT] =	 "rx-gro-list",
+	[NETIF_F_HW_MACSEC_BIT] =	 "macsec-hw-offload",
 };
 
 const char
-- 
2.17.1

