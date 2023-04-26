Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97F56EF7C4
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbjDZPcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240523AbjDZPcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:32:09 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F61835A6
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682523128; x=1714059128;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=No/jmGqT1SPLOrT693rGkQX6ZiqFrZJ25hkUcJorcpk=;
  b=hs77VFpQ4/saRQvRS0OP5XxB+PyCCKKo4BYxsZcBWuZcWd1g/NjD8AB7
   JM5PrdgNkk3kugFAWGKkczkDxQyh4RoTYmm3lsFvU2nLmsKvT+Sz4xPHy
   rKDeYXshnGRv3k89Or3Vo+MPF8UK8UFauAJYbdbxLZdFWPfGsqklCw3RX
   Tcgi2ZiOeUaHsebXkGPhDz8HE0XAEkMveNikr8isiY27yKOWHVjbpE50i
   zV/BWgRWwz2QrNexQidqXedANhXEHpJ/vK+202pY7EkMegRVJRnkpY17b
   1hEVszkCrU1r5flFIK6HSwMeZGRCtRxHuKQkjpDdFyrqId70Gf56trVNW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="331370593"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="331370593"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 08:32:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="1023658213"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="1023658213"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 26 Apr 2023 08:32:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 08:32:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 08:32:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 08:32:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eAoTOf3BRCzqWzqb55R3svH4zLFpc7RV8wQny+LsLwPokZp42xTzN2CPm/fJ/IuB4VpQkg5NuF3/03xT77qIXHZhkiUnDVqdKIFyou3j5mYfCWbrJ6bj9jUXr1HikFsGjfZkqkcc3wGjdg8owddbOzKxXkfr0Yn+vGDUOfh/RUs5uuryq5o05zOqtC2upAb9uyGj024CZ2hW4jATfMUEfZ2SjXl49IqIk4tohd3pdH9ARKkQWFIm7NiBK6cD5OEjeISt7Pva5KEBzOtDNVzWfA5lZfhVHcKzxoNMhK+izQuV3P9faTsGmQzuPRMvrkQaQdc20ZoyllZY+Ft9hjGUlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uh/rY0Q+n90P/m7007qfK153ZnaWrxEBk+TKcfMFLLI=;
 b=AQH24oMK7d3ALxfRoM7VmDY10WCiK6EOnedEoCLU88mJguYeXcFooHPn07P/UqWIgafi1VzNn40drI4TsrKRnLAZ2qxBt8zVUwRmIEBW97KB2vDwfRGQsOKp9RdTdIFPD0xPbT9+Rk8chXKmTXuBhPLU0XxkYEylUVP/HEQzcM18F9rouRvpq7KCRE4yYmc8sfl/M2Yenl9loRJsprJpakr2c7mJxzID0g9pwkDVPRoWAU0RtV0uGsLIYdFMAo5UIb9M/EXGA30TxhYODsxqlO0jgl8AMEyPy82tPce17vx5qAdEVIjxYEyaSu+GiusKX1XVSVSqCbszNaxQ0S/SNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH8PR11MB7072.namprd11.prod.outlook.com (2603:10b6:510:214::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 15:32:02 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 15:32:02 +0000
Message-ID: <e72018ab-cf1f-f50e-b43a-d50068ef5ff2@intel.com>
Date:   Wed, 26 Apr 2023 17:31:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 07/12] ice: Accept LAG netdevs in bridge offloads
Content-Language: en-US
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-8-wojciech.drewek@intel.com>
 <ee3d3162-bba6-d65b-92d4-e44930b9110b@intel.com>
 <MW4PR11MB5776258BAC908BD75A739DF2FD659@MW4PR11MB5776.namprd11.prod.outlook.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <MW4PR11MB5776258BAC908BD75A739DF2FD659@MW4PR11MB5776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0039.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH8PR11MB7072:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d14034e-9168-42df-2c3f-08db466b61db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bzNTGHuR+fYCCRQ2JDD/ijuCDdaphcGZDfnXK5z0eIEa45+3kUrtfqu260SgmTTwqg8Y+Nt7MgXa8ra+oUEYS1CHLTLkf5c1J65zAfX4NvdYCvfzrXstO4df/01Sdg08LzNDS/uhxAVs3kpIH3rxZR49Trce2Q/fJpHDWB67COCgNPSlfuQPeJqyhB+rs9AX9D52xhnSFzIZONDBizgYwqy0H7eUylwO6hJ9LiSDeKc3aVGsR3bH8YMRWuzc8xzEGYxGx7boIcEcNUpmdjwqIpYl2fOs3YT1cQh1IO1MWta0mVhVuEop8BFp47HWkSL5R/kY7qnp3DxpTR23sz1oNiRRB6xK2jsErT4OiCO67HY6ZOZfRl+gPwp3h+nUTvok8BIQRbmThingyyhgAXZ6l6+KdBANoQRh3GZutaPa/R6pfcMP7hUwxRAA1pFpLZtlYrCJ1SgZaR3svWMmBHJ4rpFtH2+mB+6eHMlerlJeGKIi/KRZy0AdN3onOelspyYW9WrG7qYQtPErlVhw3CkQ0J41Q+OTPviR7+8ShnjbF+Sjgrec5KFWipHk+2AW8cRk9hzV265HbJe+BZNM5x1X72ECGGg93O0qcPaXFmI2wAKJypYnRENWAiQLVNdJhEuJZGiIOZgsx4m77NM9SPe0Sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(36756003)(86362001)(31696002)(54906003)(478600001)(37006003)(6666004)(6486002)(8936002)(38100700002)(6862004)(8676002)(41300700001)(66556008)(66946007)(82960400001)(6636002)(316002)(2616005)(4326008)(83380400001)(186003)(66476007)(31686004)(26005)(6512007)(6506007)(53546011)(2906002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHArM1lsa2hnNGUzWUVPV1pGS3ByRnJPZnNKeVVzL2hlVmFlTGNYODRnUzRN?=
 =?utf-8?B?c3lBWHl4eVl5alFoVHVWUVNqa0pLVm1ibVJuN29yRWJCN1NKQ1NHc0k5dkND?=
 =?utf-8?B?UEsxSWtVOUQ0c2E3cHlJYWdvdGl6dVZuRGpNOFEvV0tiUmZuT2ppNHFqNndK?=
 =?utf-8?B?TUorT2VpbFZzNkZyeGVOcDdzRWM0NGozcUVVdDBxS1Zra2RhZ005ejB6dlY3?=
 =?utf-8?B?S2VJSWhQVTdlakltR2pISmlLTFBqWlQ4b1U4S2pWMnZhSzBWRUZDUHRhU2c0?=
 =?utf-8?B?UnRwV2hiOGduQ2tSSm0zSUQvRWtoUnFQemZxYzM5MGQ0aUFLcFJSV056TTVs?=
 =?utf-8?B?MjdIODFhNjhVVUVJN3RxNldoUExGbHAranBxUW9CWG9rSksxd04xalNXTyt4?=
 =?utf-8?B?bHJBbXpNYTNzNVJVa0p6Qm1hZDA1cTYwdmpqK3lQakNBTlAwY1V2alV6cmNx?=
 =?utf-8?B?T25ZYmoyWUg0U2hFNWxpaUYvbXBEWDc1NGJIdmdkU1o0d21ZcVlnRldBVHdt?=
 =?utf-8?B?NW5Za3hVeWt0VElHVUlKUFQ1R3RZT2UxWkVzcG5MazhoSnl6MnRkTjhNeGtX?=
 =?utf-8?B?c1VpSFowejV0SEVXYko1ZFVOdVRPeGk5SkIzOWhTTStsd0hvK3FwazArSWcy?=
 =?utf-8?B?aWVvTkRGTGRldkRHaGJ1S0tTK2Y1Y0t5RGpIbzJ4WWIxOEd6ZWNsSi9CYlpr?=
 =?utf-8?B?bmZjYXBLMHFOQzBsTXNTbWJOY1N0SVVtL3NkeW15azJkMTE5QkxIUUJDYUMr?=
 =?utf-8?B?Q01Zd2NRcFhjd0JSeG1XT2tPWmNYbW5vaU5BaEF4ckpyM0pnZmZ4cVF4aDBE?=
 =?utf-8?B?dlM2UEM5cklUWDdxRnJRQTgwRDFGMnFaL1lKbzNmL0pJdEc4Y0M1UmtBN2py?=
 =?utf-8?B?RTJQcXB0Y093TXVGRzVCU0d3SzVtVFU4amZXMm9kRDNIajlOTjJTRVV4ZFVr?=
 =?utf-8?B?dlk5Q1Y4REdzeU9FTVFnVmU2L2xockROR0pYSHFyQkJEbEY5MVZoSVhBVmpy?=
 =?utf-8?B?RVpjdlBJQWw3amVlNTlEY0xFNDA1RmRJUjR1MXE1dVBaN1lsQk1KbG5mR3lx?=
 =?utf-8?B?L2JnWldUS1dnWmhsSDZzZmNKOGdCVFltckN4Y1hmRUQzNnpXY1MzWU1HYnJR?=
 =?utf-8?B?REhXTTFpdUFqRkV5aG5aV2crTWVoRW9YSzlwQS9oWHBIcHBqN3VJRnJKM3Mx?=
 =?utf-8?B?UEgwejh3clBhY09iTVZuSW5QUDhGNFNad3UrMXFndWtXUEVZcjZzRldZK2xZ?=
 =?utf-8?B?MzY4ekFsem1YaUc2VzI2MVdmQlRYZnhxRkdzVmpoeFFFbWg3TWNIL1RzMGlk?=
 =?utf-8?B?YlRsVXArS3BHUlFwUWVlc2l3bVBFdFdQZitscjZkTGdOcWFIUVA4Rm5STHJM?=
 =?utf-8?B?d01tdy9MckU5Q0Q1NEJGMEtTbFlDOUFkUUR2NE9iZmpZQjc3MXFqanZsL1VI?=
 =?utf-8?B?MGFkSXd6cU1BTDlFd0ZjdHNEeXBiNVlybXlaODJUcUUxRSs1K3VxdGVscllY?=
 =?utf-8?B?NUlhK0hHa1J4d3hEUDhjUmZkSmxoeXlGd2l4WXR1QzkwY3BBQTI3aUNkZ3d3?=
 =?utf-8?B?TTlmL0QxNHNXWWlGZ0xGTWg0ZEp1dmlvK3hUelhPZ2JOeUtScmE0Ymw4Ym9E?=
 =?utf-8?B?ZnEvMWVrWnNnV2M5c0dTc1VuQTIrckd0ekpCUWpOU21xK1AxNEdMNnBQc3ZW?=
 =?utf-8?B?WXJ6Nm10U3huYy9WTkU3elRtamx5c3FoQ3dpUGZSNC8rTDhveVl2SFpBakJm?=
 =?utf-8?B?WGZRamtWVVZWc3dMK1JJUXorUW9pQkVZelRGb2JQSXUwaExaZUxGc2lPeXJz?=
 =?utf-8?B?S1phazNQR3Q0QzhzRkNFcGQvT1BBOUxNeGpaWXlrbHVRMkdlR2RWWXpTc1li?=
 =?utf-8?B?NVRNaDZqR1ovRVVxY0VhMW1LUVBoNzl3NUlpT2I0WE1tUllQTkZYRGpOb0Nl?=
 =?utf-8?B?dlNtRHE1ZVNTMTc5VWdOTlBXZVZ5bEl2RGdIdDc4emZNeWZmVU9XYm14bnRq?=
 =?utf-8?B?TDdaaUhZcUhNbEZQUVdEcEkyK2RhUHplb0VTUlN4OFFMWWNyRjNTZElLT2Yz?=
 =?utf-8?B?MWNLWExWSllKZjBNb1lPNFJZeVlqK2t6N1cwdCtJcitSdGRwN2tTZkJEdTJ4?=
 =?utf-8?B?Y3gvQU5ZOFMvSU51dGNkNC9UcytZM0RmMjh5a2tRTFo3VDB6bkQzNkVFcDNi?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d14034e-9168-42df-2c3f-08db466b61db
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 15:32:02.2886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epnHgn7gwoNnRB8xZpGs9GwxqNseHii4pnAJw0TV/OqDMZ91caV0ZcMpLX4cb6T8odVDct+Njxkp56MwAzwSD42GzVkm+EBHJLsHEdoo7Cs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7072
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Wed, 26 Apr 2023 13:31:17 +0200

> 
> 
>> -----Original Message-----
>> From: Lobakin, Aleksander <aleksander.lobakin@intel.com>
>> Sent: piątek, 21 kwietnia 2023 16:40
>> To: Drewek, Wojciech <wojciech.drewek@intel.com>
>> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Ertman, David M <david.m.ertman@intel.com>;
>> michal.swiatkowski@linux.intel.com; marcin.szycik@linux.intel.com; Chmielewski, Pawel <pawel.chmielewski@intel.com>;
>> Samudrala, Sridhar <sridhar.samudrala@intel.com>
>> Subject: Re: [PATCH net-next 07/12] ice: Accept LAG netdevs in bridge offloads
>>
>> From: Wojciech Drewek <wojciech.drewek@intel.com>
>> Date: Mon, 17 Apr 2023 11:34:07 +0200
>>
>>> Allow LAG interfaces to be used in bridge offload using
>>> netif_is_lag_master. In this case, search for ice netdev in
>>> the list of LAG's lower devices.
>>>
>>> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
>>> ---
>>>  .../net/ethernet/intel/ice/ice_eswitch_br.c   | 40 ++++++++++++++++---
>>>  1 file changed, 35 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
>>> index 82b5eb2020cd..49381e4bf62a 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
>>> +++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
>>> @@ -15,8 +15,21 @@ static const struct rhashtable_params ice_fdb_ht_params = {
>>>
>>>  static bool ice_eswitch_br_is_dev_valid(const struct net_device *dev)
>>>  {
>>> -	/* Accept only PF netdev and PRs */
>>> -	return ice_is_port_repr_netdev(dev) || netif_is_ice(dev);
>>> +	/* Accept only PF netdev, PRs and LAG */
>>> +	return ice_is_port_repr_netdev(dev) || netif_is_ice(dev) ||
>>> +		netif_is_lag_master(dev);
>>
>> Nit: usually we align to `return` (7 spaces), not with one tab:
>>
>> 	return ice_is_port_repr_netdev(dev) || netif_is_ice(dev) ||
>> 	       netif_is_lag_master(dev);
> 
> I've seen examples of both so either way is ok I think

Correct, that's more of my personal :D Or maybe I've seen a couple times
that either checkpatch or something else complained on the second line
being not aligned to the first one with `return`.

[...]

Thanks,
Olek
