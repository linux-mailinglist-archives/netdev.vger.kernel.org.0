Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2926B517C
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjCJUL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjCJUL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:11:26 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A46F12BAF5;
        Fri, 10 Mar 2023 12:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678479083; x=1710015083;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wlVXFZVGaU2FZ11yt159gGylN9GgzV9sH08ZZQp+DD0=;
  b=JrgZTdbic5t8FZb4V7ReGv9+YvYo2uP/UKPv3Egy74hkl/4YQEsaeLF4
   8TOhuDYzxq65Pa0URf9UAKxP73EX7ppQgpmNMOqpXkm5GF/qwmjzNHeBc
   hiUrRcjPgazOj03QVaVd2w4NVnXUMHLmYVaEy1c8m6ROFODdtLU3vZudA
   jUK/En3UZVy6Be1WJf0uhycLpXEz1Z6NaZ+v8b4UDsg4trqknwVEyGSM7
   kmj3UHO1vHJywRRqWSvkKTK72XbspShZ3HEBPcDkEZIs88tN0Q3E/TJcl
   clSq85bjg5+JK4z5dfUUchWf/HMjkGDP4wIKcQNdtPxEsJHp5f2p9MY3q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="320673807"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="320673807"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 12:11:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="710401897"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="710401897"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 10 Mar 2023 12:11:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 12:11:22 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 12:11:22 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 12:11:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URwjZ84K//1ujDkyPygjlnKtb7wwn0qfmRzz8o+S8/jB2OsSwO6CmuSeiFKcB3gZ+Dpkw9uQCIAdW+Hb3vZmafpCZ4FjstA/UdgYz2wo7/p0E2dXJ2jj7/xq+3621VEYpfQwuGP9Btccu7dBCFnnc1fdCfVKG8ldz//3Z8H2O4gJSF/rQXHcEO/N/SfSEWZCZY/aQ5t6uRYbWPYWlaefMfOjuBqX6/vdiFxL6TOLWUZk8aOc+EICRSqex9rYPEltGhN0aylyY2voi97VRJFfsNduVlJZK5wf7IXwOePeVTitCGdhzzUtDZTF8M42vsd+05X58BxV6iGioTfRMnuLpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGopdrfoU1eU3q+g7ntNc0NvNzjS1bXTtyyDsoSqa5U=;
 b=nU9eVrQtcOZvjkfXLJimpZtPzVeKJXpLTWxN2QiTyN8P471S0oEORwrfNJgGiWFrfs3WRybcLLcbeSpxCYerEwa/M3L3BKz4+vecEKEbJXIdwBwDYYQAGhYKP+XopGejc7R4AO7+lAI2J1J/ehIzZwNBNgGNOlAmm8DCHGbkMpZdz5JubDeKsLJkY2D7z0b1oX6THtlVMm3h7QJbrSSLppQthlhhhtkvekVYMeydlrVjyV+wpzVsJU3brde4QHaAemvU+iwCEovWdXRD+Z3pDqVxg8sIQnll/qgLmWvXKUNyVp6Z55tdzWRwjOEVfQ9aifglof+ouQMQs07e5X7YsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB6147.namprd11.prod.outlook.com (2603:10b6:208:3ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 20:11:12 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.017; Fri, 10 Mar 2023
 20:11:12 +0000
Message-ID: <2d9fa4bf-dc59-26a3-10f7-69455e2fcf5e@intel.com>
Date:   Fri, 10 Mar 2023 21:10:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v2 0/3] xdp: recycle Page Pool backed skbs built
 from XDP frames
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20230303133232.2546004-1-aleksander.lobakin@intel.com>
 <73b5076c-335b-c746-b227-0edd40435ef5@redhat.com>
 <CAADnVQJ-kWG0eL8n5r3zBeXYaXihaqMcNrOP9++QuqsnhYzL_Q@mail.gmail.com>
