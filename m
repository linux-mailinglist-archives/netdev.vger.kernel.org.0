Return-Path: <netdev+bounces-3682-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5452170853A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:44:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EB4C2815A7
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10DB21091;
	Thu, 18 May 2023 15:43:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A2953A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:43:42 +0000 (UTC)
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C74FB9
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:43:38 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1aaf21bb427so16254115ad.1
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684424618; x=1687016618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yF/tsmeio0P26jWMgNFLGXCUc1ACfD0WIWm4hDSeH5c=;
        b=uuIqK7+8OeX/QID61Fjq37axJY9XSejywc6mjTH9kWkQxu7tVp8ZhbJtjWGiozGKSK
         QOzJfWURZI65NzbfYG0PTcF6ntAcHM1/RfWWZUlbHsawbbqhqYYKi5EOyTUe2EqGiY/0
         SveYpmN6KA3gldXfdFDNUuzCQfiJiLCSp8zy0Aq8EVeMN8lInoSMsIyfslpWAUAVB7Xm
         dsrloKK86CdpfM+ZyI0G4FdWcluBdyDcY5ysUl3MUPdTab6vx1pjX80ONrxRLzkWQb0x
         opyMwSnFVcW6hI7fkAyHL/IiMdoEzP9vtd5HSTZ++JkyrmfXocMvo8AKIA/mI86Yi2xz
         chtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684424618; x=1687016618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yF/tsmeio0P26jWMgNFLGXCUc1ACfD0WIWm4hDSeH5c=;
        b=H/ITCa6Hlryhlnmcq8H/Wh/2Wp8AmiAL27yLs6P9jTElgL7I+H+sVG7Q0K4CtGqXQJ
         eykW0TBSJzPHLj7iri0M8URDalVjp6usSXGiSQm2YGQEEVJwxFgPxG1yTWA0KC4od1OA
         GtbGGIIb33zEKtmsAd5XoHJIH8SeMJTamJlMzavdjueN5a4xGa4pJdp9JGHQDRahlZuJ
         xBEv64O2HGJ0KrAjmyym5bjKWHA5CRDT6/+rtheoX59KEWC7c2ogW9Zocx43QmCF+Inl
         u7euSy5CyDbfOyQeEa4W5/EYqzZmDRAVfN3Xq66YKJiWwFsZBwR+GX+kjt6uyLIUOp4U
         aiZA==
X-Gm-Message-State: AC+VfDwmDJoPWDgbrs4yjcggJwv4sl8ZFkigVe0GHxdtvzEoV1XD/iEb
	X/vCuZFwvK4Y0L+qTxqWtJHKJA==
X-Google-Smtp-Source: ACHHUZ5xXAkttkiIhbGOez3mzE5Y8f/UJZaNHCxDAuMDZK7Mo+B65LzF36OQAiw7tD+AnRZVqQ15DA==
X-Received: by 2002:a17:902:e9d5:b0:1ac:50ec:fb2e with SMTP id 21-20020a170902e9d500b001ac50ecfb2emr2673530plk.17.1684424617795;
        Thu, 18 May 2023 08:43:37 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902d3c900b001ae2b94701fsm1620592plb.21.2023.05.18.08.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 08:43:37 -0700 (PDT)
Date: Thu, 18 May 2023 08:43:35 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Kui-Feng Lee <sinquersw@gmail.com>
Cc: David Ahern <dsahern@kernel.org>, Kui-Feng Lee <thinker.li@gmail.com>,
 netdev@vger.kernel.org, ast@kernel.org, martin.lau@linux.dev,
 kernel-team@meta.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, Kui-Feng Lee <kuifeng@meta.com>, Ido
 Schimmel <idosch@idosch.org>
Subject: Re: [RFC PATCH net-next v2 0/2] Mitigate the Issue of Expired
 Routes in Linux IPv6 Routing Tables
Message-ID: <20230518084335.5ed41e3f@hermes.local>
In-Reply-To: <337e31f2-9619-0db5-2782-dea1b0443d97@gmail.com>
References: <20230517183337.190591-1-kuifeng@meta.com>
	<61248e45-c619-d5f2-95a0-5971593fbe8d@kernel.org>
	<337e31f2-9619-0db5-2782-dea1b0443d97@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 17 May 2023 22:40:08 -0700
Kui-Feng Lee <sinquersw@gmail.com> wrote:

> >> Solution
> >> ========
> >>
> >> The cause of the issue is keeping the routing table locked during the
> >> traversal of large tries. To address this, the patchset eliminates
> >> garbage collection that does the tries traversal and introduces
> >> individual timers for each route that eventually expires.  Walking
> >> trials are no longer necessary with the timers. Additionally, the time
> >> required to handle a timer is consistent.  
> > 
> > And then for the number of routes mentioned above what does that mean
> > for having a timer per route? If this is 10's or 100's of 1000s of
> > expired routes what does that mean for the timer subsystem dealing with
> > that number of entries on top of other timers and the impact on the
> > timer softirq? ie., are you just moving the problem around.  
> 
> Yes, each expired route has a timer.  But, not all routes have expire
> times.  The timer subsystem will handle every single one. Let me
> address the timer subsystem later.
> 
> > 
> > did you consider other solutions? e.g., if it is the notifier, then
> > perhaps the entries can be deleted from the fib and then put into a list
> > for cleanup in a worker thread.  
> 
> Yes, I considered to keep a separated list of routes that is expiring,
> just like what neighbor tables do.  However, we need to sort them in the
> order of expire times.  Other solutions can be a RB-tree or priority
> queues. However, later, I went to the timers solution suggested by
> Martin Lau.
> 
> If I read it correctly, the timer subsystem handles each
> timer with a constant time.  It puts timers into buckets and levels.
> Every level means different granularity.  For example, it has
> granularity of 1ms, 8ms (level 0), 64ms, 512ms, ... up to 4 hours
> (level 8) for 1000Hz.  Each level (granularity) has 64 buckets.
> Every bucket represent a time slot. That means level 0 holds
> timers that is expiring in 0ms~63ms in its 64 buckets, level 1 holds
> timers that is expiring in 64ms~511ms, ... so on.  What the timer
> subsystem does is to emit every timers in the corresponding current
> buckets of every level.  In other word, it checks the current bucket
> from level 0 ~ level 8, and emit timers if there is any timer
> in the buckets.
> 
> In contrast, the current GC has to walk every tree even only one route
> expired.  Timers is far better. It emits every timer in the
> buckets associated with current time, no search needed.  The current GC
> is triggered by a timer as well.  So, it should reduce the computation
> of the timer softirq.
> 
> However, just like what I mentioned earlier, the drawback of timers are
> its granularity can vary.  The longer expiration time means more coarse-
> grained.  But, it probably is not a big issue.

If Linux is used on backbone router it can easily have 3 million routes
to deal with. That won't make timer subsystem happy.

