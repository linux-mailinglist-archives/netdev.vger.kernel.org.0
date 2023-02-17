Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE46C69A373
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 02:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjBQBf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 20:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQBfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 20:35:25 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45583A08A;
        Thu, 16 Feb 2023 17:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676597724; x=1708133724;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vnrCUMg4eAz0dOVHqTjq4l3fcYmzqmC7ZV48rDq6wgk=;
  b=W7/zQy/DT3BoS4QSqDsvPxtSMAejucMt1K61vuwn3mIT0BEv75VA3zdU
   99iZmyDB8Sduq+ZeQmFo5F9eXqk6ZodBKTCMxF8h7vZaDHnBiFBTCNowH
   SGQ8coCa/XpcFB1q/xt7egvlQMohK/Aq+t9/5js4tlwHnXObaDe9YIDbd
   o+6TlqCXxQhX5os8LoAyu+Qqbwi55VVZRecGBjn7mXflDNE5oBTTkI7nj
   q+ndstEnLA08X3qAgyWtYi+ZlLrIwoqg1qo4nenqADV1ZB04j94IlL4YA
   yB0W0zpwcc0PQtHcHXebG6Dgw94ImRxCNmex3SueUCuUre/RhIf6ksMb7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="319985372"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="319985372"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 17:35:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="620228267"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="620228267"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 16 Feb 2023 17:35:12 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 17:35:12 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 17:35:12 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 17:35:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7hmT6yr7M6R8GFpqu9XOEZPRkk7XJ74wnLtUmD9IZafeIl8Sy+8glBQxpqNfVoNIXbuaC1j1dRtK7V4wU7yw5/rZ981WZkHD/jn8Fd82TzT1UUbCGdca757qAYV5RqCdTQL3robPSrQp8XoVtPkVOxtoMmXp/unKaJ6bzGBSA1t67bAE6zq0yA1uP7yeuFHCHJoC59QOPCxO3CdqxQJv/3V3OFchy+v7wxCGUA8QR+YaY39pLv2xOhuFfsiBTRRKPs19nauK8EIFWtOrpnqffFpvIG4tlKo0hpWwuWHvqhI0n6TzPFUA9P2POKqfRh6GmvqT791KyWMazGRjmrbhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXGN2LUWI0CAYcTIT0WiO9jQflh1sbNt5c51cqq9rqI=;
 b=f7mEM+guviLONBXkBRTC1gld1VKGgPWQbsZcgfkNZOGFmxXwR5R9x4q8j9Kk9urCxJ6vBPRNvfd2cI5y8g5WT2PAvKHI61Kl10c61KtHEfyuX21QXYmG/5mh5cmXleuZI29LMmxCq7HOKbUMtsTWKW++yqBm8OHJIypY0MrH4DpcqNjRoKT75CRyjk2CJB4n/fxqBbZJ7MqZ7q7/9NX37JE9MqNi70jv04UPzaq8oJhiLOfZ6Ayp0gDpfmCglc2EokVozbgv6nJMq7gUXHtM930Oovj2IQUin8Pa3fhpdkluUKDdLgnSOzdvqTfVIp7kjWRRQN+cb5IksPCIE15p/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CH0PR11MB5473.namprd11.prod.outlook.com (2603:10b6:610:d4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 01:35:07 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 01:35:07 +0000
Message-ID: <b944d1d4-7f90-dcef-231c-91bb031a4275@intel.com>
Date:   Thu, 16 Feb 2023 17:35:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net v2 1/1] ice: avoid bonding causing auxiliary
 plug/unplug under RTNL lock
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>
CC:     Dave Ertman <david.m.ertman@intel.com>, <netdev@vger.kernel.org>,
        <shiraz.saleem@intel.com>, <mustafa.ismail@intel.com>,
        <jgg@nvidia.com>, <leonro@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <poros@redhat.com>,
        <ivecera@redhat.com>, <stable@vger.kernel.org>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
