Return-Path: <netdev+bounces-8726-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 720D7725655
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC30A1C20CE9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D0D6FB7;
	Wed,  7 Jun 2023 07:49:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7205D1C3A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:49:37 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2096.outbound.protection.outlook.com [40.107.101.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0489F1BF7;
	Wed,  7 Jun 2023 00:49:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tf3vqKUuYFMmmck5cR1sYjpS0qIt56gjXfrbf4gcpQfi2Rk1vyV4nKAL2DqnI4EJcY1Ed0QYcstZwFbze8nsr8hpkQgQQvUh27EHWUewbTYaPzZN4ntUhm+YTqEj0VWE9TAWUOU+TSyjdxGACrKRokBSmFFpa8EVSz/VlUVbvEcpGl4i6oc8eEHpva4tpP3rruuoLtmcFwAeQ/tlmXvP9J80iXqfN5T7I1V/4EAiq4Efms02c64s0RI91yxqqgeqFTVbAGPeUwsSR095AmFpFVsd5Zf1uAO3UYqJzQcFxnmfp+ZSO0ba9U0FcoLyQ7WY6K5o+hp2lf8RhMVt9NZibg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6nR6g/dHqSlEUTPJxIA769DgSw+KUeEekhqYUQfcXl8=;
 b=ntv/+TOQvqq5nOrUJcUf8Bs7LVsRDr9a0vfqN9eGVrn2dH3R6UzJD7gWHgxqCtxg0++BheUca6ezDdzPGKjg7P5GtuTNoCgaApjZ8E2mplcfjPV4ZTY0I1l7ErORAZJOEDt0nqto4fCdlnr5tTdQEiuccOoHWHt4VlBRKnXRrRjPr5GhefEIzM4Qy0/UlwU5D6ASwbW5HdcVhEknpov4v+Z2X/UljG4tF479H5AvleHup1q/+W5nOrsm5x/xD7d3JHhMrOVheD1ihYOZ4gk0LpCH2xQLodpgJ9D8nF07PJM/lEUw1BdaSMb1G8sjFkSmguxvRhVRejsG2zky3RZwow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nR6g/dHqSlEUTPJxIA769DgSw+KUeEekhqYUQfcXl8=;
 b=DoXRX1X08Gt6xV04TPLwVNZG9vRi7Qjlg+VTpXF+PhmKvLjMgpuQRDLBIcjs/X7ZyPySM8XLEo70lyy+alO/KCOxNSohj7mq15+tFbxC2qOvNcEjQwT+H8PGq/ED7Jt685NAD0YJ70s5QG+uTdYT/6J7vi0102SMRo5s+gIi4F4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5317.namprd13.prod.outlook.com (2603:10b6:a03:3e0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 07:49:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 07:49:32 +0000
Date: Wed, 7 Jun 2023 09:49:24 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steen Hegelund <steen.hegelund@microchip.com>,
	Praveen Kumar <kumarpraveen@linux.microsoft.com>
Subject: Re: [PATCH v6] hv_netvsc: Allocate rx indirection table size
 dynamically
Message-ID: <ZIA2hEhz0G8Oe5pf@corigine.com>
References: <1685964606-24690-1-git-send-email-shradhagupta@linux.microsoft.com>
 <ZH8Bv624GxCf1PKq@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH8Bv624GxCf1PKq@corigine.com>
X-ClientProxiedBy: AM8P189CA0013.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5317:EE_
X-MS-Office365-Filtering-Correlation-Id: 93c34a08-4287-4823-8bbf-08db672bbb41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3dmqf1cJ9aOPIvAzqKWkL5KmaMiCblVM5/AdF7AM/cU7GDShEFDmJ9u16cZ3WkLfwzqzFxgN3VBEPL+jUh/bmg8yYnpF1W0AJqNQGGyQ15jbVtCh9FcY+DRqllYJxS58+4XfeCzqUFreM2twDQrbcITNBV05+SJytGlbxhqafMOSOqE55XJOe2JIw+TWM66LOTSQVzeSmsFNot5EQqmvg1s+MaHkZtXxZm4CFDXnKyBqbnuUIPR1GmQKXP3hwnk/vk75PQdyX1maLhoFQr4Yi5Xmv9kTm5PJdRO7W84RoJ9BqzMYd1LhJRLmit/+wybIiC5OYTZDXkg8b4Nj5/YM0Hlyfnck/mOFTRiBgiVd1JkEukBVuepKthOZH5ST1er3RLDkbLmZYDcKZL1QItUoWvDnyuHgVlXaNkVF5NPLmOiUqkmSH4MYpXOkA0IvopZ2Ovnb8eEJDXV2PEm9gBE76BLHBeAYXTm6OQwXeeMG0mSd/+RHouLX+0W1MnBNd8ID2zm+lmJa9ShGCjFYzYJHk3v/blyT0aRKsTsBhS6BTcg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39840400004)(346002)(376002)(451199021)(966005)(6486002)(6666004)(83380400001)(186003)(36756003)(2616005)(86362001)(38100700002)(6512007)(6506007)(316002)(54906003)(8936002)(66946007)(66556008)(66476007)(6916009)(8676002)(4326008)(5660300002)(44832011)(41300700001)(45080400002)(2906002)(7416002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fnnTlFAZHLB2dbAUA4o4lzYlsMPypWRPTrRQuci+qlogVSDXX3en5ExV7jsm?=
 =?us-ascii?Q?zXX6ZTKtU8XxczMY3ry/jNOZgo1VohlFQuLcOv2teKq5WTpAZm0d3yyhrwbK?=
 =?us-ascii?Q?WVQ3if4USGWl2G6xdv9QSKemOVaHRc2pV84B6MEaXhag9R6oMOWIuwGaoCoH?=
 =?us-ascii?Q?0kKmOdq5kmmxpyFLCBrnXsbyER8+MB+42YhbSPJQN0mpWpTdCATmZMzl3eYV?=
 =?us-ascii?Q?lcsHS7bPyvnaUoMcdXQ4VhEnLlO2Ak1EPrSaROT0VtUUCjw/JC9S2qiYSGr3?=
 =?us-ascii?Q?yHQPXtVqhC1nSzGWOqKIschYUVpBdSlHBxlCOxSrPHXXBjMh/f5WNHdHf57N?=
 =?us-ascii?Q?FagCfqRbHsJe1YWuMeO6tdjj53QyV5cYuBpuE/8biCI49+ixm+lM6kjj6+h/?=
 =?us-ascii?Q?m2U39ASFToNK1j15/evy5v/tROz6mLVIVG3tvbpIyCyvFTLGpl0vtKheQM8V?=
 =?us-ascii?Q?vceyo2/xLAwVA5tjT7nz9YMMnT8de1EuwS/YIuy+VvLcDAEk5HXMQUkbQUsH?=
 =?us-ascii?Q?UbW0U8/fA6WtGJnwvinilxucLngpmEseV0z4HyLCtxQZbFUEImhgl/i/q/jG?=
 =?us-ascii?Q?O7iNK5Y3t4owMoQkdfA07hPCs7U9NSpTkSS/FyEb9j5Ppckil5z/DvOaAY2Q?=
 =?us-ascii?Q?6FmZhKLHfaimj4Asx8fEq5Xq+bACxklgBGUBS91Gwp+z/Co7qtz2Lm+dXHU9?=
 =?us-ascii?Q?bb9SVUi8fPznq578Rl4HZeNKyByhIvJk/wyz48JlssYKykNUJIYKjfNoXb3j?=
 =?us-ascii?Q?0xtpgFucYPttvLjOIkao42F8hAmuboxUgqIxc7oAFbyDea2GtzxpwYUvLObl?=
 =?us-ascii?Q?aJVRSrIxvg8UCEIKW/80f2HqcAbvK6mzGX5OemfgEoCkkMHV2SRr82jdXx1e?=
 =?us-ascii?Q?EENst7c/bjvRg2v0SCWXR3UZcLIbcxeYLfMOy5xVmhAwsfZk58tO7rKOkpNT?=
 =?us-ascii?Q?yKAlZ807ixoEoX/fS0q29orF6RNACJng9tADBIzx1vUbGp7GXt/pxKuYjHfd?=
 =?us-ascii?Q?b7JdqXuw1+70ITJfaD2X8SoqME4CnCRWJ+Gfj3Mxqi6Lw6F8Oh6xrLx8toQu?=
 =?us-ascii?Q?Qtf3dPbig1APggpNXRKqjvPVQFDLYZTMXNuQx3MUTw1VgNWM05BTZe8So+Rp?=
 =?us-ascii?Q?jMLNulHQRbSySt3WVpj8WwdPbZrvF2zb7NxV2YvT01O00K5ZbtOL9LroSMAR?=
 =?us-ascii?Q?vgNPMcNk0kv0SQhGlO9H4Ui50ZvPNR1/ZG70P+NwUfLF4RrmNdsD96RFCrv0?=
 =?us-ascii?Q?oKNV5J+y1FjCcJgF2zEsGbqVIy8yvMKNWe3W5EKXeQpCefsQVzKsYc0QquaK?=
 =?us-ascii?Q?AoG3QQovBFTW42hHK9olPnfafgYf/og0CD5xVOSnWaQDXear3VPlk9egsbyd?=
 =?us-ascii?Q?2pkSSx8+jvw4NE1KFBnJAbZI/OAOIHHGJYm8X25CqWy7X2xtkl8y90C/LI91?=
 =?us-ascii?Q?kbxl9mU5TWKafflkg0ObzD7+EZitn773VT9QrBu6bRX+3S/oNSicLjDOhMsT?=
 =?us-ascii?Q?HcPo3h1hkV7rWUJ1fm4k9HEeQ4JwolLYkZYDc5kElRq6sJXSTfH/2fIeaYdp?=
 =?us-ascii?Q?iZ7GDiaPTDaLPmJMMzkNC3AxNSgSCRjUvb10P+7Qtx/t2Z9BW+XC3gJ+i3f0?=
 =?us-ascii?Q?b4WZY0+b+IKxU2wvRPNtv2IX3kY11ChKSVXyUaeISVlJ8/JgVBNnzlNkf4fE?=
 =?us-ascii?Q?rgbcqg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c34a08-4287-4823-8bbf-08db672bbb41
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 07:49:32.7460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Kj2lT5zGW8G4VtwvNgH02OFJOoM0a3WWsLLoYS0ay+14cZJPxj8I7Mup0RV2gx4R/PZvEZP06uZ8/JC+tNqFg2ADdkzpPw2D0gDCjY+J9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5317
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 11:52:06AM +0200, Simon Horman wrote:
> + Praveen Kumar
> 
> On Mon, Jun 05, 2023 at 04:30:06AM -0700, Shradha Gupta wrote:
> > Allocate the size of rx indirection table dynamically in netvsc
> > from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
> > query instead of using a constant value of ITAB_NUM.
> > 
> > Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Tested-on: Ubuntu22 (azure VM, SKU size: Standard_F72s_v2)
> > Testcases:
> > 1. ethtool -x eth0 output
> > 2. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-Synthetic
> > 3. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-SRIOV
> 
> Hi Praveen, all,
> 
> it seems that there has not been any non-trivial review of this
> patchset since v3. But at that point there was some feedback
> from you. So I'd like to ask if you have any feedback on v6 [1].
> 
> [1] https://lore.kernel.org/all/1685964606-24690-1-git-send-email-shradhagupta@linux.microsoft.com/
> 

For the record:

I see that Praveen has now provided a Reviewed-by for v3 [2], thanks!

I think this patch is clear now.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

[2] https://lore.kernel.org/all/bb461c30-3eb0-74c0-d637-c4a3bdf84565@linux.microsoft.com/

