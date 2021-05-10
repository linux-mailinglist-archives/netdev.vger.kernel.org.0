Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305D8379731
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 20:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhEJSyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 14:54:13 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40463 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230229AbhEJSyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 14:54:12 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B4F9C5C0120;
        Mon, 10 May 2021 14:53:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 May 2021 14:53:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=r0qj5R
        lCwePmFyFchT4bxLEmTY2iUQspFuobg+IjXRc=; b=kHo59t6qMXxJly41WkoKt+
        OuUUo314DEbsAH00qyCNCIBpSsv3virlTkCnwMBrRoz6YEI7N3Vv52oP8mtYLUME
        +D8u9wVFYxw34Jm029nYXFaNrZ1zL/Oz0Fmz41eS8R7bieNW53yOPHM5qIJJk9Ln
        L+HaHTc7uVurlgtMq52cr797qNwI7CbrtmmjsL6GwhomfewlzGlAZO2+f8lwZjyD
        368E7WrTy1JXsP+KgWxWKJACF4aeTsxVVAwadjajMLqmtakMNUcvvHpmuRLcAXF+
        rqUVDndmITsBy2dJwDYtgpeHFekU9FSuW8bdD4ivQqMXtOeIGE9IgJ4WTY1S3qcA
        ==
X-ME-Sender: <xms:E4GZYF2IeAYOcb0yPnaTtXwJuSqnxVKL00H5uqXw5BCKF7MYh3oWbA>
    <xme:E4GZYMG5h6_VbR5DrgpqYFM2DR4ev4XaE60AsyCQhRK6vBc8OU_FST61P2Jv_LMAF
    60eii3f0a4yiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepteev
    ffeigffhkefhgfegfeffhfegveeikeettdfhheevieehieeitddugeefteffnecukfhppe
    eluddrieejrdejledrgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehmrghrmhgrrhgvkhesihhnvhhishhisghlvghthhhinhhgshhlrggsrd
    gtohhm
X-ME-Proxy: <xmx:E4GZYF7V-UCSSX1yP42_p-x8l0skhQ5C8VCQjAIpCXINix7qA1pPOA>
    <xmx:E4GZYC25nZurqaMgZ5CqjXh0Z_w4d0kGClKYVm7WmbkRna_lj3EcZA>
    <xmx:E4GZYIEKRu5nGOuEcCeN1MsQ70GC4dD1ioPhhh3Ds6uGap84Tlyq9w>
    <xmx:E4GZYNSG_ZdjzD__G0cgrCn154c6-c7nEznN_s1iYmaJsCulQwBJwg>
Received: from mail-itl (ip5b434f04.dynamic.kabel-deutschland.de [91.67.79.4])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 14:53:05 -0400 (EDT)
Date:   Mon, 10 May 2021 20:53:02 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Michael Brown <mbrown@fensystems.co.uk>
Cc:     paul@xen.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, wei.liu@kernel.org, pdurrant@amazon.com
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching
Message-ID: <YJmBDpqQ12ZBGf58@mail-itl>
References: <54659eec-e315-5dc5-1578-d91633a80077@xen.org>
 <20210413152512.903750-1-mbrown@fensystems.co.uk>
 <YJl8IC7EbXKpARWL@mail-itl>
 <404130e4-210d-2214-47a8-833c0463d997@fensystems.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+ZJZ8cOzaoxgT+l8"
Content-Disposition: inline
In-Reply-To: <404130e4-210d-2214-47a8-833c0463d997@fensystems.co.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+ZJZ8cOzaoxgT+l8
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Mon, 10 May 2021 20:53:02 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Michael Brown <mbrown@fensystems.co.uk>
Cc: paul@xen.org, xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
	wei.liu@kernel.org, pdurrant@amazon.com
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching

On Mon, May 10, 2021 at 07:47:01PM +0100, Michael Brown wrote:
> On 10/05/2021 19:32, Marek Marczykowski-G=C3=B3recki wrote:
> > On Tue, Apr 13, 2021 at 04:25:12PM +0100, Michael Brown wrote:
> > > The logic in connect() is currently written with the assumption that
> > > xenbus_watch_pathfmt() will return an error for a node that does not
> > > exist.  This assumption is incorrect: xenstore does allow a watch to
> > > be registered for a nonexistent node (and will send notifications
> > > should the node be subsequently created).
> > >=20
> > > As of commit 1f2565780 ("xen-netback: remove 'hotplug-status' once it
> > > has served its purpose"), this leads to a failure when a domU
> > > transitions into XenbusStateConnected more than once.  On the first
> > > domU transition into Connected state, the "hotplug-status" node will
> > > be deleted by the hotplug_status_changed() callback in dom0.  On the
> > > second or subsequent domU transition into Connected state, the
> > > hotplug_status_changed() callback will therefore never be invoked, and
> > > so the backend will remain stuck in InitWait.
> > >=20
> > > This failure prevents scenarios such as reloading the xen-netfront
> > > module within a domU, or booting a domU via iPXE.  There is
> > > unfortunately no way for the domU to work around this dom0 bug.
> > >=20
> > > Fix by explicitly checking for existence of the "hotplug-status" node,
> > > thereby creating the behaviour that was previously assumed to exist.
> >=20
> > This change is wrong. The 'hotplug-status' node is created _only_ by a
> > hotplug script and done so when it's executed. When kernel waits for
> > hotplug script to be executed it waits for the node to _appear_, not
> > _change_. So, this change basically made the kernel not waiting for the
> > hotplug script at all.
>=20
> That doesn't sound plausible to me.  In the setup as you describe, how is
> the kernel expected to differentiate between "hotplug script has not yet
> created the node" and "hotplug script does not exist and will therefore
> never create any node"?

Is the later valid at all? From what I can see in the toolstack, it
always sets some hotplug script (if not specified explicitly - then
"vif-bridge"),

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--+ZJZ8cOzaoxgT+l8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmCZgQ4ACgkQ24/THMrX
1yy/ggf/YP/1zFEZRHr/CVh4dFf2WG3tcdu6+PZfVx2t2vgYGy8PTvocREeIBpUE
8Cxa/uvAOF89qo1yLAJq+wlHvvUm+CQCxksO4dGjmz0OLNowekQz93RSyI/W9FYx
I9Mxa5b0ga4X0kFU4Nk7jwZ+KkLfUV248xh7LrpCZ8CyWvWyvH4OIwlfY6nWIVLc
VhcYD4bzibrjyAr7waDSmtvomUHvWc69Xmvj0drHFnrC6dj7p9PRJdgqCCO6u2uf
GKVqEFUWTl4WAGTjb69IZLnRdT4DIlILe5gQOQ+sOsfJktBWsQtQQ3iL/WOVx0Mk
rANHLc/h7UaLAcc88+YCKyGByRiPLA==
=6AQI
-----END PGP SIGNATURE-----

--+ZJZ8cOzaoxgT+l8--
