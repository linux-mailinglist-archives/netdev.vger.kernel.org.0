Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E93A57689B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 22:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiGOU6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 16:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGOU6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 16:58:46 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F6AB4BE
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 13:58:44 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220715205842euoutp0122d0f959fdfd400a89d10dc9364b4c15~CHEtXeQt-0710707107euoutp01W
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 20:58:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220715205842euoutp0122d0f959fdfd400a89d10dc9364b4c15~CHEtXeQt-0710707107euoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657918722;
        bh=YdgssgFBnCZJ4RfHC/0Rqp9j5dq+QVaDjQrDJ32E+Aw=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=iHiijxlNMCAkzWFPlsOeGtTrmZoeir+ISQTmZgS+OHKLHQ1ByxxkmY1uX6Vqn/QzV
         3rTSmN6lftUUCaHmD+by+ZcssCIeaWRSS0+vArqVcm+FD0GePXYFSClByI8pte9n/8
         7KcMiRdGJd4EjPvTSkTopXO5lCy5smdEaNkwQgMQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220715205841eucas1p2cf1272ffed50003dd40a950cc0eb0d96~CHEsRhxp20633006330eucas1p2V;
        Fri, 15 Jul 2022 20:58:41 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 73.BD.09664.105D1D26; Fri, 15
        Jul 2022 21:58:41 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220715205841eucas1p20140585c17ed9d06d3af208434f41e00~CHEr7cy4c2872928729eucas1p2p;
        Fri, 15 Jul 2022 20:58:41 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220715205841eusmtrp25937899640b4f31f8dffd5913c4b2a81~CHEr6uxBw1051010510eusmtrp2h;
        Fri, 15 Jul 2022 20:58:41 +0000 (GMT)
X-AuditID: cbfec7f2-d81ff700000025c0-ca-62d1d501779d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 6F.00.09095.105D1D26; Fri, 15
        Jul 2022 21:58:41 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220715205840eusmtip2e419d064ad4cbcc025cace366001d76d~CHErKgYeL0959709597eusmtip2F;
        Fri, 15 Jul 2022 20:58:40 +0000 (GMT)
