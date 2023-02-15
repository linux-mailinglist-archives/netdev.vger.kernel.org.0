Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A61698303
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjBOSPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjBOSPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:15:48 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B23C3B66B
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676484947; x=1708020947;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m/BV6R4hbce6A/s8zRLvzJ2n0jIcChKr/7O2KD80QyA=;
  b=mPSkNtYz4Z0xaUTjny5a7+6ub7WDS0ts7+w9+gfCtqo0mHtH3Thm4jza
   6foIMES3F1AU3SOEtcm2uLZAxx0FF9owOgJus6J+dFYcuHgCYQpW40Ezu
   sY57NuuEcH95+BX2mfU8keyyrTRAOs9Re+PqCSxz3xqoX6iJt15YrDgEb
   o3qQ3Bn01tApGOtY79BsKcMs5w9US+ofSW1HfLBkxyNOzrH7ljJc614vO
   06YVJEnBcvBzt62jDIMnKV8C7Tv5kOkfxnbBwB/evZsWHs6pXNLpupZqO
   umQeGxthpHK+F23cmgb8L2KD3v8khwjmvFeuPGK5f57QiP+ZDCld31cxP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="333651466"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="333651466"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 10:09:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="671771092"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="671771092"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 15 Feb 2023 10:09:48 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 10:09:47 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 10:09:47 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 10:09:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 10:09:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAxLZmEVzaPl1/kHpM+UR79jdq7kaM341GBHR3lKWQPGegL89dtCwrQFXmIvAkXtDayfePI0rZNgwJr3Ci8V0YaSJdRJ4BLWC7V2ggRUINVMAdSZ4uP6y43bGlfzcrmsf3jvHxgrOpioEfbOoLa1488RgNFkFHCdvTbJNLRrmOY6SWg94B15VObdfXyCF4694gF+661z0Em0G/a7KbTBW00CSey019e+la/O0fdwy9D8IOCDaPgpGLTSPkRKVfWd7odVIorpTMmuMy297qM8tzBQ3sZn9UP7EcvThT917/7M+w9i1E1Taz0LtWaMYcHumIjYIZ1dc80I5Rs0w9shwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HlrfxVxdm+lROD3P3y+wh++Iy5ptUcyi1D1WlfumJMM=;
 b=Aif0NbVrBEQRQvWFqEdlKheH6OBEL4S9apOj0bQ3bFrUZCEKhexyQNnlL9hZm0XihxwhNVaW5ZAQwiGdPnS6n23OYcqu9xgC501Ea84EHUJvVypkv6cm1IBIbv8ZsUHAI0myIszVNxX3z/xb7Ui/lTF3zGsQGPk1kdO76D2jMhnAGKJGmx2VOainCQSUQNdIYO5DsSTIb02d3wbvx4VcBlHLZh1FwtQ+EAbVTkFa+3+/Q9YoKkF+r5vsrai676PqqRyRca240SZYi0EdHJHQpi+RuQIlTFDnfGEfb7OP/0YrCq9ALcBqQT/aE9ecCfkcbvHpimq4sFwr/yFW7jlQRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DS7PR11MB6173.namprd11.prod.outlook.com (2603:10b6:8:9b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 18:09:45 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 18:09:44 +0000
Message-ID: <904992ba-650c-8810-b0e1-6c8acf5aab77@intel.com>
Date:   Wed, 15 Feb 2023 19:08:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/3] net: skbuff: cache one skb_ext for use by
 GRO
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemb@google.com>, <fw@strlen.de>
References: <20230215034355.481925-1-kuba@kernel.org>
 <20230215034355.481925-3-kuba@kernel.org>
 <ef9ab8960763289e990b0010ee2aa761c3ee80a3.camel@redhat.com>
 <20230215094542.7dc0ded6@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230215094542.7dc0ded6@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0608.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::8) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DS7PR11MB6173:EE_
