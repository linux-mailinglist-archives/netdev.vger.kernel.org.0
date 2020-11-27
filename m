Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E462C614E
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 10:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgK0JCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 04:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgK0JCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 04:02:00 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33CAC0613D1;
        Fri, 27 Nov 2020 01:01:59 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id v92so3908062ybi.4;
        Fri, 27 Nov 2020 01:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LnzhICHZdVFLZlXj95yT8QtqDM8n8lX7RfvjyfJwSFA=;
        b=FeBsvxyFG9UcDjSAKCxJV/QxRTA10Si4PGHoyP3c3m/3Xg7iYM8Y2wytEM09gIenyg
         EgA5bsozFyhI0y0y3iM2jhRSSCBl5GFsPf/KF4+IbL/YLpw/VGGaTq60eOW8Lf1MzR4s
         Sl/JrllstO4dmPddOZ10nZTkh/jcyLoIAusw8XViqHi1qEHzpxp2FpVA4VwUxJ13/LUI
         6BToXfKX+NcMOJS/Ryrnd9MbfdwT9Qaq7VJBrqggAWT4zgbHPUFfkNYP7owHPjz+eJcb
         h24pTUpZqmb/UcGLgiVVtciHEsepIEL3jJWI4WCjkWv6gevaQg4xtPhE/rR0p13z/WrP
         kEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LnzhICHZdVFLZlXj95yT8QtqDM8n8lX7RfvjyfJwSFA=;
        b=H3HuNBFOE/3t2LSfpVg9D7510RUgtizqbwd2l5Sql5saCjJeX5baogpkQcQGp0Ah9E
         9Ztt0iNBgjI3qiW5U07oJodVKGwrusmNep7G8rSwWoIqFfqTvvWHtqCfw3q1nHYTNYYf
         Hmtp0CdND/26XjKq0sWxg6Oq+9kWGmjz3uOU6ctcrDLxdRXBjmPQV/t+uy69u3BYXmq+
         ZeftFgJiHp/Gk8aBXP4zcJyz9QpMwyX1Xf1C7f7/lAyts2PxnASlD1MDFkxevLDfNCaw
         mghjHgiKIzo+6UFCZ05OXRKfb6zu60gsnbfOpMTHITe07GCfhaXmU79zdlpoK7wm6AuG
         yzpg==
X-Gm-Message-State: AOAM530+Oc/bbjpx2FCJFzHt6rLp8RCHJk5JoZ5WPhe7lVMRhdu1FaeX
        o2XN/h7O4/uFHhuGP6YPO5SzC3/KknuaTeIaews=
X-Google-Smtp-Source: ABdhPJwTmui02y1nPZ7LC9rD05l67WNMzWm1CvYwnnDWCYehiWvLvq5nhP3VIM+eg+1zizBGNUlPAmWYE3GtylJz3ok=
X-Received: by 2002:a5b:c0e:: with SMTP id f14mr10934570ybq.83.1606467718968;
 Fri, 27 Nov 2020 01:01:58 -0800 (PST)
MIME-Version: 1.0
References: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
 <20201125183749.13797-3-weqaar.a.janjua@intel.com> <394e96ea-cf70-90e1-599e-eef8e613eef8@fb.com>
