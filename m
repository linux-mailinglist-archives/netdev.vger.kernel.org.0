Return-Path: <netdev+bounces-8887-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46AEF726300
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A64981C20AD1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756F114AB8;
	Wed,  7 Jun 2023 14:38:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B56C153
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:38:49 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2110.outbound.protection.outlook.com [40.107.220.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C08E1FEE
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:38:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQdExcDRbSqXdVF+TebKRAk/cj2AgsQTvxG67ljFWfUK79FA2Zok+KpPLMENJvXPWC4KdnkIKpDTZd3DSFz6w47cjtQUsOdreU/AOUME0/gJRLwNDAWALl3IZ5vOn8cuKetgJG90wx5KdAO01wuECWOck49ZP1uYQidAJ7W0I44blDO3SqahHAs3bYfa6oPWZYVviwAdxEW9gcXduVMXYWOjydZ6BMQq9UGls3SzGUIaOsAsE1CKHVReojIQrB/gQb5Mlh71MaNhNhA3vwuDTXgykEduwVgIk0gRnIuh26uVjqf7QsFUAVPydNtCkNA/E+1rEVxaAsPEnv5vimjA5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgleuzJbh4tOEm0RXAt20+jh6ogqL6xgF4u4KOPcbYQ=;
 b=f5cVOrF/mAm9lPlIrYBi3r3MFZ4DqVlhA/Ss0Zq6+IAMGTW4bICuqSZjgL5h4nb2AEHQnOMQinxrq15Fb1G+x4NBii+SmeqabIsN6pIsdX5ylaiR6odX2kEqewEY7YiluDo5PABT1r+UVpkdiwoBrBV+8Q2XG865DE6OvitSx2DB1foU4Jotea2OLBZoktMHWOrTpLbMObMBMm75WZtVhVXmjKf3CF7eOz3SG8/u8ZZoOMjR3kIkRVPXQG8fCG8VZeyJOKDO7VnsrqHWcExlHabIEU4XPcTeaLkmzIQKO8GhPIT9IkQJRzlzVHSoplqkP/FONYJ6zEVYCscxq4BH+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgleuzJbh4tOEm0RXAt20+jh6ogqL6xgF4u4KOPcbYQ=;
 b=rOgOEKOHUPQZG7NFirvunntsRKVE8KJFO4UmPI/8qTKl8UtFRXIld46+QOJ9bXmOHkDtA+BL3aCoTuXpN8rt4sJqYuVb+37UTAi47G5drdLFW5ydN0iWFgkXGaE6E/0s7lHsm7CmEHmF5b7aFZJ6uz+65sz80IOF9GKxwaspbrs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH0PR13MB5330.namprd13.prod.outlook.com (2603:10b6:510:f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 14:38:38 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.037; Wed, 7 Jun 2023
 14:38:38 +0000
Date: Wed, 7 Jun 2023 16:38:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Michal Kubiak <michal.kubiak@intel.com>, netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH net-next v2 6/8] net: fsl_pq_mdio: Convert to platform
 remove callback returning void
Message-ID: <ZICWaIRf/hwOHv+F@corigine.com>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
 <20230606162829.166226-7-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230606162829.166226-7-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AS4PR10CA0027.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::17) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|PH0PR13MB5330:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a4fa96a-2e0d-4730-032f-08db6764e185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZjYPr4beLaWMMk6zKPGwznQjzrZmYqlSymO+0EOIHf8kjRCMehEN0EtBWxxGyo4uS0ay/fNVm4u9VkLWiPihnXFpWXryyDajdd8MeB2ALoRh3CW0Err43oiv0H89D+Rx9rsFdazSyk0EE+X5uEBKFGLOVkD0R55IUJ9dI7Hb5RXl0J7X33J1iTBGQCd4qAsJ4FcndlBCsRB7473WdjneFFcbUeEn+U6PyBlicWTWpdwRQWdfVf8AtWlRo4f1JkVQ72TAhyy8cHLimwOJ64fSu9Z8xWknxEE4vpAn9HlEOR400nRzjUmeMJfjbcchl20Bn0hpbHq4hk/cmIkJTsnDl1HxfbNyGxwAci655OPRtEDb5L709k8SIQvkx3eEjzPVL6XbUYN98I+idDEhO8uypARMu8j8MQRz/srI7BT/zKLfEe7KOkjwKf4u2Elpl1nBHTwRleX1MSBopJ45KRp+Zp0cx52zlyRPQpeJ7bJdnVWNT5JEl1EFjRdSmmsbiUbRdAEPeGGKsDfYfLjeECx9Niv9TpyoxnpdBmxH5W3lWuDK1GywnbrQBiGIjKHbZXcDgFUfEAWmjvPAbKN5IWnc0wYiIFtso4/Eudl4921i2wo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(376002)(39840400004)(346002)(396003)(451199021)(38100700002)(6512007)(6506007)(36756003)(86362001)(2616005)(186003)(54906003)(5660300002)(44832011)(2906002)(4744005)(316002)(478600001)(41300700001)(8936002)(66946007)(6916009)(66476007)(66556008)(8676002)(4326008)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmZ1eG1EL2k1TytabzFDS0YvWTlhdEVRK29UYXFHRUpiQWFZdFoxQUxqdlh5?=
 =?utf-8?B?QUo1M1RMOG5xb25kd3RZbEU2VzZzMXlqK1NBTWVDcU9wei9pNlFzdFBXU0dS?=
 =?utf-8?B?c0ZsZlAwU0JTQlhSdTREY0pnMENuajFCQXFPOEZxcEVxUDNLdTJZdnppZWxa?=
 =?utf-8?B?ajdpUDB0V1VveWRudzFUUm9DVmRjOXVyWlp0bzVMR0hjdkxDU05xVU5YQWtD?=
 =?utf-8?B?dlUwWldTdFp1cGl3cWlVUCtiUHNGOXB5WHZBUmRwK2VNa3lra1BvMHBIUGZH?=
 =?utf-8?B?VlpFbGs0N21Fc2dNUnc1eTBtSkZnbjRIUHNBa3dSRExwVzBKbnhCL21NSk9n?=
 =?utf-8?B?MjRIVjFJSXRHWUJ0QmwrNXhRSE5QWlorOGExd2wramg2NGthT1lNelU4akpo?=
 =?utf-8?B?ekhWZWZ2Rk10N2plTGV0K1h5Q2R3eU1UQkFWSDZUQ3VsSitJTUg4L0RGZU1B?=
 =?utf-8?B?VUNSSXFZVDJVV2RqMmR5clI1R2FYd3MwWk5DNzUxanozU082VDBHSDRPRzV5?=
 =?utf-8?B?Z0Z0NXNpQ2gzUkU1bjFOMnZ4dm00NlhlWWFONWVjTlFmK3dGbm14ZXJ6ZlVI?=
 =?utf-8?B?elBCNWhQR2llTGZRWnQva1VDWkh6SWxwTXdRT3VGVklmdEtvNTB5TTgzK1VR?=
 =?utf-8?B?VCtDUEFubjdFQWNjd1VXd0ZjS0hjVHlEZ0VpVVFvejMvMUsxTHhaOWNsbGFR?=
 =?utf-8?B?M1VCMzVDL1RzYzd6NHIxNllwUzVuTGdVRDIvbHM1WU5RNUlmTFJFRWFxdmZS?=
 =?utf-8?B?bzBMbFpBdkFONE9Sc2t5YWhPdEhGT0ZkdUkwaXVmYnBSb2RybWZ0Z0JjeDRv?=
 =?utf-8?B?SVRENDR2Q2x4WkF0eU83VTFsVnowTUhjWkxwVU16RWI0dU9jQlVLc0V4R1F4?=
 =?utf-8?B?Y05LaU9hNGxGcG5iazF3R2JBWmp1SXNYMXFGY2lSN1c0RXVNUnJJUkxlTHpP?=
 =?utf-8?B?MkhvcWJlT3Nad2tCOFh5WmxVUC9IQzVEM0hPbm5aY0V4bGU2dnBJVk5KRTZK?=
 =?utf-8?B?MUI5U3JnM05uRmZuUzdFZzk3dk9IK0t4QmgreDJHNklDaE96N0FHUFZ5MzBm?=
 =?utf-8?B?MVNVOG9jSG9WREF0bE1WUWJFalBYQkh0djYrQXdzL2JOZGIxMDlpcFhzNEt4?=
 =?utf-8?B?VjJPOGVRVUxVQ1RaOE0zN0EzdXhXQWcrblBwa055ZnFXNUJrM05OT0RjZC9a?=
 =?utf-8?B?QlBNMkFDTE5NcWw3Qk5iMnVXMnBaMFZQQUZ6aFA5SnFuUFllYzhPZTNYRDZU?=
 =?utf-8?B?dk1xRWptZlNSTGt4MGpjeCs0MlpuejVZSktFZ1hoZzkxUnpocm5OdTdHbXFr?=
 =?utf-8?B?bFdQMmxuMVhxUGl1MkZETGxnN2N0WXM4cDNQUG9EUm1teVBTUllBVkNsQzJp?=
 =?utf-8?B?Y0R2QU5nTldFOCsrN1p6YWZQNW1iNzlwdHhZS1RBVEpCdmk1OE5TazNOdG9G?=
 =?utf-8?B?SGdGZ2JUVFh3VHNUTERVM1IyNXhZUW0rSjZLME5BQlpiRUpiRkVrdld3TTg4?=
 =?utf-8?B?aXpHbFhkWE0zWUpJd1BYdVFHNFJtL1EwNTdvcTZSWHh0SVhRZ1JXdGpyWHpM?=
 =?utf-8?B?V1o5R0U5bTc1UFd2UUxIZXpZaDZISS9ObnEvakU5L0lSbkRuNVk2QU1Kc2VR?=
 =?utf-8?B?NGxaUi9aS3JTZEJUYnNzaDlhRDBPZDU1bzNPWERadGFBWXRxLzVBSTd0ZnpO?=
 =?utf-8?B?OGFySVkvUHRsLy94WE5GZzY2TElIOGVQNU9PMU1CaHUzNGI2bFVGYTBNRElJ?=
 =?utf-8?B?ZTNnMHh6MS93T0ZEK2N1amV2Nm5jbFBWa0dIOHJHWnhXOTZXRWtjakF5YWRT?=
 =?utf-8?B?YU1wUzZyRmxGTFlSbTlMeEo1QkdLd0xFZjgrMmNlZ3FGLzlVZjZKRHE5U0VU?=
 =?utf-8?B?NWQyOVQzMVU0cGVLekgxSlJuYloreDdNK3Q5L0pBYVhrNGp5SUhZYmlLRlkv?=
 =?utf-8?B?dW5EUDNDdDU3R3MyZGtYRWVsdytnSDJKeEdkWWRxSE5OZTZFTmZobjVUNXNI?=
 =?utf-8?B?TzRDcnM1MmZlLy9vZVo0czRTNG9Hb0lQN080Vml1L1hFY0dSQUQ0eHVVQ2xD?=
 =?utf-8?B?WVlYSmNvRzN1emtUZFd6VWtYYzRWMTAyc3BIOUo3cTFvZk9LZDBZQjErOWFR?=
 =?utf-8?B?WHZVbmZCaWFZQ1kzUzJIa0tqcElWZFZRRXFCK3d0S3lGTWpjWkppOXo0K2to?=
 =?utf-8?B?dXlEbEJHeWpoL0l1eVF6Nk1rZmxzV25JVEhrbE9yTXl6M1VGbHJscEJSNERi?=
 =?utf-8?B?d0wwMU1SWFNYaVhNT2o0ckVoM2RnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a4fa96a-2e0d-4730-032f-08db6764e185
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 14:38:38.2539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdpHinWxpAgr5SxzGToJLRq6wLeJ531W7cxtfiLV5Y6Ry6QPz+Gcev2RJgoUbU/eh/hUiatxFO1NKAgUASAjOurpkqJk7E8+f/qRaQZPIik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5330
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 06:28:27PM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


