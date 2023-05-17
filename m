Return-Path: <netdev+bounces-3370-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3FE706AE4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15F4B281728
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA5231124;
	Wed, 17 May 2023 14:18:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F92823D59
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:18:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF6B18C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684333084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ioWVxI0IhvogYDfX7ey3FCLR56UxerMQXuLkBllxahs=;
	b=flMPTNHkVD1FgpXKFtc1ggLMBEi5AjDxWLhRnZZSxZwPYp3y60C9a9MOw0qIw4lmmAFj28
	x7rJUfjT1LyQiETVlAmRAmIpu5AZ97hZ6YMmXFGeP92mcFWgmXzA0dYWWjkBmeOsuDVoik
	t8MNbTdo6H2jZ41TFnv8AaooPiRWK9Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-214-Q36tC12BMtWcT_p0sC7S7Q-1; Wed, 17 May 2023 10:18:03 -0400
X-MC-Unique: Q36tC12BMtWcT_p0sC7S7Q-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f420742d40so3431145e9.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:18:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684333082; x=1686925082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ioWVxI0IhvogYDfX7ey3FCLR56UxerMQXuLkBllxahs=;
        b=dLi+HBucQNblDBWV11oEU/xjrJdbdQJIDGbJBpmAV966MMlCUrTh1TILHW1ltsO1W8
         cdmpqDQwaxwIBzaDV8dHl4a748HFE7T39H2IombQUnS43MlZDVU2nunSjG/DCblYUHB6
         JUOmoZHzmdrgFnxdpdOfsMFvQ0OXj2RowFp2sGM5UGoilwf0jwYb5cmolahhAjeQyE/+
         wOhOJQZv1Tky92zQnZvYN6CpGNmdv8qCq9ooSmWAXU4piWLOVyT950QNU3ehKioBy4Ys
         /g7uLkFFg305rEe3F9VfgRYKmx0NZOLGskK6ADA4Pvh2VH2PP1VAbvTB/Xc2BVHEw+O2
         Gu/A==
X-Gm-Message-State: AC+VfDzf8j4qXXJUFguWDIL9rQ25KOHIwfYaLt+KHc8lhM0e8W6E06Cs
	xRcmIzBsduwGxhWN0bum1MZwo1yOnI947VQzCYxQ6yQFnWSWiatclXAA6BAqRHQMK2y+/VW3ixU
	pS8HuiiQGBhFoxYmS
X-Received: by 2002:a1c:6a0d:0:b0:3f4:23d4:e48 with SMTP id f13-20020a1c6a0d000000b003f423d40e48mr24238463wmc.23.1684333081618;
        Wed, 17 May 2023 07:18:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ75qo8BdcqXdxo15sDlxFUJpgmybshio61afdZvp0npjows/dgUMrhfRqB4N5ATx0DaUrybCA==
X-Received: by 2002:a1c:6a0d:0:b0:3f4:23d4:e48 with SMTP id f13-20020a1c6a0d000000b003f423d40e48mr24238448wmc.23.1684333081207;
        Wed, 17 May 2023 07:18:01 -0700 (PDT)
Received: from localhost (net-130-25-106-149.cust.vodafonedsl.it. [130.25.106.149])
        by smtp.gmail.com with ESMTPSA id 13-20020a05600c024d00b003f42813b315sm2359342wmj.32.2023.05.17.07.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 07:18:00 -0700 (PDT)
Date: Wed, 17 May 2023 16:17:59 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
	john.fastabend@gmail.com
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint
 using half page per-buffer
Message-ID: <ZGTiF+B46FA3TOj6@lore-desk>
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
 <62654fa5-d3a2-4b81-af70-59c9e90db842@huawei.com>
 <ZGIWZHNRvq5DSmeA@lore-desk>
 <ZGIvbfPd46EIVZf/@boxer>
 <ZGQJKRfuf4+av/MD@lore-desk>
 <d6348bf0-0da8-c0ae-ce78-7f4620837f66@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="izBUiPk0NpMgOihH"
Content-Disposition: inline
In-Reply-To: <d6348bf0-0da8-c0ae-ce78-7f4620837f66@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--izBUiPk0NpMgOihH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2023/5/17 6:52, Lorenzo Bianconi wrote:
> >> On Mon, May 15, 2023 at 01:24:20PM +0200, Lorenzo Bianconi wrote:
> >>>> On 2023/5/12 21:08, Lorenzo Bianconi wrote:
> >>>>> In order to reduce page_pool memory footprint, rely on
> >>>>> page_pool_dev_alloc_frag routine and reduce buffer size
> >>>>> (VETH_PAGE_POOL_FRAG_SIZE) to PAGE_SIZE / 2 in order to consume one=
 page
> >>>>
> >>>> Is there any performance improvement beside the memory saving? As it
> >>>> should reduce TLB miss, I wonder if the TLB miss reducing can even
> >>>> out the cost of the extra frag reference count handling for the
> >>>> frag support?
> >>>
> >>> reducing the requested headroom to 192 (from 256) we have a nice impr=
ovement in
> >>> the 1500B frame case while it is mostly the same in the case of paged=
 skb
