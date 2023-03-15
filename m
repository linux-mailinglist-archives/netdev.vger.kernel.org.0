Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2BF6BBBC8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjCOSOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbjCOSOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:14:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036B27041A;
        Wed, 15 Mar 2023 11:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678904088; x=1710440088;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=psW4ltM47YzFV+lI6WPgUwKpU1TugN5644KR9N4yiJU=;
  b=IUNR70hjDXpHglE8umtZ+Gw+suUgUzHfmOkOIq5bfeIsnJbXs3wqo1dA
   8l04zCMxloYGwIIpc67VoxGbfV2E9d9Xv8H3BCy4AFq1b3jTuCPBckoDZ
   fMz6x8a1rmg+zFm+AAUJkYtFizfHjKsTKKWeLJQYCbhVSKbZpIMNNOe4b
   BGgEnpPQCfMTVIY1K+q+xUKHqoJ1SpmH4rN3LPj1UidVu+lDou5yh8ame
   Xq0k1eTi3v+zBQcPpv+H/OHw/nKelmG3CAnXMPJPSZjP5UIMcCybCD3O6
   9gZSURYS6UUIgtGZq6iCd3Gi/Plnw91LtE6s+XqSK6OlHf2Y2uNfeB4A6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="424057638"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="424057638"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 11:14:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="709769281"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="709769281"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 15 Mar 2023 11:13:53 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 11:13:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 11:13:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 11:13:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDaVkkgCaBwNTCti0oFLuLleeOeqKppX4tyBL4WggXBin6fEkFSIVefXjFQvRg27bCyMl/iBS991DodkGJAZ8fsgeDmZl+wk4PkpIjrh31qsDjvdjcxBWPgT8ufcM/AgFjHVpZ+TbyJExcbrv90sh5BFAQx6YobYInM5eKnpTeWuSiqMvDLBVMRwC1YN3/qfdL5ttB9qIhuwJuAMfWaAXHoUM7K1krumzdIy74mY1VpHQxLCfcqAq5wkIFi1BX/d93U05hoUit5ryCLzQBPaHdBNJ/o4Y+jsYPiRkMrrdgDit0qmdilqwQKWMCwgtL01eMRIWWxRgt2pWiHqThYJOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gFtwMh+JjXETpIi2CEomfr6H6NcXVVezQeU7RL4womo=;
 b=I8uNt8Gu4+kmRlUEguYbJXMTozWTm5IKkAFob6+fQ/LROpMDsSHnq3EquoHPgONeT2hVtT0/6NmE4EoeUX05y26NNJwTkKcODN1mnWpLNkXeluHKT6zH0rQEuuPZgpQ8mCvqZpt9ESMgH2V+t4WpdAGdQNvN3O5BiEyRD56OpsiVJHiWhNxeFBB0/bW104pVviZcF0uu/laEV2qppjg4YdO8LilPN2xrZZGoRfCIvKYUEE0/ADpXuVlUxCJBiyu/Bsjrdt3MEWBO3v9/BM4TH2Dj1LzumK2UlLFL9o8OTqz1haTS3fVI+b5BPMs00C9QFB4MSemRTS9FrcM3eRSN/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB5410.namprd11.prod.outlook.com (2603:10b6:610:d1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Wed, 15 Mar
 2023 18:13:51 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 18:13:51 +0000
Message-ID: <62f8f903-4eaf-1b82-a2e9-43179bcd10a1@intel.com>
Date:   Wed, 15 Mar 2023 19:12:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        "Mykola Lysenko" <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
 <ca1385b5-b3f8-73f3-276c-a2a08ec09aa0@intel.com>
 <CAADnVQJDz3hBEJ7kohXJ4HUZWZdbRRamfJbrZ6KUaRubBKQmfA@mail.gmail.com>
 <CAADnVQ+B_JOU+EpP=DKhbY9yXdN6GiRPnpTTXfEZ9sNkUeb-yQ@mail.gmail.com>
 <5b360c35-1671-c0b8-78ca-517c7cd535ae@intel.com>
 <2bda95d8-6238-f9ef-7dce-aa9320013a13@intel.com>
 <de59c0fca26400305ab34cc89e468e395b6256ac.camel@linux.ibm.com>
 <e07dd94022ad5731705891b9487cc9ed66328b94.camel@linux.ibm.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <e07dd94022ad5731705891b9487cc9ed66328b94.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB5410:EE_
X-MS-Office365-Filtering-Correlation-Id: c6afacc9-57e3-47f6-de38-08db25810797
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mj0Di+R+ak1ms3Oqixvuf/BAXj8MJMMY5FjgNxyx61w2DzR7+Fa5fUwop8Q+BPLRKgBDPLcAxNjD/4GFIDCnLBdyN1gCfMh/dLr/EPcgJQZgdcbkUR0sm7wZLh8Z5mhe+vMuDoYMmS77gS2QZderP1+0CEtrV71H5RsILQdESCC0uGyrpQEFEaOZJbYkFKJkr3mQWRSH2mAeOSwRL/a5ruo5Cpc6Z8kWCYLMg7StoIQiMbxHjpGRbi4klHiEk6ADP49vJEsoOMDKeaBGhnXWmVrGKqGD/u1xF2dxt8fcwVxoGBMkbZge1eP689uRFtFcJXWj9tzCOdAIO1wUvW5ihEUOgHcIRJSEu2wS8Sb21j9aFvN15VmhDhqrKlPQvXpmQMwceC1PQBTWd6ksw7yzKE/wWOsMZgvobMIbZTVD/K58I9epqDVLQBaVzZmHtdTN4c1DcS18zeeEOPaSvPM28fgP9xesjB7lmeqRFi68vskE8tBgZFzZwYs/TUTUjPAeW3XD0aHsbrID48Zd3D9XosMDj/NxLdASEcdw7NeL32FRzGb4vtzpcH3yaqhq9R4RadusfTMstbs0juvqPCGO+hNjMWE8CYL3tw/FohuCl5lGYdE+YHBcOnN9+39fS6GwAsh9eOIPnoXIQSPNTMjdjFlWHDufcC2lhO6lIgeWDkVxQR/1J7RTNrHTqCLt3lN4hKA/FFPky8lItnJ8ZtpCdxMhlgbXkbFmo9v130/Oqzw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(136003)(366004)(376002)(451199018)(82960400001)(31686004)(5660300002)(7416002)(2906002)(36756003)(31696002)(86362001)(41300700001)(8936002)(66476007)(66946007)(66556008)(316002)(110136005)(38100700002)(8676002)(4326008)(2616005)(478600001)(186003)(54906003)(53546011)(6666004)(26005)(6512007)(6506007)(83380400001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mkp0VmVWcEVEZkJSTDNsdi9oYmVwRGhzTDFtM1FPMkkyWXdSZXBUT2lXclBp?=
 =?utf-8?B?cVRMY2tuWjJIOWs0OGpWckVaNzZ4R0wrc015MVZ6M0piWTViM2hBWWI4eVRz?=
 =?utf-8?B?Q2lSZ2NQd2cxUVhBTlduUzZ5aUl0T0ZZZ09SQ1MrWHYxV29YQjRBNmtVdHBs?=
 =?utf-8?B?d005eCt5V1NoZWV5ZFhQbFloMmdKWVRtZ1dpeEZjVmtvZmZycVdTY2VqTGlm?=
 =?utf-8?B?U0tzUi94YTZQVVRBMDFIZ09tWlJ1WG4vaS9IOUtZTk5DTEh1K09CNUVzRk5P?=
 =?utf-8?B?ZzAvOUxYTS9ya0tIZXBZaGE3dXFJNHRjZG05Vkd0NjFoL0I3SE5sZjY5aWtT?=
 =?utf-8?B?d1U0amZaVGc2QzlsUDdlVjYwSmVQdUFOSy9tdzVjQys4eWxRZkVUalJwMHlv?=
 =?utf-8?B?V0dJc1VDRHB6eVVqMlJaWVZkT2hwOHY3N01nS0RhTEt4MnQxMGhQdFJuOHN1?=
 =?utf-8?B?ZmorcTRzc1FSaWh3RjRwZ0hNQmphYTJCSGMrWnNtL1Y3TTNBVE9Xem4wcUlo?=
 =?utf-8?B?dGViUGNyUFlUNk1DN2tTdTNhOTgyUGF2dnpDckZYU1prejUvN0VOSVFzbUh6?=
 =?utf-8?B?QnJGdlgvQUplbmlLeWdjbDV0VFp1SUR2REhTOFVwWWtSM0JYRUl3M0thMW8r?=
 =?utf-8?B?RElBVmpVN3FnLytNelZmRkIwVmt3Zzc4alhjdXBiNDBwMGZsWjVmVVA2NUl6?=
 =?utf-8?B?T1ZlVHZ6cGRJVzNFbWJCM0Y0NmpiMXVjYUNCc2VUVm0wTVVNNWl1cjJkYjdv?=
 =?utf-8?B?cXkvdGZLVDd5dkE0c1RKUllYRTFXM2Q2cEtjWFRFN1Jqd2ZIRGJpNE5ZQkY5?=
 =?utf-8?B?S1JRUXU5RlZ3YzlpRm1PSDBDdStreDRhalpYZ1U5bDh6bmJRREwyRkNCdVAw?=
 =?utf-8?B?VDViMzhpa1kwTVA3U2pQNC80aExXejRiWWhiaHhpR2Z0cmNsS2ltR2Q0R3N6?=
 =?utf-8?B?akdHVGVocW13cDYySHF5UkxEdlR5RzIvNWlkOHkwbjVyeFpGdWVQTmNScHhn?=
 =?utf-8?B?aEh5WDU1Y2lXL1owdXlKSzVQUG95alYyR0lrdlp6bUhKQkdTM2pITG5pYmFw?=
 =?utf-8?B?VGNGaGIrTXczcmhSaDRwN0M5RGNINjE1VmlueWVBaFdtd2d1cmlLYnBqaVU0?=
 =?utf-8?B?U3VwREluSk1RUlRYUm10ajl2a0VQc0xoRjdBMm9idDAxcURLZG1ERk9qNkQ0?=
 =?utf-8?B?T2RFMHl3TDQwUkFGK1hVcDBFMzNTejIyZW1MV1dmQUo1YmtvL1pvZFM1L3Z1?=
 =?utf-8?B?Z2JxWmtSWUVYVUNRY1ArcGlwRGFQZCtSb3FGc3FVd1BjRXh3bG1JNWJxc1g2?=
 =?utf-8?B?VnhHTkZOZ09uemNUUVM0K0p4bEdQYmZ2K2QveDdWY0x1aEFsMGdiS0JKbXJN?=
 =?utf-8?B?cTArS0J0V2poRkFycDNlajB4eWk4R3U2dTZaa0tLQ3hpcEVaanI1dVc3d2FV?=
 =?utf-8?B?MStDYXhtTDBxd2N2aHd1TlZrcytqcFdILzA4dHpXeGlrSXpOYXNGMnZ4Nmhn?=
 =?utf-8?B?TVlLdWtIZ1QwSU9sS24vZnRNNFc5S29OWFhhaVdqRlpmZVByUkFqTFNJM0xs?=
 =?utf-8?B?MW9zaVhNdnRNeEVIVXBaNTNmTktCZDFTWHQwbGdwdml2VWlVc0tmaXQ4SDRV?=
 =?utf-8?B?Z3htWXpzMVNlQytkeVJINGZVajZkcnkrMHFhVHlWdWVqWFQ5QmI4SmNGM3B3?=
 =?utf-8?B?WGdDdzlVTXdmT1J5K3g5djNhcGppTk9nSldsWmlJaHk5Y2hkd25vbjVkUGZq?=
 =?utf-8?B?NHV5TTJ0QWllZjlzUUF2aDAyWW03NlNFZTFnNitOK0RLQnlmcDFkejRiYXdD?=
 =?utf-8?B?Q0xlczBBQXJ0STVVUlNWcCtDNlNxTDh2SmxFNEdSREk3K2tPNC9LNzF4bFpr?=
 =?utf-8?B?bjhBVEtOZUk2Y2NqdnRCV0RXbXpZZStxOGRZQnNYc0JJaWhYcnpSaDFaMUhw?=
 =?utf-8?B?MEp2SWI0dXdzT3hFSzFjTWg5UlcxZjNKMFBpNDF2RVZrOXNtRlBIZzFHWXRU?=
 =?utf-8?B?RWFUNHBHSFNnRlhsVXNTeWdZY2lzWmlTOUcyUmZHcThHMlpPSlpBUjBZeXFL?=
 =?utf-8?B?WFBCNnVNQlBlWlBRNmF3R2xBZ3NtVVdvRnAzNTg2ckhYMmVoYS9NcFNlMmli?=
 =?utf-8?B?UENLRll5UXZlR291Wkg1QWhnenV2bjlodGFaL2lRdnVDMVFBcUdHdTJTSDB2?=
 =?utf-8?Q?uQZw7Cux3fDpAVpDs4ORkUE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6afacc9-57e3-47f6-de38-08db25810797
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 18:13:51.4896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLH7zW9ZeNfTijR16wMpHQXzMFH2VuMKwCW2VC37A1nyMf4xGebTZyKmilkeUeSEEcgOKgzfHnbU/NzupvoEVMegfjqhRdC1iGL9KLzZGL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5410
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

From: Ilya Leoshkevich <iii@linux.ibm.com>
Date: Wed, 15 Mar 2023 19:00:47 +0100

> On Wed, 2023-03-15 at 15:54 +0100, Ilya Leoshkevich wrote:
>> On Wed, 2023-03-15 at 11:54 +0100, Alexander Lobakin wrote:
>>> From: Alexander Lobakin <aleksander.lobakin@intel.com>
>>> Date: Wed, 15 Mar 2023 10:56:25 +0100
>>>
>>>> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
>>>> Date: Tue, 14 Mar 2023 16:54:25 -0700
>>>>
>>>>> On Tue, Mar 14, 2023 at 11:52 AM Alexei Starovoitov
>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>
>>>> [...]
>>>>
>>>>> test_xdp_do_redirect:PASS:prog_run 0 nsec
>>>>> test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
>>>>> test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
>>>>> test_xdp_do_redirect:FAIL:pkt_count_tc unexpected pkt_count_tc:
>>>>> actual
>>>>> 220 != expected 9998
>>>>> test_max_pkt_size:PASS:prog_run_max_size 0 nsec
>>>>> test_max_pkt_size:PASS:prog_run_too_big 0 nsec
>>>>> close_netns:PASS:setns 0 nsec
>>>>> #289 xdp_do_redirect:FAIL
>>>>> Summary: 270/1674 PASSED, 30 SKIPPED, 1 FAILED
>>>>>
>>>>> Alex,
>>>>> could you please take a look at why it's happening?
>>>>>
>>>>> I suspect it's an endianness issue in:
>>>>>         if (*metadata != 0x42)
>>>>>                 return XDP_ABORTED;
>>>>> but your patch didn't change that,
>>>>> so I'm not sure why it worked before.
>>>>
>>>> Sure, lemme fix it real quick.
>>>
>>> Hi Ilya,
>>>
>>> Do you have s390 testing setups? Maybe you could take a look, since
>>> I
>>> don't have one and can't debug it? Doesn't seem to be Endianness
>>> issue.
>>> I mean, I have this (the below patch), but not sure it will fix
>>> anything -- IIRC eBPF arch always matches the host arch ._.
>>> I can't figure out from the code what does happen wrongly :s And it
>>> happens only on s390.
>>>
>>> Thanks,
>>> Olek
>>> ---
>>> diff --git
>>> a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
>>> b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
>>> index 662b6c6c5ed7..b21371668447 100644
>>> --- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
>>> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
>>> @@ -107,7 +107,7 @@ void test_xdp_do_redirect(void)
>>>                             .attach_point = BPF_TC_INGRESS);
>>>  
>>>         memcpy(&data[sizeof(__u32)], &pkt_udp, sizeof(pkt_udp));
>>> -       *((__u32 *)data) = 0x42; /* metadata test value */
>>> +       *((__u32 *)data) = htonl(0x42); /* metadata test value */
>>>  
>>>         skel = test_xdp_do_redirect__open();
>>>         if (!ASSERT_OK_PTR(skel, "skel"))
>>> diff --git
>>> a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>>> b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>>> index cd2d4e3258b8..2475bc30ced2 100644
>>> --- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>>> +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>>> @@ -1,5 +1,6 @@
>>>  // SPDX-License-Identifier: GPL-2.0
>>>  #include <vmlinux.h>
>>> +#include <bpf/bpf_endian.h>
>>>  #include <bpf/bpf_helpers.h>
>>>  
>>>  #define ETH_ALEN 6
>>> @@ -28,7 +29,7 @@ volatile int retcode = XDP_REDIRECT;
>>>  SEC("xdp")
>>>  int xdp_redirect(struct xdp_md *xdp)
>>>  {
>>> -       __u32 *metadata = (void *)(long)xdp->data_meta;
>>> +       __be32 *metadata = (void *)(long)xdp->data_meta;
>>>         void *data_end = (void *)(long)xdp->data_end;
>>>         void *data = (void *)(long)xdp->data;
>>>  
>>> @@ -44,7 +45,7 @@ int xdp_redirect(struct xdp_md *xdp)
>>>         if (metadata + 1 > data)
>>>                 return XDP_ABORTED;
>>>  
>>> -       if (*metadata != 0x42)
>>> +       if (*metadata != __bpf_htonl(0x42))
>>>                 return XDP_ABORTED;
>>>  
>>>         if (*payload == MARK_XMIT)
>>
>> Okay, I'll take a look. Two quick observations for now:
>>
>> - Unfortunately the above patch does not help.
>>
>> - In dmesg I see:
>>
>>     Driver unsupported XDP return value 0 on prog xdp_redirect (id
>> 23)
>>     dev N/A, expect packet loss!
> 
> I haven't identified the issue yet, but I have found a couple more
> things that might be helpful:
> 
> - In problematic cases metadata contains 0, so this is not an
>   endianness issue. data is still reasonable though. I'm trying to
>   understand what is causing this.
> 
> - Applying the following diff:
> 
> --- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> @@ -52,7 +52,7 @@ int xdp_redirect(struct xdp_md *xdp)
>  
>         *payload = MARK_IN;
>  
> -       if (bpf_xdp_adjust_meta(xdp, 4))
> +       if (false && bpf_xdp_adjust_meta(xdp, 4))
>                 return XDP_ABORTED;
>  
>         if (retcode > XDP_PASS)
> 
> causes a kernel panic even on x86_64:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000d28       
> ...
> Call Trace:            
>  <TASK>                                                               
>  build_skb_around+0x22/0xb0
>  __xdp_build_skb_from_frame+0x4e/0x130
>  bpf_test_run_xdp_live+0x65f/0x7c0
>  ? __pfx_xdp_test_run_init_page+0x10/0x10
>  bpf_prog_test_run_xdp+0x2ba/0x480
>  bpf_prog_test_run+0xeb/0x110
>  __sys_bpf+0x2b9/0x570
>  __x64_sys_bpf+0x1c/0x30
>  do_syscall_64+0x48/0xa0
>  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> 
> I haven't looked into this at all, but I believe this needs to be
> fixed - BPF should never cause kernel panics.

This one is basically the same issue as syzbot mentioned today (separate
subthread). I'm waiting for a feedback from Toke on which way of fixing
he'd prefer (I proposed 2). If those zeroed metadata magics that you
observe have the same roots with the panic, one fix will smash 2 issues.

Thanks,
Olek
