Return-Path: <netdev+bounces-8579-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D71724A07
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DC001C20939
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A5651ED54;
	Tue,  6 Jun 2023 17:19:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057241ED2C
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:19:12 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2955E1722;
	Tue,  6 Jun 2023 10:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686071948; x=1717607948;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4pyCzUJwRliZqDlBMbLQY0xVhINfycNOhis32hihFTk=;
  b=MOmtKF6rk1X8coFIX2d2qsGQDhvyc6z4rxJFxjChFD3+8iOTjCA5k+hU
   yv54z+HyeApsGNFpo27EuTTl5RBou3cOFUwo3N7EYyoRym0ug4+uZkdGY
   XwK+NoBdBPlCP+0F/rJbvLfOnpF3qrHFC7K41igkXBvkLNkXgK5RIrmAr
   9DEBoYdQ0MTwlIFk0NouRjyTeNY9p+I6WIAbve0BQ9jGmTHbTh0NxOdpL
   X+PUjxW7STazcgos7bQTrDMjCMy/wOmCmOIYc1ZsO0fqiASrEyXyy9u0u
   mp6DasPhSJtoPZomQt0zNrjqX0y6nDUU8jLnqcHVVylVvY1DOGh1fz9P5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="359200007"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="359200007"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 10:17:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="712295608"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="712295608"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2023 10:17:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 10:17:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 10:17:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 10:17:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 10:17:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a34pJJ6jQ9V/LVUjfBLb9Q2ggfVphfQjBlhdUNf6YuPWixrQyKAfLVu4i2UZKyANI9s99j6B1cgvrs+EXr5mmHmRfRVjH/gnvCfx7gf3kDoVta27DMj3idhPWDg3rW1NLlz/tJ83KzCjkTf0KMAkVeNMeYXvT7S2s9oz5CyOxaMZ414obx0Zrn/koWzPl31oqP3ZSbaY+1Qs5rgSqIRJ6Ki3IvG19ab+48jBi1SSIhxlJ+pS8xmCXwl0Mn9Cys661hQC6cym+MzUBqRWx7ykhsJL8JiG9T4UGqycltcKp+Hk7BS0Df+LnKUWPSOSlxl6594YvZUcbaziDdKojqcRzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knhdGx/FHqoNIYfS4qEBYAE0ZtnEYPrO7S8Vedt+jg0=;
 b=mTg2qVbN08U231JVvdV3vRfxFqtI0QacjZ3khN6mSiT38U02umhtZmXmNZad2q4ELBWWFUG6bqUYqWvd1aKH+On7lhrEl30mvaLPhE2siJzLL6220ZjTIY+gs4DdcqXcZ3CwRUrBMX65dLcBOE4grx7m9lpA6zSrxnOt3TArlcVDF7pwLjqmIp5VNEMlv7SalMwGndIAyKl15jF3fnxCzF9iB5/VJbHvkM5LJE2RLfcI7Izmz+kbVgnErhr5TTfNS/EdofmfLMebgsPEwpWh/oqx4T7fUh29F5gcq/Cee+hVbYytk1CDkHoTvWS198j/AcruP+ZKh5y2ThSltbnTCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB6835.namprd11.prod.outlook.com (2603:10b6:510:1ee::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Tue, 6 Jun 2023 17:17:07 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 17:17:07 +0000
Date: Tue, 6 Jun 2023 19:16:53 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alexis.lothore@bootlin.com>,
	<thomas.petazzoni@bootlin.com>, Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski
	<kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Florian Fainelli <f.fainelli@gmail.com>, Heiner Kallweit
	<hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, Vladimir Oltean
	<vladimir.oltean@nxp.com>, Ioana Ciornei <ioana.ciornei@nxp.com>,
	<linux-stm32@st-md-mailman.stormreply.com>,
	<linux-arm-kernel@lists.infradead.org>, Maxime Coquelin
	<mcoquelin.stm32@gmail.com>, Jose Abreu <joabreu@synopsys.com>, "Alexandre
 Torgue" <alexandre.torgue@foss.st.com>, Giuseppe Cavallaro
	<peppe.cavallaro@st.com>, Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 1/5] net: altera-tse: Initialize the
 regmap_config struct before using it
