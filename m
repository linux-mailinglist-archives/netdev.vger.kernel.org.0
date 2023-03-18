Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C636BF73B
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 02:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjCRBgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 21:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCRBgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 21:36:52 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F02C833C;
        Fri, 17 Mar 2023 18:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679103408; x=1710639408;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=aLqYn3u30tKkWIID5YBseu3yjn26yN1pZ4/1eG84vcA=;
  b=K/6pAh2FMTvcjwyTsxWq12CSI9d0ktzQRkgdW/+4Tp0FyAmvOUEH6tjY
   Fb2JUxYmOCcBw2BkRS2wKoCnniKV3sI8ZX8JOeYqgf65r3pwH3ynqpwXS
   hcqPY3IswWgAq3x5IcsBBk+PBtE852wpvD8hoH1PTd4ixLkQrXl2r4S3j
   1C+Tv1F4Cdt0JHNhytWoR9955f6QoRm85O1QuxZNZJepoB/5Fl5Rr4USz
   417XcQYJcP+2F45vUKk6Z3geavs8KaH5oqi03oUWbryPYM5ukBs1Q6UKF
   oapoOQWFT/Xu0vA7p3csp5Ldxc040Q9H3BHcGpcxN52vT0IrcXtEIIlVF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="318796844"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="318796844"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 18:36:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="1009865824"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="1009865824"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 17 Mar 2023 18:36:46 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 18:36:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 18:36:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 18:36:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hluSKafRtG4/XE1c214pnBwe0WxO785ju2ZDHqUcVCb3cDcWf0nUXEAbYsafM3/9Jk/xyGPZ5Re7Fmuz0hKq6sFflGO5EoeZsqlJjF85qWsVY+by36+IW0SezPno5vZhU0PHkAwAVKv2V65sFWkHb9Sse40kA8yiIuOCbcmIqwbEZEkRD79KhZIlmTiTSfEEjlawJ3lqvtMX8EzSaTpT27iytFTtSFN7rMIO3RW3c4RRiL0arj8lp4cxh7pl+grRnthzghOGtpR5UKOJ1K/Cv6WU7eEc12uQhnyNyw/CcB5Q2Dp37EEaxZYthvF4X2+XuvTkvyWhf0Yhzf3yjB0q7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEAO3aw4BGkCiE6PEEpP1WtiT5b36L/x93l7sU/zwRQ=;
 b=JvV4rB8PLNSZB5e+d999SIe6b0AT8LAiU0A7NpZJyW6vzaCzF5UWPyLxqgX/Ulr7w+qyzn3QYqLQ3/qEBiO/wgeLxiQJjOiQ6ss2wosThmspc7c1LAdCvJK4v168TaQkeUWxODetAwyWjFN8TrS048CeTTKbd0zf2UQAuTQEiB9+u5wKoDxflwtCn+dPMzypQ6hzWRbHHQuwJiMx9M/nOT96+Mt1kofUh8x4+curLThF36WEU17fq2KeS15omNJtCWdWEpjGYYjjx70I/MLVtjK5zvoGZGz6a8ZsuK0oxcWQIspJ/xERPuxk0XDi3fPtfl8emCYz0mczRV73MgPBJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DS7PR11MB6272.namprd11.prod.outlook.com (2603:10b6:8:94::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Sat, 18 Mar
 2023 01:36:38 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff%7]) with mapi id 15.20.6178.024; Sat, 18 Mar 2023
 01:36:38 +0000
Date:   Fri, 17 Mar 2023 18:36:34 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Sumitra Sharma <sumitraartsy@gmail.com>,
        <outreachy@lists.linux.dev>, <manishc@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <coiby.xu@gmail.com>,
        <gregkh@linuxfoundation.org>, <netdev@vger.kernel.org>,
        <linux-staging@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] Staging: qlge: Fix indentation in conditional
 statement
