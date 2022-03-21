Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781A04E2637
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347291AbiCUMT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347284AbiCUMTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:19:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387132610;
        Mon, 21 Mar 2022 05:17:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 385F3B81113;
        Mon, 21 Mar 2022 12:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC92C340ED;
        Mon, 21 Mar 2022 12:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647865075;
        bh=hbP3AhpoO/lToYp8LoQ9mqTkP3bOAZmEeLFUOjeqlE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IXofndBYpDF6Q4ynAxlesxXvjWCdKNz59sdZq+XJnYTyu3dO+ckC4OcdxtMyveGXe
         ekYwKCfFGR+Jrck/p22LsfOEToc0KC+6aua9e/k+7Z/qtyjqbJ+hqhcc4vDq/XtTNh
         VFa0KYZKd15OYX6B6fFzPvik4/A8JdNp42YMrwA1d8FpE9EbH8ZpRXrcsNrw06iSmj
         KoPpIHjXCoEaCBjZ1iceEjUQc2LdkO5NAaFhl/P78AWlgC55Go7J5R7OdmQ/WCrTaL
         qGS6nacRL9bOgSHN3/zWUBuyYpoTGyjPEd1/Bi0E39yxl9dxCTRRI2q4XRwM5DTnMS
         A34kP1r6jS23w==
Date:   Mon, 21 Mar 2022 13:17:51 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        pabeni@redhat.com, toke@redhat.com, andrii@kernel.org, nbd@nbd.name
Subject: Re: [PATCH bpf-next] net: xdp: introduce XDP_PACKET_HEADROOM_MIN for
 veth and generic-xdp
Message-ID: <Yjhs73opbYZtALO9@lore-desk>
References: <039064e87f19f93e0d0347fc8e5c692c789774e6.1647630686.git.lorenzo@kernel.org>
 <20220318123323.75973f84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YjTji4qgDbrXg4D+@lore-desk>
 <20220318140153.592ac996@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FG50AM7opr1QyoaJ"
Content-Disposition: inline
In-Reply-To: <20220318140153.592ac996@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FG50AM7opr1QyoaJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 18 Mar 2022 20:54:51 +0100 Lorenzo Bianconi wrote:
> > > IIUC the initial purpose of SKB mode was to be able to test or
> > > experiment with XDP "until drivers add support". If that's still
> > > the case the semantics of XDP SKB should be as close to ideal
> > > XDP implementation as possible.
> >=20
> > XDP in skb-mode is useful if we want to perform a XDP_REDIRECT from
> > an ethernet driver into a wlan device since mac80211 requires a skb.
>=20
> Ack, I understand the use case is real, but given that the TC
> alternative exists we can apply more scrutiny to the trade offs.
> IMO production use of XDP skb mode would be a mistake, the thing=20
> is a layering violation by nature. Our time is better spent making
> TC / XDP code portability effortless.

ack, got your point, but I guess there is still a value running the same xdp
program instead of switching to a tc one if the driver does not support
native xdp. Anyway I am fine dropping this patch.

>=20
> > > We had a knob for specifying needed headroom, is that thing not
> > > working / not a potentially cleaner direction?
> > >
> >
> > which one do you mean? I guess it would be useful :)
>=20
> We have ndo_set_rx_headroom and dev->needed_headroom.
> Sorry for brevity, I'm on the move today, referring to things=20
> from memory :)
:)

Do you mean set dev->needed_headroom based on XDP_HEADROOM if the device is
running in xdp mode, right? I guess this is doable for veth, but what is
the right value for generic-xdp? Am I missing something?

Regards,
Lorenzo

--FG50AM7opr1QyoaJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYjhs7wAKCRA6cBh0uS2t
rItiAP41uEM2CZGE/+VdpLQICO7PdhduEKGyyVNOWXBq7a1ekQEA3n/RP33f3c6e
FOotPhLQ68xpRAdH7sHjfHha9OF3EgE=
=UVOv
-----END PGP SIGNATURE-----

--FG50AM7opr1QyoaJ--
