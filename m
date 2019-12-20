Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16450127366
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 03:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfLTCTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 21:19:41 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8156 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726963AbfLTCTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 21:19:41 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 658332DE0C0B8ACCE7E0;
        Fri, 20 Dec 2019 10:19:39 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 20 Dec 2019
 10:19:33 +0800
Subject: Re: [PATCH net] af_packet: refactoring code for
 prb_calc_retire_blk_tmo
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, <maximmi@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>, <yuehaibing@huawei.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Network Development" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20191219013344.34603-1-maowenan@huawei.com>
 <CA+FuTScgWi905_NhGNsRzpwaQ+OPwahj6NtKgPjLZRjuqJvhXQ@mail.gmail.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <c0944cb6-eb63-b1e6-01da-4cddd2ab7f91@huawei.com>
Date:   Fri, 20 Dec 2019 10:19:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTScgWi905_NhGNsRzpwaQ+OPwahj6NtKgPjLZRjuqJvhXQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/12/19 21:56, Willem de Bruijn wrote:
> On Wed, Dec 18, 2019 at 8:37 PM Mao Wenan <maowenan@huawei.com> wrote:
>>
>> If __ethtool_get_link_ksettings() is failed and with
>> non-zero value, prb_calc_retire_blk_tmo() should return
>> DEFAULT_PRB_RETIRE_TOV firstly. Refactoring code and make
>> it more readable.
>>
>> Fixes: b43d1f9f7067 ("af_packet: set defaule value for tmo")
> 
> This is a pure refactor, not a fix.
yes , it is not a fix.
> 
> Code refactors make backporting fixes across releases harder, among
> other things. I think this code is better left as is. Either way, it
> would be a candidate for net-next, not net.
sorry, it would be net-next.
> 
>> -       unsigned int mbits = 0, msec = 0, div = 0, tmo = 0;
>> +       unsigned int mbits = 0, msec = 1, div = 0, tmo = 0;
> 
> Most of these do not need to be initialized here at all, really.
> 
some of them do not need to be initialized,
msec=1 can be reserved because it can indicate tmo is for millisecond and msec
initialized value is 1ms.

