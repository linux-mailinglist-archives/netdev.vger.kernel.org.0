Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8BC4DA27B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 19:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351074AbiCOSiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 14:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351067AbiCOSiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 14:38:21 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60792483B4;
        Tue, 15 Mar 2022 11:37:08 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id l18so16013501ioj.2;
        Tue, 15 Mar 2022 11:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xt1UGiPjPraq4SpUxRWULqHUBLr6thKTQdGzdb7dfpU=;
        b=OshylebKscz8YB29+TTLvy9R7Pkgsr41xIUiFL5WB+I/Us2w2zSF1qNiwOb2YI93UC
         WYWA5TEWSEK3cHZn8tq03rqfIVUS+FzOInIPzd1u6UaehnD+5x8D01W5JQ7WNuxzLpoF
         G9XEheursO0oeR5F+1S/QY0jykmgsnQMOzKrH4U6woLChkX2lSQTcv96hsWmUIGjz59m
         NpjgMP767eeCFjTxmk4iNRUIJOccrQGf3NOv3fuhOsh9NiogcIldQGFYBUxRENqYw10h
         OMf1oU3x1UznfQQkBLiyL4IQJZEyyW2Qbi5zwxMvOU5dzDMQA8J25/KO3eK2YH2a95UY
         bXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xt1UGiPjPraq4SpUxRWULqHUBLr6thKTQdGzdb7dfpU=;
        b=JcdUGI97gPUClFyJ4Pkx4dG2krX43rgj0BGG0vn6jgJWdl70hPMw/aI8RW+fxIcxCl
         z3JU1tHu+HILswbtCIJ4zymbCebSw81MlRr7OEB+OWuDiRE8Wbaj4VJg3+HAmkcJtXlZ
         bmoGegT4KtPjCL66ZQIo0DvHnNXZP1g+czsjZ7LyLqcOArWCWh4gw9pSWQ3cA1vIU9q9
         uW6brJUV36Dq0hkdiKHMm5gjwr1AdlzC40zxITXo54hpLEWxaANKiH5yMwhTvVmGmlhB
         945QmpezstXjx24M8QzIh1nzI2yzE6Djuc2btT+ulX67YTVHJjGq/qTkWIiDX4LAuLl4
         Od0Q==
X-Gm-Message-State: AOAM5330gKHdDdGJu/fcW4Jtnln/+0RBWxeMbSPjJRDjj6VBgYJzEDKJ
        j6NjAMBBVo9hJx7tHBRE0MJ69mw62nSKHLBvysmkccsZO4c=
X-Google-Smtp-Source: ABdhPJysC9D34/ZbaU8t+ror4M8uwsZuOIYXj3vBPIyxZeayJYyRJtn5YRt7YoLrVJBcwEdlwMoD5ZyQCzdjxGPaWSA=
X-Received: by 2002:a02:c00e:0:b0:317:c548:97c with SMTP id
 y14-20020a02c00e000000b00317c548097cmr24845913jai.234.1647369427778; Tue, 15
 Mar 2022 11:37:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220312171354.661448-1-ytcoode@gmail.com>
In-Reply-To: <20220312171354.661448-1-ytcoode@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Mar 2022 11:36:56 -0700
Message-ID: <CAEf4BzbzqvQM63-mO96tbNaPXsKSbff4h-mX6UBfbU9zZG67OQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Remove redundant check in btf_ext__new()
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Sat, Mar 12, 2022 at 9:14 AM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> Since 'core_relo_len' is the last field of 'struct btf_ext_header', if
> 'xxx->hdr_len' is not less than 'offsetofend(xxx, core_relo_len)', then
> 'xxx->hdr_len' must also be not less than 'offsetofend(xxx, line_info_len)'.
>
> We can check 'xxx->hdr_len < offsetofend(xxx, core_relo_len)' first, if it
> passes, the 'xxx->hdr_len < offsetofend(xxx, line_info_len)' check will be
> redundant, it can be removed.
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  tools/lib/bpf/btf.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 1383e26c5d1f..d55b44124c3e 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -2813,7 +2813,7 @@ struct btf_ext *btf_ext__new(const __u8 *data, __u32 size)
>         if (err)
>                 goto done;
>
> -       if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, line_info_len)) {
> +       if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len)) {
>                 err = -EINVAL;
>                 goto done;
>         }
> @@ -2826,11 +2826,6 @@ struct btf_ext *btf_ext__new(const __u8 *data, __u32 size)
>         if (err)
>                 goto done;
>
> -       if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len)) {
> -               err = -EINVAL;
> -               goto done;
> -       }

it seems like it's actually a bug. If header is smaller then core
relos parsing should be skipped, I think. Maybe let's fix that
instead?

basically the logic should be:

1. if size of header is exactly == offsetof(core_relo_off) then skip core relos
2. otherwise check that it has enough size to cover core_relo_off and
core_relo_len, and error out if not
3. otherwise proceed to parsing core relos

> -
>         err = btf_ext_setup_core_relos(btf_ext);
>         if (err)
>                 goto done;
> --
> 2.35.1
>
