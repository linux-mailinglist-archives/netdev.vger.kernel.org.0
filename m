Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5F84D6468
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 16:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345245AbiCKPUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiCKPUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:20:34 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458F41C65E7
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647011971; x=1678547971;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=scrJS934MDqsVwllRD1su6wStFovrIhcVqSK41D/ivI=;
  b=l+vWq7vbIQaQiSfSD0P1WXylu0Qs1ow2U/PiODMfLHK5opC8/aCMWwoE
   RRIX4lmluCJyDcubI6R0Wb+1xbv/urE/51AppwH6CC6VaLGrEMLTrG/Tb
   RYZR9LKYSzYqHCJBIfUg0sHaFkQvH0i8OVm3byLE+8KLg2psJ8ijFrLgl
   EZ5m0bwM55tWHYdsF8XPBWdHDdogRP9unh/navfx+HW1qx+ixcHkrSSwM
   6M4o/mweKn77vDbtpJ+Fq9aQyDFUoXaltrzSHEjN8uu/gwsIXIO4MQkOd
   OcqqmiJ1KUbrPL8MtjOXo4q+IHg+F7/04RyO4RJ/g3YQdnb4wzVPREYqF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="318811734"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="318811734"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 07:19:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="633439397"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Mar 2022 07:19:30 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Mar 2022 07:19:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Fri, 11 Mar 2022 07:19:30 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Fri, 11 Mar 2022 07:19:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beeWDzd0iG1voym1DjL6n665hXUHcNgRRW+oP0HclEjrchNaU8Ho9U3J4Dunwj4SS5iTuufahRgFSkSGBGfG5pXBoK6Mhv6W10+lx+P2rtJHGOOX08TeE27pVz8AX4glCERJYuRTUiXub1QZtXkhuUbiap5Kz7EV3vKr4j87E3KShAczpCZwvPK+B8G3CUJIdg+9C+LFoDQ0JQdtFYjZ6zMjd3IyXluHTGst1XTeEDo42et+35PYHxx/1+/F6J4n1CylKOKg7idH6iGISCiA21goDX/KeGMrJCsd422eFOgk+UzllGzMok8F0twA0fRGANNdym8/QmJPF8WnqdBW0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDCkwUta/lztpXRnM2nLSafXHNj4Xh9rbqQkMVp3rlo=;
 b=Iy6zbxaBJNMkqqckLmtdgzgRpBdVehna0utepc0l6JJa6jo1MOpS9E1HDbK7kY/gOeSMaqEyBCf6LQRv6jAXdbfS3FXmwXuLlwvycK74D+YE7O7ivHzxp9EFlfwV6Cwsj5wJLAWoWy9BkMDlitWskQi85g0spgxGWX7CeZeYZ/2lOPFiNgIX0GaRhK20YcMfZodsRj88mQLkbHCZ20CPkqut+vTnO4bmYxuv2HXPGsonDKN4tU1Jo/jABreItMAsiTo+LoHbOpHhYfJRxfLq1MYDlSsw2V7Fqbjn1AEpWCtQpBbcDszdL4KpC684qOByR0B9cAf7ggRn2nUbUwLsbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by MW5PR11MB5860.namprd11.prod.outlook.com (2603:10b6:303:19f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Fri, 11 Mar
 2022 15:19:27 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::ed3a:b7cf:f75e:8d63]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::ed3a:b7cf:f75e:8d63%7]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 15:19:26 +0000
Message-ID: <0e672d96-5b68-4445-482f-1fc4c55e8f45@intel.com>
Date:   Fri, 11 Mar 2022 09:19:23 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next 0/2][pull request] 10GbE Intel Wired LAN Driver
 Updates 2022-03-10
Content-Language: en-US
To:     Leon Romanovsky <leon@ikernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sudheer.mogilappagari@intel.com>, <amritha.nambiar@intel.com>,
        <jiri@nvidia.com>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
 <YirRQWT7dtTV4fwG@unreal>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <YirRQWT7dtTV4fwG@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:510:174::14) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bc853ab-cbfa-4d88-4af1-08da0372879e
