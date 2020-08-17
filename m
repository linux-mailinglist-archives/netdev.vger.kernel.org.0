Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218C22478AB
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgHQVSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgHQVSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:18:04 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD63CC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 14:18:02 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4BVn2C0rDMzKmpq;
        Mon, 17 Aug 2020 23:17:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id W8gA8EeCxodG; Mon, 17 Aug 2020 23:17:51 +0200 (CEST)
Subject: Re: [PATCH 3/3] net: lantiq: Use napi_complete_done()
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com
References: <20200815183314.404-1-hauke@hauke-m.de>
 <20200815183314.404-3-hauke@hauke-m.de>
 <17761534-65b1-e575-5e00-55e6f7e3f7b7@gmail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Autocrypt: addr=hauke@hauke-m.de; keydata=
 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
Message-ID: <718dce81-ace3-aaad-0f81-e75e227cd722@hauke-m.de>
Date:   Mon, 17 Aug 2020 23:17:35 +0200
MIME-Version: 1.0
In-Reply-To: <17761534-65b1-e575-5e00-55e6f7e3f7b7@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="KfqpCZnmgpW8wSRg1dOp6xzIwGoADPtmP"
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.07 / 15.00 / 15.00
X-Rspamd-Queue-Id: 1B62017A9
X-Rspamd-UID: 664ce8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KfqpCZnmgpW8wSRg1dOp6xzIwGoADPtmP
Content-Type: multipart/mixed; boundary="DoM053D8FZMS1H1zxPPIudgUnsGcL70Be"

--DoM053D8FZMS1H1zxPPIudgUnsGcL70Be
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/16/20 8:07 PM, Eric Dumazet wrote:
>=20
>=20
> On 8/15/20 11:33 AM, Hauke Mehrtens wrote:
>> Use napi_complete_done() and activate the interrupts when this functio=
n
>> returns true. This way the generic NAPI code can take care of activati=
ng
>> the interrupts.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/net/ethernet/lantiq_xrx200.c | 8 ++------
>>  1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethern=
et/lantiq_xrx200.c
>> index f34e4dc8c661..674ffb2ecd9a 100644
>> --- a/drivers/net/ethernet/lantiq_xrx200.c
>> +++ b/drivers/net/ethernet/lantiq_xrx200.c
>> @@ -229,10 +229,8 @@ static int xrx200_poll_rx(struct napi_struct *nap=
i, int budget)
>>  		}
>>  	}
>> =20
>> -	if (rx < budget) {
>> -		napi_complete(&ch->napi);
>> +	if (napi_complete_done(&ch->napi, rx))
>>  		ltq_dma_enable_irq(&ch->dma);
>> -	}
>> =20
>>  	return rx;
>>  }
>> @@ -271,10 +269,8 @@ static int xrx200_tx_housekeeping(struct napi_str=
uct *napi, int budget)
>>  	if (netif_queue_stopped(net_dev))
>>  		netif_wake_queue(net_dev);
>> =20
>> -	if (pkts < budget) {
>> -		napi_complete(&ch->napi);
>> +	if (napi_complete_done(&ch->napi, pkts))
>>  		ltq_dma_enable_irq(&ch->dma);
>> -	}
>> =20
>>  	return pkts;
>>  }
>>
>=20
>=20
> This looks buggy to me.

Hi Eric,

Thanks for looking at the patch.

What exactly looks buggy to you?

We see with and also without this patch problems in the TX path, it
looks like the netif tx queue is not started again.

> Please look again to other implementations for a correct usage.

I looked at multiple drivers and they look similar in this area.
For example microchip/lan743x_main.c is looking similar to me.

The hardware has two interrupts one for the RX and one for TX complete.

Can you please suggest a driver which uses the NAPI in a good way and is
not very complex.

Hauke


--DoM053D8FZMS1H1zxPPIudgUnsGcL70Be--

--KfqpCZnmgpW8wSRg1dOp6xzIwGoADPtmP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAl868+8ACgkQ8bdnhZyy
68fUYAf/UzO9MT+OcvMuXCj+NF2ID9wwCUuxqzilqC+6Rs8jBBXpMvo+LA7UDynn
YiaXKLGK7O5e26rnXK+KGWtbR9Ma+Ds2OjwjaFsljJ2hi77f5yGXNNA5AKRkyjU8
K2STjg3EtGoDs8JLhU523/UqzN7/JA42CwaxGNs9ohPTRffd3WC1y+VOC1E/xCrM
E3Jkv8vEfIQGKtijNU2hNEuukyjWKFNNw3Wm+XV/MGehcJEFBzExWMl075GcmZHD
OfKkSU8f3VcSlgCRXmMFAGz+LIEhSz2jVd/84KkRV4Qa+jYv+uutimybVfMXaacY
d/WDTkaLBbNHhb/owEOaxfc3ajaOjQ==
=fW3Z
-----END PGP SIGNATURE-----

--KfqpCZnmgpW8wSRg1dOp6xzIwGoADPtmP--
