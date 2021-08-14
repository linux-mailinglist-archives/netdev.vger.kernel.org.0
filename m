Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D39D3EC3E0
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 18:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhHNQhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 12:37:21 -0400
Received: from mail-bn8nam12on2129.outbound.protection.outlook.com ([40.107.237.129]:40896
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229818AbhHNQhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 12:37:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHSeFb96Oz0sNMt89cCsVmRuO3qywVgaDY5Q0M4ZaOh78q/kgbIRFLGEv9+siZ214uCoENtXG51RUJJpu+K2c9Ct8IAZL+FQPApbbZqVTQesDXFlPWAlyJQ78a/k+FBd7PCimkIBnAA9/cFpk1dUqUJei2nlsllLDQ0HIsduLYiX634Dp5KSFfRsiRn8uDQiyhQnSU7ha7mHrNHYT1vHb4FiJEjNcCaBC4yaUJJ5rCuyZnt0WyPiF/yDQyG0yUaNfdqwE/TWP9js3pztipCgPhbioaFY1sKTryhP6F0ELUF9aopAEYv0vS/19xviIxrEDJkxefUFDb1QI0vBCKj5fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yg3GLSFpGH7QWe8x6XRCfzl8WhTxwuItCptUDiSUDFQ=;
 b=ckAVR6T1UjM/qhpIyNt1oI+CHkEjR54zr3UI9Irf7Y7DO2ZM7ECUKo5iNz7apAY+pbhppi5ZaGcpq64PL+hJwn+gPmCoU2WM0qpareKRltqs7WJuTXuDzRODW2bpTTDJLzJ29AoJ1O0XV2/XEfS7xXK6ik+byfyR0KaQdSLMVB3RZBbimWXFPMLWoB8dPFmgLuGPcqXtzxfiHwDIc4bVZG8fpwqhSpYuf70B0+y8kaGafHcD0MZ1FsOod6OvOT0OCleI4sUpyg51ZCK65gocEern/x1sXcpL1aE+cqaaNGtyH018z74JlJg8k/QmGrunS8J82yDDzA3sWiCqhQgpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yg3GLSFpGH7QWe8x6XRCfzl8WhTxwuItCptUDiSUDFQ=;
 b=bk55xzvUjrss0gkfHsw3DCF7H2ttzxNnaykZVJjwLCRW6cmaiGPoJO0Nq0cFmd8g4XdWeU/imeoERgozXpWqCeaiPO8gli8QbSCBI5WeikNPoGEyVjxSljTeNoUEPwJ0hT5zUiOxGTG68GcbVKPsjSXfcjF9SxU9rDx/sBqnL88=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4802.namprd10.prod.outlook.com
 (2603:10b6:303:94::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Sat, 14 Aug
 2021 16:36:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 16:36:50 +0000
Date:   Sat, 14 Aug 2021 09:36:47 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 07/10] net: mscc: ocelot: expose ocelot
 wm functions
Message-ID: <20210814163647.GC3244288@euler>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-8-colin.foster@in-advantage.com>
 <20210814111701.dkn3ckhzxoyvcw5s@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814111701.dkn3ckhzxoyvcw5s@skbuf>
X-ClientProxiedBy: MW4PR04CA0054.namprd04.prod.outlook.com
 (2603:10b6:303:6a::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MW4PR04CA0054.namprd04.prod.outlook.com (2603:10b6:303:6a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Sat, 14 Aug 2021 16:36:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8df4b04e-1ea7-409f-36b8-08d95f41b6e5
X-MS-TrafficTypeDiagnostic: CO1PR10MB4802:
X-Microsoft-Antispam-PRVS: <CO1PR10MB48025CEFCA13342323D80575A4FB9@CO1PR10MB4802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghbMOV+UStQn0HxwU0rwf5QjE3birmm7MBbpQ/Ry60YFgHol8ycMdiPbHXYTB5L/2rhK8W7gUvTFa21FIbYuFZm+ycPERZoPU3CckKS0rjmAAY0tXptFSYXmiQODmZ2xNMxkHSXjbjNpP/69wUOA+/HcqFKEF6SuIQ23yAZXFvyRtf4j21HBWd9vpMvo/DZUYeWCcnZINBujCf7q2fLI6dmK4WtCHgs5fiq4SRhKRu28dJYWv2GRqaq+t+e/5VGLRj22cfe6xaqqo8i9mxIqt++wiGgpEu5fHAlHLtMhrRxm87z+KZI1XuzbBur2rK1cBAT53Je1wcLUl/DFJqIQL4AdamAbIB0pab9yk6Nd7GGy9FVenW10r2ISODHZ9wi59GbYSIkX1GYiymlovd2kHmOlMmZ8UB4cg9NjC66YU8TBcOA0Zz5W4c9RQc2D21J94VEa4xMHy85ooPRy2f3e/RpBim8PbJHnQvxUzori66c81TajK32bB+wXmn+JbJYvEEwBwql/Txj9pYqKAfnnV12Zbk6DMqhUNP/CWhLm8mrkApP2NA/nV4VcXC+H+R9l5cGbIoImiSgq1OWyZr7T02Qc3Ll9JZi8vMViXa8iSICNxrVAAdt7q4nkCJoPlSpQIIsHXX13QwSblV7G/UBGcMdVsBylU/q8sZZKNnR93nBUCFamteDmfd/SlhqbAy4+VB1E47m0x397p6h3HnD3RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(376002)(396003)(346002)(366004)(9576002)(2906002)(66476007)(33656002)(66556008)(55016002)(316002)(86362001)(8676002)(478600001)(66946007)(33716001)(9686003)(8936002)(44832011)(38100700002)(38350700002)(7416002)(52116002)(956004)(1076003)(6496006)(5660300002)(4744005)(26005)(186003)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XqB8WQ/puTeMrRT+B/zHtAv8tyWIHM8xIHmwKHRH2qR1C6nOx11zdA+uIndl?=
 =?us-ascii?Q?yXTkD6PsRCcXt5UHh7MRc8q2Ip1yXQl5tKg8A8SeibsXarUnXqRKPZnQrBJ5?=
 =?us-ascii?Q?PRY2KtWGJwmC6j0EhBVvQ2rZm6ZQYYO2t6vOgj3P6lGFmen71mWyCRVb1K2D?=
 =?us-ascii?Q?GZHzcW/6MY42qIivl/l8lXh5LoZVbCTS5oJp2f+gYwREwP5tlMWYgJSnYGMr?=
 =?us-ascii?Q?5/9UYNUPl3feCZQMFVrwQ0rKJB+fZRB7uPoWb6jiYc6c/PZlGGyUPNzTJxJc?=
 =?us-ascii?Q?NAEXvwswQxHizxpnXGK5a8glKWYD2m01J12LpxdhPTZ274dYtfIIzB7XKhWZ?=
 =?us-ascii?Q?DTa6jXeCMuwRAfIzisgWREHdgQb13/bOirdbq1mk7WUR6UDaBNg1njp3GcCY?=
 =?us-ascii?Q?2J8H9SZzb7DhTI9UWLTBoH6UUr7mIzWnwRM6skEUZ3pU9godtf/8f7J+aWvV?=
 =?us-ascii?Q?EUHHNuOGGEkVOKOWcXYh9olg6+n1Nbq4psElUZHO79jKKBGW5QsR2mkr3Y/5?=
 =?us-ascii?Q?efRhJWPlZEp7j3Fhw6FHkNQ2Jy10bStXn2nxB4nCWKCIEyTkqt6KH9jERdYo?=
 =?us-ascii?Q?Urn9yqFEnRAYiJHf26fC1PnF3RfmmPxb7hZGQG2HRABN8ItBiFtpPv9cM+jj?=
 =?us-ascii?Q?VfrlE0fycfriStDS3GcGIdRU7xY0q91OxJlI4LocfyKYKI3nFPm6CWFYQKpg?=
 =?us-ascii?Q?daI99EvSsYxUajwOmPRTNOe/uWeVRBS+glzT6xIB9wmdsIr3pxjxo2aAyb+y?=
 =?us-ascii?Q?3Yj6Fiq9xWAjvlgwka2WCiK7e8o6bizjqsQx3XIhBRphhZ7jUCmlN1U3yRY5?=
 =?us-ascii?Q?6LxEfAlSjYfn17ja9V9MeyjgY03/v0EqNKxXLT4km0AR8b/A+oRzu7rHYv+F?=
 =?us-ascii?Q?EuLqfwzSU8o4HgkZt39kdv9kQLEbXVxdJHdg0A+0HtG0LuaNKO5TVZpP6ffq?=
 =?us-ascii?Q?/oR9VQYelnL8eQKvCwlNvUcnHMgT2ekkOUROtBQcKnNYBG+vTrJD57AJrMpo?=
 =?us-ascii?Q?+NcAy7zGtuuf/LD2eLFq9aHuf/gcZnRGjAf8UmtQFOO0HR7tSmAommiZwKMz?=
 =?us-ascii?Q?VV9bCgp2ax/RgYc3EXag/eW699kidhdXKSoR6Mog7pWiGftb6JXzubSbWTXN?=
 =?us-ascii?Q?gk3mspX1RwRdJ0KrtOgs3CPg/cjg7IXgAZYlSFixq56VVjC41ynF0O1Wt3Rt?=
 =?us-ascii?Q?Kuck6mxgYICYUOqRoLAp8VWJKIWGFzZN1Im/kHl5y7JdGoRJTxqamxtrS30R?=
 =?us-ascii?Q?cnIeKHW9R9W0ec7Wlrbb1twSz63MbcFVX6qnuC+ETn/5AREPKfXsoL4n9QRM?=
 =?us-ascii?Q?qJ8f5+nnGS8uio7hKjZDOpWG?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df4b04e-1ea7-409f-36b8-08d95f41b6e5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 16:36:50.0990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGJhv0TL4hdtuX5ZZdeReye+NmH1YKSuprzT72RwX6GKhKK6c2sIViDoALEZSEUjiXDxyJmkfOHd0lZRngR5g+kY/yXVe1+gwvG8KCHfVY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4802
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 02:17:01PM +0300, Vladimir Oltean wrote:
> On Fri, Aug 13, 2021 at 07:50:00PM -0700, Colin Foster wrote:
> > Expose ocelot_wm functions so they can be shared with other drivers.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> Can these be moved to ocelot_devlink.c? There's a lot of watermark code
> already in there.

Yes, that should be easy enough.
