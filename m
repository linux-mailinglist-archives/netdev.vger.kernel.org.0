Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FF0226249
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgGTOhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:37:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58224 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTOhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 10:37:50 -0400
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595255867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jI81a0NeYObY84iSzl0HjySkYIo3U1NTf0aiPAXTJLY=;
        b=wFikjtKjzDMDJBhzTSKG9CabkYgMyov4MWkW9GXoI+5qdY2jiuLeXtEmTHyvTQeGMA9/gR
        ktt65BTZpGH7b2rE/k+P1PsVuzkG4cO7vY8RdreK9LnQjDzcyLakh478/M3EYb+4Psh1E7
        tPV3QBw1xwZPq32JAAsM/41KoST+2HsvSe+Yx4AkwL840geufyIuWzUZJQPP/Gktf9lkzK
        oqwUmF3c8tSDPNGVAPDUTtDy7bweRDfU43VhuyeIeEGRH31NBHZV1IRa0fadwL0tMhkUOO
        o2MqACa238xRl8bxvk7IZP/KKjyfnj7ThyCAza0+UW/jOGdOqVCUTwWv05CnDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595255867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jI81a0NeYObY84iSzl0HjySkYIo3U1NTf0aiPAXTJLY=;
        b=umnKKjN22D6jQlrpxSQzEP1iWpAfGxcLQSwumlQg9sZwfRYRj3LBnsh5QEOr2Pygug0sBj
        anyI+BMKo12Xx8Cw==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
In-Reply-To: <20200720142146.GB16001@hoboy>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk> <20200716204832.GA1385@hoboy> <874kq6mva8.fsf@kurt> <20200718022446.GA4599@hoboy> <20200720142146.GB16001@hoboy>
Date:   Mon, 20 Jul 2020 16:37:46 +0200
Message-ID: <87ft9m9rr9.fsf@kurt>
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

On Mon Jul 20 2020, Richard Cochran wrote:
> On Fri, Jul 17, 2020 at 07:24:46PM -0700, Richard Cochran wrote:
>> On Fri, Jul 17, 2020 at 09:54:07AM +0200, Kurt Kanzenbach wrote:
>> > I'll post the next version of the hellcreek DSA driver probably next
>> > week. I can include a generic ptp_header() function if you like in that
>> > patch series. But, where to put it? ptp core or maybe ptp_classify?
>>=20
>> Either place is fine with me.  Maybe it makes most sense in ptp_classify?
>> Please put the re-factoring in a separate patches, before the new
>> driver.
>
> And maybe the new header parsing routine should provide a pointer to a
> structure with the message layout.  Something similar to this (from
> the linuxptp user stack) might work.
>
> struct ptp_header {
> 	uint8_t             tsmt; /* transportSpecific | messageType */
> 	uint8_t             ver;  /* reserved          | versionPTP  */
> 	UInteger16          messageLength;
> 	UInteger8           domainNumber;
> 	Octet               reserved1;
> 	Octet               flagField[2];
> 	Integer64           correction;
> 	UInteger32          reserved2;
> 	struct PortIdentity sourcePortIdentity;
> 	UInteger16          sequenceId;
> 	UInteger8           control;
> 	Integer8            logMessageInterval;
> } PACKED;

Yes, makes sense. It should work.

>
>
> Of course, the structure should use the kernel types that include the
> big endian annotations.

Sure.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8VrDoACgkQeSpbgcuY
8Ka5nRAAjlQgs+et9q9su3EYSYe8FNSq0CVjdYIqpWqzYFDzYmB4y0FAwwuzPfMb
cYyMkJFvcfMC7fz9VqKrGmjiD8FRz657mEBkkZkACWc44EIY3lwGOtAyU3GDj67i
HMtX1wX9s1UQUrtreEMkz5DNuiXaP1pYxjT0ZU9YvO2fYxUEzkdG4xfmm1ElcmSZ
hCzSDn/k/uVB5SLxs7hBcxZD/nsz1VvxoSoKsAcZTcJ9SB8LFNNxymUI795dh9fO
O2IvH7N44AyFTlPytgS276zr/gdcVXLuGfUvRBAONID7t0bnF6HAH8ZYt75BLfIq
y+kECuuOX1BQ06W/EGWbfHXWlUqqfIipQMb/jUrBUWaT6r78Zp0vDQQ3qwLHvcnK
vmDvNzSf6ifFTs5bo7VRoBzkcQVIRo3Twikftnk77qlqDJ/melA0wbQXlT4UWHkc
yQdS7zDnixHO2DA91bqSg8pn14NslvN7yL5HeCqT9FRqZplyUw6FPo1aC5tq0mK5
BNkoQ0a2kc82i8BZvz/lDWW+d/MnqY76JkU0e6jJKuOF6PmRghtzw1FX0hiazqkE
fP1bt3l9EDsLB3gboOkwdCIirRTFV81fK6yjCMUj9r8NsRTQZ31/2Fojg3M9BgKN
FtsIZ8Jv0G9nEBYfIZORcpU7tPP3R21407xUg8GBFNZCnEHvofs=
=yv6G
-----END PGP SIGNATURE-----
--=-=-=--
