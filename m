Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87B840A1CF
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 02:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236521AbhINAT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 20:19:29 -0400
Received: from prt-mail.chinatelecom.cn ([42.123.76.222]:37770 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229482AbhINAT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 20:19:28 -0400
HMM_SOURCE_IP: 172.18.0.218:47798.281646273
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.87.95.153 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 9D2542800AF;
        Tue, 14 Sep 2021 08:17:56 +0800 (CST)
X-189-SAVE-TO-SEND: zhenggy@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 23f18b7698bb4a238727e0331becb224 for liyonglong@chinatelecom.cn;
        Tue, 14 Sep 2021 08:18:08 CST
X-Transaction-ID: 23f18b7698bb4a238727e0331becb224
X-Real-From: zhenggy@chinatelecom.cn
X-Receive-IP: 172.18.0.218
Sender: zhenggy@chinatelecom.cn
Subject: Re: [PATCH v3] tcp: fix tp->undo_retrans accounting in
 tcp_sacktag_one()
To:     Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, qitiepeng@chinatelecom.cn,
        wujianguo@chinatelecom.cn, liyonglong@chinatelecom.cn
References: <1630314010-15792-1-git-send-email-zhenggy@chinatelecom.cn>
 <CANn89iLMDQqVmhq38OhD3X1D93qzAye0AsQpZYdCi=fsLEuNsg@mail.gmail.com>
 <CAK6E8=fDRvd_qezt+Nxiru+aYH=aLFhSuYFQsZMHmzsKS2WWZg@mail.gmail.com>
 <CADVnQymAseByviwpgikUyZqOmvqvEVsRXiD-aHVFCnoPn4TrMQ@mail.gmail.com>
From:   zhenggy <zhenggy@chinatelecom.cn>
Message-ID: <bf17406d-d9c1-f6e7-add9-73a099e6158b@chinatelecom.cn>
Date:   Tue, 14 Sep 2021 08:17:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CADVnQymAseByviwpgikUyZqOmvqvEVsRXiD-aHVFCnoPn4TrMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks very much for all your comments, i will repost a v4 patch later.

在 2021/9/14 0:27, Neal Cardwell 写道:
> On Mon, Sep 13, 2021 at 12:11 PM Yuchung Cheng <ycheng@google.com> wrote:
>>
>> On Mon, Sep 13, 2021 at 8:49 AM Eric Dumazet <edumazet@google.com> wrote:
>>>
>>> On Mon, Sep 13, 2021 at 3:51 AM zhenggy <zhenggy@chinatelecom.cn> wrote:
>>>>
>>>> Commit 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit
>>>> time") may directly retrans a multiple segments TSO/GSO packet without
>>>> split, Since this commit, we can no longer assume that a retransmitted
>>>> packet is a single segment.
>>>>
>>>> This patch fixes the tp->undo_retrans accounting in tcp_sacktag_one()
>>>> that use the actual segments(pcount) of the retransmitted packet.
>>>>
>>>> Before that commit (10d3be569243), the assumption underlying the
>>>> tp->undo_retrans-- seems correct.
>>>>
>>>> Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
>>>>
>>>
>>> nit: We normally do not add an empty line between Fixes: tag and others.
>>>
>>> Reviewed-by: Eric Dumazet <edumazet@google.com>
>> Acked-by: Yuchung Cheng <ycheng@google.com>
>>
>> This is a nice fix that would increase the effectiveness of TCP undo
>> in high-speed networks.
> 
> Yes, thanks for the fix!
> 
> Acked-by: Neal Cardwell <ncardwell@google.com>
> 
> neal
> 
