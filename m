Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89528C0625
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 15:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfI0NPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 09:15:23 -0400
Received: from mout.web.de ([212.227.15.4]:38389 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727376AbfI0NPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 09:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569590108;
        bh=77LlS4dssunQjdsq0f1LknYiQqkHDEPQzLkskhHSDyg=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=KCGDieftIA0oVt/RDKgSoTMzao3B7rAHThu3zW87ao36zLEMezBdrmNLTj2XofU+/
         0v2JOWqfzckPOqw/nkUxFhbhU4aJoa708rKO+Yhm6aEyqLimhSXhAW0SPr0oymcwuz
         KJULyD8AR/35F2m+9Gyd1tSBOskmPSVsmWLSY/OA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.191.8]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LnSKE-1hfL8s1m3i-00hbxm; Fri, 27
 Sep 2019 15:15:08 +0200
To:     Paul Moore <paul@paul-moore.com>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Stephen A McCamant <smccaman@umn.edu>,
        "David S. Miller" <davem@davemloft.net>
References: <CAHC9VhR+4pZObDz7kG+rxnox2ph4z_wpZdyOL=WmdnRvdQNH9A@mail.gmail.com>
Subject: Re: genetlink: prevent memory leak in netlbl_unlabel_defconf
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
Message-ID: <c490685a-c7d6-5c95-5bf4-ed71f3c60cb6@web.de>
Date:   Fri, 27 Sep 2019 15:15:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAHC9VhR+4pZObDz7kG+rxnox2ph4z_wpZdyOL=WmdnRvdQNH9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rjJKQfBm9V5MbGJysp5lHeJ/MAt7se96rJzW4qvj/ZsuJblz24o
 LZDmhOPv4CQDyOOo/4gyDYqNm4Z1NFIqRpW2I6SqE9YlqX0mXzCtYPciMJF1SAfXGON3fRX
 i943t9/SUZTW+tPhyqtZ9HMT3ipRkcsa/yEl8Mq6Jnk3G1IzZlbEv5GazNUGqWGe89rgcFm
 NGLvvHGH4Y0207mWz8MkQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:o+CJJ5F4WQ4=:I0dAVsJcWpFwoSvsImSEj3
 gLBfrADCxSttv7bU8vzswnSFRtcFOgTJkY5A87mn7g/2aPXvO0KFMVsl+ewRlSbQSRLp10sC9
 av0cIh6POV04/slLQ1BpRHG1wJIq2epj7jsDt59nIJsrGS66QRIqQzaZC1DtcaaFi8qUWQ2TW
 2PrImgFVfqp9osEqzJImnMgxC7ceA2hM1vHh8pM5pAmpeJrYaKH0UjBRpn6XXgajlEOATWXLd
 BuXpqxPlb/ziaLtt7Pu0Qs2c9wXCQO7ZOx/xl87azI+Ff5F8jMtYkvyhUosZ3T6uBXBGACntV
 APyp69YKwInn5QsH4p1+voPwZf8+SD4jkGeG6v5OztMqVLWcY2sUKpR/5lzIbrwEy/m1XifjA
 cd1hUix0+JG3ZftEe+sZLS55Bi0wAI4M1YwR7cNOkBXjlZ2C8OinSM8jXW+wqcHavMc81bky9
 AQ/WEANaFRpiYugcoEFVbXIKsXoNA9xdh1I34nKJzYBy7kP/TyTA8oAX9A1q2SCqOWUtzW6VB
 ZoOTCuVBdPZ6fM2Ub2WiZ23WJogqID8ghL6Wnjr4F7FNlKdRLCHOb9GBxoCG+omlTNwUc3Uza
 UJy05A5CG7XODDMpofPooNVe1Q6+V1cWdzgNj5+PFmku4+9DLbjG8zGd11xL6PpE8AZs7rS9c
 eu2xJZXVzJjTVWVqF5LvPIlZxnvMBVnHjbyi+S1neNFOQtDnyeNT/ogwZZZWYU7C1odHDne33
 zLQlBOQnBoExJ+2kZZZdNhe9IWxAFb7mL3OuDdSs8g7e+uvmmw3Lj/7af262UJrnpYUya4hEG
 MlIFiz3GcSxdTrFDLLHLIHQP0qC1UG42Y1XM8V+w/0NAzWdZ46vPSw8rdPz97B2sZs/5mgjc/
 lOsatG2KntyZZJtI73bsY5rpFrT3JxggxgZB7JICYUJnWGj6lUu9piRGCTZAILFv0dfCK4LEz
 pC+yh6xpmb2UcJnzBeSynHCiYD7V2H3uWar9YCfTQi1yXJF/zywwwXURoJiqm1JSK5FrxLOLx
 ALTy/FUmoqCBCVsIV/iJNt1yQExOaHInsWl8Br5U7wqoroxV1YLDfoxNQiMyPAAS+P3i8gqP5
 0rjiarFfYQAD7Q6AouXQZH22FWxQQgjiOSAky4KetyWPfA/zqlQevNUrUzMAYRzqn5pOrFi70
 BO17g+PatdZ6+qW1typuu43jz4tGF2ljuRXSsJ/HeGv9p/zZXlQFyujzuQqrQxsREVamGbgLO
 1+vPCHgu5582fkk/5wNZbGhhsLP2rOD8xeFHmbXLlGa/xjDNRkdtFSsjvQG8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > In netlbl_unlabel_defconf if netlbl_domhsh_add_default fails the
> > allocated entry should be released.
=E2=80=A6
> That said, netlbl_unlabel_defconf() *should* clean up here just on
> principal if nothing else.

How do you think about to add the tag =E2=80=9CFixes=E2=80=9D then?

Regards,
Markus
