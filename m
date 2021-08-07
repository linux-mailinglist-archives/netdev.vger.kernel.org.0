Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9D73E3542
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 14:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhHGMIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 08:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbhHGMIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 08:08:22 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A4CC0613CF;
        Sat,  7 Aug 2021 05:08:03 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u2so10837666plg.10;
        Sat, 07 Aug 2021 05:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fe+Qj13L2fpPtbQOlPpWUWp2MGqwowpxswIvzZUFPvw=;
        b=pwxgEYD4YDmvPKT65ehV5p9rq2kaMo1WsBdQc0LPMOsK1ocpIMQExH6S9dM+nWEIUJ
         NeD9P1sVLAAoZLx1pH33AZzFQ8FI5u+ob9GqsJEJjfWvDcB5BEa84neHewUlfLIgzmhb
         Q1AqIEtcRcbi2LNjRE3k8egJj2XClxNeqyLseB3clw6RpNRoCdPEFW98HyaxqWyNpZSE
         hsSzo+T7tDsvO8kzAuxsP8e78zoyx4Ht3deLvxZkiLDC5EIxAw488igkkvwbMHyR8UV7
         BxOVfPwSdCxmbcFVq9ViT/PBRb3dN88DaIiO+nzuG1RnCg96karkTqlwRxKqPuvFSD/u
         PgbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fe+Qj13L2fpPtbQOlPpWUWp2MGqwowpxswIvzZUFPvw=;
        b=HIuUgCzZHJ/gYh//5AeaGG7ZN1ynA9xZMnXStmH4i/Gl0beGnN9TC2V5GSiIt8QuAc
         tU7ePlnEsRqceERLCWool8DBjPGaDoB5t+VpyEbq5QTfIuhhFhk5qhAU0HpkQaRsvTyk
         +tpESWPmgGChSrMUcFQAJAZCGojGYIwZU43L81RiKD/rJAEYjLsQTU9mwDPDL7mOFqOf
         VOOvYli4hlDaIzFHMId04m9iXGILTANWhomCCk6T2riOorqbmAJPZ8ScXyhcK+eThX07
         t7JaCvsnbYfmoAd8Ao2YLtZwqKgu45LP6HSVmvFAAEPIsxHtgENm6LNqlF/2pWhgPlrb
         Ge3g==
X-Gm-Message-State: AOAM530pVNXC71GmM+9qr1EQ/ARFSEV0UkY7KsEAlCAS+OHbfaG/thBF
        M+5Vl+p6pzAtUFPhGtOk43I=
X-Google-Smtp-Source: ABdhPJxzlYppj5h2KdgEpEL+dwojRRtBt/bO/LqjU8q0P/dgmC+3e1Vcm8yjwm+DTIahIHNxOtigvw==
X-Received: by 2002:a62:9709:0:b029:3b2:ef36:6872 with SMTP id n9-20020a6297090000b02903b2ef366872mr15186759pfe.34.1628338083415;
        Sat, 07 Aug 2021 05:08:03 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id b15sm16471035pgj.60.2021.08.07.05.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 05:08:02 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Xiaofei Shen <xiaofeis@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>,
        =?UTF-8?q?Andr=C3=A9=20Valentin?= <avalentin@vmh.kalnet.hooya.de>
Subject: [RFC net-next 3/3] net: dsa: tag_qca: set offload_fwd_mark
Date:   Sat,  7 Aug 2021 20:07:26 +0800
Message-Id: <20210807120726.1063225-4-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210807120726.1063225-1-dqfext@gmail.com>
References: <20210807120726.1063225-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we offload flooding and forwarding, set offload_fwd_mark according to
Atheros header's type.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 net/dsa/tag_qca.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 6e3136990491..ee5c1fdfef47 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -50,7 +50,7 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
-	u8 ver;
+	u8 ver, type;
 	u16  hdr;
 	int port;
 	__be16 *phdr;
@@ -82,6 +82,15 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	if (!skb->dev)
 		return NULL;
 
+	type = (hdr & QCA_HDR_RECV_TYPE_MASK) >> QCA_HDR_RECV_TYPE_S;
+	switch (type) {
+	case 0x00: /* Normal packet */
+	case 0x19: /* Flooding to CPU */
+	case 0x1a: /* Forwarding to CPU */
+		dsa_default_offload_fwd_mark(skb);
+		break;
+	}
+
 	return skb;
 }
 
-- 
2.25.1

