Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E026A4D36
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjB0Vah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjB0Vad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:30:33 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF2122A1F;
        Mon, 27 Feb 2023 13:30:32 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id AE3785C0152;
        Mon, 27 Feb 2023 16:30:29 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 27 Feb 2023 16:30:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1677533429; x=1677619829; bh=GtBIbUEIzI
        /iUf6AU5qtHMu638shGX4SdoEqg7SfWT4=; b=Kc0MEy8xNRfWchZnTrYphtjku8
        exVS95qfn7rjqJ0D2GvyD1IONxt1WEKqyuXVXwkGZ/BtS/YOCObQ+fdUPzntbD37
        e30JndEqtwfv8VPluEcBNz3MAosXdSTBuh8KB+IdNKd3NrpNuF8gdDRwl8PzOPjb
        rruwlA4y0z58o7O3e1hI1OhSru1yf5GFqW2475eR4m1kcqTWGi0+RTphtBTYvki+
        NYgoH4YH0nIcC1lzIOw+V/GG2ah7iYFoWCmRQTWa8Etj1jXgKUsxEFfKGU8detsG
        IkoXop1dnLBlNOK/V61m3vY8Ia4qrXLmBIhwaSNk0fkXcHMP91xWBMR5GYlg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677533429; x=1677619829; bh=GtBIbUEIzI/iUf6AU5qtHMu638sh
        GX4SdoEqg7SfWT4=; b=JlcpH0Oge+scYqG/VvsdPzZdfNBeGdfCRLr9/y0551Yg
        YDzC8COlR/rVwNihuhSpwiGSTrM1ix1lbBFHBE8D60eLde3b/ULHe7JsakgD8b5S
        G+/4Qnuo2lyimfDzKRyXmf4Oak06MrJmRohv8b/hTiIYGPISCl4GJ4OoVqdqvS8B
        hoHkOpsBiQTDYkj6D5xO9YWRebmeCLJBdkuCiboYSKpf7cjg4888K5W47722EeCu
        ebKA/31BUWTQ0vlFHMzIExppXMiqzopwmVfA332ughh/QKw/dtSgllCFycdxUFOO
        jr9s/aa/bnikBtwCzSAKLOZ5Aa1c+6OIjYdA2RCfyw==
X-ME-Sender: <xms:9SD9Y3ssTzJNau3SkHyi9pRJtsfxfFjnv0VraZs2NK-VGBNvnp01Yw>
    <xme:9SD9Y4eOBoGKqs9pQNSeGoAPIsvWzqc5LA4WY8yP5nPdziPIuCWmgf65ZcVhSNhWp
    _-Bg5kNt0JFKuUsElM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeltddgudegiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:9SD9Y6xRrEHbSUznwqBNIvEiOl6ydCmwOHeJoTs9vkIPEv4Kvmr08A>
    <xmx:9SD9Y2O6Mn8xIwkS4L9m1-ueg6EbKFyinGtZ3omTEjjbVvGxh6aByQ>
    <xmx:9SD9Y38SlqWXXtBekSsScYu4IEjewB43gb2TgTdqKXd9zaQuKdHxVA>
    <xmx:9SD9YyerfjbYaH5FmDPEc-hCwbV1fwxUpHF0kw7KNI601RQXmuE7KQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 43FC9B60086; Mon, 27 Feb 2023 16:30:29 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-183-gbf7d00f500-fm-20230220.001-gbf7d00f5
Mime-Version: 1.0
Message-Id: <7085019b-4fad-4d8d-89c0-1dd33fb27bb7@app.fastmail.com>
In-Reply-To: <e9f8501f-ede0-4d38-6585-d3dc2469d3fe@lwfinger.net>
References: <20230227133457.431729-1-arnd@kernel.org>
 <3d8f28d7-78df-5276-612c-85b5262a987a@lwfinger.net>
 <c17bff4e-031e-4101-8564-51f6298b1c68@app.fastmail.com>
 <e9f8501f-ede0-4d38-6585-d3dc2469d3fe@lwfinger.net>
Date:   Mon, 27 Feb 2023 22:30:08 +0100
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023, at 22:09, Larry Finger wrote:
> On 2/27/23 14:38, Arnd Bergmann wrote:
>> Is this the Cardbus or the PCMCIA version of the BCM4306 device? As far
>> as I understand this particular chip can be wired up either way inside
>> of the card, and the PowerBook G4 supports both types of devices.
>> 
>> If it's the PCMCIA version, then dropping support for it was the idea
>> of the patch series that we can debate, but if it was the Cardbus version
>> that broke, then this was likely a bug I introduced by accident.
>
> The BCM4306 is internal, and wired directly to the PCI bus. My understanding is 
> that the BCM4318 is a cardbus device. It definitely shows up in an lspci scan.

Ah right, I got confused because I had googled for BCM4306 for too long
trying to find out whether that might be used in combination with the
BCM63xx SoC support that patch 1 removed.

BCM4318 should definitely keep working after my series. My best guess
is that the problem is that I introduced an unnecessary dependency
between CONFIG_CARDBUS and CONFIG_PCI_HOTPLUG, so you'd need to
either undo the dependency or enable both in the local config.

If it's not that, then it's a bug in my changes that needs to be
fixed before they can be considered for integration. As long as
we are still debating whether the series makes sense at all,
I'm not worried about this.

      Arnd
