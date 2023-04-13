Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AEE6E0329
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 02:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjDMAYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 20:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjDMAYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 20:24:36 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189DC2134;
        Wed, 12 Apr 2023 17:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681345475; x=1712881475;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DNTdT7J5nb6TcIYxp0+10xH1I4UD+03hn3HqSt85GGM=;
  b=AANFxSnoyqygyFfk9DY91kKHK8JEBp4In/rdtvYEt517esucyaNTu9zC
   n/yYVFrqPGoaBe+IHoZVY31iQeLujG/OxcyXpxQMLPslOJuCJR51sEaiZ
   RMEqhAmxkUm39Yfm5Ny56jJLv5TzQ70C61Qrl+XDrBS9o8V3tm0Kw7Woz
   irpIWc84gF63sbhHJOY2jd/2gIPSsvhf9cL2+ZsnQlDn5e8bBs2rNGc+q
   23t61ijb0AnJZwVKOb8v08l5yRfe2CpofZn7AsPODSRt5IplO3OcW4GkG
   ygMVx5NIAmMrVPHIXsJ0gUKbRC6f8LHx2dmD1Lp9phfJnosriaSdAJE4v
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="323676271"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="323676271"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 17:24:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="863516236"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="863516236"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 12 Apr 2023 17:24:34 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 17:24:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 17:24:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 17:24:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KngBX4mr3I6+Bjm2o2bViNaxz1CjVgoaUmRxpxvxv87h0QkHDkDvdkMCWew2j71dflQii2BR3atWG4ZWdcjeouxjoe6c25OBr2xlF0PWoFclznxMJYggzKgijhdJzqAYVHvsoW+byzmlnggEKYSiRNiN7MxrwXPo6hfkcE4HcU7fbUjgiTMwbmR/9H091dDGhjjywZeFIHtQ4byOko8wyzgBtLt2osDHUnlJPG63HZgQkae90HTbkuN2unVWBNfSd0Ihf9fW1vP8lLCDsIL7ZEmLqBdu0l5+U21M0XVquWMIV9G5t3nGNRu25ub75EjwjlUgMHz+n438oPKv6912gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e78eXzYNkC2oCtCC6oLPmxvG1MukhZ9dhtEFRismO9Y=;
 b=Uz8juCB6D8ThO9fTKM8tWb6Tt0M+iAi/V9HaqSE/FYjtqxvGCC3MDrREJTF9MSTxKTbDoKSSQzFqeRNnLqAbi9fxbf/inbztj5QTZZssRCA01zW4NGwMg8wPl4DtNc7FTy3hFTrysfCMcsijVH29fIqsIgHB2MfuQms+pLxwoNngYwfqCk0Y5u/DnD1faQwj/9SZYfDDdjAsB+wp6jDen8A/+EaWfk1Vu7IzwNGA5KLX/ICmFMzt79BajPROXZSfrHQKobGvJEcym24Z17Bcl0h03hOyOkN6UtudvdLMxNiYWIE0rupiRMH3cxLd1hqPYN5RbJ9ifrLsprXVuCUIbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB5057.namprd11.prod.outlook.com (2603:10b6:303:6c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Thu, 13 Apr
 2023 00:24:32 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 00:24:32 +0000
Message-ID: <f2da00ab-37e5-ed62-1779-3838db796d22@intel.com>
Date:   Wed, 12 Apr 2023 17:24:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net v2] net: macb: fix a memory corruption in extended
 buffer descriptor mode
Content-Language: en-US
To:     Roman Gushchin <roman.gushchin@linux.dev>, <netdev@vger.kernel.org>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Rafal Ozieblo <rafalo@cadence.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        <linux-kernel@vger.kernel.org>,
        "Lars-Peter Clausen" <lars@metafoo.de>
