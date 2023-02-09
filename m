Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB5468FD48
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbjBICqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjBICpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:45:41 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4513136FFC;
        Wed,  8 Feb 2023 18:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675910574; x=1707446574;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EsGt0jX4Wk+EbgD3pyezXQBcnlsh8tm2nP6wpGFCRg0=;
  b=ku8EoMP1wT7Ul1ui7YXt9JvCKPEhPdwZ1Owe5kCyeVzKgK2avbjjYnvY
   hsOym0zqZ4E4Gre6bLwWnkPmCZX9PqhHQuz3eOSjUKs9AFV9CZxsnnTHs
   F0m878NwOTLe7HkGGBBaPye00Faa9I7XLuDNsfRzGfJCvliqwxQE5bPqq
   t4GmqeoOH5GX1hQDeOdiugOSMiIx4LGr6rmHBEBuJxgwPRTQZF1uA8aMV
   4ZRNpVPQ/NAbCw/iRVs46BBjmTzDWv7g0Eh/PQ69OkltYmgEPb9SYOS8b
   wz44MskzoobLfg6Yw5zbhTONRm1cobCZbWHbIvDEMEn7Q+3a1DGiTwgF/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="309642603"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="309642603"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 18:42:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="667475862"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="667475862"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 08 Feb 2023 18:42:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 18:42:17 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 18:42:17 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 18:42:17 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 18:42:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7huqkXt8bJJgoJnrHhdoDLt8QAWNzBcWEBkUlhoRZnl6uMAiVc6Gzh3yr13SB1aduQQo6rS46goHZ79kw6GaI8faQ7Lq8cOh280OvKDvWMfp3778j791j63pXq7WqCxeICjsN4oFQvI3JOf8+6WtLX5570jc+sOKgdR0ts+4GmnTPb3pEH0BZADx5uTUfuJXZu0AlMsIWDjS+0DAJ6oApbXtwTAyJXDjdgPtaO37vQ18xWQbA9GFkdqDmPhowvuiS5KlGy2ZI082WdFqlSl/gi8TCRX4ftzG4wx530nOS2Pek1sMGgYLY+vaANBszjirZ7r6ad4KNwrjMYVTR3X6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zum2Je+Od/5ByIuitnKK4TeY6mNZ6Ba0Sc55avvQ5eo=;
 b=l/TXrHEk3SmtYDBOVMR7KRN6Nr+C/F1r2KSLjXKS06LK+32XOE9YTE/RDLcmh+E24jWDvomRQmnC9lb4DvgBMbWubsW0kUkl+StYGval9SnshcTo3Go5+n1mTSlgaYUd2G4pAiiTCc55uFtTsfFCaV4rSy3F93QUoOZ+pB0e7HAJN80iSlfxDSXYjgjOAZGCOkQ7JCdxTkxMoLG4VcWL0G8nCgn3j4S2g9h2+4a/RI48/xUqFXsD4RFRIOXLpcunxQeG0FywoFEGTYmKI5Udb4MFH/EcOrKq5tNlCIHQ24qVu1nGjmPImbwBLmGetAN8DTCL15zPVoJg04PD65mmJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
 by CH3PR11MB7841.namprd11.prod.outlook.com (2603:10b6:610:121::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Thu, 9 Feb
 2023 02:42:03 +0000
Received: from BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::66b1:16ec:b971:890c]) by BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::66b1:16ec:b971:890c%4]) with mapi id 15.20.6064.034; Thu, 9 Feb 2023
 02:42:03 +0000
Date:   Thu, 9 Feb 2023 10:41:33 +0800
From:   Philip Li <philip.li@intel.com>
To:     kernel test robot <lkp@intel.com>
CC:     Pawel Chmielewski <pawel.chmielewski@intel.com>,
        <yury.norov@gmail.com>, <oe-kbuild-all@lists.linux.dev>,
        <Jonathan.Cameron@huawei.com>, <andriy.shevchenko@linux.intel.com>,
        <baohua@kernel.org>, <bristot@redhat.com>, <bsegall@google.com>,
        <davem@davemloft.net>, <dietmar.eggemann@arm.com>,
        <gal@nvidia.com>, <gregkh@linuxfoundation.org>,
        <hca@linux.ibm.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <jgg@nvidia.com>,
        <juri.lelli@redhat.com>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux@rasmusvillemoes.dk>,
        <mgorman@suse.de>, <mingo@redhat.com>, <netdev@vger.kernel.org>,
        <peter@n8pjl.ca>, <rostedt@goodmis.org>, <saeedm@nvidia.com>,
        <tariqt@nvidia.com>, <tony.luck@intel.com>
