Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0722061FDA4
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiKGSfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiKGSfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:35:21 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2932209B2
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667846120; x=1699382120;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HpdurP14ebYh2WcjrRRJDO06wqVDABHOFxvhsjAcRN4=;
  b=DCvzAaFCv3y5G0387L8iBxaSa1SKNO1hfVHjsm4vqXLF7W6XeHITP6Vv
   RdtKKmHiM7i/C5Z+trLJcDolA5mnHWAkVLeifqIxbD7oyudZTZ4Q4chWE
   TfZ2iS4znKOax/bBZQ2DlB4kE+8e2oiM56gssdav7uz8ZuWHiDBMhYh5u
   w7gFwck88KmdiU4oJhFtaGMLjJLPSfNTrC6G4sEI0dS59HVz0O2eUrFvG
   bpQ1XcPmP5YzsD8Jzc0vXCm8xPCgrN6TO74qhWrBwHJytDJYzimk1LqSp
   sll+dS+p4cKFRtyGi54c9F9byXflhYX29x4FzV3Rvu+SE7s6DtTWKvktd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="290211565"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="290211565"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:35:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="810942273"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="810942273"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 07 Nov 2022 10:35:20 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 10:35:19 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 10:35:19 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 10:35:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AX7MJo5ZfN5c4Ts8s4aHydtcyqVG4wU4+ibsdgHDdHGCTHO1KdyLwULqlzYIy9iSoFVJeXBJSyuCsvmzUIqGmEk5KPvAn/Zi0tqoz6cLBPZDmRDhHTBDpctV/1AA9lS9PupGZzHlRvsHn/SJ4PT0P+YTEuGheWiCEb/qPVUD1+gI5SXaGGcJyn5G9eC6kKX2Dq/ZqVyTmTj8AUyoRuBczIl10mmVi6+FIW27DEZg0wSY2+Jv/g3YMpkQ2BLgy/+eG/tnpg5U5D3cFboEjgXgDeR6GEMZ+pqVAEwUDESivEXcRWbMyL4LAwDjwFCsdX8OUh/rJpW+zXD/F3P4SdXeXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwbVFzSOl3NW37XRNm4OAuwOr9OfM6EWMS8MHDg8fMU=;
 b=lfru9vz18dPOAIveouLrwVif9fZGY5pSPIUzc1G4yXpHphwhWe+g6Pr5s8IDno+YyNOeKCRUkPveoiBMwIe4OG2hso8YiZHrH4QlbIR+r1HFp+L6JAf5rJxvkZci/V5E/6tbyDmpfTeA0LyLVZKXBNtipaGN7Uuqth/TRaiDBTct9fIZxcGpzz6hqmLjdVoCZ40n4sioGrLofTBDpTalWr0Tn0x1tNekl7Pr7KhGekekviFnVJfAyJMO6Dz0xPPy4aJMV8f+3R8GmVF/Jkn2VCT9YV3UdSQleBTMqwGnk9iOpR5fMpcXwjzDtetv/VUyI5znn7hLjnhX+/bSZNSVOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CH0PR11MB5507.namprd11.prod.outlook.com (2603:10b6:610:d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Mon, 7 Nov
 2022 18:35:17 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 18:35:17 +0000
Message-ID: <c051fa25-6047-0efb-7049-be08f566d1fb@intel.com>
Date:   Mon, 7 Nov 2022 10:35:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next 5/6] igb: Do not free q_vector unless new one was
 allocated
