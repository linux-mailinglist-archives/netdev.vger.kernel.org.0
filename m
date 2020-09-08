Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14FC2621F6
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 23:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgIHVbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 17:31:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23206 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726369AbgIHVbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 17:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599600692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O++UrgWAYwMrjy+jnzJqXxokoc/n6C/TkhYPRy4RjBU=;
        b=CQVq1DRtqynXLnL77B8jwH2Z0aV8F4aCO7olJE8PCxdbXFSRG3gAiuEvSJDP+Wj8Gje+39
        MP/sCvRf9bNQdsqPkX5j7V0zKjuuSwyWz3rJtcB8dydX6CUn5+fUBUoZ4H+lhEoFS3Vo5T
        10/f4krBBLvvlJObOAwi8+6Il1NCjKA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-Tfot9ynCPJa92C86gFQblg-1; Tue, 08 Sep 2020 17:31:25 -0400
X-MC-Unique: Tfot9ynCPJa92C86gFQblg-1
Received: by mail-wr1-f70.google.com with SMTP id s8so104644wrb.15
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 14:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O++UrgWAYwMrjy+jnzJqXxokoc/n6C/TkhYPRy4RjBU=;
        b=IZzGHFKVcRXiprsKpUo5MghQzuQ4NXxVMyUFqs81uq+WMeof819XoxpyJx9OeK9EVE
         zP+WBAHm+bPoVo0NwYjl6rUoETuTZ3zSK0tIbzqmce+B/CXJWEkYjVGnnB8HVhedLxwa
         gTir0N91yQ+K8/2xpuErelgeU2kzh2R2QDm4kq1jPT8xbGDCpBynMrllEMzsjMonlXJz
         fRkGS6ZwFtsPNnIK/ULK0ntw1PXshawx3SN+rnSb8JD9pW25F1NWaYXxk8qGfPGH25bq
         roacVIKIL5uLptAig6rdPjtPoL1SMtfMOTUGLRMOp/V7S1Ypd7PCcFJV+IiX/h30xUg0
         9M7A==
X-Gm-Message-State: AOAM5331bwTLbbjjxxmYEsnzYsufCBYJFHpYh28vIcVCy0Z96STDy9ct
        Dd9IhYNYi6mgF4TeDC4Pun7AR9vDtxBCEIPrk2bypYDTATRKe7xeHgKP97/njSrJED9hMCx9kKh
        I1SiQ4gXMJdH7jDnw
X-Received: by 2002:adf:e7ce:: with SMTP id e14mr428574wrn.43.1599600684445;
        Tue, 08 Sep 2020 14:31:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxHhsY0Bxpsc5jg821SY3XDofH3qHiqxwIeFbR1sA4l4DHEmshDaf8c4o5w0ipmVL2YwJ4yQ==
X-Received: by 2002:adf:e7ce:: with SMTP id e14mr428561wrn.43.1599600684128;
        Tue, 08 Sep 2020 14:31:24 -0700 (PDT)
Received: from localhost ([151.66.86.87])
        by smtp.gmail.com with ESMTPSA id k84sm852403wmf.6.2020.09.08.14.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 14:31:23 -0700 (PDT)
Date:   Tue, 8 Sep 2020 23:31:20 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        edumazet@google.com
Subject: Re: [PATCH v2 net-next 6/9] bpf: helpers: add
 bpf_xdp_adjust_mb_header helper
Message-ID: <20200908213120.GA27040@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
 <5f51e2f2eb22_3eceb20837@john-XPS-13-9370.notmuch>
 <20200904094511.GF2884@lore-desk>
 <5f525be3da548_1932208b6@john-XPS-13-9370.notmuch>
 <20200906133617.GC2785@lore-desk>
 <5f57e23e513b2_10343208e0@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <5f57e23e513b2_10343208e0@john-XPS-13-9370.notmuch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > > Lorenzo Bianconi wrote:
