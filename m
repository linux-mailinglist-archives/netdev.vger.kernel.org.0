Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E13F3F31BF
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhHTQyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:54:13 -0400
Received: from mail-co1nam11on2100.outbound.protection.outlook.com ([40.107.220.100]:22361
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229784AbhHTQyI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 12:54:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQNy9rcGqysPIZWjRyOhxwJPKmFwIkxwLn3c3bp1I5RZ1VmAvyww3kw83olnRjJgLiKteXY3ctuxj9LBEx6MNz29H4WEVtjN2BBKI0otNnmG3AqH/ySptqk6ErdcF16TzOiDP1xBpcxD90zQYL1ZqHjHaq7PA17dlz2oY4qx3/bQG7c7oQlaFFQjUCbPUddoEL8pmj4KAYq9UDY/pdr35HJTZPQJAZet5qFtaIAIr6q6yVXgC3Sa6kMbvDJw4eclhmuoVj1ajZx5zAccVcgqgZFsRfsGYENK0TEYSoWsuPKrShx8oQAid2W6qeTlJHmP/BZwY+6qD/b6v9UJ1fecsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OrPEM3FpwZHlnwvA25RWbB8MeljRcPNohJ+12a0KIU=;
 b=By0Pvlhlw4iKKG1hjn55WCTAX5EHINRLbZ7cYZktDA9PH7ZC872k7EXeTRxtepnoaWWpdofUs/Vs1ZCN3gSBvts46+qJbRnxaiQB3877YEtBZLFfOfq6FB+s/f0SyEJ/M56LAvBO0yM2VnTVjqD2g9BoiENKT+aILgCCAhv7lPFM0Bhv7yBnIFy9ygcLbIoh+wT8Bs3DoY9TlGuVF0EphJzxE0dyy7lVuuA4B+9Ny1dRzPgIj4ph6iq502YL/GyP0zmA3BwC/tBkqjYqoXxJH25YxkZedQqCOTvr2OIIzwSfTgm6V0DiYl1zX8kTLZZxyPY0k/B4Ut1w96+gKn6CEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OrPEM3FpwZHlnwvA25RWbB8MeljRcPNohJ+12a0KIU=;
 b=BcgVS8QSn63tTecGK2FarO8OROGOuFIDooXReN3feSSV8nSb9aUxsbBOrWafIqn+D4Muru+OczupcHJNJ74DvHD0bsHZgYpQCqLqfsBVbzIeUox0vJnrvCugnToO3EFia8FvuThtj3oWoamYp9ZcRApy7JmXQ0g7FZpRbrqqWaI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2174.namprd10.prod.outlook.com
 (2603:10b6:301:33::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 16:53:26 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4436.021; Fri, 20 Aug 2021
 16:53:26 +0000
Date:   Fri, 20 Aug 2021 09:53:18 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 02/10] net: mdio: mscc-miim: convert to a
 regmap implementation
Message-ID: <20210820165318.GA304524@euler>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-3-colin.foster@in-advantage.com>
 <20210814110328.7fff5z4hdhnju3pd@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210814110328.7fff5z4hdhnju3pd@skbuf>
X-ClientProxiedBy: MW4P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::17) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MW4P223CA0012.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 16:53:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2551ce2a-9ca6-411b-53d3-08d963fb0771
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2174:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2174D3B04DFFC71DD009E309A4C19@MWHPR1001MB2174.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w0Qdr7v8qrysrrSrRoPFqEzk1zNxb7XCZn0tMbU3aXP6EpCUAvigKL/o/wrP0uXf4mgCykGVyCvKrLp3DVltuATxflsuyg2sFQ3CbRzGX9wwuxsxckFAxRYdLe3JznPCPjd5Q2SkgUK5T7TcSF3mWgGl+vTMIGCF0z3rjfIJ+NZQ1KF7ZSpB/zJqlfcpdFpdtPGTWxUjRkbvKHLwGJwsC5Pik4j5HoFcO3ep5lYPmxi2nyeS4aC0dqPorPzPWZsD+Cad9HmSLacHDLe2LfyRs24u5Dv+wGV4jYY5Yi2CtIx5ugNKY1+6HfByU/cih6Y8tG19jbkm88LJbKjjl0XmBoP9OpfQP4ekSQ8+oWm5IlSbt3gbRylwZZ6ywU4JrVdk2hK6OaiapYy6UC3PsH9KHvYXfVdqLwOKMzifDLKE6wREEsqeH9kwgOD9aSwO1c8KgoHG4TlqlU7c+XhV1+3ss4Mb99EMKz5I/xUvdDh86HEH8CwmKdS8p6bQUO9tXqOPelwjKlBvLHNKd3g10W8qL2akCG9ybaDuwX9iHcaXWeBY0TRGhxVYd5+cQtvaWnhQ+m27vwxYz+lIHqQZwtIV/acUO0CplIIq/Jv80HsrBeWbubg+G1u2wolcY4o9z9wuYz/2ld23afTLUBEaF0CT4rBu8hOwhcLj9Hc+3+cUCX5furVNRH2vhtPR7m7+zz93Z09gYzGTV9hBuR/Fk58j8TrAeVDVopwVQspy3mwTzgL5dagFNdVJgj6pubaeV9vfx4lTWpkwANMWronpbY3GtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(136003)(366004)(376002)(396003)(346002)(4326008)(2906002)(26005)(55016002)(9576002)(9686003)(6666004)(8936002)(52116002)(316002)(6916009)(66476007)(66946007)(66556008)(33656002)(478600001)(966005)(86362001)(6496006)(5660300002)(38350700002)(38100700002)(8676002)(956004)(186003)(33716001)(1076003)(83380400001)(44832011)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTd3TWgzb3FURzlGUWpDaGU4Z2tya09KaUxQRDRhdm41NTZXam1vNjJDaEZT?=
 =?utf-8?B?emk1UlhBRDE4RHZwWlAzYjdRazFJT05yY0VjaVdRQ3pITXZEVDNwRWhvcmRy?=
 =?utf-8?B?aG9OY3dPT0Y1OTlOMlJwbURobEkwTWVHaEFHY3orZVpJVmNuZUduMThOektE?=
 =?utf-8?B?VjAyalB2b3NRMzcwYnMwRW9mbE01RlFNU2Q2anNIWGRkRTRRK0VqQXR6Q3Fa?=
 =?utf-8?B?QVZyeS9WM2pOa0xhVFFXMDdZUlpNYlh0SWR5NDgreXlwdE5maWx5eHJXMitj?=
 =?utf-8?B?VjQzRzVrUW9vdDlON3FsNWIydy9BTHZFWVIrOWgwUkZhejQ2TGJkNENTRnhZ?=
 =?utf-8?B?amNtd0NKVTg3R1ora2lRRXc4YnFJUFFxYVIzWi92NDJaSTI3VnhLQmErbjVk?=
 =?utf-8?B?U0ZOZ3RkcEVVNWZ3VzB2VjFxaTJjN0tJdi9SaytZRUxiNGsydmJsMUhpdGdt?=
 =?utf-8?B?UnV2dGZsb2pZbVhGalMrbWpidDJGWk95dTA0aDBzYjN0NUJHUm9ReXlvWUx5?=
 =?utf-8?B?NnRaNURpUitSdXc3WG9hUDN3ZXBkNkFpV29UdG9aaTVwbTRFZk13NDJUWTJY?=
 =?utf-8?B?S3JEd3lRbXZnUkE5a3BjUUpWVWV5a0xEa01mZTgzcmNUV0p3TEY4cHU4WUpp?=
 =?utf-8?B?c3A0ZW9jNy9TaWhudHl4NEJQZmo2Yjl2OERJQ0xZOWZoZ3lnM0hvZUdOaWsr?=
 =?utf-8?B?OFdBcW9PTWR5VlFTaHZxWDREQmRnRnRjT2hZem1tVTRoN0JLOFdnbkNxM2F6?=
 =?utf-8?B?Nmd6enNtT2o1WHF3QXBnckJmYWx2aHUrVmxXRTN3anoxazE5T1RvY09DTE5V?=
 =?utf-8?B?cUN0Z08xbi8yNGo4UldKbG5BMVhKbnRpbEUzMlgvTE5zbFpJei8vUnZOWE55?=
 =?utf-8?B?dVJYWUQvVEtYT2RLU3d0VUxsYUZTZHpnbzl2USs5cTk1Sk5aRWZQS0dzMHg5?=
 =?utf-8?B?MXdsSjBSVldYZDBSaTJzd2VsTTVpZDNtN2t3OG5IY2haNWQ2YVhNaDRTQ2cr?=
 =?utf-8?B?QXhtd3YvVVZpdmY0enRaYlppOHpPc1drNnJ6MUcrK2pmc1d4SzVMbDFQWWYz?=
 =?utf-8?B?UTZKKysyWXJBV290RHg2bXpvYUJEY2JuUmZEdHE0cGZsOHJUU1UxeTU3VGZJ?=
 =?utf-8?B?NWNSb0xwN3NBaHludlhTYmVPc0FBT3ozM2VsbnduMFVkUDIvUWxPQ09lYVc0?=
 =?utf-8?B?ZHFvT3V5R3VCSVNKWm02OEh5US9aNkdCb2lONU5JUkhwaWRMczVVOUU5STA5?=
 =?utf-8?B?eXBZNzF5eHJoVlh0dWVPWkdBWHVjSytGdW5scmRNbDZnSjYyTExwVzJteFJ3?=
 =?utf-8?B?OWFOOXdiK3BzY0ZyY2d5c1ZDTGpaTVFFbGI3MytUWERjV0xGeXJNS2tvYmRp?=
 =?utf-8?B?bmhEWFYzVXpKUlh6TXN1SUs2ekZldCtDY09jUjUycmMxdVF1MmtOZFZGQm9u?=
 =?utf-8?B?a3NmSzdpS25RamQvMDg0YWxRaE1RTzhWUEVxZnBSTUc0NXpWcUs1QVZ3aUt6?=
 =?utf-8?B?dVlVL290N283SnNPNHF4ZEw4ZTNlNThQL0lNYWN6Y1hxcFRBN0FpMDRKNGVB?=
 =?utf-8?B?RVpCa29wNGpSR0txZUxZbEFVdTdGSkVEaHpYbW91cHY4M2p2L1pnNG1yR2NH?=
 =?utf-8?B?VHA2YUVjbkJtM1lZSjFrcUhXd1lMbnZRSUF0TERUMkVqL2RKaHFGN0lpZytL?=
 =?utf-8?B?cVJWREVTYm5PbVlla3p1cCtjU2JvNWFaR2UwUnBvbTg4SHYzTVhJWDRmYTJS?=
 =?utf-8?Q?RZ8+a9ZUm5bp60s2yLg5+Kl6dnz5N/2qPROBQGR?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2551ce2a-9ca6-411b-53d3-08d963fb0771
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:53:26.5472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +92xYghq+PIrpZLGMJ3nv+jtMVmb4i25K/WYxlgs7y2fFunXOtH/1WzDvST4TTnuwXqHPUsdqJCRP8qpoepErHS9BrwKZkJ/ieBVcLCId4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2174
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 02:03:28PM +0300, Vladimir Oltean wrote:
> On Fri, Aug 13, 2021 at 07:49:55PM -0700, Colin Foster wrote:
> > Utilize regmap instead of __iomem to perform indirect mdio access. This
> > will allow for custom regmaps to be used by way of the mscc_miim_setup
> > function.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> git b4 20210814025003.2449143-1-colin.foster@in-advantage.com
> Looking up https://lore.kernel.org/r/20210814025003.2449143-1-colin.foster%40in-advantage.com
> Grabbing thread from lore.kernel.org/linux-devicetree/20210814025003.2449143-1-colin.foster%40in-advantage.com/t.mbox.gz
> Analyzing 11 messages in the thread
> Checking attestation on all messages, may take a moment...
> ---
>   ✓ [PATCH RFC v3 1/10] net: dsa: ocelot: remove unnecessary pci_bar variables
>   ✓ [PATCH RFC v3 2/10] net: mdio: mscc-miim: convert to a regmap implementation
>   ✓ [PATCH RFC v3 3/10] net: dsa: ocelot: felix: switch to mdio-mscc-miim driver for indirect mdio access
>   ✓ [PATCH RFC v3 4/10] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
>   ✓ [PATCH RFC v3 5/10] net: dsa: ocelot: felix: add interface for custom regmaps
>   ✓ [PATCH RFC v3 6/10] net: mscc: ocelot: split register definitions to a separate file
>   ✓ [PATCH RFC v3 7/10] net: mscc: ocelot: expose ocelot wm functions
>   ✓ [PATCH RFC v3 8/10] net: mscc: ocelot: felix: add ability to enable a CPU / NPI port
>   ✓ [PATCH RFC v3 9/10] net: dsa: ocelot: felix: add support for VSC75XX control over SPI
>   ✓ [PATCH RFC v3 10/10] docs: devicetree: add documentation for the VSC7512 SPI device
>   ---
>   ✓ Signed: DKIM/inadvantage.onmicrosoft.com (From: colin.foster@in-advantage.com)
> ---
> Total patches: 10
> ---
>  Link: https://lore.kernel.org/r/20210814025003.2449143-1-colin.foster@in-advantage.com
>  Base: not found
> Applying: net: dsa: ocelot: remove unnecessary pci_bar variables
> Applying: net: mdio: mscc-miim: convert to a regmap implementation
> Using index info to reconstruct a base tree...
> M       drivers/net/mdio/mdio-mscc-miim.c
> Falling back to patching base and 3-way merge...
> Auto-merging drivers/net/mdio/mdio-mscc-miim.c
> CONFLICT (content): Merge conflict in drivers/net/mdio/mdio-mscc-miim.c
> error: Failed to merge in the changes.
> Patch failed at 0002 net: mdio: mscc-miim: convert to a regmap implementation
> hint: Use 'git am --show-current-patch' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".

I see what happened here. I had my branch on the latest 5.13 tag of
net-next and it conflicts with the master. Makes sense.

I should have rebased onto V5.14-rc5 (the latest at the time) before 
submitting. A mistake I'll hopefully only make this once.
