Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8AE116059
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 05:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfLHEmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 23:42:20 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:44857 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfLHEmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 23:42:20 -0500
Received: by mail-pj1-f66.google.com with SMTP id w5so4415119pjh.11;
        Sat, 07 Dec 2019 20:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=UjtZXBSyprQ4mGwwoiOFGkJ78toSWvYGI5NT/nXnrTo=;
        b=YYtlqcaUAtG3zLXND+Y0jnOAYx3oqoHXMi2zhxAjrdjyoOJxrRx0mTm/QVmjgVsEJ3
         fO9dJsFSfHhm5gphK5WGVGsCJamJiZ6UYEtrNy3HTFb32TmOb7rmeN2p7wME9P6kTngE
         0IeRCzALDaOYbgWK/dpMYhtWVqvPAiVZ6yTnYix+uGsVFvU4OnxnKzU6AvkDZuJ8sx9V
         1Br6V0gfLP6LdfrC3B3EODdGAc4wtVhKsytzCkKBMhSAdMwuoJz8v3HT04UlVmjf9zgb
         IRUTPrhtQsh0+Upjofp8kHNxFcjNKs/aTDpAMfJeL3X2xNaWa9/FTKhL+pWs6DDCPBGr
         7n2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=UjtZXBSyprQ4mGwwoiOFGkJ78toSWvYGI5NT/nXnrTo=;
        b=Guya/R4ZfsAqOcPdQhwjV0TW1PKWWgQOSeOZmVoeyNDDvPxtHDw4+e3OWW4CzIvDpr
         SS20w3db3LOH+IlXqDOvWJg+rhmilusJfHdjYYNoZWazWIbDtcPFyIf0bYTlVj6oxVau
         zls/QJEC57k+Zf6lNbGbJ1st19dvrvGvTZbSUt7DjK+Pd2XINO5gFgA5+OkWHsn+mZHI
         bM476LHZ8CU1B0KVJzpwym7WiKuJdj8l5H/hn7hV3dbe0Ey5th++r5xLh86wk0cuN0SX
         tIM9EDlHAodxcI9eLV3LTPVWy/00vEMr6f7+CeI3tc4In89sDvd9Ikm4H4m1Q36C48DK
         nqXA==
X-Gm-Message-State: APjAAAVwFyuzmFkH1IBKTS9pSG3FWimjUlcyUWqQlLyrg2FQz/JXi3VI
        32CP15Mg/Q9GXOZRbmllNbtyG+d7
X-Google-Smtp-Source: APXvYqwaOZj1SDpU22XJ2ICfZpRaueDJkVewzdqUM4Q7mi8jChiXvFSqrZzLMjlvC3j+NrewL/mjDg==
X-Received: by 2002:a17:90a:aa8f:: with SMTP id l15mr25186165pjq.52.1575780139461;
        Sat, 07 Dec 2019 20:42:19 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z30sm10333842pfq.154.2019.12.07.20.42.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Dec 2019 20:42:18 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 4/7] netfilter: nft_tunnel: also dump ERSPAN_VERSION
Date:   Sun,  8 Dec 2019 12:41:34 +0800
Message-Id: <e64595c27468e392826f0afb5f18b68ce258787a.1575779993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <2c9abbd7ac3b89af9addb550bccb9169f47e39a2.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
 <533ced1ea1cc339c459d9446e610e782f165ae6b.1575779993.git.lucien.xin@gmail.com>
 <2c9abbd7ac3b89af9addb550bccb9169f47e39a2.1575779993.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not necessary, but it'll be easier to parse in userspace,
also given that other places like act_tunnel_key, cls_flower and
ip_tunnel_core are also doing so.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/nft_tunnel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index e1184fa..576437f 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -479,6 +479,9 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				opts->u.vxlan.gbp))
 			return -1;
 	} else if (opts->flags & TUNNEL_ERSPAN_OPT) {
+		if (nla_put_u8(skb, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
+			       opts->u.erspan.version))
+			return -1;
 		switch (opts->u.erspan.version) {
 		case ERSPAN_VERSION:
 			if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX,
-- 
2.1.0

