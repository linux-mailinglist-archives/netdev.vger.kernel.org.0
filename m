Return-Path: <netdev+bounces-1472-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D5026FDDF3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B88C280CF2
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2AC6FC3;
	Wed, 10 May 2023 12:39:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D53A20B42
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:39:02 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2091.outbound.protection.outlook.com [40.107.94.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F061E114
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 05:39:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asWBqVMLmOFBdbujjfGmdIQ4O7C6Qaw0DGbUzxWcfwjK0NajkW0lqa3f2/oRpu/aqKX9vUWwlfisOX3oAfyTVSUlcXF8qilgf0qnNDjpsGCD6iwZTcMqOjBD3bNTdePfvf/ltrbWX4+nY6EQMcQfGcACXZ03TBLv5THwxqOkkDCjGEKp1CDL/QglcsIBSkM9qMar2jR6+qN2RC3MDxanxsh8ZO3/FOXbGifmONmBpMDAmsxgHWZ3NYNf6JYEP1/GGNsFZehOJ7r5uDsLI15564ALSmrZRQxvcYlr7z25I/kOyeq66mxeeiF2EqE+Xmi1P+9vV4bX1y7ifD/vcXK0Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ia7JyLuCZN98IYSsLBtQOKDEY10kM1gQEZorDC6uUoo=;
 b=aBJnOv7CwIngKb2PhcjH/lR/pLjoBPHjMPDUkuWvzB3RukV2nlRpeTe/u/YwJnzZhwgamWfkFF8V/ClCIeuOmcZHj7fhiP6gkrCkdar2bLfllStktcbevs9qOYqu8Ewfdp1eDq2FTP5nju5SnzhNRqvLk2gmCFVncXSr/blHJM1K8pycaAZyXqlYfbwuVGTu7E7lSxtO41zyuLRaJWWyf3TwNTOBZDbNSIi4tXj1NUjZvKhvMG3zdRssrjuEievaPbhNJlvYLv+hYATS9BB35riF2oMkKyR5sQ0xNkNHvp60JgNTEsvArwNhNGTOMxQ/oEhV+xMgXGFH97QDkQnzvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ia7JyLuCZN98IYSsLBtQOKDEY10kM1gQEZorDC6uUoo=;
 b=DBIHKK2FyTbH2rMY2Jsg3CzMN1Q1PCImuV8G2yFLdUKxpryyJQOqBzV+FO/Cmfwram1s/pZzEuut3DrVrqVjt15oBf/qAVMCJLZP0u7k5MDRV4M8HL6XJJsoBRfVlGtIUr7V+JwzL4pGG1AZme8aPwAiL6qFQEhrLIKt380EG9s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6440.namprd13.prod.outlook.com (2603:10b6:610:19d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.17; Wed, 10 May
 2023 12:38:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 12:38:57 +0000
Date: Wed, 10 May 2023 14:38:50 +0200
From: Simon Horman <simon.horman@corigine.com>
To: m.chetan.kumar@linux.intel.com
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
	johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
	loic.poulain@linaro.org, linuxwwan@intel.com,
	m.chetan.kumar@intel.com, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 2/3] net: wwan: iosm: remove unused enum
 definition
Message-ID: <ZFuQWmQFcobnqxZq@corigine.com>
References: <0697e811cb7f10b4fd8f99e66bda1329efdd3d1d.1683649868.git.m.chetan.kumar@linux.intel.com>
 <8295a6138f13c686590ee4021384ee992f717408.1683649868.git.m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8295a6138f13c686590ee4021384ee992f717408.1683649868.git.m.chetan.kumar@linux.intel.com>
X-ClientProxiedBy: AM0PR04CA0078.eurprd04.prod.outlook.com
 (2603:10a6:208:be::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: a0a071ad-044c-4cec-417f-08db515385c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NgS/K6s+nYKF6UMbVPtRH2cOwznCLyEzHdLxApXO+wLPRwXKcqMM/vS/Pt0ezmk0OHviA8qqn9hoAOGsQz4EMIYTbSkPzYTUbmTTw+1jyC9Y5mcdzVPRI7ioJIIn+MTvJFgkKnDsFLVd7lWg2KBKo5fPoXIxMAMqMHcvIEYvTDIVP3O/JcVg3+hxQohPs2mAa5xsDH33oA3ApRSPFIS3eW6U0LwTGzruLhw5qnBKTpypZsR4rYwxTJC970c5mqtQjF3ma+S/Oa87s5GQA098oTUyK80NCl6AmhVXnRPXIiDARlYnFGOrb3y1G6dlyy7ccApwt9LedIwrqgRqfVlWvjcOQ8p+ZYEJ2iZrPsQbOwG+jxu5VpJYH3btMsgLB8VlmgAMUuJbSXO5dxAEckYMqxZVBp7C6Z+2RTIPQmRom6eg0u5adM7Y4Bcz8a58kviYI81bA8Gk13ly0AXBziypKJpcT9MSwTX2vHaaRKgHVCU+GgZlZ0dgjT29qC2DHaCVP1THWzsGXzbRMbfcBO07Yw0AmmZiZ4G9ac1EexBKZwD2AGGg2S1A/WAt7bWggYmP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(346002)(376002)(366004)(136003)(451199021)(6506007)(6512007)(6486002)(2616005)(38100700002)(86362001)(36756003)(186003)(4326008)(6916009)(5660300002)(66946007)(4744005)(478600001)(2906002)(8936002)(66476007)(8676002)(66556008)(7416002)(44832011)(41300700001)(6666004)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hokmtGjJaFHQ90zOedCi2Prj479xtbwZwMtSNTLNYp9m1jw7aq5zWwqRBNIg?=
 =?us-ascii?Q?QhC/tg1IMaUcxb/+e9wmE/oDqUbMg3tPhHhmBuvSokvDKu/LJ2STY0slgfsx?=
 =?us-ascii?Q?ftMoKqxjBiGI5V78ZJeS1Pea3d2Pwu6y5LaOcir8mZ08Gh4eUUVp9Htikf4I?=
 =?us-ascii?Q?57TFMPBBEE7EANo4HZybirt5kV18BTR/4wkkA1YGsR/dLvGqy32gHQ+pMjYN?=
 =?us-ascii?Q?Ed4cO8PHU/bl4YoymgX0GXX0iSoXJj6g3pJmnQkaeeQcV8tIexlQYYr62Muz?=
 =?us-ascii?Q?I3YjeMmn8fu7kBwPHll9EWtqs5JzNXWYUYbjM+plYVYIE7ZgL7mmC9x7CmUE?=
 =?us-ascii?Q?h4Nz9Y7k9vL/g9tRt7BNCE82addMaD0PtTMXOlICXUcAhd1BtcQ2Gh/5XfUU?=
 =?us-ascii?Q?bHPMeJ05hnWYGTidKWoVz2X4cR/nHqoSgKPW4Ye3k0BXZVKBpFrND4XULp48?=
 =?us-ascii?Q?O4DOZ7RpuWacvW8jB6l5Caixv1KpIjGU/MMAXJnUSbEDcA2UUXjF1h4ThhnC?=
 =?us-ascii?Q?twSTYNP9x366hlRciEowSryaJCG/DK+ihzpLfPI+nI/I/lnAC7xtT2vTgdif?=
 =?us-ascii?Q?bal/pLYlfMYHCRMT+UPKa3ZIkjAAxRmwx9kvMUNpcjfPSJ61AEhGm77cS55Q?=
 =?us-ascii?Q?e2gIUe5H9q8+IJpOg5BWEs0Xdvp0iyFCh54bfEsD3rbVBwnrOMsb3tJ8CjCc?=
 =?us-ascii?Q?WAbQeZIbtDWQZArqQnbto2tqfkp/gaVARK/Buc8bG7fKI7bgPcTf6oiyL6F4?=
 =?us-ascii?Q?DUsgCthZN0+Je0nxXFVfiqOhZcHWWUaS8tooLVu6N7/pY2nQzF3HUw6KmPtj?=
 =?us-ascii?Q?LqMLqJEfPxoOIRSSpTZ4CYcoflpoKFer5BhH0SqLclJS4XnFZANVwLE4QaUK?=
 =?us-ascii?Q?ELsAcYktOTgplZwvnwcDfImaX0k48wGRar3iZKynRM90wnXDl70SgwoHpikU?=
 =?us-ascii?Q?9+3CVXHTs3VTkDnVdc8fRGUj9eqMOOJhagIJ5A+CdlQUIsb6gfAQmPi8UiXa?=
 =?us-ascii?Q?1bNdRuWuFaeMSu0Jg1CzSU6T2eQWw4NDRUutnBy0YOqBmwu5A0SD4wdgdCkm?=
 =?us-ascii?Q?0tzNzdLe50ojX5W6sA/LHBbB04CJcWkWVPI/fo2MXP2FQ3Rh/N+5FD+EqGsy?=
 =?us-ascii?Q?7mNP9d9LYROd6+LwhE7VUCwSDO+WUctcqDXtYGnPnI/gMNACmlbRuqV0JELh?=
 =?us-ascii?Q?imgJmuSoUrTbxTJuqYivQdHTNoRyP3tZtMewQZdWm1J0RPFM3hrcpDUXcm7q?=
 =?us-ascii?Q?24bEuul85SwfnXT6w0U6ts4JNj4IVXBFkPLZG33KzXQ0yaLSNAVJpkh1cODn?=
 =?us-ascii?Q?0/0Jr/boQB779hE+f0XQJNrnloKtcGtTE/otKl/MDPtwR2eLz6shXmKzmNwm?=
 =?us-ascii?Q?XUZzArB+9sCRdsiwDS8pVFOZT/sLNXxa4RY5vB5QtwIXsMgL70joFr3rebqY?=
 =?us-ascii?Q?6zN1ZLBPSqUafuMUaUF7HDFxtwuZS2AJx5rr10g/Wzw+ix0+93H/jXEGlUz0?=
 =?us-ascii?Q?tXNrlJgIdoznriggmNNdTITIOzWPVywy110VS+vL+A8iyVUyjengMd3y5xCZ?=
 =?us-ascii?Q?tmiGYPx/AIdIerqc1ckG2LOWc2fr+uBKqNu+aBavlnd9f180BzkobIMunnaH?=
 =?us-ascii?Q?qHE6m1hYbwVR2H/LfiNVNPbFN7pyzKVMveMs4+g4+EUGMs1PMfIyEBpBBHBr?=
 =?us-ascii?Q?eii++w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a071ad-044c-4cec-417f-08db515385c7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 12:38:57.2997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4FHKOJrzmiX32PqSbVBgfDtrYfNQkPA0dA0EUmQUdFrdvYAgYZfdsWmRIpf6/oKp0Nl4SxhQE93rXw38XfTBY2OrDJF15PMd5oATmLIlrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6440
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:06:22PM +0530, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> ipc_time_unit enum is defined but not used.
> Remove it to avoid unexpected usage.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


