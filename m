Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F9D45CD33
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 20:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349607AbhKXTdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 14:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351000AbhKXTdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 14:33:14 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88983C061574;
        Wed, 24 Nov 2021 11:30:04 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637782202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LYogUZz5SCgK/KWX9KT7zTNAuMHBvkv1vFcTH7JmwzE=;
        b=iFHR8vN0YSSvuY+/FEqOWS04ELNvnlIINtGmzBvpgvoW0RJXJNsuHQmBfMj2iA4ZMko4H2
        60BmO1srcUsxSyxf3b8VwniTwrU4MW5HYIXnO89hYIS7P1Dv+dfsCPnYU7rnP5wpbTitY0
        d+Uog0bcMrja6eQpc+n+YlkcbsQy9imG2hGFjxPQyYFnX6EtIaVaRi/GO9kEUtQ+z/u24q
        yeZsZgvknnYSXbkPASptJlMOrvr5vdukN69zMmHhXuYOWPC8Bsq0PCSq9rs+XpnYsjoU08
        2MExB79kFbRR0fbL2JT4UdNRaQEHAcI3vik+kIMHnW4vn3C+t3gOgV0PnSzSIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637782202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LYogUZz5SCgK/KWX9KT7zTNAuMHBvkv1vFcTH7JmwzE=;
        b=ZIXqIBgjBL4jcz44alU7iuZQZux6E74834ms00khTW9kWpyR41Bmv11e6hQ6i28s8f1em7
        dHuN95+5/LDPrhBg==
To:     Nitesh Lal <nilal@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        huangguangbin2@huawei.com, huangdaode@huawei.com,
        Frederic Weisbecker <frederic@kernel.org>,
        Alex Belits <abelits@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>, rostedt@goodmis.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Ingo Molnar <mingo@kernel.org>, jbrandeb@kernel.org,
        akpm@linuxfoundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com,
        Stefan Assmann <sassmann@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>, james.smart@broadcom.com,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Ken Cox <jkc@redhat.com>, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com,
        Alaa Hleihel <ahleihel@redhat.com>,
        Kamal Heib <kheib@redhat.com>, borisp@nvidia.com,
        saeedm@nvidia.com,
        "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        Al Stone <ahs3@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        bjorn.andersson@linaro.org, chunkuang.hu@kernel.org,
        yongqiang.niu@mediatek.com, baolin.wang7@gmail.com,
        Petr Oros <poros@redhat.com>, Ming Lei <minlei@redhat.com>,
        Ewan Milne <emilne@redhat.com>, jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        kabel@kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, kashyap.desai@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        suganath-prabu.subramani@broadcom.com, ley.foon.tan@intel.com,
        jbrunet@baylibre.com, johannes@sipsolutions.net,
        snelson@pensando.io, lewis.hanly@microchip.com, benve@cisco.com,
        _govind@gmx.com, jassisinghbrar@gmail.com
Subject: Re: [PATCH v6 00/14] genirq: Cleanup the abuse of
 irq_set_affinity_hint()
In-Reply-To: <CAFki+L=9Hw-2EONFEX6b7k6iRX_yLx1zcS+NmWsDSuBWg8w-Qw@mail.gmail.com>
References: <20210903152430.244937-1-nitesh@redhat.com>
 <CAFki+L=9Hw-2EONFEX6b7k6iRX_yLx1zcS+NmWsDSuBWg8w-Qw@mail.gmail.com>
Date:   Wed, 24 Nov 2021 20:30:01 +0100
Message-ID: <87bl29l5c6.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nitesh,

On Mon, Sep 13 2021 at 10:34, Nitesh Lal wrote:
> On Fri, Sep 3, 2021 at 11:25 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>>
>> The drivers currently rely on irq_set_affinity_hint() to either set the
>> affinity_hint that is consumed by the userspace and/or to enforce a custom
>> affinity.
>>
>> irq_set_affinity_hint() as the name suggests is originally introduced to
>> only set the affinity_hint to help the userspace in guiding the interrupts
>> and not the affinity itself. However, since the commit
>>
>>         e2e64a932556 "genirq: Set initial affinity in irq_set_affinity_hint()"

sorry for ignoring this. It fell through the cracks.

>> Thomas Gleixner (1):
>>   genirq: Provide new interfaces for affinity hints

Did I actually write this?

> Any suggestions on what should be the next steps here? Unfortunately, I haven't
> been able to get any reviews on the following two patches:
>   be2net: Use irq_update_affinity_hint
>   hinic: Use irq_set_affinity_and_hint
>
> One option would be to proceed with the remaining patches and I can try
> posting these two again when I post patches for the remaining drivers?

The more general question is whether I should queue all the others or
whether some subsystem would prefer to pull in a tagged commit on top of
rc1. I'm happy to carry them all of course.

Thanks,

        tglx


