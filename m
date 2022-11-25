Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D744638779
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiKYKZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiKYKZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:25:18 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C745F209AE;
        Fri, 25 Nov 2022 02:25:17 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NJWBF3vkKzJnw0;
        Fri, 25 Nov 2022 18:21:57 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 18:25:14 +0800
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
To:     Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <patches@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, <shuah@kernel.org>,
        <patches@kernelci.org>, <lkft-triage@lists.linaro.org>,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        <srw@sladewatkins.net>, <rwarsow@gmx.de>,
        Netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
References: <20221123084557.945845710@linuxfoundation.org>
 <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
 <CA+G9fYvgaNKbr_EhWsh9hjnzCeVXGJoXX4to72ytdvZi8W0svA@mail.gmail.com>
 <Y4BuUU5yMI6PqCbb@kroah.com>
 <CA+G9fYsXomPXcecPDzDydO3=i2qHDM2RTtGxr0p2YOS6=YcWng@mail.gmail.com>
 <a1652617-9da5-4a29-9711-9d3b3cf66597@app.fastmail.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <23b0fa9c-d041-8c56-ec4b-04991fa340d4@huawei.com>
Date:   Fri, 25 Nov 2022 18:25:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <a1652617-9da5-4a29-9711-9d3b3cf66597@app.fastmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/25 18:02, Arnd Bergmann wrote:
> On Fri, Nov 25, 2022, at 09:05, Naresh Kamboju wrote:
>> On Fri, 25 Nov 2022 at 12:57, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>> On Thu, Nov 24, 2022 at 09:17:36PM +0530, Naresh Kamboju wrote:
>>>>
>>>> Daniel bisected this reported problem and found the first bad commit,
>>>>
>>>> YueHaibing <yuehaibing@huawei.com>
>>>>     net: broadcom: Fix BCMGENET Kconfig
>>>
>>> But that is in 5.10.155, 5.15.79, 6.0.9, and 6.1-rc5.  It is not new to
>>> this -rc release.
>>
>> It started from 5.10.155 and this is only seen on 5.10 and other
>> branches 5.15, 6.0 and mainline are looking good.
> 
> I think the original patch is wrong and should be fixed upstream.
> The backported patch in question is a one-line Kconfig change doing

It seems lts 5.10 do not contain commit e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies"),
there is not PTP_1588_CLOCK_OPTIONAL option.

> 
> diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
> index f4e1ca68d831..55dfdb34e37b 100644
> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -77,7 +77,7 @@ config BCMGENET
>         select BCM7XXX_PHY
>         select MDIO_BCM_UNIMAC
>         select DIMLIB
> -       select BROADCOM_PHY if ARCH_BCM2835
> +       select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
>         help
>           This driver supports the built-in Ethernet MACs found in the
>           Broadcom BCM7xxx Set Top Box family chipset.
> 
> which fixes the build on kernels that contain 99addbe31f55 ("net:
> broadcom: Select BROADCOM_PHY for BCMGENET") and enable
> BCMGENET=y but PTP_1588_CLOCK_OPTIONAL=m, which otherwise
> leads to a link failure.
> 
> The patch unfortunately solves it by replacing it with a runtime
> failure by no longer linking in the PHY driver (as found by Naresh).
> 
> I think the correct fix would be to propagate the dependency down
> to BCMGENET:
> 
> diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
> index f4e1ca68d831..f4ca0c6c0f51 100644
> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -71,6 +71,7 @@ config BCM63XX_ENET
>  config BCMGENET
>  	tristate "Broadcom GENET internal MAC support"
>  	depends on HAS_IOMEM
> +	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
>  	select MII
>  	select PHYLIB
>  	select FIXED_PHY
> 
> With this change, the broken config is no longer possible, instead
> forcing BCMGENET to be =m when building for ARCH_BCM2835 with
> PTP_1588_CLOCK=m.
> 
>      Arnd
> .
> 
