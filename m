Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249C96D3BCC
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 04:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjDCCXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 22:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjDCCXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 22:23:23 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81DD59F7;
        Sun,  2 Apr 2023 19:23:21 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PqZSN1tFQz4x1N;
        Mon,  3 Apr 2023 12:23:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1680488600;
        bh=I4VCQQfTYYuPM7QdVmDDuL639PPq1rvfSSDNSg3HDNE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m3IUFhDsNPsUxwGeesWUGTLGAezURvEkkuoTutMDflrabhD0M9qrIl6l7HwRKoCyf
         1cQJbpXdatvJ/YuwIT/bNAY1eZze2/7pwut9U25tfgsgEJKcRDZzQG06/9x0Juhd9T
         MGZuPhjJISIPoK35wwao3z4RlKPSyMzFwyUCqclJxvy6TCenDyjNIbmqaW5xu9Pg3x
         DTxLr0AtyYD3lzrNqMJcHAxbk1v10Ggku0en+RfZ3m+hUFLW2ZpM7t/eqPBg5EUYUh
         jWPH33TOdhnuuQp0Cb6CR7pmuMT0o11mnP9VHn9FUcWvXBh8z0BibxxyHagkc14MAS
         ond/FhzcVCidw==
Date:   Mon, 3 Apr 2023 12:23:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-ID: <20230403122313.6006576b@canb.auug.org.au>
In-Reply-To: <20230331104959.0b30604d@canb.auug.org.au>
References: <20230331104959.0b30604d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/pxlJb5yfrRaqeCfuZZkYAsv";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/pxlJb5yfrRaqeCfuZZkYAsv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 31 Mar 2023 10:49:59 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the wireless-next tree got a conflict in:
>=20
>   net/mac80211/rx.c
>=20
> between commit:
>=20
>   a16fc38315f2 ("wifi: mac80211: fix potential null pointer dereference")
>=20
> from the wireless tree and commit:
>=20
>   fe4a6d2db3ba ("wifi: mac80211: implement support for yet another mesh A=
-MSDU format")
>=20
> from the wireless-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc net/mac80211/rx.c
> index 3e2176a730e6,1c957194554b..000000000000
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@@ -2776,27 -2862,12 +2843,31 @@@ ieee80211_rx_mesh_data(struct ieee80211
>   		rcu_read_unlock();
>   	}
>  =20
>  +	/* Frame has reached destination.  Don't forward */
>  +	if (ether_addr_equal(sdata->vif.addr, eth->h_dest))
>  +		goto rx_accept;
>  +
>  +	if (!--mesh_hdr->ttl) {
>  +		if (multicast)
>  +			goto rx_accept;
>  +
>  +		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
>  +		return RX_DROP_MONITOR;
>  +	}
>  +
>  +	if (!ifmsh->mshcfg.dot11MeshForwarding) {
>  +		if (is_multicast_ether_addr(eth->h_dest))
>  +			goto rx_accept;
>  +
>  +		return RX_DROP_MONITOR;
>  +	}
>  +
>   	skb_set_queue_mapping(skb, ieee802_1d_to_ac[skb->priority]);
>  =20
> + 	if (!multicast &&
> + 	    ieee80211_rx_mesh_fast_forward(sdata, skb, mesh_hdrlen))
> + 		return RX_QUEUED;
> +=20
>   	ieee80211_fill_mesh_addresses(&hdr, &hdr.frame_control,
>   				      eth->h_dest, eth->h_source);
>   	hdrlen =3D ieee80211_hdrlen(hdr.frame_control);
> @@@ -2914,14 -2982,24 +2985,24 @@@ __ieee80211_rx_h_amsdu(struct ieee80211
>   					  data_offset, true))
>   		return RX_DROP_UNUSABLE;
>  =20
>  -	if (rx->sta && rx->sta->amsdu_mesh_control < 0) {
>  +	if (rx->sta->amsdu_mesh_control < 0) {
> - 		bool valid_std =3D ieee80211_is_valid_amsdu(skb, true);
> - 		bool valid_nonstd =3D ieee80211_is_valid_amsdu(skb, false);
> + 		s8 valid =3D -1;
> + 		int i;
> +=20
> + 		for (i =3D 0; i <=3D 2; i++) {
> + 			if (!ieee80211_is_valid_amsdu(skb, i))
> + 				continue;
> +=20
> + 			if (valid >=3D 0) {
> + 				/* ambiguous */
> + 				valid =3D -1;
> + 				break;
> + 			}
>  =20
> - 		if (valid_std && !valid_nonstd)
> - 			rx->sta->amsdu_mesh_control =3D 1;
> - 		else if (valid_nonstd && !valid_std)
> - 			rx->sta->amsdu_mesh_control =3D 0;
> + 			valid =3D i;
> + 		}
> +=20
> + 		rx->sta->amsdu_mesh_control =3D valid;
>   	}
>  =20
>   	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,

This is now a conflict between the net-next and net trees.

--=20
Cheers,
Stephen Rothwell

--Sig_/pxlJb5yfrRaqeCfuZZkYAsv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQqOJEACgkQAVBC80lX
0GzLUQf/Vekw0s3Sf5zcEYFTTxODgF3dtaKW6OfXDMO+9o5jENK4pkZH+PsZnHwu
46hzwu8Jo5rvcVvyPAMOJmzyucgtv0BMazIdcJbx+QNkW1CT1Br8LBoHWeXYwU1b
dL5jUtGgdJtvv2wharEL0LplvmE/B3A2MlWeJo+IwesL2sLnCCI9AeZZ9JB2rFWn
VvgF4ZJOgLR6dht9dMHyV31DnqiFENBsG/n1sCizcQ55ZihcXcvLAwssovILW8V5
yTtJ3/JLgnfRNelcPgmI5qsRj4Jd2/7OryxgLyqWRWpuDZL+erUW15o+4vqB44Cp
psLtzk+4KkGtmD8UOivpmGoRTmX/uA==
=RqQD
-----END PGP SIGNATURE-----

--Sig_/pxlJb5yfrRaqeCfuZZkYAsv--
