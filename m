Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD13532534
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbiEXI02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiEXI0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:26:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A049F599
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 01:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653380773; x=1684916773;
  h=message-id:date:subject:references:in-reply-to:to:cc:
   from:content-transfer-encoding:mime-version;
  bh=nj5D2Y7MnemshbrXpmXPSmT1BYn0ti63dLF4MrjWVE4=;
  b=m8Vuq/TfN1f5xwrEgwEi3XFZqIYBzBSwmJsA6MRi44tbP50cn0Q4n1kd
   sn/zboHb6Q/vS5qYN4U1I5IH2beQcvcGIwob49Xyga033YljFPqSKQ0Vx
   0XMps5d7qNypR7TAi/rI+u7zgbZplXMVc/lJmTJ328nM6H/izaB7GTcVl
   tBeYRz/RLHc1SLN7LtAjyPIGBnJsRnzh9+bmaFAv8OuMJiip115EjqXNT
   8jCVd4IA0sU6tkMHgbXwacG4YZkDfJF3VsqL3ZnrmjoU9+wVJ2dOvQqb2
   KpDAapfsPqif0PWrt0K53MEBnfEGarTJEAXb8Zlr2MtUBgyKcheWCrYDv
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="272286641"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="272286641"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 01:26:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="548370017"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 24 May 2022 01:26:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 24 May 2022 01:26:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 24 May 2022 01:26:12 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 24 May 2022 01:26:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMOYuJ7g0mIYJ68ORXtOb2RrkJ8gwC+ikdoKLe65Qg5VttOW5SN514Pws6Mz+QjavgZ12zuu1HVGib2idZk460MrlZFaN4ukPc7IRv1rCln6hO24Q8iij0OyidCb+dSzY1JExqaHYSy7fzH8rz0D7Aarr3Dk/SLzwHEbk5xSpFuL5/+9AeQU9wkRWKsn60mI8/O6LvnjBwG3eWzzYudFcN0b+l56UaCMIGC6GO9kWvj3vAVMBvEjM2Qogs2n3Zn9fehjl3PcsrfDXQfAPLUl0/OY4+IqkXqwG01beaBUO0zzK8Dk7S7hTTmmbE2yPqKJzf5S9qCA5aNY95673EwfDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JvIjiZpC7shAcAA5p8qifpVXl7JoIm2HOX8YCqtXJ70=;
 b=S25uO4CphdI1jpMArazEod+SejGLOGMLiUb9tFuvr+1hEXzNK4MS3xXAIeKo49hRdoMZag3AnYqqAnAOsG///KBMbVsrNyPrdnbqq16CST9evNxMmECLSY5kv67JKiq0RmNENjl2Gt6y6c8+UM093xCkfAEdk4RkgflvnZiO2L3Pa6besxtS76UT/T5PBx74jPEhxuzMMdIEQwH+PW9EkjrTtSRbpebz6hwUJuLN/m5GBmeD2trduetW+3ck2VU/FBrUpV2RMLl2X0SG0PaA741LhIiKSIb5j/9OzxlrgC9r1b+RFlP4EN+uZJ4kdEVO1iH96Ok+hE2REF2kR5T/4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB5933.namprd11.prod.outlook.com (2603:10b6:303:16a::15)
 by CY4PR1101MB2277.namprd11.prod.outlook.com (2603:10b6:910:1a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Tue, 24 May
 2022 08:26:10 +0000
Received: from MW4PR11MB5933.namprd11.prod.outlook.com
 ([fe80::1169:fc9:c1ef:248e]) by MW4PR11MB5933.namprd11.prod.outlook.com
 ([fe80::1169:fc9:c1ef:248e%9]) with mapi id 15.20.5273.022; Tue, 24 May 2022
 08:26:10 +0000
Message-ID: <15f465e2-c456-23e4-2c13-af97a3aefa5c@intel.com>
Date:   Tue, 24 May 2022 16:26:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v5 10/11] igc: Check incompatible configs for
 Frame Preemption