> > > > > Lorenzo Bianconi wrote:
> >=20
> > [...]
> >=20
> > > > > > + *	Description
> > > > > > + *		Adjust frame headers moving *offset* bytes from/to the sec=
ond
> > > > > > + *		buffer to/from the first one. This helper can be used to m=
ove
> > > > > > + *		headers when the hw DMA SG does not copy all the headers in
> > > > > > + *		the first fragment.
> > > >=20
> > > > + Eric to the discussion
> > > >=20
>=20
> [...]
>=20
> > > > > > +BPF_CALL_2(bpf_xdp_adjust_mb_header, struct  xdp_buff *, xdp,
> > > > > > +	   int, offset)
> > > > > > +{
> > > > > > +	void *data_hard_end, *data_end;
> > > > > > +	struct skb_shared_info *sinfo;
> > > > > > +	int frag_offset, frag_len;
> > > > > > +	u8 *addr;
> > > > > > +
> > > > > > +	if (!xdp->mb)
> > > > > > +		return -EOPNOTSUPP;
> > >=20
> > > Not required for this patch necessarily but I think it would be bette=
r user
> > > experience if instead of EOPNOTSUPP here we did the header split. This
> > > would allocate a frag and copy the bytes around as needed. Yes it mig=
ht
> > > be slow if you don't have a frag free in the driver, but if user want=
s to
> > > do header split and their hardware can't do it we would have a way ou=
t.
> > >=20
> > > I guess it could be an improvement for later though.
> >=20
> > I have no a strong opinion on this, I did it in this way to respect the=
 rule "we
> > do not allocate memory for XDP".
> >=20
> > @Jesper, David: thoughts?
>=20
> Consider adding a flags field to the helper so we could do this later with
> a flag. Then users who want the alloc can set the flag and get it.
>=20
> [...]
>=20
> >=20
> > >=20
> > > How/when does the header split go wrong on the mvneta device? I guess
> > > this is to fix a real bug/issue not some theoritical one? An example
> > > in the commit message would make this concrete. Soemthing like,
> > > "When using RX zerocopy to mmap data into userspace application if
> > > a packet with [all these wild headers] is received rx zerocopy breaks
> > > because header split puts headers X in the data frag confusing apps".
> >=20
> > This issue does not occur with mvneta since the driver is not capable of
> > performing header split AFAIK. The helper has been introduced to cover =
the
> > "issue" reported by Eric in his NetDevConf presentation. In order to te=
st the
> > helper I modified the mventa rx napi loop in a controlled way (this pat=
ch can't
> > be sent upstream, it is for testing only :))
> > I will improve commit message in v3.
>=20
> Ah ok so really there is no users for the helper then IMO just drop
> the patch until we have a user then.

I agree, this helper is not strictly related to the series. I added it in v2
to provide another example of using xdp_buff mb bit.

>=20
> >=20
> > >=20
> > > >=20
> > > > >=20
> > > > > Also and even more concerning I think this API requires the
> > > > > driver to populate shinfo. If we use TX_REDIRECT a lot or TX_XMIT
> > > > > this means we need to populate shinfo when its probably not ever
> > > > > used. If our driver is smart L2/L3 headers are in the readable
> > > > > data and prefetched. Writing frags into the end of a page is like=
ly
> > > > > not free.
> > > >=20
> > > > Sorry I did not get what you mean with "populate shinfo" here. We n=
eed to
> > > > properly set shared_info in order to create the xdp multi-buff.
> > > > Apart of header splits, please consider the main uses-cases for
> > > > xdp multi-buff are XDP with TSO and Jumbo frames.
> > >=20
> > > The use case I have in mind is a XDP_TX or XDP_REDIRECT load balancer.
> > > I wont know this at the driver level and now I'll have to write into
> > > the back of every page with this shinfo just in case. If header
> > > split is working I should never need to even touch the page outside
> > > the first N bytes that were DMAd and in cache with DDIO. So its extra
> > > overhead for something that is unlikely to happen in the LB case.
> >=20
> > So far the skb_shared_info in constructed in mvneta only if the hw spli=
ts
> > the received data in multiple buffers (so if the MTU is greater than 1 =
PAGE,
> > please see comments below). Moreover the shared_info is present only in=
 the
