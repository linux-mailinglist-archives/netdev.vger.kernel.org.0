Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E005653D33D
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 23:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346482AbiFCVbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 17:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbiFCVa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 17:30:59 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508EA38BE5;
        Fri,  3 Jun 2022 14:30:58 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id l30so14527646lfj.3;
        Fri, 03 Jun 2022 14:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5/2T3P0ZiupSWsrUP0xa/9587MGNTDXqll1NTZ+aZdo=;
        b=Lf+Kp8EJZJJIBxjmB7FVWwy/l0qRUVlcNFdcLxc92vGELD0XSoerbHE7PDXmeLOWL4
         P/JEcGHKgstyqePRe/yEhBYBDqomW65uewyUDTnCz63S0+0pxziGGvvX0bXDpQVXS8ia
         6DX2XLBP+IegZIJj3C0Z6nfyMjiRoDC5MA6X33sbTQt4ATtAIRE9jLL7xQmGiugE99lP
         3VpZXYhFtlYU3dVNTuVbKQpYPGSFedF52GE0DXAxJdzC6qcmDC48YYucxdOi+kaiW/RG
         ls80bfWAnnpQVkLiNGbjGu+7lK3QL98KVPp6hyYa+jsW35M2jzS46oVOOM6AzhAZ1qpt
         lNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5/2T3P0ZiupSWsrUP0xa/9587MGNTDXqll1NTZ+aZdo=;
        b=iCFFqGNzWJlO5XAra6kCWWnnhTAC+WLEiFHb5AtAQybhY5bqJad9duSMv1LVuUgj4o
         rAxhYkjo4SHAUlgb1uS2kPUh5RnscuCUGX+czO79utIu+QLOeo/o6LYEh55g+zsGKiKG
         EXD5GwfpkW6GHKLov0c0NuCUhEek2jhP9EEoSj/8V+O3hwv1dKN7VoRwldx/KLCzJxFE
         WE87M1+caw0voeizGKsXiZBF3VqWkrjN+6KUz3/YD1WRMcaohJnr6b0oiqw8aAcjF+kk
         iOfMCn8Y/QkmOYW/ohXkKunsZtnPMauWQqSDRzzg62KxwfojH+5RoBq5DwUdDgJXNTxZ
         pGtQ==
X-Gm-Message-State: AOAM533AKK/zq01bffKpFcciKYDIh3lWivdCKTRDg1c3qmYowLphy32A
        gAcHhuoNDPcqstuqNpQTG2mcQwnoZHRpKOGkHXqS5n8Kzmw=
X-Google-Smtp-Source: ABdhPJzZdJz/yoFUqVp9xzrNB8TMWtBZplBN1hFdIHTVRJzJOFdP/h+2jeRBBkb9PCJX1nkgCE1XbZaczOy058CKzvI=
X-Received: by 2002:a05:6512:1398:b0:448:bda0:99f2 with SMTP id
 p24-20020a056512139800b00448bda099f2mr54765221lfa.681.1654291856678; Fri, 03
 Jun 2022 14:30:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com> <20220601190218.2494963-8-sdf@google.com>
In-Reply-To: <20220601190218.2494963-8-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 14:30:45 -0700
Message-ID: <CAEf4BzZW_xFWVU0_VFsov+xo7i5i0SnC+_Ciy1vTHU97KT-+cQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 07/11] libbpf: add lsm_cgoup_sock type
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

On Wed, Jun 1, 2022 at 12:02 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> lsm_cgroup/ is the prefix for BPF_LSM_CGROUP.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 5afe4cbd684f..a4209a1ad02f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -107,6 +107,7 @@ static const char * const attach_type_name[] = {
>         [BPF_TRACE_FEXIT]               = "trace_fexit",
>         [BPF_MODIFY_RETURN]             = "modify_return",
>         [BPF_LSM_MAC]                   = "lsm_mac",
> +       [BPF_LSM_CGROUP]                = "lsm_cgroup",
>         [BPF_SK_LOOKUP]                 = "sk_lookup",
>         [BPF_TRACE_ITER]                = "trace_iter",
>         [BPF_XDP_DEVMAP]                = "xdp_devmap",
> @@ -9157,6 +9158,7 @@ static const struct bpf_sec_def section_defs[] = {
>         SEC_DEF("freplace+",            EXT, 0, SEC_ATTACH_BTF, attach_trace),
>         SEC_DEF("lsm+",                 LSM, BPF_LSM_MAC, SEC_ATTACH_BTF, attach_lsm),
>         SEC_DEF("lsm.s+",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
> +       SEC_DEF("lsm_cgroup+",          LSM, BPF_LSM_CGROUP, SEC_ATTACH_BTF),
>         SEC_DEF("iter+",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
>         SEC_DEF("iter.s+",              TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_iter),
>         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> @@ -9610,6 +9612,7 @@ void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
>                 *kind = BTF_KIND_TYPEDEF;
>                 break;
>         case BPF_LSM_MAC:
> +       case BPF_LSM_CGROUP:
>                 *prefix = BTF_LSM_PREFIX;
>                 *kind = BTF_KIND_FUNC;
>                 break;
> --
> 2.36.1.255.ge46751e96f-goog
>
