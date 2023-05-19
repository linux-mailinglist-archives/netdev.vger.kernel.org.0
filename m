Return-Path: <netdev+bounces-3831-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EBEC709073
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1928E1C2122E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 07:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A9D80C;
	Fri, 19 May 2023 07:35:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264467F3
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:35:55 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2095.outbound.protection.outlook.com [40.107.237.95])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AE8122;
	Fri, 19 May 2023 00:35:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/mTgLKt4OykDgjggjBvDiL69Ymmk0eswrDsNb3ioEkeqaQbq/6BIg+7B/Eip2cmnWlKxpcIHLFzQIoiMvwTpQjpCb7dFMwWl2yb7lPNQjvVZ3oytB9DUaQf212KWtal1482f3MVAj9CvucxbU6+CwDqCI2moOoEI+e+csm1FMat5sqv2mBzpnsgB9Tg1Ek75Gkw6mv6Rplcg1UKK67sK/t7H6MsZ5WgPJJq4YKrfz/w4FJghZLfCuSfcey2y6Qr/2c+9Ed+jrygdKc9XjUwIxeC4GBhGIO49lbJKe7Nh//+YSSMYZwsJOpb16pK4SzaR7gGsKcZtVnQO78bzp1IWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z8+I9neSIHXxpIwT4XV/8CiUJ9ideXDflsF0eFVC33g=;
 b=OTt1a71c0N6V+PTN+mGBNoLjib1JR9kFT9UhTWEJyAMFy1GjDcHDyguH3Afa57TK/PV55Ezu/gSgGCI9mWVNsLp3urwkiGC1RtGkNRpDaDrsL2fECITmF7i+vm6iBvstZoIlImXQqjXjQEVrl9jA1ZxpVYI5jUAFxp8j0U9OB7ExyzHm613DTctvrNU+cVMi8dWVki+EkoyFIq5bPPWQhCziefrS1trIYTma20FAgt5csxRHccweVEQDzDpS2kqJrXHv2+oqK4Z6nU1qYmUDwKfjjP+9ZAgOrrqT//V15vaAnQgNyPeXhSDIdGcSPhh+uTUFADcreLcF/WoQKsDISg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8+I9neSIHXxpIwT4XV/8CiUJ9ideXDflsF0eFVC33g=;
 b=PUWNKL4Pqe2lZULSjl3j/7gMdSulG0JgNp51EmrR6JoHKkjN1Pwb0Rkchu64qHhy/mLcsN3hGV3770l6DVu3mWzrBQO9ZcXJPJYEYMSjxcHic8mgV3tHXKN+g7utA+Nbkf79r7tljgWWimi5Aj9PcXUn7Lye0Yja/7taPqhOksg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BY5PR13MB3779.namprd13.prod.outlook.com (2603:10b6:a03:229::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 07:35:51 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 07:35:49 +0000
Date: Fri, 19 May 2023 09:35:27 +0200
From: Simon Horman <simon.horman@corigine.com>
To: wei.fang@nxp.com
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Frank.Li@freescale.com, shenwei.wang@nxp.com,
	xiaoning.wang@nxp.com, netdev@vger.kernel.org, linux-imx@nxp.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next] net: fec: remove useless fec_enet_reset_skb()
