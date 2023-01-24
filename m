Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDF6679671
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbjAXLSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbjAXLSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:18:08 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA57EF93;
        Tue, 24 Jan 2023 03:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674559086; x=1706095086;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uqQwPT6xGq1lS1tN42tPR7sLtV2DKNpNEAAWl9qWn0I=;
  b=IlPXPa5WWLYEHux/SzVg8Cl5v9HT5Ri6KSZTsvZ02iAPIQZ5ikDOCQyv
   VWW51ecChy5dgArh75ViPpJ/dYWwqO6Zjpw85AsiaJ3S3g3c7y0SAzUl+
   sFiK9BImVKPYQE0wE4KQ5YK9m2J3L21HJpK460u3R13+g8KgGozBs75h1
   FAWRgOzcO12nSlCvEYm6NHeL2vAhVTRcBTimfjL/tiAEvxy5JRd5Qhqq4
   NGN9WyCbXC30EK8hY2cIp7dbkjL8QV9gK0bB8ynW+hnzDDLlH8lBtv9lX
   XBcK/nVhMCF6URn8u1pTOcKETPDVqEGQUOSfQZyq5YQTzNqEaqnVe1VuD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="323967444"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="323967444"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 03:18:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="990839133"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="990839133"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 24 Jan 2023 03:18:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 03:18:05 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 03:18:05 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 24 Jan 2023 03:18:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIkutT+Agpv9sVnhMp0MlBs72TBXy1ELKowP0vFJZMcz/5IxaKPa8bCQkmwXUjQGC5KPR4D2L0BjAmpMsVs6IhS3j/oMgwltO8fZDyfRwjp6I49XIJsE9VMUt3DitmLmxrsy5kWBI7GhWQT2IgtS58huSnuaUPkmxWrx9uF9PPxfR33uePja5Du5zHIYqTpqLQTBbe9rYkkZuFhGch6tVfFYd9i0mJexZYsPdHUd02fkKwYhAJoIGaejy/jEcjST2IakZNI7N9DExyPUfVseVId1nyGG8EHsGiomh/gnbmgJMKvZ3n2Y4Hh5O0kTXL4OxCYnhudw6LJAqgOq47iuqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5jLI1/LmagsMzs4uf+6UgL+I8LUnvd0/RqKoMWARME=;
 b=GpRTrwYKVj8BFqX7DdEbZimvQ5L5aJ+BHpSpN2U/BOREXrxP/qnMNH3iHy9+Um93yul8l7bhPYlG9P+WevrCOtLWdZDqpXBRZYLYTWCgt7iiVDqN8VsIr2RQrodkBODnpyTSx3Abvnqx4r7MMDXlV3LJjWCblBVX3xCQaafaaZOAO9N7OKFDq1I1oToPeZittAYmG1yO3lYz2ANM4XecLPjTd5o2Pp432qbZ+l6ef7MGiZV5T14saUwYWaSnPVNBkjOboS6KXtOIAvM4Nb11SmmAEjaxr0O+J7CqVX7Z174l2xvkbfAzq3v5tSnOuRjSjhT8YdDyL4WnnVGWaLxLOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB5189.namprd11.prod.outlook.com (2603:10b6:510:3d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 11:17:58 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 11:17:58 +0000
Message-ID: <5b757a2a-86a7-346c-4493-9ab903de19e4@intel.com>
Date:   Tue, 24 Jan 2023 12:17:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH bpf-next v8 00/17] xdp: hints via kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
CC:     Martin KaFai Lau <martin.lau@linux.dev>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>,
        <xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20230119221536.3349901-1-sdf@google.com>
 <901e1a7a-bb86-8d62-4bd7-512a1257d3b0@linux.dev>
 <CAKH8qBs=1NgpJBNwJg7dZQnSAAGpH4vJj0+=LNWuQamGFerfZw@mail.gmail.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <CAKH8qBs=1NgpJBNwJg7dZQnSAAGpH4vJj0+=LNWuQamGFerfZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB5189:EE_
