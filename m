Return-Path: <netdev+bounces-10800-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B416D73058C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E19F28147C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD1B2EC1A;
	Wed, 14 Jun 2023 16:58:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9B67F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:58:29 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2138.outbound.protection.outlook.com [40.107.102.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831F5213B;
	Wed, 14 Jun 2023 09:58:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNEgUcvt7BJwsnAvQ1uDC59XWenXiAcVuo6dc2pCiwBbaReIb6h+kJryNrr32uu4EnbbFLtI3dmJcefvs1c7tZ31xpNYVkZIEiEJTtGBiQxDsrmEMSlPrvlzLMFbiQw32A1kpjxfFSemtOe+KjNmlb88gnvZT4uV1hNkdyXbXAMBoGHGnfmJPZgQJoY6gFuijQISWCsxwkKdD2HQlAonpLCPUdJpZLcX4YUSx4++7yhHg0q6XPr+dIT3PgEq4LU+xlmdnWqbyhts8EqUADpdIt6iF6R1S34/0d6b7Hq++1HqBRUMT3qXAyLCjVf8OcU/RFIJDZbHyQ6SqeBCfQ7YAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=exJ6nMJHLtJLI2BbsuJeaKHecKc5z1YDcbzBvWf4WrQ=;
 b=jo4GnnBQK5VUtxQzmyjhLR9z13CsoWO17tesLk4Fy2Nm57/leKZU98PBpT6Sy9pVWUKOC9n/f4hcEPwG37kNatnwgpbml5uhe8lOseJVSqdJZ9VHlCr+zFEznUhvlw41I86MOgq8VbGkOWNrad71CfkJVvO3PVr5fSwdlKMDm0isKT4s/PBmVgYhgFBEI/MxXnwjxR6Yvf02q6r+dTVnURv573lCij5uKg44hLNQsT1/vSPzfUeOjqGwmyWm4Wh9kGQbjp0h4tjTIbPiNpLVaV49vXLgTmB2cAKpAJlNt3hx0XH1798oRfASfKbG1zEV83bF2It5Uylxn3f6TJkljA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exJ6nMJHLtJLI2BbsuJeaKHecKc5z1YDcbzBvWf4WrQ=;
 b=hoYdngyjseVhdVYa9ljiAuJRHkCQhZeaezmr//CX/1lBcxLKhfLdlzHPs1D4iXfDXRiz9Ab9MuEVpPKn8JOFWUA5LQ1orUV6z5sM098BWxhYf1RvksBvninpNQIRO25+TgZ5EefW2v6xHgP8b+bXbp2JUhJdzOTHzsSpX2wjbMo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6256.namprd13.prod.outlook.com (2603:10b6:806:2ef::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 16:58:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 16:58:22 +0000
Date: Wed, 14 Jun 2023 18:58:16 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Stefan Wahren <stefan.wahren@chargebyte.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Stefan Wahren <stefan.wahren@i2se.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net resend] net: qca_spi: Avoid high load if QCA7000 is
 not available
