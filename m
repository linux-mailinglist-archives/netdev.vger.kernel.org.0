Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3F3468109
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 01:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383570AbhLDAPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 19:15:13 -0500
Received: from mail-bn8nam12on2117.outbound.protection.outlook.com ([40.107.237.117]:3680
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1359660AbhLDAPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 19:15:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2yDHXqqPONS+j1M1F96BxR13G4QxMVfa3WWKENsDUIbI6LTJPtmlJw6PCJnwW5zjyVxmThJCPE181wpZ4TWLpIfh2XIJzqacvr0QPF3pZ9bsAKwUw7FiUbUktQZWF0Jf7ChZ1iN7DCfduy5Swsa/XcRpOqeCuFQ5oRrZjuVIbtmV0XeykvmKJOdmReV0ydbc+Ayj6s/WQJOJbJW1Sf0wG7YAwSCx37WIt+W3zhw1DORhC8VAAZVsgzjRcqYgJ6WpMIMzWCm9oU3jDZ0kE6nX8CukgQvdVARuZwehzUEKAVSbpvb3BRHB0+vxd5NbdbpkcKVoySZceuco6MUIwqX5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lE9cFTm/yFwYwvFaEvjx939wG+jqHtq/d+y2gpD+gNg=;
 b=mV4p1tK3lWEc48RYyX4WawvO7OWdsBGNskei4wEqUJ8Eupxf49DPX5MA1/qB3Ys9zeUvsvcScXx1hLneW8z1aUpb8ZCXbCx220HjYQchpNMcvRKTsk698qW51nQS8I9/bB8/jTvHJz5tqhE/CqzOBcP/QN12Z/S1vjlW0wjsPc7GumH1o6+L03pz8Sx+zhUZgQu1cOo33i18khQlFJhFP2zNlE5GPMm/JSDTct9M8LMHm4dPp09iLuIdPT7o/byXmwIDDWgxXg7tozFKQBjsDvnnUbI/YR1c+egX+AXV+7jLIwLLiITeiGZioBjhFsiqVEJV0+KY/4GM1tSveSvESw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lE9cFTm/yFwYwvFaEvjx939wG+jqHtq/d+y2gpD+gNg=;
 b=qIdu/4wXim8soN2LYP8pj2s1rQLZnmeg9LTa4eh/KE0+6F525iRVbpFwFdHEyt9oNl8FBIi4Inj16bYsXfgybUzHw33ndW9VsUzaZajk00/A5zQp/Yv9knRi6taX+eaYlb/PajVQJJZLour09cDeBm6hqvTllqCORdxL6AUn1cM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4740.namprd10.prod.outlook.com
 (2603:10b6:303:9d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Sat, 4 Dec
 2021 00:11:45 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.028; Sat, 4 Dec 2021
 00:11:45 +0000
Date:   Fri, 3 Dec 2021 16:11:40 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 3/6] net: dsa: ocelot: felix: add interface
 for custom regmaps
Message-ID: <20211204001140.GA953373@euler>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
 <20211119224313.2803941-4-colin.foster@in-advantage.com>
 <20211121171901.nodvawmwxp6uwnim@skbuf>
 <20211122164556.GC29931@DESKTOP-LAINLKC.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122164556.GC29931@DESKTOP-LAINLKC.localdomain>
X-ClientProxiedBy: MW4P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by MW4P221CA0024.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 00:11:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9258178f-4032-4c0e-1e7e-08d9b6baa86b
X-MS-TrafficTypeDiagnostic: CO1PR10MB4740:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4740A1426DFBFDDAB789109EA46B9@CO1PR10MB4740.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JqfwDWdqo3rxj6a31C16Z1EbwYYSN0+co6e+RTVIxis8bJLM/o1/AHo9fc6kf51azx4+TcWWYQSMhzV1BUt1dgWP4xQf/LQKsJr6toJmxp3jjMBghyzjNZaKp1IjxC8j6A34aJNuq4Ixose6jiXcURIEeQOUbDiXtAUCv5t9TvGat48FeA95qc96O3m1OmhtKYrnKuLKus0tUj1Q8VxUjzIkarNErzkabGiEeIHbH3nRlEzwHU26Ho6PA9jUv8SIvlOjsJlKspBVGNnT0pmBom1VO3kT3RBI5EoZRPDfTwnxaZR1+UCRQkt5RVeSkYARI31g6OhO3yaBLyF5yBO10ctsG71koyf4snRjTmEn0PcOOmk+3KWOMRr4QEWCRpg8w425c2VxQVu+zmGtXAIo7Wf2WFtrJmfcMZQUqgxH1PWyD39J7fxy7I79BxCwvcAFXelBCXsVF2e8ZypeUYECJqydns70H7VQ7bkRF+jb9ULpbRk2U4j9c49Y6b2kSJduxEwxmd2VwOVvYx+3dJLoNop2xxkGqZ2/QY8h1GeGNCbfIqG7/lnRMx2OHohnfF8fbGzynhzysnStO/XfnSEzriJ8kAduvwAd6c7MryAd6TSys3VUs+dfe+96nbHYzILMTxqnPnm08mRhqOtwnrZ7mQH7fbEXc4tpq2E7XXzebWRBqA4JDKDfGr1bEZUgQQ97NDmpQypoG3gWh3PFUrHPPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(346002)(396003)(376002)(366004)(508600001)(83380400001)(33716001)(38100700002)(316002)(956004)(55016003)(6666004)(66556008)(66476007)(66946007)(5660300002)(8676002)(9576002)(44832011)(8936002)(33656002)(4326008)(6916009)(38350700002)(52116002)(186003)(6496006)(9686003)(54906003)(2906002)(86362001)(7416002)(1076003)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kh+yEhZXkkHFadPXE8pN2Cj1Cn7vADSDDL4AEAcgqI1UdNmzrhoot/+Foha9?=
 =?us-ascii?Q?dKl4wzejBGyc1rku0BIG+AtUmxvhrhXqLeEfKUQDG54BrAXLnrF4wH4FyCeO?=
 =?us-ascii?Q?7U82rgzOIGyp6RJ92kK5K8evOzPfckcnkykJHeJxWxKRmUDWkfRJlMYXpuCo?=
 =?us-ascii?Q?gX+5LOAfQ9lx5zHw0WFTq5I1oVFic3UkfiIxv8fU0SWiPW0fABfJDQfhhYmX?=
 =?us-ascii?Q?kKjLEjuKnuNDQhJvgeFqaWBq0i8M73q5OyisNjjYKpVk1NJloGDN0fvm0Hve?=
 =?us-ascii?Q?OqqkydSk9toM9tQmZzV9hme0qmXUmZLJ12v5Q4nw0FZ8YuRffroC4L7IKIsl?=
 =?us-ascii?Q?ZhIF+Qqwh3EXg+AGAMOLlQMYyOWvGkrQaePjJXQQsGgg7KUYj7P1ImOjVnK6?=
 =?us-ascii?Q?bDi8QKICFAQmXzC6T1DVejRaYwpE6xgwM1CpjIZGCasXtdSAcUI/flTB+Gvv?=
 =?us-ascii?Q?lHSLs2ie8yL9pv0vGsIeiaudkkkhCVzpPPntUiPX1lLqVDCM5jiHTSpY0m6G?=
 =?us-ascii?Q?zy8YE/cp/uGziNhOlPPuGOgl1ENd41aYIKV9wi6FHzyFvRDp2pTV7dPot6BQ?=
 =?us-ascii?Q?2u2zzb9N5T1QNJ/VDxbWrCjEGrVQIGD+Q1QLbwTZTo1PF7I7K4j4edx+SO41?=
 =?us-ascii?Q?mYSCXGhf/CEgoz1JrkKTzqmGiDTr7L9SlLYuu9/Gxe0LauDsRndtBJPkfDHU?=
 =?us-ascii?Q?NN2PljXxrL7pybA1eVCh97mvSyWFhh719V5Vor+lOKrzZA65apKuz7JGl1MJ?=
 =?us-ascii?Q?ulaA5uqsu4RhM5HTllqoR2lDBFiPvUliSq//gEOq80rpHF2OjlNaRWnJl1e7?=
 =?us-ascii?Q?gUSrIIL7j53rkvrgaxZDR98q5dX9r0QDCoT7hN1OD+9jk6BrjnFhWYEk/Qy6?=
 =?us-ascii?Q?/p8BdV/Wx+g3BLF9TUxYCvaDZPJGHBZDLXjRuN5iJ7vfYRJmi/adljh2zMLO?=
 =?us-ascii?Q?DXSnELIevOUyqRmr9lg8YxrmJTsNyViL1cJQlqcv9hxIvjq1GC/NqcsqkBhF?=
 =?us-ascii?Q?sp48VG0WtlaEmJNI6+mC6TBZb3yjXnHsDMSBTilXoNiv7bt6oeI8iuLmulhf?=
 =?us-ascii?Q?La3t3vlnSJADkqF+LjYePVGOaDqOKC825Oefz2ZMK1DFLnc8f8uZqbsyQ1ZT?=
 =?us-ascii?Q?C3ZYp88VpuQJDjQ9WBlvV6dYaXWizpoRFUnzEsv/aJg2FtEiuq9MIHdPcEF4?=
 =?us-ascii?Q?qEfwUuipMXrTgCb8MGgebpRmEAkVMGJNoSGIrfqjXL2F0tpmimPo7a4kFx1m?=
 =?us-ascii?Q?GuuvlcMf1rpRrfLRrvEmo4c9W4j2e14352OvbeGpBO0h01RG6fn6hXNEj8Wn?=
 =?us-ascii?Q?F9sKlnSTWTltGT+yDXaITvQyp1kBC5hAIRQ9Hn73DGqqUoVy5PLmTQ6RBVKs?=
 =?us-ascii?Q?esQXSYRICvymvW0RWtMA4g1oh/8TA3lSYOG6aIBfrZ1slYDH7wjX/bPdIP5R?=
 =?us-ascii?Q?Pw+Iv9nDT6b9AXj8lP1YXnNGNYqMmNxdIYE/LYOtDoFsx9UngsAxSLW2NRHm?=
 =?us-ascii?Q?oCFboj8bwe2/h/SB2Go994ctf44mbOjZG/x8XfKQJJXW5KCNDSHqSzYGQR7V?=
 =?us-ascii?Q?fTXA/9whhOkP3ndlS1teMzqn567p8iq1kyEBGDKWE6dKertTLN4MePjiV6MR?=
 =?us-ascii?Q?mKAjMKnsJxzhPjOmWTSHS14xWDy9eQBkJVeTu5N2g+vDQqHJckjCG/TifVMi?=
 =?us-ascii?Q?Hbqu6A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9258178f-4032-4c0e-1e7e-08d9b6baa86b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 00:11:45.7999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxjOW3RQ0oBulQYlXrvhABkObmqjPJOALL2LqtPQSBFNx5iYPIbqzsQX2HRdLh47C2bPavwg9bjdeHtVph0ISAioKvtxNhekwJ8u4jRwP6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4740
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 08:45:56AM -0800, Colin Foster wrote:
> On Sun, Nov 21, 2021 at 05:19:02PM +0000, Vladimir Oltean wrote:
> > On Fri, Nov 19, 2021 at 02:43:10PM -0800, Colin Foster wrote:
> > > Add an interface so that non-mmio regmaps can be used
> > > 
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> > 
> > What is your plan with treating the vsc7514 spi chip as a multi function
> > device, of which the DSA driver would probe only on the Ethernet switch
> > portion of it? Would this patch still be needed in its current form?
> 
> I don't have this fully mapped out, so I'm not positive. I think it
> would be needed though. Felix and Ocelot need regmaps and will need to
> get them from somewhere. The VSC7512 switch driver will need to provide
> the regmap directly (current form) or indirectly (by requesting it from
> the MFD parent).
> 
> I'll be looking more into MFD devices as well. The madera driver seems
> like one I'd use to model the VSC751X MFD after - just from a brief look
> around the drivers/mfd directory.

As you can infer from my RFC today - I've looked more into what the MFD
implementation will be. I believe that will have no effect on this
patch. Felix needs "ANA", so if it gets that regmap from the resource
(felix / seville), by "devm_regmap_init" (current implementation) or
"dev_get_regmap(dev->parent, res->name);" should make no difference from
the Felix driver standpoint.

That said, I'm fine holding this one off until that's proven out. I'd
like to get feedback on my general RFC before skinking a couple days
into that restructure.
