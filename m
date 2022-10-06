Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358225F67CB
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJFNYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiJFNYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:24:18 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB7AA99C3;
        Thu,  6 Oct 2022 06:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665062648; x=1696598648;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=cIATCVsSRW9lYCX1WZE4re8D9lFhrVMrt/3D1AVrKfo=;
  b=hhW9P5ZviPPR3pqwOgNYPxwgmdH2HfYVxEO+4eunl81kMhZ4HLc/giSp
   PzxXs0uPlMUdmfrGaT7eeuvhk+JQtcjhp78YeErEZNSJ/X+N5fWknVKHO
   fxES+ZcCzOSRMHiTg5S0NgV+2toJQr3btuiPLEft4YnmzwHZ5CELjJZYU
   GNLtuIo1eWPgfemKW4XJEOOKLpBPcmc19Df39ieDOSdLAzYkbROu7dqvN
   Vk+GBJb5x6QVkcnh4gaSxwaUTo4nI7MlGF3c/e97qpy/ClOgUtQII0Q7R
   ghZdiOwQb2uyGGiuU7w56vUmdT/bayOhQNFgZhil+VK7mlctL46+rJDUq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="283809891"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="xz'?yaml'?scan'208";a="283809891"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 06:24:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="693349673"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="xz'?yaml'?scan'208";a="693349673"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 06 Oct 2022 06:24:06 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 6 Oct 2022 06:24:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 6 Oct 2022 06:24:05 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 6 Oct 2022 06:24:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQt1c1YFYbnbjcCKDVZ77UN4kj/DPqr2sz+pJpC1EKIZgr8t2M8QNP10r/XFis7pTHPZfpgvc6lsozcmBSUtFGwHzuMPxWiwdx3eNwc1yRCJMKdRzxDAskZ8hkOrrySBAsHu+j2JD2SHYsK9BK8c8OLo2upnn3NneFnjTI17kp2kUf2zvJvGCi589MoPLnkZXPrdrBOTkdxI1j0XkhobWX56W/zW0n3uWKVPwz7N9J2n3tIbiL9Ht+m+QxzykMFXtFaEmyFya/sTYCfSkhiefEMLnO11et6VqCDYRSAqnyiIZATVlZD+lIPQbhFBGa9npuGaP2pCsCBf/jGh9jm05A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a1wCaj61fRSu73jCFRDDry/eUA26zZg9FzQLYlTQg58=;
 b=TJ7HRujWL3ze+VrVuQ1jRNfVkuvZ/dpnde7mUiaCThOOir5nqa4Br2duK8gkmz4vn7/RxFAtzroIa8qDLP6sEDLTft1IePKFY2ednwzEO0EuScEvOFTlHTSxk7eqwMxGCvPKcsQzGJi4LegAp8EVELUwwM+SZmTw2nbL1quSDXlWxG60mbqEyxCZdXVDwRgSCii1nvTfTxP6YNeIdBc3eTlJ31DHj0INglOHABA/JM5CWFbA6S26TEguZcaC8pkNagSnV7Le88v+4GQY5RdMuW2FxcMw+f4SK0YFGHhOK5C/YSV6oURDGtbC9peakp1JXYOlU0mW7BtrXNvftoDJbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by CO1PR11MB4916.namprd11.prod.outlook.com (2603:10b6:303:9c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Thu, 6 Oct
 2022 13:24:00 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e1c4:1741:2788:37d0]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e1c4:1741:2788:37d0%3]) with mapi id 15.20.5676.030; Thu, 6 Oct 2022
 13:24:00 +0000
Date:   Thu, 6 Oct 2022 21:23:50 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Richard Gobert <richardbgobert@gmail.com>
CC:     <lkp@lists.01.org>, <lkp@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [net]  0e4d354762: kernel-selftests.net.fcnal-test.sh.fail
Message-ID: <202210062117.c7eef1a3-oliver.sang@intel.com>
Content-Type: multipart/mixed; boundary="FxTqW4ihe4HI1nwj"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SG2PR06CA0247.apcprd06.prod.outlook.com
 (2603:1096:4:ac::31) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|CO1PR11MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: 060d91da-9e0c-47a0-44a3-08daa79e071e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: io9XsPvjw7fN9e3BdE0bWaeH2opRjO5ROE4OuYfOi9sfNOqT7HnsPXgSIQzx2cSbmx7KVE9hDQH/SY7ksIVaGY6flBcnTJAdjWgeY6D/XXlKJKuH8Ah6NLkiv6JzyI3tzQwdcY5jJuGHC+oaMAT2vG1t5yHev+0I35yKsFYHaI+RjgzNzDCKWTHkvGE0zIBOiQwWJD8J1BsKj1ja8YSMwFgXjHRCW/3FAMaLjndY2kMh7aK54CRr8ewHJo+Ef5rBJiaLQG8f0P9plU+9UrL6LmloedmJ/i4Kl4SWJnEd7QqAE7SC09N/1u1UHVNeeJ2xUUjUBi+9Ta3kjzx3fdj6gv/OTK4N39cN26Yzw9kmngWna3tzlr3mosfjDXluF1ImZTGEMOcF2ssWP/IfaXms0s2CM+NcAq1v3AgCQQLQeLknIAEUa5zvg+oZC67Bc1Sqh9sH1fuWZqoxvERYHVn/iDzUh3fBST3Un5Fy6eXc1WxX4R7AOOqoNsI6bgP+jzre3voVTMeszcYZgZQUz9RzkKN4Y5rGhRnjVCCBjxXxRH3Q8iNCuJatDCeNaHp/pNpzRug39oKspu8ZIiBWulGDa9EnDM+ksVqZycH5fH1KxU4WOzylBVU4ZNZinbprqdArWo6UcMGubJRHzOshKosCHRaUEsCTdGXaUZWbrrZN30Y2ScM+m7FwdsLArlJafm+k8PQqsn8mdApd9/2nKkN5UwFfcQyyA/90G+3+n6dGoxlzb2xM/RvFhezahEd1NY35HvmuEy6TocSOLOorCGKJYpLdJ58tm/i0RKvFU5bDkoG+w5rdWafVIpv+K1PwTMgT7kNSlNhXDBUkM1pS/qFHHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199015)(44144004)(21490400003)(86362001)(478600001)(30864003)(54906003)(2906002)(36756003)(2616005)(6916009)(316002)(1076003)(186003)(38100700002)(82960400001)(6512007)(33964004)(26005)(4326008)(66946007)(8676002)(66476007)(66556008)(8936002)(235185007)(6486002)(5660300002)(966005)(41300700001)(6666004)(6506007)(83380400001)(2700100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gucN2L86ImhsvPWA1bBcgqn3wKSOAb60nE324BxoVkwj2xt1Ss1iSmcsLDSe?=
 =?us-ascii?Q?cbDjUs1T0viA4Kz4svRk2XZnAWUqgtkY+lmzdbhtIJIorlaU7OcYh34Brghj?=
 =?us-ascii?Q?sKDRVb9veTSnZiqio23f1NNc2QLyXfWMIGAWfFObK6T5wVErlX5p+GQxTe6X?=
 =?us-ascii?Q?lAZOhkAmFxju36ALTQERqJpemjr4BOsO06SnspbwDbj3TyPvYU0FA5osL0Rd?=
 =?us-ascii?Q?1/zUGhG4wK7UrrGvQVvB3nKiAws8qwt/YXFCQuphStbaRanGTS2hKYJlRoY9?=
 =?us-ascii?Q?zooPePq4yXDT7DxlyjQHChe/akGTg7MVY76vYsFRuOAsidA8xux/DYjMNbP4?=
 =?us-ascii?Q?/mVYIuNORoo564tgBMoW1w7HLauTyC5Erfjq/O1+PSEVu/BzCSO1W3KZe//g?=
 =?us-ascii?Q?2xBUzyagliQOWzH0KXEgc5GePzFhJFqXkhgVKXQ/wQ42c0kmdf2YFJbTne6f?=
 =?us-ascii?Q?TK4lnS2hf7VfUDDaCrHtNgpGRt1QJgEw0IPtyVHik0QHxPAE1qhxF+B1vSph?=
 =?us-ascii?Q?0PMH3QLLTniOrrgsnVyvmB6XpLM/AogaxbI9ZPOdo6Nls30DmRztWHfX9MII?=
 =?us-ascii?Q?4dF4YzmIMVd1sFY6fXTV6LTpxU4ZH/2FTefwHf9FOgo+Z7Z4vvrtkDW/N+sU?=
 =?us-ascii?Q?6FDT09yqWhrrehm0B6Rdl0lVEEQrSMHC4obXLA6BJXi+N56zpvv8V/cPZfDM?=
 =?us-ascii?Q?3vyjU695Mo7YhAQu/zytK/kFDLPSepfATKR2zQJrdxEO6fRGyQ/xUot4a+j5?=
 =?us-ascii?Q?uT4yI+nQ5iR6LM/nzYgnwBIuQ7KR6Nq0ZHNOrYPFxoWkPAsbXaMwb8JQbORW?=
 =?us-ascii?Q?HTJHwuHI0z1ak2YHF1JAr9o9pRWFAr6tf8i5HNfTLL5jMjjBstEA9aNadMXB?=
 =?us-ascii?Q?sBppPz3ZhvYZsGAoSE6lbpQ4CpP86XTbcra+phTG88FNdcM3ZEV1rwNsRaCf?=
 =?us-ascii?Q?rbxrHMOz+cMgj9QV4lVvkokjoGDHP99hCVM6VLXtQs/LSYIfPd6q91t1Z3Kn?=
 =?us-ascii?Q?jJYB+vVXnrhhDI/hoWmuQ1k4lpPvLEBUbXMSmHkgYfMztEnfePMexKKsQdHk?=
 =?us-ascii?Q?9XJ69pFSplFklvrAoux9Zc5tzU8LbyWzPpTeAeDPKb0fvx30J0AJOB3dtmvk?=
 =?us-ascii?Q?wCwj53+btSXso9l7igVOMrf2nSLUES9CJ0l3e8tmAy5gIOsWrlExAmNxoyC5?=
 =?us-ascii?Q?i6MFGaopLP7v4p3HVUHT5rkLg8oR3rKei4V8bx8ir9zwqspUXhX278oYGXtw?=
 =?us-ascii?Q?oyztQWTY9YnzeoAxw67owTfFa1BloK4MBKeSeDMqO4LieiqIZwXnkiQgZt6R?=
 =?us-ascii?Q?t1Yp/f1r/YmkPuCkSB6KfysOgaH4Kp8h/OUEhAybMhaGyQ9ExD7T/hqHxh5s?=
 =?us-ascii?Q?rtCCUiD82IuyXGVVdSYKAfn+kd5erg3xhSX+87smi8kie2/0kajtYxWDvH1v?=
 =?us-ascii?Q?Ma4bOZGiGD/itXj4Xoz/3VjsZEfEy4KMl3j4gkLrIQhS7tB8/zwZZCfcBYPy?=
 =?us-ascii?Q?7uM7NGUniMKSDV5i1jreLw3jiJQZC6oNZZpdOK8fv2WPBHqVL9OdQ/+VXLH2?=
 =?us-ascii?Q?AAlK303nCpJvJ0OyzaHgMSFH3uRBbQkRwFguDLRQ1FBBg/CIxfMvzaCHOwO+?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 060d91da-9e0c-47a0-44a3-08daa79e071e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 13:24:00.1659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LHIAlSjqeti1LFNMJ+nJh6OMDwsr6AjDjQfPffj3JgfmmIv8hF7CHBlVZaQRR/IS+FqqkIWjAIM57XluyUZ5Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4916
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--FxTqW4ihe4HI1nwj
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline


Greeting,

FYI, we noticed the following commit (built with gcc-11):

commit: 0e4d354762cefd3e16b4cff8988ff276e45effc4 ("net-next: Fix IP_UNICAST_IF option behavior for connected sockets")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

in testcase: kernel-selftests
version: kernel-selftests-x86_64-700a8991-1_20220823
with following parameters:

	group: net
	test: fcnal-test.sh
	atomic_test: ipv6_udp

test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
test-url: https://www.kernel.org/doc/Documentation/kselftest.txt


on test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 28G memory

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):




If you fix the issue, kindly add following tag
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Link: https://lore.kernel.org/r/202210062117.c7eef1a3-oliver.sang@intel.com



# selftests: net: fcnal-test.sh
# SYSCTL: net.ipv4.udp_early_demux=1
# 
# 
# ###########################################################################
# IPv6/UDP
# ###########################################################################
# 
# 
# #################################################################
# No VRF
# 
# 
# #################################################################
# udp_l3mdev_accept disabled
# 
# SYSCTL: net.ipv4.udp_l3mdev_accept=0
# 
# TEST: Global server - ns-A IPv6                                               [ OK ]
# TEST: Device server - ns-A IPv6                                               [ OK ]
# TEST: Global server - ns-A IPv6 LLA                                           [ OK ]
# TEST: Device server - ns-A IPv6 LLA                                           [ OK ]
# TEST: Global server - ns-A loopback IPv6                                      [ OK ]
# TEST: No server - ns-A IPv6                                                   [ OK ]
# TEST: No server - ns-A loopback IPv6                                          [ OK ]
# TEST: No server - ns-A IPv6 LLA                                               [ OK ]
# TEST: Client - ns-B IPv6                                                      [ OK ]
# TEST: Client, device bind - ns-B IPv6                                         [ OK ]
# TEST: Client, device send via cmsg - ns-B IPv6                                [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6                     [ OK ]
# TEST: No server, unbound client - ns-B IPv6                                   [ OK ]
# TEST: No server, device client - ns-B IPv6                                    [ OK ]
# TEST: Client - ns-B loopback IPv6                                             [ OK ]
# TEST: Client, device bind - ns-B loopback IPv6                                [ OK ]
# TEST: Client, device send via cmsg - ns-B loopback IPv6                       [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B loopback IPv6            [ OK ]
# TEST: No server, unbound client - ns-B loopback IPv6                          [ OK ]
# TEST: No server, device client - ns-B loopback IPv6                           [ OK ]
# TEST: Client - ns-B IPv6 LLA                                                  [ OK ]
# TEST: Client, device bind - ns-B IPv6 LLA                                     [ OK ]
# TEST: Client, device send via cmsg - ns-B IPv6 LLA                            [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6 LLA                 [ OK ]
# TEST: No server, unbound client - ns-B IPv6 LLA                               [ OK ]
# TEST: No server, device client - ns-B IPv6 LLA                                [ OK ]
# TEST: Global server, local connection - ns-A IPv6                             [ OK ]
# TEST: Global server, local connection - ns-A loopback IPv6                    [ OK ]
# TEST: Global server, local connection - IPv6 loopback                         [ OK ]
# TEST: Device server, unbound client, local connection - ns-A IPv6             [ OK ]
# TEST: Device server, local connection - ns-A loopback IPv6                    [ OK ]
# TEST: Device server, local connection - IPv6 loopback                         [ OK ]
# TEST: Global server, device client, local connection - ns-A IPv6              [ OK ]
# TEST: Global server, device send via cmsg, local connection - ns-A IPv6       [ OK ]
# TEST: Global server, device client via IPV6_UNICAST_IF, local connection - ns-A IPv6  [ OK ]
# TEST: Global server, device client, local connection - ns-A loopback IPv6     [ OK ]
# TEST: Global server, device send via cmsg, local connection - ns-A loopback IPv6  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection - ns-A loopback IPv6  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection, with connect() - ns-A loopback IPv6  [FAIL]
# TEST: Global server, device client, local connection - IPv6 loopback          [ OK ]
# TEST: Global server, device send via cmsg, local connection - IPv6 loopback   [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection - IPv6 loopback  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection, with connect() - IPv6 loopback  [ OK ]
# TEST: Device server, device client, local conn - ns-A IPv6                    [ OK ]
# TEST: No server, device client, local conn - ns-A IPv6                        [ OK ]
# TEST: UDP in - LLA to GUA                                                     [ OK ]
# 
# #################################################################
# udp_l3mdev_accept enabled
# 
# SYSCTL: net.ipv4.udp_l3mdev_accept=1
# 
# TEST: Global server - ns-A IPv6                                               [ OK ]
# TEST: Device server - ns-A IPv6                                               [ OK ]
# TEST: Global server - ns-A IPv6 LLA                                           [ OK ]
# TEST: Device server - ns-A IPv6 LLA                                           [ OK ]
# TEST: Global server - ns-A loopback IPv6                                      [ OK ]
# TEST: No server - ns-A IPv6                                                   [ OK ]
# TEST: No server - ns-A loopback IPv6                                          [ OK ]
# TEST: No server - ns-A IPv6 LLA                                               [ OK ]
# TEST: Client - ns-B IPv6                                                      [ OK ]
# TEST: Client, device bind - ns-B IPv6                                         [ OK ]
# TEST: Client, device send via cmsg - ns-B IPv6                                [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6                     [ OK ]
# TEST: No server, unbound client - ns-B IPv6                                   [ OK ]
# TEST: No server, device client - ns-B IPv6                                    [ OK ]
# TEST: Client - ns-B loopback IPv6                                             [ OK ]
# TEST: Client, device bind - ns-B loopback IPv6                                [ OK ]
# TEST: Client, device send via cmsg - ns-B loopback IPv6                       [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B loopback IPv6            [ OK ]
# TEST: No server, unbound client - ns-B loopback IPv6                          [ OK ]
# TEST: No server, device client - ns-B loopback IPv6                           [ OK ]
# TEST: Client - ns-B IPv6 LLA                                                  [ OK ]
# TEST: Client, device bind - ns-B IPv6 LLA                                     [ OK ]
# TEST: Client, device send via cmsg - ns-B IPv6 LLA                            [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6 LLA                 [ OK ]
# TEST: No server, unbound client - ns-B IPv6 LLA                               [ OK ]
# TEST: No server, device client - ns-B IPv6 LLA                                [ OK ]
# TEST: Global server, local connection - ns-A IPv6                             [ OK ]
# TEST: Global server, local connection - ns-A loopback IPv6                    [ OK ]
# TEST: Global server, local connection - IPv6 loopback                         [ OK ]
# TEST: Device server, unbound client, local connection - ns-A IPv6             [ OK ]
# TEST: Device server, local connection - ns-A loopback IPv6                    [ OK ]
# TEST: Device server, local connection - IPv6 loopback                         [ OK ]
# TEST: Global server, device client, local connection - ns-A IPv6              [ OK ]
# TEST: Global server, device send via cmsg, local connection - ns-A IPv6       [ OK ]
# TEST: Global server, device client via IPV6_UNICAST_IF, local connection - ns-A IPv6  [ OK ]
# TEST: Global server, device client, local connection - ns-A loopback IPv6     [ OK ]
# TEST: Global server, device send via cmsg, local connection - ns-A loopback IPv6  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection - ns-A loopback IPv6  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection, with connect() - ns-A loopback IPv6  [FAIL]
# TEST: Global server, device client, local connection - IPv6 loopback          [ OK ]
# TEST: Global server, device send via cmsg, local connection - IPv6 loopback   [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection - IPv6 loopback  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection, with connect() - IPv6 loopback  [ OK ]
# TEST: Device server, device client, local conn - ns-A IPv6                    [ OK ]
# TEST: No server, device client, local conn - ns-A IPv6                        [ OK ]
# TEST: UDP in - LLA to GUA                                                     [ OK ]
# 
# #################################################################
# With VRF
# 
# 
# #################################################################
# Global server disabled
# 
# SYSCTL: net.ipv4.udp_l3mdev_accept=0
# 
# TEST: Global server - ns-A IPv6                                               [ OK ]
# TEST: Global server - VRF IPv6                                                [ OK ]
# TEST: VRF server - ns-A IPv6                                                  [ OK ]
# TEST: VRF server - VRF IPv6                                                   [ OK ]
# TEST: Enslaved device server - ns-A IPv6                                      [ OK ]
# TEST: Enslaved device server - VRF IPv6                                       [ OK ]
# TEST: No server - ns-A IPv6                                                   [ OK ]
# TEST: No server - VRF IPv6                                                    [ OK ]
# TEST: Global server, VRF client, local conn - ns-A IPv6                       [ OK ]
# TEST: Global server, VRF client, local conn - VRF IPv6                        [ OK ]
# TEST: VRF server, VRF client, local conn - ns-A IPv6                          [ OK ]
# TEST: VRF server, VRF client, local conn - VRF IPv6                           [ OK ]
# TEST: Global server, device client, local conn - ns-A IPv6                    [ OK ]
# TEST: VRF server, device client, local conn - ns-A IPv6                       [ OK ]
# TEST: Enslaved device server, VRF client, local conn - ns-A IPv6              [ OK ]
# TEST: Enslaved device server, device client, local conn - ns-A IPv6           [ OK ]
# 
# #################################################################
# Global server enabled
# 
# SYSCTL: net.ipv4.udp_l3mdev_accept=1
# 
# TEST: Global server - ns-A IPv6                                               [ OK ]
# TEST: Global server - VRF IPv6                                                [ OK ]
# TEST: VRF server - ns-A IPv6                                                  [ OK ]
# TEST: VRF server - VRF IPv6                                                   [ OK ]
# TEST: Enslaved device server - ns-A IPv6                                      [ OK ]
# TEST: Enslaved device server - VRF IPv6                                       [ OK ]
# TEST: No server - ns-A IPv6                                                   [ OK ]
# TEST: No server - VRF IPv6                                                    [ OK ]
# TEST: VRF client                                                              [ OK ]
# TEST: No server, VRF client                                                   [ OK ]
# TEST: Enslaved device client                                                  [ OK ]
# TEST: No server, enslaved device client                                       [ OK ]
# TEST: Global server, VRF client, local conn - ns-A IPv6                       [ OK ]
# TEST: VRF server, VRF client, local conn - ns-A IPv6                          [ OK ]
# TEST: Global server, VRF client, local conn - VRF IPv6                        [ OK ]
# TEST: VRF server, VRF client, local conn - VRF IPv6                           [ OK ]
# TEST: No server, VRF client, local conn - ns-A IPv6                           [ OK ]
# TEST: No server, VRF client, local conn - VRF IPv6                            [ OK ]
# TEST: Global server, device client, local conn - ns-A IPv6                    [ OK ]
# TEST: VRF server, device client, local conn - ns-A IPv6                       [ OK ]
# TEST: Device server, VRF client, local conn - ns-A IPv6                       [ OK ]
# TEST: Device server, device client, local conn - ns-A IPv6                    [ OK ]
# TEST: No server, device client, local conn - ns-A IPv6                        [ OK ]
# TEST: Global server, linklocal IP                                             [ OK ]
# TEST: No server, linklocal IP                                                 [ OK ]
# TEST: Enslaved device client, linklocal IP                                    [ OK ]
# TEST: No server, device client, peer linklocal IP                             [ OK ]
# TEST: Enslaved device client, local conn - linklocal IP                       [ OK ]
# TEST: No server, device client, local conn  - linklocal IP                    [ OK ]
# TEST: UDP in - LLA to GUA                                                     [ OK ]
# 
# Tests passed: 136
# Tests failed:   2
not ok 2 selftests: net: fcnal-test.sh # exit=1
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net'



To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        sudo bin/lkp install job.yaml           # job file is attached in this email
        bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
        sudo bin/lkp run generated-yaml-file

        # if come across any failure that blocks the test,
        # please remove ~/.lkp and /lkp dir to run from a clean state.



-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



--FxTqW4ihe4HI1nwj
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-6.0.0-rc2-00573-g0e4d354762ce"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 6.0.0-rc2 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-5) 11.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=110300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23890
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23890
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=123
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_WATCH_QUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_IDLE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING_USER=y
# CONFIG_CONTEXT_TRACKING_USER_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=100
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
# CONFIG_BPF_PRELOAD is not set
# CONFIG_BPF_LSM is not set
# end of BPF subsystem

CONFIG_PREEMPT_VOLUNTARY_BUILD=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_PREEMPT_DYNAMIC is not set
# CONFIG_SCHED_CORE is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_DEFAULT_ALL is not set
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
# CONFIG_PRINTK_INDEX is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_GCC12_NO_ARRAY_BOUNDS=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
# CONFIG_CGROUP_FAVOR_DYNMODS is not set
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_INITRAMFS_PRESERVE_MTIME=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_GUEST_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_NR_GPIO=1024
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
CONFIG_INTEL_TDX_GUEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_HYGON is not set
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_ZHAOXIN is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_BOOT_VESA_SUPPORT=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_CLUSTER=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_LATE_LOADING=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_X86_MEM_ENCRYPT=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
# CONFIG_X86_KERNEL_IBT is not set
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_X86_SGX=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_XONLY=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_CC_HAS_SLS=y
CONFIG_CC_HAS_RETURN_THUNK=y
CONFIG_SPECULATION_MITIGATIONS=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_RETPOLINE=y
CONFIG_RETHUNK=y
CONFIG_CPU_IBRS_ENTRY=y
# CONFIG_SLS is not set
CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_USERSPACE_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=m
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_DPTF is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_ACPI_PFRUT is not set
CONFIG_ACPI_PCC=y
CONFIG_PMIC_OPREGION=y
CONFIG_ACPI_PRMT=y
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_AMD_PSTATE is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32_ABI is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
# end of Binary Emulations

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_PFNCACHE=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_DIRTY_RING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_HAVE_KVM_PM_NOTIFIER=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_WERROR is not set
CONFIG_KVM_INTEL=m
# CONFIG_X86_SGX_KVM is not set
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_XEN is not set
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HAVE_IMA_KEXEC=y
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_KRETPROBE_ON_RETHOOK=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_MMU_GATHER_MERGE_VMAS=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING_USER=y
CONFIG_HAVE_CONTEXT_TRACKING_USER_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_HAVE_OBJTOOL=y
CONFIG_HAVE_JUMP_LABEL_HACK=y
CONFIG_HAVE_NOINSTR_HACK=y
CONFIG_HAVE_NOINSTR_VALIDATION=y
CONFIG_HAVE_UACCESS_VALIDATION=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_ARCH_HAS_CC_PLATFORM=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SUPPORTS_PAGE_TABLE_CHECK=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y
CONFIG_HAVE_ARCH_NODE_DEV_GROUP=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLOCK_LEGACY_AUTOLOAD=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_ICQ=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
# CONFIG_BLK_CGROUP_IOPRIO is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y
CONFIG_BLOCK_HOLDER_DEPRECATED=y
CONFIG_BLK_MQ_STACKING=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_ZPOOL=y
CONFIG_SWAP=y
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_DEFAULT_ON is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y

#
# SLAB allocator options
#
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLAB_FREELIST_HARDENED=y
# CONFIG_SLUB_STATS is not set
CONFIG_SLUB_CPU_PARTIAL=y
# end of SLAB allocator options

CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTPLUG=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_DEVICE_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_THP_SWAP=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ARCH_HAS_ZONE_DMA_SET=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DEVICE=y
CONFIG_HMM_MIRROR=y
CONFIG_GET_FREE_REGION=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PERCPU_STATS is not set
CONFIG_GUP_TEST=y
CONFIG_ARCH_HAS_PTE_SPECIAL=y
# CONFIG_ANON_VMA_NAME is not set
CONFIG_USERFAULTFD=y
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
CONFIG_PTE_MARKER=y
CONFIG_PTE_MARKER_UFFD_WP=y

#
# Data Access Monitoring
#
CONFIG_DAMON=y
CONFIG_DAMON_VADDR=y
CONFIG_DAMON_PADDR=y
# CONFIG_DAMON_SYSFS is not set
CONFIG_DAMON_DBGFS=y
# CONFIG_DAMON_RECLAIM is not set
# CONFIG_DAMON_LRU_SORT is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_NET_REDIRECT=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_AF_UNIX_OOB=y
CONFIG_UNIX_DIAG=m
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_XDP_SOCKETS=y
# CONFIG_XDP_SOCKETS_DIAG is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_INET_RAW_DIAG=m
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_NV=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
# CONFIG_INET6_ESPINTCP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=y
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_FOU=y
CONFIG_IPV6_FOU_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
CONFIG_IPV6_IOAM6_LWTUNNEL=y
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=m
CONFIG_MPTCP_IPV6=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_EGRESS=y
CONFIG_NETFILTER_SKIP_EGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
# CONFIG_NETFILTER_NETLINK_HOOK is not set
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_FLOW_OFFLOAD=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
# CONFIG_NFT_XFRM is not set
CONFIG_NFT_SOCKET=m
# CONFIG_NFT_OSF is not set
CONFIG_NFT_TPROXY=m
CONFIG_NFT_SYNPROXY=m
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
# CONFIG_NFT_REJECT_NETDEV is not set
CONFIG_NF_FLOW_TABLE_INET=m
CONFIG_NF_FLOW_TABLE=m
# CONFIG_NF_FLOW_TABLE_PROCFS is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XTABLES_COMPAT=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
# CONFIG_IP_VS_TWOS is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
CONFIG_NFT_BRIDGE_REJECT=m
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
CONFIG_NET_SCH_ETF=m
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
CONFIG_NET_SCH_FQ_PIE=m
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=m
CONFIG_NET_SCH_ETS=m
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
# CONFIG_DEFAULT_CODEL is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_FQ_PIE is not set
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_EMATCH_CANID=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_EMATCH_IPT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_ACT_MPLS=m
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
CONFIG_NET_ACT_CONNMARK=m
CONFIG_NET_ACT_CTINFO=m
CONFIG_NET_ACT_SKBMOD=m
CONFIG_NET_ACT_IFE=m
CONFIG_NET_ACT_TUNNEL_KEY=m
CONFIG_NET_ACT_CT=m
# CONFIG_NET_ACT_GATE is not set
CONFIG_NET_IFE_SKBMARK=m
CONFIG_NET_IFE_SKBPRIO=m
CONFIG_NET_IFE_SKBTCINDEX=m
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set
# CONFIG_CAN_ISOTP is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
# CONFIG_MCTP is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
# CONFIG_NFC_DIGITAL is not set
CONFIG_NFC_NCI=m
# CONFIG_NFC_NCI_SPI is not set
# CONFIG_NFC_NCI_UART is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_VIRTUAL_NCI=m
# CONFIG_NFC_FDP is not set
# CONFIG_NFC_PN533_USB is not set
# CONFIG_NFC_PN533_I2C is not set
# CONFIG_NFC_MRVL_USB is not set
# CONFIG_NFC_ST_NCI_I2C is not set
# CONFIG_NFC_ST_NCI_SPI is not set
# CONFIG_NFC_NXP_NCI is not set
# CONFIG_NFC_S3FWRN5_I2C is not set
# end of Near Field Communication (NFC) devices

