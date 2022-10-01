Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12CA5F1D3B
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 17:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiJAPjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 11:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiJAPjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 11:39:04 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49394056E;
        Sat,  1 Oct 2022 08:39:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3/3qaofO0bPOolyxZz/VCTciEqlYAjXR7jHc6OnMHVMc0sABxzCKPo6LtNROaUZgpfhqjRPgRDesq5c2araJnSXBBwY7a4nEv1n64mEzBhZKpwVZ5vWQUqPb0uRbUymi4DGRl4gx0Dg1cPDuBKIVTbBHoKt8DiqMbcE8Nx+MnEp+eFHSyjoJMNMkVJVGAqHrNZXOZq369ByHPIJqD0DxLQySlemIH9xYT/PH/8emkLSRkVOKMOpFN/tP+mI3eGig57fsUj8VjcHWs9n7WbUnNa5B8mtzAsaAr7Sc2OxyrhIIc6oTxN/mn7qQgXJHzkXshnx76wvvowbAcFEhJdkbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyKks1BOcDw6FiARq/bviVPjXI8r6mHUo7uFPUGgDiM=;
 b=AoCYpg9zB3IRB4AXBh1ue8EwQMC7id8zQvMgI5zq8gs0/j8f/8+05kOEX3Tpyv2qlkAskZIO6rS7Uwn646lN5sAdmUFS/dQUPihNAinmPEdAqCrNZhB/2TWpuOvKhwnpBzTKDPkmzGc6r83jWt34yaan5pdLJux4diV80WXZcdRSU2hvyb+4fEnIRAA8ZLt4lKCweE4nu/B75zeITD0O/JoK9+J9N2BjdGMyzjFzd/umAHYNrcB9imMs/RCf0NGiLvGhqwTDVAaOEiZqSnOtuM/qUvnbDXLEy3N68wk/xxTrWwZDvmFNrRd84kQuoRsTi0+3vMDR+s07Va9UI5ZmoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyKks1BOcDw6FiARq/bviVPjXI8r6mHUo7uFPUGgDiM=;
 b=HTySrFSDXTDsAakvTPk2v02Ivu0mzS9B1NbkFM7vpfU9wZB4rjzPCM9q3zGunu4DYfuKveTd/K/2BDXdAQ5O4QSGhS1FsJWUiLefI4LBXDdEmaV+/7PZMAAe+z+R+WC5Y8pBM9XBlZwxYT0mZ9KYJFY5HXQWi36WbkWgN94dr8u4Ld+6UvUARDdi8Kp8PHXLxelDSH1QSRgLB+87npOrzMd92CE8L0P67Y2TdX0zNrGAd13PrwhngB0YH76AXlvZ7RgV19mja3AtjHnN7COoo4Ap0f4eANkviFf20NMzqnZt88n4F+tYFsaYtuPHBVG0z5VxhyVUdFLFhi4JXhwT5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Sat, 1 Oct
 2022 15:39:01 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5%7]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 15:39:01 +0000
Date:   Sat, 1 Oct 2022 18:38:54 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH iproute2-next 2/2] bridge: fdb: enable FDB blackhole
 feature
Message-ID: <YzhfDgqjBvhqNUHX@shredder>
References: <20220929152137.167626-1-netdev@kapio-technology.com>
 <20220929152137.167626-2-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929152137.167626-2-netdev@kapio-technology.com>
