Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F155358D026
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 00:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbiHHWdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 18:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238925AbiHHWd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 18:33:29 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A352193F2;
        Mon,  8 Aug 2022 15:33:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y13so19088015ejp.13;
        Mon, 08 Aug 2022 15:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=KMXQ/Pwj7yDaZ7TRzg/t/aATv4ZfeHOhQlXQrMZVKBA=;
        b=j3sZULbKIqIZbAamBjBRRR39xeiXXPQsf+PI6szKCszlTfbUArigeAIlyNbwu12Fs7
         No1RdPepj/Xljl5HxmR60rMWgizu3kCwnM2SdQv2nkYbVGBNj2Lx9K8R21qfcon37j43
         Shnhrj/VeXJRQMHkPr5tVXOLTTypCbSyKR2nHjvtkWuHLf/G7HfEZSJy6edK6vmmJzn2
         kbhsQXtcc4OZoZEiknGUjoA20qlsKlyY7yA0NV2G0ryxzzHdxbs3TofiAK/+BI/nv7M4
         HiRLT6L5feNATp/4R9wSWGwPUOM9U1cxk1GvZiC/KEzUdwdurnr1iuLKn32jSKFLJINX
         1mfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KMXQ/Pwj7yDaZ7TRzg/t/aATv4ZfeHOhQlXQrMZVKBA=;
        b=5pQYlkt+QBMYzRN2uJYqHa14HI2/muCQglv+yJQM4Xmu8JOwkKVtF9HvU0SQlAbBRD
         DBajtseTPcmoTGD/a58DzINoAZPq2J7l9r41GguX1y+3P4N5Jti+S/NDyTFZMIF1UrPz
         iDuc9mAcugfawOTa5fmrWHcCyDaAU2DnlsBiaCoRdQ3n7oCLVM7ufTE2oR+CBNPJH/+y
         6aXRLSqoDcnMiq6fIlEN3DHVjiZd1YsRpekcVqrzxtHnKibKWL+LOfTu32Sbln2lZuIz
         GkbA2dhH55Yu+9WVNUX+5npHdueeH0/1YGrveKgw9STrFNY24vsCXo8qFSf1YYLQiEbM
         PtQw==
X-Gm-Message-State: ACgBeo1oJkD0klqGfPppWR6hZ8NOC/d7jzrfXjGE79ouze0o3RS63EHn
        VGF5pxpgT4dCgyUveq4XeGu/uyZXWOXyxsNSe6o=
X-Google-Smtp-Source: AA6agR5QhVsszhSijvfbG8Fw8DLy0BZulXTgtsciGWMcGiEwJkfX5R28DfJEKhIA7I4EMnfxmSWPK0qKnhBU9WxskiQ=
X-Received: by 2002:a17:907:6e22:b0:731:152:2504 with SMTP id
 sd34-20020a1709076e2200b0073101522504mr11517720ejc.545.1659998006964; Mon, 08
 Aug 2022 15:33:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220808093304.46291-1-liuhangbin@gmail.com>
In-Reply-To: <20220808093304.46291-1-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Aug 2022 15:33:15 -0700
Message-ID: <CAEf4BzYL1TQwo1231s83pjTdFPk9XWWhfZC5=KzkU-VO0k=0Ug@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: try to add a name for bpftool
 self-created maps
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org
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

On Mon, Aug 8, 2022 at 2:33 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> As discussed before[1], the bpftool self-created maps can appear in final
> map show output due to deferred removal in kernel. These maps don't have
> a name, which would make users confused about where it comes from.
>
> Adding names for these maps could make users know what these maps used for.
> It also could make some tests (like test_offload.py, which skip base maps
> without names as a workaround) filter them out.
>
> As Quentin suggested, add a small wrapper to fall back with no name
> if kernel is not supported.
>
> [1] https://lore.kernel.org/bpf/CAEf4BzY66WPKQbDe74AKZ6nFtZjq5e+G3Ji2egcVytB9R6_sGQ@mail.gmail.com/
>
> Suggested-by: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
>

Hm... this is pretty ugly. And unfortunately I mostly ignored the
previous discussion, sorry about that.

To give you my view of this. I've considered making bpf_prog_load()
and bpf_map_create() smart enough to ignore name if kernel doesn't
support program or map name, respectively. I previously decided to
keep it simple and follow the approach that low-level APIs (which
bpf_prog_load and bpf_map_create are) should not do any such
adjustments to user arguments. But we are not 100% following that
anyways (e.g., bpf_prog_load does retries and is more clever about
log_level, as one example), and it does seem very unlikely that user
will explicitly want to cause failure by passing non-NULL name to
bpf_prog_load/bpf_map_create on old kernels that don't support names.
It's way more likely that a user doesn't want to care and always wants
to specify a name and use it if the kernel supports it.

So I propose we just teach bpf_map_create and bpf_prog_load to ignore
non-NULL names if the kernel doesn't support it. Please double check
if map name support was added at the same time as prog name support,
and if yes, just use kernel_supports(NULL, FEAT_PROG_NAME) in both
cases. If not, we can add a dedicated map name feature detector.

If a user really-really wants to force failure (for some reason),
they'd need to do their own bpf() syscall. Which I think is totally
fine, given the upside of not having to care about whether the kernel
supports names.


> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 77e3797cf75a..db4f1a02b9e0 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4423,6 +4423,22 @@ static int probe_kern_prog_name(void)
>         return probe_fd(ret);
>  }
>
> +static int probe_kern_map_name(enum bpf_map_type map_type,
> +                              const char *map_name, __u32 key_size,
> +                              __u32 value_size, __u32 max_entries,
> +                              const struct bpf_map_create_opts *opts)
> +{
> +       int map;
> +
> +       map = bpf_map_create(map_type, map_name, key_size, value_size, max_entries, opts);
> +       if (map < 0 && errno == EINVAL) {
> +               /* Retry without name */
> +               map = bpf_map_create(map_type, NULL, key_size, value_size, max_entries, opts);
> +       }
> +
> +       return map;
> +}
> +
>  static int probe_kern_global_data(void)
>  {
>         char *cp, errmsg[STRERR_BUFSIZE];
> @@ -4434,7 +4450,7 @@ static int probe_kern_global_data(void)
>         };
>         int ret, map, insn_cnt = ARRAY_SIZE(insns);
>
> -       map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
> +       map = probe_kern_map_name(BPF_MAP_TYPE_ARRAY, "global_data", sizeof(int), 32, 1, NULL);
>         if (map < 0) {
>                 ret = -errno;
>                 cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
> @@ -4567,7 +4583,7 @@ static int probe_kern_array_mmap(void)
>         LIBBPF_OPTS(bpf_map_create_opts, opts, .map_flags = BPF_F_MMAPABLE);
>         int fd;
>
> -       fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), sizeof(int), 1, &opts);
> +       fd = probe_kern_map_name(BPF_MAP_TYPE_ARRAY, "array_mmap", sizeof(int), sizeof(int), 1, &opts);
>         return probe_fd(fd);
>  }
>
> @@ -4614,7 +4630,7 @@ static int probe_prog_bind_map(void)
>         };
>         int ret, map, prog, insn_cnt = ARRAY_SIZE(insns);
>
> -       map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
> +       map = probe_kern_map_name(BPF_MAP_TYPE_ARRAY, "bind_map_detect", sizeof(int), 32, 1, NULL);
>         if (map < 0) {
>                 ret = -errno;
>                 cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
> --
> 2.35.3
>