CONFIG_PSAMPLE=m
CONFIG_NET_IFE=m
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
# CONFIG_PAGE_POOL_STATS is not set
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_EDR is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_CXL_BUS is not set
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_DEVTMPFS_SAFE is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
CONFIG_FW_UPLOAD=y
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# CONFIG_MHI_BUS_EP is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
CONFIG_SYSFB=y
# CONFIG_SYSFB_SIMPLEFB is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_DXE_MEM_ATTRIBUTES=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
# CONFIG_APPLE_PROPERTIES is not set
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y
# CONFIG_EFI_DISABLE_RUNTIME is not set
# CONFIG_EFI_COCO_SECRET is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=m
CONFIG_ZRAM_DEF_COMP_LZORLE=y
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP="lzo-rle"
CONFIG_ZRAM_WRITEBACK=y
# CONFIG_ZRAM_MEMORY_TRACKING is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_UBLK is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_VERBOSE_ERRORS is not set
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TCP is not set
# CONFIG_NVME_AUTH is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_FC=m
# CONFIG_NVME_TARGET_TCP is not set
# CONFIG_NVME_TARGET_AUTH is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_GSC is not set
# CONFIG_INTEL_MEI_HDCP is not set
# CONFIG_INTEL_MEI_PXP is not set
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
# CONFIG_PVPANIC_MMIO is not set
# CONFIG_PVPANIC_PCI is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_BLK_DEV_BSG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPI3MR is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_EFCT is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
CONFIG_MD_CLUSTER=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_MULTIPATH_HST is not set
# CONFIG_DM_MULTIPATH_IOA is not set
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
CONFIG_DM_AUDIT=y
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_IFB=m
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=y
CONFIG_GENEVE=y
CONFIG_BAREUDP=m
# CONFIG_GTP is not set
CONFIG_AMT=m
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
CONFIG_NET_VRF=y
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ASIX=y
# CONFIG_SPI_AX88796C is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_CX_ECAT is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
CONFIG_NET_VENDOR_DAVICOM=y
# CONFIG_DM9051 is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_ENGLEDER=y
# CONFIG_TSNEP is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_FUNGIBLE=y
# CONFIG_FUN_ETH is not set
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
# CONFIG_IXGBE_IPSEC is not set
# CONFIG_IXGBEVF is not set
CONFIG_I40E=y
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
CONFIG_IGC=y
CONFIG_NET_VENDOR_WANGXUN=y
# CONFIG_NGBE is not set
# CONFIG_TXGBE is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_LITEX=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_OCTEON_EP is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MICROSOFT=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
# CONFIG_SFC_SIENA is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VERTEXCOM=y
# CONFIG_MSE102X is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLINK=y
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_SFP is not set

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
# CONFIG_ADIN1100_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
CONFIG_AX88796B_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MARVELL_88X2222_PHY is not set
# CONFIG_MAXLINEAR_GPHY is not set
# CONFIG_MEDIATEK_GE_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_MOTORCOMM_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_DP83TD510_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_CAN_DEV=m
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_NETLINK=y
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_CAN327 is not set
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_CTUCANFD_PCI is not set
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_MCP251XFD is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB is not set
# CONFIG_CAN_ETAS_ES58X is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_FWNODE_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_DEVRES=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_THUNDER is not set

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
# CONFIG_USB_NET_CDCETHER is not set
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_ATH11K is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWLMEI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_PURELIFI=y
# CONFIG_PLFXLC is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
# CONFIG_RTW89 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_SILABS=y
# CONFIG_WFX is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set
# CONFIG_WAN is not set

#
# Wireless WAN
#
# CONFIG_WWAN is not set
# end of Wireless WAN

# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CYPRESS_SF is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
# CONFIG_RMI4_F3A is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
# CONFIG_TCG_TIS_I2C is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
CONFIG_RANDOM_TRUST_CPU=y
CONFIG_RANDOM_TRUST_BOOTLOADER=y
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_AMDPSP is not set
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_CP2615 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# CONFIG_I2C_VIRTIO is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_MICROCHIP_CORE is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_PTP_1588_CLOCK_OPTIONAL=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# end of PTP clock support

CONFIG_PINCTRL=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set

#
# Intel pinctrl drivers
#
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
# CONFIG_PINCTRL_ALDERLAKE is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_METEORLAKE is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
# CONFIG_PINCTRL_TIGERLAKE is not set
# end of Intel pinctrl drivers

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
CONFIG_GPIO_MOCKUP=m
# CONFIG_GPIO_VIRTIO is not set
CONFIG_GPIO_SIM=m
# end of Virtual GPIO drivers

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_IP5XXX_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SAMSUNG_SDI is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_MAX77976 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
# CONFIG_BATTERY_UG3105 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AQUACOMPUTER_D5NEXT is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_DELL_SMM is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6620 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MLXREG_FAN is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775_CORE=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT6775_I2C is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
# CONFIG_SENSORS_NZXT_SMART2 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_DELTA_AHE50DC_FAN is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_DPS920AB is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LT7182S is not set
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2888 is not set
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_MP5023 is not set
# CONFIG_SENSORS_PIM4328 is not set
# CONFIG_SENSORS_PLI1209BC is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE152 is not set
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
# CONFIG_SENSORS_SBRMI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SY7636A is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA238 is not set
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP464 is not set
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
# CONFIG_SENSORS_ASUS_WMI is not set
# CONFIG_SENSORS_ASUS_WMI_EC is not set
# CONFIG_SENSORS_ASUS_EC is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_INTEL_HFI_THERMAL is not set
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_MLX_WDT is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SIMPLE_MFD_I2C is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_INTEL_M10_BMC is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=y
CONFIG_BPF_LIRC_MODE2=y
CONFIG_LIRC=y
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_IR_IMON_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_SONY_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_IR_ENE=m
CONFIG_IR_FINTEK=m
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
CONFIG_IR_ITE_CIR=m
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_NUVOTON=m
# CONFIG_IR_REDRAT3 is not set
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_TOY is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_RC_LOOPBACK=m
# CONFIG_RC_XBOX_DVD is not set

#
# CEC support
#
# CONFIG_MEDIA_CEC_SUPPORT is not set
# end of CEC support

CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_SUPPORT_FILTER=y
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media device types
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_PLATFORM_SUPPORT is not set
# CONFIG_MEDIA_TEST_SUPPORT is not set
# end of Media device types

#
# Media drivers
#

#
# Drivers filtered as selected at 'Filter media drivers'
#

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# end of Media drivers

#
# Media ancillary drivers
#
# end of Media ancillary drivers

#
# Graphics support
#
CONFIG_APERTURE_HELPERS=y
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DEBUG_MM is not set
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
CONFIG_DRM_DEBUG_MODESET_LOCK=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_DISPLAY_HELPER=m
CONFIG_DRM_DISPLAY_DP_HELPER=y
CONFIG_DRM_DISPLAY_HDCP_HELPER=y
CONFIG_DRM_DISPLAY_HDMI_HELPER=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_BUDDY=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
# CONFIG_DRM_I915_GVT_KVMGT is not set

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

CONFIG_DRM_VGEM=y
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_QXL=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# CONFIG_DRM_PANEL_WIDECHIPS_WS2401 is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_BOCHS=m
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_DRM_PANEL_MIPI_DBI is not set
# CONFIG_DRM_SIMPLEDRM is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9163 is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_GUD is not set
# CONFIG_DRM_SSD130X is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_NOMODESET=y
CONFIG_DRM_LIB_RANDOM=y
CONFIG_DRM_PRIVACY_SCREEN=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION is not set
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_XIAOMI is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
# CONFIG_HID_LETSKETCH is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_MEGAWORLD_FF is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NINTENDO is not set
CONFIG_HID_NTI=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
# CONFIG_HID_RAZER is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SEMITEK is not set
# CONFIG_HID_SIGMAMICRO is not set
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
# end of USB HID support

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
# CONFIG_AMD_SFH_HID is not set
# end of AMD SFH HID Support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
# CONFIG_USB_SERIAL_XR is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_UCSI_STM32G0 is not set
# CONFIG_TYPEC_TPS6598X is not set
# CONFIG_TYPEC_RT1719 is not set
# CONFIG_TYPEC_STUSB160X is not set
# CONFIG_TYPEC_WUSB3801 is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_FSA4480 is not set
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_LP50XX is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_IS31FL319X is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# Flash and Torch LED drivers
#

#
# RGB LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_LEDS_TRIGGER_TTY is not set

#
# Simple LED drivers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_GHES=y
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
# CONFIG_EDAC_IGEN6 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_GOLDFISH is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
# CONFIG_INTEL_IDXD is not set
# CONFIG_INTEL_IDXD_COMPAT is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_AMD_PTDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
CONFIG_UDMABUF=y
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
# CONFIG_DMABUF_SYSFS_STATS is not set
CONFIG_DMABUF_HEAPS_SYSTEM=y
# end of DMABUF options

CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VFIO=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_PCI_LIB_LEGACY=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MEM is not set
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_RTL8723BS is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_SM750 is not set
# CONFIG_STAGING_MEDIA is not set
# CONFIG_LTE_GDM724X is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_FB_TFT is not set
# CONFIG_KS7010 is not set
# CONFIG_PI433 is not set
# CONFIG_FIELDBUS_DEV is not set
# CONFIG_QLGE is not set
# CONFIG_VME_BUS is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
# CONFIG_MLXREG_LC is not set
# CONFIG_NVSW_SN2201 is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
# CONFIG_UV_SYSFS is not set
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_NVIDIA_WMI_EC_BACKLIGHT is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
# CONFIG_YOGABOOK_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMC is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
# CONFIG_ASUS_TF103C_DOCK is not set
# CONFIG_MERAKI_MX100 is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
# CONFIG_WIRELESS_HOTKEY is not set
CONFIG_HP_WMI=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_THINKPAD_LMI is not set
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_INTEL_SAR_INT1092 is not set
CONFIG_INTEL_PMC_CORE=m

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_WMI=y
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m

#
# Intel Uncore Frequency Control
#
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
# end of Intel Uncore Frequency Control

CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_INTEL_ISHTP_ECLITE is not set
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_VSEC is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
# CONFIG_BARCO_P50_GPIO is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_SERIAL_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=m
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
# CONFIG_SIEMENS_SIMATIC_IPC is not set
# CONFIG_WINMATE_FM07_KEYS is not set
CONFIG_P2SB=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_LMK04832 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_XILINX_VCU is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOASID=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
CONFIG_IOMMU_DEFAULT_DMA_LAZY=y
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_IOMMU_SVA=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_SVM=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON=y
CONFIG_IRQ_REMAP=y
# CONFIG_VIRTIO_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# fujitsu SoC drivers
#
# end of fujitsu SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_CLK is not set
# CONFIG_PWM_DWC is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_USB_LGM_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set

#
# PHY drivers for Broadcom platforms
#
# CONFIG_BCM_KONA_USB2_PHY is not set
# end of PHY drivers for Broadcom platforms

# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=m
# CONFIG_STM_PROTO_BASIC is not set
# CONFIG_STM_PROTO_SYS_T is not set
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# CONFIG_PECI is not set
# CONFIG_HTE is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
# CONFIG_XFS_ONLINE_REPAIR is not set
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_F2FS_IOSTAT=y
# CONFIG_F2FS_UNFAIR_RWSEM is not set
# CONFIG_FS_DAX is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=m
CONFIG_NETFS_STATS=y
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_ERROR_INJECTION is not set
# CONFIG_CACHEFILES_ONDEMAND is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# CONFIG_NTFS3_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
# CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON is not set
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_NFS_V4_2_SSC_HELPER=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS_COMMON=m
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEPRECATED_API is not set
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_TRUSTED_KEYS_TPM=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
CONFIG_SECURITY_LANDLOCK=y
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
# CONFIG_IMA_KEXEC is not set
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_WRITE_POLICY=y
CONFIG_IMA_READ_POLICY=y
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_ARCH_POLICY=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT=y
# CONFIG_IMA_DISABLE_HTABLE is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
# CONFIG_ZERO_CALL_USED_REGS is not set
# end of Memory initialization

CONFIG_RANDSTRUCT_NONE=y
# CONFIG_RANDSTRUCT_FULL is not set
# CONFIG_RANDSTRUCT_PERFORMANCE is not set
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
# CONFIG_CRYPTO_DH_RFC7919_GROUPS is not set
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECDSA is not set
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_SM2 is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
# CONFIG_CRYPTO_HCTR2 is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_CRC64_ROCKSOFT=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_POLYVAL_CLMUL_NI is not set
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_POLY1305_X86_64=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3_GENERIC is not set
# CONFIG_CRYPTO_SM3_AVX_X86_64 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
CONFIG_CRYPTO_SEED=m
# CONFIG_CRYPTO_ARIA is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_SM4=y
CONFIG_CRYPTO_SM4_GENERIC=y
# CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
# CONFIG_FIPS_SIGNATURE_SELFTEST is not set

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_MODULE_SIG_KEY_TYPE_RSA=y
# CONFIG_MODULE_SIG_KEY_TYPE_ECDSA is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
# CONFIG_SYSTEM_BLACKLIST_AUTH_UPDATE is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=m
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA256=y
# end of Crypto library routines

CONFIG_LIB_MEMNEQ=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC64_ROCKSOFT=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=m
# CONFIG_CRC4 is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
# CONFIG_XZ_DEC_MICROLZMA is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_DMA_MAP_BENCHMARK=y
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_ALWAYS_INIT=y
CONFIG_SBITMAP=y
# end of Library routines

CONFIG_ASN1_ENCODER=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_NONE is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_DEBUG_INFO_DWARF5 is not set
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_DEBUG_INFO_BTF=y
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_DEBUG_INFO_BTF_MODULES=y
# CONFIG_MODULE_ALLOW_BTF_MISMATCH is not set
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B is not set
CONFIG_OBJTOOL=y
# CONFIG_VMLINUX_MAP is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ONLY_BOUNDS=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set
# CONFIG_DEBUG_NET is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_PAGE_OWNER=y
# CONFIG_PAGE_TABLE_CHECK is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SHRINKER_DEBUG is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
# CONFIG_KASAN_MODULE_TEST is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_WQ_WATCHDOG=y
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_WW_MUTEX_SELFTEST=m
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PLIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_FPROBE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_OSNOISE_TRACER is not set
# CONFIG_TIMERLAT_TRACER is not set
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_FTRACE_SORT_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
CONFIG_PREEMPTIRQ_DELAY_TEST=m
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
# CONFIG_RV is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_AUXDISPLAY is not set
# CONFIG_SAMPLE_TRACE_EVENTS is not set
# CONFIG_SAMPLE_TRACE_CUSTOM_EVENTS is not set
CONFIG_SAMPLE_TRACE_PRINTK=m
CONFIG_SAMPLE_FTRACE_DIRECT=m
# CONFIG_SAMPLE_FTRACE_DIRECT_MULTI is not set
# CONFIG_SAMPLE_TRACE_ARRAY is not set
# CONFIG_SAMPLE_KOBJECT is not set
# CONFIG_SAMPLE_KPROBES is not set
# CONFIG_SAMPLE_HW_BREAKPOINT is not set
# CONFIG_SAMPLE_FPROBE is not set
# CONFIG_SAMPLE_KFIFO is not set
# CONFIG_SAMPLE_LIVEPATCH is not set
# CONFIG_SAMPLE_CONFIGFS is not set
# CONFIG_SAMPLE_VFIO_MDEV_MTTY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB is not set
# CONFIG_SAMPLE_VFIO_MDEV_MBOCHS is not set
# CONFIG_SAMPLE_WATCHDOG is not set
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
CONFIG_LKDTM=y
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_TEST_REF_TRACKER is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_STRING_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=m
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=m
CONFIG_TEST_SCANF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_SIPHASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_BITOPS=m
CONFIG_TEST_VMALLOC=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_BLACKHOLE_DEV=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_SYSCTL=y
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_LIVEPATCH=m
# CONFIG_TEST_MEMINIT is not set
CONFIG_TEST_HMM=m
# CONFIG_TEST_FREE_PAGES is not set
CONFIG_TEST_FPU=m
# CONFIG_TEST_CLOCKSOURCE_WATCHDOG is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--FxTqW4ihe4HI1nwj
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job-script"

#!/bin/sh

