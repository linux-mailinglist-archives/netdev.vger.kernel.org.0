Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449D76E9AAA
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjDTRZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbjDTRZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:25:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F4E1FE3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682011543; x=1713547543;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mcunzA1v/2Vr5BJE9cIVt/zoZaPDrtHRP9xhzWJY6ao=;
  b=d4pozu8DU1Y4ghSXZwioZHjCHsPUzBZqpmCi1N1bta94nzvFn0kQtxC1
   4/CdBKAeEN8NEkM6j8xpx1Lf6g/ez2fdDCzF1Bcn3hRTFcqAMDlmO7jnr
   oOOMx/AS7F8sGDNL3mPLLpyr23inQIa/C5Nwv2ere6eCW+cglH6fJ/1ao
   YCl4gDGJF0hfuOhMUoicSJlyLEw7IpBBgqalXzkMpwF7OZfAN5HbIF8nm
   QlTSPYUnvIwH/rQ1bhUrFslIeHn3EaAqeOMZriMovkc7GGFATUTqIfRHY
   vOe7Iu0xe9mhnKwOzOZ9hjqPaUTkTam4tN5JtBigfYiVw/fJmR8vU5edn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="347684726"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="347684726"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 10:01:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="835819511"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="835819511"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 20 Apr 2023 10:01:00 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 10:01:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 10:01:00 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 10:00:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A548iijYFXeE0jonEz1ia5s36wNcC0hZmYriZZ0NT5EJ5fpc+JUsFqiCwnLMidmVgXJn6AlqlvIEeIZnKS5yVOwwJ7Uo2F5LlhppZahkclpuXiHdt5X2GW/nPiZt7nAqzGAqoBbjP6YbyF8sNMzvK0yI3qbza9T2chAYO6Adsttu5dDz11sSwkL1jNP5Own3EYT4iHJIHXtbc90amySrGaV6dzGnoLsComSaBch/HbLtZrD3ioBftaaUYxAEx0zCkEsasSWp7qfKG/NRImtUOvaLK05hg6cgO3Dxitxm2H7ETcQB3Rqnup/TnKs5iIAW8frvVZ6B8/d1zcYnVxa2sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lah6vilca9WJaeiXqhJnRS31ThWS6xnUHoqXYIlS+c4=;
 b=FBkNXVtYaOzMUhglteUvfjWQ/bhn4cuwnK4HWKNA0syWXhBv1IoTHW/7J8e77CbvznplRKb59dQt4q5YVaVi/gVjIlZgd/p8+7Mcxdv+6en3XtP9CW8Bm8YF8bHSkkKJBfewEd3+kpsMQoe0UEPXg7Tm6AvgeV1V+EmqF1VR75GWU4WP6GbQcaXE8h1JBiWLgSZfxs69ffZ4T7kytzhl7zpFTVpMtRwRiH3pz4SRf3q0i3rfiAFxxYnVh9vLF/07XBH1ndBfFzt90x4fcw4AsTWt5dVv3gYQ+K7+FdjpWinwWCA37kvsED4mMlmyjsIFe+WsqYeJSVIyyeIlEyWVqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BN9PR11MB5372.namprd11.prod.outlook.com (2603:10b6:408:105::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 17:00:57 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 17:00:57 +0000
Message-ID: <92c09efa-7e47-f580-4f60-19f9bb0f045d@intel.com>
Date:   Thu, 20 Apr 2023 18:59:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 05/12] ice: Switchdev FDB events support
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
 <20230417093412.12161-6-wojciech.drewek@intel.com>
 <10045539-91eb-cdb1-0499-1c478d87870e@intel.com>
 <MW4PR11MB57760F836B7714BC22A26FC7FD639@MW4PR11MB5776.namprd11.prod.outlook.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <MW4PR11MB57760F836B7714BC22A26FC7FD639@MW4PR11MB5776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0037.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BN9PR11MB5372:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e19919e-4cd4-476e-c195-08db41c0cf1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RvNiArn1HPaFVK+gE+Gj04j7ttyi/g3tcAGwgOhpCyLO3znaemofm8XA98e4ccHbWG56HXowXBdVm4r0/a0PFtHZWKXtoxnC7ZPuYtyVSTQHXVJhwI8tigmjOxAO3+3pWiWMdpEWjbMmZVVzM6s7F6RJmt74UAU6eerH7kXTSiCU/Tw8W9JVW+gmX+ahRYJgO5ta2coJq4k1mLsYV3DxXUKji55aExRHQdTjt5H+sjwDfG3ZULw7kUfTdK8kgs2LoYe+mI6buQWy3z5jjqkbjxEHOIgdqYNGpFRRwEIqBNUkMK2QKlE+7JR8oo9iDU3EKgEWujwQP4fDxXYOGVpo1mp2cSFQ28tSpjt9YuvZxBj9kPVl5YYneQwEKzEtyxnAt5UjnVpY9TKOjvUbPMxGOI2Uy+fRDUlMAm2gz21bYI0fwuIdARxDHQdFBlhI3JJNWSGBXt7TNtt3Xn6L5PFaShnJrv4XIeYI7tpDAvOhBuRVVUBZptCO2Lm1A1Z0fGNNQKirvKyH8evXWYlNtUtO7E/PUAiwYw+bhXM6RnESYwFd2OBLMHSEdFT09PoXMnoQSyNQbW3507fCxBGm+yUHmgZx3qhKm50Z8d7ce7wqt5AAIrog5Xa9mm/g0VcrG7a0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199021)(2906002)(8936002)(38100700002)(6862004)(8676002)(5660300002)(36756003)(86362001)(31696002)(6506007)(6486002)(6666004)(26005)(6512007)(966005)(6636002)(54906003)(478600001)(2616005)(31686004)(83380400001)(53546011)(186003)(316002)(37006003)(4326008)(66556008)(82960400001)(66476007)(66946007)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0VQeEUvKzdZZnN0L3RvSXdadVN3NVRQWDZhYmdpcHlhdERER2ZqTHVVSzUy?=
 =?utf-8?B?NW1jeTBId1VmdWtNL3Zkc2JNNE9rRHNNOUxITEFiNWVyQ2t1L3hlQUxTb0tt?=
 =?utf-8?B?d2wzNDlsN2tRUGtSM2lZN2N6UmdMalpzb085S1cxMDFyMUI1anF5eUYrOXZX?=
 =?utf-8?B?aGtzd1NwUWVVQXEwU1duQ0xJUDhWaHU0Tk94eHhuUmlBSERWa3BPeGNTMEdX?=
 =?utf-8?B?VWYxQ0I0T280Yi8xMk9DR29RL2FJUmprcHpKSnhBUDFNTlVORjV0Z2ZLaXpY?=
 =?utf-8?B?b1VIK0FWUTYvd1d4cmNvMExtNFdHVitmRlJFOE5LVFVZTGV0Lys3d2NmUS95?=
 =?utf-8?B?QjkxTndzdGcxOFNCcjQvVmVBQXYzb25DUncvUmJ2ZnFvRFhEN2xxamszb3FS?=
 =?utf-8?B?Tmh5bmJmbGVCQ2J2MzRXT2ZJalUrcE1NM0dHSW8xTDBvQ09HQXBVSmJJMCt1?=
 =?utf-8?B?SmZzTkJCamN5OFVVZXNDTmNtTExBVXNlMm5pWTkvL0JEN1lTT0FWbXJrUU1E?=
 =?utf-8?B?NlVFZ1c3MnBjUDNQMngwREJKU3diSXFCdU51VUxzMG1PbGhVdzV0cTBYUTZv?=
 =?utf-8?B?cjFmVE5uVG9iY2phcmpVeHJqQjBITjBWN0QzZ1NKQWo0LzY3ay9QSHRxREZH?=
 =?utf-8?B?cERCK2Nhc0VhcEd3YmhHa0hGMXgvY1o5WVBmdEYrRGM5MzlyanpORm5ML0ts?=
 =?utf-8?B?U3BzSzF5OW51WThjSE1ldnRITkt0OXRhSXhrUzVUb0tJSFFqaVdwTlhqMGJ4?=
 =?utf-8?B?OUpxZ2crV0NqdzZRV0NBakpic0hja1JZSEh5Q3NvWWNrZDRmV3l4VWZlSzlw?=
 =?utf-8?B?dG1jY2hkKzlDWG1sNGtheEFRYWF2c3FMQ0NtSUczTElDenNjd1FDTXFmOVYz?=
 =?utf-8?B?cUwrNHVmTm1MaGxQNHc5c2JXRnVHTldlYjBmaHIwT0ZsZVExRExDSy85eHZU?=
 =?utf-8?B?QUt4Z3ZJR1JzUTZmcjJRei9rS0lsTDh2T3JwS3hRc0xrNFBPZkJBekRjU3po?=
 =?utf-8?B?eFR2V2c0MzZnYTRsbmwwWDFjdVNjSkx1TWFYUVpsMXRCWktxVDB2cEQyK1N1?=
 =?utf-8?B?UTRJL0dUMmJLeUUrY1FUekhMcEpEd3JhMTV2ejd6MVV4Y3dzRVdDZW5pR2d5?=
 =?utf-8?B?L1ovckxRUjd5N0tDU0ladkpDalQ4dUFTUXFtbnp3Sklja3hEZktuUjhBajdP?=
 =?utf-8?B?enJBMTFSNkJIOEVxLzJEdWUyOTVVZXJ4OHBQU0NOZitSU2xpdlNlaUNTTTBz?=
 =?utf-8?B?YUo3aDBMWDI0SDQwU0wrNlZWVHFaaCtRN24xT1JuYmN4eWl6SDdhQkpTVDMy?=
 =?utf-8?B?Q2Voc05HNWEvNnVRYWhvTTZFS2ZBY2swQTFIZDhuUUcwMjkwUWdXZ0psSU81?=
 =?utf-8?B?bUM4OE42dHZNVTd3K3JUMjM1MG85N3pQdzlCaFN1ZnNQMEdvbWcvNGNuTmRj?=
 =?utf-8?B?S1R3VUNjWVF6VEZja0hlZEJRam5FVjVjbmh1cWlJUEFwVm8yZmxPc2paWjNV?=
 =?utf-8?B?eUJkcUxrWW5uZzE1SXM0RW1vRDZEOVJDUnhSSzNSakRGTjYxdlpnTWhWTm9U?=
 =?utf-8?B?M0J0MWlpUnRJcTJRM2FJajFHYmdmS01nY2FDdU10UUNHNndlV0o1RThRZDJy?=
 =?utf-8?B?NmdsamJOMUNJUWMwL2VWSTZnbXQvUVFsVUVPeFJrU2h6Z1RLZEdLRWpMYXkv?=
 =?utf-8?B?VGM3ZHJUUWFLc3BNcGN6YmpZNHFCMEpGeFBseUlEV1N1cHUvQjZhaS9ydVNk?=
 =?utf-8?B?ZnNmTUhoYjQzQ1JTZU1yaWwzbjgyOFdMWXN2YzN0QmRmdUR4d2dURzQ3UHBS?=
 =?utf-8?B?RGh3MjM5dGs3Q1oyK3hBQ0F3SkZmKzFSRXFiSllsOTZCV0R2b1hCczc4YlQ4?=
 =?utf-8?B?Z1JXT1crbktTdnVyeFg4b2EwMVBXUU45NjZ5cmYwOUJLd1M1N3lyTjBqRWlk?=
 =?utf-8?B?Zm4ralUvbWc5YVE0bVFGbVM1cVVrSDBQNzZQdk1pSUprWXZYYStVY2JDa1dZ?=
 =?utf-8?B?eGw1UUFZRE5QMEN6dWhaT2daOWZvMHlMU25Yd2ltRTUwanIzZmpGL2hyTFRD?=
 =?utf-8?B?V1UyQ2N5SmtueEw3K3BIUXhJc2YrWU1VVDV1bHdsS0FyV2FqUGhCOTErWVpG?=
 =?utf-8?B?dXFEeU1jSURpbTBmcXdYVGFVNG5uZlRmSmxhNkE3WjJRQytXNm1BT01hbW9s?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e19919e-4cd4-476e-c195-08db41c0cf1e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 17:00:57.2415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCLqHyOuQR9mqFs5MUgBIcfh//GjQzx6Mrl1fwC18E2O4ZdwR/4nX9ypk2bQst7UNyQGzjiQ9TlT2+sUS4Xd3oikfob0ErfAamNa9DLqUJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5372
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
Date: Thu, 20 Apr 2023 13:27:11 +0200

