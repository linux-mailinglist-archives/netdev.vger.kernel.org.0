Return-Path: <netdev+bounces-8099-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3579722AFF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B0921C20992
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0165200B8;
	Mon,  5 Jun 2023 15:28:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46621F93D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:28:01 +0000 (UTC)
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2C694
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:28:00 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-565f1145dc8so54610307b3.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 08:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685978879; x=1688570879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+vXrX2uIKS2mIMRlNK+Nc321eW49XHyfNXKQzxgWz9M=;
        b=TUT+b4molzkVlzzJ0Fms+B2/EuJ0RHoAlfoCaESM0EhSFil0mojqOq981YO5wIDtbC
         ycECZBjpinVnuZpt+Y6kCHt1IDnV4/9uNfoTZvNylOQ9DWUt/WOzmZatvNTGmVv3s30z
         r5iAngUV3GcEMMTrK36jSYG+SlZoCekrkAzVOxk/LsCW/p9UxwlwnV6Kveo9znt8mSEV
         1GotckagWHjkwOacuZXvvfQuE8bt3RyT+Oz7B5q26aBEAXvXc8ggU+htaerzbEdXSADZ
         JnPwf3IVaAunJ8Hw+LB6JqKSxR4I/pEmtxEXQJNXb5DtoIJYQl8E8/XhuiZkaJG0c83v
         WfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685978879; x=1688570879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+vXrX2uIKS2mIMRlNK+Nc321eW49XHyfNXKQzxgWz9M=;
        b=QYIL0AkSkHr/os3SIip57eZ7X+AluhipH6GLsMaIq8iAOOElMoYHUWOJ3eQIpDXCKQ
         H4GvMIlZpA6tsJ3z4ofQjC2ODXlfVvZEBkHWijw1NW44hE3oIemzJnSpKg5VYUIoFFu6
         wjuffjGIlWrTbgwo+ftHJQ++NOLnT3v/emSeCgkr33NYAOQFQvukQkVgYN/Nxvg6ozpy
         JvbVwRfPB5JquOSlDcNLAWoiviDLH8nD5YvghhRs5f/QqRev5YlVBKtnsscskBTCMH1q
         6j5xWtIV72/7JcmxG7b1z92BgFDJ8it5cGaTbi32ghjtHIheMjGrR6auuMYvMHQRSHM/
         ya/A==
X-Gm-Message-State: AC+VfDztnjX/yVERIFe1zRVJ0jQ37putamPYMf3Exc2h4mQPOn5yannk
	q7Rbo9Z3Vrdfx5bYUXi6+eKG6tfctx3kiSOtBG/gdA==
X-Google-Smtp-Source: ACHHUZ6R2A3pZsxwleTxyrmeXRjDG8p4VIa+rXjRZItSYpz0zrTbdijkJYo6ifEZk845naFe1LJjw63H+R3sSgTC4DY=
X-Received: by 2002:a81:6784:0:b0:561:c147:1d46 with SMTP id
 b126-20020a816784000000b00561c1471d46mr10163082ywc.9.1685978879690; Mon, 05
 Jun 2023 08:27:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-4-jhs@mojatatu.com>
 <ZH2wEocXqLEjiaqc@corigine.com> <9a777d0b-b212-4487-b5ac-9a05fafac6c7@kadam.mountain>
 <CAAFAkD-N4qeYpPMOf7WFORjnt0CDztBzHF2aF2iD+qRNLdCqbA@mail.gmail.com> <9ae2fc87-40a4-4ca8-afcd-a85392f01181@kadam.mountain>
In-Reply-To: <9ae2fc87-40a4-4ca8-afcd-a85392f01181@kadam.mountain>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 5 Jun 2023 11:27:48 -0400
Message-ID: <CAM0EoMmgMVzaHM+_TRf5DPUOYLkO2eEb1maHieoHn4UCXfu9TA@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 04/28] net/sched:
 act_api: add init_ops to struct tc_action_op
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jamal Hadi Salim <hadi@mojatatu.com>, Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, 
	deb.chatterjee@intel.com, tom@sipanda.io, p4tc-discussions@netdevconf.info, 
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com, 
	xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 10:59=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> On Mon, Jun 05, 2023 at 10:01:44AM -0400, Jamal Hadi Salim wrote:
> > On Mon, Jun 5, 2023 at 7:39=E2=80=AFAM Dan Carpenter via p4tc-discussio=
ns
> > <p4tc-discussions@netdevconf.info> wrote:
> > >
> > > On Mon, Jun 05, 2023 at 11:51:14AM +0200, Simon Horman wrote:
> > > > > @@ -1494,8 +1494,13 @@ struct tc_action *tcf_action_init_1(struct=
 net *net, struct tcf_proto *tp,
> > > > >                     }
> > > > >             }
> > > > >
> > > > > -           err =3D a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, =
tp,
> > > > > -                           userflags.value | flags, extack);
> > > > > +           if (a_o->init)
> > > > > +                   err =3D a_o->init(net, tb[TCA_ACT_OPTIONS], e=
st, &a, tp,
> > > > > +                                   userflags.value | flags, exta=
ck);
> > > > > +           else if (a_o->init_ops)
> > > > > +                   err =3D a_o->init_ops(net, tb[TCA_ACT_OPTIONS=
], est, &a,
> > > > > +                                       tp, a_o, userflags.value =
| flags,
> > > > > +                                       extack);
> > > >
> > > > By my reading the initialisation of a occurs here.
> > > > Which is now conditional.
> > > >
> > >
> > > Right.  Presumably the author knows that one (and only one) of the
> > > ->init or ->init_ops pointers is set.
> >
> > Yes, this is correct and the code above checks i.e
> >  -     if (!act->act || !act->dump || !act->init)
> >  +     if (!act->act || !act->dump || (!act->init && !act->init_ops))
> >                return -EINVAL;
> >
>
> Ah.  Right.
>
> > > This kind of relationship between
> > > two variables is something that Smatch tries to track inside a functi=
on
> > > but outside of functions, like here, then Smatch doesn't track it.
> > > I can't really think of a scalable way to track this.
> >
> > Could you have used the statement i referred to above as part of the st=
ate?
> >
>
> If the if statement were in the same function then Smatch would be able
> to parse this but that relationship information doesn't carry across the
> function boundary.  It's actually quite a bit more complicated than just
> the function boundary even...  I don't know if this is even possible but
> if it were then it would be like a 5-7 year time frame to make it work...

Understood. I guess this semantically is at least a layer above, so it
owuld be complex.

cheers,
jamal
> regards,
> dan carpenter
>
>

