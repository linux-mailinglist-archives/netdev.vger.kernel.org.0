Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633104B994E
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 07:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbiBQGfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 01:35:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234157AbiBQGfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 01:35:50 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54F32A520E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 22:35:33 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220217063531euoutp0247e88f609b4f63e360fa258006027393~Uf0zGri8N1547815478euoutp028
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:35:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220217063531euoutp0247e88f609b4f63e360fa258006027393~Uf0zGri8N1547815478euoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1645079731;
        bh=ipigtSfsdAFXwgz+IWoVQ6UbZqrjrxN9zsqe1ZCW+7Y=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=jiclKU0ISMlELwlbTYZpCVXhNQeYt0dR8R49fSqYF3dfZ7vS+mWbJa47E7cNW20no
         8iq8gDu2Oo1lyTidhmh/QBIjyPgFh2905m2xqqwRnuajwGUlA77AahEQXRtXs5F2Co
         u2jGzdJVf89sGNyi4XD82/5eyCp4ri8Z3aIC+QcQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220217063531eucas1p18202ba68c1afd44b1fa5d794b8cded4e~Uf0ytV6mV2722727227eucas1p1K;
        Thu, 17 Feb 2022 06:35:31 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id A7.4C.09887.3BCED026; Thu, 17
        Feb 2022 06:35:31 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220217063530eucas1p21b749650bd4fd25a77b144f00039d1c9~Uf0yUhdiZ2710527105eucas1p2l;
        Thu, 17 Feb 2022 06:35:30 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220217063530eusmtrp2db2c8d8469dce7a199c83341a914e613~Uf0yTq4aW2347823478eusmtrp2M;
        Thu, 17 Feb 2022 06:35:30 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-a6-620decb30559
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 95.18.09522.2BCED026; Thu, 17
        Feb 2022 06:35:30 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220217063529eusmtip2509e915705d4a3f7c44776937700239e~Uf0xiOml63108531085eusmtip2B;
        Thu, 17 Feb 2022 06:35:29 +0000 (GMT)
Message-ID: <ce67e9c9-966e-3a08-e571-b7f1dacb3814@samsung.com>
Date:   Thu, 17 Feb 2022 07:35:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net: Correct wrong BH disable in
 hard-interrupt.
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rg?= =?UTF-8?Q?ensen?= 
        <toke@toke.dk>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@redhat.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <Yg05duINKBqvnxUc@linutronix.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsWy7djP87qb3/AmGRzYwmrx5edtdotpFycx
        W3w+cpzNYvHCb8wWc863sFg8PfaI3WJP+3Zmi6YdK5gsLmzrY7U4tkDMYvOmqcwWlw4/YrHY
        +n4FuwOvx5aVN5k8ds66y+6xYFOpR9eNS8wem1Z1snm8O3eO3eP9vqtsHlsOXWTz+LxJLoAz
        issmJTUnsyy1SN8ugSuj5epm9oL9QhVXl95gb2B8ydfFyMkhIWAi8WvqT/YuRi4OIYEVjBJP
        55xjhnC+MEosOPoFyvnMKLHs62FGmJbLF6ZDJZYzSjz7epcRwvnIKDG7q4kFpIpXwE6i4fh9
        JhCbRUBVov/RPkaIuKDEyZlPgGo4OEQFkiQWbXMHCQsLBEgcmjmJDcRmFhCXuPVkPliriICp
        ROPFQywg85kFOlkkLtw7wAqSYBMwlOh628UGModTQFdiww4ViF55ie1v5zBDHLqcU+Lw9hqQ
        EgkBF4k5a1kgwsISr45vYYewZST+7wRZxQVkNzNKPDy3lh3C6WGUuNw0A+pja4k7536B7WIW
        0JRYv0sfIuwo8Wd1MzPEfD6JG28FIU7gk5i0bTpUmFeio00IolpNYtbxdXBrD164xDyBUWkW
        UpjMQvL8LCTPzELYu4CRZRWjeGppcW56arFRXmq5XnFibnFpXrpecn7uJkZggjv97/iXHYzL
        X33UO8TIxMF4iFGCg1lJhPfDQd4kId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzJmRsShQTSE0tS
        s1NTC1KLYLJMHJxSDUwZcU35rrqn/gTNdNM41CnUWFl57eOBf3U9PfN/mETmtat+KeqeoNGj
        VqY7ySDj9Dnd3l8RHuLz9/9OrpO/Yrd5zdR/lt/fShbO+NDQsLB/SXGobuzC/X/TjiwoaVl+
        I4z1/4I95R90UhSEt23z8T51Mr2q/rVNaERvwI6aHWZl+rEJHpcU1y7YKMjxf+UlV9m7ry4v
        3se/hNeVpeTkYdPNojsfeEmX5Uk+j+pXOKJ9o77teVqH6bdlQpMN4sXPOoZeSfm+3THq5cMl
        Yd4TL4WEP1ac9OdL4XOPPw+q4oRyLmdfrywvNrc5Yvck2e7WycrOzFOvwqe+ei/F9E7FLbgy
        d4tIdtPLY292n/Px/a7EUpyRaKjFXFScCAAz9Ge53wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t/xe7qb3vAmGSy+p2Lx5edtdotpFycx
        W3w+cpzNYvHCb8wWc863sFg8PfaI3WJP+3Zmi6YdK5gsLmzrY7U4tkDMYvOmqcwWlw4/YrHY
        +n4FuwOvx5aVN5k8ds66y+6xYFOpR9eNS8wem1Z1snm8O3eO3eP9vqtsHlsOXWTz+LxJLoAz
        Ss+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1SN8uQS+j5epm
        9oL9QhVXl95gb2B8ydfFyMkhIWAicfnCdOYuRi4OIYGljBITz0xjhkjISJyc1sAKYQtL/LnW
        xQZR9J5RYtaNe+wgCV4BO4mG4/eZQGwWAVWJ/kf7GCHighInZz5hAbFFBZIk1k2fDzZUWMBP
        4tvzM2A1zALiEreezAfrFREwlWi8eIgFZAGzQC+LRPOtdSwQ2xoYJU7c6AXrZhMwlOh6C3IG
        BwengK7Ehh0qEIPMJLq2dkENlZfY/nYO8wRGoVlI7piFZN8sJC2zkLQsYGRZxSiSWlqcm55b
        bKhXnJhbXJqXrpecn7uJERjX24793LyDcd6rj3qHGJk4GA8xSnAwK4nwfjjImyTEm5JYWZVa
        lB9fVJqTWnyI0RQYGBOZpUST84GJJa8k3tDMwNTQxMzSwNTSzFhJnNezoCNRSCA9sSQ1OzW1
        ILUIpo+Jg1OqgUkwTFftgdXHt3s2XjGf4bPl/bKmLbsdXglt9c03038mEpQ2d7Nm9rQr3c/3
        F797WhGw3UGvaCpf7JNNdxOlXY5MtDS9vrbzQbjgN+/jZov0fObfvPhwbazUDhnXH/Gm03+9
        dV37nk0kzqjsWbm77Gvzc6I7jTm1QhSdZcq4tLhv1sxzE/TU/80275vD8/BZr97E81R3P74p
        VnBZXOeA1NHbpyoYw8s/bzr4tHXZ+b96IVam8Y++yMotubz51sxpMg93qLpkZOguS3m89EqQ
        uPkXV8P1mt4OOwL3HDzlarSp7I1VZ0WXdu4y3w+zJzH/UF8Yv8fnQdLEr5Z7FDXflzjJZIdn
        LDu2YmfqTIuNMtJKLMUZiYZazEXFiQDXbND8dAMAAA==