Content-Language: en-US
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <CAADnVQJ-kWG0eL8n5r3zBeXYaXihaqMcNrOP9++QuqsnhYzL_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB6147:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a8f3372-85ea-4a3b-37ef-08db21a3982a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KBbWF+W+8ZGiK+34jXBevnbzjm4CvLUDAeB/y6OYc6M8V+x6D+qxahWnCBhCLlAAu4fLwtdmzNgKShrYb8YJNCu24ongc4uPK1HinqVJxwP9rznLJpxnQ7g33uLl1XtoLpBHTjk+VLlE3RlB2Q+4HH6UrH6NDld1+TvOg1MJ0xSX/gGlsRY0wKW0fl353vu9EfBqf98OXeQf67P7AmuXmrJcqKiZX21GpRTCIWA5M9kv4NetuUBNpm0BPv+4jEP/Md7aRMt+SZ/4a17OJ+pC+MDtWftmiE63Eg+euQWzn+XofOuq5q010SQ78ilb1AKyIhkqnA+y8uAC4farrsbOnvBuvuR/vHgJdA75r/w+fC6lq4j1VnacAVyyS6pfpjFltu8vPcAErkdsNs4VHRIKiXPw12Jli+0R3Gx+zv08u0tGcs4lWqbMLvivjL5hQCDZS8N89Cr0K6e4Ces5tjwPB9J7E4URr2CZ5ZkRcrmUx0KWxZOiDMMzbvA+prNiUwl+qbEm8lpZbfUpm5GEuLQUa/JJVAr9vxcCLORiTnNv1zdwT3LwQTwCLTBuWULO0jYAVWm8Tg8doKylBlZtuHedT52TyRSuTYFO4YFgabqNk4YheNhtMvzZYOma0HHIljgzc6CeSxgqAVQYuCpyrnaBlFluoqvKTSGqfVU1UJkHRe3CeQQauKytFmRGAeixZkgIeLie770XPXF2SMjRv1q/M4OgRuxgKwBuqmB8hZdPwjE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(366004)(396003)(346002)(376002)(451199018)(31686004)(54906003)(36756003)(6512007)(38100700002)(86362001)(31696002)(186003)(6506007)(82960400001)(26005)(5660300002)(2616005)(7416002)(316002)(478600001)(6486002)(4326008)(41300700001)(6916009)(4744005)(2906002)(8936002)(8676002)(66556008)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VndibUltRGYveVFKMGxnRGljTHF5dHpsU0lUVlhHUXRQcitjOFgxL3FGVWlH?=
 =?utf-8?B?VGdTSTE4ZUYwNzcvczJSRFlnRkxpaG84K2orVnZ5OWYwb3FWWlorQi9mTmM2?=
 =?utf-8?B?MnMrcGU5Q0MyWVVaRTdXdjlUbFRoQlNUc2pMUEV0UTROSklWQjNnSGJnTWZ6?=
 =?utf-8?B?UXYyV1FhZ0NlRS8rMVh6QmF5MnZOOEZaekFoaDVZeXFIamVESVJEMm5KMTNy?=
 =?utf-8?B?Rzc3WEtQamdtalRYNERnNC92K09rRUxWbzlHRXRTOWY3YmtpeUNvL3VhczZJ?=
 =?utf-8?B?alNCWjZPQURmYk5rcUxYQkhFUmgvT1V4dG1WUFMwYzhEQXhlbHRGNC96S3Fa?=
 =?utf-8?B?MC9FNHA1bitZS2ZzN2dhRVdpSnFvSS9BWHdOclYvZUtzeThybVlkbkdRd3NI?=
 =?utf-8?B?Y3V3aHI5OFFxc3lzUnZoVzZqOENkV241WUFLRTM2OGYzZEN1Qi9ERmtrdU1i?=
 =?utf-8?B?TU9LTlJ2dk9OQlVTcGYvZHc5T3QvNHA1V2xxQXJoSDluOGpJSGFyczFiTTJK?=
 =?utf-8?B?eGZGZnUrRG4xWXRRcHNzcFJqOG5XcXhVUUh6Um4rU0hWdk93OVhsR0hzMnRK?=
 =?utf-8?B?MEVvcWtZWFdoTWFiZVg0bmRHWDFsL1FpZVN6dGIrYzF1aVhKcDZyYkx4YjM4?=
 =?utf-8?B?REREaEU2ZktLZ3dSZUlqS1pQYnIrQ1psZTc5dFhod29Ca1pLOUFRZW1uaFgr?=
 =?utf-8?B?TzJIdE43QTFOeXZmQjhjVlc5WFUrNVA3NndrOWszRzFJditHYm9IS2UwZG83?=
 =?utf-8?B?V2ZMSzkza1F4Z241ZE5RVVJsMXVYM3E4d0JtcmVDRTNkOThuOENQVlhCMjFT?=
 =?utf-8?B?eXhndVY0ZHlNMG1EdzRkenVGdU1Ka0F3VHB5U09raHBsRU43QTJqb054SHpa?=
 =?utf-8?B?QjBqdDBrMUJkck5xREc2ZU5teVVDYW9yNUpPb0VVMjd4L1N6OGZsbjI4YkFJ?=
 =?utf-8?B?Z0djb0wvTDFiRjByU0FFWkVhSkZkcFRXb3I2TDZxMVAxZDhGRXdleVVTSjlx?=
 =?utf-8?B?SmZiR3pSemw4SkxUcXFhVlhCUHBVZnB2MG4zMHIwMGpmK0Job3Iyb2RKVlNX?=
 =?utf-8?B?bGdhMkN4aTQvTndWa0hUT3Q0Szd0MUNoTFFXLzcySlVlTEJVRnpNVXRaK2JB?=
 =?utf-8?B?NEZwS3RiaUMxUkcycHVDdkhxU2d2c2loSHBiNDk4ZDEyajd6RVcwOTdpeE91?=
 =?utf-8?B?SDBVamgvRmEvMmo0ZlRrQjNZRUpMRjloR1VvTk5TOWtweTVMRjFiMEVDRWhJ?=
 =?utf-8?B?a282aWM2NDdXdTJLTzlibWdWS0RqdlNhYlJkQkxwZnNnQXBJZHBXSUtpaHov?=
 =?utf-8?B?V1dpTzlqMW83VzZUVHo2QUhzL1ZVb2JjNDc1K0VlY1IxQjNFYWJoTVJFU2Y2?=
 =?utf-8?B?YVE2SlQyeVJzK0tTaCttZ2NZM1JjWlljWHJVQlIya3FpVEwrSkJSRUN2QzR1?=
 =?utf-8?B?VUlaTHdnekRVSjAxcDFSRTYzKy9PVWw4RjRPVDZBNU91amhteGc0NzJQNEVq?=
 =?utf-8?B?NmFqVTA5eFFUNGFrbmw2Vm83c0xVRUlWeUNTNC9nRlRra1N4Y2pPT2FMN3ZE?=
 =?utf-8?B?RVBvWnVoMEo5OTNaOHY1ZzFlY3RydnZkMGdMeHA5RkpYUVhZYmlDSGdJTjFR?=
 =?utf-8?B?K3NsblBEZk5xOWFMblZPekR1dWE0NWVPdm5BMElsZHFMQkY1NkpTYnhRSExz?=
 =?utf-8?B?ZSszbnNHSzZTVGZkUEFrRG80SEF2NlI0bm4yY21FSXpBRlYyaUxUbTY5dWQ4?=
 =?utf-8?B?TC9DTTM5bHArQUhVVkkrTC84ald4VGFkNDNrZmJ1UFRYRkY0WkZ0T0lrT0dm?=
 =?utf-8?B?TTV0Rm9uSUtCdHNHMVFCa29hV2gyNlNUdThCQVkzdlZlUUNiekdrRFIwcnUv?=
 =?utf-8?B?R1ZUcDd3NU93UExnSzJUWEVsTkVkUW9hNmIrakk2M2VZTkk4Nng4QUYzbkFK?=
 =?utf-8?B?bzRJN3p1NnA4cUlIL29jZ1Uvc1o4SFJhak5FK3M1aVZ2cVFMSHNSMEM2TjI4?=
 =?utf-8?B?VGcrcXY3L0dmdCsvcEpCNTE2OHZITDRRYS9NK2VycnJ6S29aMTdFQTVDRjBv?=
 =?utf-8?B?T2g4R1NCZjZXVHQyNTNvZ3p5KytDR3ZtRzc0Z01RM29jakIyeE5WVFFYK1BM?=
 =?utf-8?B?Q3hjeHpwN2ErOWdFaDkyVXZyN0NEYjJuTVExWmYrTmc5V2lBcDVzbHFYeEFF?=
 =?utf-8?Q?bCbhyZqm40FHkFZC+c3XFNo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8f3372-85ea-4a3b-37ef-08db21a3982a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 20:11:12.3252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qp4QTC4qF4wWvu0+UMY5cX8We11eKs/FjIrZ6WDXQAhYNkXB0IyW/jD3n8cTwa4nQNmVAQ0kg4UFNxOKIPUlW2HLnRyxcwmJLW4AehL0Yow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6147
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 10 Mar 2023 10:33:39 -0800

> FYI
> 
> test_xdp_do_redirect:FAIL:pkt_count_zero unexpected pkt_count_zero:
> actual 9936 != expected 2
> 
> see CI results.
> It's a submitter job to monitor test results.

Yeah I saw it. Just for some reason I thought it's some CI problems,
like "what could possibly go wrong?" :clownface: Sorry >_<

The test assumes that only dropped pages get recycled, while this series
actually implements recycling for redirected ones as well. I'll dig into
this and adjust it on Monday. The code itself is fine :D

Thanks,
Olek
