Return-Path: <netdev+bounces-9512-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79D8C7298E0
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:59:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3398A2818C8
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8502F16416;
	Fri,  9 Jun 2023 11:59:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3AB79E5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:59:01 +0000 (UTC)
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE95C35A9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 04:58:59 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-568af2f6454so15457477b3.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 04:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686311939; x=1688903939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ph/g1QYCuQ2I5zRLUhOtnSBZFThTxv2+et3oMtQd1fU=;
        b=o1Y/SVANQiuGKGDYyn5b/nwQKlLSKO43rUke27uvB8rtHIkXQQuNxFKQjzN5lhAsEI
         ejbkAdgiYjy0MsoGHkT334jZDfmax3QwLyNk8maMlGUXqDIKG6wruFt/K8KaZmNk4EQV
         VmrSmxj+czaXxT27wqGhFa9IQK8QTc3SIjSKmxDz6fkm44zDSag97e389Jw5JmVsKstX
         7JsL4N7gZQ0+Lck09ZRvqd5CdC8BOdePUx+YNoH5CLI/9Vx6E7TWpVSMowFxrnGfkgsM
         aqLGyy5vs2/56ji/T/09j+mDl2Djwe0WXUKrth6ZYes1YSataAySiKhyYA3R4hOWxsi2
         sw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686311939; x=1688903939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ph/g1QYCuQ2I5zRLUhOtnSBZFThTxv2+et3oMtQd1fU=;
        b=cFVroRBSMTKhf/KtXEKF8iyYz1yrIJYEw7M+ddq9eK8S7QMiQwbx3o/426SoAX7At+
         ANLcnkCJ+Us+lEdVg0YIYjeySPX22jNuXQNH5nmbOpq7w/jiA1jj2HyySt2Py42AXFMn
         5RkpiShkzfKePK97iwVvehinPMHwNgMEqPtpDU2RBowwWub2hBA+7XvfBR46acRiw5LG
         l2ZzDmo6HGtXqwmM2c66qoEN3nOtgzEg9kGPWsxSuRQIgOvhuKTj9XLnz7sDImNhzgFW
         KRlldOtX5rOh00z1LnG4ECo9UmEMGsef+E+mIreRWvPAtdsjHnNH6s8CU6ZEWXsoVJ0k
         RwCA==
X-Gm-Message-State: AC+VfDzINsbkYHe10E+zsfRvvdXnaBTFbMDdL+n38vK9fWNKPQ4ohmcY
	ibV3MJ33ABMhNFhcywnxBDLS3l9f+uVgztKNzkK60g==
X-Google-Smtp-Source: ACHHUZ5lIEADb7H3QAz4n7CvTObzRPmJ+xmeumnj1UvQgwsvyWnGzcki2zToiuHRKrU8+dwM79rwJYJEmRC+Tfg5OGc=
X-Received: by 2002:a0d:d7cb:0:b0:561:9051:d2d3 with SMTP id
 z194-20020a0dd7cb000000b005619051d2d3mr995525ywd.11.1686311939037; Fri, 09
 Jun 2023 04:58:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608140246.15190-1-fw@strlen.de> <20230608140246.15190-4-fw@strlen.de>
 <CAM0EoMkMxOwxNVANaYjd6GBFOkkhkNz=n9xyTnLR6=OmB9nVAw@mail.gmail.com> <20230608182831.GE27126@breakpoint.cc>
In-Reply-To: <20230608182831.GE27126@breakpoint.cc>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Fri, 9 Jun 2023 07:58:47 -0400
Message-ID: <CAM0EoMkvUzSPH26_U_uv80wGsUE2V28COb-7Bi3fjjOYc9W+zA@mail.gmail.com>
Subject: Re: [PATCH net v2 3/3] net/sched: act_ipt: zero skb->cb before
 calling target
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, xiyou.wangcong@gmail.com, 
	jiri@resnulli.us, Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 2:28=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > On Thu, Jun 8, 2023 at 10:03=E2=80=AFAM Florian Westphal <fw@strlen.de>=
 wrote:
> > >
> > > xtables relies on skb being owned by ip stack, i.e. with ipv4
> > > check in place skb->cb is supposed to be IPCB.
> > >
> > > I don't see an immediate problem (REJECT target cannot be used anymor=
e
> > > now that PRE/POSTROUTING hook validation has been fixed), but better =
be
> > > safe than sorry.
> > >
> > > A much better patch would be to either mark act_ipt as
> > > "depends on BROKEN" or remove it altogether. I plan to do this
> > > for -next in the near future.
> >
> > Let me handle this part please.
>
> Sure, no problem.
>
> > > This tc extension is broken in the sense that tc lacks an
> > > equivalent of NF_STOLEN verdict.
> > > With NF_STOLEN, target function takes complete ownership of skb, call=
er
> > > cannot dereference it anymore.
> > >
> > > ACT_STOLEN cannot be used for this: it has a different meaning, calle=
r
> > > is allowed to dereference the skb.
> > >
> >
> > ACT_STOLEN requires that the target clones the packet and the caller
> > to free the skb.
>
> Makes sense, but if NF_STOLEN gets returned the skb is already released,
> so we can't touch it anymore.
>
> > > At this time NF_STOLEN won't be returned by any targets as far as I c=
an
> > > see, but this may change in the future.
> > >
> > > It might be possible to work around this via list of allowed
> > > target extensions known to only return DROP or ACCEPT verdicts, but t=
his
> > > is error prone/fragile.
> >
> > I didnt quiet follow why ACT_STOLEN if this action frees the packet
> > and returns NF_STOLEN
>
> We could emulate NF_STOLEN via ACT_STOLEN, yes, but we'd have to
> skb_clone() unconditionally for every skb before calling the target
> eval function...
>

True.

> Other alternatives I can think of:
>
> - keep a list of "known safe" targets,
> - annotate all accept-or-drop targets as "safe for act_ipt"
> - make the skb shared before calling target function
> - ensure that targets will never ever return NF_STOLEN
>
> I dont really like any of these options :-)
>
> At this time, targets return one of accept/drop/queue.
>
> NF_QEUEUE will log an error and treats it like NF_ACCEPT,
> so we are good at this time.

Since we are shooting to remove this i think it is sufficient.

cheers,
jamal

