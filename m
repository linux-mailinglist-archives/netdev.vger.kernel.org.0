Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBECD392BA7
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 12:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbhE0KX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 06:23:56 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:55150 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236081AbhE0KXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 06:23:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622110937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dDJT6X4zSDczVsL85ePLb2edlKxANz9DzYCuH+VrkBU=;
        b=Bea2V7SgcH15q7HGNTvJD0Al4JF+EyCkN17dq+BkRllStwM/Ll8GMGFXb0APahRrZ4P/DL
        pU1n37y6OgdmmWIm7Sh3I6mQVj+r8Rez1RhpDjV7VDAHOWVFBge+u73ITLx6Nxxzh9GiQc
        gnjyVkHYaCjDAXVbzJNrr8O1qN5hgNA=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2050.outbound.protection.outlook.com [104.47.5.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-WzIlkBHxPHKuom-AeqfSXg-1; Thu, 27 May 2021 12:22:16 +0200
X-MC-Unique: WzIlkBHxPHKuom-AeqfSXg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEFAL7/fLHGpH/Hj+UsjkOZtSk3nyW6G7d9Wsb90r3laD585mCdpaP46GFzLJS0SDADb+H/Z08K465lz9mMtFfc2KC3Gbyz1dvyKP+Q/vrQTM4XIX86yTyCzODK8TywrrK8hjAbgY01A96JB6HHGB0yvlwEONJW78qhf/70ZJGMtWp1KlB+lv1HyLG95ADvoCGjET9o1HpHuQUyeamv9IxoIR+C5GDGtJnRP1tRCnBr0SjC09heGu+sHne/nNvZMicVQSZyek7eiYEisCemBovJbnbADtKEZlK3dCDchD+Cn0i5AE8XaD1LqSpAnhjPNP0XgwF7e109TgtjQjyuGLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDJT6X4zSDczVsL85ePLb2edlKxANz9DzYCuH+VrkBU=;
 b=bxYG9rLeOTkwBH/ZAVktqdtPtxgEF/r6y11gGV8k1DvmMg0TVnz6Y+A7LaisonbW7p+DS2VOFx9dKb2cafuhxQVjui2zEAxIuMpBQ9NUyBMSYtrsrIKPUifwKxG1UCBAv1mXmoTw+b5u8xJfadLDt988hcpVEjf0orpuLIxVAkQ9VcPNfiO2LmkhbaZ5VO0x1tPAJVTYvyjOzv2buezBK8k8dMiXKIO/h3r2zR9plcD9Jp1OPrT3xZyVLhNLvetw0VUnUDghcU1AECLJCRmOvF/S10lV0RqtrJdnPXmcG/aubcPcQ7wAkfjBB1zQlD36FOiqZslpzk01LYNw+yqAAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21)
 by DBBPR04MB8059.eurprd04.prod.outlook.com (2603:10a6:10:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Thu, 27 May
 2021 10:22:12 +0000
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::790f:c865:4660:1565]) by DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::790f:c865:4660:1565%7]) with mapi id 15.20.4173.021; Thu, 27 May 2021
 10:22:12 +0000
Date:   Thu, 27 May 2021 18:21:57 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Nitesh Lal <nilal@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com,
        Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com
Subject: Re: [PATCH] genirq: Provide new interfaces for affinity hints
Message-ID: <YK9yxQoBPeUfQG05@syu-laptop>
References: <20210504092340.00006c61@intel.com>
 <87pmxpdr32.ffs@nanos.tec.linutronix.de>
 <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com>
 <87im3gewlu.ffs@nanos.tec.linutronix.de>
 <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com>
 <CAFki+L=eQoMq+mWhw_jVT-biyuDXpxbXY5nO+F6HvCtpbG9V2w@mail.gmail.com>
 <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com>
 <87zgwo9u79.ffs@nanos.tec.linutronix.de>
 <87wnrs9tvp.ffs@nanos.tec.linutronix.de>
 <YK9ucRrjq+eck/G7@syu-laptop>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YK9ucRrjq+eck/G7@syu-laptop>
