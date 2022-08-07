Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A945B58BA01
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 09:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbiHGHVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 03:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiHGHVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 03:21:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0CD2DF4;
        Sun,  7 Aug 2022 00:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659856870; x=1691392870;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=8FzqpNTz65mBf/p2JzOOl1lO4taPPvQ9t/gcgJVKL7s=;
  b=cVxdiPteHCjydUjgpW39rTb8faY8UB1ILWakv2YTEJn3an/kQKEPt3DR
   aX5/Ly18ZipsyvrX7tkDR0IazN0iTXlgbR2U8Ei/lu4EUNEQj5ipg7xHg
   RCoyDwPvpV9e8VpfKYahQNEEybRD38PICDTRdBGmjs+XYZqOztBpZ4nAu
   1UL45+672dpy7jRAXP9kXMyN2qs3jLNHsu1wMafU+QSiQyp5hPFwshB4S
   Wsa4EmObfb+s6Ufp7LEsSHCcqKbP+bHHPATd1BzIkyJeAkV+R9m5roa5s
   sPAfW+i+hcrFvDfV+dvVmvVKRQ3G1LHHRfKsl5LoMydk79qRVWmvmxvWb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10431"; a="290425929"
X-IronPort-AV: E=Sophos;i="5.93,219,1654585200"; 
   d="xz'?scan'208";a="290425929"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 00:21:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,219,1654585200"; 
   d="xz'?scan'208";a="600761994"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga007.jf.intel.com with ESMTP; 07 Aug 2022 00:21:09 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Sun, 7 Aug 2022 00:21:09 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Sun, 7 Aug 2022 00:21:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Sun, 7 Aug 2022 00:21:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Sun, 7 Aug 2022 00:21:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcgtKSSjCm4UzjWKbQ0eNoy8Y3lh9PsfkD1jFxEKq/Q+lVnqzOdEuOUny5v5nlWHfnHUorI7nCdQhsdNuTXbf3IxdRQ8K4Vn0Q62jkioGUbrpnSd/Gnsj8mRWD0s7W8L0RMX+fDDYxRQjWGPVwIF09cIIsuV3uq8MSR9PfM/PixKuNRMysDdApDMe3mfRhmke2jwf3/PUS9/mDXycIjn4dVsTVaRAb524Cb4q5AnizZmGNwjBhw3lYzmB6ldHVsavCcm+1OHSW9wMKNkrCHopAnRSK5DvoMZOUFB3xglc/A2yHOJH2DOdhauoDJ7nHPtJ0mX3zusJTpugbkbOIA+7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzML33Y9TJ9TwXcANzLAakaVc4yZKdXtsg6PpH8qlAo=;
 b=ZgG+I4VrGxT2A84ybGWKJIflCeuJFeaxz3ISIiEcQPWnGAseDuIFjdpsbua5tGok5QpzhR8EmiE5RxHuwl1iXxEinHFvPX3mAxQ2VAWgCpOCAGat92JpPnKD/c9mLUjVq4e7s/2c5ufZxuV8GbCFcrTvPigPBZ+J/zW39vT35JzAOm3SWf2qJCctkDM2D5pQ66UzCQNhCyLZcFCEL7VNo5vBthLjw3DrojwPJWwQxM57qJSkHIXtACwnY96c2kxA7H51SOetQJ7rpt5Zuu3lZ+yzvYwEm4/uSpt+FxSjSqgVdifZqAV3MqhbYOZl3Lu2u1T2UTpZrbK0h9yeuhzSqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6297.namprd11.prod.outlook.com (2603:10b6:a03:458::8)
 by BN6PR11MB4067.namprd11.prod.outlook.com (2603:10b6:405:7e::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Sun, 7 Aug
 2022 07:21:04 +0000
Received: from SJ1PR11MB6297.namprd11.prod.outlook.com
 ([fe80::f906:b045:d73e:8e49]) by SJ1PR11MB6297.namprd11.prod.outlook.com
 ([fe80::f906:b045:d73e:8e49%7]) with mapi id 15.20.5504.017; Sun, 7 Aug 2022
 07:21:03 +0000
Date:   Sun, 7 Aug 2022 15:20:52 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-staging@lists.linux.dev>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <lkp@lists.01.org>, <lkp@intel.com>
Subject: [net]  2638eb8b50: WARNING:suspicious_RCU_usage
Message-ID: <Yu9n1GOKdTOoO5hG@xsang-OptiPlex-9020>
Content-Type: multipart/mixed; boundary="Lunvpfy9DIRDIEcw"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SGBP274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::34)
 To SJ1PR11MB6297.namprd11.prod.outlook.com (2603:10b6:a03:458::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b7e0d5c-2a32-4698-6a10-08da784562cb
X-MS-TrafficTypeDiagnostic: BN6PR11MB4067:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o1XBoNttVK9qbXl+2GfR9KB/rPmC30shSnPMMH92auifkxCVPqxPDm7v1ubBcbJY6tkACcUFEBP8iTpLqAtfG2eLYXx06jVWeqrpVe4XuiuuJ+JSBg8lwNnGMLIwaLjjKKxLzJHBbE61ZM0u3v9S/fk1P7JBInlOkYsfZ8B29AicR2KTfo/KBiH6uI/wzpY9hQUS7kq9SeJqpvXAJVbjIfobVHsIt0TJpYjYjiunObsVAyrnDZA+kByJtT+VBSEv9H6cLBjK+61QMfj5SIuTfMqANcAQmjsABRQI5Pe+wdgdmqKnyy9ZFKatoKnVJmZVLzwwoffP0ZwhiNskFliABrIUL2VGcL9s8ILfg20j2Uh2eWMrRUOUwkj87RRLLlQip/0IrDDrPOvkGiXCWKBfBHg3W/6Af+Xkb7SIAfuY5GwBuq/at9XiCIveApdcsoSJXn/nUUnAq2bH3teM5TP2zxNnfRCh7GdTHBF+slx6P1xg42d7s7psZRZdOGkgQ+mknJGlVss1GJ7DoD4aVef/6m4kkBK71Ln9hljCfuPH4BJdGopA+JRc4iPHuXz512qf5HNfZ/dWc4ZcELJZUvIODEMcAOmVqX+Zdd6YBM1AGbYaGHhmRiGGo3DB9NGWPBBo6Yv6y476dSfUiPYmesO3W4DWkm3AVpbZAv8syD+hHqZp4/weqeTcz2xdajvH52YHpxC2raf1DDTI1z6MxL/BRCYnD9FclyMz1PAZ8ataDuXP1j2/2ewJCXO+2sYxc2K0eAJu+5obD2O7VnUQ6T/Pn/7ZXsAFlGy0fj2ZPkkREQg73iFrLy3ZOlNdSsC6fd0boa5pJrYqyw79DPn3nvTneOdKi+ONrnyq9G4Y3GYOUqeTNcpGWtQ/Gu4ebN5WZWQy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6297.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(136003)(376002)(39860400002)(346002)(396003)(5660300002)(235185007)(966005)(33716001)(8936002)(7416002)(4326008)(66476007)(66556008)(6486002)(8676002)(38100700002)(66946007)(2906002)(82960400001)(316002)(54906003)(186003)(6916009)(107886003)(83380400001)(41300700001)(478600001)(44144004)(9686003)(26005)(6512007)(6666004)(6506007)(86362001)(2700100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xa93uVJrSCDK/CTNzKZkZpbeA1rb8G+7digrgZAnlXrNDqyXKopNSqRbj25c?=
 =?us-ascii?Q?tub4shEbmIxiNKVdNa+mQ29Qi1NbA3lg+LLU2gjY1AHLaWA+62W9Xoviwj29?=
 =?us-ascii?Q?GoYNNQcEQ1umufoS+3QRkeGddfU3y/wojKkrJ7SAo8AWx1bEM69AQ0SrEgUC?=
 =?us-ascii?Q?GF79k7BcxUFjxZ+O+slmXhimFjNuGB4V81FlWd+BZ72TorpadMRa70Ps0bLc?=
 =?us-ascii?Q?Yf+jdVlv8oWKFadqBOoCfxvi7MIxmNGkqj7NG06LyWwwYAMbqXnMrQa3403f?=
 =?us-ascii?Q?n8HDf7vmARnRKAMuF0Fk8lkFvGC64LIObof/hzFHN9gY41Ix/fmsjvVNL1Lv?=
 =?us-ascii?Q?E09Tdvimp8KisVnuE/6TF2Kf1py4vH1E1W+FgGA0TtyWpLLB6PsY2ra6axWK?=
 =?us-ascii?Q?LRecn+h2ZKeZDtqhvdNvBIqICb8ZJR8JBdMYV2f2kXqumBAdelg3urqdz+Qx?=
 =?us-ascii?Q?BGJuA89U1QMVorQAXHY83Dy73ChF6V6qYVfnX+PbhqUdG1l099X85YwKH7XA?=
 =?us-ascii?Q?CIo3jCdvPYH+6AJixVoVysHMJbQAbFQmDUDvIfe7APi/KnVkCgPph3ovHSmj?=
 =?us-ascii?Q?P9RuO/XTcqK7A+MNwyHJD+0+dvNYFq2CGriKZvCVfTIW2SFOr4QAzZvTXf5s?=
 =?us-ascii?Q?evqujkmxbdyi0Sgp640keRxyIyWciaSHju0VAHRH3Wv1+N9RvNCs0wPJwu3N?=
 =?us-ascii?Q?REIpmUhho5wElSYQ9eh/NvdJDzKI4A7+4SFHzUYeNGakVTJq6jth6tlz8Zs+?=
 =?us-ascii?Q?64Prc7g/AaMyWdOytHhPCCWQHNqssEd1uqFIajQzst5xLt9Z2lU9yEyysokE?=
 =?us-ascii?Q?9zah2dCv9Fqkd1OFgg55K0xDrf4aIcZqm9pwGJhTftpLQQdnFOC77jtZx2Ht?=
 =?us-ascii?Q?T9H7BsApX72h24eTzKVzmEKg0wOpD2to3V94h2Pe2G+qfh6prK9jFM8I0C8g?=
 =?us-ascii?Q?ms+4yc0G/YnTMAVhWGkXINv8IWtf1732v8gForkefQKR70mQ3yV2WRsztUc4?=
 =?us-ascii?Q?dPYWms5HI4YrAqxzuoM5SvBgr1ATV/E93bEeSAm/oZIfUGMpv9iBmBZwRkqy?=
 =?us-ascii?Q?GhU1qbu8gPh2g+CXd9ykr3gEzpwL8rV3cXjtsSfOgI4H1IRK+yGS65VZ0gtE?=
 =?us-ascii?Q?X5qutl83RJU9sUEtCvY/x095ncW5VH1p6VUwzNHW72nCfCtRQMhpBh/YAZtH?=
 =?us-ascii?Q?qxN2V+d4lDeqEFGageQRACREcrWoaFfJ9GzbOmX41LuEChuYtG12yv4cjHml?=
 =?us-ascii?Q?+HBaK0S46AB5lFT7UbWgCkEj3mch43jfwkMLgRvWQhrFPLdTO9sn+7GPeGu6?=
 =?us-ascii?Q?xBojUMeLCe16VUovfQYay7ihLGcbr1hhd5v2adkNAZiax+A2MinjPvMF4IcU?=
 =?us-ascii?Q?7fNbcHaaabbrQ4FWdigQirNZyUWR4LZHAWqoJFLOzJXpBgJCmN/FwrWhjL17?=
 =?us-ascii?Q?EgCiFjoIqPSrzEmrgjDVtC/3a+oPDzz/FMg+TdJjH6+j/TD76ossYOGm2MYE?=
 =?us-ascii?Q?q2IT6I/xD7lf310fAv7rTf/VDM815ftyPE/YMI2LdRVgw3FoSx7SFWxnodOF?=
 =?us-ascii?Q?kl+m7uBQ7q35yc+jI77YCoLq/kAlcvl7s+lyOyHlsjrRp2ZrqtYUFKxq8ywL?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7e0d5c-2a32-4698-6a10-08da784562cb
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6297.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2022 07:21:03.8169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: peVqgv4wHpjb0ijNTNth//QS8qPalPNTfZGV0v4IaH9VAypS/9pKsbzTJv1ef9635ZBX+DoXXy/0bepNM7RZrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4067
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Lunvpfy9DIRDIEcw
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline


(please be noted we found the issue still reproducible on latest mainline
and linux-next/master, also on fix commit 6a9e9cea4c and there are similar
Call Trace and context, so report this though the commit is quite old)


Greeting,

FYI, we noticed the following commit (built with gcc-11):

commit: 2638eb8b50cfc16240e0bb080b9afbf541a9b39d ("net: ipv4: provide __rcu annotation for ifa_list")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

in testcase: boot

on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):


+------------------------------------------------------------------+------------+------------+
|                                                                  | cb8f1478ce | 2638eb8b50 |
+------------------------------------------------------------------+------------+------------+
| WARNING:suspicious_RCU_usage                                     | 0          | 6          |
| drivers/net/plip/plip.c:#suspicious_rcu_dereference_check()usage | 0          | 6          |
+------------------------------------------------------------------+------------+------------+


If you fix the issue, kindly add following tag
Reported-by: kernel test robot <oliver.sang@intel.com>


[   17.432553][    T1] WARNING: suspicious RCU usage
[   17.433096][    T1] 5.2.0-rc2-00605-g2638eb8b50cfc #1 Not tainted
[   17.433772][    T1] -----------------------------
[   17.434315][    T1] drivers/net/plip/plip.c:1110 suspicious rcu_dereference_check() usage!
[   17.435431][    T1]
[   17.435431][    T1] other info that might help us debug this:
[   17.435431][    T1]
[   17.436597][    T1]
[   17.436597][    T1] rcu_scheduler_active = 2, debug_locks = 1
[   17.437477][    T1] 1 lock held by swapper/0/1:
[ 17.438019][ T1] #0: (____ptrval____) (rtnl_mutex){+.+.}, at: ic_open_devs (net/ipv4/ipconfig.c:222) 
[   17.438986][    T1]
[   17.438986][    T1] stack backtrace:
[   17.439702][    T1] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.2.0-rc2-00605-g2638eb8b50cfc #1
[   17.440768][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-debian-1.16.0-4 04/01/2014
[   17.441885][    T1] Call Trace:
[ 17.442250][ T1] dump_stack (lib/dump_stack.c:115) 
[ 17.442701][ T1] plip_open (drivers/net/plip/plip.c:1110 (discriminator 9)) 
[ 17.443209][ T1] __dev_open (net/core/dev.c:1413) 
[ 17.443685][ T1] __dev_change_flags (net/core/dev.c:7554) 
[ 17.444253][ T1] dev_change_flags (net/core/dev.c:7625) 
[ 17.444809][ T1] ic_open_devs (net/ipv4/ipconfig.c:243) 
[ 17.445308][ T1] ip_auto_config (net/ipv4/ipconfig.c:1472) 
[ 17.445820][ T1] ? root_nfs_parse_addr (net/ipv4/ipconfig.c:1435) 
[ 17.446381][ T1] do_one_initcall (init/main.c:915) 
[ 17.446896][ T1] do_initcall_level (init/main.c:982) 
[ 17.447470][ T1] kernel_init_freeable (init/main.c:990 init/main.c:1009 init/main.c:1169) 
[ 17.448055][ T1] ? rest_init (init/main.c:1084) 
[ 17.448549][ T1] kernel_init (init/main.c:1089) 
[ 17.449001][ T1] ? rest_init (init/main.c:1084) 
[ 17.449472][ T1] ret_from_fork (arch/x86/entry/entry_64.S:358) 
[   17.464713][    T1] Sending DHCP requests .
[   17.518062][   T12] plip0: transmit timeout(1,d8)
[   19.498527][  T172] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   19.499947][  T172] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   19.801409][    T1] ., OK
[   20.547499][    T1] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0.2.15
[   20.548418][    T1] IP-Config: Complete:
[   20.548851][    T1]      device=eth0, hwaddr=52:54:00:12:34:56, ipaddr=10.0.2.15, mask=255.255.255.0, gw=10.0.2.2
[   20.549948][    T1]      host=vm-meta-288, domain=, nis-domain=(none)
[   20.550650][    T1]      bootserver=10.0.2.2, rootserver=10.0.2.2, rootpath=
[   20.550651][    T1]      nameserver0=10.0.2.3
[   20.557919][    T1] Freeing unused kernel image memory: 3472K
[   20.571470][    T1] Write protecting the kernel read-only data: 18432k
[   20.573644][    T1] Freeing unused kernel image memory: 2016K
[   20.574730][    T1] Freeing unused kernel image memory: 360K
[   20.575917][    T1] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[   20.576757][    T1] x86/mm: Checking user space page tables
[   20.577486][    T1] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[   20.578303][    T1] Run /init as init process
[   20.592303][    T1] systemd[1]: RTC configured in localtime, applying delta of 0 minutes to system time.
[   20.594574][    T1] LoadPin: mnt_sb lacks block device, treating as: writable
[   20.595455][    T1] LoadPin: enforcement can be disabled.
[   20.596104][    T1] LoadPin: kernel-module pinned obj="/lib/modules/5.2.0-rc2-00605-g2638eb8b50cfc/kernel/fs/autofs/autofs4.ko" pid=1 cmdline="/init"
[   20.599065][    T1] systemd[1]: Inserted module 'autofs4'
[   20.606700][    T1] cgroup2: Unknown parameter 'memory_recursiveprot'

