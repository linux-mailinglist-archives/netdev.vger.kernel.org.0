Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4163481856
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhL3CEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:04:50 -0500
Received: from mail-sn1anam02on2130.outbound.protection.outlook.com ([40.107.96.130]:50702
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232768AbhL3CEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 21:04:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gmw/SOldxGB3OE+wB5zqLv/gr7EMfSj/8wbGu6V297IkscafhujGogpNF74C2Sp2EpsH4cD1ZPHrcjututW9ReGJDd36OvK18tA8GM3BA7eoc+sz/VT80wtgdPa9RAAoYp4IOQU0xSAcihV1efv7MeJ9C26w7Ra8n94bSlpvIBM3UFz4ChF57++TM2/CwhMCRQ6JGt486XhGl4Q9kGiUHEAXDC2T9S23oTnveyJZOEhUT7EW3grDxmSf/nTUFaSQMCOJQpG2Px7tEXOossYAy7JTJLgWL1VeE2hgMgaEP9jjdClJpNxHacDRMcDzXU792Fb9s8vpMuZ7T0Y4mfNW3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IO+7SCb0mZEMVa22973at9EoZRcXzSqsexlYpAK3y/M=;
 b=VIy7+k1+qKRkSKCXdWsnfmK4pVGhnkFA2vIQiCzp0ITl7ysdekbecxImv/6sc78ahAfyXWqUlZ21yYBKBrmee/w0EES38tEWbG9V1THn1JMOHsprp5XR09tcQf13ZOxouySPwc/Kd7B0UrxjcINsPDBPiHdN63gULf6wzWMkAEjrRx9kSmosupiwXlpKvY60GD/ufm9fDxn6QTozqvELWT05sXYTjLV7wXgbtDUJEwhcUC466LO7a5PCfXzqzVcR6G/STT5TNM9kj6Z5ZoCtH+NSBHjzMvfmOWJ2lhbrwu4edT6UGmB4L7E7Fj2ag1EzY8Tf+z/QCkzn/+4YQYrYng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IO+7SCb0mZEMVa22973at9EoZRcXzSqsexlYpAK3y/M=;
 b=ou3Cm2KFjb+6oaOYa3QJ5Qg/zUI+gs4M5eRtnyBaOnsb958rKAdSZMkHDPrGRVDO7XKDoMes1voGQIeBJbGI888nzmOinyBPG/01vCGvCfNbBr6f4PYSswzFTFiSGBNxW6oS2xIhg+cDqzVufGYlH2YduQredGy5RNAkOzaSVAA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1696.namprd10.prod.outlook.com
 (2603:10b6:301:8::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 30 Dec
 2021 02:04:45 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4844.014; Thu, 30 Dec 2021
 02:04:45 +0000
Date:   Wed, 29 Dec 2021 18:04:43 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v5 net-next 08/13] mfd: add interface to check whether a
 device is mfd
Message-ID: <20211230020443.GB1347882@euler>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-9-colin.foster@in-advantage.com>
 <Ycx+A4KNKiVmH2PJ@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ycx+A4KNKiVmH2PJ@google.com>
X-ClientProxiedBy: MWHPR1701CA0009.namprd17.prod.outlook.com
 (2603:10b6:301:14::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc2add18-a4a6-4900-7862-08d9cb38c052
X-MS-TrafficTypeDiagnostic: MWHPR10MB1696:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB16964072BA7A1B02077D39DFA4459@MWHPR10MB1696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dLPvtUqT9s8uHHkiX9igK2KVu6uKwtnkda87o9LX/o45j5n2IUrhz6UP26PulMPtr+6ONZeNVS1tD/bpKrihQ3m+LkYWVFTqZXDuC35+u/G/UTrMx0x79OmO9sK00igoB2EDWNYf/EAmY7R3WREvjvK6uvhzt+dKUj4aL0gjrW/OIhX4IAdAV5iWGAtvRuMi9MZb0FwgAT0k/f4zVcNOXjcjdb8j5PR1JDyVaRsmmjYMbYHoDuBTUgMwa8fj2SeJWxms3zGX+5LFFgn7yKZ4wiDPZsyOP0lIGHWpPHTvsfAkjdYHkK/7c5//E242hsQ2cj73umTlse2RkZWBb0X2gDMy3CPQPqktK4vxStkiNFeQ6wNjTnvj1y5WqmSHxrkE9k0oODzFWxmu3FsYHqmxlBjL3mHV/1nG6bz3ahBt8QQBOtGRedBdVCNzMHARB7ngQ9+an7AISSEeRGgS2rhr3ZPy5pJg8/ETBgqYhWa9UZB2EoqAVwcJh8r018mz+sE85YjJoHU8oBfLXWep2lETseZTjYtCPsOvt6FrPtijfgvEI/nRix0qnlYTq5oxvAzkYh16Y9cS3TpSOW6sol5LovhY901lhG8r8vY2zjdD40iP6C/6no/pPYSeNUWdiZJ6seQY5LNC08AYtKxXrwUstc7bOzIVQI0eAn1jpRhExoy6+x7wTyAzQHR1HMos2DdwqTvcQ/UTtWBJTo88ExgqVryClkEZRxJRZQmUjjrRYoKZ3mirLsKqoF3XgTlW3aUEkwEu1T2bPMmezjJ7v+ciFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(39830400003)(346002)(396003)(136003)(42606007)(376002)(366004)(52116002)(44832011)(66946007)(6486002)(9686003)(6506007)(33656002)(86362001)(54906003)(4326008)(66476007)(83380400001)(66556008)(186003)(38100700002)(1076003)(38350700002)(33716001)(26005)(8936002)(7416002)(6916009)(966005)(6512007)(5660300002)(8676002)(508600001)(2906002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWw2Y3VzTTB1enhjTVJNOWNSNVBGWGgxTFEvWDZnUnRjQ2djbEc2ZFdkeEhF?=
 =?utf-8?B?YWhoL1l2bGF5b3JjTVhVcjlWM0hQL3g5QnJVTDNVOXhnaFllY255Sk9kQjRH?=
 =?utf-8?B?blE5ZTIvWk9kb3RDdXpGUjA2N3VkZWw3bTMrcFZkcmp0bExPRkpmZE5ZNDJx?=
 =?utf-8?B?cUlRVms5dGRqeGk3cHNnbGV4SnZkWjRVUC8vZjkvOE94NlFCUE5kN1FDN2tB?=
 =?utf-8?B?WWJYRHB5TG15SFJvcUZJSUpKSmErWm8zdit1MjlxOTZTK21SL2Uwd2Vtd1g1?=
 =?utf-8?B?M0dGRTJQcGlSMGRVemdZN00wbWMyMnZwODlaWWxrK29HdTcrWVE2UFBJSTEw?=
 =?utf-8?B?WmpFWStVTHNZRENxMU5oRTA1WERVSitUQUxpckY1emRCWWxIM2MxbmFuV1hI?=
 =?utf-8?B?OXV6dHZpd0tsOW54NjJvWFY1K3dRWm5JNDJTeXFxcGRuWkVMdU5JUkptZFJR?=
 =?utf-8?B?SmhlUmZwc1l6QVp2TXVVRkRaWFZYajUrTkV6QkV3NE5FTDlzWkc1UG9CcWts?=
 =?utf-8?B?M0REaUlHZjQ4MWZxYVcrUnF1VUNFek9VRFR4MmFzbUtYLzVlVzJpR1gxK2Fa?=
 =?utf-8?B?dEJIS09PRHNrQmorRE5za3RYbnorSmwzeDIzcEhiczYyQkxnRHpmQkNKSmQw?=
 =?utf-8?B?cXh1UW1GTkN2dE5CQlc1VjhTOE1jSnBqYk8xNFpSd1ltbnFLZm0wQlB2aTVq?=
 =?utf-8?B?eTQyR3Z5Yis5cTUvYzE2c2FoY09zL3J6WnhmMjJaNU1jMk9lRE9YLzcvTGI5?=
 =?utf-8?B?NmhvcW5UbDlIUnA5MzUvbXFRb2JLbXVrZFJCL1l4VVJwcmd0S3VHcnY1dkF1?=
 =?utf-8?B?cHUxVGdrdGVXMStFckR3ZWt4Tjk4RGk4WWR4MXQySTRWTlVmWlNad1NmQzlh?=
 =?utf-8?B?dUxVTjQwMk1LaENUQzEvR1daTWtBVmpUeDBGS1lEOEpmdWlnUTcwZ2Q5LzR2?=
 =?utf-8?B?Tk9OeEdDaS9jMXFXbXd1aWJtdE51T0NpVGErMFN5TzdUbEFzRTA2M3A5L2li?=
 =?utf-8?B?OWVVLy96YXhOdzhmazJuZkpjQWtGQjBSYXprZlZyMzMxWkNiN3llaWxxOWxp?=
 =?utf-8?B?NnN3RXpFQ0VnQjNiQjRnT0huamVuelpoYkxSalFWUmhxRjNzdmIvTE85ZzYz?=
 =?utf-8?B?eUtPZ1RKYjRIOGdiSGlBQnpNRXkxWU9wUUQyVVBNSisyQUZjMW1rVEZ6SnJC?=
 =?utf-8?B?SmxFQUN1eHNySWtzK3FRZlh2ejJ1eWxYdUcwaGxBaGNjMDFEaWRpM1BzSnpX?=
 =?utf-8?B?NEZvMDNSWjdtSCtPZ0dJeDdSZkN3bVd4L1JMaXhaVUtSZ29uQ2NPREVsY0hV?=
 =?utf-8?B?V1VBc2c2WklBWkVLTWpTckx4bWVvSTBlN1lvUklwRkZOVW53ZVJ0YkxmdEZY?=
 =?utf-8?B?Qk9pZ3U2b1F0NndETzVYekFKOW5BWi9sYThFNndXMzBleGdpS1IwTGx3MHRK?=
 =?utf-8?B?V2laK0xGYThzOHcrRzBiNGJCdkhuK3ZQUGI5a2VLSjJIeWpnNG9HSHA2Q2tp?=
 =?utf-8?B?YmJlaVR0aGkvNmRoNjFvb2o2dnQyb2I0M0Q3S2wwWCs0ZldvNTltTE5zNjNC?=
 =?utf-8?B?UERjV3hwbzBKNWE1VkJGSGtlWHJJUXJDeDRMakF3TnlHRzRUV3BxSDFDV2Qy?=
 =?utf-8?B?bWh4cmxGd0hxb21QcjhSampGb2VrbkMxNDl2ditWbTd4bVdqVkVkMkRwQmM2?=
 =?utf-8?B?MFNCT0dUMGpMcG00clBwcE9xMERvZ3V2dHNiSmtpMlR2UkdKaC8yc0hJSU5U?=
 =?utf-8?B?RXBUdVFqSWZ0V211SFFwc0hCNzZGdFg5YWlhZDdqK2ZsdzkzNGZIN3hDNU9N?=
 =?utf-8?B?RlRFS2h3UTRraGRJRGovMmxkNUp2cmJNTU9VeHlhanFRajh5eXlHamNhNis5?=
 =?utf-8?B?R3o3b2JZYUhJb05VdFZTZVNWY2FZK0pYc04weWN4eHVZVkEyOC92Vm92d0JU?=
 =?utf-8?B?VDhMVE02dy9RQWNhTUNXVEwyVm1TRWk0SVFZSml6djFoM041UnVuV3Z2QU5u?=
 =?utf-8?B?b3ZYWjNJcHYrNXZpd2ViY3VvZGxKMERQVHFBc25mUDZlZGIzZnBONm9RbS9Q?=
 =?utf-8?B?UjdPSWszVmlldjBqOUt1WHFMK3krVkdpYzBZanQrM2pEblljaUFiN09JZ3Ni?=
 =?utf-8?B?TEVpeHJVNzUwNW93ejJJYmlBSTFpUVNQK1AxNzQvdFA3bFJWL0F4aHpOd2Fr?=
 =?utf-8?B?bWl6VEpEd0I2RitoczNOaU9ORUhST3ZGQk1YSXQzSW9WRzc0OTZmVEFKL3J6?=
 =?utf-8?Q?4+E0D2vXapCGAO0/41f9OtNPsAxDRAKfu5PIyn9hNs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2add18-a4a6-4900-7862-08d9cb38c052
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2021 02:04:45.6748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hmOvsgonoauFAqDF1rmiEFAf6R1h+msoretD6wsK4RxwAn1IEpNaUGLhXI1BX3B9/WALBfngTkt5m13rD469iy06MXHHycDSwRFb0QFGOeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 03:25:55PM +0000, Lee Jones wrote:
> On Sat, 18 Dec 2021, Colin Foster wrote:
> 
> > Some drivers will need to create regmaps differently based on whether they
> > are a child of an MFD or a standalone device. An example of this would be
> > if a regmap were directly memory-mapped or an external bus. In the
> > memory-mapped case a call to devm_regmap_init_mmio would return the correct
> > regmap. In the case of an MFD, the regmap would need to be requested from
> > the parent device.
> > 
> > This addition allows the driver to correctly reason about these scenarios.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/mfd/mfd-core.c   |  5 +++++
> >  include/linux/mfd/core.h | 10 ++++++++++
> >  2 files changed, 15 insertions(+)
> > 
> > diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> > index 684a011a6396..905f508a31b4 100644
> > --- a/drivers/mfd/mfd-core.c
> > +++ b/drivers/mfd/mfd-core.c
> > @@ -33,6 +33,11 @@ static struct device_type mfd_dev_type = {
> >  	.name	= "mfd_device",
> >  };
> >  
> > +int device_is_mfd(struct platform_device *pdev)
> > +{
> > +	return (!strcmp(pdev->dev.type->name, mfd_dev_type.name));
> > +}
> > +
> 
> Why is this device different to any other that has ever been
> mainlined?

Hi Lee,

First, let me apologize for not responding to your response from the
related RFC from earlier this month. It had been blocked by my spam
filter and I had not seen it until just now. I'll have to check that
more diligently now.

Moving on...

That's a question I keep asking myself. Either there's something I'm
missing, or there's something new I'm doing.

This is taking existing drivers that work via MMIO regmaps and making
them interface-independent. As Vladimir pointed out here:
https://lore.kernel.org/all/20211204022037.dkipkk42qet4u7go@skbuf/T/
device_is_mfd could be dropped in lieu of an mfd-specific probe
function.

If there's something I'm missing, please let me know. But it feels like
devm_get_regmap_from_resource at the end of the day would be the best
solution to the design, and that doesn't exist. And implementing
something like that is a task that I feel I'm not capable of tackling at
this time.

> 
> -- 
> Lee Jones [李琼斯]
> Senior Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
