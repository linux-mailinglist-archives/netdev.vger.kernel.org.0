Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 036445A5D8
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfF1UZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:25:22 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33350 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfF1UZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:25:21 -0400
Received: by mail-qt1-f196.google.com with SMTP id h24so4776196qto.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 13:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=YgOkvMRbAoBV9RdEWjxdL5LcNeoNsF2571Oh25CeOBw=;
        b=QzE1KzevnHvw2DlPmsGsEfdOepxU79Es3UiyhdeOMln6yJzTbKeyitv9bFSDwj3Rx9
         66XPQkE8+TsusPrbHla/JjYTLX/tFvHUMEutclrzhlEuVSjm0/nF2I4uaBKTVPhyVL/E
         FS/05Djg9y/041KBPy3cgG/3AS3mxCiH7Vd5NSdENcfZ1SJ37dB0jpMoKuWYldGM+YBY
         oXdQ/71UBOX2O+4V3A5uo2wezvd/0HCZbGB8lJ1LFl8VDGahWa6AJ/Ez8B/qf4j/Fk5y
         Av+RrkoQc/kUXMvimtRI6d0CG/9Bks/3EpPvUMjPkmC5RWm8goEPdjw3b1PSCarr3TVg
         Cz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YgOkvMRbAoBV9RdEWjxdL5LcNeoNsF2571Oh25CeOBw=;
        b=keixp8h91ISssgkyqe61/iGuoXQ7w0XptShgqW3zFyDZke52H3DhdwRqvvXdREWPNh
         eZsr8jhXgI8SO4RyefjZ1huIXeff4jgA1FL3Z/CvjXFoo6pu4prqWTq5HiqbQgTOROAD
         BupcOQkiQRwvthJ1FRt204xPZUX6n2hfmHWPgih6viOdJ3tiNRr/gv6piytRUZx0qURu
         /oqFP8R9EBhlFHQqE5u6yPsRZwhrl042qzBGR5v0eRYHv3Z4WewaTxGH1S5OA3pHKrly
         L1OIUTSWCKb/UCB8KsAS44iIDVUhV282yFmynxBNtw1n7V+tM+Zx4CKPzT9xeQ5MQQjF
         L2bg==
X-Gm-Message-State: APjAAAWh0WifNkUeI96eAviIQVrmWRKFSrOygr58K7qAFgyna424k7M1
        cSOgLKteuF7KTGo1j23jUrr5yg==
X-Google-Smtp-Source: APXvYqxYTPmzEj683koEfyjLlMd0M3Tt8zuPQO5h4/CE4XS5HzFO8KqqjrXRaM6yHId7odT4p28uog==
X-Received: by 2002:a0c:b90a:: with SMTP id u10mr10012395qvf.201.1561753520824;
        Fri, 28 Jun 2019 13:25:20 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f132sm1519910qke.88.2019.06.28.13.25.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 13:25:20 -0700 (PDT)
Date:   Fri, 28 Jun 2019 13:25:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Laatz, Kevin" <kevin.laatz@intel.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
Message-ID: <20190628132516.723ef517@cakuba.netronome.com>
In-Reply-To: <f0ca817a-02b4-df22-d01b-7bc07171a4dc@intel.com>
References: <20190620083924.1996-1-kevin.laatz@intel.com>
        <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
        <ef7e9469-e7be-647b-8bb1-da29bc01fa2e@intel.com>
        <20190627142534.4f4b8995@cakuba.netronome.com>
        <f0ca817a-02b4-df22-d01b-7bc07171a4dc@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 17:19:09 +0100, Laatz, Kevin wrote:
> On 27/06/2019 22:25, Jakub Kicinski wrote:
> > On Thu, 27 Jun 2019 12:14:50 +0100, Laatz, Kevin wrote: =20
> >> On the application side (xdpsock), we don't have to worry about the us=
er
> >> defined headroom, since it is 0, so we only need to account for the
> >> XDP_PACKET_HEADROOM when computing the original address (in the default
> >> scenario). =20
> > That assumes specific layout for the data inside the buffer.  Some NICs
> > will prepend information like timestamp to the packet, meaning the
> > packet would start at offset XDP_PACKET_HEADROOM + metadata len.. =20
>=20
> Yes, if NICs prepend extra data to the packet that would be a problem for
> using this feature in isolation. However, if we also add in support for=20
> in-order RX and TX rings, that would no longer be an issue.

Can you shed more light on in-order rings?  Do you mean that RX frames
come in order buffers were placed in the fill queue?  That wouldn't
make practical sense, no?  Even if the application does no
reordering there is also XDP_DROP and XDP_TX.  Please explain :)

> However, even for NICs which do prepend data, this patchset should
> not break anything that is currently working.

My understanding from the beginnings of AF_XDP was that we were
searching for a format flexible enough to support most if not all NICs.
Creating an ABI which will preclude vendors from supporting DPDK via
AF_XDP would seriously undermine the neutrality aspect.

> > I think that's very limiting.  What is the challenge in providing
> > aligned addresses, exactly? =20
> The challenges are two-fold:
> 1) it prevents using arbitrary buffer sizes, which will be an issue=20
> supporting e.g. jumbo frames in future.

Presumably support for jumbos would require a multi-buffer setup, and
therefore extensions to the ring format. Should we perhaps look into
implementing unaligned chunks by extending ring format as well?

> 2) higher level user-space frameworks which may want to use AF_XDP, such=
=20
> as DPDK, do not currently support having buffers with 'fixed' alignment.
>  =C2=A0=C2=A0=C2=A0 The reason that DPDK uses arbitrary placement is that:
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 - it would stop things working on =
certain NICs which need the=20
> actual writable space specified in units of 1k - therefore we need 2k +=20
> metadata space.
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 - we place padding between buffers=
 to avoid constantly hitting=20
> the same memory channels when accessing memory.
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 - it allows the application to cho=
ose the actual buffer size it=20
> wants to use.
>  =C2=A0=C2=A0=C2=A0 We make use of the above to allow us to speed up proc=
essing=20
> significantly and also reduce the packet buffer memory size.
>=20
>  =C2=A0=C2=A0=C2=A0 Not having arbitrary buffer alignment also means an A=
F_XDP driver=20
> for DPDK cannot be a drop-in replacement for existing drivers in those=20
> frameworks. Even with a new capability to allow an arbitrary buffer=20
> alignment, existing apps will need to be modified to use that new=20
> capability.
