Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73152D6C5B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393282AbgLKAHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 19:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392180AbgLKAHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 19:07:42 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9C6C061793;
        Thu, 10 Dec 2020 16:07:02 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607645220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QO8ZPs/aGTq6EeeiALBW4EwIli8xcBfNVbHQE3SuKNs=;
        b=gGpzgKDIdOJvLB57zkDYdB5nPR7tx5lmvyUREbAkcjTKLREnSTar6ATS+ovX5gwzQX+6as
        +gKXjZ78+gchUrT83h8ptRu8KDTcmgA5V5jrxe+Iroa2IR3dW4mzdsbfdAz67KCaNXJRFh
        HyT/Fqjz1nJPJbfByhhTG/yrTVt1YV6bo+ZpfwQUI97MYBpnXtPk3xo0rt3TJ6ElYxaC8x
        LYoOgKlBWXABRporT9mN8YQ9yVhNAWvziSIf5Q/k/u/zwNWg/xf9bb8eHNApJHV92yI6Fh
        8Vq/6Agy+63spk92uys0SUp9GgNSiQePxXptHhOLRD+usYLs0evVgfm0CC10Uw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607645220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QO8ZPs/aGTq6EeeiALBW4EwIli8xcBfNVbHQE3SuKNs=;
        b=fI8WyKpmQQfuF7v98I0m9jYr52j6v9il/Y1kYa+Nz5btUfOeJehvfvrp82h91pkkXnG/cc
        g+EFTi6ulxrthHDw==
To:     boris.ostrovsky@oracle.com, LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>, Juergen Gross <jgross@suse.com>,
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
In-Reply-To: <7f7af60f-567f-cdef-f8db-8062a44758ce@oracle.com>
References: <20201210192536.118432146@linutronix.de> <20201210194045.250321315@linutronix.de> <7f7af60f-567f-cdef-f8db-8062a44758ce@oracle.com>
Date:   Fri, 11 Dec 2020 01:06:59 +0100
Message-ID: <87ft4di4t8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10 2020 at 18:20, boris ostrovsky wrote:
> On 12/10/20 2:26 PM, Thomas Gleixner wrote:
>> All event channel setups bind the interrupt on CPU0 or the target CPU for
>> percpu interrupts and overwrite the affinity mask with the corresponding
>> cpumask. That does not make sense.
>>
>> The XEN implementation of irqchip::irq_set_affinity() already picks a
>> single target CPU out of the affinity mask and the actual target is stor=
ed
>> in the effective CPU mask, so destroying the user chosen affinity mask
>> which might contain more than one CPU is wrong.
>>
>> Change the implementation so that the channel is bound to CPU0 at the XEN
>> level and leave the affinity mask alone. At startup of the interrupt
>> affinity will be assigned out of the affinity mask and the XEN binding w=
ill
>> be updated.=20
>
> If that's the case then I wonder whether we need this call at all and
> instead bind at startup time.

I was wondering about that, but my knowledge about the Xen internal
requirements is pretty limited. The current set at least survived basic
testing by J=C3=BCrgen.

Thanks,

        tglx
