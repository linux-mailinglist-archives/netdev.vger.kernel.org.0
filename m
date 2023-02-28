Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CA36A5DC5
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjB1Q4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjB1Q4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:56:35 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EDB6EBD;
        Tue, 28 Feb 2023 08:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677603378; x=1709139378;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f9ABy93s2Fpar1PlVN4GM+kXyAy3Pp+0fBo6mQaGjhk=;
  b=NI4GQWLEbjbOWAe3j7nv7CqBqaAw4OBw5mcfBtlx5rKrMtltRQRp8trG
   70rHR19JMA7hxT75Q3G5QwR5xWZoejksWKRui4HUDPGpbi4gYnXNE5FM9
   R11iHq7mn/1hGQhalqGUFx1UlrZ7zXTM/2dS6TtFHMLL0ULx1KdJ3fqdN
   2bqjm+k28Xizm5fRynv1xD9GQXI1NsAhudBJ594bxExuXqRrrlsjv/Z5I
   7RU1iQWvrf9KZVpyMwyQG302y5CTvG5l91h0it/hIIPz2om5CP0IKTkYr
   d2LHYUVm8kBol7jGCJqtIPXSfBcpMhwAzjrNNrQqx7J/KJb9BDdJ+x6VR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="361753478"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="361753478"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 08:54:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="1003285014"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="1003285014"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 28 Feb 2023 08:54:05 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 08:54:04 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 08:54:04 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 08:54:04 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 08:54:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ay2ZdHchr/g6nNRKOkWgtSRDrEaqT3vKi2hc2UwtxzYeRXsubvOfDRKB0vghR1Dpkog+wHovDLl/B0ANlasK7JWjDPy4xYHyiFhILeMMD1LIU6yM/47ZKnvLk069ePo6pQZRp6jjzH4O/5JSa+7dMVr56g6PEzSP8m/S11ku0OEY+jaeWkzbv5zoIaPtaia6b2JRC/+qDlNQ4n4+xIiodEGfyRXLwfb9YAuxzWLv4x4Yram46MosAXXfThOj6Q2fz/lCz7YaHXU0eQaMYaSkAf809wktFtY5jgs/kaUCXmC0JEt5Bv6mc6QoiiDRU4MYf7J/DLiHkrtYw5pGJyLRpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fvbzcHhk3GtoEPMl57n/MD7sTs3LSBZef8ykTbQFb2o=;
 b=PSmlCJko6N9vnd9g9Jx/LtdnqZ3khbGjgBFdHZAuHfmZ+qBtv24M5q5VPfheX9Hr+1cyXXbmOnbBLsd7exf/4JCN/93ZlFUavkFrhpZikYixhcBLB80VC8mGSOjGuqzm5CxNHoGqOlFZzPS6Fco0I/hNJMYh3U4t3jXLSIkKwkY+f0D73Go8XMIReZlbhKQUnvwzQjl9EK1vX8mGFOOp7NR/cfmffJIxGbRDXn4tmusfWiWTj92lRwFaubF9J+wFuUE3WUd0+F1ffQszww5x9O7ynQfxetwGMRIOUJdk2Adk0UC7PsP6cjytxf34O5+hRX4Ufoh+QJWi/hcg1gS6lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA3PR11MB7462.namprd11.prod.outlook.com (2603:10b6:806:31d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 16:54:02 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 16:54:02 +0000
Message-ID: <f45c1cbf-3dc1-5075-feea-1613b059bf71@intel.com>
Date:   Tue, 28 Feb 2023 17:52:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v2 2/2] iavf: fix non-tunneled IPv6 UDP packet type
 and hashing
Content-Language: en-US
To:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Michal Kubiak <michal.kubiak@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230228164613.1360409-1-aleksander.lobakin@intel.com>
 <20230228164613.1360409-3-aleksander.lobakin@intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230228164613.1360409-3-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0129.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA3PR11MB7462:EE_
