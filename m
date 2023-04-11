Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931DA6DDFC0
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjDKPbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjDKPbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:31:01 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F89246B4;
        Tue, 11 Apr 2023 08:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681227061; x=1712763061;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bAaYQaQ7dwZjMlSC68BdO6Q1/kZtqsZyzuUQvoXst4s=;
  b=QaqvZZCxSR8tImo3mbrGY0tmmNf6fwAoSqCoYMfI3ezMnEkGT6AcsvAr
   w8xqfzA/pIbkWfIaSZBq395UiygfOs94UIsqW4iYfE2O1JZTjiwA4RfZZ
   K/pAEkXpeB3MngUtHJzqO8tgC3f3bwpyqGJs6CA69uRBNvN6hgigcNcft
   5RM/C4vePHdM4rSi+oDXLVCisISdj3fSTrK/83VpXRVYj0yp8a3vISpRk
   9cye8MSGl7JwfLPy5tWVVuVfT/x/z3QeDcvh4LubAOnNErU7zzImI67ev
   iOx6OX3ylqSXHBYUOiZFJqnwjtogS2HTbGh3AsXvBM8nykCLuMZNOU9ne
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="324013036"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="324013036"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:31:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="757885322"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="757885322"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 11 Apr 2023 08:30:59 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:30:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 08:30:58 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 08:30:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnyu/d5EYVVfv2qr2VzPEE06+giIQyoBLSqwDmQLKLKci6+MGcwAt6OhR1j70E3es10uxJhv1yy5vWJXOw8iZl6fa97SmuxeCh7jQn4Bq/w5twO/be3WhbXZnfBTpr8cYpIrJi6i5SnOFoDnJNcev+qyQ4QXmbIdQ4nEvVR30476haHBIujAVzHj2SfPKqQzlzKtLLTvlN79yQ3xF7DqbW/fiRhZCe222XuKZB7pSZmjx9/fKRCoZD+o6G2n/iz6hW0HDsdekwfbNVCyL54hXn6QSB34v+85wB3Pmu7U3jAh6poYillMX0Sk4JAedD2hXOzqjLVPTn9ckc102J3Z4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhP2WOFegMnuX+rvRulv97Vx7dKCul+rRcTaMCBWyxE=;
 b=FrOpe/VjVAb+pnagHkX62h/rk3Ir7hmXVFdHWJzpkSDdoqwEZywlKVJES8lCRPeYTLZr9HMNceDg1AXHaXa53DzqNrnXuyI3dh4CFIV57vzcZ+0u0hoDahIhE6PgowkbO7JEV4RTL5po/dLMOMaGB0jZRJrf8wL9F2iy4XC1fK4w7Zjym4TPwQ6mN6inAzoKU3FkG6frHxIoSWKhunR9P4FQo62rA0fw9VFft36akxeupamOr0uJ6DEN23kHe1YqvkW57YDTBAgBFSia58D3lXSTjIyYAUDBgt8USj5zYxPbyACK2Fcg28Q/9HyP8cpMfFr2fXzYOuWp+FfXH0DboQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SJ1PR11MB6204.namprd11.prod.outlook.com (2603:10b6:a03:459::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 15:30:55 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:30:54 +0000
Message-ID: <260c2921-44e1-466b-0bfb-05006e6ad4c1@intel.com>
Date:   Tue, 11 Apr 2023 08:30:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net] net: bridge: switchdev: don't notify FDB entries with
 "master dynamic"
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Ido Schimmel" <idosch@nvidia.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "Nikolay Aleksandrov" <razor@blackwall.org>,
        Ivan Vecera <ivecera@redhat.com>,
        "Jiri Pirko" <jiri@resnulli.us>,
        Arkadi Sharshevsky <arkadis@mellanox.com>,
        "Ido Schimmel" <idosch@mellanox.com>,
        <bridge@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