References: <202205221852.CJ4p5boS-lkp@intel.com>
Content-Language: en-US
In-Reply-To: <202205221852.CJ4p5boS-lkp@intel.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
CC:     <llvm@lists.linux.dev>, <kbuild-all@lists.01.org>
From:   kernel test robot <yujie.liu@intel.com>
X-Forwarded-Message-Id: <202205221852.CJ4p5boS-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25)
 To MW4PR11MB5933.namprd11.prod.outlook.com (2603:10b6:303:16a::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d26bfd5d-693b-4cc1-4965-08da3d5f0e50
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2277:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CY4PR1101MB227775D0E197710B294B28B3FBD79@CY4PR1101MB2277.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3VxenKpCSJ84UNa8x8jeaUau/U9V2P/y4FshsHkqV9GzTv+H5u0SIIvyNGaYwtnxX/LShXcFtBY+lKZTYgPhO3Fk/yXP4OG1de7yiFbo9+S4g7jvEJKrotr8NDqpXd58br7d926T6NCuxfPTRMUiEGsHua80DlEMxyyQgsmbJ+iD9kjIaukW1sUtUI6b8EYhq7fxPAAy3Hq0F8fpE+DPajO08ibZMjlisPFm2VzIaJQ41sfGQlQh/f/Pb2nHq1+LyDMkc/Ln1ZosSO/PxhfL7o8UQLGc2e4VUrOXQyinXAFbcfe8nuAqF9vMvreehcaVUxJ4qfHw/gU3/maWdY+X0PfI36TXdRo7cLTSyrECVp9fUViBDnaMoIidZQdDkUdlzzMOP600IZDL9f2yKpFQpzN7MtH2YdK3KxbJzsUmx2GbmhKnz/YmukhJbY4z9J6xmZxmsOrzTVrF7JcsMSAJE76Y8lDW4vy7BLLRCWj+fb/EdFoo7nSRDqnlu5I5b+LAwFhsRxd0Wgx9uKH/44VFtp+6oHbvJYi6pa43oSWEAcN4Xd3XxTwpUEEmgu7TOZm1C2+M/R2RWCBFNuFa16G9VtXxcXBazdqwP8jZL+y3PS54K9OKCaniQXRox8LOSWZX2wfisT4S7mDMlCsoZHK4lw5Xesr3jVTWHV/pNM/qmCM4pjU4r/oNsLPH/shj1zi/bqjs/An7LQnSwWVA5YOJN+mSZwZIkHAvs+PrD8NLI7Xi5J35mjR8kLIrWJi673wBs8YHNE5e7cNIgsI54n77x8X7Nt6+VGtFayCDiTFqH3QJgykd699m/T1SSGQ25M8EaTv0CG+4YVMZl8R7EdO+0ne3T8EEwBevYEBoacMDeKI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5933.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(316002)(4326008)(8936002)(6512007)(83380400001)(26005)(66476007)(66556008)(66946007)(31696002)(186003)(86362001)(31686004)(36756003)(6506007)(966005)(2906002)(6486002)(508600001)(6666004)(82960400001)(110136005)(38100700002)(5660300002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkdtdkFrbVVUU2hpV0FUZnBwUDMvNzhPY0FJL1BqUEp4QnRsckFwa3c3bktt?=
 =?utf-8?B?MzNnR3cvZjJZeWNRMm84Z3FsWjRFZ3BBaTROQ3NiaDRHRzFFc0xPaDI4Rit5?=
 =?utf-8?B?RXNEQXJYZG02Sm13RUVPVUZ4Tm1KUG4zdVYwTUVFNEpzZysyWHVZUHV6WUww?=
 =?utf-8?B?bjBQTTZIckNUbFdIdVdUcTkwSHgwNWdpYlZqWkwrT0htUFJwamlGdERaVits?=
 =?utf-8?B?SEl3cHlUaHlFTVVYNUNid29EYTJjWXVwZ1h5ckxxei83R1BuRThDVm4zRGV4?=
 =?utf-8?B?TVdXU2lhOWJlbWc5UFFMczRySW4xajd4NDlMVDh3MWd0RGZuNWhpMGhHY2J2?=
 =?utf-8?B?eTNYdGZNYVZKS2VLZUt0dkpYRTdKUGUzSm1uUFhpUlYzd0JPWklVekovQS84?=
 =?utf-8?B?VklWQm9GUGhiWkw5dFJWUVBPVkJBbUZ4QlllbHAvZnY0a1Z5cGVra2pVQzda?=
 =?utf-8?B?WkZCZUhOUisvRHBabVpHZ2NQdE5adW9ZZFFzS0QxZE9LRHBuT2FtNFMvSU95?=
 =?utf-8?B?SlE2Ym1rdG44OFhmc3dEcWxTM2hZYktIdXFkeU5SQ3VCUzIxLzNiTTdhYmZN?=
 =?utf-8?B?azNkNThtay9ib0FwVlhnc2ZXcnpwV3p3eUYxMFRQWnJjdkozbFhMN0FEUkNj?=
 =?utf-8?B?SHZ2MWN3RENvcTVQeHFvRnk5ZTVVaEVxMTN4WEF5S1hZb01XVVl4MU52SnBh?=
 =?utf-8?B?U2F4d3F5ZW9ySjgrM25rSGJIOStEYW8rTGFIcG1MdTNhMzlPZWxPMzR4bWlw?=
 =?utf-8?B?bXVHNEhxOFJNU0VjcnErcWNOUEtNUVlFbUtZMjRoRU1uRTNOOFM5TjJ4SVZK?=
 =?utf-8?B?VnNZZUM3Zm1QVGZtMHVtNjJOSEY3VSt3SzlNZWJkS1RFOUwreGViNG15T3Rx?=
 =?utf-8?B?Q29vNHlScmhvM1N4SFFHR1FuK2NsbWg1VmV5K2xoSkRQK3cvUVhkdWN2VXFU?=
 =?utf-8?B?MlBabmNBbElxYWE2MkorYnBONVJCd2JxeGJhVEMwKzdsZFBEdjVrdVMva0Vy?=
 =?utf-8?B?MXVIK04vSGUxTEFwSzVKZHlzbEU2UFJ4NGw2Z3dORUtVaXA5ZHhDNU5EOUF6?=
 =?utf-8?B?dUFERnplSk5zYkNTd01lbXlGbFNtZ3ZDRCtRbm9WNWhtd2d6SlN3ZmlpNVRw?=
 =?utf-8?B?TnBIYkFNc0ZlZHpWMlM4SkFuM1NRREhaYXMxbGlGaSt1Nm81RnFXcXdxSzRr?=
 =?utf-8?B?ZGtUako2bmRzbUpDVW1FVnZBVzhscExBL0orLy8vMWVvVmovMWFWWVhxN28z?=
 =?utf-8?B?amxJSkRMY1IyQ2FBTnlQcUNGMVRBUzZMV0lFc0xFU3RRVnBHUDhlVlg3UzRE?=
 =?utf-8?B?OFdSQmJuY24xTG9GcDZ2d3lpbmczK1JpRk9FV3ZyQStIMDBONVNZWUlXQVVJ?=
 =?utf-8?B?eklIZzZBck5qSzcvTHZVNGFuMkhGTGZ6Rm14ZWtuV1VpUWtwNUhiT09sSjZT?=
 =?utf-8?B?YkdWMUdpay9UaExlT0pjcDJ1SWRBU0ZqQlZhNGtabWErTU83K05RaC8yeGlC?=
 =?utf-8?B?SVVtQ2RQQ1laMk5DalEyZG9Sb1l0cmNRZ0szMEg5U216YUVnVC9xNGEvSi94?=
 =?utf-8?B?WTFuRlNMOGlPN3V4QlVEZkxJN3kxbXdpa0VkQXdHc2szNjM4bmtBOEJRYVI5?=
 =?utf-8?B?MDNoRkdrdE16NStJbFpiUGRaT0ZCT2wxYUxEdG5COXZieDF6MjlJczBrampU?=
 =?utf-8?B?QzhZaDJNQlJIeGh0TCtFQ216TnF1YzVRWHMvbndqYkN1TjNKZ2hyZ0NlZkdv?=
 =?utf-8?B?UjJkN2FLT2lwRGNOVmkzdlRUMFdRbUdlTVFCNitzZjJ1Z3Zza3EzcU5JbWJt?=
 =?utf-8?B?eFN2bkFzNlh3OE8rWTlkbll5TE5mdklXUVNFTTFtNUwyakRqZXZYaFppWWF3?=
 =?utf-8?B?UkV3SkZZQm5rNDdFUERyTnNhSzN4WTBkSkRUTHJ5RDk5Q2x2REk3RUpYM1NM?=
 =?utf-8?B?NnA4dlloSW9pdWVzVXVOK0pJVmFlOHdvektwb01xT3QzYnZmT2Q0ZUljRDVk?=
 =?utf-8?B?MkFFZXMwZk5nZTgxME5aeUR3V1o2aVo5L3NkSFB0aGlCdGxscnZ6MkpFRWJk?=
 =?utf-8?B?TUdkZVFFRzNXd2pZUjVjY0dMNHByK1VKc3lDcWI3ZTF0NVlQNDQ2UUR1cGVn?=
 =?utf-8?B?UlhDQlpyZ2RYcCs4TVlCb1doQXUvQnFFS3Zmc1BPdllueDcwWEpKYmd5Z3RZ?=
 =?utf-8?B?Y1NRbHFoREIrQzZLTzVvelNJQkFadXRuYjdrcUdYWmpSMy90d1YrMEVLWExM?=
 =?utf-8?B?ZkJ5eTdiOXd5RVJOcStqTkVSd1RtU2ZObjFJZXVmMTBtSGtMenQ4RTQxNEN4?=
 =?utf-8?B?WmJ1MXpjWURtRmFTMzd6SjlTcWs5N0pQT0h5OW5BdkNYYWc2RDJZQjUrNTVT?=
 =?utf-8?Q?jPltX5/ojim3CLsc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d26bfd5d-693b-4cc1-4965-08da3d5f0e50
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5933.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 08:26:10.0176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KKNm5W9nkvY08fSJ8mFNvRb9v/pOWH8KDa2i44bMQeGTD8T47EHwhCglhfH1DRaGTY6Rg684+wygqkzFDNtRJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2277
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

Thanks for your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vinicius-Costa-Gomes/ethtool-Add-support-for-frame-preemption/20220520-092800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git df98714e432abf5cbdac3e4c1a13f94c65ddb8d3
config: arm-randconfig-c002-20220522 (https://download.01.org/0day-ci/archive/20220522/202205221852.CJ4p5boS-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 1443dbaba6f0e57be066995db9164f89fb57b413)
reproduce (this is a W=1 build):
         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
         chmod +x ~/bin/make.cross
         # install arm cross compiling tool for clang build
         # apt-get install binutils-arm-linux-gnueabi
         # https://github.com/intel-lab-lkp/linux/commit/a42e940bc53c40ee4e33a1bbf022a663bb28a9c7
         git remote add linux-review https://github.com/intel-lab-lkp/linux
         git fetch --no-tags linux-review Vinicius-Costa-Gomes/ethtool-Add-support-for-frame-preemption/20220520-092800
         git checkout a42e940bc53c40ee4e33a1bbf022a663bb28a9c7
         # save the config file
         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm clang-analyzer

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <yujie.liu@intel.com>


clang-analyzer warnings: (new ones prefixed by >>)

 >> drivers/net/ethernet/intel/igc/igc_main.c:5919:6: warning: Access to field 'preemptible' results in a dereference of an undefined pointer value (loaded from variable 'ring') [clang-analyzer-core.NullDereference]
            if (ring->preemptible) {
                ^

vim +5919 drivers/net/ethernet/intel/igc/igc_main.c

5f2958052c5820 Vinicius Costa Gomes 2019-12-02  5910
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5911  static int igc_save_launchtime_params(struct igc_adapter *adapter, int queue,
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5912  				      bool enable)
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5913  {
82faa9b799500f Vinicius Costa Gomes 2020-02-14 @5914  	struct igc_ring *ring;
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5915
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5916  	if (queue < 0 || queue >= adapter->num_tx_queues)
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5917  		return -EINVAL;
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5918
a42e940bc53c40 Vinicius Costa Gomes 2022-05-19 @5919  	if (ring->preemptible) {
a42e940bc53c40 Vinicius Costa Gomes 2022-05-19  5920  		netdev_err(adapter->netdev, "Cannot enable LaunchTime on a preemptible queue\n");
a42e940bc53c40 Vinicius Costa Gomes 2022-05-19  5921  		return -EINVAL;
a42e940bc53c40 Vinicius Costa Gomes 2022-05-19  5922  	}
a42e940bc53c40 Vinicius Costa Gomes 2022-05-19  5923
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5924  	ring = adapter->tx_ring[queue];
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5925  	ring->launchtime_enable = enable;
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5926
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5927  	return 0;
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5928  }
82faa9b799500f Vinicius Costa Gomes 2020-02-14  5929

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
