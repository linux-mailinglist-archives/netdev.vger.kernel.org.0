Return-Path: <netdev+bounces-3904-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F016C70980F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 899B8281C68
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D7AC2D2;
	Fri, 19 May 2023 13:17:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78C67C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:17:24 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2130.outbound.protection.outlook.com [40.107.96.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E869D8;
	Fri, 19 May 2023 06:17:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdHKXjdPbniE5YHQerzfbI/Aa9XQs8FW0cNyRqqlZUY3evpazRxxd1nAzlS94GigfalX1Tk/q9ybu2b4Y+/xLowf8eVPvro0I69UQ/399y9QxHlGiZIR1P/QS9EvQFyj7Oh0XrerHgPiE9gm08XgmUy5jnoxbOHxEiwLmxoOS1aLd3jwgGp7VRXqTo4svvhMYYoifN7KMzT/NYP4OC9wWyS3bd8Q8lMvy2U3OyIJlAiKU3rA0LpF17WE2MnNHaAX5W8MsEJTlAUJOpC+hbY3yaAI5v/fGQpe3ZAioAKj59FL2fTQxLJo9q/KOOmOjMV00P1ZODsycQxquuX1+HhCHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpkHGDKvXAtIcmK8Hpi27937qrkKtE8zAZXH882VD8k=;
 b=MO3ytb2D6rzmu/zjVFcMka6DMecJzvqD+hhYDPBRabSCQi8moe9jkBh0o/pyKz5wJm8fwXXKNQd0CgQz0r76zczEsmBGgRPwBX6Wwhklti7exz+BGMbapjOtofHLOyjOCDSDkvkRVZvGd7gh0ILOD/CcPMjt+/6UCGn1GU74XApGdkdsys4RJdzh81VtWeCQKQ8CaCCkMi5DTbavI1M1AkSjLRF8xIZCGLAsC5dyhflylm27sDUEsPW/W5K0UKJezWfuPcVKNtUDNzz76OMIamHxhQjchkwKr2+fDfWAz7VKdH8QyyeAzYUJtFAsfPg7cVS3ep5SOtkEnUpoeASWyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpkHGDKvXAtIcmK8Hpi27937qrkKtE8zAZXH882VD8k=;
 b=HL4XWz+C/m6NCtilkc5qgiwcbVFkBSLgtntdwzYUab6a+tPTt6NHyGSGO5k55KQiYcxJuLl/uYw9fwjLiZ38AAIFtQxmx9DFxlOkOaWqjqFzZ4KEddBmo+cFWCApbbfbNLjUCzOnVtbirs8p2MfLfEQDV3ANo9xK9W5l2UX0yAI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5537.namprd13.prod.outlook.com (2603:10b6:806:230::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Fri, 19 May
 2023 13:17:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:17:21 +0000
Date: Fri, 19 May 2023 15:17:14 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Min-Hua Chen <minhuadotchen@gmail.com>
Cc: alexandre.torgue@foss.st.com, davem@davemloft.net, edumazet@google.com,
	joabreu@synopsys.com, kuba@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com,
	netdev@vger.kernel.org, pabeni@redhat.com, peppe.cavallaro@st.com
Subject: Re: [PATCH v2] net: stmmac: compare p->des0 and p->des1 with __le32
Message-ID: <ZGd22jBn1nkzzQsN@corigine.com>
References: <ZGdgA9jMLJOi1W1+@corigine.com>
 <20230519114652.70372-1-minhuadotchen@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519114652.70372-1-minhuadotchen@gmail.com>
X-ClientProxiedBy: AM4PR0902CA0020.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5537:EE_
X-MS-Office365-Filtering-Correlation-Id: 54e17fa3-6594-49ef-87c4-08db586b60bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tO/hGWbalqTSWsOYBZJ8ws3XEkTJiUacCvFyzDV0ygTfpEmTYAO7ZaQxUDh0RRqQxpDqyzZSja3/j4kg0jBFXcyF3t+jmUYQaRkVT5nAoDamuooCXnQSRpztFTjft0A800MSB4hSjXk1CpLDze7w0nm2q0W11bNA0nRpkdd2bnehFJX/flecRTnCdP4RcltsUzrA9kQ30t9iS1FD3qVXvc6s67U3UygNhDkDa4jv4LWrw+rhQxsv4gIIx6jyJBRsTARHX8J8NY4asd2bwzPq7K5Li1ek1mUlEWh6yE9jXzpPjABHA5x1r8HYPO/kOON8vf2a3SI3IQlzwKV4t4hlHLoWm7zGoIVpZvJVnwX3Mwhf+RogxGc2PJ09QVNrStsB3HbpYX6h+l8VLR9VdwXSLzjM6KRfX2Jgk65nYGDU9KyOCH+mHolxi0WWOaQdqEVF7qeI3x2dCS5Zk3URy4Tb5HqkkUd3XcTyoHH+43+hutL2gMc4D19jfVVaF64lFjVG493Mp0qF/ivqg0mL5qWcLxQTM6sko3gEqdPclT+x9v6yf9xixXf4iLTqj2GScsX5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(396003)(366004)(136003)(346002)(451199021)(38100700002)(7416002)(41300700001)(5660300002)(36756003)(8676002)(2906002)(6916009)(8936002)(4326008)(316002)(86362001)(66556008)(66476007)(66946007)(966005)(186003)(44832011)(2616005)(6506007)(83380400001)(6512007)(478600001)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K5+vn7WaPyY50IyyjW5XliA9LxI9oG9/JaAdrRMvxDmTYcrmm8g1Kb2HZD1E?=
 =?us-ascii?Q?l3zqNyJwTyEYroE9h7siJOlsHXFRRinL0BKFz/lNsTmr9FLmIBvWtixhuOZB?=
 =?us-ascii?Q?jRYHke3afCy5z5NDKoxJ7UoH9lAXkgHpRDgAe5Mxz2yq4hMphUiWtXfuxvbd?=
 =?us-ascii?Q?kwgLf/YbEZbYoA1j79nQy9qbhdY7/xErxPG/YqRptX4BeAuwIAE024qqwGcU?=
 =?us-ascii?Q?AIPuLk+VzEBc9SwAXJIWkUEKuRir4dE8Gvy3t97tHK/j8VYCedl7+GYPYsUK?=
 =?us-ascii?Q?xTa6JJdrhveOvBCIa8tMKzGG9VC3jf1bTgBowAVkVBBWZFwLopRvGxnzK7gz?=
 =?us-ascii?Q?Nf+i3Ug12774o6f7n1y6z9pOM9Ny3clZirXcYDOm9tOSpX8aR/bo4lspCh0z?=
 =?us-ascii?Q?PXd/LII3waaSDrFPZZVRCBPBRguUk22DYU48uIgL6dTLLBHs/2t/Hcnxt2XX?=
 =?us-ascii?Q?Opx9sfe7HkAigLr91B0YXLEEgJB8TqaC2urRn0yGo5sygyGmaFTsaWtjygf7?=
 =?us-ascii?Q?ColkAZtAVcwS9ry3crjQCcPbCbK63sPH/mKrgWuEI6v1JkNr9bvO0OJSK+hs?=
 =?us-ascii?Q?ZdB4tDrUAOZXOHBr3aK0I1FFjRLIwRvQZVN1FToJ1LuTsyTHs6aGMMws9Ins?=
 =?us-ascii?Q?pe59ISJlCUOzPrF8Fbly9Uvd+j3rFTJqiyaOzXswn7U3M7uVcvQGvQM1zFuS?=
 =?us-ascii?Q?KYZ/Ck6M+CMzXcR59HtA/9itRrWn1xYIw6QigsWfXamJsfMoKWmYPMvTtK0i?=
 =?us-ascii?Q?zuIjk29+/hseSm+HgOUK7c4B0x5tMRvOISLV7jms4Z1xqZeM1jVGeTdoIIAf?=
 =?us-ascii?Q?O5WlgP774vDKHHDC9BKwxA8NFZB+h9J8EJlabIfFOEpSm9aovPv91VSuzhyz?=
 =?us-ascii?Q?E3iX+bwrMCyCUKv+oOg8zA+QiV0JdjbbEsyYuucNSpOyS89rGdpxdotmGq3Z?=
 =?us-ascii?Q?H0GJXbdRCQUeGElPMOHM3ZAcEyqLSO6QUDerahreEqSjf3XmRUYWZKyXrBNR?=
 =?us-ascii?Q?r13zU0kTm3tSF8rphHx3OCplVGiJKhqxRIYEAUV95s9s9QPLEXI+/Q4dpAPT?=
 =?us-ascii?Q?ajfIbLT0b93j1qGllB9g7XRdcxynNbFUZw2Q2R/VvhjTcoaHMiMEzC+DiI3u?=
 =?us-ascii?Q?HXea1tc38BC6ds5CZLop8VOsILtLh2nBA78bGWsquURscTXAdWZ0b6grBf05?=
 =?us-ascii?Q?dvOtBxcCh+rhuh5ki3WpM9dsi7Z8aeUsCB8D7dGqLj8iN3+w6U5R0rmbWdvh?=
 =?us-ascii?Q?2Ca0y6Shl1RM/4jZLUwzb3Eenh3J0iDCgcnpfEb4B7uWiAerse5WlrTeYpYz?=
 =?us-ascii?Q?p3WzLnyt/COtgv/viTAoIj5VQLIXOGP5dY0XdCSiKe0k1FDY1GZKe4X7Veas?=
 =?us-ascii?Q?V4U5akalvEWkTfhbyXdEtbtuSrsRWebynE3NxcM24rxatTRVKfXVNtTeN1Zz?=
 =?us-ascii?Q?pCm3m7JQdPTjok1k2CtGahJ89kshzx9W/L3GhjVo2bWlsmOjiygkgXWdWT2K?=
 =?us-ascii?Q?rxlSWanoINrhR4J72MvYcTyxboewmJuICSE9tO/b/PdgvAq4aatemPy071GU?=
 =?us-ascii?Q?InQoQ62DgewWCPibGbM2aatoKpoqJhf/lZ0JlO74oaegswLyoUh4Fo00z0pA?=
 =?us-ascii?Q?3G4metdTaPLsSHBj6AFJH+uCpCbq4iuY3PgUaTYSD0oNagsNldfFNL8zyiRY?=
 =?us-ascii?Q?sIKYCQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e17fa3-6594-49ef-87c4-08db586b60bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:17:21.1811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ddrsx+gkP00tsAtclOgyf2FGcEbTD7KSTWeSOgohkTzjKI+waSS5JPs46RNxGJverF2S6Qc++TnIZyyXiDWnMhOaa2keCSRFI6IoMwlcQM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5537
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 07:46:52PM +0800, Min-Hua Chen wrote:
> [You don't often get email from minhuadotchen@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> >On Fri, May 19, 2023 at 07:25:08PM +0800, Min-Hua Chen wrote:
> >> Use cpu_to_le32 to convert the constants to __le32 type
> >> before comparing them with p->des0 and p->des1 (they are __le32 type)
> >> and to fix following sparse warnings:
> >>
> >> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:23: sparse: warning: restricted __le32 degrades to integer
> >> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:50: sparse: warning: restricted __le32 degrades to integer
> >>
> >> Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
> >
> >Reviewed-by: Simon Horman <simon.horman@corigine.com>
> >
> >> ---
> >>  drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> >> index 13c347ee8be9..eefbeea04964 100644
> >> --- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> >> +++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> >> @@ -107,7 +107,8 @@ static int dwxgmac2_rx_check_timestamp(void *desc)
> >>      ts_valid = !(rdes3 & XGMAC_RDES3_TSD) && (rdes3 & XGMAC_RDES3_TSA);
> >>
> >>      if (likely(desc_valid && ts_valid)) {
> >> -            if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
> >> +            if ((p->des0 == cpu_to_le32(0xffffffff)) &&
> >> +                (p->des1 == cpu_to_le32(0xffffffff)))
> >
> >nit: Sorry for not noticing this in v1.
> >     There are unnecessary parentheses (both before and after this change).
> >
> Thanks, I noticed this before submitting v2 (by checkpath.pl) but I keep
> the original parentheses.
> 
> I will do v3 with your Reviewed-by tag. :-)

Thanks.

