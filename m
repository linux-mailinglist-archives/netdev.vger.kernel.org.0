Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B766BC255
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 01:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjCPAVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 20:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCPAVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 20:21:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24F99CBDF;
        Wed, 15 Mar 2023 17:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678926058; x=1710462058;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fQHi556Ba6aqQFUAQqm1ODNA4moHY+lWUUcs6rQDlyg=;
  b=VNNMKtpST+aEZ+Tm9UmHaaAEj4tV3b1uExMoY13Jmsjj/HOaoyPHldcF
   509uQY/L0RBiJrXRDbl2dkzaC5nRPRDlYjXQslmvCd0H9HHrDFvl9XCO8
   +8ZtLO8h5WcOx4eUjs8As7y1XFv/KEFxDWyY8V4lsFH7pRyvd4RRVCdSl
   q2gVxL2DjTTAX54iMG4I5j3SVsLWu+VAWVAW4T5YslFucrGGxQ+JDvNPd
   Klg6j/SNYWsWp9tXfluLqEAQjaAzeh1yQz50yL+cJnIdvWC0J00/rgiTc
   /b9btt01OJdejuEVSh+UtL2RE8+BGwXP8cHuHTuQ+069+/Qxls2Mribmh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="424123316"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="424123316"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 17:20:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="790043786"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="790043786"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 15 Mar 2023 17:20:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 17:20:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 17:20:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 17:20:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=od7/rpyOH4n41FOZ3F25cyP8GsGRN3fLMAPsxlcbIiropM0jnmD6sqGsbyzkQPWnhzfIHETwuVNFJCgRF2rKgoI4D0bAVp9hdjPSMDXUJSCJf0Rd1X4pzenJUawjDV3bkT1S3mWWdD4tnnGDCbIGQRSxLilD351DEI10BEvnaB44zsKo5ZMcCIu5hzQY6Wsufrgu0lNK++1AmB0+BDgYje5zIh3THFySZadoi+JWGRnUJMW++bYlq3pXjWHyzwp5fcdXimB0LNvWgG2yVnvCk35JJxLCVmreKjtvFwCDJSbGHaWVO5KPH+p7n9xLgyIgOcilTgDOkq4rjG7GnEFiJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Winha0FX/qjP0KEnc5InAV8DwcXFXF3TVSw0HGRciSo=;
 b=SkJYYd+jhYWNDpGRhtYyfukNyT2tGC62ZbEY44CV8z+9ZX//FTpmYaq8o+OB/V8H0sgdiaUNA6HgiXfz7lx2ZpTeZymEUKwSCiYBVRAeRUe12ZtJ0CcNWsBS84V/M9eNFquXSi8uTvydJ3MLm3jmpyn8mFP2p8RZdniHE7UKZvIPmImBBxZwwoFeJSbTnYw0FiEd2A0MZt2Xt2v6ZIlXOpifOKS4DfpwQK8UgC6B8VTvlDFRqw8seEywFL+PcjjIYsmTCTjefpaXC9Gz1kVhttI9lmcojtCaOjKbW5WRqItDBWL9r5QOzvc1NGj+pB6JTXGii+sN6ecboWEDr3jpsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA3PR11MB8074.namprd11.prod.outlook.com (2603:10b6:806:302::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 00:20:47 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 00:20:47 +0000
Message-ID: <71ee8b08-b1d4-cc42-62c6-4104849a8cf6@intel.com>
Date:   Wed, 15 Mar 2023 17:20:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] docs: networking: document NAPI
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <jesse.brandeburg@intel.com>, <corbet@lwn.net>,
        <linux-doc@vger.kernel.org>
References: <20230315223044.471002-1-kuba@kernel.org>
 <e7640f5c-654c-d195-23de-f0ca476242f1@intel.com>
 <20230315161706.2b4b83a9@kernel.org> <20230315161941.477c50ef@kernel.org>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230315161941.477c50ef@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0034.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::47) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|SA3PR11MB8074:EE_
