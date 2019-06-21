Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 469374E7FD
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 14:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfFUMam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 08:30:42 -0400
Received: from [195.159.176.226] ([195.159.176.226]:42234 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfFUMam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 08:30:42 -0400
Received: from list by blaine.gmane.org with local (Exim 4.89)
        (envelope-from <gl-netdev-2@m.gmane.org>)
        id 1heIgh-000mL3-4X
        for netdev@vger.kernel.org; Fri, 21 Jun 2019 14:30:39 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: bonded active-backup ethernet-wifi drops packets
Date:   Fri, 21 Jun 2019 08:30:28 -0400
Message-ID: <30bdcc940d2bdafb7b8f5609207a4bf642fcf9a5.camel@interlinx.bc.ca>
References: <0292e9eefb12f1b1e493f5af8ab78fa00744ed20.camel@interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-O+Zeijg6TAgQM+Wtrfm6"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
In-Reply-To: <0292e9eefb12f1b1e493f5af8ab78fa00744ed20.camel@interlinx.bc.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-O+Zeijg6TAgQM+Wtrfm6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-06-18 at 14:57 -0400, Brian J. Murrell wrote:
> Hi.

An update...

I have another machine with the same ethernet-wifi bonded connection
and it behaves perfectly but only when disconnected from the wired-
ethernet and therefore on the bonded-wifi.  The ping -f occasionally
bursts out a few '.'s but it quickly catches up and removes them (i.e.
very momentary delay -- to be expected for wifi I suppose).

But when I do plug it into wired, it drops packets like the other
machine.  Which is really odd.  I'd think wired should be much more
reliable than wifi.

So why does this machine behave (but only on wifi) and the other one
doesn't.  To compare them...

> I have an active-backup bonded connection on a 5.1.6 kernel

Working machine has a 5.0.16 kernel.

> My bonding config:
>=20
> $ cat /proc/net/bonding/bond0
> Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
>=20
> Bonding Mode: fault-tolerance (active-backup)
> Primary Slave: enp0s31f6 (primary_reselect always)
> Currently Active Slave: enp0s31f6
> MII Status: up
> MII Polling Interval (ms): 100
> Up Delay (ms): 0
> Down Delay (ms): 0
>=20
> Slave Interface: enp0s31f6
> MII Status: up
> Speed: 1000 Mbps
> Duplex: full
> Link Failure Count: 0
> Permanent HW addr: 0c:54:15:4a:b2:0d
> Slave queue ID: 0
>=20
> Slave Interface: wlp2s0
> MII Status: up
> Speed: Unknown
> Duplex: Unknown
> Link Failure Count: 1
> Permanent HW addr: 0c:54:15:4a:b2:0d
> Slave queue ID: 0

Working machine:

$ cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: fault-tolerance (active-backup)
Primary Slave: enp0s25 (primary_reselect always)
Currently Active Slave: enp0s25
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

Slave Interface: wlp3s0
MII Status: up
Speed: Unknown
Duplex: Unknown
Link Failure Count: 1
Permanent HW addr: 00:24:d7:7b:1f:24
Slave queue ID: 0

Slave Interface: enp0s25
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 00:24:d7:7b:1f:24
Slave queue ID: 0

> Current interface config/stats:
>=20
> $ ifconfig bond0
> bond0: flags=3D5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500
>         inet 10.75.22.245  netmask 255.255.255.0  broadcast
> 10.75.22.255
>         inet6 fe80::ee66:b8c9:d55:a28f  prefixlen 64  scopeid
> 0x20<link>
>         inet6 2001:123:ab:123:d36d:5e5d:acc8:e9bc  prefixlen
> 64  scopeid 0x0<global>
>         ether 0c:54:15:4a:b2:0d  txqueuelen 1000  (Ethernet)
>         RX packets 1596206  bytes 165221404 (157.5 MiB)
>         RX errors 0  dropped 0  overruns 0  frame 0
>         TX packets 1590552  bytes 162689350 (155.1 MiB)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

Working machine:

$ ifconfig bond0
bond0: flags=3D5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500
        inet 10.75.22.130  netmask 255.255.255.0  broadcast 10.75.22.255
        inet6 2001:470:1d:6f8:b12f:e840:c6a9:8480  prefixlen 64  scopeid 0x=
0<global>
        inet6 fd31:aeb1:48df:0:2374:a2d1:e1b7:89a3  prefixlen 64  scopeid 0=
x0<global>
        inet6 fe80::3dac:5dd4:3c21:421b  prefixlen 64  scopeid 0x20<link>
        ether 00:24:d7:7b:1f:24  txqueuelen 1000  (Ethernet)
        RX packets 40416877  bytes 10615841459 (9.8 GiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 9040319  bytes 1493391347 (1.3 GiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

> Devices:
> 00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection
> (2) I219-LM (rev 31)
> 02:00.0 Network controller: Intel Corporation Wireless 8265 / 8275
> (rev 78)

Working machine:

00:19.0 Ethernet controller: Intel Corporation 82577LM Gigabit Network Conn=
ection (rev 06)
03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev=
 35)

The only real difference I can see is hardware and kernel version.  Or
was there something I missed?

Cheers,
b.


--=-O+Zeijg6TAgQM+Wtrfm6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEE8B/A+mOVz5cTNBuZ2sHQNBbLyKAFAl0MzeUACgkQ2sHQNBbL
yKC75wf7Buc7NuEa9FiSr4zNCNBwk2Cx/WnZ+KsTfwSrgn7P/Q6P/26iM5r/DD0x
mxBB3XCVVRwrD1bziD/Q/4B7GmHbn53xrgSie1t8dUqAQ5KRcRiTh5nM1p2OsFfy
xM6wlzn8y9Jhv4c2d97XhWOE/a+NvFlbvwsIIKX4UJiDwXiH/77lUfOqpMMwrd/k
CF0so8TNPfb3nCg3ozpAqJAkRKki0qcRevvqFIT7CMqyptzEkD4qbne1VJM2Sii2
WV9ExFM8lVKMFgwUQt1cESBWEABmnq3/adTol9dZbUp5UuDfUJBSjTkPxlXt5ZGB
Ku8kWVLOT4H+LDctPku8nThYxgP77A==
=LWrj
-----END PGP SIGNATURE-----

--=-O+Zeijg6TAgQM+Wtrfm6--


