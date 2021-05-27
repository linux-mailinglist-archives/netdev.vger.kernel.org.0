Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED097392B5C
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 12:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbhE0KFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 06:05:24 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:47798 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236007AbhE0KFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 06:05:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622109828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XelYueJaFOpdty88fV1FJfjnXyg6CFX9/Q++gr8VD0E=;
        b=FDNXJj3LMmGxZfFFdmpRgYySm5yADP8ttQgS7Qe36rgGBhoumHziiTny+QH3UDgXtGOkO2
        3xxJQKgj9QHR9kBv0icxhUs9NdeCVanmVa4dTw2YjQdgD82qO7B9sWs3KcmsnL4+ZeqOqn
        S35pq266Twwj51jJR3WgBu1wiDx9D0k=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2054.outbound.protection.outlook.com [104.47.0.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-35-2Pgl_GATPgmUV8oII5b3vw-1; Thu, 27 May 2021 12:03:46 +0200
X-MC-Unique: 2Pgl_GATPgmUV8oII5b3vw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBZATecgc3oXICXa4gXR23kHM1JeW17sPvM5woyWUz2nZWmuk8bZLK1iQVB9rfcOqzIJVzdhrCBGfRiIrP3oPTUj7dndSVjnsnwS5jLhh4cUts/d1ZTX76Mlw0V/CQ/CP3OrShoALr45r9kBZrjwLysD++Lx81/ymLpmQg0V0ml9r1RTApg0AWL9tbxmQTY4G8yIMvTOaTVF8CSvPfd+RJiT+BnPsXMtSE5gASd7cNijDM/t421HS8FISxgUj7nI+J/45BMUu7OVtkd/1eiYzMIo4tIX1dt+L5Y0VjA9Uv1bXIf+OPgjjpW7fgNvngBFTjrXdCmG8SZummLCe+zsMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XelYueJaFOpdty88fV1FJfjnXyg6CFX9/Q++gr8VD0E=;
 b=L9rFy3jyXpemNK2dBs/gH5PTLjKPbuP/SR/QAnJTUB2sJjC67l9HGZNbfgFnKlrNRi67nBl+WFPkHSMgJFR5j1G+UA4QncMVs3A2RbGk/j+XKFMsEobNA9T6uSBrnZ4847sv+oUnmCC1b5RYlS5/ZOnO3T5NZvQAKzy3w2wGCfMcbrEvZbXcFVCHTHnzKNFt2on1ZpBDEaukexLoWvKp6uxNe97gS1wyZTUhrKaMTuAjLWQcOFkej53HDkuxVlYQ8ujiA5kTiTfb7mTwp+YTlfF5bg3h/ozFgJGMLIqheLV7u5Xg7bdpcdueBrl+E5Ng6d40QMGR8ACEq7TgqUMbPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21)
 by DB6PR04MB3240.eurprd04.prod.outlook.com (2603:10a6:6:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Thu, 27 May
 2021 10:03:43 +0000
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::790f:c865:4660:1565]) by DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::790f:c865:4660:1565%7]) with mapi id 15.20.4173.021; Thu, 27 May 2021
 10:03:43 +0000
Date:   Thu, 27 May 2021 18:03:29 +0800
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
Message-ID: <YK9ucRrjq+eck/G7@syu-laptop>
References: <20210504092340.00006c61@intel.com>
 <87pmxpdr32.ffs@nanos.tec.linutronix.de>
 <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com>
 <87im3gewlu.ffs@nanos.tec.linutronix.de>
 <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com>
 <CAFki+L=eQoMq+mWhw_jVT-biyuDXpxbXY5nO+F6HvCtpbG9V2w@mail.gmail.com>
 <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com>
 <87zgwo9u79.ffs@nanos.tec.linutronix.de>
 <87wnrs9tvp.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87wnrs9tvp.ffs@nanos.tec.linutronix.de>
