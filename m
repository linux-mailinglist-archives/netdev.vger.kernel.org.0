Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FABC224C01
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 16:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgGROt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 10:49:27 -0400
Received: from mout.web.de ([212.227.17.12]:58669 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbgGROt1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 10:49:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1595083735;
        bh=yi6X3Espd5sqSuTZxmewLW+HuDxFJ98WpdvVZq3n+xo=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=oU+m9PD+nRG+MaaKhAGUrVmXlvBn7KIetTTOXuZ6hoFzoz1qRqrpVHQh2iX1N+5Pr
         hJxehk4LPWQkTcm7a3S5H5DqkOc6ynQh1jwAPSO+iL7mCSWF18hAe2YV8xornUxCJg
         uWFY1lWfu68qX2P6MlAJdKyN/qpoCSquD6VRs+l4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.120.168]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MbTL1-1kY3dm2yVd-00bVdw; Sat, 18
 Jul 2020 16:48:55 +0200
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Navid Emamdoost <emamd001@umn.edu>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7601u: add missing release on skb in
 mt7601u_mcu_msg_send
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
Message-ID: <080cc1d6-cbe2-65c7-fc78-861292bd46b9@web.de>
Date:   Sat, 18 Jul 2020 16:48:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xGd5zp427AZNVcvL0N6vop3uRwIGOzf5KsveZJhnWmHKhgAIkQK
 6FoGgX2XGpgWjbbxfvlxFwEz9IzDY0ue5YQTXPbMJ9aNrrXuM+ucI5oVQ4RE6/wybsu1FaE
 D+LUzkoOv9OFlatbzVFtGNd57az+LbgFQFLc2LtK7HMiYr9GyDPs3+6VcqYBEwmAWTTEN0l
 L4pSOGpiURVIxdwG55FhQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MC+N+UBDk9E=:8iDVDj7jP1s7OiZ2PhbEBO
 zIelheL8VSespmvapmnRtGe5WeHQi2/Xi426hQ3lICgpTAv8Q/9W6N8f8aAZaJporxL284yec
 m7O2LFBMlVWlBxyOIgCcpO3GhX/yl3D6fFRwpPqx50dRULSi7dsWq5NO6BJIdvFEEv0C4nvuF
 twEsyQmzXWKCo1Qx10GUCqEbov2pHB5vLy5NCZIGIITfL2aMS/l6NPTVmg3TVetWqon4prBD8
 iT7zYIQzkbq9AJFEyR4jHrSqjhXmmZMJGrDjJ9OHPXCjGl1Yk3bDuu9X65mMcXa6un7wRExC3
 yiy3MtxvO96dvaJJ+NuTEs1WRDRNGipPe5LWhXRudaW0uAfrpFadn/kDBJnTfdnMA3Y2eGDAv
 8D+SC3FtZzb1xKUM967wwmwrAzqRSu9XQkDSGIp19jeRljL1EECAlGsPtv1uN/jLhjtQ69Oq1
 53kvvN9tLAdtUJdYpoS+AeuCKBWXtV6wUAu67Bkp2Sh+9ZW/+fXa/dpvIl1VbMOLRIIAQQYlL
 3Uy5P8uuTMLNPEddkZrXimWpCqIpMTUs69j/5h7WR4+BxWRDHoQgUdOT3OsDqru3LhJI/Lqjj
 0KgUgs2dwGFqlS1f+HrMd1izz2rBK5ySxqpeChY3XqJg57vRYzyVHCoifVsCnxf4g4rVQGyMC
 paZ+B8rUpCpH732KXQWTgETVv8dl439I3LNPi9xMJxfHoojkXNmMiBtXCQc/Ju+Z4qH5/Pjhx
 OItC0yTCuAC/OZuXQR39nbCj78kG4gJoo4NCtMBYdixuKKEjvBFwzyLdK531z2DXDfbU2vtIW
 6QYBZ3HADHr+lsTWCuZCaQtw/xFZ6UfQWYULkJG8GtsyWy90Ligmv3x9C1llgIJQf9YrqjH9Z
 73Ah2p/AckbRQImTo659ls+GzoqjS2iSSBXoBjIj4TUQAjcOBB5Diq/zcyxp3E8HRwWJYMMgh
 md5mRe6x35pgB+IclfX5/6J1jg57iKhSL7yf/MXYdN0eVWY+8p3UhEdfbGLZds0uU5EkeEVvg
 5p1ElXiPG/2U1zd9LaMTZQtOiC5HzLbSelVOTbUYC5pgS44X3Vu84gJyxxITiHj7IfUAskVPA
 frWahzqCqBgW+ZTRWfS/zJfliM0xPZ+Koasx2CMmG0rQmEMGkfejYtPVWkusfrkaZ05LKG7I9
 +C45fcowqbn1yEMlBDZ2ScbiSiHj60Qfz4y2Soz0RZ0JcFJTNjLBEZGYfccOaGunIj1m4XGZo
 5yFlA0hjr5nNAB5Yypn/P3p8UdtvxyO1B+a4abQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E2=80=A6
> +++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> @@ -116,8 +116,10 @@ mt7601u_mcu_msg_send(struct mt7601u_dev *dev, struc=
t sk_buff *skb,
>  	int sent, ret;
>  	u8 seq =3D 0;
>
> -	if (test_bit(MT7601U_STATE_REMOVED, &dev->state))
> +	if (test_bit(MT7601U_STATE_REMOVED, &dev->state)) {
> +		consume_skb(skb);
>  		return 0;
> +	}
=E2=80=A6

How do you think about to use the the following statements instead
in the if branch?

		ret =3D 0;
		goto consume_skb;


Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit messag=
e?

Regards,
Markus
