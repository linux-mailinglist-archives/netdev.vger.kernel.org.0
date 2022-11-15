Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6723D628EAD
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbiKOAt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 19:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiKOAt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:49:28 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2036B57;
        Mon, 14 Nov 2022 16:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668473366; x=1700009366;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZwOzXg9YsGGx0OkasQZeth2JakrpuC9UkaxXUSZzz9Q=;
  b=ad0dToQRHBA0VoJoC/Mi+ctThFdq401epphlJw1QdDrgIc9hBhDWuU4y
   jC4/QzlD5LTNsv6hpA142a1cmiqH5y2cHzO7v07q2FnO3bJ4eqGSj2X31
   eE92q22xViNmjPNwlSeN7OPDXP2GErtNtxoGho6+2QtKoqIsN539B/4hH
   ANMwx9YHlYsTyk3vgMnOMlwtUyo1bykzWGApZSrtLfhCczh+GFGKU3rpO
   uYcsHMamNRMfnbTbENBLkbJW5E+3Y5kzi7lanX7MSiaRbwvNITPOxkr+A
   Ea5jisgSSIjTJwI8tsoLKe9dNxPzw7iQ7r3JBFij7+EekiTSV5SgHDauH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="374252388"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="374252388"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 16:49:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="967786471"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="967786471"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 14 Nov 2022 16:49:25 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 16:49:25 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 14 Nov 2022 16:49:25 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 14 Nov 2022 16:49:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+KMWVH0PhfFUnJly+/5MTYZU3UYTXP6j2UnIsRfngRQJQxjl4SPpfJ5uoWnMv4gJQ6HGsSwpvvmhr5NyH3K7jqgk0ElrO2zA0apTnsMl3uJV0apL+AYZqioeBCdT//otnKkKXfGdUl4+p7ZEukFvR2GnTk5jdnq5aI0s9mh0mA4OW0x3Z5J82rFVEsj/OXMFlQsGKhH9u8lZGbfD27a6Sg2WOEyvoae0G9nPGg5NcTcFyRU/AffHmOWxzwiW9bk4QVvf0iFB7cDEE+1hYVlR/LsS/0FeInBILzvjNtFSj1rQxGAeyX2JslebCWQ+WLpS0tDETg6D7h+kru6w1E8Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kflNWQen1l2A7QcW6bZ6ho2OwnNWMtZutZwTuOYxayk=;
 b=T2mzFhc1MDaZM0KqP7qa62zFX4DQO9wvndgxBKQTFhSySJ3H1OkWiGp2488e8NcXVtuco1SqgwM0wBQvi09GnrOYfUqlf5yUTF/Ge4x8+cJm5jg1dtfPBcVeeO1QXNddsFIY6Bz4gBEqx4zcROQZWNFsgCC1x5nU+6lw6WFwUL6MISPfautV9r0wlIKqPqEJAoS+m4cbMBy3nUm9nAR4PpLrHdrS9qti4ZPemPhvkBfSOv8sT62x1EyFFl3WSwBHrGcHTlMKSd1eB4n8k9NadGsSueEH6m8CaI5NIH2cs0GLr1La0JTNUufHjeBrjj6m3YQ28aoVc4eERgCvb+a3qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DS0PR11MB6519.namprd11.prod.outlook.com (2603:10b6:8:d1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.17; Tue, 15 Nov 2022 00:49:19 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 00:49:18 +0000
Message-ID: <2a630a76-bcfb-d08d-619d-eafa6a7b1025@intel.com>
Date:   Mon, 14 Nov 2022 16:49:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net] iavf: Fix a crash during reset task
To:     Stefan Assmann <sassmann@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>
CC:     <netdev@vger.kernel.org>, Jacob Keller <jacob.e.keller@intel.com>,
        "Patryk Piotrowski" <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20221108093534.1957820-1-ivecera@redhat.com>
 <20221108105343.vjczwdxcsxhfghk7@p1>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20221108105343.vjczwdxcsxhfghk7@p1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0178.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::33) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DS0PR11MB6519:EE_
