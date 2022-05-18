Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDD152B735
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiERJxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbiERJxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:53:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13B15534C;
        Wed, 18 May 2022 02:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61D87B81EF2;
        Wed, 18 May 2022 09:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFF4C385AA;
        Wed, 18 May 2022 09:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652867596;
        bh=5gqBzS4hqEVHVcDeIKJ/pK7OHoUOClp7PDlQPjda0Io=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VQu+0AvIuaLFj51kcWbrHdXMufiGQ8dLdZrQMZlv9ew+7v1D5kCkTR+/hu9ihcKRJ
         Q8px1Mla06YbjbT0IYMlCndab+4tc1Wali8zfU/D2vwDHHaQar0KFyR4Fsyp6xRiCT
         Ufr2GX85FcQZwHyCv9SmbfCwsmqX72RWWHQyYFdybHhO2TKHVtiXoG8lFfw7ggQLvB
         sLfGqKxL+I43O2k8lhETvuFZSIGP5V+5beoQkSqPKXxiVb7DmdP/GiiGd3tgk1DJY+
         CbsK1PHAAC7Fvc8cFPELPKLIpO9Tpa5oSWfiizfdmLgai29x6qrPVNjA7PKMeNrqDi
         38tZC1y7ziuWg==
Date:   Wed, 18 May 2022 11:53:12 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 12/15] net: ethernet: mtk_eth_soc: introduce
 MTK_NETSYS_V2 support
Message-ID: <YoTCCAKpE5ijiom0@lore-desk>
References: <cover.1652716741.git.lorenzo@kernel.org>
 <cc1bd411e3028e2d6b0365ed5d29f3cea66223f8.1652716741.git.lorenzo@kernel.org>
 <20220517184433.3cb2fd5a@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="py/BeQuNQzkJfHTN"
Content-Disposition: inline
In-Reply-To: <20220517184433.3cb2fd5a@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--py/BeQuNQzkJfHTN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On May 17, Jakub Kicinski wrote:
> On Mon, 16 May 2022 18:06:39 +0200 Lorenzo Bianconi wrote:
> > +	struct mtk_mac *mac =3D netdev_priv(dev);
> > +	struct mtk_tx_dma_v2 *desc =3D txd;
> > +	struct mtk_eth *eth =3D mac->hw;
> > +	u32 data;
> > +
> > +	WRITE_ONCE(desc->txd1, info->addr);
> > +
> > +	data =3D TX_DMA_PLEN0(info->size);
> > +	if (info->last)
> > +		data |=3D TX_DMA_LS0;
> > +	WRITE_ONCE(desc->txd3, data);
> > +
> > +	if (!info->qid && mac->id)
> > +		info->qid =3D MTK_QDMA_GMAC2_QID;
> > +
> > +	data =3D (mac->id + 1) << TX_DMA_FPORT_SHIFT_V2; /* forward port */
> > +	data |=3D TX_DMA_SWC_V2 | QID_BITS_V2(info->qid);
> > +	WRITE_ONCE(desc->txd4, data);
> > +
> > +	data =3D 0;
> > +	if (info->first) {
> > +		if (info->gso)
> > +			data |=3D TX_DMA_TSO_V2;
> > +		/* tx checksum offload */
> > +		if (info->csum)
> > +			data |=3D TX_DMA_CHKSUM_V2;
> > +	}
> > +	WRITE_ONCE(desc->txd5, data);
> > +
> > +	data =3D 0;
> > +	if (info->first && info->vlan)
> > +		data |=3D TX_DMA_INS_VLAN_V2 | info->vlan_tci;
> > +	WRITE_ONCE(desc->txd6, data);
> > +
> > +	WRITE_ONCE(desc->txd7, 0);
> > +	WRITE_ONCE(desc->txd8, 0);
>=20
> Why all the WRITE_ONCE()? Don't you just need a barrier between writing
> the descriptor and kicking the HW?=20

I used this approach just to be aligned with current codebase:
https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mediatek=
/mtk_eth_soc.c#L1006
https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mediatek=
/mtk_eth_soc.c#L1031

but I guess we can even convert the code to use barrier instead. Agree?

Regards,
Lorenzo

--py/BeQuNQzkJfHTN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYoTCCAAKCRA6cBh0uS2t
rFcEAPsEE4SH1pWFhrUuCVVh5wJ9R0iCDZrsIRMA13UFQ1FqcAEA/i7P7a2wwN3o
b/PBY5gsePzROcyMFUtToLos6mKsrwg=
=kZTh
-----END PGP SIGNATURE-----

--py/BeQuNQzkJfHTN--
