Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EC749D2D0
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiAZTxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:53:38 -0500
Received: from mga12.intel.com ([192.55.52.136]:51577 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229484AbiAZTxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 14:53:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643226817; x=1674762817;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SfmTOnDdU92cbvpQLKkkH57/Nw9iTV4EaYgalGsaY7A=;
  b=EiMj/WunXWByFYRL29oXc8Kzikz4snYSKrtjyhiOzy4R1cwfbSvCdG4g
   XLOsf6/wRmMzl4L92YPzY82IA72N9ztdRvilO4QZtjq9zHqHGKamW3bH7
   5T7PT98IuP5X047IpJzBLg1HPn6MijPmSIwNdyQuTVjKvdZZod262kFrv
   4rOS8PqGaBPb41l+1mEmEYRoKNEz5/tRkoN8WP1IGnOVFuM65k31DOPci
   GXT8uhH/OKrqvMowcirWPY5baLTwNcr0p8a8bJTWODwp7gzXW9tGWX57T
   Y7L94Qg0+mKYIP0ZNb7f0IdXm6IJktFlNMbH7KnLidlhx7FflxIqngIio
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="226614492"
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="226614492"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 11:53:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="674456993"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 26 Jan 2022 11:53:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 11:53:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 11:53:34 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 26 Jan 2022 11:53:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 26 Jan 2022 11:53:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SP1OqEqTtXIWpECUts2I51Yst5tD/cLBKqpVx9C94BlNCOvfWuNIv3LRI2DP0AX7ynKR8Nm6NxsY6KHM0xAxT14ngS5fO06cr88Ad9SNxH4UX7z2LGFhL8BcIVOvsB7ZS0R6B6YwVv8s3puUL2vbnO47RP5qEFTzagIRmpaMgHMNTDHgWRfjImt2LKFNJtCNHKVRRaQQGXMuwmpBwTKTECv1nUEsvJ96vBvZc12yPtps7VtPSwrw88zoags1Wt2KD9jnKz27nvzawfk6BOjtPtiMghjuSHZnDI7E1/IhDOGX/aw62rIuFHeSVfvFYI11iyZUiG3/C2hqfdf1GW4HJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6bYwo8Xa7vXFr/7E1tU2lxAlB7zCP9BhDlYww3dxQc=;
 b=K13WXXtLbESkr7bKp0SZ52NqivU6r7pPk3fk1oWPDXmeVfA4f3kEnS9jr0zlWVUmGHbQeYZ9K0EmcrgpDDdxQ1F54mUtyFqW1x3jptZUhHcRsGrOGBAH7LlCw+ZiVHNXCf8ybVwx3sYBeet+xzpVQwbD9GmQGVLw+ASz43IYexmiUhC4MGC/4ssgQa2BCt4CDGUH3daDwM05Cfgu2GRWk/iYjmFgRIvdsQ/eAnLEZ1OrgmXUBGt29OT1GkC5jNxVPTkf3Duc4AJA9xn4kPl+Fu9U/mKLHUUqo0QuynP3m1iomcn7OJFJFn5hOK3PvNhDCsA7CKdOiELKqPnVi8GGsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.14; Wed, 26 Jan
 2022 19:53:31 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::d016:68bf:aa12:d92d]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::d016:68bf:aa12:d92d%3]) with mapi id 15.20.4930.015; Wed, 26 Jan 2022
 19:53:31 +0000
