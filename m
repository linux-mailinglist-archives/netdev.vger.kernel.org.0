Return-Path: <netdev+bounces-9103-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E227D7273F7
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 03:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D787281546
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 01:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285C1A32;
	Thu,  8 Jun 2023 01:08:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157017F6
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 01:08:26 +0000 (UTC)
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A797D26A5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 18:08:25 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-6259c242c96so788956d6.3
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 18:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686186505; x=1688778505;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TbnQXRxFRLikv1N97Lo3PC1BT3/mdVul44dDk0qitfQ=;
        b=Be9gsFbD5IAI6Gp/rjMsIJUHSAMBr/ilBsNGOj9Q1aMsr9w6lvnrJ+sFvqtfcZSG51
         BE+0V75x43LNH5HM/0wu2VjfyPG2Qzh3Dohj66ytnUk9FxW2aXk6gc1MpsQuDzKDh32Q
         CeXgXNe0e2TOaD54rQ/lC8ClPdaLaicgYl7dZs/zZ/s8vlqskUWt+6Vm3wOTr2jQOWqb
         IFxYFwiZZq2fPDJbbMLTIYHth+95E8eeW1Uk/5RtCiI/c17+UG562aYbydcsE5pmO+0y
         Au1Z59eB4x6Q5MwLRvSlT+xVzWo2pbV8lTs6ThfxmIdbco8GuThzLMwsjsEWv8A7IBdx
         /EIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686186505; x=1688778505;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbnQXRxFRLikv1N97Lo3PC1BT3/mdVul44dDk0qitfQ=;
        b=AbKeYxaMqltNQt/yGI0TkughSCHZJkVik40rjlds0Cy3wue93OZk/q39hlcA6+oDtm
         7qIA0DAwj3T7pG+tm5ZPtHhtjv+ihvgWBpfNhhPUYT8PJuWU16YmbmYpn3IK3IY7nLSy
         N+KtMybKd/1IRfeMyBYwlaPKqYpIeaDdOk7XWyBPdiosxRYyRCwHbhaZRbGOTlZdRBZS
         aQ3MZvZBhPVXlwlMw8fd0BcDw/JX+zX+14gKUjv+g82Yqk5adpflLa9rSi7Am4ZeiGgu
         rGxqNT648v941q0s5WwHJtHKdnCHf/SuXmE1TDsBG8dUavj8wltG+NN/3r57rpLIx1U2
         /2NQ==
X-Gm-Message-State: AC+VfDw7HWHmbpkgOc1/qigUtJlqrKMjmbk7fEQ7Mr59l3SSn+c06PNl
	StLdQIo1AKlM35Fx+Gn5Ng==
X-Google-Smtp-Source: ACHHUZ5Ws2LnMaF38IgPHywBkfL00Qr0Ge+Lz9fuzmvocj0cAXImvzEVYonDZqdnTvfWOL3DHQWkIQ==
X-Received: by 2002:a05:6214:2b06:b0:623:9126:8d7b with SMTP id jx6-20020a0562142b0600b0062391268d7bmr61911qvb.28.1686186504742;
        Wed, 07 Jun 2023 18:08:24 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:7cbc:7b16:951c:eeaa])
        by smtp.gmail.com with ESMTPSA id h9-20020a0cf209000000b00626a0ea44fbsm50926qvk.23.2023.06.07.18.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 18:08:24 -0700 (PDT)
Date: Wed, 7 Jun 2023 18:08:18 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Jakub Kicinski <kuba@kernel.org>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZIEqAosXPn8hB1hK@C02FL77VMD6R.googleapis.com>
References: <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com>
 <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com>
 <87bki2xb3d.fsf@nvidia.com>
 <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com>
 <877csny9rd.fsf@nvidia.com>
 <ZH/V5gf+YjKuC0bn@C02FL77VMD6R.googleapis.com>
 <87y1kvwu5c.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y1kvwu5c.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 11:18:32AM +0300, Vlad Buslov wrote:
> > I also thought about adding the new DELETED-REJECT-NEW-FILTERS flag to
> > ::state2, but not sure if it's okay to extend it for our purpose.
>
> As you described above qdisc->flags is already used to interact with cls
> api (including changing it dynamically), so I don't see why not.

Sorry, I don't follow, I meant qdisc->state2:

  enum qdisc_state2_t {
          /* Only for !TCQ_F_NOLOCK qdisc. Never access it directly.
           * Use qdisc_run_begin/end() or qdisc_is_running() instead.
           */
          __QDISC_STATE2_RUNNING,
  };

NVM, I think using qdisc->flags after making it atomic sounds better.

On Wed, Jun 07, 2023 at 11:18:32AM +0300, Vlad Buslov wrote:
> > 	err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
> > 			      flags, extack);
> > 	if (err == 0) {
> > 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
> > 			       RTM_NEWTFILTER, false, rtnl_held, extack);
> > 		tfilter_put(tp, fh);
> > 		/* q pointer is NULL for shared blocks */
> > 		if (q)
> > 			q->flags &= ~TCQ_F_CAN_BYPASS;
> > 	}               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> > TCQ_F_CAN_BYPASS is cleared after e.g. adding a filter to the Qdisc, and it
> > isn't atomic [1].
> 
> Yeah, I see we have already got such behavior in 3f05e6886a59
> ("net_sched: unset TCQ_F_CAN_BYPASS when adding filters").
> 
> > We also have this:
> >
> >   ->dequeue()
> >     htb_dequeue()
> >       htb_dequeue_tree()
> >         qdisc_warn_nonwc():
> >
> >   void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc)
> >   {
> >           if (!(qdisc->flags & TCQ_F_WARN_NONWC)) {
> >                   pr_warn("%s: %s qdisc %X: is non-work-conserving?\n",
> >                           txt, qdisc->ops->id, qdisc->handle >> 16);
> >                   qdisc->flags |= TCQ_F_WARN_NONWC;
> >           }       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >   }
> >   EXPORT_SYMBOL(qdisc_warn_nonwc);
> >
> > Also non-atomic; isn't it possible for the above 2 underlined statements to
> > race with each other?  If true, I think we need to change Qdisc::flags to
> > use atomic bitops, just like what we're doing for Qdisc::state and
> > ::state2.  It feels like a separate TODO, however.
> 
> It looks like even though 3f05e6886a59 ("net_sched: unset
> TCQ_F_CAN_BYPASS when adding filters") was introduced after cls api
> unlock by now we have these in exactly the same list of supported
> kernels (5.4 LTS and newer). Considering this, the conversion to the
> atomic bitops can be done as a standalone fix for cited commit and after
> it will have been accepted and backported the qdisc fix can just assume
> that qdisc->flags is an atomic bitops field in all target kernels and
> use it as-is. WDYT?

Sounds great, how about:

  1. I'll post the non-replay version of the fix (after updating the commit
     message), and we apply that first, as suggested by Jamal

  2. Make qdisc->flags atomic

  3. Make the fix better by replaying and using the (now atomic)
     IS-DESTROYING flag with test_and_set_bit() and friends

?

Thanks,
Peilin Ye


