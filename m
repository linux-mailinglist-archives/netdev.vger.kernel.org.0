Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0302D224C65
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 17:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgGRPUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 11:20:48 -0400
Received: from mout.web.de ([217.72.192.78]:55883 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgGRPUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 11:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1595085611;
        bh=IyxbL1zU07mof8eJC+WHF+sz18Phyd5JcwgRAU12by0=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=G8EsF2cFN4LYRw7k/aTHi1cciBYepan5//oLCGr8ERifLdZ3JBdQb4q/k0Iflns4E
         VEt1Gb1BtvzepPpSeYReEOjPzuHk5R2yyQkWs0mhUlHodxGnY8oumXNXld44hsXZN2
         6KjhrFyPqdhKvGBUzhngweULsGPJZavNhjivfoD0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.120.168]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MWi5i-1kL6o63xhw-00XR95; Sat, 18
 Jul 2020 17:20:11 +0200
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Navid Emamdoost <emamd001@umn.edu>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76: mt76u: add missing release on skb in
 __mt76x02u_mcu_send_msg
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <b480613d-9ff5-79de-1066-2ece999d516d@web.de>
Date:   Sat, 18 Jul 2020 17:20:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:69mwo9rNqPcINw1ozFY10lAPovPQK9fXOUGp4GFTTV4tLe/qWC3
 95CqizS015kpzGv03t3bsoeCKGlGnOYYr6IbDDAmVpjnx5+PZhqdAYLPTQNEEqWgO+lcNfY
 1EZ4qFFedVGOoXhHStwW+a/gWENtW0Dk0j+BlxXitWb+FRxQh8+Y3zyfmj3hmGPIpKF1/Sc
 RBUba0mTnAv6FX1DXm3Zw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HC7GFijEuYc=:J56CkoGGsWNyEWiNWQHATD
 Nwrh+JqrtAWLbnvFHg/w/mJU0o4/EDvcBX/yi8867ofxfjAdYmeAdML7zUO5RLkVZC02CY1Et
 3Fm6JzX24UooB42tSWPOzkeLV7y0Ou7O6twPpcfeERB79/pzJflTNCdH0WUFw+j1v3IkGXWhS
 ub/CzsdB/t+QelFVDTX46rQgiZau5mDGoju1+3PTjXOjsLx7sgPj3i3OlItlyVD4zyk+170Z8
 yu+ETwjWi+f9c533MVCBHqovtJeyrZQvgOTRbJV7vaMtrP93RES2/jbnNDoA4spJDFdVfIZLh
 +CYp32FhGqdwzP0F96CXWSKkbtMuKquvTqvU36ATGh1ohUVHRGkpZcedKuqUHW53/oEAW/UGo
 qNFN58V8wUQE3n/9Dv5o3g2dAOR9AHFOYRZ5kRGti73ab+VYj22sMDOAl8XZiPsHNknSlZFpr
 tz1Fo8uD4iP3VRSuJu6jk5uCeUMFgAFn7a/RxlQ1s+sKGr5TEAQ+7KkrPcMqeoqB5y5zFyNV2
 VY0pyzRJXEx4OXn531Ra7BwpVfAW7dJJLMghy5qx8Y95PekDBKAORWFsjTPmVgBQ8ECq/i3xD
 8EBWPS+Sb8CMvnFxx76h2dgfRknp4b5iFFDy3p/v2VTJwMfG0gfPfTz8aNg6AHoF6pQcRY23e
 jS3V0qNXzcP0ZZ5senLluVjWPzLeuKYaL0x+okfljwBLNodR7SSk1mJtloWkD40r8aAkWH0xY
 mXcdH4hLuhcOFYFPup805Vo3qqky8VEeG1D0/w2JUfqDn618Y6ni9hb9L6ou+FFtEBP9NXGWC
 f/1myLZovNBOIgblcn3ZM9hAYfpTlPdpFvhe1dCIU1eFWB3pClDKkFqIarRQ6yBBRnkMFVAbz
 ydVqSuyWsLFMdH12JRtqfi142/QXTHpSwPSiAPV5PqcuEASf/Zm0gETYINk2ETOQ/1dA6nJGS
 SpGM4wUYNodlCaO6X0G0eai++g0QtGIJYC9Ci4VuW9pZ4p2NMWBX4bjmn2d/zG0syqCKDKljA
 QKyeMqW+pxgKICCyEqfXbc4HGAJsZJ/imivDrZ9AOYfx7p405rLGg8cknT6C+R2VUAM75fdyM
 gZCP+kAS79/c+osl0xyLVqELWCAJKGHroYNr/Pl8zmQeT8+PtJJVmHDIY9IOPNXMFL38Ek8Sa
 oUboQSW/fwQNLjyKsbYPZtgDDre80u7i/eI1pnbV6NWWYA8HSfQE6+1sRORw67CCJ94Ceh74q
 420W2T5IylhxjjJjhUqsxQDMR5k1VuBWEH2LB6A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E2=80=A6
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
=E2=80=A6
> @@ -111,6 +113,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct=
 sk_buff *skb,
>  	if (wait_resp)
>  		ret =3D mt76x02u_mcu_wait_resp(dev, seq);
>
> +out:
>  	consume_skb(skb);
=E2=80=A6

I suggest to use the label =E2=80=9Cconsume_skb=E2=80=9D.

Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit messag=
e?

Regards,
Markus
