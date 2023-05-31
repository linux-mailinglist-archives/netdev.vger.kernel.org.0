Return-Path: <netdev+bounces-6663-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F79571755F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:25:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43E6928125B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 04:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C912108;
	Wed, 31 May 2023 04:25:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBDC1FBF
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 04:25:48 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E59121
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:25:47 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f606e111d3so22935e9.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685507145; x=1688099145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihDrGOWJ/NS2B8HAbfxw019GmilYfUxTgH9b5dT8Yc8=;
        b=GgcnKR9gHO/Zjo6JvUryJNQVVxjF6qMg4EJWMitJQftVqeLBdSLGrTrSdWMpXtddTa
         4FOZAXQzC2HMKeCmO8TqEpd4I7uz8aJtslYe3xPfxQOwdhIAwyyRFf3F9cVasts+Oaoi
         sV6V+Bz3sgoxbjLSaN+oqR3v7rcsTxlxjfnhLrMl833SP9Xmf8BwFpClR/5FgpaytMGA
         ufNLJptoGpHNjjEcAbbM6H5qTf1u/o2JKtww7Yw20NvnxgEGd1XtJuFlKztkZvhvNUyo
         yWjJ34YLZUwBliKh6y2hMXcRacZ6kkaVz59AhjCEpPtOKJC4g/PhJJU7sxQRe1nFbeOY
         FQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685507145; x=1688099145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ihDrGOWJ/NS2B8HAbfxw019GmilYfUxTgH9b5dT8Yc8=;
        b=gh52QHU/KvTA0GOVl0fU7dqqtMYnKDLkT4WW8zvAheo4qSrZ3FYQ1OkPmRdoqNEwwx
         S1adwIlqlSCqa2UTASlW0s41+/a2ef9XDOVkrkxvpsJ2gt3ibVqff/0ygkL7GpiOWz1B
         fvPoZzp9TjuCQrdULpA69r34vIWHbG8FMhf4yAE4SfEfYP+7XYyl4+jERrXVu5RVfJbp
         kotOR795jJ8A5jwDvA1sHdRAz/zZ6KYow2xyJ8UIPcegEpgh0fz98KF4SkkpjAHsli8T
         /4TtdrarGdqI1B6h6m/1/90QrNjCrP6aV1byjJLtt37qYSIfxPqot9GH7hc6BI7xJuxu
         C90w==
X-Gm-Message-State: AC+VfDwRULhmpT8apEkI49JS62QLN11zZNajRldxwGYeFHlcgonsKsmT
	xg8ufuAyEXhlfBWwWmlh7+5izKdqNjUqOs4mMwDMvQ==
X-Google-Smtp-Source: ACHHUZ60bwThhRfQUS/XQ9fL4XO4ZTL9QP4ixlbPl+keazP8IHgd4OeBZdiUK1bYKF3wIDanKAudx/2YYnydCrl+eZw=
X-Received: by 2002:a05:600c:5129:b0:3f2:4fd2:e961 with SMTP id
 o41-20020a05600c512900b003f24fd2e961mr99526wms.0.1685507145345; Tue, 30 May
 2023 21:25:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530151401.621a8498@kernel.org> <20230531010130.43390-1-kuniyu@amazon.com>
In-Reply-To: <20230531010130.43390-1-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 31 May 2023 06:25:33 +0200
Message-ID: <CANn89iKK4Si92z91ACV_mgh4vqbecxQCHmB-SYEbq6Bsqei_Qg@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 00/14] udp: Farewell to UDP-Lite.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: kuba@kernel.org, davem@davemloft.net, dsahern@kernel.org, 
	kuni1840@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 3:01=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Tue, 30 May 2023 15:14:01 -0700
> > On Tue, 30 May 2023 16:16:20 -0400 Willem de Bruijn wrote:
> > > Is it a significant burden to keep the protocol, in case anyone is
> > > willing to maintain it?
> > >
> > > If consensus is that it is time to remove, a warning may not be
> > > sufficient for people to notice.
> > >
> > > Perhaps break it, but in a way that can be undone trivially,
> > > preferably even without recompiling the kernel. Say, returning
> > > EOPNOTSUPP on socket creation, unless a sysctl has some magic
> > > non-deprecated value. But maybe I'm overthinking it. There must be
> > > prior art for this?
> >
> > It may be the most intertwined feature we attempted to remove.
> > UFO was smaller, right?
> >
> > Did deprecation warnings ever work?
> >
> > How about we try to push a WARN_ONCE() on socket creation to net and
> > stable? With a message along the lines of "UDP lite is assumed to have
> > no users, and is been deleted, please contact netdev@.."
> >
> > Then delete the whole thing in net-next? Hopefully pushing to stable
> > would expedite user reports? We'll find out if Greg throws rotten fruit
> > at us or not..
>
> Yes, if it's ok, it would be better to add a WARN_ONCE() to stable.
>
> If we added it only in net-next, no one might notice it and we could
> remove UDP-Lite before the warning is available in the next LTS stable
> tree.

WARN_ONCE() will fire a syzbot report.

Honestly I do not  think UDP-Lite is a significant burden.

What about instead adding a CONFIG_UDPLITE and default it to
"CONFIG_UDPLITE is not set" ?

And add a static key, with /proc/sys/net/core/udplite_enable to
eventually save some cycles in various fast paths
and let the user opt-in, in case it is using a distro kernel. with
CONFIG_UDPLITE=3Dy

DCCP is more interesting because removing it would allow for a better
organisation of tcp fields to reduce
number of cache lines hit in the fast path.

