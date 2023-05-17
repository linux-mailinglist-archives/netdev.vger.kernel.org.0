Return-Path: <netdev+bounces-3462-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D0A70744A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 23:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FC371C20EEE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8499C107AD;
	Wed, 17 May 2023 21:31:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6A9AD28
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 21:31:26 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C231BD8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:31:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba81b238ee8so2307984276.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684359080; x=1686951080;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MVkZxvZRccB8oR9w42MAKnF8DsC5dHALM+TralSrLU0=;
        b=AYtTE1vR705tcMfDOdEiI7Ps6Xqgc52uwEL4s0EcsekMsajyD70KJRHngmUtBPP/0Y
         dc42xfasLqr1LkXPPdPtv11MnSsm1JhT8LrWW6zViDbQKw7KRayzf8J8LoZ/7cWXRRzB
         TasnM3QRZmVlXEatPbg4r/bqmlRL9g8KY7v2+c/M+IRBVaMjXX3Av2tmbxq1xF5gpYjl
         8GDhJ0FCwicVCEPG39Lgad9XBtygaH6xT91FLy12hDVJBddlbiLatSYuNakQQcBKW9C2
         cOGxJIEmoZT6ZmoEuVZA34+7rTeG8xZh4Gg00BejQVzt//y+d2s+BXGVV2DvF2rwU99J
         35Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684359080; x=1686951080;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MVkZxvZRccB8oR9w42MAKnF8DsC5dHALM+TralSrLU0=;
        b=HlTzeoMnB1KCxbBgBrHac7KlNxfj3OO3Cm088LJD10qiI26ZFIrccfKQAJIMnICBxk
         ITM0jSnzX/MQO02mL3zVpGiRYiyofdvZW6pOikQYY2nnpXNd2Jafl/q1twlVhXbgKEk3
         EhoHUoEvJ/V8JLfhzD+t4Fl9BZOrDs3MLYWUNi02Jv8n+mf/djp0HB+0itl/kI6Mtwaw
         6+laxTCZSzf1tZG6K6JP/a1Sw0eoRqxOfz2eQkFyN67v5T7i4mLsbwg+dMXW8YKLUShQ
         FQ9rYT0FkXIQoKXc7RzK9fY80EfXvNb/hq3rKRWuqCsyVLxb9Hm8iHowp9oO9nGF2s2z
         Iv3w==
X-Gm-Message-State: AC+VfDzG57g1r7dgXuj5C3zfeJWPF3CPJlnN5AeE6/ZsQ6oerCWrQ59Q
	fQvOy/09aYw2KoZKx4bFzkn7MTZNxv/pCg==
X-Google-Smtp-Source: ACHHUZ575b/bw34aYCIwIDh4F95bJmV73mhd9M2eFrsoj1di6T43zSkpcJfAl7BVupfnzlL0Cemz7/F94AGGPQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:bbc9:0:b0:b95:518b:4921 with SMTP id
 c9-20020a25bbc9000000b00b95518b4921mr18027008ybk.12.1684359080473; Wed, 17
 May 2023 14:31:20 -0700 (PDT)
Date: Wed, 17 May 2023 21:31:15 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517213118.3389898-1-edumazet@google.com>
Subject: [PATCH net 0/3] ipv6: exthdrs: fix three SRH issues
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Aring <alex.aring@gmail.com>, David Lebrun <david.lebrun@uclouvain.be>, 
	netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

While looking at a related CVE, I found three problems worth fixing
in ipv6_rpl_srh_rcv() and ipv6_srh_rcv().

Eric Dumazet (3):
  ipv6: exthdrs: fix potential use-after-free in ipv6_rpl_srh_rcv()
  ipv6: exthdrs: avoid potential NULL deref in ipv6_srh_rcv()
  ipv6: exthdrs: avoid potential NULL deref in ipv6_rpl_srh_rcv()

 net/ipv6/exthdrs.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

-- 
2.40.1.606.ga4b1b128d6-goog


