Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C832637D9
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 22:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgIIUv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 16:51:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36167 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726426AbgIIUvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 16:51:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599684709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7VaKgUYdoCYfXk1gvLwhUDgt15+ghTv7BWTFQdxogQ0=;
        b=WLfBaD6JaX1QyKhZPwYZ3/5jzlPh7Jw6kK3tF6AlB7uak+JAI22KQswl10z3P9rIICpwZy
        BN4Kn+QdikxhOxXCkFMEW9aLdpSC4+MWSMd8IisoIJ2ubEAWREnLj1apXY/PHFG2G3TCLW
        4gaXfNs9raqUBN9PQb8mbEmbapdVQco=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-UA5Ux31ZMsKPp-FJsCbpLg-1; Wed, 09 Sep 2020 16:51:47 -0400
X-MC-Unique: UA5Ux31ZMsKPp-FJsCbpLg-1
Received: by mail-wr1-f71.google.com with SMTP id 33so1387376wrk.12
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 13:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7VaKgUYdoCYfXk1gvLwhUDgt15+ghTv7BWTFQdxogQ0=;
        b=U2aEkFgeNn5n+r3H9geGBv5WUitcwIweiLGe+sNTurVezXk9Uwh2xfxFxTEqiPaqNK
         FFU8FDnCe9pHZqCoSGCiyPT4xuOQj+yZElZXiwjJpWByIB0YuDugtZgCBWkCUEEJ1qRW
         wGZUvvHzyLaqdPEGJq4Udadt+lOk355h+i1hiJgCr1g6lmYUDy1xuS4JyhafI1y2rMUH
         oj6JShKa0Q8sSSapXlHEPLyJ0MII5JdMB2cHu/l2PgpzUYYkmfTXpbuQvzMRFUWnd/r/
         u8cJ1FImhJ9+J0cTiPefK/Wb3JeVmH9BRJdgm95mXDITXK4ehjPc8Q7fH+tXCRsWOPiT
         9C/w==
X-Gm-Message-State: AOAM5335CzBZK2FOZWHmq6hvznvKeHPbmsKswnUgDU8VXSD/AwerY2zh
        fIgysz9BA3eiGFkHloLQLPVyv5qUkqxlQIfgB35DqsdA1B9oWhex4rse15422HTyU8c+7ElNP/0
        MphYXzng/mhb2qwhT
X-Received: by 2002:a1c:a444:: with SMTP id n65mr5164234wme.122.1599684706501;
        Wed, 09 Sep 2020 13:51:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTsshEUN4ySdeMCxYKlzNGfrdu5a03Ova6UB6adHF1KnVbcAHYyz4dJnCe2ROsJstwihTxFw==
X-Received: by 2002:a1c:a444:: with SMTP id n65mr5164211wme.122.1599684706173;
        Wed, 09 Sep 2020 13:51:46 -0700 (PDT)
Received: from localhost ([151.66.86.87])
        by smtp.gmail.com with ESMTPSA id r14sm5658072wrn.56.2020.09.09.13.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 13:51:45 -0700 (PDT)
Date:   Wed, 9 Sep 2020 22:51:41 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        edumazet@google.com
Subject: Re: [PATCH v2 net-next 6/9] bpf: helpers: add
 bpf_xdp_adjust_mb_header helper
Message-ID: <20200909205141.GA6369@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
 <5f51e2f2eb22_3eceb20837@john-XPS-13-9370.notmuch>
 <20200904094511.GF2884@lore-desk>
 <5f525be3da548_1932208b6@john-XPS-13-9370.notmuch>
 <20200906133617.GC2785@lore-desk>
 <5f57e23e513b2_10343208e0@john-XPS-13-9370.notmuch>
 <20200908213120.GA27040@lore-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20200908213120.GA27040@lore-desk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > Lorenzo Bianconi wrote:
> > > > Lorenzo Bianconi wrote:
> > > > > > Lorenzo Bianconi wrote:
> > >=20
> > > [...]
> > >=20
> > > > > > > + *	Description
> > > > > > > + *		Adjust frame headers moving *offset* bytes from/to the s=
econd
> > > > > > > + *		buffer to/from the first one. This helper can be used to=
 move
> > > > > > > + *		headers when the hw DMA SG does not copy all the headers=
 in
> > > > > > > + *		the first fragment.
> > > > >=20
> > > > > + Eric to the discussion
> > > > >=20
> >=20
> > [...]
> >=20

[...]

