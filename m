Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983426511C2
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 19:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbiLSS0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 13:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiLSSZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 13:25:56 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9569FD6;
        Mon, 19 Dec 2022 10:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671474353; x=1703010353;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bnQ6ftWbK4PQ4r4d7fCRUWH9Of6un9vHvZwBZ+JsYqo=;
  b=f6dyvGdjuVpDcW/jnCO3oeU/nyVCcKyIsWdbaAoOFOWlkOHDe1XkBvK1
   1vs2b+h1Vt7I2UtaCZ6v7L8JsdceFMZAELNckXN6qCxFg4vMM9PF9nM/M
   krSsenb3SgsyKSmGIUDGGqC2K/Kw5hX6Ll2IHK0d+tBzuFtU22HJPn9mD
   aLE6vl/LlYGrmRIUM/7yBqgw4WyBzTVDO+OEdUug1x8lL9Yu7T6fBRiYU
   sPKib1U8lzmwSSmxWV5aJFJcKs8sJNa4cDrRbZmGfAEa1DkdoCBKkjwFn
   Nkie25lbPF62Rf7RYx/WeBqhpUI2YhKMe6rUBrE8mVc4FaD6UANAoKPk9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="299760105"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="299760105"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 10:25:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="739442781"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="739442781"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Dec 2022 10:25:34 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 10:25:33 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 10:25:33 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 10:25:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxWuWfjWPkeJG7Sh9Bt89m2VasRGdijIdaW9bld848Ymu/06cKWzrROSRrlFbIgUsw5oCZmEpSCv4w+pqsqBQU2L9h7teIJfipw0ZyFP6e1s57QjGHlAhYTdT3Qro2iBjPqr37ox/9ZsgydDpoP9VnQgRAB4eE5pfTWqoebloPNqq7TSJehzwod9d/znplfpEfzoMOfqwNfchbRObR9tRJiIxhtpUy3YMO036Bu3pHxCe6jNOm4ossp8lS4NF3KA069P1WZ0Yn8eksMxIb91jFezGb+KlGW8juCj9buFIQa2/SYnoeUvwCP8gSsxbAHOUnRoZ+bEN4HlspH/ZsYwKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bnQ6ftWbK4PQ4r4d7fCRUWH9Of6un9vHvZwBZ+JsYqo=;
 b=fojtI4tDA20SzXF6LnrgLByJvrx/idCM64UWnoKRqZg6eiCnBraomTuye94EUws5RWDf26Jop5iMVFwdwR1fia1o0dMksBXMBUAY7z7fbuI7TlSL2pGChk1IrsnOIH8IATavlZV9RmB9GXHZW1xXY8xrzG00TEVxjJJSYLgu8TT/7FsDW6kXSomDOXa35/4W40kPoSciDNdY2B0sKo3p788sS/bTAVf3ZLoC39Vlq3wPsLhn69hA8aAEg2vPeRrcBknki8/D3PVG89YjkcC7iY5ggvycG1ty445dlv9ovjXyYLtECUavKvuu6pC4zXI7nLeoFGW24HbShEo0z2zRxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ1PR11MB6228.namprd11.prod.outlook.com (2603:10b6:a03:459::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 18:25:30 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 18:25:30 +0000
Message-ID: <72641fb1-f547-197b-b319-ce3b943b192d@intel.com>
Date:   Mon, 19 Dec 2022 10:25:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in case
 of invalid one
Content-Language: en-US
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "Lixue Liang" <lianglixuehao@126.com>,
        <anthony.l.nguyen@intel.com>, <linux-kernel@vger.kernel.org>,
        <jesse.brandeburg@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <lianglixue@greatwall.com.cn>
References: <20221213074726.51756-1-lianglixuehao@126.com>
 <Y5l5pUKBW9DvHJAW@unreal> <20221214085106.42a88df1@kernel.org>
 <Y5obql8TVeYEsRw8@unreal> <20221214125016.5a23c32a@kernel.org>
 <4576ee79-1040-1998-6d91-7ef836ae123b@gmail.com>
 <CAKgT0UdZUmFD8qYdF6k47ZmRgB0jS-graOYgB5Se+y+4fKqW8w@mail.gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <CAKgT0UdZUmFD8qYdF6k47ZmRgB0jS-graOYgB5Se+y+4fKqW8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::38) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ1PR11MB6228:EE_
