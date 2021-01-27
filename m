Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A1830592D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 12:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhA0LFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 06:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbhA0LDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 06:03:06 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B86C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 03:02:25 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id gx5so2025642ejb.7
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 03:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mHR66ldFVwUCP2wsSMCfJ0XtjIkTSquFug283vsdazc=;
        b=qCJRFOZMjKT9YEPD6FWnge3cOhB8oUv0xlpvASOtlDdogk/3p4bvPaTsvn8t++A7+t
         Qybzzwx07jKwt39Tj4f+MyfM+k40/CTyh15J0plITUW3VnfGBthX/5ylmG3qp38ZPOKa
         DhVtu8qyQS5ZIHLlIxkGEAsTHedEUq7+BAi9zLAV0yWCflj8QGL+AjHeyCTlSRbtdocC
         62LlXB6tLLg/0KBxwGzETJRXPsmM0Ed+3B/04gKVgZCTyvV1e/+vC9/MNiy2mtEuQIz5
         beAfzP8QreZ618H/9vHNuKuf90pBwOT1B+/WzVgsW30opIgt9ohtQ0WNSRYXA+6/yTrN
         THdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mHR66ldFVwUCP2wsSMCfJ0XtjIkTSquFug283vsdazc=;
        b=a+b8DRPbgrO5LzNDh+wIvUG9xIsHc3+P/D7h/WqowRrAvP20Zr5I6+CwbkLuC1lGOz
         0y1oiJsQfsQLNZlZ7kOGkip9919TynZU6pH4JnWFRYCtKrcjqBdbu0HoicxWTSyzkxfb
         PrPpr88QsaUdMFeFRS1WXrSoxWUjNApQtXez83/kWPYsgNiFNO50jvr6xqS7QDH9bwD6
         GLLQOfXxrkGmpeBvhtXL5l1C9z+NIv9gclppUg365sOc3DeADewtKv9FybUqwPzq6XKR
         mCmrbd6bD7R96fgWDvaJWZLsw4VUUD7XnnzPepCFruvfTWivNzuDN4JjmiDZyPqkCU47
         WbFw==
X-Gm-Message-State: AOAM5326kBEb6p9o/5seNBumbsBzm6AEOXfSddX5+WpkBqUxFbipOicd
        h9nvC3S36YkIRvOLaaaTSR+5ww==
X-Google-Smtp-Source: ABdhPJw8wjCk79GlRsRQUjL8JKiczDh4NYey0/YRXzyhHyPu3z6Rt/aFWr+F1v28M+HwObra0hhJbA==
X-Received: by 2002:a17:906:7c43:: with SMTP id g3mr6346936ejp.210.1611745344535;
        Wed, 27 Jan 2021 03:02:24 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id g90sm1121777edd.30.2021.01.27.03.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 03:02:23 -0800 (PST)
Date:   Wed, 27 Jan 2021 12:02:23 +0100
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
Message-ID: <20210127110222.GA29081@netronome.com>
References: <20210125151819.8313-1-simon.horman@netronome.com>
 <20210126183812.180d0d61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126183812.180d0d61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Jan 26, 2021 at 06:38:12PM -0800, Jakub Kicinski wrote:
