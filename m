Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4541BF9A0
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfIZSwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:52:49 -0400
Received: from mout.web.de ([212.227.15.14]:41591 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfIZSwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 14:52:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569523960;
        bh=xN+p/5OCq7JFB361Iwj0Dzg56oldc5duC5WCMkjPXx4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Jk//6vmBJf6eYadvCVXaG7vXQh45AvVi5AVcwgmhJ20nPUk3VBf+6MMk+FQ/cEMwd
         /boVamxLKmbuOnZzrn8QA0boKV7CnlhuNEOkwZB3gPjQT45xIpArFFEy+Tnli5zXON
         xFnr3rhEoiGkeBcCphawlNPjGJnYFnmdE5bUDNl0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.81.241]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MPHFI-1iHyiu1qcK-004S5G; Thu, 26
 Sep 2019 20:52:40 +0200
Subject: Re: [1/2] net/phy/mdio-mscc-miim: Use
 devm_platform_ioremap_resource() in mscc_miim_probe()
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <189ccfc3-d5a6-79fd-29b8-1f7140e9639a@web.de>
 <506889a6-4148-89f9-302e-4be069595bb4@web.de> <20190920190908.GH3530@lunn.ch>
 <121e75c5-4d45-9df2-a471-6997a1fb3218@web.de>
 <20190926161825.GB6825@piout.net>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 mQINBFg2+xABEADBJW2hoUoFXVFWTeKbqqif8VjszdMkriilx90WB5c0ddWQX14h6w5bT/A8
 +v43YoGpDNyhgA0w9CEhuwfZrE91GocMtjLO67TAc2i2nxMc/FJRDI0OemO4VJ9RwID6ltwt
 mpVJgXGKkNJ1ey+QOXouzlErVvE2fRh+KXXN1Q7fSmTJlAW9XJYHS3BDHb0uRpymRSX3O+E2
 lA87C7R8qAigPDZi6Z7UmwIA83ZMKXQ5stA0lhPyYgQcM7fh7V4ZYhnR0I5/qkUoxKpqaYLp
 YHBczVP+Zx/zHOM0KQphOMbU7X3c1pmMruoe6ti9uZzqZSLsF+NKXFEPBS665tQr66HJvZvY
 GMDlntZFAZ6xQvCC1r3MGoxEC1tuEa24vPCC9RZ9wk2sY5Csbva0WwYv3WKRZZBv8eIhGMxs
 rcpeGShRFyZ/0BYO53wZAPV1pEhGLLxd8eLN/nEWjJE0ejakPC1H/mt5F+yQBJAzz9JzbToU
 5jKLu0SugNI18MspJut8AiA1M44CIWrNHXvWsQ+nnBKHDHHYZu7MoXlOmB32ndsfPthR3GSv
 jN7YD4Ad724H8fhRijmC1+RpuSce7w2JLj5cYj4MlccmNb8YUxsE8brY2WkXQYS8Ivse39MX
 BE66MQN0r5DQ6oqgoJ4gHIVBUv/ZwgcmUNS5gQkNCFA0dWXznQARAQABtCZNYXJrdXMgRWxm
 cmluZyA8TWFya3VzLkVsZnJpbmdAd2ViLmRlPokCVAQTAQgAPhYhBHDP0hzibeXjwQ/ITuU9
 Figxg9azBQJYNvsQAhsjBQkJZgGABQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEOU9Figx
 g9azcyMP/iVihZkZ4VyH3/wlV3nRiXvSreqg+pGPI3c8J6DjP9zvz7QHN35zWM++1yNek7Ar
 OVXwuKBo18ASlYzZPTFJZwQQdkZSV+atwIzG3US50ZZ4p7VyUuDuQQVVqFlaf6qZOkwHSnk+
 CeGxlDz1POSHY17VbJG2CzPuqMfgBtqIU1dODFLpFq4oIAwEOG6fxRa59qbsTLXxyw+PzRaR
 LIjVOit28raM83Efk07JKow8URb4u1n7k9RGAcnsM5/WMLRbDYjWTx0lJ2WO9zYwPgRykhn2
 sOyJVXk9xVESGTwEPbTtfHM+4x0n0gC6GzfTMvwvZ9G6xoM0S4/+lgbaaa9t5tT/PrsvJiob
 kfqDrPbmSwr2G5mHnSM9M7B+w8odjmQFOwAjfcxoVIHxC4Cl/GAAKsX3KNKTspCHR0Yag78w
 i8duH/eEd4tB8twcqCi3aCgWoIrhjNS0myusmuA89kAWFFW5z26qNCOefovCx8drdMXQfMYv
 g5lRk821ZCNBosfRUvcMXoY6lTwHLIDrEfkJQtjxfdTlWQdwr0mM5ye7vd83AManSQwutgpI
 q+wE8CNY2VN9xAlE7OhcmWXlnAw3MJLW863SXdGlnkA3N+U4BoKQSIToGuXARQ14IMNvfeKX
 NphLPpUUnUNdfxAHu/S3tPTc/E/oePbHo794dnEm57LuuQINBFg2+xABEADZg/T+4o5qj4cw
 nd0G5pFy7ACxk28mSrLuva9tyzqPgRZ2bdPiwNXJUvBg1es2u81urekeUvGvnERB/TKekp25
 4wU3I2lEhIXj5NVdLc6eU5czZQs4YEZbu1U5iqhhZmKhlLrhLlZv2whLOXRlLwi4jAzXIZAu
 76mT813jbczl2dwxFxcT8XRzk9+dwzNTdOg75683uinMgskiiul+dzd6sumdOhRZR7YBT+xC
 wzfykOgBKnzfFscMwKR0iuHNB+VdEnZw80XGZi4N1ku81DHxmo2HG3icg7CwO1ih2jx8ik0r
 riIyMhJrTXgR1hF6kQnX7p2mXe6K0s8tQFK0ZZmYpZuGYYsV05OvU8yqrRVL/GYvy4Xgplm3
 DuMuC7/A9/BfmxZVEPAS1gW6QQ8vSO4zf60zREKoSNYeiv+tURM2KOEj8tCMZN3k3sNASfoG
 fMvTvOjT0yzMbJsI1jwLwy5uA2JVdSLoWzBD8awZ2X/eCU9YDZeGuWmxzIHvkuMj8FfX8cK/
 2m437UA877eqmcgiEy/3B7XeHUipOL83gjfq4ETzVmxVswkVvZvR6j2blQVr+MhCZPq83Ota
 xNB7QptPxJuNRZ49gtT6uQkyGI+2daXqkj/Mot5tKxNKtM1Vbr/3b+AEMA7qLz7QjhgGJcie
 qp4b0gELjY1Oe9dBAXMiDwARAQABiQI8BBgBCAAmFiEEcM/SHOJt5ePBD8hO5T0WKDGD1rMF
 Alg2+xACGwwFCQlmAYAACgkQ5T0WKDGD1rOYSw/+P6fYSZjTJDAl9XNfXRjRRyJSfaw6N1pA
 Ahuu0MIa3djFRuFCrAHUaaFZf5V2iW5xhGnrhDwE1Ksf7tlstSne/G0a+Ef7vhUyeTn6U/0m
 +/BrsCsBUXhqeNuraGUtaleatQijXfuemUwgB+mE3B0SobE601XLo6MYIhPh8MG32MKO5kOY
 hB5jzyor7WoN3ETVNQoGgMzPVWIRElwpcXr+yGoTLAOpG7nkAUBBj9n9TPpSdt/npfok9ZfL
 /Q+ranrxb2Cy4tvOPxeVfR58XveX85ICrW9VHPVq9sJf/a24bMm6+qEg1V/G7u/AM3fM8U2m
 tdrTqOrfxklZ7beppGKzC1/WLrcr072vrdiN0icyOHQlfWmaPv0pUnW3AwtiMYngT96BevfA
 qlwaymjPTvH+cTXScnbydfOQW8220JQwykUe+sHRZfAF5TS2YCkQvsyf7vIpSqo/ttDk4+xc
 Z/wsLiWTgKlih2QYULvW61XU+mWsK8+ZlYUrRMpkauN4CJ5yTpvp+Orcz5KixHQmc5tbkLWf
 x0n1QFc1xxJhbzN+r9djSGGN/5IBDfUqSANC8cWzHpWaHmSuU3JSAMB/N+yQjIad2ztTckZY
 pwT6oxng29LzZspTYUEzMz3wK2jQHw+U66qBFk8whA7B2uAU1QdGyPgahLYSOa4XAEGb6wbI FEE=
