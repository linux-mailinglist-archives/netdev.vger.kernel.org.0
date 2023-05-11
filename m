Return-Path: <netdev+bounces-1777-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 089346FF1F4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93642281746
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51801F940;
	Thu, 11 May 2023 12:56:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84D41F920
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:56:23 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::700])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C656106;
	Thu, 11 May 2023 05:56:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjCuiqpLyJOsolfhM53nGGvYiRUHzvam/+cdrcohKpgy0zIF8JRuMZWLKkra5aMvmMOYjBNVgXio4PBBqyjXAze/p/SVUEFIqg1i93ayp2JRChv9Xr1pPdaj5J5WypwROgeeSja2J2Uf6Lg3omtkwuDHz86TK9VmE3bghiE7flKt3XTw4V86fs6CUllgPk3kMIZGQ1OsM0Uhl2MQtuOJqchUx+18zXTTVjk8LT+ksalOje7Q9xXZtmXxqxWBV1EUEVSF/DQ1B9qMzp7LU26IMmRMxnIVCL4eG0U5DkNApacyTZ3qKgGSYcwTEwTeAXSg+Vet2ktgIj0JV7cW5rMIFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+XL8Scde6O9KFLXlNUQHyPsvm5I7veouXmH0GYyaXWk=;
 b=EwzE4HAiuvNqNYVgqQTPZfEZnNGKV4BFPy4lP+oubYhvc7z5E0mi2x+ECps3eb1a3VcRVOUeWeH2mhGScX6cB8mdwhQ8NtNXQtTeyl3W1efP2XyynXV+Q6+nmepeszz11m0BazF020MMRVcxzmBvQzx/YISJmiGuooCK3T/zKAuxhv5jnGDTYRIIuRU+K7BLvkxHY+RnhihlzE9ci2MaasWDXouFGmMofeQe0pk7BdHpKIKaxvKX4YJ4wzSA/dyuBj4SNbHFE40+sZCjLCty+AEJTSdFyvz9sBVesA3ZKhzM6XcpYI2RNq5/LXVbfYRM1MJMpzkil0qJlW2eBPc7Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XL8Scde6O9KFLXlNUQHyPsvm5I7veouXmH0GYyaXWk=;
 b=ZeSKH8OITkwTL7MtiO10RSQ+Sa1nxf5xBA9bnUBQwp88VwxTDn7mz4smzeWjIDtaRxXGCCROdPNU/ti4MLK1RDGFrhHvArg8hIXTlHp/7IiN/xmRkMoHTQtRdxymMo8oLDw5NytCVr5+l3p0aFNd+wlw6Qy6cFNCsn/IC+z/i0s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5136.namprd13.prod.outlook.com (2603:10b6:408:166::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 12:56:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 12:56:16 +0000
Date: Thu, 11 May 2023 14:56:08 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] ipvlan: Remove NULL check before dev_{put, hold}
Message-ID: <ZFzl6J4wwyr5QyLw@corigine.com>
References: <20230511072119.72536-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511072119.72536-1-yang.lee@linux.alibaba.com>
X-ClientProxiedBy: AM3PR03CA0062.eurprd03.prod.outlook.com
 (2603:10a6:207:5::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5136:EE_
X-MS-Office365-Filtering-Correlation-Id: bc37cf13-3dc3-486a-2614-08db521f1bb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Phe/2Dg+O/G3xp0XUVbLGDmq40uSmH97FKk9YgjNDVwAifXD3iV5Vjkw/vp1M1syR19RUEO9F4Es3Fh/f8DQqOKUcMF1TVS6z+ZB7SyWpEMHKmH61dH4cA/dYiq+RiCkgEZDPbJnZRnl5nezgjYCxmi5+pnAwiEJjJoIEx3WXzvssUhG9coHt6aXznT48/D2+yayA0wczydv8qMUg+R+lQ0Bg73mZHal4ANO5+uPd69AnMHcS2POgWMpnuv4NLxkfIFJ3c5fchyZScb1TpCyCWpwnTgcmJDVdewGY/l8FT0v93RKTeCZHTpnveLA0LIuoLkRFYh+agU5S1+aEoXP1H0vwk7kaHS248oQd3x39q/GmfGxdRk5heIScGQvvYHnf0kTdccYn54nbOYsnUB1U6tTHWM/5F3FYtg9Ge7ahnJx8M66JSqSqMOf12v6wH9bZIhN/f15EMKZHcsticJG025xEzYxYoe19T6nI5l3fKtDnrcdeWEjf8vI3A2HLrO12VVii4A6GxF7UoGoVctfJi6x9OhLN62j5yJThutdyGs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39840400004)(376002)(366004)(346002)(451199021)(186003)(2616005)(4744005)(2906002)(83380400001)(36756003)(38100700002)(86362001)(6486002)(966005)(8676002)(8936002)(316002)(6666004)(41300700001)(44832011)(5660300002)(478600001)(6916009)(66946007)(4326008)(66476007)(66556008)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DvglMie2n9Ht8G1caX8zfcFAgwNgyo93aMeKh8SmzLdr76cIVlNlahLdGsMA?=
 =?us-ascii?Q?Vhr2PLzMYGsfDX6DGNwyMDq3Dm5yneucYIm3E20JMTVbClGjlUdzGA3OGlz9?=
 =?us-ascii?Q?h3CVJ8NDoHgYKRCLHwMO48HVedKKBFRbMtRvj7zSkFkNx0HJZNvzJyQOO0mA?=
 =?us-ascii?Q?fTKZ6HgXwZpjJKOyvmbkbBkCFl1JKezCURcLX4Y/RCruU8iDTA9BtFTGIWU4?=
 =?us-ascii?Q?QaTPer6H3tIVa6ug+4xJNIwj7PgQK1DUBVTW5/nr5LZS0nxmj3ttKUrbi47d?=
 =?us-ascii?Q?rHTGJNQp1FBN18y3Ml1iGAM8RHSXp0KihSLDrIFHKJ7KPHJfb6nhbVERo1c/?=
 =?us-ascii?Q?1syoknRFjoShEOYkeJCIBzN8uelQFazT2PM3sXzm9EnA6NZiM2JhGaoh2vQI?=
 =?us-ascii?Q?Kqy0xoWd+8OYy+WiR88zX/PPIH/psE8EAdnjIqrrQJvafRihnfnp69c4N4YJ?=
 =?us-ascii?Q?qTPHFEai/gQWm90kIQ9wg2P9t8okVcLXpo52JOEEtD3BRVDZS3Msoea3qdsy?=
 =?us-ascii?Q?/tnfCg6p0vURRODBZYsNvQFcNKZe1fCfjLQVNj/j97IRaKAOtVXtX/LGOmb7?=
 =?us-ascii?Q?sXr3NUjubytl2xxDQY18v7bCkva5e20RXI17eaP088fIbHlI6DdKNlmv3pfo?=
 =?us-ascii?Q?dyCp4qtpDRX7h7kxdcmGIBedj/htqdpX4/Is9FMLkC5kZaygonNz9L8RjxgL?=
 =?us-ascii?Q?wEd4aYMHFkV1p2kQXUG4ALOYZkTc2b/xZJU+pqgPa9bOiMpQMV3XCevGYnNq?=
 =?us-ascii?Q?kQgXTaOctVxkdtsxpVGhuluwxNJF/REp7couuimUzdBg0gv5w95iERCcV5Q9?=
 =?us-ascii?Q?8lSW2BpVuWvuR1+HIdI3Q3mpAn4X2DYGTnjbUcQDpPuEEUfvgSvSti0bGPMv?=
 =?us-ascii?Q?msauVvUAmVgll/vtER/EF2hakA1lO1XDoPviYjCwMhq7/LxqegVru2Q64T7u?=
 =?us-ascii?Q?DNxlItTI5UVi1nw8OEf5qNRKkJlIz0DeZzF7qSDq8hIPoXpw2aCQU+BtshdU?=
 =?us-ascii?Q?0Zn6TF82S4LW7g5U82GY/LZOd5IEGHY2g/fPodtk5a53VvHEsP8j5j8fSPsv?=
 =?us-ascii?Q?3rnQB/5NUEgtQ0Z67GAktqZ/F4pCDlnqIeTP7Camdw2T+arJwHsdLObBptda?=
 =?us-ascii?Q?B72kgZqktI0jQf/G3KzBPveUvYdlJmDZSM+lrGY/i58jJ/8RPM75Mdp9mCpT?=
 =?us-ascii?Q?ZbTcZwTN6UjwYZT3HiApp1wkB6xTK7R7+qc7BTVCC1wTFLNmzbi4pN545lHy?=
 =?us-ascii?Q?p9Ac8XpvthOMVcRFSc7q2AfrGO8a6ewS9RwAPXjuhiyKO2tJyfoqRv5pe+bE?=
 =?us-ascii?Q?S3QtEWrguK52hROnsJxcscj+v0wV4NnUD3hDbCbarl//YRkljCutQ82z2Fzr?=
 =?us-ascii?Q?U0dj0RqHkA+8FnrzKF36xzwPgBat1EBsUvStWBuPydRrLBkLh+sXcb478m2v?=
 =?us-ascii?Q?A03I3zOu9lKI5g3j4q0qxOOozJ04zWtLaHQyfp/myCBK7t+dDYgZlMBYkpVd?=
 =?us-ascii?Q?EiZkRT/KNEAr1YwTf9BbsHipQMgCYGaixd/wsI2NTGvOlU0uzSf1ZYfOKrZ5?=
 =?us-ascii?Q?ozzeV/NFnFlNae4BeRH7YxDxdqa9cgb77uOypel+6721aK0DU/KyAr5zheQV?=
 =?us-ascii?Q?t0KbfgTuvCuzcdzBofmvHc5oWOCjU2lwZ5ecDZjy/Wh7YbDX2BR4tEkP5bne?=
 =?us-ascii?Q?eB9gaw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc37cf13-3dc3-486a-2614-08db521f1bb1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:56:16.7445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KjTXO5vOcyKjgCOgG9nZHaZerQhgZwev+zVF/XOkiaYKoCDzzfYQBcU++G621erVSJSeT5XCQkYicI1liyUR52ftCNDf9ffbhxSwFHSZ6AU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5136
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 03:21:19PM +0800, Yang Li wrote:
> The call netdev_{put, hold} of dev_{put, hold} will check NULL,
> so there is no need to check before using dev_{put, hold},
> remove it to silence the warning:
> 
> ./drivers/net/ipvlan/ipvlan_core.c:559:3-11: WARNING: NULL check before dev_{put, hold} functions is not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4930
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

