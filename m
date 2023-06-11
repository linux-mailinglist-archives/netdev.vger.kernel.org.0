Return-Path: <netdev+bounces-9868-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 868AA72B01C
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 05:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BA1A1C20AA1
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 03:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 526F115B4;
	Sun, 11 Jun 2023 03:25:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BDE10F5
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 03:25:13 +0000 (UTC)
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADE619BB
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 20:25:12 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-62614f2eee1so21720346d6.0
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 20:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686453911; x=1689045911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JzW14MsNNnJ33Yzz+9Qc4U/HGnNQ+KcpVvUhu1sGNek=;
        b=IMo2xYsQSDHsczjoboG5rqRq68vfun3wru4juRd1A6M3Fd/TliNnp1WxeXhBI0jNh0
         qoQ84urBuCdWqaHeUcio4KP1MDZSTuC1gma4goPXa92TBb/RA5hXgzLQP72hI4aGYslT
         fwbBzsPFq15QW6U0eKcpLEuctzkL2hKD+EViF9enZS9TsHcWUDfXaqmSJHNOZtgxT9dw
         Ocq26rAHXyQV9KKjy0CiCuG55I7ex1bLE3ADtLO6B+KPy9cJ5OiOXAqGfPsr3/yvjCuA
         +QUxYH3A2qKLQhn8q4bWQbe4ugZOjEHt1oClgr9WPP4g3em/Eulxb+1DJAZOydUJxvl0
         QcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686453911; x=1689045911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzW14MsNNnJ33Yzz+9Qc4U/HGnNQ+KcpVvUhu1sGNek=;
        b=AGI2vKC5JwcG8VR228SqGJy/oph5YZabLY6wqcIDAOKJ+z0tytJQ6t1yUwp1XESb+d
         O7ten45Y8MtZuPj/QNzpy+JvuOW/gm/t1DWS1B5hLJ6EoQd+QSyOLTxbGUFfOppJmpTe
         AovXpGE7rY9ogFKMLPeW9AQi9xOi2Y6LCYfFHJn518RuLtkaqfS7lEvEcfWS+NZ+aTiA
         jrORDpkhEHvsG5bk59L19W1wtPtYvJ6Ld0zbtB95AJgCfgA/My3sIu6FOiqLHj4J5c72
         D8STGFRnx0toi3RBVqyHC1hJLZeYoUal7qEVZNC2KBOqiVS1UQ46klrUPcwh9VYMlFsb
         aWkQ==
X-Gm-Message-State: AC+VfDwQ8A5RFPYAngteOpHJ2c36SJc3URGWwjK48NudUOK02/y3ZjBD
	rDoSSf5OzP1slvKZ3fzPYg==
X-Google-Smtp-Source: ACHHUZ54+nyB1ssfN6vSh/2UwvbLcD6GAn+6dG7cCm/ePG4XvD96Ig2XD+Qd41c/YdDj89tZBZDqtw==
X-Received: by 2002:ad4:5d67:0:b0:61b:5cba:5820 with SMTP id fn7-20020ad45d67000000b0061b5cba5820mr6397549qvb.50.1686453911572;
        Sat, 10 Jun 2023 20:25:11 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:65a5:6400:a53e:60df:7509:de6])
        by smtp.gmail.com with ESMTPSA id y18-20020ad457d2000000b00628479e69e8sm2239424qvx.5.2023.06.10.20.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 20:25:11 -0700 (PDT)
Date: Sat, 10 Jun 2023 20:25:06 -0700
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
Message-ID: <ZIU+krXpJ34WpiwU@C02FL77VMD6R.googleapis.com>
References: <87jzwrxrz8.fsf@nvidia.com>
 <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com>
 <87bki2xb3d.fsf@nvidia.com>
 <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com>
 <877csny9rd.fsf@nvidia.com>
 <ZH/V5gf+YjKuC0bn@C02FL77VMD6R.googleapis.com>
 <87y1kvwu5c.fsf@nvidia.com>
 <ZIEqAosXPn8hB1hK@C02FL77VMD6R.googleapis.com>
 <87ttviwfoy.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttviwfoy.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 10:48:12AM +0300, Vlad Buslov wrote:
> >> It looks like even though 3f05e6886a59 ("net_sched: unset
> >> TCQ_F_CAN_BYPASS when adding filters") was introduced after cls api
> >> unlock by now we have these in exactly the same list of supported
> >> kernels (5.4 LTS and newer). Considering this, the conversion to the
> >> atomic bitops can be done as a standalone fix for cited commit and after
> >> it will have been accepted and backported the qdisc fix can just assume
> >> that qdisc->flags is an atomic bitops field in all target kernels and
> >> use it as-is. WDYT?
> >
> > Sounds great, how about:
> >
> >   1. I'll post the non-replay version of the fix (after updating the commit
> >      message), and we apply that first, as suggested by Jamal
>
> From my side there are no objections to any of the proposed approaches
> since we have never had any users with legitimate use-case where they
> need to replace/delete a qdisc concurrently with a filter update, so
> returning -EBUSY (or -EAGAIN) to the user in such case would work as
> either temporary or the final fix.

I see, yeah.

> However, Jakub had reservations with such approach so don't know where we
> stand now regarding this.

Either way I'd say applying that non-replay version first is better than
leaving the bug unfixed.  It's been many days since the root cause of the
issue has been figured out.  I'll post it, and start making qdisc->flags
atomic.

> >   2. Make qdisc->flags atomic
> >
> >   3. Make the fix better by replaying and using the (now atomic)
> >      IS-DESTROYING flag with test_and_set_bit() and friends
> >
> > ?
>
> Again, no objections from my side. Ping me if you need help with any of
> these.

Sure, thanks, Vlad!
Peilin Ye


