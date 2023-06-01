Return-Path: <netdev+bounces-6950-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9BA1718F91
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 02:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 041781C20A81
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 00:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C4E2110F;
	Thu,  1 Jun 2023 00:36:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFB41101
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 00:36:28 +0000 (UTC)
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF79911F;
	Wed, 31 May 2023 17:36:26 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-bb15165ba06so181533276.2;
        Wed, 31 May 2023 17:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685579786; x=1688171786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4sqJL/rMkklfFhbl1Ni87E9CJg3Zr6eX+Yy8CWLUH6c=;
        b=JmpQPaf/UJfzh2krStUvAzSS5hoGnhLjgYL5+8bt0LrQvqohKHDMNGHhBQkksuXphc
         BtKaVJRDr/w7bLrB9HO4B9BBc/TChvGjXA/BQBULp/8YvG3K8iIanvQwDvWfiljY/1Nn
         n0YSv4XqrJPOwpgWjZP6dC1Fk2i6eD4jIxEsnBNsPvR1N9L8ujm+f/FYrICC/8fYkNQF
         4FKJCYiQErZ5E2tOAoduTlA/tH1iDcVc5Gz3+fW1Fr96J5Eok1iV7C46BO6Crxsc3zNZ
         h0heO2MIjeQHqMsuNLuF+FF3U2yQEYVVSmVpcHStpS91Dl/GYy45CmivpfzM/BJRMvMl
         5UGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685579786; x=1688171786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4sqJL/rMkklfFhbl1Ni87E9CJg3Zr6eX+Yy8CWLUH6c=;
        b=hqhpCvHkVeVSTJOYS9RMIagf5Ykh05WYhTFWZo+0p8iFNUXKy0tNFswT0zWe22Pxr9
         dh5qrwy1k2Tfe0bAhPXClg3H6ZF8dI7feLgLBPpg3xbFtZQNTu7TO3ekAtgtCjE+bR1U
         TEAk9Px6XvpveCCgp8tb65T5i2eCxlpPbUeJfE9ivh721rOJMz+/jH9u1B1qZf78NxTB
         TvuY1re2ODcXBWdeAX7UxvnKkGjIjUEK+5bXbbRfDS2ZAdNvjyQ5cN2bLpV7vZtEAiJN
         dW8OHdtFcgnG/bSdShbi8n40zXmAWndexWF5S8EpRCz/c2EYRtpA38dyok7BjLvluqZ2
         KwnA==
X-Gm-Message-State: AC+VfDyN6FDk+gjGpfK+d5YHKrjIiBL0Ol7lS/rsNoE2mhbY47UOllBD
	pPw8SxlvxGVeDilprAEAGDeR9dvy1uaHkxBEZL50vZHNNSw=
X-Google-Smtp-Source: ACHHUZ5+fGGG1EBTvFeNQe1LCsw72dhPGvRkxGvgAcKeqpqZv7CWJ9xTS0NVogL3Uk54GeSCtR23SWMJoq8jyFhQwGo=
X-Received: by 2002:a25:764b:0:b0:ba8:26da:3147 with SMTP id
 r72-20020a25764b000000b00ba826da3147mr7214008ybc.59.1685579785840; Wed, 31
 May 2023 17:36:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iK13jkbKXv-rKiUbTqMrk3KjVPGYH_Vv7FtJJ5pTdUAYQ@mail.gmail.com>
 <20230531225947.38239-1-kuniyu@amazon.com>
In-Reply-To: <20230531225947.38239-1-kuniyu@amazon.com>
From: Akihiro Suda <suda.kyoto@gmail.com>
Date: Thu, 1 Jun 2023 09:36:14 +0900
Message-ID: <CAG8fp8TmupTpgCmjk6pWWTMbKAmeKSCLP_A_fq=3hn8JkWioww@mail.gmail.com>
Subject: Re: [PATCH linux] net/ipv4: ping_group_range: allow GID from
 2147483648 to 4294967294
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: edumazet@google.com, akihiro.suda.cz@hco.ntt.co.jp, akihirosuda@git.sr.ht, 
	davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, segoon@openwall.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I think we can use proc_doulongvec_minmax() instead of open coding.

Thanks, sent v2 with your suggestion
https://lore.kernel.org/lkml/168557950756.14226.6470993129419598644-0@git.s=
r.ht/

