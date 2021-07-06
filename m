Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0433BDC7D
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 19:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhGFRuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 13:50:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhGFRuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 13:50:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625593657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ud/FbbkqMLCe6Dt8tvS0TkRcWmpTAmpmuojmvS4Bzl0=;
        b=Aj19BvmiIM+SWfzygXyZbzsVdKmmIPRlMFFmsfQoux2/GHGoC9AabuoPRNa91ysQT8jJyz
        U3Wq9tav3O/X7WtPp362djAAhHg626Qc9UrluemQIiBjtFGSr+Kq8zQ6zpe0V0XgEDLBoK
        9TewERh/K+b0WUaugaloa0WSqisUz1A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-CXVnTPIbPLGpJAmEKcwxKQ-1; Tue, 06 Jul 2021 13:47:35 -0400
X-MC-Unique: CXVnTPIbPLGpJAmEKcwxKQ-1
Received: by mail-ed1-f71.google.com with SMTP id m21-20020a50ef150000b029039c013d5b80so1064679eds.7
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 10:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ud/FbbkqMLCe6Dt8tvS0TkRcWmpTAmpmuojmvS4Bzl0=;
        b=WOCoGboH0N8bhaWENDx2a4I5D9QBWX13W587KinW5Xwc+qipCEpAYlKz2mT1og+HGz
         9sPCPmst6jC+bdddpK9DiXLDFFFMeXP/+C7IUWJhTVm1esiAmgqTigub4ztNKjpAFj/a
         X6f+06bdJz/9vo7a/YchV3acyhvDLb9UDgardexXPKJ+2AbtHcNiFrpGmEq73lXPfKfx
         jzL5zR8HBYhYuiJV12C6OnYaTtj5vl5bHnDar5dtpws/GJrU2VMmy+t59UT5EAjtgPYi
         Hq+bOrIq2lHyMwsEqPMxuSarPONUqnMIXd9g9/sRzhfrmsfZylRGVon3GNKtx7oTEWS3
         gPjA==
X-Gm-Message-State: AOAM530JpP5Jjs/1sNZ81hLdRStckeHdANJKZNcyi6h7IkolX/EPw1Sy
        An7T438kC6jazYGvUr/57JRmiWO4CCnv2URH2+3IsKAvY+KBdxWIbIGjaikCa8Yrj+FaTUsRvJf
        X7BUgbBrJDO//C9h8
X-Received: by 2002:a17:907:3e0a:: with SMTP id hp10mr20028631ejc.110.1625593654283;
        Tue, 06 Jul 2021 10:47:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy63BPqIFbjkuQBMUipQjDofizgnH2LF/eLNAGvSlGT1+C1e1zrpkylD+N1hEzc/Rl3Wefznw==
X-Received: by 2002:a17:907:3e0a:: with SMTP id hp10mr20028599ejc.110.1625593654040;
        Tue, 06 Jul 2021 10:47:34 -0700 (PDT)
Received: from localhost (net-93-71-3-244.cust.vodafonedsl.it. [93.71.3.244])
        by smtp.gmail.com with ESMTPSA id o9sm7501831edc.91.2021.07.06.10.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 10:47:33 -0700 (PDT)
Date:   Tue, 6 Jul 2021 19:47:30 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Subject: Re: [PATCH v9 bpf-next 02/14] xdp: introduce flags field in
 xdp_buff/xdp_frame
Message-ID: <YOSXMkI3XM+1xqmf@lore-desk>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <1316f3ef2763ff4c02244fb726c61568c972514c.1623674025.git.lorenzo@kernel.org>
 <CAKgT0Ue7TsgwbQF+mfeDB-18Q-R29YZWe=y6Kgeg0xxbwds=vw@mail.gmail.com>
 <YNsVcy8e4Mgyg7g3@lore-desk>
 <CAKgT0Ucg5RbzKt63u5RfXee94kd+1oJ+o_qgUwCwnVCoQjDdPw@mail.gmail.com>
 <YOMq0WRu4lsGZJk2@lore-desk>
 <CAKgT0Udn90g9s3RYiGA0hFz7bXaepPNJNqgRjMtwjpdj1zZTDw@mail.gmail.com>
 <YORELD7ve/RMYsua@lore-desk>
 <CAKgT0UceWvSzYrt=0cJTqjhTE6CHiuo0nXV+YG+1qc9Nr2bJZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yWLL6sKrVEZutc8e"
