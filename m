Return-Path: <netdev+bounces-2614-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9420D702B5F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5026D280FF8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6560EC137;
	Mon, 15 May 2023 11:24:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EFA79D0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:24:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2007E138
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 04:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684149866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fr77g79IuIpWR+7vF2JMQY/uJlwAychzVE28vpLATyA=;
	b=KHrGqen21jqglQ72Qh55/+24URMDXbUJ9JZM9TH3LA6aO10Ddj1fO4RlLYW5w8Sw1NUfmP
	dMNf1c68eoC9JA/BSHDkOGS/ZCNO4/oTfN3TTW/33XFNRi3AaM9wJVChJmGdkXskV941tP
	hFGJuXpRpfnxs1Qm1E+oyWK0GYJdwe8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-sm5SpeFxPDGNqI4rcUSDdg-1; Mon, 15 May 2023 07:24:24 -0400
X-MC-Unique: sm5SpeFxPDGNqI4rcUSDdg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30629b36d9bso4847486f8f.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 04:24:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684149863; x=1686741863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fr77g79IuIpWR+7vF2JMQY/uJlwAychzVE28vpLATyA=;
        b=ScRcjaEwW4arjPwFjF0LV2QpQd/APrtA1K7wvmk02PtANT9/l5NT6yGPk9C6Egn/Gh
         +K2VHzDWsnIURU8MvLFDNBTQDxTl/D/AUoNQ2mPWoWuw+18xMvU7wjOzmYJMudSMbm+j
         SntQUOq7pZ2vUEPlUMduvgnE4kx0TCd5YjwFfl+CEj2mvS86jl175zyBbB1i+RuDc437
         a0pWwB287bSs/5lVL9qSFXIgC6AUDYIYYAZCwi/gL2c+zYrjlofy/dE76rOhN2daCsme
         EgezAvC76PGlXFWcw+ZHtcW/hpN6oTUU/zj6TgF5oR/1xyjL7UcdXTiNlXYKuVtgwR3J
         qWLw==
X-Gm-Message-State: AC+VfDw4clY3129TW9a6/cZGCYifO8MOZAR7z7uh267fr4+UryPL2pMl
	+bJfOVthLraBr/vSuqdICnCdTz9XqlUvv0UrKLj+0seI0SQhgCVIZ06ztiq/anm4HUhLDieHkDC
	UugDctj3a0hLHrnZSxUMZObbf
X-Received: by 2002:adf:dbd2:0:b0:309:1c89:c618 with SMTP id e18-20020adfdbd2000000b003091c89c618mr2330002wrj.56.1684149863585;
        Mon, 15 May 2023 04:24:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7oZtQY++dxseRfxY6nRF336EzjPa1MVqrYHMQ9PlW0bOtJkbMVsvn58tqyvVAtkK18BSu/Lw==
X-Received: by 2002:adf:dbd2:0:b0:309:1c89:c618 with SMTP id e18-20020adfdbd2000000b003091c89c618mr2329981wrj.56.1684149863222;
        Mon, 15 May 2023 04:24:23 -0700 (PDT)
Received: from localhost (net-130-25-106-149.cust.vodafonedsl.it. [130.25.106.149])
        by smtp.gmail.com with ESMTPSA id o1-20020a5d6701000000b003063a1cdaf2sm32316243wru.48.2023.05.15.04.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 04:24:22 -0700 (PDT)
Date: Mon, 15 May 2023 13:24:20 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
	bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
	daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint
 using half page per-buffer
Message-ID: <ZGIWZHNRvq5DSmeA@lore-desk>
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
 <62654fa5-d3a2-4b81-af70-59c9e90db842@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XLm+aGnV+Xnm3C/6"
Content-Disposition: inline
In-Reply-To: <62654fa5-d3a2-4b81-af70-59c9e90db842@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--XLm+aGnV+Xnm3C/6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2023/5/12 21:08, Lorenzo Bianconi wrote:
> > In order to reduce page_pool memory footprint, rely on
> > page_pool_dev_alloc_frag routine and reduce buffer size
> > (VETH_PAGE_POOL_FRAG_SIZE) to PAGE_SIZE / 2 in order to consume one page
>=20
> Is there any performance improvement beside the memory saving? As it
> should reduce TLB miss, I wonder if the TLB miss reducing can even
> out the cost of the extra frag reference count handling for the
> frag support?

reducing the requested headroom to 192 (from 256) we have a nice improvemen=
t in
the 1500B frame case while it is mostly the same in the case of paged skb
(e.g. MTU 8000B).

>=20
> > for two 1500B frames. Reduce VETH_XDP_PACKET_HEADROOM to 192 from 256
> > (XDP_PACKET_HEADROOM) to fit max_head_size in VETH_PAGE_POOL_FRAG_SIZE.
> > Please note, using default values (CONFIG_MAX_SKB_FRAGS=3D17), maximum
> > supported MTU is now reduced to 36350B.
>=20
> Maybe we don't need to limit the frag size to VETH_PAGE_POOL_FRAG_SIZE,
> and use different frag size depending on the mtu or packet size?
>=20
> Perhaps the page_pool_dev_alloc_frag() can be improved to return non-frag
> page if the requested frag size is larger than a specified size too.
> I will try to implement it if the above idea makes sense.
>=20

since there are no significant differences between full page and fragmented=
 page
implementation if the MTU is over the page boundary, does it worth to do so?
(at least for the veth use-case).

Regards,
Lorenzo


--XLm+aGnV+Xnm3C/6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZGIWZAAKCRA6cBh0uS2t
rFFtAQDDgY5v0GS6eK3fKxJvrayj8hV0G6H4tsh/dSNmjQOzNwD/S2c2CyFW09SH
esT10TYSuKKL9g3UXPBkii0+oyQaxwQ=
=59Iz
-----END PGP SIGNATURE-----

--XLm+aGnV+Xnm3C/6--


