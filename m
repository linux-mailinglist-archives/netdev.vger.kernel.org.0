Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F9996B78
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbfHTV2G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Aug 2019 17:28:06 -0400
Received: from gauss.credativ.com ([93.94.130.89]:58165 "EHLO
        gauss.credativ.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730430AbfHTV2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 17:28:06 -0400
Received: from gauss.credativ.com (localhost [127.0.0.1])
        by gauss.credativ.com (Postfix) with ESMTP id EACCC1E3CA6;
        Tue, 20 Aug 2019 23:27:59 +0200 (CEST)
Received: from openxchange.credativ.com (openxchange.credativ.com [93.94.130.84])
        (using TLSv1 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by gauss.credativ.com (Postfix) with ESMTPS id CDFD11E3C50;
        Tue, 20 Aug 2019 23:27:59 +0200 (CEST)
Received: from openxchange.credativ.com (localhost [127.0.0.1])
        by openxchange.credativ.com (Postfix) with ESMTPS id 46CkRM4l5Qz2xc4;
        Tue, 20 Aug 2019 21:27:59 +0000 (UTC)
Date:   Tue, 20 Aug 2019 23:27:59 +0200 (CEST)
From:   Sedat Dilek <sedat.dilek@credativ.de>
Reply-To: Sedat Dilek <sedat.dilek@credativ.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?Q?Cl=C3=A9ment_Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     Sedat Dilek <sedat.dilek@gmail.com>
Message-ID: <892584913.468.1566336479573@ox.credativ.com>
In-Reply-To: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
References: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v4 00/14] NFC: nxp-nci: clean up and new device support
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.10.2-Rev10
X-Originating-Client: open-xchange-appsuite
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Andy Shevchenko <andriy.shevchenko@linux.intel.com> hat am 29. Juli 2019 15:35 geschrieben:
> 
>  
> Few people reported that some laptops are coming with new ACPI ID for the
> devices should be supported by nxp-nci driver.
> 
> This series adds new ID (patch 2), cleans up the driver from legacy platform
> data and unifies GPIO request for Device Tree and ACPI (patches 3-6), removes
> dead or unneeded code (patches 7, 9, 11), constifies ID table (patch 8),
> removes comma in terminator line for better maintenance (patch 10) and
> rectifies Kconfig entry (patches 12-14).
> 
> It also contains a fix for NFC subsystem as suggested by Sedat.
> 
> Series has been tested by Sedat.
> 
> Changelog v4:
> - rebased on top of latest linux-next
> - appended cover letter
> - elaborated removal of pr_fmt() in the patch 11 (David)
> 
> Andrey Konovalov (1):
>   NFC: fix attrs checks in netlink interface
> 
> Andy Shevchenko (11):
>   NFC: nxp-nci: Add NXP1001 to the ACPI ID table
>   NFC: nxp-nci: Get rid of platform data
>   NFC: nxp-nci: Convert to use GPIO descriptor
>   NFC: nxp-nci: Add GPIO ACPI mapping table
>   NFC: nxp-nci: Get rid of code duplication in ->probe()
>   NFC: nxp-nci: Get rid of useless label
>   NFC: nxp-nci: Constify acpi_device_id
>   NFC: nxp-nci: Drop of_match_ptr() use
>   NFC: nxp-nci: Drop comma in terminator lines
>   NFC: nxp-nci: Remove unused macro pr_fmt()
>   NFC: nxp-nci: Remove 'default n' for the core
> 
> Sedat Dilek (2):
>   NFC: nxp-nci: Clarify on supported chips
>   NFC: nxp-nci: Fix recommendation for NFC_NXP_NCI_I2C Kconfig
> 
>  MAINTAINERS                           |   1 -
>  drivers/nfc/nxp-nci/Kconfig           |   7 +-
>  drivers/nfc/nxp-nci/core.c            |   2 -
>  drivers/nfc/nxp-nci/i2c.c             | 134 +++++++-------------------
>  drivers/nfc/nxp-nci/nxp-nci.h         |   1 -
>  include/linux/platform_data/nxp-nci.h |  19 ----
>  net/nfc/netlink.c                     |   6 +-
>  7 files changed, 41 insertions(+), 129 deletions(-)
>  delete mode 100644 include/linux/platform_data/nxp-nci.h
> 
> -- 
> 2.20.1

Hi Andy,

I gave that patchset v4 a try against Linux v5.3-rc5.

And played with neard and neard-tools v0.16-0.1 from Debian/buster AMD64.

# nfctool --list

# nfctool --enable --device=nfc0

# nfctool --list --device=nfc0
nfc0:
          Tags: [ tag11 ]
          Devices: [ ]
          Protocols: [ Felica MIFARE Jewel ISO-DEP NFC-DEP ]
          Powered: Yes
          RF Mode: Initiator
          lto: 0
          rw: 0
          miux: 0

# nfctool --device=nfc0 --poll=Both --sniff --dump-symm
Start sniffer on nfc0

Start polling on nfc0 as both initiator and target

Targets found for nfc0
  Tags: [ tag11 ]
  Devices: [ ]

But I see in the logs:

# journalctl -u neard.service -f
Aug 20 23:01:15 iniza neard[6158]: Error while reading NFC bytes

What does this error mean?
How can I get more informations?
Can you aid with debugging help?

Thanks in advance.

Regards,
- Sedat -

[1] https://github.com/nfc-tools/libnfc/issues/455#issuecomment-523185147
[2] https://github.com/nfc-tools/libnfc/issues/455#issuecomment-523195283
[3] https://github.com/nfc-tools/libnfc/issues/455#issuecomment-523198304

-- 
Mit freundlichen Grüssen 
Sedat Dilek
Telefon: +49 2166 9901-153 
E-Mail: sedat.dilek@credativ.de
Internet: https://www.credativ.de/

GPG-Fingerprint: EA6D E17D D269 AC7E 101D C910 476F 2B3B 0AF7 F86B

credativ GmbH, Trompeterallee 108, 41189 Mönchengladbach 
Handelsregister: Amtsgericht Mönchengladbach HRB 12080 USt-ID-Nummer DE204566209 
Geschäftsführung: Dr. Michael Meskes, Jörg Folz, Sascha Heuer

Unser Umgang mit personenbezogenen Daten unterliegt folgenden Bestimmungen: 
https://www.credativ.de/datenschutz/