> 
> 
>> -----Original Message-----
>> From: Lobakin, Aleksander <aleksander.lobakin@intel.com>
>> Sent: środa, 19 kwietnia 2023 17:39
>> To: Drewek, Wojciech <wojciech.drewek@intel.com>
>> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Lobakin, Aleksander <aleksander.lobakin@intel.com>; Ertman, David M
>> <david.m.ertman@intel.com>; michal.swiatkowski@linux.intel.com; marcin.szycik@linux.intel.com; Chmielewski, Pawel
>> <pawel.chmielewski@intel.com>; Samudrala, Sridhar <sridhar.samudrala@intel.com>
>> Subject: Re: [PATCH net-next 05/12] ice: Switchdev FDB events support

[...]

>> (no types shorter than u32 on the stack reminder)
>>
>>> +			       const unsigned char *mac)
>>> +{
>>> +	struct ice_adv_rule_info rule_info = { 0 };
>>> +	struct ice_rule_query_data *rule;
>>> +	struct ice_adv_lkup_elem *list;
>>> +	u16 lkups_cnt = 1;
>>
>> Why have it as variable if it doesn't change? Just embed it into the
>> ice_add_adv_rule() call and replace kcalloc() with kzalloc().
> 
> It will be useful later, with vlans support lkups_cnt will be equal to 1 or 2.
> Can we keep it as it is?

Ah, okay, then it's surely better to keep as-is. Maybe I'd only mention
then in the commit message that this variable will be expanded to have
several values later. So that other reviewers won't trigger on the same
stuff.

> 
>>
>>> +	int err;
>>> +
>>> +	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
>>> +	if (!rule)
>>> +		return ERR_PTR(-ENOMEM);
>>> +
>>> +	list = kcalloc(lkups_cnt, sizeof(*list), GFP_ATOMIC);
>>
>> [...]
>>
>>> +	fwd_rule = ice_eswitch_br_fwd_rule_create(hw, vsi_idx, port_type, mac);
>>> +	if (IS_ERR(fwd_rule)) {
>>> +		err = PTR_ERR(fwd_rule);
>>> +		dev_err(dev, "Failed to create eswitch bridge %sgress forward rule, err: %d\n",
>>> +			port_type == ICE_ESWITCH_BR_UPLINK_PORT ? "e" : "in",
>>> +			err);
>>> +		goto err_fwd_rule;
>>
>> A bit suboptimal. To print errno pointer, you have %pe modifier, so you
>> can just print err as:
>>
>> 		... forward rule, err: %pe\n", ... : "in", fwd_rule);
>>
>> Then you don't need @err at all and then below...
> 
> This is really cool, but I think it won't work here. I need to keep err in order to
> return it in the err flow. I can't use fwd_rule for this purpose because
> return type is ice_esw_br_flow not ice_rule_query_data.

My bad, forgot to mention. If you want to return error pointer of a type
different from the return value's one, there's ERR_CAST(). It casts
error pointer to `void *`, so that there'll be no warnings then.
Here's nice example: [0]

> 
>>
>>> +	}
>>> +
>>> +	flow->fwd_rule = fwd_rule;
>>> +
>>> +	return flow;
>>> +
>>> +err_fwd_rule:
>>> +	kfree(flow);
>>> +
>>> +	return ERR_PTR(err);
>>
>> ...you can return @fwd_rule directly.
>>
> 
> I can't return @fwd_rule here because return type is different
> This function is meant to return @flow.

[...]

>>> +	struct net_device *dev;
>>> +	struct ice_esw_br_port *br_port;
>>> +	struct ice_esw_br_flow *flow;
>>> +};
>> [...]
>>
>> Thanks,
>> Olek

[0]
https://elixir.bootlin.com/linux/latest/source/drivers/clk/clk-fractional-divider.c#L293

Thanks,
Olek
