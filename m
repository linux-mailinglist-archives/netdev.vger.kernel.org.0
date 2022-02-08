Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6997B4ADDF1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358751AbiBHQHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiBHQHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:07:49 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2127.outbound.protection.outlook.com [40.107.223.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B770CC061576;
        Tue,  8 Feb 2022 08:07:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1sEgkq6x7utTlmOj26O5BnJ9vsHuPryeXEkaVmQgeq8UlUTG6gFSetCq9Sv5L30HnCopdUxPF+y/1c0FzDgmM/f+M3cVk+HjrGah3JtoIXQ6fklEiz3xmBQWRqo+wrf/kRzIVg9lWWESvwIXj3SPsDhph+8Rk5CL/i8+HPBOdl3ubRqvdh8t/dNHNb/sej7HAvAHjvKWSVvox6QQ4MJlZ1CTyvSAYTeAZFmHWSBWsNXLOeWE5jCgxcipvq9SwqYoKoPHt+RhvrxkVtlbg4oMLPGwbuHyzML6+JeSkpeR422tPjNkP1fy1nF6cUZ82+g6ZfjKA0Pzqc2WCkM4xdm6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpdiiCxTm3ctZ5EdP7kuT7rha8JPF5VBx0941zh+rnQ=;
 b=obN0exJ2ocRGJNxloSPnsSNbVptS4D8YPVh981w8z7XB2MMoLMxxrVYotuXzgyc6j+yKeP7laM3VgOETxOKh81trmpzn/xvfqBPDopbcvhnpT5RsjGVGenGesqq4qURcL61s/46ZrPdZ1OLZah4SzpAa3526ZIhqI4TgFTEGG1z49uOkuanYWgCFuIzc4oZC1g4u7jrXYiMJk6ZldlFWWpJFfSvHG914gb8JnWOgLsUgpMD2Xin1Un3Qv6JxXSs+KhH8ck2mhmRWRrf5M2Qv4lpbWefsXWsWJM32TtBpBpRwXiUFi2DF8FWBhmgj2P/CY2EI6dIIkkGKkL/eX4yrHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpdiiCxTm3ctZ5EdP7kuT7rha8JPF5VBx0941zh+rnQ=;
 b=rslmMjT8441H2n1PCjnSZkAeD3sRyyF5Dqyl63WIogFeUu1ju7Y9tupNtup11gwwwQZcGh4hBiMNVNqnkF1PtLLVpiz+0uxwTdAklx+idrveKS6OKCKyS/ySRUmSnZpFZegxchp2kps/GtCYKMadRJ/2J9JaG5weW5b8Qg4T+/E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1616.namprd10.prod.outlook.com
 (2603:10b6:301:9::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 16:07:45 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 16:07:44 +0000
Date:   Tue, 8 Feb 2022 08:07:42 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Message-ID: <20220208160742.GB4785@euler>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208044644.359951-4-colin.foster@in-advantage.com>
 <20220208150303.afoabx742j4ijry7@skbuf>
 <20220208153449.wyv7xrv4kotji7mb@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208153449.wyv7xrv4kotji7mb@skbuf>
X-ClientProxiedBy: MWHPR17CA0073.namprd17.prod.outlook.com
 (2603:10b6:300:c2::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c89a6f81-6907-485a-c7bf-08d9eb1d244b
X-MS-TrafficTypeDiagnostic: MWHPR10MB1616:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB161617694B4B24D6B83FA6C1A42D9@MWHPR10MB1616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RhByvUKRShTvwtf5mq0Wnaeqg2v/N4Nh1x7GpzmJpIxv7SIVwFYUpGSXstos4Zwyvrj2IgnNbvT72z5Y/s4Kxupgj0vfxkbQ7uRk4xk89kZDaGAW+M1jwJ+FkowBMeL9s3BUfqnxL22e+IiUrCOFUFoKVyBKFpHoK8lICCq9QcVkrJ+fRBMu2uLPqhtXNLHm2uYIeZCdSMCyav001BYu6M1440DhEN6DK6LZQPTLlQJ3EKD9WbgLDgc9XfT9A6wFI76jFy0f53xcXk+ziO0SwSKfjYjNNTYSMjNM/p8fU7qIusXxGfsZJMPGNwE1uYSeDSuo18P9gIDVs7/WRYKrhY0wxuIt+laYk4DEtGx+dVh8rK1WJvkVmaS77JXEyK7HdsGi9MS58BZtKpYCrv31qEXdvIK8Nf85g3NDkRYzFVjzeNdOvo6b2sGYtLKmxK+6QlrfAnIf8oTxmjM/MNu6lmi5vffxaDbFM0ZObtTzqKsn4IeAAtJ51J6TMH4Pf25mGNhryArTa+FLlhU3ck8SSDEEZ/CFsqfJ/fb5f1twfH/dV6+iounni8PO1J30dEjGvGUJFrQwt2I8Cd5i9Vto+DpsmCFMqlNVuhtv/ZBnW+MQrfUfgdpz05j1EoBbBggu77accvHhiqM9zGFBDoqg5Tpp92n4aAXoym3GaCHlDLFwh77eToTWvORBuS1W/+qOrcFV/e4nyD5jN+pz/aXGMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(376002)(136003)(346002)(396003)(42606007)(366004)(39830400003)(6506007)(54906003)(86362001)(6916009)(1076003)(508600001)(2906002)(52116002)(33656002)(9686003)(4326008)(44832011)(6512007)(316002)(83380400001)(26005)(33716001)(66946007)(66476007)(66556008)(5660300002)(8676002)(38100700002)(38350700002)(8936002)(6486002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cp7y+YEbnjVLGf8Qbe2yvOYTwVRzwFPDUOySQfBsC6QYU2ZDe728ldbioxc7?=
 =?us-ascii?Q?bdNJr2xfOzoaodknPbcBWiNf9WhSJZ9L2rmLZOmmGXQHRw8jYYv4NtyEXV8g?=
 =?us-ascii?Q?n+URHkRp8cRfZmLnC+rN5pGiUJNdCT+/Stc6kO/bZ6jL+FGCuF419Rq5zyGM?=
 =?us-ascii?Q?+5cLjN25F5aTkWiRISDqHgKPPj0m11xmIb8MeaOf9Sv/CaOHBEPvJTZLO4Xz?=
 =?us-ascii?Q?mXfVhhvSlwcTHoXfZMNra3Z4slBLb0pT8AW9hPJ7gkPhjgglnmGGdfnv7uWq?=
 =?us-ascii?Q?E/wpwuJQx+bFtGJEr8Q7hXaXehOXWic2odhlYB33VVrh3hSKtHSJHRj9FXN4?=
 =?us-ascii?Q?GyfQ8FC8V/sZ9bGLEdMRyou7UABXLAUZfnGpI7FjGaFwz3KFDjKS5YFLh40a?=
 =?us-ascii?Q?vaJdgR0duDnGpWmhr+MWTrqb9WMtSsNemVoZnfqyULaZrE7r9Gm6C3IAM+IW?=
 =?us-ascii?Q?0Gf/SBj9DOjWKxPL1qlUtYehWZhGdXEnf8K6XpuvngdSbinvgLaPXrbW33Zu?=
 =?us-ascii?Q?w81hI9Q8idFOOK2PHM2JvaJqHdlw4oMFCXXqZFZgVP8iCSZGAHCwKUffDbcu?=
 =?us-ascii?Q?+cN68aZev5AfY5GLnkneas+CXfdz/J97JcK7cUO4vt7EVHozau4uVKPlKsda?=
 =?us-ascii?Q?F7boG3Ys38Tq3yd4GuB7e1MeZOOzK1UnFbN1Xq5T/csXLsRVQdOO7qZ3xc7J?=
 =?us-ascii?Q?n1/73F/vyYa5Enty6E19B0+h6VMCUQ8hKgbfRyJKui3+wU5DCVUkcExztoPU?=
 =?us-ascii?Q?J+377jbnnLY7JQ2vCNOf6i4jcjNDogeBEdf0z9rfAAIv1Zuk3UxjDF8VL8y9?=
 =?us-ascii?Q?Yrfyn6jCWO301CCzKuDpMjezJDdnkiwMYBvCZjT0x37EF5ysXME38h3jVe3m?=
 =?us-ascii?Q?CIfLVhfF6EjbLH89qexFUOeX/1H4YDpdN3Q2iGhCh3U+lzV95I95t4+k0n6g?=
 =?us-ascii?Q?ICYhDke+wzoebKQIPicS0Qzb7Sg0+V1+vVthfEqngybBAKvXPqI0JZ+R12wO?=
 =?us-ascii?Q?i/H+6142RhjNPLp1VGGifXnyxtEhWO3VsNKQUH4ONgwtSEAbjp2TjBSgwUHF?=
 =?us-ascii?Q?0E7vAFciIrsb9CRNzf7FwTvyF4IQ8F+LnVX0IUrRJzViZuCsf511hEpMFIK8?=
 =?us-ascii?Q?QBSTHukija9uYvG3ut6GPjyfwYkJmMZ/T5VCM3nuTxBNGFzkaG/dP+WpEJ1y?=
 =?us-ascii?Q?sQ+UqKyxQJwqg00yMHl7Q+gF/Pqhkt9q432lpmzJXv80hp+Me3BijSrm0YOE?=
 =?us-ascii?Q?ZIBziC99CNjoqdIdasNaJpjyzRayuL5vjIUHiAG2PE/ZLlUdN4a8wl9UdHqL?=
 =?us-ascii?Q?Kd6OEGyDRPH9DvqerhNkQxoDlNJ0KhrCbk23FscINjUhL8EOxApwprOPVIil?=
 =?us-ascii?Q?87WKrrhX1U9dTY81Vso66xcXS38WG9yetMZQozFF51HCZ10nVWkjjAqfBFxV?=
 =?us-ascii?Q?eXJ2aMur3ej2Ed2YBRWbmsMUI9lPd+xlAubWuxC0w4Z2jA97aDXHwZ+7vBZX?=
 =?us-ascii?Q?uvuWmMK37j7PEFBcD7XREj5oeL3DYfIQPXEPv+yrGsKFb8JcwA0flY9J2z3Z?=
 =?us-ascii?Q?WVhFq1TRYd8IRVNSn8suBn9nHyX2UANcvoRG4ZhcpLLO0Co2xRBz3spdGPrf?=
 =?us-ascii?Q?mqMUBYk9d9jctVuMDWG3Hctayr/6xApQFhGNu3fZSiMUx0H2LODm9WpcNxNV?=
 =?us-ascii?Q?/7C3n1grFmTPS/PyapPHDlRM4SA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89a6f81-6907-485a-c7bf-08d9eb1d244b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 16:07:44.7348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ABN0eEOhwDGEOGG0PBSH1UtkGsUuHVdFo31OdU9ruNWJD6knO55Grt9dr57KaAB4u1s0AoNgTAcKhROYBuYR8xbMmd1uuh+eXm0o6W1WEg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1616
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 03:34:49PM +0000, Vladimir Oltean wrote:
> On Tue, Feb 08, 2022 at 05:03:03PM +0200, Vladimir Oltean wrote:
> > >  	for (i = 0; i < ocelot->num_phys_ports; i++) {
> > > +		unsigned int idx = 0;
> > > +
> > 
> > This is a bug which causes ocelot->stats to be overwritten with the
> > statistics of port 0, for all ports. Either move the variable
> > declaration and initialization with 0 in the larger scope (outside the
> > "for" loop), or initialize idx with i * ocelot->num_stats.
> 
> My analysis was slightly incorrect. Somehow I managed to fool myself
> into thinking that you had tested this in a limited scenario, hence the
> reason you didn't notice it's not working. But apparently you didn't
> test with traffic at all.
> 
> So ocelot->stats isn't overwritten with the stats of port 0 for all
> ports. But rather, all ports write into the ocelot->stats space
> dedicated for port 0, effectively overwriting the stats of port 0 with
> the stats of the last port. And no one populates the ocelot->stats space
> for ports [1 .. last]. So no port has good statistics, I don't see a
> circumstance where testing could have misled you.

Both ethtool -S and debugfs show statistics that I'd expect in my test
setup. But yes, the port 0 stats would be especially curious.

EDIT: Just saw your message about these. Yes, port 0 is all messed up:
# ethtool -S eth0 | grep p00 | head
     p00_rx_octets: 13602161426432
     p00_rx_unicast: 4539780431872
     p00_rx_multicast: 9028021256192
     p00_rx_broadcast: 8980776615936
     p00_rx_shorts: 0
     p00_rx_fragments: 0
     p00_rx_jabbers: 0
     p00_rx_crc_align_errs: 0
     p00_rx_sym_errs: 0
     p00_rx_frames_below_65_octets: 4539780431872


(configuration - swp2 plugged into swp3, bridged with stp. swp1 into my
development machine, swp4-7 not up)

# pwd
/sys/class/net
# cat swp[123]/statistics/tx_bytes
44616
44668
52
# cat swp[123]/statistics/rx_bytes
34574
46
73272

# ethtool -S swp1 | head -n 5
NIC statistics:
     tx_packets: 942
     tx_bytes: 48984
     rx_packets: 764
     rx_bytes: 37808
# ethtool -S swp2 | head -n 5
NIC statistics:
     tx_packets: 946
     tx_bytes: 49192
     rx_packets: 1
     rx_bytes: 46
# ethtool -S swp3 | head -n 5
NIC statistics:
     tx_packets: 1
     tx_bytes: 52
     rx_packets: 1699
     rx_bytes: 80658
# ethtool -S swp4 | head -n 5
NIC statistics:
     tx_packets: 0
     tx_bytes: 0
     rx_packets: 0
     rx_bytes: 0
# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1520 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 24:76:25:76:35:37 brd ff:ff:ff:ff:ff:ff
3: swp1@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 24:76:25:76:35:37 brd ff:ff:ff:ff:ff:ff
4: swp2@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 24:76:25:76:35:37 brd ff:ff:ff:ff:ff:ff
5: swp3@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 24:76:25:76:35:37 brd ff:ff:ff:ff:ff:ff
6: swp4@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 24:76:25:76:35:37 brd ff:ff:ff:ff:ff:ff
7: swp5@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 24:76:25:76:35:37 brd ff:ff:ff:ff:ff:ff
8: swp6@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 24:76:25:76:35:37 brd ff:ff:ff:ff:ff:ff
9: swp7@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 24:76:25:76:35:37 brd ff:ff:ff:ff:ff:ff
10: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 24:76:25:76:35:37 brd ff:ff:ff:ff:ff:ff


Clearly my testing wasn't sufficient as there were still issues, but
there were reasonable signs of things working as expected on ports 1-4.