export_top_env()
{
	export suite='kernel-selftests'
	export testcase='kernel-selftests'
	export category='functional'
	export job_origin='kernel-selftests-bm.yaml'
	export queue_cmdline_keys='branch
commit
kbuild_queue_analysis
bm_initrd_keep'
	export queue='validate'
	export testbox='lkp-skl-d01'
	export tbox_group='lkp-skl-d01'
	export submit_id='6339e600327459cc64906ed2'
	export job_file='/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-ipv6_udp-net-fcnal-test.sh-debian-12-x86_64-20220629.cgz-0e4d354762cefd3e16b4cff8988ff276e45effc4-20221003-52324-39tfl8-2.yaml'
	export id='d3840eade9557a73fe0caf40d34c1ab97f57e5d5'
	export queuer_version='/zday/lkp'
	export model='Skylake'
	export nr_cpu=8
	export memory='28G'
	export nr_ssd_partitions=1
	export nr_hdd_partitions=4
	export hdd_partitions='/dev/disk/by-id/wwn-0x50014ee20d26b072-part*'
	export ssd_partitions='/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part1'
	export swap_partitions='/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part3'
	export rootfs_partition='/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part2'
	export brand='Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz'
	export cpu_info='skylake i7-6700'
	export bios_version='1.2.8'
	export commit='0e4d354762cefd3e16b4cff8988ff276e45effc4'
	export need_kconfig_hw='{"PTP_1588_CLOCK"=>"y"}
{"E1000E"=>"y"}
SATA_AHCI
DRM_I915'
	export ucode='0xf0'
	export bisect_dmesg=true
	export need_kconfig='{"PACKET"=>"y"}
{"USER_NS"=>"y"}
{"BPF_SYSCALL"=>"y"}
{"TEST_BPF"=>"m"}
{"NUMA"=>"y, v5.6-rc1"}
{"NET_VRF"=>"y, v4.3-rc1"}
{"NET_L3_MASTER_DEV"=>"y, v4.4-rc1"}
{"IPV6"=>"y"}
{"IPV6_MULTIPLE_TABLES"=>"y"}
{"VETH"=>"y"}
{"NET_IPVTI"=>"m"}
{"IPV6_VTI"=>"m"}
{"DUMMY"=>"y"}
{"BRIDGE"=>"y"}
{"VLAN_8021Q"=>"y"}
IFB
{"NETFILTER"=>"y"}
{"NETFILTER_ADVANCED"=>"y"}
{"NF_CONNTRACK"=>"m"}
{"NF_NAT"=>"m, v5.1-rc1"}
{"IP6_NF_IPTABLES"=>"m"}
{"IP_NF_IPTABLES"=>"m"}
{"IP6_NF_NAT"=>"m"}
{"IP_NF_NAT"=>"m"}
{"NF_TABLES"=>"m"}
{"NF_TABLES_IPV6"=>"y, v4.17-rc1"}
{"NF_TABLES_IPV4"=>"y, v4.17-rc1"}
{"NFT_CHAIN_NAT_IPV6"=>"m, <= v5.0"}
{"NFT_TPROXY"=>"m, v4.19-rc1"}
{"NFT_COUNTER"=>"m, <= v5.16-rc4"}
{"NFT_CHAIN_NAT_IPV4"=>"m, <= v5.0"}
{"NET_SCH_FQ"=>"m"}
{"NET_SCH_ETF"=>"m, v4.19-rc1"}
{"NET_SCH_NETEM"=>"y"}
{"TEST_BLACKHOLE_DEV"=>"m, v5.3-rc1"}
{"KALLSYMS"=>"y"}
{"BAREUDP"=>"m, v5.7-rc1"}
{"MPLS_ROUTING"=>"m, v4.1-rc1"}
{"MPLS_IPTUNNEL"=>"m, v4.3-rc1"}
{"NET_SCH_INGRESS"=>"y, v4.19-rc1"}
{"NET_CLS_FLOWER"=>"m, v4.2-rc1"}
{"NET_ACT_TUNNEL_KEY"=>"m, v4.9-rc1"}
{"NET_ACT_MIRRED"=>"m, v5.11-rc1"}
{"CRYPTO_SM4"=>"y, v4.17-rc1"}
{"CRYPTO_SM4_GENERIC"=>"y, v5.19-rc1"}
NET_DROP_MONITOR
TRACEPOINTS
{"AMT"=>"m, v5.16-rc1"}
{"IPV6_IOAM6_LWTUNNEL"=>"y, v5.15"}'
	export rootfs='debian-12-x86_64-20220629.cgz'
	export initrds='linux_headers
linux_selftests'
	export kconfig='x86_64-rhel-8.3-kselftests'
	export enqueue_time='2022-10-03 03:26:56 +0800'
	export _id='6339e619327459cc64906ed3'
	export _rt='/result/kernel-selftests/ipv6_udp-net-fcnal-test.sh/lkp-skl-d01/debian-12-x86_64-20220629.cgz/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4'
	export user='lkp'
	export compiler='gcc-11'
	export LKP_SERVER='internal-lkp-server'
	export head_commit='89934960fa96984efcbc93940a25ecd69b48de4f'
	export base_commit='f76349cf41451c5c42a99f18a9163377e4b364ff'
	export branch='linux-next/master'
	export result_root='/result/kernel-selftests/ipv6_udp-net-fcnal-test.sh/lkp-skl-d01/debian-12-x86_64-20220629.cgz/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/1'
	export scheduler_version='/lkp/lkp/.src-20221001-230515'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-12-x86_64-20220629.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/kernel-selftests/ipv6_udp-net-fcnal-test.sh/lkp-skl-d01/debian-12-x86_64-20220629.cgz/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/1
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/vmlinuz-6.0.0-rc2-00573-g0e4d354762ce
branch=linux-next/master
job=/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-ipv6_udp-net-fcnal-test.sh-debian-12-x86_64-20220629.cgz-0e4d354762cefd3e16b4cff8988ff276e45effc4-20221003-52324-39tfl8-2.yaml
user=lkp
ARCH=x86_64
kconfig=x86_64-rhel-8.3-kselftests
commit=0e4d354762cefd3e16b4cff8988ff276e45effc4
max_uptime=2100
LKP_SERVER=internal-lkp-server
nokaslr
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/modules.cgz'
	export linux_headers_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/linux-headers.cgz'
	export linux_selftests_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/linux-selftests.cgz'
	export bm_initrd='/osimage/deps/debian-12-x86_64-20220629.cgz/run-ipconfig_20220629.cgz,/osimage/deps/debian-12-x86_64-20220629.cgz/lkp_20220629.cgz,/osimage/deps/debian-12-x86_64-20220629.cgz/rsync-rootfs_20220629.cgz,/osimage/deps/debian-12-x86_64-20220629.cgz/kernel-selftests_20220927.cgz,/osimage/pkg/debian-12-x86_64-20220629.cgz/kernel-selftests-x86_64-700a8991-1_20220823.cgz,/osimage/deps/debian-12-x86_64-20220629.cgz/hw_20220629.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20220804.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='6.0.0-rc7'
	export repeat_to=6
	export schedule_notify_address=
	export stop_repeat_if_found='kernel-selftests.net.fcnal-test.sh.fail'
	export kbuild_queue_analysis=1
	export bm_initrd_keep=true
	export kernel='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/vmlinuz-6.0.0-rc2-00573-g0e4d354762ce'
	export dequeue_time='2022-10-03 03:32:26 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-ipv6_udp-net-fcnal-test.sh-debian-12-x86_64-20220629.cgz-0e4d354762cefd3e16b4cff8988ff276e45effc4-20221003-52324-39tfl8-2.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test group='net' test='fcnal-test.sh' atomic_test='ipv6_udp' $LKP_SRC/tests/wrapper kernel-selftests
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env group='net' test='fcnal-test.sh' atomic_test='ipv6_udp' $LKP_SRC/stats/wrapper kernel-selftests
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time kernel-selftests.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--FxTqW4ihe4HI1nwj
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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
Wg==

--FxTqW4ihe4HI1nwj
Content-Type: text/plain; charset="utf-8"
Content-Disposition: attachment; filename="kernel-selftests"
Content-Transfer-Encoding: quoted-printable

KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-8=
.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4
2022-10-02 19:37:14 mount --bind /lib/modules/6.0.0-rc2-00573-g0e4d354762ce=
/kernel/lib /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762ce=
fd3e16b4cff8988ff276e45effc4/lib
2022-10-02 19:37:14 ln -sf /usr/sbin/iptables-nft /usr/bin/iptables
2022-10-02 19:37:14 ln -sf /usr/sbin/ip6tables-nft /usr/bin/ip6tables
2022-10-02 19:37:14 sed -i s/default_timeout=3D45/default_timeout=3D300/ ks=
elftest/runner.sh
2022-10-02 19:37:14 make -C bpf
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf'
  MKDIR    libbpf
  HOSTCC  /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/f=
ixdep.o
  HOSTLD  /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/f=
ixdep-in.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/f=
ixdep
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/b=
pf_helper_defs.h
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/libbpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/bpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/nlattr.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/btf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/libbpf_errno.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/str_error.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/netlink.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/bpf_prog_linfo.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/libbpf_probes.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/hashmap.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/btf_dump.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/ringbuf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/strset.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/linker.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/gen_loader.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/relo_core.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/usdt.o
  LD      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/libbpf-in.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/l=
ibbpf.a
Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from=
 latest version at 'include/uapi/linux/bpf.h'
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/libbpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/bpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/nlattr.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/btf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/libbpf_errno.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/str_error.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/netlink.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/bpf_prog_linfo.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/libbpf_probes.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/hashmap.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/btf_dump.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/ringbuf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/strset.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/linker.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/gen_loader.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/relo_core.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/usdt.o
  LD      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/libbpf-in.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/l=
ibbpf.so.1.0.0
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/libbpf/l=
ibbpf.pc
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/bp=
f.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/li=
bbpf.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/bt=
f.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/li=
bbpf_common.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/li=
bbpf_legacy.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/bp=
f_helpers.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/bp=
f_tracing.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/bp=
f_endian.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/bp=
f_core_read.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/sk=
el_internal.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/li=
bbpf_version.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/us=
dt.bpf.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/bp=
f_helper_defs.h
  TEST-HDR [test_progs] tests.h
  EXT-OBJ  [test_progs] testing_helpers.o
  EXT-OBJ  [test_progs] cap_helpers.o
  BINARY   test_verifier
  BINARY   test_tag
  MKDIR    bpftool

Auto-detecting system features:
...                        libbfd: [ =1B[32mon=1B[m  ]
...                libbfd-liberty: [ =1B[31mOFF=1B[m ]
...              libbfd-liberty-z: [ =1B[31mOFF=1B[m ]
...                        libcap: [ =1B[32mon=1B[m  ]
...               clang-bpf-co-re: [ =1B[32mon=1B[m  ]

...                      /tmp/lkp: [ =1B[31mOFF=1B[m ]

  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/ha=
shmap.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/nl=
attr.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/re=
lo_core.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/include/bpf/li=
bbpf_internal.h
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
btf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
btf_dumper.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
cfg.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
cgroup.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
common.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
feature.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
gen.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
iter.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
json_writer.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
link.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
main.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
map.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
map_perf_ring.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
net.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
netlink_dumper.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
perf.o
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/hashmap.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/relo_core.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/libbpf_internal.h
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/bpf_helper_defs.h
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/libbpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/bpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/nlattr.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/btf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/libbpf_errno.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/str_error.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/netlink.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/bpf_prog_linfo.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/libbpf_probes.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/hashmap.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/btf_dump.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/ringbuf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/strset.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/linker.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/gen_loader.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/relo_core.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/usdt.o
  LD      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/libbpf-in.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/libbpf.a
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/libbpf.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/btf.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/libbpf_common.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/libbpf_legacy.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf_helpers.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf_tracing.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf_endian.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf_core_read.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/skel_internal.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/libbpf_version.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/usdt.bpf.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf_helper_defs.h
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/main.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/common.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/json_writer.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/gen.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/btf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/xlated_dumper.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/btf_dumper.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/disasm.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/bpftool
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
vmlinux.h
  CLANG   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
pid_iter.bpf.o
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
pid_iter.skel.h
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
pids.o
  CLANG   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
profiler.bpf.o
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
profiler.skel.h
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
prog.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
struct_ops.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
tracelog.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
xlated_dumper.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
jit_disasm.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
disasm.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/bpftool/=
bpftool
  INSTALL bpftool
  GEN      vmlinux.h
  CLNG-BPF [test_maps] atomic_bounds.o
  CLNG-BPF [test_maps] atomics.o
  CLNG-BPF [test_maps] bind4_prog.o
  CLNG-BPF [test_maps] bind6_prog.o
  CLNG-BPF [test_maps] bind_perm.o
  CLNG-BPF [test_maps] bloom_filter_bench.o
  CLNG-BPF [test_maps] bloom_filter_map.o
  CLNG-BPF [test_maps] bpf_cubic.o
  CLNG-BPF [test_maps] bpf_dctcp.o
  CLNG-BPF [test_maps] bpf_dctcp_release.o
  CLNG-BPF [test_maps] bpf_flow.o
  CLNG-BPF [test_maps] bpf_hashmap_full_update_bench.o
  CLNG-BPF [test_maps] bpf_iter_bpf_array_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_hash_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_link.o
  CLNG-BPF [test_maps] bpf_iter_bpf_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_percpu_array_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_percpu_hash_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_sk_storage_helpers.o
  CLNG-BPF [test_maps] bpf_iter_bpf_sk_storage_map.o
  CLNG-BPF [test_maps] bpf_iter_ipv6_route.o
  CLNG-BPF [test_maps] bpf_iter_ksym.o
  CLNG-BPF [test_maps] bpf_iter_netlink.o
  CLNG-BPF [test_maps] bpf_iter_setsockopt.o
  CLNG-BPF [test_maps] bpf_iter_setsockopt_unix.o
  CLNG-BPF [test_maps] bpf_iter_sockmap.o
  CLNG-BPF [test_maps] bpf_iter_task.o
  CLNG-BPF [test_maps] bpf_iter_task_btf.o
  CLNG-BPF [test_maps] bpf_iter_task_file.o
  CLNG-BPF [test_maps] bpf_iter_task_stack.o
  CLNG-BPF [test_maps] bpf_iter_task_vma.o
  CLNG-BPF [test_maps] bpf_iter_tcp4.o
  CLNG-BPF [test_maps] bpf_iter_tcp6.o
  CLNG-BPF [test_maps] bpf_iter_test_kern1.o
  CLNG-BPF [test_maps] bpf_iter_test_kern2.o
  CLNG-BPF [test_maps] bpf_iter_test_kern3.o
  CLNG-BPF [test_maps] bpf_iter_test_kern4.o
  CLNG-BPF [test_maps] bpf_iter_test_kern5.o
  CLNG-BPF [test_maps] bpf_iter_test_kern6.o
  CLNG-BPF [test_maps] bpf_iter_udp4.o
  CLNG-BPF [test_maps] bpf_iter_udp6.o
  CLNG-BPF [test_maps] bpf_iter_unix.o
  CLNG-BPF [test_maps] bpf_loop.o
  CLNG-BPF [test_maps] bpf_loop_bench.o
  CLNG-BPF [test_maps] bpf_mod_race.o
  CLNG-BPF [test_maps] bpf_syscall_macro.o
  CLNG-BPF [test_maps] bpf_tcp_nogpl.o
  CLNG-BPF [test_maps] bprm_opts.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___diff_arr_dim.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___diff_arr_val_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___equiv_zero_sz_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_bad_zero_sz_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_non_array.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_too_shallow.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_too_small.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_wrong_val_type.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___fixed_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___bit_sz_change.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___bitfield_vs_int.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___err_too_big_bitfield.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___just_big_enough.o
  CLNG-BPF [test_maps] btf__core_reloc_enum64val.o
  CLNG-BPF [test_maps] btf__core_reloc_enum64val___diff.o
  CLNG-BPF [test_maps] btf__core_reloc_enum64val___err_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_enum64val___val3_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval___diff.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval___err_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval___val3_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_existence.o
  CLNG-BPF [test_maps] btf__core_reloc_existence___minimal.o
  CLNG-BPF [test_maps] btf__core_reloc_existence___wrong_field_defs.o
  CLNG-BPF [test_maps] btf__core_reloc_flavors.o
  CLNG-BPF [test_maps] btf__core_reloc_flavors__err_wrong_name.o
  CLNG-BPF [test_maps] btf__core_reloc_ints.o
  CLNG-BPF [test_maps] btf__core_reloc_ints___bool.o
  CLNG-BPF [test_maps] btf__core_reloc_ints___reverse_sign.o
  CLNG-BPF [test_maps] btf__core_reloc_misc.o
  CLNG-BPF [test_maps] btf__core_reloc_mods.o
  CLNG-BPF [test_maps] btf__core_reloc_mods___mod_swap.o
  CLNG-BPF [test_maps] btf__core_reloc_mods___typedefs.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___anon_embed.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___dup_compat_types.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_array_container.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_array_field.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_dup_incompat_types.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_missing_container.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_missing_field.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_nonstruct_container.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_partial_match_dups.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_too_deep.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___extra_nesting.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___struct_union_mixup.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___diff_enum_def.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___diff_func_proto.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___diff_ptr_type.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___err_non_enum.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___err_non_int.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___err_non_ptr.o
  CLNG-BPF [test_maps] btf__core_reloc_ptr_as_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_ptr_as_arr___diff_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_size.o
  CLNG-BPF [test_maps] btf__core_reloc_size___diff_offs.o
  CLNG-BPF [test_maps] btf__core_reloc_size___diff_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_size___err_ambiguous.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___all_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___diff.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___diff_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___fn_wrong_args.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___incompat.o
  CLNG-BPF [test_maps] btf__core_reloc_type_id.o
  CLNG-BPF [test_maps] btf__core_reloc_type_id___missing_targets.o
  CLNG-BPF [test_maps] btf_data.o
  CLNG-BPF [test_maps] btf_dump_test_case_bitfields.o
  CLNG-BPF [test_maps] btf_dump_test_case_multidim.o
  CLNG-BPF [test_maps] btf_dump_test_case_namespacing.o
  CLNG-BPF [test_maps] btf_dump_test_case_ordering.o
  CLNG-BPF [test_maps] btf_dump_test_case_packing.o
  CLNG-BPF [test_maps] btf_dump_test_case_padding.o
  CLNG-BPF [test_maps] btf_dump_test_case_syntax.o
  CLNG-BPF [test_maps] btf_type_tag.o
  CLNG-BPF [test_maps] btf_type_tag_percpu.o
  CLNG-BPF [test_maps] btf_type_tag_user.o
  CLNG-BPF [test_maps] cg_storage_multi_egress_only.o
  CLNG-BPF [test_maps] cg_storage_multi_isolated.o
  CLNG-BPF [test_maps] cg_storage_multi_shared.o
  CLNG-BPF [test_maps] cgroup_getset_retval_getsockopt.o
  CLNG-BPF [test_maps] cgroup_getset_retval_setsockopt.o
  CLNG-BPF [test_maps] cgroup_skb_sk_lookup_kern.o
  CLNG-BPF [test_maps] connect4_dropper.o
  CLNG-BPF [test_maps] connect4_prog.o
  CLNG-BPF [test_maps] connect6_prog.o
  CLNG-BPF [test_maps] connect_force_port4.o
  CLNG-BPF [test_maps] connect_force_port6.o
  CLNG-BPF [test_maps] core_kern.o
  CLNG-BPF [test_maps] core_kern_overflow.o
  CLNG-BPF [test_maps] dev_cgroup.o
  CLNG-BPF [test_maps] dummy_st_ops.o
  CLNG-BPF [test_maps] dynptr_fail.o
  CLNG-BPF [test_maps] dynptr_success.o
  CLNG-BPF [test_maps] exhandler_kern.o
  CLNG-BPF [test_maps] fentry_test.o
  CLNG-BPF [test_maps] fexit_bpf2bpf.o
  CLNG-BPF [test_maps] fexit_bpf2bpf_simple.o
  CLNG-BPF [test_maps] fexit_sleep.o
  CLNG-BPF [test_maps] fexit_test.o
  CLNG-BPF [test_maps] find_vma.o
  CLNG-BPF [test_maps] find_vma_fail1.o
  CLNG-BPF [test_maps] find_vma_fail2.o
  CLNG-BPF [test_maps] fmod_ret_freplace.o
  CLNG-BPF [test_maps] for_each_array_map_elem.o
  CLNG-BPF [test_maps] for_each_hash_map_elem.o
  CLNG-BPF [test_maps] for_each_map_elem_write_key.o
  CLNG-BPF [test_maps] freplace_attach_probe.o
  CLNG-BPF [test_maps] freplace_cls_redirect.o
  CLNG-BPF [test_maps] freplace_connect4.o
  CLNG-BPF [test_maps] freplace_connect_v4_prog.o
  CLNG-BPF [test_maps] freplace_get_constant.o
  CLNG-BPF [test_maps] freplace_global_func.o
  CLNG-BPF [test_maps] get_branch_snapshot.o
  CLNG-BPF [test_maps] get_cgroup_id_kern.o
  CLNG-BPF [test_maps] get_func_args_test.o
  CLNG-BPF [test_maps] get_func_ip_test.o
  CLNG-BPF [test_maps] ima.o
  CLNG-BPF [test_maps] kfree_skb.o
  CLNG-BPF [test_maps] kfunc_call_destructive.o
  CLNG-BPF [test_maps] kfunc_call_race.o
  CLNG-BPF [test_maps] kfunc_call_test.o
  CLNG-BPF [test_maps] kfunc_call_test_subprog.o
  CLNG-BPF [test_maps] kprobe_multi.o
  CLNG-BPF [test_maps] kprobe_multi_empty.o
  CLNG-BPF [test_maps] ksym_race.o
  CLNG-BPF [test_maps] linked_funcs1.o
  CLNG-BPF [test_maps] linked_funcs2.o
  CLNG-BPF [test_maps] linked_maps1.o
  CLNG-BPF [test_maps] linked_maps2.o
  CLNG-BPF [test_maps] linked_vars1.o
  CLNG-BPF [test_maps] linked_vars2.o
  CLNG-BPF [test_maps] load_bytes_relative.o
  CLNG-BPF [test_maps] local_storage.o
  CLNG-BPF [test_maps] local_storage_bench.o
  CLNG-BPF [test_maps] local_storage_rcu_tasks_trace_bench.o
  CLNG-BPF [test_maps] loop1.o
  CLNG-BPF [test_maps] loop2.o
  CLNG-BPF [test_maps] loop3.o
  CLNG-BPF [test_maps] loop4.o
  CLNG-BPF [test_maps] loop5.o
  CLNG-BPF [test_maps] loop6.o
  CLNG-BPF [test_maps] lru_bug.o
  CLNG-BPF [test_maps] lsm.o
  CLNG-BPF [test_maps] lsm_cgroup.o
  CLNG-BPF [test_maps] lsm_cgroup_nonvoid.o
  CLNG-BPF [test_maps] map_kptr.o
  CLNG-BPF [test_maps] map_kptr_fail.o
  CLNG-BPF [test_maps] map_ptr_kern.o
  CLNG-BPF [test_maps] metadata_unused.o
  CLNG-BPF [test_maps] metadata_used.o
  CLNG-BPF [test_maps] modify_return.o
  CLNG-BPF [test_maps] mptcp_sock.o
  CLNG-BPF [test_maps] netcnt_prog.o
  CLNG-BPF [test_maps] netif_receive_skb.o
  CLNG-BPF [test_maps] netns_cookie_prog.o
  CLNG-BPF [test_maps] perf_event_stackmap.o
  CLNG-BPF [test_maps] perfbuf_bench.o
  CLNG-BPF [test_maps] profiler1.o
  CLNG-BPF [test_maps] profiler2.o
  CLNG-BPF [test_maps] profiler3.o
  CLNG-BPF [test_maps] pyperf100.o
  CLNG-BPF [test_maps] pyperf180.o
  CLNG-BPF [test_maps] pyperf50.o
  CLNG-BPF [test_maps] pyperf600.o
  CLNG-BPF [test_maps] pyperf600_bpf_loop.o
  CLNG-BPF [test_maps] pyperf600_nounroll.o
  CLNG-BPF [test_maps] pyperf_global.o
  CLNG-BPF [test_maps] pyperf_subprogs.o
  CLNG-BPF [test_maps] recursion.o
  CLNG-BPF [test_maps] recvmsg4_prog.o
  CLNG-BPF [test_maps] recvmsg6_prog.o
  CLNG-BPF [test_maps] ringbuf_bench.o
  CLNG-BPF [test_maps] sample_map_ret0.o
  CLNG-BPF [test_maps] sample_ret0.o
  CLNG-BPF [test_maps] sendmsg4_prog.o
  CLNG-BPF [test_maps] sendmsg6_prog.o
  CLNG-BPF [test_maps] skb_load_bytes.o
  CLNG-BPF [test_maps] skb_pkt_end.o
  CLNG-BPF [test_maps] socket_cookie_prog.o
  CLNG-BPF [test_maps] sockmap_parse_prog.o
  CLNG-BPF [test_maps] sockmap_tcp_msg_prog.o
  CLNG-BPF [test_maps] sockmap_verdict_prog.o
  CLNG-BPF [test_maps] sockopt_inherit.o
  CLNG-BPF [test_maps] sockopt_multi.o
  CLNG-BPF [test_maps] sockopt_qos_to_cc.o
  CLNG-BPF [test_maps] sockopt_sk.o
  CLNG-BPF [test_maps] stacktrace_map_skip.o
  CLNG-BPF [test_maps] strncmp_bench.o
  CLNG-BPF [test_maps] strncmp_test.o
  CLNG-BPF [test_maps] strobemeta.o
  CLNG-BPF [test_maps] strobemeta_bpf_loop.o
  CLNG-BPF [test_maps] strobemeta_nounroll1.o
  CLNG-BPF [test_maps] strobemeta_nounroll2.o
  CLNG-BPF [test_maps] strobemeta_subprogs.o
  CLNG-BPF [test_maps] syscall.o
  CLNG-BPF [test_maps] tailcall1.o
  CLNG-BPF [test_maps] tailcall2.o
  CLNG-BPF [test_maps] tailcall3.o
  CLNG-BPF [test_maps] tailcall4.o
  CLNG-BPF [test_maps] tailcall5.o
  CLNG-BPF [test_maps] tailcall6.o
  CLNG-BPF [test_maps] tailcall_bpf2bpf1.o
  CLNG-BPF [test_maps] tailcall_bpf2bpf2.o
  CLNG-BPF [test_maps] tailcall_bpf2bpf3.o
  CLNG-BPF [test_maps] tailcall_bpf2bpf4.o
  CLNG-BPF [test_maps] tailcall_bpf2bpf6.o
  CLNG-BPF [test_maps] task_local_storage.o
  CLNG-BPF [test_maps] task_local_storage_exit_creds.o
  CLNG-BPF [test_maps] task_ls_recursion.o
  CLNG-BPF [test_maps] tcp_ca_incompl_cong_ops.o
  CLNG-BPF [test_maps] tcp_ca_unsupp_cong_op.o
  CLNG-BPF [test_maps] tcp_ca_write_sk_pacing.o
  CLNG-BPF [test_maps] tcp_rtt.o
  CLNG-BPF [test_maps] test_attach_probe.o
  CLNG-BPF [test_maps] test_autoattach.o
  CLNG-BPF [test_maps] test_autoload.o
  CLNG-BPF [test_maps] test_bpf_cookie.o
  CLNG-BPF [test_maps] test_bpf_nf.o
  CLNG-BPF [test_maps] test_bpf_nf_fail.o
  CLNG-BPF [test_maps] test_btf_decl_tag.o
  CLNG-BPF [test_maps] test_btf_map_in_map.o
  CLNG-BPF [test_maps] test_btf_newkv.o
  CLNG-BPF [test_maps] test_btf_nokv.o
  CLNG-BPF [test_maps] test_btf_skc_cls_ingress.o
  CLNG-BPF [test_maps] test_cgroup_link.o
  CLNG-BPF [test_maps] test_check_mtu.o
  CLNG-BPF [test_maps] test_cls_redirect.o
  CLNG-BPF [test_maps] test_cls_redirect_subprogs.o
  CLNG-BPF [test_maps] test_core_autosize.o
  CLNG-BPF [test_maps] test_core_extern.o
  CLNG-BPF [test_maps] test_core_read_macros.o
  CLNG-BPF [test_maps] test_core_reloc_arrays.o
  CLNG-BPF [test_maps] test_core_reloc_bitfields_direct.o
  CLNG-BPF [test_maps] test_core_reloc_bitfields_probed.o
  CLNG-BPF [test_maps] test_core_reloc_enum64val.o
  CLNG-BPF [test_maps] test_core_reloc_enumval.o
  CLNG-BPF [test_maps] test_core_reloc_existence.o
  CLNG-BPF [test_maps] test_core_reloc_flavors.o
  CLNG-BPF [test_maps] test_core_reloc_ints.o
  CLNG-BPF [test_maps] test_core_reloc_kernel.o
  CLNG-BPF [test_maps] test_core_reloc_misc.o
  CLNG-BPF [test_maps] test_core_reloc_mods.o
  CLNG-BPF [test_maps] test_core_reloc_module.o
  CLNG-BPF [test_maps] test_core_reloc_nesting.o
  CLNG-BPF [test_maps] test_core_reloc_primitives.o
  CLNG-BPF [test_maps] test_core_reloc_ptr_as_arr.o
  CLNG-BPF [test_maps] test_core_reloc_size.o
  CLNG-BPF [test_maps] test_core_reloc_type_based.o
  CLNG-BPF [test_maps] test_core_reloc_type_id.o
  CLNG-BPF [test_maps] test_core_retro.o
  CLNG-BPF [test_maps] test_custom_sec_handlers.o
  CLNG-BPF [test_maps] test_d_path.o
  CLNG-BPF [test_maps] test_d_path_check_rdonly_mem.o
  CLNG-BPF [test_maps] test_d_path_check_types.o
  CLNG-BPF [test_maps] test_enable_stats.o
  CLNG-BPF [test_maps] test_endian.o
  CLNG-BPF [test_maps] test_get_stack_rawtp.o
  CLNG-BPF [test_maps] test_get_stack_rawtp_err.o
  CLNG-BPF [test_maps] test_global_data.o
  CLNG-BPF [test_maps] test_global_func1.o
  CLNG-BPF [test_maps] test_global_func10.o
  CLNG-BPF [test_maps] test_global_func11.o
  CLNG-BPF [test_maps] test_global_func12.o
  CLNG-BPF [test_maps] test_global_func13.o
  CLNG-BPF [test_maps] test_global_func14.o
  CLNG-BPF [test_maps] test_global_func15.o
  CLNG-BPF [test_maps] test_global_func16.o
  CLNG-BPF [test_maps] test_global_func17.o
  CLNG-BPF [test_maps] test_global_func2.o
  CLNG-BPF [test_maps] test_global_func3.o
  CLNG-BPF [test_maps] test_global_func4.o
  CLNG-BPF [test_maps] test_global_func5.o
  CLNG-BPF [test_maps] test_global_func6.o
  CLNG-BPF [test_maps] test_global_func7.o
  CLNG-BPF [test_maps] test_global_func8.o
  CLNG-BPF [test_maps] test_global_func9.o
  CLNG-BPF [test_maps] test_global_func_args.o
  CLNG-BPF [test_maps] test_hash_large_key.o
  CLNG-BPF [test_maps] test_helper_restricted.o
  CLNG-BPF [test_maps] test_ksyms.o
  CLNG-BPF [test_maps] test_ksyms_btf.o
  CLNG-BPF [test_maps] test_ksyms_btf_null_check.o
  CLNG-BPF [test_maps] test_ksyms_btf_write_check.o
  CLNG-BPF [test_maps] test_ksyms_module.o
  CLNG-BPF [test_maps] test_ksyms_weak.o
  CLNG-BPF [test_maps] test_l4lb.o
  CLNG-BPF [test_maps] test_l4lb_noinline.o
  CLNG-BPF [test_maps] test_legacy_printk.o
  CLNG-BPF [test_maps] test_link_pinning.o
  CLNG-BPF [test_maps] test_lirc_mode2_kern.o
  CLNG-BPF [test_maps] test_log_buf.o
  CLNG-BPF [test_maps] test_log_fixup.o
  CLNG-BPF [test_maps] test_lookup_and_delete.o
  CLNG-BPF [test_maps] test_lwt_ip_encap.o
  CLNG-BPF [test_maps] test_lwt_seg6local.o
  CLNG-BPF [test_maps] test_map_in_map.o
  CLNG-BPF [test_maps] test_map_in_map_invalid.o
  CLNG-BPF [test_maps] test_map_init.o
  CLNG-BPF [test_maps] test_map_lock.o
  CLNG-BPF [test_maps] test_map_lookup_percpu_elem.o
  CLNG-BPF [test_maps] test_migrate_reuseport.o
  CLNG-BPF [test_maps] test_misc_tcp_hdr_options.o
  CLNG-BPF [test_maps] test_mmap.o
  CLNG-BPF [test_maps] test_module_attach.o
  CLNG-BPF [test_maps] test_ns_current_pid_tgid.o
  CLNG-BPF [test_maps] test_obj_id.o
  CLNG-BPF [test_maps] test_overhead.o
  CLNG-BPF [test_maps] test_pe_preserve_elems.o
  CLNG-BPF [test_maps] test_perf_branches.o
  CLNG-BPF [test_maps] test_perf_buffer.o
  CLNG-BPF [test_maps] test_perf_link.o
  CLNG-BPF [test_maps] test_pinning.o
  CLNG-BPF [test_maps] test_pinning_invalid.o
  CLNG-BPF [test_maps] test_pkt_access.o
  CLNG-BPF [test_maps] test_pkt_md_access.o
  CLNG-BPF [test_maps] test_probe_read_user_str.o
  CLNG-BPF [test_maps] test_probe_user.o
  CLNG-BPF [test_maps] test_prog_array_init.o
  CLNG-BPF [test_maps] test_queue_map.o
  CLNG-BPF [test_maps] test_raw_tp_test_run.o
  CLNG-BPF [test_maps] test_rdonly_maps.o
  CLNG-BPF [test_maps] test_ringbuf.o
  CLNG-BPF [test_maps] test_ringbuf_multi.o
  CLNG-BPF [test_maps] test_seg6_loop.o
  CLNG-BPF [test_maps] test_select_reuseport_kern.o
  CLNG-BPF [test_maps] test_send_signal_kern.o
  CLNG-BPF [test_maps] test_sk_assign.o
  CLNG-BPF [test_maps] test_sk_lookup.o
  CLNG-BPF [test_maps] test_sk_lookup_kern.o
  CLNG-BPF [test_maps] test_sk_storage_trace_itself.o
  CLNG-BPF [test_maps] test_sk_storage_tracing.o
  CLNG-BPF [test_maps] test_skb_cgroup_id_kern.o
  CLNG-BPF [test_maps] test_skb_ctx.o
  CLNG-BPF [test_maps] test_skb_helpers.o
  CLNG-BPF [test_maps] test_skc_to_unix_sock.o
  CLNG-BPF [test_maps] test_skeleton.o
  CLNG-BPF [test_maps] test_skmsg_load_helpers.o
  CLNG-BPF [test_maps] test_snprintf.o
  CLNG-BPF [test_maps] test_snprintf_single.o
  CLNG-BPF [test_maps] test_sock_fields.o
  CLNG-BPF [test_maps] test_sockhash_kern.o
  CLNG-BPF [test_maps] test_sockmap_invalid_update.o
  CLNG-BPF [test_maps] test_sockmap_kern.o
  CLNG-BPF [test_maps] test_sockmap_listen.o
  CLNG-BPF [test_maps] test_sockmap_progs_query.o
  CLNG-BPF [test_maps] test_sockmap_skb_verdict_attach.o
  CLNG-BPF [test_maps] test_sockmap_update.o
  CLNG-BPF [test_maps] test_spin_lock.o
  CLNG-BPF [test_maps] test_stack_map.o
  CLNG-BPF [test_maps] test_stack_var_off.o
  CLNG-BPF [test_maps] test_stacktrace_build_id.o
  CLNG-BPF [test_maps] test_stacktrace_map.o
  CLNG-BPF [test_maps] test_static_linked1.o
  CLNG-BPF [test_maps] test_static_linked2.o
  CLNG-BPF [test_maps] test_subprogs.o
  CLNG-BPF [test_maps] test_subprogs_unused.o
  CLNG-BPF [test_maps] test_subskeleton.o
  CLNG-BPF [test_maps] test_subskeleton_lib.o
  CLNG-BPF [test_maps] test_subskeleton_lib2.o
  CLNG-BPF [test_maps] test_sysctl_loop1.o
  CLNG-BPF [test_maps] test_sysctl_loop2.o
  CLNG-BPF [test_maps] test_sysctl_prog.o
  CLNG-BPF [test_maps] test_task_pt_regs.o
  CLNG-BPF [test_maps] test_tc_bpf.o
  CLNG-BPF [test_maps] test_tc_dtime.o
  CLNG-BPF [test_maps] test_tc_edt.o
  CLNG-BPF [test_maps] test_tc_neigh.o
  CLNG-BPF [test_maps] test_tc_neigh_fib.o
  CLNG-BPF [test_maps] test_tc_peer.o
  CLNG-BPF [test_maps] test_tc_tunnel.o
  CLNG-BPF [test_maps] test_tcp_check_syncookie_kern.o
  CLNG-BPF [test_maps] test_tcp_estats.o
  CLNG-BPF [test_maps] test_tcp_hdr_options.o
  CLNG-BPF [test_maps] test_tcpbpf_kern.o
  CLNG-BPF [test_maps] test_tcpnotify_kern.o
  CLNG-BPF [test_maps] test_time_tai.o
  CLNG-BPF [test_maps] test_trace_ext.o
  CLNG-BPF [test_maps] test_trace_ext_tracing.o
  CLNG-BPF [test_maps] test_tracepoint.o
  CLNG-BPF [test_maps] test_trampoline_count.o
  CLNG-BPF [test_maps] test_tunnel_kern.o
  CLNG-BPF [test_maps] test_unpriv_bpf_disabled.o
  CLNG-BPF [test_maps] test_uprobe_autoattach.o
  CLNG-BPF [test_maps] test_urandom_usdt.o
  CLNG-BPF [test_maps] test_usdt.o
  CLNG-BPF [test_maps] test_usdt_multispec.o
  CLNG-BPF [test_maps] test_varlen.o
  CLNG-BPF [test_maps] test_verif_scale1.o
  CLNG-BPF [test_maps] test_verif_scale2.o
  CLNG-BPF [test_maps] test_verif_scale3.o
  CLNG-BPF [test_maps] test_vmlinux.o
  CLNG-BPF [test_maps] test_xdp.o
  CLNG-BPF [test_maps] test_xdp_adjust_tail_grow.o
  CLNG-BPF [test_maps] test_xdp_adjust_tail_shrink.o
  CLNG-BPF [test_maps] test_xdp_bpf2bpf.o
  CLNG-BPF [test_maps] test_xdp_context_test_run.o
  CLNG-BPF [test_maps] test_xdp_devmap_helpers.o
  CLNG-BPF [test_maps] test_xdp_do_redirect.o
  CLNG-BPF [test_maps] test_xdp_link.o
  CLNG-BPF [test_maps] test_xdp_loop.o
  CLNG-BPF [test_maps] test_xdp_meta.o
  CLNG-BPF [test_maps] test_xdp_noinline.o
  CLNG-BPF [test_maps] test_xdp_redirect.o
  CLNG-BPF [test_maps] test_xdp_update_frags.o
  CLNG-BPF [test_maps] test_xdp_vlan.o
  CLNG-BPF [test_maps] test_xdp_with_cpumap_frags_helpers.o
  CLNG-BPF [test_maps] test_xdp_with_cpumap_helpers.o
  CLNG-BPF [test_maps] test_xdp_with_devmap_frags_helpers.o
  CLNG-BPF [test_maps] test_xdp_with_devmap_helpers.o
  CLNG-BPF [test_maps] timer.o
  CLNG-BPF [test_maps] timer_crash.o
  CLNG-BPF [test_maps] timer_mim.o
  CLNG-BPF [test_maps] timer_mim_reject.o
  CLNG-BPF [test_maps] trace_dummy_st_ops.o
  CLNG-BPF [test_maps] trace_printk.o
  CLNG-BPF [test_maps] trace_vprintk.o
  CLNG-BPF [test_maps] trigger_bench.o
  CLNG-BPF [test_maps] twfw.o
  CLNG-BPF [test_maps] udp_limit.o
  CLNG-BPF [test_maps] xdp_dummy.o
  CLNG-BPF [test_maps] xdp_redirect_map.o
  CLNG-BPF [test_maps] xdp_redirect_multi_kern.o
  CLNG-BPF [test_maps] xdp_synproxy_kern.o
  CLNG-BPF [test_maps] xdp_tx.o
  CLNG-BPF [test_maps] xdping_kern.o
  CLNG-BPF [test_maps] xdpwall.o
  GEN-SKEL [test_progs] atomic_bounds.skel.h
  GEN-SKEL [test_progs] bind4_prog.skel.h
  GEN-SKEL [test_progs] bind6_prog.skel.h
  GEN-SKEL [test_progs] bind_perm.skel.h
  GEN-SKEL [test_progs] bloom_filter_bench.skel.h
  GEN-SKEL [test_progs] bloom_filter_map.skel.h
  GEN-SKEL [test_progs] bpf_cubic.skel.h
  GEN-SKEL [test_progs] bpf_dctcp.skel.h
  GEN-SKEL [test_progs] bpf_dctcp_release.skel.h
  GEN-SKEL [test_progs] bpf_flow.skel.h
  GEN-SKEL [test_progs] bpf_hashmap_full_update_bench.skel.h
  GEN-SKEL [test_progs] bpf_iter_bpf_array_map.skel.h
  GEN-SKEL [test_progs] bpf_iter_bpf_hash_map.skel.h
  GEN-SKEL [test_progs] bpf_iter_bpf_link.skel.h
  GEN-SKEL [test_progs] bpf_iter_bpf_map.skel.h
  GEN-SKEL [test_progs] bpf_iter_bpf_percpu_array_map.skel.h
  GEN-SKEL [test_progs] bpf_iter_bpf_percpu_hash_map.skel.h
  GEN-SKEL [test_progs] bpf_iter_bpf_sk_storage_helpers.skel.h
  GEN-SKEL [test_progs] bpf_iter_bpf_sk_storage_map.skel.h
  GEN-SKEL [test_progs] bpf_iter_ipv6_route.skel.h
  GEN-SKEL [test_progs] bpf_iter_ksym.skel.h
  GEN-SKEL [test_progs] bpf_iter_netlink.skel.h
  GEN-SKEL [test_progs] bpf_iter_setsockopt.skel.h
  GEN-SKEL [test_progs] bpf_iter_setsockopt_unix.skel.h
  GEN-SKEL [test_progs] bpf_iter_sockmap.skel.h
  GEN-SKEL [test_progs] bpf_iter_task.skel.h
  GEN-SKEL [test_progs] bpf_iter_task_btf.skel.h
  GEN-SKEL [test_progs] bpf_iter_task_file.skel.h
  GEN-SKEL [test_progs] bpf_iter_task_stack.skel.h
  GEN-SKEL [test_progs] bpf_iter_task_vma.skel.h
  GEN-SKEL [test_progs] bpf_iter_tcp4.skel.h
  GEN-SKEL [test_progs] bpf_iter_tcp6.skel.h
  GEN-SKEL [test_progs] bpf_iter_test_kern1.skel.h
  GEN-SKEL [test_progs] bpf_iter_test_kern2.skel.h
  GEN-SKEL [test_progs] bpf_iter_test_kern3.skel.h
  GEN-SKEL [test_progs] bpf_iter_test_kern4.skel.h
  GEN-SKEL [test_progs] bpf_iter_test_kern5.skel.h
  GEN-SKEL [test_progs] bpf_iter_test_kern6.skel.h
  GEN-SKEL [test_progs] bpf_iter_udp4.skel.h
  GEN-SKEL [test_progs] bpf_iter_udp6.skel.h
  GEN-SKEL [test_progs] bpf_iter_unix.skel.h
  GEN-SKEL [test_progs] bpf_loop.skel.h
  GEN-SKEL [test_progs] bpf_loop_bench.skel.h
  GEN-SKEL [test_progs] bpf_mod_race.skel.h
  GEN-SKEL [test_progs] bpf_syscall_macro.skel.h
  GEN-SKEL [test_progs] bpf_tcp_nogpl.skel.h
  GEN-SKEL [test_progs] bprm_opts.skel.h
  GEN-SKEL [test_progs] btf_data.skel.h
  GEN-SKEL [test_progs] btf_dump_test_case_bitfields.skel.h
  GEN-SKEL [test_progs] btf_dump_test_case_multidim.skel.h
  GEN-SKEL [test_progs] btf_dump_test_case_namespacing.skel.h
  GEN-SKEL [test_progs] btf_dump_test_case_ordering.skel.h
  GEN-SKEL [test_progs] btf_dump_test_case_packing.skel.h
  GEN-SKEL [test_progs] btf_dump_test_case_padding.skel.h
  GEN-SKEL [test_progs] btf_dump_test_case_syntax.skel.h
  GEN-SKEL [test_progs] btf_type_tag.skel.h
  GEN-SKEL [test_progs] btf_type_tag_percpu.skel.h
  GEN-SKEL [test_progs] btf_type_tag_user.skel.h
  GEN-SKEL [test_progs] cg_storage_multi_egress_only.skel.h
  GEN-SKEL [test_progs] cg_storage_multi_isolated.skel.h
  GEN-SKEL [test_progs] cg_storage_multi_shared.skel.h
  GEN-SKEL [test_progs] cgroup_getset_retval_getsockopt.skel.h
  GEN-SKEL [test_progs] cgroup_getset_retval_setsockopt.skel.h
  GEN-SKEL [test_progs] cgroup_skb_sk_lookup_kern.skel.h
  GEN-SKEL [test_progs] connect4_dropper.skel.h
  GEN-SKEL [test_progs] connect4_prog.skel.h
  GEN-SKEL [test_progs] connect6_prog.skel.h
  GEN-SKEL [test_progs] connect_force_port4.skel.h
  GEN-SKEL [test_progs] connect_force_port6.skel.h
  GEN-SKEL [test_progs] dev_cgroup.skel.h
  GEN-SKEL [test_progs] dummy_st_ops.skel.h
  GEN-SKEL [test_progs] dynptr_fail.skel.h
  GEN-SKEL [test_progs] dynptr_success.skel.h
  GEN-SKEL [test_progs] exhandler_kern.skel.h
  GEN-SKEL [test_progs] fexit_bpf2bpf.skel.h
  GEN-SKEL [test_progs] fexit_bpf2bpf_simple.skel.h
  GEN-SKEL [test_progs] find_vma.skel.h
  GEN-SKEL [test_progs] find_vma_fail1.skel.h
  GEN-SKEL [test_progs] find_vma_fail2.skel.h
  GEN-SKEL [test_progs] fmod_ret_freplace.skel.h
  GEN-SKEL [test_progs] for_each_array_map_elem.skel.h
  GEN-SKEL [test_progs] for_each_hash_map_elem.skel.h
  GEN-SKEL [test_progs] for_each_map_elem_write_key.skel.h
  GEN-SKEL [test_progs] freplace_attach_probe.skel.h
  GEN-SKEL [test_progs] freplace_cls_redirect.skel.h
  GEN-SKEL [test_progs] freplace_connect4.skel.h
  GEN-SKEL [test_progs] freplace_connect_v4_prog.skel.h
  GEN-SKEL [test_progs] freplace_get_constant.skel.h
  GEN-SKEL [test_progs] freplace_global_func.skel.h
  GEN-SKEL [test_progs] get_branch_snapshot.skel.h
  GEN-SKEL [test_progs] get_cgroup_id_kern.skel.h
  GEN-SKEL [test_progs] get_func_args_test.skel.h
  GEN-SKEL [test_progs] get_func_ip_test.skel.h
  GEN-SKEL [test_progs] ima.skel.h
  GEN-SKEL [test_progs] kfree_skb.skel.h
  GEN-SKEL [test_progs] kfunc_call_destructive.skel.h
  GEN-SKEL [test_progs] kfunc_call_race.skel.h
  GEN-SKEL [test_progs] kfunc_call_test_subprog.skel.h
  GEN-SKEL [test_progs] kprobe_multi.skel.h
  GEN-SKEL [test_progs] kprobe_multi_empty.skel.h
  GEN-SKEL [test_progs] ksym_race.skel.h
  GEN-SKEL [test_progs] load_bytes_relative.skel.h
  GEN-SKEL [test_progs] local_storage.skel.h
  GEN-SKEL [test_progs] local_storage_bench.skel.h
  GEN-SKEL [test_progs] local_storage_rcu_tasks_trace_bench.skel.h
  GEN-SKEL [test_progs] loop1.skel.h
  GEN-SKEL [test_progs] loop2.skel.h
  GEN-SKEL [test_progs] loop3.skel.h
  GEN-SKEL [test_progs] loop4.skel.h
  GEN-SKEL [test_progs] loop5.skel.h
  GEN-SKEL [test_progs] loop6.skel.h
  GEN-SKEL [test_progs] lru_bug.skel.h
  GEN-SKEL [test_progs] lsm.skel.h
  GEN-SKEL [test_progs] lsm_cgroup.skel.h
  GEN-SKEL [test_progs] lsm_cgroup_nonvoid.skel.h
  GEN-SKEL [test_progs] map_kptr.skel.h
  GEN-SKEL [test_progs] map_kptr_fail.skel.h
  GEN-SKEL [test_progs] metadata_unused.skel.h
  GEN-SKEL [test_progs] metadata_used.skel.h
  GEN-SKEL [test_progs] modify_return.skel.h
  GEN-SKEL [test_progs] mptcp_sock.skel.h
  GEN-SKEL [test_progs] netcnt_prog.skel.h
  GEN-SKEL [test_progs] netif_receive_skb.skel.h
  GEN-SKEL [test_progs] netns_cookie_prog.skel.h
  GEN-SKEL [test_progs] perf_event_stackmap.skel.h
  GEN-SKEL [test_progs] perfbuf_bench.skel.h
  GEN-SKEL [test_progs] profiler1.skel.h
  GEN-SKEL [test_progs] profiler2.skel.h
  GEN-SKEL [test_progs] profiler3.skel.h
  GEN-SKEL [test_progs] pyperf100.skel.h
  GEN-SKEL [test_progs] pyperf180.skel.h
  GEN-SKEL [test_progs] pyperf50.skel.h
  GEN-SKEL [test_progs] pyperf600.skel.h
  GEN-SKEL [test_progs] pyperf600_bpf_loop.skel.h
  GEN-SKEL [test_progs] pyperf600_nounroll.skel.h
  GEN-SKEL [test_progs] pyperf_global.skel.h
  GEN-SKEL [test_progs] pyperf_subprogs.skel.h
  GEN-SKEL [test_progs] recursion.skel.h
  GEN-SKEL [test_progs] recvmsg4_prog.skel.h
  GEN-SKEL [test_progs] recvmsg6_prog.skel.h
  GEN-SKEL [test_progs] ringbuf_bench.skel.h
  GEN-SKEL [test_progs] sample_map_ret0.skel.h
  GEN-SKEL [test_progs] sample_ret0.skel.h
  GEN-SKEL [test_progs] sendmsg4_prog.skel.h
  GEN-SKEL [test_progs] sendmsg6_prog.skel.h
  GEN-SKEL [test_progs] skb_load_bytes.skel.h
  GEN-SKEL [test_progs] skb_pkt_end.skel.h
  GEN-SKEL [test_progs] socket_cookie_prog.skel.h
  GEN-SKEL [test_progs] sockmap_parse_prog.skel.h
  GEN-SKEL [test_progs] sockmap_tcp_msg_prog.skel.h
  GEN-SKEL [test_progs] sockmap_verdict_prog.skel.h
  GEN-SKEL [test_progs] sockopt_inherit.skel.h
  GEN-SKEL [test_progs] sockopt_multi.skel.h
  GEN-SKEL [test_progs] sockopt_qos_to_cc.skel.h
  GEN-SKEL [test_progs] sockopt_sk.skel.h
  GEN-SKEL [test_progs] stacktrace_map_skip.skel.h
  GEN-SKEL [test_progs] strncmp_bench.skel.h
  GEN-SKEL [test_progs] strncmp_test.skel.h
  GEN-SKEL [test_progs] strobemeta.skel.h
  GEN-SKEL [test_progs] strobemeta_bpf_loop.skel.h
  GEN-SKEL [test_progs] strobemeta_nounroll1.skel.h
  GEN-SKEL [test_progs] strobemeta_nounroll2.skel.h
  GEN-SKEL [test_progs] strobemeta_subprogs.skel.h
  GEN-SKEL [test_progs] syscall.skel.h
  GEN-SKEL [test_progs] tailcall1.skel.h
  GEN-SKEL [test_progs] tailcall2.skel.h
  GEN-SKEL [test_progs] tailcall3.skel.h
  GEN-SKEL [test_progs] tailcall4.skel.h
  GEN-SKEL [test_progs] tailcall5.skel.h
  GEN-SKEL [test_progs] tailcall6.skel.h
  GEN-SKEL [test_progs] tailcall_bpf2bpf1.skel.h
  GEN-SKEL [test_progs] tailcall_bpf2bpf2.skel.h
  GEN-SKEL [test_progs] tailcall_bpf2bpf3.skel.h
  GEN-SKEL [test_progs] tailcall_bpf2bpf4.skel.h
  GEN-SKEL [test_progs] tailcall_bpf2bpf6.skel.h
  GEN-SKEL [test_progs] task_local_storage.skel.h
  GEN-SKEL [test_progs] task_local_storage_exit_creds.skel.h
  GEN-SKEL [test_progs] task_ls_recursion.skel.h
  GEN-SKEL [test_progs] tcp_ca_incompl_cong_ops.skel.h
  GEN-SKEL [test_progs] tcp_ca_unsupp_cong_op.skel.h
  GEN-SKEL [test_progs] tcp_ca_write_sk_pacing.skel.h
  GEN-SKEL [test_progs] tcp_rtt.skel.h
  GEN-SKEL [test_progs] test_attach_probe.skel.h
  GEN-SKEL [test_progs] test_autoattach.skel.h
  GEN-SKEL [test_progs] test_autoload.skel.h
  GEN-SKEL [test_progs] test_bpf_cookie.skel.h
  GEN-SKEL [test_progs] test_bpf_nf.skel.h
  GEN-SKEL [test_progs] test_bpf_nf_fail.skel.h
  GEN-SKEL [test_progs] test_btf_decl_tag.skel.h
  GEN-SKEL [test_progs] test_btf_map_in_map.skel.h
  GEN-SKEL [test_progs] test_btf_newkv.skel.h
  GEN-SKEL [test_progs] test_btf_nokv.skel.h
  GEN-SKEL [test_progs] test_btf_skc_cls_ingress.skel.h
  GEN-SKEL [test_progs] test_cgroup_link.skel.h
  GEN-SKEL [test_progs] test_check_mtu.skel.h
  GEN-SKEL [test_progs] test_cls_redirect.skel.h
  GEN-SKEL [test_progs] test_cls_redirect_subprogs.skel.h
  GEN-SKEL [test_progs] test_core_autosize.skel.h
  GEN-SKEL [test_progs] test_core_extern.skel.h
  GEN-SKEL [test_progs] test_core_read_macros.skel.h
  GEN-SKEL [test_progs] test_core_reloc_arrays.skel.h
  GEN-SKEL [test_progs] test_core_reloc_bitfields_direct.skel.h
  GEN-SKEL [test_progs] test_core_reloc_bitfields_probed.skel.h
  GEN-SKEL [test_progs] test_core_reloc_enum64val.skel.h
  GEN-SKEL [test_progs] test_core_reloc_enumval.skel.h
  GEN-SKEL [test_progs] test_core_reloc_existence.skel.h
  GEN-SKEL [test_progs] test_core_reloc_flavors.skel.h
  GEN-SKEL [test_progs] test_core_reloc_ints.skel.h
  GEN-SKEL [test_progs] test_core_reloc_kernel.skel.h
  GEN-SKEL [test_progs] test_core_reloc_misc.skel.h
  GEN-SKEL [test_progs] test_core_reloc_mods.skel.h
  GEN-SKEL [test_progs] test_core_reloc_module.skel.h
  GEN-SKEL [test_progs] test_core_reloc_nesting.skel.h
  GEN-SKEL [test_progs] test_core_reloc_primitives.skel.h
  GEN-SKEL [test_progs] test_core_reloc_ptr_as_arr.skel.h
  GEN-SKEL [test_progs] test_core_reloc_size.skel.h
  GEN-SKEL [test_progs] test_core_reloc_type_based.skel.h
  GEN-SKEL [test_progs] test_core_reloc_type_id.skel.h
  GEN-SKEL [test_progs] test_core_retro.skel.h
  GEN-SKEL [test_progs] test_custom_sec_handlers.skel.h
  GEN-SKEL [test_progs] test_d_path.skel.h
  GEN-SKEL [test_progs] test_d_path_check_rdonly_mem.skel.h
  GEN-SKEL [test_progs] test_d_path_check_types.skel.h
  GEN-SKEL [test_progs] test_enable_stats.skel.h
  GEN-SKEL [test_progs] test_endian.skel.h
  GEN-SKEL [test_progs] test_get_stack_rawtp.skel.h
  GEN-SKEL [test_progs] test_get_stack_rawtp_err.skel.h
  GEN-SKEL [test_progs] test_global_data.skel.h
  GEN-SKEL [test_progs] test_global_func1.skel.h
  GEN-SKEL [test_progs] test_global_func10.skel.h
  GEN-SKEL [test_progs] test_global_func11.skel.h
  GEN-SKEL [test_progs] test_global_func12.skel.h
  GEN-SKEL [test_progs] test_global_func13.skel.h
  GEN-SKEL [test_progs] test_global_func14.skel.h
  GEN-SKEL [test_progs] test_global_func15.skel.h
  GEN-SKEL [test_progs] test_global_func16.skel.h
  GEN-SKEL [test_progs] test_global_func17.skel.h
  GEN-SKEL [test_progs] test_global_func2.skel.h
  GEN-SKEL [test_progs] test_global_func3.skel.h
  GEN-SKEL [test_progs] test_global_func4.skel.h
  GEN-SKEL [test_progs] test_global_func5.skel.h
  GEN-SKEL [test_progs] test_global_func6.skel.h
  GEN-SKEL [test_progs] test_global_func7.skel.h
  GEN-SKEL [test_progs] test_global_func8.skel.h
  GEN-SKEL [test_progs] test_global_func9.skel.h
  GEN-SKEL [test_progs] test_global_func_args.skel.h
  GEN-SKEL [test_progs] test_hash_large_key.skel.h
  GEN-SKEL [test_progs] test_helper_restricted.skel.h
  GEN-SKEL [test_progs] test_ksyms.skel.h
  GEN-SKEL [test_progs] test_ksyms_btf.skel.h
  GEN-SKEL [test_progs] test_ksyms_btf_null_check.skel.h
  GEN-SKEL [test_progs] test_ksyms_btf_write_check.skel.h
  GEN-SKEL [test_progs] test_ksyms_module.skel.h
  GEN-SKEL [test_progs] test_ksyms_weak.skel.h
  GEN-SKEL [test_progs] test_l4lb.skel.h
  GEN-SKEL [test_progs] test_l4lb_noinline.skel.h
  GEN-SKEL [test_progs] test_legacy_printk.skel.h
  GEN-SKEL [test_progs] test_link_pinning.skel.h
  GEN-SKEL [test_progs] test_lirc_mode2_kern.skel.h
  GEN-SKEL [test_progs] test_log_buf.skel.h
  GEN-SKEL [test_progs] test_log_fixup.skel.h
  GEN-SKEL [test_progs] test_lookup_and_delete.skel.h
  GEN-SKEL [test_progs] test_lwt_ip_encap.skel.h
  GEN-SKEL [test_progs] test_lwt_seg6local.skel.h
  GEN-SKEL [test_progs] test_map_in_map.skel.h
  GEN-SKEL [test_progs] test_map_in_map_invalid.skel.h
  GEN-SKEL [test_progs] test_map_init.skel.h
  GEN-SKEL [test_progs] test_map_lock.skel.h
  GEN-SKEL [test_progs] test_map_lookup_percpu_elem.skel.h
  GEN-SKEL [test_progs] test_migrate_reuseport.skel.h
  GEN-SKEL [test_progs] test_misc_tcp_hdr_options.skel.h
  GEN-SKEL [test_progs] test_mmap.skel.h
  GEN-SKEL [test_progs] test_module_attach.skel.h
  GEN-SKEL [test_progs] test_ns_current_pid_tgid.skel.h
  GEN-SKEL [test_progs] test_obj_id.skel.h
  GEN-SKEL [test_progs] test_overhead.skel.h
  GEN-SKEL [test_progs] test_pe_preserve_elems.skel.h
  GEN-SKEL [test_progs] test_perf_branches.skel.h
  GEN-SKEL [test_progs] test_perf_buffer.skel.h
  GEN-SKEL [test_progs] test_perf_link.skel.h
  GEN-SKEL [test_progs] test_pinning.skel.h
  GEN-SKEL [test_progs] test_pkt_access.skel.h
  GEN-SKEL [test_progs] test_pkt_md_access.skel.h
  GEN-SKEL [test_progs] test_probe_read_user_str.skel.h
  GEN-SKEL [test_progs] test_probe_user.skel.h
  GEN-SKEL [test_progs] test_prog_array_init.skel.h
  GEN-SKEL [test_progs] test_queue_map.skel.h
  GEN-SKEL [test_progs] test_raw_tp_test_run.skel.h
  GEN-SKEL [test_progs] test_rdonly_maps.skel.h
  GEN-SKEL [test_progs] test_ringbuf_multi.skel.h
  GEN-SKEL [test_progs] test_seg6_loop.skel.h
  GEN-SKEL [test_progs] test_select_reuseport_kern.skel.h
  GEN-SKEL [test_progs] test_send_signal_kern.skel.h
  GEN-SKEL [test_progs] test_sk_lookup.skel.h
  GEN-SKEL [test_progs] test_sk_lookup_kern.skel.h
  GEN-SKEL [test_progs] test_sk_storage_trace_itself.skel.h
  GEN-SKEL [test_progs] test_sk_storage_tracing.skel.h
  GEN-SKEL [test_progs] test_skb_cgroup_id_kern.skel.h
  GEN-SKEL [test_progs] test_skb_ctx.skel.h
  GEN-SKEL [test_progs] test_skb_helpers.skel.h
  GEN-SKEL [test_progs] test_skc_to_unix_sock.skel.h
  GEN-SKEL [test_progs] test_skeleton.skel.h
  GEN-SKEL [test_progs] test_skmsg_load_helpers.skel.h
  GEN-SKEL [test_progs] test_snprintf.skel.h
  GEN-SKEL [test_progs] test_snprintf_single.skel.h
  GEN-SKEL [test_progs] test_sock_fields.skel.h
  GEN-SKEL [test_progs] test_sockhash_kern.skel.h
  GEN-SKEL [test_progs] test_sockmap_invalid_update.skel.h
  GEN-SKEL [test_progs] test_sockmap_kern.skel.h
  GEN-SKEL [test_progs] test_sockmap_listen.skel.h
  GEN-SKEL [test_progs] test_sockmap_progs_query.skel.h
  GEN-SKEL [test_progs] test_sockmap_skb_verdict_attach.skel.h
  GEN-SKEL [test_progs] test_sockmap_update.skel.h
  GEN-SKEL [test_progs] test_spin_lock.skel.h
  GEN-SKEL [test_progs] test_stack_map.skel.h
  GEN-SKEL [test_progs] test_stack_var_off.skel.h
  GEN-SKEL [test_progs] test_stacktrace_build_id.skel.h
  GEN-SKEL [test_progs] test_stacktrace_map.skel.h
  GEN-SKEL [test_progs] test_subprogs.skel.h
  GEN-SKEL [test_progs] test_subprogs_unused.skel.h
  GEN-SKEL [test_progs] test_sysctl_loop1.skel.h
  GEN-SKEL [test_progs] test_sysctl_loop2.skel.h
  GEN-SKEL [test_progs] test_sysctl_prog.skel.h
  GEN-SKEL [test_progs] test_task_pt_regs.skel.h
  GEN-SKEL [test_progs] test_tc_bpf.skel.h
  GEN-SKEL [test_progs] test_tc_dtime.skel.h
  GEN-SKEL [test_progs] test_tc_edt.skel.h
  GEN-SKEL [test_progs] test_tc_neigh.skel.h
  GEN-SKEL [test_progs] test_tc_neigh_fib.skel.h
  GEN-SKEL [test_progs] test_tc_peer.skel.h
  GEN-SKEL [test_progs] test_tc_tunnel.skel.h
  GEN-SKEL [test_progs] test_tcp_check_syncookie_kern.skel.h
  GEN-SKEL [test_progs] test_tcp_estats.skel.h
  GEN-SKEL [test_progs] test_tcp_hdr_options.skel.h
  GEN-SKEL [test_progs] test_tcpbpf_kern.skel.h
  GEN-SKEL [test_progs] test_tcpnotify_kern.skel.h
  GEN-SKEL [test_progs] test_time_tai.skel.h
  GEN-SKEL [test_progs] test_trace_ext.skel.h
  GEN-SKEL [test_progs] test_trace_ext_tracing.skel.h
  GEN-SKEL [test_progs] test_tracepoint.skel.h
  GEN-SKEL [test_progs] test_trampoline_count.skel.h
  GEN-SKEL [test_progs] test_tunnel_kern.skel.h
  GEN-SKEL [test_progs] test_unpriv_bpf_disabled.skel.h
  GEN-SKEL [test_progs] test_uprobe_autoattach.skel.h
  GEN-SKEL [test_progs] test_urandom_usdt.skel.h
  GEN-SKEL [test_progs] test_varlen.skel.h
  GEN-SKEL [test_progs] test_verif_scale1.skel.h
  GEN-SKEL [test_progs] test_verif_scale2.skel.h
  GEN-SKEL [test_progs] test_verif_scale3.skel.h
  GEN-SKEL [test_progs] test_vmlinux.skel.h
  GEN-SKEL [test_progs] test_xdp.skel.h
  GEN-SKEL [test_progs] test_xdp_adjust_tail_grow.skel.h
  GEN-SKEL [test_progs] test_xdp_adjust_tail_shrink.skel.h
  GEN-SKEL [test_progs] test_xdp_bpf2bpf.skel.h
  GEN-SKEL [test_progs] test_xdp_context_test_run.skel.h
  GEN-SKEL [test_progs] test_xdp_devmap_helpers.skel.h
  GEN-SKEL [test_progs] test_xdp_do_redirect.skel.h
  GEN-SKEL [test_progs] test_xdp_link.skel.h
  GEN-SKEL [test_progs] test_xdp_loop.skel.h
  GEN-SKEL [test_progs] test_xdp_meta.skel.h
  GEN-SKEL [test_progs] test_xdp_noinline.skel.h
  GEN-SKEL [test_progs] test_xdp_redirect.skel.h
  GEN-SKEL [test_progs] test_xdp_update_frags.skel.h
  GEN-SKEL [test_progs] test_xdp_vlan.skel.h
  GEN-SKEL [test_progs] test_xdp_with_cpumap_frags_helpers.skel.h
  GEN-SKEL [test_progs] test_xdp_with_cpumap_helpers.skel.h
  GEN-SKEL [test_progs] test_xdp_with_devmap_frags_helpers.skel.h
  GEN-SKEL [test_progs] test_xdp_with_devmap_helpers.skel.h
  GEN-SKEL [test_progs] timer.skel.h
  GEN-SKEL [test_progs] timer_crash.skel.h
  GEN-SKEL [test_progs] timer_mim.skel.h
  GEN-SKEL [test_progs] timer_mim_reject.skel.h
  GEN-SKEL [test_progs] trace_dummy_st_ops.skel.h
  GEN-SKEL [test_progs] trigger_bench.skel.h
  GEN-SKEL [test_progs] twfw.skel.h
  GEN-SKEL [test_progs] udp_limit.skel.h
  GEN-SKEL [test_progs] xdp_dummy.skel.h
  GEN-SKEL [test_progs] xdp_redirect_map.skel.h
  GEN-SKEL [test_progs] xdp_redirect_multi_kern.skel.h
  GEN-SKEL [test_progs] xdp_synproxy_kern.skel.h
  GEN-SKEL [test_progs] xdp_tx.skel.h
  GEN-SKEL [test_progs] xdping_kern.skel.h
  GEN-SKEL [test_progs] xdpwall.skel.h
  GEN-SKEL [test_progs] kfunc_call_test.lskel.h
  GEN-SKEL [test_progs] fentry_test.lskel.h
  GEN-SKEL [test_progs] fexit_test.lskel.h
  GEN-SKEL [test_progs] fexit_sleep.lskel.h
  GEN-SKEL [test_progs] test_ringbuf.lskel.h
  GEN-SKEL [test_progs] atomics.lskel.h
  GEN-SKEL [test_progs] trace_printk.lskel.h
  GEN-SKEL [test_progs] trace_vprintk.lskel.h
  GEN-SKEL [test_progs] map_ptr_kern.lskel.h
  GEN-SKEL [test_progs] core_kern.lskel.h
  GEN-SKEL [test_progs] core_kern_overflow.lskel.h
  GEN-SKEL [test_progs] test_ksyms_module.lskel.h
  GEN-SKEL [test_progs] test_ksyms_weak.lskel.h
  GEN-SKEL [test_progs] kfunc_call_test_subprog.lskel.h
  LINK-BPF [test_progs] test_static_linked.o
  GEN-SKEL [test_progs] test_static_linked.skel.h
  LINK-BPF [test_progs] linked_funcs.o
  GEN-SKEL [test_progs] linked_funcs.skel.h
  LINK-BPF [test_progs] linked_vars.o
  GEN-SKEL [test_progs] linked_vars.skel.h
  LINK-BPF [test_progs] linked_maps.o
  GEN-SKEL [test_progs] linked_maps.skel.h
  LINK-BPF [test_progs] test_subskeleton.o
  GEN-SKEL [test_progs] test_subskeleton.skel.h
  LINK-BPF [test_progs] test_subskeleton_lib.o
  GEN-SKEL [test_progs] test_subskeleton_lib.skel.h
  LINK-BPF [test_progs] test_usdt.o
  GEN-SKEL [test_progs] test_usdt.skel.h
  TEST-OBJ [test_maps] array_map_batch_ops.test.o
  TEST-OBJ [test_maps] htab_map_batch_ops.test.o
  TEST-OBJ [test_maps] lpm_trie_map_batch_ops.test.o
  TEST-OBJ [test_maps] map_in_map_batch_ops.test.o
  TEST-OBJ [test_maps] sk_storage_map.test.o
  TEST-HDR [test_maps] tests.h
  EXT-OBJ  [test_maps] test_maps.o
  MKDIR    resolve_btfids
  HOSTCC  /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/fixdep.o
  HOSTLD  /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/fixdep-in.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/fixdep
  MKDIR     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762ce=
fd3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolv=
e_btfids//libsubcmd
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/libsubcmd/exec-cmd.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/libsubcmd/help.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/libsubcmd/pager.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/libsubcmd/parse-options.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/libsubcmd/run-command.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/libsubcmd/sigchain.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/libsubcmd/subcmd-config.o
  LD      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/libsubcmd/libsubcmd-in.o
  AR      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/libsubcmd/libsubcmd.a
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/main.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/rbtree.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/zalloc.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/string.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/ctype.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/str_error_r.o
  LD      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/resolve_=
btfids/resolve_btfids-in.o
  LINK     resolve_btfids
  BINARY   test_maps
  BINARY   test_lru_map
  BINARY   test_lpm_map
  TEST-OBJ [test_progs] align.test.o
  TEST-OBJ [test_progs] arg_parsing.test.o
  TEST-OBJ [test_progs] atomic_bounds.test.o
  TEST-OBJ [test_progs] atomics.test.o
  TEST-OBJ [test_progs] attach_probe.test.o
  TEST-OBJ [test_progs] autoattach.test.o
  TEST-OBJ [test_progs] autoload.test.o
  TEST-OBJ [test_progs] bind_perm.test.o
  TEST-OBJ [test_progs] bloom_filter_map.test.o
  TEST-OBJ [test_progs] bpf_cookie.test.o
  TEST-OBJ [test_progs] bpf_iter.test.o
  TEST-OBJ [test_progs] bpf_iter_setsockopt.test.o
  TEST-OBJ [test_progs] bpf_iter_setsockopt_unix.test.o
  TEST-OBJ [test_progs] bpf_loop.test.o
  TEST-OBJ [test_progs] bpf_mod_race.test.o
  TEST-OBJ [test_progs] bpf_nf.test.o
  TEST-OBJ [test_progs] bpf_obj_id.test.o
  TEST-OBJ [test_progs] bpf_tcp_ca.test.o
  TEST-OBJ [test_progs] bpf_verif_scale.test.o
  TEST-OBJ [test_progs] btf.test.o
  TEST-OBJ [test_progs] btf_dedup_split.test.o
  TEST-OBJ [test_progs] btf_dump.test.o
  TEST-OBJ [test_progs] btf_endian.test.o
  TEST-OBJ [test_progs] btf_map_in_map.test.o
  TEST-OBJ [test_progs] btf_module.test.o
  TEST-OBJ [test_progs] btf_skc_cls_ingress.test.o
  TEST-OBJ [test_progs] btf_split.test.o
  TEST-OBJ [test_progs] btf_tag.test.o
  TEST-OBJ [test_progs] btf_write.test.o
  TEST-OBJ [test_progs] cg_storage_multi.test.o
  TEST-OBJ [test_progs] cgroup_attach_autodetach.test.o
  TEST-OBJ [test_progs] cgroup_attach_multi.test.o
  TEST-OBJ [test_progs] cgroup_attach_override.test.o
  TEST-OBJ [test_progs] cgroup_getset_retval.test.o
  TEST-OBJ [test_progs] cgroup_link.test.o
  TEST-OBJ [test_progs] cgroup_skb_sk_lookup.test.o
  TEST-OBJ [test_progs] cgroup_v1v2.test.o
  TEST-OBJ [test_progs] check_mtu.test.o
  TEST-OBJ [test_progs] cls_redirect.test.o
  TEST-OBJ [test_progs] connect_force_port.test.o
  TEST-OBJ [test_progs] core_autosize.test.o
  TEST-OBJ [test_progs] core_extern.test.o
  TEST-OBJ [test_progs] core_kern.test.o
  TEST-OBJ [test_progs] core_kern_overflow.test.o
  TEST-OBJ [test_progs] core_read_macros.test.o
  TEST-OBJ [test_progs] core_reloc.test.o
  TEST-OBJ [test_progs] core_retro.test.o
  TEST-OBJ [test_progs] cpu_mask.test.o
  TEST-OBJ [test_progs] custom_sec_handlers.test.o
  TEST-OBJ [test_progs] d_path.test.o
  TEST-OBJ [test_progs] dummy_st_ops.test.o
  TEST-OBJ [test_progs] dynptr.test.o
  TEST-OBJ [test_progs] enable_stats.test.o
  TEST-OBJ [test_progs] endian.test.o
  TEST-OBJ [test_progs] exhandler.test.o
  TEST-OBJ [test_progs] fentry_fexit.test.o
  TEST-OBJ [test_progs] fentry_test.test.o
  TEST-OBJ [test_progs] fexit_bpf2bpf.test.o
  TEST-OBJ [test_progs] fexit_sleep.test.o
  TEST-OBJ [test_progs] fexit_stress.test.o
  TEST-OBJ [test_progs] fexit_test.test.o
  TEST-OBJ [test_progs] find_vma.test.o
  TEST-OBJ [test_progs] flow_dissector.test.o
  TEST-OBJ [test_progs] flow_dissector_load_bytes.test.o
  TEST-OBJ [test_progs] flow_dissector_reattach.test.o
  TEST-OBJ [test_progs] for_each.test.o
  TEST-OBJ [test_progs] get_branch_snapshot.test.o
  TEST-OBJ [test_progs] get_func_args_test.test.o
  TEST-OBJ [test_progs] get_func_ip_test.test.o
  TEST-OBJ [test_progs] get_stack_raw_tp.test.o
  TEST-OBJ [test_progs] get_stackid_cannot_attach.test.o
  TEST-OBJ [test_progs] global_data.test.o
  TEST-OBJ [test_progs] global_data_init.test.o
  TEST-OBJ [test_progs] global_func_args.test.o
  TEST-OBJ [test_progs] hash_large_key.test.o
  TEST-OBJ [test_progs] hashmap.test.o
  TEST-OBJ [test_progs] helper_restricted.test.o
  TEST-OBJ [test_progs] kfree_skb.test.o
  TEST-OBJ [test_progs] kfunc_call.test.o
  TEST-OBJ [test_progs] kprobe_multi_test.test.o
  TEST-OBJ [test_progs] ksyms.test.o
  TEST-OBJ [test_progs] ksyms_btf.test.o
  TEST-OBJ [test_progs] ksyms_module.test.o
  TEST-OBJ [test_progs] l4lb_all.test.o
  TEST-OBJ [test_progs] legacy_printk.test.o
  TEST-OBJ [test_progs] libbpf_probes.test.o
  TEST-OBJ [test_progs] libbpf_str.test.o
  TEST-OBJ [test_progs] link_pinning.test.o
  TEST-OBJ [test_progs] linked_funcs.test.o
  TEST-OBJ [test_progs] linked_maps.test.o
  TEST-OBJ [test_progs] linked_vars.test.o
  TEST-OBJ [test_progs] load_bytes_relative.test.o
  TEST-OBJ [test_progs] log_buf.test.o
  TEST-OBJ [test_progs] log_fixup.test.o
  TEST-OBJ [test_progs] lookup_and_delete.test.o
  TEST-OBJ [test_progs] lru_bug.test.o
  TEST-OBJ [test_progs] lsm_cgroup.test.o
  TEST-OBJ [test_progs] map_init.test.o
  TEST-OBJ [test_progs] map_kptr.test.o
  TEST-OBJ [test_progs] map_lock.test.o
  TEST-OBJ [test_progs] map_lookup_percpu_elem.test.o
  TEST-OBJ [test_progs] map_ptr.test.o
  TEST-OBJ [test_progs] metadata.test.o
  TEST-OBJ [test_progs] migrate_reuseport.test.o
  TEST-OBJ [test_progs] mmap.test.o
  TEST-OBJ [test_progs] modify_return.test.o
  TEST-OBJ [test_progs] module_attach.test.o
  TEST-OBJ [test_progs] mptcp.test.o
  TEST-OBJ [test_progs] netcnt.test.o
  TEST-OBJ [test_progs] netns_cookie.test.o
  TEST-OBJ [test_progs] ns_current_pid_tgid.test.o
  TEST-OBJ [test_progs] obj_name.test.o
  TEST-OBJ [test_progs] pe_preserve_elems.test.o
  TEST-OBJ [test_progs] perf_branches.test.o
  TEST-OBJ [test_progs] perf_buffer.test.o
  TEST-OBJ [test_progs] perf_event_stackmap.test.o
  TEST-OBJ [test_progs] perf_link.test.o
  TEST-OBJ [test_progs] pinning.test.o
  TEST-OBJ [test_progs] pkt_access.test.o
  TEST-OBJ [test_progs] pkt_md_access.test.o
  TEST-OBJ [test_progs] probe_read_user_str.test.o
  TEST-OBJ [test_progs] probe_user.test.o
  TEST-OBJ [test_progs] prog_array_init.test.o
  TEST-OBJ [test_progs] prog_run_opts.test.o
  TEST-OBJ [test_progs] prog_tests_framework.test.o
  TEST-OBJ [test_progs] queue_stack_map.test.o
  TEST-OBJ [test_progs] raw_tp_test_run.test.o
  TEST-OBJ [test_progs] raw_tp_writable_reject_nbd_invalid.test.o
  TEST-OBJ [test_progs] raw_tp_writable_test_run.test.o
  TEST-OBJ [test_progs] rdonly_maps.test.o
  TEST-OBJ [test_progs] recursion.test.o
  TEST-OBJ [test_progs] reference_tracking.test.o
  TEST-OBJ [test_progs] resolve_btfids.test.o
  TEST-OBJ [test_progs] ringbuf.test.o
  TEST-OBJ [test_progs] ringbuf_multi.test.o
  TEST-OBJ [test_progs] section_names.test.o
  TEST-OBJ [test_progs] select_reuseport.test.o
  TEST-OBJ [test_progs] send_signal.test.o
  TEST-OBJ [test_progs] send_signal_sched_switch.test.o
  TEST-OBJ [test_progs] signal_pending.test.o
  TEST-OBJ [test_progs] sk_assign.test.o
  TEST-OBJ [test_progs] sk_lookup.test.o
  TEST-OBJ [test_progs] sk_storage_tracing.test.o
  TEST-OBJ [test_progs] skb_ctx.test.o
  TEST-OBJ [test_progs] skb_helpers.test.o
  TEST-OBJ [test_progs] skb_load_bytes.test.o
  TEST-OBJ [test_progs] skc_to_unix_sock.test.o
  TEST-OBJ [test_progs] skeleton.test.o
  TEST-OBJ [test_progs] snprintf.test.o
  TEST-OBJ [test_progs] snprintf_btf.test.o
  TEST-OBJ [test_progs] sock_fields.test.o
  TEST-OBJ [test_progs] socket_cookie.test.o
  TEST-OBJ [test_progs] sockmap_basic.test.o
  TEST-OBJ [test_progs] sockmap_ktls.test.o
  TEST-OBJ [test_progs] sockmap_listen.test.o
  TEST-OBJ [test_progs] sockopt.test.o
  TEST-OBJ [test_progs] sockopt_inherit.test.o
  TEST-OBJ [test_progs] sockopt_multi.test.o
  TEST-OBJ [test_progs] sockopt_qos_to_cc.test.o
  TEST-OBJ [test_progs] sockopt_sk.test.o
  TEST-OBJ [test_progs] spinlock.test.o
  TEST-OBJ [test_progs] stack_var_off.test.o
  TEST-OBJ [test_progs] stacktrace_build_id.test.o
  TEST-OBJ [test_progs] stacktrace_build_id_nmi.test.o
  TEST-OBJ [test_progs] stacktrace_map.test.o
  TEST-OBJ [test_progs] stacktrace_map_raw_tp.test.o
  TEST-OBJ [test_progs] stacktrace_map_skip.test.o
  TEST-OBJ [test_progs] static_linked.test.o
  TEST-OBJ [test_progs] subprogs.test.o
  TEST-OBJ [test_progs] subskeleton.test.o
  TEST-OBJ [test_progs] syscall.test.o
  TEST-OBJ [test_progs] tailcalls.test.o
  TEST-OBJ [test_progs] task_fd_query_rawtp.test.o
  TEST-OBJ [test_progs] task_fd_query_tp.test.o
  TEST-OBJ [test_progs] task_local_storage.test.o
  TEST-OBJ [test_progs] task_pt_regs.test.o
  TEST-OBJ [test_progs] tc_bpf.test.o
  TEST-OBJ [test_progs] tc_redirect.test.o
  TEST-OBJ [test_progs] tcp_estats.test.o
  TEST-OBJ [test_progs] tcp_hdr_options.test.o
  TEST-OBJ [test_progs] tcp_rtt.test.o
  TEST-OBJ [test_progs] tcpbpf_user.test.o
  TEST-OBJ [test_progs] test_bpf_syscall_macro.test.o
  TEST-OBJ [test_progs] test_bpffs.test.o
  TEST-OBJ [test_progs] test_bprm_opts.test.o
  TEST-OBJ [test_progs] test_global_funcs.test.o
  TEST-OBJ [test_progs] test_ima.test.o
  TEST-OBJ [test_progs] test_local_storage.test.o
  TEST-OBJ [test_progs] test_lsm.test.o
  TEST-OBJ [test_progs] test_overhead.test.o
  TEST-OBJ [test_progs] test_profiler.test.o
  TEST-OBJ [test_progs] test_skb_pkt_end.test.o
  TEST-OBJ [test_progs] test_strncmp.test.o
  TEST-OBJ [test_progs] test_tunnel.test.o
  TEST-OBJ [test_progs] time_tai.test.o
  TEST-OBJ [test_progs] timer.test.o
  TEST-OBJ [test_progs] timer_crash.test.o
  TEST-OBJ [test_progs] timer_mim.test.o
  TEST-OBJ [test_progs] tp_attach_query.test.o
  TEST-OBJ [test_progs] trace_ext.test.o
  TEST-OBJ [test_progs] trace_printk.test.o
  TEST-OBJ [test_progs] trace_vprintk.test.o
  TEST-OBJ [test_progs] trampoline_count.test.o
  TEST-OBJ [test_progs] udp_limit.test.o
  TEST-OBJ [test_progs] unpriv_bpf_disabled.test.o
  TEST-OBJ [test_progs] uprobe_autoattach.test.o
  TEST-OBJ [test_progs] usdt.test.o
  TEST-OBJ [test_progs] varlen.test.o
  TEST-OBJ [test_progs] verif_stats.test.o
  TEST-OBJ [test_progs] vmlinux.test.o
  TEST-OBJ [test_progs] xdp.test.o
  TEST-OBJ [test_progs] xdp_adjust_frags.test.o
  TEST-OBJ [test_progs] xdp_adjust_tail.test.o
  TEST-OBJ [test_progs] xdp_attach.test.o
  TEST-OBJ [test_progs] xdp_bonding.test.o
  TEST-OBJ [test_progs] xdp_bpf2bpf.test.o
  TEST-OBJ [test_progs] xdp_context_test_run.test.o
  TEST-OBJ [test_progs] xdp_cpumap_attach.test.o
  TEST-OBJ [test_progs] xdp_devmap_attach.test.o
  TEST-OBJ [test_progs] xdp_do_redirect.test.o
  TEST-OBJ [test_progs] xdp_info.test.o
  TEST-OBJ [test_progs] xdp_link.test.o
  TEST-OBJ [test_progs] xdp_noinline.test.o
  TEST-OBJ [test_progs] xdp_perf.test.o
  TEST-OBJ [test_progs] xdp_synproxy.test.o
  TEST-OBJ [test_progs] xdpwall.test.o
  EXT-OBJ  [test_progs] test_progs.o
  EXT-OBJ  [test_progs] cgroup_helpers.o
  EXT-OBJ  [test_progs] trace_helpers.o
  EXT-OBJ  [test_progs] network_helpers.o
  EXT-OBJ  [test_progs] btf_helpers.o
  LIB      liburandom_read.so
  BINARY   urandom_read
  MOD      bpf_testmod.ko
warning: the compiler differs from the one used to build the kernel
  The kernel was built by: gcc-11 (Debian 11.3.0-5) 11.3.0
  You are using:           gcc (Debian 12.2.0-3) 12.2.0
  CC [M]  /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bpf_testmod/bpf_test=
mod.o
  MODPOST /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bpf_testmod/Module.s=
ymvers
  CC [M]  /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bpf_testmod/bpf_test=
mod.mod.o
  LD [M]  /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bpf_testmod/bpf_test=
mod.ko
  BTF [M] /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bpf_testmod/bpf_test=
mod.ko
Skipping BTF generation for /usr/src/perf_selftests-x86_64-rhel-8.3-kselfte=
sts-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bp=
f_testmod/bpf_testmod.ko due to unavailability of vmlinux
  BINARY   xdp_synproxy
  BINARY   test_progs
  BINARY   test_verifier_log
  BINARY   test_dev_cgroup
  BINARY   test_sock
  BINARY   test_sockmap
  BINARY   get_cgroup_id_user
  BINARY   test_cgroup_storage
  BINARY   test_tcpnotify_user
  BINARY   test_sysctl
  MKDIR    no_alu32
  CLNG-BPF [test_maps] atomic_bounds.o
  CLNG-BPF [test_maps] atomics.o
  CLNG-BPF [test_maps] bind4_prog.o
  CLNG-BPF [test_maps] bind6_prog.o
  CLNG-BPF [test_maps] bind_perm.o
  CLNG-BPF [test_maps] bloom_filter_bench.o
  CLNG-BPF [test_maps] bloom_filter_map.o
  CLNG-BPF [test_maps] bpf_cubic.o
  CLNG-BPF [test_maps] bpf_dctcp.o
  CLNG-BPF [test_maps] bpf_dctcp_release.o
  CLNG-BPF [test_maps] bpf_flow.o
  CLNG-BPF [test_maps] bpf_hashmap_full_update_bench.o
  CLNG-BPF [test_maps] bpf_iter_bpf_array_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_hash_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_link.o
  CLNG-BPF [test_maps] bpf_iter_bpf_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_percpu_array_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_percpu_hash_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_sk_storage_helpers.o
  CLNG-BPF [test_maps] bpf_iter_bpf_sk_storage_map.o
  CLNG-BPF [test_maps] bpf_iter_ipv6_route.o
  CLNG-BPF [test_maps] bpf_iter_ksym.o
  CLNG-BPF [test_maps] bpf_iter_netlink.o
  CLNG-BPF [test_maps] bpf_iter_setsockopt.o
  CLNG-BPF [test_maps] bpf_iter_setsockopt_unix.o
  CLNG-BPF [test_maps] bpf_iter_sockmap.o
  CLNG-BPF [test_maps] bpf_iter_task.o
  CLNG-BPF [test_maps] bpf_iter_task_btf.o
  CLNG-BPF [test_maps] bpf_iter_task_file.o
  CLNG-BPF [test_maps] bpf_iter_task_stack.o
  CLNG-BPF [test_maps] bpf_iter_task_vma.o
  CLNG-BPF [test_maps] bpf_iter_tcp4.o
  CLNG-BPF [test_maps] bpf_iter_tcp6.o
  CLNG-BPF [test_maps] bpf_iter_test_kern1.o
  CLNG-BPF [test_maps] bpf_iter_test_kern2.o
  CLNG-BPF [test_maps] bpf_iter_test_kern3.o
  CLNG-BPF [test_maps] bpf_iter_test_kern4.o
  CLNG-BPF [test_maps] bpf_iter_test_kern5.o
  CLNG-BPF [test_maps] bpf_iter_test_kern6.o
  CLNG-BPF [test_maps] bpf_iter_udp4.o
  CLNG-BPF [test_maps] bpf_iter_udp6.o
  CLNG-BPF [test_maps] bpf_iter_unix.o
  CLNG-BPF [test_maps] bpf_loop.o
  CLNG-BPF [test_maps] bpf_loop_bench.o
  CLNG-BPF [test_maps] bpf_mod_race.o
  CLNG-BPF [test_maps] bpf_syscall_macro.o
  CLNG-BPF [test_maps] bpf_tcp_nogpl.o
  CLNG-BPF [test_maps] bprm_opts.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___diff_arr_dim.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___diff_arr_val_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___equiv_zero_sz_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_bad_zero_sz_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_non_array.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_too_shallow.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_too_small.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_wrong_val_type.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___fixed_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___bit_sz_change.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___bitfield_vs_int.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___err_too_big_bitfield.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___just_big_enough.o
  CLNG-BPF [test_maps] btf__core_reloc_enum64val.o
  CLNG-BPF [test_maps] btf__core_reloc_enum64val___diff.o
  CLNG-BPF [test_maps] btf__core_reloc_enum64val___err_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_enum64val___val3_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval___diff.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval___err_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval___val3_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_existence.o
  CLNG-BPF [test_maps] btf__core_reloc_existence___minimal.o
  CLNG-BPF [test_maps] btf__core_reloc_existence___wrong_field_defs.o
  CLNG-BPF [test_maps] btf__core_reloc_flavors.o
  CLNG-BPF [test_maps] btf__core_reloc_flavors__err_wrong_name.o
  CLNG-BPF [test_maps] btf__core_reloc_ints.o
  CLNG-BPF [test_maps] btf__core_reloc_ints___bool.o
  CLNG-BPF [test_maps] btf__core_reloc_ints___reverse_sign.o
  CLNG-BPF [test_maps] btf__core_reloc_misc.o
  CLNG-BPF [test_maps] btf__core_reloc_mods.o
  CLNG-BPF [test_maps] btf__core_reloc_mods___mod_swap.o
  CLNG-BPF [test_maps] btf__core_reloc_mods___typedefs.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___anon_embed.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___dup_compat_types.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_array_container.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_array_field.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_dup_incompat_types.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_missing_container.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_missing_field.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_nonstruct_container.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_partial_match_dups.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_too_deep.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___extra_nesting.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___struct_union_mixup.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___diff_enum_def.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___diff_func_proto.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___diff_ptr_type.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___err_non_enum.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___err_non_int.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___err_non_ptr.o
  CLNG-BPF [test_maps] btf__core_reloc_ptr_as_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_ptr_as_arr___diff_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_size.o
  CLNG-BPF [test_maps] btf__core_reloc_size___diff_offs.o
  CLNG-BPF [test_maps] btf__core_reloc_size___diff_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_size___err_ambiguous.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___all_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___diff.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___diff_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___fn_wrong_args.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___incompat.o
  CLNG-BPF [test_maps] btf__core_reloc_type_id.o
  CLNG-BPF [test_maps] btf__core_reloc_type_id___missing_targets.o
  CLNG-BPF [test_maps] btf_data.o
  CLNG-BPF [test_maps] btf_dump_test_case_bitfields.o
  CLNG-BPF [test_maps] btf_dump_test_case_multidim.o
  CLNG-BPF [test_maps] btf_dump_test_case_namespacing.o
  CLNG-BPF [test_maps] btf_dump_test_case_ordering.o
  CLNG-BPF [test_maps] btf_dump_test_case_packing.o
  CLNG-BPF [test_maps] btf_dump_test_case_padding.o
  CLNG-BPF [test_maps] btf_dump_test_case_syntax.o
  CLNG-BPF [test_maps] btf_type_tag.o
  CLNG-BPF [test_maps] btf_type_tag_percpu.o
  CLNG-BPF [test_maps] btf_type_tag_user.o
  CLNG-BPF [test_maps] cg_storage_multi_egress_only.o
  CLNG-BPF [test_maps] cg_storage_multi_isolated.o
  CLNG-BPF [test_maps] cg_storage_multi_shared.o
  CLNG-BPF [test_maps] cgroup_getset_retval_getsockopt.o
  CLNG-BPF [test_maps] cgroup_getset_retval_setsockopt.o
  CLNG-BPF [test_maps] cgroup_skb_sk_lookup_kern.o
  CLNG-BPF [test_maps] connect4_dropper.o
  CLNG-BPF [test_maps] connect4_prog.o
  CLNG-BPF [test_maps] connect6_prog.o
  CLNG-BPF [test_maps] connect_force_port4.o
  CLNG-BPF [test_maps] connect_force_port6.o
  CLNG-BPF [test_maps] core_kern.o
  CLNG-BPF [test_maps] core_kern_overflow.o
  CLNG-BPF [test_maps] dev_cgroup.o
  CLNG-BPF [test_maps] dummy_st_ops.o
  CLNG-BPF [test_maps] dynptr_fail.o
  CLNG-BPF [test_maps] dynptr_success.o
  CLNG-BPF [test_maps] exhandler_kern.o
  CLNG-BPF [test_maps] fentry_test.o
  CLNG-BPF [test_maps] fexit_bpf2bpf.o
  CLNG-BPF [test_maps] fexit_bpf2bpf_simple.o
  CLNG-BPF [test_maps] fexit_sleep.o
  CLNG-BPF [test_maps] fexit_test.o
  CLNG-BPF [test_maps] find_vma.o
  CLNG-BPF [test_maps] find_vma_fail1.o
  CLNG-BPF [test_maps] find_vma_fail2.o
  CLNG-BPF [test_maps] fmod_ret_freplace.o
  CLNG-BPF [test_maps] for_each_array_map_elem.o
  CLNG-BPF [test_maps] for_each_hash_map_elem.o
  CLNG-BPF [test_maps] for_each_map_elem_write_key.o
  CLNG-BPF [test_maps] freplace_attach_probe.o
  CLNG-BPF [test_maps] freplace_cls_redirect.o
  CLNG-BPF [test_maps] freplace_connect4.o
  CLNG-BPF [test_maps] freplace_connect_v4_prog.o
  CLNG-BPF [test_maps] freplace_get_constant.o
  CLNG-BPF [test_maps] freplace_global_func.o
  CLNG-BPF [test_maps] get_branch_snapshot.o
  CLNG-BPF [test_maps] get_cgroup_id_kern.o
  CLNG-BPF [test_maps] get_func_args_test.o
  CLNG-BPF [test_maps] get_func_ip_test.o
  CLNG-BPF [test_maps] ima.o
  CLNG-BPF [test_maps] kfree_skb.o
  CLNG-BPF [test_maps] kfunc_call_destructive.o
  CLNG-BPF [test_maps] kfunc_call_race.o
  CLNG-BPF [test_maps] kfunc_call_test.o
  CLNG-BPF [test_maps] kfunc_call_test_subprog.o
  CLNG-BPF [test_maps] kprobe_multi.o
  CLNG-BPF [test_maps] kprobe_multi_empty.o
  CLNG-BPF [test_maps] ksym_race.o
  CLNG-BPF [test_maps] linked_funcs1.o
  CLNG-BPF [test_maps] linked_funcs2.o
  CLNG-BPF [test_maps] linked_maps1.o
  CLNG-BPF [test_maps] linked_maps2.o
  CLNG-BPF [test_maps] linked_vars1.o
  CLNG-BPF [test_maps] linked_vars2.o
  CLNG-BPF [test_maps] load_bytes_relative.o
  CLNG-BPF [test_maps] local_storage.o
  CLNG-BPF [test_maps] local_storage_bench.o
  CLNG-BPF [test_maps] local_storage_rcu_tasks_trace_bench.o
  CLNG-BPF [test_maps] loop1.o
  CLNG-BPF [test_maps] loop2.o
  CLNG-BPF [test_maps] loop3.o
  CLNG-BPF [test_maps] loop4.o
  CLNG-BPF [test_maps] loop5.o
  CLNG-BPF [test_maps] loop6.o
  CLNG-BPF [test_maps] lru_bug.o
  CLNG-BPF [test_maps] lsm.o
  CLNG-BPF [test_maps] lsm_cgroup.o
  CLNG-BPF [test_maps] lsm_cgroup_nonvoid.o
  CLNG-BPF [test_maps] map_kptr.o
  CLNG-BPF [test_maps] map_kptr_fail.o
  CLNG-BPF [test_maps] map_ptr_kern.o
  CLNG-BPF [test_maps] metadata_unused.o
  CLNG-BPF [test_maps] metadata_used.o
  CLNG-BPF [test_maps] modify_return.o
  CLNG-BPF [test_maps] mptcp_sock.o
  CLNG-BPF [test_maps] netcnt_prog.o
  CLNG-BPF [test_maps] netif_receive_skb.o
  CLNG-BPF [test_maps] netns_cookie_prog.o
  CLNG-BPF [test_maps] perf_event_stackmap.o
  CLNG-BPF [test_maps] perfbuf_bench.o
  CLNG-BPF [test_maps] profiler1.o
  CLNG-BPF [test_maps] profiler2.o
  CLNG-BPF [test_maps] profiler3.o
  CLNG-BPF [test_maps] pyperf100.o
  CLNG-BPF [test_maps] pyperf180.o
  CLNG-BPF [test_maps] pyperf50.o
  CLNG-BPF [test_maps] pyperf600.o
  CLNG-BPF [test_maps] pyperf600_bpf_loop.o
  CLNG-BPF [test_maps] pyperf600_nounroll.o
  CLNG-BPF [test_maps] pyperf_global.o
  CLNG-BPF [test_maps] pyperf_subprogs.o
  CLNG-BPF [test_maps] recursion.o
  CLNG-BPF [test_maps] recvmsg4_prog.o
  CLNG-BPF [test_maps] recvmsg6_prog.o
  CLNG-BPF [test_maps] ringbuf_bench.o
  CLNG-BPF [test_maps] sample_map_ret0.o
  CLNG-BPF [test_maps] sample_ret0.o
  CLNG-BPF [test_maps] sendmsg4_prog.o
  CLNG-BPF [test_maps] sendmsg6_prog.o
  CLNG-BPF [test_maps] skb_load_bytes.o
  CLNG-BPF [test_maps] skb_pkt_end.o
  CLNG-BPF [test_maps] socket_cookie_prog.o
  CLNG-BPF [test_maps] sockmap_parse_prog.o
  CLNG-BPF [test_maps] sockmap_tcp_msg_prog.o
  CLNG-BPF [test_maps] sockmap_verdict_prog.o
  CLNG-BPF [test_maps] sockopt_inherit.o
  CLNG-BPF [test_maps] sockopt_multi.o
  CLNG-BPF [test_maps] sockopt_qos_to_cc.o
  CLNG-BPF [test_maps] sockopt_sk.o
  CLNG-BPF [test_maps] stacktrace_map_skip.o
  CLNG-BPF [test_maps] strncmp_bench.o
  CLNG-BPF [test_maps] strncmp_test.o
  CLNG-BPF [test_maps] strobemeta.o
  CLNG-BPF [test_maps] strobemeta_bpf_loop.o
  CLNG-BPF [test_maps] strobemeta_nounroll1.o
  CLNG-BPF [test_maps] strobemeta_nounroll2.o
  CLNG-BPF [test_maps] strobemeta_subprogs.o
  CLNG-BPF [test_maps] syscall.o
  CLNG-BPF [test_maps] tailcall1.o
  CLNG-BPF [test_maps] tailcall2.o
  CLNG-BPF [test_maps] tailcall3.o
  CLNG-BPF [test_maps] tailcall4.o
  CLNG-BPF [test_maps] tailcall5.o
  CLNG-BPF [test_maps] tailcall6.o
  CLNG-BPF [test_maps] tailcall_bpf2bpf1.o
  CLNG-BPF [test_maps] tailcall_bpf2bpf2.o
  CLNG-BPF [test_maps] tailcall_bpf2bpf3.o
  CLNG-BPF [test_maps] tailcall_bpf2bpf4.o
  CLNG-BPF [test_maps] tailcall_bpf2bpf6.o
  CLNG-BPF [test_maps] task_local_storage.o
  CLNG-BPF [test_maps] task_local_storage_exit_creds.o
  CLNG-BPF [test_maps] task_ls_recursion.o
  CLNG-BPF [test_maps] tcp_ca_incompl_cong_ops.o
  CLNG-BPF [test_maps] tcp_ca_unsupp_cong_op.o
  CLNG-BPF [test_maps] tcp_ca_write_sk_pacing.o
  CLNG-BPF [test_maps] tcp_rtt.o
  CLNG-BPF [test_maps] test_attach_probe.o
  CLNG-BPF [test_maps] test_autoattach.o
  CLNG-BPF [test_maps] test_autoload.o
  CLNG-BPF [test_maps] test_bpf_cookie.o
  CLNG-BPF [test_maps] test_bpf_nf.o
  CLNG-BPF [test_maps] test_bpf_nf_fail.o
  CLNG-BPF [test_maps] test_btf_decl_tag.o
  CLNG-BPF [test_maps] test_btf_map_in_map.o
  CLNG-BPF [test_maps] test_btf_newkv.o
  CLNG-BPF [test_maps] test_btf_nokv.o
  CLNG-BPF [test_maps] test_btf_skc_cls_ingress.o
  CLNG-BPF [test_maps] test_cgroup_link.o
  CLNG-BPF [test_maps] test_check_mtu.o
  CLNG-BPF [test_maps] test_cls_redirect.o
  CLNG-BPF [test_maps] test_cls_redirect_subprogs.o
  CLNG-BPF [test_maps] test_core_autosize.o
  CLNG-BPF [test_maps] test_core_extern.o
  CLNG-BPF [test_maps] test_core_read_macros.o
  CLNG-BPF [test_maps] test_core_reloc_arrays.o
  CLNG-BPF [test_maps] test_core_reloc_bitfields_direct.o
  CLNG-BPF [test_maps] test_core_reloc_bitfields_probed.o
  CLNG-BPF [test_maps] test_core_reloc_enum64val.o
  CLNG-BPF [test_maps] test_core_reloc_enumval.o
  CLNG-BPF [test_maps] test_core_reloc_existence.o
  CLNG-BPF [test_maps] test_core_reloc_flavors.o
  CLNG-BPF [test_maps] test_core_reloc_ints.o
  CLNG-BPF [test_maps] test_core_reloc_kernel.o
  CLNG-BPF [test_maps] test_core_reloc_misc.o
  CLNG-BPF [test_maps] test_core_reloc_mods.o
  CLNG-BPF [test_maps] test_core_reloc_module.o
  CLNG-BPF [test_maps] test_core_reloc_nesting.o
  CLNG-BPF [test_maps] test_core_reloc_primitives.o
  CLNG-BPF [test_maps] test_core_reloc_ptr_as_arr.o
  CLNG-BPF [test_maps] test_core_reloc_size.o
  CLNG-BPF [test_maps] test_core_reloc_type_based.o
  CLNG-BPF [test_maps] test_core_reloc_type_id.o
  CLNG-BPF [test_maps] test_core_retro.o
  CLNG-BPF [test_maps] test_custom_sec_handlers.o
  CLNG-BPF [test_maps] test_d_path.o
  CLNG-BPF [test_maps] test_d_path_check_rdonly_mem.o
  CLNG-BPF [test_maps] test_d_path_check_types.o
  CLNG-BPF [test_maps] test_enable_stats.o
  CLNG-BPF [test_maps] test_endian.o
  CLNG-BPF [test_maps] test_get_stack_rawtp.o
  CLNG-BPF [test_maps] test_get_stack_rawtp_err.o
  CLNG-BPF [test_maps] test_global_data.o
  CLNG-BPF [test_maps] test_global_func1.o
  CLNG-BPF [test_maps] test_global_func10.o
  CLNG-BPF [test_maps] test_global_func11.o
  CLNG-BPF [test_maps] test_global_func12.o
  CLNG-BPF [test_maps] test_global_func13.o
  CLNG-BPF [test_maps] test_global_func14.o
  CLNG-BPF [test_maps] test_global_func15.o
  CLNG-BPF [test_maps] test_global_func16.o
  CLNG-BPF [test_maps] test_global_func17.o
  CLNG-BPF [test_maps] test_global_func2.o
  CLNG-BPF [test_maps] test_global_func3.o
  CLNG-BPF [test_maps] test_global_func4.o
  CLNG-BPF [test_maps] test_global_func5.o
  CLNG-BPF [test_maps] test_global_func6.o
  CLNG-BPF [test_maps] test_global_func7.o
  CLNG-BPF [test_maps] test_global_func8.o
  CLNG-BPF [test_maps] test_global_func9.o
  CLNG-BPF [test_maps] test_global_func_args.o
  CLNG-BPF [test_maps] test_hash_large_key.o
  CLNG-BPF [test_maps] test_helper_restricted.o
  CLNG-BPF [test_maps] test_ksyms.o
  CLNG-BPF [test_maps] test_ksyms_btf.o
  CLNG-BPF [test_maps] test_ksyms_btf_null_check.o
  CLNG-BPF [test_maps] test_ksyms_btf_write_check.o
  CLNG-BPF [test_maps] test_ksyms_module.o
  CLNG-BPF [test_maps] test_ksyms_weak.o
  CLNG-BPF [test_maps] test_l4lb.o
  CLNG-BPF [test_maps] test_l4lb_noinline.o
  CLNG-BPF [test_maps] test_legacy_printk.o
  CLNG-BPF [test_maps] test_link_pinning.o
  CLNG-BPF [test_maps] test_lirc_mode2_kern.o
  CLNG-BPF [test_maps] test_log_buf.o
  CLNG-BPF [test_maps] test_log_fixup.o
  CLNG-BPF [test_maps] test_lookup_and_delete.o
  CLNG-BPF [test_maps] test_lwt_ip_encap.o
  CLNG-BPF [test_maps] test_lwt_seg6local.o
  CLNG-BPF [test_maps] test_map_in_map.o
  CLNG-BPF [test_maps] test_map_in_map_invalid.o
  CLNG-BPF [test_maps] test_map_init.o
  CLNG-BPF [test_maps] test_map_lock.o
  CLNG-BPF [test_maps] test_map_lookup_percpu_elem.o
  CLNG-BPF [test_maps] test_migrate_reuseport.o
  CLNG-BPF [test_maps] test_misc_tcp_hdr_options.o
  CLNG-BPF [test_maps] test_mmap.o
  CLNG-BPF [test_maps] test_module_attach.o
  CLNG-BPF [test_maps] test_ns_current_pid_tgid.o
  CLNG-BPF [test_maps] test_obj_id.o
  CLNG-BPF [test_maps] test_overhead.o
  CLNG-BPF [test_maps] test_pe_preserve_elems.o
  CLNG-BPF [test_maps] test_perf_branches.o
  CLNG-BPF [test_maps] test_perf_buffer.o
  CLNG-BPF [test_maps] test_perf_link.o
  CLNG-BPF [test_maps] test_pinning.o
  CLNG-BPF [test_maps] test_pinning_invalid.o
  CLNG-BPF [test_maps] test_pkt_access.o
  CLNG-BPF [test_maps] test_pkt_md_access.o
  CLNG-BPF [test_maps] test_probe_read_user_str.o
  CLNG-BPF [test_maps] test_probe_user.o
  CLNG-BPF [test_maps] test_prog_array_init.o
  CLNG-BPF [test_maps] test_queue_map.o
  CLNG-BPF [test_maps] test_raw_tp_test_run.o
  CLNG-BPF [test_maps] test_rdonly_maps.o
  CLNG-BPF [test_maps] test_ringbuf.o
  CLNG-BPF [test_maps] test_ringbuf_multi.o
  CLNG-BPF [test_maps] test_seg6_loop.o
  CLNG-BPF [test_maps] test_select_reuseport_kern.o
  CLNG-BPF [test_maps] test_send_signal_kern.o
  CLNG-BPF [test_maps] test_sk_assign.o
  CLNG-BPF [test_maps] test_sk_lookup.o
  CLNG-BPF [test_maps] test_sk_lookup_kern.o
  CLNG-BPF [test_maps] test_sk_storage_trace_itself.o
  CLNG-BPF [test_maps] test_sk_storage_tracing.o
  CLNG-BPF [test_maps] test_skb_cgroup_id_kern.o
  CLNG-BPF [test_maps] test_skb_ctx.o
  CLNG-BPF [test_maps] test_skb_helpers.o
  CLNG-BPF [test_maps] test_skc_to_unix_sock.o
  CLNG-BPF [test_maps] test_skeleton.o
  CLNG-BPF [test_maps] test_skmsg_load_helpers.o
  CLNG-BPF [test_maps] test_snprintf.o
  CLNG-BPF [test_maps] test_snprintf_single.o
  CLNG-BPF [test_maps] test_sock_fields.o
  CLNG-BPF [test_maps] test_sockhash_kern.o
  CLNG-BPF [test_maps] test_sockmap_invalid_update.o
  CLNG-BPF [test_maps] test_sockmap_kern.o
  CLNG-BPF [test_maps] test_sockmap_listen.o
  CLNG-BPF [test_maps] test_sockmap_progs_query.o
  CLNG-BPF [test_maps] test_sockmap_skb_verdict_attach.o
  CLNG-BPF [test_maps] test_sockmap_update.o
  CLNG-BPF [test_maps] test_spin_lock.o
  CLNG-BPF [test_maps] test_stack_map.o
  CLNG-BPF [test_maps] test_stack_var_off.o
  CLNG-BPF [test_maps] test_stacktrace_build_id.o
  CLNG-BPF [test_maps] test_stacktrace_map.o
  CLNG-BPF [test_maps] test_static_linked1.o
  CLNG-BPF [test_maps] test_static_linked2.o
  CLNG-BPF [test_maps] test_subprogs.o
  CLNG-BPF [test_maps] test_subprogs_unused.o
  CLNG-BPF [test_maps] test_subskeleton.o
  CLNG-BPF [test_maps] test_subskeleton_lib.o
  CLNG-BPF [test_maps] test_subskeleton_lib2.o
  CLNG-BPF [test_maps] test_sysctl_loop1.o
  CLNG-BPF [test_maps] test_sysctl_loop2.o
  CLNG-BPF [test_maps] test_sysctl_prog.o
  CLNG-BPF [test_maps] test_task_pt_regs.o
  CLNG-BPF [test_maps] test_tc_bpf.o
  CLNG-BPF [test_maps] test_tc_dtime.o
  CLNG-BPF [test_maps] test_tc_edt.o
  CLNG-BPF [test_maps] test_tc_neigh.o
  CLNG-BPF [test_maps] test_tc_neigh_fib.o
  CLNG-BPF [test_maps] test_tc_peer.o
  CLNG-BPF [test_maps] test_tc_tunnel.o
  CLNG-BPF [test_maps] test_tcp_check_syncookie_kern.o
  CLNG-BPF [test_maps] test_tcp_estats.o
  CLNG-BPF [test_maps] test_tcp_hdr_options.o
  CLNG-BPF [test_maps] test_tcpbpf_kern.o
  CLNG-BPF [test_maps] test_tcpnotify_kern.o
  CLNG-BPF [test_maps] test_time_tai.o
  CLNG-BPF [test_maps] test_trace_ext.o
  CLNG-BPF [test_maps] test_trace_ext_tracing.o
  CLNG-BPF [test_maps] test_tracepoint.o
  CLNG-BPF [test_maps] test_trampoline_count.o
  CLNG-BPF [test_maps] test_tunnel_kern.o
  CLNG-BPF [test_maps] test_unpriv_bpf_disabled.o
  CLNG-BPF [test_maps] test_uprobe_autoattach.o
  CLNG-BPF [test_maps] test_urandom_usdt.o
  CLNG-BPF [test_maps] test_usdt.o
  CLNG-BPF [test_maps] test_usdt_multispec.o
  CLNG-BPF [test_maps] test_varlen.o
  CLNG-BPF [test_maps] test_verif_scale1.o
  CLNG-BPF [test_maps] test_verif_scale2.o
  CLNG-BPF [test_maps] test_verif_scale3.o
  CLNG-BPF [test_maps] test_vmlinux.o
  CLNG-BPF [test_maps] test_xdp.o
  CLNG-BPF [test_maps] test_xdp_adjust_tail_grow.o
  CLNG-BPF [test_maps] test_xdp_adjust_tail_shrink.o
  CLNG-BPF [test_maps] test_xdp_bpf2bpf.o
  CLNG-BPF [test_maps] test_xdp_context_test_run.o
  CLNG-BPF [test_maps] test_xdp_devmap_helpers.o
  CLNG-BPF [test_maps] test_xdp_do_redirect.o
  CLNG-BPF [test_maps] test_xdp_link.o
  CLNG-BPF [test_maps] test_xdp_loop.o
  CLNG-BPF [test_maps] test_xdp_meta.o
  CLNG-BPF [test_maps] test_xdp_noinline.o
  CLNG-BPF [test_maps] test_xdp_redirect.o
  CLNG-BPF [test_maps] test_xdp_update_frags.o
  CLNG-BPF [test_maps] test_xdp_vlan.o
  CLNG-BPF [test_maps] test_xdp_with_cpumap_frags_helpers.o
  CLNG-BPF [test_maps] test_xdp_with_cpumap_helpers.o
  CLNG-BPF [test_maps] test_xdp_with_devmap_frags_helpers.o
  CLNG-BPF [test_maps] test_xdp_with_devmap_helpers.o
  CLNG-BPF [test_maps] timer.o
  CLNG-BPF [test_maps] timer_crash.o
  CLNG-BPF [test_maps] timer_mim.o
  CLNG-BPF [test_maps] timer_mim_reject.o
  CLNG-BPF [test_maps] trace_dummy_st_ops.o
  CLNG-BPF [test_maps] trace_printk.o
  CLNG-BPF [test_maps] trace_vprintk.o
  CLNG-BPF [test_maps] trigger_bench.o
  CLNG-BPF [test_maps] twfw.o
  CLNG-BPF [test_maps] udp_limit.o
  CLNG-BPF [test_maps] xdp_dummy.o
  CLNG-BPF [test_maps] xdp_redirect_map.o
  CLNG-BPF [test_maps] xdp_redirect_multi_kern.o
  CLNG-BPF [test_maps] xdp_synproxy_kern.o
  CLNG-BPF [test_maps] xdp_tx.o
  CLNG-BPF [test_maps] xdping_kern.o
  CLNG-BPF [test_maps] xdpwall.o
  GEN-SKEL [test_progs-no_alu32] atomic_bounds.skel.h
  GEN-SKEL [test_progs-no_alu32] bind4_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] bind6_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] bind_perm.skel.h
  GEN-SKEL [test_progs-no_alu32] bloom_filter_bench.skel.h
  GEN-SKEL [test_progs-no_alu32] bloom_filter_map.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_cubic.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_dctcp.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_dctcp_release.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_flow.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_hashmap_full_update_bench.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_bpf_array_map.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_bpf_hash_map.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_bpf_link.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_bpf_map.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_bpf_percpu_array_map.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_bpf_percpu_hash_map.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_bpf_sk_storage_helpers.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_bpf_sk_storage_map.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_ipv6_route.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_ksym.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_netlink.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_setsockopt.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_setsockopt_unix.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_sockmap.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_task.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_task_btf.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_task_file.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_task_stack.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_task_vma.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_tcp4.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_tcp6.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_test_kern1.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_test_kern2.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_test_kern3.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_test_kern4.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_test_kern5.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_test_kern6.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_udp4.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_udp6.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_iter_unix.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_loop.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_loop_bench.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_mod_race.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_syscall_macro.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_tcp_nogpl.skel.h
  GEN-SKEL [test_progs-no_alu32] bprm_opts.skel.h
  GEN-SKEL [test_progs-no_alu32] btf_data.skel.h
  GEN-SKEL [test_progs-no_alu32] btf_dump_test_case_bitfields.skel.h
  GEN-SKEL [test_progs-no_alu32] btf_dump_test_case_multidim.skel.h
  GEN-SKEL [test_progs-no_alu32] btf_dump_test_case_namespacing.skel.h
  GEN-SKEL [test_progs-no_alu32] btf_dump_test_case_ordering.skel.h
  GEN-SKEL [test_progs-no_alu32] btf_dump_test_case_packing.skel.h
  GEN-SKEL [test_progs-no_alu32] btf_dump_test_case_padding.skel.h
  GEN-SKEL [test_progs-no_alu32] btf_dump_test_case_syntax.skel.h
  GEN-SKEL [test_progs-no_alu32] btf_type_tag.skel.h
  GEN-SKEL [test_progs-no_alu32] btf_type_tag_percpu.skel.h
  GEN-SKEL [test_progs-no_alu32] btf_type_tag_user.skel.h
  GEN-SKEL [test_progs-no_alu32] cg_storage_multi_egress_only.skel.h
  GEN-SKEL [test_progs-no_alu32] cg_storage_multi_isolated.skel.h
  GEN-SKEL [test_progs-no_alu32] cg_storage_multi_shared.skel.h
  GEN-SKEL [test_progs-no_alu32] cgroup_getset_retval_getsockopt.skel.h
  GEN-SKEL [test_progs-no_alu32] cgroup_getset_retval_setsockopt.skel.h
  GEN-SKEL [test_progs-no_alu32] cgroup_skb_sk_lookup_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] connect4_dropper.skel.h
  GEN-SKEL [test_progs-no_alu32] connect4_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] connect6_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] connect_force_port4.skel.h
  GEN-SKEL [test_progs-no_alu32] connect_force_port6.skel.h
  GEN-SKEL [test_progs-no_alu32] dev_cgroup.skel.h
  GEN-SKEL [test_progs-no_alu32] dummy_st_ops.skel.h
  GEN-SKEL [test_progs-no_alu32] dynptr_fail.skel.h
  GEN-SKEL [test_progs-no_alu32] dynptr_success.skel.h
  GEN-SKEL [test_progs-no_alu32] exhandler_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] fexit_bpf2bpf.skel.h
  GEN-SKEL [test_progs-no_alu32] fexit_bpf2bpf_simple.skel.h
  GEN-SKEL [test_progs-no_alu32] find_vma.skel.h
  GEN-SKEL [test_progs-no_alu32] find_vma_fail1.skel.h
  GEN-SKEL [test_progs-no_alu32] find_vma_fail2.skel.h
  GEN-SKEL [test_progs-no_alu32] fmod_ret_freplace.skel.h
  GEN-SKEL [test_progs-no_alu32] for_each_array_map_elem.skel.h
  GEN-SKEL [test_progs-no_alu32] for_each_hash_map_elem.skel.h
  GEN-SKEL [test_progs-no_alu32] for_each_map_elem_write_key.skel.h
  GEN-SKEL [test_progs-no_alu32] freplace_attach_probe.skel.h
  GEN-SKEL [test_progs-no_alu32] freplace_cls_redirect.skel.h
  GEN-SKEL [test_progs-no_alu32] freplace_connect4.skel.h
  GEN-SKEL [test_progs-no_alu32] freplace_connect_v4_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] freplace_get_constant.skel.h
  GEN-SKEL [test_progs-no_alu32] freplace_global_func.skel.h
  GEN-SKEL [test_progs-no_alu32] get_branch_snapshot.skel.h
  GEN-SKEL [test_progs-no_alu32] get_cgroup_id_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] get_func_args_test.skel.h
  GEN-SKEL [test_progs-no_alu32] get_func_ip_test.skel.h
  GEN-SKEL [test_progs-no_alu32] ima.skel.h
  GEN-SKEL [test_progs-no_alu32] kfree_skb.skel.h
  GEN-SKEL [test_progs-no_alu32] kfunc_call_destructive.skel.h
  GEN-SKEL [test_progs-no_alu32] kfunc_call_race.skel.h
  GEN-SKEL [test_progs-no_alu32] kfunc_call_test_subprog.skel.h
  GEN-SKEL [test_progs-no_alu32] kprobe_multi.skel.h
  GEN-SKEL [test_progs-no_alu32] kprobe_multi_empty.skel.h
  GEN-SKEL [test_progs-no_alu32] ksym_race.skel.h
  GEN-SKEL [test_progs-no_alu32] load_bytes_relative.skel.h
  GEN-SKEL [test_progs-no_alu32] local_storage.skel.h
  GEN-SKEL [test_progs-no_alu32] local_storage_bench.skel.h
  GEN-SKEL [test_progs-no_alu32] local_storage_rcu_tasks_trace_bench.skel.h
  GEN-SKEL [test_progs-no_alu32] loop1.skel.h
  GEN-SKEL [test_progs-no_alu32] loop2.skel.h
  GEN-SKEL [test_progs-no_alu32] loop3.skel.h
  GEN-SKEL [test_progs-no_alu32] loop4.skel.h
  GEN-SKEL [test_progs-no_alu32] loop5.skel.h
  GEN-SKEL [test_progs-no_alu32] loop6.skel.h
  GEN-SKEL [test_progs-no_alu32] lru_bug.skel.h
  GEN-SKEL [test_progs-no_alu32] lsm.skel.h
  GEN-SKEL [test_progs-no_alu32] lsm_cgroup.skel.h
  GEN-SKEL [test_progs-no_alu32] lsm_cgroup_nonvoid.skel.h
  GEN-SKEL [test_progs-no_alu32] map_kptr.skel.h
  GEN-SKEL [test_progs-no_alu32] map_kptr_fail.skel.h
  GEN-SKEL [test_progs-no_alu32] metadata_unused.skel.h
  GEN-SKEL [test_progs-no_alu32] metadata_used.skel.h
  GEN-SKEL [test_progs-no_alu32] modify_return.skel.h
  GEN-SKEL [test_progs-no_alu32] mptcp_sock.skel.h
  GEN-SKEL [test_progs-no_alu32] netcnt_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] netif_receive_skb.skel.h
  GEN-SKEL [test_progs-no_alu32] netns_cookie_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] perf_event_stackmap.skel.h
  GEN-SKEL [test_progs-no_alu32] perfbuf_bench.skel.h
  GEN-SKEL [test_progs-no_alu32] profiler1.skel.h
  GEN-SKEL [test_progs-no_alu32] profiler2.skel.h
  GEN-SKEL [test_progs-no_alu32] profiler3.skel.h
  GEN-SKEL [test_progs-no_alu32] pyperf100.skel.h
  GEN-SKEL [test_progs-no_alu32] pyperf180.skel.h
  GEN-SKEL [test_progs-no_alu32] pyperf50.skel.h
  GEN-SKEL [test_progs-no_alu32] pyperf600.skel.h
  GEN-SKEL [test_progs-no_alu32] pyperf600_bpf_loop.skel.h
  GEN-SKEL [test_progs-no_alu32] pyperf600_nounroll.skel.h
  GEN-SKEL [test_progs-no_alu32] pyperf_global.skel.h
  GEN-SKEL [test_progs-no_alu32] pyperf_subprogs.skel.h
  GEN-SKEL [test_progs-no_alu32] recursion.skel.h
  GEN-SKEL [test_progs-no_alu32] recvmsg4_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] recvmsg6_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] ringbuf_bench.skel.h
  GEN-SKEL [test_progs-no_alu32] sample_map_ret0.skel.h
  GEN-SKEL [test_progs-no_alu32] sample_ret0.skel.h
  GEN-SKEL [test_progs-no_alu32] sendmsg4_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] sendmsg6_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] skb_load_bytes.skel.h
  GEN-SKEL [test_progs-no_alu32] skb_pkt_end.skel.h
  GEN-SKEL [test_progs-no_alu32] socket_cookie_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] sockmap_parse_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] sockmap_tcp_msg_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] sockmap_verdict_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] sockopt_inherit.skel.h
  GEN-SKEL [test_progs-no_alu32] sockopt_multi.skel.h
  GEN-SKEL [test_progs-no_alu32] sockopt_qos_to_cc.skel.h
  GEN-SKEL [test_progs-no_alu32] sockopt_sk.skel.h
  GEN-SKEL [test_progs-no_alu32] stacktrace_map_skip.skel.h
  GEN-SKEL [test_progs-no_alu32] strncmp_bench.skel.h
  GEN-SKEL [test_progs-no_alu32] strncmp_test.skel.h
  GEN-SKEL [test_progs-no_alu32] strobemeta.skel.h
  GEN-SKEL [test_progs-no_alu32] strobemeta_bpf_loop.skel.h
  GEN-SKEL [test_progs-no_alu32] strobemeta_nounroll1.skel.h
  GEN-SKEL [test_progs-no_alu32] strobemeta_nounroll2.skel.h
  GEN-SKEL [test_progs-no_alu32] strobemeta_subprogs.skel.h
  GEN-SKEL [test_progs-no_alu32] syscall.skel.h
  GEN-SKEL [test_progs-no_alu32] tailcall1.skel.h
  GEN-SKEL [test_progs-no_alu32] tailcall2.skel.h
  GEN-SKEL [test_progs-no_alu32] tailcall3.skel.h
  GEN-SKEL [test_progs-no_alu32] tailcall4.skel.h
  GEN-SKEL [test_progs-no_alu32] tailcall5.skel.h
  GEN-SKEL [test_progs-no_alu32] tailcall6.skel.h
  GEN-SKEL [test_progs-no_alu32] tailcall_bpf2bpf1.skel.h
  GEN-SKEL [test_progs-no_alu32] tailcall_bpf2bpf2.skel.h
  GEN-SKEL [test_progs-no_alu32] tailcall_bpf2bpf3.skel.h
  GEN-SKEL [test_progs-no_alu32] tailcall_bpf2bpf4.skel.h
  GEN-SKEL [test_progs-no_alu32] tailcall_bpf2bpf6.skel.h
  GEN-SKEL [test_progs-no_alu32] task_local_storage.skel.h
  GEN-SKEL [test_progs-no_alu32] task_local_storage_exit_creds.skel.h
  GEN-SKEL [test_progs-no_alu32] task_ls_recursion.skel.h
  GEN-SKEL [test_progs-no_alu32] tcp_ca_incompl_cong_ops.skel.h
  GEN-SKEL [test_progs-no_alu32] tcp_ca_unsupp_cong_op.skel.h
  GEN-SKEL [test_progs-no_alu32] tcp_ca_write_sk_pacing.skel.h
  GEN-SKEL [test_progs-no_alu32] tcp_rtt.skel.h
  GEN-SKEL [test_progs-no_alu32] test_attach_probe.skel.h
  GEN-SKEL [test_progs-no_alu32] test_autoattach.skel.h
  GEN-SKEL [test_progs-no_alu32] test_autoload.skel.h
  GEN-SKEL [test_progs-no_alu32] test_bpf_cookie.skel.h
  GEN-SKEL [test_progs-no_alu32] test_bpf_nf.skel.h
  GEN-SKEL [test_progs-no_alu32] test_bpf_nf_fail.skel.h
  GEN-SKEL [test_progs-no_alu32] test_btf_decl_tag.skel.h
  GEN-SKEL [test_progs-no_alu32] test_btf_map_in_map.skel.h
  GEN-SKEL [test_progs-no_alu32] test_btf_newkv.skel.h
  GEN-SKEL [test_progs-no_alu32] test_btf_nokv.skel.h
  GEN-SKEL [test_progs-no_alu32] test_btf_skc_cls_ingress.skel.h
  GEN-SKEL [test_progs-no_alu32] test_cgroup_link.skel.h
  GEN-SKEL [test_progs-no_alu32] test_check_mtu.skel.h
  GEN-SKEL [test_progs-no_alu32] test_cls_redirect.skel.h
  GEN-SKEL [test_progs-no_alu32] test_cls_redirect_subprogs.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_autosize.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_extern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_read_macros.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_arrays.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_bitfields_direct.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_bitfields_probed.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_enum64val.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_enumval.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_existence.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_flavors.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_ints.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_kernel.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_misc.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_mods.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_module.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_nesting.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_primitives.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_ptr_as_arr.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_size.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_type_based.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_reloc_type_id.skel.h
  GEN-SKEL [test_progs-no_alu32] test_core_retro.skel.h
  GEN-SKEL [test_progs-no_alu32] test_custom_sec_handlers.skel.h
  GEN-SKEL [test_progs-no_alu32] test_d_path.skel.h
  GEN-SKEL [test_progs-no_alu32] test_d_path_check_rdonly_mem.skel.h
  GEN-SKEL [test_progs-no_alu32] test_d_path_check_types.skel.h
  GEN-SKEL [test_progs-no_alu32] test_enable_stats.skel.h
  GEN-SKEL [test_progs-no_alu32] test_endian.skel.h
  GEN-SKEL [test_progs-no_alu32] test_get_stack_rawtp.skel.h
  GEN-SKEL [test_progs-no_alu32] test_get_stack_rawtp_err.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_data.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func1.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func10.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func11.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func12.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func13.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func14.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func15.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func16.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func17.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func2.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func3.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func4.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func5.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func6.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func7.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func8.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func9.skel.h
  GEN-SKEL [test_progs-no_alu32] test_global_func_args.skel.h
  GEN-SKEL [test_progs-no_alu32] test_hash_large_key.skel.h
  GEN-SKEL [test_progs-no_alu32] test_helper_restricted.skel.h
  GEN-SKEL [test_progs-no_alu32] test_ksyms.skel.h
  GEN-SKEL [test_progs-no_alu32] test_ksyms_btf.skel.h
  GEN-SKEL [test_progs-no_alu32] test_ksyms_btf_null_check.skel.h
  GEN-SKEL [test_progs-no_alu32] test_ksyms_btf_write_check.skel.h
  GEN-SKEL [test_progs-no_alu32] test_ksyms_module.skel.h
  GEN-SKEL [test_progs-no_alu32] test_ksyms_weak.skel.h
  GEN-SKEL [test_progs-no_alu32] test_l4lb.skel.h
  GEN-SKEL [test_progs-no_alu32] test_l4lb_noinline.skel.h
  GEN-SKEL [test_progs-no_alu32] test_legacy_printk.skel.h
  GEN-SKEL [test_progs-no_alu32] test_link_pinning.skel.h
  GEN-SKEL [test_progs-no_alu32] test_lirc_mode2_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_log_buf.skel.h
  GEN-SKEL [test_progs-no_alu32] test_log_fixup.skel.h
  GEN-SKEL [test_progs-no_alu32] test_lookup_and_delete.skel.h
  GEN-SKEL [test_progs-no_alu32] test_lwt_ip_encap.skel.h
  GEN-SKEL [test_progs-no_alu32] test_lwt_seg6local.skel.h
  GEN-SKEL [test_progs-no_alu32] test_map_in_map.skel.h
  GEN-SKEL [test_progs-no_alu32] test_map_in_map_invalid.skel.h
  GEN-SKEL [test_progs-no_alu32] test_map_init.skel.h
  GEN-SKEL [test_progs-no_alu32] test_map_lock.skel.h
  GEN-SKEL [test_progs-no_alu32] test_map_lookup_percpu_elem.skel.h
  GEN-SKEL [test_progs-no_alu32] test_migrate_reuseport.skel.h
  GEN-SKEL [test_progs-no_alu32] test_misc_tcp_hdr_options.skel.h
  GEN-SKEL [test_progs-no_alu32] test_mmap.skel.h
  GEN-SKEL [test_progs-no_alu32] test_module_attach.skel.h
  GEN-SKEL [test_progs-no_alu32] test_ns_current_pid_tgid.skel.h
  GEN-SKEL [test_progs-no_alu32] test_obj_id.skel.h
  GEN-SKEL [test_progs-no_alu32] test_overhead.skel.h
  GEN-SKEL [test_progs-no_alu32] test_pe_preserve_elems.skel.h
  GEN-SKEL [test_progs-no_alu32] test_perf_branches.skel.h
  GEN-SKEL [test_progs-no_alu32] test_perf_buffer.skel.h
  GEN-SKEL [test_progs-no_alu32] test_perf_link.skel.h
  GEN-SKEL [test_progs-no_alu32] test_pinning.skel.h
  GEN-SKEL [test_progs-no_alu32] test_pkt_access.skel.h
  GEN-SKEL [test_progs-no_alu32] test_pkt_md_access.skel.h
  GEN-SKEL [test_progs-no_alu32] test_probe_read_user_str.skel.h
  GEN-SKEL [test_progs-no_alu32] test_probe_user.skel.h
  GEN-SKEL [test_progs-no_alu32] test_prog_array_init.skel.h
  GEN-SKEL [test_progs-no_alu32] test_queue_map.skel.h
  GEN-SKEL [test_progs-no_alu32] test_raw_tp_test_run.skel.h
  GEN-SKEL [test_progs-no_alu32] test_rdonly_maps.skel.h
  GEN-SKEL [test_progs-no_alu32] test_ringbuf_multi.skel.h
  GEN-SKEL [test_progs-no_alu32] test_seg6_loop.skel.h
  GEN-SKEL [test_progs-no_alu32] test_select_reuseport_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_send_signal_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sk_lookup.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sk_lookup_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sk_storage_trace_itself.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sk_storage_tracing.skel.h
  GEN-SKEL [test_progs-no_alu32] test_skb_cgroup_id_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_skb_ctx.skel.h
  GEN-SKEL [test_progs-no_alu32] test_skb_helpers.skel.h
  GEN-SKEL [test_progs-no_alu32] test_skc_to_unix_sock.skel.h
  GEN-SKEL [test_progs-no_alu32] test_skeleton.skel.h
  GEN-SKEL [test_progs-no_alu32] test_skmsg_load_helpers.skel.h
  GEN-SKEL [test_progs-no_alu32] test_snprintf.skel.h
  GEN-SKEL [test_progs-no_alu32] test_snprintf_single.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sock_fields.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sockhash_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sockmap_invalid_update.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sockmap_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sockmap_listen.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sockmap_progs_query.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sockmap_skb_verdict_attach.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sockmap_update.skel.h
  GEN-SKEL [test_progs-no_alu32] test_spin_lock.skel.h
  GEN-SKEL [test_progs-no_alu32] test_stack_map.skel.h
  GEN-SKEL [test_progs-no_alu32] test_stack_var_off.skel.h
  GEN-SKEL [test_progs-no_alu32] test_stacktrace_build_id.skel.h
  GEN-SKEL [test_progs-no_alu32] test_stacktrace_map.skel.h
  GEN-SKEL [test_progs-no_alu32] test_subprogs.skel.h
  GEN-SKEL [test_progs-no_alu32] test_subprogs_unused.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sysctl_loop1.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sysctl_loop2.skel.h
  GEN-SKEL [test_progs-no_alu32] test_sysctl_prog.skel.h
  GEN-SKEL [test_progs-no_alu32] test_task_pt_regs.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tc_bpf.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tc_dtime.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tc_edt.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tc_neigh.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tc_neigh_fib.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tc_peer.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tc_tunnel.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tcp_check_syncookie_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tcp_estats.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tcp_hdr_options.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tcpbpf_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tcpnotify_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_time_tai.skel.h
  GEN-SKEL [test_progs-no_alu32] test_trace_ext.skel.h
  GEN-SKEL [test_progs-no_alu32] test_trace_ext_tracing.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tracepoint.skel.h
  GEN-SKEL [test_progs-no_alu32] test_trampoline_count.skel.h
  GEN-SKEL [test_progs-no_alu32] test_tunnel_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] test_unpriv_bpf_disabled.skel.h
  GEN-SKEL [test_progs-no_alu32] test_uprobe_autoattach.skel.h
  GEN-SKEL [test_progs-no_alu32] test_urandom_usdt.skel.h
  GEN-SKEL [test_progs-no_alu32] test_varlen.skel.h
  GEN-SKEL [test_progs-no_alu32] test_verif_scale1.skel.h
  GEN-SKEL [test_progs-no_alu32] test_verif_scale2.skel.h
  GEN-SKEL [test_progs-no_alu32] test_verif_scale3.skel.h
  GEN-SKEL [test_progs-no_alu32] test_vmlinux.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_adjust_tail_grow.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_adjust_tail_shrink.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_bpf2bpf.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_context_test_run.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_devmap_helpers.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_do_redirect.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_link.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_loop.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_meta.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_noinline.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_redirect.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_update_frags.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_vlan.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_with_cpumap_frags_helpers.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_with_cpumap_helpers.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_with_devmap_frags_helpers.skel.h
  GEN-SKEL [test_progs-no_alu32] test_xdp_with_devmap_helpers.skel.h
  GEN-SKEL [test_progs-no_alu32] timer.skel.h
  GEN-SKEL [test_progs-no_alu32] timer_crash.skel.h
  GEN-SKEL [test_progs-no_alu32] timer_mim.skel.h
  GEN-SKEL [test_progs-no_alu32] timer_mim_reject.skel.h
  GEN-SKEL [test_progs-no_alu32] trace_dummy_st_ops.skel.h
  GEN-SKEL [test_progs-no_alu32] trigger_bench.skel.h
  GEN-SKEL [test_progs-no_alu32] twfw.skel.h
  GEN-SKEL [test_progs-no_alu32] udp_limit.skel.h
  GEN-SKEL [test_progs-no_alu32] xdp_dummy.skel.h
  GEN-SKEL [test_progs-no_alu32] xdp_redirect_map.skel.h
  GEN-SKEL [test_progs-no_alu32] xdp_redirect_multi_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] xdp_synproxy_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] xdp_tx.skel.h
  GEN-SKEL [test_progs-no_alu32] xdping_kern.skel.h
  GEN-SKEL [test_progs-no_alu32] xdpwall.skel.h
  GEN-SKEL [test_progs-no_alu32] kfunc_call_test.lskel.h
  GEN-SKEL [test_progs-no_alu32] fentry_test.lskel.h
  GEN-SKEL [test_progs-no_alu32] fexit_test.lskel.h
  GEN-SKEL [test_progs-no_alu32] fexit_sleep.lskel.h
  GEN-SKEL [test_progs-no_alu32] test_ringbuf.lskel.h
  GEN-SKEL [test_progs-no_alu32] atomics.lskel.h
  GEN-SKEL [test_progs-no_alu32] trace_printk.lskel.h
  GEN-SKEL [test_progs-no_alu32] trace_vprintk.lskel.h
  GEN-SKEL [test_progs-no_alu32] map_ptr_kern.lskel.h
  GEN-SKEL [test_progs-no_alu32] core_kern.lskel.h
  GEN-SKEL [test_progs-no_alu32] core_kern_overflow.lskel.h
  GEN-SKEL [test_progs-no_alu32] test_ksyms_module.lskel.h
  GEN-SKEL [test_progs-no_alu32] test_ksyms_weak.lskel.h
  GEN-SKEL [test_progs-no_alu32] kfunc_call_test_subprog.lskel.h
  LINK-BPF [test_progs-no_alu32] test_static_linked.o
  GEN-SKEL [test_progs-no_alu32] test_static_linked.skel.h
  LINK-BPF [test_progs-no_alu32] linked_funcs.o
  GEN-SKEL [test_progs-no_alu32] linked_funcs.skel.h
  LINK-BPF [test_progs-no_alu32] linked_vars.o
  GEN-SKEL [test_progs-no_alu32] linked_vars.skel.h
  LINK-BPF [test_progs-no_alu32] linked_maps.o
  GEN-SKEL [test_progs-no_alu32] linked_maps.skel.h
  LINK-BPF [test_progs-no_alu32] test_subskeleton.o
  GEN-SKEL [test_progs-no_alu32] test_subskeleton.skel.h
  LINK-BPF [test_progs-no_alu32] test_subskeleton_lib.o
  GEN-SKEL [test_progs-no_alu32] test_subskeleton_lib.skel.h
  LINK-BPF [test_progs-no_alu32] test_usdt.o
  GEN-SKEL [test_progs-no_alu32] test_usdt.skel.h
  TEST-OBJ [test_progs-no_alu32] align.test.o
  TEST-OBJ [test_progs-no_alu32] arg_parsing.test.o
  TEST-OBJ [test_progs-no_alu32] atomic_bounds.test.o
  TEST-OBJ [test_progs-no_alu32] atomics.test.o
  TEST-OBJ [test_progs-no_alu32] attach_probe.test.o
  TEST-OBJ [test_progs-no_alu32] autoattach.test.o
  TEST-OBJ [test_progs-no_alu32] autoload.test.o
  TEST-OBJ [test_progs-no_alu32] bind_perm.test.o
  TEST-OBJ [test_progs-no_alu32] bloom_filter_map.test.o
  TEST-OBJ [test_progs-no_alu32] bpf_cookie.test.o
  TEST-OBJ [test_progs-no_alu32] bpf_iter.test.o
  TEST-OBJ [test_progs-no_alu32] bpf_iter_setsockopt.test.o
  TEST-OBJ [test_progs-no_alu32] bpf_iter_setsockopt_unix.test.o
  TEST-OBJ [test_progs-no_alu32] bpf_loop.test.o
  TEST-OBJ [test_progs-no_alu32] bpf_mod_race.test.o
  TEST-OBJ [test_progs-no_alu32] bpf_nf.test.o
  TEST-OBJ [test_progs-no_alu32] bpf_obj_id.test.o
  TEST-OBJ [test_progs-no_alu32] bpf_tcp_ca.test.o
  TEST-OBJ [test_progs-no_alu32] bpf_verif_scale.test.o
  TEST-OBJ [test_progs-no_alu32] btf.test.o
  TEST-OBJ [test_progs-no_alu32] btf_dedup_split.test.o
  TEST-OBJ [test_progs-no_alu32] btf_dump.test.o
  TEST-OBJ [test_progs-no_alu32] btf_endian.test.o
  TEST-OBJ [test_progs-no_alu32] btf_map_in_map.test.o
  TEST-OBJ [test_progs-no_alu32] btf_module.test.o
  TEST-OBJ [test_progs-no_alu32] btf_skc_cls_ingress.test.o
  TEST-OBJ [test_progs-no_alu32] btf_split.test.o
  TEST-OBJ [test_progs-no_alu32] btf_tag.test.o
  TEST-OBJ [test_progs-no_alu32] btf_write.test.o
  TEST-OBJ [test_progs-no_alu32] cg_storage_multi.test.o
  TEST-OBJ [test_progs-no_alu32] cgroup_attach_autodetach.test.o
  TEST-OBJ [test_progs-no_alu32] cgroup_attach_multi.test.o
  TEST-OBJ [test_progs-no_alu32] cgroup_attach_override.test.o
  TEST-OBJ [test_progs-no_alu32] cgroup_getset_retval.test.o
  TEST-OBJ [test_progs-no_alu32] cgroup_link.test.o
  TEST-OBJ [test_progs-no_alu32] cgroup_skb_sk_lookup.test.o
  TEST-OBJ [test_progs-no_alu32] cgroup_v1v2.test.o
  TEST-OBJ [test_progs-no_alu32] check_mtu.test.o
  TEST-OBJ [test_progs-no_alu32] cls_redirect.test.o
  TEST-OBJ [test_progs-no_alu32] connect_force_port.test.o
  TEST-OBJ [test_progs-no_alu32] core_autosize.test.o
  TEST-OBJ [test_progs-no_alu32] core_extern.test.o
  TEST-OBJ [test_progs-no_alu32] core_kern.test.o
  TEST-OBJ [test_progs-no_alu32] core_kern_overflow.test.o
  TEST-OBJ [test_progs-no_alu32] core_read_macros.test.o
  TEST-OBJ [test_progs-no_alu32] core_reloc.test.o
  TEST-OBJ [test_progs-no_alu32] core_retro.test.o
  TEST-OBJ [test_progs-no_alu32] cpu_mask.test.o
  TEST-OBJ [test_progs-no_alu32] custom_sec_handlers.test.o
  TEST-OBJ [test_progs-no_alu32] d_path.test.o
  TEST-OBJ [test_progs-no_alu32] dummy_st_ops.test.o
  TEST-OBJ [test_progs-no_alu32] dynptr.test.o
  TEST-OBJ [test_progs-no_alu32] enable_stats.test.o
  TEST-OBJ [test_progs-no_alu32] endian.test.o
  TEST-OBJ [test_progs-no_alu32] exhandler.test.o
  TEST-OBJ [test_progs-no_alu32] fentry_fexit.test.o
  TEST-OBJ [test_progs-no_alu32] fentry_test.test.o
  TEST-OBJ [test_progs-no_alu32] fexit_bpf2bpf.test.o
  TEST-OBJ [test_progs-no_alu32] fexit_sleep.test.o
  TEST-OBJ [test_progs-no_alu32] fexit_stress.test.o
  TEST-OBJ [test_progs-no_alu32] fexit_test.test.o
  TEST-OBJ [test_progs-no_alu32] find_vma.test.o
  TEST-OBJ [test_progs-no_alu32] flow_dissector.test.o
  TEST-OBJ [test_progs-no_alu32] flow_dissector_load_bytes.test.o
  TEST-OBJ [test_progs-no_alu32] flow_dissector_reattach.test.o
  TEST-OBJ [test_progs-no_alu32] for_each.test.o
  TEST-OBJ [test_progs-no_alu32] get_branch_snapshot.test.o
  TEST-OBJ [test_progs-no_alu32] get_func_args_test.test.o
  TEST-OBJ [test_progs-no_alu32] get_func_ip_test.test.o
  TEST-OBJ [test_progs-no_alu32] get_stack_raw_tp.test.o
  TEST-OBJ [test_progs-no_alu32] get_stackid_cannot_attach.test.o
  TEST-OBJ [test_progs-no_alu32] global_data.test.o
  TEST-OBJ [test_progs-no_alu32] global_data_init.test.o
  TEST-OBJ [test_progs-no_alu32] global_func_args.test.o
  TEST-OBJ [test_progs-no_alu32] hash_large_key.test.o
  TEST-OBJ [test_progs-no_alu32] hashmap.test.o
  TEST-OBJ [test_progs-no_alu32] helper_restricted.test.o
  TEST-OBJ [test_progs-no_alu32] kfree_skb.test.o
  TEST-OBJ [test_progs-no_alu32] kfunc_call.test.o
  TEST-OBJ [test_progs-no_alu32] kprobe_multi_test.test.o
  TEST-OBJ [test_progs-no_alu32] ksyms.test.o
  TEST-OBJ [test_progs-no_alu32] ksyms_btf.test.o
  TEST-OBJ [test_progs-no_alu32] ksyms_module.test.o
  TEST-OBJ [test_progs-no_alu32] l4lb_all.test.o
  TEST-OBJ [test_progs-no_alu32] legacy_printk.test.o
  TEST-OBJ [test_progs-no_alu32] libbpf_probes.test.o
  TEST-OBJ [test_progs-no_alu32] libbpf_str.test.o
  TEST-OBJ [test_progs-no_alu32] link_pinning.test.o
  TEST-OBJ [test_progs-no_alu32] linked_funcs.test.o
  TEST-OBJ [test_progs-no_alu32] linked_maps.test.o
  TEST-OBJ [test_progs-no_alu32] linked_vars.test.o
  TEST-OBJ [test_progs-no_alu32] load_bytes_relative.test.o
  TEST-OBJ [test_progs-no_alu32] log_buf.test.o
  TEST-OBJ [test_progs-no_alu32] log_fixup.test.o
  TEST-OBJ [test_progs-no_alu32] lookup_and_delete.test.o
  TEST-OBJ [test_progs-no_alu32] lru_bug.test.o
  TEST-OBJ [test_progs-no_alu32] lsm_cgroup.test.o
  TEST-OBJ [test_progs-no_alu32] map_init.test.o
  TEST-OBJ [test_progs-no_alu32] map_kptr.test.o
  TEST-OBJ [test_progs-no_alu32] map_lock.test.o
  TEST-OBJ [test_progs-no_alu32] map_lookup_percpu_elem.test.o
  TEST-OBJ [test_progs-no_alu32] map_ptr.test.o
  TEST-OBJ [test_progs-no_alu32] metadata.test.o
  TEST-OBJ [test_progs-no_alu32] migrate_reuseport.test.o
  TEST-OBJ [test_progs-no_alu32] mmap.test.o
  TEST-OBJ [test_progs-no_alu32] modify_return.test.o
  TEST-OBJ [test_progs-no_alu32] module_attach.test.o
  TEST-OBJ [test_progs-no_alu32] mptcp.test.o
  TEST-OBJ [test_progs-no_alu32] netcnt.test.o
  TEST-OBJ [test_progs-no_alu32] netns_cookie.test.o
  TEST-OBJ [test_progs-no_alu32] ns_current_pid_tgid.test.o
  TEST-OBJ [test_progs-no_alu32] obj_name.test.o
  TEST-OBJ [test_progs-no_alu32] pe_preserve_elems.test.o
  TEST-OBJ [test_progs-no_alu32] perf_branches.test.o
  TEST-OBJ [test_progs-no_alu32] perf_buffer.test.o
  TEST-OBJ [test_progs-no_alu32] perf_event_stackmap.test.o
  TEST-OBJ [test_progs-no_alu32] perf_link.test.o
  TEST-OBJ [test_progs-no_alu32] pinning.test.o
  TEST-OBJ [test_progs-no_alu32] pkt_access.test.o
  TEST-OBJ [test_progs-no_alu32] pkt_md_access.test.o
  TEST-OBJ [test_progs-no_alu32] probe_read_user_str.test.o
  TEST-OBJ [test_progs-no_alu32] probe_user.test.o
  TEST-OBJ [test_progs-no_alu32] prog_array_init.test.o
  TEST-OBJ [test_progs-no_alu32] prog_run_opts.test.o
  TEST-OBJ [test_progs-no_alu32] prog_tests_framework.test.o
  TEST-OBJ [test_progs-no_alu32] queue_stack_map.test.o
  TEST-OBJ [test_progs-no_alu32] raw_tp_test_run.test.o
  TEST-OBJ [test_progs-no_alu32] raw_tp_writable_reject_nbd_invalid.test.o
  TEST-OBJ [test_progs-no_alu32] raw_tp_writable_test_run.test.o
  TEST-OBJ [test_progs-no_alu32] rdonly_maps.test.o
  TEST-OBJ [test_progs-no_alu32] recursion.test.o
  TEST-OBJ [test_progs-no_alu32] reference_tracking.test.o
  TEST-OBJ [test_progs-no_alu32] resolve_btfids.test.o
  TEST-OBJ [test_progs-no_alu32] ringbuf.test.o
  TEST-OBJ [test_progs-no_alu32] ringbuf_multi.test.o
  TEST-OBJ [test_progs-no_alu32] section_names.test.o
  TEST-OBJ [test_progs-no_alu32] select_reuseport.test.o
  TEST-OBJ [test_progs-no_alu32] send_signal.test.o
  TEST-OBJ [test_progs-no_alu32] send_signal_sched_switch.test.o
  TEST-OBJ [test_progs-no_alu32] signal_pending.test.o
  TEST-OBJ [test_progs-no_alu32] sk_assign.test.o
  TEST-OBJ [test_progs-no_alu32] sk_lookup.test.o
  TEST-OBJ [test_progs-no_alu32] sk_storage_tracing.test.o
  TEST-OBJ [test_progs-no_alu32] skb_ctx.test.o
  TEST-OBJ [test_progs-no_alu32] skb_helpers.test.o
  TEST-OBJ [test_progs-no_alu32] skb_load_bytes.test.o
  TEST-OBJ [test_progs-no_alu32] skc_to_unix_sock.test.o
  TEST-OBJ [test_progs-no_alu32] skeleton.test.o
  TEST-OBJ [test_progs-no_alu32] snprintf.test.o
  TEST-OBJ [test_progs-no_alu32] snprintf_btf.test.o
  TEST-OBJ [test_progs-no_alu32] sock_fields.test.o
  TEST-OBJ [test_progs-no_alu32] socket_cookie.test.o
  TEST-OBJ [test_progs-no_alu32] sockmap_basic.test.o
  TEST-OBJ [test_progs-no_alu32] sockmap_ktls.test.o
  TEST-OBJ [test_progs-no_alu32] sockmap_listen.test.o
  TEST-OBJ [test_progs-no_alu32] sockopt.test.o
  TEST-OBJ [test_progs-no_alu32] sockopt_inherit.test.o
  TEST-OBJ [test_progs-no_alu32] sockopt_multi.test.o
  TEST-OBJ [test_progs-no_alu32] sockopt_qos_to_cc.test.o
  TEST-OBJ [test_progs-no_alu32] sockopt_sk.test.o
  TEST-OBJ [test_progs-no_alu32] spinlock.test.o
  TEST-OBJ [test_progs-no_alu32] stack_var_off.test.o
  TEST-OBJ [test_progs-no_alu32] stacktrace_build_id.test.o
  TEST-OBJ [test_progs-no_alu32] stacktrace_build_id_nmi.test.o
  TEST-OBJ [test_progs-no_alu32] stacktrace_map.test.o
  TEST-OBJ [test_progs-no_alu32] stacktrace_map_raw_tp.test.o
  TEST-OBJ [test_progs-no_alu32] stacktrace_map_skip.test.o
  TEST-OBJ [test_progs-no_alu32] static_linked.test.o
  TEST-OBJ [test_progs-no_alu32] subprogs.test.o
  TEST-OBJ [test_progs-no_alu32] subskeleton.test.o
  TEST-OBJ [test_progs-no_alu32] syscall.test.o
  TEST-OBJ [test_progs-no_alu32] tailcalls.test.o
  TEST-OBJ [test_progs-no_alu32] task_fd_query_rawtp.test.o
  TEST-OBJ [test_progs-no_alu32] task_fd_query_tp.test.o
  TEST-OBJ [test_progs-no_alu32] task_local_storage.test.o
  TEST-OBJ [test_progs-no_alu32] task_pt_regs.test.o
  TEST-OBJ [test_progs-no_alu32] tc_bpf.test.o
  TEST-OBJ [test_progs-no_alu32] tc_redirect.test.o
  TEST-OBJ [test_progs-no_alu32] tcp_estats.test.o
  TEST-OBJ [test_progs-no_alu32] tcp_hdr_options.test.o
  TEST-OBJ [test_progs-no_alu32] tcp_rtt.test.o
  TEST-OBJ [test_progs-no_alu32] tcpbpf_user.test.o
  TEST-OBJ [test_progs-no_alu32] test_bpf_syscall_macro.test.o
  TEST-OBJ [test_progs-no_alu32] test_bpffs.test.o
  TEST-OBJ [test_progs-no_alu32] test_bprm_opts.test.o
  TEST-OBJ [test_progs-no_alu32] test_global_funcs.test.o
  TEST-OBJ [test_progs-no_alu32] test_ima.test.o
  TEST-OBJ [test_progs-no_alu32] test_local_storage.test.o
  TEST-OBJ [test_progs-no_alu32] test_lsm.test.o
  TEST-OBJ [test_progs-no_alu32] test_overhead.test.o
  TEST-OBJ [test_progs-no_alu32] test_profiler.test.o
  TEST-OBJ [test_progs-no_alu32] test_skb_pkt_end.test.o
  TEST-OBJ [test_progs-no_alu32] test_strncmp.test.o
  TEST-OBJ [test_progs-no_alu32] test_tunnel.test.o
  TEST-OBJ [test_progs-no_alu32] time_tai.test.o
  TEST-OBJ [test_progs-no_alu32] timer.test.o
  TEST-OBJ [test_progs-no_alu32] timer_crash.test.o
  TEST-OBJ [test_progs-no_alu32] timer_mim.test.o
  TEST-OBJ [test_progs-no_alu32] tp_attach_query.test.o
  TEST-OBJ [test_progs-no_alu32] trace_ext.test.o
  TEST-OBJ [test_progs-no_alu32] trace_printk.test.o
  TEST-OBJ [test_progs-no_alu32] trace_vprintk.test.o
  TEST-OBJ [test_progs-no_alu32] trampoline_count.test.o
  TEST-OBJ [test_progs-no_alu32] udp_limit.test.o
  TEST-OBJ [test_progs-no_alu32] unpriv_bpf_disabled.test.o
  TEST-OBJ [test_progs-no_alu32] uprobe_autoattach.test.o
  TEST-OBJ [test_progs-no_alu32] usdt.test.o
  TEST-OBJ [test_progs-no_alu32] varlen.test.o
  TEST-OBJ [test_progs-no_alu32] verif_stats.test.o
  TEST-OBJ [test_progs-no_alu32] vmlinux.test.o
  TEST-OBJ [test_progs-no_alu32] xdp.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_adjust_frags.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_adjust_tail.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_attach.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_bonding.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_bpf2bpf.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_context_test_run.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_cpumap_attach.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_devmap_attach.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_do_redirect.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_info.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_link.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_noinline.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_perf.test.o
  TEST-OBJ [test_progs-no_alu32] xdp_synproxy.test.o
  TEST-OBJ [test_progs-no_alu32] xdpwall.test.o
  EXT-OBJ  [test_progs-no_alu32] test_progs.o
  EXT-OBJ  [test_progs-no_alu32] cgroup_helpers.o
  EXT-OBJ  [test_progs-no_alu32] trace_helpers.o
  EXT-OBJ  [test_progs-no_alu32] network_helpers.o
  EXT-OBJ  [test_progs-no_alu32] testing_helpers.o
  EXT-OBJ  [test_progs-no_alu32] btf_helpers.o
  EXT-OBJ  [test_progs-no_alu32] cap_helpers.o
  EXT-COPY [test_progs-no_alu32] urandom_read bpf_testmod.ko liburandom_rea=
