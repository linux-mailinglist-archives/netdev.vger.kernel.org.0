Return-Path: <netdev+bounces-8596-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12076724B19
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC4A928105D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAF022E3D;
	Tue,  6 Jun 2023 18:20:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BFA19915
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:20:38 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEC9139;
	Tue,  6 Jun 2023 11:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686075636; x=1717611636;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TxVc5C+7nGVrUG2+fEjqPyP76MhIQA1gUbVb47Ufwvc=;
  b=XBFqcxbFJW9UXfintcax/m0vrEWJ/MAGCqvxZbctGi4YfYcJWpFT6MVB
   k2V2mbEq2NdGc3dLr/x+tSq8pYT/8tljkJ2gazGS2G4JmIrWmVvaETCIq
   N1eHyIOmDJ5Lu1bqp2gPw0eDhV7oXomE1fpyhfiAPOJi1j2g7Pwsll0gU
   uACoifzhXHlKR0cqeWRR81Ios8Y8s/SYzX+VOHZT2hc4KKKTUfyBUNONg
   Ok2JBvPX/lM4DbEZA6zfsAeg0DCXMkbyICLaFGN+yAo3cMqoRVK0GcbAN
   mkIv3ML0X+6pg1WLfWMjAx/ARngM3AMN8eRG3vm9ONKsEo6U6ZG7lFBjx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="337124623"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="337124623"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 11:20:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="853543730"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="853543730"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jun 2023 11:20:36 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 11:20:35 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 11:20:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 11:20:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maBi2qFNYQsX8l7RJYQ2MKmwpQkPukW6fiyY6X/mbvCDwu6sMgGylyN9nteFEgR8zUpLyyxAJyLz0YScD8vsjndbyY8Ns+td+3it+NULTmimkhly7fyedEvU25LuyNIfLCGqxMMfhNdKMa+NLw/kZwP4o8HiDbjGXG2F4aZyIEjfGO/d4S5aPNhLeeiPfF/oa5xoAEEOXpJEerogTRTV9BIjWVTr/Gy5qWw8aHLnSXkvCMFuB4oG8nEhlmnRIT+9Lb5WOSig1mNGSjHKWsD7hKTZXNljIeNOA4fv+HDJb0DHP7/Mk4S3jRLFBfW6WORXdImuQGpKwIjrgHPxxIxIIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AVmA5ho8MBjEHlvW8tlOjFYWBU1FXASfXj9noLFlwM0=;
 b=PpruPrmT2oO1BQY9dRN1Pl7ibOKUZdv18xIoK8w0imgWcPe4ChHI5PN6sPGxM/xekFJCPB/2m43LSSei4AEIO9Zw+/ONQE8IGMrJs608tRGvwj8bIBoE/NGR6ow/LGw2AidM8+U1s2CBYWIyC5yTEblj50CY24bDcsBQVHs8DCugsD7NAOvB2/SdvWI44WXjQj9q3d/0uN/O0qMZN+zidGgvB8ASWiZPkWaYYa0WdYOOTDUc/CBnsdxRtdVD5f+0Z8AbkRJdhSWgjFVazfgto3A0xVa9c2DVrSTJjjmakUZTmaodJ/tB0OGLNSduZg25hUNHfbSer1CO9xB+DhO0Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA0PR11MB7159.namprd11.prod.outlook.com (2603:10b6:806:24b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Tue, 6 Jun 2023 18:20:04 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 18:20:04 +0000
Date: Tue, 6 Jun 2023 20:19:53 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
CC: <netdev@vger.kernel.org>, <andriy.shevchenko@linux.intel.com>,
	<Jose.Abreu@synopsys.com>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>, <linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
Subject: Re: [PATCH net-next v12 0/8] TXGBE PHYLINK support
Message-ID: <ZH94ySvY3BSSrM7l@boxer>
References: <20230606092107.764621-1-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230606092107.764621-1-jiawenwu@trustnetic.com>
X-ClientProxiedBy: FR3P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA0PR11MB7159:EE_
X-MS-Office365-Filtering-Correlation-Id: 0149bb1c-b4d0-409b-a0dd-08db66baa65a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RQhr8a+s5+SvMxH14quqDPU/85gnOHUes+LbwsWN2fhGcpRNFkH0izs7I6XXx5dIQUMHROWHNklprdVG50sIFx+bBCIVb9tlqkZdkvrf2qi5Tb9iX1yDmuDLnj42TNzeHXLTmfk9jW1BKuf20afBIiV+P6t5jchZfH8U4Xx+nv8N8SUARl6iuOPnuVnIXVjKG3y6rlRtXwF39yiPeu4VJPXlL/VNw1SImEeD8iAKn1XAfROJLHk2zRyVaIcSqj6eXJY9czGN9K6RZudmWExlTSVdde2uBvZMqis2TrKRAYIpQT3eODY2dZ9bt7ct96YP6J6A2ioq3wNd4Rj5a6T8dWFIFtaZzrmnpe2jB+ZmPYWbvX0nfAwpLt6S+gw67KA/5lqiVltwmG7qZC4DTFb/bjI6K1sntli2aPrqZ3LW2HzGURymLAyU34KpJfUxE5DAbdO8UigQQkeTEt8UHYb6o3imNDYlQtHJUF48vlHKkexaX7JDAaCAazySpxMa6GSTK/YqX20RfMqxqRT0WxeeDD1W0v4OdhBRBQpnGB8zI4bTM+8MlTfTeX3CZ0iw6A6c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199021)(66556008)(66476007)(66946007)(8676002)(8936002)(6916009)(4326008)(5660300002)(316002)(86362001)(44832011)(41300700001)(38100700002)(478600001)(2906002)(33716001)(82960400001)(6666004)(9686003)(6486002)(26005)(6512007)(6506007)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VvuTX7cR5BBZRjjMc5T0ee5rrdMqJ/9SXBtzXGJQvfkrmtdAYWBLz/5kwUzS?=
 =?us-ascii?Q?9ekJJZFe+YGx5UcPODEuAuejP6wrQ8the40DKWFye2B+AUC9zQ/zrIwcAbXQ?=
 =?us-ascii?Q?iGASe+HWkLIUCFjWqlcdUman7MNwThd9Bwdwc4yTem04UMhUM5IDgita29+O?=
 =?us-ascii?Q?uPcNs5ac0lcFRosnwyw0HSz1mUVzyKXRqfRHO3bS1FK1MthPsjMyRoIwof/8?=
 =?us-ascii?Q?cVCmdlOLlLMDeyqRHUZTGoSqTibKG241qdrFq8WMZ8GSKwbt4gZjI+g0EjW/?=
 =?us-ascii?Q?lO1JJBSy+iSL5QGpyxyYeGge8DxAqTV3Ik0KGjRrgV9AUawFVbnSd02+b8p4?=
 =?us-ascii?Q?GjRSo/paRGCZCiUa09Jn5Z3nZy1TyGmNifO57uLHUULvdW7N/VpyqXN/NTEQ?=
 =?us-ascii?Q?fClbvh1gQI9lRS6zJysRZmOr/LyHmdP4nH8re480XUm8pW6hpoA4jlMaZ8vi?=
 =?us-ascii?Q?hrPuyoZjWEMAwyUH7tBFMq0l9M3wvwJ8F2Obnn14D2dqqBsVpHDkzLyIu1rz?=
 =?us-ascii?Q?iB+SZqNZzVPYA7g/fMdhWpi2/3zKaeXfBJ8i8gVyfPRgPNLZ6OQ3GNy6dxgj?=
 =?us-ascii?Q?PLhCfURSFwiBymotZZbeWTF8YBlSKkkkh5gYRX/1bD4Lp/DPt5MYH8KQJPti?=
 =?us-ascii?Q?9uZ+wKcLfjF2N2SMsi7x8PU7U+h38TKd+HBK3Sdh2dNJpCMD8KQFgzFHqDEm?=
 =?us-ascii?Q?mvNH1P2oZzPlRUcrF3I2cxLU1ArN6WTWwPoTUFgH2DejzuHTCHNEAUvnhEe5?=
 =?us-ascii?Q?UMSGxcg8a2Hshc0kybgW1JDf/O90R+JZoMbBLNnb6CbjgDpGIK1uSA61WgyA?=
 =?us-ascii?Q?CX5VHtnRNDEfOcleArSLe7SPyRBhwZmRyDXRLLWFcPIXfpMIKBao1EvyIQH3?=
 =?us-ascii?Q?p8IhToXSS6p9DCilSaO5EYT8LkmSezUgTfm6nun0+7jDNRmZrxvv70M9YVWX?=
 =?us-ascii?Q?5NKHm1MQRQouSvZUy2y+6AqpAuElqVPj1EGA1Qv1Dh4norP60ZTlS0tP31lu?=
 =?us-ascii?Q?nGGzT9KIP9axXf5YphYNeM3brwezAA7qczh+rrN2hBR3bC8hUoBPKoxR3Yry?=
 =?us-ascii?Q?sjUVgB+YbJe5/XqVkTIxxRopRWteyulU1d7xfac+Yo0uZJmtA6NjGJivXh7A?=
 =?us-ascii?Q?V0yX0Nr+RrV3K17WxG/T52JtazsDtgkmMSdWa+/p5VxtCaBxq899073MH5nO?=
 =?us-ascii?Q?OjJ/y3NQMw7zBrrXBmphWDL2k5qlFBJkNxomZO1R+H2VGyYEDS4DBK014piB?=
 =?us-ascii?Q?zp/HGBqj/vm+LQJsDqsr/143spOG43JLmGnvkmXtuw5l6+8/4O8MVIR/n+45?=
 =?us-ascii?Q?nnvhsRWJh3+5wYJAT65HGPS2q/ZYbEuxHCsfBbfphAp7byqAB2llczsrVJXS?=
 =?us-ascii?Q?ITLOLmin0j2nclIfcuJCocqeO54+QEbsIg1tsTe87bxuVz8naM5uvWQ/qVyZ?=
 =?us-ascii?Q?bmKzkAHr06WzH+cSUsEWIRRCm4izgw132bozDyYT7BxL/ZUosAEMJPLErOv4?=
 =?us-ascii?Q?S8Q+98pc/uIKiStuSMXG5oEttymeR0Thg2vasBDNOjYtJFsYMarzkJS5vUrN?=
 =?us-ascii?Q?NY3SGwc6wIkKuLdeSimdIYL6g5JBGrzLWfg+UI4OOnT4SL+eMF91lEBEwicT?=
 =?us-ascii?Q?4giyxFlWBLrC+8fPRIjl99I=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0149bb1c-b4d0-409b-a0dd-08db66baa65a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 18:20:04.5676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wV0iMrTkaUN8DwlXT30+Nv0XCNaV6rW+i3+ngzUXXE6azpEQmrM14bbmefh+D10sfEa2Dnd49FLzz7idJi6cd35QyODdUNJk7H+2t9sd59I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7159
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 05:20:59PM +0800, Jiawen Wu wrote:
> Implement I2C, SFP, GPIO and PHYLINK to setup TXGBE link.
> 
> Because our I2C and PCS are based on Synopsys Designware IP-core, extend
> the i2c-designware and pcs-xpcs driver to realize our functions.

