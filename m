Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3292D8282
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 00:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436943AbgLKW57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 17:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407083AbgLKW5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 17:57:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D33C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 14:56:43 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607727400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RMdJ5cNpvG94MqmN/2d6QVEWUP/YrLyBgV8MUkzsNlA=;
        b=0WcDMUhLUE5DmQJjljMHI2zWwird6I5Vzppg/zn6AZ6e1OM3STU+JeGE05b5oqLFOvFfmh
        CDXWZX+LKXvz41MQk+jw0mabsf/xLxFNSlsc7D+IqZgppXn+tyA6NewoUrmvCeXtmt2AST
        EViRmHdbhCgpLeje9DpFYTQlqeoEtc+eq14ZwN+Y4G4vhAzpgACbffqabmLR4OWIgQ5TkH
        0732UhUwEAjs3Gs9iSFScNlfSc9uVrpQKD7eElRAgICAQIyVgSIk6IrtHhKDjUooShlbLw
        6lnH9jzEFDJiTz3F4zTjotppmf5h8vHSXnbS356QRRnsZMAn1kegUSilRX0RVQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607727400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RMdJ5cNpvG94MqmN/2d6QVEWUP/YrLyBgV8MUkzsNlA=;
        b=ljcajSXupjVbHPbFKhUP57PPTY2aSW+D5nnua5xYh57kSUlRXkx3yzKeC3jH07q5vSS64l
        BGsVaGm3g05BhRAQ==
To:     Andrew Cooper <andrew.cooper3@citrix.com>,
        boris.ostrovsky@oracle.com,
        =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci@vger.kernel.org,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [patch 27/30] xen/events: Only force affinity mask for percpu interrupts
In-Reply-To: <edbedd7a-4463-d934-73c9-fa046c19cf6d@citrix.com>
References: <20201210192536.118432146@linutronix.de> <20201210194045.250321315@linutronix.de> <7f7af60f-567f-cdef-f8db-8062a44758ce@oracle.com> <2164a0ce-0e0d-c7dc-ac97-87c8f384ad82@suse.com> <871rfwiknd.fsf@nanos.tec.linutronix.de> <9806692f-24a3-4b6f-ae55-86bd66481271@oracle.com> <877dpoghio.fsf@nanos.tec.linutronix.de> <edbedd7a-4463-d934-73c9-fa046c19cf6d@citrix.com>
Date:   Fri, 11 Dec 2020 23:56:40 +0100
Message-ID: <87y2i4eytz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,

On Fri, Dec 11 2020 at 22:21, Andrew Cooper wrote:
> On 11/12/2020 21:27, Thomas Gleixner wrote:
>> It's not any different from the hardware example at least not as far as
>> I understood the code.
>
> Xen's event channels do have a couple of quirks.

Why am I not surprised?

> Binding an event channel always results in one spurious event being
> delivered.=C2=A0 This is to cover notifications which can get lost during=
 the
> bidirectional setup, or re-setups in certain configurations.
>
> Binding an interdomain or pirq event channel always defaults to vCPU0.=C2=
=A0
> There is no way to atomically set the affinity while binding.=C2=A0 I bel=
ieve
> the API predates SMP guest support in Xen, and noone has fixed it up
> since.

That's fine. I'm not changing that.

What I'm changing is the unwanted and unnecessary overwriting of the
actual affinity mask.

We have a similar issue on real hardware where we can only target _one_
CPU and not all CPUs in the affinity mask. So we still can preserve the
(user) requested mask and just affine it to one CPU which is reflected
in the effective affinity mask. This the right thing to do for two
reasons:

   1) It allows proper interrupt distribution

   2) It does not break (user) requested affinity when the effective
      target CPU goes offline and the affinity mask still contains
      online CPUs. If you overwrite it you lost track of the requested
      broader mask.

> As a consequence, the guest will observe the event raised on vCPU0 as
> part of setting up the event, even if it attempts to set a different
> affinity immediately afterwards.=C2=A0 A little bit of care needs to be t=
aken
> when binding an event channel on vCPUs other than 0, to ensure that the
> callback is safe with respect to any remaining state needing
> initialisation.

That's preserved for all non percpu interrupts. The percpu variant of
VIRQ and IPIs did binding to vCPU !=3D 0 already before this change.

> Beyond this, there is nothing magic I'm aware of.
>
> We have seen soft lockups before in certain scenarios, simply due to the
> quantity of events hitting vCPU0 before irqbalance gets around to
> spreading the load.=C2=A0 This is why there is an attempt to round-robin =
the
> userspace event channel affinities by default, but I still don't see why
> this would need custom affinity logic itself.

Just the previous attempt makes no sense for the reasons I outlined in
the changelog. So now with this new spreading mechanics you get the
distribution for all cases:

  1) Post setup using and respecting the default affinity mask which can
     be set as a kernel commandline parameter.

  2) Runtime (user) requested affinity change with a mask which contains
     more than one vCPU. The previous logic always chose the first one
     in the mask.

     So assume userspace affines 4 irqs to a CPU 0-3 and 4 irqs to CPU
     4-7 then 4 irqs end up on CPU0 and 4 on CPU4

     The new algorithm which is similar to what we have on x86 (minus
     the vector space limitation) picks the CPU which has the least
     number of channels affine to it at that moment. If e.g. all 8 CPUs
     have the same number of vectors before that change then in the
     example above the first 4 are spread to CPU0-3 and the second 4 to
     CPU4-7

Thanks,

        tglx
=20=20=20