In-Reply-To: <394e96ea-cf70-90e1-599e-eef8e613eef8@fb.com>
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
Date:   Fri, 27 Nov 2020 09:01:33 +0000
Message-ID: <CAPLEeBZ3cd_cAw1fH0bT+CMWEA7xNXWTL7+9iwqN=CqfPp0cQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/5] selftests/bpf: xsk selftests - SKB POLL, NOPOLL
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 at 04:31, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/25/20 10:37 AM, Weqaar Janjua wrote:
> > Adds following tests:
> >
> > 1. AF_XDP SKB mode
> >     Generic mode XDP is driver independent, used when the driver does
> >     not have support for XDP. Works on any netdevice using sockets and
> >     generic XDP path. XDP hook from netif_receive_skb().
> >     a. nopoll - soft-irq processing
> >     b. poll - using poll() syscall
> >
> > Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> > ---
> >   tools/testing/selftests/bpf/Makefile     |   2 +-
> >   tools/testing/selftests/bpf/test_xsk.sh  |  36 +-
> >   tools/testing/selftests/bpf/xdpxceiver.c | 961 ++++++++++++++++++++++=
+
> >   tools/testing/selftests/bpf/xdpxceiver.h | 151 ++++
> >   tools/testing/selftests/bpf/xsk_env.sh   |  17 +
> >   5 files changed, 1158 insertions(+), 9 deletions(-)
> >   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
> >   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selft=
ests/bpf/Makefile
> > index 596ee5c27906..a2be2725be11 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -83,7 +83,7 @@ TEST_PROGS_EXTENDED :=3D with_addr.sh \
> >   # Compile but not part of 'make run_tests'
> >   TEST_GEN_PROGS_EXTENDED =3D test_sock_addr test_skb_cgroup_id_user \
> >       flow_dissector_load test_flow_dissector test_tcp_check_syncookie_=
user \
> > -     test_lirc_mode2_user xdping test_cpp runqslower bench
> > +     test_lirc_mode2_user xdping test_cpp runqslower bench xdpxceiver
> >
> >   TEST_CUSTOM_PROGS =3D urandom_read
> >
> [...]
> > +
> > +static void parse_command_line(int argc, char **argv)
> > +{
> > +     int option_index, interface_index =3D 0, c;
> > +
> > +     opterr =3D 0;
> > +
> > +     for (;;) {
> > +             c =3D getopt_long(argc, argv, "i:q:pScDC:", long_options,=
 &option_index);
> > +
> > +             if (c =3D=3D -1)
> > +                     break;
> > +
> > +             switch (c) {
> > +             case 'i':
> > +                     if (interface_index =3D=3D MAX_INTERFACES)
> > +                             break;
> > +                     char *sptr, *token;
> > +
> > +                     memcpy(ifdict[interface_index]->ifname,
> > +                            strtok_r(optarg, ",", &sptr), MAX_INTERFAC=
E_NAME_CHARS);
>
> During compilation, I hit the following compiler warnings,
>
> xdpxceiver.c: In function =E2=80=98main=E2=80=99:
> xdpxceiver.c:461:4: warning: =E2=80=98__s=E2=80=99 may be used uninitiali=
zed in this
> function [-Wmaybe-uninitialized]
>      memcpy(ifdict[interface_index]->ifname,
>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>             strtok_r(optarg, ",", &sptr), MAX_INTERFACE_NAME_CHARS);
>             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> xdpxceiver.c:443:13: note: =E2=80=98__s=E2=80=99 was declared here
>   static void parse_command_line(int argc, char **argv)
>               ^~~~~~~~~~~~~~~~~~
>
> I am using gcc8. I am not sure whether we should silence such
> warning or not (-Wno-maybe-uninitialized). Did you see such a warning
> during your compilation?
>
Most probably you have hit gcc bug 71701, we do not see this warning
as our gcc builds might be different even though mine is 8, I will try
to get rid of strtok_r to avoid the whole thing.

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D71701

> > +                     token =3D strtok_r(NULL, ",", &sptr);
> > +                     if (token)
> > +                             memcpy(ifdict[interface_index]->nsname, t=
oken,
> > +                                    MAX_INTERFACES_NAMESPACE_CHARS);
> > +                     interface_index++;
> > +                     break;
> > +             case 'q':
> > +                     opt_queue =3D atoi(optarg);
> > +                     break;
> > +             case 'p':
> > +                     opt_poll =3D 1;
> > +                     break;
> > +             case 'S':
> > +                     opt_xdp_flags |=3D XDP_FLAGS_SKB_MODE;
> > +                     opt_xdp_bind_flags |=3D XDP_COPY;
> > +                     uut =3D ORDER_CONTENT_VALIDATE_XDP_SKB;
> > +                     break;
> > +             case 'c':
> > +                     opt_xdp_bind_flags |=3D XDP_COPY;
> > +                     break;
> > +             case 'D':
> > +                     debug_pkt_dump =3D 1;
> > +                     break;
> > +             case 'C':
> > +                     opt_pkt_count =3D atoi(optarg);
> > +                     break;
> > +             default:
> > +                     usage(basename(argv[0]));
> > +                     ksft_exit_xfail();
> > +             }
> > +     }
> > +
> > +     if (!validate_interfaces()) {
> > +             usage(basename(argv[0]));
> > +             ksft_exit_xfail();
> > +     }
> > +}
> > +
> [...]
