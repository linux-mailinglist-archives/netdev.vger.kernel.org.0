Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E9D5A85BD
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 20:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbiHaSgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 14:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbiHaSg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 14:36:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A901123A4;
        Wed, 31 Aug 2022 11:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661970720; x=1693506720;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=B2WXfhgaJtRm368bb+v5fzQr1I7nVsRxaHIvsJ95f9k=;
  b=fuxESYfSNIwClPCuukGVluu4Rg0gh69JLpKUj0CvlfTnBWRNfyd1F8B/
   ZDOIvR5L/VMa45HNM9le2GEsECWdxLiFuvTLmSreyT1RW2Z7+PPAIc6Kx
   VlMDLJBLz9KtzV0dkHXULhwE93ncyLJaXtRk+/Z4i2+HsYVjk4vZOSqdS
   dxAtgqdt/zpmXRcP/yFXLSfT6B32qHugcTftWjXbooootwOLIIg+bW/Hu
   jxXwu3pAI6UH32TLIsI8Okt0Xhl0UeprVBqJTn4ccuI3Cr/NyWee1Xjo7
   oa/cEZktSMVvSp79einO7pcjhPFWkbf2o3t/UXFrlUiNKFpIJajvls/by
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="282491019"
X-IronPort-AV: E=Sophos;i="5.93,278,1654585200"; 
   d="scan'208";a="282491019"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 11:32:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,278,1654585200"; 
   d="scan'208";a="612190039"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 31 Aug 2022 11:31:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 11:31:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 11:31:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 11:31:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uz4us9/wOQENYRDYHwNzfZ+FComiNADUoE/sjtHpDFaFZ+Yj1xZ6vN4HGrV6h+/H4w9zUxmVKyuNkhswY2DsY9SnW+QOjF95lpb/grRsXwDJrdSAPci6aLY3qOEUcBd/xV7C3DB0EgrmAMXb/Xcw7G5CEL1lSbTYRJA2gOMzEc3MFg6fAo2GL5rObfwUSBB1zc4cVK7yfqDe8YNqLkQmwYypYtFT5d2TpD9dvMx4xkWJyaKsWBeOsZTyx/CTYOhODpqz91QCzakhsqaqwtC5HRVfLzXx0m2EKzb+LhC+/pt/OuotDAZvHojIztAdPuwMLl2Qev7LQAlXL5n15jKVvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7M7/I5D3GBgPdnFHiObv9qWLh6fsQV9Og4zsNaQH3yM=;
 b=APuoqUTDDSQl4ScMr7798eTc47PmqLbjQWC/o1rkeLXyrrD00+8WYlIx2f/IrrtioZIJUv+gBMr9diAeRj5aEETQ4UsmbTw6+OXoTL/DCORoiqJzTCmKvhOZovCT9GHbnzOdnCKTZhvfDGYruUdRF0aN+JlZLOwtiBvFIABadLMhGNsXVGvLyANWRZbDEGXGFZLFdPz5Z35kxOsYaDaEY44pphRR52UZxQbTpTlZCcqvw3mz2OGxed2g2GNVKdKslE3pxNAtqSV7kLRwV7rE9cycusV9sMaJVnXAOwBJXzA1BZgLRTcGj3W0j8+9jLfIptwIPCzqvwVbHpDHITHseg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH0PR11MB5079.namprd11.prod.outlook.com (2603:10b6:510:3d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 18:31:32 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5%7]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 18:31:32 +0000
Message-ID: <3d9e5deb-5de3-2a30-8e4f-dec08876ff5b@intel.com>
Date:   Wed, 31 Aug 2022 11:31:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] Revert "iavf: Add waiting for response from PF in set
 mac"
Content-Language: en-US
To:     Petr Oros <poros@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220830214309.3813378-1-poros@redhat.com>
 <20220830214309.3813378-2-poros@redhat.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220830214309.3813378-2-poros@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::21) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2538e261-08f9-411e-9c18-08da8b7f0738