References: <20230410204951.1359485-1-vladimir.oltean@nxp.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230410204951.1359485-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::8) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SJ1PR11MB6204:EE_
X-MS-Office365-Filtering-Correlation-Id: c32f94b4-3bb3-4c7e-215c-08db3aa1bd79
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4KMGnVLzy3tchQ/BEXbYCIHKp2V8j8fse9OzsfGHsLCGjGtqwZTn9Va/6dCQ1ZAI/IrVUhBIuLZrIi03GekI/6pfxbAx67wdM0pJ40yJsJU7DvvchmoSb8lF1QBYbwMpvhmMVg1l+Ao7TaFU6aUb3W7xy5vDdodqC8CowsRkH1j8a09Faae57PJ4RUCtEHY056I7YUBStRhzF49OA4BcDWvKu09NRxr+Pxo1HU/Xoe9JeEePi2p6Q/RwJdwp25iccw1i8Td1iPhjcD3FnkJNbDVlujsfm41HarCN4qYOFND7NJAeDPHTp2sLciMJQgNktQ/eD9zTKeyhopFyU7TNMWB93OluDNz8I8X9Kkevh1uR9hwGQ4eZV2/vcP0UhzO09t59pKGeq06+B0Vp3dUzDuEAcf+RgFAaxDtELwxu68AbjpdPnu3tgEn/uorDQtQg9QBM0hp8+G3+lK4SAEuifAAukh5wMKupwq8kTUxV3sCzcKzE8mze26iQvbghGu88R1dSNlZludJxZ/35Lyk/xspL8ff+C1tx+bu2U7Dy6SxdOwdQER/JXqnuYt5nlXM6V9LXKR+wbzJDtM9MeaV/St/luPqqcvJZjrQozuZqA8t4VegG5OlRcL1+G4EFnrkc97Ght87xLc7s2FoUw6Bfeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199021)(478600001)(6512007)(26005)(316002)(53546011)(6506007)(44832011)(186003)(54906003)(2906002)(966005)(5660300002)(4326008)(66946007)(7416002)(41300700001)(8676002)(6666004)(66476007)(6486002)(8936002)(66556008)(31696002)(86362001)(83380400001)(36756003)(82960400001)(2616005)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjdCUTBobzRyTDV6WDl3L2Nrekc0Zlh0NE9ZblYyaEJENStpOXVTOG9lci8x?=
 =?utf-8?B?OVNGRUNFbGcwcTVmY0tzc1R2VWJka093bVhJazl6TFR5cnY2QnM5TTFnWlhI?=
 =?utf-8?B?UGE5YXhJTmEwUm92akFrcmlTc0ZFVmpPNXhRNkpIYkU1ZzdHenlTdnMxQU1i?=
 =?utf-8?B?bVFuMGk4cG1TVFUrUDkxMEV6aURVc2lGOHUyVUtvc2J5bkhYMUJNeDhNdnE0?=
 =?utf-8?B?NDZLeUY5cldjd0xtODhybklPMDdmQ2dJNHp5Y25ScW9EZWJTaHEwN1V3K2lW?=
 =?utf-8?B?VFJmcXJRTCtkOFdVVEdjL0VBN2c1QUNLWGIwWHhoME5VMG1ORzNxSEkvVXUw?=
 =?utf-8?B?b0JOM3FCWlpmd1FFbDJnY2s2SEx3ZHpJd0IzclRWTGU5TkRIcjI1ZzVOV25O?=
 =?utf-8?B?bHI0K2pCRzZjd0txN1U3bGVXMmtrbUpoWUNyMHZiRkkwZ2Q4UzlCZ3ExbEZw?=
 =?utf-8?B?YkY2TzhTUTh0bUxXNDR2K0ZTUy9nQVNlMk9STm1lbEFhY0R6ZVhwWTRSN3Ew?=
 =?utf-8?B?dW1ETnUxejNLK2Fka043R3RSRlNQOTZ1NU5oT3Rldm9pQS9ZbGNrVGhvYzJC?=
 =?utf-8?B?UjBKenBvUFJ5RjRxQ0lLKzVBSkJSeFY1a2ZnVCt0SUVRY3B3NjBlUnJpMHdH?=
 =?utf-8?B?RGRFM2tJSWtFTVM0UStFeitPd00wRFNQV3ZyYXM5andCWGpOK2tOZDdqZkR3?=
 =?utf-8?B?ejFwUjVMWStIQ3dqNXFqMnVRNVVEZDAvTUx5MHRFcEl3Ukg3QXhzK1UvTTd2?=
 =?utf-8?B?NHMyK2pWREFjaUdrZDZrTHl4VU44T2FLRHREZTFINGFTYVNMTGxkTERzcGJV?=
 =?utf-8?B?NzhyZC9GeVBOOVhYQUNiTmIycE1OVzFHMis2dWZwZ0MrcHZBMGVTV2w0ZWND?=
 =?utf-8?B?NUxxM3lrV1IvanZISVE4R3FMTldXaFFvK0VMQ0J3TEg4UUVndXY2OEdUQ3hJ?=
 =?utf-8?B?aEFieldJNVZ0eTBSQlJOT21SRXdYbmVvdHQvVUwzWjJHdXFXUll4ZERBSFZF?=
 =?utf-8?B?MW9qaWZ6YjZPRFhrRHVLdjdJQnZlR2hiZy9DNzdLcVdrRGJucFBjcmhvbko1?=
 =?utf-8?B?b3VPbE9jcHIxZ0VCbnh0NmRVNHpheUxmODZCNE5sazhNVjB0UjdTM3lpSlJr?=
 =?utf-8?B?ZXFXVjd6ME5CK0xWL25NU0dqOXU5ZE0xcUxLYTFhblFjc2Q0L2J1NFJEUjVW?=
 =?utf-8?B?K1JsYXpUbE93UlRPdTZrK2tGcHU5ajdOeVhGQUNCMVJtNXlPUHlQU2svME81?=
 =?utf-8?B?VEluN1IzMWk1MTlTaEZ0bWMwdHk5bWFKckF0UWtYUm1nWUdRMS9NRTBoNnNM?=
 =?utf-8?B?V0w2dmhvYks2dVlDOFNHOW9KWklPYUVyT2N4eU9QQkJXZ2g1ZE5pQmxHK1R5?=
 =?utf-8?B?eXRJWUJXYTIxU1ZWcTgyN3E2Y3ZTZFgzL1Iya0JMdjZvUXhGeS81YXpPNzZL?=
 =?utf-8?B?VEpPSlpucVl0ZlJ3OTZQWHdyL21waVVGYlZzQ3hnbkR0UHgxNHBtb0x0Z1FP?=
 =?utf-8?B?NlBnVmVCQ0NFUUp1TFdkbHRrb203N0RtektDY1lHYWQvQXB6bWtjbFdTRWxo?=
 =?utf-8?B?T0l0cFFFM0tDMlI2S2dHQmYyZjFBT1hncG1nblIrMHNjV0hicEtlbHJLSUlL?=
 =?utf-8?B?Y0N5cmYzdzFsMkhqNjZtVjhwMlkrM3AvRUZ3SzhIZ3d2NlFLeUtkS0xZNDZB?=
 =?utf-8?B?WEtZZVFVaVNrdnFueVpXdzN0SkhmQzlxUTBacGkrc095VjVibTc4bGR0SlFT?=
 =?utf-8?B?NjJIemhSMUoxakR1SHpLaCtGVCtZbFgrSDk0QmZWMVhXNjFqZWJuajc0Wm1F?=
 =?utf-8?B?N3pJZm82UHVjRWxMVS9XSEpXb0RMNHFVUWZtbkNpNWd4aTVYbGVCdytzdUpo?=
 =?utf-8?B?SHhuNmlrSGdYdTNXZkMyRFMvV2Rjc2JrcGtQQmtnZlVQaVFIVXlPd3pGd2ZR?=
 =?utf-8?B?TC8rUTVtOTlRMkRUaGU3OXlJWGdZNUVCY293UWh0VGRpSGVsbk9aOHJuUjd0?=
 =?utf-8?B?SVlwZmZHOSsyT01WRFN1Q1NvUklIWkJGYmRZR3RsWWMwYWZJcGZEVE5GOUJa?=
 =?utf-8?B?d0tJUVV6RnhpbzlFd1RSZ2JGd3NoOFF3MGtDR2xMYkt4YmN5SWFUY1ZqbU1G?=
 =?utf-8?B?dlpEeVNvSyt1dW9hLzVTbDRlNkxudW1ZYytXSjJoWlJjbUphOXM1ampsR2Fk?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c32f94b4-3bb3-4c7e-215c-08db3aa1bd79
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:30:54.8254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EF/Sh2jRQgaAjL2yH//yO08KlDtKi8iaPbsJKeV8d1WCGNhIdPqXVoZFilE9AKLuzapcG0tOS9BdenrHuxyfY63uKfQjrm4lpAMSn6hwGI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6204
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/2023 1:49 PM, Vladimir Oltean wrote:
> There is a structural problem in switchdev, where the flag bits in
> struct switchdev_notifier_fdb_info (added_by_user, is_local etc) only
> represent a simplified / denatured view of what's in struct
> net_bridge_fdb_entry :: flags (BR_FDB_ADDED_BY_USER, BR_FDB_LOCAL etc).
> Each time we want to pass more information about struct
> net_bridge_fdb_entry :: flags to struct switchdev_notifier_fdb_info
> (here, BR_FDB_STATIC), we find that FDB entries were already notified to
> switchdev with no regard to this flag, and thus, switchdev drivers had
> no indication whether the notified entries were static or not.
> 
> For example, this command:
> 
> ip link add br0 type bridge && ip link set swp0 master br0
> bridge fdb add dev swp0 00:01:02:03:04:05 master dynamic
> 
> causes a struct net_bridge_fdb_entry to be passed to
> br_switchdev_fdb_notify() which has a single flag set:
> BR_FDB_ADDED_BY_USER.
> 
> This is further passed to the switchdev notifier chain, where interested
> drivers have no choice but to assume this is a static FDB entry.
> So currently, all drivers offload it to hardware as such.
> 
> bridge fdb get 00:01:02:03:04:05 dev swp0 master
> 00:01:02:03:04:05 dev swp0 offload master br0
> 
> The software FDB entry expires after the $ageing_time and the bridge
> notifies its deletion as well, so it eventually disappears from hardware
> too.
> 
> This is a problem, because it is actually desirable to start offloading
> "master dynamic" FDB entries correctly, and this is how the current
> incorrect behavior was discovered.
> 
> To see why the current behavior of "here's a static FDB entry when you
> asked for a dynamic one" is incorrect, it is possible to imagine a
> scenario like below, where this decision could lead to packet loss:
> 
> Step 1: management prepares FDB entries like this:
> 
> bridge fdb add dev swp0 ${MAC_A} master dynamic
> bridge fdb add dev swp2 ${MAC_B} master dynamic
> 
>         br0
>       /  |  \
>      /   |   \
>   swp0  swp1  swp2
>    |           |
>    A           B
> 
> Step 2: station A migrates to swp1 (assume that swp0's link doesn't flap
> during that time so that the port isn't flushed, for example station A
> was behind an intermediary switch):
> 
>         br0
>       /  |  \
>      /   |   \
>   swp0  swp1  swp2
>    |     |     |
>          A     B
> 
> Whenever A wants to ping B, its packets will be autonomously forwarded
> by the switch (because ${MAC_B} is known). So the software will never
> see packets from ${MAC_A} as source address, and will never know it
> needs to invalidate the dynamic FDB entry towards swp0. As for the
> hardware FDB entry, that's static, it doesn't move when the station
> roams.
> 
> So when B wants to reply to A's pings, the switch will forward those
> replies to swp0 until the software bridge ages out its dynamic entry,
> and that can cause connectivity loss for up to 5 minutes after roaming.
> 
> With a correctly offloaded dynamic FDB entry, the switch would update
> its entry for ${MAC_A} to be towards swp1 as soon as it sees packets
> from it (no need for CPU intervention).
> 
> Looking at tools/testing/selftests/net/forwarding/, there is no valid
> use of the "bridge fdb add ... master dynamic" command there, so I am
> fairly confident that no one used to rely on this behavior.
> 
> With the change in place, these FDB entries are no longer offloaded:
> 
> bridge fdb get 00:01:02:03:04:05 dev swp0 master
> 00:01:02:03:04:05 dev swp0 master br0
> 
> and this also constitutes a better way (assuming a backport to stable
> kernels) for user space to determine whether the switchdev driver did
> actually act upon the dynamic FDB entry or not.
> 
> Fixes: 6b26b51b1d13 ("net: bridge: Add support for notifying devices about FDB add/del")
> Link: https://lore.kernel.org/netdev/20230327115206.jk5q5l753aoelwus@skbuf/
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Looks fine to me, but I'd like to see other switchdev experts reply.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


