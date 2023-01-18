Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFC8672A4C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjARVUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjARVUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:20:48 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E29303E6
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674076847; x=1705612847;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+O6ifOMy1r/ykeIdzdueBJBrrzvt3AiulWrzPcTfd40=;
  b=UCpHtfKo1Fli3cQ6CX9Wt/Mgz3n/HAMRWh3Mk9K1pwc2mgXqZ57h+NBD
   IxMpgqN7FN4pfjw2LY/Cj2het9nl+BMAcOF5S4BGFWd3qF4hTPwNjEs4i
   dh39nPh+Ogi9wCTWqmg8E5qqmJ2bcYMTWI0BrqcRQq7J74p6czo4vv+TW
   yypKipa6BGqapDGbp+wAPnSbJMT4Q0pfccsF/VcX1WfQCgduEmjsRvgLk
   4UQBTEEunwNJVN72x8kLZ1JjNmOOHUaPyNMo8YCxGk2cUmrm34e4cPv2I
   g9iyd7rt0TtsalpQt43zS47vWNY32ozsXJV3azqUHNL8DhnEqUlJI9tPO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="411344659"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="411344659"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:20:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="783827536"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="783827536"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2023 13:20:46 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:20:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:20:45 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:20:45 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:20:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8uTnJ9x9gqnpHJ7CRmPCCOOwGOQO3J46dx7LPXAGaR1r5MHGHOXRGLGq9BEd7BeJM9dWJpqsDljnO3rbHxrE2V5P9G1FGiPtvoAEeHTWXu5yASYirvLKsS0w+ih0nmWZGT4SLAcWetrIiAxHg3AyNZ/vFRM2FfJ6jlga/U/gfsgK3Ndt3mXaa1mHkc8G5p5c8M0+/YYMV7ZFX+cNyg8aCxmlJejKfZppar1Snk8YMxpsRwaVHyjpCb1BLk0PV/kPQhkTNvuLVEqv9vzZ3G0n8AXBUlkbxhg9U/z8MqPicda8YRIYQeE/UxQY0WeV75K0I3J7bXzwUIG1TbFzdFMHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zDTfoz6aKeWTjtiRsQM1Y1qejW53CMUWPUXJfBNqNQ=;
 b=dtVDj99TRavebhwXtPo+uKiQsSvGjJFOrX1QUFw3v+EMF5Na/w/voPV4rM2QgS24xvEIHuKSX6KTxo3sM0TIbrMP/6GRJJP+MAubjBVWOAM/F3w8MsiWodZHXokOIjabmAkDIAp9ANIsb31qWdyBvH52t93D2u2XrtMN/KPJA4M3Ac0TNWlSj+dLigm4yAT4dhvWOTC9x6/uCqs05AAZ8Fm8c8yXIX3bjpneWFPGxl9T//WN2kwSIdnqXkSQWIAHLQ2uvptCT0aIv4hCJduPRUClwtuc8+7ZcEPEew2eVEWaE9fmZ4KJ4MfoS6Yr/BbYBL46r4izt+VIEaTfhnZIMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5366.namprd11.prod.outlook.com (2603:10b6:208:31c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 21:20:43 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:20:42 +0000
Message-ID: <df57ba1e-3052-df65-a94b-02be13930a61@intel.com>
Date:   Wed, 18 Jan 2023 13:20:39 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 08/12] devlink: remove reporter reference
 counting
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>, <gal@nvidia.com>
References: <20230118152115.1113149-1-jiri@resnulli.us>
 <20230118152115.1113149-9-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-9-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0183.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::8) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL1PR11MB5366:EE_
