Return-Path: <netdev+bounces-572-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A2316F83A3
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:16:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1727281067
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64D0BE62;
	Fri,  5 May 2023 13:15:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4677156DA
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:15:58 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2125.outbound.protection.outlook.com [40.107.94.125])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45326203C6
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:15:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KaVREby94fquaVl+jntH/fqf8YSSFI5uJofYT8JYAdcOFvXq0Ch7vP6fDfQnGU3l8pN/7z6aM6gjtNNWSWciVh39C0fVHe83g0Q0UZzkPtdzPFrg59cDRccdKIaGI2Rl1HZ+ztmkoT3+T2xwUJz4HUj40CWVDSZ+CGg3P8Lv9EYKKRBR9gAbbGfFNjMBU52S5MPvxAfDGulADkzguEL3SM7GCvDi9rl7tRVINg/+Qj+Y9wAmfQ2Ex8IN5bvUkjxcCK9ILEq9tKJlg+6Dbt31xZMFnsRVKVKAELToW5iBfu8hALTchsY11zU+Vzzb3yQcUovxQr/lXgR6mK8HNWrttQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDE1D/NuWEpxE29b+9DULY/dx5Sgc7NnO8wJTZv0knQ=;
 b=ivex3fOvqb3V92V87M+Kn7WRZC+sk6g7y1OUSTxdbqLPRqFJIkk8cVmXtwqMcI6fr9TcWLCB5WqwLMfr+ISIYTUBguXBIOsbmQuVMKvgSJy+JS+9+nWEDoLSzn3G9ju4ZeWk8DYQHqm2jwqQ99a0awTohEaKo546VX9IZptba7XIEwseSnGw6MbYRiQao/AYZMFaEsYlf0tv8o8viziqpPbD8kbCSk3HALEoLLC3BPId0tU4QX3xmcuOFo2xSlkRJNv2RKFj0QcVv/VirhGJOeIYcCI6m67Jh2PsEzyUSq0Zc2QIszEr5M5t9gfuE8gZPXo9XSqbHLh/iozsvjW1IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDE1D/NuWEpxE29b+9DULY/dx5Sgc7NnO8wJTZv0knQ=;
 b=fXMvS/5xrsIEN2sd6Oz82nSgacWHxhU+500l7IFk5mhz38q9aVdWONytAf3GQ+9imazT9dzMb2gcQ+FPhstUAUcEwWxnYT2VNaypL8C8fi33bzGvOGk63nooFxKn5SnyzbP4I32ND8NAqApWdHBZ5mb8V81b/k57Uq7p5mj49l8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4555.namprd13.prod.outlook.com (2603:10b6:610:61::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 5 May
 2023 13:15:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 13:15:44 +0000
Date: Fri, 5 May 2023 15:15:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH 2/5] net/handshake: Fix handshake_dup() ref counting
Message-ID: <ZFUBe016EUW+bwyg@corigine.com>
References: <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
 <168321389545.16695.14828237648251844351.stgit@oracle-102.nfsv4bat.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168321389545.16695.14828237648251844351.stgit@oracle-102.nfsv4bat.org>