X-MS-Office365-Filtering-Correlation-Id: 5851d5ba-895d-4604-888d-08dac6a33a45
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HsSptzvhhS7LIEGrmMwZtJU+/gup/9Y9hYSW1dfL+fx0+1zAMVghxNwlacm5Y7MVDTysExz+woBjuuUuDHxrVcnC4d52+jIAxIzDRWswJirE1Ed6Y+OCaYR/8EltIbZNEjVGxxifMj2QTrLGc3SrVuvZ2v7W+OrMK0iW0zqM+wenEN9pcCHMj5TnAai29plRPveufYbFouxYe/+3OkLl0dNq+DgrIhR5q0zTNrvYzwG89Ixr2E0v4d7sjdCpxheQYtMrpqyphh/LqkEGiLAURmxGPpieiWuw62pTMICKoF53FCve9B20G5u2bk11ZTEO3d6YQ2lCPdK+D2JuzLMGfHm1nD/gMvncrholia02iEJkQXjb4yGUDRDnPrhDmzzNYLwBPRYA9IwXNQa9FAWphDDfU7wTetA3gzXmXRhoyY1iwmCUWeXmZWSZRsed2/3i7YX1s7N/ORuP212g2XEa7SJFdfi6yXp5+8D0rSh0ftBBEkuSSv0JZ42CdJzkcVeh+GmF97PxKeOrohmwUpFA3r3c1qmR/IPpsMYHex4f8QA6MJI9IYHXS2WOf5ebtv3SoI9HIfgxzWoxCoUY1yWjs9aFDWKh46V95WZZGfJWhN4PHCWI5IXmCg9yybS5DrACcmLLXEpZdqsqXUC4dmufTx1Zr2gtiBYD7VE/MPplQIfollUhtD/sG32LJcSEitcWbpYZqxIa1abpiPfY4FtOUUMDRkzQesUN0sDMWiPD954YZphRLELyEOQTmEMu+UxfMMakJVQHKX1buk7bLAX0se3JGPsTlIFxOVqxVDnaPcc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199015)(26005)(2906002)(5660300002)(6512007)(4326008)(66476007)(66556008)(66946007)(8676002)(316002)(53546011)(8936002)(2616005)(41300700001)(6506007)(36756003)(38100700002)(31696002)(82960400001)(86362001)(83380400001)(6666004)(45080400002)(478600001)(186003)(31686004)(6486002)(54906003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mi96UTZla05jcFF1VXFQQlgxNVZ1dVdYNkR1VVRCM3k1d0c5SGMwVU9LZVN0?=
 =?utf-8?B?M2ZoQWgrQjJ1blY4MXRJbzIxOS9zbTZKaW1XN29LK3I2V1NOT2htbWphRHQw?=
 =?utf-8?B?UTI0Tk9zWGFRSDV5VitIUEZpSFgyblMwdFBtWWY2NVFsYzJyUFZVdms3cnMr?=
 =?utf-8?B?eWplTTc1UDBkaVFYMmVQR01IL3JEdXBhUDFxL2p3eG9UR0VMbmRUVjVNdWN6?=
 =?utf-8?B?YmNBbWhwbUZOK2RqUXRyb2JmdDhTNlp0ZjV3R1hndTk4TjE5dm5zdjgzci9x?=
 =?utf-8?B?UXIwRXdsVkYzV2tvaS9uUDFvaGtidW9vMXJMS3FUelhUYytuN2g3dHdaV2hI?=
 =?utf-8?B?cmlmNm9oaEp3UU1ZSWUrLzNIWHduUlQxUlVJRTRzSzMwbUJ0TGpqeUJacUZM?=
 =?utf-8?B?T2I1UEZEN2t3cmpFVVNybXZ4U2FweUNxRzVaVkhqSURXT3MyUldFU3A2Z3Zs?=
 =?utf-8?B?T1M0QS9BZ0J5M3R2R1AyY1NJa050b2VMb0ZuV2xWZXRVVWZpSHR4bFRwYWZK?=
 =?utf-8?B?TTRzZWhNVm5FR0ptNlovNE1FOERSTUswRk9pVDhXdWFKaFVCU210QWlRRUY4?=
 =?utf-8?B?NGttRG93WDBhQU5teWg4NTUwK2R6UE9ydkhHc3o1Lzk1MmpmZEN3ZStxSHhZ?=
 =?utf-8?B?aldubWNwYmFYUUIyaTdyZWtMNERXZDJEc2hESnBiSzlRQVZ0VSs0TnJsZDhy?=
 =?utf-8?B?VWtOcGQzZHo0SWJGN1ZRQkRvWWRuUDFLU2kzT0FLQWttS0ZiS2l0MDE4TWFy?=
 =?utf-8?B?N01lZGVhZE1XVStTYnNDeWN5NjZnTFFxUTBNQVhKcTByNzhBTzZBT0RFM0Jy?=
 =?utf-8?B?NWZqMldmdlJhcjBaYlRmVEpxcFNqK3VCTklabHNNVThTd3FaZnk3Z3IwK3Vh?=
 =?utf-8?B?c0RESGlBQ29PbTZ2UXlaOG9WdzFIZ0FqMVRZbTBHUTZBbGNVMVArYXNGeWpa?=
 =?utf-8?B?WkQzcUl4V3ExaWtSV2h2RldKOEd1b3R0UEdsMFg2UWhPUU1wVEl4Vm1KQ2hi?=
 =?utf-8?B?R1RjL0ttZTVjMjBIRXNkSDJqNnZhLzQ4RnhQd01xOGRQK21LNFpBSk9ZSUha?=
 =?utf-8?B?bThNSFZwL25hZHIzK2x3dTFiVDVXMW9QTjBITWJyT2dMQWhFZjRua3RiVmM5?=
 =?utf-8?B?QmgzY09VajJSMVZKam5UVTJ3RUNMUWgxZ2dHdUJnVWdlTlVramptM0Q5czdw?=
 =?utf-8?B?UlUvbFZNbTlPalhPZGdhaTFDSE5wYml4NlRRTnRManF2cUV6UGNMOGdxSkNX?=
 =?utf-8?B?ZTJFVFVtRmNPYkdWRjFGSHRJM0orZGxKNHJwTldWbmZycTBBdXJVSHJQZUYv?=
 =?utf-8?B?Sk1qTjNhU0ZURUVJdW84RElsQ2QweGY5VlJPVktEVGpEMzVxY01YMEZveDFa?=
 =?utf-8?B?eE1HOE9YZzEzMlFoY0FiYnRQMW4yT3JjUFNXUWtsYjl2Wmx5dFowZ1ZoMUJI?=
 =?utf-8?B?TE1mZmJPZFF5VU5EVCtwL0Nod3ZoK21ad1daSUI0SnlHQldCa0R3WlI4NzZp?=
 =?utf-8?B?Y09pMEJpQ1Z1T0dGR1laS2RpV1M1bzY3cTRzaXlnUWJaTlJ3US9lYUljRTV1?=
 =?utf-8?B?R2pLOGZxS0s3RWxqbnJPUklGRW9SS0tMVVVrOFUwS2xGcUpDeEtrSFR1OGly?=
 =?utf-8?B?VWRLL1NNcTJiTkFzaHdDRHU3QStsbUoxU3g4R3hROHV4R0EvV0FTVDhQayt0?=
 =?utf-8?B?cGNyM2EwTWRKb1hEVStjRzlGditkUWZ3bWJZWlZLaWhvL0t3QzB4dUFCb0R0?=
 =?utf-8?B?YWNoenUxamJtMlRUcGJPci9BUlYyVnp3L3p0anppWjFYa1d1MFA3NE8vK3g2?=
 =?utf-8?B?RVovenpYTmFOVnFjbXlxZFRYQzlza1Z5c1ZYNUJaZ2Z4RUR2bkdHbnpiQUJi?=
 =?utf-8?B?RjQwa010TVh5TnQ5TWVpcExaNmdzSzZEaXpDekR4c0JmekUxOStiQVROQjBI?=
 =?utf-8?B?Q2s4YXZjbjg0eW1VeVRqY3UwV00xd3JCdDdRZEo4SkdyRmFqcGEyQlNyaFhs?=
 =?utf-8?B?T0FvVUJxM09CV09qNDh1VE9EZHFrTldaSVZhV1NoVDc2YWpPZkZveXdhMmcx?=
 =?utf-8?B?T0xSSU5OTnpjT3FscURKTkV6UXVCdjY1b2tqNUpvc3QrVFFhYUxCSVZyR25E?=
 =?utf-8?B?cUY2QWJndjJUWmN4SGVuR1BDSDhvV0hQcDRWMVVVWkRDM2lIOUxmRURsQjJm?=
 =?utf-8?B?K0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5851d5ba-895d-4604-888d-08dac6a33a45
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 00:49:18.7825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dk9BX3iowH1o1NbKghMw6vijn8PboMfaziEvvNJHnY0FTDofG1qiz/ignAeVZtnGTAx2i+XtNqGlWiUoUvfiVgOEmo5pxOgBls5mGDqmukY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6519
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/2022 2:53 AM, Stefan Assmann wrote:
> On 2022-11-08 10:35, Ivan Vecera wrote:
>> Recent commit aa626da947e9 ("iavf: Detach device during reset task")
>> removed netif_tx_stop_all_queues() with an assumption that Tx queues
>> are already stopped by netif_device_detach() in the beginning of
>> reset task. This assumption is incorrect because during reset
>> task a potential link event can start Tx queues again.
>> Revert this change to fix this issue.
>>
>> Reproducer:
>> 1. Run some Tx traffic (e.g. iperf3) over iavf interface
>> 2. Switch MTU of this interface in a loop
>>
>> [root@host ~]# cat repro.sh
>> #!/bin/sh
>>
>> IF=enp2s0f0v0
>>
>> iperf3 -c 192.168.0.1 -t 600 --logfile /dev/null &
>> sleep 2
>>
>> while :; do
>>          for i in 1280 1500 2000 900 ; do
>>                  ip link set $IF mtu $i
>>                  sleep 2
>>          done
>> done
> 
> With this patch applied iavf doesn't crash anymore but after a few
> cycles with the reproducer tx timeouts are observed.
> 
> [   47.551151] iavf 0000:00:09.0 eth0: NIC Link is Up Speed is 10 Gbps Full Duplex
> [   54.035902] ------------[ cut here ]------------
> [   54.037397] NETDEV WATCHDOG: eth0 (iavf): transmit queue 3 timed out
> [   54.039264] WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:526 dev_watchdog+0x20f/0x250
> [   54.041524] Modules linked in: 8021q intel_rapl_msr intel_rapl_common kvm_intel kvm irqbypass rapl pcspkr drm ramoops reed_solomon crct10dif_pclmul crc32_pclmul crc32c_intel ata_generic pata_acpi ghash_clmulni_intel ata_piix aesni_intel crypto_simd iavf libata be2iscsi bnx2i cnic uio cxgb4i cxgb4 tls libcxgbi libcxgb qla4xxx iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
> [   54.049723] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.1.0-rc2+ #90
> [   54.051049] Hardware name: Red Hat KVM, BIOS 1.15.0-2.module+el8.6.0+14757+c25ee005 04/01/2014
> [   54.052898] RIP: 0010:dev_watchdog+0x20f/0x250
> [   54.053907] Code: 00 e9 4d ff ff ff 48 89 df c6 05 92 24 96 01 01 e8 c6 f2 f8 ff 44 89 e9 48 89 de 48 c7 c7 28 7f f6 a0 48 89 c2 e8 6e 65 23 00 <0f> 0b e9 2f ff ff ff e8 25 06 2a 00 85 c0 74 b5 80 3d 74 1b 96 01
> [   54.057282] RSP: 0018:ffffaf56c00e0e80 EFLAGS: 00010282
> [   54.058164] RAX: 0000000000000000 RBX: ffff993ed95b8000 RCX: 0000000000000103
> [   54.059345] RDX: 0000000000000103 RSI: 00000000000000f6 RDI: 00000000ffffffff
> [   54.060473] RBP: ffff993ed95b8508 R08: 0000000000000000 R09: c0000000fff7ffff
> [   54.061558] R10: 0000000000000001 R11: ffffaf56c00e0d18 R12: ffff993ed95b8420
> [   54.062640] R13: 0000000000000003 R14: ffff993ed95b8508 R15: ffff993ef74a06c0
> [   54.063681] FS:  0000000000000000(0000) GS:ffff993ef7480000(0000) knlGS:0000000000000000
> [   54.064867] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   54.065654] CR2: 00007f42309e1280 CR3: 0000000107f6a003 CR4: 0000000000170ee0
> [   54.066612] Call Trace:
> [   54.066985]  <IRQ>
> [   54.067265]  ? mq_change_real_num_tx+0xd0/0xd0
> [   54.067844]  call_timer_fn+0xa1/0x2c0
> [   54.068330]  ? mq_change_real_num_tx+0xd0/0xd0
> [   54.068916]  run_timer_softirq+0x527/0x550
> [   54.069447]  ? lock_is_held_type+0xd8/0x130
> [   54.069998]  __do_softirq+0xc3/0x481
> [   54.070469]  irq_exit_rcu+0xe4/0x120
> [   54.070963]  sysvec_apic_timer_interrupt+0x9e/0xc0
> [   54.071604]  </IRQ>
> [   54.071909]  <TASK>
> [   54.072223]  asm_sysvec_apic_timer_interrupt+0x16/0x20
> [   54.072942] RIP: 0010:default_idle+0x10/0x20
> [   54.073533] Code: 89 df 31 f6 5b 5d e9 ff 1c a5 ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 eb 07 0f 00 2d f2 2a 42 00 fb f4 <c3> 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 0f 1f 44 00 00 65
> 
> This only occurs when the device is detached and reattached during reset.

Hi Ivan,

Was there going to be an update to the patch to resolve this? If not, 
I'll take what there is now.

Thanks,
Tony