> > first buffer.
>=20
> Still in a normal L2/L3/L4 use case I expect all the headers you
> need to be in the fist buffer so its unlikely for use cases that
> send most traffic via XDP_TX for example to ever need the extra
> info. In these cases I think you are paying some penalty for
> having to do the work of populating the shinfo. Maybe its measurable
> maybe not I'm not sure.
>=20
> Also if we make it required for multi-buffer than we also need
> the shinfo on 40gbps or 100gbps nics and now even small costs
> matter.

Now I realized I used the word "split" in a not clear way here,
I apologize for that.
What I mean is not related "header" split, I am referring to the case where
the hw is configured with a given rx buffer size (e.g. 1 PAGE) and we have
set a higher MTU/max received size (e.g. 9K).
In this case the hw will "split" the jumbo received frame over multiple rx
buffers/descriptors. Populating the "xdp_shared_info" we will forward this
layout info to the eBPF sandbox and to a remote driver/cpu.
Please note this use case is not currently covered by XDP so if we develop =
it a
proper way I guess we should not get any performance hit for the legacy sin=
gle-buffer
mode since we will not populate the shared_info for it (I think you refer to
the "legacy" use-case in your "normal L2/L3/L4" example, right?)
Anyway I will run some tests to verify the performances for the single buff=
er
use-case are not hit.

Regards,
Lorenzo

>=20
> >=20
> > >=20
> > > If you take the simplest possible program that just returns XDP_TX
> > > and run a pkt generator against it. I believe (haven't run any
> > > tests) that you will see overhead now just from populating this
> > > shinfo. I think it needs to only be done when its needed e.g. when
> > > user makes this helper call or we need to build the skb and populate
> > > the frags there.
> >=20
> > sure, I will carry out some tests.
>=20
> Thanks!
>=20
> >=20
> > >=20
> > > I think a smart driver will just keep the frags list in whatever
> > > form it has them (rx descriptors?) and push them over to the
> > > tx descriptors without having to do extra work with frag lists.
> >=20
> > I think there are many use-cases where we want to have this info availa=
ble in
> > xdp_buff/xdp_frame. E.g: let's consider the following Jumbo frame examp=
le:
> > - MTU > 1 PAGE (so we the driver will split the received data in multip=
le rx
> >   descriptors)
> > - the driver performs a XDP_REDIRECT to a veth or cpumap
> >=20
> > Relying on the proposed architecture we could enable GRO in veth or cpu=
map I
> > guess since we can build a non-linear skb from the xdp multi-buff, righ=
t?
>=20
> I'm not disputing there are use-cases. But, I'm trying to see if we
> can cover those without introducing additional latency in other
> cases. Hence the extra benchmarks request ;)
>=20
> >=20
> > >=20
> > > >=20
> > > > >=20
> > > > > Did you benchmark this?
> > > >=20
> > > > will do, I need to understand if we can use tiny buffers in mvneta.
> > >=20
> > > Why tiny buffers? How does mvneta layout the frags when doing
> > > header split? Can we just benchmark what mvneta is doing at the
> > > end of this patch series?
> >=20
> > for the moment mvneta can split the received data when the previous buf=
fer is
> > full (e.g. when we the first page is completely written). I want to exp=
lore if
> > I can set a tiny buffer (e.g. 128B) as max received buffer to run some =
performance
> > tests and have some "comparable" results respect to the ones I got when=
 I added XDP
> > support to mvneta.
>=20
> OK would be great.
>=20
> >=20
> > >=20
> > > Also can you try the basic XDP_TX case mentioned above.
> > > I don't want this to degrade existing use cases if at all
> > > possible.
> >=20
> > sure, will do.
>=20
> Thanks!
>=20

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX1f4JQAKCRA6cBh0uS2t
rLIVAP0YopFJvfbXGY9cXMcf+vsN2yz9MqndI8V7+ye/SOVyzwEArZl5QI+YGwMJ
zTwAnlCHEE2OhvBdnu7pZOmc2KSlOAw=
=/Qd7
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--

