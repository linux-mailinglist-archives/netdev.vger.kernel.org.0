Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B6E47D4E7
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 17:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbhLVQNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 11:13:47 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:47606 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbhLVQNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 11:13:47 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id D35BB200E7AA;
        Wed, 22 Dec 2021 17:13:45 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be D35BB200E7AA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1640189625;
        bh=axz04srqnv0RxqV7pv7GAMP0UEjejwvHX4olHG/d7Z8=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=zi4JRloI0XrgQdaOgZh0As7tjfiBIRCG3BvHT5MVj71sAksibUOj63r4ha7z4hLyl
         t1b8kp+XZ5tDRa6+sJF2NZW3rF69VzXAt544u2OrZNKCP8kczaBteqZryeKL0ZsU/x
         Hs36kXmV9x06o/LtdB1JoplLHK9Jg/2PZcFcJJtoK8nTgJxRei5UC41gc3AiMjG+89
         DkktAU6KJ4Ui/krEzO2wvbmEruQk7h+qwMSjLz9CVVj+WkYEz9+87TBtv1UaoFY/C+
         1JTNZBBV0NQL2OW4VYxDcbNaPTVtyPNanqK6ujlr2cn7gkuXvtWKXRgjrPR2VRLLCq
         uiSBr0yOxBaMw==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id BF819603B13B1;
        Wed, 22 Dec 2021 17:13:45 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gUVCreHqj4NY; Wed, 22 Dec 2021 17:13:45 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 97D1D60084334;
        Wed, 22 Dec 2021 17:13:45 +0100 (CET)
Date:   Wed, 22 Dec 2021 17:13:45 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
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
Message-ID: <2123917236.243143344.1640189625571.JavaMail.zimbra@uliege.be>
In-Reply-To: <20211221121306.487799cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211206211758.19057-1-justin.iurman@uliege.be> <1665643630.220612437.1638900313011.JavaMail.zimbra@uliege.be> <20211208141825.3091923c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1067680364.223350225.1639059024535.JavaMail.zimbra@uliege.be> <20211209163828.223815bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1065685246.241690721.1640106399663.JavaMail.zimbra@uliege.be> <20211221172337.kvqlkf3jqx2uqclm@skbuf> <20211221121306.487799cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF95 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Buffer occupancy data field
Thread-Index: 8XY1YSwMgrHVk8kEKsXYPPD68wONOg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dec 21, 2021, at 9:13 PM, Jakub Kicinski kuba@kernel.org wrote:
> On Tue, 21 Dec 2021 19:23:37 +0200 Vladimir Oltean wrote:
>> On Tue, Dec 21, 2021 at 06:06:39PM +0100, Justin Iurman wrote:
>> > On Dec 10, 2021, at 1:38 AM, Jakub Kicinski kuba@kernel.org wrote:
>> > > I think we're on the same page, the main problem is I've not seen
>> > > anyone use the skbuff_head_cache occupancy as a signal in practice.
>> > > 
>> > > I'm adding a bunch of people to the CC list, hopefully someone has
>> > > an opinion one way or the other.
>> > 
>> > It looks like we won't have more opinions on that, unfortunately.
>> > 
>> > @Jakub - Should I submit it as a PATCH and see if we receive more
>> > feedback there?
>> 
>> I know nothing about OAM and therefore did not want to comment, but I
>> think the point raised about the metric you propose being irrelevant in
>> the context of offloaded data paths is quite important. The "devlink-sb"
>> proposal was dismissed very quickly on grounds of requiring sleepable
>> context, is that a deal breaker, and if it is, why? Not only offloaded
>> interfaces like switches/routers can report buffer occupancy. Plain NICs
>> also have buffer pools, DMA RX/TX rings, MAC FIFOs, etc, that could
>> indicate congestion or otherwise high load. Maybe slab information could
>> be relevant, for lack of a better option, on virtual interfaces, but if
>> they're physical, why limit ourselves on reporting that? The IETF draft
>> you present says "This field indicates the current status of the
>> occupancy of the common buffer pool used by a set of queues." It appears
>> to me that we could try to get a reporting that has better granularity
>> (per interface, per queue) than just something based on
>> skbuff_head_cache. What if someone will need that finer granularity in
>> the future.
> 
> Indeed.
> 
> In my experience finding meaningful metrics is heard, the chances that
> something that seems useful on the surface actually provides meaningful
> signal in deployments is a lot lower than one may expect. And the

True.

> commit message reads as if the objective was checking a box in the
> implemented IOAM metrics, rather exporting relevant information.

Indeed, but not only. I sent this patchset as a Request for Comments to
see if it was correct and relevant. I mean, if there is no consensus on
this, I'll keep this data field as not supported, not a big deal. But
it would obviously be good to have it at some point (as long as what we
retrieve makes sense enough, and for all cases).

> We can do a roll call on people CCed but I read their silence as nobody

I thought that silence means consent. That's why more opinions would be
welcome, even if we seem to converge. Not only for opinions, but also
for any idea or guidance for a better solution, if any.

> thinks this metric is useful. Is there any experimental data you can
> point to which proves the signal strength?

Apart from the fact that I monitored the metric during normal and
high-load situations, honestly no. Values made sense during
those tests, though.
