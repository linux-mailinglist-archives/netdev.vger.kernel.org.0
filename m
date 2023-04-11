Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25976DDF5A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjDKPQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjDKPPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:15:54 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841C4FE;
        Tue, 11 Apr 2023 08:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681226083; x=1712762083;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uyYnez8VLnzs/h67moM1GmDiEZbXdkkMWuTpvGw7qEM=;
  b=lknPAxXyII7Gk56PXvzG00emAS2LVdS0jhbxSrWfRbW4dFQG5OF5qdRK
   LQ6lH7UGtTlR02eZQCqO6g17ZZFxRhgkmH7qYz86i8Ba0qtrawafNIKTd
   SdvjpfxV8LCeIf4eC7DnJmDRmf+FBUpo/I5joXWiJr0KEgM0oCcw/rDxN
   AFPHRp9IMOvx5Clz+pOgMWHv/CkGMB8IxIOYBvkmhYzrbReu3WXVkP00h
   vVl5S4ae5JFcciBI1/ISVteqz/bEESYNTaojjmzDOPP1/K68FctWC2UlA
   N9SS2+tCERs84PfKQ9iG7tLhdUc/Rqv2aPIEnkvgxX9QNX2s4q/1pPBaN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="371494483"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="371494483"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:13:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="832376116"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="832376116"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 11 Apr 2023 08:13:26 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:13:26 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:13:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 08:13:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 08:13:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbYJEmAQ7ydYrNOXcujKTuqpXq+vroNGIs/aIrhCD5pr4vvvC9ElBiIVT7npZiHyxO9ToBE5L0Kr8EXI110NgHeK9nnzKuD7IT/gY8UM5+GMA4RRSsev0EUSHDxGmiO38fGT6pDbkjDam42+T1ouGC9RtzJmpnWEvWGfA0DC4zFc1WhO0uvre6HJlyOUkKkt6K2QD2A/x1lh4NiCecg/AXZ3YdH0pH7hz4NNxi4JFLZcab6VSjbu3jYRq+vuroyvTrCbJlolgNndNDkiudHLrPAKnIc+bJT28UWlEQGBPJ7TARyl7bXxNmU/Z0+lUurbBRAFq7hn8lyb+o//zeV6/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3fnFh6EV9SZyW75Eb9KzV7O7dW3l1RW6+nfCntJkGfg=;
 b=efbUFyt2SqOi5XpIxYeBseg88gNrSwAFpkKyLFDQlJbT1PGrVuSCHxJygk5nIdVX3ll/+0peDA5AK2v15fWcRFjawH5jxqQqMtiY4W53t97qmrT5SPUYnQ/OpOSToB9p8AUq2c0FhPc1qeoOrMl8sWbBMeZGs7QpG5atmKzFN6ItY4Van4z4fZijLw3q/rgtdFusRv8FAxgj9+hWQQIToVFWUB70D4W1jCZ2CdPru8eESag+RPsLLStXGztB+AB9S2h/AfZ3/EDuQVzWIGLqpRNpH+vl5CC42xZ4Qe7WKcx8+KAriqd1fKW4tnDWxim44Z54jKJ+f3+9YYvU9PqqDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by IA0PR11MB7751.namprd11.prod.outlook.com (2603:10b6:208:43a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 15:13:20 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:13:17 +0000
Message-ID: <1f524738-778d-a23c-c0d8-ece6ae4ee909@intel.com>
Date:   Tue, 11 Apr 2023 08:13:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net 1/1] i40e: Fix crash when rebuild fails in
 i40e_xdp_setup