Message-ID: <0a1f4dbf-4cc6-8530-a38e-31c3369e6db6@web.de>
Date:   Thu, 26 Sep 2019 20:52:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190926161825.GB6825@piout.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FW7oPWJvZiXJxSXbN8g5Z+LIu5czpM2Hablpz5u2piawnl6iGA9
 2ZLuyWev+N783dVLGZJlQgrIbtqyJxPDzOOSSChpE0j3+MmorFm6IYrtEYh7X4+Q8vjqoAH
 7IWEnf2zWDTscSPpAGAoTrhlYRAj63ce2beLYPsyyxVABP8HlzVTkQKcebtJNJWrwKAvpFw
 6LcZb2au5yQr2BLuLVAeg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Gimchof243k=:qo/1X95tidx3mEqPIxw0cJ
 Ux5ENHeZ2iPB2DjPk07jt2615u+/Rl1WFCganOTdXJ2qg//lGkq+9Ys0YFbLHB/WiW58VYVCo
 WgOcqNkl3X4qV6sZobkyxHtt0jULe8PoTBPV8tWl9pVvzHsVVZeLNHJ/PrCyuzXjn+cRUYyy1
 160NTCDrr+lIkwiZtUwe5qOC8Puk4adbUH97F5Ucj+4gpCnZ9UEbpr/sQ4Xi7kx/7yOy+moLA
 F6fP+ipgvuc178/CGQxZ5DgkGKn4tVjdJmr0DpqNAktuUyqxSbm69Mg4OWJDbylwMTS4G83UD
 YNljrnJl0eKq5/HSKtRbcp26Gdh7CcYyB06Q04Vj8Lm7mUUu5ay2wOq6xbcJsMzLVUqA52Et+
 A5adX4q4J2UI5veb104KxjFXin9AFJe6yR8mYlq7aeT9/ZFdDu9KG9p1agK6BL5LqugmWF1ez
 7Y/OQPqcmcYVKhHwZxVtFTChYWDc6Ai81X4/emydaPJ193R1Iz3uMjhQh7oz+xLkEqQvHSPRH
 EWWJwFk1LfMHT4b4l7oREV+f1BHYrdeWkTAQMBbUps4zOpEiVSQBr63WF9EoSbrGzQyNVHn9i
 PSOJcjRBDigF2qw2NicKAF1E6V4OPzacUvefV6RPjLa1KsDAKHm4zwN0KzdqZsxzEWWX99jhq
 X0wOPf2TNd7nsflfPKPqM9OMKhWmJUh2ghSmpAH3Yp15eOntUdDMVIWgXPPL/zWx6Prm1ok17
 jdX4keZVxfUzXzVIdEQED6EL97eBOvnmndOinShNvJBwliGPWmuHEix8G6advAobzsYcvBMCk
 eTom1Yq1xC1BuryO1yRHVZ4tTdzOfJPElWH0lTkutzdZcqjwF/ldXLwEOZur+QFM6ICG6NqaS
 fA+TcWLzf6MN7wkUFbk4CaGMF510CpUrGFp44/0lV0tZ01QNU2ivfztPegKwJoa+OjdzqN2Oj
 jeCkBvGjuizxw1AJb9UrCgxcxWsZg5BSPj7Y5oDuqMHl7VJe6kwSwrH+wP4wbznGSolQ5tMe6
 5A3iUBA2s5tQ9oNGASHFMdLY7rGXAvW5K+6gmmgyuDT4ZFhQptc8nGUkOPRzgOnH2yC2DCTdw
 xXHBHy1frpO8z9FImZ2qTgjg0fhCibeWB3p0McY0a3r6CAETrkHKSECXrLrPmu28OlV/iZf6f
 8eiuSfZqdj1ka10NMEE0BSmq409sBNT+c6XqJfiSv4aJ2rLFxwn67WuT/LCmj8n3bDgOVIzhb
 2QP2hHnUt9wx5K2eYPzis54+g/3m844VTc7BTP7FhRAjS2y/J/ChBu205EiM=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Does this feedback indicate also an agreement for the detail
>> if the mapping of internal phy registers would be a required operation?
>> (Would such a resource allocation eventually be optional?)
>
> It is optional.

Would you like to integrate an other patch variant then?

Regards,
Markus