Welcome to Debian GNU/Linux 11 (bullseye)!

[   20.795840][    T1] random: systemd: uninitialized urandom read (16 bytes read)
[  OK  ] Created slice system-getty.slice.
[   20.800706][    T1] random: systemd: uninitialized urandom read (16 bytes read)
[  OK  ] Created slice system-modprobe.slice.
[   20.803151][    T1] random: systemd: uninitialized urandom read (16 bytes read)
[  OK  ] Created slice User and Session Slice.
[  OK  ] Reached target Local Encrypted Volumes.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Slices.
[  OK  ] Reached target Swap.
[  OK  ] Listening on RPCbind Server Activation Socket.
[  OK  ] Listening on Syslog Socket.
[  OK  ] Listening on initctl Compatibility Named Pipe.
[  OK  ] Listening on Journal Audit Socket.
[  OK  ] Listening on Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Listening on udev Kernel Socket.
Mounting Huge Pages File System...
Mounting POSIX Message Queue File System...
Mounting RPC Pipe File System...
Mounting Kernel Debug File System...
Mounting Kernel Trace File System...
Starting Load Kernel Module configfs...
Starting Load Kernel Module drm...
Starting Load Kernel Module fuse...
[   20.886032][    C1] random: fast init done
Starting Journal Service...
Starting Load Kernel Modules...
Starting Remount Root and Kernel File Systems...
Starting Coldplug All udev Devices...
[  OK  ] Mounted Huge Pages File System.
[  OK  ] Mounted POSIX Message Queue File System.
[  OK  ] Finished Load Kernel Module configfs.
[FAILED] Failed to mount RPC Pipe File System.
See 'systemctl status run-rpc_pipefs.mount' for details.
[  OK  ] Mounted Kernel Debug File System.
[  OK  ] Mounted Kernel Trace File System.
[  OK  ] Finished Load Kernel Module drm.
[  OK  ] Finished Load Kernel Module fuse.
[  OK  ] Finished Load Kernel Modules.
[  OK  ] Finished Remount Root and Kernel File Systems.


