Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCE16EA203
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjDUCwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbjDUCvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:51:46 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27507A9D;
        Thu, 20 Apr 2023 19:51:24 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a66911f5faso15952255ad.0;
        Thu, 20 Apr 2023 19:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682045484; x=1684637484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzGS+UdzXek+xJHu4+K3eBKPYOUbqdAU3uJzg+J1eL4=;
        b=poUS2eXvbKbyutb8Y/OZuu5rSs7SDpvdzJfbPtqCXkQr6zq/VoRNZSPZCmxBfUDsQP
         GkvMCSIZ3YzfPb7O9lTcuV1wf4zJPgioZ8kgl9goI5X6NIqHC37zHNuiWwN/Rm21qFIg
         +4Uu92wJQZjpsHFfV9M/FHgmiFGfRNM+dyDTQEGyshzxNKqs8CN5u3KNWKrLA20MKEMX
         oA39jTCD0hjwjpz6UvCFLWTy4p9590VZUhoKq4upOa+p17MccNMEUDRHX/+ZhgHYVbtX
         18NdWSkK/S1DCFXwiAX6pxTUtLyTocrWQxuJkP22PyZW3ekvE+Xp0YUGFWTnnGrqfQ9O
         wt2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682045484; x=1684637484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mzGS+UdzXek+xJHu4+K3eBKPYOUbqdAU3uJzg+J1eL4=;
        b=LxcZmpPaDpjNtJ2Dwpe1Pyr7mLLne7VOmBf9+Wg5gn5592a7y9l6r3LFnktz8RTeyH
         slqyhH3818sHNcwZV7/McT7/YNBjQcI8aNFqvYz4fa9qgZyuhBRn4ckYZ8t+ksrcYFI0
         4KsofOCYCzqB0bg1AchlOoRUkLKlmgl1OTVHE4Bi1NxshziFdkIe8/mOCqXW/9vaaRTC
         skEFbxKI/0/GakPIocRLVPJWyoZe/NADU+badq962HwQ483LDKOAeB+oulv1RzN8XV3B
         rsHtV+RbqFqH2EZY6ksjbRbu2JSYqfKExNLUjlC1G8d9ZtF9QS9FZzTGqGdmhN7+cI5S
         YFyQ==
X-Gm-Message-State: AAQBX9fKokeN39xEghey1MsrsbOqC1jrt8Jmt5SoHztMeszXrAUC737K
        YcFor45IalMPnbkvWqfL53eTmFL03FA=
X-Google-Smtp-Source: AKy350adkbcdQ+ZlfSVaF6TDc/qHvNHFULbKey7nmI9cu4rWZjkWuS/PG4VbIJZp/FGuVePSV2tTUA==
X-Received: by 2002:a17:902:f683:b0:1a8:17db:e252 with SMTP id l3-20020a170902f68300b001a817dbe252mr3875983plg.34.1682045483982;
        Thu, 20 Apr 2023 19:51:23 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id a13-20020a1709027d8d00b001a647709860sm1736293plm.157.2023.04.20.19.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 19:51:23 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From:   Tejun Heo <tj@kernel.org>
To:     jiangshanlai@gmail.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        Tejun Heo <tj@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 18/22] net: qrtr: Use alloc_ordered_workqueue() to create ordered workqueues
Date:   Thu, 20 Apr 2023 16:50:42 -1000
Message-Id: <20230421025046.4008499-19-tj@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421025046.4008499-1-tj@kernel.org>
References: <20230421025046.4008499-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.40.0

