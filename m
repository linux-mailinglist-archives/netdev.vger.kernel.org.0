Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D50287222
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbgJHKBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:01:05 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49544 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbgJHKBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 06:01:05 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602151262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YlY2PCfKX4Q4U4zU0hxRIXZu0KsMCr/9DHvRarIxCYM=;
        b=wWZg1kAtZPnnplaoh3ise45nwUu56ACbWLgD6xMkOlWZNsw/rXgs6aB2ZqbzryivxFmAOU
        uFy5Z/EhS1gCsS4QLFYGAS7aePu7QhMtmqco1xwhM+qnZqUdPiBRdsAbq83h/cyExE93x2
        Qinxz3M4eMj+24TfiQfI21SYrq0+d66cJfQGWopC6Ldt4rZh9cRMh941mRRk3uvusJ1wUv
        lLXubfJJ5srqLT+kYlC76jVKNBDdYNjxJ7M/HSyCcZrYHcMCNx8OjvNAMRLt7sVi9fYXXB
        xR07JobsFtOn8w5TG0jRcfiaIuMb5TBkONIg+FPCXRk9KrU+VI/tTG/7n1uBUw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602151262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YlY2PCfKX4Q4U4zU0hxRIXZu0KsMCr/9DHvRarIxCYM=;
        b=XfBri8WtKbFjqo1mFGHGfxvRZK+cmOp45NZIXGfM27wpQVPcI3ce+bnumUsbG/m9uMqGE0
        ejSmaD5zuES2LHAw==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for hardware timestamping
In-Reply-To: <20201008094440.oede2fucgpgcfx6a@skbuf>
References: <20201004143000.blb3uxq3kwr6zp3z@skbuf> <87imbn98dd.fsf@kurt> <20201006072847.pjygwwtgq72ghsiq@skbuf> <87tuv77a83.fsf@kurt> <20201006133222.74w3r2jwwhq5uop5@skbuf> <87r1qb790w.fsf@kurt> <20201006140102.6q7ep2w62jnilb22@skbuf> <87lfgiqpze.fsf@kurt> <20201007105458.gdbrwyzfjfaygjke@skbuf> <87362pjev0.fsf@kurt> <20201008094440.oede2fucgpgcfx6a@skbuf>
Date:   Thu, 08 Oct 2020 12:01:01 +0200
Message-ID: <87lfghhw9u.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Oct 08 2020, Vladimir Oltean wrote:
> On Thu, Oct 08, 2020 at 10:34:11AM +0200, Kurt Kanzenbach wrote:
>> On Wed Oct 07 2020, Vladimir Oltean wrote:
>> > On Wed, Oct 07, 2020 at 12:39:49PM +0200, Kurt Kanzenbach wrote:
>> >> For instance the hellcreek switch has actually three ptp hardware
>> >> clocks and the time stamping can be configured to use either one of
>> >> them.
>> >
>> > The sja1105 also has a corrected and an uncorrected PTP clock that can
>> > take timestamps. Initially I had thought I'd be going to spend some ti=
me
>> > figuring out multi-PHC support, but now I don't see any practical reas=
on
>> > to use the uncorrected PHC for anything.
>>=20
>> Just out of curiosity: How do you implement 802.1AS then? My
>> understanding is that the free-running clock has to be used for the
>
> Has to be? I couldn't find that wording in IEEE 802.1AS-2011.

It doesn't has to be, it *should* be. That's at least the outcome we had
after lots of discussions. Actually Kamil (on Cc) is the expert on this
topic.

>
>> calculation of the peer delays and such meaning there should be a way to
>> get access to both PHCs or having some form of cross timestamping
>> available.
>>=20
>> The hellcreek switch can take cross snapshots of all three ptp clocks in
>> hardware for that purpose.
>
> Well, at the end of the day, all the other TSN offloads (tc-taprio,
> tc-gate) will still have to use the synchronized PTP clock, so what
> we're doing is we're simply letting that clock be synchronized by
> ptp4l.

Yes, the synchronized clock is of course needed for the traffic
scheduling and so on. This is what we do here in this code as well. Only
the synchronized one is exported to user space and used. However, the
multi PHCs issue should be addressed as well at some point.

>
>> >> > So when you'll poll for TX timestamps, you'll receive a TX
>> >> > timestamp from the PHY and another one from the switch, and those w=
ill
>> >> > be in a race with one another, so you won't know which one is which.
>> >>=20
>> >> OK. So what happens if the driver will accept to disable hardware
>> >> timestamping? Is there anything else that needs to be implemented? Are
>> >> there (good) examples?
>> >
>> > It needs to not call skb_complete_tx_timestamp() and friends.
>> >
>> > For PHY timestamping, it also needs to invoke the correct methods for =
RX
>> > and for TX, where the PHY timestamping hooks will get called. I don't
>> > think that DSA is compatible yet with PHY timestamping, but it is
>> > probably a trivial modification.
>>=20
>> Hmm? If DSA doesn't support PHY timestamping how are other DSA drivers
>> dealing with it then? I'm getting really confused.
>
> They aren't dealing with it, of course.
>
>> Furthermore, there is no hellcreek hardware available with timestamping
>> capable PHYs. How am I supposed to even test this?
>>=20
>> For now, until there is hardware available, PHY timestamping is not
>> supported with the hellcreek switch.
>
> I was just pointing out that this is something you'll certainly have to
> change if somebody will want PHY timestamping.

Understood.

>
> Even without hardware, you _could_ probably test that DSA is doing the
> right thing by simply adding the PTP timestamping ops to a PHY driver
> that you own, and inject dummy timestamps. The expectation becomes that
> user space gets those dummy timestamps, and not the ones emitted by your
> switch.

Of course it can be mocked. Whenever somebody wants to do PHY
timestamping with a hellcreek switch this issue can be re-visited.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9+410ACgkQeSpbgcuY
8KZc4RAApMcJksbhvJ3h+InmLV0zBPwEhm+pi54GM6pcMgEU2pVU3p7V4u4sECeE
YtI3vANceVAYOeoFJKCV2mRQkZHNlUbUm6UoJ/cplRJk8d2bqNNBj1iRUfvdxN5M
i+tVJ6LQCSePZNhCkL3VFBCpe5J08qC1OrWFOFBLUcvFsaNpP7keIC0AxGd1Ls+h
ISIGrC0RP+dz2ehhAZmeKRI9ype6d2CzV34JtfR+cTlwLrHlndoBSF19f4YrfDbl
D/fjhAR/ubleveAlhFK4J0TgLz2eFP8c0YSYJ5ZCgxds3XFVxiGLz9Iki3Pv7J7b
6ZK+eroPmNEwcmapMHIDVMSZffVJ13OZdKr/lR/tVuo04U8xM+sEe8nnJAaNIFh2
n8hz3ptWfF+7WRpexasB4/FEtBz5HUqT06Bn6pwYz+fgYU0Biro4FGVON7zJVdI8
DJwD8lORPQbfIzhD+6em7bdtmokmZQj+DsBsN4a/k6NmFOro7HUee0/BpvAeG30X
/ZZXIbe+RISZdvMB0K5CPvo6LT1LPqhIDC/shm3g9FdsXtcXLQj97Rw6DQQfsRVq
Ofcs0pFyclS1j8QMqtN2cDH4AQcVbD3Fu5Snqq1ekXN0WTIg0wKxRevK8SS9uH3N
IKEYgHvWS67CgPRssQ/9vnSjA6B+D4agaNNQpTFnYRX9/rlaE9s=
=+53N
-----END PGP SIGNATURE-----
--=-=-=--