d.so xdp_synproxy ima_setup.sh btf_dump_test_case_bitfields.c btf_dump_test=
_case_multidim.c btf_dump_test_case_namespacing.c btf_dump_test_case_orderi=
ng.c btf_dump_test_case_packing.c btf_dump_test_case_padding.c btf_dump_tes=
t_case_syntax.c
  BINARY   test_progs-no_alu32
  BINARY   test_sock_addr
  BINARY   test_skb_cgroup_id_user
  BINARY   flow_dissector_load
  BINARY   test_flow_dissector
  BINARY   test_tcp_check_syncookie_user
  BINARY   test_lirc_mode2_user
  BINARY   xdping
  CXX      test_cpp
  MKDIR   =20
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/runqslow=
er//vmlinux.h
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/runqslow=
er//runqslower.bpf.o
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/runqslow=
er//runqslower.skel.h
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/runqslow=
er//runqslower.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/tools/build/runqslow=
er//runqslower
  CC       bench.o
  CC       bench_count.o
  CC       bench_rename.o
  CC       bench_trigger.o
  CC       bench_ringbufs.o
  CC       bench_bloom_filter_map.o
  CC       bench_bpf_loop.o
  CC       bench_strncmp.o
  CC       bench_bpf_hashmap_full_update.o
  CC       bench_local_storage.o
  CC       bench_local_storage_rcu_tasks_trace.o
  BINARY   bench
  CC       xsk.o
  BINARY   xskxceiver
  BINARY   xdp_redirect_multi
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bpf-helpers.rst
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bpf-helpers.7
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bpf-helpers.7
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bpf-syscall.rst
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bpf-syscall.2
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf/bpf-syscall.2
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/bpf'
2022-10-02 19:41:59 make -C ../../../tools/testing/selftests/net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net'
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reusepor=
t_bpf.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762ce=
fd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/reuseport_bpf
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reusepor=
t_bpf_cpu.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d3547=
62cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/reuseport_bpf_=
cpu
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reusepor=
t_bpf_numa.c -lnuma -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0=
e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/reusepo=
rt_bpf_numa
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reusepor=
t_dualstack.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d35=
4762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/reuseport_du=
alstack
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reuseadd=
r_conflict.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354=
762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/reuseaddr_con=
flict
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     tls.c  -=
o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cf=
f8988ff276e45effc4/tools/testing/selftests/net/tls
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     tun.c  -=
o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cf=
f8988ff276e45effc4/tools/testing/selftests/net/tun
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     tap.c  -=
o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cf=
f8988ff276e45effc4/tools/testing/selftests/net/tap
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     sk_bind_=
sendto_listen.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d=
354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/sk_bind_se=
ndto_listen
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     sk_conne=
ct_zero_addr.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d3=
54762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/sk_connect_=
zero_addr
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     socket.c=
  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b=
