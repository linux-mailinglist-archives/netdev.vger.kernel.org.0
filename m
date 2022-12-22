Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DB66546EF
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 20:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiLVT4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 14:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLVT4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 14:56:45 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7D519021;
        Thu, 22 Dec 2022 11:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671739004; x=1703275004;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=MZwVDRGg39JMKDu0r99clAhAaWH4PkVMHpXyXMqbYHI=;
  b=OgflItj8kHLhfrSGjXcunfC3Ondhibp/C5C0xJJEHnhIOiGOxdYO4HFP
   9B/iVa1uDvY7Nci5R3jP/xvkqjW1QGosSbLBBjRDHcixGRTJRXTb4JzOl
   yNekzqKSVGf4DChLZJAV06ztERv7v/NiSqxE0YAtl3lvz37GYkVywvE1M
   81l63YoZVPAJDqFPhmAlNRUWMStrzbrmp7uV+qw1tdED08O3fo/GZBQ9r
   u+1cclpKdcpWTX6iljE+Dx+KgQc0uHisMlVnR0tG3VGQypczcsixU1Pi/
   0VsBOWVCKIvXOezgdILrcZtlSEo7PctfFzUTqqwZV/VwkIsJ4vAiE83yQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="382462916"
X-IronPort-AV: E=Sophos;i="5.96,266,1665471600"; 
   d="scan'208";a="382462916"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 11:56:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="826080789"
X-IronPort-AV: E=Sophos;i="5.96,266,1665471600"; 
   d="scan'208";a="826080789"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 22 Dec 2022 11:56:43 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 22 Dec 2022 11:56:43 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 22 Dec 2022 11:56:43 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 22 Dec 2022 11:56:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=La6hv0K1g2CxFg0aJdDKm+0REMWTPlTYaJJKTV9BARNEf0BysfipudIDM+8bfRafjM364F4R/i8SqdhMdYNMHJC1FQ/3+d+ch+skiQ7yPqfM9esGH3lkaM/9fR1gh5LYFwzbRWzWG/R6Kc7j0ZZOAWe/PH/0qchIp3dy4YNhYFxXKWTbrqkGSTpX4AVASRdOTsBmFiaocsLpKOI6G8Oc1YiNTU4trr3NGAkAiD0AouSo/p4xetXCzQNLNacPVymcx3xeuG1ijxJILGF1Y9280jTZkkYPKESe537FDG0rJXhzfjq26f1Ru58uriu70adqMOXj+7dUILBxYAzMqySg+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzIVY77WnzSGCA+VpIQsrRksRcUfADrXk06yE+39T5M=;
 b=NederfCD14C1Pz+dFo92fDorDjrB2pmZkLOGPQW4ZiDK9Se3GymqfgHTwxeSG9Xbb3SFlufSEbfcEEztY2oFXj7OOlgoqvVLbbtg3T9U+d7KjrHk+TuZVaMmbfbcT1WU+4p+JqbPOin/kc46tIBSIksmd7PXfIZy94KK9iRnbJNPf0w50uSSCbHWx9Ykjhz43S9VGMfZsi7F+5uBvH+hk23T9/knH2wYDjn7xIFnn2vvcZapezifFmEMUmQIHOPZd9Y76dAFnwLBhH3Re+Ww53UgmDC9EF5nOU9Nb6NgaqGs1p2/FtcttChQIYWacFHC+bmsvp82Az73v6ilIskTtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 (2603:10b6:405:51::14) by DS0PR11MB7507.namprd11.prod.outlook.com
 (2603:10b6:8:150::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.12; Thu, 22 Dec
 2022 19:56:42 +0000
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::5d3a:5bc9:4e57:622e]) by BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::5d3a:5bc9:4e57:622e%7]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 19:56:42 +0000
Date:   Thu, 22 Dec 2022 20:56:39 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Clark Wang <xiaoning.wang@nxp.com>
CC:     <linux@armlinux.org.uk>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mcoquelin.stm32@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/2] fix mac not working after system resumed with WoL
 enabled
