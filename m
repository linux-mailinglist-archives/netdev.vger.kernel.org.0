Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FDF3D14D8
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhGUQ1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:27:14 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:39470 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGUQ1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:27:13 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id AC48B200C001;
        Wed, 21 Jul 2021 19:07:47 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be AC48B200C001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1626887267;
        bh=gh6hKttLghDfjGIi0srmFqw0tpEAOD8pPN2eC0u7DaM=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=ZtoDyD8H36KO45kzURYc7l1DNCOfSnK4CnfSf/S3CuvMRuLgeHH4kL0H4ZumASjGR
         fooQ4/VmCyH3swIKQOlxYa0yQUZNfZPD15UyTCR+taqwQt6KAP8vkEd8jLJW1RT2aw
         JCD552ujXKkg8lM90C5Lqj48R4LeOZelLq38kpzoolUItooUsGfz0UdV4pgjleT8Rx
         4w3vIh2VeYSIzoYZf8/REAHCU/D8w6bvgKwz2yzwkQVwu236VadTBwZVUcIzhEdMUW
         ROzkxR6ZTil7Nwwlyq0eCxMmztLykBgHxdtmIUA5RFcMDtzc7lSf4SVnbemKciKkzL
         SBR6fxxTY1FhA==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id A220F6008444F;
        Wed, 21 Jul 2021 19:07:47 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 65I-Or4iemCM; Wed, 21 Jul 2021 19:07:47 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 888D36008444D;
        Wed, 21 Jul 2021 19:07:47 +0200 (CEST)
Date:   Wed, 21 Jul 2021 19:07:47 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tom@herbertland.com
Message-ID: <144299238.24382358.1626887267507.JavaMail.zimbra@uliege.be>
In-Reply-To: <37f96841-39ad-c9bc-0b47-b1e418c4d9b8@gmail.com>
References: <20210720194301.23243-1-justin.iurman@uliege.be> <20210720194301.23243-3-justin.iurman@uliege.be> <37f96841-39ad-c9bc-0b47-b1e418c4d9b8@gmail.com>
Subject: Re: [PATCH net-next v5 2/6] ipv6: ioam: Data plane support for
 Pre-allocated Trace
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Data plane support for Pre-allocated Trace
Thread-Index: I40xp2+YG8xM/uDF0ZeHDlNyjX41qQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>  static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
>> @@ -999,6 +1056,10 @@ static const struct tlvtype_proc tlvprochopopt_lst[] = {
>>  		.type	= IPV6_TLV_ROUTERALERT,
>>  		.func	= ipv6_hop_ra,
>>  	},
>> +	{
>> +		.type	= IPV6_TLV_IOAM,
>> +		.func	= ipv6_hop_ioam,
>> +	},
> 
> It is a bit strange to put a not-yet used option in the midle of the table,
> before TLV_JUMBO (that some of us use already...)

Eric,

It's been a long time since I added it in the list, it's indeed an oversight. I'll move it down.

>>  	{
>>  		.type	= IPV6_TLV_JUMBO,
> >  		.func	= ipv6_hop_jumbo,
