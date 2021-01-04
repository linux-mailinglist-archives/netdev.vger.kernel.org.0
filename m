Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EE12E9F76
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbhADVUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbhADVUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:20:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66F7421919;
        Mon,  4 Jan 2021 21:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609795196;
        bh=E7g2U+SvOmE1Xw5CMic8FCeXkufHPLDtW4XNdpKvxvM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ry6zT4PVSKjhC0GhVl9JkFTWwDVA4CFPTW4DzBiJFLKbVqXiuKIUGYe3Rq/O1drpl
         EPQb90QsdrlfLy4sGxkxol0wN4qVE3WvkU6LNrvbs7QQftDwLguZE9tTk44TNH5pJs
         kXiwEQjfwE+CiAoDGTjCcL7hbnCJFGGFRyxM6q+unzA73TIbzYIIM7DcuDRsvMdNEZ
         YFhKzAAxcs1B3gBa1lEveHV4tXSi8j7+JQGc6uf3a1djoDn1YiUFK7kmS2OlNSRB7B
         aU6VCEhdOkY6X3YADzC4TItFeZL/jjEBHP02DmGnACyZzPVzoYzOuSWM8iZAUF6sNt
         AmLuZ6TvW8LWg==
Date:   Mon, 4 Jan 2021 21:19:30 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>, lee.jones@linaro.org
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20210104211930.GI5645@sirena.org.uk>
References: <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com>
 <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com>
 <20201218180310.GD5333@sirena.org.uk>
 <20201218184150.GY552508@nvidia.com>
 <20201218203211.GE5333@sirena.org.uk>
 <20201218205856.GZ552508@nvidia.com>
 <20201221185140.GD4521@sirena.org.uk>
 <20210104180831.GD552508@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="l0l+eSofNeLXHSnY"
Content-Disposition: inline
In-Reply-To: <20210104180831.GD552508@nvidia.com>
X-Cookie: Stupidity is its own reward.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l0l+eSofNeLXHSnY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 04, 2021 at 02:08:31PM -0400, Jason Gunthorpe wrote:
> On Mon, Dec 21, 2020 at 06:51:40PM +0000, Mark Brown wrote:

> > BTW I did have a bit of a scan through some of the ACPI devices and
> > for a good proportion of them it seems fairly clear that they are
> > not platform devices at all - they were mostly interacting with ACPI
> > firmware functionality rather than hardware, something you can't
> > really do with FDT at all.

> Right, that is kind of the point. We also have cases where ACPI
> devices are just an ioresource list and don't have any special
> ACPIness. IIRC DT has a similar issue where there are DT drivers that
> just don't work without the OF stuff. Why are they platform drivers?

There *might* be some very legacy ones for actual OF systems but that's
not really at all a thing for FDT which is essentially all DT usage at
this point - to the extent that things won't work it's due to the
non-enumarability of the hardware so it's just a question of where the
data comes from rather than one of communicating with a firmware (and
for more generic things like GPIOs exactly where the data comes from
ends up abstracted away from the driver anyway which is all some devices
need).  The idiom with DT is more that it's just a different way of
filling out the data you'd get from a board file, it's not a runtime
thing like ACPI.

> We fake this idea out by being able to convert platform to DT and OF,
> but if platform is to be the universal device then why do we have PCI
> device and not a 'platform to pci' operator instead? None of this is
> consistent.