Message-ID: <Y6S2d6mQ+Vl+wp+D@nimitz>
References: <20221221080144.2549125-1-xiaoning.wang@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221221080144.2549125-1-xiaoning.wang@nxp.com>
X-ClientProxiedBy: FR2P281CA0015.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::25) To BN6PR1101MB2227.namprd11.prod.outlook.com
 (2603:10b6:405:51::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2227:EE_|DS0PR11MB7507:EE_
X-MS-Office365-Filtering-Correlation-Id: 57b069de-6557-48f9-8213-08dae456a53e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0SP3fTV7EA1Xw9oLbbPDbGO6XhpWRuK5IqM/bieCGKNiMD0zXuz24qofi+utv8zTOhk9/T6DkoAmrbAIuzcxT7ndB/2oyUUJ2HdO2Nj5Z8HmpSEPvqo0oIBy2tF1cECX825aUQ5HDdlzx3Y9HfeJ3nEOQWmFn5nd0TcRQ4O7cwRa10nAYhVHE/WVmMYuaVrdCcsSeMB44slxT4RuR7tRXEAsCEemkg60RFxszIYYLYKw8b1Fbxd3Cwt7FGTGoNmZsyYTnwdkyUDo1KSJolXso15mvIVQWY1UOSMRvVGgwwShfIdmkrkavNABWDEk6scpDKdRpSQU1JSRqj1swzQM9CbfeuKxf5wOXTyAI40cJ4+Y7Oijc291pbGzbPKvRLKAsb0uKnovzkqWyu1U7abKJ60KfqgK7ANmDHOfGiYMY9MpDOyc2FmADoi8gCsb5gkTwoo0mt7cRkG+k8DDB+lX4nxVxMXHLWtBiOox0V7WTNwmtAfUT4N08iG7zQFPRHCyDP457xV6IZXxbf4veVQVILLnuu2Z7TEQdLhZVbl64JsSMw603N7hDau1tFLXaMgmGwBxfivKxjMeS+2WERKP8wbCIQxqndMPVbXnQquyc0jpt23+26LyKAiNjx21e7Fl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2227.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199015)(4744005)(44832011)(478600001)(8936002)(8676002)(66946007)(7416002)(2906002)(66476007)(66556008)(4326008)(5660300002)(6916009)(316002)(6486002)(6666004)(6506007)(33716001)(186003)(6512007)(9686003)(83380400001)(26005)(38100700002)(82960400001)(41300700001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KpWwIvcoCcBDrBmQox5ZgkSvKota3buOcdVTxo+p3rwBNR28HoIHrUlqdsdg?=
 =?us-ascii?Q?pyetuiM+v6yhQ2kvayaZLN/TAagsYAuAK3Ohm2r9FguXOAXxmLrjnyCFKKMI?=
 =?us-ascii?Q?VBuXqv2JmheuLN7PIH8iON5WUGptJJGHGaQDQm3l8UsXkZjBb7oLrgcD0Fcw?=
 =?us-ascii?Q?1f6BqsuzogOgH6bui1H6qDaIuz+Kw75X9dljARG7rvvMjGzG/ornv7GyTIxP?=
 =?us-ascii?Q?NcTrf8HqDUcf5HHks7UP5Prl1y7Uvw472iiowgmVacEuzN7mwomTB0df365A?=
 =?us-ascii?Q?EfHhcyPKHb7++VREYtPTP9N0L4/vqaTyc4wKA4BtZo2uyC1f6axNIJR/3caY?=
 =?us-ascii?Q?3vmd/J+PkBoo+F48LVFBvR1vBxLFL3bI1TiVn1LLk2QX03AC2p0v3Him/man?=
 =?us-ascii?Q?iNL5uC+QrBPViIMsHRQrbHQpvELM2KrN5mnh4djLmh3TBFKciKQZCTJnGfn9?=
 =?us-ascii?Q?nUfKZtDDW5iFymbeXRb3SXsZ9XHTnL9WmqvbGCtzo2lSrpu1Bfh1skKy3ati?=
 =?us-ascii?Q?lHW1eAlzbBZ6Qo8lFW794yct7D8ZUbwaeii5Ks/PyoYanGWBSQmmiGBpBUbc?=
 =?us-ascii?Q?BPI5lJQJFzY8VwoQrYoXFwOlNdUka+zoq9tXiMLrlv+CHFh+kVXLae8bZ3nM?=
 =?us-ascii?Q?Y/iUZ7UuqQW7fFEiozqwtfsYWTLWA77Q0AmkOpMb/AgU0R7VH79jyRs+PLYL?=
 =?us-ascii?Q?YgpdRtQocm9q9HiaIPGSi7x1mUs8Nu+FcbP8tm1wKyk0Oh7zFP3eIkMsFMtS?=
 =?us-ascii?Q?etFeIWke7DMYRlGfZoOrYSeIrWqykGBq03TpwNmXzblzcGPSA2S5A2SJ8PqD?=
 =?us-ascii?Q?a33Wx0unnPUdF1TI4OpIIRFmsrT3uNbxd96BbnsMsIiLaNxSbAHgm3R+a5BV?=
 =?us-ascii?Q?HqdbdDEmk5qCccHsfCV6gX4QoEcaqExbv6QknGAxpUh+3TZkao95SrHSRgAx?=
 =?us-ascii?Q?T0h2PHJ/LURyloGdXcYEXwpRDhII9HBu8gP5ZE5QPG+4BL4Ud1clQTmiuWsv?=
 =?us-ascii?Q?mxK5/x2WJVFtop3wW1MCrqVWtAwbZZqP0UTZmOpv2A8lY5/QL/fC2TZz7VyF?=
 =?us-ascii?Q?KG0B+XRbqHNisAVs780cpK8Mp4hvglOFNIp9d9FYn155BNKfM1sHZe0kW3sy?=
 =?us-ascii?Q?BZ8+8NflU1j9DYd+NSX8I2TM3HpFEj6OAHPJMYgR76F2ufmM2cN4GZlt/Y8B?=
 =?us-ascii?Q?LNTFbcOX91wrYp26GvUk6ypHfWzOxbpMc6CMmkcvSIHUpp6HQueoAth8EwDm?=
 =?us-ascii?Q?YpZagBWkrtTUc8IL/VdPk8gXYtXlxuc7/jrGjSkpoS/XL9NGEpgM6VnUtcXW?=
 =?us-ascii?Q?K58Juxh6RI7Me0qgARRzJTOKWVg3IcnTs25D4I+nMKTiPj82ZwZLDSsuJHlZ?=
 =?us-ascii?Q?yUbl7WwgnrfF+i6h8Vp5PqUNKbmXpJkjKX0BmLoFoVF45dBs+swZ5vtLo5aS?=
 =?us-ascii?Q?+yVuEdo0AByXhgd1liSJ1PTTV7hSA+Aa5Wvo9r2HSj8lBIo612rEtFnm14fi?=
 =?us-ascii?Q?V4tOob1tJ/EmPZP+/dE2BRC8iwNZNca9YKgSeEbmGmAOZJTSJ9szuWhgYjyG?=
 =?us-ascii?Q?/54twB2CEvxpoqQto9ihJhA6rnsCovfk+pVCn3z3qPsHH7Qnblu4m/zvYJME?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b069de-6557-48f9-8213-08dae456a53e
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2227.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 19:56:41.9503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 56fXKEpV4EJ1C5mGrtXQFit33IvivoEwS/tK7+RPP+uppWDJ4lINJQ5YGLFQlJu4N+fifqOlYaJimtSKMVi/VbrJsQ/g0cPkCKfGqQZMzo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7507
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 04:01:42PM +0800, Clark Wang wrote:
> Hi,
> The issue description is in the commit message.
> 
> This patchset is the second version following discussions with Russell.
> But the name of each patch has changed, so V2 is not marked in each patch.
> 
> Thanks.
> 

Please include target tree name in the subject eg. [net 1/2]

> Clark Wang (2):
>   net: phylink: add a function to resume phy alone to fix resume issue
>     with WoL enabled
>   net: stmmac: resume phy separately before calling stmmac_hw_setup()
> 
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 16 +++++++-------
>  drivers/net/phy/phylink.c                     | 21 ++++++++++++++++++-
>  include/linux/phylink.h                       |  1 +
>  3 files changed, 28 insertions(+), 10 deletions(-)
> 
> -- 
> 2.34.1
> 
