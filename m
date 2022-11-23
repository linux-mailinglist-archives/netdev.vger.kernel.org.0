Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580E7636B9D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbiKWUwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbiKWUwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:52:01 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4D68E0A2
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669236705; x=1700772705;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YQ0+mgZQD3jWWsdBe/3sxzfhkr/xCH2jgpH7vCtx21A=;
  b=RkZF9u+IN2NcDyVMREaE2KxdbYVpHCLJi2uYVsW0zVcJeed+8jPZjq8p
   dHODObkf+c8BQB4wYpAkW+cyN4tamJVtG+U2IyghPZNzM7dWS4NvzPe+T
   ZQSvGMk+retNHFigXrVjem6hJ03e0InpI0VRO5+aqD320uLfLYng4ciJS
   lPELiiGSwg7ildwzSgNlnjDHJJdtXF92OK8bAdmUu09Kdrsnk0e33r9b7
   MI32IAESgRmalmhnVP6KXTsVJhd5lcCo5hT8TwYzLYk1Hr0KQnPtCvYDM
   K7wUTHwzfBeP2Q1+JplI+FmXi2BUUKxStN8pHwg4rwfLqWE5HRjbZbDFN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="314191841"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="314191841"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:51:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="971000487"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="971000487"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 23 Nov 2022 12:51:45 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 12:51:44 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 12:51:44 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 12:51:44 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 12:51:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=niWUHy6tfv37Nk92Px4Ck54QutPKW+x5e6E1GywAg4QNi+4k/j7wHCTggvV+j0QN5XnMp7O02bf/SQLvVTZXdfrJUC/xOTc4NiHQT13XdeyZsv6GNEROW42xluNKKYRGlgzit0BdseQRoR03zyzEKldrR1BO9d79Unk1cJwKJU6HirFihiTwSoko3KM5MUrrXXgnBFWI9L9dyyHHjSbkf0YEoyWlz1twIFexdnwdsa8XLCKhpCuW2jGkz6ZZhtLaY/f4k3RNWvYj7W6ddxFYtsfdRwvui522BFzaCcMtUvs1O5Hu4VErntS7Ex9Cwv3Or5aG3t90IgTP6gLSnudP3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPpbwZX/hq1be7T1STdkMPE/F4D94xvHvNKNYiQ9SqY=;
 b=GsRy6rVQEhFzeP65vZRUMd87Qojl4JOiDSu4R/sraejzE/gfYwbOLkSyuEi4RtpGQExvggjOUdehCNjyKhMD9THqaCuKA5r12FeRj563S91OeOctX3tFRyA1b9si2H+WL1zkJEdBDrlIPvqKjiP+wLNiGklM75jKA8UUWeOdYb48OMXbvNk14TzuL7MedCam59l4eyzRyXAcqIiLthAmMsf4XNphcr4ifUrt9N6EePkhFeUBuIoD+P9h3gnhRrL78kFZr2xSM6GcI7E1z8JsJaWQ6i/wOvmXQA8tjotIyaqrHsDRcd5YFp4TZeBupN7TUg6aHQXZ42qx//IuY4vpvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY8PR11MB6866.namprd11.prod.outlook.com (2603:10b6:930:5e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Wed, 23 Nov
 2022 20:51:42 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 20:51:42 +0000
