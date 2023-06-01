Return-Path: <netdev+bounces-6993-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFDF27192BA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3971C2815D8
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DFC46FC4;
	Thu,  1 Jun 2023 05:52:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEEE1C07;
	Thu,  1 Jun 2023 05:52:08 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD041701;
	Wed, 31 May 2023 22:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685598698; x=1717134698;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=cNQ+LY/qaJuMaZ+0hOiLcn1X/islYilRAsa9FRyesjA=;
  b=n5fMhegXUzH7yuobo8j5mpU3bXxyKHrglVjJzPj42P4rVjAmEX3cHGVN
   qUuwe6JjstaPqvIISXkKH2NTLZhvlyFF+ypG507jOVUOvs8xTBMx42UrO
   ttDb+gIsw54RYAMxHkpsTC5eWtsv67n5aFj1QHTTODLiMZOxtFwv4sXCq
   VlhgdhZ0AQOZ3qvqhgrG2oR1LmfXdCVj6b160ad2uU8fCtVBVZ0KDrHL8
   MjHxEt/Lm7vnwGxBQLGLRwQWYhg52IbAmJxrreDuFEVJINE9UZ7PWLotL
   hq2HdX9sWARsQ27DvDz2hDSJOsg8OLl8ROHjO62eyqNcpAuTIbkARgQKS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="441819579"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="441819579"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 22:50:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="831453440"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="831453440"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 31 May 2023 22:50:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 22:50:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 22:50:10 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 22:50:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNNnYiNz9YdNnGXr4n7iEYob+ZTzsKxNno9NQToDDJaClzlyfYcY8kiJmoeEUKhEyoB/Htf7DzKJMNXZU/UPrr5B/k4Mv4K3kiY9FUtMkcygsbDeLYiT3kUUp4fYmHnNnsnmdxjf+u+eUbEFoZjX1SkBxhgii6a1maduXeKK9rTINkMcC2eoppkj9rRY+bgqaL36evAsy1mkOIZNg2YIk+6MemwkS35/zqnC04rO7s+in3DOAr+j/rSZmTJpVmwzmvcTsXnAWbEEat3DHXmt50RAQ8V9eQnkG4+w44yhJogyExmneqBxYBUxZ4ltu7LOpoZocyy07MOWQ12o6VZNqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=exJH8riCzph/yTOEDJKO2i75eifr+sUmMJeHzyrPLnc=;
 b=X2t6tPKJb1GzBoX5aPx3mRqdLr/yCWea+jMaDZZUtIUbhcuimtGjGoEnz/rN+N1G5yVdx/CVp8VXEyATz5zaw7MOHqJiCN+B8cDOQimGAp1x4OUUeNpzqzEFcGDGFQkL0yVlRSZjZdddco2uT/WCMuBvudJlIhhPedxNqWYRtD1p+WoSaxsNfncM4BcYkRYvODsudz0kGhqeT84uYrkZkGtf090jiru9G3f+vBV5FRBWo9JKT9OG39wu58e40GMzqOBDwpPvlh88nHJuvOFU49hQjKN+1PbDcDkmoIa/hmxkw7J+WLLpn8tWInlrXscLN0X6Dl+xpn91f3/orCaRcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by CO1PR11MB5188.namprd11.prod.outlook.com (2603:10b6:303:95::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 1 Jun
 2023 05:50:08 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::b14b:5c9c:fa0e:8e7c]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::b14b:5c9c:fa0e:8e7c%7]) with mapi id 15.20.6433.022; Thu, 1 Jun 2023
 05:50:08 +0000
Date: Thu, 1 Jun 2023 13:46:54 +0800
From: kernel test robot <yujie.liu@intel.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, <bpf@vger.kernel.org>,
	<ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC: <oe-kbuild-all@lists.linux.dev>, <netdev@vger.kernel.org>,
	<magnus.karlsson@intel.com>, <tirthendu.sarkar@intel.com>,
	<maciej.fijalkowski@intel.com>, <bjorn@kernel.org>
Subject: Re: [PATCH v2 bpf-next 17/22] selftests/xsk: add basic multi-buffer
 test
