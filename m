Return-Path: <netdev+bounces-8684-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E276B7252CF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E72D2810CE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 04:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1E481F;
	Wed,  7 Jun 2023 04:25:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30D77C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:25:52 +0000 (UTC)
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5354F2129
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 21:25:50 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-75ca95c4272so608352985a.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 21:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686111949; x=1688703949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3lD7kDuhNLnl7wZBlFAg8XydFMtRy3xTipVxb3Q4+0c=;
        b=niPlnkME9RoIVx63PrvWd85cNUuwfSSwknPy9SFsL9nhTbna7mPj4HrnlWV7nC6CVw
         9KM2wHUeqIzuWvN4VzB4/0brkTzBlmscLbOHk4aoZQXZjVN+K/STCQvhFHU2rJDlMcWF
         WXYPgY0lwJze0Xn1Oq7JxlmM0dY5jOJ9gs98Vy8HLLQYFncXTTIO/hKGwWO9m1huBLSA
         z+6BUA0hdKNdS6HDyJHZdVWCNPEf/Gr8f5VGJcwWE2V4ixSTmE15hFW9GETAj1IokXhT
         iChjWKIBsE9edQLwPzLu2U0cMfgO2iGBY4B7c9LDbCTdzCjV25kLmVVCYPpa6s61aACR
         q0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686111949; x=1688703949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3lD7kDuhNLnl7wZBlFAg8XydFMtRy3xTipVxb3Q4+0c=;
        b=jVkzMFzBUtC+Zg6/aZvO4UXi7iIVeFbGTMyle6Ric3koCY77WD6Zrx+e22IJi25U6M
         +utFGwLKyFC9QGGUv2ik87R5s8yH1dKNxiyKgOovMeNgPQBMn3KpnayyDrFdJ5XXK8rV
         SJ0gBmTIC1lC9J+8kVrq3PuLk9g5faw/xKk4p0viSACg/aMg7SKT5UqE1x+mdE0PWxTK
         WLnZZuEpsGL2/3nRlT/scDw7xZEU85Jk5gaZH2JzQi45zh+hyCzbKwekVRGVB7HL5NFw
         pN5d+SWmQ3S+d1cgUmWhPN1CzQctzk9BrQGhcpay1hNWzzgriovgs1zbVFG1YdNa112T
         vmww==
X-Gm-Message-State: AC+VfDzxTYltGNSntcCsvrgIxE4DoOAzZExGaF/wechObE7Gv3KOES7a
	o0LBFffqhDLWCxPkXwUBMg==
X-Google-Smtp-Source: ACHHUZ4JfcgLiy3E6u3TiOur9zXvy439WyZaT87WJkU6oumJNgzi47PMlCA6KdukAAT7rXBFqcDXhw==
X-Received: by 2002:a05:620a:2993:b0:75e:b9dc:ec2 with SMTP id r19-20020a05620a299300b0075eb9dc0ec2mr1004758qkp.5.1686111949312;
        Tue, 06 Jun 2023 21:25:49 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:c473:cfa6:fc78:2500])
        by smtp.gmail.com with ESMTPSA id r28-20020a05620a03dc00b0075785052e97sm5390766qkm.95.2023.06.06.21.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 21:25:49 -0700 (PDT)
Date: Tue, 6 Jun 2023 21:25:42 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: Vlad Buslov <vladbu@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <ZIAGxoRQIrLqZbc0@C02FL77VMD6R.googleapis.com>
References: <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com>
 <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com>
 <87bki2xb3d.fsf@nvidia.com>
 <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com>
 <30a35b1f-9f66-f7c7-61c6-048c1b68efce@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30a35b1f-9f66-f7c7-61c6-048c1b68efce@mojatatu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Pedro,

On Thu, Jun 01, 2023 at 10:03:22AM -0300, Pedro Tammela wrote:
> On 01/06/2023 00:57, Peilin Ye wrote:
> > -                       /* Replay if the current ingress (or clsact) Qdisc has ongoing
> > -                        * RTNL-unlocked filter request(s).  This is the counterpart of that
> > -                        * qdisc_refcount_inc_nz() call in __tcf_qdisc_find().
> > +                       /* If current ingress (clsact) Qdisc has ongoing filter requests, stop
> > +                        * accepting any more by marking it as "being destroyed", then tell the
> > +                        * caller to replay by returning -EAGAIN.
> >                           */
> > -                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_sleeping))
> > +                       q = dev_queue->qdisc_sleeping;
> > +                       if (!qdisc_refcount_dec_if_one(q)) {
> > +                               q->flags |= TCQ_F_DESTROYING;
> > +                               rtnl_unlock();
> > +                               schedule();
>
> Was this intended or just a leftover?
> rtnl_lock() would reschedule if needed as it's a mutex_lock

In qdisc_create():

			rtnl_unlock();
			request_module("sch_%s", name);
			rtnl_lock();
			ops = qdisc_lookup_ops(kind);
			if (ops != NULL) {
				/* We will try again qdisc_lookup_ops,
				 * so don't keep a reference.
				 */
				module_put(ops->owner);
				err = -EAGAIN;
				goto err_out;

If qdisc_lookup_ops() returns !NULL, it means we've successfully loaded the
module, so we know that the next replay should (normally) succeed.

However in the diff I posted, if qdisc_refcount_dec_if_one() returned
false, we know that we should step back and wait a bit - especially when
there're ongoing RTNL-locked filter requests: we want them to grab the RTNL
mutex before us, which was my intention here, to unconditionally give up
the CPU.  I haven't tested if it really makes a difference though.

Thanks,
Peilin Ye


