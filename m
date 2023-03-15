Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C366BACD2
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjCOJ6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjCOJ6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:58:24 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31DA6FFFC
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678874216; x=1710410216;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3o6bECDBEwxyhkh9XaFm+XDH18teb2QyjZnAMfUdm3M=;
  b=YQZmHhDIkBdqIBKtRDEEWryODaYJYHldqbUdH18agLk6YyGGNnhx1bk5
   zvvi1uzq6iM8doQ06joef3hqsgUiA81Zwazm0taWfbPDrMAaHS4qMUu6D
   3+2AwzkDBgIsB6Zaqy7alX26dDFMNiAx90qJrsmvUPu7OQgNSHBFlDHBY
   yO+lDIU4vnvVjkhisNSmwpOLc+pMqJOQ6RWabxeC/Rrq1k9EhANmQ7DNC
   odoKcdf7pNwXJW69hu3el6eCxor+4bjGdBDRufi8F0bm+iJvjg72It5vk
   VY0AWbsDYz4gKF4Gs1JKqVYbyi/JxxEQTZfCxMT4tQz97QpzrYqq5Po2W
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="340023328"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="340023328"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:56:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="743628241"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="743628241"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 15 Mar 2023 02:56:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 02:56:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 02:56:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 02:56:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yu/KNfAkgqf2fykH8MU3ow0/EilJQ60QedmIgo8GeVbm+4NhXADbx/0im4N401bKeQ5Lr375inJ2ybRQQQZnH6LllsV6eYEzt3k2tO6OPzGxVSXfvgr+ThN37MJQIYRsYh8mJhW/1hhZ4hPtZbUFHk51HeW+5ZdCCwd8Ou4mO9LPSgwwwLmokvJOd5mWd6G5CowX9qVKic9mAYm9OUIP3iZ4vcVNMc3bZkPhWTTcQIHX9nxhlREpIaNZ4dlaAXSxp90CHix03vrVQsNsYHY60AsO4fbmUioRl3K1XlGcgNPZkW6LFO0lv0g0bkfuEWx9m4J1eAuqMXirvYwyd/78gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wwg+Kg0LbzqSWIv/7lETpUanHblpfeM1MKTyZZCCVtU=;
 b=fmP6iBCW+qkI4BY11M0Gr7gAyqlrfdiHlotURw7ShUh/mQJENMqlWB+A3BFb/G9pafgVyC6cXRlHkanX+RzSyLMbHsKqhnU1AzQQvTadpqLxIb1dD0j96i/LdUp0r1xH5WP2rSvR9gGPq698bWCakoEnzivPYrBT2UTF6P650YAvo9AZWf0cRLuKWpEUMmYk0RrlcgMcVhIuyh8bTCP8npoNp/5VTP8lLl+RhOyat/yojo/4CIjEUC5Nc5xxcT8dAgOFANFVmFiBjJti1p5NgZ8DvXSqP7Tug1Y4bs4qKy6qo0F4aA3WBlRUKWFDFNDFk7CoTiPP6rygWXo8IQVGvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ2PR11MB7618.namprd11.prod.outlook.com (2603:10b6:a03:4cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 09:56:39 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 09:56:39 +0000
Message-ID: <356f0d97-84ae-d508-93d2-a3a68187e03e@intel.com>
Date:   Wed, 15 Mar 2023 10:55:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [Intel-wired-lan] [PATCH net v1 1/2] ice: fix W=1 headers
 mismatch
Content-Language: en-US
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20230313203608.1680781-1-jesse.brandeburg@intel.com>
 <20230313203608.1680781-2-jesse.brandeburg@intel.com>
 <f0c898f5-f4cb-34dc-91f6-a83106c52c0e@intel.com>
 <cb406635-0c44-ef7e-2bc9-3c1ecd5c2779@intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <cb406635-0c44-ef7e-2bc9-3c1ecd5c2779@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0202.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ2PR11MB7618:EE_
X-MS-Office365-Filtering-Correlation-Id: 698618ed-aeeb-4865-d69b-08db253b926c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X2W05ltodkr/Wxc38WsirpgQaqZjpSseLDqZlrQGOgCUzly6e22EcFxFRQ9IyUiGzUleOXLzXq20h0Rtozqdg24KDFE/5Qn72LpRWU4mwaiBM2iuWZT8RX5RThcTKepNq3E19HFUu18R3vsIcmh6XR1a8r8mb4T3EBsxKhB12qX11prue3FHjQ5r7syJiLvOzYTPFu4kAFS+q2eq/DhA6GV8NJim/UxVr+Tj8Db9hXT5NQP+GsXaxW4K92Clpoxg1LOopMRFAuSzUSWULuF3a8o/0XgD14uMCLxUdIKvIHubAEcSUitGKZc2anLX+QqyLa6Ur8Fad0Pr2WuNTNfupAhfclcrrVe1AK3DyWHzr0p+Eh+cCuCiEptMSPIo4/6F2Sh6gndJ6mWCOaBD4ZTtDHzAymNCJofXRQvtF06PfMCkSoraSQuOHWKmvld+l1M6bjiznsTFMvcJk+MNqI7Ne1mbW0ErQ8Il6gOWxtcYk47RZvQMqiczoAqezntt6vs9GAh+w9/GpXX0Vk2cA/UDN6ftoO9LwPHJ5EsyliOWtfrykm7hWj6hx4jTUW3s/n/J+YS7/ouCZoyMhOeu2OkHBZh/CxTbAgxe0Nvfn+bC3JPp+0rxz9r26e6RnhUMBcIBqO+hGPh99gUFqRRz8xj07grkoZdvUTirWM5n3jHsTKhVnOOerTziLPzlggjmBk9aL4SRk4dCtL63BhK4qYy0vAjORc0gHltZvjtNzXIfTJs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199018)(31686004)(41300700001)(66946007)(6862004)(37006003)(8936002)(8676002)(478600001)(4326008)(66476007)(66556008)(6636002)(31696002)(86362001)(38100700002)(36756003)(316002)(82960400001)(26005)(53546011)(6506007)(6512007)(6486002)(6666004)(186003)(4744005)(2906002)(2616005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUtxcFJsajNEazRVRDdBdTh5b2dsKzF5eHZ0QXFWRGVZNno4d0Q1c2hVWXJF?=
 =?utf-8?B?d3NDL3NweSt2WXUwYm02MXJyd05Bc1JodnE3aEVMdktJM2gzQytTajlRQ3ly?=
 =?utf-8?B?clBvOWQ0RndKRnhoUDlMa3lUSkQ4WmpDUHJRKzFrZksyTWxyc3RESTNrYmdZ?=
 =?utf-8?B?RmZWSWZZNy9MeUY1eU80SzJvYk1JSnRLUDlJQTE4YjF4dHVNNmNPQW5lT2Zo?=
 =?utf-8?B?RnFJcFgyODUxTHEraDRTT2d1b1FqZ1RkTG5ITDV2UXBDWGRrdDBpb1Z6RDc4?=
 =?utf-8?B?WUMzb0pWQWwzZnhMZ2g5a25jYmJ1Tjl2c2o4R3ptbmp2cU14RW0wUHVpd3BY?=
 =?utf-8?B?ZWNwK1E2UzdrdFpyc2VKdnRLdlFuOXhWY2VYQ09QSjM0T1FHdkFvY3BSY0dW?=
 =?utf-8?B?RkZGUFE4aVpXUTU2N09YZ29hN2M1YjhpMlpsR29sTDNvanJqd1N5Z0Q3QXB6?=
 =?utf-8?B?STByTGVxMWNlcnlQcDRWMkUyalQ2Q285bHQ0c1ZmVjYzV0FkRkFOd2JIZ0hV?=
 =?utf-8?B?M0ZqOTJFVkEvbVpZSmJQUld1RVRqVWduQTlKTm5OVm5YcWxFKzRQZHBJa1o5?=
 =?utf-8?B?VXFuaVIwOHVnaUxsZzBKY0FEalo2SDJmVk5YOU83SG90WkdRbEUyKzRKRWJM?=
 =?utf-8?B?UDdFempzVFIycXBBQVBpbXB5UmVCMnJienppa1lrZHlXUi9FQXcrNG5TdnJs?=
 =?utf-8?B?VmFROUgwLzFzOXJaZkxsWFRPWU4zTEg3NHcwVjFvaU1HRkxsSUhUNTFWTWVK?=
 =?utf-8?B?UG5FM3pvU284ZzhkcVliUDFINExJbFpOYjJlM1FZZmJuL3hpMDIwNEhFMnlE?=
 =?utf-8?B?OHRyOHhlV2RQbTJHNy9RbEpNRTZ1SnluTTdCWlArMC9yQlVYV09POXF6azdr?=
 =?utf-8?B?cFlFWmhiZTBERXZCeUxhb2ZjSUQrekE2L084S0Q2ajRsdDU1bjNwRDl3ak9S?=
 =?utf-8?B?QVVHUkRSUlhnRW03UXZXem1reVF4WTdzYmp6OE96Q3FiUk9KcEsxUll1eGhR?=
 =?utf-8?B?R1lFeDRwYXY1ODN6RTk2QWtvZnF2R0RNTlB0akVNSEZLZjhNeU4xN0dZQkVx?=
 =?utf-8?B?cTJVSnVlTDBhR2IwWmNuY2VVK3pzbVYzVHQ5YXdiNCtkM01EV0xnTVhVQi9x?=
 =?utf-8?B?ajhSQ0d5UFp4WkhQQlFqVzRtWG1aeEtzWDUzTFBCVE02Tm1MdWRWQmhva2ZC?=
 =?utf-8?B?bit4dnBWdTdIY1VCMlRyMFZLSDJYQVZnSVpoQm4wMFVTeG5rSGtqbVNQRzlD?=
 =?utf-8?B?Q0k0d1g4UkxWYjV3ZGNpdDYzM2UraVRZL2diVmJkaWdNWGQzbnhZUWRtd1pJ?=
 =?utf-8?B?SEErVWZqSkpaajR1ZW8zWDJOUmxCQ3BIOU0vL2N1Z3U0U2lQT1pCS2tFaUl1?=
 =?utf-8?B?aDY0YytFVlF0ajUreHVYVGpZQzFaRkdRaW01cDBWU0owMjA4WEdwaFFmMVps?=
 =?utf-8?B?ZlAvSHI0K3ZreTZBWU1iaGxRVDdyZ2RnR2FNTko4a2VqSFlYd090bUE2TmxG?=
 =?utf-8?B?ZzJ0RlplREhQa3dRUGJFN0dsanlCYU1vOFBkM2szR1NtTm9ERzVydHM5ekFN?=
 =?utf-8?B?Y2tFRFZtMFkyNTBRMW9wR2RoakFQeEFpOU5seU0reHJtMklIN21PSEJpZGU5?=
 =?utf-8?B?T1VPS3QvbG9VK2I0RmRKN3cwSGNkeGt4ZlJhYUY3eWJiNUJVOThnSGd5a0ts?=
 =?utf-8?B?dzVOZjFQb1Q4cWw1L01NNHVKdFh2elhuWW5LLzZqY3E1NXNFNmZwWnpRZnNU?=
 =?utf-8?B?RGthWEpDVEVCLzBDN3RHQjVrTmRNTkN2ZWh1SEtIeERzUEJKV0xKa2RJczIr?=
 =?utf-8?B?OGtjNWVaS1c2aHVxRTZ1SFlTeTQxWjJINVdlL2o4MVd6UnVKOWpaZm9kYVUr?=
 =?utf-8?B?b204UkVZQUEyQktFNlY3dFlLTjRGMEpGMWsxZEs1T0FCb0tmczRBd0s5NHYr?=
 =?utf-8?B?cGhhbkw5d0FtRGI1OUlwMFJZVVF2cHBTVWptTExXNHpLTldXNmJ0ZVJCUmJY?=
 =?utf-8?B?SXBrczJCd0g0anlFWExJTjRvUWNXVEtzYnJIbVJqZ0VHMm5tVGt0R0k5SkdE?=
 =?utf-8?B?S1h0ZS94cDRlcERpUVFZcEFmYjF4Q2hDWGxuajdxM2dGZWxBbW11MVQ4ZW55?=
 =?utf-8?B?UG1sV2s2cjBTZ01QUlZZR0dTUCs1WEt4TlZGZU1veGR4aVFlUXo4TFdLZmFi?=
 =?utf-8?Q?Zymcc/9hTQV2SPAaCgSIuis=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 698618ed-aeeb-4865-d69b-08db253b926c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:56:39.5773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/RQ49XYXE/dxS1jx9SceklbG1wwqnv7doaFjtTXr3/S79vHWR+E1qhyi2LBdWEXc+KKBo1GqcIEw8cHdgYcSxmXbkAbxCzbb9ymxSMdxbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7618
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brandeburg, Jesse <jesse.brandeburg@intel.com>
Date: Tue, 14 Mar 2023 13:29:41 -0700

> On 3/14/2023 6:54 AM, Alexander Lobakin wrote:
>> From: Brandeburg, Jesse <jesse.brandeburg@intel.com>

[...]

> Quoting myself:
>> Fix a couple of small issues, with a small refactor to correctly handle
>> a possible misconfiguration of RDMA filters, and some trivial function
>> headers that didn't match their function.
> 
> Please see the last half of the sentence, regarding fixing these trivial
> comment-only issues. If you still think that isn't enough I can reword
> or resend, but in this case I don't think there is anything wrong, do
> you agree after my explanation? Did I miss something?

I've read the cover letter, but its subject is "ice_switch fixes
series", that's why I wrote this :D That confuses a bit. I've no
problems with this spin, Tony doesn't preserve cover letter subjects anyway.

> 
> Thanks,
> Jesse
> 

Thanks,
Olek
