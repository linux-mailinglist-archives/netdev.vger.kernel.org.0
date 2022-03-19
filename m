Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381564DEAA0
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 21:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244132AbiCSU1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 16:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244130AbiCSU1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 16:27:11 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0B835DFE;
        Sat, 19 Mar 2022 13:25:49 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id m12so13846997edc.12;
        Sat, 19 Mar 2022 13:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UOoYNkWbn3lmrKEsG1YOHnatThAIgskfCdr/GMzc900=;
        b=FMHp5b8Oreenx13Q81cuS53VAtjTKHzEOymx+hJeJ58vvMQW7Tzk/rbarGHHFANROV
         JEah+MBLJs9WIBok57cgluQ2hZ5Wae16wCUlihEYanNw96OZksh9xJxNfr86IPwPAzyc
         m4AczSJoEbiYsvGvgOWCf1YFCM6LancgKC72Ml5HlAmzBUatdOdtOSv61+tNSgLWbMbh
         0hR//Yr6zP5p3d3ukoNa8TL6QJgHojMJQ2K8BOdLp+c0pq/nmodWvjAMEMapM65ztzqT
         2NvPSNlkI9l73SxQ9FJ4DteCc9ftS4c2Sfh1a+GIm01q+F8lFogP1BvIZUPIsZBhv2Yo
         Z0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UOoYNkWbn3lmrKEsG1YOHnatThAIgskfCdr/GMzc900=;
        b=UIEC2epbpHk/WE39sSGAwhhPXKxVTGJZ2VHgS4ajz7LQEmxndgYbtMZvQ7IDC2qpJ/
         6CL+Ya19DljD8iSJwVuAcoXQKbGiA6mFWaJMJmSUXBygyJhC4SAxF7S4nVAXvDd6fr5M
         7Ck5VBQ+nMvhMYjhdyX+3w+o1Wr3ilepgsjGbK9ZpNhGEpflJGteC+7xQVa9gKNfC4DQ
         2YiYQ/myuvEyKRZMUSSMFjVz+61SMyka/ZrfFET5nNaKlZf4PImamIC8Gj/fTjwbqWBJ
         UI6QRwY/Qum6x0TfsCrPqXb03pvPub/DFBxknsyTEmzklDJY9snnWNRdoDTP1xiwC2I5
         IEeA==
X-Gm-Message-State: AOAM530AZuH4YJtGupvzcZzlutItApnaIdQ3wQ9B+sEGvCy0jnwmJJ75
        dkpmXxaLXFiaqKbIeDSWH98=
X-Google-Smtp-Source: ABdhPJzRWWxkZjo8KpR/DyRgICpiuH6OzWnV5AJcws63ScJIbsO4Zcilfric4wFhqebc4++F7D2ImA==
X-Received: by 2002:a05:6402:3590:b0:415:c162:f3d6 with SMTP id y16-20020a056402359000b00415c162f3d6mr16023255edc.124.1647721547808;
        Sat, 19 Mar 2022 13:25:47 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id d23-20020aa7d5d7000000b00418f7b2f1dbsm4471945eds.71.2022.03.19.13.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 13:25:47 -0700 (PDT)
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
Subject: [PATCH] netfilter: nf_tables: replace unnecessary use of list_for_each_entry_continue()
Date:   Sat, 19 Mar 2022 21:25:26 +0100
Message-Id: <20220319202526.2527974-1-jakobkoschel@gmail.com>
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

Since there is no way for the previous list_for_each_entry() to exit
early, this call to list_for_each_entry_continue() is always guaranteed
to start with the first element of the list and can therefore be
replaced with a call to list_for_each_entry().

In preparation to limit the scope of the list iterator to the list
traversal loop, the list iterator variable 'rule' should not be used
past the loop.

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d71a33ae39b3..bdd80136ef1d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8299,7 +8299,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	data_boundary = data + data_size;
 	size = 0;
 
-	list_for_each_entry_continue(rule, &chain->rules, list) {
+	list_for_each_entry(rule, &chain->rules, list) {
 		if (!nft_is_active_next(net, rule))
 			continue;
 

base-commit: 34e047aa16c0123bbae8e2f6df33e5ecc1f56601
-- 
2.25.1

