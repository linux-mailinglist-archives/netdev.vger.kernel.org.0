Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAADF6A5FB5
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 20:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjB1Tcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 14:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjB1Tcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 14:32:45 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B735733474;
        Tue, 28 Feb 2023 11:32:41 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id u20so6493321pfm.7;
        Tue, 28 Feb 2023 11:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O2L0ttHm+/TkRLQEPj0BgPCqHHA0WUnIL4IMzbCPwzE=;
        b=Iy8qB9Z1kMtM1MTX1VPnLNaFlrUc6GdkaN7+FaqLbVBAshZeC5lMkinzk9jp/i+4xV
         /0HIJghk4Z6ToOZa/my9BRFaxtaxBNWqpq9EPOsnwjI5D2XErj8gPuQzIBaByeJk/pZc
         HIh+8jJFGSGKcoMqon8vyVGX+n+0i5pLmoXktRoPm4Lx8tDBfPCV8W7mCuDsbwuT0nH1
         I2ZFICe3Axgto7u6Pk9uGMA4uUkTTN+Bh0l92pTX9MyESZR08kwH+XRwPs5DqlzAUy5Z
         ve3P2nIin6zzUcTVv9FaERrJbone9EzXD/im6+a5B1v2rx0PrdQ+RIu7ZJzqck45UvAX
         ZQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O2L0ttHm+/TkRLQEPj0BgPCqHHA0WUnIL4IMzbCPwzE=;
        b=wKL2wLdFP68fOKSylVVrISDvzXP2xq85Ylfl6VANg4VgP/ze/Ug3EtP35oO70n7ATc
         lpe0HpcyR6ele2M0RONp49u2ulwov7jLTBC8nGfRu1KUxOmsum3koIu+7bFm5IDH2yu2
         n3NIUR/OLO4fk2wtKLYihL1U46y2Z4psKKK+NpiV/gMYh1tOfI2UJCsTGCMzSKrziWsM
         SjALZ7o4ULPhjAm+8mEnaR9MPqtq5cJBF0oNiU6iGb2hagzsGobfBDcP0yIa0az6PM8Z
         YujpB9/w8vPSOmB5/8x6ARwLS5AYJKXXRyp8k1rSb9dpgH4M9LpLO5zwUO17dublSpFA
         XuOQ==
X-Gm-Message-State: AO0yUKUM8xrUMrPXdJjaDQ3w+3vOyQfzD71gBhgSOTShRknsdgL70R3G
        GBkqvu7zmendSMw5GhGwcaI=
X-Google-Smtp-Source: AK7set/NsBZzMwC2RvLZxEARHzT6MyElSzKxy1pIoxxyboLy/+ZTqbG9OrK5Zqf1B7ZEGWlp4iYhsg==
X-Received: by 2002:a62:79c5:0:b0:593:befd:848c with SMTP id u188-20020a6279c5000000b00593befd848cmr4419327pfc.16.1677612760805;
        Tue, 28 Feb 2023 11:32:40 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id c9-20020a637249000000b00502f20aa4desm6076987pgn.70.2023.02.28.11.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 11:32:39 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 28 Feb 2023 09:32:38 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 2/5] bpf: Mark cgroups and dfl_cgrp fields as
 trusted.
Message-ID: <Y/5W1ju2DfmaxCIB@slm.duckdns.org>
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
 <20230228040121.94253-3-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228040121.94253-3-alexei.starovoitov@gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 08:01:18PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> bpf programs sometimes do:
> bpf_cgrp_storage_get(&map, task->cgroups->dfl_cgrp, ...);
> It is safe to do, because cgroups->dfl_cgrp pointer is set diring init and
                                                              ^
							      u

> never changes. The task->cgroups is also never NULL. It is also set during init
> and will change when task switches cgroups. For any trusted task pointer
> dereference of cgroups and dfl_cgrp should yield trusted pointers. The verifier
> wasn't aware of this. Hence in gcc compiled kernels task->cgroups dereference
> was producing PTR_TO_BTF_ID without modifiers while in clang compiled kernels
> the verifier recognizes __rcu tag in cgroups field and produces
> PTR_TO_BTF_ID | MEM_RCU | MAYBE_NULL.
> Tag cgroups and dfl_cgrp as trusted to equalize clang and gcc behavior.
> When GCC supports btf_type_tag such tagging will done directly in the type.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