X-CMS-MailID: 20220217063530eucas1p21b749650bd4fd25a77b144f00039d1c9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08
References: <CGME20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08@eucas1p2.samsung.com>
        <Yg05duINKBqvnxUc@linutronix.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

On 16.02.2022 18:50, Sebastian Andrzej Siewior wrote:
> I missed the obvious case where netif_ix() is invoked from hard-IRQ
> context.
>
> Disabling bottom halves is only needed in process context. This ensures
> that the code remains on the current CPU and that the soft-interrupts
> are processed at local_bh_enable() time.
> In hard- and soft-interrupt context this is already the case and the
> soft-interrupts will be processed once the context is left (at irq-exit
> time).
>
> Disable bottom halves if neither hard-interrupts nor soft-interrupts are
> disabled. Update the kernel-doc, mention that interrupts must be enabled
> if invoked from process context.
>
> Fixes: baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> Marek, does this work for you?

Yes, this fixed the issue. Thanks!

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

>   net/core/dev.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 909fb38159108..87729491460fc 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4860,7 +4860,9 @@ EXPORT_SYMBOL(__netif_rx);
>    *	congestion control or by the protocol layers.
>    *	The network buffer is passed via the backlog NAPI device. Modern NIC
>    *	driver should use NAPI and GRO.
> - *	This function can used from any context.
> + *	This function can used from interrupt and from process context. The
> + *	caller from process context must not disable interrupts before invoking
> + *	this function.
>    *
>    *	return values:
>    *	NET_RX_SUCCESS	(no congestion)
> @@ -4870,12 +4872,15 @@ EXPORT_SYMBOL(__netif_rx);
>   int netif_rx(struct sk_buff *skb)
>   {
>   	int ret;
> +	bool need_bh_off = !(hardirq_count() | softirq_count());
>   
> -	local_bh_disable();
> +	if (need_bh_off)
> +		local_bh_disable();
>   	trace_netif_rx_entry(skb);
>   	ret = netif_rx_internal(skb);
>   	trace_netif_rx_exit(ret);
> -	local_bh_enable();
> +	if (need_bh_off)
> +		local_bh_enable();
>   	return ret;
>   }
>   EXPORT_SYMBOL(netif_rx);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

