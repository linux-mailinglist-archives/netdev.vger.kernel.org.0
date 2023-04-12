Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A66E0246
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 01:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjDLXHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 19:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjDLXHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 19:07:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DE4869B;
        Wed, 12 Apr 2023 16:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681340822; x=1712876822;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d0ZzIjQ2wsTTTZiB4CqDUxKte1FIrUIGd8+ElpF4w0o=;
  b=eS18C0vJ+fzZ6CnXccbOec94XOGs8hj0EsXyQcAzvnnqBRDuLY5bRR5K
   IsnxQaZS/MpvPVrvHorKX7tB6gI6iZB9hP613A0VAxA8hUGFshjyb3PZi
   AbHm5/7JsMBhTIEZi0K4XY+FXTzC1AP+MXprfFBb9dSLRGuPgEDPcHTC/
   5n+ah4BDOv2aNKtHVV1SkImatRIAb0uigCALFjfR9gpWpe5Uk7gw/Gtp1
   sxzAGPIqZ8wPQsKvtsqF/24a1+TqPmxZA00AX7A9GXMyzbvU4a+GAXsNX
   0aKnNaP+NYeF6Eo3c0PnGwChKNqAKaFtIdx51KHlotKR6CmYR1bunV4YB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="409186437"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="409186437"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 16:06:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="719582037"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="719582037"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 12 Apr 2023 16:06:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:06:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:06:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 16:06:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 16:06:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzpApPMIyuSaOKkMYg4zhlYsPYjiJr9nL5yWJp5Xa777OLe63l7QNT7RSNkza6A4vxikZ8rSCUbUxU4UhyHwVZr7RbyUolLjY8lELJIHQc2lz9EEaMWbooTSy3+6R3pmdqF7CigwgiyQorI12/Qxl2Z497dgBYKAOnRBiJTAD8RIboZE80B4Pexut+lXCdyJeNFDIe9hLU7/1tg7Numj5ojYB9MwospkVBIAMe9GsijcH1cNNmnylTY2PqKkO66wC0Lg4Kr+fefCxvOUAVi704ufxat5vfQkCUh+FmqnqAL487ffpCJ6YEtgRRlV3m+vTbMiWj2vYaaM4c0bBnLxuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rqvku4HoyXYJEQi4EYQ/IRoYsqgDXckI3gFUWoWL7Q=;
 b=cKKNz9QtiZ8f7uF6iKJHr+6iKp8hRYF4/+1pgGlhYoAVSfwiiE9kmdSyRXt4xiuXTnWJXNRgeUkD2gUuClFG9SUb6L67dYskb0NYiGtkGxoQlUT3dc05TKT5fwouTUQmbnVioGc8uRR8ApJov6VqrErpWn+TdZW9r7PA7VzkSdcxHcUwJGIwpYpfEn0+TCrfQHjTGGM4cwYnDjXLbeN2hpdMQSg3cS+nBLzUltD+NnmkxpFsVWbsbXSrwdMUEUYXcJzLlOo29FdzBCozMmF+Y5HoOUmWtdLvyL3Ly9sH9xe8AZwpRIaAEER37UtcJP5B85a4nxrNm1H4XcPWG8M6Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB5968.namprd11.prod.outlook.com (2603:10b6:8:73::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Wed, 12 Apr 2023 23:06:53 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 23:06:53 +0000
Message-ID: <4ad37f67-d419-27ce-581b-c0fa4739c3a3@intel.com>
Date:   Wed, 12 Apr 2023 16:06:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next Patch v7 2/6] octeontx2-pf: Rename tot_tx_queues to
 non_qos_queues
Content-Language: en-US
To:     Hariprasad Kelam <hkelam@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <naveenm@marvell.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
References: <20230410072910.5632-1-hkelam@marvell.com>
 <20230410072910.5632-3-hkelam@marvell.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230410072910.5632-3-hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0003.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB5968:EE_
