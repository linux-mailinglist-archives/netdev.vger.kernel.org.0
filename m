Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCDC6ECF66
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjDXNl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbjDXNll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:41:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767968A6E
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 06:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682343635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q3oVwJNzTFkgSQFuAMtj6ntCf48bt9Cidl8iSc0WSxY=;
        b=KVrh/uT25fIYz5umv6wKz+NJ1yKbDA3hGRXzhk6N6VpdZYwFH97ORB31uBJ8qysAcLfpaO
        crRTjky4wpfaAsj0f5nArwYPm3OFOMvNzP1UusBQ32iNaXZE7uQEtvBnniRCTT3XGxGpUz
        NASioUs8fGlhG3WDQGWg4DNwYf8MxD0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-tTxTTkTEMCyk-gOVOA_lMw-1; Mon, 24 Apr 2023 09:40:34 -0400
X-MC-Unique: tTxTTkTEMCyk-gOVOA_lMw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-5ef5fe13973so27820296d6.0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 06:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682343633; x=1684935633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q3oVwJNzTFkgSQFuAMtj6ntCf48bt9Cidl8iSc0WSxY=;
        b=h+O8/Whxr8vp48N94EqA1ZnAFCuARpy/QEfgvxQmbqu/4WvXyN01tEjLhZMST7fs7e
         glqBFaqAO1G0ntD7JPkOsigfxKZkok6zOskcz5VLo03WCfr5g5bfXRpNK0no3ii6vNWe
         yG8t8hGScl5IgpZV9v/yLNmWB0uTLVjeaO5pxDDSaev5L9D2rLQOISqcS7t776iTSfbI
         PjL20M81zm9t4wei7Xz4OaqDMWA3rCFcnSMR+fR/FEUYU2lS6jvmCkoNycoql2/qStJL
         aVwSkzRTuct+Em0aJxsoGEyuaqm1lvjaVKG7nhvPLGlCuWaJe7ca01hSVPoC3RsPi8V5
         wJGA==
X-Gm-Message-State: AAQBX9dg3yoAnfMQ6HnAoEYwokCbO3YNgHR+eBaDxnTio7FqlWus5nh8
        +d0wModFwcci22a7t53HE5SjCj2kfuBS9vHRXuKG/b7KRCDTSe1RiEF5djSBcNeUw8Lm5O7YDnq
        3aFv1hVkILcXstFTD
X-Received: by 2002:a05:6214:411b:b0:5ef:41bf:d567 with SMTP id kc27-20020a056214411b00b005ef41bfd567mr20824274qvb.43.1682343633606;
        Mon, 24 Apr 2023 06:40:33 -0700 (PDT)
X-Google-Smtp-Source: AKy350YtgNDotzzCOd443mQYO9c5msFuvp6PLZgsNhOVAVwbUEJ9ISFLesnZE6Db6c6+OAEha1fJsQ==
X-Received: by 2002:a05:6214:411b:b0:5ef:41bf:d567 with SMTP id kc27-20020a056214411b00b005ef41bfd567mr20824244qvb.43.1682343633314;
        Mon, 24 Apr 2023 06:40:33 -0700 (PDT)
Received: from localhost (77-32-99-124.dyn.eolo.it. [77.32.99.124])
        by smtp.gmail.com with ESMTPSA id p3-20020a0ccb83000000b0060270619bfesm2809730qvk.24.2023.04.24.06.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 06:40:32 -0700 (PDT)
Date:   Mon, 24 Apr 2023 15:41:00 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hawk@kernel.org,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH v2 net-next 1/2] net: veth: add page_pool for page
 recycling
Message-ID: <ZEaG7Dad0FV9SVXJ@localhost.localdomain>
References: <cover.1682188837.git.lorenzo@kernel.org>
 <6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org>
 <4f008243-49d0-77aa-0e7f-d20be3a68f3c@huawei.com>
 <ZEU+vospFdm08IeE@localhost.localdomain>
 <3c78f045-aa8e-22a5-4b38-ab271122a79e@huawei.com>
 <ZEZJHCRsBVQwd9ie@localhost.localdomain>
 <0c1790dc-dbeb-8664-64ca-1f71e6c4f3a9@huawei.com>
 <ZEZ/xXcOv9Co5Vif@boxer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HHebbjvWlzqbQ2y5"