X-Originating-IP: [27.242.200.212]
X-ClientProxiedBy: FR3P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::9) To DB7PR04MB5177.eurprd04.prod.outlook.com
 (2603:10a6:10:20::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from syu-laptop (27.242.200.212) by FR3P281CA0061.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4b::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.10 via Frontend Transport; Thu, 27 May 2021 10:03:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f94e762c-4038-4324-1568-08d920f6b583
X-MS-TrafficTypeDiagnostic: DB6PR04MB3240:
X-Microsoft-Antispam-PRVS: <DB6PR04MB32405A27BC08163C6D87CEB4BF239@DB6PR04MB3240.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BgUl4mnVN5FMwt00/0Z83UtqGt/5lTFWTEsRJmjJAwyTKc/f24byACqfwvYQdfIrB8Le08zpwCwcEp65gkCaQXIasKMrHyt+hcfiv/f7UJl6mim9I+A0HzYtnV+3av70/uMplEmuzqpATA/cl4DsNCI+AI92+7Lmpbw8g9YH3DGI1YnP+l2RlkVslNx0/pfKKZhUlHLKRq1t7yGKmuVAzlgiKtFienVhQwKtqzg+JaOcAx41GhTwFlQZJ7gNwHcgk6Yd6/eptDJJC3gj37RZ2Ygkk3gj1LKweHAnNCslNRpCadtxRnlDfPUCwWk8/JcrBQ0pTG789p4sF6dHzqPkSX62BX8F6qBNkt8VfEveOR6EDohJPQim1uDRdbzAS6fMVsTZLEJjClt5aQR0rXPfXFDhbyu81N7sGPOfPfCDL8sPCQcHHWGQNAXtXbM2k2b2nHuws+ZC8raaoxMwNtJcibvyjS0i72UidestrxQJBQaPd8UgWspgDV4wzvRqMzPtg9wZ9Fr9DH+aaePYqqJC0ODusAJymmOp5izx4BzxIbVpuCwfI3Qg/b3+E079H4aFkus7QVQ1qOsKdKCWpgS7e3OcI+GzXmCRBAP1C5Owgz1ioqYoTvlJRRfk5WMgybS3WtIL+h7WNT70afxXnaJ/4x0Bua9Nz951cHulbsmkNC9mHSAh3kPXqAe/FrAuC9rf5DznWgaGNpI9alWKSCLtHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5177.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(26005)(6496006)(55016002)(966005)(38100700002)(86362001)(54906003)(66556008)(66946007)(66476007)(498600001)(6666004)(7416002)(33716001)(6916009)(956004)(4326008)(9686003)(8676002)(16526019)(2906002)(8936002)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M1JlK0ZzdmNXbVFGN042YnlqQURYZ1lqYXR6RDZ2WlpBTmpPNEVQUStLNGpT?=
 =?utf-8?B?RlZWaERSeFJZQ3o5N2ZwSnR2VEF1N0Qxa0NEam1wMTVMaFpYMm9Kc2l1MzM2?=
 =?utf-8?B?dXd1U0V5cnZBanlWL1MwZlBPOUN5Mm8zSHJYemJVVE15Z0RTcG1RbW9TWHVa?=
 =?utf-8?B?c3ArNEw2SVpydXVucEoxQWw1WWhGTkdDTXV5ektIaGtWMUw5Uml2amQwSE83?=
 =?utf-8?B?M1JpL2ZwL2NzRzd0SVBaWTFpMFFjOG1lRUFGakZDMnZ4RzFCYW9IUXBXY2Q2?=
 =?utf-8?B?RUdrcmh4RUpJR2t2RjhrOFdRUDgxNVJNUHp2V0FKRlI1T0U0YTVjNEpnOE5z?=
 =?utf-8?B?RWNnSEpFK3RKRGZ3SzFyakF5amdabEdzYno0d3BRU3JCa2FCUThBTGkxV0N1?=
 =?utf-8?B?N28xVFVGWnk5WWNKWDBkOVVzWmdUcjhBWTRsRjAreC83bzdRWkJyZVhIWmVl?=
 =?utf-8?B?MS91M1NzUFpTd0V5YnZaRklZQUtBaElpOHZEV1d4VjlsOEh5Z0Uwa2hsYngw?=
 =?utf-8?B?bW5jNXkrcjlCSFdsUTk3ZmQzUUFWMzkvNEhXdVpMVlhUYTBsMXdjbzdhVEoz?=
 =?utf-8?B?THdHbUdkejFHY0lKWEVTNFBpajhvUU1BRzZnVklLNjFBWUVXZXZDN1RXM0xU?=
 =?utf-8?B?anhyT3pjaE91emRlaXREcFVudWZaNFNuemVjT2lvK3RhUkdqM29SOFI1RzBH?=
 =?utf-8?B?RTRmellPWSsrWHc0N0dETjNranh2Z2VyYkRYUENIU1JERjkyRTFEeGJWUEJi?=
 =?utf-8?B?eTMvRmxwTE9uaFFFNTFxeEtNd29td3Rvdm5CWVl0RlAvTWplbXkyU2RZT3Fj?=
 =?utf-8?B?eHBtdWhFTHpyT2Z6V0R2R3hEem1qS1JWSTRLTjEwcVFSd1dlUG1sM0UzK05G?=
 =?utf-8?B?QnVhNXd1V0JITFdUSVNwa0daK2ZwWlZzK0RJRm4wbVUwQktBb2I0T2grRStl?=
 =?utf-8?B?ZFcxYTlSdlNVYW5HNDVVd2ZqOWVrTS9xamdNZ0NmVFNiYkZEYmVYSk4rNTRv?=
 =?utf-8?B?bVcyRWN4c0JEQjV6cXBPQ2VkLy9COUw4MExabitjOEpQMzJOZGxRZWt3bUxE?=
 =?utf-8?B?OWs4RlNXODhkMGttMHFDcUdpbDBBYkNLOUNtYXlpK2pkQS9tdjV4dkJiTk1I?=
 =?utf-8?B?d1BiSm0ybTlrNUNEekNrK1JvK2hUL3J1VGFjQ2FzZCt4VWgvSUdBdUxJeGJ3?=
 =?utf-8?B?WUUwOEtldFJVQ2cwais5eTZ1c0FxS0Yzdm94Ry9tR2ZVdXhIS0JuWjRtWi92?=
 =?utf-8?B?WnM1TWo3STg1ZGJGQ2hEaVNESmlWVGlCWkxCVUxBNzljaHptNVVFTUFieFQw?=
 =?utf-8?B?OW9CSkg0aFViSW1YcXBtVGJWVzh2a0FqUnVtQjRBWFVENlp5eGhiR3VybFhH?=
 =?utf-8?B?ZXI0Q21zeGRYNGtxMTFoY00vYmduSUsvOXZEZVFRcHZyWllRZ2VWT2RqbTNB?=
 =?utf-8?B?T2hlWnNjWkNxeFgyaUx3d2s2R0o0aUlyVGlrSExEVy8rMDJ4Qk54STJOa2o2?=
 =?utf-8?B?cDU0bWdXNzU4RXRMcG5XdnRWNjhSazFtaFdkY0dSYWN6OUdKbG1ndTkzcGFK?=
 =?utf-8?B?dVViNGx1eVUxczkrdE5PWllEVk1wQXROOFFxZjZ0allWN1NtNmMwRldMNFlt?=
 =?utf-8?B?THZrV1RURThNL2d4Y0oxbkZ1V05vQlRrWWVwTlpveWUvWDdQZk1ycG5jL3pL?=
 =?utf-8?B?QndYTndIdjBvZ3EwMmlJaUdSb3phTVZXUXdCL2UxeGNMUnRENGNYaDVKbzVR?=
 =?utf-8?Q?m1uU8MLdF0bibdIDOh5lTMWkIOKMWBsBPuEwpFn?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f94e762c-4038-4324-1568-08d920f6b583
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5177.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 10:03:43.3323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYYNe78FqVK+IZF8ap9hk9LpsQ8OzWlabzFs0l4Rrnptg0SFbY3KEYp/1luCMf+Y6wOwlANcTWZ2Ips9cR+cIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3240
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, May 21, 2021 at 02:03:06PM +0200, Thomas Gleixner wrote:
> The discussion about removing the side effect of irq_set_affinity_hint() of
> actually applying the cpumask (if not NULL) as affinity to the interrupt,
> unearthed a few unpleasantries:
> 
>   1) The modular perf drivers rely on the current behaviour for the very
>      wrong reasons.
> 
>   2) While none of the other drivers prevents user space from changing
>      the affinity, a cursorily inspection shows that there are at least
>      expectations in some drivers.
> 
> #1 needs to be cleaned up anyway, so that's not a problem
> 
> #2 might result in subtle regressions especially when irqbalanced (which
>    nowadays ignores the affinity hint) is disabled.
> 
> Provide new interfaces:
> 
>   irq_update_affinity_hint() - Only sets the affinity hint pointer
>   irq_apply_affinity_hint()  - Set the pointer and apply the affinity to
>   			       the interrupt
> 
> Make irq_set_affinity_hint() a wrapper around irq_apply_affinity_hint() and
> document it to be phased out.

