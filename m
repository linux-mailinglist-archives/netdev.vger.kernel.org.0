Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86C43118F09
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfLJRbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:31:17 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33554 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbfLJRbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:31:17 -0500
Received: by mail-pf1-f196.google.com with SMTP id y206so192940pfb.0
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 09:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=J7eD26mFIlQahOsKyXk+aSeIwPjhMzK6P1OiNJx0ExI=;
        b=bSIab2f4FVE6XLbfo7AYMYu9i+Nj45cDMdNIDoeMra9jfB8z/ClzUlL4gseBRg3QLM
         ZEynPUMUTN1o6+EsAq8qnENQMLvRCdFh0eoQp5pzcDpheEwYuxCTeRXIWD7HWiBCcVvy
         SVGZUVMEDv7MpZ0T03svN5glx7fx7fmoiOPT18BSd2B4GH4/LNtNea2f8ZgdfuhWHUtT
         2FNzJqoRB1M+bu7+16SQSc8IqrUBYC5ULP0aIsRgahk6XDXgRioy2qKu7CcWSXg7M08O
         QkPhQot0Lu5cfz88PlG+CMaLOCGbl2TzqkEL0yYK82QzKreRYlNHqaTdReDEHZ2MLv2j
         Pgdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=J7eD26mFIlQahOsKyXk+aSeIwPjhMzK6P1OiNJx0ExI=;
        b=r5mwN9kXB5LQhXqcPdriaD37KCyEEHwrr0Io8wggL0K7g1KZHLiOGl/JjtXL+2B0Wi
         Btx0oPSTyGE3CpnoyBE1c2BftOK7mx/0LpezzTl0m77H0NPSnF41OV3O2odl93OCflAG
         UJwrw7itfPYNLCSkM60wXSY6hATT3RHODgx4GtB0Hkou6FVobjP889zRW+x4uZApLvre
         P96r8vy5qGcF59Ovb05j6TqWYjLJCtDUQbFdIarXenZ0ORinQ2DMTBu2kyvqV/vrf/Nh
         UGMeYzOBvRHDIm2pQNgG99tXpgttx5zddrk5u/syJ6bpZhOsHcYwdld2aFzBF7LBUPjN
         pf8g==
X-Gm-Message-State: APjAAAVJnhJ7PMW6ocG0uMCMkD1qzsXoMe4pSUe94hCLmLYqiTAGbRu7
        ZTd1ZO1g2eFPyP+QDObHxtl8ng==
X-Google-Smtp-Source: APXvYqy+kQLqyeUYQhiA8k8C9HrBqehNSjFCKUoZ4jUrzygwOhI0FW6fEcG2hvsPNn56/YdQZJk6/g==
X-Received: by 2002:a62:7590:: with SMTP id q138mr35504583pfc.241.1575999075344;
        Tue, 10 Dec 2019 09:31:15 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::3])
        by smtp.gmail.com with ESMTPSA id i16sm4113991pfo.12.2019.12.10.09.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 09:31:15 -0800 (PST)
Date:   Tue, 10 Dec 2019 09:31:11 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-ID: <20191210093111.7f1ad05d@cakuba.netronome.com>
In-Reply-To: <CAHo-OowHek4i9Pzxn96u8U5sTH8keQmi-yMCY-OBS7CE74OGNQ@mail.gmail.com>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
        <20191209224530.156283-1-zenczykowski@gmail.com>
        <20191209154216.7e19e0c0@cakuba.netronome.com>
        <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
        <20191209161835.7c455fc0@cakuba.netronome.com>
        <CAHo-OowHek4i9Pzxn96u8U5sTH8keQmi-yMCY-OBS7CE74OGNQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 12:46:29 +0100, Maciej =C5=BBenczykowski wrote:
> > Okay, that's what I was suspecting.  It'd be great if the real
> > motivation for a patch was spelled out in the commit message :/ =20
>=20
> It is, but the commit message is already extremely long.

Long, yet it doesn't mention the _real_ reason for the patch.

> At some point essays and discussions belong in email and not in the
> commit message.

Ugh just admit you didn't mention the primary use case in the commit
log, and we can move on.

> Here's another use case:
>=20
> A network where firewall policy or network behaviour blocks all
> traffic using specific ports.
>=20
> I've seen generic firewalls that unconditionally drop all BGP or SMTP
> port traffic, or all traffic on ports 5060/5061 (regardless of
> direction) or on 25/53/80/123/443/853/3128/8000/8080/8088/8888
> (usually due to some ill guided security policies against sip or open
> proxies or xxx). If you happen to use port XXXX as your source port
> your connection just hangs (packets are blackholed).
>=20
> Sure you can argue the network is broken, but in the real world you
> often can't fix it... Go try and convince your ISP that they should
> only drop inbound connections to port 8000, but not outgoing
> connections from port 8000 - you'll go crazy before you find someone
> who even understands what you're talking about - and even if you find
> such a person, they'll probably be too busy to change things - and
> even though it might be a 1 letter change (port -> dport) - it still
> might take months of testing and rollout before it's fully deployed.
>=20
> I've seen networks where specific ports are automatically classified
> as super high priority (network control) so you don't want anything
> using these ports without very good reason (common for BGP for
> example, or for encap schemes).
>=20
> Or a specific port number being reserved by GUE or other udp encap
> schemes and thus unsafe to use for generic traffic (because the
> network or even the kernel itself might for example auto decapsulate
> it [via tc ebpf for example], or parse the interior of the packet for
> flowhashing purposes...).
>=20
> [I'll take this opportunity to point out that due to poor flow hashing
> behaviour GRE is basically unusable at scale (not to mention poorly
> extensible), and thus GUE and other UDP encap schemes are taking over]
>=20
> Or you might want to forward udp port 4500 from your external IP to a
> dedicated ipsec box or some hardware offload engine... etc.

It's networking you can concoct a scenario to justify anything.

> > So some SoCs which run non-vanilla kernels require hacks to steal
> > ports from the networking stack for use by proprietary firmware.
> > I don't see how merging this patch benefits the community. =20
>=20
> I think you're failing to account for the fact that the majority of
> Linux users are Android users - there's around 2.5 billion Android
> phones in the wild... - but perhaps you don't consider your users (or
> Android?) to be part of your community?

I don't consider users of non-vanilla kernels to necessarily be a
reason to merge patches upstream, no. They carry literally millions=20
of lines of patches out of tree, let them carry this patch, too.
If I can't boot a vanilla kernel on those devices, and clearly there is
no intent by the device manufacturers for me to ever will, why would I
care? Some companies care about upstream, and those should be rewarded
by us taking some of the maintenance off their hands. Some don't:
https://www.youtube.com/watch?v=3D_36yNWw_07g (link to Linus+nVidia video)=
=20
even tho they sell majority of SoCs for 2.5 billion devices.

> btw. Chrome OS is also Linux based (and if a quick google search is to
> be believed, about 1/7th of the linux desktop/laptop share), but since
> it supports running Android apps, it needs to have all Android
> specific generic kernel changes...
>=20
> The reason Android runs non-vanilla kernels is *because* patches like
> this - that make Linux work in the real world - are missing from
> vanilla Linux
> (I can think of a few other networking patches off the top of my head
> where we've been unable to upstream them for no particularly good
> reason).

The way to get those patches upstream is to have a honest discussion
about the use case so people can validate the design. Not by sending
a patch with a 5 page commit message which fails to clearly state the
motivation for the feature :/
