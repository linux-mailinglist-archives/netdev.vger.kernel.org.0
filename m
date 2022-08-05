Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEDD58B0CD
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 22:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbiHEUSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 16:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiHEUSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 16:18:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750AD3A4B1
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 13:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659730713; x=1691266713;
  h=message-id:date:to:from:subject:
   content-transfer-encoding:mime-version;
  bh=pvn9EpyTeTFF9osYJ+orCPPoOKJ7i9LJG1iD/xNicNY=;
  b=NWrbwfNQ8ZjAumQD8U/TdwbI5dfS5xdVJoTMHSlR9d+5TqmnAD958Ssz
   IoYGh8wJClxLdJe1D1ni1BKeRpttFdRfmvbB2KCH12lPqbtrrfNQh68SE
   vHqOMvt+jHkkASxI3iMwegwB7Xs1uwIVgpAzcmLwvu+3iC8C5fJ6DHIGv
   PKyi4wRNeZ3kbhle2lG5tLu1EKEEqTHd5iltQnMcnKEuNCBS7sQ69G1TB
   D4pXEB27IU8AB4SZtHRfTGUSLyHyYZnOEt5dwE6UIi1Hy3E711z8VIB1p
   qfByM7XUo/4X0b+Vdh0ofDNhoI/VeFyI6MEDolQJeWF5K+I7N6ho1GJ07
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="270667293"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="270667293"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 13:18:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="745971593"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 05 Aug 2022 13:18:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 13:18:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 5 Aug 2022 13:18:32 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 5 Aug 2022 13:18:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NM711SlcQ9VFuGK+2gPgB97LQR7jGp5lScAaMSJg6ej2DZBIG9T0CFYl8QmoiZl+cycSU452aTGx1zUUHnT1BZy1hizbjKep3QUnTKQBn1P41LwjbbR6vzKzFBdktULXrOevM08HQWTxDhs5lWzzlUwus+xh/C+cyi2QRv0DcyxTWe7g2NqyQf6aSwclOolPjiQSSwnt+QIwWivI33r3j+7ckpEUYesW/pFcA/PmcfgekTjygUSFEkQjRaUJ5+UD4yv1Svmp3AWn2MGoH6GsoaDlwOowCOBPvEADE+umNsYcj8S60naF2QJsIw8qIEhZtvKcYac38CyVqd2mIPr/cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvn9EpyTeTFF9osYJ+orCPPoOKJ7i9LJG1iD/xNicNY=;
 b=MSFc49I15DhVTYFD+CSW4KbhYbWkM5sbDOwT7vpqG97nF4pl9pmHSSZJNsTqlwD0vtflngcaxS/EmRqqOVhs0WzlCHRx58mcC+atmX+oGUOsLy5JKeMO71IQvY0xpswvP+C4aQ6xIfKyTdao5JmcMEu0CgM+ocKqkV2e6IShFXwrEVi2KlmruyE+kyarK8sD10u/IbX3JUGwVby9JNeeTLvOYecwa9s5A+vgTxnZ+X9+dETwzyKLS/OfMqm4KssemLfsXAdHRD+3fcWtDZTwGLtGDB3XpM9mnB8+ZNZitHO+vBViq8BIO491ZotSD/O9lxuB7wXa4H4E1Mdv7B8SgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY4PR11MB0006.namprd11.prod.outlook.com (2603:10b6:910:7b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 20:18:29 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 20:18:29 +0000
Message-ID: <fd4da86c-e806-8261-970a-fc563758a9e1@intel.com>
Date:   Fri, 5 Aug 2022 13:18:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Content-Language: en-US
To:     Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Subject: cmd_sb_occ_show doesn't call dl_put_opts
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0103.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::18) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fee568f7-c342-47d7-a451-08da771fa914
X-MS-TrafficTypeDiagnostic: CY4PR11MB0006:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZOjZuVh/mTlTFfnH+HCHIFpsuWIerYCRDJzYauSgR4nBRKTHiZocm1bWiT20qo/aVLswLDqcC0dmztrZremdafGkLoyxS9kTPjIerJxli6603HapY8l03GI6A5PtMeY0WCx1TBSnsMa3E4vOh+7k36Cadjv1fu6f3By6YWoIHX2rl3cO3la9gzwz6IB6jO022FOpe4VvW7RKjwAV+I2kNSL11eqH6p4igyerqnwQHEh2JaLgwEvMmWfVn9GSNExTZ/e6UCUqzg9XNS4CrovFFCokW2eCrWqPdgFTtpDys57cXbLvTSVGq/5OChNXklnJCL/Tpg+0BgvdVEeJGyaDgO9QXUeNWfVRh6sfpuQYPY53uitYKI+P+s8B2d4Ow0oTyXWbQrnVsz09f0zk+CNlpBYp55NoBt2LUbbzQDLMRVLGhjnL6cjeXWD5w2x5lmYjo2SEc7TAJGNQySY6jL4BnRMhTjNT1Q+gPivDMF/duhrVt1wMntNjiiK/peKsA48k/V5GqZ3oJJZY61xWnBMWjfL5ZNIpHHlGBpPLkfT1J/nmhBeI/SzvPE1aQlnhfamGy53b6v5O3jCN1sxUmUa++RpakKJh5gybpdwRmntoaCnC30xpQXmqVrCCd5EDxhc4OnZXWnzQ0KdmVKuew46+JMIwAFptLJ1WaMGiw2CvYpkUfW9+Mv7GjfP2gKpkuGMf15YDKIxgfGNrA6PCsC+txpTVXeVkcFFy185IcW2LY24mgSgktq/BW5637ogDb3bXMJdDEsOx8y50N9OS72uS7autT8BWMPcFEpupsZZop3fRctIGsPBWfI2tct3775lbD2DXBfwMUxYo100/jRB2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(396003)(376002)(346002)(366004)(5660300002)(66476007)(66556008)(110136005)(4744005)(66946007)(8936002)(8676002)(2906002)(86362001)(31696002)(82960400001)(41300700001)(38100700002)(316002)(6486002)(478600001)(31686004)(36756003)(2616005)(83380400001)(186003)(26005)(6506007)(6666004)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aCtvc2FuQnRvQWhsY1g3dUhhTTRmdEZUcGh4Sm9NOTBYdHBKT2NnLzhxMmU5?=
 =?utf-8?B?aVNnUlA4Z0o3L0hKSEhlNUlhRWZnNXhzVWh5akJRYjJJSGJCVVA3Z0FSMHNZ?=
 =?utf-8?B?NWZpU3NZOCt1SG9BaVFuR1laMUlLSE9wQkl0MlRFSEtIYy9TNjRvVytqbWVJ?=
 =?utf-8?B?VmVvRk9oMGlEY0VVSGJsenp1RXpCT2psTHZ3UlFCeC9lMElFY3VaT3p4d3pN?=
 =?utf-8?B?MlREM3dGWUl1N1RvNXduMHhYTi9adEgxZVk2NGU1ZGZzczRZeGYwTGVjZUU2?=
 =?utf-8?B?elg0NnEwZjZvMjh4NWs5cVRJNlBIWG90WnFXTFo2SStPSHB0TVhsY1Z6WEVS?=
 =?utf-8?B?b0UzeWN0MzJzaHRMTDVaUzlEN09GRmNKMWo2TEVmUllyQmVqRnBwbWtFbXRz?=
 =?utf-8?B?YlRZRmNNZUhqa09BUFUzZWR5TVBVc1lIUlc3UmFua1RaM3dXT2tjR3Exc0g0?=
 =?utf-8?B?eWhyanU2VHlMQVAwZkYzMjdUZDQwbUV4MlNmSG55SWtHdkJCWG52M0FPWTNQ?=
 =?utf-8?B?dm5seDhYOHpSazlWRkdjTlR5RDBZcTVNZGhOL2FoSUphMldQYmErSUdmTjJV?=
 =?utf-8?B?RHpPWkg0aVBpOC9Fb21DaVltdkEzRklOdHRmUmNJbDhRb0tsNWRSdDZmbWV5?=
 =?utf-8?B?V1ZvbUhYYUFzYmtESUhZOWcxaEVoWmFkL1R0aWVwUGd2dlZRdTEyTm9MSzl5?=
 =?utf-8?B?dkI5Y1VwOHlPcElZQlRtNkZrWlY3ZTNIMmNsSFRrMFhyYVlUQitqVVZzY21j?=
 =?utf-8?B?WTFvQWZ3UEtIbFF3SlQyMGVZdUc5WFBiOWE2UTNIaCtmaDZaMlJVZ3F4UElj?=
 =?utf-8?B?YVVTSnoyT2VmUmgxZWcyTkg4UFN5ME80Z3RDekM2QTBYMlgvWHBIYnl0ZDZz?=
 =?utf-8?B?TGNJQ2luSWF5MmpFOEZuNkRBekJiUUNaSXZlZmVkN0ZQY3VpK2tLWXl1aFpt?=
 =?utf-8?B?ZTRoNS8wRUY4TWFCVnp6b1RieDJidVlmbkVXNnliVi9uR2VEWDNQcUhMMEJJ?=
 =?utf-8?B?d1FENm95bGFidnA0ajFYMGNqNmYxZ25KMThsM3ZVU0JzRGZGeTRCa1JDLzJz?=
 =?utf-8?B?NHdpNExNWjU4QStxZ21Pb3ByQ081U0p4V09teFN6QU5jdHpGTWsrQnJTZURV?=
 =?utf-8?B?R0xKWWRsbUk5R01ZV1paTnhrT3hrdXBhbUZRZHJnQjBQREdibkp2VFY1amtk?=
 =?utf-8?B?blJSeU5ndHZNdE9ZUGNBWU1kMExBU0xwazJhdkttNm9EUEFwN0xETWhFRTNU?=
 =?utf-8?B?NEM5aUUyVEE0NXF2TEJDQnFRRGtxb01MNUwzMUdta0R3dGxVM0IwYjVucHV1?=
 =?utf-8?B?UGZtaitFOGpyYk1ITVVwdGg2bEtvV2dXZ2YvdWRwSjBUbktPc0FyOE00SkN6?=
 =?utf-8?B?NFk5d3Z4MEZaRFQ0bWozWVhRZUNQRE91MCtYRVhiSmxrcU9ORE9pN1oxUHp3?=
 =?utf-8?B?NVRrRnR4L3ovZVg4cUxuSHZRSzhmWUluUUVZY2NBM0p2anZlVHJFMFdSR0xL?=
 =?utf-8?B?ZFRsRXJEaXZhdHF4dFU4TityemlnaDRvd0lmZkQ4cGlLUVlEdjZ4T0hVTVlF?=
 =?utf-8?B?RkZESk9JY0U5QTFnNHU0eVZQYWRGSHd1ODVBbFpsbEM0SDFNTk9GMXRSUXJG?=
 =?utf-8?B?enp0Qi9wZ0l1bmZpVUFRR1BqWmRjQWdqcDhKb0hDV0JTNjZPaEo0Zmp5SitY?=
 =?utf-8?B?aWg4YUUwVXF1MGZMR2lVOXMySE0zREFBbm5BUy9ERTYzS3hIYUlJZEdvVm5y?=
 =?utf-8?B?blpvbUp1R3JmbHhUUFFXTkdiaXh1eDVKb3FlWUQ0NCtOOXJpZ2VPZkkrdzg1?=
 =?utf-8?B?R2ZGblRHTUg1SEYvNDY4SnFVT1dZVzZNNXdMODQzUVBBSDNXQlFNTWExMjQx?=
 =?utf-8?B?Nmp4bm13bjFXb1ZYS2E2TDEvaFJXM2RNSTFlejVOUXE3KzYrTklQUDU1aU5V?=
 =?utf-8?B?N0xnb1Mzd0o5MjB6Z0FTRnhLM2lxZmpOdFhRak5zaFZtSDNteE5ab1hFMXhG?=
 =?utf-8?B?TkdpdUdkTUZueWd4YXU1aC84MmxuQWdFRTQwazgyTDFBR0ZZbkJNcWIrYUtK?=
 =?utf-8?B?bkhGL0FET2JNaHdMQ3BXaWxnTk93Sm1LYXkzQmtxZzl4aTJzaEUyT0IvTFRP?=
 =?utf-8?B?UDJrVXpDMXFYNDZQTGNyOHZKUHkycTR1TElMTWkyZFZnUVliUXRBTVpiblo0?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fee568f7-c342-47d7-a451-08da771fa914
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 20:18:29.2458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k0RBdX0eQ2ZVzIRpLwKdp3EoOkFGYjOJbc+/QSAhWoCxaFID2qeDNQ8HpCNCao+IHkABkEpjT+rlkgbgLcxXLmn1HaPS19/5Ac9BDnpwmZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0006
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Jiri,

I noticed while looking at implementing policy checking support in
devlink that the cmd_sb_occ_show calls dl_argv_parse but then doesn't
call dl_put_opts, so it doesn't seem to be sending any of the attributes
down to the kernel.

I am guessing this is not done on purpose, and is just an oversight,
caused by needing to send two different netlink messages.

It looks like the code could use a dl_argc check to determine whether to
use NLM_F_DUMP and call dl_put_opts to ensure the netlink attributes get
added..?

Thanks,
Jake