Message-ID: <b9e1e22a-47ba-fdd8-ca12-e9bdd57afd41@samsung.com>
Date:   Fri, 15 Jul 2022 22:58:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH v3 for-next 2/3] net: copy from user before calling
 __get_compat_msghdr
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org, Kernel-team@fb.com
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <b2e36f7b-2f99-d686-3726-c18b32289ed8@kernel.dk>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsWy7djPc7qMVy8mGVyYIGUxZ9U2RovVd/vZ
        LOacb2GxmPrHw+LpsUfsFu9az7FYHOt7z2pxYVsfq8WxBWIW306/YXTg8tiy8iaTx8Tmd+we
        O2fdZfdYsKnU4/LZUo9NqzrZPN7vu8rm8XmTXABHFJdNSmpOZllqkb5dAlfGnpO72Qu2ilZ0
        z97A3sC4WbCLkZNDQsBE4v+7s6xdjFwcQgIrGCVeLb7KBuF8YZT4sXMHI4TzmVGi+9tddpiW
        1V+/s0MkljNK3Lp0AKrlI6PEsuPLGUGqeAXsJJa/mQpkc3CwCKhKTLhgBREWlDg58wkLiC0q
        kCxx7izIOk4OYYFYic55/8EWMAuIS9x6Mp8JZKaIwBVGiRsnfzFCJPQkVnS8BmtgEzCU6Hrb
        BWZzCthKzFr2DKpZXmL72znMIM0SAs2cEk1rZjFDnO0i8W73BzYIW1ji1fEtUO/ISPzfCbKN
        A8jOl/g7wxgiXCFx7fUaqFZriTvnfrGBlDALaEqs36UPEXaUWL3zPBtEJ5/EjbeCEBfwSUza
        Np0ZIswr0dEmBFGtJjHr+Dq4nQcvXGKewKg0CylQZiF5fhaSX2Yh7F3AyLKKUTy1tDg3PbXY
        MC+1XK84Mbe4NC9dLzk/dxMjMGmd/nf80w7Gua8+6h1iZOJgPMQowcGsJMLbfehckhBvSmJl
        VWpRfnxRaU5q8SFGaQ4WJXHe5MwNiUIC6YklqdmpqQWpRTBZJg5OqQamKr2TF5sfdpe+/s90
        80tZ6/4ZOj9vWn53WRq98c/pyxrBcvkMyxLvFJS+Wv7Rjdl8dVpZ4hF2HxvmD7mmjm73xMtm
        b1nYJ3424/XGr0JSyboxDL/09lpyn8mY+qox4I2izdpNR7lmeu5i+/BPyWF/rNz+pIvbGafo
        i3kKqngxaItPUpnMsMCzxEXwjEOO1i/h9Rr387w79vlw6v4UuPhpu0XFk+XWSxgfS77euf7e
        4uRCZYYLQYyOT3fel1YISTkTzKZQY2O7daZ/jVTC5FK7xPKCeb/04sNCdjtfylC83fDk7LOF
        y2RLdoixrLTOmirQO63wP8OFI4tTK2Y+1Vnz8LFUxIovgSsmXjG+mZKkxFKckWioxVxUnAgA
        zzg+wMkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t/xe7qMVy8mGbxYzGIxZ9U2RovVd/vZ
        LOacb2GxmPrHw+LpsUfsFu9az7FYHOt7z2pxYVsfq8WxBWIW306/YXTg8tiy8iaTx8Tmd+we
        O2fdZfdYsKnU4/LZUo9NqzrZPN7vu8rm8XmTXABHlJ5NUX5pSapCRn5xia1StKGFkZ6hpYWe
        kYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl7GnpO72Qu2ilZ0z97A3sC4WbCLkZNDQsBEYvXX
        7+xdjFwcQgJLGSVuPD7HCJGQkTg5rYEVwhaW+HOtiw2i6D2jxIVpTewgCV4BO4nlb6YCNXBw
        sAioSky4YAURFpQ4OfMJC4gtKpAs0bzlEBOILSwQK9E57z9YK7OAuMStJ/PB4iIC1xglfm/z
        gYjrSazoeA21azaTxMNF+8EGsQkYSnS9BTmCk4NTwFZi1rJnUIPMJLq2djFC2PIS29/OYZ7A
        KDQLyR2zkOybhaRlFpKWBYwsqxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQIjdduxn5t3MM57
        9VHvECMTB+MhRgkOZiUR3u5D55KEeFMSK6tSi/Lji0pzUosPMZoCw2Iis5Rocj4wVeSVxBua
        GZgamphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTBNWbMk6MRFtxjryzzyksGG
        BcFXvHeu16idrqSxyE79QbZb8DM1Dp7weXxeW52eXjIo59q44W7PF+M7IfOjXQw+2960q1W6
        pLXsdN2/jpy5JheqNI18jkz55hrfca3qy+qXk/oanX4xlYQcteP3/qHVtyw3eLYQm5fZHlt+
        zgOpLvtSDv5i+Lb6sGKXxAeFyYcvZDc8LJxcxbXozXl3tmWff6ieFwhI+MVjuO7GTJvNr5iv
        9khs5vSrMPpxRHvK0mXHj4opZFo41J0/G8sjuT12okOsgO/pHt3l5qkP+fmn9nIt4d274OSt
        mSuO5fvvn+WplLM9vOni/ZC+xT3le2zXrYk8suGRtJnnlMnxoj5KLMUZiYZazEXFiQBQ36SU
        XQMAAA==
