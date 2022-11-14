Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A6A628A75
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 21:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbiKNUcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 15:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236559AbiKNUcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 15:32:50 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8852102
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 12:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668457969; x=1699993969;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0Y9c1ghdM86x/2Chf7Q1AbxMzf0UiuXlGpF9dn8tRU8=;
  b=P+P4c1vTIyizgGFA3VtgJGKUcamrcEO/GOilLpt3zuyzRishhrrn7FEI
   ZuFdp8LaqzYxpJuanabNd19C1+k0YUIpYATX+h2Y1xe9IevyAFIjIXs/u
   ozGHxcXkGX5tIctDRh7E+CTEqiBAnEDybWOr9PzThbPEUdBhbwKBKIHeZ
   p426Tzo6PaGoVKFW3N9jKTCAK7YjK57UbezIFOzK6XykxpNIU9mYvTsOo
   EU3K8aPuaZiB7u96ZHqVwGFYTwGExRKsa6tAG6ccFxgfU4OzAMxzrqjL4
   gpq5TW/EKbdD0sPbJ1Jcp9C/PZ7m9MpkvqsefEYPGe5dwbY3IsCFc3PU7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="376343368"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="376343368"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 12:32:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702154769"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702154769"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 14 Nov 2022 12:32:49 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 12:32:48 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 14 Nov 2022 12:32:48 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 14 Nov 2022 12:32:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGHzWBzlT1ubLmyHg4LzOtHJtBr6Cao+/5ZvHNV8zMlMgXwT01B5xvk5JagB7dN+xmC1zVni5RclRMjT713/9BYhiRl5c8Q13nlmNnVjXWC98zfh5vYTjdMz6B6nQpnO8Jjd4RKA/MZjDzkB2BH6hOy+txGFa5A/z/nPPCPSknV+rj9j3kswOO/uuJDpE6dOAI4RhNjUOOx+xaH16B9rEsvvX5/HF1KFgdfjwvCHcIvjXhsUA6BxOZuA/Ki/Mja42DB8VTRaBrsw8dtegX4lWDEnq1fsBtDGH2j86XZW3b2+AFyfWU0lP0hDCsTx6eUEAGOYo0oFGNXEkwJwyI4ADw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMp4dgKlRMZe/F74a949em8re34bBTg6BXa8LUWs3DE=;
 b=k6mQetK8pwg8Upof8t41iXjfHIzdYUcY/FmjU/0oVdOxiDH5xWx8IhtU1QfzVYJjyS5t3n+F+geLGueaUQJYAp0TUd2TNUAe2TIxraLuJjp+s+lIvUdbGbfjIuRSBnCbXY8L17FSzAbYttbK3dVK+XlOsqtbpBvHTgFY5rhVqXwBCXDBOM0tfCVe9HiwblXulonQlG9V0jY++HRaL5dHwoKSuJCdtKczfLwrPwCHu5B9sSrCdwzsUCMzaBoKuxFepLcHhSFwMoU+qdhGeBafPB1YLyQwPqdnqErs5DjWMpwtRq6P9iAA4UAiwnzq1QGcY7XnrwDmjhGlD7pZ04pCUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by IA1PR11MB6369.namprd11.prod.outlook.com (2603:10b6:208:3af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 20:32:46 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%4]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 20:32:45 +0000
