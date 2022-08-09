Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B4558DD3C
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245379AbiHIRct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245339AbiHIRcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:32:47 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACAD24093;
        Tue,  9 Aug 2022 10:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660066365; x=1691602365;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ob4q4w9v4seePTk42SnxETascvw+RJHJ+Nxyacq3wkA=;
  b=fXcVrx2VjEiuactnISG6r3FsN09ENUFTtAFvNN05eOHE7MFpiuYXtboA
   vhVZDS9bj51EZF1sky9kQxPHCNdUhXI0KxnWE63CxfXamFWBIHGK9JKXl
   XNZZ+DeZl4UmhtsEzxy0/I4i1VisG/vGtk3UAf1fwbaioyZ/x6VBL0W/V
   sbyvd7SrR30Wi1Z2OxS11X9SkeKLmodnQamvMn8s9ruhe6zsBWC5mg2B2
   0AAOq1e3wEp01mHc0X7YAdo+NRIXm9SwCeSOnWtsPXv6swhjpDTIHoASR
   x7h2ZOQ4PDhQbOyPf9uB4fniuCZ42pLWTkAUYx2kA04aMEYDS538Vzg9H
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="354894965"
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="354894965"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 10:32:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="672971705"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 09 Aug 2022 10:32:44 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 9 Aug 2022 10:32:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 9 Aug 2022 10:32:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 9 Aug 2022 10:32:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Utl/qDuTfpLCPg7lSteauM9C4qL9/isjDTx3wzqmCEuwHI+1b+On93gd8pvl/kWrEgiP56qPHiYW8RA4shuQWXcYXcL5n0LjSiqsJeTRc8aUV9RaII5aIXBmT5UJsDiH6xtABxn74l7WZ59XIP03sdzty+4ybgdNPoaQaqkG8YIi/X76n7+ClPmN8Et5GThI8OU9RZmKEAe4s7IdIw34jBDd59JyC+u3lmZn9xHw/dXbOR6fCsfgIMo+JYx13ovRlHaSzar/TPnEPrMDT5XHod8vGKxT4jPIHH7XebHQ6pgXkgxxvOrYqBP6OQX7Ce+DElRyXeaMNxt3dGOcdEybCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//JrvWyC34TLZ/euyzyDL/zhjyAUsxwqtn8rfVmk9bw=;
 b=O1LXwVnxyAV1Kkm9uMY0c7STm46n4a7+pNmqOahNBOkVk8XLhY8/5eiWgmTWseh1E4O+MVWjz2BjY7QdwMDz+OJtyLtratFraLy/EBadFdcR+RRdVu0W4zIpXN9V4kZByeke0i8XAPWb+2CtqH7hUgYsG4wS3b5t7yF63qZbV2Vbs1ilNl9dVkUTnjY13o1riWSH7o2WmqRF2uqg9j8w8yktDjanra1q76V8ndUq/PO/zFNZ9cbAlmh/XIs+4PrrMv27CbIoOaqL1C4C7U+lQToC4095ukf4b+RfnK2uxzQiNqDkaAYP+Mpez2zUKA7s2xYKk/9D+PIzzsy+RCHBYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MN2PR11MB3885.namprd11.prod.outlook.com (2603:10b6:208:151::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Tue, 9 Aug
 2022 17:32:37 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::9d3b:23bc:a1e8:2475]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::9d3b:23bc:a1e8:2475%7]) with mapi id 15.20.5504.016; Tue, 9 Aug 2022
 17:32:37 +0000