References: <20230412232144.770336-1-roman.gushchin@linux.dev>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412232144.770336-1-roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0059.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::34) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB5057:EE_
X-MS-Office365-Filtering-Correlation-Id: a8b54c0d-bed7-417b-1d1b-08db3bb57337
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m2CKzO0GFYzbGFAeuoXbATyljJ1rYueYaZvNkupfTykJ+wJVjLHKAhY/GuG2BQbZZg9ppX1p/SNpCPEe0l2ud4gQIRazr9TbVKgTeJdVgXAB3+Mq3KkywgjXyGCt9B/aLnJCU2/YyhCoTg8Kb6shwLggVPh7/WxTYckW8up3y/I4WnfQLNB17rAYK7Hx0pqV4hrRpnWv0hDmKy30eFmdmEi4fqOBeUzZL0keSUcvxmtbziNXicLfZY5HeC4eNzOL3heDyAWN1QmraKuuC3QISjmMSaTD2NWR382VHNj4TdtUtUacv+Rwn7/2hg2mix3kIDRXrQoyJuuetrh2H9HlQT8U1ZG/deUd8yzrl5S/5hnavRk6+tzU9p0rQbg9cDGSNbJzwbbAhFXJtxOefw2guQk730s9JKJcyseU/GpVVsIRdvFgqtqaskLod9U1I+Bgcm6YcXGhKETBLOyhZvm9WqMhKV/b/UaeySqh/ijSL/M4saQkECpBQGIFM7NxllCCiYyAbQoehGz84gEDeV5hrl214tEQc/Qjo9IKPsvWdCCFowUrTcsQeLV/jF0jEB81HDCv8cBqVyR5G5PbVS3PrwFpc2VYDjYSnWe86DtbDdMNaI8VjwbjNVCVaz3qGRy90OwgyimyPztuWbEkMOdlLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199021)(478600001)(38100700002)(45080400002)(8676002)(8936002)(316002)(41300700001)(4326008)(82960400001)(66946007)(66556008)(66476007)(54906003)(36756003)(2906002)(6506007)(186003)(53546011)(26005)(86362001)(6512007)(31696002)(31686004)(2616005)(83380400001)(5660300002)(6486002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVBuclJCL0VkMkZ2blQxQ2JHVWpKN1p4YlJwL0NiSU04UlQ5bk1NSHIwbHo3?=
 =?utf-8?B?RGplM2R1KzFJVWlTTXZMa2g2cWRSVzBTQnZiZ210OGhxOEFZMUc2TWhPWTZO?=
 =?utf-8?B?cmNPbTdrS05oWkRpM2J5SHJaSHBNaEEwdDNqbmIrdE5VUXZ5c3dIdmNxaVB1?=
 =?utf-8?B?ZjlKcUY0dGZzeUlVS01qajZicWFnYmx6Qk10SDZFbHF4QmpidkI3aXlSbmpO?=
 =?utf-8?B?ZFQ3bkNxblpDWHJyVTRLQkVldDVla1Zmbm1GQ3pQcmhab3pMTlJiT3ZQWUV1?=
 =?utf-8?B?d1d4TWlLd3dWUS9xVnRXakVBQjJxNHhHWDliYmJYeU9RVXd1a2FzYjdiSUo3?=
 =?utf-8?B?S21zL1FiUkQwei90cFUvRy9UQXFub21lMzhoRDRHdlYzejVlOHU3TGRDSC90?=
 =?utf-8?B?V2l1bldqNGp5THd3YitMeGtZWmFYVThqYTF6WkZvbUwveHYwOVFxUmFyVjhW?=
 =?utf-8?B?b29qM21pajlKR0xEUVM0bFlCY2pSaEpFUTdnS21zR05aMFZESzFvdnI5c05M?=
 =?utf-8?B?MENGaFA2Ym4zUU4ybUdHaUpzeDdnbzBIQWJxN2xuaHZucjBIejdTb2x3MU8v?=
 =?utf-8?B?aFBFNVFKT21oU3F6emN3b0h0Y2lwTitsZGF0bkNnWmVGb242NXNpRzlhbklT?=
 =?utf-8?B?dDFnT0RqVC84MDVNVVdkc2N6RzROVU5tc0dBbTRPcG16NHdzL2VWUERIV2Yr?=
 =?utf-8?B?VlNrdG5aYkwxeGtManIzZitaTklyOVdDcWhRRmo2T1AyVGVQcTNiRlFZRnV2?=
 =?utf-8?B?N3daSndJZ21IUFpQLzAwa3BoYU1iazVwR3E3UHZuS3Q5VmZNSU5Lc0hTZ2lv?=
 =?utf-8?B?d2NteW8xdkQ2OHpRSHZqMnFoblZEb09PVnlzS3dUdWdkdVRhUDlvdGdBZUto?=
 =?utf-8?B?MVB1SVByaU1qNUxEbVBCVStRSmVZVHdOaWRUamErZUVNZ3k2bUVzdUhvbnRO?=
 =?utf-8?B?R3ZGR2tpRFlzNmQrenVLTmYrejJoQlRFdjlVOFp6M1AvVmlqdWNoQnIvNUQr?=
 =?utf-8?B?N3E4QjZYODlvNk1vSTJ2QU10SUtaVDM1L3E4TlFYTGtBWVRkQjZYY1NQWlZC?=
 =?utf-8?B?cGFPNW4rM1VxOGd1b0IwR280Y25WRHIvcktMcFpGR3NQaTRMeDdzTVlINGJ5?=
 =?utf-8?B?b1BYbVN5OTgvc3h3cWlZWVpsTStxYXNFTTBzTGpxd0pKeVFXR3pPckRPVEdZ?=
 =?utf-8?B?Z0NMTnUvUEFWa1k5UmFVb01PS0xtUDNVZlRueDRGMmZkVWI0cDArdDhZajh4?=
 =?utf-8?B?QmNTaWlMUUlSSE1wVjFjOHNFQ2FCeE56RUFBY2taMVRSbXVDVEE5S3RBY1FP?=
 =?utf-8?B?ZWZWNFFnR1BrWHhLQXI3SVk1SkxGS01mSUt0cGZ3eXhQS01DU0laWjBHSVhi?=
 =?utf-8?B?UCt2QzJSY24yeW1CdGxFUUJaVTYyZ09LVXNJZXhmeEo5RDVXYldUZisyNEpo?=
 =?utf-8?B?aEZZMzlOaTF5WnNPZktOcmRqdGpRZXBEYW5GdUhiWmlNRXpkYysxbHZkM0xS?=
 =?utf-8?B?Zkt4aWQ0Qjd5QUJWYWg2TlZ4RWFjUjRoR2p1blVlTUFNK1JYeEhUR3Z3RDVT?=
 =?utf-8?B?SWkyV1dvWFR3dWNhYVpld2VLV2NhREo2V1l1SHluNFdWUlZ0L2RPOS9Pdk42?=
 =?utf-8?B?VmI5Q0tzcmR3ZG1aNnhabjkyOTlrRXdMdG9OcU1uRm5YRkhQTUx4dlg2cUlK?=
 =?utf-8?B?YldpbzZod1hzaE9IRTZIV2laN2pkK2hoR1I2ejNoMXUveEJ5ZE1oVitXbHNH?=
 =?utf-8?B?bnJBYjhiQjNrQVVnNzc4Ui9pK3A0djlqQjVOdExSSTZORzVEajk1NTU3Vjlk?=
 =?utf-8?B?MFVMYjlvVlR6UkNUUFM0bE16S3RQVnF2VjkzcmFMNGhSZ0ZHRUlTVUI0K2N6?=
 =?utf-8?B?QWFtanVlVm1lMENpWmxWYTZhRmVWWjlCTjZ4OVNEcW9zK0hvSXZGeGZVWlJm?=
 =?utf-8?B?eHE2aHBmbmJUV29BYkxSZW1FTXNwTUhkMGFmQTExNGd6eGx2VmhGU2xCMFdB?=
 =?utf-8?B?cG04UFFJVktCVWEwZFl3MHRGVDRsZzVHc1hyWEpyTTZ6V2ZTZk5ma3h0Tk0v?=
 =?utf-8?B?THBJcUw4clgyRHF2cncvUXE2OWdyNGg1K3oxZ3BDQWQvdzFuOWZ3RXh1VEpx?=
 =?utf-8?B?aWRkdnUxME5YUytlV2VsYmJXMEc3SHhWd2xaVnROVHYrZmxyeXQ3Y1VLbVZ2?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b54c0d-bed7-417b-1d1b-08db3bb57337
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 00:24:31.2924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OOEI7xZRPR5+dsJDqK/6KujMNDQbLKiHhSRvml0KionLeyCvdZTNm/fOFOjF7ML0Our/YdfFsKWVTJwP4HZrkbrrI+9vLe7RsxzOZ/TogXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5057
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 4:21 PM, Roman Gushchin wrote:
> For quite some time we were chasing a bug which looked like a sudden
> permanent failure of networking and mmc on some of our devices.
> The bug was very sensitive to any software changes and even more to
> any kernel debug options.
> 
> Finally we got a setup where the problem was reproducible with
> CONFIG_DMA_API_DEBUG=y and it revealed the issue with the rx dma:
> 
> [   16.992082] ------------[ cut here ]------------
> [   16.996779] DMA-API: macb ff0b0000.ethernet: device driver tries to free DMA memory it has not allocated [device address=0x0000000875e3e244] [size=1536 bytes]
> [   17.011049] WARNING: CPU: 0 PID: 85 at kernel/dma/debug.c:1011 check_unmap+0x6a0/0x900
> [   17.018977] Modules linked in: xxxxx
> [   17.038823] CPU: 0 PID: 85 Comm: irq/55-8000f000 Not tainted 5.4.0 #28
> [   17.045345] Hardware name: xxxxx
> [   17.049528] pstate: 60000005 (nZCv daif -PAN -UAO)
> [   17.054322] pc : check_unmap+0x6a0/0x900
> [   17.058243] lr : check_unmap+0x6a0/0x900
> [   17.062163] sp : ffffffc010003c40
> [   17.065470] x29: ffffffc010003c40 x28: 000000004000c03c
> [   17.070783] x27: ffffffc010da7048 x26: ffffff8878e38800
> [   17.076095] x25: ffffff8879d22810 x24: ffffffc010003cc8
> [   17.081407] x23: 0000000000000000 x22: ffffffc010a08750
> [   17.086719] x21: ffffff8878e3c7c0 x20: ffffffc010acb000
> [   17.092032] x19: 0000000875e3e244 x18: 0000000000000010
> [   17.097343] x17: 0000000000000000 x16: 0000000000000000
> [   17.102647] x15: ffffff8879e4a988 x14: 0720072007200720
> [   17.107959] x13: 0720072007200720 x12: 0720072007200720
> [   17.113261] x11: 0720072007200720 x10: 0720072007200720
> [   17.118565] x9 : 0720072007200720 x8 : 000000000000022d
> [   17.123869] x7 : 0000000000000015 x6 : 0000000000000098
> [   17.129173] x5 : 0000000000000000 x4 : 0000000000000000
> [   17.134475] x3 : 00000000ffffffff x2 : ffffffc010a1d370
> [   17.139778] x1 : b420c9d75d27bb00 x0 : 0000000000000000
> [   17.145082] Call trace:
> [   17.147524]  check_unmap+0x6a0/0x900
> [   17.151091]  debug_dma_unmap_page+0x88/0x90
> [   17.155266]  gem_rx+0x114/0x2f0
> [   17.158396]  macb_poll+0x58/0x100
> [   17.161705]  net_rx_action+0x118/0x400
> [   17.165445]  __do_softirq+0x138/0x36c
> [   17.169100]  irq_exit+0x98/0xc0
> [   17.172234]  __handle_domain_irq+0x64/0xc0
> [   17.176320]  gic_handle_irq+0x5c/0xc0
> [   17.179974]  el1_irq+0xb8/0x140
> [   17.183109]  xiic_process+0x5c/0xe30
> [   17.186677]  irq_thread_fn+0x28/0x90
> [   17.190244]  irq_thread+0x208/0x2a0
> [   17.193724]  kthread+0x130/0x140
> [   17.196945]  ret_from_fork+0x10/0x20
> [   17.200510] ---[ end trace 7240980785f81d6f ]---
> 
> [  237.021490] ------------[ cut here ]------------
> [  237.026129] DMA-API: exceeded 7 overlapping mappings of cacheline 0x0000000021d79e7b
> [  237.033886] WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:499 add_dma_entry+0x214/0x240
> [  237.041802] Modules linked in: xxxxx
> [  237.061637] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.4.0 #28
> [  237.068941] Hardware name: xxxxx
> [  237.073116] pstate: 80000085 (Nzcv daIf -PAN -UAO)
> [  237.077900] pc : add_dma_entry+0x214/0x240
> [  237.081986] lr : add_dma_entry+0x214/0x240
> [  237.086072] sp : ffffffc010003c30
> [  237.089379] x29: ffffffc010003c30 x28: ffffff8878a0be00
> [  237.094683] x27: 0000000000000180 x26: ffffff8878e387c0
> [  237.099987] x25: 0000000000000002 x24: 0000000000000000
> [  237.105290] x23: 000000000000003b x22: ffffffc010a0fa00
> [  237.110594] x21: 0000000021d79e7b x20: ffffffc010abe600
> [  237.115897] x19: 00000000ffffffef x18: 0000000000000010
> [  237.121201] x17: 0000000000000000 x16: 0000000000000000
> [  237.126504] x15: ffffffc010a0fdc8 x14: 0720072007200720
> [  237.131807] x13: 0720072007200720 x12: 0720072007200720
> [  237.137111] x11: 0720072007200720 x10: 0720072007200720
> [  237.142415] x9 : 0720072007200720 x8 : 0000000000000259
> [  237.147718] x7 : 0000000000000001 x6 : 0000000000000000
> [  237.153022] x5 : ffffffc010003a20 x4 : 0000000000000001
> [  237.158325] x3 : 0000000000000006 x2 : 0000000000000007
> [  237.163628] x1 : 8ac721b3a7dc1c00 x0 : 0000000000000000
> [  237.168932] Call trace:
> [  237.171373]  add_dma_entry+0x214/0x240
> [  237.175115]  debug_dma_map_page+0xf8/0x120
> [  237.179203]  gem_rx_refill+0x190/0x280
> [  237.182942]  gem_rx+0x224/0x2f0
> [  237.186075]  macb_poll+0x58/0x100
> [  237.189384]  net_rx_action+0x118/0x400
> [  237.193125]  __do_softirq+0x138/0x36c
> [  237.196780]  irq_exit+0x98/0xc0
> [  237.199914]  __handle_domain_irq+0x64/0xc0
> [  237.204000]  gic_handle_irq+0x5c/0xc0
> [  237.207654]  el1_irq+0xb8/0x140
> [  237.210789]  arch_cpu_idle+0x40/0x200
> [  237.214444]  default_idle_call+0x18/0x30
> [  237.218359]  do_idle+0x200/0x280
> [  237.221578]  cpu_startup_entry+0x20/0x30
> [  237.225493]  rest_init+0xe4/0xf0
> [  237.228713]  arch_call_rest_init+0xc/0x14
> [  237.232714]  start_kernel+0x47c/0x4a8
> [  237.236367] ---[ end trace 7240980785f81d70 ]---
> 
> Lars was fast to find an explanation: according to the datasheet
> bit 2 of the rx buffer descriptor entry has a different meaning in the
> extended mode:
>   Address [2] of beginning of buffer, or
>   in extended buffer descriptor mode (DMA configuration register [28] = 1),
>   indicates a valid timestamp in the buffer descriptor entry.
> 
> The macb driver didn't mask this bit while getting an address and it
> eventually caused a memory corruption and a dma failure.
> 
> The problem is resolved by explicitly clearing the problematic bit
> if hw timestamping is used.
> 
> Fixes: 7b4296148066 ("net: macb: Add support for PTP timestamps in DMA descriptors")
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Co-developed-by: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Whew, this sounds like it was a mess to hunt down. Glad the fix is simple!

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  drivers/net/ethernet/cadence/macb_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index f77bd1223c8f..541e4dda7950 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -1063,6 +1063,10 @@ static dma_addr_t macb_get_addr(struct macb *bp, struct macb_dma_desc *desc)
>  	}
>  #endif
>  	addr |= MACB_BF(RX_WADDR, MACB_BFEXT(RX_WADDR, desc->addr));
> +#ifdef CONFIG_MACB_USE_HWSTAMP
> +	if (bp->hw_dma_cap & HW_DMA_CAP_PTP)
> +		addr &= ~GEM_BIT(DMA_RXVALID);
> +#endif
>  	return addr;
>  }
>  
