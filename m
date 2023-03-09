Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913CE6B2B10
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCIQny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjCIQnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:43:33 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB380F7387;
        Thu,  9 Mar 2023 08:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678379547; x=1709915547;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uL2kbsgeN9x9mvhXFt/0CLq6OxJtG+gO//V+Q95zGC0=;
  b=FtXO+djSlUJPYCsosDp7f7wcOoJZAZD1b7HuSwKsvNntZDXYxKbV/z1n
   KJzGwcNWidee8zOXoyxb1SZiT+4MRKAslUc/ozV2cieO5yJ0G9C2XBnUJ
   Z1fmevjOi86bCuKlpDGDP42+fUobxq7G1EW6GBc+2Bnm2NIugiG4W93tI
   9NO0+j5hs4QTPIPlps9avMKaqvlqSk8vsVVjCqcLLmwX1H4pkKNQPmeTa
   t2h3BtwjNBKv7Qf+sQmGSeCDIPMTY6iQLLuYNrNVdhJUs2HbBZ5xs2FhW
   pSAsU7YoxuGe89pIfxYBMKW4Fcsv/HVQS46YFEuz8faxnJrJMm/UZggkD
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="335195636"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="335195636"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 08:31:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="787647454"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="787647454"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 09 Mar 2023 08:31:50 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 08:31:50 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 08:31:49 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 08:31:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eof5XHcUGIH+vNUAWWfyPpaylxXxTs9HbuzOFfSIl2/xtb9xknXYBJjlygSDL8MYCKNjncgHfIpqpNlxw8B+vSDwPA2jsNd9+02VRkVbIM6UhFBeuFEDZ4DpdLDgF89wiAIsSE+B7qvIrhJp6KAetc4y2+XIPFdmuqbVHntWdAxiPHyRheHonjjWkHZQSyh2yuCyIkZnCgtcL/4JWo/T4L8MnvVoppX/5tvdwryI2wvntq9w8benVnxkeHKkFsrHyFt+HGjmGU3llKE6bUiyttpodzfGm0cEKgPb/sI9TY5Nn3hcw0mi2f5wu7/6sIh/HHhO/HlM7xCH1q08MuVL/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xG5Zd+G7QKPYe5LtJDbgULZnTInQP1h3d/F/iNobGts=;
 b=k+vceHUcYGAfp0Wok/+JgjNeQlxHBNtLJffFr1nZ/VtmIthvWgTEOJTQi64lTGO/oIqjf3lCP8rpfdmF4V9B92lE247NZJ+AUJKabU6mNDLD9fCacDEqfm6GxutXXDAd28LpbeXnXaRFTsoxxFUpx4H8Bzkh5rX3GAlGwzbXJi2JWLph7l34pOhx929ptvXQ+Un9qgXu5bgkqpAIZkOcgdeks6wwIMpCJZwWvVd0LF483IAB0Jl0h9j2wmK/S7mPOupim6azs0R05H5wkDpcwJ0grLQlfvQ/w6kMs5JlAl6XL3LAzBM/Tv0Q4XxcAc+BdIHo7vsTxwTEdxNsDXZoaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB7205.namprd11.prod.outlook.com (2603:10b6:8:113::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 16:31:47 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.017; Thu, 9 Mar 2023
 16:31:47 +0000
Message-ID: <feee2aad-6834-da69-a154-c1e0e21d12b7@intel.com>
Date:   Thu, 9 Mar 2023 17:30:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] xsk: Add missing overflow check in xdp_umem_reg
Content-Language: en-US
To:     Kal Cutter Conley <kal.conley@dectris.com>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230307172306.786657-1-kal.conley@dectris.com>
 <20230308105130.1113833-1-kal.conley@dectris.com>
 <4ddd3fe4-ed3c-495e-077c-1ac737488084@intel.com>
 <CAHApi-=C3ym23bBQ2h8BOyOfUtYXs9eZNG0Z8G2zfPeaEQWeRg@mail.gmail.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <CAHApi-=C3ym23bBQ2h8BOyOfUtYXs9eZNG0Z8G2zfPeaEQWeRg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2P251CA0029.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:10:230::31) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB7205:EE_
