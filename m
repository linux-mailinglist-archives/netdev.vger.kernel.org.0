Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4B1284EF9
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgJFP2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:28:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725996AbgJFP2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 11:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601998133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/rdp1rxgsLSHWFsRmsO/gSgWUaSPdYRlDAynIxLveGo=;
        b=fIz7A15KO0C070dG+sCsrIJMvGerQ4PXww4hPk7i3V2MnBnSOQFDtAbmoO+x9Y59kJCdla
        /1LejrY0BvaOdpdnL7hOkyaOSZfbDkyd3qogVLjgXvg7zQuBe+iVuGJ6oHExKG9cfU3cqY
        jf68xVWh2SFK0QIuH4gmXJCqv87qMGU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-R_2YSyJ0ObKmWIylB6OVMg-1; Tue, 06 Oct 2020 11:28:50 -0400
X-MC-Unique: R_2YSyJ0ObKmWIylB6OVMg-1
Received: by mail-wr1-f69.google.com with SMTP id b2so5450095wrs.7
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 08:28:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/rdp1rxgsLSHWFsRmsO/gSgWUaSPdYRlDAynIxLveGo=;
        b=lXlmZY+H3eD85fuyNMPDlq4Aa5FgewPsamD/IjZ0qZLOpz3S1+EA8En80Wu2kFw9T/
         5VDqCw+8D6GhKGyqjIR1XnDwk9Q/YVbrTF5Vxqx67Kx+yE+c3JRcTmnQY9tWMZj5GtB8
         ApUkLWgH3rD1m4hQTgg45IOrRI/UKBztm0iYBonqr8E2sfXCESwmhS9L7qJp7XNAte92
         aMFusqyTDS2OS9jceJ/86mFMiLwCEOfmd5PQ3J8YZXAtxnCtlFCM9ndLmUATa6XlcpeS
         PycdVEQp3d6YRMUwLgZNZzdwhLfUlm8UcmzaRNc/uwFq+4lKPCE5RC+qp8Ms8dmyj+Uq
         Xpng==
X-Gm-Message-State: AOAM5315aQRe9N2rGAZn762AtxblC7X9+SPIz9FPwdYPBaCN0iJ264ns
        lOorRgTcySKJz8xZYaP8bccTxYQs0Hu/RJndWF60HgA/vBJQANc3PAiWHNop7CfHqIgxGR4Yt5h
        TC+vhzIHmRalwlaFR
X-Received: by 2002:adf:d841:: with SMTP id k1mr5563929wrl.227.1601998129365;
        Tue, 06 Oct 2020 08:28:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxec4UfB0CGEg5/hujQVs3YwrNsB08CAyEAQK+3mUtbHLILGP9rB9x74qM/5zMopOjtzDtnew==
X-Received: by 2002:adf:d841:: with SMTP id k1mr5563895wrl.227.1601998129069;
        Tue, 06 Oct 2020 08:28:49 -0700 (PDT)
Received: from localhost ([176.207.245.61])
        by smtp.gmail.com with ESMTPSA id i11sm5012094wre.32.2020.10.06.08.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 08:28:48 -0700 (PDT)
Date:   Tue, 6 Oct 2020 17:28:45 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Tirthendu Sarkar <tirtha@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20201006152845.GC43823@lore-desk>
References: <cover.1601648734.git.lorenzo@kernel.org>
 <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
 <20201002160623.GA40027@lore-desk>
 <5f776c14d69b3_a6402087e@john-XPS-13-9370.notmuch>
 <20201005115247.72429157@carbon>
 <5f7b8e7a5ebfc_4f19a208ba@john-XPS-13-9370.notmuch>
 <20201005222454.GB3501@localhost.localdomain>
 <5f7bf2b0bf899_4f19a2083f@john-XPS-13-9370.notmuch>
 <20201006093011.36375745@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <20201006093011.36375745@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 05 Oct 2020 21:29:36 -0700
> John Fastabend <john.fastabend@gmail.com> wrote:
>=20
> > Lorenzo Bianconi wrote:
> > > [...]
> > >  =20
> > > >=20
> > > > In general I see no reason to populate these fields before the XDP
> > > > program runs. Someone needs to convince me why having frags info be=
fore
> > > > program runs is useful. In general headers should be preserved and =
first
> > > > frag already included in the data pointers. If users start parsing =
further
> > > > they might need it, but this series doesn't provide a way to do that
> > > > so IMO without those helpers its a bit difficult to debate. =20
> > >=20
> > > We need to populate the skb_shared_info before running the xdp progra=
m in order to
> > > allow the ebpf sanbox to access this data. If we restrict the access =
to the first
> > > buffer only I guess we can avoid to do that but I think there is a va=
lue allowing
> > > the xdp program to access this data. =20
> >=20
> > I agree. We could also only populate the fields if the program accesses
> > the fields.
>=20
> Notice, a driver will not initialize/use the shared_info area unless
> there are more segments.  And (we have already established) the xdp->mb
> bit is guarding BPF-prog from accessing shared_info area.=20
>=20
> > > A possible optimization can be access the shared_info only once befor=
e running
> > > the ebpf program constructing the shared_info using a struct allocate=
d on the
> > > stack. =20
> >=20
> > Seems interesting, might be a good idea.
>=20
> It *might* be a good idea ("alloc" shared_info on stack), but we should
> benchmark this.  The prefetch trick might be fast enough.  But also
> keep in mind the performance target, as with large size frames the
> packet-per-sec we need to handle dramatically drop.

right. I guess we need to define a workload we want to run for the
xdp multi-buff use-case (e.g. if MTU is 9K we will have ~3 frames
for each packets and # of pps will be much slower)

>=20
>=20

[...]

>=20
> I do think it makes sense to drop the helpers for now, and focus on how
> this new multi-buffer frame type is handled in the existing code, and do
> some benchmarking on higher speed NIC, before the BPF-helper start to
> lockdown/restrict what we can change/revert as they define UAPI.

ack, I will drop them in v5.

Regards,
Lorenzo

>=20
> E.g. existing code that need to handle this is existing helper
> bpf_xdp_adjust_tail, which is something I have broad up before and even
> described in[1].  Lets make sure existing code works with proposed
> design, before introducing new helpers (and this makes it easier to
> revert).
>=20
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp=
-multi-buffer01-design.org#xdp-tail-adjust
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX3yNKwAKCRA6cBh0uS2t
rI9PAP0bEg3Lo9OrmegA+nOSOUzqQgimJe9RR2yiiTIrQzRo4AD+LPudD17gposr
ecBCDjvmi1ys7h5OSthvcLWdjStm7gc=
=1ZE2
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--

