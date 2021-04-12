Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA1235C864
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242216AbhDLOLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:11:30 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:19040
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241159AbhDLOL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:11:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLm/O2M28XLbm28t8H4Exd6nAdvT9YJtJwSpFI+u10ddtGq0ySq6EsYiZ305ZHAj7Xk3kmqp1EWLzHJI6+yWHYdu1czP93vy2QaTAXnPgWeXlUxueaFEBg63VBUihAq3HqakRgFJaHpZg2cwavnVqFZC5OozJ9VGOrK/XyUwAiZQqgC4qkYI5U/4wxeiIUPIUh9D6e1j1p8BjnNT+89i1+BYY67DaCTIenH8ycJ+xBKamIjehJbN0OxnUiMpgDMmZKOYcTandh4gdLCekEG8YUeRvcF36xUCDLY3PS0fDXK45R7qVTSyELh7bCsurHVNPnME40WnzRM22GTrWQutMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIRyO4OnYqWQlCKjGhvWeRf414rx8Zfj6mvN7gHu0X4=;
 b=icEM1Q5qdxSyCT94q3DjpVCRHOSCobhOZcBCJJCA83Z/VxJrjtShxPLam3QOAQO8RQqiPeUQ/z3id6r3EuyxpiOSueiyh1nw2TLQYo1ta5/9l25D8xwn8ZSEJypgLZks26ARJ0+19isz/ysRnv5CygIjmfwW68fqi/xtQF8ugwRqgAt6vnG15qBsMCT5cvQ4MDIooxfKxEVpAEugQ+YDHlhdWU/w0rSEUW2PvlFMvU08x2faEcpMELC1X1maGDO6bSG9mSpYXKLI1JbNG5yM1XFPi9XG/DIhk9L1SOGfoOKfXhUfXfvRVD757CLasRReTSEKWjgLFxpLg1WicQJmzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIRyO4OnYqWQlCKjGhvWeRf414rx8Zfj6mvN7gHu0X4=;
 b=UX4J5NwV610iqc3jI04swKA4pFYDc0aH8XjBxk8rPiNrHc2+GaPEp2jaqN8zzDRyG2kgzXyqzW/ADTEmf7YyVSeLBNljUG77muVNdfE3I7iyoOW49co6/FV6tZp0iv0aM3EQ+cdRcD5+03/O7iUgmZ0wBDIiSv6L+Nkq8azBpW4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB7198.eurprd04.prod.outlook.com (2603:10a6:800:126::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 14:11:09 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4020.018; Mon, 12 Apr 2021
 14:11:07 +0000
Message-ID: <111528aed55593de83a17dc8bd6d762c1c5a3171.camel@oss.nxp.com>
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
From:   "Radu Nicolae Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 12 Apr 2021 17:11:02 +0300
In-Reply-To: <YHRDtTKUI0Uck00n@lunn.ch>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
         <YHCsrVNcZmeTPJzW@lunn.ch>
         <64e44d26f45a4fcfc792073fe195e731e6f7e6d9.camel@oss.nxp.com>
         <YHRDtTKUI0Uck00n@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
Content-Transfer-Encoding: 8bit
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM0PR05CA0089.eurprd05.prod.outlook.com
 (2603:10a6:208:136::29) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.141] (89.45.21.213) by AM0PR05CA0089.eurprd05.prod.outlook.com (2603:10a6:208:136::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 14:11:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1193bb3-941d-4f0a-e86d-08d8fdbcd0d3
X-MS-TrafficTypeDiagnostic: VI1PR04MB7198:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7198541E3E3CCBC955025B5F9F709@VI1PR04MB7198.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +jOfmKbOP7iq0xQp2aD3x98l73ePw/cFJr5SHx0nNrKOLEFYx4UoUCtO04fQj1Dwl96xc1U2JCQOMqsAZPFTZ4OZLnXFRKG9lc2EgJ5zz7Cju6fVOOFFYCp9wK8QPzWapIqu95SyLdHKDSejZjbvONwvzif2SjIfMu/3kpBF/+Akg0/s5x7JxW/ZUxoLj/bCqLHZMQLOY9m2bZiiHrosftIt31TuGod00AgzH7BNsabpwHPjvg++1lsZm9S5CQaazLi99U+8uhnt1zTtzG+Wi4nh6XkIk4wvW5S4J9viuQ/APONfJQvCB32DpOGj0Ku4JH1DuQ5RwG+sLgnf63iohFy9IhrWNLpAcDx2I2fMBrYCE630Kcu2Lc3KcNM09XFxfwpiMi6ER6qr77vI4NZutwKbem+nqWb5GN0hwxm/NYuuWiS02zKOw0cC9E/HOCWOIrJLxnD6pbu5VGrMGqJJCYU6ca1oaI65M/yvD4/M3aCeSGLyJPu5DCU34qqLNB9Ul5xBK5gJS4XVGSVenvPwHVGOmBE5TzNGNIgIVFmwvcRfZrop0ph7bW9c5VarxSYA/WATAvEAbo0Kgkt7fsB8tVsTUCgMW3nNmM6MTWwnK4qke59fbbP9H/BN1neCCYAT2WBBFLhOnMoiotolyX9Og9jB9BqEv4/99km+wAUVcNlket/tgPo2MQOXB2NjSZMo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(6666004)(6916009)(4326008)(38100700002)(956004)(52116002)(2616005)(86362001)(16576012)(5660300002)(66946007)(478600001)(6486002)(66556008)(66476007)(8676002)(38350700002)(16526019)(8936002)(26005)(2906002)(186003)(316002)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?akxBMWdod3paVGNDaUhNZlRCKzlKM3dMQnlIMFJHTUhaS0sxRkN5Mmd4REZZ?=
 =?utf-8?B?cEM0aWdPRk1xUFMwbU1mWDdZSkNJL0piZ3Bob1FxZHR2bVMwMi9nZVc4eVA2?=
 =?utf-8?B?clQrY2x1MDRScnVDRmhwNUhEeGh1cVphOW9lK0t6N2JvUGRxSDRZcVE5S09m?=
 =?utf-8?B?NHdvYk1FQ21yVkVTZVdiaklBNEZXdldFSEIwYzhRUW5LSVhHRkF6UHplWENT?=
 =?utf-8?B?SFMxTTdHVHk4S25XUDNoTFJleTZVM2RxRklpQjFaay8yWi9EWlBQaVhqWExy?=
 =?utf-8?B?cG4vOUlFdU02ZXgwK3JMYURGTFVxWVhISTZkOE5BcUd2REljZlkzdFI2ZHRK?=
 =?utf-8?B?N0ZUWHBlOUZJQlBYUGx0SzRPUzgvQXd2eXRaNTI3bnhKbXV1UlZ2clQ4R0t5?=
 =?utf-8?B?MGJTVU5zN3o1TUxOSVNlcDI1TFJGQk1ZZ0Z6RW9ZRURESFNmaHR1YzROTmZJ?=
 =?utf-8?B?dXcrWXN2NENPRC9VaTRoOHBwSEZ5bVR4dzFuclI1TUxkZGFjemZKYXAzdTE4?=
 =?utf-8?B?b3hScUpTcUNvNmg0YjcwYzZtRnNBSGxmKzN6eFp3UWNCWE1RRzFOY0s2TU9m?=
 =?utf-8?B?b1g5NEJvSHR1WEZwTW1mNUpWdTllZGlqZ0FLN3d4eVJvTzhqYlJJWVorS2ti?=
 =?utf-8?B?czk0M2w1NVV4d3lmZmJGSklKck1nZ2FKVXc4NCtGcUJ6a2VsbmF1V2JmaEE2?=
 =?utf-8?B?aDVnN1ZjdkxCWCtLZktjZGZtTlMxdDNIY0k4OVFJd3E5NFo1RFhBaDNUQVQv?=
 =?utf-8?B?TGVYMXJCQ3d3RzRtbDM2YTRieXRMSVdTNmZWM0NoQlNDZEtTUC9EMTFmd1dy?=
 =?utf-8?B?YnEwL0p1Qm1RcjR1b2hHOUU4M0pkUDBjU0ZUMFlWRlhkR05JK1FTQ2E2UW9Y?=
 =?utf-8?B?dGkyVzh5NW1YRXVROG1OSXBtd0g1S3k0NmI3ejdiNk1QWmpnL1d0WXpEOEZS?=
 =?utf-8?B?SnZlY2s4UDRSbDVmQU1QUjlEaUJhTDJ2NzJ3Z0E1OU5qdW05SDJ1MnNHSFFK?=
 =?utf-8?B?eUxiM0MrUGkxRllqRFJaMkpURkFpZ0srRFFMZ0FINXBhV3Jlb2I4VG8rZGFM?=
 =?utf-8?B?NlU3dkJCUFl4cVM5ZGEzQkZraEtOVDNneEd0MS84V2g4TWp2WW81eGt2ZnF5?=
 =?utf-8?B?d1JSdkdJempCR3M4c0Zuc2ZlYkFTRlRyZ1VsWTR0V3l2L0VvMEtTYkc2SFdx?=
 =?utf-8?B?OHMzMC96NisrRWgxKzZWc1IzNWw2ME9sQTgvMzJzV0YxeHBJTE9KLzVyQ3BJ?=
 =?utf-8?B?T3pqNU95alhSMnM0RmV1YzJrZUp5MDlUWXk1WEV5cjEzdkRrdDQ0SzJmN05M?=
 =?utf-8?B?aEo3WHFDVm9jS0tPVEFLQjlNTGhHSUtuVGVXaWxxOWVmVmwwUzFyd2lyd2sw?=
 =?utf-8?B?bmQrK3F2ajBYcGVoQkdPaU9oT3BFRG9GMk53SGYxWEFCdlhYTkx2VzNJekxy?=
 =?utf-8?B?S0U2WnhHWVJncEIvYjZZQUZSMUhTWEZvUGxndDMyVXc5bDI2VGN1dDM2S3FN?=
 =?utf-8?B?UG8wTWU5NFlaVy9SMmdLejJ3bHJsdUh5UXorUS9ncGg5VDR3QlEwRVBrb2Nw?=
 =?utf-8?B?U3VrU1lCOW1jYzZqUFBCUDgxaFVROGFRQk4rVnNGNEYrYUNheGdJUkNjRDJZ?=
 =?utf-8?B?WExYcndUZit4M1FYOUtLMThNVWxzWXJQQmdpYUh2ME0vWFZKNk9NNFdkVFkx?=
 =?utf-8?B?emNwNmZuaDIyd29jeExjcVcydStsc2Jwb0RlUlRkRENlL2hoaG5ESXVCdzg5?=
 =?utf-8?Q?Fn1sRuzhb+54eug9koHw5XB5qGYGEGPa1z80XWM?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1193bb3-941d-4f0a-e86d-08d8fdbcd0d3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 14:11:07.5280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ohT9cZy/VZlj9ASSJGJTPKRcHtsUK4m459/qcqhFuOnYa7yKv/sdLYnwgu1mmodXOU4xpJl7ppOjiRUJDtYLjNuCRTHEpNvijr3qwCMuQA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7198
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-12 at 14:57 +0200, Andrew Lunn wrote:
> On Mon, Apr 12, 2021 at 01:02:07PM +0300, Radu Nicolae Pirea (NXP
> OSS) wrote:
> > On Fri, 2021-04-09 at 21:36 +0200, Andrew Lunn wrote:
> > > On Fri, Apr 09, 2021 at 09:41:06PM +0300, Radu Pirea (NXP OSS)
> > > wrote:
> > > > Add driver for tja1103 driver and for future NXP C45 PHYs.
> > > 
> > > So apart from c45 vs c22, how does this differ to nxp-tja11xx.c?
> > > Do we really want two different drivers for the same hardware? 
> > > Can we combine them somehow?
> > It looks like the PHYs are the same hardware, but that's not
> > entirely
> > true. Just the naming is the same. TJA1103 is using a different IP
> > and
> > is having timestamping support(I will add it later).
> 
> Is the IP very different? You often see different generations of a
> PHY
> supported by the same driver, if the generations are similar.
Yes. It's very different. I know what you mean, but that's not the
case. That's why we decided to write a new driver from scratch.
> 
> Does it support C22 or it is purely a C45 device?
It is purely a C45 device.
> 
> > TJA is also not an Ethernet PHY series, but a general prefix for
> > media
> > interfaces including also CAN, LIN, etc.
> > > 
> > > > +config NXP_C45_PHY
> > > > +       tristate "NXP C45 PHYs"
> > > 
> > > This is also very vague. So in the future it will support PHYs
> > > other
> > > than the TJA series?
> > Yes, in the future this driver will support other PHYs too.
> 
> Based on the same IP? 
> Or different IP? Are we talking about 2 more
> PHYs, so like the nxp-tja11xx.c will support 3 PHYs. And then the
> tja1106 will come along and need a new driver?
> What will you call
> that?
>  I just don't like 'NXP C45 PHYs", it gives no clue as to what it
> actually supports, and it gives you problems when you need to add yet
> another driver.
Even if the PHY will be based on the same IP or not, if it is a C45
PHY, it will be supported by this driver. We are not talking about 2 or
3 PHYs. This driver will support all future C45 PHYs. That's why we
named it "NXP C45".
> 
> At minimum, there needs to be a patch to add tja1102 to the help for
> the nxp-tja11xx.c driver. And this driver needs to list tja1103.
I will make the changes then.
Thank you.
> 
>     Andrew


