Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 257649993E
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390000AbfHVQc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 12:32:57 -0400
Received: from mout.web.de ([212.227.17.11]:33725 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbfHVQc4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 12:32:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1566491545;
        bh=ht6lYPJe0b8nt8f4KXeCIb7X14dugJgZeVLShKqxWVo=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=C62D8uE8fZcM6yk0bLu6yXGwnz3Dm+NslzeReHEcFA1J0MPGb8+OlTdAKpn2cDdJV
         C9NmYUnmpRiYXG6HhhTARS5XsHXZuyGll4jb7L+S6ZvNaEIRKbkwuj2JerrRCyjcx1
         cb6kWdDB5No+5sPCMKI5dOUX+c0wYKvbTiPNc/Gc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.181.43]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LgYOH-1idWkX3j0P-00nzZ9; Thu, 22
 Aug 2019 18:32:25 +0200
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: =?UTF-8?Q?=5bPATCH=5d_net/ipv4/tcp=5fbpf=3a_Delete_an_unnecessary_c?=
 =?UTF-8?Q?heck_before_the_function_call_=e2=80=9cconsume=5fskb=e2=80=9d?=
Openpgp: preference=signencrypt
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
Message-ID: <25ca9c48-1ac9-daa1-8472-0a53e4beed6a@web.de>
Date:   Thu, 22 Aug 2019 18:32:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xDTeW1knqZOQNEv3CDUHgxC3lXmxNlPeXq7oAGg1PPlrRYRLBQX
 IS+eJXuxa/0qCqrzDvOXdOawn2ZzcGc7ceCEkI+QxZzognhcxwUKpT9QQ0++YVJX4mI4d0I
 /6C9O5szvLH2aTvZyjBq4h2jP2FxwAV4xVIkFOfACzq+PFbaKjesiVSYeaMTMz65MzVzmqN
 SWLAdB65sgjC+dfC7tFhQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Z3St/I3a+aM=:mIIFZ9s5mp6yvJ/9xWt7cd
 3Te+BdsE3kOdYomnNE7FhKraecvC+wOdSr8zD66yndfRvXuRjUAhqke8f5rEYslx0zIC83Lv3
 n3sX3lAcyWc204sBidSMBrTQ4zZHn9D45CwZweI/stk+mOtHU5lZ7U74zq0y3TRKus25BySwa
 kdVYgA+JEEPNBFQi9qGQPcSH3rfPKSzqSJb3IpdV+YIcdztxjp4Wwun5K10Jqdl2Yahtj9Sui
 R/e6AetJRlE6jXrXoEJNDrJrlZ7hsBHHuulF9X0+fyTCdngVTqVJJqDIQTwnX8tCJf+JQoN8Q
 kP+4qqDPWAqDa1saFTIVgaLxFHh4iiZgVsys8OeVqIiO0i51OKu0yrQaD/GsqsRniLN1v9VQi
 1XqxLW39/gaHKxA0/lBr1H/4ww4Xb4hkMQ2M/iA+l2iwbPes5DvhjYF3A5W24nyBbzrRb7hid
 mjBvwlzrOMkxrGHAlJNbuFZBS8cJpgZS6nWYENCIs46jlju6zv/ycmelzzQsZ/iF9Z2Pha+Pp
 UmnkAuEvlM1uV4U48DkVb9TaebCiTTLP8VxYKqfVJbU/s0X+UE3rE0rqLGoRjiNVSXm/tRYZx
 /JqtbAJ44yfye/3PkOhxc3ILGojG8gJKyBRytjBpT1XfEwzkpn5t/sDu2C6PV6ePVYWAtwmlG
 2+Se7Stibo9Ya54M27G8v3yVBZ/Pu35iHhs92wRZ5I9AhL5xNtwTziPjWuhu0Le5UAfuPkx/1
 zqEod1klu+OglFxgej/S2eUP4IBiAtWgzenj6Gy98lGzL/5y6g0wCT1oXLm4/dPlPfTXYmGIh
 s387dvzddfZkuqVlcXMj8FYaN/Uf7OxgxJhawVXU0R+UbGTm7GnGHCvRbf2gpSz9I/4yiedaj
 7mE7OA10hc19FFHCila5buNRXgWrBqQb84PSq2UTY1SLR3tTSgSaAhd47wnFSludQLoNxZgZ5
 g8uBImWAkq7iPAGBnD3RQZ3LUg5XyizKoO9IciPYIafBPaHaIH1iE6UEc3V6Wb0wvum3KMHLo
 vFSfFYM3SnnMXWbvc/fmRaCP6lUepPhBo17Xf0hzSWrZc1mNQ5xMyW1dM7Mbif47P8REV8Rie
 mkJizJos7rUhm+ieuw7r0y4+/tl7OWNFAkUsMCLXEwRVPOA/0YEDz7TRZn0VMIBDw0xyr+WUT
 WL6f9IH895pBzH47eAnaQOYpBRaZYI+Z99Ji6gRiJOFKftWR8DqJdQgWpCk254/i8nM59gl9+
 rFX9llRRIQ0WIWnF/yFhb+eWSahnOX8pWMcumFuAx45cpweADdutyWmowLyj6F1yf43A2CzYt
 xHi9z1XwwPmVkOXRE2cv1XSqLV2pFhScFNjukgtLBSlppLQlTtKsVzncBU7ATtseXvOYMa+Zv
 ffDIAt8ZXwY7WpboB8+gHaMpG8V0ZqkJ7m0GoCKBIFybBAYdU6A2XvPVGDuZWTWY2ELL3csxE
 Gm88F2Ee+5SXg81aMRKtWWQ95jt3Ev2cI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 22 Aug 2019 18:20:42 +0200

The consume_skb() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 net/ipv4/tcp_bpf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 8a56e09cfb0e..4ae18bd431a0 100644
=2D-- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -103,8 +103,7 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock=
 *psock,
 		msg_rx->sg.start =3D i;
 		if (!sge->length && msg_rx->sg.start =3D=3D msg_rx->sg.end) {
 			list_del(&msg_rx->list);
-			if (msg_rx->skb)
-				consume_skb(msg_rx->skb);
+			consume_skb(msg_rx->skb);
 			kfree(msg_rx);
 		}
 		msg_rx =3D list_first_entry_or_null(&psock->ingress_msg,
=2D-
2.23.0