Message-ID: <d1dc869a-a08e-7f3a-df87-e41849c3e6f1@intel.com>
Date:   Mon, 14 Nov 2022 12:32:43 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2 0/2] gve: Handle alternate miss-completions
Content-Language: en-US
To:     Jeroen de Borst <jeroendb@google.com>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
References: <20221111163521.1373687-1-jeroendb@google.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20221111163521.1373687-1-jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::44) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|IA1PR11MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: b86893b4-e514-4aec-7102-08dac67f6310
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2a0v1siyFiffj3Hwp6HpaDr+eBhU2Cawb5vOKHJUfcJfXJST1wd3cUTgcVxjiwHwziZrXAeso53zxc/J1DhUl6ofWdw6mAXJvK2igaVFeoJFnstbT6b9y3/fURzc+RsCUcq6BHn2r6QG8pje8GWKvHlM8Vg1ZfmMGFjezwsy1XVYywqzDCzSesoMHSJQ38/4wYIxz6hd+rqMdpGZmUllCcX3Xg7WFK6PSKGZeDP5ZKplLO+6JbpkxqHM/Utv5BRp0O65xbPR4ZzKoZunl0XGETkWGsIeEOzK+kvdaa3KCEWg+B+IohOmE47bRH4U/osyQJIC7XC2FLuR2ZoXGEHtDVOFer9gd0Zxa+HhTKbc2pSKDHRViZ23eMlCtdt48uDbFbXJYVpKBi1Fg/Cob+mgdP/b+FWaSqQ+BtERS0zXFVwOSZIMiHcwS8+DWAWHlwfnXs2nUjg3cWxiaTGZ7ZYZRbQ94HqEe1mxTzAlAidFpS7qZgOZikT+7O74wMCRWbcCcXPAFSa1iGHYRSw4Qa37D3bG4g/mETetXyx2UJ/MRu3PaC4hHaea672ynjvZ90x+nzaBwJ3g5KRRQ3VGBgT3Vdm1Qid0LBYDLGYMRp9GS7xvGxWJz726mPUjq3sK0ekK2TP1QTsDtjbVDThA9DySKIVGQkNFkr8b+418D03tW+Brs1HettwD2ZHQPeimJsKRBi6eMr0VWPzb5Nx2RLBqGSFqadSoEIZxYJMpwqyCclOmSdkk0gE1/6+i2BobZxwvZGMG8StbSBNMfpMPfa+2kSz5IaU5leetbCl+hSFgJG4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199015)(83380400001)(2616005)(186003)(82960400001)(2906002)(44832011)(8936002)(38100700002)(6486002)(478600001)(26005)(6512007)(6506007)(66556008)(66476007)(5660300002)(8676002)(53546011)(4326008)(66946007)(41300700001)(316002)(31686004)(36756003)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VytLVU95NW1iaDNxWWNzZHlidHRvZzM2WXF0SDBvY2NjZUs5d0doNkJQM0wz?=
 =?utf-8?B?N0tjYXowYUNCWXVNRUNicTZ1a2hQWHhXK04zd1U1VEZISlNydHdqQU5nT3gv?=
 =?utf-8?B?dFh4UDVPaVByVzJ0SzY1M0RSTHN1ZGJPSTNhZDJaMHFzMkUrVVRGUWxtWkJi?=
 =?utf-8?B?NThWMkdZNlU3MEY5QjB2Y2NRMHZxQ3NLTkVJYm5LaEJqNWJhcjBpeUljYXZF?=
 =?utf-8?B?Yk9uckt6V3hncjRsb2pFditKRFIwRHJJems2VGlSNE1iVk5BWUxwSGZKMmw0?=
 =?utf-8?B?MXdHZ1V0MVlJSGQzcGc4bUh4UjVDNm91SVg4c3FzY3d5M3ltSDhTaS9hU1NK?=
 =?utf-8?B?eWRxbVh3c2JtcGRETU42QWhia25aMnF4YVZobjI2SzFSVzBjd3JaMmtHSkNJ?=
 =?utf-8?B?ZXNBTzBpTTlYUTlHMC9TQlhHbDNwbXlpRzYxNWozdDA2djNIUWpaZmhJSkVv?=
 =?utf-8?B?T1hLbldTK2hBdEJBNE4rK2ZoS3lYZFJrSkxwZHNyV2RXUmtwM09YcEx4R3I4?=
 =?utf-8?B?RENJZGtORkxTWlBJdzdKb3NuWFBZYkU4SU1OWTdKL3BXS21zVjNPWHlSaVJm?=
 =?utf-8?B?S1BRa0p6SzdPc1BSRHY2WWRwRVZJeGppZ3FiSnRQZ3pLdmJzUXVjOTJES3dT?=
 =?utf-8?B?a2dQTXN4T2NINDFBdGdQRkxqTldNTjFPVnI1TjFmNDNoYTFmR240alN6U2tZ?=
 =?utf-8?B?cWRYNXRPcG9DVEt6aHFvcFozY2lKZXRiNXdaanRoVTJvYlRVdG0rbEhEdFJ3?=
 =?utf-8?B?bE92VlhMOGo1bnlDNnlPVWFuU2JvMDZMU1Fyc1JxeHBYRGJRNmVMOXhaQ1Js?=
 =?utf-8?B?QUNBMXFlcHFqd2RGeXllei9tYkJ0UjhTenZTUHFleUFCZXd4YWZrZjZlcGpt?=
 =?utf-8?B?dEM2VkJFeE0rTFdkT3UwR2xLSkd6OXZZdnFFNzVac0FnWWZtbURhZkZhdElo?=
 =?utf-8?B?clpRdGpnZWFRVlp5eHJMT2puNXk0dXIzUURXekRaY0E1MWs2TmYzT240RUJO?=
 =?utf-8?B?N1B1eUQ5REtieXUydnc2MllIYkpWb3pWeHh1Rm1XOFcwVytkQlNyVEJFYVVQ?=
 =?utf-8?B?cTFTTE1sSnNza25RejRkaHhUZVpwWUZhMGpkb1ZVUm5nd1hEMTJoM3J1bFRi?=
 =?utf-8?B?Ujk3Y0xZWnlzeVhZRktpZURGNWdOZGRlcWlNbFdDVzNqYVVySUZKQktrQWlk?=
 =?utf-8?B?aEp3U1cvZ0NiTll2aC9kNGVMU2RFME0rMWJiaVBDaktoWk5WRHJHMU4rbGxu?=
 =?utf-8?B?VEZQUmxSSGpGV1ZTV09PcEFnNkNjMnhWa0NvL1hCNS93ajQyKzNkMC9seis1?=
 =?utf-8?B?MVB2Y0lLbUJKVEM5c3pldm9ScWpla2RabE1RamVHODY1L2hwQ1cyMEJCaWRZ?=
 =?utf-8?B?dDhWVjUzS08vdVQ1bEZPaGhLV1JYZkJRR3NVTDd5YkpaNnpTVFQ3TnZKWmxp?=
 =?utf-8?B?Q3FseUdzOTc5NFpySVl0M25oaHcyVzZ0UzNCcFVvdXJueHlPd2orNmorOFlv?=
 =?utf-8?B?TjJuWWZKZVVyWHZ4bzd5YnhRQzlBK2JLV2orVm9qVDJTNDBtbnBjZGc2ZGMy?=
 =?utf-8?B?enhxQXB5cEJtakw2UkNJL2hIYUxEQWJObU9YdUkyNlhLbmtobncxMU00djVG?=
 =?utf-8?B?NlhvbzhCN2ZuK1h0VlM1all4MVBTK05sWlJwNUNCdVl2d0QyN1FJamlzc2dD?=
 =?utf-8?B?Zm5TOWFldnI4Y3NuRUh0bDNjdU1jeXFNQVVrV0tMc2p6UFpOT0lsSlAwVnVI?=
 =?utf-8?B?cFk5SDhGVElpbStGY0lreGEyMFlQczV6NWVvcXVxcXJNamFhckp3KzJSRHhQ?=
 =?utf-8?B?ZjYrTWFRQVlUOFJoVUs1VzRJdnNxdWhHOEUwZklFQnpzKzl5ekx4SVhIcE5V?=
 =?utf-8?B?cUhFVHpZb3FzK21YWVloNWQrTUd1eExMQlZ3VldZdGRTanhreEtaNmhvT1F5?=
 =?utf-8?B?NnBOY0hXSjBxREdQN3dyYlhISUJYQ0J3TVdhSXF2RDBET1dpVW1FNW9tSU8x?=
 =?utf-8?B?OEFZbS9Wb0V1WXFySDRtaUg3dFBzYlM5WnNpSExBaGxRK1UvMUpwRHY1UGlH?=
 =?utf-8?B?NlZZU1FuMWR1aXdjakZGU1lDSDRlYlBwY1B5eSthYTJCOC9UU0pYNEI4cGNk?=
 =?utf-8?B?QTREZ1dkOXU1TFJIcER5YjdOVmw5enVJRDBtVlYwditJSUorOUt1VTIwNzVk?=
 =?utf-8?B?c1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b86893b4-e514-4aec-7102-08dac67f6310
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 20:32:45.2295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zSNTWkiBlgv5snkAO1sCM2ztu4JvCH1ybM3yvnhI3RIuwTyTHMIgg0X26omTBxfeYlMC+36J+idz/li+ahq4OZ/BQnff+EkaPp1Zppvlbsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6369
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

