Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E21259033
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgIAOUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgIAOUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:20:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A94FC06124F;
        Tue,  1 Sep 2020 07:20:03 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598970001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EzXhOWsJJTl/hJbRWWE+RCFJeBmDtvEQ/oNbCJfaYgg=;
        b=yDZNSAQRfYKaEpdbWiHiaX86IocigSeiu8kS4ExpJ5txpDEwrzW0CTfYTGw66V5PBIkYH4
        wnU1+hBn/29UBtyjFtKu78vfcnjUqu9X4RMiSohSI2FTXLGWzkMV3z1zJ3LlKI/zJr05ii
        UHQqsOGI0zIMpHomno679XZOM7Okk85tkSMpDSe88HZByrvt0kfOp2YCH1wTBAczvvB/tc
        DEdsw+6C2FuUOC4NHdKZxnZlak7J+QhgY2Ugq7Hs8ynrCQVCa1ES8HgPwrlNXFWT1hEuyy
        /pAsDgzT3mPP0EYrOfkT9Zot1SK+8NiAyaEx2bSeDqg0aIWCnkao0A35TLVQig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598970001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EzXhOWsJJTl/hJbRWWE+RCFJeBmDtvEQ/oNbCJfaYgg=;
        b=gjV3avv5uMXe0coacwOWCMRjx4JBuXbLT8wkr0D7CcBNdNfdgCudYPlg90miinYvPeDJAc
        J5ld9ixg0gjf0DBA==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
In-Reply-To: <20200825093219.bybzzpyfbbccjanf@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <87pn7ftx6b.fsf@intel.com> <87bliz13kj.fsf@kurt> <20200825093219.bybzzpyfbbccjanf@skbuf>
Date:   Tue, 01 Sep 2020 16:20:00 +0200
Message-ID: <87v9gxefzj.fsf@kurt>
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
> On Tue, Aug 25, 2020 at 11:23:56AM +0200, Kurt Kanzenbach wrote:
>> On Mon Aug 24 2020, Vinicius Costa Gomes wrote:
>> > Hi,
>> >
>> > Kurt Kanzenbach <kurt@linutronix.de> writes:
>> >
>> [snip]
>> >> +	/* Setup timer for schedule switch: The IP core only allows to set a
>> >> +	 * cycle start timer 8 seconds in the future. This is why we setup =
the
>> >> +	 * hritmer to base_time - 5 seconds. Then, we have enough time to
>> >> +	 * activate IP core's EST timer.
>> >> +	 */
>> >> +	start =3D ktime_sub_ns(schedule->base_time, (u64)5 * NSEC_PER_SEC);
>> >> +	hrtimer_start_range_ns(&hellcreek_port->cycle_start_timer, start,
>> >> +			       NSEC_PER_SEC, HRTIMER_MODE_ABS);
>> >
>> > If we are talking about seconds here, I don't think you need to use a
>> > hrtimer, you could use a workqueue/delayed_work. Should make things a
>> > bit simpler.
>>=20
>> I've used hrtimers for one reason: The hrtimer provides a way to fire at
>> an absolute base time based on CLOCK_TAI. All the other facilities such
>> as workqueues, timer list timers, etc do not.
>
> That still doesn't justify the complexity of irqsave spinlocks and such.
> You could just as well schedule a workqueue from that hrtimer and have
> process context...

After giving this a bit more thought, it can be implemented by using
workqueues only. That ptp time is "cached" anyway the we could just
periodically check for the base time arrival. That should solve the
irqsave and the being synchronized problem.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9OWJAACgkQeSpbgcuY
8KYTTxAAzDMvQIXyzghTI8d0w/3qvioIEiOO/t/UGnf6PH6kR/aKxYsX82XZ8ahG
knDrsGE62KZm5oAgeeJhBLfxJc2cLbbs809g2zu/7SYeE1ONiJ5cEOmto/dGaB+R
NDLbipZV8SwbiSdXqnCjtjYccjGkmEwcg3fTIHO7oYCT7+x4g0tsjex2x/J0btBH
X0lUI2ON1aMQP75pDEpXA2ELnrpIAq3DVLWQWlh558H7KPpLdIkPSwOSpz7rPOhR
dWfclVDH3cZDaodbvbw2n/84O6iDBRdvr4XYmI0i407Xop0gCr8n8Db7oO4GXg3l
pHrxlFuPCkFwfBooQRzRc79DGdRQLOOt8S0i6h3tVe4puVc4Ytnvm4yvkv9KTXrj
F5NMrb4HVGKZVOcUAbWvRSzPedQ7Zygvu7F1BPUgEJBUyOLkuNhr4EVVRNtkTWWP
l73RXFkAMB/eySXeOI7nWmMuWXidC23TfWIeksgFLxmY/w0Q7u1vR4AL2ErkSsX9
vjC32uCKSXrSG06z866c13cGtFYwUnvJQ95ONNR9Um0iK1d64SbPp6RCvyzwkI7Q
9uNKVPQSeAFhw6Qynw4cWEH2lsB/Wgsom9Ce7YlARRxQnj+7vKyFoNxHxKos4wNM
rWQtjUHDQZmmhJ9nL0RoDVpmiEvAsixM2rQ0Z2/tjxPEbJJAvi4=
=VIAt
-----END PGP SIGNATURE-----
--=-=-=--
