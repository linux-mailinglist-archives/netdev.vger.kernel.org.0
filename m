Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EA96B9E4B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjCNS1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjCNS1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:27:11 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52970A54EE;
        Tue, 14 Mar 2023 11:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678818430; x=1710354430;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Imeq+cQGUhPzG4Vp6GsYp+fgb1GldCsZlAUBAi3HA+g=;
  b=HGSxbIopoPw62amfSvEdgGsU1Vxef52LRbdTnrAeW4JFrrNgv8zkePbF
   zfmRp/zuvane/2jcgK4Hp6FE097fOxR7UeB7uY1tPvDQFXtDFOIMvdmJS
   FSd0tjIDSbKsxBSuNftoz6740Zqif5bqGggCDtqMWRju4vtCS6C1HjLYH
   FEyjsy5SxJbjy8QnP6EnUIC+uuuvrPCRezdPbnKD43Fr4fSs8e7nZ6NWB
   Hw4hP9Y4ZAduvXB6oZLRJAaPzTjdx/cNc6Y9/102vNZ4bOUFVUZt6Kj6Z
   lckkyxnB/6kIzTjr7nmwXCF1/OsSWpyI4PL24XqUgZTNz4E8nIPSINLti
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317160417"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317160417"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 11:27:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="802968255"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="802968255"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 14 Mar 2023 11:27:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 11:27:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 11:27:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 11:27:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOu9pydGWCvDeWHhjSszIxcbXDcKSlAhYQvv+xfYEeEAm9OfcrA+v9tclJH22tEFkq9lYaDsxkQgPSn20CfKJVldZG2Cfa52lKtJvj7JW/ay+Z6fJK5PnJIKjgi2/nV5Y0dHRiGtm0+eUMBP7Nz8T3pLbp/xFW7LktixEbaq2Ut6UqA2+Q04A8U1T/lSLUNh0RWl4OISoHd3fr2p6bnQS4/+ZCh/zLTxdQUgRlDXVjt4vqMxHmTSEN3eDcU0+pE4NLc+0jRxqcJgDacSrG95Ou0CcWmjodaJjohgAUe28wZyOIMTTUypFnve5BRKp794Yvqu80NitmmsTEaQnlc2Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvL4wbbJ7gECL/8nZkKTe6nKAjl2gwEE9yyeVOlCr0c=;
 b=Nc99yozQ5+JjSLsu50ECnMIfpEaVFTyYaNz7AEHzX903JdnxQB+RayOnrXjmb5IGOe3zMSqomTcqqud9aB7bBINQ6OIYNomGod2nK7imlA7pVw3IcMVzDmoQUhsMHxylJlVpkSnGftC2fsPYkk9mFJ+7xrc4Ba4uqx6Na4ZSOojix02GFalDPPaH0Pm2bffbYmuoR3vAdTkJqJp8qLJ4R5I7gdtgXZphYNsUZQq+VEwj1VgvX30+9kc9lDJnTbf7VciJIngZ49syS6s2PYzZCndEL0rps/okGmOOpWVcTNsFREoKKoqS79KkIW11M2S+/xAAZJVBqIXYPQE6mB0Duw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SA2PR11MB5067.namprd11.prod.outlook.com (2603:10b6:806:111::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 18:27:06 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 18:27:06 +0000
Date:   Tue, 14 Mar 2023 19:26:59 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] can: tcan4x5x: Introduce tcan4552/4553
Message-ID: <ZBC8cw/yLiv9L9OM@localhost.localdomain>
References: <20230314151201.2317134-1-msp@baylibre.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314151201.2317134-1-msp@baylibre.com>
X-ClientProxiedBy: FR3P281CA0041.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::17) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SA2PR11MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: ab2cc1f8-bc8c-45e6-1833-08db24b9b723
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /gTgmzUETSvCrUeTXIyHYxHAzQOfVBBpelPH8FHKplCtNHI5jtGKCIck5ca00LS0+XQi+AzoNN3T0LRNtkB6/J0NAhsn0c9iLvPZZrClLJYRK9K8xhQ2LW+V4c9oas2CxRi7aESsEFNL64WfJGze6yT18Utwrf8V/2l5wg2A293XI5UlWBdO3Gsz/K3nMNNeiLsAgJbaJ+sBPZfEGCtl6B0tAbI91dMGEuYD26ULD0zpH7wiO3pYc5hbB7v4ME+4dUp/7rjayfqR3WwrsARsnP+CNaCN07KnPIJQiZP+7lgmlA6LZxzreiuDMuTS1/gHcgy4R8jJcy0VKKM/52eKIyV6TqpbgNzhaByTerro/itlumnp1vQyFNNq8iNh+K1aI8kjw63WyEoI8UGV3V97Oo9g2amGITe9WFFIEGCtsNdBkzqa/nog7K/1FPID7nz4Cf+u1/VA2u/JFo8ZaxtVroWyGdbdlQXsSutQATOLwdb2mbfIuqXqTK5Z2CT1IR2wSftuXmctmXpkvZISoFEw0LYQJWMtFYNsf/u2WTYMxg1trl4Dhh8XxOW4qNDVXUPJLbELkr6gonJcZiELGDpYKc0eXAz7uqAQMqj1Sc575fPBPhHiB7rvJtX0w5/3mH59
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199018)(82960400001)(38100700002)(2906002)(86362001)(478600001)(6666004)(54906003)(6512007)(6506007)(316002)(4326008)(41300700001)(66556008)(8676002)(26005)(66946007)(6916009)(66476007)(7416002)(9686003)(186003)(6486002)(966005)(8936002)(5660300002)(83380400001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+afvQfoKXddudUbku7UdX2l1oD5yIiiZi4uRK5LPo3PAT1nqJZWBxLrWPvDy?=
 =?us-ascii?Q?btzbjPrlAQN2C19F/LbxgXRFhRQ/qbysy1veHJhspX2WkjCM55jLrxDSZGvQ?=
 =?us-ascii?Q?kcdjhTFKK9In+OzRjVilYMAGrkf8KJM2y8H8ek0vjav4uGk+xbJsEVdkqp3r?=
 =?us-ascii?Q?U2cD6gMfVpHpHDEl6idc9l9o1Djx3RWwa1tCTpSJZ2G30/6fVwFlPlq/GkpU?=
 =?us-ascii?Q?mUuFjGYfWBxogdulpmueywkSL6ub0UKazsUp4n1fiTJJMRYowTA0m/V0BVIQ?=
 =?us-ascii?Q?9nBquEFSEdd7/Hyloo93K2+UVFaxv+FgyMdGV4vUK90rmmeyed5EKBLvMaTS?=
 =?us-ascii?Q?YIzXRUPKuqXkEZMAJKJ/4aHE3J5sf4tp7TqePJLUhZmgEhImLvma3z/WXAKn?=
 =?us-ascii?Q?g4eu+N9NoErVEKt9zwqGUFlLy3r/jfLeiTCLNppc94m4mk6w/BjhEpF5KcQd?=
 =?us-ascii?Q?62CT0DacJb6w7un5S1dd8MQOcwCXCs9fn8nGqnw625+2mrvZsVQPzcSN2RVx?=
 =?us-ascii?Q?4L7ievOK37nKAtQ3pOKQUo+7/V+5SuG7JWI9YuFxsa+AJJo0ws3QHA3S5Oem?=
 =?us-ascii?Q?Ed5VLJQbOmnl5Kum0slM8SpR6ysHyItBegbVIy3ac3zZ9RIcnBUPeJyCCRPe?=
 =?us-ascii?Q?0IqThHWsXzbMmZC6M0qyUB6q/LpWA7FWx4knBo2B6Y7GRaQxwmCeYSq82pru?=
 =?us-ascii?Q?9oyg8rFwSSPcUkyIHfHg8EINISjF6I8FyBDt4T6HAhsIJJOvgyvh1xCMSl5A?=
 =?us-ascii?Q?WNKgzIjPQMg7ajVjddQu3QvaBftFzoc22+vCrXBw1hMVD7VFLDroPG5D6ukZ?=
 =?us-ascii?Q?b/ceRigbHKb0L9uCFTQfDD3M3HyXvIISOds2x6frJ11u4sbG0wHrsGhd3eVc?=
 =?us-ascii?Q?Qh8DpZXUt59Eri3zlvjlw2VoVZE9ijWe9wleHEm1H5gV3evMs4m4JZbwap0f?=
 =?us-ascii?Q?2AEQmwekn4vqSN4UxKw1U0EH/NxorbInbH7MxfYdaT2D7T6jwyQDbodH8CuN?=
 =?us-ascii?Q?ewyfEZFPMUDi4EePq03dOEBaxqxUuCB3Z8OxegmQGqJdw2wa6wqUuF+KPYMQ?=
 =?us-ascii?Q?R1us2CtHrEUMtsBAKEUUNB/7xwJl36EQO0zxV8+rNS4JFFPeAMT4cm6Xlq57?=
 =?us-ascii?Q?AdK64WpXBCE7NnpEgGR74Zt9gIqZGyEYiAOfvMPBD7LBr6uNNOC7LgivdeaW?=
 =?us-ascii?Q?ML8oot7VruAoKuS2vYeXTYqLxbAHLgVVxqHzqI0BDlcUi5qk4Vr3MusbBGUU?=
 =?us-ascii?Q?o+wuWH7iNGQ/sVyCDF6cCEFTwVnQ/LT+0Y+Tuel9o7paA6rLES5QsqliESQo?=
 =?us-ascii?Q?s/RFtxFsNrxQziQaqMwHWSYTg3faku6OO8HfCKRA7xAa/BWH5tRIV4gMoCZ0?=
 =?us-ascii?Q?OXmp8wWq0L2VPNoVSEfed0Yz2g9HQnxLu/ePblOAMBoTvaJLcuC0gw8sv+DC?=
 =?us-ascii?Q?3BSz1WSb0Zmi4q5tC5COrtlQ1o/e/3Qp0l9K16sZRFnFCwZoaHzN67kVjflT?=
 =?us-ascii?Q?yHCNDNl8dBTr0I43lWzVhiY5LdNEMVrYv8djzK4G1jXF2cJMpneMZV+6P9i1?=
 =?us-ascii?Q?fCqyleAcl/mvmQ/UNEWUCgIcZCKXDY7ZzZUXQsspUo/ekCusO83jXhibUfud?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab2cc1f8-bc8c-45e6-1833-08db24b9b723
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 18:27:06.4855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgMAVQw3wM3reBgGsnDzIOyGe5uZJhRuAzrGYKRPy1hpIo9wVuFGVvbq9wjJc4KqLQH9U5p4NmKL/NR/5v1VIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5067
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 04:11:56PM +0100, Markus Schneider-Pargmann wrote:
> Hi Marc and everyone,
> 
> This series introduces two new chips tcan-4552 and tcan-4553. The
> generic driver works in general but needs a few small changes. These are
> caused by the removal of wake and state pins.
> 
> I included two patches from the optimization series and will remove them
> from the optimization series. Hopefully it avoids conflicts and not
> polute the other series with tcan4552/4553 stuff.
> 
> Best,
> Markus
> 
> optimization series:
> https://lore.kernel.org/lkml/20221221152537.751564-1-msp@baylibre.com
> 
> Markus Schneider-Pargmann (5):
>   dt-bindings: can: tcan4x5x: Add tcan4552 and tcan4553 variants
>   can: tcan4x5x: Remove reserved register 0x814 from writable table
>   can: tcan4x5x: Check size of mram configuration
>   can: tcan4x5x: Rename ID registers to match datasheet
>   can: tcan4x5x: Add support for tcan4552/4553
> 
>  .../devicetree/bindings/net/can/tcan4x5x.txt  |  11 +-
>  drivers/net/can/m_can/m_can.c                 |  16 +++
>  drivers/net/can/m_can/m_can.h                 |   1 +
>  drivers/net/can/m_can/tcan4x5x-core.c         | 122 ++++++++++++++----
>  drivers/net/can/m_can/tcan4x5x-regmap.c       |   1 -
>  5 files changed, 121 insertions(+), 30 deletions(-)
>

The logic and coding style looks OK to me, but CAN-specific stuff should
be reviewed by someone else.
Just one nitpick in the last patch.

Thanks,
Michal

For entire series:
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

> -- 
> 2.39.2
> 
