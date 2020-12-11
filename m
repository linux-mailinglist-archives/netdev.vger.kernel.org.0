Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEBB2D6C4C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391835AbgLKAF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 19:05:56 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59166 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729668AbgLKAFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 19:05:20 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607645077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u4caiGj9t4ml+Fg2/LjvRAStceu1HqnXy5JxnlwmdFA=;
        b=eJe5C3lGb4euYOQ5NqFfsUko6q7Wl5m2rZaxuQ1CHGu4Pm86NUNkZ6G0XU9RxY87NzbBDc
        ldDhHBRuz8FurePK9zxQgdZ8itpY4Ib/oRUPYjSjeYReInLr9h7ip+USHGm7wSsyPmDxLv
        kj/1ZDcjtWRNli3PMHxskKmD4HwrP9Z+f8gXizycgXKbIaIDlgPtawVOXPrlZTSGX8Zfnf
        IWYCSqSxGsHEKzkDR85bq7gyV8KfYwwNkrQ2+SYN1BD6txCpqD9nrnJuEv/HOAgcIkRmdB
        DiW9PCPEtazOZRhcxwcj1i5rFCGn+T95DeUWuc+jttPExN8BouNdQm/34fvnLQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607645077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u4caiGj9t4ml+Fg2/LjvRAStceu1HqnXy5JxnlwmdFA=;
        b=z8XrxSbQKj1sp6kNzbU4BhMX1SALkTHGkd40WvYT5KLsIfRVa3pnqtOT9ywbS00FEUqpMv
        tXHEfFQ9bRMVcSAg==
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
Subject: Re: [patch 24/30] xen/events: Remove unused bind_evtchn_to_irq_lateeoi()
In-Reply-To: <748d8d81-ac0f-aee2-1a56-ba9c40fee52f@oracle.com>
References: <20201210192536.118432146@linutronix.de> <20201210194044.972064156@linutronix.de> <748d8d81-ac0f-aee2-1a56-ba9c40fee52f@oracle.com>
Date:   Fri, 11 Dec 2020 01:04:37 +0100
Message-ID: <87im99i4x6.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10 2020 at 18:19, boris ostrovsky wrote:
> On 12/10/20 2:26 PM, Thomas Gleixner wrote:
>> -EXPORT_SYMBOL_GPL(bind_evtchn_to_irq_lateeoi);
>
> include/xen/events.h also needs to be updated (and in the next patch for xen_set_affinity_evtchn() as well).

Darn, I lost that.
