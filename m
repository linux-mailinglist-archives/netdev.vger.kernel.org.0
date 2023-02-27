Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D7C6A4C66
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjB0Uj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjB0Uj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:39:26 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A6C241DD;
        Mon, 27 Feb 2023 12:39:20 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id E63645C012F;
        Mon, 27 Feb 2023 15:39:19 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 27 Feb 2023 15:39:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1677530359; x=1677616759; bh=S1e3ePYKPA
        RVzg5R0A+d2tPWsFwcVvoNQZq9oGxMJlk=; b=AM0evC64PkAurLIav8Kvp5pRWz
        rrJUXArt/YaCrSSTBXPkOap91I1/GoSj9jD5tLmokjU+dAK2AAKGghYSKg2L898x
        5NV4W92OvLTmEI62WFINDwBjhGiFwIrVcg/fEOFO7ZTQbIGG9H2K6/zOiEFad4Mu
        vrSSyOtZX5rSqqFHvWSvJR0cGOJ7zym/dvH1MRXVAba4xcUIaZnqoKp9vsS1MzI5
        a1BVImUD1rwnFf5m7UiXSePDfToc9Y/MxOTPYGKAFxv6WpEgdJEo5YiYuZXczPgv
        RM1sLOqIjT/9vPNPcvVb+DN6gjVz2As+gT3blIsj/+tg2V/p5rUIoABkcjEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677530359; x=1677616759; bh=S1e3ePYKPARVzg5R0A+d2tPWsFwc
        VvoNQZq9oGxMJlk=; b=RCWu7QtK9uPN/g1Pss5r3EAsnZLvd9r9wXX0v8xYZiMV
        lj5mDFj1gR69ANKaBudSuQ1upTyEYtmZOanh1bwBTtwcNhw+d97WS0qjNZxDFs0i
        BB1rbtGi6JjV/ontuqVRpo0H8zNk5MBq4NSv0T3JhHo9LA6U80RNFBu1bcYyjlwT
        WTS59/kNS8pkhIPazPaE5ynoWNFo34Dy/jrPOzzmVqoRK+QLolJziYbTowLJKkhR
        SlydfJR7i2UufWwf+8apkjxqj0HzZc5isyI9P9Ud9FHfecJ8mAa4vmf4sSLaquMY
        pUNzklG9MbRFPiYowvwcu4q7hSXn6waFs+SQR1BuOQ==
X-ME-Sender: <xms:9xT9Y5oIUNzx0xP9NUq-9ER4s7qWMn-oyleahK4fJ5sXY_k9-RYBdw>
    <xme:9xT9Y7ohvHc1zphjIfVI0OqEGTEHYoLswWPAOtqumQnj7EmkWvzLAGQSFq77GdfiV
    0GSCYlyIJaSx4vlbDI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeltddgudefiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:9xT9Y2PQP1we4fnztxFZDGJ7oi0C8hxrVtFpGyQEWRyK8nhYF0_yVg>
    <xmx:9xT9Y04YjNZnx1v967R6eTqh6uvjLEB8eZzupR317raNQ3b7GO1-aA>
    <xmx:9xT9Y44xqH9MS-EREdaaa4DCmQPj3HO_ES_YIQfKn2UHcCyxbCCpDw>
    <xmx:9xT9Y-7rwHi_mMxi8Xq_-Vt-0PIIyO3hZwzEkgq54JOYzY6Csy0AsA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 887CEB60086; Mon, 27 Feb 2023 15:39:19 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-183-gbf7d00f500-fm-20230220.001-gbf7d00f5
Mime-Version: 1.0
Message-Id: <c17bff4e-031e-4101-8564-51f6298b1c68@app.fastmail.com>
In-Reply-To: <3d8f28d7-78df-5276-612c-85b5262a987a@lwfinger.net>
References: <20230227133457.431729-1-arnd@kernel.org>
 <3d8f28d7-78df-5276-612c-85b5262a987a@lwfinger.net>
Date:   Mon, 27 Feb 2023 21:38:54 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "Dominik Brodowski" <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Cc:     "Bjorn Helgaas" <bhelgaas@google.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Hartley Sweeten" <hsweeten@visionengravers.com>,
        "Ian Abbott" <abbotti@mev.co.uk>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Kevin Cernekee" <cernekee@gmail.com>,
        "Lukas Wunner" <lukas@wunner.de>,
        "Manuel Lauss" <manuel.lauss@gmail.com>,
        "Oliver Hartkopp" <socketcan@hartkopp.net>,
        "Olof Johansson" <olof@lixom.net>,
        "Robert Jarzmik" <robert.jarzmik@free.fr>,
        "YOKOTA Hiroshi" <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
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

On Mon, Feb 27, 2023, at 21:23, Larry Finger wrote:
> On 2/27/23 07:34, Arnd Bergmann wrote:

>
> Your patch set also breaks my PowerBook G4. The output of 'lspci -nn | grep 
> Network' shows the following before your patch is applied:
>
> 0001:10:12.0 Network controller [0280]: Broadcom Inc. and subsidiaries BCM4306 
> 802.11b/g Wireless LAN Controller [14e4:4320] (rev 03)
> 0001:11:00.0 Network controller [0280]: Broadcom Inc. and subsidiaries BCM4318 
> [AirForce One 54g] 802.11g Wireless LAN Controller [14e4:4318] (rev 02)
>
> The first of these is broken and built into the laptop. The second is plugged 
> into a PCMCIA slot, and uses yenta-socket as a driver.
>
> When your patches are applied, the second entry vanishes.
>
> Yes, this hardware is ancient, but I would prefer having this wifi interface 
> work. I can provide any output you need.

Is this the Cardbus or the PCMCIA version of the BCM4306 device? As far
as I understand this particular chip can be wired up either way inside
of the card, and the PowerBook G4 supports both types of devices.

If it's the PCMCIA version, then dropping support for it was the idea
of the patch series that we can debate, but if it was the Cardbus version
that broke, then this was likely a bug I introduced by accident.

      Arnd
