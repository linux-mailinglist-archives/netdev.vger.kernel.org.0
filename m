Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D324139D27C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 03:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhFGBHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 21:07:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3075 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhFGBHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 21:07:13 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fyw5q5BCQzWrjT;
        Mon,  7 Jun 2021 09:00:31 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 09:05:09 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 09:05:08 +0800
Subject: Re: [PATCH net-next v2] net: gemini: Use
 devm_platform_get_and_ioremap_resource()
To:     Linus Walleij <linus.walleij@linaro.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210605123636.2485041-1-yangyingliang@huawei.com>
 <CACRpkdZi-W-vnCH05C4CkQdnYtUKuD4NWoBTh8hGXmok_=Dsfw@mail.gmail.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <da671768-64b8-e658-20bb-c536df8c1aae@huawei.com>
Date:   Mon, 7 Jun 2021 09:05:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CACRpkdZi-W-vnCH05C4CkQdnYtUKuD4NWoBTh8hGXmok_=Dsfw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2021/6/5 23:17, Linus Walleij wrote:
> On Sat, Jun 5, 2021 at 2:32 PM Yang Yingliang <yangyingliang@huawei.com> wrote:
>
>> Use devm_platform_get_and_ioremap_resource() to simplify
>> code.
>>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> (...)
>> -       dmares = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -       gmacres = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> Should you not also delete the local variables
> dmares and gmacres? I doubt they are used
> after this.
They are used to print message before returning gemini_ethernet_port_probe()
static int gemini_ethernet_port_probe(struct platform_device *pdev)
{
[...]
         netdev_info(netdev,
                     "irq %d, DMA @ 0x%pap, GMAC @ 0x%pap\n",
                     port->irq, &dmares->start,
                     &gmacres->start);
         return 0;

unprepare:
         clk_disable_unprepare(port->pclk);
         return ret;
}

Thanks,
Yang
>
> Yours,
> Linus Walleij
> .
