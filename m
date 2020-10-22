Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A21295B75
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 11:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509365AbgJVJLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 05:11:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503963AbgJVJLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 05:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603357910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gHzULOT3VOnkW/ImLdIo7YhLXMKjnV2V9o8V5VzEafU=;
        b=AurSUJRv2FZExMW917P0Sy8X6w1kqpiFRh2njx/9ozgRbOVlJNYWnTJMZXejfTWdgW736I
        WCcW1O0Op3FprX9re4ysN1rxdG6AWuRNt0wXbKoHNt5Fq8Ry/x1LwK2zfOLbb0c8hd3+m9
        xvAtQvHevl/UCjWPyttA+J8TeWRdLiE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-8Bi5nHvjON26T6NTNX-OZQ-1; Thu, 22 Oct 2020 05:11:48 -0400
X-MC-Unique: 8Bi5nHvjON26T6NTNX-OZQ-1
Received: by mail-wm1-f70.google.com with SMTP id o15so370914wmh.1
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 02:11:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=gHzULOT3VOnkW/ImLdIo7YhLXMKjnV2V9o8V5VzEafU=;
        b=fkve0zpjrr3ds8MihwXoDZwNtD9ad73ugfE1SBzKPATH75UJpPbAArCu9FN1UGd620
         e6wtCJM3FPcc3aAPGkN9Pf6oeIN6t6c2N1TWTvoyQlev6YrGRC3JQVs7tvYQccXEWgMY
         tcqGsOUtpkYX8UOudGBOoQakb5TRjSPqC9LxlefjGJHLNFf9p+hvPL+oA7tAFG1mNLFy
         r4rcCJPf6p1qTKD7S5TKn95E1iLWLmJtufMI6lPH87SQxTQseod2N1oR3bBf7WocLzFx
         38/J900MjIuM+Q1yovc4EGLlEMUDyOfhI5mSBGFQu0eVRu8qSrW7xgzvcXaVBSGSMdiB
         i5NQ==
X-Gm-Message-State: AOAM530pl8LCUIp5WYOyipIbFota1xI+RN7jKjGdqcDretPDhzXnEAYN
        pp+73LC9tHsqgubVSwNSz2XD+omc3Pd07Ixk4XPMYDSa7jHLENPMazpIbLvIgkV9R1gKDluCzdt
        7MrW3Tjqt2aRqG7Se
X-Received: by 2002:adf:e5cb:: with SMTP id a11mr1564561wrn.353.1603357906960;
        Thu, 22 Oct 2020 02:11:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxa8ExFhQWLsLMr0/nLupBmHExyR3egauTG4tuukH+ADjiSR3vlfGQ74SifFeC1b/FurYtTfA==
X-Received: by 2002:adf:e5cb:: with SMTP id a11mr1564545wrn.353.1603357906815;
        Thu, 22 Oct 2020 02:11:46 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id 24sm2354940wmg.8.2020.10.22.02.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 02:11:45 -0700 (PDT)
Date:   Thu, 22 Oct 2020 11:11:44 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        martin.varghese@nokia.com
Subject: [PATCH iproute2-next] m_mpls: test the 'mac_push' action after
 'modify'
Message-ID: <4340721b2347c9290d2e379ee22b3a1a05083eb6.1603357855.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 02a261b5ba1c ("m_mpls: add mac_push action") added a matches()
test for the "mac_push" string before the test for "modify".
This changes the previous behaviour as 'action m' used to match
"modify" while it now matches "mac_push".

Revert to the original behaviour by moving the "mac_push" test after
"modify".

Fixes: 02a261b5ba1c ("m_mpls: add mac_push action")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tc/m_mpls.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tc/m_mpls.c b/tc/m_mpls.c
index cb8019b1..2c3752ba 100644
--- a/tc/m_mpls.c
+++ b/tc/m_mpls.c
@@ -99,14 +99,14 @@ static int parse_mpls(struct action_util *a, int *argc_p, char ***argv_p,
 			if (check_double_action(action, *argv))
 				return -1;
 			action = TCA_MPLS_ACT_PUSH;
-		} else if (matches(*argv, "mac_push") == 0) {
-			if (check_double_action(action, *argv))
-				return -1;
-			action = TCA_MPLS_ACT_MAC_PUSH;
 		} else if (matches(*argv, "modify") == 0) {
 			if (check_double_action(action, *argv))
 				return -1;
 			action = TCA_MPLS_ACT_MODIFY;
+		} else if (matches(*argv, "mac_push") == 0) {
+			if (check_double_action(action, *argv))
+				return -1;
+			action = TCA_MPLS_ACT_MAC_PUSH;
 		} else if (matches(*argv, "dec_ttl") == 0) {
 			if (check_double_action(action, *argv))
 				return -1;
-- 
2.21.3