> On Mon, 25 Jan 2021 16:18:19 +0100 Simon Horman wrote:
> > From: Baowen Zheng <baowen.zheng@corigine.com>
> > 
> > Allow a policer action to enforce a rate-limit based on packets-per-second,
> > configurable using a packet-per-second rate and burst parameters. This may
> > be used in conjunction with existing byte-per-second rate limiting in the
> > same policer action.
> > 
> > e.g.
> > tc filter add dev tap1 parent ffff: u32 match \
> >               u32 0 0 police pkts_rate 3000 pkts_burst 1000
> > 
> > Testing was unable to uncover a performance impact of this change on
> > existing features.
> > 
> > Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@netronome.com>
> > Signed-off-by: Louis Peens <louis.peens@netronome.com>
> 
> > diff --git a/net/sched/act_police.c b/net/sched/act_police.c
> > index 8d8452b1cdd4..d700b2105535 100644
> > --- a/net/sched/act_police.c
> > +++ b/net/sched/act_police.c
> > @@ -42,6 +42,8 @@ static const struct nla_policy police_policy[TCA_POLICE_MAX + 1] = {
> >  	[TCA_POLICE_RESULT]	= { .type = NLA_U32 },
> >  	[TCA_POLICE_RATE64]     = { .type = NLA_U64 },
> >  	[TCA_POLICE_PEAKRATE64] = { .type = NLA_U64 },
> > +	[TCA_POLICE_PKTRATE64]  = { .type = NLA_U64 },
> > +	[TCA_POLICE_PKTBURST64] = { .type = NLA_U64 },
> 
> Should we set the policy so that .min = 1?

Yes, I think so.
Thanks for spotting that.

> >  };
> >  
> >  static int tcf_police_init(struct net *net, struct nlattr *nla,
> > @@ -61,6 +63,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
> >  	bool exists = false;
> >  	u32 index;
> >  	u64 rate64, prate64;
> > +	u64 pps, ppsburst;
> >  
> >  	if (nla == NULL)
> >  		return -EINVAL;
> > @@ -183,6 +186,16 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
> >  	if (tb[TCA_POLICE_AVRATE])
> >  		new->tcfp_ewma_rate = nla_get_u32(tb[TCA_POLICE_AVRATE]);
> >  
> > +	if (tb[TCA_POLICE_PKTRATE64] && tb[TCA_POLICE_PKTBURST64]) {
> 
> Should we reject if only one is present?

Again, yes I think so.
I'll confirm this with the author too.

> > +		pps = nla_get_u64(tb[TCA_POLICE_PKTRATE64]);
> > +		ppsburst = nla_get_u64(tb[TCA_POLICE_PKTBURST64]);
> > +		if (pps) {
> > +			new->pps_present = true;
> > +			new->tcfp_pkt_burst = PSCHED_TICKS2NS(ppsburst);
> > +			psched_ppscfg_precompute(&new->ppsrate, pps);
> > +		}
> > +	}
> > +
> >  	spin_lock_bh(&police->tcf_lock);
> >  	spin_lock_bh(&police->tcfp_lock);
> >  	police->tcfp_t_c = ktime_get_ns();
> 
> > +void psched_ppscfg_precompute(struct psched_pktrate *r,
> > +			      u64 pktrate64)
> > +{
> > +	memset(r, 0, sizeof(*r));
> > +	r->rate_pkts_ps = pktrate64;
> > +	r->mult = 1;
> > +	/* The deal here is to replace a divide by a reciprocal one
> > +	 * in fast path (a reciprocal divide is a multiply and a shift)
> > +	 *
> > +	 * Normal formula would be :
> > +	 *  time_in_ns = (NSEC_PER_SEC * pkt_num) / pktrate64
> > +	 *
> > +	 * We compute mult/shift to use instead :
> > +	 *  time_in_ns = (len * mult) >> shift;
> > +	 *
> > +	 * We try to get the highest possible mult value for accuracy,
> > +	 * but have to make sure no overflows will ever happen.
> > +	 */
> > +	if (r->rate_pkts_ps > 0) {
> > +		u64 factor = NSEC_PER_SEC;
> > +
> > +		for (;;) {
> > +			r->mult = div64_u64(factor, r->rate_pkts_ps);
> > +			if (r->mult & (1U << 31) || factor & (1ULL << 63))
> > +				break;
> > +			factor <<= 1;
> > +			r->shift++;
> 
> Aren't there helpers somewhere for the reciprocal divide
> pre-calculation?

Now that you mention it, yes.

Looking over reciprocal_divide() I don't think it a good fit here as it
operates on 32bit values, whereas the packet rate is 64 bit.

Packet rate could be changed to a 32 bit entity if we convince ourselves we
don't want more than 2^32 - 1 packets per second (a plausible position
IMHO) - but that leads us to a secondary issue.

The code above is very similar to an existing (long existing)
byte rate variant of this helper - psched_ratecfg_precompute().
And I do think we want to:
a) Support 64-bit byte rates. Indeed such support seems to have
   been added to support 25G use-cases
b) Calculate byte and packet rates the same way

So I feel less and less that reciprocal_divide() is a good fit.
But perhaps I am mistaken.

In the meantime I will take a look to see if a helper common function can
be made to do (64 bit) reciprocal divides for the packet and byte rate
use-cases.  I.e. the common code in psched_ppscfg_precompute() and
psched_ratecfg_precompute().

> > +		}
> > +	}
> > +}
> > +EXPORT_SYMBOL(psched_ppscfg_precompute);
> 
> 
