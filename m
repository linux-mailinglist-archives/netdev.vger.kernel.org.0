Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619C96BEA4B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 14:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjCQNkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 09:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjCQNkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 09:40:15 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D48BD5157;
        Fri, 17 Mar 2023 06:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679060403; x=1710596403;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KqF7akDK+KD+cioS3XfcRUmi7K/DiWzPN2fUCoR6O/o=;
  b=C6n+2LUk0DCORK+vwTilXcYfxpLYh5Z7/WnlvgED2EEskVEcdLZazH8S
   ZTr/78SUoGTXQlhzR9hdrPX8l1zwQahYq+PUEh/msgawA+i7lZuEglvJ5
   ImRXL9vnWFJ0SfAqQJHI8dKkToAt2VszAaOULsUKqP1E2TmFkaGIpgaSX
   Ux2eq/y87bCAyXO752dWfmP+elfZuSxGlEc9RfJNI1DWKjX3FKF4VdSpp
   Nl8+nRJOAOoqbwxqUDibqqMZu5UmkvTp9warLt+J1UU58dxB5wXWHHwxP
   3WFdoTJDSinQHPUkHn1d4/uTW6JCyTWorJ+a5JmBWq2TxDhwwVNHXWIoq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="326621034"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="326621034"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 06:40:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="712754160"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="712754160"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 17 Mar 2023 06:40:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 06:40:01 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 06:40:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 06:40:00 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 06:39:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpScC+EF03/QYDtyFaMTYCCXmAKQ3tBeL1t7P3zb/oWMgkyXZMDEdAFWG43DheBL4i826lEoGyQ61I4SvlzRNNFQOz2bgt0CCxzTVFSSCE0fJw43/0AeFKokwQme5B5ngc41B3nDSoYyxe93A08mlC/eJ1xjv663sHGHfARSUh4/YDbWObxBF4UMvyfnWLN9AckEAT4sZ0b1DT0lhsFXllUVXgs6ONUeDyKTtennMQYPrbcb+BgDP7Ag3JFngmLJR89N1ihsXRbgr2EWwUrhS4SHrEr/CbwP3wUxFndKIrTzKi4bgPD+9hJM5xqo2lMTC9JKdOnCZNbBc2P47V+tiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCq5wFLFynTN/q+s+aXni1XNzmJ22kDUB+BdhXkulVU=;
 b=oILIQp8TXoH2Qk36NaalpFgBWd7i14qWWTLgSoY5jqz7bwtwca47NkTfLwwV6VwGLExafzeC39my2X5Not9vMngFi8DnV124sDJXyqcYBfizvtc240yi/n83ceV7+u/OcRg5I9B7HKk9t/IK5+VotqsnfeT+RJJgGvUpuc2Xb7Y64rXRYqxLs8wRoZFR0JHVbU5aUOWBb+4je3h1F5hKsIt/x0dDa6KW39PawAH4oRPjz00jwL7fkBiGlcPzMQSPHoLj360FF3jLxKcdZg6JAP+8jT2U8cpFKDiS07bu+NhPxit0jJ0pS2oTV3zJCGQlOilqqlfqe9dMAd5CuGc3PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 13:39:57 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 13:39:56 +0000