To reproduce:

        # build kernel
	cd linux
	cp config-5.2.0-rc2-00605-g2638eb8b50cfc .config
	make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage modules
	make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 INSTALL_MOD_PATH=<mod-install-dir> modules_install
	cd <mod-install-dir>
	find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz


        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script is attached in this email

        # if come across any failure that blocks the test,
        # please remove ~/.lkp and /lkp dir to run from a clean state.



-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



--Lunvpfy9DIRDIEcw
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-5.2.0-rc2-00605-g2638eb8b50cfc"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.2.0-rc2 Kernel Configuration
#

#
# Compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
#
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=110300
CONFIG_CLANG_VERSION=0
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_WARN_MAYBE_UNINITIALIZED=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
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
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# end of Timers subsystem

# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_RCU_NOCB_CPU is not set
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS_PROC is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_KMEM=y
# CONFIG_BLK_CGROUP is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_BPF is not set
CONFIG_CGROUP_DEBUG=y
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
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
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_MULTIUSER=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
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
# CONFIG_IO_URING is not set
# CONFIG_ADVISE_SYSCALLS is not set
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_BPF_SYSCALL=y
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
# CONFIG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# end of Kernel Performance Events And Counters

# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_MEMCG_SYSFS_ON is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLAB_FREELIST_HARDENED is not set
# CONFIG_SHUFFLE_PAGE_ALLOCATOR is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
# CONFIG_X86_X2APIC is not set
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
# CONFIG_X86_CPU_RESCTRL is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
# CONFIG_IOSF_MBI is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
CONFIG_PVH=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# end of Performance monitoring

CONFIG_X86_VSYSCALL_EMULATION=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
# CONFIG_X86_PMEM_LEGACY is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
CONFIG_X86_INTEL_UMIP=y
# CONFIG_X86_INTEL_MPX is not set
# CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not set
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_KEXEC_FILE is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
# CONFIG_MODIFY_LDT_SYSCALL is not set
CONFIG_HAVE_LIVEPATCH=y
# CONFIG_LIVEPATCH is not set
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
# CONFIG_ACPI_SPCR_TABLE is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_REV_OVERRIDE_POSSIBLE is not set
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=m
# CONFIG_ACPI_VIDEO is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_TAD is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
# CONFIG_ACPI_THERMAL is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=m
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_NFIT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_EINJ is not set
CONFIG_ACPI_APEI_ERST_DEBUG=m
CONFIG_DPTF_POWER=y
CONFIG_PMIC_OPREGION=y
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
# CONFIG_CPU_IDLE_GOV_MENU is not set
CONFIG_CPU_IDLE_GOV_TEO=y
# end of CPU Idle

# CONFIG_INTEL_IDLE is not set
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_ISA_BUS=y
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
# CONFIG_IA32_EMULATION is not set
# CONFIG_X86_X32 is not set
# end of Binary Emulations

CONFIG_HAVE_GENERIC_GUP=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_FW_CFG_SYSFS is not set
CONFIG_GOOGLE_FIRMWARE=y
CONFIG_GOOGLE_SMI=y
CONFIG_GOOGLE_COREBOOT_TABLE=y
CONFIG_GOOGLE_MEMCONSOLE=y
# CONFIG_GOOGLE_MEMCONSOLE_X86_LEGACY is not set
CONFIG_GOOGLE_MEMCONSOLE_COREBOOT=y
CONFIG_GOOGLE_VPD=m

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=m
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=m
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_BOOTLOADER_CONTROL=m
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_EARLYCON=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# General architecture-dependent options
#
CONFIG_HOTPLUG_SMT=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
CONFIG_STACKPROTECTOR=y
# CONFIG_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_ISA_BUS_API=y
CONFIG_64BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_REFCOUNT=y
# CONFIG_REFCOUNT_FULL is not set
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_PLUGIN_HOSTCC=""
CONFIG_HAVE_GCC_PLUGINS=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_MODULE_COMPRESS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_ZONED=y
# CONFIG_BLK_CMDLINE_PARSER is not set
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
CONFIG_BLK_DEBUG_FS=y
CONFIG_BLK_DEBUG_FS_ZONED=y
CONFIG_BLK_SED_OPAL=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
# end of Partition Types

CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=m
# CONFIG_IOSCHED_BFQ is not set
# end of IO Schedulers

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
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_DEFERRED_STRUCT_PAGE_INIT is not set
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ARCH_HAS_ZONE_DEVICE=y
CONFIG_ARCH_HAS_HMM_MIRROR=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_BENCHMARK is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_NET_INGRESS=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_TLS is not set
# CONFIG_XFRM_USER is not set
# CONFIG_NET_KEY is not set
CONFIG_XDP_SOCKETS=y
# CONFIG_XDP_SOCKETS_DIAG is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_IPV6_ILA is not set
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_FAMILY_BRIDGE=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NETFILTER_NETLINK_OSF is not set
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NF_LOG_NETDEV is not set
# CONFIG_NF_TABLES is not set
# CONFIG_NETFILTER_XTABLES is not set
# end of Core Netfilter Configuration

# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_SOCKET_IPV4 is not set
# CONFIG_NF_TPROXY_IPV4 is not set
# CONFIG_NF_DUP_IPV4 is not set
# CONFIG_NF_LOG_ARP is not set
# CONFIG_NF_LOG_IPV4 is not set
# CONFIG_NF_REJECT_IPV4 is not set
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_NF_ARPTABLES is not set
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_SOCKET_IPV6 is not set
# CONFIG_NF_TPROXY_IPV6 is not set
# CONFIG_NF_DUP_IPV6 is not set
# CONFIG_NF_REJECT_IPV6 is not set
# CONFIG_NF_LOG_IPV6 is not set
# CONFIG_IP6_NF_IPTABLES is not set
# end of IPv6: Netfilter Configuration

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
# end of DECnet: Netfilter Configuration

# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=m
CONFIG_PHONET=y
# CONFIG_6LOWPAN is not set
CONFIG_IEEE802154=m
CONFIG_IEEE802154_NL802154_EXPERIMENTAL=y
# CONFIG_IEEE802154_SOCKET is not set
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=m
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_CBS is not set
CONFIG_NET_SCH_ETF=m
CONFIG_NET_SCH_TAPRIO=m
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_SKBPRIO=m
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_CAKE=y
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_HHF=y
CONFIG_NET_SCH_PIE=y
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ_CODEL is not set
# CONFIG_DEFAULT_SFQ is not set
CONFIG_DEFAULT_PFIFO_FAST=y
CONFIG_DEFAULT_NET_SCH="pfifo_fast"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=m
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=m
CONFIG_NET_CLS_BPF=y
CONFIG_NET_CLS_FLOWER=y
# CONFIG_NET_CLS_MATCHALL is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
# CONFIG_NET_ACT_SAMPLE is not set
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_ACT_VLAN=m
# CONFIG_NET_ACT_BPF is not set
# CONFIG_NET_ACT_SKBMOD is not set
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=y
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BATMAN_V=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_MCAST=y
# CONFIG_BATMAN_ADV_DEBUGFS is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_BATMAN_ADV_SYSFS=y
# CONFIG_BATMAN_ADV_TRACING is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
# CONFIG_VSOCKETS_DIAG is not set
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
# CONFIG_HYPERV_VSOCKETS is not set
CONFIG_NETLINK_DIAG=y
CONFIG_MPLS=y
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_MPLS_ROUTING is not set
CONFIG_NET_NSH=y
CONFIG_HSR=m
# CONFIG_NET_SWITCHDEV is not set
# CONFIG_NET_L3_MASTER_DEV is not set
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_VXCAN is not set
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

