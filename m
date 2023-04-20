Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444126E89BE
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjDTFuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjDTFuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:50:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25A83C2A;
        Wed, 19 Apr 2023 22:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681969826; x=1713505826;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=Pe9RiYQudNTtjS1so2BmJeCB6RgZmknfx7FpNqujYtg=;
  b=bkPuFyXIkl1p2an785NJ6W6GvfQ7tlQhRukHrrve6NwIVsPs32DGhbTI
   yA4TVFMvHSuFidb6iXkLiAUU/wW3v6HEnGPojpFeLFGCVV6LdippW9U7r
   ZNbjnmcJXlfG9H5WKMQo2nZmM4OhiB/BkkZIV53ZzKj4dkCVRT2pUdDAg
   8jF8Rs691qOwvadn1Z7zjj8zB2/k3V6bg5IuEO4/wacEDAUdBuvi1oyys
   qFr+yU2D0nnJfZPjlExbAFyAjOwGqDiesGlLHdbS/GhW9xidfHaNCSFTM
   y/K1NpTpqGV4ea0hSzGo7V+nhjEOvPFjCszFsXNNH0CEBOS0ZntDDvkHo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="334461594"
X-IronPort-AV: E=Sophos;i="5.99,211,1677571200"; 
   d="yaml'?scan'208";a="334461594"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 22:50:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="835581712"
X-IronPort-AV: E=Sophos;i="5.99,211,1677571200"; 
   d="yaml'?scan'208";a="835581712"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 19 Apr 2023 22:50:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 22:50:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 22:50:23 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 22:50:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nojc7SVgM2uRPGzpu4GwJWaKd//yhWto8x+nJJ7vP8pApDcQ8XRYyEwOFHI6f75nTyxgb1GRZfTXqp5D3b6MgpGg0bG/Y/FAX5/05cCD7fR9eeeFlv0xkaGhf9mL51y+8obo3SvfBLvua2IPvJdKoZ8NLW+K7bukGKZ8pM2YiAqHALIKw2u8JD/lJ4Ix9Kf/t5qeLkQ99miWm0SomuKlTI8+MbdR5pUykengEOkwUcr3zGk89CZUSBrLvMVigeuTYLJsk+nE/ShZ2i6+SFkSGfcVrsTJnpvybZibII05i1ReydL09oPpXN7cxmFt+V7ZLmKHK7ajG062/b6rqkx8hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHkuXYeY7wQXbeO8fci++1Uw0E1qnUqHkCTEycz6f2c=;
 b=KXjBnhd+z4bMh3bjS+Wc2bpNYCEgXBAo4nhtgY3RQQs4yOFrdBtdYt8J6eOSI6JJmwyUwLKMqhgUy3ZBYXni30ofMcVi+DtPyOX6BzdGv+PD2R1JMNH4VRcGHX+6Kc30o16mrWhNQXE0LsYU0qrh60CVDiJsWRENKz61V/iUUiqQJdK1oqZyeG4IM50xwAu48kTeEmfpkfLR9t0zYHyEUo+OxWfY8n3TDCte8AVixMNpOPCQ9tWdXChSYgCb3Kd4GnJs/jNiNPJrvXvB40QFudrVbTp4JICUSNukZDm3/d373OJk4J3gdzI8BTAQj0R1DOdxj3hWiakGxHsjsgtOWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by PH7PR11MB6953.namprd11.prod.outlook.com (2603:10b6:510:204::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 05:50:15 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf%6]) with mapi id 15.20.6298.045; Thu, 20 Apr 2023
 05:50:14 +0000
Date:   Thu, 20 Apr 2023 13:50:01 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        <linux-kernel@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <ying.huang@intel.com>, <feng.tang@intel.com>,
        <fengwei.yin@intel.com>
Subject: [linus:master] [net]  68822bdf76:  redis.get_total_throughput_rps
 -5.0% regression
