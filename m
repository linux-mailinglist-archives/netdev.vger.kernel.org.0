Return-Path: <netdev+bounces-8045-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D00AA7228D9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47E1C1C20C3B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6835A1E537;
	Mon,  5 Jun 2023 14:32:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACEA1DDF4
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:32:33 +0000 (UTC)
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6DDEC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:32:31 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-777b2af1c53so62858939f.2
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 07:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685975550; x=1688567550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGDtTg4cLbZ42yg9zsenTptB75YDCu2MnatpiOWQytc=;
        b=ULd31mem+kWSzeDbv+9Gdo0vVXyx402+aoZ3ErOM0/VSB3+ZFZAqd+JMSr8w0AvO6P
         4JubvUMpvUWVIXARdtFv9omkMxTiAt0ORRsfqu/rbV6v9kJkJcGWSPdYo9pqAHJH1fV4
         WStueGWf9RvlwVShD4ja/4vpOweJPtshnBZhKMFLvix1OyFevl+aBLLx6EMEfszyDHSX
         INdf6u74WpfRcZtR8emxKPiIELwOzdLLelR+hoQaudacH+sUcBHhclX7dCmTGQLTkBdz
         3Phc1/ePEmz5wZQ4gkCtWWRk0LA5aLKRp2avqAOJWsjAvJDpvnN3raH7XC2w6DnWNLXe
         oefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685975550; x=1688567550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sGDtTg4cLbZ42yg9zsenTptB75YDCu2MnatpiOWQytc=;
        b=ZqbKTzKsNxhJyhd+G52nk09/DOMMWMD7k64eQanfhP56TPZTu+mw3pl9VCFSnmhaJG
         Q+nm7e6f4epA8Xaj3qF7jBZbSnX8k5Lorl0nHeByoaZ101wePKaglzIbBtA8BHmU4Shu
         LwT2oNXonzeFnP06l7aL032MCxVepqf9XyFN6L8qaZkwqfmxFgLX8nTgQgw6+/T2UAGU
         RMiLw3+IBm2of1MwUPQ/VXGL66rxjb4mmbjqynn2SxTv0X0yrmm7dA6GCf8H82b4XLkJ
         9ukIPZCk0r67vT8WHhlA0ne+7frLsACdb3/NfHkYoiiLMzbvUri+/VS0GPpTto20gftp
         QfRg==
X-Gm-Message-State: AC+VfDzTC6pn+ewhYmF22+9t81h64BepRO1Zxb7tliZc+GiCRJYZqXL0
	wUS7LCrVZ+IcSE5XqPxxBtAGQ/eeWnfERP7oeBG+JA==
X-Google-Smtp-Source: ACHHUZ6LbmEz5NIwfpzzhG4KvMGYuY+2EVfeTdc7PMjdugJHH41ett9F4IRbkWTob3aeEQkY/t2eul9yK4lFqXsvYhI=
X-Received: by 2002:a05:6602:2298:b0:763:5cf8:65eb with SMTP id
 d24-20020a056602229800b007635cf865ebmr40933iod.9.1685975550739; Mon, 05 Jun
 2023 07:32:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-10-jhs@mojatatu.com>
 <ZH21GzZ6HATUuNyX@corigine.com>
In-Reply-To: <ZH21GzZ6HATUuNyX@corigine.com>
From: Jamal Hadi Salim <hadi@mojatatu.com>
Date: Mon, 5 Jun 2023 10:32:20 -0400
Message-ID: <CAAFAkD8psofYNvFdKhT48NH-4SF+4j6b=3+L9X9GibuUejFeaQ@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 10/28] p4tc: add
 pipeline create, get, update, delete
To: Simon Horman <simon.horman@corigine.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org, deb.chatterjee@intel.com, 
	tom@sipanda.io, p4tc-discussions@netdevconf.info, Mahesh.Shirshyad@amd.com, 
	Vipin.Jain@amd.com, tomasz.osinski@intel.com, xiyou.wangcong@gmail.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 6:12=E2=80=AFAM Simon Horman via p4tc-discussions
<p4tc-discussions@netdevconf.info> wrote:
>
> On Wed, May 17, 2023 at 07:02:14AM -0400, Jamal Hadi Salim wrote:
>
> > +static void __tcf_pipeline_init(void)
> > +{
> > +     int pipeid =3D P4TC_KERNEL_PIPEID;
> > +
> > +     root_pipeline =3D kzalloc(sizeof(*root_pipeline), GFP_ATOMIC);
> > +     if (!root_pipeline) {
> > +             pr_err("Unable to register kernel pipeline\n");
>
> Hi Victor, Pedro, and Jamal,
>
> a minor nit from my side: in general it is preferred not to to log messag=
es
> for allocation failures, as the mm core does this already.
>

We debated this one - the justification was we wanted to see more
details of what exactly failed since this is invoked earlier in the
loading. Thoughts?

> > +             return;
> > +     }
> > +
> > +     strscpy(root_pipeline->common.name, "kernel", PIPELINENAMSIZ);
> > +
> > +     root_pipeline->common.ops =3D
> > +             (struct p4tc_template_ops *)&p4tc_pipeline_ops;
> > +
> > +     root_pipeline->common.p_id =3D pipeid;
> > +
> > +     root_pipeline->p_state =3D P4TC_STATE_READY;
> > +}
>
> ...
>
> > diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_=
api.c
>
> ...
>
> > +const struct nla_policy p4tc_root_policy[P4TC_ROOT_MAX + 1] =3D {
> > +     [P4TC_ROOT] =3D { .type =3D NLA_NESTED },
> > +     [P4TC_ROOT_PNAME] =3D { .type =3D NLA_STRING, .len =3D PIPELINENA=
MSIZ },
> > +};
> > +
> > +const struct nla_policy p4tc_policy[P4TC_MAX + 1] =3D {
> > +     [P4TC_PATH] =3D { .type =3D NLA_BINARY,
> > +                     .len =3D P4TC_PATH_MAX * sizeof(u32) },
> > +     [P4TC_PARAMS] =3D { .type =3D NLA_NESTED },
> > +};
>
> Sparse tells me that p4tc_root_policy and p4tc_policy should be
> static.

We'll fix in next update.

cheers,
jamal

> ...
> _______________________________________________
> p4tc-discussions mailing list -- p4tc-discussions@netdevconf.info
> To unsubscribe send an email to p4tc-discussions-leave@netdevconf.info

