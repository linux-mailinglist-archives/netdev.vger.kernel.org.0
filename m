Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BF96A4CB8
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjB0VFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjB0VFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:05:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B1C27D7E;
        Mon, 27 Feb 2023 13:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8B80B80DB9;
        Mon, 27 Feb 2023 21:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9C7C4339C;
        Mon, 27 Feb 2023 21:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677531911;
        bh=wM7CKQVbmGuH345EmkznKBI9Vbtt2sSUgczg9Ty7nXs=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=jOPmsQJ92zMVF6JYFsoNUtFmfqH1qn9yNHrBFNCHK1WfW7u5eh/4Dt9Wuis7K36N0
         zrL+jhWh1yWTKKzwbuI8LAi0DKDAghFiaLH5lvECf285Web9rihBnkQ8C3DESaEWK0
         /j7dTBTpjCyFT8vHLXWUy9qwvesNEnhkTG5aQlFxMcvzvM6AKOkT0GNU1MFopQ68Gj
         htVUyVIN5jq24tsH7EHUCjm7Wqg+o4VRa+39BcSkQqAtkTiNRkF1yHoI7FytKL3qRN
         /mnyrfziJh7++JU+FiEifPiPb2v4w4HMEJbpJnpyNS69v66VYxTCeW/J/rBk/0TyWV
         6UaSXElMaBwCA==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailauth.nyi.internal (Postfix) with ESMTP id D2E5827C0054;
        Mon, 27 Feb 2023 16:05:09 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 27 Feb 2023 16:05:09 -0500
X-ME-Sender: <xms:BBv9Yyq_yU45rwjslj9ZPw3LnS_Yd3JCkKAXSvmFzr69CFR2sOj88A>
    <xme:BBv9Ywo9VLxxtN8HDdkLGcOtVPWMG59yBVPaDlDViIdcBzPiuWwE2xiNKgG-bC3C8
    14R5VUgpEdn9d0GJO4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeltddgudegtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugeskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpedvveeigfetudegveeiledvgfevuedvgfetgeefieeijeejffeggeeh
    udegtdevheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrrhhnugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidquddvkeehudej
    tddvgedqvdekjedttddvieegqdgrrhhnugeppehkvghrnhgvlhdrohhrghesrghrnhgusg
    druggv
X-ME-Proxy: <xmx:BBv9Y3NRTcfPS0EYvfk5Q21Jb-QcLDWCcZQkB9uda8GiiBfkXPK7Qg>
    <xmx:BBv9Yx5sAGjH5WS5nTp0Ao8kgK1098XeOqkPFFLTZ5Ul3ATxZpcFJw>
    <xmx:BBv9Yx7BPJU4ThUSrb8hCmt20IPwURbUGqPfv2ohP3vz_7e7CjhkNQ>
    <xmx:BRv9Y_7DCKSXNgCtRbgu-759t33EYkEgxuDAtp_duzO0SmzYx8s2_w>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 7653FB60086; Mon, 27 Feb 2023 16:05:08 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-183-gbf7d00f500-fm-20230220.001-gbf7d00f5
Mime-Version: 1.0
Message-Id: <3e94a109-66cc-4774-8317-3ae249e34c54@app.fastmail.com>
In-Reply-To: <Y/0PbJzvrzpvLbcW@shell.armlinux.org.uk>
References: <20230227133457.431729-1-arnd@kernel.org>
 <Y/0PbJzvrzpvLbcW@shell.armlinux.org.uk>
Date:   Mon, 27 Feb 2023 22:04:07 +0100
From:   "Arnd Bergmann" <arnd@kernel.org>
To:     "Russell King" <linux@armlinux.org.uk>
Cc:     "Dominik Brodowski" <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org, "Arnd Bergmann" <arnd@arndb.de>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
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
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023, at 21:15, Russell King (Oracle) wrote:
> On Mon, Feb 27, 2023 at 02:34:51PM +0100, Arnd Bergmann wrote:
>> I don't expect this to be a problem normal laptop support, as the last
>> PC models that predate Cardbus support (e.g. 1997 ThinkPad 380ED) are
>> all limited to i586MMX CPUs and 80MB of RAM. This is barely enough to
>> boot Tiny Core Linux but not a regular distro.
>
> Am I understanding that the argument you're putting forward here is
> "cardbus started in year X, so from year X we can ignore 16-bit
> PCMCIA support" ?

Right, but I'm asking this as a question, hence the
'RFC' in the subject.

> Given that PCMCIA support has been present in x86 hardware at least
> up to 2010, I don't see how that is any basis for making a decision
> about 16-bit PCMCIA support.

I assume you mean machines with Cardbus slots that can use
16-bit PCMCIA slots, rather than laptops with only PCMCIA here,
right?

> Isn't the relevant factor here whether 16-bit PCMCIA cards are still
> in use on hardware that can run a modern distro? (And yes, x86
> machines that have 16-bit PCMCIA can still run Debian Stable today.)

There are three combinations that are supported at the moment:

1. Machines with only 16-bit PCMCIA support, all very old,
   which rely on these slots for basic functionality.
2. Machines that support Cardbus slots that are actually
   used to connect 16-bit cards.
3. Machines that have a Cardbus slot and can just use 32-bit
   cards for whatever they need.

Dominik originally raised the question whether we could
kill off all PCMCIA support already given its age, which
would either break all three of the above or at least
the first two if Yenta-socket is kept as a PCI hotplug
driver.

I wanted to make sure that we keep both case 1) for
sa1100/omap1/pxa and case 3) for x86, while case 2) seems
much less important because there are presumably fewer
users than 3), and they have an upgrade path that only
involves replacing one cheap card instead of trashing the
whole machine.

   Arnd

