Return-Path: <netdev+bounces-6978-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B723719147
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0E471C20FD6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241F45383;
	Thu,  1 Jun 2023 03:25:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120414C83
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:25:37 +0000 (UTC)
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9475CC9;
	Wed, 31 May 2023 20:25:32 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 3f1490d57ef6-ba818eb96dcso284521276.0;
        Wed, 31 May 2023 20:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685589932; x=1688181932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1075G3HvSg/kvHdmmCcsIFr2YDRXoh3FI/k1IiFmQCg=;
        b=G8s7iRtzkkILLueWvrQxne0xcEFcpNJrcdR/YeaVrghsHmRQjtzV4lOb44UqaSlk5O
         g+8TIdrrmZ916KDcK1zR0q7qc5a6uSmgH6Fs8FXNUWCfGKe97FclYordRz6Z0+vzJlti
         gXItJkQurx+CDCuhL13EGYJZVebGTB7pv4WCWD8RzVtIQR0KwUIcI/PjUxINHx41zlew
         UjnHx9ShOY3ioU2O6DAKlXiEhXwEHZvtpK5eigAWGIHDnrd5M6Aiy719f9mTj//b6v1L
         f66yUtf43J0J3P0lGKTLH6vpfaw88bHKy+Rzay/3agJY/mCUpy7MQbmN3cUJdKbqNwHu
         zeQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685589932; x=1688181932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1075G3HvSg/kvHdmmCcsIFr2YDRXoh3FI/k1IiFmQCg=;
        b=KPIKA+Nt8ruu0KC1jUe7ujqAfb1wkc3WM0X+MucMcYz7EMa/6TG8uwlEpDKi0EwS0h
         BpQdAtqHr2NoQNmYy2aENwIwq14OQDTTFe2P/ic9k287FVWV5AqsXDwYUgXVaGkl9XWL
         4I/Lepko5DyZf8KzUeocOQF7XEVo2GqRvem1q8M5MIFHYkHQvNZEKD6lPraVn7CTlBbG
         KfVIEgS5DoY/tCEy8M8iyde6S4xKKN62nnZqDJJNVw/wBgpqLm3l1vIjE8ZAz9sZYDCz
         0pZ1rcJYIRr7EO+CgkVtrUxFrUDP9Ul7cfR6oLTq5EuB7KNtGqFvRb6zV+7LUWhYAdn1
         fQqw==
X-Gm-Message-State: AC+VfDwrShl9hCnQCmomM8s1xjoHcO+y9KpjejAx/yJ9ReGOoPalrafK
	659U8MC7ITp+ZSWuS2LNPjdqI8HnS+97fJLzmlY=
X-Google-Smtp-Source: ACHHUZ7dB0ExZANHMOCXMBLjVatsOxCNoXw4FyZluu58OkcExYMv1y4Ju5SZSyN+Q2dfeGWmh+J8mwzxfQilEMVMSh4=
X-Received: by 2002:a25:e713:0:b0:b72:4ca:b3ce with SMTP id
 e19-20020a25e713000000b00b7204cab3cemr7594658ybh.16.1685589931691; Wed, 31
 May 2023 20:25:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <168557950756.14226.6470993129419598644-0@git.sr.ht> <20230601012708.69681-1-kuniyu@amazon.com>
In-Reply-To: <20230601012708.69681-1-kuniyu@amazon.com>
From: Akihiro Suda <suda.kyoto@gmail.com>
Date: Thu, 1 Jun 2023 12:25:20 +0900
Message-ID: <CAG8fp8TExDuswLyBaudhAuSG9NEyPKf3=QbUGb8Gq1KtBt6Tag@mail.gmail.com>
Subject: Re: [PATCH linux v2] net/ipv4: ping_group_range: allow GID from
 2147483648 to 4294967294
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: akihirosuda@git.sr.ht, akihiro.suda.cz@hco.ntt.co.jp, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, segoon@openwall.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thanks, submitted v3 with your suggestions
https://patchwork.kernel.org/project/netdevbpf/patch/20230601031305.55901-1=
-akihiro.suda.cz@hco.ntt.co.jp/

