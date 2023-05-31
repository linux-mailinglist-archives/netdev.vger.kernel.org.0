Return-Path: <netdev+bounces-6753-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE500717CEC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFF4E1C20D95
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2986513AC9;
	Wed, 31 May 2023 10:13:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C4AD52E
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 10:13:08 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2107.outbound.protection.outlook.com [40.107.94.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7E810B;
	Wed, 31 May 2023 03:13:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqN54jzSbto/VSsd33qbNjGI+ntg2JRMyds7OYullop+/Nrxns4MvIel/oCNdTU+nfUPlQgefoL0JSAaszoMfNltMNV5MmzfRQDUzha5NYDXCtRQPVRi9bzf2tHgUS6mKluAw0WZdbTUyFcniVsLBnwBCI5UuOojLvGrBsXtEdmzIwfWHPLCKm2qR9GPwgKf7aZpTtVEcaIulq5PupexOGtaw+8wH9s2ltIcUYdhpKJv3LgPSEZFv9fKJOmXrhSsGJhaRfCnJaCzUxp5qPZo5rC/yJvvAoCb1gUWXhxncub7dzIb04wEnuyTDx9tdbBifyRF1o4yGZstJNWB5LtbRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVBuN1zunydNV9eKKT0thfUsc+CL4eaCMJOQwNoAhQU=;
 b=Prl+bS03iA8NUx//ue+/Rbopz+SIqhDOkkJml0HWVHlc0IsnCqzWWtSvojMLg6kXMeWItCxdn5/HaEFlTvJa17hAeR+aYPGSW06jf0luhl/KCsoP0N+bqPlofUWq+938UbUS996d8lZioZEo1NacPiEzewK1QIOluo2v6Ysxibl7nKDcklgck2PckrpFEGVFPDgVeEpBpff0doVm0k5BKkZUm4G9fAF2OaXr1XBMaTT/Q384XaUGNTKp2Ny04zt29vbSzDGLI7YsnKiXdm+vpNJnxM868s2gVOgFQNVwwVKjWvGyf8kWM+wcTS7modrBlk5H41W6dj/y6KVXX8FbTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVBuN1zunydNV9eKKT0thfUsc+CL4eaCMJOQwNoAhQU=;
 b=gl4ygUhF9Zxi1cHOtgTryJKkCtgp7WmuxlagVinNPOFsd+jPjVW0pnBsOrGB62OmrhwrX5wxWDkLKKzLm/iSoy6beb4jD9g4j3UkfZKXP5F7bLc4p6hRkOMOlTTQbAuGpI3fxHLdbQzIsArSzmnmleHqeHav9zCSbhUafB8HzVo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB6008.namprd13.prod.outlook.com (2603:10b6:510:d8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Wed, 31 May
 2023 10:13:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 10:13:03 +0000
Date: Wed, 31 May 2023 12:12:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hangyu Hua <hbh25y@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, simon.horman@netronome.com,
	pieter.jansen-van-vuuren@amd.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: fix possible OOB write in fl_set_geneve_opt()
Message-ID: <ZHcdqPFZODXF/U7m@corigine.com>
References: <20230529043615.4761-1-hbh25y@gmail.com>
 <ZHXf29es/yh3r6jq@corigine.com>
 <e9925aef-fefc-24b9-dea3-bd3bcca01b35@gmail.com>
 <ZHb/nPuTMja3giSP@corigine.com>
 <ebdc1731-3647-8b58-c66c-db5bb09f5bfa@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebdc1731-3647-8b58-c66c-db5bb09f5bfa@gmail.com>
X-ClientProxiedBy: AM0PR04CA0069.eurprd04.prod.outlook.com
 (2603:10a6:208:1::46) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB6008:EE_
X-MS-Office365-Filtering-Correlation-Id: 64e88831-f81b-4d13-6d29-08db61bf9e7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vEKURoGgWC14BarjIgAo98aD0MMah2h566aq9aZx+ZIVcOIS0/Y3ZKSRqqqAOcM7IoiMD+AFK9zXJekVNxOjLZSowpiPe6RdxcRLzbVGs4sXfVnAVSzgnHfNKRVA3cu2gqZUjvGqDa+0jtW2Xi/vTqb7am4+of9/axZ87n4GdMcjVCTxQPgbgRYGmfJjFWAfPqhjE1G+IR09EGwH4e6nO+yAwiJhi9ndXc1/M5Y2J53jgPvyDocjkzO5OZLo62P6Bf0Y9Kydj6DE2zAX7JlHD91J1wEhN7EIoTCDsPTnLQOsvn4r4IZFHH0Z0WuDzFAKu0TLkoMbzy7w91a9N/bTTeo78N7MZLGnFclKhxG/F/nLxfZSqceq0b5fwc6YjfUUOnstaxJt0Loq583BMdFdgRJ4yeW0byAAV42jtvbcAJeLksdX9x/xqyDBirmLeCA3eetShcHzlpfS1ljoLbZwj3CBGwWHPnkiFlGwYf5QnsGGpBjI4wdq6r0xiUTwGOgJJ6Omg5faoZk+hPfsgkpVus399v7QV/SLY7siNRWTJzRWvei1y457DyIHXoLe/u6AmwaMra9MAUK7H9B1pQ+6lz4EZOV1NBnCW8zknf98YZA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(39840400004)(396003)(136003)(451199021)(66556008)(478600001)(66946007)(6916009)(66476007)(4326008)(316002)(36756003)(86362001)(38100700002)(83380400001)(53546011)(2616005)(6512007)(6506007)(186003)(41300700001)(7416002)(6666004)(8676002)(44832011)(6486002)(8936002)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ePLBqHPuEB/MNV+UTM/Z3LN0PoaBn24BiDN7Clcu73UvZY6HTGO5S1wOls/U?=
 =?us-ascii?Q?dI5bAIJx3dW+80reF7ahuB1FtlZjmvy2K50cT7F/RvbVsbOSTvLAlODHTCCS?=
 =?us-ascii?Q?txQZyq2hr9lTWZoGWtsm6hXD+1ZnfDCZIZeXNmizNrUgX4DbqXPhhIw9u6ZH?=
 =?us-ascii?Q?FXzd0dDZZA/XSRt5IqExfIa5CfIdKyMw8ajUUUUJsmtx0AwKm+QWr5IPA+Vw?=
 =?us-ascii?Q?E3TpOYwsbBbRR0d4vDBL1M71r1IyUOSKmAHg8bK43xOK/aa+/uhWL/dJCjaJ?=
 =?us-ascii?Q?iV4ojvEChPEZZDWOPrAn9LpbGJmxjrAxlsFJ+K6Z7HXcW+3ObKURYrurCJvR?=
 =?us-ascii?Q?Wl+ameAB2juknnMnrzLj9iiF2JjqCCdmoF0jRRPrbMoEeR5z26k2o4kWWRaC?=
 =?us-ascii?Q?gpvjJ1lkSjzamsyPBT/A3gdGfKDCWe/wL/D6l7qSzhJecWLPhOMKCCfh/Raj?=
 =?us-ascii?Q?Fbh46VJCgt5vzFU6TYSOUFSWI9odhw01jElTM94qsi076NeELkwHZ5x/WEHh?=
 =?us-ascii?Q?FqvVv6FoixMliOP58a6AJYTyu7/ixcgsPOs8YsGCIS8LkqTmrwkGdAlsVtu3?=
 =?us-ascii?Q?YY/8mhjs62Ee0gxSQC/jxmfF92nBsHoJy2KL/Dig0rnqCoCny46/Su7rQWUF?=
 =?us-ascii?Q?PSH7SnXW2/2gv7bofA9Mbyly19/tRzf4StxTk5tvzlvMXv3ZS0nade9uYK2l?=
 =?us-ascii?Q?+U0bftQclN/VrB4YdH7mDceJRuIWHKAXEtmaV41Tp1zojsiDzT8q2Nudh7x2?=
 =?us-ascii?Q?a6VKD4XBtZDXWKgjIBLx6n+pexCFkJ5dqy23O/+j84UzO08IU+nM6XxbUFTJ?=
 =?us-ascii?Q?AFezsQ9mkV6r24rxAFu4CrvSyMuB925lttwGHXI0JQF0n1T7y5b6A2B7KPru?=
 =?us-ascii?Q?zJCgCSyLMg37wgh2zIgnlVrC7zqR1W32qopUe6ny26PM3hpOLu1kUFPBgc6a?=
 =?us-ascii?Q?ZjTUAt+wG+hsEMt3SAxvEUHGt6l+s+uCZIAYXnnwX6LomxSyV3W5eBx9G1yU?=
 =?us-ascii?Q?BRZOWgB/W2D9UQBIxZsGNQDL8b3KKK4ZK24H/0HScI2bCOr9aLOVg28Met3x?=
 =?us-ascii?Q?thZsT33fwpz2RIjD175/p39AYamNvBPQvFwX3LmNt8rhEguFUbspYM3C4G11?=
 =?us-ascii?Q?xHr36lDO6IOS94KnwdhwNZZOnnsu4vO6LQzI+QofIhuFPdIK8wN7Ua9L0JTF?=
 =?us-ascii?Q?CxiOitzvj1iNzA7draWvGThyi50+1fg+FjZaTKPgBUvLRfnOp8RBxjdreDAm?=
 =?us-ascii?Q?FGYB3gFcdRjOsZllU0X0QCE1ge3cujUaWyWLxlA7yTgqmjoN1MTXxISbhsnC?=
 =?us-ascii?Q?GMTnrze7UAM36dOOiPt75ZmamUW9ca21UJjir2FiQBl095TtGyeZRAi0dJHX?=
 =?us-ascii?Q?Yj4fW/cYnTbOylhqsTygzvFfWqaUETOzl6JUulyUkk+nEiEbWQtmoKKTOf9U?=
 =?us-ascii?Q?it8RrZroJPSHGvvd66FVjQv7+K9ibvuHxdlnkvb0VERgYdvM5Gp7GrplyOYG?=
 =?us-ascii?Q?1cF3+s15Uf5Juc6FYUf12+4mnbScgU/4sbCNsbE1J8NPSNgK0rzdnkzwau80?=
 =?us-ascii?Q?fDL5Z30uB124oQkgdH6+biIuTRKYCnqp6KaRD3g+8krR9GWrRVwPY2W1Yk+9?=
 =?us-ascii?Q?JpB2V84dFoE1rXVvOZ89hF/BvOGT/+6YJ/Ts+prfHN7IXEjc5JGngy2ITa8f?=
 =?us-ascii?Q?8o+GdQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e88831-f81b-4d13-6d29-08db61bf9e7f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 10:13:03.0505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qH0faYOQozIObEYpRGpfuaVes6Fozxo7W9INn+PrPJ1uLh4t8n+9fh8w8duTtDvAmCoO30LGiIx5m+o+QndZS7gIS0xGcK9p81HCrotVo5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6008
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 06:05:29PM +0800, Hangyu Hua wrote:
> On 31/5/2023 16:04, Simon Horman wrote:
> > On Wed, May 31, 2023 at 01:38:49PM +0800, Hangyu Hua wrote:
> > > On 30/5/2023 19:36, Simon Horman wrote:
> > > > [Updated Pieter's email address, dropped old email address of mine]
> > > > 
> > > > On Mon, May 29, 2023 at 12:36:15PM +0800, Hangyu Hua wrote:
> > > > > If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
> > > > > size is 252 bytes(key->enc_opts.len = 252) then
> > > > > key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
> > > > > TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
> > > > > bypasses the next bounds check and results in an out-of-bounds.
> > > > > 
> > > > > Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> > > > > Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> > > > 
> > > > Hi Hangyu Hua,
> > > > 
> > > > Thanks. I think I see the problem too.
> > > > But I do wonder, is this more general than Geneve options?
> > > > That is, can this occur with any sequence of options, that
> > > > consume space in enc_opts (configured in fl_set_key()) that
> > > > in total are more than 256 bytes?
> > > > 
> > > 
> > > I think you are right. It is a good idea to add check in fl_set_vxlan_opt
> > > and fl_set_erspan_opt and fl_set_gtp_opt too.
> > > But they should be submitted as other patches. fl_set_geneve_opt has already
> > > check this with the following code:
> > > 
> > > static int fl_set_geneve_opt(const struct nlattr *nla, struct fl_flow_key
> > > *key,
> > > 			     int depth, int option_len,
> > > 			     struct netlink_ext_ack *extack)
> > > {
> > > ...
> > > 		if (new_len > FLOW_DIS_TUN_OPTS_MAX) {
> > > 			NL_SET_ERR_MSG(extack, "Tunnel options exceeds max size");
> > > 			return -ERANGE;
> > > 		}
> > > ...
> > > }
> > > 
> > > This bug will only be triggered under this special
> > > condition(key->enc_opts.len = 252). So I think it will be better understood
> > > by submitting this patch independently.
> > 
> > A considered approach sounds good to me.
> > 
> > I do wonder, could the bounds checks be centralised in the caller?
> > Maybe not if it doesn't know the length that will be consumed.
> > 
> 
> This may make code more complex. I am not sure if it is necessary to do
> this.

Understood. I agree that complex seems undesirable.

