Return-Path: <netdev+bounces-8027-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3188722770
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 420511C20B58
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB4961C768;
	Mon,  5 Jun 2023 13:31:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C616C134BE
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:31:19 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2094.outbound.protection.outlook.com [40.107.244.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8F692
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:31:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlnEfEDX9HpUFpxpU/WWYK3uePIBtSNAX1mmqGAH6oXAIV+Re8nx3jsFVRQYmclkxHGtbTViCJcqR8kE9oZxXGs6BR84F1MfI7qjV0IJh6GQLA9O+hqYTcdswxLZIY+gdiumhsWQFP4j0EdALec5pnbIZgusmV6acy3q2cIM6m7Ssx0ljzbRiqLb3v77+nMrEZYkP0PSOMTvprb9z4YWCuqBCkZ6oMPhjIQxV94mA31hLxmh8GngKXfaIPmlVrRmEY1qDEu+F7ZIyfts4Qs057k88OFZbir947/G1cv/Rjqyi1tNild+AI844yEwRzvj7iTge0RDGSFV4Hki0HAPOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uDxZPbTTJFQczAWbprrB+dXF1Aw/Nk/U/Vpjda+168=;
 b=Dr/7hZhek/1Rb3vJsJAGLu0xlQDUNb9AxiCGYNeGrCeZVihYY2P6ijpFIOGI6VwJDz3jm/4SODmREySUrwDz4+ky9D8U7UpdsBG9KzEB+yRzPcHUL/M2QnWFirSpmiMbc3+QUq2SnJORLpQgRu9o6HaoQj/ailVGjtJeTagIjaBfbsX2Vtg5svwAGkf03nxFG5H8QKyFBficzmAPeeYh244elAq4NfE84Z4rb+Upmvlm8OOM87+3IB4EOlvYKebCOguPC1pTwJWIi84yqusocnb9BRW2HMOG+Opa0l+DSaF5I+21MmcEa7obI8QbNgqvAepSWF4pWwNSHu1qj/em2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uDxZPbTTJFQczAWbprrB+dXF1Aw/Nk/U/Vpjda+168=;
 b=W6OQDHTWWNWNyVEVOYWN+KP8ggNRKoe8Fqa/HNN6rctQA2Gn4Eqp4OtbO/+ztn5kXpRbL5VYRPn3ZRBNBjfu9rhynI9hnnYOwFZSIWzW+wX9A5oHnq7t7SfQc0PLXUXyO22JSF1c47/l3UB6xS/MksMqyQdEVmv4QyxE46Ui9DQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5977.namprd13.prod.outlook.com (2603:10b6:8:46::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Mon, 5 Jun 2023 13:31:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 13:31:13 +0000
Date: Mon, 5 Jun 2023 15:31:07 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Mengyuan Lou <mengyuanlou@net-swift.com>
Cc: netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [RFC,PATCH net-next 3/3] net: ngbe: add support for ncsi nics
Message-ID: <ZH3jm45hskl+RzPv@corigine.com>
References: <20230605095527.57898-1-mengyuanlou@net-swift.com>
 <5050D7292AC40763+20230605095527.57898-4-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5050D7292AC40763+20230605095527.57898-4-mengyuanlou@net-swift.com>
X-ClientProxiedBy: AS4P251CA0009.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5977:EE_
X-MS-Office365-Filtering-Correlation-Id: 20ac6d6e-e6cc-4ed1-8c2a-08db65c921eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uZEKC7H7kTouX6j9cW3/M1OUS1ma4kKeCM90zkeWgUoyVtpzsPvAJZTg3DQ3vrmvsTXIbVvROlaXVqnpvh3/ROMYhMSJNTaMmstZGtswwx+2ScKMYoXEK5pker9EAuIbTYPrwlwZYsB2q4hJv7jgKGnb9p2pq4/xN6h8bF93eUv9IRYfvw9JLV/SQJVkk7jcJLK5qaubar0SmrQJ/tgCMObrd6m++XTB7KyEWMEwiHmBwcL2vgjZaNekeR6e7Owayqs1hj7FAFYa1a6gjMVi5OyJh+JwDDEzzem2ZFjsXFPDHnglNmy+nBv3owjw9aeL945B6oM7+J7dn/YrhXpncqpdv0TXBDOu8zPjwe9knP6vcMrMohTuJLa1/ZQSl1Onq7WRes2oR0CouEyq3OjpU0ZNVtM/SXqph5WM1b9auyc3Mx4PtbaBp8R+xb74S4FtSjJuEHTCAQ9PbzzHbkHBzvmOpFsObv9HCqlRsUBSMNdITM3+8B5GM+mE9+MLZGhc9ssHm8QlfZrAjHdoZhhMCX8qWKMlm/atvtvw2xc8yv/5IE2nLqjZy/72Gz9IbT08BUv7a7l+xUfq9zoE2NhqzPJKF+1POmu5hroBsdTkIYbFPvY04TvX9jDJfG9vcQdXQkTZfApkQLlxESLDl1cdFg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(346002)(136003)(39840400004)(451199021)(83380400001)(44832011)(478600001)(558084003)(8676002)(8936002)(41300700001)(316002)(66946007)(66476007)(66556008)(5660300002)(38100700002)(6916009)(4326008)(86362001)(6486002)(36756003)(6666004)(2906002)(186003)(6506007)(6512007)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wmwOKOYa+3AIJf8Szp3Udf/yZB0kXfYkiIUA5+7ALyqDVKj3gc+5Q5qTyx0v?=
 =?us-ascii?Q?654wC1tSYe99AwFTLYJd75VnOPUIli1UuNbLTnfRelvMKb/7+HFud97/Ror7?=
 =?us-ascii?Q?jwe9syqNPe7JZ4mfS/UJ53AV9uowl5yFZU2se8dXeneJNlbxiODmwXJa8JG6?=
 =?us-ascii?Q?jecJBLqb91LENDC1B67wgCFE8mGJCW2sP09Z97DGkKCjPtLrxuS8nunEXcvm?=
 =?us-ascii?Q?waF/rkYWxx7eSAiEMhMmnUdoPa7z4WbvmFBCKLalBeF5jFXXAjO+WvUEfkq/?=
 =?us-ascii?Q?ft0ZEKnbjSkMd5mLwM9K5rui2Tdy7xP4Ltjnex5mJPZJe7yzUIdRa3IDHNe8?=
 =?us-ascii?Q?DlkVJgtn9EmI5v4fmF0iSCjYms7pQhzGKdPKKbrSI3Pwp2ZNqT5AeDify2nU?=
 =?us-ascii?Q?DiTYDe18G+nsl15W0SSNhPEkvocX3g4dWNni0apDvowjssRfYkFyrYkcm1W5?=
 =?us-ascii?Q?b1sTWEA307Ke9GvPAHCogUUjQedqHfiPt9hHU5Z989vqiwAjq0V0uf2k8Eoc?=
 =?us-ascii?Q?xeIyQo9g8jLUdoz3IKuJEvksWEQylfw8ig8UHFTdIckpmWHlbRTIUNZQLZ9T?=
 =?us-ascii?Q?x3/5K+W91xcnLkgbqrsj/fphOOdquVCUImvb6OKN1Mk3Oc2fglxT7UGefRok?=
 =?us-ascii?Q?wfp2D6NSn6KGCqNZ+LOLechL7nCXQlnlM9ogaFCt57my3LjPMdhFFfdVd4xM?=
 =?us-ascii?Q?Ni1fn38tb4wKYj64yjBiQvjH+9RrQUfAX7EeZ0eBgER/shxrNmqpHIKmFa5I?=
 =?us-ascii?Q?mHok5fhSbIU77dE+sIIcJDhJeOPZqiriKJNm1Ew5xRKcYM25/H7BWJFZThxR?=
 =?us-ascii?Q?1JWk3ifuLjFQUHU2WcOyZauYpT+h/TNceK5mn2JywaHP4TlWKWKw0349sqPi?=
 =?us-ascii?Q?LPpq/wNOEAk+6Hbiyemf31wp248dNuktGNH7gj5P0rXzGO93Gms5UO0hF5w1?=
 =?us-ascii?Q?2dFJ+Aj0RUupB/a0+Z0lnJ8G1p946UZQTJGMI+Byn5XDUXbab0N5ZqyYI1Gy?=
 =?us-ascii?Q?uZNt4zX9NTugplzLztWN5lVJOZyBcf1W1aFT3uRAe5UsG8zHdUyM3MS7W0re?=
 =?us-ascii?Q?QqAaB6RFVCUnOK5Q0tOKtcT8dtXrwQ4RWcH79eHm/zS2hf0SN66j+Ck0tYK9?=
 =?us-ascii?Q?KgK9Z6S6P6Dd3xVMJEzS4MXBRYMTxBDDKFeMMFKubfU0KMIIntEm7Grr+SY5?=
 =?us-ascii?Q?aZWUsyWXFY0OFKhHVMIiC3SqfFcYrlHnhtVnz4O+e1EcrmWkObfezAGLOpOK?=
 =?us-ascii?Q?mipWGjL5bZ6wa76n4W030XMQfCOxjo9Caa2p/YGskbqL03euitnYhf2FKeWh?=
 =?us-ascii?Q?1Su8rosbA2/ojojL2xe1SR5FoHpwoSCHFMWF5D0z8vlzZ7SEI+roPzgT8K59?=
 =?us-ascii?Q?WZT8FI7MNBgJyT8HV4dqCZ2wktPcyKNyqc3H/6HuXaesvdYx0RZgP2AlboJh?=
 =?us-ascii?Q?froz9TGTkmhVf2gpUgahw1gWTBVXhrIn/Gr1bJ4W4+pq2et1vzLCHik9rDJG?=
 =?us-ascii?Q?rUvWpF0OwOQICZnA0i/PNyZGyCjJpxDy9fxFW6jFy0NYYJ1Dji4yOaHiFgDx?=
 =?us-ascii?Q?IcqHhg+phvX8UGBBfCpRnsd6kbEh2GxEbePmPABNk7pgWJF7q93TwmPUBYiL?=
 =?us-ascii?Q?Vd07FKyDKTQYvxrVfh1R0gZyx+8GarXgXieIleV/nucViK8lyCpe0rYq9fYj?=
 =?us-ascii?Q?RWpbKA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ac6d6e-e6cc-4ed1-8c2a-08db65c921eb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 13:31:13.7020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GIBpYxzTWmy+aL+y7VIoGlgKzRsBBUwAKimVC8u7vIcAZjZvrVVQa2GI84e0GmP0GKlm08sdizknS7wCjqXzBKZNoczwcme+Nfdsx7mSdGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5977
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 05:52:52PM +0800, Mengyuan Lou wrote:
> Pass ncsi_enabled through netdev to phy_supsend().
> when ncsi_enabled is on, phy should not to supsend.

Hi Mengyuan Lou,

a minor nit from my side: 'supsend' -> 'suspend'

