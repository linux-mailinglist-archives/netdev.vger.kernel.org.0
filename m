Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA7A64E16F
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 19:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiLOS7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 13:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLOS7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 13:59:30 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4361231DF0
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 10:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671130769; x=1702666769;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZmJyQFxH9tp6kf+2ySQ3/ZUhc3wRJRRwjb9c2sClI70=;
  b=J+TItmj6rid2EfAWR2HLO/CJvhE2kv/3JrjYhgh2XTbSd8d6obr//lCv
   Gkb+4HVlKRIzRAE4a5b++fQBhVqZqbXCNxEaJmM90NsWup7LOWrCHyqzN
   wzV67An5OmZMnQDLp+OR4h+nNXgQBy6JmQv1vGf7xrzGEoU8PXjV2J87Z
   no6vBsi8qwmcYc0NyIhMDNdEhvLvQSpWdPolSXVFPbynnFjAnhWU2VFBN
   +x53A/FsSgdI4LTEg1szbQspevW22cc+oDSxvWGAeRBI6nMwTFtJ2EQcI
   2p4OvHrOuqtX2XgdY7yZjeij9GkQsb9NqUyofqjjvpnO9gLmVIQl6ACBA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="299116560"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="299116560"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 10:59:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="756446502"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="756446502"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 15 Dec 2022 10:59:12 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 10:59:11 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 10:59:11 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 10:59:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gabvmXNPqeB+lEacmj7wqA5khw4eN+v66bptSIzScyeCKlgRZrQ3q2SzaUECo1GzipSL0iNq5Z5eEDdRxbU8zLEcLgxIXX/AbZtiuZIeaLSx5JXcsXSo6+wNxUg5DYT6idkVKo0x8nsJPMeVp3Tsem6i9LdLzf0P52Y1zpi6As+n+zTl393nBQd0MjbBjyk5pPna5WQBtiEtVfVaS6z9GITViyMVoTjcPJttODa1hfsHOiUX37WQfo33iL2n/eH63X+enzDtxdb6flUs3izhKaRsuJRSNY2ozPHuPKadt4Blr79tat0dhYAza56qTYRJK7p5IJq/xZmExrJISlFOfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IP3Kdm/pqlQGAJOrAplAcMjyh++PBdZMUXS5vyMXxCM=;
 b=RlX6rswgDVJnzFkRBwF6O7YwMRIh4sJ+vHOAJjkrqxiCC0hN1wSGSTKnFy0ksjhcnJ408k117Anh5pWDqd5c0iEfOfrM4sESft++m1tfLQ7S+/wkh7f9gQms+QZTdFGsBIXfW2cjH1gyg6oT1xS4C3HG89fNh1HnsEpQP6pIoq1pMcs5Xm3YUZ+x4bY9Ys2J7t06KwF8WrdVcAUo7aWbUDJ/GsDQxQ4IC2xPBwk/PifRrMvnNJQhnzDWlUI8hyIjBqQNH5p0SkLEWL/tVWBAJseJimTI5nn6itSF6QVQO0H4yyTULL9tqCgLtl6aQ+V8ZhH2D4oGD/UNCEB7OWn3Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB6765.namprd11.prod.outlook.com (2603:10b6:a03:47b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 18:59:10 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 18:59:10 +0000
Message-ID: <224645a4-990d-8c66-01e0-497a3f5f94af@intel.com>
Date:   Thu, 15 Dec 2022 10:59:07 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 10/15] devlink: restart dump based on devlink
 instance ids (simple)
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <leon@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-11-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221215020155.1619839-11-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0210.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::35) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ0PR11MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: 95524a79-4f7d-4d12-a0f3-08dadece72e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wtBupCCaZE1WftZ1PwOTLQLyJLfbosZrJouOilaAQmWwPFAVuMxCSJ5zBfwN9y2L2BVHYMliMQobbjuldNeyWpPkbAdjDfQuCvRZS3hOp0HoV6BaLvUrDvZUO+lJVygSQ+aM0V2ROgygMCJJsWq4M/D8q4+iW0x2LyPtKiyZuYJFY38XgHZnvyXLUeLov52WzE7KCroONnyQF8XLVnG4jARb9/vN0k3zH+Tx/wwDdb3kEmaAFotr9tdw3BKLMB2m45HEfKw7x08Fzpe2wDdila1sqolP9O/U/5aKxnBnO+zcn8eyb1lJfFDoy4C7JHhh8O4fc/D5e4OjQVwau+hgqd/pZnjMYWvX3EheXVroH8e1IKp6jMkrJegouGxN6MlbUn7OcWdlBZ7ma8kbi1m8m7fm44VFCrbcwBqLLdFm4TQpaAQmkLyczrBrlQvGpoP4z0ZUDlDUIUXrITO2DgXxxMhWxN22ZZNLXOM33/SnpXej8eUTR0pQRfaS4ONexOyfLZgFX3RFQY/KzbYE7s7ployJZIEwqPDgJoe4fl47bwO7HBpxwgmDVXN1X9uE/SbsZA13Q/N3BP9WMk/+rALlAD5td+hhUmoW55IJ0zpWztmQHFXVajk+VBZm0yzkbUr9+JQhqEhPIRNUHivQs+ZA1VK9V4tSl16id4X/etPh25tW9mE6jhJSvmflJUaI/m1zznb/glG3rpvaakYwWw9Uhi9JnoGN8PJTQgbSlkDcTBo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199015)(6666004)(6512007)(186003)(53546011)(6506007)(26005)(478600001)(6486002)(36756003)(31696002)(82960400001)(86362001)(38100700002)(2616005)(31686004)(8936002)(66946007)(4326008)(5660300002)(41300700001)(66556008)(66476007)(8676002)(2906002)(4744005)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1M0WVUrSWNCYWxid2xBNWZnYmhLZ3V5Wk82aE5aWEg1T1M4V1RSeG1wd0Vo?=
 =?utf-8?B?bkdWOHBVSlJCdDZvOGNRcjl6U2E5UUZYQ2MxUmVmUVYzYk5MTDdtZkEvMk5t?=
 =?utf-8?B?bjl0Si80amJlWDV3Z3dlbkM0blRKTmtzdlR4cTNCSU1JeHhWaU0zRHU1Snoy?=
 =?utf-8?B?aVYyYUxQVTdWazkxWW45T1FjMUJPRnYwNGd3bUdqOWt3YlJ0Slc0djlMdG9J?=
 =?utf-8?B?emoxYkxBZ3dyc1VuYk9ZbzNMNytOSHBtSTEyL1hyV29uU3A0K1dhdUZrU0w1?=
 =?utf-8?B?RmtUQk5iZEZ4aTgyUlNWQWNNMVV4bUF0MXM4YzR5V1VPTGVhd0hXSTdYcUNw?=
 =?utf-8?B?VXdmWUo4aVlDbmU2ZmRIaFhPeURJb2g0YUR2MzM3VkM0OTNqOGxnTGlCWnFX?=
 =?utf-8?B?Zmx4Y2psb1lETWcwVGl2TXVycUcxbGx2eUVES1NoZU9Fdm43RzNWZ3p4bFRP?=
 =?utf-8?B?VXBjbWNvNWhxeklmdU8yT2lRT1V0dUJXeXJXMzhRMGNTV0FKMmt0VThVR3Zl?=
 =?utf-8?B?dkFNd2ltL0JGVmV2dkptdG1iQURyY0ZWSGpGTWdNeFgzV1VyZnFPak9WWlNC?=
 =?utf-8?B?anlrL3psSVRGOVNIRHA1azJSanY1TTh5eXNhSmVaL0J2TXFCUXRSYWoyRGRJ?=
 =?utf-8?B?NTFYRHVuK0U5NE45K25pR1d2dERkQyswdVZDSDhQekdQTUJuVWJ6bTQvT05z?=
 =?utf-8?B?Vk1Pd2NKQmVUSXZNcXNTb0ZzZjdGaE5iZkNncUsvR2tvOERCWEVDMnpST3ZC?=
 =?utf-8?B?RGlaWVN0VTYxUHY3bVlNOW9jMFk4QVAzeXBTV0FBZTZocXZwQ2kyOWY5ZER1?=
 =?utf-8?B?RFIrYTlpRTRZWVdOSXBCaHJvZ0EzSmhmNjFZcldiN2tZUVhkSjlsVVJybkk0?=
 =?utf-8?B?OFBQSlQvMHoxcnVsY3UzVnBTUVZVNlZEa25ScjRCT21BdURHRGt2SDR1ZE9J?=
 =?utf-8?B?YWtpbkxHZDRtY0JWcGJjV1N0UXdkelBMZVFRS0lrRE56VHI0MjJaTXdpdXNL?=
 =?utf-8?B?TVJNUituNnN0emxpeG9ac2tNeE82ZDlCU3dJRlViNFFJQW9ESGJRdkxHM2lr?=
 =?utf-8?B?RGFtZm1QcnA4VmJFOUtHemE2Y0tQMUVWMUFEOWQwaUtxUkJzSzQ4N3I2czNM?=
 =?utf-8?B?MzA2Zit1elJRQ2VzYTErODRqMTFRUzNLS3NVYnk4eHNtdmVJaTllTDB3enhK?=
 =?utf-8?B?bWd5dnpCc2FnUFlCZnhMa3p1c25MUGw0N1EwU2UzdXh0MG5LRGs1cjU3eWNT?=
 =?utf-8?B?UDlHcnkwMGt2elFQaG5iRTZxS09IMnR1SUkxNTNzdHNmSGNWK0tlTG81T0gv?=
 =?utf-8?B?M1R6MnFvMFBLZFZlUEpNTFUrcVdQL3pMZzFSb3dtVHdmTGdhTkI1bURYZW5x?=
 =?utf-8?B?b05TVm9jWHJiL29DYVRNYUVBcFJWdVhsdUVJTkhyaGlCS1BiZTd1RXZyMXVX?=
 =?utf-8?B?eHRmNFJISVovSm1MNklwUmtTeWdUS2t5ZHRudkdJQzJFRE1yN21zSkFWcnNi?=
 =?utf-8?B?aG44YStiYjhUUmpGaW5oM2l4bUpnSnV0dW5VdVBwVE9uWno2S0E4MUh0YVdM?=
 =?utf-8?B?QTZNdWlaa0l0VDFBOTJIclc3bFRySm54Vk9ZS2JMTzY5QW42Y3RCTWY1TVVJ?=
 =?utf-8?B?YWcyVlhXRktvdWErdG9DbUcxbXBTVWJseWRneXIzVmFzdE1lT2MrRWFBcFVI?=
 =?utf-8?B?REpaelQ2RlBVdkk0NWh3bExCTUlPNERTdndyZUEyV3U5cDJmTzk3MjYzWjg1?=
 =?utf-8?B?UThOUFRuaEpZYUFYWkFuRUlOR3VSNGtraHlpVUw1b2VuQ0ZUa3RCSXRoQi9G?=
 =?utf-8?B?c2NvRkl5VEdtNURSbUY3R2pWVnQveEpXazBVdEtzSkt6UDRvRjRTMllFU25u?=
 =?utf-8?B?RGx4TWtUVHdZU05SSnV5NjVpY09pNGhGSllWeGs0SXFYNGFRcEJEYjEyQjY5?=
 =?utf-8?B?UE5FQXArSVJUanVrbXFRM2orOTMwc25GYkFKaTJqd3ozSGk0MXU4VW9GaFJp?=
 =?utf-8?B?WU9qVkVIdVd5V2JSRG1pRCtuZE5Eb2tsNVlydU92cmlTalh4UW5SMWQxazZl?=
 =?utf-8?B?RENqbG1xd2JHQTB4Q29xK080WTRBbm5LVFRSNTlvL2kzczE3Y1pFMmJYenVS?=
 =?utf-8?B?T1VwbG42U0xqUDZ3Nk1RUURYc3RaZWVHQVRISGVQaDY3SFhYTDlWQTQ1K2Zo?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95524a79-4f7d-4d12-a0f3-08dadece72e2
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 18:59:10.0162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: seQwUbys56TnEOyIXbJqFEk0jv4iPbYw/ParQUuNdz0WNiMpkSw8eBWP1GHeTNXZ8sbaBN6Up/sfquv60+psC6UiJlqGabMqfxSaikgp7r4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6765
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



On 12/14/2022 6:01 PM, Jakub Kicinski wrote:
> xarray gives each devlink instance an id and allows us to restart
> walk based on that id quite neatly. This is nice both from the
> perspective of code brevity and from the stability of the dump
> (devlink instances disappearing from before the resumption point
> will not cause inconsistent dumps).
> 
> This patch takes care of simple cases where dump->idx counts
> devlink instances only.


So with this change for now dump->instance and dump->idx will be 
identical, but we'll slowly change the meaning of dump->idx with each of 
the following changes as we expand the user of this macro.

Nice. Keeps it simpler to review. Thanks!
