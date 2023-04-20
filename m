Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0092A6E8A6A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbjDTGbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbjDTGbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:31:43 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496AE46A6;
        Wed, 19 Apr 2023 23:31:42 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 5C6F2320069B;
        Thu, 20 Apr 2023 02:31:39 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 20 Apr 2023 02:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1681972298; x=1682058698; bh=eP
        zZEj8M7v5T2YSkLJR2yP2qHh01VIHjtDtJNsIPb5Y=; b=i5FL1M32ued+WtcQCq
        EYl5+KZSaJhuolI+2V6ij3AED0sMCj8lHtz12tziM70JA2SqcdLVv+K7tF7NMbZk
        GfHm42gFBY8aQIkYBbznsaeM6nlJUxZ1T97+c7vkPk8a3MXMeCwHzgEa57cHp9tA
        vk3M7NSPWDrqFqWMLV9Hz01ef4bu0FXoFpXDyYWgEZMiKoWBFhFvOp9X2J4hf9aV
        6Vs0v1Vp2ybMfHjbMVb6c22OvfyQPMJKOLqjNa5wdhNQolfUv3fqi2r97/7VxH5m
        yjEivOe/OJHD3b5t7FFP+sssOeCTBm7Smwl7jM2oKMGdxObsTfTf5k6muQr6R6nM
        DUsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681972298; x=1682058698; bh=ePzZEj8M7v5T2
        YSkLJR2yP2qHh01VIHjtDtJNsIPb5Y=; b=KCLwG3l5O3gAA27jXbZzdvHU4EveJ
        lCQyBp2Svnu9kCNDTJ9LeXY6BxXfHgH5tk7Tw8Lvrq29rzc/FiXQI7/IhSGuwdA/
        bWuSMBkH1kvm6jxRHB5TY7EXOilIo4xxaO6kL4Ss7yssohKnauKGCllmOv7zhs02
        6AwFQkAtqK5nhostq50dU7oWyRG1bsE+QQ4dn8A8Qj7ml0x8DzRgEeCfOvKVV5T5
        Qb8vLUgH8hWikCjtnYFkdAIvRNEaItSub76vjdnBAgWfsxwx8zE9e5fb37bZJL7a
        mCmrMk5ueZY0qEel6MM2B0FLt9EOM+GNC3M+p8BbT3qF6apu/kZjptY8Q==
X-ME-Sender: <xms:StxAZCDuJfyQ3_xhcoBV3HQTw8mM8aKD2ry9sFcww3D2FRsPqeaVHw>
    <xme:StxAZMg_jf0455MvU-PMyGkKSATAUCusSrU3Aonn4Wn-VEXLr7_4KpI6XHLXSZ5qk
    GrERFhxO5-wNrQN3vk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtuddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:StxAZFkwMhANCl37MtN12A_l1FOjIEIawFZ_CA62cvDfmUojxAB_PA>
    <xmx:StxAZAz4vQGLb68CTLHVztEQzKNGWBEDNfxVmxrRPLyOgKD_mtEREA>
    <xmx:StxAZHQpEbpFda-6rXtB0SDQ35n8kiVz0Qoj9U9gtNtAzVxYILZXBA>
    <xmx:StxAZARMZlR-W6hHQDRLJI9ih0wlLNMam6ezYxWXtnhVzELIWXKepA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 6432FB60086; Thu, 20 Apr 2023 02:31:38 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-372-g43825cb665-fm-20230411.003-g43825cb6
