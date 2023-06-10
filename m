Return-Path: <netdev+bounces-9760-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73BB472A782
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:38:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14FD82817B6
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35420139E;
	Sat, 10 Jun 2023 01:38:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25904137B
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:38:02 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8462E18D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:38:01 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f7f7dfc037so27565e9.0
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 18:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686361080; x=1688953080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFC/nJ4UsR3bhQCiUne8kolsUVMuxDLATSxmpuCVlLs=;
        b=XyG3/0aqASrmcnkfzCni7mBJiWrgW0J5yWRoVpKSLiTsXxsNL46uo+nRSeQNsh0kCB
         AlS6lg2YMtzsIYTpKW/tiz0sxZAz24A1VQuQNmtpAy/g1oV8WIC5vEMydn4UZ/ZcEVrN
         g9x/cJSDEwMH9SfMTItZbCpCwVBmh8MXaGc8e5jkU01WLyl1MopU1JEkMWl3JEocATpd
         sLHrgUd0i4FxdWk5av+fvydIox8vff9VkONV+UusOraK/Ix94FRYx+5nUbfh1ffjug1r
         m/8njpbdVlKSL66xg3ZjgM2oHGdc6HnnX8HmwM05EQLf2SbECu7DjfGahzL8E2DGsM2j
         fSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686361080; x=1688953080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rFC/nJ4UsR3bhQCiUne8kolsUVMuxDLATSxmpuCVlLs=;
        b=A+G1IW4J7ukeklsvXhsm2P92ewC3fLwI4DDLSCLi5+3SBuYkMuPmeUl2Um0E2aYxyQ
         WOwdhf7kjKo+lvGdQaFomimaxMD2AroQYace4GrVfqgumGqsLHNzYc4JSKZTm07LM0ec
         y5+QSYbBuLJ52sYVuoOqX/oEWaE4oOdQ/CpBPJQ6Kf6kIJkdyiJkpm9KJqQ7ox3wgo0l
         c/DJbkPQYh19KPuheyqe3edMdhBct9SL8rT+pWp4KODdTeyfd8c4Rea0VES+MTCe4NDy
         TL4ur1LPSo4QnPOoDFlseWHuyojp3hewRmSvX8QYYjDZaGQR49kyv9HEX2/owm/ESStW
         ZFLw==
X-Gm-Message-State: AC+VfDwh55pybwsaQSMIiPQdsVlAwzdjsgmmXzx6Z87Hvs/kX/vLBjwF
	/Gmmwqx90OSd/Ilgia6VNHGP2eq7wBljoMEzkgFyJQ==
X-Google-Smtp-Source: ACHHUZ4Ey6pniPNS3a5SQnbBnwiaiCc7yqFTg819E/BL85tDq6JYywPAqDeeOa+QBmlH3d+nAPrIRL5b8lImq6/qXgA=
X-Received: by 2002:a05:600c:3d86:b0:3f1:70d1:21a6 with SMTP id
 bi6-20020a05600c3d8600b003f170d121a6mr47717wmb.0.1686361079833; Fri, 09 Jun
 2023 18:37:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609204706.2044591-1-mfreemon@cloudflare.com> <20230609174213.0759cac8@hermes.local>
In-Reply-To: <20230609174213.0759cac8@hermes.local>
From: Eric Dumazet <edumazet@google.com>
Date: Sat, 10 Jun 2023 03:37:31 +0200
Message-ID: <CANn89iJb9zug7u1B042GM3XJ2T_4M0mmfz6Rhy41QvvGoBMKPg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] tcp: enforce receive buffer memory limits by
 allowing the tcp window to shrink
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Mike Freemon <mfreemon@cloudflare.com>, netdev@vger.kernel.org, 
	kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 10, 2023 at 2:42=E2=80=AFAM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri,  9 Jun 2023 15:47:06 -0500
> Mike Freemon <mfreemon@cloudflare.com> wrote:
>
> > +     {
> > +             .procname       =3D "tcp_shrink_window",
> > +             .data           =3D &init_net.ipv4.sysctl_tcp_shrink_wind=
ow,
> > +             .maxlen         =3D sizeof(u8),
> > +             .mode           =3D 0644,
> > +             .proc_handler   =3D proc_dou8vec_minmax,
> > +             .extra1         =3D SYSCTL_ZERO,
> > +             .extra2         =3D SYSCTL_ONE,
> > +     },
>
> NAK on introducing another sysctl.

We respectfully disagree.

A sysctl makes a lot of sense to us, as it allows us to not break many
packetdrill tests.

