Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B08C00E3
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfI0IOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:14:45 -0400
Received: from mout.web.de ([212.227.15.4]:38231 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfI0IOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 04:14:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569572075;
        bh=QAkNnVWeJt5SekPKj+WvdKsNgsfW0v/u3gpvyRC/tG0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Enca4z2G7q+QMUvMD4lEojaOK6vlPwkXUWHzAPbcUVeVPbjZt+Fpv7ByPGAqlCv/4
         siZWjo5fdQQCxXngAe+UXWcXzURDDbvlFbkWSZhHp+E4Z8gC73RWQEQr5r2dPS2ZY9
         70JKBpd9TFp4aLogLrBuHHkBeVzRzIzZDIKvyaQs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.191.8]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MC1ho-1iMb5G3wLw-008nfo; Fri, 27
 Sep 2019 10:14:35 +0200
Subject: [PATCH v2 0/2] net: phy: mscc-miim: Adjustments for mscc_miim_probe()
To:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <189ccfc3-d5a6-79fd-29b8-1f7140e9639a@web.de>
 <506889a6-4148-89f9-302e-4be069595bb4@web.de> <20190920190908.GH3530@lunn.ch>
 <121e75c5-4d45-9df2-a471-6997a1fb3218@web.de>
 <20190926161825.GB6825@piout.net>
 <0a1f4dbf-4cc6-8530-a38e-31c3369e6db6@web.de>
 <20190926193239.GC6825@piout.net>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <8fbfa9ad-182a-e2ce-e91f-7350523e33c7@web.de>
Date:   Fri, 27 Sep 2019 10:14:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190926193239.GC6825@piout.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:klzDtDJPyHsodHKVe00zX2aghptZrnS25Kp49RNIJegMl/4B6YF
 G3uTX78gzMrT1NQV7F+y0Z06p2zxEIlRwQwAlTTz2ANNvBTWm/POsGrPGHiBwPy4ICRiVtB
 XODGkOjaJgAkRsZ2+jms2V8hxVTNonXGE2yd6DckMlSppDBzdAAIQy3lbTZSDMRByacc9m6
 w170jIP9dhBoWKxHRsu4w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1Zrzp7MwNm8=:oCZ+ScnRN+8mk+p6I1L3aU
 rJdOZJsGG4saATYxwTSkVu/TZ5QhxzRJhF3eRb/kBte0xhu9C5BVc8CLTdY29Qt7eEJoLWA0E
 2l0qoIXUzpnNlzcJydKx9fV0FO6ygkopl2tgWp4VTSvy1YyjaJ5zxu+b2VCvg3W2epqo3UFUR
 fuAKGqzZOY6BZHbHcgsJGGmG7hkUgryV8z/D6I0G/f9lonlle3FsB/OtgABgV2vf3+HLGwYlA
 3QxWWlIG0vfW805l0QSPSgs6SRaW60d+j6JJaVEw4KaRygZ+P7zNZN9T41jWL5JYmEz4KtFMm
 vX7blHQKEXT5RT4gXmSgay+jL9QH9Tkb9tLlW0WSaPIEIHVZtFXrPeD/S+TxTdviAsoHlTBQW
 Cu3tSgkrpoTNSNL/fXIks77fB259+WI9tGLPHlyU8B2ygwBM03LPD4GrK5TCUEavccdp3CFEn
 tWUzn2s8Ndz3lMj49UxPVYoMUQJMgP0TThx3vN5XWqEYZcay+PwJm+l22xRnaGk1Vos9Dup9N
 zazNQfNFqQ40kSsQO0AuKj4wHG+m4gYCc7PoGCYvIKF12mHO4f3Jbw2VWLze2pGa617vs0x61
 7Wp5f5iVYt9ro0s75nYvCHLbritquyB4cjEpRoWS6QaYDLP4tYZ7PVnxzHZKRqXQI76CIwFHK
 tRvPf3BsBtB6G1iHdoXB4jY5+gZtZ+9v/pgfkZTBZGMoCgRXrrepXJjtfkBsorI5562i7xJ7q
 j41mpbIJxrFpx9bpuZ4wx6iPAglUybgPFIZlLG8xxAawyBaf8YnwoUvZUlbFXorfBg6g6aAje
 RWi/LEFqbfhJC6r+vPNygXy7/E7sPDvF/9TnMzqL/ODINLfb7R2ug1ficYZQUCb6Bjn4n6fvk
 oGm2gD7KZpQzw4SPRzuPHMk0ifz0R4GbPytNBRjUohT4MBQT6ECCDoIDWx/kTtMVtpa46UdqR
 rpXKpgNl2EdddqzZRgPj9Cza02XBdtrrMYvn2gKDfYxygMjMQATzaDwid3ap2HyjwoFTO/XBo
 E0TfJu24HbCJ2KNaA/E16Tz4YJtvsaZnQxHQlOmhMIEos4VMMOyjjmfSXa9zkw5Jm8NX7RtYR
 djItdmi6gGRwnYP0g35vaaZqL23z9FD9maodw22fgVuQPix2zlQWJ7LHebEf78AY+eKiPTkkZ
 yvVkKUorNLvm15v25s+Hl1gQ5u0f3WR7kE2eZzm9qC92nlt1xnSn+pDQUHTjcemMaPMkEHlcP
 OYd/O7fv8dr5oDrbNXO7L3p3HSu3m9Okpru7hcpcsi3riXaZGCQqAKSsACH0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 27 Sep 2019 09:48:09 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Use devm_platform_ioremap_resource()
  Move the setting of mii_bus structure members

 drivers/net/phy/mdio-mscc-miim.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

=2D-
2.23.0