Content-Disposition: inline
In-Reply-To: <ZEZ/xXcOv9Co5Vif@boxer>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HHebbjvWlzqbQ2y5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Apr 24, 2023 at 07:58:07PM +0800, Yunsheng Lin wrote:
> > On 2023/4/24 17:17, Lorenzo Bianconi wrote:
> > >> On 2023/4/23 22:20, Lorenzo Bianconi wrote:
> > >>>> On 2023/4/23 2:54, Lorenzo Bianconi wrote:
> > >>>>>  struct veth_priv {
> > >>>>> @@ -727,17 +729,20 @@ static int veth_convert_skb_to_xdp_buff(str=
uct veth_rq *rq,
> > >>>>>  			goto drop;
> > >>>>> =20
> > >>>>>  		/* Allocate skb head */
> > >>>>> -		page =3D alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> > >>>>> +		page =3D page_pool_dev_alloc_pages(rq->page_pool);
> > >>>>>  		if (!page)
> > >>>>>  			goto drop;
> > >>>>> =20
> > >>>>>  		nskb =3D build_skb(page_address(page), PAGE_SIZE);
> > >>>>
> > >>>> If page pool is used with PP_FLAG_PAGE_FRAG, maybe there is some a=
dditional
> > >>>> improvement for the MTU 1500B case, it seem a 4K page is able to h=
old two skb.
> > >>>> And we can reduce the memory usage too, which is a significant sav=
ing if page
> > >>>> size is 64K.
> > >>>
> > >>> please correct if I am wrong but I think the 1500B MTU case does no=
t fit in the
> > >>> half-page buffer size since we need to take into account VETH_XDP_H=
EADROOM.
> > >>> In particular:
> > >>>
> > >>> - VETH_BUF_SIZE =3D 2048
> > >>> - VETH_XDP_HEADROOM =3D 256 + 2 =3D 258
> > >>
> > >> On some arch the NET_IP_ALIGN is zero.
> > >>
> > >> I suppose XDP_PACKET_HEADROOM are for xdp_frame and data_meta, it se=
ems
> > >> xdp_frame is only 40 bytes for 64 bit arch and max size of metalen i=
s 32
> > >> as xdp_metalen_invalid() suggest, is there any other reason why we n=
eed
> > >> 256 bytes here?
> > >=20
> > > XDP_PACKET_HEADROOM must be greater than (40 + 32)B because you may w=
ant push
> > > new data at the beginning of the xdp_buffer/xdp_frame running
> > > bpf_xdp_adjust_head() helper.
> > > I think 256B has been selected for XDP_PACKET_HEADROOM since it is 4 =
cachelines
> > > (but I can be wrong).
> > > There was a discussion in the past to reduce XDP_PACKET_HEADROOM to 1=
92B but
> > > this is not merged yet and it is not related to this series. We can a=
ddress
> > > your comments in a follow-up patch when XDP_PACKET_HEADROOM series is=
 merged.
>=20
> Intel drivers still work just fine at 192 headroom and split the page but
> it makes it problematic for BIG TCP where MAX_SKB_FRAGS from shinfo needs
> to be increased. So it's the tailroom that becomes the bottleneck, not the
> headroom. I believe at some point we will convert our drivers to page_pool
> with full 4k page dedicated for a single frame.
>=20
> >=20
> > It worth mentioning that the performance gain in this patch is at the c=
ost of
> > more memory usage, at most of VETH_RING_SIZE(256) + PP_ALLOC_CACHE_SIZE=
(128)
> > pages is used.
> >=20
> > IMHO, it seems better to limit the memory usage as much as possible, or=
 provide a
> > way to disable/enable page pool for user.
>=20
> I think that this argument is valuable due to the purpose that veth can
> serve, IMHO it wouldn't be an argument for a standard PF driver. It would
> be interesting to see how veth would work with PP_FLAG_PAGE_FRAG.

actually I already have a PoC for using page_pool with PP_FLAG_PAGE_FRAG
flag in veth driver but if we do not reduce XDP_PACKET_HEADROOM size there
will not be any difference in the memory footprint since we will need two
fragments (so a full-page) for a 1500B frame. Moreover, we will have lower
performance since we will need to spread the data on two skb buffers
(linear area and frag0 in this case).

Regards,
Lorenzo

>=20

--HHebbjvWlzqbQ2y5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZEaG6gAKCRA6cBh0uS2t
rMZoAP9BQYbVLWuKe1Qfw4fp/jVBp2fiV3XHyioCHSxcIagNugD+JokxIUkrA/QL
qTFNNF1+63Av28u/VjWQEoiNX4C70Qg=
=8vPz
-----END PGP SIGNATURE-----

--HHebbjvWlzqbQ2y5--