X-CMS-MailID: 20220715205841eucas1p20140585c17ed9d06d3af208434f41e00
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220715202859eucas1p1a336fd34a883adb96bde608ba2ca3a12
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220715202859eucas1p1a336fd34a883adb96bde608ba2ca3a12
References: <20220714110258.1336200-1-dylany@fb.com>
        <20220714110258.1336200-3-dylany@fb.com>
        <CGME20220715202859eucas1p1a336fd34a883adb96bde608ba2ca3a12@eucas1p1.samsung.com>
        <46439555-644d-08a1-7d66-16f8f9a320f0@samsung.com>
        <b2e36f7b-2f99-d686-3726-c18b32289ed8@kernel.dk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 15.07.2022 22:37, Jens Axboe wrote:
> On 7/15/22 2:28 PM, Marek Szyprowski wrote:
>> On 14.07.2022 13:02, Dylan Yudaken wrote:
>>> this is in preparation for multishot receive from io_uring, where it needs
>>> to have access to the original struct user_msghdr.
>>>
>>> functionally this should be a no-op.
>>>
>>> Acked-by: Paolo Abeni <pabeni@redhat.com>
>>> Signed-off-by: Dylan Yudaken <dylany@fb.com>
>> This patch landed in linux next-20220715 as commit 1a3e4e94a1b9 ("net:
>> copy from user before calling __get_compat_msghdr"). Unfortunately it
>> causes a serious regression on the ARM64 based Khadas VIM3l board:
>>
>> Unable to handle kernel access to user memory outside uaccess routines
>> at virtual address 00000000ffc4a5c8
>> Mem abort info:
>>     ESR = 0x000000009600000f
>>     EC = 0x25: DABT (current EL), IL = 32 bits
>>     SET = 0, FnV = 0
>>     EA = 0, S1PTW = 0
>>     FSC = 0x0f: level 3 permission fault
>> Data abort info:
>>     ISV = 0, ISS = 0x0000000f
>>     CM = 0, WnR = 0
>> user pgtable: 4k pages, 48-bit VAs, pgdp=0000000001909000
>> [00000000ffc4a5c8] pgd=0800000001a7b003, p4d=0800000001a7b003,
>> pud=0800000001a0e003, pmd=0800000001913003, pte=00e800000b9baf43
>> Internal error: Oops: 9600000f [#1] PREEMPT SMP
>> Modules linked in:
>> CPU: 0 PID: 247 Comm: systemd-udevd Not tainted 5.19.0-rc6+ #12437
>> Hardware name: Khadas VIM3L (DT)
>> pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : get_compat_msghdr+0xd0/0x1b0
>> lr : get_compat_msghdr+0xcc/0x1b0
>> ...
>> Call trace:
>>    get_compat_msghdr+0xd0/0x1b0
>>    ___sys_sendmsg+0xd0/0xe0
>>    __sys_sendmsg+0x68/0xc4
>>    __arm64_compat_sys_sendmsg+0x28/0x3c
>>    invoke_syscall+0x48/0x114
>>    el0_svc_common.constprop.0+0x60/0x11c
>>    do_el0_svc_compat+0x1c/0x50
>>    el0_svc_compat+0x58/0x100
>>    el0t_32_sync_handler+0x90/0x140
>>    el0t_32_sync+0x190/0x194
>> Code: d2800382 9100f3e0 97d9be02 b5fffd60 (b9401a60)
>> ---[ end trace 0000000000000000 ]---
>>
>> This happens only on the mentioned board, other my ARM64 test boards
>> boot fine with next-20220715. Reverting this commit, together with
>> 2b0b67d55f13 ("fix up for "io_uring: support multishot in recvmsg"") and
>> a8b38c4ce724 ("io_uring: support multishot in recvmsg") due to compile
>> dependencies on top of next-20220715 fixes the issue.
>>
>> Let me know how I can help fixing this issue.
> How are you reproducing this?

This happens always during system boot on the mentioned board, when udev 
starts discovering devices. The complete boot log is here:

https://pastebin.com/i8WzFzcx

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

