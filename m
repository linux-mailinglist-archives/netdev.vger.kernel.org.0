Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87E6BF5E5
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 17:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfIZP3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 11:29:24 -0400
Received: from mout.web.de ([212.227.15.4]:45227 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfIZP3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 11:29:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569511753;
        bh=z3a2zT3Fyaevm06leJAon5Y5SGGHkjpRtvTfdrw6efk=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Ha5fSblRqiAyG+IN2pdg8zuHlLaeEF8BS1UYHfyO+5HpQFXPOh3YX2iL5j60rEwVm
         G13PVxLOl9rYQ1j2KZRG5vp5r0AgloRo9PLi870lwNhJDo5EiIVzx/wzdT+UDJpJb6
         lfzoP9H4PUnDWDjM3Q6rPiTiSSYRGNnm2oxr9a3s=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.81.241]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MP047-1iHci61aZL-006PjL; Thu, 26
 Sep 2019 17:29:13 +0200
Subject: Re: [1/2] net/phy/mdio-mscc-miim: Use
 devm_platform_ioremap_resource() in mscc_miim_probe()
To:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <189ccfc3-d5a6-79fd-29b8-1f7140e9639a@web.de>
 <506889a6-4148-89f9-302e-4be069595bb4@web.de> <20190920190908.GH3530@lunn.ch>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <121e75c5-4d45-9df2-a471-6997a1fb3218@web.de>
Date:   Thu, 26 Sep 2019 17:29:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190920190908.GH3530@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:V8JTcGGBM3baN+wenwNNCBW7Mas/rhq1A0Ja+RzGKVnjPbUQ2Gk
 pgQosy8Cio3nIzTAS1OMsVOyXTyedJNK5Ps93D0eh6A3vHdgpI9fy3GdfwDD+hZBrOhKDkI
 cZ1CQ/ETy/AAURvWKMXvgluUCFoLl9ED6TJWUU4DKCHhnIauXEPn5WCQ3WIyNeFOVQ3qAC1
 6OmnK1xuW5NXnUf8F9wFg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:YLztFb1NFno=:olrVmny85Nhik+A+du79xX
 Ch8mzZFFJUEMVanlyslfmlMJEAA/tE0wZxqT5kv0W4NX4UMQxDAHBv30lzEYk6eLGZUk+94W4
 QDe4IZ1luORy0YnGLnC5a+RGiFrWtfWOS13gLbOL+7hsHTwU+/4KX6gX2Xf/uFSnitng2sGct
 Ohqgb2SH0S2JL1CAQMz/rhi/MtDoK5zOGTnsOxbc7J/TtmixPqNJK1isVKObqrFl9/tRRYf0P
 bEaqW7XGqHosbtnPFmJe2WN7vOhnLHzEW8IE6O9cUm4ppp+HQ+Kaeer3VpypL6cTHKRB0YoXu
 iDUq96sKIhSTu2mnQ9QY4Kt+E4aLthtdDsDIQmfWuSmJBIkJiXjUMFbTGD5AoQU6JZLztYOCM
 DRoBm0zo6zA3Y6sv5SnXaabeOllnSM7Ru8yQLOCiYxFvLXDjhSE2tPYEUzqwtKudz3OP+ssPz
 fp2TQkBM1mSjEi3hcSRK0cGxxR7KIVkZo+U/BQBOoHUiG2IDAE+OLPN6g36ToiYOM+4uh6f5u
 oT65OVuI2C/sQkiBAb/1lv8l6BHFG4lnr44QVLZShYXx81+pG60gck2eBPuXqlBitJ43nZBGJ
 8XW13oCIp6gPnHhmrCGk+Io6QB5C1QxX+NBB56tUCVNowBIJsfar3e67cSw/+4dXIhn/j1eK4
 ZzIw9wL1a21TmgpETq/QKytvZcvNk2RYhYraxc+eO4hEJ2B5ceWq4+UJCT15wYevMpeOG7LFt
 MfoK8y8Wpt7M28yAb4runXY32w/URsb4eEI3KubUO5pz1hozhmfFY/XxzUlH8+LvaTj+xVbXw
 pjlGQqCwwmozaihQKCc8CnDpywqfkSxvX9L49RY9B1/3lC9qAQ7qkJakoUNP9aGwfJZEA73Mp
 Zpi99ZvVA+hDmwRqb9Ai8dY2g2LV7CrQpCFbjJex1Hq0z/c0zyJ59QQNuHGIAk2TpVe7lzBmj
 WsO0KX+IGe1gT14B7h7XFJ5hTqST/BwtqlSrwuxwFurt2ZCo2btUr6y+gQ47ohYvGfTAuC8uy
 6sur7NfMAd665lU27O+H0arpSfGghBvr/J7mjXjnsPgzxA+plrUH2u4+OOg2ZR1RsRr49XmEA
 TlURyyKr+d8labsVdz34zOgKtwlMdJiqny1jKKNvwIK3gq+TYDZK+TFnHBsdA0nwibPuw7wDa
 LrqEgycSP5IQqBWv7WarzJCHl7JvXOSrMsZp0OZs6VxQCUA1IunkLZwEgC8RZ31wvXbpkVF7Y
 PBIx6XGNl7FTiHesnFChS9Q0i/eT4ECiiIwib4Nc9eYG9QuHYcGImYg9pHGc=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Simplify this function implementation by using a known wrapper function=
.
=E2=80=A6
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Does this feedback indicate also an agreement for the detail
if the mapping of internal phy registers would be a required operation?
(Would such a resource allocation eventually be optional?)
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dr=
ivers/net/phy/mdio-mscc-miim.c?id=3Df41def397161053eb0d3ed6861ef65985efbf2=
93#n145
https://elixir.bootlin.com/linux/v5.3.1/source/drivers/net/phy/mdio-mscc-m=
iim.c#L145

Regards,
Markus
