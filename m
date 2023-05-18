Return-Path: <netdev+bounces-3687-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 110AD708542
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B90432819DC
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2EE21093;
	Thu, 18 May 2023 15:45:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1757053A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:45:56 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2119.outbound.protection.outlook.com [40.107.93.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC39B11C
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:45:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdOR0L7Lz/Zrj4zcaNP4bL6uiDY2YgGxY4Imi2zkrDGwPL94F3IL1MCske8tDyHRfkBDa3iLPTdj3eqNuclDhSPT2SuQNEb6rDPS3E6pAMQS8zaTd2CyOpquv64UqKnlnoI+rDNMV1yrhkxKQVLJbgCdYDiewBAOWwcNiSxX/1hxBHNkx1YHsdp5wRLItHSZEKAGl2fWsudzu4S8OBqQ9IEFla8xu1wKLS0xhcbIRDRpE5ynInJWR3fVKDEHXtxxA07pLif4bWuiPAmnGsQCh/tD2DQ8uo81ym3yiYdAQhaKsB6UzzZp35r61gvg12jwLIGzf4gQRqiS+vti6+B6Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUHOK0Jd+Lfg9Ufjr3AUkter9G9zqa9hpZ7prPWePfA=;
 b=JnXqm+3n0n71j6QaeB/+APCmsMckqJwldp36tA7OkEhLVF15EC1GyfL5w2iQfi1r5WfqRax88T4vmpMxFoomHQr+1HfR2HiAVP3bIxroS2oVGrPQIJxxMk1NaCKYdiue5ETf4qbl1twUyNJ5KqRG6wJZHxBWBH9ptmZ6aljqAUPOIQ2tVJ2ouGz05w/hhAMOHW9Z9Vm22GBHyTAYWkJociuGA55ThgfJHXn6MWySnpj5SbjPET33TWu1uCEILwj4CHpgv4NydLsKOkOMhNBZzzRIR1Ei7coAY5Gld1J0lzYbDVnt2PX1yoz8feEvQaZyoLI11lJrWhJ34884cOyihA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUHOK0Jd+Lfg9Ufjr3AUkter9G9zqa9hpZ7prPWePfA=;
 b=fE1TZ/wd1oBswOhk8WcPq7qKqk9YdEbHLXRVgXcNn9bd8NXUQQOsHcLtIJZD/NWSL89CxFLuBf3Dbv+f5wcrh4vX7nBTJj6URA+NGfcl3Hs3ZEhs+mAL7XCNUxvbnxm0pdPtk0pOyaZiiLXI1VTkVDJO3PT3p4rXhiA3epDp7pg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5495.namprd13.prod.outlook.com (2603:10b6:510:12a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 15:45:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 15:45:53 +0000
Date: Thu, 18 May 2023 17:45:46 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
	tariqt@nvidia.com, Shai Amiram <samiram@nvidia.com>
Subject: Re: [PATCH net 7/7] tls: rx: strp: don't use GFP_KERNEL in softirq
 context
Message-ID: <ZGZIKkKZ45T6tq8U@corigine.com>
References: <20230517015042.1243644-1-kuba@kernel.org>
 <20230517015042.1243644-8-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517015042.1243644-8-kuba@kernel.org>
X-ClientProxiedBy: AS4P189CA0001.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5495:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aaf1e40-fc3c-4d9c-ea79-08db57b6f646
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1bhAWowz5sdk5TPEa5e6bIPZzVuO3Z+BLQT0IEI1WC5dtvE6fFWMEc5RJ9FENOYEb0qGpeXIaAPw8gV6Bdxhnqh22d693A89IINQHEfsweq/ss2aJJ76xyKDHVhlnWDTE6pWDNjh5OwtYjrcauK3qGjYvPve3wgmPQwzNAh1wqc2Co3gJiw8OZbPKDXxhnvevsUcn0zuIryWAD+Iu2CjXzsdIhhy8qUfmEWF5UwHzhWSn535DRMPSo46BH/XZCIgkh0Qm3F+/zPd6tvmlD+u6Xng7HXhk/57idk4Fnihr0BKl1yAYWebTzlZ4OJ/nbemdNQlpwgWaPeR0vccWXVongsm0BGmYlS6sD4+Uf305oZouK6vcuv5Fl2PmXHOAwQfAn6K+KovY3SijdgmZnMKYCSgf/LM2xFEzO5ZW6SSkyJeZMXtlUcFkuI2NBZrzR6nNDIb6rjg2L6RWVnQ6oLW4ye1ytJ+NtOSuHXW2VUC+Cv6BILIlE5k4vtSJF0uNdq49uNHRCPMvVGDVgr9iQEnc9fqrEzJ7tWFHOOEpr0V/jlmvYTWc/Tn4s5NMHwfZlyX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(346002)(136003)(376002)(396003)(366004)(451199021)(66476007)(38100700002)(66556008)(66946007)(316002)(4326008)(6916009)(44832011)(5660300002)(6512007)(8676002)(36756003)(186003)(8936002)(6506007)(2616005)(86362001)(4744005)(2906002)(41300700001)(478600001)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S2yeewEHPAGljT7X2kW0wwvEBVvJ/2NMx5F3C/AiFAkZAJM5HbdCojLPvzSZ?=
 =?us-ascii?Q?/ogo4u9bB1aFydzCEjHjJDOSab5Nj7k7ouooU4KYlGi/PAIKGhjeK/lZiFKR?=
 =?us-ascii?Q?DWVjzvJer6t6de6FTQO1Srm2qLaErpDEeKz98G+1DIlReQVE/sXhLowkz1uh?=
 =?us-ascii?Q?ZjSJxv5ClFrtKWqS/Q8P6x81Awf+A1orHjSmagc/4nsquxkr/sfCZ+bnqpmy?=
 =?us-ascii?Q?w1d2vAWPphQNRsBdQhQPEmUG8N5kHe1vX7dBtUjhPou15A7mNdiGCRO1ESs+?=
 =?us-ascii?Q?zkV0ScDyLzYejlVBKyKMF8dNFecgzjzTvsrIPzIwRkIW6px4rDUxrysA3/U5?=
 =?us-ascii?Q?BN/K2Yqpw789iSCmJe5D5T8ixo6P/ZgyAfoarXHVcCPExSrseCHxnXz83sau?=
 =?us-ascii?Q?9bZzc8XUVXBj/A6xPdJD6eadHwlkC6j1PunSqDH8ChwjciPsOiKR7+daUUDn?=
 =?us-ascii?Q?nRUItT2P2AiXeINiVj50HCtLmLNc+vr3h4WckwgUyY8jBQEzXKhh78CnWucI?=
 =?us-ascii?Q?5gN8pNoa+F8wA+5sV8qWtlv0xPiBQiO+9JoDcLdDhVCTCQTiqNZHxP4radiP?=
 =?us-ascii?Q?6ZJVsKv03m6fZcIb1tBjIZ1+sqcj90sB8VPStJi4CekKoARwGQJXbXOCQY3V?=
 =?us-ascii?Q?qFBTOVt0Iyq+O9pcTjTZPB6/GnjHQhJQkJHaHohgMOA2B/M0QUUOyeC6cJQw?=
 =?us-ascii?Q?M2LM5JVG2tgFwj2UWh03ty+F0f2jO91NgRXfGlAH0mXDWFSoBMsnviEfVSNZ?=
 =?us-ascii?Q?q3mF/yUCt9eWyy/0SYKABlAZ2WUDM2ScwlLgc9ii5jEl78iub3K4r5OcNViO?=
 =?us-ascii?Q?I/lrYiI4Kk1y8FU4JTGAis+w0EZhFVl+Fg6wB/LnK7slYpeprgMz0qSc8iXp?=
 =?us-ascii?Q?UTSWLK2UVr5fby/h0C9RTKiM3vGxgBYNCtyfIZmN+dS0o7CJa3b75mv/8Zwn?=
 =?us-ascii?Q?PHlJiK67Fd+JpdLZap5RRNFj7sROBTq9G6WP4dg6pkBMsEecbRIIxMU9qikY?=
 =?us-ascii?Q?VWaJs96vpiA4hwQe0Vnfn33ThdIhb2CNhb1qqnnaE9S8uJSGUOF1AgI0x5rh?=
 =?us-ascii?Q?+xSye6kRNr6InonBtDPaZrJX0O7S1IhqR7RTdh4YN2yS/NCWwYrQQ01ilRPv?=
 =?us-ascii?Q?oG8cgeJZBmltTuoN3sqt7ov+sJs7qSp3cL/wXbWdxRMs7N8w2IDmszrBbYXK?=
 =?us-ascii?Q?DAplqDOh4k4iXjMnPljks2//YIGSi/vLUUlRYpymkg0tBdV13oUdwE4ZTdd/?=
 =?us-ascii?Q?Y2yUupdIJbM7Dia7OZXmFN27jGis+rpt6VcTxh3EEYDgWD//eG7tLlyBW7zg?=
 =?us-ascii?Q?Fj6NDP4/Rd0vMH6h7zsyhV8GVhhJaMK6JXhqkXim/rg0lXRc36BYiDDiGoHu?=
 =?us-ascii?Q?+nZFnCirfIFeqXQMcIaC/McLl+A02Us8RyVNBnw4HUBoO/uDsx9vB7Lh2P63?=
 =?us-ascii?Q?8GlyEHVeYLQJfoilGjvgKvHZc2NkUwQoiCQzm9rZtrvWH530WmcxdnXMbQa8?=
 =?us-ascii?Q?OtwRo63TS+53hgtM/mVhrvA2yPRDvc8m1uP+r5JTrcgkbZY+SX3CsTie3/49?=
 =?us-ascii?Q?EQcI13HXD+yM5MFlJu03JmkPecRNVLqXv1IdGgOZfIDvUNtaTDi0qQ14020C?=
 =?us-ascii?Q?t+KgFvOYfccNWbYvXMYLHR6C4/in9GtSeDfMLXScT3YzFi2YcGMUoCIVGR2c?=
 =?us-ascii?Q?G8AUKg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aaf1e40-fc3c-4d9c-ea79-08db57b6f646
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 15:45:53.2200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXvSLnGlQIzbnR8Y09lTFDrot7M8AV2FS9uOGqjs+RKWsVyG47ulnuubOXiuiJW66BwY+twtg2ASbFF94/ORDO+KmC4933pcMD5y+W8wFA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5495
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 06:50:42PM -0700, Jakub Kicinski wrote:
> When receive buffer is small, or the TCP rx queue looks too
> complicated to bother using it directly - we allocate a new
> skb and copy data into it.
> 
> We already use sk->sk_allocation... but nothing actually
> sets it to GFP_ATOMIC on the ->sk_data_ready() path.
> 
> Users of HW offload are far more likely to experience problems
> due to scheduling while atomic. "Copy mode" is very rarely
> triggered with SW crypto.
> 
> Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
> Tested-by: Shai Amiram <samiram@nvidia.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


