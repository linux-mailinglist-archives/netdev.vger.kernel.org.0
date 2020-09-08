Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B26C260F6C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 12:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgIHKOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 06:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729333AbgIHKOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 06:14:16 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4F3C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 03:14:15 -0700 (PDT)
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599560053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qp4IN52qcyrPxBCQ5gd6Y4yDLM8yTjX7VyRMPyI/RYM=;
        b=M3FMhLMbzl502AjjxwdZFUbJmSEIetFpCKJ0q88T/W/x53t54lau4hrMdTXTYhZtFyV3J+
        DB+AhmtrCA6CumQI3EPn35KsMqLJOXbpYd6fiMZRDGRVrhPy3XSEAq0OvcERl7bWA+85CA
        Y+Gx7HfD39pHHn+Qq4FNTjf7RXq2nCz0heD7/GrihWU5uWw4JDeRcP9fax8XcPTq3xBQYQ
        7LQYbwJH76I1PqjSaWOHX/WI/W5cCA0eicmLK0cfug4Y8rfGIH/4hZqt/5ZkPhGE65Dp/N
        ip9kAdIFodZhCkuxYs8nQ+Z/DQWGZpkP+09hrxZMAUgVPSnBqkgnCAHwMaWWaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599560053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qp4IN52qcyrPxBCQ5gd6Y4yDLM8yTjX7VyRMPyI/RYM=;
        b=6v2O8eTtEQRJc4TYgeyyO7sai3wC+BWuB39EI1c3A6TfAW/O6X7SZXPbCkor7IZzf/uUEW
        ho0ba/lW7OG4RCCw==
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set configure_vlan_while_not_filtering to true by default
In-Reply-To: <20200907182910.1285496-5-olteanv@gmail.com>
References: <20200907182910.1285496-1-olteanv@gmail.com> <20200907182910.1285496-5-olteanv@gmail.com>
Date:   Tue, 08 Sep 2020 12:14:12 +0200
Message-ID: <87y2lkshhn.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Sep 07 2020, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> As explained in commit 54a0ed0df496 ("net: dsa: provide an option for
> drivers to always receive bridge VLANs"), DSA has historically been
> skipping VLAN switchdev operations when the bridge wasn't in
> vlan_filtering mode, but the reason why it was doing that has never been
> clear. So the configure_vlan_while_not_filtering option is there merely
> to preserve functionality for existing drivers. It isn't some behavior
> that drivers should opt into. Ideally, when all drivers leave this flag
> set, we can delete the dsa_port_skip_vlan_configuration() function.
>
> New drivers always seem to omit setting this flag, for some reason.

Yes, because it's not well documented, or is it? Before writing the
hellcreek DSA driver, I've read dsa.rst documentation to find out what
callback function should to what. Did I miss something?

> So let's reverse the logic: the DSA core sets it by default to true
> before the .setup() callback, and legacy drivers can turn it off. This
> way, new drivers get the new behavior by default, unless they
> explicitly set the flag to false, which is more obvious during review.

Yeah, that behavior makes more sense to me. Thank you.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9XWXQACgkQeSpbgcuY
8Ka30w//YuLiwy7MusXUQErT4H5Cr+s5JCBSF0NKhsRztWXiQpVpB35GK+nobK8N
OWFuWkieDOH2RTm6r8Gencv47D9kyYrkOq0ZnXM9RJaHQPowRcHljkJq7CKqrWnS
acazKpTvLJVZn+/kZwxxA0lM3QWy+/IqVLbGPusoSjg+YovwoEAuvXyKvCPfcTWl
DOO5dOPXHH/JEw/CDK4OLcA5HgG/Q07gKdl5BOdqZZwDuofExl6dUAfFNEo89Cgg
6Wm0iAwicDPZ9XNNJgpLdc2fArMvb0mu/3kXPowHmcPSnOm7kn/CqLpOhOHLo3FS
vH7ciZe4/CWgMcZY0+tloQrrznZfpvUhjbw1i0Uoc5IxjGmvAGVdY/cJr+MuZbjG
ZhA1MxbE4P+voibDymQ5jLFWXedo0FMhXVf0VwM74Ff1kM4gGdSY7XrYcMpbNUIn
k+KR170yT046UDGAo16VYIfu4LuD3IBV9+MAmflxtI04ZkNcY6eW4XYDxrO0y1TM
aXYZkr7PN30ZVZyGJCGOImglechF/+rW/nBq3H+NSmlFHOmrBZrujU/3SqUgVUav
g7vTWllnLHMTIzzfaXLcM2zYbKlKe7Zfy3TWhRwzUl1/lYQa8J95DJXxw+I+zpR+
p26Uy8d4vyCmyH9OxbKsUklPY723xjPFI/uJgXk/cZ30H6E96Ak=
=32lY
-----END PGP SIGNATURE-----
--=-=-=--
