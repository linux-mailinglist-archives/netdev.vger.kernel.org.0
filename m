Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6DD393DA3
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 09:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbhE1HWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 03:22:40 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:21029 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235299AbhE1HWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 03:22:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622186461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y6ZpWTkYGG5NBHLcUoQP4TZFjxb+x2kAmAiTYXZDz6I=;
        b=BeT1Q4zeUXJiSXab97/fcj/bVbXgAvwsFyPztIf6k18vca5ia0U187913txlj1l68PLD4e
        ZX81ELyqd4icmignm1w+cqni78zT7j5iq/VexiE087m0PLTkug9K/eLxpwtVk55wvnp2i1
        /ImrfvYrGjagPYdHJG/PCsVLWZHDCSI=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-c66CzkL5PjGQD7swV4qGxA-1; Fri, 28 May 2021 09:20:58 +0200
X-MC-Unique: c66CzkL5PjGQD7swV4qGxA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVsQXrGwpDHq5nRNzgk95Af5JVhAeFvFwSlpp2ksis6RWMVyRcXWZR0pCJFhwlYVsXhtaFdvzlX6dvOgO1aAyhXiuxbkRIPZpXAK/pOBrYoxP9If/n8Jw5p4vZMHjNke2XsUmzb4gnli61c2HSL23rG0yZ+yXSIhPVbljnHaaUr/Pyec3tJhT8B9R0OxPuVjExwoQfZJkf41CvLA3lmbVoPPnh8Q9iAwzg4Q/8h1Tclm4RbeiwlG8AOlm0Ln9rkU8zhUCpcTcMzGk3ChI4Dab+TPoAcA7e+Gpw962C/G9mO1aLF70KKwRsnAGPyMuE6Vf+C/i5XdOjF0F6QHTUwuHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6ZpWTkYGG5NBHLcUoQP4TZFjxb+x2kAmAiTYXZDz6I=;
 b=LcKvy59lUNZDfOJ9qn4VnxmmAHWeHHG2+Pz9SQZU2di4w3kYblXyFHhjHO6JyfBIG0peHYEIOg5jHexgUKVyy6+Z7l7j7Rvb3V9/whi4Oek67PSXtvQQaLN/MXXcUf8H6HM+Yc0jDkEG6zTzf+/Sy2cjx+kf5nA1lM8Pv1NeD1jX6pdo9n02gXaVo+guVc1TqQFu0VRmXoY+VlxQMa4KoPoAeOVvubCvZdUluAMU7RoQL3ukFyrJjTdKiY+/w/xo8FSh1NOBRRuklaMJvvpsnKWXNzYox1mqWh/xk0HwLYRv0ZSeuSss0Qwuz3owUfD3wULnUDtw5IQwYRPr0KdVXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21)
 by DB3PR0402MB3884.eurprd04.prod.outlook.com (2603:10a6:8:f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 07:20:56 +0000
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::790f:c865:4660:1565]) by DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::790f:c865:4660:1565%7]) with mapi id 15.20.4173.021; Fri, 28 May 2021
 07:20:55 +0000
Date:   Fri, 28 May 2021 15:20:41 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Nitesh Lal <nilal@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <YLCZyVXiMfQshpgL@syu-laptop>
References: <87pmxpdr32.ffs@nanos.tec.linutronix.de>
 <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com>
 <87im3gewlu.ffs@nanos.tec.linutronix.de>
 <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com>
 <CAFki+L=eQoMq+mWhw_jVT-biyuDXpxbXY5nO+F6HvCtpbG9V2w@mail.gmail.com>
 <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com>
 <87zgwo9u79.ffs@nanos.tec.linutronix.de>
 <87wnrs9tvp.ffs@nanos.tec.linutronix.de>
 <YK9ucRrjq+eck/G7@syu-laptop>
 <CAFki+LnuharcwJy=x4Z27ixCMK1u2s2cvHh9=Bcf90rO06osEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFki+LnuharcwJy=x4Z27ixCMK1u2s2cvHh9=Bcf90rO06osEw@mail.gmail.com>
