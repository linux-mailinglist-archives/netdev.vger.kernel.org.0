Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A114E3A6B
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiCVIVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiCVIVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:21:11 -0400
X-Greylist: delayed 330 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Mar 2022 01:19:42 PDT
Received: from ni.piap.pl (ni.piap.pl [195.187.100.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE875EDDD
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 01:19:42 -0700 (PDT)
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        by ni.piap.pl (Postfix) with ESMTPSA id A2715C360E02;
        Tue, 22 Mar 2022 09:14:08 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl A2715C360E02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1647936849; bh=T2cidvVxQQYqJFyZU8DviBjsHwe8rK5Z23dR8jWDaYI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=D05ttJcayN9UOJKHpT0XUic7CrQu0KGDbP4V+TnJxFJMD4nfuGOW+2zs4m/dybMAO
         vLGBmTpg5SyMI1lFJr+izEMV8WD6xw1DBgu0cciEJSEDqR1S2JUrVkzzrDbS92qMYJ
         IM0toDpmbiai7ZBeWVzLjf66ewE6gSgpAx/pxtvY=
From:   =?utf-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Stanley-Jones <asj@cban.com>, Rob Braun <bbraun@vix.com>,
        Michael Graff <explorer@vix.com>,
        Matt Thomas <matt@3am-software.com>,
        Arnd Bergmann <arnd@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Is drivers/net/wan/lmc dead?
References: <20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: khalasa@piap.pl
Date:   Tue, 22 Mar 2022 09:14:08 +0100
In-Reply-To: <20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Mon, 21 Mar 2022 14:40:13 -0700")
Message-ID: <m37d8mieun.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-KLMS-Rule-ID: 3
X-KLMS-Message-Action: skipped
X-KLMS-AntiSpam-Status: not scanned, whitelist
X-KLMS-AntiPhishing: not scanned, whitelist
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, not scanned, whitelist
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> It has also received not received a single functional change that'd
> indicate someone owns this HW since the beginning of the git era.
>
> Can we remove this driver or should we invest effort into fixing it?

Ahh, it's where they took a tulip (DEC Ethernet controller) and added
an FPGA/PLD frontend converting Ethernet to/from sync serial (buffering
etc). I guess they were tulip experts and didn't want to mess with PCI
directly.

Alan Cox wrote in 2008 (commit 8ab7b66796):
> Not sure anyone uses this driver any more, maybe we should just drop it ?
> Code is still foul but at least a fraction less broken.

C101, N2 (including hd64570), Cosa, hostess_sv11, Sealevel (including
z85230) are ISA. The last motherboard with ISA slot (just one) I used
was Pentium II + i440LX (or something). Sure, the serial links needed
only obsolete hardware (I had been using an old Pentium ~ 100 MHz router
for years back then). But it was ~ 20 years ago. Are there places on
Earth where such stuff still exists, and uses relatively up-to-date
Linux kernels?

Farsync, LMC, PC300, PCI200SYN and wanXL are PCI. While PCI is obsolete,
I think it's quite possible for such hw to be in active use. wanXL were
expensive (and bit older) cards and thus rare, but PC300 and PCI200SYN
were common at some point (as common as V.35/X.21 etc. stuff could be).
I don't know about Farsync or LMC (though I still have one or two of
the latter, somewhere).

The remaining - fsl_ucc_hdlc, lapbether, slic_ds26522 - are either
embedded drivers (Motorola QUICC engine, Dallas Semi T1/E1/J1 frontend)
or pure software device. QUICC isn't exactly new :-) but it seems to be
referenced by arm64 and PPC DTS files (so this isn't the original
~68020 QUICC).
--=20
Krzysztof "Chris" Ha=C5=82asa

Sie=C4=87 Badawcza =C5=81ukasiewicz
Przemys=C5=82owy Instytut Automatyki i Pomiar=C3=B3w PIAP
Al. Jerozolimskie 202, 02-486 Warszawa
