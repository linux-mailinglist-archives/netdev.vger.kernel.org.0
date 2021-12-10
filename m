Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F046C470928
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 19:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245526AbhLJSsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 13:48:15 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48292 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbhLJSsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 13:48:14 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639161877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SscPtTd6NYlTuHsVGD4gIuaxOIVHkwKJUjrMqfCiVF4=;
        b=TY8BF1JpkOaWtM2lrvFKTimTzat4EoRUHL+2eclOarFXkWGYNp3IyW2HQ5T8OWMWbhbfVq
        VDI9t4KC4+9kr42qqtXe/zQkX9rgTt0OrLcbIC4lUUJnZcElcKe523A+3l80bmMdk2T6L5
        d5Hu/EtGPMItJfm5OP7BSFdEbREqITVFviXcxUWECj7AtRzxskgM53w8GvswvRLjsPdB17
        PVpuyE/35HcdVqIN7L14w6Qv8pd7aSo6oy2iBx3jCjdSZinbR7bP3gFDZcByUHgsRXRjFr
        33QecEs2XK3Ltk39FZfGapRxuPnM89/MI/XPmnxKqZNooWA0jpNi3oGb1yrqlg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639161877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SscPtTd6NYlTuHsVGD4gIuaxOIVHkwKJUjrMqfCiVF4=;
        b=HHsBOye9UyITzMD4gKeP/m5EEeIczEVFtbEFxqB8YFUhZWJIQz4Lx7hjogYbp35pBy31KU
        IuicCTDcUwWRSDBA==
To:     Nitesh Lal <nilal@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
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
In-Reply-To: <CAFki+L=5sLN+nU+YpSSrQN0zkAOKrJorevm0nQ+KdwCpnOzf3w@mail.gmail.com>
References: <20210903152430.244937-1-nitesh@redhat.com>
 <CAFki+L=9Hw-2EONFEX6b7k6iRX_yLx1zcS+NmWsDSuBWg8w-Qw@mail.gmail.com>
 <87bl29l5c6.ffs@tglx>
 <CAFki+Lmrv-UjZpuTQWr9c-Rymfm-tuCw9WpwmHgyfjVhJgp--g@mail.gmail.com>
 <CAFki+L=5sLN+nU+YpSSrQN0zkAOKrJorevm0nQ+KdwCpnOzf3w@mail.gmail.com>
Date:   Fri, 10 Dec 2021 19:44:36 +0100
Message-ID: <87ilvwxpt7.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10 2021 at 08:51, Nitesh Lal wrote:
> On Wed, Nov 24, 2021 at 5:16 PM Nitesh Lal <nilal@redhat.com> wrote:
>> > The more general question is whether I should queue all the others or
>> > whether some subsystem would prefer to pull in a tagged commit on top of
>> > rc1. I'm happy to carry them all of course.
>> >
>>
>> I am fine either way.
>> In the past, while I was asking for more testing help I was asked if the
>> SCSI changes are part of Martins's scsi-fixes tree as that's something
>> Broadcom folks test to check for regression.
>> So, maybe Martin can pull this up?
>>
>
> Gentle ping.
> Any thoughts on the above query?

As nobody cares, I'll pick it up.

Thanks,

        tglx
