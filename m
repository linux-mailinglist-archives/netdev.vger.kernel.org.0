Return-Path: <netdev+bounces-6266-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADD47156EA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B29671C20B99
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F31125AB;
	Tue, 30 May 2023 07:37:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56959111B9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:37:48 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2112.outbound.protection.outlook.com [40.107.93.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E0BA0;
	Tue, 30 May 2023 00:37:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHM1GKoqVC2RPH3oqPhXRJR3ddyjkD83yktcWD6O9C1sTCda93OvdQzwQprFjD2JECDkSVKo2BiN/ULOLXgNyjOM6T6RK2M8Jt0jOnz0o+wFHLB45iSrQco4o0iYMgUEwa4iapaA9k8rx6h7Q1CaFakbelgY6z29hBWA79aSu5FikqscLgONyLKAmdoNTfCPxLgcLaKnbPaIYcIo527OZ1+mLhmFxSZNvpGjWsrKcnWO4THE9YvzhdjwgTGndP/JZgfoxjqfeqS32MCNAMq9yWmkECWNdPHKIIvPNqZY/uBhxKrA5QJyS0k5rYd7hVYbh6kih2vrQJzt+QUg9GptzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mujmdeUiwgdVhF0uyTk6+Svhbf1cb8+pO7EnaHZvcto=;
 b=izGSkyYvnLHUOngzMpaup6/za5zQFaeXOi2ZuoJKBTAsie2jTN/QWtSr49qIQNp+z/hn0aenLJPpzXv9G1iU65JEwLM6Omdmuug6rRONhEHaoAflaQDZQSVf5TjD5DR+UYAyzO7snCgo6MSEiTt/khsCaEKTjAqnXaU0a97jjFY8dltIKjwrWjQzKDjrhNvMe1Nr0STqmt0hX6qem+E3TRGJs1lfk3qubagZexI5/QwZXrUJraclKfInygLv+ltqb8yTT8IJme5DAy2KMJ5Not0CP1JcQsYjElpkC6qqsIeZAiaXFaITqXniyggBzx6YD5gMM2zohfKkARIpc2qgEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mujmdeUiwgdVhF0uyTk6+Svhbf1cb8+pO7EnaHZvcto=;
 b=m2zQw2/eUNRTVpDJalEKlDSwVKXVMUM6pSOVDietym0t4yiff1ehdX/5yQdQPSPPEqsN7ZhOI7fEtFdakC7rrK4A2gzZElfZY/j+nMAEojYdq+ivc7qv3c8T2CxU5azpdR8QJH2AMRjIzVlTcfJfUmVOzFlW+0A7kyaKwclqn84=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB6046.namprd13.prod.outlook.com (2603:10b6:303:14d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 07:37:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 07:37:45 +0000
Date: Tue, 30 May 2023 09:37:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Marek Vasut <marex@denx.de>
Cc: linux-wireless@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Jilin Yuan <yuanjilin@cdjrlc.com>,
	Kalle Valo <kvalo@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] wifi: rsi: Do not configure WoWlan in shutdown hook if
 not enabled
Message-ID: <ZHWnw9SDkEuEltSk@corigine.com>
References: <20230527222833.273741-1-marex@denx.de>
 <ZHWnfhh26QVBZxi5@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHWnfhh26QVBZxi5@corigine.com>
X-ClientProxiedBy: AS4P191CA0049.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB6046:EE_
X-MS-Office365-Filtering-Correlation-Id: ad56d4bb-c729-4581-f136-08db60e0c270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wRXogvD8r1EEZE8bsRd7AE9CF9Zgc3haKvfbRqtlWeXXXKBr0z3/RUGGF0rcbm0lUec18GF8orYQq0XZ3a/HiK/vCz8L2le3Ek2qBLhyJyungN5OCbEhGUZ6W/2Kt4LQ5mvfADbTGiGXOrzgIXomslYWFm3lq1BU+E1PpxmMu8HvmOL2chDVWeexM7SeRPSGoT+88o4Ojedf/IzVsSnrLJ/aGvN/vemWCuFH8cutxOnS+zT8Kp3LyjDYTNKMD8BHytk4HJ4X9P+KJlTvmPtrdbsViL/3pZla2cF1K977HMzc3Ct1PJT7hACQY5vs5bBVn8LN6Rlb7UlQY+y1rQsb2NSat45ALMV84NojnSOQxpsDyaifzm0DVU4RDasKE3Be24gQCS+SMzdFu24lTZYsG+QFwz5QvKM2Ei1M1Y1YSyAo5V0b02m3qaqirvM4BkOdCeUO2qLCAlJQMDJJr2HtyGhg98+fxb9qTtj++QnQGERgYyzVeDlYcTtzswKS9xY4T5G84OwLB/SyzpP1/q2eBw1mLkGbCopay0aGqNW4awpoh2bDJVa1XgQtWSqAQYnx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(6029001)(4636009)(396003)(366004)(39840400004)(376002)(136003)(346002)(451199021)(6512007)(6506007)(186003)(2616005)(2906002)(54906003)(478600001)(44832011)(83380400001)(8676002)(38100700002)(41300700001)(8936002)(6486002)(6666004)(66946007)(5660300002)(66476007)(66556008)(316002)(86362001)(36756003)(4326008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XLWrdo2PGqJBTsbdPGb2sU4RfZ0ksuLtQs6bZt7nzDqYm6BG8XtwLpazV7D9?=
 =?us-ascii?Q?VA+tmdRuy2N0NGyS+M2NAQp5FI8rI1wkBb6qSk025/AlZE9bOm10pVejSz1v?=
 =?us-ascii?Q?66W0wbPHwWVxsUxlY5PtSslxOr9y6Ctay9LtWCiEjOAW13MgtfYlHXkbun4n?=
 =?us-ascii?Q?61pXcYFF6laXn3cFCgVMD0UN+j3S4Ai9sVlHlDKnhILO/VORHhg09FOmaOAR?=
 =?us-ascii?Q?ekdmF8WEKU/W8UwC4FTWTBc8A2HW9qdsAUGoPkpyGhxClCZ6OCOiWRiHGHNf?=
 =?us-ascii?Q?WPfeX2/9DZ36fcpVIwMUNcT385MTTBOJU5B8QtdfXieV706OM4eQT0fUuZQG?=
 =?us-ascii?Q?dQTHKTclMiPeIUnqPQDClA2U6IN/wT6U2XSBXlprB/Je9HRjr23qtb6L+9SP?=
 =?us-ascii?Q?vmQo7QNe6Aq9T50/bRrwVx0xUvx398L8kBszS8Utlg8uEd0pWcc9nyxow6TC?=
 =?us-ascii?Q?FoOx7WPAX8BNy+950J1RFYboiHjAJKphGTREI89SRWzR+m+A2C1Y+a3ip2Yo?=
 =?us-ascii?Q?7levHsDS0EuqEqO0RJ3cwPh7z4Ocgz96sQ4OFMvFQc/LWcAVNAn7WPlgjVJp?=
 =?us-ascii?Q?Q1vNTTtTfCt2nkLqP+ReXSdJLkq9ffyxi0UkKz5UxAHOAZ/aWG9JDy2F0UvP?=
 =?us-ascii?Q?roceJrFRziEXGBMuhp6iTg6fh5VfdtFUAkZhvLdHkeckBOaqWHcirTG3CrDv?=
 =?us-ascii?Q?Y2YcAtpssH+EtOHJsXHPN+CjrJjg4GrDEtz0VjDp7GkLPB1CIcZC7aMEhnFP?=
 =?us-ascii?Q?rTaX78rSfMyPW/mzGZji1L93QZyyGG++mdK/xhx3gqAC6CfQ30ot+R7Cimgz?=
 =?us-ascii?Q?jqQ3JTcDuO3523Fv6n7T0wkKlCfwNkcXaQLm/2qt4QCTMiogEskza7Thmoug?=
 =?us-ascii?Q?bYc45x1iaO6tcJskJ11lYu1vik+GHzCOz30noCXIYypOOdKJzy5dO6aEhPCo?=
 =?us-ascii?Q?XP5StY+lKuuA/43QKHi5DGiPZFRdivQ2EYCANJUeA2rOtdp+T8uHxvWoRVbL?=
 =?us-ascii?Q?43HlF6XPgLeWa1KKIKyAcF/UWYFIikWUOMgmO/VOnKyRg08jBLUrOIsGx2CW?=
 =?us-ascii?Q?v/JI2qwFwuAQKqxml8qyQKbaX7e61E77cs4Cv05nxuU/dlwzLUltJsH2UrHt?=
 =?us-ascii?Q?EKA9WOCfRayVMGcUGUZkIaS/C0D7+ljq8Rxl+9Y0t3OVi1HC3x4ki1tEFNjb?=
 =?us-ascii?Q?5c/Wm8MP8uVIEkEwkK3u1MmcYDHQNQb2QI52JVPc3dqfkSGx6mTmajJx2SET?=
 =?us-ascii?Q?g2o7PuVRl557x6+S8BjrYE5yxchpjZHTvQLxPum9tBPbNmskYWpRpbspgtp0?=
 =?us-ascii?Q?VVyg9YRuywJJ+2vhSfthlyOD+oBMVyxVe9YXl1YK4f7mnE7XETr3CEu+/q68?=
 =?us-ascii?Q?PYQ16UiCnX8S8yC/OuPTe2aldSKoiTiC2QB2uCKdUs55hBb57BS8T+HmgwEJ?=
 =?us-ascii?Q?I+3a83b3NDALUguSrvxHxQzoVwxPNkvylvdo9sedVbirA9V30fuw50zZIDZ0?=
 =?us-ascii?Q?6UAnZtHeARrRbfxIwAwoey/Rp5hTLlHuD/7GEjYQ3WUAc1AamwuJ9+1mqpJX?=
 =?us-ascii?Q?oI9wxMv5nq9ksGyjUYxcKJoZU8troLm/2D4MIHhx5VVT6649DMddir0/bKmT?=
 =?us-ascii?Q?sNChNmMvTy05NBHCqdvPUKxDIWZnU7MXLrwS0nZkCB3oLYX3gw4bGKrmjOQx?=
 =?us-ascii?Q?QqWMkg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad56d4bb-c729-4581-f136-08db60e0c270
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 07:37:45.5007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Al5wf/zPVERy5hK8SSggFFZIjHqZYtAQZ5ZzRuWZBXJyxAB7xouRqVjjhloytLeHC4PlJjht5+1XL1VsN+Cy9TQtvsM2ctfV9XyIgR/E7Dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB6046
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 09:36:36AM +0200, Simon Horman wrote:
> On Sun, May 28, 2023 at 12:28:33AM +0200, Marek Vasut wrote:
> > In case WoWlan was never configured during the operation of the system,
> > the hw->wiphy->wowlan_config will be NULL. rsi_config_wowlan() checks
> > whether wowlan_config is non-NULL and if it is not, then WARNs about it.
> > The warning is valid, as during normal operation the rsi_config_wowlan()
> > should only ever be called with non-NULL wowlan_config. In shutdown this
> > rsi_config_wowlan() should only ever be called if WoWlan was configured
> > before by the user.
> > 
> > Add checks for non-NULL wowlan_config into the shutdown hook. While at it,
> > check whether the wiphy is also non-NULL before accessing wowlan_config .
> > Drop the single-use wowlan_config variable, just inline it into function
> > call.
> > 
> > Fixes: 16bbc3eb8372 ("rsi: fix null pointer dereference during rsi_shutdown()")
> 
> nit: no blank line here

Sigh, there was no blank line here.
Sorry for the noise.

> > Signed-off-by: Marek Vasut <marex@denx.de>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

