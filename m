Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88BC4AC924
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbiBGTDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbiBGS7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:59:37 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0830C0401DA;
        Mon,  7 Feb 2022 10:59:36 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id h11so3765908ilq.9;
        Mon, 07 Feb 2022 10:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7jtyMgwW9BiDXzVcsfLl4AZbikM19XjQ9hiGnvokWMA=;
        b=CiRHBjQtNzSnZEJcfHoXO90rUIjdZIEt79PeC16IliCiyQMzsQDTJ1TMwy+l2gMlQk
         wZRTJ0z4EvVMyeqnoovxpia5LFqoMoGQB2zSVQIok4GjJIsUEEOUmKdNAbDfyE3SjgfN
         jILi46aTquk55TXGAFF9xEu0wK33RYQe1qTV/A5xJfqqQ12RqozgFYDUMA0Jo+zeu9LV
         uvpPvs9GC2MIIFkZyteMAFfEJnV+0NCA7PXVu1WtCloMc2y2ru7XPqip5V8X2RR72bSC
         JMC70FKeV2CLDRRGxclfmfn6RG2JVDMdab/wKuoSNdvXFMbns4zkkXrx+E9noLM71Gip
         vkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7jtyMgwW9BiDXzVcsfLl4AZbikM19XjQ9hiGnvokWMA=;
        b=yRNWyyTRpzQNkuC002hj7U4m+0Iu2Mc61hHfDcWP7S/dMf1gFZ1hUWW7i9GRUaNnUQ
         fZLQB+vHCP7RZYw+iFf2xHZ9zc3kIZ1eqDCTBKgVTi93YVAih9tHYT0VV7mxxtjnhLGD
         8/61hBGRoI3sg3Ow6/Dx2KIm6y/jL0KLu5mn7H1voNoASbzMzPZav8GyvcwKjg3zf6zs
         n/zo4ZQJ6SMBGNXx/2BKKdRPXjYiiC1a/P0nypGlfJeD+PrGUAFobn631tUOFDdGw+tv
         f4Axkydr4TATfhp9Q7XhVjDKAVz4SUbSw5KU3U8KeIN9CLm1+COXFKVmVQkrTieAvhel
         FJTQ==
X-Gm-Message-State: AOAM532l/LSxYwyG7jz+++uT9fBSfNoWsH7C5GpRPljMqwaYQOF612xw
        K3pxzzVYLFq2dqeboLogqgur8SPC3VYezSt0RN8=
X-Google-Smtp-Source: ABdhPJwYfppWqQ9/Arjpc9tSAe6UgTK5qfoR/AfBjDbOqCN6Al5XY2Rr0djgd1iPl8uKn/aH20YRf7rotF2vgUbsuj4=
X-Received: by 2002:a05:6e02:1b81:: with SMTP id h1mr453086ili.239.1644260376142;
 Mon, 07 Feb 2022 10:59:36 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <20220202135333.190761-5-jolsa@kernel.org>
In-Reply-To: <20220202135333.190761-5-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Feb 2022 10:59:24 -0800
Message-ID: <CAEf4Bzaj3x8K6VA5FgkYbbAWz2vtBwyepbpe-np30pYD1m22gQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] libbpf: Add libbpf__kallsyms_parse function
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
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

On Wed, Feb 2, 2022 at 5:54 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Move the kallsyms parsing in internal libbpf__kallsyms_parse
> function, so it can be used from other places.
>
> It will be used in following changes.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c          | 62 ++++++++++++++++++++-------------
>  tools/lib/bpf/libbpf_internal.h |  5 +++
>  2 files changed, 43 insertions(+), 24 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 1b0936b016d9..7d595cfd03bc 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7165,12 +7165,10 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
>         return 0;
>  }
>
> -static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
> +int libbpf__kallsyms_parse(void *arg, kallsyms_cb_t cb)

please call it libbpf_kallsyms_parse(), internal APIs don't use
"object oriented" double underscore separator

also this "arg" is normally called "ctx" in similar APIs in libbpf and
is passed the last, can you please adjust all that for consistency?

>  {
>         char sym_type, sym_name[500];
>         unsigned long long sym_addr;
> -       const struct btf_type *t;
> -       struct extern_desc *ext;
>         int ret, err = 0;
>         FILE *f;
>

[...]
