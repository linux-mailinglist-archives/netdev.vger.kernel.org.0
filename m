Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705141CBE04
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 08:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgEIGPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 02:15:42 -0400
Received: from mout.web.de ([217.72.192.78]:53217 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgEIGPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 02:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1589004925;
        bh=ifcV3ZHs6w2S6xwGj4cy+pBXQRHSzpfPrRFt6UkrSUs=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=Zz6L1nYQou7GnhzbX5fOFkHQ3q67xI93xTaVAEcRfrb8BCqeb3f8ExMMpMwxUhyg9
         w8ZjFGSzzLnL0NYZEjVPFq4GdT3cyQcM/nlBP0fpI9cHqY0r+JUhAvysfjvDw018jf
         f9dM2RsIcqdBOZ1ZoLjyxr+oxm/Wyn+oEKkYMh8c=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.147.78]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MSrl3-1jfFMW28kn-00RnHW; Sat, 09
 May 2020 08:15:25 +0200
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Finn Thain <fthain@telegraphics.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net/sonic: Fix some resource leaks in error handling
 paths
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Message-ID: <b7651b26-ac1e-6281-efb2-7eff0018b158@web.de>
Date:   Sat, 9 May 2020 08:15:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:q7OD8yBSZzkshqpVZn9WpjIxXdZ5nl4Od1KAm8Ec1iweRgjciU9
 9QrlqSHKp7XQfFV6Frxvf5Ept8+A9BKfmqNe6wPIHfOCvL00Wxr0xwxKBdeXDGzPMm72jFl
 +n+0Gi1Qk8JFwi68QsgdZ5clFawSWzhu1+nbINI2RynMDjhpoghCxCxRN8SZ3bopZe67/GK
 Rd+c1kekLKXQiVeny3GSQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KBxsFh92u2w=:Oc2aNy8cfUMLfaP1GvpY/v
 q208mgYrSIT4f8Iy0I+FCbAs0/4jj5TJmjFqX8y4BBImXZYwFuZoAzRZcA9rNrSgXFdsxFk4w
 xvbaAvUcRk2WZVyFn1luAAngvYF5rBgeHvmqD/05ncRfOP21w2XQfzL3tLXPoT2HZoqRoiAxi
 ygr8QGsPZgb3qPvTnlmnsopDPGeuPnvtsSJZA3M87cS+tdZteu6z9+PcUP4lN2/jXzoiwahvu
 DC2Bt9X9WF98P1v3fPknlqdRD6rvpLig2SetqhX/KGNxhv7pkchn/Fju1LDxr+Xnp1wryRlTd
 9YzUCJJAkqtpqlYlHEiZ/AGdnxBxqcOLNRmFmQWNCf0H9xXDI/caxn1/aPb/KaibLito+sYKG
 89mMNHO3gyeCsI36NPtP6EMwJAgRY/GBZ4yKPzymjYUS6NfcxM2fUEwFEyWYz+pWSVD5xu1lM
 Sghc9qouJ1RBioHfYQtiofQH21/Jkok5bTf1bj5ZDGteYgiz38U5UchASkSqcg/a1GfKcm4On
 v/0TGqeW7uk7E1O9u3o/6qHQgliti9D0wG+I9uY4o7FVHFdaT3hndc3v7TRtOhjVf3y9BFt5y
 zgU4ZFxdTe+2p681GLy8Y0iTO8HI9Y60CH6b3tVQ/jJkI6qzRJ+tDerHEiks+gAKwe/XiWV/i
 i4pfszFFEYTpnneKiv7/4khTVGHBJ19MFiwTctyS900E1WhX/p/7sXxVotj11bT4wJc8fi7k3
 N6tLgNxjbIg3sRipbmWEWfWOS3lpNU6DlKRMHZZimcrmyaP7z2pkyVmtJ1FvC4/V965j1j7b7
 nVxKDswuIka1iXra1WJLEsyhAd6crNEzNFrsMI29JVcErWQG3A22x2SpBpwvXYepzcKf4ZSsZ
 2r0LH0Lbn+OHaqpQ5MVCTQyNUkoFINN0r6FosDnQOQPDTZt4GWBkWB2E4HTxUTY8JYuAoRAfw
 /r9JEutL/oo8c0KLqZ8zmDZwpcxSo00e+zkhexQ7Aw5wVjS2Pg2oPRg+Nh/IVHGX8WF4s4zNA
 xyn1UIXPN8MTG0JvyGOmn2BB5TmAXLa+JK/hwfhDZoQ7L7QnNvQZ3lYe+adqs9MPh7P5OiaPd
 ZrPMz7ryBjRjIpHvawipzfG0zkEuS9iX4ZkG1RvccsOy/rkjB49/75fAgra5rNl+YomI9QEDJ
 oCk/Tbl7G+2/+JUnHthmhR5C49P4Pel4bsrW9gRgyOTGJPAqIqNTykZZl8hWDnOk3TK7OPwpw
 5SsjemwsfzOMEyC/w
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> While at it, rename a label in order to be slightly more informative and
> split some too long lines.

Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the change descri=
ption?


=E2=80=A6
> +++ b/drivers/net/ethernet/natsemi/macsonic.c
> @@ -506,10 +506,14 @@ static int mac_sonic_platform_probe(struct platfor=
m_device *pdev)
>
>  	err =3D register_netdev(dev);
>  	if (err)
> -		goto out;
> +		goto undo_probe1;
>
>  	return 0;
>
> +undo_probe1:
> +	dma_free_coherent(lp->device,
> +			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
> +			  lp->descriptors, lp->descriptors_laddr);
>  out:
=E2=80=A6

How do you think about the possibility to use the label =E2=80=9Cfree_dma=
=E2=80=9D?

Regards,
Markus