X-MS-Office365-Filtering-Correlation-Id: ac20d727-ee8d-42a1-6436-08dafdfca593
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RAx4ky9aoMhCr/PBrY1R9ihsLy4lWZyHAXmkzLMqvbwmwALkfHF8JBwYjROQYSjYsWUhiuriqC+fPZeVHLiRkH2DD+bkr937QICVV4f1yw+b3zKRqvKu7+Q9p3Y1MIFwg8y13BDPV7dHjDjMBjT103tr96Olp2+FmtQhyr2vgvD8z00wRQ9/ymQXKh1QeCj0BQkIySg2TDs+xaIEIV1QyNPWGduHO5MPTEUPexice5xgFksDglmzImMmXRbW8yhr1KYFBZqMlywgGlDxGLc/53riEL1/7ulqh9vyggO3ZnOU/BEmJUnyn44SHPTWMrvYcLbGu9zHmBWje0oz+RbrrNv+DFZVMRe+FC9fk5oOzIK9WOJErtA0hx4fZnxNgrQi06x9cqLI7/UpkXhkOHau30GGAfzSp+pNQpRYejJaiZuXvZfQwPt6q04Hlsp+LEGQeS6e/XL34bpsDc1cXi1t3JyxAfYE8rjxi4XBIWlDfnCZ5qAlDKNpbFbaV7CbZ4RJOQcd5z34AMOTiTfEgCqmK9nxx5kxA14I2W5Jqrvy9ixbGbCwl65yzKkjzGYZE4SHVG0iF7HUkeNjdmoiwQ26eeavagK/RSQ7GPj4guG6lfKD5xtoRgiGMVd2itdcAO7X6kKTwrNmexDqYsYOhIVjz36T538aHPmjlvMQpdquL1zNb0Igym0tKaolZV+cePqUxR2BKDoENnQLhbEvLF28PFH43oDsl06O7ZvXQvVGxAQ2XHma+2Q0oxbhmd+LeCi3re//Ze0jSTjqHFxP2zobgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199015)(53546011)(31686004)(8676002)(66476007)(66946007)(6486002)(6916009)(66556008)(4326008)(2616005)(83380400001)(6512007)(186003)(8936002)(26005)(6666004)(5660300002)(41300700001)(7416002)(2906002)(6506007)(966005)(82960400001)(38100700002)(31696002)(316002)(478600001)(54906003)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUNmN1hYQUEyRXVnRVB0Uk1VN0ZqTTkxb2tNNVJ4aDlSUG5tV21NVVpxd21k?=
 =?utf-8?B?YVBteUxEdWIrQmhYRFVXU082TjFkemd3b0NFTTM3bFlwaUpyOGR3aW1jd2lu?=
 =?utf-8?B?YU1HQkNFL0l6Zk91UWJFZzVjZzZuMVJGdFRsNmpBT0tFWmZRTU14MnIzTmVJ?=
 =?utf-8?B?eStGNTdUdE9lR3dSM1FjYW9qamNERm9iQ0hZVHdBNWdrUjBweGJCSkR4NVYy?=
 =?utf-8?B?bGtTSWQ1ekhHNzBDcmVlMWlmcFVUS2IzaWdnKys2dzB0R1FyRVdRaG5CYjAv?=
 =?utf-8?B?Z05TUWhpRlloUEtlNDJGbWo5a1hvLzFZT09VZmg2NDRKeHVCb0xsNXJqZk1S?=
 =?utf-8?B?WGZBMmtRd0Zrc080R0pIZk9ncGp5OWh3REZLbTdQOUk4d0h1b3dJaW5JR24z?=
 =?utf-8?B?czlyMGMzdGw3Z29vdlFpR1EzZjFNZUtYbXRrUVZJV0lOSlNyYk1EMDFpNUVP?=
 =?utf-8?B?ME5KaTVRaHJnS1JSZDc5ZXltVVMwQ0oyNUtDUWZmTjlOaHdXSFJGZmVnNSs5?=
 =?utf-8?B?M0pSSFpabVd6YkxySkhpN0NBUTU2d2h0R0NONCs0TFVnNC9lWElYL1VTK2xs?=
 =?utf-8?B?YWt6ZnVNOFVhWk9DQUxxb0gvbDRDanRHWDI5Ujg3SmRuZzRQcTIyRGxHWWRN?=
 =?utf-8?B?bkw0U3QrVUNTZWxJYktaVExINis1VE5NLzV2M0JlVFZWTjdBZUZKSnlhRW9t?=
 =?utf-8?B?R2p5U2c4Vk9WejZ3MHdZOUJ4YlhGQkJsYUNCV2ZqWUhlOHkvdFdpTk93SGM0?=
 =?utf-8?B?eEZTYmJkS0JTOEthaVduMWNDSjlROHBCRTk2ajVYQysyL25vTFAvNjN2QzM3?=
 =?utf-8?B?dUc0bCtOQlVUYlpDcnN0RWlQVjhiUkxLdDBkR3EvQ0Q1WDdUTlU4NjhZVnNu?=
 =?utf-8?B?QjFtUlc1ZThMZ3BaT216UWhBUzIvMExhVkxsbDc1NHJldzFmUlR5UjArQ0Zh?=
 =?utf-8?B?SG1tRnZ4dHBESHNsR1JCSzVYcURVNWdaMEtmczU2SE9wYUdLR2RXbUhrd0lQ?=
 =?utf-8?B?Y1o1WHpJeDJ6ZG5iV1VjVFlnWjkrRHg4QVZKU3FkeU03dUgxSk8wVW1hbm5o?=
 =?utf-8?B?MlZnWTdiMUkxdFQ0cmVWT2VYTG95MFVvMGRwa3hBckJmVlVmVlFvYk1MR1E0?=
 =?utf-8?B?d01ZRy9XcUVzZ2orODVaVG1aVWo2b3F1bzQwWThmY2V3SE1ML0dFeGplQmg2?=
 =?utf-8?B?UURiWUNyMk1Xejg1ZnVaVUIzcE82ck0yZE40cGY3STcxeFVmam9XK3R0KytP?=
 =?utf-8?B?SUZ3QTFBVnRBSGRmMnlHZUVrQ2M1SlVWdmpjb3RqTFJnbGQvTTV4eHhzb3RN?=
 =?utf-8?B?RE56Z2ZmdEE1VFVlT1BQTHMyT3pUanNvZ0dlUjBJeElnZmJkNzhFOU1IWjBM?=
 =?utf-8?B?bmhmbnRvK2FMM0NZR0RwVnFxaUNzakFhSUxyWXV4T0RqbkUzamk5VHdmWXZt?=
 =?utf-8?B?elBxd3VDWmNkOG94OEJGNk5NN0pleXFyUkptbm9lNnorNU9kdVlxTWx1M2Fq?=
 =?utf-8?B?N1hZOTBqY2pnMkROOHRLckpBS0h4ZEx2eUZBNDVEckkrUDd3RkFkUkJtazFR?=
 =?utf-8?B?ck1Fbm50aVJSZHpIdU82YlFlQjN5bWxsYTRKVzZxQ1ZTdlRocVVkZmdCVXFp?=
 =?utf-8?B?dk9DOFZMajNTMkhLSTdVYjFHNEVpQlhMajMwWlNhZHJvUXZTSVhEZVZ2eS9u?=
 =?utf-8?B?c1ZpZGhDbzFzakxkais2czBKSWVTRVNhcEhqRklzS2dXT2pZWTFyblN5WUov?=
 =?utf-8?B?ZU9LVTZMdzRWT3R4SE5RZWNmNFk0cXQyc2NCa2h1aVVIaDNuWTBKUWtXTnJN?=
 =?utf-8?B?bTU4T1p1NjFFU0psWFoxVjJhc3IvbFd4d2hpdE5xeXVOZ29XMU5jRVgvcGZ3?=
 =?utf-8?B?UERiUmVydndVK3VadEw3dk1vNEdaazN0YytSWi96MDNwanBhRC9ueWRxdDU5?=
 =?utf-8?B?UmlyR2RUSENoYm40Yzd3TFBhTjE4STh2amlQMTZ2eDg0QzZhVnAwSmc5d3k4?=
 =?utf-8?B?aUhiOWhLSTVJaEtOdHJ1ZjIydnNWLytrWkRIU0xVWkVPQTI1OTkwZzFKK256?=
 =?utf-8?B?REVLUlFxL0srSitBSGpId21NMnZwT2laemFBOFVVMU9jejZqbTFjdkJyYWM2?=
 =?utf-8?B?OE9kWXFUbTVOZStXZ2w3WXpidmttUzBoSlBUdk5tU3NmMlpqOWJaVC9NTVFi?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac20d727-ee8d-42a1-6436-08dafdfca593
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 11:17:58.0644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vuSV6XhiMy3oyUj4JBqkVDys0Hl9GTDdcje4YOVPaTf1O1YuGwtf6VYCNxMkjjXeaKoeBKM8Rt3wyfpemoO7nHFWCKiTHx+qGEHGBBBHFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5189
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>
Date: Mon, 23 Jan 2023 10:55:52 -0800