Message-ID: <202304191555.32c93785-oliver.sang@intel.com>
Content-Type: multipart/mixed; boundary="eG5Q/vRJnZo6MKIs"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SI2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:196::18) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|PH7PR11MB6953:EE_
X-MS-Office365-Filtering-Correlation-Id: e820014b-c412-49c1-2394-08db41631c57
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NrasxjciE1WKU5ecTfIwgwjRBEyOwWHChrlwU8G3C6vnKpKUsjOVjb/vpZ/BdM7aEy9WHP7yOtqwiTkuvJDuiwfUAJz4sUCGVgb4GnGIRYDBqiIka1077zg28qDJrnqCpKIw2XE8IB4MtrbdLSeKBgDByv9KwcW4yQr04d7XQ3atjiNIdrj7yM7ITabTRy9LYGbJbIzHt+QrlTTdOfH0FwFcg3gxo6qYcnSYHMChfNmUAGTr1hvsAD8NzRlkXvXvnl8+w7Kle6YwVGnAdbF+Kaj+ecA2MgvQ6X2MDCoBCwxTPoMbTcrAb4vtpSIJmnjkZ+QvD5fgPQVrwg/N+FkCiTTynwQPopE/ynKTeeGPPJaxvzk4jKDojTmx4zNu7EVl9GsCDWNUkLmOn2y3WpnfrV953HVB7DD3PyUqXldtNU6M3ooEWDgtTwaMZwlMWIoANZW5yLK8RATMZRLUuzMatWQQ6wUY80RizNWujv/xsa67ukZub0sEhsIB/tqM2+Fno1/u8GNrLbe4QCtqmHG6RqK8zQulWbtWrzoiAMGdZkr9P9K0Eg9onl0PyBBo4tY54bPSCuOifeBAgM6Xg5pR3Mlxko10p+sixf72Bips8NhgEPpmEdGdGhzQHu16xype7q+UMpU44CqzON86SxWgXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199021)(83380400001)(2616005)(966005)(478600001)(44144004)(6486002)(6666004)(21490400003)(19627235002)(26005)(107886003)(54906003)(1076003)(6506007)(6512007)(186003)(2906002)(30864003)(36756003)(38100700002)(6916009)(66476007)(66556008)(66946007)(82960400001)(4326008)(235185007)(5660300002)(41300700001)(8676002)(8936002)(316002)(86362001)(2700100001)(579004)(559001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?qi56eNLH1bLsOwlaoWwUtm5YS7ywSjuUrecAp5YfXIhkPk+yHAMoYWgxd2?=
 =?iso-8859-1?Q?obdpuH/WnM35PlJGNoTEQgUPnkoWJI5N9VeuvYvnmC0abpNfVV5lcoQKOR?=
 =?iso-8859-1?Q?i2Vvs4ZHhhxfqo3Rf2+Q8k2DN67X1nDWtdCJ8impEBicOro79sqV3/CE/4?=
 =?iso-8859-1?Q?NcP+9+TqJxlLLe0FCMRlKgnyKvbD2iE++pf7y17rrY9jrB+IphIiD8FeXD?=
 =?iso-8859-1?Q?o4wylCVZCHao7kNrKTg7Il4F7gvQso0K3otmDGpOqV84eJo7zjhze2GTuX?=
 =?iso-8859-1?Q?G76lrGfD4WNtJGOZkjNLB/3vzK8dva9vR91xQ/pr1Q7szad1/vmiFe+kSg?=
 =?iso-8859-1?Q?gcf1rnUj7rz/Ro+SCkLPlOadfv38iqxML3y3tXZ74WejhsrGgfb27iF2ou?=
 =?iso-8859-1?Q?vnESLIadDWpXd2/rBxijK1oaCUY+KsNpojXDtz38B92EWzsDx7euZrzDzd?=
 =?iso-8859-1?Q?bjXwZPRC0tn7veqrCINMIrO1Bk36L+wQ7XxQMEsQYNv5jFnoBJGQpu9dJ6?=
 =?iso-8859-1?Q?7sZ1EQ5CDvempuZ4Nu/xfHfKjtGeaBThd8ORsDbqaczYsaNFN67qTnBXDu?=
 =?iso-8859-1?Q?gVRmx7RzMA1zGiXu4eLmApiHCYtfgFhhZrdbI/p9NyFo2HdR8FKqf/qx9R?=
 =?iso-8859-1?Q?X0b8F1H0Mpi+yvsMvDhCG/ZR7NPWKEXQf3yO/QvybdXb18swEdRb79DtU2?=
 =?iso-8859-1?Q?QKsmsvU+sirwtqwY1K0JfhJgfhvMpsIaZugCYQ/SCtSp3b9C4B27GYP+ID?=
 =?iso-8859-1?Q?+bfqBoumsSp4cIbaA/oBMFyQvhFj9yf03eepvZooHW8FeQLdJnkP3u6mJC?=
 =?iso-8859-1?Q?qDqFWr5Jjs8EAMXa6eCU0kS496UNt7eIwlaOUbm7C6eNNpA9m2zMdA/010?=
 =?iso-8859-1?Q?Ugtdymk1ZiV8jTGsQ91bWK21U9Gpv46VIbipMuhOuyEIUY59SNCj4mqC9l?=
 =?iso-8859-1?Q?iTHHxW6FuNFchLRPvKOxx5iT+xyG0lx37RseD2kWKa6XD5PvNBzI1GCtSU?=
 =?iso-8859-1?Q?bWDqAsSrcSP/Nd2E/55BA6iaXSifbyCR/isnlNBkxntPnJT0CtoFoGoD46?=
 =?iso-8859-1?Q?Z5eXgNdicKE1JHu5qSesMo8DlvdRJgxT4/7SFYQVNNOljIEvjR78kowCA8?=
 =?iso-8859-1?Q?J2dxa45IKXHXdyLbTeDpFXgVI+FXJSHOaX8uRrjGgO6Yy5nZR7fyvEWNjo?=
 =?iso-8859-1?Q?Pt2mpo2DAl16uyhmnQ7BBIPn23Oo0nSCQFJ2D3x2rlRvHtliFZY9BJ20t/?=
 =?iso-8859-1?Q?h+P+87pH057zf0gBETjZaZ6DuMQpa1G6EQZHD5/DKROUaYBph7OMYdXrLF?=
 =?iso-8859-1?Q?bp5ed+rLlenyOo0mD4t+0CBfyWFAKg+x+ulKEiguIGkJ1UdQgk8tBDEjbN?=
 =?iso-8859-1?Q?iOChtal1zFUSGDImnipoYIVaTH0PHfl4SgNKIpBJ/ef/HKGspLaNbk2vWz?=
 =?iso-8859-1?Q?qkXkEDhze7rx8l9aY7gqFy+P8kJMCCWd5Lb6PP9Zy83jBwFB0mCY5YFDYy?=
 =?iso-8859-1?Q?2PUuQygn+/gpu+T/87y5wSECfc7vTH0Gfi+sRBt+CBxRAKefG15fZkT1kQ?=
 =?iso-8859-1?Q?occBDtgdFuJV/npCyMV4AVFvybcxO8biu6c49RJqrSOZwrEh323zJoowwl?=
 =?iso-8859-1?Q?FaUZbDgknMdtxDHRC4/NvsXKcBcDpOn8svaSg7qBLQgbsYGBijSI6fvg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e820014b-c412-49c1-2394-08db41631c57
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 05:50:14.5844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FyqqZy8oE0hRh6C0LMMcatxEn7ttVS/Jvu0gdq/MujLJBVHAJs5faYKlpjM1TdRwr42qD/zl+ZSQDn8e0zbtzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6953
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--eG5Q/vRJnZo6MKIs
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Hello,

kernel test robot noticed a redis.get_total_throughput_rps -5.0% regression on:


commit: 68822bdf76f10c3dc80609d4e2cdc1e847429086 ("net: generalize skb freeing deferral to per-cpu lists")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: redis
test machine: 96 threads 2 sockets Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz (Cascade Lake) with 512G memory
parameters:

	all: 1
	sc_overcommit_memory: 1
	sc_somaxconn: 65535
	thp_enabled: never
	thp_defrag: never
	cluster: cs-localhost
	cpu_node_bind: even
	nr_processes: 4
	test: set,get
	data_size: 1024
	n_client: 5
	requests: 68000000
	n_pipeline: 3
	key_len: 68000000
	cpufreq_governor: performance

test-description: Redis benchmark is the utility to check the performance of Redis by running commands done by N clients at the same time sending M total queries (it is similar to the Apache's ab utility).
test-url: https://redis.io/topics/benchmarks



Details are as below:
-------------------------------------------------------------------------------------------------->

besides the performance change, we also noticed big memory usage change, e.g.

  48446253          +252.4%  1.707e+08        meminfo.Memused



To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        sudo bin/lkp install job.yaml           # job file is attached in this email
        bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
        sudo bin/lkp run generated-yaml-file

        # if come across any failure that blocks the test,
        # please remove ~/.lkp and /lkp dir to run from a clean state.



=========================================================================================
all/cluster/compiler/cpu_node_bind/cpufreq_governor/data_size/kconfig/key_len/n_client/n_pipeline/nr_processes/requests/rootfs/sc_overcommit_memory/sc_somaxconn/tbox_group/test/testcase/thp_defrag/thp_enabled:
  1/cs-localhost/gcc-11/even/performance/1024/x86_64-rhel-8.3/68000000/5/3/4/68000000/debian-11.1-x86_64-20220510.cgz/1/65535/lkp-csl-2sp7/set,get/redis/never/never

commit: 
  561215482c ("net: usb: qmi_wwan: add support for Sierra Wireless EM7590")
  68822bdf76 ("net: generalize skb freeing deferral to per-cpu lists")

561215482cc69d1c 68822bdf76f10c3dc80609d4e2c 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    312142 ±  2%      -5.0%     296641 ±  2%  redis.get_avg_throughput_rps
     54.50 ±  2%      +5.2%      57.35 ±  2%  redis.get_avg_time_sec
   1248568 ±  2%      -5.0%    1186564 ±  2%  redis.get_total_throughput_rps
    218.01 ±  2%      +5.2%     229.40 ±  2%  redis.get_total_time_sec
    236728 ±  2%      -0.8%     234909 ±  2%  redis.set_avg_throughput_rps
     71.86 ±  2%      +0.8%      72.43 ±  2%  redis.set_avg_time_sec
    946914 ±  2%      -0.8%     939638 ±  2%  redis.set_total_throughput_rps
    287.43 ±  2%      +0.8%     289.72 ±  2%  redis.set_total_time_sec
    127.13 ±  2%      +2.8%     130.75 ±  2%  redis.time.elapsed_time
    127.13 ±  2%      +2.8%     130.75 ±  2%  redis.time.elapsed_time.max
     45816 ± 12%      +6.3%      48695 ± 14%  redis.time.involuntary_context_switches
      1.00 ±223%     -66.7%       0.33 ±141%  redis.time.major_page_faults
      4460 ±  2%      -2.1%       4365 ±  2%  redis.time.maximum_resident_set_size
      3331            +0.3%       3341        redis.time.minor_page_faults
      4096            +0.0%       4096        redis.time.page_size
    273.17 ±  5%      +3.5%     282.67 ±  6%  redis.time.percent_of_cpu_this_job_got
    261.43            +3.5%     270.55        redis.time.system_time
     86.91 ± 36%     +15.5%     100.39 ± 34%  redis.time.user_time
   9966615 ± 19%      -5.2%    9451531 ± 20%  redis.time.voluntary_context_switches
  1.13e+10 ±  2%      +2.9%  1.163e+10 ±  2%  cpuidle..time
  32241498 ±  4%      -6.8%   30051856 ± 14%  cpuidle..usage
     10.00            +0.0%      10.00        dmesg.bootstage:last
    232.70 ± 15%      +2.5%     238.44 ± 18%  dmesg.timestamp:last
     10.00            +0.0%      10.00        kmsg.bootstage:last
    154.09            +0.6%     155.02 ±  2%  kmsg.timestamp:last
    167.02            +2.7%     171.53 ±  3%  uptime.boot
     14438            +2.6%      14817 ±  3%  uptime.idle
     37.04 ±  2%      +2.4%      37.92 ±  9%  boot-time.boot
     20.45 ±  4%      +4.3%      21.33 ± 16%  boot-time.dhcp
      2995 ±  2%      +2.3%       3064 ± 10%  boot-time.idle
      1.08 ±  8%      +3.1%       1.11 ±  9%  boot-time.smp_boot
     91.66            -0.1       91.60        mpstat.cpu.all.idle%
      0.69            +0.0        0.73        mpstat.cpu.all.irq%
      1.21 ±  4%      -0.1        1.07 ±  3%  mpstat.cpu.all.soft%
      3.97 ±  2%      +0.0        3.97 ±  2%  mpstat.cpu.all.sys%
      2.47 ± 12%      +0.2        2.62 ± 12%  mpstat.cpu.all.usr%
      0.00          -100.0%       0.00        numa-numastat.node0.interleave_hit
   9670367           +35.7%   13119976        numa-numastat.node0.local_node
   9729524           +35.3%   13161039        numa-numastat.node0.numa_hit
     51739 ± 65%     -24.1%      39250 ± 64%  numa-numastat.node0.other_node
      0.00          -100.0%       0.00        numa-numastat.node1.interleave_hit
   9843761           +34.7%   13263799        numa-numastat.node1.local_node
   9863192           +35.2%   13334365        numa-numastat.node1.numa_hit
     35138 ± 96%     +35.5%      47610 ± 53%  numa-numastat.node1.other_node
     91.00            +0.4%      91.33        vmstat.cpu.id
      5.17 ±  7%      -3.2%       5.00        vmstat.cpu.sy
      2.33 ± 20%      +0.0%       2.33 ± 20%  vmstat.cpu.us
      0.00          -100.0%       0.00        vmstat.io.bi
      4.00            +0.0%       4.00        vmstat.memory.buff
   2834465            -0.1%    2832838        vmstat.memory.cache
 4.795e+08           -25.7%  3.562e+08        vmstat.memory.free
      7.00            +0.0%       7.00        vmstat.procs.r
    158326 ± 20%      -7.3%     146776 ± 21%  vmstat.system.cs
    196052            -4.5%     187299 ±  7%  vmstat.system.in
    127.13 ±  2%      +2.8%     130.75 ±  2%  time.elapsed_time
    127.13 ±  2%      +2.8%     130.75 ±  2%  time.elapsed_time.max
     45816 ± 12%      +6.3%      48695 ± 14%  time.involuntary_context_switches
      1.00 ±223%     -66.7%       0.33 ±141%  time.major_page_faults
      4460 ±  2%      -2.1%       4365 ±  2%  time.maximum_resident_set_size
      3331            +0.3%       3341        time.minor_page_faults
      4096            +0.0%       4096        time.page_size
    273.17 ±  5%      +3.5%     282.67 ±  6%  time.percent_of_cpu_this_job_got
    261.43            +3.5%     270.55        time.system_time
     86.91 ± 36%     +15.5%     100.39 ± 34%  time.user_time
   9966615 ± 19%      -5.2%    9451531 ± 20%  time.voluntary_context_switches
    252.00            +2.2%     257.67 ±  3%  turbostat.Avg_MHz
      9.02            +0.2        9.24 ±  3%  turbostat.Busy%
      2796            -0.0%       2795        turbostat.Bzy_MHz
   8377758 ± 22%     +29.8%   10872184 ± 48%  turbostat.C1
      0.64 ± 19%      +6.5        7.17 ±104%  turbostat.C1%
  16804679 ± 23%     -35.4%   10854692 ±100%  turbostat.C1E
     55.33 ± 44%     -14.0       41.29 ±101%  turbostat.C1E%
   5881927 ± 70%      -1.2%    5811478 ± 77%  turbostat.C6
     35.36 ± 69%      +7.4       42.73 ± 82%  turbostat.C6%
     90.62            -0.4%      90.30        turbostat.CPU%c1
      0.35 ± 12%     +32.1%       0.47 ± 44%  turbostat.CPU%c6
     57.67            -0.3%      57.50        turbostat.CoreTmp
      0.26 ±  3%      -3.8%       0.25 ±  6%  turbostat.IPC
  25497386 ±  2%      -1.9%   25019814 ±  7%  turbostat.IRQ
   1155519 ±  6%    +115.7%    2491896 ± 93%  turbostat.POLL
      0.04 ± 21%      +0.3        0.31 ±112%  turbostat.POLL%
      0.03 ±117%    +600.0%       0.19 ± 95%  turbostat.Pkg%pc2
     57.67            +0.0%      57.67        turbostat.PkgTmp
    178.56            +0.5%     179.44        turbostat.PkgWatt
     37.63            +2.1%      38.41        turbostat.RAMWatt
     32.00 ±141%     -50.0%      16.00 ±223%  turbostat.SMI
      2095            +0.0%       2095        turbostat.TSC_MHz
      9878 ± 20%      +0.5%       9930 ± 22%  meminfo.Active
      8094 ± 25%      +0.6%       8138 ± 27%  meminfo.Active(anon)
      1784            +0.4%       1790        meminfo.Active(file)
      1024 ±100%     +33.3%       1365 ±111%  meminfo.AnonHugePages
  43909092            +0.7%   44201514        meminfo.AnonPages
      4.00            +0.0%       4.00        meminfo.Buffers
   2727001            -0.1%    2724729        meminfo.Cached
  2.64e+08            +0.0%   2.64e+08        meminfo.CommitLimit
    723016 ±  3%      -0.9%     716283 ±  2%  meminfo.Committed_AS
 5.199e+08            -0.1%  5.196e+08        meminfo.DirectMap1G
  19293184 ±  9%      +1.6%   19597994 ± 10%  meminfo.DirectMap2M
    480366 ±  9%      +9.3%     525081 ±  5%  meminfo.DirectMap4k
      2048            +0.0%       2048        meminfo.Hugepagesize
  43946789            +0.7%   44236870        meminfo.Inactive
  43946633            +0.7%   44236721        meminfo.Inactive(anon)
    154.83 ±  6%      -4.3%     148.17        meminfo.Inactive(file)
    106128            -0.1%     106053        meminfo.KReclaimable
     17176            -0.2%      17148        meminfo.KernelStack
     51340 ± 15%      -4.2%      49192 ± 10%  meminfo.Mapped
 4.775e+08           -25.6%  3.552e+08        meminfo.MemAvailable
 4.796e+08           -25.5%  3.573e+08        meminfo.MemFree
  5.28e+08            +0.0%   5.28e+08        meminfo.MemTotal
  48446253          +252.4%  1.707e+08        meminfo.Memused
     90897            +0.5%      91389        meminfo.PageTables
     50792            -0.6%      50474        meminfo.Percpu
    106128            -0.1%     106053        meminfo.SReclaimable
    186607        +33305.6%   62337379 ±  2%  meminfo.SUnreclaim
     46575 ± 36%      -4.9%      44302 ± 34%  meminfo.Shmem
    292736        +21230.9%   62443433 ±  2%  meminfo.Slab
   2678488            +0.0%    2678489        meminfo.Unevictable
 3.436e+10            +0.0%  3.436e+10        meminfo.VmallocTotal
    272339            +0.0%     272346        meminfo.VmallocUsed
  48612688          +251.8%   1.71e+08        meminfo.max_used_kB
      3105 ± 34%     +18.9%       3692 ± 11%  numa-meminfo.node0.Active
      1915 ± 22%      -0.8%       1900 ± 21%  numa-meminfo.node0.Active(anon)
      1189 ± 70%     +50.5%       1791        numa-meminfo.node0.Active(file)
      1024 ±100%     +33.3%       1365 ±111%  numa-meminfo.node0.AnonHugePages
  21988630            +1.0%   22204681        numa-meminfo.node0.AnonPages
  28932084            +0.3%   29009098        numa-meminfo.node0.AnonPages.max
   2596199 ±  3%      +1.7%    2641162 ±  2%  numa-meminfo.node0.FilePages
  21993460            +1.0%   22207826        numa-meminfo.node0.Inactive
  21993357            +1.0%   22207677        numa-meminfo.node0.Inactive(anon)
    103.00 ± 71%     +43.9%     148.17        numa-meminfo.node0.Inactive(file)
     83092 ±  2%      +2.3%      84966 ±  4%  numa-meminfo.node0.KReclaimable
      9171 ±  5%      +3.8%       9519 ±  3%  numa-meminfo.node0.KernelStack
     39797 ±  7%      -1.2%      39339 ±  6%  numa-meminfo.node0.Mapped
 2.382e+08           -25.9%  1.766e+08        numa-meminfo.node0.MemFree
 2.638e+08            +0.0%  2.638e+08        numa-meminfo.node0.MemTotal
  25644389          +240.2%   87251385        numa-meminfo.node0.MemUsed
     45755            +1.4%      46404        numa-meminfo.node0.PageTables
     83092 ±  2%      +2.3%      84966 ±  4%  numa-meminfo.node0.SReclaimable
    107711 ±  2%  +29048.4%   31396043 ±  2%  numa-meminfo.node0.SUnreclaim
      7109 ±140%     -24.3%       5384 ±112%  numa-meminfo.node0.Shmem
    190804 ±  2%  +16399.1%   31481011 ±  2%  numa-meminfo.node0.Slab
   2587795 ±  3%      +1.8%    2633837 ±  2%  numa-meminfo.node0.Unevictable
      6145 ± 23%      -3.0%       5963 ± 51%  numa-meminfo.node1.Active
      5550 ± 29%      +7.4%       5963 ± 51%  numa-meminfo.node1.Active(anon)
    594.33 ±141%    -100.0%       0.00        numa-meminfo.node1.Active(file)
  21926394            +0.4%   22003416        numa-meminfo.node1.AnonPages
  28875311            -0.2%   28808925        numa-meminfo.node1.AnonPages.max
    129802 ± 66%     -35.9%      83192 ± 83%  numa-meminfo.node1.FilePages
  21958871            +0.3%   22035525        numa-meminfo.node1.Inactive
  21958819            +0.3%   22035525        numa-meminfo.node1.Inactive(anon)
     51.83 ±141%    -100.0%       0.00        numa-meminfo.node1.Inactive(file)
     23037 ± 10%      -8.5%      21087 ± 18%  numa-meminfo.node1.KReclaimable
      8001 ±  6%      -4.7%       7626 ±  4%  numa-meminfo.node1.KernelStack
     11256 ± 50%     -12.9%       9809 ± 29%  numa-meminfo.node1.Mapped
 2.414e+08           -25.2%  1.807e+08        numa-meminfo.node1.MemFree
 2.642e+08            +0.0%  2.642e+08        numa-meminfo.node1.MemTotal
  22806740          +266.3%   83543415 ±  3%  numa-meminfo.node1.MemUsed
     45149            -0.3%      44997        numa-meminfo.node1.PageTables
     23037 ± 10%      -8.5%      21087 ± 18%  numa-meminfo.node1.SReclaimable
     78911 ±  4%  +39147.9%   30971157 ±  4%  numa-meminfo.node1.SUnreclaim
     38462 ± 42%      +0.2%      38539 ± 33%  numa-meminfo.node1.Shmem
    101950 ±  4%  +30299.5%   30992245 ±  4%  numa-meminfo.node1.Slab
     90692 ± 99%     -50.8%      44652 ±153%  numa-meminfo.node1.Unevictable
    216.83 ± 10%     +10.0%     238.50 ±  5%  proc-vmstat.direct_map_level2_splits
     14.50 ± 11%      +3.4%      15.00 ± 12%  proc-vmstat.direct_map_level3_splits
      2013 ± 24%      +1.0%       2032 ± 27%  proc-vmstat.nr_active_anon
    445.67            +0.3%     447.17        proc-vmstat.nr_active_file
  10977589            +0.7%   11050497        proc-vmstat.nr_anon_pages
      0.50 ±100%     +33.3%       0.67 ±111%  proc-vmstat.nr_anon_transparent_hugepages
  11917645           -25.6%    8864868        proc-vmstat.nr_dirty_background_threshold
  23864430           -25.6%   17751412        proc-vmstat.nr_dirty_threshold
    681747            -0.1%     681180        proc-vmstat.nr_file_pages
 1.199e+08           -25.5%   89325035        proc-vmstat.nr_free_pages
  10986981            +0.7%   11059302        proc-vmstat.nr_inactive_anon
     38.33 ±  6%      -3.5%      37.00        proc-vmstat.nr_inactive_file
     17175            -0.2%      17148        proc-vmstat.nr_kernel_stack
     12839 ± 15%      -4.2%      12298 ± 10%  proc-vmstat.nr_mapped
     22724            +0.5%      22847        proc-vmstat.nr_page_table_pages
     11639 ± 36%      -4.9%      11072 ± 34%  proc-vmstat.nr_shmem
     26532            -0.1%      26513        proc-vmstat.nr_slab_reclaimable
     46654        +33304.4%   15584532 ±  2%  proc-vmstat.nr_slab_unreclaimable
    669621            +0.0%     669621        proc-vmstat.nr_unevictable
      2013 ± 24%      +1.0%       2032 ± 27%  proc-vmstat.nr_zone_active_anon
    445.67            +0.3%     447.17        proc-vmstat.nr_zone_active_file
  10986981            +0.7%   11059302        proc-vmstat.nr_zone_inactive_anon
     38.33 ±  6%      -3.5%      37.00        proc-vmstat.nr_zone_inactive_file
    669621            +0.0%     669621        proc-vmstat.nr_zone_unevictable
  18481804 ±  2%      +2.0%   18851346 ±  3%  proc-vmstat.numa_hint_faults
  18480162 ±  2%      +2.0%   18844495 ±  3%  proc-vmstat.numa_hint_faults_local
  19595411           +35.2%   26497564        proc-vmstat.numa_hit
      0.00          -100.0%       0.00        proc-vmstat.numa_huge_pte_updates
      0.00          -100.0%       0.00        proc-vmstat.numa_interleave
  19516791           +35.2%   26385935        proc-vmstat.numa_local
     86877            -0.0%      86860        proc-vmstat.numa_other
    663.33 ±112%    +685.5%       5210 ± 67%  proc-vmstat.numa_pages_migrated
  20627159 ±  3%      +2.0%   21040343 ±  4%  proc-vmstat.numa_pte_updates
    163882 ± 34%      -1.3%     161765 ± 33%  proc-vmstat.pgactivate
      0.00          -100.0%       0.00        proc-vmstat.pgalloc_dma32
  19580028           +35.2%   26473834        proc-vmstat.pgalloc_normal
  34004059            +1.1%   34379420        proc-vmstat.pgfault
   5167229 ±  2%     -41.2%    3037029 ± 12%  proc-vmstat.pgfree
    663.33 ±112%    +685.5%       5210 ± 67%  proc-vmstat.pgmigrate_success
      0.00          -100.0%       0.00        proc-vmstat.pgpgin
     21628 ±  2%      +1.9%      22031        proc-vmstat.pgreuse
      0.00          -100.0%       0.00        proc-vmstat.thp_collapse_alloc
      0.00          -100.0%       0.00        proc-vmstat.thp_fault_alloc
      0.00          -100.0%       0.00        proc-vmstat.thp_split_pmd
      0.00          -100.0%       0.00        proc-vmstat.thp_zero_page_alloc
     16.83 ±  5%      +3.0%      17.33 ±  5%  proc-vmstat.unevictable_pgs_culled
    478.67 ± 22%      -0.9%     474.17 ± 21%  numa-vmstat.node0.nr_active_anon
    297.33 ± 70%     +50.4%     447.17        numa-vmstat.node0.nr_active_file
   5497730            +0.9%    5549433        numa-vmstat.node0.nr_anon_pages
      0.50 ±100%     +33.3%       0.67 ±111%  numa-vmstat.node0.nr_anon_transparent_hugepages
    649053 ±  3%      +1.7%     660291 ±  2%  numa-vmstat.node0.nr_file_pages
  59549313           -25.8%   44166254        numa-vmstat.node0.nr_free_pages
   5498916            +0.9%    5550183        numa-vmstat.node0.nr_inactive_anon
     25.50 ± 71%     +45.1%      37.00        numa-vmstat.node0.nr_inactive_file
      9173 ±  5%      +3.8%       9521 ±  3%  numa-vmstat.node0.nr_kernel_stack
      9959 ±  7%      -1.2%       9839 ±  6%  numa-vmstat.node0.nr_mapped
     11438            +1.4%      11597        numa-vmstat.node0.nr_page_table_pages
      1781 ±140%     -24.4%       1347 ±112%  numa-vmstat.node0.nr_shmem
     20772 ±  2%      +2.3%      21241 ±  4%  numa-vmstat.node0.nr_slab_reclaimable
     26927 ±  2%  +29014.5%    7839703        numa-vmstat.node0.nr_slab_unreclaimable
    646948 ±  3%      +1.8%     658459 ±  2%  numa-vmstat.node0.nr_unevictable
    478.67 ± 22%      -0.9%     474.17 ± 21%  numa-vmstat.node0.nr_zone_active_anon
    297.33 ± 70%     +50.4%     447.17        numa-vmstat.node0.nr_zone_active_file
   5498913            +0.9%    5550181        numa-vmstat.node0.nr_zone_inactive_anon
     25.50 ± 71%     +45.1%      37.00        numa-vmstat.node0.nr_zone_inactive_file
    646948 ±  3%      +1.8%     658459 ±  2%  numa-vmstat.node0.nr_zone_unevictable
   9729708           +35.3%   13159803        numa-vmstat.node0.numa_hit
      0.00          -100.0%       0.00        numa-vmstat.node0.numa_interleave
   9670552           +35.7%   13118739        numa-vmstat.node0.numa_local
     51739 ± 65%     -24.1%      39250 ± 64%  numa-vmstat.node0.numa_other
      1416 ± 37%      -4.8%       1348 ± 32%  numa-vmstat.node1.nr_active_anon
    148.33 ±141%    -100.0%       0.00        numa-vmstat.node1.nr_active_file
   5482167            +0.3%    5499137        numa-vmstat.node1.nr_anon_pages
     32390 ± 66%     -36.1%      20681 ± 83%  numa-vmstat.node1.nr_file_pages
  60346437           -25.1%   45181069        numa-vmstat.node1.nr_free_pages
   5490182            +0.3%    5507189        numa-vmstat.node1.nr_inactive_anon
     12.83 ±141%    -100.0%       0.00        numa-vmstat.node1.nr_inactive_file
      8001 ±  6%      -4.6%       7632 ±  4%  numa-vmstat.node1.nr_kernel_stack
      2721 ± 50%      -8.6%       2487 ± 29%  numa-vmstat.node1.nr_mapped
     11286            -0.4%      11247        numa-vmstat.node1.nr_page_table_pages
      9555 ± 41%      -0.4%       9518 ± 32%  numa-vmstat.node1.nr_shmem
      5760 ± 10%      -8.5%       5271 ± 18%  numa-vmstat.node1.nr_slab_reclaimable
     19728 ±  4%  +39100.0%    7733447 ±  4%  numa-vmstat.node1.nr_slab_unreclaimable
     22672 ± 99%     -50.8%      11162 ±153%  numa-vmstat.node1.nr_unevictable
      1416 ± 37%      -4.8%       1348 ± 33%  numa-vmstat.node1.nr_zone_active_anon
    148.33 ±141%    -100.0%       0.00        numa-vmstat.node1.nr_zone_active_file
   5490179            +0.3%    5507186        numa-vmstat.node1.nr_zone_inactive_anon
     12.83 ±141%    -100.0%       0.00        numa-vmstat.node1.nr_zone_inactive_file
     22672 ± 99%     -50.8%      11162 ±153%  numa-vmstat.node1.nr_zone_unevictable
   9863404           +35.2%   13333035        numa-vmstat.node1.numa_hit
      0.00          -100.0%       0.00        numa-vmstat.node1.numa_interleave
   9843941           +34.7%   13262469        numa-vmstat.node1.numa_local
     35138 ± 96%     +35.5%      47610 ± 53%  numa-vmstat.node1.numa_other
      8.91            +5.1%       9.37        perf-stat.i.MPKI
 4.373e+09 ±  3%      -3.2%  4.235e+09 ±  3%  perf-stat.i.branch-instructions
      1.11            -0.0        1.08        perf-stat.i.branch-miss-rate%
  49153987 ±  3%      -5.3%   46527528 ±  3%  perf-stat.i.branch-misses
     13.55            +7.5       21.07        perf-stat.i.cache-miss-rate%
  26851788 ±  2%     +58.9%   42662719 ±  2%  perf-stat.i.cache-misses
 1.975e+08 ±  3%      +1.7%  2.009e+08 ±  3%  perf-stat.i.cache-references
    162209 ± 20%      -7.2%     150493 ± 21%  perf-stat.i.context-switches
      1.07 ±  4%      +5.9%       1.14 ±  6%  perf-stat.i.cpi
     96009            +0.1%      96071        perf-stat.i.cpu-clock
 2.372e+10            +2.4%  2.429e+10 ±  3%  perf-stat.i.cpu-cycles
    115.60            -1.7%     113.66        perf-stat.i.cpu-migrations
    937.11 ±  3%     -36.6%     594.16 ±  5%  perf-stat.i.cycles-between-cache-misses
      0.09 ±  7%      +0.0        0.09 ±  8%  perf-stat.i.dTLB-load-miss-rate%
   5175886 ±  4%      +3.2%    5343110 ±  5%  perf-stat.i.dTLB-load-misses
 6.178e+09 ±  3%      -3.4%  5.968e+09 ±  3%  perf-stat.i.dTLB-loads
      0.04            -0.0        0.04        perf-stat.i.dTLB-store-miss-rate%
   1275320 ±  3%      -3.9%    1225499 ±  3%  perf-stat.i.dTLB-store-misses
 3.395e+09 ±  3%      -3.5%  3.277e+09 ±  3%  perf-stat.i.dTLB-stores
     84.34            +0.8       85.14 ±  3%  perf-stat.i.iTLB-load-miss-rate%
  29715807            -6.7%   27712394        perf-stat.i.iTLB-load-misses
   5409704 ± 11%     -11.5%    4786420 ± 22%  perf-stat.i.iTLB-loads
 2.225e+10 ±  3%      -3.3%  2.152e+10 ±  3%  perf-stat.i.instructions
    753.47            +3.7%     781.27 ±  2%  perf-stat.i.instructions-per-iTLB-miss
      0.94 ±  4%      -5.4%       0.89 ±  6%  perf-stat.i.ipc
      3.83 ± 13%     +11.2%       4.25 ± 24%  perf-stat.i.major-faults
      0.25            +2.3%       0.25 ±  3%  perf-stat.i.metric.GHz
    254.51 ±  4%     +25.3%     318.87 ±  6%  perf-stat.i.metric.K/sec
    147.30 ±  3%      -3.3%     142.43 ±  3%  perf-stat.i.metric.M/sec
    266973 ±  3%      -1.5%     263039 ±  4%  perf-stat.i.minor-faults
      4.42 ±  3%      +0.3        4.69 ±  6%  perf-stat.i.node-load-miss-rate%
    437171 ±  4%     +19.3%     521376 ±  4%  perf-stat.i.node-load-misses
  12747842            +7.4%   13691997 ±  2%  perf-stat.i.node-loads
     16.94 ±  8%      -7.7        9.19 ± 68%  perf-stat.i.node-store-miss-rate%
    215706 ± 16%    +282.1%     824246 ± 67%  perf-stat.i.node-store-misses
   3536741 ±  2%    +152.9%    8945289 ±  9%  perf-stat.i.node-stores
    266977 ±  3%      -1.5%     263043 ±  4%  perf-stat.i.page-faults
     96009            +0.1%      96071        perf-stat.i.task-clock
      8.88            +5.1%       9.33        perf-stat.overall.MPKI
      1.12            -0.0        1.10        perf-stat.overall.branch-miss-rate%
     13.60            +7.7       21.25        perf-stat.overall.cache-miss-rate%
      1.07 ±  4%      +5.9%       1.13 ±  6%  perf-stat.overall.cpi
    884.49 ±  3%     -35.5%     570.06 ±  5%  perf-stat.overall.cycles-between-cache-misses
      0.08 ±  7%      +0.0        0.09 ±  8%  perf-stat.overall.dTLB-load-miss-rate%
      0.04            -0.0        0.04        perf-stat.overall.dTLB-store-miss-rate%
     84.63            +0.8       85.39 ±  3%  perf-stat.overall.iTLB-load-miss-rate%
    748.82            +3.7%     776.43 ±  2%  perf-stat.overall.instructions-per-iTLB-miss
      0.94 ±  4%      -5.4%       0.89 ±  6%  perf-stat.overall.ipc
      3.31 ±  3%      +0.4        3.67 ±  6%  perf-stat.overall.node-load-miss-rate%
      5.73 ± 14%      +2.9        8.61 ± 68%  perf-stat.overall.node-store-miss-rate%
 4.338e+09 ±  3%      -3.2%    4.2e+09 ±  3%  perf-stat.ps.branch-instructions
  48761063 ±  3%      -5.4%   46127743 ±  3%  perf-stat.ps.branch-misses
  26633127 ±  2%     +58.9%   42308635 ±  2%  perf-stat.ps.cache-misses
 1.959e+08 ±  3%      +1.7%  1.992e+08 ±  3%  perf-stat.ps.cache-references
    160978 ± 20%      -7.3%     149194 ± 21%  perf-stat.ps.context-switches
     95244            +0.0%      95265        perf-stat.ps.cpu-clock
 2.353e+10            +2.3%  2.408e+10 ±  3%  perf-stat.ps.cpu-cycles
    114.70            -1.8%     112.69        perf-stat.ps.cpu-migrations
   5134448 ±  4%      +3.2%    5297962 ±  5%  perf-stat.ps.dTLB-load-misses
 6.128e+09 ±  3%      -3.4%  5.918e+09 ±  3%  perf-stat.ps.dTLB-loads
   1265534 ±  3%      -4.0%    1215160 ±  3%  perf-stat.ps.dTLB-store-misses
 3.367e+09 ±  3%      -3.5%   3.25e+09 ±  3%  perf-stat.ps.dTLB-stores
  29475167            -6.7%   27485610        perf-stat.ps.iTLB-load-misses
   5369102 ± 11%     -11.6%    4744846 ± 22%  perf-stat.ps.iTLB-loads
 2.208e+10 ±  3%      -3.3%  2.135e+10 ±  3%  perf-stat.ps.instructions
      3.79 ± 13%     +11.3%       4.21 ± 24%  perf-stat.ps.major-faults
    264991 ±  3%      -1.6%     260790 ±  4%  perf-stat.ps.minor-faults
    433443 ±  4%     +19.3%     516988 ±  4%  perf-stat.ps.node-load-misses
  12639760 ±  2%      +7.5%   13582029 ±  2%  perf-stat.ps.node-loads
    213864 ± 16%    +282.2%     817323 ± 67%  perf-stat.ps.node-store-misses
   3513010 ±  2%    +152.4%    8868043 ±  9%  perf-stat.ps.node-stores
    264995 ±  3%      -1.6%     260794 ±  4%  perf-stat.ps.page-faults
     95244            +0.0%      95265        perf-stat.ps.task-clock
 2.813e+12            -0.6%  2.795e+12        perf-stat.total.instructions
    587.95 ±104%     -57.6%     249.07 ±173%  sched_debug.cfs_rq:/.MIN_vruntime.avg
     29785 ±121%     -63.5%      10876 ±123%  sched_debug.cfs_rq:/.MIN_vruntime.max
      0.00            +0.0%       0.00        sched_debug.cfs_rq:/.MIN_vruntime.min
      3983 ±107%     -60.6%       1571 ±148%  sched_debug.cfs_rq:/.MIN_vruntime.stddev
      0.16 ± 30%      +6.4%       0.17 ± 35%  sched_debug.cfs_rq:/.h_nr_running.avg
      1.00           +19.4%       1.19 ± 16%  sched_debug.cfs_rq:/.h_nr_running.max
      0.35 ± 10%      +4.6%       0.37 ± 11%  sched_debug.cfs_rq:/.h_nr_running.stddev
     16326 ± 42%     +29.6%      21158 ± 40%  sched_debug.cfs_rq:/.load.avg
    105642 ±  2%    +268.6%     389360 ± 92%  sched_debug.cfs_rq:/.load.max
     33898 ± 16%     +88.3%      63832 ± 50%  sched_debug.cfs_rq:/.load.stddev
     35.94 ± 28%     +12.4%      40.39 ± 28%  sched_debug.cfs_rq:/.load_avg.avg
    621.00 ± 25%      +0.2%     622.50 ± 16%  sched_debug.cfs_rq:/.load_avg.max
    113.18 ± 24%      +7.3%     121.39 ± 17%  sched_debug.cfs_rq:/.load_avg.stddev
    587.95 ±104%     -57.6%     249.07 ±173%  sched_debug.cfs_rq:/.max_vruntime.avg
     29785 ±121%     -63.5%      10876 ±123%  sched_debug.cfs_rq:/.max_vruntime.max
      0.00            +0.0%       0.00        sched_debug.cfs_rq:/.max_vruntime.min
      3983 ±107%     -60.6%       1571 ±148%  sched_debug.cfs_rq:/.max_vruntime.stddev
     45879 ± 11%     +17.3%      53817 ± 18%  sched_debug.cfs_rq:/.min_vruntime.avg
    191354 ± 12%     +22.9%     235230 ± 28%  sched_debug.cfs_rq:/.min_vruntime.max
     13537 ± 26%     +18.0%      15971 ± 14%  sched_debug.cfs_rq:/.min_vruntime.min
     38326 ± 15%     +24.3%      47631 ± 28%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.16 ± 30%      +7.2%       0.17 ± 35%  sched_debug.cfs_rq:/.nr_running.avg
      1.00           +19.4%       1.19 ± 16%  sched_debug.cfs_rq:/.nr_running.max
      0.35 ± 10%      +4.9%       0.37 ± 11%  sched_debug.cfs_rq:/.nr_running.stddev
     14.66 ± 51%     +14.5%      16.78 ± 44%  sched_debug.cfs_rq:/.removed.load_avg.avg
    510.94 ± 50%      -5.4%     483.56 ± 31%  sched_debug.cfs_rq:/.removed.load_avg.max
     81.28 ± 48%      +6.7%      86.68 ± 35%  sched_debug.cfs_rq:/.removed.load_avg.stddev
      5.92 ± 56%     +15.3%       6.83 ± 57%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
    241.61 ± 51%      -6.5%     226.00 ± 32%  sched_debug.cfs_rq:/.removed.runnable_avg.max
     33.86 ± 53%      +4.9%      35.52 ± 44%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
      5.92 ± 56%     +15.3%       6.83 ± 57%  sched_debug.cfs_rq:/.removed.util_avg.avg
    241.56 ± 51%      -6.4%     226.00 ± 32%  sched_debug.cfs_rq:/.removed.util_avg.max
     33.85 ± 53%      +4.9%      35.52 ± 44%  sched_debug.cfs_rq:/.removed.util_avg.stddev
    203.90 ± 16%      +9.8%     223.93 ± 17%  sched_debug.cfs_rq:/.runnable_avg.avg
      1011 ±  8%      +2.5%       1036 ±  6%  sched_debug.cfs_rq:/.runnable_avg.max
    282.97 ±  8%      +4.0%     294.37 ±  8%  sched_debug.cfs_rq:/.runnable_avg.stddev
    -22708           -92.8%      -1623        sched_debug.cfs_rq:/.spread0.avg
    122764 ± 32%     +46.4%     179788 ± 40%  sched_debug.cfs_rq:/.spread0.max
    -55054           -28.3%     -39468        sched_debug.cfs_rq:/.spread0.min
     38327 ± 15%     +24.3%      47630 ± 28%  sched_debug.cfs_rq:/.spread0.stddev
    203.41 ± 16%      +9.8%     223.42 ± 17%  sched_debug.cfs_rq:/.util_avg.avg
      1010 ±  8%      +2.5%       1035 ±  6%  sched_debug.cfs_rq:/.util_avg.max
    282.20 ±  8%      +4.1%     293.67 ±  8%  sched_debug.cfs_rq:/.util_avg.stddev
     73.93 ± 35%      +9.4%      80.87 ± 45%  sched_debug.cfs_rq:/.util_est_enqueued.avg
    799.72 ±  5%      +3.6%     828.17        sched_debug.cfs_rq:/.util_est_enqueued.max
    196.33 ± 11%      +2.9%     202.10 ± 15%  sched_debug.cfs_rq:/.util_est_enqueued.stddev
    841612            +1.0%     849698        sched_debug.cpu.avg_idle.avg
   1081404 ±  7%      +2.5%    1108691 ±  5%  sched_debug.cpu.avg_idle.max
      4490 ±  7%      +5.3%       4726 ± 10%  sched_debug.cpu.avg_idle.min
    289137 ±  2%      -3.1%     280198 ±  3%  sched_debug.cpu.avg_idle.stddev
     98759            -4.1%      94685 ± 13%  sched_debug.cpu.clock.avg
     98762            -4.1%      94688 ± 13%  sched_debug.cpu.clock.max
     98755            -4.1%      94680 ± 13%  sched_debug.cpu.clock.min
      1.97 ±  9%      +8.0%       2.13 ± 32%  sched_debug.cpu.clock.stddev
     97526            -4.1%      93576 ± 13%  sched_debug.cpu.clock_task.avg
     98349            -4.1%      94285 ± 13%  sched_debug.cpu.clock_task.max
     91332            -5.2%      86606 ± 13%  sched_debug.cpu.clock_task.min
      1300 ±  7%      +3.5%       1345 ± 29%  sched_debug.cpu.clock_task.stddev
    489.29 ±  6%      -7.1%     454.31 ±  6%  sched_debug.cpu.curr->pid.avg
      6230            -2.6%       6067 ±  5%  sched_debug.cpu.curr->pid.max
      1420 ±  3%      -4.6%       1355 ±  3%  sched_debug.cpu.curr->pid.stddev
    501470            +0.5%     503820        sched_debug.cpu.max_idle_balance_cost.avg
    589771 ±  2%      -1.6%     580451 ±  5%  sched_debug.cpu.max_idle_balance_cost.max
    500000            +0.0%     500000        sched_debug.cpu.max_idle_balance_cost.min
     10572 ± 31%     +38.1%      14597 ± 50%  sched_debug.cpu.max_idle_balance_cost.stddev
      4294            -0.0%       4294        sched_debug.cpu.next_balance.avg
      4294            -0.0%       4294        sched_debug.cpu.next_balance.max
      4294            -0.0%       4294        sched_debug.cpu.next_balance.min
      0.00 ± 56%     +69.5%       0.00 ± 66%  sched_debug.cpu.next_balance.stddev
      0.12 ±  6%      -2.8%       0.11 ±  8%  sched_debug.cpu.nr_running.avg
      1.00           +19.4%       1.19 ± 16%  sched_debug.cpu.nr_running.max
      0.32 ±  2%      +0.4%       0.32 ±  4%  sched_debug.cpu.nr_running.stddev
    109088 ± 15%     -16.7%      90916 ± 22%  sched_debug.cpu.nr_switches.avg
   1255900 ± 15%     -16.1%    1053956 ± 29%  sched_debug.cpu.nr_switches.max
    960.78 ±  7%      -8.9%     874.83 ± 12%  sched_debug.cpu.nr_switches.min
    243571 ± 15%     -17.3%     201398 ± 26%  sched_debug.cpu.nr_switches.stddev
 2.105e+09 ±  6%      +3.1%   2.17e+09 ±  9%  sched_debug.cpu.nr_uninterruptible.avg
 4.295e+09            +0.0%  4.295e+09        sched_debug.cpu.nr_uninterruptible.max
 2.143e+09            -0.2%  2.138e+09        sched_debug.cpu.nr_uninterruptible.stddev
     98756            -4.1%      94682 ± 13%  sched_debug.cpu_clk
    996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.avg
    996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.max
    996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.min
 4.295e+09            -0.0%  4.295e+09        sched_debug.jiffies
     98114            -4.2%      94022 ± 13%  sched_debug.ktime
    950.00            +0.0%     950.00        sched_debug.rt_rq:.rt_runtime.avg
    950.00            +0.0%     950.00        sched_debug.rt_rq:.rt_runtime.max
    950.00            +0.0%     950.00        sched_debug.rt_rq:.rt_runtime.min
    108922            -4.5%     104053 ± 10%  sched_debug.sched_clk
      1.00            +0.0%       1.00        sched_debug.sched_clock_stable()
  29306427            +0.0%   29306427        sched_debug.sysctl_sched.sysctl_sched_features
      0.75            +0.0%       0.75        sched_debug.sysctl_sched.sysctl_sched_idle_min_granularity
     24.00            +0.0%      24.00        sched_debug.sysctl_sched.sysctl_sched_latency
      3.00            +0.0%       3.00        sched_debug.sysctl_sched.sysctl_sched_min_granularity
      1.00            +0.0%       1.00        sched_debug.sysctl_sched.sysctl_sched_tunable_scaling
      4.00            +0.0%       4.00        sched_debug.sysctl_sched.sysctl_sched_wakeup_granularity
    193829            +0.0%     193878        slabinfo.Acpi-Operand.active_objs
      3466            +0.0%       3467        slabinfo.Acpi-Operand.active_slabs
    194114            +0.0%     194161        slabinfo.Acpi-Operand.num_objs
      3466            +0.0%       3467        slabinfo.Acpi-Operand.num_slabs
      1119 ±  4%      +2.2%       1143 ±  6%  slabinfo.Acpi-Parse.active_objs
     15.33 ±  4%      +2.2%      15.67 ±  6%  slabinfo.Acpi-Parse.active_slabs
      1119 ±  4%      +2.2%       1143 ±  6%  slabinfo.Acpi-Parse.num_objs
     15.33 ±  4%      +2.2%      15.67 ±  6%  slabinfo.Acpi-Parse.num_slabs
    467.50 ± 14%      +9.1%     510.00 ± 18%  slabinfo.Acpi-State.active_objs
      9.17 ± 14%      +9.1%      10.00 ± 18%  slabinfo.Acpi-State.active_slabs
    467.50 ± 14%      +9.1%     510.00 ± 18%  slabinfo.Acpi-State.num_objs
      9.17 ± 14%      +9.1%      10.00 ± 18%  slabinfo.Acpi-State.num_slabs
     33.00 ± 20%      +9.1%      36.00        slabinfo.DCCP.active_objs
      1.83 ± 20%      +9.1%       2.00        slabinfo.DCCP.active_slabs
     33.00 ± 20%      +9.1%      36.00        slabinfo.DCCP.num_objs
      1.83 ± 20%      +9.1%       2.00        slabinfo.DCCP.num_slabs
     31.17 ± 20%      +9.1%      34.00        slabinfo.DCCPv6.active_objs
      1.83 ± 20%      +9.1%       2.00        slabinfo.DCCPv6.active_slabs
     31.17 ± 20%      +9.1%      34.00        slabinfo.DCCPv6.num_objs
      1.83 ± 20%      +9.1%       2.00        slabinfo.DCCPv6.num_slabs
      0.00       +1.8e+105%       1787 ± 20%  slabinfo.PING.active_objs
      0.00       +5.6e+103%      55.50 ± 20%  slabinfo.PING.active_slabs
      0.00       +1.8e+105%       1787 ± 20%  slabinfo.PING.num_objs
      0.00       +5.6e+103%      55.50 ± 20%  slabinfo.PING.num_slabs
    192.00            +0.0%     192.00        slabinfo.RAW.active_objs
      6.00            +0.0%       6.00        slabinfo.RAW.active_slabs
    192.00            +0.0%     192.00        slabinfo.RAW.num_objs
      6.00            +0.0%       6.00        slabinfo.RAW.num_slabs
    130.00            +0.0%     130.00        slabinfo.RAWv6.active_objs
      5.00            +0.0%       5.00        slabinfo.RAWv6.active_slabs
    130.00            +0.0%     130.00        slabinfo.RAWv6.num_objs
      5.00            +0.0%       5.00        slabinfo.RAWv6.num_slabs
    176.67 ±  6%      -3.5%     170.50 ±  8%  slabinfo.TCP.active_objs
     12.00 ±  6%      -2.8%      11.67 ±  8%  slabinfo.TCP.active_slabs
    176.67 ±  6%      -3.5%     170.50 ±  8%  slabinfo.TCP.num_objs
     12.00 ±  6%      -2.8%      11.67 ±  8%  slabinfo.TCP.num_slabs
     87.83 ±  5%      -2.5%      85.67 ±  7%  slabinfo.TCPv6.active_objs
      5.83 ±  6%      -2.9%       5.67 ±  8%  slabinfo.TCPv6.active_slabs
     87.83 ±  5%      -2.5%      85.67 ±  7%  slabinfo.TCPv6.num_objs
      5.83 ±  6%      -2.9%       5.67 ±  8%  slabinfo.TCPv6.num_slabs
    112.00 ± 10%      -3.6%     108.00 ± 11%  slabinfo.UDPv6.active_objs
      4.67 ± 10%      -3.6%       4.50 ± 11%  slabinfo.UDPv6.active_slabs
    112.00 ± 10%      -3.6%     108.00 ± 11%  slabinfo.UDPv6.num_objs
      4.67 ± 10%      -3.6%       4.50 ± 11%  slabinfo.UDPv6.num_slabs
      1694 ± 19%    -100.0%       0.00        slabinfo.UNIX.active_objs
     56.17 ± 18%    -100.0%       0.00        slabinfo.UNIX.active_slabs
      1694 ± 19%    -100.0%       0.00        slabinfo.UNIX.num_objs
     56.17 ± 18%    -100.0%       0.00        slabinfo.UNIX.num_slabs
     16671 ±  4%      +2.3%      17056 ±  8%  slabinfo.anon_vma.active_objs
    366.50 ±  5%      +1.9%     373.33 ±  8%  slabinfo.anon_vma.active_slabs
     16880 ±  5%      +1.9%      17204 ±  8%  slabinfo.anon_vma.num_objs
    366.50 ±  5%      +1.9%     373.33 ±  8%  slabinfo.anon_vma.num_slabs
     20768 ±  3%      -2.7%      20216 ±  3%  slabinfo.anon_vma_chain.active_objs
    330.33 ±  3%      -2.7%     321.33 ±  3%  slabinfo.anon_vma_chain.active_slabs
     21159 ±  3%      -2.6%      20607 ±  3%  slabinfo.anon_vma_chain.num_objs
    330.33 ±  3%      -2.7%     321.33 ±  3%  slabinfo.anon_vma_chain.num_slabs
     94.50 ± 11%      +3.7%      98.00 ± 10%  slabinfo.bdev_cache.active_objs
      4.50 ± 11%      +3.7%       4.67 ± 10%  slabinfo.bdev_cache.active_slabs
     94.50 ± 11%      +3.7%      98.00 ± 10%  slabinfo.bdev_cache.num_objs
      4.50 ± 11%      +3.7%       4.67 ± 10%  slabinfo.bdev_cache.num_slabs
     64.00            +0.0%      64.00        slabinfo.bio-120.active_objs
      2.00            +0.0%       2.00        slabinfo.bio-120.active_slabs
     64.00            +0.0%      64.00        slabinfo.bio-120.num_objs
      2.00            +0.0%       2.00        slabinfo.bio-120.num_slabs
    427.00 ± 10%      +4.9%     448.00 ±  8%  slabinfo.bio-184.active_objs
     10.17 ± 10%      +4.9%      10.67 ±  8%  slabinfo.bio-184.active_slabs
    427.00 ± 10%      +4.9%     448.00 ±  8%  slabinfo.bio-184.num_objs
     10.17 ± 10%      +4.9%      10.67 ±  8%  slabinfo.bio-184.num_slabs
     64.00            +0.0%      64.00        slabinfo.bio-248.active_objs
      2.00            +0.0%       2.00        slabinfo.bio-248.active_slabs
     64.00            +0.0%      64.00        slabinfo.bio-248.num_objs
      2.00            +0.0%       2.00        slabinfo.bio-248.num_slabs
    221.00 ± 17%     -15.4%     187.00 ± 12%  slabinfo.bio-296.active_objs
      4.33 ± 17%     -15.4%       3.67 ± 12%  slabinfo.bio-296.active_slabs
    221.00 ± 17%     -15.4%     187.00 ± 12%  slabinfo.bio-296.num_objs
      4.33 ± 17%     -15.4%       3.67 ± 12%  slabinfo.bio-296.num_slabs
     74.67 ± 38%     +28.6%      96.00 ± 16%  slabinfo.biovec-128.active_objs
      4.67 ± 38%     +28.6%       6.00 ± 16%  slabinfo.biovec-128.active_slabs
     74.67 ± 38%     +28.6%      96.00 ± 16%  slabinfo.biovec-128.num_objs
      4.67 ± 38%     +28.6%       6.00 ± 16%  slabinfo.biovec-128.num_slabs
    250.67 ±  4%      -6.4%     234.67 ± 10%  slabinfo.biovec-64.active_objs
      7.83 ±  4%      -6.4%       7.33 ± 10%  slabinfo.biovec-64.active_slabs
    250.67 ±  4%      -6.4%     234.67 ± 10%  slabinfo.biovec-64.num_objs
      7.83 ±  4%      -6.4%       7.33 ± 10%  slabinfo.biovec-64.num_slabs
     80.00 ± 11%      -3.3%      77.33 ±  4%  slabinfo.biovec-max.active_objs
     10.00 ± 11%      -3.3%       9.67 ±  4%  slabinfo.biovec-max.active_slabs
     80.00 ± 11%      -3.3%      77.33 ±  4%  slabinfo.biovec-max.num_objs
     10.00 ± 11%      -3.3%       9.67 ±  4%  slabinfo.biovec-max.num_slabs
    108.00           -16.7%      90.00 ± 14%  slabinfo.btrfs_inode.active_objs
      4.00           -16.7%       3.33 ± 14%  slabinfo.btrfs_inode.active_slabs
    108.00           -16.7%      90.00 ± 14%  slabinfo.btrfs_inode.num_objs
      4.00           -16.7%       3.33 ± 14%  slabinfo.btrfs_inode.num_slabs
    195.00            +3.3%     201.50 ±  7%  slabinfo.buffer_head.active_objs
      5.00            +3.3%       5.17 ±  7%  slabinfo.buffer_head.active_slabs
    195.00            +3.3%     201.50 ±  7%  slabinfo.buffer_head.num_objs
      5.00            +3.3%       5.17 ±  7%  slabinfo.buffer_head.num_slabs
      6299 ±  2%      -1.5%       6208 ±  2%  slabinfo.cred_jar.active_objs
    149.17 ±  2%      -1.5%     147.00 ±  2%  slabinfo.cred_jar.active_slabs
      6299 ±  2%      -1.5%       6208 ±  2%  slabinfo.cred_jar.num_objs
    149.17 ±  2%      -1.5%     147.00 ±  2%  slabinfo.cred_jar.num_slabs
     42.00            +0.0%      42.00        slabinfo.dax_cache.active_objs
      1.00            +0.0%       1.00        slabinfo.dax_cache.active_slabs
     42.00            +0.0%      42.00        slabinfo.dax_cache.num_objs
      1.00            +0.0%       1.00        slabinfo.dax_cache.num_slabs
    111820            -0.6%     111175        slabinfo.dentry.active_objs
      2672            -0.5%       2659        slabinfo.dentry.active_slabs
    112250            -0.5%     111695        slabinfo.dentry.num_objs
      2672            -0.5%       2659        slabinfo.dentry.num_slabs
     30.00            +0.0%      30.00        slabinfo.dmaengine-unmap-128.active_objs
      1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-128.active_slabs
     30.00            +0.0%      30.00        slabinfo.dmaengine-unmap-128.num_objs
      1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-128.num_slabs
    799.50 ±  4%      -7.3%     741.17 ±  6%  slabinfo.dmaengine-unmap-16.active_objs
     18.50 ±  5%      -7.2%      17.17 ±  7%  slabinfo.dmaengine-unmap-16.active_slabs
    799.50 ±  4%      -7.3%     741.17 ±  6%  slabinfo.dmaengine-unmap-16.num_objs
     18.50 ±  5%      -7.2%      17.17 ±  7%  slabinfo.dmaengine-unmap-16.num_slabs
     15.00            +0.0%      15.00        slabinfo.dmaengine-unmap-256.active_objs
      1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-256.active_slabs
     15.00            +0.0%      15.00        slabinfo.dmaengine-unmap-256.num_objs
      1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-256.num_slabs
     20305 ±  7%      -0.9%      20122 ±  9%  slabinfo.ep_head.active_objs
     78.83 ±  7%      -1.1%      78.00 ±  9%  slabinfo.ep_head.active_slabs
     20305 ±  7%      -0.9%      20122 ±  9%  slabinfo.ep_head.num_objs
     78.83 ±  7%      -1.1%      78.00 ±  9%  slabinfo.ep_head.num_slabs
    729.67 ±  7%      -5.7%     688.00 ±  8%  slabinfo.file_lock_cache.active_objs
     19.33 ±  7%      -5.2%      18.33 ±  8%  slabinfo.file_lock_cache.active_slabs
    729.67 ±  7%      -5.7%     688.00 ±  8%  slabinfo.file_lock_cache.num_objs
     19.33 ±  7%      -5.2%      18.33 ±  8%  slabinfo.file_lock_cache.num_slabs
      4282 ±  3%      -1.9%       4199 ±  6%  slabinfo.files_cache.active_objs
     92.50 ±  3%      -1.8%      90.83 ±  6%  slabinfo.files_cache.active_slabs
      4282 ±  3%      -1.9%       4199 ±  6%  slabinfo.files_cache.num_objs
     92.50 ±  3%      -1.8%      90.83 ±  6%  slabinfo.files_cache.num_slabs
     13284 ±  2%      -0.5%      13222        slabinfo.filp.active_objs
    433.33            +0.7%     436.50 ±  3%  slabinfo.filp.active_slabs
     13876            +0.8%      13988 ±  3%  slabinfo.filp.num_objs
    433.33            +0.7%     436.50 ±  3%  slabinfo.filp.num_slabs
      1920 ±  7%      -3.3%       1856 ± 10%  slabinfo.fsnotify_mark_connector.active_objs
     15.00 ±  7%      -3.3%      14.50 ± 10%  slabinfo.fsnotify_mark_connector.active_slabs
      1920 ±  7%      -3.3%       1856 ± 10%  slabinfo.fsnotify_mark_connector.num_objs
     15.00 ±  7%      -3.3%      14.50 ± 10%  slabinfo.fsnotify_mark_connector.num_slabs
     31577            +0.1%      31605        slabinfo.ftrace_event_field.active_objs
    371.50            +0.1%     371.83        slabinfo.ftrace_event_field.active_slabs
     31577            +0.1%      31605        slabinfo.ftrace_event_field.num_objs
    371.50            +0.1%     371.83        slabinfo.ftrace_event_field.num_slabs
    224.00            +0.0%     224.00        slabinfo.fuse_request.active_objs
      4.00            +0.0%       4.00        slabinfo.fuse_request.active_slabs
    224.00            +0.0%     224.00        slabinfo.fuse_request.num_objs
      4.00            +0.0%       4.00        slabinfo.fuse_request.num_slabs
     98.00            +0.0%      98.00        slabinfo.hugetlbfs_inode_cache.active_objs
      2.00            +0.0%       2.00        slabinfo.hugetlbfs_inode_cache.active_slabs
     98.00            +0.0%      98.00        slabinfo.hugetlbfs_inode_cache.num_objs
      2.00            +0.0%       2.00        slabinfo.hugetlbfs_inode_cache.num_slabs
     89306            -0.1%      89258        slabinfo.inode_cache.active_objs
      1751            -0.0%       1750        slabinfo.inode_cache.active_slabs
     89338            -0.0%      89296        slabinfo.inode_cache.num_objs
      1751            -0.0%       1750        slabinfo.inode_cache.num_slabs
    206.83 ± 13%      +0.0%     206.83 ± 13%  slabinfo.ip_fib_alias.active_objs
      2.83 ± 13%      +0.0%       2.83 ± 13%  slabinfo.ip_fib_alias.active_slabs
    206.83 ± 13%      +0.0%     206.83 ± 13%  slabinfo.ip_fib_alias.num_objs
      2.83 ± 13%      +0.0%       2.83 ± 13%  slabinfo.ip_fib_alias.num_slabs
    240.83 ± 13%      +0.0%     240.83 ± 13%  slabinfo.ip_fib_trie.active_objs
      2.83 ± 13%      +0.0%       2.83 ± 13%  slabinfo.ip_fib_trie.active_slabs
    240.83 ± 13%      +0.0%     240.83 ± 13%  slabinfo.ip_fib_trie.num_objs
      2.83 ± 13%      +0.0%       2.83 ± 13%  slabinfo.ip_fib_trie.num_slabs
     87791            -0.1%      87726        slabinfo.kernfs_node_cache.active_objs
      2745            -0.1%       2741        slabinfo.kernfs_node_cache.active_slabs
     87850            -0.1%      87738        slabinfo.kernfs_node_cache.num_objs
      2745            -0.1%       2741        slabinfo.kernfs_node_cache.num_slabs
      1601 ± 10%      -1.5%       1577 ± 16%  slabinfo.khugepaged_mm_slot.active_objs
     44.00 ± 10%      -1.5%      43.33 ± 17%  slabinfo.khugepaged_mm_slot.active_slabs
      1601 ± 10%      -1.5%       1577 ± 16%  slabinfo.khugepaged_mm_slot.num_objs
     44.00 ± 10%      -1.5%      43.33 ± 17%  slabinfo.khugepaged_mm_slot.num_slabs
      5617            +0.3%       5635        slabinfo.kmalloc-128.active_objs
    175.67            +0.3%     176.17        slabinfo.kmalloc-128.active_slabs
      5626            +0.3%       5642        slabinfo.kmalloc-128.num_objs
    175.67            +0.3%     176.17        slabinfo.kmalloc-128.num_slabs
     36827            +0.4%      36986        slabinfo.kmalloc-16.active_objs
    144.00            +0.2%     144.33        slabinfo.kmalloc-16.active_slabs
     36864            +0.3%      36991        slabinfo.kmalloc-16.num_objs
    144.00            +0.2%     144.33        slabinfo.kmalloc-16.num_slabs
      5786            +0.1%       5793        slabinfo.kmalloc-192.active_objs
    136.83            +0.1%     137.00        slabinfo.kmalloc-192.active_slabs
      5786            +0.1%       5794        slabinfo.kmalloc-192.num_objs
    136.83            +0.1%     137.00        slabinfo.kmalloc-192.num_slabs
      5512        +7.5e+05%   41441174 ±  2%  slabinfo.kmalloc-1k.active_objs
    172.50        +7.5e+05%    1295036 ±  2%  slabinfo.kmalloc-1k.active_slabs
      5533        +7.5e+05%   41441175 ±  2%  slabinfo.kmalloc-1k.num_objs
    172.50        +7.5e+05%    1295036 ±  2%  slabinfo.kmalloc-1k.num_slabs
      9216 ±  2%      +2.4%       9441 ±  3%  slabinfo.kmalloc-256.active_objs
    293.83 ±  2%      +2.3%     300.50 ±  3%  slabinfo.kmalloc-256.active_slabs
      9418 ±  2%      +2.3%       9630 ±  3%  slabinfo.kmalloc-256.num_objs
    293.83 ±  2%      +2.3%     300.50 ±  3%  slabinfo.kmalloc-256.num_slabs
      3206            +0.4%       3219        slabinfo.kmalloc-2k.active_objs
    201.50            +0.9%     203.33        slabinfo.kmalloc-2k.active_slabs
      3235            +0.8%       3261        slabinfo.kmalloc-2k.num_objs
    201.50            +0.9%     203.33        slabinfo.kmalloc-2k.num_slabs
     48725            +0.2%      48801        slabinfo.kmalloc-32.active_objs
    380.67            +0.3%     381.67        slabinfo.kmalloc-32.active_slabs
     48775            +0.3%      48918        slabinfo.kmalloc-32.num_objs
    380.67            +0.3%     381.67        slabinfo.kmalloc-32.num_slabs
      1578            -0.1%       1576        slabinfo.kmalloc-4k.active_objs
    198.17            -0.1%     198.00        slabinfo.kmalloc-4k.active_slabs
      1589            -0.1%       1588        slabinfo.kmalloc-4k.num_objs
    198.17            -0.1%     198.00        slabinfo.kmalloc-4k.num_slabs
     11984            +0.4%      12027        slabinfo.kmalloc-512.active_objs
    375.83            +0.3%     377.00        slabinfo.kmalloc-512.active_slabs
     12045            +0.3%      12078        slabinfo.kmalloc-512.num_objs
    375.83            +0.3%     377.00        slabinfo.kmalloc-512.num_slabs
     48777            -0.1%      48751        slabinfo.kmalloc-64.active_objs
    761.50            +0.0%     761.50        slabinfo.kmalloc-64.active_slabs
     48798            -0.0%      48788        slabinfo.kmalloc-64.num_objs
    761.50            +0.0%     761.50        slabinfo.kmalloc-64.num_slabs
     55620            -0.6%      55275        slabinfo.kmalloc-8.active_objs
    111.17            -0.1%     111.00 ±  2%  slabinfo.kmalloc-8.active_slabs
     57001            -0.3%      56832 ±  2%  slabinfo.kmalloc-8.num_objs
    111.17            -0.1%     111.00 ±  2%  slabinfo.kmalloc-8.num_slabs
    864.83            -0.2%     863.00        slabinfo.kmalloc-8k.active_objs
    217.00            +0.0%     217.00        slabinfo.kmalloc-8k.active_slabs
    870.33            -0.0%     870.00        slabinfo.kmalloc-8k.num_objs
    217.00            +0.0%     217.00        slabinfo.kmalloc-8k.num_slabs
      5701            +0.3%       5719        slabinfo.kmalloc-96.active_objs
    137.33            +0.0%     137.33        slabinfo.kmalloc-96.active_slabs
      5768            +0.0%       5768        slabinfo.kmalloc-96.num_objs
    137.33            +0.0%     137.33        slabinfo.kmalloc-96.num_slabs
    213.33 ± 14%     -17.5%     176.00 ± 13%  slabinfo.kmalloc-cg-128.active_objs
      6.67 ± 14%     -17.5%       5.50 ± 13%  slabinfo.kmalloc-cg-128.active_slabs
    213.33 ± 14%     -17.5%     176.00 ± 13%  slabinfo.kmalloc-cg-128.num_objs
      6.67 ± 14%     -17.5%       5.50 ± 13%  slabinfo.kmalloc-cg-128.num_slabs
      2714 ± 13%      -3.6%       2616 ± 12%  slabinfo.kmalloc-cg-16.active_objs
     10.33 ± 14%      -3.2%      10.00 ± 11%  slabinfo.kmalloc-cg-16.active_slabs
      2714 ± 13%      -3.6%       2616 ± 12%  slabinfo.kmalloc-cg-16.num_objs
     10.33 ± 14%      -3.2%      10.00 ± 11%  slabinfo.kmalloc-cg-16.num_slabs
      3676 ±  4%      -3.6%       3545 ±  6%  slabinfo.kmalloc-cg-192.active_objs
     87.00 ±  4%      -3.6%      83.83 ±  6%  slabinfo.kmalloc-cg-192.active_slabs
      3676 ±  4%      -3.6%       3545 ±  6%  slabinfo.kmalloc-cg-192.num_objs
     87.00 ±  4%      -3.6%      83.83 ±  6%  slabinfo.kmalloc-cg-192.num_slabs
      3193 ±  4%      -1.9%       3134 ±  3%  slabinfo.kmalloc-cg-1k.active_objs
     99.17 ±  3%      -1.8%      97.33 ±  3%  slabinfo.kmalloc-cg-1k.active_slabs
      3193 ±  4%      -1.9%       3134 ±  3%  slabinfo.kmalloc-cg-1k.num_objs
     99.17 ±  3%      -1.8%      97.33 ±  3%  slabinfo.kmalloc-cg-1k.num_slabs
    183.33 ±  7%      -5.1%     174.00 ±  8%  slabinfo.kmalloc-cg-256.active_objs
      5.50 ±  9%      -3.0%       5.33 ±  8%  slabinfo.kmalloc-cg-256.active_slabs
    183.33 ±  7%      -5.1%     174.00 ±  8%  slabinfo.kmalloc-cg-256.num_objs
      5.50 ±  9%      -3.0%       5.33 ±  8%  slabinfo.kmalloc-cg-256.num_slabs
    318.33 ±  8%      -2.5%     310.33 ± 10%  slabinfo.kmalloc-cg-2k.active_objs
     19.00 ±  8%      -2.6%      18.50 ± 10%  slabinfo.kmalloc-cg-2k.active_slabs
    318.33 ±  8%      -2.5%     310.33 ± 10%  slabinfo.kmalloc-cg-2k.num_objs
     19.00 ±  8%      -2.6%      18.50 ± 10%  slabinfo.kmalloc-cg-2k.num_slabs
     11936            -3.1%      11568 ±  3%  slabinfo.kmalloc-cg-32.active_objs
     92.67            -3.4%      89.50 ±  3%  slabinfo.kmalloc-cg-32.active_slabs
     11936            -3.1%      11568 ±  3%  slabinfo.kmalloc-cg-32.num_objs
     92.67            -3.4%      89.50 ±  3%  slabinfo.kmalloc-cg-32.num_slabs
    965.83            +0.4%     969.67        slabinfo.kmalloc-cg-4k.active_objs
    123.00            +0.9%     124.17 ±  2%  slabinfo.kmalloc-cg-4k.active_slabs
    988.50 ±  2%      +0.7%     995.83 ±  2%  slabinfo.kmalloc-cg-4k.num_objs
    123.00            +0.9%     124.17 ±  2%  slabinfo.kmalloc-cg-4k.num_slabs
      3018            -0.9%       2991        slabinfo.kmalloc-cg-512.active_objs
     94.00            -0.7%      93.33 ±  2%  slabinfo.kmalloc-cg-512.active_slabs
      3018            -0.9%       2991        slabinfo.kmalloc-cg-512.num_objs
     94.00            -0.7%      93.33 ±  2%  slabinfo.kmalloc-cg-512.num_slabs
      1689 ±  8%      +1.9%       1721 ±  5%  slabinfo.kmalloc-cg-64.active_objs
     25.50 ±  8%      +2.0%      26.00 ±  5%  slabinfo.kmalloc-cg-64.active_slabs
      1689 ±  8%      +1.9%       1721 ±  5%  slabinfo.kmalloc-cg-64.num_objs
     25.50 ±  8%      +2.0%      26.00 ±  5%  slabinfo.kmalloc-cg-64.num_slabs
     49663            -0.0%      49639        slabinfo.kmalloc-cg-8.active_objs
     96.83            -0.3%      96.50        slabinfo.kmalloc-cg-8.active_slabs
     49663            -0.0%      49639        slabinfo.kmalloc-cg-8.num_objs
     96.83            -0.3%      96.50        slabinfo.kmalloc-cg-8.num_slabs
     40.00 ±  4%      +1.7%      40.67 ±  4%  slabinfo.kmalloc-cg-8k.active_objs
      9.67 ±  4%      +1.7%       9.83 ±  3%  slabinfo.kmalloc-cg-8k.active_slabs
     40.00 ±  4%      +1.7%      40.67 ±  4%  slabinfo.kmalloc-cg-8k.num_objs
      9.67 ±  4%      +1.7%       9.83 ±  3%  slabinfo.kmalloc-cg-8k.num_slabs
    409.67 ± 10%      -5.1%     388.67 ± 11%  slabinfo.kmalloc-cg-96.active_objs
      8.83 ± 12%      -5.7%       8.33 ± 13%  slabinfo.kmalloc-cg-96.active_slabs
    409.67 ± 10%      -5.1%     388.67 ± 11%  slabinfo.kmalloc-cg-96.num_objs
      8.83 ± 12%      -5.7%       8.33 ± 13%  slabinfo.kmalloc-cg-96.num_slabs
     64.00            +0.0%      64.00        slabinfo.kmalloc-rcl-128.active_objs
      2.00            +0.0%       2.00        slabinfo.kmalloc-rcl-128.active_slabs
     64.00            +0.0%      64.00        slabinfo.kmalloc-rcl-128.num_objs
      2.00            +0.0%       2.00        slabinfo.kmalloc-rcl-128.num_slabs
     42.00            +0.0%      42.00        slabinfo.kmalloc-rcl-192.active_objs
      1.00            +0.0%       1.00        slabinfo.kmalloc-rcl-192.active_slabs
     42.00            +0.0%      42.00        slabinfo.kmalloc-rcl-192.num_objs
      1.00            +0.0%       1.00        slabinfo.kmalloc-rcl-192.num_slabs
      7660 ±  6%      +1.5%       7775 ±  2%  slabinfo.kmalloc-rcl-64.active_objs
    119.00 ±  6%      +1.7%     121.00 ±  2%  slabinfo.kmalloc-rcl-64.active_slabs
      7660 ±  6%      +1.5%       7775 ±  2%  slabinfo.kmalloc-rcl-64.num_objs
    119.00 ±  6%      +1.7%     121.00 ±  2%  slabinfo.kmalloc-rcl-64.num_slabs
      1274 ±  5%      -2.7%       1239 ±  6%  slabinfo.kmalloc-rcl-96.active_objs
     30.33 ±  5%      -2.7%      29.50 ±  6%  slabinfo.kmalloc-rcl-96.active_slabs
      1274 ±  5%      -2.7%       1239 ±  6%  slabinfo.kmalloc-rcl-96.num_objs
     30.33 ±  5%      -2.7%      29.50 ±  6%  slabinfo.kmalloc-rcl-96.num_slabs
    384.00 ±  9%      +0.0%     384.00 ±  4%  slabinfo.kmem_cache.active_objs
     12.00 ±  9%      +0.0%      12.00 ±  4%  slabinfo.kmem_cache.active_slabs
    384.00 ±  9%      +0.0%     384.00 ±  4%  slabinfo.kmem_cache.num_objs
     12.00 ±  9%      +0.0%      12.00 ±  4%  slabinfo.kmem_cache.num_slabs
    819.00 ±  9%      -2.7%     796.67 ±  5%  slabinfo.kmem_cache_node.active_objs
     13.00 ±  8%      -2.6%      12.67 ±  5%  slabinfo.kmem_cache_node.active_slabs
    832.00 ±  8%      -2.6%     810.67 ±  5%  slabinfo.kmem_cache_node.num_objs
     13.00 ±  8%      -2.6%      12.67 ±  5%  slabinfo.kmem_cache_node.num_slabs
     18699            +1.4%      18969        slabinfo.lsm_file_cache.active_objs
    109.83            +1.5%     111.50        slabinfo.lsm_file_cache.active_slabs
     18803            +1.5%      19088        slabinfo.lsm_file_cache.num_objs
    109.83            +1.5%     111.50        slabinfo.lsm_file_cache.num_slabs
      3048            +0.0%       3048        slabinfo.mm_struct.active_objs
    100.83            +0.2%     101.00        slabinfo.mm_struct.active_slabs
      3048            +0.0%       3048        slabinfo.mm_struct.num_objs
    100.83            +0.2%     101.00        slabinfo.mm_struct.num_slabs
    782.00 ± 11%      -4.3%     748.00 ± 11%  slabinfo.mnt_cache.active_objs
     15.33 ± 11%      -4.3%      14.67 ± 11%  slabinfo.mnt_cache.active_slabs
    782.00 ± 11%      -4.3%     748.00 ± 11%  slabinfo.mnt_cache.num_objs
     15.33 ± 11%      -4.3%      14.67 ± 11%  slabinfo.mnt_cache.num_slabs
     34.00            +0.0%      34.00        slabinfo.mqueue_inode_cache.active_objs
      1.00            +0.0%       1.00        slabinfo.mqueue_inode_cache.active_slabs
     34.00            +0.0%      34.00        slabinfo.mqueue_inode_cache.num_objs
      1.00            +0.0%       1.00        slabinfo.mqueue_inode_cache.num_slabs
    768.00            +0.3%     770.67        slabinfo.names_cache.active_objs
     96.00            +0.3%      96.33        slabinfo.names_cache.active_slabs
    768.00            +0.3%     770.67        slabinfo.names_cache.num_objs
     96.00            +0.3%      96.33        slabinfo.names_cache.num_slabs
      8.00            +0.0%       8.00        slabinfo.net_namespace.active_objs
      1.00            +0.0%       1.00        slabinfo.net_namespace.active_slabs
      8.00            +0.0%       8.00        slabinfo.net_namespace.num_objs
      1.00            +0.0%       1.00        slabinfo.net_namespace.num_slabs
     34.00            +0.0%      34.00        slabinfo.nfs_read_data.active_objs
      1.00            +0.0%       1.00        slabinfo.nfs_read_data.active_slabs
     34.00            +0.0%      34.00        slabinfo.nfs_read_data.num_objs
      1.00            +0.0%       1.00        slabinfo.nfs_read_data.num_slabs
    240.83 ±  8%      -7.3%     223.17 ± 17%  slabinfo.nsproxy.active_objs
      4.17 ±  8%      -8.0%       3.83 ± 17%  slabinfo.nsproxy.active_slabs
    240.83 ±  8%      -7.3%     223.17 ± 17%  slabinfo.nsproxy.num_objs
      4.17 ±  8%      -8.0%       3.83 ± 17%  slabinfo.nsproxy.num_slabs
    120.00            +0.0%     120.00        slabinfo.numa_policy.active_objs
      2.00            +0.0%       2.00        slabinfo.numa_policy.active_slabs
    120.00            +0.0%     120.00        slabinfo.numa_policy.num_objs
      2.00            +0.0%       2.00        slabinfo.numa_policy.num_slabs
      9343            -2.2%       9138 ±  3%  slabinfo.pde_opener.active_objs
     91.00            -1.8%      89.33 ±  3%  slabinfo.pde_opener.active_slabs
      9343            -2.2%       9138 ±  3%  slabinfo.pde_opener.num_objs
     91.00            -1.8%      89.33 ±  3%  slabinfo.pde_opener.num_slabs
      4044            +0.3%       4056        slabinfo.perf_event.active_objs
    150.50            +0.7%     151.50        slabinfo.perf_event.active_slabs
      4079            +0.6%       4102        slabinfo.perf_event.num_objs
    150.50            +0.7%     151.50        slabinfo.perf_event.num_slabs
     21919 ±  6%      +1.1%      22149 ±  4%  slabinfo.pid.active_objs
    689.50 ±  6%      +1.1%     696.83 ±  4%  slabinfo.pid.active_slabs
     22084 ±  6%      +1.0%      22314 ±  4%  slabinfo.pid.num_objs
    689.50 ±  6%      +1.1%     696.83 ±  4%  slabinfo.pid.num_slabs
      1272 ±  8%      -0.7%       1264 ±  3%  slabinfo.pool_workqueue.active_objs
     40.00 ±  9%      -1.2%      39.50 ±  3%  slabinfo.pool_workqueue.active_slabs
      1280 ±  9%      -1.2%       1264 ±  3%  slabinfo.pool_workqueue.num_objs
     40.00 ±  9%      -1.2%      39.50 ±  3%  slabinfo.pool_workqueue.num_slabs
      2856 ±  2%      +1.2%       2891 ±  2%  slabinfo.proc_dir_entry.active_objs
     68.00 ±  2%      +1.2%      68.83 ±  2%  slabinfo.proc_dir_entry.active_slabs
      2856 ±  2%      +1.2%       2891 ±  2%  slabinfo.proc_dir_entry.num_objs
     68.00 ±  2%      +1.2%      68.83 ±  2%  slabinfo.proc_dir_entry.num_slabs
     11408            -0.3%      11376        slabinfo.proc_inode_cache.active_objs
    247.50            -0.3%     246.83        slabinfo.proc_inode_cache.active_slabs
     11413            -0.3%      11381        slabinfo.proc_inode_cache.num_objs
    247.50            -0.3%     246.83        slabinfo.proc_inode_cache.num_slabs
     30220            +0.3%      30309        slabinfo.radix_tree_node.active_objs
    540.17            +0.3%     541.67        slabinfo.radix_tree_node.active_slabs
     30274            +0.3%      30369        slabinfo.radix_tree_node.num_objs
    540.17            +0.3%     541.67        slabinfo.radix_tree_node.num_slabs
     48.00            +0.0%      48.00        slabinfo.request_queue.active_objs
      2.00            +0.0%       2.00        slabinfo.request_queue.active_slabs
     48.00            +0.0%      48.00        slabinfo.request_queue.num_objs
      2.00            +0.0%       2.00        slabinfo.request_queue.num_slabs
    294.33            -3.1%     285.33 ±  4%  slabinfo.request_sock_TCP.active_objs
      5.00            +0.0%       5.00        slabinfo.request_sock_TCP.active_slabs
    294.33            -3.1%     285.33 ±  4%  slabinfo.request_sock_TCP.num_objs
      5.00            +0.0%       5.00        slabinfo.request_sock_TCP.num_slabs
     46.00            +0.0%      46.00        slabinfo.rpc_inode_cache.active_objs
      1.00            +0.0%       1.00        slabinfo.rpc_inode_cache.active_slabs
     46.00            +0.0%      46.00        slabinfo.rpc_inode_cache.num_objs
      1.00            +0.0%       1.00        slabinfo.rpc_inode_cache.num_slabs
    640.00            +0.0%     640.00        slabinfo.scsi_sense_cache.active_objs
     20.00            +0.0%      20.00        slabinfo.scsi_sense_cache.active_slabs
    640.00            +0.0%     640.00        slabinfo.scsi_sense_cache.num_objs
     20.00            +0.0%      20.00        slabinfo.scsi_sense_cache.num_slabs
      3426            +0.3%       3437        slabinfo.seq_file.active_objs
     99.83            +0.3%     100.17        slabinfo.seq_file.active_slabs
      3426            +0.3%       3437        slabinfo.seq_file.num_objs
     99.83            +0.3%     100.17        slabinfo.seq_file.num_slabs
      4739 ±  2%      -0.6%       4710 ±  2%  slabinfo.shmem_inode_cache.active_objs
    112.50 ±  2%      -0.9%     111.50 ±  2%  slabinfo.shmem_inode_cache.active_slabs
      4739 ±  2%      -0.6%       4710 ±  2%  slabinfo.shmem_inode_cache.num_objs
    112.50 ±  2%      -0.9%     111.50 ±  2%  slabinfo.shmem_inode_cache.num_slabs
      2284 ±  3%      -1.7%       2245 ±  3%  slabinfo.sighand_cache.active_objs
    152.67 ±  2%      -2.2%     149.33 ±  3%  slabinfo.sighand_cache.active_slabs
      2294 ±  3%      -2.1%       2245 ±  3%  slabinfo.sighand_cache.num_objs
    152.67 ±  2%      -2.2%     149.33 ±  3%  slabinfo.sighand_cache.num_slabs
      3952 ±  2%      +1.6%       4015 ±  4%  slabinfo.signal_cache.active_objs
    140.50 ±  2%      +1.5%     142.67 ±  4%  slabinfo.signal_cache.active_slabs
      3952 ±  2%      +1.6%       4015 ±  4%  slabinfo.signal_cache.num_objs
    140.50 ±  2%      +1.5%     142.67 ±  4%  slabinfo.signal_cache.num_slabs
      5455            -1.2%       5390        slabinfo.sigqueue.active_objs
    106.17            -1.3%     104.83        slabinfo.sigqueue.active_slabs
      5455            -1.2%       5390        slabinfo.sigqueue.num_objs
    106.17            -1.3%     104.83        slabinfo.sigqueue.num_slabs
      1536 ± 15%  +2.7e+06%   41436616 ±  2%  slabinfo.skbuff_fclone_cache.active_objs
     47.33 ± 15%  +2.7e+06%    1294893 ±  2%  slabinfo.skbuff_fclone_cache.active_slabs
      1536 ± 15%  +2.7e+06%   41436617 ±  2%  slabinfo.skbuff_fclone_cache.num_objs
     47.33 ± 15%  +2.7e+06%    1294893 ±  2%  slabinfo.skbuff_fclone_cache.num_slabs
      4496 ±  5%      -1.0%       4453 ±  3%  slabinfo.skbuff_head_cache.active_objs
    142.17 ±  4%      -0.7%     141.17 ±  3%  slabinfo.skbuff_head_cache.active_slabs
      4549 ±  4%      -0.7%       4517 ±  3%  slabinfo.skbuff_head_cache.num_objs
    142.17 ±  4%      -0.7%     141.17 ±  3%  slabinfo.skbuff_head_cache.num_slabs
      3046 ± 10%      +1.5%       3090 ± 11%  slabinfo.sock_inode_cache.active_objs
     77.50 ± 10%      +1.3%      78.50 ± 11%  slabinfo.sock_inode_cache.active_slabs
      3046 ± 10%      +1.5%       3090 ± 11%  slabinfo.sock_inode_cache.num_objs
     77.50 ± 10%      +1.3%      78.50 ± 11%  slabinfo.sock_inode_cache.num_slabs
      1279 ±  6%      -2.8%       1243 ±  5%  slabinfo.task_group.active_objs
     24.33 ±  6%      -2.1%      23.83 ±  6%  slabinfo.task_group.active_slabs
      1279 ±  6%      -2.8%       1243 ±  5%  slabinfo.task_group.num_objs
     24.33 ±  6%      -2.1%      23.83 ±  6%  slabinfo.task_group.num_slabs
      1715            -1.4%       1690 ±  2%  slabinfo.task_struct.active_objs
      1717            -1.4%       1692 ±  2%  slabinfo.task_struct.active_slabs
      1717            -1.4%       1692 ±  2%  slabinfo.task_struct.num_objs
      1717            -1.4%       1692 ±  2%  slabinfo.task_struct.num_slabs
    314.50            -8.3%     288.33 ±  8%  slabinfo.taskstats.active_objs
      7.00            -9.5%       6.33 ±  7%  slabinfo.taskstats.active_slabs
    314.50            -8.3%     288.33 ±  8%  slabinfo.taskstats.num_objs
      7.00            -9.5%       6.33 ±  7%  slabinfo.taskstats.num_slabs
      2606 ±  2%      +0.9%       2629 ±  3%  slabinfo.trace_event_file.active_objs
     56.67 ±  2%      +0.9%      57.17 ±  3%  slabinfo.trace_event_file.active_slabs
      2606 ±  2%      +0.9%       2629 ±  3%  slabinfo.trace_event_file.num_objs
     56.67 ±  2%      +0.9%      57.17 ±  3%  slabinfo.trace_event_file.num_slabs
    204.33 ±  6%      +4.1%     212.67 ±  3%  slabinfo.tw_sock_TCP.active_objs
      5.50 ±  9%      +9.1%       6.00        slabinfo.tw_sock_TCP.active_slabs
    204.33 ±  6%      +4.1%     212.67 ±  3%  slabinfo.tw_sock_TCP.num_objs
      5.50 ±  9%      +9.1%       6.00        slabinfo.tw_sock_TCP.num_slabs
     67.83 ± 20%      +9.1%      74.00        slabinfo.uts_namespace.active_objs
      1.83 ± 20%      +9.1%       2.00        slabinfo.uts_namespace.active_slabs
     67.83 ± 20%      +9.1%      74.00        slabinfo.uts_namespace.num_objs
      1.83 ± 20%      +9.1%       2.00        slabinfo.uts_namespace.num_slabs
     19463 ±  4%      -1.3%      19206 ±  2%  slabinfo.vm_area_struct.active_objs
    488.83 ±  4%      -1.3%     482.50 ±  2%  slabinfo.vm_area_struct.active_slabs
     19563 ±  4%      -1.2%      19320 ±  2%  slabinfo.vm_area_struct.num_objs
    488.83 ±  4%      -1.3%     482.50 ±  2%  slabinfo.vm_area_struct.num_slabs
     14489            +1.5%      14701        slabinfo.vmap_area.active_objs
    225.83            +1.5%     229.17        slabinfo.vmap_area.active_slabs
     14490            +1.5%      14702        slabinfo.vmap_area.num_objs
    225.83            +1.5%     229.17        slabinfo.vmap_area.num_slabs
     42.00            +0.0%      42.00        slabinfo.xfrm_state.active_objs
      1.00            +0.0%       1.00        slabinfo.xfrm_state.active_slabs
     42.00            +0.0%      42.00        slabinfo.xfrm_state.num_objs
      1.00            +0.0%       1.00        slabinfo.xfrm_state.num_slabs
    451.50            -3.2%     437.17 ±  6%  softirqs.BLOCK
      2.00            +0.0%       2.00        softirqs.HI
  45336235            +0.0%   45336401        softirqs.NET_RX
     17.67 ±  5%      +0.0%      17.67 ±  2%  softirqs.NET_TX
   3004096 ±  6%      +9.4%    3285370 ±  9%  softirqs.RCU
   1660048 ±  3%      +5.7%    1754109 ±  7%  softirqs.SCHED
    257.00            +0.3%     257.67        softirqs.TASKLET
     32626            +4.4%      34073 ±  2%  softirqs.TIMER
     10.56 ± 13%      -1.8        8.76 ±  9%  perf-profile.calltrace.cycles-pp.__napi_poll.net_rx_action.__softirqentry_text_start.do_softirq.__local_bh_enable_ip
     10.53 ± 13%      -1.8        8.74 ±  9%  perf-profile.calltrace.cycles-pp.process_backlog.__napi_poll.net_rx_action.__softirqentry_text_start.do_softirq
     10.22 ± 13%      -1.8        8.45 ±  9%  perf-profile.calltrace.cycles-pp.__netif_receive_skb_one_core.process_backlog.__napi_poll.net_rx_action.__softirqentry_text_start
      9.78 ± 13%      -1.7        8.05 ± 10%  perf-profile.calltrace.cycles-pp.ip_local_deliver_finish.__netif_receive_skb_one_core.process_backlog.__napi_poll.net_rx_action
      9.65 ± 13%      -1.7        7.92 ± 10%  perf-profile.calltrace.cycles-pp.tcp_v4_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish.__netif_receive_skb_one_core.process_backlog
      9.74 ± 13%      -1.7        8.01 ± 10%  perf-profile.calltrace.cycles-pp.ip_protocol_deliver_rcu.ip_local_deliver_finish.__netif_receive_skb_one_core.process_backlog.__napi_poll
      8.22 ± 14%      -1.6        6.66 ± 11%  perf-profile.calltrace.cycles-pp.tcp_v4_do_rcv.tcp_v4_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish.__netif_receive_skb_one_core
      8.16 ± 14%      -1.5        6.62 ± 11%  perf-profile.calltrace.cycles-pp.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish
     11.36 ± 12%      -1.4        9.97 ± 15%  perf-profile.calltrace.cycles-pp.__local_bh_enable_ip.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit
      2.06 ± 11%      -1.3        0.73 ± 56%  perf-profile.calltrace.cycles-pp.tcp_clean_rtx_queue.tcp_ack.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv
     11.25 ± 12%      -1.3        9.94 ± 15%  perf-profile.calltrace.cycles-pp.do_softirq.__local_bh_enable_ip.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_skb
     11.14 ± 13%      -1.3        9.88 ± 15%  perf-profile.calltrace.cycles-pp.__softirqentry_text_start.do_softirq.__local_bh_enable_ip.ip_finish_output2.__ip_queue_xmit
     12.80 ± 12%      -1.2       11.58 ± 14%  perf-profile.calltrace.cycles-pp.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames
     15.90 ± 11%      -1.2       14.69 ± 12%  perf-profile.calltrace.cycles-pp.tcp_write_xmit.__tcp_push_pending_frames.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg
     10.75 ± 13%      -1.2        9.55 ± 15%  perf-profile.calltrace.cycles-pp.net_rx_action.__softirqentry_text_start.do_softirq.__local_bh_enable_ip.ip_finish_output2
      2.94 ± 10%      -1.2        1.78 ±  8%  perf-profile.calltrace.cycles-pp.tcp_ack.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_protocol_deliver_rcu
     13.53 ± 12%      -1.1       12.45 ± 13%  perf-profile.calltrace.cycles-pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames.tcp_sendmsg_locked
     14.78 ± 12%      -1.1       13.72 ± 12%  perf-profile.calltrace.cycles-pp.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames.tcp_sendmsg_locked.tcp_sendmsg
      9.13 ±  5%      -0.7        8.48 ± 11%  perf-profile.calltrace.cycles-pp.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_send.redisAsyncRead
      6.75 ±  4%      -0.6        6.10 ± 13%  perf-profile.calltrace.cycles-pp.__tcp_push_pending_frames.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg.__sys_sendto
      9.08 ±  5%      -0.6        8.44 ± 12%  perf-profile.calltrace.cycles-pp.__sys_sendto.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_send
      8.94 ±  5%      -0.6        8.31 ± 12%  perf-profile.calltrace.cycles-pp.sock_sendmsg.__sys_sendto.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.75 ±  7%      -0.6        9.14 ± 14%  perf-profile.calltrace.cycles-pp.__libc_send.redisAsyncRead
      6.03 ±  5%      -0.6        5.44 ±  8%  perf-profile.calltrace.cycles-pp.__x64_sys_epoll_ctl.do_syscall_64.entry_SYSCALL_64_after_hwframe.epoll_ctl
      9.52 ±  7%      -0.6        8.94 ± 14%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__libc_send.redisAsyncRead
      9.23 ± 18%      -0.6        8.66 ± 14%  perf-profile.calltrace.cycles-pp.__tcp_push_pending_frames.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg.sock_write_iter
     14.06 ±  8%      -0.6       13.49 ± 14%  perf-profile.calltrace.cycles-pp.redisAsyncRead
      9.46 ±  7%      -0.6        8.90 ± 14%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_send.redisAsyncRead
      0.56 ± 82%      -0.6        0.00        perf-profile.calltrace.cycles-pp.__kfree_skb.tcp_clean_rtx_queue.tcp_ack.tcp_rcv_established.tcp_v4_do_rcv
      5.56 ±  5%      -0.6        5.00 ±  8%  perf-profile.calltrace.cycles-pp.do_epoll_ctl.__x64_sys_epoll_ctl.do_syscall_64.entry_SYSCALL_64_after_hwframe.epoll_ctl
      8.72 ±  5%      -0.5        8.17 ± 12%  perf-profile.calltrace.cycles-pp.tcp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto.do_syscall_64
      3.01 ± 18%      -0.5        2.48 ± 16%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      8.52 ±  5%      -0.5        7.99 ± 12%  perf-profile.calltrace.cycles-pp.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto
      0.45 ± 80%      -0.5        0.00        perf-profile.calltrace.cycles-pp.skb_release_data.__kfree_skb.tcp_clean_rtx_queue.tcp_ack.tcp_rcv_established
      2.72 ± 18%      -0.4        2.27 ± 14%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call
      4.84 ± 12%      -0.4        4.48 ± 12%  perf-profile.calltrace.cycles-pp.__x64_sys_epoll_wait.do_syscall_64.entry_SYSCALL_64_after_hwframe.epoll_wait
      4.52 ± 13%      -0.4        4.16 ± 13%  perf-profile.calltrace.cycles-pp.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.61 ±  6%      -0.3        2.26 ±  9%  perf-profile.calltrace.cycles-pp.ep_insert.do_epoll_ctl.__x64_sys_epoll_ctl.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.63 ± 12%      -0.3        4.29 ± 13%  perf-profile.calltrace.cycles-pp.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64.entry_SYSCALL_64_after_hwframe.epoll_wait
      0.34 ± 70%      -0.3        0.00        perf-profile.calltrace.cycles-pp.writeHandler.redisAsyncRead
     12.92 ± 18%      -0.3       12.59 ± 11%  perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_write.connSocketConnect
     12.76 ± 18%      -0.3       12.43 ± 11%  perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_write
      0.41 ± 73%      -0.3        0.09 ±223%  perf-profile.calltrace.cycles-pp.tick_sched_handle.tick_sched_timer.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt
      0.40 ± 73%      -0.3        0.09 ±223%  perf-profile.calltrace.cycles-pp.update_process_times.tick_sched_handle.tick_sched_timer.__hrtimer_run_queues.hrtimer_interrupt
      0.30 ±100%      -0.3        0.00        perf-profile.calltrace.cycles-pp.timekeeping_max_deferment.tick_nohz_next_event.tick_nohz_get_sleep_length.menu_select.cpuidle_idle_call
      1.54 ± 72%      -0.3        1.25 ± 88%  perf-profile.calltrace.cycles-pp.get_perf_callchain.perf_callchain.perf_prepare_sample.perf_event_output_forward.__perf_event_overflow
     12.54 ± 18%      -0.3       12.25 ± 11%  perf-profile.calltrace.cycles-pp.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.55 ± 72%      -0.3        1.26 ± 88%  perf-profile.calltrace.cycles-pp.perf_callchain.perf_prepare_sample.perf_event_output_forward.__perf_event_overflow.perf_tp_event
      1.80 ± 19%      -0.3        1.51 ± 14%  perf-profile.calltrace.cycles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state
      1.82 ± 19%      -0.3        1.54 ± 14%  perf-profile.calltrace.cycles-pp.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter
     13.59 ± 17%      -0.3       13.32 ± 12%  perf-profile.calltrace.cycles-pp.__libc_write.connSocketConnect
     13.37 ± 17%      -0.3       13.11 ± 12%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__libc_write.connSocketConnect
     12.43 ± 18%      -0.3       12.17 ± 11%  perf-profile.calltrace.cycles-pp.sock_write_iter.new_sync_write.vfs_write.ksys_write.do_syscall_64
     13.30 ± 17%      -0.3       13.04 ± 12%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_write.connSocketConnect
     16.91 ± 17%      -0.2       16.67 ± 12%  perf-profile.calltrace.cycles-pp.connSocketConnect
     12.30 ± 18%      -0.2       12.06 ± 12%  perf-profile.calltrace.cycles-pp.sock_sendmsg.sock_write_iter.new_sync_write.vfs_write.ksys_write
      5.67 ±  7%      -0.2        5.46 ±  7%  perf-profile.calltrace.cycles-pp.epoll_wait
     32.95 ± 20%      -0.2       32.74 ± 24%  perf-profile.calltrace.cycles-pp.mwait_idle_with_hints.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call
      5.26 ±  7%      -0.2        5.05 ±  7%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.epoll_wait
      5.30 ±  7%      -0.2        5.10 ±  7%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.epoll_wait
      2.90 ± 23%      -0.2        2.71 ± 21%  perf-profile.calltrace.cycles-pp.ep_poll_callback.__wake_up_common.__wake_up_common_lock.sock_def_readable.tcp_rcv_established
      0.73 ± 21%      -0.2        0.54 ± 45%  perf-profile.calltrace.cycles-pp.tick_sched_timer.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt
      2.13 ± 10%      -0.2        1.94 ±  8%  perf-profile.calltrace.cycles-pp.ep_send_events.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64
      0.27 ±100%      -0.2        0.08 ±223%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc.ep_ptable_queue_proc.tcp_poll.sock_poll.ep_item_poll
      3.58 ± 21%      -0.2        3.40 ± 17%  perf-profile.calltrace.cycles-pp.sock_def_readable.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_protocol_deliver_rcu
      0.67 ± 11%      -0.2        0.49 ± 45%  perf-profile.calltrace.cycles-pp.ep_ptable_queue_proc.tcp_poll.sock_poll.ep_item_poll.ep_insert
      1.69 ± 12%      -0.2        1.52 ± 20%  perf-profile.calltrace.cycles-pp.__wake_up_common.__wake_up_common_lock.sock_def_readable.tcp_rcv_established.tcp_v4_do_rcv
      0.94 ± 19%      -0.2        0.78 ± 17%  perf-profile.calltrace.cycles-pp.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.63 ±  5%      -0.2        0.47 ± 45%  perf-profile.calltrace.cycles-pp.ep_unregister_pollwait.ep_remove.do_epoll_ctl.__x64_sys_epoll_ctl.do_syscall_64
      0.96 ± 10%      -0.2        0.81 ±  8%  perf-profile.calltrace.cycles-pp.ep_item_poll.ep_insert.do_epoll_ctl.__x64_sys_epoll_ctl.do_syscall_64
     12.05 ± 18%      -0.2       11.90 ± 12%  perf-profile.calltrace.cycles-pp.tcp_sendmsg.sock_sendmsg.sock_write_iter.new_sync_write.vfs_write
      0.94 ± 10%      -0.1        0.79 ±  9%  perf-profile.calltrace.cycles-pp.sock_poll.ep_item_poll.ep_insert.do_epoll_ctl.__x64_sys_epoll_ctl
      0.52 ± 71%      -0.1        0.38 ±101%  perf-profile.calltrace.cycles-pp.perf_trace_sched_switch.__schedule.schedule.schedule_hrtimeout_range_clock.ep_poll
      0.51 ± 71%      -0.1        0.37 ±101%  perf-profile.calltrace.cycles-pp.perf_tp_event.perf_trace_sched_switch.__schedule.schedule.schedule_hrtimeout_range_clock
      0.41 ± 72%      -0.1        0.26 ±100%  perf-profile.calltrace.cycles-pp.dictSdsKeyCompare
      0.50 ± 71%      -0.1        0.36 ±101%  perf-profile.calltrace.cycles-pp.__perf_event_overflow.perf_tp_event.perf_trace_sched_switch.__schedule.schedule
      8.19 ± 24%      -0.1        8.05 ± 26%  perf-profile.calltrace.cycles-pp.epoll_ctl
      0.54 ± 71%      -0.1        0.40 ±101%  perf-profile.calltrace.cycles-pp.perf_prepare_sample.perf_event_output_forward.__perf_event_overflow.perf_tp_event.perf_trace_sched_stat_runtime
      0.82 ± 11%      -0.1        0.69 ±  9%  perf-profile.calltrace.cycles-pp.tcp_poll.sock_poll.ep_item_poll.ep_insert.do_epoll_ctl
      1.99 ± 29%      -0.1        1.86 ± 29%  perf-profile.calltrace.cycles-pp.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64
      1.64 ±  6%      -0.1        1.51 ±  9%  perf-profile.calltrace.cycles-pp.ep_remove.do_epoll_ctl.__x64_sys_epoll_ctl.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.89 ± 29%      -0.1        1.76 ± 29%  perf-profile.calltrace.cycles-pp.__schedule.schedule.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait
      0.40 ± 71%      -0.1        0.27 ±100%  perf-profile.calltrace.cycles-pp.tcp_poll.sock_poll.ep_item_poll.ep_send_events.ep_poll
      2.08 ± 12%      -0.1        1.95 ± 11%  perf-profile.calltrace.cycles-pp.__wake_up_common_lock.sock_def_readable.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv
      0.57 ± 76%      -0.1        0.45 ±103%  perf-profile.calltrace.cycles-pp.perf_callchain_kernel.get_perf_callchain.perf_callchain.perf_prepare_sample.perf_event_output_forward
      1.90 ± 29%      -0.1        1.77 ± 29%  perf-profile.calltrace.cycles-pp.schedule.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.43 ± 71%      -0.1        0.31 ±101%  perf-profile.calltrace.cycles-pp.perf_prepare_sample.perf_event_output_forward.__perf_event_overflow.perf_tp_event.perf_trace_sched_switch
     11.84 ± 18%      -0.1       11.72 ± 12%  perf-profile.calltrace.cycles-pp.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg.sock_write_iter.new_sync_write
      1.17 ±  5%      -0.1        1.05 ± 11%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc.ep_insert.do_epoll_ctl.__x64_sys_epoll_ctl.do_syscall_64
      1.08 ± 10%      -0.1        0.97 ±  8%  perf-profile.calltrace.cycles-pp.ep_item_poll.ep_send_events.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      7.43 ± 25%      -0.1        7.32 ± 28%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.epoll_ctl
      0.11 ±223%      -0.1        0.00        perf-profile.calltrace.cycles-pp.je_malloc_usable_size
      0.10 ±223%      -0.1        0.00        perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter
      1.04 ± 10%      -0.1        0.93 ±  9%  perf-profile.calltrace.cycles-pp.sock_poll.ep_item_poll.ep_send_events.ep_poll.do_epoll_wait
      0.62 ± 47%      -0.1        0.52 ± 45%  perf-profile.calltrace.cycles-pp.clockevents_program_event.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      7.32 ± 25%      -0.1        7.22 ± 28%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.epoll_ctl
      1.90 ± 16%      -0.1        1.80 ± 10%  perf-profile.calltrace.cycles-pp.stringObjectLen
      0.09 ±223%      -0.1        0.00        perf-profile.calltrace.cycles-pp.__inet_lookup_established.tcp_v4_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish.__netif_receive_skb_one_core
      0.09 ±223%      -0.1        0.00        perf-profile.calltrace.cycles-pp.tcp_eat_recv_skb.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg.sock_read_iter
      0.19 ±142%      -0.1        0.10 ±223%  perf-profile.calltrace.cycles-pp._copy_from_iter.skb_do_copy_data_nocache.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg
      1.17 ± 29%      -0.1        1.08 ± 25%  perf-profile.calltrace.cycles-pp.__libc_start_main
      1.17 ± 29%      -0.1        1.08 ± 25%  perf-profile.calltrace.cycles-pp.main.__libc_start_main
      1.17 ± 29%      -0.1        1.08 ± 25%  perf-profile.calltrace.cycles-pp.run_builtin.main.__libc_start_main
      0.09 ±223%      -0.1        0.00        perf-profile.calltrace.cycles-pp.__softirqentry_text_start.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state
      0.08 ±223%      -0.1        0.00        perf-profile.calltrace.cycles-pp.scheduler_tick.update_process_times.tick_sched_handle.tick_sched_timer.__hrtimer_run_queues
      0.08 ±223%      -0.1        0.00        perf-profile.calltrace.cycles-pp._raw_read_lock_irqsave.ep_poll_callback.__wake_up_common.__wake_up_common_lock.sock_def_readable
      0.08 ±223%      -0.1        0.00        perf-profile.calltrace.cycles-pp.copyin._copy_from_iter.skb_do_copy_data_nocache.tcp_sendmsg_locked.tcp_sendmsg
      0.74 ± 51%      -0.1        0.65 ± 53%  perf-profile.calltrace.cycles-pp.perf_trace_sched_stat_runtime.update_curr.dequeue_entity.dequeue_task_fair.__schedule
      1.12 ± 29%      -0.1        1.04 ± 26%  perf-profile.calltrace.cycles-pp.cmd_record.cmd_sched.run_builtin.main.__libc_start_main
      1.12 ± 29%      -0.1        1.04 ± 26%  perf-profile.calltrace.cycles-pp.cmd_sched.run_builtin.main.__libc_start_main
      0.62 ± 71%      -0.1        0.54 ± 75%  perf-profile.calltrace.cycles-pp.__perf_event_overflow.perf_tp_event.perf_trace_sched_stat_runtime.update_curr.dequeue_entity
      0.62 ± 71%      -0.1        0.54 ± 75%  perf-profile.calltrace.cycles-pp.perf_event_output_forward.__perf_event_overflow.perf_tp_event.perf_trace_sched_stat_runtime.update_curr
      0.96 ± 29%      -0.1        0.88 ± 27%  perf-profile.calltrace.cycles-pp.dequeue_task_fair.__schedule.schedule.schedule_hrtimeout_range_clock.ep_poll
      0.94 ± 29%      -0.1        0.87 ± 28%  perf-profile.calltrace.cycles-pp.dequeue_entity.dequeue_task_fair.__schedule.schedule.schedule_hrtimeout_range_clock
      1.12 ± 30%      -0.1        1.04 ± 26%  perf-profile.calltrace.cycles-pp.__cmd_record.cmd_record.cmd_sched.run_builtin.main
      0.32 ±102%      -0.1        0.26 ±100%  perf-profile.calltrace.cycles-pp.ktime_get.clockevents_program_event.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt
      0.78 ± 13%      -0.1        0.72 ±  5%  perf-profile.calltrace.cycles-pp.tick_nohz_get_sleep_length.menu_select.cpuidle_idle_call.do_idle.cpu_startup_entry
      1.35 ± 45%      -0.1        1.29 ± 40%  perf-profile.calltrace.cycles-pp.__wake_up_common_lock.ep_poll_callback.__wake_up_common.__wake_up_common_lock.sock_def_readable
      1.32 ± 45%      -0.1        1.26 ± 40%  perf-profile.calltrace.cycles-pp.__wake_up_common.__wake_up_common_lock.ep_poll_callback.__wake_up_common.__wake_up_common_lock
      0.71 ± 14%      -0.1        0.66 ±  6%  perf-profile.calltrace.cycles-pp.tick_nohz_next_event.tick_nohz_get_sleep_length.menu_select.cpuidle_idle_call.do_idle
      0.50 ± 71%      -0.0        0.45 ±112%  perf-profile.calltrace.cycles-pp.perf_event_output_forward.__perf_event_overflow.perf_tp_event.perf_trace_sched_switch.__schedule
      1.29 ± 45%      -0.0        1.24 ± 40%  perf-profile.calltrace.cycles-pp.autoremove_wake_function.__wake_up_common.__wake_up_common_lock.ep_poll_callback.__wake_up_common
      1.28 ± 45%      -0.0        1.23 ± 40%  perf-profile.calltrace.cycles-pp.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock.ep_poll_callback
      0.76 ± 52%      -0.0        0.72 ± 47%  perf-profile.calltrace.cycles-pp.record__finish_output.__cmd_record.cmd_record.cmd_sched.run_builtin
      0.76 ± 52%      -0.0        0.72 ± 47%  perf-profile.calltrace.cycles-pp.perf_session__process_events.record__finish_output.__cmd_record.cmd_record.cmd_sched
      0.75 ± 53%      -0.0        0.71 ± 47%  perf-profile.calltrace.cycles-pp.reader__read_event.perf_session__process_events.record__finish_output.__cmd_record.cmd_record
      0.58 ±  7%      -0.0        0.53 ± 44%  perf-profile.calltrace.cycles-pp.copyout._copy_to_iter.__skb_datagram_iter.skb_copy_datagram_iter.tcp_recvmsg_locked
      1.11 ± 14%      -0.0        1.07 ± 11%  perf-profile.calltrace.cycles-pp.menu_select.cpuidle_idle_call.do_idle.cpu_startup_entry.secondary_startup_64_no_verify
      0.55 ±  7%      -0.0        0.52 ± 44%  perf-profile.calltrace.cycles-pp.copy_user_enhanced_fast_string.copyout._copy_to_iter.__skb_datagram_iter.skb_copy_datagram_iter
      2.34 ± 18%      -0.0        2.30 ± 11%  perf-profile.calltrace.cycles-pp.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_read.connSocketConnect
      0.42 ± 73%      -0.0        0.38 ± 71%  perf-profile.calltrace.cycles-pp.perf_session__process_user_event.reader__read_event.perf_session__process_events.record__finish_output.__cmd_record
      0.42 ± 73%      -0.0        0.38 ± 71%  perf-profile.calltrace.cycles-pp.__ordered_events__flush.perf_session__process_user_event.reader__read_event.perf_session__process_events.record__finish_output
      0.32 ±101%      -0.0        0.29 ±101%  perf-profile.calltrace.cycles-pp.perf_session__deliver_event.__ordered_events__flush.perf_session__process_user_event.reader__read_event.perf_session__process_events
      2.20 ± 18%      -0.0        2.18 ± 11%  perf-profile.calltrace.cycles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_read
      2.03 ± 18%      -0.0        2.03 ± 11%  perf-profile.calltrace.cycles-pp.new_sync_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.09 ±223%      -0.0        0.09 ±223%  perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.stringObjectLen
      0.09 ±223%      -0.0        0.09 ±223%  perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.stringObjectLen
      0.21 ±143%      +0.0        0.21 ±142%  perf-profile.calltrace.cycles-pp.unwind_next_frame.perf_callchain_kernel.get_perf_callchain.perf_callchain.perf_prepare_sample
      0.09 ±223%      +0.0        0.09 ±223%  perf-profile.calltrace.cycles-pp.perf_trace_sched_switch.__schedule.schedule_idle.do_idle.cpu_startup_entry
      0.78 ± 51%      +0.0        0.78 ± 29%  perf-profile.calltrace.cycles-pp.update_curr.dequeue_entity.dequeue_task_fair.__schedule.schedule
      1.99 ± 18%      +0.0        2.00 ± 11%  perf-profile.calltrace.cycles-pp.sock_read_iter.new_sync_read.vfs_read.ksys_read.do_syscall_64
      0.63 ± 71%      +0.0        0.64 ± 53%  perf-profile.calltrace.cycles-pp.perf_tp_event.perf_trace_sched_stat_runtime.update_curr.dequeue_entity.dequeue_task_fair
      1.83 ± 18%      +0.0        1.84 ± 11%  perf-profile.calltrace.cycles-pp.inet_recvmsg.sock_read_iter.new_sync_read.vfs_read.ksys_read
      1.80 ± 18%      +0.0        1.82 ± 11%  perf-profile.calltrace.cycles-pp.tcp_recvmsg.inet_recvmsg.sock_read_iter.new_sync_read.vfs_read
      0.68 ± 19%      +0.0        0.70 ± 10%  perf-profile.calltrace.cycles-pp.skb_copy_datagram_iter.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg.sock_read_iter
      0.78 ± 75%      +0.0        0.81 ± 57%  perf-profile.calltrace.cycles-pp.perf_tp_event.perf_trace_sched_wakeup_template.try_to_wake_up.autoremove_wake_function.__wake_up_common
      0.79 ± 75%      +0.0        0.82 ± 57%  perf-profile.calltrace.cycles-pp.perf_trace_sched_wakeup_template.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock
      0.76 ± 75%      +0.0        0.79 ± 58%  perf-profile.calltrace.cycles-pp.__perf_event_overflow.perf_tp_event.perf_trace_sched_wakeup_template.try_to_wake_up.autoremove_wake_function
      0.76 ± 75%      +0.0        0.79 ± 57%  perf-profile.calltrace.cycles-pp.perf_event_output_forward.__perf_event_overflow.perf_tp_event.perf_trace_sched_wakeup_template.try_to_wake_up
      0.63 ±  7%      +0.0        0.67 ±  9%  perf-profile.calltrace.cycles-pp._copy_to_iter.__skb_datagram_iter.skb_copy_datagram_iter.tcp_recvmsg_locked.tcp_recvmsg
      0.67 ± 76%      +0.0        0.71 ± 58%  perf-profile.calltrace.cycles-pp.perf_prepare_sample.perf_event_output_forward.__perf_event_overflow.perf_tp_event.perf_trace_sched_wakeup_template
      1.53 ± 18%      +0.0        1.57 ± 11%  perf-profile.calltrace.cycles-pp.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg.sock_read_iter.new_sync_read
      3.14 ± 19%      +0.0        3.19 ± 15%  perf-profile.calltrace.cycles-pp.__libc_read.connSocketConnect
      0.57 ± 71%      +0.1        0.63 ± 53%  perf-profile.calltrace.cycles-pp.__schedule.schedule_idle.do_idle.cpu_startup_entry.secondary_startup_64_no_verify
      2.63 ± 20%      +0.1        2.70 ± 17%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_read.connSocketConnect
      2.64 ± 20%      +0.1        2.72 ± 17%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__libc_read.connSocketConnect
      0.32 ±100%      +0.1        0.40 ± 70%  perf-profile.calltrace.cycles-pp.asm_exc_page_fault.stringObjectLen
      0.84 ± 16%      +0.1        0.92 ± 11%  perf-profile.calltrace.cycles-pp.lookupKey
      0.00            +0.1        0.09 ±223%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.__softirqentry_text_start.run_ksoftirqd.smpboot_thread_fn
      3.34 ± 18%      +0.1        3.42 ± 10%  perf-profile.calltrace.cycles-pp.dictFind
      0.00            +0.1        0.09 ±223%  perf-profile.calltrace.cycles-pp.perf_tp_event.perf_trace_sched_switch.__schedule.schedule_idle.do_idle
      0.00            +0.1        0.09 ±223%  perf-profile.calltrace.cycles-pp.__perf_event_overflow.perf_tp_event.perf_trace_sched_switch.__schedule.schedule_idle
      0.25 ±141%      +0.1        0.35 ±100%  perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_write.connSocketConnect
      0.00            +0.1        0.10 ±223%  perf-profile.calltrace.cycles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.mwait_idle_with_hints
      0.24 ±141%      +0.1        0.34 ±100%  perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_send.redisAsyncRead
      0.00            +0.1        0.10 ±223%  perf-profile.calltrace.cycles-pp.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.mwait_idle_with_hints.intel_idle
      0.98 ±  6%      +0.1        1.07 ±  8%  perf-profile.calltrace.cycles-pp.skb_copy_datagram_iter.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg.__sys_recvfrom
      0.23 ±141%      +0.1        0.33 ±100%  perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_recv.redisAsyncRead
      0.00            +0.1        0.12 ±223%  perf-profile.calltrace.cycles-pp.skb_release_head_state.__kfree_skb.net_rx_action.__softirqentry_text_start.do_softirq
      0.24 ±141%      +0.1        0.36 ±100%  perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_read.connSocketConnect
      1.64 ± 11%      +0.1        1.76 ±  8%  perf-profile.calltrace.cycles-pp.__skb_datagram_iter.skb_copy_datagram_iter.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg
      2.27 ±  5%      +0.1        2.39 ±  8%  perf-profile.calltrace.cycles-pp.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_recv.redisAsyncRead
      0.77 ± 18%      +0.1        0.90 ± 12%  perf-profile.calltrace.cycles-pp.tcp_stream_alloc_skb.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg.sock_write_iter
      2.25 ±  5%      +0.1        2.38 ±  8%  perf-profile.calltrace.cycles-pp.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_recv
      2.04 ±  5%      +0.1        2.17 ±  8%  perf-profile.calltrace.cycles-pp.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.02 ±  5%      +0.1        2.16 ±  8%  perf-profile.calltrace.cycles-pp.tcp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64
      1.75 ±  5%      +0.2        1.90 ±  8%  perf-profile.calltrace.cycles-pp.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg.__sys_recvfrom.__x64_sys_recvfrom
      0.58 ± 71%      +0.2        0.73 ± 29%  perf-profile.calltrace.cycles-pp.schedule_idle.do_idle.cpu_startup_entry.secondary_startup_64_no_verify
      0.35 ±141%      +0.2        0.51 ±100%  perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.epoll_wait
      0.00            +0.2        0.17 ±141%  perf-profile.calltrace.cycles-pp.rcu_core.__softirqentry_text_start.run_ksoftirqd.smpboot_thread_fn.kthread
      0.00            +0.2        0.17 ±141%  perf-profile.calltrace.cycles-pp.__softirqentry_text_start.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      0.00            +0.2        0.17 ±141%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      0.42 ± 72%      +0.2        0.60 ± 15%  perf-profile.calltrace.cycles-pp.skb_do_copy_data_nocache.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg.sock_write_iter
      0.68 ±  5%      +0.2        0.86 ± 12%  perf-profile.calltrace.cycles-pp.tcp_stream_alloc_skb.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg.__sys_sendto
      0.00            +0.2        0.20 ±223%  perf-profile.calltrace.cycles-pp.skb_release_data.__kfree_skb.net_rx_action.__softirqentry_text_start.do_softirq
      2.74 ± 15%      +0.2        2.93 ± 16%  perf-profile.calltrace.cycles-pp.__libc_recv.redisAsyncRead
      0.18 ±141%      +0.2        0.38 ± 70%  perf-profile.calltrace.cycles-pp.ret_from_fork
      0.18 ±141%      +0.2        0.38 ± 70%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
      2.54 ± 15%      +0.2        2.76 ± 17%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__libc_recv.redisAsyncRead
      2.52 ± 15%      +0.2        2.75 ± 17%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_recv.redisAsyncRead
      0.00            +0.3        0.26 ±100%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork
      0.12 ±223%      +0.3        0.40 ±107%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_kernel.secondary_startup_64_no_verify
      0.12 ±223%      +0.3        0.40 ±107%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_kernel.secondary_startup_64_no_verify
      0.12 ±223%      +0.3        0.40 ±107%  perf-profile.calltrace.cycles-pp.start_kernel.secondary_startup_64_no_verify
      0.00            +0.3        0.28 ±142%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.mwait_idle_with_hints.intel_idle.cpuidle_enter_state
      0.12 ±223%      +0.3        0.40 ±107%  perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_kernel
      0.12 ±223%      +0.3        0.40 ±107%  perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_kernel.secondary_startup_64_no_verify
      1.30 ± 11%      +0.3        1.60 ± 12%  perf-profile.calltrace.cycles-pp.__alloc_skb.tcp_stream_alloc_skb.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg
      1.02 ± 34%      +0.4        1.38 ±  9%  perf-profile.calltrace.cycles-pp.__dev_queue_xmit.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit
      0.00            +0.4        0.44 ±223%  perf-profile.calltrace.cycles-pp.__kfree_skb.net_rx_action.__softirqentry_text_start.do_softirq.__local_bh_enable_ip
      1.14 ±141%      +0.5        1.66 ±100%  perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.epoll_ctl
     32.98 ± 20%      +1.0       33.98 ± 21%  perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      0.44 ± 71%      +1.3        1.73 ±118%  perf-profile.calltrace.cycles-pp.poll_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
     38.15 ± 17%      +1.5       39.64 ± 15%  perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.secondary_startup_64_no_verify
     39.10 ± 17%      +1.5       40.60 ± 15%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.secondary_startup_64_no_verify
     39.10 ± 17%      +1.5       40.61 ± 15%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.secondary_startup_64_no_verify
     36.91 ± 18%      +1.5       38.43 ± 16%  perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.secondary_startup_64_no_verify
     39.36 ± 17%      +1.8       41.14 ± 16%  perf-profile.calltrace.cycles-pp.secondary_startup_64_no_verify
     36.76 ± 18%      +1.9       38.62 ± 16%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
      0.00            +2.8        2.78 ±127%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.mwait_idle_with_hints.intel_idle.cpuidle_enter_state.cpuidle_enter
     10.56 ± 13%      -1.8        8.76 ±  9%  perf-profile.children.cycles-pp.__napi_poll
     10.54 ± 13%      -1.8        8.75 ±  9%  perf-profile.children.cycles-pp.process_backlog
     10.23 ± 13%      -1.8        8.45 ±  9%  perf-profile.children.cycles-pp.__netif_receive_skb_one_core
      9.78 ± 13%      -1.7        8.05 ± 10%  perf-profile.children.cycles-pp.ip_local_deliver_finish
      9.66 ± 13%      -1.7        7.93 ± 10%  perf-profile.children.cycles-pp.tcp_v4_rcv
      9.74 ± 13%      -1.7        8.02 ± 10%  perf-profile.children.cycles-pp.ip_protocol_deliver_rcu
      8.22 ± 14%      -1.6        6.66 ± 11%  perf-profile.children.cycles-pp.tcp_v4_do_rcv
      8.18 ± 14%      -1.6        6.62 ± 11%  perf-profile.children.cycles-pp.tcp_rcv_established
     11.43 ± 12%      -1.4       10.03 ± 15%  perf-profile.children.cycles-pp.__local_bh_enable_ip
     11.26 ± 12%      -1.3        9.95 ± 15%  perf-profile.children.cycles-pp.do_softirq
     12.81 ± 12%      -1.2       11.58 ± 14%  perf-profile.children.cycles-pp.ip_finish_output2
     15.98 ± 11%      -1.2       14.77 ± 12%  perf-profile.children.cycles-pp.__tcp_push_pending_frames
     15.92 ± 11%      -1.2       14.72 ± 12%  perf-profile.children.cycles-pp.tcp_write_xmit
     10.76 ± 13%      -1.2        9.56 ± 15%  perf-profile.children.cycles-pp.net_rx_action
     12.05 ± 12%      -1.2       10.87 ± 14%  perf-profile.children.cycles-pp.__softirqentry_text_start
      2.95 ± 10%      -1.2        1.79 ±  8%  perf-profile.children.cycles-pp.tcp_ack
     13.54 ± 12%      -1.1       12.45 ± 13%  perf-profile.children.cycles-pp.__ip_queue_xmit
     14.79 ± 12%      -1.1       13.74 ± 12%  perf-profile.children.cycles-pp.__tcp_transmit_skb
      2.08 ± 11%      -1.0        1.05 ±  8%  perf-profile.children.cycles-pp.tcp_clean_rtx_queue
     41.40 ± 11%      -0.9       40.51 ± 13%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     21.24 ± 11%      -0.9       20.37 ± 10%  perf-profile.children.cycles-pp.sock_sendmsg
     41.04 ± 11%      -0.9       40.17 ± 13%  perf-profile.children.cycles-pp.do_syscall_64
      0.78 ± 10%      -0.8        0.00        perf-profile.children.cycles-pp.tcp_eat_recv_skb
     20.80 ± 11%      -0.7       20.10 ± 10%  perf-profile.children.cycles-pp.tcp_sendmsg
      9.14 ±  5%      -0.7        8.48 ± 11%  perf-profile.children.cycles-pp.__x64_sys_sendto
      9.08 ±  5%      -0.6        8.44 ± 12%  perf-profile.children.cycles-pp.__sys_sendto
     20.37 ± 11%      -0.6       19.72 ± 11%  perf-profile.children.cycles-pp.tcp_sendmsg_locked
      9.82 ±  7%      -0.6        9.20 ± 14%  perf-profile.children.cycles-pp.__libc_send
      6.03 ±  5%      -0.6        5.45 ±  8%  perf-profile.children.cycles-pp.__x64_sys_epoll_ctl
     14.06 ±  8%      -0.6       13.49 ± 14%  perf-profile.children.cycles-pp.redisAsyncRead
      5.57 ±  5%      -0.6        5.02 ±  8%  perf-profile.children.cycles-pp.do_epoll_ctl
      1.03 ± 12%      -0.4        0.65 ± 85%  perf-profile.children.cycles-pp.skb_release_data
     13.16 ± 18%      -0.4       12.80 ± 11%  perf-profile.children.cycles-pp.ksys_write
      4.84 ± 12%      -0.4        4.48 ± 12%  perf-profile.children.cycles-pp.__x64_sys_epoll_wait
      4.52 ± 13%      -0.4        4.17 ± 13%  perf-profile.children.cycles-pp.ep_poll
     12.98 ± 18%      -0.4       12.63 ± 11%  perf-profile.children.cycles-pp.vfs_write
      2.62 ±  6%      -0.3        2.28 ±  9%  perf-profile.children.cycles-pp.ep_insert
      4.63 ± 12%      -0.3        4.29 ± 13%  perf-profile.children.cycles-pp.do_epoll_wait
      1.21 ± 12%      -0.3        0.88 ±110%  perf-profile.children.cycles-pp.__kfree_skb
     12.76 ± 18%      -0.3       12.45 ± 11%  perf-profile.children.cycles-pp.new_sync_write
     13.87 ± 17%      -0.3       13.56 ± 11%  perf-profile.children.cycles-pp.__libc_write
      2.12 ±  9%      -0.3        1.85 ±  7%  perf-profile.children.cycles-pp.ep_item_poll
     12.43 ± 18%      -0.3       12.17 ± 11%  perf-profile.children.cycles-pp.sock_write_iter
      2.04 ±  9%      -0.3        1.78 ±  8%  perf-profile.children.cycles-pp.sock_poll
      0.39 ± 12%      -0.2        0.15 ± 13%  perf-profile.children.cycles-pp.__ksize
     16.91 ± 17%      -0.2       16.67 ± 12%  perf-profile.children.cycles-pp.connSocketConnect
      0.46 ±  9%      -0.2        0.23 ±104%  perf-profile.children.cycles-pp.__slab_free
      5.76 ±  7%      -0.2        5.54 ±  7%  perf-profile.children.cycles-pp.epoll_wait
      1.44 ±  9%      -0.2        1.23 ± 10%  perf-profile.children.cycles-pp.tcp_poll
      1.21 ±  5%      -0.2        1.00 ± 27%  perf-profile.children.cycles-pp.kmem_cache_free
      2.15 ± 11%      -0.2        1.96 ±  8%  perf-profile.children.cycles-pp.ep_send_events
      3.46 ± 21%      -0.2        3.28 ± 17%  perf-profile.children.cycles-pp.__wake_up_common_lock
      3.59 ± 21%      -0.2        3.41 ± 17%  perf-profile.children.cycles-pp.sock_def_readable
      1.69 ±  6%      -0.2        1.51 ± 10%  perf-profile.children.cycles-pp.kmem_cache_alloc
      8.46 ± 23%      -0.2        8.28 ± 26%  perf-profile.children.cycles-pp.epoll_ctl
      0.27 ±  9%      -0.2        0.10 ±223%  perf-profile.children.cycles-pp.kfree
      2.98 ± 31%      -0.2        2.82 ± 30%  perf-profile.children.cycles-pp.perf_tp_event
      2.92 ± 31%      -0.2        2.76 ± 30%  perf-profile.children.cycles-pp.__perf_event_overflow
      2.90 ± 31%      -0.2        2.74 ± 30%  perf-profile.children.cycles-pp.perf_event_output_forward
      3.05 ± 23%      -0.2        2.90 ± 19%  perf-profile.children.cycles-pp.__wake_up_common
      2.50 ± 31%      -0.1        2.36 ± 31%  perf-profile.children.cycles-pp.perf_prepare_sample
      2.37 ± 31%      -0.1        2.23 ± 31%  perf-profile.children.cycles-pp.perf_callchain
      2.36 ± 31%      -0.1        2.22 ± 31%  perf-profile.children.cycles-pp.get_perf_callchain
      2.00 ± 29%      -0.1        1.86 ± 29%  perf-profile.children.cycles-pp.schedule_hrtimeout_range_clock
      1.66 ±  6%      -0.1        1.53 ±  9%  perf-profile.children.cycles-pp.ep_remove
      0.21 ± 16%      -0.1        0.08 ±  8%  perf-profile.children.cycles-pp.skb_page_frag_refill
      0.22 ± 15%      -0.1        0.10 ± 12%  perf-profile.children.cycles-pp.sk_page_frag_refill
      2.90 ± 23%      -0.1        2.78 ± 19%  perf-profile.children.cycles-pp.ep_poll_callback
      1.96 ± 28%      -0.1        1.84 ± 28%  perf-profile.children.cycles-pp.schedule
      2.68 ± 28%      -0.1        2.56 ± 28%  perf-profile.children.cycles-pp.__schedule
      2.22 ± 15%      -0.1        2.12 ± 10%  perf-profile.children.cycles-pp.stringObjectLen
      0.34 ± 11%      -0.1        0.23 ±  9%  perf-profile.children.cycles-pp.aa_sk_perm
      0.26 ± 12%      -0.1        0.16 ±  8%  perf-profile.children.cycles-pp.security_socket_sendmsg
      1.76 ± 32%      -0.1        1.66 ± 31%  perf-profile.children.cycles-pp.perf_callchain_kernel
      0.67 ± 12%      -0.1        0.57 ± 10%  perf-profile.children.cycles-pp.ep_ptable_queue_proc
      0.88 ±  7%      -0.1        0.79 ±  8%  perf-profile.children.cycles-pp.__entry_text_start
      1.17 ± 29%      -0.1        1.08 ± 25%  perf-profile.children.cycles-pp.__libc_start_main
      1.17 ± 29%      -0.1        1.08 ± 25%  perf-profile.children.cycles-pp.main
      1.17 ± 29%      -0.1        1.08 ± 25%  perf-profile.children.cycles-pp.run_builtin
      0.46 ± 13%      -0.1        0.37 ± 10%  perf-profile.children.cycles-pp.tcp_event_new_data_sent
      0.10 ± 16%      -0.1        0.01 ±223%  perf-profile.children.cycles-pp.cubictcp_acked
      1.04 ± 22%      -0.1        0.95 ± 23%  perf-profile.children.cycles-pp.perf_trace_sched_stat_runtime
      0.82 ± 10%      -0.1        0.74 ±  8%  perf-profile.children.cycles-pp.__inet_lookup_established
      0.10 ± 11%      -0.1        0.02 ±142%  perf-profile.children.cycles-pp.cubictcp_cwnd_event
      1.10 ± 23%      -0.1        1.02 ± 22%  perf-profile.children.cycles-pp.update_curr
      0.30 ± 13%      -0.1        0.22 ± 12%  perf-profile.children.cycles-pp.tcp_current_mss
      1.14 ± 29%      -0.1        1.06 ± 25%  perf-profile.children.cycles-pp.cmd_record
      0.63 ±  5%      -0.1        0.55 ±  9%  perf-profile.children.cycles-pp.ep_unregister_pollwait
      0.89 ± 11%      -0.1        0.81 ±  6%  perf-profile.children.cycles-pp.tick_sched_handle
      0.88 ± 11%      -0.1        0.80 ±  6%  perf-profile.children.cycles-pp.update_process_times
      0.69 ±  5%      -0.1        0.61 ± 16%  perf-profile.children.cycles-pp.memcg_slab_free_hook
      1.14 ± 30%      -0.1        1.06 ± 25%  perf-profile.children.cycles-pp.__cmd_record
      1.41 ± 32%      -0.1        1.34 ± 32%  perf-profile.children.cycles-pp.unwind_next_frame
      0.50 ± 14%      -0.1        0.42 ± 13%  perf-profile.children.cycles-pp.aeProcessEvents
      1.12 ± 29%      -0.1        1.04 ± 26%  perf-profile.children.cycles-pp.cmd_sched
      0.33 ± 12%      -0.1        0.26 ± 11%  perf-profile.children.cycles-pp.tcp_send_mss
      0.27 ± 18%      -0.1        0.20 ±  8%  perf-profile.children.cycles-pp.__mod_timer
      0.98 ± 28%      -0.1        0.90 ± 27%  perf-profile.children.cycles-pp.dequeue_task_fair
      0.30 ± 16%      -0.1        0.23 ±  7%  perf-profile.children.cycles-pp.sk_reset_timer
      0.96 ± 29%      -0.1        0.89 ± 27%  perf-profile.children.cycles-pp.dequeue_entity
      0.61 ± 12%      -0.1        0.54 ± 13%  perf-profile.children.cycles-pp.copyin
      1.05 ± 14%      -0.1        0.98 ±  4%  perf-profile.children.cycles-pp.tick_sched_timer
      1.30 ± 14%      -0.1        1.24 ±  3%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      1.04 ± 31%      -0.1        0.98 ± 30%  perf-profile.children.cycles-pp.perf_trace_sched_switch
      0.83 ± 32%      -0.1        0.77 ± 25%  perf-profile.children.cycles-pp.reader__read_event
      0.78 ± 13%      -0.1        0.73 ±  6%  perf-profile.children.cycles-pp.tick_nohz_get_sleep_length
      0.28 ±  6%      -0.1        0.22 ± 16%  perf-profile.children.cycles-pp.__might_sleep
      0.55 ± 19%      -0.1        0.49 ± 12%  perf-profile.children.cycles-pp.dictSdsKeyCompare
      0.58 ± 14%      -0.1        0.52 ± 10%  perf-profile.children.cycles-pp.memcg_slab_post_alloc_hook
      0.84 ± 32%      -0.1        0.78 ± 25%  perf-profile.children.cycles-pp.record__finish_output
      0.84 ± 32%      -0.1        0.78 ± 25%  perf-profile.children.cycles-pp.perf_session__process_events
      0.72 ± 14%      -0.1        0.66 ±  6%  perf-profile.children.cycles-pp.tick_nohz_next_event
      0.10 ± 24%      -0.1        0.04 ± 72%  perf-profile.children.cycles-pp.inet_sendmsg
      0.66 ±  9%      -0.1        0.60 ±  6%  perf-profile.children.cycles-pp.scheduler_tick
      0.44 ±  6%      -0.1        0.39 ± 11%  perf-profile.children.cycles-pp.__might_resched
      0.46 ± 21%      -0.0        0.42 ± 12%  perf-profile.children.cycles-pp.je_malloc_usable_size
      0.37 ± 10%      -0.0        0.32 ±  8%  perf-profile.children.cycles-pp.irqtime_account_irq
      0.05 ± 46%      -0.0        0.00        perf-profile.children.cycles-pp.tcp_small_queue_check
      0.51 ± 16%      -0.0        0.46 ±  7%  perf-profile.children.cycles-pp.timekeeping_max_deferment
      1.32 ± 44%      -0.0        1.28 ± 39%  perf-profile.children.cycles-pp.autoremove_wake_function
      0.30 ± 16%      -0.0        0.26 ± 12%  perf-profile.children.cycles-pp.processMultibulkBuffer
      0.27 ±  9%      -0.0        0.23 ± 16%  perf-profile.children.cycles-pp.redisReaderGetReply
      0.54 ± 11%      -0.0        0.50 ±  8%  perf-profile.children.cycles-pp.dev_hard_start_xmit
      0.51 ± 27%      -0.0        0.46 ± 30%  perf-profile.children.cycles-pp.__get_user_nocheck_8
      0.29 ± 14%      -0.0        0.25 ± 10%  perf-profile.children.cycles-pp.release_sock
      0.52 ± 12%      -0.0        0.48 ±  9%  perf-profile.children.cycles-pp.xmit_one
      0.63 ± 30%      -0.0        0.59 ± 31%  perf-profile.children.cycles-pp.__unwind_start
      0.49 ± 15%      -0.0        0.45 ± 10%  perf-profile.children.cycles-pp.mod_objcg_state
      0.54 ± 27%      -0.0        0.50 ± 30%  perf-profile.children.cycles-pp.perf_callchain_user
      0.05 ± 46%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.07 ± 23%      -0.0        0.03 ±100%  perf-profile.children.cycles-pp.ip_rcv_finish_core
      0.54 ±  9%      -0.0        0.50 ± 12%  perf-profile.children.cycles-pp.__fget_light
      1.33 ± 43%      -0.0        1.29 ± 38%  perf-profile.children.cycles-pp.try_to_wake_up
      0.51 ± 13%      -0.0        0.47 ± 10%  perf-profile.children.cycles-pp.lock_sock_nested
      1.12 ± 14%      -0.0        1.08 ± 11%  perf-profile.children.cycles-pp.menu_select
      0.23 ± 18%      -0.0        0.19 ± 13%  perf-profile.children.cycles-pp.tcp_check_space
      0.06 ± 46%      -0.0        0.02 ±141%  perf-profile.children.cycles-pp.inet_send_prepare
      0.14 ± 22%      -0.0        0.10 ± 18%  perf-profile.children.cycles-pp.ipv4_mtu
      0.71 ± 14%      -0.0        0.67 ± 12%  perf-profile.children.cycles-pp._copy_from_iter
      0.51 ±  5%      -0.0        0.47 ±  4%  perf-profile.children.cycles-pp.writeHandler
      0.26 ± 14%      -0.0        0.22 ± 12%  perf-profile.children.cycles-pp.processCommand
      2.43 ± 18%      -0.0        2.39 ± 11%  perf-profile.children.cycles-pp.ksys_read
      0.33 ±  5%      -0.0        0.30 ± 13%  perf-profile.children.cycles-pp.native_sched_clock
      2.24 ± 15%      -0.0        2.20 ±  5%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.10 ± 10%      -0.0        0.07 ± 14%  perf-profile.children.cycles-pp.rb_first
      1.47 ± 11%      -0.0        1.43 ±  8%  perf-profile.children.cycles-pp.copy_user_enhanced_fast_string
      0.48 ± 11%      -0.0        0.45 ± 10%  perf-profile.children.cycles-pp.loopback_xmit
      0.23 ± 34%      -0.0        0.20 ± 36%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.77 ± 12%      -0.0        0.74 ± 13%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.22 ± 34%      -0.0        0.19 ± 37%  perf-profile.children.cycles-pp.record__pushfn
      0.23 ± 35%      -0.0        0.20 ± 36%  perf-profile.children.cycles-pp.perf_mmap__push
      0.43 ± 11%      -0.0        0.40 ± 14%  perf-profile.children.cycles-pp.native_irq_return_iret
      0.38 ±  7%      -0.0        0.35 ± 11%  perf-profile.children.cycles-pp.sched_clock_cpu
      0.23 ± 12%      -0.0        0.20 ± 13%  perf-profile.children.cycles-pp.calc_global_load_tick
      0.17 ± 15%      -0.0        0.14 ± 10%  perf-profile.children.cycles-pp.tcp_wfree
      0.22 ± 34%      -0.0        0.19 ± 35%  perf-profile.children.cycles-pp.writen
      0.98 ± 42%      -0.0        0.94 ± 36%  perf-profile.children.cycles-pp.perf_trace_sched_wakeup_template
      2.26 ± 15%      -0.0        2.23 ±  5%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.13 ± 48%      -0.0        0.10 ± 32%  perf-profile.children.cycles-pp.__mod_memcg_lruvec_state
      0.24 ± 18%      -0.0        0.21 ± 14%  perf-profile.children.cycles-pp.je_malloc
      0.22 ± 34%      -0.0        0.18 ± 39%  perf-profile.children.cycles-pp.generic_file_write_iter
      0.22 ± 34%      -0.0        0.18 ± 39%  perf-profile.children.cycles-pp.__generic_file_write_iter
      0.56 ± 13%      -0.0        0.53 ±  9%  perf-profile.children.cycles-pp._raw_spin_lock_bh
      1.34 ± 15%      -0.0        1.31 ±  8%  perf-profile.children.cycles-pp.ktime_get
      0.22 ± 11%      -0.0        0.19 ± 13%  perf-profile.children.cycles-pp.ip_rcv
      0.30 ± 22%      -0.0        0.28 ± 15%  perf-profile.children.cycles-pp.zmalloc
      0.21 ± 34%      -0.0        0.18 ± 39%  perf-profile.children.cycles-pp.generic_perform_write
      0.12 ±  9%      -0.0        0.09 ± 16%  perf-profile.children.cycles-pp.validate_xmit_skb
      0.49 ±  7%      -0.0        0.46 ± 11%  perf-profile.children.cycles-pp.read_tsc
      0.34 ± 18%      -0.0        0.32 ±  9%  perf-profile.children.cycles-pp.call
      0.15 ±  9%      -0.0        0.12 ±  6%  perf-profile.children.cycles-pp.__put_user_nocheck_4
      0.04 ± 71%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.cubictcp_cong_avoid
      0.06 ± 13%      -0.0        0.03 ±100%  perf-profile.children.cycles-pp.arch_scale_freq_tick
      0.03 ±100%      -0.0        0.00        perf-profile.children.cycles-pp.ftrace_graph_ret_addr
      0.05 ± 52%      -0.0        0.02 ± 99%  perf-profile.children.cycles-pp.tcp_rtt_estimator
      0.32 ±  4%      -0.0        0.29 ± 11%  perf-profile.children.cycles-pp._copy_from_user
      0.07 ± 19%      -0.0        0.04 ± 45%  perf-profile.children.cycles-pp.tcp_event_data_recv
      0.08 ±  6%      -0.0        0.05 ± 46%  perf-profile.children.cycles-pp.rb_insert_color
      0.07 ± 16%      -0.0        0.05 ± 47%  perf-profile.children.cycles-pp.ipv4_dst_check
      0.06 ± 14%      -0.0        0.04 ± 72%  perf-profile.children.cycles-pp.rcu_idle_exit
      0.05 ± 45%      -0.0        0.02 ±142%  perf-profile.children.cycles-pp.get_next_timer_interrupt
      0.21 ± 20%      -0.0        0.18 ± 14%  perf-profile.children.cycles-pp.error_entry
      0.08 ± 34%      -0.0        0.05 ± 76%  perf-profile.children.cycles-pp.fixup_exception
      0.14 ± 12%      -0.0        0.12 ± 14%  perf-profile.children.cycles-pp.redisBufferWrite
      0.22 ±  6%      -0.0        0.20 ± 13%  perf-profile.children.cycles-pp.select_estimate_accuracy
      0.10 ± 14%      -0.0        0.08 ± 21%  perf-profile.children.cycles-pp.tcp_rate_check_app_limited
      0.04 ± 71%      -0.0        0.02 ±142%  perf-profile.children.cycles-pp.memcpy@plt
      0.12 ±  8%      -0.0        0.10 ± 13%  perf-profile.children.cycles-pp.memset_erms
      0.09 ± 12%      -0.0        0.07 ± 21%  perf-profile.children.cycles-pp.inet_ehashfn
      0.08 ± 13%      -0.0        0.06 ± 14%  perf-profile.children.cycles-pp.__sk_dst_check
      0.08 ± 16%      -0.0        0.05 ± 51%  perf-profile.children.cycles-pp.fput_many
      0.76 ± 19%      -0.0        0.74 ±  5%  perf-profile.children.cycles-pp.clockevents_program_event
      0.26 ±  8%      -0.0        0.24 ±  7%  perf-profile.children.cycles-pp.remove_wait_queue
      0.23 ±  6%      -0.0        0.21 ± 14%  perf-profile.children.cycles-pp.ktime_get_ts64
      0.19 ±  7%      -0.0        0.17 ± 14%  perf-profile.children.cycles-pp.__might_fault
      0.15 ± 19%      -0.0        0.13 ± 14%  perf-profile.children.cycles-pp.writeToClient
      0.22 ± 28%      -0.0        0.20 ± 27%  perf-profile.children.cycles-pp.process_simple
      0.09 ±  7%      -0.0        0.07 ±  9%  perf-profile.children.cycles-pp.redisNetWrite
      0.03 ±101%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.sdsrange
      0.16 ± 17%      -0.0        0.14 ± 20%  perf-profile.children.cycles-pp.readQueryFromClient
      0.06 ± 11%      -0.0        0.04 ± 72%  perf-profile.children.cycles-pp.fsnotify_perm
      0.28 ± 11%      -0.0        0.26 ± 11%  perf-profile.children.cycles-pp._raw_read_unlock_irqrestore
      0.02 ±142%      -0.0        0.00        perf-profile.children.cycles-pp.skb_clone
      0.02 ±142%      -0.0        0.00        perf-profile.children.cycles-pp.hi_sdsMakeRoomFor
      0.32 ± 16%      -0.0        0.30 ± 14%  perf-profile.children.cycles-pp.tick_nohz_irq_exit
      0.52 ± 33%      -0.0        0.50 ± 25%  perf-profile.children.cycles-pp.perf_session__process_user_event
      0.52 ± 33%      -0.0        0.50 ± 25%  perf-profile.children.cycles-pp.__ordered_events__flush
      0.17 ±  6%      -0.0        0.15 ± 18%  perf-profile.children.cycles-pp.aeDeleteFileEvent
      3.32 ± 15%      -0.0        3.31 ±  6%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.14 ± 21%      -0.0        0.12 ± 15%  perf-profile.children.cycles-pp.sync_regs
      0.13 ± 11%      -0.0        0.12 ± 16%  perf-profile.children.cycles-pp.tcp_update_pacing_rate
      0.07 ± 19%      -0.0        0.05 ± 46%  perf-profile.children.cycles-pp.__ip_finish_output
      0.07 ± 18%      -0.0        0.06 ± 50%  perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      0.05 ± 48%      -0.0        0.04 ± 71%  perf-profile.children.cycles-pp.sock_put
      0.06 ±  9%      -0.0        0.04 ± 71%  perf-profile.children.cycles-pp.aeMain
      0.05 ± 72%      -0.0        0.03 ±102%  perf-profile.children.cycles-pp.shmem_write_begin
      0.05 ± 72%      -0.0        0.03 ±102%  perf-profile.children.cycles-pp.shmem_getpage_gfp
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.redisBufferRead
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.__update_blocked_fair
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.updateClientMemUsageAndBucket
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.apparmor_socket_sendmsg
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.evictClients
      0.30 ±  4%      -0.0        0.28 ± 12%  perf-profile.children.cycles-pp.get_obj_cgroup_from_current
      0.18 ± 28%      -0.0        0.16 ± 29%  perf-profile.children.cycles-pp.ordered_events__queue
      0.67 ± 14%      -0.0        0.65 ± 17%  perf-profile.children.cycles-pp.exc_page_fault
      0.28 ± 10%      -0.0        0.26 ±  8%  perf-profile.children.cycles-pp.call_rcu
      0.51 ± 32%      -0.0        0.49 ± 25%  perf-profile.children.cycles-pp.perf_session__deliver_event
      0.13 ± 15%      -0.0        0.12 ±  8%  perf-profile.children.cycles-pp.__put_user_nocheck_8
      0.36 ± 12%      -0.0        0.34 ±  8%  perf-profile.children.cycles-pp._raw_write_lock_irq
      0.19 ±  9%      -0.0        0.17 ± 18%  perf-profile.children.cycles-pp.lapic_next_deadline
      0.11 ± 12%      -0.0        0.09 ± 29%  perf-profile.children.cycles-pp.tcp_stream_memory_free
      0.04 ± 71%      -0.0        0.03 ±101%  perf-profile.children.cycles-pp.connSocketEventHandler
      0.04 ± 45%      -0.0        0.03 ±101%  perf-profile.children.cycles-pp.nf_hook_slow
      0.08 ± 10%      -0.0        0.07 ± 16%  perf-profile.children.cycles-pp.tcp_rearm_rto
      0.05 ± 73%      -0.0        0.03 ±103%  perf-profile.children.cycles-pp.search_extable
      0.17 ± 28%      -0.0        0.15 ± 27%  perf-profile.children.cycles-pp.queue_event
      2.28 ± 18%      -0.0        2.27 ± 11%  perf-profile.children.cycles-pp.vfs_read
      0.27 ± 17%      -0.0        0.26 ± 13%  perf-profile.children.cycles-pp.zfree
      0.20 ± 28%      -0.0        0.19 ± 29%  perf-profile.children.cycles-pp.perf_output_copy
      0.09 ± 24%      -0.0        0.08 ± 16%  perf-profile.children.cycles-pp.tcp_ack_update_rtt
      0.10 ± 21%      -0.0        0.09 ± 12%  perf-profile.children.cycles-pp.rcu_sched_clock_irq
      0.09 ± 17%      -0.0        0.08 ± 16%  perf-profile.children.cycles-pp.clock_gettime
      0.09 ± 23%      -0.0        0.07 ± 18%  perf-profile.children.cycles-pp.cfree
      0.05 ± 74%      -0.0        0.04 ±101%  perf-profile.children.cycles-pp.search_exception_tables
      0.10 ± 10%      -0.0        0.09 ± 20%  perf-profile.children.cycles-pp.ip_output
      0.08 ± 17%      -0.0        0.07 ± 18%  perf-profile.children.cycles-pp._writeToClient
      0.08 ± 33%      -0.0        0.06 ± 56%  perf-profile.children.cycles-pp.kernelmode_fixup_or_oops
      0.26 ± 15%      -0.0        0.24 ± 11%  perf-profile.children.cycles-pp.task_tick_fair
      0.18 ± 18%      -0.0        0.17 ± 14%  perf-profile.children.cycles-pp.__fdget_pos
      1.36 ± 11%      -0.0        1.34 ± 11%  perf-profile.children.cycles-pp.asm_exc_page_fault
      0.51 ±  7%      -0.0        0.50 ±  7%  perf-profile.children.cycles-pp.mutex_lock
      0.18 ± 15%      -0.0        0.17 ± 13%  perf-profile.children.cycles-pp._raw_spin_lock_irq
      0.20 ± 14%      -0.0        0.19 ± 10%  perf-profile.children.cycles-pp.sock_recvmsg
      0.02 ±144%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.exit_to_user_mode_loop
      0.07 ± 18%      -0.0        0.06 ± 15%  perf-profile.children.cycles-pp.addReply
      0.12 ± 18%      -0.0        0.11 ± 12%  perf-profile.children.cycles-pp.processInputBuffer
      0.14 ± 14%      -0.0        0.13 ±  9%  perf-profile.children.cycles-pp.string2ll
      0.12 ± 13%      -0.0        0.10 ± 13%  perf-profile.children.cycles-pp.__libc_calloc
      0.08 ± 23%      -0.0        0.07 ± 14%  perf-profile.children.cycles-pp.clientHasPendingReplies
      0.52 ± 15%      -0.0        0.51 ± 10%  perf-profile.children.cycles-pp._raw_read_lock_irqsave
      0.48 ± 14%      -0.0        0.47 ± 10%  perf-profile.children.cycles-pp.tcp_queue_rcv
      0.21 ± 10%      -0.0        0.20 ±  9%  perf-profile.children.cycles-pp.mutex_unlock
      0.14 ± 14%      -0.0        0.13 ± 17%  perf-profile.children.cycles-pp.copy_user_generic_unrolled
      0.15 ± 40%      -0.0        0.14 ± 30%  perf-profile.children.cycles-pp.__kernel_text_address
      0.11 ± 36%      -0.0        0.10 ± 34%  perf-profile.children.cycles-pp.kernel_text_address
      0.06 ± 13%      -0.0        0.05 ± 52%  perf-profile.children.cycles-pp.__perf_sw_event
      0.03 ±100%      -0.0        0.02 ±141%  perf-profile.children.cycles-pp.__switch_to_asm
      0.02 ±142%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.fault_in_iov_iter_readable
      0.02 ±142%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.fault_in_readable
      0.02 ±142%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.__usecs_to_jiffies
      0.12 ± 11%      -0.0        0.11 ± 22%  perf-profile.children.cycles-pp.add_wait_queue
      0.10 ±  4%      -0.0        0.09 ± 21%  perf-profile.children.cycles-pp.sockfd_lookup_light
      0.04 ± 71%      -0.0        0.03 ±102%  perf-profile.children.cycles-pp.perf_output_begin_forward
      0.11 ±  9%      -0.0        0.10 ± 19%  perf-profile.children.cycles-pp.refill_obj_stock
      0.31 ± 29%      -0.0        0.30 ± 26%  perf-profile.children.cycles-pp.perf_output_sample
      0.56 ± 15%      -0.0        0.56 ± 14%  perf-profile.children.cycles-pp.do_user_addr_fault
      0.30 ± 11%      -0.0        0.29 ± 10%  perf-profile.children.cycles-pp.hdr_record_values
      0.28 ± 28%      -0.0        0.27 ± 27%  perf-profile.children.cycles-pp.pick_next_task_fair
      0.19 ± 24%      -0.0        0.18 ± 26%  perf-profile.children.cycles-pp.build_id__mark_dso_hit
      0.02 ± 99%      -0.0        0.02 ±141%  perf-profile.children.cycles-pp.netif_skb_features
      0.02 ± 99%      -0.0        0.02 ±141%  perf-profile.children.cycles-pp.rcu_eqs_exit
      0.02 ± 99%      -0.0        0.02 ±141%  perf-profile.children.cycles-pp.hrtimer_start_range_ns
      0.04 ± 71%      -0.0        0.03 ±100%  perf-profile.children.cycles-pp.sysvec_call_function_single
      0.04 ± 71%      -0.0        0.03 ±100%  perf-profile.children.cycles-pp.__update_load_avg_se
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.task_work_run
      0.02 ±141%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.ull2string
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.task_numa_work
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.change_protection_range
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.random
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.change_prot_numa
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.change_pmd_range
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.change_pte_range
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.trackingHandlePendingKeyInvalidations
      0.02 ±141%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.hrtimer_update_next_event
      0.02 ±141%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.scriptIsTimedout
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.timerqueue_del
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.sk_free
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.redisNetRead
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.sched_ttwu_pending
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.redisGetReply
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.slowlogPushEntryIfNeeded
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.freeReplyObject
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.wake_affine
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.available_idle_cpu
      0.01 ±223%      -0.0        0.00        perf-profile.children.cycles-pp.read
      0.18 ± 13%      -0.0        0.18 ±  9%  perf-profile.children.cycles-pp.security_socket_recvmsg
      0.10 ±  9%      -0.0        0.09 ± 15%  perf-profile.children.cycles-pp.tcp_tso_segs
      0.18 ± 37%      -0.0        0.18 ± 32%  perf-profile.children.cycles-pp.unwind_get_return_address
      0.09 ± 17%      -0.0        0.08 ± 20%  perf-profile.children.cycles-pp.tcp_update_skb_after_send
      0.06 ± 11%      -0.0        0.05 ± 48%  perf-profile.children.cycles-pp.ACLSelectorCheckCmd
      0.06 ± 23%      -0.0        0.05 ± 46%  perf-profile.children.cycles-pp.listNext
      0.05 ± 77%      -0.0        0.04 ±104%  perf-profile.children.cycles-pp.select_task_rq_fair
      0.10 ± 11%      -0.0        0.09 ±  8%  perf-profile.children.cycles-pp.hi_sdscatlen
      0.16 ± 16%      -0.0        0.15 ±  7%  perf-profile.children.cycles-pp.__netif_receive_skb_core
      0.50 ± 10%      -0.0        0.49 ±  9%  perf-profile.children.cycles-pp.sock_rfree
      0.12 ± 17%      -0.0        0.11 ±  9%  perf-profile.children.cycles-pp.ep_done_scan
      0.17 ± 30%      -0.0        0.16 ± 34%  perf-profile.children.cycles-pp.deref_stack_reg
      0.06 ± 21%      -0.0        0.06 ±  8%  perf-profile.children.cycles-pp.__tcp_select_window
      0.10 ± 23%      -0.0        0.09 ± 19%  perf-profile.children.cycles-pp._raw_spin_trylock
      0.08 ± 17%      -0.0        0.07 ± 14%  perf-profile.children.cycles-pp.hi_sdsrange
      0.04 ± 45%      -0.0        0.04 ± 71%  perf-profile.children.cycles-pp.syscall_exit_to_user_mode_prepare
      0.02 ±141%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.enqueue_hrtimer
      0.02 ±141%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.tcp_rate_gen
      0.28 ±  9%      -0.0        0.28 ± 11%  perf-profile.children.cycles-pp.tcp_mstamp_refresh
      0.13 ± 19%      -0.0        0.13 ± 18%  perf-profile.children.cycles-pp.update_rq_clock
      0.13 ± 27%      -0.0        0.13 ± 22%  perf-profile.children.cycles-pp.update_load_avg
      0.10 ± 55%      -0.0        0.09 ± 31%  perf-profile.children.cycles-pp.set_next_entity
      0.20 ± 37%      -0.0        0.19 ± 30%  perf-profile.children.cycles-pp.orc_find
      0.21 ± 13%      -0.0        0.20 ±  8%  perf-profile.children.cycles-pp.__cond_resched
      0.19 ±  8%      -0.0        0.19 ±  9%  perf-profile.children.cycles-pp.readHandler
      0.18 ± 20%      -0.0        0.18 ± 13%  perf-profile.children.cycles-pp.__fget_files
      0.15 ± 26%      -0.0        0.14 ± 11%  perf-profile.children.cycles-pp.je_free
      0.22 ± 41%      -0.0        0.22 ± 25%  perf-profile.children.cycles-pp.evlist__parse_sample
      0.10 ± 10%      -0.0        0.10 ± 10%  perf-profile.children.cycles-pp.syscall_enter_from_user_mode
      0.10 ± 26%      -0.0        0.10 ± 10%  perf-profile.children.cycles-pp.decrRefCount
      0.09 ± 21%      -0.0        0.08 ± 11%  perf-profile.children.cycles-pp.handleClientsWithPendingWrites
      0.09 ± 22%      -0.0        0.08 ± 14%  perf-profile.children.cycles-pp.update_blocked_averages
      0.07 ± 24%      -0.0        0.07 ± 14%  perf-profile.children.cycles-pp.run_rebalance_domains
      0.10 ±  9%      -0.0        0.09 ± 15%  perf-profile.children.cycles-pp.malloc
      0.14 ± 26%      -0.0        0.13 ± 26%  perf-profile.children.cycles-pp.thread__find_map
      0.06 ± 14%      -0.0        0.06 ±  8%  perf-profile.children.cycles-pp.getMonotonicUs_posix
      0.09 ± 32%      -0.0        0.08 ± 31%  perf-profile.children.cycles-pp.__perf_event_header__init_id
      0.04 ±101%      -0.0        0.03 ±101%  perf-profile.children.cycles-pp.bsearch
      0.05 ± 47%      -0.0        0.05 ± 73%  perf-profile.children.cycles-pp.io__get_hex
      0.16 ± 43%      -0.0        0.16 ± 42%  perf-profile.children.cycles-pp.ttwu_do_activate
      0.16 ± 45%      -0.0        0.16 ± 44%  perf-profile.children.cycles-pp.enqueue_task_fair
      0.42 ± 31%      -0.0        0.42 ± 30%  perf-profile.children.cycles-pp.__orc_find
      0.12 ± 10%      -0.0        0.12 ± 15%  perf-profile.children.cycles-pp.obj_cgroup_charge
      0.12 ± 17%      -0.0        0.12 ± 19%  perf-profile.children.cycles-pp.ip_rcv_core
      0.10 ± 14%      -0.0        0.09 ± 17%  perf-profile.children.cycles-pp.rcu_segcblist_enqueue
      0.10 ± 20%      -0.0        0.09 ± 17%  perf-profile.children.cycles-pp.arch_cpu_idle_enter
      0.05 ± 50%      -0.0        0.05 ± 50%  perf-profile.children.cycles-pp.queued_write_lock_slowpath
      0.07 ± 14%      -0.0        0.07 ± 26%  perf-profile.children.cycles-pp.___perf_sw_event
      0.08 ± 56%      -0.0        0.08 ± 55%  perf-profile.children.cycles-pp.copy_page_from_iter_atomic
      0.14 ± 17%      -0.0        0.14 ± 24%  perf-profile.children.cycles-pp.perf_mux_hrtimer_handler
      0.17 ± 14%      -0.0        0.16 ± 12%  perf-profile.children.cycles-pp.netif_rx_internal
      0.09 ± 23%      -0.0        0.09 ± 16%  perf-profile.children.cycles-pp.tsc_verify_tsc_adjust
      0.06 ± 78%      -0.0        0.05 ±105%  perf-profile.children.cycles-pp.select_task_rq
      0.10 ± 20%      -0.0        0.10 ± 20%  perf-profile.children.cycles-pp.siphash_nocase
      0.23 ± 18%      -0.0        0.23 ± 12%  perf-profile.children.cycles-pp.do_numa_page
      0.15 ± 14%      -0.0        0.15 ± 18%  perf-profile.children.cycles-pp.security_file_permission
      0.13 ± 11%      -0.0        0.12 ± 18%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.08 ± 15%      -0.0        0.08 ± 17%  perf-profile.children.cycles-pp.__list_add_valid
      0.06 ± 13%      -0.0        0.06 ± 11%  perf-profile.children.cycles-pp.rcu_all_qs
      0.05 ± 47%      -0.0        0.05 ± 73%  perf-profile.children.cycles-pp.seq_read_iter
      0.03 ±102%      -0.0        0.03 ±100%  perf-profile.children.cycles-pp.prepareClientToWrite
      0.01 ±223%      -0.0        0.01 ±223%  perf-profile.children.cycles-pp.perf_env__arch
      0.11 ± 28%      -0.0        0.11 ± 11%  perf-profile.children.cycles-pp.createEmbeddedStringObject
      0.03 ±100%      -0.0        0.02 ± 99%  perf-profile.children.cycles-pp.__update_load_avg_cfs_rq
      2.06 ± 18%      -0.0        2.06 ± 11%  perf-profile.children.cycles-pp.new_sync_read
      0.43 ± 16%      +0.0        0.43 ± 12%  perf-profile.children.cycles-pp.handle_mm_fault
      0.73 ± 30%      +0.0        0.73 ± 29%  perf-profile.children.cycles-pp.schedule_idle
      0.16 ± 13%      +0.0        0.16 ± 12%  perf-profile.children.cycles-pp.enqueue_to_backlog
      0.13 ± 13%      +0.0        0.13 ± 11%  perf-profile.children.cycles-pp.exit_to_user_mode_prepare
      0.13 ± 14%      +0.0        0.13 ± 18%  perf-profile.children.cycles-pp.apparmor_file_permission
      0.14 ±  8%      +0.0        0.14 ± 11%  perf-profile.children.cycles-pp.rb_erase
      0.08 ± 16%      +0.0        0.08 ± 10%  perf-profile.children.cycles-pp._addReplyToBufferOrList
      0.05 ± 47%      +0.0        0.05 ± 51%  perf-profile.children.cycles-pp.__intel_pmu_enable_all
      0.07 ± 18%      +0.0        0.07 ± 11%  perf-profile.children.cycles-pp.addReplyOrErrorObject
      0.14 ± 50%      +0.0        0.14 ± 24%  perf-profile.children.cycles-pp.evsel__parse_sample
      0.09 ± 24%      +0.0        0.09 ± 26%  perf-profile.children.cycles-pp.kallsyms__parse
      0.02 ±141%      +0.0        0.02 ±141%  perf-profile.children.cycles-pp.__sysvec_call_function_single
      0.02 ±141%      +0.0        0.02 ±144%  perf-profile.children.cycles-pp.__task_pid_nr_ns
      0.01 ±223%      +0.0        0.01 ±223%  perf-profile.children.cycles-pp.reweight_entity
      0.01 ±223%      +0.0        0.01 ±223%  perf-profile.children.cycles-pp.ttwu_do_wakeup
      0.18 ± 32%      +0.0        0.19 ± 28%  perf-profile.children.cycles-pp.memcpy_erms
      0.08 ± 17%      +0.0        0.08 ± 13%  perf-profile.children.cycles-pp.resetClient
      0.04 ± 75%      +0.0        0.05 ± 45%  perf-profile.children.cycles-pp.machines__deliver_event
      0.02 ±141%      +0.0        0.02 ±142%  perf-profile.children.cycles-pp.idle_cpu
      0.04 ± 71%      +0.0        0.04 ± 72%  perf-profile.children.cycles-pp.__switch_to
      0.17 ± 15%      +0.0        0.18 ± 12%  perf-profile.children.cycles-pp.__netif_rx
      0.11 ± 23%      +0.0        0.11 ± 25%  perf-profile.children.cycles-pp.dso__load
      0.11 ± 23%      +0.0        0.11 ± 25%  perf-profile.children.cycles-pp.__dso__load_kallsyms
      0.05 ± 46%      +0.0        0.06 ±  8%  perf-profile.children.cycles-pp.redisReaderFeed
      0.02 ±142%      +0.0        0.02 ±142%  perf-profile.children.cycles-pp.hrtimer_next_event_without
      0.02 ±141%      +0.0        0.02 ±144%  perf-profile.children.cycles-pp.__hrtimer_next_event_base
      0.34 ± 14%      +0.0        0.34 ± 14%  perf-profile.children.cycles-pp.__handle_mm_fault
      0.11 ± 25%      +0.0        0.12 ± 27%  perf-profile.children.cycles-pp.map__load
      0.06 ± 46%      +0.0        0.06 ±  9%  perf-profile.children.cycles-pp.beforeSleep
      0.06 ±  9%      +0.0        0.06 ± 11%  perf-profile.children.cycles-pp.tcp_rate_skb_delivered
      0.08 ± 32%      +0.0        0.08 ± 29%  perf-profile.children.cycles-pp.uart_console_write
      0.08 ± 32%      +0.0        0.08 ± 29%  perf-profile.children.cycles-pp.wait_for_xmitr
      0.09 ± 18%      +0.0        0.10 ± 17%  perf-profile.children.cycles-pp.siphash
      0.02 ±143%      +0.0        0.03 ±101%  perf-profile.children.cycles-pp.core_kernel_text
      0.01 ±223%      +0.0        0.02 ±142%  perf-profile.children.cycles-pp.note_gp_changes
      0.01 ±223%      +0.0        0.02 ±141%  perf-profile.children.cycles-pp.cmp_ex_search
      0.05 ± 46%      +0.0        0.06 ±  8%  perf-profile.children.cycles-pp.__copy_skb_header
      0.04 ± 75%      +0.0        0.04 ± 45%  perf-profile.children.cycles-pp.connSocketWrite
      0.02 ±141%      +0.0        0.03 ±100%  perf-profile.children.cycles-pp.perf_poll
      0.11 ± 57%      +0.0        0.12 ± 43%  perf-profile.children.cycles-pp.enqueue_entity
      0.07 ± 32%      +0.0        0.08 ± 27%  perf-profile.children.cycles-pp.serial8250_console_putchar
      0.08 ± 19%      +0.0        0.09 ± 16%  perf-profile.children.cycles-pp.aeCreateFileEvent
      0.13 ± 22%      +0.0        0.14 ± 25%  perf-profile.children.cycles-pp.newidle_balance
      0.05 ± 46%      +0.0        0.06 ± 13%  perf-profile.children.cycles-pp.ACLCheckAllUserCommandPerm
      0.04 ± 75%      +0.0        0.05 ± 48%  perf-profile.children.cycles-pp.do_poll
      0.01 ±223%      +0.0        0.02 ±142%  perf-profile.children.cycles-pp.handle_pte_fault
      0.00            +0.0        0.01 ±223%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.00            +0.0        0.01 ±223%  perf-profile.children.cycles-pp.free_pcp_prepare
      0.00            +0.0        0.01 ±223%  perf-profile.children.cycles-pp.addReplyLongLongWithPrefix
      0.00            +0.0        0.01 ±223%  perf-profile.children.cycles-pp.seq_printf
      0.00            +0.0        0.01 ±223%  perf-profile.children.cycles-pp.vsnprintf
      0.00            +0.0        0.01 ±223%  perf-profile.children.cycles-pp.aa_file_perm
      0.00            +0.0        0.01 ±223%  perf-profile.children.cycles-pp.rb_next
      0.00            +0.0        0.01 ±223%  perf-profile.children.cycles-pp.call_cpuidle
      1.99 ± 18%      +0.0        2.00 ± 11%  perf-profile.children.cycles-pp.sock_read_iter
      0.08 ± 32%      +0.0        0.09 ± 27%  perf-profile.children.cycles-pp.serial8250_console_write
      0.02 ± 99%      +0.0        0.04 ± 71%  perf-profile.children.cycles-pp.ip_skb_dst_mtu
      0.01 ±223%      +0.0        0.02 ±142%  perf-profile.children.cycles-pp.tcp_established_options
      0.02 ±141%      +0.0        0.03 ±100%  perf-profile.children.cycles-pp.sk_filter_trim_cap
      0.08 ± 32%      +0.0        0.09 ± 26%  perf-profile.children.cycles-pp.asm_sysvec_irq_work
      0.08 ± 32%      +0.0        0.09 ± 26%  perf-profile.children.cycles-pp.sysvec_irq_work
      0.08 ± 32%      +0.0        0.09 ± 26%  perf-profile.children.cycles-pp.__sysvec_irq_work
      0.08 ± 32%      +0.0        0.09 ± 26%  perf-profile.children.cycles-pp.irq_work_run
      0.08 ± 32%      +0.0        0.09 ± 26%  perf-profile.children.cycles-pp.irq_work_single
      0.08 ± 35%      +0.0        0.09 ± 24%  perf-profile.children.cycles-pp._printk
      0.08 ± 35%      +0.0        0.09 ± 24%  perf-profile.children.cycles-pp.vprintk_emit
      0.08 ± 35%      +0.0        0.09 ± 24%  perf-profile.children.cycles-pp.console_unlock
      0.08 ± 35%      +0.0        0.09 ± 24%  perf-profile.children.cycles-pp.call_console_drivers
      0.04 ± 71%      +0.0        0.05 ± 46%  perf-profile.children.cycles-pp.createStringObject
      0.08 ± 30%      +0.0        0.10 ± 28%  perf-profile.children.cycles-pp.irq_work_run_list
      0.05 ± 74%      +0.0        0.06 ± 50%  perf-profile.children.cycles-pp.__poll
      0.02 ± 99%      +0.0        0.04 ± 73%  perf-profile.children.cycles-pp.proc_reg_read
      0.10 ± 12%      +0.0        0.12 ± 20%  perf-profile.children.cycles-pp.finish_task_switch
      0.20 ± 26%      +0.0        0.22 ± 14%  perf-profile.children.cycles-pp.rebalance_domains
      0.03 ±100%      +0.0        0.04 ± 73%  perf-profile.children.cycles-pp.seq_read
      0.12 ± 48%      +0.0        0.13 ± 33%  perf-profile.children.cycles-pp.tick_sched_do_timer
      0.20 ± 19%      +0.0        0.22 ± 13%  perf-profile.children.cycles-pp.__list_del_entry_valid
      0.00            +0.0        0.02 ±223%  perf-profile.children.cycles-pp.__free_one_page
      0.01 ±223%      +0.0        0.02 ± 99%  perf-profile.children.cycles-pp.update_irq_load_avg
      0.05 ± 78%      +0.0        0.06 ± 50%  perf-profile.children.cycles-pp.__x64_sys_poll
      0.05 ± 78%      +0.0        0.06 ± 50%  perf-profile.children.cycles-pp.do_sys_poll
      0.02 ±141%      +0.0        0.03 ± 70%  perf-profile.children.cycles-pp.cliWriteConn
      0.00            +0.0        0.02 ±141%  perf-profile.children.cycles-pp.redisNextInBandReplyFromReader
      0.00            +0.0        0.02 ±141%  perf-profile.children.cycles-pp.switch_mm_irqs_off
      0.01 ±223%      +0.0        0.02 ± 99%  perf-profile.children.cycles-pp.raw_local_deliver
      0.06 ± 72%      +0.0        0.08 ± 31%  perf-profile.children.cycles-pp.prepare_task_switch
      0.00            +0.0        0.02 ±142%  perf-profile.children.cycles-pp.tick_nohz_idle_exit
      0.12 ± 17%      +0.0        0.14 ±  8%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      0.14 ± 18%      +0.0        0.16 ± 15%  perf-profile.children.cycles-pp.update_sd_lb_stats
      0.95 ± 12%      +0.0        0.97 ±  7%  perf-profile.children.cycles-pp._copy_to_iter
      0.14 ± 21%      +0.0        0.17 ± 14%  perf-profile.children.cycles-pp.find_busiest_group
      0.11 ± 20%      +0.0        0.14 ± 19%  perf-profile.children.cycles-pp.update_sg_lb_stats
      0.44 ±  8%      +0.0        0.46 ± 16%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.49 ±  8%      +0.0        0.51 ± 16%  perf-profile.children.cycles-pp.ret_from_fork
      0.49 ±  8%      +0.0        0.51 ± 16%  perf-profile.children.cycles-pp.kthread
      0.42 ±  9%      +0.0        0.44 ± 17%  perf-profile.children.cycles-pp.run_ksoftirqd
      0.10 ± 14%      +0.0        0.12 ± 20%  perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.06 ± 47%      +0.0        0.08 ± 47%  perf-profile.children.cycles-pp.tick_irq_enter
      0.00            +0.0        0.03 ±100%  perf-profile.children.cycles-pp.tcp_data_ready
      0.18 ± 20%      +0.0        0.20 ±  8%  perf-profile.children.cycles-pp.load_balance
      0.07 ± 47%      +0.0        0.09 ± 25%  perf-profile.children.cycles-pp.irq_enter_rcu
      0.28 ±  9%      +0.0        0.31 ±  6%  perf-profile.children.cycles-pp.tcp_rcv_space_adjust
      0.03 ±100%      +0.0        0.06 ±  8%  perf-profile.children.cycles-pp.tcp_rate_skb_sent
      0.00            +0.0        0.03 ±102%  perf-profile.children.cycles-pp.nr_iowait_cpu
      0.19 ± 11%      +0.0        0.22 ± 10%  perf-profile.children.cycles-pp.tcp_schedule_loss_probe
      0.00            +0.0        0.03 ±223%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.10 ± 17%      +0.0        0.14 ±223%  perf-profile.children.cycles-pp.dst_release
      0.40 ±  6%      +0.0        0.43 ± 10%  perf-profile.children.cycles-pp._raw_spin_lock
      0.84 ± 13%      +0.0        0.87 ±  8%  perf-profile.children.cycles-pp.copyout
      0.59 ± 16%      +0.0        0.62 ± 11%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.19 ± 17%      +0.0        0.23 ±  6%  perf-profile.children.cycles-pp.ip_local_out
      0.10 ±141%      +0.0        0.14 ±100%  perf-profile.children.cycles-pp.irqentry_exit_to_user_mode
      0.15 ± 14%      +0.0        0.19 ±223%  perf-profile.children.cycles-pp.skb_release_head_state
      0.00            +0.0        0.04 ±223%  perf-profile.children.cycles-pp.free_unref_page
      0.03 ±147%      +0.0        0.07 ± 23%  perf-profile.children.cycles-pp.io_serial_in
      0.18 ± 19%      +0.0        0.22 ±  4%  perf-profile.children.cycles-pp.__ip_local_out
      0.00            +0.0        0.04 ±223%  perf-profile.children.cycles-pp.__unfreeze_partials
      0.52 ±  8%      +0.0        0.56 ± 16%  perf-profile.children.cycles-pp.rcu_do_batch
      0.14 ± 20%      +0.0        0.19 ±  5%  perf-profile.children.cycles-pp.ip_send_check
      0.57 ±  7%      +0.0        0.62 ± 17%  perf-profile.children.cycles-pp.rcu_core
      3.25 ± 18%      +0.0        3.30 ± 15%  perf-profile.children.cycles-pp.__libc_read
      0.02 ±142%      +0.1        0.07 ± 51%  perf-profile.children.cycles-pp.kfree_skbmem
      0.87 ± 14%      +0.1        0.92 ± 12%  perf-profile.children.cycles-pp.skb_do_copy_data_nocache
      0.06 ± 47%      +0.1        0.12 ± 55%  perf-profile.children.cycles-pp.ktime_get_update_offsets_now
      0.00            +0.1        0.07 ± 14%  perf-profile.children.cycles-pp.rmqueue_bulk
      0.00            +0.1        0.07 ± 12%  perf-profile.children.cycles-pp.tcp_chrono_start
      0.90 ±  8%      +0.1        0.97 ± 11%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.85 ± 17%      +0.1        0.94 ± 11%  perf-profile.children.cycles-pp.lookupKey
      3.37 ± 18%      +0.1        3.46 ± 10%  perf-profile.children.cycles-pp.dictFind
      0.41 ± 10%      +0.1        0.50 ± 13%  perf-profile.children.cycles-pp.__skb_clone
      0.25 ±  7%      +0.1        0.34 ± 12%  perf-profile.children.cycles-pp.simple_copy_to_iter
      0.09 ± 15%      +0.1        0.20 ± 27%  perf-profile.children.cycles-pp.__virt_addr_valid
      0.14 ± 20%      +0.1        0.25 ± 10%  perf-profile.children.cycles-pp.tcp_skb_entail
      0.00            +0.1        0.11 ± 16%  perf-profile.children.cycles-pp.rmqueue
      0.00            +0.1        0.12 ± 18%  perf-profile.children.cycles-pp.setup_object
      1.65 ± 10%      +0.1        1.76 ±  8%  perf-profile.children.cycles-pp.__skb_datagram_iter
      1.66 ± 11%      +0.1        1.78 ±  8%  perf-profile.children.cycles-pp.skb_copy_datagram_iter
      2.25 ±  5%      +0.1        2.38 ±  8%  perf-profile.children.cycles-pp.__sys_recvfrom
      2.27 ±  5%      +0.1        2.40 ±  8%  perf-profile.children.cycles-pp.__x64_sys_recvfrom
      0.02 ±142%      +0.1        0.15 ± 16%  perf-profile.children.cycles-pp.__alloc_pages
      0.00            +0.1        0.14 ± 15%  perf-profile.children.cycles-pp.get_page_from_freelist
      3.87 ± 10%      +0.1        4.02 ±  8%  perf-profile.children.cycles-pp.inet_recvmsg
      3.82 ± 10%      +0.2        3.98 ±  8%  perf-profile.children.cycles-pp.tcp_recvmsg
      0.48 ± 10%      +0.2        0.64 ± 13%  perf-profile.children.cycles-pp.kmalloc_reserve
      0.00            +0.2        0.17 ± 14%  perf-profile.children.cycles-pp.skb_attempt_defer_free
      0.45 ± 10%      +0.2        0.62 ± 13%  perf-profile.children.cycles-pp.__kmalloc_node_track_caller
      0.21 ± 13%      +0.2        0.38 ± 12%  perf-profile.children.cycles-pp.kmem_cache_alloc_node
      0.38 ±  9%      +0.2        0.56 ± 13%  perf-profile.children.cycles-pp.__check_object_size
      2.79 ± 14%      +0.2        2.99 ± 16%  perf-profile.children.cycles-pp.__libc_recv
      3.29 ± 10%      +0.2        3.48 ±  8%  perf-profile.children.cycles-pp.tcp_recvmsg_locked
      1.18 ± 11%      +0.2        1.40 ± 10%  perf-profile.children.cycles-pp.__dev_queue_xmit
      0.05 ± 45%      +0.2        0.27 ± 12%  perf-profile.children.cycles-pp.tcp_cleanup_rbuf
      0.25 ± 93%      +0.3        0.53 ± 63%  perf-profile.children.cycles-pp.start_kernel
      1.31 ± 11%      +0.3        1.61 ± 12%  perf-profile.children.cycles-pp.__alloc_skb
      1.46 ± 11%      +0.3        1.76 ± 11%  perf-profile.children.cycles-pp.tcp_stream_alloc_skb
      0.20 ± 11%      +0.4        0.57 ± 13%  perf-profile.children.cycles-pp.___slab_alloc
      0.06 ± 19%      +0.4        0.44 ± 16%  perf-profile.children.cycles-pp.allocate_slab
     33.03 ± 20%      +1.0       34.05 ± 21%  perf-profile.children.cycles-pp.mwait_idle_with_hints
     33.04 ± 20%      +1.0       34.06 ± 21%  perf-profile.children.cycles-pp.intel_idle
      2.63 ±129%      +1.0        3.68 ± 94%  perf-profile.children.cycles-pp.syscall_exit_to_user_mode
      3.69 ± 15%      +1.2        4.85 ± 35%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.55 ± 33%      +1.4        1.93 ±101%  perf-profile.children.cycles-pp.poll_idle
     39.36 ± 17%      +1.8       41.14 ± 16%  perf-profile.children.cycles-pp.secondary_startup_64_no_verify
     39.36 ± 17%      +1.8       41.14 ± 16%  perf-profile.children.cycles-pp.cpu_startup_entry
     38.38 ± 17%      +1.8       40.17 ± 16%  perf-profile.children.cycles-pp.cpuidle_idle_call
     39.35 ± 17%      +1.8       41.14 ± 16%  perf-profile.children.cycles-pp.do_idle
     37.14 ± 18%      +1.8       38.95 ± 16%  perf-profile.children.cycles-pp.cpuidle_enter
     37.13 ± 18%      +1.8       38.94 ± 16%  perf-profile.children.cycles-pp.cpuidle_enter_state
      0.27 ± 10%      -0.3        0.00        perf-profile.self.cycles-pp.tcp_eat_recv_skb
      0.39 ± 12%      -0.2        0.15 ± 12%  perf-profile.self.cycles-pp.__ksize
      0.45 ±  8%      -0.2        0.23 ±104%  perf-profile.self.cycles-pp.__slab_free
      0.73 ± 13%      -0.2        0.53 ± 56%  perf-profile.self.cycles-pp.skb_release_data
      0.20 ± 16%      -0.2        0.01 ±223%  perf-profile.self.cycles-pp.skb_page_frag_refill
      0.44 ± 12%      -0.2        0.27 ± 12%  perf-profile.self.cycles-pp.tcp_clean_rtx_queue
      0.67 ± 10%      -0.1        0.57 ± 11%  perf-profile.self.cycles-pp.tcp_poll
      0.52 ± 13%      -0.1        0.42 ± 11%  perf-profile.self.cycles-pp.tcp_ack
      0.17 ± 14%      -0.1        0.08 ± 16%  perf-profile.self.cycles-pp.__local_bh_enable_ip
      0.24 ± 18%      -0.1        0.15 ±  8%  perf-profile.self.cycles-pp.aa_sk_perm
      0.36 ± 13%      -0.1        0.28 ± 40%  perf-profile.self.cycles-pp.cpuidle_enter_state
      0.09 ± 17%      -0.1        0.01 ±223%  perf-profile.self.cycles-pp.cubictcp_acked
      0.10 ± 11%      -0.1        0.02 ±141%  perf-profile.self.cycles-pp.cubictcp_cwnd_event
      1.42 ± 16%      -0.1        1.34 ± 10%  perf-profile.self.cycles-pp.stringObjectLen
      0.26 ±  8%      -0.1        0.18 ± 21%  perf-profile.self.cycles-pp.kmem_cache_free
      0.37 ± 13%      -0.1        0.30 ± 10%  perf-profile.self.cycles-pp.tcp_v4_rcv
      0.54 ± 13%      -0.1        0.47 ± 12%  perf-profile.self.cycles-pp.tcp_rcv_established
      0.47 ± 15%      -0.1        0.40 ± 13%  perf-profile.self.cycles-pp.aeProcessEvents
      0.23 ± 18%      -0.1        0.16 ±  9%  perf-profile.self.cycles-pp.__mod_timer
      0.11 ±  6%      -0.1        0.04 ± 75%  perf-profile.self.cycles-pp.do_softirq
      0.73 ± 10%      -0.1        0.67 ±  7%  perf-profile.self.cycles-pp.__inet_lookup_established
      0.32 ±  6%      -0.1        0.26 ± 22%  perf-profile.self.cycles-pp.memcg_slab_free_hook
      0.60 ± 33%      -0.1        0.54 ± 34%  perf-profile.self.cycles-pp.unwind_next_frame
      0.54 ± 20%      -0.1        0.49 ± 11%  perf-profile.self.cycles-pp.dictSdsKeyCompare
      0.42 ±  6%      -0.1        0.37 ± 10%  perf-profile.self.cycles-pp.__might_resched
      0.46 ± 21%      -0.1        0.41 ± 12%  perf-profile.self.cycles-pp.je_malloc_usable_size
      0.24 ±  5%      -0.0        0.19 ± 17%  perf-profile.self.cycles-pp.__might_sleep
      0.05 ± 48%      -0.0        0.00        perf-profile.self.cycles-pp.ep_ptable_queue_proc
      0.05 ± 46%      -0.0        0.00        perf-profile.self.cycles-pp.tcp_small_queue_check
      0.29 ± 15%      -0.0        0.25 ± 10%  perf-profile.self.cycles-pp.processMultibulkBuffer
      0.51 ± 16%      -0.0        0.46 ±  7%  perf-profile.self.cycles-pp.timekeeping_max_deferment
      0.59 ±  9%      -0.0        0.55 ±  4%  perf-profile.self.cycles-pp.sock_poll
      0.24 ± 11%      -0.0        0.20 ±  9%  perf-profile.self.cycles-pp.ep_insert
      1.45 ± 11%      -0.0        1.41 ±  8%  perf-profile.self.cycles-pp.copy_user_enhanced_fast_string
      0.22 ± 17%      -0.0        0.18 ± 11%  perf-profile.self.cycles-pp.tcp_check_space
      0.23 ± 11%      -0.0        0.19 ± 12%  perf-profile.self.cycles-pp.ip_finish_output2
      0.27 ± 11%      -0.0        0.23 ± 16%  perf-profile.self.cycles-pp.redisReaderGetReply
      0.06 ± 15%      -0.0        0.02 ±142%  perf-profile.self.cycles-pp.validate_xmit_skb
      0.14 ± 22%      -0.0        0.10 ± 16%  perf-profile.self.cycles-pp.ipv4_mtu
      0.13 ± 19%      -0.0        0.09 ± 13%  perf-profile.self.cycles-pp.tcp_current_mss
      0.07 ± 20%      -0.0        0.03 ±100%  perf-profile.self.cycles-pp.ip_rcv_finish_core
      0.33 ±  7%      -0.0        0.29 ± 13%  perf-profile.self.cycles-pp.native_sched_clock
      0.38 ±  6%      -0.0        0.34 ±  8%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.72 ± 10%      -0.0        0.69 ± 11%  perf-profile.self.cycles-pp.ep_poll_callback
      0.35 ±  5%      -0.0        0.32 ± 13%  perf-profile.self.cycles-pp.__fget_light
      0.06 ± 46%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp.inet_send_prepare
      0.28 ±  7%      -0.0        0.24 ± 15%  perf-profile.self.cycles-pp.kmem_cache_alloc
      0.50 ±  6%      -0.0        0.47 ±  4%  perf-profile.self.cycles-pp.writeHandler
      0.11 ± 17%      -0.0        0.08 ± 18%  perf-profile.self.cycles-pp.do_numa_page
      0.05 ±  8%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp.ip_output
      0.76 ± 12%      -0.0        0.73 ± 13%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.32 ± 18%      -0.0        0.28 ±  9%  perf-profile.self.cycles-pp.call
      0.17 ± 21%      -0.0        0.13 ± 15%  perf-profile.self.cycles-pp.__wake_up_common
      0.23 ± 18%      -0.0        0.20 ± 13%  perf-profile.self.cycles-pp.je_malloc
      0.32 ±  8%      -0.0        0.28 ±  8%  perf-profile.self.cycles-pp.epoll_ctl
      0.17 ± 15%      -0.0        0.14 ± 10%  perf-profile.self.cycles-pp.tcp_wfree
      0.03 ±103%      -0.0        0.00        perf-profile.self.cycles-pp.tcp_rtt_estimator
      0.07 ± 18%      -0.0        0.04 ± 75%  perf-profile.self.cycles-pp.fput_many
      0.04 ± 45%      -0.0        0.01 ±223%  perf-profile.self.cycles-pp.kfree
      0.22 ± 14%      -0.0        0.19 ± 12%  perf-profile.self.cycles-pp.processCommand
      0.23 ± 10%      -0.0        0.20 ± 13%  perf-profile.self.cycles-pp.calc_global_load_tick
      0.14 ± 23%      -0.0        0.11 ± 13%  perf-profile.self.cycles-pp.vfs_write
      0.10 ± 14%      -0.0        0.07 ± 10%  perf-profile.self.cycles-pp.rb_first
      0.15 ±  9%      -0.0        0.12 ±  7%  perf-profile.self.cycles-pp.__put_user_nocheck_4
      0.06 ± 19%      -0.0        0.04 ± 71%  perf-profile.self.cycles-pp.tcp_update_skb_after_send
      0.06 ± 11%      -0.0        0.03 ±101%  perf-profile.self.cycles-pp.fsnotify_perm
      0.38 ±  7%      -0.0        0.35 ± 12%  perf-profile.self.cycles-pp.__entry_text_start
      0.43 ± 11%      -0.0        0.40 ± 14%  perf-profile.self.cycles-pp.native_irq_return_iret
      0.32 ±  6%      -0.0        0.30 ± 13%  perf-profile.self.cycles-pp.memcg_slab_post_alloc_hook
      0.54 ± 13%      -0.0        0.51 ±  9%  perf-profile.self.cycles-pp._raw_spin_lock_bh
      0.13 ± 16%      -0.0        0.10 ± 11%  perf-profile.self.cycles-pp.sock_write_iter
      0.48 ±  7%      -0.0        0.45 ± 11%  perf-profile.self.cycles-pp.read_tsc
      0.22 ± 15%      -0.0        0.20 ± 18%  perf-profile.self.cycles-pp.do_syscall_64
      0.12 ± 46%      -0.0        0.10 ± 32%  perf-profile.self.cycles-pp.__mod_memcg_lruvec_state
      0.04 ± 71%      -0.0        0.01 ±223%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.04 ± 71%      -0.0        0.01 ±223%  perf-profile.self.cycles-pp.cubictcp_cong_avoid
      0.06 ± 13%      -0.0        0.03 ±100%  perf-profile.self.cycles-pp.arch_scale_freq_tick
      0.07 ± 19%      -0.0        0.04 ± 45%  perf-profile.self.cycles-pp.tcp_event_data_recv
      0.07 ± 17%      -0.0        0.04 ± 45%  perf-profile.self.cycles-pp.release_sock
      0.07            -0.0        0.05 ± 45%  perf-profile.self.cycles-pp.rb_insert_color
      0.02 ±141%      -0.0        0.00        perf-profile.self.cycles-pp.try_to_wake_up
      0.09 ± 20%      -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.sock_sendmsg
      0.07 ± 20%      -0.0        0.05 ± 47%  perf-profile.self.cycles-pp.ipv4_dst_check
      0.10 ± 19%      -0.0        0.08 ± 14%  perf-profile.self.cycles-pp.new_sync_write
      0.26 ± 10%      -0.0        0.24 ±  8%  perf-profile.self.cycles-pp.tcp_write_xmit
      0.07 ± 29%      -0.0        0.05 ± 72%  perf-profile.self.cycles-pp.perf_output_copy
      0.04 ± 72%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp.ip_protocol_deliver_rcu
      0.28 ± 11%      -0.0        0.26 ± 11%  perf-profile.self.cycles-pp._raw_read_unlock_irqrestore
      0.29 ± 22%      -0.0        0.27 ± 16%  perf-profile.self.cycles-pp.zmalloc
      0.15 ± 21%      -0.0        0.13 ± 15%  perf-profile.self.cycles-pp.writeToClient
      0.06 ± 13%      -0.0        0.04 ± 71%  perf-profile.self.cycles-pp.__x64_sys_sendto
      0.12 ±  8%      -0.0        0.09 ± 15%  perf-profile.self.cycles-pp.memset_erms
      0.26 ± 13%      -0.0        0.24 ± 13%  perf-profile.self.cycles-pp.ep_send_events
      0.10 ± 17%      -0.0        0.08 ± 21%  perf-profile.self.cycles-pp.tcp_rate_check_app_limited
      0.05 ±  8%      -0.0        0.03 ±101%  perf-profile.self.cycles-pp.ACLSelectorCheckCmd
      0.52 ±  6%      -0.0        0.50 ±  6%  perf-profile.self.cycles-pp.do_epoll_ctl
      0.14 ± 11%      -0.0        0.12 ± 14%  perf-profile.self.cycles-pp.redisBufferWrite
      0.18 ± 13%      -0.0        0.16 ± 11%  perf-profile.self.cycles-pp.tcp_event_new_data_sent
      0.15 ± 20%      -0.0        0.14 ± 21%  perf-profile.self.cycles-pp.readQueryFromClient
      0.16 ±  7%      -0.0        0.14 ± 21%  perf-profile.self.cycles-pp.aeDeleteFileEvent
      0.08 ± 10%      -0.0        0.06 ± 17%  perf-profile.self.cycles-pp.redisNetWrite
      0.05 ±  8%      -0.0        0.04 ± 71%  perf-profile.self.cycles-pp.aeMain
      0.03 ±100%      -0.0        0.01 ±223%  perf-profile.self.cycles-pp.tcp_recvmsg
      0.12 ± 12%      -0.0        0.10 ± 16%  perf-profile.self.cycles-pp.___slab_alloc
      0.08 ± 10%      -0.0        0.06 ± 21%  perf-profile.self.cycles-pp.inet_ehashfn
      0.06 ± 82%      -0.0        0.04 ± 73%  perf-profile.self.cycles-pp.reader__read_event
      0.30 ±  3%      -0.0        0.28 ± 13%  perf-profile.self.cycles-pp.get_obj_cgroup_from_current
      0.14 ± 23%      -0.0        0.12 ± 16%  perf-profile.self.cycles-pp.sync_regs
      0.10 ± 23%      -0.0        0.08 ± 16%  perf-profile.self.cycles-pp._raw_spin_trylock
      0.05 ± 71%      -0.0        0.03 ±100%  perf-profile.self.cycles-pp.set_next_entity
      0.02 ±141%      -0.0        0.00        perf-profile.self.cycles-pp.ull2string
      0.04 ± 72%      -0.0        0.02 ±143%  perf-profile.self.cycles-pp.enqueue_task_fair
      0.02 ±141%      -0.0        0.00        perf-profile.self.cycles-pp.memcpy@plt
      0.02 ±141%      -0.0        0.00        perf-profile.self.cycles-pp.apparmor_socket_sendmsg
      0.02 ±141%      -0.0        0.00        perf-profile.self.cycles-pp.ip_local_deliver_finish
      0.13 ± 12%      -0.0        0.11 ± 16%  perf-profile.self.cycles-pp.tcp_update_pacing_rate
      0.08 ± 10%      -0.0        0.06 ± 11%  perf-profile.self.cycles-pp.__libc_send
      0.06 ±  9%      -0.0        0.04 ± 45%  perf-profile.self.cycles-pp.__tcp_push_pending_frames
      0.06 ± 26%      -0.0        0.05 ± 46%  perf-profile.self.cycles-pp.cfree
      0.19 ±  9%      -0.0        0.17 ± 18%  perf-profile.self.cycles-pp.lapic_next_deadline
      0.11 ± 10%      -0.0        0.10 ± 12%  perf-profile.self.cycles-pp.__libc_calloc
      0.08 ±  6%      -0.0        0.06 ± 11%  perf-profile.self.cycles-pp.tcp_rearm_rto
      0.08 ± 11%      -0.0        0.07 ±  8%  perf-profile.self.cycles-pp.__sys_sendto
      0.08 ± 20%      -0.0        0.07 ± 20%  perf-profile.self.cycles-pp._writeToClient
      0.08 ± 15%      -0.0        0.06 ± 11%  perf-profile.self.cycles-pp.ep_item_poll
      0.16 ± 12%      -0.0        0.14 ±  9%  perf-profile.self.cycles-pp.call_rcu
      1.00 ± 18%      -0.0        0.98 ±  9%  perf-profile.self.cycles-pp.ktime_get
      0.36 ±  8%      -0.0        0.34 ±  8%  perf-profile.self.cycles-pp.mod_objcg_state
      0.21 ± 10%      -0.0        0.20 ±  9%  perf-profile.self.cycles-pp.mutex_unlock
      0.05 ± 47%      -0.0        0.04 ± 71%  perf-profile.self.cycles-pp.sock_put
      0.17 ± 14%      -0.0        0.16 ± 13%  perf-profile.self.cycles-pp._raw_spin_lock_irq
      0.06 ± 13%      -0.0        0.04 ± 77%  perf-profile.self.cycles-pp.___perf_sw_event
      0.04 ± 72%      -0.0        0.03 ±100%  perf-profile.self.cycles-pp.connSocketEventHandler
      0.12 ±  4%      -0.0        0.10 ± 15%  perf-profile.self.cycles-pp.epoll_wait
      0.06 ± 11%      -0.0        0.04 ± 47%  perf-profile.self.cycles-pp.enqueue_to_backlog
      0.30 ± 28%      -0.0        0.28 ± 29%  perf-profile.self.cycles-pp.__get_user_nocheck_8
      0.35 ± 11%      -0.0        0.34 ±  9%  perf-profile.self.cycles-pp._raw_write_lock_irq
      0.10 ± 19%      -0.0        0.08 ± 17%  perf-profile.self.cycles-pp.__libc_write
      0.16 ± 27%      -0.0        0.15 ± 27%  perf-profile.self.cycles-pp.queue_event
      0.13 ± 14%      -0.0        0.12 ±  8%  perf-profile.self.cycles-pp.__put_user_nocheck_8
      0.11 ± 21%      -0.0        0.10 ± 10%  perf-profile.self.cycles-pp.processInputBuffer
      0.14 ± 12%      -0.0        0.12 ±  8%  perf-profile.self.cycles-pp.string2ll
      0.06 ± 28%      -0.0        0.05 ± 47%  perf-profile.self.cycles-pp.clientHasPendingReplies
      0.07 ± 14%      -0.0        0.06 ± 13%  perf-profile.self.cycles-pp.clock_gettime
      0.03 ±102%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp.__might_fault
      0.07 ± 18%      -0.0        0.06 ± 15%  perf-profile.self.cycles-pp.addReply
      0.03 ±100%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp.inet_recvmsg
      0.04 ± 71%      -0.0        0.02 ± 99%  perf-profile.self.cycles-pp.getMonotonicUs_posix
      0.10 ± 14%      -0.0        0.08 ± 27%  perf-profile.self.cycles-pp.tcp_stream_memory_free
      0.06 ± 47%      -0.0        0.05 ± 46%  perf-profile.self.cycles-pp.rcu_sched_clock_irq
      0.50 ± 10%      -0.0        0.48 ±  9%  perf-profile.self.cycles-pp.sock_rfree
      0.29 ± 11%      -0.0        0.28 ± 11%  perf-profile.self.cycles-pp.hdr_record_values
      0.15 ± 14%      -0.0        0.14 ± 14%  perf-profile.self.cycles-pp.ep_poll
      0.09 ±  7%      -0.0        0.08 ± 16%  perf-profile.self.cycles-pp.ktime_get_ts64
      0.03 ±100%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp.__switch_to_asm
      0.03 ±100%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp.__update_load_avg_se
      0.02 ±141%      -0.0        0.01 ±223%  perf-profile.self.cycles-pp.sdsrange
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.perf_env__arch
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.tcp_mstamp_refresh
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.hi_sdsMakeRoomFor
      0.12 ± 14%      -0.0        0.11 ± 22%  perf-profile.self.cycles-pp.kmem_cache_alloc_node
      0.11 ± 11%      -0.0        0.10 ± 12%  perf-profile.self.cycles-pp.select_estimate_accuracy
      0.02 ± 99%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp._copy_from_user
      0.04 ± 71%      -0.0        0.03 ±100%  perf-profile.self.cycles-pp.prepare_task_switch
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.skb_clone
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.redisBufferRead
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.random
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.__hrtimer_run_queues
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.ip_rcv
      0.02 ±141%      -0.0        0.01 ±223%  perf-profile.self.cycles-pp.cliWriteConn
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.sk_free
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.__netif_receive_skb_one_core
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.perf_event_output_forward
      0.02 ±141%      -0.0        0.01 ±223%  perf-profile.self.cycles-pp.prepareClientToWrite
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.freeReplyObject
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.new_sync_read
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.ftrace_graph_ret_addr
      0.01 ±223%      -0.0        0.00        perf-profile.self.cycles-pp.available_idle_cpu
      0.14 ± 16%      -0.0        0.14 ± 15%  perf-profile.self.cycles-pp.__x64_sys_epoll_ctl
      0.10 ±  9%      -0.0        0.09 ± 15%  perf-profile.self.cycles-pp.tcp_tso_segs
      0.08 ±  8%      -0.0        0.08 ±  9%  perf-profile.self.cycles-pp.hi_sdscatlen
      0.05 ± 48%      -0.0        0.04 ± 45%  perf-profile.self.cycles-pp.__tcp_select_window
      0.47 ± 14%      -0.0        0.46 ± 10%  perf-profile.self.cycles-pp.tcp_queue_rcv
      0.15 ± 30%      -0.0        0.15 ± 34%  perf-profile.self.cycles-pp.deref_stack_reg
      0.11 ± 30%      -0.0        0.10 ± 25%  perf-profile.self.cycles-pp.perf_callchain_kernel
      0.02 ± 99%      -0.0        0.02 ±142%  perf-profile.self.cycles-pp.syscall_exit_to_user_mode_prepare
      0.13 ± 15%      -0.0        0.12 ± 14%  perf-profile.self.cycles-pp.copy_user_generic_unrolled
      0.11 ±  9%      -0.0        0.10 ± 19%  perf-profile.self.cycles-pp.refill_obj_stock
      0.10 ± 14%      -0.0        0.10 ± 10%  perf-profile.self.cycles-pp.irqtime_account_irq
      0.07 ± 23%      -0.0        0.06 ± 11%  perf-profile.self.cycles-pp.handleClientsWithPendingWrites
      0.08 ± 17%      -0.0        0.07 ± 14%  perf-profile.self.cycles-pp.hi_sdsrange
      0.04 ± 72%      -0.0        0.04 ± 71%  perf-profile.self.cycles-pp.perf_tp_event
      0.04 ± 73%      -0.0        0.03 ±100%  perf-profile.self.cycles-pp.__unwind_start
      0.02 ±141%      -0.0        0.01 ±223%  perf-profile.self.cycles-pp.tcp_rate_gen
      0.16 ± 16%      -0.0        0.15 ±  7%  perf-profile.self.cycles-pp.__netif_receive_skb_core
      0.08 ±  7%      -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.__x64_sys_epoll_wait
      0.20 ± 37%      -0.0        0.19 ± 30%  perf-profile.self.cycles-pp.orc_find
      0.51 ± 15%      -0.0        0.51 ± 10%  perf-profile.self.cycles-pp._raw_read_lock_irqsave
      0.26 ± 17%      -0.0        0.25 ± 14%  perf-profile.self.cycles-pp.zfree
      0.19 ± 10%      -0.0        0.18 ±  9%  perf-profile.self.cycles-pp.readHandler
      0.14 ± 14%      -0.0        0.14 ± 15%  perf-profile.self.cycles-pp.tick_nohz_next_event
      0.08 ± 14%      -0.0        0.08 ± 14%  perf-profile.self.cycles-pp.syscall_enter_from_user_mode
      0.07 ± 15%      -0.0        0.06 ±  7%  perf-profile.self.cycles-pp._copy_to_iter
      0.06 ±  7%      -0.0        0.06 ± 15%  perf-profile.self.cycles-pp.__libc_recv
      0.42 ± 31%      -0.0        0.42 ± 30%  perf-profile.self.cycles-pp.__orc_find
      0.10 ± 17%      -0.0        0.09 ± 18%  perf-profile.self.cycles-pp.siphash_nocase
      0.09 ± 21%      -0.0        0.09 ± 17%  perf-profile.self.cycles-pp.tsc_verify_tsc_adjust
      0.09 ±  7%      -0.0        0.09 ± 15%  perf-profile.self.cycles-pp.malloc
      0.04 ± 72%      -0.0        0.04 ± 71%  perf-profile.self.cycles-pp.beforeSleep
      0.13 ± 15%      -0.0        0.13 ± 13%  perf-profile.self.cycles-pp.sock_def_readable
      0.13 ± 26%      -0.0        0.13 ± 10%  perf-profile.self.cycles-pp.je_free
      0.07 ± 47%      -0.0        0.07 ± 48%  perf-profile.self.cycles-pp.evlist__parse_sample
      0.05 ± 46%      -0.0        0.05 ± 45%  perf-profile.self.cycles-pp.__copy_skb_header
      0.36 ±  8%      -0.0        0.36 ±  8%  perf-profile.self.cycles-pp.mutex_lock
      0.13 ± 11%      -0.0        0.12 ± 18%  perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.10 ± 16%      -0.0        0.10 ± 14%  perf-profile.self.cycles-pp.__cond_resched
      0.06 ± 15%      -0.0        0.06 ± 13%  perf-profile.self.cycles-pp.rcu_all_qs
      0.01 ±223%      -0.0        0.01 ±223%  perf-profile.self.cycles-pp.cmp_ex_search
      0.01 ±223%      -0.0        0.01 ±223%  perf-profile.self.cycles-pp.__kernel_text_address
      0.01 ±223%      -0.0        0.01 ±223%  perf-profile.self.cycles-pp.core_kernel_text
      0.11 ± 14%      -0.0        0.11 ± 18%  perf-profile.self.cycles-pp.ip_rcv_core
      0.10 ± 10%      -0.0        0.10 ± 18%  perf-profile.self.cycles-pp.obj_cgroup_charge
      0.09 ± 14%      -0.0        0.09 ± 17%  perf-profile.self.cycles-pp.rcu_segcblist_enqueue
      0.08 ± 11%      -0.0        0.08 ± 17%  perf-profile.self.cycles-pp.ep_remove
      0.07 ± 15%      -0.0        0.07 ± 18%  perf-profile.self.cycles-pp.__list_add_valid
      0.03 ±100%      -0.0        0.03 ±102%  perf-profile.self.cycles-pp.perf_output_begin_forward
      0.05 ± 48%      -0.0        0.05 ± 49%  perf-profile.self.cycles-pp.sock_read_iter
      0.18 ± 21%      -0.0        0.18 ± 12%  perf-profile.self.cycles-pp.__fget_files
      0.16 ± 15%      +0.0        0.16 ± 14%  perf-profile.self.cycles-pp.__softirqentry_text_start
      0.16 ± 17%      +0.0        0.16 ± 11%  perf-profile.self.cycles-pp.process_backlog
      0.13 ±  8%      +0.0        0.13 ± 12%  perf-profile.self.cycles-pp.rb_erase
      0.08 ± 16%      +0.0        0.08 ± 10%  perf-profile.self.cycles-pp._addReplyToBufferOrList
      0.05 ± 47%      +0.0        0.05 ± 51%  perf-profile.self.cycles-pp.__intel_pmu_enable_all
      0.07 ± 11%      +0.0        0.07 ± 11%  perf-profile.self.cycles-pp.loopback_xmit
      0.06 ± 46%      +0.0        0.06 ± 13%  perf-profile.self.cycles-pp.error_entry
      0.06 ± 17%      +0.0        0.06 ± 14%  perf-profile.self.cycles-pp.addReplyOrErrorObject
      0.04 ± 71%      +0.0        0.04 ± 71%  perf-profile.self.cycles-pp.ACLCheckAllUserCommandPerm
      0.01 ±223%      +0.0        0.01 ±223%  perf-profile.self.cycles-pp.hrtimer_interrupt
      0.01 ±223%      +0.0        0.01 ±223%  perf-profile.self.cycles-pp.ep_unregister_pollwait
      0.05 ± 73%      +0.0        0.05 ± 46%  perf-profile.self.cycles-pp.update_load_avg
      0.02 ± 99%      +0.0        0.02 ± 99%  perf-profile.self.cycles-pp.__update_load_avg_cfs_rq
      0.02 ±141%      +0.0        0.02 ±144%  perf-profile.self.cycles-pp.__task_pid_nr_ns
      0.01 ±223%      +0.0        0.01 ±223%  perf-profile.self.cycles-pp.unwind_get_return_address
      0.01 ±223%      +0.0        0.01 ±223%  perf-profile.self.cycles-pp.reweight_entity
      0.01 ±223%      +0.0        0.01 ±223%  perf-profile.self.cycles-pp.tcp_established_options
      0.01 ±223%      +0.0        0.01 ±223%  perf-profile.self.cycles-pp.__wake_up_common_lock
      0.01 ±223%      +0.0        0.01 ±223%  perf-profile.self.cycles-pp.get_perf_callchain
      0.09 ± 25%      +0.0        0.10 ± 13%  perf-profile.self.cycles-pp.decrRefCount
      0.11 ± 14%      +0.0        0.11 ± 15%  perf-profile.self.cycles-pp.apparmor_file_permission
      0.07 ± 18%      +0.0        0.07 ± 15%  perf-profile.self.cycles-pp.resetClient
      0.04 ± 72%      +0.0        0.04 ± 72%  perf-profile.self.cycles-pp.do_idle
      0.05 ± 72%      +0.0        0.06 ± 51%  perf-profile.self.cycles-pp.update_rq_clock
      0.02 ±141%      +0.0        0.02 ±142%  perf-profile.self.cycles-pp.idle_cpu
      0.04 ± 71%      +0.0        0.04 ± 72%  perf-profile.self.cycles-pp.__switch_to
      0.18 ± 32%      +0.0        0.18 ± 27%  perf-profile.self.cycles-pp.memcpy_erms
      0.08 ± 22%      +0.0        0.08 ±  6%  perf-profile.self.cycles-pp.__libc_read
      0.14 ± 11%      +0.0        0.14 ± 13%  perf-profile.self.cycles-pp.tcp_stream_alloc_skb
      0.07 ± 15%      +0.0        0.07 ± 12%  perf-profile.self.cycles-pp.exit_to_user_mode_prepare
      0.09 ± 18%      +0.0        0.09 ± 19%  perf-profile.self.cycles-pp.siphash
      0.14 ± 50%      +0.0        0.14 ± 24%  perf-profile.self.cycles-pp.evsel__parse_sample
      0.02 ± 99%      +0.0        0.03 ±100%  perf-profile.self.cycles-pp.sched_clock_cpu
      0.03 ±105%      +0.0        0.03 ±101%  perf-profile.self.cycles-pp.kernel_text_address
      0.07 ± 10%      +0.0        0.08 ± 16%  perf-profile.self.cycles-pp.tcp_sendmsg
      0.40 ± 11%      +0.0        0.40 ±  9%  perf-profile.self.cycles-pp.__skb_datagram_iter
      0.05 ± 71%      +0.0        0.05 ± 49%  perf-profile.self.cycles-pp.perf_output_sample
      0.01 ±223%      +0.0        0.02 ±141%  perf-profile.self.cycles-pp.connSocketWrite
      0.09 ± 24%      +0.0        0.09 ±  9%  perf-profile.self.cycles-pp.createEmbeddedStringObject
      0.28 ± 13%      +0.0        0.29 ± 11%  perf-profile.self.cycles-pp.__kmalloc_node_track_caller
      0.09 ± 29%      +0.0        0.10 ± 35%  perf-profile.self.cycles-pp.__schedule
      0.02 ±142%      +0.0        0.03 ±100%  perf-profile.self.cycles-pp.enqueue_entity
      0.08 ± 20%      +0.0        0.08 ± 20%  perf-profile.self.cycles-pp.aeCreateFileEvent
      0.04 ± 73%      +0.0        0.05 ± 50%  perf-profile.self.cycles-pp.queued_write_lock_slowpath
      0.11 ±  9%      +0.0        0.12 ±  8%  perf-profile.self.cycles-pp.tcp_schedule_loss_probe
      0.04 ± 71%      +0.0        0.04 ± 73%  perf-profile.self.cycles-pp.cpuidle_idle_call
      0.01 ±223%      +0.0        0.02 ±142%  perf-profile.self.cycles-pp.handle_pte_fault
      0.01 ±223%      +0.0        0.02 ±141%  perf-profile.self.cycles-pp.raw_local_deliver
      0.00            +0.0        0.01 ±223%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.00            +0.0        0.01 ±223%  perf-profile.self.cycles-pp.free_pcp_prepare
      0.00            +0.0        0.01 ±223%  perf-profile.self.cycles-pp.__handle_mm_fault
      0.00            +0.0        0.01 ±223%  perf-profile.self.cycles-pp.select_task_rq
      0.00            +0.0        0.01 ±223%  perf-profile.self.cycles-pp.rb_next
      0.04 ± 73%      +0.0        0.05 ± 48%  perf-profile.self.cycles-pp.listNext
      0.02 ±141%      +0.0        0.02 ± 99%  perf-profile.self.cycles-pp.ip_skb_dst_mtu
      0.01 ±223%      +0.0        0.02 ±142%  perf-profile.self.cycles-pp.__sys_recvfrom
      0.05 ± 45%      +0.0        0.06 ± 14%  perf-profile.self.cycles-pp.tcp_rate_skb_delivered
      0.08 ± 18%      +0.0        0.10 ± 15%  perf-profile.self.cycles-pp.update_sg_lb_stats
      0.04 ± 71%      +0.0        0.05 ± 47%  perf-profile.self.cycles-pp.createStringObject
      0.02 ±143%      +0.0        0.04 ± 71%  perf-profile.self.cycles-pp.update_process_times
      0.10 ± 56%      +0.0        0.11 ± 37%  perf-profile.self.cycles-pp.tick_sched_do_timer
      0.19 ± 19%      +0.0        0.20 ± 13%  perf-profile.self.cycles-pp.__list_del_entry_valid
      0.04 ± 71%      +0.0        0.06 ±  8%  perf-profile.self.cycles-pp.redisReaderFeed
      0.03 ±102%      +0.0        0.04 ± 45%  perf-profile.self.cycles-pp.ksys_write
      0.01 ±223%      +0.0        0.02 ± 99%  perf-profile.self.cycles-pp.update_irq_load_avg
      0.00            +0.0        0.02 ±141%  perf-profile.self.cycles-pp.switch_mm_irqs_off
      0.01 ±223%      +0.0        0.02 ± 99%  perf-profile.self.cycles-pp.tcp_send_mss
      0.03 ±100%      +0.0        0.04 ± 45%  perf-profile.self.cycles-pp.tcp_rate_skb_sent
      0.00            +0.0        0.02 ±142%  perf-profile.self.cycles-pp.do_epoll_wait
      0.00            +0.0        0.02 ±142%  perf-profile.self.cycles-pp.__hrtimer_next_event_base
      0.14 ± 12%      +0.0        0.16 ±  8%  perf-profile.self.cycles-pp.tcp_rcv_space_adjust
      0.08 ± 14%      +0.0        0.10 ±  5%  perf-profile.self.cycles-pp._raw_spin_unlock_irqrestore
      0.28 ± 26%      +0.0        0.30 ± 25%  perf-profile.self.cycles-pp.menu_select
      0.46 ± 11%      +0.0        0.48 ±  7%  perf-profile.self.cycles-pp.__tcp_transmit_skb
      0.13 ± 13%      +0.0        0.15 ± 17%  perf-profile.self.cycles-pp._copy_from_iter
      0.08 ± 16%      +0.0        0.10 ± 11%  perf-profile.self.cycles-pp.__virt_addr_valid
      0.38 ±  6%      +0.0        0.41 ± 10%  perf-profile.self.cycles-pp._raw_spin_lock
      0.00            +0.0        0.03 ±100%  perf-profile.self.cycles-pp.tcp_data_ready
      0.00            +0.0        0.03 ±102%  perf-profile.self.cycles-pp.nr_iowait_cpu
      0.09 ± 17%      +0.0        0.12 ± 20%  perf-profile.self.cycles-pp.rcu_cblist_dequeue
      0.10 ± 16%      +0.0        0.13 ±223%  perf-profile.self.cycles-pp.dst_release
      0.02 ±142%      +0.0        0.05 ±223%  perf-profile.self.cycles-pp.skb_release_head_state
      0.10 ±141%      +0.0        0.13 ±100%  perf-profile.self.cycles-pp.irqentry_exit_to_user_mode
      0.00            +0.0        0.04 ± 44%  perf-profile.self.cycles-pp.setup_object
      0.03 ±147%      +0.0        0.07 ± 23%  perf-profile.self.cycles-pp.io_serial_in
      0.17 ± 14%      +0.0        0.21 ± 79%  perf-profile.self.cycles-pp.net_rx_action
      0.14 ± 22%      +0.0        0.19 ±  4%  perf-profile.self.cycles-pp.ip_send_check
      0.02 ±142%      +0.1        0.07 ± 47%  perf-profile.self.cycles-pp.kfree_skbmem
      0.12 ± 21%      +0.1        0.18 ± 10%  perf-profile.self.cycles-pp.tcp_skb_entail
      0.00            +0.1        0.07 ± 15%  perf-profile.self.cycles-pp.tcp_chrono_start
      0.89 ±  8%      +0.1        0.96 ± 10%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.01 ±223%      +0.1        0.08 ± 91%  perf-profile.self.cycles-pp.ktime_get_update_offsets_now
      0.82 ± 17%      +0.1        0.90 ± 11%  perf-profile.self.cycles-pp.lookupKey
      3.30 ± 18%      +0.1        3.40 ± 10%  perf-profile.self.cycles-pp.dictFind
      0.35 ± 12%      +0.1        0.44 ± 14%  perf-profile.self.cycles-pp.__skb_clone
      0.28 ±  8%      +0.1        0.42 ± 14%  perf-profile.self.cycles-pp.__ip_queue_xmit
      0.27 ±  8%      +0.2        0.44 ± 13%  perf-profile.self.cycles-pp.__check_object_size
      0.28 ± 12%      +0.2        0.46 ± 11%  perf-profile.self.cycles-pp.tcp_recvmsg_locked
      0.21 ± 12%      +0.2        0.41 ± 13%  perf-profile.self.cycles-pp.__alloc_skb
      0.00            +0.2        0.25 ± 19%  perf-profile.self.cycles-pp.allocate_slab
      0.00            +0.3        0.25 ± 12%  perf-profile.self.cycles-pp.tcp_cleanup_rbuf
      0.46 ± 14%      +0.3        0.75 ± 12%  perf-profile.self.cycles-pp.__dev_queue_xmit
      1.21 ± 12%      +0.3        1.54 ± 11%  perf-profile.self.cycles-pp.tcp_sendmsg_locked
     33.02 ± 20%      +0.6       33.67 ± 22%  perf-profile.self.cycles-pp.mwait_idle_with_hints
      2.48 ±136%      +1.1        3.54 ± 98%  perf-profile.self.cycles-pp.syscall_exit_to_user_mode
      0.53 ± 34%      +1.3        1.82 ±101%  perf-profile.self.cycles-pp.poll_idle




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



--eG5Q/vRJnZo6MKIs
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-5.18.0-rc3-00616-g68822bdf76f1"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.18.0-rc3 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-8) 11.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=110300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23990
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23990
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=125
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
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
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

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
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
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
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
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_BPF is not set
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
# CONFIG_CHECKPOINT_RESTORE is not set
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
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
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
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_GUEST_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLAB_FREELIST_HARDENED is not set
CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
CONFIG_SLUB_CPU_PARTIAL=y
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
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
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
CONFIG_RETPOLINE=y
CONFIG_CC_HAS_SLS=y
# CONFIG_SLS is not set
# CONFIG_X86_CPU_RESCTRL is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
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
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# CONFIG_PERF_EVENTS_AMD_UNCORE is not set
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
# CONFIG_AMD_MEM_ENCRYPT is not set
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
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
CONFIG_X86_KERNEL_IBT=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
# CONFIG_X86_SGX is not set
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
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
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
# CONFIG_PMIC_OPREGION is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_PRMT=y

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
CONFIG_X86_ACPI_CPUFREQ_CPB=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
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
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32_ABI is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
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
CONFIG_KVM_INTEL=m
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
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_CONTEXT_TRACKING_OFFSTACK=y
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
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
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

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# CONFIG_GCC_PLUGIN_RANDSTRUCT is not set
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
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
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
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
CONFIG_MEMORY_HOTPLUG=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
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
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
CONFIG_ZSWAP=y
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
# CONFIG_ZSWAP_DEFAULT_ON is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DEVICE=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_SECRETMEM=y
# CONFIG_ANON_VMA_NAME is not set

#
# Data Access Monitoring
#
# CONFIG_DAMON is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
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
# CONFIG_NET_KEY is not set
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
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
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
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_IPV6_RPL_LWTUNNEL is not set
# CONFIG_IPV6_IOAM6_LWTUNNEL is not set
CONFIG_NETLABEL=y
# CONFIG_MPTCP is not set
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
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
# CONFIG_NFT_REJECT_NETDEV is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XTABLES_COMPAT=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m

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

# CONFIG_IP_SET is not set
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
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y
# end of DCCP CCIDs Configuration

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# end of DCCP Kernel Hacking

CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
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
# CONFIG_NET_SCH_FQ_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
# CONFIG_NET_SCH_ETS is not set
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
# CONFIG_DEFAULT_CODEL is not set
CONFIG_DEFAULT_FQ_CODEL=y
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
# CONFIG_NET_EMATCH_CANID is not set
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_MPLS is not set
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
# CONFIG_NET_ACT_CONNMARK is not set
# CONFIG_NET_ACT_CTINFO is not set
CONFIG_NET_ACT_SKBMOD=m
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
# CONFIG_NET_ACT_GATE is not set
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
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

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

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
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
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
CONFIG_PCI_HYPERV=m
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
CONFIG_PCI_HYPERV_INTERFACE=m

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
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
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
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
# CONFIG_APPLE_PROPERTIES is not set
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y

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
# CONFIG_ZRAM is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_VERBOSE_ERRORS is not set
# CONFIG_NVME_HWMON is not set
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TCP is not set
# CONFIG_NVME_TARGET is not set
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
# CONFIG_SGI_XP is not set
CONFIG_HP_ILO=m
# CONFIG_SGI_GRU is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
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

# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

# CONFIG_SENSORS_LIS3_I2C is not set
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_HDCP is not set
# CONFIG_INTEL_MEI_PXP is not set
# CONFIG_VMWARE_VMCI is not set
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
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
# CONFIG_SCSI_DPT_I2O is not set
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
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_HYPERV_STORAGE=m
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
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
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
# CONFIG_TARGET_CORE is not set
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
# CONFIG_DUMMY is not set
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
# CONFIG_BAREUDP is not set
# CONFIG_GTP is not set
# CONFIG_AMT is not set
# CONFIG_MACSEC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_NET_VRF is not set
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
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
# CONFIG_MICROSOFT_MANA is not set
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
# CONFIG_VXGE is not set
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
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set
CONFIG_FIXED_PHY=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
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
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
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
# CONFIG_PCS_XPCS is not set
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
# CONFIG_WLAN is not set
# CONFIG_WAN is not set

#
# Wireless WAN
#
# CONFIG_WWAN is not set
# end of Wireless WAN

# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
CONFIG_HYPERV_NET=y
# CONFIG_NETDEVSIM is not set
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
CONFIG_HYPERV_KEYBOARD=m
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
# CONFIG_SERIAL_JSM is not set
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
# CONFIG_TCG_TIS_I2C_CR50 is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set
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
CONFIG_I2C_SMBUS=y
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
CONFIG_I2C_I801=y
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
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_VIRTIO is not set
# CONFIG_GPIO_SIM is not set
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
CONFIG_SENSORS_ADM1021=m
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
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
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
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
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
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
# CONFIG_SENSORS_NZXT_SMART2 is not set
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
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
# CONFIG_BCMA is not set

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
CONFIG_LPC_ICH=y
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
CONFIG_RC_CORE=m
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
# CONFIG_IR_SHARP_DECODER is not set
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
# CONFIG_RC_LOOPBACK is not set
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

CONFIG_MEDIA_HIDE_ANCILLARY_SUBDRV=y

#
# Media ancillary drivers
#
# end of Media ancillary drivers

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DEBUG_SELFTEST is not set
CONFIG_DRM_DP_HELPER=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_BUDDY=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=m

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
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
# CONFIG_DRM_I915_GVT is not set
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# CONFIG_DRM_VGEM is not set
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
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
# CONFIG_DRM_HYPERV is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_NOMODESET=y
CONFIG_DRM_PRIVACY_SCREEN=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
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
CONFIG_FB_HYPERV=m
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
CONFIG_HID_HYPERV_MOUSE=m
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
# CONFIG_INTEL_ISH_HID is not set
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
# CONFIG_USB_SERIAL is not set

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
# CONFIG_TYPEC_TPS6598X is not set
# CONFIG_TYPEC_RT1719 is not set
# CONFIG_TYPEC_STUSB160X is not set
# CONFIG_TYPEC_WUSB3801 is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
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
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
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
CONFIG_LEDS_CLEVO_MAIL=m
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
# CONFIG_SW_SYNC is not set
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
# CONFIG_DMABUF_SYSFS_STATS is not set
# end of DMABUF options

CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
# CONFIG_UIO is not set
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
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
# CONFIG_STAGING is not set
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
# CONFIG_AMD_HSMP is not set
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
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
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
# CONFIG_HWSPINLOCK is not set

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
CONFIG_HYPERV_IOMMU=y
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
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
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
# CONFIG_ANDROID is not set
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
# CONFIG_STM is not set
CONFIG_INTEL_TH=y
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=y
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# CONFIG_PECI is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
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
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
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
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
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
# CONFIG_FSCACHE is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
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
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_HUGETLB_PAGE_FREE_VMEMMAP=y
# CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON is not set
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
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
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
# CONFIG_CEPH_FS is not set
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
# CONFIG_DLM is not set
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
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
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
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
# CONFIG_IMA is not set
# CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
# CONFIG_ZERO_CALL_USED_REGS is not set
# end of Memory initialization
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
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
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
CONFIG_CRYPTO_OFB=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
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
# CONFIG_CRYPTO_BLAKE2S is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_CRC64_ROCKSOFT=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
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
# CONFIG_CRYPTO_SM3 is not set
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
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_SM4=m
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
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

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
# CONFIG_PRIME_NUMBERS is not set
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
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_LIB_SM4=m
# end of Crypto library routines

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
CONFIG_SWIOTLB=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
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
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_STACK_VALIDATION=y
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
# CONFIG_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_HAVE_KCSAN_COMPILER=y
# CONFIG_KCSAN is not set
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set
# end of Networking Debugging

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_TABLE_CHECK is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
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
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
# CONFIG_KASAN is not set
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
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
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
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
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
# CONFIG_FPROBE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_OSNOISE_TRACER is not set
# CONFIG_TIMERLAT_TRACER is not set
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_BPF_KPROBE_OVERRIDE=y
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
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
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
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
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
# CONFIG_TEST_STRSCPY is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
# CONFIG_TEST_SCANF is not set
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_SIPHASH is not set
# CONFIG_TEST_IDA is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_BITOPS is not set
# CONFIG_TEST_VMALLOC is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_TEST_BLACKHOLE_DEV is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_TEST_KMOD is not set
# CONFIG_TEST_MEMCAT_P is not set
# CONFIG_TEST_LIVEPATCH is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_TEST_HMM is not set
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
# CONFIG_TEST_CLOCKSOURCE_WATCHDOG is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--eG5Q/vRJnZo6MKIs
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job-script"

#!/bin/sh

export_top_env()
{
	export suite='redis'
	export testcase='redis'
	export category='benchmark'
	export need_memory='135G'
	export nr_threads=96
	export cluster='cs-localhost'
	export cpu_node_bind='even'
	export nr_processes=4
	export job_origin='redis.yaml'
	export queue_cmdline_keys='branch
commit
kbuild_queue_analysis'
	export queue='validate'
	export testbox='lkp-csl-2sp7'
	export tbox_group='lkp-csl-2sp7'
	export branch='linus/master'
	export commit='68822bdf76f10c3dc80609d4e2cdc1e847429086'
	export submit_id='643f4dfef00a5708d4c8f75a'
	export job_file='/lkp/jobs/scheduled/lkp-csl-2sp7/redis-1-cs-localhost-even-performance-1024-68000000-5-3-4-68000000-1-65535-set_get-never-never-debian-11.1-x86_64-20220510.cgz-6-20230419-67796-3pphdm-4.yaml'
	export id='e5fd439ed692783ca4ed2c8ead4d91dd39b28f05'
	export queuer_version='/zday/lkp'
	export model='Cascade Lake'
	export nr_node=2
	export nr_cpu=96
	export memory='512G'
	export nr_hdd_partitions=1
	export nr_ssd_partitions=1
	export hdd_partitions='/dev/disk/by-id/ata-ST1000NM0055-1V410C_ZBS1K5E0-part1'
	export ssd_partitions='/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4204000G800RGN-part1'
	export swap_partitions=
	export rootfs_partition='/dev/disk/by-id/ata-ST1000NM0055-1V410C_ZBS1K5E0-part2'
	export brand='Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz'
	export ucode='0x5003302'
	export need_kconfig_hw='{"I40E"=>"y"}
SATA_AHCI'
	export rootfs='debian-11.1-x86_64-20220510.cgz'
	export kconfig='x86_64-rhel-8.3'
	export enqueue_time='2023-04-19 10:12:15 +0800'
	export compiler='gcc-11'
	export _id='643f4e19f00a5708d4c8f75b'
	export _rt='/result/redis/1-cs-localhost-even-performance-1024-68000000-5-3-4-68000000-1-65535-set_get-never-never/lkp-csl-2sp7/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086'
	export user='lkp'
	export LKP_SERVER='internal-lkp-server'
	export result_root='/result/redis/1-cs-localhost-even-performance-1024-68000000-5-3-4-68000000-1-65535-set_get-never-never/lkp-csl-2sp7/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086/3'
	export scheduler_version='/lkp/lkp/.src-20230418-100632'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-11.1-x86_64-20220510.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/redis/1-cs-localhost-even-performance-1024-68000000-5-3-4-68000000-1-65535-set_get-never-never/lkp-csl-2sp7/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086/3
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086/vmlinuz-5.18.0-rc3-00616-g68822bdf76f1
branch=linus/master
job=/lkp/jobs/scheduled/lkp-csl-2sp7/redis-1-cs-localhost-even-performance-1024-68000000-5-3-4-68000000-1-65535-set_get-never-never-debian-11.1-x86_64-20220510.cgz-6-20230419-67796-3pphdm-4.yaml
user=lkp
ARCH=x86_64
kconfig=x86_64-rhel-8.3
commit=68822bdf76f10c3dc80609d4e2cdc1e847429086
initcall_debug
nmi_watchdog=0
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
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086/modules.cgz'
	export bm_initrd='/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/numactl_20220516.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/redis-server-x86_64-7.0.9-0_20230404.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/mpstat_20220516.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/turbostat_20220514.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/turbostat-x86_64-210e04ff7681-1_20220518.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/perf_20230402.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/perf-x86_64-00c7b5f4ddc5-1_20230402.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/sar-x86_64-c5bb321-1_20220518.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20220804.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='5.18.0-rc3-00739-gbe5fd933f8c1'
	export repeat_to=6
	export schedule_notify_address=
	export kbuild_queue_analysis=1
	export kernel='/pkg/linux/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086/vmlinuz-5.18.0-rc3-00616-g68822bdf76f1'
	export dequeue_time='2023-04-19 10:19:56 +0800'
	export job_state='downgrade_ucode'
	export node_roles='server client'
	export job_initrd='/lkp/jobs/scheduled/lkp-csl-2sp7/redis-1-cs-localhost-even-performance-1024-68000000-5-3-4-68000000-1-65535-set_get-never-never-debian-11.1-x86_64-20220510.cgz-6-20230419-67796-3pphdm-4.cgz'

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

	run_setup all=1 $LKP_SRC/setup/numactl

	run_setup sc_overcommit_memory=1 sc_somaxconn=65535 $LKP_SRC/setup/sysctl

	run_setup thp_enabled='never' thp_defrag='never' $LKP_SRC/setup/transparent_hugepage

	run_setup $LKP_SRC/setup/cpufreq_governor 'performance'

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper boot-time
	run_monitor $LKP_SRC/monitors/wrapper uptime
	run_monitor $LKP_SRC/monitors/wrapper iostat
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-numastat
	run_monitor $LKP_SRC/monitors/wrapper numa-vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-meminfo
	run_monitor $LKP_SRC/monitors/wrapper proc-vmstat
	run_monitor $LKP_SRC/monitors/wrapper proc-stat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper slabinfo
	run_monitor $LKP_SRC/monitors/wrapper interrupts
	run_monitor $LKP_SRC/monitors/wrapper lock_stat
	run_monitor lite_mode=1 $LKP_SRC/monitors/wrapper perf-sched
	run_monitor $LKP_SRC/monitors/wrapper softirqs
	run_monitor $LKP_SRC/monitors/one-shot/wrapper bdi_dev_mapping
	run_monitor $LKP_SRC/monitors/wrapper diskstats
	run_monitor $LKP_SRC/monitors/wrapper nfsstat
	run_monitor $LKP_SRC/monitors/wrapper cpuidle
	run_monitor $LKP_SRC/monitors/wrapper cpufreq-stats
	run_monitor $LKP_SRC/monitors/wrapper turbostat
	run_monitor $LKP_SRC/monitors/wrapper sched_debug
	run_monitor $LKP_SRC/monitors/wrapper perf-stat
	run_monitor $LKP_SRC/monitors/wrapper mpstat
	run_monitor debug_mode=0 $LKP_SRC/monitors/no-stdout/wrapper perf-profile
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	if role server
	then
		start_daemon $LKP_SRC/daemon/wrapper redis-server
	fi

	if role client
	then
		run_test test='set,get' data_size=1024 n_client=5 requests=68000000 n_pipeline=3 key_len=68000000 $LKP_SRC/tests/wrapper redis
	fi
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env test='set,get' data_size=1024 n_client=5 requests=68000000 n_pipeline=3 key_len=68000000 $LKP_SRC/stats/wrapper redis
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper boot-time
	$LKP_SRC/stats/wrapper uptime
	$LKP_SRC/stats/wrapper iostat
	$LKP_SRC/stats/wrapper vmstat
	$LKP_SRC/stats/wrapper numa-numastat
	$LKP_SRC/stats/wrapper numa-vmstat
	$LKP_SRC/stats/wrapper numa-meminfo
	$LKP_SRC/stats/wrapper proc-vmstat
	$LKP_SRC/stats/wrapper meminfo
	$LKP_SRC/stats/wrapper slabinfo
	$LKP_SRC/stats/wrapper interrupts
	$LKP_SRC/stats/wrapper lock_stat
	env lite_mode=1 $LKP_SRC/stats/wrapper perf-sched
	$LKP_SRC/stats/wrapper softirqs
	$LKP_SRC/stats/wrapper diskstats
	$LKP_SRC/stats/wrapper nfsstat
	$LKP_SRC/stats/wrapper cpuidle
	$LKP_SRC/stats/wrapper turbostat
	$LKP_SRC/stats/wrapper sched_debug
	$LKP_SRC/stats/wrapper perf-stat
	$LKP_SRC/stats/wrapper mpstat
	env debug_mode=0 $LKP_SRC/stats/wrapper perf-profile

	$LKP_SRC/stats/wrapper time redis.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--eG5Q/vRJnZo6MKIs
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job.yaml"

---

#! /lkp/lkp/src/jobs/redis.yaml
suite: redis
testcase: redis
category: benchmark
need_memory: 135G
nr_threads: 100%
numactl:
  all: 1
sysctl:
  sc_overcommit_memory: 1
  sc_somaxconn: 65535
transparent_hugepage:
  thp_enabled: never
  thp_defrag: never
cluster: cs-localhost
cpu_node_bind: even
nr_processes: 4
if role server:
  redis-server:
if role client:
  redis:
    test: set,get
    data_size: 1024
    n_client: 5
    requests: 68000000
    n_pipeline: 3
    key_len: 68000000
job_origin: redis.yaml

#! queue options
queue_cmdline_keys:
- branch
- commit
- kbuild_queue_analysis
queue: bisect
testbox: lkp-csl-2sp7
tbox_group: lkp-csl-2sp7
branch: linus/master
commit: 68822bdf76f10c3dc80609d4e2cdc1e847429086
submit_id: 643ee867f00a57b3ddce9969
job_file: "/lkp/jobs/scheduled/lkp-csl-2sp7/redis-1-cs-localhost-even-performance-1024-68000000-5-3-4-68000000-1-65535-set_get-never-never-debian-11.1-x86_64-20220510.cgz-6-20230419-46045-qm2t77-1.yaml"
id: cf45ba136f3fb8d6066832422e6c28b5640aaa04
queuer_version: "/zday/lkp"

#! hosts/lkp-csl-2sp7
model: Cascade Lake
nr_node: 2
nr_cpu: 96
memory: 512G
nr_hdd_partitions: 1
nr_ssd_partitions: 1
hdd_partitions: "/dev/disk/by-id/ata-ST1000NM0055-1V410C_ZBS1K5E0-part1"
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4204000G800RGN-part1"
swap_partitions:
rootfs_partition: "/dev/disk/by-id/ata-ST1000NM0055-1V410C_ZBS1K5E0-part2"
brand: Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz

#! include/category/benchmark
kmsg:
boot-time:
uptime:
iostat:
heartbeat:
vmstat:
numa-numastat:
numa-vmstat:
numa-meminfo:
proc-vmstat:
proc-stat:
meminfo:
slabinfo:
interrupts:
lock_stat:
perf-sched:
  lite_mode: 1
softirqs:
bdi_dev_mapping:
diskstats:
nfsstat:
cpuidle:
cpufreq-stats:
turbostat:
sched_debug:
perf-stat:
mpstat:
perf-profile:
  debug_mode: 0

#! include/category/ALL
cpufreq_governor: performance

#! include/testbox/lkp-csl-2sp7
ucode: '0x5003302'
need_kconfig_hw:
- I40E: y
- SATA_AHCI
rootfs: debian-11.1-x86_64-20220510.cgz
kconfig: x86_64-rhel-8.3
enqueue_time: 2023-04-19 02:58:47.923465668 +08:00
compiler: gcc-11
_id: 643ef4f5f00a57b3ddce996a
_rt: "/result/redis/1-cs-localhost-even-performance-1024-68000000-5-3-4-68000000-1-65535-set_get-never-never/lkp-csl-2sp7/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086"

#! schedule options
user: lkp
LKP_SERVER: internal-lkp-server
result_root: "/result/redis/1-cs-localhost-even-performance-1024-68000000-5-3-4-68000000-1-65535-set_get-never-never/lkp-csl-2sp7/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086/0"
scheduler_version: "/lkp/lkp/.src-20230418-100632"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-11.1-x86_64-20220510.cgz"
bootloader_append:
- root=/dev/ram0
- RESULT_ROOT=/result/redis/1-cs-localhost-even-performance-1024-68000000-5-3-4-68000000-1-65535-set_get-never-never/lkp-csl-2sp7/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086/0
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086/vmlinuz-5.18.0-rc3-00616-g68822bdf76f1
- branch=linus/master
- job=/lkp/jobs/scheduled/lkp-csl-2sp7/redis-1-cs-localhost-even-performance-1024-68000000-5-3-4-68000000-1-65535-set_get-never-never-debian-11.1-x86_64-20220510.cgz-6-20230419-46045-qm2t77-1.yaml
- user=lkp
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3
- commit=68822bdf76f10c3dc80609d4e2cdc1e847429086
- initcall_debug
- nmi_watchdog=0
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
modules_initrd: "/pkg/linux/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086/modules.cgz"
bm_initrd: "/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/numactl_20220516.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/redis-server-x86_64-7.0.9-0_20230404.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/mpstat_20220516.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/turbostat_20220514.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/turbostat-x86_64-210e04ff7681-1_20220518.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/perf_20230402.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/perf-x86_64-00c7b5f4ddc5-1_20230402.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/sar-x86_64-c5bb321-1_20220518.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20220804.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /db/releases/20230406163540/lkp-src/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer:
watchdog:
last_kernel: 4.20.0

#! /db/releases/20230407192341/lkp-src/include/site/inn
repeat_to: 3
schedule_notify_address:

#! user overrides
kbuild_queue_analysis: 1
kernel: "/pkg/linux/x86_64-rhel-8.3/gcc-11/68822bdf76f10c3dc80609d4e2cdc1e847429086/vmlinuz-5.18.0-rc3-00616-g68822bdf76f1"
dequeue_time: 2023-04-19 04:03:06.102233377 +08:00

#! /db/releases/20230418152252/lkp-src/include/site/inn
job_state: finished

#! /cephfs/db/releases/20230418152252/lkp-src/include/site/inn
loadavg: 6.25 2.91 1.12 3/887 9814
start_time: '1681848265'
end_time: '1681848399'
version: "/lkp/lkp/.src-20230418-100721:cddf3b4aa638:3da9117cc73f"

--eG5Q/vRJnZo6MKIs
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="reproduce"

echo '1' > '/proc/sys/vm/overcommit_memory'
echo '65535' > '/proc/sys/net/core/somaxconn'
echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled
echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag

for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*
do
	online_file="$cpu_dir"/online
	[ -f "$online_file" ] && [ "$(cat "$online_file")" -eq 0 ] && continue

	file="$cpu_dir"/cpufreq/scaling_governor
	[ -f "$file" ] && echo "performance" > "$file"
done

numactl  --cpunodebind=1  -- /lkp/benchmarks/redis/bin/redis-server --port 6381 --save "" &
numactl  --cpunodebind=0  -- /lkp/benchmarks/redis/bin/redis-server --port 6382 --save "" &
numactl  --cpunodebind=1  -- /lkp/benchmarks/redis/bin/redis-server --port 6383 --save "" &
numactl  --cpunodebind=0  -- /lkp/benchmarks/redis/bin/redis-server --port 6384 --save "" &
/usr/bin/numactl  --all -- numactl --cpunodebind=1 -- redis-benchmark -r 17000000 -n 17000000 -t set,get -d 1024 -c 5 -P 3 -p 6381
/usr/bin/numactl  --all -- numactl --cpunodebind=0 -- redis-benchmark -r 17000000 -n 17000000 -t set,get -d 1024 -c 5 -P 3 -p 6382
/usr/bin/numactl  --all -- numactl --cpunodebind=1 -- redis-benchmark -r 17000000 -n 17000000 -t set,get -d 1024 -c 5 -P 3 -p 6383
/usr/bin/numactl  --all -- numactl --cpunodebind=0 -- redis-benchmark -r 17000000 -n 17000000 -t set,get -d 1024 -c 5 -P 3 -p 6384

--eG5Q/vRJnZo6MKIs--