Message-ID: <cdf1ae24-eebb-a9f8-65d3-01876334a33c@intel.com>
Date:   Fri, 17 Mar 2023 14:38:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: fix "metadata marker" getting
 overwritten by the netstack
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230316175051.922550-1-aleksander.lobakin@intel.com>
 <20230316175051.922550-3-aleksander.lobakin@intel.com>
 <875yb0a25h.fsf@toke.dk>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <875yb0a25h.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0171.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: 687543ee-a94c-4804-0044-08db26ed189c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFL2KMya/pnFmAdL3tb09t3PIQPQUItrRke9J/4wvRzH8+XCYl43WWxkBsJeXuy6++/2xnvtErnAThEXPzS4/3gdUCuSH4xSySBJsZTeVwmKhcalDZdWyVwyfo+V8Jiay/EnGMmj20sWBzQX1V8rcxHjfPvtE+/bDyExpcYoX8n8J8bpmOYD9iVKLBjg0HXpEUOAyC3v+KCvO3sUe3HOKbOAsSwUDplzpu7wfenNgFWdBR4F67Ypkn3MovsO1hiYrPYHfCLa2C71PfRe/KOJAu6rBBFfQyO3JVm2jVDOmk4GX6YxR/sIA8FLDf78zlVZiiDlpehVZ4YDYiDdXCSIUesIYY9UmPW39N9bO5wzsKNmAjY1nPM2Yp+gPYMZY+SNy2ACPO7pNqLV3zMrII7aA40xjOCfTRUUFb4rpz7j29+JMluYk1yn2jjCsLaWBlPl+JPR1cCSiG4RSSuFmtCgVC1chCTRPvt6/QvEQCGS85W+qfEjB/mmnjXw0d25nu5V38q6T0z0FdFLb0UydxFwkvhq6XjidkmxM59brUtLHIY+sVrEbjBnfwC+B986uI7A9FxwQk0amQUyzZ/xyGg6OePisRuhB3NbjXMZptmRw5rU4Rwichuu0b+8V23pGxIm1BHzJ2s5c+hx/kCgcgVgfv2DwGO8iF2RaPeLJFeWBf8cB/aKVJSTlaFpIgvNiBZmW6rzBn7y/thWGppxkTbbLm9dHfnVnh2pJan+x316z7Xm17uo5cdoBd7lqEpnoccIA0D8RGhD1cQXFs7ei2WYfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(136003)(366004)(39860400002)(451199018)(82960400001)(186003)(6512007)(6506007)(26005)(41300700001)(31686004)(38100700002)(66476007)(6666004)(8676002)(66946007)(8936002)(7416002)(4326008)(5660300002)(66556008)(83380400001)(6916009)(966005)(2616005)(6486002)(316002)(66574015)(54906003)(31696002)(36756003)(86362001)(2906002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUNNcTcyZjFMc0RNbG96RXRXdmhaNndjTXFPQis0NGIweEZjeXJVOG9BOGxS?=
 =?utf-8?B?eVprNXdlMzRlbkFucDhRTGkrOTF0a1RXOWdZVko3VFA0UDl4Q3o2c3d0M1lu?=
 =?utf-8?B?bHJRY0hlMm1wd2VkYmFsRWwrMDBYNVdZNjJNYTZmYmtjWUJWOGJERzQwQVlV?=
 =?utf-8?B?RG5iVnhzRzZVSjRBSFBmTGh4K1RJeFFGV01BaTFESVJBRDROMG96REhxVVJ0?=
 =?utf-8?B?OXovMS9ac29QSllSdWF6WUZ3L0dQWmNJZnprQ3pCWGtDL2lCWlZ1YWVEYjVq?=
 =?utf-8?B?QldMV3J6N0RnenZ2K3pvNktaUFl1SFJTSmxhSXY4VC9CSU15U1l1TkxOdWtS?=
 =?utf-8?B?MDdkWDNkRzcvdjRwOEE1RFRkbitxOUFOcTVvRS9iaGxkNkl4MWRNdVZtNGd6?=
 =?utf-8?B?dkQ2cG1EaHVMMTRPY0VGa1FzcXdEK3pLMFI4TmpjVFRjT1dUTTVtNzRmdGRI?=
 =?utf-8?B?dC92bGhOWThLRVdGdnJWVE05ZmxiUTZxak5sckpLT3k2MUdUOWg5aWZrTzND?=
 =?utf-8?B?ZFM2RGdpeUlaK3ZiOHVKSDl6c3RxNXdYYnVhcWNEWUpZck1ucEUvSHAzUWNQ?=
 =?utf-8?B?Z0kreVJvdm94WDJoUGF5ck1EeVljOW5rSm9DZ0x1azFFOENTdlNqSFlYKzEv?=
 =?utf-8?B?eUlvUkQxQ0M5Q25pTnM2NG0zWmN3N0J6THZjclFFNFZGQWhTSUtCMTRaWEZW?=
 =?utf-8?B?STJSUVJPUUs5MytMdXFJb2RoWVpNTllKZXZOTE5jZ21KeFhpSUJORTB2Q09X?=
 =?utf-8?B?Vzd5WXNMMHlkWXN3NEthRE14SVIrVkVNTms4dVNBL3F3UUNxQ3FUN3EyVmpk?=
 =?utf-8?B?Y3d4cVdKUGt4Uk9ZYmV4UkpUVmVZT0h6WUZVSTZPckJTUU5DNTlSUG1rV1dV?=
 =?utf-8?B?QXh4TEJkQ2hmaUJDeklOTkY3eVUzZlN5d1lmTjc2eFA0dEVpMUF4Rm1BMmlH?=
 =?utf-8?B?QmhBOCs0cmFicVkrY1JvV1FrNENXWVNHM1VIaHFQeFpoaDB1ZmVrRXlsbFRz?=
 =?utf-8?B?MnhzcmVUOTMra2JPRUJZMTcxV1IrejZWS1VsajhGNzR4RE1zMEh6MDZWcEhC?=
 =?utf-8?B?aEZEbXMydXdPV3VVbXFGbDV4RU1WK0o4aWtmVjlRdjlXZFZ1NnFtM1FrRjBv?=
 =?utf-8?B?VCtNUmNPWlNkOEpmNCtwa1B2TW1ZTnB2eGtScVNGWEJkM242b2RvSkhjQ294?=
 =?utf-8?B?SnlEeTJGemc1MDBuZjJlZVk5bndtQ01RMk0vN3FDVmVnSVQ5ckNlQlVWdUhE?=
 =?utf-8?B?N3hEWnhqOFRxNFJZaHJRTE42ekZhN0tCY2RoV0t6OUlwT1JqTFN0ZnJmY3Zl?=
 =?utf-8?B?TXgxSEtoYTFDejhEZ2t6U1JNa1MvaXRrM2czK0tES3MyZFU0MHNRVDJlaWdS?=
 =?utf-8?B?WWNuOFA1YVF0SFRiUHpZb2Q3K0JMaDNiUHdqeXNUbVUxWmtPSi9vSDRtZG5L?=
 =?utf-8?B?aXpYd1ZmZzE4VU9Ebk41ZDFMZFM4QlBxR0NxaUduOEZ2VWNVNFB5OE9NVTBW?=
 =?utf-8?B?U0hzSDJPKytpV3NEV0VWdzJHK3I4cFJWQUpwTTF2dVYwbzZaWFpUa1paT05z?=
 =?utf-8?B?UU1Relc0ZFBlZVZFalVySnBROFlOazR0MVh4VFhnTFE5NmNFa0ppbjFkYWht?=
 =?utf-8?B?Vkk1RVVXWnhRcXlxaHhUenNoUytDcDlFT2lWL3VDOGIwcnFGQmdkV2JaV2lV?=
 =?utf-8?B?V0VJem9uYUczMHpFclZkRHl2aXhVVU1rNDFKelVibVVtYy9lQkI4a1Q0dDc5?=
 =?utf-8?B?U25pVHRjTCtYYURTS2JjNDFkakZqTSs0djl2UW1rNHc1cGloNFFPMVlHWVRo?=
 =?utf-8?B?SmJPOUd1bTRCQk9HOW9MUzZMZVVwczVNOWhVQkhrbHJjbFE0YTVaTEtnQWRE?=
 =?utf-8?B?Qi9hTzd3R0srclkxMkdlc3BrRExCQnVtWFk0VHhjekF6ZlYxeHlKSDNzWEor?=
 =?utf-8?B?ZzE4WURKTEkrT0NtRDBMRlY0S29HMEVVMlNrRXRGOTlXSDVQeVdkZXhYSGdU?=
 =?utf-8?B?R3NyZkVOai91RkhuVGpMc3BGN2R3OGpTeitNUUNNQkFRNUwwTWhBM2JMZWk1?=
 =?utf-8?B?U3NjVDZFM0VLTGZWZGhnbHdneGpGNFpDeHd0c1ZFUEVSemtlNkNoNWwzcDJJ?=
 =?utf-8?B?Tkd4aFlpQTN4RnYzbTFhYXFnWXJQWUEzTVByamU4Q1h0VittNlJCdUFwV05H?=
 =?utf-8?Q?rxLwuQoJF0EWNNP58T3Ug2g=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 687543ee-a94c-4804-0044-08db26ed189c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 13:39:56.8319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UyR9MzZPW/eYZmS4vaNxpkzgTDvh+gA/4TMDbUAnO/4Ac3EzHtAfZliXDAg/lrnsCJeIcnDIATLFI7IEFYYkuH+ha26wgb83mS1CiPAmZIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5978
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Thu, 16 Mar 2023 21:10:02 +0100

> Alexander Lobakin <aleksander.lobakin@intel.com> writes:
> 
>> Alexei noticed xdp_do_redirect test on BPF CI started failing on
>> BE systems after skb PP recycling was enabled:
>>
>> test_xdp_do_redirect:PASS:prog_run 0 nsec
>> test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
>> test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
>> test_xdp_do_redirect:FAIL:pkt_count_tc unexpected pkt_count_tc: actual
>> 220 != expected 9998
>> test_max_pkt_size:PASS:prog_run_max_size 0 nsec
>> test_max_pkt_size:PASS:prog_run_too_big 0 nsec
>> close_netns:PASS:setns 0 nsec
>>  #289 xdp_do_redirect:FAIL
>> Summary: 270/1674 PASSED, 30 SKIPPED, 1 FAILED
>>
>> and it doesn't happen on LE systems.
>> Ilya then hunted it down to:
>>
>>  #0  0x0000000000aaeee6 in neigh_hh_output (hh=0x83258df0,
>> skb=0x88142200) at linux/include/net/neighbour.h:503
>>  #1  0x0000000000ab2cda in neigh_output (skip_cache=false,
>> skb=0x88142200, n=<optimized out>) at linux/include/net/neighbour.h:544
>>  #2  ip6_finish_output2 (net=net@entry=0x88edba00, sk=sk@entry=0x0,
>> skb=skb@entry=0x88142200) at linux/net/ipv6/ip6_output.c:134
>>  #3  0x0000000000ab4cbc in __ip6_finish_output (skb=0x88142200, sk=0x0,
>> net=0x88edba00) at linux/net/ipv6/ip6_output.c:195
>>  #4  ip6_finish_output (net=0x88edba00, sk=0x0, skb=0x88142200) at
>> linux/net/ipv6/ip6_output.c:206
>>
>> xdp_do_redirect test places a u32 marker (0x42) right before the Ethernet
>> header to check it then in the XDP program and return %XDP_ABORTED if it's
>> not there. Neigh xmit code likes to round up hard header length to speed
>> up copying the header, so it overwrites two bytes in front of the Eth
>> header. On LE systems, 0x42 is one byte at `data - 4`, while on BE it's
>> `data - 1`, what explains why it happens only there.
>> It didn't happen previously due to that %XDP_PASS meant the page will be
>> discarded and replaced by a new one, but now it can be recycled as well,
>> while bpf_test_run code doesn't reinitialize the content of recycled
>> pages. This mark is limited to this particular test and its setup though,
>> so there's no need to predict 1000 different possible cases. Just move
>> it 4 bytes to the left, still keeping it 32 bit to match on more
>> bytes.
> 
> Wow, this must have been annoying to track down - nice work :)

I just blinked my eyes once and Ilya already came back with the detailed
stacktrace, so it's almost entirely his work <O

> 
>> Fixes: 9c94bbf9a87b ("xdp: recycle Page Pool backed skbs built from XDP frames")
>> Reported-by: Alexei Starovoitov <ast@kernel.org>
>> Link: https://lore.kernel.org/bpf/CAADnVQ+B_JOU+EpP=DKhbY9yXdN6GiRPnpTTXfEZ9sNkUeb-yQ@mail.gmail.com
>> Reported-by: Ilya Leoshkevich <iii@linux.ibm.com> # + debugging
>> Link: https://lore.kernel.org/bpf/8341c1d9f935f410438e79d3bd8a9cc50aefe105.camel@linux.ibm.com
>> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> 
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> 

Thanks! That was quick :D

Olek
