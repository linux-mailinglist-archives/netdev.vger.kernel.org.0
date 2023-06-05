Return-Path: <netdev+bounces-8084-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AE68722A31
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5928281010
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265CA1F92C;
	Mon,  5 Jun 2023 15:04:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1970D6FDE
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:04:48 +0000 (UTC)
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AEE9C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:04:47 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-565c7399afaso54334667b3.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 08:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685977486; x=1688569486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SjbbBA7EontyB9HzSIqPzzJatS75a7JE8YVdrZrGYTE=;
        b=H0WAJfZCnQWtUwg66hVGjFLtBxr7jex6m2+ftYdjEDx22aHUaMnFuseL6Z3p0MabgF
         vPz42FEpePd271ITIEWgvrf/Jhx+HRhPrBU4eGdLtyvRldN5sEGSHaqKn8N+F76nOOhA
         m94rRASS5uxoa8iL7NJurLj19KGOgWYIybOsHktx4GG6VxD4+FB+TfLheJ805iQUdtLn
         hGGZh5sD9T/ZY3mrpIQK1Eum+xVAflL42bxtUUoZgEhIaCTxkSnMuUk0Rd3LZm9nU9sZ
         JehMrmP/hFa/CBR5GZKivrxlGxwQ9W6l4pTKKAoejeiEaX7Hx3U+VzteyPgl5qdIxBl9
         cCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685977486; x=1688569486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SjbbBA7EontyB9HzSIqPzzJatS75a7JE8YVdrZrGYTE=;
        b=HLkgzunscMOoedLKhMn05f4CvSl5ix1NGIMJZhu8FLUnLhz8yOZX2wKPj/w5bLu/ii
         0+oO37ECPZnjzgvr4O6KIpNf8Ul2EQ2jrMc0YY62xEwWDAViasCnH34Z1TPnnqDE72l6
         lLnrnWKYUVFMFF/jmZ0K6Ig07s2q5J1iipn+/sVfejRvpHWtZB9mWcVTcZOdF1IZaJXm
         mbxAaan1yRzTGYQAKFw1BFvtesxin97kWvXD3l11awcCLZ1SfJBerjwofnLfVUOOuN7p
         RW8rbF46QDTJooIIqhqTKEkLbXhvTM1xftEYy4L1WDsppexWjN1ePV1vLn/jj5uq6PD8
         0GTA==
X-Gm-Message-State: AC+VfDypkJxJMbPnTAzSeksVsI/7Q9v1K3MPgcZVnzzSYXdVhhalKyk4
	kIguSGunYyOarkZ2pjca7jSc0E6Radffemaa8ZM9IQ==
X-Google-Smtp-Source: ACHHUZ4xl/httMV2kWtvZPSn3MgEda8DNQVfguIJ6PbcSeS4xHHbfrqhqH4TOsiSMvNtwuWKGQ2v0b/TmC40+40uCe0=
X-Received: by 2002:a0d:d594:0:b0:561:90b3:e712 with SMTP id
 x142-20020a0dd594000000b0056190b3e712mr10418898ywd.28.1685977486585; Mon, 05
 Jun 2023 08:04:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-5-jhs@mojatatu.com>
 <ZH2xKs65IZe1LMTC@corigine.com> <CAAFAkD8dUoPjff+VaRY95VsvQDpSzBdtUg=JzjJnrqsKc7AHJA@mail.gmail.com>
 <ZH3x3mT+80K1BR1O@corigine.com>
In-Reply-To: <ZH3x3mT+80K1BR1O@corigine.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 5 Jun 2023 11:04:35 -0400
Message-ID: <CAM0EoMk1HNE5zgnjs_YozQcXuQWw9kn6QKHZp+dJU5zhPGhpeg@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 05/28] net/sched:
 act_api: introduce tc_lookup_action_byid()
To: Simon Horman <simon.horman@corigine.com>
Cc: Jamal Hadi Salim <hadi@mojatatu.com>, netdev@vger.kernel.org, deb.chatterjee@intel.com, 
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

