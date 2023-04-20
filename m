Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CB76E9AB4
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjDTR1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDTR1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:27:04 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D4D173A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682011623; x=1713547623;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mP9MVeBmE9eeeuFM6/urSxryPkJQ4AhJBZfRERyvalg=;
  b=PturhDZCF5Id6L+NReL+e4eaf+d9T0WGytNLbSWDNM38FTPqEcf689MO
   qlafC5BSiv2yQYu+aaI0u75dkAoptjg7UhOWchjNsiILSFZxKh+34AZpG
   gonoICl8a4Xk7Lx6AJnM2scORqIqcxUPR/cIhEsKFutb9EFgxGet5AHKh
   T1L547srr12Bu8RJSf4NBEveu9kMUOW8XUKiWYmZaixS5HX1IKlhndyRq
   Jze7ExH/uBGLvBpsMB1pdouDTvUFdw8QDEFPZL2sTEkDT4hoWLmKlsRzW
   iZMnqqHsY8gGTgHNOJtaSeIu0DKHWxQg3yGJt0uRDrQen+RAVLcVf7ubL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="334654274"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="334654274"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 09:55:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="669415024"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="669415024"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 20 Apr 2023 09:55:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 09:55:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 09:55:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 09:55:01 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 09:55:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGvtF+DFNvmTczB2eGrQXV1uLMiuk3iZhRzVd4A2iZEHQCOlYoJ8f9w4P2NSGEWICKAiGIKeYF86yL+oB+WBVMqYuuzeBLEA1YfuzHLMU08kVg9mR47Ogmjqxr/yRuAtHC1wX7omIOsL3cnNfkupaYfknMbERnRBEZH3NHGQ1IC0wtdS+TZ5ZV+wy1/4OOwImJ83hrF9jCX8hnW2Ow/wBuz17zboby1HkJQA03ug3MVY1vuiM5CJYIPPqOiSyQEBfN6n6iT6uKGZwgVldAWMV6bPYHD7PtfQw2Tb9s/9RibAAsX895ZGsPK+RDtyFx0oy/vhdSNBeLo2xAfi0fYEag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wspFJxeP+oNQvO5+HOkWNhkT5M7HzoAaidNspzb0WaY=;
 b=KEICfG+fH4giVjz1veOPWCtlCjcObkveWymq7mc07Uj2aHoifCflqkFRhi/cdIrjRkhRLvonqy2QIGCCxLeqFYg/+qIL5KqbjKZEWmqzm9UbZ0Q3X055pMegmX8dOyP55qBGJvrZnHpRH/hZIQVV+bnHgDSmPZspbeBG0zE5Sb9ClG0NXRxLDbqS0iFO0JYYGPLKtdGa295oMVQdI+7bX6jhhZkKUtYMFv45PkRyNMg6FvLbeMsjH+ndAvxMDK+CY7fKUFhmWAbuNlTEd0D7wJwNfIWCMDWtNZM+Yj/5XE1r0Kc9/FgQ5zF7WQZFdb/4rP722EPV/lKw43uflj/+5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB6094.namprd11.prod.outlook.com (2603:10b6:8:ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 16:54:59 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 16:54:59 +0000
Message-ID: <db91e3b3-5282-7172-a9e5-8a0425bbc7d5@intel.com>
Date:   Thu, 20 Apr 2023 18:53:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 04/12] ice: Implement basic eswitch bridge setup
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
 <20230417093412.12161-5-wojciech.drewek@intel.com>
 <4a293c46-f112-e985-f9ad-19a41dd64f01@intel.com>
 <MW4PR11MB5776C7DDDB91DD98A960AD20FD639@MW4PR11MB5776.namprd11.prod.outlook.com>
 <MW4PR11MB5776C243E4904E9A15E014A6FD639@MW4PR11MB5776.namprd11.prod.outlook.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <MW4PR11MB5776C243E4904E9A15E014A6FD639@MW4PR11MB5776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB6094:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d195f64-edb2-4fdf-acb7-08db41bff9ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y34pMyJE+rE261XD4h9yUVjJ6e7SZZ/X6jMvXlI6vNgpdYPBcGzhC7OYrOuXIQTfXNJ1j6UatqxoUfQE4OFuRGxtOaIqFfPV1QuBOgLskdtsB8Bqc30QJQnU5bM+E41eFok38YdpgdbivrwNZlpCG9o9rG3pYYBEKFItM5C1UCVt/W3xeIDxLGNLRDpZiN+rCxdvqqnj7nEfLfgYC79Dkl1YZKtTVdUpbqDl+BmCuTgVjJyv9Vp2E9runE6n++b5kNsYf8DGfNJiElSWQuHgdUgprdX9wJqGssJ6ptl3bYbbw9T9Toxe1UzvqRfDBLFlmPLAvZdPOBT2j+70CueamxS8P9bK+ucNHxW5ZhSGTsUtmdCxGI523Y95rKFLqewhP0f/Fdj25VUpm2/X+t3i+FpjEC6OtN5SmOLy1tuHMIvLANkFJdsyvkK8rezrV8RzCAp/yNuDkRe0U2EoWs1qCqPwbt2y5fmAL5kQ0Aw6a8QUx0xxG0nk+f3L67o5LS3zBd6QcoyC9nwV4lo6mGcszl9hqE/RBvfm2lkyngXq79GzLOVmwmi/snNXeOQIkmU6sfYb7wkOtnxOtVj8I4G9kSBG8ZOAdm0EDDOOwn19hPKyNGFkAOjZEOvP31Ix2itgpDiPaBeRa72K9qcwlbgYOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(31696002)(36756003)(38100700002)(6506007)(26005)(86362001)(6512007)(186003)(2906002)(53546011)(83380400001)(2616005)(5660300002)(31686004)(6486002)(8676002)(6862004)(37006003)(8936002)(478600001)(4326008)(54906003)(6666004)(82960400001)(41300700001)(316002)(66946007)(66556008)(6636002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NS9tb08yUTQxVWlGcW56VnNhUEtQSldYK0JmYzFmeUN1R0dnNVFCYXd3Tjdr?=
 =?utf-8?B?QUdZOFZEalBBMlNHMEJDK3dpZWhZOUxFS05qQWJpQVFVSTFOZEpxV2lWbThw?=
 =?utf-8?B?eXZJSVJjOFNkQ3M0SDBEWFpQRzVjV3BGdmFNcnV0MzkyTzlScG1mcVNGOHZZ?=
 =?utf-8?B?VlZQdm9HZjBnMU1WTzlJNnpKeU9ZZCtzcTlXOFlPTTZPdk1sdzNiRnZrSVo1?=
 =?utf-8?B?ZWxIWnBkQjZIeHJnSTQvVVc2RXNKUnYwSFdRRllHbG9SdGtSRWNnZnBaaXRC?=
 =?utf-8?B?VWJycVovNVg3d3ZuYU93WkFFcG5xTUhvc3JqYnRaU2VKNHlkeFJHNWRGb0Y5?=
 =?utf-8?B?UzF3UkxQd3FHY2Q1Z2daWU4ySmZrT2pibzBIZkU5ZGloRVJrVERubCt5QjFB?=
 =?utf-8?B?dmNNdks0LzdoUjFISFdqWkxFSXdWdXZrekxuQVhNMm8xVUkzOVdDQkliSjZs?=
 =?utf-8?B?Q2Q5dEFHc1J1Sk01bHRJelArUVMwU1ljeS92T0tLWlNXb3h3QzBjcnFvcm9V?=
 =?utf-8?B?TlNpeWpmMmdJUzU4dUtIQmF0SitSZ2ZDZ2hvTVFXQ0xhMXhLUWNBc1NwZ0ZW?=
 =?utf-8?B?OEZ5WFFNZk9EWHdpenFLYVE0TzdTYkFFZEVOZThTY1lPaEVnSDFrVGJaWTlL?=
 =?utf-8?B?S2tHQmxFRW81UDVUL2NRZUNDNGU0VFhNTzB1QXN6ano3ZkhuVDllQkwzUnho?=
 =?utf-8?B?d0poSVhRY0tnV1BrZEZ5d3I1S0lzcjRrSHNYVHY0SmlxdEhxOFBJYWpPK0dy?=
 =?utf-8?B?d255Ti9xZTE4WklLUFFqUjVpQ1oxMmJZdE1zd0xmbmE3bXN3dEhUdGZyRXhG?=
 =?utf-8?B?aHg4MTNocjl6M3pnb2FYUUgvK2dXcTQ3YlJHR0JrdXRIb05naUdTSGFHOHR5?=
 =?utf-8?B?TnN0OFc0SUJldmNMTUozdDR2VElnbmZ1bmJleGdJenJWakh0dkRzTVZSanBz?=
 =?utf-8?B?UXJKMUkzaE9OY0lyQUl2aGJJRmtSMUtMT3crempBVzVUNTdveEtibUVtNGdX?=
 =?utf-8?B?VldHK0VCVHJCRjFoSUFtdzF2d1FzeVNyV0JseWpwTkwrVXdVOEdjNVllVTE1?=
 =?utf-8?B?bTJndU1JOVlKWjM5SU1HS3FrTzF5NmZENmxIYzIwTkFjVmtSbFFnZ3FreElW?=
 =?utf-8?B?a29GNGZwdFdwUjlQNFhVL2NhWmlEVWFsWHp3QVRqRTQ2TEZZeUlmY1pJU0o0?=
 =?utf-8?B?bitZOExkTll2QkowVnFGZ2t1TVc5WG9JamNpUlVDZXZ6dGxzMm1XbE1weCsv?=
 =?utf-8?B?cGdHaGEycW9vd2t6alJJOGllaUlra1A4aTltdmZrcmpTVU9qRmYxNitONllM?=
 =?utf-8?B?U3N4S0Q4d0E1bkg3L0VRSGxoMzVlSElLc2dRdVdrUDRiMjJRNTRtczN6NlBI?=
 =?utf-8?B?Tnc2YmxJT2N6RU0yMDMyNEZreStEb2kwc05WcXB0ZjZ1QWhxREsxS2pFeG5G?=
 =?utf-8?B?cnQwMTlzVGplYjJYdlRDbUE3YTBxbC8wZllvcys2WUxHSGlRSjFHUWthMm1x?=
 =?utf-8?B?aEk4RnAyK1djTUNiSDd6N1d5SWxEQ3B5UktRUGlsWEtuQTA0dmlncXBVTDNS?=
 =?utf-8?B?dW9wdjIrSHE3VnBySlNreWQ3ck1yaFFKUWZiRGhqQnRZUEFBcUdkT0VQTHhj?=
 =?utf-8?B?am1LUm1yZUIzekxNOFRiY28yOVRNOTVCeUlWSS9BbzRLVWxlOHovSENwTCtz?=
 =?utf-8?B?TlduR3hQTGc4Z3o4OGVuOU53UGpCUm1PV1VIRzJSZ2ZDYmE4WmhKWWQ4Ukps?=
 =?utf-8?B?Y3NLYk5ScUk4UWR6cXI4RStqTGE2WE9BUThGajE1VFVNa2RLK2tJWktjdktK?=
 =?utf-8?B?dncvWmRYWXJBdWdDTGlHTy9jV25DUTlVMUZ5eE14elROeE9MeGY4MTVPaWJl?=
 =?utf-8?B?c3ZySjRuMzM5eTRkZUdROXVNNER0d1kvaDFldEUrVVJza2U5MGZSOXdxRXY4?=
 =?utf-8?B?MnNEL25pMUhYMXg2UzBBSStEOEhzM0pEOFR2RGQvU2hPN3MzUDFSOXkwK0Ez?=
 =?utf-8?B?QW4vQ1BFdEJES3VWODJ1MEMxSzZQNFdyOFY3bHNNM2dpOFM4S2FnYm9SUVJX?=
 =?utf-8?B?cFlUL21rYWxFTnJqZmNRT3NvZmJOUnBoMGtYRURyWStsbTVKcFhHd3pmLzFm?=
 =?utf-8?B?NjY1TnJXeXBQYjNSWFlSeUNtVG9WWU96bFg4REVYTEZ2S2txUURDcVcvMkpS?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d195f64-edb2-4fdf-acb7-08db41bff9ce
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 16:54:59.1700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eUQM7guvoiX9DZgNFAHc/gMn+6jiUAdt9ecgVokwzTXrzEzILHRfkZK+pAvyPmptAOlpqZLkKzwC29bM0h+rLPaiX5FCejXlRpCpw37SBHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6094
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Thu, 20 Apr 2023 12:46:31 +0200

> 
> 
>> -----Original Message-----
>> From: Drewek, Wojciech
>> Sent: czwartek, 20 kwietnia 2023 11:54
>> To: Lobakin, Aleksander <aleksander.lobakin@intel.com>
>> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Ertman, David M <david.m.ertman@intel.com>;
>> michal.swiatkowski@linux.intel.com; marcin.szycik@linux.intel.com; Chmielewski, Pawel <pawel.chmielewski@intel.com>;
>> Samudrala, Sridhar <sridhar.samudrala@intel.com>
>> Subject: RE: [PATCH net-next 04/12] ice: Implement basic eswitch bridge setup
>>
>> Thanks for review Olek!
>>
>> Most of the comments sound reasonable to me (and I will include them) with some exceptions.

[...]

>>>> +static struct ice_esw_br_port *
>>>> +ice_eswitch_br_netdev_to_port(struct net_device *dev)
>>>
>>> Also const?
> 
> This function changes a bit in "ice: Accept LAG netdevs in bridge offloads"
> With the changes introduced in this commit, I think that @dev as constant is not a good option.
> 
>>>
>>>> +{
>>>> +	if (ice_is_port_repr_netdev(dev)) {
>>>> +		struct ice_repr *repr = ice_netdev_to_repr(dev);
>>>> +
>>>> +		return repr->br_port;
>>>> +	} else if (netif_is_ice(dev)) {
>>>> +		struct ice_pf *pf = ice_netdev_to_pf(dev);
>>>
>>> Both @repr and @pf can also be const :p
> 
> Repr makes sense to me, the second part will change later and I think that
> there is no point in making it const

+ for both, not a problem, esp. given that the subsequent patches
require them to be non-constant.

> 
>>>
>>>> +
>>>> +		return pf->br_port;
>>>> +	}
>>>> +
>>>> +	return NULL;
>>>> +}
[...]

Thanks,
Olek
