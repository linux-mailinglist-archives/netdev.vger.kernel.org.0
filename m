Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29388638B34
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiKYNdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKYNc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:32:59 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1814E2612F;
        Fri, 25 Nov 2022 05:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669383179; x=1700919179;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=l8klgzlEBtQk+YYQNAe5meLmxuew+Vxga6Kal34+PtE=;
  b=SwYWAx07sgYhltE3uGNwvaRITL7JJfQZ6kUxknclZSggaGlsBbawhgg6
   ZhoZtHTXb5D/zyjTDx6pc5fc0hiVhTc1Lw+UJmgDemckEk/+TZq3vHPaL
   aWu9hMJhw/P9bKyvwkMWa8cqxw9orKww9C1GzZ5UVPnnLFRcfz7yEMm+X
   x3+7aQYdJf3nt+wqUZBNq2tkYrSzPbaU2ZQ2J4Q8l8p+CQ710PE705cS5
   gX9BCqvL4+g8tTMhtbp9ouo4X62avySAlLuSY+OYgJVNFFXWt5MTFfJD3
   a/OQe58YCFIpbTZrHtOvQOnfoVTGeh/Ri9+f4WRD5tay+1lFYbztbiKTX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="302054707"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="302054707"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 05:32:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="817144738"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="817144738"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 25 Nov 2022 05:32:58 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 05:32:58 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 05:32:57 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 05:32:57 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 05:32:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BM6VbhYnJwuaSzCqyHAUP+ErwGW6qUxq4zwndvXldVJJf6eIiJozsPlSepMo+D3JNAnv12pzVMFxpHk7sx5Bl7NYcNZuHuMoLQSROzaB3AX7Gz1y297SDXBdhP3oeV75CRCK+JRumtPLZ40O8MARM/G1pd6ZuXBNjnClWTf6yQ5HfIY+YesfLz4WnJHWI2lsvVRh1juCsSbjSbQUScPskOaIdoCJQzBl0lSJLo1OdqlmLyticAH6R8ieNbms/hQOk5FcJlm0KPIPYCfzh5h0HYoUOzBMoUGpJvcPgxJS5DtZEGXQBBmIJAdeSTejJNpvPRntqjRYestc44qA5jj9ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5w+g2ZRZyzBB9fHzsYR/Wd16ohFrcQJFfHDJDLDrxk=;
 b=OKA4uE/psXmBo7gHOPZt5/BA/RNCw0cPWHal69t8SJXPh+qgusnoVaSZ6YxPKVnS83n9eTqoCHbX0nS+hmEfR7kEQ+6RD1kFQu8e+PbD/qtDIMOCYhiC6vmjsTOXn1Eeqr2HLvryIFXeHA05BJTfuyLs0yEaxzZ44uMRTbJKZ5JqE5QhgagoGfglEHQup6c8thkHMHEluMPYMs5upFLmNLYWJA3I/9E3VugZ+8FXh6n9dk1sJhDp92hnX8jw5b1HHru5GFaAshViWjZ7lhpkqgoFqoNI5cHd+ilRMmXRTknEpwVB90QIWrk1xtiNu0dz0k052UkHtjyGQCiUxDK7mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.20; Fri, 25 Nov 2022 13:32:55 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Fri, 25 Nov 2022
 13:32:55 +0000
