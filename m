Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120936E01D8
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 00:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjDLWex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 18:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDLWew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 18:34:52 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0714040D3;
        Wed, 12 Apr 2023 15:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681338891; x=1712874891;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8u/WZDXHc55ee3U7FnxGNYQY975fSiTcxF2E94sZU/o=;
  b=bAXABtCcTGVPafg2mWMgK1GGYO2vgzR6oeh33l8W8qBqdeTUS+1xz+VQ
   WnMjrtPzqU25uYOJqArsQwog5RzBX+QzKV+ptI4Q+1Jip3mfPaRHPBvRX
   fWtwBNDJ0opUjFlXEAwdjRwei3923lamo0TXpR6iVmPWPJTe9w19RWse5
   G1XDnDxWgPNknjYwP5LukjDBWWU/epzyW/p+IVff3C7m4MWReSimQJCGD
   HPOrxD1nwje5yvwuHkRL4+NEifANw1P7I6ft7rz4mbYdEhiNeaZnehs+M
   73gpWSm3L8wmdd3gFQ1S2jf3YASuGGeii/qIYJmcLrJ+GyNdiM7MNLx7D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="409181921"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="409181921"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 15:34:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="1018898843"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="1018898843"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 12 Apr 2023 15:34:50 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 15:34:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 15:34:49 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 15:34:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJHX1GmA7ElAvj+iXiiCnaKPFxVA7Ie5IYOXBgU+5/Y2GWN+9SQkWS4kWBCSEriD8p9Ct7D1aq85RfwDQMRAIbJUdCq5y4GW2AzVxIYmtLUXvu7W7RirWoGTOZ1b340/aKowHszaVZsKzCHgigJVqeiEyLJVezfcr+crM1dMxs7okDJV342nhWgv5j0RKp2prtqDO9NTTVH5z4v7PtGNVMBld6erdBaf6hHWN5WmzNVF5Eq/SisosSmexO6MLHos4GNaKG91TpiRBP8jHLwyNk13PkWAJrX5k+JE+VT3JanLDU4UebinShqAmBxRUwchSPU1MZ+Ed5DdzQBg9KaPHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBsDuWJknIYTtF6fGzLwgLL6icbcgJ2ndQ32poVj9C0=;
 b=BritURRDJSq9/CNecrJGuUp6Yc5aEVEVSz/tDUt7dWKNjdMJ3mb+Bv4VYAv/EFy+pI/uBnDzrX+eteRSOt1SWOv4kaDrIxCBKSFgZfFWtQ2KjYZ9cHt4Qe7jhlz0uoK8bCpCHuIo0UWZz0s2eVdi11/d16bp3MyslnfuX365r3N6vBQFXx7G+jZosnQALFlUR8wfg36T4kXi8YflSH2nt/i+adENxSQQ5MfNeokCGKM7Wc3QdHedUR7drOtN0kkaI+mvPFFW3WSoxnPT2IRB2w2m558nzGgn6t8AzSRAbZYShmY0v3WHiY2fBw6TqEl5oCrwz3zHaoyXW4XVtg9/hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB4816.namprd11.prod.outlook.com (2603:10b6:a03:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 22:34:47 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 22:34:47 +0000
Message-ID: <30e4bf50-7950-0b3c-67b5-6028b7114da2@intel.com>
Date:   Wed, 12 Apr 2023 15:34:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH net] sfc: Fix use-after-free due to selftest_work
Content-Language: en-US
To:     Ding Hui <dinghui@sangfor.com.cn>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pengdonglin@sangfor.com.cn>, <huangcun@sangfor.com.cn>
References: <20230412005013.30456-1-dinghui@sangfor.com.cn>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412005013.30456-1-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0105.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::46) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ0PR11MB4816:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eb684cd-844c-468e-fca2-08db3ba61e98
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kgu7BUpM4Pc2ipemQTGH1upAtxO8nLSUOmXvy9/QASMBL2V+cPZK17GStodJEqb0LF5JnlW2ZCcHO3dTO47kdRouyeNa14NhO7SKJ2BHce7SonnGK4nvsUeN6GAeejEPV2brIZjExfxA1Z+Xv0TZZGA8wJmdOpL445BJ6ZKnz6R2o77x226Xu/QBo6fWnGBkzuq8XVfviNIWspgdRXZ/LdfmSQMEXGtXS7i9gvDC+egoBceWD5FMbVV7+Hf8n4R488XbuNCu04ruCtmCHOz+Rg0HHzWtjDewyc0Md5WVbD50719NUQbYeDpNt7h7iWfiwjlSTgLvwdVWFqO+iUIzXauBzIWgbt50mBRJ7y0iTLd/K4NiZwExhgJ3cPQ/Hgj165k/7AW6ozk+xIwj5b3Cp8IstnzHKikviauK44boYi8jYmPiBHvTuED5mmgO6n80soJ3RubMKjWAKVko+Etc0IsdaaxWBCQk9yco4GHtaJw1of4u8I1WfIebYRBaPIOhsqY2v4L31UE6CTxTaMdAIoXkky224d7iuoJq7NLeGJ08qrZzIg6f3chlvvQ4SB5zW5zCPI+pTU7yhJVMNtzyD+gBwviJjrxfK8aNRtR/UYkd1PxtmX4eBPPJz/UmhUE6JhW0JkgyaBHxH1XyVuuyJTKZzY/eE1o43AQF7NQKx08=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199021)(2616005)(2906002)(36756003)(82960400001)(86362001)(31696002)(38100700002)(83380400001)(6666004)(41300700001)(66946007)(66556008)(6486002)(66476007)(316002)(4326008)(8676002)(7416002)(8936002)(5660300002)(478600001)(31686004)(26005)(6512007)(53546011)(186003)(6506007)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0FDT2hpa2lyTVcrQzFiQmI5UG9rTDY5M0NSTnl6ZUxiMjY4NmhtWEg3WCsz?=
 =?utf-8?B?c0xCTzhTQXYxVUtKNG1mOThXMHRkMnFVYnNxNG9sRVJwV1dGYnQwQ1hWTUdl?=
 =?utf-8?B?ejRHOWhHQ3l3ZzhabDR1VVR6NXdMOUJyTGhvUWs3eldyeTdHdDFKT0dZR0hp?=
 =?utf-8?B?TlErd0o0VTV0M1ZNL0xRaEQ0UTgyUm9CUm1FMUQwcGdTMVdrWjM2azVYZDRs?=
 =?utf-8?B?Q0NQaXcyb2JyUkVKSnNvaHhEK2FnaGhiTTVLUk5FZ3NnQk1CTFJlZTM3UjlJ?=
 =?utf-8?B?MkY5NnVVc2wrbnc4WGYxUTR0a2czdnFVK2N0cHpKYms3MmI4Si9uU0VIS2xt?=
 =?utf-8?B?MDJkcUhtWjF5TzJJeXJYdklJcGNuUUNXS2lLdi84cHZiOWJHLy9JMU5RcHhw?=
 =?utf-8?B?YTU0U3NQaG0zSU1qRFppSjBJUU1ETTdLYnJneUZ5ZDgxMmxSR0NxN3FTK0VT?=
 =?utf-8?B?QTZ1Rkk0UVFDOGc2dElWbmNvc1dHWWZaRS9KdlBZU1JRRmJFcThhOWpxdy85?=
 =?utf-8?B?MDFKOHFHZ1pHYXkveklFc1ZDNnFtY2VUUVFYeDU0SVhaR0Z3NmpLWGJiY2Zy?=
 =?utf-8?B?WkpHQnlCemRqUDh3U3pWWmd2dkpLeFRUdTR1OGpScUwrZnVnQjNyRXE0Rk50?=
 =?utf-8?B?R1ZLdnJXejIxN1RXYWpibS9uL1ZZbWZqdEFQcGNVVElMRTZ2Vjd3ZU9FdWdM?=
 =?utf-8?B?UENma2I4bTRLaWgzMzJ3MjFobGJZWnhlY3lVUjluQVA0bHJEVmlzbG9ZOU5L?=
 =?utf-8?B?MXBEdExBVGdqeUw3Zk9qL0JVTUpyNkxpdVZrT2hzMFNkcmhMWDI2aERCVnYy?=
 =?utf-8?B?am9UdGVpVzRLUzc3VUMrYUpFM3JvRjkwanVJZGpDYXdlelJMWU5vUHpsNjFn?=
 =?utf-8?B?L2RPWEtvUTZEcmNxTER2NUJsZndobXduT1cvV2VWenBHL1B2NUN6eTBRdGcw?=
 =?utf-8?B?eXFNWUoySmlHaU1nbVczZWF6TWZ6cmV6VGV6WVRRNk9OaHcyZ2NYZndNNDZ6?=
 =?utf-8?B?NzNieHYycFcwdXpERWM2c3FzQm5HUmljeXdUaFpQL1dMVjZVZEZKdFZYUjJ2?=
 =?utf-8?B?Qmoyaks1V0E3Q01pajBQcE9LbUgyVVlWQzFrZDBVM1Zod2RtSi9QTko4Nzlh?=
 =?utf-8?B?WW9VQkhJaXVIS2VVaXNEa3BtZmZTdzVDSlloWWZ3UDNzeWF3cUs0SHA3Vk5h?=
 =?utf-8?B?djVRc2RoSE5lb2IvVHpJMlA3NUx6UlpyWlR1c3hLcElSL2Y1WXkvMmpGc2pk?=
 =?utf-8?B?eHZVeXNNL05iWUk4enRkOG9PL05DbGR6N0ZrWERQOC94YmlTM0d0a0lZbWl3?=
 =?utf-8?B?ZCtWdU5xRG0wbDFCcHd2UHZvL1MvNEg5Y1V1czc0SER5a0RBMzg4bmFRSVE1?=
 =?utf-8?B?N29lajg4Q2lOd0ViZmprRGxEWEIvb25rejUvUGZKMjl1WjZJNDFrWlF4ZG51?=
 =?utf-8?B?eGRNS3pZOGlDbzV4TFY0Ykc1MXlQQ2pRZ0RTckhCdzc0M2xZNHJDVCs5U213?=
 =?utf-8?B?bXNwNHBaM3Y3ZjNZbE96bGZBWmFkMnNwWk9OWVJyRU00dmxwRGJqRnB2UUlF?=
 =?utf-8?B?OFFJV2w1S1dGZi9aanpMdlpWemlFeUdRNHRFdzlDTm1xY3I5RFZ0M2F3QUtK?=
 =?utf-8?B?SU8xT3ZIU3l0L2tEcUFxK2hEaXBBd2tlc0JNbEhidXpnNS9GT2x4VUErdGtU?=
 =?utf-8?B?ejhWMm9uWUxWZHF0aTI5dlRmMDh6SFdDVTVXeVpPYXVLQ2prVGp1dXdCamhF?=
 =?utf-8?B?RkhDc2JhM1hUM3djUThHQ2FQMTEranBaQ2hoM3hHMHM1eG9UUUM0ZnloL25L?=
 =?utf-8?B?M2J0aWNxOUZuNUk0bXJPUHAvZ21ZM2FYTzhLeStqOXJYNnFJWHdFUUQwNnQ0?=
 =?utf-8?B?WCt3NXl4WWlIamh1b003TmNqMVp5YlhJeE1HRFlRcDM3dGU2Tmg4OElhUjZa?=
 =?utf-8?B?SUQyTEFGNlhuUDVDYWxwa0dNalFtVE1yU3pndmFEV2ZOZlJpbGNVOGlFMi9L?=
 =?utf-8?B?Y3BuMit4a3dWTjRIbytyNmlSTVVRaUx1NS9Ra2l1WWc5RDliQm56NDVBS2ht?=
 =?utf-8?B?cEdTVGtsTmR6b0RhS0RQbW5DL1lNUTdNK3B3NmlPZ2ZBN1FOdG9ZWWxCa0dW?=
 =?utf-8?B?cE5oYmhXcmlOMG9Xc3pabnozTk5SWWZwdkFxWkl4WEFjd3JDejhsUGZMeFh2?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb684cd-844c-468e-fca2-08db3ba61e98
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 22:34:46.9037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MsugZ5T3JRAmhC2xXegQm0xDdlOXc5sO/suL64uqQg4lIgzqNQEAPn+dLo+zYZNezIcXmWBiRLCAaJO3qfaVdPokAU9ehsgo2VWx0WiYWCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4816
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2023 5:50 PM, Ding Hui wrote:
> There is a use-after-free scenario that is:
> 
> When netif_running() is false, user set mac address or vlan tag to VF,
> the xxx_set_vf_mac() or xxx_set_vf_vlan() will invoke efx_net_stop()
> and efx_net_open(), since netif_running() is false, the port will not
> start and keep port_enabled false, but selftest_worker is scheduled
> in efx_net_open().
> 
> If we remove the device before selftest_worker run, the efx is freed,
> then we will get a UAF in run_timer_softirq() like this:
> 
> [ 1178.907941] ==================================================================
> [ 1178.907948] BUG: KASAN: use-after-free in run_timer_softirq+0xdea/0xe90
> [ 1178.907950] Write of size 8 at addr ff11001f449cdc80 by task swapper/47/0
> [ 1178.907950]
> [ 1178.907953] CPU: 47 PID: 0 Comm: swapper/47 Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> [ 1178.907954] Hardware name: SANGFOR X620G40/WI2HG-208T1061A, BIOS SPYH051032-U01 04/01/2022
> [ 1178.907955] Call Trace:
> [ 1178.907956]  <IRQ>
> [ 1178.907960]  dump_stack+0x71/0xab
> [ 1178.907963]  print_address_description+0x6b/0x290
> [ 1178.907965]  ? run_timer_softirq+0xdea/0xe90
> [ 1178.907967]  kasan_report+0x14a/0x2b0
> [ 1178.907968]  run_timer_softirq+0xdea/0xe90
> [ 1178.907971]  ? init_timer_key+0x170/0x170
> [ 1178.907973]  ? hrtimer_cancel+0x20/0x20
> [ 1178.907976]  ? sched_clock+0x5/0x10
> [ 1178.907978]  ? sched_clock_cpu+0x18/0x170
> [ 1178.907981]  __do_softirq+0x1c8/0x5fa
> [ 1178.907985]  irq_exit+0x213/0x240
> [ 1178.907987]  smp_apic_timer_interrupt+0xd0/0x330
> [ 1178.907989]  apic_timer_interrupt+0xf/0x20
> [ 1178.907990]  </IRQ>
> [ 1178.907991] RIP: 0010:mwait_idle+0xae/0x370
> 
> I am thinking about several ways to fix the issue:
> 
> [1] In this RFC, I cancel the selftest_worker unconditionally in
> efx_pci_remove().
> 
> [2] Add a test condition, only invoke efx_selftest_async_start() when
> efx->port_enabled is true in efx_net_open().
> 
> [3] Move invoking efx_selftest_async_start() from efx_net_open() to
> efx_start_all() or efx_start_port(), that matching cancel action in
> efx_stop_port().
> 
> [4] However, I also notice that in efx_ef10_set_mac_address(), the
> efx_net_open() depends on original port_enabled, but others are not,
> if we change all efx_net_open() depends on old state like
> efx_ef10_set_mac_address() does, the UAF can also be fixed in theory.
> 
> But I'm not sure which is better, is there any suggestions? Thanks.
> 

I think this fix makes the most sense to me.

> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> ---

net patches need a Fixes tag indicating what commit this fixes. This
being RFC is likely why that was left off?

>  drivers/net/ethernet/sfc/efx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index 884d8d168862..dd0b2363eed1 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -876,6 +876,8 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
>  	efx->state = STATE_UNINIT;
>  	rtnl_unlock();
>  
> +	efx_selftest_async_cancel(efx);
> +
>  	if (efx->type->sriov_fini)
>  		efx->type->sriov_fini(efx);
>  