4cff8988ff276e45effc4/tools/testing/selftests/net/socket
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     nettest.=
c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16=
b4cff8988ff276e45effc4/tools/testing/selftests/net/nettest
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     psock_fa=
nout.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cef=
d3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/psock_fanout
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     psock_tp=
acket.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762ce=
fd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/psock_tpacket
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     msg_zero=
copy.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cef=
d3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/msg_zerocopy
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reusepor=
t_addr_any.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354=
762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/reuseport_add=
r_any
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     tcp_mmap=
.c -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d3547=
62cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/tcp_mmap
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     tcp_inq.=
c -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d35476=
2cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/tcp_inq
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     psock_sn=
d.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e=
16b4cff8988ff276e45effc4/tools/testing/selftests/net/psock_snd
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     txring_o=
verwrite.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d35476=
2cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/txring_overwrit=
e
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     udpgso.c=
  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b=
4cff8988ff276e45effc4/tools/testing/selftests/net/udpgso
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     udpgso_b=
ench_tx.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762=
cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/udpgso_bench_tx
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     udpgso_b=
ench_rx.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762=
cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/udpgso_bench_rx
In file included from /usr/include/error.h:59,
                 from udpgso_bench_rx.c:6:
In function =E2=80=98error=E2=80=99,
    inlined from =E2=80=98do_flush_udp=E2=80=99 at udpgso_bench_rx.c:276:4,
    inlined from =E2=80=98do_recv=E2=80=99 at udpgso_bench_rx.c:375:4,
    inlined from =E2=80=98main=E2=80=99 at udpgso_bench_rx.c:406:2:
