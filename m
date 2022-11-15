Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B75E629965
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbiKOM4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbiKOM4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:56:06 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9734F2C7;
        Tue, 15 Nov 2022 04:56:05 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bs21so24112277wrb.4;
        Tue, 15 Nov 2022 04:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Suc+sDOw9njkbA6lorcFP1RSCMU5Z1RLuQ/KM9dn4E=;
        b=SgaeOd/CGA1rG+IGWVCNAzIArtZKPNHDEp26333K2hiCIWuZK0fNiyXHLKeYtb5NSe
         10CGzkbG948ccpsZdTedmzA2sHcADEuCwNlhZUEx0BCT+KLEeVC7xbaCEmuUhchv+g7p
         CURG8lFHKQrNGkTCIcBAfBawEfwDm8HIfPLvDOuJ2B7WI9ykxg4oCdpYQSWp5r7ngKNL
         gmfU9eSE8oAu6YDlgap9jEu1zH+dumW4dK+VjV9HV4yOfWLSGA5Zc0dhB1d1sM0URsR2
         bIpz6szMTAkUAaSMfED0YW7eiaGY2+kfqJjK8UYI9Nk1s/42spCHNurN4pSrbWHRLi4X
         QI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Suc+sDOw9njkbA6lorcFP1RSCMU5Z1RLuQ/KM9dn4E=;
        b=E7EBgIKWmt9oew0UWDxE13xCAFGZw3pRS3L7pwmrf/XkUJUeEP8tF09mOp5WXX298j
         PGYrX5wHhj303F1gCDn/SdXPugEPV9vVUewTgN9E9PHB0MFexnVBwN6Q1HEKFtMACxp5
         Gg8BUl8o+8PYhgcTni9lYOP/R9mH9i3xY8SN5R5gmFEGqQyWf2dgrR+bYEZMbhqGQt4S
         3rM2+nGjUCkvpITdkde2YL0XIXJJQ5FKUBzYIKlUVeKRrPnr65t4t5Ay2pybDGFwyK4a
         ymTchazjNREjAD2JabNcokdOMZ0u1qbWT/cIOVQA0BIRuEIl38SS25OfkxLXN7b/jK5M
         Tfrw==
X-Gm-Message-State: ANoB5pk6S1nTIisNy881LKD8lGN2lOrw87PtxDY04qhkOJ/ZpPjH4O1t
        q7yapDqHLvN0dCmDuRvN/x0=
X-Google-Smtp-Source: AA0mqf6LXGbMOdPES8+MrqVJoYnqb/iq4AENQu0yOdbYTfhxUcPgm3h/DU8Qxhdpm2V/pYdxUVOxwA==
X-Received: by 2002:a5d:4cd0:0:b0:236:757c:54a1 with SMTP id c16-20020a5d4cd0000000b00236757c54a1mr10665635wrt.106.1668516964004;
        Tue, 15 Nov 2022 04:56:04 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id v21-20020a05600c215500b003c6c3fb3cf6sm15168301wml.18.2022.11.15.04.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 04:56:03 -0800 (PST)
From:   Dan Carpenter <error27@gmail.com>
X-Google-Original-From: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Tue, 15 Nov 2022 15:56:00 +0300
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next/netfilter] netfilter: nft_inner: fix IS_ERR() vs
 NULL check
Message-ID: <Y3OMYNmQxpgXBAMA@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __nft_expr_type_get() function returns NULL on error.  It never
returns error pointers.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This applies to net-next but presumably it's going to go through the
netfilter tree?

 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 62da204eed41..6b159494c86b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2873,8 +2873,8 @@ int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
 		return -EINVAL;
 
 	type = __nft_expr_type_get(ctx->family, tb[NFTA_EXPR_NAME]);
-	if (IS_ERR(type))
-		return PTR_ERR(type);
+	if (!type)
+		return -ENOENT;
 
 	if (!type->inner_ops)
 		return -EOPNOTSUPP;
-- 
2.35.1

