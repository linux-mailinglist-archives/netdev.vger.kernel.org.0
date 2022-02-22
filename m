Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9623C4C00DF
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiBVSEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbiBVSEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:04:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62A003587F
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645553012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BJiWgJgb0ZSyBw+wP4sGAVZeW0Dqx7Uf85QQGbwKcAw=;
        b=IZwy0kyR3AMcar+v02OfFij7ueESIKiotpk0IHYLaic3cN5f0sdftUbogxkyU9CikZykZb
        VX18c5J50YVZJkEMwqWBRJ1N9AeRD52u7A1TyZIgzEglalGRs4DxEXUy0Ep9Xu9zFOFZXT
        ZWlpGa5T01pl72pXkRZjX9ofBFKE3l0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-rxHjvj0uNwO2qKaTivIr2g-1; Tue, 22 Feb 2022 13:03:30 -0500
X-MC-Unique: rxHjvj0uNwO2qKaTivIr2g-1
Received: by mail-wm1-f71.google.com with SMTP id m21-20020a7bcf35000000b00380e364b5d2so623875wmg.2
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:03:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BJiWgJgb0ZSyBw+wP4sGAVZeW0Dqx7Uf85QQGbwKcAw=;
        b=YtahWk6OdTrWmYJECWvg6RfEVHwCKw9cXQMmpJarIBz7I+vyAquFJQxX3dWVqmvtI+
         9q/ii5K3IEgpNTpdHemKsi0KNu4UnT1ndAyxf9ozIetWfnoA94Nc9RpOoUycJTcnCPnv
         L1p3T3iHth2ZqXbhVIaEYY8jtQnh2gnYXmoLjTrIYgtjmyFe7cN1oyzW0MQ95KOGHnQN
         cZZq5CrLTzi3fLypKCp+PzTMriWanBhk06C0VwLUZM40BSdS3ePSUTZF9aG6sX+5WrB5
         Rm0mQdVAkED0s1OOF8+sRugSJs/06n6amP/n7eXfjDv3Cf1a2Pq6JYGS4m9g4xVohBwr
         SiBg==
X-Gm-Message-State: AOAM530cAMQXi0bWU9Ti1bB0Ojlq470iLM/fijdqdVqvi1ruBHhobmIn
        7wq0aMC9Wzi0RCHAAvVbAVklM8qjxpQQRDOTpVxwB95Rqb+6dHpW5IDOGzs8bYo60dPjWUmu/jg
        kPk7IWUHrZk5AkATo
X-Received: by 2002:a05:6000:1141:b0:1e4:b28e:461d with SMTP id d1-20020a056000114100b001e4b28e461dmr19576898wrx.320.1645553009270;
        Tue, 22 Feb 2022 10:03:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyA/Mo3iHfCI33/hlFBw3ASdrXtJ+8ydxtX9DYEFEFS8y2zhU9O8UMROIZFawboMrHMebgu8Q==
X-Received: by 2002:a05:6000:1141:b0:1e4:b28e:461d with SMTP id d1-20020a056000114100b001e4b28e461dmr19576876wrx.320.1645553008994;
        Tue, 22 Feb 2022 10:03:28 -0800 (PST)
Received: from localhost (net-37-182-17-113.cust.vodafonedsl.it. [37.182.17.113])
        by smtp.gmail.com with ESMTPSA id v124-20020a1cac82000000b0037c3d08e0e7sm2951726wme.29.2022.02.22.10.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 10:03:28 -0800 (PST)
Date:   Tue, 22 Feb 2022 19:03:26 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        toke@redhat.com, echaudro@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: Re: [PATCH v2 bpf-next 3/3] veth: allow jumbo frames in xdp mode
Message-ID: <YhUlbui5VNCG0p7h@lore-desk>
References: <cover.1644930124.git.lorenzo@kernel.org>
 <15943b59b1638515770b7ab841b0d741dc314c3a.1644930125.git.lorenzo@kernel.org>
 <0c9bc29843cd1697aa89ebceb61b8efe8156a9e8.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fBPXmG+qnzKw0Oit"
Content-Disposition: inline
In-Reply-To: <0c9bc29843cd1697aa89ebceb61b8efe8156a9e8.camel@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fBPXmG+qnzKw0Oit
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 2022-02-15 at 14:08 +0100, Lorenzo Bianconi wrote:
> > Allow increasing the MTU over page boundaries on veth devices
> > if the attached xdp program declares to support xdp fragments.
> > Enable NETIF_F_ALL_TSO when the device is running in xdp mode.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/veth.c | 26 +++++++++++---------------
> >  1 file changed, 11 insertions(+), 15 deletions(-)
> >=20
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index a45aaaecc21f..2e048f957bc6 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -292,8 +292,6 @@ static int veth_forward_skb(struct net_device *dev,=
 struct sk_buff *skb,
> >  /* return true if the specified skb has chances of GRO aggregation
> >   * Don't strive for accuracy, but try to avoid GRO overhead in the most
> >   * common scenarios.
> > - * When XDP is enabled, all traffic is considered eligible, as the xmit
> > - * device has TSO off.
> >   * When TSO is enabled on the xmit device, we are likely interested on=
ly
> >   * in UDP aggregation, explicitly check for that if the skb is suspect=
ed
> >   * - the sock_wfree destructor is used by UDP, ICMP and XDP sockets -
> > @@ -334,7 +332,8 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, s=
truct net_device *dev)
> >  		 * Don't bother with napi/GRO if the skb can't be aggregated
> >  		 */
> >  		use_napi =3D rcu_access_pointer(rq->napi) &&
> > -			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
> > +			   (rcu_access_pointer(rq->xdp_prog) ||
> > +			    veth_skb_is_eligible_for_gro(dev, rcv, skb));
>=20
> Sorry for the late feedback. I think the code would be more readable if
> you move the additional check inside 'veth_skb_is_eligible_for_gro' and
> adjust veth_skb_is_eligible_for_gro() comment accordingly.

Hi Paolo,

sure, will do in v3.

Regards,
Lorenzo

>=20
> Thanks!
>=20
> Paolo
>=20

--fBPXmG+qnzKw0Oit
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYhUlbgAKCRA6cBh0uS2t
rBoaAP90qtpUltQFXb+ntGb/XOC0W/QsLuTRq90Rxc0K4N4lAwD+IB62cznIEA01
lXh2f/PtJfUwdsmueGSdI1VUrzWRCwY=
=howh
-----END PGP SIGNATURE-----

--fBPXmG+qnzKw0Oit--

