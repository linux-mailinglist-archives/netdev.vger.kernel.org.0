Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3C76836E5
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjAaT4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjAaT4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:56:34 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE434B18F
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675194994; x=1706730994;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cRAnJRdkpuIlWutvwN8yS/ZHyKjUKVl9tJqLQrCN7Do=;
  b=CrX67sEf9mqgaBaxeGEImqaO0z3laX9z9QgkUSQG7XUC0/U/s8p/Bfgl
   zByNCDZdZJtfsOujQtp8jqn4bXDe/+vSSfOR2IwBDzHmYfgYmhIuKPeZu
   l4n3zf66esnQ+mtjSX0NiS1bDtZAWRcqBBhE6hHVp3MVf187CDzW91bMR
   tjcB54kZlBlcwxcPkstpWFkPbAS8tMOThUrSngioTEC1Jvf4vrlSmVNPX
   pebtuJUT+fprT4xhRjDGzi/72q2QNKvy7Zt5rgahdgdCABrvjNCsUg1w9
   BWBKoWuzfKsT09ZWKlqDKMw+hc5r335QR7ssjiBRvpCAaj52tS0fd0sQC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="311568993"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="311568993"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 11:56:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="733250993"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="733250993"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jan 2023 11:56:32 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 11:56:32 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 11:56:32 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 11:56:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFePO7tjewsdVkfECyimcK/+mHOT/b1T0iwy+cxqng3YkPQZD+vxeGJ/QqzIFWAuplAZxyo5Bhibt9rc43QBRGh6FL+NBABcKxH0YSLXpNRMdC6xMKu+vsBmxeAZ5vykzJR7QbrEZJSbi7mtnwFDCalH6F64L/wPU9Xs2yKArBT2/TSOQXa+k71iUzbhC7+YUknog/WyiWvVDVHt5oNHub6O2mySCgaNMe17KlDnkYj1QrcyLgoxzaPGN3edMXWiA2Wz41gkrM6mskfkrF/vDmOZIZ+hwl05JkavqwI96uHD+DpLszSHa8waKAOmfux+42s31GJyC8III9iDIkZyKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZoE0F0xjgBc1h7qKeNj38NvMrG4PnD1qQkYC+DTEPko=;
 b=JHC4X5mUlkbekVOzxrIUhAhCrfZZwcT8c5rmC/Cb35r8dipCH1BFle/NM6Z1ZjocjnY/nBjqwwYGzjG8htQRSCFWkQcxdbQlAJP1BH9zyZvMWxg+ZP1zzDKvTjn8QWR9XXMsCUiiQafZa4tXyUUzGieJlGNnXUbglxv43JOcZrHJeu/o8UnQcd+hUYjTtjUHeqWTlBlhXL5mU4LJaAYyT3Wfr7L/sT7Ur8dvdPv1C9ypv+ISUihE1eQ1aUeYGu5oFFuCt4RUczJ+h7mu/9x+AkrBSdErLMoARkF+pSiXM6qQa8ksUmLJtc3J/mXJvG04uiXiV4IN3yMFpGaYDAGkxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN0PR11MB5988.namprd11.prod.outlook.com (2603:10b6:208:373::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Tue, 31 Jan
 2023 19:56:28 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 19:56:28 +0000
Message-ID: <7106dccd-4f3d-17a1-0897-604a1025a937@intel.com>
Date:   Tue, 31 Jan 2023 11:56:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: PHY firmware update method
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Jiri Pirko <jiri@resnulli.us>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>
References: <YzQ96z73MneBIfvZ@lunn.ch> <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch> <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch> <Yzan3ZgAw3ImHfeK@nanopsycho>
 <Yzbi335GQGbGLL4k@lunn.ch> <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
 <Y9BCrtlXXGO5WOKN@lunn.ch> <7bd02bf6880a092b64a0c27d3715f5b6@walle.cc>
 <Y9lB0MmgyCZxnk3N@shell.armlinux.org.uk> <20230131104122.20c143a2@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230131104122.20c143a2@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::23) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MN0PR11MB5988:EE_
