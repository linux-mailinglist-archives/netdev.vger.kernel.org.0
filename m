Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04B41B837D
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 05:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgDYDlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 23:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726040AbgDYDlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 23:41:00 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A586AC09B04A;
        Fri, 24 Apr 2020 20:41:00 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id w18so5774166qvs.3;
        Fri, 24 Apr 2020 20:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eNiqUjT2D3DVZlIGZS8qj2BAwx22UeeEYj8LOV+TNJA=;
        b=UwEeTU32GC5OyBAmuuA9WXaqSHhXEoU/o+CY1NmK1s7rLBgLYOdbE1cJwU3RxpE/UP
         AR6EZEI8Tiz4sfABT5/xbnPxeIBATy23u4S34arFAY5O2xr15L2Pl14rpRgW4zOENoS8
         GWd3lVJo7/dSg2LDTjpSIqJ5+VSa9WK5+lKfiutk3tcma7faVPcreAKDgLqRcRrysf9j
         gW8Ud9s1I5PpcnCeCByH09g6LBxygtrop1Dbgcq+HtQ6omM+O8vKHG2+/uds8i3CsGwM
         vAJTmDHFajqTiztmfp1LQyslsdL4d3kxhYQQU/pO2rUY7/qFtlBb+wO9KM3J4MMsG6px
         P/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eNiqUjT2D3DVZlIGZS8qj2BAwx22UeeEYj8LOV+TNJA=;
        b=ugvBSuohon/vUkOsi7WarqHVdax/xjzGTfuebRME3ZWhV0OOl+BsoRhS4fv7TExxH1
         WMQsxtmnBDwtn58SPLzc3ecOX6Iw5rxSVXDjTo+Zi0Joo2c9KnqALIZljfWR50GGjdgv
         7reUWvya48Tp0R6dNeF5OyhdYS6NcV9+p98raTFdwXjHocyw96RdxLJxiLIVMZquAUkc
         PIlOoXSTlbhe7Pxfjp9KYMxAB0/7cv39JWz/HaQLD0iKX32IikEBgOU2al01hL7ATH/F
         zE6D41FJkltVSUCqbiQTSmNrKJTvrrYT38Zjaj+1ZFKarafLKihoU2La6bSY4zKn234s
         Gmog==
X-Gm-Message-State: AGi0PubjNydJBkodvc3Nvx5p9FB9saz1yru9j2rWx8mHsfoinXmucEg9
        hHLqohJRXOaunxi20a9njEAjpCGvIrQiXFwzHoY=
X-Google-Smtp-Source: APiQypLOGggKyL2sr4TvcerJGN7FTsf2IyRG7iSIWWcw3lsm7Qyqij8ETv+TJpGm3RjrdH5q5emPMB6pIwywVo5mQO0=
X-Received: by 2002:a0c:b651:: with SMTP id q17mr11730679qvf.135.1587786059944;
 Fri, 24 Apr 2020 20:40:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200424121051.5056-1-geert@linux-m68k.org> <d2c14a2d-4e7b-d36a-be90-e987b1ea6183@gmail.com>
 <CAMuHMdWVmP04cXEgAkOc9Qdb2Y2xjGd1YEOcMt7ehE70ZwdqjQ@mail.gmail.com>
 <87ftcs3k90.fsf@toke.dk> <CAMuHMdUpQ1h5gapkzoX191hgxSQ814TfwcuPAmm8hOKSwk0RHA@mail.gmail.com>
In-Reply-To: <CAMuHMdUpQ1h5gapkzoX191hgxSQ814TfwcuPAmm8hOKSwk0RHA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 25 Apr 2020 11:40:23 +0800
Message-ID: <CAMDZJNXtPdZ=5zi5MasRhR5WLMZ1BT0uYxFPwb_wosKVgc5QZA@mail.gmail.com>
Subject: Re: [PATCH] net: openvswitch: use do_div() for 64-by-32 divisions:
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, ovs dev <dev@openvswitch.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 25, 2020 at 1:54 AM Geert Uytterhoeven <geert@linux-m68k.org> w=
rote:
>
> Hi Toke,
>
> On Fri, Apr 24, 2020 at 6:45 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> > Geert Uytterhoeven <geert@linux-m68k.org> writes:
> > > On Fri, Apr 24, 2020 at 5:05 PM Eric Dumazet <eric.dumazet@gmail.com>=
 wrote:
> > >> On 4/24/20 5:10 AM, Geert Uytterhoeven wrote:
> > >> > On 32-bit architectures (e.g. m68k):
> > >> >
> > >> >     ERROR: modpost: "__udivdi3" [net/openvswitch/openvswitch.ko] u=
ndefined!
> > >> >     ERROR: modpost: "__divdi3" [net/openvswitch/openvswitch.ko] un=
defined!
> > >> >
> > >> > Fixes: e57358873bb5d6ca ("net: openvswitch: use u64 for meter buck=
et")
> > >> > Reported-by: noreply@ellerman.id.au
> > >> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > >> > ---
> > >> >  net/openvswitch/meter.c | 2 +-
> > >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >> >
> > >> > diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> > >> > index 915f31123f235c03..3498a5ab092ab2b8 100644
> > >> > --- a/net/openvswitch/meter.c
> > >> > +++ b/net/openvswitch/meter.c
> > >> > @@ -393,7 +393,7 @@ static struct dp_meter *dp_meter_create(struct=
 nlattr **a)
> > >> >                * Start with a full bucket.
> > >> >                */
> > >> >               band->bucket =3D (band->burst_size + band->rate) * 1=
000ULL;
> > >> > -             band_max_delta_t =3D band->bucket / band->rate;
> > >> > +             band_max_delta_t =3D do_div(band->bucket, band->rate=
);
> > >> >               if (band_max_delta_t > meter->max_delta_t)
> > >> >                       meter->max_delta_t =3D band_max_delta_t;
> > >> >               band++;
> > >> >
> > >>
> > >> This is fascinating... Have you tested this patch ?
> > >
> > > Sorry, I should have said this is compile-tested only.
> > >
> > >> Please double check what do_div() return value is supposed to be !
> > >
> > > I do not have any openvswitch setups, let alone on the poor m68k box.
> >
> > I think what Eric is referring to is this, from the documentation of
> > do_div:
> >
> >  * do_div - returns 2 values: calculate remainder and update new divide=
nd
> >  * @n: uint64_t dividend (will be updated)
> >  * @base: uint32_t divisor
> >  *
> >  * Summary:
> >  * ``uint32_t remainder =3D n % base;``
> >  * ``n =3D n / base;``
> >  *
> >  * Return: (uint32_t)remainder
>
> Oops, that was a serious brain fart. Sorry for that!
>
> That should have been div_u64() instead of do_div().
> Feel free to update my patch while applying, else I'll send a v2 later.
>
> /me hides in a brown paper bag for the whole weekend...
I sent the patch with updated, change the reported tag, test it, and
add more commit msg,
and author should be you. Thanks.
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                 -- Linus Torvalds



--=20
Best regards, Tonghao