CONFIG_BT=m
# CONFIG_BT_BREDR is not set
CONFIG_BT_LE=y
# CONFIG_BT_LEDS is not set
# CONFIG_BT_SELFTEST is not set
CONFIG_BT_DEBUGFS=y

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=m
CONFIG_BT_BCM=m
CONFIG_BT_RTL=m
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTUSB_AUTOSUSPEND=y
CONFIG_BT_HCIBTUSB_BCM=y
CONFIG_BT_HCIBTUSB_RTL=y
CONFIG_BT_HCIBTSDIO=m
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
CONFIG_BT_ATH3K=m
# CONFIG_BT_MTKSDIO is not set
CONFIG_BT_MTKUART=m
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=m
CONFIG_CAIF_USB=m
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_FAILOVER=m
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_PCI_LOCKLESS_CONFIG=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
# CONFIG_HOTPLUG_PCI is not set

#
# PCI controller drivers
#

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support

#
# DesignWare PCI Core Support
#
# end of DesignWare PCI Core Support
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

# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# end of Firmware loader

# CONFIG_ALLOW_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPMI=m
CONFIG_REGMAP_W1=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_FENCE_TRACE=y
# end of Generic Driver Options

#
# Bus devices
#
# end of Bus devices

CONFIG_CONNECTOR=m
CONFIG_GNSS=y
CONFIG_GNSS_SERIAL=y
CONFIG_GNSS_MTK_SERIAL=y
# CONFIG_GNSS_SIRF_SERIAL is not set
CONFIG_GNSS_UBX_SERIAL=y
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# Partition parsers
#
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=y
CONFIG_FTL=m
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=m
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_PARTITIONED_MASTER=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_INTELEXT is not set
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# end of Self-contained MTD device drivers

CONFIG_MTD_NAND_CORE=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=m
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_NAND_ECC_SW_HAMMING=y
# CONFIG_MTD_NAND_ECC_SW_HAMMING_SMC is not set
CONFIG_MTD_RAW_NAND=y
CONFIG_MTD_NAND_ECC_SW_BCH=y

#
# Raw/parallel NAND flash controllers
#
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_GPIO=y
# CONFIG_MTD_NAND_PLATFORM is not set

#
# Misc
#
CONFIG_MTD_NAND_NANDSIM=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# end of LPDDR & LPDDR2 PCM memory drivers

# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=m
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TARGET is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
CONFIG_ISL29020=m
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
CONFIG_PVPANIC=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_IDT_89HPESX is not set
CONFIG_EEPROM_EE1004=m
# end of EEPROM support

# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module (requires I2C)
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC & related support
#

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
# end of Intel MIC & related support

# CONFIG_GENWQE is not set
CONFIG_ECHO=m
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# end of Misc devices

CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
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
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
# CONFIG_LIBFCOE is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
CONFIG_SCSI_IZIP_SLOW_CTR=y
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
CONFIG_SCSI_VIRTIO=m
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
# end of SCSI device support

CONFIG_ATA=m
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_ZPODD=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
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
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PLATFORM=m
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_LEGACY is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
# CONFIG_TCM_FC is not set
# CONFIG_ISCSI_TARGET is not set
CONFIG_SBP_TARGET=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=m
# CONFIG_FIREWIRE_NET is not set
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
# CONFIG_CAIF_SPI_SLAVE is not set
# CONFIG_CAIF_HSI is not set
# CONFIG_CAIF_VIRTIO is not set

#
# Distributed Switch Architecture drivers
#
# end of Distributed Switch Architecture drivers

CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
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
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_VENDOR_AURORA=y
# CONFIG_AURORA_NB8800 is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
# CONFIG_CAVIUM_PTP is not set
# CONFIG_LIQUIDIO is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_HUAWEI=y
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
# CONFIG_IGC is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
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
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_MDIO_BCM_UNIMAC=m
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set
# CONFIG_PHYLIB is not set
CONFIG_PLIP=y
CONFIG_PPP=m
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOATM is not set
# CONFIG_PPPOE is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_USB_NET_DRIVERS is not set
CONFIG_WLAN=y
# CONFIG_WIRELESS_WDS is not set
# CONFIG_WLAN_VENDOR_ADMTEK is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_WLAN_VENDOR_BROADCOM is not set
CONFIG_WLAN_VENDOR_CISCO=y
CONFIG_WLAN_VENDOR_INTEL=y
CONFIG_WLAN_VENDOR_INTERSIL=y
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_PRISM54 is not set
# CONFIG_WLAN_VENDOR_MARVELL is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
# CONFIG_WLAN_VENDOR_RALINK is not set
# CONFIG_WLAN_VENDOR_REALTEK is not set
CONFIG_WLAN_VENDOR_RSI=y
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_WLAN_VENDOR_TI is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
CONFIG_WLAN_VENDOR_QUANTENNA=y

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_HYPERV_NET is not set
# CONFIG_NETDEVSIM is not set
CONFIG_NET_FAILOVER=m
CONFIG_ISDN=y
CONFIG_ISDN_CAPI=y
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_CAPI20 is not set
CONFIG_MISDN=y
# CONFIG_MISDN_DSP is not set
CONFIG_MISDN_L1OIP=y

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
# CONFIG_MISDN_HFCMULTI is not set
CONFIG_MISDN_HFCUSB=y
# CONFIG_MISDN_AVMFRITZ is not set
# CONFIG_MISDN_SPEEDFAX is not set
# CONFIG_MISDN_INFINEON is not set
# CONFIG_MISDN_W6692 is not set
# CONFIG_MISDN_NETJET is not set
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=m
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
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
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_HANWANG=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_PEGASUS=m
# CONFIG_TABLET_SERIAL_WACOM4 is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SMB=m
# CONFIG_RMI4_F03 is not set
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
# CONFIG_RMI4_F30 is not set
# CONFIG_RMI4_F34 is not set
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_HYPERV_KEYBOARD=m
CONFIG_SERIO_GPIO_PS2=m
CONFIG_USERIO=m
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_NULL_TTY is not set
CONFIG_LDISC_AUTOLOAD=y
# CONFIG_DEVMEM is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
# CONFIG_SERIAL_8250_MEN_MCB is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# end of Serial drivers

CONFIG_SERIAL_DEV_BUS=y
CONFIG_SERIAL_DEV_CTRL_TTYPORT=y
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=y
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set

#
# I2C support
#
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_LTC4306=m
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_MUX_REG=m
# CONFIG_I2C_MUX_MLXCPLD is not set
# end of Multiplexer I2C Chip support

# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m
# end of I2C Algorithms

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
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_SLAVE=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_GPIO_FAULT_INJECTOR is not set
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_DLN2 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
# CONFIG_SPI is not set
CONFIG_SPMI=m
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=m
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
CONFIG_DEBUG_PINCTRL=y
# CONFIG_PINCTRL_AMD is not set
CONFIG_PINCTRL_MCP23S08=m
# CONFIG_PINCTRL_BAYTRAIL is not set
CONFIG_PINCTRL_CHERRYVIEW=m
CONFIG_PINCTRL_INTEL=y
CONFIG_PINCTRL_BROXTON=y
# CONFIG_PINCTRL_CANNONLAKE is not set
CONFIG_PINCTRL_CEDARFORK=m
CONFIG_PINCTRL_DENVERTON=m
CONFIG_PINCTRL_GEMINILAKE=y
# CONFIG_PINCTRL_ICELAKE is not set
CONFIG_PINCTRL_LEWISBURG=y
CONFIG_PINCTRL_SUNRISEPOINT=y
CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_MENZ127 is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_IT87=y
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_WINBOND=y
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
CONFIG_GPIO_ADP5588=m
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_TPIC2810=m
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
CONFIG_GPIO_BD9571MWV=m
CONFIG_GPIO_DLN2=m
CONFIG_GPIO_KEMPLD=y
CONFIG_GPIO_TPS65086=m
CONFIG_GPIO_TQMX86=y
# CONFIG_GPIO_WM8994 is not set
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
# USB GPIO expanders
#
# CONFIG_GPIO_VIPERBOARD is not set
# end of USB GPIO expanders

CONFIG_GPIO_MOCKUP=y
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set
# end of 1-wire Bus Masters

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2405 is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2406=y
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2805=m
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2438=y
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_DS28E17=m
# end of 1-wire Slaves

