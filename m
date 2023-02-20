Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F3469CA57
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbjBTLyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjBTLyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:54:12 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660E01A8;
        Mon, 20 Feb 2023 03:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676894051; x=1708430051;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pNYzdEr6cda/kwx1staTQHEHYKUZTBHu9di8D2rlLvs=;
  b=VM1nUKxxU6NJlXAMeF2ma/a4vv7ONh9TFF2tubZsjKEuMzWM0x8fdMyT
   XqmldIkfaTDsgT4e4/iDTEIlhwyj3NgEMq8YhuSRdP0DcuvkGKKVNPtYT
   zJWh84lmhIeKRnKoQASYl7M8XCbsrt+Me+hMEYCJThzPfEp9h6nV6aWix
   BxerINBfEVFnSTdoa3AuTj8YSCgIc+wTWAlgSR/uS0y8m2nDU5P1qKqk1
   cBy21tBHjdkICfdtR5DCeQilHdYQUBG+xX8JCVvmHWIf9LcTn8rdEGiHn
   SieARjBKAecZWUODvVPI486a7zR/9m3+ul10LOyf2+eBSBO4hXzUNlIKs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="312014592"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="312014592"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 03:54:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="671289466"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="671289466"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 20 Feb 2023 03:54:10 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 20 Feb 2023 03:54:09 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 20 Feb 2023 03:54:09 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 20 Feb 2023 03:54:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvF7kudND5+FjDUHgtN+t6S7g7IkeRNTY/axS5nqJuq1OOtwSxgBR6r7u0v76/2nStJvZkDedqpt3uYRk12Hv4pmP9PrFZxLT25VJZJQuUsz981zQdL804uOI9704gZQ1mohQUciL8zinAadyXsLk5O0mmtgfY7ahcp4XpsFCPvKPGG9KfcJLrsO8ZYgMOaZ2kquZXR+4NzGoAIyRp7myQIrClA1K+ODgn+eEfsrH5IbPJ4nD+I/JTKPP8ev7GRp/+cRmc2FWRaHpvi6cLaFELxVdXUyG5EOUd03zPYF5qdOu6Of5sR7YhsHjWRL7y0ehB+guwG3mORGQ5wBpsfbig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iwE9Rt9Yhw9Czh0Ka+XMIXKkB6lKBMfY+Yytdq5UUyA=;
 b=BxD+41/Qb+we/bqv6DDMldRIcB7bQAZaEDHeGW1tcQrSvHAoDqLgD1oY/lt8v7MBqYKGhyxSnW8whbtIO8Kb5a40g+MAJGlFrlHV4f6iaEHSpVi5ldUw7G8cynYuQ52bO3mLsAEyzcvNdp2D6vjhqG0lSNAwDCZMH7o45gDizFyCDZT2SbPAF4l4qjSczhviBrWjBWiE+cRJ14R7+ILN3aMoAuHUliHDgOuPY8Uie6wR5zqIRMrQ7DNJtFLHgcymm1743KtPg+pgwxpguCjgPEgYs9+aUvFkTnJ9vBL3hjpF1O7E2bXHJM9LZULqKbM3uDiliIChsRWvUEeawYdhRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB6931.namprd11.prod.outlook.com (2603:10b6:510:206::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Mon, 20 Feb
 2023 11:54:02 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 11:54:02 +0000
Message-ID: <a472728a-a4eb-391a-c517-06133e6bbc8c@intel.com>
Date:   Mon, 20 Feb 2023 12:53:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexander Lobakin" <alexandr.lobakin@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20230220100056.363793d7@canb.auug.org.au>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230220100056.363793d7@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0571.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::10) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB6931:EE_
X-MS-Office365-Filtering-Correlation-Id: db28cb07-ff36-4468-a236-08db133928eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0t3v91ogHmFbR6Hy7EyFGexuyFDr7KzEyYy4m3aEA/cFWd+n70XL0oxuhJ3SlUQzhxApeHApUW+XC7O5c+OG/YFWvQ9ScBdEuPRsZmmtwgi4mQ1mFbPP2Pybce8mCEb3spP5AzRo8pW5+SDxQ8D3I/P1gy4gs9fPHbfC5tFIzA0iUIYJ+FP8xu9poBYTKeidYCP6bSDtZPpMx9Ov3M7awghctbxxaGtZd3WsvVSZMRTGJF7xdHURb+SRAgsV6ydTSsBg5t4omdB4rdjn4ghNNVqg9PiJODczmNmb1u3Pm8aG8SLp3KXeXn1mvjaXbuwOO0lR/Ih9apkqV8wwU/r9/RY8D8UCZh/Vr+58Qw5S5hN5XJlQcUNAiRkC+spj37+/VqDgNVW4hdAUOHCtL4KI5UTO23gJRzS13UGxMqXBssgNnxtnXnN/P4o7Xcb7/QsONXvVZqpd09w6TfGGhyhax/7d5zNCgj1ggH4q0TsFGSjUZL6bhP30CUKF19L0JXA5nJJU7LNlR0+IKDP2MZqsIYC8qfcmSw+xSUSGMn/mJgicZqC8rkpTHqefV8KbTYdSLmjqRvVLGcOyX8YQ28JRfEMA3bAHLWVlcZeUrY0fcO7/LvH6EVwPlpb4w4UUbvhmefNSnKgFXb0qCkWSRZKwNtIJ7yFDjCT91+3F4N3pSp3t/1OI4iQKuTJXUfc02UVAH8c1y0s/4EE5IDEAn9oPgrfegMQHFXy3ERfGOPqwzFY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(396003)(376002)(346002)(451199018)(8936002)(5660300002)(478600001)(6512007)(36756003)(6666004)(82960400001)(38100700002)(6506007)(2906002)(8676002)(4326008)(966005)(6486002)(66946007)(26005)(66476007)(66556008)(186003)(316002)(86362001)(110136005)(54906003)(31696002)(31686004)(41300700001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDlXWGFQQUFFaGJkR3hNNzBOOWZRelJZcWtkdU5WUVM5d2YvY1pIc3V3TG9p?=
 =?utf-8?B?cjhxa0hUa0htWHRQd0YyOVNiNTdFRTJHSGUvZTVPWEVNYVpoY0FqY3IvQ3N5?=
 =?utf-8?B?YWZxaVQwN0RIN1BYNkJ3NlpjNjcxYWN0R0xsOC9mVUc3M0s5dWlOd3ZNcnZN?=
 =?utf-8?B?dmVQOHVwNnliTFczNnpZVEIraktTZVYyekVyQ1hISnhQdHY4RHdGblNqVUVy?=
 =?utf-8?B?RmFSc2JXdWdNVXFMV1g2T01hbjh1SVhkcWRvdHdKT0hHKzRSUFZhOG1HbXhl?=
 =?utf-8?B?OGpHNk9oV2pTa3liQ21UZWRGcE5ydXlwNERVS1kxeHJGemNRcTcrWWJqYm1C?=
 =?utf-8?B?UkROWG83V01HZGwzdXV5SUFJeTJhVHB3aS9ScWEwaG1kVzNEQXVSMmNOWG9v?=
 =?utf-8?B?T2cvRnczSk9EOHhRQTBQSzkrTUJrcm1nUkVuWXY3MnVzMkVJcXBBUFlKM281?=
 =?utf-8?B?S3pidXM5cXFyUGEyblhaOFcvM1ZyR2duZTBoR3lOV1I3a2hzSUlnaXZTWFNu?=
 =?utf-8?B?MVREWjlDdyt5Q1YwYnpEWHE4RFhYOEVyK01UQmdUUkxld3JMbXloSklMamo2?=
 =?utf-8?B?TDVGYmY0UlIxOUZzb05DdXN3S0hWdUNkMlErQ3RDenJvZGdWN3Z5aTZzNC9a?=
 =?utf-8?B?MzF4M3YzRElFbk5oYXJPNFFmdU1qd0s3OTZFOVFFTjFWNFpRZVJuNG9PYXE3?=
 =?utf-8?B?MC9XMmQrdm5nZkRIa3Z3a2xvbjB1TCtLRUVlU0pZdG41aWtlVmtWQ0o1VlJw?=
 =?utf-8?B?QjBXU1RvMWJzMS84OE9jNDJWVVdwWGJEblF6K01wZEhmL0kwL1k2YTZKZ21a?=
 =?utf-8?B?c0g0bUIxSU9ZbUdONGpWeTdVOHlaQTZoWXV4SUszdmNQK28vbWtzSlVkc2p2?=
 =?utf-8?B?WlArVmZ6QW1RdGdNZ2orVWQ5OHlnRk9PSEw5OVdKZmNHTllXaE1mdTZXTUZZ?=
 =?utf-8?B?MUF6OGxINThwVTZHakNrdGdFa3FqR1daZE5qOEtlbU5hMWhXQ29Oci9xL3pJ?=
 =?utf-8?B?RWpTaHZkRWNQWVFxamIrUU5NY09DaFNKSnRHZ293SVlVNzVhYU1xUnR6UHBs?=
 =?utf-8?B?VVlYNTIxNStiemhST3lGdExCalc0TXlJQVA2K0p3alhiRElzb2NPbkVxUDJa?=
 =?utf-8?B?dHJyWkVWQXZ3RWJreFh0UXhKQThtRzJXQzJXaDlTNEV1SEFlWkR5YjZ6ajV2?=
 =?utf-8?B?T3RMNWJPMUZvRWQzTmh5WDByZDRsT2VmcUVSb0FGa3hpZ1pNZHVNWjRPOEVG?=
 =?utf-8?B?QUpvWkIxY2ZaZEpFV2RBUTVOdXgweDNzUmRnNUZJU2ZWYzNXYmF0SG5hSk9q?=
 =?utf-8?B?RVFpaDR2V0cwMzJyaGxjc253ZmJQWXR0MXJ0R0xSV1YrZlZzL0FFakFXK3Rm?=
 =?utf-8?B?eTVEV3ZJbWttaVBjdFhDYk9hNXhkaWRSaWRJcFNScVZIc0hlakZER25QZzVy?=
 =?utf-8?B?U2R5T1JpazE4OU5kNkw3ZzZmN3hQeUdzWmZPSFZuNitwR2VMcG9GVUthdFVm?=
 =?utf-8?B?bUFGaWVDeFRyYjlaeGtyL2dkN2JHQ2NVY3VjN081NGEwUmFtaFFVc2pBbXZt?=
 =?utf-8?B?ZFRzR0Z0aG05TmxkVGV3ZkkxVWo3c2s0U3kzTzZFVU9nWHVnSXRDZldJY0No?=
 =?utf-8?B?c0xZUFg0L0NsczYzdTZUQTE4RVpFaWFwMy8wcGQvNGpWT2FQeXNkVk82TWph?=
 =?utf-8?B?TmtVdXhYZHZkbGhGSVI2SmprWDBpYkxoanJOZlcydFRVQ1pGSWxEaUVaVW1n?=
 =?utf-8?B?L3lCbzd4R1YyWjZYUERKdUxQTXU4ckp0Zy9aQSsyWWtQQXliaHQ5OGJkbU9J?=
 =?utf-8?B?OFJmTUwzQkxDR3dWWCtEcHdvblR1Z2JpUjV3bzFxdWxpSVlxdXdrQUZCWDlZ?=
 =?utf-8?B?RFdhcDJKTDQ4RWdpM2FmTW16cnh5L2p6dDdlVk9VRXRaUjNhajV5dFkwQlN2?=
 =?utf-8?B?ZGVrZmxSRm9NSXdGUVc5YlQra0NGLzVmdlpGbnQwMzB1aVpDS0EySzFMOTdG?=
 =?utf-8?B?RzYrblJWZ01lTTlmTmJ2Yy9yaUN4MWhUNGhjYlRWVnFsNG9RN21OS0t2SjBv?=
 =?utf-8?B?Nkh5VGh0bjVOT0RuRlNVQlNvaWp0dk9EZUdVL1E5WjJmbXkrZDZrVlRZUmpm?=
 =?utf-8?B?TThZR1gzdGdjOW5vUzA2d0l3MU9ZeUxxeHU4cUJoSmZKdFpvMVdyMG04MzYy?=
 =?utf-8?Q?idSaaksaow0kPm3j/Xzseao=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db28cb07-ff36-4468-a236-08db133928eb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 11:54:02.5370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KH1Ty1Wi2k5k3rF/nvYYQ0nLdgUpu7ejm8IlnbIDEpQbWF/x2BEKaJjlCj4MaZjtGeAXqJf5V+sD+6IAzz+n7wZ4gO0BqJerG15jdvgaB3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6931
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 20 Feb 2023 10:00:56 +1100

> Hi all,
> 
> Today's linux-next merge of the bpf-next tree got a conflict in:
> 
>   drivers/net/ethernet/intel/ice/ice_xsk.c
> 
> between commit:
> 
>   675f176b4dcc ("Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net")
> 
> from the net-next tree and commit:
> 
>   aa1d3faf71a6 ("ice: Robustify cleaning/completing XDP Tx buffers")
> 
> from the bpf-next tree.
> 
> I fixed it up (I guessed - see below) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.
> 

Hi,

the correct fix will be as follows (at least my Git yielded me this when
merging net-next with bpf-next).
Strange movements from Git, but basically the resolution is to pick the
latest ice_xsk.c from bpf-next and then manually carry Larysa's fix[0]
for @xsk_frames (she initially did it for bpf-next, so it's easier for
us to resolve this conflict).
Much thanks for noticing and notifying.

[0]
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=1f090494170ea298530cf1285fb8d078e355b4c0

Thanks,
Olek
---
diff --cc drivers/net/ethernet/intel/ice/ice_xsk.c
index b2d96ae5668c,917c75e530ca..1fcfa07c205b
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@@ -629,29 -613,28 +614,30 @@@ static void ice_clean_xdp_irq_zc(struc

  	last_rs = xdp_ring->next_to_use ? xdp_ring->next_to_use - 1 : cnt - 1;
  	tx_desc = ICE_TX_DESC(xdp_ring, last_rs);
- 	if ((tx_desc->cmd_type_offset_bsz &
- 	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE))) {
+ 	if (tx_desc->cmd_type_offset_bsz &
+ 	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)) {
  		if (last_rs >= ntc)
 -			xsk_frames = last_rs - ntc + 1;
 +			completed_frames = last_rs - ntc + 1;
  		else
 -			xsk_frames = last_rs + cnt - ntc + 1;
 +			completed_frames = last_rs + cnt - ntc + 1;
  	}

 -	if (!xsk_frames)
 +	if (!completed_frames)
  		return;

 -	if (likely(!xdp_ring->xdp_tx_active))
 +	if (likely(!xdp_ring->xdp_tx_active)) {
 +		xsk_frames = completed_frames;
  		goto skip;
 +	}

  	ntc = xdp_ring->next_to_clean;
 -	for (i = 0; i < xsk_frames; i++) {
 +	for (i = 0; i < completed_frames; i++) {
  		tx_buf = &xdp_ring->tx_buf[ntc];

- 		if (tx_buf->raw_buf) {
- 			ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
- 			tx_buf->raw_buf = NULL;
+ 		if (tx_buf->type == ICE_TX_BUF_XSK_TX) {
+ 			tx_buf->type = ICE_TX_BUF_EMPTY;
+ 			xsk_buff_free(tx_buf->xdp);
+ 			xdp_ring->xdp_tx_active--;
  		} else {
  			xsk_frames++;
  		}
