Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BD66EA208
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbjDUCwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbjDUCvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:51:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7480172B8;
        Thu, 20 Apr 2023 19:51:26 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b4bf2d74aso1496422b3a.2;
        Thu, 20 Apr 2023 19:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682045486; x=1684637486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCIuGqiDIfKTQJqJOMYJZ+fdDTSyv1xrRS/ONUv2yRA=;
        b=gezxl302dxv42n+zCHus+E5E/8VfIO1QqtasOji91jFxm4HbDDyC/T8wrTYvihAkIV
         tAIybYBeQQ94t0LI8KHGbVzEDjpQQdu55bK1twCEYMc2yKVoEzj/S5YJlGc+cOK25kMR
         6WK7KlJ01Bhj8pv5zXg7vWs4gSLSaLVI1fgW3ZUPXlt9cpWfGRUvASCXkeiLL93vzvrl
         sEIvA1dtXYyriy0pzL0jk4esCON3xEefzhYJ1jRj4SAyw+6/GegiEDA20CNyY9yVD7oj
         RLJx8FdAVg9nv1XzlKVR7HQ77y9YPDxI/MnTdqsHS2CdSSbFBaRh46Z8Kf8/JRiWZPTJ
         JxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682045486; x=1684637486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iCIuGqiDIfKTQJqJOMYJZ+fdDTSyv1xrRS/ONUv2yRA=;
        b=k0BRzxzp/4BTcZnDIz2qHY70NWIy6HiPIjJd3N0fknhHjkszk5ZM4WefdD6PA7nFkC
         LbWVU9a6FPMnwhctzlpoxgh6fICp2RC95ZckSoI7Oef3rX5eH0TnW58sZl9DxUgLIK28
         ekvGUSwcw1iCZC23W0Ls0yBHDagV84gc1gEABl5fq8nfuJAl4cUgQdTpboI7elYjQayv
         MhLBTR79mdnFXY6Btw32T+9pkKDiHj7sy7bY05tsgOYPqhFmg6CDFTe6YWXIYko//9Fd
         gpslH7EqKy2nQpjn8TOvj6X+vGobRqzDxBy+0rwSjHaZjQ5rxG8theJPOV0C+4O7YYKS
         m8Gw==
X-Gm-Message-State: AAQBX9cXOBRquwUiVVoAqZHs3DhlIVcT2mDT9aE6dK5RhXjskID7MqU/
        ZXNwwRmFJSH3958VZdDOVdA=
X-Google-Smtp-Source: AKy350aBOJ7nhIIumms1QQ76eNdqaCc+JMXIPTzoicMoqIOcGFDp6SldY002aawpwXQfVP6C/Z0LVA==
X-Received: by 2002:a05:6a21:9011:b0:f0:69db:ebea with SMTP id tq17-20020a056a21901100b000f069dbebeamr4516265pzb.30.1682045485928;
        Thu, 20 Apr 2023 19:51:25 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id x125-20020a636383000000b00513ec871c01sm1701365pgb.16.2023.04.20.19.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 19:51:25 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From:   Tejun Heo <tj@kernel.org>
To:     jiangshanlai@gmail.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH 19/22] rxrpc: Use alloc_ordered_workqueue() to create ordered workqueues
Date:   Thu, 20 Apr 2023 16:50:43 -1000
Message-Id: <20230421025046.4008499-20-tj@kernel.org>
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
index 102f5cbff91a..e1822c12990d 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -972,7 +972,7 @@ static int __init af_rxrpc_init(void)
 		goto error_call_jar;
 	}
 
-	rxrpc_workqueue = alloc_workqueue("krxrpcd", WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+	rxrpc_workqueue = alloc_ordered_workqueue("krxrpcd", WQ_HIGHPRI | WQ_MEM_RECLAIM);
 	if (!rxrpc_workqueue) {
 		pr_notice("Failed to allocate work queue\n");
 		goto error_work_queue;
-- 
2.40.0

