Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B3D33F9F0
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 21:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbhCQU2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 16:28:43 -0400
Received: from gateway36.websitewelcome.com ([50.116.127.2]:19985 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233300AbhCQU2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 16:28:17 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id CBD4D400D43C7
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:04:17 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id McOvlx51TMGeEMcOvllxs1; Wed, 17 Mar 2021 15:04:17 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=D8jlraIWCpRmgNot1k3zhHVL68RtL3nZfNp9Ci7QXGc=; b=wT9iZ75rdYBI8q0oAJMJJ921tV
        X0EyaqaeXNl6TqwJMi1jrUMMOrtW3DhSF/uGyfy3/jhSMgZitmrYjomKVxIO5FK3kLObYWJAegVyt
        5SLq1nuTvl06FylCEIphqedo3Bq1aRhyQR7utbMXIyuCL5ll0r4H6Z//FxcVHp8FGJjbreapk4lbQ
        LQggvdpZJm1f7H22S2tI055at3tf5h9Ydkml9VMFK10L5YuQhAp6lC3yt0zvv9au9+fE2mXz6fn9D
        OyZAMSmJ9rumg0aApRXQGIPYBdss2ta4nCobrcGWmw9i7ce9i+3xhPq/qqEU0ZED1qAFoZoJK8aMC
        QNfpSzdw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:59896 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lMcOu-003Fbj-P8; Wed, 17 Mar 2021 15:04:16 -0500
Subject: Re: [Intel-wired-lan] [PATCH][next] ixgbe: Fix out-of-bounds warning
 in ixgbe_host_interface_command()
To:     Jann Horn <jannh@google.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, linux-hardening@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210317064148.GA55123@embeddedor>
 <CAG48ez2RDqKwx=umOHjo_1mYyNQgzvcP=KOw1HgSo4Prs_VQDw@mail.gmail.com>
 <3bd8d009-2ad2-c24d-5c34-5970c52502de@embeddedor.com>
 <CAG48ez2jr_8MbY_sNXfwvs7WsF-5f9j=U4-66dTcgXd2msr39A@mail.gmail.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <03c013b8-4ddb-8e9f-af86-3c43cd746dbb@embeddedor.com>
Date:   Wed, 17 Mar 2021 14:04:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez2jr_8MbY_sNXfwvs7WsF-5f9j=U4-66dTcgXd2msr39A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lMcOu-003Fbj-P8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:59896
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/17/21 13:57, Jann Horn wrote:

>>>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
>>>> index 62ddb452f862..bff3dc1af702 100644
>>>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
>>>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
>>>> @@ -3679,7 +3679,7 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw *hw, void *buffer,
>>>>         u32 hdr_size = sizeof(struct ixgbe_hic_hdr);
>>>>         union {
>>>>                 struct ixgbe_hic_hdr hdr;
>>>> -               u32 u32arr[1];
>>>> +               u32 *u32arr;
>>>>         } *bp = buffer;
>>>>         u16 buf_len, dword_len;
>>>>         s32 status;
>>>
>>> This looks bogus. An array is inline, a pointer points elsewhere -
>>> they're not interchangeable.
>>
>> Yep; but in this case these are the only places in the code where _u32arr_ is
>> being used:
>>
>> 3707         /* first pull in the header so we know the buffer length */
>> 3708         for (bi = 0; bi < dword_len; bi++) {
>> 3709                 bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
>> 3710                 le32_to_cpus(&bp->u32arr[bi]);
>> 3711         }
> 
> So now line 3709 means: Read a pointer from bp->u32arr (the value
> being read from there is not actually a valid pointer), and write to
> that pointer at offset `bi`. I don't see how that line could execute
> without crashing.

Yeah; you're right. I see my confusion now. Apparently, there is no escape
from allocating heap memory to fix this issue, as I was proposing in my
last email.

I really appreciate the feedback. Thanks!
--
Gustavo
