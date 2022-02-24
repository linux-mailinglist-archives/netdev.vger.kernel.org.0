Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939344C2279
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 04:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiBXDlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 22:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiBXDlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 22:41:39 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5822C247757
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 19:41:11 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id t21so825799qkg.6
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 19:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s3ovoeYlbdVHc3j0rFP3xQfqw0QOl7ocKzZwdec0dSU=;
        b=Y9mUJkwV48L/ybwSPNtyvQoVqiV5v/1XkEDkw7iwTwMMnSjgT7cyoJrk1HJzNlGj97
         pQ10lI/Sj1thD/SIOn9p93CMvzIL+L11QohTfRd89wl1cr3pldEeqPYfkF+elaZJcevK
         Ni704KhK8PGstOFz0lRgmfrYqYGnf8U0ts0s7ebEyD5h+gH18LpT248NVY4bUVScjKwE
         gOoxnHgUPsj25je9jOuH8VBF0VLueuKNKTUwvqZiiJAzLACsN+7lrGUxE9U+9DSKzeaV
         edPMPbNwiYmN+y1aLloDVQSRsj3+vr7r7jStkZfXpCg0cWk1NBgEyFkVejIwnpU+9mhW
         UJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s3ovoeYlbdVHc3j0rFP3xQfqw0QOl7ocKzZwdec0dSU=;
        b=57rqgiwLTMkMIb3ImDqniT8cLTEshObXwhgS2pM/9yWUoVV86cntkZ6gtJ9skY5Ud1
         RaR/aGIdloKomkFcLuZv/8kxpOjR/Z3O0QYwbsrOPVFV21bh774x+ur1oc/E1FNcellY
         W6SJ3rWfAnaf06H1oSBovOM+bS+D9OYqUfs23GX7nkT8G8hPJzkIZOcQv5DwXVAb2fn5
         48ab2zoC4UHEfcV13IpmfsA3LE1oP1Ajq5ZQ7QXEFpAaHsvOGHHwVwXB2GPtzW3SbbZK
         GDF3FY/ft+HL7wcm4Dyc1TK88nr1VSrfcDOIFWWf1Ru5iar/H+BLUYnFRLwSBJnkGIzu
         nu2A==
X-Gm-Message-State: AOAM530t4hanVqCncKnk9fVTHlRB1etJ50nmkmFwLkfR5UMmewgNkj5E
        uI4z8ORAgOWT5PacuvgOPDjwCvok+d8=
X-Google-Smtp-Source: ABdhPJwFyQc4YGQ+dXizWbr7sPTVdHRiucdJk6xpIZXnrfrkHlZUuHGUfgZ/sqbVYxUNZ/rnLydEHQ==
X-Received: by 2002:a05:620a:1fc:b0:60d:d438:d628 with SMTP id x28-20020a05620a01fc00b0060dd438d628mr490684qkn.388.1645674070221;
        Wed, 23 Feb 2022 19:41:10 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z19sm863608qts.18.2022.02.23.19.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 19:41:09 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net] ping: remove pr_err from ping_lookup
Date:   Wed, 23 Feb 2022 22:41:08 -0500
Message-Id: <1ef3f2fcd31bd681a193b1fcf235eee1603819bd.1645674068.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

As Jakub noticed, prints should be avoided on the datapath.
Also, as packets would never come to the else branch in
ping_lookup(), remove pr_err() from ping_lookup().

Fixes: 35a79e64de29 ("ping: fix the dif and sdif check in ping_lookup")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ping.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 3a5994b50571..3ee947557b88 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -187,7 +187,6 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 			 (int)ident, &ipv6_hdr(skb)->daddr, dif);
 #endif
 	} else {
-		pr_err("ping: protocol(%x) is not supported\n", ntohs(skb->protocol));
 		return NULL;
 	}
 
-- 
2.31.1

