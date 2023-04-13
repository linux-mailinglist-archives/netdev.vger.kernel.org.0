Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780DF6E1328
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjDMRHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjDMRHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:07:39 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605F9769C;
        Thu, 13 Apr 2023 10:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681405658; x=1712941658;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V5nVniItVBZ/SpcNm7miKWmF1pqS0boPc/v8w8oWXnw=;
  b=ZLluAnNACyEYotnNdywxU1J6mPmrQYMVZLXY0CYe993UQ6cPRb/aPzhh
   lgF3ULHvyW9z9wdFXc/G06GP8omedwQiEi+/JLcWQSyfjtjVX6hAn2aoM
   st+q6RlnN1C1GcJVqTe9vi3FLU/dtGVppYWpgT2EeQ3TIcBX7I6i0krvI
   3ydc/MBB/1kE4K2cB2UB6318GlxduvKudbxh1ZqvQUhXBwaX7v0g83fRN
   KbrOUZDLo1wuy42F8/4wvd1Yg39HHIHI4vp5DjjzJgx6hsbNlUJihQ5/e
   dHR8dPu6wfB/PIWDOwMjcQyk/jTCCEwDBFWvpKpYnd0Gz0w4antGbQqCq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="409424655"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="409424655"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 10:07:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="754084518"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="754084518"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 13 Apr 2023 10:07:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 10:07:36 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 10:07:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 10:07:36 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 10:07:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NrFKTZQRwQEPMHdBmIUb6VxTsprcuTihoynyRsjKSwy5sSwoomFrfR6NOvTepgZtL4dbpmxrcSvSKj1arfFVbyKmkoPl8XSVmrkb5/BfZtJn3EfqikkrLlvbQhM8f7sRfjh1bjrV0bqaj7ZESsR+eb/nQ4Zo4iksQGRlyBbQQWKLldSSJSCrTJW0DHoSr6PLsCXacFcgTymt7ZcgWbXrTqOmTd4cwITFepQ2WHZ11aJ3sw16aBg6nxCB0UKSA8l4Vg/cwfLfaWcWJtJUMEBZpHK1AardkWRNwTN9O8/CVW3mC3SK+igcJTRidUR6QiOA5mNlqKhpnhvhQZ74inyguA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wHeu3ITUr5NNQAp0tKwpWiDn6Jxp92cBrWcaxxhv9Jo=;
 b=nCVhkq2Ks/e1sm7tNwpVpTp09bJjWZjTa49H53tKMYGXB2S63/lFcA0Hhiupi9TAXzUxxxp7GckdLDza4YKbPYo1UnDNfh/GnD6iNoMVc37l4fhziEMNclNBuusIIjuMecR9jhKnXk6ZKz1UXHbAl0OP39z02PEXBK25QcxxUw6n0z8pDgK0H0DIykVHkZnCwaSt14IF1uSsbEPCjxYRMd+b02/kcfipicp6GNu1JEAXGqeSNHtYqWWEZrxbwUrtTUtUih32vuwtOaBKq4K1jDKZ5c+YqV+Pu6OSBdusBC+oxkiUhg7gUxx0HvcddudWI/ZRoWyheMYI8o29y+kBzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB6943.namprd11.prod.outlook.com (2603:10b6:806:2bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 17:07:34 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 17:07:34 +0000
Message-ID: <01ef9d4f-d2dc-d584-4733-798cffda49a1@intel.com>
Date:   Thu, 13 Apr 2023 10:07:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v4] net: stmmac:fix system hang when setting up
 tag_8021q VLAN for DSA ports
