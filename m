Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A952575943
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 03:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbiGOBzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 21:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiGOBzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 21:55:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBB92C65B
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 18:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657850144; x=1689386144;
  h=message-id:date:subject:references:in-reply-to:to:cc:
   from:content-transfer-encoding:mime-version;
  bh=aiwTKIrwzdGG9uDMEYzzz3rolkTFIVX2w9IzHECZ2pw=;
  b=jjmvicMAM2Pyjmx7bVXtcVSnPY29mCVc63ZO3VGSSbiCIM8D8XJOgp7s
   LlDFnqw4XAhXSlPqBnIXwzFAoW18ewIiQXXwaZPOSK+guOZ3VB8ASqKdD
   THXjZDmXESvdtBya0DJsZ1iAaraxNESuVEruEWyPv1JIqDCHM8PV8+116
   EW8dtOgPid1cBJK4rrR+Lbmce+1jh9U49wjPn94Xeom4CPz5+5SueUiJT
   ERkycOFSLWqCUmDw4RbSrqiGcmrmd1FO8qCmQ7/wZW9fqVLFhSQUrtRmZ
   CNmFsOsCeKtzrwYPPEm06ngnkESmWu5cTY2X8GpEqbMn/0FwGwcb0ukPJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="283236605"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="283236605"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 18:55:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="722931471"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga004.jf.intel.com with ESMTP; 14 Jul 2022 18:55:24 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 18:55:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Jul 2022 18:55:24 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Jul 2022 18:55:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBB9yNzV4PewtrQsX4syR95VW6wujo3tN63hHj+ouqYzFz+F21ONtQT3uA1IspONVIq2L/LtM6gpb8Tnhs8efyE00LsJvPFRQ0xO/1lvVDguU7qQbJr4+jAF1meXp9zGjG6vLBnBQTzVvkuK56vavHqHQNp7q0LgmgCUYELGg8620TcBVdEYSD39DjvCmPFDISt8CB51hIBZP/Gvna8REXoohdD5bmxrdjimVS2cWOLU2QMv859fSFlWxh3FHgF4MrMKGIvpxbQB7kv5ZfalT5+9HJyQYgz5fcxMtwStPRJNcm+p6FGY63iRqrRn/j8Tk7tiQmpEABxReh2y27f+dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DCiScpvOCyCStmbKIds+Y7LIyFodHx6l7+vDAyKT0E=;
 b=UWNmyAjl/quXtZ9owPnb8h6it2DECOKbjSZIDkUF2SIrwztoZx8rhAw6ht4FO308mO+rPWnEHIDZzd9kTVZbku7GDhJKlk7Alal21U7+AU6YWwjOZwDtF7CX6qm66B7WUH/xMOLNLTt/rF4R48aCz1hXHtrtEnHIGvleZMXcC88cOvHhfEK2fmtDKpjOLIRZqAx3W04zvtqlj3nmCmbmMFCR+Ixp6MdeG45vLXOwN92EZdhSriQr1CDYBkxDuCjMt0J0orrOL2kOQx6vkDb/z5jrBGN8hBs9FCyNk3uanQe/h5Pd7rku4t1iuvjU4440mXDMBQaiL/BLeYo7loxlkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB5933.namprd11.prod.outlook.com (2603:10b6:303:16a::15)
 by BL0PR11MB3330.namprd11.prod.outlook.com (2603:10b6:208:64::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13; Fri, 15 Jul
 2022 01:55:20 +0000
Received: from MW4PR11MB5933.namprd11.prod.outlook.com
 ([fe80::71d0:716c:7d6d:94c4]) by MW4PR11MB5933.namprd11.prod.outlook.com
 ([fe80::71d0:716c:7d6d:94c4%3]) with mapi id 15.20.5417.026; Fri, 15 Jul 2022
 01:55:19 +0000
Message-ID: <22ad9e6f-340c-3a34-cf0c-3d9487e62b4e@intel.com>
Date:   Fri, 15 Jul 2022 09:55:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 1/3] net: Add a bhash2 table hashed by port +
 address
