Return-Path: <netdev+bounces-6268-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2564715740
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DD942810CA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA516125BF;
	Tue, 30 May 2023 07:42:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8185125B9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:42:37 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2124.outbound.protection.outlook.com [40.107.93.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08E8E52
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 00:42:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHlPoV2hW/tPcVa7ds6hBu/iAuZrWZ7Q8ZFYJn3af1/f7zj28193sPVmRWvUJemOWJDxmZEimVVA1OUEzSTEnF0yqIUwuognJI94XZTrZLpNp0JNkIeZf0brzzY53abBC7HZNSz54BZ6IecHbiUCkQUr32EIsumB2xmwNVM/w1DoY4gdTnooNt2W0ci/Cy65OS4AIvOzZzBlw78wKn+sl4xydPp4A5IyndmSXlAwpUavkv0lgZCGH9byzx9L758R80Cd9JjJqFPMejTWqK2DkjHY2Uk02FEO1r/rr024STOKrkfQO6JJxOo3oNO2nFwXblk8JxQ/2+Y+EI7GbdfPEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJ8CqlHgqQ3OK1fa3kk5VmlgI4CIPVI+SBez2N6+cm0=;
 b=T2+pgqeM2meXmpjXRnLGErPP2nu+e34F5exKHwetSpiF5j8ag1AV+oD/rIa5XmYCpkK3ON3VlkGYIQZGBLd8PmB/LiM+WzVDxeQijpQYkis4keVZ+yBhejulfAbuk7+SFFfc8LzXuEkQdLzsQWYbRaPy/53EqFRzVNCLE9BBESfSYeBcFxZ+X+grckItqq86AeI7pYtSYZhVkUob/sotgm3cJ82jQG2D5+xWNE9aU799JRAM6A7Zf8Pmjj2g53FXhZdUSQPrt8EBdD9z82W4W/1nyK0zm4bwwYUI2XtnGu4OoYGrTcQXPGC9ziHiPVbpvlHWxidiqH9RSG6aeMABhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJ8CqlHgqQ3OK1fa3kk5VmlgI4CIPVI+SBez2N6+cm0=;
 b=Cz3ZgQ+bmzHfotRso6DSy+ug5RvNAflS6FEL+ju6n1Nv6u/ogm9T2IPckUF3+1+GtUbSey3fL+wE3SuybqZlO7Pz8TWwV9UzHbiIH9TqmRg40dGtFkhWT/jcc3aK27dJzcnUuDQWCkNoA86o/+quOHUJDhbQASvn0+sdgT5AhdM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV8PR13MB6494.namprd13.prod.outlook.com (2603:10b6:408:190::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.21; Tue, 30 May
 2023 07:40:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 07:40:22 +0000
Date: Tue, 30 May 2023 09:40:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, David Miller <davem@davemloft.net>,
	Realtek linux nic maintainers <nic_swsd@realtek.com>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: check for PCI read error in probe
Message-ID: <ZHWoYfW7+u01hlhZ@corigine.com>
References: <75b54d23-fefe-2bf4-7e80-c9d3bc91af11@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b54d23-fefe-2bf4-7e80-c9d3bc91af11@gmail.com>
X-ClientProxiedBy: AM0PR10CA0112.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV8PR13MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: 79af1f3c-5979-410b-4a27-08db60e12035
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IW6XLFlS+JybcXgg/s34ypmiZ3aJ+IhGWSVmSOYPtMGJVrI3sgwWKyeOPoeOZa/2Q/zezK3H9Ocd7Rf5baTwC3hqLhSmogjh+GeOphcuC0/8O4lqIVAMnUfMKT+HCT0QoIKV4oAQ4nmN4PgunetWB6JJfRddqXEMX8iZn/OQCS1LbNlKGJdCFyTwgQYgolKRFg8E/fQUl4znsw7N+uG0Da4Dx9AMA0VHzc6L3dolQdxptIIaoQAOwjJ7phNWCFRdMdgW1adysrVQbVzQSkcqGObnJD1X85z1qZmir7OEflr7+zRoT7GQfq8NqRGR3x6TE09/9iqfAKAdNkD9f4G1xmA8uqwEFZvNshx7sx0xHm3FrSF+J3AF52zr5/QHWotYaHsdAtkxF1BWvzn2XDqXf35Vsmt6bEU5XNWLFoTJhNzKwfISR5SufZPgQzZag1qa7N3a66x6XmVqDFhATkEgzJCg66f+S1eAASq2EE6xhD/fS8sDs6WGQj/dgu2t5fR2lELhAToA9f7YHFRfrj/nsHkXzUXocfRSEw0Zxjg3oqsmAEEc/379nCle1htzPqlaCdCjoq4sVW9gEDrL49ThW+g/4nELrOle0nTw5lp7yx8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(346002)(376002)(366004)(136003)(451199021)(478600001)(54906003)(8676002)(8936002)(44832011)(5660300002)(36756003)(2906002)(4744005)(86362001)(4326008)(6916009)(66556008)(66476007)(66946007)(316002)(38100700002)(41300700001)(2616005)(186003)(6506007)(6512007)(6486002)(6666004)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iWDezvOeRGjeJmFvHHtTklaAKw0S96MMyrWlM1kqSK+Wm6CZp9yVBW96cZPD?=
 =?us-ascii?Q?LRZrvwQ+UpCvUfLjn1nwVxuWMPZ7xD5maDphn7dCP+og+srSrILQf9NszQFG?=
 =?us-ascii?Q?Jx3ymWOE3cyF7fVXMwBO8uEkbc+3NSLP+NXw7YkaiX5grxKtqvVQaEFW0kCi?=
 =?us-ascii?Q?oKdkSDWfuRwtcftoRWAfizguVvDfaZrBDvDUewF1XadXq7Vpaqg9b0LnOYtz?=
 =?us-ascii?Q?37dQG9XzYeKWR2oDSLq4rrHekS+i2uL2tSpEGhT5sm7zqRzXfMZbpM7lW93m?=
 =?us-ascii?Q?OUOow2wDo/rqdWiDev9PeORFfWhY4BjOQgpqkbSm6pQWtIKiuB+oOZ/yZ1BR?=
 =?us-ascii?Q?cONK1dVVf0A2s1Z2azksZoq6PsXHDd+e1rTCMSPsjBxkZjsojHYS6UfjcJBX?=
 =?us-ascii?Q?Y2q5yi8JRYapnYlDPanne4kDOdUNl7soGKX2/oWg0QEEOQA+m9mp8KAuUM3d?=
 =?us-ascii?Q?i6nF3aaAYygqYmfvccp0f5cwM+EfPncRwR4LsXsc0af6aAWfqS2fHvhB26/v?=
 =?us-ascii?Q?AbCKd4J/B0kThpU/grfoRW9aXqi42GKehzQrcHMnO3zYSqvAhfhVoNAMSTj4?=
 =?us-ascii?Q?lZJ4EZhxYkThgstbHT75tMjH7F7yCUM8WOX1UIjbFKnthhdSgocvKXTIUhGA?=
 =?us-ascii?Q?FhDBMQG3eJxc4BVJtSjoRUcTzyQN7qTHKpr95jotvrpRcr90Uy/WvOomZZdp?=
 =?us-ascii?Q?P6KYwdD84gWfL2SEuFYThc7gO4AVBSdTAlU9ucjfLUy/3MaQTjwNNAGlJUzC?=
 =?us-ascii?Q?lNU87IFYpS/1CDtQ9P4QTxL8yt3p4VyEvj4ysVTWICak3QdGJQrFvq2WI4BD?=
 =?us-ascii?Q?YohpQs3uqCkQYnlQwTKEBKJqiYgNmUVDtcvJWfG69Ei7NpbjW3uQOkHyZH3T?=
 =?us-ascii?Q?lYQ3MNu8NU3uHSrMMqsaR4OxULtFgofHWYmsxA2fwFkyfKdlcbiNPHg0sA3B?=
 =?us-ascii?Q?6f5VDsQp131NTGP41nhvK9Oj/p++jAUTHtkvi1+UqGgWIpfxPk3Pih+3FnYY?=
 =?us-ascii?Q?YcPWRFZ4hkgbXYbTMHOFpg6DQffBP9TVH6KB5sWtoG3S2nlrw0GWEaSTiAx8?=
 =?us-ascii?Q?A0SAuWa4mSpnQO5En5nZibQi7LAY2kweJ45RWB/xhCEaxVm2DNUcFoayb274?=
 =?us-ascii?Q?rLHIZ1YEMgk1idNWG6IJ98VDsJI5k9Mk4mR0FGm1d2s2CX8PmgJhp1JNDZ3Z?=
 =?us-ascii?Q?uVMUqIv/FFISV+pqSJjVvcQtkxSrWOcdp/+AJqjE3iCj9B/O7IWEfDhnTad3?=
 =?us-ascii?Q?88AFgBfJCIJiIvpTnllqiyFcAkO4PBF5UUt3XofnqDdtpLgAHBRURWpHx5jx?=
 =?us-ascii?Q?pMthwV+evfTetEwN8UkPFJgU6l7IR2G/pq7QVg+B9TClVSG+sNGJdhHLYdnD?=
 =?us-ascii?Q?RB9FgV5t+rdYxKPj0dgy3DC5KDW8FyVaFSciDvAx4LIOREe8fZxCYkP/TjGw?=
 =?us-ascii?Q?r/r9+aS+fyllVvfYevMMP0I5Kn5Ef2CJOpo/nxhXPIcumNe4BTIUcaQoMwxR?=
 =?us-ascii?Q?WtCc/d4IAND7C4gQyF1Bsb+boGTTBUVGn/gVjElofuQ1RzYSM3qi3+863yQC?=
 =?us-ascii?Q?sA6IU13mZ9Ici2AiuCwKanpq8EOIUrhrGAVRq0HEyKtzkxwQ4C26I3THCl3n?=
 =?us-ascii?Q?j2ckMU2OhWQRoiMF7yIqFSYX3FiExTcPxcoBJUcubkggTrYUnOSMW+6Tq7y8?=
 =?us-ascii?Q?MxXmkg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79af1f3c-5979-410b-4a27-08db60e12035
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 07:40:22.8671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VX+fDpuuDNyfRiEBCYyQi+DkekrRcfr3JIj4EaqaHSpQfGVv86KRZ2WvfZKXRsXq+bVl9BIi8fe9T32jRKFamcnhCx+M2uqQ4TxfkKPL/zs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR13MB6494
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 28, 2023 at 07:35:12PM +0200, Heiner Kallweit wrote:
> Check whether first PCI read returns 0xffffffff. Currently, if this is
> the case, the user sees the following misleading message:
> unknown chip XID fcf, contact r8169 maintainers (see MAINTAINERS file)
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