Content-Language: en-US
To:     Yan Wang <rk.code@outlook.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "open list:STMMAC ETHERNET DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <KL1PR01MB5448C7BF5A7AAC1CBCD5C36AE6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <KL1PR01MB5448C7BF5A7AAC1CBCD5C36AE6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0206.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::31) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA1PR11MB6943:EE_
X-MS-Office365-Filtering-Correlation-Id: e63a924c-0bdc-4ce2-154a-08db3c419308
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxmK0DBtlGqnH5oxc3tf5y932nVsREpanWxqmZ+nK6xgRllmoQH5DDMQ7mWwJy2X3eWbZNLcFC5ZUepywEyTb0lwfcuEnltgimxbDIP2+Kbb12DNt9GXm6YT6U4A/9+S9Qz4YXKx8BU2/hm9SqMlKgkYqOlyDTMJvvBJeDv1C/co9lwVLSokIu95H0w/AchSsaI6zi6dLhYzLPh19grg8pKzwOO4iYFxTXAoIBLHPpNHA4iiuvnaIPfEpDnrtsgWTTU6FT20mzdBYXhih8v84siM1FXKSxwCiu2ZzYLOk8i9BufMbn5jWClaRhkdr8yJtvCDFgea5qdAosYoc2p5tE631VGjXm4Ce2JTN/LVeGwHjn0+r+NGWq3NAbl51bFfeO//i2jSgJZPlJ3jrv8sdy9lTy9SMvDJqwC1u1i4GXSboQukYnDVBbRxx38p6C+5+0BiXY6SuuO8SUyLXBQWrIl+5rhq67f7Dy9kcefN6/X1vyZQBuhhWshxSJGbDmMMrLO2BHcFABWiyDNoxcHu5rzu39OM72fsAT6v3MsTuggV34qnb/rxxj6vtvdu9ok5HYR2/6umggJPTpLZeBjDywY5hThjdap8AdX9ELb80ncBsKEvYUd0a0QWdzP/co6IsQykg5qkIoODZDDv4g9fig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199021)(2616005)(38100700002)(7416002)(36756003)(6486002)(5660300002)(2906002)(83380400001)(31686004)(4744005)(31696002)(54906003)(6506007)(6512007)(186003)(478600001)(45080400002)(53546011)(86362001)(26005)(4326008)(966005)(66556008)(66946007)(66476007)(82960400001)(8936002)(8676002)(41300700001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlV4OUVnd0p1VDhYWnJ3R0dmZDVkOWZpOFVscXg2a3dYVHdXZGFMcVBQU3N0?=
 =?utf-8?B?aEg1eXc2d3Zib2ZOQllEdFUvWFVUMzF2bmloeTF0YmE2SzJEZitYdWhlNjRE?=
 =?utf-8?B?V3dwaTZvQnlEMnRmMjlGLzFxRXdOdUUrMVlWc3pUcEQ5c2kvOWRtRVZBN2h6?=
 =?utf-8?B?RDAySzVnQ2l4bkNkdXFuaERhZDg1dkd6RDhQTE9zMnFmVEs2cUQ5MFhmRUli?=
 =?utf-8?B?Z0xOb01qQmo3Wkp6WTdGZXYyRVdveXI0LzJxU1FVY2U2OHJTdS9FNWhWS0VC?=
 =?utf-8?B?WUpaaC9FMUZRMkNyZ2x2U0xQSW1hSFhoajdMTGRZaUtKVlRDNzVPOVJlSnpt?=
 =?utf-8?B?N2ltUlJDbG04OS9NQWxuOWp5dGJ4c0gvWWZpK2JhQmg5bmt6Q0ZHWi9Ha0Nu?=
 =?utf-8?B?OXhKMWJISXVrQzBLYnlqMXJOWFZmZUZCVisvYU1yalFoSnQrK0J4bEhldTY5?=
 =?utf-8?B?NUZTSGQxamp0UjhtRnFCaU5yOVAwL0JSd0F3dmdIdVkwS1hlcGl4UjlpMEhP?=
 =?utf-8?B?eFBGZ2RZL0ZiWDU2S3EyREhlbW1nVWtCRWNjTjBWcnlJOE9QSXpzWHdMLzRW?=
 =?utf-8?B?bGN3N3VHdVdZZ2MvR0FkZVpsZkRETkgzeko0SjA0UXh1V0pvWkxSS1RmUHZB?=
 =?utf-8?B?Rmh0L0VrdHZ2M1JiV2ZHYWZDdTRPcUx3T2t4YUtEMmV3cFdlUFNUcWZlUzVx?=
 =?utf-8?B?bWtsaW5uMFhYbnZaY2c5THFVdVBGaHJnbHduZUpVZVFObjBtcGszUm5tWjNq?=
 =?utf-8?B?bTJKdlk0d0N0M1hjK09lVURDLzR6MnFmQ1lCTjQrZFdoK2JtNWQzNjNoMXVK?=
 =?utf-8?B?R3VtbUlyMTNrZFMzWENtMUphQkxJckF2UmtUeXdZMWJNUE5DY3J5UlFhdGRz?=
 =?utf-8?B?VVU3eFJLY0o1WFFZN29OSTlJOGw2TVF1Ni9SVkh6T0h1akZnU09VZHFYbisr?=
 =?utf-8?B?bTBuN1NINVlsQm9xV3Axd1gwTERBY1l6UDN4WU0reVlBalBVd0NCdUJ6VGlP?=
 =?utf-8?B?aGVlZVZ6RVcwT1hQM3Jtc0hoQTJiNHhoeGxpV1k3cTQ4Y25aSzFNWUFEY0ZZ?=
 =?utf-8?B?Q001TkNnaFpWMXNWL0NReXdUbkk5dzNRbGFiRTFGbjQ1eWxXRnBFVnRvK3RS?=
 =?utf-8?B?eG4ybzVIUHRoTGdueHBQd2dyaUltYXB1L01uVC93U3NpWVJFN0JoWW0rcyt2?=
 =?utf-8?B?bmVWeUJnV3dPMjhTVis3WTZWOUt1cEQxZnpUT0c2cXhWc2prZ3hCUmROSG9s?=
 =?utf-8?B?dnhIbDNkQUwxUksyK0xpUDhVckU2QVZ5ZzhwUEZHaTNwK2RRQS9TMUdNM1pJ?=
 =?utf-8?B?S0d2VGNLa1lvbmc5UHV1MzlOUnh5RGlyczRVeEg0bGQ1RDRBUlQ4RWdDMkJ5?=
 =?utf-8?B?OE9mSVArRXp6akl3elI4ME92Zks1NFowQlU0OHR5MVdKNm5IKy9OazR4Tmlv?=
 =?utf-8?B?LzhES3hEUTJmU0NNaUdDTVJLSUZsV2VuS1k4eE9VVXAvT0t4RWE4NDlvalZZ?=
 =?utf-8?B?OUpBdkdYejlQZmk1N0VJQVN1amNycnFjYU43elZrc3V4WjNWcC9KQXRmMk5a?=
 =?utf-8?B?UU43Z1JpOHU0WjlrNWFldDdMZ0dZMkh6UTdUWlFlNGZHd2FrL2k0ZEV2UnRK?=
 =?utf-8?B?cDhTdDV6cGhMNGhQVHZzTkYwcks5WlVjL0t2MFhCbkRuSHFvT1BoeXRwVWpt?=
 =?utf-8?B?ZXZYaFpSVmZTMnF3Z1pJanlCTXhSeGk4azVYSmhoMHVMTm5ZQ29HblRUem03?=
 =?utf-8?B?OW94d3Q5YnlSOGlvdXBGODU3VER1MXBLb25Rd1FabTRuNTcxQ1MxU2hzVmtB?=
 =?utf-8?B?MFFyYjEvYkd4ckxhSDgwVTdzRVQwSFZMWGx3Y0c0SWxZYUFTZkNIODRpclRM?=
 =?utf-8?B?dmxBM2JSa2pGR29jSXp6ZDRNREoxN3JmZk5rUnZXUjFNcVkzVmtOb20rUHp0?=
 =?utf-8?B?YVoxSG4rQ0xjRGZscnJOTVFmV3lLQndpRTJvb3c3L0x1T2ErMVY0UzREeHhS?=
 =?utf-8?B?R0pmdS8rUStaMDhHSmNHQkdBUDFjSUZCa3YzL0J3THE3eFA2cktsU2RCc05J?=
 =?utf-8?B?ZDgzWEZCemhickd0N0NuUmcrVkQvMVpBWE1iN0ZkbzFvZ0hud2h1NittSGd4?=
 =?utf-8?B?VkxsZXRwZ1ZGWjYraEVHRHZaeExEQU85TXdCMGNKMnVlYTRqU2VTeDdYc202?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e63a924c-0bdc-4ce2-154a-08db3c419308
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 17:07:34.2858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrnyCyISq44txe/Fx/PeJ6nRkCSaJHUZgzEVJzPjSdFCwLQS00JRp96+sCw4wJtfQQcdDXOZxPKuw/i/85BxCvvLAWWI4bAKy8qhk8ekK+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6943
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



On 4/13/2023 8:06 AM, Yan Wang wrote:
> The system hang because of dsa_tag_8021q_port_setup()->
> 				stmmac_vlan_rx_add_vid().
> 
> I found in stmmac_drv_probe() that cailing pm_runtime_put()
> disabled the clock.
> 
> First, when the kernel is compiled with CONFIG_PM=y,The stmmac's
> resume/suspend is active.
> 
> Secondly,stmmac as DSA master,the dsa_tag_8021q_port_setup() function
> will callback stmmac_vlan_rx_add_vid when DSA dirver starts. However,
> The system is hanged for the stmmac_vlan_rx_add_vid() accesses its
> registers after stmmac's clock is closed.
> 
> I would suggest adding the pm_runtime_resume_and_get() to the
> stmmac_vlan_rx_add_vid().This guarantees that resuming clock output
> while in use.
> 
> Signed-off-by: Yan Wang <rk.code@outlook.com>

This looks identical to the net fix you posted at [1]. I don't think we
need both?

[1]:
https://lore.kernel.org/netdev/KL1PR01MB5448020DE191340AE64530B0E6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
