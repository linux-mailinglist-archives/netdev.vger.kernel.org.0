Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FB16BC0B0
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbjCOXNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbjCOXNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:13:19 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6AD136D8;
        Wed, 15 Mar 2023 16:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678921998; x=1710457998;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ENwt9juiNn3LXNeq3wH7Hb223itDGl4rzpGYyAZbZ3g=;
  b=IqfC1SSDvVgo7EXFT4lk94QSyG9kjrx7TmJWZbNtPNqEwudOrYLn6/Jn
   myiuB1piZ6P6aAecGNs/74C0mh6QF5csPMPexQaf5/R3zsconJW31WLcW
   oRj0FFovDQdUBnlA55YnljD92KKZTVb5sbA+05cyY0SVATI8F3bWYfXlU
   uasgDTmPkGtJVyEhO5Sud54D4IKRql0o3REvZItCaKh/XJisZIIOC3HJF
   Nz15ZyRAFc3z1BaexHBGYsdkGqA6dxuzyfSp67K4qSZZd/bo5T3J00dg2
   37CqXu+5huduu3/TRGKRRlajwtM20YjX/Mh/R/2gzCip7BvYHz7NIYaMw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="424111769"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="424111769"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 16:12:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="712108419"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="712108419"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 15 Mar 2023 16:12:53 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 16:12:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 16:12:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 16:12:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ubb31Pe8k3sJ98a+zjw7AWV60Bt4Kj5FHFONm3KIG2z54VBZfdAOgKsMPVJnLpxU5r7X9poO1TvrXGNfrOfbyMNR7nnUp8aq9Zi3lwCzHxA89OOtJa4k8ZHF6X5R1Mp8iyLY1b4sVPnVPkqBnuxlXvvNLSDTOvAnshT6HW4eWaYpxHUMX7NuQvSSKv/+hehxlSEo58MuYp776GpSrRZU0u4vlavh/G35ZHGqqaqG3WNq9WqrksPrsZKFNidyrm1E4zwHjg2w9q9HFLLujvaVGYoMVE5OKfxgbNK8+kioByEGXFK++O294wy8Ff5FDNFU05v5dSwGpix6h845IQlXaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9uyMEfYhLh/3cqg5f9qzxZnKHOHlx27JWJrsutOdgo=;
 b=Li+BjVg8fK9174SgJazyLAf62nO90eQuGGHL4phqaieGyJI2oRUT/nPw6R6A2AQbfs6X+Fxe0X2HjZIY3qxhYICbZ4+HtQsiKSfuIHh1d/xV9Yy5Nizoq1fS1m0Jqs3M+7xWaUBfwMoJYhnEG9dLWR5YBg9j94PT0+dOt67ykwXRO0MdMzXHQnsufxubMyqMcW+K/0I6AFlcHqh6C/duSW/P/W5+4GKTY84mWBzI2OcAgS6Y101XFfp69SqUqjpSqkQVN/SD0rxSTaBBQAZKj6QGO5l1oD9JfC6eyxNg1T2Jo2eWlajQMaHJpseZP+sWwOGe7XmC4BCHjgYa5ydFNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH0PR11MB7709.namprd11.prod.outlook.com (2603:10b6:510:296::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 23:12:46 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 23:12:46 +0000
Message-ID: <e7640f5c-654c-d195-23de-f0ca476242f1@intel.com>
Date:   Wed, 15 Mar 2023 16:12:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] docs: networking: document NAPI
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jesse.brandeburg@intel.com>,
        <corbet@lwn.net>, <linux-doc@vger.kernel.org>