X-MS-Office365-Filtering-Correlation-Id: c527d451-97fa-4438-2fd7-08db19ac64c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IwqBtIwIpuWiTughiMtBZ6xjICbWePP8a12ueZh8TV40GLLeOf3oz6Cac761xB9DJfqnG1m9gYdPjmhJD94RZYX6JY4O2diGCmAp2mYWJgzWz5t0lIaVXPS1ZyWFzF4FfLbwNkpOWtdyxlGy74h6euiTVOzIqmO7UkRjj8leAbR0T+8cm8GL4Ra+p3B7qOHDzHZ8X+u0c4hyWEY2kUXyi9+hkM4SimYuDckXwOgagW5+XALY8mPwFMm6sPbuAkyOrQw7DxjDh4Ykr2ZnvYNbU1nOtSs++uAuR5ajh2dGYJagop0u8MKx9CgtMys13m/Tq4D+6ZgyMWmHCYsYmgvVn70BwBuUcjzWYEUqdWX/KpwXM/ozU9RxnCypJgmvyeXCZNGaPxVZbVF3gofzRs4wMxBgu7ljLBC4QOB99Wf046hgj1Gsaiw9uunwPq0u7v3Clvzdr/IU5Q0jTAXikJNRnYGf0G4hO0v0tmu2U68aCDlumepkz7NEUumvQQVF19BBKIhhqQWi7TKt9q8TjO3dbfqPioe2vO4IMsqZqqimOFTclS7vX892clmT+50QeGV5ssGGElGQr5GmxSPuHd/jj6bZS1Y1wKzekXZ6qLR8hZbaQFzb/QX5upYoTUjd69l8Q7Q0FXCJFMKB4Ig0pWobZR8BC5wwEfOVwGsE6ZOaUQKQ/VlS8C0iyO8KeBJuZLl4a9cnAEGKXTvIzHgz3dtcilGPCUnUot9g1kqTjZrxX6o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(136003)(366004)(396003)(39860400002)(451199018)(82960400001)(26005)(186003)(6512007)(6666004)(6506007)(38100700002)(31686004)(83380400001)(2616005)(86362001)(31696002)(2906002)(8936002)(41300700001)(316002)(4326008)(6486002)(36756003)(66476007)(5660300002)(8676002)(66946007)(66556008)(54906003)(478600001)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGYwZTJKRitEbVBBMjQ5YzFFRGZrZFVMNHU3ZFVzUFJXQnZKYXh3VytBNUQr?=
 =?utf-8?B?dFZNQzRrU0FZSXNqdW5QdHBoQkZWL2hMN0ZEMGxKUmFtdklqd3N1cjg0VzQx?=
 =?utf-8?B?RWRzTk90bHBkVU9tcU1lUHJDNFlLZFpTRlZ5a0NmOWpVZVVveG1IRU5rZmJ3?=
 =?utf-8?B?TXZRMVRoQkpNcHN4ZzUxYktTclFmZUNJZnMyYS85NDc3a2FRM21PSStwUDZG?=
 =?utf-8?B?NEU3djh5QXZ3UVR1Smp0TFpZRTB2WGtNUnErQ1gzcFhvbG5BMC93WWNWSitS?=
 =?utf-8?B?WGorbEo5bk5EM0dTQXlmOEFvVkFhVVdzSmV5dUtVcG1OTnpISURWc0JIeDho?=
 =?utf-8?B?Q3pibGNBZFJFUFJFNXpYaVNweEErTHk0YmFtWm5YVkVwbzZVZnhLdlc0dVJk?=
 =?utf-8?B?b09RSUpmd000UFhFbmw4a1hjR0RPbCsxdXV6UXA0dERQM1pCN0dBUWtIdnlJ?=
 =?utf-8?B?Nkh6T2wxa2tEUC9uOGt4TGJVanI2Z09uVmRpUnBPWlVwWkd6WkU2NmgvVHRJ?=
 =?utf-8?B?TTkrc0JZT0Z1N21FSHlHWVd4ZDRvU0FoOFhvV3lnaVZ3QU1oV0FwM00wNlNs?=
 =?utf-8?B?NUROcnpjQW5iaEQ2U3B2KzVaWk80dklaTDF5Rm52WVdtMjcyMEh6VFVCQ3VZ?=
 =?utf-8?B?bHM4ajIza3RZSGVRd3BFSjdyQmRiSktBRVFPTDZ3ZHlSbHJyeU1uSWNaU2VF?=
 =?utf-8?B?bDdFcHhCa3dTOXMyWURtYzdWcXgwWVN2SDNEMi9FNlBYQW9CSm1MbmVEY3hm?=
 =?utf-8?B?bUQxLzM2dTZ4NTRlMC9SQ1hHckxtN0lzTVB6T211eGtyU3FRb0k3QkdxWnhS?=
 =?utf-8?B?VURPWkhBR0JQOTh1aTlDZzFTMHh3MFZ5dGkwQ3NJSko2akI5bWZQY1F5VXlq?=
 =?utf-8?B?aG5oQ1RuQXA2Y0RQcWp2YjBWdGsxMGRwMXhsaUVzaFoyTU5SSnNXZStZVVZo?=
 =?utf-8?B?MVhNRXUzdnVQM1VsNjhBQnNXZG1HbEdVblgrcUJvUTJQbTVrN2lrUnZlSXJN?=
 =?utf-8?B?aVpSN0FRbDlnd2RQT21vQkxaa1pPSEU2Y2syWnRiWGwxUVNVcGRJZmtLVE02?=
 =?utf-8?B?WGpLZEtSTlUvVStRWlZoZmJyc2dzZVk3eDhnRWF3S3YzRDdaaVpEZkhOTFRV?=
 =?utf-8?B?L1dNVk1lSWV3cnFjT3lOUlBtRUExY21GRzh3ZUtMdG1MZUFRakNlbDRTMmIw?=
 =?utf-8?B?MXN1RStReFFEeFBHZDQxdFk4aHhkc1JicE1PMHRTajBxck9jQldIUjdoLzJW?=
 =?utf-8?B?bFBna2k5N3BNNmRTMzZwU3YwODVxZjkwMlhUWUhZdEgwUlNZNitkaW1kWUox?=
 =?utf-8?B?QldHMndsNXBsd1puTU9vTFRuRlE1b0F0dWYvbDBFWGU1U3hJQ0lqSGJTbG5B?=
 =?utf-8?B?eW95VTdDQW45MmdzYUM1WnNKbldRQXFueWVsbUZxVG1VZmhwUWdWOEM3TWxM?=
 =?utf-8?B?a0JyRGhqYlVJYWUreXQzWlZObzlIeVduMko5bWU5M1dYZWEvSEpQZXZUNkg0?=
 =?utf-8?B?cHphOXR5L0oySFJSdUVoc25ib1RxbDV5RzE2a1VXRFM5aEtxMlB4WFpHOGdM?=
 =?utf-8?B?WDRDZklFT3RrMTczci9MNVBTU3FxaDFidHR1by80TTBsOXVuN3NlZ2hPa1dX?=
 =?utf-8?B?eU81dlVPaElCMjUwL1JmdExpbDJqR2k5RDV6L2gyQ05DS1VhYzBFRHhRbDIy?=
 =?utf-8?B?ampUcnVSbGMrOGZGZGQxQjE0czlsbTNOa2JCdW41Wkd4QTZ3aENkdE0rUjBa?=
 =?utf-8?B?S2pEMjJzVVpLaFozbXBlMmxQaW1RK3NLQmViQlpSSHZ4bXY1dXZyeFg5V2tv?=
 =?utf-8?B?TkJrc3VBWVBEZ2dkaU55OGZjaWNDYzB4YzlXcTdNcFVKWXU0MXNOdXp1L0kw?=
 =?utf-8?B?amQ2eTJxRGlRS3YwVGFLZWJqNFhsdlZRRmNMUUNqb3hOTkFTT1hGK09UNWhq?=
 =?utf-8?B?Znl4Q1o3ZWthTFhDNTNaYTFxR2VaL3Z0aXVPMDNDZnJjZUhDU3VQUzZVT2lh?=
 =?utf-8?B?UGdmZm43U21RMUJMZnhVWTdkWVJkeFNjTUVUQ0tmenhRSmdwekZHaTFoY2Jj?=
 =?utf-8?B?bElCOTVsSzdOdWhZVVFPYmtzVEZtUlZXR2h6NjJhWC9DTlpkQkppNmFhL1Bo?=
 =?utf-8?B?NDJhRjM0SWhrTnJUUzBMM0Q5Mi9hdmV4TmRBNGRyeDByN21wRFdjNGdqQXVr?=
 =?utf-8?Q?oSDOKv4gDfzuEd0ppVzL2kk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c527d451-97fa-4438-2fd7-08db19ac64c5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 16:54:02.1426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8PjPqPbB+WvJjvqGxJvPBWS+0YpYceYOuw525+ZdiKZu5/eG3iRaRghIjRvF9OmGYOyKiBPkJQ8rdPpDSt8bQUriid0cgO6yPScvu04za9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7462
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <aleksander.lobakin@intel.com>
Date: Tue, 28 Feb 2023 17:46:13 +0100