Message-ID: <ZInxqMtr4Gk4Kz0V@corigine.com>
References: <20230614111714.3612-1-stefan.wahren@chargebyte.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614111714.3612-1-stefan.wahren@chargebyte.com>
X-ClientProxiedBy: AM0PR04CA0076.eurprd04.prod.outlook.com
 (2603:10a6:208:be::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6256:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d531f4b-4d17-44ec-f6b9-08db6cf88fc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wRjDi/uAXu3vy1eGNE2CT598SeTbdqj3R04be+7/xm3qdTTJndWfw+MJwX8Qn0jplsNqm0pu0+B5hMyiXDPk0Tb0UnprEZaosd1RtsEsdDWqWdLEnTJD3krav9V37TnSti0ei/tCXEW4kgIsLMhMCQOREjg3oOHMExfGD4LtpEA8lBxW33fVmI/sIWnNNNe3o6KtPX2xKNXkFJyrpH7XpTQQy2DRxQ+/liDOSchbtxdntmoDf6oIekWkRXjlKmFX/6UQPD9AjbUVaVAk4PB49+YkbrmNJqfursTrKa0IUkWcgpoNHrVRLJ8XHL7B5Q+2SNBCN/r77JVwzMi8cn2xRLe1tcXCwPapcaYhQzj8xgVXlBvbfNqBtdpTQBO9YvqbMl5RFhIa+gzUNtbVJeTjZ7VCTMsuDfY4BX/STLlFQn/gH4IBHgbr/Zsmp7Lmsgfv/O7ix+y9EupTBKrxkFy1cJJaEq5SKRreIiNCiZHde4Su9YBeVRN52rCsdO0rqSfMWrKpTUqooOpk6zFQtm9un/OA12CXsaduDGnl0GL1/CffxlXJ6IYVmSm2fwBNtftXyuWlYz8PFZmu+TV3zTVlZ8yo+VaKC8lgTjHXYC6n0eg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(376002)(136003)(366004)(346002)(451199021)(8936002)(6486002)(8676002)(6512007)(41300700001)(38100700002)(478600001)(36756003)(66946007)(6916009)(4326008)(66556008)(66476007)(86362001)(316002)(54906003)(6666004)(6506007)(44832011)(5660300002)(83380400001)(186003)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dHKkIf0ZW0Cu12y01SASQBaGLS5IYUot/2C+FlhuT3db6dHPJXgxyOGqCR+o?=
 =?us-ascii?Q?UMdOQxB+goeY01P97OaV77MWMm/SNAWcgZXIKvw6nTFybSp0fYJEASt17Y4T?=
 =?us-ascii?Q?hZmv/kltl0JGYH3rUt65C+3Bf/tCoBT2SS+aKRyyxfpUdAkm9KJWYAq89Ww4?=
 =?us-ascii?Q?Rh0+ohWAgJ5/dDQj0UeiIvWGfijgqdyE95F9EbR1P4AeyqA6XZJikbe7t3F6?=
 =?us-ascii?Q?peRtkxFH2Rem6BfU9NuhQA7SjiS7zQuUC3wez3Tt/vzXDoq3Kl3xGISMFu5M?=
 =?us-ascii?Q?RxuxMEToOzgppOIUIaNQ1GEwa8A+WJ0vQFFiOxK6fhRDZptLkMQh5BVmkcAq?=
 =?us-ascii?Q?I0ueU83hB8mPom8PPkloPmko49SZSl4vZpI69Wspm2XCduCKEttx4lRhs1lR?=
 =?us-ascii?Q?hXiN0ynKNjVXWGI6I5Jve6L4IPGucbCdTSHmYEJUGYiOiiW2NfDV5YJiKj4q?=
 =?us-ascii?Q?WBhuo3TMPvfpTxngQrln0UVoTIFXmn+GrcyYfUFQx8f68OTn3Rg8Ml78/0zM?=
 =?us-ascii?Q?hb+myly0wRmLgPrpMjP/ULsdqapIy2jf7hHN+wucc8Rb/f9NLwhFpZlFv8XM?=
 =?us-ascii?Q?Bc6xxf1c6XfYfjN6GrSywRRz3UmtXBoIJHN1jtNu2KZ26Vnvh4IYpQhHjuAh?=
 =?us-ascii?Q?AyCUxsoaFHSmR5hJDUlKBqwCmy1nsW1h5T0Wi9mkhboXU11euC+u2MqmLx/n?=
 =?us-ascii?Q?FEU+y2q6d5l6P4LDElvl2yiHf3EcvioVzZlc3bbFinoSKKo6ds10O6sU5e+A?=
 =?us-ascii?Q?HiXxve9Xdwvr4jSVbFk/Lwvbb3G/Bbh+2K4u5zBM47IZKMy+e/pQmRtd7agb?=
 =?us-ascii?Q?lKVlOocQKLz79DUDdaI0lhG8un/MKYZ9kQMRBv1W+06lUXNsA0jVHxV8kzty?=
 =?us-ascii?Q?RGEqnkNY1fUKw5pElrNIX7+oWitjsANt5OTmYoo1W+NveZgqGbEFQ22RjCcj?=
 =?us-ascii?Q?uzC9s71T9IFFwAuIp0dL8VcMMej19XOJ94WDKC+XoZZM3DOheShddw1AmOly?=
 =?us-ascii?Q?mCPsPg0kl5s89jcaheU7YjdIx1pWSVfPLys173zgpjqgXvT8f79ByHv05qCp?=
 =?us-ascii?Q?ACj9o8MNTRZ1pc6FyL3iNNnAXoZE2tJVmOQUh34Q+X6+vwti4mniplKfYAIN?=
 =?us-ascii?Q?iqA29LvYoE8NFpx3jqQUKgL+TqsR+pacTCYsbfB5exWRTdxn0VVUvc1b/hFx?=
 =?us-ascii?Q?XzBJUajwSg6jx3nZsH0BuRF4zaEy69deg0AuDAgyWkFZQ5hz6VoD0HE8j6KG?=
 =?us-ascii?Q?QawNtJqsWQ3znXiN1bHQw/XliEPiZaZuVPL5NyL7Qa30hGC61S3eONPVXF7S?=
 =?us-ascii?Q?f4U62ldVyJUYtbzLlguybDwMJWspUACOUvmeQZEVmlsO+3rNxtX/42YFB52U?=
 =?us-ascii?Q?NOLdOL2Gsbe42fg1ssU4sjdeB/zVn2hvJeASY19iuxYMWb06xmOOzsmc3zfQ?=
 =?us-ascii?Q?VgadiCzJCLBY3us4zxQ/KJLiPe2Iw1M/efhQs0t16nbV4j/eCU3VlCoPm3qD?=
 =?us-ascii?Q?hwqPbcsfvO6RpUgr+QEc/6twO2J/7xTlsNT+hgQe8VcUAASBGesVpU+DjA3l?=
 =?us-ascii?Q?eQjSMWwxb+ajol9YL72+aisI0Wjs5jzmuOqsxBIwTaxw/M/lJz/HE0Nchvwl?=
 =?us-ascii?Q?fMtVPwiTn6IHyDNoxe+N7YLdKXG5dG92evCD/wzdKWxfhmgWqNd14kDOqTf6?=
 =?us-ascii?Q?AtX5kg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d531f4b-4d17-44ec-f6b9-08db6cf88fc9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 16:58:22.6168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nvVwcBlpfun4zM7yM8qItn65qWkG+Gf+Sq0Pra3LAnPvrE6pTI1NknwXBCbGP7aqPiBkxkvc4/vIJ9t6Vb8qg7deA0qG4qqLqNdvS+hLh/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6256
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 01:17:14PM +0200, Stefan Wahren wrote:
> In case the QCA7000 is not available via SPI (e.g. in reset),
> the driver will cause a high load. The reason for this is
> that the synchronization is never finished and schedule()
> is never called. Since the synchronization is not timing
> critical, it's safe to drop this from the scheduling condition.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@chargebyte.com>
> Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for
>  QCA7000")

Hi Stefan,

the Fixes should be on a single line.

Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")

> ---
>  drivers/net/ethernet/qualcomm/qca_spi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c
>  b/drivers/net/ethernet/qualcomm/qca_spi.c

Likewise, the above two lines should be a single line.
Unfortunately it seems that because it is not git doesn't apply
this patch, which creates problems for automation linked to patchwork.

I think it would be best to repost after resolving these minor issues.

> index bba1947792ea16..90f18ea4c28ba1 100644
> --- a/drivers/net/ethernet/qualcomm/qca_spi.c
> +++ b/drivers/net/ethernet/qualcomm/qca_spi.c
> @@ -582,8 +582,7 @@ qcaspi_spi_thread(void *data)
>  	while (!kthread_should_stop()) {
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		if ((qca->intr_req == qca->intr_svc) &&
> -		    (qca->txr.skb[qca->txr.head] == NULL) &&
> -		    (qca->sync == QCASPI_SYNC_READY))
> +		    !qca->txr.skb[qca->txr.head])
>  			schedule();
>  
>  		set_current_state(TASK_RUNNING);
> 

-- 
pw-bot: cr


