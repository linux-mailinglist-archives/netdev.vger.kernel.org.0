Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E67D676BD7
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 10:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjAVJbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 04:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjAVJa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 04:30:59 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3855E559E;
        Sun, 22 Jan 2023 01:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674379858; x=1705915858;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Dhuhx+pGfk3oECPc2+hLhYJ99R1XUMBLbuUQEwulNZE=;
  b=Dodxecsz3baVRLFDEU+i45NEhw9aOuTE4SjAN78TZYPTkFddzyjbEXbL
   1Dc8vDOZmDfHvXVdqlMBIQAjbJ37hNZz4SAgNyQGC3dScRSotfQdrIBgj
   HiJHry22G6ujiNV4ei8GFNnTA5EPDVVu4B4vm0qKqfDYAPxjDoa/hy4yD
   8pYT9tEqSOzOKYqO74g8rGfZbY28nJ4HGqHJdFCT2X4qEpfyDHf9gibCO
   nlNvKOQl3lSVP/EM6TEC8oTm4kxYtAK36ZDBzJLziG6Kfnhu6f9RvZCYb
   z17imioR0aR/8GYD8pA9xS6o4gxgAp1oPf5sE/OHHoepgrMsdc4fBhZy5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10597"; a="306237942"
X-IronPort-AV: E=Sophos;i="5.97,237,1669104000"; 
   d="scan'208";a="306237942"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2023 01:30:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10597"; a="803567999"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="803567999"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 22 Jan 2023 01:30:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 22 Jan 2023 01:30:55 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 22 Jan 2023 01:30:55 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 22 Jan 2023 01:30:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8xzaHg/mY43Tm2yrh+9u8rFC9q45R75eiAMW6kPyERlzydacy9VABmiyKUhKpGCEqcItBOrUEmPtlfmKeLt5K1oSh9TkwWia7aU6kSpm7L2KvcTczE0z7KuTUwFrvr/44z515gScwTdYkLWNzjbtD7Tf0HKycTMVIojlOLpM/jeLEGUPM4nv0jaJfewk0hRayky1rfvy9TmigUGmO7C74K1I81hWgEB1r9k5tYe4yd04KOz9VEFArmujg4L0DLUrWbotTWDUoA87DdCI3fQZ6AJhdFtuGk7ucRo2mlKUr710W7HJOVOuze5zGBPqQd3Pr1IFsdKrrptP5bjk4EkBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XyFFn3NHP86x6exyl3AX2ntxvgKgtkmRYlN7nLJJop8=;
 b=FJGUIY3kZ8Tu5wk0i/Zmw7IwnSYQ5rL8A6Ero9klN2a5PX0UPNBJ/Lin+65+IWCPiIrz8K3YqORox1hrJK/2MbKpTg+HoHq1rRVxHRG3dac7nUXJmn3uoxAaEDV8Yi7GR1gG/T2Lb+iqU+HEAch/8k8u2Jx03TRBx2XBvjstwGguuQ7eh/EWMO7JV+FT38atX3BtutLSMXJGrkYLt2de6mTi80lV6A3YAZVX8rqQn9E0c7vvlEBRyv5DzidayhbE/8P4LpliqDsG+otn+kR+VkKaNWeLsVAvVBTVLNc595H/IgWqX2GoW6aDWBD56LwpOgA9j4Z+FeIRfd+lAyOnEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6738.namprd11.prod.outlook.com (2603:10b6:303:20c::13)
 by PH7PR11MB5793.namprd11.prod.outlook.com (2603:10b6:510:13a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Sun, 22 Jan
 2023 09:30:53 +0000
Received: from MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::7c7c:f50a:e5bc:2bfb]) by MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::7c7c:f50a:e5bc:2bfb%3]) with mapi id 15.20.6002.013; Sun, 22 Jan 2023
 09:30:53 +0000
Message-ID: <3d63835d-cc1f-a6f3-6407-8b7c155a6d65@intel.com>
Date:   Sun, 22 Jan 2023 11:30:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Add ADP_I219_LM17 to ME S0ix
 blacklist