Message-ID: <641515a2a7b8d_28ae522945f@iweiny-mobl.notmuch>
References: <20230314121152.GA38979@sumitra.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314121152.GA38979@sumitra.com>
X-ClientProxiedBy: BYAPR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:a03:60::38) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DS7PR11MB6272:EE_
X-MS-Office365-Filtering-Correlation-Id: da9ef222-f594-42eb-f7a6-08db2751379d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BGD7hviDl+rrh9GqtQj/plu57Cs46mD/GSitPlEWLnFV5XFrMzIa2P0U+Gql4Mx3ajnFuqC56HgmFfimHNWpSbQT2uGJ2Q5P98ZZARjAbiaI8ngMJ1LZdtyW/5yj+42GOLVMIStR18vFNTDX4Obti8wpgT+injdZW+Bxh+oeHJYOj//PRQJR07WxPnefcHZVC2yXvOqbKQgm2PPaYkAsOnJLy8J/V/j51RI9co0tqJDbA8OkCEksQ1xgC/wjOxTXem3HMDEUewVJbI8KVUhrMbCDQg6a4pG0Ffp3xfc5bcU6cbptsK74myyB5ey4vMIA7D6phm7/HyhraS7dLWivAKz0tDqA1f4FynQBkdu1QrauSJI/d7bdq86WdM34R8T6iDzVtk/tmczjK88QBE2NxkKvd38GHnKc779vZ97OWNcq6GYVST18GSDCWaoF50uGydSYRiQ+iLH5ruQWatbetl30Dp7VlOofQAP+spNarKdD5XetqpfzPPPKNlf13X5EP1BxVYsstDpZGtJ5FaU1IQQuzeFi6OAaQf/rV3e/i5pcAXC1HL6PuTyvjWIFFdRvi3SzJHvGlvE48QvopnwrbKOm5KleU36QFLFYP9vIukBu14ST77PVy/V7USMn+qhv9u2FjKYk35XbqSUEcBS2Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199018)(41300700001)(66556008)(8676002)(66946007)(66476007)(38100700002)(82960400001)(86362001)(558084003)(44832011)(8936002)(2906002)(5660300002)(478600001)(186003)(6486002)(6512007)(6506007)(26005)(316002)(6666004)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xs47iYOQj4OKRjIalOTeGdH8cnettbpQPTnSLVxRb604IpB/r18FLlx/4a1A?=
 =?us-ascii?Q?pwYldajQ/aZP3LmdiCnaQx5d5wSK7/mKpOM5PdonL+ephBxZ9gds3jBeoXfU?=
 =?us-ascii?Q?16pCk+x2eEfYBgkgQcUvc/AFR2RC2wOMp061cGFf75E6suhQLFmlE7jeQhBr?=
 =?us-ascii?Q?C4EWKw6L+sU8VtYV/9QTuEu01PwieoGfDj4P0mM+N+XsNGQy4yFDo/H6ya+o?=
 =?us-ascii?Q?9Q289BQDi7/RJV2yIiGp8cieoIiQPyxqRljcfcYYJIs6mhlGEJp19qvI8fRX?=
 =?us-ascii?Q?O5tZ2sc6g2NM2bXgYpf8nbeSAvceHd/ONEh5E6KivNZFHCL+YBco0/keAflu?=
 =?us-ascii?Q?i9/2mn7Mj6N3iWd3Mg2C5sChOIz3r/cqrzh7odgpi68z4oKhIW3PFJztJ/He?=
 =?us-ascii?Q?JkJhHTdRAfvIUcIeZQZ1LorAeDkHt/2THqErkktorVapK17qUAOOIAwNmdPF?=
 =?us-ascii?Q?0SvuCdQTqwxQ1YQWmKFyR4r2z6mK+1yG3ZUCrgDbQWsYfkrQjYu8TTxHW408?=
 =?us-ascii?Q?OsqbXsVxklDGNxBLtrVCArD6DS03KHv7Je4z4ZV53bttHJQ7qUk5OIsTc8GU?=
 =?us-ascii?Q?zj5IR7u3OMrpA1wGavmSJ/lGVxmGKoVSmYYQFjqybIfQv6V/UPuShXeG4e4T?=
 =?us-ascii?Q?yzkRALWd3SadyByejF4BvG7m97z+C8cXe6DuDJ74IHf3b5KEClRNN4U6Wv+D?=
 =?us-ascii?Q?dWF0ec4KcGTq7hwOMtdzPrxLSp0yeG7Hv/HpikNnChDlItx7KqatgEeOlUC1?=
 =?us-ascii?Q?Kq/jo7mjKzXh/Q20CMLmO9uBqEbTFHlmcna0zLXttPGPd0MLGxgX+sBpuIFe?=
 =?us-ascii?Q?wWYu6JKESR2Xeq4tpqlc0BV1ySExFUabnDM1SalC85czpprN3qug4qBxsIG8?=
 =?us-ascii?Q?aW6hVc8IinwH+1frveQmJw2oikbPmiijvHU/8JfvOF8mu13aUczXITdkJtUi?=
 =?us-ascii?Q?WoWIHoW6RVw1wN4o9Vkqnkfn4L3kmBF4se46zjkPSB+d/clXadS0cftxYsOr?=
 =?us-ascii?Q?BdW2ybL0V6hOHBGp1rgrmjZzVmmDkrpLaQT+1/DHCO7YlXSXMc8LcIZb3o7I?=
 =?us-ascii?Q?M83+d1Vn+LSJH4JsBLSnE8I4n2wE50dtqcwDDdXN6E6z3g9SY5z4tquYYudO?=
 =?us-ascii?Q?CYi1dJhPs510zSDWQNsp3BAzC0GDmt/ic9F3vTRRlpXkUHNB5XFbmzsMIzvV?=
 =?us-ascii?Q?4/R114OummGrVnDMOaDlrjuWoDSsCb0pdacpDwfghuu/NvXgwC3nAAwuhRNs?=
 =?us-ascii?Q?5nQIX60F5zwwEVXybv9MfjOzSK2qj4DyLAEACiHCHsnS/aYMLeNjC8SiCK6Z?=
 =?us-ascii?Q?3PPm7nS5Da4p8zRyE2H9heVOK2Iex7vv6o2bCWipYrQvJzUhod92V0TmAb1W?=
 =?us-ascii?Q?Fov7X9rxam/m8Cz44wfnF8vJfcy8aTKatkWQzOHmTp9NMmA/7m/ACxzFkzF9?=
 =?us-ascii?Q?SzjBwxwVTmBCyyeKwIt6SNKGwxtJJ4u4Dd2jmqMz5KFegPj5TEf/wPOVOOxH?=
 =?us-ascii?Q?6m4KxC3xBMI03UsTvudyr7RPZWIuLzK6GPkGdzmcunkA1gZbOl5lX8CTHre+?=
 =?us-ascii?Q?L4r7Bs7hxZt70712MAkAV69LF9I0F/wUJmdiw5kB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da9ef222-f594-42eb-f7a6-08db2751379d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 01:36:38.4495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5H3/mkxzfJTTRi48Qsmj1ivaMK/T3GtIIiqaEY7pD7h42gAI1jtA+zmWfVLNv4CGtLbbRIyA66q1x6paVxDkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6272
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sumitra Sharma wrote:
> Add tabs/spaces in conditional statements in to fix the
> indentation.
> 
> Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>

LGTM:

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
