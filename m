Return-Path: <netdev+bounces-5269-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF46F7107C6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:42:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A360B2814AA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0CFD2EC;
	Thu, 25 May 2023 08:42:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEE1849C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:42:15 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2097.outbound.protection.outlook.com [40.107.223.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D0098;
	Thu, 25 May 2023 01:42:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5YXiTWEsvmex67md8BwAJdg6FczSx+nuKqhDM+7Z74SFiqkVo4xnGEFX6kG8dexuPQXBPCPv8bGPptKiS4A7WlSlsJ/YITDrDTO95KCvKbS96jllJsqkDKuSKq70HFBeETN3PWJasYpxK1m7nB/DFjFoAwhPDCJ5fOJ4OVGd6h0LM7jnW/cdAs9SqkN/rC4oXCIfgxgcoaMSn+iMMveyyJdafndnoSw+UmdnWNGMDMJmiMxWgnNGcPVNz7LvG+VcxrFjjRnuTtUbETMuEU/u85fBUwPLik5eYYTh50suYsKNcMu45W7B0tZUOkhL2n1rVn/FLosKSgCSiTT7pRB4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1HT892CLuzD4hfM98I2wxw1A8Mlh5/bZjCfnftXtWc=;
 b=V4l10abohYYsYaGjeY3BbBBZscQgLjPaFF18/5O+hbNwcWYfoc5jQyJi/WiDfVNsYj4h5mDBKDOIGSFhQzw2g/pfGlTIfALvcST1ksU+DdEUpX7afLaji9/PbEStBj0TkpilAsMtjq/LgKIsGPzHZ60Xa06OSWilHbAtuPWaDpYyUuHnqgTisgbnxweL5N72PLhgfcXVohm3uAbuxCZIMMs14QNaRtYLDW37LRCjVQxddeQVF0j76bkawUCTo4sK/f7ilL85mk4xSvuOF3ou3ys9NkfDfeIiyq+V2YqAdljlPkL5be4ygsi126wHHa2oxG0qNcfKoyIWxnGPk8y6Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1HT892CLuzD4hfM98I2wxw1A8Mlh5/bZjCfnftXtWc=;
 b=O95Uu/PIIwdY9wmr6fo7KUfd+0R+dNnJ5YgRe2xW/anvP7VYDxGBBQc6D/br1xNfxAy1vSAbUldNlso2Ptf+ptbrbe90RIQ0hwoQuIx0vKsUlT0g+48m4M+DLMccRD+uhW15744gFX7DStXUJjJYMiufMlFsvUkoHh31/JbMnlc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4619.namprd13.prod.outlook.com (2603:10b6:610:c9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Thu, 25 May
 2023 08:42:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 08:42:10 +0000
Date: Thu, 25 May 2023 10:42:02 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, Liming Sun <limings@nvidia.com>,
	David Thompson <davthompson@nvidia.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: mellanox: mlxbf_gige: Fix skb_panic splat
 under memory pressure
Message-ID: <ZG8fWujTDjxRXZKn@corigine.com>
References: <20230524194908.147145-1-tbogendoerfer@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524194908.147145-1-tbogendoerfer@suse.de>
X-ClientProxiedBy: AM0PR04CA0072.eurprd04.prod.outlook.com
 (2603:10a6:208:1::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4619:EE_
X-MS-Office365-Filtering-Correlation-Id: e0e5aa48-8cd4-4f8c-d1fe-08db5cfbed85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WWCEEDa2b5ctVETjkS3nP7ckUU3CUTWvTwZUwJUZ8DIF1tKpkuxiv3Uy4dWlH4lXyTIRUQlaMLs3rlYJgW6mq3fILqJK9gRj0CmurV+ztKzgN/o71gC0KB1qPaKKtNusFtmOWRUa8LhmJWJa9mLAsmSVfePrXBYQq1HsO0Ore1SiO3xupqM+nxXrdS4dfNcwQhC9BGF1WjYiYg3ac6iCiDuce5d56CfLMVyYWP1mqGzwNGVUHUkoKMJbMDUE9GucFXC991XCVMZtc8THtrYxyGYr2CRpHvOLXB+Pub9CfaTGYGnEzTa9ywPq15LVwbgIdPfrQ6wAAzyv0YxBi/V8DkFGpDgH+UOjqhB0GhtbYxjS/1N8U1PaaqDZMoQwiYIFYZau7BpmxIfBsnbSWMVn7hx4wXuouW3voLMd7q7VO/cX1QVd78h1rzQAQ2OM9DzZsqHz9gp3gQwW2zZILoCQh9A/CVtNh5j+xJzcoOFUoFrL2/kGLWjKcbb8O9Ur/6DW+St3kpSMWkLDg8bnauDgf/w1UKAPjWzXFD7y5RYCbhdEI6Cr/kwPKfZ3nhedb6T4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(346002)(396003)(136003)(376002)(451199021)(2906002)(4744005)(5660300002)(44832011)(7416002)(8676002)(8936002)(6486002)(66946007)(41300700001)(6916009)(4326008)(66476007)(54906003)(36756003)(316002)(478600001)(66556008)(6666004)(86362001)(2616005)(6506007)(6512007)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GvU5ETckDjjuLpO1FuZjOjGDmP2wnUi9AW5ARzvaqecTfq9IVP+JL26mpJNC?=
 =?us-ascii?Q?0rAvvOjT2URKF/qPhC6Zf1IIAPk9Jt0WCQELH+ilTjQDADw6kiJSp62oGXV/?=
 =?us-ascii?Q?CRvkqNFTQMGCYsJfHzPm7Pr4OraVUvOmWr4/FW6h9OFrqwdfea8WwQj2y5iA?=
 =?us-ascii?Q?5ea4G58DcWiJPp9pT2j8XT21shrsqCKd1kbL9ssF/yyTJOVTvvhMhkkiWPfZ?=
 =?us-ascii?Q?yEcM77JrLU1hJqS/A/GjX0mn9qpQ9+hIifLPz3aSe6kQ9cXmyK0gnlJMeM+B?=
 =?us-ascii?Q?k1n3cHes53nk61KrcpN1NKUbD6gFDNtx8tvF2LD6dpcFBcG8Xw2ZWKG65Fi0?=
 =?us-ascii?Q?yo0Ulg4PMK7v9V9qn3l0akLG22D1Tu4bsXWR/O0kBlqduZHOKRMd7KFEANlf?=
 =?us-ascii?Q?aHupc60h3mghH3bEtTiBkF8E9BhZDN5NJSHyHMQgFxCSlnfWb9D+W5tsJsgX?=
 =?us-ascii?Q?55FznSKfQ+USNBcTIEmENXZBD19wDpoFJlbt+JeeYsng+GoUg2cslOqTIMWx?=
 =?us-ascii?Q?0hWIjJ9NLrWiZr+JKkBgPvu+adv/e5+8CaEQtZhNJbKhcVY2NScaeC4lztpF?=
 =?us-ascii?Q?mt42wpDP30MfU6f5HwuUgXu04ovo99x2WsOr7xkGs6slBGXvhcIcyd3IcwR/?=
 =?us-ascii?Q?4an69+dS6iFPMQFdPIbIZ3Opb8glrVJBbZz1oKugL85DIL00tWD58tEPmXYO?=
 =?us-ascii?Q?086hGpKaFlGjJwt71wETAyM5lYzqVxeU3T+3CwMEOoZM68gclcVOhJirEtE0?=
 =?us-ascii?Q?yVKEfA1mXmj0ZEX/qKgyyhyOhtI7bQL4wmvBS5M62PjO9Rq5HKaYWRUGeYNZ?=
 =?us-ascii?Q?RgG1+CGCc/lY8To6ZR/JnDn/qOnSXNvAfpYQaMYZteUOrnjrQCP6qeEgffrD?=
 =?us-ascii?Q?iwBDocpmbL2a4un8mTBTLnpv1x1gv9Zp17qTkWwkavbSZRQ5dtOt9kCHEYRo?=
 =?us-ascii?Q?Nb7pCXoQRbjmq5zyURmFUCIoL75/ykrWygDdgiUU/IexR2+kQj/LlIlnUXWq?=
 =?us-ascii?Q?mspoK3TKa3z1uFX3Y5klBVYdhg+oTCkUH3GnVjFL7WTMuqbLu97CWqBKoU3P?=
 =?us-ascii?Q?3aJoLw6HUkm7tco3w78ltyRdWOP4p5hGTp/whsIYf7N59DtT9UBNH4K1lzb9?=
 =?us-ascii?Q?tnYt1SinRlV+wz4sAz8kqvFm27C7NPFP0JoDLdxOFjr8VUxw8aHFzQiTdIhB?=
 =?us-ascii?Q?zkXxshj817goX3X4lbt8FKHFb7FyUnu7dBaeSj9kyCBOpQchbQi1PqOizZ8E?=
 =?us-ascii?Q?uCft+NxYt+TK32JgK7Xx1UL+AZi0rnCgRmCK4e5Y4m0XeTg2XWPVGapVys9r?=
 =?us-ascii?Q?PSNUKycz3OF/RjSFF7tDapfllWPM52BpM3eFlN+z8U7djA4CgIbubT4kstx5?=
 =?us-ascii?Q?/ruwb5EVSca5aV3506HcTeO7GcR0YMhCKiwkXFUsxkla/T3wzSsaV7uPYNLt?=
 =?us-ascii?Q?YVBtijG0yTMzE4ao13diJqDE8+LMI9R6tMgkI4YuOoHqGuOYcwck8GnHcYRZ?=
 =?us-ascii?Q?51csqt+y1cQNL70H40rDdCFbh+SMAS2w4oVyJmwHahKbCR8/D1R0U+IhTP1K?=
 =?us-ascii?Q?c46HWybYpCriAeY2ezaShFXLS04+9INzQRpwx7/wykq8d4jWXm4aArkgx4GI?=
 =?us-ascii?Q?1y5x1iJ0EyO+jaVfoxJ+Hoe4XdzDMaBrnfsZTcOJHXgWlhznPfo/B5hkrKmM?=
 =?us-ascii?Q?oUVdOg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0e5aa48-8cd4-4f8c-d1fe-08db5cfbed85
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 08:42:09.9168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3DMcaAAy1KS3q9zCda2VgigGu9EQg2qe+25dnpjgMjj0Kix/RLbKJQ4kIceelT/qAZTY0j4vvctWynWp3f46iHhWLH9YS0uFGVFAb+GV2N0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4619
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 09:49:08PM +0200, Thomas Bogendoerfer wrote:
> Do skb_put() after a new skb has been successfully allocated otherwise
> the reused skb leads to skb_panics or incorrect packet sizes.
> 
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


