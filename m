Return-Path: <netdev+bounces-6929-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A94E0718B95
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 23:09:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45DC21C20F7E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CEF3C081;
	Wed, 31 May 2023 21:09:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902F81640F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 21:09:17 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1413129
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:09:15 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f6a6b9bebdso24855e9.0
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685567354; x=1688159354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4iMmkUuYGN1wsHW1StSPldTBX3FYQkgI1Gpxtxyr2Uo=;
        b=GPhrX423T5+5XiyVCsehdQL0GiVyyx1i0L5dfg671U4aTQ5DldA6R7/IhwFtGLSu1p
         a2rbeXz7vpqRU49TrWHNRlUuW12I/LvpE/boLoEq+QZ3o1MYZA5mF1R6xQFKlE3BA7Oz
         Y81AyNsBUVEEBfMzSk1VY39jiE/g4T2NmBgYaR0mIPZDS44XZb5IXyyb1o334hW++dn7
         YPjrta8hBeYHQjk5PXHaTRkwdiI+trck+EEavB8lUKd4aABAqVGNjIMxtHhH0yX2G8ti
         1T427C+zWU8UnFSENDNpRYlQnK1u0KZYsx6UjgV6sro/Evgyr29/wjBSQw9HF+nSkcaJ
         8Qww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685567354; x=1688159354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4iMmkUuYGN1wsHW1StSPldTBX3FYQkgI1Gpxtxyr2Uo=;
        b=A/MqDvln8f10u4YmvlfoyRxuPfz/cvUiJhXPs5uvj5IDDSM+55yaTeVo+hvh39Ff2W
         ONXTyYvtSznwb5tIQX5gQSMmKUVNvJAgbdzOCOzMQJDrQxcoul+lSAmFPL1gfvWl1XUV
         eMH/aoIHIokgNqBRJl0O9foVdGsk+XzJ/CnqA6FZId3eCy/iRGdtZVGv+TVoBU/PPQk/
         7zoV3rZ9WdOWDRAHeXXtLVQVZo7Z8wVQW7MkS3gCW5Rn4OiSuO1Pufa5gIARIQ3s+loH
         yY8my71tIQNT5QBAP/+jxvJGlSDW0xBKxy5mDlSgvioLvWLgXGZD2Lv+EnZIlhrejc6i
         GUtg==
X-Gm-Message-State: AC+VfDznLXug84TrWPqPcO5CV5wnflR+oHaDf5nEjSNenmLMr0p/05VJ
	kYlryX0rlzJj+mhG29EmdzlzW914K9C8OoJcHVjH6w==
X-Google-Smtp-Source: ACHHUZ6WVk08Z0g3UwGrixJdrfy8qflKdJLYUsk4Bum8cy4CrqhSLspr9E7h+SZLYrZub6o3/2Nmr64JQ67btOOOxCo=
X-Received: by 2002:a05:600c:5108:b0:3f4:1dce:3047 with SMTP id
 o8-20020a05600c510800b003f41dce3047mr67525wms.2.1685567353943; Wed, 31 May
 2023 14:09:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <168553315664.20663.13753087625689463092-0@git.sr.ht> <20230531191909.95136-1-kuniyu@amazon.com>
In-Reply-To: <20230531191909.95136-1-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 31 May 2023 23:09:02 +0200
Message-ID: <CANn89iK13jkbKXv-rKiUbTqMrk3KjVPGYH_Vv7FtJJ5pTdUAYQ@mail.gmail.com>
Subject: Re: [PATCH linux] net/ipv4: ping_group_range: allow GID from
 2147483648 to 4294967294
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: akihirosuda@git.sr.ht, akihiro.suda.cz@hco.ntt.co.jp, davem@davemloft.net, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, segoon@openwall.com, suda.kyoto@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 9:19=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
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
> > In the implementation, proc_dointvec_minmax is no longer used because i=
t
> > does not support numbers from 2147483648 to 4294967294.
>
> Good catch.
>
> I think we can use proc_doulongvec_minmax() instead of open coding.
>
> With the diff below:
>
> ---8<---
> # sysctl -a | grep ping
> net.ipv4.ping_group_range =3D 0   2147483647
> # sysctl -w net.ipv4.ping_group_range=3D"0 4294967295"
> sysctl: setting key "net.ipv4.ping_group_range": Invalid argument
> # sysctl -w net.ipv4.ping_group_range=3D"0 4294967294"
> net.ipv4.ping_group_range =3D 0 4294967294
> # sysctl -a | grep ping
> net.ipv4.ping_group_range =3D 0   4294967294
> ---8<---
>
> ---8<---
> diff --git a/include/net/ping.h b/include/net/ping.h
> index 9233ad3de0ad..9b401b9a9d35 100644
> --- a/include/net/ping.h
> +++ b/include/net/ping.h
> @@ -20,7 +20,7 @@
>   * gid_t is either uint or ushort.  We want to pass it to
>   * proc_dointvec_minmax(), so it must not be larger than MAX_INT
>   */
> -#define GID_T_MAX (((gid_t)~0U) >> 1)
> +#define GID_T_MAX ((gid_t)~0U)
>
>  /* Compatibility glue so we can support IPv6 when it's compiled as a mod=
ule */
>  struct pingv6_ops {
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 6ae3345a3bdf..11d401958673 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -35,8 +35,8 @@ static int ip_ttl_max =3D 255;
>  static int tcp_syn_retries_min =3D 1;
>  static int tcp_syn_retries_max =3D MAX_TCP_SYNCNT;
>  static int tcp_syn_linear_timeouts_max =3D MAX_TCP_SYNCNT;
> -static int ip_ping_group_range_min[] =3D { 0, 0 };
> -static int ip_ping_group_range_max[] =3D { GID_T_MAX, GID_T_MAX };
> +static unsigned long ip_ping_group_range_min[] =3D { 0, 0 };
> +static unsigned long ip_ping_group_range_max[] =3D { GID_T_MAX, GID_T_MA=
X };
>  static u32 u32_max_div_HZ =3D UINT_MAX / HZ;
>  static int one_day_secs =3D 24 * 3600;
>  static u32 fib_multipath_hash_fields_all_mask __maybe_unused =3D
> @@ -165,8 +165,8 @@ static int ipv4_ping_group_range(struct ctl_table *ta=
ble, int write,
>                                  void *buffer, size_t *lenp, loff_t *ppos=
)
>  {
>         struct user_namespace *user_ns =3D current_user_ns();
> +       unsigned long urange[2];
>         int ret;
> -       gid_t urange[2];
>         kgid_t low, high;
>         struct ctl_table tmp =3D {
>                 .data =3D &urange,
> @@ -179,7 +179,7 @@ static int ipv4_ping_group_range(struct ctl_table *ta=
ble, int write,
>         inet_get_ping_group_range_table(table, &low, &high);
>         urange[0] =3D from_kgid_munged(user_ns, low);
>         urange[1] =3D from_kgid_munged(user_ns, high);
> -       ret =3D proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> +       ret =3D proc_doulongvec_minmax(&tmp, write, buffer, lenp, ppos);
>
>         if (write && ret =3D=3D 0) {
>                 low =3D make_kgid(user_ns, urange[0]);
> ---8<---


Will this work on 32bit build ?