X-MS-Office365-Filtering-Correlation-Id: cc2bc272-ade9-41bf-d6b7-08db3baa9a9f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wKcTv87eXb1aGP6u4AGa9ndWU23pwOhzXIeyiZfAf41FXFIwdPQfrwKHFEu1dd1/lNr0aS6n8aT+4vERPe0Ba9qNm0d5mXv6S6ZqjEk5IXErAJwXRxy14acuCT9L4u/vMz3npj69l1K0+1JbU90/YjrzSxOVR3X47Kw0ZV1psX+C5CfbNoGhnZCcTPu2C80NPAWBWE8tKJBueLaLSzBv1+i16gUy6LflbuCVNwKGoouBTZKT7sll6gSCbN9T9sJK3QL/T6AtnYdxymLkh0f/XqjWRmfPsKl7tEis6GU39f9iKKLtMb7bcOSHvwn3RQgUkNXoq5Dyls4FBSa8a23fAE4cbccwVeIiAoQb2Uqt/0+jINQHQmA+D7O6a5wv2+SUuMrnUNWseQr98nY627tYELaErN5/TddjJsqEgIj0dN8sh9p6qH+Br6vgkEBmZNAlprJs4sQtORNW4TS7Akqb2UQidwJBK46uPxwmKcgqcXkBsrRO2PD4NUCRicDmC0qImTtIA00olTUIIChDldAyRjTYECdLkUNabenLOA4ix2+8HP445O4TTGOSzD1natz+GtQFYZ++3Q4QB/aBEVjmcAeqYQNfXwj8pU/APUeCt3qfxqzixWLu7tXXDXAmDs0oPhGWXgxOkIUAeln3Wai//g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199021)(2616005)(83380400001)(7416002)(82960400001)(41300700001)(5660300002)(2906002)(31686004)(38100700002)(8936002)(8676002)(186003)(53546011)(6506007)(6512007)(26005)(66899021)(6486002)(36756003)(66476007)(4326008)(66556008)(86362001)(66946007)(31696002)(316002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjR4SzRDamw1ekw3WG1kemxnK0REZG5HM3RUWVF4dkFGNkVKRWN4QWFOS0NY?=
 =?utf-8?B?d015Vk5vOWhacE5NenNIRmJBNkJJUDM5VE1ramxrWTExdEJkSXlJQnA2anNJ?=
 =?utf-8?B?bFArOFViaGladVdTZm5hUnRHQVArNm1JMjFDZzFWc0JXK1pKNlBXWmcvZGdq?=
 =?utf-8?B?NEdadm1SQTNSZmRKMERid1l5R3JndEJ6L2hoWjJUZ0VMTVUyUE8zMFp1NlFQ?=
 =?utf-8?B?SFRybzZUS3NVV0tNbHliSGhnSmpwQnBBSVR4SEphTTg2aWFycGtPWmFmT0s0?=
 =?utf-8?B?blVmRUR5RU5XNGFBaGtzQTFUMEJPT1BReDZNcFNEOG54V0tDdTBlWWs3VThN?=
 =?utf-8?B?VFJuRFNuTnp3U0JFZmNXN3F4ZkRnSVRhLzJOeHR0T3FUMEluQjArL3RtVzRP?=
 =?utf-8?B?ZStCU2ltcEVid2lXYjNYbm9BcWdVSTU0MHBLa2IrcFNWOExxNUE1ZXBkcVQ0?=
 =?utf-8?B?djgrSFgrL0E1RDdrTlFRVkJsL2VNWXQybVlxWCs1RmlEWXNHUm0rSktRTmhJ?=
 =?utf-8?B?TjgzbnRkSUcwYmdVM2hiZDhJT1pGTzZ4RXlYRXcrbmtadmdUV1ozcms2QVlY?=
 =?utf-8?B?VHVGdmNPK3dKODdTdTliUndMcXNRK2RsdE9BM1RTeUIvYzVmSVF2Z0l2VklM?=
 =?utf-8?B?bkh1WVBjWkwvNHFDWnJocDBNVW8rdXkzWFUzM2RSYmdnaFFrZVd5QmwrRXlv?=
 =?utf-8?B?dHRKWWs4cmxPV0M2M0RWTXRodjJNWHdMeVQrbnlVc245Z2xOWHdLbkVpZ053?=
 =?utf-8?B?c01Lak1NMC9jSVdNTmpCUUV5MTFhb3U4Qlo1SW5pUkE3bDFkRm80Yjh1UWlP?=
 =?utf-8?B?bTNrUG1HZFFDQlg3RDM1UzlGMVk4akF0Z05qWHdRMmhkd2JBS2pxTlhTTHp1?=
 =?utf-8?B?OGxVTGVWYm5PdVJKTS9oeUdTSjFPSEV5VFpLZ3QyN09BbzdOeUtLYkluVHh0?=
 =?utf-8?B?VEEvZ1ZMUHhzdzNsOEFFM2pVQnZlVm5KZzdnUnE5UFBsbGduWnlyaUU1Q0lq?=
 =?utf-8?B?YStySk1DVDBZeXFXLzdjT3NxM0VheWpianNsTVNFOUFyMzczQXhWRFVsdW1C?=
 =?utf-8?B?cGt1Nm81TXRQNW12NVk0cHVpQ1owbVpEMm1aeEphak1NUVRPR0NLUEZGekJ1?=
 =?utf-8?B?dVM2VUNlTFlQVEo5cGNKWTY3NHo2Sjh5czg2cVAwcFcxSGZSMWVrb1pJRW5Z?=
 =?utf-8?B?NDZheGpkYTAzU0VzSHkrZXJRTjUxeTFDY1kvWElqWURMZHRPSHdFRjU4MDdF?=
 =?utf-8?B?YmFSNlNpb2QxeTdiWGY5M3NFVHBnWS81MHBmczVuUTNUNzZMb1V0Rk5nMzYw?=
 =?utf-8?B?S0ZKVERsY24wbW1LdFBJc2ExdGtVUVlyWEVjeTlRcngzQjVBbDVaNVVvaHJD?=
 =?utf-8?B?TUpmT0JsSlFSNi9JUzRaZEN1T3hpeGdDOWdlMVFub3VtVmZnMmlSNUc5d0sv?=
 =?utf-8?B?ZWUrcVFDdkJRN3pTWDg1Q3l3aXdHZEJva0hocm92dWtNc0lkMEE0M2hsdnNq?=
 =?utf-8?B?akh2d1NJK25WNFhtRS95eHNjeDZzQ0lpMzA1STVvdmtUcS95a2tnVTBrZDBI?=
 =?utf-8?B?YVNQZzU3YTRXRHFubGh0cHhHUFlmZkdidXVzMUVFZ3E4S250UzRhRi9WUm5Q?=
 =?utf-8?B?UE1SeDhIQzF1eE42YzExd01obE93UVBZNlJmTm1YWElCS1l5cjR0Q2xZTE9J?=
 =?utf-8?B?SERHWkZWOUd3c0N3b21BSmhsS3c3K1lCbHVxMk5RREg1R2dnUUVJcXI0b0hn?=
 =?utf-8?B?N011Z0pQbWhwdGIrcUhyb3d2aGFNZ0hqamliTWxwb2RvVkZPaURBN1ZKTWxD?=
 =?utf-8?B?OVg1Z1gzS3F2azBuT3I3TWFneWxuaGtiQktFcWhWanBQaThDcXpacVVkOStS?=
 =?utf-8?B?bHdDaUM0M3NPRzNYQk5hUnNRSEV3UXorcjVlQURxZS9JRzd0cWFZQzZFRjVz?=
 =?utf-8?B?RHdVTFkwVWFLcTkwNDdwUTFNSUY5MzgrTmZ2ZHpQQjIwcmVmdWJva3gwQnRl?=
 =?utf-8?B?M3NINlptUDhpVkNNejRiMy9PZlB2cVRXbmFvQmZXVVNLTHFXSDFwMlM4cDVQ?=
 =?utf-8?B?U0pDZmpwQzJuNFJyQUFobUFGNXlCckNaeDhkL3dSTHBZTnRmZ0FxTkRyVFc1?=
 =?utf-8?B?eVAzazZrU1htR29iZHdEQ1B4bWpYdjJ5cS9QelpBQjdEWk8weU9YZVBicUcy?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc2bc272-ade9-41bf-d6b7-08db3baa9a9f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 23:06:53.3062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DtgV/3+GRi4PMoJTNNO5AqksDqsxc9Gx5U9v2gB8bGN+8lVLUIfb2oMUF6du5aEaZXy40xk46A0dS305bt8mW79VW5z9R8TkVQKmwPeSn6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5968
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/2023 12:29 AM, Hariprasad Kelam wrote:
> current implementation is such that tot_tx_queues contains both
> xdp queues and normal tx queues. which will be allocated in interface
> open calls and deallocated on interface down calls respectively.
> 
> With addition of QOS, where send quees are allocated/deallacated upon
> user request Qos send queues won't be part of tot_tx_queues. So this
> patch renames tot_tx_queues to non_qos_queues.
> 
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Good to clarify this.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 12 ++++++------
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  2 +-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 14 +++++++-------
>  .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  2 +-
>  4 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 8a41ad8ca04f..43bc56fb3c33 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -762,7 +762,7 @@ void otx2_sqb_flush(struct otx2_nic *pfvf)
>  	int timeout = 1000;
>  
>  	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_STATUS);
> -	for (qidx = 0; qidx < pfvf->hw.tot_tx_queues; qidx++) {
> +	for (qidx = 0; qidx < pfvf->hw.non_qos_queues; qidx++) {
>  		incr = (u64)qidx << 32;
>  		while (timeout) {
>  			val = otx2_atomic64_add(incr, ptr);
> @@ -1048,7 +1048,7 @@ int otx2_config_nix_queues(struct otx2_nic *pfvf)
>  	}
>  
>  	/* Initialize TX queues */
> -	for (qidx = 0; qidx < pfvf->hw.tot_tx_queues; qidx++) {
> +	for (qidx = 0; qidx < pfvf->hw.non_qos_queues; qidx++) {
>  		u16 sqb_aura = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
>  
>  		err = otx2_sq_init(pfvf, qidx, sqb_aura);
> @@ -1095,7 +1095,7 @@ int otx2_config_nix(struct otx2_nic *pfvf)
>  
>  	/* Set RQ/SQ/CQ counts */
>  	nixlf->rq_cnt = pfvf->hw.rx_queues;
> -	nixlf->sq_cnt = pfvf->hw.tot_tx_queues;
> +	nixlf->sq_cnt = pfvf->hw.non_qos_queues;
>  	nixlf->cq_cnt = pfvf->qset.cq_cnt;
>  	nixlf->rss_sz = MAX_RSS_INDIR_TBL_SIZE;
>  	nixlf->rss_grps = MAX_RSS_GROUPS;
> @@ -1133,7 +1133,7 @@ void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
>  	int sqb, qidx;
>  	u64 iova, pa;
>  
> -	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
> +	for (qidx = 0; qidx < hw->non_qos_queues; qidx++) {
>  		sq = &qset->sq[qidx];
>  		if (!sq->sqb_ptrs)
>  			continue;
> @@ -1349,7 +1349,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
>  	stack_pages =
>  		(num_sqbs + hw->stack_pg_ptrs - 1) / hw->stack_pg_ptrs;
>  
> -	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
> +	for (qidx = 0; qidx < hw->non_qos_queues; qidx++) {
>  		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
>  		/* Initialize aura context */
>  		err = otx2_aura_init(pfvf, pool_id, pool_id, num_sqbs);
> @@ -1369,7 +1369,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
>  		goto fail;
>  
>  	/* Allocate pointers and free them to aura/pool */
> -	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
> +	for (qidx = 0; qidx < hw->non_qos_queues; qidx++) {
>  		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
>  		pool = &pfvf->qset.pool[pool_id];
>  
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index 3d22cc6a2804..b926a50138cc 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -189,7 +189,7 @@ struct otx2_hw {
>  	u16                     rx_queues;
>  	u16                     tx_queues;
>  	u16                     xdp_queues;
> -	u16                     tot_tx_queues;
> +	u16                     non_qos_queues; /* tx queues plus xdp queues */
>  	u16			max_queues;
>  	u16			pool_cnt;
>  	u16			rqpool_cnt;
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> index 179433d0a54a..33d677849aa9 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> @@ -1257,7 +1257,7 @@ static irqreturn_t otx2_q_intr_handler(int irq, void *data)
>  	}
>  
>  	/* SQ */
> -	for (qidx = 0; qidx < pf->hw.tot_tx_queues; qidx++) {
> +	for (qidx = 0; qidx < pf->hw.non_qos_queues; qidx++) {
>  		u64 sq_op_err_dbg, mnq_err_dbg, snd_err_dbg;
>  		u8 sq_op_err_code, mnq_err_code, snd_err_code;
>  
> @@ -1383,7 +1383,7 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
>  	otx2_ctx_disable(&pf->mbox, NIX_AQ_CTYPE_SQ, false);
>  	/* Free SQB pointers */
>  	otx2_sq_free_sqbs(pf);
> -	for (qidx = 0; qidx < pf->hw.tot_tx_queues; qidx++) {
> +	for (qidx = 0; qidx < pf->hw.non_qos_queues; qidx++) {
>  		sq = &qset->sq[qidx];
>  		qmem_free(pf->dev, sq->sqe);
>  		qmem_free(pf->dev, sq->tso_hdrs);
> @@ -1433,7 +1433,7 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
>  	 * so, aura count = pool count.
>  	 */
>  	hw->rqpool_cnt = hw->rx_queues;
> -	hw->sqpool_cnt = hw->tot_tx_queues;
> +	hw->sqpool_cnt = hw->non_qos_queues;
>  	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
>  
>  	/* Maximum hardware supported transmit length */
> @@ -1688,7 +1688,7 @@ int otx2_open(struct net_device *netdev)
>  
>  	netif_carrier_off(netdev);
>  
> -	pf->qset.cq_cnt = pf->hw.rx_queues + pf->hw.tot_tx_queues;
> +	pf->qset.cq_cnt = pf->hw.rx_queues + pf->hw.non_qos_queues;
>  	/* RQ and SQs are mapped to different CQs,
>  	 * so find out max CQ IRQs (i.e CINTs) needed.
>  	 */
> @@ -1708,7 +1708,7 @@ int otx2_open(struct net_device *netdev)
>  	if (!qset->cq)
>  		goto err_free_mem;
>  
> -	qset->sq = kcalloc(pf->hw.tot_tx_queues,
> +	qset->sq = kcalloc(pf->hw.non_qos_queues,
>  			   sizeof(struct otx2_snd_queue), GFP_KERNEL);
>  	if (!qset->sq)
>  		goto err_free_mem;
> @@ -2520,7 +2520,7 @@ static int otx2_xdp_setup(struct otx2_nic *pf, struct bpf_prog *prog)
>  		xdp_features_clear_redirect_target(dev);
>  	}
>  
> -	pf->hw.tot_tx_queues += pf->hw.xdp_queues;
> +	pf->hw.non_qos_queues += pf->hw.xdp_queues;
>  
>  	if (if_up)
>  		otx2_open(pf->netdev);
> @@ -2751,7 +2751,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	hw->pdev = pdev;
>  	hw->rx_queues = qcount;
>  	hw->tx_queues = qcount;
> -	hw->tot_tx_queues = qcount;
> +	hw->non_qos_queues = qcount;
>  	hw->max_queues = qcount;
>  	hw->rbuf_len = OTX2_DEFAULT_RBUF_LEN;
>  	/* Use CQE of 128 byte descriptor size by default */
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> index ab126f8706c7..a078949430ce 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> @@ -570,7 +570,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	hw->rx_queues = qcount;
>  	hw->tx_queues = qcount;
>  	hw->max_queues = qcount;
> -	hw->tot_tx_queues = qcount;
> +	hw->non_qos_queues = qcount;
>  	hw->rbuf_len = OTX2_DEFAULT_RBUF_LEN;
>  	/* Use CQE of 128 byte descriptor size by default */
>  	hw->xqe_size = 128;