To:     Leon Romanovsky <leon@kernel.org>,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
References: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
 <20221104205414.2354973-6-anthony.l.nguyen@intel.com>
 <Y2itqqGQm6uZ/2Wf@unreal>
 <DM5PR11MB1324FDF4D4399A6A99727B5EC13C9@DM5PR11MB1324.namprd11.prod.outlook.com>
 <Y2lEK4CMdCyEMBLf@unreal>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y2lEK4CMdCyEMBLf@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:74::18) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CH0PR11MB5507:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d084b7b-4f07-4c19-413c-08dac0eed15b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4IliU06jsNOKY7+X6IfQxsWWx6X75z7so+Zurk4eLdaRerYms5nfQEFkWj6Ma+2kQQXL4zIEiUieaQ0yj5BVvnkQHPUaQSmX6NdvJPBCfu8b3ZPMVJ/YhE4kD6mRO/n4CmZjshFhDSs1+AcyeSXfcE+dU6Pyz4kTbsOS3pciYcXPT1XHtzye860delkrTuHneje+VV6s5bPy6ajbnan1ioDrKFDGMY2v/2zYsa/eUNpMgGXgnLgKVhr0WhsIkJgK7DWHC4b/lzhv99suJg4DrxM+gnHTQOhEnEoc/NyHvZMpbhYBM6PyS4UvyETTLfgSnA1DmMMdwHm68/qVnUHMsYwxOwG52M+MPZSeuJ2Cje0wRpvQNSSR7NXXI6hySuBnKNs/hq8ak2CRHhuBVAHlGupRYFzn3sBEFNrUIu8U2jlIdUFu46uwBmWxrqc50/nHA97z6rzZ+q+5TMtQQ6M7IJSV/1UZUFzmXu4XY2/I8rt6X1Rv+lQY80TO+qUC0OqRa1qgJbh8U+NHZV4jWRpFvkMFO1EwAH2qSGFuWVn2INUh9vyh/OTyxlOZZ635lZjOLm4hlK7xuXM8yxXFMTeN9/sSg5kE7GbUwMIItbzQdMXxqeVvFqYVIjv0inV8fUEqetU/IToLYGm/KzpmNaL0uzTt1PsaujyeAgnxaI6wDMAh0fNhgGDJbOpIgsXokbH+GI2IFFmkKfkUXs6rARKuoL/hxr2kADNEapLfhL6wBO8lS2OSonAuISCNilwMak6s1FV6FUbMzJPus8nT9xrsKDzpJzCnKUtdyIKO1tpmjpc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(83380400001)(31686004)(36756003)(31696002)(107886003)(6506007)(6666004)(4326008)(38100700002)(82960400001)(86362001)(2906002)(5660300002)(8936002)(41300700001)(8676002)(26005)(110136005)(6636002)(316002)(54906003)(53546011)(6512007)(2616005)(186003)(478600001)(66476007)(66556008)(66946007)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2MyYVF3dkFycjNlL0RHV1k3Q2pwcExNYXVqMStPWGNFOUdFejJxd3hTWXc4?=
 =?utf-8?B?Z2JXY2ZRWXBUaUVtOW1Uc1JBL2F1L0JmeFl2SkViMWpCN0pSbStQbkZaVXVa?=
 =?utf-8?B?U29NZFJyMzcreDJIVG5wVzVleTMzTk1NWUVGMmRvZFJseXVIUXBYU0E0T0xr?=
 =?utf-8?B?ZGJGNWhsQW8vZytROHFyakYyQjY5TENJMWpRYzFVZ3lKNWRtYm8vRGZqR1BH?=
 =?utf-8?B?ODJYQ3Q1bURMczZ2aXNQZzBkZGVvTGMySlF3UnhVTVpiSVBFU3ppaW1rOUNM?=
 =?utf-8?B?UG9Vc1RwekdVVlViK2F1M0g0d1BOSWR1WU5VT004UnZ5ZWdFdEVFVnE0ekFO?=
 =?utf-8?B?emp3Z3c3bHBPMjd2WElibnFxNkhmdGNYb2pMZ2RyaFJSWVBscytENmI5M0Fh?=
 =?utf-8?B?VXhVVUQ2R0U5YnFKeHdMYndQNm9meUt3RVRUVHNEV1RWb2dyODJUL3lyYUZQ?=
 =?utf-8?B?c0JJMWVQZUJ3WUNEV1l0MnZhald4QmpsTUhyditrbTZHY0tBMnI1c1VyRGww?=
 =?utf-8?B?OHpDcDFLdVE5ekc2bWZwUU9PQzBGNWFyVmxMd0xMSUx2ZjlVaW9CbGFSOVZN?=
 =?utf-8?B?OFlVdjhNOWxVYzV0RlVTbVkxU1pGRmRmWXUvVVc4YkpQakVXOXhwMURiK2F0?=
 =?utf-8?B?bThwdGtHNitkSXlpVUZ6SE1wdkMyYzFZUC9UTU1ENEhjQ0hKc1ZCRGpzM0di?=
 =?utf-8?B?TUUxYUkzVmRoZHFjaHVlbnhYdTJiL3NTTHRHdW1ib21UL0FRV28wMUlxZW4r?=
 =?utf-8?B?RXNzMjlKOXF4YmlzUWtPY3FHNWNyRWtqY3J0dFcwUlgzVWMwWE9MWHR5WjB0?=
 =?utf-8?B?MmtpVUZRVi91ZGw3d28waWJrNjBobW5jQnRJTHNXT2dtZ1hHRFEzSmJSeXZF?=
 =?utf-8?B?TmxFWmdHQTVvT3pFWkVPa1gvRDZsUTdoNWMrZTUvZEtacmhBTVJ5TW5LZzBo?=
 =?utf-8?B?b1VTcFlEU3gvN09zeDhTZGFwaGpnbFY5S01jWm5GNFJlWnFSWlNLdUZDbk1O?=
 =?utf-8?B?V3NBL3hPeHJiWW81WXBhcHBnaEkxeDkvYTdPZUdYR1FmS3RvcUFtbFZJV3pW?=
 =?utf-8?B?WmVyK3EzUUJ3b1hiYkxVTlMwV0wyakV5eEFGZjJIWW4vNERORy9jS3ZQZ0xT?=
 =?utf-8?B?bEI3b0dEaDgxcHlmZzRZQVY1Z1FFNFRZdGdTNllCeVB3S0pra0tvTjE5Vmwy?=
 =?utf-8?B?d09jZzFpMnAxUzhiYkMvTXZESUVNUWw5d2kwbzhGaTZiM1FRdVFJaEdrYk9v?=
 =?utf-8?B?Q2ZkNExWZVVhU2hFelcvK2lMb1hFNjU3YWRmU3dBbHA1SEwyekFYMDJlZmdX?=
 =?utf-8?B?R3MycUJrYzJzWU1xSHpYYXJ6S3pEK3VOZXR2L3NEUnR0c2o3R3NIb1hVY3Rs?=
 =?utf-8?B?Y25KSk90cmVNbFRsUkVsZGZDWEs3eHpkM1dGSjN0YmZyY2EzZXJxMGNZWlRv?=
 =?utf-8?B?STBnN2lza0tTZ0hNVDUxMEprY2Y2K3UzRW1EZmNHSDFtaGVhMUtSbWVwajYv?=
 =?utf-8?B?c01xQkw0V2NUcFdRa1R5QTdwY1BMQklYTEl0RU1GRUtXekRVSGIrVkN3ejhw?=
 =?utf-8?B?K2djNjl5MjNEUDUvUXdZYTdXVXgrbFc5eCtJMFJaQytrcHJwdWdvUmk0MUZJ?=
 =?utf-8?B?RVJ3ZndPUFo1NWM3R2tQT2QrSERsTnhaVENORklyMkxjMnp4dEJPOVdWVUVn?=
 =?utf-8?B?OU01RkFseGZobWZzK0FIWXpiL1FPZUw2YmVTWXdZNS9kZ0l6REdqNHV0VElX?=
 =?utf-8?B?RFpGaGhPQ3BpNDR0V3JaZ2hXYml1cC9MZFZtR1RBekVBMTQyS3NIWllidXNF?=
 =?utf-8?B?Zmdpdit3RytGWC82a0o5ZytFcVRzdEZRUDRHYlRJM1JDdHdmbVlHTjA5MG9M?=
 =?utf-8?B?dmZiU2k2MTJzVElhUkF1R2k1aXREd3RPZjBBZ251U2svYkV5Q3Q0OGJoOFBK?=
 =?utf-8?B?bmVvYUY2SEtkNGhYR1ZTcDF2MzdGM3E1M1E3UnduYk1pL0R2bStDR3E1Wk9i?=
 =?utf-8?B?WmZZMGg0Vlo0K2xRZjNPY3hrTnRtbmwrMit4RWswUHhRQXgzeENHYmxNTnZG?=
 =?utf-8?B?RUh5NEhlZzhYRVM3NHBSejVRSGF1VHBuTVdlZUpMemxHL0xyajlMcWlmN3dy?=
 =?utf-8?B?czdCQWRKVTNqbmlrL1hLQm95b1FQVjJhM0MxM04rbi9BNDJkTUY2ZW5NL0FO?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d084b7b-4f07-4c19-413c-08dac0eed15b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 18:35:17.4764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kMsSoLUe8wPAlxkDw0WIdkNuBJu3X0rvL/05SlCW0eeZi68Fcr7eG0guUOMTKUQkO9yG1F3eOh3/zbAy0bf7gEbugk/rQy5L0alcKk0RsKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5507
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/7/2022 9:45 AM, Leon Romanovsky wrote:
> On Mon, Nov 07, 2022 at 01:55:58PM +0000, Ruhl, Michael J wrote:
>>> -----Original Message-----
>>> From: Leon Romanovsky <leon@kernel.org>
>>> Sent: Monday, November 7, 2022 2:03 AM
>>> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
>>> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
>>> edumazet@google.com; Kees Cook <keescook@chromium.org>;
>>> netdev@vger.kernel.org; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
>>> intel-wired-lan@lists.osuosl.org; Ruhl, Michael J <michael.j.ruhl@intel.com>;
>>> Keller, Jacob E <jacob.e.keller@intel.com>; G, GurucharanX
>>> <gurucharanx.g@intel.com>
>>> Subject: Re: [PATCH net-next 5/6] igb: Do not free q_vector unless new one
>>> was allocated
>>>
>>> On Fri, Nov 04, 2022 at 01:54:13PM -0700, Tony Nguyen wrote:
>>>> From: Kees Cook <keescook@chromium.org>
>>>>
>>>> Avoid potential use-after-free condition under memory pressure. If the
>>>> kzalloc() fails, q_vector will be freed but left in the original
>>>> adapter->q_vector[v_idx] array position.
>>>>
>>>> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
>>>> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
>>>> Cc: "David S. Miller" <davem@davemloft.net>
>>>> Cc: Eric Dumazet <edumazet@google.com>
>>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>>> Cc: Paolo Abeni <pabeni@redhat.com>
>>>> Cc: intel-wired-lan@lists.osuosl.org
>>>> Cc: netdev@vger.kernel.org
>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>> Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
>>>> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>>>> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker
>>> at Intel)
>>>
>>> You should use first and last names here.
>>>
>>>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>>>> ---
>>>>   drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++++--
>>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
>>> b/drivers/net/ethernet/intel/igb/igb_main.c
>>>> index d6c1c2e66f26..c2bb658198bf 100644
>>>> --- a/drivers/net/ethernet/intel/igb/igb_main.c
>>>> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
>>>> @@ -1202,8 +1202,12 @@ static int igb_alloc_q_vector(struct igb_adapter
>>> *adapter,
>>>>   	if (!q_vector) {
>>>>   		q_vector = kzalloc(size, GFP_KERNEL);
>>>>   	} else if (size > ksize(q_vector)) {
>>>> -		kfree_rcu(q_vector, rcu);
>>>> -		q_vector = kzalloc(size, GFP_KERNEL);
>>>> +		struct igb_q_vector *new_q_vector;
>>>> +
>>>> +		new_q_vector = kzalloc(size, GFP_KERNEL);
>>>> +		if (new_q_vector)
>>>> +			kfree_rcu(q_vector, rcu);
>>>> +		q_vector = new_q_vector;
>>>
>>> I wonder if this is correct.
>>> 1. if new_q_vector is NULL, you will overwrite q_vector without releasing it.
>>> 2. kfree_rcu() doesn't immediately release memory, but after grace
>>> period, but here you are overwriting the pointer which is not release
>>> yet.
>>
>> The actual pointer is: adapter->q_vector[v_idx]
>>
>> q_vector is just a convenience pointer.
>>
>> If the allocation succeeds, the q_vector[v_idx] will be replaced (later in the code).
>>
>> If the allocation fails, this is not being freed.  The original code freed the adapter
>> pointer but didn't not remove the pointer.
>>
>> If q_vector is NULL,  (i.e. the allocation failed), the function exits, but the original
>> pointer is left in place.
>>
>> I think this logic is correct.
>>
>> The error path leaves the original allocation in place.  If this is incorrect behavior,
>> a different change would be:
>>
>> 	q_vector = adapter->q_vector[v_idx];
>> 	adapter->q_vector[v_idx] = NULL;
>> 	... the original code...
>>
>> But I am not sure if that is what is desired?
> 
> I understand the issue what you are trying to solve, I just don't
> understand your RCU code. I would expect calls to rcu_dereference()
> in order to get q_vector and rcu_assign_pointer() to clear
> adapter->q_vector[v_idx], but igb has none.
> 
> Thanks

the uses of kfree_rcu were introduced by 5536d2102a2d ("igb: Combine 
q_vector and ring allocation into a single function")

The commit doesn't mention switching from kfree to kfree_rcu and I 
suspect that the igb driver is not actually really using RCU semantics 
properly.

The closest explanation is that the get_stats64 function might be 
accessing the ring and thus needs the RCU grace period.. but I think 
you're right in that we're missing the necessary RCU access macros.

Thanks,
Jake
