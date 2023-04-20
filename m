Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11EF6E95EF
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 15:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjDTNiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 09:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjDTNiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 09:38:04 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AEE4ECF;
        Thu, 20 Apr 2023 06:38:02 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 54FFB5C02B1;
        Thu, 20 Apr 2023 09:38:00 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 20 Apr 2023 09:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1681997880; x=1682084280; bh=l1
        57PF1o8GfYodDCq/uRVldL3RnSiAxX/QtRHLYnAzg=; b=i9vitxfqzHhlC5SUtd
        1vMtckX3QQi+aeJIOBnS9Tf4UFRS9SSXdT5rJ3Q2OX0s0tl7uUeBCGnv3DoRQ+CW
        YPK1t6JwyVdfBeDb8Q7P415qB7htkoPyQjPp097jOHhbD1hM764giFGSEUJAC0U2
        ypVBLPnWA1Cv0ZZr7DInmY9CLaT/q3xLlUYxWOWDfZa3xDmfZf8wwllfgLO6kLG/
        9e9WuT3cnw9dNag09DL171jMBy9/bOhyk36Pd9bsQkuk8L6v5raYP8uoQOmFBawg
        SDO7IkU62bw3mhofU+M9yR4LNQ8jbOJuhbL1u/1++yKchRJV2T7IFp27IO2RMs7t
        sutg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681997880; x=1682084280; bh=l157PF1o8GfYo
        dDCq/uRVldL3RnSiAxX/QtRHLYnAzg=; b=Kh7jMS4QOAKyepo6FS5j6xqoER69k
        68tL8bFit/2b3jK+hPWHkzfEdNx/JonEZyTQ0QUvg/pP95oD2Rh60VBQeS1DBB3c
        goY+43+gQYFPrZn8RA8+ZAjEHO+9rwPk1XjX921fFJHVlQ6+FyXXkk/j4BX82mee
        qxy4oPLMPaN+F0Yp26VPOKRRoanySKVuQf5kmuqj4w3nz/Agj6AKDcEtLl465i5n
        ZKW81LaJyac2oAk93Bv6tZ1p2EEjYxAeZVye0WzGRp2bMBHpofARi+0yDrrQkkfZ
        vBjBWE2xa9CEd8GrZM2M/0DQNBxoPfvTKt4jw2C+yN3uSYAxtCINazqyA==
X-ME-Sender: <xms:OEBBZKJTzqEOAufVxIZO_d1bF0RJhI-rv7io8tRgVN7YdbU--_VdKw>
    <xme:OEBBZCJESyHE0OBu6jSmqqDjL6fuI9yKMQ89QA6bTzum3D7oppjJydVjwGv9IlFvg
    pjWkkPeP2Ukk6qPNmo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtvddgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepvefhffeltdegheeffffhtdegvdehjedtgfekueevgfduffettedtkeekueef
    hedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:OEBBZKvm-g6VhBfuo5zld3-9JsJ1zAzK6ODGacvQzQMsvDHgTTIPeg>
    <xmx:OEBBZPZEmQCIjssV2CjJpqs-nlMtfmaJdKTGsgIC0mMMYtDxyI7KZQ>
    <xmx:OEBBZBYlQxiVjBGqehCks1pMPWWeVwLNxTG17CyYxddurounxrjEjw>
    <xmx:OEBBZN4adpwhvzXAOysdLQ7Ru4kxybBuOYJnYLk337Ix_ZOmNdDGuA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id F389BB60086; Thu, 20 Apr 2023 09:37:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-372-g43825cb665-fm-20230411.003-g43825cb6
Mime-Version: 1.0
Message-Id: <91c716f0-bf7f-4fdf-8cb7-83f1bdc0cbd4@app.fastmail.com>
In-Reply-To: <758fff85-aefc-4e0a-97b1-fe7179fafac6@lunn.ch>
References: <202303241935.xRMa6mc6-lkp@intel.com>
 <f16fb810-f70d-40ac-8e9d-2ada008c446d@app.fastmail.com>
 <758fff85-aefc-4e0a-97b1-fe7179fafac6@lunn.ch>
Date:   Thu, 20 Apr 2023 15:37:38 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Andrew Lunn" <andrew@lunn.ch>
Cc:     "kernel test robot" <lkp@intel.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        "Christian Marangi" <ansuelsmth@gmail.com>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [lunn:v6.3-rc2-net-next-phy-leds 5/15] ld.lld: error: undefined symbol:
 devm_mdiobus_alloc_size
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

On Thu, Apr 20, 2023, at 15:07, Andrew Lunn wrote:
> On Thu, Apr 20, 2023 at 08:31:17AM +0200, Arnd Bergmann wrote:
>> 
>> It looks like this has hit linux-next now, I'm seeing the same problem in
>> my own randconfig builds after Andrew's 01e5b728e9e4 ("net: phy: Add a
>> binding for PHY LEDs").
>
> Hi Arnd
>
> I tried to fix this with:
>
> commit 37f9b2a6c086bb28487a0682b8098f907861c4a1
> Author: Andrew Lunn <andrew@lunn.ch>
> Date:   Thu Mar 30 20:13:29 2023 -0500
>
>     net: ethernet: Add missing depends on MDIO_DEVRES
>    
>     A number of MDIO drivers make use of devm_mdiobus_alloc_size(). This
>     is only available when CONFIG_MDIO_DEVRES is enabled. Add missing
>     depends or selects, depending on if there are circular dependencies or
>     not. This avoids linker errors, especially for randconfig builds.
>
> All the failures i've seen have CONFIG_MDIO_DEVRES set to disabled. So
> i added either depends on, or select to the drivers which use it. I
> missed the LAN743x.

I've sent a different patch now. From what I can tell, your patch does
not address the actual problem, it just works around one of the symptoms:

When you have a driver that selects PHYLIB, but PHYLIB itself
depends on something that is not enabled, Kconfig just gives up
and stops handling any other 'select' statements from that chain.

selecting MDIO_DEVRES from each of the drivers works around this
one thing, but it does not solve the actual dependency, for that you
would have to add 'depends on LED_CLASS' on each of the network
drivers as well, which is clearly not the intention.

>> The problem here is that both PHYLIB and LEDS_CLASS are user-visible
>> tristate symbols that are referenced from other Kconfig symbols with
>> both 'depends on' and 'select'. Having the two interact introduces a
>> number of ways that lead to circular dependencies.
>
> I was getting circular dependencies with first versions of the above
> patch. I initially tried depends on everywhere, and then had to drop
> back to select for a few cases.
>
>> It might be ok to use 'select LEDS_CLASS' from PHYLIB, but I have not
>> tried that yet and I expect this will result in other build failures.
>> 
>> A better solution would be to change all drivers that currently use
>> 'select PHYLIB' to 'depends on PHYLIB' and have PHYLIB itself
>> 'default ETHERNET' to avoid most of the regressions, but doing this
>> for 6.4 is a bit risky and can cause other problems.
>
> For 6.4, will adding more depend on/select MDIO_DEVRES help? That
> should be low risk.

I think the best way is to drop your MDIO_DEVRES patch and instead
apply mine (or some variation of that) from

https://lore.kernel.org/lkml/20230420084624.3005701-1-arnd@kernel.org/

Once any missing or recursive dependencies are handled, the devres
problem should be fixed as well. I have completed around 150
randconfig builds with that patch and have not seen any further
problems.

     Arnd
