Return-Path: <netdev+bounces-7114-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD4B71A211
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 948BD281552
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D008722610;
	Thu,  1 Jun 2023 15:11:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C172342E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:11:32 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B541703
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:11:14 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f6a6b9bebdso92225e9.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 08:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685632262; x=1688224262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/ZDCbaS5BasDGweOpypX69jqZRIVn168PE8kkE06BM=;
        b=pbm6sStAd9k4icSNrF8FKrRnjXhNVxOIBj6hWYKhyhV+GCAJXTJAFfmp/Yd2Su7y03
         KRX4UNkQAu+CKX9EoN9lq/kpGH8I5dRMeSjXYKyofzyJwziDRD+HqWBEp00zpvUEtvve
         cvCjoPBMoPmB53JpaY3hEYQDCHg7QJu/bWbNwL4r81gSB6rg+mznOi24+75t7t3TKos1
         9JweGRXEHiU0BgCAUICByA2yFUdGc42PFMzdKDfFzuIQUaw4y9X3c35C/BA1LMmOZJwy
         uyQcq+yBYhyWfCiJHnJdBgMjg0pRYRhxhwLD3yQKxsfVb2/uw5w8XOteqmZpILZS69Jb
         rp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685632262; x=1688224262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e/ZDCbaS5BasDGweOpypX69jqZRIVn168PE8kkE06BM=;
        b=EsQAFxrnGoMMlGY0VzRNNqTMFKsl1/++EG6clEEL5Ie1GtSmZrfGnNpmJkni365P72
         RKAl1qcLj0HfA943jy8yma/4hBaU+23k3nuqnkzf4A/HIa8LISO7PEKMKrUghZF1Pwny
         +uQusyIGtAzrgRaBFNUdszrR26iTrxgGBXGt+NlEp56PvZAh6nL3bCGKbq49x2qAwA8z
         AxodwPVZi6DPHeKwTu2G7q5LgMUTV6mazzjuJb37Z5a75u1oJrh5SgZqRlVa332TVhn+
         jkcTXXHZVMpIpiBXfRly4C0DKcxQpwxjcDeLGn0/S5goLuUHtKUpKJ8JhBrEuqTZz/B9
         HDYw==
X-Gm-Message-State: AC+VfDyMywQFLrsLgFWIcuvYVwSnPmzmDc5K5fgP3fyFUt+fwyRdbP4p
	ax41wwYHUOgLZ5eRRKFahT/jv17ZlLAAkUg7Ynwb1A==
X-Google-Smtp-Source: ACHHUZ5ar1qnATBRV5jmIEbk1dpCTLMW7l75k70ElwEbGikS91c/JcyvRCKiLiVHbjPOHX5sXJV6qUGyXa8ITwr1SkU=
X-Received: by 2002:a05:600c:3ac9:b0:3f1:6fe9:4a95 with SMTP id
 d9-20020a05600c3ac900b003f16fe94a95mr239669wms.4.1685632262377; Thu, 01 Jun
 2023 08:11:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230531141556.1637341-1-lee@kernel.org> <CANn89iJw2N9EbF+Fm8KCPMvo-25ONwba+3PUr8L2ktZC1Z3uLw@mail.gmail.com>
 <CAM0EoMnUgXsr4UBeZR57vPpc5WRJkbWUFsii90jXJ=stoXCGcg@mail.gmail.com> <20230601140640.GG449117@google.com>
In-Reply-To: <20230601140640.GG449117@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 1 Jun 2023 17:10:50 +0200
Message-ID: <CANn89i+j7ymO2-wyZtavCotwODdgOAcJ5O_GFjLkegqAsx4F5A@mail.gmail.com>
Subject: Re: [PATCH 1/1] net/sched: cls_u32: Fix reference counter leak
 leading to overflow
To: Lee Jones <lee@kernel.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 1, 2023 at 4:06=E2=80=AFPM Lee Jones <lee@kernel.org> wrote:
>
> On Wed, 31 May 2023, Jamal Hadi Salim wrote:
>
> > On Wed, May 31, 2023 at 11:03=E2=80=AFAM Eric Dumazet <edumazet@google.=
com> wrote:
> > >
> > > On Wed, May 31, 2023 at 4:16=E2=80=AFPM Lee Jones <lee@kernel.org> wr=
ote:
> > > >
> > > > In the event of a failure in tcf_change_indev(), u32_set_parms() wi=
ll
> > > > immediately return without decrementing the recently incremented
> > > > reference counter.  If this happens enough times, the counter will
> > > > rollover and the reference freed, leading to a double free which ca=
n be
> > > > used to do 'bad things'.
> > > >
> > > > Cc: stable@kernel.org # v4.14+
> > >
> > > Please add a Fixes: tag.
>
> Why?

How have you identified v4.14+ ?

Probably you did some research/"git archeology".

By adding the Fixes: tag, you allow us to double check immediately,
and see if other bugs need to be fixed at the same time.

You can also CC blamed patch authors, to get some feedback.

Otherwise, we (people reviewing this patch) have to also do this
research from scratch.

In this case, it seems bug was added in

commit 705c7091262d02b09eb686c24491de61bf42fdb2
Author: Jiri Pirko <jiri@resnulli.us>
Date:   Fri Aug 4 14:29:14 2017 +0200

    net: sched: cls_u32: no need to call tcf_exts_change for newly
allocated struct


A nice Fixes: tag would then be

Fixes: 705c7091262d ("net: sched: cls_u32: no need to call
tcf_exts_change for newly allocated struct")

Thanks.

