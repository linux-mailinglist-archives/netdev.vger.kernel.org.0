Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EC9698316
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjBOSTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjBOSTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:19:04 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BAA11B;
        Wed, 15 Feb 2023 10:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676485144; x=1708021144;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4NP67ITDa8J/HzqaDgyutLOm22Ev+iB5wxteQCZ3tTY=;
  b=gRfbiATP0PbQ5cJ9z4RXQI8C9ntUuea0jwz2D7ZJWdqkIzJ8WFRbaP9E
   HGDfVF3KsVu9l2wZMQHdkrz5WLQ3u+lp+1HQObR3FPp0S7cj7qQrTYeF8
   57WAsizUl50sZrybNPjDn6Cqv97gMyFgPes35l1H59isANO2qCyES/m0I
   rPNHHPv/aJ/C5FlLdEcoeoTbd0nBmEAY/Cd1VaohZFAgOFs4TJt+3YRyY
   CEnlxBbQWb+JfYBzQ1WF1U/kLCCh8xPKOtOeqkyhrOm+bgTaOI2NLBJ64
   mKlydNiONtEYZhudeXd1Jeis2nQgae2ofvmwLO73Je7OC4YpFcU6Zu018
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="319545779"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="319545779"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP; 15 Feb 2023 10:13:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="793647964"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="793647964"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 15 Feb 2023 10:13:23 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 10:13:22 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 10:13:22 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 10:12:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TO8WRnCG1yHkYOzDrdiNw6x/LO9iI7GbtlBoXrdtU/ZEt0JAzK1ZdLk53PenKN9NxvIiL4ky0kGJ6KsD5Ih1nIrRNrnF6G1HkzlEcg5l975EiISLRWltfNUQiW5tD51VY9uyP7OOGrUcXQ/IAJ3wvxEtG8MTo07gqxayLKfCQfSn2d5W5rrTe98mxqZuz70Mo3rgE+9I8G1OSqXJVE4eHDnIolCsYkr8t8WnjUVBFiaFNMBKNKVDrgihmIuCm7dmCpOSMEOtPfhkScc/dn1W95pmedWTmZyiahQicqeePUk7+mWl55oXi/ChXlQwcMExX5JCZdd++JGYj9hB0D50ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOmHv1I0WPexMR+kMS3bPj25Fzln0U+hjWN8rMEKlzY=;
 b=VeU2pkPGpA7sOLvWlOnGyGjZb/sv6E59Dk9KXXnrn9HLBkSW/7XFmXNykLgF+J49dSnFp8T0Dcm9jN/rs3GQtoriBOGfKW2/+oHuR1HCSzMc0FP55WCkloxZ2qgco4KvzEvxQq4F6NpxyIPB0+yA4Cu53GANCbWevkre+M/SHPh0HoSrshl7i113OEHIsI8EHbt5fxOMB4M29qZm5xAgiztUHGRKTi0iXztc4wYjyri+e+lEQXI3Grv5HxcaKwNkmorEDyc07lkNKuOnV5jQMW3fXvDODePIVyQabEJPxxbVAhNig0znBRvTjgLUpg0k/noeU0IO1ozb2y0vOhcZ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB5792.namprd11.prod.outlook.com (2603:10b6:a03:425::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 18:12:41 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 18:12:41 +0000
Message-ID: <447ea90f-bd4c-6200-4c56-8eefec7050e2@intel.com>
Date:   Wed, 15 Feb 2023 19:11:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230215152141.3753548-1-aleksander.lobakin@intel.com>
 <7629c295-fc74-41fe-fd2e-28fe3a6e0846@linux.dev>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <7629c295-fc74-41fe-fd2e-28fe3a6e0846@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO0P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e43902f-3c8d-4be0-7f2c-08db0f803a20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0hMCcc+F9reE7HJTxQMoZWbXrRCGpDrW/EzVqlprLzmqjKr/OSBeBQK0CoYkZTmeME1C9wlNlTmQrtCp61Wk2o6GvnUwOfo6x48qUbGDSi3IojF93Y2X9HgyiDGndX75Q0Q5NKZH92qfV8M5cNPeEL0kmE17JLAuWGogYPyxnrxNB/OGrJLHaSbDzFCM5Ivy7Yb1dT4RCBADPOE3TXgyh/iFNAxLfvafmdgR7s8g9HKpdNZCfeatvaN/3v8JqIh/kkA+qRuINO63mmbRaesJOKNzauEg5Cl2LJWQeyHkbSr4PxRMOwSE9omFQ4C5lTxjLsvpqUPsBkut0Xm+8nI+Cef/HTuA3qp8hc9u/Cf52S7DejZzGLNX3ROJofz+YzJ7ra1jSoOAtpl3h02bBn7AUjFjYwS8ChsLeVU4ba3I5JNIC89fhkMZRI5xMj8MKXk1cVDYiiuHRYV+aHqG8ZuvpSejcF06Qh1U19pHJl5z0THmTWo8SoUAhbNsoK/sWxYfhGwM/z7mnXML6HZM/+QA6AA7fzZY3a/4EbosBYQ01Hi6jbbXW/cANrb7iSAag/ZI/TDAm4HievZs/zFVkqF7qjlyUu3GQt/t/i7sYA8PQpvk3oUhYcmIfuh5TzV19bJcTBmY9roVa6nZzD7JL/7mu/kTMgavEgh9Jf+z2WvBg7LHDQGgQ6d9dvlepSosQFHk4sKoQRiH2ksh2f/jZBCk703s7dBneaRMjl8Ce2MHFjw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199018)(31686004)(36756003)(31696002)(86362001)(66556008)(4744005)(66946007)(5660300002)(8676002)(66476007)(4326008)(41300700001)(7416002)(2906002)(8936002)(82960400001)(38100700002)(316002)(966005)(478600001)(6486002)(2616005)(6916009)(54906003)(6506007)(186003)(6512007)(26005)(6666004)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzRwL1FHU0JJaUJmdjM3NVdyTGRQWEVzOWMzYVJnMGZKVkJqWHo4b2Q0bmth?=
 =?utf-8?B?eWJPai9ualFoYlloMlRUNXZnSUJibkptZkRrZ3ZWVWNwc08wbVJXb21NZ1ZO?=
 =?utf-8?B?MmtTQk1vQk1LaEczWGM3UmJEa1VwTGtlSmtJWkxNbXppVHN2YURRUGRWRm1Q?=
 =?utf-8?B?TGlsWFVOWThSQ1F3LytpOGJoanE5MnpWQjZWSzZ1eUcyMWsxN1d2MHFLMytr?=
 =?utf-8?B?VDk1bnJCUlRQS1hMQ01JaWlXMW9WMHo2ZFBES2F3ZEtISGdvaE4wTGpvY3Zi?=
 =?utf-8?B?STJvWHJyN0M1UDU3blA1SUJyL3ZrNk9NbVVqWGZCWmtrcHBQcEJwRW9rMlc1?=
 =?utf-8?B?TkJEaTBsNUk4R2o2S2VEQjlCN3puSlI2RFByalJLbFd1N0dyN1dkMEpiZmxj?=
 =?utf-8?B?WlV4WkJPT0FCaWZpWHRnKzJJdmZ3M0N5SnFNSjRKUmhMdXZudUtwRVF5b1hz?=
 =?utf-8?B?dThIeW1DRzhGWkJXR3FCOHFXTlNLQVNnWGtjNXN5ZzlJb3A3alptUFozTURH?=
 =?utf-8?B?U1FGdkJNc3FGa1lTMjlsZ3NuRUtUTFBkbXBOeVFLazRNeEZYWXMvejAvc0E4?=
 =?utf-8?B?RUNrZ09KVjFSWENGcklNbGZpSTI5eFB2UWh2bGg4b0RyUUhLUXpBR3lSTGpV?=
 =?utf-8?B?ZGlwZWl3VThZSWRJWjZxR1EyWEQwVDUwNjR3bEVPaEtjdXhnQXpZVDV6b1pT?=
 =?utf-8?B?ekwwY0loaGRnYjhPb2ZlQ0tnenNlSzFMVlRvQndpWGFCdklTbytrbUpCZXh3?=
 =?utf-8?B?ZVBZdGoya0JJaEJnOEEzSXB2SFY3Q3hITE43YXV1Y2JzM1IzbnRzV01mTTR2?=
 =?utf-8?B?d3VSS1NxU3VQRWk4QWVUQWY0eE9nd2VNb09qT1hWSER1QTlQL1JuRjV3TE0v?=
 =?utf-8?B?djgyRWVENi9SaXR3VEwzclpsWEhWeVk4R0JkYUpjWFVmTWcwQnBRWDloWUFx?=
 =?utf-8?B?VE1pNEdSOUNsR05FQXRUK1UzZjVNaUw2aFB1MlRVTDNsUTRVcUZGaDkvS2Ny?=
 =?utf-8?B?VHNmb1N3NDNqUGl1Qzhad3ptZGJ4R3lucWdjeTU5SCtGb0w4V242b0lNelR2?=
 =?utf-8?B?cXNGbzROUGZoYkhrYnpRSUt1VE1KMDZpeEtzelc2bGIvaGtHWEV0RjlSS2dv?=
 =?utf-8?B?anFYaGM5dmFZdlBxSXVBVHdzb3U4STVURDZzR3FIdVhRcHJxcUVYVThmSU9O?=
 =?utf-8?B?VFZadjNpOFNrSkZQMTlWMFV6elN0US8zR0dQY245c1U5UjlSdEYzOWRqaWRT?=
 =?utf-8?B?R0EwS0U3QmxKc242QVppVFZwMXBIaWRqbG8zUmVuMTVLVTJLb01NWkc2bUhm?=
 =?utf-8?B?Nyt2aDRXdk9CZFA2YWhYWEVrOHVlQmdicTEwZW1KM3lSdzNXbEFET2tUNjBD?=
 =?utf-8?B?ZEZEUVg2Zzh5dVlaYWhlRGxWNGJXeTNCN1pwcHc2bWJzS052dkxoblVSRUpp?=
 =?utf-8?B?SDFNTkdRTmIxR0svSGhuMW9sYytLbHZra1I3aEhRcXRkSHc4bkhGaDQyS2x0?=
 =?utf-8?B?NFpxeHliOU1JNDRDdWNqazNQZUNRNlVUcHpHUW4yWXBxODR6ZlNpZDR6T3Rt?=
 =?utf-8?B?NVFkclZodlpKRmN2WHNPZXNQUldrZmM0Q1hFTGRkMVZncVdUckdGK1ZMMHZz?=
 =?utf-8?B?R0JXWVN5YWVvN01IYTFwS0d6cm43WWM3ZUpzZkdkQWxma0xOVGltekRlMGdm?=
 =?utf-8?B?cEt3MWdlNVJxaENsd3dHRjNvbnorUHBqdkZzbmw3bFRDclZ4aFZjUkp6a0h6?=
 =?utf-8?B?UGZZU2xtb0tETkZoa1QzSDhkaFZvM0d1MFlVV2VNeUN4VEZBNXh1eEErQWZk?=
 =?utf-8?B?TnhoczdWSnpyT3I2aDBrUC9rSFc1UklQRjJqYTgzNGczYnNjYkZQR3VTSVps?=
 =?utf-8?B?VU9pbGZOV0pwN05DbGJoWEVVbGZKQVBySEorSjZpU2JYdjBBUElyV0ZnMFVL?=
 =?utf-8?B?SDhpU214MU8rekhKRlVmNjJ4K2QvY1FvVnpkTzQvWU1lK2ExZC9nTVhBOVFi?=
 =?utf-8?B?ekJJVzczWGV5SmRnMHBrZjhuMjNOU2UyUzhXQXdJL3JPRnNxVzArdCtqUzBQ?=
 =?utf-8?B?YlVUdE5GakhzS09iSW1wSmQxMWVzY2V6b3lCejdOVFBrTEJvdTVnaWorTXFp?=
 =?utf-8?B?ZUxOQVVqNmhHOG5Qcy9MZzJnN3VWZThPZ0hrYnNvc2JKeTFRY0FmN21VYXg4?=
 =?utf-8?Q?ldsuw0nj81FGtYFSPi6pOYg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e43902f-3c8d-4be0-7f2c-08db0f803a20
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 18:12:41.0527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1fXNwm5AHy8QmuT6Ej/5wgbeEyZlnleigeiea2/xZA7fTxiGKXGjS6mxKBKUdaxhmbbU5Pi6E8bkJk3V3AoaEuOLUzoDdz5NN9NQbD7xJf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5792
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

From: Martin Kafai Lau <martin.lau@linux.dev>
Date: Wed, 15 Feb 2023 10:04:51 -0800

> On 2/15/23 7:21 AM, Alexander Lobakin wrote:
>>   /* The maximum permissible size is: PAGE_SIZE - sizeof(struct
>> xdp_page_head) -
>> - * sizeof(struct skb_shared_info) - XDP_PACKET_HEADROOM = 3368 bytes
>> + * sizeof(struct skb_shared_info) - XDP_PACKET_HEADROOM = 3408 bytes
>>    */
>> -#define MAX_PKT_SIZE 3368
>> +#define MAX_PKT_SIZE 3408
> 
> s390 has a different cache line size:
> 
> https://lore.kernel.org/all/20230128000650.1516334-11-iii@linux.ibm.com/
> 
> The above s390 fix is in bpf-next. It is better to target this patch for
> bpf-next also such that the CI can test it in s390.
> 

Oh, thanks for letting me know! Will do in a bit.

Thanks,
Olek
