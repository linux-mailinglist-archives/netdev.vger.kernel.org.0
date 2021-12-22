Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455B847D461
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241525AbhLVPt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:49:56 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:45110 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbhLVPtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:49:55 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 9310D200E2B3;
        Wed, 22 Dec 2021 16:49:53 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 9310D200E2B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1640188193;
        bh=GZ7VLGvDOpm+w7+1stlIaiTCb3ctBBwCJsi4A5ytvJw=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=ZT5jHbztg/K3HR6GNeVf19FEyJHuIjKib3Klnu2u+FKE23yWYnhftufFF3tvJho5h
         f0ZEzMpAjcd34lGEmcAcJRv0NRtBZ7yqAZwPAyDVoYAEWlLij9zKWilSofLQz8JAK2
         aoUUPSFceByta+ezc3SNXT+iDuwPOR5KkJCe/UTfb+01SSeR4bg8DG04DsXxN+Of7x
         zIVWVKEtjFTxkQeXfrs0faL6EO75ENg8jiY6wwlSFIqtJM/JvgdnS470VYg6o4OROc
         IWVSUNWNY1CH8eyQYfEsSJ6deiP+hjywd4Qe27K8RHDyWv2hHozK74l0S6h9Wxti6g
         Pux0s+EAihQYA==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 814CB602252D4;
        Wed, 22 Dec 2021 16:49:53 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Il8ePcCuoKRE; Wed, 22 Dec 2021 16:49:53 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 5E6A06016F429;
        Wed, 22 Dec 2021 16:49:53 +0100 (CET)
Date:   Wed, 22 Dec 2021 16:49:53 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Vladimir Oltean <olteanv@gmail.com>
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
Message-ID: <433890308.243090207.1640188193310.JavaMail.zimbra@uliege.be>
In-Reply-To: <20211221172337.kvqlkf3jqx2uqclm@skbuf>
References: <20211206211758.19057-1-justin.iurman@uliege.be> <20211207090700.55725775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1665643630.220612437.1638900313011.JavaMail.zimbra@uliege.be> <20211208141825.3091923c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1067680364.223350225.1639059024535.JavaMail.zimbra@uliege.be> <20211209163828.223815bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1065685246.241690721.1640106399663.JavaMail.zimbra@uliege.be> <20211221172337.kvqlkf3jqx2uqclm@skbuf>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF95 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Buffer occupancy data field
Thread-Index: 6aLBKica04ayJStGoq6B6A7PY5YYFw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dec 21, 2021, at 6:23 PM, Vladimir Oltean olteanv@gmail.com wrote:
> I know nothing about OAM and therefore did not want to comment, but I

NP, all opinions are more than welcome.

> think the point raised about the metric you propose being irrelevant in
> the context of offloaded data paths is quite important. The "devlink-sb"
> proposal was dismissed very quickly on grounds of requiring sleepable
> context, is that a deal breaker, and if it is, why? Not only offloaded

Can't sleep in the datapath.

> interfaces like switches/routers can report buffer occupancy. Plain NICs
> also have buffer pools, DMA RX/TX rings, MAC FIFOs, etc, that could
> indicate congestion or otherwise high load. Maybe slab information could

Indeed. Is there any API to retrieve such metric? Anyway, that would
probably involve (again) sleepable context.

> be relevant, for lack of a better option, on virtual interfaces, but if
> they're physical, why limit ourselves on reporting that? The IETF draft
> you present says "This field indicates the current status of the
> occupancy of the common buffer pool used by a set of queues." It appears
> to me that we could try to get a reporting that has better granularity
> (per interface, per queue) than just something based on
> skbuff_head_cache. What if someone will need that finer granularity in
> the future.

I think we all agree (Jakub, you, and I) on this point. The thing is,
what could be a better solution to have something generic that makes
sense, instead of just nothing? Is it actually feasible at all?
