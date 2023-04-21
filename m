Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D466EA1F0
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbjDUCvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbjDUCvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:51:13 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B45576B8;
        Thu, 20 Apr 2023 19:51:08 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b4dfead1bso1584816b3a.3;
        Thu, 20 Apr 2023 19:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682045468; x=1684637468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vXy2LlryeqFYuG6VIcWnTi0Y22Hml5WbUl7g3QZBsxI=;
        b=DNXPUdu3So6Ly099msBkeS7QG2IIR0hElah4MDZwf8MWR1gh2Qq/qQbimHClsh938b
         823fOETKFYsI5gKPXdc5lvyzkHjWyvJxTZM7XPzbXB8kMGcGMUJpUgIL0LfhkKobISuC
         OA5UP91DpFYekIyJbBQshJbMEeWYiJhA0onfRS4M+Y8wioMvq6Cx+cres2NEdLWHpDdr
         8A9XAwa0cIu9GLFDCoRmnhNGnjNQJTgvHNQAAR9V8t1ZQomU3z7aYsnBlQSuk+QFicie
         YA64dM6wNqV6F4c3hHdtw1bllG2Zwd0XCD3/VoVVN+drc4zNkIsTdTgQXJ03D1fM5dCf
         usPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682045468; x=1684637468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vXy2LlryeqFYuG6VIcWnTi0Y22Hml5WbUl7g3QZBsxI=;
        b=a2+60fq2LfuQvHrJsd3e9WDOhW6wLAdgABo4UVaboNY0IwZvWxZukHtXkgrFWxVbtr
         oTFgk/JPA3/MbWLEHkxW/YG17dc8biq6IohSRO79BwWqe5CuetfYZkexscuNnX2IIPXx
         qrpvBJgWx8IrN5Avzy4h2dyMQ65nX0CsKKQQ5MJtMhIL/+lF9pcV7uBMRA1dbqUGvtZX
         BCGgTopsVSw8wflk0DmP1F+6DPvN+Rb//+8foCORlDbJsyqTtSUZkNPgjmUeqVfPwjjn
         qI0jHWQyM49UBodvHaD1GyIxLlnDbQcZ7SKQJ7q0Zw9HoKRXkOxwP2cnKYvzg/lorDJJ
         cHPQ==
X-Gm-Message-State: AAQBX9dXOgfv4ioUH96EZEcfyMrYwWIJ53j7ievMbYhnoqID7mnx1QOw
        /LZhndiZeaxDjjyoF40h8CU=
X-Google-Smtp-Source: AKy350YiGBh1kzca9HUbkPPfun9iKHT605jECnArxYVlQeqJ+qB/AWk8NZ5gxhWAeNluLohvMkKHXw==
X-Received: by 2002:a05:6a20:a1a0:b0:de:247e:d1fe with SMTP id r32-20020a056a20a1a000b000de247ed1femr3442160pzk.1.1682045467914;
        Thu, 20 Apr 2023 19:51:07 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id o64-20020a62cd43000000b0063d642dcd12sm1972276pfg.16.2023.04.20.19.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 19:51:07 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From:   Tejun Heo <tj@kernel.org>
To:     jiangshanlai@gmail.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        Tejun Heo <tj@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        "Haim, Dreyfuss" <haim.dreyfuss@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 09/22] wifi: iwlwifi: Use alloc_ordered_workqueue() to create ordered workqueues
Date:   Thu, 20 Apr 2023 16:50:33 -1000
Message-Id: <20230421025046.4008499-10-tj@kernel.org>
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
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Avraham Stern <avraham.stern@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mordechay Goodstein <mordechay.goodstein@intel.com>
Cc: "Haim, Dreyfuss" <haim.dreyfuss@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 0a9af1ad1f20..cd17b601b172 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3576,8 +3576,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	init_waitqueue_head(&trans_pcie->fw_reset_waitq);
 	init_waitqueue_head(&trans_pcie->imr_waitq);
 
-	trans_pcie->rba.alloc_wq = alloc_workqueue("rb_allocator",
-						   WQ_HIGHPRI | WQ_UNBOUND, 1);
+	trans_pcie->rba.alloc_wq = alloc_ordered_workqueue("rb_allocator",
+							   WQ_HIGHPRI);
 	if (!trans_pcie->rba.alloc_wq) {
 		ret = -ENOMEM;
 		goto out_free_trans;
-- 
2.40.0

