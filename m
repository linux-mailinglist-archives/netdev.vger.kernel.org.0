Return-Path: <netdev+bounces-9679-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06CF272A2C9
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:05:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B49322819E6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B2C408F7;
	Fri,  9 Jun 2023 19:05:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A682E408F0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:05:50 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2134.outbound.protection.outlook.com [40.107.223.134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95A635B3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:05:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zi3aMb4QUE4CAv4SNar1MaPmeEQdLVeQPmG/FAuBWR/8N18YuBW0KNeWEoiC/Qk4GiypvdZN0VEY4hjC5ZxswlmDcKQKW1zeoKJGn1tDcZPw/aRsQrRK5+/AhNRq0WcSDkQ0sQrX4ranrb9J8k3DV78G7ya6J+18ZvAY+3mJPBC25oI8xkGm7ueZqpihpy4WqsXic8jfC/lckvZVMQRudHo83HYxm7uFD0u2ajPveDeBHqYa92MlKeZbzQ9GSMqoroGAaiocw+0omBR9XdNvqNoLEkC00e5xKlud/bHLZ0Ufol+h+r6CgaF2Aktzeua6ueMqhK59Vgu9rPtMAyBkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mcMjTG3LN83pHszlBFSTcb7wLdahSoJbE1oAhGVrlNI=;
 b=PQChhnR3otS40j3458kgmhCyMoQO5jBdaBap1q3ezbKXXcFBst1kRpXKZbb/8wmM/2RT0U0tKIIUnCaolFHNF0Qsz7mkcqUWAvcz/L1Ef77jl0d+KZKcwjE7+ZR7KiuostCg7IMRrU5xUJa/TG4AJGgfuXrEOBJ6/6CCUjyuXB76wyziaCY+Z1YKjQWgmCmPBHvIS59EgbBzcWZ0b3Vo6MgmPeCA43vfrdwguMQMWqzFzQxh6EttjQJQPa4NO4tWf0wp99UAVu/bbAIQfGxsU/3o13T4ghQ67kf7JDIX28vFISH1DDV2hmTBs+J7OVaWPV+StEuJvOy1CiGRf9Iwhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcMjTG3LN83pHszlBFSTcb7wLdahSoJbE1oAhGVrlNI=;
 b=tuQ0YHGeluGfKH4BnNBGfJTPalwPE3WDV/xLEIMQup+MgB1F5wXfXzkKNqiRApVmByHV25e8UrpZ3JgE78kwnQb5atS8znhGlYEJMUFZ2BOWQPDNVy04dNmPsjVPGTAfYv8W5/i2Zitj/aFMfjfgmY+p/9KHZLjK0EwiFnYJYK8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6336.namprd13.prod.outlook.com (2603:10b6:408:198::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.17; Fri, 9 Jun
 2023 19:05:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 19:05:47 +0000
Date: Fri, 9 Jun 2023 21:05:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Petr Machata <petrm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 2/8] mlxsw: spectrum_router: Move here inetaddr
 validator notifiers
Message-ID: <ZIN4BapCqoGQIWYU@corigine.com>
References: <cover.1686330238.git.petrm@nvidia.com>
 <1e55f30145be26ecdab744be0a6ec130fbab02b7.1686330238.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e55f30145be26ecdab744be0a6ec130fbab02b7.1686330238.git.petrm@nvidia.com>
X-ClientProxiedBy: AM0PR04CA0074.eurprd04.prod.outlook.com
 (2603:10a6:208:be::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: ec3c3280-9aa5-41d7-229a-08db691c88ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AfUcS9cshoptFyJ0+rKwiwEIUO7UzwsinW+JNvOh6P1pxFOpiRo0f9qdBvr8G9TfIU591Lcd7ago5wpkvOwZ6K6bF8kjEdzdjobOt5Odg1mUDzLD3WFyY2fWBsDxAcTlledfeif7TrhBSWbRp4omK1DH5H+eVRSeaWqyAhC5QBH54mEgPefsrrRn7Vjd9qeD2TSESY6kXFuN5KRHntbQ6c3ZGjqxJax5jwPQ9xRbyqvwy0n3OM5R01BO30X/gugn89JTM4BwQtTH0gbm3vLZllpxV7XQdrCbXCI1+WA9fLcJarDaCbM6vAv05yeRQtjRzWqjol3nSxF5Xl9rNzMHd3SbuZZS9rzag2ZpK3wz0JLtUQoYYcvpqshPnVk+ypoHt+ONfjX8kaU+uUyGMD96QL1cedfXUr7Pn7D1am2OPI6ehicHaledIrOzjepsNTwOTnFgAMguIh0+AfuG2r15qWUaICczzxudIFlVMs3rRoo1GlElWYGh8lEretzahchVfBIs0h9aABTatBBInmHzTOKg7eQieFEZ93v/H8kY6Cb+e6rFgpdlC9Lqw1gKQykt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(366004)(376002)(396003)(451199021)(66574015)(83380400001)(2906002)(4744005)(8676002)(8936002)(5660300002)(6486002)(316002)(41300700001)(44832011)(86362001)(6666004)(478600001)(66946007)(66556008)(66476007)(38100700002)(4326008)(6916009)(54906003)(2616005)(6506007)(6512007)(36756003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FTBCBZ5ZiSuisKiewdxjanr/2x+eOnioN9N77X3JL1k28YA/T6KmFH8o+n64?=
 =?us-ascii?Q?cqz78VMGhy6ZvDSTjizx006a2T5R1Un4I3jdtLjxkAF+jrPIe74mi0uCTxAu?=
 =?us-ascii?Q?MXios10Xd163hl/FQdfq7hdofACNJed4ZecoMh7jOojXBilQTF6qdqUp7vii?=
 =?us-ascii?Q?AfeBu82bQGRFYUCzdfrfUpbo+QP9CskVwbl3aCRm9aV98fRvBfyKDMnH3Px+?=
 =?us-ascii?Q?/AyHWPHB+O+FZjzy+WTSmN/veuZEbguH5wiHRwNOraodEFwG6tJjms+CEk8+?=
 =?us-ascii?Q?1up8TT62g3wUY0l/E8PDROsE9cGKtxYjl1lSiLsrZDYo4HKUUeEpAC10lIJg?=
 =?us-ascii?Q?K4WaKZfxDvdZIEDEhi8ADwKkacS2RXAFWIP5Wy+Tozfk8onRAJhyoAGpGMCf?=
 =?us-ascii?Q?VSkOmTyyMVpnI5GgI+x+ZkS9/iKCwcW7J7GMKENE3JAZxoLzRPRjIduQwuTd?=
 =?us-ascii?Q?zpQHRzFAg/myt74fS8uj6NiPkn5zyLf02y7kBCDFuPe+iSkviX4bjzL8JE/p?=
 =?us-ascii?Q?ki2Nl5yn+1XLReG8EeoSkxPeRxsqECVtyW3d9rxXviN3e4ij1v2kwutGO5nk?=
 =?us-ascii?Q?N6uhHbnUV8XMPpAmDU9vdEec7oHK/kLg99Y2gTcVjeVb2+8935Oj9R2OCn+r?=
 =?us-ascii?Q?UpMwb5LsHh5AGI5iMlLKRr8coGL3eFK2G2beAC5zd0KgYRl4IcJ7yUZKEAWQ?=
 =?us-ascii?Q?xpy+Tt4icMb+ZMUguTX8068UdToIw2OlQ2CWtpyT8wSgh8uhjUj1hl+6/M8F?=
 =?us-ascii?Q?4+Npj7SzSxq8gm9c9n1oF+MF2du+YNFy+duF1oecKlKYNz3Ubs8Y/1AffXSR?=
 =?us-ascii?Q?Ecefxb68HQzZ4GZuehNTxJ7/WC3+HSU0MReYE860I4ehswDCuJY8RbjpjmDc?=
 =?us-ascii?Q?GZ4f8qBUgWyjzS7TUOEcyofq0J2ULNQQbL5xWUxipJw33PyV6yV5puyLMo4d?=
 =?us-ascii?Q?jRnOpQZEMuUeiQSBfN40iFkoXj4ymLuY1go3OWdla2XqQNkXZ0gUYf5kDk6v?=
 =?us-ascii?Q?u6TiLEm9aCPCRyHLx3ledQprd9aylVOIJ0eUhFZYQ7qgFy60w2U6UAYCuq9r?=
 =?us-ascii?Q?p0LEaUfyyozmRetvYhu5Pq1fVNepUhdh/lAEORMbxjjGl+YOH/KTzqtcziJ+?=
 =?us-ascii?Q?LGFWQjt+MZ8mwu4H8hiF2KYU5okZUtoHmsu9W9kZ8Xeak442OIi0HyXwCqE6?=
 =?us-ascii?Q?ZxbjK/aMkBN9F9uqfHSDdPs0rXq1IPBIeSh4WcazLag2nX3vo+PFv/6vo7eL?=
 =?us-ascii?Q?NVZ4YF7tt//OfFLA6h2AhyrQxxfeuzGjKBMIjezHBNfWjUE7zM6VYA7nIxUm?=
 =?us-ascii?Q?vovFlyGZQeEbzOBiKkOFsz2RNFcz7TgKuRq6giRe9mKW48ZBGOk88LuBVrpg?=
 =?us-ascii?Q?/WSXDMAIuzjxZcuKw88+FeuVplciwmRqgAUibCypJy/CYvmGBAMGJNGhx0K0?=
 =?us-ascii?Q?SAQ7ON2Y+mvbfyGtGdCEGgZ5nt67ODJ5uPzQJ1AqIQ0cFJ/ihQkRxRVGpdv3?=
 =?us-ascii?Q?xmJmforTcmPp41Y7yLJ7PjU2V5vO2I5f/ulrZyIy8LD1KBFh/ovP/YjdkY6p?=
 =?us-ascii?Q?9i+xzy0N0scrORs+6TtstGNThJ+OI9zDWFDtvco9JSaul+jNq1q/UtCBlu4I?=
 =?us-ascii?Q?fyI4duWUvrX94QFafC0P3Cx7LGmPWPjVabobqbUhTQR44GUZMwD1+uLF4rXw?=
 =?us-ascii?Q?3lDSJQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3c3280-9aa5-41d7-229a-08db691c88ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 19:05:47.7687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aNSujwq6kOit63nabRuecYGkLHUsMbUEYeYjsv0UbpGv+RPLUvBd//cAaGYRitVLG3oXCGBVXeLATADHRELXz6ddrvr3bu2ZeQP54/Xt5Ds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6336
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 07:32:07PM +0200, Petr Machata wrote:
> The validation logic is already in the router code. Move there the notifier
> blocks themselves as well.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