X-Originating-IP: [27.242.200.212]
X-ClientProxiedBy: AM3PR07CA0067.eurprd07.prod.outlook.com
 (2603:10a6:207:4::25) To DB7PR04MB5177.eurprd04.prod.outlook.com
 (2603:10a6:10:20::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from syu-laptop (27.242.200.212) by AM3PR07CA0067.eurprd07.prod.outlook.com (2603:10a6:207:4::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Fri, 28 May 2021 07:20:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c87451db-4fbd-4d55-1c06-08d921a92203
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3884:
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3884233510AB8D31F8CD9C6CBF229@DB3PR0402MB3884.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aXl7LdCLM+/CuWC7UZpr5F6mr6PEAZjB+aGlXHY5e6uQifWpdKpDzRRls7GsVsNiP+DkzdJzT7v3uKVelyg3PKdHGLdjEd8VJ3JAo2FUa1qmd1751khRSKO+K/wHUp5HEH7473V5nqwtFThgf6vz6rjlhcxpoZLvSzL0/t8vUFojwLsIAOUyC69dC9BZzTWYIzZJfn7Qg+iZuqcULZW1D/fnVAM1E6uD16OvKEWf0JeSdy8PBGepz8rt8fMBoy/NalsYr5/qu9LGwLuMinOO9h84ygAHPObO5LSIEp4te+4WzccaxTVq4927VwjRBI8QkSBz5duHGqVXQj4j3l+qKTDtDrEZh/zOYJQKqAuG6PU7jQBKs5vWB6yQiviD/pcTcRx0MbhersxgIMkkeH8PT1aiZnjyr+So6hphgOlQcN5C0mIww8FmRyNKE6RP3Lff/FHicYu+ZX5Lh5WUiARbufVr9whGW+JG4iCs1jPUIJV2Cb6687Qcgvg35hMQ71Y2OIxek4cmNSK+p5i2fiyCwLoUjwcPTQJD5/OSjYddpXav+XaxitnRIafab+fG+w9AW1TNUm13ebD9FalyBJ7iAJPQLMWkOplfqScP5OQb4KP9nnqYM/MbTC2x9jmy8Ysg1jirJNURfW6fB6u33Rcw3r/o093OpkGgyUAvW2iJgAVpzS3+AqzxgSYVylmFOz9PfETc/l9Bz+XBO28omPaLjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5177.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(26005)(966005)(478600001)(6496006)(53546011)(16526019)(86362001)(7416002)(55016002)(186003)(6916009)(2906002)(83380400001)(33716001)(9686003)(6666004)(316002)(54906003)(4326008)(8676002)(956004)(8936002)(5660300002)(66556008)(66476007)(66946007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dTVlbmhFUEJ5NjlSTGI0RDZkU0U2NXQwN1MvNVVvc2NGczRsSThaT3g1Nk83?=
 =?utf-8?B?REFKQmVWQ0RtZ2YzQTFsYWkxNGZjRE5RNnZBVzQwazE2OUNQZEV0MHdPK2M1?=
 =?utf-8?B?ZERTTllnSXljS0g3UHBrRTJYYS9VTVlGUU5xelEzRjdlaXRRTVhXMHZWcVZy?=
 =?utf-8?B?ZDBMNEsyeDQyTlkrMUxGYjdQUWd3b2FYeDVyM1lTVUpyUHlBREdXU1k5TXdn?=
 =?utf-8?B?eW9BOTAvOWEvNmpjUkhsbUlPQmFieW9Sbkt1TFllSk1VQ3BaOU9HZzNZemo1?=
 =?utf-8?B?NmhwSGZmci90R0RZSHVKZnB5NXVyVjdyMEt6bWRDUktlN2VtZTEzWWh2dXNU?=
 =?utf-8?B?aGRNMlM3cnhJRFN5cnNXanVsRGc4czF0QnJGTEFvanUrUC94MXNlTmRJTS9V?=
 =?utf-8?B?Q1hxT1FHVVUxUW9WU1Q3N0VKSVlad1hTbmQwNzNwVWRyeGI3WTJYb1ViSmI0?=
 =?utf-8?B?WFBWd3FZbHVZeUUzQmhsWDZ4Z3dBOUtyc2tXVDQ0MUM4VEcwTHNMQVpNQ3VT?=
 =?utf-8?B?TENsZ2pweS9INUVZc0VuVlpGRGRGL0JhTmJ4SUs5ZVFHemlVL3Z6MkkyczNZ?=
 =?utf-8?B?YUxxcW1nU3lsWlpGTisvTGdUVFBrQkkwUUZYMzF1SWZGNlpVMjNrSmlCYTAv?=
 =?utf-8?B?eW9UNCthakNYYmRzeHFnNDVNVVVUcjRxckZVcEhLd25IQ2dneWJ5ZUNsKzRz?=
 =?utf-8?B?S1k3QWxqZnpzSER5d1dUd1F1YUd4ekt4Vk80VFpKbVZXd29wTVduZVdocGF3?=
 =?utf-8?B?WVJ2dGwybHAvUzFPdzNyMEVTcENWTTd5ODBzUHl5bkNiejN1QVhoUGlycURP?=
 =?utf-8?B?WW9tSmVDRTVVSW96MjNuZUZ3Q0YzSkJ3RXRxeG9kVkZubXFHa0NSY3haRmFR?=
 =?utf-8?B?SGkvOCtqNnlNZnhXQ1U5VXFkcHMyRThJQkxDNThnVjVWQWhwOGZuakhSYmdp?=
 =?utf-8?B?d2c0QjZrZ0ptRHY4Vy9LVXpWbURwL1lKaFlGY201QUZxRHZJR1lDdTFYRnhZ?=
 =?utf-8?B?aExUT1IzeDV0YXBwK0ZxUlJOd0ZSUlkrVXNPVW52aTc0Wjg4d2hkV0lYak03?=
 =?utf-8?B?RDFxUzRiZHZDRVlrTDFaWFVab2pqclkrc2p1TFRmR2hnaTlOTDdQYjdQWVFh?=
 =?utf-8?B?RllXRjdaV1dodWM0Z1UzekVUSXBXN2N0ME9pTW15QXBOZDY1eFZLRzZRdHBa?=
 =?utf-8?B?NmRQYUlucHNSYjMwekhlQmkzMDR0ZG5HcWpUL3dvZWsrSDhQTW96ZU5zOUwz?=
 =?utf-8?B?S0MwUXZkL2dobU5QVnhwZDl3MEFWR0wwcXI5ZGFkdlpheGNUZ0FMU3BVR0hF?=
 =?utf-8?B?MjVrRENWYW5yVDZKeVpETGsxQTEwMWtGZTFxY3hIUmNsOW5VcXZEdmZVZlJ5?=
 =?utf-8?B?OXpYckVKL2kwY003NXNjSUp2L2ptMXhKamF3cjhEeWNXUWF3QlJpN3pBR3Bs?=
 =?utf-8?B?OGNiQ2dsbGt5bU1RWEE5YWdZSFpRWHhGanRtdGVpazhpVFZrVHFiUWlZNHVh?=
 =?utf-8?B?S25waHVlSmJERS84UmVLeDNnMDlkc3BacWpINnlaZEZEVG5PM2tJWjdJVWVl?=
 =?utf-8?B?SGdRei9iaUxuQ2t4V1I0TGRpakoyS0FEcC9Yd0wwdzdDRUJGNFdEcTZGcFJW?=
 =?utf-8?B?Y2JQYkwrcjN3TDBSSjcwSmNidXhMSzRrL01WdEJlYmgwU1RZZTk5WmsrblFU?=
 =?utf-8?B?TTlVOWhsZ25tQ3R5OHhkTTZzU3B0ZDluOERkUXpzNnRROU43eW1iS2s3UHJJ?=
 =?utf-8?Q?EjKcKOQ6lS58xY56Z2bWlV1a3APAPTxB9NKXeKD?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c87451db-4fbd-4d55-1c06-08d921a92203
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5177.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 07:20:55.8361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4dCR9PSvlIBnzu/jyAgIqgE3zSZ0pYfOlUNXMqxVyhKd57fAfZdR5NZkH0YOh8YwK4u6TebDXpOgjMxNR4W33Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 09:06:04AM -0400, Nitesh Lal wrote:
> On Thu, May 27, 2021 at 6:03 AM Shung-Hsi Yu <shung-hsi.yu@suse.com> wrote:
> >
> > Hi,
> >
> > On Fri, May 21, 2021 at 02:03:06PM +0200, Thomas Gleixner wrote:
> > > The discussion about removing the side effect of irq_set_affinity_hint() of
> > > actually applying the cpumask (if not NULL) as affinity to the interrupt,
> > > unearthed a few unpleasantries:
> > >
> > >   1) The modular perf drivers rely on the current behaviour for the very
> > >      wrong reasons.
> > >
> > >   2) While none of the other drivers prevents user space from changing
> > >      the affinity, a cursorily inspection shows that there are at least
> > >      expectations in some drivers.
> > >
> > > #1 needs to be cleaned up anyway, so that's not a problem
> > >
> > > #2 might result in subtle regressions especially when irqbalanced (which
> > >    nowadays ignores the affinity hint) is disabled.
> > >
> > > Provide new interfaces:
> > >
> > >   irq_update_affinity_hint() - Only sets the affinity hint pointer
> > >   irq_apply_affinity_hint()  - Set the pointer and apply the affinity to
> > >                              the interrupt
> > >
> > > Make irq_set_affinity_hint() a wrapper around irq_apply_affinity_hint() and
> > > document it to be phased out.
> >
> > Is there recommended way to retrieve the CPU number that the interrupt has
> > affinity?
> >
> > Previously a driver (I'm looking at drivers/net/ethernet/amazon/ena) that
> > uses irq_set_affinity_hint() to spread out IRQ knows the corresponding CPU
> > number since they're using their own spreading scheme. Now, phasing out
> > irq_set_affinity_hint(), and thus relying on request_irq() to spread the
> > load instead, there don't seem to be a easy way to get the CPU number.
> >
> 
> For drivers that don't want to rely on request_irq for spreading and want
> to force their own affinity mask can use irq_set_affinity()

I *do* want the driver to rely on request_irq() for spreading.

It is retrieving effective affinity after request_irq() call that I can't
seem to figure out.


Thanks,
Shung-Hsi

> which is an exported interface now [1] and clearly indicates the purpose
> of the usage.
> 
> As Thomas suggested we are still keeping irq_set_affinity_hint() as a
> wrapper until we make appropriate changes in individual drivers that use
> this API for different reasons. Please feel free to send out a patch
> for this driver once the changes are merged.
> 
> [1] https://lkml.org/lkml/2021/5/18/271
> 
> -- 
> Thanks
> Nitesh
> 

