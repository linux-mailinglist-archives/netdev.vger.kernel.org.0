Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA36066E77C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 21:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbjAQUKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 15:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjAQUI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 15:08:29 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38F3241FE
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673982208; x=1705518208;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xuo7R+VhvL8EAOS88qe2+HzfKwmD6+bNPqT4azcBjRQ=;
  b=RPEidBMnavULim63X74gusxZai3SIFR3zaRH3LUQmSDuSJNzmcZLsU3+
   u5pA1T+XPNJ6lVwDXKDo9ORBTlNZjpfzi2cdELKw/EzEc5diadOnPrwoO
   ymrajQBdFxkfmSH8QL8v+A2+FyIyV+5HuRDC7Eo/Wizypqn7WWkC2EXos
   zNSUcc9MkbhwftkWfLEmLSp4fCXGV3w6MimLCmlaYURAJ8V0cMwTkccNn
   MgErJy378Xj2Dz51/M8pJ+MJWYnyMFYzHlyURVCsiTZQfAL2HE4dLjvu9
   9t8y1iNR3mNyrdHFtGUGsDFrXEMoVde4KLrjapQPIrtpGGOj9yobhLX5M
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="312659287"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="312659287"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 11:03:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="801854381"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="801854381"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 17 Jan 2023 11:03:26 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 11:03:26 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 11:03:26 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 11:03:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyLZdJ25oi7I4/bTzt/f5tGdlImE3GdOx5NWZF3uI2ausEvZKlXY9YJQ1ps4UuVO3SvAp3pFYX184cyFk9agXsyouL2jL8OqLa0GV4iZejfBSgSZFhyLu1TwBNi/CJ732259a3A1FrY2r+W/EzFSq1eIU/F9PabjwwmFruHYtkJq6Q8MdwUZkPHr/GkpHkcRjSas3sbFIFEqKfixmaA12qYjYOoVkXGBGQyddVOvnecHsumJT+koMZNGxXSIuKx5SYbpyw0Vu6WjJjeAhXQwkRECi7JRUF04jkiMlr1oFjVdT9D07f5hwmOGHcxdU30MaXS0UDr6gKPEv1wO2O78+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1SqZL8cusF3j/+LIwSrdq/DszOGbEddbFYe8vFjq8E=;
 b=hJYLxU7Lrdc/l4i+eQt7TJewRYLF+Hs7+oc20kl31x0+dPm0zIJheBfJdyCAJlnjX8yKEUVCM4bISsWkGPyaGwUZCG9Bifdx7JmxXFSO7n+ImBolu3tO+AlJNcd6zCQTRuXlNRAFIPUQ5Cw4c8tZOgKW3gZVt7ewSR4gxnW9vz/DPRnNPTMoi+V06B65+lqiCEPfMZBfrwFcKYMAqtyO/9gQzDhc5MjuLriQra9QHMZmQC4d81+EZ2yzoHBWrbB5SBrCBpj0IlcKH20KAQoQzTR4uZDhns2De1Xcl1dqcYX1rmCals1DfZkY8CZyv5Ql3nePiXM8RzIFQeMopODxkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB4800.namprd11.prod.outlook.com (2603:10b6:a03:2af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 19:03:24 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 19:03:24 +0000
Message-ID: <5f494ec3-9435-b9dc-6dd8-9e1b7354430d@intel.com>
Date:   Tue, 17 Jan 2023 11:03:21 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] selftests/net: toeplitz: fix race on tpacket_v3 block
 close
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>
References: <20230116174013.3272728-1-willemdebruijn.kernel@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230116174013.3272728-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0077.namprd05.prod.outlook.com
 (2603:10b6:a03:332::22) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ0PR11MB4800:EE_
