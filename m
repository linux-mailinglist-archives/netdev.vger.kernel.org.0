Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD7A453508
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237803AbhKPPID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:08:03 -0500
Received: from mail-bn8nam12on2135.outbound.protection.outlook.com ([40.107.237.135]:40171
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237804AbhKPPHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 10:07:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWC/J7tfaN+Lsh3Wu7ghsjOgsGV4+R+cUNtAaWS0cOvtbNZeFqHhfiJjPWWiGxXk2DIrD8itUjrMLICQfB4tx6TLuFzZeYx8YL14IjKdpcel1tBc8fJZnKixlKhMBJvKcYh4IHbS81T1LZ8lh8Uuo61JyJ95g095fl5AaCsUUbDmhW4jkbsv0KhfMeGnbIoTqbZGePN/F2+gKvQta/rTQh1AIebYZXxZzzO4ak5ZIUcADuUeOsgnkAJOB5fJBXrR+zrZComYulpB+xrBN2W5DPwF8GC148CzS6EasqMzWf1LNDyxzBe7DkqLLJeWe/iGQdibVbRfxg3z9fxGQZVkpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSuPQ3d0tOED9bkhjCyHEX1WBQd3xts64ziWqYOr5zA=;
 b=j5WpjJUI/SB0gpfk8z9wTPdasF6vxnUCY+HyRltuYtUYkTMLa40fjPzejzdD2l9m4QilSuykgdB8j9MJJFW0QmF/H83r/4FtvEl6L/qDFQbnkB3iKHKs/N4PgRwcfVlYK7Gk5HCVZmvXSuNxUGRZTJinQDPJJj2pKMGWGZBHWwVzsWyaQFxGFSjsJfBE1/TfO1YiwfZSajY2pT/PAxHo0ze/9eaMRxTOp6iYOwyY+J5mTZjr8AYJfg9iqV64M2zmLvRuIqzS72DNquc4EPkh8HIR8/HQtomCAW+/u6zlaCrrcTL0VuqPqfFAXUl/G6oj1gZiAXVtjliE2hgdLS9fkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSuPQ3d0tOED9bkhjCyHEX1WBQd3xts64ziWqYOr5zA=;
 b=FukRBPwFkHPtng3v0YyPwy+sy+7CLEX/t63gMBp09hPn2J3ny0bPwzIFwvsouUJ1KkRew/m8AtKIIIzl8MgI4W5LLGqIKz0nqsCcvAWfV5cfP1cGnh0HqCeVMwybcV3bAKQ4gf7C1xBtnsXdnCjPwYQyxdCiHlvTpaOpRYsJXoo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5881.namprd10.prod.outlook.com
 (2603:10b6:303:18e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 15:04:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Tue, 16 Nov 2021
 15:04:03 +0000
Date:   Tue, 16 Nov 2021 07:04:04 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Daniel Scally <djrscally@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
Message-ID: <20211116150404.GA8651@DESKTOP-LAINLKC.localdomain>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <YZOJKZZSVQ9wvUTS@smile.fi.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZOJKZZSVQ9wvUTS@smile.fi.intel.com>
X-ClientProxiedBy: MWHPR22CA0064.namprd22.prod.outlook.com
 (2603:10b6:300:12a::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from DESKTOP-LAINLKC.localdomain (96.93.101.165) by MWHPR22CA0064.namprd22.prod.outlook.com (2603:10b6:300:12a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19 via Frontend Transport; Tue, 16 Nov 2021 15:04:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9622e6af-407a-443f-a8af-08d9a91253eb
X-MS-TrafficTypeDiagnostic: MW4PR10MB5881:
X-Microsoft-Antispam-PRVS: <MW4PR10MB58810860B2917518592B83E7A4999@MW4PR10MB5881.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: owseUeNYJii/ahoFWOk5RpdvL3KKDftjgwfgsQFLW5jn8tn2FvXGbmofzgavVsRaFqprV9z65yu5mYH9h0+Byco5cO8xk0Z6SwK4AErtTHD+lJhJKeaFIwsMeZm0Aj+UFfXeqUD2amcy6lRVbHHb/VSt/llGUbUUzpsJb6zEGiqAGfWlEVQQlqyksxiPBcY0jSmxjRWzi3bxY6T3aO3nOf+i0IqhwUR1Kr3vdGiTeKD1MRxKG0Obs0eaMFPm09hVsHWy+MkoZtwVDnXX0pYDoOqCdPY1J0k363YFzd9zlUCm7Djug/5Tfbo106oucPuKC3tTeGNjZTv72877p4HcjMG9OfZGZJYEyYiTDPl+nuTm1Is4YBUqNLoYvsl5ME+wBdYvpKQrXppjh/VQgb5ofWiQIvM/o3YWskimqO3CfvdcnE3K8N8BEM9gZ2+ovrnNyfa+J0kHPhGNDPVmIa4gEgXQVm+A+hBXO+xonTCP4I7djKBnLpyD3AiGYIBfZ9ozlr0eUlgKMOP/TIWVXP4izLHu6Hp3odLAUUpmGJHZ8ZRZZtsddaq1vbAPBcp2LEahGTf8FmL8FzpA1UeS05G30Wc2Rs91Ecu3PPZWTSXFbvjiUaK0qiXUX8JexOCFLnTPBB0CbbEythVi4zsJ3xZbTi/o4DVc6UeFGdPrR6ZB7JGhRD/TejHwmgAbPsIqd6ODHrAztnVriePotglyB0H5X+2yit3yI0i98s1O2d7wmMf13O3riscQqzCqjP8frQONKVdfGcgmfd2jG2/BuOn0otLu8XVdQgnEH3sEZUw8AIs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(376002)(39840400004)(8676002)(26005)(186003)(44832011)(966005)(6916009)(2906002)(66556008)(508600001)(33656002)(956004)(9686003)(66476007)(1076003)(52116002)(316002)(86362001)(8936002)(66946007)(55016002)(4326008)(7696005)(54906003)(5660300002)(38350700002)(6506007)(7416002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uMqtuto1VCi5LSGkfBjT9UtZfShD2d84DWnu0Pc93qteAxgAgd9HYUpMAKXY?=
 =?us-ascii?Q?3iNui7AbAq0/RYIEzRdTMSAsTG+fKy94BhKpiZtIHrX+P+B0TpjhOwukNhEW?=
 =?us-ascii?Q?2KRdwQxuIbtOBkZlt+o83fY6zjBo2Nv59cr4j7miOwovs6bBLkxmYuQ/7fFf?=
 =?us-ascii?Q?75vRGKIFye8Zwr1aQjB7Uor52HBY8kvyyuZs2gEsuOESZ2kTuFyXaBIUWkly?=
 =?us-ascii?Q?RE2Z+PLnJi515M94UvvLTXVqb3DI4lzHkn9R6Bh6Q3PYylz0qKx+RFG0aEGT?=
 =?us-ascii?Q?0yCRlzCNXkPh6zGKJiZRyxmlWghMAaQcAt45kVxSvYx4xKGP/b5oPzgG/qUO?=
 =?us-ascii?Q?GUAMarANcg7IlEt8Z1z3ucmGEfZkFeYIHSeBfZ4uw0egD/B7sT10lbl+oVjz?=
 =?us-ascii?Q?4LwT++7P4JXL+9QVejjXo7Sr5sWWsI4oLhf427Hzj6Ih/CVYKHHtGycLwBDK?=
 =?us-ascii?Q?v/GmcgUH1cAWOxkz5L5d6q42u38YBtRVwv+/ahv1vb/Q0t4Uxk9yYmo+gw7b?=
 =?us-ascii?Q?CqqFcqosSfPyOcQP1Bh72ttSooioJVCV8t4XVdz3poSF4DHx2nEz6CJZaBAe?=
 =?us-ascii?Q?9XWZjkCEzP1TMM4pkmB5T7iRkXnGqTkN5IhgbYRBwiBLtetkxcrAFzwDakTM?=
 =?us-ascii?Q?q2Pww8Fed7nfiP5iXslvL/ZIlfjBg28YLozh+4iEqaipfEZYkFGHCQ2WC/Ec?=
 =?us-ascii?Q?AlXmVb/Sovf+mYYsgXNW4lwbcYbt8/7QcUOqqG2K6P78Z8y7bbjxV/tZQXXg?=
 =?us-ascii?Q?Yem9HjDKB/sz5A31zV9MSPEuZhbwf84e03gUPw1Rn3bHzJ9nnrnGjBw4U/bj?=
 =?us-ascii?Q?6VST+vR8fjfdAkzccLfEqhtd2Vvueobp/7+QsEOxLDpViDjVHcvA6lcNK066?=
 =?us-ascii?Q?nw4tHsVsH2WBQHD235+SvVBUVKLNQoYHk3BSDtASpeqQGsG27kBeO6f9wlkM?=
 =?us-ascii?Q?lMlFWMQeqb6/RnsDKme6Ez29G365L8rgJ6L4IeHzCEiKjoOiOfBxZXhANif1?=
 =?us-ascii?Q?5zecfXNTuIu/m+aY8Hf/bhF+e+jKJkQrcLPsg4PWIWMuYHtLgj7/YHkraS9y?=
 =?us-ascii?Q?xMFKGjFAxtd+4zaKk+HYpJMFBD6RMkw2jykVKW1U5vi38ZKd/kuYy7ZCak0m?=
 =?us-ascii?Q?pL+uRA4WofGKF7z2LtMYSXnuyjCwDTt0HcVVQEE89o4OriqYZPSArRbIoUAe?=
 =?us-ascii?Q?FO46MkHi0uOf4otmhoRTEUYKS8BJLWfK3PEvC8fGuO80LJz9oRAg9Pi9ROtb?=
 =?us-ascii?Q?4+nADYtZRyKOuMEsLUOwrnCBA20Crn/X/qXnUIGH6Na2LMbD/e2uV4Mv812W?=
 =?us-ascii?Q?p9FZtg3HgzXIYCn/Qri2YkzJ1aDEO4/BdCASwE8PDBad5ZYsGAQD7c1FWZtF?=
 =?us-ascii?Q?Mpor7PUwPt/ufmFSoBozV4crn6cYPJgU/Jo9Dki2v+Qzc8UPbl1H6llAWimf?=
 =?us-ascii?Q?TyKYY8eKjB/PYwymBeCWD6z8vv8EgZ6k8OKkWcMNFx5pzfShmnaB1aqIgrhX?=
 =?us-ascii?Q?Rv5CD37GVwJ9cG0xD34yNU55YkN7CN6U7UT97UX7+xVrzwf86+oDyi15mn2v?=
 =?us-ascii?Q?e2/jcEfVmN543rX1k0kcv7S4Po70Fq8p8LfGJLuhL7m0zDDa3cR3SZspd6hm?=
 =?us-ascii?Q?zevPN+ZMITRmaRY8ACnkJtDzvNsnbKbLt5JJVBQnKmcvIBfNZhREo7JiuI7u?=
 =?us-ascii?Q?PjxHGxxGHhH3kz9Vkhvh4BTuTO0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9622e6af-407a-443f-a8af-08d9a91253eb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 15:04:03.5382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tp4StAHUaXQEi9iMiV4jiJmguJI+5SIhvCOCev4ajWxpxZ399X5dXDGAcm1BkmekkuDmAp0qacxiFXvYrEaIMyg2TpB8RlX/nXX06uYJM4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5881
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 12:34:17PM +0200, Andy Shevchenko wrote:
> On Mon, Nov 15, 2021 at 10:23:05PM -0800, Colin Foster wrote:
> > My apologies for this next RFC taking so long. Life got in the way.
> > 
> > 
> > The patch set in general is to add support for the VSC7511, VSC7512,
> > VSC7513 and VSC7514 devices controlled over SPI. The driver is
> > relatively functional for the internal phy ports (0-3) on the VSC7512.
> > As I'll discuss, it is not yet functional for other ports yet.
> 
> 
> Since series touches fwnode, please Cc next time to Daniel Scally.

Thank you. I will do this next time.

For my future reference, is there a way that I could have known this? Or
is this just knowledge that comes with experience? The email list I got
was from running the patch set through get_maintainers.

> It also appears [1] that somewhere in PHY code a bug is hidden
> (at least I think so).

Thank you for this information. I'll keep an eye out!

> 
> [1]: https://lore.kernel.org/lkml/20211113204141.520924-1-djrscally@gmail.com/T/#u
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> 
> 
