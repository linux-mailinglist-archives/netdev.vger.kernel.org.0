Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973FF4BD745
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 08:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345893AbiBUHHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 02:07:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345855AbiBUHHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 02:07:00 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D7B6244
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 23:06:33 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220221070624euoutp026ee7ee78ed008263283cc36259ed69e3~Vu06HI7HV3197531975euoutp02e
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 07:06:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220221070624euoutp026ee7ee78ed008263283cc36259ed69e3~Vu06HI7HV3197531975euoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1645427184;
        bh=0dH+tWf9bUEYBNi19OrTLWtCpcSKrJmFASt/PVSIL5c=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=ERxIMgNG11aaHmxtiKD1JEmFz8vDl1EdFVIEB+7Cbw2CRezo34SRU58qhzJqJHyJA
         Zo7rNjc64w9jFzFQ9jJ7XHHMMBiMUwNX81u/2BKh+3UhybxKp4dotYAJIFbRLUrbu9
         5MIruT0f+lSwHOCDxON9Jk11WvQDQSWxq7bQh+OA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220221070624eucas1p14fdd434ade459fa67b96ea5880d3e73c~Vu05w-wjv3227832278eucas1p1d;
        Mon, 21 Feb 2022 07:06:24 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id AE.2A.10009.2F933126; Mon, 21
        Feb 2022 07:06:26 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220221070624eucas1p1f57ff155fbfc8d41c315fcaf9dec2a12~Vu05Yt4Bp0574605746eucas1p1-;
        Mon, 21 Feb 2022 07:06:24 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220221070624eusmtrp18a084bb0bc33c08f7ca660e772c5fc95~Vu05XyQNu1904719047eusmtrp1M;
        Mon, 21 Feb 2022 07:06:24 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-c9-621339f29017
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id F5.D5.09404.2F933126; Mon, 21
        Feb 2022 07:06:26 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220221070623eusmtip1456d4f670842c2d0bf6597c92059a222~Vu04jx8__0702807028eusmtip1d;
        Mon, 21 Feb 2022 07:06:23 +0000 (GMT)
Message-ID: <37eade3b-ad3e-7f89-aae1-8376b8f9e172@samsung.com>
Date:   Mon, 21 Feb 2022 08:06:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH] usb: dwc3: gadget: Let the interrupt handler disable
 bottom halves.
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
        <toke@redhat.com>, Felipe Balbi <balbi@kernel.org>,
        linux-usb@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <Yg/YPejVQH3KkRVd@linutronix.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsWy7djPc7qfLIWTDG6+0rb48vM2u8Wxtifs
        FtMuTmK2+HzkOJvF4oXfmC3mnG9hsXh67BG7RfPi9WwWe9q3M1s07VjBZHFhWx+rxaJlrcwW
        xxaIWWzeNJXZ4tLhRywWW9+vYHcQ8Niy8iaTx85Zd9k9Fmwq9ei6cYnZY9OqTjaPd+fOsXvs
        n7uG3eP9vqtsHlsOXWTz+LxJLoArissmJTUnsyy1SN8ugSvjzaEt7AV/hSr2f5nC1MB4mb+L
        kZNDQsBEYuuKTSxdjFwcQgIrGCVezDoE5XxhlJiy4iyU85lR4ui7CywwLXdmtDFDJJYzSqz7
        uZYVJCEk8JFRYv/yJBCbV8BOYmdPKxOIzSKgKnF401FWiLigxMmZT4AGcXCICiRJLNrmDmIK
        C0RJPGq2B6lgFhCXuPVkPliniECGxK5lm5lAVjELHGeROLTgDtgNbAKGEl1vu9hAbE4BXYme
        c22MEM3yEtvfzgG7TULgMKfE36U/mSGOdpG4tG46G4QtLPHq+BZ2CFtG4vTkHhaIhmZGiYfn
        1rJDOD2MEpebZjBCVFlL3Dn3iw3kVGYBTYn1u/Qhwo4SbyfvZgYJSwjwSdx4KwhxBJ/EpG3T
        ocK8Eh1tQhDVahKzjq+DW3vwwiXmCYxKs5BCZRaS/2cheWcWwt4FjCyrGMVTS4tz01OLDfNS
        y/WKE3OLS/PS9ZLzczcxAlPh6X/HP+1gnPvqo94hRiYOxkOMEhzMSiK8d9iFk4R4UxIrq1KL
        8uOLSnNSiw8xSnOwKInzJmduSBQSSE8sSc1OTS1ILYLJMnFwSjUwyapax1ydzfU/tEzRPWZX
        xDoHi3S2PbsbXAv1xbQt2O4+WtPOe+NPqtBmrtMcObNePj2oHrPq3yfBBpdF1ztOzHu+y/bn
        hJm7rK+XZV5Uyy3t8YlctfKb23W5TRXXu4RtlKbvfiz477+Rc+PbOqbHoYt5VL/9XCyyVdPz
        XmV/oQ1vx0/XxEsc9W7b7iTmX65P+yehFnd2RmXzkvh3wv+8/EucYveeDP28ZJttw6EJXicn
        Pbi17kfWlD3TcuqPfJR4fNdwpwffnv2fQpaITfYTWLGlcMYa5ucnl99eYWnruzBxySblzeZv
        fdsiaud9WSUsx7Xw9tvtPPdPRmn/36bGmqUwPeEpm6V0Bv+k9ybOf5RYijMSDbWYi4oTAU6E
        ZTn0AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t/xu7qfLIWTDObPFrb48vM2u8Wxtifs
        FtMuTmK2+HzkOJvF4oXfmC3mnG9hsXh67BG7RfPi9WwWe9q3M1s07VjBZHFhWx+rxaJlrcwW
        xxaIWWzeNJXZ4tLhRywWW9+vYHcQ8Niy8iaTx85Zd9k9Fmwq9ei6cYnZY9OqTjaPd+fOsXvs
        n7uG3eP9vqtsHlsOXWTz+LxJLoArSs+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbK
        yFRJ384mJTUnsyy1SN8uQS/jzaEt7AV/hSr2f5nC1MB4mb+LkZNDQsBE4s6MNuYuRi4OIYGl
        jBJT1zezQyRkJE5Oa2CFsIUl/lzrYoMoes8osXDZSbAiXgE7iZ09rUwgNouAqsThTUdZIeKC
        EidnPmEBsUUFkiTWTZ8PtIGDQ1ggSuJRsz1ImFlAXOLWk/lgrSICGRKbt+9mAZnPLHCaReLL
        u+lQFzUwSnydvAWsik3AUKLrLcgVnBycAroSPefaGCEmmUl0be2CsuUltr+dwzyBUWgWkjtm
        IVk4C0nLLCQtCxhZVjGKpJYW56bnFhvpFSfmFpfmpesl5+duYgTG/7ZjP7fsYFz56qPeIUYm
        DsZDjBIczEoivHfYhZOEeFMSK6tSi/Lji0pzUosPMZoCA2Mis5Rocj4wAeWVxBuaGZgamphZ
        GphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTC5cQfz13A5JO2oeb30ohfjzumPO8p1
        G/slJh00jemeWOtyR1d2N0/Tieuens3Tlscei6m5Okt3tlD9Ub0juivqxKumVQemBN2KjFXy
        72esDPhbPt1RXUvW3GGe7J+f35anXXkkpvlR71HrkishMgp/i3NOrAlddPbq2VuXri1Z9KUz
        5/eV6WttDbrX8C3+vOyqo1zo9833RdZFPOBtEmG+P0f8ffoZ8QrXgzMPf1/OJ7Xmf/Tzogo2
        3fdL8+3eqwV0tLqsNJA9/OQYzylT6dPtz71NBc9y3IrcoOL1ZXfc/puaxS4vAx41/vANcmB9
        kzotqatza8y0iZNWHGmWipuV+adyXmFtHeeh9Dn37HqUWIozEg21mIuKEwGEAU0iiAMAAA==