I have browsed through the series and I didn't spot issues that stand out
for a guy that is not an expert in these regions. Consider my:

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

not a big fan of devm_ usage though.

> 
> v11 -> v12:
> - split I2C designware patch (2/9) to I2C tree, repost remaining 8
>   patches
> 
> v10 -> v11:
> - add gc->label NULL check
> - rebase on merging of wangxun patches
> 
> v9 -> v10:
> - clear I2C device model flags
> - change the order of header files
> - use xpcs_create_mdiodev()
> - fix Kconfig warning
> 
> v8 -> v9:
> - rename swnode property for specific I2C platform device
> - add ".fast_io = true" for I2C regmap
> - use raw_spinlock_t for GPIO reg lock and adjust its position
> - remove redundant txgbe->mdiodev
> - keep reverse x-mass tree order
> - other minor style changes
> 
> v7 -> v8:
> - use macro defined I2C FIFO depth instead of magic number
> - fix return code of clock create failure
> - add spinlock for writing GPIO registers
> - implement triggering GPIO interrupts for both-edge type
> - remove the condition that enables interrupts
> - add mii bus check for PCS device
> - other minor style changes
> 
> v6 -> v7:
> - change swnode property of I2C platform to be boolean
> - use device_property_present() to match I2C device data
> 
> v5 -> v6:
> - fix to set error code if pointer of txgbe is NULL
> - change "if" to "switch" for *_i2c_dw_xfer_quirk()
> - rename property for I2C device flag
> - use regmap to access I2C mem region
> - use DEFINE_RES_IRQ()
> - use phylink_mii_c45_pcs_get_state() for DW_XPCS_10GBASER
> 
> v4 -> v5:
> - add clock register
> - delete i2c-dw.h with platform data
> - introduce property "i2c-dw-flags" to match device flags
> - get resource from platform info to do ioremap
> - rename quirk functions in i2c-designware-*.c
> - fix calling txgbe_phylink_init()
> 
> v3 -> v4:
> - modify I2C transfer to be generic implementation
> - avoid to read DW_IC_COMP_PARAM_1
> - remove redundant "if" statement
> - add specific labels to handle error in txgbe_init_phy(), and remove
>   "if" conditions in txgbe_remove_phy()
> 
> v2 -> v3:
> - delete own I2C bus master driver, support it in i2c-designware
> - delete own PCS functions, remove pma configuration and 1000BASE-X mode
> - add basic function for 10GBASE-R interface in pcs-xpcs
> - add helper to get txgbe pointer from netdev
> 
> v1 -> v2:
> - add comments to indicate GPIO lines
> - add I2C write operation support
> - modify GPIO direction functions
> - rename functions related to PHY interface
> - add condition on interface changing to re-config PCS
> - add to set advertise and fix to get status for 1000BASE-X mode
> - other redundant codes remove
> 
> Jiawen Wu (8):
>   net: txgbe: Add software nodes to support phylink
>   net: txgbe: Register fixed rate clock
>   net: txgbe: Register I2C platform device
>   net: txgbe: Add SFP module identify
>   net: txgbe: Support GPIO to SFP socket
>   net: pcs: Add 10GBASE-R mode for Synopsys Designware XPCS
>   net: txgbe: Implement phylink pcs
>   net: txgbe: Support phylink MAC layer
> 
>  drivers/net/ethernet/wangxun/Kconfig          |  10 +
>  drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   3 +-
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  |   4 +
>  drivers/net/ethernet/wangxun/txgbe/Makefile   |   1 +
>  .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  28 +
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  65 +-
>  .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 673 ++++++++++++++++++
>  .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |  10 +
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  89 +++
>  drivers/net/pcs/pcs-xpcs.c                    |  30 +
>  include/linux/pcs/pcs-xpcs.h                  |   1 +
>  11 files changed, 881 insertions(+), 33 deletions(-)
>  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
>  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
> 
> -- 
> 2.27.0
> 
> 

