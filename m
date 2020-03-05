Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0C217A5ED
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCENBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:01:51 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39426 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgCENBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 08:01:50 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so6913518wrn.6;
        Thu, 05 Mar 2020 05:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t2NGryvhCLvmnyd/Xl+UOhgKdKyuJOM/oppylBpY9rE=;
        b=aGYjkIi2IgcK9z6YzGxIfxClCbJ0x4WsZgfcWxSXZ/+tYuMuOVTGfkW/es0mIUDnXj
         2vtK3s07aW2Xfe9vizs18BLn1j3AvSewCkqsVOrl9rdUcbRCPk9xkvBj66MSOaGnrYlC
         fVE6EnvqWC/fbp6tB0SblmBy7hlLoEJdvDkfxte0abpbob5+/dASrY93/u1ZGD9FLTR0
         wsWA1hwmSHkabFC2Pa43Iq+gAjbAqOsU689Q67Ei/ZP0lJzSlMlaA0wQ8e6p3ZAkVaMo
         PVaBL8tY6VO+cxMTulmoqbY4vnShuuOrw9FVPGiYww/mrZW/DCnNtmCciOEnJaqORg4X
         FIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t2NGryvhCLvmnyd/Xl+UOhgKdKyuJOM/oppylBpY9rE=;
        b=OsB0BZgDvdemhwLR0/6wIsesWvhpxaI0YQc5hay1B6iNMHxUzWR6SAnPO5lPrwY1bP
         gHBJJBQCHe3HzLrsgoAomFhg2gVM7uHPjJPRjxKOru7871HuyUNrau1t4iLgZRiPNb29
         H2W8ZWV74phQGxFoBBYNu7Pdo3ltaqtaj+/CPIXUni8zYWSyZRcswEdfD7GHde2AKPkz
         h6/K/vfjKUCrVNp48CmVcmluiCFv3qdQXCDoqwkIs92VOiLEQamnTd9sNWkhlYu1lpr3
         UyGeqM2s5RZwjBbrniemGaZQQJZ+HGMK1EzC/hqBit0EJN4whuFiMcwHCKCG6wQkHQ9C
         BPrw==
X-Gm-Message-State: ANhLgQ2Ux/2K0XEGjIeXP5gfRu82dU0PUrCTOV/zhlTfXJYpC4reiu1b
        CkIBYu1cMEQ6u+OsSV5CKxQ=
X-Google-Smtp-Source: ADFU+vvR/18iNwy6cGdZGtDnmt55x+lq6hZiLJYMXU3MpwTn7DDblfi7EQGFbVcFKwmj698NStWPXw==
X-Received: by 2002:a5d:66c6:: with SMTP id k6mr10306466wrw.343.1583413306171;
        Thu, 05 Mar 2020 05:01:46 -0800 (PST)
Received: from localhost (hosting85.skyberate.net. [185.87.248.81])
        by smtp.gmail.com with ESMTPSA id c11sm43789619wrp.51.2020.03.05.05.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 05:01:42 -0800 (PST)
From:   Era Mayflower <mayflowerera@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Era Mayflower <mayflowerera@gmail.com>
Subject: [PATCH 2/2] macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)
Date:   Thu,  5 Mar 2020 22:01:08 +0000
Message-Id: <20200305220108.18780-2-mayflowerera@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305220108.18780-1-mayflowerera@gmail.com>
References: <20200305220108.18780-1-mayflowerera@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netlink support of extended packet number cipher suites,
allows adding and updating XPN macsec interfaces.

Added support in:
    * Creating interfaces with GCM-AES-XPN-128 and GCM-AES-XPN-256.
    * Setting and getting packet numbers with 64bit of SAs.
    * Settings and getting ssci of SCs.
    * Settings and getting salt of SecYs.

Depends on: macsec: Support XPN frame handling - IEEE 802.1AEbw.

Signed-off-by: Era Mayflower <mayflowerera@gmail.com>
---
 drivers/net/macsec.c           | 181 ++++++++++++++++++++++++++++++---
 include/net/macsec.h           |   3 +
 include/uapi/linux/if_link.h   |   2 +
 include/uapi/linux/if_macsec.h |   5 +
 4 files changed, 175 insertions(+), 16 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 5bfd0f92f..aff28ee89 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -240,11 +240,13 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 #define MACSEC_PORT_ES (htons(0x0001))
 #define MACSEC_PORT_SCB (0x0000)
 #define MACSEC_UNDEF_SCI ((__force sci_t)0xffffffffffffffffULL)
