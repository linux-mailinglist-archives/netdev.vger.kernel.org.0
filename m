Return-Path: <netdev+bounces-5601-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6CB71239E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:29:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A5A61C211EF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:29:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9099A111AC;
	Fri, 26 May 2023 09:29:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860D3523D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:29:34 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2123.outbound.protection.outlook.com [40.107.212.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574431A4
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:29:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMM70cHiSK2hk0dibpM3krU1PaLafYdMo52dbn8ciFoj5FbCgyvtfcowpSlJLooHn1jaXXRdPBlMfwa/Nn+AfIf5s7N+sRMnm2n5p/BAfaUS8G5mAQfcXrqWYlKwdr8DCB6rjZHVUeEgmLLF7X/yi1VpauEY/ZZ+7ER2ot6vE+3Eaj5t2nqsb97NPh//BHRmgRctJXhaxm51L2kcRGn9yyiZNNnhYyREnkMFckeq4dr5KntpB8GwUxSwJdHmJ0Eks28SRmhN+s3rtyaSHo4KzJS8JePNcSYJPHk3zlQvrv5ZLm3/QHLNut5DlzcXHERKo8mJlEneOthX7FZi1a2rFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBF/wnsTgGzHvsHH+5rI6YSFM7e2rT9KX9CaJJ4eD+Q=;
 b=JnTf8e26TYIX3BxWkQkQp+vqVUAWFrlzIMIT9cRCtOaqMbJPuz3fWVPpIbnieBO4FhugYRoxdBcr2DS2LWRGXdi+VzbmAV4K2WJHbd4lGNkz6DPc/XHrXMC2ly1zlAKowUfVzQa4JoKAa4oIKnxlNaHV3V/GlgswswxD01bgT5aUCR/eWMZGMoDqF7aR6PsCDJ107CTCUJHczEzthtLJsUwH4XBKh94Ty94aIM1x7UtJ8x/15WVfcdU9fawKcilgicLZdtCX5ye37ffTc6jPfAV+atmrWP9s8vnGtLSPNkqCm4FDZleDbrHj6ka18DXC6hiAZWR2kwK6A7Wk6F/+lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBF/wnsTgGzHvsHH+5rI6YSFM7e2rT9KX9CaJJ4eD+Q=;
 b=A4XEXzKNAlVHD/wELd2euhJ7AMMfeWuTa3sbN/rlGlIqOSqiqJHcQQw9uJt+CXFlhSNZelkMYNO4Add+WcrdwvP5GAFap0vmvVkjUD1z8IXMFrfT0vXFWl1zbtid3hDMXNMjUD2u5rYC+YXZZXF6ZxWqfDqXiqvY5rwK6dMDAYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5197.namprd13.prod.outlook.com (2603:10b6:408:154::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Fri, 26 May
 2023 09:29:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 09:29:31 +0000
Date: Fri, 26 May 2023 11:29:25 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Neal Cardwell <ncardwell.sw@gmail.com>
Cc: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Neal Cardwell <ncardwell@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] tcp: remove unused TCP_SYNQ_INTERVAL definition
Message-ID: <ZHB79Zwho1MWLkbv@corigine.com>
References: <20230525145736.2151925-1-ncardwell.sw@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525145736.2151925-1-ncardwell.sw@gmail.com>
X-ClientProxiedBy: AM3PR07CA0138.eurprd07.prod.outlook.com
 (2603:10a6:207:8::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5197:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b4b3f55-df38-49b0-f6c9-08db5dcbb5c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qBhULHTGrqUxIgJEjylIyDZa7q5Q8tFFM+rByJAhhH71oBlQEBRQSRBbp2aOT10UkXeneo1oX/s0olr6EuJUOkDp6Ulzsd1JLBRo+nO72bS++1TvwoqMlGvW85P47GSMUwNB7DThXOffaWLJpOHK2lmCkyy9xB2Gq2YOPxMHU6t4+GU3T1Ekx0HdGOTKByI1qEiupTH/pPf5Sv+N4FWDU0GTt5/Gwg3hgf3HWY6aEGhGEgcF6nrfZsUZ5WD5LF7d31qMgdd5hIc6vJrCgG6pofBFX1HpK4zYmkz0OCZS7GJB3x3hOpZehBty+BbGJBTFEHEzC3fSsi0P+l+yymPNwmg4RJRVV2qycVlMFWxNStjrd8AdlbBDeZZk+2mML2pGQu0gGS4gW0o2Z1yzFwioz2gCI+sH45V+ypUrQJntMvFozthy8/8xoOr4gG9nWjwdGWl2eNzrZI9PK+2gHzJs984VQheQkLMrbdbGdXSPcc4glOKkeEoD+QjhG+KuLMf9ONeLcHmz38/lrq7ENt34UwUeOvLyhLlbS0++DlSSQxinBw32zpAVuNfZMNScCOaY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(396003)(136003)(366004)(346002)(451199021)(6916009)(6666004)(6486002)(4744005)(2906002)(8936002)(66476007)(36756003)(66946007)(8676002)(66556008)(41300700001)(38100700002)(5660300002)(44832011)(316002)(4326008)(478600001)(2616005)(54906003)(186003)(6512007)(86362001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mRwGdvZMPzF898FtxLHJePMoKNiY4KfUp/VRxX35Mw4w/aV1KNdZ/6Evw+91?=
 =?us-ascii?Q?KWMxeAILVaJksrRMqQWN8XPDoJK23xPUlTUcP4bALLqsIJuo+JTrKrrdKNo/?=
 =?us-ascii?Q?FEkRYV4BUlrcRC36aEcLnx1ct1hhBC3hN6r1VT16Bf6izT7AnyxaizxLYWXb?=
 =?us-ascii?Q?xiZFrd1wAupR4sp2k1GxB2Ez29lSte54c1b7PZwuSW47bIyn/4ZyCWp+F1gw?=
 =?us-ascii?Q?EEsueeg51BxSSeAn1lpCJGjlbXqqaZwY6+1KakqcPtg9XEQaf9pRSC4SYik5?=
 =?us-ascii?Q?19HCwi6EyLB/gIUCDsB62ROfbvbBE+iFhpS6Dw4GNCy2Anf3YWkadcCfFrMd?=
 =?us-ascii?Q?5OOklcSnukIW+r5vfREByzIFP7dDn/Gnkrk6EcoOlWR0Xx7TY2t9fXdUWgIK?=
 =?us-ascii?Q?XYlk3F2C43/tQZMnWzy4i+PgLS6tHqdRIWjvI2J0meMtMt0ZwPiMZQg6O6my?=
 =?us-ascii?Q?Or7JuqylrduxKbQX08KKf7Bue8DN26lTmuWkwYBcTHDi/dTNseeONF9fzxkP?=
 =?us-ascii?Q?ptONttv+Lkwci+s+b+BglTn9BLFZ3F5jt4x+geK9XEwEWoWTXc8OAPdyIMbs?=
 =?us-ascii?Q?K6WvmGIZFqLz03dXMKUgub0/os23frcbZmENNtkoMooRPviR0WAdDXbrievB?=
 =?us-ascii?Q?g04CjAOmypAX54qYids6hjrVcikHFnfHGyfNWo6AiH9iKjZi4uDuEo4M7oGY?=
 =?us-ascii?Q?PbhT8ejrSS7QOcv3GNecJ065UHTlyxIfDRkH06b4WyefPLPRkV5tWQAJjME/?=
 =?us-ascii?Q?Bfm7fLgu/K78tKAlPnCcwft+ANlgrt0HBakf9q0k7OzrwpX7bOh8gJXrchA/?=
 =?us-ascii?Q?Q9pnZA3tufXtSmsNofHde+w4C/W8XLyeVsmD3vRIuuj1nIA587OfEfLIhCQG?=
 =?us-ascii?Q?Goj+SNx2XG+7nJFm9KZEK0X+lhi8eExvXLbwbdjdFyW0n7YUS50F7lqU8/6K?=
 =?us-ascii?Q?LVdKu+gqatAYFrLiru1JkX7FVYzIaY+u8862auDQQbh+wbDFnucX5nK4g0M7?=
 =?us-ascii?Q?r9KQ+XcY+ro3kJfMJJaYq/jkDIXEj9xpo37g9NEHA/tSZh50D8LwEE0inBCn?=
 =?us-ascii?Q?chuZzd1CBOQlpnGo+xPtapvttaT1hk53dfcrr6einjx3UW7foxnxBf1euvvt?=
 =?us-ascii?Q?Tuq9IcALGXlnyGrrISkLq3Kt5NB6kJOBooQLivaRfZzugJz78TP/9Ql8B4j1?=
 =?us-ascii?Q?JD4CxJowvoOA0qFcxmoD4QTkRYsZH+m4oEsBKdhuubQjNyT1UGWamoLZiUDR?=
 =?us-ascii?Q?OMG9prFhoomF5I1DcHWypKlR+Gci2JacUn9HBz+4W0f2oemi76EoTSQlgr1/?=
 =?us-ascii?Q?rqcH7tNofo/8KECWrY+1yB06yBF0pt/lKdzKwqHM9LmdpxCkvEirRmAEzPvz?=
 =?us-ascii?Q?HP3fJad11RRmLCHfT67eCe9PKJRMPZXtOF30D70+LU1Wfgm8fP+xwCrmyqfm?=
 =?us-ascii?Q?MTKlC9u950ABNFCgJiOk4sPnMWS8iDPF0X4m+sohwO+UrdkhVDdCtSvHPvgY?=
 =?us-ascii?Q?XoDp9JamUzREz2U6f0ktcl+0etj9r5Eyz9kOEOf3Y+tMjGfi0obT0Eg75j/t?=
 =?us-ascii?Q?/T9fMAMlrL/QIouvD9OXlkiqtWHjLfpmCo43GbUwD0oitWAp7l7kV4FLB3QX?=
 =?us-ascii?Q?Ik7jaBT4QkRdyd9/OHv6u0trLA9pz9NmCMN21PF7j8t2jdUNRmbRfWFCCfRF?=
 =?us-ascii?Q?6UVUlg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b4b3f55-df38-49b0-f6c9-08db5dcbb5c2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 09:29:31.3434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gHOA1rOjMMPuBuyQh8ThaMzh6q0ZJ4WvP4JZBPnmXpMB7ursG65oGtDPuVwMUDQkKajN878pXpeTDHumXiEI2YY2VauYTsI0DOv5iTxz4tM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5197
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+ missing maintainer, Paolo.

On Thu, May 25, 2023 at 10:57:36AM -0400, Neal Cardwell wrote:
> From: Neal Cardwell <ncardwell@google.com>
> 
> Currently TCP_SYNQ_INTERVAL is defined but never used.
> 
> According to "git log -S TCP_SYNQ_INTERVAL net-next/main" it seems
> the last references to TCP_SYNQ_INTERVAL were removed by 2015
> commit fa76ce7328b2 ("inet: get rid of central tcp/dccp listener timer")
> 
> Signed-off-by: Neal Cardwell <ncardwell@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


