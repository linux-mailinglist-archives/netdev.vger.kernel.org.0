Return-Path: <netdev+bounces-4694-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42EAC70DF0E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:19:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F19B6280CB0
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2351F180;
	Tue, 23 May 2023 14:19:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082401E50F
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:19:24 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2100.outbound.protection.outlook.com [40.107.92.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9895EC4
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:19:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSciZLOZrm64PO+WKNnQVeJhuXG+Yhni9ivSD+153PNIpbmVF37//ok+kUDvm6JPer5QZsgWOcwkBFOELvB7H8/WW4Z513QCIw8+mvtWirynQDMw4LfO9U6TkBlPO/LmpgLG4TS0yiqcU0X0q1RdJ/cgZK0PxOQXEHODi+JVAvA0cCmNP9G/9x452pqunwU1BYZ7FOx5mouGUDn2t92ZwrRt21DRC2CEyzLpSJzMt2urXOQEcKRR35fwdl1N+7Kd0otfJA5zihG2FcmIYJNi3FgOvbISGgqX6gBU2urobzL0jr0nkeMD/O+0Qja/oIWYXyz/5KnI+YpfWmolY60GJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKrIhKGD92hxpwDnWsa6NjyUVyRQ1m4KX8hz/5gkv4M=;
 b=XBRWryFZdUdxc39f3nVy+m4UJPocWjE0lRi6mIlKiaF56Ep774xT7O7F3Cz3xt97jA3J3yxNWJShmjOih7PJTJGNzulLYNUSnTfZ3ASx6c0Ug6LiR0qHbtZ2yKX4/0qWY7vsKwTOqSks3plfiwsmTKQ0+Ga0QuK3Myl39UBkO0FrBQsM8ZGsWE//R9GGFEA9Z84fgorXys9nBnR8nhmxSV10EGOoZu7J/on3/aWVeu8NYb+byZUKFmTkc0SaF/+lrFX+w1UMLmp16/FS6M0hPDz+XQ1WTPEo7FV2TuDDwRACMLrdpL5F5HdRPBdFqA1FrfAKxn2N9lFvYzngFosSGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKrIhKGD92hxpwDnWsa6NjyUVyRQ1m4KX8hz/5gkv4M=;
 b=Yuu3Y1X9zSP643ruVTKAi5wDT6NvzLSqSNepbdtIFNY/9Re+YMJgAt4b0VEaEH2hc8i/HeMhLigVnFm8PfAd2rzPU19HKx0/yp2YCkj0KJkt7WswGaN28VyzuPOXN9Rug/6TKZyyGV66aGceS2yLY/kt8ZbKXiMo91kELIk+viM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5462.namprd13.prod.outlook.com (2603:10b6:303:195::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 14:19:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 14:19:18 +0000
Date: Tue, 23 May 2023 16:18:58 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, edumazet@google.com, leon@kernel.org,
	saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [patch net-next 1/3] devlink: remove duplicate port notification
Message-ID: <ZGzLUiGijlYMKJ8T@corigine.com>
References: <20230523123801.2007784-1-jiri@resnulli.us>
 <20230523123801.2007784-2-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523123801.2007784-2-jiri@resnulli.us>
X-ClientProxiedBy: AM3PR04CA0149.eurprd04.prod.outlook.com (2603:10a6:207::33)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5462:EE_
X-MS-Office365-Filtering-Correlation-Id: 077e425f-0b71-4d54-9e7f-08db5b98b1f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dOcX9OAqLtEUb41zKvTgslwoOKH3C4Uk8N1bxcj7S9X+J+PLuDHwmB5yVvHgihcJn98/J27JWll3RZnpkVacxlRiXFwxUKI7OJNskLr5s1CHLKQWF1dBByBqQoysxCzIErI+2i8V8OSU+svC/msR9J3PAPh/OpTWVbOY1DJDC7jecTzk/wMwEV5oCzFN15Xjq55VMI63Y7KvepndrP8qP5kH1JblhhJgdz5M0g6Vl3n1pxwHK9RJhl+VQ5qHt3zuMFx89LXuCemNOEhBUrLPEecwifGDSFfVhU6z5j1VvQA1LKISj9flyNUr095JAgdLb+73cUTAbfawfSzFykwp+qvg0r08xbLkC4pLkuUHztnJ4thLgalCD9NM0DbH1ztDpYyHpdXc0cmMl439VyyXLQLTxA7nyl+aJE5yPFydvYhFcEpPfOnGg/TviWsq8URu39nHpklTYSYibV516QTHP41jwHj0T4DblRi35W0YoWLHjxPybEn8iTJ8bP/6Ia/clCuesTPxxaGjdJoodGsKlbc9emj4dozyrvSq0IxUzR9YPJA6AJcihicjv8Su+nna
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(39840400004)(376002)(451199021)(41300700001)(6486002)(478600001)(316002)(4326008)(6916009)(6666004)(66946007)(66556008)(66476007)(86362001)(5660300002)(8936002)(8676002)(38100700002)(44832011)(2906002)(6512007)(6506007)(15650500001)(4744005)(186003)(83380400001)(2616005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3hAnGl8liiA4+qikb0k+QH/FrZftVF9JLl77mf4w6nMu+s8o6lc8lXhOim3X?=
 =?us-ascii?Q?j3aXhvttrfCi11nyDOWcil2hnXHhXr2ZDfLpO0ImjVhAEVjoGtRGCw71YA//?=
 =?us-ascii?Q?PPjU//kDXYL0YaoF2Nct0seJgKMV7YSpmWZ+amc7nZrOdtAE5uadxyN/V3lZ?=
 =?us-ascii?Q?TekEB6oXXWoEgCFGTfoWFKohL87O1JfDQd+ab9TjXxG6VziRRd02iVgcPajZ?=
 =?us-ascii?Q?5yNduZvO7MgQaMzhrnxki1bRhAreFLY/XTxM8ZMnphS0TPKpTdPBSM8dKewl?=
 =?us-ascii?Q?Jhx2wZanXcIWg8oywcZktax8/2KeYoykeSPmxm1k2/xnTxsdMZHhsKk2epeV?=
 =?us-ascii?Q?15K7qi8JopXpaOtmKgPhcJssCyWzFrYyQ9QvnnxzOghuT98yMeVKYa6eorXB?=
 =?us-ascii?Q?wtYMUm3z3nyJFi5D0CpvsuHjrytpRPFcZI+9NOqXQ0v4DbbD64aw6LY4wB9x?=
 =?us-ascii?Q?RBGxpCGOYhgMfXj7eqDtJOS73RFOJrBfOy0441UGFC10H/jak779TkQwP0Ci?=
 =?us-ascii?Q?7WOaxpBEmzakY2HoYnbVEmYsTBYvbeEJgndezl8GbPOG4LARuIJKjCXj1xWa?=
 =?us-ascii?Q?iFMUBcHsZ1HiQXLTONQutLNetVRbRTyclop1JRaYbLpEPZ2/RnsrNbQtcDdL?=
 =?us-ascii?Q?JXQx3LdJ/YpF1J+R1L6quGCDE2JBOprwqk2Tmu8VXXbrs+8G8YTx8+xntAuq?=
 =?us-ascii?Q?VM9FaV49wbSg++0wHEqlH29u3wZ/bENHV8qsba4Vfia2q0gbdhAcVak7A1rb?=
 =?us-ascii?Q?uX5wZOXSO/K0tMIQy7UgNld3E4CrFY9u6NzeERhXAgu8/1GegeWQemzWyAPd?=
 =?us-ascii?Q?pCbM+ir4zVG5h7Z7lgQMQD+7dfYwDcl1MnP/tCuCQwQs1a6HzVveFVA75aEQ?=
 =?us-ascii?Q?BloznXC2HI+ZGMUwA1gtIx4tL5wiyv4y1N1pIAWhaOFg5+DbJ7cIazYzCvfe?=
 =?us-ascii?Q?GppwjWhnGaQRrYZEDsV8BAKWLpGJYKuYz/Q4ok4hGCb+jX1NPj77Mto+vZds?=
 =?us-ascii?Q?+i7Rby+oKYfueAA7CrWeS+f2GEMfG/C0l0Y/Yld6X37QYZcF8TwXrkWh4W/a?=
 =?us-ascii?Q?IaAlXcZfGhp5lAlwgnsM7HvLmGYaxOH4xweO3o0r98goZMe5xcUoj6kH3g/9?=
 =?us-ascii?Q?WEmFlG1T5PQtp+e0xtagRkvZ8ykFBTalVvx5GF3MjZhQTY9o+A5BJWO7p2Ft?=
 =?us-ascii?Q?MDn3vb35bMaEZ2nDFAS94FZcqWKuS4XQl6qDnNxwflyTZH7adcF2PaFiglSR?=
 =?us-ascii?Q?DNTFF6OLWj1ffys4+RnLdYG7QKVBPf7fjKYMv9irM5mQgknC4gJ/YQWKmd82?=
 =?us-ascii?Q?JapZh0elAJVYOWWIwzd8VZKex7mOS3h9/JGcb9QwqzpuI+5agFEGvzyljYGd?=
 =?us-ascii?Q?9ozH3EzaUM6zXFI9TvCi3j4sa4csTMqpMpTGcnqWUtn9kpI6DYJM3VQ3bsCB?=
 =?us-ascii?Q?F7Ctm+ArGhdzpCoDCIin7ytqt3vxE9md4MUBMfBxiL2Q3jD/yb5swnmsM+K4?=
 =?us-ascii?Q?mviK+gCtWnAv6sjCnSVdnFTfL2N7yXFsKh+w9B6PKx6OOn0gxtflLeccl8fM?=
 =?us-ascii?Q?WZ2ZqkXHR5CyPJxRHoh0Nqgrb7JP6T8KxlT3miiGmhuFkbO+RnKes3XkoqUm?=
 =?us-ascii?Q?ktNBOSEEObBIlV1Wcf8u2EMvym63nVYYp4zd/wx6WhTa3UixgsoOyyGZzZpl?=
 =?us-ascii?Q?MqFTKg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 077e425f-0b71-4d54-9e7f-08db5b98b1f5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 14:19:18.6319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qR2rGDAHsDoBZndhgm/+PBCHHi7jH0FBkgPLSA3G/9O5TCHnghVwnoIsewKvZbbxxsENyWno8TTsO6YhPDlvW0MbgiT4bBqrli04jvmISl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5462
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 02:37:59PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The notification about created port is send from devl_port_register()
> function called from ops->port_new(). No need to send it again here,
> so remove the call and the helper function.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


