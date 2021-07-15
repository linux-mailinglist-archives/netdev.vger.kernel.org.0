Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314A43C9F13
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 15:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhGONHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 09:07:36 -0400
Received: from mout.gmx.net ([212.227.17.22]:45775 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhGONHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 09:07:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626354271;
        bh=3XKnCVe17/cL/PJQD7dAeEz7KGEt/61iS/itcmUBvTw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=AehGIjIFryTdfYB6UGcGPOqsSWwkRDhvA9wnNHEX9IOamuDhN9gc7QCCvMHE3Zd3s
         Dz/OxXYKsuqzGYVqn7kCXssY9XIOI4bOtkOcm6uG8weCe6muMWB/EBU2o2A4hilAkj
         VgNjkq/IwYAWMFVoXPWu8vU1sIZCpm47eGQqPuno=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.130.101.138] ([87.130.101.138]) by web-mail.gmx.net
 (3c-app-gmx-bap31.server.lan [172.19.172.101]) (via HTTP); Thu, 15 Jul 2021
 15:04:31 +0200
MIME-Version: 1.0
Message-ID: <trinity-0dbbc59b-1e7d-4f58-8611-adb281a82477-1626354270982@3c-app-gmx-bap31>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Aw: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware
 process the layer 4 checksum
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 15 Jul 2021 15:04:31 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210715114908.ripblpevmdujkf2m@skbuf>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf> <YO9F2LhTizvr1l11@lunn.ch>
 <20210715065455.7nu7zgle2haa6wku@skbuf>
 <trinity-84a570e8-7b5f-44f7-b10c-169d4307d653-1626347772540@3c-app-gmx-bap31>
 <20210715114908.ripblpevmdujkf2m@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:BSfJAEMGWpjmadghZep1FdQXRxpw04ktpiPXQm4UEOWb2hn8UaCaD6/RHVTWWsP9vxrgu
 6KOGEfPGPo7MRxTIC+sfYhjtkA9IEFAVzHKA06WD9cicrV55JhssXal3b7xvyu/MUSyd+ITHCZiO
 EB+xYMQLNp6CKwx7r9A57F5RYfiCoaZQETxVKzLC81uM93bUUUMxRh1aVKGvEX+F/WSMZil7dg3J
 4OXOXly6RXBdsXD+9RvwjnL2tjWxLJC/dovEuIrMP0PFeWj1EhdkybWPBJQvNKF0jhjA5CFSkqsA
 dg=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3Ad/TgTgTrE=:KMdnEyIsLgBVyIkXwHnnZQ
 bykJuNOiF6M8cmKG49845vHTRtMeIbThHhNNfLNDnjlMj3Eei6r8scvlGZaC8EPAfBLuE3ht/
 PzEuOX4giqxS+zc4hL6YYP8XAzf2EzBgIy0vpNZaoNE0foMzYvdwtas1FTFDfVnbv0F1G9bCP
 /HtdoOsJ0H3U8VghjPrPOkBGvzllW1ii59I95Lmrs1nztOM50NVbJmYW0cnfKfZQa840x1zjH
 P0omxUqhT72A9sw6yRMAcx0YazzUIl6p0ZgWV/YmW/NUr3aYl3kE/uk450ZRkjJQavc9bSc4g
 hsv8nVQ3ozNTvNCh9bILkd8kE8FgoxVi8T8atnUIVLmcjNdY0SpI8qSR9pWr+jYgA/GaKrSEf
 gVE3vEGhqU40FJwxXMG101qR1j1xETsuSb7Zx30rzBJdQ0bgeULqdknrHYIYbILeRQrgtB22a
 TMHVrACpewIYGaTfAxYurxGc204JddUOWzq6yzoXD1VCESeG17Ty++wGrQBLnOBX7UfRIuUSe
 1c4HZ/bWNAKkuAFmIqwZGZmGZWcVe6N9QTaDJaRrKU7YPZ7fU9ZUB+xl+xmdZTky5d9FaOYNg
 +is3FIp7XOMnFiUEdBdZ0y2cYFuEiGctEcDaJn9LQLViK2G00B8bgolG7tbxmBlGlow9utteJ
 4iBrGjGACCXtgnypUGmPJKqIBZmf5AjID8jY0HRzlC4QsxwYHsw25VflS1h8cGfPmU7GW/8tq
 TmwSuk0jN7QRPSFf4pj9UOPYwwYlvooFV0M4KkGCaQMNSdn4M3ZfWwtYa3Gn++TweR+NWlF+F
 x7jqYzpSHmI80LLv7/GW9WHUVZDWzTO6qcyw/X/+6MN8MEbnAA=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Gesendet: Donnerstag, 15. Juli 2021 um 13:49 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>
> An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
> Cc: "Andrew Lunn" <andrew@lunn.ch>, woojung.huh@microchip.com, UNGLinuxD=
river@microchip.com, vivien.didelot@gmail.com, f.fainelli@gmail.com, davem=
@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org, linux-kernel@vger=
.kernel.org
> Betreff: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware proces=
s the layer 4 checksum
>
> On Thu, Jul 15, 2021 at 01:16:12PM +0200, Lino Sanfilippo wrote:
> > Sure, I will test this solution. But I think NETIF_F_FRAGLIST should a=
lso be
> > cleared in this case, right?
>
> Hmm, interesting question. I think only hns3 makes meaningful use of
> NETIF_F_FRAGLIST, right? I'm looking at hns3_fill_skb_to_desc().
> Other drivers seem to set it for ridiculous reasons - looking at commit
> 66aa0678efc2 ("ibmveth: Support to enable LSO/CSO for Trunk VEA.") -
> they set NETIF_F_FRAGLIST and then linearize the skb chain anyway. The
> claimed 4x throughput benefit probably has to do with less skbs
> traversing the stack? I don't know.
>
> Anyway, it is hard to imagine all the things that could go wrong with
> chains of IP fragments on a DSA interface, precisely because I have so
> few examples to look at. I would say, header taggers are probably fine,
> tail taggers not so much, so apply the same treatment as for NETIF_F_SG?
>

Please note that skb_put() asserts that the SKB is linearized. So I think =
we
should rather clear both NETIF_F_FRAGLIST and NETIF_F_SG unconditionally s=
ince also
header taggers use some form of skb_put() dont they?






