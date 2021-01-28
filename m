Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4DE307590
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhA1MIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhA1MIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:08:49 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036C1C061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 04:08:07 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id l9so7400626ejx.3
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 04:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IcjWNKokMVM82f/d0eFOBaSq2UMGIWZxpn3K1pNlYB0=;
        b=T9Io02Q+PEmF1T2SnLXkLTX49GZDaXmZKTCBaJzEdIRvjjd18NoVPUg2HinEPWtQvI
         igtbzXpX8h6LneBGwMbMfkqFKnFGQDIZ9xyLYqr+rrF6Ul36iTIUHpROr8knJoSNrhe/
         s3m/WtyfnSFFPyVCBK+xPwOgBafAXP2wU57nrVSjydSLR+qFlfp8IHHY7IL3D6SD6gab
         A1qZ97fImqujqv1QFcBmOnqipCjPrGehD84cIMeRLWvrHJUK5teJpX6rcKE5ZLBWPgu3
         avYv43Lcv8H7UCpvWAN3O8CzFq3qpED8WeDQkNODyYXG9X8CtHJCfE4hXfv6se1D9Kta
         gUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IcjWNKokMVM82f/d0eFOBaSq2UMGIWZxpn3K1pNlYB0=;
        b=LRkMmTD8Ne3dd4ea/SEwJUm1QnGe40RDN/5z00WSRDqZmr4HnoTqo2i7n+JnAkhgVO
         uct4pKuGIl6sBKDsZlf0Y491iWMqBBKS24CBGZKtbqxdWfgrRWdIoKq24+RrCYj0Icgg
         gOfdDAN5B5Ca4cWQRm37tL7X2ek9MRv9qFDsGFcvq0lBiC3oknZSXH572JeLifAv5uhr
         SQIwhvJuUp/3m7c1fjDXR4ZchBbTpvnG331nLNp6Kjvy9FRZSRczN8fmtloxSSKAoUd0
         hf8gfcuF7QxBf6oGnl61pzucn9YSc6HkkG/EbVn9H8hqS0aeOpzUAvLwjMNwuTeQyePL
         qneA==
X-Gm-Message-State: AOAM532c99ZasiaHFh+/hBal6qTOgFZyTabrNDiksz+mnZSz/sI3R+8F
        ZOn69NGtjOceM+c+MNRI9j66uQ==
X-Google-Smtp-Source: ABdhPJyQ3qipgtlTgYY7aZYpeTiSQdqYMfmak7i28I4vBE0sC2cMZa0mbtCe9u+S4Au2TjmCJ+L9aQ==
X-Received: by 2002:a17:906:4893:: with SMTP id v19mr10630634ejq.454.1611835685657;
        Thu, 28 Jan 2021 04:08:05 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id g10sm2183432ejp.37.2021.01.28.04.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 04:08:04 -0800 (PST)
Date:   Thu, 28 Jan 2021 13:08:04 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH RFC net-next] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210128120803.GB8059@netronome.com>
References: <20210125151819.8313-1-simon.horman@netronome.com>
 <20210126183812.180d0d61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210127110222.GA29081@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127110222.GA29081@netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 12:02:23PM +0100, Simon Horman wrote:
> Hi Jakub,
> 
> On Tue, Jan 26, 2021 at 06:38:12PM -0800, Jakub Kicinski wrote:
> > On Mon, 25 Jan 2021 16:18:19 +0100 Simon Horman wrote:
> > > From: Baowen Zheng <baowen.zheng@corigine.com>
> > > 
> > > Allow a policer action to enforce a rate-limit based on packets-per-second,
> > > configurable using a packet-per-second rate and burst parameters. This may
> > > be used in conjunction with existing byte-per-second rate limiting in the
> > > same policer action.
> > > 
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
> > 
> > > diff --git a/net/sched/act_police.c b/net/sched/act_police.c
> > > index 8d8452b1cdd4..d700b2105535 100644
> > > --- a/net/sched/act_police.c
> > > +++ b/net/sched/act_police.c
> > > @@ -42,6 +42,8 @@ static const struct nla_policy police_policy[TCA_POLICE_MAX + 1] = {
> > >  	[TCA_POLICE_RESULT]	= { .type = NLA_U32 },
> > >  	[TCA_POLICE_RATE64]     = { .type = NLA_U64 },
> > >  	[TCA_POLICE_PEAKRATE64] = { .type = NLA_U64 },
> > > +	[TCA_POLICE_PKTRATE64]  = { .type = NLA_U64 },
> > > +	[TCA_POLICE_PKTBURST64] = { .type = NLA_U64 },
> > 
> > Should we set the policy so that .min = 1?
> 
> Yes, I think so.
> Thanks for spotting that.

It seems that I was mistaken.

A value of 0 is used to clear packet-per-second rate limiting
while leaving bit-per-second rate configuration in place for a
policer action.

So I think the policy should be left as is...

> > >  };
> > >  
> > >  static int tcf_police_init(struct net *net, struct nlattr *nla,
> > > @@ -61,6 +63,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
> > >  	bool exists = false;
> > >  	u32 index;
> > >  	u64 rate64, prate64;
> > > +	u64 pps, ppsburst;
> > >  
> > >  	if (nla == NULL)
> > >  		return -EINVAL;
> > > @@ -183,6 +186,16 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
> > >  	if (tb[TCA_POLICE_AVRATE])
> > >  		new->tcfp_ewma_rate = nla_get_u32(tb[TCA_POLICE_AVRATE]);
> > >  
> > > +	if (tb[TCA_POLICE_PKTRATE64] && tb[TCA_POLICE_PKTBURST64]) {
> > 
> > Should we reject if only one is present?
> 
> Again, yes I think so.
> I'll confirm this with the author too.

... but add this restriction so the code will require either:

1. Both PKTRATE64 and PKTBURST64 are non-zero: packet-per-second limit is set;
   or
2. Both PKTRATE64 and PKTBURST64 are zero: packet-per-second limit is cleared

...
