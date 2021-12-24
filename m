Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB8947EED5
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 13:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352676AbhLXMdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 07:33:46 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:55107 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbhLXMdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 07:33:45 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 70DDD201B720;
        Fri, 24 Dec 2021 13:33:43 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 70DDD201B720
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1640349223;
        bh=uXGRlUsu1ggjjzXIz027ZpF7DmpikALWlcaqXM+6eSU=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=eFFbVxWJQLfYTFqz3WkY3ABn8reEgOhqIAftzsQBA4QnlgSW08Hsk0T4nNw6EZ7H/
         AdIHLyrnX0TqEXtuPnTy76Kz4m8lamHmvLWBJWHg6YHPk16ryodjw5q6hR3S5W6Nz4
         yi65ram8NIvUSQ7cJ/r6EYK+N6jMaWHWL5/31+4/gwK1+biZpiABkZrFL3PH/EhfHu
         udQlXEXifyYa8F3S0wazWeBv9PIcTw844NM+0Oz4HdbohrdqUydLj8WKGsHtzOwfeD
         u6uTDjuXsGhxvf1WmPll04UlfC0XlxfV3hN2x+11NsgQecOYpaS2bUM2t7o0z6S0RT
         37Smiz70HXiDQ==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 69063603B16DB;
        Fri, 24 Dec 2021 13:33:43 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id A42QGZxRc8fX; Fri, 24 Dec 2021 13:33:43 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 516C360225583;
        Fri, 24 Dec 2021 13:33:43 +0100 (CET)
Date:   Fri, 24 Dec 2021 13:33:43 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org
Message-ID: <1276384477.245449661.1640349223295.JavaMail.zimbra@uliege.be>
In-Reply-To: <20211223192845.1586b5b2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20211223155515.15564-1-justin.iurman@uliege.be> <20211223192845.1586b5b2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Subject: Re: [PATCH net-next] ipv6: ioam: Support for Queue depth data field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF95 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Queue depth data field
Thread-Index: bWyYaJIZNS1EUaVNp1uTM45T6TMhsQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dec 24, 2021, at 4:28 AM, Jakub Kicinski kuba@kernel.org wrote:
> On Thu, 23 Dec 2021 16:55:15 +0100 Justin Iurman wrote:
>> +		} else {
>> +			queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);
>> +			qdisc_qstats_qlen_backlog(queue->qdisc, &qlen, &backlog);
>> +
>> +			*(__be32 *)data = cpu_to_be32(qlen);
>> +		}
>>  		data += sizeof(__be32);
>>  	}
>>  
> 
> sparse complains that:
> 
> net/ipv6/ioam6.c:729:56: warning: incorrect type in argument 1 (different
> address spaces)
> net/ipv6/ioam6.c:729:56:    expected struct Qdisc *sch
> net/ipv6/ioam6.c:729:56:    got struct Qdisc [noderef] __rcu *qdisc

Thanks for reporting, I indeed forgot to run sparse. I'm surprised the
bot did not report it, though. Sorry for that, will fix this in -v2.
