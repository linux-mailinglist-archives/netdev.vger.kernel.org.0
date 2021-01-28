Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A22A307579
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhA1MFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhA1MDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:03:31 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8ECC061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 04:02:38 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id a14so6293463edu.7
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 04:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=R4v02/snh+GiV8ooyIC0fqwNhrJhmwqfA58dg31pFJY=;
        b=HAO1QgsBzaVnIuD212W1wRnBOHgLyVzvAy8jOxISfCyS1pfDq+F4Zdmcjp7YU8E4QF
         VRVZspXwu7mq/PZWMU1R2IX8su2U2qJ68jF8HkftBAbSuvmdSIcnCF5jWQnpQ1fyjAZ2
         xrtIzUAGTlhvgGuaWxGmUYK4nW5I+xc1q5szkJuYXAlQKzYjSvi20kURirxKziGMsn2b
         zKcCBFyIhxACDkAPDooDPR/L0yU2WsjeTkQIJ6ZvMXth/g9078FrtZT9Kq8+5mVV4BsP
         R1O43FD0hcCCnXOM96V5w+i8O+4mc6Aqah2EpItER5fmGEw6Vywny/CZXiI5q7862X0T
         AU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R4v02/snh+GiV8ooyIC0fqwNhrJhmwqfA58dg31pFJY=;
        b=K3bR8d75Ytn7tfDv3tJQEGgbMmoFsrmvC4pH7pNPhpTvlBmskclvJ+yl/mjfZyMkZW
         Nd//MgPynoyedKlLJu1iWG7y8FCKzWFSrWJmlatDNAW7cY0650ZOeCsKUcwUyRU1UlL8
         RYhbuV2dHoY9k/6V/WEba6qkir1biHyrxZVHKOJhfYkADuxFGJd3l1HcAykk7eKygzu7
         itD5uL1XOib4ozKCfql34aTch+v7ocUKZW/nSoFcd9gXDN6J+n/8aF3Yb6BBo8fDpTxc
         HHhUHbYFSiDAGGD3/NFYTsXLGxEjX2PXesirQjEd2ELtvqvIR0QH4biXwyQOanGmZED2
         9kWQ==
X-Gm-Message-State: AOAM532wQ9dfqh/WJdi9Cb8oOvJB7Q2FoTImpNnL3Hr10AGmKU4yNXKv
        lqnRIso+wp8jX2IomqvtqOo2Ww==
X-Google-Smtp-Source: ABdhPJzo2rOGpACDJaf2cxxSrUj1PeuFoHecqARBKC/mmao7cTd29CUwC1RiDVW2piqO6trGqdSxDg==
X-Received: by 2002:aa7:d6cf:: with SMTP id x15mr13759608edr.336.1611835356847;
        Thu, 28 Jan 2021 04:02:36 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id j23sm2161213ejs.112.2021.01.28.04.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 04:02:35 -0800 (PST)
Date:   Thu, 28 Jan 2021 13:02:34 +0100
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
Message-ID: <20210128120233.GA8059@netronome.com>
References: <20210125151819.8313-1-simon.horman@netronome.com>
 <20210126183812.180d0d61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210127110222.GA29081@netronome.com>
 <20210127125905.628c0a9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127125905.628c0a9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 12:59:05PM -0800, Jakub Kicinski wrote:
> On Wed, 27 Jan 2021 12:02:23 +0100 Simon Horman wrote:
> > > > +void psched_ppscfg_precompute(struct psched_pktrate *r,
> > > > +			      u64 pktrate64)
> > > > +{
> > > > +	memset(r, 0, sizeof(*r));
> > > > +	r->rate_pkts_ps = pktrate64;
> > > > +	r->mult = 1;
> > > > +	/* The deal here is to replace a divide by a reciprocal one
> > > > +	 * in fast path (a reciprocal divide is a multiply and a shift)
> > > > +	 *
> > > > +	 * Normal formula would be :
> > > > +	 *  time_in_ns = (NSEC_PER_SEC * pkt_num) / pktrate64
> > > > +	 *
> > > > +	 * We compute mult/shift to use instead :
> > > > +	 *  time_in_ns = (len * mult) >> shift;
> > > > +	 *
> > > > +	 * We try to get the highest possible mult value for accuracy,
> > > > +	 * but have to make sure no overflows will ever happen.
> > > > +	 */
> > > > +	if (r->rate_pkts_ps > 0) {
> > > > +		u64 factor = NSEC_PER_SEC;
> > > > +
> > > > +		for (;;) {
> > > > +			r->mult = div64_u64(factor, r->rate_pkts_ps);
> > > > +			if (r->mult & (1U << 31) || factor & (1ULL << 63))
> > > > +				break;
> > > > +			factor <<= 1;
> > > > +			r->shift++;  
> > > 
> > > Aren't there helpers somewhere for the reciprocal divide
> > > pre-calculation?  
> > 
> > Now that you mention it, yes.
> > 
> > Looking over reciprocal_divide() I don't think it a good fit here as it
> > operates on 32bit values, whereas the packet rate is 64 bit.
> > 
> > Packet rate could be changed to a 32 bit entity if we convince ourselves we
> > don't want more than 2^32 - 1 packets per second (a plausible position
> > IMHO) - but that leads us to a secondary issue.
> > 
> > The code above is very similar to an existing (long existing)
> > byte rate variant of this helper - psched_ratecfg_precompute().
> > And I do think we want to:
> > a) Support 64-bit byte rates. Indeed such support seems to have
> >    been added to support 25G use-cases
> > b) Calculate byte and packet rates the same way
> > 
> > So I feel less and less that reciprocal_divide() is a good fit.
> > But perhaps I am mistaken.
> > 
> > In the meantime I will take a look to see if a helper common function can
> > be made to do (64 bit) reciprocal divides for the packet and byte rate
> > use-cases.  I.e. the common code in psched_ppscfg_precompute() and
> > psched_ratecfg_precompute().
> 
> No strong feelings, I'll just ask to document the reasoning in the
> commit message or the comment above.

Thanks. I'll include some text explaining this when reposting.
