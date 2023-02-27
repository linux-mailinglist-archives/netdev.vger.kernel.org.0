Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3256A4BE5
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjB0UAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjB0UAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:00:54 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F20523D85;
        Mon, 27 Feb 2023 12:00:52 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id AF5825C0072;
        Mon, 27 Feb 2023 14:53:32 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 27 Feb 2023 14:53:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1677527612; x=1677614012; bh=yC30tR58lD
        WMAbC3WznvtUEL6VSBZ1Xu0Ye4jfaff4E=; b=jkSIlNorAIKuVx/vedrggy/bfW
        oydMrIo9XFGFDAbd8/D5bVMHMfyhG/wiEytF8dkgRqFzFcit17qG1ITq+ByzC+77
        RaezKUIBNHiWC2+XMoLCqXZ4G3iOl5D3uWMYqb37YX78pqX6V2SBuNBQkOslmzlh
        sHPCJSELqlpK+HSmC8QPO4TbkZ7D1tqNpfJwt6v0QzZzxfI/SPdZ570TvYcztU8S
        FfHiDPMmb7gkwO7gyvD/eUy7gvAWlzxNP9g/dw5UGorTv+eaPciRfpJZQTxFFg9N
        4H71GsoX5OxdNUlTA2NEaLoYRozfZZAc+zQhOq+UI/3lNKQ5QUkHyVPIWGnA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677527612; x=1677614012; bh=yC30tR58lDWMAbC3WznvtUEL6VSB
        Z1Xu0Ye4jfaff4E=; b=CaznXqVrGCF/7CkuE4qsh1nNvy3qZ0VsgAzx/RYeDcvW
        hajBnnqt020TlccB7ZrjN6n3k/76uiBjIRrsdfj5JReYYtjAST3p7GnKdkCLIxjj
        zbzLehkioMkAaehIoCaQ10+ix08xHgrTZ5bffa3gguQ6Av21r42tmyho7twwxYLx
        alDf3y0Sxgv9asu+X1qwBjMvTU7r2cJS5PbXw+dRrf6m5o+za7SXBhIHH9marFRb
        Ru6bwY4qFkSTLFRNkBLtxcsffMnwoInR1YsfBNDLaX7NE3MBTDH90GPmejp48LDs
        JSx3RI6u5cLSjIkBYS/Skbr6c5CNkpoeQI3FSl+P5g==
X-ME-Sender: <xms:Owr9Y5CjfJQMxjg0vkuoq5FGG0-w9czhxzJYAZrdl_9gLzm6Yby8lg>
    <xme:Owr9Y3gguyQCvcLGy0iQLYUIfgRzhcuI29r8g53fk3-A66BsgTeiufX0PcwWx9ImR
    RRLfOxRBWNd73EaemM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeltddguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeelgffhgedvueeuffdtveeutddtfeehlefffeetvdffleejjeevffejjeek
    teevgeenucffohhmrghinhepsghoohhtlhhinhdrtghomhdpkhgvrhhnvghlrdhorhhgne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgu
    segrrhhnuggsrdguvg
X-ME-Proxy: <xmx:Owr9Y0n72Lh-6iiY43f1qXuG1cB1AMF4XSH1BKzMPkjzFIUVeu3Jpg>
    <xmx:Owr9YzwAVuC3mXk5s674S4oBdOv2YfNu4TDmIJS4Ciudk7zx_HL9Ew>
    <xmx:Owr9Y-TFZ0Q62NIaUS35WBkpKDZPoqNSRxcCKISuk8mvUblpI9AWFA>
    <xmx:PAr9Y8nu7ufuM1nV1G_gYiQuX9hLo0sw9jeSyhnO2nbhntu-nwIOuw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3EF77B60086; Mon, 27 Feb 2023 14:53:31 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-183-gbf7d00f500-fm-20230220.001-gbf7d00f5
Mime-Version: 1.0
Message-Id: <c5ea695e-8693-4033-9941-c582f1c6f6be@app.fastmail.com>
In-Reply-To: <1daa9f1f-6a68-273f-0866-72a4496cd0db@hartkopp.net>
References: <20230227133457.431729-1-arnd@kernel.org>
 <1daa9f1f-6a68-273f-0866-72a4496cd0db@hartkopp.net>
Date:   Mon, 27 Feb 2023 20:53:09 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Oliver Hartkopp" <socketcan@hartkopp.net>,
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

On Mon, Feb 27, 2023, at 20:07, Oliver Hartkopp wrote:
> Hello Arnd,
>
> On 27.02.23 14:34, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>
> (..)
>
>> The remaining cardbus/yenta support is essentially a PCI hotplug driver
>> with a slightly unusual sysfs interface, and it would still support all
>> 32-bit cardbus hosts and cards, but no longer work with the even older
>> 16-bit cards that require the pcmcia_driver infrastructure.
>
> I'm using a 2005 Samsung X20 laptop (Pentium M 1.6GHz, Centrino) with 
> PCMCIA (type 2) CAN bus cards:
>
> - EMS PCMCIA
> https://elixir.bootlin.com/linux/latest/source/drivers/net/can/sja1000/ems_pcmcia.c
>
> - PEAK PCCard
> https://elixir.bootlin.com/linux/latest/source/drivers/net/can/sja1000/peak_pcmcia.c
>
> As I still maintain the EMS PCMCIA and had to tweak and test a patch 
> recently (with a 5.16-rc2 kernel):
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/can/sja1000/ems_pcmcia.c?id=3ec6ca6b1a8e64389f0212b5a1b0f6fed1909e45
>
> I assume these CAN bus PCMCIA interfaces won't work after your patch 
> set, right?

Correct, the patch series in its current form breaks this since
your laptop is cardbus compatible. The options I can see are:

- abandon my series and keep everything unchanged, possibly removing
  some of the pcmcia drivers that Dominik identified as candidates

- decide on a future timeline for when you are comfortable with
  discontinuing this setup and require any CAN users with cardbus
  laptops to move to USB or cardbus CAN adapters, apply the series
  then

- duplicate the yenta_socket driver to have two variants of that,
  require the user to choose between the cardbus and the pcmcia
  variant depending on what card is going to be used.

Can you give more background on who is using the EMS PCMCIA card?
I.e. are there reasons to use this device on modern kernels with
machines that could also support the USB, expresscard or cardbus
variants, or are you likely the only one doing this for the
purpose of maintaining the driver?

      Arnd
