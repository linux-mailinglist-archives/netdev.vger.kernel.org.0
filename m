Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D9747010B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 13:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241067AbhLJNAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:00:51 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:50948 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbhLJNAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:00:50 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 7B7FC200BE4B;
        Fri, 10 Dec 2021 13:57:13 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 7B7FC200BE4B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1639141033;
        bh=wFe+CeEqaCqv3NqjLOm7g2hIIbR1I8s0HQPuVv6Eubc=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=V3BXAPd0khk90c2AKalZHbzlDLgFqfJIIVL7uw+jq5cilUuKSMVMoe/mQoYJMw7p3
         tk9c5i38Jq/cSXknqX59IpxhuIlg9soAlbfRiZGF/8i9vNCSHPwvzcRZxL1YjbkgY7
         yyoBL9OiPqzVeCgiC8LAI4vkRZCFU1hgMbPb4ASFbrC4JqJMkaOn3Y5kMqGLBLnSNX
         GswfzgXIuPI9pBGth/0nNP/BMAAK0Qr8u2dBECEol5xz6DR9alGBB0+kmdnUrkP8zD
         uvJVRPZlxFsHDsYF1qgRwqhZcV+y3ETvjCtd7ih4SICfDy0Hvyz7q8cNNFeAZv6WT+
         r2In0zBGRrdYA==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 5EFA96022451C;
        Fri, 10 Dec 2021 13:57:13 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id IkfwqIB4FfQx; Fri, 10 Dec 2021 13:57:13 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 1AF6E6014635C;
        Fri, 10 Dec 2021 13:57:13 +0100 (CET)
Date:   Fri, 10 Dec 2021 13:57:12 +0100 (CET)
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
Message-ID: <1887416432.225095145.1639141032334.JavaMail.zimbra@uliege.be>
In-Reply-To: <20211209163828.223815bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211206211758.19057-1-justin.iurman@uliege.be> <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1045511371.220520131.1638894949373.JavaMail.zimbra@uliege.be> <20211207090700.55725775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1665643630.220612437.1638900313011.JavaMail.zimbra@uliege.be> <20211208141825.3091923c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1067680364.223350225.1639059024535.JavaMail.zimbra@uliege.be> <20211209163828.223815bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [139.165.223.37]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF94 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Buffer occupancy data field
Thread-Index: U6awZlPIBpVjCQ/wD/+4f3Z2EMewfA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Indeed, would be a better fit. I didn't know about this one, thanks for
>> that. It's a shame it can't be used in this context, though. But, at the
>> end of the day, we're left with nothing regarding buffer occupancy. So
>> I'm wondering if "something" is not better than "nothing" in this case.
>> And, for that, we're back to my previous answer on why I agree and
>> disagree with what you said about its utility.
> 
> I think we're on the same page, the main problem is I've not seen
> anyone use the skbuff_head_cache occupancy as a signal in practice.

Indeed.

> I'm adding a bunch of people to the CC list, hopefully someone has
> an opinion one way or the other.

+1, thanks Jakub.

> Lore link to the full thread, FWIW:
> 
> https://lore.kernel.org/all/20211206211758.19057-1-justin.iurman@uliege.be/
