Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBBA667F5D
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 20:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbjALTbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 14:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjALTbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 14:31:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9292AC3
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 11:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673551514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LmPmuQ9gL4nLxbYEYTDRNpgHfjXbGiU/X0vTwjJsUoQ=;
        b=KON7PGeoI1hAgMipbM4g6zhRxep5K+a2dMkGMxja+D0Nmw8/RbaG4XKVzLCsynxldGA2jJ
        Ni1w4CfF9AsgM4L3dWZhr0gwxNsliCWYRFC2D0QRXtKncw0Zo4bkbpItDGAyQLV5uoy0QG
        PQb1TsYeZZCYIiNWR3BJo0IX/4ILA4E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-52-hi1cYDrwMVSxMWKZZrzh9Q-1; Thu, 12 Jan 2023 14:25:13 -0500
X-MC-Unique: hi1cYDrwMVSxMWKZZrzh9Q-1
Received: by mail-wr1-f70.google.com with SMTP id g24-20020adfa498000000b002bbeb5fc4b7so3176232wrb.10
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 11:25:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmPmuQ9gL4nLxbYEYTDRNpgHfjXbGiU/X0vTwjJsUoQ=;
        b=Ve8XbSKnOoIiKDHA5O2iPk6wPM5UJjZuVcGqr/GbEfuevnpsim7wofYS7Kvdnt58jQ
         hG8J1auLdC1+XdLHPhrkSEZT1+IKQL3NP6P1+6nc0PZowC3IIFd5Ru23UhXmydcH99oz
         mgJhEKqbgUEB3Q9upqn5qGUBm/lyDM3uEnOUyKmYtNdq+2cjpJOqbFhhNS0i250DIy73
         HDzMnADUFkaE0nSeF0uMblIqZftaNLbc9FGhlZPOE/uijrluQJlinOuuyEO7+0k9nZQb
         IoqEBSaCevVCqH77ZS+m3DUQpaOUWtaUPinrAuHNkQ8IzqnzM3Q88en83NZalpkJugfI
         xYyA==
X-Gm-Message-State: AFqh2krinN8T3vzljull0Ix6Hl8V5MmqdTQMSOVa7G6/Bzz3kHrSL3SR
        rrHmmiks6tStZBtDMm4emkiwpk7U1jnyLJoaXkYZTPeSXBADTFFllWjYoGFV82IiGgSKX0keFbw
        bxFLLnH7/KN026XB8
X-Received: by 2002:a05:600c:4d25:b0:3d3:5b7a:1791 with SMTP id u37-20020a05600c4d2500b003d35b7a1791mr67368474wmp.41.1673551507511;
        Thu, 12 Jan 2023 11:25:07 -0800 (PST)
X-Google-Smtp-Source: AMrXdXudbazJdSZY97fD0GpKHa91U1CL2WPC7qDBoANZ6AvIHOdBj2VZRTJZPvsFFt47yTk0WsoEMA==
X-Received: by 2002:a05:600c:4d25:b0:3d3:5b7a:1791 with SMTP id u37-20020a05600c4d2500b003d35b7a1791mr67368456wmp.41.1673551507237;
        Thu, 12 Jan 2023 11:25:07 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id k30-20020a05600c1c9e00b003d9b89a39b2sm25395568wms.10.2023.01.12.11.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 11:25:05 -0800 (PST)
Date:   Thu, 12 Jan 2023 20:25:03 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: Re: [PATCH v5 net-next 5/5] net: ethernet: mtk_wed: add
 reset/reset_complete callbacks
Message-ID: <Y8Bej+76EiNyApWE@lore-desk>
References: <cover.1673457624.git.lorenzo@kernel.org>
 <0a22f0c81e87fde34e3444e1bc83012a17498e8e.1673457624.git.lorenzo@kernel.org>
 <02cfb1dd78f6efb1ae3077de24fa357091168d39.camel@gmail.com>
 <Y8A0r6IA+l5RzDXq@lore-desk>
 <CAKgT0UeX0n0b887MWUXiO54-PBMhxgSKPTab9AX3LPk3R4fS+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0WJ3yzgKXgDJAM2z"
