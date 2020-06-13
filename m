Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927491F8156
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 08:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgFMGgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 02:36:45 -0400
Received: from mout.web.de ([212.227.15.14]:35367 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbgFMGgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 02:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592030197;
        bh=k2s8eb/2vmpIhCxWfTUYQO1d5bc6ZGIHEINUn8mcBYQ=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=msaEkurVfCeRrfBBs54vvu/2RGA7GuFXJ2bc1z9hznAefBtdBgJKFFXlEajUZ8fg4
         1YZrI+JCRT+3bi1f0Y1mkUi7LTbjVa4ws+2KLdldrB7hrvDTAOF2w4VPZqdNPc7Xrk
         PZlFow25j75aXyhQtt9cVbdaAAv4VqEmRjE9NYOg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.51.155]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lcxfc-1j26J30RHM-00i9RM; Sat, 13
 Jun 2020 08:36:37 +0200
To:     Aditya Pakki <pakki001@umn.edu>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Kangjie Lu <kjlu@umn.edu>, Qiushi Wu <wu000273@umn.edu>
Subject: Re: [PATCH] test_objagg: Fix memory leak in test_hints_case()
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
Message-ID: <d248479f-7209-d8f8-6270-0580351d606a@web.de>
Date:   Sat, 13 Jun 2020 08:36:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gaX0WJqFoqG8TGAHIdw6lVhq+HMK45m/5S4T0Ei2rPskxBk464Q
 Z58pCXDzmNyVZttO9heEBsAR3C1f287HZ8EAmLuzEceMh0K57lqcmIUrNq/deRF+KlnDqGD
 8F1WiwnA9fvJ/WiB5yKSCMgWOTykrMiE3mSPy7oY4xjOE1GxbAzYE7iVy5b4KKaoQywtIUY
 9voQh/xz5CF90Sk6jk+qA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vNHyLViQvh0=:t4GWMd9t8ZQaw3lO7KeVDb
 zFUJN4m+r6sH+s1DnI0bhDv1jVy7CjShuVHSOIf6lw3ijQvVIM909LCwyL0I0AlI5j7CUFj7H
 80sKZq09ZNiw3/G5BWnfrDhD8kDl0bbvqwvlV2mB7XusIuEku0K9qzG2YkIb4EAvf2+PcPxfP
 0qhbXVLpf6mJusVHOrWZlE5iv02TTeOewAP8ixiNIVLrqqmo96mfhyFjaulZPeraeTNEY0VEE
 E5B086WHi0tAOdmkgiE6wKfPJCMjPLm7EJsdtaCsUNIMPMiOFlaZ8c1PqiomZE9ymYIpZDQNl
 UmJHjPwN7W3my1s6mZTpEnS1evyJozGwbXHrl50hwBUckpn37CPzFGyi6YKPt6QZT1qgsqEFL
 PdRADrwRa4PVYG+/rO51BfSwudTzCtlPOlv/lbAHxA4vJtOKmJ/LPB2dwtR1f7Di76jtUPZW3
 PiUpBhY0wnbPHa38o7T9+MxlGHWiTrcenDh0ZJ4ZPycglO7LBlnz3pxtqGs34+3qd38f+Da6A
 hd5xjUoUwMr4NX1FLpVwcWzgCbO8bzAKqo+/Xiu5IqQK8e5D27KveXum7c2e2sqxMaHmsDRVR
 uGKBqDXD6oxADlcLo8Gubdq5J5YAKd7RgTfVVRUAjvAY+Hv+bW010+wH5YgrUUzNiRxvJpP15
 3ylm4gdvn2mSCWIslbtaotqTDsx9tmwxYu7/oIlYcdmQpCghLsKeEROH0JKNVKN+lK31nMWdR
 9afQFWdtxlBkhS5ZP/yrFF3bn2CiRW4yjF/PHW5cTgj4qP4AcKxTBaRTbbYQUDxWK+hkEr3uh
 Gp+JdOCX1IqQ4JbidOxAdNWwY4UWodyaPEVyRrZrE/HN9uUG/pwkdbVraV9eV0ycOd+Ej5aDB
 wvtMVOEKIpLMlmA7e0iNnhUxw3A45Gnz97RWMJE81sc/cysldHAUlf5SjbNM5X0iT3VOUkeqf
 iuK3/ivb9R2ItoIJ8x/CrKcgNCHtLJDPYoYaUQQr7SH4sI/uo0CMHDxnJFxuNFD8zAzttlod8
 4Ic+fET4e9BbGl5u0Q76plxfP3vr39w55WFPSvDb9YlJU2auBTalLg/+4qTzkr3JnwitDZ+eA
 fwplVIBSJrpt0PBh/iZpV4Ihz8DAtlxqtjWp5eW8eZAibRMlksnL0Mmfeglhc97Rjmez5FjHO
 IbX/II2CQPvSk3vm+NDLFdoct9KZ4PMy01hUUiDTKrZmYsMgiryZyH+wHTNZ6Hism2fRmGaA/
 py1JwqNmOX5BU73KM
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> =E2=80=A6 The patch fixes this issue.

I propose to replace this information by the tag =E2=80=9CFixes=E2=80=9D.
Please choose another imperative wording for your change description.

Regards,
Markus
