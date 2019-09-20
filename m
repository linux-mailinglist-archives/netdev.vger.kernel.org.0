Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495B1B977C
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 21:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406690AbfITTAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 15:00:37 -0400
Received: from mout.web.de ([212.227.15.3]:39253 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405208AbfITTAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 15:00:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569006024;
        bh=5xwqHg64byu80G0cmgQ325jH+mwYDqd5Pno/t33K0b0=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=UuwzX0ciddejRM+QGvTLg+Klc4rxjgYJARAWNP2feTT0WJ9a4Yg2keaedm1BoRtF5
         Mnkdrz3QLxT0pHECcIOmvgGrxGuBPdecpM4VHieAFQ8rey5r17R1okzq8hOqFmS1jQ
         uqHPtkLRTCWh40+AeN9fb8YzghqtAkquo2MZkq8Y=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.117.22]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MRl2f-1idkli46ED-00SyeI; Fri, 20
 Sep 2019 21:00:24 +0200
To:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH 0/2] net/phy/mdio-mscc-miim: Adjustments for mscc_miim_probe()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <189ccfc3-d5a6-79fd-29b8-1f7140e9639a@web.de>
Date:   Fri, 20 Sep 2019 21:00:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xRnoPAo7xEhIJ5ZcmH2qZ4WOjEpYAkWC26S+oyaFya8XLbMupQl
 NUMASdQ6kluJZpqpO6c3O9HH9P98V6oBDh7/peBRLVcG22QXOIE4xnm3GHHYbYOanUsSL1x
 2b+JcKUTa8k9eJuHPAJWc5ljI0L6kN6UwSERJFgic8AQQRk0xGYUDQu90fWYaiuTu0F+g3O
 V3xh6PSimqPHGJuyd0cXA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tJIycuQYSkY=:8y84WTmFB4xEG8VXX0QfUQ
 0oFbxsNkdhrdIXG5HsXjCjBWVGYsCVxGKO07Hgzz4xcyxk0jn8PmY6Z06jpULq5QI5I/5E95e
 X07RqwVc3yDydCJUAea/4jnsxM/+XKDg8Td/k6ktLpiL9mUcrCaoQmOm1MHd10xrUhBNfEXHe
 v0qxNELgxOpY4WKgnLFXS6iEqBaTR7liYH9KmEGdIeCQ8haVn42QODr3jpQKWsQoKQ7ee/G7U
 CEXlGFRbRNei++hkJCZyjRIwSh37dX+iarT0oRDofk3popWKGg1oQQ7XXtuKlBijMOdouqEq6
 9Kaj9ZuHPhhH7/rMcVZa2Kvp+E22flxWO1XyIidNWnf6yG8V6V6IieZ9+v8BgP3QD6EgpayWx
 k38oTOPi7/jDaFB5ZzA3wQCP+T7E0tyWX10WUpb7Ez2QxzV1Y39MPzTVLFVBxzy1OfVYOmJtW
 /ztKQLlessCUycfDr4r0ckVNbZ+pWD4dru0lB9ccX1vEhD6+joOBimHTQ8GzP5VtxSbPw3IGC
 ctL4Y8l+cBtXGc3C6PuvOVDk394xyLu+7wFWmQ0BCYg9NjElribNAA6t1GceX/1qlSPhUOltZ
 jDwWuFPOKcvGEzS0mkSJh/WfkFhZXDhyqd+1C16Wh8oXzvfBZYkuZN4LgfjBupvTJdh1PO4t8
 5zvfu/Jp+q+X+jIYHDfIiLnF3IvGQd7WsKUxLSOH/da2zzZXeJYbBDFH8uTk1EglPMfGvC1SU
 dhxmxfqTa16gMXCbhSco66TOG8DG8iqbfuErZ3D4EIzWXiRrffgr/p9fhn5Shv4Mjq5qVoSsu
 ZR4eKyVd7CMMyF6+nfkxuTUmcoCKG7Co6zlgOqpRAg75EmrBCIx3hPmkLv3soPPncG1avPSRj
 vy6W3EvcyXQLlYzRKqVfZfhxZ4AM6C+qxOWQxYIvsIJN+adLPlRalU63XV4tg30ieJjXjVsId
 1jfXNs949DGqPsZPBWhw6QRLK59Rm5TkUVAVtmYijZyPb7PEVYMpfTfdhMZvgsicfeh8IaQfB
 X2Jpj7KjNJuMsXBl5Z0CoPwoGKPZAg7o42rHKMExy/H9o2aHLga+DxRwrRCmCC1s3jGXC+pVF
 EXVkU9YotS0kY9UlNa2xtEs59nT/bcv2RQ7ebqsOeNHl32LAQ/M8TZV5cjTfBh32I5KcWtkc+
 giHDoi5WcYqaj3k38/ESfmpuVJ449unVwqc3JSjHsNVmY4kOmP58CHWCVdYEGdpFnOGu1W/g0
 drHZ3Wjtluw2WHm6phb4lMYclP4jM0GhkpJpbvHfZ7gHc6/niQ80QE9RnhPk=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 20 Sep 2019 20:52:25 +0200

Two update suggestions were taken into account

from static source code analysis.

Markus Elfring (2):
  Use devm_platform_ioremap_resource()
  Move the setting of mii_bus structure members

 drivers/net/phy/mdio-mscc-miim.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

=2D-
2.23.0

