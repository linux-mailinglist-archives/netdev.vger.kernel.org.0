Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E565968C527
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjBFRvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBFRvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:51:50 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5706E8D
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675705906; x=1707241906;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GmAiu3UUiybLwWBTtd/yF/xKRs/7K9GRFh0kdr9ySsA=;
  b=CUsZHIN4fQCwO4C42senVbgXqwhbS7eOpm7bRqjEhNrL8CAeBmmkXW1/
   NoCB4IHR/utdYh3NznxXRtkW+3baEDsV4k1o03amTBZMfDpHJTWaSEcHs
   T+LsD3vb6cMofbhVCm2EPfCk4ZWNsjIKL08ZyxM8wEg9ZkOTL+uoBBzxq
   DRcNNqsciaUrA7mbnBZdhkE8mc4383+hY3zMUCjRLK1Jb0KG3QGD9uWY9
   POMgeIEc2I3Gb5kLMBHmmfCkFSIiUG2hSptHHeokT9hhNgHrGeT3PAcG8
   zN1kr11j3s70ONbgDd1bxptbRz8tDwVfSVM9kRWIa5/XQlQ6+Q4FvnF1O
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317279857"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317279857"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 09:51:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="912012232"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="912012232"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 06 Feb 2023 09:51:43 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 09:51:42 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 09:51:42 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 09:51:42 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 09:51:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHq5i62+c+d0rqJb7zHZ5BWQWc0EDeSvp4HR4UdCB93nmObVbkya/GoDi8KWQJ/45ne689sA7SGRQC1kau7EzweK4PJJgp7iDPNiBOYDyXB1k+2YTU8xPndmUTu9XlKeVAeF7hDsIQtJk+Z+felSi41glG1rDfR49XBfJwcJ7RAqT/5/NJfx/FjKsfXHCinwjbXnhc5xm0jLnDlbgadYfJSf8+35eE2rB12iDvU6Dqx4vJNH6HBYjhWM6eA3yT3g4ypFfJXY8xz1/ED6nI40lNt2kP+uSKpTdRD2Az33TKkPJ/O+U8EJAHDjObqwPHKQB6QbeG/F7zXla6Ku605SUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxonkN7BGnq8PFI9z7imRijRRZrhqvF4DLFU/NydpM0=;
 b=dUhmWyHEese7XwcZyjhd72jdnvo5huMaSA/AJ4YkdoMUL/ng8RCdLB8oMwjhXtkQTBAFJ973vGcKqBbU/4lcw1N4i20/gApIv51lCJjr3dEZkpwZCosq0wCIPPE1xUFhHX9QNEbJLJq3z/LZ1Jsv0dgFAm9Uy4TamMS4T4L6RYh6P+PgZqATaPdKo5/ACRLhKqpiufsS8jQzKsh0Qui4isYq8A/9zdC4MoOhqKROOyrvMW6qcmkLF6poQkAd66f1/ekiXag+qzCZanZg5S04s9JOBRNIGUhXxGNoWGI4tM2KyqfzNwNEmMOgAfgCInQBAZ4+CusdHMX9vCiYdeVojg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB6049.namprd11.prod.outlook.com (2603:10b6:208:391::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 17:51:40 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 17:51:39 +0000
Message-ID: <529aba02-d31d-37c6-dc46-7a129b8f1b0b@intel.com>
Date:   Mon, 6 Feb 2023 09:51:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v6 net-next 00/13] ENETC mqprio/taprio cleanup
Content-Language: en-US
To:     <patchwork-bot+netdevbpf@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <claudiu.manoil@nxp.com>, <vinicius.gomes@intel.com>,
        <kurt@linutronix.de>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <irusskikh@marvell.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <thomas.petazzoni@bootlin.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <horatiu.vultur@microchip.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <gerhard@engleder-embedded.com>, <s-vadapalli@ti.com>,
        <rogerq@kernel.org>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
 <167567822122.32454.18057858947281179194.git-patchwork-notify@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <167567822122.32454.18057858947281179194.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::21) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL1PR11MB6049:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ebb4bd4-ba74-4976-65ce-08db086acc7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lojFMgrAofpCN23mB3b5AUEVrJwa9Be7jDZIr+n2RlqhsRH8DIFVFFttYK9QFSuEVjfjDFzkNucdjEEyVo7HDoOqLk1W+5eN6GjAH1XaBy9AR3lc+LSUqQ2Al+AVSEjdt2lhPNu+LXq51sRfeynCHmgdOKmB5djmQiXbw6JSwsYdn9ReQxlJh2C+xvvKc9keR2LpGyTlGDdcPe6muskQTU6cDvl2SUa969EKDN0Z3NjjPg43oj4mToiVBEuEIxLsTY5N/hhvCjklUaivSeV02/h3vhTB6ZqlCf32oeXBRTr9SR06A49tl3oD4ySwXh3X4GjBPi2dw+b4HNPZsQf0Xj37gx8FXBXXWmf5Ddp7aKjaEfV8qoxnvEEEvqo270JZvmmFIdKjTBaNTNUOzQAE0gD0nerRRLJHuDvapx5UtLAg0FGKU1xvdLsmc008q2JcbJWqHjAcFRpbX5eYb1TNbn/vuk8x8yAfjYt1hisfW8RvelMGVaB1RoyrRRnnV5X93EIEWbGIGsBX7YZ5GAiO7ayCB6zHuufoqgopPjGgCXLRuOQVwuGRSL4nm3XCqEcRpN8StbsZDHIF3foFfpX0Wv8LCzvVsHiQDHg0TuWKM0BucKsyEiMD4QctSrvtyRNt/Oh1OEUxu9DeHtug6DICjG8xahqXG0LvyywltiJmqWeygtnXI/cicDTFLC/GNP877mKZiztTl5R6hUl2bypgeRx2KGTJTwhEOtK/a3NNpyeilHzwawdfmgXg3uLd55TteDp0UdE9ExCMvjWtjyOGI5FjTkEgQ9j2B606SGeWnyOZvQcK9pI/tvOB+bPhUc18
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(396003)(39860400002)(136003)(366004)(451199018)(186003)(66946007)(38100700002)(82960400001)(83380400001)(5660300002)(6916009)(41300700001)(2906002)(66476007)(7416002)(6506007)(8936002)(8676002)(66556008)(4326008)(6666004)(6486002)(478600001)(966005)(53546011)(2616005)(86362001)(26005)(31696002)(6512007)(316002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGtMc0hWMUhpOTliVyt2ZS84NnhGSitRUWFNbEhXS0RYYU00MGE0QlI0dmU2?=
 =?utf-8?B?bTc3Wkp4WHE3VnowbmM2S2lRcEs4T2svcFpTUjE1N0lUMmpkRGYrSDhhTUQ2?=
 =?utf-8?B?Vkp5TFZwOEl3N21rUzNxSmpvcEFrMHdWL2J1ZXVtNWZvVFI2UGZvWUJpYSsr?=
 =?utf-8?B?UFdKKzFnd0szQXRzVEdIbTVib014bUY1QnpJNDNoZ0RESFdOSFBGeDhuTVJl?=
 =?utf-8?B?K09iL2xRa1V4R0VZTWFpYmp6clJBK1FxSHRiV3Y1VTZ2ZHpaUnljdnlzT1Jr?=
 =?utf-8?B?VXpQVXZ3WGpUUm13emRBQ1BaY1h6MGhaT1hndE5Xb3ViQllUWFoyRjhWd0Vy?=
 =?utf-8?B?Y01LSHRKV2RDd3h1NUYvcngvM0UxaGsxWWxsMkNEUTlFOC92Y0dNNTBmUGVt?=
 =?utf-8?B?VzhWS0l1dVBRQ1dySFBsRXBhUGpjVUkreFMyQTNwVGQyeUZWRGZYTVo3aEts?=
 =?utf-8?B?bXNHUk9HeXNBcWptUDVmNXR1cWpDYXM3TE1GRnFlZmwrQ0lrRm9YcGx2SUI1?=
 =?utf-8?B?MC9JTGxBZmlyZ1phK0lIL2NZV3F6emxIZ1dtQUx6YkxxaFkrT1UzUXNhWWo0?=
 =?utf-8?B?ejgyWm9tK0JtMjNMYTNGeXJlWG02Q1RoZEZqSjJla0NEWTdadUo4S3JTSy9n?=
 =?utf-8?B?UFJaTHZyR1NXTkxFVFZxdFNZaWZnWWY0V0ZhQXZOQWJpL3NhYklWS1gxNm9a?=
 =?utf-8?B?S0NTeFFKaFpNQk9PUDloSDNzb2Z5eGlwVlZyM05lVUlZVEtYdmJsOTNmUDJT?=
 =?utf-8?B?a3BXcVdQSG5SaFJGNWIvMFlPdVFnZU9zV20rUFR0VExOTCtoSFhlN2RoaHI0?=
 =?utf-8?B?YTB1VUo1d3JiRVVUd2xQVEtBRjFKSVRLU1dzalB4Z1pmdmxpa0RlMmZEdGxo?=
 =?utf-8?B?bnYraUVJWXljQUVyOGV3K3VaV2llS29mc1lRMVQ5MncrZWVoNVF3c3htWkI5?=
 =?utf-8?B?UEFpQURzMDEyZEJKbnB3ckFmMS9ibG5pVEYxN3dDSGYwZFJUSi9BMHk0UzJF?=
 =?utf-8?B?c0VBOHNJNnJ2b01ONHBwR21kbUVtOTU4bkk5cVFSSkxNQTRyMkE0dXcvL1dJ?=
 =?utf-8?B?UFcyS2d3TlNYeXlGd1VOWkVMWFpLTUlDTzJjSjVoNW96dEFrbDU4RW5seTlR?=
 =?utf-8?B?SjZFeG1XSzlubzg1UUJ4UGlNeUxiZXp4T1FtRk1Tb2h2QnR6SU5leGZJaXFC?=
 =?utf-8?B?Y1F4K1hNY1VYYWpDRVpQU3FzRjRqTUJEa29aQ1pMZXE0d3oxbjF0cys1Sktz?=
 =?utf-8?B?aS9Qa09tYmxiY05vT21sUGRlRGxQalAzWFJ5LzRQM0phSlBSSVFub2JaaWdL?=
 =?utf-8?B?VTVjUGNsdGJLSHRjSkdqSXdkWjREa0FJaG9iV2svb0dRNG04ejVBQ0NhQ0FD?=
 =?utf-8?B?ZGFZYUp1Z3Z0VkdWNG1ZaytlbElsNUQwSWVaMjgrSHpCUWEyZitENTc1Nld1?=
 =?utf-8?B?eTVoVWV3V3JmZkJ0Q1QwcnNiTHcwd1dkYk5BUFNMdE1CUklXSVhyTW45Q3pK?=
 =?utf-8?B?OWtDanRMVVZ6N2FadEl5U0hoeXRXK3VhLzNrOVdVS0ticmxNcHJoaVRmd21F?=
 =?utf-8?B?eC8wYXNJNFFTN250Z0taUGZLNVJYK2pqSVhwblgrbXRNbVBISUZsZktwcmdm?=
 =?utf-8?B?a3NScEtCdjlyeFo3QXpWRTM0QXlscmw2R1J1QnpEMzJCZFk2OHVqK2Y2M2hq?=
 =?utf-8?B?dEFZenJlWGtxZ1RhZW1FZ2ptSTk0ZWdoa1pubnlDRWNiZlVmdGlUbnB4WlZt?=
 =?utf-8?B?OS9IWm82NGpWSkc1b3gxbTRyeFd4QTAzS3RycmhuM2lLNVFrbVRQcXBLbUlJ?=
 =?utf-8?B?WkxkdlFjM2N4Rm4rbXNnaGxjU1dzbllPQ2lQZ1BsUldKRUNTWnZoYVlKZThN?=
 =?utf-8?B?Y0s1SWc5SUR3S0FxZFZVZFpneW5LbW5BbU5RRENJOXNja2dhOTYrMEllWnRS?=
 =?utf-8?B?UmdDM1UwQkRWMjMycDQ5WUd2ZWxtWmdCMWlkYUhSTU1DV2xtdnRnYmJsZ1Vt?=
 =?utf-8?B?ck1xb01NMnphaDNTQ3RkeStmOUJhQlhUcjhOMTM5emk5NmtYa1k5OThjQ2tH?=
 =?utf-8?B?WjdJR1QyR25sY1p3RHRqRGxhRjYzSmQwR3h1Y1BWYTFhVjNabjVOa2ZLODB5?=
 =?utf-8?B?dFI1VGpsWSt5OENabTV2eEhFWnM1UTIwOGNwdzFDQ2FmTHA0WHloOTNpdTln?=
 =?utf-8?B?alE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ebb4bd4-ba74-4976-65ce-08db086acc7f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:51:39.5544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAwqgDRC6GCs3r2TDnyKOJjm0i5DPz0ZO2u5MnBPM+oR0lm4datrVDAE5wIMS8SfkId2aumANn5rVzeOSHdheel4i6fTr2ES8P8OHmT2uaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6049
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/6/2023 2:10 AM, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Sat,  4 Feb 2023 15:52:54 +0200 you wrote:
>> v5->v6:
>> - patches 01/17 - 04/17 from previous patch set were merged separately
>> - small change to a comment in patch 05/13
>> - bug fix to patch 07/13 where we introduced allow_overlapping_txqs but
>>   we always set it to false, including for the txtime-assist mode that
>>   it was intended for
>> - add am65_cpsw to the list of drivers with gate mask per TXQ (10/13)
>> v5 at:
>> https://patchwork.kernel.org/project/netdevbpf/cover/20230202003621.2679603-1-vladimir.oltean@nxp.com/
>>
>> [...]


A little late since it was already merged, but this version seems good
to me!

Thanks!

-Jake

> Here is the summary with links:
>   - [v6,net-next,01/13] net/sched: mqprio: refactor nlattr parsing to a separate function
>     https://git.kernel.org/netdev/net-next/c/feb2cf3dcfb9
>   - [v6,net-next,02/13] net/sched: mqprio: refactor offloading and unoffloading to dedicated functions
>     https://git.kernel.org/netdev/net-next/c/5cfb45e2fb71
>   - [v6,net-next,03/13] net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
>     https://git.kernel.org/netdev/net-next/c/9adafe2b8546
>   - [v6,net-next,04/13] net/sched: mqprio: allow reverse TC:TXQ mappings
>     https://git.kernel.org/netdev/net-next/c/d7045f520a74
>   - [v6,net-next,05/13] net/sched: mqprio: allow offloading drivers to request queue count validation
>     https://git.kernel.org/netdev/net-next/c/19278d76915d
>   - [v6,net-next,06/13] net/sched: mqprio: add extack messages for queue count validation
>     https://git.kernel.org/netdev/net-next/c/d404959fa23a
>   - [v6,net-next,07/13] net/sched: taprio: centralize mqprio qopt validation
>     https://git.kernel.org/netdev/net-next/c/1dfe086dd7ef
>   - [v6,net-next,08/13] net/sched: refactor mqprio qopt reconstruction to a library function
>     https://git.kernel.org/netdev/net-next/c/9dd6ad674cc7
>   - [v6,net-next,09/13] net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
>     https://git.kernel.org/netdev/net-next/c/09c794c0a88d
>   - [v6,net-next,10/13] net/sched: taprio: only pass gate mask per TXQ for igc, stmmac, tsnep, am65_cpsw
>     https://git.kernel.org/netdev/net-next/c/522d15ea831f
>   - [v6,net-next,11/13] net: enetc: request mqprio to validate the queue counts
>     https://git.kernel.org/netdev/net-next/c/735ef62c2f2c
>   - [v6,net-next,12/13] net: enetc: act upon the requested mqprio queue configuration
>     https://git.kernel.org/netdev/net-next/c/1a353111b6d4
>   - [v6,net-next,13/13] net: enetc: act upon mqprio queue config in taprio offload
>     https://git.kernel.org/netdev/net-next/c/06b1c9110ad1
> 
> You are awesome, thank you!
