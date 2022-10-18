Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A477602F63
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 17:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiJRPPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 11:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJRPPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 11:15:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042AEB2766
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 08:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666106118; x=1697642118;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Won+VEAgh5dlnhTBGygZ18wby7nC4mIxjyn2T2ZB56Q=;
  b=gNXEOjlTmiERpt36cQ/o2keuHd1Io69orKoMRw6gQZ5f8W2pkOZ2j0Iv
   QBfZwAEEO4/Tb4UUUKcuDWrSu3ioPh+WfV/HRdi0BAVmDmBVPkMq6E299
   uckeJDlpEMNudVnzrA5eEcQeLwBQJkQo+GkI76hRFbK6rJ+igrgnqxSy+
   U4FpS7Tho70EpvwpaBDGbSc/vqX0MghQppgvwqNGMvecY9lMGmXrngk8g
   YiTUDFpAoW1qOmuVwoLeHE/QhEvZBMYl8LGhPO3yeUQM4SS5GTZ1xoFV3
   OyHQSVseHnfPSXKwy9veeWVBh1yoecbkmCfFfZVOdP9joZGkwd+qbitxA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="332681810"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="332681810"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 08:13:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="754091168"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="754091168"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 18 Oct 2022 08:13:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 08:13:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 18 Oct 2022 08:13:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 18 Oct 2022 08:13:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwUjZIQjjY+oJsIREsYqj6/rPZf9EGALWwX/g2eLJImm7S9wXIZzSmh+9xMKIJ2aMEBmvRSJHZ6kvkScaiTtDwQkLW4ooAdaKa4d9pex0xYiOJxQeW1BdanCtxRyPi3guzTYjna1Hgeg0nRUtGOXB/JwRCSTZSrriStoJoND2wZfXHAlASEFdSY2k1lv1pE67oYbAMf5ZZVYc+1y39Qo7XdkXyiS+6myRnUKMu+wrWqGY5sOsSP5/i3PA/C/zpAyxiWo13Cy1eT+yOTwWTgTAv83utfmPh0ekZ1AZGi5QPLpo7ZATzriMxJ2HBfcHNNXe5BOzoutUs8H2CKAji011A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Won+VEAgh5dlnhTBGygZ18wby7nC4mIxjyn2T2ZB56Q=;
 b=PFGV2oUmwp+NU3RJU4j4JUL4foi9tFX+xlLrh/eGm/QTNcCgUe1Rm4roGseXclDhVePYi7TPeirvAALrhm2sSJWEt+TBc2PG1mfXlVs//IRTdwYJU1HAlT/a3aIiW9OnUUJf5Rt8In3qagU9HqyEUU7rxEPbuwzHMnEFBmtGDDjxQ1I5DhbMAhRIpERqB5OVfH51HTJ6eKb7IMCQsvsC2RdhS0hg/8XN0dgq8ntbDagHBZjjy8QZv2rGvGIK+UXv+1ogXBDiAZMC/dlowyBeRUQE191TxaEkml6+4tzyislYd+vhSKU+Y02g86oNzosogq4I/QqUpYot+TSpyZUdfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by MN2PR11MB4726.namprd11.prod.outlook.com (2603:10b6:208:269::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Tue, 18 Oct
 2022 15:13:36 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 15:13:36 +0000
Message-ID: <9f73fcab-5374-81d8-1069-6a7ad0140a2f@intel.com>
Date:   Tue, 18 Oct 2022 17:13:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH net-next v6 1/4] devlink: Extend devlink-rate api with
 export functions and new params
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <kuba@kernel.org>, <ecree.xilinx@gmail.com>
References: <20221018123543.1210217-1-michal.wilczynski@intel.com>
 <20221018123543.1210217-2-michal.wilczynski@intel.com>
 <Y06zTYTdNPJAKfcw@nanopsycho>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <Y06zTYTdNPJAKfcw@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::6) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|MN2PR11MB4726:EE_
