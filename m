Return-Path: <netdev+bounces-1730-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06AFD6FEFEB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6E0428144B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58CE1B8FA;
	Thu, 11 May 2023 10:29:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07581C747
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:29:03 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2112.outbound.protection.outlook.com [40.107.223.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A35993FF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:29:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anMuk38rUIdM703nWHIqQQiUza69t503JO/GLybc7fRfsSE1S9IvpeCUlxLBzHgXnyGtzNWz4OI+S92XJw2WePeRhVCmiGzcJ8bbKnYgT+aLzZMXm7BKtu94v8dxrPrf3RWA8q0ASnRgDU7ox5MpswjGZx8UtKqEOC6o773In1ObZB/IPtUcaK5lsqyJc8xC6YLFtnTGv89V5GhRR1wgsK9szGzrZ89ghgEggEYxlbKlB+Gonau35UNPbi5QzXtbumbvnSYuqzv8HcGmsfRiU2H4/s1BOGUESc7u6kXjc26b3vITZnxOdPGQC3+HWkUsUAMhqxgHq29W2kyCxTOSrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEn8OUetVDQ8gAImd+cggu9nkKeuV9yHOtIwr/mJ1aI=;
 b=jReX/S9wd0M39t0imZ+7nkmA/KZ2DtrcZ2/V4ki60ZqO6Lybpctcv4TAVG58mNJ8iaQArQB0+upw3Ry/qmpnU7rw2OC2FjUXCidt1OT/oyPG78LJvkYefEjdqJ0lfasmTKxg9iCvp+dTdy3+H5UWTOCmTFz7b65D0jDv9+hYvpYixAvYnAr5BrEFfzRq9rmDWN6Yc8MvnJ81EZljUn3jDF7+fdh4u3+z8Ps1NjpZE1WZBbgShFlQJGcKafYD285xW9l+sRfUumaOrkg405OCeZ/wa2ccsOO/RMLYo970pdXUk9ykS9kPi3PUUDR4MEb30n014GWMKlF9/jyvpgQIUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEn8OUetVDQ8gAImd+cggu9nkKeuV9yHOtIwr/mJ1aI=;
 b=QWPxbUbQh3lcjgm5zfCrKC1SmawWRQ4qnUYxKvlWyHuF5cOB37CGKpvBehjEo17AShycuovBdHNf3aoa6tHsFZzS5W6Znrn1MR1/rzPK1VkCAufJU8ACbhGXf0j7zhooJ1dgqVT4Xx1KWJ/COcaB2hchQXqJivjJek22Vlb5cc4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4727.namprd13.prod.outlook.com (2603:10b6:408:127::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 10:29:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:29:00 +0000
Date: Thu, 11 May 2023 12:28:54 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Byungho An <bh74.an@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next] net: samsung: sxgbe: Make sxgbe_drv_remove()
 return void
Message-ID: <ZFzDZhOSXuJ2Yg35@corigine.com>
References: <20230510200247.1534793-1-u.kleine-koenig@pengutronix.de>
 <ZFzAvXjpr4t8LLCO@corigine.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZFzAvXjpr4t8LLCO@corigine.com>
X-ClientProxiedBy: AM0PR04CA0026.eurprd04.prod.outlook.com
 (2603:10a6:208:122::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 88827811-1b30-45ff-b084-08db520a888d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TLU69gC7M//VKCrwFN01ySJdBLrAJh+t3xi9OJCpH/iKnQZTFZCugx7P+Nq6D+6ldlR6hZNEooVcsm51z3q+cjxRFPyqC+LpuYG1UJxMasPnscIZvcn5vNbfLfPVLQmYtYbEqC9ZBCtNWUocvyKksCAlXT39OM1jtxTz/Vf5ity5o42Rgfh9a8s6ycutHdAkiCEMAQfr02xO+ft/11FkL1Vrd5Q3sFgpSSEkdcm99JjLeXA+l2cY3or7Bnc9QL0GKNM1hYmM959deTDYa3DFUJb9cafOcWRQ5gAKrQNE2Iril5TMgzpBoc+wjDzBTIETJKh+Tu5PcZG5PGbf8RcCW3YqESZCkF3WZFUGnc6QAHVp/xakOqUrZ+U2bSVCRCaK1w4c1jDssbgj2AZTtQqAfNAV5LuEiHxE7rgR5T6dqwmgqBMQ0cRCVk0/dzRvm2jYtz42jY/J0eHmH9tyQWWGg9Pky1Yi/yuAq7q41XbPDrxudsUSNvQE54hSA09C/blRBk6WxNveS5DjX68XdCpjl8Wf1/rqE7t/SPwecEo55HMLEfTYRF8RvjMWKvasHzS7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(366004)(39840400004)(376002)(451199021)(186003)(2616005)(4744005)(2906002)(36756003)(38100700002)(86362001)(6486002)(8676002)(8936002)(316002)(6666004)(41300700001)(44832011)(5660300002)(478600001)(54906003)(6916009)(66946007)(4326008)(66476007)(66556008)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3FGOURTclNTNWkyandhQmFYRCtMOGVyR29VcFlISFFkaFdaTjVkVE1zWHpz?=
 =?utf-8?B?VmhvVk9wTzVrUUxPU2J0ZlkxRHp3QkR2NC9IWis2Sk5Zb0wwWDE2cnErRDk3?=
 =?utf-8?B?WTRJam5vSytSSXNnQ3g0cHVXdzNKQUIxc1FFeUtobjVMUkJjak9MS2hPVWRm?=
 =?utf-8?B?MTVvT211TkNQM2FjdzhrMkJtV25FUW9ERVQ5WC9XQ1VhZzZFMDNKU3JWc0Mv?=
 =?utf-8?B?ZHVRWHd1UnE0SDdrNUEwVnhYL3p1bTE4MkFVK1JQOTZYMWlYN254SkdIRGxG?=
 =?utf-8?B?SHJMYjIxNzNnZ2dCZTE1WkRjYTJ6RytBVnZySjBvZC9xWkVDNk95dStXMVV6?=
 =?utf-8?B?bEF1RENJb0JjUHNXUzkveEp3bHp3aE5RLzV2QlVMTmJwaE44UFUwcjQrQ2Jh?=
 =?utf-8?B?MWl5NW1nOHd5bEUwdktCMGFsWm1qTnpodFEyWHpSY3drWEkvOEFpSzYrcnRC?=
 =?utf-8?B?UU91em5rU3NWSHdSSGY2cWlHUlM4ZFZDV0NMSHJlZTh4UlF5ME53Q0dJTC9x?=
 =?utf-8?B?K0ZQbnR3L215VWV3YXNsRlVIT1gvU1drOEhXOGx4T3UwU0tzZnRNZEl2a05o?=
 =?utf-8?B?Q3FHaTR2Q3JKL1dReEtVNHBkMFo1a2RlYjRYRFk2aTdVSG1EVW9kb0hJbEp6?=
 =?utf-8?B?b1FsT3hzU1psUXBnY2U1Y1NCQ2VjS285aGZSWmpWSmd5OGQwUllWYjR2VEQw?=
 =?utf-8?B?cGU2eXhRK08vNjM3YzlGUnYwWjdHRFJNdG5mTlRRK1ZGVGZzSEswQ2RVU2JE?=
 =?utf-8?B?VzVPQlFla3E3aVBwS0tRQmJydjJVK1dtbEdDdUJqODJ2QWtXS0xVNTJ1NWR5?=
 =?utf-8?B?OGhqNUdSTjk3aHpPT0xLLzhuTUlNZjhyMzl5TStpY0NzL2RDSE0rVjVTVmN0?=
 =?utf-8?B?c0E3MlpNQ2JRRjlocllYUndiYjZmZHRkbGRsL0gyZ29aNWpSOWdDNWpjQTE0?=
 =?utf-8?B?SlZtczg3TmthOEp2TVhYQzQyVzZ6VncvVnBMUjVWczB0QmVPWlNsT3B2OTdM?=
 =?utf-8?B?cmFUSFNlOUhxWll5SWhMdkZxR2x5SHp2U1Z3d2JKa2VzU0tPdUJpcnAxbE9S?=
 =?utf-8?B?eFFrQVZnY2NKb09aUmhaTW5HRkZLZlhYSlFTMU4zOGhablZwb0piOWROTmVE?=
 =?utf-8?B?TWViOHVPakEwRTB2a0grZUZDak56bVp0a255SnVOZWJ0bnovUHlOR3pGK0VL?=
 =?utf-8?B?S1BvY2xVTGhobjhKeGNqVjdaNnAxQXVBODVJNWFrc08vTGxKSzdCMmJ6VW82?=
 =?utf-8?B?WGthbzV0QWxGSXl5VkFPZDNyN0FpbXlzaUROeExYR2FDNHYvM1MxeEx0UGZi?=
 =?utf-8?B?V3Z0Z1lkWDU2OTREN0FjS2xyRDVNbWlGK1BSeVdjWlhVQjI0ZkVFclNtNjNt?=
 =?utf-8?B?VkIwZ1Z0ZXlBekhSSkM1MVRDdFFvNG83NWRUeDQza2YrdzYxRmFKeGt6b1FK?=
 =?utf-8?B?WlFpTXh1SUxicHJ4YUIxTENveTZHbkx4K3FQTE9aUkl1RlQ2dW9pcXdIcEY5?=
 =?utf-8?B?bm1aNEp4c0JxVkNOU2ZXL1cvWVNkWkhJd1VsenVEZjlUdzFYbDRqRFZjRlBU?=
 =?utf-8?B?eEFEdUN5NDdkd1pYZ05CTUlnSXlsTG1QNXh6aW8rZXpvcFo1cHNqckFNWW4v?=
 =?utf-8?B?bXVPUFNiakZMWDArSlZ0WmZpUjhoOTFBYnh0enM3cUhZbjY4RFFKYmhRUWs2?=
 =?utf-8?B?Q1ZadzhNSTBXYmhlSGI3czRjcVZCMWZhdk1ILzZ6TVVUT3AweWlPRzBPNVNl?=
 =?utf-8?B?R0VBb1RuczdYemZLemlSUlhiYWJPcDZWeEFRcFlvbnlteENWNmJ0OFBrcGk1?=
 =?utf-8?B?UFdVdS9nUHJua1N1RUhwR3lMa1lFWGJDbXlNL3hSZk5nbGdQRHRVdGdSSmlB?=
 =?utf-8?B?dFZBcnkySnFkeHFqMnFkRlRjNDdzM2VkVVZuMlZmaWZMa1BLMmVTOFlBclhz?=
 =?utf-8?B?K3JzUklPMkZUTGowRkpFSkFJNmgyNE4xOU5ybjl5THEvNkUvVzVqSkxrNlhx?=
 =?utf-8?B?NHpCMXVJK1R2TWdrRXJ2QzRlanM4dkFSR2FkcWttd2xsek44UGpOK2lSY2F3?=
 =?utf-8?B?Vk8yanhiUEc4T2R4a3lIRFVlVmR5Vmd2cXd6dnUrczVZWjJQKzRRZzVJRk5y?=
 =?utf-8?B?YzVmQzBybFJrQjhrSGdyN3FuYUt5aVBVc1grSEZLUVIwcnRqRmdJbjJ5elpp?=
 =?utf-8?B?TCtpd2FaYitYZkxCNm4rQ3ZyZXZhdXVCbG9xNjVMUjFMVHo2ckxYSzZ6RmxO?=
 =?utf-8?B?djFzYVJLdTZMMUl1Sm4wc01NNmNRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88827811-1b30-45ff-b084-08db520a888d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:28:59.8794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MG7TC7xEpzBDeZyPrnDJ9ewWaef0x6bSq94n3eZufeM8YUcmMFMCmJvpexmtwFWzf45UWQ/SHtvm449eRSX6kqNFazOtGBGkKxI/R9pVdEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4727
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 12:17:40PM +0200, Simon Horman wrote:
> On Wed, May 10, 2023 at 10:02:47PM +0200, Uwe Kleine-König wrote:
> > sxgbe_drv_remove() returned zero unconditionally, so it can be converted
> > to return void without losing anything. The upside is that it becomes
> > more obvious in its callers that there is no error to handle.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Sorry, minor nit.
Perhaps the subject prefix should be 'net: sxgbe: ', for consistency.
Or 'sxgbe: ' because the 'net: ' part is largely meaningless.

