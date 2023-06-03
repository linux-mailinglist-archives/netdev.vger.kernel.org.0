Return-Path: <netdev+bounces-7656-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21CAF721021
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 15:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23ADE280E60
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 13:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141BCC2F8;
	Sat,  3 Jun 2023 13:03:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DEE1FD9
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 13:03:36 +0000 (UTC)
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3226B18C
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:03:35 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-565ee3d14c2so33777257b3.2
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 06:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685797414; x=1688389414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GETtXG3dz5Xh9oZ9tHr1jKs9WxcsmWGKXhLbeCyWoA4=;
        b=3gEtsONDbpSWWHsywXk7vuzBcVeUa4+sXQ/4Frd6kFSdR0hLUJPEHXaxRoXZaGp75B
         GdkBI9Af7rk4LyF8o/Wcc+mK4oBvEI98PgxSplCbYzDshPmkmeiZZ/L8r0kQdm4uWkeC
         CDdT9ZkF+cLYzGOFb2fAs/LdMrSmgFRsbSS8dRbOa2PrDaNLPhppvGWqsPVfB5I5AEGU
         Gd7N17FOPohrn7hpQfgmQ+U1rDLeossr1ZK7PuUVQ4vYRa6a/SBjL0CRUD8rMywoKEsk
         grQKdTAFIbktzSS4Z5Ka2ypuvtz8AOOKguoKcsDrbLIcZWzuXzJjSOVBrypjYkgSisHB
         s1Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685797414; x=1688389414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GETtXG3dz5Xh9oZ9tHr1jKs9WxcsmWGKXhLbeCyWoA4=;
        b=DQe+0au1OH8YhRSF7SCCzlUj+6e2ftQWTyj/1uV0dvsOr8v8LbCwrgEP/+oMlGbT8v
         Ja0Y4xeK0oCykNTSVqOIRGf9mRxp7Sly8OwPU1AsATSTmvA88HI1Klz7BK1t4c+p9bmr
         RreQOKp8qq0IQyx4d8/K3El/29wErmtYfdiCLmDaaViZdwfFdgifx9fAsx4uk09FdlzY
         x3xGkyxSpilN0xYBFUxZlWwNW6kam6dwfZtlswo7hEFn8ShN8c59jOXWq+rwXEe31a46
         4QQNbcee9W9fOlm4lC5Bb3IkL+iV1Np/TvQEmhpfuQeDby6IssDprs+Hw516Z4cuptj3
         V7MA==
X-Gm-Message-State: AC+VfDxoWCOueUBp7HPbCN8/vpko56sxhoc6CP/ftUOWZsvu1/+WvVSS
	zl1pWbyqvS501n5koRMB42RPZ/165xO4NgRLxz9cJw==
X-Google-Smtp-Source: ACHHUZ6rfcheXqfGucCBpER7tbr6JmSYkU3jPdvBDnRzXco/w4AgfjiGACfzWPAK2zSarwMz5N/fl2ds2cAuxXI2lLc=
X-Received: by 2002:a81:a009:0:b0:561:8c55:738e with SMTP id
 x9-20020a81a009000000b005618c55738emr3803214ywg.12.1685797414451; Sat, 03 Jun
 2023 06:03:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-3-jhs@mojatatu.com>
 <CALnP8ZbH+V5gq90+m8uwYy_8V-FKQtoVmEdj1DKw051RdBJ8xw@mail.gmail.com>
In-Reply-To: <CALnP8ZbH+V5gq90+m8uwYy_8V-FKQtoVmEdj1DKw051RdBJ8xw@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 3 Jun 2023 09:03:23 -0400
Message-ID: <CAM0EoMmQNjt=rkBntFPSEAe5RWHNMKzZEkZtyOZ_dK7q3zC3KA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 03/28] net/sched: act_api: increase TCA_ID_MAX
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

On Fri, Jun 2, 2023 at 10:19=E2=80=AFAM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
>
> On Wed, May 17, 2023 at 07:02:07AM -0400, Jamal Hadi Salim wrote:
> > --- a/include/uapi/linux/pkt_cls.h
> > +++ b/include/uapi/linux/pkt_cls.h
> > @@ -140,9 +140,9 @@ enum tca_id {
> >       TCA_ID_MPLS,
> >       TCA_ID_CT,
> >       TCA_ID_GATE,
> > -     TCA_ID_DYN,
> > +     TCA_ID_DYN =3D 256,
> >       /* other actions go here */
> > -     __TCA_ID_MAX =3D 255
> > +     __TCA_ID_MAX =3D 1023
> >  };
>
> It feels that this patch should go together with the 1st one, when
> dynamic actions were introduced. When I was reading that patch, I was
> wondering about possible conflicts with a new loaded dynamic action
> and some userspace app using a new tca_id definition (it is UAPI,
> after all) that overlaps with it.

Good catch. We'll make this change in the next update.

cheers,
jamal

