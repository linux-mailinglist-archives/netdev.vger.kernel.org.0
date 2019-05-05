Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4BB13CBC
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 04:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfEECLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 22:11:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34292 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbfEECLU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 22:11:20 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1FB23F88FDFDF1B6B756;
        Sun,  5 May 2019 10:11:18 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.20) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Sun, 5 May 2019
 10:11:11 +0800
Subject: Re: [PATCH v2] net: route: Fix vrf dst_entry ref count false
 increasing
To:     David Ahern <dsahern@gmail.com>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     mousuanming <mousuanming@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>
References: <1a4c0c31-e74c-5167-0668-328dd342005e@huawei.com>
 <dd325420-37ae-f731-1ea8-01f630820af0@gmail.com>
From:   linmiaohe <linmiaohe@huawei.com>
Message-ID: <d20b12f2-129a-7055-6dec-075523458b21@huawei.com>
Date:   Sun, 5 May 2019 10:11:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <dd325420-37ae-f731-1ea8-01f630820af0@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.189.20]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/5/4 22:59, David Ahern wrote:
> On 5/4/19 7:13 AM, linmiaohe wrote:
>> From: Suanming.Mou <mousuanming@huawei.com>
>>
>> When config ip in default vrf same as the ip in specified
>> vrf, fib_lookup will return the route from table local
>> even if the in device is an enslaved l3mdev. Then the
> 
> you need to move the local rule with a preference of 0 after the l3mdev
> rule.
> 
> 

Move the local rule after l3mdev rule can get rid of this problem. And
even if this happend, we can delete the same ip address in default vrf
to fix it.
But I think maybe it's still a problem because other rule with default
vrf out device holds the specified vrf device. It looks unreasonable.

Many Thanks.

