Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594685E5782
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiIVAnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiIVAnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:43:06 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA00BA99DD;
        Wed, 21 Sep 2022 17:43:05 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z97so11268697ede.8;
        Wed, 21 Sep 2022 17:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=wYSOQNWC5It+o8/Gi1iJCg31bqOBA5TdTGj9SmNibk4=;
        b=J+da/wSD/B7rlCGbUx98XPTM2HCpGyWOHbEa0NrjgBx5frpgi/kvKYenSf4puOfOAf
         X/ki/9drk1cdFhtXBFq0Hav6/R1Bd6YbO7RfsFCOHzfvgL0WpWDcPXUhPQhBh1uqpMld
         tp7NrZFsLUHNYOGdZVoH6s21g2X68GSNGg9SaGfNvsH9oopBVghs8a+DROo7V1ASLXvQ
         jcJopt/O52j7mtEAAQC4Ma0jzZxFTdClBzrLvRjeD20TByNlpmAYk/w+E7z73T4SFdLx
         8Fx5GnWNXguX/GL7j+7PtzaHodTa46QqkkBdisSTHVNkjleZZSh4YB3QRmPALDRUQomX
         +HMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=wYSOQNWC5It+o8/Gi1iJCg31bqOBA5TdTGj9SmNibk4=;
        b=YwWRJdTjkQS9slT9T56AqKYqX3dksLNpcwyCoTsSvzBgiuYneKrssslaVhILIEogq/
         uoSIUvNLrIQiN5J3q6LS3J07dCVTHUzVJIVlGwi77F6ZbWcaKNRG3jHkqdlEdpouMIoU
         L9HBW890+bo2sVlaKxHuXPUS8WO01fDGuAj9oIxFOC65Hhs6RpXFuVn8slLc5lBEHf30
         TCAltNmM+6qCQwxyHShb1y69XQowEXCBWgVacEuR75vVyeQK0dda7OxTJZJmhJd6dfNE
         JTqyTndw613+Jyu6QdZ/7Q/pE32eTz19g4lsg3l7OZrz3k4aZBTg2ifAh0kLXM0vvq7U
         PG+A==
X-Gm-Message-State: ACrzQf1I/MCexS67xbT3tsA/B+1AoP0/bBJ+qxy9Au5IqoFw+1YIDfMH
        SnCSmDQFE8bgS+zIGAxZr2UTLaHxu1f1U7KOYMI=
X-Google-Smtp-Source: AMsMyM59vgKc16+SXV2dQ4kgCA5xjzucBZiPrf0bFDSAQRC+J5Lv2Mq/uM4O+cnE/TwO1jgVgHajxhaw5e64drpOsf8=
X-Received: by 2002:aa7:de9a:0:b0:44d:8191:44c5 with SMTP id
 j26-20020aa7de9a000000b0044d819144c5mr707493edv.232.1663807384275; Wed, 21
 Sep 2022 17:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <1662702346-29665-1-git-send-email-wangyufen@huawei.com>
 <1662702346-29665-2-git-send-email-wangyufen@huawei.com> <Yxt07BE7TOX6dGh2@google.com>
In-Reply-To: <Yxt07BE7TOX6dGh2@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Sep 2022 17:42:53 -0700
Message-ID: <CAEf4Bza_449Ku65rLFG391aS6_ec-rt-sWbspveZ_nhBKn2j8w@mail.gmail.com>
Subject: Re: [bpf-next 2/2] libbpf: Add pathname_concat() helper
To:     sdf@google.com
Cc:     Wang Yufen <wangyufen@huawei.com>, andrii@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 10:16 AM <sdf@google.com> wrote:
>
> On 09/09, Wang Yufen wrote:
> > Move snprintf and len check to common helper pathname_concat() to make the
> > code simpler.
>
> > Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> > ---
> >   tools/lib/bpf/libbpf.c | 74
> > ++++++++++++++++++--------------------------------
> >   1 file changed, 27 insertions(+), 47 deletions(-)
>
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 5854b92..238a03e 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -2096,20 +2096,31 @@ static bool get_map_field_int(const char
> > *map_name, const struct btf *btf,
> >       return true;
> >   }
>
> > -static int build_map_pin_path(struct bpf_map *map, const char *path)
> > +static int pathname_concat(const char *path, const char *name, char *buf)
> >   {
> > -     char buf[PATH_MAX];
> >       int len;
>
> > -     if (!path)
> > -             path = "/sys/fs/bpf";
> > -
> > -     len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
> > +     len = snprintf(buf, PATH_MAX, "%s/%s", path, name);
> >       if (len < 0)
> >               return -EINVAL;
> >       else if (len >= PATH_MAX)
> >               return -ENAMETOOLONG;
>
> > +     return 0;
> > +}
> > +
> > +static int build_map_pin_path(struct bpf_map *map, const char *path)
> > +{
> > +     char buf[PATH_MAX];
> > +     int err;
> > +
> > +     if (!path)
> > +             path = "/sys/fs/bpf";
> > +
> > +     err = pathname_concat(path, bpf_map__name(map), buf);
> > +     if (err)
> > +             return err;
> > +
> >       return bpf_map__set_pin_path(map, buf);
> >   }
>
> > @@ -7959,17 +7970,8 @@ int bpf_object__pin_maps(struct bpf_object *obj,
> > const char *path)
> >                       continue;
>
> >               if (path) {
> > -                     int len;
> > -
> > -                     len = snprintf(buf, PATH_MAX, "%s/%s", path,
> > -                                    bpf_map__name(map));
> > -                     if (len < 0) {
> > -                             err = -EINVAL;
> > -                             goto err_unpin_maps;
> > -                     } else if (len >= PATH_MAX) {
> > -                             err = -ENAMETOOLONG;
>
> [..]
>
> > +                     if (pathname_concat(path, bpf_map__name(map), buf))
> >                               goto err_unpin_maps;
> > -                     }
>
> You're breaking error reporting here and in a bunch of other places.
> Should be:
>
> err = pathname_concat();
> if (err)
>         goto err_unpin_maps;
>
> I have the same attitude towards this patch as the first one in the
> series: not worth it. Nothing is currently broken, the code as is relatively
> readable, this version is not much simpler, it just looks slightly different
> taste-wise..
>

It's a minor improvement, IMO, so I don't mind it (5 repetitions of
annoying error case handling seems worth streamlining). But selftests
just for this seems like an overkill.

> How about this: if you really want to push this kind of cleanup, send
> selftests that exercise all these error cases? :-)
>
>

[...]
