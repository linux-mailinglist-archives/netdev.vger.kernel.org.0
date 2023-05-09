Return-Path: <netdev+bounces-1089-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E29A6FC241
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C12CF281276
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1908486;
	Tue,  9 May 2023 09:02:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC20417C2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:02:52 +0000 (UTC)
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B268DC58
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:02:46 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3ef34c49cb9so88501cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 02:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683622965; x=1686214965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQMbOwK6UYUwP4h+X9ffrgGRqDFyDl3hTELKhL2KLRY=;
        b=ddHO5YVlQ1k4ASnusUqx9tc+JVzlf+tQbh4Gdn+HbeY+pKzC/a+VgLV0AgN0LagWz/
         ArL3VnF/Pj2P7rinLP5b7MF/8kziKaG7TvoAs77uCq5FcyN+CR4SUU4RX5VlLVPD7zZL
         U/e8Obxe5plDiMpKDbVsYsFtiNV7qXyPUYvJDrRGzKCdrovK7N1lloFDk3lYESTlSml3
         lDD8ubJopiXPiJTmqf5aMWEPdl2oDrI55jnokpxjATrszf3NbWADNDSc/NbKRimorDBD
         VLwctjYRZvd5+3mtqEHnrSL1cXmn2jhSRrH+K4pAc3t9ef39l7rJ+BKu4mfZ3I0AfBv5
         +RXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683622965; x=1686214965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQMbOwK6UYUwP4h+X9ffrgGRqDFyDl3hTELKhL2KLRY=;
        b=dnaWh1mlVD9xlrojMOcdzLMg7+JYwluqZLMmsg6ja30GAcSzgatcnQquGAaC+l/R3L
         XntCg0q2fWdQkBB9/Z3Z6Mgz2ELBJKAus1Hap81F/t1Ie6T+lvW2KPHxL8JCu68QIeve
         TsChEmyZXlT7wIiLZoDQbj9TMoq8ajsvZFW7N1F9SCsT4nzB7pJycXqcXIpvfm1mxALI
         O0OSIrH9ls9dSO1YUJZ3gVH+aGh7N1wnvM8uzusU2sUqYhGbmFay5t5i+4bXKHgtyHlH
         T/TcX5iOL1wVGNP0DAk7TFFOSM6MYd2rIi39njZ2kX0xCIytH7ahBldJZ0wFuV+DH5aD
         yuNQ==
X-Gm-Message-State: AC+VfDzt1fnK/IkvEakeh7k4wvxIjzrECTN/aiA74DB7gg/Ci3HOxoL6
	lhOfUtz4p2OJe0s0t0FJhUsJrrGrVf6GIE1RjgTrXg==
X-Google-Smtp-Source: ACHHUZ5aQwhgwj/qWG83MeZFJnYduMtgU13qiDC9ksdyPsMzKkTIqz9lHLF930e5/pXsqRmHy7+SS648OohflQdddNA=
X-Received: by 2002:a05:622a:1308:b0:3ef:4319:c6c5 with SMTP id
 v8-20020a05622a130800b003ef4319c6c5mr158583qtk.19.1683622965469; Tue, 09 May
 2023 02:02:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <57e66b364f1b6f09c9bc0316742c3b14f4ce83bd.1683526542.git.pabeni@redhat.com>
 <20230508184219.4049952c@kernel.org>
In-Reply-To: <20230508184219.4049952c@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 11:02:34 +0200
Message-ID: <CANn89iKLuSq8aGhVpB7CkT2Q7aWBPWMWcUek+U7kgfHU5tEyTA@mail.gmail.com>
Subject: Re: [PATCH] revert: "softirq: Let ksoftirqd do its job"
To: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org, 
	"Paul E. McKenney" <paulmck@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org, 
	netdev@vger.kernel.org, Jason Xing <kerneljasonxing@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 9, 2023 at 3:42=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Mon,  8 May 2023 08:17:44 +0200 Paolo Abeni wrote:
> > Due to the mentioned commit, when the ksoftirqd processes take charge
> > of softirq processing, the system can experience high latencies.
> >
> > In the past a few workarounds have been implemented for specific
> > side-effects of the above:
> >
> > commit 1ff688209e2e ("watchdog: core: make sure the watchdog_worker is =
not deferred")
> > commit 8d5755b3f77b ("watchdog: softdog: fire watchdog even if softirqs=
 do not get to run")
> > commit 217f69743681 ("net: busy-poll: allow preemption in sk_busy_loop(=
)")
> > commit 3c53776e29f8 ("Mark HI and TASKLET softirq synchronous")
> >
> > but the latency problem still exists in real-life workloads, see the
> > link below.
> >
> > The reverted commit intended to solve a live-lock scenario that can now
> > be addressed with the NAPI threaded mode, introduced with commit
> > 29863d41bb6e ("net: implement threaded-able napi poll loop support"),
> > and nowadays in a pretty stable status.
> >
> > While a complete solution to put softirq processing under nice resource
> > control would be preferable, that has proven to be a very hard task. In
> > the short term, remove the main pain point, and also simplify a bit the
> > current softirq implementation.
> >
> > Note that this change also reverts commit 3c53776e29f8 ("Mark HI and
> > TASKLET softirq synchronous") and commit 1342d8080f61 ("softirq: Don't
> > skip softirq execution when softirq thread is parking"), which are
> > direct follow-ups of the feature commit. A single change is preferred t=
o
> > avoid known bad intermediate states introduced by a patch series
> > reverting them individually.
> >
> > Link: https://lore.kernel.org/netdev/305d7742212cbe98621b16be782b0562f1=
012cb6.camel@redhat.com/
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Tested-by: Jason Xing <kerneljasonxing@gmail.com>
>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.

