Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820755307B3
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 04:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352883AbiEWCaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 22:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352878AbiEWCaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 22:30:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E62D3702D;
        Sun, 22 May 2022 19:30:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D5E0721A3E;
        Mon, 23 May 2022 02:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653273011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xxyhl8hHZLFvYuKrBOeUuiz5/xSOjIEJVZn/so9e9Jo=;
        b=SBFQLCVgJujUr9a6oFzRsek2OC2o3hImU+UFVELtFaL0DldRFv8ekz9rMk3fZzQCEHEVqo
        MJNnw6aa00yO2zkyR+5x5UQGkpThknlg1rkCYWv6RoSpUcZliytUIUnEoR5XiTTDiFNZDC
        QzPDyj2EO+j44+gehs4XxgVW2q8cTUY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653273011;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xxyhl8hHZLFvYuKrBOeUuiz5/xSOjIEJVZn/so9e9Jo=;
        b=i9BFUa2qS9RUGtWl+OV0xYhy6rFdeRs7uIx4L08pvw6fuIj5rSWhoh38LfuiA/qjdoAspB
        xT1N9E5ocRBgcYBQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id CB31A2C141;
        Mon, 23 May 2022 02:30:10 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EBDE460294; Mon, 23 May 2022 04:24:38 +0200 (CEST)
Date:   Mon, 23 May 2022 04:24:38 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: REGRESSION (?) (Re: [PATCH] net: af_key: add check for
 pfkey_broadcast in function pfkey_process)
Message-ID: <20220523022438.ofhehjievu2alj3h@lion.mk-sys.cz>
References: <20220517094231.414168-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g42tgft3y3hx52j4"
Content-Disposition: inline
In-Reply-To: <20220517094231.414168-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--g42tgft3y3hx52j4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 17, 2022 at 05:42:31PM +0800, Jiasheng Jiang wrote:
> If skb_clone() returns null pointer, pfkey_broadcast() will
> return error.
> Therefore, it should be better to check the return value of
> pfkey_broadcast() and return error if fails.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  net/key/af_key.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index fd51db3be91c..92e9d75dba2f 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -2826,8 +2826,10 @@ static int pfkey_process(struct sock *sk, struct s=
k_buff *skb, const struct sadb
>  	void *ext_hdrs[SADB_EXT_MAX];
>  	int err;
> =20
> -	pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
> -			BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
> +	err =3D pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
> +			      BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
> +	if (err)
> +		return err;
> =20
>  	memset(ext_hdrs, 0, sizeof(ext_hdrs));
>  	err =3D parse_exthdrs(skb, hdr, ext_hdrs);

After upgrading from 5.18-rc7 to 5.18 final, my racoon daemon refuses to
start because it cannot find some algorithms (it says "aes"). I have not
finished the debugging completely but this patch, mainline commit
4dc2a5a8f675 ("net: af_key: add check for pfkey_broadcast in function
pfkey_process"), seems to be the most promising candidate.

As far as I can see, pfkey_broadcast() returns -ESRCH whenever it does not
send the message to at least one registered listener. But this cannot
happen here even if there were one as BROADCAST_PROMISC_ONLY flag makes
pfkey_broadcast() skip the rest of the loop before err could be set:

	sk_for_each_rcu(sk, &net_pfkey->table) {
=2E..
		if (broadcast_flags !=3D BROADCAST_ALL) {
			if (broadcast_flags & BROADCAST_PROMISC_ONLY)
				continue;
			if ((broadcast_flags & BROADCAST_REGISTERED) &&
			    !pfk->registered)
				continue;
			if (broadcast_flags & BROADCAST_ONE)
				continue;
		}

		err2 =3D pfkey_broadcast_one(skb, GFP_ATOMIC, sk);

		/* Error is cleared after successful sending to at least one
		 * registered KM */
		if ((broadcast_flags & BROADCAST_REGISTERED) && err)
			err =3D err2;
	}

and the only other option to change err from -ESRCH is

	if (one_sk !=3D NULL)
		err =3D pfkey_broadcast_one(skb, allocation, one_sk);

which cannot happen either as one_sk is null when called from
pfkey_process().

So unless I missed something, bailing out on any non-zero return value in
pfkey_process() is wrong without reworking the logic of pfkey_broadcast()
return value first.=20

Michal

--g42tgft3y3hx52j4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmKK8GAACgkQ538sG/LR
dpUHTAf9ERCtb+WT/nqUex+gV8YmPze/VHGfpivZX06w3CEDBI0VUtt7rGJDDGGu
3Ca4WGfZRlLQk5da3ysbgZA7iTBTIsbYrnxHzNXjiBA4/w8Nuf1Rn/2cpk4Kyafb
FvqLfFCxeF6HXH+rtsFIe7nQOWewY5shqOOOhRWeq8z8kQou9RWoM/Pg/IVmhuyz
j4hnuDsar1Dot9d1Fxxq5tP8xzUqCm6t5Qya+3ZE9nhL1ACaxTrsg+pOZmb5tBg8
ymtQra26k/hfii9vX8cBxb85p8kigpsbPtDPl3WEXiwgO+utdu+gQ7L7WQ9e4DGH
Vsrg7eEKdMZby1lkM16WEFIduzJmrw==
=Eg5V
-----END PGP SIGNATURE-----

--g42tgft3y3hx52j4--