X-MS-Office365-Filtering-Correlation-Id: e422613f-71df-4558-3bfe-08dab11b545e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3qCUg27lQimt/lslwwv/BsJuyJnA7rwTzolKU1Au3LEHGzUO6q0INV8JYc1Lw/BHtUA3N3LT8jRDyUb1g5nLMEaUAAgwPpEMkrq5ZsRQhYJM+gVyi0wDL2j4ImXkAnXY0b7YzVKjm4FsgETi7LcIiDVQIo6Yry6NE+l0jiUUZ90W+JP9IHund3FlD+FkTv5uJQLAALDPkNs5firum45xaORby+ihgjcBsSlgCYENUqqUnbRDMIyAZUOuKRujunnz4LRyeJQMzKcDXMf8D1X2pkfx95ItCUzOzNOt7RKQ2jwA3Z2WTFx4Dlzgb12n1bXc8askn5LJNnxKMpT2UDN0HTtS/UKc6hzYgvBvfTv7GLtXc1WAAYbwB63IDVt1LTx06ykjO8+S9ZkMsPuQSkxjreC8wUbiRO8lwn6lscu1ftD7WNyIJVTtV0lAEY6U+ud6YEN+5JexD3hiSzeYYM+USnAhHDk0/VlrZpbNW3sZIiU4XOst9gV9/kAFKXzTc607VRnFl4U8JP4rd9XJLaDEX97fFh5CvMQRMHUgaQ22l/hq60eFhWJ4jKD6CJFhwV9UA+zJn0v65RKHt5tdYvAS9a/vEArdT3ysswpO0AVZgJrgRvCWBM8OZTOk+bMg95szQdHip4mjrVKoVaWdwlwYv1MCpDJ075I0Vhv/JDBVxwpS6TlilzSrFxA2lU8Sw4R9Vz8j2pBN7qMsCdbj1nLhq3vCPZnaHWpdOwxP3lTKudcedCXghlXu8tnmz52QHOnMv4JBMLJ6MtBiopX7euzLzhV/OGbIcXcWINLV9LIcct8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199015)(31696002)(36756003)(86362001)(31686004)(38100700002)(82960400001)(2906002)(5660300002)(6666004)(6506007)(6512007)(26005)(186003)(2616005)(53546011)(6486002)(478600001)(316002)(6916009)(66556008)(66946007)(8676002)(4326008)(66476007)(41300700001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2xzaDJ5OUtWWGxMaDVudHIvRHZQUVo1a3IvUkplU3Z4VjhUYXVNZHQxSU9w?=
 =?utf-8?B?cFVSQ1FNU1lFa0tCL0Z0QUl1a0RuL2cvWmVTengwalg4ZUltTVFSTWJnNHVx?=
 =?utf-8?B?cXhZdkhOSlM3NHhDQjRaWitYS3lxa3JPSzExd3dIN0VCYml4am4xUU9RNHJa?=
 =?utf-8?B?R3VqWjJsNHpIQmkxd2phc1pveVZObkR1MjduME45YnhvMERQaWNrSktjU0JB?=
 =?utf-8?B?K2crV2pmSEJ2U3BMQkRpdXQwRlJwcFlsRjRvNGFqRGZZbkpVUkh6ZUdrTXNQ?=
 =?utf-8?B?NnpZZ1pWMXNsM1pRNFJUZWxPeTg1Q0hIekZ2bnBHOStrR3dia1FKYWhMRERi?=
 =?utf-8?B?eGxWNEpHSzZJRDVLWE12d3pJa3RPRzVWMDBvcVc2bWtzYmNpZjNaa2xSNTg0?=
 =?utf-8?B?QnN2dkZkL2VHV2JPWkRkVHVJaEJCYkxHNmJIaTlneW5vMnlCSlUwT2I4ajdj?=
 =?utf-8?B?WnMrdWZSbHRzRUFwN2h1d0lGbU54dURHclF4TjRWaEc4VjBSOXJVczJyYWVz?=
 =?utf-8?B?QXRYZTduQ3hBOExWdmtTT3dSYWlyZUsyZHE5bTVBaTNlcTlrOC9FOUh6Vi80?=
 =?utf-8?B?eks4MmVZVFV5R0tjdGsrNzI4RTVTVGFRaTBiT21ORlJhZUsyTVErNmh4bVF4?=
 =?utf-8?B?QWFHVDQ5RCtzOHZvUndyeTFpN1dpSXZMN1dZT0JOdjhsc3lvdElPRG83bFdU?=
 =?utf-8?B?R1BnUnlMczdma2JyLzNmZTJQeVRWZXh5aHIweEhjd0Q4R2xES2VPcTlhTFdE?=
 =?utf-8?B?WVU3WCt6TnJRQ3NXQk05ZDZ3ZzE0SVZleVkrMUQ5Wk1xOVZHUGhjRVExK2ll?=
 =?utf-8?B?bVRXNDZMK0ZIcGN0a1hQdEl6QTBTTVEwbTkzbVI1enhXSXFxV1A5aVVNMU9F?=
 =?utf-8?B?d1FieWFzWExHbnA5NEtuMkdXTlZKUlh6Q3FqV1piV1ZjSlcrZDE5VkV2cGVs?=
 =?utf-8?B?UFhiNjdqWDdvSHRPS1FPU0g3R3dQNVRlODM1TUlXcmNtTnorMlRYdmQ3dlBL?=
 =?utf-8?B?SVkyQjZCZ1pVU29mWVgvZWQ5VElkUTdNTWVDTG9IblMvamZSRUF4WUJMQ3B4?=
 =?utf-8?B?Vk0zUzNFMG5KRTBpVzBKRy9NYVVwenlnUmtVSHJqaG90U1cvZ09jZi9OcnRv?=
 =?utf-8?B?V0F4eDhQRjVGUGhBUEVQb1ZaazRkMFpYRXdTRmZxQjNZWlpaWXk5Q0FKbWE5?=
 =?utf-8?B?RWRQZnhaMUhTaDFhREVpdzVnUEpud1ZSQUJBaVZOVXg3clBETzdpMDc3ZHFs?=
 =?utf-8?B?Qm9nYnp4c0tzenRLL3JRVGF0RGFoamNZUmMrdHBuRFlDN1FRM2VwZlpzTVAx?=
 =?utf-8?B?U3ZTYkh6ZmJNdGtCcFdTRjVYYjVoUlIzWUVCQTQ3Y1hwTTRWcnlKS2c1ZXJW?=
 =?utf-8?B?RzBhdThVK2tMVWJsMGdzeGxkT3h2cG45ZXhtZnlEVkVsUHJ6STVQd3REQ1Zp?=
 =?utf-8?B?Y3BxZXVVM25aVTM2Zis1ZDYzOW9JS1pxTk1pMkwzS1BYWkVYNStHQ0I0RStQ?=
 =?utf-8?B?ODN2WnRqQ3RxZWZVRUpLcStrSTR1aWkyMWFXbUFoeXZ4TmFmU2tiRGxHaFZn?=
 =?utf-8?B?SndrRGwwK2dGM2JrM2ZzQlIzWmtQYjd0SFluMk5qRmhtRkV1WERQWVBJQlYv?=
 =?utf-8?B?MldpZ2RYUk50M0dxdmFCd1YyYldLREljWmJ2UjdyNk5ab0xpbnhWMkQ5K09h?=
 =?utf-8?B?bStnd3l0NnR5RSt0QkRCK0g3OW5XeXFZZ0U1QlNzMHIwSnlkRkk1ZHBIS0NX?=
 =?utf-8?B?ckNHWWpsUXZPNC9BOWRjSGJHNnZKTVBhMERsQXoraVNQS1hpdlFFT2R5UEFs?=
 =?utf-8?B?eUNDb0JWemk5WkZQYmxPOENhVGE2N3V6Y2FrT0x4MDlVY25BU1c1TXJtWUF2?=
 =?utf-8?B?OGRhRXZxUzEzdHNHdUd0LzJBWVJIcXZDaWhXM1JwNVlaMWdGYXY1WVpDRzJn?=
 =?utf-8?B?TVI4QU9CUCtWTVBZMHFCUVlURUxFKy84eXdWUm9nbkUvYkNCMUMzU1Qybk1S?=
 =?utf-8?B?dU9kWXBjcjFkckFRMGVrakdyMG9hY0tlZVU0N3dCV1lCT3ZkREFOL0krMTB3?=
 =?utf-8?B?QndSQk5NcVdaTTNwblhFeHdyQVdoanY2YkdGNEJzaTYrcXlLTWthNzArdHpl?=
 =?utf-8?B?ckI4UUxRT1QyTmpvUys2eXRyT2gvbnI3UjRTR2dQRnE3MHk3M2h3eGp3VU5E?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e422613f-71df-4558-3bfe-08dab11b545e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 15:13:36.6853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aaKt8i8Wjtczdg5Jfr0wLu7OICN1Znn/3EwqS4q+Xun9CC3GyPiRSYrTjYcFeQG0s4tdXCeJCwQ+8QfIgjYhRbi6GZGD4vULbW6feyEFZWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4726
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/2022 4:08 PM, Jiri Pirko wrote:
> Tue, Oct 18, 2022 at 02:35:39PM CEST, michal.wilczynski@intel.com wrote:
>> ice driver needs an ability to create devlink-rate nodes from inside the
>> driver. We have default Tx-scheduler tree that we would like to
>> export as devlink-rate objects.
>>
>> There is also a need to support additional parameters, besides two that
>> are supported currently:
>> tx_priority - priority among siblings (0-7)
>> tx_weight - weights for the WFQ algorithm (1-200)
>>
>> Allow creation of nodes from the driver, and introduce new argument
>> to devl_rate_leaf_create, so the parent can be set during the creation
>> of the leaf node.
>>
>> Implement new parameters - tx_priority, tx_weight.
>>
>> Allow modification of the priv field in the devlink_rate from parent_set
>> callbacks. This is needed because creating nodes without parents doesn't
>> make any sense in ice driver case. It's much more elegant to actually
>> create a node when the parent is assigned.
> This should be split into like 3-4 patches.

Sure,
Will try to split and re-send,
Thanks,
Michał