Mime-Version: 1.0
Message-Id: <f16fb810-f70d-40ac-8e9d-2ada008c446d@app.fastmail.com>
In-Reply-To: <202303241935.xRMa6mc6-lkp@intel.com>
References: <202303241935.xRMa6mc6-lkp@intel.com>
Date:   Thu, 20 Apr 2023 08:31:17 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "kernel test robot" <lkp@intel.com>, "Andrew Lunn" <andrew@lunn.ch>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        "Christian Marangi" <ansuelsmth@gmail.com>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [lunn:v6.3-rc2-net-next-phy-leds 5/15] ld.lld: error: undefined symbol:
 devm_mdiobus_alloc_size
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023, at 12:36, kernel test robot wrote:
>>> ld.lld: error: undefined symbol: devm_mdiobus_alloc_size
>    >>> referenced by phy.h:458 (include/linux/phy.h:458)
>    >>>               
> drivers/net/ethernet/microchip/lan743x_main.o:(lan743x_pcidev_probe) in 
> archive vmlinux.a
>    >>> referenced by phy.h:458 (include/linux/phy.h:458)
>    >>>               drivers/net/ethernet/ni/nixge.o:(nixge_probe) in 
> archive vmlinux.a
>
> Kconfig warnings: (for reference only)
>    WARNING: unmet direct dependencies detected for PHYLIB

It looks like this has hit linux-next now, I'm seeing the same problem in
my own randconfig builds after Andrew's 01e5b728e9e4 ("net: phy: Add a
binding for PHY LEDs").

>    Depends on [m]: NETDEVICES [=y] && (LEDS_CLASS [=m] || LEDS_CLASS 
> [=m]=n)
>    Selected by [y]:
>    - PHYLINK [=y] && NETDEVICES [=y]
>    - TIGON3 [=y] && NETDEVICES [=y] && ETHERNET [=y] && 
> NET_VENDOR_BROADCOM [=y] && PCI [=y] && PTP_1588_CLOCK_OPTIONAL [=y]
>    - LAN743X [=y] && NETDEVICES [=y] && ETHERNET [=y] && 
> NET_VENDOR_MICROCHIP [=y] && PCI [=y] && PTP_1588_CLOCK_OPTIONAL [=y]
>    - NI_XGE_MANAGEMENT_ENET [=y] && NETDEVICES [=y] && ETHERNET [=y] && 
> NET_VENDOR_NI [=y] && HAS_IOMEM [=y] && HAS_DMA [=y]
>    - XILINX_EMACLITE [=y] && NETDEVICES [=y] && ETHERNET [=y] && 
> NET_VENDOR_XILINX [=y] && HAS_IOMEM [=y]
>    Selected by [m]:
>    - ALTERA_TSE [=m] && NETDEVICES [=y] && ETHERNET [=y] && HAS_DMA [=y]
>    - DNET [=m] && NETDEVICES [=y] && ETHERNET [=y] && HAS_IOMEM [=y]
>    - B44 [=m] && NETDEVICES [=y] && ETHERNET [=y] && 
> NET_VENDOR_BROADCOM [=y] && SSB_POSSIBLE [=y] && HAS_DMA [=y]
>    - KS8851_MLL [=m] && NETDEVICES [=y] && ETHERNET [=y] && 
> NET_VENDOR_MICREL [=y] && HAS_IOMEM [=y] && PTP_1588_CLOCK_OPTIONAL [=y]
>    - SMSC911X [=m] && NETDEVICES [=y] && ETHERNET [=y] && 
> NET_VENDOR_SMSC [=y] && HAS_IOMEM [=y]
>    - SMSC9420 [=m] && NETDEVICES [=y] && ETHERNET [=y] && 
> NET_VENDOR_SMSC [=y] && PCI [=y]
>    - XILINX_LL_TEMAC [=m] && NETDEVICES [=y] && ETHERNET [=y] && 
> NET_VENDOR_XILINX [=y] && HAS_IOMEM [=y]
>    - USB_NET_AX88179_178A [=m] && NETDEVICES [=y] && USB_NET_DRIVERS 
> [=m] && USB_USBNET [=m]

The problem here is that both PHYLIB and LEDS_CLASS are user-visible
tristate symbols that are referenced from other Kconfig symbols with
both 'depends on' and 'select'. Having the two interact introduces a
number of ways that lead to circular dependencies.

It might be ok to use 'select LEDS_CLASS' from PHYLIB, but I have not
tried that yet and I expect this will result in other build failures.

A better solution would be to change all drivers that currently use
'select PHYLIB' to 'depends on PHYLIB' and have PHYLIB itself
'default ETHERNET' to avoid most of the regressions, but doing this
for 6.4 is a bit risky and can cause other problems.

     Arnd