X-MS-Office365-Filtering-Correlation-Id: 40b4426f-dd9a-40f8-50da-08db25b44a46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kt2yptJ8W82HRmtuR8U7R6rWMHNesEnkSDT95ph85h9Jk8OJXePkMawU8Gd1kC6PmIBgEc3u9vX2DMsxXXdxgEWeMIYGa5JVSkAYCEU7rJMlW2luXPV7Uns8o2EjOJtLw/7KHci6yOT4AdRYUNBQmaQObjwTinGl7N0g5LdPfFiZHPwA0U8xCf36rgr6M8CozVUuasVFawwm3FOw0XGgVdIW3k7VmEYFp2yHdoV9KjGoTXtjbC1GYn+UL0+WtZbx8C7DybtQHVm7HrKzVHYsDXYRmrse0Va4HpL7tkc/nLwRCKwY4FzbY7oK22Wk2gU1ha3qdITMkrh1xaYSIuUKnrewdSspJDVVS/2lMLuF04hDGkHuOug8U9p9wj/thJ0KauqLebSR4f0VGONYwsqTomRBGJmNafzZZHvBim7DKsStODslFuzAu3GrrYs5hZkpX0iZ5bRr9+tenmTYlVw9l5IH0JyfUoHgp82fWWBYZ8seCk6bWbfyI/Lcol7jEq8g9j6aLZSbUTqygXmBL6S7+f93po0eJDa9MFcEy1JnoSdEAnUYrJ9IQK4Nsfwz5tnOAihwkoov2l1cSxdrcOIHjrtapewvVcfalCrNly0hYPsx3Y0T3qNRl+pNr7A754pTuEgXCDy9dX2q3QNBs3ri01tUGVjr2jeEhtxNdzSkgWxKoe49mwQA1p5QUzbc1/EzDLpjY+P+Z9F3TeYgn84u/WqCC0LKrt3r1GFGsgb2kVo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199018)(86362001)(66476007)(31696002)(36756003)(38100700002)(82960400001)(8936002)(4326008)(66556008)(6916009)(8676002)(478600001)(41300700001)(66946007)(53546011)(316002)(4744005)(2616005)(83380400001)(2906002)(6666004)(186003)(26005)(6512007)(6486002)(6506007)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NktCeGJMY1ZFOGRZRUU5em5JNUdGVVh5WEtOcDRzV3A0Z2MrdGdTMXg2eTVF?=
 =?utf-8?B?V0dwSlIzc2twNmFUVU1hNXJOMlFMa2NWQVQ5dHpEZU5TRjdkMXNETnBKenpK?=
 =?utf-8?B?MStXcWVFeVdsUmNmMFBSTk5tUEVsNFVHYXdrd241eUFWcEJGWnlRZWxWWkZO?=
 =?utf-8?B?QUFzMGwzdzBaSlJOOWJKNU5jOWphamhYNHFqNTBVNmFYR2tHeXFqS3ZPbGRR?=
 =?utf-8?B?UW5mR1BRMVcxYzFqclV4bEl3QUFPclEvU3Q5SXJ4WWRPK012Zk9OdlBDZVps?=
 =?utf-8?B?VWhaQWlMMmJNRW5JSmprQTFDcHdPay9DVzNiVXZaWXM3TmRZTTczWlltS3Jk?=
 =?utf-8?B?aVh4WEIzR0J1M005ZGdtS1BVUmpLanFFSUJSV0NQVit3RHFQUjI1bGZsK0V1?=
 =?utf-8?B?ZGJ4Z0ZUNWRMZ3dxblhrYnJTRmJhMUkxQXlnRlJ1RkZhYzBGaTJzRE0rNHAx?=
 =?utf-8?B?TDRINTRObEtlYWs3a2QxNUhYZ2VUNG4wdnpOT3ZJaGNKR1ZEZFRCT3JtbkJI?=
 =?utf-8?B?YXBtbEZDenU4VmtxMmNVVDJhdWpWaGNTZmloZ0NmOHJwdEZpMEx5cVdKTkNL?=
 =?utf-8?B?RGFFWmgzYUw1YU4yRU1NU1NsUkdWYjUwd2VxV2h1WlFXWXZ5ODlLQ2xOVXBt?=
 =?utf-8?B?cHl1VHlkYlgyZHZFREM2Z3Q0Z2Y1TkVBa2R6Njd4WlFrZHRmTjlZYWlyNmd6?=
 =?utf-8?B?QU1xNXVEV0hHMjUrMmFkZnMyeGkxM0I4WlBQNGhESWNjTnFodVQ5ZWRDeWRD?=
 =?utf-8?B?OElTbkJQYW1yTEFDRVFuVUxYby9zZEkxSGV0Y1BiZndrakRMN1lyK1NmWU42?=
 =?utf-8?B?ZkNnUDV1WUhTdXk1a0dDTVp2N0pYOUY2RmpjVlJWc2hXOUpyQzNTVFdQY0Ra?=
 =?utf-8?B?YW1UbWVPTHVSRWplVmRiL1JiSWRMczd1YUNJZk1qUXhYSGpoQzB1cmxRbUp6?=
 =?utf-8?B?d0UvWFFXZmpjRjgxTXRIU3ZxSWZMcjFtQSt6TEtwSXZ5YnBjbU5HVlk3cjNk?=
 =?utf-8?B?NGM3RXJUcStOY1hNN1FBZjRoSzRoSjZTQjNRNnU4MjJOMzFvR3BHemx6cnZT?=
 =?utf-8?B?Qm1Jc0N1djc2MEc5QWIydTNtdnkyS21XbDZWM2VFbXJJWGY2cWs1NDZ6VFBt?=
 =?utf-8?B?cFZ4Y1BNOWlpanZWQVdKeXp4d3JnTmNRdnBUeTF2V2FjKzJWTEdlM2kva0Vp?=
 =?utf-8?B?YXY0N1pYY3A1NnoxN0FpeUp0cmN6UjBMY3lwckdCZGQ3K1I3Zk1OL2dHcWRa?=
 =?utf-8?B?empCUDN4WGl3VjJ4b1lOZENaNUQxbEJxT1VDeDJ3cmVmTTBJNC8rRTk0ZFox?=
 =?utf-8?B?TVJKSFZETmdQUzBwRE15b0hISTJWeWIyUFdTazF2bUtveGFkWHZ2Z3dROWg5?=
 =?utf-8?B?RTRHU3JHQndxc3h3aGViSkVJNmd2Q29vY056NHl5YmVGNUJJUlM4ZWxEVFhr?=
 =?utf-8?B?WGtFMStoa29BNWZCNVlJQndnM3FOU0xUWDkxK1BVS09HYnlVL253S1BvL2hi?=
 =?utf-8?B?L3BGR3B0bExjdi9aaktJL0ZKRXdxYVBzZVphaXcraHlCaktEbFY5NWFnenJL?=
 =?utf-8?B?eFlDZzdqRThMWGUvdStCMUpKcXpucTM4OUIvdGtOTHJJWUxodktOYWd5QWM3?=
 =?utf-8?B?UXRCaDRUTjRidmt5OW44MVRJQ3h5MGJjSlZqS1YxZDQ2WlAwOWZ1WVBiOGtH?=
 =?utf-8?B?U083cWllNGxpTDdCYWNjU3drbzFxU0dJTjl4ZzdjbFB2QVQ5c2RKSlZBbWtm?=
 =?utf-8?B?UHV3WGNmdnlPVmd4TmIwczVkRWdFaHJuS2ZSVG5OUnBqMUl4V1dka2F2OXdE?=
 =?utf-8?B?VEhhNStycjhNQStJdnJTT292UUJDQ2VScE1ML1Y0enZqY1RCL3YyQlpwbjlx?=
 =?utf-8?B?b1RNYUhkZUFMdFpTZTZLSFBUMUoxdng0cFFyZklOTzJ4bDBFZGZZVTBKeTND?=
 =?utf-8?B?U0hNNGRPa2ZFZDMyUGtoK29VUzVuZmtuVWRKMk96bDZrMnNuVW5DcVBFSURO?=
 =?utf-8?B?bGdlUXRYeitINHQxbzlQdVFPTWdjaW85RUl4bmF3bklTMFJIZ3R1MFliUG1z?=
 =?utf-8?B?VER3OTNrK2ZEL21yYW9tQ3ExUndzR0orM0FqM05BbTBJcTU1c00zcklIQ0Mv?=
 =?utf-8?B?dEZTTHd6b1RyOFRnN3h2SytYQXJBVXFxV085aGkrdCtobHRsRTZTSlpQa1FO?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b4426f-dd9a-40f8-50da-08db25b44a46
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 00:20:47.6020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8hbPNLZ7euCFkXZoLl2NzEGbtE7U7uSzSwPdDKgjW91XrZ7J2fy8Ks693i8aEk0gFDcMe9rOjygbi0viO2jdZwyYFJWlJXcSDGeag1HgJ40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8074
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/2023 4:19 PM, Jakub Kicinski wrote:
> On Wed, 15 Mar 2023 16:17:06 -0700 Jakub Kicinski wrote:
>> On Wed, 15 Mar 2023 16:12:42 -0700 Tony Nguyen wrote:
>>>>    .../device_drivers/ethernet/intel/e100.rst    |   3 +-
>>>>    .../device_drivers/ethernet/intel/i40e.rst    |   4 +-
>>>>    .../device_drivers/ethernet/intel/ixgb.rst    |   4 +-
>>>
>>> ice has an entry as well; we recently updated the (more?) ancient link
>>> to the ancient one :P
>>
>> Sweet Baby J. I'll fix that in v2, and there seems to be another
>> link in CAN.. should have grepped harder :)
> 
> BTW are there any ixgb parts still in use. The driver doesn't seem
> like much of a burden, but IIRC it was a bit of an oddball design
> so maybe we can axe it?

Let me ask around.
