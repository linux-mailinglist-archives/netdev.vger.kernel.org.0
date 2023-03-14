Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AE76B96FA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjCNN46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbjCNN43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:56:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7FB62320
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678802129; x=1710338129;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t3x23fFcOKzQmo0q4/8o0bAbgzUCoIa2CEX/aB/hJ8Y=;
  b=Aj1cHFSqS2k674SBnE9f2pm/KCDmxCvjT0LDhFLLc6PjGVTq41wDiE0V
   gFpyHwRLs1Bm8Vsnn3P6RpqQC+lRgCchlB/HP1e3A7bKkj6bq+qYTTwa3
   BJzpZVMKW/O26WyFAgXP8de2Xbk/Btndjyj1llY+SoEk0y8o+eqn1Vdzn
   A/EpU0wDp3X7QchjV/yNaUu0XjVy0PNBAMqdpb0vIc5WF5NVuB/lB+gKd
   8Q8nsyQfxyJ2+iLcuPQKuncXodZfvDa/8B8/8QeBbSge3lkl5zfLvjRN/
   bHypUTV0j2HwKDfpuMjP/416JBU+zeDb3xF0NmS0YHTenIb28TWw6Blag
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="337455434"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="337455434"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 06:55:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="711522588"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="711522588"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 14 Mar 2023 06:55:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 06:55:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 06:55:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 06:55:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azVw9j9TEjTy0rHAxA9OhcS/Bj7jQ1+PadU6awbln8+pZtX0d/WzwgXhVoT/0vwXZlklha2iwiyjqTwVqOhzJGUqQsof/SzSZfWxW6WrpdLwRp9ucE1zaX/tgb/DkQxGrb1tecrMCHr4k4+oSN2l5vTIVn/XPxQjubw2i7bC0C6iJ1OEThnwKKvBzFqQ3fTaHWJz86HCDPRbrJqZq5qpJZ/8zUzJTXBKlK1i+RlcuQ7tbGEXZBna5tzasQfWO1o8WICgzIRxQSRTJjmdHQ7JyGAhc1o5Vm4LGRehgIDje/1EyaT1RmRlYbsac7u1L+xH/D2DK4RuSuUrsEFdU9JrVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mwhuhxJ7GjUFnVduUm47qaQPM8n3iq808ia/izxnBM=;
 b=jX72uBpcU4E++JG8/PrIuY/G9rvdIrifJGosYvai0J9PeXSy9Eev40daphED3nCbs5M8cHl7tAsB78TKyL6BTRPe3axrRDF8sQ0c84GtScpyhZ/D2q0D8EI/ISZS1zwRbUKMc8O3MBPyKdkXVn9vfH/5vzqpsR1EgTba4B6mkGgUxs1wG8iY76J2YzpOGcM8+1PfFAgrWkfxY9xYbUFhSrIvUFlBucAOzAM5YEM+3f38z2LwTUlDYh98Z15Q7/xa4/2S6ZcJVY2RCKfC3c5m8rABzDei0UXUKdmqPW23P+/ccfsQXXbYLPplbsENtDOIDuKU+GF/Ogy81Wto9xgdHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB5374.namprd11.prod.outlook.com (2603:10b6:5:395::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 13:55:25 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 13:55:25 +0000
Message-ID: <f0c898f5-f4cb-34dc-91f6-a83106c52c0e@intel.com>
Date:   Tue, 14 Mar 2023 14:54:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [Intel-wired-lan] [PATCH net v1 1/2] ice: fix W=1 headers
 mismatch
Content-Language: en-US
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20230313203608.1680781-1-jesse.brandeburg@intel.com>
 <20230313203608.1680781-2-jesse.brandeburg@intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230313203608.1680781-2-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c2ecacd-933b-48e0-0dfa-08db2493c2ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vlsU6fHLDdfQwFqP6H2SItq7vjNsBWB9lmEqP3SXGLhnrlG6PdPEUUQXYha9xoOZFyZBD/4DqlNiV35tNwZVGVxy0F1zgNPVhK6rP3xUH0syRGxSHf6yfNXHSVPuW0EFPnf1vq8RJeV0QY+VC7SeTiNe7KEU1Yvg/CT13GpzSCWeFkbxOT5YNUHbeVplFqKKysBXZgvocrBdCF7jyT635gvIq9C+9AGaBl9Sjn8X8nF3GbKzw+SQT6I/bt+X8zfJ3wUf7zyeV1/O0ymRqsnFfejz+McDcwD1HGBUScr2urzwr4xcnnHgJbxz1zEixI+Zd5CdT/idhWf19WCo6s1xZqlRXPPyXwlYOFLshOAOr7MUlz3CfPpcCwd4vRFsVUD/M0LOQ7IPbRjfokpeXcl6aF98+tukKCsxcSt2xjb9A4v3uLlOXXU/+onWK7oA6nYYsbI6LAsFhlq78yUMt3Jnfk7pAcglPudYkjHzrNbZtwt5p3TC/y5r6S0mdBDQRV19EJmhV+6Rh88SP1cwcxHBBp8Div1jXDZzKieDtZ8nBGHI+vlxicGxlVsRLVghzaG8xlXMzYLUBmPmggCKM72DsaC0pMp/c0+iWCHaYG/BwyKtwk5OUNKJNZUkh7HoM1ccB8PnbS0PaVCuk8JRVsAZeczRsdTSoEfnVZHDq+8yzYvvalHhcE+rflMuyddISUxiD3vsCSqvZRmZyAEWcGc0fbI0Q7wldDa4hLCCc36njao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199018)(36756003)(316002)(6636002)(37006003)(6486002)(478600001)(5660300002)(6862004)(2906002)(8936002)(4326008)(8676002)(66556008)(66476007)(66946007)(41300700001)(82960400001)(86362001)(38100700002)(31696002)(186003)(2616005)(6666004)(6506007)(6512007)(26005)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnJnUlJadkdIVXN5Mnc1T0R1YVJLZ0hub280Z0NsUjNWd2RpaG1DNnJOOEZi?=
 =?utf-8?B?ZFZ6TmlSUWVsOWlDNUpEY0FZS2U3V0NzdFMxVnVMV1BJdWJ6bWhIbHloYnh3?=
 =?utf-8?B?SHJ3OU1XNGFCY3MyR3RIV2haU1pDZm5JUm1Fc0dSZzlWVlJNK0Uxb2lUbnI1?=
 =?utf-8?B?aTE0c2M3SjcyRTJWdUtFNC9TZnJTSGkvSU4wK1ZXNW42YXZkVXREdlUyc0dj?=
 =?utf-8?B?NlJlcnpEZGV2Y3pueVk0THdyVjltaUdzczNQMzFXRGZCUlVhL3NLYWJ3eE5i?=
 =?utf-8?B?blhiSVkxRWhqVVVkbTllRFBTR0xrT0QxZVY0bm1Pa2pLd2x2N05sdlpGY3dy?=
 =?utf-8?B?VkRVcGNXb2plaXI1Uno1WDFEaHRRcjFWRlFhU21GZWVVY1VHcDZ2Vk1VU00z?=
 =?utf-8?B?RmVtNUQvK25JRFZac3N4OUg3M3ZBd2FJV21WSm5mSDNWSWtaRmUzaGxHcDJx?=
 =?utf-8?B?SkJ2bVRoSzZ2Sk43MEgvUlhMYzAraFAzeG5wRFFucjZqWkcwN0ZzNUhUK25o?=
 =?utf-8?B?bk5Ndm4xS3l6UFNhQjZBdDA3K1V2elcwc0VXcXBsMGdiR0ovcnpTbnhjRkln?=
 =?utf-8?B?UmNkZ0hnalJtMDdKOU0zalZ4T2d5emFyYnpodTVqanR0dkVUd0lmYzF1ekRm?=
 =?utf-8?B?bkFUOUtaNFJ2YnkvbTlyYjlZWURZNmlsdHFlUHdJbVdISnVUOFByRm5taDRR?=
 =?utf-8?B?bjZUb3NjdjFPeHQyV2V4cDJGdTRwVUQwMVZLcEdIakwvRWFvWlRUQkRWMDZG?=
 =?utf-8?B?Ny9iTXF3L1Z2Wkl5OS9mTTZrNlNDVzNxbmxrVnljNm5vdzZXTjlOTHJVNGpR?=
 =?utf-8?B?NHJ2aGJObFBWK2s2cDJYRFl5VitzZWhCeEZMbExUVE9ZNm92alRibHNvY2VU?=
 =?utf-8?B?SVh1YVc0Z0FFZ0ZxdDA1ZitIT0t4MFIrcHJBa1h1QnoxdW5yUnBOYnVZTzRk?=
 =?utf-8?B?YVpyaFY2Y3JNbzhOMHVoRW1hdGhDMUpraHN4blM4T1BHT09Oa1dmUHFYVEJX?=
 =?utf-8?B?amovakVrckljVjRBdjFlME1GS3JtWk1NSnB5TG1DSVkzZ3VobEN5ZGFhUW9M?=
 =?utf-8?B?UnQ0TVEvWkNlUVVJSXZpelRkZnpNQ3ZPY3RHaXQ4TUo2MWZwdWRoSDMydDhQ?=
 =?utf-8?B?T3gwbUs0K2xJcWhneGREUExaWEZVSHBnQkJ0NUlJUVF3c1U0Mk4ycjdCRFBB?=
 =?utf-8?B?SnU4Vm5odGg5Qnc4NmppZS9qR3ZVTnNFVEtyRXd4bEQvZ0t1c1lyNEtVL0FW?=
 =?utf-8?B?MERlK1c4a3h1QmxJL0hRWm45SmlqbTg3d2pCM3g2d1F3N1QrS1NJVTFWcW9a?=
 =?utf-8?B?RjVNQUY0ZHdra1FRMlZsazJyc2FjZzUzYTlhL3Z3dWtWM1ZrdXdpUGdzeDJp?=
 =?utf-8?B?Rm5iK2ZrWHlrMXYzY0NMNTV2TEZ5ZU4yMWpmbHc5c3R0Vy9MVFdHbW1BLzNp?=
 =?utf-8?B?WkhDUkwvQkF5TVZwZkxwZXF5Yyt2TVZHN1R6Wmtjdm42MzNyRGY1SGhFTWwz?=
 =?utf-8?B?YzVraGZxaCtram1WdmtkNjVyYXVZakxQaGNBaEE4ZFhQNVNCWUpHcmxHUjlL?=
 =?utf-8?B?a1hIMW9MdGhGQmNoU3dlZDArUklqY0gvVW1YR2JPRHJ6Uzl4SmdOUVl4Wjdp?=
 =?utf-8?B?cHdxbGwxcGJSOXRaTXZsdjVuQXZ3UE9QUWkvZDZlSk5lS04wSFRJVW1lKzZw?=
 =?utf-8?B?bjBIeXhyWjQyZFVVdENGNU9DUXZvR1d5ME10VkN0MVQ0d2Q4SGFacmxtYVBa?=
 =?utf-8?B?Z0c1NFFhenRjR3haRzVoVTNDVktLTGVrOW5id1RrZXdXRGNobzhvcUlYWXR2?=
 =?utf-8?B?N1RxN3ZIQzUyb2E2d2VacXVqbU9RNnJnbWt5VWIyQkpVZWtpZ3hOWlJSR2N4?=
 =?utf-8?B?ODhRRlo2amh2aWd4czcyMml5a1ZXeWhmSXdCbXdMK3NJOHpLbkZLUzAvU1A2?=
 =?utf-8?B?am44UjVPNVViUGhPWlpyL0FNa2t2SGppMm1zaDhXM1ZsZ2NWU2E2S254Vm1w?=
 =?utf-8?B?eHo2dzc3NUI4MDBOcXY4VE1WUnJ3UDFkYjFUdi9sVHprejNVeU9wODRUbGdi?=
 =?utf-8?B?SjhLRHQvREhYY3I5VmVqZGlEM2J3eUdMSGY3alIxajNNOHlaVERLUHZORyto?=
 =?utf-8?B?YXlZVStMQk5LK2Y5MjVTMnQ2d1I1djBpNzRnY0Q4aXY0ZWlPbW9rQ3djQk54?=
 =?utf-8?Q?bUv31TfqBw0Cg5XxCy5UDgU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2ecacd-933b-48e0-0dfa-08db2493c2ac
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 13:55:25.0405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2AM9BkKaa3M57jTc3ptomJ+kQA7ceP0CWCf6z+8MQQu46awp8oXvfKGfAPbRFlSwIcElIFBgTowcme877cmujb7EH5MinFxcU/uQDV/pys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5374
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

