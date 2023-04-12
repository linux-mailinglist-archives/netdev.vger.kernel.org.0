Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884B86E0260
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 01:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjDLXOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 19:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjDLXOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 19:14:35 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70AF7EF9;
        Wed, 12 Apr 2023 16:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681341271; x=1712877271;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eA756U+D+rB+uZXcGaZqlHULGINAWhvEFoSUnIM5m5U=;
  b=b16IUqytAit2zCR/A1dyny4QosUlEmtHjnnhaPkwNQDfrhXqMEfx6Bbk
   k4jj7uYuHeHox2pWwl5xojL1HP5IsRcrEKGNVZJ1K0a0cqNm+41SNbCKU
   +GcVJKeAWBJmrzGEgJX9S1l2NUcj/YZkV2iKZjpf3IruMfFy2b8lNHKqM
   2IP2AsAQdb5bHIyNgMgymi3rVe1ojmXVK6V3YBC3vYji56ZdqcljiWnIm
   ElfamuJT64O03F60xKKk8ek2hXuTSN7/EyNpCOa0OFWoo+E28LRLdbAT7
   CWwah8Ieu9lYKtaPjngMGl8GnybvmaWXKIU3Q/bAb3+8WQ/zvld11mbhk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="406877845"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="406877845"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 16:14:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="832846155"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="832846155"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 12 Apr 2023 16:14:30 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:14:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 16:14:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 16:14:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xo8ZZTIL+nK92wRi0wJuD+iUQxOOgSJJknga5KnDnmvFDyYNS118vo8jRQvEYQWdP9lFLuyEfcKy7mm3gIp3ONyhWOujSPKTFtrJuNn0TfTvlR/jfThlAlEFJnA92Sk4W++VoJBSCmCCTNV0s6QkTL8z/30dnSkvLuvGkbII9xUV/SOchWxGI+iX2C7Xc6gBSAVFUAFCiz8+OpdJaDY17QhFdeCHBMLlIYuiTGAe401PpABPHLoEJLhL9A6BJM0tqNomwCoRShsFBZ8clpTH0gFtU1NReLKJsFctYmcWWmGnePyCgbIcEsHjRmrYqslEX3+C9atrRDuFNWSPANEHIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HpHEpkVpWmxcOE5SYXU/fL9wsNO0yFc6d84KFhHlMig=;
 b=lPcVOAQwXtmgGRdVtzXuMtYYHbyQzNp3WToO7e0TYSAl5kWH3MDLmy/UxCN7s/Zdpn2F0WWy519rhdaHaUvqrbjvv61+1cCeFwPrxNXUceeUdT4VN/8BUVj5hEGBEMuJZNvpYZlmRiqpN3Bzo3Yy7CaM/hMo7PAj6UF7/GyfdkJl8X+7U8VAWvjGrf5orJ1neKWah29gk8DU180Sr0enDtmP7Ls203u54HroUtO/r66UeeibkzYPxKCldJrTN2uWVXBtC/YQcpVDTeK9DO4KVtM1x7AHuTHBhkK7iUmwljFD7jCGbTicUsT+m2P1gE3mnIkrKTnpR5dV4sTr7uyMAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5239.namprd11.prod.outlook.com (2603:10b6:208:31a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 23:14:16 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 23:14:16 +0000
Message-ID: <a303351e-8b0f-f7ad-180f-cc2108c15b76@intel.com>
Date:   Wed, 12 Apr 2023 16:14:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next Patch v7 5/6] octeontx2-pf: Add support for HTB offload
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
 <20230410072910.5632-6-hkelam@marvell.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230410072910.5632-6-hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0167.namprd05.prod.outlook.com
 (2603:10b6:a03:339::22) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL1PR11MB5239:EE_