Subject: Re: [PATCH 1/1] ice: Change assigning method of the CPU affinity
 masks
Message-ID: <Y+RdXYlTKydr3L4I@rli9-mobl>
References: <20230208153905.109912-1-pawel.chmielewski@intel.com>
 <202302090307.GQOJ4jik-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <202302090307.GQOJ4jik-lkp@intel.com>
X-ClientProxiedBy: SG2PR04CA0174.apcprd04.prod.outlook.com (2603:1096:4::36)
 To BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB2995:EE_|CH3PR11MB7841:EE_
X-MS-Office365-Filtering-Correlation-Id: aa7553bb-a9f1-495c-8878-08db0a47396c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: upmY1wdqvZt4EYrPKQiijVoEvYyPVVQAlezM4Spr9jMxi0Ze1Ig+NEI5BKJVNL7K9eVfeL3gsgQrv+FgUoJeaYAqv3h+1R6P9gbW8URfNEKYtRpqez5RFPHR8cbdNbtTu1EohzWq4LKNT+JfCLvPW/pLkB4DpzhkBLW4NYS3x9AfBOLnpyK2xm8yHsn+UnHE11gkfS2VmJjoy9wZw7+pQ6RluKAs1FvpmJpel27Qqj1JykV4vgTxQJy7GXQBIsO14IQRXdznE3qCrTBQ80UAnymFZ6MOPq1EwcZTQZG8ZCXTPvuX4pmXdJX4CFIeY1+NH4erilvQozTpVji6NxIpx8n6A2aNT2NqmsWrN23BAd/yIiKGg5P9hiXaIvzWEAtwHaT+hKgU7o+kN5Ed28l4+yT7BOJSrge+1S0u/lUi/dNkkFLxR4Ivrv1kcpLOGfjPnDzRuTfhlT2jXmDf7NXGEEpy6contT1lCuX+LKVGYlyQWJIjYTEz4cbFKsem67x/3/Cu8lSdZO2Y0A/BnnzUiHsH1gn657tJy43fblKVaYabdqftM66Lpfxd7kotIW2Z2W0/GviN+tklVjasqizcDiuKkeRb529hTeSiBtXrFpXwTgMdz2BZOKom3+1j1zSHk/v27Hn7ozjzAFCkhiYNANnA1GaCKmCpCneAkHPNTtEtx0QxeXMN65Eo5C01VdNPCJ6GjJ+rHoVpfMJqS6WU5kfaPnOw1AGSuiujcv1P9JhpRdU88lMEpnmUW9ovlc0qgAPxpbPwHA1BYxgTMCmZmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199018)(6506007)(966005)(9686003)(478600001)(6486002)(186003)(6512007)(26005)(6666004)(6636002)(316002)(83380400001)(66476007)(66946007)(66556008)(82960400001)(38100700002)(8676002)(4326008)(2906002)(8936002)(41300700001)(44832011)(86362001)(7416002)(5660300002)(33716001)(6862004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rbdlx1izitRJLUh+reEIaL9YaxPhQ9M2Rp9OmSjEW97YmgOWdrq9Po4OdaqT?=
 =?us-ascii?Q?AkYn4UYKpF71GbybDtE8DBEQ9yQ6RfgH8RsQfcWqfgNrITp0kUDYiJszzFH5?=
 =?us-ascii?Q?RSKDTrcqo21+T2kS7qYMjUL694UYU64It34NFGTdveKgYL+2bC5eIG2+Ebdt?=
 =?us-ascii?Q?gdZIT1dd9SWzSa7/nJVhE/73NQFZkkbmUmqLsEGuWk7n24qT1azfTrigHpMZ?=
 =?us-ascii?Q?OuJGvTHoQS7IciOOW6pYnGqt9zG6A64SxxGiv8TOXSvxpN2rjmlB364dlyy7?=
 =?us-ascii?Q?4b/sEPTc2JWfuCbQ9ERYMv48XlnAUkWYNZE24ze+SGuf2+VWxp5Bu3jWxDc7?=
 =?us-ascii?Q?BxiVHK0yYP5DNCyb/DPvaAl68Bs69PHcpS6abxWIUEquiYZLEC7mFAdTOqTO?=
 =?us-ascii?Q?iGT9MDvXLp0KqLrqhesH5xNk5OQHmRBy7XAU5BqPPshODjW/+cTqKwc02Fx+?=
 =?us-ascii?Q?CzTeGAUPpRoxQb+/Zvz7XApr147q7jppnYbJR79uCXkWa10yLJFzXEsT6vK0?=
 =?us-ascii?Q?qhWA5xrhdxemtSoj3GqgVUL2M4iQzs3Kjkl0vYVGFZNZ795EcZ8uFxeNgCU1?=
 =?us-ascii?Q?JUAr3GEYtwWp1nUIlxiZpMemcFwQchtZLuOYsc7l4XW/KdoVntnejf54rcPz?=
 =?us-ascii?Q?JL9FMJ3PKuDzswu5uasWzFJkn7U2WI4l7nz2nRGc0G4nxtQc6GBFtL/Ha4WJ?=
 =?us-ascii?Q?wtWGVj1x9oWl0uTaWh5NTZ9fBDwZfTk6PhxjiWiRJOmDRf+mguOqvJ9j4cDs?=
 =?us-ascii?Q?60Gckxsf0sLnN5ILUmMrNolGYxy79hBSUos3OocnvhGzi7n++3+Y8s4lw3nl?=
 =?us-ascii?Q?zNxhiTDaI6tC4ZuEWseDBubI4OWFF0TQxct4jU9Iys/XdFVRYRFiEZ7JbrXe?=
 =?us-ascii?Q?r437e+wz0PCla4Dd5z3+AXDwaDJrugXIthFBxfxczoCq72T6faSXLEYrKzpG?=
 =?us-ascii?Q?YKsSZLxIO4lR1OZP1sUYUEdAQ7YCqi+4s5Y8phIRFJlGIYbJAZdcdj1yMfQ8?=
 =?us-ascii?Q?90+fCdOKMSvU816w2sn2Wv+K1ZT+dS8UYzsySL8MWTyHeLYM2g1jCuGp59II?=
 =?us-ascii?Q?QdOqDysF39vpDMGi5nZ5Hqy+pzU8FUVqhcj2E9PuvextTgCVb79aepmQiZ7w?=
 =?us-ascii?Q?ycqBZ6chC1hbgHPcl7ukVOb9HlSXwKyqJ1Gn8lfiElHiPrhwKWy4ajP4hKGz?=
 =?us-ascii?Q?8fh219MrCp1zZzxd7yoBquRPmvLXO0tSxjy6mASfVd99h7X6i8/TFWotEEJQ?=
 =?us-ascii?Q?mVO0qtFmRfk27iHKBju5eV6h9QeCpduXXWWRfGiqckGZ0IxWtkQ+/bKH9Nm4?=
 =?us-ascii?Q?7mIRx8nZRNjZkJKx3ajhqfsC2A38+7NFu3Jf9hOlNUKjHT/FMJ9b5GBZWtcg?=
 =?us-ascii?Q?/qb+txsd59x4AwbMdnAoOb90F+kVRJ7TWe0ZqY/FowUfmhSDU+1dY0ZQOpp2?=
 =?us-ascii?Q?j8cE46Uuk+Ul2yl+m0PJ+n9g83+xladb46aKmm5NCljxdPaXKHwiLE5LAO07?=
 =?us-ascii?Q?iHUYmCOf4wSnIw0uGz/XlZ3TUfbkH8TvDCCclm01rSdjRStPDcXvT1/T2VbF?=
 =?us-ascii?Q?jZ2TjO2AVu8Zgs2fSWbOXu3fmriIGnCheDIt0JYaYIUYmGCgkK+adAic4E7e?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa7553bb-a9f1-495c-8878-08db0a47396c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 02:42:03.0270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lx/SknOy65a3Hlnp2mWCI0M7v2TpfcePyLHVzi+kNhYsdTiTK7kllrCWjGLDFMaqP2hfD/f/miSBc2bnratpzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7841
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 03:11:55AM +0800, kernel test robot wrote:
> Hi Pawel,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on tnguy-next-queue/dev-queue]
> [also build test WARNING on linus/master v6.2-rc7]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Pawel-Chmielewski/ice-Change-assigning-method-of-the-CPU-affinity-masks/20230208-234144
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git dev-queue
> patch link:    https://lore.kernel.org/r/20230208153905.109912-1-pawel.chmielewski%40intel.com
> patch subject: [PATCH 1/1] ice: Change assigning method of the CPU affinity masks
> config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230209/202302090307.GQOJ4jik-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/33971c3245ae75900dbc4cc9aa2b76ff9cdb534c
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Pawel-Chmielewski/ice-Change-assigning-method-of-the-CPU-affinity-masks/20230208-234144
>         git checkout 33971c3245ae75900dbc4cc9aa2b76ff9cdb534c
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=x86_64 olddefconfig
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/20230208153905.109912-1-pawel.chmielewski@intel.com

