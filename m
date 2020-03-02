Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0449F1763C3
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgCBTWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:22:15 -0500
Received: from mout.gmx.net ([212.227.15.18]:42837 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbgCBTWP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 14:22:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1583176926;
        bh=Lt2Q3AalYxTfamBXhAOyFLBHgmkc4B5x/srNr3IqMQw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=hdoz/OlCEwPpYwaCmF0bXVp8Eky6hxXbAmNAEqhrBTGzeJBFDoKzzUtoIWHEnz0eL
         oKXu5h1399APMBE2wFxszY142TblOlauh4Ic5GXJA7sa9Afid8jJtlSM+heqazYB1z
         0pUKmUvUpccmZy17eWdNcIyRaj4VybpeMaAAfiPw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.55] ([95.90.191.58]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MBlxW-1jEMxG0AGa-00CBPl; Mon, 02
 Mar 2020 20:22:06 +0100
Subject: Re: [PATCH v2 1/2] ag71xx: Handle allocation errors in
 ag71xx_rings_init()
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, chris.snook@gmail.com, jcliburn@gmail.com
References: <20200302000208.18260-1-hauke@hauke-m.de>
From:   Oleksij Rempel <linux@rempel-privat.de>
Autocrypt: addr=linux@rempel-privat.de; prefer-encrypt=mutual; keydata=
 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
 Rmpernzn0GXR0xYSTiUvuvpLsoo=
Message-ID: <863553db-d4df-d59c-fa8e-6c9a60ecb4e2@rempel-privat.de>
Date:   Mon, 2 Mar 2020 20:22:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302000208.18260-1-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hhgKeSteCl7/74JbR1XVCWXWu3OfL9yQ497TXhM7BGcdUJIw0zw
 2JTNwQwMOvxeD+e9Kn5aJ9dUkuQNiiL/kIVvOOR+Q3yrONVnAN3g8n+fap1MkZbKhtvbgaf
 mTNCRC4F4gsqu8Dt3nRU2i5aedtRyiOAE4ZzJGG41902OBWW15ExrodnX3+hWXxaG2IaxFh
 365qqb8FmSL/A2y5ToDAA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fNZa32zuAb4=:8bDs3fjHyDNxs1wDTQstWf
 zo4rpDe2O+2PwIFqlo3MW1rhltlTd1maLrTYoc0PlNNNqx7LM/0n/Q09UlhQNjENLrtm0kQRi
 nbpqmWfEF4vg2qXU4ML48ULPw4mLJt2mRTQTZCbuE4uGDool4lQ33t1+kQrhxqnJM+jHvnS/P
 RfQYKYOpD+Nn9mGciWByOtrsKZjfqXwbCMJC3yWo/2ZFe+pr+zkr2o83TOAASIiAFx4AQs/ym
 NEAag3hL0vEpftMzjCEjZSWPfSNK8gIGgJwRJumnuYM3TdyVmVS5SfVjka1GHesvylIHvCGvB
 kLohugUhamvkBReuAQmNhn4WNO89y6RDrgDv8kgn+KHL7qDdm2epa1nGf4k/gGTmzuB1K4KJ+
 id2wQAjVy2jmRnMior39xSp+wWnc1kUrUNGS20Jd+mbB3m/e8/jUuqejrHBxQ0FkiM5UbkMvw
 Jb7Ogu8HWg5rM0sFCvsn8c3PeYigWqx7sP/yqGQjtz6fqm02Irt5fR1fQXWOfM/o9wX4JTt83
 iLKnMZKU2fEmemLpnI8QnN0JCvO5xYhVtIU+RlK1jhXeoCcmw6gsz7ata5jTYnOPiJP455ixv
 AefCD5/Z4a/sE6jHARds9vDZVqHxCkTEY8OSPCcb5nHGCRgvHDdrOtaM6L94J20Dl3GYGvP8R
 tsyl4U7ulAypDYRE/h/cUXKt0kjLXfBizftkC/WFmCjnjLlDuB7FmxzgGzuE5CUTe1ZTgfNZa
 J3cPwm/koLCXz7BhPZmjUf4xizHf+Xt6b1+W2AYW/snRX6PrE2uW7AXF+ci/lb3bGj8U63z6t
 RJkQqHiaToVfy3PRTS20I6II8eO43epH6r6oGaE4B8xp4PHB/rNd2OIsWYwFegiLq5tpV0Jeu
 2Ll/6PJYa+ZYeyZ8QvSTCtX0B5bE7kPqNCMIYf0ZGlNTQnxkUzTtK+A4zybSUCut1gS4Ir0vz
 FyQpAXDHNrofvLunSyJr2EkxnQGiMKVmM44s0H62wnmHVQM5jhS1P5OWurO9YnSc4nc7dYSt/
 7Op/ysjGBOQFTCzjYyV04ooCaJfJE+GrV/jbf9jhyIq4dtpLBk/NkzUK3HW7WPLBE3OchN+NE
 hubIUgFototu/cjsBByVw2eer7NstUff84tYKCL+gBrGyj14MohIcosyo6M3lsNFrXfAdbJVQ
 nxq0RjfeBrqXaIWpMbfXu0rCVH7ctAi85Al/+oS8c9wNgINqiYP1Lo6JozMgXXoVbc4D54DR9
 C+5oDDD5U7V0BDUgS
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hauke,

Am 02.03.20 um 01:02 schrieb Hauke Mehrtens:
> Free the allocated resources in ag71xx_rings_init() in case
> ag71xx_ring_rx_init() returns an error.
>
> This is only a potential problem, I did not ran into this one.

Thank you for spotting it!

> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
> ---
>
> v2:
>  * rebased onm top of "net: ag71xx: port to phylink"
>
>  drivers/net/ethernet/atheros/ag71xx.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/etherne=
t/atheros/ag71xx.c
> index 02b7705393ca..38683224b70b 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -1169,6 +1169,7 @@ static int ag71xx_rings_init(struct ag71xx *ag)
>  	struct ag71xx_ring *tx =3D &ag->tx_ring;
>  	struct ag71xx_ring *rx =3D &ag->rx_ring;
>  	int ring_size, tx_size;
> +	int ret;
>
>  	ring_size =3D BIT(tx->order) + BIT(rx->order);
>  	tx_size =3D BIT(tx->order);
> @@ -1181,9 +1182,8 @@ static int ag71xx_rings_init(struct ag71xx *ag)
>  					   ring_size * AG71XX_DESC_SIZE,
>  					   &tx->descs_dma, GFP_KERNEL);
>  	if (!tx->descs_cpu) {
> -		kfree(tx->buf);
> -		tx->buf =3D NULL;
> -		return -ENOMEM;
> +		ret =3D -ENOMEM;
> +		goto err_free_buf;
>  	}
>
>  	rx->buf =3D &tx->buf[tx_size];
> @@ -1191,7 +1191,21 @@ static int ag71xx_rings_init(struct ag71xx *ag)
>  	rx->descs_dma =3D tx->descs_dma + tx_size * AG71XX_DESC_SIZE;
>
>  	ag71xx_ring_tx_init(ag);
> -	return ag71xx_ring_rx_init(ag);
> +	ret =3D ag71xx_ring_rx_init(ag);
> +	if (ret)
> +		goto err_free_dma;
> +
> +	return 0;
> +
> +err_free_dma:
> +	dma_free_coherent(&ag->pdev->dev, ring_size * AG71XX_DESC_SIZE,
> +			  tx->descs_cpu, tx->descs_dma);
> +	rx->buf =3D NULL;
> +err_free_buf:
> +	kfree(tx->buf);
> +	tx->buf =3D NULL;
> +
> +	return ret;
>  }

Hm... i think it will be better to reuse ag71xx_rings_free() at this place=
.

>  static void ag71xx_rings_free(struct ag71xx *ag)
>


=2D-
Regards,
Oleksij
