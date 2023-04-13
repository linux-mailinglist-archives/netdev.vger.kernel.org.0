Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD396E1524
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjDMT0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjDMT0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:26:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382F55B9A
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681413960; x=1712949960;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p9/2CU0g4kYuhjB21kJRSCynVBrAY3W3AEFceE4Z3EM=;
  b=Q6omB7Xf4090ZuLJWSQk7yMRW6hK9wR/+vwyegYxPsklg+KfI65u5Zzz
   It2S75AVqFDl5hUEbQ9JObFqMvcpJ7MYNhbj8Nn1EjpTt8BqwYODmso6u
   5TShIo40kjVbmtkMTs5yO9MZrT7vn8AmGiG94w9vMkrrjFDZBk76aSqVS
   tLpq2RvvXaUFGRyOiqcTZ8+A/9BuGz/jzKacEEeSeBT4jJVJ8LEnQmBgz
   GEvr6YHwuqbBPRxj+CiwdojNYSGKb53DJmwsrk8UpHgzQFA4E/tCy2I4H
   YhJqDNFkUIGQx2PiACON0AQDwBwq3YtTVYl7XHflYIlCDDEGM4v3UsvBt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="344279244"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="344279244"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 12:25:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="720000541"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="720000541"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2023 12:25:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 12:25:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 12:25:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 12:25:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMn12oebBQXW6XKdBfAGNh2DgUnoxGKUB/kg3YRbXsUub0QmBtRWZbniEzuhVxJ30WH/ExqrF0Pw6o8GGRFjrXQIyt5GmmAoEZZsI8l7+HcO9IfmU8Qb3dy6HeOLbkC+MbLtqMauUDmwnK1apzgSnkLpoNEsPxbb+rx/X9ZAPcyCbPXsvsXjxW+r42Kst6CpwoZ8FI9hbkfZpWnJSjhls+h4vu0NX0cRDY7QhYIy+HGP/g2DhmNbzG+i9Zf4ethrSRyduomu6ACXJYezJzZZ5g+81AoVdoSQGE2zx1lbxhUVUT8gnlc2Cyzog5iGZJ3x1BFNEMD+Nf6asjtRb1XHrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Tm0xdCVXfpxwcyJ8V9AZ66iSFIj+J+BEU7juaxs5h8=;
 b=AVvna81ubejDkAJrTkjRHjWwcQmfOcbmWG5giuOGW5wXj76PlsBntVIFes91Ni8pU/ezMm18TCPfXVKRDx6905K3L655Y7Hb82n0KbWc7ok8dG31ZbDeTvkBCTCjjUuzTUlnS+VBpQBYjbAh/p380NfpM+8qaE4g4Sm0TVZElT1n0yB8I/XFSeX5Ukldykc/ywmWXlZeAZs8b2taI0cdIyUTYm7fFT4TmVNPHAAkgqD2GZCGEjd2PP5p1qqj418GeUQVj+Xg20BaxVNWExsGJ9M21MggqMcIh26OrFO/pcUSrKCoIFL6uwwMDNIW1NP+7zl6mEUMAPRxKpq6uk2prA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW6PR11MB8365.namprd11.prod.outlook.com (2603:10b6:303:240::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Thu, 13 Apr
 2023 19:25:52 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 19:25:52 +0000
Message-ID: <ac076400-e086-15be-47db-59556413094f@intel.com>
Date:   Thu, 13 Apr 2023 12:25:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 3/3] r8169: use new macro
 netif_subqueue_completed_wake in the tx cleanup path
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
 <3ef7166d-ce47-e24c-1df4-bb76a39c96c3@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <3ef7166d-ce47-e24c-1df4-bb76a39c96c3@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0248.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::13) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW6PR11MB8365:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f27ba7b-a326-4b1f-52be-08db3c54e4ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yDWhscCVk3lmXV9p6yd7j9th6ZnNFlraY4NM6GldyM13e28HOTz9zU81swjTQEus06CpFSIRdL8tMrm4ND/xncCEGCsh9sveXJO+RUwYsXzrZhzdPdHtwI7IMjqiDQkmIoK+yRjeRyuq/gN79oozAdOZCaCK0as3cPWpbCpQ+lL1JQcDGcqynLqDwtaC4RkBbCSQ0r15/klbTdqHI2VdBigMaiG9aazA9/+Vc6L0TWY2PfX0P3wkvus45kcSrsprJ+c2U1xfU//2msRbPy8gYIGxWA1icWLBVRM9xRhVVkUohjKMmC03bq4DSaLw/nFxFFTCO1EPfao/oey3TUsnrGhuSBsNJt6f2ny42Unl7IQ55c6VPoP2P035k4DhVW6m1oN1j+nfNzUnsN+rGd5gIZEJVSUN/CZvH8ftytlbRRA4b/gj5ALoxpAELqHXdeCLdgnD/FNOOg3zYLPA1HJMkS0bJy+MjQQ3kYoP0npnuYepHO1hA2icneSsIzcRSlr9CDsU5RqdDlhD/EYKbCy8LmJZmLIyxXcNJh6zvixZeJO2TifMjC2TVNpvBFoB5aIEEbj3s+D6GL5lwUZ9xcDIrTX9YdgUBhSXrzXbMWTdPNJ+G9U6Fl8AdhK676Db7V3lv2s/b5Kx12XXboTb4EpmQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199021)(31686004)(82960400001)(6512007)(6506007)(53546011)(4326008)(6486002)(86362001)(5660300002)(31696002)(8676002)(36756003)(316002)(8936002)(41300700001)(110136005)(478600001)(66476007)(66946007)(66556008)(2906002)(83380400001)(38100700002)(26005)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QW02eE5CRTdzOVRUenk2cElGSmRDbE9QZGsreXcrK2RYdmh3aHo5OGFaNm1B?=
 =?utf-8?B?VTZDTklnbHk4dEZnY0xrY1k0SkVMRTE2QjVaR3cxWW9hMlNyS0NON3RaYjlB?=
 =?utf-8?B?Z21qZFdpUEl2c2NqdzI0N2RFY2tHTXQ0ajBDLzJNKzQrT2ZROVFWZWpPNGxI?=
 =?utf-8?B?YTVFTzRWK1VwWmNsbEF1UXFuQ3JmSXR0cVM2V2dlK1hlV056RnRmNUtZZ21P?=
 =?utf-8?B?L0pWcGo3ZGR1d0d3UDBnVUhhU1BHVHpWa29EVzZSUi96SUQ4ZUN0Znl1UEMv?=
 =?utf-8?B?NVRxMWJxSTk4OU5hMWlWUElQZnlhWXRTUUlkT3kyTUduSC9jL1RxUkZFRXd4?=
 =?utf-8?B?SElrbFR6QW9IK1d4SHV2ZVBmbDVjNHdYN2xSSHJVQ3JaMHhJTzBZZ0VNS05p?=
 =?utf-8?B?N3lTREhYOC9rWHZMemVFdENQN3Bvb1ZaNnh6M3F3bzlvcW1EOFZPR3RMRXF4?=
 =?utf-8?B?SGpMeXdHZWEyREE3bTR2S2FYZ1RuM1ZqMVJNNXZaaU1heGFmcDhuQkJjTkhY?=
 =?utf-8?B?VGNLU2lrd2I4WGdrcWd0WEZaenJFSHJWcTUvajhSN2FZVnl2VmJJTkduRHBz?=
 =?utf-8?B?MkF4bSswcWNjYURCcDl0WlNNSmhmalB6WmwrR1dZaDQ0SVlHUnp6MWIzZkVp?=
 =?utf-8?B?UXFwVlBWbk9yY29EZzN3akJ6ck5lY2tGMGdjK2ZFL3ZvS1RLUDF1dVVQNm9E?=
 =?utf-8?B?eTdjdEIwa014eWxiWE13MkVzRVNGcUltM3M3bGtyNnEyOEVWa2pJQjJZMUgx?=
 =?utf-8?B?cVdCVjZGZmdGTy9mS0JxakRzMXlFZWwxczRlb1Vjb1VQT3BHaDRkZ0xrUVUx?=
 =?utf-8?B?MEhHT2VPU0ZUNjh5ZmUvOVlVWHZHd2l5S25lSExTNFJFNFNTUEUrcUJ5Qk5i?=
 =?utf-8?B?R3NVcWhTT3FSQmNwcXlTVVkvYStrM0RPUzEzZXVMZjZvcWYwcncvOVIvMDJR?=
 =?utf-8?B?dnlLN05VYnk1dVhGcFE0ZzdEVG8vWVVybzdqZVoxb3Y4RXBnZlZlMmMzY1B5?=
 =?utf-8?B?VTl5QmZXM1pLNk1rZDQ1RC9DYjA5ZWNZUW0zc0RUOGdQaWtKZGxDTGhLWkY0?=
 =?utf-8?B?cUYvMFI0eGFLQlFGbUxXMGZDN2huUHoyb0w5ZlVGTUJFeUxQN1IrQXp0ckFO?=
 =?utf-8?B?UExPbzV1TTJWSTVuQll0M3A4MzcwQjE5aG1zdUdFOUFqNlMvVmVvb0swd3N5?=
 =?utf-8?B?eGFyUXQ3NUJLelFyY2ZEV0FGU2l0Y0F3b3N1YlVnbUQ3NS85dTZOaERwS2hW?=
 =?utf-8?B?MWFUTFpRSWNDMjU2dXFXVHVmRDJESjEwbG9TQlVXVFFTek4yWm85dytlNGxO?=
 =?utf-8?B?VkxONngwMHVuUlZ6ZVpqMU9DcUFqOStFVnRTSjFKQmxlVkxiWFZZSXpXQnR0?=
 =?utf-8?B?OWtzZjduRDgzL2RoU3ZnMUlYOTNFZ05hQWVNb21kL0JQUzBMRXFZUmVWSFY0?=
 =?utf-8?B?cGVObzBYQjRvUFZSZ21WNWhaL2lNOEFuVWFHaE9pY1MzU2xNNFBUcS90ZUhw?=
 =?utf-8?B?bU9CckwzVGo1MEtndmZNOTNMQUJubmNwMkcrRUlnSyszSHNpbm9LR2RQNExZ?=
 =?utf-8?B?YkhEQUhVbHd6blBPMmpHd2hFekZ6ekZGa3BjWXNqTEJmOUI0RWFUZWg2QTFn?=
 =?utf-8?B?UkhwTVJvbHE1OFNOTjdqOWg2bDBmazVDOTNxRFpxNXBvM05FSUw4aWlXY1pV?=
 =?utf-8?B?UEU4V2FjclFqZm1sSysrdWVUci9ZVUxyRlh2M25palk0d2lWNHVzWVllK2RJ?=
 =?utf-8?B?TWlWZDh0eXF6MmdYWUpBVG0xcnVPa2RsU3hjWHlmNjV1MGw4SkNIQzVxWHZl?=
 =?utf-8?B?d2VtNTBWTFE2aDFCYkdNWnNMYzZLV2xhU0RIeEhjT0gxL0lkMjZBN3JXSCtG?=
 =?utf-8?B?ZTJVVjczS1FMd3Q5TEV5QnVXcFVWeXhJcXpjM04wM0daTmZMd2FYaVNERkNE?=
 =?utf-8?B?Y1FGWGRDZ1JTL2hIdURzT2tSa0ExcGJBTHNQTFlVelIwSWNOb0NrOVdTWmZH?=
 =?utf-8?B?Y1d4QjBVenNRdk1oS0hBT2FhZm9rK3pRMmtwR0hVUzhCajI3ZE5DYzRCS2xs?=
 =?utf-8?B?WXdpZ1YyNWNIOVpHN2dCWXBHdURXOEwxUFRhWGFzNVoxVmg4S01LQzJ5K1kz?=
 =?utf-8?B?cFY2dWdaaGtQUEI2bkVBZUNsSkRxMHcyNEtHZDFUNnJDQ2o4TkpQNmZjTDEr?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f27ba7b-a326-4b1f-52be-08db3c54e4ce
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 19:25:51.8912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AOnoIIm0JPDrBtqAOHZg0XD3LBqgWpqkUknUHoFrLLPII0l4pcjHoumxmVe7Kg3C/GSqCFliswwl4da2azYeMKEzNFc6r2/JGRih6vid3rM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8365
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 12:16 PM, Heiner Kallweit wrote:
> Use new net core macro netif_subqueue_completed_wake to simplify
> the code of the tx cleanup path.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 3f0b78fd9..5cfdb60ab 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4372,20 +4372,12 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>  	}
>  
>  	if (tp->dirty_tx != dirty_tx) {
> -		netdev_completed_queue(dev, pkts_compl, bytes_compl);
>  		dev_sw_netstats_tx_add(dev, pkts_compl, bytes_compl);
> +		WRITE_ONCE(tp->dirty_tx, dirty_tx);
>  
> -		/* Sync with rtl8169_start_xmit:
> -		 * - publish dirty_tx ring index (write barrier)
> -		 * - refresh cur_tx ring index and queue status (read barrier)
> -		 * May the current thread miss the stopped queue condition,
> -		 * a racing xmit thread can only have a right view of the
> -		 * ring status.
> -		 */
> -		smp_store_mb(tp->dirty_tx, dirty_tx);


We used to use a smp_store_mb here, but now its safe to just WRITE_ONCE?
Assuming that's correct:

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> -		if (netif_queue_stopped(dev) &&
> -		    rtl_tx_slots_avail(tp) >= R8169_TX_START_THRS)
> -			netif_wake_queue(dev);
> +		netif_subqueue_completed_wake(dev, 0, pkts_compl, bytes_compl,
> +					      rtl_tx_slots_avail(tp),
> +					      R8169_TX_START_THRS);
>  		/*
>  		 * 8168 hack: TxPoll requests are lost when the Tx packets are
>  		 * too close. Let's kick an extra TxPoll request when a burst
