Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C53AF3D3
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 03:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfIKBIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 21:08:48 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:40614 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfIKBIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 21:08:48 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 46F7D104B
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 18:08:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 46F7D104B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1568164127;
        bh=8215a4uhe9CjbT57PprFUSHT1irX35j+Q937pSZN6A8=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=WwR+LM53GGV6N5aMEej7XQbd07aPeu/kXa4rkv3RQMdsngnPaOC5b5v08Xss0kmMD
         6MpVM4npOAR/Soj7YuaP6zAXSfVr3nLc5U2YhxHYs5zvq855dsTZ1qRO9TecDhG85x
         0u0XWcxPwCIZRXhjWotdiJ3tbJlMqc7RMcJ0OVek=
Subject: Re: Strange routing with VRF and 5.2.7+
From:   Ben Greear <greearb@candelatech.com>
To:     netdev <netdev@vger.kernel.org>
References: <91749b17-7800-44c0-d137-5242b8ceb819@candelatech.com>
Organization: Candela Technologies
Message-ID: <51aae991-a320-43be-bf73-8b8c0ffcba60@candelatech.com>
Date:   Tue, 10 Sep 2019 18:08:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <91749b17-7800-44c0-d137-5242b8ceb819@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/19 3:17 PM, Ben Greear wrote:
> Today we were testing creating 200 virtual station vdevs on ath9k, and using
> VRF for the routing.

Looks like the same issue happens w/out VRF, but there I have oodles of routing
rules, so it is an area ripe for failure.

Will upgrade to 5.2.14+ and retest, and try 4.20 as well....

Thanks,
Ben

> 
> This really slows down the machine in question.
> 
> During the minutes that it takes to bring these up and configure them,
> we loose network connectivity on the management port.
> 
> If I do 'ip route show', it just shows the default route out of eth0, and
> the subnet route.  But, if I try to ping the gateway, I get an ICMP error
> coming back from the gateway of one of the virtual stations (which should be
> safely using VRFs and so not in use when I do a plain 'ping' from the shell).
> 
> I tried running tshark on eth0 in the background and running ping, and it captures
> no packets leaving eth0.
> 
> After some time (and during this time, my various scripts will be (re)configuring
> vrfs and stations and related vrf routing tables and such,
> but should *not* be messing with the main routing table, then suddenly
> things start working again.
> 
> I am curious if anyone has seen anything similar or has suggestions for more
> ways to debug this.  It seems reproducible, but it is a pain to
> debug.
> 
> Thanks,
> Ben
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