Message-ID: <68042dc7-0025-48bc-07e9-7051494ba2e5@intel.com>
Date:   Wed, 23 Nov 2022 12:51:39 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 0/8] devlink: support direct read from region
Content-Language: en-US
To:     <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221117220803.2773887-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::15) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY8PR11MB6866:EE_
X-MS-Office365-Filtering-Correlation-Id: c1c2e959-ead9-482a-fde7-08dacd9485dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AKPF/0otzDkMT96t7GOFkQnDYMYoiC8CnmqKyZFNYL4jiMk04xul0h0jp0u1Hh+HjU1I11ntwK9z8BD71WWKk5m31ZGIrioSRjIFIQj5C8V7vlpy0axqlvr3J/ZrEknezQl1p9rowrQvA0h80o5g+SfHGBHRqzP3q1OLyKEBGIJT8sCZaMxET7oGwn6c9L4c+uejarBJji1KMXUsk+xnl4man5lbKg5UhUcKBLZ8w/BTNDE/3tQFMZYX8Nnqi34JmC1NfgaiFf3ZMqU7K5Xb71xx4DzbfkwPyMRl92m+/8wexi/2H5Xtc2BaJz0PpGA2zDxHAM1itGws8hnyj/GICMsX3dJ2Qze5f9Dj6RwZCi4snxNMO12/tUqYrxc0bRjhMNB788xER/PY6yvtmWJzWZLONvvVobV+zwpvYHVIK9DUuKGjzSOeM4nkC690uaNV6aA2mRjVMnZGPnxMDfeKEDqGdQdoWpiC8iTGkx5R+a/25+g/50SPo3LyiVI1AnnMIh8Qdw5xtPhEgjscd4mntiz+Yu3YKkAd/FcWyqBSUuXWy0r5PmQco+wuPBN81HTwlBdc/NJGjL8upQhZK+GRvuC9F6kQspnZPEQnOp7K/j4SkfFwZ24Bp6bdLmAzcYrJTB0UYQ3vJ/2XAAEAMfRqg78z8e6RpQzAlt1NqO5u5kf+6NfRXw5qb9u6wL5YeHkhO67m/zOwtxd8qIf5yyPWwfiZDsEYIA93yddi2SgWLlQsUrMv8r4fJ4PvwxU2N/UbKjwiGpIN7W4BgvzSGQA9hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199015)(26005)(6512007)(83380400001)(186003)(2616005)(82960400001)(38100700002)(2906002)(5660300002)(8936002)(966005)(6486002)(478600001)(6666004)(53546011)(4326008)(316002)(8676002)(66946007)(66476007)(66556008)(41300700001)(54906003)(6916009)(6506007)(86362001)(31696002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjhaS0lSbjJYUU5jNEg4dk9ydjdMZDZ2dHlqUUtSY1VuYWJPeStGci8wQjU2?=
 =?utf-8?B?QzJnbkN4Q1VyQkhBczVKRmdKU2xFbmVPZm1KR2Y2MG5seUJjRGZiY0pQZUFU?=
 =?utf-8?B?cmxEMHUzeXBVU2FCRUoyQ2tMNGhuQ2RHeFl3UjhtYVdrbEpnVUJlOTJVbndB?=
 =?utf-8?B?Wi8xVzYyTSt0QTU0cmEvV2hDTTBaajA1Tnl6SnMzTUJaeFJBL0pNWVhYZ3RG?=
 =?utf-8?B?b212UjVmaERqa2N6dmlESmxIZy9aeldoZ2xsVkJHRjgxNU1SbDRyNk5ick1h?=
 =?utf-8?B?NVBNa251TkJiRzUrTUltR0l6ejZ4MWhEOWRoWnVDaVRmT1FybTl4SVZ5WlVY?=
 =?utf-8?B?amEwaG1IcFJsSTZ2TW4rWFFncFoyU1VNWnlLeVI4NUd6dy95T1hEKzV5aTJa?=
 =?utf-8?B?VFFYVWxjU1VIbmMzRytyWTNIRGNuMkxVdmNpWHhZQXFqc1hGdnpXTjBoRUk0?=
 =?utf-8?B?eXFuRTBGRGpRZGMxelo1MHJueldmb213RldST0EwNXpKam5RVG1qaE53M0Rw?=
 =?utf-8?B?V1lhNGlSNk1XQkpYOVh2R1oySkpHeVpXRG56SndBcTJqaHNtS01tdDhhWkc0?=
 =?utf-8?B?YWd1cENvbms3WmhpS21XcGo5NWlBVFIzS2FLMnFHZmtwNGFlOThnTlBiZ0JY?=
 =?utf-8?B?UE4wR0N2czl6OWU3RjVGVTk1aE5FVExmWUFRS0J4a3ZoWExwQ3Y2VEY2NkdB?=
 =?utf-8?B?aXVPaytrV2Q3SzBiYkh0cGhGT2ZmY3l4NVBOZVNHdGQ5NHNTdG5XZm1BR2sy?=
 =?utf-8?B?SStsWVJWdStGZDNuclh0L3JDNjRoOTBjZnlPckRwSXZTdGl2NFlna3dqTVg3?=
 =?utf-8?B?a24vRVFXeDVRK25tK2lDeXJjVkVybU1uKzFhMVg2MXdNQlJXUTdkRUhZa1hx?=
 =?utf-8?B?M3ZBVEhRc1RkNFpYWkxFcHVFU2NHc2ppUG14U1ljTGEvbkJOU3BCSHVEeUNa?=
 =?utf-8?B?cnV5bDFKcGd3RDRTaHhSa0x1azZWREdVcVQzMStHNmpQcGgwTDQ3Qjg2T09M?=
 =?utf-8?B?S2h5MDlNKzlBNFNnQWdJelUrTnRCdk5SdmxsWTlCNUFxWVRWSEJ2UnRSMmdl?=
 =?utf-8?B?eWlPMW5qdGdPdDUxUnNLVGY3OXNZejlBQ0c5Sk5BN1hBVUVFRkxBakJzYmlF?=
 =?utf-8?B?V0VMMUpHOEVuc28yZEdrWTZsS3NvWHI4L25oaFJkZXh0MXBjL2F4ZWZEaEJK?=
 =?utf-8?B?dER5Wk1BSWEvUG5WNEtMcEhhS3kvbEduWFIvNDdhcHVjYjdicFNZZHBuRzNv?=
 =?utf-8?B?RVAyUTJ3TVkvQVI4MFNZZUNtd2xrWXJNMHdCU2dWNlE3VzJmYmFDWVpTUFlX?=
 =?utf-8?B?SUNXUUYzZ3hFNm5MMEFiSk1UZFp0TlBNcnlaamxZcnk4UitCOVk3NFJMeGE0?=
 =?utf-8?B?SkxRc0xDMmo0bkhWYXRyWFIwS3A4STVZOTBLOHRZa1hJZ3Rha2xwQkJQdzZW?=
 =?utf-8?B?Vis0RG5hQnU4dGlObUpnWndCZVdtSTFDdGdGK0Erd0Vac1BiRjdCbkpwd0FR?=
 =?utf-8?B?V2N4MjZpTmgxV1NKb2wxODBNMno5MGYvdkZrWjAyRDFzMzVSZXd4eFM3OUlC?=
 =?utf-8?B?ME0zdUdJeWpZOG5KdzI5Y3JWdFFDbXdnaENPNCthYi9lM3UzMUVxckg4eStu?=
 =?utf-8?B?UlNxRWNPK1FPZzRQdGtOY0pucUt0aDUvVVNiUjdXMnVDS3NjQXE4TG1RQ0NC?=
 =?utf-8?B?Ti9LajE4VHp3OUtPYnNHZHk5cWtIZDV2QWNubWQwRG00UDd2SlJXa1ZBeXFE?=
 =?utf-8?B?UEZ3VlFJR2hiY1BpM2FsUStBaWdzTUd2NUNyMW83bEllbVVKSit4ZHkzSEtE?=
 =?utf-8?B?L25rM3BUZDQxLzJtZU8xWUVJQWZmVnNIODBxSXl2cGpDcWtMcngrNTZ6R1gy?=
 =?utf-8?B?Yms5QWltcjRvbm1EbDBwUHFTWmU2ZGtrY1IvbUREMzhhUTJWeUh2RUtNWDI2?=
 =?utf-8?B?eE5ReFM3K2dIQ1RLdzlKaTRwUlNmazkxeC96SHZlV1lydjE3dHNVZzFka1d2?=
 =?utf-8?B?ajhtakxkZ20zT09kMXpWMEUzQTdXdWpIZzRpVVJrdEtTa3o3bi9PU0pWamM2?=
 =?utf-8?B?NE9wZkliZXFYbkJiTXpXbVNHdFRKNnJGR1JteGwydzdBdzh2OTNGQkJkS3pl?=
 =?utf-8?B?MEV4OFJwQjM2OVliWDVBT1ZrbU9UQXM2M1diMHZzVTJVclhhWExIdENiVjJJ?=
 =?utf-8?B?Umc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c2e959-ead9-482a-fde7-08dacd9485dc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 20:51:42.5893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RinqK6J0VSVnDjmnlvomn5rlqLQH/myUVfB6lNVm1BNA9dDazBSodcjhU0YZf6bJv3VSQuq1iYtS+Ajf4ijPRPkCU0y+UzGsMSXLcFih4iw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6866
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/2022 2:07 PM, Jacob Keller wrote:
> A long time ago when initially implementing devlink regions in ice I
> proposed the ability to allow reading from a region without taking a
> snapshot [1]. I eventually dropped this work from the original series due to
> size. Then I eventually lost track of submitting this follow up.
> 
> This can be useful when interacting with some region that has some
> definitive "contents" from which snapshots are made. For example the ice
> driver has regions representing the contents of the device flash.
> 
> If userspace wants to read the contents today, it must first take a snapshot
> and then read from that snapshot. This makes sense if you want to read a
> large portion of data or you want to be sure reads are consistently from the
> same recording of the flash.
> 
> However if user space only wants to read a small chunk, it must first
> generate a snapshot of the entire contents, perform a read from the
> snapshot, and then delete the snapshot after reading.
> 
> For such a use case, a direct read from the region makes more sense. This
> can be achieved by allowing the devlink region read command to work without
> a snapshot. Instead the portion to be read can be forwarded directly to the
> driver via a new .read callback.
> 
> This avoids the need to read the entire region contents into memory first
> and avoids the software overhead of creating a snapshot and then deleting
> it.
> 
> This series implements such behavior and hooks up the ice NVM and shadow RAM
> regions to allow it.
> 
> [1] https://lore.kernel.org/netdev/20200130225913.1671982-1-jacob.e.keller@intel.com/
> 
> Cc: Jiri Pirko <jiri@nvidia.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> 

There was some discussion about GENL_REQ_ATTR_CHECK, but this doesn't 
work for dumpits. While I was investigating this, I also saw a bunch of 
uses of NL_SET_ERR_MSG_MOD in net/core/devlink.c, so I have a separate 
patch to switch those to NL_SET_ERR_MSG, which I'll probably include in 
a series cleaning up the extended error messages.

> Jacob Keller (8):
>    devlink: find snapshot in devlink_nl_cmd_region_read_dumpit
>    devlink: use min_t to calculate data_size
>    devlink: report extended error message in region_read_dumpit
>    devlink: remove unnecessary parameter from chunk_fill function
>    devlink: refactor region_read_snapshot_fill to use a callback function
>    devlink: support directly reading from region memory
>    ice: use same function to snapshot both NVM and Shadow RAM
>    ice: implement direct read for NVM and Shadow RAM regions
> 
>   .../networking/devlink/devlink-region.rst     |   8 ++
>   drivers/net/ethernet/intel/ice/ice_devlink.c  | 112 +++++++++-------
>   include/net/devlink.h                         |  16 +++
>   net/core/devlink.c                            | 121 +++++++++++++-----
>   4 files changed, 180 insertions(+), 77 deletions(-)
> 
> 
> base-commit: b4b221bd79a1c698d9653e3ae2c3cb61cdc9aee7
