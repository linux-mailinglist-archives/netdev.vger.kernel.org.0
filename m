Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B308697E63
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 15:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBOOdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 09:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjBOOdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 09:33:16 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DF314202;
        Wed, 15 Feb 2023 06:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676471593; x=1708007593;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HLQCbDrKa5T5VIjWznHzrkxpCXbWm8VD7urSWJUnPbU=;
  b=BvkxfNzcyJSt6sGf+3kBTiR2VQCIQPa7QNFjCoM2CndWP1v9ydQvFV4t
   uOecIQXQ9iEa1XZL4iTNhFfnx/NLlflcRpNrA+5cO3nuXCGGdE8XPEcZ4
   nQt2QhP2f44VyktGfaBKKxOKEvnqUE7oTeTG21ta+anLB4V/HtIwffwPr
   tnhDr1tPmAYLoky3br4vdzrA2As+tHDsLnRXIkfIqv/PIPVyODjXle+a4
   pG9eq6tAw1DYGpOklyRbkm7tXPMSzYboawyrIa6IaUozKtzaC1LC/u9e3
   nU7nu93M4r9q9JJpBHKUCB6il3+RmDDPYab8gDiKGPdKLS6UiwYKQ2Et0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="311805320"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="311805320"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 06:33:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="733301255"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="733301255"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 15 Feb 2023 06:33:09 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 06:33:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 06:33:08 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 06:33:08 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 06:33:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRNQoJzRHFNza7Z6GjDvjQH8idcejDteslpjSAPpnPn5LLsz0WtSCYU0LmE0J48K48/YdV+DMONrZFgnSMKxbQKt7Di/k134dQvZtUwVAmjHgp34wSuxSEdsBspeUTw6Q1uXzspApzm+EXzw3kPNfHjYdvFcmnYr+JL2DwEsHlZGe69w8p5/+nSa7L5X9ZP3GX0hzINFL7zc5L8pM7fqZFODMdGJDGeAbvtyEiM5O7sAeNtWAWvfD4wkPziX+t0v9mI105nrGWCkXLaTTtwquPTLo1iu9U1Lj3rkVVUrQ85pRFHMn5n1MBxbqfv43B12MPt9Eo98EA3JJLWs4RRycw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5YRk6Uew6qiyrUxIXed1cQLg7r/gS/RFSkLUGYxCS0=;
 b=PLppsmyHpbybcGCBeKz87v+2/UcalV1EOX8/Es/faA5vzuXCIHP6a6pOSzOzs89vtcnJdmSCuZT2CHh+3yzPbqQvrQq+VBN3pfCjBs3psygn33JAfb6r0FwssF7flsNACUJ9knWzCQa4b42cPpuk+JDVtgdeF89NXz/ijwpcz9wvH3XOYPCpxFMpvAhYtkNYPugBBJnxwrzwtyguA7FW8UdCr+syT0L2GMKLIUlRzFsY0ytqqyMbdietF91yCmYAN0qnasCjWwTcU9yc32wxxcYgcZ1Y2PNJ+UkyfYkgVgNev0F6rVcAHpmBc/KtZR18wIvFKITbJvLaeD2TsxQVtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by SA0PR11MB4574.namprd11.prod.outlook.com (2603:10b6:806:71::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 14:33:06 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9%8]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 14:33:06 +0000
Date:   Wed, 15 Feb 2023 15:14:51 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH net-next v1 7/7] net: fec: add support for PHYs with
 SmartEEE support
Message-ID: <Y+zo2+oaFe9lvVA6@lincoln>
References: <20230214090314.2026067-1-o.rempel@pengutronix.de>
 <20230214090314.2026067-8-o.rempel@pengutronix.de>
 <Y+uMDEyWW15gerN0@lunn.ch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y+uMDEyWW15gerN0@lunn.ch>
