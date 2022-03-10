Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296DA4D55B7
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239514AbiCJXr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344870AbiCJXrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:47:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4286119E01F
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646956004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oXt6f6cLtIHiy0vpPclSvGUgoo3PYAuq0R9cH40xJt0=;
        b=f8WbBiXqGP4WcwrJrXELzp3ehdg489GlLQRwDM/rbBnzGWRYD7te+CXAfyiWoLOdUrzp0+
        D56LI5y+Ep3Kd71On250/1UGhKDiDi9k3tvsFtSvjqJiUr6b7cS6iCTFCfXc6fojlyFHQP
        FraqNSIYeoOayi9b6InaiKGsWQydBlo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-8kd5jOm3M72FPrZSMCRWsg-1; Thu, 10 Mar 2022 18:46:43 -0500
X-MC-Unique: 8kd5jOm3M72FPrZSMCRWsg-1
Received: by mail-qt1-f199.google.com with SMTP id w11-20020a05622a134b00b002dd15429effso5259184qtk.18
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:46:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oXt6f6cLtIHiy0vpPclSvGUgoo3PYAuq0R9cH40xJt0=;
        b=Knuj8H5LAD7eCNVpn7WhP71oqtqY/rmdqto4IntA6M+KbFLqBKuHRwuB6/eK2SCosx
         3W5XPViT0sqv934/x3TlV5GMmf7bsty3o8P/6QdGu7KAx/JD5Bg9Xmtgv3ccJvx+3YjS
         upYfv696gmfReSM6c3//Z2zT/I1hKjaw8xVsmDmPaH2caEyS3f442SEGKGIQ9xoxuS5Q
         SbnyMNgbBkDenF0nG87B/rUF8rLp6quSL8YF8k7yYNiywtZ+xN4K7gRn2iwUyWjsP7gt
         6mAVMf1QWP3oJsS5cb0255OvBWJJ3RAxvEEWZ8UXv32hkpLsLdKQMVdiyZnPv8xQwBDE
         J96g==
X-Gm-Message-State: AOAM530iSHK1ZzDD5fre0CxVLH5fXPi0Rg+0fG5TEyhbYO64axwUeSom
        AXWs6GzNbMO/pv6JoQ2r3ZYuQ1eXyu3LpG/fMsHVJ8BAbrokO7asWfp2AmUdckx7quEkhO3+duO
        8y+p5N4ujFKC2Uzzb
X-Received: by 2002:a05:620a:4308:b0:67b:487e:e02a with SMTP id u8-20020a05620a430800b0067b487ee02amr4790438qko.696.1646956002517;
        Thu, 10 Mar 2022 15:46:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyAbf1O9Nn5fcq2gbLsyHxoiS0Jt0YQ3PNs+QBQtxidM1cvJ+YUn7SjhbGw02/YBX2anjqy9A==
X-Received: by 2002:a05:620a:4308:b0:67b:487e:e02a with SMTP id u8-20020a05620a430800b0067b487ee02amr4790414qko.696.1646956002209;
        Thu, 10 Mar 2022 15:46:42 -0800 (PST)