Message-ID: <b39c9fa3-1b7c-c7b1-c3dd-bf5ceb035dc8@intel.com>
Date:   Tue, 9 Aug 2022 10:32:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] igc: Remove _I_PHY_ID check for i225 devices
Content-Language: en-US
To:     Linjun Bao <meljbao@gmail.com>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220809133502.37387-1-meljbao@gmail.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220809133502.37387-1-meljbao@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::35) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be6ed68b-ef07-4b5d-2988-08da7a2d26d1
X-MS-TrafficTypeDiagnostic: MN2PR11MB3885:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gt2dSLHG3RerTyhqqnI1zRk1IGrm1j25hWb7eFcJmHUBKgYmEEYK4Kkvz4nENVf05JTQDTXCJmzh7pdTG08pLPFOlfkbFLfmjfEoQE9SNnOpoXFAltz32y15MItlZpg8iEMDUJ2eMHiJ6kRCKx0DMMDftciimeJ52bu5ebLWGrtfanjl807io0XZzOkmmnVAwjaSFlsE/54rHxVOU+1VqNx5pOoZ5R/L9TldBonijSTH1FJ8W+SnmYnne/X3lRaAaWEXRbjsyIfRtRotVr/GnpaTAG8djhY4qfmONO+CCgNW8BRw6bBZYyQT68VgAtsi28YpYEb9j8vE7kNoOEqBk+UVlh1HMIm+2boJi2OpfBxY2ttZhCkQGvU385oCHDER8yH48mHOnHU8hL+YodyGgZenQzpqm2p6N1OKsJb/xnULk90Ci2a/mS8vcn2dby1MlwLBnlUGGQsov6bRV/VZ7zTsjbPuiiagkys0x4M13ltlUN5rUFaKxy0vUY5VCvioAst8o0UawZe9i83DiFhjg0uxEcsnJUA/nTVtzUY5mPknF1+xkVuMK2Ipo31/eJLGQFHR/wVehhfPmsIEOcaT9pKFMkM9e+10+PgJ0p5UkOE/9P8PoYDXgfU4/HeEK3jCOnyn1pCVgawLpPX9AgaatoE01yXr0JPhP8s3G3YdQrQ6ZmX/riytFjp0ROJquEqYkxFATHBYYebE+e9/eMprnmUErtrifRXdubpZI9noSoOMIdSAp1WZ73M9Y2axges2uRUEgotdd/KtSVcHWD+o33PnAS/EWbprUoL58A5mx3dNqPSxEfPv0kkOdLqsAJU4hrFYWdcQZOKz3nJGa18u1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(366004)(39860400002)(396003)(36756003)(83380400001)(31686004)(6512007)(26005)(2616005)(186003)(4326008)(53546011)(316002)(86362001)(6666004)(41300700001)(2906002)(6916009)(66946007)(6486002)(66556008)(38100700002)(66476007)(5660300002)(31696002)(54906003)(8676002)(82960400001)(478600001)(6506007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUp4WXczOFZwY3ExTFBHc3FBZVd5QTFidFdBYXRQRXYrdm5oenYxb3NOYzN6?=
 =?utf-8?B?RTgyb0RVVUJkeFVvdkNLc3FBN2NrR2k1ZjlLbWpjbmx6dGFHMjJZRVJhNVls?=
 =?utf-8?B?NEUzTUhQWDdoWmU0cnd6RGM4QXB5L2lmRGRUQ0JweVV1aTNzaDZnTXBLZmxv?=
 =?utf-8?B?WHRNeWRUanBGYjVBcUtDQ2ZDSnViaEJEK1FuMFhUb1ppaFJtMkQxYWJYMkZj?=
 =?utf-8?B?NlE3WlhuOVBCcUF1Y3VuUVZDaVk2UkxuSkZEckZLWmVjVG9aT3BpdlpXVU9y?=
 =?utf-8?B?bVE2bC9lazR2dE1FYll2bzBoY3MydUJ5MWlRbmdZbXRQYzEvakwySE5GL1J1?=
 =?utf-8?B?cG5pWTlSZ055RW5GNXp0ZkZSSFl4M0czME9BbklMNmExQWhkbllZcXF2Tlp5?=
 =?utf-8?B?c0lVOHpnSnhnMjU0M2prbDZGVktncGI5NmVKc3ZLeFQ4N3A0SkU3Q3Nja05n?=
 =?utf-8?B?amd3Z201TXRJdUc4RlN3ZEJrQmZjb3BOV0pQR2VUUFB2dmFDNE1QYmJ4OXgy?=
 =?utf-8?B?djBvdDNwMEhwMWJvS3RPMFc5NWl3NVd1a0xiRitkendLb01kOVhQcTRBNENv?=
 =?utf-8?B?ZU1aOGQyS0xsSko1UTlMZWIvTE1XZG4xWW5jVXlzcWZPQ0V4c1B3eVZZYTZR?=
 =?utf-8?B?L2FNYWZHMFZFNTBwaGpCbkEzaDJrLy8zTm5UVGpvMnplRVl1S1VjYWVMZkxy?=
 =?utf-8?B?ZTNpU1ZaTHE2MGQxc1FlNVZkeXlPNmsyVUI1bmZBUXdkbmo2cFB4aFdoaDc4?=
 =?utf-8?B?ZXNudWtiWElkRmJLOHhEL215VDRIRkI5ZU5WdDByajRxZFhNQWFYbzhPaEN2?=
 =?utf-8?B?bjk5OEt1VHIzdnFxb3Vra2JBRkRFUUpxWXhoaVpOMGpONnlZcFpMWWZNRllV?=
 =?utf-8?B?cTc0TGxSOUhNQnRuUkZrMERYdFNISkdnQkVwcHVCcFd3em1sNmljQmZUMUwv?=
 =?utf-8?B?bmVldjVKd1JIbGxsNXR5N2ZHWGFDbkZBVExMaTRoaWZIVmcvSGJ5Zm5JMWIv?=
 =?utf-8?B?YzZyaWFXMTMvSjFyVnA4YnZMU0pWdnM2VXAzQzdTOWFZUDJMRFNjcjVXbFdq?=
 =?utf-8?B?K0JJKzNtQkxody9RWXhmeXhyYVB5YjVVVG5UOGd3dEFsV05SY2M5aitoTjRF?=
 =?utf-8?B?MG54ZDhSbWRIYUdNc1NpT1VQaFcraXFlWXlWUE5QaUV3dms3NUZKdzIvemcw?=
 =?utf-8?B?VFpXU3JEK2NwWUVCejFrQ0l1UkNMWHBpL3g0cmdzTXEwUCtpKytMdDJSaG51?=
 =?utf-8?B?eVdGbERLMXZQQVRwMHlyOFh1R1FkQ3ZkMGM3ZFpzWUk2SGZSSGpYY2krMmtC?=
 =?utf-8?B?ZEpmQ0gyRXU4Z3luaEYyTHBiSmJ1VmJRcEdRcTI0eDNHaUE2NEs5dEYxVmhs?=
 =?utf-8?B?UWRpS3pIZ0NrajJ2REtaeTZyc1F2YTVkdEdhaStMZ1g1ZXRGZjhrVlFTWXJh?=
 =?utf-8?B?d2trdEI4K1lZWkdsWU5EdEloUVc1NTJqWUlYRGFLUzd0dTYrL2xtRjRGTG5u?=
 =?utf-8?B?KzdUbVlpUERGb1Vwck1HRTlRKzdVOE1LWlZhZVRBWE40YjBQZGFoSW4vNXFS?=
 =?utf-8?B?M00vYTBhakNVUDRwczZmcUlFN3d2bkFQZkZGZjB5endWVzc0aWY3RVNzVTZ6?=
 =?utf-8?B?YWNXbUR5aEI5djZFSEZHL0dlS2NQbWNEN3cyVGFTOXJEOUxjZGQvN1ZDdjhC?=
 =?utf-8?B?U3dEQVVZVlRIS3pXNnhSY1dRWmFUZmpEa2FKYXRwYzVoZzhUb2hOZnUxdVpB?=
 =?utf-8?B?c1gwNXlQdUZQNnZwSmY4b0ZvMHFGUndaV05ZaWN2Qm8yYmM5TW5Kc01WbXdy?=
 =?utf-8?B?ck16Vk1rMGUwb1VFckdyNE9rQ2hwUE0vYk5panJIY0RBazExTFVJZ3dER1Zh?=
 =?utf-8?B?bHcwSGw3MEh0Wm1UZk1XV01hQVZ1U2ovbTJhUUx0djdXUENKd2Y4QklvelFt?=
 =?utf-8?B?eGt4R09OVDFGZWltZHFYbW1oK21SSW90ei83Q2xUZjQ3MkJmekt3em80YUNW?=
 =?utf-8?B?M2NjRE5PRU9uN0N5N1hlR1lUZ09zV1ptQjZiVUYwOG0rZ1NBbUFtM1hncE5i?=
 =?utf-8?B?RGtvRStZd0NSSWtSUmxaNXVtemdHamxteHJGSmF0a3FVZEYrTlBGM0dyalUy?=
 =?utf-8?B?VVJPeEcrQ0FlVitiYTJTd2IyNHQrcTI4Nmk4QlZ6eFhoenV0b1RLM3RENGY3?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: be6ed68b-ef07-4b5d-2988-08da7a2d26d1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 17:32:37.1267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHbX7uq/UlGkCOVZDCrikJdB+n7JOSDzqrzsaKPji+y0myzUUEytjxLofn2kWc6oDx4YE/MAl73z0PJEt/rQDRHGem5hVDrDk4Writm0SqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3885
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/2022 6:35 AM, Linjun Bao wrote:
> Source commit 7c496de538ee ("igc: Remove _I_PHY_ID checking"),
> remove _I_PHY_ID check for i225 device, since i225 devices only
> have one PHY vendor.

What are you trying to do with this patch? You're referencing the 
original commit so you know it's committed, but it's not clear to me why 
you are re-sending it.

Thanks,
Tony

> Signed-off-by: Linjun Bao <meljbao@gmail.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_base.c | 10 +---------
>   drivers/net/ethernet/intel/igc/igc_main.c |  3 +--
>   drivers/net/ethernet/intel/igc/igc_phy.c  |  6 ++----
>   3 files changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
> index db289bcce21d..d66429eb14a5 100644
> --- a/drivers/net/ethernet/intel/igc/igc_base.c
> +++ b/drivers/net/ethernet/intel/igc/igc_base.c
> @@ -187,15 +187,7 @@ static s32 igc_init_phy_params_base(struct igc_hw *hw)
>   
>   	igc_check_for_copper_link(hw);
>   
> -	/* Verify phy id and set remaining function pointers */
> -	switch (phy->id) {
> -	case I225_I_PHY_ID:
> -		phy->type	= igc_phy_i225;
> -		break;
> -	default:
> -		ret_val = -IGC_ERR_PHY;
> -		goto out;
> -	}
> +	phy->type = igc_phy_i225;
>   
>   out:
>   	return ret_val;
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 9ba05d9aa8e0..b8297a63a7fd 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -2884,8 +2884,7 @@ bool igc_has_link(struct igc_adapter *adapter)
>   		break;
>   	}
>   
> -	if (hw->mac.type == igc_i225 &&
> -	    hw->phy.id == I225_I_PHY_ID) {
> +	if (hw->mac.type == igc_i225) {
>   		if (!netif_carrier_ok(adapter->netdev)) {
>   			adapter->flags &= ~IGC_FLAG_NEED_LINK_UPDATE;
>   		} else if (!(adapter->flags & IGC_FLAG_NEED_LINK_UPDATE)) {
> diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
> index 6156c76d765f..1be112ce6774 100644
> --- a/drivers/net/ethernet/intel/igc/igc_phy.c
> +++ b/drivers/net/ethernet/intel/igc/igc_phy.c
> @@ -235,8 +235,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
>   			return ret_val;
>   	}
>   
> -	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
> -	    hw->phy.id == I225_I_PHY_ID) {
> +	if (phy->autoneg_mask & ADVERTISE_2500_FULL) {
>   		/* Read the MULTI GBT AN Control Register - reg 7.32 */
>   		ret_val = phy->ops.read_reg(hw, (STANDARD_AN_REG_MASK <<
>   					    MMD_DEVADDR_SHIFT) |
> @@ -376,8 +375,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
>   		ret_val = phy->ops.write_reg(hw, PHY_1000T_CTRL,
>   					     mii_1000t_ctrl_reg);
>   
> -	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
> -	    hw->phy.id == I225_I_PHY_ID)
> +	if (phy->autoneg_mask & ADVERTISE_2500_FULL)
>   		ret_val = phy->ops.write_reg(hw,
>   					     (STANDARD_AN_REG_MASK <<
>   					     MMD_DEVADDR_SHIFT) |
