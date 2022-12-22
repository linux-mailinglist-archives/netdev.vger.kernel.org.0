Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB8C65497E
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 00:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiLVXuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 18:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLVXum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 18:50:42 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADA094;
        Thu, 22 Dec 2022 15:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671753041; x=1703289041;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vkLI5HI0mlNGxNYfxarz0qPwsIIAlmN4jt5kuZg2/4k=;
  b=FTvZO/RzaKaU6BpQfj5SAyt9qTsL+1+S6vFizw2gptzfYsa8WqfyLlob
   QZH0UhG3hHgjmNkq6S+gRzaT9pmvg8XMrMTtFPOxGpISW4MnInxSOv1kE
   YPFZQ3m1pdtypW7QJ398KL/P4tkkJeVDtHOJp/leSa9TkkqQhOdoMsZZe
   EKYOFcuLSPP55iNygXXogsENJnoc555lbDxq1uaum8DDJHN0voaHE5PRK
   /5rwsb9sYmV/uIEiNLO1Q1Q65A7GzbtoNn8p/BmxbWjB4hJ6+PF4cNXQD
   dnmVU6YSpaVisXdIip8/mPa3ecadt3CxL9t0COAHRqpa78yMUhpOc73sh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="299912536"
X-IronPort-AV: E=Sophos;i="5.96,266,1665471600"; 
   d="scan'208";a="299912536"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 15:50:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="980775452"
X-IronPort-AV: E=Sophos;i="5.96,266,1665471600"; 
   d="scan'208";a="980775452"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 22 Dec 2022 15:50:38 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 22 Dec 2022 15:50:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 22 Dec 2022 15:50:37 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 22 Dec 2022 15:50:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNM2b/FvQCwfgY5+T5gltM18JaqWxeXkR/EffLIzW3St703oEdKrLggHqI3lWdCPTVdmwZh+HvXCBDOR7R3BVXYXGJPag5LVl9FY8mfMzEYqaqPG9x55zxqtK5M/FYJzeBBE210JVe7ggM/KXYzRQf8D/w3uyjfSj/DmO9PhTBEZBt4I446+CugRwI3QcdLjUkI7WvDUJfWhXIHUUjydME1Hk5LPtrU/cTcEL3XdyiqY96KFMkr+FbA6wcNz7OKsqzwSWHYPcieezvUrzpYEpmWPYnLCrvUszMjoyh02Wl/6C4FkERDCcwgi7NgX/JiWbEAXFA0wCi9mrSMfee/9dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D65JB+K0oSeYrYVwgvm8lxJZz33MQHgPfBgT/fOTLQg=;
 b=UJ64JUcq9eG3xoqJXlQTN5Ncv3+CUQtdEaHR5pAPNzhAbLiG8OKJtZ0cm79+Ewu+HVVhl36wIpS1dqDJx2beqyxUaUOG2leWZOv5+CKlm8jPROSZ/Ywtq6HtYw9EpTIGyRYDm/nRW6zhtnI5wotY9WyETR6LnrsYmFCgmvGHxU7kK7mpres7ir7TprX5QfyS4vJOk08UCb7d/0Z6VfnO77dy6ZYtSDWFaDqDt4nbBiDqwrGnNxLGKTnI5PgKKY5j9jUW5g1j5fS8Se/5rIzl0QrwLWVN5/h2Esak+LBj481i0aCtbgZOjF6/UurSt+R74MBHNtBQXlHTmKXLpqBVsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB7606.namprd11.prod.outlook.com (2603:10b6:510:271::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 22 Dec
 2022 23:50:34 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9%8]) with mapi id 15.20.5944.012; Thu, 22 Dec 2022
 23:50:34 +0000
