Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63CD24F0CE5
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 01:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376623AbiDCXM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 19:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357532AbiDCXMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 19:12:24 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAB32BB36;
        Sun,  3 Apr 2022 16:10:30 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id x9so5703989ilc.3;
        Sun, 03 Apr 2022 16:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a3HAUNAOGJbuMUJGWk34muWFcGqX/DzMj8VavXq90tI=;
        b=L0nJ6s2BVwW8B84xCcYvOJ2ZJSnAjg214/lRxP7iEMPY6jzsGy4TEwH4F6a5nbPoCx
         ldZRFFBKJ/QxS0bsNI3VGsT47JNE+azq/SXHjTWhE0SYF0FGD4XywW4HLW2nBHFpEVOw
         l7zvZ0Q+bGKKcyCUE1Dki8jzzPfmdQ2IErLH1weOl+tF/LTgjZMsdyx5Cfw3UiP+SFkX
         CRlfrTF+rxkYiqf+5DxY2b+eCd7i6TZwHADu/mfuO0ZxOGZfE8lr0RKXjCnvGZ4zVVuw
         Usd3L8Uuo9WfhZvA9K7O/aFQb0ziOyU8293JEbtUJwddmhv0mU1ud9KCQN3o/c79xjc7
         yTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a3HAUNAOGJbuMUJGWk34muWFcGqX/DzMj8VavXq90tI=;
        b=0rNhpdgkHDcukDTf5m7co6BgqRvDtzOn4rUSmRtyc0CnfWZeVo+LUx36EicG4uvLUZ
         d2urF4X7HByd4KbhaU/Tu7F5zY12yY086uD+V0TIYcF27kZiS40hcyLSfIiDkc3wvvtn
         dlCkQGkttwSn7BYmPX3SfGqJmL9GDDmEtmjHWoExRfR5VnLJeKlxYQT7om0fkQK7iWVu
         qinPAusYCAsDfrXkRfodgPMp2SMpLL1G9oUlNOxWLeJ4fKFc5DX1enjkbdDoXq8eWHDj
         AJhUQ5ohpmuwEl+9CtgIjrC4fflCd5gxmZvdl4ABr8L5tmANL9y08xRfq0icQBbJvuXV
         JuBQ==
X-Gm-Message-State: AOAM532uuxNtE9qrOoHQ/Bk+fvFjAadZH8mD4gc3jjIjsEbQxmc2ZJd9
        tN3oCqeoAiR15nfXxyEA089BTRhaJc9cHx/JpsU=
X-Google-Smtp-Source: ABdhPJz6B8WlpD0f2DGBAzviio1COIm1zm0S0G60bpAExDemXJIZjcSUZct2ThnbAajYcoajZmXkS024TUYnnIPZaak=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr4162168ilb.305.1649027429127; Sun, 03
 Apr 2022 16:10:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzbzqvQM63-mO96tbNaPXsKSbff4h-mX6UBfbU9zZG67OQ@mail.gmail.com>
 <20220316145213.868746-1-ytcoode@gmail.com>
In-Reply-To: <20220316145213.868746-1-ytcoode@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 16:10:18 -0700
Message-ID: <CAEf4Bzbi1E_-yojgJQevM1rdhXF4EzU4dgPsGDT7F5uuDPOE7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: Don't return -EINVAL if hdr_len < offsetofend(core_relo_len)
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
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

On Wed, Mar 16, 2022 at 7:52 AM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> Since core relos is an optional part of the .BTF.ext ELF section, we should
> skip parsing it instead of returning -EINVAL if header size is less than
> offsetofend(struct btf_ext_header, core_relo_len).
>
> Fixes: e9fc3ce99b34 ("libbpf: Streamline error reporting for high-level APIs")
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
> v1 -> v2: skip core relos if hdr_len < offsetofend(core_relo_len)
>

Seems like this never made it to Patchworks. Can you please trim down
the CC list and resubmit?

>  tools/lib/bpf/btf.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 1383e26c5d1f..9b7196b21498 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -2826,10 +2826,8 @@ struct btf_ext *btf_ext__new(const __u8 *data, __u32 size)
>         if (err)
>                 goto done;
>
> -       if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len)) {
> -               err = -EINVAL;
> -               goto done;
> -       }
> +       if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len))
> +               goto done; // skip core relos parsing

don't use C++-style comments, only /* */

>
>         err = btf_ext_setup_core_relos(btf_ext);
>         if (err)
> --
> 2.35.1
>