> On Mon, Jan 23, 2023 at 10:53 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>
>> On 1/19/23 2:15 PM, Stanislav Fomichev wrote:
>>> Please see the first patch in the series for the overall
>>> design and use-cases.
>>>
>>> See the following email from Toke for the per-packet metadata overhead:
>>> https://lore.kernel.org/bpf/20221206024554.3826186-1-sdf@google.com/T/#m49d48ea08d525ec88360c7d14c4d34fb0e45e798
>>>
>>> Recent changes:
>>> - Keep new functions in en/xdp.c, do 'extern mlx5_xdp_metadata_ops' (Tariq)
>>>
>>> - Remove mxbuf pointer and use xsk_buff_to_mxbuf (Tariq)
>>>
>>> - Clarify xdp_buff vs 'XDP frame' (Jesper)
>>>
>>> - Explicitly mention that AF_XDP RX descriptor lacks metadata size (Jesper)
>>>
>>> - Drop libbpf_flags/xdp_flags from selftests and use ifindex instead
>>>    of ifname (due to recent xsk.h refactoring)
>>
>> Applied with the minor changes in the selftests discussed in patch 11 and 17.
>> Thanks!
> 
> Awesome, thanks! I was gonna resend around Wed, but thank you for
> taking care of that!
Great stuff, congrats! :)

Olek