X-Originating-IP: [27.242.200.212]
X-ClientProxiedBy: PR3P189CA0040.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::15) To DB7PR04MB5177.eurprd04.prod.outlook.com
 (2603:10a6:10:20::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from syu-laptop (27.242.200.212) by PR3P189CA0040.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 10:22:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69c3169f-7bc4-4362-6cd7-08d920f94a39
X-MS-TrafficTypeDiagnostic: DBBPR04MB8059:
X-Microsoft-Antispam-PRVS: <DBBPR04MB8059E3B7D3E61BD47316F47EBF239@DBBPR04MB8059.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HB4GEiW1mioq+juFay0vOhwywXNlI/ZLEvuPDqzkhZ61XuOkaez90uwtCEOIEgr3+EW/EoY7DZgl9o3P/yLbWT0bflgllxMQeum3t254WpXjxTNMh1QGSJ3EzT4CZqqAf/25zX/hcTEUhfhtK7dTwHqIAq8Dk/tq5/E+qsyFknyYEJqAP+Wnfdzv2UcmiXSZy0vvYQr3tBsKZnIzvAk/nXtzAsEiCW/k250PUyWREwP/oZmFoHKIgK3lOqYEUe1o4X3npYm0xiAPjQTydj6cXbATL/EGhkFpy7ROOvI040Xj6oPEE4pM65FSBQYlXkj2u3v93w7O6e8HNXSR7fUAyPyv8O8VX06pLdTxR9g16xFNRniM2b04bHQwrf0pfiOuywROgbrLRhKczmsy9zPnpnsNBMuTtYpKZhHeqDWhdwodw1WX/NfamvKqSELNK8kM5hqBxnZAU8aUMa8BYN16WvqmbNbfIn6DU5ajLTgjVMoCLsAsu7FSfZaxdL7FZq9qkJ1aMYybJJnNMujtb/T7BKnF1DRcSE3CtfxKHOzopiIzGtZT0pUnioeOeQM5KppXa8rerM7bsRxrCWpL+ojzHaQBsLV1724vPxl3C+G+8+lBJ3Q3edYzP9Wm5Hs3Ct6Y1rzRhmduHp56B1FKZVO2iHgXpCMNDRK5mKB+t5HBoeEEuKLIXGEqp9ybgELd+KayIYQCHPna+PwKTdmRvl+l8vRW/kcvzArgfhvFBQtosBY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5177.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(9686003)(8676002)(6496006)(66476007)(966005)(66946007)(55016002)(54906003)(66556008)(38100700002)(33716001)(5660300002)(6666004)(2906002)(498600001)(6916009)(186003)(26005)(16526019)(83380400001)(8936002)(86362001)(956004)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dWNNc3JjdnBNZ3N3bVplMWRIWjM1S0F1MGpUWW1TSzBxRW4yTHg5NWpCUTdz?=
 =?utf-8?B?RS9VdkJNaXNxWWV2YkZVbmIyNG5PTmw0dVZTQ0RIbjVWVllYMm5YTTJqaWpr?=
 =?utf-8?B?d3YzenBOLzVaN0NOQThEbmxwalduZ3hpSzJUKzI4RnBjZTVYc0lGNkJNQWpP?=
 =?utf-8?B?MnBlR0xiQWYwSWVKS3lkcU1rN2FkU3VDclhHNGFJZld0OVhiazB6d0ZnWVhv?=
 =?utf-8?B?OVc5Y3ZOWVRYSVg0QW1DeHhkOUdTN0t4RW1BNit4UWdnWmJVVnc2NzRvR0RR?=
 =?utf-8?B?bS91cTNyYWxJdnY5TWdSano0NHNQUW5sUjlEYzF2T1VzMTZCVkZVVXVLSUFB?=
 =?utf-8?B?VGlnaVdkQ2QvNmJnekg5ZU9zY1BraFdOY0hEeEhISWdOOG5rQnhVdFA0TGlG?=
 =?utf-8?B?TGdpYzNCZDBTL1Z4eGdDRGNJZEFSb3IzSWNhM1dZakRpbmdPejVXd3RjT2Zz?=
 =?utf-8?B?OVM3bEd5UG9rRkFzS24zUkkwajlreTVKbVZ0enp4aVZKWFB5T3hBSXpqTkpT?=
 =?utf-8?B?dktGdENzOU5Sb2taWFBXaGJrTDk4eTZTMk1YRkpwWDI3VXhlaGhFUHREOHNj?=
 =?utf-8?B?VnplWEtPQ3dvRURXYkg2bExxUnB0NXp3MHhFaVZlLytrZDI1Z0V3Wm5aU2d5?=
 =?utf-8?B?Ui9rcEwxRkVOSG4rRlVaVlZVYzgxdExYdmhCQ2hQZStMSEV1akd0K21tRFB2?=
 =?utf-8?B?bGo5a3Z2djZyVmo3VTIxejB5ZUM0MW1RdzJSSkd0Y1h3YlpEY1A5OWIrQjd1?=
 =?utf-8?B?Zkh0YUk4ZERacm1ONVR4RGdKaWdyb0V3UzByQ3l5aGQ1YVE4SWFicTVvckpD?=
 =?utf-8?B?aDF4QVJPS0UwYUo3YlRENTYrVjErZWpZMEFIRzFJRDV2d1grZ0xyL0tnSmow?=
 =?utf-8?B?TG90ZzFKb0lrdFhwaW91TUI2SUtMSG5qaGliUndhdkpZaG1wYm1rWllaaFdz?=
 =?utf-8?B?ZElhUnhpa1h6R0FpUXNDRjZBbXptN2tyMjlPb01YTk1zazZvSzV2ZTY0OHZ3?=
 =?utf-8?B?S0hPYVQ5RUIxL1k2a2kwNlp0TjBHOFZTYlVmSFQrclUwOWpNRGFLMkRFY1dF?=
 =?utf-8?B?dlp6K2VNWTFNYm1oZjNRdk84MW1EOFl1c3Q3U3lmR0FKUWRRaWxuZXR2QW42?=
 =?utf-8?B?Rkx1Skl0dzZrNVdzWC9VMG9EaGhtQ0pTMWNPQVMvdDFyUTcybDQyejFCSU5u?=
 =?utf-8?B?SXh3TlR5L0x3bDhCT25KTWZFTlNPUFZJbW9OTSttQk5zdTJ4Z0Zyc2pncXhE?=
 =?utf-8?B?VytNTjNTLzFXOGhmNWFJaUdDYWxIS01YMzB1eEtWZVpBTWwvaUFXa2dvbmdN?=
 =?utf-8?B?REF5eEZLYzNOZVVQY1RIZ0c0SXhraCtRaFNnZjRRNGJyRmlTcGNUSTdma25x?=
 =?utf-8?B?ZU9HQWpaNjZudnBxeGtiZnFrVkpkL1VZTEpVTXppRmZrZWIxZWpXTHZETHlO?=
 =?utf-8?B?Ty9tV2VCZFZFTlVlUDdWa3ltMFBVMHVYb0xILzZuZXgwWUluNkdhZFZ5c1Q0?=
 =?utf-8?B?TVNxTTVuMGp1TGJtUlFDU04vcnZPR2EwRTUzSFc3Sno1blk4MExFWGNMTEo4?=
 =?utf-8?B?R1BGbVRlOUhJMExaR1B5alFPK2pPTUlPMXVOZkw5T2pTWEZpSGIydldRVitx?=
 =?utf-8?B?cjVZdDQzdTdhbS9NcHRHVkRLblByMWV4WWJpV1ptSzNHeTJwQU1vdDRjM3pk?=
 =?utf-8?B?V1dxMktxQndMbmlpc3lyV0RzRUx1VVBmU3ZqWGlxYjJaRDhoM1dVNjcxbjNG?=
 =?utf-8?Q?zabl/bgvFYILwcdvzh2u5PJAkouZK5w3JJYtw11?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69c3169f-7bc4-4362-6cd7-08d920f94a39
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5177.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 10:22:11.7546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GAGPz0YnXXcLvFRKt0ziasUuCImVFmSSvommnGC1opvsUFo+aV8JZaMXd+HQjWp/lN9ex7Z4zkESty7iAU/MZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 06:03:29PM +0800, Shung-Hsi Yu wrote:
> Hi,
> 
> On Fri, May 21, 2021 at 02:03:06PM +0200, Thomas Gleixner wrote:
> > The discussion about removing the side effect of irq_set_affinity_hint() of
> > actually applying the cpumask (if not NULL) as affinity to the interrupt,
> > unearthed a few unpleasantries:
> > 
> >   1) The modular perf drivers rely on the current behaviour for the very
> >      wrong reasons.
> > 
> >   2) While none of the other drivers prevents user space from changing
> >      the affinity, a cursorily inspection shows that there are at least
> >      expectations in some drivers.
> > 
> > #1 needs to be cleaned up anyway, so that's not a problem
> > 
> > #2 might result in subtle regressions especially when irqbalanced (which
> >    nowadays ignores the affinity hint) is disabled.
> > 
> > Provide new interfaces:
> > 
> >   irq_update_affinity_hint() - Only sets the affinity hint pointer
> >   irq_apply_affinity_hint()  - Set the pointer and apply the affinity to
> >   			       the interrupt
> > 
> > Make irq_set_affinity_hint() a wrapper around irq_apply_affinity_hint() and
> > document it to be phased out.
> 
> Is there recommended way to retrieve the CPU number that the interrupt has
> affinity?
> 
> Previously a driver (I'm looking at drivers/net/ethernet/amazon/ena) that
> uses irq_set_affinity_hint() to spread out IRQ knows the corresponding CPU
> number since they're using their own spreading scheme. Now, phasing out
> irq_set_affinity_hint(), and thus relying on request_irq() to spread the
> load instead, there don't seem to be a easy way to get the CPU number.

I should add that the main use-case for retrieving CPU number seems to be
ensuring memory is allocated on the same NUMA node that serves the interrupt
(again, looking at ena driver only, haven't check others yet).

    int cpu = i % num_online_cpu();
    cpumask_set_cpu(cpu, &affinity_hint_mask);
    request_irq(irq, ...);
    irq_set_affinity_hint(irq, &affinity_hint_mask);
    int node = cpu_to_node(cpu);
    buffer = vzalloc(node);

> In theory the following could work, but including irq.h does not look like a
> good idea given that the comment in its explicitly ask not to be included in
> generic code.
> 
>     #include <linux/irq.h>
>     int irq = request_irq(...);
>     struct irq_data *data = irq_get_irq_data(irq);
>     struct cpumask *mask = irq_data_get_effective_affinity_mask(data);
>     int cpu = cpumask_first(mask);
> 
> Any suggestions?
> 
> 
> Thanks,
> Shung-Hsi
> 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Link: https://lore.kernel.org/r/20210501021832.743094-1-jesse.brandeburg@intel.com
> > ---
> > Applies on:
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
> > ---
> >  include/linux/interrupt.h |   41 ++++++++++++++++++++++++++++++++++++++++-
> >  kernel/irq/manage.c       |    8 ++++----
> >  2 files changed, 44 insertions(+), 5 deletions(-)
> > 
> > --- a/include/linux/interrupt.h
> > +++ b/include/linux/interrupt.h
> > @@ -328,7 +328,46 @@ extern int irq_force_affinity(unsigned i
> >  extern int irq_can_set_affinity(unsigned int irq);
> >  extern int irq_select_affinity(unsigned int irq);
> >  
> > -extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
> > +extern int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
> > +				     bool setaffinity);
> > +
> > +/**
> > + * irq_update_affinity_hint - Update the affinity hint
> > + * @irq:	Interrupt to update
> > + * @cpumask:	cpumask pointer (NULL to clear the hint)
> > + *
> > + * Updates the affinity hint, but does not change the affinity of the interrupt.
> > + */
> > +static inline int
> > +irq_update_affinity_hint(unsigned int irq, const struct cpumask *m)
> > +{
> > +	return __irq_apply_affinity_hint(irq, m, true);
> > +}
> > +
> > +/**
> > + * irq_apply_affinity_hint - Update the affinity hint and apply the provided
> > + *			     cpumask to the interrupt
> > + * @irq:	Interrupt to update
> > + * @cpumask:	cpumask pointer (NULL to clear the hint)
> > + *
> > + * Updates the affinity hint and if @cpumask is not NULL it applies it as
> > + * the affinity of that interrupt.
> > + */
> > +static inline int
> > +irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m)
> > +{
> > +	return __irq_apply_affinity_hint(irq, m, true);
> > +}
> > +
> > +/*
> > + * Deprecated. Use irq_update_affinity_hint() or irq_apply_affinity_hint()
> > + * instead.
> > + */
> > +static inline int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
> > +{
> > +	return irq_apply_affinity_hint(irq, cpumask);
> > +}
> > +
> >  extern int irq_update_affinity_desc(unsigned int irq,
> >  				    struct irq_affinity_desc *affinity);
> >  
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -487,7 +487,8 @@ int irq_force_affinity(unsigned int irq,
> >  }
> >  EXPORT_SYMBOL_GPL(irq_force_affinity);
> >  
> > -int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
> > +int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
> > +			      bool setaffinity)
> >  {
> >  	unsigned long flags;
> >  	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
> > @@ -496,12 +497,11 @@ int irq_set_affinity_hint(unsigned int i
> >  		return -EINVAL;
> >  	desc->affinity_hint = m;
> >  	irq_put_desc_unlock(desc, flags);
> > -	/* set the initial affinity to prevent every interrupt being on CPU0 */
> > -	if (m)
> > +	if (m && setaffinity)
> >  		__irq_set_affinity(irq, m, false);
> >  	return 0;
> >  }
> > -EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
> > +EXPORT_SYMBOL_GPL(__irq_apply_affinity_hint);
> >  
> >  static void irq_affinity_notify(struct work_struct *work)
> >  {

