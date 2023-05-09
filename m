Return-Path: <netdev+bounces-999-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33EFD6FBCBB
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:51:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05DAC28116D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF381396;
	Tue,  9 May 2023 01:51:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E71383
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:51:22 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE9EA26E;
	Mon,  8 May 2023 18:50:54 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1ab0c697c2bso49726325ad.1;
        Mon, 08 May 2023 18:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683597053; x=1686189053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lP5IaIFdiCV3CLFQyofnNGbKobWaxQ8hETIzTLkOsHM=;
        b=IuzHeRYk9bZCJjY+c51BTwSfwNB3YJPrwNIPsXNAYGwynBe5GubLNbMQUh3GkPIOx1
         ABfJV/ZnmRKgJM6p5LnQWxKslcwTg9CUpSJjjkc+11iRUCyaGTcwxShndkiTqlidzp41
         dVrrF2zYq0a86ifYSpcqfu8MOK6rWMIYJn9suM7zv/mgxVvwCqXCRTDGuaxQuY3FMYe8
         QAD6dgtLiBySt4uA3CL/zd/ocT5WWm/G6xQ+gqrebAlZvFbAlIiAsWiG4G5bzBQ3BLMr
         7GKmdD5ou02+spSYoQ7FJjl383SXdeENzKhNCYO/Wd7MbUIwC0BrvRLFZo5zYqo4w9zW
         486w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683597053; x=1686189053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lP5IaIFdiCV3CLFQyofnNGbKobWaxQ8hETIzTLkOsHM=;
        b=UKu+3zAbhr0PmycHDId26v2RFBG1vUWYca/NwZg/wAqkOvp8j8+8h+ugBGWF9HNaVq
         eTLg2up3q2dUGctEyNPVxIYjgzTTcEf9UvVsyR9Xd93ia++Lor3z4fJgYQcKxvM5doES
         y1Fwc2KPeT9Z8ng+4xWngPMZRj6wzOLmFTrBJsbfaT9s1LZZV2tFiOQqe1EbF1bkHYAJ
         pz8NhsOib37NWm9WEqRnHXHoXXCscQtTf9kdsoi5UUGnOKd2IGsBmLtBXPw2JMyLTQab
         GdfoJEFg2cNOcpoygyffKqkD2jrrZsTHua1ZOsDZ3UonAhbdIPErnQsXWtmiUQ9dxUT6
         iV9Q==
X-Gm-Message-State: AC+VfDzhoYqSj3OlsPANQytFN7NvPLFF6VjYVbo7H896ia3vLDCw8YiP
	6NELDi2ls7fK25k4P+JZudw=
X-Google-Smtp-Source: ACHHUZ4ITCiXUXq8qffdksAkMo2gD+tX6SA8ac8w9NL+1hHgfMb58opbrOs2qVpb1OWg5QV+TvJyrg==
X-Received: by 2002:a17:902:f816:b0:1a9:3916:c2d1 with SMTP id ix22-20020a170902f81600b001a93916c2d1mr13097348plb.54.1683597053120;
        Mon, 08 May 2023 18:50:53 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id bb5-20020a170902bc8500b001ab05aaae2fsm149237plb.107.2023.05.08.18.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 18:50:52 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Tejun Heo <tj@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 09/13] net: qrtr: Use alloc_ordered_workqueue() to create ordered workqueues
Date: Mon,  8 May 2023 15:50:28 -1000
Message-Id: <20230509015032.3768622-10-tj@kernel.org>
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
Cc: Manivannan Sadhasivam <mani@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-arm-msm@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 net/qrtr/ns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 0f25a386138c..0f7a729f1a1f 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -783,7 +783,7 @@ int qrtr_ns_init(void)
 		goto err_sock;
 	}
 
-	qrtr_ns.workqueue = alloc_workqueue("qrtr_ns_handler", WQ_UNBOUND, 1);
+	qrtr_ns.workqueue = alloc_ordered_workqueue("qrtr_ns_handler", 0);
 	if (!qrtr_ns.workqueue) {
 		ret = -ENOMEM;
 		goto err_sock;
-- 
2.40.1


