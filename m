Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8083D5B9C75
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 15:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiION54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 09:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiION5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 09:57:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EECB99B71
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 06:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663250274; x=1694786274;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qb78bsMj4k6tCkCL9PqSCYTkOEKcpLpFAYBSAifg4KU=;
  b=aXSuzzwZp+PrXr8FeSZpRnYP71UR9C7EcUkvdbwVymE5AR7H1Arhh5Hb
   ScDfhHJzZ3itfkBQ5vE35zbC26TtQIJnUbwUTs6s997GtAT4p4QBpbKQK
   Cs6YTeg6WVYvOK1M66Ml7+1qUSV7pb8mmkIZExhA0Cs2zL47qA1+vX+iv
   Bb2MDRSJ5tzUcmFhc3bOaGA6xkaxYxxnQV2eGowt5cxB7gurjMRN6jaQl
   weH8KKqEGjpBrfTgq7vpMITJtpwizTYsAZA362lZMTmQoPx2lPT73cnk7
   8mtDfhb4zgNgngr5uCy/uy5Y/SzWi9h0eXC+S6+Zh5baS3CXV7v4LHCU3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="281747773"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="281747773"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:57:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="945961275"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 15 Sep 2022 06:57:44 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 06:57:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 15 Sep 2022 06:57:43 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 15 Sep 2022 06:57:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3BqEAewrDNWwwkrYWL53ScVVGUsEM41NAcELs37ubmYa/Kq5MXtIxJvHGJR4qBcALG9DS0YLD/vDcr4BNp27SWD7kfZcQMf6fRgJ72SOF2BLK8ESC0RyVVQ8IAK1BznG0xFvzWyRdOqVlubKyFh0IgbJvYuS53x/tETepiWhok903ukyPcYUBH9jWKNGykz3gMXivY/+pHhnOc2t9dWwHpaAjLILkDf0YdJ677ypw+BctsB4dJF/V9KWzsia7pp1IcdaVDNqVlAGbNX8YBtq5c25C6YA4qFjyeMvpU6XYHT1AIZOEomqjG3TtveGsCP2HgRfmLN1Br2Eptt5glNaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43h5lPgMuNr6sjGYISjpDZwpUUwV57OInmGqiTs5eow=;
 b=BmUGQY+nLwHelmxeR/93d61PhWwc1OJtkSeaonBF5BzO8XPYXJrSkyQ+bHMn4HnY7lw8t16Xgvp30p9Appkj1mFFvz/ajnJ7yRu92eHc/w+GuEfFjW1hvGICQeBlA/Qcef68wH9K2ev2vrjJlh9ZWkyPHyxljDHNHLjtDwESk4zYlgR49Qiymo3jnpQAKhsa/y2f3sqFyGYO2qPP8zONjHEjNMl3no9xSVhwDsB/fbtulXbrOQGpoW7tSKOqiMvKGLoj9p+e1ffowJrq77TJuE7+G0vNLnIh5FyL3Fmb9sr/5yyoJPVsm21n+FLvt/YHRICrGHqWZBQLTezJXVG7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by BN9PR11MB5308.namprd11.prod.outlook.com (2603:10b6:408:119::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 13:57:41 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9%6]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 13:57:41 +0000
Message-ID: <32b1423d-abe3-393e-2044-3169bbf2a52c@intel.com>
Date:   Thu, 15 Sep 2022 15:57:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH net-next v4 0/6] Implement devlink-rate API and extend
 it
