Return-Path: <netdev+bounces-7740-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C5E72158A
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 10:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35D811C20AE1
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 08:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC94259B;
	Sun,  4 Jun 2023 08:17:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A45115C1
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 08:17:29 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2123.outbound.protection.outlook.com [40.107.223.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F4BDC
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 01:17:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzcvQ2Cmq2lQb7OsV3rY5TfHYrvYpFI8uNT9kAcXDGGylJ5cPpcX7dXntiGfJwjAFn9yMlcRHznbkCVHb7i03chzWpPEjeYdwe4PSbrim0HUch2Tu5V96RhWgJqZJ+0L3ZNN3lEj+THk2oSiJ44wJ3x3e3Hd5/4WGLAHbxEDPUIv9x1mFfhK7ZViJSD8mkmwEkpWjk5UuzcfcG9zfctGQI4K+cIhgYbPrslcUTvwNqi2fYQ0Ggx/h1TEMnSh/GUWrBmrOalacmq9ORYCzBhRNmf15BEI+7x26xV5pI0V1EYHkUBi8DG8XRl7G9Eh7c9bNf8uCD+9raISlMPWHSfj9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJHSMQV8WnHosFHbbtLAELGj0PMelYjJr+gAxgvax4Y=;
 b=Z5ttJZOKqAvanbgXUjAyRdfCtoHnEnzFVgtvJyjBDIPAG73pJ+W5U+cCTPUjEdzJFym3FlQN/sz1hkEl19BYrINSYoTz/6o92///tXPauNn+bIBdBuCZ3gIJslEbkUMfqsfVpjkFbM2e6iXgmvJQq0D5K0lGe0DrGC6ydkSSwfoQTMxj8+8Zinhq13hzWAeadqqYCSkPhy8yC9a7SbUiaQtL3hRiCzj7qzdBvTsUuQ8/obndy0AV1Z/1isDYsGifyZ95feiSkfg0aKfLDa4jkxh8SF7G/GLPXZK1oUmBTph1OKWkDQrx2DyTSJ7U9nQ4GVucNoQKi18gh8AleOzEKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJHSMQV8WnHosFHbbtLAELGj0PMelYjJr+gAxgvax4Y=;
 b=Lcubc1bgOzTI4CbiEeS1jknWPyOzK7LNdszXHyqngm5d4I6mEnVb9hE3V5DoQnKic9CrFydOUFB7PH+X2GSLElpmZYaVhD8poo98XHyDs/T5XzZDQIaW21LuOrHXRuw4fTFHArw/wry++8PDvtvRNcxnlsyMSEPmNunysrg2FAw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4800.namprd13.prod.outlook.com (2603:10b6:806:1a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Sun, 4 Jun
 2023 08:17:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 08:17:25 +0000
Date: Sun, 4 Jun 2023 10:17:14 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wojciech Drewek <wojciech.drewek@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	alexandr.lobakin@intel.com, david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com, sridhar.samudrala@intel.com,
	pmenzel@molgen.mpg.de, dan.carpenter@linaro.org
Subject: Re: [PATCH iwl-next v4 01/13] ice: Skip adv rules removal upon
 switchdev release
Message-ID: <ZHxIitexswXG7iZQ@corigine.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-2-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524122121.15012-2-wojciech.drewek@intel.com>
X-ClientProxiedBy: AM9P195CA0025.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4800:EE_
X-MS-Office365-Filtering-Correlation-Id: a3ade26d-293a-4601-cfce-08db64d4208a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jVNTzuP3yEAY7i6+gkBT7mrRM7XNGCQmuRCCh9byZGsWZs6pbBS9V3vgvy4feFJPcTUmuw0NaBXajNHsLftInuumR8ldVwG+JPO02wLwdP+fJetd/XstMRV2r2z0k7A41nchh7RmPZzyCU5GEVcjXYi9YvaHOLlZ202noewzefA7D4A3qIG1biXH8XxPi2mIXaYzJiOa43LqDxx4r/jk+9vpKUoq4Tf621P61/NikgCHd5yWjXNdGQ0X4a1fhgKchc5olJIKUWnjQdkDMxzm0Er60/fD3gvfjjH2DgZXXi9936kNs35hoeSkJAJqWIO1/K3l2vVcEl/ZOMY4GqAkPjlY5mwgB6nPKPs+4iQ3u6QXtdm6g0pqcfEbGSVr37Q5waD/hmQiFiQAA9MUPdCxE2uzXIhjxAm1GeyqI5EwLwwshytI2MshW/aj0pdkDncdoyhdEj5JXmVnCj/HQTzL9TGrP+VQEnpbWfmi8vn5SjX/lWyJnDNRjmrzEn7hKcOwKDrlej20gROeTvj4ONSFploZ8ZeNNg3PK0uz+AvPoKyKuMl4e/tMBQUGmYHqBOmo7mG8riiOMd1FHRzU0f71ckX3nJFvN/sagxGSj20a9x0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(346002)(396003)(376002)(366004)(451199021)(2906002)(478600001)(41300700001)(316002)(44832011)(7416002)(5660300002)(6486002)(4326008)(66946007)(66556008)(66476007)(6916009)(8936002)(6666004)(8676002)(6512007)(6506007)(2616005)(186003)(83380400001)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+4Jhzc8OemdikY3fNXjT9rnyJO7/WSND0HHdSopoiUUKiY2BUXLepse/WIc6?=
 =?us-ascii?Q?HVTjYi28hco3uW+3Bevy2zUFzsukAoJNOscxeSSBryjdYEiM01phcl3p6Egg?=
 =?us-ascii?Q?pzFaiRIrMr03xi+uw7SGdQgJ9b9FOUev0TKilWxxyT9eBHn11IwwTpqa9lQ8?=
 =?us-ascii?Q?fBTPuAI00Oe69JiS1L+tX+JqsVnBEChfuho65DeMq6Pzi+sf9d2fzjIwza9u?=
 =?us-ascii?Q?OomMi0RwU5l3VKiybk3hjLDWvNxcaNXnkcUoYA3vnGTvq3sIR5f/LdmmmEK5?=
 =?us-ascii?Q?yXwV6Z66w7iumNk5xxWxz77ZpajA5JXX9fROi1xPAbXTg6FR/qMvSEosW2j1?=
 =?us-ascii?Q?1ERJjOPVW3B0fGJePymAAqpa4BW6h5tpa4Q8tFoyOIdZSCIwOP3tQUZZOQQ8?=
 =?us-ascii?Q?Mu3JxeA84xp9euWmDTim43KEQ2QUIt5RWhgWKdUhxtq+52q5VtOhYiSN23F6?=
 =?us-ascii?Q?mwP/3Du4fUdUnBKIY4+v3lAG1gnDOXNpzqIlQrNH6wm1eyNWiCOXiRDXKvrh?=
 =?us-ascii?Q?LcS4IremlHEewn+9c17qJJQPN0t/oLF9qyG6nfoCWByu9k6EGUhweCByvIwt?=
 =?us-ascii?Q?D2IHPKZdTxzXtE6iUWTXyDiSAHOFxifRRw59qsmceZdzLIZcEN3Oj0mjIfL5?=
 =?us-ascii?Q?WLgUGJl3NMVB4kt4xqNPOwApyN48HHNDF4E2UMHq58QTjn9tTedtAuzex79w?=
 =?us-ascii?Q?mzaUwQdbiuEihg8FGlaepWOn2zwJCxtPRN11XcDjUs3/MuQNcIw+w0Pg+q6t?=
 =?us-ascii?Q?nsa1gPdD/Lln8gh1HfIYryx2U7lTvLfcnkYOyqKV9lG8xLU6bV4bXOgcJwHt?=
 =?us-ascii?Q?Ksj00jljgHsO8gWtAMQZxZZfAYb778PFY8RCYWblCHlpXGiSu+/wTF0HQxVZ?=
 =?us-ascii?Q?ZQN7ZaDoLUNzHIQpgNj5llJexVEtNJ/v9E2CGvrApQfUvQt+0ccSU+E5nffG?=
 =?us-ascii?Q?38Ju+r1nE04hakVnIMJ/Yll2DLpbdu8OHE5yNYWoe8QlvyAd5wdDpZkIPQLg?=
 =?us-ascii?Q?5kXMrgRY53XE0MPR7XB8xH3yjiBysVWw3TnGGTChoLFVXtY3hTb6yRUdMVEJ?=
 =?us-ascii?Q?qU8N3m2aDcaC0x2RHd5W1+WKSMVj5bzqQuhVyxwvds5Fj4KgrbZSze5LKJrM?=
 =?us-ascii?Q?KRTWqPfJ4i3aWd/vd8sisny2DVu+DM2rh1ak4DunmbQZHKYd/Nao3Z/hig0V?=
 =?us-ascii?Q?O7hTsKVQc5JqSZH9O1gyBDLvzqJsIoOc5d/PQNPh93tTdHK4vdqsNQ1jEv9D?=
 =?us-ascii?Q?yPozVjKakBG+cFUcz0hZnnMj1xblnAQOzpw96Wx0pdwIlPADyTUjqXHxRtN5?=
 =?us-ascii?Q?1mXxC/7kX63MPUlOZKpLEP/EoDCaqIejbe6EvDj1K48UdarpqvsurlPoSkgQ?=
 =?us-ascii?Q?yt5bCKAPR+NiAoepwKFsGM2oNPY6h7l8FUdmSoa2VXzPp1H4toD9a808whKU?=
 =?us-ascii?Q?bq3mZJ2+6ROVVHOfVqnIJ+qKTo6YUU3D2e7gz283NS4zSRkUZyk/KY8lyobw?=
 =?us-ascii?Q?BrKETi02WvPYNvCeXBwvd7YTEbgnQ89QrXtEs3l00RRRvCpxfcF3fEXb9qCQ?=
 =?us-ascii?Q?G+9eyZAPdbQpA/3WvKuKe4uQP41UPiI0ah9q/F7AvBdQ+6r2DbkSmg6WRnI6?=
 =?us-ascii?Q?i3NWNix6DfvENsbIrF5a5F3iy8JM9P/s1tXeJ08LnjTFFyBa+GxbnljKkxHQ?=
 =?us-ascii?Q?FKnp6g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ade26d-293a-4601-cfce-08db64d4208a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 08:17:24.9820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+Ok3oguiUbBrAPyHq7H5ZTXmJdQV4E0tSLX+Tum98QuMtmtX/VxtZhmBMWIJxlletCqCwKAJCJv4eiXXgOYTyY9PCWCekM7ggQGqouAvUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4800
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:21:09PM +0200, Wojciech Drewek wrote:
> Advanced rules for ctrl VSI will be removed anyway when the
> VSI will cleaned up, no need to do it explicitly.
> 
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>

This looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

As a follow-up perhaps ice_rem_adv_rule_for_vsi() can be removed.
It seems to be unused after this patch.

> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
> index ad0a007b7398..be5b22691f7c 100644
> --- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
> +++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
> @@ -503,7 +503,6 @@ static void ice_eswitch_disable_switchdev(struct ice_pf *pf)
>  
>  	ice_eswitch_napi_disable(pf);
>  	ice_eswitch_release_env(pf);
> -	ice_rem_adv_rule_for_vsi(&pf->hw, ctrl_vsi->idx);
>  	ice_eswitch_release_reprs(pf, ctrl_vsi);
>  	ice_vsi_release(ctrl_vsi);
>  	ice_repr_rem_from_all_vfs(pf);
> -- 
> 2.40.1
> 
> 

