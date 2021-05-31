Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232713959E6
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 13:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhEaLw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 07:52:27 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:39070 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbhEaLw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 07:52:26 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 1F9B0200BE7A;
        Mon, 31 May 2021 13:50:45 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 1F9B0200BE7A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622461845;
        bh=yD3ZQhsDRj/sNWFYwKevMGbAZdpzociIWi7Z6J6+RRc=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=fDTnxcj7i455gcDc1+VRGQk1nYT9IqXZpxP/OaOhz8R2o/KsRvhjcWenf51n2DIBW
         ofWSEJs62OTfExmV+8pt3sespEpIV/83nHja4Nwa+MGsSBvDc5kqvnw9hUv3MugRn+
         2fOMgd2hxFr1S7VlN+C3IDTFoVb1wuw47zZ3NJkVzu6d5bgMh0tf6HZzjBZWRHyqpc
         6NIg0ZTtNZJmivNvC51yWlwfpBaehuErJpldv9vl7kCtpDCCkM30JB2+JNAGuhc/by
         sKBoTfqfEPYCXJFxWuX1TOFO53i4z6eXi/5Mud9KzbfGIckikebe17oS41KQfe7i5F
         93zaI+US4OgUA==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 1746A6008D40D;
        Mon, 31 May 2021 13:50:45 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YSp18gwONd3Q; Mon, 31 May 2021 13:50:45 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 015DC6008D58C;
        Mon, 31 May 2021 13:50:45 +0200 (CEST)
Date:   Mon, 31 May 2021 13:50:44 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Message-ID: <1696168387.35309838.1622461844972.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210530130519.2fc95684@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20210527151652.16074-1-justin.iurman@uliege.be> <20210527151652.16074-3-justin.iurman@uliege.be> <20210529140555.3536909f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <1678535209.34108899.1622370998279.JavaMail.zimbra@uliege.be> <1616887215.34203636.1622386231363.JavaMail.zimbra@uliege.be> <20210530130519.2fc95684@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Subject: Re: [PATCH net-next v4 2/5] ipv6: ioam: Data plane support for
 Pre-allocated Trace
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Data plane support for Pre-allocated Trace
Thread-Index: PNlP+GPsr+izNuwzXWAAcFhPZkjPxQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >> Last two sentences are repeated.
>> > 
>> > One describes net.ipv6.conf.XXX.ioam6_id (per interface) and the other describes
>> > net.ipv6.ioam6_id (per namespace). It allows for defining an IOAM id to an
>> > interface and, also, the node in general.
>> >   
>> >> Is 0 a valid interface ID? If not why not use id != 0 instead of
>> >> having a separate enabled field?
>> > 
>> > Mainly for semantic reasons. Indeed, I'd prefer to keep a specific "enable" flag
>> > per interface as it sounds more intuitive. But, also because 0 could very well
>> > be a "valid" interface id (more like a default value).
>> 
>> Actually, it's more than for semantic reasons. Take the following topology:
>> 
>>  _____              _____              _____
>> |     | eth0  eth0 |     | eth1  eth0 |     |
>> |  A  |.----------.|  B  |.----------.|  C  |
>> |_____|            |_____|            |_____|
>> 
>> If I only want IOAM to be deployed from A to C but not from C to A,
>> then I would need the following on B (let's just focus on B):
>> 
>> B.eth0.ioam6_enabled = 1 // enable IOAM *on input* for B.eth0
>> B.eth0.ioam6_id = B1
>> B.eth1.ioam6_id = B2
>> 
>> Back to your suggestion, if I only had one field (i.e., ioam6_id != 0
>> to enable IOAM), I would end up with:
>> 
>> B.eth0.ioam6_id = B1 // (!= 0)
>> B.eth1.ioam6_id = B2 // (!= 0)
>> 
>> Which means in this case that IOAM would also be enabled on B for the
>> reverse path. So we definitely need two fields to distinguish both
>> the status (enabled/disabled) and the IOAM ID of an interface.
> 
> Makes sense. Is it okay to assume 0 is equivalent to ~0, though:
> 
> +		raw32 = dev_net(skb->dev)->ipv6.sysctl.ioam6_id;
> +		if (!raw32)
> +			raw32 = IOAM6_EMPTY_u24;
> 
> etc. Quick grep through the RFC only reveals that ~0 is special (not
> available). Should we init ids to ~0 instead of 0 explicitly?

Yes, I think so. And it is indeed correct to assume that. So, if it's fine for you to init IDs to ~0, then it'd be definitely a big yes from me.
