Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A516EA1E9
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbjDUCvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbjDUCvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:51:11 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF9A72B6;
        Thu, 20 Apr 2023 19:51:02 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63b5c48ea09so1600864b3a.1;
        Thu, 20 Apr 2023 19:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682045462; x=1684637462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34/Qii7FhGNnTA9R8bpTQlpj4RZtJcqmBQ/JN/Zhs64=;
        b=rloF2mVAYBrDqM/6XuYQZv7gDt2EIV8lhLGgEEJ3aoXgc0Wvlus+anMCNBx6PUd0+k
         HQ/kOTFvj3/q6z85JtIlfUU1j5z/ZAJb1YnJW+JewjxZYuQ9kGRTHS0ZaV4/9UqSTjKI
         QLjvN+BgQzSGhKEztoAQ1YtgyBnLS5Wv1sOGtn0cPnlrfmm809JWs4QNV1B/DookEJq6
         T9ZRYKVAVUELaRb+Bcp/Rx2wIDO8bd210XgXcNEYG9OV/dX2QvYlUyALg25HkejBfB3w
         bsGYcbipu6KkSio+dJCNrD0lXpUWNTwNW6g5iTJ4+ar3ZmOFXg72Yqbx5uUpF3uQrVEH
         vY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682045462; x=1684637462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=34/Qii7FhGNnTA9R8bpTQlpj4RZtJcqmBQ/JN/Zhs64=;
        b=MX1FnsfEI8JOCDxvS0Lggm7r6at/QHp2e1f1jZy8dXeorr9RX3H5CZp2+Dd9wBmRY5
         Tm9/3tjfi+P5yYvujjIIbGBSIfuaMJnrArXkl/9INbnoVmCrt+tuKawluCxZZgGiIytc
         ypgzp/jQ9BeWGVJjD2S8EJhPPgtRHWVKbyzC8oBgSjSjEsDIsobaDlQhX+mgTWwBU5gk
         AFCLnVnzo2wzTR5IkmJD2bWzOZjxYn7wnZO/alAm8iBJCPgHjomQrcSO2TT0t02DXmV3
         U47arc9tHdQFV1a4qtvznJfOKuqCAX4fEqNI8zu5PAAMrlza5fMzP0CmmX+8uJbnMWb+
         1T1Q==
X-Gm-Message-State: AAQBX9dWFeRt+ljUfUyattLGMLiD3yNkevskQfN/toYMIfrjjZlxIGQ7
        07Gq616o+QrvNPK0mM0FjCE=
X-Google-Smtp-Source: AKy350Yn90TexflSL5xc7ZrsTa6Anc/kqV6Sh8SIc6wqmavXZKkrA+mOseiosddYVVGPcr8lUAoyRg==
X-Received: by 2002:a05:6a21:6817:b0:f0:164b:fa5d with SMTP id wr23-20020a056a21681700b000f0164bfa5dmr4235235pzb.15.1682045462096;
        Thu, 20 Apr 2023 19:51:02 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id z12-20020a63c04c000000b0050f74d435e6sm1676172pgi.18.2023.04.20.19.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 19:51:01 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From:   Tejun Heo <tj@kernel.org>
To:     jiangshanlai@gmail.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        Tejun Heo <tj@kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH 06/22] net: thunderx: Use alloc_ordered_workqueue() to create ordered workqueues
Date:   Thu, 20 Apr 2023 16:50:30 -1000
Message-Id: <20230421025046.4008499-7-tj@kernel.org>
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
Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index 7eb2ddbe9bad..a317feb8decb 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1126,8 +1126,7 @@ static int bgx_lmac_enable(struct bgx *bgx, u8 lmacid)
 	}
 
 poll:
-	lmac->check_link = alloc_workqueue("check_link", WQ_UNBOUND |
-					   WQ_MEM_RECLAIM, 1);
+	lmac->check_link = alloc_ordered_workqueue("check_link", WQ_MEM_RECLAIM);
 	if (!lmac->check_link)
 		return -ENOMEM;
 	INIT_DELAYED_WORK(&lmac->dwork, bgx_poll_for_link);
-- 
2.40.0