Sorry that the link is wrong, which should be

	Link: https://lore.kernel.org/oe-kbuild-all/202302090307.GQOJ4jik-lkp@intel.com/

> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/net/ethernet/intel/ice/ice_base.c: In function 'ice_vsi_alloc_q_vectors':
>    drivers/net/ethernet/intel/ice/ice_base.c:678:9: error: implicit declaration of function 'for_each_numa_hop_mask'; did you mean 'for_each_node_mask'? [-Werror=implicit-function-declaration]
>      678 |         for_each_numa_hop_mask(aff_mask, numa_node) {
>          |         ^~~~~~~~~~~~~~~~~~~~~~
>          |         for_each_node_mask
>    drivers/net/ethernet/intel/ice/ice_base.c:678:52: error: expected ';' before '{' token
>      678 |         for_each_numa_hop_mask(aff_mask, numa_node) {
>          |                                                    ^~
>          |                                                    ;
> >> drivers/net/ethernet/intel/ice/ice_base.c:663:20: warning: unused variable 'cpu' [-Wunused-variable]
>      663 |         u16 v_idx, cpu = 0;
>          |                    ^~~
> >> drivers/net/ethernet/intel/ice/ice_base.c:660:31: warning: unused variable 'last_aff_mask' [-Wunused-variable]
>      660 |         cpumask_t *aff_mask, *last_aff_mask = cpu_none_mask;
>          |                               ^~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> 
> 
> vim +/cpu +663 drivers/net/ethernet/intel/ice/ice_base.c
> 
>    650	
>    651	/**
>    652	 * ice_vsi_alloc_q_vectors - Allocate memory for interrupt vectors
>    653	 * @vsi: the VSI being configured
>    654	 *
>    655	 * We allocate one q_vector per queue interrupt. If allocation fails we
>    656	 * return -ENOMEM.
>    657	 */
>    658	int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
>    659	{
>  > 660		cpumask_t *aff_mask, *last_aff_mask = cpu_none_mask;
>    661		struct device *dev = ice_pf_to_dev(vsi->back);
>    662		int numa_node = dev->numa_node;
>  > 663		u16 v_idx, cpu = 0;
>    664		int err;
>    665	
>    666		if (vsi->q_vectors[0]) {
>    667			dev_dbg(dev, "VSI %d has existing q_vectors\n", vsi->vsi_num);
>    668			return -EEXIST;
>    669		}
>    670	
>    671		for (v_idx = 0; v_idx < vsi->num_q_vectors; v_idx++) {
>    672			err = ice_vsi_alloc_q_vector(vsi, v_idx);
>    673			if (err)
>    674				goto err_out;
>    675		}
>    676	
>    677		v_idx = 0;
>  > 678		for_each_numa_hop_mask(aff_mask, numa_node) {
>    679			for_each_cpu_andnot(cpu, aff_mask, last_aff_mask)
>    680				if (v_idx < vsi->num_q_vectors) {
>    681					if (cpu_online(cpu))
>    682						cpumask_set_cpu(cpu, &vsi->q_vectors[v_idx]->affinity_mask);
>    683					v_idx++;
>    684				}
>    685			last_aff_mask = aff_mask;
>    686		}
>    687	
>    688		return 0;
>    689	
>    690	err_out:
>    691		while (v_idx--)
>    692			ice_free_q_vector(vsi, v_idx);
>    693	
>    694		dev_err(dev, "Failed to allocate %d q_vector for VSI %d, ret=%d\n",
>    695			vsi->num_q_vectors, vsi->vsi_num, err);
>    696		vsi->num_q_vectors = 0;
>    697		return err;
>    698	}
>    699	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests
> 
