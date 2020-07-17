Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AB92245C3
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 23:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgGQVRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 17:17:08 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53608 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQVRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 17:17:07 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200717211706euoutp017c1687ad4db9fe77524f670e8d42693c~ips8AYLFz0365103651euoutp01R
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 21:17:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200717211706euoutp017c1687ad4db9fe77524f670e8d42693c~ips8AYLFz0365103651euoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595020626;
        bh=axk5IGxg5wek4PUHhF+mZ0GxOxaDbbeSaF7m89FMM/Y=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=vTt6/yYcpOGISIpIaSKHYxyn4v1TsX6lIxpE3+MmvU7M/o39R4/mrGHi8Qp/KXHWq
         4RjDRRVmnCR5NLwJI6sBOMVgJ68sQctfSGSdSg8M7eDw2tjXXeBYA548MMqbRtPeMd
         7max5wOIt1q4jd5XsjS0gIVMW872y/RDLsryD2yA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200717211705eucas1p1d26ce42722ffbd8451137ce3c30ca3b3~ips7ddgjD0501605016eucas1p1I;
        Fri, 17 Jul 2020 21:17:05 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id B1.72.06456.155121F5; Fri, 17
        Jul 2020 22:17:05 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200717211704eucas1p2192d6f38ba11691eff214a84cd3d4489~ips61H8xj0259702597eucas1p2U;
        Fri, 17 Jul 2020 21:17:04 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200717211704eusmtrp1bc3f2dd68a6218ae5e80f4c504a3a939~ips60clzQ3040830408eusmtrp1b;
        Fri, 17 Jul 2020 21:17:04 +0000 (GMT)
X-AuditID: cbfec7f2-809ff70000001938-47-5f121551d02f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 20.26.06314.055121F5; Fri, 17
        Jul 2020 22:17:04 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200717211704eusmtip25a9e83df205beba37224ad4211f71361~ips6UKHBJ0374603746eusmtip2H;
        Fri, 17 Jul 2020 21:17:04 +0000 (GMT)
Subject: Re: [PATCH] net: genetlink: Move initialization to core_initcall
To:     Daniel Lezcano <daniel.lezcano@linaro.org>, davem@davemloft.net
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <d67a4204-49c2-0184-b6fe-44d81dc4c129@samsung.com>
Date:   Fri, 17 Jul 2020 23:17:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715074120.8768-1-daniel.lezcano@linaro.org>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsWy7djP87qBokLxBqfniVnM+yxrMed8C4vF
        nBdlFo9WzGK3uLCtj9Xi8q45bBZfnh9ntji2QMxi1YYuRgdOjy0rbzJ57Jx1l91j8Z6XTB6b
        VnWyedy5tofN49n0w0weZxYcYff4vEkugCOKyyYlNSezLLVI3y6BK2Ppkd1MBQ8FKhp2/GJp
        YLzK28XIySEhYCIx9/Ifti5GLg4hgRWMEtt3fGKEcL4wSvSsXg7lfGaUWL/jGDtMy/KGk0wQ
        ieWMEhM2HmKHcN4zSmxpO87axcjBISzgKfH1rTBIg4iAs8SEK99YQGxmgYVMEn1TwWw2AUOJ
        rrddbCA2r4CdxIXv78FaWQRUJXbPEgEJiwrESax/uZ0JokRQ4uTMJ2CtnEDly+c0sEGMlJfY
        /nYOM4QtLnHryXwmiDuvsUv8uBgCYbtITHx6H+p+YYlXx7dA2TISpyf3sICcLyHQzCjx8Nxa
        dginh1HictMMRogqa4k7536xgRzHLKApsX6XPkTYUWL9/x5mkLCEAJ/EjbeCEDfwSUzaNh0q
        zCvR0SYEUa0mMev4Ori1By9cYp7AqDQLyWezkHwzC8k3sxD2LmBkWcUonlpanJueWmyYl1qu
        V5yYW1yal66XnJ+7iRGYrE7/O/5pB+PXS0mHGAU4GJV4eDvWCMYLsSaWFVfmHmKU4GBWEuF1
        Ons6Tog3JbGyKrUoP76oNCe1+BCjNAeLkjiv8aKXsUIC6YklqdmpqQWpRTBZJg5OqQbGxds6
        jLUK372Rdjm15Apr1qt7Hdf9vfuk5z57fN3tUovMrCeu7PpOZw3aF/zTf7yW84IZa/DL29I/
        UnnTfqSsqxP57v96etzEOGk1oceTWMM4vTiTHnWt7w/RT3A/32+ed/9E6na38Lcs9QaCC9eH
        HP9fXXKI+eyrDbr+Xl7FZ8ufi6TvPp6pxFKckWioxVxUnAgAzNjrqFIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t/xe7oBokLxBns6tCzmfZa1mHO+hcVi
        zosyi0crZrFbXNjWx2pxedccNosvz48zWxxbIGaxakMXowOnx5aVN5k8ds66y+6xeM9LJo9N
        qzrZPO5c28Pm8Wz6YSaPMwuOsHt83iQXwBGlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqln
        aGwea2VkqqRvZ5OSmpNZllqkb5egl7H0yG6mgocCFQ07frE0MF7l7WLk5JAQMJFY3nCSqYuR
        i0NIYCmjxKGzDWwQCRmJk9MaWCFsYYk/17rYIIreMkrc37aDsYuRg0NYwFPi61thkBoRAWeJ
        CVe+sYDUMAssZpL4vWw5E0hCSMBW4tW234wgNpuAoUTX2y6wBbwCdhIXvr9nBZnDIqAqsXuW
        CEhYVCBOYvmW+ewQJYISJ2c+YQGxOYHKl8+BuI1ZwExi3uaHzBC2vMT2t3OgbHGJW0/mM01g
        FJqFpH0WkpZZSFpmIWlZwMiyilEktbQ4Nz232FCvODG3uDQvXS85P3cTIzA+tx37uXkH46WN
        wYcYBTgYlXh4O9YIxguxJpYVV+YeYpTgYFYS4XU6ezpOiDclsbIqtSg/vqg0J7X4EKMp0G8T
        maVEk/OBqSOvJN7Q1NDcwtLQ3Njc2MxCSZy3Q+BgjJBAemJJanZqakFqEUwfEwenVAOjZsfy
        lEN+6ozKLtfiH0/uLxSbsMt8mzPz1UlsXY4r7CdNvmn+T/5GFv9RaZPPTt9zXHNEc3+tj/7F
        9/zLD+8O2Q+XxTf0e6llygnX1RRfDNZaXG329uGbKueX2254XzdkPdwrymT5XG/Ou3bF3jCr
        pzGL5P4FqJd/Wfnk54WcRRdSj0u/u5ukxFKckWioxVxUnAgACZn2luUCAAA=
