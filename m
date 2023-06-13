Return-Path: <netdev+bounces-10526-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9573172ED9A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:05:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 598AF280F9C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68ABB3C086;
	Tue, 13 Jun 2023 21:05:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D563174FA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 21:05:48 +0000 (UTC)
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A8A19A8
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:05:46 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-33bf12b5fb5so11285ab.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686690346; x=1689282346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T9bwhLWaPErvlXQuP18ogPD4bTWrdunjPBBykpXpY3E=;
        b=QNkbSddv+IUCMwfZtVWexUViZ+d4Gy5tbnjLHSDWcUE59ZHfoPpBbKHZ9CA46uftey
         Nxzm+kJWVEeRhLI5/LdethGupQDwtYRLoF5MOM7hYNjfbEaVPdr7RzM6S/VZwDPBjsQ+
         weJD5FKgOrqEWLUFOdKZT8dOizK9NgUB1Lv38YmliQ6nXDiK/YCNGXPnZPMvw8BZJBah
         4tx3NwjrDqlpAuYiHX3gM4H3DLaywXKDH1IsFwAy93sBcYbCS0KujTZKL/2rHdHvvVdu
         bHYq276uMzoEjdRMcjKHTWK78NGUxuCa9E7Ot52w2Nq0e7LtfOlXNcr20wErscM/9tGs
         Joag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686690346; x=1689282346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T9bwhLWaPErvlXQuP18ogPD4bTWrdunjPBBykpXpY3E=;
        b=VbcBHlC8rW1nG+qP7YuZ9pdQNQaKVbfz8tBjAZj8b7ouMyWY5TYzNJmpSTqPtgXE59
         UJuAWMqO4gNlNkiHcUhxzGZU+icBNLfaTRGLxZN6nCu4HhiqnjP7yfdb7woyKhkn5neo
         fYCwYZfbh1wG4mWQez8k2B2gGzVi1HKdScbnco1IWE+Q4BOJe5ZZmfqEGeseOIG6ffBT
         yGNohi2GqlAKSSONi6l5ocfOt1D4rcj8r88IHqVGBinrlLRjGqETUsvdW93S1NpstSBm
         hAz3datHG2RwtLKWs6bEr4n2q2tqpNcbsFZmmnteGxxsnoKW/Nw3Jp6C0a1H8o89RZka
         YhAQ==
X-Gm-Message-State: AC+VfDzY3z5c9QM7J/zDKgyFL4ChZaNHhtPsjwwgHAIANgbDwLWupzZ0
	cC8E/ZpEQ4xHrnNOP6c79iokxafk+fyo0dm257GbylBw0nd4YOUDx0hKyw==
X-Google-Smtp-Source: ACHHUZ5Ia+cJYzqMmgtBPlJTMaXmnasp3VxfFZsEVs7dgGVbObotDgGAo4tVJozvELubF+oWn6/RUlw0W3ZYxfjprIs=
X-Received: by 2002:a05:6e02:1a62:b0:33e:2907:c62d with SMTP id
 w2-20020a056e021a6200b0033e2907c62dmr57164ilv.6.1686690346030; Tue, 13 Jun
 2023 14:05:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230613165654.3e75eda8@espresso.lan.box> <CANn89i+5DoHFh-2MvLy740ikLdV-sE8pEEM+R=i0i77Pyc1ADQ@mail.gmail.com>
In-Reply-To: <CANn89i+5DoHFh-2MvLy740ikLdV-sE8pEEM+R=i0i77Pyc1ADQ@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 13 Jun 2023 23:05:34 +0200
Message-ID: <CANn89iKzZsyT-C-Ge6nPzC9Oo0f+gf5HZXbmXnePvSi+v4vuUg@mail.gmail.com>
Subject: Re: panic in udp_init() when using FORCE_NR_CPUS
To: Ricardo Nabinger Sanchez <rnsanchez@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 10:19=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Tue, Jun 13, 2023 at 9:56=E2=80=AFPM Ricardo Nabinger Sanchez
> <rnsanchez@gmail.com> wrote:
> >
> > Hello,
> >
> > I have hit again an old panic that, in the past, I could not check in
> > more depth.  But today I was able to pinpoint to a single config knob:
> >
> > $ diff -u /mnt/tmp/Kernel/linux-6.4-rc6/.config{.old,}
> > --- /mnt/tmp/Kernel/linux-6.4-rc6/.config.old   2023-06-13
> > 10:34:11.881004307 -0300 +++
> > /mnt/tmp/Kernel/linux-6.4-rc6/.config   2023-06-13
> > 13:42:46.396967635 -0300 @@ -4996,7 +4996,7 @@ CONFIG_SGL_ALLOC=3Dy
> >  CONFIG_CHECK_SIGNATURE=3Dy
> >  CONFIG_CPUMASK_OFFSTACK=3Dy
> > -CONFIG_FORCE_NR_CPUS=3Dy
> > +# CONFIG_FORCE_NR_CPUS is not set
> >  CONFIG_CPU_RMAP=3Dy
> >  CONFIG_DQL=3Dy
> >  CONFIG_GLOB=3Dy
> >
>
> Sure, but you did not give NR_CPUS value ?

I suspect you run with LOCKDEP enabled (CONFIG_PROVE_LOCKING=3Dy)
and a very big NR_CPUS ?

LOCKDEP makes spinlock_t 16 times bigger :/

If so, please try the following fix.

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9482def1f310379efde1a1a8c86999b4b826cf17..ad19a37a49e78715c813b17a109=
7226dd1450671
100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3481,8 +3481,13 @@ void __init udp_init(void)

        /* 16 spinlocks per cpu */
        udp_busylocks_log =3D ilog2(nr_cpu_ids) + 4;
-       udp_busylocks =3D kmalloc(sizeof(spinlock_t) << udp_busylocks_log,
-                               GFP_KERNEL);
+       while (udp_busylocks_log >=3D 4) {
+               udp_busylocks =3D kmalloc(sizeof(spinlock_t) << udp_busyloc=
ks_log,
+                                       GFP_KERNEL | __GFP_NOWARN);
+               if (udp_busylocks)
+                       break;
+               udp_busylocks_log--;
+       }
        if (!udp_busylocks)
                panic("UDP: failed to alloc udp_busylocks\n");
        for (i =3D 0; i < (1U << udp_busylocks_log); i++)