On Mon, Jun 5, 2023 at 10:32=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Mon, Jun 05, 2023 at 10:17:57AM -0400, Jamal Hadi Salim wrote:
> > Hi Simon,
> > Thanks for the reviews.
> >
> > On Mon, Jun 5, 2023 at 5:56=E2=80=AFAM Simon Horman via p4tc-discussion=
s
> > <p4tc-discussions@netdevconf.info> wrote:
> > >
> > > On Wed, May 17, 2023 at 07:02:09AM -0400, Jamal Hadi Salim wrote:
> > > > Introduce a lookup helper to retrieve the tc_action_ops
> > > > instance given its action id.
> > > >
> > > > Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> > > > Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> > > > Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> > > > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > > > Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> > > > ---
> > > >  include/net/act_api.h |  1 +
> > > >  net/sched/act_api.c   | 35 +++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 36 insertions(+)
> > > >
> > > > diff --git a/include/net/act_api.h b/include/net/act_api.h
> > > > index 363f7f8b5586..34b9a9ff05ee 100644
> > > > --- a/include/net/act_api.h
> > > > +++ b/include/net/act_api.h
> > > > @@ -205,6 +205,7 @@ int tcf_idr_release(struct tc_action *a, bool b=
ind);
> > > >
> > > >  int tcf_register_action(struct tc_action_ops *a, struct pernet_ope=
rations *ops);
> > > >  int tcf_register_dyn_action(struct net *net, struct tc_action_ops =
*act);
> > > > +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 a=
ct_id);
> > > >  int tcf_unregister_action(struct tc_action_ops *a,
> > > >                         struct pernet_operations *ops);
> > > >  int tcf_unregister_dyn_action(struct net *net, struct tc_action_op=
s *act);
> > > > diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> > > > index 0ba5a4b5db6f..101c6debf356 100644
> > >
> > > > --- a/net/sched/act_api.c
> > > > +++ b/net/sched/act_api.c
> > > > @@ -1084,6 +1084,41 @@ int tcf_unregister_dyn_action(struct net *ne=
t, struct tc_action_ops *act)
> > > >  }
> > > >  EXPORT_SYMBOL(tcf_unregister_dyn_action);
> > > >
> > > > +/* lookup by ID */
> > > > +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 a=
ct_id)
> > > > +{
> > > > +     struct tcf_dyn_act_net *base_net;
> > > > +     struct tc_action_ops *a, *res =3D NULL;
> > >
> > > Hi Jamal, Victor and Pedro,
> > >
> > > A minor nit from my side: as this is networking code, please use reve=
rse
> > > xmas tree - longest line to shortest - for local variable declaration=
s.
> > >
> >
> > Will do in the next update.
> >
> > > > +
> > > > +     if (!act_id)
> > > > +             return NULL;
> > > > +
> > > > +     read_lock(&act_mod_lock);
> > > > +
> > > > +     list_for_each_entry(a, &act_base, head) {
> > > > +             if (a->id =3D=3D act_id) {
> > > > +                     if (try_module_get(a->owner)) {
> > > > +                             read_unlock(&act_mod_lock);
> > > > +                             return a;
> > > > +                     }
> > > > +                     break;
> > > > +             }
> > > > +     }
> > > > +     read_unlock(&act_mod_lock);
> > > > +
> > > > +     read_lock(&base_net->act_mod_lock);
> > >
> > > base_net does not appear to be initialised here.
> >
> > Yayawiya. Excellent catch. Not sure how even coverity didnt catch this
> > or our own internal review. I am guessing you either caught this by
> > eyeballing or some tool. If it is a tool we should add it to our CICD.
> > We have the clang static analyser but that thing produces so many
> > false positives that it is intense labor to review some of the
> > nonsense it spews - so it may have caught it and we missed it.
>
> Hi Jamal,
>
> My eyes are not so good these days, so I use tooling.
>
> In this case it is caught by a W=3D1 build using both gcc-12 and clang-16=
,
> and by Smatch. I would also recommend running Sparse, Coccinelle,
> and the xmastree check from Edward Cree [1].
>
> [1] https://github.com/ecree-solarflare/xmastree
>
> FWIIW, I only reviewed the first 12 patches of this series.
> If you could run the above mentioned tools over the remaining patches you
> may find some more things of interest.

We will certainly be doing this in the next day or two.

cheers,
jamal

