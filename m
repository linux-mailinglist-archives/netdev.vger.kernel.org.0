Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39704D687B
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 19:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350919AbiCKSiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 13:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiCKSiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 13:38:08 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CB5D198E
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 10:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647023823; x=1678559823;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OYNPV+tiBmPoDZQwUeSgGuz2vXHvNVtlOe7O+PdHrjE=;
  b=hw5iP2KVdwY1FoOR3TIvArviI3Eb1R8tlaNnaXMP/epu01RI5NqZSEgb
   HG8G+9K45mD8MTR6MYnSUd32YlVFpMtns874rSX/WAyzt2tdO/L3LjvF3
   253LKoOibOLixlz1jPQv9Q0b+7KDZKTjG2eeZpIxMyxX/VZ58wlp24+6M
   ikofszEOYwyOS0Mjsmuk1c6jORq/Y/etSaZs5IJTNQoigRPtjbThp/Ol+
   ANYMIigqPSEo2osDlJDUd013ZZFdRzbq9x9WJ1mbPYUA3JpY55EFmS6x+
   cKGA7RooPQfcX5k36XmbD61WuPfrjSCaae3D8asBXYdfLQkmb8j6cABUm
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="255577121"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="255577121"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 10:37:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="548536693"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 11 Mar 2022 10:37:02 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Mar 2022 10:37:02 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Mar 2022 10:37:01 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Fri, 11 Mar 2022 10:37:01 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Fri, 11 Mar 2022 10:37:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dx3Ja6YBHrPHU8mXoaxVZqs51l7I477ffIgPW34hBSi0JF7YVNecCDjSm2OeScWXJWoQ9k4yPlSwRS5eLd+IHElNQycuUMkD4Kq4LsdZL55VZzp641kpX44O1em2MlS1RPo17vhIiK65efgGvV51oF8O6nb32CKoEfLJoTVEB6wzyAzSJDDpG7tX4qdBa3ltkRf2+Ftbpfafg9VAOpbwFxJbQswAaPW4e3QVoyY7Zb7chxp5cRAZCgQag7jX2IGQqb6QJIgPqZ6JeNxmdQwWiXl6sxjyFopXZnCjgM9P7eWo2DpWoISqs51Foxmk008bly0fgBJptes5MlvYvRGP6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jHGVge+/kkbpdHioNYK5t4aNSkm/t50ic/2VeOA2uk=;
 b=PxoiPu40/8a7We9cWxdB3WurvxWhRaYTJuRpt1EjwpGuEMJ0HkBP0PCWk/j7252oA8GggDBNJLx9d3vpYYFD6W+OIwwO6lgZBE9mE++syMXLZnmwiSPjQQX2P3TD9asU6qE63j4e0vZCkziF147myFp1/Ruiss4aBWyzSPLe3CoAJcgwQIaU7s5FVD4S9b4u2T0bPskaIb8kNo+Z71+xMGzU588kUZOLysvXcUzTRJDKUmHi/YQLY5mM88RtSjTSiKnkjdstsOQH/Q7wXIAw8+GCqX567QVa+qNA7cFpyH39AkfDavqERXGp0ny14NmTzfZrS7CZj0VagufRQvB4Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by BN8PR11MB3601.namprd11.prod.outlook.com (2603:10b6:408:84::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 18:36:59 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::ed3a:b7cf:f75e:8d63]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::ed3a:b7cf:f75e:8d63%7]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 18:36:59 +0000
Message-ID: <135a75f8-2da9-407b-40b2-b84ecb229110@intel.com>
Date:   Fri, 11 Mar 2022 12:36:55 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next 2/2] ice: Add inline flow director support for
 channels
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, Kiran Patil <kiran.patil@intel.com>,
        <netdev@vger.kernel.org>, <sudheer.mogilappagari@intel.com>,
        <amritha.nambiar@intel.com>, <jiri@nvidia.com>,
        <leonro@nvidia.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
 <20220310231235.2721368-3-anthony.l.nguyen@intel.com>
 <20220310203416.3b725bd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20220310203416.3b725bd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0048.namprd07.prod.outlook.com
 (2603:10b6:510:e::23) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f7e23f3-be04-4d64-5726-08da038e204d
