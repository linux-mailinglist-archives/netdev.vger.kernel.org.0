Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1B36BEA43
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 14:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjCQNiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 09:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCQNit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 09:38:49 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CD7D5A74;
        Fri, 17 Mar 2023 06:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679060318; x=1710596318;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kCCJlhrr43K4jpYXLUlpw34aeInYihAH0F2YosQ5DtM=;
  b=FSORd2Yyr9yua1K8etiDKzGDVrW7Df8wcC8GOyxd2XK37CNwhHNZDFI3
   xO6pXhtJrhbxWXq3V5dH3k4ISxg5ws/LUpmFXDd6FWCgCatowOgJBBDmm
   It7PD1jVw9FT3F9KnZWfBVxpp5+C1J7ZDI+ySf/XTSATZg0W6CsUsoUqY
   SNOOy7sqHP9fLubR0tUxmJiT5Urew9q2vFaFdsBU/QqCv+q61fs1kf+7k
   wVSxSTDQ7TVmlMWErwRrp9BKthwFOVSCs58vP5hpi01jxjWEs08V1vQJz
   QpYfaN2MmjAClP3C3ueMvWpMrjsh4CfuJAWFcFIipb9LzH/0D8fhmDDGx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="336960711"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="336960711"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 06:38:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="749257068"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="749257068"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 17 Mar 2023 06:38:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 06:38:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 06:38:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 06:38:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUS131jzodbRwlfunKCX8OqZCCRI9ZTzm//GXpZYckZy+bCvx3lL8GSYJWv2IijkvZBiOIEpKjI3Tf3sYcEIYlJeH9PFDG2876l9S6KNscNwzM1KCwutrVE/Eq2v0YwYI8PzEQ7gms0QfhY92lWHkOsy0x8sMcoCKS8p/VymiYqO7TyzGzqJX4xtLLYRPOUR6qDFPp0v+2wwPoCs6RFZ307M7qGIcUn9OjRRe+BRvwNBm1Dye+DwfiJRbx2aXWsrHs5JbETm4kRk2AY13Mt754D+MeSkozp21mCWqALtogwx+Lhq8kHUsVM+wB2EiynPoTx3QM/7k9wiwgQhwpUpDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNmhP0vvJNy8TSBlmLBWYkD+3pCPIQT1ll6Qd6LiSJA=;
 b=RoKZz60fpYqhahxTqKhCg7KiMp7Wu8l6b8TXgJ7dNL0EubzuU6YnOexlCI7tCR+a5LC1+QM6eZvL4bU+uVtLmNZqNwZwyz90BzIlRE1UfjCPZJdvmN1uVeFOAnF54z9StWI7q+H3K1SEgL3LBjTUgth3LER2GJdjoNtA1k0PgQhGWD1Sh6I0QaDJtzW3FAX50WPSlNanbaquwirvG7+rzchS8SenL16/jodq+TwKUYgaHXzu8Po5stzW7Qd5AvMw04IzzPur7+22fzM242ayQY6coMlYMifCcPQoG+MBMOqeJ0nsFl2Q1KS4BqOq3CxFUH/aB4SkcwWbC0z4UNrZyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 CY8PR11MB7688.namprd11.prod.outlook.com (2603:10b6:930:75::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.35; Fri, 17 Mar 2023 13:38:33 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 13:38:33 +0000
Date:   Fri, 17 Mar 2023 14:38:15 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, "Lee Jones" <lee@kernel.org>,
        <linux-leds@vger.kernel.org>
Subject: Re: [net-next PATCH v4 04/14] net: phy: Add a binding for PHY LEDs
Message-ID: <ZBRtRw8pg0mcRxbZ@localhost.localdomain>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-5-ansuelsmth@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230317023125.486-5-ansuelsmth@gmail.com>
X-ClientProxiedBy: FR3P281CA0106.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::16) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|CY8PR11MB7688:EE_
X-MS-Office365-Filtering-Correlation-Id: c286ddab-e63f-440d-35ef-08db26ece6a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9smkM5kuCvnO/5wqGwKvkUYC9V1xdyFciLM7CAcajGz7iOqfDVkA5EjoKlz7rjZclxu72Qk3punbDRN1SCBTuaZpOLXKbCMapIPIlK2F/7w1G3ij9R2K+he92mfncToB813M8Ps2q6CluNGBu2ZowV838OESENV0Lcf6WTlo+4HAJfGC+V2N15N+FWiQn0sqNgMpuq0xKnRh72MIZf4MjWUSgKusA2antI7ZxYYQ3lH6ICItOQ8dO2ri2Z44OuOVklKZpIIm4FrJU3LdAuE42D0nF7yZIib4J0My/5bPQ9+CrJuOoyQdkjmd9oGH4J+fZL4ixBoy7VSVe+XIBOBHFRvIH4fVhwRozjeMW3hQ1wXYzfkqnVJvgbWiBb0ETGReZ/NQDzx2lzO1H05ezHKO0m9imowL/l6gKujkTEWBkEaEfpjIJiLz78sQ3hrHzG76ePdmIBI1okVitTpDOSTWn4bYgiPIrIyOFg1OPoQupSl3uM+1hlJTGvHIQ469h+batRclFhyjjVm7VYL+lz2T8owP9Z58GV7Rtl+CFojyXqoClv2wGI8eQYcER0xFYrrS8cxEaO26dmiKhDRrwAFdtW2aKS8Whx3/ll/atEPPnVxJSMdJfz+WRV8VUhR7R9waTSd5xCGZDxYtDLUp7D3kKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(136003)(39860400002)(376002)(346002)(451199018)(186003)(6486002)(83380400001)(6666004)(478600001)(316002)(66556008)(66476007)(66946007)(8676002)(6506007)(9686003)(6512007)(26005)(54906003)(4326008)(41300700001)(6916009)(8936002)(44832011)(7416002)(5660300002)(38100700002)(82960400001)(2906002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bQUdXi6h4o0X3ykP3GkhH+UU9Dnhkw6mwaxFYEv9rC5xEldNrPwZeLgtDunB?=
 =?us-ascii?Q?Ld8WzJg6CXK1RLneBvKSQygM2s7fosSShWOwyKwH8ZkHA6uw6nmxwJP+THhx?=
 =?us-ascii?Q?157Wfbyfbhfv6QKQ+MwJm5ofFQBiAkYwfyoPcFKwYOfFpoCdW5evHpN/7oy2?=
 =?us-ascii?Q?awZ5AmapbFf2tCZjObTJJvm7E2iXzoMPgsGRgfBcF0ubcePg4c2eFwgCFdqm?=
 =?us-ascii?Q?zNP5KkAuu7MqI2sEdr9IUyp7uD7gvPqRGvAgqr5fzTkBn+5/kDrbYvkv1X2A?=
 =?us-ascii?Q?BQpdHhRonHl2zRc4sE2NHKbt2eN/cZc5IprWp7+vUBE8n2hUHR3Mo+8nQ8cT?=
 =?us-ascii?Q?u7c4C3mQxDaod7Zgw+czOl8AkzwXw2ieYOpCy2g7K/HgN1QQAYdDkdz54/4I?=
 =?us-ascii?Q?6TXlsvu77Q9+IIbbqWrisQCIDVF2rmPwXc90DYZwgsxgEXLwfGIu6J2UzlgY?=
 =?us-ascii?Q?U84OgyIAP35NZPraAO6HTSm+kHXFwMdL23UsT+wtC4KPFnUUZobHEInkb6Ib?=
 =?us-ascii?Q?wi8z8zvZhbtNpbHi5EG4+f2h6Npm09yzk68WcZ4DawVOEjb966/9uoYI5uJz?=
 =?us-ascii?Q?+4P6GJcxRmpOmpg44n82hNAIjz+hMN0Oq+WU8iun1/4oPmD+LMV80DzRhS0P?=
 =?us-ascii?Q?38r7LylFiPr9fFAwg6BFw6HUk1p+y9yuYWHgC/6Eif6LDrBvi6JCMBew6zoY?=
 =?us-ascii?Q?tUxL8B9hHeNHz4LvDcEUCN7AkF7fqb/+MhonOtdVFdhkFntsWiLkGYfKCQBl?=
 =?us-ascii?Q?E8ohu+ANFVJwY1QswXD1CD7N4UaQC1oOjVey215e+pQMe4J+R02Nc+EyQJW3?=
 =?us-ascii?Q?e+EMKYbf7iQBHwAHykHqoGD0b1S/ZgyAYbhC5dMpVbs2OxewlygO6H8Fc/f2?=
 =?us-ascii?Q?/spq17MSz/q7141i/ZQiQWJpJmxjkhPZdw22koX2l20fwxX+L7uxu7voxf04?=
 =?us-ascii?Q?DB2rdI1/xJew+pNuPv8TrhbHRNm0R1a6xgftC1ivkVY6fB8Q5VpT3JE1UoIF?=
 =?us-ascii?Q?B0ZVdRUomhX25tglaL3w3Yr+r/iB/7ZaDUT4ygpV46dRPN5/oU7nL7RYwupi?=
 =?us-ascii?Q?wf94FLCIW7D5i43c51uIJGd7aumn1MfYLwzqYQ5RiiFmw/qJz+1PUqggYtxa?=
 =?us-ascii?Q?mHgRLVjbAyMkJRJL+jcOu6pWrGNGXC9Px177MWYnT2cLUfQuuq9iyjVsLR7A?=
 =?us-ascii?Q?asnHYhwcIuxSN0M1SVCKO5FZeqrWjG1YZ8saiHCPVS/83b8clovEArg2Q4qH?=
 =?us-ascii?Q?unqY5TLKX/u9G7zE2o2iYtd/b9p2LNeXsLDNIHsbazHfc8QsN2/vtRQajtQ+?=
 =?us-ascii?Q?V7J1aM9Qo9EofyIMbWGpr5/edfibmK2ECD5EEjSm909qUlsW3WpoMozTzr+I?=
 =?us-ascii?Q?fghpm9HF4MDVwhu+LlQQtn4jlDlF6fkfMJ7nGtR318gTK/WoVSQyaoNap0Ue?=
 =?us-ascii?Q?BK3kxWh6nW+lHjQA7/eRwCW8ga7/+GIgb9WAYmSyMl7PyX0z29Ssfnf8+PaX?=
 =?us-ascii?Q?zdeUSK6rOldSem5WCzcKgoNTPVZcfZ0Of4ZvP6oSk0sJDlkbGSzR0EM3bqv9?=
 =?us-ascii?Q?Vj7IWKDcqWCDTh6Z0CWoURX47wWW3PWPZPRC8+LjaIZ1UPlzc65f6f0zV2pP?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c286ddab-e63f-440d-35ef-08db26ece6a6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 13:38:33.0284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sXJwerMiIcPlTLQQeWbDyEtJ57YNuVHLXRgIffOHyYw8DX1j04zq2/XC1T9FHgTjQSlvroLT0CNZgjWGXVYTYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7688
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

On Fri, Mar 17, 2023 at 03:31:15AM +0100, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Define common binding parsing for all PHY drivers with LEDs using
> phylib. Parse the DT as part of the phy_probe and add LEDs to the
> linux LED class infrastructure. For the moment, provide a dummy
> brightness function, which will later be replaced with a call into the
> PHY driver.
>

Hi Andrew,

Personally, I see no good reason to provide a dummy implementation
of "phy_led_set_brightness", especially if you implement it in the next
patch. You only use that function only the function pointer in
"led_classdev". I think you can just skip it in this patch.

Please find the rest of my comments inline.

Thanks,
Michal


> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/phy/Kconfig      |  1 +
>  drivers/net/phy/phy_device.c | 75 ++++++++++++++++++++++++++++++++++++
>  include/linux/phy.h          | 16 ++++++++
>  3 files changed, 92 insertions(+)
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index f5df2edc94a5..666efa6b1c8e 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -16,6 +16,7 @@ config PHYLINK
>  menuconfig PHYLIB
>  	tristate "PHY Device support and infrastructure"
>  	depends on NETDEVICES
> +	depends on LEDS_CLASS
>  	select MDIO_DEVICE
>  	select MDIO_DEVRES
>  	help
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 9ba8f973f26f..ee800f93c8c3 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -19,10 +19,12 @@
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/kernel.h>
> +#include <linux/list.h>
>  #include <linux/mdio.h>
>  #include <linux/mii.h>
>  #include <linux/mm.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/netdevice.h>
>  #include <linux/phy.h>
>  #include <linux/phy_led_triggers.h>
> @@ -658,6 +660,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
>  	device_initialize(&mdiodev->dev);
>  
>  	dev->state = PHY_DOWN;
> +	INIT_LIST_HEAD(&dev->leds);
>  
>  	mutex_init(&dev->lock);
>  	INIT_DELAYED_WORK(&dev->state_queue, phy_state_machine);
> @@ -2964,6 +2967,73 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
>  	return phydrv->config_intr && phydrv->handle_interrupt;
>  }
>  
> +/* Dummy implementation until calls into PHY driver are added */
> +static int phy_led_set_brightness(struct led_classdev *led_cdev,
> +				  enum led_brightness value)
> +{
> +	return 0;
> +}

