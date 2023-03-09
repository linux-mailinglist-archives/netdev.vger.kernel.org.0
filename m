Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDCF6B2AE8
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCIQhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCIQhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:37:04 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89572F98F2;
        Thu,  9 Mar 2023 08:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678379261; x=1709915261;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lmeaXMcdzsPEiGnYXRMcvrhDS2ywuYLH4O4G6dlV9Bw=;
  b=NYDH6+aegsUpU7mJ39HqgFmWo5UYrE3W9f61igijAoVcUgBewVdTkb72
   FSUfW3F4ZQzMTdvT4RHdEC6mKMt7xxCfbpR09Ta5Iec8WD41JMhScNYcF
   RZDYNbRkAf3CKXxuzUps19y1yv/Ynbyn1PIAiOCRrsPtQhiq00dNoCs0T
   kkgXJmD9pcNTQqPhU1MSEItxg/dlD2bxRFGnichluto4/4J3krD3IVhlm
   r4sdPWNfmL16wkZF5RSiSqKiArn54gxGHlKmfbLvdXhZohhB0ZReWl2//
   KvKeR1V08b0jrvVNhhoKvVfGJKucVZWBKk0hP9lrfrqx16RKbBrkN7wYC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="316148909"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="316148909"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 08:26:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="801231910"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="801231910"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 09 Mar 2023 08:26:38 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 08:26:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 08:26:37 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 08:26:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5dUF+duswbLvaKhKV7rIejuFx2nEE2DTQzEAm+2RDZN3UVZCer3AdD1kR+A3Bv6/dk0tqF+p86HcOIAhWr59bPNPbaE3ayX2vcGPs44T1MvFUMTJHomJLBU+Ck9JAkFOEA2WafLJmV/+Q9hbEya0UeTok+4NyS6DI378VFhIX62lqEOZUAILdMdxLacsBHo4ZGekubgmPWTnpdXdNWrpBiLcaJmQ35Q3ohsehhqRI24X32mHvEy9Z550B3kd4Lx9MjSOUTDCjTIe4wZHPX9TYBPe729Jv+NQVCauDL4B0KFiFSjdZdejehkii3Q0aVcA8nLhT0K9lnYVNbIzQ02mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nqx0Bu6jtOl9/KWaFyIbWyXSFHMG+r2OMpDfNlWVikg=;
 b=bocJNCpLbuDgi2RJ5aqTtzmDTLlQX0AB7aEWKq4gENcz7Cvq5+g/vBnGWt/UOF58hzpeQQZOyPCFi6Eh5aCUsX4dI56Xrcc00yQa/8gRRzLD+0HbXZezoKxn1TR5ghQ1YBUz/Y4gUVfEO07p+TYc5J6HuxfNII2P9ydfYgRY3zaHt0Ho85dY9bvt082vxIQGvMphcjBHWGpqNL4bLIP4ScBBEbH3kSBQESNBDEQ0Qj71STLJL24YQTZIXt4ap/n4OrzZZ1zd5xj9auF/vQJ6PE0awhk7rF7C/A2GtTpPutiYmcRXKKXQkgYMjEO4hpxeEWxuQ3AUqXAjohwP479BDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB5443.namprd11.prod.outlook.com (2603:10b6:610:d2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 16:26:34 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.017; Thu, 9 Mar 2023
 16:26:34 +0000
Message-ID: <e5be0165-c398-c84b-4f16-18e5b302290d@intel.com>
Date:   Thu, 9 Mar 2023 17:25:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v2 0/3] xdp: recycle Page Pool backed skbs built
 from XDP frames
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230303133232.2546004-1-aleksander.lobakin@intel.com>
Content-Language: en-US
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230303133232.2546004-1-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB5443:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b9c6046-0b5a-4372-7931-08db20bb0c53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBDaP5agpBYNZbxDMU9RYHU2kUDFYVvme3QgRwINb4rDoViO052aEmgCFvg8CBRHvsPTLww7hNWTS/rEw6bKuFwuiqftFcu8OrvWYaQxaDbh3C0f7+b9ZqKZqEnxWEnzlDP9m8luLfuu7k6D5iOANnXDNC2jw8ZyFuHYemSRYY24tnlW1WnuvcXL3aA9/cFnME+d9RDA3lHvyCVFQy00JLX9bFMp7DQ+IQYNDX4OO+RhiCZ0j5tU5k43+BA5OMco2ZeeL0MxzSUrcpX41MXR6ost0kIOdwIH23Uc3PKLqrFD4cB8FhIeUee++lT9KP9W5+uMUJ9FT55UNbS6Dbm+heh4lDi/VnI6IVzyw1yfXW6NWGm3xzJXOVEH85RmSpbKSvARAYHHb1YIEfc83YAsVdXSL+Oh7OhPugeVLHib4dm9vay09kpkCrpSDfAeuM/9H5/V7ofIReuYSrnnoAtFI4sIF8I6m28cARMTEk2eMo3bDwPno8czOi7b/xy8VG4Hdqx76UA+yFB9uIb83XxIYFx42OnbS1RKz3JaDqqfuUjNJQ0FXe6BIiNP/KmoCZXz7lSpi8nCksbqiCRgCASrOtlzkhLsNw1K8nmbX3Mp0vbijEtOPmiozFknvpgTpPdKaoeY39D3XyM4lpwOSEuqxiFERT11pw/pSGvxH3wALzMn89ocniO2MgSFq9U2gaYZQkB4vi7CHabhnuA63eCDZvODibwgyO5fGsgPVRPWaQM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199018)(8936002)(36756003)(7416002)(4744005)(5660300002)(26005)(6506007)(6512007)(38100700002)(6666004)(83380400001)(186003)(82960400001)(2616005)(54906003)(316002)(86362001)(66556008)(41300700001)(66946007)(110136005)(8676002)(4326008)(66476007)(31696002)(6486002)(478600001)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWYwMDk5ckYraHhFNEsxK3Y1RDdPRENFdFVlMDBYSnliRmhBaW9YSmhkcVBZ?=
 =?utf-8?B?U2lialpDZ2F0VHp2OWFJVzJnWHVEVXF2bEdhblZzQ3lUWGVvMGp1d1MrVHF3?=
 =?utf-8?B?NktZRy8vMDdEWVl2aDBCaWR4cTJlSndyMlpibndmUmlyTTVuVmR2T2FoR3Vn?=
 =?utf-8?B?UVo2RXBNeDZrcFh5dStqL1o0RWg5LzVTTWJGbGlZbktza3duTEozQ1ZyN0VU?=
 =?utf-8?B?dEsxcGREVVlISjRvSDBZWC9HNDVpYkc1Ty9mQTRpQklmamxoekJBWWtpdlll?=
 =?utf-8?B?eDd4bjFhdHY3ejRUZXBaL1B0TFU5bVg0NzZNRU0xc1M0WjA3YklENVA2SHdO?=
 =?utf-8?B?Zk5tSlg1bnVNOWh6MEJOdDUrT0hldTQrWmtnc2g0R2xwSzNIdmN5R092S0hm?=
 =?utf-8?B?ckUrNmxRMFRXYnlHTHpTclpNcmNwQXVSaHhRTFMxSHNLUkxqSklDaFRVemt0?=
 =?utf-8?B?Tm5JQlhSamtSd2pNVnhDSGREQSthcnBmbGc1bW9zcnU0Ynh4T2V2aXY0ekVr?=
 =?utf-8?B?V3EwY0lEb29uR1FHTVBobzRNTUwxOU4zYzkzQVlLWDJJSzVKVVNwZkxxMk45?=
 =?utf-8?B?ZjlQZ0FlbUJ6SmIra2t3WHpEWkJyOFNYcE5ldUNrTGc3UkNnMVZEaTJWL3JE?=
 =?utf-8?B?bDBVdFhFMlpKQkFrSWoxVTZSWDB1U1RxbVEwcXJQUTZFaGhhSlRlVm5aeW9T?=
 =?utf-8?B?MGlqUjEzS1NPN2ZpdTN2UDJLeUVzdEdpa2xuNDQvQlExMzdjczQ1YzJhblhr?=
 =?utf-8?B?V3NwZUpNREdHZENGdnVRUGFSSC9OM1pQK0tmMHIzU0xHODNpMWdoaTVDZ1pt?=
 =?utf-8?B?YmphMDNRTWMxSGkyaERtSXNQVWg3NmQrZXdMYUxQMVpWL1F4VUlscVFtOHVL?=
 =?utf-8?B?SkhFenNmKytSNStTK1R1RlBwRXJDeHI5NFdpWnNmV3FKQjBOZ0RkVGI5NTdF?=
 =?utf-8?B?VG5ySllBNFFWVVJRYnErWHdMbEpoc2o5OTY2WXFOMjVEbWM2VHdBTzZQNjFM?=
 =?utf-8?B?eXRnNjBsNUplMlN2VFZwRDBseElEOXlmeU5jSjYvN2pIZm5aNlVNUk9uNE16?=
 =?utf-8?B?RjFKNWV6dU81TitYYlBsR3ZDYXIwR296cmFUYlZSNUdQcDJEdmU1SXFuNzZp?=
 =?utf-8?B?NEhndFpMS25KWmo0WWRhWWRUZUpSMTdwdDFzTlJFcktMYjI3MGlUV3dCM0dR?=
 =?utf-8?B?Q2xleEdkMDhEUk01cUVSZXBqUWptdW9RcmhkRkx4T0tOSU5TcXc4MFcrUlls?=
 =?utf-8?B?Tjl5N0ZqTktxbXZqRXZwQWluVTNsRXpzUjJKajBpSFlaZW5pTW9aL0R0TzdC?=
 =?utf-8?B?NWdkNkczVmpKaU5QOWt6K0w0Q3ZxR1hWMndDcVM5R1pLT1ZxTGxEWDFwTHFt?=
 =?utf-8?B?VkROLzh6WnBRUTlkSlpqazdIYXc3eCt3T2RucUtaK3FoUmowajRrdmdrS29T?=
 =?utf-8?B?UEVWUmdTVnA5WnI4VklnQVJGZXJOKzFXMUdWdGVuZkU0RDVCaEVtZmY5Nm9U?=
 =?utf-8?B?OU5DM1hzWHFNMXRaeVFBa2NNQUJORjU0c2pRVWZmbDhHMXVjRjRKL3E2M3pU?=
 =?utf-8?B?Q29TRUNUTGV3Z0xUMDAzMDNMTEgxNDJnY2JuNElIejB6S251ZjB5UXE3aits?=
 =?utf-8?B?QzlpQVI5N05LbFVhMzdjaUpuak0xWm5OU2F2UTJpVGJqZVVINnlrVjkrdWhM?=
 =?utf-8?B?RGFTQnlQSGlDTGtoS3VVd1dOYXNhZFVmV1dWMW9hVkZoTzBQMDZNNTdTOHBE?=
 =?utf-8?B?RDFrSUN0bzlTbERqa3NVNWlsV29VVTVKMVBNMnlnd3R4N2pBNy9JSi8wLzRP?=
 =?utf-8?B?eFhLV3IxUWRxSjB1Qy9GRjBqblJPZHFlOUhBM1hlSTZQQXN1N3oxc2xVNitn?=
 =?utf-8?B?WFNFa3liTStJRjdDNWJMdnZ2T0NxNEdMVUFHM0NJVGs1eTZ0S243c2c5WTV0?=
 =?utf-8?B?VmdRN3Y5RWhvd0ZBY2Y0M3FRUGwybFZMR3RZY0NLNVpZQkxpOTVqdXBDeXlz?=
 =?utf-8?B?TURpeThzcG4zZDNsV0FQcGFwU0I4Zjc1dFYvZ09kaE1wSytZR0NOZGxUbjNI?=
 =?utf-8?B?VC9PemVDYWlDSTRIeXJiTWp4QThqUC9nQytRdFZDYzlGbWhlU2o0endGTFMy?=
 =?utf-8?B?cG9WMjdaWFlGNnFQclo0OHpVeE15UVNjUEtaWU81Wm5WclFSaGZlbVRnRU8z?=
 =?utf-8?Q?2+SGewiDwyqKjyDjsXkU+oA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9c6046-0b5a-4372-7931-08db20bb0c53
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 16:26:34.3795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EpB7JW+qR+DZa0qpuo+EdqaV4CGKXt5ASIpO+M2n3Arp6StC9k333nkRohjJDP/99CqYHWg3+WfXBlganWzuRO/oOjWcSePZmExbii75XiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5443
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

From: Alexander Lobakin <aleksander.lobakin@intel.com>
Date: Fri, 3 Mar 2023 14:32:29 +0100

> Yeah, I still remember that "Who needs cpumap nowadays" (c), but anyway.
> 
> __xdp_build_skb_from_frame() missed the moment when the networking stack
> became able to recycle skb pages backed by a page_pool. This was making
> e.g. cpumap redirect even less effective than simple %XDP_PASS. veth was
> also affected in some scenarios.
> A lot of drivers use skb_mark_for_recycle() already, it's been almost
> two years and seems like there are no issues in using it in the generic
> code too. {__,}xdp_release_frame() can be then removed as it losts its
> last user.
> Page Pool becomes then zero-alloc (or almost) in the abovementioned
> cases, too. Other memory type models (who needs them at this point)
> have no changes.

Ping?
The discussion in the v1 thread is unrelated to the patch subject :D

[...]

Thanks,
Olek