X-MS-TrafficTypeDiagnostic: PH0PR11MB5079:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uteTudjjcZIl6jxfOod5ecZW1DocHlm4zsh/9/kaChmAvR7nYfqF4TqFjrSv1NokGPCADTuVmqLWE8LZ03ESWxWscBBM/o0bIgG5I5RLCpZnm2KSFGo03XMyoZQ1qFoL0cEmv6TvAKUPmNcx6tXWj3XSMBo2I0dt+S5mIQxoba7Fv+0fETaTgjMsMVMKnrkX1r1TIZd/f3a3wGm8trpPC54TnGd+Z5sQwj4jYlJAZImjqsiskx3TCBBe5OGPJzeEkh2BDR+jhcWcTS/8AlAbQNz59eCFIzkAC1MJAyzlfRrkYH2c6cM8aT9sgbOM0wGLTn246M4lORKW0R2wkJGX5FcEV7p7BrqTyInqt4phDSJFegixmYdvQVMSnWgLi8dBQEfT0J+VCui4hZOqu5/YFeBnvgFYZN/xbjgVij4a3Xg/Rshfli3wpVR2qRt2W9XdEhdHx/oUjc62pAuTN46Jg69nJp0cehGRwwFaGebDBqR6sbFE0rg78bifS9tREMc7MUQsPmcg5A/yIEhTZW+zW+huUpG3XewO/YyE6/1LEWyetwumdMZEAuVOFK2DZpMEaogBs+CnkAMrgRpkThY+JNoELjnA/JGLpwk+jO88U9yyWyBpDZKRQAFsqdSFDX5tw6Ts8XVAZ5UufsITXj4vI7OYIiDg0xvPwCsmNNyHnpDGYuzPNEfpf5vYwU5STWO4c+n8BYSwYSWB4eg3ifSwr6cE+idgquUPhMu3Sy4ZwG/6dN7LQZflsoAifoPjsgiv3B2gvPeke830zFzSq24M0z+uN3mabST0buXJt3lcO1qxQToBUzmb0dM/90avXhhQt58ObsAtdEZsoMaMZq1l3tLN6bJ1rJzdRRqtet2hlRQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39860400002)(346002)(376002)(2906002)(38100700002)(6666004)(110136005)(41300700001)(6506007)(316002)(86362001)(53546011)(186003)(2616005)(31696002)(66556008)(82960400001)(66476007)(966005)(6486002)(36756003)(8936002)(5660300002)(6512007)(66946007)(26005)(478600001)(8676002)(31686004)(69900200002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0dqMFNDNFJPVVhsb2N0aGl4UEJSWFJxRE9kTDhZR0Z6RnQzUGNaV1p4MXlq?=
 =?utf-8?B?VUJCbDV4QTZ3QTArSkhPZG5aSFkvL2tJKzVDZGlkUDJRZnozUHd0bVF1MW5P?=
 =?utf-8?B?SHpyampiYlZZSThuMVVqTU5HQWlrWDV1SHpFN1BkWDBML05nczdNSXB6Zkdi?=
 =?utf-8?B?UnlRTGdqSzViSnUxKzJZUFZrSFdxVm13VzZidXdkaFUvK2RsRE0wS3ZuS05E?=
 =?utf-8?B?YWI0bTdVYkxESHBsV1dyaFp5U2lFOHRHOWtCdXlwZzVrSnlVNlgwMGRGOWlj?=
 =?utf-8?B?WXAzZ2YzZ2xmZk45R0I0WW1GWGxOSldFYjdWa3dEZXI3NDJxc1RkV2lmZHVq?=
 =?utf-8?B?bnFFMU0rNnkrbFN3U3FrTGI5Vjl4Yi81UURVbUl1aVVtZjYxK3dNenVVREgv?=
 =?utf-8?B?WXZPUTZpcWttWjNZK002OGovTXFiek1jR2hwbkZtRkx1dVpkOUpWWVlhOU1B?=
 =?utf-8?B?NkV1TjFWSEVPb1BIL3kwbE5kNjFxaGllaEJudzBodGF3RzBQdFVIVzRRaVJP?=
 =?utf-8?B?cmhBYXFzbzBwL3R3V3JJVmZyS2VzNnZXcXVCUzhNWUJXWXlBZHFZYWR6SEdn?=
 =?utf-8?B?aW1OWFdHK3R5c25DZWdITDFEbEhRZTQ1ZXpaakRnTnlqbC8xSVFLMngzN0VT?=
 =?utf-8?B?RktJUEFXeDFzUlFTOUI0NXVHOEtYUWpOUGVNYjBHSng1azVGWm5MNUhPQ0NI?=
 =?utf-8?B?UUZ3UFpZb0NvQXBKaVlUMTVhRFpmbGhNU1NOWHYzdzcydllWb0JDdHBSYUNI?=
 =?utf-8?B?c3lCQmVuTURTWEdiSGtPUlF3dG9QWXVKYmhWc1VqdmpUMThlQThjM2hMQnUz?=
 =?utf-8?B?ZG91bHFxWFA1clM4eGVXR1dmcDNqV2FMQkJnb3pzZi8rSEJnTnBhak1HOWJU?=
 =?utf-8?B?WHNTeUwycGFvMFpudURrTDEvZFdtUW9qeDQ0Z1FqY2w0R0VSYkFHdVJFMFV3?=
 =?utf-8?B?Z2VhTFRUSGlvdXVxb3JtcEdXdmtHTDQwVlByRzRRa1kyUGMrKzYyK3ZoUTFy?=
 =?utf-8?B?T3pER0FyT3FZYk5FWk8vVmpmbXdNYlhWNmVrNTVLWktwTGVLWmNJcWFZcnhP?=
 =?utf-8?B?dlo1OUt5cmZwdU1oQllYS2c2cUpmeXNSekZCTjhTYjhCcEhTRUJJbFhiQXRQ?=
 =?utf-8?B?cXhYRkU2ZFB0cnNMd1ZLeGo3NGYxY0dFMWVZMlMwb2xBUFRQK2hUNmRhajRY?=
 =?utf-8?B?S1g2TTVJbXBDZ2FHMUFEU3h0emRoWHZTQTN1NitzKzl6MmZyc1h1azNHME5J?=
 =?utf-8?B?dU5va3JoUHRNS1NEemVFT1dWb3VYdDVOcmxRMXJDdEdreDZFVU5PM2o0S2U4?=
 =?utf-8?B?VHRJckRUZld4TDlNeXJjZ2tkblhlaWo0SWR0M3I2MDNzbXZraFlXQzBFbFNJ?=
 =?utf-8?B?V3ZzWHZoejFOTVdraHlHRVFHQkIwQTY5aGtrWDNEcTkwa2hFcm1OZ1BTamU3?=
 =?utf-8?B?YTF2YjQ2UzlyQVJ3c0pKc1J3U1VHbVBtUnJwbS9Yam5nU21FMFZhQk9rOFAz?=
 =?utf-8?B?VWtsQXQySVZYNWx5VTljWTYwUmJ2L3JMZVNQbHA2UVIza25uQ3lEOC91Y1ZC?=
 =?utf-8?B?aHdEdzhUTWlFdGRDTDVYTzgweUZ2Q2psZnpRbTNTWXp5M015TFFXcFY4TWwx?=
 =?utf-8?B?RjM2QTNzWkF5UDh0MWZYd0VJRTloVDg0OHV1MVNPalU5eDNuYzBSa2FUa3lW?=
 =?utf-8?B?Wlc4T3Qvd213ZEtYNVdzeXFyVmR2ZXZSMEZ2SlVrUWE1TVB0QnEzZ1RUc256?=
 =?utf-8?B?WDNxYVZXdlp4djFGMUhUUWNVemxnM3FMaC9xdUZuSStwUHZxdThYNkRCeGlV?=
 =?utf-8?B?SzVCRnhWbkw0WHVxSmQvUjhTSXd2bXNJbmlwb21MN01xTCt1bjJLRXBkSmRF?=
 =?utf-8?B?WStaY21TVkd0dHJCNmlrQk9Pb2pjK2cxYStZdVR2cExFbEttU3hXdTVUNm9v?=
 =?utf-8?B?VjlIMlNQSXFPTUNBQy94c3hwc2ZqbVJqUDE0RGowTmZlekViRlBXc1lkMEtO?=
 =?utf-8?B?N2FlRVJwenlSQlViMERHSjZRZnRDRHpyc254dTNGdGMxanVmNXRFWlBhVTZH?=
 =?utf-8?B?dXJkZE5pMVJpYjlFOEFXMEoxem1LQUp5WUdWbTd4S1F1eW1tY0x4dU5MYTF6?=
 =?utf-8?B?LzlXclhWY015b3lyNFo2bjY1Y2gvdjBVeGZCSnFQYnpVdDRTZWVZTWttbWdH?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2538e261-08f9-411e-9c18-08da8b7f0738
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 18:31:32.7104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+vJ+fNviXQgja56/K07oJHoj59nTAZaDPnpSj6NpjOXIwICoMDEbeQPt2SYTuCSfvFSbHNxYDnuHouGFa9fL1EpW1H1lqiP1+7bI1vN7Gw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5079
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/2022 2:43 PM, Petr Oros wrote:
> This change caused a regressions with MAC address changing.
> It is not possible to simple fix issues caused by this patch.
> It is better revert/rework it.
> 
> [root@host ~]# ethtool -i enp65s0f0
> driver: ice
> version: 5.19.4-200.fc36.x86_64
> firmware-version: 3.20 0x8000d83e 1.3146.0
> 
> - Change MAC for VF
> [root@host ~]# echo 1 > /sys/class/net/enp65s0f0/device/sriov_numvfs
> [root@host ~]# ip link set enp65s0f0v0 up
> [root@host ~]# ip link set enp65s0f0v0 addr 00:11:22:33:44:55
> RTNETLINK answers: Permission denied
> 
> - Add VF to bond
> [root@host ~]# echo 2 > /sys/class/net/enp65s0f0/device/sriov_numvfs
> [root@host ~]# ip link add bond0 type bond
> [root@host ~]# ip link set enp65s0f0v0 down
> [root@host ~]# ip link set enp65s0f0v1 down
> [root@host ~]# ip link set enp65s0f0v0 master bond0
> RTNETLINK answers: Permission denied
> dmesg:
> bond0: (slave enp65s0f0v1): Error -13 calling set_mac_address
> 
> This reverts commit 35a2443d0910fdd6ce29d4f724447ad7029e8f23.
> 
> Signed-off-by: Petr Oros <poros@redhat.com>

Hi Petr,

Could you see if this patch [1] resolves your issues?

Thanks,
Tony

[1] 
https://lore.kernel.org/intel-wired-lan/20220831135243.8623-1-mateusz.palczewski@intel.com/