Content-Language: en-US
To:     <netdev@vger.kernel.org>
CC:     <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20220915134239.1935604-1-michal.wilczynski@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0157.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::13) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|BN9PR11MB5308:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f90650d-8fdf-48dd-92e3-08da972241ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DTR5qcBAQE4otixApK8YayOZyc8LFpcBYsYB6GkpwY43fPH4+nDs5c0vC3iQYW4//gp9uDxI0tZKtjr7CsvUiefsv5zO9IVKhlR3P72aq8H/NWVVOsxuZHz75IEluAQLiQLK5TqlI6V99N/O2mAe9IjwWEj41gQhfg57GzpqzJlKKekwDdyIPsM8mNA3dwPE/VqMPHmc8U5Zr/vtAdq9qquaXZi25JhD3thEq63cHfryGwtcdbDO4rRwzO8KWmPiw0kwm7qkPE694CFka1829t7UJZKXirI38pNg7aqiDi7Mqja2yshGM8UKz1bRTtMMLdXwvHzvl+N2KjNaCNuDxsXxOt8jtdLGl9KA8CEKk5VtBziWs0+IgvkhSem00RxbdDHtXeHwjCEJyUvJ+31+qnHo2Q95bj8WgsLBZs21lKYHXPLQiEfXhjK3A+4sVFY5ybejfmLzRLKDdpHUcaJzunl8qbUXK5zlgFLaS6baD3ZayhsXZBTt/kbaHDeL9gudVWkMwaLDa8FKLJ8Ck1921v5RU/HO3dL6T3Qc5tKufBVGOLOSJP5wNsnkxkB1uDtkgEcivhee2oXCaLjpAtLu/j5tGRFNPTp1JwUi/bPpxkJ2B3QT3PIAsPyKwNLkZpP1L5X6YIBkNIPiEifURPXlLfvKce8ghGk6xIdyEthyHbMqDgOctQvPNS+8r0chORz/K1/f6oaJcuTP7nQOepiKIdqG/SbKEaapAPI20FYqApX/cVSsRtj53Sc3OH7jQRjw8HzhYAIkVCyLoKHK/Ab3oklkE+CDVwGdTpeR2fHrgvetMpzogfZ34D2q/fZsCvKS4FySLUm9I+w73bhkH5x1ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199015)(31686004)(38100700002)(26005)(2906002)(82960400001)(36756003)(2616005)(5660300002)(83380400001)(6486002)(8936002)(186003)(41300700001)(66476007)(66946007)(4326008)(6512007)(53546011)(6506007)(6666004)(107886003)(8676002)(966005)(31696002)(86362001)(478600001)(316002)(6916009)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHZnQ2hTay96RFgrc3VpR1lYR2lZU3BLZGNQK3B4SVZSQlErMFdDTjF3UE9k?=
 =?utf-8?B?NkJkOXhHYjZPUGNHZllzYVh2cFdCS3VCNEJ2UnRseEpTZlViN2NIcUJFa1ov?=
 =?utf-8?B?dGE1ZVZOVmtTOGt2bkxETmtiQllIUkNpUCsrSEdqNzNGRW5FbDdZSDNLOWlz?=
 =?utf-8?B?YWNrTVFzeEdwZUJIYmhGVTRTSi8yeWlyQ1NwS3JhMytCTE5rUFo5dkU5SnRX?=
 =?utf-8?B?dG8vclhGd0FuYTB6WkcrQ3BvWjFMajcybVdWMEFFb1paWGZ0dGh3NThsZloz?=
 =?utf-8?B?OE15Tm10NDI5MVI3Tlc3aW9HMmhxRHBibVBIK3M1VmRBRThKQytGc3dUQ1NG?=
 =?utf-8?B?dnk4S2pnczN2MDM2NnB0YnE1bUR5TGdNV1RrcHRHQW95TmI5cnZUcGRiajND?=
 =?utf-8?B?anZnaVdMVjE4bXBKellFR0ZRa0h6elFMNWc1MG42ZVNjaU1DOEZuYzJmWDhj?=
 =?utf-8?B?WE1JbWQ2bXpyTFlpUHVsN2UyeGFUWC9vbXJZSWIwRWcxOFdJSzZXN0R2Ujdv?=
 =?utf-8?B?cElYUG9va0syZHpZTlBOQ3k4T3dKeFUra2dianFobnVWVE9sdGJrWXh4ZTIv?=
 =?utf-8?B?aGorb3NmY1RGdzcyVGd2ZGUveWIxQXhNdjY3UHZIMmhRbjkvbVJtNllFWnN1?=
 =?utf-8?B?VzB2RWt6SlFiUE1ISFNGaW00UE1TekNEN3FBRmR1b1lrZnVhUGMvbmIwTk0r?=
 =?utf-8?B?Y0FMMjNSbDZxT2duRTJydE1JNVluZmcwSXNWUk1neDhNMGl1cDFsL2lzenJS?=
 =?utf-8?B?Y1VWeVpKdnJTRVY2QmE5L2JkSXVNZ01GUlBCSGtNRm5pcDZMNzNNdmJKaXhN?=
 =?utf-8?B?Uk92aEhsNndvNlZjMzREZDAxN0EwZnZDbml6Nnh2dnhLbzM1ekprdlVqN2c4?=
 =?utf-8?B?cDFHNXMyLzZIQU5KMWx4U05qaG5GenFuMmRHSklRdVQ0NUt2RFQvQm9aL3RR?=
 =?utf-8?B?L1RzZEY1V3owWXIzSUI2Q0JweGp6UTY1dFp0NUQ0MVQ2SDRBZnpvRXJMQTNw?=
 =?utf-8?B?dWdNQzJjNWwxTHE0QTY3UlhxMkdmZVo3cDhzTjRuc3ZJS0Z3MnFPbHhhcUk4?=
 =?utf-8?B?eHJOcCtMNTZjdkFhUThUNVNweW1pZ3BCZnh0aDJiajVvLzROTDBDZERkRmZq?=
 =?utf-8?B?ZWs2TExsdkNCbGM5R0Y0Y1FsL1hyR0FxMENRREp4d1pEVXJOcTU0UXdEcXJa?=
 =?utf-8?B?dUJqNFVpQXRnQTU5UG11Y1BKSUxwL3hyaXpPOUFWU1dnb09kRVp5RlJrSHcr?=
 =?utf-8?B?SjdYNmJ1K1pWVUNJNW1PTWFkN2lCRjdCK01pWTFUc3VYVEZBQmlYNUthRlpZ?=
 =?utf-8?B?UDRhMW5udEc3Wm83dDFsc2tiYkQ5OWMvMVRIK3VKMHhZSFRNd2VVZEErVXBY?=
 =?utf-8?B?TlNidzNrbmFzQmtCUFg5ZVNsQzBhVXIyMGk0OEVPKzZGek1aZnRPWmFDVk9Y?=
 =?utf-8?B?cG1HNkFpeXdaVW9CZEF4VTBxRE9vTkFJZDcySlpWc2k2bmM0OGRQSVVYR2x5?=
 =?utf-8?B?TUxLWEN5bzg2UmdsczdIdUxKWXhxYmRlUUpQZUxNU2R4QVU3VWlnOUtCSDlQ?=
 =?utf-8?B?UW0rWTVadnJSa244Q2ZLWEdoenZhR1RwbENuQjNHdmJhUTJSRXkxYkUvZk9O?=
 =?utf-8?B?eGp2d0EzV1NxUnpHRDhnUGJkck5ZemtVRkV6aEZ3Q2NBM0JjZzhuVWwyVHpj?=
 =?utf-8?B?d29XRE53MXMvcUNaTzVYcGt5RjMybTBVSElVVVFmVlZEYUkzcHJ6TERLM2Vh?=
 =?utf-8?B?Y0puSWM5Y21IdmoyQlB0bGo1bko1bWlRenRndUU3eTVWREtBbnNZYUNIblRH?=
 =?utf-8?B?a0NmaERKQ0FkWks0K1hMYjQ1cjNMZ0Frck5ZK05OREl5N2dwdW5qMWwvWUdX?=
 =?utf-8?B?TFFscXQxV0Z2Z0xpMThBdHFTVytxOU1rOUV3dWRCSGw3ekxNaHVJalJpREN4?=
 =?utf-8?B?NjdiYW9XNndsU0VnZ2lmeEtjM3p0NUwrZWtLRU55cVZjbEdoWU1CRXk0NUpt?=
 =?utf-8?B?NW5zdU1GaVloR0FBTDNoUWN1eGI4VFd5WktiWk04bXU0cUtRSE1oemFicHZu?=
 =?utf-8?B?U3kvV3l6U3k1MUo1R3BHVldzaWtMdlNQRXJDWllIcWdmay8vTnZTaEsxbEpk?=
 =?utf-8?B?M0lkVTREemZYb3pvSUxSK3NIUkY2OVppYU9oaWJPVWFNQ0lIRFRBY1dndVhZ?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f90650d-8fdf-48dd-92e3-08da972241ab
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 13:57:41.5291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzTkY0ZnWSBvWNEEn8WYhGWVKB5/QUF0f1inVuhAk3veA1qWZZx7irX237OAyWs3TMpfmhRhfx04EO3SDjJqCh7JNaHXoUyin6+VknqKFcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5308
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/2022 3:42 PM, Michal Wilczynski wrote:
> This patch series implements devlink-rate for ice driver. Unfortunately
> current API isn't flexible enough for our use case, so there is a need to
> extend it. New object type 'queue' is being introduced, and more functions
> has been changed to non-static, to enable the driver to export current
> Tx scheduling configuration.
>
> This patch series is a follow up for this thread:
> https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/T/#u
>
> V4:
> - changed static variable counter to per port IDA to
>    uniquely identify nodes
>
> V3:
> - removed shift macros, since FIELD_PREP is used
> - added static_assert for struct
> - removed unnecessary functions
> - used tab instead of space in define
>
> V2:
> - fixed Alexandr comments
> - refactored code to fix checkpatch issues
> - added mutual exclusion for RDMA, DCB

