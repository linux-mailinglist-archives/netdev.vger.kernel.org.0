Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B9C595547
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiHPIbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiHPIaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:30:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D9F647F4;
        Mon, 15 Aug 2022 22:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660629195; x=1692165195;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ok4TBIOS/cV3eZGm5inuQPsh2CQvjBAfU8xUHEUSuIE=;
  b=K7v314zQCcNG/u55904i+0xarfpA9CK3+Yy4l62VmPlWW70zyFFh5xDW
   dXZCxfT0XwTqg3uAzA2879jGIcM4PAtsscuUkxiEw8QmUPM7c3Wn7GO5l
   UvETKwCKDHskFcU4y5osOTGgrosm7DlzhziFMxbJ+n8IeG5v/8eBp2AsB
   zgaKiJFxuGbmF+McEq2gwD/uhGETnvSEyUyNL7ABrDi4tZP5qCOz+tmtY
   SvEn068W998JJi81tRny5faOYca7X3lxDWs5Dv5b7X6fc3SmwPm4LgVdh
   BHEm7nVl4du/1gnmhIerfdpNnkUzSmILsNbu6lf7aY2IT5srDPlZmJeJJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="290885692"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="290885692"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 22:53:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="934765887"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 15 Aug 2022 22:53:14 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 15 Aug 2022 22:53:13 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 15 Aug 2022 22:53:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 15 Aug 2022 22:53:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 15 Aug 2022 22:53:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBPf0bqOa3SRNMOoY/B/m3yheVeHSnaPFOlMPEiF5sS9KdzkvTv3pOGHC0xGJ+g/7k1n6RHVacS0yAIVsE3i5EN/KFHI9sq202aKt/834uazbAlqqY+GF4q/2EyLiDZ6JfDJUmXr84kIRGNVzNaHkQbC6D6sWQC2csQR7fFlzrelOL3ZY5Xv9ml3HJ621Mo43Nj6CymJkDaSh1M2jlCrLyPg20gdhJ8SvzxHmt/S+Ddy9zKb8AR98YC2ORbB8FBRM6p1C52PaWEB0EE6yjoUH3tgJKkr9+naeB7vVh7RjDWDKVn4562EGCOkaEGM/5oF5IJWRKpvrQTUR/B8+Tli9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3w8elYUL2w9tY7LpXB1xsarV1NvBGgrOkQXLSxPPFA8=;
 b=aoSfA2x7HMUeB7H7yutMZuvW0pyk+2kSYv4tm73fW7VNoTWDehzNpwYpWBGuR+IxLGLCN/0x3LirjWm/6+EV/Wg05N9f57m0HycGTaH/UUaYkeSIjwqF2xxMf6oyw+eXuBw2A6KW3uQlfThtXFwAuhiN033rMk7gX3/UH25348aNtnJOumOLdPD/VbOBczD9UhpZCsN/8lfr0ogoryvrfGfehpjRt9cGgLSnpYHpXFpANqwpObIFyGP+u2C/A7vS8pAkjjCv3gOM5pYTNwre9rzzrse96jDbqxSPnLg4vKpBlWhEMd+vxCqmqqLde/e5bKY4+tvZ+E9j9EqlnwECHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6297.namprd11.prod.outlook.com (2603:10b6:a03:458::8)
 by CH0PR11MB5364.namprd11.prod.outlook.com (2603:10b6:610:bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 05:53:11 +0000
Received: from SJ1PR11MB6297.namprd11.prod.outlook.com
 ([fe80::f906:b045:d73e:8e49]) by SJ1PR11MB6297.namprd11.prod.outlook.com
 ([fe80::f906:b045:d73e:8e49%9]) with mapi id 15.20.5525.010; Tue, 16 Aug 2022
 05:53:11 +0000
Date:   Tue, 16 Aug 2022 13:52:58 +0800
From:   Oliver Sang <oliver.sang@intel.com>
To:     Feng Tang <feng.tang@intel.com>
CC:     Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        <lkp@lists.01.org>, kbuild test robot <lkp@intel.com>,
        Huang Ying <ying.huang@intel.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        "Yin Fengwei" <fengwei.yin@intel.com>, Ying Xu <yinxu@redhat.com>
Subject: Re: [net] 4890b686f4: netperf.Throughput_Mbps -69.4% regression
Message-ID: <YvswusNaC5yr+HwT@xsang-OptiPlex-9020>
References: <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com>
 <20220627123415.GA32052@shbuild999.sh.intel.com>
 <CANn89iJAoYCebNbXpNMXRoDUkFMhg9QagetVU9NZUq+GnLMgqQ@mail.gmail.com>
 <20220627144822.GA20878@shbuild999.sh.intel.com>
 <CANn89iLSWm-c4XE79rUsxzOp3VwXVDhOEPTQnWgeQ48UwM=u7Q@mail.gmail.com>
 <20220628034926.GA69004@shbuild999.sh.intel.com>
 <CALvZod71Fti8yLC08mdpDk-TLYJVyfVVauWSj1zk=BhN1-GPdA@mail.gmail.com>
 <20220703104353.GB62281@shbuild999.sh.intel.com>
 <YsIeYzEuj95PWMWO@castle>
 <20220705050326.GF62281@shbuild999.sh.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220705050326.GF62281@shbuild999.sh.intel.com>
X-ClientProxiedBy: SG2PR06CA0200.apcprd06.prod.outlook.com (2603:1096:4:1::32)
 To SJ1PR11MB6297.namprd11.prod.outlook.com (2603:10b6:a03:458::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 883e8d39-9f8c-406b-c6ec-08da7f4b9a14
X-MS-TrafficTypeDiagnostic: CH0PR11MB5364:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hqC/pYE4tJ1yHCAIAt4q71bNGYvb1GN8sREkSl+/go0DTBiqjX6hA2RZOhuN4R//SCHHVmOin7Un6z4KF+ClU28dUh/aODN8R8ZjWKkqakhi9zneX1mcnHL9eAE0hAb2scYhGWxZ2+aYHUgAU8r/3ogIKoJ95J7VZXhkNY/PhrAgIdO1ujdGv/qa8JHTtz9zpDnQxrjRB65DEC++1/gxfAQ4oFna5leF8sMukRVjOmJtzeKOv/xOLWQDov50O9IFGNgQldmLlL3fKuIhJZGrtKIHgg/88E4sGUh6mUCUd6rw8iEbb/ViHSL+QnXoREVZUrbJcn6YPjlylf9uSt+Fs0adwGvA4Me9q5ZwY788+l3r5rG5C95Lbj+W5f53uGDRBo6dZeIp4kZ2c7k3OqbWqVz4DYDpX+/ZPTGd6rlxGt6tpSkzC4cuu666srXTvI+uPsherICEJ/iCZwaqKsKJx4X4Nkt8ozBP42tyM+u8Q8JX8/JbqS12fo9cKx42pKYwrNVP35ja/S+ECoAhp57kwg/TSXAhkNOOvCpl8RDCiSr1pcSnyxn8aaU5sETRepNQAs3cgGfDIpepfTNBx+HVP8p52Bb9ROe2dZt29wcG1K4Ov6DsLtMaaaZ4Yfy1Fp+06Cr3qEJXvksrjS+Z5c2eLrIo1Mjib0qlQVD+Q5d224Yr55fzhWiYZL0WsNtzbKVx0JUQzXqW2qKcvJ3KaYMKGeoWrS0yHOmbzBOo0L0l/rMlogG2B7ilRrbaYAs7zKgaUNpUlKSrIRwFwjyw/kQ3Hf20ym9DwbXSKJi07o6XHmc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6297.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(376002)(396003)(39860400002)(136003)(346002)(186003)(86362001)(9686003)(6512007)(41300700001)(6666004)(83380400001)(6636002)(6506007)(53546011)(54906003)(26005)(4326008)(33716001)(316002)(66946007)(66476007)(44832011)(6486002)(82960400001)(5660300002)(6862004)(8676002)(66556008)(7416002)(38100700002)(8936002)(478600001)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?8/FNh8ljE2YfgAoHrT9xgSs/LeR50MOskgtLpL8Krjtj9EJAtmESdYegdL?=
 =?iso-8859-1?Q?1CLIkd9wZQFtQrvAzE78vSVrPTQV0AkcJL/y8uXD9s+wlr0YCFSgpLpqju?=
 =?iso-8859-1?Q?2tz6m88Dk05PWDL3H19/oOe1UgURYLwQCL5o6yRgvZGFhvjaFbEJnxo0WS?=
 =?iso-8859-1?Q?iNy8IkyqbvUKdX/gdHJAB+1rxIrUi3O8ShRqMTce1Oe1PHS+mx8X9OBW+k?=
 =?iso-8859-1?Q?/hMw80n7NszOPXAFl/+CyEepy6tHyMuvJUs7zsa7u+v49CnAaTz8thLuQy?=
 =?iso-8859-1?Q?Y4NfK0lQeWx2bAQdzTpecRJc7FFX2eIxMZqswgazeAxrR0Gk/eAW3/sChk?=
 =?iso-8859-1?Q?4foYCq42BNE2AirMKZTMqvbdduqmTyZFonoR6jbizs8PH/kPYVyA0xDQhV?=
 =?iso-8859-1?Q?WKBoI/f4AiftPDbhS1MIWYV+7RYY9LlLRtSEUVtZ6M9TiFd3IhNZMd7TOe?=
 =?iso-8859-1?Q?Ctni5SgFw65TNN7RmG/AWCSwKNjFdYf24hg84qOb52M9MiYcpERSS+0sIP?=
 =?iso-8859-1?Q?vDCdZRbuNRTYibAER2vaCIqPS9XAcvOrumfjZVhQ02qBX6/jcu4apGJ2uQ?=
 =?iso-8859-1?Q?P+nBh7H7TzNH3RjmArBZVrefqvvl8gNEusUaefL9ssyP3TGuinlzZY9NOL?=
 =?iso-8859-1?Q?TIAxWJ+gB7Iurp+2HzM1Drz5b4dHyUi6Bl5AiovxWaqrrAuLa/pDOSQ/kE?=
 =?iso-8859-1?Q?LwNlOgmuobFONVox4vS1rbjbVAhkZmztDt7dhEJ7p1T9QDGDUVpH++c1gg?=
 =?iso-8859-1?Q?/LiuLc69WycNq4NITbig8sEC0Jh+cGBlVID6S/SBqFb+mTxnrOstF4sIPE?=
 =?iso-8859-1?Q?+VAg76R9zxa3AVxwdgF13uuaFvlqwZbqXMyVN7MSm8pBhz4Bpux8O9yJpq?=
 =?iso-8859-1?Q?cLTyKINtZgDZ2imcG9hFbcxFfwYzRJpDWjY76NHxQKwM+vS6GJXhX9QBJe?=
 =?iso-8859-1?Q?RzFC1yg242nNRDEDT+gf4NXFl39fAIAZXnr5ABa3JMCuwj4W/icv99rDmk?=
 =?iso-8859-1?Q?rsgEXrtw9dRt6nQdTME6J4wwV1QzItl7K9j8GngrIMJHzvB9nT/hjr8Js4?=
 =?iso-8859-1?Q?M3I8JKUJeTxoogr6DViqJX4hO24QRPQIIQ/M5shE1rWN/VseG3g/hJffC0?=
 =?iso-8859-1?Q?KsuO/vYjuEMgs/xrb9JtZ40KX+OFEUymOvvF9RL+OVPFBapIcA4UGzsqSz?=
 =?iso-8859-1?Q?OEyKBEQ5xCLRlE7WiNobo6sDVgV4Edpskpe6liKdIVcu3k/u7hxQMl8DmW?=
 =?iso-8859-1?Q?ktiNH/fp14sD4XfFDVIdUpifY+ZNbaEFlWP70Tkts1sxcuSxAzm0QFSCz0?=
 =?iso-8859-1?Q?bH67nRTH/O3cAVzPdQhvjcQ8YyMncOyiZQZPM2gLbwo6qXZnh97NftNVXh?=
 =?iso-8859-1?Q?yMoDWlT3FFEm5vDlXWu1qAFd74O648CQTBSOztgrASD3vgN6mgYJjzN2HW?=
 =?iso-8859-1?Q?mVEQaqCWHoDXmxxe8vUP6ynVAYbNNjcIYcapHq4LEtHcUoeAtJnPu34514?=
 =?iso-8859-1?Q?1DBdu9nuqxdAamLBqbcKCaUL4hphD9VIRnI4x2ha51oasc7w/1Bqo4ddkd?=
 =?iso-8859-1?Q?zwqSXqECTKhcrLq1v8KLj5I8bDBDZZGJ/3+7m6waTSkKfoXj6uIiBYQ6p5?=
 =?iso-8859-1?Q?3w78b5+osy3G4olLZJSn/nBqzql1GTXv1L+tEkQUOoAZHYPXEeC20nkg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 883e8d39-9f8c-406b-c6ec-08da7f4b9a14
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6297.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 05:53:11.5361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUTF15pius4neQ4oLJkJ0pI0Y2G3YTQXKpBv/4qePUQZ5cErPDPpaOS+kYLvMeaYzLreTMB7ClfwYNNNSAFfLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5364
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

now we noticed this commit has already merged into mainline, and in our tests
there is still similar regression. [1]

not sure if there is a plan to merge some of the solutions that have been
discussed in this thread? we'll very glad to test patches if there is a request

Thanks a lot!

[1]
=========================================================================================
tbox_group/testcase/rootfs/kconfig/compiler/ip/runtime/nr_threads/cluster/send_size/test/cpufreq_governor/ucode:
  lkp-icl-2sp4/netperf/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3/gcc-11/ipv4/300s/50%/cs-localhost/10K/SCTP_STREAM_MANY/performance/0xd000363

7c80b038d23e1f4c 4890b686f4088c90432149bd6de
---------------- ---------------------------
         %stddev     %change         %stddev
             \          |                \
      9078           -55.9%       4006        netperf.Throughput_Mbps
    581006           -55.9%     256385        netperf.Throughput_total_Mbps
     36715           -54.6%      16674 ±  4%  netperf.time.involuntary_context_switches
      1885           -50.2%     938.33 ±  3%  netperf.time.percent_of_cpu_this_job_got
      5533           -49.9%       2771 ±  2%  netperf.time.system_time
    152.13           -59.5%      61.61 ±  2%  netperf.time.user_time
    418171 ±  5%     +89.4%     791954 ± 17%  netperf.time.voluntary_context_switches
 2.128e+09           -55.9%  9.389e+08        netperf.workload
     30217           +17.8%      35608        uptime.idle
 2.689e+10           +20.3%  3.234e+10        cpuidle..time
 6.366e+08           -48.1%  3.305e+08        cpuidle..usage
     70.26           +13.5       83.78        mpstat.cpu.all.idle%
      4.46            -1.5        2.92 ±  3%  mpstat.cpu.all.soft%
     23.71           -11.6       12.16 ±  3%  mpstat.cpu.all.sys%
      0.89            -0.5        0.38        mpstat.cpu.all.usr%
 1.392e+09           -57.5%   5.91e+08 ± 12%  numa-numastat.node0.local_node
 1.389e+09           -57.5%  5.906e+08 ± 12%  numa-numastat.node0.numa_hit
 1.369e+09           -54.5%  6.226e+08 ± 12%  numa-numastat.node1.local_node
 1.366e+09           -54.4%  6.222e+08 ± 12%  numa-numastat.node1.numa_hit
     36715           -54.6%      16674 ±  4%  time.involuntary_context_switches
      1885           -50.2%     938.33 ±  3%  time.percent_of_cpu_this_job_got
      5533           -49.9%       2771 ±  2%  time.system_time
    152.13           -59.5%      61.61 ±  2%  time.user_time
    418171 ±  5%     +89.4%     791954 ± 17%  time.voluntary_context_switches


On Tue, Jul 05, 2022 at 01:03:26PM +0800, Feng Tang wrote:
> On Sun, Jul 03, 2022 at 03:55:31PM -0700, Roman Gushchin wrote:
> > On Sun, Jul 03, 2022 at 06:43:53PM +0800, Feng Tang wrote:
> > > Hi Shakeel,
> > > 
> > > On Fri, Jul 01, 2022 at 08:47:29AM -0700, Shakeel Butt wrote:
> > > > On Mon, Jun 27, 2022 at 8:49 PM Feng Tang <feng.tang@intel.com> wrote:
> > > > > I just tested it, it does perform better (the 4th is with your patch),
> > > > > some perf-profile data is also listed.
> > > > >
> > > > >  7c80b038d23e1f4c 4890b686f4088c90432149bd6de 332b589c49656a45881bca4ecc0 e719635902654380b23ffce908d
> > > > > ---------------- --------------------------- --------------------------- ---------------------------
> > > > >      15722           -69.5%       4792           -40.8%       9300           -27.9%      11341        netperf.Throughput_Mbps
> > > > >
> > > > >       0.00            +0.3        0.26 ±  5%      +0.5        0.51            +1.3        1.27 ±  2%pp.self.__sk_mem_raise_allocated
> > > > >       0.00            +0.3        0.32 ± 15%      +1.7        1.74 ±  2%      +0.4        0.40 ±  2%  pp.self.propagate_protected_usage
> > > > >       0.00            +0.8        0.82 ±  7%      +0.9        0.90            +0.8        0.84        pp.self.__mod_memcg_state
> > > > >       0.00            +1.2        1.24 ±  4%      +1.0        1.01            +1.4        1.44        pp.self.try_charge_memcg
> > > > >       0.00            +2.1        2.06            +2.1        2.13            +2.1        2.11        pp.self.page_counter_uncharge
> > > > >       0.00            +2.1        2.14 ±  4%      +2.7        2.71            +2.6        2.60 ±  2%  pp.self.page_counter_try_charge
> > > > >       1.12 ±  4%      +3.1        4.24            +1.1        2.22            +1.4        2.51        pp.self.native_queued_spin_lock_slowpath
> > > > >       0.28 ±  9%      +3.8        4.06 ±  4%      +0.2        0.48            +0.4        0.68        pp.self.sctp_eat_data
> > > > >       0.00            +8.2        8.23            +0.8        0.83            +1.3        1.26        pp.self.__sk_mem_reduce_allocated
> > > > >
> > > > > And the size of 'mem_cgroup' is increased from 4224 Bytes to 4608.
> > > > 
> > > > Hi Feng, can you please try two more configurations? Take Eric's patch
> > > > of adding ____cacheline_aligned_in_smp in page_counter and for first
> > > > increase MEMCG_CHARGE_BATCH to 64 and for second increase it to 128.
> > > > Basically batch increases combined with Eric's patch.
> > > 
> > > With increasing batch to 128, the regression could be reduced to -12.4%.
> > 
> > If we're going to bump it, I wonder if we should scale it dynamically depending
> > on the size of the memory cgroup?
>  
> I think it makes sense, or also make it a configurable parameter? From 
> the test reports of 0Day, these charging/counting play critical role
> in performance (easy to see up to 60% performance effect). If user only
> wants memcg for isolating things or doesn't care charging/stats, these
> seem to be extra taxes.
> 
> For bumping to 64 or 128, universal improvement is expected with the
> only concern of accuracy.
> 
> Thanks,
> Feng
> 
> > Thanks!
