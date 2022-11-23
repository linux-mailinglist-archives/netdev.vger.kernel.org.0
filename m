Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F7F636929
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbiKWSmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239362AbiKWSm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:42:29 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCE2BC4
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669228946; x=1700764946;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SsBInjEoxl109WaDCwrdv0fpM1pbZRzvboAqRuBnlnA=;
  b=NOomZcAm9K0cxCErYbzK3f/urM/JnZhDEgrMucGsgT2ipb+P37t5OkLV
   P5DGMmEtnWPbVHJxH2LczURRcUQgDAV40TSuI94nq3iufLt4MK9PoIFEv
   5jGZ8SxxCUD+N8tSdWoz3Y9HfILuWeZHQbv+CHn4brhAqRop4RGQ6EVJX
   oTv/e7jIbPAy6D31+0+9I9lGoq7dTw1Uej5FJuisVhEPKed77pWYdnWyJ
   VrARh9kRimNdfNKQq7fTQkmzG7MFKhMIEfu8jmdDpvKxOlqSTRYnzSXSX
   qIo0C9XSOjLI0RlTzmeYieq9bfVZKsaJ+Rvb5tVrwjEs5K6BLhA6gQMCl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315287761"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315287761"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 10:42:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747906878"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747906878"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 10:42:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 23 Nov 2022 10:42:25 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 10:42:25 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 10:42:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYoU+X0LpY77in/56bgA3JV2U8QxhE3+5mcsg84Kwccn2GyOHahix0S0qq8nlNIotUlzpm8LGW34CvE4+9OgVnLfZlPZucg7ImpuisFjvEMEJmoo8Y7F/VvBg1oBVM9XkAHcZ5a9Vnw52Ab6wvx26LItL9IhOTHJamIgdZfGyy+E3oT3PLoUzSFKuFQOz9ht5XFaecKW4L5b6k07qZt+VTz4GWYquwZd38Orjlxo4k2VqCLrezMlIeHV4L1pbX7PlKFiNxxkVRAfukHDTM7qDV6ypRXZuaE7SX2U/Fr6M4yfe5jKaGLA99vfhvAf4G1nmm7Gn5T9boic2cFP8lEzow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFt5m5scgWM/ptEo/Dpx+YIskbNfMkgpebXqMKCiFjg=;
 b=iE6m/5DMO3b1qgeqArPLIN0BUgqt+twtOXgKWsN1qVOO4dyc2jKQ7tTJUlcCGhDDr65NcftiUYZU8kazeXL7FfT1mGg198VoyQf67v0JzRV2yUXQBohZNWItlhp61N4J1JcRch+6LEuWTP3PVRaF4JK0UMxCIsH/QoeiqcUpM/fj/BISI7H0A7felCPgXXwNcs6FHPLtjvq91nDHruKiW33vNyhNCFGEoEWmaZWu79eKnbM0/9gPNdKQvNPNNeI7QH3FqY9OSici8azgxh1H+2sWVDdAcwvV7WCvspSizzY4lMqqJbPn0Ecjnpgnkd9OwG4pVbd6Puva33/g0Wezlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA1PR11MB5777.namprd11.prod.outlook.com (2603:10b6:806:23d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Wed, 23 Nov
 2022 18:42:23 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 18:42:23 +0000
Message-ID: <55118d61-1646-b3af-57d4-dbbad88b3b6b@intel.com>
Date:   Wed, 23 Nov 2022 10:42:21 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v2 2/7] ice: Remove gettime HW semaphore
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        <netdev@vger.kernel.org>, Gurucharan G <gurucharanx.g@intel.com>
References: <20221122221047.3095231-1-anthony.l.nguyen@intel.com>
 <20221122221047.3095231-3-anthony.l.nguyen@intel.com>
 <Y31O6zWRjaqttANO@hoboy.vegasvil.org>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <Y31O6zWRjaqttANO@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:a03:255::22) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|SA1PR11MB5777:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ed50eb6-b712-409f-4e89-08dacd8275ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzIxb1d6KTMC3kjDuothTzCeZUTzKCLaX+ccVAf49Kmwqdw8JlCq1tsFvJZuDQ/f3aZNN2rzYoidg2HKWFGdpv6NhQgjLKqWfuEdmprJqhFG2gbicxrsYMJi3jhQgTkrcw1IYVfpIoCC7qikHzKU9I0L56FN3uuaJR4d8aZtIdZvIg3pcKxCm5TeKnJlr668lMCrkO43S7exZVflByUhSr9B5Cz5ql+tamfVEmNwmRHdxtUUn8QMidV879Ekasc/scOn+nkiGVEj50XNHwZYpiMtgBIwnwL2FlhMCKv4r1PXD5u6/sEuxIOUzu3qmu8wcdD12WJ3PBVUdN6B5e9u7QHeqTHkqNkBUDFXuklFvqE70q1MPxAmvfn5ifEhfeSO4bWspxdV+td31hiqzQwwMOrVVJZ3wVeUu+uyflFLoF7g+3tuiBxcDLCSXl8bh4uWgIo0gbzGa2Yvet6QItLwLq6WukKiMHsnPZSDgT149WtYTzqEZHJoi/P38rFqbwPuyIER84HF9z58SsrsZghtCwINndOYrDQKFYXGyJ6uRt/88TheBPCNkTIvUI+4CmT8MzMnYV+Sm8TtFUlxOWNBXqhP9UPcducxahyrhbP8xzPZRQ3EQvxFbxc/PwaF6D98Vz6h3qViHfzAEw/iJ2kKwibEaPjoyF4QSrlrNH2eOogYu5JXA09N7LcpTQNd2xNY544C2KKtuPERMMvkqPSdCCl9qu8LrRLbtf60dcYJdPw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199015)(83380400001)(31686004)(86362001)(31696002)(6916009)(107886003)(6506007)(54906003)(6486002)(53546011)(82960400001)(36756003)(38100700002)(6512007)(2616005)(186003)(5660300002)(4744005)(478600001)(66946007)(66476007)(41300700001)(4326008)(66556008)(8676002)(8936002)(2906002)(26005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1E4T3g2ZDh3VlM5R3BreTdubHl3RnBIWExxLzAzRWNhYm56TlVVREZJQUVr?=
 =?utf-8?B?ZjB1RmhTYmU5UXdzWkVzMUQzc0c0dTlUYzBxWGdzRmdCbVp1aG5DNHMwRWdQ?=
 =?utf-8?B?QmsrcEhPM01sWnpQNjNBR1VsbHY0SC84d1l4SE45c2lLMmljeDdqZmJKZFZF?=
 =?utf-8?B?bHBEUEszMGRIdkFEK0ZwT1o1TzUzUldKUk9FbmFWTVBDRlN3WkpBdVVwdWdv?=
 =?utf-8?B?Szc3V095elZ4UUUxdWVEeTlUMnMrbE53c0NDR3ltMXRxQkk3L0ZCOUxRV3hv?=
 =?utf-8?B?c3dMZGdVb3E2RjQvUHVWdUJwUWpKY3RwWW53VDlVVW1MMUkxZHpXcGJYNGRp?=
 =?utf-8?B?UmszZFBVTzU4Y3dNV2c5THF2djYxTWVSdXJ6SlkwbDFoL2p2YTBKcGlVeUVa?=
 =?utf-8?B?d3N6ZnZ1Ui9uaGtsL0k3L0NheHVJS1pnZVoxZTBYaExHREN3eGI5OWZUZXNM?=
 =?utf-8?B?ODdtbHZreEorZHFhODZVNzl3bkwyYjJJTlREaTE1RHlvZDFaSjdjZkNpc3dX?=
 =?utf-8?B?T0tzRllNT2d0dEhMKzFjSUtxN3NVVS9JRXh0eTc1MnZWUlgxZ3hIZnlFS21u?=
 =?utf-8?B?c3R1ZC85d045OHN6VFUrZjFmVmo5cEdiL242TFB6cnYzREVsek1QMTVFYi9X?=
 =?utf-8?B?bHhlSURsWm5NQ25hSnVXdWFNUDNIVSswMlpSQUpsZlhkalEzSkJhM0FCYnpK?=
 =?utf-8?B?QnlCcmp3TDltWFY4MGU1c3BueFFXa0FlSkRaVWlZYUw2amVWRzRVVlFpZWkz?=
 =?utf-8?B?cHI2UU5IdlllcVMwaytkYTQ2MUlSRUlveS9qdlZKcVd6cjY3R0FORW9qZ3NN?=
 =?utf-8?B?UWl5NkpJSkhydVhta2MrRFFWZGtlTFF5OVN4SXBsbmNJRGZKb0hzaVg0T2lv?=
 =?utf-8?B?enVmVHlZa2xIRWY2T3NNbUVtYUpEU1hvc1hGZFdpYWJWeHV5SktUWkZTQXIr?=
 =?utf-8?B?YUZJWjBDaXdZamJLdkphc1BwazlmZEN3S0ZQSnpMazI0MmpZK3IydWRtTUhn?=
 =?utf-8?B?YnNqZ3ZJNFpZYll6VlVMZ0NKM3B1MG1TV3BmR21Qdy8zUE4yU0hVSDJwOEIw?=
 =?utf-8?B?ZFdPVUIzRWl6TjZaWHNUUi9xdkZXTDRjWkgxaVpleHNIVW1pWHNzOTJKYVlx?=
 =?utf-8?B?UTB6V2JGUzUrSUxpckJMcDZlS0RudEt4cXhiUFlrVHUvR0QrT0F5bE1FY1hD?=
 =?utf-8?B?VDRzbWY3WmtQeGUweDRYNWZ6di9KVENUb1JvU3p5eVp0c3Nlbk5nT2RLdjlp?=
 =?utf-8?B?QTlYTDBxUlF2R1dMSkJ5Z3ppdW5wL3k2aG9pVXcvSVhuSHl2WHdkZkJCYVdM?=
 =?utf-8?B?dXllQTUvcWpoOHFEWU9HK0xPSE94TFluRGEvRTNCQTQ3RkxjTVdqZzlGZDN5?=
 =?utf-8?B?NTBRWjg5S1p4bUFOZ0pUN1NZZURHTjllVG40M1BOL2xMZWtWS29MRnVmL2dV?=
 =?utf-8?B?OXJXcEplMmlSVkc1OS8zVVVXWXpGYnByaVMxQmlRcXRTWDJsamVSLzBZZ0hy?=
 =?utf-8?B?VytFa0VYUWxsbUx2MVRLVnF5M0ErWmxXaHNrSmNialNpaERKYVpudi9LSS9M?=
 =?utf-8?B?WnduWXdYZmJ0V3duYWUrM3U2TENuMzhiaXZLdHZyY0MxWnM3TCtMaGxzNkRQ?=
 =?utf-8?B?bk5MMUxzTDBUZVhkT29DbjI1ZGc5UUNaeGZqWHArVWV5c01ZZVhIOThkY1l0?=
 =?utf-8?B?dkFJbTh4cVN5TjNRaE9wZ2RzRkxNOWlMOGtjMVh3V2pQN3k1NVJVUUM5VCs0?=
 =?utf-8?B?bW1jL3JaWW15dFgxZWJoTzl2UDBsVWIvYVRTeTVZQ3EvKzExalZWenZzMmpZ?=
 =?utf-8?B?Q0ZLRHRkWTdwV3hpRjExUWFCSHhGUlBob2MzcDNxelZrSjNGSWRsVUxsZzZI?=
 =?utf-8?B?ZUlvc1phSXpHVnRuMlk3L0Vmc1BnNWcrSS9NUWZvWVp1SkUyTUlndC8zYjJX?=
 =?utf-8?B?elhBUjl1dGM0aU9JNkpTd0tkeHJQODRBeGFOV1c3aUx2anJqWkVITkVyRkZ2?=
 =?utf-8?B?MTQ4WFZKTXh1VDF2eUMrOGpwTTVXcm8xY29IUDBhblJ4UFI1L0pQUUpaUjBo?=
 =?utf-8?B?ZUlDbERJOUNlQTR5TkVGbXduMDg3WEFHeW92NDQ4QWZHbjJEcVdaaXhMdWRl?=
 =?utf-8?B?TFBodmxHYVllam1DZjA5S0g5QkRId1JlL3QyMDlmRy84R3NSakIxNUgvOFJG?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed50eb6-b712-409f-4e89-08dacd8275ff
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 18:42:23.8423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkE5OvaXB2EWG5U8VGvckkqp0bR/nUr8rE1E4wwHTj3Vd6J9oohp7zRLzzRPBzUKQcb1dePUVmEehpPjx+SBelFL2bX+5aFbeGKVvJphL8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5777
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/22/2022 2:36 PM, Richard Cochran wrote:
> On Tue, Nov 22, 2022 at 02:10:42PM -0800, Tony Nguyen wrote:
>> From: Karol Kolacinski <karol.kolacinski@intel.com>
>>
>> Reading the time should not block other accesses to the PTP hardware.
>> There isn't a significant risk of reading bad values while another
>> thread is modifying the clock. Removing the hardware lock around the
>> gettime allows multiple application threads to read the clock time with
>> less contention.
> 
> NAK
> 
> Correctness comes before performance.

Will drop this patch from the series.

Thanks,
Tony