2023=E5=B9=B46=E6=9C=881=E6=97=A5(=E6=9C=A8) 8:00 Kuniyuki Iwashima <kuniyu=
@amazon.com>:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Wed, 31 May 2023 23:09:02 +0200
> > On Wed, May 31, 2023 at 9:19=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazo=
n.com> wrote:
> > >
> > > From: ~akihirosuda <akihirosuda@git.sr.ht>
> > > Date: Wed, 31 May 2023 19:42:49 +0900
> > > > From: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>
> > > >
> > > > With this commit, all the GIDs ("0 4294967294") can be written to t=
he
> > > > "net.ipv4.ping_group_range" sysctl.
> > > >
> > > > Note that 4294967295 (0xffffffff) is an invalid GID (see gid_valid(=
) in
> > > > include/linux/uidgid.h), and an attempt to register this number wil=
l cause
> > > > -EINVAL.
> > > >
> > > > Prior to this commit, only up to GID 2147483647 could be covered.
> > > > Documentation/networking/ip-sysctl.rst had "0 4294967295" as an exa=
mple
> > > > value, but this example was wrong and causing -EINVAL.
> > > >
> > > > In the implementation, proc_dointvec_minmax is no longer used becau=
se it
> > > > does not support numbers from 2147483648 to 4294967294.
> > >
> > > Good catch.
> > >
> > > I think we can use proc_doulongvec_minmax() instead of open coding.
> > >
> > > With the diff below:
> > >
> > > ---8<---
> > > # sysctl -a | grep ping
> > > net.ipv4.ping_group_range =3D 0   2147483647
> > > # sysctl -w net.ipv4.ping_group_range=3D"0 4294967295"
> > > sysctl: setting key "net.ipv4.ping_group_range": Invalid argument
> > > # sysctl -w net.ipv4.ping_group_range=3D"0 4294967294"
> > > net.ipv4.ping_group_range =3D 0 4294967294
> > > # sysctl -a | grep ping
> > > net.ipv4.ping_group_range =3D 0   4294967294
> > > ---8<---
> > >
> > > ---8<---
> > > diff --git a/include/net/ping.h b/include/net/ping.h
> > > index 9233ad3de0ad..9b401b9a9d35 100644
> > > --- a/include/net/ping.h
> > > +++ b/include/net/ping.h
> > > @@ -20,7 +20,7 @@
> > >   * gid_t is either uint or ushort.  We want to pass it to
> > >   * proc_dointvec_minmax(), so it must not be larger than MAX_INT
> > >   */
> > > -#define GID_T_MAX (((gid_t)~0U) >> 1)
> > > +#define GID_T_MAX ((gid_t)~0U)
> > >
> > >  /* Compatibility glue so we can support IPv6 when it's compiled as a=
 module */
> > >  struct pingv6_ops {
> > > diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> > > index 6ae3345a3bdf..11d401958673 100644
> > > --- a/net/ipv4/sysctl_net_ipv4.c
> > > +++ b/net/ipv4/sysctl_net_ipv4.c
> > > @@ -35,8 +35,8 @@ static int ip_ttl_max =3D 255;
> > >  static int tcp_syn_retries_min =3D 1;
> > >  static int tcp_syn_retries_max =3D MAX_TCP_SYNCNT;
> > >  static int tcp_syn_linear_timeouts_max =3D MAX_TCP_SYNCNT;
> > > -static int ip_ping_group_range_min[] =3D { 0, 0 };
> > > -static int ip_ping_group_range_max[] =3D { GID_T_MAX, GID_T_MAX };
> > > +static unsigned long ip_ping_group_range_min[] =3D { 0, 0 };
> > > +static unsigned long ip_ping_group_range_max[] =3D { GID_T_MAX, GID_=
T_MAX };
> > >  static u32 u32_max_div_HZ =3D UINT_MAX / HZ;
> > >  static int one_day_secs =3D 24 * 3600;
> > >  static u32 fib_multipath_hash_fields_all_mask __maybe_unused =3D
> > > @@ -165,8 +165,8 @@ static int ipv4_ping_group_range(struct ctl_table=
 *table, int write,
> > >                                  void *buffer, size_t *lenp, loff_t *=
ppos)
> > >  {
> > >         struct user_namespace *user_ns =3D current_user_ns();
> > > +       unsigned long urange[2];
> > >         int ret;
> > > -       gid_t urange[2];
> > >         kgid_t low, high;
> > >         struct ctl_table tmp =3D {
> > >                 .data =3D &urange,
> > > @@ -179,7 +179,7 @@ static int ipv4_ping_group_range(struct ctl_table=
 *table, int write,
> > >         inet_get_ping_group_range_table(table, &low, &high);
> > >         urange[0] =3D from_kgid_munged(user_ns, low);
> > >         urange[1] =3D from_kgid_munged(user_ns, high);
> > > -       ret =3D proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos)=
;
> > > +       ret =3D proc_doulongvec_minmax(&tmp, write, buffer, lenp, ppo=
s);
> > >
> > >         if (write && ret =3D=3D 0) {
> > >                 low =3D make_kgid(user_ns, urange[0]);
> > > ---8<---
> >
> >
> > Will this work on 32bit build ?
>
> It worked at least on my i686 build and qemu.
>
> ---8<---
> # uname -a
> Linux (none) 6.4.0-rc3-00648-g75455b906d82-dirty #76 SMP PREEMPT_DYNAMIC =
Wed May 31 21:30:31 UTC 2023 i686 GNU/Linux
> # sysctl -a | grep ping
> net.ipv4.ping_group_range =3D 1   0
> # sysctl -w net.ipv4.ping_group_range=3D"0 4294967295"
> sysctl: setting key "net.ipv4.ping_group_range": Invalid argument
> # sysctl -w net.ipv4.ping_group_range=3D"0 4294967294"
> net.ipv4.ping_group_range =3D 0 4294967294
> # sysctl -a | grep ping
> net.ipv4.ping_group_range =3D 0   4294967294
> ---8<---

