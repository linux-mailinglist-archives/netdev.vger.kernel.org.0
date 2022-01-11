Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4255948B5AC
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344916AbiAKS17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:27:59 -0500
Received: from mail-bn1nam07on2132.outbound.protection.outlook.com ([40.107.212.132]:43150
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241941AbiAKS16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 13:27:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVAZon1jQW6lTymZiJZrzhjbybsORM9uP1SspWKCjHBSAm7aRWtKPkmT76psyA0Fr3iSBMTiVPXW1ChH4MvUhDjbw+AcRetKpk3IyDhTOvwnTu7hHl7DEHY+OFOyro5PO37NjNPf85upPWi2tAEgqd69K5TqhkSU9bpbm6i6YbWgiyxrl2eyEpe+yn4pFLABIffPvbfIJqT55zMjbZn4oExJ31Y5uMQzBBuXx2auRwOUSNCNspkbi07ruwThZGTOleHr+hlYvSbyvEvQ/8ld4iOM24VbqYJ0yje+qo0u2YRO0DwDb97P6+dNo17oDFEc+yTgT+RYsxxz8L+OFTsfNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xBIRg89hlRdCZKOyUOVyBsntRHY7Rgw3SffrC59pNWg=;
 b=LxapCBwWo3rpp0rmN58D+SF0uCUkkw15HM7DzXCprWKX2eZ/C4N0O/9w9Pob7vthkm7HHxm+O/w1W30H8t5yubtzYTKSCPPq/8D9FGbBCj8FA1kt2KRcvMuLPuWZ70+FKf3pbs1r0TFZ021R7G1UvZF0/btT8O+JtHcbljQVk2DeCOYeIHzbG6pD3OEg0cecLRlIB+CJSFV78QpHm4pUWhb2pVfubcvj04po4mqLJcOHNuEOSC1DzPTAx3JljdkMwB485gOs+VOozXyfNAvJPX+L+CY7jCSKXK+7sr6DRICU4paDkxXqhAqSgfufqC444Fjo6qZTVU+7TO37YYXbNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBIRg89hlRdCZKOyUOVyBsntRHY7Rgw3SffrC59pNWg=;
 b=uGR3hCGe5bSm+fvQOJu6ZLnmNhFQ69zKgdAFdunzGKk18QRsnaQe+r22INceff+DM+IYNtV8Grqs8lUa9yminyHrdVffKW+ltPEy3+l0hQsPfvGYpHQRrN3UF9vn7yjRHMffRFjjprx2uKHI84Bw9eQEWzljRcg8R+0axiEF5B0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2032.namprd10.prod.outlook.com
 (2603:10b6:300:10b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 18:27:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 18:27:54 +0000
Date:   Tue, 11 Jan 2022 10:28:15 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Mark Brown <broonie@kernel.org>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Subject: Re: [RFC v5 net-next 01/13] mfd: ocelot: add support for external
 mfd control over SPI for the VSC7512
Message-ID: <20220111182815.GC28004@COLIN-DESKTOP1.localdomain>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-2-colin.foster@in-advantage.com>
 <Ycx9MMc+2ZhgXzvb@google.com>
 <20211230014300.GA1347882@euler>
 <Ydwju35sN9QJqJ/P@google.com>
 <20220111003306.GA27854@COLIN-DESKTOP1.localdomain>
 <Yd1YV+eUIaCnttYd@google.com>
 <Yd2JvH/D2xmH8Ry7@sirena.org.uk>
 <20220111165330.GA28004@COLIN-DESKTOP1.localdomain>
 <Yd23m1WH80qB5wsU@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yd23m1WH80qB5wsU@google.com>
X-ClientProxiedBy: MWHPR10CA0012.namprd10.prod.outlook.com (2603:10b6:301::22)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff4ac4bf-8fbd-417a-5f2e-08d9d5301525
X-MS-TrafficTypeDiagnostic: MWHPR10MB2032:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB203227CADFBE4D7BEBB851D3A4519@MWHPR10MB2032.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gqDC6I6+8DaAF6aeTkn2O6LWGzhlZZn3OFrGThpWBl5LApJRHHhlSphihHjflb86DRKZvjv6oYIOlQiX39cGihP24NlhZ/0Z6U4mv/ij9LwoOGET6nGJ5Vlxts/9iJms3XoHOwrGLxP3zsb/GAcXeIff2O835gZNH6kHQuIzt9H/oLN7kGj5g3jDqekxrYdJRCJ6PJZ8vZcp2IAx3MvSqw5kHbjL/2Vs5CSNIuIXnZPICl61CHpUEgip2jsD5e0BVV3/0P8grEYkPBLre0YO5ZJ9jG1J6SSIn3nqoyg/l5S1FjM95mjqUMH5Qo71pY1ZOUr2F9sjdqLekwVz/OPQPOHjNRRaJsJiZpkBQtoySGgoaFR76gc2OYb0oZCLkUKLwE7jM5bAEMKkg/dKPiCdMXKcgDWbBKC3GeJfOi+3EFNauN/YzYaLLBIhffnJ4MshvbKTXOzGzWJZPW+5mLJLNGRDGjLKe8fZYZNDYqvlb1XND73P42zIkrijuwWJeFbIkWLwowLN8yvqD0D7+BzQ2Tqd3OZlpfLTDD0WkTdTNc5BbxTJuPTCPrfoO6WXl9n+sumgXqBJfCNKxuGCuT8n3QCa1CToHwr0dLA2Rz80TRry+cwThcVyJTo7urQfsnydT0VVNgMHB8mS+HUcAZitjxbuFc7la0Gc2YLOVtT4bqI0xDaAPS1X5TWtc2Qk3my9RxbBbiR4fwRda3oC4hS5Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(42606007)(396003)(39830400003)(346002)(376002)(136003)(6666004)(6506007)(8936002)(1076003)(2906002)(33656002)(44832011)(86362001)(26005)(186003)(52116002)(4326008)(54906003)(38350700002)(6916009)(508600001)(7416002)(316002)(83380400001)(8676002)(5660300002)(66946007)(66556008)(66476007)(9686003)(6486002)(38100700002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WENHZ2JMVnREbXRVTFNVakEyc25YcUpqaGxONFhWdEVod2JyakJCT1ZQeENP?=
 =?utf-8?B?OW91cHpza2k0dmkzamNSTU9ITWFVcmFacUd1NFpOQm43SUM5eThPK0Y4WU02?=
 =?utf-8?B?ZDI3K2Y5VWl2SUhpSW1ieEsyL3Nzb05obm42VFZweWJwRXVnbzZYOTNoY0NE?=
 =?utf-8?B?MTV2T1J2cW9BdDlFQ0JHLzVHbUlZV2Rka3VlUFlZL09pdGtJMHpzSnAyb0s1?=
 =?utf-8?B?UzhzRjEzWUhLUGdkT2FaOW9yQVZJb0pHRVZoL0tBWjNGZUdYTFNOQm1FYy9N?=
 =?utf-8?B?ZGZtZmhJNVE3SnNmQU5PT0dkNFRoWDU4RmdhQm1rR3FpUmhRSlJtOHI0V0hF?=
 =?utf-8?B?d0lqNXcxSnhoNXZVcjd4bktVcFhDMXhhOGMrTFE1M3AzQVl5dUV1SDk2UTdh?=
 =?utf-8?B?aWt5NHpoRTk5U1FGV2I2QTk1YXhxWFlKQ2I4S0YyWDk0aUNkMnRQa1c3YVpI?=
 =?utf-8?B?TmRkRzFxbGN4T21hK0xEdW5jazF1emxsY2hRUElPU3RERE5pcDJFSE5RWm9s?=
 =?utf-8?B?Yk9sOVhEb0drbFlmakI2N2REUUpNNWQ1UGVpYTMyZCtiSDJwMDk1MWw4eVF3?=
 =?utf-8?B?Tm43OHdBa1I3NUNPL3VzNTFBUXRyOFBqbHI0TzdDTzNmN2J0M3c0dVpJZHg4?=
 =?utf-8?B?Sk5EM21LNDM1anUrYmthMGtBc0tVSXN1VlQ4VGd2Nytpd2V6c3d5MjZSbzVF?=
 =?utf-8?B?Q0ZMMUFnVkllN0Y4WG4xWUVBN2pZYmFtOWZNYXRzNUhVZmNyM3E1cnBZU0N0?=
 =?utf-8?B?cENGUjJ0dkl2elFFUUd2akh3U1RZZ01qbUQwajFCQ3Y1K3V3MUl4L0dqM00x?=
 =?utf-8?B?WTZMOGFveFBCSW5oYXE0amFCaVNMdE1ESHNOcGtWL1FoYVhQUHptTjhOV3Jp?=
 =?utf-8?B?MHhwT2kxcllldGJwZ3ZFNjFGaWJOaWk2RWNFUzhGN2U0eGprTmhKL09YdHlK?=
 =?utf-8?B?ZUF0S0lNMm55ZE0wTUZuclFLcHU4eUNWbVBrNy9rbVpWQXVrdFJIdmhJM2cx?=
 =?utf-8?B?SC9xbFhBNC9HWG44WVRWMjVUZDdKU3djSGxET09NSE1rN0dNbUpGVG9ZRFds?=
 =?utf-8?B?VE9hdHJHUTBkWGFITk1rZ1BWT0NFelhWK1lQWjRjRkova1hyMzBGNHVtRWNv?=
 =?utf-8?B?bHNiNGFHWnBmUHQvY1VVc3RVYW85T1grY3A5TnpmdG9DT1pjKzB4bjdYeVBI?=
 =?utf-8?B?N0lodTZEUjZXR1VVclR1WGplOXNETHRjRk9jS3J4bVdpOWdKUG9yQjBRUmx6?=
 =?utf-8?B?ZzlHeXZNWDBya3FReXBaTjlxMmFNdDh0dkYwcTRDNHV0NkJuMU5CaGdldzUr?=
 =?utf-8?B?UnZJRXYvWFZ2WjBGOWliL3FONXp1aENuQlN0OHJEOUJYOWhPOUpDTGFrbUk0?=
 =?utf-8?B?SFlmcVQ0UmN2cWVkdFkwcUZyanhsZXJvckg5YjdYc1hFUU9nTnIzT0VwY01M?=
 =?utf-8?B?d1B3bHZZV21sTmtsWHlxbGV5eXJaMUVFYlpCSVRvVEdxNHU2dG1HbHAyK3JE?=
 =?utf-8?B?K2xwMWwrTWI3UCtqWW5SUGgzbC91eVh3dDRib0NiRU5jOGxiNGhpS2NKcGMv?=
 =?utf-8?B?ZkpKYmJmNXV5azVFQkFwU1ZMWTVJT2lMU2Q5eCtuREZ1MWNRT2pPaVE5L1B1?=
 =?utf-8?B?K1FhOXZCN2F2YlJGWXM5SmJuQWNmRy9xRmQzcnV4K3QrS01jbUpXKzdGN3NE?=
 =?utf-8?B?a09xMWFuc2FRb3R3NE1XNzEvcnFBOGpHdU5nNm45emNuSzhoL2YxYXgyQy9q?=
 =?utf-8?B?YjZZN1NoUjJGYVVBVEhCS0hWc3NreExySnI5cTltdmwxYWk2YkZYQVNSWmlU?=
 =?utf-8?B?b1VjelFZbG1vS0IxajRUWjFvRld5MldVaW96U2o2bDAwaHFQQkNLOHBxZjNC?=
 =?utf-8?B?bEtubDQrZlhRVS8wN29CWTdYOXhGZjV1bVhKUHdETDBCN0xPRVRycVhwRW12?=
 =?utf-8?B?aGwzaG5MaTF4YkVYKzBlQjcvUUNrZTJhdWRMOHhBNFNvMGhoWjlRMEloSmg4?=
 =?utf-8?B?NUZyVldLSHVIK01PWTdoNENDSkxpODhCVXlWaDAxbURleDF1TnUyTis3OERQ?=
 =?utf-8?B?RE8xa3ViYk1aSXYveS95N3k1VVRWYjRnQ1VaRzcyT01PdmxIYjZNUkVxRjNH?=
 =?utf-8?B?azJvUFZXQjlLK0o5N1h6U21SelFXdWc3ajUrc3QwbXN1OFFKT3o2cWdObFJr?=
 =?utf-8?B?aHlmd3JkVUhxVVQ3Q3VPcG1Od1lIR2NFeFVwMTZVNmJJdHkzVkxrMlBXZ2Jq?=
 =?utf-8?B?eUFSanh2SVdkS2RMVXhGZlV2UTJRPT0=?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff4ac4bf-8fbd-417a-5f2e-08d9d5301525
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 18:27:54.2052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XBnSXNnzjSqAhfiP1OltBDLO36QhnzF1qPNyEJDl+DHXNk2Gl9S2dJDsT5szwyLmU4q1c6XPSofyfSDCJeKAD6iCpphuCRSPCfd40I4kCTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2032
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lee,

On Tue, Jan 11, 2022 at 05:00:11PM +0000, Lee Jones wrote:
> On Tue, 11 Jan 2022, Colin Foster wrote:
> 
> > Hi Mark and Lee,
> > 
> > > 
> > > > However, even if that is required, I still think we can come up with
> > > > something cleaner than creating a whole API based around creating
> > > > and fetching different regmap configurations depending on how the
> > > > system was initialised.
> > > 
> > > Yeah, I'd expect the usual pattern is to have wrapper drivers that
> > > instantiate a regmap then have the bulk of the driver be a library that
> > > they call into should work.
> > 
> > Understood. And I think this can make sense and clean things up. The
> > "ocelot_core" mfd will register every regmap range, regardless of
> > whether any child actually uses them. Every child can then get regmaps
> > by name, via dev_get_regmap. That'll get rid of the back-and-forth
> > regmap hooks.
> 
> I was under the impression that MFD would not always be used?
> 
> Didn't you have a use-case where the child devices could be used
> independently of anything else?
> 
> If not, why don't you just register a single Regmap covering the whole
> range?  Then let the Regmap API deal with the concurrency handling.

That's exactly the use-case I was considering.

An example:
"mscc,ocelot-miim" exists. It can currently be used in two different
scenarios: directly with devicetree, or indirectly as in
drivers/net/dsa/ocelot/seville_vsc9953.c

mscc_miim_setup(dev, &bus, "VSC9953 internal MDIO bus",
                ocelot->targets[GCB],
                ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK]);

The "GCB_MIIM_MII_STATUS" parameter is the offset from the base for that
regmap. See commit (b99658452355 "net: dsa: ocelot: felix: utilize
shared mscc-miim driver for indirect…")

(My apologies if the formatting of that commit refernece is incorrect)

But in that case... the Seville driver makes a devcpu_gcb regmap located
at 0x71070000. That regmap is created over the entire "GCB range". That
gets passed into the mscc-miim driver, along with the base register
location of the MIIM periperal.

At the same time, mscc-miim can be probed independently, at which point it
would create a smaller regmap at 0x7107009c
(Documentation/devicetree/bindings/mscc-miim.txt)

So the mscc-miim driver supports multiple use-cases. I expect the same
type of "offset" idea can be reasonably added to the following drivers,
all of which already exist but need to support the same type of
use-case:

mscc,ocelot-pinctrl, mscc,ocelot-sgpio, mscc,ocelot-miim, and
mscc,vsc7514-serdes. As I'm bringing up different parts of the hardware,
there might be more components that become necessary.

With the exception of vsc7514-serdes, those all exist outside of MFD.
The vsc7512-serdes driver currently relies on syscon / MFD, which adds a
different complexity. One that I think probably merits a separate probe
function.

> 
> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
