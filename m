Return-Path: <netdev+bounces-7977-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3405C72250E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 253D01C2096D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75FD917AD0;
	Mon,  5 Jun 2023 12:00:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EC6525E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:00:04 +0000 (UTC)
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A836A1;
	Mon,  5 Jun 2023 05:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=9NkVDs/uToJnfaJZhSuqTMqwAYAKHdCOilQPymUsNus=;
	t=1685966403; x=1687176003; b=XLSdzwdSfRHN2l/8bHHbvtS4dow47FpahCrsHIBfnhk60hX
	ek1Aam03VFk+inrCpClX36gzBdmemUiVmajnoFGIwjqB5CGOAKVvxmk/kazzr/2HHey96tU4U/tKF
	wKsfXWKcvEI+2RY/tY8bgcWNc9p2/ZLjpa3fdzUvdflHZlm9Cl0mCrEndPu5N3Lco0/o9aEZNZfxA
	0nsufUP6z5zLEtiUyup2a4EerOv/z4wsjR047ydUph2iyeF4Ftjs0XSGlWyIuB2ANRBgYO9Oi/RBj
	m9ahihTrs3G4/d3C+ha3YMuntZ6k0UJBs7bjtFwY+bOlOLL37Z8lgSpy/3ODHUEQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1q68sO-00ERZN-2c;
	Mon, 05 Jun 2023 13:59:56 +0200
Message-ID: <1dc009dc5c6394640fae1200624e7ba4c706c9b4.camel@sipsolutions.net>
Subject: Re: [PATCH] lib80211: remove unused variables iv32 and iv16
From: Johannes Berg <johannes@sipsolutions.net>
To: Tom Rix <trix@redhat.com>, davem@davemloft.net, edumazet@google.com, 
 kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
 ndesaulniers@google.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Date: Mon, 05 Jun 2023 13:59:55 +0200
In-Reply-To: <20230517123310.873023-1-trix@redhat.com>
References: <20230517123310.873023-1-trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.2 (3.48.2-1.fc38) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-05-17 at 08:33 -0400, Tom Rix wrote:
> clang with W=3D1 reports
> net/wireless/lib80211_crypt_tkip.c:667:7: error: variable 'iv32'
>   set but not used [-Werror,-Wunused-but-set-variable]
>                 u32 iv32 =3D tkey->tx_iv32;
>                     ^
> This variable not used so remove it.
> Then remove a similar iv16 variable.
> Remove the comment because the length is returned.
>=20
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  net/wireless/lib80211_crypt_tkip.c | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_c=
rypt_tkip.c
> index 1b4d6c87a5c5..9b411b6a7b5d 100644
> --- a/net/wireless/lib80211_crypt_tkip.c
> +++ b/net/wireless/lib80211_crypt_tkip.c
> @@ -662,12 +662,6 @@ static int lib80211_tkip_get_key(void *key, int len,=
 u8 * seq, void *priv)
>  	memcpy(key, tkey->key, TKIP_KEY_LEN);
> =20
>  	if (seq) {
> -		/* Return the sequence number of the last transmitted frame. */
> -		u16 iv16 =3D tkey->tx_iv16;
> -		u32 iv32 =3D tkey->tx_iv32;
> -		if (iv16 =3D=3D 0)
> -			iv32--;
> -		iv16--;
>=20

FWIW, this has come up before, and we weren't sure that this really is
right and shouldn't have reported the iv32/iv16 values out to userspace
...

That said, it's unlikely anyone would ever go and test his code again,
so I guess we might as well clean this up to get rid of the warning.

Maybe leave a comment?

johannes

