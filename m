Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BA46386F0
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiKYKCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKYKCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:02:47 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D20FB4B4;
        Fri, 25 Nov 2022 02:02:45 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 709865C009B;
        Fri, 25 Nov 2022 05:02:42 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 25 Nov 2022 05:02:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1669370562; x=1669456962; bh=sWYE/iIwCB
        vIU0xfDNveElelu0+FYSafuJcobyMBNYw=; b=C+oiFxD0ZqCbkXOpvygFUOnO7O
        bSJ+1QmD2EvTApYfH8/4uFWWcAKR5NhzDD92jb1q/mfnXbgXVecsdwHhfmwMxrq4
        ck/yh1BktL/NvzprB0boZ7L+MdUJ4lHwQdbplWZch5+fj55xPnMEiTaLe1yLtWDd
        YI57gzoGLDpg0LxV8i1Uk7zOb7R4qBB+3lVxSDbHOEm8Ueo+M/n/NLI38aE097d0
        aVmQc0WvWNQd7NE+t682JUReleLk9AYeaiF+Hi1AkbVkQavZH0jAI2eu7P1Wnx6g
        OX/qm8v75+kYVyEsTtt8aTuNdVGyimhauGE3F+BQrnOjsd7oKwSfsSPL2+Fg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669370562; x=1669456962; bh=sWYE/iIwCBvIU0xfDNveElelu0+F
        YSafuJcobyMBNYw=; b=wiDYy/YysHRfab9xMajQeRyxikkuhZyszOQkwwJdYfdU
        UgwqobLJ5xNIugL3Mbwmk5C2VK49S5hkADKoWu3uq6Yv8W276VzDWGFE18wgZeRJ
        x5tL2bQu+F5RlDKCvmboVcFt6Eebbtkc74+Ehidm5Qx9o0SYG+cxg3tkZvxhFVnj
        YgzE4fatoIir0zPxEaisi1/Y8gUnLfzTVuzXJfp16fsnyfEAzKo6yYMORCrM1+Lg
        AoE0SjAN4nrLfODbVq82Ew+3GxBkCLVZ/xBWeKa1jJSmScYNJTf9gEwQFP627cJ5
        LswIJqcVvssBJA+bbohMghGyfwsgLgrftdwp7PRMAg==
X-ME-Sender: <xms:wJKAYzW4siAWQN6Yp95tLa9Iomanxa9LtkFrpNftLS64DH9vJ6rIbw>
    <xme:wJKAY7koaoyLU4WCZvezFv2bDQFzYsIsh-jr7rWUHqLBzYwj8C9NofsFd59Ijbsbb
    KIKPQGUanLgj5cCW08>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieehgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:wJKAY_bktRkmR8r7PWwVtE6yRxphat27a9OEcXVjsXs4GmprerTmOg>
    <xmx:wJKAY-Xs0gmpzfudIiX5RZmVQg8MVPT9U3ulR5f9p_wvXvtFohvz4Q>
    <xmx:wJKAY9lfBOUZbnNRonki464UOCf9cRQVrpGEfhdXaBAHKXK5JQkgqQ>
    <xmx:wpKAY3vEhs9u_qQP1wWMHrwD6NLs99LlsYcqr6M3F5AMEQ6y-NPn9g>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 5993FB60086; Fri, 25 Nov 2022 05:02:40 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <a1652617-9da5-4a29-9711-9d3b3cf66597@app.fastmail.com>
In-Reply-To: <CA+G9fYsXomPXcecPDzDydO3=i2qHDM2RTtGxr0p2YOS6=YcWng@mail.gmail.com>
References: <20221123084557.945845710@linuxfoundation.org>
 <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
 <CA+G9fYvgaNKbr_EhWsh9hjnzCeVXGJoXX4to72ytdvZi8W0svA@mail.gmail.com>
 <Y4BuUU5yMI6PqCbb@kroah.com>
 <CA+G9fYsXomPXcecPDzDydO3=i2qHDM2RTtGxr0p2YOS6=YcWng@mail.gmail.com>
Date:   Fri, 25 Nov 2022 11:02:19 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>
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
        Netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022, at 09:05, Naresh Kamboju wrote:
> On Fri, 25 Nov 2022 at 12:57, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>> On Thu, Nov 24, 2022 at 09:17:36PM +0530, Naresh Kamboju wrote:
>> >
>> > Daniel bisected this reported problem and found the first bad commit,
>> >
>> > YueHaibing <yuehaibing@huawei.com>
>> >     net: broadcom: Fix BCMGENET Kconfig
>>
>> But that is in 5.10.155, 5.15.79, 6.0.9, and 6.1-rc5.  It is not new to
>> this -rc release.
>
> It started from 5.10.155 and this is only seen on 5.10 and other
> branches 5.15, 6.0 and mainline are looking good.

I think the original patch is wrong and should be fixed upstream.
The backported patch in question is a one-line Kconfig change doing

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index f4e1ca68d831..55dfdb34e37b 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -77,7 +77,7 @@ config BCMGENET
        select BCM7XXX_PHY
        select MDIO_BCM_UNIMAC
        select DIMLIB
-       select BROADCOM_PHY if ARCH_BCM2835
+       select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
        help
          This driver supports the built-in Ethernet MACs found in the
          Broadcom BCM7xxx Set Top Box family chipset.

which fixes the build on kernels that contain 99addbe31f55 ("net:
broadcom: Select BROADCOM_PHY for BCMGENET") and enable
BCMGENET=y but PTP_1588_CLOCK_OPTIONAL=m, which otherwise
leads to a link failure.

The patch unfortunately solves it by replacing it with a runtime
failure by no longer linking in the PHY driver (as found by Naresh).

I think the correct fix would be to propagate the dependency down
to BCMGENET:

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index f4e1ca68d831..f4ca0c6c0f51 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -71,6 +71,7 @@ config BCM63XX_ENET
 config BCMGENET
 	tristate "Broadcom GENET internal MAC support"
 	depends on HAS_IOMEM
+	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
 	select MII
 	select PHYLIB
 	select FIXED_PHY

With this change, the broken config is no longer possible, instead
forcing BCMGENET to be =m when building for ARCH_BCM2835 with
PTP_1588_CLOCK=m.

     Arnd
