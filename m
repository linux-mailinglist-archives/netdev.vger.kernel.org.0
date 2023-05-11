Return-Path: <netdev+bounces-1733-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F3B56FF026
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A837D1C20F55
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 699BE168D6;
	Thu, 11 May 2023 10:52:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510C81C774
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:52:00 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2127.outbound.protection.outlook.com [40.107.244.127])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4817A55B3
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:51:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwvy+a/JixWLP40ZGcNaAK+lF39McZbFmxx75ujy1JbzNDmNXLdbTx82s1kUKqGplESl6V3j4Q/cGar0Dr6hiVqyoG6NUCF/nBfrWfpKxEjDjPsSyZ4Y3w553WTUV9j2akV85vTlx8/3Y3VpsxsdTaKYUPIaPrBHMPjgJUR/a1Tg4Sgr8IUUjd8JQlH8g4BQkDXi7k4Q3SYT5qfmtuN9saXNIh82Iyf8GVJn4XteRGmDnKfj0K3Ls0fkS0b0zdhJWYKCRPI0UJ9BlxegI772BvTddtu+XOSLepcg48OLqy+eEOcGPkzRdLQkSA+YNHc6apMQ5GsEBmGvKA5cQCPVZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mki0g1XtSlNBZYDBK4NgTEEII6NJbx0Pn0dEQHXprIE=;
 b=iLYA5AYZxijcNQjMuUmIPZeUvzmyBt39w6vRNuZWtwPt8sc8ZO8aFwcFoAV86IjY2dsCW9b2wJUQ8B+Xpmwyr78QwdHFxYtSnk/YwK2BrDAMxZfw29SaenmaSBGJ1t8pw00mgrXZr8IMAiS92zlnPFo8OQAB3hAQobkkU50x2ZxF7Z+w30M2X45MoTQOEIFDtfgW+YFcqXUf1gFLcqV40uFQaLS7JRaGYZtMdYGrHd7vCn5JdqWGXVooUeJoBC1N+8FRIMsINmaHsNyP1zv73t98rIm8tHwzjoOv//TWOZM3No/1pQDf2OAJ660WaRHN05SZCRzOojhsh2dfZO9kEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mki0g1XtSlNBZYDBK4NgTEEII6NJbx0Pn0dEQHXprIE=;
 b=eEcqrI/bBM4ywHpqSSoxvpvFro/7WM0omhtS4h+ClD9AEYdy6QnWjBM/g3eOBpmBYp+uM18orJbMlgLO9bcK0/4dY+tVPC/BW5Qx/sKMgx/1qevx3+QuTQeweHvsfYZRMjVXM3nQd9DxGGe973k2CPsV3E5UCRN6imgC3FnTWAg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4724.namprd13.prod.outlook.com (2603:10b6:208:307::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 10:51:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:51:31 +0000
Date: Thu, 11 May 2023 12:51:24 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Byungho An <bh74.an@samsung.com>, netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: samsung: sxgbe: Make sxgbe_drv_remove()
 return void
Message-ID: <ZFzIrLxLXwKdemyE@corigine.com>
References: <20230510200247.1534793-1-u.kleine-koenig@pengutronix.de>
 <ZFzAvXjpr4t8LLCO@corigine.com>
 <ZFzDZhOSXuJ2Yg35@corigine.com>
 <20230511104509.wllidoba775bldms@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511104509.wllidoba775bldms@pengutronix.de>
X-ClientProxiedBy: AS4P192CA0054.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c72371c-294b-4cd9-a60d-08db520dae0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Cbjtcuff4TuBSPFwHZxCyQhcaAYo8qEZy5l+K8AODMo8wIm6FoBlFP4f7txybs0RgJJleFQE7KBn5HFh07DzTl930lViNiNECSBWpVDu1aW8F1YAXeWFKkVXGM3Af5UvHsFJ4Va6SfRHN4Dgi0YIRquU+F9y37Ij2rnzN9buuUjktaB46mDVm59nCsmeBpTmgsPny9UJyjjxUtOLd+f27xD4d9E4cGTGBuddlsbU1f+kX+oHnAbPLs7dHW1xDv1HEz56C0Oux4tYXZRdZ7ibsR2aeIE2XhPWnmN4vODULHwP8rUqAHIVU4ZmF9GIZLznF+to7BCmtetpbdRm+05Dmq2Za8AJYcqlax3GoeBn/1h11dpvveEr0A5tBh2jSVp97CF2yHVkM9fOxU27IpHs6SBVGIaxtUXDDeewKs95d/MuYJ8zcxU9mDbCb2NMqEAMDkOqDlSaSX5rrhTxLLmaNjL4BJdCyZsv+LGvUOAFJjFP08xZaBoiKiz6CnAG+ZLkqFoC+/BCpAmzT8j8KO+s/yjF7Shb8lOqGhuXGKiKNI4oxImMIA7LLYad3kNotkwrlpelEydctskVAJNVvrp++lZ3V2fdZ3dBFRqlMWv2T20=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(366004)(136003)(39840400004)(451199021)(2906002)(86362001)(6486002)(6512007)(44832011)(6506007)(186003)(478600001)(36756003)(5660300002)(6666004)(66574015)(38100700002)(4326008)(66476007)(66946007)(6916009)(66556008)(2616005)(41300700001)(316002)(8936002)(8676002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGh3YmJjTkxvd1NoaTlETEFOd3hsaHg2UzZPSDlndlErdURPbnNoUGRrK1hi?=
 =?utf-8?B?TzU4d0tXWERScVJhRVhrbHM0NHRzbmRjRlgwY0FxVmZNOVV2NlV1S1ZLTUlN?=
 =?utf-8?B?UTQvOVVRUVlwQkNHOEVCVUhTS2Y2ZDZyeVlXaHVUVmR5UVdBRDByaUVqcWsz?=
 =?utf-8?B?N1NHNEdJYk12RWVWRlFUL2tKMUs3LzZCdllHdXNuMHFRdjduc2JUTWFtZHpn?=
 =?utf-8?B?Vzc0SGM1dVpNK2xBdTVKY2xob3ZIa1J6TzdkOTd0VDkwUFhuUnlUbTlhZkNt?=
 =?utf-8?B?WjdFTjAxdjMxVWlHMTE4VThGTE5Ud0xDRXI2eHVuNFBia1lZbkN3WUhYeCtx?=
 =?utf-8?B?cmhoREIrUUkwWTVwZWI0QkdEeWtjZWREeEVFNnFYeWhlODU2eXZyY3VWaFNz?=
 =?utf-8?B?YVNnUVlUVi96M1JkOTJZT3EyZ0xvY0ZFelNNLzBWaHlZbXQxNXQwcG9pbis4?=
 =?utf-8?B?RUpuMzg5TVJFcHBpZGcrWFMxMEs2Z1J4aDQ0ZEU4OXM5UVF2TVpEeGZnN0h4?=
 =?utf-8?B?cURtLzNXZlNHU0VRd0NFK3M1aytVMTNzUkZtQlBmUVlBa1FIa0JIOUxtMWZl?=
 =?utf-8?B?SlBHOFFjZWltejhXNng2U3lZZG5sSUR5NWlCWSttUlNKVVp3VWFENVB6SDRO?=
 =?utf-8?B?dFZGK1Y0cnhsQy8xbE1XYUJaMlFMeUR0SlhpTGV5cVRqRWZHbUN0Qlk3aGJz?=
 =?utf-8?B?bWVuN2krQnVGQ2s3ZVBQakh4Tk9IMUF6MWFwbWMzQ3lCN3JvZDY1UlFuRU50?=
 =?utf-8?B?SVdxS2FqODR1S2ZDa01YeURZZnZCVHpCVlJtOU80ZXk2WGNrNU1kU00vVFFx?=
 =?utf-8?B?QkxXengxdVpkaDY0a2J4cmMzb2svOGxTb3ZqSDFHVXJab2EydVhJTWlpak5O?=
 =?utf-8?B?LzdlM3o3OFhxcUFYdCttZ2ZnZ3RKd3hyZVl0amt0NFl0aVRzZGI0b3hndDlB?=
 =?utf-8?B?b01JaE42VUdQR0tiam14SkRMaXVWQmMrTm1TeXBoWDZ2QzdMd0JicisvUG9Y?=
 =?utf-8?B?VFRzbkVDb2p0YnYrMmhiTEhzK3ZJS3lWVnFSdGErS24rZUhqNlE2aC9LS0ZF?=
 =?utf-8?B?ZnV2ZE0yeFVlMnNtT1hwVE9UOVUzR0NjbGhwWExlRE94MGREenhQamZVWlQv?=
 =?utf-8?B?ZmQ2bFYwOTlqU1l1VnZPNHFoNVEvQ0FYM1hoZlI3NVBJRGdwa0pRU0VqckF6?=
 =?utf-8?B?V0JQL3BnVlUyc0Q3L3lOQmhBVmxabG01SFoxeHlnRWFzSlJnYXplWEN6ekNo?=
 =?utf-8?B?aTVWMHJzQmFwZ2hQV3hheS83M2FRUWJlc3V1eUxtSmFBbnB5d2dSbGRGTmc2?=
 =?utf-8?B?MUlXMGhIQVM4bWJKdmh0UDNwYXBSekYwTThCaStmTW5RTCtCODN5aEVhSEFE?=
 =?utf-8?B?TUhyMXllOWIyZ1NKY3lXbnBxL3FUc1F0Lzc5bFFFeVpTSGJCWjBRTEp5SEV5?=
 =?utf-8?B?U0tjU2pkb2ZGbmEzZTJLOGNGajRudnBINW9IQTBZbUVZbTFWdGtFek4wQWhZ?=
 =?utf-8?B?ZXdtWE1IYkxPTTFyRGh1cjQxb2pGbzhBOEtJdURQaTA0V3Ruc0Jjd2VodFEr?=
 =?utf-8?B?dXpIWjkyUXY1RGt3R0ZTOGdlOWppdTFxZTlnQ0tXM1NkU0ltTlV1bGc1WDhZ?=
 =?utf-8?B?aFl2VWVta3ZsVUlFeGx6UnN6Zk5Oak9FSUUwUlJodjRWa0pyUjlMcE8yWm9C?=
 =?utf-8?B?VUREckovcGVURnduUlZTa0NWUmRTU2tWc2tOVTlsL2dzMHVhQytuVTg5ZzI2?=
 =?utf-8?B?OXdCeGFnYW1IWERPK0lBMjBock8rUUpnck9zQm1vSFFFRDlKRmE2OUxodTJy?=
 =?utf-8?B?bEFNTEEyOWNoVkJSY1NZV2dQNFBhUHRGczAvZU9Ock1McTFaQnZ2N0NPMGp1?=
 =?utf-8?B?NVo2ditlV202U2FOd3dSQi9TNnNXOE9PWUN0VDBTT2gyTU1BS2ZxK1NTZ0Fa?=
 =?utf-8?B?eGtJK1RvYW9TZVR4RHRmLzdCQ254OXlrcGcwbVowRVFoeEs3UVBESDZzYzlw?=
 =?utf-8?B?SzY0NllsM2ZSS2FmMDZUQWl5ZkdOb2FBRk9NMzB2eWw5NHQzL21OV25pMnNx?=
 =?utf-8?B?R0FsRG9kK0ozc1h0RnJzSmdja1hjVXR4a2oyNnBsWldxZERQTXF5SDJYNUU0?=
 =?utf-8?B?ZVJMaDYxUDdTL1NkRXdMZmM0b2dwVjVFb1hXc2dMUGRQZ0pqNWMrZWlPTkVj?=
 =?utf-8?B?bDlhdUY0ZHI2TlJ4UTZ3S29KK0pZbStFNEg1d3dmM0luRnRTckdTT3UvdWgz?=
 =?utf-8?B?YVkyd0dkUXd0Zm16OFB0dU9uaXdBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c72371c-294b-4cd9-a60d-08db520dae0e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:51:31.2988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4nc3XwYluqt7ywvEawXhVlqRgFbLqg1yQ547578lU43hC51rzFNod+0dbaFrK/rwBlvPGT3FruD+81mRunmaq4P4NSrr1R/qzIfKpYhaKEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4724
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 12:45:09PM +0200, Uwe Kleine-König wrote:
> On Thu, May 11, 2023 at 12:28:54PM +0200, Simon Horman wrote:
> > On Thu, May 11, 2023 at 12:17:40PM +0200, Simon Horman wrote:
> > > On Wed, May 10, 2023 at 10:02:47PM +0200, Uwe Kleine-König wrote:
> > > > sxgbe_drv_remove() returned zero unconditionally, so it can be converted
> > > > to return void without losing anything. The upside is that it becomes
> > > > more obvious in its callers that there is no error to handle.
> > > > 
> > > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > 
> > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > 
> > Sorry, minor nit.
> > Perhaps the subject prefix should be 'net: sxgbe: ', for consistency.
> > Or 'sxgbe: ' because the 'net: ' part is largely meaningless.
> 
> I'd not drop "net:". Looking at the output of
> 
> 	git log --format=%s next/master -- drivers/net/ethernet/samsung/sxgbe/ | sed 's/:[^:]*$//' | sort | uniq -c | sort -n
> 
> the clear winner is "net: sxgbe: ".
> 
> If and when I will resend this patch, I'll adapt accordingly. If it's
> taken as is (or the committer adapts the subject line) that's fine for
> me, too.

Thanks, that's good for me on all counts.


