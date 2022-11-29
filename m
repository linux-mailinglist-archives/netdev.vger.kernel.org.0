Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC3B63BF91
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 12:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiK2L7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 06:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiK2L65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 06:58:57 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EBC658C;
        Tue, 29 Nov 2022 03:58:56 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id AEF1C3200A06;
        Tue, 29 Nov 2022 06:58:54 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Tue, 29 Nov 2022 06:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1669723134; x=1669809534; bh=QeS5xMGkD4
        rRY6zWepk0K92JtGeum9CogY/Tq9dEfh8=; b=Pm0uGiEykoP05sMiaN6h4DRQBw
        iG+GHIPVl7IuuYL2pGQjSH2WulZv1NO3HZfZrn8HLgJapchmRYuNdz+SJ0f5Ojwn
        7Re4r3diK2Xzeibmq4XjWPOKcvDYw8pHaDk42xFdh3chGVFBXaGbT4Sm2oKCZDLt
        FWYDtcS+VVeJ1Vo0n6P8vNQYWPkJUho841ek/W7OHyjfyipZ0wsebo/b1hCk8pzT
        93GVbaNnC03OKndRXre3e3WM8aEth9RnYxCG7KQCohnE2GdXKnD7A/srZhBFEXXu
        ItIe4kTAyaJNL3aBz1VKndXB1psepp4U7CRtUWqOnuaC/k4luTjVW+EQPrvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669723134; x=1669809534; bh=QeS5xMGkD4rRY6zWepk0K92JtGeu
        m9CogY/Tq9dEfh8=; b=GcFy+Aysk+I2pXQhKEUUEpuumRby/pgJroMN/p1Dlglk
        7aZRCD97mKveGTOs2ZN8xSOwPMAq1IVZhpkFWbNdP45f44OwZ9OWEc1os2BwixOz
        2gTw8nPsgGrYrJpuRbDDzDzT+xXK4oUqSHYGIO+tUz7hZgg8ZgPdiTAGVx3JDMT0
        TQJye4K69WLHFardwmeXvZo3EI7jVO5G81Mb5yr1YiYS3yR+QbdP7fmKRtIFI6ES
        mn3LhJNi2RTeg2yTigG0bKfICk+CC7R0s4CJ4LnY3GLWou7BgBIqW53jNlxo03EX
        UiXaRE0cnmRg73c4B2+fYkCYr1PxAQM1Gc006IYpQQ==
X-ME-Sender: <xms:_vOFY5DxgOuni61vmiztQpi0PLZ9MlrcRmiHJlYUspcYweps6jSNhg>
    <xme:_vOFY3hWpPcTzxcZQ7ATeWm8L8EkKbAZhbBdBscQ_e-Xe-YbQKHdKMauFFC7LgRiR
    ELKbO1e7Dv2MZzRBdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrtddtgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeevhfffledtgeehfeffhfdtgedvheejtdfgkeeuvefgudffteettdekkeeufeeh
    udenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgepud
    enucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:_vOFY0n5qNSGgPSu0AjbWJJgZ1w6HEPy4p03CIAtJC-SyXYQz16LpA>
    <xmx:_vOFYzwmGb6XROvzebwFXoCMozmdtgC2vs0I2GIemQpHDBNaoGXBFg>
    <xmx:_vOFY-TzogyUFrvvHXnA698t7lMYcLKAJ35VOpCll7X3RuPEHcq09A>
    <xmx:_vOFYxHGnN2Ahm9vqmdXtsDyBn2iISkDMQ8qe0bOx2wsdmg4iU95-Q>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 02708B60086; Tue, 29 Nov 2022 06:58:53 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <10c264a3-019e-4473-9c20-9bb0c9af97c3@app.fastmail.com>
In-Reply-To: <92671929-46fb-4ea8-9e98-1a01f8d6375e@app.fastmail.com>
References: <20221125115003.30308-1-yuehaibing@huawei.com>
 <20221128191828.169197be@kernel.org>
 <92671929-46fb-4ea8-9e98-1a01f8d6375e@app.fastmail.com>
Date:   Tue, 29 Nov 2022 12:58:23 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Jakub Kicinski" <kuba@kernel.org>,
        "Richard Cochran" <richardcochran@gmail.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Florian Fainelli" <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET
 under ARCH_BCM2835
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Florian's broadcom.com address bounces, adding him to Cc
with his gmail address]

On Tue, Nov 29, 2022, at 12:56, Arnd Bergmann wrote:
> On Tue, Nov 29, 2022, at 04:18, Jakub Kicinski wrote:
>> On Fri, 25 Nov 2022 19:50:03 +0800 YueHaibing wrote:
>>> diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
>>> index 55dfdb34e37b..f4ca0c6c0f51 100644
>>> --- a/drivers/net/ethernet/broadcom/Kconfig
>>> +++ b/drivers/net/ethernet/broadcom/Kconfig
>>> @@ -71,13 +71,14 @@ config BCM63XX_ENET
>>>  config BCMGENET
>>>  	tristate "Broadcom GENET internal MAC support"
>>>  	depends on HAS_IOMEM
>>> +	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
>>>  	select MII
>>>  	select PHYLIB
>>>  	select FIXED_PHY
>>>  	select BCM7XXX_PHY
>>>  	select MDIO_BCM_UNIMAC
>>>  	select DIMLIB
>>> -	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
>>> +	select BROADCOM_PHY if ARCH_BCM2835
>>>  	help
>>>  	  This driver supports the built-in Ethernet MACs found in the
>>>  	  Broadcom BCM7xxx Set Top Box family chipset.
>>
>> What's the code path that leads to the failure? I want to double check
>> that the driver is handling the PTP registration return codes correctly.
>> IIUC this is a source of misunderstandings in the PTP API.
>>
>> Richard, here's the original report:
>> https://lore.kernel.org/all/CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com
>
> The original report was for a different bug that resulted in the
> BROADCOM_PHY driver not being selectable at all.
>
> The remaining problem here is this configuration:
>
> CONFIG_ARM=y
> CONFIG_BCM2835=y
> CONFIG_BCMGENET=y
> CONFIG_PTP_1588_CLOCK=m
> CONFIG_PTP_1588_CLOCK_OPTIONAL=m
> CONFIG_BROADCOM_PHY=m
>
> In this case, BCMGENET should 'select BROADCOM_PHY' to make the
> driver work correctly, but fails to do this because of the
> dependency. During early boot, this means it cannot access the
> PHY because that is in a loadable module, despite commit
> 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> trying to ensure that it could.
>
> Note that many other ethernet drivers don't have this
> particular 'select' statement and just rely on the .config
> to contain a sensible set of drivers. In particular that
> is true when running 64-bit kernels on the same chip,
> which is now the normal configuration.
>
> The alternative to YueHaibing's fix would be to just revert
> 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> and instead change the defconfig file to include the phy driver,
> as we do elsewhere.
>
>     Arnd