X-MS-TrafficTypeDiagnostic: MW5PR11MB5860:EE_
X-Microsoft-Antispam-PRVS: <MW5PR11MB58603F2D5D5B2CABF1F5D4A4E60C9@MW5PR11MB5860.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NXW6TYKmyaqkfb1EzOM5P/G+spqmyxWweODVlDn96fKSw9mCTMF8rNtXVrMC24PCtFdVFMoiONJ6jqj9i5eECRF71t2PsK0MSVxLOG6DTdPjaObhBsFTpkSuZnKQL+ooOVwPBkgE2uGvV5ebPtKVLiaAZOBMcGOGqjnxrWE0zSeC0Af9OyyNbaXbTKcUWqOLvrVbq2aT+i6RYWIhBgJR168KlIFwgP0QxuMd5FrWg31yyF8GrbabumNnSpvzfF0sDcbekf+UFAPJ1bsCSVXxCMlWM23B6NRDag34p0rMXc1GkfW91wR0WaNvaCkFBDNyaBIj95OtfYzBLCaeqONjin4EYhReOmNp2kSixZNGItjQJDcOJAMFGGqkPTs6ykHFZH30oGznQ+b1j9s/DT62qRDHAIjiTi0x4XmheolCK05wzJuHvZg3hvtT40e1R1tbenYprZftbCDeuKHaX05kBQXRF6Hu+MNak3EHeNzHC0ZyXx5xuvir7m2hfUTtiLFrOi+j48NVXhnOelDE0Qx0xxoy8pWsxbMoCEf55H7JhROW/VypPCu2rM96V8t/3w3xFizndB0WmkqcLQA18mffvifw4B4yNBMfH/k9hxiDKdwUrfXvrRG1XzE1HtOzYou3t7EpwEp7XOt5c5fZJzn9/p0mslI/SweOwZzttfNUgrDc3HgQDJQuWLpKgORXsRd8W3jFOI9OXQQojO8X0/H04yDVpwgQ60pogw6s9qmtfDM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(186003)(31696002)(4326008)(26005)(8936002)(2616005)(83380400001)(508600001)(6512007)(82960400001)(6486002)(6666004)(38100700002)(53546011)(6506007)(66946007)(5660300002)(66476007)(8676002)(110136005)(6636002)(31686004)(36756003)(15650500001)(2906002)(316002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGdZUk11WTBLd2MxbUVaajU2WGl1ZTNCYTJUcTBKOTI5Y3ZLZkxGSFBtYW0y?=
 =?utf-8?B?cWtzU20yMTBZbmtxZUFzTC83S1M1T0RYajlUL3ZxSStmRUFlNVdJUWFtTytH?=
 =?utf-8?B?aVNtUC9pQ3cxRExXOUkyMUlPd09NUzBURUl3VWd1UHIxakZlNmhDN2hjTVJD?=
 =?utf-8?B?SmliT1hvYVg2c0hpaThZRmVaQU1jQVFIYnRHVXNUMU52aFN0a1o5cks4ZFdD?=
 =?utf-8?B?UmlqTHFuN1g3elRQZE9OcTdLT2lzKzNKRUFuQVdjSjAxRXVnQVBYYTRMYVVT?=
 =?utf-8?B?VG1LVllPRE9zazljMDFtcksrM1BDVW0rWUp3YzdXZ0dwRFphU1lROC96L29X?=
 =?utf-8?B?Rk9CT01KamJ3Nnk0M1BwUUhJM2hLQmFVdlpIdG5mVitRQWltK2hLOFNOWTBP?=
 =?utf-8?B?ZGVRQ3VNQlRXUjgrcXE0bkNGVHIvR3V6cjJjT2l1Y3d6UE5JVDNHQzQvYTFo?=
 =?utf-8?B?Q25odXhOOElYMGYvNzI4WW9BVTkwRjhUNFo2VjRVV0JIUCtsOEZrdDJScG1X?=
 =?utf-8?B?UW42bFdTOHU1VHpUOFp0bHQxem55WlJrYzdsZzRzUi9tUCtGNU1HRmJPRlJ6?=
 =?utf-8?B?U0xIR3o2ajdrZkJBcUs1MzltTnUrbEF2WkZXN1NEc3k1Q0lHd3VhZ1JhOE1n?=
 =?utf-8?B?eTdsRG8zdDJCUGlSc0x1VStKUVNxTEFmR2t5Mms4bVdSTTB2WXhnekdFS0I2?=
 =?utf-8?B?ZllteUlxS2ZUWXNKNnlxMzdXUmxJZXE5c0lMcEJEUldiTlJpaUJ6cHY0TFJ0?=
 =?utf-8?B?RVBHdE5TRGMzR20rdFhlcERzNG5ONVBVWnRNV0lPR3A3VTRCUlJqV011aXA3?=
 =?utf-8?B?MEVBalJiSzFKNFpEeUQxZjFKU093aFlOUmRjQTVlYVE0SDZTSy9vOWF1RXN1?=
 =?utf-8?B?ZXNyWEFFRUZOeWc0VDRhUGJQK0U5a2NYQTd5bi94cjIrdEkrWENVV1RsRExo?=
 =?utf-8?B?UHpSeURwaFlSTGQwUGdYU1g3dE1ORUk2Q0pGNzlaRTdTS1VyVmM4MUNwSnox?=
 =?utf-8?B?RVAyWjVnWTFnOFZPSlcwaEFnTGhxRHRvNWZHTU93eE1tTXFNV3RIMTBucDdF?=
 =?utf-8?B?d2M5NzYwWFlGQWliVW95OVBsQTlGMnlja05iUWxrSmRhcWxQcTNLdDI2MnU5?=
 =?utf-8?B?SzZOeDBzVHlIWDdRT2hJK2M2emJ0T0pFT1FZeGsrbWJ1TTBqTFR6Q244d1RD?=
 =?utf-8?B?UjZnMjFKdUpNYmk2cFFHR0EvdFpMWUpMTWFWWXBDdEUvUDR2T1RTYjF0VjUr?=
 =?utf-8?B?Q0s2NVcxNWRxaGFxQkRaRHFXei9kNkFqOVVCTndSVUJvTG15cEt3bnphUk5y?=
 =?utf-8?B?NkRHOWdWeFZQVUFreWdKU1VpTnZROGo2ZTBUZEpUSmRFNjdKRGJzd3YzTW9C?=
 =?utf-8?B?U1A1UytleUU0YlMvUDMxQzlTS2NDNWY5eG83eENNdlE2T3UxcWJMSXhyY2lt?=
 =?utf-8?B?S25PRjRVTlRuaDlaVVd4OVMycFQ2amZNWEdWSXJ3VkVyZjM5bHhaWkY4M0t1?=
 =?utf-8?B?OE9rTWdkL2p1QXNkSXlpb2R4cDZiaEtRWTJiRHRXVXN6QU8vRnBURWduOVFH?=
 =?utf-8?B?RE1kK2p0QlEwMzdNU2lhMkpSOHdLUnA5NzBIQ0VkL3FzaG9nYXhhUWJCNVdE?=
 =?utf-8?B?ZjllcjFrV2krNHNXVDk2a0hObm55c09uSFFrOUljNlM0b2NVZFJxT0EydVlo?=
 =?utf-8?B?V2w0UllhSytHVjZzYXlqZlJZSDdta3lsekZoSUc5cWZ0cktPaGlwbzhWdEhj?=
 =?utf-8?B?RS9OYUxIZ3pjdWpKS2s2RTFZR0lqam50VXlHcmtka3FuK2U5d0NoZ2lFd3Jq?=
 =?utf-8?B?WFU1NDRCWjNUdW9nbGh3WTVWWDM1NTR0Skx2bzh6dys1WlpvY0wreTZIMTd4?=
 =?utf-8?B?dFZTWEtiZkk4S3RXU29SNlZmekFCMmp5Qm1YU2tEY2xHYVFmVW00bldRSWhJ?=
 =?utf-8?B?M1V2Y01RQU0yNWZiclc1Q2lPRmsxODQ3c3NjR050aHJOWmx1MUU5V0hyRDdk?=
 =?utf-8?B?MURGVkhJWXE0WmlGQjVIeDJ1K3NDNW1DUkVQVHhzWnB1RDZvcThSMkRqdW1y?=
 =?utf-8?B?ckhTNSs5cXlsWnZCV003TlYzaFpSd3Y3RVIxc25qeEVhUXhDM0wzNmdacncw?=
 =?utf-8?B?ZmlIOFlCTEJ5VWc0RjQwa2MxR2VWVlZuSkZSY3pFM0RoVVBCbFZJQ3dYWlBs?=
 =?utf-8?B?dUloWTU0VHR6SnhwNjNsa2VhaVNBdklaZXFrUERzeDg1M2dwRzFNSHlCa0R0?=
 =?utf-8?B?dVV4UmczaVVnTTBtaVhjWFVuWk9BPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc853ab-cbfa-4d88-4af1-08da0372879e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 15:19:26.4842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjSVUEBhMMZAe2GRSP6XUXCkiA9NFEPIht+Yij558ovD8DqdHuHJoUddFMy5kyA6pHZBLTPVEvs6lGLbVUEDGTBe8PcQ3AcK4QzQ2roV/vw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5860
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/2022 10:34 PM, Leon Romanovsky wrote:
> On Thu, Mar 10, 2022 at 03:12:33PM -0800, Tony Nguyen wrote:
>> Sudheer Mogilappagari says:
>>
>> Add support to enable inline flow director which allows uniform
>> distribution of flows among queues of a TC. This is configured
>> on a per TC basis using devlink interface.
>>
>> Devlink params are registered/unregistered during TC creation
>> at runtime. To allow that commit 7a690ad499e7 ("devlink: Clean
>> not-executed param notifications") needs to be reverted.
>>
>> The following are changes since commit 3126b731ceb168b3a780427873c417f2abdd5527:
>>    net: dsa: tag_rtl8_4: fix typo in modalias name
>> and are available in the git repository at:
>>    git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE
>>
>> Kiran Patil (1):
>>    ice: Add inline flow director support for channels
>>
>> Sridhar Samudrala (1):
>>    devlink: Allow parameter registration/unregistration during runtime
> Sorry, NO to whole series.
>
> I don't see any explanation why it is good idea and must-to-be
> implemented one to configure global TC parameter during runtime.

This parameter is applicable only after splitting the netdevice queues into
queue groups(TCs) via tc mqprio command.
The queue groups can be created/destroyed during runtime.
So the patch is trying to register/unregister this parameter when TCs are
created and destroyed.

>
> You created TC with special tool, you should use that tool to configure
> TC and not devlink. Devlink parameters can be seen as better replacement
> of module parameters, which are global by nature. It means that this
> tc_inline_fd can be configured without relation if TC was created or
> not.

Extending tc qdisc mqprio to add this parameter is an option we could explore.
Not sure if it allows changing parameters without reloading the qdisc.

>
> I didn't look too deeply in revert patch, but from glance view it
> is not correct too as it doesn't have any protection from users
> who will try to configure params during devlink_params_unregister().

Is there any limitation that devlink params can be registered only during
probe time?
Would it be OK if we register this parameter during probe time, but allow
changing it only after TCs are created?

-Sridhar