+#define MACSEC_UNDEF_SSCI ((__force ssci_t)0xffffffff)
 
 #define MACSEC_GCM_AES_128_SAK_LEN 16
 #define MACSEC_GCM_AES_256_SAK_LEN 32
 
 #define DEFAULT_SAK_LEN MACSEC_GCM_AES_128_SAK_LEN
+#define DEFAULT_XPN false
 #define DEFAULT_SEND_SCI true
 #define DEFAULT_ENCRYPT false
 #define DEFAULT_ENCODING_SA 0
@@ -1351,7 +1353,8 @@ static struct macsec_rx_sc *del_rx_sc(struct macsec_secy *secy, sci_t sci)
 	return NULL;
 }
 
-static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
+static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci,
+				ssci_t ssci)
 {
 	struct macsec_rx_sc *rx_sc;
 	struct macsec_dev *macsec;
@@ -1375,6 +1378,7 @@ static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
 	}
 
 	rx_sc->sci = sci;
+	rx_sc->ssci = ssci;
 	rx_sc->active = true;
 	refcount_set(&rx_sc->refcnt, 1);
 
@@ -1444,6 +1448,16 @@ static int nla_put_sci(struct sk_buff *skb, int attrtype, sci_t value,
 	return nla_put_u64_64bit(skb, attrtype, (__force u64)value, padattr);
 }
 
