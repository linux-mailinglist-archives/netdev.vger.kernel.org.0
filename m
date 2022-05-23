Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FB1531F36
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiEWX0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiEWX02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:26:28 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8968166F96;
        Mon, 23 May 2022 16:26:26 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id 68so9050890vse.11;
        Mon, 23 May 2022 16:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CZ7Bvz2UGyVwQOZNoDQxqJB4ctZcA6AKZ3k/mtWMH4g=;
        b=cKx/6qQgWDg31wde1pTQ6o5boMSF069ng8I6CLRVybr1xA/Fw02UBhJbDhDtjaeIKW
         rQFAIBZukrQcNcYYWRmJ0u//9UqY3hj2olDKzXqMY2KeUCU/bIKJ8eVpidMKwVo2flqV
         l5JLbo1VxoLM4dv8AR+PFaRbKULipBCo1CJ9fWstgxRgjANERjqAQJOE9DApHw+kHKxs
         FBwDeN6P0+vaI6kTcgzRCFkvdifaOXXHrlue+r8cct9Hvu85wzBOLUtj7BanQJRYtR7C
         mgF07SJwNN6uj6WFLOO2VQekDtRwvVjqtbBsLAdlNeaHH1Rc64gBI9lXg0rYoGLb/feV
         Qtvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CZ7Bvz2UGyVwQOZNoDQxqJB4ctZcA6AKZ3k/mtWMH4g=;
        b=Gmsms3LT+Nc0dWmr30A7fy2pYxbdhypC/kHi8qWxWK2bNPHuw7cozZhmiZk/+eHCfi
         sME7K+WDz5CMjg13L4uq4ttwIVEA4jZjUvHjJOvVHwPb0safc5vdWaiBGMDacQ5vsML+
         pNE65raWATUd2Vt2uAldaX0+pJ5lMv7tVaxvQY/VsNFdQL5wYRGs+pP6hybmCYx3bflJ
         McLML09TW89YvaYFWWYxsMFFNPFf4xMhR3m0r3kX074Kqr3wbBbB7wvKdKWuWbdiXhIo
         9N9PxnCEAcjDmMgRWM+9qGblHMWfo4JRu0NuBcxrvDn9bya/9wF5YLU6h6/gwgDtovGh
         AtdQ==
X-Gm-Message-State: AOAM533C7MQ4mX8jK7HQ/YmPtbYjfobeQ45ubhS/d3WMqkhA2vBXa9Mv
        LY/6FF9QLHPVVWGUoCjx3d4MKVIFcDpt1mbLVCs=
X-Google-Smtp-Source: ABdhPJxhY2Ye4o10ntHAGeMcm6K0eSKQPCWmJLCBj3BlcJ5QuakLDbLcAFgU4YFXZ24FpKZ5nQdt7iejyO3H166REUk=
X-Received: by 2002:a05:6102:370a:b0:333:c0e7:77e8 with SMTP id
 s10-20020a056102370a00b00333c0e777e8mr10000706vst.54.1653348385289; Mon, 23
 May 2022 16:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-9-sdf@google.com>
In-Reply-To: <20220518225531.558008-9-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 16:26:14 -0700
Message-ID: <CAEf4BzZEHfBbski189Qt2Lp4XOOxveRA07yjjPwVbpnQ-ggOew@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 08/11] libbpf: add lsm_cgoup_sock type
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 3:55 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> lsm_cgroup/ is the prefix for BPF_LSM_CGROUP.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ef7f302e542f..854449dcd072 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -9027,6 +9027,7 @@ static const struct bpf_sec_def section_defs[] = {
>         SEC_DEF("fmod_ret.s+",          TRACING, BPF_MODIFY_RETURN, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_trace),
>         SEC_DEF("fexit.s+",             TRACING, BPF_TRACE_FEXIT, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_trace),
>         SEC_DEF("freplace+",            EXT, 0, SEC_ATTACH_BTF, attach_trace),
> +       SEC_DEF("lsm_cgroup+",          LSM, BPF_LSM_CGROUP, SEC_ATTACH_BTF),

we don't do simplistic prefix match anymore, so this doesn't have to
go before lsm+ (we do prefix match only for legacy SEC_SLOPPY cases).
So total nit (but wanted to dispel preconception that we need to avoid
subprefix matches), I'd put this after lsm+


>         SEC_DEF("lsm+",                 LSM, BPF_LSM_MAC, SEC_ATTACH_BTF, attach_lsm),
>         SEC_DEF("lsm.s+",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
>         SEC_DEF("iter+",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
> @@ -9450,6 +9451,7 @@ void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
>                 *kind = BTF_KIND_TYPEDEF;
>                 break;
>         case BPF_LSM_MAC:
> +       case BPF_LSM_CGROUP:
>                 *prefix = BTF_LSM_PREFIX;
>                 *kind = BTF_KIND_FUNC;
>                 break;
> --
> 2.36.1.124.g0e6072fb45-goog
>
