Return-Path: <netdev+bounces-8916-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4821E726477
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:26:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EEB81C20D88
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838BB33C89;
	Wed,  7 Jun 2023 15:26:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715E31ACB5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:26:45 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20701.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::701])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74417213A;
	Wed,  7 Jun 2023 08:26:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxX+GKH1fK4d/DuOLHLXhZjHY2BEZIrUkL5dWIjBnhqQ2LYL17h1u6G4TqWRFexsJuYPXvbYrjUkhrGaQyNkJFNo8jQjAPuruIrxzhb36Tp9Wd1u59ljWtY+KmM4q1Ls/7NHWzeDDps99sPAQBGYlE1y593b1v5A0/jkceunQoMUpFQiI8O4vuI8ocsOcRW3pVkpsgn9WqzDk5DfYhArwBAuNmfqNPZCjSRU/kJqeccJgyi7BeAwskEYLT4YCigi9o4dfW9pTvpB08VBGrCp0phvVozgDH7CY/Ufsflx8BwlpRLO/Xm72IeNAzc4MdJcMJWhgBb+saScuOD66l6o3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdGs+UP+tZtUpZHUFqOu72LeoR349IV+SKtaB4r8TH4=;
 b=UKtLXcmKlVOimG4eGw5yvqrJe6Dix9SxlSgZhhzV7JFzzfCj+6HYE9Trn+5SaeFfihnhb7bXZFzU3//RT7zcaZ3iaQ4vI6xMTfNB6BAoGn8eMonPELqkx4h7e0I3ZHnABQgrn2Pr6JNalwhH27u8D28gCxd65y3rnnPDoL7x9Jo+wHTaGtq3pj/iDNvaL2xVO3tHxITwKQ1dlQ581IgBJPgrexi0u69nQrnmwXKxDTo5pIn33FqWzzNTe8Fi0iBJD6GMLX7CI1clTcJOSiEpUeeu64qZnHkS7cm8ogkrRkPGUsbZQE2sXr9P57VE1kzSzT7c+yoKhVPcJ2Li0o0wNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdGs+UP+tZtUpZHUFqOu72LeoR349IV+SKtaB4r8TH4=;
 b=jqMVo2q0/mnpsv0z759zC9fKtJwkKC/3DgDshSbl0Mz48qlCXFm7dRynoXfHiUxfvUOKTQkB9VRVktijVBfEtrmfYTFjr1IyOl3b6vxho/K3l+EPjJ/ozUJdSNw1sEwMfPi4/gXLBlccp1igxCJm45WieAFstb9GC1vEKAzrnZ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BY1PR13MB6261.namprd13.prod.outlook.com (2603:10b6:a03:52f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 15:25:49 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.037; Wed, 7 Jun 2023
 15:25:49 +0000
Date: Wed, 7 Jun 2023 17:25:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Phong Hoang <phong.hoang.wz@renesas.com>
Subject: Re: [PATCH net v2] net: renesas: rswitch: Fix timestamp feature
 after all descriptors are used
Message-ID: <ZIChdcJ1e2cl5epK@corigine.com>
References: <20230607070141.1795982-1-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607070141.1795982-1-yoshihiro.shimoda.uh@renesas.com>
X-ClientProxiedBy: AM9P192CA0014.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::19) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|BY1PR13MB6261:EE_
X-MS-Office365-Filtering-Correlation-Id: edefac6f-274a-473f-052e-08db676b78cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tYxzbtpF7WgcN3fqMoVJixqVdf9zF3dzsdJQ4mFAR8h5WDG82N7DomToj/cGQsOPkfNOEOlGrCzBj+MgupAW06bYqnr0cKa4ylmfDUOGj1a6J/esfiNxF3Ucup/CQFvUilB4ed1aTF00P956bXIE9yHGWVgrtxtyb9jPRYH7WKUNISgSUDbBLPl2SwwHCujk//BXTg7EoUCTsKEIJNIyyqYT+6R9KThkF1k6I4KoP41J/Cng5j4JCxSH6PkWaVmEg7ks/SdoFzuEMq+4DNCbvPOEFQAaOTGzmFsnGkPyNMlJvT7dl9o5nXrMJjd3HfljWKms1Ld6PvC73sVEjFSruXkht78dBq8+/dHd4McI8y3XVMMacGlBxkwqtYUBrQcGU/UZJwXztXck3xL5s+x1wt0AKcAoXbRkn1dv7vfCDu9yyMIcxW5EZYZBM9pqS+zAMqIlTuwpgT+IFXfHp7zZiO8HR1NyzVNbMUGDtFaAuBnVJHGLeO6579YblT8Z2yehYNILqlqqG1wMdlmVtzLkne5gg5KMWFtfXdVsLmCcUed9PpnRLL4D2rb/vHIxDQG6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39840400004)(346002)(376002)(451199021)(6506007)(6666004)(6512007)(2616005)(478600001)(186003)(6486002)(66556008)(66946007)(4326008)(6916009)(66476007)(316002)(38100700002)(8676002)(8936002)(44832011)(5660300002)(2906002)(4744005)(86362001)(36756003)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OujqBLvPz4ciQ5pvMWPVVrncw76AOd90pTjIAk+2hPN35rOcT12I70nNagpv?=
 =?us-ascii?Q?WfzwuEeTI/DWSAHgWZprt+WdTwpxZZOaOLfOSpDjVVgvH0OM/AH1JTVGa3Ht?=
 =?us-ascii?Q?OP2xBfO1AZQessuIpeMf3SPx06R6/VGctNhEtA6Buw7KZvjRMggirxcY7OPt?=
 =?us-ascii?Q?9SsiqOAt7FQR2XgbUFU2Ocog44G3Esr7z9et6I3UaKKQOdnzGtlmSu/7H8ya?=
 =?us-ascii?Q?uT1iakTqRQxLlF8ZF3LgFB58b8Xzd4nyhzUp/Q+FBYNuOWkYgWx92AmJeTnI?=
 =?us-ascii?Q?J5J7QSN4Cc7JWAUx8XCgkvZCnMAyMic5/Pej7qRXpy5D1VbLs1y5FUY2kQdZ?=
 =?us-ascii?Q?1Gsuso1rJiIczB+C4t2qTnpEJhVv+ZDPWDbAeMTlkZKLz9NN+xu897EeKJH8?=
 =?us-ascii?Q?JMJH4HlrYdiDec7iv+NKHTzmp0v48cjL8aePDmJQr5awwEMZi26JuhChXXEb?=
 =?us-ascii?Q?CEXusuNESqhmZhjNnw3/H8LrWi89BWpgX2AIhT7SmaUMsw5mq6YRtWf9gFir?=
 =?us-ascii?Q?Ihwsyx6hkjCrJ5z7l60JXWCfkVzMYHj75sh6TybKnVUS0830fJL+thjp7sam?=
 =?us-ascii?Q?AYrclxEXgu/rpwn0/OnrPp6tR3oijz1as4X8UUcuZ3c2FkT9MtQ0ri3LdQ2H?=
 =?us-ascii?Q?OIBCKCGgEWebIkgW8oyJCba3e8x0uC/6nlPrn3kjCsZnXanwm4Y1IJdpFiZ3?=
 =?us-ascii?Q?kwEyCsARU9XPJIB49XWN9pG0NQgGqWAxa64AuSJcOQMznu23VmqsZiTK+xa9?=
 =?us-ascii?Q?7YXESLVk/+GMb87aSOPTlqKb8JKHaWaUJyFgkTJpv9VcUpOa1LAR6OMuIs8Q?=
 =?us-ascii?Q?VuY9hPa4bizSVq+J7+dMBxKrmGLK0FsBTHvuJBARuGDgOpNg6XIychudaUw2?=
 =?us-ascii?Q?NrEXhN6mgmNlPqwCNWY5Vr1E3PEK81Nw4b3SctACygOuK+zhd/Bphi0+1guJ?=
 =?us-ascii?Q?XNyefraLfJOnCTH+dNsU40H5TmGGptAUbvMLTDQJjZOpsKbBGVwIgX1pPReg?=
 =?us-ascii?Q?8oGooSyyPcK564pMKpFZS0HV9t0u3Qxyl5op9ADVX+kHyotAuK0UiPRamd1g?=
 =?us-ascii?Q?8bn5LquMQe8Lyw5mylocacFfUZaaP9m+Z3ndzXHn1UEsUQGZuE2NbqHeghgT?=
 =?us-ascii?Q?4k0So6a6tzv1UiMJcbruGh/6+4c4HTQMCbeY+0qBN8ANDtxMIY2ySoYfsshD?=
 =?us-ascii?Q?Er8cT5DPbI+zxnsGY5KE1i6xT6DDu9y1vCuMtXXZb9NNH6htfhHo2MTQMuNM?=
 =?us-ascii?Q?h4Fz/sCc3GVPSuFbRbsxJ5Ug+Kzww8UkOJ/ix62Ulhk5xjoyi+iGEoKAmJpv?=
 =?us-ascii?Q?Tygrsg5S+1y8dvQbAF6Ttcpjdn708TJhDQef/moEWcXQj0bmFvjnoNXj22Se?=
 =?us-ascii?Q?6ZzdUgEYVvRcZY+hObvfhSXdwtAOUtgGRnxsydLHDJtT7uiC5J7fUQ7Sz8Gz?=
 =?us-ascii?Q?0JuxAiIh+VQIQx2KM6w1QbxJEfSslX99kHJ0YlO2KwjN2Jf7pP1dz1JVOk3P?=
 =?us-ascii?Q?5EfHiD2DJ4Nk3xdoh93+rTcyrxtz1RgmLckeLM+GJauZQlIDdNCMKWGJ1pgv?=
 =?us-ascii?Q?mnGJhE6VG+a+zWiv6Kjnk86sPC7YCjzCzW8SvFcORqYm3plWkwzT0NXwaYJq?=
 =?us-ascii?Q?F1sbxZERKuh2y0AmLvq6g4Iw/3F+2MnvweQtaltXkJJokovDdkrK1jXlBHkT?=
 =?us-ascii?Q?xQ1r3A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edefac6f-274a-473f-052e-08db676b78cc
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 15:25:49.2234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +K9736JIVxdxpDxYZFb6lCH5ugsRFxDiYS+H86Simwp5cLk0XboFBZvFrX7O/J5M6T9HVCo4rDclmrBoGAVpV36IRod1ScFvUFGW4QUaFow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6261
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 04:01:41PM +0900, Yoshihiro Shimoda wrote:
> The timestamp descriptors were intended to act cyclically. Descriptors
> from index 0 through gq->ring_size - 1 contain actual information, and
> the last index (gq->ring_size) should have LINKFIX to indicate
> the first index 0 descriptor. However, thie LINKFIX value is missing,

Hi Shimoda-san,

a very minor nit, in case you end up posting a v3 for some other reason:

	thie -> the

> causing the timestamp feature to stop after all descriptors are used.
> To resolve this issue, set the LINKFIX to the timestamp descritors.
> 
> Reported-by: Phong Hoang <phong.hoang.wz@renesas.com>
> Fixes: 33f5d733b589 ("net: renesas: rswitch: Improve TX timestamp accuracy")

...

