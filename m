Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1B3295D56
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 13:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897224AbgJVLZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 07:25:46 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44806 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897214AbgJVLZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 07:25:45 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1C1561C0B78; Thu, 22 Oct 2020 13:25:41 +0200 (CEST)
Date:   Thu, 22 Oct 2020 13:25:40 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>,
        Drew Fustini <pdp7pdp7@gmail.com>
Subject: Re: [PATCH v6 6/6] docs: ctucanfd: CTU CAN FD open-source IP core
 documentation.
Message-ID: <20201022112540.GB30566@duo.ucw.cz>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz>
 <213155c64da5a97c574cd15de1cb06f8d0acef6a.1603354744.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <213155c64da5a97c574cd15de1cb06f8d0acef6a.1603354744.git.pisa@cmp.felk.cvut.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-10-22 10:36:21, Pavel Pisa wrote:
> CTU CAN FD IP core documentation based on Martin Je=C5=99=C3=A1bek's dipl=
oma theses
> Open-source and Open-hardware CAN FD Protocol Support
> https://dspace.cvut.cz/handle/10467/80366
> .

> ---
>  .../ctu/FSM_TXT_Buffer_user.png               | Bin 0 -> 174807 bytes

Maybe picture should stay on website, somewhere. It is rather big for
kernel sources.

> +About SocketCAN
> +---------------
> +
> +SocketCAN is a standard common interface for CAN devices in the Linux
> +kernel. As the name suggests, the bus is accessed via sockets, similarly
> +to common network devices. The reasoning behind this is in depth
> +described in `Linux SocketCAN <https://git.kernel.org/cgit/linux/kernel/=
git/torvalds/linux.git/tree/Documentation/networking/can.rst>`_.
> +In short, it offers a
> +natural way to implement and work with higher layer protocols over CAN,
> +in the same way as, e.g., UDP/IP over Ethernet.

Drop? Or at least link directly to the file in kernel tree?

> +Device probe
> +~~~~~~~~~~~~
> +
> +Before going into detail about the structure of a CAN bus device driver,
> +let's reiterate how the kernel gets to know about the device at all.
> +Some buses, like PCI or PCIe, support device enumeration. That is, when
> +the system boots, it discovers all the devices on the bus and reads
> +their configuration. The kernel identifies the device via its vendor ID
> +and device ID, and if there is a driver registered for this identifier
> +combination, its probe method is invoked to populate the driver's
> +instance for the given hardware. A similar situation goes with USB, only
> +it allows for device hot-plug.
> +
> +The situation is different for peripherals which are directly embedded
> +in the SoC and connected to an internal system bus (AXI, APB, Avalon,
> +and others). These buses do not support enumeration, and thus the kernel
> +has to learn about the devices from elsewhere. This is exactly what the
> +Device Tree was made for.

Dunno. Is it suitable? This is supposed to be ctu-can documentation,
not "how hardware works" docs.

> +Platform device driver
> +^^^^^^^^^^^^^^^^^^^^^^
> +
> +In the case of Zynq, the core is connected via the AXI system bus, which
> +does not have enumeration support, and the device must be specified in
> +Device Tree. This kind of devices is called *platform device* in the
> +kernel and is handled by a *platform device driver*\  [1]_.
> +
> +A platform device driver provides the following things:
> +
> +-  A *probe* function
> +
> +-  A *remove* function
> +
> +-  A table of *compatible* devices that the driver can handle
> +
> +The *probe* function is called exactly once when the device appears (or
> +the driver is loaded, whichever happens later). If there are more
> +devices handled by the same driver, the *probe* function is called for
> +each one of them. Its role is to allocate and initialize resources
> +required for handling the device, as well as set up low-level functions
> +for the platform-independent layer, e.g., *read_reg* and *write_reg*.
> +After that, the driver registers the device to a higher layer, in our
> +case as a *network device*.
> +
> +The *remove* function is called when the device disappears, or the
> +driver is about to be unloaded. It serves to free the resources
> +allocated in *probe* and to unregister the device from higher layers.
> +
> +Finally, the table of *compatible* devices states which devices the
> +driver can handle. The Device Tree entry ``compatible`` is matched
> +against the tables of all *platform drivers*.

And this is "how to write a kernel driver" documentation. Like, why
not, but maybe it does not need to be in kernel tree, and certainly
should be separate from real "what is ctucan and how to use it" docs.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX5FsNAAKCRAw5/Bqldv6
8jKBAKCmizHIJCj3VPyqOohSfi3GtrmUCACfcxb6hpq3N7kbuJ2u8CONZ1K74u4=
=+fFG
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
