Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30F26E6FDE
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjDRXOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjDRXOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:14:46 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FF9270E
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:14:44 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id d21so6916490vsv.9
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681859684; x=1684451684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6bJBqnWYESL5R3rjD+q/En6p5ftpjkKPa6sA0kBJ/4I=;
        b=GQOi5Zn+AoONtEi5D+xliT+hGpuN4RcV5kGYN7mvbEt9l/BVsh3yEdwcKeIg7DjaqL
         CPy2nI9pbAHoew7P/HzwMjoCtljPi+BGP0nOef6Z5qqbm6/WZ7oOGu7fJyfRaMDcSAuY
         KL+08ugyKaR8XnrlBZID7bmun36WOMYAZgFKfvBi+Bpyg9NVKg4QDWGTJIXI+Y/0Cvd4
         T3qjlrQeq/Fl61GBy00vSsJtPxDAH3678g+vagNkJ32vVMNF+HxFHgSlA6Ug9TEHbDeF
         2S+JpQbazYiIDsYCn7/o2z69KNKEuTXKpOZP0WiMD2WR2C6Dx3707K4/du3v6knI+oss
         bDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681859684; x=1684451684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6bJBqnWYESL5R3rjD+q/En6p5ftpjkKPa6sA0kBJ/4I=;
        b=AJFzQbAkw7PEMoU3Wgam3kQpCBP+F66tDEAJgvpqrBeq9JEp+doSe4ZHMfg42+TASQ
         2DieCnrMCecn9U8P0d2SOaEFNZ38Hcc8cJANiSQSdxeWkx+4XVjkvT/HyRWBc5AaQpKB
         LDVTdsYzzI8gOr+vh+YJqNWbfu0J3cRBu2KD8jdHmVWtpedciMBEGCC7jNXR+Vur7zzl
         LdWpzIbxg/B2SnNQUg7uyqbyCu4yjOghsiepchwFB/YjDL9GuGw/NLu7rfQrCiALVTlG
         IJ3JL/Z6LxZ14RRkZyfvQeN+hTdmbBl7hlu4uK9o/2bfuwCbtYPWOtieOpLlaHvE3IvT
         27/Q==
X-Gm-Message-State: AAQBX9cXDKpI5DZNnLHoZm6Abv+4E2fyrEhFPG9Y2LDyqGpKfwyylnyU
        tZIYo35Wno6ek3ULhhOOGvBO5vA8I/qkWKiXDWoF3g==
X-Google-Smtp-Source: AKy350ZWbaO/xdu5SZrMy9STy/Vit9mbcxiyDFbxTZJHPKp8xjRYUeUYijVf3/qUtfbFps+Y5ERmR1Pcs2qTjTnORJU=
X-Received: by 2002:a67:c21a:0:b0:42e:668a:2884 with SMTP id
 i26-20020a67c21a000000b0042e668a2884mr6853253vsj.7.1681859683922; Tue, 18 Apr
 2023 16:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230417204407.2463297-1-maheshb@google.com> <20230418183339.83599-1-kuniyu@amazon.com>
In-Reply-To: <20230418183339.83599-1-kuniyu@amazon.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 18 Apr 2023 16:14:17 -0700
Message-ID: <CAF2d9jihubh_MJ+FwKfX3g45LidbBnU_cyF2ADEMdDZ3X3kTFQ@mail.gmail.com>
Subject: Re: [PATCH next] ipv6: add icmpv6_error_anycast_as_unicast for ICMPv6
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     corbet@lwn.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, mahesh@bandewar.net,
        maze@google.com, netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 11:34=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon.c=
