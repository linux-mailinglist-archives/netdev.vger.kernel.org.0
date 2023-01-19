Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8423D67479C
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 00:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjASX6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 18:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjASX6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 18:58:02 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A0AA1007
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 15:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674172681; x=1705708681;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fdpe2ncFVMgb/8XW2xCzwi6k48+fVfWNqAM7Xkm80jI=;
  b=K/acWfGMAOJkP+3a09zuUmu5e0vN82FMYkEbHlmS5Ii7EhLJ3F286Spm
   Kdci4SvAEcrP7QUZ32A0xoyCYFztzhUkm2jOaE0jD8xCywfgmD78b+Yvp
   3hzOmq0821BeHhAJ32y7Sh92O0f/AkMA4rFs4KzVvJdH/7qxjrlcG4kAv
   ceezEj/zHfOq15JabHw70b38LSUJnTNtjvjMKfl2mGsRCvpFDsvAZVOil
   iKSclhtXZKpOhl6gUKkLw85YEx8ActeCz8t5pHGf3dlc6mN+BhAE92Uly
   sjPc3NF9Fon8go6G412DeMhm3bL1+X/bLNkOjtlLIT5SYCyRZ+z3p0y2N
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="313355209"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="313355209"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 15:58:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692645790"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692645790"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 15:57:59 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 15:57:59 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 15:57:59 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 15:57:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cySBELXKlyQQDtXRsdQkIJjAbwc/3b5MCgQIi7CXdstEe5K3a1wsoLF6xu3blgeSBmloJ8d6maUnqeA0CAywnCj4zAe6UuFTmhVZ3t3ZoIm9fBroingBZbSPGWRkLKiboM/AKzUy3rSB8QQYUm+9COIUVPpQ5apx1QEEKZKxC9rt+KlyENr/bHlAogqSi0RQ7v6wp6gCsTCTUBXOiVZlfFxprKT6EyUH/MP5WZX2BhR0kT0wjfvxOuQpecNmhLkY2v/WU4xM1TKC6nuHue48FQb+U/rws8bDjZ429NjtSpwFPYLmMK3PuO2VyJrePwO4aqTimiBdwo0owzuJH4+mGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ktBF5H30l9qmUmRfUfP37EUQqojggvIU7SrWFLETiA=;
 b=ccECUrnPWpHNZ8dyvJlEU+llle8N1SvYPCguEB+xgSBbkXF2KXrahH3J6MLvB7nKBxd2T3FrZKFeu9Th53qsXhDE+NOG0GDfya/3CNb0kRM6dtGZwj0J4se0FGLusEJL/OtQkU97kfDaGXW6QA/qtK4a95JNV7qfFrnxq2lTxFXsrnPWl20N/ueOeoQ+jGad9if80Kq7Z2iaGOdierYHB5JaidF03puxDP0IN41ClTjaVf284Nsfcy+eqF8kskXl6NWy6b0W0xKyhh2++4U+sC4AlRvlJ+N6v7vIenP7qdUi1U8t/+4pMPJf2ELz9MSRj/Y7stpkt6e94Y1Iv0uTNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CH0PR11MB5492.namprd11.prod.outlook.com (2603:10b6:610:d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 23:57:57 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 23:57:57 +0000
Message-ID: <1a3387e7-dbe3-905a-4b7a-ef2cd776cb33@intel.com>
Date:   Thu, 19 Jan 2023 15:57:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 3/7] sfc: add mport lookup based on driver's
 mport data