Message-ID: <ZGcmv8LKS9ayAHRI@corigine.com>
References: <20230519020113.1670786-1-wei.fang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519020113.1670786-1-wei.fang@nxp.com>
X-ClientProxiedBy: AM0PR06CA0111.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::16) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|BY5PR13MB3779:EE_
X-MS-Office365-Filtering-Correlation-Id: 98a59b5f-b0ab-4bb5-5470-08db583ba235
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	psMDBnSwhWtjLNg26NXzBNzv9End7DTvMSxwQfTDCVLuDSwr6hualkAi9g02HQFhiUo09oDed3bAVbBlAYrAfwnbl6FflnQTtPt1sY8mtXk9vtWMOSt4m1XbsxjwKzjRPhD74KBCKYuXUajrZhkdeJ+XmatD90I0RA4UevBb1ChPi4T/D5CRJ1kBjOpEASP8LVvG6sM2PunyLdcx6RMGzYmlZC2UpmJzJIPBAAsdJR0XU7tbVkxA4g2sl6/lMc5kvRFvmyhwDPMyzh3SJ/NZ9+J265YPgYxd46eL0UDNElzBLYeN/V6x8GubEtgzSJ8D73IZgAfBWPcaqSVH2meC8fKmAh1CPFBO3Vpl0VBZEqjQ/Ory4iOSmxAwnacGF61/UE5P1vfSyODzDWz+ohz3PSmN5S4XKi84z7Hcuj4bosVV29yyfwkaoqHjpImNI2B6B/x0VN3TiDglVUuK3CTPZsEqgeNrn82joukQC1ZJOg5hcYr66amAcIBt6x7N0n1n3X4b9PbF0DuTAvbaJMriGSCjJBiyEJ1HX1xndMzDtAmJydH6OUQ3QKN6Im6RmP+A
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(396003)(136003)(366004)(346002)(376002)(451199021)(38100700002)(36756003)(86362001)(7416002)(5660300002)(44832011)(8676002)(8936002)(2616005)(6506007)(6512007)(4744005)(2906002)(186003)(478600001)(316002)(6666004)(66946007)(66556008)(66476007)(6916009)(4326008)(6486002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pmRHwI6jhi9rxiKNXcMW0NU7SHyMAw9OE8CAeOhNV4ZGBKt7B3at6gw1WXkF?=
 =?us-ascii?Q?XWX7/mNXVF34AkYxp0uqQliQ/9w/Or5KXsZ7LFGD9+hz4syA9bmrsW07QWRV?=
 =?us-ascii?Q?aRKFcjRgvckcO3jEuCmd4OuerHW9jfFizIfK/IZE4agcHu3QdABM3KMeEu1d?=
 =?us-ascii?Q?mZ3wJmBGtfW9w1h2WRZCMBavJD7FCBzLJik2f6dZIfmwScY+BRHM9LSJTymN?=
 =?us-ascii?Q?WmrrsMoR6xKDHfyetZ4uKEzm2m3GuJfMqQpmuViS/Q4XTcODp1yWFAGOZWCF?=
 =?us-ascii?Q?8RUI5n3s+GAsxYXsD/I/c4N8Omf2HB/HTp83dKFAwhWxsd40o5RbAvlXh0Jb?=
 =?us-ascii?Q?6COjucOF66G5m17p0cQTFW8eA5V8Oa+ruue/nokvyIY9ejUurX6Xp90K45Tk?=
 =?us-ascii?Q?nLTpy+CD+fH6vgazCramGisyN6QjtiVHPUJlBIb6VDzu1YlDPJjtpwurjePC?=
 =?us-ascii?Q?jKfShBCsolcxSJLFNHUJmbhaGcBqC6ezJLVZ18rCfXWoION8B0Uy6McD0MBU?=
 =?us-ascii?Q?euGocbxDq2GAnQT9p1EQQUE5jCMjGcjfVKlFziptH+WibwYq1lf0W0LY1/P2?=
 =?us-ascii?Q?DI4qJUtakTbJVGgrcz7AmeSCqapVZfydq23BXxSn+ZcPTuHEufAEdpRQKhoz?=
 =?us-ascii?Q?vpxHpVEZXVDCq4yqz5FZjR/py/DTOvsCw67n7EnYz9eFNcOOvfRKe97Ul8tH?=
 =?us-ascii?Q?SDYVskUtufmJ8PvvhyHOvr14k+7i+9OknYroLOLvzPgZ+yX97uNTDpbDAJls?=
 =?us-ascii?Q?2IqcnfjQdJkBpqq6kICt5Qo2kofGolsX4n64iVIed5wm0vFQiY/Frurthlyq?=
 =?us-ascii?Q?La/67rg5Sow3WqsZzwvRSQ2hqfqCSc0jwNT6nUZXsuUJyhM6Cw5XAc6tKCJm?=
 =?us-ascii?Q?lpqUq8z3arMhUQeYGv26TYO/ZysRO4d1OrSxMJY7EnDujSDsj4dazCRxL2qj?=
 =?us-ascii?Q?v6hTEM+r+1fdYN1Gjm9v3WqWxf8adX+FuBMU09D1qKbbC5IigK5ddCT33dxW?=
 =?us-ascii?Q?IX4slZQ0wJ1Lb3yWaDjpMypifzQDw2RB7kG9nbmEDIfhoVYyUWgm2ScjxZG7?=
 =?us-ascii?Q?N58NGK4+pic0w10f+EixoYwXeKbFErAbbExp40dIP6VFbrxtZ2m+hZy3D/+g?=
 =?us-ascii?Q?Hw7yCDdEJzM62V2iARQq/QihwU/w8O8LTZqhxV2CNMBRu+O5/1q3V8crKoP5?=
 =?us-ascii?Q?jY4I97IDrA36nY5PZtITWfwA7RvrnpSyLvUbwmotrQZPLVJrXnux8M+scdR7?=
 =?us-ascii?Q?rHfQnC0E39Y+p35uZqpMhLIOyh7fnTMSPAI2l6yXmGvlCE+zgKOndglimF4A?=
 =?us-ascii?Q?TanA74oY1jC0f+JBMRq/VNh+wL5v0NDm2dek6AZ+RR1k6DbjfDMRx9FJK0WG?=
 =?us-ascii?Q?Ubk+5ozDFwLXYFalXxDpwlIvlMLh13ha+u4nKtwmyAlG+ADqQc1LFFPoxzmF?=
 =?us-ascii?Q?t9yd/LHk+mTgU/c/iHKaiQRIAwMo6Yu2FhfIsnUupczy2SrTOBoBeFaIY3DM?=
 =?us-ascii?Q?vvr1BGNkTKIlIluPuTTKysK2znRWHrFt4gX58nitysyLez+BYV2Ov3TkM7Ze?=
 =?us-ascii?Q?d7AHZcGkr3D8AqRp4fRmKq8d6NL6o+KDYVne9I5MYIs8jxLH/WDWc6q8cLSb?=
 =?us-ascii?Q?KHaqIqqeTn/US6dWJPwrNf+5D8VtIcFhcZ63KMjY8PGnQrllHQPELyOEWMR2?=
 =?us-ascii?Q?EJop9Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a59b5f-b0ab-4bb5-5470-08db583ba235
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 07:35:49.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hjA5Wuvj6lyTilf8p0Jfy7303MKdxldiMd4r1ynjjuPXPU+V7jtxMxCH1sTtoKh8pVpeKslP3qRzIrZsbhoH2x80+jKGdbnsZmUhAeF/yos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3779
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 10:01:13AM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> This patch is a cleanup for fec driver. The fec_enet_reset_skb()
> is used to free skb buffers for tx queues and is only invoked in
> fec_restart(). However, fec_enet_bd_init() also resets skb buffers
> and is invoked in fec_restart() too. So fec_enet_reset_skb() is
> redundant and useless.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
> V2 change:
> According to Simon Horman's suggestion, it's just a cleanup and without
> user-visible problem, so change the target tree from net to net-next.

Thanks Wei Fang, looks good.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


