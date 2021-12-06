Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B36F46A20F
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241109AbhLFRI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350574AbhLFRHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 12:07:30 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D43C061746;
        Mon,  6 Dec 2021 09:04:01 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id s6so5432544ild.9;
        Mon, 06 Dec 2021 09:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2IvWFLuHLBYxGkmDjEw+pjmwb6VHqWVX+Fe386Zgr5U=;
        b=HeS81PUZH715DbYMInl/iKXbhME/VcCTo39xsJNh4UNCWiduo1pBL0S6wjntXWJsQ5
         uQHvRyRX4pWPwFGnkoWm+7HxOTB7RoMysdbXSSV5F1rRy/hxSpioQNsxUG4U53N4XxRf
         Br05WDSDeAJ99f75coN3IUK04y/zypXRyMIdJsR+LKOJMQpGe2cAKPmRptpN726n1y8O
         qVRcOImFSz2G8jEJ6vif0fBDwvzBCUnX/o/LWEQNF07Kj1IxPfahqO1owQG4/LTOtcxw
         2WIcwEB2p3rBNq1ydTgRZSM2yjCYcTXq+an2pYpifEtY/CMdd7k3sI1U9kNUjbYqIfW/
         +Y1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2IvWFLuHLBYxGkmDjEw+pjmwb6VHqWVX+Fe386Zgr5U=;
        b=5b+OtjdndFfRm/ghpXblv1VH2Qx7eW4KWH6Ir8Ub1304qzxg5Yn6+VkXFYRYLTmTNY
         kSqqcwwBunCMp+BqDKmresA68X+UqlH/RMvNPbUkxgcqdsyFCiLk5fFwiFkQPcdMeV0l
         ZbLBUKnXwrb9Y7GE1i9/iebcDjhKxhU/89x7HnSRwt3KmXqkgRNVZZ1Y9Qg7R6AgFDL6
         u0X4MJIJmerkuxi/zXUJW338I38sp8hNj4hUFZ+IQKeSE3fM0Y7Pjck/xsPWQ1RPlzIr
         Hua25WjeuELICT3vG4nO0YlMvLDvnYCX+1aUg9m5RCG1jDgcuoTvRor2d7RZp+mChN6F
         j4eQ==
X-Gm-Message-State: AOAM531teZZP8dPNfEn5NmfzZthMLlJ4OCVlSQM6sJ+51foMvyikFJL9
        9jVP2P3xzzyfcN7UcYBYUSg=
X-Google-Smtp-Source: ABdhPJwX0uu6vh82s6rO0rS70/xhL0JtlORWFaapo3I5PdxJWK8Cxj1sdBsyaKjtv1z+9X3vTFEg/w==
X-Received: by 2002:a05:6e02:b4f:: with SMTP id f15mr29096852ilu.201.1638810240612;
        Mon, 06 Dec 2021 09:04:00 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id 1sm6450417ill.57.2021.12.06.09.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:04:00 -0800 (PST)
Date:   Mon, 06 Dec 2021 09:03:53 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61ae427999a20_881820893@john.notmuch>
In-Reply-To: <Ya4oCkbOjBHFOHyS@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <95151f4b8a25ce38243e82f0a82104d0f46fb33a.1638272238.git.lorenzo@kernel.org>
 <61ad7e4cbc69d_444e20888@john.notmuch>
 <Ya4oCkbOjBHFOHyS@lore-desk>
Subject: Re: [PATCH v19 bpf-next 03/23] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> > Lorenzo Bianconi wrote:
> > > Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> > > XDP remote drivers if this is a "non-linear" XDP buffer. Access
> > > skb_shared_info only if xdp_buff mb is set in order to avoid possible
> > > cache-misses.
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > 
> > [...]
> > 
> > > @@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
> > >  		      struct xdp_buff *xdp, u32 desc_status)
> > >  {
> > >  	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> > > -	int i, num_frags = sinfo->nr_frags;
> > >  	struct sk_buff *skb;
> > > +	u8 num_frags;
> > > +	int i;
> > > +
> > > +	if (unlikely(xdp_buff_is_mb(xdp)))
> > > +		num_frags = sinfo->nr_frags;
> > 
> > Doesn't really need a respin IMO, but rather an observation. Its not
> > obvious to me the unlikely/likely pair here is wanted. Seems it could
> > be relatively common for some applications sending jumbo frames.
> > 
> > Maybe worth some experimenting in the future.
> 
> Probably for mvneta it will not make any difference but in general I tried to
> avoid possible cache-misses here (accessing sinfo pointers). I will carry out
> some comparison to see if I can simplify the code.

Agree, I'll predict for mvneta it doesn't make a difference either way and
perhaps if you want to optimize small pkt benchmarks on a 100Gbps nic it would
show a win.
