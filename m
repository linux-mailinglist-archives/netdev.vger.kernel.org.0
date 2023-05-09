Return-Path: <netdev+bounces-1000-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C86686FBCBC
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75C972810D6
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA6F383;
	Tue,  9 May 2023 01:51:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4004517F0
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:51:28 +0000 (UTC)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F54A5FA;
	Mon,  8 May 2023 18:50:56 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1ab0c697c2bso49726565ad.1;
        Mon, 08 May 2023 18:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683597055; x=1686189055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wzzVWCLT7CybQfeQQoKtalxgsWtn1vK9dyFV4Pj3x8=;
        b=dCnxds2h5O2JmS2nsr5K6wfDnSJwjmLkmuWoZ1BKnNWPks1H/TMA9WWYDqkkNmOl2U
         Il4En8UeeDp+SHRwIagQnWPiKjBYH0qxsuqGVbpBnoKZZPK9/YXQ4ublXUCHRlhryEOF
         vDXkFY1yxE5CjldZNuAfvDsMb0UNXwBy2tCDkOGo0HUvB7pLF97rnLrT3RI5QH3o2WEF
         RruJx2RPaet2NyvHcHki5HqrXuF7BPwka9wJSy+EVUhQvU6E1DaOszxDjirQVpEYUwLN
         WVfgRENEINfJgaCOJorTn1blvsAfZKKWhdum4RUllaImWV+qIboofUJcKiIr+xIWt2Kp
         QRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683597055; x=1686189055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4wzzVWCLT7CybQfeQQoKtalxgsWtn1vK9dyFV4Pj3x8=;
        b=j1LDOKYBQCXRSbDjdv9gHEqrUlmec4zWEKaemXiWTCE4HyNbUJb90GNBGxqkLp//WQ
         PznfIVEHPP9J58oRLCRTDTD5o+kdyqK5AxIHNNJnX/cKPKrFVlpKjB8vFDZ3r8uOmE19
         JoqRQQxqqWB1qJb6gNjHuILzYqnjfaz3jLY3ZmpFaC1esEdM26fn4xOyagNYWxHN89dP
         UiCvVj3/R7sXV691T8Ll71T4ZTTuZFKGRFaCmcUa9nKrZyCVauCDZo01U7fznLINEF9g
         fVFpTtkwFAJmYqClHVfbjjloEcZiaeuIQ+u+bOK2RbsOJ1f50Ihe+bNs9HehaCFEXpS4
         VSFw==
X-Gm-Message-State: AC+VfDx7yr7JmYPhuy1I1DKbQE8IUlTlCw3+pz96zwFLEyRVmxVeQ+9l
	DLWYc+FlUsPNcB0xW3cINiU=
X-Google-Smtp-Source: ACHHUZ6YLDxJo1rwXIAisaqpgSMigXLyXSlmwBj7vvQFm+3mgPQ2CFRhLRwxkgopk/t9TqwjFbLJ7A==
X-Received: by 2002:a17:903:2292:b0:1a1:bff4:49e9 with SMTP id b18-20020a170903229200b001a1bff449e9mr17671752plh.23.1683597055036;
        Mon, 08 May 2023 18:50:55 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id jd12-20020a170903260c00b001ac937171e4sm133425plb.254.2023.05.08.18.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 18:50:54 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Tejun Heo <tj@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org
Subject: [PATCH 10/13] rxrpc: Use alloc_ordered_workqueue() to create ordered workqueues
Date: Mon,  8 May 2023 15:50:29 -1000
Message-Id: <20230509015032.3768622-11-tj@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230509015032.3768622-1-tj@kernel.org>
References: <20230509015032.3768622-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

BACKGROUND
==========

When multiple work items are queued to a workqueue, their execution order
doesn't match the queueing order. They may get executed in any order and
simultaneously. When fully serialized execution - one by one in the queueing
order - is needed, an ordered workqueue should be used which can be created
with alloc_ordered_workqueue().

However, alloc_ordered_workqueue() was a later addition. Before it, an
ordered workqueue could be obtained by creating an UNBOUND workqueue with
@max_active==1. This originally was an implementation side-effect which was
broken by 4c16bd327c74 ("workqueue: restore WQ_UNBOUND/max_active==1 to be
ordered"). Because there were users that depended on the ordered execution,
5c0338c68706 ("workqueue: restore WQ_UNBOUND/max_active==1 to be ordered")
made workqueue allocation path to implicitly promote UNBOUND workqueues w/
@max_active==1 to ordered workqueues.

While this has worked okay, overloading the UNBOUND allocation interface
this way creates other issues. It's difficult to tell whether a given
workqueue actually needs to be ordered and users that legitimately want a
min concurrency level wq unexpectedly gets an ordered one instead. With
planned UNBOUND workqueue updates to improve execution locality and more
prevalence of chiplet designs which can benefit from such improvements, this
isn't a state we wanna be in forever.

This patch series audits all callsites that create an UNBOUND workqueue w/
@max_active==1 and converts them to alloc_ordered_workqueue() as necessary.

WHAT TO LOOK FOR
================

The conversions are from

  alloc_workqueue(WQ_UNBOUND | flags, 1, args..)

to

  alloc_ordered_workqueue(flags, args...)

which don't cause any functional changes. If you know that fully ordered
execution is not ncessary, please let me know. I'll drop the conversion and
instead add a comment noting the fact to reduce confusion while conversion
is in progress.

If you aren't fully sure, it's completely fine to let the conversion
through. The behavior will stay exactly the same and we can always
reconsider later.

As there are follow-up workqueue core changes, I'd really appreciate if the
patch can be routed through the workqueue tree w/ your acks. Thanks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-afs@lists.infradead.org
Cc: netdev@vger.kernel.org
---
 net/rxrpc/af_rxrpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 31f738d65f1c..7eb24c25c731 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -988,7 +988,7 @@ static int __init af_rxrpc_init(void)
 		goto error_call_jar;
 	}
 
-	rxrpc_workqueue = alloc_workqueue("krxrpcd", WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+	rxrpc_workqueue = alloc_ordered_workqueue("krxrpcd", WQ_HIGHPRI | WQ_MEM_RECLAIM);
 	if (!rxrpc_workqueue) {
 		pr_notice("Failed to allocate work queue\n");
 		goto error_work_queue;
-- 
2.40.1