> >>> (e.g. MTU 8000B).
> >>
> >> Can you define 'nice improvement' ? ;)
> >> Show us numbers or improvement in %.
> >=20
> > I am testing this RFC patch in the scenario reported below:
> >=20
> > iperf tcp tx --> veth0 --> veth1 (xdp_pass) --> iperf tcp rx
> >=20
> > - 6.4.0-rc1 net-next:
> >   MTU 1500B: ~ 7.07 Gbps
> >   MTU 8000B: ~ 14.7 Gbps
> >=20
> > - 6.4.0-rc1 net-next + page_pool frag support in veth:
> >   MTU 1500B: ~ 8.57 Gbps
> >   MTU 8000B: ~ 14.5 Gbps
> >=20
>=20
> Thanks for sharing the data.
> Maybe using the new frag interface introduced in [1] bring
> back the performance for the MTU 8000B case.
>=20
> 1. https://patchwork.kernel.org/project/netdevbpf/cover/20230516124801.24=
65-1-linyunsheng@huawei.com/
>=20
>=20
> I drafted a patch for veth to use the new frag interface, maybe that
> will show how veth can make use of it. Would you give it a try to see
> if there is any performance improvment for MTU 8000B case? Thanks.
>=20
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -737,8 +737,8 @@ static int veth_convert_skb_to_xdp_buff(struct veth_r=
q *rq,
>             skb_shinfo(skb)->nr_frags ||
>             skb_headroom(skb) < XDP_PACKET_HEADROOM) {
>                 u32 size, len, max_head_size, off;
> +               struct page_pool_frag *pp_frag;
>                 struct sk_buff *nskb;
> -               struct page *page;
>                 int i, head_off;
>=20
>                 /* We need a private copy of the skb and data buffers sin=
ce
> @@ -752,14 +752,20 @@ static int veth_convert_skb_to_xdp_buff(struct veth=
_rq *rq,
>                 if (skb->len > PAGE_SIZE * MAX_SKB_FRAGS + max_head_size)
>                         goto drop;
>=20
> +               size =3D min_t(u32, skb->len, max_head_size);
> +               size +=3D VETH_XDP_HEADROOM;
> +               size +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +
>                 /* Allocate skb head */
> -               page =3D page_pool_dev_alloc_pages(rq->page_pool);
> -               if (!page)
> +               pp_frag =3D page_pool_dev_alloc_frag(rq->page_pool, size);
> +               if (!pp_frag)
>                         goto drop;
>=20
> -               nskb =3D napi_build_skb(page_address(page), PAGE_SIZE);
> +               nskb =3D napi_build_skb(page_address(pp_frag->page) + pp_=
frag->offset,
> +                                     pp_frag->truesize);
>                 if (!nskb) {
> -                       page_pool_put_full_page(rq->page_pool, page, true=
);
> +                       page_pool_put_full_page(rq->page_pool, pp_frag->p=
age,
> +                                               true);
>                         goto drop;
>                 }
>=20
> @@ -782,16 +788,18 @@ static int veth_convert_skb_to_xdp_buff(struct veth=
_rq *rq,
>                 len =3D skb->len - off;
>=20
>                 for (i =3D 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
> -                       page =3D page_pool_dev_alloc_pages(rq->page_pool);
> -                       if (!page) {
> +                       size =3D min_t(u32, len, PAGE_SIZE);
> +
> +                       pp_frag =3D page_pool_dev_alloc_frag(rq->page_poo=
l, size);
> +                       if (!pp_frag) {
>                                 consume_skb(nskb);
>                                 goto drop;
>                         }
>=20
> -                       size =3D min_t(u32, len, PAGE_SIZE);
> -                       skb_add_rx_frag(nskb, i, page, 0, size, PAGE_SIZE=
);
> -                       if (skb_copy_bits(skb, off, page_address(page),
> -                                         size)) {
> +                       skb_add_rx_frag(nskb, i, pp_frag->page, pp_frag->=
offset,
> +                                       size, pp_frag->truesize);
> +                       if (skb_copy_bits(skb, off, page_address(pp_frag-=
>page) +
> +                                         pp_frag->offset, size)) {
>                                 consume_skb(nskb);
>                                 goto drop;
>                         }
> @@ -1047,6 +1055,8 @@ static int veth_create_page_pool(struct veth_rq *rq)
>                 return err;
>         }

IIUC the code here we are using a variable length for linear part (at most =
one page)
while we will always use a full page (exept for the last fragment) for the =
paged
area, correct? I have not tested it yet but I do not think we will get a si=
gnificant
improvement since if we set MTU to 8000B in my tests we get mostly the same=
 throughput
(14.5 Gbps vs 14.7 Gbps) if we use page_pool fragment or page_pool full pag=
e.
Am I missing something?
What we are discussing with Jesper is try to allocate a order 3 page from t=
he pool and
rely page_pool fragment, similar to page_frag_cache is doing. I will look i=
nto it if
there are no strong 'red flags'.

Regards,
Lorenzo

>=20
> +       page_pool_set_max_frag_size(rq->page_pool, PAGE_SIZE / 2);
> +
>         return 0;
>  }
>=20

--izBUiPk0NpMgOihH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZGTiFgAKCRA6cBh0uS2t
rIYXAQDC1p5J2e/oUAWCH/jUJ7eWYR4MYfi1yoeuVh2Ez13k/QEAl19w3AO1FWmQ
fAhzwXqmg4cV/roSBYKY+62rlK78DQs=
=t0oa
-----END PGP SIGNATURE-----

--izBUiPk0NpMgOihH--