X-MS-TrafficTypeDiagnostic: BN8PR11MB3601:EE_
X-Microsoft-Antispam-PRVS: <BN8PR11MB36017A048AE1DEC43C988B71E60C9@BN8PR11MB3601.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 75Nt6BUSqwuWLsWRRWVpa7ChfwpzzRrTP9zj+t9PpcISjjpEjc/MwbKMeawnkg32sH5AXdx4n9gPC35HEHEn/0DnZ6MAA7mVkGzxHgICUHFF4nhhQgIehWwmAOKVsShSwi5U32oLB8oGIcpFC6kDiDoJMuZtyv58clo07c667a0vzj3RU5IutdFKp0l1718Btmf8V8wQA6Vk0hgWI9iSW7Mmh7GjIdQDpOgyMU/SfPNpFW2GuzMAOobsYRSe2exXhclB0Oqqkma7fbYmTEelyzMNhffivaVrDddXlGhkcqOiIdRQvggkvIN+yXxuQbGrivl0A3gr5uixnFwFNfW94cuPyuUzxu10kPa8p0pItkxnCG0Vpn0QGggBWYc+7VoiU3quoAgT8ktCfQQnqujMVDPz3eTpg9WcFMmLl9WKDAislk5LFq7WMs8MYaK3pQMijm4tXhcEsj4EpRsLZRSlkDA9Q4/7YAhgI/537MDR3omxCmbriFFTuz6DD5yeh1HvG6YVJwCmdSgwZ3tG0tZ8+zeNNhv0hvnI3pW/RDa7AePdyOgd3JBtdbNXo0HhLzKJ4c6aJL7rEzt4NPqCfh0b01FRZzFB/k5IngkKujOlPECfX7DXXXfHwCkpVeGA1QR5eBfAa7W3IUMHyOrcPn8mAX6rYlibYlPo+8zZnq9vbDZ/f/9AMHRoi3gb2HHEfnYZmjRe6yha6TmtpZIRcbNRBScZ6cekpmU/4vckPD979FOrmalcU16S8rM0Og7oSzgC4ZguVzv+6xC2TZ8nHD2AIG3Q+ougjA2ShSzev1WLWFBQlLi9Xh/OdKDz5GyqBpbk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(966005)(186003)(2616005)(31696002)(53546011)(36756003)(4326008)(8936002)(6512007)(86362001)(8676002)(38100700002)(6636002)(66476007)(66556008)(66946007)(31686004)(26005)(316002)(110136005)(5660300002)(54906003)(508600001)(2906002)(107886003)(6666004)(6506007)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THpSYkFiaW5JRWVZNnhaV240Wm5zdm1yVU1VTFVqdDBQWkVhSUF4LzkvMWJR?=
 =?utf-8?B?amZFY3RYOWgrOW53S2lweEkxRjVPZmV6REdzSVJXTTk3R0pnUHNUUG9DTzdF?=
 =?utf-8?B?VHVtaHAzV2RxU0k1RUdJaVpZblNYbmh4VlpEeWdZenZuZ3QrWEtCTlBwWFdy?=
 =?utf-8?B?TFVsNGdKUndUNTRLTUZsOG8yVGIvQmVjaDJQVlF6RndLc2NTeFZUUmhPUGho?=
 =?utf-8?B?dFVpcDNjVStsNmJKUjdpVFBOd3d4OWZjcVYxdFhVVk5rNlErbDhWZW1oVFJY?=
 =?utf-8?B?RjF5V2l6dFJWNUpBL3kwZnE2L09oNGpaVUZtYkd5ME9mcmZZVjdnVTVTOEI3?=
 =?utf-8?B?ZDkvZGhLZ1dHNUNRSFNFMGNtVDhxNldjL0xQUHRyU2xJcS9sYjRxemNOZlhW?=
 =?utf-8?B?NzlUK0M2MmFKRHlKMWtoRFdCLy9KamluclVZOVNJdXlxQ1pDRW9nbG5XczUx?=
 =?utf-8?B?RDd2ZVVpRkJodks5dzc5T3BxdnZZMUtja2NYK1FoQkxlWlNGUVE1b3hlTXFY?=
 =?utf-8?B?RS82VTdGZTNMbnp5NHBjMm5KQVMyRUhzeUIwWVBvN3dJZkd4OHJZV2ZUWnNu?=
 =?utf-8?B?cWNyNTQ0S2p1Q1dzdnRDbGVTUEpOa3JsOXZvTFYzdlgrSjJIZ1NaM09KQm9U?=
 =?utf-8?B?RFgzcXFBS0tVWVlPdll0NGxIUkhxV2RjNXg0UWlaQzdjVGYzdEFuRUxPYkFq?=
 =?utf-8?B?ZTlQL0gvSW0zVXBnNElHTWM2WXZlV3ZKOTVZOU8wekVIRzYzV3JKa1ZFZWFy?=
 =?utf-8?B?NnIyaUdMUmlqNmJOQU1xT29UOU02QmdiTTZsOFBwd0tPU3pIdS9oTnlMQXJX?=
 =?utf-8?B?UWRDZW9ZWWpiUHpIQzNzd3ZiWWE5ajlSVzlLK3BGdlJFKzRMNUZkTlJvMmd4?=
 =?utf-8?B?aGJFK3pBVWZwTTQwS21ZbDJQR1RGS1ZMSHlEZTZrUGtZTzlib1J1QnpGWTRI?=
 =?utf-8?B?TjEyc2JERk5weEVQWS94cHZrbmw3VlVnU1pibkJybFU5SlAyRGRuQ3RPZDdq?=
 =?utf-8?B?c1EreDRGcUJBd2J6VkxyRHRXYUtJNmU4eFBtaFNyOHZiSmJWQ1RHZ0Ewd3BE?=
 =?utf-8?B?MmowZHFNQWxVZVQ2Ky9pSnZTWUEwQkxQNS90NkVEVHBEUjVFT2JYb1lPYjRD?=
 =?utf-8?B?RFU3bFhLYXZRNHovYlZIUGhLVmVpY0JPZTdtb20wcVRRMS9qUGZzQ0FUSDRZ?=
 =?utf-8?B?UEdUVVB6SHVyblZ6dXNuMTNPem8yLy8yZGNvQWh6VHBpcmxQcWplQUgvNjlt?=
 =?utf-8?B?aDh3bGRkRi9lWmw0eXR5NGNQN3psaHN2TmppMmxRTitqTTR6UDJVQjZEdHY2?=
 =?utf-8?B?WUdCRVU5cU8wMFVSZzhJU0NzOU5RQ2w1NExHczdvdmgyVVQvRDduSE9makd4?=
 =?utf-8?B?OXZhNERmbENtSUQwRzQzL1hOTENzYkRvdng0WjFwVzljK0xkbjZrNGF6MmYy?=
 =?utf-8?B?cTBKZGFJZFBRRTEzaG5JcENhODlQdGZheVBKWGY2QXZ5OHV2NWRYZGk0U3pF?=
 =?utf-8?B?ZE9Td3ptZnBNYmRucU1EdGlVaTUwc1lhS1JoNVBEREEyci8zdk5rRitOdHpB?=
 =?utf-8?B?ZmVZM3JpZ1hhMmFiaGxXcWlHTnpoRkpDWGhhUHhpeVJENDRzV1RjTXVGMkc0?=
 =?utf-8?B?bE1pVEtVSW5wQTBsMnNPRjNOQW1ZYjdpUENLNy9KQVlMemRSbXNiZEpxUVJI?=
 =?utf-8?B?TW5GL1M3VUJOTzFqdTdqa285akZaQ2Q1RlBJc1RjT1NKWkltMzNIOVBpcXBZ?=
 =?utf-8?B?TExneE05S2xZblBNRGNwTjVLNHpHZHY5ZVU0QlZyRFZnRjJVZUp2aS84WmU2?=
 =?utf-8?B?ejllSVZvY0Z1SzlnMkZmc3lXK3cxbWs3K0ZkaTJEajY4NFh4bTRMdmNZRk96?=
 =?utf-8?B?VjVxOTA1L0tFZ09uRklNNDd4a0s0QnhQQ0RUcjF2YldKUmV0ZG5mVkhPY2p6?=
 =?utf-8?B?WnlOUmY1bnhXckttQmkrZkZkeTVobnRnc3dQZEY4TVljUkdpWmJBRzI1YlN6?=
 =?utf-8?Q?bdJUs3DPuNQ2s9OU8nycrA7NKr3HB4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7e23f3-be04-4d64-5726-08da038e204d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 18:36:59.0706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pT0Oow+2I9eYFalMHlnFkGZnt+9VQ4T6eNLfr030oQEFm3jjPa2+SfiSI7XGaV3ZbXt/rUbMQqIReSHHt9W7Kk2q77dAQnWTonQly3EUOFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3601
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

