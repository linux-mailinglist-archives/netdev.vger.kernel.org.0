Return-Path: <netdev+bounces-7982-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44F9472253E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2E8E2810D2
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B29182AF;
	Mon,  5 Jun 2023 12:08:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55820525E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:08:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7C292
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685966925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BLbS50OJ0t1bwcZdXh7ykBSEpBom8HPq/+cANJwK+Ns=;
	b=Q5hQe1S8dt4j4rI6PoZUqdhFuOUh2E7sKPpOQFE+qOvg02seiJN8s6f+D8tKJN/hJPFxeb
	ViZRCPju9ezI8sEhI8WgwByOOEDf4xk5qqOZ5DjuU6NcqbGul9s6rLcF4/G20hhFXpz28N
	cjavirEMlIqLhk6XtpM16RGbpZh9Z7s=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-l-VQrkkiOu-XuXYhTOb3CQ-1; Mon, 05 Jun 2023 08:08:44 -0400
X-MC-Unique: l-VQrkkiOu-XuXYhTOb3CQ-1
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-43b187f3d68so890166137.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 05:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685966924; x=1688558924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:in-reply-to
         :mime-version:references:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BLbS50OJ0t1bwcZdXh7ykBSEpBom8HPq/+cANJwK+Ns=;
        b=XlN0xG7Ou/bM/9N/XKA31a7+DKQfzMwYVwYOIwothTDSRw5BANOWBaI9G1RnPuYgyg
         O2e+V6tDfWxJWbjuvPMaA/2Y8YTG0oHHvyxoQzpxrGIbLQCdi3Qmy1UnQ7bV9BM0PGXd
         r9VcBlFQHDF2lXEMs519J0Pp5ebF66FgL2xF3wLRSXUsNaQuFgb2Azz2ow/bz6vqqVtF
         UDjb0a0wbkBHTDyKvFQjPukPVvaXBiU8V+oTLH+8+hiP5fgZm3Cbym3gyDLuSGFNwR4p
         igG8KlajqUdDtLxE6fetIxMk1ceV+8sPpHWTIaDrX5M6i30oiAtcKpnpCdJ+3EjgImvi
         Ugdg==
X-Gm-Message-State: AC+VfDxLFIhQQkXLAwqwewYvKuC9jDBDswMZ+/TroKLWdFI0PBFKBw84
	X5t2MagkYXGHbiPAktD/PQ+3F3qdglznYzisjy3LZPSgt/3BMAAslTEBzFHctBULeRYdnyOLYH4
	nfpKIpXWfZfusQOxf4s1GuvTSzpuUszr5
X-Received: by 2002:a67:ee99:0:b0:434:5839:bdc4 with SMTP id n25-20020a67ee99000000b004345839bdc4mr7977311vsp.25.1685966923892;
        Mon, 05 Jun 2023 05:08:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5B5t1YSDmu1Iov9I/CiU4Lr9iMtuznGn3qDBZtfesGpynLgQpjScPxrCY89qZ+jeONpQ4JwU4QaqFoMhRGOeg=
X-Received: by 2002:a67:ee99:0:b0:434:5839:bdc4 with SMTP id
 n25-20020a67ee99000000b004345839bdc4mr7977296vsp.25.1685966923623; Mon, 05
 Jun 2023 05:08:43 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 5 Jun 2023 07:08:43 -0500
From: Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-5-jhs@mojatatu.com>
 <CALnP8ZYDriSnxVtdUD5_hcvop_ojuTHWoK8DpQ+x4KgBqRTD2w@mail.gmail.com> <CAM0EoMnBCHyG0w4wV6abAL1X9GU2vMK=nK8e66G-EDttQhKTpw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAM0EoMnBCHyG0w4wV6abAL1X9GU2vMK=nK8e66G-EDttQhKTpw@mail.gmail.com>
Date: Mon, 5 Jun 2023 07:08:42 -0500
Message-ID: <CALnP8Za_MOB-m2u=jQe3_GZFhwJJSHZcL5A1P6iytxD+0hvvZA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 05/28] net/sched: act_api: introduce tc_lookup_action_byid()
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com, anjali.singhai@intel.com, 
	namrata.limaye@intel.com, tom@sipanda.io, p4tc-discussions@netdevconf.info, 
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com, 
	jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com, 
	simon.horman@corigine.com, khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 03, 2023 at 09:14:53AM -0400, Jamal Hadi Salim wrote:
> On Fri, Jun 2, 2023 at 3:36=E2=80=AFPM Marcelo Ricardo Leitner
> <mleitner@redhat.com> wrote:
> >
> > On Wed, May 17, 2023 at 07:02:09AM -0400, Jamal Hadi Salim wrote:
> > > +/* lookup by ID */
> > > +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act=
_id)
> > > +{
> > > +     struct tcf_dyn_act_net *base_net;
> > > +     struct tc_action_ops *a, *res =3D NULL;
> > > +
> > > +     if (!act_id)
> > > +             return NULL;
> > > +
> > > +     read_lock(&act_mod_lock);
> > > +
> > > +     list_for_each_entry(a, &act_base, head) {
> > > +             if (a->id =3D=3D act_id) {
> > > +                     if (try_module_get(a->owner)) {
> > > +                             read_unlock(&act_mod_lock);
> > > +                             return a;
> > > +                     }
> > > +                     break;
> >
> > It shouldn't call break here but instead already return NULL:
> > if id matched, it cannot be present on the dyn list.
> >
> > Moreover, the search be optimized: now that TCA_ID_ is split between
> > fixed and dynamic ranges (patch #3), it could jump directly into the
> > right list. Control path performance is also important..
>
>
>
> Sorry - didnt respond to this last part: We could use standard tc
> actions in a P4 program and we prioritize looking at them first. This
> helper is currently only needed for us - so you could argue that we
> should only look TCA_ID_DYN onwards but it is useful to be more
> generic and since this is a slow path it is not critical. Unless i

Yes, and no. Control path is not as critical as datapath, I agree with
that, but it's also important. It's a small change, but oh well.. it
should accumulate on complex datapaths.

> misunderstood what you said.

I meant something like this:

+     if (act_id < TCA_ID_DYN) {
+         read_lock(&act_mod_lock);
+
+         list_for_each_entry(a, &act_base, head) {
+                 if (a->id =3D=3D act_id) {
+                         if (try_module_get(a->owner)) {
+                                 read_unlock(&act_mod_lock);
+                                 return a;
+                         }
+                         break; /* now break; is okay */
+                 }
+         }
+         read_unlock(&act_mod_lock);
+     } else {
+         read_lock(&base_net->act_mod_lock);
+
+         base_net =3D net_generic(net, dyn_act_net_id);
+         a =3D idr_find(&base_net->act_base, act_id);
+         if (a && try_module_get(a->owner))
+                 res =3D a;
+
+         read_unlock(&base_net->act_mod_lock);
+     }

>
> cheers,
> jamal
>
> > > +             }
> > > +     }
> > > +     read_unlock(&act_mod_lock);
> > > +
> > > +     read_lock(&base_net->act_mod_lock);
> > > +
> > > +     base_net =3D net_generic(net, dyn_act_net_id);
> > > +     a =3D idr_find(&base_net->act_base, act_id);
> > > +     if (a && try_module_get(a->owner))
> > > +             res =3D a;
> > > +
> > > +     read_unlock(&base_net->act_mod_lock);
> > > +
> > > +     return res;
> > > +}
> > > +EXPORT_SYMBOL(tc_lookup_action_byid);
> >
>