X-ClientProxiedBy: VI1PR0701CA0046.eurprd07.prod.outlook.com
 (2603:10a6:800:90::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL1PR12MB5221:EE_
X-MS-Office365-Filtering-Correlation-Id: 152f15be-7377-43d7-3f71-08daa3c31025
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1kYjBKQMZlwpRYt3F8IgL8ePMEwBmM3rgXuu5PDyZxaZPVTNHr7ZHU/uE6LlciVJHIi2qHVNL5rtUWmtjJ8U5I9pwByTsCTow4H7RhaKWCkWaQake4VfB7n78WK8WV3rKMDdUvQqiA5LMxHax3Rv66whqNHCdUuLZGoYa+cIjLqsszzR0PZ+Wdcf9e382c+psMyn47DNiImunnp7HBG7T0YvrMxlsDJo5IZke0ozBYp6MQyW7m4+4WVeq8ra3qyCdpOKDHvakZJFhKi1Vh/y0lImWUTk3Sxptp+12edXaynXPkhlQA4bkzdZB4/krpC49xS5mALcZUVsU1fMYQrM/1328qqJVP1XOD0jMlSlxJ19eFgXklv7+2jRQ9mPSTQZvZ1z1etu/QclboYZZ7sLi2QKEY2tlawVPYUxrm2DXnVOnM11qXM176TtzPAkU/ROA+cZwXPTIeijVrbCesbq/hYDSw35/UNw8Jx3TwdYhAf9CSrapwwtVVNx7CvFtI1M4h0XHvGBNfqIy4i0OB4bzxZlvCJxIbiTDpxDIk46sRn5FqZRkcneKndQcpOsIEIpMBn0fMTYLMo7sH7VTl2EiayJG2Gn5tCtZOma7j1o3KHi1Z1eOZ6uUrCja+M1+y30ZUcNhzHZpw5JZZHE0Z8v8k9aeLYoQ5l/wc3ixxXg4uTWSqJSTGQ372Sg/vQNRYu5Lbzy5tA7zdOsxAHxrSpZBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(86362001)(478600001)(6486002)(66946007)(8676002)(66556008)(66476007)(4326008)(41300700001)(7406005)(316002)(54906003)(6916009)(5660300002)(33716001)(7416002)(8936002)(38100700002)(186003)(6506007)(6666004)(9686003)(6512007)(26005)(83380400001)(2906002)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pM1KdrDYzrgSiJtNS0oND06t9ev7G8eQ3qLrHyBdNhvVjAM/ZWZ3gOPXi2re?=
 =?us-ascii?Q?QNyIGtxD1Gx5WaNHV1GDevrc948uTTNQ1Lt5T7s65Kqgx7QX9kMTSwFqOHWT?=
 =?us-ascii?Q?4/qbmSShRiEoTCz+tGmvwZ1/d216G3Ld+XDneBqjmYJkJUlwC9oLWjWzCu5m?=
 =?us-ascii?Q?Y2Pt6/Jz5SOc8gqTDSeAvGjQqbJCviaQxELQcmKz4H4GkzpV1vD/5FAJB+GN?=
 =?us-ascii?Q?ZlafxgifAU4dJXE5SpASYK4Sldl7Vo9T9MbjMbJtthxUSVRAldDYm3ngKq0t?=
 =?us-ascii?Q?sNYI/7YugQCob5fY6NdRUg2fYXRXVvv0dPAePA8n6ZBlGvMizU0fukzSTUGc?=
 =?us-ascii?Q?uwmEcNPDGHpVjTJSoNNCKOYE1cQekO+8NYgiU2S3dul5DXM7aFIWdRf2mvdR?=
 =?us-ascii?Q?QupzT2oOqewpCzbkGF06RlahCmgvrPk5VLGcIPsGS8QcC2Sl6My1KTxEGoKG?=
 =?us-ascii?Q?FbmcBC3ZuDE0aCqrJTGSiI0n3q6ylbAJzWf8bNNRnhtL0TicebO9sp9QEp7h?=
 =?us-ascii?Q?64Makp0/FNHsk9yzzxG81JWv1Nfqefyn9hw/ZjKBgL2XAD7jIH+oCn2crwlt?=
 =?us-ascii?Q?cdxzeGuBR900KvB3ZqXaY5v/4sBBJxaWB+a/h7SaCmHChndO7tloxysT78yR?=
 =?us-ascii?Q?gAQX57Dgycm+ni4HYAo0m89ausxs4ujsKr/4fGMK+5IC84+NNqqH8qGu//Ns?=
 =?us-ascii?Q?up8aeprkj3Nj+Mg/4nNJnYwvhF3Xdt2gajcxiwljGBw7gzyeRjPNJZPN3JCJ?=
 =?us-ascii?Q?hMGh+4uwuvZX4tqVDQAViouQ0/xXFGbVwuygLZscfr1n9f1GUE7w0Xlm/UBm?=
 =?us-ascii?Q?fzFgWTsJVkj5roKYILymeQ/R7KnCNeRueDHwoRm/0F6xWBWpHSyZqWbndt77?=
 =?us-ascii?Q?UvEMn2IEEHlZc1W0LbfkzLKcu+9KpYeTcUXhVv6waM0wAadMOUazrXLWKEVB?=
 =?us-ascii?Q?kORqSawJDFJqiidrOqZZECg0KzYHmKlhudvqFFsxjMpxTZyl6Y72OII9Cnl9?=
 =?us-ascii?Q?UyYklFOn4wMD/A5GEbb40VDj5dvo6Fg9CjZJLbV5OdQrXkyUNo78iT7WZkpd?=
 =?us-ascii?Q?X61ND1tKJ6aCsk8d0MJiG99pk7CmtIZ6XOIgMOBiL5vJKH8I6nOzO1RgxuBs?=
 =?us-ascii?Q?FaIEJn6hc8+EQd0cAG8siUeEIaV1iiRf/sbjFNRoE0upZlhHDuNrNZxcQCOd?=
 =?us-ascii?Q?24R60HTWydu8iZazly1kOGyUwzMMNQ9PTbeZq9NkGAsAhq1pbWTSttNmOVWV?=
 =?us-ascii?Q?3wzDusuJYe7ra/CUc1xTb4vgmalrnMCUNgcqzMpM3LgvrFqSlXmCiqE81TMB?=
 =?us-ascii?Q?RhJhTeU3or8/zNjRV4vN1FFuI5oNtWuZYpV/kXHQjeQ1IaB6i03NYDc8OgKy?=
 =?us-ascii?Q?LnL6GzEa5dDORcKdPZTwYi95ZKai7MFRUHAKLp/gta8sBI37PIoy2nYuOraB?=
 =?us-ascii?Q?WqxtzV2/fpcKWo1lMNEufo4s+EN5X5UfDuWJsonWlIrWrA+TK50MD36zNM9i?=
 =?us-ascii?Q?pMq3qYzkLAyCb6Yrnh8VngdKWSzEBuKpydLQ2ndYxcPaA+Au3yWGqJZuJlDX?=
 =?us-ascii?Q?AIaCDpmEPqHZ3KnyRQiuAQZlX6+kiOcqWEVcR7xG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 152f15be-7377-43d7-3f71-08daa3c31025
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 15:39:01.2735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCqWlzNW1Vs459NiGTABipFxE0b+2WrHauJ+mrNcm7pBBL3+pe9rxWT67K/VEuVMNyBgJJiroeqeoN/ODEo2cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5221
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 05:21:37PM +0200, Hans Schultz wrote:
> Block traffic to a specific host with the command:
> bridge fdb add <MAC> vlan <vid> dev br0 blackhole

Please add an example with regular and JSON output.

> 
> The blackhole FDB entries can be added, deleted and replaced with
> ordinary FDB entries.
> 
> Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
> ---
>  bridge/fdb.c                   | 7 ++++++-
>  include/uapi/linux/neighbour.h | 4 ++++
>  man/man8/bridge.8              | 6 ++++++
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/bridge/fdb.c b/bridge/fdb.c
> index 0fbe9bd3..2160f1c2 100644
> --- a/bridge/fdb.c
> +++ b/bridge/fdb.c
> @@ -38,7 +38,7 @@ static void usage(void)
>  	fprintf(stderr,
>  		"Usage: bridge fdb { add | append | del | replace } ADDR dev DEV\n"
>  		"              [ self ] [ master ] [ use ] [ router ] [ extern_learn ]\n"
> -		"              [ sticky ] [ local | static | dynamic ] [ vlan VID ]\n"
> +		"              [ sticky ] [ local | static | dynamic ] [blackhole] [ vlan VID ]\n"

[ blackhole ]

>  		"              { [ dst IPADDR ] [ port PORT] [ vni VNI ] | [ nhid NHID ] }\n"
>  		"	       [ via DEV ] [ src_vni VNI ]\n"
>  		"       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ]\n"
> @@ -116,6 +116,9 @@ static void fdb_print_flags(FILE *fp, unsigned int flags, __u8 ext_flags)
>  	if (flags & NTF_STICKY)
>  		print_string(PRINT_ANY, NULL, "%s ", "sticky");
>  
> +	if (ext_flags & NTF_EXT_BLACKHOLE)
> +		print_string(PRINT_ANY, NULL, "%s ", "blackhole");
> +
>  	if (ext_flags & NTF_EXT_LOCKED)
>  		print_string(PRINT_ANY, NULL, "%s ", "locked");
>  
> @@ -493,6 +496,8 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
>  			req.ndm.ndm_flags |= NTF_EXT_LEARNED;
>  		} else if (matches(*argv, "sticky") == 0) {
>  			req.ndm.ndm_flags |= NTF_STICKY;
> +		} else if (matches(*argv, "blackhole") == 0) {
> +			ext_flags |= NTF_EXT_BLACKHOLE;
>  		} else {
>  			if (strcmp(*argv, "to") == 0)
>  				NEXT_ARG();
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index 4dda051b..cc7d540e 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -54,6 +54,7 @@ enum {
>  /* Extended flags under NDA_FLAGS_EXT: */
>  #define NTF_EXT_MANAGED		(1 << 0)
>  #define NTF_EXT_LOCKED		(1 << 1)
> +#define NTF_EXT_BLACKHOLE	(1 << 2)
>  
>  /*
>   *	Neighbor Cache Entry States.
> @@ -91,6 +92,9 @@ enum {
>   * NTF_EXT_LOCKED flagged FDB entries are placeholder entries used with the
>   * locked port feature, that ensures that an entry exists while at the same
>   * time dropping packets on ingress with src MAC and VID matching the entry.
> + *
> + * NTF_EXT_BLACKHOLE flagged FDB entries ensure that no forwarding is allowed
> + * from any port to the destination MAC, VID pair associated with it.
>   */
>  
>  struct nda_cacheinfo {
> diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
> index 40250477..af2e7db2 100644
> --- a/man/man8/bridge.8
> +++ b/man/man8/bridge.8
> @@ -699,6 +699,12 @@ controller learnt dynamic entry. Kernel will not age such an entry.
>  - this entry will not change its port due to learning.
>  .sp

Need to patch the "SYNOPSIS" section as well

>  
> +.B blackhole
> +- this is an entry that denies all forwarding from any port to a destination
> +matching the entry. It can be added by userspace, but the flag is mostly set
> +from a hardware driver.

I'm not sure the last sentence belongs in the man page. We have no way
of knowing if it is true and it can change with time.

How about:

"this entry will silently discard all matching packets. The entry must
be added as a local permanent entry."

> +.sp
> +
>  .in -8
>  The next command line parameters apply only
>  when the specified device
> -- 
> 2.34.1
> 