X-ClientProxiedBy: AS4P192CA0005.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4555:EE_
X-MS-Office365-Filtering-Correlation-Id: 23fe41c1-ab4e-4d2c-ff42-08db4d6ad536
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3/HetVm7NIq3mXiwSlMxweUDS7Z9hthFmdDAKwilO4WP2s3P/BV0A8XMxZA4yQZLeGWnTPNnPBSC1PCOCusoE4ktl2OJk0yh4YzGFzGYHjh5DC0gsSf76Bx7bt0pzxuoQdV0IWcZUjTPQDSnaK841V9Z0ru5ozgyU+8QfdW7OZlepeseKBlzJSPdI13e10nnpzYgoMB29JfZbQqgWqETqv/2OaElgHNI5Z0QMc5aL28338HEwEcaQOmIBqFBBYwXEwmeLaB5PTz+R/ii1YH+0SXNBoE/a9cLRvK+X3qMAQU7d1m1NP9ebebLhkvbUwoY9yNSR71VbS85ynMensCJI47AHMtIyAI9eJjRjoWGmo2MicZ1AeOc9us9r2PxfuzKpxsPF+hLOi+7DCB5dB3EwTZC6Zl9fQ3cMfZy91FR/ISZ6Wcmjmbd9vSB8u91hTyzLmgZtIDOjVMeEvRHlIbzonO5tKp00Knan8bmPiqzYNGAaI4PmNWfyBqZ9HXQD1c3M9dUt+9gae5D1YJecY7bi1zPHB1r+wxVSbGW5ilu6zq9KmF+PnasFMWbzxokCge1FK5l8aY2Abq+vNJdw/XQvoFhrcBk+XbTDW2F1pDVebI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(376002)(346002)(136003)(451199021)(2616005)(36756003)(6512007)(8676002)(41300700001)(6506007)(6486002)(6666004)(186003)(83380400001)(8936002)(66476007)(66556008)(66946007)(478600001)(316002)(4326008)(6916009)(86362001)(5660300002)(44832011)(38100700002)(2906002)(4744005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7piycJoww5yPqdgJ3AxHl9TJgkrtKIJTAmH/Tad9Pq4gr9LOf40X0oF2Ph+t?=
 =?us-ascii?Q?HO5l1UbXxcm8Xjr0RYZa/rasniT09boBSJErUgCvLow4cae/rd0AhsTxd4B3?=
 =?us-ascii?Q?zmIF6r7b/dO5QP7APD5TzpJHOM1bJe7ENzOWPUVFcrHvXtzjdbsDso8MhJXE?=
 =?us-ascii?Q?UHf48qVJlosWb1EI0z69xzb3a5Gdn1yhUrRCa1X7OZdZGO3jrQgqnNpteaFz?=
 =?us-ascii?Q?T0b+H0snfd2JmYvP7yOc0P6Zh+OqxPUrrLZrVZsrXtyG18c5cZ+DfNhxI8iD?=
 =?us-ascii?Q?3TWWf70yLs23awjUeq/PhYTtckui5ultIRzd70TwT3Ru/jwMAe4jNB1SyD4t?=
 =?us-ascii?Q?makBra/wM+mpwzxe+SD/6/Vbz7xWfPIS0LaUMBU6QVjXq+UJoIfyd+DoZLZ7?=
 =?us-ascii?Q?G6EtOsGtazcQzT4cTh4+PuD8GNcM2gUHiGkw7FP3V7L4MQuriInGnH9nzUg3?=
 =?us-ascii?Q?NhJ7v+98i/qSakOz10zCIf5/8dhkFsr/AZLdCPSI8hEZGZ9MGbEurzSj+4Uc?=
 =?us-ascii?Q?bKKSlbWEo+QqbrekxG7l4+Uc13qcNiEj+t1AYnBY86A/oieDvapdSua3ysFV?=
 =?us-ascii?Q?APn/dy6qmPuW/4SStHSNw3uBVHsug1XVpuHl3SpLgXQXfNA1rS+SVEt5dHty?=
 =?us-ascii?Q?I3n+27RZkZU3TCgc6sxpCYebW+T6El2otz6EZ0JW6G6m3z567cZ+mRDPi7Z+?=
 =?us-ascii?Q?qZheP5kmJDhCX4qy1EVRu57vAPViMkpkxIFuxp+Ycrppx4nnpe5qpfznuHNs?=
 =?us-ascii?Q?kUZdB905+3B6TDwMjyqWGKllgT2bpJA9p1w+tofOt/bbKPkxiwkqMq2Fwc9V?=
 =?us-ascii?Q?A09idRcRFYeauv0ECdNLoa9RzukUFnjef/aCWl1QSHP6pVKQwYR+JycvP5Gr?=
 =?us-ascii?Q?U6cy8KjtXJf97fNZqUSdjDSx8QuOpzRM0tvFPsZr0HPOfZnGBjs/cnMI6oH9?=
 =?us-ascii?Q?ovGcRFKD2Wwhz4CJCgK5s3JqeFfufR1VTAR0TBIIqw+bTrd3EOgTUvoKr4JO?=
 =?us-ascii?Q?f+J6F+7CUaayeKvwHzzt1SNee3k609HXCL7ua0TJEM2oJwo4aidw7i0ZhOU/?=
 =?us-ascii?Q?T0odO1AaDl3olpbAVw+7wxgWjRp6+i9AwHN2u/lrdtaEOhC+wnMxQUcgPTWj?=
 =?us-ascii?Q?A+wZW29n2Hk24qwIKik+ZTzemdG6ooM/zEKE6LZCMSM8dSIQDSZ0OKVKNLcO?=
 =?us-ascii?Q?gFx4HYKKhbIduznCmGosM5Z2U9szfwo1m6S/Ams1XPytcUueUhd3idiWiOvt?=
 =?us-ascii?Q?7nv6kfhTAb1biTcw0MGxc4USawwRhTezwqjKW1ZNFrHBTdtc/HTWX90jAmFy?=
 =?us-ascii?Q?DUuE2Fa+4U8ucE9ecyByDduOHC9bBF41HOQQAIhMFT0cnOYuUjD7ut/7OsYR?=
 =?us-ascii?Q?Zg6I7o0NDt1/SItsd5842Tx/wEHXdvm3DnuAyhyC2Dctxk101LyNZKOJzESt?=
 =?us-ascii?Q?7pgQr0EyVgjLgvT4qQ/BXLXksKXdS2UG7pmQ4q2H7YGcK5UfGX9tGrEdnzVZ?=
 =?us-ascii?Q?SGYJhK/TfflOsHfsEbihFQOYDEFqHaSp0Oiy/VeyiyyzEAlRjJLUnQJuxzMN?=
 =?us-ascii?Q?rv2QhrtxEZs6bo+Sgf+Reo/fa6BPyt08+xB7E484HwHrS3FpHfnFK9//iXbO?=
 =?us-ascii?Q?yY4OpOv4Oj2SaCa7HQ40bOwj9tWMlUGi2ERIi3ths1NibKF8BILwNSp4KE+s?=
 =?us-ascii?Q?Dl9SbQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23fe41c1-ab4e-4d2c-ff42-08db4d6ad536
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 13:15:44.3373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YguZoQ7/rNJQwOuup1pU7hO0mV57bOHm9ci09ciLD8rlRnJ4gWKHWaPugiHSfMWkfjJd2B4SgzFjrMPDvHCUCCFRFN9qYShhK8I12A1IAkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4555
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 11:25:05AM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> If get_unused_fd_flags() fails, we ended up calling fput(sock->file)
> twice.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


