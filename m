Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052BB53C455
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 07:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239363AbiFCFfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 01:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiFCFfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 01:35:31 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A468C38DB6;
        Thu,  2 Jun 2022 22:35:30 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id o15so7353069ljp.10;
        Thu, 02 Jun 2022 22:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eO43q8JT8AT25MGSbylOq4L/CpABvSv2du0djS6sehA=;
        b=P/97q019CzWcs+L2gPt9QiGVXh/uYt7kgeU0EIf4p6CoyrGqwWo7y9/z73AdNyH83L
         glFYiP6OYRhOUoF20JGcoqmVZv5VGrLDGdnM8rGi9NW0DuAdTmT4L20EmFLZv+UzHzJ+
         h7tPFYxfOVkNjJbO2WjnxiqOx1zdycWQRHVQYrCOkqtMtGVupShAB8PQxYRLsb7DT+Qw
         n7dF039HfS5z47CrgfJDgxMYGr4oFKFi1FjnBFySjArdEc8fNsfHjBz02F2tRoWkI7L5
         e9kxAFfLPkRSJ/loHG2XlH3TBs1iel1x5oVeImHKgZt2Pqe9EpCIoZ2yzEoIrYukV/Ov
         zr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eO43q8JT8AT25MGSbylOq4L/CpABvSv2du0djS6sehA=;
        b=r5AATzNNuPFbrG0/1jo3JOm/8x8N6l9PVkHHNH1dSixRNeUYYGqbeoeZXibGpxCvkB
         8BUMHSGgifm2ocUxg86GyQjIONwLQAL5uGUjGdDIzHB7NEGN6VBFR7cjQwuiLHlQd1ma
         BNqkuWcwcm5evYaEn4O1m7eqmtSEgvpRtLkErSP58yDM2tXVeR63VXxoMWXQDFJpMivu
         62Vm73nyzKf9UFb3KEoQl1foazFRX66Qq4Ba4ESNyBu8HF8V8Ipnbgr9MuVTQWPnFcZe
         QOwbgYkgvVpENqx8pOS5jRfNix50gsDWDxFkW70Ssyp55DahgIgGfNZSa0hwveP6/DJy
         pmfQ==
X-Gm-Message-State: AOAM531QKQ8ggdqJCFsIppOx4R0DzCJ8rQp/JNF6/o1zdXVAwZhVZmg2
        R2bNX1RkymV+41Wgp+oYU98ymrTL+9O5I2YCBQ0=
X-Google-Smtp-Source: ABdhPJyjiGHAloI5DNHT20YN0eogzenXFjqoxr3fKXGsnmq3G427Nd8CATT4eiiSONAXrxtOd1YSdx3hDW8ryqSg+98=
X-Received: by 2002:a2e:a7c5:0:b0:253:ee97:f9b7 with SMTP id
 x5-20020a2ea7c5000000b00253ee97f9b7mr31934085ljp.472.1654234528865; Thu, 02
 Jun 2022 22:35:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220603041701.2799595-1-irogers@google.com> <CAC1LvL12oxCojWBxqCj=g+cC=UbAHoQ6kT4TQXSi1j78L5zn3g@mail.gmail.com>
 <CAEf4BzYvxvidSPa1ewWMm7rWHP=eSfu9vXz0rkbPWpBB5HpuRA@mail.gmail.com>
In-Reply-To: <CAEf4BzYvxvidSPa1ewWMm7rWHP=eSfu9vXz0rkbPWpBB5HpuRA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Jun 2022 22:35:17 -0700
Message-ID: <CAEf4BzbD0eJCOGMtBY719JzTfNQDc7k5y+2-pt6g17sJ7R4AqA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix is_pow_of_2
To:     Zvi Effron <zeffron@riotgames.com>
Cc:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Yuze Chi <chiyuze@google.com>
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

On Thu, Jun 2, 2022 at 10:33 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 2, 2022 at 9:31 PM Zvi Effron <zeffron@riotgames.com> wrote:
> >
> > On Thu, Jun 2, 2022 at 9:17 PM Ian Rogers <irogers@google.com> wrote:
> > >
> > > From: Yuze Chi <chiyuze@google.com>
> > >
> > > There is a missing not. Consider a power of 2 number like 4096:
> > >
> > > x && (x & (x - 1))
> > > 4096 && (4096 & (4096 - 1))
> > > 4096 && (4096 & 4095)
> > > 4096 && 0
> > > 0
> > >
> > > with the not this is:
> > > x && !(x & (x - 1))
> > > 4096 && !(4096 & (4096 - 1))
> > > 4096 && !(4096 & 4095)
> > > 4096 && !0
> > > 4096 && 1
> > > 1
> > >
> > > Reported-by: Yuze Chi <chiyuze@google.com>
> > > Signed-off-by: Yuze Chi <chiyuze@google.com>
> > > Signed-off-by: Ian Rogers <irogers@google.com>

also can you please add Fixes: tag?

> > > ---
> > >  tools/lib/bpf/libbpf.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 3f4f18684bd3..fd0414ea00df 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -4956,7 +4956,7 @@ static void bpf_map__destroy(struct bpf_map *map);
> > >
> > >  static bool is_pow_of_2(size_t x)
> > >  {
> > > -       return x && (x & (x - 1));
> > > +       return x && !(x & (x - 1));
>
> ugh... *facepalm*
>
> >
> > No idea if anyone cares about the consistency, but in linker.c (same directory)
> > the same static function is defined using == 0 at the end instead of using the
> > not operator.
> >
> > Aside from the consistency issue, personally I find the == 0 version a little
> > bit easier to read and understand because it's a bit less dense (and a "!" next
> > to a "(" is an easy character to overlook).
> >
>
> I agree, even more so, logical not used with arbitrary integer (not a
> pointer or bool) is a mental stumbling block for me, so much so that I
> avoid doing !strcmp(), for example.
>
> But in this case, I'm not sure why I copy/pasted is_pow_of_2() instead
> of moving the one from linker.c into libbpf_internal.h as static
> inline. Let's do that instead?
>
> > >  }
> > >
> > >  static size_t adjust_ringbuf_sz(size_t sz)
> > > --
> > > 2.36.1.255.ge46751e96f-goog
> > >
