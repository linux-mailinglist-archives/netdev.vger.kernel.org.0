Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BAC653D33
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 10:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbiLVI75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 03:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiLVI74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 03:59:56 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14391D0C8;
        Thu, 22 Dec 2022 00:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671699595; x=1703235595;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ronFRUeQPAl4/uAsVT0E72ajrEHrz9GfGqFPhU9nGgk=;
  b=WdC9A4jCnEPlC+DMDezxhfh6+Cqkbtgggpqjp+XKqxDnhk5dsaeH5lEn
   QSEqZgNBl9WXKJAQtOaoZQzaJrQc/ZuUQNnQ89azLAmQw/VwFPKwA2ME2
   frisiUJW6X+CLzowFH0L3UDU8w3DAMMGfURxI9AlpmGvQtefewmqoCe3s
   P0RzhuBQ/+BaJYpKarb6g+ewfvS28J6zVqTRPHtX6/0g02MS8I+r7/d3Y
   BaQLQx6vJCRcbJbtJEtgdNfEqQ1AMGy3ZZ6ebuvbFg0kyMCEHfxblxhhH
   rFbmXpUJvaTVTkB8GoUpYe1mznJE1hwGX7ZcXf0YhitGi7U7s1WaOaSJC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="347221332"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="347221332"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 00:59:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="720242099"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="720242099"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 22 Dec 2022 00:59:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 22 Dec 2022 00:59:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 22 Dec 2022 00:59:47 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 22 Dec 2022 00:59:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+RelGl4YVsZPzsX3NvA8Jgn8IsEo0pnoIR8v/hCsHFTqVYNVKHDm2ro2GdqKJrx34w5Gqo8/pzOeAJfqj/g3rWqX2fV3O+thIvrGm6ExP7NoX3gDTbs/0BWirpiJUamkEo3vOSxNr5w7I0dIIKqgqHWrtY/cUbtvTelbelNnN2rl/M7r3FcX3b1miMv8EvTjb+mszNIEmvfvWd5Dbz9P4es4670kVFzsC+70fZagAXl4bmB+3XeOfHjI4+Q8fEVfsYX+CU5KfK1WAWuRwa5B4kwrLd27YqKLNRtIy359TZIhpx0IlI0Ps3hhN9fO3hKn2BL266gwHouaArxGycLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4OKIp5RHZl9TKunLgb3T05MCjy+iCoapdwMWgZKQmw=;
 b=K2PgSENqwtA9K+B8/4eXbqGVyZn/SreXUX7rTwuzvI9ouPZ84VPeBfswSGUDrpYnlKDh6Uknnddml1tvChhDp2VLHTrH7n5vQJr2zLIxsxA6DckD9OjSdoRCMakvomG3VlBNGtdkC10Cthi+avCd8xlx5bYz/AFEWbcIUcDOBVvlICCXTSqK/3esCxlDHyxVGfMFaha75KXYqabazBkdMYA2sw+Bz/8N38gqXNtEwfyoKKwMHXF2C/mBIa/XzE25ABh3CArADYuIOXCM5/tiGI+e2CCG26ej7+s5sikaFNUlakq9gqdha7R7+WCZhX32WGPLhrhbp+GMVGiHcD5yYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 (2603:10b6:405:51::14) by SJ0PR11MB5598.namprd11.prod.outlook.com
 (2603:10b6:a03:304::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 08:59:45 +0000
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::5d3a:5bc9:4e57:622e]) by BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::5d3a:5bc9:4e57:622e%7]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 08:59:45 +0000
Date:   Thu, 22 Dec 2022 09:59:39 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        <linux@armlinux.org.uk>
Subject: Re: [PATCH net] net: lan966x: Fix configuration of the PCS
Message-ID: <Y6QcSh8zQMKRKbJp@praczyns-desk3>
References: <20221221093315.939133-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221221093315.939133-1-horatiu.vultur@microchip.com>
X-ClientProxiedBy: FR0P281CA0104.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::15) To BN6PR1101MB2227.namprd11.prod.outlook.com
 (2603:10b6:405:51::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2227:EE_|SJ0PR11MB5598:EE_
X-MS-Office365-Filtering-Correlation-Id: 25ea452f-0533-4401-25b3-08dae3fadf03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: huSnWyZAFW3SOcPhEZl7OatAa7bZoLb8IKFlw+RhpzoMbRWOv1IJX7APW9enynctQD1SMszjRGmCbpfqajkzXqXN0ZX3P6hYc8CWVKTCfaftWzcydsPfHoW3LQbUahHq+6pJuMsb7hA8UW0IuB8yr/YzuOub5tR0RfT9MRobCPIklTzKIwOlrypjllMBtu8eVu1YEkIfIaoG/LQVCEI8UjIKZxUbx/Tw+drcDUAdLc/yed411ogWZJM9mM4B9hT+tXDj4rtVrpCGeP8asNQsW8YYynGcE1sdM2EDUQZlyqnuX7fNESY8jSvv1qnd46ZWLoIitfh37yS0qx0BW5sswB/hA+78SQ9fKmlsTCuiE1uPODbp9eq68Ttk2c2j2o0Ph50PZtSxuf9MavHd/nNlbFc1d9yGRWK+u4OFHpOeqRKSuNp6C5CgsKJfv6qGuWvQ5vHUB5af2Wfu3Pd1i3Gkb3KodE8Lre7xtZXbiKkHYOntI8wV4bbcaYwnrK/fBXuxZOUPgsH/D3AgyRyz07SNv2j/UEuYBg4Zsr6GtBHvdEEn8X3cTYUEqybnZ/87Ef+OzcGuC91Ef63XN5fr915woaNGvgHHsSk1YwV8swFHffzjVM/5WWCgrSm6k9vwLrrA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2227.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(376002)(39860400002)(136003)(346002)(366004)(451199015)(83380400001)(2906002)(86362001)(4326008)(44832011)(5660300002)(82960400001)(66946007)(66556008)(66476007)(8676002)(41300700001)(8936002)(26005)(33716001)(9686003)(186003)(6666004)(6506007)(6512007)(316002)(6916009)(38100700002)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qniXMGuToCKaJ1chn5eAoWRVd3qcDCy9zskKdmVQIIptIKen8Zz+qAsE6bqt?=
 =?us-ascii?Q?giGkNKPlhqzol+cn1SmF6cwxWkqHm5Xt8oGjp8QkJ/eu0etuZDu9J975Hovn?=
 =?us-ascii?Q?ILEPEm323gvwj4XPRSEDzENimH6bH64eE+6g2y/jo1lNTuwSW32zytv9UCac?=
 =?us-ascii?Q?uXF+K9Lo7Dg1EyyXW/rI3uw06IeHfCJQatnkLItB6AchYiaYyqWoLG+DJJb3?=
 =?us-ascii?Q?7cC/ySFyqz+4ftRI51LcQUQXYElT+j3ABpzqc8nQedw17G+310hCktNS7Vy2?=
 =?us-ascii?Q?KMhOYXVKOsklv5Lf3CQiXXBaQ25WWClMRuh5cFCF7IrMp0/kL4m9/I0g19z+?=
 =?us-ascii?Q?nLBUFeWDPkKM4IyhLlLmDz7RGycviMOW7M1LZBYjfeANz2B5xnk3WTyxWjd7?=
 =?us-ascii?Q?LWrphtLzdNhQPv30Asa0wgAIr7kNwWFWnaZRpO8MUs3H7HX0vNhp8s8BuqqK?=
 =?us-ascii?Q?6T2puM7QyK8l2/Yvl78BlWnn/m3PBQRiuWLo1wteCupbBoATI7YHp8yf3qIB?=
 =?us-ascii?Q?GWm/o/YexVNdWzPT/P7eVRDwJw8NY3QRgfs8EueshcaL3Zyzg+FyijGNmNTy?=
 =?us-ascii?Q?Hku9QJlhC0J8m2rF3h77iyrXx6qu/ZRrfhx1AuYCHgBylBgwcHmfWH1CCycG?=
 =?us-ascii?Q?gZf+f14aYD40zenHzDr/y2W0XzWDjE2GUToRu58Udogp5p4AhVoVUT8HltrI?=
 =?us-ascii?Q?aQyA5Wpw/xmQBx5ewyoFR0CoVOWQK6CcH78CV8puRofWjpDevA4fXlmTdjS2?=
 =?us-ascii?Q?2zC8wU7usoNo0o/Rt7VKGJFiAc2qzsV8eIyP2tB+AGUKcAtKXmX4swDvMhAT?=
 =?us-ascii?Q?8PxwqcShEWqPT5VAX0KlP67bkqV8ycVWLFiCqaB2/sTtbohxk3zQ1IjpNK/V?=
 =?us-ascii?Q?LbOJhpEgwBNNENROzeRlTn/onGzrF+r4QZw2H0BfIgq37k8fFvDp8e1/J1h7?=
 =?us-ascii?Q?H4grtNgbNSlzydcCt63mB7Z5Yqxx4JzW6ukmGDDvrWUHpNO5b7ScnwhqdJs0?=
 =?us-ascii?Q?d39AHe3/OnQpidPnmQdjjv3Nl57GxH68zaj3BP2YoXrcgrzSELnGxVao+LcH?=
 =?us-ascii?Q?BkxZ+gymGdTchxKk5uQc7vc9L1AlXIeMhxoXRDfq5yMVVxQYvTCr7PbW8wFZ?=
 =?us-ascii?Q?yyinJmNoNl0z8DchSa/5d5edxLinXEBykfPZ0k5N90NjonrK8KrQeHsQslfF?=
 =?us-ascii?Q?Bkjde6W7XiHjl1Mw+r5886HWv/cwr3MC/0AKz9lWKscRGRwkPnZvgN2WLBuz?=
 =?us-ascii?Q?DhyBCFH7LMp/N1EISbs3wJtKDvxFcBfqvOKFoDXAJBDbYqSPjPF8b5H/8FQw?=
 =?us-ascii?Q?+PFe1PKK1t+tXreyhGlo1fk9nHSm85d/gdfGqVj3d+W2lJ04yXZnXjRHHm4B?=
 =?us-ascii?Q?jTRoAAW1MU17MjS7fI57x2r9vUCsUYynRwlWbXrg42jGRAbmRnqzPr6zc+5W?=
 =?us-ascii?Q?dFug1WHR0WRX8z2ENCgtOMql04ZVDISjWluq1L7/eEkP0PWd5I/NYGB1TGGu?=
 =?us-ascii?Q?TfSPPo8xTvy4bQ4b+xg+KtK5LESqET1e/c0ZGPWj4HrjWu47rT1aV4btqV1Z?=
 =?us-ascii?Q?AfboAWr0owg6mrdPSmlVgthexK60hCuUqAO5SnthHwEBFT1OPGTxa1xNfMGQ?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ea452f-0533-4401-25b3-08dae3fadf03
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2227.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 08:59:45.2013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0an42wtPzSs69S8/RFCHk1M9gCi7K7giZYFCRoYCYN79mrS4LH7gRil7Dx53FA0ifeAmpiVbmtVBaIvsZaY2Tdq/qKHv7wA6t9N6GrhKnBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5598
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 10:33:15AM +0100, Horatiu Vultur wrote:
> When the PCS was taken out of reset, we were changing by mistake also
> the speed to 100 Mbit. But in case the link was going down, the link
> up routine was setting correctly the link speed. If the link was not
> getting down then the speed was forced to run at 100 even if the
> speed was something else.
> On lan966x, to set the speed link to 1G or 2.5G a value of 1 needs to be
> written in DEV_CLOCK_CFG_LINK_SPEED. This is similar to the procedure in
> lan966x_port_init.
> 
> The issue was reproduced using 1000base-x sfp module using the commands:
> ip link set dev eth2 up
> ip link addr add 10.97.10.2/24 dev eth2
> ethtool -s eth2 speed 1000 autoneg off
> 
> Fixes: d28d6d2e37d1 ("net: lan966x: add port module support")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_port.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> index 1a61c6cdb0779..0050fcb988b75 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> @@ -381,7 +381,7 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
>  	}
>  
>  	/* Take PCS out of reset */
> -	lan_rmw(DEV_CLOCK_CFG_LINK_SPEED_SET(2) |
> +	lan_rmw(DEV_CLOCK_CFG_LINK_SPEED_SET(LAN966X_SPEED_1000) |
>  		DEV_CLOCK_CFG_PCS_RX_RST_SET(0) |
>  		DEV_CLOCK_CFG_PCS_TX_RST_SET(0),
>  		DEV_CLOCK_CFG_LINK_SPEED |
> -- 
> 2.38.0
> 
LGTM, thanks for getting rid of a magic number here.

Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