X-MS-Office365-Filtering-Correlation-Id: 76f6a336-bf4a-4a2c-3143-08db03c53da8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C0Xcyrhw98sEcBRQupkPQq8PeXV/KsFQqRQnVBl1G8rXc4FRaOiv0Zz93E3JA4zMg/R7qy0iju7vZ2jLkn0BxVRSi/egdm6NNukmilaHcCqfwqshZuNOCVfSYO310D6qVPnVXM16hoIYbDOvREtnH8gIdRsP+1l5HcduWGruvYESnTBQkF5kqGCNQA3X9B7Ubh/I4+hlgoeCsMgIr22nvQe/rrM/pQSWRvDFDDNsjXn3PGJ+aegQvOg5c/XTDX7IexEuUKHBeqxjY3s7ANCIp1fXd0NYMrokjHZFUZDiyWqK2Jwhm6r5LZic//y3Y4W2TLBSK5c/jJM2CrlUHfR9wwXNp/pxY1qEOgdzEkpuXfGEO2F6JphsVNh7/Z3jboJQwOBD3Vkct52rEyjDtQQpvrCpfpW0bj8DRPYWDZz+dFqfYBND3Mpvu2o9O5CA+lEOdpCugY4mJK4kpGYb+Thg6nkN/5JPFIU+NSQbDWwUG3FPEza44ZQ+tMVn+oqXCjK4/kcgaKc5zOmmtlPNDpZqllC33hhMmRN1xL/Ja8vzC+nwJY3kTSXV9zruuRh5JhKCMRjJEAV6ebQFhPCy2LByiqIlvL9KhAFh4zz4oZhtpPoAEj470MHIzow0tj01+RQN65JEKrYGiCGCMHhjog+0d6rELjXv7qdxJp7FweqwEuIs2z8E88ouB46SDJwN9uLzLdLx+IBAcgRoKc/a5JB5u3Z1kM/6UUh8NNtv+sMK+38=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199018)(31696002)(86362001)(31686004)(36756003)(38100700002)(82960400001)(83380400001)(3480700007)(6506007)(53546011)(2616005)(26005)(6512007)(186003)(316002)(66476007)(110136005)(8676002)(54906003)(6486002)(478600001)(2906002)(4744005)(66556008)(5660300002)(66946007)(4326008)(41300700001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1F4bkY4MERZZDEyZkZ4eEJkU3JZaWFyUE1BaU04ZUcvVUVmVFlVNmNpUlhJ?=
 =?utf-8?B?a1lJWFVjNHVlWHE3dCt5NHlRbXQ0bUVQcWJNWWVsdThtZXE1N0dDWGZFZHJB?=
 =?utf-8?B?MmlGOCt2QjRRVVlWTlRqNXgxOVh0bUw4K1YyMG5MM0FpY1o2NU9yeGcrUEJY?=
 =?utf-8?B?NWZwZWZIWUc1dytYS3FDa1AwYlJkbTBmbW5yMG4yd0R5R09zN25GVHBtc0tJ?=
 =?utf-8?B?SDExaVBmbjJkdjQzVnVTdVZOLzhHOEs0SmhBbURQWHBET24wTHdRaVdudytF?=
 =?utf-8?B?U1lueFJNaXBPcGNSRDN1ZUY5Mm83aGpja2VWc3NxWmRFamFGZ3UzTW1XS2Iy?=
 =?utf-8?B?MlNHVHE4Y1I0QVY4MUg0YW43U1lTQWpaSVJoc25ndG1IeFd1b1JoNGVNbXlj?=
 =?utf-8?B?K1IwWmdHai8vam9DR2wxUkloYml0WEpmRmtudDE1KzE5My9LRXBGL0w0dVp1?=
 =?utf-8?B?aUFWUllMdllsSXlLU09qNm5maFd4bGgvTzBiejRja0ozOG9UQkkwZGdqNG9H?=
 =?utf-8?B?YSsxdERNUzZKYWo3TWhQZTBNTjZWYmpmN3dSUlNRdDcvTEt1UDMzV1NJSDd4?=
 =?utf-8?B?TWJObE4xT2FtQWFUWjlvTFhqS2tuY0wrbWYxOFpHcWVCRHZUNVdXTWRIUzV6?=
 =?utf-8?B?WkkxMkNRTUlaNXBLaUlWeTRuN1JNaHRCMEl1NEFnMEpZUnZ3cEN2eTZNUzdz?=
 =?utf-8?B?cjRTVUI3VWxYMC82eEJ3OTY4SEJFL1pBMm1SUGdhVjZPOGpwSjhHekJqazFu?=
 =?utf-8?B?djFKOGsyenUxTVpJRmF2SkdFVytOZ2VKMm8zZXR3ZTc3MVJyaVZDVXU0dUU3?=
 =?utf-8?B?SW5hM0N5ak5rMWx5MjBkL213Z3lCM0lpRHltc0hIcjZxOEtRSnRueUVUUEdh?=
 =?utf-8?B?L3dwSURDUlNManQ2UlN3UXdEWmZlbzhUOFVuTmtqL081ZlYzZVYzVC8rR29x?=
 =?utf-8?B?aEV2blFxb1dFU0MzSWU4Z3dKQVVndWUxNWtyVjEvem9KU1doQW9rdlNubUdK?=
 =?utf-8?B?ZnFDVzRrUnlVVlZ5bFhWWE9TK1dIV284cTVvSnB3TGZ4bUY4dFJUNlZ2SlVo?=
 =?utf-8?B?YzRiVGJQU2hjd2N6YWVtOHdtcGhDaWcwcjNiZnRiQkxCM0hXRGNTZnZRVzBq?=
 =?utf-8?B?WmMydzNpM01sTEttVkE4ZWN0S3JoV2Fxckp0bHMwTFM5bkEzS1JNcmtaeE9R?=
 =?utf-8?B?b3BUb3F4c3NIMWh4SWFGR3A1R1l1RzJMWHY0djJUOWl0RmZuYlJqVmVPUmF2?=
 =?utf-8?B?aDR5cGhvWVQrajlOK0xETmw4L0tvWWFWMTBWWkRDOUhna1p0Q29GRlNjSjd6?=
 =?utf-8?B?UmhPby9GaXhoMlhBRXBxRzl2Qk9qSlcyZnh0TmNYcW9TemdtZlJZVHpaeGhl?=
 =?utf-8?B?QmpJWTlHdm5wdmlVblIwa0czYzJKZTRaVjZSelRwaFJBRTBXZ2x5QlU1QWxz?=
 =?utf-8?B?dXV1bHBKenAwMGFCQ0VaRXBTNngrNGU2VEhYZ2ZrU2Y2TzZ0VlJuVm5QUFBq?=
 =?utf-8?B?VElOUkpQTW1sUEkrejVTcEJ2Tk04NUo3NUQ0Nkt0alBoL0FrT0dYTXZsd0Nt?=
 =?utf-8?B?Z3VYRVF5NnBDa3JoK0NVUXEyVWNvM3RuWThnbXQ2d3VjdnUxeUt1NEVwR01Q?=
 =?utf-8?B?QkRYRTZVK3pPTFZxVVpxNTYrZHBwbC8rOWR2SExRR3NwRi8yNFBKa0NEdjBO?=
 =?utf-8?B?ZU1rejJ1WUpBZEx5MHhPTGFqTGwwTHhLaGRWOGM0MU1JcDh1R3NGd2grVzg2?=
 =?utf-8?B?Y05CbC9JY2UvYlRNMWxZYmxwdkVmeGQzWkR1MnlXODN5VFlOR05vUDFac3du?=
 =?utf-8?B?amc0ejZJK3YwU3h3cjNtRmVUdlUwZlVkT2VKbnB0L0ZyT1hOVmgyTFJVZHBR?=
 =?utf-8?B?ZGRzQ1ZsMzlXWmlLQmQ3cmZWMVhRVEJnaHRhMVZGcFNOcmhWWXdsSWpzdGN5?=
 =?utf-8?B?WG5lTlpTcm00dzVQZ1h1V3NVZXkzWStwZ2ZIdm5CZWROWGFzbDFLMWpvOXRU?=
 =?utf-8?B?OFFaQlZsMzFpQStlZ1ZkemZoSEhoQVFscFRpMHFNWkYrK1U1T2hOejE0NE40?=
 =?utf-8?B?S3I0cm1JOUt2dEpYbnRQck5qMDdFVURDSHRSeXg1TUNFVkFLRGN6ZW40VUlJ?=
 =?utf-8?B?Vk5DNnpsNEtXU0xTdjBNWmVXbGd1UDhDUHg2aWNnRzYzTWZYdUw0bmVqU1pD?=
 =?utf-8?B?RHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f6a336-bf4a-4a2c-3143-08db03c53da8
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 19:56:28.2803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1mWIepCfGRrsvAB7N3kPRP0GBuIin7YOU7tpBdJJgr7U0FoV8uW0tIW5ZvsBHT8QWUyjtMSXR/+gcuo07LZs19Zt7EiK7B1aGl517miWjyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5988
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/31/2023 10:41 AM, Jakub Kicinski wrote:
> On Tue, 31 Jan 2023 16:29:04 +0000 Russell King (Oracle) wrote:
>> I really don't like the idea of the kernel automatically updating
>> non-volatile firmware - that sounds to me like a recipe for all
>> sorts of disasters.
> 
> FWIW we had a concept of "FW load policy" in devlink but IDK if it
> addresses the concern sufficiently. For mlxsw IIRC the load policy
> "from disk" means "flash the device if loaded FW is older".

My initial interpretation of this parameter was that "LOAD_DISK" implied
the device could choose to load the firmware from disk but didn't
necessarily overwrite what was stored in the flash permanently.

Your interpretation also makes sense on a second review, but I'm not
sure what "driver" would mean in this context? I guess "whichever driver
prefers?"

The parameter does seem like a suitable place to allow admin to specify
the policy.
