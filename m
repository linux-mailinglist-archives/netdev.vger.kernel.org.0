Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B3C4DA957
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 05:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353528AbiCPEfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 00:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353521AbiCPEeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 00:34:44 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2B35EDD2;
        Tue, 15 Mar 2022 21:33:31 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id q11so1098057iod.6;
        Tue, 15 Mar 2022 21:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=70UoJWrmjI50t2swoz3ieIHZ1jDITBYJP+SxtcY68Bw=;
        b=WRWGQSp4XimyBdEprQLaCVudyUc7Bod2u3sN0JVTzSVqinJn4lqwwHwZCac0F6bII1
         9/F/bJVIl8aMIF2Y0wFZ39fQ/NKOtufwrc4rRBKbUkoRdzZcVYRxNrvOnHf7KoL5xaoJ
         irWbKjMyKwJtNOqW8hd4rt84AZf76XLYYEnpCcz59tJa8wEF4FZmBrMDeLM+JQPVwCLP
         p0iKMKPA5yAGyqJlP67yKI/VC5sWGZ1LGiyQcwqpnN6jlKBtQUSNIjPVVly5WHESkFcw
         xxVA0B7wEiY+qIudiBN7YgV9hiYXDCtVena6fITA5S2+j7g2m+Gc/DqKx0ccO4wovdQE
         KjjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=70UoJWrmjI50t2swoz3ieIHZ1jDITBYJP+SxtcY68Bw=;
        b=vH1SE+2zb56e3G7rffFFltT2YHv/MxjB4gMz/5xMTj24rSZ4+JTcI/ez/AIXDIK15o
         wNtxEpnDQsskeBVAMcVSftKqgpPVmb6QmlbQ2LRIgo9MgzwIIyNQe63Lc2avK8U4BqlY
         MdgChSDlbotXDaPm3XV8St1KU61Olr/wxyOV+3vdmDxIJo9gbVXQAQrkphcJoWKmmfIB
         sxu69vAkpqimAAdRXk7Bln+ZqEgU4E6q6ersyypUCnXynBNpiSE4N7OXkDjblLF7+22h
         zllTDDjIrdNfDCuZ6ayCB0daQuRBMbJ8NkMXuwiApgay2urcYh1Dimf/wW5HfX3qu6hS
         icUg==
X-Gm-Message-State: AOAM533Wjfp/xfSGCcu5i2FvEW+DYddIVAuJmWBba5SwJrNPG8GJgE6e
        pdRPiGTy7W+P7XLk7AqLJcO4EO+9TnYFEMVIV+0=
X-Google-Smtp-Source: ABdhPJw7pvVezE2R8fHmGOewAJTOEBC8d6BG8Rd7OA50MsBbuBu8r5ZSw/Id4WMkkPwef5ZJaYUpb6n/6GVDjVboWy8=
X-Received: by 2002:a05:6638:1035:b0:306:e5bd:36da with SMTP id
 n21-20020a056638103500b00306e5bd36damr25847669jan.145.1647405210960; Tue, 15
 Mar 2022 21:33:30 -0700 (PDT)
MIME-Version: 1.0
References: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com> <1647000658-16149-4-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1647000658-16149-4-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Mar 2022 21:33:20 -0700
Message-ID: <CAEf4BzaM9EMQ0XyFxGzf0U1Z5SVXMdcvChgBioSwVZTnCj+KdQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/5] libbpf: add auto-attach for uprobes based
 on section name
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Fri, Mar 11, 2022 at 4:11 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Now that u[ret]probes can use name-based specification, it makes
> sense to add support for auto-attach based on SEC() definition.
> The format proposed is
>
>         SEC("u[ret]probe/prog:[raw_offset|[function_name[+offset]]")

nit: prog -> binary ? or prog -> path?

