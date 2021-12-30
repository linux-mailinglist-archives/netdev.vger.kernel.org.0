Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7F8482032
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbhL3UND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:13:03 -0500
Received: from mail-dm6nam11on2109.outbound.protection.outlook.com ([40.107.223.109]:17891
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231890AbhL3UNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 15:13:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMfE287yTOx5QLbXQsSaElIbCmFBK3fombMICQLH/USPXkyJ3nBlpOb82UdkzTltSYPff2TUEtu3z+HvFxA8xEm8l2f6LqdGHugFJEWzEFGpXYzxVmoAY4yfeJ5OIRw1AKNgjw3slZdyEz4CljmbNHdybwl4B4mFUwfigIrqRXjX3veVdqiiQsh2euZ5wmEvbxTtCpthboLcIkqWgarxAzljU9qIONCgvYGciKCaky1qgATm3hAM9AOLoVqoQhMRngbSfTMHKeZNDe4MmcHYcoUvZAAYKwXCZ6HKu5dB1Mb9R0bdsLeIQ8KI9O1/gye1A0wNVQ4SZ1nFkJcGXMV4ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l7ynpy7r4oAZJbVbH3YfQ4V34O1T5PB7L88eZ7kk0bA=;
 b=RkYUcBER8N2HZOtpwAbwLW6yoiI862wIcqHucAn/w9pHamCHggyT++88uDQAEvY1c8l2O3h8rtP6lmFwnndXxnKDRgdRsB8waJRENbNLloqC8aGfFY0hu+jzFWetZXIo+hKHGF/R4LxEEiCrvUMeA714nmIHPBty6rer/A9uPw/3rwyPAAKoOcJ4is2Cjj4OpvS8G7Nnfr7ZKnq0QqLt6sWWOYaNAi8zwBwSIiI4kpvV+ta4qBdtJyE8xK0UFs3tvVemcFm8WlU5s7dCWVTQNORt3MsOdIyEttZyL+6X71L1uthX6GNa+lVFEJNQ/fUBSo6+7CIS3MAnTZBkC9z5Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7ynpy7r4oAZJbVbH3YfQ4V34O1T5PB7L88eZ7kk0bA=;
 b=Z0CqQZ58focMDtGVvl1bIPTOIPRn35R5yT5KJZ9y5HpVbdcUc6YmeVtd752CHIdngPK0RcXc+dX4IQ4e+pWD9B9kjHM/vQqTtX/AnU6thu7e17JtPO6gu5iKrKvLAxQzLpgFDVAITSV8/yL/2GllDLuk785c/wYbpvlc+3585lw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2173.namprd10.prod.outlook.com
 (2603:10b6:301:2e::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Thu, 30 Dec
 2021 20:12:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4844.014; Thu, 30 Dec 2021
 20:12:58 +0000
Date:   Thu, 30 Dec 2021 12:12:53 -0800
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
Message-ID: <20211230201253.GA1484230@euler>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-9-colin.foster@in-advantage.com>
 <Ycx+A4KNKiVmH2PJ@google.com>
 <20211230020443.GB1347882@euler>
 <Yc23mTo6g1tBiMjT@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yc23mTo6g1tBiMjT@google.com>
X-ClientProxiedBy: MWHPR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:301:1::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82ec0a27-a80f-4435-aa75-08d9cbd0c564
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2173:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB21735543467AEE3E403457C5A4459@MWHPR1001MB2173.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmIuvDuTo1PO4XinJvOvPyANsjOtl1BKa6zdMm4n7eMBUFNYJjdQjlmQ8dSSIbiI1g1C12SnEQUMU8O+2riipTq+iwYMzfNLyTu48YsPoWHSYFB4mUQikl5dZfjoUdBN1u9hShsKrsjRw11mgeg0dhq0tdsLz+5tMGrGXDKwhM6T7l8eQ9kxD09qDSwuVi5SiINTXrYTTwuQ9cxxUScQEGrttPmi2jR+cID0EZT+V//8d9oMbsdPcMe+8Ov1Z1CiJti0XxkLyUQfkPOdRhqj9RXnhkAc/HHL0cF8Q6K2Ql7cKBaFkwVhKE/6yfWFqmYtERUJlKvtLarlDnrU8PUHvzoaXyEXJWB2TTAo4fluHmGg6XX5ALrsfOyec1+Hf2oUGvAsEjSzV45bxL7cTBWFHMK1Fvq1l/b3Td7/PVpbO5CXcJ3SqPA3WTRnRpLZRJFdJ8vfbJfBxLinWm1xXt+j2h1tOL1FDJRUdbrp1g8sSOPmQu2jStC/rKRJBjo9akthFhN20Q/lpDz9KJExZHYpJQf21hKrgJG58NWYnPCTRKu629MuXliY5UQISQVORQozupLPKrV0D3CIXjuR/zaCyXWKJVgRSe8G6yCgH+B4ttBnIJKnqW8jlYLryrmNdNwfTSVjyAYZJUgaJY5Ao6GISmf8jsAE+nwR7nuIKEKw4ksYUi89BppsjufMv4QvIla5/9xm9RXOdJXyu3gx6Xw8oTdaDnFOye/0t4jNZ+rWWBxDzC/ROPbEhE2SEhV13WH3O5/mdrG8PnFhC/EcuSMbeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(39830400003)(366004)(136003)(396003)(42606007)(346002)(376002)(83380400001)(44832011)(52116002)(6916009)(186003)(5660300002)(6506007)(7416002)(8676002)(6512007)(33656002)(4326008)(66946007)(66476007)(966005)(316002)(9686003)(1076003)(38350700002)(6486002)(66556008)(33716001)(6666004)(26005)(508600001)(8936002)(54906003)(86362001)(38100700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bW5yNkZEcGlsdEdBa1l3VDExODQzcW9ZTCs5UDdESUVjWGVENXZLd2pMcXM4?=
 =?utf-8?B?TmlBM2o5WU91MHJsNjVHL1dnWnQxNi9oREx4TkpobVMvMnBtbUlmbmhvdlVp?=
 =?utf-8?B?NkM1Q29VR3hVSGlzTjRSNk9GbnFGZ0JaVkVuYlQwRDltemFtYXNXTGZnN2pl?=
 =?utf-8?B?Z2dTd1ZScW9xdTJHT2tLTGxwc25iZi9RZmtYRnlwNmVQYXFxQWs2NTJLcVRR?=
 =?utf-8?B?T09SRHpKMHdNNlhzSTNEME1GTVlBU3UwYWd2SGs3UFFTd2h5RXd2bkFPcGRF?=
 =?utf-8?B?MmhYQzBIKzdhcnU0VDhJNUU1NHNYcVBZVGR6L2tGVytvNE81RGhtMjkyN2d2?=
 =?utf-8?B?U0JwYzRCY2h6OGp2QUdFQk9XQ2VHdjZhYkQybmkyS3lvUlI4U2I0VndoNUpw?=
 =?utf-8?B?YUJjbXpuYW02c1JGQ29BQTM0amY2cUxKVkxuV24xdG9OUTlxVUVCZnVVaFBB?=
 =?utf-8?B?Y25heGtsS3ByQzhQeUhBbXpVYW1HbjIvQjRkQ2tHcUwxekM5VEJ3RmlaUXFl?=
 =?utf-8?B?S0tDR0dQODZuWGoreCtJc1lZR0xLWjMyNzVuWVk1eGl2Tm5nUGhJSTRkSGEy?=
 =?utf-8?B?SlRJbTVHcEswUDBLRHk4RW9zc25hTXMzT0dXdXRhVU9aY3kwbllYZVlISWtD?=
 =?utf-8?B?TU1vMGxXWnZ3eFlmYXR3c1EyZTJ5cFgxMk9hN1gwUGp6UFQvNzh0WDNTaG1z?=
 =?utf-8?B?UlhXYlROSWlwTmsyc2E3bzArT0xDanlFWG8rdW1HdEhtdEdIMHlsb1A2VU1K?=
 =?utf-8?B?aTJHVTV4QnNXaVA1WHNlbzBxNmhhNGR5Q3R6SmRrYllUQW1xR1NqR2E1dngx?=
 =?utf-8?B?QW41Nkl5ZEVESnNVOTVLWjZ6OEJCY1pEOHBlOUkrY1RkRnhwRHFaZEZ6dGZU?=
 =?utf-8?B?SFV0SzltQVhsN2JlcWhoNk95Q3pQeEo0eEpkbDZOY2ttdDVCcWZVVXlCNFVE?=
 =?utf-8?B?c3htaGY0K2ZjOVc4Zy95c1gxUUNXRHhkVndrOGdNdzNVVUZRbm1UVWlZNnFT?=
 =?utf-8?B?N28yMCthK092SWpER1dZckRwcWIydjd2dm5CNEVlTzZBWWQyVisrOW5xUEFF?=
 =?utf-8?B?UzNhYndFMUZyR3M1Y2prejlmcHpmMGNtaDJRMS9nWFBabERmNitMa2NzSHVC?=
 =?utf-8?B?T3BIMU55ZHc5VlJYUjVYbFl1MGtFcGNvYjhvK3BrczQ1bkVJYzloZG83cWFn?=
 =?utf-8?B?VXJ4UW1peXpxa1NtbGlXaEhURGNCQXI2dXNFbHl0bC9kY2NyK2grSXJ0dWJK?=
 =?utf-8?B?UXd5V29CWkZSWE5TV0VxU202WWZ2eENIN2gyM1BzYWx1dzdHTzN6aERHTHQz?=
 =?utf-8?B?WG5FajlheWRsaXpGWTVLYi85dkN0dDV2WFAwbHFydHB6dFhINmx5LzVrRDA3?=
 =?utf-8?B?cWpFZUlqNUEwQzRDam16T2htMXlKNHpxN3NJZlQ3SmtGQzh6WnNTck5nYnNw?=
 =?utf-8?B?SUxnNmtHLzdBTEhETkxwQm01TGNiK1V2TXNuUDJITzJpU2t3dWdmZzJ6NTYv?=
 =?utf-8?B?WERpaU8yaXRkejViYVFRTThwMzYvTi93QUJGQzR4cHpqbkpEOHhsYWc4bHd5?=
 =?utf-8?B?QXliWFVCcElYdlF0bFNJOXJnajEwaHZNRXRLZGoxcVVWcWhZN1JmZHVIMW5N?=
 =?utf-8?B?SmR2TTg4bWI0OFUzTjFJUUZLOG5ta0JIdkYrazVhNmVKWWtwVlNVL0wxWWVn?=
 =?utf-8?B?YUorNS91UzRKVFQzNjBQbngweWNTdXVxZ29TMGh5NlFRdXRWck1ITlNkcE5w?=
 =?utf-8?B?UVNjVFlBQktCZWFtWENFejZZQkFZcWRRUDBqdm5pMXhvWjBKRHVjRExGTjBp?=
 =?utf-8?B?RWloRDQybFBaeFAzR0p5SldHZldRYzUwTmVCaXkvL3BBaWZlSWZuaytVOWNy?=
 =?utf-8?B?RUxqT3IwNEFPMTVqVFprMmpNTmp1bmsxUzZwTi9qRmRmYWJoNE5jN3J2WkY1?=
 =?utf-8?B?eTB6V2JVQVRlWnNndE01aE5PUysvNUNiNFNWek80NmdsVlp1V3BXenFFYWRn?=
 =?utf-8?B?dkh3WUhOcDVGWThPSkFqd0tFNHhRYlFuaXc4Y29ZS25oMlBBY3p4eEg2aURS?=
 =?utf-8?B?VCtoc3ZKUTNxVFc1S25Kem9jRjM1ZzlJQi9uQnlCMTlpSWw1Wld0Q0d1MkJJ?=
 =?utf-8?B?S1ZNSGpxbUl4RmwxRHdWMTZPL1k0ZVpBTC9UKzJ0MkxFL0JjV2FaQ0Fncyto?=
 =?utf-8?B?UmlZWk1OSzFyRDA5b3VJbWZEVk5ySXNIK0t4U2ZpZkprOVd5Rzk2bUc0SmZY?=
 =?utf-8?B?QTh5M3F4RE1zQ2tNUFhGYVBDTXhRPT0=?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ec0a27-a80f-4435-aa75-08d9cbd0c564
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2021 20:12:57.9355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lp/OOP3H9uo9nxlunogtZW8qQSI78SNz9NFRAbsaH/AA767BDGB7Oh9hck5xjkTdIHHO0qKoqT4uMsmc2kun8VtB4wOvAOXiDahFT6amJY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2173
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 01:43:53PM +0000, Lee Jones wrote:
> On Wed, 29 Dec 2021, Colin Foster wrote:
> 
> > On Wed, Dec 29, 2021 at 03:25:55PM +0000, Lee Jones wrote:
> > > On Sat, 18 Dec 2021, Colin Foster wrote:
> > > 
> > > > Some drivers will need to create regmaps differently based on whether they
> > > > are a child of an MFD or a standalone device. An example of this would be
> > > > if a regmap were directly memory-mapped or an external bus. In the
> > > > memory-mapped case a call to devm_regmap_init_mmio would return the correct
> > > > regmap. In the case of an MFD, the regmap would need to be requested from
> > > > the parent device.
> > > > 
> > > > This addition allows the driver to correctly reason about these scenarios.
> > > > 
> > > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > > ---
> > > >  drivers/mfd/mfd-core.c   |  5 +++++
> > > >  include/linux/mfd/core.h | 10 ++++++++++
> > > >  2 files changed, 15 insertions(+)
> > > > 
> > > > diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> > > > index 684a011a6396..905f508a31b4 100644
> > > > --- a/drivers/mfd/mfd-core.c
> > > > +++ b/drivers/mfd/mfd-core.c
> > > > @@ -33,6 +33,11 @@ static struct device_type mfd_dev_type = {
> > > >  	.name	= "mfd_device",
> > > >  };
> > > >  
> > > > +int device_is_mfd(struct platform_device *pdev)
> > > > +{
> > > > +	return (!strcmp(pdev->dev.type->name, mfd_dev_type.name));
> > > > +}
> > > > +
> > > 
> > > Why is this device different to any other that has ever been
> > > mainlined?
> > 
> > Hi Lee,
> > 
> > First, let me apologize for not responding to your response from the
> > related RFC from earlier this month. It had been blocked by my spam
> > filter and I had not seen it until just now. I'll have to check that
> > more diligently now.
> > 
> > Moving on...
> > 
> > That's a question I keep asking myself. Either there's something I'm
> > missing, or there's something new I'm doing.
> > 
> > This is taking existing drivers that work via MMIO regmaps and making
> > them interface-independent. As Vladimir pointed out here:
> > https://lore.kernel.org/all/20211204022037.dkipkk42qet4u7go@skbuf/T/
> > device_is_mfd could be dropped in lieu of an mfd-specific probe
> > function.
> > 
> > If there's something I'm missing, please let me know. But it feels like
> > devm_get_regmap_from_resource at the end of the day would be the best
> > solution to the design, and that doesn't exist. And implementing
> > something like that is a task that I feel I'm not capable of tackling at
> > this time.
> 
> I'm really not a fan of leaking any MFD API outside of drivers/mfd.
> MFD isn't a tangible thing.  It's a Linuxiusm, something we made up, a
> figment of your imagination.
> 
> What happens if you were to all dev_get_regmap() in the non-MFD case
> or when you call devm_regmap_init_mmio() when the driver was
> registered via the MFD framework?

I'd imagine dev_get_regmap in a non-MFD case would be the same as
dev_get_and_ioremap_resource() followed by devm_regmap_init_mmio().

In the MFD case it would possibly request the regmap from the parent,
which could reason about how to create the regmap. As you understand,
this is exactly the behavior I created in this patch set. I did it by
way of ocelot_get_regmap_from_resource, and admit it isn't the best way.
But it certainly seems there isn't an existing method that I'm missing.

I'm coming from a pretty narrow field of view, but believe my use-case
is a valid one. If that is true, and there isn't another design I should
use... this is the opportunity to create it. Implementing
ocelot_get_regmap_from_resource is a way to achieve my needs without
affecting anyone else. 

Going one step further and implementing mfd_get_regmap_from_parent (or
similar) would creep into the design of MFD. I don't know enough about
MFD and the users to suggest this. I wouldn't want to start venturing
down that path without blessing from the community. And this would
indirectly affect every MFD driver.

Going all in and implementing device_get_regmap_from_resource... I don't
know that I'd be comfortable even starting down that path knowing that
it would affect every device. Perhaps it would have to utilize something
like IORESOURCE_REG that seems to only get utilized in a handful of 
files:
https://elixir.bootlin.com/linux/v5.16-rc7/C/ident/IORESOURCE_REG

> 
> -- 
> Lee Jones [李琼斯]
> Senior Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
