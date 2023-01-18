Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D0F672A84
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjARVbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjARVbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:31:11 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A5618ABC
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674077470; x=1705613470;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l+J4kK9w+XYdxtaJfKQGVpMulpaM5n9gwK4EfdUMc/4=;
  b=mu7QUP83g0QRKfxXI48Jv8AfOVPBjyEyWi+DY3e96p9+xQ4afmx2JxfW
   9VSx0V7NCBKFy9ZSb58QTmi4o3EZ8nyhGOQXxDxtMfO2dwFHTknybgINB
   l+u1c40E+i4eDc+BJ7/9qk4cLdxrYe5T99L/SLPmfiONB0W1q1xrMCNds
   bqQE3/4+klrk0iqO8Vb66OqZSbCy2+WgsVtqnwd5FcttENfx7P8AXMatP
   lMztFe7OUuSJ7anFcAenWiMRuwFtfA17v5Wb5yWosjXD2cwO2gd5MAkQW
   W6qxwuLPGYvRB8x8uBZL6qmdsSuWu4zEl52t+sZrfJzyFoMd6/hqcAj16
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="312982481"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="312982481"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:31:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="833751419"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="833751419"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 18 Jan 2023 13:31:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:31:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:31:09 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:31:09 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:31:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dd7Zc/smyklZz4A9EUtwdXnlLydI9cDOjMdmZvNUvxcsVuq8wQopTWJPXQ+zLJJFR5ymY1qbpAXCEjExKEkTAI9LtPuHZXRsE/d8/5cghrfC0o+c6o5Uj8wFSLBRY64MybFT/emfIQMH+i2PeKrX0ats/LerqMuz1zN8OlDT3oRHiVOha9EdgDdOybrlpLICRnMzxMpZv6M18GfgWgkWIv7UqGXADXFgaWOXxaKtV+pn2AnOgXtZn6SdgGOe4YIpqIWobn+Tps11Jz0oK6wca35QmFoPJ58JwXHBx4jIdHNn0Bg9R/FW29bQPZ9BRe4IA4hs5Mbp9j3SZm/5YnOEgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7Kbni0kER7U9jlsUIeMRw+Kdp2d43+Aj69Ubzw4+g4=;
 b=h1qPxDEOeEEl8O+c8UeCxySR8OYsYXSBT4gJv7KEGj2pDaEJ7gvYh/1bQo5dIDFctW4spSRDMDBvoLYG7GoTTt+mAKzLk/2u1i0+VE4XQq4vF4JQ+qHEm/0lHZOU9BozCbQPd4Ci2lrZc2J19SF6Li0IuMJi7svprg9JjrZ3v0YRDJrI8uUyldosmgxSoQeNciSnK0n0U4WXCw+SXWVwnTSTHZOrWvhqMJfafZMvG1hDc/04QvcKIdSC7U3ZVXAIcilqaVrDyK4wOtv/IeAEp0DTebtFzboY6sKV8cagt8HI99TYkiJkoTPS5ABhdW6owqxU/UygN+4eptbxYM4zcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB6061.namprd11.prod.outlook.com (2603:10b6:8:74::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Wed, 18 Jan 2023 21:31:05 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:31:05 +0000
Message-ID: <9ffa2a9b-ddd1-afa1-273d-6c303fcedcfb@intel.com>
Date:   Wed, 18 Jan 2023 13:31:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 01/15] net/mlx5e: Suppress Send WQEBB room warning for
 PAGE_SIZE >= 16KB
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        "kernel test robot" <lkp@intel.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-2-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-2-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: 0588908e-a914-4b00-8de4-08daf99b4dca
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iylEEbb+rvrvYDY5mXIu0bQR7HF/ANpo+Vjzk87g2QMl3t2I5s6JGC2+FqLvhYjfni0/BoFocjPUpguNNpakaMiA2r/YtimZ0MheU78VWot+MMHPAmXIwHkJWcRHXnx5Mwi/U7h+HnOj9iC46b2oI1ijN/IWtOF+ZD6+7BdDiBleZIfuFMRMEvVdJMfuLZ7pIZEhdcwRa4zmrGGDdsTaEWJ5H47xh6LcOcnam5cIZ8nbyc+6owm6TbesCZUEkn7dI33UXHWqQF+YdQajFKJvHDrqZzIbLHrPy1nU+Xi8SFMvnSaYbwxJ7XzeaElTA/pAA5dCl1jP7pewnwXHJ62QZIYKx02YGlrdB4NiNc88RPbyrTlJO4dKgj1glDACMcczSlIIIYQcIGH2NuYNs1CdKOQ+toINNOhIa4rEtGfnXKfJD9RtUX6dDXIVXngVhSPkE4Qoc6VVHVH/rDVMyx/6BsHPKyFqEJD//woMoDKEThGB4zti1cPk8IsXxQqxBh0sbbYpcJVgU5YVKW/7f0NhZaanDbPvGBnSnGzRGbrtw1kpQEN6WYZexiQCxn9GaACzgVf0nDZ1v7YgSGfD6cJtG8+BN3XjkgL/ABZtruvOZjqAaHyvG/sVVJk//ikRpJBMqiEo+aUlKzkFnhQsvB/u2dPSb/+B01I4NtQSQkrLq3odQq0/Kii5araP0DPNCDZEpltqg6eFfMsQgUwTm/nCjXE0lZ99MZlE5NHU/2OJL50=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(346002)(39860400002)(136003)(451199015)(31686004)(36756003)(4326008)(2906002)(66556008)(66476007)(8676002)(66946007)(8936002)(5660300002)(38100700002)(82960400001)(83380400001)(31696002)(107886003)(6666004)(54906003)(110136005)(478600001)(86362001)(316002)(41300700001)(6512007)(53546011)(2616005)(6486002)(186003)(26005)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVh4VGV2aDErWVNHTVJCSkI3clk5bEF0WVNjMUJZc2F2eHJVMUFrUnlNNU1R?=
 =?utf-8?B?QUYzS21nN1U4N3VDVXdCQVIwVE1Cd05jVkY4UUJ3VHhETWJIMmFQV3R1M0xk?=
 =?utf-8?B?dGhCVXRSOWNaMlc0MGVEMWd5MGdzWWJ5R1RxL0xTYlB1NW1TM0I2TU5rTVVX?=
 =?utf-8?B?Y2g0L0gzNjl6d09wVUgxWkRWSFdIRVo2NlJMR1FMeUdueHJVYVFqSnZrQUg4?=
 =?utf-8?B?QWYyRUpGeXY3RzBtaVRkUWVrUmtPZGV3aUtRdDVKSys5eTV2Mk4rZ1dtL2dk?=
 =?utf-8?B?RTd2bERsUmNTWHk3dC9yeUs1QWx1aXZvM1dZbHlndWFaa2xJb3pXbGNQN0l0?=
 =?utf-8?B?a0gxNUQxa09ISnNBYmJRaThuVnZOR3lLbk9BK2xabXVuZGhXZGh1bC9tcHdl?=
 =?utf-8?B?WDY5ZE5zakRXNDNuWFFLNzl1aUlaejRHaGYxVVI4WmJUK3ZCcXJja2ZRWDQz?=
 =?utf-8?B?aXlXNTBUdUhPOGxsR1o2TTVGY0tDYkFrTnRMT29nR0dPK3QvalhIMld2SDV1?=
 =?utf-8?B?SUFIWWxidXBlN1dOWmpGNE5FRHkyNkZqcHFzZUtLTHhJdTI5dXdIQlVGay9Q?=
 =?utf-8?B?Vnk2WWk4Wm1ZRGZreUdFaU1uUkJsb0cxcDA2bWRac01tUXVTQlZKME1hRjk2?=
 =?utf-8?B?KzMzdHhuYmpUSVRkdVltUmMvTFdwYXJ6cmdOcVhoY0Y3WFlxNzlWNHVGWUIx?=
 =?utf-8?B?UUExOFBVbkM4NUhpWkpKbkkxOWFYdWNOY0U3Wkp1S3VnQVlReUpSR3JCSjZa?=
 =?utf-8?B?T0x4dGl0MExkQVkwRVZFMUZ4Qk9iWFREVkd2ekM2QkZFeEdrL2VuL2Q1Z1pE?=
 =?utf-8?B?NVNNRUxLcXpnMSttWFh2Zk1YdHZVa2JZaERiNjVhZUhPZ2gvUmFIMXJseWky?=
 =?utf-8?B?emVmT0dQSDdJRFkyN3M2Njh3MFlqdXY5alhCendjeUxUdGd0T3J3ZHo0aE5z?=
 =?utf-8?B?ckw1YUpLQnY1MG1mTkl6amtaY0JhSng5SDVyUFZGZEhhemoxWmFXcml3UWNV?=
 =?utf-8?B?T1oxTjJEejEveC9XQ2RwR01lb1ZVZVBlYkJRSXQ0Zkp0eXV1ZGVSaGNzS0o4?=
 =?utf-8?B?MHEzblFvb3Z0VHhxeFJacmpnN093dFZ5eDhzVCtkZ3RHSTdZRnJlRitock5q?=
 =?utf-8?B?V0xPYitkbVhLcVQvOG1xeStyTVpKaGpsTnFVbWlPY3NaRUhsVXBvenE2ZFc5?=
 =?utf-8?B?aXdzWVpCbnN6WnFPVkhqTHZpcU1QTnkxRENZUW9PYS9aQkdrYkZKL2xPTlpP?=
 =?utf-8?B?Mzl3YUxUK0dieXgyZHFVRDg2QndMQnozL0RpSUk5dUtpa1pPMVVMUkU4RzBE?=
 =?utf-8?B?TzJKNHBSN1NqMkhFWmpKZTFpUmlnT1BmaExsblVFVnV6YStodFBrZm0xQ1pl?=
 =?utf-8?B?MngvSUZHbVBwNkxHbHo1UVJVSVBTT2pyWlpzTWVkTGp1TlhtNUtIMDhZczNk?=
 =?utf-8?B?bCtBQ2E3WWgxdDgzMDFqNlM5Q3FZSkVsaVAwY1haZ3lSdUs2ZTNYRkpQR0ZJ?=
 =?utf-8?B?d3U3MlVjK28waXNLS1RFT05xMFZIWHpmNVZ6K2x5by9rRitpWFFZMmkvSG82?=
 =?utf-8?B?ZlJKbFN3VlIzNUNLWWl2MlBZL2lrUG1KcWpjNng1cW1UZmJ5dzZKSXJqL3p3?=
 =?utf-8?B?UDJUSnVzdCt3c1YwdGlWbHhLU2EvMVB6Tkc2N2tpYm0vTUxWZjdhZEg0UGRZ?=
 =?utf-8?B?ZHhYRCtCZFdqdXpKTGFRVnMzRE5VWEluZkQ3bWFlNEl6RzZIRUZpYnAyYkUy?=
 =?utf-8?B?ZmE2cUhITTZVS005VUpDa3J1Zzd0NFhSVEFaeG9yU2dQOWUzUVp0NnNWYUJQ?=
 =?utf-8?B?V2wxZDJvOEJOSGdEWHJWM21Tb3VHeUF6d3U1WTRSN0NoSW9NZkxWUldxdUVq?=
 =?utf-8?B?Yy9WUHhGWnJSRDRJYklPNFJrclVpRGxMdUIxdXRqZzd5RHk4ejI3ZXVKTHZH?=
 =?utf-8?B?SE1EN1loOTl3cEEyZVppdFhNK2Y2cWtteFc4V3IvOFZac0ZETDZQZWlLRTZz?=
 =?utf-8?B?L2FadFlpTFI3dTY2MFJTdUhCM1lQNXBoMTB6M0crdEpxQ2VOS1B1c29NSjJN?=
 =?utf-8?B?M1h0V25KZE9aK2ZBY0YwNzRQMlNkWVlNK20wU3BTdU11UCtjaWhKZVhVUTI0?=
 =?utf-8?B?N1JNeGMvMmVvSDVTVjRRZkErL1pwbFJhRmZGY3JpT0pka0k5TE82QVVFK0tl?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0588908e-a914-4b00-8de4-08daf99b4dca
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:31:04.9525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I5x3YjIK0RK/tTqqeIhGQLRTSV+Lzk5OuYUH3WArCakNI/mhPrXoj26k0gE9sI5nOalFMvolwTkbkZo52sM0wFU0cZAxLZrHhCBzcPZ5yGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6061
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



On 1/18/2023 10:35 AM, Saeed Mahameed wrote:
> From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> 
> Send WQEBB size is 64 bytes and the max number of WQEBBs for an SQ is 255.
> For 16KB pages and greater, there is always sufficient spaces for all
> WQEBBs of an SQ. Cast mlx5e_get_max_sq_wqebbs(mdev) to u16. Prevents
> -Wtautological-constant-out-of-range-compare warnings from occurring when
> PAGE_SIZE >= 16KB.
> 
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> index 853f312cd757..5578f92f7e0f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> @@ -445,7 +445,7 @@ mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
>  
>  static inline u16 mlx5e_stop_room_for_wqe(struct mlx5_core_dev *mdev, u16 wqe_size)
>  {
> -	WARN_ON_ONCE(PAGE_SIZE / MLX5_SEND_WQE_BB < mlx5e_get_max_sq_wqebbs(mdev));
> +	WARN_ON_ONCE(PAGE_SIZE / MLX5_SEND_WQE_BB < (u16)mlx5e_get_max_sq_wqebbs(mdev));
>  
>  	/* A WQE must not cross the page boundary, hence two conditions:
>  	 * 1. Its size must not exceed the page size.
