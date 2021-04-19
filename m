Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BFD363BF9
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhDSG45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:56:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231203AbhDSG4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 02:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618815357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CfFgAP3oaXw9DBMJywNjiJxkc/lfcdS2wTAzSi6+ro8=;
        b=UGlsAJ9S0XYGimHLvecSY/yd8fWIZM8LveyFv7HnAgnQURpsHfkHR3hc3aQNLbK2txMgQ2
        9ZHMILrxe/kUQAIsJyEwXpiHPxN08QjXksgIpwtTGhQ55VH7DFUpjq1yDniJ0ZCcO/DJl9
        iTVWtMBSaudJf0ZLlwOtlPjctBmC7+o=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-C24pK-qvO0uN6f9lA6hadg-1; Mon, 19 Apr 2021 02:55:54 -0400
X-MC-Unique: C24pK-qvO0uN6f9lA6hadg-1
Received: by mail-ej1-f70.google.com with SMTP id o25-20020a1709061d59b029037c94676df5so3288170ejh.7
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 23:55:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CfFgAP3oaXw9DBMJywNjiJxkc/lfcdS2wTAzSi6+ro8=;
        b=Sn/+p3aKV8IYqIEMds0Rje6dFBglj23QurlKtDkCiwc8TeRsUoLugOH7w+KG51o4lq
         5BQQ1QmkKO/G/lSUflKwglqgWwC3BQJILwHdhAeCUEb5XQONbgUHZvDMI5hqrINpHmxl
         X/bNIyenVmF7SRFrb17EnGljdu0vQ4Bf48Xv1ct4hq/fbZTCepR1aC1AFC4Iy1hif7GX
         EYkgno81CFYh6+bNUshRUG4PhA3oXPvygk0JoPrqJdQrlj949vj1Sx5zoLhyUVaxeoUT
         o++I8auGQ5iDe4JTp0blZVTJiVeuVyh7RL5JYS2MkHL8JQgqo6TPjYbKlejygTdESM9q
         E97w==
X-Gm-Message-State: AOAM530a9kQzZ5TF/Y8UqAPy2AvoxecgVJlC65wSdg2HE00QdysREc7I
        39cPx0lw5wzId/zGh0XQ2/g6YgFm/XzLye3A/3NtWsMohtUUI6JdfUo8ZdYpwat8W4HJ6t6kpED
        NaSnPYZLPslEBwp2k
X-Received: by 2002:a17:906:9b2:: with SMTP id q18mr20434087eje.147.1618815353492;
        Sun, 18 Apr 2021 23:55:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcn890CBV/YNi8GpOhoDwYaWgjCDq79VbJ5vYMQq42Tf7E/7us2+m+jkJL+50T0u4LSEMJwg==
X-Received: by 2002:a17:906:9b2:: with SMTP id q18mr20434070eje.147.1618815353329;
        Sun, 18 Apr 2021 23:55:53 -0700 (PDT)
Received: from localhost ([151.66.28.185])
        by smtp.gmail.com with ESMTPSA id s3sm12039574edw.66.2021.04.18.23.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 23:55:52 -0700 (PDT)
Date:   Mon, 19 Apr 2021 08:55:49 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        sameehj@amazon.com, John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
Message-ID: <YH0pdXXsZ7IELBn3@lore-desk>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
 <20210418181801.17166935@carbon>
 <CAJ8uoz0m8AAJFddn2LjehXtdeGS0gat7dwOLA_-_ZeOVYjBdxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zJQ7ehSoYb8/vkCh"
Content-Disposition: inline
In-Reply-To: <CAJ8uoz0m8AAJFddn2LjehXtdeGS0gat7dwOLA_-_ZeOVYjBdxw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zJQ7ehSoYb8/vkCh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sun, Apr 18, 2021 at 6:18 PM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > On Fri, 16 Apr 2021 16:27:18 +0200
> > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> >
> > > On Thu, Apr 8, 2021 at 2:51 PM Lorenzo Bianconi <lorenzo@kernel.org> =
wrote:
> > > >
> > > > This series introduce XDP multi-buffer support. The mvneta driver is
> > > > the first to support these new "non-linear" xdp_{buff,frame}. Revie=
wers
> > > > please focus on how these new types of xdp_{buff,frame} packets
> > > > traverse the different layers and the layout design. It is on purpo=
se
> > > > that BPF-helpers are kept simple, as we don't want to expose the
> > > > internal layout to allow later changes.
> > > >
> > > > For now, to keep the design simple and to maintain performance, the=
 XDP
> > > > BPF-prog (still) only have access to the first-buffer. It is left f=
or
> > > > later (another patchset) to add payload access across multiple buff=
ers.
> > > > This patchset should still allow for these future extensions. The g=
oal
> > > > is to lift the XDP MTU restriction that comes with XDP, but maintain
> > > > same performance as before.
> > [...]
> > > >
> > > > [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-=
4k-mtu-and-rx-zerocopy
> > > > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/co=
re/xdp-multi-buffer01-design.org
> > > > [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-supp=
ort-to-a-NIC-driver (XDPmulti-buffers section)
> > >
> > > Took your patches for a test run with the AF_XDP sample xdpsock on an
> > > i40e card and the throughput degradation is between 2 to 6% depending
> > > on the setup and microbenchmark within xdpsock that is executed. And
> > > this is without sending any multi frame packets. Just single frame
> > > ones. Tirtha made changes to the i40e driver to support this new
> > > interface so that is being included in the measurements.
> >
> > Could you please share Tirtha's i40e support patch with me?
>=20
> We will post them on the list as an RFC. Tirtha also added AF_XDP
> multi-frame support on top of Lorenzo's patches so we will send that
> one out as well. Will also rerun my experiments, properly document
> them and send out just to be sure that I did not make any mistake.

ack, very cool, thx

>=20
> Just note that I would really like for the multi-frame support to get
> in. I have lost count on how many people that have asked for it to be
> added to XDP and AF_XDP. So please check our implementation and
> improve it so we can get the overhead down to where we want it to be.

sure, I will do.

Regards,
Lorenzo

>=20
> Thanks: Magnus
>=20
> > I would like to reproduce these results in my testlab, in-order to
> > figure out where the throughput degradation comes from.
> >
> > > What performance do you see with the mvneta card? How much are we
> > > willing to pay for this feature when it is not being used or can we in
> > > some way selectively turn it on only when needed?
> >
> > Well, as Daniel says performance wise we require close to /zero/
> > additional overhead, especially as you state this happens when sending
> > a single frame, which is a base case that we must not slowdown.
> >
> > --
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> >
>=20

--zJQ7ehSoYb8/vkCh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYH0pcwAKCRA6cBh0uS2t
rLg6AQC4guHiZReHqLkzgFeVNP3vQpWAKZzxHZ6EIgR8I6Ba+AEA0uGSd14znwF8
DySXiO48RWgBbJeoVDf6wSagKTGRCA0=
=rFYd
-----END PGP SIGNATURE-----

--zJQ7ehSoYb8/vkCh--

