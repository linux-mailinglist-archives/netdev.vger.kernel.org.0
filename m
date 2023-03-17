Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFB46BEA3D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 14:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjCQNia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 09:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCQNi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 09:38:27 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A02DD3099;
        Fri, 17 Mar 2023 06:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679060304; x=1710596304;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dLCGMdHWQlU2oAY01YIUZyOCyW0pFirzt0uI11RR62U=;
  b=lBsPVQHSthiijc+S1dIgMJYMckhWcpQLQeV63Fo+x8goJlRJIwjLO1S7
   glts6A13h2OlGOvbiglZEj4owxRowALf77PjXJKG2B5MRPjkdvtvgSioi
   +5r95CNyWHd/zs3biNSnKEhqAKLTrl9Tvzt0QPWLmuxTHcLNdmnWtBedD
   +8Aca8GddBKuY30L/gbMXpuC0I5qP/j73QcstDrgrCHOtidwdygpPK0qP
   3FeJ4XCADUrGBkbb4ZWQq36Zb3riD3gGnO9KKbD0B+MwK0NwMjw9BQjEC
   bAkSpsjGFzhkB3LXdUxwMAyIA1i1ovW+SqQ1kraLLSJe4CJghMQsi7Lwt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="424531616"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="424531616"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 06:37:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="790715401"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="790715401"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 17 Mar 2023 06:37:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 06:37:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 06:37:43 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 06:37:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VenQG04ZHy6aitoPrYlzs/hRxqptyt9AO8bzGbhrR5eHrYD+f5YMsM6AJ8C08jg78fB2t/8tE8QOvG66gmD/1eBQ4RO1M4/wrI5E0or5nJ785fMZquOC0lBgtn4e9Gxv2Dy2n37GTz9O7pHhSDSdeJrsienZw2kHj6ZOnF3yJzXXiU7iLUDH6wbCEDJSrZhA4Hhrtg9LDhgRvYOiSpY+NfCzZkLZyFVnfGGDW2gWl01AEbCFfzn9QhlyDvpJpNz4cQB+YtonKwDfVwZBtzgdbvx6kP9uO9TNBg04tzT6fm2yv7c7IZngtgjoyq9H7Gk8enoi9UFSJvDpv3BXOh+LBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukvmhYwViuQ72yLYlTBaxwHEWE3S/8G3ZiGagRndFg8=;
 b=PtCHE5gDavqSbTMYTEp0CnXMUYNgr9wuIkJnWM8sMvfA+jZoKcKaeGQ/ZcbcEQVbsQCrc3gNck3kJaBuyNxG/QUBajFkLn1H7IN3UNywmd5SN4Ih00V62evIxU4BhObqFXFjRd61nExHBsnWhEaVasmA0MgArjfO0wZ/7S+8jrYpqoygmkgqZrm+w0kuQQwositO33ZKd7Wxh7Zw5OJCvWO5E1dFwIf9pHytaUOFBIq49FDz2mc+qZOc/tzJWWUbdzr1U9fW6xZtgees+KgW+YXXEGNyRbw1l0sYD9yIARcgOfSFx/12vRbV2BkLXYIyCozEnvP+7thFQYQXc1+FnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB7182.namprd11.prod.outlook.com (2603:10b6:8:112::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 13:37:36 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 13:37:36 +0000
Message-ID: <244270ae-c976-599d-6c72-f19e008ba5b4@intel.com>
Date:   Fri, 17 Mar 2023 14:36:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v3 3/4] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     <brouer@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
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
        Paolo Abeni <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Freysteinn Alfredsson <Freysteinn.Alfredsson@kau.se>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
 <20230313215553.1045175-4-aleksander.lobakin@intel.com>
 <11e480dd-7969-7b58-440e-3207b98d0ac5@redhat.com>
 <85d803a2-a315-809a-5eff-13892aff5401@intel.com>
 <0377c85c-5d59-49e5-017f-212821849a18@redhat.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <0377c85c-5d59-49e5-017f-212821849a18@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0029.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::22) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: b0842a30-2e0c-437b-d530-08db26ecc478
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i/8oqg5xCj9cKdn7IQXPnzws262wfu7j4KcTK0vKfHVR6vqaKgwWlAJvFDALKfN8Bo3hMY7mvIWXyB62/lbDZkjiT+WrI9o74vA2KBnkGDNexTTQZ11/bpnGH8bC4nC5nAr6wUHu7DXM8xzGMc215W/sTbxXND8bxdG1XLjidJZ8qg/jGhGQPv/Ox+bDxzsbnP6U2oqDOu9aqAEPjB20hWhF1ZsI7ApXh4AKLnDq7vQkgwnLjToO53xJbjC78IkzF3P9CAjARPlwEZI9RvUKDCHuRUWkf61gXBQE+8YVIcleNWZIFsVUpRkCi0ij74DD7wrvbWP7BLcgcFGlH6CIRhIUq+hxc64EHdVdKb7s2R8yBDe0AICTN5B1mlAzi9C0W5+m1UesizRqP8C2C2yig817dfzljqpoAvFZoG+JCwPns86L64cSXvJyeBv0XVcJgrA93rpP/kvqFXvgP+Y4ywxv94lkzlHGcUoxlFkdSnDhX96+xxeg+ma2dBhiizqFoxmW/I/96Nqs4ecj5hacpnxLUvMBkvrrv5EGYRBE0QxYUhowekq2SRWQpDoKivgTbcgWtpOKAEGYRZXkJciw1JPyWlEEhokU5zlq90qIfdbQAywEMBvaAul6X4WPN2L6TuRLQolx/YSPnhEw+eyTj9K09BJxNpxpuJr6FA5gXUan69ii8S5xH+3Ph/xvMNt4JCryyWIvqT1lLi5h39z7pTpLFe9/1s8FFjq3hdfWSwI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199018)(31686004)(83380400001)(6486002)(36756003)(86362001)(31696002)(82960400001)(6916009)(6512007)(186003)(6506007)(26005)(38100700002)(2616005)(8676002)(6666004)(66476007)(478600001)(316002)(8936002)(4326008)(66946007)(66556008)(54906003)(41300700001)(7416002)(2906002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDhSdnpDd1lGNWs4RDdOdXAyekxucG54ckJ4UHJYaG9taVIwbUhldUZsYTd1?=
 =?utf-8?B?OHpjSjJMNjFWRmZoV3NCdEd3TGRmc2hsQUtWN2tYZk5PRmxCYnhOaytWcGdp?=
 =?utf-8?B?RGFKQjlNa2NEQWIyUHhGZjRIU0xhTU41QjgxM0RqVnBxeHFRMnpoNytNS0ZI?=
 =?utf-8?B?LzQzcUtMdm11Mm16a0RsamNpZUx4SGs4RU9zRTBVS3YyZTkxd3c3RXBRVDNh?=
 =?utf-8?B?WVdTVnVQTDEyeWhseEJ3R1ZzaGVEbHcwSzdpVmdXZkJGSDRUcVIrQlZXR3U4?=
 =?utf-8?B?TElkUllhcU5UMERHeXEvakRaNmJYM0RvRzhCTWNNV3N5RFdtMjZ2RUk0dkRz?=
 =?utf-8?B?eEt4N1dRdXZ1S2hES2RWNEFEb0xVWHhBa3RUZ2FVemlQalNXR1VHRmVuZEpZ?=
 =?utf-8?B?ZUsrUVJGSjlqMHVqZ3BhNElqTmF1RFo1V0Z2NXE4L3lkalBLTEtyR0trd1d3?=
 =?utf-8?B?TGRkNXk1aWhKQkJMV05wUm4xVEVzd3o4RFJyUiszSWxUWEZDZlJwQWhjWlRn?=
 =?utf-8?B?OHYydHlyNDhvYjRLdWtUT3FnNjh6eHNjOHAvaGVBdW80ZzRPNUtzcFFUT3BC?=
 =?utf-8?B?T3h4cEVEMU9iLzdXYXlNSk1lZWRlemU2eU9EM1hIeGt5clpCbndCK2R6M081?=
 =?utf-8?B?Q2ZNQ005RnBETE44Zy9pNTllUEgwM1A0QlFyOVZzcEtURTluejlYRWdoN21r?=
 =?utf-8?B?NG1GZUZFWXFHRkRVM1NlK3Z4bVpaWHFsdDhHZTErTFpmVE9LQ29wcGxWNXdW?=
 =?utf-8?B?b0VIQ3o1N05XdmhlelF0bmJuWVRJSkxWeUlCSS93WFBEeVR4RktVMGRhSDZV?=
 =?utf-8?B?RTl5UEZKK290K1JWZ09aaVdURkw4SjJjS2ZzeXNtV0RkRjRDbzhtVXVIbWxt?=
 =?utf-8?B?NmgyMmRmR3dQOW53d1Rxd01DdkhmZjJ4ODdZSEJ0Q20wdTVsbkdtVmZjQmd6?=
 =?utf-8?B?bUZTLzFOTWt6YnBqOVQ0TkViaW1iWFlkcXpNVUVhNWRqOE9wYmx1V2RNRTRh?=
 =?utf-8?B?U0lpZUszU3hiN2tOcXYwUXIxSE9vUFgwNGVranlmanNWTERuR0hVc0RINkx4?=
 =?utf-8?B?QkVHTnd4dFQ0ZHpvZjlqQnZGQndweE9rak00ZTExeFFKTjcwREdnT2JRYkxC?=
 =?utf-8?B?NmpGcTYyUEpKRTdpNFNVeUlHMkZTeDFwS2h6TXEwbTM5OFFGUUpwM0FlSnZk?=
 =?utf-8?B?ODdldkZFOVBkblprMVNPbDhhSDA2SGxzaEhvQmdnRnZpVGZmQ1BIWVJEUDRE?=
 =?utf-8?B?VS9JUUR3VEhIZjBTdUpzQTRGWURnSFdRQnArWTBUYnEyeldVaXF6cER5L1lC?=
 =?utf-8?B?bzg0UWNzc0oxY1lldlkxSU1VdGZwVCthSGJneEJtZmJTUk01bzB1UTV4YjhE?=
 =?utf-8?B?bTBmSXR1WEVGWVlNNCtYdlBFUFJEVzB1cWt2SVdha2VwWEtMYk9zcitDMWYr?=
 =?utf-8?B?MHkzdUpIVjhOS0VLL09HWjVLK0hFMnJXZERTbjR2RmpwSDJQbDIxdlI3b1NK?=
 =?utf-8?B?eHdyV3FiVXZQYTlKekN3TTNzeHZ3cVJOazBJRzgrdzIzYWZsSnBiWDRYM2tj?=
 =?utf-8?B?K2VjMjRMTXFielhjWFZjWGxEbjdqeThlRGs0V21yd251bENKeGdPc0w4UDk0?=
 =?utf-8?B?dlJ4TWI2T0t2ZE1OcU1QcENONkNQSm80ZHBZYzdMQWlqeDB4WW9wN3BGejJx?=
 =?utf-8?B?UmJObGF5VGhhR09EMWNYckVMelRuVjFmWGhPcTFCZzdrNzBMbVlZUjFYRVFV?=
 =?utf-8?B?eWM4RWFta25oelJUQUxSa1hsU3o2dEZreWRramxPYXpWaURTVXZQeGFYTVBu?=
 =?utf-8?B?QlE1c05WdVpCL095eS9uK0t2bFZXSnVONVZPekVHK1lWRWxQdTMwaVp4YzlZ?=
 =?utf-8?B?T2ZENnN4dU13dERGdTVBMDlJeWVIb241RCt6eThWZEpSdVQ0NndtQjVUdlRj?=
 =?utf-8?B?RkUvQkJVR0JhZXI2V1k2aGNSOERqZEdSL2x0VUR6eXdCQWEvTTI1S2RxY2l5?=
 =?utf-8?B?VW9VblRIdGJJcWg4cnVON1BhZVF0NTlUZ3h1MlBBVUhDVXFYdDFXbzBTN0E1?=
 =?utf-8?B?TDZlYk0zZ2EvaWpHVDRVVjJObDdramU1L01PSXpSS2x1NklNdnA3WXpMOE9Z?=
 =?utf-8?B?YkdxZE1CUHcyTXU1NnRoRURCZjVSSXZ1UXRUTlhSQTNnL0d3bDYvdTZFUFNE?=
 =?utf-8?Q?Dw5eBD3YPNhhFRCStTaL4lA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0842a30-2e0c-437b-d530-08db26ecc478
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 13:37:35.6572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7r6ZvEX2t8ZFWe3nc2F5+wRRCBXwqgP+fVabNow7xtAg8QDfqyGnifmxH+ltvn1Hg4XrewD1bvb+mUyZQ8HT0etR4e5Ng8kWdRdvW0zxL1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7182
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

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Thu, 16 Mar 2023 18:10:26 +0100

> 
> On 15/03/2023 15.58, Alexander Lobakin wrote:
>> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
>> Date: Wed, 15 Mar 2023 15:55:44 +0100

[...]

> Thanks for signing up for fixing these issues down-the-road :-)

At some point, I wasn't sure which commit tags to put to Fixes:. Like,
from one PoV, it's not my patch which introduced them. From the other
side, there was no chance to have 0x42 overwritten in the metadata
during the selftest before that switch and no one could even predict it
(I didn't expect XDP_PASS frames from the test_run to reach neigh xmit
at all), so the original code is not buggy itself as well ._.

> 
> For what is it worth, I've rebased to include this patchset on my
> testlab.
> 
> For now, I've tested mlx5 with cpumap redirect and net stack processing,
> everything seems to be working nicely. When disabling GRO/GRO, then the
> cpumap get same and sometimes better TCP throughput performance,
> even-though checksum have to be done in software. (Hopefully we can soon
> close the missing HW checksum gap with XDP-hints).

Yeah I'm also looking forward to having some hints being passed to
cpumap/veth, so that __xdp_build_skb_from_frame() could consume it. So
that I could pick a bunch of patches from my RFC back to switch cpumap
to GRO finally :D

> 
> --Jesper
> 

Thanks,
Olek
