Return-Path: <netdev+bounces-8039-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41F5C72289A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:18:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 628491C20BCB
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9770B1DDCB;
	Mon,  5 Jun 2023 14:18:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BBD1C777
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:18:10 +0000 (UTC)
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D8C98
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:18:08 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-777ac169033so26966639f.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 07:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685974688; x=1688566688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=upCUMRF+iPZe65e6wDz0/cNOzxM8TYdc181YWVDqxsA=;
        b=Cnwj1k9QS93bM9j/CcP4D0+dL5FG84Ry2+Cye8kmKK8SftqkWvRvPUphpKDbBSK82B
         jW2S6D9E6crkaYKKYq+qqCudsz3/r5hNL4vseL68bwlKztzROndZGAnf9ERlQAwECUTE
         j4bDI0Q1jBodsGBmu7uwl9W9qjYFUIGrhb2tGIgg+UsP5wrT9cCQgQT4SHasGpOXsZHV
         dKBAKc1D7I2LedhnD7Dqk2+tN/HCRUCjZ6eeLkb0eYDtoBkK7G4KWHQwJ5eafaHFCFGy
         p6ykV0K7EN/yYnR9t4JDQ9eS3rbkNdFMT2l1clpAaqM6qeVK3Wfbjgi118tz/Q/cc5lW
         yHqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685974688; x=1688566688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=upCUMRF+iPZe65e6wDz0/cNOzxM8TYdc181YWVDqxsA=;
        b=J8I7H9ZTVOq6vs2jxyqqa2XSijmrK7e6EhoDYsaHnWXjPM3K4AQ0ItXd7BzaDrXS07
         iwjTfawLjI0mqqUV+KP+UXh1W2CYp/GNh4WBMiHsnWG7Obe3iuUpqPF87N0eCyTpt1/R
         zfCtRlKI/6F4W+4wdw7xer/oI43CMaZLEwM2Al4N10ynljZ4TNhqZ7l10W9DtkKdyb5z
         NVvQU4dV2yFBZNbsQshd4aV2uusDOSDjhh7yKNAkKUR2HGnY7LGGq6qU/moOmTq/FtQI
         KWDiChBOOtpJHdDnLC1SRKL+Vzr8RTTiV+OPfwt1hWQpsZrSOs5t5LYqBvLgQn8gtfK5
         AQxw==
X-Gm-Message-State: AC+VfDznzKK6CwfkCnfejJRhKMv6TjwQGG3BKAN606GUWluOSlK3CU9J
	o+OvIpJ6QGE/HczwrNzfTSxQgtPndkXmgcTQK3LVjQ==
X-Google-Smtp-Source: ACHHUZ7WROZVLXnEaO1use2wQ17+dkdnhwYXwBdlSgsumtFOeexm35wfeDjEfq6BT5w/k8Xu3jiy5pBIfJ6cANfX5ro=
X-Received: by 2002:a6b:8d4e:0:b0:777:ab36:2817 with SMTP id
 p75-20020a6b8d4e000000b00777ab362817mr2676806iod.8.1685974688034; Mon, 05 Jun
 2023 07:18:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-5-jhs@mojatatu.com>
 <ZH2xKs65IZe1LMTC@corigine.com>
In-Reply-To: <ZH2xKs65IZe1LMTC@corigine.com>
From: Jamal Hadi Salim <hadi@mojatatu.com>
Date: Mon, 5 Jun 2023 10:17:57 -0400
Message-ID: <CAAFAkD8dUoPjff+VaRY95VsvQDpSzBdtUg=JzjJnrqsKc7AHJA@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 05/28] net/sched:
 act_api: introduce tc_lookup_action_byid()
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

Hi Simon,
Thanks for the reviews.

On Mon, Jun 5, 2023 at 5:56=E2=80=AFAM Simon Horman via p4tc-discussions
<p4tc-discussions@netdevconf.info> wrote:
>
> On Wed, May 17, 2023 at 07:02:09AM -0400, Jamal Hadi Salim wrote:
> > Introduce a lookup helper to retrieve the tc_action_ops
> > instance given its action id.
> >
> > Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> > Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> > Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> > ---
> >  include/net/act_api.h |  1 +
> >  net/sched/act_api.c   | 35 +++++++++++++++++++++++++++++++++++
> >  2 files changed, 36 insertions(+)
> >
> > diff --git a/include/net/act_api.h b/include/net/act_api.h
> > index 363f7f8b5586..34b9a9ff05ee 100644
> > --- a/include/net/act_api.h
> > +++ b/include/net/act_api.h
> > @@ -205,6 +205,7 @@ int tcf_idr_release(struct tc_action *a, bool bind)=
;
> >
> >  int tcf_register_action(struct tc_action_ops *a, struct pernet_operati=
ons *ops);
> >  int tcf_register_dyn_action(struct net *net, struct tc_action_ops *act=
);
> > +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act_i=
d);
> >  int tcf_unregister_action(struct tc_action_ops *a,
> >                         struct pernet_operations *ops);
> >  int tcf_unregister_dyn_action(struct net *net, struct tc_action_ops *a=
ct);
> > diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> > index 0ba5a4b5db6f..101c6debf356 100644
>
> > --- a/net/sched/act_api.c
> > +++ b/net/sched/act_api.c
> > @@ -1084,6 +1084,41 @@ int tcf_unregister_dyn_action(struct net *net, s=
truct tc_action_ops *act)
> >  }
> >  EXPORT_SYMBOL(tcf_unregister_dyn_action);
> >
> > +/* lookup by ID */
> > +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act_i=
d)
> > +{
> > +     struct tcf_dyn_act_net *base_net;
> > +     struct tc_action_ops *a, *res =3D NULL;
>
> Hi Jamal, Victor and Pedro,
>
> A minor nit from my side: as this is networking code, please use reverse
> xmas tree - longest line to shortest - for local variable declarations.
>

Will do in the next update.

> > +
> > +     if (!act_id)
> > +             return NULL;
> > +
> > +     read_lock(&act_mod_lock);
> > +
> > +     list_for_each_entry(a, &act_base, head) {
> > +             if (a->id =3D=3D act_id) {
> > +                     if (try_module_get(a->owner)) {
> > +                             read_unlock(&act_mod_lock);
> > +                             return a;
> > +                     }
> > +                     break;
> > +             }
> > +     }
> > +     read_unlock(&act_mod_lock);
> > +
> > +     read_lock(&base_net->act_mod_lock);
>
> base_net does not appear to be initialised here.

Yayawiya. Excellent catch. Not sure how even coverity didnt catch this
or our own internal review. I am guessing you either caught this by
eyeballing or some tool. If it is a tool we should add it to our CICD.
We have the clang static analyser but that thing produces so many
false positives that it is intense labor to review some of the
nonsense it spews - so it may have caught it and we missed it.

cheers,
jamal

> > +
> > +     base_net =3D net_generic(net, dyn_act_net_id);
> > +     a =3D idr_find(&base_net->act_base, act_id);
> > +     if (a && try_module_get(a->owner))
> > +             res =3D a;
> > +
> > +     read_unlock(&base_net->act_mod_lock);
> > +
> > +     return res;
> > +}
> > +EXPORT_SYMBOL(tc_lookup_action_byid);
> > +
> >  /* lookup by name */
> >  static struct tc_action_ops *tc_lookup_action_n(struct net *net, char =
*kind)
> >  {
> > --
> > 2.25.1
> >
> _______________________________________________
> p4tc-discussions mailing list -- p4tc-discussions@netdevconf.info
> To unsubscribe send an email to p4tc-discussions-leave@netdevconf.info