X-MS-Office365-Filtering-Correlation-Id: 4683f822-cab7-4f0e-a881-08db0f7fd119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p4DjKWnAM1KPdZ7+2TGZPWv0qzXFfs93ZfCRxrXRSp6memHjRiQJrU9i4ynV7HMkXSAvVfwGA76MT+DrK4Q7zd4G3Gv1IIagoxndfEpm0q8DsHYt+33bjlaU6R+3KfTfvoittm1qTjwJsD4xYEHJ6eBUB0FGFez9mTg2PM5yWYrt2LVFW07P/PabH30BrA4yuwp01l1cZszjvd6Tj2bCHPdW/jBNT9Ksonb4wVIA8D8aGz/5+nQGvKWmt1SP0uvSl1PXlVj/irO5csUboPGBsWZqm54A2V9zUMgQ33l+NCxL/lThlEMx6snCePzZgDK+s46z1vREHh8l6kKYbgQVVwi6otr4e2NowOt18PFwYhjQMc5mTsatWmg7VVrFkrYGYSHHsWPPw/842e/gWU9YmLjXcnoDGLp7+pHwzlgxtBMhrKAHnr2K199DN5rs0sdz+Y5BnmKjHydNsYOmQ6lWmTnVHZVSJMfhGNxCj7TUCWrmuBxx8LW3LV4KNL1S8tlgmbMRLd8xgcjcatuxm4qcHxBJf/pfDttDIkm7zvbZZIetOzwfdhMCINGvl6Gpc3nsihVrDCvsGpVflXmMsj43Wc/sApr6l76AG7eF7jyCMQfJa3fy3cbTtMp+Eo93jIIihJpjr79sIzEJ28BD0K1DvZEJdPPZgtbHbJNndoT0VgOGSP6M0YdVf1lu/L1AFwxr+o6tuldiNnhC/cz2HtK/URQAlzrymJntZKl1aKu28ag=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199018)(4326008)(316002)(31686004)(5660300002)(2906002)(41300700001)(6916009)(8676002)(8936002)(66556008)(66476007)(66946007)(4744005)(6486002)(478600001)(6506007)(26005)(186003)(6512007)(2616005)(36756003)(83380400001)(6666004)(38100700002)(31696002)(86362001)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVMzUHhQT2ZsK3lRVFA4T0xBZ1p4YldxVERGWG0rV0hRWWRzd1BJa0hYa0Nj?=
 =?utf-8?B?UU5vMWNUcGplUlVCWHJSOVhUT1pyUE9pQmpzYS9TWXlZSENrcWpQSWNEKzdM?=
 =?utf-8?B?OVhqOXMwcE9tREVNL2pDeVJqWmt4Wk12RnVCODg2T0t2RVNJK210Z3MzbmJ1?=
 =?utf-8?B?eThnZ294NjZOWFNBa0tCM3lPTDExanZGcXNoUHh4d2trZmpQMGhvYVViTDJl?=
 =?utf-8?B?NnBjSklibXRBV013OXBFUzk0RzRJdjNqRTA0bzZzUWpNWnJTbytWYS9EbTNV?=
 =?utf-8?B?MEU1QmIyV0xiem1wSTZRUzdKbXBDd2tOZzgvQk9vUXVEaHhKWHVlTGJSQW02?=
 =?utf-8?B?MVAyZndVeng2WVRwdWxqNnQrYlppUURDUVM2ZDc3WUR3bUlxTWV3TTczQm5Z?=
 =?utf-8?B?c0lxeENSeW1sRTRJNld2NDR3VTRELytReFk3S3h0dHFydUdUZXNsZmZ3QjRI?=
 =?utf-8?B?UW9hd3ljOUZnU2Voa2kyclZOb3hNN1VGc0U5TWdHYzM5L0R0VXJscUFvWGR0?=
 =?utf-8?B?b0tVN2Jkc2dWdG5NczVHSVI5UU9QS3NhbzlNTm9meU5Sb1MrWUhBR05Oc0Jo?=
 =?utf-8?B?OHRWVDN2emo2Y0VWMzgzWlFTanV1eUIzQmk4NWRCZ29uMFhkdGpOTzU2SGgz?=
 =?utf-8?B?UVluZnRralNVZnVTVCtDL2wzRlFmcE0rRnh3M3FwZEZ5YitjR21lWjMvOXgw?=
 =?utf-8?B?Z1NjbWh6SS9VK0Izd3FZU3huNEN0U3lLbFRTUENWWnZwQVBZZGN3UnJPNy9Q?=
 =?utf-8?B?TjVQaXlDNUlRRVNRZGdrY1B5cFhFT29lMWErWm01V3QzR216bi9BWWtCak8w?=
 =?utf-8?B?VGw3OGJCUVFpQzJJak9tUGllOWlCNjFzQ1pDcHN2SjI1VDFqTVZKWHV3eC90?=
 =?utf-8?B?c2hzOGlCSm1zdHo5cnd3NVArcVZ0WmhPbVQzMVZEWnd4V2MwckpnK0lFMUtw?=
 =?utf-8?B?WUpxMkpoNDJKcG1rZFJtWURXOXpjTll2U0M5SCtITDhHalFsSnFYclVHbmZT?=
 =?utf-8?B?TlBKM2RYQUhYN2ZaT29iR1FsSnJtSkIwM0x4Z1Y1R2x6Y2d2NVVoVTVkeG9w?=
 =?utf-8?B?aHY3THpWYldSWDdVYlo2a28vZVVVeVdReUh4eE83T0xUZ2RrYktYRVdsU3NR?=
 =?utf-8?B?Ti9ZTXNZSGdRc29ieGpCWWdwYk9kUWxqWlpHSEt2UHBJNzJqYW4rbzBlL28r?=
 =?utf-8?B?akVCYVpYMXQ1R2tHWkY1bHcxK2dWWjU0MUpjNkx5NDM2em4zbTBkcTZmMEt5?=
 =?utf-8?B?Zm1tQnNDeVkxVFNrd0lTclhhZDg3QUpNZzFZRFFSd0VjL1NzM1ZnLytzNWtT?=
 =?utf-8?B?Sll4anRpbmU1VEVhU2htMWNETnJ1NlRjSWgvUU02ZlZLZFYrd3FWMG5PT0ts?=
 =?utf-8?B?amRkaVFFMnRzcUJMeU9xM0swd3VxaXhBR2hrclB2Qzk2UE53b1BIcnM3Nkhm?=
 =?utf-8?B?YmFtRVRadDRCR2JwTW5FeTR4QW50MWJOSkJHMUtMYnMxZkplcUhoWlF0V3J2?=
 =?utf-8?B?OHpxMUlKQjNFWU9YL3FSdFQ1aisrb3QwaGZiUWtRbEJrTFdmeVkwelYzcHZL?=
 =?utf-8?B?b1VwWUNjSmdiTHNWaWxKUVhMdWpya1grWEZoQjRyalEwR1VxZ3pQOHpzUm1n?=
 =?utf-8?B?SGRQVDF5a1hwMG9QM2s0UjZCd3FSVmxLWThOT1pNaDlRTUZzZHFiYU4zcUF1?=
 =?utf-8?B?aUg4ZDNNQktWTFJFb0R3b2xhUktrcWRza3VhMUNVMEkyRGgrc3lqUFR5bndM?=
 =?utf-8?B?ZDRyMldCVk1RTWxYZkJ0Vk80dTJ0bHE2Z0l6cUFOTFpiTG5oWjRFd3h2aURh?=
 =?utf-8?B?SG1JQjloNmQzclBWdzloam8rSHl2RFdDVzFwVWlnQVlMZlZZYitoK0NEZkRC?=
 =?utf-8?B?NWg3QmtwcU5HSHFmLy9GL2FMUzhCOXVBeDhDRUJaTk1hcUpGbEpiRWozdE5y?=
 =?utf-8?B?dHAzQ0xFTC9ReGdvYkNDbDY1RjBvU1VSOFk0VGVoTGJNYjZubHdEUFRGdzlP?=
 =?utf-8?B?dDJWWXZraVd5UzFrQWZRSHhXbk9kYnBMdHRXalVLMWkyNXFvcDBqclNpd1Jj?=
 =?utf-8?B?VDZWc0c4TWVJOHFWN3IwZ2YxcGs0T1lrQjRhUWREc1c1ajhOaGpZQkZab256?=
 =?utf-8?B?Y01DVU1tQTlidHBTckc0cURZZnkwaXZEbks0QmdvOXpGSFBaUWNKM2pEOENz?=
 =?utf-8?Q?5CIGH9fuB0nN0J3d/MU1UAQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4683f822-cab7-4f0e-a881-08db0f7fd119
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 18:09:44.7533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8bBGHS1qChvaDUVmvs2z24ApSxSw8sm9f4uw1Ty9XHmnADUGdeJWH9dxoa6cEqCpFmxd0gKEmitdhRw6cNxQbE+3HBP4U+I45ul7k3UPxeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6173
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 15 Feb 2023 09:45:42 -0800

> On Wed, 15 Feb 2023 09:41:13 +0100 Paolo Abeni wrote:
>> I'm wondering if napi_reuse_skb() should be touched, too? Even it's not
>> directly used by the following patch...
> 
> I didn't touch it because I (sadly) don't have access to any driver
> using GRO frags to test :(  But I certainly can.
> 
> What about __kfree_skb_defer() and napi_consume_skb() (basically 
> the other two napi_skb_cache_put() callers) ?
>

Sounds good. Basically any caller of napi_skb_cache_put() can be
switched to recycle extensions.
But you certainly need to have a pool instead of just one pointer then,
since napi_consume_skb() will return a lot if exts are actively used :)
Having just one pointer will only make freeing extensions 1 step longer
(`caller -> skb cache -> kmem_cache_free()` 63 times per 1 Tx completion
poll for example to save you 1 pointer to be used on Rx later).

Thanks,
Olek