>
> For example, to trace malloc() in libc:
>
>         SEC("uprobe/libc.so.6:malloc")
>
> ...or to trace function foo2 in /usr/bin/foo:
>
>         SEC("uprobe//usr/bin/foo:foo2")
>
> Auto-attach is done for all tasks (pid -1).  prog can be an absolute
> path or simply a program/library name; in the latter case, we use
> PATH/LD_LIBRARY_PATH to resolve the full path, falling back to
> standard locations (/usr/bin:/usr/sbin or /usr/lib64:/usr/lib) if
> the file is not found via environment-variable specified locations.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/libbpf.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 66 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 2b50b01..0dcbca8 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8593,6 +8593,7 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
>  }
>
>  static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link);
> +static int attach_uprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link);
>  static int attach_tp(const struct bpf_program *prog, long cookie, struct bpf_link **link);
>  static int attach_raw_tp(const struct bpf_program *prog, long cookie, struct bpf_link **link);
>  static int attach_trace(const struct bpf_program *prog, long cookie, struct bpf_link **link);
> @@ -8604,9 +8605,9 @@ int bpf_program__set_log_buf(struct bpf_program *prog, char *log_buf, size_t log
>         SEC_DEF("sk_reuseport/migrate", SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT_OR_MIGRATE, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
>         SEC_DEF("sk_reuseport",         SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
>         SEC_DEF("kprobe/",              KPROBE, 0, SEC_NONE, attach_kprobe),
> -       SEC_DEF("uprobe/",              KPROBE, 0, SEC_NONE),
> +       SEC_DEF("uprobe/",              KPROBE, 0, SEC_NONE, attach_uprobe),
>         SEC_DEF("kretprobe/",           KPROBE, 0, SEC_NONE, attach_kprobe),
> -       SEC_DEF("uretprobe/",           KPROBE, 0, SEC_NONE),
> +       SEC_DEF("uretprobe/",           KPROBE, 0, SEC_NONE, attach_uprobe),
>         SEC_DEF("tc",                   SCHED_CLS, 0, SEC_NONE),
>         SEC_DEF("classifier",           SCHED_CLS, 0, SEC_NONE | SEC_SLOPPY_PFX | SEC_DEPRECATED),
>         SEC_DEF("action",               SCHED_ACT, 0, SEC_NONE | SEC_SLOPPY_PFX),
> @@ -10761,6 +10762,69 @@ struct bpf_link *bpf_program__attach_uprobe(const struct bpf_program *prog,
>         return bpf_program__attach_uprobe_opts(prog, pid, binary_path, func_offset, &opts);
>  }
>
> +/* Format of u[ret]probe section definition supporting auto-attach:
> + * u[ret]probe/prog:function[+offset]

same about prog

> + *
> + * prog can be an absolute/relative path or a filename; the latter is resolved to a
> + * full path via bpf_program__attach_uprobe_opts.
> + *
> + * Many uprobe programs do not avail of auto-attach, so we need to handle the

do not avail of? meaning "can't be auto-attached due to missing information"?

> + * case where the format is uprobe/myfunc by returning 0 with *link set to NULL
> + * to identify the case where auto-attach is not supported.

it's true that we supported SEC("uprobe/whatever") before and that's
not enough to auto-attach. But let's not drag this legacy "syntax"
forward. How about we check if LIBBPF_STRICT_SEC_NAME is set, and if
yes, then it should either be plain SEC("uprobe") or a proper full
form of SEC("uprobe/path:func...") that you are adding? libbpf
supports such case, you just need to change SEC_DEF definition to
uprobe/ -> uprobe+, which means that it is either SEC("uprobe") or
SEC("uprobe/<something>").

In legacy mode we just won't support auto-attach for uprobe.

Thoughts?

> + */
> +static int attach_uprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
> +       char *func, *probe_name, *func_end;
> +       char *func_name, binary_path[512];
> +       unsigned long long raw_offset;
> +       size_t offset = 0;
> +       int n;
> +
> +       *link = NULL;
> +

[...]