om> wrote:
>
> From:   Mahesh Bandewar <maheshb@google.com>
> Date:   Mon, 17 Apr 2023 13:44:07 -0700
> > ICMPv6 error packets are not sent to the anycast destinations and this
> > prevents things like traceroute from working. So create a setting simil=
ar
> > to ECHO when dealing with Anycast sources (icmpv6_echo_ignore_anycast).
> >
> > Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> > CC: Maciej =C5=BBenczykowski <maze@google.com>
> > ---
> >  Documentation/networking/ip-sysctl.rst |  7 +++++++
> >  include/net/netns/ipv6.h               |  1 +
> >  net/ipv6/af_inet6.c                    |  1 +
> >  net/ipv6/icmp.c                        | 13 +++++++++++--
> >  4 files changed, 20 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/net=
working/ip-sysctl.rst
> > index 87dd1c5283e6..e97896d38e9f 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -2719,6 +2719,13 @@ echo_ignore_anycast - BOOLEAN
> >
> >       Default: 0
> >
> > +error_anycast_as_unicast - BOOLEAN
> > +     If set non-zero, then the kernel will respond with ICMP Errors
>
> s/non-zero/1/, see below to limit 0-1.
>
>
> > +     resulting from requests sent to it over the IPv6 protocol destine=
d
> > +     to anycast address essentially treating anycast as unicast.
> > +
> > +     Default: 0
> > +
> >  xfrm6_gc_thresh - INTEGER
> >       (Obsolete since linux-4.14)
> >       The threshold at which we will start garbage collecting for IPv6
> > diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
> > index b4af4837d80b..3cceb3e9320b 100644
> > --- a/include/net/netns/ipv6.h
> > +++ b/include/net/netns/ipv6.h
> > @@ -55,6 +55,7 @@ struct netns_sysctl_ipv6 {
> >       u64 ioam6_id_wide;
> >       bool skip_notify_on_dev_down;
> >       u8 fib_notify_on_flag_change;
> > +     u8 icmpv6_error_anycast_as_unicast;
> >  };
> >
> >  struct netns_ipv6 {
> > diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> > index 38689bedfce7..2b7ac752afc2 100644
> > --- a/net/ipv6/af_inet6.c
> > +++ b/net/ipv6/af_inet6.c
> > @@ -952,6 +952,7 @@ static int __net_init inet6_net_init(struct net *ne=
t)
> >       net->ipv6.sysctl.icmpv6_echo_ignore_all =3D 0;
> >       net->ipv6.sysctl.icmpv6_echo_ignore_multicast =3D 0;
> >       net->ipv6.sysctl.icmpv6_echo_ignore_anycast =3D 0;
> > +     net->ipv6.sysctl.icmpv6_error_anycast_as_unicast =3D 0;
> >
> >       /* By default, rate limit error messages.
> >        * Except for pmtu discovery, it would break it.
> > diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> > index f32bc98155bf..db2aef50fdf5 100644
> > --- a/net/ipv6/icmp.c
> > +++ b/net/ipv6/icmp.c
> > @@ -362,9 +362,10 @@ static struct dst_entry *icmpv6_route_lookup(struc=
t net *net,
> >
> >       /*
> >        * We won't send icmp if the destination is known
> > -      * anycast.
> > +      * anycast unless we need to treat anycast as unicast.
> >        */
> > -     if (ipv6_anycast_destination(dst, &fl6->daddr)) {
> > +     if (!net->ipv6.sysctl.icmpv6_error_anycast_as_unicast &&
>
> Please use READ_ONCE() to silence KCSAN.
>
thanks for the comments. I'll integrate them in v2.
>
> > +         ipv6_anycast_destination(dst, &fl6->daddr)) {
> >               net_dbg_ratelimited("icmp6_send: acast source\n");
> >               dst_release(dst);
> >               return ERR_PTR(-EINVAL);
> > @@ -1192,6 +1193,13 @@ static struct ctl_table ipv6_icmp_table_template=
[] =3D {
> >               .mode           =3D 0644,
> >               .proc_handler =3D proc_do_large_bitmap,
> >       },
> > +     {
> > +             .procname       =3D "error_anycast_as_unicast",
> > +             .data           =3D &init_net.ipv6.sysctl.icmpv6_error_an=
ycast_as_unicast,
> > +             .maxlen         =3D sizeof(u8),
> > +             .mode           =3D 0644,
> > +             .proc_handler =3D proc_dou8vec_minmax,
>
>                 .extra1         =3D SYSCTL_ZERO,
>                 .extra2         =3D SYSCTL_ONE
>
> > +     },
> >       { },
> >  };
> >
> > @@ -1209,6 +1217,7 @@ struct ctl_table * __net_init ipv6_icmp_sysctl_in=
it(struct net *net)
> >               table[2].data =3D &net->ipv6.sysctl.icmpv6_echo_ignore_mu=
lticast;
> >               table[3].data =3D &net->ipv6.sysctl.icmpv6_echo_ignore_an=
ycast;
> >               table[4].data =3D &net->ipv6.sysctl.icmpv6_ratemask_ptr;
> > +             table[5].data =3D &net->ipv6.sysctl.icmpv6_error_anycast_=
as_unicast;
> >       }
> >       return table;
> >  }
> > --
> > 2.40.0.634.g4ca3ef3211-goog
