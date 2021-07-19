Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FCE3CCDAC
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 07:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhGSFza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 01:55:30 -0400
Received: from ni.piap.pl ([195.187.100.5]:59386 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234437AbhGSFz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 01:55:28 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jul 2021 01:55:26 EDT
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        by ni.piap.pl (Postfix) with ESMTPSA id 795F4C3F2A51;
        Mon, 19 Jul 2021 07:45:21 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl 795F4C3F2A51
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1626673524; bh=xH3yU1unl5seSQwdZbQWwx5A9ON1+nGOmgWR8IFn5r8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=L7U05iMv3oK92oCUuG5CTlxppqcc0E6eKg9JErEbxAKkTlJL107YThmaj1R9//agf
         ujEHiof3dy3tIle/ZvOryphYwiEfqEPiMWKwlENA/Tzv3jq7JttbBCzB0lDDauFBMk
         lA27aWd7d+osdxmPHbr2zUAKGu54dYjmQaG1nnxk=
From:   =?utf-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Salomon <dilinger@queued.net>,
        linux-geode@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Schiller <ms@dev.tdt.de>, linux-x25@vger.kernel.org,
        wireguard@lists.zx2c4.com
Subject: Re: [PATCH 5/6 v2] net: hdlc: rename 'mod_init' & 'mod_exit'
 functions to be module-specific
References: <20210711223148.5250-1-rdunlap@infradead.org>
        <20210711223148.5250-6-rdunlap@infradead.org>
Sender: khalasa@piap.pl
Date:   Mon, 19 Jul 2021 07:45:21 +0200
In-Reply-To: <20210711223148.5250-6-rdunlap@infradead.org> (Randy Dunlap's
        message of "Sun, 11 Jul 2021 15:31:47 -0700")
Message-ID: <m3y2a2zwjy.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 165067 [Jul 18 2021]
X-KLMS-AntiSpam-Version: 5.9.20.0
X-KLMS-AntiSpam-Envelope-From: khalasa@piap.pl
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=pass header.d=piap.pl
X-KLMS-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17, {Tracking_from_exist}, {Tracking_Text_ENG_RU_Has_Extended_Latin_Letters, eng}, {Tracking_marketers, three}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;piap.pl:7.1.1;t19.piap.pl:7.1.1;127.0.0.199:7.1.2
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2021/07/19 04:42:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/07/19 00:49:00 #16924188
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

Randy Dunlap <rdunlap@infradead.org> writes:

> Rename module_init & module_exit functions that are named
> "mod_init" and "mod_exit" so that they are unique in both the
> System.map file and in initcall_debug output instead of showing
> up as almost anonymous "mod_init".

>  drivers/net/wan/hdlc_cisco.c   |    8 ++++----
>  drivers/net/wan/hdlc_fr.c      |    8 ++++----
>  drivers/net/wan/hdlc_ppp.c     |    8 ++++----
>  drivers/net/wan/hdlc_raw.c     |    8 ++++----
>  drivers/net/wan/hdlc_raw_eth.c |    8 ++++----
>  drivers/net/wan/hdlc_x25.c     |    8 ++++----

Sorry for the delay.

Acked-by: Krzysztof Halasa <khalasa@piap.pl>
--=20
Krzysztof Ha=C5=82asa

Sie=C4=87 Badawcza =C5=81ukasiewicz
Przemys=C5=82owy Instytut Automatyki i Pomiar=C3=B3w PIAP
Al. Jerozolimskie 202, 02-486 Warszawa