Date:   Fri, 25 Nov 2022 14:32:47 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Yan Vugenfirer" <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Subject: Re: [PATCH net v4] igb: Allocate MSI-X vector when testing
Message-ID: <Y4DD/5BtgD3TjdW2@boxer>
References: <20221125133031.46845-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221125133031.46845-1-akihiko.odaki@daynix.com>
X-ClientProxiedBy: LO2P265CA0063.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::27) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO1PR11MB5154:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f990c1b-8e3a-4d90-5bde-08dacee98f67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmiSgZQx//5yQd1H3olYnfyYJdrD8mNE4cb9+xkEzkstgo3E+w3b5tHaCXv0SLxWbAOFRcG2s/JrNa8K4DeOrsE8vdeFnVHJ8N3vvH6r1RsMEA3Fe/eq7xi+EHEhN4f7skXZFadS6q97GOw/SJHdJwnSF63AwY2zp6Wedg5W6By6eyftx/81eDS7Yb68r0XMGwvTY0Xy1qrgWwrfn1DXtq6Y1daVwngmJCsvq3PKPLAt/GxW1Kdlqxmsq5loUeCgf3wBiIdomeIqurs8hCAf9IMwNcKvT2GDx0uMn8fnS2yuE9/hvPHe2A01kSIzU9B3xF70v0QTtcAsnpP4CMamm74+5wGSMhhwx5iH104eVmp3nE6yRJIeKAoXvgrXmJ3aWuqpZNz+8/f9SeNBb0UUDSV4un4W2t47OwtTGpnZKaNW+/kCcCXxQqdKtOBsUfXrCjYwc31AHnYLO/hAs8Ch1DU8WCy5+xRNDvVoKaU2kutZg/FRoqRPUbzyl0dr4DlTLJvhLxC37aCv3jQBHVHgBy64ekpf//JsoTZBL3gg+a4DqJse+Fft3r+NMUF2FKhdIPm2OOeqbi3v/g22/ZHVLQMiPMrBKsPXlIsmpk42L0/nWwGdIkRoDS8qxIMS9nTGsHGSLeFZWJKpN7EFY6NKDlaiOd0IVqq4/cg3vUbWPBRpMhRuUJ95x0YbluATtJtw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(82960400001)(54906003)(478600001)(38100700002)(2906002)(33716001)(6486002)(4326008)(41300700001)(5660300002)(66476007)(7416002)(66556008)(66946007)(8676002)(86362001)(8936002)(316002)(6916009)(44832011)(83380400001)(186003)(6666004)(6506007)(9686003)(6512007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sA61TY3AdwOz8a12LhsLsrtWA2dkpAbM7PQ9XW4HdapvnSifkIx5GxpcQsBa?=
 =?us-ascii?Q?snoyJdBn+pZfs8j7GPafIlAOgoBzjqvQDzZfbSf2Hq4KKhxJblDaLz8mogAG?=
 =?us-ascii?Q?hXTfK/SZNwK8kfUlhkSIjpu8pqjMkTVPYfc5TnPk7YoCw57L/Ur+YBbGIuSu?=
 =?us-ascii?Q?Lfz564Tk44Dl0rxeEQdYGVlaxEA+CZdDGtdWOaT05d6P/PyV13UeJzw7iC+i?=
 =?us-ascii?Q?eFJb/ymf5iJjZl60qT4gK+3s+Ce90MGl18kgw6pT7cZolM76AVyvwKksUBTA?=
 =?us-ascii?Q?dBByn5soncMHEBFp8qVSAdKZYOjtt2x5HFLFVhcVDqsbfl0aGHQtpAukAhP7?=
 =?us-ascii?Q?Spq9jm3E2q3u8BuFuQUUU4ZCUHv++uqL4lKBL+wzHXz48DrXNoHjEfq2Fihl?=
 =?us-ascii?Q?uK/fXGBToxER/1atBM7stj789OAzDtkP2YxoidOQyQir5/10SlKJhE3DGSLk?=
 =?us-ascii?Q?vOfZ98rYhgSXgNGM1bqSEWqS9g/o15ONdUU+BXaShwbu9eWwnrTLvq5K2CjW?=
 =?us-ascii?Q?Xzh3mUrOa30/TgIqTNp0ymrs72LmI/+FXokQ5ipJ96m6SkHW7km8cVWtDgT/?=
 =?us-ascii?Q?Lna5grSI4k3iVpZcXWIsCIGYiDkn56qDC4qjQ5jBQCcvHgW2j02wFQbohvg8?=
 =?us-ascii?Q?1/ENSHKrTGrxRKoJVcbdAlXZ5xJr2ST+omLIbl3+M2r2ECkDP9n16Mtq4Sx9?=
 =?us-ascii?Q?pDJbMe2rS0FJ777iSuKH3KCBX9m1e6r/GAP/zb5qupEv1noKzr4+u88WoT59?=
 =?us-ascii?Q?pKnqgaxI7CK1at9ISkBtGqyU8VGKhv2kDYKMYM+ytCYYTIWv/5oLNI2sC+fV?=
 =?us-ascii?Q?V8KcwB0Npea0dk5Ga2bx24y+ap8gE7ypx5ilpFewDw7nVMEW5/P15MABtk0q?=
 =?us-ascii?Q?cB5FiXVSGi1k9uQAnXjCkQV0bGKWPAW88j61SxwNM+FW7NiRcE83QMHbyQTm?=
 =?us-ascii?Q?nYLL88fXJYCgRjmAxrhlWRCYhyItPaNlX14W2hzHBm+wkvFA7FBjY+XxlxX6?=
 =?us-ascii?Q?mIq1bW3maYYCR9DY4SVt3DSRpdtpblb5uOfTG3dtoV18DNRODaK434djNNtj?=
 =?us-ascii?Q?r5xrsWlK5u8KjAqVhraO7TvhuoMdHWoV5h7XCWIcOM66F2yuyCzoOykA2VNR?=
 =?us-ascii?Q?9NkDUbxz9k85t3H1TIOAddUMcSpL7RnApkRtIQx+ldPiF34WWNRb9K0h6tOq?=
 =?us-ascii?Q?0o69T927Lp5M6jkER3ANoJOrudf7QKMxNQt//NiCp8+gpLjh3rJSNy2Xd2NS?=
 =?us-ascii?Q?pGdBMfQgeOaMM8RT2IJvI11w3ooF15VcPb28Cd+ucqRQpOAhaaDy7ViiFJsO?=
 =?us-ascii?Q?Zjy1r/TwHnURLSOi8OEXor/zOPbeOH1OB3OkmuNHPaqX6y3ecCeYUJyZ6upJ?=
 =?us-ascii?Q?YVw2v8pUc90PQEvOS/p5QWFfRB1y1D+bq1935NjQ/3tD3AjxYX1ZqSVy8QLA?=
 =?us-ascii?Q?zaCpWQimv/yzjKzyHK9XczklFGJsgu8PnI3KoHgW/O8cPfdbUFymDG2BFsj4?=
 =?us-ascii?Q?x4bFf8LYbFVnJGNV1pl5CBRqQ5VDHHG6AZzqeX0rWMCRLejI3WFwbhlIgGGn?=
 =?us-ascii?Q?zIVtWXpiu/x6NJ1OcGMaa1EydAakJqtzZr92uZGX9+W9a8Q2vnRLy4+RaS7h?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f990c1b-8e3a-4d90-5bde-08dacee98f67
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 13:32:55.6213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A3DLbkxAGP4Esk2L7Em72AsFO/+LV6jRT1Wj0Nl8EIN+UclFygnuwi0b5eQlbIkbhKN2T6Y3uCORA2cCdJLJvp1094BOKeHkBlMCO8ZuUYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5154
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 10:30:31PM +0900, Akihiko Odaki wrote:
> Without this change, the interrupt test fail with MSI-X environment:
> 
> $ sudo ethtool -t enp0s2 offline
> [   43.921783] igb 0000:00:02.0: offline testing starting
> [   44.855824] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Down
> [   44.961249] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> [   51.272202] igb 0000:00:02.0: testing shared interrupt
> [   56.996975] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> The test result is FAIL
> The test extra info:
> Register test  (offline)	 0
> Eeprom test    (offline)	 0
> Interrupt test (offline)	 4
> Loopback test  (offline)	 0
> Link test   (on/offline)	 0
> 
> Here, "4" means an expected interrupt was not delivered.
> 
> To fix this, route IRQs correctly to the first MSI-X vector by setting
> IVAR_MISC. Also, set bit 0 of EIMS so that the vector will not be
> masked. The interrupt test now runs properly with this change:
> 
> $ sudo ethtool -t enp0s2 offline
> [   42.762985] igb 0000:00:02.0: offline testing starting
> [   50.141967] igb 0000:00:02.0: testing shared interrupt
> [   56.163957] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> The test result is PASS
> The test extra info:
> Register test  (offline)	 0
> Eeprom test    (offline)	 0
> Interrupt test (offline)	 0
> Loopback test  (offline)	 0
> Link test   (on/offline)	 0
> 
> Fixes: 4eefa8f01314 ("igb: add single vector msi-x testing to interrupt test")
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
> V3 -> V4: Added Fixes: tag
> 
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index e5f3e7680dc6..ff911af16a4b 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -1413,6 +1413,8 @@ static int igb_intr_test(struct igb_adapter *adapter, u64 *data)
>  			*data = 1;
>  			return -1;
>  		}
> +		wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
> +		wr32(E1000_EIMS, BIT(0));
>  	} else if (adapter->flags & IGB_FLAG_HAS_MSI) {
>  		shared_int = false;
>  		if (request_irq(irq,
> -- 
> 2.38.1
> 