Message-ID: <202305200620.ZTVLUbDI-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230529155024.222213-18-maciej.fijalkowski@intel.com>
X-ClientProxiedBy: SG2PR01CA0121.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::25) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|CO1PR11MB5188:EE_
X-MS-Office365-Filtering-Correlation-Id: ceb8d713-bf15-47ed-d7e3-08db62640e27
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ovmWgjEwFnQ/OBXucOzjtmQt27C6jWqL+jJlWF1oDdWPmWfK8CeXjLOUbjkn4JY+janbvyKmJkTDtvz+X7oxjKObYZeghtt5+uOZke0maOoFCZuLzB3kPHfCSMu7v5xkBlOGVJODureezlVPDxR3gzPO+398f7pVw0dM1NPdNqAkOMD2YN7scEQYsWZ7s2I1dmCM68B9/jdsEN3uEcTplkHed/coQbdC9GWt8aQqnQOm+MWo2qU4GYoTl1XDlT/83CKu2Rxr8YNQOl7O+x39UalFCO9y+UgONvoTqmQFXrmoWrMMjlrjMLxgjAZ+OWeKQRJiXYN/AoDhq0zXSGQljEoAGheV7sSApusZWyNOssF2XRL/mun1ogc7heDUYWjji4O7ifQtLoWZqvHZaxnHiGtoJQXkTmE9T+bq0+VvEj8oLty7Ncm2MWNLNRHTtkB7QnbO8sggm3CFAmDjjGonQxrW+q+reGiDxM3RJ1ipDiQZqbw7CAzPmZ0z+lSmCB+w/5fvcIausVX5uvnhEhswgjs8tKYW1xl5rg8hmv94fyZ9q/gZw3huYdDmEq8gj/xB3dv4HhQaUL8HNmLSVFd1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199021)(5660300002)(8936002)(8676002)(6486002)(966005)(38100700002)(478600001)(6666004)(316002)(41300700001)(66476007)(66946007)(66556008)(4326008)(82960400001)(36756003)(186003)(83380400001)(86362001)(2616005)(2906002)(6512007)(1076003)(26005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eamsvlTgqCO/1hdyLwo5qnJY9dF8tYf8rOhBU5QH8QCNn841D1RBzLxpQPnE?=
 =?us-ascii?Q?7RhDUikzscw4heOdHl5MBAXXi7CDT6QW8CDTMdK/VrT1nkoaZkBf2VZFKKNn?=
 =?us-ascii?Q?0IKbppXzutPx8NCjo9frDqUL2LelKmQ8VW080Oxe+KVMXWCszlOv6CIWgHgZ?=
 =?us-ascii?Q?qbsY2jXW+qgjoN6sAoBZ5jSvogPzEnmljoS/79im8I1vA/B6KIvUZd88x+8n?=
 =?us-ascii?Q?6GU77QNDDJde9KybOgoizoGNnKSsR+IBJM9qj0wcZY0gwVOhtzAYON2jz9ph?=
 =?us-ascii?Q?tL8d49aELUGC9Y7w2KmyHfLCV66caP/XHTbGOZU7dnFXbh2k4XsS/9HyaAk2?=
 =?us-ascii?Q?lvEKhsTIjfHiAj/GZGvndOjKGTyMzQQAAxvn8iQRcC8eb+7Uaa6M1Tzmbeeb?=
 =?us-ascii?Q?7PCg9YbpKGoGpXblm6Jtn2uwPzGDZKc9ELS6vikOdOPkMEOOcIvQDfVjgBRw?=
 =?us-ascii?Q?ykPcegRUetuphL3QgGtxgsQ+LbQU0kXoBq490ES7/ZBGlYGw6PoAfhMnPMt+?=
 =?us-ascii?Q?tSahH8dAamPcglUE70ccGEkr2CKkRpVq5PmdvIkshiXlNNaaxocQz5GCL2em?=
 =?us-ascii?Q?+7SS860bJVLuEOfJ45rlqQYaCAP8gzeDXJYoipYWt9Ep/w/yo6EzCF4grmr1?=
 =?us-ascii?Q?NgVrAwjQA1a9LVvLYMjq83vZnueGIUGOBSkzEazwil16agvfm1ZQxesQz6ir?=
 =?us-ascii?Q?JOK68pseJiQhjUd1UGsXuwneoHPTwrljUpK3YqCdC+i9hEmU5J2Baf3kUSKV?=
 =?us-ascii?Q?MMDbLBue/bP2Die8KKes2UV0YRx9JT+t0qKEnQg8MMeRtbuS9tXcwjFwRK64?=
 =?us-ascii?Q?yJIazxFJHPzdphSdR0vSdAbIgKLuc+dJn097mbcm1nhb/r9Vs1JxIkT0to3W?=
 =?us-ascii?Q?8r797H3qc1HAuWp8reAYDnknbEsU9ytJfrQfMJ6fpZX8EnPFIq9T9K05OxS5?=
 =?us-ascii?Q?pYQvMmFl7EqzwMI2PMgRXjoxHyOeYEkgq2x4KChOzYI8MPy9mxArYhfR7NPR?=
 =?us-ascii?Q?eSifbfTIF7dApyP2eGdmsjPY+cwNaBGIY7r/Hy9mlC8PgdDkweUoib381SVR?=
 =?us-ascii?Q?/9O675iDpfqxMwTwslO7OxaXFRcLg52XY9t9V1E4K3FmvZLX5dlcBKhfeb8Q?=
 =?us-ascii?Q?HQFbdiWx53EnTQ39gpseAxx2UikxTOGpcR6Nca9FudGc8CUcHVz9r4/fs5d/?=
 =?us-ascii?Q?If4va/sNvcjiz6Dwinf+xrdCy9Yp+kxNyMusjKU7UeCsqvIRI2eBIxQQ+ML/?=
 =?us-ascii?Q?cZt83GO28u+sGJk7XP0nagVJW8SvPOH5PmOwLiYdDfGAs1l71G+yUJ9ho3AS?=
 =?us-ascii?Q?//Stmh9TRDYYQDbCAak8R7NgB3SsTv4w6lYcDmHvZvTM6KxleDuLH6RfVIrA?=
 =?us-ascii?Q?VvDNDKJ4WudEC0KdXLcKF7fwNhUFtzdg1/QObYX/6W0i5K9/T1Oi7+Nt1mJu?=
 =?us-ascii?Q?u9XNJZZBcHrfrU+s6kILu9wGIG93kAtA46P6vGcT5GMCUGLjYKptG6odbPNv?=
 =?us-ascii?Q?klW34g3Zj3APWiTT/dMgRWgNGa6diKz7D0ydQ9nrO9rbCwiJO/uTbZhSnNwm?=
 =?us-ascii?Q?05l+mkjd8IpfeJqQDXMPXrtjFhSR/58GFzxosCaE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ceb8d713-bf15-47ed-d7e3-08db62640e27
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 05:50:07.9790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3iCjhHmslfB2oklCT5augdwuKTBL8FxWY/O8P8J1nWVZ1uD/+QBTc2hlr6V670Xmi0kX2tf80U+z7dfbYYPG1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5188
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Maciej,

kernel test robot noticed the following build warnings:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Maciej-Fijalkowski/xsk-prepare-options-in-xdp_desc-for-multi-buffer-use/20230530-000151
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/20230529155024.222213-18-maciej.fijalkowski@intel.com
patch subject: [PATCH v2 bpf-next 17/21] selftests/xsk: add basic multi-buffer test
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305200620.ZTVLUbDI-lkp@intel.com/

includecheck warnings: (new ones prefixed by >>)
>> tools/testing/selftests/bpf/xsk.c: linux/if_link.h is included more than once.

1cad078842396 tools/lib/bpf/xsk.c               (Magnus Karlsson         2019-02-21 10:21:26 +0100  19) #include <linux/filter.h>
1cad078842396 tools/lib/bpf/xsk.c               (Magnus Karlsson         2019-02-21 10:21:26 +0100  20) #include <linux/if_ether.h>
10392a6fa0806 tools/testing/selftests/bpf/xsk.c (Magnus Karlsson         2023-05-29 17:50:19 +0200 @21) #include <linux/if_link.h>
1cad078842396 tools/lib/bpf/xsk.c               (Magnus Karlsson         2019-02-21 10:21:26 +0100  22) #include <linux/if_packet.h>
1cad078842396 tools/lib/bpf/xsk.c               (Magnus Karlsson         2019-02-21 10:21:26 +0100  23) #include <linux/if_xdp.h>
d317b0a8acfc4 tools/lib/bpf/xsk.c               (Yonghong Song           2020-09-14 15:32:10 -0700  24) #include <linux/kernel.h>
2f6324a3937f8 tools/lib/bpf/xsk.c               (Magnus Karlsson         2020-08-28 10:26:27 +0200  25) #include <linux/list.h>
10392a6fa0806 tools/testing/selftests/bpf/xsk.c (Magnus Karlsson         2023-05-29 17:50:19 +0200  26) #include <linux/netlink.h>
10392a6fa0806 tools/testing/selftests/bpf/xsk.c (Magnus Karlsson         2023-05-29 17:50:19 +0200  27) #include <linux/rtnetlink.h>
1cad078842396 tools/lib/bpf/xsk.c               (Magnus Karlsson         2019-02-21 10:21:26 +0100  28) #include <linux/sockios.h>
1cad078842396 tools/lib/bpf/xsk.c               (Magnus Karlsson         2019-02-21 10:21:26 +0100  29) #include <net/if.h>
1cad078842396 tools/lib/bpf/xsk.c               (Magnus Karlsson         2019-02-21 10:21:26 +0100  30) #include <sys/ioctl.h>
1cad078842396 tools/lib/bpf/xsk.c               (Magnus Karlsson         2019-02-21 10:21:26 +0100  31) #include <sys/mman.h>
1cad078842396 tools/lib/bpf/xsk.c               (Magnus Karlsson         2019-02-21 10:21:26 +0100  32) #include <sys/socket.h>
1cad078842396 tools/lib/bpf/xsk.c               (Magnus Karlsson         2019-02-21 10:21:26 +0100  33) #include <sys/types.h>
10397994d30f2 tools/lib/bpf/xsk.c               (Maciej Fijalkowski      2021-03-30 00:43:05 +0200 @34) #include <linux/if_link.h>
1cad078842396 tools/lib/bpf/xsk.c               (Magnus Karlsson         2019-02-21 10:21:26 +0100  35)


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


