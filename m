Return-Path: <netdev+bounces-5542-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D1D27120F7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B7A41C20EC4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715E179EE;
	Fri, 26 May 2023 07:30:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0616FA2
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:30:34 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B716E114
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 00:30:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVAF2axpzwAPj909tZXMgmKQEtUDoboOIegfx+zJX3phczRpwqeskq9O8e6DDEuZilpnQm6/W9qyh4Yi/BrnRXF5QTyrk6I+SLPAD80OnxEfViZlAh7/3qhSnReRJrca8Y+LErBPqdb1JIVBbMme+Kl2oN1O9SNQG4nDLRficNTSjLJXNncGwcqMi+EztnJ17se6jTbYybrIizxevBvRi8QotEN51WPVfTFGxVFxnUIOqqXq28aO75t0GjCUrt0ms79kOmXqrhdaYTCa+1XgddS8vIhN5L8eJdVOra+DQEKboldadeOlEL8aTDfdBTHAgwi5iFj2zTSZNtlKFPqbiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m10NzkTRZZwfGphEvXMenzylFGaaBFHm3X9MVo2yn4w=;
 b=kFqNTs0QmjQdkjLwtRuKp7/gs8lopKxhWLk68Sl0YpUCZAyOWSOlepprok3BguMtGZC39fUv/n9ni/H582ahmj5148Krg97gz7wvxV/Zyk3fiAVNApMI5je/S2S738AYb8iMmL+iaL7rxZgua8JtOFgzpC6D+T9LPjEVVF7CV4Klp61ZF86UBZmMRpdcUXW+0vclBC/5q3NtWnnH22HTLhDPCT/fxnQEZhQWyG7UQhHw4X9EgR0q+IqfTLXglbURlmtKisEOSjmIp7uGv/vFCSnRucpDd3Fyo6yxvM6gtvg/jzLERMTaK57zSq9wxlXNpQXd/6i0pH13ctpft98A2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m10NzkTRZZwfGphEvXMenzylFGaaBFHm3X9MVo2yn4w=;
 b=Ud+5RHtDXuzDWd8bNDD0Hh/L3U0qOT5190g76uxUEprC4tPnqc1C++YTvtBVlL8IBE5GJgx2flJMI35jdop/2dDn0YJi0m6owjKVSIxVgU5/PShDLCH5NFCjLggFBGnjOxqows/qvI6LIueTOFlsjxlWbfepqCSlNv1lS3MA1lg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4698.namprd13.prod.outlook.com (2603:10b6:610:dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 07:30:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 07:30:30 +0000
Date: Fri, 26 May 2023 09:30:24 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Osama Muhammad <osmtendev@gmail.com>
Cc: krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] nfcsim.c: Fix error checking for debugfs_create_dir
Message-ID: <ZHBgEGPRWFryKFfv@corigine.com>
References: <20230525172746.17710-1-osmtendev@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525172746.17710-1-osmtendev@gmail.com>
X-ClientProxiedBy: AS4P189CA0042.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4698:EE_
X-MS-Office365-Filtering-Correlation-Id: b092ab47-8e1a-4c08-c038-08db5dbb15a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	q6psD+JsXA9EaAJ6TtjUIpA1j9oNVM9hYMVAscTqnq4GxdaWFvCnJTGZHqvVViELMGpDcj2Rf1eIztyIMhq20AoO0gj6r/twgTQKoWXJ2pFKGPIkvuW6mvunx7LFn6/zt7IECKt935xUDwy/Eg1GaGVQIFdesHSkrp+CS24vfakc7cC+iCYTiViJ67ZVIjoUxONKKxnNKfSo0G/pIJBIk40h+m8S09beC5guw01bXWsp4nlaZ2RYMPgTO7lkIcCaIrnndO6DxPEPGFZ0nmpNR6tGO8gdQW2VNfVSMHhNcyfA+ReyX+YjLOa9w8FtQ6lxXu8yagcweUDLYf095lLoNMZIHKfaM7BCTuWWj9juCWffQZet7y2cl9qcZvjzrtctSiR0ZG3cAI4kGOxQ9kX2UoSp96pTVqXtam1UR4wHWowJ/HvCfzf30t25BuS3D+KirDAv0fqDClirUrT/JPRPPq6ljajCbge9xOlQ2abg6ZISC9ejM1UrEJpo4Apjnc6728TAsrZhYV3jlTvz0/t79H9y1tm2/boiEwQ2lYquZc979omqexeUdz0/Ox85pjPM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(346002)(376002)(39840400004)(451199021)(44832011)(2616005)(4744005)(2906002)(36756003)(478600001)(6666004)(6512007)(86362001)(6506007)(6486002)(38100700002)(186003)(8676002)(8936002)(66476007)(66946007)(4326008)(66556008)(6916009)(316002)(41300700001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4mwYglktuFTMwgMA5bz7YCbWgdi1hdwmcTLVI11tvjljXKPijFbmXrF5fowm?=
 =?us-ascii?Q?yyVkwq2Fj4EInQRDfMKbD/cuJsXwh7twm2AilpqbnfYCiPMnloZEkW0eYw7K?=
 =?us-ascii?Q?5bVjW3oX9r3YJ27uhUY+YliZZYq7soryUzN/ZNTjwTTQ/nCb+m42aOmYkfnd?=
 =?us-ascii?Q?vVGbzXrUXT2DoPQpqtlzyPiEfN+Poz7ba+WIA2Kd9qFvVtaKMDcSlE9oYcXx?=
 =?us-ascii?Q?5oTbkUSzwhZTZCESFBfDATufB4dzbWJdBCeNbHJnC1aRjIX2efHLWOrxfsIw?=
 =?us-ascii?Q?2yiHnOBUcndXrbXth1Cey5ox9GCUfbVPLsO2LMulRBzTAkMlPD22saVGw/Ql?=
 =?us-ascii?Q?Oj+pinxE78aPkFtvQEaFeMATJAUEnoMaxz1Qrk3rJuvC8ilyy4nitCgR64Du?=
 =?us-ascii?Q?kjqXSC0aZ7hVQYyx7Vqp4tthkPQcYYXQLyvPr7ZO8GzVD7JUdg5OPLVhM2d/?=
 =?us-ascii?Q?3kPmAFN0oaIEgh75NKRqeVPtzxCqf6sYEQKeRyyx/v7dxW+5j/u40olVFFDc?=
 =?us-ascii?Q?wW23w+9BCDCyvtbHRtUHXu4TKRlml/AkRiOpGLWEIi7GMSLyuLkW0uNUnLRu?=
 =?us-ascii?Q?AiUP6ohhOgljcWKKIcs4rlMCMWlCk281A/Xk0fdllq8fPoV131fnI5ya5euu?=
 =?us-ascii?Q?i+IvQ9HvGYI+3HaD8UjbBCDHnJvlo54hAvD7ubHI7Dhj7hReluPKTSBLLmGs?=
 =?us-ascii?Q?ojaHlsq8Yz7y2Yd9VklMuJgKttWxKcSAYr2iehDyp3cXO6V5+clzApkXbdoz?=
 =?us-ascii?Q?r/ULBxZoHoS49I1CJso5NINe936sNZjrOUUOgS8mxClqDMKtFZXo3W2XIqtf?=
 =?us-ascii?Q?ijuZdLKA37igvvnU/89hXrtQwRgO82/5rlWTSqbt2z1u5VLSndVnrZxnmq++?=
 =?us-ascii?Q?c7flhUPmxv2l5rqnFPZC00jZUB0X0nGTyCF4RdDXcnf1p/lHJbkigIKw5oq9?=
 =?us-ascii?Q?K+Wuj7SfoDdqKSNWLvYIaQgGcQeFp86o2P8FP9Qfidc9S3hL1VKYN4j+vy6P?=
 =?us-ascii?Q?B9fyEEpIDOk7HX1OHxChT7VcoEJPbMFq+o/S1XvUz7Erbt2SmklHLPh86K2r?=
 =?us-ascii?Q?lmoV6JsLwUmetC8NDsvIQUGALNjOrber+FuT/wTGE4KcLDyNN26mJoNPJS5+?=
 =?us-ascii?Q?xdoB28aGjJkiM4vyYXnItWXc9gm0B6AGuQgQNt4b0tw5csWweXj2Qv85OgRJ?=
 =?us-ascii?Q?OIuKF9X6/wxyj5rCtKa9M6CeTzXynJGsQRfG92ruFhq0/j1VxtMsTQsTPmRi?=
 =?us-ascii?Q?DWZEj5CopI833q/rTe2+ybwMM0K620iquSM7Xh2K97nDGFcXYclkL/+1pww4?=
 =?us-ascii?Q?vYqS6hd5r2TydocuX15sf1JDl1O0+AarSWn4f2p9F9LAnUOzgAsnNpeUhHw0?=
 =?us-ascii?Q?6VrcRBHRjN/TZpKObSZQEyg6sQTKmyuaFu0+DgZq/RcaRV8pgcClHm5ZooEu?=
 =?us-ascii?Q?+/vX4XrJGV17imeqxG2523aBmcnnvGPa+OkJnH99fA06GhWGzeMunpP+FrlI?=
 =?us-ascii?Q?FuBBkOen5KKBgLDmWxAaajmOY40fglR1uE8yLt8RD3p5b9c4wDNNWvUDp+ZD?=
 =?us-ascii?Q?rtIFSXW6vGRKT3qDh02vusTaNDkehZn5gzISBeXiSUgG3ESGIFEia9faP6LQ?=
 =?us-ascii?Q?ZYrFivOa/+9uDYMdk000ywZKDW9KvoHJr0N6bKasaKa2i8GmmxK4PR8iln1x?=
 =?us-ascii?Q?tX+uug=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b092ab47-8e1a-4c08-c038-08db5dbb15a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 07:30:30.8459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8oUzQ48WkSHYyaP0MtY8ny1SKa4gYq6g2qEO6VlA2JplyNuoteASqJYnwaN01P0F+a3AYlr0WIJxUkQ/bLkOxDkO7dRnBfVa3rOP0nKtrnY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4698
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 10:27:46PM +0500, Osama Muhammad wrote:
> This patch fixes the error checking in nfcsim.c.
> The DebugFS kernel API is developed in
> a way that the caller can safely ignore the errors that
> occur during the creation of DebugFS nodes.
> 
> Signed-off-by: Osama Muhammad <osmtendev@gmail.com>

Thanks, LGTM.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

