Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF9E61A3BC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiKDV44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiKDV4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:56:55 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF71359FCB;
        Fri,  4 Nov 2022 14:56:54 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id y14so16619863ejd.9;
        Fri, 04 Nov 2022 14:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4lxURksHj3T3+DcMA1c6SDe+tyv9on8orkNxxpF1wpw=;
        b=l0krgcQ1x+QyVprsYS3e+Ksm4+O/J8WaR2uV6+jmasJviwEA3s2GkMc63/xsHLjn7v
         ixmrS6jsmrwUnuUdjE8GWaqkURtfAIBNCCDsOAH5yvj37AORMKhnXUlwGDLLishrkEap
         hrZHKLTqYnAaRNKiwshxZEHjqjx5LSXqF3INh9C2ED0eTg/NncG5b8HIHoQNzr8f7MXo
         lpHeaInkAo6UuVIdtSENIfi06o7QZxPQNsBAr4SfuN6j4EXeoA9ICcz0/c7FLMEIYK+3
         khdW04Rm0KbzqigAluLFYkZG4vif9LQdMRDGfoQzFNW3uBAQJcLVelIpU8Z9vNHcFGmw
         F7PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4lxURksHj3T3+DcMA1c6SDe+tyv9on8orkNxxpF1wpw=;
        b=s19UwLSENXQF4FoGFDrZAFymyExVHsZAmUN4XTI773aInZYFTxQF/RDCKBTat9Cn+P
         k11B2wrQmZIIeRLSPy4FLiEf0Emvv1BO1du9cEFAqc/ojJ5jl8No5bjx2I5NOTXFSlTJ
         8AH/rGPZnB6oDpOe8YAxqTu6zKi+CQxlQy8/o7mnaq5n3vNd2I78orw8+/NkK1Ix949/
         izf4xzQTjeR58LkDXOXPmIm1/Gk2l05QzQv5rBFbUeDc+5ylbp1dFCQzeoRIKkaYUtSY
         QiX3sS5FcJLQZu4SDXXiVMOFeYzaMknyautP/1NiKIHNUqtI3PWShAU/moV6o0VYsNxL
         lRng==
X-Gm-Message-State: ACrzQf1ZwHhwXxnp6Q5066fm+1XrYgMNHqkm8GQEO3mayw3q+yTltVK0
        W/pA5HuDtucEMu78IXEwcvCfFvnUfet1+1MB9OI=
X-Google-Smtp-Source: AMsMyM7L6eNb0nhcMUMgqoe134AW/LDinI4BWgMVWvwPF3qBv3jLgKkauI5+9B9OECRCQCMH3pk11ofWlwIrl3aIwno=
X-Received: by 2002:a17:906:11d6:b0:7ad:fd3e:2a01 with SMTP id
 o22-20020a17090611d600b007adfd3e2a01mr17227919eja.545.1667599013262; Fri, 04
 Nov 2022 14:56:53 -0700 (PDT)
MIME-Version: 1.0
References: <20221103083254.237646-1-yangjihong1@huawei.com> <20221103083254.237646-3-yangjihong1@huawei.com>
In-Reply-To: <20221103083254.237646-3-yangjihong1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Nov 2022 14:56:40 -0700
Message-ID: <CAEf4BzY+qP1wwVddjg7_rypcUAW8iPRzSa=1O6aFG5dSLX+1Gg@mail.gmail.com>
Subject: Re: [PATCH 2/4] bpf: Remove size check for sk in bpf_skb_is_valid_access
 for 32-bit architecture
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, illusionist.neo@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, benjamin.tissoires@redhat.com, memxor@gmail.com,
        delyank@fb.com, asavkov@redhat.com, colin.i.king@gmail.com,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 1:36 AM Yang Jihong <yangjihong1@huawei.com> wrote:
>
> The error code -EACCES is returned when bpf prog is tested in 32-bit environment,
> This is because bpf_object__relocate modifies the instruction to change memory
> size to 4 bytes, as shown in the following messages:
>
> libbpf: prog 'kfunc_call_test1': relo #2: matching candidate #0 <byte_off> [18342] struct __sk_buff.sk (0:30:0 @ offset 168)
> libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) off 168 -> 168
> libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) mem_sz 8 -> 4
>
> As a result, the bpf_skb_is_valid_access check fails. For 32-bit architecture,
> unnecessary checks need to be deleted.
>
> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> ---
>  net/core/filter.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index bb0136e7a8e4..eab7ce89740c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8269,8 +8269,6 @@ static bool bpf_skb_is_valid_access(int off, int size, enum bpf_access_type type
>                         return false;
>                 break;
>         case offsetof(struct __sk_buff, sk):
> -               if (type == BPF_WRITE || size != sizeof(__u64))
> -                       return false;

this probably should be specific to host architecture bitness? I'd
imagine that size = 4 should be invalid on 64-bit arches (reading half
of the pointer is bad)

either way, please make sure to add tests specifically for this case
in test_verifier



>                 info->reg_type = PTR_TO_SOCK_COMMON_OR_NULL;
>                 break;
>         case offsetof(struct __sk_buff, tstamp_type):
> --
> 2.30.GIT
>