X-MS-Office365-Filtering-Correlation-Id: f01bd0d6-e92d-435f-d88b-08db3baba2fe
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qHEsVsCGxpMa5PjpgzlkhCme7emSVsJWOXdBHiEW8yfytDlvmbDqD/kVnnZ6mbkN4PoqlxDf7E7mHwXZy/FgAJUUurctQ+7jDs2j7zBVxlzhgVCzWJ1Ld1IGccDIFkAvWDi13Ylee+ywCLu1Hb874qWIroKqlX/c+XOXptu88j9YTV3Zm66E94/V+AfFjBKVMV/CueIWfgUQC17uRBjvewMRaK7+P/IjP1xpsEqRA6VsMpsJMMD64vUSU+5hWFYBZybZRnB8xNNPpXpw8YHETjDB1oGB04mbp+JIh8QJBUQQs76JkAD6wSV+OADrreokXptYQ25hXzYV+XHmHUxfyLzvyUsimSkxtqqtR6SZ2fJeWfs9l/PxnhTbBJfoMF/ILbGSm6+24mfa2sb30KzvJsmsqA/W8YMS73X7smhZ8TvIFIBsQJwsSxYv4bXTZMrQMdmJvtj7hH1zp60HyMN7E//fmR+Gh7Qzvp/y3zXnt9P6fzHGRwEdGGaI1i3OHir45lZykkXAG7AUfbTUq/0TVcgH1byvuhhfL3ps05DnHjIjDVuHRgU+VBmI8zbM+hz+I5PEgIErVmdVWfe3RSS3yglmjNmQyEnvTHhsT4N5nzmFrsG0UBseb6RnLCXCmnhp3vferT/J5bCP7PpGY4inCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(376002)(136003)(39860400002)(451199021)(2906002)(7416002)(31686004)(8676002)(8936002)(5660300002)(478600001)(41300700001)(316002)(66946007)(66556008)(83380400001)(66476007)(82960400001)(36756003)(4326008)(31696002)(26005)(86362001)(6666004)(38100700002)(186003)(6486002)(53546011)(6506007)(6512007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlJ0WmZwdFhmWU1oZXVpYVM4MU5XRGQ1dGtQT1pWMTluU3EwYWtqb2pJbnI4?=
 =?utf-8?B?czh4RGFVQjlrbDJxdFdXdjhTZkJVeXc5aStCejNyWjhyYWVLSVlpRUpFeURI?=
 =?utf-8?B?UExkVlJka1d4SWhOMXgxUUt1eXpoalZ6Q2FoUDdBVFVjaHN0Z205SkYvTWE2?=
 =?utf-8?B?RmRIczFEallHbWFRSXZqcGNsdXNvcUszQXlxclJpenA1enBSeWJuMHJpUVA2?=
 =?utf-8?B?eWRtOGJZN2NKUktrVmhCMTA2NDNpK3cvVnBHMHp3RUozZXZvckZiZUlndStZ?=
 =?utf-8?B?ZkNwV1lMYmRYWFFxeEM0bE5mODhLbXFtaUNjM00zV0luN1F3ZmZsSEdHQkpv?=
 =?utf-8?B?dUtRMkxxcjMwd0tEZFVMUkFUYVNjVzJpWmRzTXEyYm5NZXEvQmdUQWZ1VkhF?=
 =?utf-8?B?SFNvaDFlbjcrWmFRZFlqOHU1RlhVQUppajFBWUxnTFFRdDBBUWNWbHhlUk56?=
 =?utf-8?B?L0YzZjUxS2RiUHFnK1RLZ1RmRkZPK0J0eG1mbzdNVTBXTi8zTzlaN3NGdXFi?=
 =?utf-8?B?bWVGczhjQThpVkNQNU9rQk8xRnNwd1pyVGpNWXVvYVVYb1ZPR2RJOGdNcDRX?=
 =?utf-8?B?MkVFZllrN0Ivd2NzT2JkTkxxcXpuOU43YUFkQVdldGFpbFNaRlBHeTdrRytj?=
 =?utf-8?B?SlVDQXFFYVlUcGhGSFlNT0NOQ3RIenBHTVZ3NkxhT21ocHV2ZFpSWncvVVEw?=
 =?utf-8?B?UC9qY2FsM2FVWkRHNWtmeUtwdFBnSjJNVUlVM2R4aUV5Nll6cENHNGJ5enVk?=
 =?utf-8?B?TndaR2pLOGJ2ZWdQTWlqMUZSQ3NqRGtFeUdiNm9HbWpydzUyMXduYW1OSWIy?=
 =?utf-8?B?TkVHNkkzaEdRL2RXK1Iwa0hPTzcyaHB0L3NYUkxEQnVkd2I4RGZlbWZFVUVK?=
 =?utf-8?B?NkJ6RklsaUJFSjgrM2ExTW1wK0gzaXozTTlqb05OWW9tTm55bU1rajhVbVE4?=
 =?utf-8?B?ZmRYcU9iVDMwT2FFWVk5ZzFWUjNKUzZhWjRUN3NNSUpYcFpPWEt6YmM5ZDdo?=
 =?utf-8?B?Kzh3U2FKVnRsVVRaYXd2WlpZbXRZRHRlMW1ldEcxZUlBZis2ME43Nkk0Tmlq?=
 =?utf-8?B?MHBETmFmZVVsQUNZVEZ2b1hFVGRRcCtaeGRHM0tIUmZHN2EzYU5mak02UmNV?=
 =?utf-8?B?Smx1ZS9DcWwxcXl0L2F0YStnSDVCQ3d4aXVJVk1sL3VwOEF5dVNBa29teHBC?=
 =?utf-8?B?VktrZWpKcnBWUVZHaUROdjFITFJOTmo1Vi9kYk9VUHNuVDBqdjF5MWZvUkZq?=
 =?utf-8?B?MVVXMXZnNnBNeHJOQ3QrQ1N2OVo2aStLTitzVmh1STlUSWk3bTQra0czeGZ6?=
 =?utf-8?B?OEsyMDQ1UlhIVU04YkxISVNoZVFxSzdDNXBzRGJTV0QvK2IzVHkwOHNpN3FG?=
 =?utf-8?B?MGJhVTZTMjFVKy95VEs2aTBpZmt3STFJaUhHZm5mb1cybDFmck9Lc01nYTd1?=
 =?utf-8?B?M2lsTEtORURIWTcra1FrSU05d3ZOdkk0Q0tDa3A0U2R2c3Vhc2JaRWZCdzhU?=
 =?utf-8?B?dzdzQzNpMDBUTmhPMVhOTk90UXQ2azJXblUxbUdaUHl0OHFXcDhVa1lPeTNY?=
 =?utf-8?B?aEVMd1crQldjdG5LcFMyQURUQUJOOXIvWXJDVStLSXg1NmpjeEFCUG5iNEJ0?=
 =?utf-8?B?cEpWajJ4bnlsNEpzZmVFbjh5ck5nSWtFamdMKzB4NytJL2J1b0s3Zm11SmdP?=
 =?utf-8?B?TkJVWVFwQ1NxWE9tSWlWOVNISHhqWU43bmUzc3BaUytJU25kc3RINW5pa0Qy?=
 =?utf-8?B?Qi9WSEpoTGNJbXdjMWZnaUhKL09ZOWdKY3lJbXUzWExKTUN3ZlFmMUhySXBz?=
 =?utf-8?B?eHR4b1NINlpUK05jZEFnYnR3WnF6bXJyQXFvUEJUWnpSUEgwV1drYUxDcTBP?=
 =?utf-8?B?YXk5RUJ6eDNxWElMVlJldFBhVnJWQU8raks2V1h1RGRmZDc3SDltZUI1ci9U?=
 =?utf-8?B?TWZtaVI5RmFDU3pHdkZ3VnE1dTNNUmhPZnRLdXY3V25FalRnTXp3MEcrVDhB?=
 =?utf-8?B?ZmZTWk0xeEJpV2ZXUFd5UGQwLy85RVcvd0VqQ0wyb3hjWEFseXNxMlBISWU3?=
 =?utf-8?B?WGVEVUl0NElKMWFiZzNWVXVlN1NWQXVzYVlJcTBWRW5tbWxDenRtN2ZLZTVz?=
 =?utf-8?B?Y0lJV0FEL2RwZDNjTllxZ09MemtVYXE5c3pndUdZeExpZzVaZllJankwMEpm?=
 =?utf-8?B?ZUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f01bd0d6-e92d-435f-d88b-08db3baba2fe
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 23:14:16.5198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DykWf+XYOSVLSvVSLyZ1fHSinTTMHqzlVoqfePhKzkGkrgMokggl5JsHphgywzl9J23TrqT9jyNEhlb8i8eLmBNpXPdhqNPOO8z1wKnwUxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5239
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



