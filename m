Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD324E3D0B
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 11:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbiCVLAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 07:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiCVLAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 07:00:20 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531D657163;
        Tue, 22 Mar 2022 03:58:53 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bi12so35403728ejb.3;
        Tue, 22 Mar 2022 03:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6eTie8pN9DOlF868bn+y4zBjLnv2GLhQ4xR2n+oPB4o=;
        b=QzvTPalSltc1H2yWkF7TA/9e8Udp1ApWJdjNySe8TcsiL2zt3+USc7xlja6WIms09q
         j7Oac21kyr1Ue9ryUmmWZXJUwmgEjcfqOsczHxYoJrErWgb31lsHM0N/jlrR2Kkv3HE3
         ugKYnoHgOte8xlT3opFPTr39L/c24oQp8YHr7oojZPCXf4Phj3PX8a/LEathe2YlnxGD
         7D2dC5en8o51c6mBvB38CkZJZD/HwHvMjPLGCDEr8I51RpTYvQwRlE2xSQDwRxRVbC/R
         8Ma/wmPsDJM9xvdx1Galp5ZxfHuyYmfAdOJx33Dq0TkNs1vv1ViIPVC+kKhdbMO4JeM3
         1/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6eTie8pN9DOlF868bn+y4zBjLnv2GLhQ4xR2n+oPB4o=;
        b=guSRRA2HDYsjQvhsqAhUE1V7+NrvQiXH/R6YCfjCqpsHJ6rdEbRJiFKgere2WnMq1r
         q2B+Xf5IZmZvkzOZCx7OjBiHa7Lh/jkqdDxs9QuJd1mgCVAaUnrhXqLtAHqlZD8fQIRq
         xFLPscVd6zRAcr1ZKrBvPl/1tB3dDLynGLfM1bXkkhGaSo1llgyh85cdwnwCirytBmAA
         +rIwJMA828Q1IOnPVwmIWAk/xWKEpjN5CQZnS38diNeFiUODnjETby6/3vtbcaAKtuDf
         yVqP64+XpaAmH9NtV5QGhAt8UlgrBDrP2s0vrfzq2Q5cRhOZlotPsyg2KnPmIYhg7NMS
         TOyQ==
X-Gm-Message-State: AOAM530OS6P3uQhp823rMrQopA7FmfSzFhRAPaFXEWaA9ikYUJHKYoch
        SXDZuihTNcaLQVwWXPiKV0jWriE0c+Y=
X-Google-Smtp-Source: ABdhPJyazF0uGyLpbtzXM77PFzEF7PotXeqSwSX5ULFhQ7tu8+unt2hSIdsJNfpHLou/gGNVbk9Zrg==
X-Received: by 2002:a17:906:e87:b0:6df:8602:5801 with SMTP id p7-20020a1709060e8700b006df86025801mr25367980ejf.140.1647946731535;
        Tue, 22 Mar 2022 03:58:51 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id da19-20020a056402177300b00413583e0996sm9227623edb.14.2022.03.22.03.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 03:58:51 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jakob Koschel <jakobkoschel@gmail.com>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH v2] netfilter: nf_tables: replace unnecessary use of list_for_each_entry_continue()
Date:   Tue, 22 Mar 2022 11:56:44 +0100
Message-Id: <20220322105645.3667322-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since there is no way for list_for_each_entry_continue() to start
interating in the middle of the list they can be replaced with a call
to list_for_each_entry().

In preparation to limit the scope of the list iterator to the list
traversal loop, the list iterator variable 'rule' should not be used
past the loop.

v1->v2:
- also replace first usage of list_for_each_entry_continue() (Florian
Westphal)

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 net/netfilter/nf_tables_api.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d71a33ae39b3..6a8239b25a66 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8279,10 +8279,8 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	if (chain->blob_next || !nft_is_active_next(net, chain))
 		return 0;

-	rule = list_entry(&chain->rules, struct nft_rule, list);
-
 	data_size = 0;
-	list_for_each_entry_continue(rule, &chain->rules, list) {
+	list_for_each_entry(rule, &chain->rules, list) {
 		if (nft_is_active_next(net, rule)) {
 			data_size += sizeof(*prule) + rule->dlen;
 			if (data_size > INT_MAX)
@@ -8299,7 +8297,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	data_boundary = data + data_size;
 	size = 0;

-	list_for_each_entry_continue(rule, &chain->rules, list) {
+	list_for_each_entry(rule, &chain->rules, list) {
 		if (!nft_is_active_next(net, rule))
 			continue;


base-commit: f443e374ae131c168a065ea1748feac6b2e76613
--
2.25.1