Content-Language: en-US
To:     <alejandro.lucero-palau@amd.com>, <netdev@vger.kernel.org>,
        <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm@gmail.com>,
        <ecree.xilinx@gmail.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-4-alejandro.lucero-palau@amd.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230119113140.20208-4-alejandro.lucero-palau@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0108.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::23) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CH0PR11MB5492:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e701b15-7af4-4e54-57ae-08dafa78fcb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S3wt30k/VM6Ef7OUKjHzusxMiGyRDL7Bq+LuMhxauqNt5lXCv29IIpdkNOo0revZDwhwpwJbwnqnGiy4EVs3pclNo/j+sr7Z6txrp7x6AVfbzNl2cPjTyY/Y/nfXAaGd72xFwqcLAnVU+5YC6vGtiUFfjPhk/5PYQPicCBwfZkm82cqiCYt5iYzHnU4m/hFg1T31vkywO1Ec7oWQp1M1uA0VZ6ruv/RlC/UfeGs/tV8UdlKii8LK/BksswsRrJ3Pi8u8PkI78q+Nd6+SWZQpWaMtxbhI4ms49JQK4UL29XiibJU58gyY70mnzF1gLxJuPtTa3gbPGGP/jmQGR0LNFCqnE3ghA8gfZrlW+CiAPOm1lE+x3euR6Ybxg5JlDyQYpqXVxpEcEs21ZZ9S6NcwqOpKUINkPkRCLJ3bGnHmz409/BSuv3gBZZlrpDZUxiDLeP0nJw6ADsXaeG8V5ARJQszumkEphl0TNySTbikifzHBqlaIYRLRmXs00EClLVoSe9gqqrd/coo4rrzFWf8AA42TK6Jbu5pXnsdmSxvre0/N2koowIntZivQi0gxeeaS+ul9DEfSG25DMwBsjx/nNhIrVqMSvXJr0cWyzTQmqTkc7LHoFMFk5xZ4HmgYdlRgJC3Zh4z8nF3j+7UuzmNopJlC1HF7a7H5E9pvyqtEdALkY9bqxaiqWZJNSeLszBQruZgoTlsGt9H62tIgDYFf1ppl64qqrzLhHe9LWGXgVDs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199015)(82960400001)(38100700002)(36756003)(31696002)(86362001)(8936002)(4744005)(5660300002)(41300700001)(316002)(8676002)(66556008)(66476007)(66946007)(4326008)(2906002)(6486002)(2616005)(83380400001)(478600001)(26005)(53546011)(6512007)(6506007)(186003)(6666004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bG9BTUxOWDRQTDBIV3ZKMWxOQlREMU5IZXE2QTBzZW9aNUE4eUkvN1dFTFg5?=
 =?utf-8?B?cjhkcld0clRpdEhScjd5T3huejRjTmJCR3oyZ2daREEvSlVxZVcxQ3gxdE8v?=
 =?utf-8?B?aEFhTFBRYkZVN3JMSG5OWjQzNmh5U0xhK0dpU3ZLcG5LY2ZiTU5jUVR5b1Nk?=
 =?utf-8?B?SXNvSFBKcW1DRktYWC82UmRQMStLZHBZWGJldUh6V0NoNlJlMmJtZ3dydjRL?=
 =?utf-8?B?bitCMnJ6akdjRzVUVHV4dVE1VU9nbHBia2RkNkJqY0dBMTQ1UkZVUDdSbERZ?=
 =?utf-8?B?aW1wNHZFMVU3cU5PZ2JCOE12RFNGeXJTSWlsbmVFZElRWlhvRHZoWldpZnlV?=
 =?utf-8?B?Uk9iMkQ4VC9tTjhRbW9ZVWpCZnUraDlkdGhiU0NIVEpCanV1WUtuUjhhMFRi?=
 =?utf-8?B?U2RKWlAvbXgrNVl0N2VHSUdxK2NrOUZZZ3l5Wkhha2FydkZvQXNCa0ZQT0g0?=
 =?utf-8?B?MDNTUTRWZUwyUzlNZGkwNkNka3JaZzBDWldwa1lEUmQ1Y00wemMySHhxOUpP?=
 =?utf-8?B?bWhnczFTbzYvZ2FqanA4ZWxaU0R2WU1WTVFYNFZ4cmVZcjhYa2NmMEhIZExH?=
 =?utf-8?B?WE4vdWFqa1N5c0VBRFZSRmxXZ0lTZjBKTkdhbUlqRXFWSmU4KzIvRXR1bTB4?=
 =?utf-8?B?enJWcmxDSTllL2FGWE9XMUZLMndsTXVQak9xL1JWWnVTVkRoem54T3lTWFBq?=
 =?utf-8?B?NlhWcEFkOW5ITjFHeTlOTlR5OXdKK0NMeE9PczdnalA0c1dwZGxvVWpIbTRk?=
 =?utf-8?B?d2lndC9iTUN4S0FGVkpZZGh2M1R5MkVwb1VPSGI4K0Fqb3dteTRDUDR3aGlk?=
 =?utf-8?B?UGd2Z3dRUmJncjlRZjNlU2Q3amtyM0gzaTBiQXFRVTdrSXpsVXkwWitnLzFl?=
 =?utf-8?B?bVlINlFYTzkzd2FGQmJ3UlFRRnA3V3dBN1VUbWlFOEpFRzB5T2J6SndGTXQx?=
 =?utf-8?B?emNGYlJuUm13UjJXMS8xYmtwOSsxLzdSd1pXbUowWE9zM2pzS2c5cWZsQTlZ?=
 =?utf-8?B?VzFQYTljbjh3WTduTmViSjFIb3RZS1h3V1Rvd3I1VFpRTENnVUxZcVJnQSto?=
 =?utf-8?B?UVVEemUyNnhxVDN0Sy9DMllhT1hoRFZ4SmtnQ3RTMEo1UnNWYnA0ZVFNMmlM?=
 =?utf-8?B?Nkp1YlFMRXIxcitJQnhVRmhlNzN5bHM2eDF5LzJPYTE2Yk11cEl4ckNoMnBH?=
 =?utf-8?B?ZnRrTUN3QmM0ZHoyaXlEbEttU0JmVXFxaVdsZk9KcEJCREVyVWJyQzZSV3Bi?=
 =?utf-8?B?S1pzbFhCUGphSkUvS0JQdENudEtsWm5qaEFBd1dhUnc4cEdpdlB5SEs3aWlR?=
 =?utf-8?B?UUNlNXZIaHJRcjVaT3FFcGlTVjVIYjBpbHVEVGpneU5XaGdyUHQzbWVKaytt?=
 =?utf-8?B?OVVoR0t4ODlSUmUyb1h1QWVqL2l0SG01WEJkNXBXSTlOQlJLZ1FkQ2o1M2JN?=
 =?utf-8?B?ckFvTzlha2ptdUEyUW9LekpaektRa3pKNlJxT1cyZkhXdkg0MGZDenY3V0sx?=
 =?utf-8?B?QmVDMndqNlR6Uzd3ZjBhOHNBVTFoR0xzSHNGMy9MOWpUWkF4WUJFUXJ4dlNu?=
 =?utf-8?B?SEt0ZGZVTnRzZnRRR21PS25FZ09za0NrSWhTWlhzbC9lN2tmY2wydG5aQlQy?=
 =?utf-8?B?WFJHZTZhL2R2aHJjU2xrVGhoOHMxUHEyZnF0aWFwenk2YU9oQVFyOE1oZ1Rt?=
 =?utf-8?B?bWpmTm1YVTNxeE9lYkZ5VWR1a0pvMG05aWUzeXlDLzRwOG9yK2l6ZlQ1c3gw?=
 =?utf-8?B?OUsyaERNNjhyNE8wYXBVL3RBQlVXZmxwTkFNZ3JvVGJnQ2FxZlRYNjR6Y3dY?=
 =?utf-8?B?bG16cGhPSDVSVTVGaCtkMnVoVWEvZWJwM2d1WVpudU9tUHVncmc1QWdrc2R0?=
 =?utf-8?B?VUxOZWw1M0l4R2pBVHVnc0xCd3Zrc2lqOGJFL1k3SEU4RUkxNzRtY2Z4Vllh?=
 =?utf-8?B?R29wNFIwNk15MERiaHRLYWpEZE1reE9Vd2xXYXpQUktTVmplZ3Nnc0N4eDJW?=
 =?utf-8?B?RkFvK2o5Vjdwcjlqby9zMXJCUnhBbDgrbzk1Z2pjc1FBaVZNUmlWSzkvV3Q3?=
 =?utf-8?B?WmZhWVQrZUUyWG1sNDA4TC84cDJmVEUzN3JUS3cvdUJWdWpWMmw5Q09FKzFD?=
 =?utf-8?B?QThrWkdqVGRRVU9rNXBxd0xrZEl3eGRqeVFnNEVaU3JURGF5NWViRGgybWNw?=
 =?utf-8?B?SXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e701b15-7af4-4e54-57ae-08dafa78fcb2
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:57:57.2817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0TdL6gqj+9wcC80urBqKWMcpO3KF9PDSpPisrmMxNSgBwrnLf9f1yMC+UCQ2pCJCpCies5Yq2qUeX7mKRL6xxq6JIHVmA6KiDeFoZnyjSbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5492
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



On 1/19/2023 3:31 AM, alejandro.lucero-palau@amd.com wrote:
> +int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf_idx, u32 *id)
> +{
> +	struct ef100_nic_data *nic_data = efx->nic_data;
> +	struct efx_mae *mae = efx->mae;
> +	struct rhashtable_iter walk;
> +	struct mae_mport_desc *m;
> +	int rc = -ENOENT;
> +
> +	rhashtable_walk_enter(&mae->mports_ht, &walk);
> +	rhashtable_walk_start(&walk);
> +	while ((m = rhashtable_walk_next(&walk)) != NULL) {
> +		if (m->mport_type == MAE_MPORT_DESC_MPORT_TYPE_VNIC &&
> +		    m->interface_idx == nic_data->local_mae_intf &&
> +		    m->pf_idx == 0 &&
> +		    m->vf_idx == vf_idx) {
> +			*id = m->mport_id;
> +			rc = 0;
> +			break;
> +		}
> +	}
> +	rhashtable_walk_stop(&walk);
> +	rhashtable_walk_exit(&walk);

Curious if you have any reasoning for why you chose rhashtable vs
another structure (such as a simpler hash table of linked lists or xarray).

At any rate,

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
