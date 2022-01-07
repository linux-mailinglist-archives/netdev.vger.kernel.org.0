Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADD5487036
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 03:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345320AbiAGCPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 21:15:54 -0500
Received: from mail-db8eur05on2132.outbound.protection.outlook.com ([40.107.20.132]:15457
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345312AbiAGCPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 21:15:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1Hrs5apWYe6TiUCl42a6JQgkOHq+f9Qg8jZbIH4Osens7D/H86mzoYCsb2XAczwEN5o6ITdL3RFBAuNRPprfS4PXzH+5LggyFcaBgvsGNBDezvkjYCSx9tPD+k8Y3d9b19FtNwzijaHousS5rcUu4xjP2aDHzDk8gP3+kP0F8/PeISiddJGQHFXaxpW1yhoRTrJ25yeKL4aTF0BVqfsikOhylzRBe1Md4+7X+0DaS88b1DRsu7ImixnCOeG1O6VlPtbfnn/IHK/0sry2gPuzrNmHM1DaSBAlNZRi96eZ6tJoCQ/WAW+AdYREtKtx5Muva0xsfME736pEWi5sa65NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wx6jXPGwkLZbaLF92DzGv0pKR9WLhXgVCSKVBBXqhYQ=;
 b=PeaRwlHXAiTmm4ZiVR3DV4VPf1G/Omh64e4Ka+E8s3AxsK2PqVWza1m9mCij4LCDTeAB7AiwQmcCCXTLGDnAvivaDzhy4IXaqE8m1fyCYbfJCAKVZ1K2os6uVUQGbiwG5Y8EAsV9xKlC5N9vM+hGtWfCNMQkHYQ6HEl69wwvhzrmKj4SwHdn+olfUF1QvmZCDquQHnDZptjVrp7HQsESIQZa/dACd1NnNEMoW8XLIVQCBxTL/fCiZSb0POmhTEP1PeKIeKZb02i+HtoH7nqJi5Dl0F578OQkuHSqz5fSe7F4D4vtdfiLsOpXH5bjDPun2/T2yewfLPOG3dUhBzHgfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wx6jXPGwkLZbaLF92DzGv0pKR9WLhXgVCSKVBBXqhYQ=;
 b=fTakXyYndqH1ve8H4r05uCwF4B6H6da3vTccqWa5KoB3N/tagyIVUzKSHHvSBWhjwomwAIo+K/bEKgIEXaQOr8YVnlSU8iieDBkacSSgZjP+vSMpCHFLfuC+KOD33cifh5e7QclU8LXVURiC/nwIRM9OGLczZSDPUC7hwg7ULyI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PA4P190MB1136.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:10b::20)
 by PA4P190MB1117.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:105::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 02:15:49 +0000
Received: from PA4P190MB1136.EURP190.PROD.OUTLOOK.COM
 ([fe80::dc32:681:7104:d4ad]) by PA4P190MB1136.EURP190.PROD.OUTLOOK.COM
 ([fe80::dc32:681:7104:d4ad%3]) with mapi id 15.20.4867.010; Fri, 7 Jan 2022
 02:15:49 +0000
Date:   Fri, 7 Jan 2022 04:15:45 +0200
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/6] net: marvell: prestera: Add router
 interface ABI
Message-ID: <YdeiUcL476kdanpP@yorlov.ow.s>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
 <20211227215233.31220-3-yevhen.orlov@plvision.eu>
 <Yc230kOuj+tHOkjQ@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc230kOuj+tHOkjQ@shredder>
