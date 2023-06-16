Return-Path: <netdev+bounces-11351-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0792732B2F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1A281C20A92
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A38F9DDC9;
	Fri, 16 Jun 2023 09:12:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E2363D5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:12:00 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2122.outbound.protection.outlook.com [40.107.237.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1C6273F
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:11:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrxcWEUz5lOaGHT1Co7RRPcr1BiNIoHOLu11EJ0cQLt3FwQpCMhSryy76IkzFYxoDDBYcio0W5zGvSUmQAlx2lsc2mmgHhCipsoGEVEeQ951iBYnt554OU/tClL5LEyiFjnCwPBrH8ATqFa1J29Bej/I5udSZodAMmWdDFssvszfrCcYkNn+S0MXshl+3/AWiAsKFz98oy1wHPwyMgE2Mbr52Bqkz4zieAQOIlAjRLlFoQ7PkWcx3L/XsIEobHzdKbHHIefCwLSf9VfFG6EotUZw+pUTOqtPmW2aYTRSoafYxmvfcEfVKn4XuD0gZ5GemK2lHa6AEKPNShqd0RSF5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hc/75n1iuMSzBpBQWohFi0f6EnH/fHWP/wfNLCmm5N4=;
 b=Te4SI7zNfm6hI1ckxnZ/gAydL53sJalIC++o/Flq0b1vTUJd8WfrsRCXgH8mwW+aV6hmI/r9l6LqpOfRRiIwswVnLt4UIJSqooG6v3UkU+FE/VJmD62CjHoUjP+JGfN/Z5c16N7wlU4OjWZbTi3eAc//cuhdw/W45mz6FVZ/W6GZY70tST1yQD6OuphI3uLg09hhlopW9FT04b4I0VpjlgDvQmnmeUxdr96/NdIS7cU0RCaCNNXbcRTxWiEoH7PP3Gky+jjWGVta66dWDlUwy7KBUjwJ6PF/hs766/75O4/YGFHxzfhVq/zI4Zv2aWYlrBQZdFDPztzOgBcG7Be5qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hc/75n1iuMSzBpBQWohFi0f6EnH/fHWP/wfNLCmm5N4=;
 b=VkLeKfFw/xCNQKXt801pxc+uEq5seFhczbvOCOHsYFKEOAMfA4PF+arb0Q4ITImLNeKleIqUgqtdeATcnVklByH+cRKfxMMQV+MPX9i+LXECcivAZ7LlNBQvfpIHFmPMrSKa+ShCbqlAZDth47cbImvzgxzfYJxOl8y5iLAgSjo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4902.namprd13.prod.outlook.com (2603:10b6:303:f0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 09:11:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 09:11:55 +0000
Date: Fri, 16 Jun 2023 11:11:48 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Cambda Zhu <cambda@linux.alibaba.com>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Lu Wei <luwei32@huawei.com>, "t.feng" <fengtao40@huawei.com>,
	Xin Long <lucien.xin@gmail.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>
Subject: Re: [PATCH net v1] ipvlan: Fix return value of ipvlan_queue_xmit()
Message-ID: <ZIwnVEiGlLgD1qcG@corigine.com>
References: <20230616063436.28760-1-cambda@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616063436.28760-1-cambda@linux.alibaba.com>
X-ClientProxiedBy: AM0PR02CA0113.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4902:EE_
X-MS-Office365-Filtering-Correlation-Id: f4ad9da9-d559-4640-a2c0-08db6e49babd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3v0s9PaFofTwVORarvOazx/jGUelomoe2XolwotiJx+zSUvP5fm1MMuUDyaK7+hbxov9uXWR7Yn3/z4HQAa0+HodI4oCttASH8xcZIL4jxTNdTmFIJ+OpQ3WfbeK6AMQ/k9+QKuV8rhq6lkpKwnmIoH/P36ukthjnWaRbajEYDub7LQC7OKBC4cyi6ZCbmFprJFKaq1YnFeDX4sYxn5ORi3YDaPxJjzo5ppWnG3/tsVD47bO+4GC5O1CjMUquBcw5O7ZMdU5/TFN5qfscq0Zed5qHPGRBsXxLb+2jD0OALx5cprCyFoI3rqd6S3/YtQuBVvx9b6NMXk/eYA2yZ3QhSL9K+IOhFzS6s1pNiDerfKYPpf7yXkwWi6+uhrnrbYoSIRKMI0nSSsYKD/9dPYo7HLq9IbimslvnJR74Z6jYnIUq42pJLOXc6pfk94OyBUmRo8WMPqBiTFbd5xhHJWOf234E/GiP0brHA+ULE7tkZ/B/KiW2qxfDmPAZNbtfMUAuBz9cAsVmcOVyNo8rQV46DuKbWprms3+oZ/ct+Cx6Nyc0q1G/etvYxBevb44lLAFPxueF6lThkGvY60SRUzbUkC+AUHs1zyfuVAKCdJ1nFtTJUo2SRBYzGtbCu3/7ZElJh0UfoH3WQkOHe+Tu59aoD/2nsnK+O4CQZQAJo0e2ZA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39840400004)(376002)(346002)(451199021)(2906002)(4744005)(6512007)(186003)(83380400001)(2616005)(6916009)(66476007)(66556008)(66946007)(4326008)(8936002)(41300700001)(6486002)(8676002)(316002)(6666004)(54906003)(36756003)(478600001)(38100700002)(86362001)(44832011)(7416002)(6506007)(5660300002)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7q2CiY4fwMvNWuC6VTwSCx5ZsbJTBd3sSrxsFntZnkkkm4zwVMxV8Rf8y+vO?=
 =?us-ascii?Q?vcuCy2Jh6ywP7hHsck3BAkmmaiFDw67+L48T4AvHbgHjXhaQTBF2QAXdBXy+?=
 =?us-ascii?Q?k4iSXfHfeGCxfUhXt4pOkLDisbiqVfchBfcv7anA9sUm2Qfkcc4f8VV5mdba?=
 =?us-ascii?Q?kKG0ZDynULTaw61lTxp8HU30NoH8J5OAc/hY+KAO+sh/lquw/zoMFdn7GFl8?=
 =?us-ascii?Q?Ru2KLwk/bk5QK+oL+ObM8x3I+r2tUx5z5MdUU195oKC+bcMCL8JPChzIFj7Z?=
 =?us-ascii?Q?sNpJBDtsBFn6zP8OfXjW4H4r4dpVcGNNxvmXOWX7piZ4FI9myxtpYsjrfang?=
 =?us-ascii?Q?s/qCazoL2anAy8FOc1Irn+2ogxZu9AWQroqrNX3WpL8LNw8HhI1euH0cB5oJ?=
 =?us-ascii?Q?b2UsCYyb910hoPzie0Lq/yzz1/i9uOR3QTDEVBAK7KStirtd2bWOz91OLAqs?=
 =?us-ascii?Q?JgRq+Q6O/pkuU/U/fC54CF4ShjcEcaUVKLgWYEkfKWsrkgTfw03ZJW27Rz5z?=
 =?us-ascii?Q?/WYd7pO55O46Gxc6inoZ63M6LgowhkuxFTlIJMR59TbGEC2UPwgGpyWIEnHK?=
 =?us-ascii?Q?x/j6L6Gsvm6FoZxVjJjDri5DdGZZSVbn8wqTnJ5taacXfv55kiwPDt+LSYBZ?=
 =?us-ascii?Q?MTfofVlP6VpJhEutTpnUf21gE+thrsNDXrpkFgGmV/BkZqEoIJEssFIp9l9E?=
 =?us-ascii?Q?7TI9Cp+2s1XdST6UOzeOJ5fVMu1jkBDNasJ4CFauqVYtlKmg6dGw73zgOQAc?=
 =?us-ascii?Q?gEuAyuwR8kGLWOb00XPIVxz6B2iah87Fty1DVVhMYu4gx4shrcVts0EkFb/o?=
 =?us-ascii?Q?IgrhOAu9vGQT9ydSVRjmCzwrqyaoX9CQKRlXpw4OCTND51+BIdtk/BBU3tHs?=
 =?us-ascii?Q?JNweCiZVutBmedHvY78WzsTuQuyRklls3oGCXL9LrscgT7Ql+ErfDbWhi5YL?=
 =?us-ascii?Q?ht9ZoT0gKkehgmjFNmj3AA6lYy5TYG/ViZDpB5LT3hxas8EdgtUA61EVkk3B?=
 =?us-ascii?Q?0AlmaB682SyiuWqMRqtJ5kQqc2l+vR7bKaDL/kIblMbrftoa27/+xEGCrTLz?=
 =?us-ascii?Q?jcEH+zaOKsKfzzEP51znHeTZeigLXKSc1NEbJ/TVyoNO2Kh4roUjZZ5gWGBk?=
 =?us-ascii?Q?4qzU2WSYAscACEI5rJt3mqXV4dMv+t+u+YRbOgOEqu4nb/y5ffDcHl02xQ0D?=
 =?us-ascii?Q?8UmW5xsoFmO5lhScTBOvNn97tV/pT4lno6prmkzvA22PQLmY3J3TEUjALu3o?=
 =?us-ascii?Q?eYSlwoLdug3doPQDwsFjNlSzAXAn89A+luC/chlKiscIixPOsTK2lYGYAEWa?=
 =?us-ascii?Q?3IbPa76vA0r01RGzR1jyWghiOKCGn4Y1/gMECCpqBaovATQuqyV0QW4VpkVl?=
 =?us-ascii?Q?hvZO9O5LzVSAaSKvHjPNiaALcBXkURkiSQgcls+GrifqGXp8X4zBTB/D+ttO?=
 =?us-ascii?Q?zjjwFmtYFaldXAYpO2iqrFmuzNDkikwE8eblyfu/ztI0TC1nhFP6tbOlmCFw?=
 =?us-ascii?Q?FmPuB0yADNeoafBJaUX3egYFIIbSPR9eFT8cc0l0itcT/E3PMegqE0K9q7ZF?=
 =?us-ascii?Q?wB/pCYwdN2BYD6NkpYCdxP1rWuWJWKIdGmkelGEYL/EEpg+FT0KABWhi/ffp?=
 =?us-ascii?Q?unkGPvuuMEhO+TPYd/2QwSs68LlUGD+nZU9NZxwGQfSn6ZWFOrwOR5SR3cwW?=
 =?us-ascii?Q?80b3kg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4ad9da9-d559-4640-a2c0-08db6e49babd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 09:11:54.9388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MK6pVounmT0bOR0+dCENoOi7kENKTRgGeQr1cNLrVracCFY4A8o/F6TPz82EH7rFcjn1T+nIqWByr41LkaSox+TSEuadGTS5bHDWqrhQZy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4902
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 02:34:36PM +0800, Cambda Zhu wrote:
> The ipvlan_queue_xmit() should return NET_XMIT_XXX,
> but ipvlan_xmit_mode_l2/l3() returns rx_handler_result_t or NET_RX_XXX
> in some cases. The skb to forward could be treated as xmitted
> successfully.
> 
> Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>

Hi Cambda Zhu,

ipvlan_rcv_frame can return two distinct values - RX_HANDLER_CONSUMED and
RX_HANDLER_ANOTHER. Is it correct to treat these both as NET_XMIT_SUCCESS
in the xmit path? If so, perhaps it would be useful to explain why
in the commit message.