/usr/include/x86_64-linux-gnu/bits/error.h:40:5: warning: =E2=80=98gso_size=
=E2=80=99 may be used uninitialized [-Wmaybe-uninitialized]
   40 |     __error_noreturn (__status, __errnum, __format, __va_arg_pack (=
));
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~
udpgso_bench_rx.c: In function =E2=80=98main=E2=80=99:
udpgso_bench_rx.c:253:23: note: =E2=80=98gso_size=E2=80=99 was declared her=
e
  253 |         int ret, len, gso_size, budget =3D 256;
      |                       ^~~~~~~~
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     ip_defra=
g.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e=
16b4cff8988ff276e45effc4/tools/testing/selftests/net/ip_defrag
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     so_txtim=
e.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e=
16b4cff8988ff276e45effc4/tools/testing/selftests/net/so_txtime
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     ipv6_flo=
wlabel.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762c=
efd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/ipv6_flowlabel
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     ipv6_flo=
wlabel_mgr.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354=
762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/ipv6_flowlabe=
l_mgr
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     so_netns=
_cookie.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762=
cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/so_netns_cookie
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     tcp_fast=
open_backup_key.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e=
4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/tcp_fast=
open_backup_key
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     fin_ack_=
lat.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/fin_ack_lat
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reuseadd=
r_ports_exhausted.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-=
0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/reusea=
ddr_ports_exhausted
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     hwtstamp=
_config.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762=
cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/hwtstamp_config
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     rxtimest=
amp.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/rxtimestamp
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     timestam=
ping.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cef=
d3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/timestamping
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     txtimest=
amp.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/txtimestamp
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     ipsec.c =
 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4=
