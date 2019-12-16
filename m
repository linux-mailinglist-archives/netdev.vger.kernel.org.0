Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3817412001B
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 09:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfLPIoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 03:44:13 -0500
Received: from mout.web.de ([212.227.17.12]:46903 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfLPIoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 03:44:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576485833;
        bh=+PPbIlgj/jy3PI1TwRvB8BjPTFOceJ1biaOGTKC1qeg=;
        h=X-UI-Sender-Class:Cc:References:Subject:From:To:Date:In-Reply-To;
        b=iKnnmMbWzwzy4R6J2dgyxZRMfavVe2zZKvXmdrViZiIhV9uHoRskU4cBb52EX6PW8
         106N40cS9E5jv8D2u1T0XqMgOgyRBa9a2bRsglWD8LKQZ0Q3ZmD0vINh1NcO9Af/YO
         qIl9uUpuOhwuIhpUpXafJS0fzKgVefPni3Q0Ht/s=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([78.48.181.202]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MKa6N-1ieqhq1UZT-001zO6; Mon, 16
 Dec 2019 09:43:53 +0100
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Chas Williams <3chas3@gmail.com>, Kangjie Lu <kjlu@umn.edu>
References: <20191215161451.24221-1-pakki001@umn.edu>
Subject: Re: [PATCH] fore200e: Fix incorrect checks of NULL pointer
 dereference
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
To:     Aditya Pakki <pakki001@umn.edu>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Message-ID: <47757327-f6df-9146-03a1-2b32b23a37e6@web.de>
Date:   Mon, 16 Dec 2019 09:43:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191215161451.24221-1-pakki001@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:sVy/fXwIzJJRTix6pcw7mQIpl623Gf0miVdWobIiWboF0ElQZIh
 P2wjT+npLvNiNv6kT6YrS8Wv6EIH0r8WzBnlqOSxqGPQVeatngJB5Yzl0JKb1M6BacE2eqb
 0xM9sWiU+mWVS52u15jJ6k9Jlql//6bGJEE/1uiSJ3DUxM4hnChQG5IT0/pJ/uywgmFrvFt
 VQfrM+io7XF1e0oco0RKQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:GUNuTZ3PO1w=:Ob4pfiD4QMwL+LRCNaBv6Q
 SVsNhb7eVc8ekStl5WBLFFcItXq+Ah1ptWEa3mwhsh9SDy2NzCrKvDJsEbLqOYOGaDfFzf9bS
 sCZSqOXHmPPzXW8cZmy+kE+QnzZaRynDCmj1prwa58iQlH+1edbBKiadSRg5jwW+nMK21IISy
 d0O1dc1L5uVOsv6RgmNo6NIZ19jxTH/EFmGWgnGmg9ZL94RPBMnWT1Ul7OLxiTNDcxwC0QaTg
 IA9deXWDUulWgqi6q0AkuIGRJ8JWTnpvPrBCefDdBMn4V8CxaWvFsOMODhmmT2ugM8QAMCNp/
 MxrV3BYWjx3pc7inmrJcrpPuQd7s0sciZOsSbhYycvyKAAdnlVb3NUnKjRjddIprXZIlz4UcK
 9LPmfn/4PEujFWl8P/Scq2pBwLJQHb175+meQ1KxYCGtwDVYlDhAqtc8BoXnglbdhVdBv6mCJ
 bqeaFqAr0w/bELDt+w98TpbPM+z6ZGjrUK4PWdj1Nk1w0YdLHwONuv8mgsg7XeKXi+f/axyoc
 DVdASo8E8fcQiYYayjLdv6fB9yFPO5OEv/OnJZ1+A6BhB8Dl2ahtVEohBuJL1K0igiQHSjbD7
 HVgKPZcfoPyxsgQXr/S6cR7zu6m+ySc+q0h2X33Z6rIxaO5qodqJZy6Xd5eWA0Rt/yK+wVidN
 mzVc+Civg/PzF0VKwtcyYWrmFBelegCBsF53B9JnUAPKzmUmPqIdhjtj0Uyn9WI030k1QZfOc
 RSB7t85RkFoVPGCOyckX1vaNIQAyM23W0PZfcaK92TxRU9Nk2EN/+ud+sRDLuSdW3AhMo93r8
 jAaumxwRbLj4Dr1RLyccFbFxdQNv8FBLjE1DmjgvfT4FDuvWKss6oA42vJxlvnvmyTFg1APr2
 b+os1sEXhO6srYheln7k9NMNgHSe1xX2pjdVrtxk+77QXdlc4My3ULs1svx8+GaMkKtlJb7En
 HqFNRu4QDS2vGEa+9JxSeFfxWKpTSCPqEnlXEr5XguV7FB9AA1fZFWoM7kCOyQY2jQajUOCzs
 Uo+KFV+RmepdtIH2EB8hlnOcOaZUY/OWCez8BIASqmBIdQkFilXWyQkyPv5dLvQgvcxSy1uhO
 ecKnxxMFkffXMW3LEpEc8XrEGHV5MdqXmmZ7FSQq8ZJYj7TE98QlpeBETX6dbNVhW0kAiWD8l
 MsoExuNuV+1slDutyrm+vF9aXzUCLBGtCqvnGqA550T9VzmRaHTuCAuX/Iy6KDp/w3NnGyeMm
 Li1YFMcmpW87wrjhio9GeiBQluK6tIkMefA1cO0e5qOuQ6lBh9Q50F7PD6JY=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The patch fixes these issues by avoiding NULL pointer dereferences.

I suggest to choose a better wording for this change description.

Will the tag =E2=80=9CFixes=E2=80=9D become helpful here?


=E2=80=A6
> +++ b/drivers/atm/fore200e.c
=E2=80=A6
> @@ -1480,9 +1482,18 @@ fore200e_send(struct atm_vcc *vcc, struct sk_buff=
 *skb)
=E2=80=A6
> +    fore200e =3D FORE200E_DEV(vcc->dev);
> +    fore200e_vcc =3D FORE200E_VCC(vcc);
> +
> +    if (!fore200e)
> +        return -EINVAL;
> +
> +    txq =3D &fore200e->host_txq;
> +    if (!fore200e_vcc)
> +        return -EINVAL;
>
>      if (!test_bit(ATM_VF_READY, &vcc->flags)) {
=E2=80=A6


Can the following adjustment be nicer?

+    fore200e_vcc =3D FORE200E_VCC(vcc);
+    if (!fore200e_vcc)
+        return -EINVAL;
+
+    fore200e =3D FORE200E_DEV(vcc->dev);
+    if (!fore200e)
+        return -EINVAL;
+
+    txq =3D &fore200e->host_txq;


Regards,
Markus