X-CMS-MailID: 20200717211704eucas1p2192d6f38ba11691eff214a84cd3d4489
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200717211704eucas1p2192d6f38ba11691eff214a84cd3d4489
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200717211704eucas1p2192d6f38ba11691eff214a84cd3d4489
References: <20200715074120.8768-1-daniel.lezcano@linaro.org>
        <CGME20200717211704eucas1p2192d6f38ba11691eff214a84cd3d4489@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 15.07.2020 09:41, Daniel Lezcano wrote:
> The generic netlink is initialized far after the netlink protocol
> itself at subsys_initcall. The devlink is initialized at the same
> level, but after, as shown by a disassembly of the vmlinux:
>
> [ ... ]
> 374 ffff8000115f22c0 <__initcall_devlink_init4>:
> 375 ffff8000115f22c4 <__initcall_genl_init4>:
> [ ... ]
>
> The function devlink_init() calls genl_register_family() before the
> generic netlink subsystem is initialized.
>
> As the generic netlink initcall level is set since 2005, it seems that
> was not a problem, but now we have the thermal framework initialized
> at the core_initcall level which creates the generic netlink family
> and sends a notification which leads to a subtle memory corruption
> only detectable when the CONFIG_INIT_ON_ALLOC_DEFAULT_ON option is set
> with the earlycon at init time.
>
> The thermal framework needs to be initialized early in order to begin
> the mitigation as soon as possible. Moving it to postcore_initcall is
> acceptable.
>
> This patch changes the initialization level for the generic netlink
> family to the core_initcall and comes after the netlink protocol
> initialization.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

I confirm, that this change together with the thermal subsystem initcall 
change fixes the issue observed in linux-next for the last few days.

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   net/netlink/genetlink.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 55ee680e9db1..36b8a1909826 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1263,7 +1263,7 @@ static int __init genl_init(void)
>   	panic("GENL: Cannot register controller: %d\n", err);
>   }
>   
> -subsys_initcall(genl_init);
> +core_initcall(genl_init);
>   
>   static int genlmsg_mcast(struct sk_buff *skb, u32 portid, unsigned long group,
>   			 gfp_t flags)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

