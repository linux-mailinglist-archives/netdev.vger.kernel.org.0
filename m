Return-Path: <netdev+bounces-11984-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12A20735961
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C228C2810EB
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05282125B6;
	Mon, 19 Jun 2023 14:21:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1448BE5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:21:07 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2104.outbound.protection.outlook.com [40.107.243.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798B4E64
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:21:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgSx3BOHZcZpyCTH2NSKsNx70Bl1NF72wvp03qclMvbNs0m0KCq2RrXga3VfwDL/HTs+WBaanZD7Tev+uR/Po1cVkw1qVssT/XDFmjjdHX8Q7TfH/UWgc19obdEzjTw74mZt5EdztUK0tvX9t7n4cU2BsT2OocU5IyI7ka7FBUy8ciSN+4Zh7tmOH6LCoNDWkkRYXb4omC3WjRSZRTHhykryQ5Bd/T3BdG2B2WSftCKuYTT1N+yzDonb7br9LVX7alUMURKKf3znE66tO4uH91ou2wnaInLCxdOsVqdXosTwwduhLaj/i2oVTbDim4+i6um365+dTlJ2pYOyPjsL7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HwA27eDrtag2TUfUL3Gp4LaCcHCK8oSYpbLaQcE5i2U=;
 b=bG0RUc/4qVn3Rr0guMyZr6OT4J+Xi3IuRhPe4nAJWQqWUK0m47aa/w7wBuZibXdij+m+Ii2qtkSW9AzeVgnFVNkQ69MJSQpBW9sGb16q6uOHrKYxdPXlSvFnpocCKlObxy/GS75DiBp7Me5RDSYLuLSpX8EXnsKP4iApwF3HFvglrNBuCmYkD4gJ9GwV5z5a86LOLbScJ9hZVbRy+0QJNYSWpTYeyhvy8SjCk/Zv18L7troXQESw6y6b9grp8hn+0ggDMCoqzyPMl0hgr/Z2iMeJ5PnIdE0UbYaNR1jBU+/pkjJMwlrJqoQYLnCX68mT7Rtn3XzYITOJI6FQb1iPlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwA27eDrtag2TUfUL3Gp4LaCcHCK8oSYpbLaQcE5i2U=;
 b=R91/bpV/mzXIbJ4lw7cPYPSbq7+BT1X7UcjjDrNBcFxya6mGOQ2pXCrwC7+1dGRI1r4Y8uscTR5s2GKHizvyz69LiaXFnaCWrW7Gfr+uWs3I0ST2pQ9IVXYmryh9SuQmPv9+Tj4GAqRpf3Z+K1EP9TyQZ4LXXDC6JwyqujZRsDs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB5025.namprd13.prod.outlook.com (2603:10b6:a03:36a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 14:20:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 14:20:56 +0000
Date: Mon, 19 Jun 2023 16:20:51 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev <netdev@vger.kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH v4 net-next 5/9] net: phy: Keep track of EEE configuration
Message-ID: <ZJBkQ8yBOgJZqM2O@corigine.com>
References: <20230618184119.4017149-1-andrew@lunn.ch>
 <20230618184119.4017149-6-andrew@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230618184119.4017149-6-andrew@lunn.ch>
X-ClientProxiedBy: AM3PR07CA0072.eurprd07.prod.outlook.com
 (2603:10a6:207:4::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB5025:EE_
X-MS-Office365-Filtering-Correlation-Id: aadd82d2-a924-488a-4016-08db70d065d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PNS6Smww5C2V9WVxt9xHBcjW6r59C5vxfy9soM/OtXVhUu/m+S5LF32fTTykYbcloG+FWcxrAG4uBhR3BKq4wiIsFoqrCSbM5K44dUb2Ii/2RstzulMv+gQ+YM1gh7ymAzDDVHFS+8wVFqbgoR6d7NCHEFpPHA78iVITiJPl1pkKZSDkkFcSexzrjYTEG57l3IjCfD4CA7Apv3EiNkvh9yFTxl8JETL4lchy2Wb5GASZwMfFOtnlICnnKYlt2m2MfTfKdwCx3ir6r+ojGR709JHMpNP43NXSRI4ndruIOIR/qvWgJW+UUQO/SmP8TXeu3sCFne4yUgEDfrZrqPpKuN28bWV9ChNEKZA+XdRvMDZNUX3b3sjWPKjyJSuwo8Bba3jwOJFKtaDAJU9DXy5BJf2wuwm9KJRoTyO8xp7hjJTvtJYupoezx87+L7l8xxoOdqAVaGSZnbNN27/BDBOtx/+wPELIfau0MA8HijahBjFKrBkzAy3K73TxobwgtLCX6sHFPNqhdGDpmDxQQCcB5pprK//vfs3zSPJ9lEVurjeDuVGyGKQE03lT1jjNbqO0iX6jmQX+C3NJS3BapWjWmGTqH9zx4njhk8oRBzJOShI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(136003)(396003)(39840400004)(451199021)(186003)(478600001)(6666004)(6486002)(86362001)(6506007)(6512007)(54906003)(2616005)(38100700002)(316002)(66946007)(66556008)(6916009)(66476007)(4326008)(8676002)(8936002)(5660300002)(44832011)(2906002)(41300700001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iLjz/SJMVavfodYUGWwkNFb0i+ULmHg5ApMzQP2ko/aeJGVhsJtrTGgSL/uo?=
 =?us-ascii?Q?03fzxp0/0v8DUyCXWjaf8qxyJSO/NQaRBKRCxlkIpbAbmIsmmm4DWXBx6EHF?=
 =?us-ascii?Q?9/6Y68696VtF0Je45eWRy2Ove8TUwRZG1uuQcSIt/mA0MjvWMi8L+VfsZ0rb?=
 =?us-ascii?Q?yYgPuMqbaXxjQERAlm87Y/cKTZGzf/D47bm5k9cnJpe1f83IqngEUGwHkU7M?=
 =?us-ascii?Q?VDbKAeFAd3tPf6GL8mVUKm0BW/LJjIYKNRBTCdpGJ3yg6H78GSvHliVZtB/2?=
 =?us-ascii?Q?jnrpsmF3NmvIenkOTiOTJ1Kh6ykyejqo5wAWhUmTzLYgB2uQv3+c57MmppVc?=
 =?us-ascii?Q?ZkSPtk2ZY4Sv0isgPy5i1BkH8oTUGdeoeJ9LYxVbNEQ4HSGy443Veu0bdD1z?=
 =?us-ascii?Q?lGdUUYZOGKfC69gBODCahSqXHipISE13NyspVPO4SfrAg/H6iJpNQ29emteu?=
 =?us-ascii?Q?wT4BgeUGAyqW2kcCIUs7FDeoIllOGl0lN+3+czrWV0MLpez7lgbhDzdNJfAb?=
 =?us-ascii?Q?ThGhQDUrseXqg+8Ai9NxMszXWcFSnoyT6eejL+HFtJ1Qwb3vHBIONC+ZSXy4?=
 =?us-ascii?Q?XI3NC/ibDI29/HkxqUQQ4ASKh2JIoM4jXLhZfRcXPSZrqYewbv/fXzwcz1tR?=
 =?us-ascii?Q?TA7xM/wrhwItUENDLFTVk0BbRBqUfPWHWrHvfpaZj/3s0lfHg8xfGsqGPlnw?=
 =?us-ascii?Q?RnglM7uMleuvIVRUjWQdUMr41O8pPTVvrIEPRabH3pAE/COL39iQpaBXjMfY?=
 =?us-ascii?Q?DAzESXnJ4rzhWykRnwMj8N2u2klJt/x4R/6FLT1PdChmfBesP64AzkdyFxsu?=
 =?us-ascii?Q?f5eGfOKVspYyTbnhhGytsH/Uu3cKv4/f6DajdnDblPMDRT4cnGV0WLycELry?=
 =?us-ascii?Q?9q6P2QOWu2Y1ljW82pYWmeuoCP2d8TrU5cm7ht05rCOkiPy0hz1muPOO2St4?=
 =?us-ascii?Q?++UOwF66flaJw98Xc/iWaZaWSOgix+CyhTTwRJ9eedSpK+4CDGi8+9RBfXGK?=
 =?us-ascii?Q?a1mVZfUCBPurOvB6nVtZh1qhVJnXBXimQ/BwCoobRAJ/q6njFgjKy99GCHXD?=
 =?us-ascii?Q?Wzb2PkBnVs7gkE90wchaUZm0QWVTyBDolJMqgVZFqC4Fty8poib8UtE3Ouyy?=
 =?us-ascii?Q?b7PWYeGxncES7117Cw1et01hbsc65Mb6tdiwpGoyx3h+UXGZRXx6dtwiKHOs?=
 =?us-ascii?Q?2BRpYsR3aLhqXl66SH+3d0Np1EP1COJ+ckrQ8NwwTgJ0sqHwQ8defSuLvNu+?=
 =?us-ascii?Q?vb4fOrzjM0+czh/QWJtoePSHkvsb7uX3ZZAl6LHy8SD2uEJRzbE/zKznKo2k?=
 =?us-ascii?Q?QFrcFxtNj+rpKk590naTcEJfpm+wENH4Kln3dYd1mBp2Xb3MSwDXysVkLr1f?=
 =?us-ascii?Q?0kr3E2s+cNr/mYn34cBDmOPA+9W5CPQcCfc29eWIKBlBUzdpgZexUU4EKJCy?=
 =?us-ascii?Q?6wTHiFHIprt8OdAo/Kb0HNN7hsNNO+VlzoMlAGlTDO0zZen9RAC4lvqQvB5a?=
 =?us-ascii?Q?EKnHPIA+RbbS3oxLG1Fksbp360OhLTd55d+4/YcDYALAXFgK6pTVyjSvr3QG?=
 =?us-ascii?Q?pnzD6PbIPyzsflLU521ZbtN7chAA2i4G23idRw2I6zDKnN2HbUKoyW4mZOxg?=
 =?us-ascii?Q?d6AmbP9H0+AL2uZrndNNsrFMjbmBvJ5CDJDBpJ+3wyGT4lbPSeLF+CtAttNs?=
 =?us-ascii?Q?En/NNw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aadd82d2-a924-488a-4016-08db70d065d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 14:20:56.8301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9VQyJFIt6iucjKp/grtQJQ6oEl+4e6o/XmIUrQ6lkOE6NEDtf32PppW93prXioyEcMta3ho+F5VqZ01qZ1nycXFCecBCCXfrv2Jl9wPKPag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5025
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 18, 2023 at 08:41:15PM +0200, Andrew Lunn wrote:
> Have phylib keep track of the EEE configuration. This simplifies the
> MAC drivers, in that they don't need to store it.
> 
> Future patches to phylib will also make use of this information to
> further simplify the MAC drivers.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

...

> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 66f69d512f45..473ddf62bee9 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -30,6 +30,7 @@
>  #include <linux/refcount.h>
>  
>  #include <linux/atomic.h>
> +#include <net/eee.h>
>  
>  #define PHY_DEFAULT_FEATURES	(SUPPORTED_Autoneg | \
>  				 SUPPORTED_TP | \
> @@ -585,6 +586,7 @@ struct macsec_ops;
>   * @advertising_eee: Currently advertised EEE linkmodes
>   * @eee_enabled: Flag indicating whether the EEE feature is enabled
>   * @enable_tx_lpi: When True, MAC should transmit LPI to PHY
> + * eee_cfg: User configuration of EEE

Hi Andrew,

a minor nit from my side: eee_cfg: -> @eee_cfg:

>   * @lp_advertising: Current link partner advertised linkmodes
>   * @host_interfaces: PHY interface modes supported by host
>   * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
> @@ -702,6 +704,7 @@ struct phy_device {
>  	/* Energy efficient ethernet modes which should be prohibited */
>  	u32 eee_broken_modes;
>  	bool enable_tx_lpi;
> +	struct eee_config eee_cfg;
>  
>  #ifdef CONFIG_LED_TRIGGER_PHY
>  	struct phy_led_trigger *phy_led_triggers;
> -- 
> 2.40.1
> 
> 

