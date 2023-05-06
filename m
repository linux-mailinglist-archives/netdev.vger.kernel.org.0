Return-Path: <netdev+bounces-697-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7FAC6F913B
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 12:41:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A20B1C218F0
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 10:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF848462;
	Sat,  6 May 2023 10:41:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475A11FDA
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 10:41:48 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2106.outbound.protection.outlook.com [40.107.92.106])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B939B;
	Sat,  6 May 2023 03:41:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGlXHhdqRCW5T3acGWr3mJ+I27WVy8BVOlUFUU6AsTPqTk1iOipD4mgZLjUMsygAuJ9Lyn2hR0njleT7QR8aIB/TvJ0lLHZnJpHzxBhemojqWpkAcz5ysfvmX+jD4pXUtjGqe0u4Jwhpjug7SxaDE/F7000HGbwCmKr9kmCBl1DQEkB2TTWwKbiRpYnNDyCyfKMF29mt8srZolw6/SKxvRuQgDphKSH5SZpDQQ9SXDzBEprSbeg9or4wjxnBINacsX2EpIn3wfu0QB5BNZ9btKknBMThOsV2D//B3FtvKOoj6qza7wFrrJhK5yzbGirECS+q0z8q4UKXQRh1mZ+onA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHFD9uMKZhIhu9zVFzUlQv8llYacZS3if58WJytEksk=;
 b=iAMkqB1Sp2tebG9xE4IsWq9uCzAx19UIKuPJSDzHwTr9Bdo9PYxg79RYSEKSKVIsOIBX4pPPzOHqAhZCL6m+Evv4X29FlGyGa/WXbq2Umlgvj8QDcIUtl9lZ1VearSCAgUZbyP9qOr7TEAscY9zZa6X8cqOPLY42zXfUfmQPcoNL/dt2vJAmCZRuRbnRzKv642Tjn129xg1OjrOalaG3WEawJhbmHAd4QmQafTvWmAnt2WLUMqqqPo1hCVGPhtxApTbyA8Pi5G7Y6X2BlIOo7hSDpbFeM6+tbTKwEtz8jJ9tx59vqpXk1z5KPoMquqPcOzhLa4d4lkos1j8Sn6zjyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHFD9uMKZhIhu9zVFzUlQv8llYacZS3if58WJytEksk=;
 b=bp2HeTXmTgYq/8i/GAeIYkzvFMVsmvURP/djm/luvUqjUpAoueZ1q2VVexhq104RLmiDnMDa5G4f+jYp+jTV35tK3p5WqAMcZRG1rOijEBy9HJoR2+1WJl4DoSRJB0z/kHjJUi66H9wKrWERKYIOdHW3wtlk4ccbgaiMCtKS1iA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3793.namprd13.prod.outlook.com (2603:10b6:a03:226::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 10:41:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.026; Sat, 6 May 2023
 10:41:41 +0000
Date: Sat, 6 May 2023 12:41:31 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: dario.binacchi@amarulasolutions.com, wg@grandegger.com,
	mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] can: bxcan: Remove unnecessary print function dev_err()
