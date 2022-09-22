Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3055E637B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiIVNWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiIVNWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:22:05 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E04ECCD8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:21:59 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220922132154euoutp01de2ff00370c40a73be8df715f02262c0~XMWkaJJ-71442614426euoutp01_
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:21:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220922132154euoutp01de2ff00370c40a73be8df715f02262c0~XMWkaJJ-71442614426euoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663852914;
        bh=E1JCROI3L2SYyPYhxqQF43MFG11NRDGK2z19cxzjdVM=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=kop8l5+AiZGtLSLjHyQKbElzL4/eMTxV9bjH60hP9RM1vq1nbN9FzttqrAxuI42nt
         6U3Z0zlW6fGYadMc87a6ekFxeVRdxE3qMfofOyX/XmyfwsonqXg5K/wblLfxbkwgjh
         OwAqh27zbJYEXzbe1U81HRKceJaFY9lAJugQGIZs=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220922132154eucas1p25272b8c2c06cbf446dde2105088a46a0~XMWjzp6bV2512625126eucas1p2X;
        Thu, 22 Sep 2022 13:21:54 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id D8.E5.19378.1716C236; Thu, 22
        Sep 2022 14:21:53 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220922132153eucas1p2d162c09637e46611324bc018df28b776~XMWjJelJ22674726747eucas1p2V;
        Thu, 22 Sep 2022 13:21:53 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220922132153eusmtrp12fe2d9c55bb7c9eb5d22d190be0a16c7~XMWjIWCv81838618386eusmtrp1W;
        Thu, 22 Sep 2022 13:21:53 +0000 (GMT)
X-AuditID: cbfec7f5-a4dff70000014bb2-d4-632c6171484c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id FA.66.07473.1716C236; Thu, 22
        Sep 2022 14:21:53 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220922132152eusmtip2ec03fcc237b0d520baa3d770aa163913~XMWiBJevk2250322503eusmtip2o;
        Thu, 22 Sep 2022 13:21:52 +0000 (GMT)
Message-ID: <373b0f34-8154-e4a3-208e-3b52e59cb932@samsung.com>
Date:   Thu, 22 Sep 2022 15:21:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY
 interrupts to PHY driver to avoid polling
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20220918191333.GA2107@wunner.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf0xTVxj1vvf6+qire1SEO0SZ3XABNoRtWW7EOFE3X/xjcXH7hyzbmvpS
        yKCaVhQ1W6oIYkMUZAiWCo3RImWzwBgrJDRQCd1oZ2WMhWJh/KZ2QCkFpOjsVh5u/HfO953z
        fd+5uRQu0pPRVKb8JKuQS7LEpIBo7go8eEsheVOa7JYjbYGTjxyDFhxNOgdIpHVcJNBE1ygf
        rcx28tFy1X0SOcov4OiWt4KHHI56PnrYfIWHxuv0GKpwmDF0S5+PI0tZG0CdCwYCuae2ouEe
        NYG6dJFIPVZLIl3+BIGWbNMA5c17MPS0pIfcB5neP3pwxjR4GzBNtU6MadEM8pk53+eMrjGH
        mSgu5TONhssk0+kcAUyLyY8xruU7gPGa+0jGOevBmWBeL8EYm/oIxt+4/YgoXbDnGJuVeYpV
        7Nr7pSDjmUFHnqh7OdfeFiBVwPqSGoRRkH4XDvSbeWogoET0XQBLbAU4RxYAXP61lM8RP4BP
        liaJFxb74BDJNWoAXHQNrfl9ADaXaIEaUJSQ3gsfreSGDAQdB43To7wQFtLh8Jcb46uDttBS
        qOnqAiG8mZbDv5yGVQ1OR8GB8WoshCNoMbzw7SwWmo/ThXzYrcpbNZB0ClTPqMkQDqOT4FhR
        C8aZY+FPM9rVDJCuFcChwPckd/ZB2B9cWouwGXqsTXwOx0BbaRHBGS4BqHv6J8aRYgBVUwOA
        U6VC14MVMhQNp+OhsXUXV06DvvYhPFSG9CbYPxPOHbEJXmsuXysLYWGBiFPvhBrrvf/Wdjz8
        DS8GYs26d9Gsy69ZF0fz/14dIAwgis1RZstY5Tty9nSSUpKtzJHLkqTHsxvBv1/Z9ty6aAJ3
        Pb4kC8AoYAGQwsURwkpXvFQkPCY5c5ZVHP9CkZPFKi1gK0WIo4RkRYJURMskJ9mvWPYEq3jR
        xaiwaBW2e1xq/GDOvC01rSnw/g7nnsxXTTsK5z/eWX363ket+Xc23I+u+fry0sb6vniVOyts
        9NqwZ9sBJvFxOu155EqJGfN3BPa7zqdPd9uvJrZpvPbrUQvzde99+vPhQ4+vVl6MFNTXnGkJ
        5iYXmJODCb/7w6wRsrKF2z9oz58zKhZny3+0BJcnb95sqDJWuRuOwkN5r1R2Xo+b+vuou9y0
        vei7cL3NJxsJtnqf2yPHruzjdej2O2EvrdZ4JbEfnpvaMldXnBo3eWDk7Ibu3YveFm9iO2GX
        3dBb0tIzGsq+GX49ZmPi4bc/a/vE7D31Rplx5jXRJSnRbnoWbSo42O85Uh0bF2F9IiaUGZKU
        BFyhlPwDf5vYczkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t/xe7qFiTrJBo++iFrMabvJbnH+7iFm
        i2c3b7FZzDnfwmLx9Ngjdotf746wW/yYd5jN4vz0JmaLRe9nsFqcP7+B3eLCtj5WiyerlzFZ
        zDi/j8li0bJWZotDU/cyWhz5sorF4sVzaYsHF7tYLI4tELPoerySzWJB61MWi2+n3zBaNH96
        xWTxe+JFNgcJj8vXLjJ77Li7hNFjy8qbTB47Z91l9/jwMc5jwaZSj6cTJrN7bFrVyeZx5OZD
        Ro+dOz4zedz5sZTR4/2+q2weN9+9Yvb433yZxWP9lqssHp83yQUIRenZFOWXlqQqZOQXl9gq
        RRtaGOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJalFunbJehl/Fm1gK1gNX/Fmb0/2RoYj/N0
        MXJySAiYSJy5e4+ti5GLQ0hgKaPEk5vbWSASMhInpzWwQtjCEn+udUEVvWeUuLmxDaiIg4NX
        wE7i9q8KkBoWAVWJ9W8egdXzCghKnJz5BGyOqECyxJKG+2BxYYE8idPNb8BsZgFxiVtP5jOB
        2CICShJNU94xgcxnFuhjl2hauo8dYtk6Fol/b38yglSxCRhKdL0FuYKTg1NAT+Jxz04miElm
        El1buxghbHmJ7W/nME9gFJqF5JBZSBbOQtIyC0nLAkaWVYwiqaXFuem5xYZ6xYm5xaV56XrJ
        +bmbGIFpaNuxn5t3MM579VHvECMTB+MhRgkOZiUR3tl3NJOFeFMSK6tSi/Lji0pzUosPMZoC
        Q2Mis5Rocj4wEeaVxBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTD5
        HAuyP5lfWqWybtrUrmcqXv8aRQ6U2yer5Tm6ZX1+lLfse1zHL8Fog91eBa8uHYp8Yth7i+t2
        pMRE2ThLR0354FuzH2in2AvmuXFeDymY//Bz26y61n+fxBVEFXNjeipfss0K0O4okzzd/cCn
        Jf7dy+snPqxIsb0woXOZb+HHz0vW/s+4fLNLcrFHqNjD06e+fly5q/bR90uv8j768PndeREW
        Iht4NTTi2IdAMxOTZw6JK455rgj3CZQwLOqpUYlz/jbzRBwf775Wq1v+nt0SyT3lbd1WoWsV
        n21iKDy4qel+VNqKrVO318bWPV/lZPHticrUL9ZeGtnH/Xr4WBgnTvBMfFR05ynnWZMJT5RY
        ijMSDbWYi4oTAaEwDfDMAwAA
