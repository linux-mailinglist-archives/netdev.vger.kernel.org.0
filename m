Return-Path: <netdev+bounces-1947-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85E686FFB54
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:33:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A5EA281990
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EBAA8F56;
	Thu, 11 May 2023 20:33:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B253624
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:33:11 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11F630D3;
	Thu, 11 May 2023 13:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683837188; x=1715373188;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nCwIfhFbc9lutSoyFn/SJJerC2I6NrHYH3m1kk38dc0=;
  b=gaAws3RuuxMh3Ukr9NUwnftCVxfM8kDIpzsJUhWhgF0X6MhmYvVkySv0
   5bisEvhU0EDa5ODhoT5JnUjzeFjPM+UeKCDBO107x1+AIr8MnsXPQJ6S1
   rcIS2w2TrFTenX2DK0mmFWO8aG1T7YYqgYVfT1ihJ7gGicJQJtzpjvtbr
   8evUIJwshtwt7kn7LIVZWY/UmnYENsgUBg+ddfH745RwZcJL4GGR4kUji
   vROlccmkqHChzrdZRXxe+8jKBz9f0JZb1VsHUhIjp9VUiebZupjPuQ5ti
   kC4K0/5WLRRHgAKDU/aIY+VLEafV18ZMGYtuKJGh7JNhO8BNUdYOOZUUQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="330243517"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="330243517"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 13:33:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="811782948"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="811782948"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 11 May 2023 13:33:07 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 13:33:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 13:33:06 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 13:33:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OW7pqac085W83LGQWi1VqM1B3o5iZ88vepCKGK8zYLYqTlDDp8qmS06N0q5F1Qhx367rsPc7sZsRjCkGMJPPI4aJuGUsE/qdvrlvf0EOUXz+5oc2vmXaPSJRTtGx4tryp9ibjnoM/2mWKYWmjMz0ud0jnsOJOZYPkHsmEAPy/N/acbbp2DHKMT922Atzm7nc267zh7QpPTmcqdTwhBEf4g2xdhVozzFtgeQylAGfHR0QVAX+MPJdyq7ECfCoy9tCHmVqYmhjf9X89/S2b9fxAav6miODzH9/WncndVJRUiDr61+5Sfc0Hd5T7jKUy06DkakZswTCj5cpndjIMPEukg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nd8D/ahR9vlnpCC9eu9XiAXem8GtaXiUNJuKdNc3e7s=;
 b=jvryOfQ7/2VzG0cnals0dYdTVCLuZu4F6mqWBxEEh55RCMLq06XPpVPnE30GDnhOCrY7pxQ7q5ZGpVc28qDQGCD818U0ZoM3rMl9jbvZxT+tox10YaLpf+rjgFFpsV/nOCOY6D8TiR89LWmhe2MVOUydnfjDUlGe1wmzRGffPiaRRqA1Oan7W6qtOfl+MCOap61BxZ/cFIHvSjMsw7/jPMjQCsOCDS0gVShIMLLx1oAO0A9C3V5RhckmPyA7LOvqaaD8IABF+bO53yd9bQTEt1WBbDmtnCHc5ama16EpZim92QsDWAQMxFc1yiZL3tvH2HTGG3XAs+aB6NmP+ibHjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by CH3PR11MB8153.namprd11.prod.outlook.com (2603:10b6:610:163::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 20:33:04 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 20:33:03 +0000
Date: Thu, 11 May 2023 22:32:53 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
CC: <netdev@vger.kernel.org>, <jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>, <mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>, <Jose.Abreu@synopsys.com>, <andrew@lunn.ch>,
	<hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>, <mengyuanlou@net-swift.com>
Subject: Re: [PATCH net-next v7 8/9] net: txgbe: Implement phylink pcs
Message-ID: <ZF1Q9Tc6wHKhnp/q@nimitz>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
 <20230509022734.148970-9-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230509022734.148970-9-jiawenwu@trustnetic.com>
X-ClientProxiedBy: FR3P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::9) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|CH3PR11MB8153:EE_
X-MS-Office365-Filtering-Correlation-Id: c3ca8ae9-4e27-4126-9ee9-08db525eeaf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3yA11MtaX3+dMR+TvZRIJMoEYc+kXkjQAjYJ8e1Bh2bk6vVDejc+9n5QvFILOPPzMwn86/a3IGGyyILu7U8B4l+Jci906FN8uKF6ppZwSYlC0hmXFzmSPJwFrMA0s89zK8PLR1IRTzxxtp0/O5GGSnSRQe/bfvh0kRHdM3+bBgNU8GdTfRNf4Kwv6xnp5LgZk/CMLb3SmccSZKYfoknHIfbhNS70WEAr/jH/kjMCcHdG+6SVMWA9zUSwqu9QP/FCVnJBOyJ2BexQ2mJ3dkfau3ZTs7Sk7zufX9RxE/Wq4RaLYJXjt+G3VceyNgrEYVpke8ZjAEIl+8RE9q5hIvKyCqBwK/cpyd9rr7L9/MAaHdcUij39rLgz52wzxNjDZ94ejP/pwlnk09HPLnAoE8DRT1EAclS07Zpp/5/XudA9LLkuQI0P6xvAwVwcR8MGnCn1JEJ24fJC9WyGRzDatlAoKnmaw5xM6YOVcmRoQasPZDXBLjxDzVwSIDVzNcGivY1qsTQZ3rS8YlwKnsqNp/rKlWc/QK6/cU4uRmnc1Edx7ox6AgouEY+QILgCqpZDzoDO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(86362001)(9686003)(478600001)(6506007)(6512007)(6666004)(6486002)(26005)(66556008)(6916009)(66476007)(82960400001)(316002)(4326008)(186003)(66946007)(38100700002)(5660300002)(8676002)(41300700001)(8936002)(44832011)(2906002)(7416002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nu5bJJJlsUnytpkAwvqvz3N94VKbLx08yLiwM3IVQhNzeNSxS6IU77eqvuF5?=
 =?us-ascii?Q?DwS0SXnWJ/qo8xj1b/vGdmIF5r26w2pTjo5fvlSKMCk6jdIW8zGmhlsasXuS?=
 =?us-ascii?Q?loGXG1ZHCDUlMkIYnPBnY9otO6y/hIdjxtUbgUH/pAsU7JFx7g4Dm/G5V31n?=
 =?us-ascii?Q?nijprDSTlsH2pKeQqjr+9ukke+qseeaawAfjEKYmxyfOZx+VeXCxxEoELsaE?=
 =?us-ascii?Q?hWoclqcyitIVrm0tQDRTi7HRAt9RL03fSfjsH5yH8RJxCZye4udUX5cMaZIc?=
 =?us-ascii?Q?qfzWquqzK/fE6X1XYu4DNNBzVfCaYlbE84wF7aVP1JoKxt0d+CNVGX8OuA9N?=
 =?us-ascii?Q?jM/0g/EG4sCnXdZLBI9YIa5ywM1fTYUU+msHGP45AuQWlybejCDlHGOSq0DS?=
 =?us-ascii?Q?jHGGFYNtrQqohVCN9rB0jla1i1PBWDNKGbIg2LowjbJ8/3gF7end99uckG/X?=
 =?us-ascii?Q?dI+7+KSMsoq2XttalcVh6dX45562IVxcwsSZ2g4yYHtoxQjW+fnElqsjfR8A?=
 =?us-ascii?Q?zDdSlLqdUvUZEl9aDyw8ew+oXe2N4GpZcBxbRvuRa3JWE3f0m9UMu0G2LEdT?=
 =?us-ascii?Q?xq1A3NPcsNe5surJ/GMvhFh0SS7v5JNXF5Ic4kZDFrxiSM60xn4sw2vSiCOc?=
 =?us-ascii?Q?efaiLumSkUqT1ytoSwa+WUbYx9uCaCzHIWhSAxWWAnOS+PT01VEE8txNp29k?=
 =?us-ascii?Q?fclQNZJ7zBPlfz/tZ/NMSgxi1JTRDDWjVrCpgVaavrI/2fTTTjnRktl4bqdf?=
 =?us-ascii?Q?jw/0FFDiVZYTXhHY4Q1ImvVRpd5MYdHQ4Zror7corA1n/CABlHdEE7uVyAmL?=
 =?us-ascii?Q?TgmQ6sbgX0EZ/gezpIG4OvQNCb/xLtB2tyOL6kCksxSa70zTYu/7URJywEbj?=
 =?us-ascii?Q?yajLw0giuxHEz1q85h+rXllA2MbDWlUufniEAJVQyAGxFRoZnU+eVn8vuRw+?=
 =?us-ascii?Q?dTpQVCiaSsE7KxMBgqijaxA86R3OEAVsIDGHe4YqFdWu+AmwIs7R0VXid19K?=
 =?us-ascii?Q?NCgPA9EWMZ4TuZCa0MOHEfST7NIQipH3zc42s79b90xyk+baOwKuSdHLOqKo?=
 =?us-ascii?Q?amQezpZPMkrNhWbzwPeKpBUVIElZMZQ39x0b/kb0elxBYihQZgTd41BqRTOk?=
 =?us-ascii?Q?yX7kRY0JuKiFytvcTnZNXMkdBGRSXd47nBpQvwhsunmNvG0q0X0cBT4AkD5E?=
 =?us-ascii?Q?rE8IZ6l7yRxcPyK0etzn7F9T++8QVrq+kKomY3WeIKRNsQmbxWd1JZznv23w?=
 =?us-ascii?Q?iz/mfOfnW3+8+Qhbb+l1eJxuuXyBPKcluctBzOEST4/64PHUDsIckN6Demm/?=
 =?us-ascii?Q?7FdrZ9UkPhAIVAdp2W9U+SkiLcyR8qU3bjhwftvZLvJ8/qn/EGe8MMX/9aCS?=
 =?us-ascii?Q?EWeXjtm0kJJsZe9ILSO5uxu0Qy1zq3WjqmHYw/XtnXIozAB91bJcg8os5VC6?=
 =?us-ascii?Q?/YH+m3QjZ9VOvg6NR+8UkMAzugDieosJ0cnuHLWF33GpW3KY4mMWC0ALNr5m?=
 =?us-ascii?Q?ujASq2RHoC28rNhJVosZb4JzVCL4TNrSxV14VhBnZIQvkRzM2Pn6xZS+rNTP?=
 =?us-ascii?Q?DSc0ORGPq5ZvBwx3+JTrwV3QQte15ncHWfNti2U1d57F9FsPhturxN/bw7PS?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ca8ae9-4e27-4126-9ee9-08db525eeaf6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 20:33:02.6948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mGkrgfkjiUHYhVzu40DUzi/C8GUeVh5n5KOZkjhcdz0GmjalrrqHATdU5AExGrkGVC/MMzBjq5ggO8qikvYetMll/9we1vNN2+cLpviyVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8153
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +static int txgbe_mdio_pcs_init(struct txgbe *txgbe)
> +{
> +	struct mdio_device *mdiodev;
> +	struct wx *wx = txgbe->wx;
> +	struct mii_bus *mii_bus;
> +	struct dw_xpcs *xpcs;
> +	struct pci_dev *pdev;
> +	int ret = 0;
> +
> +	pdev = wx->pdev;
> +
> +	mii_bus = devm_mdiobus_alloc(&pdev->dev);
> +	if (!mii_bus)
> +		return -ENOMEM;
> +
> +	mii_bus->name = "txgbe_pcs_mdio_bus";
> +	mii_bus->read_c45 = &txgbe_pcs_read;
> +	mii_bus->write_c45 = &txgbe_pcs_write;
> +	mii_bus->parent = &pdev->dev;
> +	mii_bus->phy_mask = ~0;
> +	mii_bus->priv = wx;
> +	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "txgbe_pcs-%x",
> +		 (pdev->bus->number << 8) | pdev->devfn);
> +
> +	ret = devm_mdiobus_register(&pdev->dev, mii_bus);
> +	if (ret)
> +		return ret;
> +
> +	mdiodev = mdio_device_create(mii_bus, 0);
> +	if (IS_ERR(mdiodev))
> +		return PTR_ERR(mdiodev);
> +
> +	xpcs = xpcs_create(mdiodev, PHY_INTERFACE_MODE_10GBASER);
> +	if (IS_ERR_OR_NULL(xpcs)) {
> +		mdio_device_free(mdiodev);
> +		return PTR_ERR(xpcs);
> +	}

xpcs_create does not seem to return NULL but if it would then you'd
return success here. Is this intentional?

> +
> +	txgbe->mdiodev = mdiodev;
> +	txgbe->xpcs = xpcs;
> +
> +	return 0;
> +}