On 11/11/2022 8:35 AM, Jeroen de Borst wrote:
> Some versions of the virtual NIC present miss-completions in
> an alternative way. This patchset lets the diver handle these
nit:                                         ^^^^^
                                              driver

nit: use imperative voice. replace "This patchset lets" with "Let"

> alternate completions and announce this capability to the device.
> 
> Changes in v2:
> - Changed the subject to include 'gve:'
> 
> Jeroen de Borst (2):
>    gve: Adding a new AdminQ command to verify driver
>    gve: Handle alternate miss completions
> 
>   drivers/net/ethernet/google/gve/gve.h         |  1 +
>   drivers/net/ethernet/google/gve/gve_adminq.c  | 19 +++++++
>   drivers/net/ethernet/google/gve/gve_adminq.h  | 51 ++++++++++++++++++
>   .../net/ethernet/google/gve/gve_desc_dqo.h    |  5 ++
>   drivers/net/ethernet/google/gve/gve_main.c    | 52 +++++++++++++++++++
>   drivers/net/ethernet/google/gve/gve_tx_dqo.c  | 18 ++++---
>   6 files changed, 140 insertions(+), 6 deletions(-)
> 

I looked over this series for things that didn't make sense and I didn't 
find any, so, esp if you fix the cover letter stuff above.

For the series:
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

