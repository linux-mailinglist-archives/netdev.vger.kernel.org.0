Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBE82AA84A
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 23:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgKGWeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 17:34:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727871AbgKGWeT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 17:34:19 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70D242087E;
        Sat,  7 Nov 2020 22:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604788458;
        bh=A3y1VdU9V2CMGIbICldyKqFc6cl6/s1Y3Us+vWT/bYg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q6I5H7csoxjMobxUf2XwhUIzFmS5DO3SAw9Nf4OOdL7DoT5MgRb3mOvtiaIuu3lpN
         IAzqYl3khqyBHrrhCI+tm2Ww8szvzlkarFKJm6noE1j3TFe/TPp6CiqkX3Qcc+iYN0
         mgTAH5xiT3FymkToc0PxgOShZdVWNtwFKuE6n8ew=
Date:   Sat, 7 Nov 2020 14:34:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Motiejus =?UTF-8?B?SmFrxaF0eXM=?= <desired.mta@gmail.com>
Cc:     netdev@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Documentation: tproxy: more gentle intro (re-post #2)
Message-ID: <20201107143417.7bfefd47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201105102602.109991-1-desired.mta@gmail.com>
References: <20201105102602.109991-1-desired.mta@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Nov 2020 12:26:04 +0200 Motiejus Jak=C5=A1tys wrote:
> Clarify tproxy odcumentation, so it's easier to read/understand without
> a-priori in-kernel transparent proxying knowledge.
>=20
> Remove a reference to linux 2.2 and cosmetic Sphinx changes and address
> comments from kuba@.
>=20
> Sorry for re-posting, I realized I left a gap just after sending.
>=20
> Signed-off-by: Motiejus Jak=C5=A1tys <desired.mta@gmail.com>

> diff --git a/Documentation/networking/tproxy.rst b/Documentation/networki=
ng/tproxy.rst
> index 00dc3a1a66b4..d2673de0e408 100644
> --- a/Documentation/networking/tproxy.rst
> +++ b/Documentation/networking/tproxy.rst
> @@ -1,42 +1,45 @@
>  .. SPDX-License-Identifier: GPL-2.0
> =20
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> -Transparent proxy support
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +Transparent proxy (TPROXY)
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> =20
> -This feature adds Linux 2.2-like transparent proxy support to current ke=
rnels.
> -To use it, enable the socket match and the TPROXY target in your kernel =
config.
> -You will need policy routing too, so be sure to enable that as well.
> +TPROXY enables forwarding and intercepting packets that were destined fo=
r other

I would not say forwarding

> +endpoints, without using NAT chain or REDIRECT targets.

"without using NAT or the REDIRECT target"

> -From Linux 4.18 transparent proxy support is also available in nf_tables.
> +Intercepting non-local packets
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> =20
> -1. Making non-local sockets work
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +To identify packets with destination address matching a local socket on =
your

> -Because of certain restrictions in the IPv4 routing output code you'll h=
ave to
> -modify your application to allow it to send datagrams _from_ non-local IP
> -addresses. All you have to do is enable the (SOL_IP, IP_TRANSPARENT) soc=
ket
> -option before calling bind::
> +.. code-block:: sh
> +
> +    ip rule add fwmark 1 lookup 100
> +    ip route add local 0.0.0.0/0 dev lo table 100
> +
> +Because of certain restrictions in the IPv4 routing application will nee=
d to be
> +modified to allow it to send datagrams *from* non-local IP addresses. En=
able

"modified to enable sending datagrams" ... "Set"

> +the ``SOL_IP``, ``IP_TRANSPARENT`` socket options before calling ``bind`=
`:
> +
> +.. code-block:: c
> =20
>      fd =3D socket(AF_INET, SOCK_STREAM, 0);
>      /* - 8< -*/
> @@ -51,9 +54,22 @@ option before calling bind::
>  A trivial patch for netcat is available here:
>  http://people.netfilter.org/hidden/tproxy/netcat-ip_transparent-support.=
patch
> =20
> +Kernel configuration
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> -2. Redirecting traffic
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +To use tproxy you'll need to have the following modules compiled for ipt=
ables:
> +
> +- ``NETFILTER_XT_MATCH_POLICY``

That's not the config option for policy routing.

> +- ``NETFILTER_XT_MATCH_SOCKET``
> +- ``NETFILTER_XT_TARGET_TPROXY``

