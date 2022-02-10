Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A59F4B144F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242694AbiBJRey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:34:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241940AbiBJRex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:34:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7787EF1B;
        Thu, 10 Feb 2022 09:34:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E8F361E09;
        Thu, 10 Feb 2022 17:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8ADC340EF;
        Thu, 10 Feb 2022 17:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644514493;
        bh=RAVYSQx/4ghHVPmoaDi8n9up8m/CMo9DBlGXzYcSIFw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CIjUCVaQsjeyd1CU80njQyKfL+bV0DV7/HM7/twCsBGOVRnHLNtbPTmPx/eg5fu3f
         GqWkvWXr6HGenw0VArRpEe2Pln7aoYsKnNXVeaWZj8HgUrQWWByXNkKbSfOv5wf7YM
         pb1jEJRpsffvLxGsrYRqbQkdBOc9yIRVmXrygj8qLgUi2FzBWtx2CCgTYHaQzaC2mW
         un3tSL46ROfv7ACG64P3/APrRvfLGmOCHo+genBe8v/vUgXvxV3E7/eMaLryUi9v21
         Ue98SDuToMh3Csh46y4CW5JWdT5vfxM76gmwer7KpLoqgxPmeaGb4v5bmkxVkyGEOV
         zaK6cN2V02QEQ==
Date:   Thu, 10 Feb 2022 18:34:49 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>
Subject: Re: [PATCH bpf-next] net: veth: account total xdp_frame len running
 ndo_xdp_xmit
Message-ID: <YgVMufwV+z7HYfH0@lore-desk>
References: <705a05194508bc0c1b0c1a5de081bbb60f2693a5.1643712078.git.lorenzo@kernel.org>
 <CAADnVQJoWF8co=9YNdvQkziwsOAoqw=p134aHTL9YZ82=QJcRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fEji8xlfT1CMJWVv"
Content-Disposition: inline
In-Reply-To: <CAADnVQJoWF8co=9YNdvQkziwsOAoqw=p134aHTL9YZ82=QJcRA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fEji8xlfT1CMJWVv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Feb 1, 2022 at 2:46 AM Lorenzo Bianconi <lorenzo@kernel.org> wrot=
e:
> >
> > Introduce xdp_get_frame_len utility routine to get the xdp_frame full
> > length and account total frame size running XDP_REDIRECT of a
> > non-linear xdp frame into a veth device.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/veth.c |  4 ++--
> >  include/net/xdp.h  | 14 ++++++++++++++
> >  2 files changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 354a963075c5..22ecaf8b8f98 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -493,7 +493,7 @@ static int veth_xdp_xmit(struct net_device *dev, in=
t n,
> >                 struct xdp_frame *frame =3D frames[i];
> >                 void *ptr =3D veth_xdp_to_ptr(frame);
> >
> > -               if (unlikely(frame->len > max_len ||
> > +               if (unlikely(xdp_get_frame_len(frame) > max_len ||
> >                              __ptr_ring_produce(&rq->xdp_ring, ptr)))
> >                         break;
>=20
> Looks correct, but could you explain what happens without this fix?

I guess this is just a theoretical issue, since at the moment we can't perf=
orm
a XDP_REDIRECT with a non-linear xdp buffer, but without this patch we will=
 fail
to account peer max packet size since we take care of just the linear part =
of
the xdp_buff.
I am working on adding xdp multi-buff support to veth driver so I will repo=
st this
patch into the series.

>=20
> Any other drivers might have the same issue?

I do not think so since other drivers are not able to map multi-frags yet (=
veth
already support it since we run __xdp_build_skb_from_frame()).

Regards,
Lorenzo

--fEji8xlfT1CMJWVv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYgVMuQAKCRA6cBh0uS2t
rEOlAQCnhlHABC7kVQ+OnphlPVGyPvthx41F4zdr2wZTzkCnDAD/fGkIjtY6oPJ5
CbjDzGiLMyWhwNYJMpGPO7qthkthSQY=
=C658
-----END PGP SIGNATURE-----

--fEji8xlfT1CMJWVv--
