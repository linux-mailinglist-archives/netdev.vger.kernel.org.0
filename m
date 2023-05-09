Return-Path: <netdev+bounces-1079-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 026716FC193
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3039B1C20A27
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B28217AD8;
	Tue,  9 May 2023 08:22:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336343D6A
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:22:00 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2129.outbound.protection.outlook.com [40.107.244.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC352E40;
	Tue,  9 May 2023 01:21:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8ZSpvxAYuzH/hF/667uCdcVAyq5ljgMUiRT8WfbFEi9wxANLJqk/+kKyNnH1AnFWu1faq2hi3Q98pOSe10YprPMAHaST2nXfPBKUO8hcb/Hm0p8NGW4SH+lJpZYNA40e11JjiKHWYCcRS7si69JyVUTGAsv29ZYPwHx9vJGX0umcGYXeuWuJ24KxWwBZR8RCxPmvfMSNMX8SJJ4pMc4QZ9Qa3e9+ucEcBE9SwGMFJRCvS/bXav6z/F5bwiS+M03EyA7EFaEzCO7zRks4puooTxZiO0pNCbpszdf5O7Z9YokErK6prKxYAfF4OD7IhrnxKdBwcoh8BSDlME9hq3mhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cC+gyrpLd7nYJ7x0ybYahKmrjO1lOvIqIUs3grtMsg=;
 b=dOOnWVMHaPuStUgyNODweYoBIdCtlnP5hw+BsmcOSU8YA/9ls/BnCVfwN3Hw75dfpuKhmFYVUB881l5B0voUT9Wm6yWnUu5uxUHWT/IgruzYMj6aYSUA+bkdI9ihy20ZOWfOySQqUBVlTaRuNihtlfDaXbsD0Gis11gPQaMzl24Z4bLcciCGARCcQH57tNJS8XcAYQdkNxY+JjTibhkUgTFwRP7bZy84kLdR1hoJy2dpAjpSMrySA2qwldA1dW1BWXAkRrwo7/CX2yV/Rhd9l56DHLgmCjt/LONbYvUq2N8Li43mit3dZffv8h1FvWXrfl7lTbMGbtp05selSVDgGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cC+gyrpLd7nYJ7x0ybYahKmrjO1lOvIqIUs3grtMsg=;
 b=rLLudrUobXUaeKGE6qOaEumUMannM+sQYwP0mArTfPXf7B1CflXhxodvz0GG4z25r+TsVkN8pYixnssh5tHyrFFXbhQnw8ow1YdrJtTYC8KbrVQImNn3hzqeJxJQYGmmAy8CUrWm/fgbDeOZmhc/A5DV8yoIov7CnOmKNfW0J84=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5945.namprd13.prod.outlook.com (2603:10b6:303:1aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 08:21:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 08:21:56 +0000
Date: Tue, 9 May 2023 10:21:48 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Dong Chenchen <dongchenchen2@huawei.com>
Cc: edumazet@google.com, kuba@kernel.org, davem@davemloft.net,
	pabeni@redhat.com, jbenc@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, yuehaibing@huawei.com,
	weiyongjun1@huawei.com
Subject: Re: [PATCH next, v2] net: nsh: Use correct mac_offset to unwind gso
 skb in nsh_gso_segment()
Message-ID: <ZFoCnIIZdrdoht6T@corigine.com>
References: <20230509021924.554576-1-dongchenchen2@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509021924.554576-1-dongchenchen2@huawei.com>
X-ClientProxiedBy: AM0PR10CA0060.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5945:EE_
X-MS-Office365-Filtering-Correlation-Id: f83f1c04-a9fa-4bc5-43e1-08db506673d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Cih3rktRXEON/8tfos/IklqCbChtXIk62MJ4QJ4bdKxc7RhJ4J+6AA4BH7UXZWzmlxVXwjEpqtyJogb7a7s1THpFhapasY1q3Q3xLOqB5kaIyvNPYJ+IqVj8zRFl+/8Xv75f+W40JOohty5Ou8me4nnEdi9umzuDFqtJUEsQY2NsNRqP2ixE419ti88lq1sqex7M9stG+ic8BBpc0hzittezzSq+MpWUsRsiEnN0hN/wmiIWbAstuSuntxN+hXb4CRwtm3BZZlETzVZLr2jZgg9ne7kTtJTM//K0PWnceF/UhMOXHgs2/9FoxW7E6edQ6poZ+64lHNfRU6v+WmL4fSKv6pUzm0a9L4eufE4n2XvRFu4/CJbnOv8BFibie8XtcFfQFw7nTkwb/NIYBxRsdWT3gHUFbszB6y6ll8C5UmUCZBkpR7a5pm0YrJXpZBvk1Ja5Mp45KsOTlgSGLgqzj+i5djhRgMoxxeKAQt12ejxlYss3Bjc4mTQiVTrV+j0TuDL6Fp0+AufLehlP+/49PJYoHiwJ+Oz2e+QCwc1jxEQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(376002)(39840400004)(346002)(451199021)(966005)(66476007)(6916009)(478600001)(316002)(4326008)(6486002)(66946007)(66556008)(86362001)(36756003)(83380400001)(6506007)(2616005)(6512007)(6666004)(44832011)(5660300002)(2906002)(7416002)(41300700001)(8676002)(8936002)(38100700002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q32vWeYJgeARxVZrE25433ccC0ozYDm+ea+gXsH3c/iTjQarofqUWp12MThW?=
 =?us-ascii?Q?2c2mj/Jisr/R+I7OQ5ljgqzh5eIhnBrubXr2mXUNVsWOhjAghEt+4dU0bBMr?=
 =?us-ascii?Q?d3xbrSThbEEZdHQtO9tJMHIiXAeT3cykJbjR61e3T+ry+VU1Id62fCfUeyWL?=
 =?us-ascii?Q?co4OzoPeVpIxlbCah8ddm8ZVonMrz0vBtbzaw25/LwhvaRNa0o+D3rwBGHQo?=
 =?us-ascii?Q?CfkKpdE5q2YKlv/yt+2yE8WFrK66lvnL4Ypp+j2ECu8GyoHmFuLkFxDDglXD?=
 =?us-ascii?Q?x2XVLyiom3RFXgdQzkOwaQ/8HP8qWGGIZ+FA+0nw5XGpzfp8pSPUENaXIh6P?=
 =?us-ascii?Q?goXgTG59bBoCTbQDBVzJ/Q+I4QQ5R6L3reqY4oAkVJXivVKrMAffPC1WFf9/?=
 =?us-ascii?Q?8hOplSTiv6giKdKHdk8CEdpbITuyEy1ZI8tCHSmqhuAc0fxRyOp5eyNOOCfF?=
 =?us-ascii?Q?pzkv4vzn1dUtUnxNNYMRBHHQYAylrlYAsl2LJDZC0aqc1Wp2TfOOvRqUcknb?=
 =?us-ascii?Q?gwpS8jPv6sdTEjw1dArhMyJceBiawcRZaNiMyQoXB+ADJYXp3etxsCok3V95?=
 =?us-ascii?Q?JsZGjwfAdyliogM22YSmjUxCogNFRi7Pj7KjqDdZ8v/H1zbTgILSiy9ZyymO?=
 =?us-ascii?Q?v3w7gl+QuXh7xADJF8yS10BVwXSKE61PuYfPN/rP75wDkcDEDOMQemojMOvB?=
 =?us-ascii?Q?XQ4vMsJ0tvvv6HjyLEh6eWuT0v2BXWCLKfPIts2huoCvws5xUw0DXeVg18YI?=
 =?us-ascii?Q?BfMGfN9WGq9Ew2A+hktbTMq1wT07qIQFgz+GTwSajMdJL0GCOlwyjPxqJwyT?=
 =?us-ascii?Q?I4dHWafa4zNB32AoK0NxIWupNr0EN62VMGQApDjNCpIs6msPlOeV2ztSMCP2?=
 =?us-ascii?Q?O0rgqn8ovXQaJgk4MwMG58xLEaaUV9UYp/BCZ56dYOrimEEniqsqgKIFVpFR?=
 =?us-ascii?Q?YbzUw+QeuY2Q4Zr0HzvorkeTAqnlCCjsklSvIUz28k7WLkKqkmEfqJMdkOzK?=
 =?us-ascii?Q?86R14ZWg+pxTDcM2PBwJOrHgnY6kcwVVah8MFEtzyNLS+s8cHvhlyw3LzoYf?=
 =?us-ascii?Q?pOD6dzfcvgXTgOs3NsI9vl9oBMdgwyz2G/J0TDR5S+K5quHB/tIHLFh5qdQG?=
 =?us-ascii?Q?ODeHLRNEGoheHggBUk9ouCjhywGrJoJ5P7WDYtQvGAcdtaPgRmB0lxegHrvI?=
 =?us-ascii?Q?HzyymFZiKpY+HL869BS9bLZKsEBbte4Zj+rf0x4uTsN4+U3DlM4JhS4FR/xt?=
 =?us-ascii?Q?L5zUlTM8VOZQEwXBIMJb8gb3WTku5lDnqFRxXhecLMXil9Bh31+jk4Afw3cw?=
 =?us-ascii?Q?39B8Z62aXRuGN9zVhWwd7gjvoIFGlXbLQ033YxV8EujYHArtSjWKxflJFlJW?=
 =?us-ascii?Q?xfEMsqnvsAR3AySyNQ9Qo0WElZ2ip7vLAgceD4XLiOmFEsjaXwJha7+OTFt7?=
 =?us-ascii?Q?6VSO5W+045n6bOsvKs6Yi4LcFGyQ7ETNzRbIhw/nSDaPKX2ZzTWi8fYj8qMa?=
 =?us-ascii?Q?TwW62OU/mNgUPG+xYA8MpFSN2FcJJ+BGyz9YonkF/QIRgmJoQ1RDtcHOZWmA?=
 =?us-ascii?Q?D4Cp4y1UWEQYWcxUh6yF8LrYPog5h7hL11bjrb/ams9nABIPyBWcn9GrCz5l?=
 =?us-ascii?Q?7KpdmKMy136CuwcPKtCY4TUo7c1OjLnPaZ/s+foc9Xv+lfxwHDFoAUchNgkE?=
 =?us-ascii?Q?iW9cxQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f83f1c04-a9fa-4bc5-43e1-08db506673d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 08:21:56.6051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aaCnKzTeJgnYDKx7iGa5EE0grT7mu1RCisjNabIHyg1kgya90A1eUGdfSB9Yx5pO7aOuZtc8GaGnio9xdt5rE2THRnReg22R4FAtrzJa6qA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5945
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:19:24AM +0800, Dong Chenchen wrote:
> As the call trace shows, skb_panic was caused by wrong skb->mac_header
> in nsh_gso_segment():
> 
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> CPU: 3 PID: 2737 Comm: syz Not tainted 6.3.0-next-20230505 #1
> RIP: 0010:skb_panic+0xda/0xe0
> call Trace:
>  skb_push+0x91/0xa0
>  nsh_gso_segment+0x4f3/0x570
>  skb_mac_gso_segment+0x19e/0x270
>  __skb_gso_segment+0x1e8/0x3c0
>  validate_xmit_skb+0x452/0x890
>  validate_xmit_skb_list+0x99/0xd0
>  sch_direct_xmit+0x294/0x7c0
>  __dev_queue_xmit+0x16f0/0x1d70
>  packet_xmit+0x185/0x210
>  packet_snd+0xc15/0x1170
>  packet_sendmsg+0x7b/0xa0
>  sock_sendmsg+0x14f/0x160
> 
> The root cause is:
> nsh_gso_segment() use skb->network_header - nhoff to reset mac_header
> in skb_gso_error_unwind() if inner-layer protocol gso fails.
> However, skb->network_header may be reset by inner-layer protocol
> gso function e.g. mpls_gso_segment. skb->mac_header reset by the
> inaccurate network_header will be larger than skb headroom.
> 
> nsh_gso_segment
>     nhoff = skb->network_header - skb->mac_header;
>     __skb_pull(skb,nsh_len)
>     skb_mac_gso_segment
>         mpls_gso_segment
>             skb_reset_network_header(skb);//skb->network_header+=nsh_len
>             return -EINVAL;
>     skb_gso_error_unwind
>         skb_push(skb, nsh_len);
>         skb->mac_header = skb->network_header - nhoff;
>         // skb->mac_header > skb->headroom, cause skb_push panic
> 
> Use correct mac_offset to restore mac_header to fix it.
> 
> Fixes: c411ed854584 ("nsh: add GSO support")
> Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>

nit: As this is a fix it should probably be targeted at 'net'
     (as opposed to 'net-next'). This should be noted in the subject.

     Subject: [PATCH net v2]...

> ---
> v2:
>   - Use skb->mac_header not skb->network_header-nhoff for mac_offset.
> ---
>  net/nsh/nsh.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
> index e9ca007718b7..7eb536a9677f 100644
> --- a/net/nsh/nsh.c
> +++ b/net/nsh/nsh.c
> @@ -78,6 +78,7 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
>  {
>  	struct sk_buff *segs = ERR_PTR(-EINVAL);
>  	unsigned int nsh_len, mac_len;
> +	u16 mac_offset = skb->mac_header;

nit: It is generally preferred to arrange local variable in networking code
     from shortest line to longest - reverse xmas tree order.

     This can be verified using.
     https://github.com/ecree-solarflare/xmastree/blob/master/README

>  	__be16 proto;
>  	int nhoff;
>  
> @@ -108,8 +109,7 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
>  	segs = skb_mac_gso_segment(skb, features);
>  	if (IS_ERR_OR_NULL(segs)) {
>  		skb_gso_error_unwind(skb, htons(ETH_P_NSH), nsh_len,
> -				     skb->network_header - nhoff,
> -				     mac_len);
> +				     mac_offset, mac_len);
>  		goto out;
>  	}
>  
> -- 
> 2.25.1
> 
> 