On 4/10/2023 12:29 AM, Hariprasad Kelam wrote:
> +static void __otx2_qos_txschq_cfg(struct otx2_nic *pfvf,
> +				  struct otx2_qos_node *node,
> +				  struct nix_txschq_config *cfg)
> +{
> +	struct otx2_hw *hw = &pfvf->hw;
> +	int num_regs = 0;
> +	u64 maxrate;
> +	u8 level;
> +
> +	level = node->level;
> +
> +	/* program txschq registers */
> +	if (level == NIX_TXSCH_LVL_SMQ) {
> +		cfg->reg[num_regs] = NIX_AF_SMQX_CFG(node->schq);
> +		cfg->regval[num_regs] = ((u64)pfvf->tx_max_pktlen << 8) |
> +					OTX2_MIN_MTU;
> +		cfg->regval[num_regs] |= (0x20ULL << 51) | (0x80ULL << 39) |
> +					 (0x2ULL << 36);
> +		num_regs++;
> +
> +		/* configure parent txschq */
> +		cfg->reg[num_regs] = NIX_AF_MDQX_PARENT(node->schq);
> +		cfg->regval[num_regs] = node->parent->schq << 16;
> +		num_regs++;
> +
> +		/* configure prio/quantum */
> +		if (node->qid == OTX2_QOS_QID_NONE) {
> +			cfg->reg[num_regs] = NIX_AF_MDQX_SCHEDULE(node->schq);
> +			cfg->regval[num_regs] =  node->prio << 24 |
> +						 mtu_to_dwrr_weight(pfvf,
> +								    pfvf->tx_max_pktlen);
> +			num_regs++;
> +			goto txschq_cfg_out;
> +		}
> +
> +		/* configure prio */
> +		cfg->reg[num_regs] = NIX_AF_MDQX_SCHEDULE(node->schq);
> +		cfg->regval[num_regs] = (node->schq -
> +					 node->parent->prio_anchor) << 24;
> +		num_regs++;
> +
> +		/* configure PIR */
> +		maxrate = (node->rate > node->ceil) ? node->rate : node->ceil;
> +
> +		cfg->reg[num_regs] = NIX_AF_MDQX_PIR(node->schq);
> +		cfg->regval[num_regs] =
> +			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
> +		num_regs++;
> +
> +		/* configure CIR */
> +		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
> +			/* Don't configure CIR when both CIR+PIR not supported
> +			 * On 96xx, CIR + PIR + RED_ALGO=STALL causes deadlock
> +			 */
> +			goto txschq_cfg_out;
> +		}
> +
> +		cfg->reg[num_regs] = NIX_AF_MDQX_CIR(node->schq);
> +		cfg->regval[num_regs] =
> +			otx2_get_txschq_rate_regval(pfvf, node->rate, 65536);
> +		num_regs++;
> +	} else if (level == NIX_TXSCH_LVL_TL4) {
> +		/* configure parent txschq */
> +		cfg->reg[num_regs] = NIX_AF_TL4X_PARENT(node->schq);
> +		cfg->regval[num_regs] = node->parent->schq << 16;
> +		num_regs++;
> +
> +		/* return if not htb node */
> +		if (node->qid == OTX2_QOS_QID_NONE) {
> +			cfg->reg[num_regs] = NIX_AF_TL4X_SCHEDULE(node->schq);
> +			cfg->regval[num_regs] =  node->prio << 24 |
> +						 mtu_to_dwrr_weight(pfvf,
> +								    pfvf->tx_max_pktlen);
> +			num_regs++;
> +			goto txschq_cfg_out;
> +		}
> +
> +		/* configure priority */
> +		cfg->reg[num_regs] = NIX_AF_TL4X_SCHEDULE(node->schq);
> +		cfg->regval[num_regs] = (node->schq -
> +					 node->parent->prio_anchor) << 24;
> +		num_regs++;
> +
> +		/* configure PIR */
> +		maxrate = (node->rate > node->ceil) ? node->rate : node->ceil;
> +		cfg->reg[num_regs] = NIX_AF_TL4X_PIR(node->schq);
> +		cfg->regval[num_regs] =
> +			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
> +		num_regs++;
> +
> +		/* configure CIR */
> +		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
> +			/* Don't configure CIR when both CIR+PIR not supported
> +			 * On 96xx, CIR + PIR + RED_ALGO=STALL causes deadlock
> +			 */
> +			goto txschq_cfg_out;
> +		}
> +
> +		cfg->reg[num_regs] = NIX_AF_TL4X_CIR(node->schq);
> +		cfg->regval[num_regs] =
> +			otx2_get_txschq_rate_regval(pfvf, node->rate, 65536);
> +		num_regs++;
> +	} else if (level == NIX_TXSCH_LVL_TL3) {
> +		/* configure parent txschq */
> +		cfg->reg[num_regs] = NIX_AF_TL3X_PARENT(node->schq);
> +		cfg->regval[num_regs] = node->parent->schq << 16;
> +		num_regs++;
> +
> +		/* configure link cfg */
> +		if (level == pfvf->qos.link_cfg_lvl) {
> +			cfg->reg[num_regs] = NIX_AF_TL3_TL2X_LINKX_CFG(node->schq, hw->tx_link);
> +			cfg->regval[num_regs] = BIT_ULL(13) | BIT_ULL(12);
> +			num_regs++;
> +		}
> +
> +		/* return if not htb node */
> +		if (node->qid == OTX2_QOS_QID_NONE) {
> +			cfg->reg[num_regs] = NIX_AF_TL3X_SCHEDULE(node->schq);
> +			cfg->regval[num_regs] =  node->prio << 24 |
> +						 mtu_to_dwrr_weight(pfvf,
> +								    pfvf->tx_max_pktlen);
> +			num_regs++;
> +			goto txschq_cfg_out;
> +		}
> +
> +		/* configure priority */
> +		cfg->reg[num_regs] = NIX_AF_TL3X_SCHEDULE(node->schq);
> +		cfg->regval[num_regs] = (node->schq -
> +					 node->parent->prio_anchor) << 24;
> +		num_regs++;
> +
> +		/* configure PIR */
> +		maxrate = (node->rate > node->ceil) ? node->rate : node->ceil;
> +		cfg->reg[num_regs] = NIX_AF_TL3X_PIR(node->schq);
> +		cfg->regval[num_regs] =
> +			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
> +		num_regs++;
> +
> +		/* configure CIR */
> +		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
> +			/* Don't configure CIR when both CIR+PIR not supported
> +			 * On 96xx, CIR + PIR + RED_ALGO=STALL causes deadlock
> +			 */
> +			goto txschq_cfg_out;
> +		}
> +
> +		cfg->reg[num_regs] = NIX_AF_TL3X_CIR(node->schq);
> +		cfg->regval[num_regs] =
> +			otx2_get_txschq_rate_regval(pfvf, node->rate, 65536);
> +		num_regs++;
> +	} else if (level == NIX_TXSCH_LVL_TL2) {
> +		/* configure parent txschq */
> +		cfg->reg[num_regs] = NIX_AF_TL2X_PARENT(node->schq);
> +		cfg->regval[num_regs] = hw->tx_link << 16;
> +		num_regs++;
> +
> +		/* configure link cfg */
> +		if (level == pfvf->qos.link_cfg_lvl) {
> +			cfg->reg[num_regs] = NIX_AF_TL3_TL2X_LINKX_CFG(node->schq, hw->tx_link);
> +			cfg->regval[num_regs] = BIT_ULL(13) | BIT_ULL(12);
> +			num_regs++;
> +		}
> +
> +		/* return if not htb node */
> +		if (node->qid == OTX2_QOS_QID_NONE) {
> +			cfg->reg[num_regs] = NIX_AF_TL2X_SCHEDULE(node->schq);
> +			cfg->regval[num_regs] =  node->prio << 24 |
> +						 mtu_to_dwrr_weight(pfvf,
> +								    pfvf->tx_max_pktlen);
> +			num_regs++;
> +			goto txschq_cfg_out;
> +		}
> +
> +		/* check if node is root */
> +		if (node->qid == OTX2_QOS_QID_INNER && !node->parent) {
> +			cfg->reg[num_regs] = NIX_AF_TL2X_SCHEDULE(node->schq);
> +			cfg->regval[num_regs] =  TXSCH_TL1_DFLT_RR_PRIO << 24 |
> +						 mtu_to_dwrr_weight(pfvf,
> +								    pfvf->tx_max_pktlen);
> +			num_regs++;
> +			goto txschq_cfg_out;
> +		}
> +
> +		/* configure priority/quantum */
> +		cfg->reg[num_regs] = NIX_AF_TL2X_SCHEDULE(node->schq);
> +		cfg->regval[num_regs] = (node->schq -
> +					 node->parent->prio_anchor) << 24;
> +		num_regs++;
> +
> +		/* configure PIR */
> +		maxrate = (node->rate > node->ceil) ? node->rate : node->ceil;
> +		cfg->reg[num_regs] = NIX_AF_TL2X_PIR(node->schq);
> +		cfg->regval[num_regs] =
> +			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
> +		num_regs++;
> +
> +		/* configure CIR */
> +		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
> +			/* Don't configure CIR when both CIR+PIR not supported
> +			 * On 96xx, CIR + PIR + RED_ALGO=STALL causes deadlock
> +			 */
> +			goto txschq_cfg_out;
> +		}
> +
> +		cfg->reg[num_regs] = NIX_AF_TL2X_CIR(node->schq);
> +		cfg->regval[num_regs] =
> +			otx2_get_txschq_rate_regval(pfvf, node->rate, 65536);
> +		num_regs++;
> +	}
> +
> +txschq_cfg_out:
> +	cfg->num_regs = num_regs;
> +}
> +


That is a lot of code for one function.. Any chance it could be split
into some helpers?

This patch itself is also much larger than I was expecting. I guess most
of it is in the new file implementing the new HTB offload, but its hard
to digest in a single patch.
