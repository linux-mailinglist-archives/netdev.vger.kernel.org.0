Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12ACA59E5B0
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243856AbiHWPFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237712AbiHWPE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:04:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071A231E6EB
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661257704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tML+QnnHXQz/iYyoD3FaZkxBdgewrRT6f7NKH6MO5KM=;
        b=PzYREJFC0DPjPFD6Fheg3OW7Q3D8bVtbeIPx+0J6/zWbyZfagsHwwViRltB5Oj09YpQ1qN
        JXwR80BvlSeuu8TbSZL6zl7PXFYigJakAPoAyRa2JCe8/sH9hXb+ho8mKB7nBffx0M/su+
        WnyX3d7uMvNlLT/oCOsjr5P9LG00TNg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-2BzG_zhBPlyym-YCzL5JCg-1; Tue, 23 Aug 2022 08:28:21 -0400
X-MC-Unique: 2BzG_zhBPlyym-YCzL5JCg-1
Received: by mail-ej1-f70.google.com with SMTP id he38-20020a1709073da600b0073d98728570so1030532ejc.11
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tML+QnnHXQz/iYyoD3FaZkxBdgewrRT6f7NKH6MO5KM=;
        b=wuroNxHlSjHvVz6QIwtp9fjS6tmNNZRMBxEh5O3XDbI3j81wGdeD7KYOdDly3pGS4Z
         7rmV4LWfToABsF7xcItoFG7+MBEs/FPjxfb3EyHHYRVqrVwjB+SbT+XnNG3ZKWg0Ysqz
         wsqhoUZoEZTuHxfMj+yBcepnRYgdqBxL31O1oUiKBdPPhSljhkGP8hBio+s1a4JEITkz
         60XdaR4MgvDufml+5D9FOHr2Jh05G5R4IRctw8zQww/ADOuj0hSs/zpc/BzJC7DkoOm4
         I2YiAJZUdQ4tfxQlzTIdQC33y5eRvUeIIgMtzXJvr0rC3/jIsuGbjfO3Vx4XcWUHfbEc
         355g==
X-Gm-Message-State: ACgBeo3QjblLje1wpsfcnBdBxqqsIxvcAV4e3mFmD8RrgfDk/J1BxZ/9
        qWgT4DkZILevrB1hrVZQ/TGlrF/qsBw1nO2AXOzA4XjXOrXz7YP7qS7tO8k1Uu0qr1sLyCCvuvN
        XnjzNdDD8w4aZnCCT
X-Received: by 2002:a17:907:a057:b0:730:a2d8:d5ac with SMTP id gz23-20020a170907a05700b00730a2d8d5acmr16319281ejc.764.1661257699995;
        Tue, 23 Aug 2022 05:28:19 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4ubL1ewD3cThVJ/9ahwHJLtl3B6LgL02Z2rP69QdUogtpxwjhFQyCiHgNQYaocEstWUevLRA==
X-Received: by 2002:a17:907:a057:b0:730:a2d8:d5ac with SMTP id gz23-20020a170907a05700b00730a2d8d5acmr16319264ejc.764.1661257699727;
        Tue, 23 Aug 2022 05:28:19 -0700 (PDT)
Received: from localhost (net-93-71-3-16.cust.vodafonedsl.it. [93.71.3.16])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906201200b0073a20469f31sm7386247ejo.41.2022.08.23.05.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 05:28:19 -0700 (PDT)
Date:   Tue, 23 Aug 2022 14:28:17 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, john.fastabend@gmail.com
Subject: Re: [PATCH v2 bpf-next] xdp: report rx queue index in xdp_frame
Message-ID: <YwTH4c/Mk82LIWNM@lore-desk>
References: <3923222d836b104232ee70eef34ce2aa454ef9db.1660721856.git.lorenzo@kernel.org>
 <1a22e7e9-e6ef-028f-dffa-e954207dc24d@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oXTbf8T5vS6lKkZ/"
Content-Disposition: inline
In-Reply-To: <1a22e7e9-e6ef-028f-dffa-e954207dc24d@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--oXTbf8T5vS6lKkZ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> On 17/08/2022 09.40, Lorenzo Bianconi wrote:
> > Report rx queue index in xdp_frame according to the xdp_buff xdp_rxq_in=
fo
> > pointer. xdp_frame queue_index is currently used in cpumap code to conv=
ert
> > the xdp_frame into a xdp_buff and allow the ebpf program attached to the
> > map entry to differentiate traffic according to the receiving hw queue.
> > xdp_frame size is not increased adding queue_index since an alignment
> > padding in the structure is used to insert queue_index field.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> (Sorry, I replied to v1 and not this v2.)
>=20
> I'm still unsure about this change, because the XDP-hints will also
> contain the rx_queue number.  And placing it in XDP-hints automatically
> makes it avail for AF_XDP consumers.
>=20
> I do think it is relevant for the BPF-prog to get access to the rx_queue
> index, because it can be used for scaling the workload.

ack, I agree. Then we can implement it with xdp hw-hints.

Regards,
Lorenzo

>=20
>=20
> > ---
> > Changes since v1:
> > - rebase on top of bpf-next
> > ---
> >   include/net/xdp.h   | 2 ++
> >   kernel/bpf/cpumap.c | 2 +-
> >   2 files changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 04c852c7a77f..3567866b0af5 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -172,6 +172,7 @@ struct xdp_frame {
> >   	struct xdp_mem_info mem;
> >   	struct net_device *dev_rx; /* used by cpumap */
> >   	u32 flags; /* supported values defined in xdp_buff_flags */
> > +	u32 queue_index;
> >   };
> >   static __always_inline bool xdp_frame_has_frags(struct xdp_frame *fra=
me)
> > @@ -301,6 +302,7 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct =
xdp_buff *xdp)
> >   	/* rxq only valid until napi_schedule ends, convert to xdp_mem_info =
*/
> >   	xdp_frame->mem =3D xdp->rxq->mem;
> > +	xdp_frame->queue_index =3D xdp->rxq->queue_index;
> >   	return xdp_frame;
> >   }
> > diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> > index b5ba34ddd4b6..48003450c98c 100644
> > --- a/kernel/bpf/cpumap.c
> > +++ b/kernel/bpf/cpumap.c
> > @@ -228,7 +228,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_=
map_entry *rcpu,
> >   		rxq.dev =3D xdpf->dev_rx;
> >   		rxq.mem =3D xdpf->mem;
> > -		/* TODO: report queue_index to xdp_rxq_info */
> > +		rxq.queue_index =3D xdpf->queue_index;
> >   		xdp_convert_frame_to_buff(xdpf, &xdp);
>=20

--oXTbf8T5vS6lKkZ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYwTH4QAKCRA6cBh0uS2t
rOEXAP9q4720t4CmWUFUafKol802Af7ZiSpyq+OX6ArG4vIS1AEAtlq+Y9hu+1+l
wwcusrNPSDuANA97lWGcFR9O8ZSPrwI=
=VdRN
-----END PGP SIGNATURE-----

--oXTbf8T5vS6lKkZ/--