# CONFIG_POWER_AVS is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
CONFIG_CHARGER_ADP5061=m
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
CONFIG_CHARGER_SBS=m
CONFIG_MANAGER_SBS=m
CONFIG_BATTERY_BQ27XXX=y
CONFIG_BATTERY_BQ27XXX_I2C=m
CONFIG_BATTERY_BQ27XXX_HDQ=m
CONFIG_BATTERY_BQ27XXX_DT_UPDATES_NVM=y
CONFIG_CHARGER_AXP20X=m
CONFIG_BATTERY_AXP20X=m
CONFIG_AXP20X_POWER=m
# CONFIG_AXP288_FUEL_GAUGE is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_BATTERY_MAX1721X=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_MAX14577 is not set
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24257=m
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_BQ25890=m
# CONFIG_CHARGER_SMB347 is not set
CONFIG_BATTERY_GAUGE_LTC2941=m
# CONFIG_BATTERY_RT5033 is not set
CONFIG_CHARGER_RT9455=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ASPEED=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DELL_SMM=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_MC13783_ADC=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_FTSTEUTATES=m
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_I5500 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_POWR1220=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LTC2945=m
CONFIG_SENSORS_LTC2990=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MAX31790 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_MLXREG_FAN=m
CONFIG_SENSORS_TC654=m
CONFIG_SENSORS_MENF21BMC_HWMON=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NCT7802=m
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_IBM_CFFPS=m
CONFIG_SENSORS_IR35221=m
CONFIG_SENSORS_IR38064=m
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC2978_REGULATOR is not set
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX20751 is not set
CONFIG_SENSORS_MAX31785=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_TPS40422=m
# CONFIG_SENSORS_TPS53679 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
CONFIG_SENSORS_SHTC1=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_STTS751 is not set
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_INA3221=m
CONFIG_SENSORS_TC74=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83773G=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_XGENE=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
CONFIG_THERMAL_STATISTICS=y
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_CLOCK_THERMAL is not set
CONFIG_DEVFREQ_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# end of ACPI INT340X thermal drivers

# CONFIG_INTEL_PCH_THERMAL is not set
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_SYSFS=y

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_DA9062_WATCHDOG is not set
# CONFIG_MENF21BMC_WATCHDOG is not set
# CONFIG_MENZ069_WATCHDOG is not set
# CONFIG_WDAT_WDT is not set
# CONFIG_XILINX_WATCHDOG is not set
CONFIG_ZIIRAVE_WATCHDOG=m
# CONFIG_RAVE_SP_WATCHDOG is not set
CONFIG_MLX_WDT=y
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
CONFIG_MAX63XX_WATCHDOG=m
CONFIG_RETU_WATCHDOG=m
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_EBC_C384_WDT=y
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=m
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=m
CONFIG_TQMX86_WDT=m
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=m
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_NI903X_WDT=y
CONFIG_NIC7018_WDT=m
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_BCM590XX=m
CONFIG_MFD_BD9571MWV=m
CONFIG_MFD_AXP20X=m
CONFIG_MFD_AXP20X_I2C=m
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_MADERA is not set
CONFIG_MFD_DA9062=m
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
CONFIG_MFD_DLN2=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=m
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=m
CONFIG_MFD_INTEL_LPSS_ACPI=m
# CONFIG_MFD_INTEL_LPSS_PCI is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=m
CONFIG_MFD_88PM805=m
CONFIG_MFD_MAX14577=m
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=m
# CONFIG_MFD_MT6397 is not set
CONFIG_MFD_MENF21BMC=m
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RT5033=m
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SKY81452 is not set
CONFIG_ABX500_CORE=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_TI_LMU=m
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65086=m
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
CONFIG_MFD_TQMX86=y
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8994=m
CONFIG_RAVE_SP_CORE=y
# end of Multifunction device drivers

CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PG86X is not set
# CONFIG_REGULATOR_88PM800 is not set
CONFIG_REGULATOR_ACT8865=m
CONFIG_REGULATOR_AD5398=m
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_AXP20X is not set
CONFIG_REGULATOR_BCM590XX=m
CONFIG_REGULATOR_BD9571MWV=m
CONFIG_REGULATOR_DA9062=m
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_DA9211=m
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ISL9305 is not set
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_LM363X is not set
CONFIG_REGULATOR_LP3971=m
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=m
# CONFIG_REGULATOR_LTC3589 is not set
# CONFIG_REGULATOR_LTC3676 is not set
CONFIG_REGULATOR_MAX14577=m
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MC13XXX_CORE=m
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_MT6311 is not set
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_PV88060 is not set
CONFIG_REGULATOR_PV88080=m
CONFIG_REGULATOR_PV88090=m
CONFIG_REGULATOR_PWM=m
CONFIG_REGULATOR_QCOM_SPMI=m
CONFIG_REGULATOR_RT5033=m
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65086 is not set
CONFIG_REGULATOR_TPS65132=m
CONFIG_REGULATOR_WM8994=m
CONFIG_CEC_CORE=m
CONFIG_CEC_NOTIFIER=y
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_LIRC=y
CONFIG_RC_DECODERS=y
# CONFIG_IR_NEC_DECODER is not set
# CONFIG_IR_RC5_DECODER is not set
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
# CONFIG_IR_SONY_DECODER is not set
CONFIG_IR_SANYO_DECODER=m
# CONFIG_IR_SHARP_DECODER is not set
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_XMP_DECODER=m
CONFIG_IR_IMON_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
# CONFIG_DRM_DP_AUX_CHARDEV is not set
# CONFIG_DRM_DEBUG_SELFTEST is not set
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_FBDEV_EMULATION is not set
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_DP_CEC is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_I2C_NXP_TDA9950=m
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set

#
# ACP (Audio CoProcessor) Configuration
#
# end of ACP (Audio CoProcessor) Configuration

# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_VGEM=m
CONFIG_DRM_VKMS=m
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=m
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_VIRTIO_GPU is not set
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
# CONFIG_DRM_HISI_HIBMC is not set
# CONFIG_DRM_TINYDRM is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y

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
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

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
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
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
CONFIG_FB_IBM_GXT4500=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_PM8941_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_PCF50633=m
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=m
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
CONFIG_BACKLIGHT_RAVE_SP=m
# end of Backlight & LCD device support

CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

CONFIG_SOUND=y
# CONFIG_SND is not set

#
# HID support
#
# CONFIG_HID is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
# CONFIG_USB_MOUSE is not set
# end of USB HID Boot Protocol drivers
# end of USB HID support

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
# end of I2C HID support

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
# end of Intel ISH HID support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=y
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=m
# CONFIG_USB_EHCI_FSL is not set
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_R8A66597_HCD=m
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=m
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=m
CONFIG_USBIP_CORE=m
CONFIG_USBIP_VHCI_HCD=m
CONFIG_USBIP_VHCI_HC_PORTS=8
CONFIG_USBIP_VHCI_NR_HCS=1
CONFIG_USBIP_HOST=m
# CONFIG_USBIP_VUDC is not set
CONFIG_USBIP_DEBUG=y
CONFIG_USB_MUSB_HDRC=m
CONFIG_USB_MUSB_HOST=y
# CONFIG_USB_MUSB_GADGET is not set
# CONFIG_USB_MUSB_DUAL_ROLE is not set

#
# Platform Glue Layer
#

#
# MUSB DMA mode
#
# CONFIG_MUSB_PIO_ONLY is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_ULPI=y
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_HAPS=y
CONFIG_USB_DWC2=m
# CONFIG_USB_DWC2_HOST is not set

#
# Gadget/Dual-role mode requires USB Gadget support to be enabled
#
# CONFIG_USB_DWC2_PERIPHERAL is not set
CONFIG_USB_DWC2_DUAL_ROLE=y
# CONFIG_USB_DWC2_PCI is not set
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_PCI=m
CONFIG_USB_CHIPIDEA_UDC=y
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_ISP1760=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1761_UDC=y
# CONFIG_USB_ISP1760_HOST_ROLE is not set
# CONFIG_USB_ISP1760_GADGET_ROLE is not set
CONFIG_USB_ISP1760_DUAL_ROLE=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HUB_USB251XB=m
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
CONFIG_USB_CHAOSKEY=m
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
# CONFIG_USB_CXACRU is not set
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_USB_GPIO_VBUS=m
# CONFIG_TAHVO_USB is not set
CONFIG_USB_ISP1301=m
# end of USB Physical Layer drivers

CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=m
CONFIG_USB_GR_UDC=m
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=m
# CONFIG_USB_M66592 is not set
# CONFIG_USB_BDC_UDC is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=m
# end of USB Peripheral Controller

CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_F_FS=m
CONFIG_USB_F_TCM=m
CONFIG_USB_CONFIGFS=m
# CONFIG_USB_CONFIGFS_SERIAL is not set
# CONFIG_USB_CONFIGFS_ACM is not set
# CONFIG_USB_CONFIGFS_OBEX is not set
CONFIG_USB_CONFIGFS_NCM=y
# CONFIG_USB_CONFIGFS_ECM is not set
CONFIG_USB_CONFIGFS_ECM_SUBSET=y
CONFIG_USB_CONFIGFS_RNDIS=y
# CONFIG_USB_CONFIGFS_EEM is not set
# CONFIG_USB_CONFIGFS_PHONET is not set
# CONFIG_USB_CONFIGFS_MASS_STORAGE is not set
# CONFIG_USB_CONFIGFS_F_LB_SS is not set
CONFIG_USB_CONFIGFS_F_FS=y
# CONFIG_USB_CONFIGFS_F_HID is not set
# CONFIG_USB_CONFIGFS_F_PRINTER is not set
CONFIG_USB_CONFIGFS_F_TCM=y
CONFIG_TYPEC=y
CONFIG_TYPEC_TCPM=m
CONFIG_TYPEC_TCPCI=m
CONFIG_TYPEC_RT1711H=m
# CONFIG_TYPEC_FUSB302 is not set
CONFIG_TYPEC_UCSI=y
CONFIG_UCSI_CCG=m
CONFIG_UCSI_ACPI=y
CONFIG_TYPEC_TPS6598X=m

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
CONFIG_TYPEC_DP_ALTMODE=m
CONFIG_TYPEC_NVIDIA_ALTMODE=m
# end of USB Type-C Alternate Mode drivers