> >=20
> > Still in a normal L2/L3/L4 use case I expect all the headers you
> > need to be in the fist buffer so its unlikely for use cases that
> > send most traffic via XDP_TX for example to ever need the extra
> > info. In these cases I think you are paying some penalty for
> > having to do the work of populating the shinfo. Maybe its measurable
> > maybe not I'm not sure.
> >=20
> > Also if we make it required for multi-buffer than we also need
> > the shinfo on 40gbps or 100gbps nics and now even small costs
> > matter.
>=20
> Now I realized I used the word "split" in a not clear way here,
> I apologize for that.
> What I mean is not related "header" split, I am referring to the case whe=
re
> the hw is configured with a given rx buffer size (e.g. 1 PAGE) and we have
> set a higher MTU/max received size (e.g. 9K).
> In this case the hw will "split" the jumbo received frame over multiple rx
> buffers/descriptors. Populating the "xdp_shared_info" we will forward this
> layout info to the eBPF sandbox and to a remote driver/cpu.
> Please note this use case is not currently covered by XDP so if we develo=
p it a
> proper way I guess we should not get any performance hit for the legacy s=
ingle-buffer
> mode since we will not populate the shared_info for it (I think you refer=
 to
> the "legacy" use-case in your "normal L2/L3/L4" example, right?)
> Anyway I will run some tests to verify the performances for the single bu=
ffer
> use-case are not hit.
>=20
> Regards,
> Lorenzo

I carried out some performance measurements on my Espressobin to check if t=
he
XDP "single buffer" use-case has been hit introducing xdp multi-buff suppor=
t.
Each test has been carried out sending ~900Kpps (pkt length 64B). The rx
buffer size was set to 1 PAGE (default value).
The results are roughly the same:

commit: f2ca673d2cd5 "net: mvneta: fix use of state->speed"
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
- XDP-DROP: ~ 740 Kpps
- XDP-TX: ~ 286 Kpps
- XDP-PASS + tc drop: ~ 219.5 Kpps

xdp multi-buff:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
- XDP-DROP: ~ 739-740 Kpps
- XDP-TX: ~ 285 Kpps
- XDP-PASS + tc drop: ~ 223 Kpps

I will add these results to v3 cover letter.

Regards,
Lorenzo

>=20
> >=20
> > >=20
> > > >=20
> > > > If you take the simplest possible program that just returns XDP_TX
> > > > and run a pkt generator against it. I believe (haven't run any
> > > > tests) that you will see overhead now just from populating this
> > > > shinfo. I think it needs to only be done when its needed e.g. when
> > > > user makes this helper call or we need to build the skb and populate
> > > > the frags there.
> > >=20
> > > sure, I will carry out some tests.
> >=20
> > Thanks!
> >=20
> > >=20
> > > >=20
> > > > I think a smart driver will just keep the frags list in whatever
> > > > form it has them (rx descriptors?) and push them over to the
> > > > tx descriptors without having to do extra work with frag lists.
> > >=20
> > > I think there are many use-cases where we want to have this info avai=
lable in
> > > xdp_buff/xdp_frame. E.g: let's consider the following Jumbo frame exa=
mple:
> > > - MTU > 1 PAGE (so we the driver will split the received data in mult=
iple rx
> > >   descriptors)
> > > - the driver performs a XDP_REDIRECT to a veth or cpumap
> > >=20
> > > Relying on the proposed architecture we could enable GRO in veth or c=
pumap I
> > > guess since we can build a non-linear skb from the xdp multi-buff, ri=
ght?
> >=20
> > I'm not disputing there are use-cases. But, I'm trying to see if we
> > can cover those without introducing additional latency in other
> > cases. Hence the extra benchmarks request ;)
> >=20
> > >=20
> > > >=20
> > > > >=20
> > > > > >=20
> > > > > > Did you benchmark this?
> > > > >=20
> > > > > will do, I need to understand if we can use tiny buffers in mvnet=
a.
> > > >=20
> > > > Why tiny buffers? How does mvneta layout the frags when doing
> > > > header split? Can we just benchmark what mvneta is doing at the
> > > > end of this patch series?
> > >=20
> > > for the moment mvneta can split the received data when the previous b=
uffer is
> > > full (e.g. when we the first page is completely written). I want to e=
xplore if
> > > I can set a tiny buffer (e.g. 128B) as max received buffer to run som=
e performance
> > > tests and have some "comparable" results respect to the ones I got wh=
en I added XDP
> > > support to mvneta.
> >=20
> > OK would be great.
> >=20
> > >=20
> > > >=20
> > > > Also can you try the basic XDP_TX case mentioned above.
> > > > I don't want this to degrade existing use cases if at all
> > > > possible.
> > >=20
> > > sure, will do.
> >=20
> > Thanks!
> >=20



--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX1lAWwAKCRA6cBh0uS2t
rO1TAQCjzao5yMool1muTgooRW/xpARCm0LRjGPZblaEI96c1gD/Y4qpPX069sT3
aySbVadRlnSZ46wtd+KvVOZbUvFiVQs=
=zFfe
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--