> [PATCH net v2 2/2] iavf: fix non-tunneled IPv6 UDP packet type and hashing
> v2

How this got here ._.
Lemme know if I should resend (it's probably okay for Git, but may broke
Patchwork, dunno).

> Currently, IAVF's decode_rx_desc_ptype() correctly reports payload type
> of L4 for IPv4 UDP packets and IPv{4,6} TCP, but only L3 for IPv6 UDP.
> Originally, i40e, ice and iavf were affected.
> Commit 73df8c9e3e3d ("i40e: Correct UDP packet header for non_tunnel-ipv6")
> fixed that in i40e, then
> commit 638a0c8c8861 ("ice: fix incorrect payload indicator on PTYPE")
> fixed that for ice.
> IPv6 UDP is L4 obviously. Fix it and make iavf report correct L4 hash
> type for such packets, so that the stack won't calculate it on CPU when
> needs it.
> 
> Fixes: 206812b5fccb ("i40e/i40evf: i40e implementation for skb_set_hash")
> Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
> index 16c490965b61..dd11dbbd5551 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_common.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
> @@ -661,7 +661,7 @@ struct iavf_rx_ptype_decoded iavf_ptype_lookup[BIT(8)] = {
>  	/* Non Tunneled IPv6 */
>  	IAVF_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
>  	IAVF_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
> -	IAVF_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY3),
> +	IAVF_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),
>  	IAVF_PTT_UNUSED_ENTRY(91),
>  	IAVF_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
>  	IAVF_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),

Thanks,
Olek