cff8988ff276e45effc4/tools/testing/selftests/net/ipsec
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     ioam6_pa=
rser.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cef=
d3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/ioam6_parser
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     gro.c  -=
o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cf=
f8988ff276e45effc4/tools/testing/selftests/net/gro
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     toeplitz=
.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e1=
6b4cff8988ff276e45effc4/tools/testing/selftests/net/toeplitz
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     cmsg_sen=
der.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/cmsg_sender
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     stress_r=
euseport_listen.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e=
4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/stress_r=
euseport_listen
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     io_uring=
_zerocopy_tx.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d3=
54762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/io_uring_ze=
rocopy_tx
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     bind_bha=
sh.c -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d35=
4762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/bind_bhash
clang -O2 -target bpf -c bpf/nat6to4.c -I../bpf/tools/include -I../../bpf -=
I../../../../lib -I../../../../../usr/include/ -o /usr/src/perf_selftests-x=
86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/te=
sting/selftests/net/bpf/nat6to4.o
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net'
2022-10-02 19:42:09 make install INSTALL_PATH=3D/usr/bin/ -C ../../../tools=
/testing/selftests/net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net'
rsync -a run_netsocktests run_afpackettests test_bpf.sh netdevice.sh rtnetl=
ink.sh xfrm_policy.sh test_blackhole_dev.sh fib_tests.sh fib-onlink-tests.s=
h pmtu.sh udpgso.sh ip_defrag.sh udpgso_bench.sh fib_rule_tests.sh msg_zero=
copy.sh psock_snd.sh udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reus=
eport_addr_any.sh test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.=
sh tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh traceroute.sh fin_ack_l=
at.sh fib_nexthop_multiprefix.sh fib_nexthops.sh fib_nexthop_nongw.sh altna=
mes.sh icmp.sh icmp_redirect.sh ip6_gre_headroom.sh route_localnet.sh reuse=
addr_ports_exhausted.sh txtimestamp.sh vrf-xfrm-tests.sh rxtimestamp.sh dev=
link_port_split.py drop_monitor_tests.sh vrf_route_leaking.sh bareudp.sh am=
t.sh unicast_extensions.sh udpgro_fwd.sh udpgro_frglist.sh veth.sh ioam6.sh=
 gro.sh gre_gso.sh cmsg_so_mark.sh cmsg_time.sh cmsg_ipv6.sh srv6_end_dt46_=
