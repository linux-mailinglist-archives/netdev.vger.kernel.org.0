Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C5A671312
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 06:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjARFUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 00:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjARFUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 00:20:20 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11574A1E2;
        Tue, 17 Jan 2023 21:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674019219; x=1705555219;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8y/LaVm/IslAKK8brwxQDridbGyattE+0SBEfCNFmpE=;
  b=aGAQnzi6ImtJtrtAyoArg/6eJZjmDNcuNMqbbPBoM7eXdgHqqkDAiV2Z
   B+tmpWBqEawd3lz8ITs3tyqv/Hl5wuQxIrsIl650BIDaFjl8wNNFpRTMz
   H2qC9mTjNBc4daUu1OAQbIDe48lPlAfCqWXX26NI+WrjvXDZVo8MVfp15
   sLoGG5pjAXCQ6JPzRpl+O4lnG4WzvPCyNc8Wi22mqJjQenat1+OHUCN+q
   CmVmJ2TwxZbvfGJe9KT+mXBTYZQzLPVocByzGldxGEXUzZ6aeczX2fUfE
   YI4+JlVYFKF7/PGm7m/AKzjETerelEvwCti/R3eb5RHyozJvWfrQXKIvm
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="389401861"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="389401861"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 21:20:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="833425425"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="833425425"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 17 Jan 2023 21:20:15 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 21:20:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 21:20:14 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 21:20:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 21:20:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qsx6Ypulami0a3J/NuAnacm3RdlQxMTR4jfTXh7oZ1rvAnByFUZBiMvzBRTojwEDY/vSi873HCGhRBzqtaadTLphHo//M5DLr6l2AQCjB0BZlsI2gKw3UOBAia+zrn3m58I9lEIndYRZ3+6M6NmrHu6NLP8xqraW3Y2YXgGYTCmuW9EguUJtkMfWiBFUGDoi+Hx71aGeBGs1T3yKBuRcXAiHBnFx6WB+LKxrUDOIqZVXA0Hx5HmzKBi/zTJDGF8Vt5HQv5sEkU+mghG3d73pEuzUDcEqTarq6qZqzQ/kmOiQd1eISh4EY3kY4ohHNOntjAj76xFMgg4p+6MFDrg6mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgEjpdK0u9WG3xjwjb0xrWalxWZcdTf7nNaRL878Wng=;
 b=T4G/GIbOFesvRxq8VYsgKwIyS9f5BomxR/L7QM6OGuG1WaYU3X35IJPNE2b7qxfzPb/1uMFQG0/WnmBBtQsdJwby1RY73hyJgTt5amdpcZc4oVGi2JFdXzK593l50xrHvPrJ3+QkkpmtoEQZ6lIDkFKPOiJAeb9d88Rc+2ZEI3fWvxn53v5vBZBDFh8CPWlpNUmqnkEiWwtXD1w7c6p+IhCYCmdhFjAYkJ5rikh5EUfwtXKobh1vtCcpTiJ4LvmMa0ms5GVe0ERUKCXvhi41mpCt18oYLbHCvtRHv2lpb5rtg+GRJDMn9YyAllxWITr0irTuzwb8TaxxRML9BgEDpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6738.namprd11.prod.outlook.com (2603:10b6:303:20c::13)
 by SJ0PR11MB5867.namprd11.prod.outlook.com (2603:10b6:a03:42a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 05:20:12 +0000
Received: from MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::7c7c:f50a:e5bc:2bfb]) by MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::7c7c:f50a:e5bc:2bfb%4]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 05:20:12 +0000
Message-ID: <5d96deeb-a59d-366d-dbb2-d88623cdfa2d@intel.com>
Date:   Wed, 18 Jan 2023 07:20:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Add ADP_I219_LM17 to ME S0ix
 blacklist
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiajia Liu <liujia6264@gmail.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <linux-kernel@vger.kernel.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>
References: <20230117102645.24920-1-liujia6264@gmail.com>
 <9f29ff29-62bb-c92b-6d69-ccc86938929e@intel.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <9f29ff29-62bb-c92b-6d69-ccc86938929e@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::16) To MW4PR11MB6738.namprd11.prod.outlook.com
 (2603:10b6:303:20c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6738:EE_|SJ0PR11MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b8abdc3-3aa8-4b50-ce6b-08daf913ac96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3kKhmvpWrygMO6gHNIIpyBm0WY3T5nssqPQjGY71+VwP6RxVzMGa2j051n+0TdLqP17cPELrJnPcRr175zlU7CAeWMkOIOHuUec7FLde35Gng2PYgYKHH2/PO7XW0bSFNoOxi/bx/IwE0eYMHqH4aLiC00YKwSFDsWWcp/1PTM/ROKaki/Pt0L8zr33EwN2tA3bVTp91UQkqte5xxONJVs4uBVF7WGtvGp3XbRwpT/MzOnPLl4CJQj10b998uZ1gQ91ZtT4NjtJzCE1lvS1PqdC4t+DyqugmlrG4f+VPWeJew6PcSgdhPK2IJFAIMC7kEqzGKAo32xSdhBTCPK76yLmDG0tzh0LMS0KNZlHm3Csg04Gb0m55yqIg5RN3FolSLj9Ps+9Ny+ngyilRgmFTsTj8WgcyXJBepINXQLEJRD0V6jlTb1a4y9zHlrXmmNcj2KYYA1+ckwiDLAfNvkS5UC+tHyI32SFLIR1usYLop7B3OV9m2vPL81bjVQqjnxl1tMZHbAZMqL1+fKmIl2Y7DaqVVXuxSmpYWix79/ibGMNGFu6ZmUrJBaDYSCIKGBvi9pTsi9XbkIl2sRcdDEgSZnBCGmBu80nzPH0s9tuPEr/YDG9S5mQniM3CT0hGXxcKbY7LP+wAJas3/gSTj4Y/zIhEGjESOFHlU5liiyr3lH0b3iA9nGjESA6NypKp3h/WP1irkGIM7DMfA3264FJPgwfYjm8te+y1Y0TI5gWv4zWd9045phQoDdH7c0SAz+XShbKjQkQL5V6B74mms+yk95nVH8scYTq9y3tURRJFhwt65BetRir+32dbPU8wAFSLBPN6rwTF8nKSQk60fck/gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6738.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(366004)(396003)(346002)(451199015)(31686004)(86362001)(2906002)(66946007)(66556008)(66476007)(8936002)(5660300002)(82960400001)(31696002)(38100700002)(316002)(54906003)(110136005)(107886003)(6666004)(53546011)(966005)(6506007)(6486002)(478600001)(36756003)(41300700001)(8676002)(4326008)(26005)(186003)(6512007)(83380400001)(2616005)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHRBd2FjdGlhcDk2LzNlTHhrMC9jZ2dYQ05tMEt1V2JQdUk5UHZiUUkwY0JJ?=
 =?utf-8?B?WWkveVEyUW91ckFUQU5laTRBaG9QWmhiM0VtY294eldrekROZkJPL3dKTy8x?=
 =?utf-8?B?MGFQUHVXNkxRSjVYOFRuM2xDOEZvcUZsMG9ZWDEwYVowYUIxZlBYRzFoSG5F?=
 =?utf-8?B?ZDBxUFVOdTRPbTNzcVIzMzY3S1BhWisrYVFNVE5PNWd1bk41M0FMblZhdmFx?=
 =?utf-8?B?eVlSb01taG1UdEZQMFZwT0RYZFdNdlU2WG9kb0xRbCtGeFdoV0tlYWtxOW1i?=
 =?utf-8?B?RUR6Zi9OQnp6elFTbldMajJxL2ZoUjJ4bVVONUFBSWZMYnF2TTBuRG15a2tj?=
 =?utf-8?B?ak93TlJScWZTcFhnTnM5OWxudW9kVUFnSG5PSUxYaVo0OXRjeE81dFJrd0x5?=
 =?utf-8?B?dkNxTHdPd0NtS3F1aEdwSEpRM2NRbFVHYndXUXRFZU9zL3ZFVHBhc085M3NI?=
 =?utf-8?B?aFZHdVhUL0dKVlY0ZnBuM1ZPc05BQmh1V1JzNmIwVC9tSEVnTEdRbE50L21U?=
 =?utf-8?B?TGdtVkNLZmF6WVg4U05lcVRWS2pNSE1JaUFZb2ViNmNUbW5MbFN2UGpydjRQ?=
 =?utf-8?B?b3g4K2RSZGc4bW1qSjJVaTdqMXVkbkdtWkYyTEdnTkFDY1RnVXVWYXFyN3Jw?=
 =?utf-8?B?Z3BacmZGUk5BeDdZNkJ5anNNL1MvMG9QczRiVCtuSGpmVFd6cGh2aExNa1RF?=
 =?utf-8?B?RUI2aGZjSk5xUXJiYTUvbG1hZzJ2L2t6aGEyRkZUWXBLamxJTFZYUkpqUm03?=
 =?utf-8?B?VDdiQ0NKcmpFODF4QjM4VmFPb3dhN2kvT05RWlg5ZE4rYjRqeG52TkRPU2pq?=
 =?utf-8?B?NEhxbW9aN3RQR3ZoSUNVcjZxSldTdHBMZzF1QVV2aThYVXQwL0tpZUxSeWRh?=
 =?utf-8?B?cEtSNExBeTkyRjc5SG5CRjVKUlZZSDF0VWx5WXlFV0dsL1AyRE1CSFB5NXNF?=
 =?utf-8?B?aEhxSEpETjJGQ1pTV3ljcWJiZ1ovREo2UHo3cWkyc2NTYksrQm9wNSs5TlVv?=
 =?utf-8?B?QmNJcXYxd0duQTF0S2laQ0pTZVFrR3R1Uk9XK09kV2luSDR0MVBWMHE2Ylpo?=
 =?utf-8?B?c09KTzM2NlBMWGZKZ0lmQzlyMkFWOEZSL2t3Vmwzc0RnUitlQUNqdDdKQzdO?=
 =?utf-8?B?MnZKZDhrWFdLTkRIVFZlWXltc0FKVUx0amx6TkhIa3N0a3UzNUVNWStMME5z?=
 =?utf-8?B?Y0Zpa2FSbzV5MDdSVGsyMVFwVXBJWVJnVUlJdnpGdWN5aVB1RGs0eG5JWTNI?=
 =?utf-8?B?T0pkZWdTT1FFYS9GdE1ES3djc25WT0s3SjJ0SnJzcTlHbStWVGtQSDluTkVH?=
 =?utf-8?B?NXd1YTY2Z0RFaWdiMnYvWmg4SVVQQmphREJneGlwQmRKd0FYTDY0d2RSYWJs?=
 =?utf-8?B?MDVJbFVlclNZaThWTldXYTlqV2lKeGwwNjU5SURSUnlleXNaR21hdmlPL2VF?=
 =?utf-8?B?ajlKczdzelF3ZDVPZENVTnI3N1ZSeTBFWEJhN1QyQ2I2THhsc29UM2YrS2Zu?=
 =?utf-8?B?RWpKZjhRWlVpZzFLcnV4SjEwRi94Wk5lakRhR0pGeG5yL1BMQ2l2SmlTWHhH?=
 =?utf-8?B?Z2N4TGxTcWtna3RzaUxNMmFQYzlFVGt2ZmxrMjAwMGZWRE44U2YyZjRPeUNI?=
 =?utf-8?B?ZkJNL1ZNSFd5ZGlEeVJ6eXRKc3VocTlPakZ6WFpHQmRoU21jZE53RENzUlRH?=
 =?utf-8?B?by9NL2MwUmoyY0Q1WGQwS2dUeE4raWxvZktGeENrbXdJd3ZSekJTTktlS3hD?=
 =?utf-8?B?azJ2TjdsamhmRjBVb2xyQU9PZmtFUmlRN0YxWlBUaUVOYVhHbmVEQ0tDdXBo?=
 =?utf-8?B?QVBGVlhodTZCT1A2ZUllZkhCRFhURlltN052TVROVDFxZTF3ZTZINUZTVmYy?=
 =?utf-8?B?eVNZcU5xZC9SanNjTm40UFdKcVJydUVUNmF5VUhJb25CTlA2L3dldzVYMjBK?=
 =?utf-8?B?VDZ6alNFZ1kySHdESDZ5VTVvVGZvQnFqSzlHOVYyZjVDSTl4Uk9qRVVHMUxL?=
 =?utf-8?B?YkFVa1R6R2ZzTVBPYms2eDJlaUR4WmNxc3E4a0ZGYjF0SjdKcXUyck0zRklw?=
 =?utf-8?B?Tm1JVWFrT1VqRis5R2FET29vTkR6cFZocEcvWGdUNURjVGQyU2hMMERMSEt4?=
 =?utf-8?B?a0hBTWxpNnBHRG1HK0E1aGhJSGhXQXhCQzB4dVI0L0xFTmp6WmU4TTJrQkRF?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8abdc3-3aa8-4b50-ce6b-08daf913ac96
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6738.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 05:20:12.5198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYK4m+uNvQCO+1zlHhAKltbBul8ftlYXiq/JeAcbH07nl+ganG/1K7lBB2XwKhw4Sw3G4Dpdh4w+vemUgmjcbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5867
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

On 1/17/2023 21:34, Jacob Keller wrote:
> 
> 
> On 1/17/2023 2:26 AM, Jiajia Liu wrote:
>> I219 on HP EliteOne 840 All in One cannot work after s2idle resume
>> when the link speed is Gigabit, Wake-on-LAN is enabled and then set
>> the link down before suspend. No issue found when requesting driver
>> to configure S0ix. Add workround to let ADP_I219_LM17 use the dirver
>> configured S0ix.
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216926
>> Signed-off-by: Jiajia Liu <liujia6264@gmail.com>
>> ---
>>
>> It's regarding the bug above, it looks it's causued by the ME S0ix.
>> And is there a method to make the ME S0ix path work?
No. This is a fragile approach. ME must get the message from us 
(unconfigure the device from s0ix). Otherwise, ME will continue to 
access LAN resources and the controller could get stuck.
I see two ways:
1. you always can skip s0ix flow by priv_flag
2. Especially in this case (HP platform) - please, contact HP (what is 
the ME version on this system, and how was it released...). HP will open 
a ticket with Intel. (then we can involve the ME team)
>>
> 
> No idea. It does seem better to disable S0ix if it doesn't work properly
> first though...
> 
>>   drivers/net/ethernet/intel/e1000e/netdev.c | 25 ++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>> index 04acd1a992fa..7ee759dbd09d 100644
>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>> @@ -6330,6 +6330,23 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
>>   	pm_runtime_put_sync(netdev->dev.parent);
>>   }
>>   
>> +static u16 me_s0ix_blacklist[] = {
>> +	E1000_DEV_ID_PCH_ADP_I219_LM17,
>> +	0
>> +};
>> +
>> +static bool e1000e_check_me_s0ix_blacklist(const struct e1000_adapter *adapter)
>> +{
>> +	u16 *list;
>> +
>> +	for (list = me_s0ix_blacklist; *list; list++) {
>> +		if (*list == adapter->pdev->device)
>> +			return true;
>> +	}
>> +
>> +	return false;
>> +}
> 
> The name of this function seems odd..? "check_me"? It also seems like we
> could just do a simple switch/case on the device ID or similar.
> 
> Maybe: "e1000e_device_supports_s0ix"?
> 
>> +
>>   /* S0ix implementation */
>>   static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>>   {
>> @@ -6337,6 +6354,9 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>>   	u32 mac_data;
>>   	u16 phy_data;
>>   
>> +	if (e1000e_check_me_s0ix_blacklist(adapter))
>> +		goto req_driver;
>> +
>>   	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
>>   	    hw->mac.type >= e1000_pch_adp) {
>>   		/* Request ME configure the device for S0ix */
> 
> 
> The related code also seems to already perform some set of mac checks
> here...
> 
>> @@ -6346,6 +6366,7 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>>   		trace_e1000e_trace_mac_register(mac_data);
>>   		ew32(H2ME, mac_data);
>>   	} else {
>> +req_driver:>  		/* Request driver configure the device to S0ix */
>>   		/* Disable the periodic inband message,
>>   		 * don't request PCIe clock in K1 page770_17[10:9] = 10b
>> @@ -6488,6 +6509,9 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>>   	u16 phy_data;
>>   	u32 i = 0;
>>   
>> +	if (e1000e_check_me_s0ix_blacklist(adapter))
>> +		goto req_driver;
>> +
> 
> Why not just combine this check into the statement below rather than
> adding a goto?
> 
>>   	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
>>   	    hw->mac.type >= e1000_pch_adp) {
>>   		/* Keep the GPT clock enabled for CSME */
>> @@ -6523,6 +6547,7 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>>   		else
>>   			e_dbg("DPG_EXIT_DONE cleared after %d msec\n", i * 10);
>>   	} else {
>> +req_driver:
>>   		/* Request driver unconfigure the device from S0ix */
>>   
>>   		/* Disable the Dynamic Power Gating in the MAC */
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan

