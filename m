Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BF064B237
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 10:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiLMJVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 04:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbiLMJUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 04:20:55 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5644D48;
        Tue, 13 Dec 2022 01:20:53 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id C4B8D5C007F;
        Tue, 13 Dec 2022 04:20:52 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 13 Dec 2022 04:20:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1670923252; x=1671009652; bh=B/U5i3u883
        FE3HYgve/aglh3sfvqVqAT4dapVTpH9Bs=; b=AAcfMHZ/V8XdPQWn804Q/+YCAl
        8JtOVvgEW+WgXdLj7p80oOqfCyEwRAWGJKaCdkoorWNPLtLLahVUgIlZsTkCOzNU
        UGlNEa9ZN8bTjoLi4jP9h4LDvZzAgSIvwyVVLnCnNAVtVF3mojSTZpr/ndXbY6Jv
        aDRYI4476ppEDk7ryW7cTtFAKJ/WNeKJcrC5DunoTSOEWitqkjx7O7GiwWPciroq
        rMeju2bINwErdfe3Ds4HT9uxWWV2TIYBxr4Gk7Y04yHhU6QLqQAl8nQmjUGaaHhA
        8Zs7PMORgPV75C9TMXPRl45Tz1wVVLjZyBTxjZIuW4BmQkSv6LkfFpBfBRmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1670923252; x=1671009652; bh=B/U5i3u883FE3HYgve/aglh3sfvq
        VqAT4dapVTpH9Bs=; b=J1DvYW0YJKnUMrML7EIqbMoMU8YeF7WTd/r90aNZ5Z2/
        djU574dBj8CE1X3i9wqjXZKLhHD2eHkXHNX4RQplSDUw8j5ba2bXj4bmetAorW7G
        +ssG2rpkhDTzMKETndGQQn+N367uXGisZ/Mxqd8tqaAf/FBm3rFa3kq6ypw1lPib
        VIrrQOA/rPOTGy3a9fJOz/LNQKHLBGoIassIvZWspHidBvkaO99tnCQ0W2tB7I1D
        sT+hGSMZSkU4yHY7rlMO8YzAuq/wBXmj/l1IPdVrXrajaqJImd1LKQyoYsrqUnhq
        bzgXGXRAFKn7hBL+gyOC7wbnCCW8Z3lDyS0NB6SNfQ==
X-ME-Sender: <xms:80OYY8eNmt8ORTVetcJjF-BkyY7pIxU019LdGNLey9vn3aEIHKMqAA>
    <xme:80OYY-NDmZ2tsWF_sOFbYFR89hjc5Rbpln_dL5jI12h5IsI5XxtcfHp7w-vBtC0qC
    YN8eClPwH51ub0cPKE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpefhtdelhfettdetvdetvdeuueegvdeuleeuudevhfeuhfeugfdvtdevvedvfffh
    udenucffohhmrghinheplhhinhgrrhhordhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:9EOYY9gx5DMlG-qag2FX-uA6qt3Ej0Cu2nhsk0_giwyyIWAcLmsJKA>
    <xmx:9EOYYx-19KTw6Jv9F1CnFRVxj1GxV2l5a11dFg9gCyBlJZKqXWy3QQ>
    <xmx:9EOYY4u8wi1d6AGKMvAYlLcUDxfwDRVzIxuGlc2akDSJv8N4dP4X_w>
    <xmx:9EOYYzlzGNWaq4kwDu4vrh1HmsKZd67fRqPTS2D7hZTsaWManVXaiQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id EBD28B60089; Tue, 13 Dec 2022 04:20:51 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <86c7e7a5-6457-49c5-a9e3-b28b8b8c1134@app.fastmail.com>
In-Reply-To: <CA+G9fYv7tm9zQwVWnPMQMjFXtNDoRpdGkxZ4ehMjY9qAFF0QLQ@mail.gmail.com>
References: <20221212130924.863767275@linuxfoundation.org>
 <CA+G9fYv7tm9zQwVWnPMQMjFXtNDoRpdGkxZ4ehMjY9qAFF0QLQ@mail.gmail.com>
Date:   Tue, 13 Dec 2022 10:20:30 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Netdev <netdev@vger.kernel.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Guenter Roeck" <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        "Pavel Machek" <pavel@denx.de>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Anders Roxell" <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022, at 08:48, Naresh Kamboju wrote:
> On Mon, 12 Dec 2022 at 18:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>
> Regression detected on arm64 Raspberry Pi 4 Model B the NFS mount failed.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Following changes have been noticed in the Kconfig file between good and bad.
> The config files attached to this email.
>
> -CONFIG_BCMGENET=y
> -CONFIG_BROADCOM_PHY=y
> +# CONFIG_BROADCOM_PHY is not set
> -CONFIG_BCM7XXX_PHY=y
> +# CONFIG_BCM7XXX_PHY is not set
> -CONFIG_BCM_NET_PHYLIB=y

> Full test log details,
>  - https://lkft.validation.linaro.org/scheduler/job/5946533#L392
>  - 
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.158-107-gd2432186ff47/testrun/13594402/suite/log-parser-test/tests/
>  - 
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.158-107-gd2432186ff47/testrun/13594402/suite/log-parser-test/test/check-kernel-panic/history/

Where does the kernel configuration come from? Is this
a plain defconfig that used to work, or do you have
a board specific config file?

This is most likely caused by the added dependency on
CONFIG_PTP_1588_CLOCK that would lead to the BCMGENET
driver not being built-in if PTP support is in a module.

     Arnd
