Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA00947C4AE
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 18:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbhLURGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 12:06:42 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:55118 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhLURGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 12:06:42 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id E632B200BE63;
        Tue, 21 Dec 2021 18:06:39 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be E632B200BE63
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1640106399;
        bh=CqnTppCRL/Z3iguzsQkfLaxXmal+39aqeE7ldFtTgQI=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=giuH0XxfSdHffbcmLMHLKXCfnbus4h1hL/64gFa9pEFEEgMh6f8zW6sCktRyA+OX2
         LaPhz8Ngqe9GeiVI+XgMJObu+LVZe4QCe8woeXFZa7/4rQPhC67QLwVt5z5Lttm7ks
         eCOLsWwRSf9pn8lW6lV6WQkjzXz6zO3nKAG0RWBD9IWgId+diAAVJCHTkxoeHiSWC4
         rTyI582pB3HAqunyyOY1007bL4ZLs1E3WVopl5QbGTEs0Z0G2XK/syOjnriIHovpUK
         ekW/d6nBhkUWYhcbRfYocu9nBO++c0DzvQi6a0J+UoAFjZqPRCEm6dOZ5o7CrW55ES
         +5neRAQDe/lew==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id D3A0A603B0F5E;
        Tue, 21 Dec 2021 18:06:39 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gTTgnXttnc-k; Tue, 21 Dec 2021 18:06:39 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id ABD0D6008D821;
        Tue, 21 Dec 2021 18:06:39 +0100 (CET)
Date:   Tue, 21 Dec 2021 18:06:39 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com,
        iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>
Message-ID: <1065685246.241690721.1640106399663.JavaMail.zimbra@uliege.be>
In-Reply-To: <20211209163828.223815bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211206211758.19057-1-justin.iurman@uliege.be> <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1045511371.220520131.1638894949373.JavaMail.zimbra@uliege.be> <20211207090700.55725775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1665643630.220612437.1638900313011.JavaMail.zimbra@uliege.be> <20211208141825.3091923c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1067680364.223350225.1639059024535.JavaMail.zimbra@uliege.be> <20211209163828.223815bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF95 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Buffer occupancy data field
Thread-Index: cXzyaHe7M6fBsCgL0fZBmOJtzfWNjg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dec 10, 2021, at 1:38 AM, Jakub Kicinski kuba@kernel.org wrote:
> [...]
> I think we're on the same page, the main problem is I've not seen
> anyone use the skbuff_head_cache occupancy as a signal in practice.
> 
> I'm adding a bunch of people to the CC list, hopefully someone has
> an opinion one way or the other.

It looks like we won't have more opinions on that, unfortunately.

@Jakub - Should I submit it as a PATCH and see if we receive more
feedback there?
