Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932DE4B9455
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 00:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbiBPXJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 18:09:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbiBPXJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 18:09:10 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC218E0AC;
        Wed, 16 Feb 2022 15:08:55 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id w7so1652449ioj.5;
        Wed, 16 Feb 2022 15:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DQGdwhzxuaQQGT+cGokIeD5v2jSvIV5/tTpED2lEYT8=;
        b=VrzW9xMaz+iTf8AL+xTD+S27kWbc8aWiEtZDp/mtHeqIxLskwHh2PrT7kGo+tZicLe
         xI+NJBJpIQzSBtMxfv0gYm/zTI4Pxgo7gjIk1MYeMGMUuf6SIN9d6jolUyQmoAar3ZUf
         s5W4bolp3St3JAURsaCtE0+mSZD8sNO9Dae1H4k+0uozd+jfXUxScS7vzVAsbj0EI6Wo
         JcBfVehAeZ+hskjnNnlSTASROb6d3LZX28ZOZkqvWPRhiOiBdJMzJKz0Jip5pfypbUsP
         YWKmIHK4whuFF+A7Ujw7jHTHdsN7vLVuonz0cesWkV7rzRv9GstjQim7JnXwC2qQ8tfn
         tkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DQGdwhzxuaQQGT+cGokIeD5v2jSvIV5/tTpED2lEYT8=;
        b=I/nrL/n4VdEsVGLE6weVD5K4HdRU28F7rAjla7v4fsWGVeTjtQqqp/LiMO8b5LyPQ5
         XVg+hdwGgWLxLEyoYV0Arr0npu1uPJJwMSP4rp8GqR8LHy4TLkbSoqXnNeHKI0rLsynj
         wkau1dyLxXGTwcUlO1yS2N4dKZChHpYS7y2ZfPrynrVIC6B/RJM4qcurbHiPBdhmCCg4
         NaHqJ5kd70+ykL3umhC4tKsX7veEaFvnUbML18SUma9srvrqQUW4uSGNPt87R7y5nFxf
         zQQxepnKAkTb6X8sUmxxSm+NNc2LckcGyn9JSR8EyiDYlMdNlutDnYHvZmMlslsvrhwp
         CE5A==
X-Gm-Message-State: AOAM5306yYrN2BFPHs9BeD7O/BkRyUIWdew31dgM1Jx/V84veUgH5KSS
        qlBuLrYIYKdlk+dMcBxZIBEGmOJSa8MtPL8l3CmayECtx8mGsg==
X-Google-Smtp-Source: ABdhPJwEIuoYnzm7Z8ea6zcujmmC/+dFVlDsv5IiW0c/Y///Zf+yoYJmQU64bva0nG0Aj68NEOBdyBLRoUAvZCYvH3Q=
X-Received: by 2002:a05:6638:382:b0:30e:3e2e:3227 with SMTP id
 y2-20020a056638038200b0030e3e2e3227mr107859jap.234.1645052935157; Wed, 16 Feb
 2022 15:08:55 -0800 (PST)
MIME-Version: 1.0
References: <20220216092102.125448-1-jolsa@kernel.org>
In-Reply-To: <20220216092102.125448-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Feb 2022 15:08:44 -0800
Message-ID: <CAEf4Bza0B1jpZ7ZR4ZBPuDf1J0+t_S2bP2ySH26Ea6sNWbiBoQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: Fix pretty print dump for maps without
 BTF loaded
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
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

On Wed, Feb 16, 2022 at 1:21 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The commit e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
> fails to dump map without BTF loaded in pretty mode (-p option).
>
> Fixing this by making sure get_map_kv_btf won't fail in case there's
> no BTF available for the map.
>
> Cc: Yinjun Zhang <yinjun.zhang@corigine.com>
> Fixes: e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/bpftool/map.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index 7a341a472ea4..8562add7417d 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -805,29 +805,28 @@ static int maps_have_btf(int *fds, int nb_fds)
>
>  static struct btf *btf_vmlinux;
>
> -static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
> +static int get_map_kv_btf(const struct bpf_map_info *info, struct btf **btf)
>  {
> -       struct btf *btf = NULL;
> +       int err = 0;
>
>         if (info->btf_vmlinux_value_type_id) {
>                 if (!btf_vmlinux) {
>                         btf_vmlinux = libbpf_find_kernel_btf();
> -                       if (libbpf_get_error(btf_vmlinux))
> +                       err = libbpf_get_error(btf_vmlinux);
> +                       if (err) {
>                                 p_err("failed to get kernel btf");
> +                               return err;
> +                       }
>                 }
> -               return btf_vmlinux;
> +               *btf = btf_vmlinux;
>         } else if (info->btf_value_type_id) {
> -               int err;
> -
> -               btf = btf__load_from_kernel_by_id(info->btf_id);
> -               err = libbpf_get_error(btf);
> -               if (err) {
> +               *btf = btf__load_from_kernel_by_id(info->btf_id);
> +               err = libbpf_get_error(*btf);
> +               if (err)
>                         p_err("failed to get btf");
> -                       btf = ERR_PTR(err);
> -               }
>         }

get_map_kv_btf is supposed to set btf to NULL, otherwise you can get a
crash in the caller

I've added

else {
    *btf = NULL;
}

and force-pushed


>
> -       return btf;
> +       return err;
>  }
>
>  static void free_map_kv_btf(struct btf *btf)
> @@ -862,8 +861,7 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
>         prev_key = NULL;
>
>         if (wtr) {
> -               btf = get_map_kv_btf(info);
> -               err = libbpf_get_error(btf);
> +               err = get_map_kv_btf(info, &btf);
>                 if (err) {
>                         goto exit_free;
>                 }
> @@ -1054,8 +1052,7 @@ static void print_key_value(struct bpf_map_info *info, void *key,
>         json_writer_t *btf_wtr;
>         struct btf *btf;
>
> -       btf = get_map_kv_btf(info);
> -       if (libbpf_get_error(btf))
> +       if (get_map_kv_btf(info, &btf))
>                 return;
>
>         if (json_output) {
> --
> 2.35.1
>