To:     Jia Liu <liujia6264@gmail.com>
CC:     Jacob Keller <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20230117102645.24920-1-liujia6264@gmail.com>
 <9f29ff29-62bb-c92b-6d69-ccc86938929e@intel.com>
 <5d96deeb-a59d-366d-dbb2-d88623cdfa2d@intel.com>
 <CA+eZsiZ81+AL1-mLb4mONZnMqO=uUPFcw=QWFhEY36_jg9MpiQ@mail.gmail.com>
Content-Language: en-US
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <CA+eZsiZ81+AL1-mLb4mONZnMqO=uUPFcw=QWFhEY36_jg9MpiQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0024.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::11) To MW4PR11MB6738.namprd11.prod.outlook.com
 (2603:10b6:303:20c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6738:EE_|PH7PR11MB5793:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c2398e9-eb26-460e-8c63-08dafc5b5b4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SvjO9EjsfAKiKnTJcLJAyY/V9BVVyP70RCS89rWkJjXni6Elr7b+MXvClU82lsw9Nev2mRZO68+92Z6go7o3VaIattYxS+fdYmMyS1V5fIJTF578ZQqBaIpWfBNmWmBzgBQiJ0rtCcHhzDwMJc04zSwpOcwoA21NHjbNBQr3ffU/ksh6KeNpDddUf4ZkNvtgvkXdMihrf0pKdFwsmZz5dVC+3qbbUfyBtN8wyAsLIpUtlBU8QOtaMgozFafKWOJdD3NBGZetO1R9EE9KugtSAOaW72OuSVGhkdQr5jKbUZrTOQGJvnin6UZj6N4vaSaxbSNq+KVn/xXpHa+qZleDkCOKGY74xN3mIXCDE6VxoO4Teg7MosJ4s1oPFTWtcjew2NqnFAXNeHdiwDsbxosuQ2NmUUstHusvQPDCDY2Ql4Ac9SN+byNTGGIyWwLilaqr41B6l1WOyEeMVTL5UQZJ2EQIEI+PIrDHqPZxs4WSh/Qd7iOpOIV+317FldJCCLRQv+79Oa4OzkXtKk8oX64EW8x6o7kLLysiCKVJSo6MuMOjT+BwPJUipRCOmR5G5uyZ0RU/0PbOga8RkT2HgQeEzd/CIcWgMxp2o9okeYDwh53mIWuW5hOPxuDtZdBj4bCAqjudx0Jqc07YIQ71uNVz317M22DZDwsbOGXvJBLIWbPVQ8JhIyL/NHJGtJlvWK2o/QiHTMiu16D4Qe6SsY/B6Ao+oW9HBmBLuuDSclzs7+zH21aqMdHQorgfaZIigSWpubo+eJX7Rg7Gg3WoEqCr2zUT2jGlNyKZa9gsgEjx9xG5gXA8E17OfXju5eypPQG1omEFhmHFkdbZcx7Ul5fxeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6738.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199015)(31686004)(6512007)(186003)(26005)(2906002)(478600001)(86362001)(83380400001)(66946007)(31696002)(966005)(6486002)(316002)(66556008)(53546011)(5660300002)(66476007)(4326008)(8676002)(82960400001)(6916009)(54906003)(41300700001)(8936002)(38100700002)(2616005)(36756003)(6506007)(107886003)(6666004)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFhkTWlZNU01M3VhelAxQmZRZk1aZDlTbGtPWllxR1NJUDdLUGE2b1R1VjZ1?=
 =?utf-8?B?Q3piZnF6ZG9YcUo4TVVDNXlqa1hHanJrQkFxNzZ2VjZCeEQxaVB5ZWZVL08w?=
 =?utf-8?B?R0s3K1VVdjhrbHMvTTVVZmFkTVlPTnZYZWFLbjk2amRuVTdqNmh4T3JWQWcy?=
 =?utf-8?B?VDNJZjJCYnlqT2R3d3Y5djE5UmF1eGpsY1EzNVIyeDdNUHRZcW83bndmZ3hD?=
 =?utf-8?B?NnAwbjN0c0FMazh1d3A5dFhtMUU3RW5QMEhKdHpLMXdsWTlyaVJ0RitkdFJz?=
 =?utf-8?B?Vjk2VGZXT2ZBUFQ1Q1dkeFdaRytTa0dPOGRFSXA5OTMxdWZQb0lHem54WXRO?=
 =?utf-8?B?SnFEZXJVcGFVTWlDOEVKaE44bUw2Q01zS0VSZ3UwbDFMUVdEL2FwVUJlN2pz?=
 =?utf-8?B?M3Erc3FURHMzS0ZrRGtRL3RzNkN1SWJNekZZVHRETjdjZ3Azam96c1FSV3RX?=
 =?utf-8?B?N3Y2cEdYMjduQVRnV3ZKSldHcE9POHlMK1VtTGt4ZTZnVm5uV1NaekU5ZFNi?=
 =?utf-8?B?WmtVVEVZbW1EZFBrdzBxa3UxT0x4UWhCTkRndG92M0ZKeXdpRkFjdGwxM1E2?=
 =?utf-8?B?MzhWZlp2TVA1WmNLdmM3d0cwcjBZQUluTFJGVnJzUGNQNUdRZ04xZ3pYWnkx?=
 =?utf-8?B?MTNRNCtSWHUxSkFNbk8wOHU2QmkwR1BrQVhjTmZhcll6andQU0pqeVlqcGlC?=
 =?utf-8?B?bHdhWUI2L2dTaUR6TlltVGJnQnVldTVmQmtadlBTblI2OHJ6QkI3ZlZVYUg1?=
 =?utf-8?B?QWFybW9SQ3hVdWJ5YmUycmlqMC8rOEw2QmpKbjdjSmdlTFY5TE9Vb1BVMWZp?=
 =?utf-8?B?U3JPOHU2Y3RJNDdlYUlCcG51QXFHdXBBYVFDSHgyZmhPVE0vZEY5NHc2cUFn?=
 =?utf-8?B?WEFkaDVlejlnQUJIRHMrYzBFWXJ4TnVuNUdqazM5U2xqRnZXUW5aWTlTbkZx?=
 =?utf-8?B?Q0lMdExnTXN5dzhwTVhOR2pOa1BDVHhjdFhwU2FyQzhZZm1oME8xSjlJS3ln?=
 =?utf-8?B?MitWZCtPMTVvMStMQ0tSVXlJclB0RFhNSWVCdzhLdGpUNCtKZGFOb25YQTl5?=
 =?utf-8?B?VExjY3hHNVFBZE9GMzFicHVTaG9kZTNMZXFkdk1ydjdacFJ5bmxBNG5LYStj?=
 =?utf-8?B?YWw5cVlRK2svR2hyQzBwOHdDK00wb1FLSjBUYWllNzlBODNLWEtEcmVkQ0l1?=
 =?utf-8?B?SExzbEUwRFJvZ2hNUXVoeGEvT014d2xsU3MrSFJ4TzVhNDc1VUVzWE9CYS9m?=
 =?utf-8?B?SHl0OGVpaHUyZmJNcW9LSDlQcmpJdllNTmd1b3MzS25oa2I0c0QxSGxwaGtv?=
 =?utf-8?B?a0ZPd3krUURQSEdhZU8yQ0VZcDkvWS8rYWkrU2hONWV5NG1qYXp3TTVEY1E2?=
 =?utf-8?B?cm05eTVPQ3JxdjB1Vyt0cXRES3JsVEdhWllBdkJGcjEyMjNNT1RNOEFmVjlM?=
 =?utf-8?B?Ty9tNFZ1NEluekhaMWFqeGZoZk82NldhVklCR084N21jMm5BYzlwSXFCNE1F?=
 =?utf-8?B?ZnBQZ1hHbFZRMnBKb2EwUFl5M0dGTkdlL3hDZ0NWVDhxYVlOQVJ3dmxCSkgz?=
 =?utf-8?B?am93UFgzV2YzZVlSUUwyaXB2Uk43dUNTUmYwZDVtKzZsenpod3A1V29SeUlM?=
 =?utf-8?B?ZEtRUUZndER2SzNadjVpb29HZzdxZDE0cFN4NXc1S1Z3NjNSaXl1NGsyalRl?=
 =?utf-8?B?cWVpdkV0VCtNRlpnaTJYVU01cU5xREVHaC9DTGEwbENhNEdQbWExMDBJUy8w?=
 =?utf-8?B?UitqcTNPbVVUT1JZWTZpZ0F1QnRxM0NtbGlxRGgySkJMVDJtNHVPNzR4MjFj?=
 =?utf-8?B?WmVhV01IbjBwSkdTUWdZeUdxcHZLMlpLOGhGc1JUYk5nSHYyOFRyRHp6c1U2?=
 =?utf-8?B?Z2xmaGt6YmFrVnVuN0ZIcDYwV01wNGMwcFJHdm04SUg3UU5BVFFSQ0pGbXN4?=
 =?utf-8?B?VkM2WUJpMy95L1cwU3VHMDFoVk9FR1gvdjVSN2JzS3g4RFRlNHBEbkFFV1d2?=
 =?utf-8?B?ZTNXc2diRzhlSDBHMlo1T0RwRjRTR0RmLzFzemJLRGcyeXJIK0l2SnpWcTI2?=
 =?utf-8?B?TU1ZTENVRFNvZG15cmcveGl1U24yTUJUMWZoeG9KcmhGV1hBYUtZUXRPRUQy?=
 =?utf-8?B?OHR3Vlhjcjl2bUp5ZlRpTzZTZ2lQZjFHMjdqNk9uWnpTN2FWV2dUdEsyUWdW?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c2398e9-eb26-460e-8c63-08dafc5b5b4e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6738.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 09:30:53.4818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJMJQKFX4xaR4cJZ6ayT82b7Tadv33KagRRPlNkIqC1TDR0m8+cGdpsIr81o0PmHHd/LZNKgxYT/DglORpxCeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5793
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/2023 11:08, Jia Liu wrote:
> On Wed, Jan 18, 2023 at 1:20 PM Neftin, Sasha <sasha.neftin@intel.com> wrote:
>>
>> On 1/17/2023 21:34, Jacob Keller wrote:
>>>
>>>
>>> On 1/17/2023 2:26 AM, Jiajia Liu wrote:
>>>> I219 on HP EliteOne 840 All in One cannot work after s2idle resume
>>>> when the link speed is Gigabit, Wake-on-LAN is enabled and then set
>>>> the link down before suspend. No issue found when requesting driver
>>>> to configure S0ix. Add workround to let ADP_I219_LM17 use the dirver
>>>> configured S0ix.
>>>>
>>>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216926
>>>> Signed-off-by: Jiajia Liu <liujia6264@gmail.com>
>>>> ---
>>>>
>>>> It's regarding the bug above, it looks it's causued by the ME S0ix.
>>>> And is there a method to make the ME S0ix path work?
>> No. This is a fragile approach. ME must get the message from us
>> (unconfigure the device from s0ix). Otherwise, ME will continue to
>> access LAN resources and the controller could get stuck.
>> I see two ways:
>> 1. you always can skip s0ix flow by priv_flag
>> 2. Especially in this case (HP platform) - please, contact HP (what is
>> the ME version on this system, and how was it released...). HP will open
>> a ticket with Intel. (then we can involve the ME team)
> 
> HP released BIOS including ME firmware on their website HP.com at
> https://support.hp.com/my-en/drivers/selfservice/hp-eliteone-840-23.8-inch-g9-all-in-one-desktop-pc/2101132389.
> There is upgrade interface on the BIOS setup menu which can connect
> HP.com and upgrade to newer BIOS.
> 
> The initial ME version was v16.0.15.1735 from BIOS 02.03.04.
> Then I upgraded to the latest one v16.1.25.1932v3 from BIOS 02.06.01
> released on Nov 28, 2022. Both of them can produce this issue.
> 
> I have only one setup. Is it possible to try on your system which has the
> same I219-LM to see if it's platform specific or not?
Yes, s0ix flows works on our platforms.
> 
>>>>
>>>
>>> No idea. It does seem better to disable S0ix if it doesn't work properly
>>> first though...
>>>
>>>>    drivers/net/ethernet/intel/e1000e/netdev.c | 25 ++++++++++++++++++++++
>>>>    1 file changed, 25 insertions(+)
>>>>
>>>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>>>> index 04acd1a992fa..7ee759dbd09d 100644
>>>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>>>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>>>> @@ -6330,6 +6330,23 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
>>>>       pm_runtime_put_sync(netdev->dev.parent);
>>>>    }
>>>>
>>>> +static u16 me_s0ix_blacklist[] = {
>>>> +    E1000_DEV_ID_PCH_ADP_I219_LM17,
>>>> +    0
>>>> +};
>>>> +
>>>> +static bool e1000e_check_me_s0ix_blacklist(const struct e1000_adapter *adapter)
>>>> +{
>>>> +    u16 *list;
>>>> +
>>>> +    for (list = me_s0ix_blacklist; *list; list++) {
>>>> +            if (*list == adapter->pdev->device)
>>>> +                    return true;
>>>> +    }
>>>> +
>>>> +    return false;
>>>> +}
>>>
>>> The name of this function seems odd..? "check_me"? It also seems like we
>>> could just do a simple switch/case on the device ID or similar.
>>>
>>> Maybe: "e1000e_device_supports_s0ix"?
>>>
>>>> +
>>>>    /* S0ix implementation */
>>>>    static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>>>>    {
>>>> @@ -6337,6 +6354,9 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>>>>       u32 mac_data;
>>>>       u16 phy_data;
>>>>
>>>> +    if (e1000e_check_me_s0ix_blacklist(adapter))
>>>> +            goto req_driver;
>>>> +
>>>>       if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
>>>>           hw->mac.type >= e1000_pch_adp) {
>>>>               /* Request ME configure the device for S0ix */
>>>
>>>
>>> The related code also seems to already perform some set of mac checks
>>> here...
>>>
>>>> @@ -6346,6 +6366,7 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>>>>               trace_e1000e_trace_mac_register(mac_data);
>>>>               ew32(H2ME, mac_data);
>>>>       } else {
>>>> +req_driver:>                /* Request driver configure the device to S0ix */
>>>>               /* Disable the periodic inband message,
>>>>                * don't request PCIe clock in K1 page770_17[10:9] = 10b
>>>> @@ -6488,6 +6509,9 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>>>>       u16 phy_data;
>>>>       u32 i = 0;
>>>>
>>>> +    if (e1000e_check_me_s0ix_blacklist(adapter))
>>>> +            goto req_driver;
>>>> +
>>>
>>> Why not just combine this check into the statement below rather than
>>> adding a goto?
>>>
>>>>       if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
>>>>           hw->mac.type >= e1000_pch_adp) {
>>>>               /* Keep the GPT clock enabled for CSME */
>>>> @@ -6523,6 +6547,7 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>>>>               else
>>>>                       e_dbg("DPG_EXIT_DONE cleared after %d msec\n", i * 10);
>>>>       } else {
>>>> +req_driver:
>>>>               /* Request driver unconfigure the device from S0ix */
>>>>
>>>>               /* Disable the Dynamic Power Gating in the MAC */
>>> _______________________________________________
>>> Intel-wired-lan mailing list
>>> Intel-wired-lan@osuosl.org
>>> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
>>

