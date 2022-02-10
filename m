Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74874B0D85
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241555AbiBJMZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:25:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241542AbiBJMZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:25:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B7442646
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644495897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Fv1bFey76cfKrs22KKsH0h7BCRARWXpAFXjfaPkP6U8=;
        b=afigX1YOLtOTN3JDEKyKM1sKWiLKZi4OjXyySKauLpq8VaoLZ5fxn0af7TTKF8Ac5eTJ4V
        +M7g0WplMlv7NPYUJOpKL5xZf9ZH6WxuEM1O4/ilrbEDyBadiG2IHIgYXKqs+aXUYMJxec
        uzywyg9lWbDjmqf2gqR4t+BrJfUuNDw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-RxvOT_W1OG68kfENhg2jEw-1; Thu, 10 Feb 2022 07:24:56 -0500
X-MC-Unique: RxvOT_W1OG68kfENhg2jEw-1
Received: by mail-wm1-f69.google.com with SMTP id i186-20020a1c3bc3000000b0037bb9f6feeeso2812190wma.5
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:24:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Fv1bFey76cfKrs22KKsH0h7BCRARWXpAFXjfaPkP6U8=;
        b=wZWjOoyeRaJCksQt0TeOhEAktRPcfmg2cYeSuXNfu6E7qAmC0kDWNrIV6Bj9GO6dCp
         9SWDtrxBOWs5whpnVSitff48PLFtJ45q24/sRDKRua0zVnt5xwtEse+WbSoCyWZa5126
         x3SB+WBSzpylgjsPUpsyByaxeiu32kZuussg8qjLv6UysE+Ky8qYjqYT501LnksF4F0R
         d7FGIbMzh27Sy4VPClDARdcPoDIWLvL6YYuPLbKUnpfz5DKzNaqvjRHeMvk7PJWdg2yt
         7syfzwC9ZpsQyE7H2Y9GJDvkyy9ro2iSN5fvxiGip4yZTVjcQKSdrHj6pwGUtcnBr+Sy
         WLNQ==
X-Gm-Message-State: AOAM532CKH5a4Wmz0UAJwwvWuN8SAXW+GExxDYJQyL0Q+DxMxqaYvQMY
        gS7iI2xruyn3qZEI6c7TYx9ppLrn0vD6gJIn/9MTnXoUmGi/dAe2p5vb4umEAM8GqKJV5J+3yz/
        GI5UbyoFdSGo10zDB
X-Received: by 2002:adf:e34c:: with SMTP id n12mr6188126wrj.263.1644495895262;
        Thu, 10 Feb 2022 04:24:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQKl/ghmSWEV30HbtnUA6kVbHgFJM1OJxCg8/5GY3bKYO6DSqtae9AISNWfu0BFsyadI4Wkg==
X-Received: by 2002:adf:e34c:: with SMTP id n12mr6188120wrj.263.1644495895089;
        Thu, 10 Feb 2022 04:24:55 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id y14sm20537488wrd.91.2022.02.10.04.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 04:24:53 -0800 (PST)
Date:   Thu, 10 Feb 2022 13:24:51 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: [PATCH net-next] ipv4: Reject again rules with high DSCP values
Message-ID: <cca72292694a74c76a6e155b34a8480df2918a14.1644495285.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 563f8e97e054 ("ipv4: Stop taking ECN bits into account in
fib4-rules") replaced the validation test on frh->tos. While the new
test is stricter for ECN bits, it doesn't detect the use of high order
DSCP bits. This would be fine if IPv4 could properly handle them. But
currently, most IPv4 lookups are done with the three high DSCP bits
masked. Therefore, using these bits doesn't lead to the expected
result.

Let's reject such configurations again, so that nobody starts to
use and make any assumption about how the stack handles the three high
order DSCP bits in fib4 rules.

Fixes: 563f8e97e054 ("ipv4: Stop taking ECN bits into account in fib4-rules")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/fib_rules.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index 117c48571cf0..001fea394bde 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -231,6 +231,11 @@ static int fib4_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 			       "Invalid dsfield (tos): ECN bits must be 0");
 		goto errout;
 	}
+	/* IPv4 currently doesn't handle high order DSCP bits correctly */
+	if (frh->tos & ~IPTOS_TOS_MASK) {
+		NL_SET_ERR_MSG(extack, "Invalid tos");
+		goto errout;
+	}
 	rule4->dscp = inet_dsfield_to_dscp(frh->tos);
 
 	/* split local/main if they are not already split */
-- 
2.21.3