References: <20230217004201.2895321-1-anthony.l.nguyen@intel.com>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230217004201.2895321-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0139.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::24) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|CH0PR11MB5473:EE_
X-MS-Office365-Filtering-Correlation-Id: c3227e50-2ce0-4a55-285c-08db108732fb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: btt88lMdLZ3S/1YYPO0PcuOsGIMxV73/p7b3swJzI51qI/f3lGcDqcWbp9PPwRzuffNp2R9Uh7ORqRl3yjZkdz/BXI22xNn0t1Xtwld5/31zuLmZxORYo5jwhmj7NAYZDB5uRfCnq/qruMhJtC/JZJnCnlDneoWqmYN+VdtZp6+6oc2uq53XIdOxnxIFpvsqZSL7eXc11eWGKs6GZOrmceNpa0rjrw8+tyvuJF7uZnhEjVJRK0yGj9MUjRg9QMaR1icwDDKIdz9rOKU6C5DRP73NpfAP6b+vR+HUxusb2GBqwcattzt+s8phMx704F/VSHQRvayn5zAaIEYn3p19lhgcKPMPJRSx/uWcZQvFlkUYDVqY2haoCpplx0LDKQ7JgoSuEyTBwfhtaHllWEauBMAMmLdUGXoaBOuWG8qn3ZAvUkPw0bjumMXeRjN0IiJ1pVfHcHI6QOx5NZVzKAC+0DmQZrHptTmfhIHOgAQwDyLrepZc4caWjSXsYVXEUwfN/TXaHAitkKyvNSzVrkwxqbHwWTCigYNwE+7qhhmViXKANDeBzBQULSOt0fXhA2Jb5deQKbNfVdOEik/TRniX/DB2DmAN96WhUKMtFShZA3FkO/+LISXGDP33KAtl6ldcI20iWKvFLIyDsbAZPdIaczjZbzEQj2Uv+Gk7MKkuaEqrrifL9ibLVK1VtY7eVcoKJMVarQ4B0GItNIziZrS2lF3tiFXNxwiKkxmdjCREwZMFFRZ/MVc3FtqV5pORVon5GWgEC0B/elgXMquBRn1GmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199018)(5660300002)(8936002)(2906002)(7416002)(54906003)(66476007)(4326008)(41300700001)(478600001)(8676002)(66556008)(316002)(66946007)(36756003)(82960400001)(6486002)(2616005)(38100700002)(83380400001)(31696002)(186003)(86362001)(26005)(966005)(6512007)(53546011)(6666004)(6506007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXh1N1c0QjQzNENXc2ludVRlOUhaRmVnZkZPSEg2aW12SThEbmxkWXhtT0RC?=
 =?utf-8?B?bzhjakkveVlNbGtTV1VIaTJZdDJPRThrRTUrN3h0dUp5WWlBL0dXTGNWc2pI?=
 =?utf-8?B?bFpoby9PVmhBZm1Vd1NHSFMrZlYyMGQ2YllYbTlESFc4M2pCdE9MVEk1OUJv?=
 =?utf-8?B?SWNkbUZzd3JRZzd0VEUyV09FbzBrRGd2RCtTWmdLNzhxYXRaZzk1TFNYV2d3?=
 =?utf-8?B?NlVLcjF6aUhieVZCQ0c5MU8zWjJBVXB0dnRFdUdkb21hc1VhUU94bGtPY0p6?=
 =?utf-8?B?SklYUktmbkt4KzJRVm4xWFptbVpiczJweUx1V2Npbm9HaVRwTG1vZGEwbDMx?=
 =?utf-8?B?WEk3N25RYlNmQUJSUXNkUmJoVmpvbURSSE5FanNtUXhOOS9JTEplOU8zL29U?=
 =?utf-8?B?UDgxdzFadlIxVElkQzhaWm1zZy9rSUNQcGxFREx3RjFWMnZoVUJOdDJibEl5?=
 =?utf-8?B?ZVIxZUJ1NHNYYU01citGdlNmcjJ5dzF6M3JrbUhoZHoyRFdNQ3dqMzc4ZjJQ?=
 =?utf-8?B?OUZkSnJDQ1VKWlh5bTNmaGNiK01qZGJQN1hMQ2QvczZPK294Q0lBNEE5Mktp?=
 =?utf-8?B?NlZlck5pOXpEY2o5cWFRa28zWDI5U05yZXdFTm9qQkh0VnVMZ08xQk5rT3Rh?=
 =?utf-8?B?djBhbUpCTk4wdWJnUCtFRkpna3ZLY3RwUXh4c2dwTjhRNklCbVFDamRkZmR5?=
 =?utf-8?B?d0NhZ0hjVHpuWTVkb09FMjlYVXUrUENpNzdGN3NZTEN3bU03VG11c1VXMDVo?=
 =?utf-8?B?LzlMWnhpZWhZUUE0Tjh1cUJBd09Xbm5KVW1jYi9tbmh0Yk1SYmdaeEl6MUJM?=
 =?utf-8?B?SkVEdnBnS0t1WkxPMmFBbzJQcU4ydGFrZDNXSEE5TVVzekIrdTVmT29hQ1FQ?=
 =?utf-8?B?MDBUNFZWSk1HRHJMQy9PWHJpNlpYSmtaSE1sQWVFQnpVNHN4V0llVXk0SG5J?=
 =?utf-8?B?eXpCR04yU1dhVGozWGV3YVJxS0ZBU0VNcXpJdG9mdXFVOFBMZUhlNTBLYjNX?=
 =?utf-8?B?Rm9MRDNGanVvUFJyT0JzUGRnalhyb0ZQQVBrTGd3RWcxSy9FZUFRbzNhbVpt?=
 =?utf-8?B?a0dzVjlKcGx1ZUZzb2J6ZmhaWFc1UVJUWlFvbjhOMHpUbjk4YjNCUEEycGxu?=
 =?utf-8?B?YVIyc3lxWGZPY3ZPck5qVlMramNpbUY0WGlmTzM2dis4SVJjRS8xMjd2ZjFY?=
 =?utf-8?B?cUJDc1VnUDgrOVZpVmQ4MWhkNFpsaTJ5YlVpS3BqQXpmNzh2L2dHckRyL0NZ?=
 =?utf-8?B?Z1Btc3B3dnl4VWZvcFRBVzNsTXI0aTIvTUdjM2ZqQWNLMENOZERFMlR0dWFm?=
 =?utf-8?B?ZHBoekVZZENNWnUxUU9NNENPdmpVYVo5ME56ajMwbmRCdCtQOG1aMXNEMVBu?=
 =?utf-8?B?TUs2YkovaXA3b1BtSVBVQm9vQmxZNVVyZnVpOFR2QWQvUy9LZVhnU0huVU5i?=
 =?utf-8?B?L3NUTlhuaVViQWVIZExOOG1lZERORVdhTzN6bE5TYTE5OWZuNFNCNzQydWkv?=
 =?utf-8?B?Qkp4NXVNVWkwNDMycUllYVBlUWM4ZTk3QnRiT0FUdFBrOVNQN3oybjk2U1FH?=
 =?utf-8?B?eEZua2svSDQ1dXN0MDVCSWM5dkZJdzlrM0ZUWm84d1h4NU03QnNwQmFqajU3?=
 =?utf-8?B?bm9FWGcyS25OUlJ5VVp4Z2ZZN3owRGlnVE5QaC9zbVMvVmk2dHpZaGIySUUz?=
 =?utf-8?B?N1hRa0tMaVB6ejdoUVdFM2tFcnlHSG8vS2NZQnI3M3cvMHZjd25ocEp0NFJV?=
 =?utf-8?B?RXlHRmEvQTMzNEI4ZFMzcEVhcE9BUEc3dUtqQXM5SlpTU2ZEakdyWEtaSEhi?=
 =?utf-8?B?L2MwamJ1cTdHMDI3ZHduWkh1S0R4bDY1NkFDSVFIQ0V4c3R6bGlSbm9VUTdu?=
 =?utf-8?B?UGU3dlMwSG9pdC9LcDhyOVgzUm5GZTVScVZXN2VhTjBPOWpkalVIU0xuQWM5?=
 =?utf-8?B?WFEvb0dXRTR2K0ZjS3FXM3FKaURsU1BRQVFmcGo2c2RaRnVwVlZrZWRYZGF3?=
 =?utf-8?B?dyt6bmlObzVKLzEvU2VkMk8yQ3dNWjV1dEloUW5CdG5MVFBNQWNYdjZJWWN6?=
 =?utf-8?B?YkhRWENEQW9keHBJL3hTM0txM1lkN3RUNHg3WE1Tck1FZUpwNjZhc2kyL3NX?=
 =?utf-8?B?alZ3VU9kV3RzVjJFUlhab1haMHFqdnYyUEJQUkdNMm5qdjA5Rno5L0NDR2hY?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3227e50-2ce0-4a55-285c-08db108732fb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 01:35:06.7038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2NiFDHV+cH1xZCNWltbTJ/A2Mr4IMZxDeXwxZ54K+p2gNM7mpOCi/zv7IAnZyiHQdjM9fLjI1Fhk/XfLK25CwYE3+hUFAJxIM6R6vh00D2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5473
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/2023 4:42 PM, Tony Nguyen wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> RDMA is not supported in ice on a PF that has been added to a bonded
> interface. To enforce this, when an interface enters a bond, we unplug
> the auxiliary device that supports RDMA functionality.  This unplug
> currently happens in the context of handling the netdev bonding event.
> This event is sent to the ice driver under RTNL context.  This is causing
> a deadlock where the RDMA driver is waiting for the RTNL lock to complete
> the removal.
> 
> Defer the unplugging/re-plugging of the auxiliary device to the service
> task so that it is not performed under the RTNL lock context.
> 
> Cc: stable@vger.kernel.org # 6.1.x
> Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
> Link: https://lore.kernel.org/netdev/CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com/
> Fixes: 5cb1ebdbc434 ("ice: Fix race condition during interface enslave")
> Fixes: 4eace75e0853 ("RDMA/irdma: Report the correct link speed")
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
> v2:
>   (Removed from original pull request)
> - Reversed order of bit processing in ice_service_task for PLUG/UNPLUG

Please ignore/drop this. Just saw that this change doesn't solve the issue.

https://lore.kernel.org/intel-wired-lan/ygay1oxikvo.fsf@localhost/T/#m83d7162b2830f248a51d121965443687d7f54654

Thanks,
Tony

> v1: https://lore.kernel.org/netdev/20230131213703.1347761-2-anthony.l.nguyen@intel.com/
> 
>   drivers/net/ethernet/intel/ice/ice.h      | 14 +++++---------
>   drivers/net/ethernet/intel/ice/ice_main.c | 19 ++++++++-----------
>   2 files changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index 713069f809ec..3cad5e6b2ad1 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -506,6 +506,7 @@ enum ice_pf_flags {
>   	ICE_FLAG_VF_VLAN_PRUNING,
>   	ICE_FLAG_LINK_LENIENT_MODE_ENA,
>   	ICE_FLAG_PLUG_AUX_DEV,
> +	ICE_FLAG_UNPLUG_AUX_DEV,
>   	ICE_FLAG_MTU_CHANGED,
>   	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
>   	ICE_PF_FLAGS_NBITS		/* must be last */
> @@ -950,16 +951,11 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
>    */
>   static inline void ice_clear_rdma_cap(struct ice_pf *pf)
>   {
> -	/* We can directly unplug aux device here only if the flag bit
> -	 * ICE_FLAG_PLUG_AUX_DEV is not set because ice_unplug_aux_dev()
> -	 * could race with ice_plug_aux_dev() called from
> -	 * ice_service_task(). In this case we only clear that bit now and
> -	 * aux device will be unplugged later once ice_plug_aux_device()
> -	 * called from ice_service_task() finishes (see ice_service_task()).
> +	/* defer unplug to service task to avoid RTNL lock and
> +	 * clear PLUG bit so that pending plugs don't interfere
>   	 */
> -	if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
> -		ice_unplug_aux_dev(pf);
> -
> +	clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
> +	set_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags);
>   	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
>   }
>   #endif /* _ICE_H_ */
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 8ec24f6cf6be..10d1c5b10d2a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -2316,18 +2316,15 @@ static void ice_service_task(struct work_struct *work)
>   		}
>   	}
>   
> -	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
> -		/* Plug aux device per request */
> -		ice_plug_aux_dev(pf);
> +	/* unplug aux dev per request, if an unplug request came in
> +	 * while processing a plug request, this will handle it
> +	 */
> +	if (test_and_clear_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags))
> +		ice_unplug_aux_dev(pf);
>   
> -		/* Mark plugging as done but check whether unplug was
> -		 * requested during ice_plug_aux_dev() call
> -		 * (e.g. from ice_clear_rdma_cap()) and if so then
> -		 * plug aux device.
> -		 */
> -		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
> -			ice_unplug_aux_dev(pf);
> -	}
> +	/* Plug aux device per request */
> +	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
> +		ice_plug_aux_dev(pf);
>   
>   	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
>   		struct iidc_event *event;