X-MS-Office365-Filtering-Correlation-Id: f7612452-194b-4d30-a5f3-08daf8bd81c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: anZDTWr+aIzTHu0qs7iby8l7yKLG8wrOCq8kD1lruNVQFcpfSa/lw4FVpM6I28vqDlAwI4OaN51IWgCE4OTrw7E6R8gMg1vDDBP5rp2LgJnYrvoGDkqeLtHmFfDZKNQJRuf6HGfq24BOugyWj6z9VKFpWmlG7+yk3iorhpq0xYwNT7sq+JIFiKdly5wsCRizJcYy/K/2OCwwUeIfiRuWTtPWgb+enGOF9NApnYBGTznFqV7MgmomJ8JFAduhIs3b4eod+1znUWo6dDR0UEP3l6wswoAvI7KxHEJcoCiI6oU8AjbJnPRloOJLmroxlQ1KqgLWA2YHrjdFs8f4qLFvmuTeAE5fnmx1wvqDzJwe2u/OioAxJbVLmkGCeyMcqyvIO+1oEkmTPUljlb2uSA/5Q4hw7/T4KhQDscUVJunmmEOenbSRL9nMxVpF3WZALvAPxQLidlPP4sq7vYgAN6jW4+y/78A73BXNFCZ9emHmwMop8Udfan0NkuLq4Ztc2vurQ+d5hlLxvPhFKH4JBTPUq48ChRVL/vM10S9UDPvItSqVibaLnzN0/XnOBS8BAXqaxy22GATnxLm+dydWhSitZZqOYd3IRagFW0xQkiaclzOoIrtaYLa1GhgcuCpCyTpxesfhd2YaZyQk/xNbRxbbY++tAs6jUzFOKJolTgfpPO+1lYf8V8cBJCHhmIw96C0+luZ1fNVA6rzF6pzu1MPBtUs2Oj8eHaCF5bjXg99iyrU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199015)(26005)(82960400001)(6486002)(478600001)(41300700001)(6512007)(38100700002)(186003)(86362001)(31696002)(316002)(2616005)(66476007)(66556008)(66946007)(4326008)(53546011)(5660300002)(36756003)(6506007)(2906002)(6666004)(31686004)(83380400001)(8936002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmFqQVVQV3dJcDh6TjNxT1NERUQyaEh2d1IwcVBwVmRTS29iQWw1dDNlMzFv?=
 =?utf-8?B?TktvOVBDcDZoZkJFQ0I3U0N0S0dyRHhEN2pkdVpGQXdpSGNJbHM0RncvaUw4?=
 =?utf-8?B?TGw5ZTBmN284Qm9iWDRsZHJkZjZha3FUNmMxdmNTM3AvdFVuUHNXR05OVVhD?=
 =?utf-8?B?djRORFJVVyszTFQxZEc4Snl6VUwxZjZyMEQzcjdvNkVLOGEwUUZaTVZIUWI3?=
 =?utf-8?B?S1JmeC8yQXhwcVBFN2p2Zzg0UzcxeDdhdGN3T21LdlNWT09QYXpiQldqcWhI?=
 =?utf-8?B?cjVjcjZyVnRHa2dRbzVRK05YOEw3eUxzYzBvMVFaUGIyaXA4cHV6dSttem9z?=
 =?utf-8?B?R1o3eGY1eEQ1c0pVd29GVThNSHZvZjhTZ2k0bzNKQXV3UC9FOGdKQ0ZyMUhY?=
 =?utf-8?B?bUNkblVaZWllclBEKyt5dnp5eXJobkR4dkx2TGJOU3FjMGlxeTFzZkFUTlpu?=
 =?utf-8?B?UnRYa0NKSU12eVVhOW1TQnNacTMrY0Vja1BVenRqbVd0VDB0K0ZZS0dEWmlX?=
 =?utf-8?B?WEVpQ1pCRHdPVlJkMXFpOEN2Rk55RUVzQUM4S1ZGZS85V3BJU3JEcHl6N1lN?=
 =?utf-8?B?QnBFN29CbTRDcGc5TWlJL3cxRGhGS2VvWjhwbVA5Z0szc1QraDEreGRjVzlS?=
 =?utf-8?B?TUxmYkQ4elBiUFRpa3AvcmU2VnVGbUkrTzlMMTZTc0RBN2JPRkZac3B6Nkcr?=
 =?utf-8?B?VkJ0ODlCQXV3ZHN5YzdSemNvdm8wMDNWTDVmcUQ1czF6U1piVmkxd3ZqVWNk?=
 =?utf-8?B?cXhreVVVL0pxeFV5K3YrVlhybFR3THZNTnhLYmtYTFczY0tva1JNQVBFVEFV?=
 =?utf-8?B?YUtqSXpuY3VtaHM1QkhhamdBU3pTcmRtNmhxdkFlQ2JZUEIzek1mR29CTWor?=
 =?utf-8?B?ZDlndDc4MVZUS1Z2bkdZWTVVWWxjWTI3bXJKNHgxQWk5UzNwa2lJNFFMdDFn?=
 =?utf-8?B?RnE5TWFxWHBwdHB0VmlFZDBRbVRjWW5tY0ZkQ3BDekg1cG5TTDVXM3FBaHNT?=
 =?utf-8?B?TEszOFRvWHFQSTdjMWprVTZJb3NEbm9BQWo5Q1hGeGZiYy9idHFzdXBwM1p5?=
 =?utf-8?B?ZkREYXJ6aklGeUNTMWJJZzJITHpZdjVrV1k4eGZxSXl6NWR6WCtkKy9NMzNF?=
 =?utf-8?B?Ulp2d0xobEtFVmkzeXdaM3hwRmx4aWxjeXFGVWFoN2hVWUt6V2pXVHRwQy9t?=
 =?utf-8?B?M2RLaHJ0b2p2VGQ0UmV4NUY2WUs0NUgwTnRHZ1cydkVpNUhoT1RlZDlyc2wx?=
 =?utf-8?B?VklQNzYrUFNGSmNTanBvR3NXOEJzVjJLYkxiaEJZWFg3eEtwUUFLQ2lvbTM0?=
 =?utf-8?B?S0dkRWdFSGdQVkUwQW1FL096WDF1ZEl5OC9tYktVZWo4R1piRHVpR1g2SWtm?=
 =?utf-8?B?bnJDYVBZYm5vQXYwd0dUdjVCbWpLWlVUZEp1WDhSZm1qWHVzbHZqQkNBd3l6?=
 =?utf-8?B?SmN2OUR4LytyWDVZWXdSZUN0ZjlzdDNYTmdST0N1cTBSMXJTOGtQTi8rU3E3?=
 =?utf-8?B?dWp0MkhmS21FOEJBUDBGV1ZnOUlWallacWx5RG52NXlDUEx5aVZvSnBnV3JD?=
 =?utf-8?B?Y3RXQVJiTFB1MlRBakhXS2Q2R3Vabk1sTkd2ZmhpTnlKV3kyMkRXSHpoWDFh?=
 =?utf-8?B?RjZaY0xGcktqbGtoeXh1b085MkdsTW1qZW9uNFVZYllmNGNURG5rMXNoTW53?=
 =?utf-8?B?aVFScS9UbVh4bFVWY3ZiMURick5kOWFjelNrbWVsdVI1bDlMdlhwMCtmNEtw?=
 =?utf-8?B?ME5jaHNQOTA3Q2JDd09OcG9tZ3MzS3Vja3ZkcnNIWXhaWTZ3ZXRBMDhmQ29U?=
 =?utf-8?B?TlN2c050SnR4TGVQVkovQ1ZuQjZuVktudkZORGtkZUlNQnZ4TEhxbjFERnRu?=
 =?utf-8?B?QUI1UFFKaFhJcitlNytQbkRzTnVnemxuOE03Q21OVTdidEEyTmVUYmpMTXcw?=
 =?utf-8?B?L2VmckVhbFlvRHdpTEs1KzZwWUE0NDc1TElGaERLM0o2MzJ6VTQvR0o3WGR3?=
 =?utf-8?B?aTYveGU0cHFha3NKNkZhZFVsZU83NnBYUS9EYm1zc2M1OHZ3Tm1aU09tc1Mx?=
 =?utf-8?B?QnRKYTN6cEFNYzRyb2NwYkVURFo4V0F5K1JKMVRHa3FMWW1HUFNVSm5zZ3pP?=
 =?utf-8?B?eldDMEZmbE9SQnYybEFyeHdhMnBMUVRKNUI0LzdXWXJmWFhsSGxxTDhxeDBC?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7612452-194b-4d30-a5f3-08daf8bd81c7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 19:03:24.1510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ogZ2BqbTMImmk8En1TRfbLxd8IvQa5mqsQn0IdvkWxE9ULgZmI06g6kcpgzIV+vFN0TMH/04AypktkHJ6AnElA57p1sfXqXMk7a7+2gw4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4800
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



On 1/16/2023 9:40 AM, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Avoid race between process wakeup and tpacket_v3 block timeout.
> 
> The test waits for cfg_timeout_msec for packets to arrive. Packets
> arrive in tpacket_v3 rings, which pass packets ("frames") to the
> process in batches ("blocks"). The sk waits for req3.tp_retire_blk_tov
> msec to release a block.
> 
> Set the block timeout lower than the process waiting time, else
> the process may find that no block has been released by the time it
> scans the socket list. Convert to a ring of more than one, smaller,
> blocks with shorter timeouts. Blocks must be page aligned, so >= 64KB.
> 
> Somewhat awkward while () notation dictated by checkpatch: no empty
> braces allowed, nor statement on the same line as the condition.
> 
> Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  tools/testing/selftests/net/toeplitz.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
> index 90026a27eac0c..66f7f6568643a 100644
> --- a/tools/testing/selftests/net/toeplitz.c
> +++ b/tools/testing/selftests/net/toeplitz.c
> @@ -215,7 +215,7 @@ static char *recv_frame(const struct ring_state *ring, char *frame)
>  }
>  
>  /* A single TPACKET_V3 block can hold multiple frames */
> -static void recv_block(struct ring_state *ring)
> +static bool recv_block(struct ring_state *ring)
>  {
>  	struct tpacket_block_desc *block;
>  	char *frame;
> @@ -223,7 +223,7 @@ static void recv_block(struct ring_state *ring)
>  
>  	block = (void *)(ring->mmap + ring->idx * ring_block_sz);
>  	if (!(block->hdr.bh1.block_status & TP_STATUS_USER))
> -		return;
> +		return false;
>  
>  	frame = (char *)block;
>  	frame += block->hdr.bh1.offset_to_first_pkt;
> @@ -235,6 +235,8 @@ static void recv_block(struct ring_state *ring)
>  
>  	block->hdr.bh1.block_status = TP_STATUS_KERNEL;
>  	ring->idx = (ring->idx + 1) % ring_block_nr;
> +
> +	return true;
>  }
>  
>  /* simple test: sleep once unconditionally and then process all rings */
> @@ -245,7 +247,8 @@ static void process_rings(void)
>  	usleep(1000 * cfg_timeout_msec);
>  
>  	for (i = 0; i < num_cpus; i++)
> -		recv_block(&rings[i]);
> +		while (recv_block(&rings[i]))
> +			;

I'd rather have one of

  while (recv_block(&rings[i]));

or

  while (recv_block(&rings[i])) {}

or even (but less preferred:

  do {} (while (recv_block(&rings[i]));

instead of  this ; on its own line.

Even if this violates checkpatch attempts to catch other bad style this
is preferable to the lone ';' on its own line.

If necessary we can/should change checkpatch to allow the idiomatic
approach.