Message-ID: <ZH9qBYo/vkkUR3R1@boxer>
References: <20230606152501.328789-1-maxime.chevallier@bootlin.com>
 <20230606152501.328789-2-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230606152501.328789-2-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: FR0P281CA0238.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB6835:EE_
X-MS-Office365-Filtering-Correlation-Id: 260afb38-9f0b-494a-c7ed-08db66b1dade
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sjN6csR2+mio3uBG+gfZUEnNULVJhhHoSTdQ5Yq8d6PZkECXJozc0+FzC4bPQa9xGmwVYYeFnWCF4tMgukpjY5VhZWBi/1BHfe8PnMyp17lQBETqJP5benDNJWY+KN3CitQYzao0MxHapVIf8LS2nslXRystEitEL+kVqAdttJA4/uYiLIYeMqL2EKtlIptCbE7uDApJZinD4U5k1p6URgJPy4xX2mXZswDrQmtN5+CBs8+oZ+RAGhJUW33jK9dijLmTUqHN+4abmwktzFcXJFix+wcF+N/EwuriSmJ6NJh+WtY7UWHg6SGomG9BNU9Nz0K8sGcds51xe4AmQHxkIdtZRqNVROiuNRU03fHmQrQaxcNYidadydRvMIUO4PscNJ11ibua5POcecMigYEoIFDnHDNjPrdCK4GdjmJxL64Ik6Ld2sxCVnbgSDQcJQ9ji4nGxG41Asc7X/Oadmlb6CfMvOH9nN8VPebupegaW2VNTQljgekYAdidzAmdLqoMIUnAqscagtP9nsm8qRBbPPX+SH0ChUWN9fOFTsbp7Uq01rWcIqN7m3yZp4kExiIC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199021)(9686003)(6506007)(6512007)(26005)(86362001)(33716001)(82960400001)(38100700002)(186003)(8676002)(5660300002)(41300700001)(44832011)(54906003)(4326008)(6916009)(66946007)(478600001)(66476007)(2906002)(316002)(8936002)(7416002)(6486002)(66556008)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q3NAjH2+i/MH0BxlC7zaXslF2cWCIMeOh50mjZgO3PkbRJ6Pm0RXeOaUZYJv?=
 =?us-ascii?Q?GJ8v/ht/gbhaPe8h4vfbqhCyVFiVvtBSLk6mk7m3hcJQdWS3NVxOpz/nAWxP?=
 =?us-ascii?Q?FRM0um+twnzgw3q3/dqrde9vVwQ6XGGvpReOMBEXSwNwOkVqBvQ/9Pi5jnFp?=
 =?us-ascii?Q?6dOSEM5yb1nbf/M67xjpw9TPzZYnkk3ATNIIEP8t4UkvzHpxWiGkx/SSzLEd?=
 =?us-ascii?Q?WY/B36D5a/+GT4SafPVM8jF/KBHky4LsieTCUtM/AkTabUjAyk/MXayNPuBP?=
 =?us-ascii?Q?XCaEeRsEXNrvzhmzf4sfSknraWOeoRiBW8DTsbZuojlDat2DuEF4i5tLO//A?=
 =?us-ascii?Q?VmKPWkIvXzr5TGVLSx5IWlc3FO5LBnp7m6l0ucjN7MS53qUkTF/0IXqOkvFN?=
 =?us-ascii?Q?mcLWX579/dOkyNdZUYkzkYfJWf6o41E7LKplxWaSZjLtBWZsxieWtKMCK+nu?=
 =?us-ascii?Q?RsdFn6KeHjcULtv9hcE1gD8bPHn1d6L8LkZ8AiiSP12qe+3UaVs44SxnBUrT?=
 =?us-ascii?Q?bFakhbY08woJIs2CDOGpntnfxnYOfbwxX7zEOm6W4LKMhurZvOoPIjrijvxU?=
 =?us-ascii?Q?P5yOIbU7NQcI9wnOi7KQzbQDn6MpK2V2AC+YV2dxtrVCxqaHUFoQ8w7crulM?=
 =?us-ascii?Q?OKg4JQU9EbbzMXj3MICv5C5dFQPgPcNnBciVlTLxfANl66qKlH05dLsACSLp?=
 =?us-ascii?Q?vN75RHFc/lNK5UpUriwC9OehUVXpwfv9nsKt7Pqg8MvXQbgwaeNCJj9EgAeg?=
 =?us-ascii?Q?y9qF2q39jET+HAyn3r63txFH2V0+X/pKdk3EWT7CTzaFBlc9DoVpnO65++eX?=
 =?us-ascii?Q?ttJN3waH7Hqdhi0mVI8J7f7v/Lf6YboxjxfQnNuxllrRKTSKu0XaaxpjGXHh?=
 =?us-ascii?Q?U3VTExS/FarRpOgrZTW9/JKTz644IG4GR+a15L7CyuSB97AIMD2ouYc9l+ny?=
 =?us-ascii?Q?tYCBlTmZme0lr3A0AwOiOdFXJ0xLyZ6X88fr0Y+XnCBODmuXK97SR6fGMrpQ?=
 =?us-ascii?Q?AYaUdXP/QWIbmyufnWn7MyLZDjjzVihnWdj5aqszrLgGEFDl/f18Ijt/zakH?=
 =?us-ascii?Q?sXXWxKm3saSm9ze9xO9TSMNZ80lHpx4nADw97XFB5KF3gX0BJ4g9/wJIzK+R?=
 =?us-ascii?Q?5KUU38Y3K0ENDBUVSGH1yicYQKWx9SPm262lbIkyhS0IYWkC63ut4nI8N4/M?=
 =?us-ascii?Q?0WoMEjhlnFdE25CM8UHutd9XzaVFXZzN8boCXPYNCdHLSwymmlEEe/SqJwZy?=
 =?us-ascii?Q?xwmTqtKkDKFkzkLRYCpHp2pjapfQNCJs5TntdquFo2E9thWtRJAvpNGu0y1c?=
 =?us-ascii?Q?yh92o6/vUzLDw6g4QUta9FoTz3d42/3z67GhZTbse665shg+8cmFv7vzFk+7?=
 =?us-ascii?Q?AV3MdkhdJlcaDbevNzTUHb1v6j+viI9g2CIB01k7MYso5aAfXf1ZKwCOlGet?=
 =?us-ascii?Q?ruk0Wcviu6gPX7zmY87HcHtYritTuYzlUTjyNNFUvaWti2hEnCpCXniSOWwV?=
 =?us-ascii?Q?Y71ebTsATDLSOlo/9xOnv0ZSD6dSd/D6OZNn5RaXgrKygx5yunDejxWFQx96?=
 =?us-ascii?Q?lFXAxs2UglMzEhE/3OSmsu1w5FLZ9IeANGjFqeIYZG2nZcR7FI91FfU1a0f/?=
 =?us-ascii?Q?tCuL1BBVtSZ/6e5tr68B/GA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 260afb38-9f0b-494a-c7ed-08db66b1dade
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 17:17:07.1701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: znSM/rfNN4vbVtupqEKFHVn5XWBEjI1Hq2+1WEsdKXXwodPfCtgT5XJfXE0gUqQM93r0XIKEPBRf1fDTePA9rAsfyYcZILdigsC9dFjjRcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6835
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 05:24:57PM +0200, Maxime Chevallier wrote:
> The regmap_config needs to be zeroed before using it. This will cause
> spurious errors at probe time as config->pad_bits is containing random
> uninitialized data.
> 
> Fixes: db48abbaa18e ("net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx")
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V2->V3 : No changes
> V1->V2 : No changes
> 
>  drivers/net/ethernet/altera/altera_tse_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
> index d866c0f1b503..df509abcd378 100644
> --- a/drivers/net/ethernet/altera/altera_tse_main.c
> +++ b/drivers/net/ethernet/altera/altera_tse_main.c
> @@ -1255,6 +1255,7 @@ static int altera_tse_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto err_free_netdev;
>  
> +	memset(&pcs_regmap_cfg, 0, sizeof(pcs_regmap_cfg));

i think it would be good to zero out mrc as well - in future someone might
expand this struct and you will have the same bug as you're fixing here.

>  	/* SGMII PCS address space. The location can vary depending on how the
>  	 * IP is integrated. We can have a resource dedicated to it at a specific
>  	 * address space, but if it's not the case, we fallback to the mdiophy0
> -- 
> 2.40.1
> 
> 

