Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A2E2A9E8A
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgKFUVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:21:39 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:16575 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbgKFUVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 15:21:39 -0500
Received: from [10.193.177.137] (harsha.asicdesigners.com [10.193.177.137] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A6KLRbe013425;
        Fri, 6 Nov 2020 12:21:28 -0800
Subject: Re: [PATCH net] net/tls: Fix kernel panic when socket is in TLS ULP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, borisp@nvidia.com,
        secdev@chelsio.com
References: <20201103104702.798-1-vinay.yadav@chelsio.com>
 <20201104171609.78d410db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <976e0bb7-1846-94cc-0be7-9a9e62563130@chelsio.com>
 <20201105095344.0edecafa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <043b91f8-60e0-b890-7ce2-557299ee745d@chelsio.com>
 <20201105104658.4f96cc90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Message-ID: <a9d6ec03-1638-6282-470a-3a6b09b96652@chelsio.com>
Date:   Sat, 7 Nov 2020 02:02:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201105104658.4f96cc90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/6/2020 12:16 AM, Jakub Kicinski wrote:
> On Thu, 5 Nov 2020 23:55:15 +0530 Vinay Kumar Yadav wrote:
>>>>> We should prevent from the socket getting into LISTEN state in the
>>>>> first place. Can we make a copy of proto_ops (like tls_sw_proto_ops)
>>>>> and set listen to sock_no_listen?
>>>>
>>>> Once tls-toe (TLS_HW_RECORD) is configured on a socket, listen() call
>>>> from user on same socket will create hash at two places.
>>>
>>> What I'm saying is - disallow listen calls on sockets with tls-toe
>>> installed on them. Is that not possible?
>>>   
>> You mean socket with tls-toe installed shouldn't be listening at other
>> than adapter? basically avoid ctx->sk_proto->hash(sk) call.
> 
> No, replace the listen callback, like I said. Why are you talking about
> hash???
>As per my understanding we can't avoid socket listen.
Not sure how replacing listen callback solve the issue,
can you please elaborate ?