l3vpn_test.sh srv6_end_dt4_l3vpn_test.sh srv6_end_dt6_l3vpn_test.sh srv6_he=
ncap_red_l3vpn_test.sh srv6_hl2encap_red_l2vpn_test.sh vrf_strict_mode_test=
.sh arp_ndisc_evict_nocarrier.sh ndisc_unsolicited_na_test.sh arp_ndisc_unt=
racked_subnets.sh stress_reuseport_listen.sh l2_tos_ttl_inherit.sh bind_bha=
sh.sh test_vxlan_vnifiltering.sh /usr/bin//
rsync -a in_netns.sh setup_loopback.sh setup_veth.sh toeplitz_client.sh toe=
plitz.sh /usr/bin//
rsync -a settings /usr/bin//
rsync -a /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3=
e16b4cff8988ff276e45effc4/tools/testing/selftests/net/reuseport_bpf /usr/sr=
c/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff27=
6e45effc4/tools/testing/selftests/net/reuseport_bpf_cpu /usr/src/perf_selft=
ests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/to=
ols/testing/selftests/net/reuseport_bpf_numa /usr/src/perf_selftests-x86_64=
-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing=
/selftests/net/reuseport_dualstack /usr/src/perf_selftests-x86_64-rhel-8.3-=
kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests=
/net/reuseaddr_conflict /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-=
0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/tls /u=
sr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff898=
8ff276e45effc4/tools/testing/selftests/net/tun /usr/src/perf_selftests-x86_=
64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testi=
ng/selftests/net/tap /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4=
d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/sk_bind_s=
endto_listen /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762c=
efd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/sk_connect_zero_a=
ddr /usr/bin//
rsync -a /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3=
e16b4cff8988ff276e45effc4/tools/testing/selftests/net/bpf/nat6to4.o /usr/bi=
n//
rsync -a /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3=
e16b4cff8988ff276e45effc4/tools/testing/selftests/net/socket /usr/src/perf_=
selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45eff=
c4/tools/testing/selftests/net/nettest /usr/src/perf_selftests-x86_64-rhel-=
8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selft=
ests/net/psock_fanout /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e=
4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/psock_tp=
acket /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16=
b4cff8988ff276e45effc4/tools/testing/selftests/net/msg_zerocopy /usr/src/pe=
rf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45=
effc4/tools/testing/selftests/net/reuseport_addr_any /usr/src/perf_selftest=
s-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools=
/testing/selftests/net/tcp_mmap /usr/src/perf_selftests-x86_64-rhel-8.3-kse=
lftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/ne=
t/tcp_inq /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/psock_snd /usr/src/p=
erf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e4=
5effc4/tools/testing/selftests/net/txring_overwrite /usr/src/perf_selftests=
-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/=
testing/selftests/net/udpgso /usr/src/perf_selftests-x86_64-rhel-8.3-kselft=
ests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/u=
dpgso_bench_tx /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d35476=
2cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/udpgso_bench_rx=
 /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff=
8988ff276e45effc4/tools/testing/selftests/net/ip_defrag /usr/src/perf_selft=
ests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/to=
ols/testing/selftests/net/so_txtime /usr/src/perf_selftests-x86_64-rhel-8.3=
-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftest=
s/net/ipv6_flowlabel /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4=
d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/ipv6_flow=
label_mgr /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/so_netns_cookie /usr=
/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988f=
f276e45effc4/tools/testing/selftests/net/tcp_fastopen_backup_key /usr/src/p=
erf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e4=
5effc4/tools/testing/selftests/net/fin_ack_lat /usr/src/perf_selftests-x86_=
64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testi=
ng/selftests/net/reuseaddr_ports_exhausted /usr/src/perf_selftests-x86_64-r=
hel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/s=
elftests/net/hwtstamp_config /usr/src/perf_selftests-x86_64-rhel-8.3-kselft=
ests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/r=
xtimestamp /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cef=
d3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/timestamping /usr/s=
rc/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff2=
76e45effc4/tools/testing/selftests/net/txtimestamp /usr/src/perf_selftests-=
x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/t=
esting/selftests/net/ipsec /usr/src/perf_selftests-x86_64-rhel-8.3-kselftes=
ts-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/ioa=
m6_parser /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd=
3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/gro /usr/src/perf_se=
lftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4=
/tools/testing/selftests/net/toeplitz /usr/src/perf_selftests-x86_64-rhel-8=
.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selfte=
sts/net/cmsg_sender /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d=
354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/stress_reu=
seport_listen /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762=
cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/io_uring_zerocop=
y_tx /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b=
4cff8988ff276e45effc4/tools/testing/selftests/net/bind_bhash /usr/bin//
rsync -a config settings /usr/bin//
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net'
2022-10-02 19:42:09 make -C net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net'
make: Nothing to be done for 'all'.
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net'
2022-10-02 19:42:09 make quicktest=3D1 run_tests -C net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net'
TAP version 13
1..2
# selftests: net: nat6to4.o
# Warning: file /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d3547=
62cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net/bpf/nat6to4.o =
is not executable
not ok 1 selftests: net: nat6to4.o
# selftests: net: fcnal-test.sh
# SYSCTL: net.ipv4.udp_early_demux=3D1
#=20
#=20
# #########################################################################=
##
# IPv6/UDP
# #########################################################################=
##
#=20
#=20
# #################################################################
# No VRF
#=20
#=20
# #################################################################
# udp_l3mdev_accept disabled
#=20
# SYSCTL: net.ipv4.udp_l3mdev_accept=3D0
#=20
# TEST: Global server - ns-A IPv6                                          =
     [ OK ]
# TEST: Device server - ns-A IPv6                                          =
     [ OK ]
# TEST: Global server - ns-A IPv6 LLA                                      =
     [ OK ]
# TEST: Device server - ns-A IPv6 LLA                                      =
     [ OK ]
# TEST: Global server - ns-A loopback IPv6                                 =
     [ OK ]
# TEST: No server - ns-A IPv6                                              =
     [ OK ]
# TEST: No server - ns-A loopback IPv6                                     =
     [ OK ]
# TEST: No server - ns-A IPv6 LLA                                          =
     [ OK ]
# TEST: Client - ns-B IPv6                                                 =
     [ OK ]
# TEST: Client, device bind - ns-B IPv6                                    =
     [ OK ]
# TEST: Client, device send via cmsg - ns-B IPv6                           =
     [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6                =
     [ OK ]
# TEST: No server, unbound client - ns-B IPv6                              =
     [ OK ]
# TEST: No server, device client - ns-B IPv6                               =
     [ OK ]
# TEST: Client - ns-B loopback IPv6                                        =
     [ OK ]
# TEST: Client, device bind - ns-B loopback IPv6                           =
     [ OK ]
# TEST: Client, device send via cmsg - ns-B loopback IPv6                  =
     [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B loopback IPv6       =
     [ OK ]
# TEST: No server, unbound client - ns-B loopback IPv6                     =
     [ OK ]
# TEST: No server, device client - ns-B loopback IPv6                      =
     [ OK ]
# TEST: Client - ns-B IPv6 LLA                                             =
     [ OK ]
# TEST: Client, device bind - ns-B IPv6 LLA                                =
     [ OK ]
# TEST: Client, device send via cmsg - ns-B IPv6 LLA                       =
     [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6 LLA            =
     [ OK ]
# TEST: No server, unbound client - ns-B IPv6 LLA                          =
     [ OK ]
# TEST: No server, device client - ns-B IPv6 LLA                           =
     [ OK ]
# TEST: Global server, local connection - ns-A IPv6                        =
     [ OK ]
# TEST: Global server, local connection - ns-A loopback IPv6               =
     [ OK ]
# TEST: Global server, local connection - IPv6 loopback                    =
     [ OK ]
# TEST: Device server, unbound client, local connection - ns-A IPv6        =
     [ OK ]
# TEST: Device server, local connection - ns-A loopback IPv6               =
     [ OK ]
# TEST: Device server, local connection - IPv6 loopback                    =
     [ OK ]
# TEST: Global server, device client, local connection - ns-A IPv6         =
     [ OK ]
# TEST: Global server, device send via cmsg, local connection - ns-A IPv6  =
     [ OK ]
# TEST: Global server, device client via IPV6_UNICAST_IF, local connection =
- ns-A IPv6  [ OK ]
# TEST: Global server, device client, local connection - ns-A loopback IPv6=
     [ OK ]
# TEST: Global server, device send via cmsg, local connection - ns-A loopba=
ck IPv6  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection - =
ns-A loopback IPv6  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection, w=
ith connect() - ns-A loopback IPv6  [FAIL]
# TEST: Global server, device client, local connection - IPv6 loopback     =
     [ OK ]
# TEST: Global server, device send via cmsg, local connection - IPv6 loopba=
ck   [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection - =
IPv6 loopback  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection, w=
ith connect() - IPv6 loopback  [ OK ]
# TEST: Device server, device client, local conn - ns-A IPv6               =
     [ OK ]
# TEST: No server, device client, local conn - ns-A IPv6                   =
     [ OK ]
# TEST: UDP in - LLA to GUA                                                =
     [ OK ]
#=20
# #################################################################
# udp_l3mdev_accept enabled
#=20
# SYSCTL: net.ipv4.udp_l3mdev_accept=3D1
#=20
# TEST: Global server - ns-A IPv6                                          =
     [ OK ]
# TEST: Device server - ns-A IPv6                                          =
     [ OK ]
# TEST: Global server - ns-A IPv6 LLA                                      =
     [ OK ]
# TEST: Device server - ns-A IPv6 LLA                                      =
     [ OK ]
# TEST: Global server - ns-A loopback IPv6                                 =
     [ OK ]
# TEST: No server - ns-A IPv6                                              =
     [ OK ]
# TEST: No server - ns-A loopback IPv6                                     =
     [ OK ]
# TEST: No server - ns-A IPv6 LLA                                          =
     [ OK ]
# TEST: Client - ns-B IPv6                                                 =
     [ OK ]
# TEST: Client, device bind - ns-B IPv6                                    =
     [ OK ]
# TEST: Client, device send via cmsg - ns-B IPv6                           =
     [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6                =
     [ OK ]
# TEST: No server, unbound client - ns-B IPv6                              =
     [ OK ]
# TEST: No server, device client - ns-B IPv6                               =
     [ OK ]
# TEST: Client - ns-B loopback IPv6                                        =
     [ OK ]
# TEST: Client, device bind - ns-B loopback IPv6                           =
     [ OK ]
# TEST: Client, device send via cmsg - ns-B loopback IPv6                  =
     [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B loopback IPv6       =
     [ OK ]
# TEST: No server, unbound client - ns-B loopback IPv6                     =
     [ OK ]
# TEST: No server, device client - ns-B loopback IPv6                      =
     [ OK ]
# TEST: Client - ns-B IPv6 LLA                                             =
     [ OK ]
# TEST: Client, device bind - ns-B IPv6 LLA                                =
     [ OK ]
# TEST: Client, device send via cmsg - ns-B IPv6 LLA                       =
     [ OK ]
# TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6 LLA            =
     [ OK ]
# TEST: No server, unbound client - ns-B IPv6 LLA                          =
     [ OK ]
# TEST: No server, device client - ns-B IPv6 LLA                           =
     [ OK ]
# TEST: Global server, local connection - ns-A IPv6                        =
     [ OK ]
# TEST: Global server, local connection - ns-A loopback IPv6               =
     [ OK ]
# TEST: Global server, local connection - IPv6 loopback                    =
     [ OK ]
# TEST: Device server, unbound client, local connection - ns-A IPv6        =
     [ OK ]
# TEST: Device server, local connection - ns-A loopback IPv6               =
     [ OK ]
# TEST: Device server, local connection - IPv6 loopback                    =
     [ OK ]
# TEST: Global server, device client, local connection - ns-A IPv6         =
     [ OK ]
# TEST: Global server, device send via cmsg, local connection - ns-A IPv6  =
     [ OK ]
# TEST: Global server, device client via IPV6_UNICAST_IF, local connection =
- ns-A IPv6  [ OK ]
# TEST: Global server, device client, local connection - ns-A loopback IPv6=
     [ OK ]
# TEST: Global server, device send via cmsg, local connection - ns-A loopba=
ck IPv6  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection - =
ns-A loopback IPv6  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection, w=
ith connect() - ns-A loopback IPv6  [FAIL]
# TEST: Global server, device client, local connection - IPv6 loopback     =
     [ OK ]
# TEST: Global server, device send via cmsg, local connection - IPv6 loopba=
ck   [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection - =
IPv6 loopback  [ OK ]
# TEST: Global server, device client via IP_UNICAST_IF, local connection, w=
ith connect() - IPv6 loopback  [ OK ]
# TEST: Device server, device client, local conn - ns-A IPv6               =
     [ OK ]
# TEST: No server, device client, local conn - ns-A IPv6                   =
     [ OK ]
# TEST: UDP in - LLA to GUA                                                =
     [ OK ]
#=20
# #################################################################
# With VRF
#=20
#=20
# #################################################################
# Global server disabled
#=20
# SYSCTL: net.ipv4.udp_l3mdev_accept=3D0
#=20
# TEST: Global server - ns-A IPv6                                          =
     [ OK ]
# TEST: Global server - VRF IPv6                                           =
     [ OK ]
# TEST: VRF server - ns-A IPv6                                             =
     [ OK ]
# TEST: VRF server - VRF IPv6                                              =
     [ OK ]
# TEST: Enslaved device server - ns-A IPv6                                 =
     [ OK ]
# TEST: Enslaved device server - VRF IPv6                                  =
     [ OK ]
# TEST: No server - ns-A IPv6                                              =
     [ OK ]
# TEST: No server - VRF IPv6                                               =
     [ OK ]
# TEST: Global server, VRF client, local conn - ns-A IPv6                  =
     [ OK ]
# TEST: Global server, VRF client, local conn - VRF IPv6                   =
     [ OK ]
# TEST: VRF server, VRF client, local conn - ns-A IPv6                     =
     [ OK ]
# TEST: VRF server, VRF client, local conn - VRF IPv6                      =
     [ OK ]
# TEST: Global server, device client, local conn - ns-A IPv6               =
     [ OK ]
# TEST: VRF server, device client, local conn - ns-A IPv6                  =
     [ OK ]
# TEST: Enslaved device server, VRF client, local conn - ns-A IPv6         =
     [ OK ]
# TEST: Enslaved device server, device client, local conn - ns-A IPv6      =
     [ OK ]
#=20
# #################################################################
# Global server enabled
#=20
# SYSCTL: net.ipv4.udp_l3mdev_accept=3D1
#=20
# TEST: Global server - ns-A IPv6                                          =
     [ OK ]
# TEST: Global server - VRF IPv6                                           =
     [ OK ]
# TEST: VRF server - ns-A IPv6                                             =
     [ OK ]
# TEST: VRF server - VRF IPv6                                              =
     [ OK ]
# TEST: Enslaved device server - ns-A IPv6                                 =
     [ OK ]
# TEST: Enslaved device server - VRF IPv6                                  =
     [ OK ]
# TEST: No server - ns-A IPv6                                              =
     [ OK ]
# TEST: No server - VRF IPv6                                               =
     [ OK ]
# TEST: VRF client                                                         =
     [ OK ]
# TEST: No server, VRF client                                              =
     [ OK ]
# TEST: Enslaved device client                                             =
     [ OK ]
# TEST: No server, enslaved device client                                  =
     [ OK ]
# TEST: Global server, VRF client, local conn - ns-A IPv6                  =
     [ OK ]
# TEST: VRF server, VRF client, local conn - ns-A IPv6                     =
     [ OK ]
# TEST: Global server, VRF client, local conn - VRF IPv6                   =
     [ OK ]
# TEST: VRF server, VRF client, local conn - VRF IPv6                      =
     [ OK ]
# TEST: No server, VRF client, local conn - ns-A IPv6                      =
     [ OK ]
# TEST: No server, VRF client, local conn - VRF IPv6                       =
     [ OK ]
# TEST: Global server, device client, local conn - ns-A IPv6               =
     [ OK ]
# TEST: VRF server, device client, local conn - ns-A IPv6                  =
     [ OK ]
# TEST: Device server, VRF client, local conn - ns-A IPv6                  =
     [ OK ]
# TEST: Device server, device client, local conn - ns-A IPv6               =
     [ OK ]
# TEST: No server, device client, local conn - ns-A IPv6                   =
     [ OK ]
# TEST: Global server, linklocal IP                                        =
     [ OK ]
# TEST: No server, linklocal IP                                            =
     [ OK ]
# TEST: Enslaved device client, linklocal IP                               =
     [ OK ]
# TEST: No server, device client, peer linklocal IP                        =
     [ OK ]
# TEST: Enslaved device client, local conn - linklocal IP                  =
     [ OK ]
# TEST: No server, device client, local conn  - linklocal IP               =
     [ OK ]
# TEST: UDP in - LLA to GUA                                                =
     [ OK ]
#=20
# Tests passed: 136
# Tests failed:   2
not ok 2 selftests: net: fcnal-test.sh # exit=3D1
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-0e4d354762cefd3e16b4cff8988ff276e45effc4/tools/testing/selftests/net'

--FxTqW4ihe4HI1nwj
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/kernel-selftests-bm.yaml
suite: kernel-selftests
testcase: kernel-selftests
category: functional
kernel-selftests:
  group: net
  test: fcnal-test.sh
  atomic_test: ipv6_udp
job_origin: kernel-selftests-bm.yaml

#! queue options
queue_cmdline_keys:
- branch
- commit
queue: bisect
testbox: lkp-skl-d01
tbox_group: lkp-skl-d01
submit_id: 6338f77a327459bc4a78b9e6
job_file: "/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-ipv6_udp-net-fcnal-test.sh-debian-12-x86_64-20220629.cgz-0e4d354762cefd3e16b4cff8988ff276e45effc4-20221002-48202-1rrfnez-0.yaml"
id: 781fe99451b912b79b95832685ac7c335f1b9104
queuer_version: "/zday/lkp"

#! hosts/lkp-skl-d01
model: Skylake
nr_cpu: 8
memory: 28G
nr_ssd_partitions: 1
nr_hdd_partitions: 4
hdd_partitions: "/dev/disk/by-id/wwn-0x50014ee20d26b072-part*"
ssd_partitions: "/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part1"
swap_partitions: "/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part3"
rootfs_partition: "/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part2"
brand: Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz
cpu_info: skylake i7-6700
bios_version: 1.2.8

#! include/category/functional
kmsg:
heartbeat:
meminfo:

#! include/queue/cyclic
commit: 0e4d354762cefd3e16b4cff8988ff276e45effc4

#! include/testbox/lkp-skl-d01
need_kconfig_hw:
- PTP_1588_CLOCK: y
- E1000E: y
- SATA_AHCI
- DRM_I915
ucode: '0xf0'
bisect_dmesg: true

#! include/kernel-selftests
need_kconfig:
- PACKET: y
- USER_NS: y
- BPF_SYSCALL: y
- TEST_BPF: m
- NUMA: y, v5.6-rc1
- NET_VRF: y, v4.3-rc1
- NET_L3_MASTER_DEV: y, v4.4-rc1
- IPV6: y
- IPV6_MULTIPLE_TABLES: y
- VETH: y
- NET_IPVTI: m
- IPV6_VTI: m
- DUMMY: y
- BRIDGE: y
- VLAN_8021Q: y
- IFB
- NETFILTER: y
- NETFILTER_ADVANCED: y
- NF_CONNTRACK: m
- NF_NAT: m, v5.1-rc1
- IP6_NF_IPTABLES: m
- IP_NF_IPTABLES: m
- IP6_NF_NAT: m
- IP_NF_NAT: m
- NF_TABLES: m
- NF_TABLES_IPV6: y, v4.17-rc1
- NF_TABLES_IPV4: y, v4.17-rc1
- NFT_CHAIN_NAT_IPV6: m, <= v5.0
- NFT_TPROXY: m, v4.19-rc1
- NFT_COUNTER: m, <= v5.16-rc4
- NFT_CHAIN_NAT_IPV4: m, <= v5.0
- NET_SCH_FQ: m
- NET_SCH_ETF: m, v4.19-rc1
- NET_SCH_NETEM: y
- TEST_BLACKHOLE_DEV: m, v5.3-rc1
- KALLSYMS: y
- BAREUDP: m, v5.7-rc1
- MPLS_ROUTING: m, v4.1-rc1
- MPLS_IPTUNNEL: m, v4.3-rc1
- NET_SCH_INGRESS: y, v4.19-rc1
- NET_CLS_FLOWER: m, v4.2-rc1
- NET_ACT_TUNNEL_KEY: m, v4.9-rc1
- NET_ACT_MIRRED: m, v5.11-rc1
- CRYPTO_SM4: y, v4.17-rc1
- CRYPTO_SM4_GENERIC: y, v5.19-rc1
- NET_DROP_MONITOR
- TRACEPOINTS
- AMT: m, v5.16-rc1
- IPV6_IOAM6_LWTUNNEL: y, v5.15
rootfs: debian-12-x86_64-20220629.cgz
initrds:
- linux_headers
- linux_selftests
kconfig: x86_64-rhel-8.3-kselftests
enqueue_time: 2022-10-02 10:29:14.539409475 +08:00
_id: 6338f77a327459bc4a78b9e6
_rt: "/result/kernel-selftests/ipv6_udp-net-fcnal-test.sh/lkp-skl-d01/debian-12-x86_64-20220629.cgz/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4"

#! schedule options
user: lkp
compiler: gcc-11
LKP_SERVER: internal-lkp-server
head_commit: 89934960fa96984efcbc93940a25ecd69b48de4f
base_commit: f76349cf41451c5c42a99f18a9163377e4b364ff
branch: linux-devel/devel-hourly-20220929-052228
result_root: "/result/kernel-selftests/ipv6_udp-net-fcnal-test.sh/lkp-skl-d01/debian-12-x86_64-20220629.cgz/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/0"
scheduler_version: "/lkp/lkp/src"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-12-x86_64-20220629.cgz"
bootloader_append:
- root=/dev/ram0
- RESULT_ROOT=/result/kernel-selftests/ipv6_udp-net-fcnal-test.sh/lkp-skl-d01/debian-12-x86_64-20220629.cgz/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/0
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/vmlinuz-6.0.0-rc2-00573-g0e4d354762ce
- branch=linux-devel/devel-hourly-20220929-052228
- job=/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-ipv6_udp-net-fcnal-test.sh-debian-12-x86_64-20220629.cgz-0e4d354762cefd3e16b4cff8988ff276e45effc4-20221002-48202-1rrfnez-0.yaml
- user=lkp
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3-kselftests
- commit=0e4d354762cefd3e16b4cff8988ff276e45effc4
- max_uptime=2100
- LKP_SERVER=internal-lkp-server
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw

#! runtime status
modules_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/modules.cgz"
linux_headers_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/linux-headers.cgz"
linux_selftests_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/linux-selftests.cgz"
bm_initrd: "/osimage/deps/debian-12-x86_64-20220629.cgz/run-ipconfig_20220629.cgz,/osimage/deps/debian-12-x86_64-20220629.cgz/lkp_20220629.cgz,/osimage/deps/debian-12-x86_64-20220629.cgz/rsync-rootfs_20220629.cgz,/osimage/deps/debian-12-x86_64-20220629.cgz/kernel-selftests_20220927.cgz,/osimage/pkg/debian-12-x86_64-20220629.cgz/kernel-selftests-x86_64-700a8991-1_20220823.cgz,/osimage/deps/debian-12-x86_64-20220629.cgz/hw_20220629.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20220804.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /db/releases/20220930113029/lkp-src/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer:
watchdog:
last_kernel: 6.0.0-rc4-01108-gc3194a67149f
schedule_notify_address:

#! user overrides
kernel: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/0e4d354762cefd3e16b4cff8988ff276e45effc4/vmlinuz-6.0.0-rc2-00573-g0e4d354762ce"
dequeue_time: 2022-10-02 10:54:43.944866039 +08:00

#! /db/releases/20221001004130/lkp-src/include/site/inn
job_state: finished
loadavg: 0.23 0.41 0.48 2/168 19904
start_time: '1664679459'
end_time: '1664680325'
version: "/lkp/lkp/.src-20221001-230556:450b29f71:37fc623e4"

--FxTqW4ihe4HI1nwj
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="reproduce"

mount --bind /lib/modules/6.0.0-rc2-00573-g0e4d354762ce/kernel/lib /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-0e4d354762cefd3e16b4cff8988ff276e45effc4/lib
ln -sf /usr/sbin/iptables-nft /usr/bin/iptables
ln -sf /usr/sbin/ip6tables-nft /usr/bin/ip6tables
sed -i s/default_timeout=45/default_timeout=300/ kselftest/runner.sh
make -C bpf
make -C ../../../tools/testing/selftests/net
make install INSTALL_PATH=/usr/bin/ -C ../../../tools/testing/selftests/net
make -C net
make quicktest=1 run_tests -C net

--FxTqW4ihe4HI1nwj--