Is there recommended way to retrieve the CPU number that the interrupt has
affinity?

Previously a driver (I'm looking at drivers/net/ethernet/amazon/ena) that
uses irq_set_affinity_hint() to spread out IRQ knows the corresponding CPU
number since they're using their own spreading scheme. Now, phasing out
irq_set_affinity_hint(), and thus relying on request_irq() to spread the
load instead, there don't seem to be a easy way to get the CPU number.

In theory the following could work, but including irq.h does not look like a
good idea given that the comment in its explicitly ask not to be included in
generic code.

    #include <linux/irq.h>
    int irq = request_irq(...);
    struct irq_data *data = irq_get_irq_data(irq);
    struct cpumask *mask = irq_data_get_effective_affinity_mask(data);
    int cpu = cpumask_first(mask);

Any suggestions?


Thanks,
Shung-Hsi

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lore.kernel.org/r/20210501021832.743094-1-jesse.brandeburg@intel.com
> ---
> Applies on:
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
> ---
>  include/linux/interrupt.h |   41 ++++++++++++++++++++++++++++++++++++++++-
>  kernel/irq/manage.c       |    8 ++++----
>  2 files changed, 44 insertions(+), 5 deletions(-)
> 
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -328,7 +328,46 @@ extern int irq_force_affinity(unsigned i
>  extern int irq_can_set_affinity(unsigned int irq);
>  extern int irq_select_affinity(unsigned int irq);
>  
> -extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
> +extern int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
> +				     bool setaffinity);
> +
> +/**
> + * irq_update_affinity_hint - Update the affinity hint
> + * @irq:	Interrupt to update
> + * @cpumask:	cpumask pointer (NULL to clear the hint)
> + *
> + * Updates the affinity hint, but does not change the affinity of the interrupt.
> + */
> +static inline int
> +irq_update_affinity_hint(unsigned int irq, const struct cpumask *m)
> +{
> +	return __irq_apply_affinity_hint(irq, m, true);
> +}
> +
> +/**
> + * irq_apply_affinity_hint - Update the affinity hint and apply the provided
> + *			     cpumask to the interrupt
> + * @irq:	Interrupt to update
> + * @cpumask:	cpumask pointer (NULL to clear the hint)
> + *
> + * Updates the affinity hint and if @cpumask is not NULL it applies it as
> + * the affinity of that interrupt.
> + */
> +static inline int
> +irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m)
> +{
> +	return __irq_apply_affinity_hint(irq, m, true);
> +}
> +
> +/*
> + * Deprecated. Use irq_update_affinity_hint() or irq_apply_affinity_hint()
> + * instead.
> + */
> +static inline int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
> +{
> +	return irq_apply_affinity_hint(irq, cpumask);
> +}
> +
>  extern int irq_update_affinity_desc(unsigned int irq,
>  				    struct irq_affinity_desc *affinity);
>  
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -487,7 +487,8 @@ int irq_force_affinity(unsigned int irq,
>  }
>  EXPORT_SYMBOL_GPL(irq_force_affinity);
>  
> -int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
> +int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
> +			      bool setaffinity)
>  {
>  	unsigned long flags;
>  	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
> @@ -496,12 +497,11 @@ int irq_set_affinity_hint(unsigned int i
>  		return -EINVAL;
>  	desc->affinity_hint = m;
>  	irq_put_desc_unlock(desc, flags);
> -	/* set the initial affinity to prevent every interrupt being on CPU0 */
> -	if (m)
> +	if (m && setaffinity)
>  		__irq_set_affinity(irq, m, false);
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
> +EXPORT_SYMBOL_GPL(__irq_apply_affinity_hint);
>  
>  static void irq_affinity_notify(struct work_struct *work)
>  {