References: <202207142304.r7aVTnSg-lkp@intel.com>
Content-Language: en-US
In-Reply-To: <202207142304.r7aVTnSg-lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>,
        netdev <netdev@vger.kernel.org>
CC:     <kbuild-all@lists.01.org>, Eric Dumazet <edumazet@google.com>,
        <kafai@fb.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Joanne Koong <joannelkoong@gmail.com>
From:   kernel test robot <yujie.liu@intel.com>
X-Forwarded-Message-Id: <202207142304.r7aVTnSg-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:3:18::18) To MW4PR11MB5933.namprd11.prod.outlook.com
 (2603:10b6:303:16a::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b25375f-9736-4fda-1680-08da66051269
X-MS-TrafficTypeDiagnostic: BL0PR11MB3330:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yrQaaJNWmqRCXHB3grTtQ2lkMRUUHycjjgoWA6tLE1iz/swtBuvgEGtKR1MqpjIsxgJzoUl9ZPS5POtoCfOMpZ4lrle2Qt60bBWl7ENPAPGkkV+fl0xg56jFuXWRRo5oPgZwf0LNZm2x0U3rDryANFvAbSFllnB9Vc/2ojm023dTOAk2M18o6AMRIyyKbK2aJweqtWZLnavaWhfn/puBTYSNuo5tWOum/JfelbaNdMcxuK1mn4fhJICBOtJZQ6oExQOMyzYLas5aMgWuRMSz91lX7pKubDYTaDMNDZ525Y7MGksTtrj/XkG4r1v95i8s9OYCFKA6pjhWT+ePN75koFDre0DR+z6LV07h9Sigrb7i/aGneOVyxS8n11LlUqe+hTtGy6xt/JzoIAVYU3h42/ehT8pKDX696zduVB0nW/icMGPvLuaCrI3lIvbpMhe0neg4ZjfDF1b8EK3by/NHpVfWwPNcF57j++p/NYnj1r8R1Vvt4EsgHsfEuZ5Avf5ro63FE18qgDHY/hlcGuWn1oStQoZsGIHwMmw4I2AMaX3gsrsYar1uGqERFIQ9QCh5aoSpO1neeG1BHYtv+p31aDV6cjJ56UrqWElkfYbdQb4JB8WlRb/IqHFg+YBYzd0uZvbcPsw5GHIRH1jKOA+OULRirLz7g3GVauEiYbN0f9aCLjgFhvjgTnlEfdvn8g17/LIdW4GXfWoR9oP9FtYq+qV1uvThFHTYMVgKcSsvbq023rLshhJ4lOQapozoFZViU2psNKjk1oKP61XXXryHpZIRsrt9qcy0+rPZrA6RqEI4tX25brtlIzmo5VyNow0+PYl9uI8P3b/Er52ZB5+yD7dr6eA3q6DQn7BAgk7YDZXPVxkKEdwrwWiJ//9vFA1LffXFk2E98oJdSnLMNxvX7v/+7T/R0dih33tfmNr0+4g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5933.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39860400002)(396003)(346002)(376002)(6666004)(31696002)(83380400001)(86362001)(54906003)(110136005)(316002)(2616005)(66946007)(6512007)(6506007)(6486002)(478600001)(966005)(41300700001)(186003)(26005)(66476007)(31686004)(4326008)(66556008)(5660300002)(8676002)(2906002)(36756003)(8936002)(38100700002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWdkNGVmaTc2ZEVqdC9RSE11bmRiU3pnaHAyUnBTQzAyeTBqdC9wa0pYdkww?=
 =?utf-8?B?NmdVZFdLeFdHMXdVVWhZWUIyb2xMcVVISWRveDBacFlRd1lIR1puOEdJaEZO?=
 =?utf-8?B?dUpWQTJhbUlJR2sxa0tSQlNsMW95Ty9ITTJ4YjBTcFIyVWd0VGZka256b2x5?=
 =?utf-8?B?RjVjNWoyYmR6cnVmdGp1VlBCZG5UTDljb1pRUnlRc01rM0tvYzc2aFRLRU5T?=
 =?utf-8?B?Qk9QVmhuVTBPT0JEcWFnNXI3QUY5UllXME1meXcrNG1hUmRBak1xTWVNeFBK?=
 =?utf-8?B?M3dBdHF3TkhlWnM1bE9UdCt3VFZHWWIyOG8zeFNUdUdQWmxudDRnMjdnRVNG?=
 =?utf-8?B?WDQxdlVvcWloRW41YzNyQ2tZTkwyN3kwQzBhcnJkNmloWmhzdEdmd3ZFZ1NZ?=
 =?utf-8?B?cFZzU0xLcFovTnFQVXZDbzVpZHZhYi9NODBPMVVBLzBmdUoyN3ZKK1Q3TGIv?=
 =?utf-8?B?cC9OeXlXMjI3SGEwVnVKdGpSbUFlQkUzTmJxa2NnbU40eTlIcnkxTFc2UVBZ?=
 =?utf-8?B?K1pQaitnSW9uZER3c0N6bnMvbjhaTkxHVHN1U0dkOE1GSXlIQ2IvanFSZkZG?=
 =?utf-8?B?ZDNuWHFPUGpBU1A0bHAxRGhXV0FjQmJldVEvTnZDT2dwLzJOZWlxTkdVd0VS?=
 =?utf-8?B?d1llc3pySlRaSTBEUktveE9MOERDTDR5cDBDeTUrTVg5QUQzcVV6dy8xT29U?=
 =?utf-8?B?dGRwWjRkNmF6VEFST1gwMVdOQ3BwZFo4VGpLM3UrYkV6SlBGSHFlOUxKTG10?=
 =?utf-8?B?R21xQW9aMlZoWnBZYjlNUlFQa0MrT25POEFLSEN0WGZLZlgraW83OVhsWjRn?=
 =?utf-8?B?RGRZQXJ6NmFzQmx4NXFSazBycVZVMlR2Z2pjYTI4RzRFZjBndjk5MFlwQjhV?=
 =?utf-8?B?aWtsNEZUd0I0SU1qTFBvVndBMGVsTUlrcFYwOHJRc1VyeE10bVYwOExudVgr?=
 =?utf-8?B?Y3lSaHZSSG8zYStwWXgrNXE3OC9mOENRR2N6UE4xbFFlNGU4K21zYWpGMU0w?=
 =?utf-8?B?Q2thU21VR0d0Lyt1dGVrdUZCdEY2T0gvWFQrUE80dURTNVZqeWlWKzlmTXlu?=
 =?utf-8?B?WStXTnBHRzY2dlI0QjJwWU5CeHg2WktlUnV5eEdaSng0dkdIVnNNZE1vYXk2?=
 =?utf-8?B?bkFFYTlIckNIUlZKUHFXSEZMbFZEeUl1d2FTaW5MZHpvUkpKNXU4eHpSWTgv?=
 =?utf-8?B?ZWtDSGg3NlNJeWNUZ2twZkdDMGZ0dWd4dGhYS2dQNlRjeGVDQUtmUmY0WUlu?=
 =?utf-8?B?dE1vRkZ1RFF6MUF0Zk5ueUJhbzJEN2FpbTRSZHpSbzFmUG9CM3k5TEVsd1Q5?=
 =?utf-8?B?Zk9xbGJ6U1I5QkRPZVdldHJST1Q4WmFVcFV5TUJxVVd2c2psSUEvcXVlRjM3?=
 =?utf-8?B?TGg0SUJHL0pFb0U1ZmdwRGRsVnFsS2JXcjBtUnVKYVZ4OG10TWhIQzBhVG00?=
 =?utf-8?B?NFZvOEFhRklla25nYUJYT1NoWnFJeDBjSGlGUmNmSEZsQmR0L0hSdkxMWlBq?=
 =?utf-8?B?cXhjZWw5bTltOE5YdS9aOTFEbVlDSzAvNmZiNEROVlYyNlFzNEM2WVRTVjdU?=
 =?utf-8?B?MXNxanQ3Tloyd3ZWbXZObGtEeEJsU0NoMkxIYkFob0NjdXFBWTIzZTlDS2lG?=
 =?utf-8?B?VW1jUFZjSmd5VTN0VXhOMWxoWEQvQlJPWWdYZmlCc3R6Y1dDcCt6NnB1dWY4?=
 =?utf-8?B?L3drU3E0c2hYWk9LaWlxUFpiQUUzSWtXWTM1MVptTDIxMm5Tc3ZqVEV1d1My?=
 =?utf-8?B?bEVZNkUyY1loWVVUVUdMT0ovK3hqbm5SZGVMVEprT1F4VDJRWStlemhkS1RB?=
 =?utf-8?B?NlQ2VllXdXFUNGxVUjJYVjIxUGxFSE5uNjNCNURSVlZXNm42UDZFQWI1U1dB?=
 =?utf-8?B?RU1nQjRhUHBRTDNNL1VWQlU5Ty9sdWVLU2Y3VGxibkFIM2JWOGRPeDU4VDg3?=
 =?utf-8?B?andrdUkyTGI2NnNYVTZYNHNiS0QvMVgwUENzSll4Q0FTNWxFbGN2am9MZUt2?=
 =?utf-8?B?STlYcUNZR3kvVjhFMVhybFF2Vzk3bU1KNElxL1Y5MitMbWdFWS8vN280YnZq?=
 =?utf-8?B?Vy95NU1UVWtGZXN0aStWd1N6TXNML3Jta2kvTWozdUF1NzBpeE9mOHVJRjNr?=
 =?utf-8?Q?lMuZfMLoGuVSNCuybii7+7IwA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b25375f-9736-4fda-1680-08da66051269
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5933.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 01:55:19.8748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnGpK1iVhiJdgZf7G53zTzr3d52RW+T4tl9JTAnh5OcD9uSeQZkpEEgluulzqIA4iohS2+86fXs0DUynJlxguQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3330
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/Add-a-second-bind-table-hashed-by-port-address/20220713-075808
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5022e221c98a609e0e5b0a73852c7e3d32f1c545
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20220714/202207142304.r7aVTnSg-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5e61b9c556267086ef9b743a0b57df302eef831b)
reproduce (this is a W=1 build):
         # https://github.com/intel-lab-lkp/linux/commit/2e20fc25bca52fbc786bbae312df56514c10798d
         git remote add linux-review https://github.com/intel-lab-lkp/linux
         git fetch --no-tags linux-review Joanne-Koong/Add-a-second-bind-table-hashed-by-port-address/20220713-075808
         git checkout 2e20fc25bca52fbc786bbae312df56514c10798d
         # save the config file
         mkdir build_dir && cp config build_dir/.config
         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <yujie.liu@intel.com>

