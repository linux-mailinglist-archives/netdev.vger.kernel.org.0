Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14EA5116053
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 05:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfLHElz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 23:41:55 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:33537 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfLHElz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 23:41:55 -0500
Received: by mail-pj1-f68.google.com with SMTP id r67so4437869pjb.0;
        Sat, 07 Dec 2019 20:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=PiPUbaZ3F/VC0IGTZ/uvjf53ColWW68Ki3o0Re+bG9I=;
        b=vMhnwX/JhJ9J5zeOsBt5Evd0YdQ27Q0Y7vMP25uAxj0OipfniZByl8m2aAOFcKCsFz
         mt9Vds41TqOZienstzPo6jL5nMi+opJ1quQDF9lfbDBlLNfDXbrU/CNiM7cAlxOCpZie
         DWOI5e5zJ8n7GszxJAhDy+hqzQZjwI099D70cXExPE97OYUOFZYK799kmy274EMY9uWJ
         ojEu7ZP6sAIdpw5+9ApwAdaZZ2KjAekXNYtLOC896pfdit/9GTPsDU5gXkVWCJnqyXeY
         33qakkxicqGaVAEAri1HEGMT4ojS1ZYBYRVbrhV4I646AykVhR0d4G8O9mEOUOstYpOl
         LGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=PiPUbaZ3F/VC0IGTZ/uvjf53ColWW68Ki3o0Re+bG9I=;
        b=oBSSiTAdl4nvP57Q2do0CdG8GJeZ61zq98MOaSK4UTT4GHkB0JLomdsn/s1IGJ1n9K
         4GKBXy1wghr/eMeFVSgoMPeETyFtzFh8R+In8XAbXf3PByFunhHYyeuHiWuYe5JhrS8Z
         Bkn0MyRfSDkdjsBa/PEU4MtFOkyYAxsVSWpnI+SLADj8Bme8PNjGNq84MgHdW0PG9y21
         Fk2cOWAJUMgNoPmP56XRUh/yVDipoXv3eOawjH5yS6uMXrEyfKErhW/RRe4Ph5wLqSbZ
         arWgurAsyzQyl5d72fUkPqsG87HvzNgVN7Sf5gfnssoYQWJvxYIB4GZ+d9L6LkZ2IXH2
         m0Dw==
X-Gm-Message-State: APjAAAVyWgdNdj+fmhSKtjtwq7zsKuDg4ZXrwtt1RTEsOtlmvGjqNW9N
        jl8MJXNRs1cx45opFGhXUgKaK9+Z
X-Google-Smtp-Source: APXvYqysu/lzMEJ6fYAL6gPgT3mZAgLkybpLjufnYVWiA1jwZR1sm4rJGgDRhXSwVctPM4OYZuRzEw==
X-Received: by 2002:a17:902:820f:: with SMTP id x15mr23511852pln.125.1575780114377;
        Sat, 07 Dec 2019 20:41:54 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k19sm22786326pfg.132.2019.12.07.20.41.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Dec 2019 20:41:53 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/7] netfilter: nft_tunnel: parse ERSPAN_VERSION attr as u8
Date:   Sun,  8 Dec 2019 12:41:31 +0800
Message-Id: <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To keep consistent with ipgre_policy, it's better to parse
ERSPAN_VERSION attr as u8, as it does in act_tunnel_key,
cls_flower and ip_tunnel_core.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/nft_tunnel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3d4c2ae..f76cd7d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -248,8 +248,9 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
 }
 
 static const struct nla_policy nft_tunnel_opts_erspan_policy[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {
+	[NFTA_TUNNEL_KEY_ERSPAN_VERSION]	= { .type = NLA_U8 },
 	[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]	= { .type = NLA_U32 },
-	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]	= { .type = NLA_U8 },
+	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]		= { .type = NLA_U8 },
 	[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]	= { .type = NLA_U8 },
 };
 
@@ -266,7 +267,7 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
 	if (err < 0)
 		return err;
 
-	version = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
+	version = nla_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]);
 	switch (version) {
 	case ERSPAN_VERSION:
 		if (!tb[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX])
-- 
2.1.0