Message-ID: <bb6675f9-63ce-77a2-e4fe-76cc592e5f41@intel.com>
Date:   Wed, 26 Jan 2022 11:53:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] i40e: remove enum i40e_client_state
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <anthony.l.nguyen@intel.com>
CC:     <shiraz.saleem@intel.com>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>
References: <20220126185544.2787111-1-kuba@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20220126185544.2787111-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::26) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 267a3695-9bac-4abd-3572-08d9e1058749
X-MS-TrafficTypeDiagnostic: CY4PR11MB1783:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CY4PR11MB178394F2631B11732E47415A97209@CY4PR11MB1783.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2KCw1WkctORM+H4x1yOp0VPkvoVT40y1mH7JejE5POG5cBeAdzplHz26EK/CT9RUh8PUh6johRRYh7hPyNwnC6YcMWStTOHz5+3/u1wlm1H+FXx7lgmT0eP96ePexgRGTYz86upL5/6Bag7MIFiLDoLibID1+OZCmepMK5lrRWPQOVChQJCfK1+ffRw7aAfe4HWPsXXNqRuHyhCPZk5HOd8NSqRJR+jQKenLxvOSf71Srvs1sGxlhdGASZjG7/ESLGFgu3dWVawvBiYMEgBMVnE9FwVPdoZQXrpnidOqmv9bHLGckykulaPKPRnHz5Brg5g4qToqDJchADhiam/yS7Q9XJ/Xbywd2g0AMs6GPomORuXYTlzuxNUcFUYvJt87iHWMBkEVWunyMnVLAbBxORBF8dxrFmt6DtmJX9hZObH2LkTudqP9XCJ6kU4woA9B4gy1ajNoifThQ15TtUUQc05ZtIB//AMQbPb0d5jGaLzu4NnBOI83DIhs666wXYAPYOiuaJxMSVG4cH5Q2Gk3retBuiVpVppiqwd1pA3WMCKBC3xH1FCXd3lKuezSAu8ldD00qJdZmO0+1/1J/fryE1cV02WRBX5mKUNbZplfN9DFN/nqb4rtjsL1qcgk8gJzOMa1eZsQPVXoyP6Mmwm/mB985bqBTq91exP4q1xCwfRx5wDykKP4HnU/wJIXL43tww3fAbmg/c/N0u/bbYvflP0Q0kkxVnGbF8bHCBTRTpw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(44832011)(31686004)(82960400001)(6512007)(2616005)(53546011)(4326008)(6636002)(8676002)(26005)(316002)(66946007)(66476007)(66556008)(86362001)(8936002)(31696002)(6506007)(186003)(36756003)(508600001)(5660300002)(38100700002)(6486002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K095WmZZaDZSTERPZUNRN0p4dVAzQ0JBSktaVFRVcVlrUG1vMmVzalQrRlVC?=
 =?utf-8?B?aXJQZzZDMDJXdG14N25uRlNGaHNKS2IvYjNxUkU4eVRHQVZJREtKTFQycXF0?=
 =?utf-8?B?eTlBdk4reDhWNzFYMVdFTm1Ja1c5ZENKUjZCcWl6NHM0d2FzOXY1ZkFPdTh4?=
 =?utf-8?B?YmNQV2M3KzBsb01hZEQrdXJ1bVNQbzYyZ2VYd0c0WnBrNDEwTEttb2tBMHNv?=
 =?utf-8?B?Q2xsaXRpM0RQaFZVdXkva0tFbitWVmxVYnZURnc5WFNSU2RDeXRuWnA3V0F6?=
 =?utf-8?B?SllxcXcyTFVhNXFYaXZxMFlFNVJWODVwa1A3Q29uNkl2WW5yVVJtNFFQeVJZ?=
 =?utf-8?B?NXFVWThMZ0xhV0xqTzlHWU1LRi9EQ2dzeWZGcUtiVG94QWVMRTI0bVFBWVhY?=
 =?utf-8?B?Qi8zcDVFYjlYL2pHbzBjRWI1MitxV0xTRFdvaUlERVd5V0VQK3lHU05UbmpM?=
 =?utf-8?B?dDNHWTlKbkxnNjBmQ0d2V0hMQ2F0UDBuelhPS2huSVJuK1gyMmlVYnU3MHpj?=
 =?utf-8?B?RncyRVl3Q1BNbWlZam9IeTQrMU1LWUR0SDhETlQ2U3ozd3dNdUJSenNBdXVH?=
 =?utf-8?B?WUQxZzFpK3ZWbW95RUNhWFRTOFBuZVV1ZHhTWE5kNElOUXUwcmw0WGtmcURw?=
 =?utf-8?B?UGhMTVhQb1pyMGl2anpXR2hLTlpEcVFveEdDK2s2YXkvZ1ZjVzNrdnVtSzNT?=
 =?utf-8?B?bEZjYW02bDZRT1VpUVQ5VlM5a05KaG9GaHVYQjFBaFJsUUdTelE2bml3NjlN?=
 =?utf-8?B?U2dYREd4dFQxRE9HS3dDYWZhY20weXppalNQWW92MVQ2MW1LMEtzSFpGbllP?=
 =?utf-8?B?dmtZRFJVNXkyako5Sitsc2xxZkZkSTZoZG9PeWFvdklpeWRrelg1OEs2Vkpp?=
 =?utf-8?B?NHBPTnpxeWdzNzJYaHprTFhLanNZbnkrS1ZZT1UzM2ZOSFpqL2FpbXMxWGVv?=
 =?utf-8?B?N09GYjFubitmb1ljcUxGbkdnRmZ2ekxHMHpNZktQM3BENENtcXBPYWlWZ0sr?=
 =?utf-8?B?MVd4UFFJdkFybUVpd1g1TkZNQ3UyWVdSYURrckwwNmprRjVhOGVwQUFnNVRY?=
 =?utf-8?B?bndYTkZNdHJLV3hBVE1CZHRZZFY5VHozQ1psbERvc1NUNzRjNW56d3RyVFow?=
 =?utf-8?B?WTB1dHJHYmk3WGoxV0ZoMEpiUnpXZFdCS2NvZm8yYzJ3dnV2WE4wK0V4MUJC?=
 =?utf-8?B?NnQrYU9MVW1yaVVTaU96a3haVUhLWWxiVDR6bmNwYitrTzFlV0dMRlg5K0ts?=
 =?utf-8?B?U1h4Z3ptM1l5ZFJNUkh1dWlBbnY3UHRTM2hEV3haZk5DRm40cnR6YlBmMkV0?=
 =?utf-8?B?SXUybnZLWEhGVGgxSCtmVnY4T0lIcHJxRWErT1hFSElEeWVNYnpGaVRPN1V1?=
 =?utf-8?B?QWFCMjJ5VmhEZDFUTkNvUkJJd0hHY3JKSHJDbmFaRFlyRGVOclk5dkpHUmJR?=
 =?utf-8?B?TUExa0xab0RWdm1lNk8zRnYzTlhxdytPL09kRUlybjdwZGl0TVFoRVdYSVNV?=
 =?utf-8?B?TTl4VlpVdHh2eTQvd0JxTTRSTGREc01Vc0lWa2toODZlN0RHYWxIQ25vanZ2?=
 =?utf-8?B?WC9LeWhQcllZSzk5STd4UmVPeVB3bnE0UVJpQjJWOURhTXRIMVZEZXZScjdS?=
 =?utf-8?B?Z0lJS3ZXVGlPZmViSGRwbUVmMXR1K205RTNIWFZRc3I3RFJRd0YxTzJqam1V?=
 =?utf-8?B?UktrK3h2TXBFNW5RVnBPSlRYRW1za1pyRUJNRERYekFYajlXOGQ5QjJRbEdQ?=
 =?utf-8?B?b0Z5dWJWQ2w0R2pEbmJ3RU1PRE5KTVdsK2NQS0FiOVkyNmZOU2xPa1ZCVGsv?=
 =?utf-8?B?UFFkOUNkT0hCZ1dFNFdoRUF4RENycEdVZ0FqTHhTNVZvblUwNFBRRGI4Z1JW?=
 =?utf-8?B?TDFnemhJNzdJM2NWZ2piVXRhMyt1S1RVb3lXUlEvRlFKM3FwMmNaT0NZNmxV?=
 =?utf-8?B?VUN1Ni9zUUxDdlNJNTFvUnM2ODhqK2R0bzFYR01aYlJHSXJNbGk5eStnbU1a?=
 =?utf-8?B?Z2FGME9aTDNOcTRaZ0tzTFBWajJuMjZsS0kwZkxtd3NEYTZqYWR2dnNnY3FV?=
 =?utf-8?B?Q2x4ZTBUZEUzdWluVHlnaFdjWks3TzNkV2JJZmhhN3VhenZSaUtjU3ZmMEFi?=
 =?utf-8?B?RHpQWTJ1Vno4bkQrTzYvTUZlZWVZWkR5RzZOWmErZXNhMFVqTDFJaW1jVHBB?=
 =?utf-8?B?YmFOQy9adVpUNEhkV0tYY1BwNk40K1NVbDM3UElrSmIySTlQTTJlNmF1RElP?=
 =?utf-8?B?S05OV25QWTd2eWdYc3dacHZ4ajlRPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 267a3695-9bac-4abd-3572-08d9e1058749
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 19:53:31.2474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oWEkXKpcuoc3ywBf9UAGzzS8073gRsUwO63WPPkAcUO4H6Ven5223On2GxYg5N9/fqspYx/XumSgzvFCHbdCsfi01vMW5PbSRZPCPmP/5T4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1783
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Jakub!

