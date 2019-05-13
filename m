Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00F61B581
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbfEMMGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:06:44 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44710 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729634AbfEMMGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 08:06:44 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 79C63BC8329D4354E033;
        Mon, 13 May 2019 20:06:41 +0800 (CST)
Received: from [127.0.0.1] (10.177.216.125) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Mon, 13 May 2019
 20:06:39 +0800
Subject: Re: [PATCH net-next] ipv4: Add support to disable icmp timestamp
To:     Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>
References: <1557711193-7284-1-git-send-email-chenweilong@huawei.com>
 <20190513074928.GC22349@unicorn.suse.cz>
 <676bcfba-7688-1466-4340-458941aa9258@huawei.com>
 <20190513114900.GD22349@unicorn.suse.cz>
CC:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>
From:   Weilong Chen <chenweilong@huawei.com>
Message-ID: <04fe9e70-2461-268b-7599-d2170c40377f@huawei.com>
Date:   Mon, 13 May 2019 20:06:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <20190513114900.GD22349@unicorn.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.216.125]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/5/13 19:49, Michal Kubecek wrote:
> On Mon, May 13, 2019 at 07:38:37PM +0800, Weilong Chen wrote:
>>
>> On 2019/5/13 15:49, Michal Kubecek wrote:
>>> On Mon, May 13, 2019 at 09:33:13AM +0800, Weilong Chen wrote:
>>>> The remote host answers to an ICMP timestamp request.
>>>> This allows an attacker to know the time and date on your host.
>>>
>>> Why is that a problem? If it is, does it also mean that it is a security
>>> problem to have your time in sync (because then the attacker doesn't
>>> even need ICMP timestamps to know the time and date on your host)?
>>>
>> It's a low risk vulnerability(CVE-1999-0524). TCP has
>> net.ipv4.tcp_timestamps = 0 to disable it.
>
> That does not really answer my question. Even if "CVE" meant much more
> back in 1999 than it does these days, none of the CVE-1999-0524
> descriptions I found cares to explain why it's considered a problem that
> an attacker knows time on your machine. They just claim it is. If we
> assume it is a security problem, then we would have to consider having
> correct time a security problem which is something I certainly don't
> agree with.
>
> One idea is that there may be applications using current time as a seed
> for random number generator - but then such application is the real
> problem, not having correct time.
>
Yes, the target computer responded to an ICMP timestamp request. By 
accurately determining the target's clock state, an attacker can more 
effectively attack certain time-based pseudorandom number generators 
(PRNGs) and the authentication systems that rely on them.

So, the 'time' may become sensitive information. The OS should not leak 
it out.

> Michal Kubecek
>
> .
>