Message-ID: <ZFYu2252kh19dMe2@corigine.com>
References: <20230506080725.68401-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230506080725.68401-1-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: AS4P191CA0001.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3793:EE_
X-MS-Office365-Filtering-Correlation-Id: aff87510-9f9b-4ee9-a058-08db4e1e7a03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GZri/IFzTNdAHYqAAJbsFXzkQNHKKmwsIKZjFghsCxr56gosfzkqFQzyLwM2EkHqvT7GxRHVuRgDFABgZMU0oUnCcA6Rw1N8rxGH/awRYF0+HpatK5kbf5ZMujvtEdU/Ufsm1oSXykL/AODKnFsKKM/lIeAy5IVr0rhE5CESNWnfGClS8UF8zxxgtvgxTG1ftxSU2skkQsPcaC5cx/yZlF0L6VzN+brKBC385EnHKiCJtXmBB4XEDVEa98AZX05e8BmKIqrZTPPjuOgO/E6ypXF+Ge38H9BBGkyWn/ZQtufhLDjWb+GdszUjbzWqaL3czW0O/3KTpXofFUiE3J310BJ9Rm1icYGx0toSPQ8t6VwQGsC1S6GCLGmDOogMrpqxFdRe/5PKkxVR0OV+R/430xOwk/dM26CI6zEeZZsJ3KdSUs5SUcPOwLWq9JEJScxZnqobLgq+YInOQuvJx7PaiUNJtQF4l7hkRGv93cRqRQUf2uhPx+8K3Ecp/6ESW2zppuNO9KaAJLLcjICfI0EAttc/2o3ru79LA4M8fWJB5dA2F4q8ucf7Hk3iD4/7dN88FBcb4NG8bT1yCr2aPX2qFGSKSIRYwgYHrayrDJWpA2E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(136003)(396003)(39830400003)(451199021)(41300700001)(4744005)(2906002)(186003)(478600001)(2616005)(44832011)(6666004)(316002)(6512007)(6506007)(86362001)(8936002)(8676002)(7416002)(5660300002)(4326008)(36756003)(38100700002)(966005)(6916009)(6486002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n5r6zc7xYZK9L7RvNqkrj9UjB7a/0/PaCr7EnNpY9M4NyagBzM+VYMg1mxIU?=
 =?us-ascii?Q?h/TxJv1684A8G0sOUDBXaC3Hc/nb2j3JDTi1Wt8Z7Cy/06vQTzkcPtY9SsS7?=
 =?us-ascii?Q?N9+RdqI1SjvqVy5bUMuwPw6HnLGZQebpJRwgU+BZNITFWeY6bPBQZTCLQZU9?=
 =?us-ascii?Q?ybPkrX5z8vEWvI6ztJqfrD7pcVXZ7rdqQ5Lg+4FtxEM+Qrr6Z7a0K8QTFjkm?=
 =?us-ascii?Q?qBAbdn0tDT+2gFUQimGzR1CvZayejEO9/agZlYIuaKj2juqVcmReTgH50ivl?=
 =?us-ascii?Q?+fYa26XmMQ5sdqOLd6DYxtMwL2sppvXnv1O85E6J4FdL74rH/koDyeL+WS6C?=
 =?us-ascii?Q?+IEpeRlFjMAF2v4R1A5CJnqUrdLwT8/NY65MQbXVwpygFroV+M5NKB4wY+Qc?=
 =?us-ascii?Q?mZQypLaiVxfEHpN8Z0xZcmReqJNXMeq9VQQjlhS7ntJP4pEkFynEHDggA2sn?=
 =?us-ascii?Q?ibiH9Q1b+sesqftlnITrAOVLkxrSIIG83h3J7ct7WoZv4zp38iYFCoiTXVt6?=
 =?us-ascii?Q?6oywrhVrl31E16nAfN8kkSHkT/xFzl6skjN1GeB3HD/Z1kLvqf8xdlMFa3CZ?=
 =?us-ascii?Q?yogYvRTyHUQM/502RJybeXBxko8rgx3EXVk5+h7EB4EYkEKSxQCiE7YURwlD?=
 =?us-ascii?Q?wiI5xV+AkN/Jd56t88fITZcu/Mq6af99N29GfMmwN3gZiLQV8udXOHyesvpa?=
 =?us-ascii?Q?/qqySl+d/AzoJb0a8lbR8JwT8H1DRsvQuG987mMznlGPzveCxDglujX6AJ5Z?=
 =?us-ascii?Q?GJMSlgUpLFyLjcvTlAySu9dAPDYijby7wx2BZG8FGSVmfEIsbKfsf8OMXPVo?=
 =?us-ascii?Q?HjJF2Nl9TWW/BN9wp2Rm1t7xvQwf0vlWVwRVwwiUNgDPFPkKzPm182lzp03I?=
 =?us-ascii?Q?o9nlHqT0WMrEpP48/t8zH8P7p9j4r3SUsDX7v4vXIPSAKX3fi9cdsC+jD44g?=
 =?us-ascii?Q?w49WbgSIKBabsqBeduEUCuvvvcLuwLfLRMp0qO/1LArHdfN+7AgM9o2p5n3i?=
 =?us-ascii?Q?A+rLDdzPNghUfj6EJ1Szi1i24cYbvq4KSASQrre2L9DC5l1EUQGSIht4C5yY?=
 =?us-ascii?Q?pnaE+3L3I+cT/+qg+5CdjbtOTkI50haKbaqkMpMbNSPOeJAgHSX5RpSYMaGE?=
 =?us-ascii?Q?S159xpX4ctMdN/YpZygFqaNfu4l0Im5S9p37LtfiF+WsAR/GCLP2TAE09R8K?=
 =?us-ascii?Q?LPmTA8H/nT6h9RhjNe8L/pKfKYsFwZEwWfE/o3r2UbnHPMhIf8GJSrgLajEM?=
 =?us-ascii?Q?3AztMerz6cjTpnlKmBNdlpv30olsxDwW1ikIUVlJyt7pMH0jc5fWzk+sXywF?=
 =?us-ascii?Q?46CG3Fc+knghp76ZCP3QvupyOIMovPa2lKalhFJ6xW5Y0bQwurAVc7+sgc8U?=
 =?us-ascii?Q?WGSMmWR4mqnVxhBGy6vWROR8LKX0frCU1F1MJMnaxxfOwtkI0G8T9JfQTRYY?=
 =?us-ascii?Q?RQfwddaZAHFs9fmQhUfl3hcRxuJbGlczhUI9iGLbcZ6jj0VvXhdonNtrRd+C?=
 =?us-ascii?Q?EgYXGfnk4BelRW8T8yidhEKq4g3HiRIMr36O2OcCMxGTQtYYYUVon1fl2YJx?=
 =?us-ascii?Q?0ZZY/iKmRcYL7j4pOPRCDbg5PONeTThDqEoSHdrOX1tMxhNHM82/LLQl8iDd?=
 =?us-ascii?Q?U5D7jME1MJaOWlv+C9apAT/n+zk7eOBtVutVSqYbq2sFUKNw11kkZ/D/dYK7?=
 =?us-ascii?Q?YuKq1A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aff87510-9f9b-4ee9-a058-08db4e1e7a03
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 10:41:41.0391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBK1kxkS4BNJLTAvfSCDhCeGgmVtrcYKaV3cy8lf2KZCwTxqop2EJaykuGD/AsLuEvJXvjDBv/AU4KsPcQEWrDcadHVhvAma0/HZzJw+R4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3793
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 06, 2023 at 04:07:25PM +0800, Jiapeng Chong wrote:
> The print function dev_err() is redundant because
> platform_get_irq_byname() already prints an error.
> 
> ./drivers/net/can/bxcan.c:970:2-9: line 970 is redundant because platform_get_irq() already prints an error.
> ./drivers/net/can/bxcan.c:964:2-9: line 964 is redundant because platform_get_irq() already prints an error.
> ./drivers/net/can/bxcan.c:958:2-9: line 958 is redundant because platform_get_irq() already prints an error.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4878
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