On 1/26/2022 10:55 AM, Jakub Kicinski wrote:
> It's not used.

minor nit, you didn't say if you wanted this to go to net or net-next or 
add a Fixes: tag?

maybe:
Fixes: e3219ce6a775 ("i40e: Add support for client interface for IWARP 
driver")



> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

for the patch itself, it looks fine to me, so if you spin this
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


> ---
>   include/linux/net/intel/i40e_client.h | 10 ----------
>   1 file changed, 10 deletions(-)
> 
> diff --git a/include/linux/net/intel/i40e_client.h b/include/linux/net/intel/i40e_client.h
> index 6b3267b49755..ed42bd5f639f 100644
> --- a/include/linux/net/intel/i40e_client.h
> +++ b/include/linux/net/intel/i40e_client.h
> @@ -26,11 +26,6 @@ struct i40e_client_version {
>   	u8 rsvd;
>   };
>   
> -enum i40e_client_state {
> -	__I40E_CLIENT_NULL,
> -	__I40E_CLIENT_REGISTERED
> -};
> -
>   enum i40e_client_instance_state {
>   	__I40E_CLIENT_INSTANCE_NONE,
>   	__I40E_CLIENT_INSTANCE_OPENED,
> @@ -190,11 +185,6 @@ struct i40e_client {
>   	const struct i40e_client_ops *ops; /* client ops provided by the client */
>   };
>   
> -static inline bool i40e_client_is_registered(struct i40e_client *client)
> -{
> -	return test_bit(__I40E_CLIENT_REGISTERED, &client->state);
> -}
> -
>   void i40e_client_device_register(struct i40e_info *ldev, struct i40e_client *client);
>   void i40e_client_device_unregister(struct i40e_info *ldev);
>   

