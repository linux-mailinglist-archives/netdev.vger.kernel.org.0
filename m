Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F1257663A
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiGORmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGORmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:42:35 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91D47BE38
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657906954; x=1689442954;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CAjY4tUtfF8XDf6IWPTUFbRozeC96gkMCRcsujzbgec=;
  b=Vsxx0reJqw3SdnMLvvAJytv9OfMIsz8KKoM690jwCxBdcaaYxT8fZWWH
   it8u8A67OnZbRyWM0cVY2uXEFxBuPVZviNMwpJFNGNzG8UUvjR3VFO3Hi
   N8VZlIPAfEn3d7V6CJGRQl+3Sm3Ejy4ANMk5/v+R7emSsknaqVHbRdP0C
   zCGKFDR0UJ2lcYxs28UxaPcpbvJpYdHWyyXG6vD4gt4sfL5Y9rpouTf8r
   YZqR1lgtBhXg640Q/SLXwO/UJXrjyl2MxbZT+d6GCy3+WOTPGy+cTC61D
   XdyyMHwc82JsOJWgGx/oIW+xmQpwhdoPFo+D0chcGR7bJClmyC9RA7VHq
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="349817898"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="349817898"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 10:41:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="546732864"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 15 Jul 2022 10:41:02 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Jul 2022 10:41:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 15 Jul 2022 10:41:01 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 15 Jul 2022 10:41:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ls5lKLeR2iLaWqpIExkBIGznUt9feAvHpYCu7HyvL3hbwgeLSkCGeBw4/dZuMF7uS1Tbnd2I7EWiT1rrdlBEUXAix6F+1u7UbfgYlfVPbF1jAcN7pRianOAHqibiXgG3Ysk2vIruMb/WXzYqKLUq1uygxnP6QZSLmza1jmyKlVOvOAtlEPTFJG5CZw8LJMsuPNrgNS6zuIXvESWSRNo2TcTWmzEahnV7MZbySvKgg43R+Dt3Kbzk4ZORR+owVKjGm7YQKEiM23u1Kw74a0/APGwkJHasQe8V5lZYYKoBWUD5vLhBj+5TdzbYy3v9c2nm2SClqjethGInqEbvcdctaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGHAY6T1Q8ZoJhutcXW21jf+LmvfUa1jJ2/1VkWAxVk=;
 b=iyY9fTxM3p0aVUrdoi/O14yZ/k0cv/WjVxvHQbYzaTXhiTtg6uvWLrikbclxUZz2dFV3pCkAE5Jhzplo65O3Oi11sxsEimJakJCTmbTcLYnGQsbnYK8QP58eVdZtG7eqrItEscDbargxb4ThKb3jbFsYd78pl0F9U9r076CrWf0EgODxP0Ntifi2BzmJI8Nm2Pv5gNkq97PuIaJNBhED3KZfE+aGRKksHqYOEwd55obARiGuUBtmunI9kuZTwKkm/jmDRqN0GVbeI/Sv2n4qHufy+xGxdZJ7o6pgPcJgTB054IhNRsps52bqW/iPkCPr2hE4KLsfj9ceyz7Km2By6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5140.namprd11.prod.outlook.com (2603:10b6:303:9e::21)
 by BN7PR11MB2531.namprd11.prod.outlook.com (2603:10b6:406:ba::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 17:40:57 +0000
Received: from CO1PR11MB5140.namprd11.prod.outlook.com
 ([fe80::7df5:5cb6:b4ff:fb53]) by CO1PR11MB5140.namprd11.prod.outlook.com
 ([fe80::7df5:5cb6:b4ff:fb53%6]) with mapi id 15.20.5438.013; Fri, 15 Jul 2022
 17:40:57 +0000
Message-ID: <cb2861b6-c453-b230-00e6-0988f8cf5b1f@intel.com>
Date:   Fri, 15 Jul 2022 10:40:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next 1/3] ice: add support for Auto FEC with FEC
 disabled
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, Gurucharan <gurucharanx.g@intel.com>
References: <20220714180311.933648-1-anthony.l.nguyen@intel.com>
 <20220714180311.933648-2-anthony.l.nguyen@intel.com>
 <20220714220919.4167f8b5@kernel.org>