2023=E5=B9=B46=E6=9C=881=E6=97=A5(=E6=9C=A8) 10:27 Kuniyuki Iwashima <kuniy=
u@amazon.com>:
>
> From: ~akihirosuda <akihirosuda@git.sr.ht>
> Date: Wed, 31 May 2023 19:42:49 +0900
> > From: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>
> >
> > With this commit, all the GIDs ("0 4294967294") can be written to the
> > "net.ipv4.ping_group_range" sysctl.
> >
> > Note that 4294967295 (0xffffffff) is an invalid GID (see gid_valid() in
> > include/linux/uidgid.h), and an attempt to register this number will ca=
use
> > -EINVAL.
> >
> > Prior to this commit, only up to GID 2147483647 could be covered.
> > Documentation/networking/ip-sysctl.rst had "0 4294967295" as an example
> > value, but this example was wrong and causing -EINVAL.
> >
> > v1->v2: Simplified the patch (Thanks to Kuniyuki Iwashima for suggestio=
n)
>
> Changelog should be placed under '---'.
>
> Also could you use 'net' instead of 'linux' in Subject so that
> patchwork will be happy ?
>
> https://patchwork.kernel.org/project/netdevbpf/patch/168557950756.14226.6=
470993129419598644-0@git.sr.ht/
>
>
> >
> > Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
> > Signed-off-by: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>
> > ---
> >  Documentation/networking/ip-sysctl.rst | 4 ++--
> >  include/net/ping.h                     | 6 +-----
> >  net/ipv4/sysctl_net_ipv4.c             | 8 ++++----
> >  3 files changed, 7 insertions(+), 11 deletions(-)
> >
> > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/net=
working/ip-sysctl.rst
> > index 6ec06a33688a..80b8f73a0244 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -1352,8 +1352,8 @@ ping_group_range - 2 INTEGERS
> >       Restrict ICMP_PROTO datagram sockets to users in the group range.
> >       The default is "1 0", meaning, that nobody (not even root) may
> >       create ping sockets.  Setting it to "100 100" would grant permiss=
ions
> > -     to the single group. "0 4294967295" would enable it for the world=
, "100
> > -     4294967295" would enable it for the users, but not daemons.
> > +     to the single group. "0 4294967294" would enable it for the world=
, "100
> > +     4294967294" would enable it for the users, but not daemons.
> >
> >  tcp_early_demux - BOOLEAN
> >       Enable early demux for established TCP sockets.
> > diff --git a/include/net/ping.h b/include/net/ping.h
> > index 9233ad3de0ad..bc7779262e60 100644
> > --- a/include/net/ping.h
> > +++ b/include/net/ping.h
> > @@ -16,11 +16,7 @@
> >  #define PING_HTABLE_SIZE     64
> >  #define PING_HTABLE_MASK     (PING_HTABLE_SIZE-1)
> >
> > -/*
> > - * gid_t is either uint or ushort.  We want to pass it to
> > - * proc_dointvec_minmax(), so it must not be larger than MAX_INT
> > - */
> > -#define GID_T_MAX (((gid_t)~0U) >> 1)
> > +#define GID_T_MAX (((gid_t)~0U) - 1)
> >
> >  /* Compatibility glue so we can support IPv6 when it's compiled as a m=
odule */
> >  struct pingv6_ops {
> > diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> > index 40fe70fc2015..bb49d9407c45 100644
> > --- a/net/ipv4/sysctl_net_ipv4.c
> > +++ b/net/ipv4/sysctl_net_ipv4.c
> > @@ -34,8 +34,8 @@ static int ip_ttl_min =3D 1;
> >  static int ip_ttl_max =3D 255;
> >  static int tcp_syn_retries_min =3D 1;
> >  static int tcp_syn_retries_max =3D MAX_TCP_SYNCNT;
> > -static int ip_ping_group_range_min[] =3D { 0, 0 };
> > -static int ip_ping_group_range_max[] =3D { GID_T_MAX, GID_T_MAX };
> > +static long ip_ping_group_range_min[] =3D { 0, 0 };
> > +static long ip_ping_group_range_max[] =3D { GID_T_MAX, GID_T_MAX };
>
> nit: s/long/unsigned long/
>
> Then, add
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
>
> Thanks!
>
>
> >  static u32 u32_max_div_HZ =3D UINT_MAX / HZ;
> >  static int one_day_secs =3D 24 * 3600;
> >  static u32 fib_multipath_hash_fields_all_mask __maybe_unused =3D
> > @@ -165,7 +165,7 @@ static int ipv4_ping_group_range(struct ctl_table *=
table, int write,
> >  {
> >       struct user_namespace *user_ns =3D current_user_ns();
> >       int ret;
> > -     gid_t urange[2];
> > +     unsigned long urange[2];
> >       kgid_t low, high;
> >       struct ctl_table tmp =3D {
> >               .data =3D &urange,
> > @@ -178,7 +178,7 @@ static int ipv4_ping_group_range(struct ctl_table *=
table, int write,
> >       inet_get_ping_group_range_table(table, &low, &high);
> >       urange[0] =3D from_kgid_munged(user_ns, low);
> >       urange[1] =3D from_kgid_munged(user_ns, high);
> > -     ret =3D proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> > +     ret =3D proc_doulongvec_minmax(&tmp, write, buffer, lenp, ppos);
> >
> >       if (write && ret =3D=3D 0) {
> >               low =3D make_kgid(user_ns, urange[0]);
> > --
> > 2.38.4
>