References: <20230315223044.471002-1-kuba@kernel.org>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230315223044.471002-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2PR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:a03:505::25) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH0PR11MB7709:EE_
X-MS-Office365-Filtering-Correlation-Id: ca8c342a-76f3-43e5-bdc1-08db25aac95b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /xBV4vZoadvHps+52EQuC8Ab3mXMNFdDdM0pQfLy1vDq3c105YJOl+hjaRICnoXmbnj3n/J1CtomDsm3GBvq2BLRx1qwAW/m+X2CjAtP2soPX2WV4Jxf0HLqNQ+ZOuifv/Tt7eyF8HNjsXy28F1ODRoGau8wjjUqKUdXqsdy48SKIP0J55YLKctt/2tlKr45hpXHCEuEyVKAeDdj8KrZripL8ypEj6idgqXlmfYpa76Ndln9ZgGvbE3gnLz2fso06kl7eGtLfLq8ddrqys7RFJGjSUUKwLCXDv65aiWchqZLPmJEeitbbR2sBIPz4ln78YpVu6Zhlosex4/iswb/p5riaI36Goc+oWKyRNg0wHevmw/wi29GpUTIQBCq7dm1ucK2bmhrF10Ji6F/Sk3702Eig1a8OFT+sOd/B15rayp5CMpSXtWyIfZm2U3Mg8UJESBFTF/s3VXAigyHcXHqnQdU5pXl0xL0dBQKEo3djG40sH4pvaBISFICCeBqt5WE2RBonOeHs+c/RUlrXlSBIZUQFDV8ycpkxlgylnpL5cjgYiBf0DScq9ZFm/ijlzAL8l8WLu4d22MWD//G5rNL1yV2FDH1PWWwcAOdw0Jwze7/PgedPerZbq4RH2TTjHd+hEb7SPWdl3XZpzZmp6ryTK2zWflVhJno0bSGm02s8+dVlCdhQ0gcMlIJdBO1oaA8uBjcBRqAGuzmheBG5eP9RuEKs40TsoDeoEEW2ibhlyw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199018)(86362001)(31696002)(8676002)(316002)(66946007)(36756003)(4744005)(2906002)(6486002)(5660300002)(66476007)(478600001)(4326008)(66556008)(8936002)(41300700001)(82960400001)(6666004)(38100700002)(83380400001)(6512007)(6506007)(26005)(186003)(53546011)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?My9UcEhYaUdFV1UzMjEzWWkwcUdiWS9aa2VSUmwxajlBd3ZVQmxaREJMMngr?=
 =?utf-8?B?aWlGYlZRcGR5aTJieEIxTW56UlVxK3N0TVREZ3FObHNLQjNST1VSREdYc3Va?=
 =?utf-8?B?a0Fxa1hUbHFDd081OUYvZ1NmMld4OXlnQ3BaMVhSakhhZmJXajhRdmtqcTk1?=
 =?utf-8?B?WEE0Z25WWVNFcldiaWNtcjlYcndabyt2STBlb3Via284SUZheU5CdzdmV2hp?=
 =?utf-8?B?UmF1L0xmcXVNYkhicmpTYUU4MVFJYlhlVGx6SDVpbVAwZ3JUVHZIR1U0a1ZL?=
 =?utf-8?B?RFhoVW1OeFBjWEVjTUZucTg3R21NdUMyVDZXTEhpWlhVdEtDTmFyR1VQa0h3?=
 =?utf-8?B?M1JZMXpZYWZhRmZFdmZTWFhMYXR6RGZ5ZTd5L0Q0djBTSHJEQWlZNHhybjVF?=
 =?utf-8?B?SCs1ZDNiYVozckJJRVpvTUNuajZrUFplOEZaWVpQMjdtV3liZEhGb3ppWktT?=
 =?utf-8?B?OGYvSkVzQTA3L3Q5L1JENmhSaGRDdUhPUDZPNmJLR0k0dVAzdTVqLzV1azFJ?=
 =?utf-8?B?eUViOVF5SVV6MTFZeUlraWMyOHpad2JsTFAwZ0h1ZlVtbWtjY3NGd1htUFBB?=
 =?utf-8?B?RVBWTkZneS9qL3hBSWtoUWNybHk3ZGdzdGM5RTJRMVM0aVBtcFh6Q1ExMFBt?=
 =?utf-8?B?S0tqWjZoUEZoVlRpRXBsTyticFlrR1h2U1hEWHBUZjF3L2tOMDBZVGthTHNs?=
 =?utf-8?B?eTdYakxjb1hOcEwvcDR1di9ObG1pd0tCejhWMUtLUlpYNnJ1SzFxbTl0NDFm?=
 =?utf-8?B?MXhHUlBBWVpzVEFHUU5qQ3VhVnBuY1VFbWNSN3pZSHhwbDNTb2J0aTFoSmlr?=
 =?utf-8?B?T3pCby9nYjBRRXR6ZFF0R2JudjNnbTg0QWQ2ajdNTVBnVlNSK1ZGRWlkWlV6?=
 =?utf-8?B?NytxWDRkcnRmZGRVNFhWWUtzcnNaNlZmaExzLytDbGVaWEFNSFl2VHNDbk14?=
 =?utf-8?B?dEtpWk43eTlPaGhacHROeGV5MTdtTnY3RmphQ2NKa1VhWTQ1UXhiZ0JwcHhR?=
 =?utf-8?B?bmUwZEk5TTBFZGcwV1RhcU5RcFNmRlMzRWtRSzZJTCs2WWsrL3pzcVRpalB6?=
 =?utf-8?B?djlnaWFwdWtXWjFDV3E5SHUwVEpoeU5uYUNBM1dhMmV1dFRyeG45Nm9HNFE2?=
 =?utf-8?B?VXpPeWxjU3JyVVM1aWpWMXV4TmdQNzVBTml4UjZvSTRWbDBMSHVDVkhpazZK?=
 =?utf-8?B?YlFMSVJvdklpVlFITzdYL2hURGtXTzRPZ1ovYjRISjdsM1U4U0lnQlp1Zy9v?=
 =?utf-8?B?eWptT0NFbm5UK2crbmFiUGtrWmdmMHdBUWxmeXhtSUVkemc0N1JtNEFhb3Ur?=
 =?utf-8?B?bUtCR0Mza3llOWY1blZuWFdUWmsxdC9udGF1cGlrdjBYU0JIbFlQUkxIdzJF?=
 =?utf-8?B?ZlZ1RU8ycEZJUGo5SnY4N2NLdSt5UlE0Qm0xV0JoRW1teWhjL240YmdRTlVx?=
 =?utf-8?B?aEFCdjdiS3hFM21FWWZLcWhoNlI1MzFFVExPcUtQS2MxVlptaTlxcU9maVJX?=
 =?utf-8?B?Y21SUlhUd2ZraS81cll6a0M0VHpYV2pTZysydDFkTk1vRXF3eURqNjh6cHpZ?=
 =?utf-8?B?MjU0WkVaenpHSUFQMEU4dVVCamsyRFhjSlZ6dDZnKzliWXpBVlA3dVkxdysw?=
 =?utf-8?B?TUhneDdsY2RxN0NQcnVoN1FLdVZlNGFaV25BM3V3WE9QZ2ZEcytaTzVjT1dT?=
 =?utf-8?B?cGczQUUyaW5LUXhpclcxRUxKa3F1TVlRMzlQWldnMTBwOHI5WDNUL2IrS3ZW?=
 =?utf-8?B?ZDZaZEFaQjVoTFEzd3VaYithZzJtU1ZjREJRbHpTMjRjUXBMOGgwSUVwVDNh?=
 =?utf-8?B?WDZDdXliYlFMNy9IbXcwbld3ZGhRSUc2UEU0RklzNlY0YUk2UWl6UnJrRDZR?=
 =?utf-8?B?OXdVR3JHNCtpbmRleTVyeTVuMUptSnE3RlBzZFlZSWFjRFhTcVU0SlJHNUhX?=
 =?utf-8?B?ZlNVbjdSVlFKTk1scjJvaXo4bmVISG5LL091Zzh4K2lEQWo2S2xwOUZHYU9r?=
 =?utf-8?B?OGtoWVNNVGQ3UUtiQUkwVnE5NTRLOFhJZDgyQkdHajJuK3BOVVlTMDVMYkha?=
 =?utf-8?B?N2ZjNVVtTTJsdGkyZnNUa1V5b1o3N09YUTVRbGZKTy9RUjRkTStrWHNOdXdp?=
 =?utf-8?B?OHJHM1RJS2QrN1pQTlk0dUh2SXI4amNVOHJRUlpyQ1hhRWpURzdsTWxHemhB?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca8c342a-76f3-43e5-bdc1-08db25aac95b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 23:12:45.8145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7tgcpgTGq/DvNrSFwVp86zsSmak4r6L83IAxeHgB/kgSKDUwqTxGhfOhqz9zTnqyDtKzGefQFKho5uwQCyJqnTZbYEz4+SNLDnfuebjR6WA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7709
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/2023 3:30 PM, Jakub Kicinski wrote:
> Add basic documentation about NAPI. We can stop linking to the ancient
> doc on the LF wiki.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jesse.brandeburg@intel.com
> CC: anthony.l.nguyen@intel.com
> CC: corbet@lwn.net
> CC: linux-doc@vger.kernel.org
> ---
>   .../device_drivers/ethernet/intel/e100.rst    |   3 +-
>   .../device_drivers/ethernet/intel/i40e.rst    |   4 +-
>   .../device_drivers/ethernet/intel/ixgb.rst    |   4 +-

ice has an entry as well; we recently updated the (more?) ancient link 
to the ancient one :P

>   Documentation/networking/index.rst            |   1 +
>   Documentation/networking/napi.rst             | 231 ++++++++++++++++++
>   include/linux/netdevice.h                     |  13 +-
>   6 files changed, 244 insertions(+), 12 deletions(-)
>   create mode 100644 Documentation/networking/napi.rst