Message-ID: <0b4185b9-1226-a547-3ef2-c9dc9310a2cc@intel.com>
Date:   Thu, 22 Dec 2022 15:50:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC Patch net-next v5 01/13] net: dsa: microchip: ptp: add the
 posix clock support
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
References: <20221221094612.22372-1-arun.ramadoss@microchip.com>
 <20221221094612.22372-2-arun.ramadoss@microchip.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221221094612.22372-2-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:a03:255::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB7606:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a45e126-18f2-4675-71fd-08dae477510d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LttW3bohIvm4UJkU/vPt67OhEobb6UTXj5HU6XcNnpD5NoPozwBUVhAcY8t3uu/A1tUzb94VWsKCaBqVcYnKdW68HOwWmOExpUZ0hkoxK+uymtc0Wt+MaaL6nI9aJ3gI4HuFoVr2DVJ2rTeP0mN1cLQhWBQfqe3d74xiQWGtzIizJEBJrgY+80S6CFmv4x5Sj4rm5bjN4z8/6q6T25xG4jOHafVUSoY7BwfvFvU+naBD8QNP3OICzBHQPQlSvXwaqB3PSyXx3aoT1IbiU2pCxi6O7ig43mWEJeznM6oThpMOKoqdtRoVKS8/cysIx5epjptajgd0rDwb3uwOdXWJ3AOG2CqsA0PGyo91opjhcE/PKtLQ5s3XPCyf81keXXmHAYRno+Kv2mvsHMEN+LlX2dTuz+YqHsGS/MPb0dSORz/wKUChAlo9jFkYzzO3epFvVgb46rUWHk+yXZdN9IXseYUttMBJjmcifR5idA66AaP37QJ1zB4/+WixFxYfQ4JbS47J/HAz/AQYsJREvHI3ZmJ+N5ZuP143Wl6haPzi4eTKt9B6F+m6Cr6qYoTbTrgEOQowFndvqcaNn1a7uMIwM9I+5MTtPfT9KqQztH1lGgW7HCiJosfRixatHR98BpuHS0UBBbrG/2AD0fM1byXpB+W8qU3v4SVbCaRMaGCRT9J9MfMhUSnU6b72bvGC/tf5BtaCI1s2jEtlAFKILXLldgpsjFMFY61hfqADeh6Hdg8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(366004)(39860400002)(451199015)(6512007)(82960400001)(6486002)(36756003)(478600001)(316002)(7416002)(66556008)(4744005)(66476007)(8936002)(41300700001)(6666004)(5660300002)(2906002)(66946007)(4326008)(8676002)(6506007)(38100700002)(186003)(53546011)(26005)(2616005)(31686004)(83380400001)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWN3d3YrdXFiR1BRamYyTUhrbVcyenBrVmw4dlJtaVBVMWZrLzBZa3J3aTVq?=
 =?utf-8?B?eU0zNXpRSWRyaFFhVWxOZUIvUzEzMmNxM24xNzl3R09XLzF4VGN5NzE5SnRL?=
 =?utf-8?B?WU5YWTNQUDh5YTlkT01SdWVWMFBsMEY1SFBkYnAwRkphQnJYL29FdnovWmdo?=
 =?utf-8?B?d01qak9LOXowWWFRM29SQ0hJZmZUZFIrengwTUIrdHFDblMyZm5aVUlhUjhi?=
 =?utf-8?B?Z1JMTC9ZTll6dVdzemg3akdFR2l5SXkxdXN5N2I5MEQwYndWZ3kyM1MycUtL?=
 =?utf-8?B?Mi9SNnppNFh1WlBXUjJ4Y0JHWnVGK0E3eXlOUDlZZG9iYm85MDZvSkt1ZzVn?=
 =?utf-8?B?UWlmOWJTemNyVk9NYStKUEFRT1llMW1qU0RMM1hYZkNVQno5STRWbG9MMDBP?=
 =?utf-8?B?cWJubGoxdFF2cWdLY1N0YTZhMHhtRGVuSnBmQlpJa2lpN0VCKzNZVXhNeVRi?=
 =?utf-8?B?QUJmd2hvSWp4bndQOHBNMHpybnk0Z0s4UEt6RExha3c1R2pxL25kS3hwbXZ5?=
 =?utf-8?B?dzR3TGgxVEhudWtZUC9wc2xCU3FWSndnWG5Db2FIZWc5RzR3MlNUeWxueGMv?=
 =?utf-8?B?M1JkemEvK3dJVGZLS0FXNE5pb2VNM1BmeDB4V3U1ekZqOFF1dnVjc2xmdURy?=
 =?utf-8?B?d05ONWJYMC93clBWT3VJVGlCMmxVVWJ6clVnZExlTTNzL2g5dWE0Q0JCQlVY?=
 =?utf-8?B?azZSTE0xRHhsWkxZN3RHZlRtOTlVN1FCZW5TTUpPaVQ4UDdWM3J4M1VsQzRB?=
 =?utf-8?B?a1F0Z3BlamlEVWZFL1c4TGtBSkVzNVdXbzRJdjNrdTIyZC9YKzJvaFIrTlkx?=
 =?utf-8?B?Rm9ZV3ZrUVdYRTc3UlExMGJIVGxnN2dBOXJwb2hGbHpTM3JuRUs2NWJSUWtw?=
 =?utf-8?B?RUhvUUZGTnhCclAra0VWQWcybDIrVU5KcENxc1BPaTY3TEFvV1ZlbGtob0xt?=
 =?utf-8?B?N2xkaW1YbDgzV2pOMTlYcXNWR3VPeXgxbkY3allHS0tuZXh1M1dHdFhFL0E0?=
 =?utf-8?B?VVRiSURiQUMyUjB6cjNPSmdrRmpycEJZbE1uRlNMTHFZZmNBeU5hOUNPTndv?=
 =?utf-8?B?cnd1UTNoY28wUGRkZjhLUXB6Rnc0V1JqUWxtcmhVOFpDTWUzbkxxWGF6L2R1?=
 =?utf-8?B?Vll2L0MxZWlqUFdVMzF6cU0vMVN2QkVMaU9wTzVYUHVXcVVYZ2VId0NCNnk5?=
 =?utf-8?B?TUJMeDRtNFNnVE95a25HWWNPK0lEdVh6dzI4K2R5UnFyaDJ2WFpZUFVjd1JV?=
 =?utf-8?B?aE5GU2lYaUJwRVhTSktmYVRCSlZmUGNyYmdmNndDQmt0a0RqdEd3TkVrK1JF?=
 =?utf-8?B?OGtzQmpObWZiYjZoTlhtRllBR1lDbjZOUVV6YldPenkwNWFMK2RPTXhsSXc3?=
 =?utf-8?B?UlpxRXhUMTFPMUZObVZWZTh2bEljN2N1R0lTNUdabkVxK00xd3NBUldyK3U4?=
 =?utf-8?B?NHhYK2d2K1JMSTlxK25DZk1ER1JTUzBLOWpsT0QrdUlzNXA4NWtlRks3clhy?=
 =?utf-8?B?dnFEci9LTSswZEZCamlZMCtBM1ZPRHoxelhMRjlLeU9VU29waE8zc3VDR0ph?=
 =?utf-8?B?d0ZIdURrTXhwbnJLQnNrVithQUlRRGZTNTRTMXlGcVB3L0syYzRtRmV3RHFh?=
 =?utf-8?B?NXNqK2pESVIwdFJ1enExalYzb3JnZnZBNG5XbXIzTDl1clRFNnU3blh5dlJL?=
 =?utf-8?B?MlhqYk51cTE5TlhrSmhOQUZKNUZMYUhTb1F3OUhCbEhjKzRBR0QycGFUSUpp?=
 =?utf-8?B?elVGa0lMbVRjVUY4aTdaL3JnNkN3bDlVeWRwd2ZvdnFiNjY4U0c0NHU0YTFq?=
 =?utf-8?B?L29RMkY5SGxvZEIyZGhMS0NROSs1NFBuZWZWeFZDZE1mUGdxTXNoQ3dTdU9a?=
 =?utf-8?B?UTh5QUtLdExMaDFONjd6dmFRek5QaW52cWlJd2pDZU8yQTduR25SdkJIbkRJ?=
 =?utf-8?B?Sk1GS0pVS09yUFlTbXczNCtOSTV4bFpZN0VWakFGMGlrckdFY2xwYU5ibmJp?=
 =?utf-8?B?aEtGOWdKaFZnZGgvQllUaGY0NWdXbCt2ZnNMZzRxYnFMVE9udHdUNXJaOGFu?=
 =?utf-8?B?V1YyZm1pblUrQ0x3YU5CaUlpRTE4aWFyMkxlcVZvN05NK3QwNmFlWm1PSTJk?=
 =?utf-8?B?bDNxZTZxMEhLWEJBdWJkclJQc2xrWGVESjUyaTQySzJnVlp4ZDA2SkJXMUdv?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a45e126-18f2-4675-71fd-08dae477510d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 23:50:33.9842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YqKsI5t9tBSiK+ALQ7P2NgisWsGavXqkwFs8zNNo3JU3o+yuiYtaJkD7h0evLXjX1hCjwVm/R/NvC3BiXAVWvvBrR79hGA+y4TXY9CwFomk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7606
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/21/2022 1:46 AM, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> This patch implement routines (adjfine, adjtime, gettime and settime)
> for manipulating the chip's PTP clock. It registers the ptp caps
> to posix clock register.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com> # mostly api
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> v4 -> v5
> - Used the diff_by_scaled_ppm helper function in adjfine
> 

Thanks! This version looks good to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