X-ClientProxiedBy: FR0P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::20) To PA4P190MB1136.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:10b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 373fcd3d-efbd-49af-ab68-08d9d1839f39
X-MS-TrafficTypeDiagnostic: PA4P190MB1117:EE_
X-Microsoft-Antispam-PRVS: <PA4P190MB111782F62BAFC4A7F5C2BF08934D9@PA4P190MB1117.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kXKMcOE7HQJgQjiYlsQSR/hnU53b2qXdOyZdv3xqTUQWG0vjB78rb9KbWv4UXUBmy6ztDbepH/BhG2xX3JFZAPwupxH6xP2ozrF8MUZTntPokxwf03/i10H+bLGS4I23PXbVzDLeW6IeCgY2OQ+Na/aPar8oNJ+236CYgiGz6E0If3Uk1T9WpZgql1f1ee4lxz0B4SOXKA2zyGpR9F8LLYY3hVP429yA9gWjJbC6cGOP0FQ2qlauCs4QUp/+uxe3WItc7WCaI2kRJAqcg3FZPKMWSbMDUKBanHDw1SwHtICDKPiFXIAWnhBJtArVS7ZN5BRy9DGuscn1mNv914mpHZPiRSClsPjrFK2cxlF5xcSUD8qA3AhhyxRbYOzJ8oqYv5ImjdBphDtYVXbeBexN2GllWclvzlQiPHg4lEBEKp3FSulhCGOO/5MEQKjhDOZNF5YfraFaNMKGyOcqld0koVcIBjjDwr+x9tS1j0GBfxpzTDQh7HD4lpYCshLFqlkH/lo2p1ckvkpxSnWMQawBhSWGlUg91+BppgR2ADVRl96ZOvGMOvOy8s1CUJzWnhJPiFwl/02b7dVSDjJXlmdhYCpvseUfCHAmjvV/46fY57VCKkXZBBcKP/SOuqBoVNcyI40kv7hdUzGCn/9K8tp4FO+MYkgFB4LmqO/SME317YInclzMQUKVuzlwCD2S4EQeJceJoxa4BKi6d2QClWdm3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4P190MB1136.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39830400003)(346002)(376002)(8676002)(26005)(52116002)(9686003)(5660300002)(6666004)(8936002)(54906003)(2906002)(44832011)(4326008)(316002)(6512007)(38100700002)(508600001)(38350700002)(6486002)(6916009)(6506007)(4744005)(186003)(86362001)(66556008)(66574015)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WGjltiKtfs6PHLFYo7oaxRLLQXGz9zWQSdeUJE2wUAB1bR4wPhgKgnwzrZpI?=
 =?us-ascii?Q?zZBqksrAyG0BnLOnlpIjn6IvfAXz5d8KW1FUIn9dMCmzPBLgrksCbDBikbHY?=
 =?us-ascii?Q?rceuHaQv2Uf1My+zVmm9rvQbFC2DVaQ1vn16J1lHeXCMAAOpxStLbQ50CBDT?=
 =?us-ascii?Q?+qZKb9Q66l3/m07ZNSB1C1D2ow4zhlm7DCxFg6jyXjdfhdulx4o57O0D2uoM?=
 =?us-ascii?Q?n+2Ceu+bZ3tpDO6lNmunAT+MBBN/5dOrozDpg9k+8J8Es8/rzt/muYBghQBR?=
 =?us-ascii?Q?zd8wvCfGOSNQlgWO0vypb+qAR1IqDIvToYbUOCLvnyTL7OH280NpNyV81FNa?=
 =?us-ascii?Q?UrCgeFGPpbqST76O792h/bNoLe/0F75tUnxGNnlVUFCRlRXqBDoSyQKfW7VA?=
 =?us-ascii?Q?8o/9exI5EP5ky79hAS81Iu6eTvQjWae1SwtVo3tq1j9PGLaoRZ1zjT03yris?=
 =?us-ascii?Q?lKwalTIRmRVy6Izpl0UaJbdhGNtZFbQRvy3P1pewrAuvBI2F1jx+//AwR/jt?=
 =?us-ascii?Q?Pgvc5jktqXH+VHAMx+Q8x8u6bFoqrvzuEkY2VfUn4hNzmCp/eJNjeTxdDct8?=
 =?us-ascii?Q?bPn5a+pRwF2ys+qgTKkM6Hp8A+hFfgDwJgf2xsOTcpTfqBT2rveJIvb7ZRUi?=
 =?us-ascii?Q?w3njBwHIegLXJHxBrYuY/y6ivClyXTGf0hy/xKv8zWrjtHiHMvnwClnAXbWx?=
 =?us-ascii?Q?83OkuwLo6Tctnn8s6Qxoe0VPHXDYCbjRQ6WKo+HMS/+SGTgsWqHNewhubcQE?=
 =?us-ascii?Q?CJscuZ8W1DX0ZVBdtFG4zkKXIPWyDq/awkGACz0KBlBZdoeBJZhEH35mEEH3?=
 =?us-ascii?Q?ZEFV+gAPuao4TvyPJwKk7Ah+bYNdJo1P8M+IxBt3OKTXJXS1YX8RJuzoBZWz?=
 =?us-ascii?Q?sypGMdpN/yF1Nb/578xFUim6ZINko064Gr0qySaWGD3RuDEvrOYP7zrJqTlm?=
 =?us-ascii?Q?HXA+ZoNyxtnSXJtbVUqvXCuy/7OeSAeiWxmL01xI/01cYsFATgzwI/v+Vhvr?=
 =?us-ascii?Q?T+Y35lGx6+v9Tk0Nyzizc2G0MK7zgL85gVO0gjS960SGeLVzJNpY5WRQ1+Cx?=
 =?us-ascii?Q?LzVFIOBm1VmfXP+96F4B6CMR0uxbI8GDZKVpgqHZrn0ComuPG4vqOglNYPPY?=
 =?us-ascii?Q?ajc4wPRIdzjX9KEgIatE9As/JXJaHy1DrHTwbbMasvGAbDnuCiCcl+vSukl+?=
 =?us-ascii?Q?+85516lmEiR6HP7ocfbkESNlvJagX4jgLkP36EfHGdvF0Wj2dMQ0D5migdcF?=
 =?us-ascii?Q?p3b/C4uo05T8vn6vBw08zxBO2uZabArugfMqnr6sK/8cgxTUaqEMW6gS09CZ?=
 =?us-ascii?Q?opkU2uqCZikCSxhwdJTDJdmncahIX+ol0UfZIIbF5i0pqwyaLwZRMSakRJug?=
 =?us-ascii?Q?x7nqgvsZd122ibMqza6jpY1rlJaMIicWqOxrBEQ8K95lY4/jNIvEVdyv5m04?=
 =?us-ascii?Q?XYX+MLSqLNOXWU9AKcOviLGfOVxNdHWX26JEfHC6uqq0WnnVB2OU9XDcHjvg?=
 =?us-ascii?Q?ahaQYjdi+g5Qh0PLOL7PD7AuWTPNPtRgRVS1ehbYQgEtHrIICgeXGxKNjWZh?=
 =?us-ascii?Q?AkQdbVn6aZITbgMIl6Ha9tTLwRU7IGsCofVN1C01KQjQyXHj+M77Vp1rME6b?=
 =?us-ascii?Q?TW9fTsZNsH2hNBtrh0Cl0aWqF5Z0rimv4n/llVBoxPu4rMampeVBeApPIClZ?=
 =?us-ascii?Q?I2QMRA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 373fcd3d-efbd-49af-ab68-08d9d1839f39
X-MS-Exchange-CrossTenant-AuthSource: PA4P190MB1136.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 02:15:49.6444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMTfW6at9PbKYSqQ+xYL+iMUXSTIaE99oiOu/Q67x8XiT/eHDNY1sGkKOIqaqJVsreuLAhi3sZtWHxECRWj4q78t58+SiTfEWMIC05M1dE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 03:44:50PM +0200, Ido Schimmel wrote:
> On Mon, Dec 27, 2021 at 11:52:27PM +0200, Yevhen Orlov wrote:
> > Add functions to enable routing on port, which is not in vlan.
> > Also we can enable routing on vlan.
>
> I don't understand these two lines. Can you explain for which netdev
> types you can create a router interface?
>

Sure.
For now we support only regular port (has no upper or lower dev).

But ABI potentially support RIF on bridge/vlan (see prestera_if_type).
This feature will be implemented soon.
