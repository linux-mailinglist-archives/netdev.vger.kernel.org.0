Return-Path: <netdev+bounces-8567-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE75572493B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:34:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 892FF281179
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A800B174D4;
	Tue,  6 Jun 2023 16:34:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D830111B1
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:34:45 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4469D92
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:34:44 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f7e4953107so73625e9.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 09:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686069282; x=1688661282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2QGwqv2pKLQzt3zGorpCpvFY7H+bwnuhYswLEZpMeCE=;
        b=gRsD6IyYPaL+vtnyyI9x5zsiHXSCqCaYMIK2WcCJzv9GTNEn6P/R4D2sLmYYW4Dr9T
         vtsFj9kZZp+G8pFmdehd3gCvd7esqrlv241LZ7rP9kS1KjGkwCbM0pUyvu3ECWJSGYqm
         2BOwn8fUrLrfmRJKR4T8WrCXIZ4B976l41s45n96fmHYzPKzgoFW6xPJUVihmTweDC8w
         Fqcsix4C/6FQB3LYtyBpm2gr2ha6erQ9jJQOi/yQcUT3r9NNDwEJ0W2ffXwa3nciG47M
         IauyhwqsAtDPgrKrhgeZPbbjBVoE78ijvL3RvyYVX/xgaFderC99CsNqfcs6kDwJFPfN
         hVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686069282; x=1688661282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2QGwqv2pKLQzt3zGorpCpvFY7H+bwnuhYswLEZpMeCE=;
        b=cnRD9+Nzn9K2yF6y/FWYhbwxNJnBCGsvZ4U7UbyFeRj/lFXWTEXPO3iKe614YlYH7/
         U8LfI32RH0d2/nf0uUVV7T6MyBmcGaM3k4vaQYQdQzUACVH6fmrqU8rOX+BrxsYWYInc
         2Zi7e7Z4Saaip7wwHUADItdgGD3UZ+8YrcL6gTwOtcLA4NpLquFH9CbAO2BiDAVo4aD+
         pPKaMPLGqh0yccbPysSE6vrD3Pq4K0UaMlzd9z4qp0ikzBtv5SV+ZFZ9+mkqUiZCMyCv
         fCXNZGohO4r+YbXy3bh0RsmpnDn6T70lnFLku3ucwzc6cSO0mD1wFTrXG1sONJeW4FKO
         c+Ng==
X-Gm-Message-State: AC+VfDwdDiv9GT2lGY2Y8ABADTcnRIPMegUAJoNXrg8bupiUy6vY7pBR
	g0kT2uVuMIRmc7pei73MzuCOjhelddIeOscMkON8ZQ==
X-Google-Smtp-Source: ACHHUZ701MWO5ihsLuBvqZk9Z1SgQpxpcLMp2FlAXBegtZebd0aQkrA08gVGKgDCf89QYfH1bqD2QwWGgKD7BCw1ruA=
X-Received: by 2002:a05:600c:8088:b0:3f7:e463:a0d6 with SMTP id
 ew8-20020a05600c808800b003f7e463a0d6mr246158wmb.0.1686069282588; Tue, 06 Jun
 2023 09:34:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606131304.4183359-1-edumazet@google.com> <ZH9PB79LUMXLZOPR@corigine.com>
 <CAM0EoMn1veKy2-qX5zcfbx3pcXhiVmBMTcV7JHv6jREuxgrFhw@mail.gmail.com>
In-Reply-To: <CAM0EoMn1veKy2-qX5zcfbx3pcXhiVmBMTcV7JHv6jREuxgrFhw@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 6 Jun 2023 18:34:30 +0200
Message-ID: <CANn89iJU3w-AVvpDMnZcErSKvTAAcCO=rVRdHRaZXGuoA1LyFQ@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: act_police: fix sparse errors in tcf_police_dump()
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Simon Horman <simon.horman@corigine.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org, 
	eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 6:01=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.com> =
wrote:
>
> On Tue, Jun 6, 2023 at 11:21=E2=80=AFAM Simon Horman <simon.horman@corigi=
ne.com> wrote:
> >
> > On Tue, Jun 06, 2023 at 01:13:04PM +0000, Eric Dumazet wrote:
> > > Fixes following sparse errors:
> > >
> > > net/sched/act_police.c:360:28: warning: dereference of noderef expres=
sion
> > > net/sched/act_police.c:362:45: warning: dereference of noderef expres=
sion
> > > net/sched/act_police.c:362:45: warning: dereference of noderef expres=
sion
> > > net/sched/act_police.c:368:28: warning: dereference of noderef expres=
sion
> > > net/sched/act_police.c:370:45: warning: dereference of noderef expres=
sion
> > > net/sched/act_police.c:370:45: warning: dereference of noderef expres=
sion
> > > net/sched/act_police.c:376:45: warning: dereference of noderef expres=
sion
> > > net/sched/act_police.c:376:45: warning: dereference of noderef expres=
sion
> > >
> > > Fixes: d1967e495a8d ("net_sched: act_police: add 2 new attributes to =
support police 64bit rate and peakrate")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> >
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
>
> Trivial comment: Eric, for completion, does it make sense to also convert
> opt.action =3D police->tcf_action to opt.action =3D p->tcf_action;
> and moving it after p =3D rcu_dereference_protected()?
>

Not sure I understand, tcf_action is in police->tcf_action, not in
p->tcf_action ?

Field is read after spin_lock_bh(&police->tcf_lock); so the current
code seems fine to me.

