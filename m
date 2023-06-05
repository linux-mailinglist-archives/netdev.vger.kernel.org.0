Return-Path: <netdev+bounces-8079-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9442F722A0E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BD6A1C20CBB
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B64662106A;
	Mon,  5 Jun 2023 14:56:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C3F10FB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:56:08 +0000 (UTC)
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAC0A7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:56:07 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-33d269dd56bso13316935ab.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 07:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685976966; x=1688568966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsjnvYo005eC+L8nxmBDjDjky4ckEQgn5pPpk2NUDZA=;
        b=f35TRSQBO4C0CbpcXyXtKAIMkZuulsoa/zkhLdbTNoNCAI8DvmBq/AUyD27GC2N8/H
         7R+bAYElKK3zeY54Pz9mQ5lg+fVwFPE0kl9oINmbGILvsT/T4Bhf3+onNmfLr59Ob6K2
         ppza6LTOE8SCPqNoi/p7/dPxbmCg1FRvZLfGhZoHr13dxpa29f2sZjRKBWD2ci3Rs85T
         fxFMurMJoVJ1Y49CzSt83xo2fi9VYZbxFfGZFsE/ztFenBfyMXZZeEl7mz0EmYdBWPrW
         MYQx5MhQB/Hd1qZwhF6dHFPBVqvu08bpzjccuNQH3zvX3N/TfFa1acNxp8GJ8B30LT+K
         WV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685976966; x=1688568966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsjnvYo005eC+L8nxmBDjDjky4ckEQgn5pPpk2NUDZA=;
        b=cHXMV4Xyitnk8LtCXFCSUlKq1VMsvBNyaTqn86snm/gUPC+52bKlS2WemNq9/9/ZZ/
         b/ilUg2joX8kZKl6uqEX2Ch/qX20odsdfr3MQ64EqoNj7TCHm3gzmXD+9LjJ4MGQa1Dv
         AlURmk/1BIqXuIVhATmti+V4YOII79bEap+pj5JQcndhbiblXueF8/AvlmOdWNPuo0mm
         KUFJ/nh4864Owpwi5r/l1xrA6NrIicDIHPFNdhG/ALhj5WpnjQt6sUDehYlzAxaZJpUD
         P6D0t2waSBjQ4HYOCaD9YMr99e1+LomgBLJVVivWrWpTqqaQODsstWAc/TnDrjoCsCRQ
         QcEQ==
X-Gm-Message-State: AC+VfDzsURnuSod3Utsj80euF0dKnzzXl8x8hH0nhX0kWXA3CRB3cUAV
	BuYHmJfkeNR153xB/HMnFYDlH5yTgvS0sP4O+D/tRQ==
X-Google-Smtp-Source: ACHHUZ7kaYV+R4/IVvSH9UxzS7XKer1+ZKED0Wh1d5a1CEPaQSIFX8Nod7pBXEpUxl/CATtjb+/jBFtuWWZ5rpPFL6k=
X-Received: by 2002:a92:502:0:b0:33d:8b4e:6613 with SMTP id
 q2-20020a920502000000b0033d8b4e6613mr53699ile.15.1685976966682; Mon, 05 Jun
 2023 07:56:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-5-jhs@mojatatu.com>
 <CALnP8ZYDriSnxVtdUD5_hcvop_ojuTHWoK8DpQ+x4KgBqRTD2w@mail.gmail.com>
 <CAM0EoMnBCHyG0w4wV6abAL1X9GU2vMK=nK8e66G-EDttQhKTpw@mail.gmail.com> <CALnP8Za_MOB-m2u=jQe3_GZFhwJJSHZcL5A1P6iytxD+0hvvZA@mail.gmail.com>
