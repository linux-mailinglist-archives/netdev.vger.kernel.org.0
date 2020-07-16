Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EEE221FA1
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 11:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgGPJXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 05:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgGPJXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 05:23:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4EAC061755;
        Thu, 16 Jul 2020 02:23:35 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594891413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cy5bVorjFk07KMBWryKUafd0Z6XE/mb1/WHYN29Nh+0=;
        b=YAdf5+jVXhtr/Y5B2YZjgpspyD9dDpUrOk0n2B4jc7XovmREiRorMZmM+WVUb5Wg6K3qjC
        nM12mGUxPlaFpGWol7iDn6PhPBPHqF9YCR8l7r/FWvSNcxxLhxT26aTJSZxo75U4XwabL0
        GSINbRejiIo/yuyT/3PorH40+lBFTvaO7BQjixSBN2VsWjvpg4rIM9K46qcSqaZb8qwlhZ
        DyqFFNesnjEF/dXoMdPxTtrfmc7j6Qh0CaqvXw+52KcWObDrzhVDETE/8xzhCU5dh317bR
        sEbk1mJ9ZlMs6xGwfOBSC5PuVYxr9+4OanTX7Ro4mDrNCYezyJF8J/R+l9gJtA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594891413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cy5bVorjFk07KMBWryKUafd0Z6XE/mb1/WHYN29Nh+0=;
        b=lYGGEEQOem02iXgTItvsUpAcdQ/prDe9aqkzF3HBN8B14tPV1/AJROzhFbqmTwxNtM4zx1
        7nuLTBoizNkTtmDg==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v1 2/8] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20200716082935.snokd33kn52ixk5h@skbuf>
References: <20200710113611.3398-1-kurt@linutronix.de> <20200710113611.3398-3-kurt@linutronix.de> <def49ff6-72fe-7ca0-9e00-863c314c1c3d@gmail.com> <87v9islyf2.fsf@kurt> <20200716082935.snokd33kn52ixk5h@skbuf>
Date:   Thu, 16 Jul 2020 11:23:26 +0200
Message-ID: <87h7u7x181.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Jul 16 2020, Vladimir Oltean wrote:
> On Mon, Jul 13, 2020 at 08:30:25AM +0200, Kurt Kanzenbach wrote:
>> On Sat Jul 11 2020, Florian Fainelli wrote:
>> > On 7/10/2020 4:36 AM, Kurt Kanzenbach wrote:
>> > [snip]
>> >
>> >> +
>> >> +/* Default setup for DSA:
>> >> + *  VLAN 2: CPU and Port 1 egress untagged.
>> >> + *  VLAN 3: CPU and Port 2 egress untagged.
>> >
>> > Can you use any of the DSA_TAG_8021Q services to help you with that?
>>=20
>> Maybe dsa_port_setup_8021q_tagging() could be used. It does distinguish
>> between RX and TX, but I assume it'd also work. Needs to be tested.
>>=20
>
> The fundamental role of DSA_TAG_8021Q is not to give you port
> separation, but port identification, when there is no hardware tagging
> support, or it cannot be used.

OK. Then it shouldn't be used.

> So in fact, it is quite the contrary:
> tag_8021q assumes that port separation will be achieved by external
> means. Most switches support a "port forwarding matrix" of sorts (i.e.
> "is port i allowed to forward to port j?"), and that is what is used, in
> tag_8021q setups, to isolate one port from another on RX (in standalone
> mode). I'm not sure what's the status with hellcreek hardware design, it
> seems very odd to me to not include any sort of port forwarding matrix,
> and to have to rely on port membership on each port's pvid to achieve
> that in the .port_bridge_join method.

As far as I know there is no port forwarding matrix. Traffic is
forwarded between the ports when they're members of the same
vlan. That's why I created them by default.

> By the way, this brings up another topic: any 'bridge vlan add' for a
> pvid will break your setup. You should avoid that somehow.

So usually for vlan configurations the bridge is created with
vlan_filtering set. In that case the default setting is reverted (see
hellcreek_vlan_filtering()).

> Please try to set ds->configure_vlan_while_not_filtering =3D true; in your
> .setup callback.  We're trying to make all switches behave uniformly and
> be able to deal with VLANs added straight away by the bridge. Don't be
> confused by the fact that it's an option - there's nothing really
> optional about it, it is just there to avoid breakage in drivers which
> haven't been converted.  Since yours is a new driver, it should enable
> this option from day 1.

OK.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8QHI4ACgkQeSpbgcuY
8KbmCQ/+PoESTzw3Mg0okdUN2cnJA1JoWcKm8DPa4n6gTFjVbSIJotHQcqXGMkg3
VJ2e8ajL7E5H8eKvhKT1Wf1W8hn+O6Srx+h/zRl+DYg5euH3PBEzC401RB3O78X/
Yc9YgXl/jiYn7vGbcrtsikUy4dVauzBL0ZzCj2B1xDdgxoRll5G/LrpF5UvDBgxp
dQXzJG8DSuofKXEI7Q08/KDD6ADsqnsoEVKlr9AYyt856MQLDxsaG/CSBdxwqjr8
Q0GDsryznOMz16Sq16TC2c/TFWu3SxhBpKiM9m5IucJdoThqaAmsoJEjiH4Uh85d
7a1oDzLn0ySbjA9oMNcHRlGWyYeCI8STH4fwBIerQuvXrVP+Whast+0MhDC1C2d1
grptpdwGXh7N3UF3F7Sk9PTReJN2fwH+4Hb3aYmXX2XUtbY3WdvuBnXwaUIpBsOK
R8E1dPwFPJGefcrttPnKo1Xflvftgumc1c+0zEzcEti+H9tNo7r06F+gB+JYNUD4
IMdT7lUf3s0Ug62jG5DbXb4tLiHX1k+33a6wV1RCF9IPXmgbayn3tkSNvF/GxRBY
MaIW+JPScJgcPtzYqMoEo7TVZ0hoJAMxkQdEHKfgk2X60EEFfgPm8hgohgbQ6+v5
JiKutL7wnFp7LZjLP84X2B+9QCtghe5Mpj42Veoh/fpGuTm7PDo=
=Tm5p
-----END PGP SIGNATURE-----
--=-=-=--