From: Brandeburg, Jesse <jesse.brandeburg@intel.com>
Date: Mon, 13 Mar 2023 13:36:07 -0700

> make modules W=1 returns:
> .../ice/ice_txrx_lib.c:448: warning: Function parameter or member 'first_idx' not described in 'ice_finalize_xdp_rx'
> .../ice/ice_txrx.c:948: warning: Function parameter or member 'ntc' not described in 'ice_get_rx_buf'
> .../ice/ice_txrx.c:1038: warning: Excess function parameter 'rx_buf' description in 'ice_construct_skb'
> 
> Fix these warnings by adding and deleting the deviant arguments.
> 
> Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
> Fixes: d7956d81f150 ("ice: Pull out next_to_clean bump out of ice_put_rx_buf()")
> CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 2 +-
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index dfd22862e926..21c1e1bb214a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -938,6 +938,7 @@ ice_reuse_rx_page(struct ice_rx_ring *rx_ring, struct ice_rx_buf *old_buf)
>   * ice_get_rx_buf - Fetch Rx buffer and synchronize data for use
>   * @rx_ring: Rx descriptor ring to transact packets on
>   * @size: size of buffer to add to skb
> + * @ntc: index of next to clean element
>   *
>   * This function will pull an Rx buffer from the ring and synchronize it
>   * for use by the CPU.
> @@ -1026,7 +1027,6 @@ ice_build_skb(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
>  /**
>   * ice_construct_skb - Allocate skb and populate it
>   * @rx_ring: Rx descriptor ring to transact packets on
> - * @rx_buf: Rx buffer to pull data from
>   * @xdp: xdp_buff pointing to the data
>   *
>   * This function allocates an skb. It then populates it with the page
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> index 7bc5aa340c7d..c8322fb6f2b3 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> @@ -438,6 +438,7 @@ int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring,
>   * ice_finalize_xdp_rx - Bump XDP Tx tail and/or flush redirect map
>   * @xdp_ring: XDP ring
>   * @xdp_res: Result of the receive batch
> + * @first_idx: index to write from caller
>   *
>   * This function bumps XDP Tx tail and/or flush redirect map, and
>   * should be called when a batch of packets has been processed in the

How is Rx hotpath related to "ice_switch" O_o :D Those are 2 separate
fixes or at least the cover shouldn't say they belong to one topic.

Thanks,
Olek
