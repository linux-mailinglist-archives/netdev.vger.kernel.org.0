Return-Path: <netdev+bounces-6933-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC03718D85
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 23:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90ABB2815EA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939A43D3BB;
	Wed, 31 May 2023 21:50:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F2B19E7C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 21:50:41 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2133.outbound.protection.outlook.com [40.107.223.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1374B13D;
	Wed, 31 May 2023 14:50:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayHy9fZB+boISbpFKFv2UNVCsRZsvX7ZPrPNrgVSn0vWCXaiR4xw/HzVG0LOKjyOjyHtSRJA0dKtzGOmnIIe3uBlYNQWqmw8uo+Vv01sQYsuASLGMz1icpO1PyF5QxUFS5HglU7+xjiIrfmXtkD/9CdllE28qy23vb0BM15tHl/XByRCpAm3gErST2yR4TDAMzBDC1361QnGhWq4Iefz/Bb4Gwzp5m5nLqyvNdp53suMI6R1Bgdvdc5l+NE0iUxsTJODJ46pucgB29vd2pLko8bujOVoW5l8dQMIOLeSE5Jv2cnKo96eIWAnwdMYbQJZNHOeuKAWboWpJOVrZba0Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ao3qtw1afTXdNMvtzM22aZDNLWxOSls7qYTfhYwJ3EM=;
 b=cLwr2r4sPZsP9YBlLkb9rUBqteTwlu3lzdEjY8cqmU0+zpqDnaetOI7cjECFgYqYwgZOw+V2iy5ZSeT5++0h3RMvrqGIjMG0N0/3G47Op++0b8QsvdXAHJp+GN7yNgbdunNBJEqCl6p+rpUfcPT/d0Rb/mW8XN9dUpD4/+1PgmVIxAOikZGkJuIM70gqD+DWpuIoGP5ZVqAO5/hb3DP3l1BX5knIOvNVdfZjVD3nwJ2J3O60y0LG6vTW3qQ44eYlrv+xQsla4u3pM0Wi4BG8P9mGMkvPjwKUqN7hDFe/iNBGxzJl/qe7clb8/7AbDSUfH8sd5QFPvZcwKKs3PXPGwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ao3qtw1afTXdNMvtzM22aZDNLWxOSls7qYTfhYwJ3EM=;
 b=ThH9U7Zm1uLBzhH8jAexkNXFsqDEml5zNIxyJvgJrKfuDYQVnb++hSXZFmxt8zwSu1MfSMQWB+Q5rEi94J7kix7ifMIAuam1XO5hVvyazN4j9kqITs8pUK8JTKW/V903vCJq5NJxePZ0Rv7WqrbsxewGLAABRMUXSpv1kvaDMsE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5776.namprd13.prod.outlook.com (2603:10b6:806:218::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Wed, 31 May
 2023 21:50:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 21:50:33 +0000
Date: Wed, 31 May 2023 23:50:26 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: pch_gbe: Allow build on MIPS_GENERIC kernel
Message-ID: <ZHfBIkdXeP5rc7Lf@corigine.com>
References: <20230530150301.9555-1-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530150301.9555-1-jiaxun.yang@flygoat.com>
X-ClientProxiedBy: AS4P250CA0001.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: 86ac73be-1c9f-4ecd-89dd-08db62210f27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YtB06fy1Xq0vEZ82s7kMnkTM65qf/JtLQmhTk4oUjkNkjcdHJ52gV6tB1vkn+Wni9gEE6u1BTSl35p/zSYe1FnFHS9ju/WokPvjT3QYrd7cVtujhIQ5lXHFFIGilXKhuVJJaX4H9hiDsPe9sT+WIRerAHKhs5WWPqm3Wm7hJF2kJKL+VjngWzYo7h3cPIWroXwtqz/o17U1d/FDFx/7hw+51UrbREO/rR7OOEHvJoGObV6zmX4qUMb1RC0U2Q/0Rj6omk4kDPDsIAs4wl3/OrvfMQptHlhvRXD1yxQkcENzllx6MXihMcIivcBKDWVRkzg6Yg5Rp/tA++vwYaabMSV3gXvDNqkKYcNnC6SBRkQjLe1AhKtu5px+1FDpYC1r8YnrAXaXmeVbSDm9VXG7kSknOKPtuie2PYeRW38O36ryTmucLhTBene6KL9xQl5LLqkNFG2VJ8ZFlyQp7JPzdnUDstbOQjftTe5D/40HK5BuEi6kpRCuVpvYVaUnBbyUjjrMffXQjGDJoFWhVLD3CidVYGDNrIU3TcqbRTd4y5jLurqcJ3153POs4yg6SUHiY0i0GQ3E0R8RK2M8dW7zblA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39840400004)(396003)(136003)(346002)(451199021)(2906002)(478600001)(186003)(6506007)(26005)(6512007)(5660300002)(8676002)(8936002)(2616005)(38100700002)(83380400001)(6486002)(41300700001)(86362001)(4326008)(36756003)(6666004)(316002)(66946007)(966005)(66476007)(44832011)(66556008)(6916009)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YcRlabFIcld4y3JNBX8OHWTzDKVtS5StRwX5xqcwk8ayFiEbUM5QlX7W0XBR?=
 =?us-ascii?Q?dLZdVv7hjaNQVWPVyNL2SU3ZYSRkp7o1Sg/MP/BVt38hkF7iLtaL1PaN0vt9?=
 =?us-ascii?Q?NZ4VbPuDLhJi4fNU6oNfc0zd7ATSGoLwMOoz3jaVazAtiZtCJjtIxyQeB1mn?=
 =?us-ascii?Q?w6B8J8UDBgxmv6ZIAU+Xf0JqH0EKWhE5nMr2dvh7Clb5dDrKOVSOEAzRK1K5?=
 =?us-ascii?Q?LFFOJvnoOzlskWPKJS9cRq/09bnlQP0SkDr41kgK+EWy6kvQiDmzzSQN+DQQ?=
 =?us-ascii?Q?EY2YNxHsscny4iHV6U6k9f+4uA1uKHmDelZbhDsBimswR2qqXRgfjbJDZOWL?=
 =?us-ascii?Q?okRtZjKiJdex3DDcCJv6WOpJl4sRDJ7jxnvrvhCvtQe7vcyrGuDCbXjBOHOB?=
 =?us-ascii?Q?RZ6abZ7ODa7JiqA6gAuv4w0mo3pXWIYaalcmpdYf4baat9bI0Ru7DV8YQn85?=
 =?us-ascii?Q?XNcHYw6ok/xH62O+xwahv3A9ifq5cNSDIu2lSBipK5unvd42YuIuoLJR8+5J?=
 =?us-ascii?Q?485wQZYTbsEOU4dJ9L2ESOuzyA82K15CRCnJIWxh+Ylf/9V6oAQqxAMTx8S6?=
 =?us-ascii?Q?h2Bwy1jUc+22X0AVxNJaVzWxbSRYCvK/yqRCmbgRqNX7oYBOni+3VEYx67LK?=
 =?us-ascii?Q?j08gVgo6y4iRHNSkLwVMY/XxKmFKupfcnfwCoQKnSH3RRqYWnuF1UnuzGIlJ?=
 =?us-ascii?Q?iWl20D+S1iT848iSrtxODg05hs+iwRbfKEC+cMPnQ7NfH9JSyOxCt8X2xw1s?=
 =?us-ascii?Q?fQF0161cWT8HQIizGv9IWwSHGpafedhJPPuPCTvyhDB9AGw7X+v0R0neivTi?=
 =?us-ascii?Q?E6f4CPEkyNMO5nWFZiOG/g4qvXhWs1j1eu8R40/O1JUHViTxKrsTBepkVW7B?=
 =?us-ascii?Q?beage/1MqzrVwb87O8ffonmteCOCPyLBats1l/4WISHfJyasY4fJ/vpTnEy9?=
 =?us-ascii?Q?EtLNEXVOMZeMK1k9rHliKQX0XSGMR7CxO2Hk+hO/y0rjkR5BWrh/d87tTPNr?=
 =?us-ascii?Q?psEox5W4asrO4QNH5FtYuWSx8KeJG1pRWgaKlU3gYv/V4E4EKy3kR8D0jDSt?=
 =?us-ascii?Q?Kkco0lBoZviAaZCMLQLQMI7v8dwN6pJp5MOqg4iSpXOzhCvv6+0eNKRrO9E7?=
 =?us-ascii?Q?uIslfy3TBu8Nct0zAnDVHTCDX+yWDHlNZfbZ9PTp53YCQs//VdoCK11HpTzg?=
 =?us-ascii?Q?bFotM6MZloqums/q4toFoaJnhvh8LCeRr17dmcbfxWxXhrFc2vXd21MtePhL?=
 =?us-ascii?Q?EeukK/vv+EPmaE7536Fyq9cMa76qYi2+yUtdBlSJc70ffj4lVnFqMOACLeft?=
 =?us-ascii?Q?H8mkNO6Xe0aBWSrNqFttzVXUU4YSmMXnf/c40/c2oQ6iq7gp6UbR6af6zdIm?=
 =?us-ascii?Q?SJEMpUNNl9m+z0QP5kfmpcnLc/XWxO+SHqoZP5tuc5yFG7QxwT29uxoUDVKi?=
 =?us-ascii?Q?UbJktwPIiZnivXsQAr3zBFcvGbHZSFaz29IgwZeZz9mROwE+k4zpqZziOd1K?=
 =?us-ascii?Q?KcNSRGoMq7WgYzHVyWfFOzzenwsNt1056IBKBRU0l1C8h+O0EKgopz82eOyV?=
 =?us-ascii?Q?AbJAvo4XUdVlEUWBv75VLHnsNXWA/LJIWAs030ppLNVQcVqFL36sBeXvQhcz?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ac73be-1c9f-4ecd-89dd-08db62210f27
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 21:50:33.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+SLIYNInVIOliRpC+oBptUYsitcqLpCnv53skFndhPmPKXBtCMFBXi0j+y4dQd78mAoz/faz+xMABGUCT8JLozlPsP0i+2H3VuUX4YcM5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5776
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

[ Fixed Jakub's email address ]

On Tue, May 30, 2023 at 04:03:01PM +0100, Jiaxun Yang wrote:
> MIPS Boston board, which is using MIPS_GENERIC kernel is using
> EG20T PCH and thus need this driver.
> 
> Note that CONFIG_PCH_GBE is selected in arch/mips/configs/generic/
> board-boston.config for a while, some how it's never wired up
> in Kconfig.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
> Netdev maintainers, is it possible to squeeze this tiny patch into
> fixes tree?

Hi Jianxun Yang,

with this patch applied on top of net [1] I see the following.
Am I doing something wrong?

ARCH=mips

$ make defconfig
CONFIG: mips-gcc-12.2.0
*** Default configuration is based on target '32r2el_defconfig'
Using ./arch/mips/configs/generic_defconfig as base
Merging arch/mips/configs/generic/32r2.config
Merging arch/mips/configs/generic/el.config
Merging ./arch/mips/configs/generic/board-boston.config
Merging ./arch/mips/configs/generic/board-marduk.config
Merging ./arch/mips/configs/generic/board-ni169445.config
Merging ./arch/mips/configs/generic/board-ocelot.config
Merging ./arch/mips/configs/generic/board-ranchu.config
Merging ./arch/mips/configs/generic/board-sead-3.config
Merging ./arch/mips/configs/generic/board-virt.config
Merging ./arch/mips/configs/generic/board-xilfpga.config

WARNING: unmet direct dependencies detected for PTP_1588_CLOCK_PCH
  Depends on [n]: (X86_32 || COMPILE_TEST [=n]) && HAS_IOMEM [=y] && PCI [=y] && NET [=y] && PTP_1588_CLOCK [=y]
  Selected by [y]:
  - PCH_GBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_OKI [=y] && PCI [=y] && (MIPS_GENERIC [=y] || X86_32 || COMPILE_TEST [=n]) && PTP_1588_CLOCK [=y]
#
# configuration written to .config
#

Other than the warning a kernel build with this config seemed to work fine

[1] 7ba0732c805f ("Merge branch 'selftests-mptcp-skip-tests-not-supported-by-old-kernels-part-1'")
    https://git.kernel.org/netdev/net/c/7ba0732c805f


Also, if the patch is targeted at 'net' then that should be noted in the
subject.

	Subject: [PATCH net] ...

And 'pch_gbe: ' is probably a slightly better prefix.

	Subject: [PATCH net] pch_gbe: ...

...

