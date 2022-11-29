Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D29463BF85
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 12:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiK2L5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 06:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbiK2L5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 06:57:01 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2332356D54;
        Tue, 29 Nov 2022 03:56:56 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 7095932009A2;
        Tue, 29 Nov 2022 06:56:53 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Tue, 29 Nov 2022 06:56:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1669723012; x=1669809412; bh=nOLnMSuo1b
        P6LQJLFcDucGJqGof4YI83X8hbRx4aygo=; b=YTH0iA2vKh+QnOG6/EPNpgvMgN
        Ml2MfdAlNvReKWat9IKPeD8Z9i4w98ekZPfcsmxFxnPOhMWbNU1KJwyetkqzjcyQ
        sZGTMvZAto66xcW4K5r4wUPSJNBJla1k1dNu9EONK79co/RPavIG/2GCaV+EvpMX
        HKuYIGyzZp9249iR/+DR1uektP4zHI2eUfQHTUzwuq9GU2hE1adJgMMrSVr1WbRd
        4hGgzWmZYzL/aMuuk9lpCv3fklEPKtrDcaHTJIiEf67+s3qn0DYVeLyvPj7KLgAG
        O8AuqwYErjQmhnLkTBJOyt95FngD9Wo0YRTXwlx8JqSbM0T61XB3klwo1yCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669723012; x=1669809412; bh=nOLnMSuo1bP6LQJLFcDucGJqGof4
        YI83X8hbRx4aygo=; b=PdBAjiLBv/DMi4ngDbiX/uhh6SAPIp8mhizwb4/gC+3O
        ils2khQgWbRqJeap7rAJFSHvn6ca5mtgMQPtBGiNOIDcOYRfIHnzQoDWZG/QkcKA
        q/HyX10IsMmE7e5VKFx3oQif4TpQxdUaqgVhS1O+kaAlesOs8KgmFUuIWukI+qC0
        jBMtBeEk6WBh3oPnFFPXlVZ0R9c/ltQVMf/xgEP+H934NUW9DbU/RZk4XX1iok5k
        y+9SCbXVwTTWsznmkmfnSGkvk0wcqtm6o+8YLeshC81KHngV+vDCYsRGF8rSw5Ut
        DqpvWgg11qMAwF6YVCqDUqbCJ4u6Kfoi21/8jE1axw==
X-ME-Sender: <xms:hPOFYxfx1M80AsAs012GuIH2lms5fduLnQDW9M5ybijb0FM1Lei9OA>
    <xme:hPOFY_Nsb0nkOCIQRp0OTufx-AJwkFTUJ75lSP82r8t3VC5UkOPOsaavjx5S3D266
    lzJz-hDEGK4z4NsabQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrtddtgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeevhfffledtgeehfeffhfdtgedvheejtdfgkeeuvefgudffteettdekkeeufeeh
    udenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:hPOFY6gNuIGnN_NzjXmlgA0EpHYE2nlAq0SW7Lere_EYVTC0LfkFhQ>
    <xmx:hPOFY68sZiOnRm6t9cMvhimV6fdt13YwsnCCXxPRfF6OV9yFkDUzMA>
    <xmx:hPOFY9sEPg4Wrc6PLqIqO_tUTQc4M3Pvd3POopG4xIJ8SKKEUraNYg>
    <xmx:hPOFYzCwpce_ituwIwZ7cteR7M0zF-ry1ZRgHTxm51vg_ljpXvSZyA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A6845B60086; Tue, 29 Nov 2022 06:56:52 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <92671929-46fb-4ea8-9e98-1a01f8d6375e@app.fastmail.com>
In-Reply-To: <20221128191828.169197be@kernel.org>
References: <20221125115003.30308-1-yuehaibing@huawei.com>
 <20221128191828.169197be@kernel.org>
Date:   Tue, 29 Nov 2022 12:56:32 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Jakub Kicinski" <kuba@kernel.org>, f.fainelli@broadcom.com,
        "Richard Cochran" <richardcochran@gmail.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
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

On Tue, Nov 29, 2022, at 04:18, Jakub Kicinski wrote:
> On Fri, 25 Nov 2022 19:50:03 +0800 YueHaibing wrote:
>> diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
>> index 55dfdb34e37b..f4ca0c6c0f51 100644
>> --- a/drivers/net/ethernet/broadcom/Kconfig
>> +++ b/drivers/net/ethernet/broadcom/Kconfig
>> @@ -71,13 +71,14 @@ config BCM63XX_ENET
>>  config BCMGENET
>>  	tristate "Broadcom GENET internal MAC support"
>>  	depends on HAS_IOMEM
>> +	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
>>  	select MII
>>  	select PHYLIB
>>  	select FIXED_PHY
>>  	select BCM7XXX_PHY
>>  	select MDIO_BCM_UNIMAC
>>  	select DIMLIB
>> -	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
>> +	select BROADCOM_PHY if ARCH_BCM2835
>>  	help
>>  	  This driver supports the built-in Ethernet MACs found in the
>>  	  Broadcom BCM7xxx Set Top Box family chipset.
>
> What's the code path that leads to the failure? I want to double check
> that the driver is handling the PTP registration return codes correctly.
> IIUC this is a source of misunderstandings in the PTP API.
>
> Richard, here's the original report:
> https://lore.kernel.org/all/CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com

The original report was for a different bug that resulted in the
BROADCOM_PHY driver not being selectable at all.

The remaining problem here is this configuration:

CONFIG_ARM=y
CONFIG_BCM2835=y
CONFIG_BCMGENET=y
CONFIG_PTP_1588_CLOCK=m
CONFIG_PTP_1588_CLOCK_OPTIONAL=m
CONFIG_BROADCOM_PHY=m

In this case, BCMGENET should 'select BROADCOM_PHY' to make the
driver work correctly, but fails to do this because of the
dependency. During early boot, this means it cannot access the
PHY because that is in a loadable module, despite commit
99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
trying to ensure that it could.

Note that many other ethernet drivers don't have this
particular 'select' statement and just rely on the .config
to contain a sensible set of drivers. In particular that
is true when running 64-bit kernels on the same chip,
which is now the normal configuration.

The alternative to YueHaibing's fix would be to just revert
99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
and instead change the defconfig file to include the phy driver,
as we do elsewhere.

    Arnd