From:   "Greenwalt, Paul" <paul.greenwalt@intel.com>
In-Reply-To: <20220714220919.4167f8b5@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To CO1PR11MB5140.namprd11.prod.outlook.com
 (2603:10b6:303:9e::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b28155ef-6647-4b9d-0200-08da66892c88
X-MS-TrafficTypeDiagnostic: BN7PR11MB2531:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KM7MBO0L6kvsM7tYEw/YGueIP1FDsX7wtCZhQTm9c8sWG/1Dp2QVSqUHqN0Eept9s1KFL3apQL0waa+bfRN1KkUywoxFEHL4ljZcWJ7PKd9RVYkIf60M4A34Jwt+Yabfun+PE4FULBE5Mkj9DBd5B0bePxEEqVJTD32xSeqUruDbNNZagEJmQCqwzhnBpXtdTkGGK4p4j0b7+mL2xI+C4rKhFj5vuXugUuxiuhNXUupzpdnDR0zLOthYrHkAaQoeHMzM7pMBAaQXieC1Ck1zpOL6EzzAX4TTdAcpP9vTzFE+GFtHUYntTmINgE9+NvWPT8JOZpXHFrUGpxtx9ssTVtMh9aH/IoPwTf972B/FOogBthNXVyOsc+1NhIAsQvWRRotm05svuD3q37SYaOpMKy3MZVOZWrxfZjT0wsnrEIpBs2102+tKUHOGAjGBlVieaOQ1bUMOoyKTv/y+PY5c1TvSqW55TISUu0Uv8edCEaLFuqtnKiGhyp8TFJ0uC6iOlKnvH+XSp0yogZ54YQbTtB7p4M11Jz3fzUvXIN4d5O8qZfqMPOA8lfB47gngIyt0enMSzWZZ+WRSBi3dG9tt0HKkJKEwdUTXsWfwpo3k+iG+3+JEIhAgED0FOcTfQcaXqaTxdOc8d8le5k5UP1j1M6FOjlyh4F/DqDYP9pT8bSi2xxGZWKlwMT00jCkmLoZmXHmFX98nIH7QoNWTV+oXv8zO1+yWwfw5eiA+5eY9mDBnHt38HEPTE7IITGBKF7qfstL7BltW9RsjNYTGs/9Lp9Elkez5kaTOfH8OkWBMjzkJJAxSQWiyuJeDx3c1dlnGz6R56EafzCHY4UO7bvpOwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5140.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(376002)(346002)(366004)(396003)(2616005)(107886003)(83380400001)(6666004)(2906002)(41300700001)(6506007)(53546011)(26005)(6512007)(186003)(31686004)(36756003)(66556008)(6636002)(4326008)(86362001)(8676002)(6486002)(82960400001)(66476007)(110136005)(31696002)(316002)(5660300002)(8936002)(4744005)(478600001)(38100700002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S01SVnpMMnVOdkFwTWd6aTZWdWN5VE42L0JJeURJU0tOaFh6dk5FUXA1WkdK?=
 =?utf-8?B?cUZmT214QlNaSVN4aGc5MXJXeWtpZkVXakJaSVAzSjlNQ1JLVjE1aUtBMVN0?=
 =?utf-8?B?TXV4NjdTaDA1Q3l6L2krMVRQNGRpbm5hWTlld0ZtdXJIeFVVZTJSNm1xYjUx?=
 =?utf-8?B?QWpWTVptNjFMdlI4T09mSlhZRWZ1SUlnT1lwWHRtSmpRVTJ4S0s2UFVXQzBx?=
 =?utf-8?B?M3ExMTFtQ0FJWVc4Q3RKQU1sZUV2VEZOcFRCRXNxUnYxUWhoK0pQN0NjMVov?=
 =?utf-8?B?ZDZFU3MxeDVtYk1jNWVVeUMzUktzTFgzelRQcFVZOWREbWs5WVZxTU1CUTZ3?=
 =?utf-8?B?ZEYrL0cwS3JaeHp5dUFXSTdxcEdIZHR5SmZqNFlEa2JzbjJkY3hpYnZhdGR3?=
 =?utf-8?B?aU05YzJUVkNXN2R6U2pJaXg5RTdCdlFDT1NEOEt4MmZCMDRqbTFIWDdWYzhD?=
 =?utf-8?B?L2ZPcmFCOEduTXUyb1RMUVpZSzdvNVhRcDlyOFl6SDFrajF6aDJnNFNUSjR0?=
 =?utf-8?B?T3hJZTNHNnJLNUo4eS9rOWs4dVVaVndQUDRiSTFyNkw4aElsKzdVS0pZKzhx?=
 =?utf-8?B?OWthMjZ5OTFSb2t2VEVwWjJ2MzNjN0hOV25Dbjk3T3dtZHprM1hYRStIVFFE?=
 =?utf-8?B?aXlEWHBhczIyRmFIMlEyRlpENUdwK3V1R3lndlJHVlJnVnpXREh1c3MzQVRz?=
 =?utf-8?B?UHRjaHdXMFBiZmE2aGp2ZXk1Sk5JWjduOUszZXRuRDNoN3hCWnZncHl3LytY?=
 =?utf-8?B?Q1A1amk2ajhLMEt1QmVZRDhnanIrbnV0NE0wbGVjVTN3a2RIK084MkdZM25V?=
 =?utf-8?B?WTcwSTgxd211UjhrQVB3N2ZEd0ZjYVdTSTJKN2ZTYUdPNWxGNnA0dWFHSVNn?=
 =?utf-8?B?S0xIVkExcFNqOS9rRVdsc1pNS1hkVlV5bStDNU5LYzRVZGlENVpMNG1hQ0k0?=
 =?utf-8?B?ZGJzV2RVbzQvekRJQ3gzczJjNGw5TGNMbXM1dlVQQUphalRrRmZXTjBGRzhG?=
 =?utf-8?B?a0RJSEV4U2ZNRUFHWXE3eWhkVFM4eUpZMHNYWWVsVU9JdzByaktVUVdaRTJo?=
 =?utf-8?B?VVZWT3R6ZGc1SmlmcTdyVVNSM0svbVBXOTFNVWQyOTBzSXVUWGFKdktEa3lZ?=
 =?utf-8?B?OHBCR0VYWVJ2M0N6VStVYVppVCttNFp2NllhSGdKRS91QVNDVkF0eU8zZDly?=
 =?utf-8?B?U0c3OWhXb2JzaUpoaUlIQmFGVGlIamkzdWZnSHRNUjJ0TUdibHIwNWdSWkpC?=
 =?utf-8?B?RWtFc2dIM1EvWktTbndjRWJRZFJRUWg0WkZYazRlajcxRTBmYkpKaWlNQm9N?=
 =?utf-8?B?Z0RxWmNzdm00a2xLa2hFTldsdnQxaDlLMDdQa3k3WU05aDl3ODRJcHJXbUJj?=
 =?utf-8?B?Tk8zNEo2QStZbFh0dm5pMnE1SFFlb3NwOS9Ra2RGa0E1Znd6U2xCRzc3L0lP?=
 =?utf-8?B?czBPVk1oUkFlSmZhU1ZUbGpWM1V2MzZsdnBRQ1VaZ3JvWUVndGNPbHVUK3Rm?=
 =?utf-8?B?Vjh1OW1VMTk1TWhtVEhnUy91M2ZiVElLYUlsMkFGclF2Z2ZndXNpRnQzS0dI?=
 =?utf-8?B?VzF0N1FPTEV2cWxjaDJUcngwK3ZkaEJzZ1grdlZ3K3pxb1Z1bitoc2JXUGp6?=
 =?utf-8?B?K2pTYlIzQ2QzL25NZ2UyR0hFY0ZRSXpkeHZhN0JoT0RlbWFBazIwRXl2cTZl?=
 =?utf-8?B?dzQ5YTB2RHZueGxzcDNjMlk5NEM1Y2drb0RKZVA5dWFUdnoxME04TFh3NmxF?=
 =?utf-8?B?VGRRUW1xcGNYVGh2b29iM2xWVGlub0RYb0Z0VGtSQ0tCMERYRlRhZWZMUkta?=
 =?utf-8?B?V2laell0dlZoUEg3ekt0OFVzLzJ2cGpjZUVaMkZPUncrUUFMQ0ZUSEFmWlFI?=
 =?utf-8?B?bS91NDg3T1JaWmlDa0tlVXFuWFpnT0xYZXRidnN1YXVPRTRnYnF3ek56WVdT?=
 =?utf-8?B?K1JEY3A1MGUwNUhhbXpHV3NEeVFQQnNqbWZwSDBOYk0zdElXSkdJVkRrNWdP?=
 =?utf-8?B?aXpBRXBVYmg1YlQ3S0s2YW84R053dUdDY0c2VVZXUG8rc2NGSERObW56OW5S?=
 =?utf-8?B?R3BSRnI2WEJEKzdaWWpTeHIvU1dwaGhUdWVNZ09kYTlmRXZTTWE1U1FndHZu?=
 =?utf-8?B?Q1BuQW0zQVRBd2pCRFRZeDJoZzVWQjZiQ1Bma056VURFVFZJc0N5UWxkemFs?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b28155ef-6647-4b9d-0200-08da66892c88
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5140.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 17:40:57.1884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNN0kKjIL+qPLi/AbUTvQ4f85hBZD35G/WJ6Lnv7bgBYtZdn7b2CsgNXVsh00+lBWOmWU4AbeQVj2YPK9bP9EFwojnwnU2IyptSI3tXYIG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2531
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/14/2022 10:09 PM, Jakub Kicinski wrote:
> On Thu, 14 Jul 2022 11:03:09 -0700 Tony Nguyen wrote:
>> The default Link Establishment State Machine (LESM) behavior does not
>> allow the use of FEC disabled if the media does not support FEC
>> disabled. However users may want to override this behavior.
>>
>> Add ethtool private flag allow-no-fec-modules-in-auto to allow Auto FEC
>> with no-FEC mode.
>>
>> 	ethtool --set-priv-flags ethX allow-no-fec-modules-in-auto on|off
> No more priv flags for FEC config please. Use the ethtool --set-fec API
> and extend it as needed.


Hi Jakub,

I will look into adding this support by extending ethtool --set-fec.

Thanks,

Paul Greenwalt