CONFIG_USB_ROLE_SWITCH=y
CONFIG_USB_ROLES_INTEL_XHCI=y
# CONFIG_USB_LED_TRIG is not set
CONFIG_USB_ULPI_BUS=y
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_DEBUG=y
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
CONFIG_MMC_USDHI6ROL0=m
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_TOSHIBA_PCI is not set
CONFIG_MMC_MTK=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m
# CONFIG_LEDS_CLASS_FLASH is not set
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
CONFIG_LEDS_APU=m
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3532=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP3952=m
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_TLC591XX=m
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_MENF21BMC=m

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
CONFIG_LEDS_MLXREG=m
# CONFIG_LEDS_USER is not set
CONFIG_LEDS_NIC78BX=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_DISK=y
CONFIG_LEDS_TRIGGER_MTD=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_ACTIVITY=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
CONFIG_LEDS_TRIGGER_PATTERN=m
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=m
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_IE31200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
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
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM80X is not set
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
CONFIG_RTC_DRV_ABX80X=m
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1307_CENTURY=y
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1374_WDT=y
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8907 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
CONFIG_RTC_DRV_PCF85363=m
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3028=m
# CONFIG_RTC_DRV_RV8803 is not set
CONFIG_RTC_DRV_SD3078=m

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=m

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
# CONFIG_RTC_DRV_DS3232_HWMON is not set
CONFIG_RTC_DRV_PCF2127=m
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_DA9063 is not set
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_FTRTC010=m
CONFIG_RTC_DRV_MC13XXX=m

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
CONFIG_UDMABUF=y
# end of DMABUF options

CONFIG_AUXDISPLAY=y
# CONFIG_HD44780 is not set
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
CONFIG_IMG_ASCII_LCD=y
CONFIG_PARPORT_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_CHARLCD_BL_OFF is not set
CONFIG_CHARLCD_BL_ON=y
# CONFIG_CHARLCD_BL_FLASH is not set
CONFIG_PANEL=m
CONFIG_CHARLCD=m
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_UIO_PRUSS=m
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO=y
# CONFIG_VFIO_NOIOMMU is not set
# CONFIG_VFIO_PCI is not set
# CONFIG_VFIO_MDEV is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_MENU=y
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_INPUT=m
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_TSCPAGE=y
# CONFIG_HYPERV_UTILS is not set
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACER_WIRELESS is not set
# CONFIG_ACERHDF is not set
CONFIG_ALIENWARE_WMI=m
CONFIG_ASUS_LAPTOP=m
CONFIG_DCDBAS=m
CONFIG_DELL_SMBIOS=m
# CONFIG_DELL_SMBIOS_WMI is not set
# CONFIG_DELL_SMBIOS_SMM is not set
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_DESCRIPTOR=m
# CONFIG_DELL_WMI_AIO is not set
CONFIG_DELL_WMI_LED=m
CONFIG_DELL_SMO8800=y
CONFIG_DELL_RBU=m
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
CONFIG_LG_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
CONFIG_ASUS_WIRELESS=m
CONFIG_ACPI_WMI=y
# CONFIG_WMI_BMOF is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m
CONFIG_MSI_WMI=m
# CONFIG_PEAQ_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
# CONFIG_INTEL_IPS is not set
# CONFIG_INTEL_PMC_CORE is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_APPLE_GMUX is not set
CONFIG_INTEL_RST=m
CONFIG_INTEL_SMARTCONNECT=m
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_INTEL_PUNIT_IPC=m
CONFIG_MLX_PLATFORM=m
# CONFIG_I2C_MULTI_INSTANTIATE is not set
CONFIG_HUAWEI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
CONFIG_PMC_ATOM=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=m
# CONFIG_CHROMEOS_PSTORE is not set
CONFIG_CHROMEOS_TBMC=m
# CONFIG_CROS_KBD_LED_BACKLIGHT is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_MAX9485=m
CONFIG_COMMON_CLK_SI5351=m
CONFIG_COMMON_CLK_SI544=m
# CONFIG_COMMON_CLK_CDCE706 is not set
CONFIG_COMMON_CLK_CS2000_CP=m
CONFIG_COMMON_CLK_PWM=m
# end of Common Clock Framework

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
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

CONFIG_IOMMU_DEBUGFS=y
CONFIG_IOMMU_DEFAULT_PASSTHROUGH=y
# CONFIG_AMD_IOMMU is not set
CONFIG_HYPERV_IOMMU=y

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
# Aspeed SoC drivers
#
# end of Aspeed SoC drivers

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
# IXP4xx SoC drivers
#
# CONFIG_IXP4XX_QMGR is not set
# CONFIG_IXP4XX_NPE is not set
# end of IXP4xx SoC drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

CONFIG_SOC_TI=y

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=m
CONFIG_DEVFREQ_GOV_PASSIVE=m

#
# DEVFREQ Drivers
#
CONFIG_PM_DEVFREQ_EVENT=y
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=m
# CONFIG_EXTCON_AXP288 is not set
CONFIG_EXTCON_GPIO=m
# CONFIG_EXTCON_INTEL_INT3496 is not set
CONFIG_EXTCON_MAX14577=m
CONFIG_EXTCON_MAX3355=y
CONFIG_EXTCON_PTN5150=m
CONFIG_EXTCON_RT8973A=m
CONFIG_EXTCON_SM5502=m
CONFIG_EXTCON_USB_GPIO=m
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_BUFFER_HW_CONSUMER=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_CONFIGFS=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
CONFIG_IIO_SW_DEVICE=m
# CONFIG_IIO_SW_TRIGGER is not set

#
# Accelerometers
#
CONFIG_ADXL345=m
CONFIG_ADXL345_I2C=m
CONFIG_ADXL372=m
CONFIG_ADXL372_I2C=m
# CONFIG_BMA180 is not set
CONFIG_BMC150_ACCEL=y
CONFIG_BMC150_ACCEL_I2C=m
CONFIG_DA280=m
# CONFIG_DA311 is not set
# CONFIG_DMARD09 is not set
CONFIG_DMARD10=m
# CONFIG_IIO_CROS_EC_ACCEL_LEGACY is not set
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
CONFIG_KXSD9=m
# CONFIG_KXSD9_I2C is not set
CONFIG_KXCJK1013=m
CONFIG_MC3230=m
# CONFIG_MMA7455_I2C is not set
CONFIG_MMA7660=m
# CONFIG_MMA8452 is not set
CONFIG_MMA9551_CORE=m
CONFIG_MMA9551=m
CONFIG_MMA9553=m
CONFIG_MXC4005=m
# CONFIG_MXC6255 is not set
CONFIG_STK8312=m
# CONFIG_STK8BA50 is not set
# end of Accelerometers

#
# Analog to digital converters
#
CONFIG_AD7291=m
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
# CONFIG_AD799X is not set
CONFIG_AXP20X_ADC=m
# CONFIG_AXP288_ADC is not set
CONFIG_CC10001_ADC=m
# CONFIG_DLN2_ADC is not set
# CONFIG_HX711 is not set
CONFIG_INA2XX_ADC=m
CONFIG_LTC2471=m
CONFIG_LTC2485=m
# CONFIG_LTC2497 is not set
CONFIG_MAX1363=m
CONFIG_MAX9611=m
CONFIG_MCP3422=m
# CONFIG_MEN_Z188_ADC is not set
CONFIG_NAU7802=m
CONFIG_QCOM_VADC_COMMON=m
# CONFIG_QCOM_SPMI_IADC is not set
CONFIG_QCOM_SPMI_VADC=m
CONFIG_QCOM_SPMI_ADC5=m
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_ADS1015 is not set
CONFIG_TI_AM335X_ADC=y
# CONFIG_VIPERBOARD_ADC is not set
# end of Analog to digital converters

#
# Analog Front Ends
#
# end of Analog Front Ends

#
# Amplifiers
#
# end of Amplifiers

#
# Chemical Sensors
#
CONFIG_ATLAS_PH_SENSOR=m
CONFIG_BME680=m
CONFIG_BME680_I2C=m
CONFIG_CCS811=m
CONFIG_IAQCORE=m
CONFIG_PMS7003=y
CONFIG_SENSIRION_SGP30=m
CONFIG_SPS30=m
# CONFIG_VZ89X is not set
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
# end of Hid Sensor IIO Common

