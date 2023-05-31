Return-Path: <netdev+bounces-6938-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1345718E12
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 00:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 349F51C20F8E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CFB40767;
	Wed, 31 May 2023 22:08:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A671719E7C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 22:08:02 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2136.outbound.protection.outlook.com [40.107.94.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB7713D;
	Wed, 31 May 2023 15:07:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azAxcQ1ntLuL7H0fBvMvdLboy3/jiL7TLYjo3SzHhUna4I3RO8hcb0krnXPMZOagZ1uphCSF1s2qEKnrRIN8tpoYw0QQ2qMxJvwnVEmC9VnUFNTEKaAq6RxLRxObJplvMBJ5Z6MgQH3tMclSI0gyxjtMk9AddK8Tw0UItB9jPJ/5rxMUouFJg4lttxnhAf1B9H+sb48ueBZ+QjHdosYsMOsvPfqKaMpf6FkCdWaODXE1HKla7JmkM/5ia4u2OtW+XQWrdG6wtdJ7RFNksHLspH+iN1GQ2OfWgYmmKXGinORYWMP2gYGu/uZRJhF4dv7+OMvNLnJGRtTGcqLoFsOgww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wrenAkhCiiCTq7TASwo5WBotvHiqkQ7Ogs4rwyqGDm4=;
 b=ghr1SLsNPi1IAhzhaq/XAjJRv7+72YMqapo3xBGuGo9isoVKtshHAWbfSiaxe5C8UYT3cEvdeAiFXK1A7xruJDVNtFdA+V3T3zROjRKUbj38yVucwSHiLRkoyBmVQrXXCONfZ9ggX3zCYZ6u96kJiA5G78dSeOvZwmhBRUEfVgDIx3BQ2HKvUtqWBbQhB4fe6QZQDrKcYpIPbL1pRDXz9PafOq2wmTp0PNeFDrBrrn1zKaHR9m8dk4QOva808PyOloc/xnj6yjnSOfZdxS/aoVbSK/GgRrumf2P3lSMQ8wIj+QBOx2vcPS+uDcvIuR2efyy9Wg6H+inxTa0Thf5XUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrenAkhCiiCTq7TASwo5WBotvHiqkQ7Ogs4rwyqGDm4=;
 b=uTGioQGMA4e8zfDSP325fVN/d3p3WUXShEp9ztIDc1gGUG9TuLiGczxRvF6gNCLhHxbrX/AWhhthOfWcsJxYtavO4VjYlQ91a/LHFT0EMvmt3xeHb7h6DL0LEpvhgHnFxpaeEv8/5XOPylaQaCLinPtcKtquuXDUylrJnCgbvIM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4950.namprd13.prod.outlook.com (2603:10b6:303:f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 22:07:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 22:07:46 +0000
Date: Thu, 1 Jun 2023 00:07:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bert Karwatzki <spasswolf@web.de>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, elder@kernel.org, netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: ipa: Use correct value for IPA_STATUS_SIZE
Message-ID: <ZHfFK0+lgv2pSkFb@corigine.com>
References: <e144386d-e62a-a470-fcf9-0dab6f7ab837@linaro.org>
 <20230531103618.102608-1-spasswolf@web.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531103618.102608-1-spasswolf@web.de>
X-ClientProxiedBy: AM0PR01CA0178.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4950:EE_
X-MS-Office365-Filtering-Correlation-Id: ca1e0f1f-698c-49f6-ba64-08db622376e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ycOT9MjtxAsRZ0thUPEAVEh81JJ4DX1YgSAIaJ2eWe413FVZAcwA5CLIrN/L3ul2LLX911Nne/2SIxFPoqnsdVJ/eiLIbiOBqRxRK8k1sAOMCFvY+hmy1bXGF/Ea0Zm5i0BqKDFoVkiw2qiGqE8VtGx1zwfpfje+SCkY7rMzrT6RjQhu9LhgKJLRZThfFSGUS9El3KsGE7Qu5pN58x7sMRCuTr3cxKhb13bPrqrQekhMB+iBvO2wq5HoHYqTZPRTP4zwsSpGx+7NsPVxMfz4ItJPJG0YjtpmmRSzG9B8m/glAliceXnzU4XnPPFGgnRX6ypvxtKbtA2DEYsRBAxi3mUdbdXtE/kHZm9NR7GY5i5UvOB5gmBCCQ08XZUeIDc1haxwIdQ/80d4cTOtIse+D1l0j//m22uVLAt2sD3yRWo8tFWU6L6bqO9qW3uCNFBphtG4NDp4ihtialbkLMmsY+OPQoq5kmARm9FS/0NMiuDT111ds1sMEamOYLVfccEgPAgmcpGlSs+94WtGQWjWxvVil4pLTG/sonEdru6qvCF/HofMhzP1Lrw0CFnbCYyBROEgcBjD5hNOoTX9JTZzMEKLu32X0/Q+Owb4HjqHJbU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39840400004)(366004)(396003)(451199021)(44832011)(66556008)(66946007)(66476007)(6916009)(8936002)(4326008)(316002)(41300700001)(8676002)(5660300002)(2906002)(6486002)(6666004)(478600001)(6512007)(6506007)(83380400001)(36756003)(186003)(26005)(86362001)(2616005)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g57HYgTO5Qd+e3TN54s8FOYZViWEbDhhVOVC0N2WDA4WmN03kGLGFyxko5ex?=
 =?us-ascii?Q?zh+w4WZiQGjvc/Wi+3rPIHgz4+CTl1pYC1VOL4UHY/S2WPYjeT9/IR2gtNM2?=
 =?us-ascii?Q?i+L4iFQZyUqCdJ4wp+3cw8I4qXK8znA1Em1yLLHP0lbzBGa4sIoC+vOT3uPw?=
 =?us-ascii?Q?8Ueki4sf5zYAf/4IoSqFIjCee7Q5rGGrWeTe22EXNJ7bt78ewnUMxuYc2PlH?=
 =?us-ascii?Q?uU32QX5hQQ1ZJyfzcnuB/eRaow/fjIZItwAOQLCUI0yChZhz8Sgd8lFnMXJa?=
 =?us-ascii?Q?ApXATtAAOzq6RLcyEJ1H+5fI6a9Vwpf5m7vhSv8dV0aMzX2cntOJbyPmj+Z7?=
 =?us-ascii?Q?FoWy9oA1xp7UlH46jcUCJ4MspuY3xIH6vZmbFcFHY4KAQfOPj6PxgtNavBzf?=
 =?us-ascii?Q?ywOT/CMU+O2JuISddS8Qq5Z57qGgnSun3VmZO7Zzzc3EsuxCflQMWudSm5tu?=
 =?us-ascii?Q?KuLM54ygsAAFs2kwsR5gCPeBPOdoDEzwpgk3EBRSUwOCZFpQPYIOelMX7iL5?=
 =?us-ascii?Q?qZCRBlmp81LA/qG0YLSVqc30t1oHagsxB2XBaorwP/V9DtKrQANnyBiZohIE?=
 =?us-ascii?Q?QC6kTB47rzKL7YvUiMLVm5yhlKBpmfljmS/MzH3awoFfffLte7k9yd5NWoS3?=
 =?us-ascii?Q?LypdYHvoAihCDt/CwQ+gyVoXGRerVkA0Zwsprn2stK4ddDKF6koPjv/Kl6D+?=
 =?us-ascii?Q?NHvTEWwcawyrkPClXIcCyheApiHUfXc17vMZ7eQwYca4hfPYM9Tfjr/0xfHM?=
 =?us-ascii?Q?Ou+NsAzdU75VapIlx9890Wg9gMxAfxGb9SsoQbiDLyZp4jFh+azfkQxMQDAr?=
 =?us-ascii?Q?9xJKyuqYyJintXsSOJC40JsnkoR1HJbkLeEO4Y1+BM9jJtpG2Vk3aaLlkBT7?=
 =?us-ascii?Q?OrNtmuvSvSjwWYHrH3nJzh/nTM6pV8vPOn7mPUg5hFPx28Q+wwB8cvirEbtz?=
 =?us-ascii?Q?du5HsSjN8pyzAfO0+Zkd75ahnMbyEnNypmCW10Coyz1gg3t00RHM8OWd3LaW?=
 =?us-ascii?Q?piIKZqQsrvENvnKekCfIlTdrPgRFvoMinwVvAlIJxTkc+coBh2QehTeFWzwE?=
 =?us-ascii?Q?QW08vckLcLdMxbNwP1nYTG6Cj00r2V4HJ8WOG+9sqo2FhC2iOQF3YkPBNQzE?=
 =?us-ascii?Q?kusY/rLGWo4E0U9DA7kWQKRyjCWd2p3VMWCSzyiy2rXjOxfe5jLmhpv+O2Xh?=
 =?us-ascii?Q?AzHoLulxUQuzQ/Te3uU1ns015EXYhn8em63Rc68GQ7GV1N2yhyeHAun5QQ6K?=
 =?us-ascii?Q?jjc8L0EJZNFvlg0zfcfk1dL8Txn2gKAhXObmkcN7R6CAO84bUfv6I2UX3Es+?=
 =?us-ascii?Q?UuW45rk7ZX1vHgQtHNH+yvItn/2WUC/3xE9eMN9sdiINzBGxMJ9NsTQnmFhN?=
 =?us-ascii?Q?Iwjvf2Ja1MVvnxYLnCsLSHfuGsQU0BPX2VDOlnwBaAOK5KOGI7q5Du0GSe71?=
 =?us-ascii?Q?NE3d+X1CPp3erMHZoR6UdtiJkt2HMmcpCGeQsur/OiwZbDwb7k4w/VpbvRwg?=
 =?us-ascii?Q?Nm2oPF3ad42tg9irOe+V32eIDiCW2vdl0KoxiWexPtIg1oOviwQnC3OcFRjR?=
 =?us-ascii?Q?0rGIcXWpm9nTwsSTOAgdNvJrbD+8sR6ST7HK/isSNGT7c4ELKq1+vkKZzvGN?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca1e0f1f-698c-49f6-ba64-08db622376e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 22:07:46.2643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJ86k4bQlvPho0dAXB/WGqIDGHf0RNNRc5W7O/ANrF8MLSp+YbZbvLlUhWNTUj10hd/Cd7SHsylqeE6k0Pzd9N7iC59j4tRXDlCtHPNp2uo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4950
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 12:36:19PM +0200, Bert Karwatzki wrote:
> IPA_STATUS_SIZE was introduced in commit b8dc7d0eea5a as a replacement
> for the size of the removed struct ipa_status which had size
> sizeof(__le32[8]). Use this value as IPA_STATUS_SIZE.
> 
> Fixes: b8dc7d0eea5a ("net: ipa: stop using sizeof(status)")
> Signed-off-by: Bert Karwatzki <spasswolf@web.de>
> ---
>  drivers/net/ipa/ipa_endpoint.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 2ee80ed140b7..afa1d56d9095 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -119,7 +119,7 @@ enum ipa_status_field_id {
>  };
> 
>  /* Size in bytes of an IPA packet status structure */
> -#define IPA_STATUS_SIZE			sizeof(__le32[4])
> +#define IPA_STATUS_SIZE			sizeof(__le32[8])
> 
>  /* IPA status structure decoder; looks up field values for a structure */
>  static u32 ipa_status_extract(struct ipa *ipa, const void *data,
> --
> 2.40.1
> 
> As none of you seem to be in Europe, I'll do another attempt, this time
> with git send-email.

This looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

(somewhere in Europe)