Received: from localhost ([37.183.9.66])
        by smtp.gmail.com with ESMTPSA id v1-20020a05620a440100b0067d3fc2eaa6sm2941459qkp.96.2022.03.10.15.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 15:46:41 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:46:38 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: Re: [PATCH v4 bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order
 to accept non-linear skb
Message-ID: <YiqN3nxoOqznFPJm@lore-desk>
References: <cover.1646755129.git.lorenzo@kernel.org>
 <24703dbc3477a4b3aaf908f6226a566d27969f83.1646755129.git.lorenzo@kernel.org>
 <87ee3auk70.fsf@toke.dk>
 <YinkUiv/yC/gJhYZ@lore-desk>
 <87ilsly6db.fsf@toke.dk>
 <YipQzAGMyVbJQyhX@lore-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7HTl4t6538JpPN/x"
Content-Disposition: inline
In-Reply-To: <YipQzAGMyVbJQyhX@lore-desk>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7HTl4t6538JpPN/x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> >=20
> > >> Lorenzo Bianconi <lorenzo@kernel.org> writes:
> > >>=20
> > >> > Introduce veth_convert_xdp_buff_from_skb routine in order to
> > >> > convert a non-linear skb into a xdp buffer. If the received skb
> > >> > is cloned or shared, veth_convert_xdp_buff_from_skb will copy it
> > >> > in a new skb composed by order-0 pages for the linear and the
> > >> > fragmented area. Moreover veth_convert_xdp_buff_from_skb guarantees
> > >> > we have enough headroom for xdp.
> > >> > This is a preliminary patch to allow attaching xdp programs with f=
rags
> > >> > support on veth devices.
> > >> >
> > >> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > >>=20
> > >> It's cool that we can do this! A few comments below:
> > >
> > > Hi Toke,
> > >
> > > thx for the review :)
> > >
> > > [...]
> > >
> > >> > +static int veth_convert_xdp_buff_from_skb(struct veth_rq *rq,
> > >> > +					  struct xdp_buff *xdp,
> > >> > +					  struct sk_buff **pskb)
> > >> > +{
> > >>=20
> > >> nit: It's not really "converting" and skb into an xdp_buff, since the
> > >> xdp_buff lives on the stack; so maybe 'veth_init_xdp_buff_from_skb()=
'?
> > >
> > > I kept the previous naming convention used for xdp_convert_frame_to_b=
uff()
> > > (my goal would be to move it in xdp.c and reuse this routine for the
> > > generic-xdp use case) but I am fine with
> > > veth_init_xdp_buff_from_skb().
> >=20
> > Consistency is probably good, but right now we have functions of the
> > form 'xdp_convert_X_to_Y()' and 'xdp_update_Y_from_X()'. So to follow
> > that you'd have either 'veth_update_xdp_buff_from_skb()' or
> > 'veth_convert_skb_to_xdp_buff()' :)
>=20
> ack, I am fine with veth_convert_skb_to_xdp_buff()
>=20
> >=20
> > >> > +	struct sk_buff *skb =3D *pskb;
> > >> > +	u32 frame_sz;
> > >> > =20
> > >> >  	if (skb_shared(skb) || skb_head_is_locked(skb) ||
> > >> > -	    skb_is_nonlinear(skb) || headroom < XDP_PACKET_HEADROOM) {
> > >> > +	    skb_shinfo(skb)->nr_frags) {
> > >>=20
> > >> So this always clones the skb if it has frags? Is that really needed?
> > >
> > > if we look at skb_cow_data(), paged area is always considered not wri=
table
> >=20
> > Ah, right, did not know that. Seems a bit odd, but OK.
> >=20
> > >> Also, there's a lot of memory allocation and copying going on here; =
have
> > >> you measured the performance?
> > >
> > > even in the previous implementation we always reallocate the skb if t=
he
> > > conditions above are verified so I do not expect any difference in th=
e single
> > > buffer use-case but I will run some performance tests.
> >=20
> > No, I wouldn't expect any difference for the single-buffer case, but I
> > would also be interested in how big the overhead is of having to copy
> > the whole jumbo-frame?
>=20
> oh ok, I got what you mean. I guess we can compare the tcp throughput for
> the legacy skb mode (when no program is attached on the veth pair) and xd=
p=20
> mode (when we load a simple xdp program that just returns xdp_pass) when
> jumbo frames are enabled. I would expect a performance penalty but let's =
see.

I run the tests described above and I got the following results:

- skb mode mtu 1500B (TSO/GSO off): ~ 16.8 Gbps
- xdp mode mtu 1500B (XDP_PASS):    ~ 9.52 Gbps

- skb mode mtu 32KB (TSO/GSO off): ~ 41 Gbps
- xdp mode mtu 32KB (XDP_PASS):    ~ 25 Gbps

the (expected) performance penalty ratio (due to the copy) is quite constant

Regards,
Lorenzo

>=20
> >=20
> > BTW, just noticed one other change - before we had:
> >=20
> > > -	headroom =3D skb_headroom(skb) - mac_len;
> > >  	if (skb_shared(skb) || skb_head_is_locked(skb) ||
> > > -	    skb_is_nonlinear(skb) || headroom < XDP_PACKET_HEADROOM) {
> >=20
> >=20
> > And in your patch that becomes:
> >=20
> > > +	} else if (skb_headroom(skb) < XDP_PACKET_HEADROOM &&
> > > +		   pskb_expand_head(skb, VETH_XDP_HEADROOM, 0, GFP_ATOMIC)) {
> > > +		goto drop;
> >=20
> >=20
> > So the mac_len subtraction disappeared; that seems wrong?
>=20
> we call __skb_push before running veth_convert_xdp_buff_from_skb() in
> veth_xdp_rcv_skb().
>=20
> >=20
> > >> > +
> > >> > +	if (xdp_buff_has_frags(&xdp))
> > >> > +		skb->data_len =3D skb_shinfo(skb)->xdp_frags_size;
> > >> > +	else
> > >> > +		skb->data_len =3D 0;
> > >>=20
> > >> We can remove entire frags using xdp_adjust_tail, right? Will that g=
et
> > >> propagated in the right way to the skb frags due to the dual use of
> > >> skb_shared_info, or?
> > >
> > > bpf_xdp_frags_shrink_tail() can remove entire frags and it will modify
> > > metadata contained in the skb_shared_info (e.g. nr_frags or the frag
> > > size of the given page). We should consider the data_len field in this
> > > case. Agree?
> >=20
> > Right, that's what I assumed; makes sense. But adding a comment
> > mentioning this above the update of data_len might be helpful? :)
>=20
> ack, will do.
>=20
> Regards,
> Lorenzo
>=20
> >=20
> > -Toke
> >=20



--7HTl4t6538JpPN/x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYiqN3gAKCRA6cBh0uS2t
rI5iAP95Zx+xeW+IB/giP5v4YiVpuAVhR4D4FZfRZbkmAiTPgwD7Bl2KOsR+0AIb
QBuRFRu6XRwzc4HAFiDxDoB9CYCZPA4=
=blfp
-----END PGP SIGNATURE-----

--7HTl4t6538JpPN/x--

