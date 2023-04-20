Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB60F6E942A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbjDTMWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbjDTMWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:22:21 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7364A1BF4;
        Thu, 20 Apr 2023 05:22:20 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id D55065C01A9;
        Thu, 20 Apr 2023 08:22:19 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 20 Apr 2023 08:22:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1681993339; x=1682079739; bh=sZ
        ONUP6h+SJJnBCxfgbuzzXtSUZFZ3CJUwyCTkmq7Xg=; b=UXWrJ2EEvSiy24KMbi
        fOpjxO35+cBmgDE7F6QvpjvJAcc23bJlf2c6pqZRu5zeqK/HhqTkzQ+AbklUI5r1
        vV4RktufQbcODh2x1HBkLgxMMrQGKIKQAw8/PMXttqcziirs1IJenx5RmmTFrAMl
        /8Y45X2c1rk1vHeLI0bgaxK/bHqFaL6fTf6EA6BNC1vlPOcyrNaRpdCfYl4AUcLb
        uXhKGvOFaUZyhA57UzjmEoBCxxyncuaERsVmjWAbCYJjm6hDOaWQjNb2cK3Nnk6a
        pZIAguRdayXwLnrrMIf8uZasj/QpiZ0pMq2GgHa8ap55jaPF4G0DAXX1tX/z7wO2
        QKXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681993339; x=1682079739; bh=sZONUP6h+SJJn
        BCxfgbuzzXtSUZFZ3CJUwyCTkmq7Xg=; b=Hf7YZCJ1hzUf+3hn6Y3OxxyMZgL8i
        PN/hgEMQ5V0XaWicdiNtSvmHWbgNanzjnZ+YZ5arE5hBWFFYPyGfSVFckEA3wa0U
        y7U6nsAR5/qkpd6sZFRm1CIy1ubMvDFjqQWsbA3AJVbBpB8Y0EFIrTJtH1UAhhMB
        kOMfeDIlbqXzEzGjZxVd8/xuJ9X13FEjEHB8dj84RQ6GL+IY5Zfd6O1oRgAnNYRX
        uSA/bjY0JIjxLpWqg4Pk13mLPaK5OX0NXk3YfsaGKetfAhBTeEY8fTxgQucu17rt
        xejm00Egbcf/Ymh/+Jj1/ngFyhUpbyU0E9FoLcz3HBDBbJPRmWWaiyYHQ==
X-ME-Sender: <xms:ey5BZI7NI8R3UM7swGYU65cfll0oLLl7jJkR3kQPgqZSjCKfqgDT4g>
    <xme:ey5BZJ41ypjuCPWmB-_ULfXWacdRdJfku9BgPPhlIC7U76U5Lu0Cu77YjPm9YEh4E
    dd-9LrkRSzT6-bHDqs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtvddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepvefhffeltdegheeffffhtdegvdehjedtgfekueevgfduffettedtkeekueef
    hedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dunecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:ey5BZHcgTSP7afLL2Ly7HJa4kgBCh5FOot5NhfcpWOpNEaavFDFsJA>
    <xmx:ey5BZNIombeMEXIsHXza8yedFKUPJgDUrLZp30tcja3zOvsg158BXA>
    <xmx:ey5BZMLRvsDvBxiF3PAoHk_uIaZscCP7T6FX8JZoVJ5JqBzfN2LA0g>
    <xmx:ey5BZKwd9vOyIog2uaUSb4za4BGatTv8tQEB_Re3wJ6lH5JCurK72g>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 06C07B60086; Thu, 20 Apr 2023 08:22:18 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-372-g43825cb665-fm-20230411.003-g43825cb6
Mime-Version: 1.0
Message-Id: <747af785-963b-45e5-9d7b-d361951ea3fc@app.fastmail.com>
In-Reply-To: <CA+G9fYsdMioe4+DEgeh38aTeaY3YaN_s_c0GFjPHhuPWfxyetA@mail.gmail.com>
References: <CA+G9fYsdMioe4+DEgeh38aTeaY3YaN_s_c0GFjPHhuPWfxyetA@mail.gmail.com>
Date:   Thu, 20 Apr 2023 14:21:58 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-next <linux-next@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Cc:     "Rob Herring" <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Nicholas Piggin" <npiggin@gmail.com>,
        "Christophe Leroy" <christophe.leroy@csgroup.eu>,
        "Andrew Donnellan" <ajd@linux.ibm.com>,
        "Anders Roxell" <anders.roxell@linaro.org>
Subject: Re: next: powerpc: gpio_mdio.c:(.text+0x13c): undefined reference to
 `__of_mdiobus_register'
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023, at 12:57, Naresh Kamboju wrote:
> Following build failures noticed on Linux next-20230419 for powerpc.
>
> Regressions found on powerpc:
>  - build/gcc-8-defconfig
>  - build/clang-16-defconfig
>  - build/gcc-12-defconfig
>  - build/clang-nightly-defconfig
>
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Build log:
> --------
> powerpc64le-linux-gnu-ld: arch/powerpc/platforms/pasemi/gpio_mdio.o:
> in function `gpio_mdio_probe':
> gpio_mdio.c:(.text+0x13c): undefined reference to `__of_mdiobus_register'
> powerpc64le-linux-gnu-ld: drivers/net/phy/phy_device.o: in function `phy_probe':
> phy_device.c:(.text+0x56ac): undefined reference to
> `devm_led_classdev_register_ext'
> powerpc64le-linux-gnu-ld: drivers/net/ethernet/pasemi/pasemi_mac.o: in
> function `pasemi_mac_open':
> pasemi_mac.c:(.text+0x19ac): undefined reference to `of_phy_connect'
> make[2]: *** [scripts/Makefile.vmlinux:35: vmlinux] Error 1

Same bug as the other one:

https://lore.kernel.org/all/20230420084624.3005701-1-arnd@kernel.org/

      Arnd