I realized now that I haven't removed versioning from internal review,
please ignore this.
BR,
Michał

>
>
> Ben Shelton (1):
>    ice: Add function for move/reconfigure TxQ AQ command
>
> Michal Wilczynski (5):
>    devlink: Extend devlink-rate api with queues and new parameters
>    ice: Introduce new parameters in ice_sched_node
>    ice: Implement devlink-rate API
>    ice: Export Tx scheduler configuration to devlink-rate
>    ice: Prevent ADQ, DCB and RDMA coexistence with Custom Tx scheduler
>
>   .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  41 +-
>   drivers/net/ethernet/intel/ice/ice_common.c   |  75 ++-
>   drivers/net/ethernet/intel/ice/ice_common.h   |   8 +
>   drivers/net/ethernet/intel/ice/ice_dcb.c      |   2 +-
>   drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   4 +
>   drivers/net/ethernet/intel/ice/ice_devlink.c  | 598 ++++++++++++++++++
>   drivers/net/ethernet/intel/ice/ice_devlink.h  |   2 +
>   drivers/net/ethernet/intel/ice/ice_idc.c      |   5 +
>   drivers/net/ethernet/intel/ice/ice_main.c     |   2 +
>   drivers/net/ethernet/intel/ice/ice_sched.c    |  81 ++-
>   drivers/net/ethernet/intel/ice/ice_sched.h    |  27 +-
>   drivers/net/ethernet/intel/ice/ice_type.h     |   7 +
>   drivers/net/ethernet/intel/ice/ice_virtchnl.c |  10 +
>   .../net/ethernet/mellanox/mlx5/core/devlink.c |   6 +-
>   .../mellanox/mlx5/core/esw/devlink_port.c     |   8 +-
>   .../net/ethernet/mellanox/mlx5/core/esw/qos.c |  12 +-
>   .../net/ethernet/mellanox/mlx5/core/esw/qos.h |  10 +-
>   drivers/net/netdevsim/dev.c                   |  32 +-
>   include/net/devlink.h                         |  56 +-
>   include/uapi/linux/devlink.h                  |   8 +-
>   net/core/devlink.c                            | 407 ++++++++++--
>   21 files changed, 1284 insertions(+), 117 deletions(-)
>

