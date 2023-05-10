Return-Path: <netdev+bounces-1473-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF9D6FDDF6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C68E91C20D6F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D591D6FDA;
	Wed, 10 May 2023 12:39:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FCF20B4A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:39:20 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2136.outbound.protection.outlook.com [40.107.94.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744C5114
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 05:39:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMWnDfqaUlJlW7KkSAq14645vjIvjKlAx/ZAovXY/3Rhi5BzqCOUoCkw3ClcZ7SfvoW9jg4ELTXJD+p/FBORFfVtagnd2iKx511nSuIHUKH71HDwhAVU4VAnkzish9GbnmJGkfHImlBJjFhWYVsGU4ypLPm9VjFwQiJXlIG+2e7fxt+28j6BgB8rjfHCljZeKCH1rr++9Qhu10yIHSVdOeBsDwv9DSb/mhBuylrtLgY7M1Tfd1Qa7PtLycUz/ZLOHftNK+915qddOIjV28z1qsp6Q70IOi/OWMfceQsjDWId8AecXJjR00wzGK/IIWTxSbjCcDefMTJO774zFkKP3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cgdayg+8M3NfyEam+FZJQVpagyypdp1Smc8B2gG1aK4=;
 b=aj21MWP/e9ygL/+DQZJMSSedJaEKEWwvfsLltVGS74tHl+TJJztsV9d8wGk1xPP/DHlV8aYfr+VGPdnGtozRUCr7h7cVbehSkGpAVkCy3Zv0STpHuCmi/LmBhUoLXjEs9J79l9s/NK+KX5TdjVwU5mOn+s/9HjRsPLF+pad958+1EUXCPraqaBZJCFSzgHlnzgA3x1pRT5XA/3Sk4kd1GDosp7oimRac9iAHW1Ig8LuQy8IMqr8xuP/n7Rp/aJL9lGpgACXESFNrVPODXXPSNXtcq1Zfjp6uLE7r4qN9Mi14EGPuQvm0uLHAyXflTPCr67/hJHyRmfeYQAjeAnqaOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgdayg+8M3NfyEam+FZJQVpagyypdp1Smc8B2gG1aK4=;
 b=lpqx6gUwYXhIO3R+6FjN10S4yAhTnKPiIori1XNrypS8SH5YHsazWE4NOSnMnSwgB2xBxx1WfeQmNNa7pOmKkTc/QJ8lUKRI2IRA83ysAmSy06TWna9/N2Vt9J1+lNdOmGMv7Aqepc+FgbCC+n8yKmxh07loSDxQ4NrjqQxTA/4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6440.namprd13.prod.outlook.com (2603:10b6:610:19d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.17; Wed, 10 May
 2023 12:39:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 12:39:17 +0000
Date: Wed, 10 May 2023 14:39:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: m.chetan.kumar@linux.intel.com
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
	johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
	loic.poulain@linaro.org, linuxwwan@intel.com,
	m.chetan.kumar@intel.com, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 3/3] net: wwan: iosm: clean up unused struct
 members
Message-ID: <ZFuQb8dwadoZaVu0@corigine.com>
References: <0697e811cb7f10b4fd8f99e66bda1329efdd3d1d.1683649868.git.m.chetan.kumar@linux.intel.com>
 <92ee483d79dfc871ed7408da8fec60b395ff3a9c.1683649868.git.m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92ee483d79dfc871ed7408da8fec60b395ff3a9c.1683649868.git.m.chetan.kumar@linux.intel.com>
X-ClientProxiedBy: AM4P190CA0015.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d0d5ab5-7d99-4cc9-079f-08db515391ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sg7OzAPD/nimEgo367J3OtQR02HmzxfIAdccD+bCEMvMvYmkGh9e0FbUyaK+aboHLXONd874CGf9q1I5ERFtCEI58LDP8K7YY6/iOEGDeBZkQa8fMSd1C4OnbQO16JRvPEHcMOX5JOgzrdjWbNMc5q9l8rD2Up6fuNyUd/di1bX+FbbDzOVPzrnruCwSbQOxswP2W6AeJYf986MdSPBdhqruBX1BUhR/KnP0Fb4RrxUp3QLqcOiYJ8muYbPJfckcMpjbBaU+h5WUmnHSTmF0OIIe6lf1dhCYfgL9t85jV9JCxH3cxpO/auG+SUTGur/OaLodKvBdvK5nsHKGUPuBZYqdo70LT6AqDbOgrUO1vW00xllkjF9dkO13mpJBbPg3UwC686imhjAICP/CmZ5guidnKDfAoO/TTqzDj3CEgCuTert5w7Mb34E83ujSSFIKjl2JW+Co5jNFa/wsKM/ur1NYPmHK5Ek9a/gkkbX3pNxW9WNWftdIBhcjWW0nTxC9rPCTqwDtQjpSInt7j0YV1fNcXpKRxFeoYtSsnEjTKzVb0beWzyNwuJGRhkYHYsSf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(346002)(376002)(366004)(136003)(451199021)(6506007)(6512007)(6486002)(2616005)(38100700002)(86362001)(36756003)(186003)(4326008)(6916009)(5660300002)(66946007)(4744005)(478600001)(2906002)(8936002)(66476007)(8676002)(66556008)(7416002)(44832011)(41300700001)(6666004)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nfJCT6j4I2JA/KOjwyZjx4V1/DRzh88d9inqFfAEmD+S/xt9/xbn+P0ZymUT?=
 =?us-ascii?Q?uOQCwcyb1AN8zB03yfTzwc0TRZRtd/nowrX0giUO22SX8g6HePPH/96BT0EX?=
 =?us-ascii?Q?3PrhNwWsoyyErwsEG4piZOqbHJcvdJkotveuUvV2XzPHHJbDz0BODjOPZYhp?=
 =?us-ascii?Q?oeV7cXb+P8J/1Jiqj9S40liYA6GR+NYN6z+mrRrZHtNoCKy3ZT11kVkFIUqJ?=
 =?us-ascii?Q?HVFb499mYfrSKnmx5kHqoj5NArmvLkPIjA6kSwFQT0s4i0BiNl5Q8Rki/ILb?=
 =?us-ascii?Q?rJOsLMXMdy6wAb+hvUodCbatjzAjQJ1/eEevbwB2vR3tQc2nIBQOQl59mDU7?=
 =?us-ascii?Q?939fhz40xvtp5LoPQSyaRD05AJap08o19DgvHj/ujpLSoHZbaipmEnI+Rqae?=
 =?us-ascii?Q?OXsiWluvzK+1INY8LFzrAIpFCYRzwq1f4K14nsYst8BcEmoAyBlljh/yU0SQ?=
 =?us-ascii?Q?USrKi1BSiBjzglSHQ2jkzwmTcdF8SyWIVKU+0BOAaybVRceXjTXFTuLR64c8?=
 =?us-ascii?Q?JmKa8THgG18cynkQiH7yN4XNHPpDuv9J82S+xVhZCZE3hlPVvOy+8KuXokxb?=
 =?us-ascii?Q?iJuLv+TCAJ3PrRODLE2kEDdGteH7m0zWHTmEn6LhMF44XZbybrDv5KCs4G5E?=
 =?us-ascii?Q?u5dpqHdvz7dpS7Cd3ftVnUrA9Qmj5OuNhiEKQSe3VbC6+R7r0M+CI5QFbD2o?=
 =?us-ascii?Q?mmt+/v4cRnD26rfT26S1G4Mt7NkUntoOOlZyRfNhM0tNu1ApggBWLmPFlZvE?=
 =?us-ascii?Q?+H/qebqUb3rMxc45W6NS/ZX18OowrdGP9eM5x0GVs3SixAJ22vsRIbg4wTAS?=
 =?us-ascii?Q?DRzPC3/Snb5JkeiaJGlSPNnuxulrX7JSQQkNvKC0it6yEM8F+q0x+09rjAqc?=
 =?us-ascii?Q?gl5/m2YRbBsmI6T42uBUEjoNF596lRG+gqEGnco4Kew6DjKXwQAFcBjZzvB7?=
 =?us-ascii?Q?YlhRDuw6A/vl5TaDCoGRutK4F0hDwpI6ZStDtyOADnxyXJwufGPgSS7Uv0eF?=
 =?us-ascii?Q?1ezN85m7yFaYTEAGLoBZOzipA39rLZiNjtjdU5oL0B58QaO8uD8Oo0wYLIcq?=
 =?us-ascii?Q?Bk0eP1Xy8VjzTZ/0jwURx95VIm4/KeYCvsrFU11yRmZH8jzLEneCHjYiX9qd?=
 =?us-ascii?Q?S9wYDewoZloOhr1631aEyqQg+yKY84Q61JmGHea8gcXZEe6hiIVS4DhhnKKg?=
 =?us-ascii?Q?+aI/PhWfvJnKQLSWx93xE6rlb3TmzneeX+aQcCkG3YGMaWrqgfOr0MH/BSUg?=
 =?us-ascii?Q?fofEBqGJCoTqZJne9s0LcCQC90jCBWZWURW3cuJgk9PQYYzLs1FFXiXVf8GZ?=
 =?us-ascii?Q?1RwM6WjLMilw7tI6PgSd8msIXZIYz2lL5ZW0KVjV1YAXmqCBXJiu7WqSvtl3?=
 =?us-ascii?Q?MMCuh/Tkneb5mjDwl55RccPq9wkZTYeS/shO+lAOjR4PThGNEKe31JMQoQJh?=
 =?us-ascii?Q?IAdWig6kzCb4VEX/s3CVu+0eCbAI/mdpdNqBrvisO8NRpbMIrkpwFs2/LjFR?=
 =?us-ascii?Q?mSZIlnk73sSUcr+aunvMtfdXSBcnSBZXWG8sExIIbDqE2wlkFFJHm5ZdR4Hd?=
 =?us-ascii?Q?GjlWthXbU5Wl+v4i7Tu1LUtVG27iAKNvZhjOQzQM4qt7rK/4cmpPM6ImgtNo?=
 =?us-ascii?Q?G8DAmYIw2Y95gHpFm0XbG8exy7/ZTIFnfjUdTwFnCgyKNCwUO3Rn2qlUo9wS?=
 =?us-ascii?Q?O/4F+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d0d5ab5-7d99-4cc9-079f-08db515391ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 12:39:17.6774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24aGDSw5hHV+yPJs9JUAsK0CiTd3C5mFdzYG+xNyteIZFt0oFFqbQY/r4VXbjF4K7lSlI8MWHE434kao5MsbBe1M98DzGvwTH7kk1xAN7S8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6440
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:06:35PM +0530, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> Below members are unused.
> - td_tag member defined in struct ipc_pipe.
> - adb_finish_timer & params defined in struct iosm_mux.
> 
> Remove it to avoid unexpected usage.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


