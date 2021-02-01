Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CB930A7C4
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 13:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhBAMjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 07:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhBAMjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 07:39:09 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5488DC061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 04:38:28 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id w1so24053651ejf.11
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 04:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ve2dChZ8TqNH0qXWzDBWt6xi0ojMNyFo5a7iSLJhXxc=;
        b=reBBtpNeCaYwV/CyTb2Ju8Nj97NAvityrQrzk7HD+01RLSeH/bHFkhgwiETK54hLdW
         /9B6IuQQX8nxXPzbHy1549VJt2vCBl84rjSlPwun/nF6obx6SIL8aOoOmN/eqnNqQ0PL
         U56MHX6mua1R99cE97T6oOAP8hmoqWl26zSbPemFJZ/D5UMSJ+UQoucVoCDoftvpk/Ws
         urA7gP0N+rTIgEyJSU28fw8AMYsVljkTWY39JkPdgzpJWQTcJ6/bJNXwBUZm9T0WwVJF
         rPU+CS7dTk0hE5x8E+1K0uJDx27ALNc2T3VGbDf2rR0nNjxASzNlBUzSSDd2aSJM9OmC
         jO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ve2dChZ8TqNH0qXWzDBWt6xi0ojMNyFo5a7iSLJhXxc=;
        b=s22BkqBDcyx7RxVVT0f0pHyEY+2Zpk3Tmb1oOJoSABWr+krrlBIYEo/pQ+mKUHA68d
         JMcb/R7opNkwnZrrNM16gfqWNkfkfbownnI2vCY5LS4EdzjkvAVa0cRkRXJqVIwVIKlW
         3JUkdlAWuhz2EEC22L9tpJdYqMq8VCLRSjpPepXY20R6ZVutHeSw968wsk0D7hqq90Q2
         8qbfOS++71fHB239YMAjupt8HtZkKDStrGZN/aZJ895eRMN3GiCMagxyWdUBGEUCqCq8
         h2zmjmNhQH3aCMxKk55iXS8HafCNRQhYQ4h+5uFS1+me5B4JwDLT/b7WaxTRPXmwludw
         Z6Pg==
X-Gm-Message-State: AOAM530TIcUOIkIPt3XqiiU3E9tqo1lbe6l0Fw6DkzjXRECBhz4aS0LK
        SDJKAR7fmJaFUjpsS1xP7QBRLw==
X-Google-Smtp-Source: ABdhPJwSMeV9zUhgRbfxQLfCvd6lQiFoUw8AZhph/PtxGNTX6ghLNfNMpyQMx9bumXEbay7mpVpWJA==
X-Received: by 2002:a17:906:bfcc:: with SMTP id us12mr17310029ejb.163.1612183107033;
        Mon, 01 Feb 2021 04:38:27 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id i90sm751802edi.52.2021.02.01.04.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 04:38:26 -0800 (PST)
Date:   Mon, 1 Feb 2021 13:38:25 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH RFC net-next] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210201123824.GA26709@netronome.com>
References: <20210125151819.8313-1-simon.horman@netronome.com>
 <20210128161933.GA3285394@shredder.lan>
 <20210201123116.GA25935@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201123116.GA25935@netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 01:31:17PM +0100, Simon Horman wrote:
> On Thu, Jan 28, 2021 at 06:19:33PM +0200, Ido Schimmel wrote:
> > On Mon, Jan 25, 2021 at 04:18:19PM +0100, Simon Horman wrote:
> > > From: Baowen Zheng <baowen.zheng@corigine.com>
> > > 
> > > Allow a policer action to enforce a rate-limit based on packets-per-second,
> > > configurable using a packet-per-second rate and burst parameters. This may
> > > be used in conjunction with existing byte-per-second rate limiting in the
> > > same policer action.
> > 
> > Hi Simon,
> > 
> > Any reason to allow metering based on both packets and bytes at the same
> > action versus adding a mode (packets / bytes) parameter? You can then
> > chain two policers if you need to rate limit based on both. Something
> > like:
> > 
> > # tc filter add dev tap1 ingress pref 1 matchall \
> > 	action police rate 1000Mbit burst 128k conform-exceed drop/pipe \
> > 	action police pkts_rate 3000 pkts_burst 1000
> > 
> > I'm asking because the policers in the Spectrum ASIC are built that way
> > and I also don't remember seeing such a mixed mode online.
> 
> Hi Ido,
> 
> sorry for missing this email until you pointed it out to me in another
> thread.
> 
> We did consider this question during development and our conclusion was
> that it was useful as we do have use-cases which call for both to be used
> and it seems nice to allow lower layers to determine the order in which the
> actions are applied to satisfied the user's more general request for both -
> it should be no surprise that we plan to provide a hardware offload of this
> feature. It also seems to offer nice code re-use. We did also try to
> examine the performance impact of this change on existing use-cases and it
> appeared to be negligible/within noise of our measurements.
> 
> > > e.g.
> > > tc filter add dev tap1 parent ffff: u32 match \
> > >               u32 0 0 police pkts_rate 3000 pkts_burst 1000
> > > 
> > > Testing was unable to uncover a performance impact of this change on
> > > existing features.
> > > 
> > > Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> > > Signed-off-by: Simon Horman <simon.horman@netronome.com>
> > > Signed-off-by: Louis Peens <louis.peens@netronome.com>
> > > ---
> > >  include/net/sch_generic.h      | 15 ++++++++++++++
> > >  include/net/tc_act/tc_police.h |  4 ++++
> > >  include/uapi/linux/pkt_cls.h   |  2 ++
> > >  net/sched/act_police.c         | 37 +++++++++++++++++++++++++++++++---
> > >  net/sched/sch_generic.c        | 32 +++++++++++++++++++++++++++++
> > >  5 files changed, 87 insertions(+), 3 deletions(-)
> > 
> > The intermediate representation in include/net/flow_offload.h needs to
> > carry the new configuration so that drivers will be able to veto
> > unsupported configuration.

Thanks for pointing that out. I do have a patch for that but was planning
to post it as a follow-up to keep this series simple. I do see your point
that the flow_offload.h change is a dependency of this patch. I'll include
it when reposting.
