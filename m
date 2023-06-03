Return-Path: <netdev+bounces-7658-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 250BC721025
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 15:15:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E0361C20A87
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 13:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AA5C8C7;
	Sat,  3 Jun 2023 13:15:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C391FD9
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 13:15:06 +0000 (UTC)
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960F0180
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:15:05 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-565cdb77b01so30837697b3.0
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 06:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685798104; x=1688390104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cIs/LZ10yT/itVZkw8wUvxB1WEnlgK2A+/MNaS3d+uU=;
        b=Mv99dv3uZ/1Nvxvo+ye1/20/AuHidp16/Q9DYiL4X9is4mbciTh5GC9uYIOeAB7uXp
         6v5T6pmmXhfXoWvva5oOrEgjFqsqd+a4nM/vRLfWbItGeMvL2WLYpUSr1JBFGXCy9EOf
         5+vMyh0HhiqHEhm596l3SB5F5XJSr42Frtaj1T5+zjMNdFcrW1r3JG8jx+FPBpUhz975
         J2V1UM23RRmBYkPR48mrkiUdqfq/5DfxANXEP1W7nWbcD56fFc19xk4zYF5kFaZHxNpP
         51H1GmK2Wdvfi2vP6HZ8d+kwSUW4p7ndzNx7P0NWUXVK6gRDtCHCMlDNyr+sA+ZmtRdQ
         Go5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685798104; x=1688390104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cIs/LZ10yT/itVZkw8wUvxB1WEnlgK2A+/MNaS3d+uU=;
        b=D70FX1FhipLsoPQl2CRTLATtWhAOYrsKd3Tec37eNDw084kUQ47JkKRWf8P4Xpql2G
         7Jf33KxlYr4cI1G4hE02Ut0thHXruqoEQ0z1KzI1l5Y2ApapNQCF0UbGQykPpqke7qJJ
         HFUzOjmTdO88tN8J6yo2MBhCWGwVDMVb/eQtDNUnIYx1dfWagNcTsbgMCrbPkmXptqxr
         w3X4A0dqmV8m8ZaO5X954LCmOfOZ1ZN3nzY5jw3VxNX3QFoRbbJm4jxB9Q0fZ+XP/nnk
         euRpR044Yo9KrJvFM0rhgceUjdx8vx6ycQR824sPF0z0FpjLHYGogA0s3LHtTfm2hPOg
         cUIg==
X-Gm-Message-State: AC+VfDzBtQSUcqKj3L+grp/qL4VtjF/+RrXF1c2/ibL82GKgBxajPgn5
	8I7TYz91sDGXKGSlsiTHJ9Fo8eEhmzwmrod/venDcA==
X-Google-Smtp-Source: ACHHUZ5BLaBH0hKxVqP1Vn46udExl763wGlIYVl4IlBgYr9VDxpVRTk7SAa88y4Cec8jKMQ5hOovHPTP98wkoqsTf/0=
X-Received: by 2002:a0d:cd85:0:b0:565:a3d1:be19 with SMTP id
 p127-20020a0dcd85000000b00565a3d1be19mr523854ywd.31.1685798104597; Sat, 03
 Jun 2023 06:15:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-5-jhs@mojatatu.com>
 <CALnP8ZYDriSnxVtdUD5_hcvop_ojuTHWoK8DpQ+x4KgBqRTD2w@mail.gmail.com>
In-Reply-To: <CALnP8ZYDriSnxVtdUD5_hcvop_ojuTHWoK8DpQ+x4KgBqRTD2w@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 3 Jun 2023 09:14:53 -0400
Message-ID: <CAM0EoMnBCHyG0w4wV6abAL1X9GU2vMK=nK8e66G-EDttQhKTpw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 05/28] net/sched: act_api: introduce tc_lookup_action_byid()
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com, anjali.singhai@intel.com, 
	namrata.limaye@intel.com, tom@sipanda.io, p4tc-discussions@netdevconf.info, 
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com, 
	jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com, 
	simon.horman@corigine.com, khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 3:36=E2=80=AFPM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
>
> On Wed, May 17, 2023 at 07:02:09AM -0400, Jamal Hadi Salim wrote:
> > +/* lookup by ID */
> > +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act_i=
d)
> > +{
> > +     struct tcf_dyn_act_net *base_net;
> > +     struct tc_action_ops *a, *res =3D NULL;
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
>
> It shouldn't call break here but instead already return NULL:
> if id matched, it cannot be present on the dyn list.
>
> Moreover, the search be optimized: now that TCA_ID_ is split between
> fixed and dynamic ranges (patch #3), it could jump directly into the
> right list. Control path performance is also important..



Sorry - didnt respond to this last part: We could use standard tc
actions in a P4 program and we prioritize looking at them first. This
helper is currently only needed for us - so you could argue that we
should only look TCA_ID_DYN onwards but it is useful to be more
generic and since this is a slow path it is not critical. Unless i
misunderstood what you said.

cheers,
jamal

> > +             }
> > +     }
> > +     read_unlock(&act_mod_lock);
> > +
> > +     read_lock(&base_net->act_mod_lock);
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
>