X-ClientProxiedBy: FR2P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::7) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|SA0PR11MB4574:EE_
X-MS-Office365-Filtering-Correlation-Id: d8d7007b-657e-411b-078c-08db0f618d9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tdM04WnayUebVpShLLOsvq6ENrLBKtmiR3QwGFOOHvOQjFI15vvuJlCRZgnPHf2BMw1jz+QVOxrPZZXU8jKRXYYwVYzPmex9to5u+X1kqWby1i6gcFReZknetw5+ZcK0WSVTw3AWWTiaUmrtKJA39hD6Z1+KG5OC7K7yVgEZQBPTNy+MXVHD++q4f78+7E1CV/SaVCKGucvGhx3S9NPLMwjCkQcbNTqw3z5u0KcLYNVVBZU1GOS5eE9nmfoXN3u/i9pefozwnFX46OQhU02ZGdGRb6uXD91KFt/zPUFDti9p9Vgd53MhY0X5rkqWTrZk0NEheKW29F6QgZKNJBtd0vXG/NeoE7c40L4Da6qLPqLR4C8rq4+QJWzSuomr2U/nrwHzxAvJNityTA4IKy5s3WppaQhz+9VARNAEbE/OxiKKgJUpzt5u6VCAnrZdlR9wMCmDLG3acyfJ3kgZLX8VqsX0+bWqXbUhbJFpaM+aQ3V0HQ8V25Ry+32Q4Hz6M21aXbymGoR2+dTZAlKTUCJC0JvAzZwxCuWo1B52m9M4G8X02SUYgJWaIbNUjVfd2uT7H3PKvx9Db2dqzagXFmDyMtKT+3GXCISgxkMPomCOjBuUdn4x8SGEiH42t6ubuaB1xgNKnZu9mk85oUOlHmQWZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199018)(478600001)(6486002)(6512007)(9686003)(26005)(186003)(6666004)(44832011)(54906003)(83380400001)(316002)(6506007)(8676002)(4326008)(6916009)(66476007)(66946007)(66556008)(41300700001)(7416002)(5660300002)(38100700002)(82960400001)(8936002)(2906002)(86362001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ne2e1+yn3TQKDLfuI1/Opcl4vMgVALjDCbXsVquTiM3PQqHAH/EjP+7fNGny?=
 =?us-ascii?Q?C9tCqsJSJDzz58hRg4+U4PjGt/Ql6UwldWveeQKCzYFmC5//hlwQw3FPvjg7?=
 =?us-ascii?Q?p6rtZJ+u8UavwrnJsCO+GAQ99K58FpdkOPeJOO2G5rR/JR3LL9aW+ydsRFhm?=
 =?us-ascii?Q?rTa0GPJo3/dwXTrQ2hlwFQATY4fF9OVCT1zZHK/xz5r/s8Kx9EHBvY57BMVc?=
 =?us-ascii?Q?2MviVBbZp/ysFeuh46VwdeW8uwN2OJWh+qniWF2YuMjcR4d5nFsE/Vmv8d2f?=
 =?us-ascii?Q?YHcpKMVyz0izs2HblUiUAz6+/mU0pJ0uVWlZKwJwWIme2zrMZEcGXMqJD6YT?=
 =?us-ascii?Q?xSaiBI/G/RsiU28sfNSYLV+zXb+A4ScSP/jIXmoxUH+xyNgcUICrIxKJtvNB?=
 =?us-ascii?Q?QftcbG0/wKf6qf8NFAttTWgitMMglYosqIkW5JMgHDesDOHfkAebumpXJX70?=
 =?us-ascii?Q?3bLCul7ybSQdDa+Uha5WdRhAXbOb7YZznf/4zuJCQ7gY0xWgYquUD6SDIHat?=
 =?us-ascii?Q?4n6PbqYAxz84tzSx9wKarxyUk96xwDfbVqatJ2uasRt9M2Yw5i/MjOXJkR0r?=
 =?us-ascii?Q?zBXTA8pnpA0iXHEtRa9ji79aHpzHGKAb+W+kFuogVNTcfp+bSo4zFOO+pnUM?=
 =?us-ascii?Q?zECRDSEQWlg48IxXtxwDHxQ+ZaVvbj+ksAzbdgcJCxxKHu6IqGI7oGopK3p4?=
 =?us-ascii?Q?NZnX+wNFFnLaOGYUqvHbnL9OEttV4Xw8VYKctIjDDRfSPeCwR5N1XKsp5DEr?=
 =?us-ascii?Q?hdOKyl85Pq55TFTd2i+Q1Yz9pfaKwU3O+HVAHMfn8GmzTbARnCMfd8uSyYGM?=
 =?us-ascii?Q?0QbL1Y65q8viVqaGvUIVGByehDfO5h1MbQ7tKB7ShdmGnBIamNTYFKpEx7VO?=
 =?us-ascii?Q?GRwHz1uOTJvIB1LnukqYX+kv1zEz1+Rv0O5mrld6X0igpLLIT0YEVTFq/41v?=
 =?us-ascii?Q?uRpbX04WY/hw3spwNTBup48Zh5PL8d3whi8V4m4wzM5PDSCgONyPoRk62VSV?=
 =?us-ascii?Q?WWKxBXrl+Z0v49F3O8w9Z03/iPDnPVKnsjWjQPiZRm6eGt6D5deogKqHyd//?=
 =?us-ascii?Q?cTuWsMCJHg3JLa20HsRlikl2Y3zZY5qK79/TglsUsva7Q9k07hbx4KyugGDq?=
 =?us-ascii?Q?FRealzOJwn7UEzhSrLlUKU+yA0yChAxcQKa/sGmYB1jFiiVqrbkf8NEb5yNy?=
 =?us-ascii?Q?syrHsJ8zWGJfYE+s055T6orIKgIdcQ4OMhAC90zkkcHxt5LOu1N/6SFwFmC7?=
 =?us-ascii?Q?U1ek/1KVCBRee58FITea6NyjeHwR+wOIOvgpLEIQhq65hW8G2rJ1bxpuLxR5?=
 =?us-ascii?Q?uOLOwmYCDtbUUp3WiItaO1Pz10hLVmFc+A1XcT+t9LGsMfFRlyjW9OjmNb8N?=
 =?us-ascii?Q?300IiXSLiv9LegBPRBi7xN0Fx3fdLo6SCkFxspKQ6c5FVnoSFNcmlS7Pg9ZG?=
 =?us-ascii?Q?OVQUCsD4PF+qdmTEcquOW+KMLWTPAPfaF5Rzygt6omDl3MSUi31rE2miRWIM?=
 =?us-ascii?Q?YpsLQi+B6zT9WA5fGV1duTajE6BuETB3rsBwMaNnuAjzXNvopHlxOrG7QzGx?=
 =?us-ascii?Q?m6+BLQbd4lcagZgBMmCAid8LTtR+MlQresqNnHlIhvNoRhFoeaB63/dF8j9N?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8d7007b-657e-411b-078c-08db0f618d9d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 14:33:06.6898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3ksK8pcUlZIVgxYkaqpfXkSXttlrLY6HBN1Jyb8KdKBukhpDGqyQbUNbqYs0qilTQU0t7qW/BjK0yK1slliEfa0HKZqBNZS1Gwbp3I8rbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4574
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 02:26:36PM +0100, Andrew Lunn wrote:
> On Tue, Feb 14, 2023 at 10:03:14AM +0100, Oleksij Rempel wrote:
> > Ethernet controller in i.MX6*/i.MX7* series do not provide EEE support.
> > But this chips are used sometimes in combinations with SmartEEE capable
> > PHYs.
> > So, instead of aborting get/set_eee access on MACs without EEE support,
> > ask PHY if it is able to do the EEE job by using SmartEEE.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++++++----
> >  1 file changed, 18 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> > index c73e25f8995e..00f3703db69d 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -3102,8 +3102,15 @@ fec_enet_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
> >  	struct fec_enet_private *fep = netdev_priv(ndev);
> >  	struct ethtool_eee *p = &fep->eee;
> >  
> > -	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
> > -		return -EOPNOTSUPP;
> > +	if (!(fep->quirks & FEC_QUIRK_HAS_EEE)) {
> > +		if (!netif_running(ndev))
> > +			return -ENETDOWN;
> > +
> > +		if (!phy_has_smarteee(ndev->phydev))
> > +			return -EOPNOTSUPP;
> > +
> > +		return phy_ethtool_get_eee(ndev->phydev, edata);
> > +	}
> 
> I can see two different ways we do this. As you have here, we modify
> every MAC driver which is paired to a SmartEEE PHY and have it call
> into phylib. Or we modify the ethtool core, if it gets -EOPNOTSUPP,
> and there is an ndev->phydev call directly into phylib. That should
> make all boards with SmartEEE supported. We do this for a few calls,
> TS Info, and SFP module info.
> 
> Either way, i don't think we need phy_has_smarteee() exposed outside
> of phylib. SmartEEE is supposed to be transparent to the MAC, so it
> should not need to care. Same as WOL, the MAC does not care if the PHY
> supports WoL, it should just call the APIs to get and set WoL and
> assume they do the right thing.
> 
> What is also unclear to me is how we negotiate between EEE and
> SmartEEE. I assume if the MAC is EEE capable, we prefer that over
> SmartEEE. But i don't think i've seen anything in these patches which
> addresses this. Maybe we want phy_init_eee() to disable SmartEEE?
> 
> 	  Andrew

I agree with the attitude that we shouldn't expect legacy MAC driver to handle 
fancy features of PHY, so modifying core code instead of driver code would be a 
much better solution.

Also, I too would like to see the case when both MAC EEE and SmartEEE are 
enabled, to be prevented or acknowledged, if it's actually useful for something.

Other than that, patchset look fine to me, so in v2, you can put my Reviewed-By 
(Larysa Zaremba <larysa.zaremba@intel.com>) under any of the previous patches 
which stay unchanged (except the 4th one, you have to correct 'specifica'
in the title).