X-CMS-MailID: 20220922132153eucas1p2d162c09637e46611324bc018df28b776
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99
References: <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
        <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
        <20220519190841.GA30869@wunner.de>
        <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
        <e598a232-6c78-782a-316f-77902644ad6c@samsung.com>
        <20220826071924.GA21264@wunner.de>
        <2b1a1588-505e-dff3-301d-bfc1fb14d685@samsung.com>
        <20220826075331.GA32117@wunner.de>
        <093730dd-2f2c-bd0b-bd13-b97f8a2898bd@samsung.com>
        <81c0f21f-f8f1-f7b3-c52f-c6a564c6a445@samsung.com>
        <20220918191333.GA2107@wunner.de>
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.09.2022 21:13, Lukas Wunner wrote:
> [cc += Florian]
>
> On Mon, Aug 29, 2022 at 01:40:05PM +0200, Marek Szyprowski wrote:
>> I've finally traced what has happened. I've double checked and indeed
>> the 1758bde2e4aa commit fixed the issue on next-20220516 kernel and as
>> such it has been merged to linus tree. Then the commit 744d23c71af3
>> ("net: phy: Warn about incorrect mdio_bus_phy_resume() state") has been
>> merged to linus tree, which triggers a new warning during the
>> suspend/resume cycle with smsc95xx driver. Please note, that the
>> smsc95xx still works fine regardless that warning. However it look that
>> the commit 1758bde2e4aa only hide a real problem, which the commit
>> 744d23c71af3 warns about.
>>
>> Probably a proper fix for smsc95xx driver is to call phy_stop/start
>> during suspend/resume cycle, like in similar patches for other drivers:
>>
>> https://lore.kernel.org/all/20220825023951.3220-1-f.fainelli@gmail.com/
> No, smsc95xx.c relies on mdio_bus_phy_{suspend,resume}() and there's
> no need to call phy_{stop,start}().
>
> 744d23c71af3 was flawed and 6dbe852c379f has already fixed a portion
> of the fallout.
>
> However the WARN() condition still seems too broad and causes false
> positives such as in your case.  In particular, mdio_bus_phy_suspend()
> may leave the device in PHY_UP state, so that's a legal state that
> needs to be exempted from the WARN().
>
> Does the issue still appear even after 6dbe852c379f?
>
> If it does, could you test whether exempting PHY_UP silences the
> gratuitous WARN splat?  I.e.:
>
> -	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY);
> +	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY &&
> +		phydev->state != PHY_UP);

Yes, this hides this warning in my case. I've tested on linux 
next-20220921 with the above change.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

