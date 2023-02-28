Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871D96A5FD2
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 20:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjB1Tjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 14:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjB1Tjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 14:39:35 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01DF34F66;
        Tue, 28 Feb 2023 11:39:22 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id z10so6353781pgr.8;
        Tue, 28 Feb 2023 11:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=opeBF3pAbytFzHeDJjyX+93c1jspBN+cmhhKcJuerEE=;
        b=e0zvJrjyAu0NnN7Ohm4W1bUswGWfzjBMpdNamloGQ/1mkvhKODmj76Kjg6o0gy8EyK
         ZhkIK0mEprcWVRcDpF2GNxLs8jX/0O8UZ3XY4hxAKQujLQa4VJiCFwJhv0z0AoJ1eIsj
         3kJ9dW5JjjcL1Z+A9Onn9aF7ZSrl7ejc4vrCC4aVSPdofKku+crISEVIr20e6TS3wI6T
         OCyDhqLpPJz7zieaLdGpogPLuyvm5Ze7w+OjJg4eD5uLX9GoP/pijarMoPFj7X+/aSwW
         Z1Cc2KMWlIdkQy9flR2YfXkKeZi7OedV3FjxVwLMtFtFYZKGJTdVIRxc5s7LmgkbxLDm
         3DCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=opeBF3pAbytFzHeDJjyX+93c1jspBN+cmhhKcJuerEE=;
        b=MPN86Ufdc78ivf+5xP1YQ7WFl+PJp8YuImpJObc9i/D+8Rzf7Cf22ODsKlkGcOPMym
         /oI63ve9VPEHFfMfDTnTxEDgCBqByQUX39/1MpTIf6ksIcauHRl8J5jSHWI/RQhtQg3I
         RO3B6v7V7O1HhhMxdBa1wc+3/4Y9jwbrxK/3e2Yp91PdARVtTGVud9dHxiEu5s+Hh47X
         Y4qjtFQuk1JhzaagLrkRa24//w7XuvOFZWd7uQwXAVCQAglAVjAEUk7q4mTGil65R6lq
         wAVRFDBlT1KGQcP/EvHHKOxo07aHMy8b9J03UTaoG1f53EnJ9RSQ8yyxgUQwczDC85Ou
         MmSA==
X-Gm-Message-State: AO0yUKWf/ZMN1CVjXLqw5ibgjbT2QXdJpDkip7XoMNjZZs3OXLUI+fnX
        p2t6kDo3W6hT5Znx9rUclx0=
X-Google-Smtp-Source: AK7set9LLme16wQkBqHA50rGtrtm6cKUt/dNxstpNq0bUKqja7YYOtfNf8FGWsOnwHNMo++ZarEZlg==
X-Received: by 2002:aa7:9607:0:b0:5e0:c59f:b008 with SMTP id q7-20020aa79607000000b005e0c59fb008mr1125733pfg.4.1677613162234;
        Tue, 28 Feb 2023 11:39:22 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id u1-20020aa78381000000b005cd81a74821sm6369156pfm.152.2023.02.28.11.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 11:39:21 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 28 Feb 2023 09:39:19 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 3/5] bpf: Introduce kptr_rcu.
Message-ID: <Y/5YZ4LR5ZTLUATc@slm.duckdns.org>
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
 <20230228040121.94253-4-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228040121.94253-4-alexei.starovoitov@gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 08:01:19PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The life time of certain kernel structures like 'struct cgroup' is protected by RCU.
> Hence it's safe to dereference them directly from __kptr tagged pointers in bpf maps.
> The resulting pointer is MEM_RCU and can be passed to kfuncs that expect KF_RCU.
> Derefrence of other kptr-s returns PTR_UNTRUSTED.
> 
> For example:
> struct map_value {
>    struct cgroup __kptr *cgrp;
> };
> 
> SEC("tp_btf/cgroup_mkdir")
> int BPF_PROG(test_cgrp_get_ancestors, struct cgroup *cgrp_arg, const char *path)
> {
>   struct cgroup *cg, *cg2;
> 
>   cg = bpf_cgroup_acquire(cgrp_arg); // cg is PTR_TRUSTED and ref_obj_id > 0
>   bpf_kptr_xchg(&v->cgrp, cg);
> 
>   cg2 = v->cgrp; // This is new feature introduced by this patch.
>   // cg2 is PTR_MAYBE_NULL | MEM_RCU.
>   // When cg2 != NULL, it's a valid cgroup, but its percpu_ref could be zero
> 
>   bpf_cgroup_ancestor(cg2, level); // safe to do.
> }
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

From cgroup POV:

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