+static ssci_t nla_get_ssci(const struct nlattr *nla)
+{
+	return (__force ssci_t)nla_get_u32(nla);
+}
+
+static int nla_put_ssci(struct sk_buff *skb, int attrtype, ssci_t value)
+{
+	return nla_put_u32(skb, attrtype, (__force u64)value);
+}
+
 static struct macsec_tx_sa *get_txsa_from_nl(struct net *net,
 					     struct nlattr **attrs,
 					     struct nlattr **tb_sa,
@@ -1553,13 +1567,14 @@ static const struct nla_policy macsec_genl_policy[NUM_MACSEC_ATTR] = {
 
 static const struct nla_policy macsec_genl_rxsc_policy[NUM_MACSEC_RXSC_ATTR] = {
 	[MACSEC_RXSC_ATTR_SCI] = { .type = NLA_U64 },
+	[MACSEC_RXSC_ATTR_SSCI] = { .type = NLA_U32 },
 	[MACSEC_RXSC_ATTR_ACTIVE] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy macsec_genl_sa_policy[NUM_MACSEC_SA_ATTR] = {
 	[MACSEC_SA_ATTR_AN] = { .type = NLA_U8 },
 	[MACSEC_SA_ATTR_ACTIVE] = { .type = NLA_U8 },
-	[MACSEC_SA_ATTR_PN] = { .type = NLA_U32 },
+	[MACSEC_SA_ATTR_PN] = { .type = NLA_MIN_LEN, .len = 4 },
 	[MACSEC_SA_ATTR_KEYID] = { .type = NLA_BINARY,
 				   .len = MACSEC_KEYID_LEN, },
 	[MACSEC_SA_ATTR_KEY] = { .type = NLA_BINARY,
@@ -1636,7 +1651,7 @@ static bool validate_add_rxsa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (attrs[MACSEC_SA_ATTR_PN] && *(u64 *)nla_data(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -1658,6 +1673,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	struct macsec_rx_sa *rx_sa;
 	unsigned char assoc_num;
+	int pn_len;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
 	int err;
@@ -1690,6 +1706,14 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
+	if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+		pr_notice("macsec: nl: add_rxsa: bad pn length: %d != %d\n",
+			  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
+		rtnl_unlock();
+		return -EINVAL;
+	}
+
 	rx_sa = rtnl_dereference(rx_sc->sa[assoc_num]);
 	if (rx_sa) {
 		rtnl_unlock();
@@ -1712,7 +1736,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&rx_sa->lock);
-		rx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+		rx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
@@ -1772,6 +1796,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net_device *dev;
 	sci_t sci = MACSEC_UNDEF_SCI;
+	ssci_t ssci = MACSEC_UNDEF_SSCI;
 	struct nlattr **attrs = info->attrs;
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
@@ -1796,7 +1821,10 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 
 	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
 
-	rx_sc = create_rx_sc(dev, sci);
+	if (macsec_priv(dev)->secy.xpn)
+		ssci = nla_get_ssci(tb_rxsc[MACSEC_RXSC_ATTR_SSCI]);
+
+	rx_sc = create_rx_sc(dev, sci, ssci);
 	if (IS_ERR(rx_sc)) {
 		rtnl_unlock();
 		return PTR_ERR(rx_sc);
@@ -1866,6 +1894,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_tx_sc *tx_sc;
 	struct macsec_tx_sa *tx_sa;
 	unsigned char assoc_num;
+	int pn_len;
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
 	bool was_operational;
 	int err;
@@ -1898,6 +1927,14 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
+	if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+		pr_notice("macsec: nl: add_txsa: bad pn length: %d != %d\n",
+			  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
+		rtnl_unlock();
+		return -EINVAL;
+	}
+
 	tx_sa = rtnl_dereference(tx_sc->sa[assoc_num]);
 	if (tx_sa) {
 		rtnl_unlock();
@@ -1919,7 +1956,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	spin_lock_bh(&tx_sa->lock);
-	tx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+	tx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
 	spin_unlock_bh(&tx_sa->lock);
 
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
@@ -2206,9 +2243,19 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
+		int pn_len;
+
+		pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
+		if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+			pr_notice("macsec: nl: upd_txsa: bad pn length: %d != %d\n",
+				nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
+			rtnl_unlock();
+			return -EINVAL;
+		}
+
 		spin_lock_bh(&tx_sa->lock);
 		prev_pn = tx_sa->next_pn_halves;
-		tx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+		tx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&tx_sa->lock);
 	}
 
@@ -2292,9 +2339,19 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
+		int pn_len;
+
+		pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
+		if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+			pr_notice("macsec: nl: upd_rxsa: bad pn length: %d != %d\n",
+				nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
+			rtnl_unlock();
+			return -EINVAL;
+		}
+
 		spin_lock_bh(&rx_sa->lock);
 		prev_pn = rx_sa->next_pn_halves;
-		rx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+		rx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
@@ -2355,6 +2412,9 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 	if (!validate_add_rxsc(tb_rxsc))
 		return -EINVAL;
 
+	if (attrs[MACSEC_RXSC_ATTR_SSCI])
+		return -EINVAL;
+
 	rtnl_lock();
 	rx_sc = get_rxsc_from_nl(genl_info_net(info), attrs, tb_rxsc, &dev, &secy);
 	if (IS_ERR(rx_sc)) {
@@ -2741,10 +2801,10 @@ static int nla_put_secy(struct macsec_secy *secy, struct sk_buff *skb)
 
 	switch (secy->key_len) {
 	case MACSEC_GCM_AES_128_SAK_LEN:
-		csid = MACSEC_DEFAULT_CIPHER_ID;
+		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_128 : MACSEC_DEFAULT_CIPHER_ID;
 		break;
 	case MACSEC_GCM_AES_256_SAK_LEN:
-		csid = MACSEC_CIPHER_ID_GCM_AES_256;
+		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_256 : MACSEC_CIPHER_ID_GCM_AES_256;
 		break;
 	default:
 		goto cancel;
@@ -2771,6 +2831,14 @@ static int nla_put_secy(struct macsec_secy *secy, struct sk_buff *skb)
 			goto cancel;
 	}
 
+	if (secy->xpn) {
+		if (nla_put_ssci(skb, MACSEC_SECY_ATTR_SSCI, secy->ssci) ||
+			nla_put(skb, MACSEC_SECY_ATTR_SALT, MACSEC_SALT_LEN,
+					secy->salt.bytes) ||
+			0)
+			goto cancel;
+	}
+
 	nla_nest_end(skb, secy_nest);
 	return 0;
 
@@ -2835,6 +2903,8 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	for (i = 0, j = 1; i < MACSEC_NUM_AN; i++) {
 		struct macsec_tx_sa *tx_sa = rtnl_dereference(tx_sc->sa[i]);
 		struct nlattr *txsa_nest;
+		u64 pn;
+		int pn_len;
 
 		if (!tx_sa)
 			continue;
@@ -2845,8 +2915,16 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 			goto nla_put_failure;
 		}
 
+		if (secy->xpn) {
+			pn = tx_sa->next_pn;
+			pn_len = MACSEC_XPN_PN_LEN;
+		} else {
+			pn = tx_sa->next_pn_halves.lower;
+			pn_len = MACSEC_DEFAULT_PN_LEN;
+		}
+
 		if (nla_put_u8(skb, MACSEC_SA_ATTR_AN, i) ||
-		    nla_put_u32(skb, MACSEC_SA_ATTR_PN, tx_sa->next_pn_halves.lower) ||
+		    nla_put(skb, MACSEC_SA_ATTR_PN, pn_len, &pn) ||
 		    nla_put(skb, MACSEC_SA_ATTR_KEYID, MACSEC_KEYID_LEN, tx_sa->key.id) ||
 		    nla_put_u8(skb, MACSEC_SA_ATTR_ACTIVE, tx_sa->active)) {
 			nla_nest_cancel(skb, txsa_nest);
@@ -2895,6 +2973,14 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 			goto nla_put_failure;
 		}
 
+		if (secy->xpn) {
+			if (nla_put_ssci(skb, MACSEC_RXSC_ATTR_SSCI, rx_sc->ssci)) {
+				nla_nest_cancel(skb, rxsc_nest);
+				nla_nest_cancel(skb, rxsc_list);
+				goto nla_put_failure;
+			}
+		}
+
 		attr = nla_nest_start_noflag(skb, MACSEC_RXSC_ATTR_STATS);
 		if (!attr) {
 			nla_nest_cancel(skb, rxsc_nest);
@@ -2920,6 +3006,8 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 		for (i = 0, k = 1; i < MACSEC_NUM_AN; i++) {
 			struct macsec_rx_sa *rx_sa = rtnl_dereference(rx_sc->sa[i]);
 			struct nlattr *rxsa_nest;
+			u64 pn;
+			int pn_len;
 
 			if (!rx_sa)
 				continue;
@@ -2949,8 +3037,16 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 			}
 			nla_nest_end(skb, attr);
 
+			if (secy->xpn) {
+				pn = rx_sa->next_pn;
+				pn_len = MACSEC_XPN_PN_LEN;
+			} else {
+				pn = rx_sa->next_pn_halves.lower;
+				pn_len = MACSEC_DEFAULT_PN_LEN;
+			}
+
 			if (nla_put_u8(skb, MACSEC_SA_ATTR_AN, i) ||
-			    nla_put_u32(skb, MACSEC_SA_ATTR_PN, rx_sa->next_pn_halves.lower) ||
+			    nla_put(skb, MACSEC_SA_ATTR_PN, pn_len, &pn) ||
 			    nla_put(skb, MACSEC_SA_ATTR_KEYID, MACSEC_KEYID_LEN, rx_sa->key.id) ||
 			    nla_put_u8(skb, MACSEC_SA_ATTR_ACTIVE, rx_sa->active)) {
 				nla_nest_cancel(skb, rxsa_nest);
@@ -3408,6 +3504,9 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCB] = { .type = NLA_U8 },
 	[IFLA_MACSEC_REPLAY_PROTECT] = { .type = NLA_U8 },
 	[IFLA_MACSEC_VALIDATION] = { .type = NLA_U8 },
+	[IFLA_MACSEC_SSCI] = { .type = NLA_U32 },
+	[IFLA_MACSEC_SALT] = { .type = NLA_BINARY,
+					.len = MACSEC_SALT_LEN }
 };
 
 static void macsec_free_netdev(struct net_device *dev)
@@ -3480,15 +3579,32 @@ static int macsec_changelink_common(struct net_device *dev,
 		case MACSEC_CIPHER_ID_GCM_AES_128:
 		case MACSEC_DEFAULT_CIPHER_ID:
 			secy->key_len = MACSEC_GCM_AES_128_SAK_LEN;
+			secy->xpn = false;
 			break;
 		case MACSEC_CIPHER_ID_GCM_AES_256:
 			secy->key_len = MACSEC_GCM_AES_256_SAK_LEN;
+			secy->xpn = false;
+			break;
+		case MACSEC_CIPHER_ID_GCM_AES_XPN_128:
+			secy->key_len = MACSEC_GCM_AES_128_SAK_LEN;
+			secy->xpn = true;
+			break;
+		case MACSEC_CIPHER_ID_GCM_AES_XPN_256:
+			secy->key_len = MACSEC_GCM_AES_256_SAK_LEN;
+			secy->xpn = true;
 			break;
 		default:
 			return -EINVAL;
 		}
 	}
 
+	if (secy->xpn) {
+		if (data[IFLA_MACSEC_SSCI])
+			secy->ssci = nla_get_ssci(data[IFLA_MACSEC_SSCI]);
+		if (data[IFLA_MACSEC_SALT])
+			memcpy(&secy->salt, nla_data(data[IFLA_MACSEC_SALT]), MACSEC_SALT_LEN);
+	}
+
 	return 0;
 }
 
@@ -3507,7 +3623,9 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (data[IFLA_MACSEC_CIPHER_SUITE] ||
 	    data[IFLA_MACSEC_ICV_LEN] ||
 	    data[IFLA_MACSEC_SCI] ||
-	    data[IFLA_MACSEC_PORT])
+	    data[IFLA_MACSEC_PORT] ||
+		data[IFLA_MACSEC_SSCI] ||
+		data[IFLA_MACSEC_SALT])
 		return -EINVAL;
 
 	/* Keep a copy of unmodified secy and tx_sc, in case the offload
@@ -3677,8 +3795,12 @@ static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 	secy->validate_frames = MACSEC_VALIDATE_DEFAULT;
 	secy->protect_frames = true;
 	secy->replay_protect = false;
+	secy->xpn = DEFAULT_XPN;
+	secy->salt.ssci = 0;
+	secy->salt.pn = 0;
 
 	secy->sci = sci;
+	secy->ssci = MACSEC_UNDEF_SSCI;
 	secy->tx_sc.active = true;
 	secy->tx_sc.encoding_sa = DEFAULT_ENCODING_SA;
 	secy->tx_sc.encrypt = DEFAULT_ENCRYPT;
@@ -3752,6 +3874,12 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 		err = macsec_changelink_common(dev, data);
 		if (err)
 			goto del_dev;
+
+		if (macsec->secy.xpn &&
+			(!data[IFLA_MACSEC_SSCI] || !data[IFLA_MACSEC_SALT])) {
+			err = -EINVAL;
+			goto del_dev;
+		}
 	}
 
 	err = register_macsec_dev(real_dev, dev);
@@ -3806,6 +3934,8 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 	switch (csid) {
 	case MACSEC_CIPHER_ID_GCM_AES_128:
 	case MACSEC_CIPHER_ID_GCM_AES_256:
+	case MACSEC_CIPHER_ID_GCM_AES_XPN_128:
+	case MACSEC_CIPHER_ID_GCM_AES_XPN_256:
 	case MACSEC_DEFAULT_CIPHER_ID:
 		if (icv_len < MACSEC_MIN_ICV_LEN ||
 		    icv_len > MACSEC_STD_ICV_LEN)
@@ -3853,8 +3983,18 @@ static struct net *macsec_get_link_net(const struct net_device *dev)
 	return dev_net(macsec_priv(dev)->real_dev);
 }
 
-static size_t macsec_get_size(const struct net_device *dev)
+static size_t macsec_get_size(const struct net_device *dev) // TODO: ?
 {
+	size_t ssci_size = 0;
+	size_t salt_size = 0;
+
+	struct macsec_secy *secy = &macsec_priv(dev)->secy;
+
+	if (secy->xpn) {
+		ssci_size = nla_total_size(sizeof(ssci_t)); /* IFLA_MACSEC_SSCI */
+		salt_size = nla_total_size(MACSEC_SALT_LEN); /* IFLA_MACSEC_SALT */
+	}
+
 	return  nla_total_size_64bit(8) + /* IFLA_MACSEC_SCI */
 		nla_total_size(1) + /* IFLA_MACSEC_ICV_LEN */
 		nla_total_size_64bit(8) + /* IFLA_MACSEC_CIPHER_SUITE */
@@ -3867,6 +4007,8 @@ static size_t macsec_get_size(const struct net_device *dev)
 		nla_total_size(1) + /* IFLA_MACSEC_SCB */
 		nla_total_size(1) + /* IFLA_MACSEC_REPLAY_PROTECT */
 		nla_total_size(1) + /* IFLA_MACSEC_VALIDATION */
+		ssci_size + /* IFLA_MACSEC_SSCI */
+		salt_size + /* IFLA_MACSEC_SALT */
 		0;
 }
 
@@ -3879,10 +4021,10 @@ static int macsec_fill_info(struct sk_buff *skb,
 
 	switch (secy->key_len) {
 	case MACSEC_GCM_AES_128_SAK_LEN:
-		csid = MACSEC_DEFAULT_CIPHER_ID;
+		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_128 : MACSEC_DEFAULT_CIPHER_ID;
 		break;
 	case MACSEC_GCM_AES_256_SAK_LEN:
-		csid = MACSEC_CIPHER_ID_GCM_AES_256;
+		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_256 : MACSEC_CIPHER_ID_GCM_AES_256;
 		break;
 	default:
 		goto nla_put_failure;
@@ -3909,6 +4051,13 @@ static int macsec_fill_info(struct sk_buff *skb,
 			goto nla_put_failure;
 	}
 
+	if (secy->xpn) {
+		if (nla_put_ssci(skb, IFLA_MACSEC_SSCI, secy->ssci) ||
+			nla_put(skb, IFLA_MACSEC_SALT, MACSEC_SALT_LEN, secy->salt.bytes) ||
+			0)
+			goto nla_put_failure;
+	}
+
 	return 0;
 
 nla_put_failure:
diff --git a/include/net/macsec.h b/include/net/macsec.h
index a0b1d0b5c..3c7914ff1 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -11,6 +11,9 @@
 #include <uapi/linux/if_link.h>
 #include <uapi/linux/if_macsec.h>
 
+#define MACSEC_DEFAULT_PN_LEN 4
+#define MACSEC_XPN_PN_LEN 8
+
 #define MACSEC_SALT_LEN 12
 
 typedef u64 __bitwise sci_t;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 024af2d1d..ee424d915 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -462,6 +462,8 @@ enum {
 	IFLA_MACSEC_SCB,
 	IFLA_MACSEC_REPLAY_PROTECT,
 	IFLA_MACSEC_VALIDATION,
+	IFLA_MACSEC_SSCI,
+	IFLA_MACSEC_SALT,
 	IFLA_MACSEC_PAD,
 	__IFLA_MACSEC_MAX,
 };
diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
index 1d63c43c3..c8fab9673 100644
--- a/include/uapi/linux/if_macsec.h
+++ b/include/uapi/linux/if_macsec.h
@@ -25,6 +25,8 @@
 /* cipher IDs as per IEEE802.1AEbn-2011 */
 #define MACSEC_CIPHER_ID_GCM_AES_128 0x0080C20001000001ULL
 #define MACSEC_CIPHER_ID_GCM_AES_256 0x0080C20001000002ULL
+#define MACSEC_CIPHER_ID_GCM_AES_XPN_128 0x0080C20001000003ULL
+#define MACSEC_CIPHER_ID_GCM_AES_XPN_256 0x0080C20001000004ULL
 
 /* deprecated cipher ID for GCM-AES-128 */
 #define MACSEC_DEFAULT_CIPHER_ID     0x0080020001000001ULL
@@ -66,6 +68,8 @@ enum macsec_secy_attrs {
 	MACSEC_SECY_ATTR_INC_SCI,
 	MACSEC_SECY_ATTR_ES,
 	MACSEC_SECY_ATTR_SCB,
+	MACSEC_SECY_ATTR_SSCI,
+	MACSEC_SECY_ATTR_SALT,
 	MACSEC_SECY_ATTR_PAD,
 	__MACSEC_SECY_ATTR_END,
 	NUM_MACSEC_SECY_ATTR = __MACSEC_SECY_ATTR_END,
@@ -78,6 +82,7 @@ enum macsec_rxsc_attrs {
 	MACSEC_RXSC_ATTR_ACTIVE,  /* config/dump, u8 0..1 */
 	MACSEC_RXSC_ATTR_SA_LIST, /* dump, nested */
 	MACSEC_RXSC_ATTR_STATS,   /* dump, nested, macsec_rxsc_stats_attr */
+	MACSEC_RXSC_ATTR_SSCI,    /* config/dump, u32 */
 	MACSEC_RXSC_ATTR_PAD,
 	__MACSEC_RXSC_ATTR_END,
 	NUM_MACSEC_RXSC_ATTR = __MACSEC_RXSC_ATTR_END,
-- 
2.20.1

