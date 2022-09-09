Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708CC5B3F2B
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 21:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiIITAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 15:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiIITAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 15:00:38 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7F774DCA;
        Fri,  9 Sep 2022 12:00:36 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b35so3964367edf.0;
        Fri, 09 Sep 2022 12:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=ox4CFUuD18drqtN8IsU1qD1pZvik437HsGVopsWFXik=;
        b=S7iuggkPdOAS4DBUAxkiKJ7/HcezhrUSy1EjrKd7adE9zpPnMfIrqRlpH0hc1Lp9NM
         KswAkP4qKJV/6p++GW4B7Mn1mVNrNgItawbOr6eQu9lZbwTwIg0qapiHORegaLkz0nOJ
         zvjwwAUdqE5JxXAPwkJoqNlKmfkHHbPK5THjqCPFVOI7IBY7M1zQCgKpJOko94hjrEhJ
         oAuYbDuDEoTdmlP2m0o4JtqtYmjDyR4Hs4ILrD/tiAHXI8xS8revZpNBWMIuJCbm2rhj
         NSQc5AH0KJzH9EE8ltKDCR8WGnibNsd4QAM5Tzuh9cNRmyxvLmwE7fa4Ic94REIcPref
         NN3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ox4CFUuD18drqtN8IsU1qD1pZvik437HsGVopsWFXik=;
        b=VPaTWTh39IdNoCLOH37jxKqVRyl3j/hKbgOv6GMXwssvOHH2HhK365M3esgywIyzvd
         drH/Iv1Gh4kfHdtAlPjSEjbNibiDRWCYsK66oqaB0EY5bzL8Tc0T8J9MoJ3UqlIFFac8
         OkzzY0hwUu+j75UmijZaP9X4NMO1Q5VrwY4mVpr/0l60OgT4/UUl4BnCeiCPOlk+xxyD
         UvzDH+epp1QQUSrDK+O2OtRld8Szq0NniiL9tq4VyoEXOThLmjrKYlluH4OgOI+vdBM1
         ptkXQ8EjQ4jckYUQjrmo+MYwC5YsYGGPK4D0XxacysfjDvzKBYtX9dDKDhBCkQx4YR4a
         J/nA==
X-Gm-Message-State: ACgBeo3dwCNl7mI8DMxOIPLlP+R+KxzlhcUCn/NmrKAAH4150GLgvHw+
        4S4EIsHKrn21BlSK3AozUM4CSnXOv7QJChk7b0I=
X-Google-Smtp-Source: AA6agR6iS15Dbd6Qj7qWac0KAGXEE4OvFghuEeBvEVkkzesf67NZr+/e9i9nclJMboVsybLQHRw+zzhKCq+ig06ILsE=
X-Received: by 2002:a05:6402:24a4:b0:440:8c0c:8d2b with SMTP id
 q36-20020a05640224a400b004408c0c8d2bmr12375623eda.311.1662750035366; Fri, 09
 Sep 2022 12:00:35 -0700 (PDT)
MIME-Version: 1.0
References: <1661349907-57222-1-git-send-email-chentao.kernel@linux.alibaba.com>
 <CAEf4BzZPYAZ-ZJXa0CnrpxzFrXjTScfuioF=DOAw4j1L_tMXTg@mail.gmail.com> <b9eef4fe-71b3-d15c-6615-282124155508@linux.alibaba.com>
In-Reply-To: <b9eef4fe-71b3-d15c-6615-282124155508@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 9 Sep 2022 12:00:24 -0700
Message-ID: <CAEf4BzZ04=R=48NjbUdp9SmQfy6z=S+kD0eYfYbGA3zzMSWn+w@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Support raw btf placed in the default path
To:     Tao Chen <chentao.kernel@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 28, 2022 at 10:36 PM Tao Chen
<chentao.kernel@linux.alibaba.com> wrote:
>
> Hi Nakryiko, thank you for your reply. Yes, i happed to put the raw
> BTF made by myself in /boot on kernel4.19, unluckly it reported error.
> So is it possible to allow the raw BTF in /boot directly, athough we
> can set the specified btf location again to solve the problem with the
> bpf_object_open_opts interface.
>
> As you say, maybe we can remove the locations[i].raw_btf check, just
> use the btf__parse, It looks more concise.

Please don't top post, reply inline (that's kernel mail lists rules).

But yes, I think we can just use btf__parse and let libbpf figure out.
Please send a patch.

>
> =E5=9C=A8 2022/8/26 =E4=B8=8A=E5=8D=884:26, Andrii Nakryiko =E5=86=99=E9=
=81=93:
>
> On Wed, Aug 24, 2022 at 7:05 AM chentao.ct
> <chentao.kernel@linux.alibaba.com> wrote:
>
> Now only elf btf can be placed in the default path, raw btf should
> also can be there.
>
> It's not clear what you are trying to achieve. Do you want libbpf to
> attempt to load /boot/vmlinux-%1$s as raw BTF as well (so you can sort
> of sneak in pregenerated BTF), or what exactly?
> btf__load_vmlinux_btf() code already supports loading raw BTF, it just
> needs to be explicitly specified in locations table.
>
> So with your change locations[i].raw_btf check doesn't make sense and
> we need to clean this up.
>
> But first, let's discuss the use case, instead of your specific solution.
>
>
> Signed-off-by: chentao.ct <chentao.kernel@linux.alibaba.com>
> ---
>  tools/lib/bpf/btf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index bb1e06e..b22b5b3 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -4661,7 +4661,7 @@ struct btf *btf__load_vmlinux_btf(void)
>         } locations[] =3D {
>                 /* try canonical vmlinux BTF through sysfs first */
>                 { "/sys/kernel/btf/vmlinux", true /* raw BTF */ },
> -               /* fall back to trying to find vmlinux ELF on disk otherw=
ise */
> +               /* fall back to trying to find vmlinux RAW/ELF on disk ot=
herwise */
>                 { "/boot/vmlinux-%1$s" },
>                 { "/lib/modules/%1$s/vmlinux-%1$s" },
>                 { "/lib/modules/%1$s/build/vmlinux" },
> @@ -4686,7 +4686,7 @@ struct btf *btf__load_vmlinux_btf(void)
>                 if (locations[i].raw_btf)
>                         btf =3D btf__parse_raw(path);
>                 else
> -                       btf =3D btf__parse_elf(path, NULL);
> +                       btf =3D btf__parse(path, NULL);
>                 err =3D libbpf_get_error(btf);
>                 pr_debug("loading kernel BTF '%s': %d\n", path, err);
>                 if (err)
> --
> 2.2.1
>
