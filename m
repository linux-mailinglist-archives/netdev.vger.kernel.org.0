Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783341F4B7C
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 04:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgFJCfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 22:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgFJCfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 22:35:21 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55134C05BD1E;
        Tue,  9 Jun 2020 19:35:20 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id s23so431680pfh.7;
        Tue, 09 Jun 2020 19:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KwqUKh9BVBfc72TeUnUwfF0EHYYLBppLJ9XiJiFqPwE=;
        b=mWbMQytT2cCRnHvGhoKaSG8N/VioLcW6SilE+9qrGvgXmVfihd1Qe0EcK2GY0MZeGX
         4aFShmg1DmmBoSK69GkCgjj1RH/QCeNJ4AwSR9zMjSgN9+Ow1xjImLcTNqa3ZZso8V1f
         yHc4yh+GcnJMGj2pOPLc8joa6z0bbo5iP84Woru/0UCSMKWc1y9t/nqQ89JJ9FjF9SAa
         DPAKi2qOTc6pPmhuVhbsQNxP7QYEfUle+NCELWWas0vTEsrouxp0eZxa6m5q4bOXlhe7
         if7bakqVUi1Ff6/qgAy60k/xBTBFSgtRrnoVZpI1nfILxtBe5xHdWA/0jpoCHp//c2Qs
         4Tew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KwqUKh9BVBfc72TeUnUwfF0EHYYLBppLJ9XiJiFqPwE=;
        b=LYMogoG1MqhSp6J9d77UXNXN28YfbPMazzLqADPRH4Nym14mr8kU7BAOFeY8oysGc6
         m0l2rOV/5NmrmQfRoB/t/PsXyJnu+iwvjtxmpU1SfCVvyWtCnEGnKc9z9l2dRIMaQ27d
         1f9w79NyNv2NlyUMIx1e/4RyUK1BNuIdBse86um2b4DCw9BbDUhzVAI1n4U1vN3t0sJm
         VFJky2k6zIVN16xbZ7L0TH+iME4pI6egQEduRScLUM2hBij3AhiYSmuAHs5G1bvLkoIG
         0G9pNewyMKsJkZUQMDoD0D0nyF+7lVQIL49hmE1K9DKDevd3LqeeXPnkEs9BwLKas+Ai
         xKuA==
X-Gm-Message-State: AOAM530Ehu9lQoVP5db9m5Hm3k7R2aB0ezOwJq75K+/HKLkwmhMjuRqJ
        Cn2hnuhztR4lIfs9jvIK6ZI=
X-Google-Smtp-Source: ABdhPJzpTUY42IZJdfxAnsDBVe4jQJHiDsTMF8jQmZPaB0C2uUB1RNu1iMZBZKYoqlWn04kIQAeFDQ==
X-Received: by 2002:a62:4e91:: with SMTP id c139mr782516pfb.18.1591756519769;
        Tue, 09 Jun 2020 19:35:19 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g18sm9616386pgn.47.2020.06.09.19.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 19:35:19 -0700 (PDT)
Date:   Wed, 10 Jun 2020 10:35:08 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Message-ID: <20200610023508.GR102436@dhcp-12-153.nay.redhat.com>
References: <20200604040940.GL102436@dhcp-12-153.nay.redhat.com>
 <871rmvkvwn.fsf@toke.dk>
 <20200604121212.GM102436@dhcp-12-153.nay.redhat.com>
 <87bllzj9bw.fsf@toke.dk>
 <20200604144145.GN102436@dhcp-12-153.nay.redhat.com>
 <87d06ees41.fsf@toke.dk>
 <20200605062606.GO102436@dhcp-12-153.nay.redhat.com>
 <878sgxd13t.fsf@toke.dk>
 <20200609030344.GP102436@dhcp-12-153.nay.redhat.com>
 <87lfkw7zhk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lfkw7zhk.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 10:31:19PM +0200, Toke Høiland-Jørgensen wrote:
> > Oh, sorry for the typo, the numbers make me crazy, it should be only
> > ingress i40e, egress veth. Here is the right description:
> >
> > Kernel 5.7 + my patch(ingress i40e, egress i40e)
> > xdp_redirect_map:
> >   generic mode: 1.9M PPS
> >   driver mode: 10.2M PPS
> >
> > xdp_redirect_map_multi:
> >   generic mode: 1.58M PPS
> >   driver mode: 7.16M PPS
> >
> > Kernel 5.7 + my patch(ingress i40e, egress veth(No XDP on peer))
> > xdp_redirect_map:
> >   generic mode: 2.2M PPS
> >   driver mode: 14.2M PPS
> 
> A few messages up-thread you were getting 4.15M PPS in this case - what
> changed? It's inconsistencies like these that make me suspicious of the
> whole set of results :/

I got the number after a reboot, not sure what happened.
And I also feel surprised... But the result shows the number, so I have
to put it here.

> 
> Are you getting these numbers from ethtool_stats.pl or from the XDP
> program? What counter are you looking at, exactly?

For bridge testing I use ethtool_stats.pl. For later xdp_redirect_map
and xdp_redirect_map_multi testing, I checked that ethtool_stats.pl and
XDP program shows the same number. When run ethtool_stats.pl the number
will go a little bit slower. So at the end I use the xdp program's number.

I'm going to re-setup the test environment and share it with you. Hope
we could get a final number that we all accept.

Thanks
Hangbin
