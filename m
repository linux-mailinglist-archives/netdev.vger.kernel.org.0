Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFABC6693B9
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 11:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbjAMKHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 05:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239755AbjAMKG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 05:06:57 -0500
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186DC34D65;
        Fri, 13 Jan 2023 02:06:56 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.west.internal (Postfix) with ESMTP id 59F1E2B066ED;
        Fri, 13 Jan 2023 05:06:53 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 13 Jan 2023 05:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1673604412; x=1673611612; bh=wiGd1poFqy
        c19NDgfhWxoziS+5a2ezYepeVzBSacqw8=; b=jQa0HDmPBmL/FfJL+hgRmPsB40
        Y3mC3xChdI36TABN4RG5b4ucaLsZc6+hC+19/zCIm4A4ie1QOoF7GdEwpLDXWLgg
        YS7KkbMyef4z8Yilol0xjO/jcY2PDSzSOyaObnKUz9YejiKar9NRQ/48gMheN8SP
        L9ydOdhClMFMN+laVtMxeJLlISQdpKBcfrhR3HNQLngArqhNZXfmj7B7QaV3Yjlc
        q1pbz3p93X/orY60g/G7bg2Tiz9gOW8CeW5RhiSUeYXFN/oIPHXLd05ewSyQoczy
        YcvZ76uBqZ6njLqUwdbbXb3on9pD3cxdKgfVZ0av7GSfMv1N46xG/nNSra4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1673604412; x=1673611612; bh=wiGd1poFqyc19NDgfhWxoziS+5a2
        ezYepeVzBSacqw8=; b=T9tKOcHloTqEvCQgyITgoeWHiCG023yZCoHB8GCNjjun
        JWtWHvJqinTMKxNzOHfWFkde1UNzFYeNjWL4OYuUevGP5ZiDtpX0SAgeRoVmsRqT
        4s4imE9aYV/f9Pvbl/xyCzDnDswOyuD8ceeVeSEppPmXeTdO2UYN2NW+SPkjkx6z
        7AGNecW4IwYIR8h6khoClacES7xN1wBX6oY0XpQ9E/MHHJqDRpFMe5RHSjqUpFHQ
        972R/sDnO/VHBlJ/MZtdHhD4RBw3rwTM6MhJr5iT0G2mUNkzC1EVZ0kt797d6W2S
        fBdJ8aBi3uu6VLi/i8mbcHwOUByNIvAxQvGBru7fCg==
X-ME-Sender: <xms:Oy3BY2x8u8jGs5oav_hETNuy2fGaBGNB7nGV00CwtVI39ajIhtTDrA>
    <xme:Oy3BYyQeI43uOCS5CK49RFBPrQXLvgoH7jyxA1EWEhaXS1U_GFSXnUcOsyByJ4HxX
    7ebslCPuxwL7F72QUk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:Oy3BY4WFmJ1Wzov0EgMi6qcJljjNqlgJoW7YxZYtni3we9ZcuZJC0Q>
    <xmx:Oy3BY8jDZdOmomBzdPQYugeTKvRs2JAmwJR9qFQ78gYn6oU0QQd3og>
    <xmx:Oy3BY4DQ3Zg11gEbb70JkOCpYbMnoYHqWtdB8svYNbX-CHCrZb2sRA>
    <xmx:PC3BYzV0__Pe1Lv9Yq1qvCTC7InwXhC6SGzQNcMq4ULKQsDh2lBDrgxrUdU>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B041DB60086; Fri, 13 Jan 2023 05:06:51 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1185-g841157300a-fm-20221208.002-g84115730
Mime-Version: 1.0
Message-Id: <d9c2f760-283b-483c-8512-fdd2c372f26c@app.fastmail.com>
In-Reply-To: <CAMuHMdXYt4dNHUDsTnPa-RP+sdK=35nNa9xQzMChwK54qO44mA@mail.gmail.com>
References: <20230113062339.1909087-1-hch@lst.de>
 <20230113062339.1909087-12-hch@lst.de>
 <CAMuHMdXYt4dNHUDsTnPa-RP+sdK=35nNa9xQzMChwK54qO44mA@mail.gmail.com>
Date:   Fri, 13 Jan 2023 11:06:22 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Christoph Hellwig" <hch@lst.de>
Cc:     "Yoshinori Sato" <ysato@users.sourceforge.jp>,
        "Rich Felker" <dalias@libc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "laurent.pinchart" <laurent.pinchart@ideasonboard.com>,
        "Kieran Bingham" <kieran.bingham+renesas@ideasonboard.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org,
        "linux-mmc @ vger . kernel . org" <linux-mmc@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 11/22] mtd/nand: remove sh_flctl
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023, at 09:30, Geert Uytterhoeven wrote:
> On Fri, Jan 13, 2023 at 7:24 AM Christoph Hellwig <hch@lst.de> wrote:
>> Now that arch/sh is removed this driver is dead code.
>
> FTR, this hardware block is also present on the ARM-based
> SH-Mobile AG5 and R-Mobile A1 SoCs.
> Again, no DT support.

I would generally consider drivers dead when they have no DT support
and no platform in the upstream kernel registering the corresponding
device.

If anyone still uses this driver on SH-Mobile or R-Mobile, they
have clearly given up on upstreaming their patches by now, and
they can carry the burden of maintaining the driver out of tree,
or re-submit a working version.

    Arnd