If it were more common for there to be IPs that appear as both PCI and
platform devices (Intel do it a bit but otherwise it's quite rare) I'd
guess we would actually have helpers for that translation.

> Regardless of the shortcut to make everything a struct
> platform_device, I think it was a mistake to put OF devices on
> platform_bus. Those should have remained on some of_bus even if they

Like I keep saying the same thing applies to all non-enumerable buses -
exactly the same considerations exist for all the other buses like I2C
(including the ACPI naming issue you mention below), and for that matter
with enumerable buses which can have firmware info.

> are represented by struct platform_device and fiddling in the core
> done to make that work OK.

What exactly is the fiddling in the core here, I'm a bit unclear?

> I agree with this, IMHO there is no really cohesive explanation for
> when to create a bus vs use the "universal bus" (platform) that can
> also explain the things platform is already doing.

> This feels like a good conference topic someday..

We should have this discussion *before* we get too far along with trying
to implement things, we should at least have some idea where we want to
head there.

> > Personally I'm even struggling to identify a practical problem that
> > we're trying to solve here.  Like Alexandre says what would an
> > mfd_driver actually buy us?

> Well, there is the minor issue of name collision eg
> /sys/bus/XX/devices/* must list all devices in the system with no
> collisions.

> The owner of the bus is supposed to define the stable naming scheme
> and all the devices are supposed to follow it. platform doesn't have
> this:

> $ ls /sys/bus/platform/devices/
>  ACPI000C:00	     dell-smbios.0	'Fixed MDIO bus.0'   INT33A1:00         m=
icrocode     PNP0C04:00   PNP0C0B:03   PNP0C14:00
>  alarmtimer.0.auto   dell-smbios.1	 GHES.0		     intel_rapl_msr.0   MSFT0=
101:00   PNP0C0B:00   PNP0C0B:04   PNP0C14:01
>  coretemp.0	     efi-framebuffer.0	 GHES.1		     iTCO_wdt	        pcspkr	=
      PNP0C0B:01   PNP0C0C:00   reg-dummy
>  dcdbas		     eisa.0		 INT0800:00	     kgdboc	        PNP0103:00    PNP0C=
0B:02   PNP0C0E:00   serial8250

> Why are ACPI names in here? It looks like "because platform drivers
> were used to bind to ACPI devices"=20

I think we decided that the ACPI namespace was sufficiently divergent
=66rom our general conventions that we could just safely use the string,
ICBW though.

> > I have some bad news for you about the hardware description problem
> > space.  Among other things we have a bunch of platform devices that
> > don't have any resources exposed through the resource API but are still
> > things like chips on a board, doing some combination of exposing
> > resources for other devices (eg, a fixed voltage regulator) and
> > consuming things like clocks or GPIOs that don't appear in the resource
> > API.

> So in these cases how do I use the generic platform bus API to find
> the GPIOs, regulators, and so on to connect with?

> If drivers take a platform device and immediately covert it to an OF
> object and use OF APIs to find those connections then it really
> *never* was a platform device in the first place and coding an OF
> driver as platform is an abuse.

Those APIs all take a struct device for lookup so it's the same call for
looking things up regardless of the bus the device is on or what
firmware the system is using - where there are firmware specific lookup
functions they're generally historical and shouldn't be used for new
code.  It's generally something in the form

	api_type *api_get(struct device *dev, const char *name);

with the strings being defined according to something in the hardware
spec so there's a good chance of them working generically (and
realistically it's only DT that's actually putting these names in
firmware, otherwise it's just board files that we totally control, so
this really is fine).

> A decent step would be to accept that 'platform_device' is something
> weird and special and split its bus_type. Only devices created
> direclty in C code should be on the platform_bus, OF/ACPI/etc should
> all be on their own bus_types, even though they all use the same
> 'struct platform_bus'

=2E..and then do the same thing for every other bus with firmware
bindings.  If it's about the firmware interfaces it really isn't a
platform bus specific thing.  It's not clear to me if that's what it is
though or if this is just some tangent.

> > that but it is not clear what the upside of doing that would be,
> > especially given the amount of upheval it would generate and the
> > classification issues that will inevitably result.

> Well, I think the upside for existing is very small, but I would like
> to see a shared idea about how to answer questions like 'when should I
> use a existing device type' and 'when should I make a new device type'.

Yes, very much so.

--l0l+eSofNeLXHSnY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/zhmEACgkQJNaLcl1U
h9CC1Af/W6qT0dhp0UsFJwoF36YD6R1ez1NBi/iFRJs6c2jlc19nvoyzAwQSbuk4
bO4YCjRfXM4GlFVailFSw+eJMJv1U6D00AdrYKZRUeO+S91I4rI5ID/37M8WWY5C
W5uusTAYNn/TTsrrWdT8QqOEjGjLZv9mDYJaTpauZhwbnjVovZkC0JZUAUfpQAYN
WOyGecFCclyk8JIY4EU0GzihaaJC7PD0kdc7lqV52i4kIkTRCWHlWdULcwTrz9C0
UyMa7I8k8lbRXbKp7J7jrYz2Ug9/QiIhfsV27Ytgl0/DvhEdL+WilU4hnKmZ2ums
z4DU3MTubqoDXkZ+nCT3UJ4xVgU/uQ==
=tjQX
-----END PGP SIGNATURE-----

--l0l+eSofNeLXHSnY--