On 3/10/2022 10:34 PM, Jakub Kicinski wrote:
> On Thu, 10 Mar 2022 15:12:35 -0800 Tony Nguyen wrote:
>> Inline flow director can be configured for each TC via devlink
>> params based interface.
>>
>> /* Create 4 TCs */
>> tc qdisc add dev enp175s0f0 root mqprio num_tc 4 map 0 1 2 3 \
>>               queues 2@0 8@2 8@10 8@18 hw 1 mode channel
>>
>> /* Enable inline flow director for TC1 and TC2 */
>> devlink dev param set pci/0000:af:00.0 \
>>          name tc_inline_fd value 6 cmode runtime
>>
>> /* Dump inline flow director setting */
>> devlink dev param show  pci/0000:af:00.0 name tc_inline_fd
>> pci/0000:af:00.0:
>>    name tc2_inline_fd type driver-specific
>>      values:
>>        cmode runtime value 6
> Why is this in devlink and not ethtool?

This is 16bit value with each bit representing a TC and is used to
enable/disable inline flow director per queue group or TC.
tc mqprio command allows creating upto 16 TCs.

My understanding is that ethtool parameters are per netedev or per-queue,
but we don't have good way to configure per-queue_group parameters
via ethtool. So we went with devlink.


>
> All devlink params must be clearly documented.

Based on the discussion in the other thread, we will make this a
devlink parameter that is registered at probe time
    https://lore.kernel.org/netdev/Yit3sLq6b+ZNZ07j@unreal/
Will add documentation in the next revision.
Hope this is OK.

-Sridhar

