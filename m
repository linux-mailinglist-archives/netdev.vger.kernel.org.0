Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002E447C4F0
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 18:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240380AbhLURXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 12:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbhLURXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 12:23:42 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B21C061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 09:23:41 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y13so54791960edd.13
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 09:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TALeJ4Y3TKvr4ta7ys0FgNoMCgdw5uQtbZ7yHc4Nyvs=;
        b=VeGPHtbzXDOVXl8Iq7OptXrLF/RVT4Tbn7HLlv4L4ICVyglKt/GV7K9L1NBHlO5UZV
         tKxVvDWrgBjIEvsE7HnPjlHZfaPZuGmcCx8xyPXqWG1HVBbDQeZTEVAzx+64B7YllXYL
         DHcnzfIhf7AJbN/D8u1Aomg297cg4QRy4c2SwY/7T1NbXcrtGk5CrvrIRWFsBhGiPZEL
         XFWmgbpAO2MscKzZS8mpVI/+vVkoYLlQxFOhdd0Flp+KdbUGZWhsnF65Hwz4nnlT7DiQ
         h0IeqrGb396Iw5sMkxU3NQHoK8eCnoFCGCk08dTIclX+kMMBcaAd2hP5ow+6yCvFWyOB
         +cdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TALeJ4Y3TKvr4ta7ys0FgNoMCgdw5uQtbZ7yHc4Nyvs=;
        b=05QfrLnzQYJG3Ot11Il8NGP5JToCABew9jKVmYSEwFXEpPtvkd9ITALhk1+h7ZuoUV
         ZUh32TdUJCvonzMhnAdZsWg9yxyVJS+13JgeMwupxFxNJB+JgUOQVmOxIshiCssS9mRH
         +sHTdMPVQNPGsyxpKhDGC/V6jvb6eF1gVwd9nBKlqsfebDUsZ3EQnwjCv9eenUBHOTaQ
         gqckQ2rGSCN+9jhShnPw0MPVVeXpj8bUZD9unC3RCAP4H7j7sM6n9NcMON28ZgnpdvXH
         sxJMAch9EY3RoWbVIjzPTTbGIL4zjhZPjJ/kiCShUFFrC2F4WHGgk1N5jK1MN6CU97hl
         bzNA==
X-Gm-Message-State: AOAM531rGcN9TszOCQj10oBz6jIztU9uZGQIFy7rU79XQvUgtvozyUTQ
        qb7mtW38WLE6CjrSJweDKaI=
X-Google-Smtp-Source: ABdhPJwJmypeXaQ8MelSoMa2Ucq3Q5LlNuH0Rvly3+Pkeb4+7z4Ee6xrxqB289Cm36AXa3pu/SEo6g==
X-Received: by 2002:a17:906:974a:: with SMTP id o10mr3448517ejy.226.1640107420297;
        Tue, 21 Dec 2021 09:23:40 -0800 (PST)
Received: from skbuf ([188.26.56.205])
        by smtp.gmail.com with ESMTPSA id ga36sm473763ejc.200.2021.12.21.09.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 09:23:39 -0800 (PST)
Date:   Tue, 21 Dec 2021 19:23:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        linux-mm@kvack.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy data
 field
Message-ID: <20211221172337.kvqlkf3jqx2uqclm@skbuf>
References: <20211206211758.19057-1-justin.iurman@uliege.be>
 <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1045511371.220520131.1638894949373.JavaMail.zimbra@uliege.be>
 <20211207090700.55725775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1665643630.220612437.1638900313011.JavaMail.zimbra@uliege.be>
 <20211208141825.3091923c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1067680364.223350225.1639059024535.JavaMail.zimbra@uliege.be>
 <20211209163828.223815bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1065685246.241690721.1640106399663.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1065685246.241690721.1640106399663.JavaMail.zimbra@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 06:06:39PM +0100, Justin Iurman wrote:
> On Dec 10, 2021, at 1:38 AM, Jakub Kicinski kuba@kernel.org wrote:
> > [...]
> > I think we're on the same page, the main problem is I've not seen
> > anyone use the skbuff_head_cache occupancy as a signal in practice.
> > 
> > I'm adding a bunch of people to the CC list, hopefully someone has
> > an opinion one way or the other.
> 
> It looks like we won't have more opinions on that, unfortunately.
> 
> @Jakub - Should I submit it as a PATCH and see if we receive more
> feedback there?

I know nothing about OAM and therefore did not want to comment, but I
think the point raised about the metric you propose being irrelevant in
the context of offloaded data paths is quite important. The "devlink-sb"
proposal was dismissed very quickly on grounds of requiring sleepable
context, is that a deal breaker, and if it is, why? Not only offloaded
interfaces like switches/routers can report buffer occupancy. Plain NICs
also have buffer pools, DMA RX/TX rings, MAC FIFOs, etc, that could
indicate congestion or otherwise high load. Maybe slab information could
be relevant, for lack of a better option, on virtual interfaces, but if
they're physical, why limit ourselves on reporting that? The IETF draft
you present says "This field indicates the current status of the
occupancy of the common buffer pool used by a set of queues." It appears
to me that we could try to get a reporting that has better granularity
(per interface, per queue) than just something based on
skbuff_head_cache. What if someone will need that finer granularity in
the future.