It can be removed from this patch.

> +
> +static int of_phy_led(struct phy_device *phydev,
> +		      struct device_node *led)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	struct led_init_data init_data = {};
> +	struct led_classdev *cdev;
> +	struct phy_led *phyled;
> +	int err;
> +
> +	phyled = devm_kzalloc(dev, sizeof(*phyled), GFP_KERNEL);
> +	if (!phyled)
> +		return -ENOMEM;
> +
> +	cdev = &phyled->led_cdev;
> +
> +	err = of_property_read_u32(led, "reg", &phyled->index);
> +	if (err)
> +		return err;

Memory leak. 'phyled' is not freed in case of error.

> +
> +	cdev->brightness_set_blocking = phy_led_set_brightness;

Please move this initialization to the patch where you are actually
implementing this callback.

> +	cdev->max_brightness = 1;
> +	init_data.devicename = dev_name(&phydev->mdio.dev);
> +	init_data.fwnode = of_fwnode_handle(led);
> +
> +	err = devm_led_classdev_register_ext(dev, cdev, &init_data);
> +	if (err)
> +		return err;

Another memory leak.

> +
> +	list_add(&phyled->list, &phydev->leds);

Where do you free the memory allocated for phy_led structure?

> +
> +	return 0;
> +}
> +
> +static int of_phy_leds(struct phy_device *phydev)
> +{
> +	struct device_node *node = phydev->mdio.dev.of_node;
> +	struct device_node *leds, *led;
> +	int err;
> +
> +	if (!IS_ENABLED(CONFIG_OF_MDIO))
> +		return 0;
> +
> +	if (!node)
> +		return 0;
> +
> +	leds = of_get_child_by_name(node, "leds");
> +	if (!leds)
> +		return 0;
> +
> +	for_each_available_child_of_node(leds, led) {
> +		err = of_phy_led(phydev, led);
> +		if (err) {
> +			of_node_put(led);
> +			return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
>   * @fwnode: pointer to the mdio_device's fwnode
> @@ -3142,6 +3212,11 @@ static int phy_probe(struct device *dev)
>  	/* Set the state to READY by default */
>  	phydev->state = PHY_READY;
>  
> +	/* Get the LEDs from the device tree, and instantiate standard
> +	 * LEDs for them.
> +	 */
> +	err = of_phy_leds(phydev);
> +
>  out:
>  	/* Assert the reset signal */
>  	if (err)
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index fbeba4fee8d4..88a77ff60be9 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -14,6 +14,7 @@
>  #include <linux/compiler.h>
>  #include <linux/spinlock.h>
>  #include <linux/ethtool.h>
> +#include <linux/leds.h>
>  #include <linux/linkmode.h>
>  #include <linux/netlink.h>
>  #include <linux/mdio.h>
> @@ -595,6 +596,7 @@ struct macsec_ops;
>   * @phy_num_led_triggers: Number of triggers in @phy_led_triggers
>   * @led_link_trigger: LED trigger for link up/down
>   * @last_triggered: last LED trigger for link speed
> + * @leds: list of PHY LED structures
>   * @master_slave_set: User requested master/slave configuration
>   * @master_slave_get: Current master/slave advertisement
>   * @master_slave_state: Current master/slave configuration
> @@ -690,6 +692,7 @@ struct phy_device {
>  
>  	struct phy_led_trigger *led_link_trigger;
>  #endif
> +	struct list_head leds;
>  
>  	/*
>  	 * Interrupt number for this PHY
> @@ -825,6 +828,19 @@ struct phy_plca_status {
>  	bool pst;
>  };
>  
> +/**
> + * struct phy_led: An LED driven by the PHY
> + *
> + * @list: List of LEDs
> + * @led_cdev: Standard LED class structure
> + * @index: Number of the LED
> + */
> +struct phy_led {
> +	struct list_head list;
> +	struct led_classdev led_cdev;
> +	u32 index;
> +};
> +
>  /**
>   * struct phy_driver - Driver structure for a particular PHY type
>   *
> -- 
> 2.39.2
> 
