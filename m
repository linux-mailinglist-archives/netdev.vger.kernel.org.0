Return-Path: <netdev+bounces-8604-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A899724BD7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E473B280F80
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E2E22E21;
	Tue,  6 Jun 2023 18:53:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F38125CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:53:03 +0000 (UTC)
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094DB106
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:52:56 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 3f1490d57ef6-ba8a0500f4aso6837814276.3
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 11:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686077575; x=1688669575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hy6kme732C03+A9GRnIkjykr9X8iiUCh0O43jksDCYs=;
        b=d+3PH6KkNEEkhPFSCHav8DDnXwx/lnVcxmQxUTICUQsJOyWPK2K9eh1G7H9QwGlJP3
         I1szq6R1qrChaPngILw4DdOtO3MxwX2IlKaGQSsCmFacNIzmQ5Cc9WW1678jRMn7ntm/
         jSFA7FkE35kn4Amp/s968rSErzh1TUHMP97VLBHD/U2obue2ftFWaoJTliVDO+QaYXL1
         feGggwY49FgLJHfUXZj8lg1rarc81YqUOCU2pxhDngNijEnWEdygzhka677dF+SbpVFd
         rpgVnmcgdBDODIPLYWjdXcoYWsMGDXR0PLX1FM+846O2JN07/QLGRR44JsE8gW9DGXZm
         cS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686077575; x=1688669575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hy6kme732C03+A9GRnIkjykr9X8iiUCh0O43jksDCYs=;
        b=dCGTe3rfx8x1TP6e5gjDbRV+UqiTaHQVbqbRuaiGqHAo1JtKAhq7sU17zHCWEMJh3K
         vKr5PMT3xRz5Df1CKSbDtcav4+IdHmuf3cg3CBIA5t78eKx4ONMwHmSC2vvXQPXY7x3c
         TvAdneFStupw+OYZ04o86anMjcnyvzseEzoRaabxWt2YhEiitua0DzijTRQGgkFZ6Br+
         k8SKdV9fnPR6yaIa2Trg8GpX42PSiH5l+05r+Wp/DOGfgfviLGM8JQsb2m2qaW3YFSRr
         NKmEO3XKwbreLWGqVZhWtcm9jeFjrvzbRLRTdvRMyxW9sYV+hzZNdqqoPqBCg+YmFW2P
         wJaw==
X-Gm-Message-State: AC+VfDxiYkVxlj7ykOaiKNEk16iGkgTQ4O60Y/TNriYCojMty9B1Vxpf
	wQw6QorWyN/4UtAV/89JZQORgAIYsjQ6M1hg6uppkg==
X-Google-Smtp-Source: ACHHUZ4mUM8PXWWgai207iHcwDj/KdmfuDs8xvu61XT8x5WTTywbBkeRcfIRppvUObq37VEjNmnrS8+oGpfpPU0ev4c=
X-Received: by 2002:a81:60c2:0:b0:560:f6ae:a71b with SMTP id
 u185-20020a8160c2000000b00560f6aea71bmr2937594ywb.48.1686077575228; Tue, 06
 Jun 2023 11:52:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-3-jhs@mojatatu.com>
 <20230605103949.3317f1ed@kernel.org> <CAAFAkD9pU0DemGSOBcFoqJWkmvt4e6TLsDM0zzV+yaUY_m-MHg@mail.gmail.com>
 <20230606101529.6ea62da4@kernel.org>
In-Reply-To: <20230606101529.6ea62da4@kernel.org>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 6 Jun 2023 14:52:43 -0400
Message-ID: <CAM0EoM=aTHbHv1fgZs+QwWe8v92C2BzDsczPqN-VQ9HkAEBYzQ@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 03/28] net/sched:
 act_api: increase TCA_ID_MAX
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jamal Hadi Salim <hadi@mojatatu.com>, netdev@vger.kernel.org, deb.chatterjee@intel.com, 
	tom@sipanda.io, p4tc-discussions@netdevconf.info, Mahesh.Shirshyad@amd.com, 
	Vipin.Jain@amd.com, tomasz.osinski@intel.com, xiyou.wangcong@gmail.com, 
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com, 
	khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 1:15=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Tue, 6 Jun 2023 13:04:18 -0400 Jamal Hadi Salim wrote:
> > > > diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_=
cls.h
> > > > index 5b66df3ec332..337411949ad0 100644
> > > > --- a/include/uapi/linux/pkt_cls.h
> > > > +++ b/include/uapi/linux/pkt_cls.h
> > > > @@ -140,9 +140,9 @@ enum tca_id {
> > > >       TCA_ID_MPLS,
> > > >       TCA_ID_CT,
> > > >       TCA_ID_GATE,
> > > > -     TCA_ID_DYN,
> > > > +     TCA_ID_DYN =3D 256,
> > > >       /* other actions go here */
> > > > -     __TCA_ID_MAX =3D 255
> > > > +     __TCA_ID_MAX =3D 1023
> > > >  };
> > > >
> > > >  #define TCA_ID_MAX __TCA_ID_MAX
> > >
> > > I haven't look at any of the patches but this stands out as bad idea
> > > on the surface.
> >
> > The idea is to reserve a range of the IDs for dynamic use in this case
> > from 256-1023. The kernel will issue an action id from that range when
> > we request it. The assumption is someone adding a "static" action ID
> > will populate the above enum and is able to move the range boundaries.
> > P4TC continues to work with old and new kernels and with old and new
> > tc.
> > Did i miss something you were alluding to?
>
> Allocating action IDs for P4 at the same level as normal TC actions
> makes the P4 stuff looks like a total parallel implementation to me.

P4 actions  look exactly the same as standard tc actions (semantics,
attributes, etc) so it seemed natural to just reuse the same
mechanics. A P4 match can invoke tc police action for example if
that's what P4 program defines. The only addition we have are
separation "static" (predefined in the kernel or a kernel module)
actions vs "dynamic" set of actions.

> Why is there not a TCA_ID_P4 which muxes internally?

It seemed like an unnecessary indirection given that everything else
is the same.

> AFAIU interpretation of action attributes depends on the ID, which
> means that user space to parse the action attrs has to not only look
> at the ID but now also resolve what that ID means.

Parsing what you are saying above (and thinking while typing this):
In the classical control path "tc action ..."  or when you say "tc
filter... action .." only names are passed. Action names are unique
globally so this works.  So no resolution required there.

P4 spec says an action is allowed to call another action "static" or
"dynamic" - and we can tell the dynamic action to find it by name or
optimally by ID (hence this lookup_byid). Static actions are easy,
they are in the UAPI because their IDs are compiled in. Dynamic
actions optimization requires resolution as you mentioned. Your
suggestion may work then we wont need to define the ranges at all (and
maintain the status quo of passing names instead of IDs from user
space).
Let me socialize it with the rest of the group...

cheers,
jamal