X-CMS-MailID: 20220221070624eucas1p1f57ff155fbfc8d41c315fcaf9dec2a12
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220218173252eucas1p19c1191ede0e9b6af41e5f6bc6ac23fe5
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220218173252eucas1p19c1191ede0e9b6af41e5f6bc6ac23fe5
References: <CGME20220218173252eucas1p19c1191ede0e9b6af41e5f6bc6ac23fe5@eucas1p1.samsung.com>
        <Yg/YPejVQH3KkRVd@linutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18.02.2022 18:32, Sebastian Andrzej Siewior wrote:
> The interrupt service routine registered for the gadget is a primary
> handler which mask the interrupt source and a threaded handler which
> handles the source of the interrupt. Since the threaded handler is
> voluntary threaded, the IRQ-core does not disable bottom halves before
> invoke the handler like it does for the forced-threaded handler.
>
> Due to changes in networking it became visible that a network gadget's
> completions handler may schedule a softirq which remains unprocessed.
> The gadget's completion handler is usually invoked either in hard-IRQ or
> soft-IRQ context. In this context it is enough to just raise the softirq
> because the softirq itself will be handled once that context is left.
> In the case of the voluntary threaded handler, there is nothing that
> will process pending softirqs. Which means it remain queued until
> another random interrupt (on this CPU) fires and handles it on its exit
> path or another thread locks and unlocks a lock with the bh suffix.
> Worst case is that the CPU goes idle and the NOHZ complains about
> unhandled softirqs.
>
> Disable bottom halves before acquiring the lock (and disabling
> interrupts) and enable them after dropping the lock. This ensures that
> any pending softirqs will handled right away.
>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Link: https://lkml.kernel.org/r/c2a64979-73d1-2c22-e048-c275c9f81558@samsung.com
> Fixes: e5f68b4a3e7b0 ("Revert "usb: dwc3: gadget: remove unnecessary _irqsave()"")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   drivers/usb/dwc3/gadget.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 183b90923f51b..a0c883f19a417 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -4160,9 +4160,11 @@ static irqreturn_t dwc3_thread_interrupt(int irq, void *_evt)
>   	unsigned long flags;
>   	irqreturn_t ret = IRQ_NONE;
>   
> +	local_bh_disable();
>   	spin_lock_irqsave(&dwc->lock, flags);
>   	ret = dwc3_process_event_buf(evt);
>   	spin_unlock_irqrestore(&dwc->lock, flags);
> +	local_bh_enable();
>   
>   	return ret;
>   }

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

