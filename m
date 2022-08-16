Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F66595836
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbiHPK26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbiHPK2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:28:36 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1050E37;
        Tue, 16 Aug 2022 02:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660641249; x=1692177249;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BTgN/mDZanMdlKTvj28T78MlIcBJFycEz5fXaw5Mys0=;
  b=hsH6lBpTQPic7zHr7oRpNsstKsC27Q+vYDYayaT1Ru6cfHu9doin5sOO
   YnHNe57y2vazVoKbpPLE9219sfdsskszYNF7Sky1QUlkmhlWMmZijsHFj
   8awOJxVWfQpoSurpI7qpQXLhpwj/o6TLO1I5zk7BrO90SotXL6n1hW62Q
   Tt2YWe3fgpHjgEmCGQTRfmAgZIH31Oufa7X24nErwV5Cz1f6Nnr8sP8d4
   fZPtzAJ2h1z3vrv67lk7lGvu0A5OdI5isLZjIndQ956ncFUVhd8SqOi56
   D386YoF+3Bxqvdqt3nT0nG7Z5n+N6nNLRgm7m0CSurI8s35Z+YO0VzosK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="318162168"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="318162168"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 02:14:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="675144569"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 16 Aug 2022 02:14:09 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 16 Aug 2022 02:14:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 16 Aug 2022 02:14:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 16 Aug 2022 02:14:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4Edku4G1lVW3R0YyeT5SMUlcmruBYWmzjycGLSY8Qyrc+XXR0c0SxRKh9JL/1Ck4To8KUZm7GtRCEKqli1b4A6cCIGdIjRp40E46qHdWn3ygRi56juHj/9SY/34K0KNbjFTWYUfEqUItWPGi9v9+QLGLX+qQY3ZkfdX2hbUbenguFlIMER83EC6Mq91Gl5ckn2WgVmuaiBLcjv7IJW7KOtdpWmtTjq/6JWeA1LZbYwtgOd6ohuSpz0adFXlybGpX0HzALG2x/7JRs4wv3Cr6Y7JTE3f+lUztKboPYgHYWQBPUD7WekuDjkDhcusC0YmPccn8NyHH29HYVQhtpAaQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8acS9e1f9jsjtvTDZpPtQdXQTkULIL1/77fZCFne9p4=;
 b=kega7Qzz0c2GQVxvqIfxTCIqM8WDyw1/TB+o9Le1NiSs8E3QpXXsIRIrefLpFHsTZqG8G3CmpMDAwdvwXsM9j3pzkHLOHIxtD1k01aUY2LJzEKTgcM0rXQczwu+mDVjYxJhBN1rfNFn9focGBFmRvFlYp3n5s+jumjnswMbObU0WxCWYIvvFI/xn2TbEaQ7poIZ+wZGZs+SK8dv4XyxhN9cCSq2RNukeiD8I0f0XNMUFpTF0jZ8k1ZXiOiwrihMkYJ9jwsMKBnk27Oa5LIoArA0mztSDfQbFo8DpOahYofNlHWDrmo6hszXA9LIrVVeALTRgub48GCS7/QfSx6kn3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3413.namprd11.prod.outlook.com (2603:10b6:a03:8c::29)
 by BYAPR11MB3767.namprd11.prod.outlook.com (2603:10b6:a03:fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 09:13:58 +0000
Received: from BYAPR11MB3413.namprd11.prod.outlook.com
 ([fe80::6423:dab9:c2a3:41d9]) by BYAPR11MB3413.namprd11.prod.outlook.com
 ([fe80::6423:dab9:c2a3:41d9%3]) with mapi id 15.20.5504.028; Tue, 16 Aug 2022
 09:13:58 +0000
Message-ID: <dd4f9e5d-d8d7-3069-21ee-7897b3d10d3d@intel.com>
Date:   Tue, 16 Aug 2022 11:13:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [net v2 1/1] ice: Fix crash by keep old cfg when update TCs more
 than queues
Content-Language: en-US
To:     Ding Hui <dinghui@sangfor.com.cn>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <keescook@chromium.org>, <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>
References: <20220815011844.22193-1-dinghui@sangfor.com.cn>
From:   Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
In-Reply-To: <20220815011844.22193-1-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DBBPR09CA0023.eurprd09.prod.outlook.com
 (2603:10a6:10:c0::35) To BYAPR11MB3413.namprd11.prod.outlook.com
 (2603:10b6:a03:8c::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff5aeded-9057-4193-a6d3-08da7f67a68e
X-MS-TrafficTypeDiagnostic: BYAPR11MB3767:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v5g32jwYHvVEeI2oSLUsuIL93vMFOdykx4f0X/ZpO5hYrJvbHpCs5CDtwIa/TgirCRfY7a/5RAbvXwTrbbeUY07I/3gXI9edlckQ2M5ptrSxT/PIN5HA/nlPxLe+TchGSVSOeELYPKSs3eMbet1vIfUw5IxnxY1GyH0Fd/vEWF9e+V3uU9/2n8YRVM4JBAXbbndkgArexjklKDZwK1zsfq6+G6sOm9BjFvSd6JnN+tA88QYHpj8TCyv81Snh9fQEagihxSP5SGoDpSdJRp8K8L6tLQTXQJ9BfET+qrsdz+EA/SHnotXyXpoxkjjsNe4iKYvKOw8uTsH12+T36qBPPs+QxsTzI3I/043W6OPzr8JqY4tOvBHm5DoRKWk0u+C4vHR0r61fuWbzOAJSEjkDvVXG4EYoskDSpSe8BhCz1LHwfIO1m3kG8hBVJM4hV+lJhY9UrKbjXH3i8E1L85BCOjvFDklKp5NdglRzPois14tqTP0kXewQs0ANv3pqRd0SLkzaPrKvEtz5Mcc19mb0xKoE3o0q+EE5B0vDbIwESHbYIawtgWJ3z5JDDqfZXTiiCiZEOKc8sOpAwf5F6Wy8FJ9YaIRH6Y+k+hV2fLFupvgVbGIIl5ZCNKEqo5LR+xnk0EfeEXAPFSVX3ImWyr5m7rDIQWNNa3NnbEwgfOJeBEbbWZzOQe6X2DeL0RuD/01sx4xL8SqcMOXZQP4QyqmB6b+pGNlOgKOaCtjgSw3EugMhuKrv6leDEc2xh76WMPBG/RQknAnemZpizdOglvK91lwHEgih/1ZDjWuaPNFYQWpccBj2P6Oueym2OtO8WfJRBXIm1NqIyvYNqIXPjIYex5ebf+8nbWbW++ak4+7Wt77AVCXQxw4IAT/B9CzqP1uT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3413.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(366004)(39860400002)(396003)(966005)(41300700001)(316002)(478600001)(38100700002)(4326008)(6486002)(7416002)(8676002)(66946007)(8936002)(44832011)(15650500001)(66556008)(5660300002)(26005)(2906002)(66476007)(31696002)(53546011)(36756003)(31686004)(186003)(86362001)(6506007)(82960400001)(6666004)(2616005)(83380400001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHY2SDIwWjg0aWJkVHNNYmJoRW5LQnd4ZVNjS29vY0lUT3JFRHlKVWR2SFBj?=
 =?utf-8?B?RERQU05JQXNmUWVzakxVZU92WFNLVEdlT2E1MjBzMjlYN2ExK3RmWE9nVTVN?=
 =?utf-8?B?RkVPWHNqemJ2cnowaTcxS3ZRZmZQQnJyeGtXVDQ5RGZrQ3I0TThLdnNmVnh2?=
 =?utf-8?B?VDg3eVpWYlB2OXlpNXVpRHRiaGtwTXJsQm1sTXpwUXlzeWVWL1craytURjEy?=
 =?utf-8?B?K0VlanprYnFkK1V3eTdoMkd6RDc4YTlnL1V5bDJUWFdxeUxtZ3BLS2RsRWFx?=
 =?utf-8?B?YTZrRjRXMko2eHNsSllYMHVlQ1NocjJYcUF2Qzl2c1pHR0dzZVQzejFHT2Ft?=
 =?utf-8?B?Vkd0OHNwMnk5Zko5RStySGd4b0xoQVlOU0ptRHFUSklPRCsvSFBnMUlRM2M1?=
 =?utf-8?B?SlJWWVB0OS9NcnJYL2tPYWd2ajRRbnhVMnpaemNkY2puNHhsTzBDUVliYUc5?=
 =?utf-8?B?ZC92OTNPV2NaTmFHQnZYZzBTTjZoUXJVSktTTE8rY3VlQ3hQN1pjTXhrazFT?=
 =?utf-8?B?VlFac21GY091dnA3b3ViMHVpZzFSbmRqT1B0M3BzUk5FQWhrVUNwc1dkTkR0?=
 =?utf-8?B?S1o5aDd6Z1VJYS9lR3lFT1BoVFBSQXVVNUVTTXpsUWFXQzE4Sm5iamlFUFVN?=
 =?utf-8?B?RFJ2VW1Nd0xVZmNjZ0xpdTF6bzNhMjUvTEZJdzI2ekpUTW9LZlN2WUVaRnNi?=
 =?utf-8?B?VkdkU2xlaXo2ckIyVlBvTW5TazZrdG9qS1I3bW56NDAzQzQ3U3I5NDZpR3NJ?=
 =?utf-8?B?UUo2cmRXaDhXMHNIVnBNK1dmN1FqQ3dIazFYRlNuUytmOHVnT1JEK0hkb0pj?=
 =?utf-8?B?OXZxVjc3d1lVZG1rQ1d3Sk04MmlQYmdQYWxEeDduV3JoL2RZV1ZOZzdhM0hx?=
 =?utf-8?B?M0RsVE5WZVQ5b052ejE1WldwN1owRFp2OWYrVWdsaXZXZ3BURVg4MElBMEUr?=
 =?utf-8?B?QkZ6UVJ3ZWxBWXc4Y0gyT3ppYmliSGw5ckFIZW9ZZlRmeklBQ3dwSG9vcy9N?=
 =?utf-8?B?NzhFcHc2eVpBSXJqWnpCdk55akxhd1c4R1dCY1Z5VWtSUlFHS3ZHMHkyeVNC?=
 =?utf-8?B?eWcxNTZ2L3BydjcyV2VMQ3dQRmYzdXQwaTZVLy95d1dWRXhENkxuWFRSZi9B?=
 =?utf-8?B?MzNObUN0WDBZbXFkUEVsc3pSbFBaa1RIMksrV2ZVQVRwQWZqTUhydk5PMkMz?=
 =?utf-8?B?dFNFSFl6NWRRL2ZzVWtBL0hla1lhRTNvZlk3SHE2MXRiOS81dXZuUWFXRnlx?=
 =?utf-8?B?SXlvS0l1Rk9YUEh0bksrRDdLWUhtMnNBSEpvQXVMWXlFNFBHY1F1R0JLWE1J?=
 =?utf-8?B?a0JpaUV3ZStaekVPbnpXUk1rMGt1WkVxa0tZeitpTVlYKzhZeE5NQkp2L081?=
 =?utf-8?B?SnhTMldtRDFpUEdhclVlYlBVRDVCZTRUOW5za01QZmpINUNlYzZUYlBxNllI?=
 =?utf-8?B?dnViekxLLzlTRkxLOHNnMjZlQmwzVEQ3dDBtN2prY1JIQ1JIZGhzeTJXMlZC?=
 =?utf-8?B?OWVZRldDZC9BaVBYMnZaNmYwTThpR2lUT0o4WnZQQ0RPZWpSV0Y0Zy9zR004?=
 =?utf-8?B?aFNFZEpEbjcwWGZPN3FnTnp6M3BFNi9wMnlVT1NkckhOOXV2YTQrZ3NURC9y?=
 =?utf-8?B?ejgxTEd2SWpmS1krOUxXaGFsM21BRXJBRkwveUtzeUNVWE44dHZxWnlMaUVu?=
 =?utf-8?B?TXo3QzYvR3lzaHlZNm93U08rYmV5M3lNb201UVl1V3hNaVpDbnB4Nno0K1lC?=
 =?utf-8?B?Rk5aMnZkcVROZ1IwaVdha0pEUnhuY3Q5Q29YMVh3YzJHemppZi9aZnVZMkpl?=
 =?utf-8?B?M3M4aDc3SjJTazBBaU1LYTJzcThnU0VQVEs1NTNibnJDUEdEUE1vSTVaQU5H?=
 =?utf-8?B?Z2FMelArYkR5Rm1lc2JrL3A2ZThBRU5XMHh6OVVuZlBTYUhUOG1SaHBDTGlB?=
 =?utf-8?B?SVhFMUI0c2kwcThzaTIwZU9CWk9JNUpvS3c1SldGaUhYUVVTSUlWRVJjanQw?=
 =?utf-8?B?VTNzRitURkhVR0FQY0txN1V6dXNveDRBY01qWDN0bEVKREJDNkRGUG1Wc2xT?=
 =?utf-8?B?MXk5QTJHaEIrK0QvK2FBYWRwMkxOTmVkcmluZ2dnVDRaeExVQm1adXBqSU5Y?=
 =?utf-8?B?MERpbTB0bUl3MzNOcE9tYkIxRWVNNURBMnF5V2dhTTNkNzc4VjVCUnNJU01m?=
 =?utf-8?Q?vERRXPiaJbND0d1IOJFJvjc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff5aeded-9057-4193-a6d3-08da7f67a68e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3413.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 09:13:58.1728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eS7pHWPg1fCKT3+J1708hFtbGxytY7O6x4jOMR+TmsF8aC9H8uxZki8mZNFY6MgZ0uvVJv5aeqkcC8RIuxAdYKXCE4AYDfRIcxuYvp67fAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3767
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.08.2022 03:18, Ding Hui wrote:
> There are problems if allocated queues less than Traffic Classes.
> 
> Commit a632b2a4c920 ("ice: ethtool: Prohibit improper channel config
> for DCB") already disallow setting less queues than TCs.
> 
> Another case is if we first set less queues, and later update more TCs
> config due to LLDP, ice_vsi_cfg_tc() will failed but left dirty
> num_txq/rxq and tc_cfg in vsi, that will cause invalid porinter access.

Nice catch. Looks good to me.
 
> [   95.968089] ice 0000:3b:00.1: More TCs defined than queues/rings allocated.
> [   95.968092] ice 0000:3b:00.1: Trying to use more Rx queues (8), than were allocated (1)!
> [   95.968093] ice 0000:3b:00.1: Failed to config TC for VSI index: 0
> [   95.969621] general protection fault: 0000 [#1] SMP NOPTI
> [   95.969705] CPU: 1 PID: 58405 Comm: lldpad Kdump: loaded Tainted: G     U  W  O     --------- -t - 4.18.0 #1
> [   95.969867] Hardware name: O.E.M/BC11SPSCB10, BIOS 8.23 12/30/2021
> [   95.969992] RIP: 0010:devm_kmalloc+0xa/0x60
> [   95.970052] Code: 5c ff ff ff 31 c0 5b 5d 41 5c c3 b8 f4 ff ff ff eb f4 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 89 d1 <8b> 97 60 02 00 00 48 8d 7e 18 48 39 f7 72 3f 55 89 ce 53 48 8b 4c
> [   95.970344] RSP: 0018:ffffc9003f553888 EFLAGS: 00010206
> [   95.970425] RAX: dead000000000200 RBX: ffffea003c425b00 RCX: 00000000006080c0
> [   95.970536] RDX: 00000000006080c0 RSI: 0000000000000200 RDI: dead000000000200
> [   95.970648] RBP: dead000000000200 R08: 00000000000463c0 R09: ffff888ffa900000
> [   95.970760] R10: 0000000000000000 R11: 0000000000000002 R12: ffff888ff6b40100
> [   95.970870] R13: ffff888ff6a55018 R14: 0000000000000000 R15: ffff888ff6a55460
> [   95.970981] FS:  00007f51b7d24700(0000) GS:ffff88903ee80000(0000) knlGS:0000000000000000
> [   95.971108] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   95.971197] CR2: 00007fac5410d710 CR3: 0000000f2c1de002 CR4: 00000000007606e0
> [   95.971309] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   95.971419] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   95.971530] PKRU: 55555554
> [   95.971573] Call Trace:
> [   95.971622]  ice_setup_rx_ring+0x39/0x110 [ice]
> [   95.971695]  ice_vsi_setup_rx_rings+0x54/0x90 [ice]
> [   95.971774]  ice_vsi_open+0x25/0x120 [ice]
> [   95.971843]  ice_open_internal+0xb8/0x1f0 [ice]
> [   95.971919]  ice_ena_vsi+0x4f/0xd0 [ice]
> [   95.971987]  ice_dcb_ena_dis_vsi.constprop.5+0x29/0x90 [ice]
> [   95.972082]  ice_pf_dcb_cfg+0x29a/0x380 [ice]
> [   95.972154]  ice_dcbnl_setets+0x174/0x1b0 [ice]
> [   95.972220]  dcbnl_ieee_set+0x89/0x230
> [   95.972279]  ? dcbnl_ieee_del+0x150/0x150
> [   95.972341]  dcb_doit+0x124/0x1b0
> [   95.972392]  rtnetlink_rcv_msg+0x243/0x2f0
> [   95.972457]  ? dcb_doit+0x14d/0x1b0
> [   95.972510]  ? __kmalloc_node_track_caller+0x1d3/0x280
> [   95.972591]  ? rtnl_calcit.isra.31+0x100/0x100
> [   95.972661]  netlink_rcv_skb+0xcf/0xf0
> [   95.972720]  netlink_unicast+0x16d/0x220
> [   95.972781]  netlink_sendmsg+0x2ba/0x3a0
> [   95.975891]  sock_sendmsg+0x4c/0x50
> [   95.979032]  ___sys_sendmsg+0x2e4/0x300
> [   95.982147]  ? kmem_cache_alloc+0x13e/0x190
> [   95.985242]  ? __wake_up_common_lock+0x79/0x90
> [   95.988338]  ? __check_object_size+0xac/0x1b0
> [   95.991440]  ? _copy_to_user+0x22/0x30
> [   95.994539]  ? move_addr_to_user+0xbb/0xd0
> [   95.997619]  ? __sys_sendmsg+0x53/0x80
> [   96.000664]  __sys_sendmsg+0x53/0x80
> [   96.003747]  do_syscall_64+0x5b/0x1d0
> [   96.006862]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> 
> Only update num_txq/rxq when passed check, and restore tc_cfg if setup
> queue map failed.
> 
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>

Please, also add Fixes tag.

> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 42 +++++++++++++++---------
>  1 file changed, 26 insertions(+), 16 deletions(-)
> 
> ---
> v1:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220812123933.5481-1-dinghui@sangfor.com.cn/
> 
> v2:
>   rewrite subject
>   rebase to net
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index a830f7f9aed0..6e64cca30351 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -914,7 +914,7 @@ static void ice_set_dflt_vsi_ctx(struct ice_hw *hw, struct ice_vsi_ctx *ctxt)
>   */
>  static int ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
>  {
> -	u16 offset = 0, qmap = 0, tx_count = 0, pow = 0;
> +	u16 offset = 0, qmap = 0, tx_count = 0, rx_count = 0, pow = 0;
>  	u16 num_txq_per_tc, num_rxq_per_tc;
>  	u16 qcount_tx = vsi->alloc_txq;
>  	u16 qcount_rx = vsi->alloc_rxq;
> @@ -981,23 +981,25 @@ static int ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
>  	 * at least 1)
>  	 */
>  	if (offset)
> -		vsi->num_rxq = offset;
> +		rx_count = offset;
>  	else
> -		vsi->num_rxq = num_rxq_per_tc;
> +		rx_count = num_rxq_per_tc;
>  
> -	if (vsi->num_rxq > vsi->alloc_rxq) {
> +	if (rx_count > vsi->alloc_rxq) {
>  		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Rx queues (%u), than were allocated (%u)!\n",
> -			vsi->num_rxq, vsi->alloc_rxq);
> +			rx_count, vsi->alloc_rxq);
>  		return -EINVAL;
>  	}
>  
> -	vsi->num_txq = tx_count;
> -	if (vsi->num_txq > vsi->alloc_txq) {
> +	if (tx_count > vsi->alloc_txq) {
>  		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Tx queues (%u), than were allocated (%u)!\n",
> -			vsi->num_txq, vsi->alloc_txq);
> +			tx_count, vsi->alloc_txq);
>  		return -EINVAL;
>  	}
>  
> +	vsi->num_txq = tx_count;
> +	vsi->num_rxq = rx_count;
> +
>  	if (vsi->type == ICE_VSI_VF && vsi->num_txq != vsi->num_rxq) {
>  		dev_dbg(ice_pf_to_dev(vsi->back), "VF VSI should have same number of Tx and Rx queues. Hence making them equal\n");
>  		/* since there is a chance that num_rxq could have been changed
> @@ -3492,6 +3494,7 @@ ice_vsi_setup_q_map_mqprio(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt,
>  	int tc0_qcount = vsi->mqprio_qopt.qopt.count[0];
>  	u8 netdev_tc = 0;
>  	int i;
> +	u16 new_txq, new_rxq;

Please follow the Reverse Christmas Tree (RCT) convention.

>  	vsi->tc_cfg.ena_tc = ena_tc ? ena_tc : 1;
>  
> @@ -3530,21 +3533,24 @@ ice_vsi_setup_q_map_mqprio(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt,
>  		}
>  	}
>  
> -	/* Set actual Tx/Rx queue pairs */
> -	vsi->num_txq = offset + qcount_tx;
> -	if (vsi->num_txq > vsi->alloc_txq) {
> +	new_txq = offset + qcount_tx;
> +	if (new_txq > vsi->alloc_txq) {
>  		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Tx queues (%u), than were allocated (%u)!\n",
> -			vsi->num_txq, vsi->alloc_txq);
> +			new_txq, vsi->alloc_txq);
>  		return -EINVAL;
>  	}
>  
> -	vsi->num_rxq = offset + qcount_rx;
> -	if (vsi->num_rxq > vsi->alloc_rxq) {
> +	new_rxq = offset + qcount_rx;
> +	if (new_rxq > vsi->alloc_rxq) {
>  		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Rx queues (%u), than were allocated (%u)!\n",
> -			vsi->num_rxq, vsi->alloc_rxq);
> +			new_rxq, vsi->alloc_rxq);
>  		return -EINVAL;
>  	}
>  
> +	/* Set actual Tx/Rx queue pairs */
> +	vsi->num_txq = new_txq;
> +	vsi->num_rxq = new_rxq;
> +
>  	/* Setup queue TC[0].qmap for given VSI context */
>  	ctxt->info.tc_mapping[0] = cpu_to_le16(qmap);
>  	ctxt->info.q_mapping[0] = cpu_to_le16(vsi->rxq_map[0]);
> @@ -3580,6 +3586,7 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
>  	struct device *dev;
>  	int i, ret = 0;
>  	u8 num_tc = 0;
> +	struct ice_tc_cfg old_tc_cfg;

RCT here also.
  
>  	dev = ice_pf_to_dev(pf);
>  	if (vsi->tc_cfg.ena_tc == ena_tc &&
> @@ -3600,6 +3607,7 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
>  			max_txqs[i] = vsi->num_txq;
>  	}
>  
> +	memcpy(&old_tc_cfg, &vsi->tc_cfg, sizeof(old_tc_cfg));
>  	vsi->tc_cfg.ena_tc = ena_tc;
>  	vsi->tc_cfg.numtc = num_tc;
>  
> @@ -3616,8 +3624,10 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
>  	else
>  		ret = ice_vsi_setup_q_map(vsi, ctx);
>  
> -	if (ret)
> +	if (ret) {
> +		memcpy(&vsi->tc_cfg, &old_tc_cfg, sizeof(vsi->tc_cfg));
>  		goto out;
> +	}
>  
>  	/* must to indicate which section of VSI context are being modified */
>  	ctx->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_RXQ_MAP_VALID);
