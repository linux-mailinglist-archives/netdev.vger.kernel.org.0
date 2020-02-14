Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675E415DA2A
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgBNPDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:25 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55042 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729412AbgBNPDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:24 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF0B8n019197;
        Fri, 14 Feb 2020 07:03:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=KvX7DLdi1dWU3Wz5dlWkE2n1w8Gxut+P0tCzcRF2J2Y=;
 b=sq9kuXGno+YgBZs+HaX7UjkBfnFhRym22tMrMtsm0zMRvOYD8SZ9stjby0hU6CeOqjn/
 DoC8C0MYQL8gTFlquAVHPs8Tgi1bF56bJec8wrxnpnI2gW+ljOm21Kmm4aQjR0zCK2og
 tTm3IDtmyQF9fXhKoYKC+oJuPDu247vhFFlzrWEDPHeJ4hbWWIWO+bbxrNjDywtI0bZt
 D6aB8VsRrL3XmKkWW4INZIGwq6QpEOp7SPNmR4KLSLRSJvVp53JAZ6+nW1j38nXWM0Ob
 fO75H26PTaEbLbI4D+GVsJG4usdi9bW7Q1UhcciHs7vm11Ibb6FO1g1i+0EwhS1srPIl 0A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2n5kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:21 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:20 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:19 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:18 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 55D1F3F703F;
        Fri, 14 Feb 2020 07:03:17 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 05/18] net: macsec: init secy pointer in macsec_context
Date:   Fri, 14 Feb 2020 18:02:45 +0300
Message-ID: <20200214150258.390-6-irusskikh@marvell.com>
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

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds secy pointer initialization in the macsec_context.
It will be used by MAC drivers in offloading operations.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index a88b41a79103..af41887d9a1e 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1692,6 +1692,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.rx_sa = rx_sa;
+		ctx.secy = secy;
 		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
 		       MACSEC_KEYID_LEN);
 
@@ -1733,6 +1734,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr **attrs = info->attrs;
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
+	struct macsec_secy *secy;
 	bool was_active;
 	int ret;
 
@@ -1752,6 +1754,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(dev);
 	}
 
+	secy = &macsec_priv(dev)->secy;
 	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
 
 	rx_sc = create_rx_sc(dev, sci);
@@ -1775,6 +1778,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		ctx.rx_sc = rx_sc;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_add_rxsc, &ctx);
 		if (ret)
@@ -1900,6 +1904,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.tx_sa = tx_sa;
+		ctx.secy = secy;
 		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
 		       MACSEC_KEYID_LEN);
 
@@ -1969,6 +1974,7 @@ static int macsec_del_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.rx_sa = rx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_del_rxsa, &ctx);
 		if (ret)
@@ -2034,6 +2040,7 @@ static int macsec_del_rxsc(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		ctx.rx_sc = rx_sc;
+		ctx.secy = secy;
 		ret = macsec_offload(ops->mdo_del_rxsc, &ctx);
 		if (ret)
 			goto cleanup;
@@ -2092,6 +2099,7 @@ static int macsec_del_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.tx_sa = tx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_del_txsa, &ctx);
 		if (ret)
@@ -2189,6 +2197,7 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.tx_sa = tx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_upd_txsa, &ctx);
 		if (ret)
@@ -2269,6 +2278,7 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.rx_sa = rx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_upd_rxsa, &ctx);
 		if (ret)
@@ -2339,6 +2349,7 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		ctx.rx_sc = rx_sc;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_upd_rxsc, &ctx);
 		if (ret)
@@ -3184,6 +3195,7 @@ static int macsec_dev_open(struct net_device *dev)
 			goto clear_allmulti;
 		}
 
+		ctx.secy = &macsec->secy;
 		err = macsec_offload(ops->mdo_dev_open, &ctx);
 		if (err)
 			goto clear_allmulti;
@@ -3215,8 +3227,10 @@ static int macsec_dev_stop(struct net_device *dev)
 		struct macsec_context ctx;
 
 		ops = macsec_get_ops(macsec, &ctx);
-		if (ops)
+		if (ops) {
+			ctx.secy = &macsec->secy;
 			macsec_offload(ops->mdo_dev_stop, &ctx);
+		}
 	}
 
 	dev_mc_unsync(real_dev, dev);
-- 
2.17.1

