Return-Path: <netdev+bounces-7659-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D479D721028
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 15:18:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F376281985
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 13:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE55C8D1;
	Sat,  3 Jun 2023 13:18:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914A62904
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 13:18:11 +0000 (UTC)
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3256918C
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:18:10 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 3f1490d57ef6-ba8374001abso3359365276.2
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 06:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685798289; x=1688390289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBq1INl084O3qmcRFW9JDk3rEn48gYCYhgMkAkeB+Gs=;
        b=3zarHBscskERgfpLTVqNTPdO/y21Q8unnZvR/RW5gPc0EgPEqlS3/teDm+fW0oZJnQ
         9VaERHGX86s4guwQoHRUKBl+20FAc1lqInpXmsAo+7NVL94BKzzsm7aH7ExZT67UNT0B
         zFjaQqQ0OltnA0Y+rZHVksBO8f8T6nZa1rDsflfAu/g8yPXxCSLhjWse0eut5WO+2/K6
         bF6y1Dfwzsr+dZuoO/PR67FdWCEVsfbr8vFCyafYuaYcpk9pqGUTVG+9ExyrDpJhfo9i
         aU2SQ7uyHJtwfXbMSfLPAmD16/aomgYze+BGn0JK8E+4E22/xV7feOFRim+lohJ7yzPz
         Ds4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685798289; x=1688390289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KBq1INl084O3qmcRFW9JDk3rEn48gYCYhgMkAkeB+Gs=;
        b=dHJTf5lhFZtCG/tylzBpOc2G1CAuqijZn89WBCKeab1aEfatM/wvt4h6+rRxY3c/+9
         FDGwGBzXiMkDkOZEQOZu7ti0N6DdC0hBuqULn5vGXYHu9sW/rFH/Sc5SBZX75hhf0FOJ
         D/uaCTPbUuKJy5D4KozgdtHHfUS9RZvJ+LHIa41EMa0XViW8flu9HPhYxjJfZ8NG7G5y
         vm82Athx8S/dh8TD6QhuE6wGMgn4X2b2H+8/Y/9/+dHmRPsfn1MpEN78x6KqLXX57+mw
         TPW38lJkb/y0L1o0GxuC68Lg0J9HOD4UVvNN0KgDze960Lq2ehpjHwZkZvYF31wz84R6
         ReWw==
X-Gm-Message-State: AC+VfDyH6KiUjWVQci5z5O24rfx3ABa3tNwidhW8FsltT/rFDuUfExGW
	lfLR0Im4kpwKguTl+CmFitw7bS9Q/GnILAhQBarSIQ==
X-Google-Smtp-Source: ACHHUZ5eQAskbe1g1xk9u1xNbJCYNVQXw1PMCANjOhsa69MdmQSMfv1R6mVZSUfLf2Po8u8g9c/jazaC3eqIj+Bw8VU=
X-Received: by 2002:a0d:cb53:0:b0:561:a7fd:d6b3 with SMTP id
 n80-20020a0dcb53000000b00561a7fdd6b3mr3622642ywd.33.1685798288740; Sat, 03
 Jun 2023 06:18:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-7-jhs@mojatatu.com>
 <CALnP8ZZ60R3ToiKfTkF6JTA6UpL4=6D+D1b37b1S8_2OA-sGqA@mail.gmail.com>
In-Reply-To: <CALnP8ZZ60R3ToiKfTkF6JTA6UpL4=6D+D1b37b1S8_2OA-sGqA@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 3 Jun 2023 09:17:57 -0400
Message-ID: <CAM0EoMm1qr+GAehEZzmmd5TZL5Ases-T=q0KZYTF49DOXdU6tw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 07/28] net/sched: act_api: add struct
 p4tc_action_ops as a parameter to lookup callback
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

On Fri, Jun 2, 2023 at 3:43=E2=80=AFPM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
>
> On Wed, May 17, 2023 at 07:02:11AM -0400, Jamal Hadi Salim wrote:
> > @@ -115,7 +115,8 @@ struct tc_action_ops {
> >                      struct tcf_result *); /* called under RCU BH lock*=
/
> >       int     (*dump)(struct sk_buff *, struct tc_action *, int, int);
> >       void    (*cleanup)(struct tc_action *);
> > -     int     (*lookup)(struct net *net, struct tc_action **a, u32 inde=
x);
> > +     int     (*lookup)(struct net *net, const struct tc_action_ops *op=
s,
> > +                       struct tc_action **a, u32 index);
> >       int     (*init)(struct net *net, struct nlattr *nla,
> >                       struct nlattr *est, struct tc_action **act,
> >                       struct tcf_proto *tp,
> > diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> > index ba0315e686bf..788127329d96 100644
> > --- a/net/sched/act_api.c
> > +++ b/net/sched/act_api.c
> > @@ -728,7 +728,7 @@ int __tcf_idr_search(struct net *net, const struct =
tc_action_ops *ops,
> >       struct tc_action_net *tn =3D net_generic(net, ops->net_id);
> >
> >       if (unlikely(ops->lookup))
> > -             return ops->lookup(net, a, index);
> > +             return ops->lookup(net, ops, a, index);
>
> Interesting. I could swear that this patch would break the build if
> only up to this patch was applied (like in a git bisect), but then,
> currently no action is defining this method. :D
>

We test every patch individually for compile for git bisect reasons,
so it would be hard to find one that escapes our process ;->

cheers,
jamal

