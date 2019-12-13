Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD4111DFF4
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 09:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfLMIxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 03:53:35 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39945 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfLMIxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 03:53:35 -0500
Received: by mail-pg1-f195.google.com with SMTP id k25so1221323pgt.7;
        Fri, 13 Dec 2019 00:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=d5zc4ldGOePcriGMBp4z0Tbe+ACa8bDZdkIjO5eruws=;
        b=t2jNfPyzSNcyrrePw5HIeYStWuZ5SaS8nF17rgIzDN+hVws3cQK5VZIzVm2b2HNihX
         uHfDMppxqEXL18Rjynegj01wIkJryAQYuCQkyjr72NWwmoPCgFxdezeBtsCxsd6VZhc+
         wCTHU1kaXHNDQURZpcMc4LoMvzCtoGnew3IjcfndAABbTBkpCW9ZonbGaBWVQvTRq4RS
         XVlNivBMXi6k7T70kV3c58WqbKqSZ5fpXkUuntNk4RvIKd8rKKl7+/giNTOnsoN2r0GX
         rDtNBJl50WrOR1+fJROpVo992IcNLiMHLpjdJNnWTL+uJrvPbt1ZlN7nq36fILlV9sZ8
         LelA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=d5zc4ldGOePcriGMBp4z0Tbe+ACa8bDZdkIjO5eruws=;
        b=UczENCr4gL3VdcLOm4LJZc+6c72Xyc4dFBjG8P000ebQFo7Z1FpcqTd3O1u5bQVv+w
         RwY57o5kOh1upVihrNK8lA+4rJ1dpc6CvhPcwNY2ZWaXNWp0VkUzMaPXcpngmmaEMVxO
         C9K6AKLBkh+Nak59SA4CB+1a/wYumUij3s1303tAq5rjM0zDWDkNdD3WR2JNU3SWwtex
         hvC14GIusBiHSVVfLWuDU3Fpo9kGmhX3FKnQHUFEWfRHX6L2DM8kSdj6CvnFOSJn65V+
         IT54mxt+Qi8EIdu6vkwDFrjuVS/pA1SzlJ2mzF0ZbOmqs8L32ZS7lufTJkXyW6Nd55Vw
         9row==
X-Gm-Message-State: APjAAAU/zuCp+9hVBWgq0Ckd9Nibet0YJGDjvAZHQy94loZaKs88sXDh
        pfOqD4zApFnYZebhA9YPjTjML4cb
X-Google-Smtp-Source: APXvYqxygmMLrVbLmDOdxaSnakrIIaiWvLqdfgwJNUMNp5oiXS9XjSzvoietaPsc73K7p/mu+7rxtw==
X-Received: by 2002:a65:5809:: with SMTP id g9mr15919459pgr.146.1576227214740;
        Fri, 13 Dec 2019 00:53:34 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cu22sm8161044pjb.13.2019.12.13.00.53.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 00:53:34 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCHv2 nf-next 2/5] netfilter: nft_tunnel: add the missing ERSPAN_VERSION nla_policy
Date:   Fri, 13 Dec 2019 16:53:06 +0800
Message-Id: <7bcaa9e0507fa9a5b6a48f56768a179281bf4ab2.1576226965.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <38e59ca61c8582cfc0bf1b90cccc53c4455f8357.1576226965.git.lucien.xin@gmail.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
 <38e59ca61c8582cfc0bf1b90cccc53c4455f8357.1576226965.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1576226965.git.lucien.xin@gmail.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ERSPAN_VERSION is an attribute parsed in kernel side, nla_policy
type should be added for it, like other attributes.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index ef2065dd..6538895 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -248,8 +248,9 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
 }
 
 static const struct nla_policy nft_tunnel_opts_erspan_policy[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {
+	[NFTA_TUNNEL_KEY_ERSPAN_VERSION]	= { .type = NLA_U32 },
 	[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]	= { .type = NLA_U32 },
-	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]	= { .type = NLA_U8 },
+	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]		= { .type = NLA_U8 },
 	[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]	= { .type = NLA_U8 },
 };
 
-- 
2.1.0