X-MS-Office365-Filtering-Correlation-Id: c83e6cfe-6e73-44b3-4212-08dae1ee68e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5WvZQ3H02PAcQJxZ6n4Qd4zF2aKDUs8Ioth+YiDxOwbGYcb6NF9C6hr0SGe/cn2ZroFLhEI8fPwRwciXMR/WkcqLp29+dAWGzPzba5hda7il9scLPmn2rkYinJJ5ms3P5p8+WAlzpyijhhLX67hYrd8rBn+tAOWJ4uwU14N4r6lNrnJ0Sz91uzpH+CBoRUKy7H5fVx1FUyXNrqjsanHKSPyaaGEYC1hSRBtFv/stG3uvsu4VcgvxanJzHBUAAcDsYq+OHTMqbYV8XLRXFEJeNTk4BpdgPdvgeo2jcduC53GXnixz0Z+WX1SWgnZ+8XbGB0/QDkPozAqUCcKJsXP6CT41N0EdLfMOkHpRUL5GJC2ZJswrPbg+pA9mysVVaYrhhFgZMUa670qDaGxq2xlMrCDgap3SnPEHjxn2W/5FLSHXKZYzf0waWZaNpv8HPvF65h1un7yYoE/9tVWdPoQRya8wuKfE/7P01V09dJiYPT1/3zdtnJUiPDW4TQyCevlPWL0sKUd6rwkghSMEa01Mv1/Kxf2wgbdDR8G9N8I6P1oi54ndjET1GhlE2tKLz0m95tYb7kO2dI80U4Y06ptRxnu0Hpu7Pz3Kx38Oi0Kvza+dzvrznUS64xhcYJdjNcklQUZcM6ORvaNPlI2wh1F2QDcx05jA75H7iVbQtNZBhlieq7/sTJm0LQCvCAIaSOK0HIjI/KKO7RidhHtxHdf3ZBgJdCVQDmfjqDLdZ2PpK4Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199015)(38100700002)(54906003)(82960400001)(478600001)(6486002)(110136005)(2906002)(7416002)(31686004)(66899015)(316002)(66556008)(5660300002)(36756003)(8936002)(31696002)(66946007)(86362001)(66476007)(4326008)(8676002)(186003)(26005)(41300700001)(2616005)(6666004)(6512007)(53546011)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkxYb2xabW5QUUNLTS9uNjF3czh0bi9mUDdiK2tPMUcxa1NqQlJubkIyenZL?=
 =?utf-8?B?dnlUNkY3UzQ1UnVZc3VoMVkzTm4wbFYzeTE5UDFYMVV1ZlZEaVNZNnVzUC8y?=
 =?utf-8?B?KzdvclhKU3lSZTBnSzZUaXRwTE94RFhrYU9iTjYzcG5qSFJYa1FGRDBVK0ZK?=
 =?utf-8?B?WnFLTFMzejR5N3JaTTVmQysyek9nYnQ0c200YStGamRFTHUvWU1ROXdlL21n?=
 =?utf-8?B?YkJiQ3VzV1FrTVVpMlJRajJNczY2SXNHZXhWK1NNaUIwOXpVOTU2bTNWZnEz?=
 =?utf-8?B?M0swdWtqNUFYbUtnd0J4SUV0UXcxT1gxT2RtUllPSlZlc1k3cDZFRUhYWUJY?=
 =?utf-8?B?U3BCUVJLL1pJZFo1ZXlzeTU0bk85QzExanJDVUZQcVJPV1lidWRTYXJQOHkv?=
 =?utf-8?B?cURhOUo4MStYRjVIL3hFVjYzdGhsVENwdUFrVnhwM2FjMW1qenBETTVZcjB5?=
 =?utf-8?B?ZFl3YVFXMlFVY0FITVdvOXoyYTU4L2dFOFVJV3Z2b3hyUlJWNUwzTzQzaHg4?=
 =?utf-8?B?YmVNQ044bjU1NXRWcGM2T3dWT001bTVMZVdWUG8xakVsRFBTL1hFTzkyRjc0?=
 =?utf-8?B?b2E3a2R0MXJSK1N5QUNGelJMTldDQzZrSkhXdWV5S1o2REtRVzlrZXY0Nm5D?=
 =?utf-8?B?TktBMkMyUVJBN1cxU1haV0Zra1N1Y2d0cHZLNTBDVmZRWDlRdnI3Y2h1czFo?=
 =?utf-8?B?RE84UnRlSi8xVnBvQXRRaXlNQmVkWnRCVGt5bXByUmVqQ1QwN2VtN3RKVTVr?=
 =?utf-8?B?WjI4NTdTWWtxS2NsVmdZYUMvcUMwNXQxaStxL0FtYlVQdmNsUlpiK2syU1B4?=
 =?utf-8?B?NTk5SVhPTktrVmRkbWhucUZxb1ZXSFNaenZrTjVkeXZGekVoNGpPTlBCcC90?=
 =?utf-8?B?YjRyRm04dXh4ZG5wckp1VUcrSjNHNXpjRUgyS3c2Z3doUUZSQXR4N0RlV0wz?=
 =?utf-8?B?NW9lUUIxR1RiZGJHaW1uUnpyMFNtcXFZcXM3QjBHUXQ5TFV1bnJNWWp0R0dR?=
 =?utf-8?B?YUIvVTQrSEZieWtxQjhkSU5aL2d0ajc3c0t6RUx5enJ6NStSaVNmbmFtVkVj?=
 =?utf-8?B?N3lIQ0gxdi9LdGlOdmhBdm1TMGg5Z2tFWDhLMG1wSFZuQzBKL2dwUmRNcWRG?=
 =?utf-8?B?cEJFU2xWaVE0aFZSV3VHbjhhR3dLdENkTEorQTk3OUdZV0gwYWdXb1BGOFdl?=
 =?utf-8?B?TVlML1lyOFIxMTFlcklHNG0vazBEM0JHNmdRVTQvZGYvcjFzQ2w2WGIvQUNq?=
 =?utf-8?B?NDBZdmtCNEMrZGhGK1RqeWxPblphWlYxemVCd3FQdndCV1k5VEZmbklueEZa?=
 =?utf-8?B?Z1Z0VVFHa0d5SVJLdGprZEhvZ3hvWk5SUGVQamxESDdFV25WYTJKQVZFdjV1?=
 =?utf-8?B?cXIxMEFnTDZZcExWMitOZ1dOT0dIV3Bldk9IV2F4WXJZdTRISk9vd2ZPYjlx?=
 =?utf-8?B?bENCSTJPZW1Md2lnZ1pyWFBTcUgvQUNucHRYbHg2Q25FNHZGVFlaUC92SXJh?=
 =?utf-8?B?NTgwb2NSeGFPTWNNdUw5QngrN0VhVHpqb0o5N0hhQ05vS2NSM3JWa2ZsL0FY?=
 =?utf-8?B?QWRQZzFGc0hKWmJtMkR2Wkg4cGV3VFJjRWt3dmhxQ29sWGlJNEZJcGJTM2RS?=
 =?utf-8?B?VXl2Rk8xNHlhOTBXV2QyVC9FSWQxbFNzMDZQMzI4b3BrZGg5SmtSWS85Nmpr?=
 =?utf-8?B?Vy9PMTZOODZ0dmo1S0dLYjd2TkZPTUlrMUFsRlovUlhFUzNhZ1g3WGFxUmNw?=
 =?utf-8?B?ZXk4YmJkOW1GakdmRkh1L1VjbERpM0VqMW1xZ2JnblZLeDBDNnRpRXdheW9j?=
 =?utf-8?B?QnVocU4weFpZcW51SE1CMWZCNGhOL0pFc1JFN1dRallycGF5aUpQZm02QjRD?=
 =?utf-8?B?aEwzTnNUSGNadFRYZE41d2NRY2xXd25Ga1FyY21pYitVSmZpbDQ5WmJKajFE?=
 =?utf-8?B?U2hJNjV2S2p0UDMybE8yT2U4NnN2TVN2NHBTamRPRXJ3TzBMWGcramNxNlMr?=
 =?utf-8?B?WGJEb3VjSEQwaktScEVsNG40WUdHeDk2Y2J4aW5BWmZFS0FKNnBKY1ZwZ1FQ?=
 =?utf-8?B?M2hLMlhad0Jud1dRZENuZEZoNTZhMGlZdUIxcHNKbllQMjVRam1CZWF4b1Nl?=
 =?utf-8?B?UTdKTllaVlg5QkpZTE9zYnVrNUJTeHB3U1F2Qk5SWms5ZmdvVkpobVVlZWw2?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c83e6cfe-6e73-44b3-4212-08dae1ee68e0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 18:25:30.6384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: opadi4PtveFuN1AJOR+JTSiyHRx7euZDNvG8J3cR8Wg4iwH/iJgg3/cW/9hZxYxICZ+7jg7Iq3a5nmt3jieef9DX33FGxw+z6hv9WL6ADNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6228
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/2022 3:17 PM, Alexander Duyck wrote:
> On Wed, Dec 14, 2022 at 1:43 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> As far as the discussion for module parameter vs something else. The
> problem with the driver is that it is monolithic so it isn't as if
> there is a devlink interface to configure a per-network parameter
> before the network portion is loaded. The module parameter is a
> compromise that should only be used to enable the workaround so that
> the driver can be loaded so that the EEPROM can then be edited. If
> anything, tying the EEPROM to ethtool is the issue. If somebody wants
> to look at providing an option to edit the EEPROM via devlink that
> would solve the issue as then the driver could expose the devlink
> interface to edit the EEPROM without having to allocate and register a
> netdev.


Right. Since igb only has netdev as the way to change the MAC or edit
the EEPROM, there is no way to fix this if the driver doesn't load.

Ideally the driver would instead still be able to register and expose an
interface (devlink?) that does not depend on the MAC, and when the MAC
is invalid it just would not register a netdevice. Another option might
me some method of a netdev to say "I don't have a valid MAC, so don't
allow me to do traffic"?

A global sysctl policy as discussed elsewhere in the thread also seems
reasonable to me, given that modifying the driver to expose devlink is a
lot more work. Of course we'd also need to check and get other drivers
to use the same global policy as well.

Thanks,
Jake