X-MS-Office365-Filtering-Correlation-Id: f6b59850-fe04-4c8a-5914-08db20bbc6f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d0iR2rbV+zvB2cUVdTE1ptdREw9WF9JIUogw7ax339CYce/Eye9QOdJVUzju7JIcXw4abjR+bn/WmXGkEY5B8/H14+ngaEwUHmAk10Gsff4zahQupAf0YmuSXc/UHDoXzwdLtfqsFrYiDVrZ559lw2Z894jwHZktviN45wC0yIT5tSfbvcJ1OIvMVYJ2ZfRBNZOX4uAQDG7zzWKXAgF9t7CFAxzxJldYVpp7M2Ig8qVm9kK4NpgP+viuXr6j3M0tntTowCu00/tWeny/unWm1aIViX1hZl7xJrxjxGIt8UNQcUwpVUiVd6iRogJBC6XnwiRCXT092tMrkJ9jHrIHDW+ZTa5teEaDVxpRGgVe1iH51H9E7r1OW/TJyJdQs36UM6IrmXzLWVtUO1gp4qldPTf8vPzcnpbf+bt71I+cP6WS/xPd9WfewIqkFLcJUErmtxNUn9ef7042WjfC3XtByeEcxbhPKcDU2LaZ0RHRFYY1zGLbdHFEWA1BT7Zh93Jyw54yNZxCst9DLxUCotBB5SW9yV9kmjbl2+PHk7a1FuA6/hV5By3MIQTaAnKXVclS6J27DoLXn7WHiS92XvLdhxX6dvZWH6WrxxwwUMr8lMBMsD98nPhKJgxdZHcj5kBnQZImunEGufMoOIhzC2FHKJyZx2IqhqQaGq3TPA2xaMdY3ayXdoeTJrnzCYfGZlJcrwvWymz+AvmVNQUtQOExDILCdRjhtI9B8a7OXbO9KuY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199018)(82960400001)(36756003)(316002)(4744005)(54906003)(38100700002)(7416002)(8936002)(31696002)(86362001)(66476007)(41300700001)(6916009)(66556008)(4326008)(8676002)(66946007)(5660300002)(478600001)(6486002)(26005)(186003)(6666004)(6506007)(31686004)(6512007)(83380400001)(2906002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkRjL3FWeXRNNDBZK25uSUgxOXFkbGo3WXZrOTExN3Q1RHlwZEtONVRTbkxj?=
 =?utf-8?B?NkFFSzVoVExBNFV1SlJQeTg3UG1hTmltSGhxQitFU1ZLTkhRZ2NIdzgxcXNE?=
 =?utf-8?B?RmdzRW15dDBGK3lRUVhva3ZVZ3MzRXFjV2ROMlVtaEZGeElNQ3o1VVFVUFBR?=
 =?utf-8?B?WHhzNXpQMVcyNVRQd0VFSG45K0h4RnZ1dGt5Z1RaTUNWQkZ6ZWpKclIrQWdO?=
 =?utf-8?B?dzBIaFZOTUE3OWg0ai90N3VzWWVQeTZQZDVJSkoxaWpPRnlWVDR3dzJTQ09y?=
 =?utf-8?B?UUlXNFNhSGZxOHg3M2E4SS9zS3FzSlJHTktVa2FGczZ0YVg1cWE0KzVFK3c5?=
 =?utf-8?B?RUdEQ0huTkpYSWIzSThDTmh2Z0FZYmQzaTUyQUZwazBZRElpdGxoc3pnMkFW?=
 =?utf-8?B?cjZxSUZLVUprY0xrakIwUVE4WWF5cE9tb0lGWHQvdXl4TXJ5cjZWcW5mQ2lq?=
 =?utf-8?B?RlB6dHNyWDI2aUJoWUZFTzVIL1hobi94RXV0REliRGJibnNBZWNEYkF0UnMv?=
 =?utf-8?B?b0REYjVYdzY1UGtSanhuZk80R2E4ZXIvZWwycVBKQU1nYzJ4VUVsOWxtK0N2?=
 =?utf-8?B?MjNaeGQxTnJOK0lZY1I2MUdOL2kxcDM1NEViKzVRZ245VENwbUlpV25OV1Vv?=
 =?utf-8?B?Q2U0K0drZzd3R3hZSm53RlB1dDJLeVJ6VUZuZ1ZLQjNMZEY0U1lRK1dHZE1q?=
 =?utf-8?B?UzBZYUhRWE16ejF0N3NIaXMvK0VYd0JlblFZU29iTXhLWWUwNUcrczM5YXl2?=
 =?utf-8?B?Z3FUTjBCUTRwTFhjSUJlYzBNUzJDU2NCMFpIK1FxQzhFQndZMHg2U2d0Q2VC?=
 =?utf-8?B?djhBNFV6dHY1dmhaYXczMXRnaWMvOXhjQWZxejJTZmQzNmRZRjVGMW52OGRk?=
 =?utf-8?B?c1RQY3V5YUd5V1kvSFVwaDRJVHBtL0lMeWFpWDVjeElDWDZuSzlCZExmMG5J?=
 =?utf-8?B?RjNFbWxHVlFzMlBROXpYb2JKVmVjMDFWaTRJNG1RTlZiR3JCREIwMkU2YTY2?=
 =?utf-8?B?WUhOSDQ3WGtlaHlyNmhWU2ZBSWJGSHVVcGkxY0gxRFJIOGxuYVBCZDJrQkha?=
 =?utf-8?B?MW11RGRxRDVCbWVyZUZrS2F6V3ZPM1NHRDRjTUJ2Y1oyTmh0K1NGWFJyc1JK?=
 =?utf-8?B?OTg1WHJmUFBaZU5paGUzRUtWZ2tqOE9LSmc0SDE0UEJHdGdNc25IU3RJa0px?=
 =?utf-8?B?NjN6KzhDRUJZOTEwYWxiT1lramVDa0oxMno3MHlKUjc5M2NCbFp1M09MckRS?=
 =?utf-8?B?L2tGUFpqVVVEc2JxV0hzaCtuL2Rvb1RHQ3J4Wk8yeUNSZEZGOVNWSytvbHJt?=
 =?utf-8?B?dzNqUGtoY1Z2a2xLWUtPN0FxV3FKdmNBYkMrcXp0eGJ0TU1IcVRQcU5jcE1U?=
 =?utf-8?B?SXdKMFlDQVpkWlJTMHN0bEtkZUtuellLUlFMKzdzY3cxNm1lQzNXcjZPOVJp?=
 =?utf-8?B?MEdOYWJYelRoWXJZMEZ0Zk5pZi9NVUxwUGVkV2NMc1c2VkZzRkM1Y2JFTjRa?=
 =?utf-8?B?VU5haStDS1VoZ00ySTJ0T2Yyb3dKa2xXU0pVNC9VUDFGNEJNL1drZmRJazJT?=
 =?utf-8?B?S1lmSS92aEF4V3pTVSt0dzduVjJ3Z1VudWgvQXlyMVpCeW45cDdKTkRnNWJu?=
 =?utf-8?B?L1N3ckI2VXJEbmppRnZ5eHpwRWlYREtjN2lBTkk5RVVNdy9VVWtmemVseWJr?=
 =?utf-8?B?eVcvVUk5aXRENWFVRFlPbEdtcnRJdzRoYldEaGJ0bHl6b2FtRzNQdGpXN0py?=
 =?utf-8?B?aGwrNXZRZjE5akRMa3FrY0FSZk0rMW1HUzJ2Unkwc2RoQVFHQlBYa2hZY3Vo?=
 =?utf-8?B?dUpSWG82UXUzUThzeFFJdWJFZXNXR1RIRlFhRXBUMk95dkRRWGgydUptZitR?=
 =?utf-8?B?WGpBY1N5bm5GQkZnT0d6VFA2T2ZydHd4Ykl0R3Y5SkNRdXUxVjlKYzZXY09M?=
 =?utf-8?B?R1lHVy8vNHFYeE4vZVJwWEVEZHF0TGxXSG0yWHNoa21uKy9HUHIyVEY5d0FL?=
 =?utf-8?B?Mlo5b0VJSjh3ajYxM3ZUanpKNGtSUTIyYnBXeWVtS0djNG5Wai9qc1kxMTlR?=
 =?utf-8?B?MGJQUVVPL3dGS2FreE0xRUFSWEZ0V3dWeXVVbFU5NmIva3VFN0J0SDlLZGpZ?=
 =?utf-8?B?QStqNVE2VSt1cjIzUFJwVXVicCtncHE2OVJtTTdKNStVVGloZ0N1eEp3VU41?=
 =?utf-8?Q?v+fbhqbpSzGc8EHz+npH3EY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b59850-fe04-4c8a-5914-08db20bbc6f5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 16:31:47.4654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fSJvM81Xo0D7UX3dXIv8yt/YBIkTaSITrZRwfXdZUJgXPLA0G73GaM9A2ZXU3EIiA5RRNzjcLa1bmwKGkr2qKoZcvrXxUrna3ylHOuHY2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7205
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

From: Kal Conley <kal.conley@dectris.com>
Date: Wed, 8 Mar 2023 19:49:29 +0100

>> The code is fine to me.
>> Please resubmit with the fixed subject and expanded commit message.
>> I'd also prefer that you sent v3 as a separate mail, *not* as a reply to
>> this thread.
> 
> Done. I used "bpf" in the subject as you suggested, however I am a bit
> confused by this. Should changes under net/xdp generally use "bpf" in
> the subject?

"bpf" when it's a fix (better to have some real repro, otherwise purely
hypothetical fix can be considered a bpf-next material), "bpf-next" when
it's an improvement / new stuff etc.

Also please don't forget to manually add all the folks who reviewed your
previous versions / were participating in the threads for previous
versions, otherwise they can miss the fact that you posted a new revision.

> 
> Thanks,
> Kal

Thanks,
Olek
