Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E014CE0A1
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiCDXMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiCDXMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:12:20 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1903B27B91E;
        Fri,  4 Mar 2022 15:11:24 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id 13so1674381ilq.5;
        Fri, 04 Mar 2022 15:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nqucxhPO+8EiZ43Hxf5GxeRzKMa1RRA+U6Dd5FDDwEI=;
        b=QqtRjO4K+4O200e6ExUQYAMLZG+ksPxqlayduvmyMNcTC21bndauqZKF3C3V2xHQwG
         AbPURou9hoXA6MZ3WLvyBp9Vx/wb3JpNFMCfqmitzOfzrUeD0RFUBS5vCAbps8T4cQv6
         XOlqPSsPlt0+Fnp8s1cjQxPKXO5SFgA8bafykOj3OJEICuAD5hmidwErGHqV+FlzOGHW
         wB/r8IVtrX6AoTw0yfjjFqYmKNkbajO20b1BowhhIPjU0KutDgg9lYa3rpv23m1eRFAa
         Ed2HRr+uAdcBuGryl59LaeoNlVqarBMES3HxnN92w5ZaOwS4F7detLC+kl9/ynpm0qWH
         GAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nqucxhPO+8EiZ43Hxf5GxeRzKMa1RRA+U6Dd5FDDwEI=;
        b=OROoZjFTcNdaq6jYUCwv/2lYtfNjGf25YLJ7vVRcx0TuTWb2zIYfPgTC6FL6Z1dKRP
         9fO+MhmcNP6OWYHFJNox6MFzbJlDymrvXDucyI/POFqRXtTNQRhmybs4dHoE8nV02Hca
         2ThoEhM14AkbJunaIOiXTwma3PPmyDqPRDGJXZMRFtPTeZmIxvOPBp8jOfEQrHRM6Gp5
         lAgHkaS3cfZWTpYiGttXXix9TRSrSUvZcdaGHXXDrCAcDdIA6NVVsYQTe7HtR4RVr3ip
         ZZPMFk47rgTr+lJD6jvI66tCpkMmbWKx5OmFWJsZhIhyUHZBYI9uH04S1i03saoywkqz
         FjsQ==
X-Gm-Message-State: AOAM533Z7j7YonFrry6P2YvbI4esv7h7wbXJjGqbt4beP6Sox2zNBu9B
        gAS3Erj1WX4ni7iqhZboGgyl81l53EB8LpdrxA4G70MEch0=
X-Google-Smtp-Source: ABdhPJxlNjaAfzwM2frGDsxUirqx9AE9bLiQQdMuDTJFTJUpn08+hkg0lQYQBAgx5jENmAhs/1TJtniE/vZ7wj1sIpA=
X-Received: by 2002:a92:ca0d:0:b0:2c2:a846:b05a with SMTP id
 j13-20020a92ca0d000000b002c2a846b05amr799337ils.252.1646435483391; Fri, 04
 Mar 2022 15:11:23 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <20220222170600.611515-7-jolsa@kernel.org>
In-Reply-To: <20220222170600.611515-7-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Mar 2022 15:11:12 -0800
Message-ID: <CAEf4BzaidFMNhxrRXA=-bOc85RwRiLk7AxuW5TOpAi2GeXhCaQ@mail.gmail.com>
Subject: Re: [PATCH 06/10] libbpf: Add libbpf_kallsyms_parse function
To:     Jiri Olsa <jolsa@kernel.org>
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
        Steven Rostedt <rostedt@goodmis.org>
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

On Tue, Feb 22, 2022 at 9:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Move the kallsyms parsing in internal libbpf_kallsyms_parse
> function, so it can be used from other places.
>
> It will be used in following changes.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM

Acked-by: Andrii Nakryiko <andrii@kernel.org>


>  tools/lib/bpf/libbpf.c          | 62 ++++++++++++++++++++-------------
>  tools/lib/bpf/libbpf_internal.h |  5 +++
>  2 files changed, 43 insertions(+), 24 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ad43b6ce825e..fb530b004a0d 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7172,12 +7172,10 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
>         return 0;
>  }
>
> -static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
> +int libbpf_kallsyms_parse(kallsyms_cb_t cb, void *ctx)
>  {
>         char sym_type, sym_name[500];
>         unsigned long long sym_addr;
> -       const struct btf_type *t;
> -       struct extern_desc *ext;
>         int ret, err = 0;
>         FILE *f;
>
> @@ -7196,35 +7194,51 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
>                 if (ret != 3) {
>                         pr_warn("failed to read kallsyms entry: %d\n", ret);
>                         err = -EINVAL;
> -                       goto out;
> +                       break;
>                 }
>
> -               ext = find_extern_by_name(obj, sym_name);
> -               if (!ext || ext->type != EXT_KSYM)
> -                       continue;
> -
> -               t = btf__type_by_id(obj->btf, ext->btf_id);
> -               if (!btf_is_var(t))
> -                       continue;
> -
> -               if (ext->is_set && ext->ksym.addr != sym_addr) {
> -                       pr_warn("extern (ksym) '%s' resolution is ambiguous: 0x%llx or 0x%llx\n",
> -                               sym_name, ext->ksym.addr, sym_addr);
> -                       err = -EINVAL;
> -                       goto out;
> -               }
> -               if (!ext->is_set) {
> -                       ext->is_set = true;
> -                       ext->ksym.addr = sym_addr;
> -                       pr_debug("extern (ksym) %s=0x%llx\n", sym_name, sym_addr);
> -               }
> +               err = cb(sym_addr, sym_type, sym_name, ctx);
> +               if (err)
> +                       break;
>         }
>
> -out:
>         fclose(f);
>         return err;
>  }
>
> +static int kallsyms_cb(unsigned long long sym_addr, char sym_type,
> +                      const char *sym_name, void *ctx)
> +{
> +       struct bpf_object *obj = ctx;
> +       const struct btf_type *t;
> +       struct extern_desc *ext;
> +
> +       ext = find_extern_by_name(obj, sym_name);
> +       if (!ext || ext->type != EXT_KSYM)
> +               return 0;
> +
> +       t = btf__type_by_id(obj->btf, ext->btf_id);
> +       if (!btf_is_var(t))
> +               return 0;
> +
> +       if (ext->is_set && ext->ksym.addr != sym_addr) {
> +               pr_warn("extern (ksym) '%s' resolution is ambiguous: 0x%llx or 0x%llx\n",
> +                       sym_name, ext->ksym.addr, sym_addr);
> +               return -EINVAL;
> +       }
> +       if (!ext->is_set) {
> +               ext->is_set = true;
> +               ext->ksym.addr = sym_addr;
> +               pr_debug("extern (ksym) %s=0x%llx\n", sym_name, sym_addr);
> +       }
> +       return 0;
> +}
> +
> +static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
> +{
> +       return libbpf_kallsyms_parse(kallsyms_cb, obj);
> +}
> +
>  static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
>                             __u16 kind, struct btf **res_btf,
>                             struct module_btf **res_mod_btf)
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 4fda8bdf0a0d..b6247dc7f8eb 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -449,6 +449,11 @@ __s32 btf__find_by_name_kind_own(const struct btf *btf, const char *type_name,
>
>  extern enum libbpf_strict_mode libbpf_mode;
>
> +typedef int (*kallsyms_cb_t)(unsigned long long sym_addr, char sym_type,
> +                            const char *sym_name, void *ctx);
> +
> +int libbpf_kallsyms_parse(kallsyms_cb_t cb, void *arg);
> +
>  /* handle direct returned errors */
>  static inline int libbpf_err(int ret)
>  {
> --
> 2.35.1
>
