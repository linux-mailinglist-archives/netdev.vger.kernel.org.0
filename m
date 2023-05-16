Return-Path: <netdev+bounces-2960-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B8F704AF7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:44:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CA822814FD
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC54134CCE;
	Tue, 16 May 2023 10:44:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D55D34CC9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:44:16 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2101.outbound.protection.outlook.com [40.107.237.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1E1E8;
	Tue, 16 May 2023 03:44:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hV3cI2CNRwI76jlS53biIo7ZLLqL1S0fejZEbiiDuStuBITSzM66IgsDfg14qnX+1p231Xs0j1pju27NvpWr5gQtvzQMzqyX+Y/qcTp16FeaKgyfZ9wKSR31/L8+XPjBZBsTMKQBlmFGUh9vTFKKrKSE5LZ0bOW1tg6hEdXqs2MLBEqAPFmaRwdmXPNAhfYYZbOK4K+b+xSrxHKA052p+3EEkfGcgmj/WSa3SaN6GMzwsfMrI+inuFsYf1PU/LyBqaL3IyfqjFtAUACyoHaxE5bNiwX2ENOCWrZc6nTdbOUeeHyFwfFEizWYMqPlf98RT1GZrqTh4f6YBrBvqNMZrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+fi44/vVXyC0D4eK30g7wWePVL6bsBf/E/JsmvLIvE=;
 b=k6nmF6npwY498u6I/Wk5hWw/cBzo4vEa9gSupPpuvg5eQ4uVgMIlEYfXJouWs2212t5DKdAfsWDTblg2RUO/DIHFIkLAoGfYVcy8K1hDDs3HPI1onkZQd9zs86m2Tz7ZGp7Ax6wSfXfzwFpPuKGhlnxxWr5beVVqbMwttF5FOZj67okBOjDOMauh+00d816Hcj3T7YmiEQgPtZvt6BQhHoI1Qv0vpef3HHa0sTmsEw7P22Gmyrv54SfcpfNtnLpQDPzlrPMYEEtVHD/EQLL3mb/uiVgrkLlflqgr3i6B/nljgGyFDO1WouDJ3/mveiSZmMULW5nmmAXuVCy/UZpNuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+fi44/vVXyC0D4eK30g7wWePVL6bsBf/E/JsmvLIvE=;
 b=d3CU/FEWu7VQDyGebIna6dRI5Gkw29fygZIhBudk4GeJS6ZCs+dqEfXyCSvQvTtclVMZFy7j4ZWx6PDvAwEC76qlu5XlCNtNOD2gLuMjSWFXU1iyytGfR+uJ4EWFlseBBMqjdipBSQEl0A8FcE/Xr9Bn3q0Fj0uBq7bmCvJZ1gI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6209.namprd13.prod.outlook.com (2603:10b6:806:2f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 10:44:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 10:44:12 +0000
Date: Tue, 16 May 2023 12:44:05 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jaswinder Singh <jaswinder@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] cassini: Fix a memory leak in the error handling path of
 cas_init_one()
Message-ID: <ZGNedY5UltgPtqjN@corigine.com>
References: <de2bb89d2c9c49198353c3d66fa9b67ce6c0f191.1684177731.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de2bb89d2c9c49198353c3d66fa9b67ce6c0f191.1684177731.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM3PR05CA0133.eurprd05.prod.outlook.com
 (2603:10a6:207:3::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6209:EE_
X-MS-Office365-Filtering-Correlation-Id: f55dde41-b050-4950-19f3-08db55fa7c8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rbQvdFCr4zluIFCuBOLuRPo+R89+nznyp8qx/7vWiEq92voYLckKI8WIosimYFiJ6S0A0xGy++dgaDieEMFME9VhjYUzXQE+TSmGS/XNB5CL022rg1WpXW9LgUGCt8zxQ+vYUbzOlr3weK6YYgM7K/dGqsy1A5ZYBLAuANjIXd0A8uyuu9KSFaK9OSNGAaEuO2Jt3xx3cKeQbnAgKBE44QRKMz+nPYP1yYjkeNcp2dpAtUrYT95rZloqSGU/MNJOmbCIMvTFFqXE0nBRu7WrefLpnHbz9lgSvbZ84R5U09FU9StwIi+i3VlKXaONQPIv2Ia9QJ2xgP/Nd9HEoymGpyW+eBbeArcViX97d99cKmbcEyr+ynNlNfV0t0ePMbQ2R6a91RfkFy+82c+6obXG2We5RaXAJynnT1LeWIcSi7jt99HbbEk1KnyO2Vfc9MRdIveVQOHNXZIa69hb2YKNjtwxDqkslcoNwzqvHW+WoD8MuUfSpf5iXQx8BLyO+RwUTJFjkmBINPa8Dr4TDOThEWA/BhiRprXneficl7U/WGhu0Ii4M4Fyli5wNscXTTtc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(39840400004)(376002)(366004)(451199021)(316002)(4326008)(6916009)(66556008)(66946007)(66476007)(6486002)(6666004)(83380400001)(38100700002)(86362001)(54906003)(5660300002)(2616005)(7416002)(8676002)(8936002)(44832011)(478600001)(2906002)(4744005)(36756003)(186003)(6506007)(41300700001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?74Gmn8fCeSDChq0yA7YGEcXcZlBr4r4b9nfhWLxn+2dq/1EYqqXaeHJowWYH?=
 =?us-ascii?Q?ctInC7hvcHkJalOD4/IvHWsxlujD7X7u9Opl0WBMROtDSn0MG3KaaV88/UL+?=
 =?us-ascii?Q?eOsA0vpD74yrDs132WKvxL5XRjdVyiQR9t2PmrY9UKgQtZ475f3iLVpgMYLu?=
 =?us-ascii?Q?QjcJShCqMOuS+hG6xe2QD+TlumVlgN9khu0VFNJDg7oOz80bchyJgJ1eQcmv?=
 =?us-ascii?Q?0/yE9gWK413byvBff6VqyVrBCSIyT++NvDE93Rf4uNU1Wo9lb6ziar6F/75h?=
 =?us-ascii?Q?zslW9xixds+0TUe00yvQ5j5L2XyDnczL5Asrdi2BcQPQE5h2hE+i4J60TNF4?=
 =?us-ascii?Q?KBmezVSoHDuOCExxHAATiYZOnm9CuPJVsWu+MVjaHxC2QxebIl3vuiAex+mg?=
 =?us-ascii?Q?Zcdg6bJkntCyp6gaPcMC314uzePxaHwgM5P58Y7OJZ4e8HQnoIL8THzxuDkP?=
 =?us-ascii?Q?Y42dj/19bbnn/3GVR0Wz/AzfTnqWP7bCPpY3t/Qcnwx0AT3kyt7mEQwXyFbQ?=
 =?us-ascii?Q?ZZjBSI1gG1Nfzyyy34hFVeJw95DahA7mScnwUL8MXKH+IR9wIOT+WUuJ3EvY?=
 =?us-ascii?Q?phkFMGluJ4Nme4gapTf5BbibHGmc83cO46yncy1Koet6g9X0Wzy++Ifo661S?=
 =?us-ascii?Q?r6PTC6TyJDI1SDfvi/avEPGT0G3JfZ/jf0zNazGA5WQW6DdPnwqegdYXLMfO?=
 =?us-ascii?Q?gOY8CD+bLumMFqKL6hkm5q2eYTV/T0yeqLM80c0k8r5aXZBfOeyE/8g+Nzll?=
 =?us-ascii?Q?Ydp9FdaHAAJ5lLzifAaC6ZX9FfvCxe61vrKe1aeBFBgfdek+6GdOezCIorXM?=
 =?us-ascii?Q?eXrvF0+w1Q5rSas7KuCaGcAngeeCTAvRyeOhbbfU6l2IrljLBNDIIIHTzrgp?=
 =?us-ascii?Q?aAvh9120S0Kz310MJN3ej8+Y6edJCEK+IjnmcBgkZ+Gp+nn0boLWWsO5dNec?=
 =?us-ascii?Q?omRTvQ/plbbFdws38qTTjvsLLQLgfYj+PfGKU4bQnNM+RdIhq1RmRTfILBHs?=
 =?us-ascii?Q?adU0jbGa+3qZPW87GjDqQrQStFym7rgKSS9JkXwJFVyQXMxTAufPUOvFG4ra?=
 =?us-ascii?Q?QzQSjVa+MDO9KLddnLhsA3d8uUocqm1nwVurHxX0tWbyk5jvw4aAdk635zO7?=
 =?us-ascii?Q?gqb8V2AHvMO6ZLnH3C6c0eycP+rB07fVAi1xcwpIr5ioU6dzd5ZeEQDwOv//?=
 =?us-ascii?Q?kfmRWcQWUk0nAs6blYHuiyAesAADJ4nGSVrTOIn/cGC+R0gVy+bL+OHPM4Dl?=
 =?us-ascii?Q?KQIvXWdYKoTYsd6V/EQgYgscSu5c76AtA8ol575KtiTXV42tBJ/1rAFxQKJg?=
 =?us-ascii?Q?11Myzii/eM67+GZWRfxc4opWbcCG2WHg9O1jYlMMnJxsPrGxgAH4TN1+dDaI?=
 =?us-ascii?Q?POqsrX33azQATK04g8iVxpNsWrj7htyyf96K/Igw+ycAoj60z9hPDTCbPIzz?=
 =?us-ascii?Q?zU6zUBgphhCctHdtUrNhJbZlFER7UnG2sFxS8fqAnqvSntBPAJKGuI3MnTAg?=
 =?us-ascii?Q?OLOKck0rp3LMSpXmuYEjwTz+srE4sueixkd8/goUiGf1LAE19vhGWVlrp46V?=
 =?us-ascii?Q?0noxRwAar9U+DOuD4cSQ12FgSO+tDNzwMq5vOIU4BgokgiS4nZ9Zo9+BcMRw?=
 =?us-ascii?Q?N6jk9WzZ2D80kPehkVvYc1wsPtoPcjTACxo5mQVE8IcJB66FgTY7Q89eMPiq?=
 =?us-ascii?Q?cQxucw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f55dde41-b050-4950-19f3-08db55fa7c8e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 10:44:12.5007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: was5O363kt2e8fCInFPCkXnsNKbF7M6xEkcha4K+CatxsigOTfrWPN5uPsR6m3zSZT2q+5Fs/A6zr9G+F26d9N+H/5jKV7Tx5KSUIyRjqqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6209
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 09:09:11PM +0200, Christophe JAILLET wrote:
> cas_saturn_firmware_init() allocates some memory using vmalloc(). This
> memory is freed in the .remove() function but not it the error handling
> path of the probe.
> 
> Add the missing vfree() to avoid a memory leak, should an error occur.
> 
> Fixes: fcaa40669cd7 ("cassini: use request_firmware")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