Content-Language: en-US
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>
CC:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        <maciej.fijalkowski@intel.com>, <magnus.karlsson@intel.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        Andrii Staikov <andrii.staikov@intel.com>,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
References: <20230407210918.3046293-1-anthony.l.nguyen@intel.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230407210918.3046293-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:a03:40::37) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|IA0PR11MB7751:EE_
X-MS-Office365-Filtering-Correlation-Id: 9532abc0-df95-44bf-c126-08db3a9f4706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NxhvkDjy3vfEPKYaVDXwcamefqYhLWIXkbOdPzP0ovffSt6znjczLHtOv26eAYf5ISZd0d1tOdAEVIEdxYf+3rygjdDFZUw9H83vxLL965H2SRrlJIXjnyCUy5ms70YTIrNBHjKIqZSUxxLsBIAyL9t/vwsVpRlybErh2dgrO22QR3Wj6FmQbvWAJMcT8fQU7HX0gAbe2tpw3lYbMQplb9BlPwkvG7riLbDB0JPlXlYVfKc9GSlOkn0cAC7z3Htftog/3CDLHuN0ikHdw7f89+AdmoP2ObfkmDAzXEFF8HWVvbqWbGonzQ7X16BRVzdST7tLiUALxCFIuIRBOHjV+htZ+DoaEKIoqpfLEW9Pb8khaszzFAnRVyfBXXDcoqfoAzAXyp28sgcTX6JR/SePLgIeRJ9KTwCggaW5Ki6pvLI7iKdHQTETy/HMH83+Nkso+ddOWlImT36CibVe/qrZDnW7e02kNbm10xUtz6Lu9XF4EIt1WpCeU0jvGN83D8qLwgB5vAMR9ToIQrOmWLTS3FGNZvcyQP/NFBbJmrnRfaBMVt2e8/fIhTFLhyirsJG/8IgKsSPGTjulPyn/PshHukZFuJHKtptJSpm0uNlU2oSt9F8OUC8EEpASYMQjQ3NOwGNDIOc/bxTPsKAyiZipugtO28Lf31Pdk0lEQBPX9mSvaOdkn3ZjfA8NsvAltdJZXjBIbwXi5Pzzt/u0tJvGeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199021)(31686004)(86362001)(31696002)(36756003)(2906002)(5660300002)(2616005)(6486002)(53546011)(83380400001)(186003)(6666004)(26005)(107886003)(6512007)(6506007)(66556008)(478600001)(66946007)(4326008)(66476007)(316002)(7416002)(82960400001)(8676002)(38100700002)(41300700001)(8936002)(54906003)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ump6WE1vTlJ2ZEk0bFg1MWxBWURCWW4rczB0YUpYQ2FHYVkrSFZMS3pjbjJz?=
 =?utf-8?B?MS9haS8xQ01aNTRrazZBMVRTV1pxaEFZQ3l3OWNBc3V4WWk2UDlpVmdReXQy?=
 =?utf-8?B?dkJ3K1BML3ZVWkN6SHZxd3VvaU9hRXNIWUNFZ3FsZXhZU04ybkpwQkhFaG90?=
 =?utf-8?B?YlQzSDJKL0VRb2lzMlRTVHROY3dFSkM3VnJEN0FqNmF1R3poRkF5eS9jQnNW?=
 =?utf-8?B?SCtvTnZmdTM0bFR1V2hLdTIwd25UMzk3N1JzOUVINmhaUkdFTzFtR0doUjVK?=
 =?utf-8?B?TjV0bGFqb1hKeE9WMDFLT2NvNUFvVUk2VStTYVd1dkJ6SUdnbkxhYVdqTDFk?=
 =?utf-8?B?b1BzNlhoT0taQ2Ira2M4dmVnZWtNWHB3a2xHMGlWbnYxazZyN3NYN21YckRP?=
 =?utf-8?B?RjdlNUt4RjNjS1pnY3FQNVhTMGdwWW5sRCtkZnQ0SFBWMFVKazR3dUs4SjlD?=
 =?utf-8?B?d0lPNjZpc21GNnZpblFJdk1rVVl4UDVlU1JYT29MTE9xOHp1NzB2WlNHQ2o0?=
 =?utf-8?B?YU9NUXV5VFNURFVIZElkWDU3NXJMUmxhK0pZcU5nbUNnb0dsc3dIa0FlOTlH?=
 =?utf-8?B?b0VIcS9GQlRtbnNvTzNFNkliaHd1dHdLZkhVekl6YTZKU1YvQVJpMDVxaTlZ?=
 =?utf-8?B?NVlHYTBBVXc4UElwNDlNOEZEQzZXa0h0ZXpmL2p2dlppL2huVG51ZDJmRU9L?=
 =?utf-8?B?aVljNm01TE1EK0R5ZlV4WURUWGlqNEVFM1dyNGhObytCTzRJOHBQbHQwUmhX?=
 =?utf-8?B?MkJ0NW9hbzIzemVzYmJlK213RHFTbHVJOVhpd2JrZjZOaHQ1Tit1VFFpV2Js?=
 =?utf-8?B?MVRJTnlaOTh4L1BITUJXTjFjUDVGMU5VK1Nwc3lhRW9CTmVxUXQwYjBVOVpa?=
 =?utf-8?B?Z3dnUmtJMytDelhPaUM3MXhsTHA5UTcvdGkvYTNRVlNPMWdzbjZZekNVU096?=
 =?utf-8?B?SGxnWEdYQnArM0tZbnhLV2xLN0pNUUpwbnhwdDN3YW5PbkM5Um1xSnhSc3Ny?=
 =?utf-8?B?L3FHQXgyR2RUbGZUeUU2Rm11OXRIdDZUNEduNWplTFJtUVdpNmJuZFo2eHJu?=
 =?utf-8?B?UGNHWGkrUmhsWnFDZDNUV0dQYmtYSGJub1RBd0FXRTFBRFg5R2RHMUNlMWxs?=
 =?utf-8?B?NktqOVBWb0RtU3ltSEd1N05UV05VaUlGTUtqSmM0dHh6VFpzTzVVUTZucWE1?=
 =?utf-8?B?T3VZYjhBMjM5L0xwSkIrUHIxUkV4QjBidEtTY0UwYWxSekFHKzBlaVlnV3Js?=
 =?utf-8?B?Y3VNOTBFSWFwaDJBZnBIbDJFZHZPbmpPczJhZ01EM0pSWVEwOU1xYjk3ZHFw?=
 =?utf-8?B?emlCWFo4ZmNuMnlTckdDalh0NGZoaVN6YjZKcUh1djVXaVJYVWkxUHdBZkV5?=
 =?utf-8?B?YmtuaG5MeFQzTDE2S3JaQjJOVFhLUURkYldxYnY4Nk9vYnFQYUZsNDYvaENB?=
 =?utf-8?B?a29veVVYMUJuek1XYllVQVRDUHVnSWZQTENJTEhnTkJ6SGNQYlBNOUxHd3Bx?=
 =?utf-8?B?YVVjWHBJRTJNd00yRTJUSGpiT2xIdUNsTFZ1MFVZd2RyTjVrRThtbjRReVNv?=
 =?utf-8?B?Nk1mVmYwQnF3UlRhbXBGRjRFUW0yaS9HUkwyRVV4SGhXTDNJNU1Eb1M3K21a?=
 =?utf-8?B?RmcycndYUjV2MDRPTnFsZXNXa2VsQndkdWhJRmFFeG5QOERNWkNzQ0lrT1ov?=
 =?utf-8?B?bVJUbGZqN0Y1TmplVDhsZ0xiWGxTT25URi8rTDJxVWN1ZnlmNGdkb1dnTzlJ?=
 =?utf-8?B?SlBWQkdpUFdMbUhCbjg2Y01iUnBTVmdYWitzNkRtRFgyelg0QVJ2bm1iaTRL?=
 =?utf-8?B?dk5TNFdKRzQzYjZlTGxyR2dIc3o0U1B4cUJrZWY3aEJFSUhhdnRUY01WQkdL?=
 =?utf-8?B?bTViNnlHQzZYQzhLM2I2SU1wRFdFMGRucTJ6U3AxVEF1WjduNlI5b2t0T014?=
 =?utf-8?B?ZkxCY2creFMycWNjMExQSTNSbVEzdm5RSDFIQk5jWWc0MmlFNDA4Ni9rejB5?=
 =?utf-8?B?K2V3Q3IzWG5laFZDTnBKY3oxcXA4ZEM5ZW1nazhmcGlLZU9ybVU5RHJZWFJn?=
 =?utf-8?B?NWZxSlhEZmZQbmlVTmVwWDhFT1hoMzM0WDlYbWtYS3lDTktTL2xHcHY0N0pV?=
 =?utf-8?B?L2xNRmo2b0I1TzVWSlpZRW1qU3BGaUNSVHJ4NWtjTm45bE0ybXJCR2hxOG4v?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9532abc0-df95-44bf-c126-08db3a9f4706
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:13:17.1199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HTx53rEMyER/CeU5k3J5h171cC9lu9ZX8FnSRyZOr/yMYxO0zXkyGCfjK95RREM9024d2LwJhbfTJcHhxHHWfCD66h/pq/0Jq3+h9O6KDCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7751
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/2023 2:09 PM, Tony Nguyen wrote:
> From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> 
> When attaching XDP program on i40e driver there was a reset and rebuild
> of the interface to reconfigure the queues for XDP operation.
> If one of the steps of rebuild failed then the interface was left
> in incorrect state that could lead to a crash. If rebuild failed while
> getting capabilities from HW such crash occurs:
> 
> capability discovery failed, err I40E_ERR_ADMIN_QUEUE_TIMEOUT aq_err OK
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> Call Trace:
> ? i40e_reconfig_rss_queues+0x120/0x120 [i40e]
>   dev_xdp_install+0x70/0x100
>   dev_xdp_attach+0x1d7/0x530
>   dev_change_xdp_fd+0x1f4/0x230
>   do_setlink+0x45f/0xf30
>   ? irq_work_interrupt+0xa/0x20
>   ? __nla_validate_parse+0x12d/0x1a0
>   rtnl_setlink+0xb5/0x120
>   rtnetlink_rcv_msg+0x2b1/0x360
>   ? sock_has_perm+0x80/0xa0
>   ? rtnl_calcit.isra.42+0x120/0x120
>   netlink_rcv_skb+0x4c/0x120
>   netlink_unicast+0x196/0x230
>   netlink_sendmsg+0x204/0x3d0
>   sock_sendmsg+0x4c/0x50
>   __sys_sendto+0xee/0x160
>   ? handle_mm_fault+0xc1/0x1e0
>   ? syscall_trace_enter+0x1fb/0x2c0
>   ? __sys_setsockopt+0xd6/0x1d0
>   __x64_sys_sendto+0x24/0x30
>   do_syscall_64+0x5b/0x1a0
>   entry_SYSCALL_64_after_hwframe+0x65/0xca
>   RIP: 0033:0x7f3535d99781
> 
> Fix this by removing reset and rebuild from i40e_xdp_setup and replace it
> by interface down, reconfigure queues and interface up. This way if any
> step fails the interface will remain in a correct state.
> 
> Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
> Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
> Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
> Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Big change, but I don't see anything obviously wrong.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


