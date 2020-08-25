Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C622515C7
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgHYJzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729456AbgHYJzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:55:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87148C061574;
        Tue, 25 Aug 2020 02:55:40 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598349339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5bdT5tTM+hEnX3GHDG3SgFYwTwZMX1yMI7aVVjqitqY=;
        b=az6XmRx0k5oLN1bIaAHyCdIuH590fxM3/uYM0egcx2w+6s56vftoivh4/DDL0y8tZaXGgB
        Xd/dMTYP4htDmj77ZYPKmtuulUTGZiW6ctR83KWrcYJVaEdwSun+H2/FFnQa+vUbFYjyiO
        3Cs6fxHY+4V3XDEUic1hESs9SRP8bkbUzGnMP1Fh2XCzeSUmfh7zbZX5wg04Bowsz2/unh
        FEizV4bgRM2CunF+cLppghCcpx9DmSprFsZZcFIAccCKIC8CnzMQmc2XbxV3bNxAHYbi8e
        Wb51G0XpY5WPkK+74sRRJlVPc96CK/PxFSH9s4N+IsDr4XGf7/UOdqHsDycnGQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598349339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5bdT5tTM+hEnX3GHDG3SgFYwTwZMX1yMI7aVVjqitqY=;
        b=p0+MO18mFNv6nUcGw/fOpqWL3EmCv1vx5i0JWx2mxD5NVODpZfbqICiy0wx/6EIRg2VsKJ
        sQOT40Z3aCsfvoCQ==
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
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <20200825093830.r2zlpowtmhgwm6rz@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <20200824225615.jtikfwyrxa7vxiq2@skbuf> <878se3133y.fsf@kurt> <20200825093830.r2zlpowtmhgwm6rz@skbuf>
Date:   Tue, 25 Aug 2020 11:55:37 +0200
Message-ID: <871rjv123q.fsf@kurt>
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

On Tue Aug 25 2020, Vladimir Oltean wrote:
> On Tue, Aug 25, 2020 at 11:33:53AM +0200, Kurt Kanzenbach wrote:
>> On Tue Aug 25 2020, Vladimir Oltean wrote:
>> > On Thu, Aug 20, 2020 at 10:11:15AM +0200, Kurt Kanzenbach wrote:
>> >
>> > Explain again how this works, please? The hrtimer measures the CLOCK_T=
AI
>> > of the CPU, but you are offloading the CLOCK_TAI domain of the NIC? So
>> > you are assuming that the CPU and the NIC PHC are synchronized? What if
>> > they aren't?
>>=20
>> Yes, I assume that's synchronized with e.g. phc2sys.
>>=20
>
> My intuition tells me that this isn't the user's expectation, and that
> it should do the right thing even if it's not synchronized to the system
> clock.

I get your point. But how to do it? We would need a timer based on the
PTP clock in the switch.

>
>> >
>> > And what if the base-time is in the past, do you deal with that (how
>> > does the hardware deal with a base-time in the past)?
>> > A base-time in the past (example: 0) should work: you should advance t=
he
>> > base-time into the nearest future multiple of the cycle-time, to at
>> > least preserve phase correctness of the schedule.
>>=20
>> If the hrtimer is programmed with a value in the past, it fires
>> instantly.
>
> Yes, it does.
>
>> The callback is executed and the start time is programmed.
>>=20
>
> With a valid value from the hardware's perspective?

Yes. That's no problem.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9E4BkACgkQeSpbgcuY
8KYTLA//czMWI4/CjiYlrGZSJO5Yo+04S6/y8xANPp50A8kGblNt3YuN5etwykHx
7xPPR6FdlU/U1FNTbi6FMgi5ryJjE6aktcpnCjkHPL63epMnx2pbt4JMRMNInaYv
u91chzZcsyMJRb3FTu5SMZVC06aPh7zPgxSIey9+D/Yn7xjtvXKu511mPooPCPC3
vR5+++wa3sOassjabinJRr2Vjsg+6nzGULd0GCQ3L8gnURN3bB/a4McV0xBWpUpi
IM256G0NWkRs0NXNX8R9B/Tn7ykeacgErRuLtuL/qXOktI+awR9PStS0O5JI8xnC
0FodtVyKhPhdTxTiaeNf8tHlyWsxUy812G5uJXWxCSdZrSoRjzCq5oVOmjvxaP5Z
s/ws+WWOufaDb4eN8QbqHvmTfqMDi7uhUFpEHnuHoBTOaXY0hzLHNKx1n6S/fHMK
x7kWkgoJ4Xu0xvuOGgVRuZcq5VpG5XaF7Hxzyn4tgT1XXXAyyIbIzvaLZSGOslBc
yOUmoYPeru2J91Ssh5GLy8nuPadYaQjsynOy+/i7RDDS+yhOuSgt8jBBcHMX3RBX
YrCGJZY5blnm5YT4Kk+f68p5njinzU9wbCoOuFQe+KX8rDhQJ05GQeVHGSAZOlpV
nQ+sH4raun37QhMM+s5pe1W8glnBdOFV5M62VMFuHdLRart4DAA=
=G86F
-----END PGP SIGNATURE-----
--=-=-=--