In-Reply-To: <CALnP8Za_MOB-m2u=jQe3_GZFhwJJSHZcL5A1P6iytxD+0hvvZA@mail.gmail.com>
From: Jamal Hadi Salim <hadi@mojatatu.com>
Date: Mon, 5 Jun 2023 10:55:56 -0400
Message-ID: <CAAFAkD8XKBfNEQW7J7KP90eYcuA62gOD+i1ifP+xZUZD6-=Nug@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 05/28] net/sched:
 act_api: introduce tc_lookup_action_byid()
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
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

On Mon, Jun 5, 2023 at 8:08=E2=80=AFAM Marcelo Ricardo Leitner via
p4tc-discussions <p4tc-discussions@netdevconf.info> wrote:
>
> On Sat, Jun 03, 2023 at 09:14:53AM -0400, Jamal Hadi Salim wrote:
> > On Fri, Jun 2, 2023 at 3:36=E2=80=AFPM Marcelo Ricardo Leitner
> > <mleitner@redhat.com> wrote:
> > >
> > > On Wed, May 17, 2023 at 07:02:09AM -0400, Jamal Hadi Salim wrote:
> > > > +/* lookup by ID */
> > > > +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 a=
ct_id)
> > > > +{
> > > > +     struct tcf_dyn_act_net *base_net;
> > > > +     struct tc_action_ops *a, *res =3D NULL;
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
> > >
> > > It shouldn't call break here but instead already return NULL:
> > > if id matched, it cannot be present on the dyn list.
> > >
> > > Moreover, the search be optimized: now that TCA_ID_ is split between
> > > fixed and dynamic ranges (patch #3), it could jump directly into the
> > > right list. Control path performance is also important..
> >
> >
> >
> > Sorry - didnt respond to this last part: We could use standard tc
> > actions in a P4 program and we prioritize looking at them first. This
> > helper is currently only needed for us - so you could argue that we
> > should only look TCA_ID_DYN onwards but it is useful to be more
> > generic and since this is a slow path it is not critical. Unless i
>
> Yes, and no. Control path is not as critical as datapath, I agree with
> that, but it's also important. It's a small change, but oh well.. it
> should accumulate on complex datapaths.
>
> > misunderstood what you said.
>
> I meant something like this:
>
> +     if (act_id < TCA_ID_DYN) {
> +         read_lock(&act_mod_lock);
> +
> +         list_for_each_entry(a, &act_base, head) {
> +                 if (a->id =3D=3D act_id) {
> +                         if (try_module_get(a->owner)) {
> +                                 read_unlock(&act_mod_lock);
> +                                 return a;
> +                         }
> +                         break; /* now break; is okay */
> +                 }
> +         }
> +         read_unlock(&act_mod_lock);
> +     } else {
> +         read_lock(&base_net->act_mod_lock);
> +
> +         base_net =3D net_generic(net, dyn_act_net_id);
> +         a =3D idr_find(&base_net->act_base, act_id);
> +         if (a && try_module_get(a->owner))
> +                 res =3D a;
> +
> +         read_unlock(&base_net->act_mod_lock);
> +     }

Reasonable. We will update with this approach. Thanks Marcelo.

cheers,
jamal

> >
> > cheers,
> > jamal
> >
> > > > +             }
> > > > +     }
> > > > +     read_unlock(&act_mod_lock);
> > > > +
> > > > +     read_lock(&base_net->act_mod_lock);
> > > > +
> > > > +     base_net =3D net_generic(net, dyn_act_net_id);
> > > > +     a =3D idr_find(&base_net->act_base, act_id);
> > > > +     if (a && try_module_get(a->owner))
> > > > +             res =3D a;
> > > > +
> > > > +     read_unlock(&base_net->act_mod_lock);
> > > > +
> > > > +     return res;
> > > > +}
> > > > +EXPORT_SYMBOL(tc_lookup_action_byid);
> > >
> >
>
> _______________________________________________
> p4tc-discussions mailing list -- p4tc-discussions@netdevconf.info
> To unsubscribe send an email to p4tc-discussions-leave@netdevconf.info