Content-Disposition: inline
In-Reply-To: <CAKgT0UeX0n0b887MWUXiO54-PBMhxgSKPTab9AX3LPk3R4fS+w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0WJ3yzgKXgDJAM2z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Jan 12, 2023 at 8:26 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > > On Wed, 2023-01-11 at 18:22 +0100, Lorenzo Bianconi wrote:
> > > > Introduce reset and reset_complete wlan callback to schedule WLAN d=
river
> > > > reset when ethernet/wed driver is resetting.
> > > >
> > > > Tested-by: Daniel Golle <daniel@makrotopia.org>
> > > > Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > > > Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  drivers/net/ethernet/mediatek/mtk_eth_soc.c |  7 ++++
> > > >  drivers/net/ethernet/mediatek/mtk_wed.c     | 40 +++++++++++++++++=
++++
> > > >  drivers/net/ethernet/mediatek/mtk_wed.h     |  8 +++++
> > > >  include/linux/soc/mediatek/mtk_wed.h        |  2 ++
> > > >  4 files changed, 57 insertions(+)
> > > >
> > >
> > > Do we have any updates on the implementation that would be making use
> > > of this? It looks like there was a discussion for the v2 of this set =
to
> > > include a link to an RFC posting that would make use of this set.
> >
> > I posted the series to linux-wireless mailing list adding netdev one in=
 cc:
> > https://lore.kernel.org/linux-wireless/cover.1673103214.git.lorenzo@ker=
nel.org/T/#md34b4ffcb07056794378fa4e8079458ecca69109
>=20
> Thanks. It would be useful to include this link in the next revision
> to make it easier to review.

ack, will do.

>=20
> > >
> > > > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/=
net/ethernet/mediatek/mtk_eth_soc.c
> > > > index 1af74e9a6cd3..0147e98009c2 100644
> > > > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > > @@ -3924,6 +3924,11 @@ static void mtk_pending_work(struct work_str=
uct *work)
> > > >     set_bit(MTK_RESETTING, &eth->state);
> > > >
> > > >     mtk_prepare_for_reset(eth);
> > > > +   mtk_wed_fe_reset();
> > > > +   /* Run again reset preliminary configuration in order to avoid =
any
> > > > +    * possible race during FE reset since it can run releasing RTN=
L lock.
> > > > +    */
> > > > +   mtk_prepare_for_reset(eth);
> > > >
> > > >     /* stop all devices to make sure that dma is properly shut down=
 */
> > > >     for (i =3D 0; i < MTK_MAC_COUNT; i++) {
> > > > @@ -3961,6 +3966,8 @@ static void mtk_pending_work(struct work_stru=
ct *work)
> > > >
> > > >     clear_bit(MTK_RESETTING, &eth->state);
> > > >
> > > > +   mtk_wed_fe_reset_complete();
> > > > +
> > > >     rtnl_unlock();
> > > >  }
> > > >
> > > > diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/=
ethernet/mediatek/mtk_wed.c
> > > > index a6271449617f..4854993f2941 100644
> > > > --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> > > > +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> > > > @@ -206,6 +206,46 @@ mtk_wed_wo_reset(struct mtk_wed_device *dev)
> > > >     iounmap(reg);
> > > >  }
> > > >
> > > > +void mtk_wed_fe_reset(void)
> > > > +{
> > > > +   int i;
> > > > +
> > > > +   mutex_lock(&hw_lock);
> > > > +
> > > > +   for (i =3D 0; i < ARRAY_SIZE(hw_list); i++) {
> > > > +           struct mtk_wed_hw *hw =3D hw_list[i];
> > > > +           struct mtk_wed_device *dev =3D hw->wed_dev;
> > > > +
> > > > +           if (!dev || !dev->wlan.reset)
> > > > +                   continue;
> > > > +
> > > > +           /* reset callback blocks until WLAN reset is completed =
*/
> > > > +           if (dev->wlan.reset(dev))
> > > > +                   dev_err(dev->dev, "wlan reset failed\n");
> > >
> > > The reason why having the consumer would be useful are cases like thi=
s.
> > > My main concern is if the error value might be useful to actually
> > > expose rather than just treating it as a boolean. Usually for things
> > > like this I prefer to see the result captured and if it indicates err=
or
> > > we return the error value since this could be one of several possible
> > > causes for the error assuming this returns an int and not a bool.
> >
> > we can have 2 independent wireless chips connected here so, if the firs=
t one
> > fails, should we exit or just log the error?
>=20
> I would think you should log the error. I notice in your wireless
> implementation you can return BUSY or TIMEOUT. Rather than doing the
> dev_err in your reset function to distinguish between the two you
> could just return the error and leave the printing of the error to
> this dev_err message.

ack, will do.

>=20
> Also a follow-on question I had. It looks like reset_complete returns
> an int but it is being ignored and in your implementation it is just
> returning 0. Should that be a void instead of an int?
>=20

ack, will do.

Regards,
Lorenzo

--0WJ3yzgKXgDJAM2z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY8BejwAKCRA6cBh0uS2t
rNRqAP44D4ZAWSKiwRwNPElbUUvRAK0RmgBpCWsQmQIkdtwnBAD/bR6fE/qNYTES
kcCwEEWC2oLr5ZnqbHFpa/WTweWNBwI=
=IXq4
-----END PGP SIGNATURE-----

--0WJ3yzgKXgDJAM2z--

