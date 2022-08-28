Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5015A3CAF
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 10:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiH1Ift (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 04:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbiH1Ifq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 04:35:46 -0400
Received: from polaris.svanheule.net (polaris.svanheule.net [84.16.241.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A650926110
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 01:35:43 -0700 (PDT)
Received: from [IPv6:2a02:a03f:eaf9:8401:aa9f:5d01:1b2a:e3cd] (unknown [IPv6:2a02:a03f:eaf9:8401:aa9f:5d01:1b2a:e3cd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sander@svanheule.net)
        by polaris.svanheule.net (Postfix) with ESMTPSA id 7349E312E19;
        Sun, 28 Aug 2022 10:35:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svanheule.net;
        s=mail1707; t=1661675741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=91RPWC9lm6EmFuQ06ZRCxMuapFeAPU+WUb0848c6UKs=;
        b=U/C4UbQcYApgt+xf4P5Vn1i9sqY1swonzE8zi8zhwtMptRuAZEa3uFxAACWVDET3lxJdKR
        /zOLMPq4faG69lpJVdGTQn9vxYXRHu+8QQUMR6wBMFe/FTzJSWpuHiV6RKrfL90N181+oU
        srMWGmn6v40AAzpHdCnpkXdkAc90Po16q7QSrUyeD3tNnQ1tHdccuNb7L31i7FGBvj3p98
        DBY46U/Xq7BgYeN2GtWCMTNpi3fwAfp+DHgNXQy3gCf3IhfH1/4SqMItR/YDhhD48MCF/z
        6pQ37B4fno6+Q1PMwQLK6j7+rHTc3r6BNVgMW87z8mCHyuDo0m/Ieg/VHj0uAw==
Message-ID: <15255a7223fe405808bcedb5ab19bf2108637e08.camel@svanheule.net>
Subject: Re: [PATCH v3 1/9] cpumask: Make cpumask_full() check for
 nr_cpu_ids bits
From:   Sander Vanheule <sander@svanheule.net>
To:     Yury Norov <yury.norov@gmail.com>,
        Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Date:   Sun, 28 Aug 2022 10:35:38 +0200
In-Reply-To: <YwfgQmtbr6IrPrXb@yury-laptop>
References: <20220825181210.284283-1-vschneid@redhat.com>
         <20220825181210.284283-2-vschneid@redhat.com>
         <YwfgQmtbr6IrPrXb@yury-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yury, Valentin,

On Thu, 2022-08-25 at 13:49 -0700, Yury Norov wrote:
> + Sander Vanheule
>=20
> On Thu, Aug 25, 2022 at 07:12:02PM +0100, Valentin Schneider wrote:
> > Consider a system with 4 CPUs and:
> > =C2=A0 CONFIG_NR_CPUS=3D64
> > =C2=A0 CONFIG_CPUMASK_OFFSTACK=3Dn
> >=20
> > In this situation, we have:
> > =C2=A0 nr_cpumask_bits =3D=3D NR_CPUS =3D=3D 64
> > =C2=A0 nr_cpu_ids =3D 4
> >=20
> > Per smp.c::setup_nr_cpu_ids(), nr_cpu_ids <=3D NR_CPUS, so we want
> > cpumask_full() to check for nr_cpu_ids bits set.
> >=20
> > This issue is currently pointed out by the cpumask KUnit tests:
> >=20
> > =C2=A0 [=C2=A0=C2=A0 14.072028]=C2=A0=C2=A0=C2=A0=C2=A0 # test_cpumask_=
weight: EXPECTATION FAILED at
> > lib/test_cpumask.c:57
> > =C2=A0 [=C2=A0=C2=A0 14.072028]=C2=A0=C2=A0=C2=A0=C2=A0 Expected cpumas=
k_full(((const struct cpumask
> > *)&__cpu_possible_mask)) to be true, but is false
> > =C2=A0 [=C2=A0=C2=A0 14.079333]=C2=A0=C2=A0=C2=A0=C2=A0 not ok 1 - test=
_cpumask_weight
> >=20
> > Signed-off-by: Valentin Schneider <vschneid@redhat.com>
>=20
> It's really a puzzle, and some of my thoughts are below. So.=20
>=20
> This is a question what for we need nr_cpumask_bits while we already
> have nr_cpu_ids. When OFFSTACK is ON, they are obviously the same.
> When it's of - the nr_cpumask_bits is an alias to NR_CPUS.
>=20
> I tried to wire the nr_cpumask_bits to nr_cpu_ids unconditionally, and
> it works even when OFFSTACK is OFF, no surprises.
>=20
> I didn't find any discussions describing what for we need nr_cpumask_bits=
,
> and the code adding it dates to a very long ago.
>=20
> If I alias nr_cpumask_bits to nr_cpu_ids unconditionally on my VM with
> NR_CPUs =3D=3D 256 and nr_cpu_ids =3D=3D 4, there's obviously a clear win=
 in
> performance, but the Image size gets 2.5K bigger. Probably that's the
> reason for what nr_cpumask_bits was needed...

I think it makes sense to have a compile-time-constant value for nr_cpumask=
_bits
in some cases. For example on embedded platforms, where every opportunity t=
o
save a few kB should be used, or cases where NR_CPUS <=3D BITS_PER_LONG.

>=20
> There's also a very old misleading comment in cpumask.h:
>=20
> =C2=A0*=C2=A0 If HOTPLUG is enabled, then cpu_possible_mask is forced to =
have
> =C2=A0*=C2=A0 all NR_CPUS bits set, otherwise it is just the set of CPUs =
that
> =C2=A0*=C2=A0 ACPI reports present at boot.
>=20
> It lies, and I checked with x86_64 that cpu_possible_mask is populated
> during boot time with 0b1111, if I create a 4-cpu VM. Hence, the
> nr_cpu_ids is 4, while NR_CPUS =3D=3D 256.
>=20
> Interestingly, there's no a single user of the cpumask_full(),
> obviously, because it's broken. This is really a broken dead code.
>=20
> Now that we have a test that checks sanity of cpumasks, this mess
> popped up.
>=20
> Your fix doesn't look correct, because it fixes one function, and
> doesn't touch others. For example, the cpumask subset() may fail
> if src1p will have set bits after nr_cpu_ids, while cpumask_full()
> will be returning true.

It appears the documentation for cpumask_full() is also incorrect, because =
it
claims to check if all CPUs < nr_cpu_ids are set. Meanwhile, the implementa=
tion
checks if all CPUs < nr_cpumask_bits are set.

cpumask_weight() has a similar issue, and maybe also other cpumask_*() func=
tions
(I didn't check in detail yet).

>=20
> In -next, there is an update from Sander for the cpumask test that
> removes this check, and probably if you rebase on top of -next, you
> can drop this and 2nd patch of your series.
>=20
> What about proper fix? I think that a long time ago we didn't have
> ACPI tables for possible cpus, and didn't populate cpumask_possible
> from that, so the
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #define nr_cpumask_bits NR_CPU=
S
>=20
> worked well. Now that we have cpumask_possible partially filled,
> we have to always
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #define nr_cpumask_bits nr_cpu=
_ids
>=20
> and pay +2.5K price in size even if OFFSTACK is OFF. At least, it wins
> at runtime...
>=20
> Any thoughts?

It looks like both nr_cpumask_bits and nr_cpu_ids are used in a number of p=
laces
outside of lib/cpumask.c. Documentation for cpumask_*() functions almost al=
ways
refers to nr_cpu_ids as a highest valid value.

Perhaps nr_cpumask_bits should become an variable for internal cpumask usag=
e,
and external users should only use nr_cpu_ids? The changes in 6.0 are my fi=
rst
real interaction with cpumask, so it's possible that there are things I'm
missing here.

That being said, some of the cpumask tests compare results to nr_cpumask_bi=
ts,
so those should then probably be fixed to compare against nr_cpu_ids instea=
d.

Best,
Sander

>=20
> ---
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index 5e2b10fb4975..0f044d93ad01 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -41,13 +41,7 @@ typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS)=
; }
> cpumask_t;
> =C2=A0extern unsigned int nr_cpu_ids;
> =C2=A0#endif
> =C2=A0
> -#ifdef CONFIG_CPUMASK_OFFSTACK
> -/* Assuming NR_CPUS is huge, a runtime limit is more efficient.=C2=A0 Al=
so,
> - * not all bits may be allocated. */
> =C2=A0#define nr_cpumask_bits=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0nr_cpu_ids
> -#else
> -#define nr_cpumask_bits=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(=
(unsigned int)NR_CPUS)
> -#endif
> =C2=A0
> =C2=A0/*
> =C2=A0 * The following particular system cpumasks and operations manage
> @@ -67,10 +61,6 @@ extern unsigned int nr_cpu_ids;
> =C2=A0 *=C2=A0 cpu_online_mask is the dynamic subset of cpu_present_mask,
> =C2=A0 *=C2=A0 indicating those CPUs available for scheduling.
> =C2=A0 *
> - *=C2=A0 If HOTPLUG is enabled, then cpu_possible_mask is forced to have
> - *=C2=A0 all NR_CPUS bits set, otherwise it is just the set of CPUs that
> - *=C2=A0 ACPI reports present at boot.
> - *
> =C2=A0 *=C2=A0 If HOTPLUG is enabled, then cpu_present_mask varies dynami=
cally,
> =C2=A0 *=C2=A0 depending on what ACPI reports as currently plugged in, ot=
herwise
> =C2=A0 *=C2=A0 cpu_present_mask is just a copy of cpu_possible_mask.

