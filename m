Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6AC30A7B1
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 13:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhBAMei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 07:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhBAMeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 07:34:37 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0F4C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 04:33:56 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id y9so2496813ejp.10
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 04:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UR/JqJVNL4Zu1Q9N3kEgHVHsgXqXOCVH79DCe3V8mjs=;
        b=wjaHmw3HYaQJf67w4GKs1966Q+iQHMCFWta+T4QBYZlaA9Jy7WWPH2bSjOiQ6dTNjN
         MsG1hKmPiSQjOnlpGCtk/YyseBvwLtyqpBl/hfrh/gfoJjc3P0AzUCgsmGLYdvlReSjy
         T1kJj3nfWSfgPx/70cCugSXpZLTrZgAGvWtxNbExx5jbGiRt1nfKgsABDUntSWHvwxzj
         QQFyOS0731VMxiEJaq+ar4pb4oABP2ETTRNbz91lgWlPxwqQnKTd+jyypel+H6OtwBvn
         Hu9vXn68P9ICKeaVFqDdkoUy89MmO3J4MwBlWlm1mwyzKIFHhMH48InfVlxZueOh8rBG
         qAHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UR/JqJVNL4Zu1Q9N3kEgHVHsgXqXOCVH79DCe3V8mjs=;
        b=jszHGqn23hIDgowGQOHxtnQCrNZv7EGHcChHALr4x2IFuiuRciGK/sYr4RAa1XaYlk
         rUIjoxSQDNBgNmJsIICauIm6i0sMfkvqqP/GV0L4wom54UJZdj9yudrr6cy4SY1AkWSj
         4kBkwDoiCVzq8DxPm7Pr7G0VBolPpMTH0OU22UMBo6/CISdxei+Lu65lK8RALgt/peUx
         NGvG1gL7UPOex+zMEaYzk2laNVwwif/cVFuHzrNgoe9JB8YOG6T0NM92buJjgXj1Ya0y
         BllpdUZuTgJvbCFZVE4kXQ8EiADAs1zJURu1bxbXf5QgjaLQB7sv5Od8FYaVm08t/htN
         h2Pw==
X-Gm-Message-State: AOAM532mUShqoTIrrE38Q2QfOvhHAHrwqBlq/2pZQdTZCXZ5B0KdnSGR
        AIbEZzW9ld6PCG4nYAwIKxwPeQ==
X-Google-Smtp-Source: ABdhPJxNpHNXnX0txoFy3Ck+A6zlSuxHhvj1p4QguTx16gQAoqxCgIZz6o7RcyjJ1ExWb8ih8Y+1Rg==
X-Received: by 2002:a17:906:c34d:: with SMTP id ci13mr1080453ejb.333.1612182834925;
        Mon, 01 Feb 2021 04:33:54 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id i1sm8610435edv.8.2021.02.01.04.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 04:33:54 -0800 (PST)
Date:   Mon, 1 Feb 2021 13:33:53 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [PATCH net-next v2] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210201123352.GB25935@netronome.com>
References: <20210129102856.6225-1-simon.horman@netronome.com>
 <0c47b7d7-dc2b-3422-62ff-92fea8300036@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c47b7d7-dc2b-3422-62ff-92fea8300036@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 09:30:00AM -0500, Jamal Hadi Salim wrote:
> On 2021-01-29 5:28 a.m., Simon Horman wrote:
> > From: Baowen Zheng <baowen.zheng@corigine.com>
> > 
> > Allow a policer action to enforce a rate-limit based on packets-per-second,
> > configurable using a packet-per-second rate and burst parameters. This may
> > be used in conjunction with existing byte-per-second rate limiting in the
> > same policer action.
> > 
> > e.g.
> > tc filter add dev tap1 parent ffff: u32 match \
> >                u32 0 0 police pkts_rate 3000 pkts_burst 1000
> > 
> > Testing was unable to uncover a performance impact of this change on
> > existing features.
> > 
> 
> Ido's comment is important: Why not make packet rate vs byte rate
> mutually exclusive? If someone uses packet rate then you make sure
> they dont interleave with attributes for byte rate and vice-versa.
> 
> I dont see featurewise impact - but certainly the extra check
> in the fastpath will likely have a small performance impact
> at high rates. Probably not a big deal (if Eric D. is not looking).
> Side note: this policer (with your addition) is now supporting 3 policer
> algorithms - i wonder if it makes sense to start spliting the different
> policers (which will solve the performance impact).

Sorry, I somehow missed Ido's email until you and he pointed it out
in this thread.

Regarding splitting up the policer action. I think there is some value to
the current setup in terms of code re-use and allowing combinations of
features. But I do agree it would be a conversation worth having at some
point.