CONFIG_IIO_MS_SENSORS_I2C=m

#
# SSP Sensor Common
#
# end of SSP Sensor Common

CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5593R is not set
# CONFIG_AD5696_I2C is not set
CONFIG_CIO_DAC=y
CONFIG_DS4424=m
CONFIG_M62332=m
CONFIG_MAX517=m
CONFIG_MCP4725=m
CONFIG_TI_DAC5571=m
# end of Digital to analog converters

#
# IIO dummy driver
#
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# end of IIO dummy driver

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
# CONFIG_BMG160 is not set
CONFIG_FXAS21002C=m
CONFIG_FXAS21002C_I2C=m
CONFIG_MPU3050=m
CONFIG_MPU3050_I2C=m
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=m
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
CONFIG_AFE4404=m
# CONFIG_MAX30100 is not set
CONFIG_MAX30102=m
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
CONFIG_AM2315=m
CONFIG_DHT11=m
# CONFIG_HDC100X is not set
# CONFIG_HTS221 is not set
CONFIG_HTU21=m
CONFIG_SI7005=m
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
CONFIG_BMI160=m
CONFIG_BMI160_I2C=m
CONFIG_KMX61=m
CONFIG_INV_MPU6050_IIO=m
CONFIG_INV_MPU6050_I2C=m
# CONFIG_IIO_ST_LSM6DSX is not set
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
CONFIG_ADJD_S311=m
CONFIG_AL3320A=m
CONFIG_APDS9300=m
CONFIG_APDS9960=m
# CONFIG_BH1750 is not set
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM3232 is not set
# CONFIG_CM3323 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_ISL29028=m
CONFIG_ISL29125=m
CONFIG_JSA1212=m
CONFIG_RPR0521=m
CONFIG_SENSORS_LM3533=m
CONFIG_LTR501=m
# CONFIG_LV0104CS is not set
# CONFIG_MAX44000 is not set
CONFIG_MAX44009=m
CONFIG_OPT3001=m
CONFIG_PA12203001=m
# CONFIG_SI1133 is not set
# CONFIG_SI1145 is not set
CONFIG_STK3310=m
CONFIG_ST_UVIS25=m
CONFIG_ST_UVIS25_I2C=m
CONFIG_TCS3414=m
CONFIG_TCS3472=m
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
CONFIG_TSL2772=m
CONFIG_TSL4531=m
CONFIG_US5182D=m
# CONFIG_VCNL4000 is not set
CONFIG_VCNL4035=m
CONFIG_VEML6070=m
# CONFIG_VL6180 is not set
CONFIG_ZOPT2201=m
# end of Light sensors

#
# Magnetometer sensors
#
CONFIG_AK8975=m
CONFIG_AK09911=m
# CONFIG_BMC150_MAGN_I2C is not set
# CONFIG_MAG3110 is not set
# CONFIG_MMC35240 is not set
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
CONFIG_SENSORS_HMC5843=m
CONFIG_SENSORS_HMC5843_I2C=m
CONFIG_SENSORS_RM3100=m
CONFIG_SENSORS_RM3100_I2C=m
# end of Magnetometer sensors

#
# Multiplexers
#
# end of Multiplexers

#
# Inclinometer sensors
#
# end of Inclinometer sensors

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Digital potentiometers
#
CONFIG_AD5272=m
CONFIG_DS1803=m
CONFIG_MCP4018=m
# CONFIG_MCP4531 is not set
CONFIG_TPL0102=m
# end of Digital potentiometers

#
# Digital potentiostats
#
CONFIG_LMP91000=m
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
CONFIG_BMP280=m
CONFIG_BMP280_I2C=m
CONFIG_HP03=m
CONFIG_MPL115=m
CONFIG_MPL115_I2C=m
CONFIG_MPL3115=m
# CONFIG_MS5611 is not set
# CONFIG_MS5637 is not set
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_T5403=m
CONFIG_HP206C=m
CONFIG_ZPA2326=m
CONFIG_ZPA2326_I2C=m
# end of Pressure sensors

#
# Lightning sensors
#
# end of Lightning sensors

#
# Proximity and distance sensors
#
CONFIG_ISL29501=m
CONFIG_LIDAR_LITE_V2=m
CONFIG_MB1232=m
# CONFIG_RFD77402 is not set
CONFIG_SRF04=m
CONFIG_SX9500=m
CONFIG_SRF08=m
CONFIG_VL53L0X_I2C=m
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_MLX90614 is not set
# CONFIG_MLX90632 is not set
CONFIG_TMP006=m
CONFIG_TMP007=m
# CONFIG_TSYS01 is not set
# CONFIG_TSYS02D is not set
# end of Temperature sensors

# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LPSS=y
# CONFIG_PWM_LPSS_PCI is not set
CONFIG_PWM_LPSS_PLATFORM=y
CONFIG_PWM_PCA9685=m

#
# IRQ chip support
#
CONFIG_ARM_GIC_MAX_NR=1
# end of IRQ chip support

CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_RESET_TI_SYSCON=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_PXA_28NM_HSIC=m
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
CONFIG_PHY_QCOM_USB_HS=y
# CONFIG_PHY_QCOM_USB_HSIC is not set
CONFIG_PHY_SAMSUNG_USB2=m
# CONFIG_PHY_TUSB1210 is not set
# end of PHY Subsystem

# CONFIG_POWERCAP is not set
CONFIG_MCB=m
# CONFIG_MCB_PCI is not set
CONFIG_MCB_LPC=m

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

# CONFIG_LIBNVDIMM is not set
# CONFIG_DAX is not set
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
CONFIG_RAVE_SP_EEPROM=y

#
# HW tracing support
#
CONFIG_STM=y
CONFIG_STM_PROTO_BASIC=y
CONFIG_STM_PROTO_SYS_T=y
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=y
CONFIG_STM_SOURCE_HEARTBEAT=m
# CONFIG_STM_SOURCE_FTRACE is not set
CONFIG_INTEL_TH=y
# CONFIG_INTEL_TH_PCI is not set
CONFIG_INTEL_TH_ACPI=m
# CONFIG_INTEL_TH_GTH is not set
CONFIG_INTEL_TH_STH=y
# CONFIG_INTEL_TH_MSU is not set
CONFIG_INTEL_TH_PTI=m
CONFIG_INTEL_TH_DEBUG=y
# end of HW tracing support

CONFIG_FPGA=m
CONFIG_ALTERA_PR_IP_CORE=m
# CONFIG_FPGA_MGR_ALTERA_CVP is not set
CONFIG_FPGA_BRIDGE=m
CONFIG_ALTERA_FREEZE_BRIDGE=m
CONFIG_XILINX_PR_DECOUPLER=m
CONFIG_FPGA_REGION=m
CONFIG_FPGA_DFL=m
# CONFIG_FPGA_DFL_FME is not set
CONFIG_FPGA_DFL_AFU=m
# CONFIG_FPGA_DFL_PCI is not set
CONFIG_PM_OPP=y
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
CONFIG_SLIMBUS=y
CONFIG_SLIM_QCOM_CTRL=m
# CONFIG_INTERCONNECT is not set
CONFIG_COUNTER=y
# CONFIG_FTM_QUADDEC is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_VALIDATE_FS_PARSER=y
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=m
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_F2FS_CHECK_FS=y
# CONFIG_F2FS_IO_TRACE is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_FS_DAX is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_AUTOFS_FS=m
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
# CONFIG_OVERLAY_FS is not set

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
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_FAT_DEFAULT_UTF8=y
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_PROC_CHILDREN is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
# CONFIG_JFFS2_ZLIB is not set
# CONFIG_JFFS2_LZO is not set
# CONFIG_JFFS2_RTIME is not set
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
CONFIG_JFFS2_CMODE_SIZE=y
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_ATIME_SUPPORT is not set
CONFIG_UBIFS_FS_XATTR=y
CONFIG_UBIFS_FS_SECURITY=y
CONFIG_UBIFS_FS_AUTHENTICATION=y
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_CRAMFS_MTD=y
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZ4=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_ZSTD=y
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=m
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFLATE_COMPRESS=y
CONFIG_PSTORE_LZO_COMPRESS=m
CONFIG_PSTORE_LZ4_COMPRESS=m
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
CONFIG_PSTORE_842_COMPRESS=y
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
# CONFIG_PSTORE_LZO_COMPRESS_DEFAULT is not set
# CONFIG_PSTORE_LZ4_COMPRESS_DEFAULT is not set
# CONFIG_PSTORE_842_COMPRESS_DEFAULT is not set
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set
# CONFIG_UNICODE is not set
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEY_DH_OPERATIONS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_SECURITY_PATH=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_LOADPIN=y
# CONFIG_SECURITY_LOADPIN_ENFORCE is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
# CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
CONFIG_IMA_DEFAULT_HASH_SHA256=y
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha256"
CONFIG_IMA_WRITE_POLICY=y
CONFIG_IMA_READ_POLICY=y
# CONFIG_IMA_APPRAISE is not set
CONFIG_EVM=y
# CONFIG_EVM_ATTR_FSUUID is not set
# CONFIG_EVM_ADD_XATTRS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_ECC=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_ECRDSA=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_AEGIS128=m
# CONFIG_CRYPTO_AEGIS128L is not set
# CONFIG_CRYPTO_AEGIS256 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
# CONFIG_CRYPTO_AEGIS128L_AESNI_SSE2 is not set
# CONFIG_CRYPTO_AEGIS256_AESNI_SSE2 is not set
# CONFIG_CRYPTO_MORUS640 is not set
# CONFIG_CRYPTO_MORUS640_SSE2 is not set
# CONFIG_CRYPTO_MORUS1280 is not set
# CONFIG_CRYPTO_MORUS1280_SSE2 is not set
# CONFIG_CRYPTO_MORUS1280_AVX2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_KEYWRAP=m
CONFIG_CRYPTO_NHPOLY1305=y
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
CONFIG_CRYPTO_NHPOLY1305_AVX2=m
CONFIG_CRYPTO_ADIANTUM=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_POLY1305=y
CONFIG_CRYPTO_POLY1305_X86_64=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
CONFIG_CRYPTO_SM3=m
CONFIG_CRYPTO_STREEBOG=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_TI=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_CHACHA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_SM4=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_842=y
CONFIG_CRYPTO_LZ4=m
# CONFIG_CRYPTO_LZ4HC is not set
CONFIG_CRYPTO_ZSTD=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_USER_API_RNG=m
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXX is not set
# CONFIG_CRYPTO_DEV_QAT_C62X is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCCVF is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXXVF is not set
# CONFIG_CRYPTO_DEV_QAT_C62XVF is not set
# CONFIG_CRYPTO_DEV_VIRTIO is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE is not set
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y