Content-Disposition: inline
In-Reply-To: <CAKgT0UceWvSzYrt=0cJTqjhTE6CHiuo0nXV+YG+1qc9Nr2bJZg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yWLL6sKrVEZutc8e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Jul 6, 2021 at 4:53 AM Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:
> >
> > > On Mon, Jul 5, 2021 at 8:52 AM Lorenzo Bianconi
> > > <lorenzo.bianconi@redhat.com> wrote:
> > > >
> > > > > On Tue, Jun 29, 2021 at 5:43 AM Lorenzo Bianconi
> > > > > <lorenzo.bianconi@redhat.com> wrote:
> >
> > [...]
> > >
> > > Hi Lorenzo,
> > >
> > > What about doing something like breaking up the type value in
> > > xdp_mem_info? The fact is having it as an enum doesn't get us much
> > > since we have a 32b type field but are only storing 4 possible values
> > > there currently
> > >
> > > The way I see it, scatter-gather is just another memory model
> > > attribute rather than being something entirely new. It makes as much
> > > sense to have a bit there for MEM_TYPE_PAGE_SG as it does for
> > > MEM_TYPE_PAGE_SHARED. I would consider either splitting the type field
> > > into two 16b fields. For example you might have one field that
> > > describes the source pool which is currently either allocated page
> > > (ORDER0, SHARED), page_pool (PAGE_POOL), or XSK pool (XSK_BUFF_POOL),
> > > and then two flags for type with there being either shared and/or
> > > scatter-gather.
> >
> > Hi Alex,
> >
> > I am fine reducing the xdp_mem_info size defining type field as u16 ins=
tead of
> > u32 but I think mb is a per-xdp_buff/xdp_frame property since at runtim=
e we can
> > receive a tiny single page xdp_buff/xdp_frame and a "jumbo" xdp_buff/xd=
p_frame
> > composed by multiple pages. According to the documentation available in
> > include/net/xdp.h, xdp_rxq_info (where xdp_mem_info is contained for xd=
p_buff)
> > is "associated with the driver level RX-ring queues and it is informati=
on that
> > is specific to how the driver have configured a given RX-ring queue" so=
 I guess
> > it is a little bit counterintuitive to add this info there.
>=20
> It isn't really all that counterintuitive. However it does put the
> onus on the driver to be consistent about things. So even a
> single-buffer xdp_buff would technically have to be a scatter-gather
> buff, but it would have no fragments in it. So the requirement would
> be to initialize the frags and data_len fields to 0 for all xdp_buff
> structures.

nr_frags and data_len are currently defined in skb_shared_info(xdp_buff)
so I guess initialize them to 0 will trigger a cache miss (in fact we
introduced the mb bit just to avoid this initialization and introduce
penalties for legacy single-buffer use-case). Do you mean to have these
fields in xdp_buff/xdp_frame structure?

>=20
> > Moreover we have the "issue" for devmap in dev_map_bpf_prog_run() when =
we
> > perform XDP_REDIRECT with the approach you proposed and last we can reu=
se this
> > new flags filed for XDP hw-hints support.
> > What about reducing xdp_mem_info and add the flags field in xdp_buff/xd=
p_frame
> > in order to avoid increasing the xdp_buff/xdp_frame size? Am I missing
> > something?
>=20
> The problem is there isn't a mem_info field in the xdp_buff. It is in
> the Rx queue info structure.

yes, this is what I meant :)

Regards,
Lorenzo

>=20
> Thanks,
>=20
> - Alex
>=20

--yWLL6sKrVEZutc8e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYOSXLwAKCRA6cBh0uS2t
rFheAP0bbdKK5UUCfa61CqcMUW7ZVf/w0607zYEUWMVAbA8GswEAlc89xSiVJQmK
dfJKdx91FZh7pHNf4rWT6CbPh++ZUgE=
=TfkO
-----END PGP SIGNATURE-----

--yWLL6sKrVEZutc8e--