All warnings (new ones prefixed by >>):

 >> net/ipv4/inet_hashtables.c:853:31: warning: variable 'head' set but not used [-Wunused-but-set-variable]
            struct inet_bind_hashbucket *head, *head2;
                                         ^
    1 warning generated.


vim +/head +853 net/ipv4/inet_hashtables.c

2e20fc25bca52f Joanne Koong 2022-07-12  849
2e20fc25bca52f Joanne Koong 2022-07-12  850  int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk)
2e20fc25bca52f Joanne Koong 2022-07-12  851  {
2e20fc25bca52f Joanne Koong 2022-07-12  852  	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
2e20fc25bca52f Joanne Koong 2022-07-12 @853  	struct inet_bind_hashbucket *head, *head2;
2e20fc25bca52f Joanne Koong 2022-07-12  854  	struct inet_bind2_bucket *tb2, *new_tb2;
2e20fc25bca52f Joanne Koong 2022-07-12  855  	int l3mdev = inet_sk_bound_l3mdev(sk);
2e20fc25bca52f Joanne Koong 2022-07-12  856  	int port = inet_sk(sk)->inet_num;
2e20fc25bca52f Joanne Koong 2022-07-12  857  	struct net *net = sock_net(sk);
2e20fc25bca52f Joanne Koong 2022-07-12  858
2e20fc25bca52f Joanne Koong 2022-07-12  859  	/* Allocate a bind2 bucket ahead of time to avoid permanently putting
2e20fc25bca52f Joanne Koong 2022-07-12  860  	 * the bhash2 table in an inconsistent state if a new tb2 bucket
2e20fc25bca52f Joanne Koong 2022-07-12  861  	 * allocation fails.
2e20fc25bca52f Joanne Koong 2022-07-12  862  	 */
2e20fc25bca52f Joanne Koong 2022-07-12  863  	new_tb2 = kmem_cache_alloc(hinfo->bind2_bucket_cachep, GFP_ATOMIC);
2e20fc25bca52f Joanne Koong 2022-07-12  864  	if (!new_tb2)
2e20fc25bca52f Joanne Koong 2022-07-12  865  		return -ENOMEM;
2e20fc25bca52f Joanne Koong 2022-07-12  866
2e20fc25bca52f Joanne Koong 2022-07-12  867  	head = &hinfo->bhash[inet_bhashfn(net, port,
2e20fc25bca52f Joanne Koong 2022-07-12  868  					  hinfo->bhash_size)];
2e20fc25bca52f Joanne Koong 2022-07-12  869  	head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
2e20fc25bca52f Joanne Koong 2022-07-12  870
2e20fc25bca52f Joanne Koong 2022-07-12  871  	spin_lock_bh(&prev_saddr->lock);
2e20fc25bca52f Joanne Koong 2022-07-12  872  	__sk_del_bind2_node(sk);
2e20fc25bca52f Joanne Koong 2022-07-12  873  	inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep,
2e20fc25bca52f Joanne Koong 2022-07-12  874  				  inet_csk(sk)->icsk_bind2_hash);
2e20fc25bca52f Joanne Koong 2022-07-12  875  	spin_unlock_bh(&prev_saddr->lock);
2e20fc25bca52f Joanne Koong 2022-07-12  876
2e20fc25bca52f Joanne Koong 2022-07-12  877  	spin_lock_bh(&head2->lock);
2e20fc25bca52f Joanne Koong 2022-07-12  878  	tb2 = inet_bind2_bucket_find(head2, net, port, l3mdev, sk);
2e20fc25bca52f Joanne Koong 2022-07-12  879  	if (!tb2) {
2e20fc25bca52f Joanne Koong 2022-07-12  880  		tb2 = new_tb2;
2e20fc25bca52f Joanne Koong 2022-07-12  881  		inet_bind2_bucket_init(tb2, net, head2, port, l3mdev, sk);
2e20fc25bca52f Joanne Koong 2022-07-12  882  	}
2e20fc25bca52f Joanne Koong 2022-07-12  883  	sk_add_bind2_node(sk, &tb2->owners);
2e20fc25bca52f Joanne Koong 2022-07-12  884  	inet_csk(sk)->icsk_bind2_hash = tb2;
2e20fc25bca52f Joanne Koong 2022-07-12  885  	spin_unlock_bh(&head2->lock);
2e20fc25bca52f Joanne Koong 2022-07-12  886
2e20fc25bca52f Joanne Koong 2022-07-12  887  	if (tb2 != new_tb2)
2e20fc25bca52f Joanne Koong 2022-07-12  888  		kmem_cache_free(hinfo->bind2_bucket_cachep, new_tb2);
2e20fc25bca52f Joanne Koong 2022-07-12  889
2e20fc25bca52f Joanne Koong 2022-07-12  890  	return 0;
2e20fc25bca52f Joanne Koong 2022-07-12  891  }
2e20fc25bca52f Joanne Koong 2022-07-12  892  EXPORT_SYMBOL_GPL(inet_bhash2_update_saddr);
2e20fc25bca52f Joanne Koong 2022-07-12  893

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
