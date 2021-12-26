Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459D647F88B
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 20:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhLZTRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 14:17:32 -0500
Received: from bmailout1.hostsharing.net ([83.223.95.100]:35727 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhLZTRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 14:17:31 -0500
X-Greylist: delayed 3433 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Dec 2021 14:17:29 EST
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id A52F230001184;
        Sun, 26 Dec 2021 20:17:28 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 9395D2ECFEC; Sun, 26 Dec 2021 20:17:28 +0100 (CET)
Date:   Sun, 26 Dec 2021 20:17:28 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        Rafa?? Mi??ecki <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [RFC PATCH 00/34] brcmfmac: Support Apple T2 and M1 platforms
Message-ID: <20211226191728.GA687@wunner.de>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 12:35:50AM +0900, Hector Martin wrote:
> # On firmware
> 
> As you might expect, the firmware for these machines is not available
> under a redistributable license; however, every owner of one of these
> machines *is* implicitly licensed to posess the firmware, and the OS
> packages containing it are available under well-known URLs on Apple's
> CDN with no authentication.

Apple's EFI firmware contains a full-fledged network stack for
downloading macOS images from osrecovery.apple.com.  I suspect
that it also contains wifi firmware.

You may want to check if it's passed to the OS as an EFI property.
Using that would sidestep license issues.  There's EDID data,
Thunderbolt DROM data and whatnot in those properties, so I
wouldn't be surprised if it contained wifi stuff as well.

Enable CONFIG_APPLE_PROPERTIES and pass "dump_apple_properties"
on the command line to see all EFI properties in dmesg.
Alternatively, check "ioreg -l" on macOS.  Generally, what's
available in the I/O registry should also be available on Linux
either as an ACPI or EFI property.

Thanks,

Lukas
