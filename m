Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33734CE188
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiCEAcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiCEAcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:32:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9BECE91E;
        Fri,  4 Mar 2022 16:31:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E941C61F4A;
        Sat,  5 Mar 2022 00:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54163C340F0;
        Sat,  5 Mar 2022 00:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646440284;
        bh=awRIwbysAAAcaXhf9r6G70yV9eNUMtyfdpt6cG+WdS4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NFihrsXcizDRGkyxR3Cg8awQAmkhhYtn0duiPuoXhota0ipzzUhn0yIn1mBzEff/z
         lYSENiDeC1aSvAozEsWcLonBQoLmwjVnsusZmchqpphq73olCMv8xLDYP3QBOefsMZ
         MAbKYdMeDjdCecydm+LAf7EnOwEE2BIoIB1d7q7mZ+03q3qGfKoPAAM5YEF+URMYEu
         eDh9hcN5B+BgMM42Zf8YyBIekByZ7I0WQEvhF3HEU/GAONPC+qkgVlTqicNjptUXkx
         lnbaxgOJWuAM4jKtf5q98skl8kVSVfV/UFjSL5U6MnfPgtguZC1hA1eBwugEgEfK2a
         Ha+p1aGLhWxmg==
Received: by mail-yb1-f182.google.com with SMTP id u10so237377ybd.9;
        Fri, 04 Mar 2022 16:31:24 -0800 (PST)
X-Gm-Message-State: AOAM532hF4FQd+XySXHlgCbIMUMbQctUrbc0ehJa/S6UcmQyDpccTJmP
        aEoY6GGCmJIP9sVwG8GgCjYml/DJ6FA1RHGcCUc=
X-Google-Smtp-Source: ABdhPJwBFO65kWq2rI3Da1Dusm/a5tFW4fIDNdvUf2aQDb/11b8ll7yQ8fxaG8oivNovon9SFOEepuumfAFj9I22pOY=
X-Received: by 2002:a05:6902:1ca:b0:624:e2a1:2856 with SMTP id
 u10-20020a05690201ca00b00624e2a12856mr946847ybh.389.1646440283308; Fri, 04
 Mar 2022 16:31:23 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com> <20220304172852.274126-5-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-5-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 4 Mar 2022 16:31:12 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5BtN6_x1pz1rZ-q5bF6P3XGzvp2maFiXiqSemdTC9jZw@mail.gmail.com>
Message-ID: <CAPhsuW5BtN6_x1pz1rZ-q5bF6P3XGzvp2maFiXiqSemdTC9jZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/28] libbpf: add HID program type and API
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 9:31 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> HID-bpf program type are needing a new SEC.
> To bind a hid-bpf program, we can rely on bpf_program__attach_fd()
> so export a new function to the API.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Song Liu <songliubraving@fb.com>

>
> ---
>
> changes in v2:
> - split the series by bpf/libbpf/hid/selftests and samples
> ---
>  tools/lib/bpf/libbpf.c   | 7 +++++++
>  tools/lib/bpf/libbpf.h   | 2 ++
>  tools/lib/bpf/libbpf.map | 1 +
>  3 files changed, 10 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 81bf01d67671..356bbd3ad2c7 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8680,6 +8680,7 @@ static const struct bpf_sec_def section_defs[] = {
>         SEC_DEF("cgroup/setsockopt",    CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
>         SEC_DEF("struct_ops+",          STRUCT_OPS, 0, SEC_NONE),
>         SEC_DEF("sk_lookup",            SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
> +       SEC_DEF("hid/device_event",     HID, BPF_HID_DEVICE_EVENT, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
>  };
>
>  #define MAX_TYPE_NAME_SIZE 32
> @@ -10659,6 +10660,12 @@ static struct bpf_link *attach_iter(const struct bpf_program *prog, long cookie)
>         return bpf_program__attach_iter(prog, NULL);
>  }
>
> +struct bpf_link *
> +bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd)
> +{
> +       return bpf_program__attach_fd(prog, hid_fd, 0, "hid");
> +}
> +
>  struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
>  {
>         if (!prog->sec_def || !prog->sec_def->attach_fn)
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index c8d8daad212e..f677ac0a9ede 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -529,6 +529,8 @@ struct bpf_iter_attach_opts {
>  LIBBPF_API struct bpf_link *
>  bpf_program__attach_iter(const struct bpf_program *prog,
>                          const struct bpf_iter_attach_opts *opts);
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd);
>
>  /*
>   * Libbpf allows callers to adjust BPF programs before being loaded
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 47e70c9058d9..fdc6fa743953 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -424,6 +424,7 @@ LIBBPF_0.6.0 {
>  LIBBPF_0.7.0 {
>         global:
>                 bpf_btf_load;
> +               bpf_program__attach_hid;
>                 bpf_program__expected_attach_type;
>                 bpf_program__log_buf;
>                 bpf_program__log_level;
> --
> 2.35.1
>
