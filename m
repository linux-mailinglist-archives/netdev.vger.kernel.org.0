Return-Path: <netdev+bounces-9748-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D144872A6FB
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 02:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9D9E1C211AD
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 00:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5E57EA;
	Sat, 10 Jun 2023 00:20:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BB5399
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 00:20:18 +0000 (UTC)
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917D33A84
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:20:17 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-39a3f2668d5so1046852b6e.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 17:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686356417; x=1688948417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fjm670gyhplsgMeSGiE7dlgKOtvxQhYw64Nv4fo2uO0=;
        b=ln161OUxeF3zvNJQMvSQ2uiKqFWk1MgWE47FPYEVNS3e+gq1cHmw97UHm6CaeCtFMq
         m+SZ67+XThci2vaHQ3UTFzaYXBtFMdm6jX/nhdfKsAvTPLxb5QM/XNerEjsE5abthfk4
         0u5wQsp/jZfDCyrQf31sm4OQ6OnjzrUe2+F4Cd5Xz3yE8LVcKl35YDxlw3KA9chrSIdd
         jxOT7Gq+T8luL8FzgXIzUWIU8PO3b9Oz5gw6h1kiOe0FxoqgJV5z07NY7tOfK0Ldni3N
         hhZLZD7dFUO87E4lsR+SvHf3lSP0SwuJS7Wdjtgc68UkD9NYGk7m+iFFzdY/CO0Qu+my
         Il/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686356417; x=1688948417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjm670gyhplsgMeSGiE7dlgKOtvxQhYw64Nv4fo2uO0=;
        b=VlZ712iEwlpeqtWGvy4dxa7BdGFz47c6hdTC4Pgc6fKjCJDm87deR6m/iHoe1UijF/
         l65EqN1CTXkc5M9G6YLHr6//sYfUw/IMqqLsg5/dddlSLElDtd/tE3bR0LsqKgKqhI0H
         ycCYShYmWoS7dBMmBmwRNZDKiijPnYV9OLKtETKL9pTb+f5BVvtKTHmu2i2/oAgflqR/
         n9PEjCJUN7E0oeZGXh+ko5CLyMw1UzRAqijX2o4fDDZyQCh6RC0Q4G+IzkViRh7MiYhs
         pKawmDX5QzjyJDup5nPCjmbpnAzzyqzyr6u6Xsv1dtHDu1sqZLIs5pTNXBop+bnZ9tzG
         h+xg==
X-Gm-Message-State: AC+VfDywso8oxxuQBiX+F7p1TDmGEU1DIhyQLtcAiATLpgGtnDri74mp
	mX41tLNWPbob9sXSZVo8Fg==
X-Google-Smtp-Source: ACHHUZ7Zzx+qErpFgFSjvvtNahn60bB3nd3R0MvRqnynklxm99R2FriPlRpHnN1akTWCjG/nopxJAw==
X-Received: by 2002:a05:6808:1155:b0:39c:94f0:1dd2 with SMTP id u21-20020a056808115500b0039c94f01dd2mr255264oiu.45.1686356416759;
        Fri, 09 Jun 2023 17:20:16 -0700 (PDT)
Received: from C02FL77VMD6R ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id e10-20020acab50a000000b003942036439dsm1957137oif.46.2023.06.09.17.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 17:20:15 -0700 (PDT)
Date: Fri, 9 Jun 2023 17:20:10 -0700
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
Message-ID: <ZIPButmlxq13LGV8@C02FL77VMD6R>
References: <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com>
 <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com>
 <87bki2xb3d.fsf@nvidia.com>
 <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com>
 <877csny9rd.fsf@nvidia.com>
 <ZIEjUobtdPCu648e@C02FL77VMD6R.googleapis.com>
 <87pm66wbgo.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pm66wbgo.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 12:17:27PM +0300, Vlad Buslov wrote:
> > When I didn't specify "prio", sometimes that
> > rhashtable_lookup_insert_fast() call in fl_ht_insert_unique() returns
> > -EEXIST.  Is it because that concurrent add-filter requests auto-allocated
> > the same "prio" number, so they collided with each other?  Do you think
> > this is related to why it's slow?
> 
> It is slow because when creating a filter without providing priority you
> are basically measuring the latency of creating a whole flower
> classifier instance (multiple memory allocation, initialization of all
> kinds of idrs, hash tables and locks, updating tp list in chain, etc.),
> not just a single filter, so significantly higher latency is expected.

Ah, I see.  Thanks for the explanation.

Thanks,
Peilin Ye