X-MS-Office365-Filtering-Correlation-Id: b0622160-8274-4ef9-bccb-08daf999dae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: saYfS7NIzwnJ36wA4KrxwATyzP5oRqDUO1iU5YIeCAoZRH1szDxWLtK5IXOREc+PHr6GdFirSCtO1YvOGR3m5vdf3avgRkSoCpk+f977Mae/jtrAA3rH0UuAvfGlKDkdYWMFJHdCLGLmJzWjUAN4f/ZKXMbJgWP6xGuITDODoyWJGcKQWhaT16/aQXt1xXcDRL1Lgr2snavlZIyjgIPh0HCt0MWfvTOm20xczBi9k25/9glpkRRWji1jGYIx9Bya2ijgYrHdFlhoBHXbL51qMyWDGe/0WrtJdS3h3eUhAe8bJfM8bZ6BUdRSbRJkebtzrOoLwhcIVhpZkn++JQiBdwrAH2Anpy0Lft1YXpqiA9OVFlduDrsD8miu4P3OoVqNxqy+RJDNL4Os7IKldwbuZqmIpfPoIENffo+susZc3kIgB7Ahj5c3qJTmLcLOSwSoy/GkKDcnMyf1xc5+rKEkzu3xmHx3cEUyTt7ZQyxgqIPOIvdihMx1q5B+3dCDiz88D92mpdJianPtTlx2LmO4JZgkGxz2EGbdj20T7rmJyzW7+WaaXwFSKGZmxwXdGrCgWm15mU177VHrwc62vSQhaL/7o0Rf4NdmrmC81W5ZfmeFReZ5aqUC54YLHtZEl0T5vYDgvJIAmZ6G0qnHudxcEsdzhQDOqmJ7eEqBaFlXJuDK35nkGsJAnw1RtBtLK9N/q+ujJ5Oof1SLYfHmtAsXfTdSBvP5D3sOn8q3BDu32JM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(31686004)(36756003)(7416002)(38100700002)(86362001)(8936002)(316002)(66476007)(66556008)(66946007)(8676002)(31696002)(5660300002)(2906002)(4744005)(4326008)(82960400001)(83380400001)(6486002)(478600001)(6666004)(53546011)(41300700001)(6512007)(2616005)(26005)(6506007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aSsxMFlkaVhWejdhL0h2cDRkYlpJejU5Z3pqR0ZtT3c4WTd2cVR2MVpKUjhn?=
 =?utf-8?B?ZThmdG5NNEVvK1k5cnUxTlBhbnh2K0hNVEcwOXM1T09pVWtGbUJsZHQ2L0w0?=
 =?utf-8?B?Vm5VZTQyMTQrODl5V3dQL1dzdzgyNzBtb2RBbGZmbXJCNGMvTFJxWlZoY1N6?=
 =?utf-8?B?SGkzbk9PV2x5R2p1dG44cnFOT2FTcXpQVUJ4Ti9KekJHQmFNejVBMkdzK0JC?=
 =?utf-8?B?cDRoNHNCb0VQR24wa0ROS0tyN0QyNmpoeUkzbmJaaUJvZHpzd2NvWFFYL1NS?=
 =?utf-8?B?eTlKVkQxNi9md0NhbjVzdlpxZkRlZUo0MWxaQVBVTjk1bTB0NVZvcG50T1A1?=
 =?utf-8?B?MDl4a1I2ZVZWY0hrR0FzaXc2N0p2TnRLZWVuWmROdE1uWDh2cFgvcVI1TnNy?=
 =?utf-8?B?SHNhSmY1Y3lsTzRtUnRKOEtMd2pLU00xRk55NENuUjRXRm5lYkcxZ0NxMHV1?=
 =?utf-8?B?Y1EwSGoyS25SY0diQWgrSUZ6ODNpeXhKcmMvUUQ3ZzNRdU8yNXlaUTVNOEk4?=
 =?utf-8?B?RzVZT3FGRGpXQ2NuOExrTzRMc1VQeUM0RTNIdDlsWktTS1l6S1hVQ2tqQXRa?=
 =?utf-8?B?VkxRZC9kR0paSnlnV0VZbDhZZmxpWGhCMmZleXZ1azBNTTdQZ05pNDMwVXBr?=
 =?utf-8?B?WHp0Tk55cEFKZktkVzBkY2pVdC81UVh4YUFlUkIwMmQ2VzRLZVZXVmtaVDNM?=
 =?utf-8?B?ZkdXOG5JdWVEQlRibmZFRm1teC9TWlNMUERxdlV3bmg5ZXZWdEQyY0IrSm9N?=
 =?utf-8?B?VmlEeXBzM1FBblErbVJieEhEYU5UVitFYjkra2wrak5heDVsKzE0R3RTVUVy?=
 =?utf-8?B?SHNnV09BUnpVc3JMQjBYMHdxNVV2eDlZV0RwRnJ3cG9RcE9pdmlUcG5XK2F4?=
 =?utf-8?B?ZjVUZDBkb1BMcWZHdWZtSlpXMnVwWWxjNlFyZDVqVUI2TTdDZWtBS0dQTTdn?=
 =?utf-8?B?cC9lcHpteXJQNzJvdzNEa0VBdzI4Wk0wUTJPK0VxeXJaSzB5enAvNk56YUFY?=
 =?utf-8?B?R2ZoY2xQekt3bU5rZEJQTTNYbFlPcnp1NXg4b2Q4Ukthb0pUWDdWYWt1cGtt?=
 =?utf-8?B?NlVaRTlKYWluMkIzVS9TNGQ4MGNaRzU2cmRESFBRblUxZ212bGJVWFhhZG1q?=
 =?utf-8?B?bTdFQ05tQURrM1hydEdQVUwxdlJJM2g0RzJiZWppUDBsdCtJVmhHb0ZpT0Rs?=
 =?utf-8?B?eWUwbitJY2NtRUpEbEpTcmNhRnZMWDh0MDc3dmh4bHhyRXNmV1lpV2RuM1Zi?=
 =?utf-8?B?RjZkTDhsTFVKUTdiZnVXeW92WHAxT2hFWThRMCswc2JRMTl3ekN2Q2p5NlZL?=
 =?utf-8?B?TkE2RDR2L1ppejB0L3dGZlY4dlJpUXRkdDEvMll5S2k1MVdkMTlhbk5HekZz?=
 =?utf-8?B?YjNHVFpBM2VtUTRQclFDMEN3OVhGOXhkN084NG1RVVhGNlk0UkdJWUQ0UDAx?=
 =?utf-8?B?RjdlQ0dCbnFPL3l6MS8wTWtSbThVQzdmejBVSE40SU9IMTJDTHA4WG1jR1I0?=
 =?utf-8?B?OUJhZit4a2pCL215b3FNTzRUSmtQd3RXV2pxUGdyWjBXWWdhT3VNd3RLUjVJ?=
 =?utf-8?B?RnpvMmllRU94V2ZRcEJLZnFDRXFrR1krTk5lazljRzYrNnlaQ1k3V2pEVDgy?=
 =?utf-8?B?TFJaeitjbVNXV3JkWUhFTEpybEYyd1kvaWVWcmkyVWN5YlE5WGVOS1RYbU83?=
 =?utf-8?B?MjMvbHBvRjFGZFR4OWo1QW1kM1FsWHRTb3E1TUNuOWVJUlVkUjFDMzNFc2dU?=
 =?utf-8?B?MDJROWV3QkJJVSt1VTNtZFExQU83Y3NLVlJjMzNJZnN3Y0E4cVVaRk8rak15?=
 =?utf-8?B?R3NVTlRKSDJwbThmTjU5ci9SOFk5SXg0WHVMbytrdzU5UE5SYXo5MEQ0QTZ5?=
 =?utf-8?B?akcxTk1GLzZaRWFzUzZySUlaYUIrVmdtUitDNkVFS1lmdUJRbTdzMHVZK29r?=
 =?utf-8?B?UFhYN2pjRTUxa3ZuTXZTSGh6bytybUxFc0dsblVSZ05sSHUrWWdzcHdhT2Jl?=
 =?utf-8?B?aHlHS2tkOWUwK1l3K2RUVEo5ME8wdFN5WjdqUFVubjVlNS9XWlFvaXVqNDhW?=
 =?utf-8?B?K0I2VXY2NGdFc3B2eko5SGc1MGlmWWExWXBQWTB1V0d6eGxVUnpuRllaN1FW?=
 =?utf-8?B?NWdCSzIxcFlYSVc1eFNVcVFIMkVDN1R0NCtxTGJFOXdrQ2Rqd0hkdGZ6WWo2?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0622160-8274-4ef9-bccb-08daf999dae3
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:20:42.5735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qGEvzAoqsl/fiP1zsEYCYQIibX7GyQG00Bjn6GYoDalk0ZN57cIgblu2H7KyiLt5FoN2acSwxFXl1mRa3pUH6V7bOrooqGUewZaieSFu6c4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5366
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 7:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> As long as the reporter life time is protected by devlink instance
> lock, the reference counting is no longer needed. Remove it.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
