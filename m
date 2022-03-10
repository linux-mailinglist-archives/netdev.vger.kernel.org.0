Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCBD4D4614
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 12:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241499AbiCJLoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 06:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241761AbiCJLo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 06:44:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0F69145AE6
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 03:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646912600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lv3jLStTHDx9pIIehZeBR/P5OFpCscaUeKQYtaO9J88=;
        b=N6hBCc3/THnCj+WJ0tqffK3LVzdLpGHTIFnRn/AArcD6PEMfP2Tsof90RXuKw9iaeUgjh1
        ynluLeOIb2e/udfAajs7uvmedHrz6j2CmEbpwn3+KItxipN6nIVDKtVbsoTDm7KKQeUgBO
        JzM3LKwM33YTE2CMQluPUaWTr3Oes0Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-eSu4BCjOMaCBRIyVl7isIg-1; Thu, 10 Mar 2022 06:43:18 -0500
X-MC-Unique: eSu4BCjOMaCBRIyVl7isIg-1
Received: by mail-wr1-f70.google.com with SMTP id z16-20020adff1d0000000b001ef7dc78b23so1588638wro.12
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 03:43:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lv3jLStTHDx9pIIehZeBR/P5OFpCscaUeKQYtaO9J88=;
        b=yLZ8XV7t193Ch+31iM4mzxVfU8eGNFMr6kaHjwABATw4vqBBFwdaB8xL/IKS3fMB0v
         5lXXP+ZVtSOa4gKpjOP6i5MutSo5rBCNmSgC1cWjhMqY2l+9Iyz6mlqYfjLG2rWmuaIX
         btpTqen/8Rb9S4VbIP8T/BqBiKV+sV+ny5+8hkHV4bHWaIYmJ5wlYq3/phk/U31l6AM1
         5/4NXt3gF5WjmwHo8AU7Jr+Cs6/uYepfG6TIhIlbCIsxVM9YjqT4lJozKaBHe1N1gHGX
         omeQM5qfkQnPFe0xaKArbie8vdpKMq431W1whvJ3kZKSIz/QLUkNuF7nEsfNnPwhHLr5
         gDkw==
X-Gm-Message-State: AOAM532VOsMdbzFV6yA33NBCT0THwRy3Oh8p6XjJksorwBYQRaaaFNjG
        5lxF5Zml/Qg4BRvbndd6vd1NgpfWC6ouOmpAx8/Jj2daP7nlYZQTmy51conGjUmCGJHmvxxNtiH
        YVJBG6l44OkKXpRY4
X-Received: by 2002:adf:f5c5:0:b0:1ed:bc44:63e4 with SMTP id k5-20020adff5c5000000b001edbc4463e4mr3307308wrp.236.1646912597411;
        Thu, 10 Mar 2022 03:43:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjLuElTWKtMfe3e05qseSNHDzbSk8W1f/geXhuoNVAo3LEF/oenypiYw3I0JieQAq3FqiPiA==
X-Received: by 2002:adf:f5c5:0:b0:1ed:bc44:63e4 with SMTP id k5-20020adff5c5000000b001edbc4463e4mr3307283wrp.236.1646912597175;
        Thu, 10 Mar 2022 03:43:17 -0800 (PST)
Received: from localhost ([37.183.9.66])
        by smtp.gmail.com with ESMTPSA id w6-20020a5d6806000000b002036515dda7sm4050451wru.33.2022.03.10.03.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 03:43:16 -0800 (PST)
Date:   Thu, 10 Mar 2022 12:43:14 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: Re: [PATCH v4 bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order
 to accept non-linear skb
Message-ID: <YinkUiv/yC/gJhYZ@lore-desk>
References: <cover.1646755129.git.lorenzo@kernel.org>
 <24703dbc3477a4b3aaf908f6226a566d27969f83.1646755129.git.lorenzo@kernel.org>
 <87ee3auk70.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7lnIUU83iotuCzDe"
Content-Disposition: inline
In-Reply-To: <87ee3auk70.fsf@toke.dk>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7lnIUU83iotuCzDe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20
> > Introduce veth_convert_xdp_buff_from_skb routine in order to
> > convert a non-linear skb into a xdp buffer. If the received skb
> > is cloned or shared, veth_convert_xdp_buff_from_skb will copy it
> > in a new skb composed by order-0 pages for the linear and the
> > fragmented area. Moreover veth_convert_xdp_buff_from_skb guarantees
> > we have enough headroom for xdp.
> > This is a preliminary patch to allow attaching xdp programs with frags
> > support on veth devices.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> It's cool that we can do this! A few comments below:

Hi Toke,

thx for the review :)

[...]

> > +static int veth_convert_xdp_buff_from_skb(struct veth_rq *rq,
> > +					  struct xdp_buff *xdp,
> > +					  struct sk_buff **pskb)
> > +{
>=20
> nit: It's not really "converting" and skb into an xdp_buff, since the
> xdp_buff lives on the stack; so maybe 'veth_init_xdp_buff_from_skb()'?

I kept the previous naming convention used for xdp_convert_frame_to_buff()
(my goal would be to move it in xdp.c and reuse this routine for the
generic-xdp use case) but I am fine with veth_init_xdp_buff_from_skb().

>=20
> > +	struct sk_buff *skb =3D *pskb;
> > +	u32 frame_sz;
> > =20
> >  	if (skb_shared(skb) || skb_head_is_locked(skb) ||
> > -	    skb_is_nonlinear(skb) || headroom < XDP_PACKET_HEADROOM) {
> > +	    skb_shinfo(skb)->nr_frags) {
>=20
> So this always clones the skb if it has frags? Is that really needed?

if we look at skb_cow_data(), paged area is always considered not writable

>=20
> Also, there's a lot of memory allocation and copying going on here; have
> you measured the performance?

even in the previous implementation we always reallocate the skb if the
conditions above are verified so I do not expect any difference in the sing=
le
buffer use-case but I will run some performance tests.

>=20

[...]

> > +
> > +	if (xdp_buff_has_frags(&xdp))
> > +		skb->data_len =3D skb_shinfo(skb)->xdp_frags_size;
> > +	else
> > +		skb->data_len =3D 0;
>=20
> We can remove entire frags using xdp_adjust_tail, right? Will that get
> propagated in the right way to the skb frags due to the dual use of
> skb_shared_info, or?

bpf_xdp_frags_shrink_tail() can remove entire frags and it will modify meta=
data
contained in the skb_shared_info (e.g. nr_frags or the frag size of
the given page). We should consider the data_len field in this case. Agree?

Regards,
Lorenzo

>=20

--7lnIUU83iotuCzDe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYinkUgAKCRA6cBh0uS2t
rPV3AQD9dCxckpCRsZy806fPlpUH4k5DTToXqM3PHWOztuxtGgD/R3LwMZNV24mK
h7zmBfR//JSvD0w77HLj3e/LTVk+qw4=
=gGvF
-----END PGP SIGNATURE-----

--7lnIUU83iotuCzDe--

