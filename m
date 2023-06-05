Return-Path: <netdev+bounces-8036-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A7372280C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:02:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B862B1C20B46
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869D81D2D0;
	Mon,  5 Jun 2023 14:01:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DD11D2BB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:01:59 +0000 (UTC)
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648789E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:01:56 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-77499bf8e8bso185448139f.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 07:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685973716; x=1688565716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2mUMfWiv7x4vPne13yFpAE+mGkV/EPlC/PX8cap8ovo=;
        b=ijZBPq5dVCe4H1BFOOFUa3ogSsITeeZ/8L2+ryHSxOgwUG4C4MPLr+kDB1XX01s8EF
         1/uRUPhhjD2UeQ1OJ2AUI7Okt8JP0CTTt9Aj89Plit7ZpOgTxhn2i+7aMCGBF00gSK5L
         Fvl1hA02XaQs34D/cq63bfo71dB6KxGwWbN+TuZyh8gLdSZVI+YQ5g1L9TrHMIe1+OhS
         ZPPIRN+k77qHObUur4A/FKuIMYIs88KyvpDJc3KOCjUruM3sshEIkHu9YcgYt62erQd5
         AtoPAJWFC17FErtP1/i8ngc5+M7qTgnsiecrLBH+2ntkTTFiyumhTzIVRmtYPto9r7Ty
         qp0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973716; x=1688565716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2mUMfWiv7x4vPne13yFpAE+mGkV/EPlC/PX8cap8ovo=;
        b=Zjl9eOQiPmlLW2yXEdf59WTOmMsOiGQLDoJpoTNMjgfMhRatQIDWukrceNkArWtOoY
         e5fdmwuMGOoM0NENTWTdCFh9/dgA0C//SvxXf677lINnu9vYTPv+wt7Ln6FV/0hzaYIP
         eVaHrUhzuzw41lRAfPxBIl3TrphBAJQNdA0xJY+5YxHjVeTU2PSm9/4IE1zot5W+KvLS
         yhus9Gfoy5VH1T0pvjIUa/V4bQv5su2fhcdGQgoNXuapBxIUCiqcsbO4CEK0fvoMehmC
         WRTXWPUsi7yezQqFC81vrRyq3Pa3VTP9K7EpaI2dvxGTPvAsBNxf9kBZVqfnrYjReOmP
         NE7g==
X-Gm-Message-State: AC+VfDwsiJhAAPYOqYU75WrxigypBozKjjcl3dBKitU1HiP2dq0kgAyg
	gGUjWo/nhPk1b9TeQDqmPqSQVO8oZE4K9NWdRjPmYkabcYHPXREHTEI=
X-Google-Smtp-Source: ACHHUZ5RtwjoES8WU3mVN1YI4z9w97kvV5A/MU/JPwvwdGNMzSh9qYK0eIIndVtuf31QWpUiY1Bbtzfz8XcXiAaWFc8=
X-Received: by 2002:a5e:dd0b:0:b0:76c:595a:6b5f with SMTP id
 t11-20020a5edd0b000000b0076c595a6b5fmr7066900iop.20.1685973715719; Mon, 05
 Jun 2023 07:01:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-4-jhs@mojatatu.com>
 <ZH2wEocXqLEjiaqc@corigine.com> <9a777d0b-b212-4487-b5ac-9a05fafac6c7@kadam.mountain>
In-Reply-To: <9a777d0b-b212-4487-b5ac-9a05fafac6c7@kadam.mountain>
From: Jamal Hadi Salim <hadi@mojatatu.com>
Date: Mon, 5 Jun 2023 10:01:44 -0400
Message-ID: <CAAFAkD-N4qeYpPMOf7WFORjnt0CDztBzHF2aF2iD+qRNLdCqbA@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 04/28] net/sched:
 act_api: add init_ops to struct tc_action_op
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, 
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

On Mon, Jun 5, 2023 at 7:39=E2=80=AFAM Dan Carpenter via p4tc-discussions
<p4tc-discussions@netdevconf.info> wrote:
>
> On Mon, Jun 05, 2023 at 11:51:14AM +0200, Simon Horman wrote:
> > > @@ -1494,8 +1494,13 @@ struct tc_action *tcf_action_init_1(struct net=
 *net, struct tcf_proto *tp,
> > >                     }
> > >             }
> > >
> > > -           err =3D a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
> > > -                           userflags.value | flags, extack);
> > > +           if (a_o->init)
> > > +                   err =3D a_o->init(net, tb[TCA_ACT_OPTIONS], est, =
&a, tp,
> > > +                                   userflags.value | flags, extack);
> > > +           else if (a_o->init_ops)
> > > +                   err =3D a_o->init_ops(net, tb[TCA_ACT_OPTIONS], e=
st, &a,
> > > +                                       tp, a_o, userflags.value | fl=
ags,
> > > +                                       extack);
> >
> > By my reading the initialisation of a occurs here.
> > Which is now conditional.
> >
>
> Right.  Presumably the author knows that one (and only one) of the
> ->init or ->init_ops pointers is set.

Yes, this is correct and the code above checks i.e
 -     if (!act->act || !act->dump || !act->init)
 +     if (!act->act || !act->dump || (!act->init && !act->init_ops))
               return -EINVAL;

> This kind of relationship between
> two variables is something that Smatch tries to track inside a function
> but outside of functions, like here, then Smatch doesn't track it.
> I can't really think of a scalable way to track this.

Could you have used the statement i referred to above as part of the state?

> So there are a couple options:
>
> 1) Ignore the warning.
> 2) Remove the second if.
>
>         if (a_o->init)
>                 err =3D a_o->init();
>         else
>                 err =3D a_o->init_ops();
>
> I kind of like this, because I think it communicates the if ->init()
> isn't set then ->init_ops() must be.

I like this approach - we'll refactor to remove the !police. (note
police using some old tc versions is still a pariah and has typically
to be checked separately, at some point we should audit the code and
remove any police specific checks).

cheers,
jamal

> 3) Add a return.
>
>         if (a_o->init) {
>                 err =3D a_o->init();
>         } else if (a_o->init_ops) {
>                 err =3D a_o->init_ops();
>         } else {
>                 WARN_ON(1);
>                 return ERR_PTR(-EINVAL);
>         }
>
> 4) Add an unreachable.  But the last time I suggested this it led to
> link errors and I didn't get a chance to investigate so probably don't
> do this:
>
>         if (a_o->init) {
>                 err =3D a_o->init();
>         } else if (a_o->init_ops) {
>                 err =3D a_o->init_ops();
>         } else {
>                 unreachable();
>         }
>
> regards,
> dan carpenter
>
> _______________________________________________
> p4tc-discussions mailing list -- p4tc-discussions@netdevconf.info
> To unsubscribe send an email to p4tc-discussions-leave@netdevconf.info