#
# Certificates for signature checking
#
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CORDIC=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=y
CONFIG_CRC4=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_CRC8=y
CONFIG_XXHASH=m
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=m
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DMA_DECLARE_COHERENT=y
CONFIG_SWIOTLB=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SGL_ALLOC=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_DDR=y
# CONFIG_IRQ_POLL is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_STACKWALK=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set
# end of Library routines

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_DEBUG_INFO_BTF is not set
CONFIG_GDB_SCRIPTS=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_STACK_VALIDATION=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# end of Compile-time checks and compiler options

CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_POISONING is not set
CONFIG_DEBUG_PAGE_REF=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_CC_HAS_KASAN_GENERIC=y
# CONFIG_KASAN is not set
CONFIG_KASAN_STACK=1
# end of Memory Debugging

CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_WQ_WATCHDOG=y
# end of Debug Lockups and Hangs

CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_DEBUG_TIMEKEEPING=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
# CONFIG_WW_MUTEX_SELFTEST is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PLIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_PERF_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_EQS_DEBUG=y
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_CPU_HOTPLUG_STATE_CONTROL=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_NETDEV_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
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
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_PREEMPTIRQ_EVENTS is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_HWLAT_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_HIST_TRIGGERS is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
CONFIG_TRACE_EVAL_MAP_FILE=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_RUNTIME_TESTING_MENU is not set
CONFIG_MEMTEST=y
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
CONFIG_SAMPLES=y
CONFIG_SAMPLE_TRACE_EVENTS=m
# CONFIG_SAMPLE_TRACE_PRINTK is not set
CONFIG_SAMPLE_KOBJECT=y
CONFIG_SAMPLE_HW_BREAKPOINT=m
CONFIG_SAMPLE_KFIFO=m
CONFIG_SAMPLE_CONFIGFS=m
CONFIG_SAMPLE_CONNECTOR=m
CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB=m
CONFIG_SAMPLE_VFS=y
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
CONFIG_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN_NO_ALIGNMENT=y
# CONFIG_TEST_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
CONFIG_X86_PTDUMP_CORE=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_EFI_PGT_DUMP is not set
CONFIG_DEBUG_WX=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_DEBUG_ENTRY=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# CONFIG_UNWINDER_GUESS is not set
# end of Kernel hacking

--Lunvpfy9DIRDIEcw
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job-script"

#!/bin/sh

export_top_env()
{
	export suite='boot'
	export testcase='boot'
	export category='functional'
	export timeout='10m'
	export job_origin='boot-300s.yaml'
	export queue_cmdline_keys='branch
commit'
	export queue='bisect'
	export testbox='vm-snb'
	export tbox_group='vm-snb'
	export branch='linus/master'
	export commit='2638eb8b50cfc16240e0bb080b9afbf541a9b39d'
	export kconfig='x86_64-randconfig-a011-20220801'
	export nr_vm=160
	export submit_id='62e9600ba17a45a1e060c218'
	export job_file='/lkp/jobs/scheduled/vm-meta-288/boot-300-debian-11.1-x86_64-20220510.cgz-2638eb8b50cfc16240e0bb080b9afbf541a9b39d-20220803-41440-1m2myuu-1.yaml'
	export id='a255cc6a3f5c7c62f06072a3b3cd4dc9ba4d39a0'
	export queuer_version='/zday/lkp'
	export model='qemu-system-x86_64 -enable-kvm -cpu SandyBridge'
	export nr_cpu=2
	export memory='16G'
	export need_kconfig=\{\"KVM_GUEST\"\=\>\"y\"\}
	export ssh_base_port=23032
	export kernel_cmdline='vmalloc=256M initramfs_async=0 page_owner=on'
	export rootfs='debian-11.1-x86_64-20220510.cgz'
	export compiler='gcc-11'
	export enqueue_time='2022-08-03 01:34:03 +0800'
	export _id='62e96772a17a45a1e060c219'
	export _rt='/result/boot/300/vm-snb/debian-11.1-x86_64-20220510.cgz/x86_64-randconfig-a011-20220801/gcc-11/2638eb8b50cfc16240e0bb080b9afbf541a9b39d'
	export user='lkp'
	export LKP_SERVER='internal-lkp-server'
	export result_root='/result/boot/300/vm-snb/debian-11.1-x86_64-20220510.cgz/x86_64-randconfig-a011-20220801/gcc-11/2638eb8b50cfc16240e0bb080b9afbf541a9b39d/3'
	export scheduler_version='/lkp/lkp/.src-20220728-201011'
	export arch='x86_64'
	export max_uptime=600
	export initrd='/osimage/debian/debian-11.1-x86_64-20220510.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/boot/300/vm-snb/debian-11.1-x86_64-20220510.cgz/x86_64-randconfig-a011-20220801/gcc-11/2638eb8b50cfc16240e0bb080b9afbf541a9b39d/3
BOOT_IMAGE=/pkg/linux/x86_64-randconfig-a011-20220801/gcc-11/2638eb8b50cfc16240e0bb080b9afbf541a9b39d/vmlinuz-5.2.0-rc2-00605-g2638eb8b50cfc
branch=linus/master
job=/lkp/jobs/scheduled/vm-meta-288/boot-300-debian-11.1-x86_64-20220510.cgz-2638eb8b50cfc16240e0bb080b9afbf541a9b39d-20220803-41440-1m2myuu-1.yaml
user=lkp
ARCH=x86_64
kconfig=x86_64-randconfig-a011-20220801
commit=2638eb8b50cfc16240e0bb080b9afbf541a9b39d
vmalloc=256M initramfs_async=0 page_owner=on
max_uptime=600
LKP_SERVER=internal-lkp-server
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
	export modules_initrd='/pkg/linux/x86_64-randconfig-a011-20220801/gcc-11/2638eb8b50cfc16240e0bb080b9afbf541a9b39d/modules.cgz'
	export bm_initrd='/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export schedule_notify_address=
	export meta_host='vm-meta-288'
	export kernel='/pkg/linux/x86_64-randconfig-a011-20220801/gcc-11/2638eb8b50cfc16240e0bb080b9afbf541a9b39d/vmlinuz-5.2.0-rc2-00605-g2638eb8b50cfc'
	export dequeue_time='2022-08-03 02:07:20 +0800'
	export job_initrd='/lkp/jobs/scheduled/vm-meta-288/boot-300-debian-11.1-x86_64-20220510.cgz-2638eb8b50cfc16240e0bb080b9afbf541a9b39d-20220803-41440-1m2myuu-1.cgz'

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

	run_monitor $LKP_SRC/monitors/one-shot/wrapper boot-slabinfo
	run_monitor $LKP_SRC/monitors/one-shot/wrapper boot-meminfo
	run_monitor $LKP_SRC/monitors/one-shot/wrapper memmap
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper boot-time
	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test $LKP_SRC/tests/wrapper sleep 300
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	$LKP_SRC/stats/wrapper boot-slabinfo
	$LKP_SRC/stats/wrapper boot-meminfo
	$LKP_SRC/stats/wrapper memmap
	$LKP_SRC/stats/wrapper boot-memory
	$LKP_SRC/stats/wrapper boot-time
	$LKP_SRC/stats/wrapper kernel-size
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper sleep
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time sleep.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--Lunvpfy9DIRDIEcw
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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
AwCNXGmtscRn+wIAAAAABFla

--Lunvpfy9DIRDIEcw--
