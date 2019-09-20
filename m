Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785C8B921B
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 16:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387714AbfITO0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 10:26:08 -0400
Received: from mout.web.de ([212.227.15.3]:38231 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbfITO0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 10:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1568989555;
        bh=dtegyN4+XNVdQ37ed5eR83MzYQOOvPRpAtDsjkdmr6I=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=Ioacao/pNnbmG4TNqYUXCMwk5lRQEY3T3aozFWs9nVBJAEP679TusgYi9ztrVh7vM
         hqeLceizbbF3L81e32efGp6quAaG7kXD6c2epCA1BCQJSBjp5gmRFICvfr6EBQjV4c
         ktv5JYnjWccahYfbPekjby61OOE4Dc6F+xnnEDJg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.117.22]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LZvrx-1hm8Vi0Kp3-00lkAU; Fri, 20
 Sep 2019 16:25:55 +0200
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH 0/2] net: dsa: vsc73xx: Adjustments for
 vsc73xx_platform_probe()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <98fee5f4-1e45-a0c6-2a38-9201b201c6eb@web.de>
Date:   Fri, 20 Sep 2019 16:25:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yv/+pV2Pwje3PoBU8IEfLlcUUXTUtCpx23GLADc5Snng0Z4LdJ+
 tRtotViipok3Y2B7qZd28Gg+uuM7bYMKQWvjQLn1rUZwLq1BdACONi0kcoW0S9u7ucD/kaM
 lmAsfkU0KDGfv4iIigzx/C73fJmkWrysZqlJLpQX5QLbpnh/Mb36L3/yUlEz7rAgwfK06wh
 56F8r1eisISjWOSmKIOaw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:J8S7VHgNnr8=:9qSP6W3cqwXsBAB64YwDm8
 Edjn8KGWO5mHcgR4W7o+K1yBHHhKPv15temHCXY26VvHnBhxEgDpHJTvsjyx6uPaF+CIstF4R
 dNO/TTdCaqwhLbmTBn32ro6Cyg6VPIuvU5h+nG87uzHMu1xpN9jmRcqMyf6XM6kWP7DLDl94K
 GRpOUIxK+TsjL3ZS89sNlc+IQ8d9tPfBUkIr/GO7h3OZat9u8Xj2Y51sP/eZQltjdze4dJ1Px
 4aRxNc/wnsJ/zo5ysM9NclqzVWPEOYTnMT/AEo9EZ1vp7N2m5clgw3L+RYiz1Tt5V4kmljoqs
 BTqhFJ0ZXdo6NdWifYKTblR74shIeQU8pRB+KrIr+WWXe/Qvgz/uqP/9FKjaUYOyfUIRFHiga
 H194xLUg78Jc9oc8aQTNAw8sdSNnTdSlafdrO7be/+2ENtlv5PEWpojoePbI22JnLk0cJrrlK
 wrkBZYvAUYItnIg87u3hpKD5nJiXYdmencLwg7gclMXsHioOpDt6sOiVdvxkTNwR+qstJDEsX
 nWlfQxwNheOfVlbhCDdzwNac/UvOHhzm9yLZb0CuEVSvQn7yymKRO/kLEDbiRhEXJKwZ7woKX
 NTSAGwPGcccFfbATVoEQclv729UVVEl3E46uBxt5Z0ofu+SW9PalT3aslvlHnbU3NIsm+PQlj
 MD1D5wcN/AIDsTt+Fjk4AShuuIkHWIpDiX9SMJXCkflUfPrflCOJIOP3FMJphX3P9oVioz+2y
 OM4B+8rAZ/EM3xyh+SkNJBpvJQxZU999Phv7HiexITpEVO2q56LSNYI5D9HkyBRDckSp/YWxS
 7skdp69U54sMWPoWlH+HDiz2aXn3QncBqYVl720UfSohcwwLzCA2Fp619QHCCl8e7BWCg1AsW
 R8r4872Ao+DvsWGYZ0bnF+Yz+qKKx3Q9+1asjMipsvUKIUoYwywlgPIOV4PuU4v0UTbG4NWAm
 sFpqxrg9WB5isR5EHRvymZnjGwpQGcKI0+dqLChub3LE5ciUvxIpMm382/lSQeWo35ZcyDCDL
 Khl0ZCeNmQnsdHj5ox4h0jz3NB91N+2AYHLZvsS7eOVhdeqt1ezfY/rquPW5OmbwAO8RcW0nU
 mYrckPLDzVCoX9JW1rNwyBle1uJjuj2TaoRPxzcBRSzhBgL0Rlsr5zZneTgJqB0edBXiBCTjR
 +ES11Xtqg6M0K1klMU7+Z90/K6Al+DBp2gHnnCPJP1PJ+LrNShHUk59EDuZOxfXbZT6zhiW72
 eMCS7HPopLds4kOMW+wQXva9l3X4xRNcCE7HzET2SDgysJRQkBrHjlUX/ZKU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 20 Sep 2019 16:17:18 +0200

Two update suggestions were taken into account
from static source code analysis.


Markus Elfring (2):
  Use devm_platform_ioremap_resource()
  Return an error code as a constant

 drivers/net/dsa/vitesse-vsc73xx-platform.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

=2D-
2.23.0

