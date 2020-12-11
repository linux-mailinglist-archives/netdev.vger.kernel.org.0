Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3852D8192
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 23:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405123AbgLKWIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 17:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405437AbgLKWIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 17:08:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02ABC0613D3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 14:07:24 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607724443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uE5KR5qlfz+ztx9s8pbRCB1Be+kxvrwztlDzBEoJCeU=;
        b=upIVkJhj5g1RmAalIreFExmj0QWc7xxC7dfgYyTKQ7/s1CPaLrvswCn2cis9a5ELIHv+rz
        IPyhjuoIqfAMI+60hoe1U1U27IhweRJLvNYpN7cTAqQ0o0KlM2VdD+/ibGw4UCrbJtLWLY
        inuTJUAvrZhdYHuTfLNeogwgdoyl5SGN/dy3kNNRxVqcfza2kw+U/H2LlJBjtaANpZFTIZ
        ptr78MOU90DKS42tb76OuG8X418bmY7SaqmPbyqibyrcTnWO7/ljKjMmuQI0HfaTAZd7Ho
        gSP1o6so90u917yflugfQ7VOzMuRufMAcgTvFJSwBRyBFBjjIC3oXcfJ628ySQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607724443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uE5KR5qlfz+ztx9s8pbRCB1Be+kxvrwztlDzBEoJCeU=;
        b=6l4EGHeIGgEoz1BM8xIprj71LYQ/8TNyn+KsbwNoVJfPjiraGOnwYmma/niMdHbbcB5BbA
        SooB9xEZT4EUdpBw==
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
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
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list\:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list\:HFI1 DRIVER" <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: Re: [patch 03/30] genirq: Move irq_set_lockdep_class() to core
In-Reply-To: <87h7osgifc.fsf@nanos.tec.linutronix.de>
References: <20201210192536.118432146@linutronix.de> <20201210194042.860029489@linutronix.de> <CAHp75Vc-2OjE2uwvNRiyLMQ8GSN3P7SehKD-yf229_7ocaktiw@mail.gmail.com> <87h7osgifc.fsf@nanos.tec.linutronix.de>
Date:   Fri, 11 Dec 2020 23:07:22 +0100
Message-ID: <87360cgfol.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11 2020 at 22:08, Thomas Gleixner wrote:

> On Fri, Dec 11 2020 at 19:53, Andy Shevchenko wrote:
>
>> On Thu, Dec 10, 2020 at 10:14 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>>>
>>> irq_set_lockdep_class() is used from modules and requires irq_to_desc() to
>>> be exported. Move it into the core code which lifts another requirement for
>>> the export.
>>
>> ...
>>
>>> +       if (IS_ENABLED(CONFIG_LOCKDEP))
>>> +               __irq_set_lockdep_class(irq, lock_class, request_class);
>
> You are right. Let me fix that.

No. I have to correct myself. You're wrong.

The inline is evaluated in the compilation units which include that
header and because the function declaration is unconditional it is
happy.

Now the optimizer stage makes the whole thing a NOOP if CONFIG_LOCKDEP=n
and thereby drops the reference to the function which makes it not
required for linking.

So in the file where the function is implemented:

#ifdef CONFIG_LOCKDEP
void __irq_set_lockdep_class(....)
{
}
#endif

The whole block is either discarded because CONFIG_LOCKDEP is not
defined or compile if it is defined which makes it available for the
linker.

And in the latter case the optimizer keeps the call in the inline (it
optimizes the condition away because it's always true).

So in both cases the compiler and the linker are happy and everything
works as expected.

It would fail if the header file had the following:

#ifdef CONFIG_LOCKDEP
void __irq_set_lockdep_class(....);
#endif

Because then it would complain about the missing function prototype when
it evaluates the inline.

Thanks,

        tglx
