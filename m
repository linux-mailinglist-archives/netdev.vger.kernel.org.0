Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DA46BEA8F
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjCQOB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjCQOB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:01:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2008C298EB;
        Fri, 17 Mar 2023 07:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679061676; x=1710597676;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AhBsa0Y69PBUaAs55HDXcxmxnkbzYgMsBfozd/r3ZYs=;
  b=muDnoVOasCfRXxJC3xCv3dRU0V7sZPzwuhl5J1MwC6Lc+zj5yay3AzzN
   v34b6dqlGHMgSXhb53yW/HaKr6Q4+KEMhLfV4AtMIYfuvo9NXVJcdJ4c/
   jAIH66I1NPXX3gXQhK8d/HoIcbRgnf52OrfqVGrGlXeJMIqcHAneOTGku
   x8zERG1llapnI4yPYqPPmgs6zq+uaO4VQTKf5v0gC6jY7OWwdwr8gkFAE
   m0Ps2BjJdtWgVZ3jr3LLjcDxhJYPRiHSTbqBFLPnJhoU2IExLM4McdaDM
   Knfy6QcHnRCZssOQJJLqJsGUvLZwjabTVQFN3lhomexGk90ZFIZDvfJSG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="338283270"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="338283270"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 07:01:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="926152163"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="926152163"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2023 07:01:12 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 07:01:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 07:01:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 07:01:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTVzKtsAtDsfixBVTP2bYYAwzWSLatAuF+i/U2ZjRVGV0YYgHkDTQK+tAL3HONyR3j/QKxZBbq6EScurHuAu4cElhMUzALn/7OpSOxLiyUfCrQyMZDFpc2zUSRI/jwVX737rqeCDZx+imehBMlunK07ym0VcnONOF4WEtfD12gRotvFrbENh7s8jxPRAeIDHO9JSBkhUYsTRHQY6juZKAuD/RYV8JSqN1yrSfwXVfNLFyXeYWUOloMYxX6NxyOvI4fZacE/urF99iTS0cQ3wlXEl0ggCISkLtvg/fu1cd6bLCi3uhgKmdBpVa88M6rq9Q9iET5lim/aQ/ELfJtfqCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rKAAmiJ3kbv04xcVkLhq9ka2a8osBBoby3qov+xTIxw=;
 b=dT0w8bzaFjzn+nC+kc6lNhnqhFRkcrk26q4cLI8uF/FvY3C/xRSi0kSzQ5ME830Gg+gSIyyh7+PTU3qe1c+ApV/d358B1nmVYbRCDrL4a6qnCMg6cWBEs0138iYau2Pj5Nc7eS4ISWk20rR4NRXAdvpdQPbcOUCopkoVCHUCwdRc54ylQQquFEb2PqoV0cGGZD5OG8bxdRAGbLm83DlSTQ78nHmizNhos0RyIfS6lNnxTIJdAJ/1GCaC2pF7faB2Hjwd6hcmaTVbsjRLQzkZjOy2CvKzPNWF2P+iOzkUPDpIHZHprEQ4kulpy/37KU2k2iXwxOkCRg23PCqfGc2TsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SJ0PR11MB6717.namprd11.prod.outlook.com (2603:10b6:a03:44f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Fri, 17 Mar 2023 14:01:09 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 14:01:09 +0000
Date:   Fri, 17 Mar 2023 15:01:00 +0100
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
Subject: Re: [net-next PATCH v4 05/14] net: phy: phy_device: Call into the
 PHY driver to set LED brightness
Message-ID: <ZBRynEEAefKZcVgS@localhost.localdomain>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-6-ansuelsmth@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230317023125.486-6-ansuelsmth@gmail.com>
X-ClientProxiedBy: FR0P281CA0066.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::12) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SJ0PR11MB6717:EE_
X-MS-Office365-Filtering-Correlation-Id: ece2cf97-f55c-419e-c8b2-08db26f00eea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wqqUfhumSp5SXsY36aD4EvUca+q4gc7L7nYbXLR5ACS9ijgTzeF/U5K674WSW80iY8/wc90JgFCoE++QzNS3Sz19Ph0qD/T1TRK1PwUHaZs1SudnTcX7bij1oxIdeZnTJMoTNHblNpDN0CYx0KV8wnH4dFkwI5MZJLoNPoHMDRfOnCb+WBhjw+OXK3S+aydAvnGdZCvOmWM4SnaRIn+XYCjCPT7uf952l6vHWyYwzVbc/5Uk1i2eNZ0CB3IZ3W4Zq8F/adOx+40H4S07Z8DGl1ZC6Xzjtnu4Mfa5fxWANz/bEHUJbQzocgyBT+xUbMuJymohZHxBCrvYQc7+uXMUcWW6q1Ua7GkX3jzmlG1EiebYl5tpfnKGNfnd4AWG8MhrijUJFQTmHIrDTvxK+FqocYxZeioTcQs7bCez40+QGbALxKgKUISzzHRo85ltjkEDvY0JuXiApa6to4Yp1KC8Cl6DvmXkiGDomM5UUZEOLPo2iZHLvXOZ8JilvILV5attz2bBffzbBlJITx9ic4eULW/I0I5212aV5RNFhehWqrX9kYQ9ZR2MNxaQqA9BjtecxWG/TzCtk2kmVgMCSRcTDRaBX90jFtVFMqhyY1Ia6pyvIxmUQP1NUNQ3pHMIatJPPBSf+o+HTJd0/Zje7t3P8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199018)(6666004)(54906003)(316002)(86362001)(38100700002)(9686003)(82960400001)(83380400001)(6506007)(186003)(26005)(6512007)(7416002)(478600001)(8936002)(6486002)(6916009)(5660300002)(8676002)(66946007)(2906002)(41300700001)(66476007)(4326008)(66556008)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CDsOTAHe/8J6Dsyum4sur2QNyYUEhUfR+G54mvwn/7mIyRrv8rwrPb7Hl9un?=
 =?us-ascii?Q?dgFo1tMbyl5TiC4/A0DqCOG0yCpZ2FKi8GI7HEQqKEaqQ3Voln+tdZhHbZ3T?=
 =?us-ascii?Q?zT7KSD9/04oWSVdAp1Kp3Wq90YBFVrPTWKABfRwjKBe6UirZZgT+XJIqNBjv?=
 =?us-ascii?Q?lV0K2fJ8kzDYYqHLrfUQ28J21o791U2EnDvDNj+7dVaMcavXonHIrcnoUFnl?=
 =?us-ascii?Q?14bpGVcK07d3ke/ey/ECcQFaYODTTqNbhLi0k9NQNS6rIFgtFZDMupqPMzwR?=
 =?us-ascii?Q?NXj6M+QW++w8iz8QCkHR93Ig7B6bADG+NY50iDnJIMXccqo1FM8zc3nFl0Ss?=
 =?us-ascii?Q?ejfyNXKG/26GHNO9QpuPFTun0hHGH6NBf/C6qDoslfKjkZCQdFJSRXSBJyfk?=
 =?us-ascii?Q?+aHP6qjGZye0++WjcpVyr+qlP2mqHMQerIFIRqoPHleXjPsJQOT+Hq9Sipov?=
 =?us-ascii?Q?rKJqL8uJ25ratzqOncjF0sqtSLhNLT5ZUCJdNSZiCU/nY3yv6leg3xRWlAkJ?=
 =?us-ascii?Q?4EhMDrolypC/PNRZ3BVlt0jeVE4bF+AwROOlfBHU8j2IPTlCET+IQE7wvbNx?=
 =?us-ascii?Q?C1VCiSrOguD0x+uKSMsUvv9gPQSK1BA2Lu8XQx+kOGOEFhJEu+BGtwfiKqAa?=
 =?us-ascii?Q?hmkMizZqz4y6h5QuMLkerq2mAaxYR23bG3Ikj/KXdq1W+4WghrqnM+7/eRBe?=
 =?us-ascii?Q?02N2TD2OHNw0214sQDKZdgXcU3/BXSUEwvx7PKsQZN8nK9+3gOtbey1SoD8V?=
 =?us-ascii?Q?MnuYrVhDU/qP37wj8rCpLBIVFgpz2Po9Un8G4WBWA3qIRuT4O4Y49Aqp7Fpz?=
 =?us-ascii?Q?4FQKegjflK2FiqaTVndA2WeGkxkDaEsnXWjYcnaoGZmAa943dYJK4dwH26dK?=
 =?us-ascii?Q?JaYefCXhcwKKvRAGUSBo+TJCvsfLAwxGAMTFL/TuPZFPZjJV9jpVxLP5RAQH?=
 =?us-ascii?Q?bPIsOZry9plEHgFKq2cBjz44B/Gm5TA+BST6h58sgeWNaLPrNKzU1B16YZYu?=
 =?us-ascii?Q?WRqepMIWjgUkMnk7X6tKQTxoKjBOr/9oCFhKypA+Mgc18TllCWB1OVO+2mZw?=
 =?us-ascii?Q?6x2f6LvjCWUtkwRVsDQAuam/7vIWA2dq3GSJGyg8uBpvL30EvtBHbs/gFMOL?=
 =?us-ascii?Q?j5ZVt+Iyzq8c0P5Z4wTZ6eWIHTv5bB/TM41WlLsibf6wn9ekGtLfHUjOv4wh?=
 =?us-ascii?Q?iXYP0MMD/mOVLmGJeEV12magRs3Hd7AKCWAiKrC9dZxQ3NJBJRC0fy26axuX?=
 =?us-ascii?Q?1yPsGdvh2zk9xODXi4IRMCtWY9uvfecHMz6RCOTjmxg8SMsER7bYNBPptCIw?=
 =?us-ascii?Q?UClLRrWybaNpKH0R6riZ6dm27GmBTiige0uWQGZqPdNvakDswIlEpxb3/2Wk?=
 =?us-ascii?Q?b1GtKT3vtdwQbCBBUwDp4Py+9W0DTeMsvaT5GCCo4D1K9bnVh9swrLO76z5r?=
 =?us-ascii?Q?9fHh80+THLrdwDIG7geRTirkVO7n0sgMbRLtH3oMJt6Kl8BnE9//LIgJ4hZL?=
 =?us-ascii?Q?/r3qsOSfgJzBS663mJYigOBI8HYr6kPIDnarqIbFbEWytzNZ+LTY1Ighlc49?=
 =?us-ascii?Q?Vdr3S9uGlAAVm3Yx/7ULqhc4DzkyBdlyVVP6t4PwbUV9d1FkRpQ1UO16OgHd?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ece2cf97-f55c-419e-c8b2-08db26f00eea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 14:01:08.9675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X94XrkkUejram/1xnF5lkrgtge8wkv7Na9/Eax5msbWX86yYiV2B054Y341MVCLARukyad8Elf5GTRAwn7/ibg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6717
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

On Fri, Mar 17, 2023 at 03:31:16AM +0100, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Linux LEDs can be software controlled via the brightness file in /sys.
> LED drivers need to implement a brightness_set function which the core
> will call. Implement an intermediary in phy_device, which will call
> into the phy driver if it implements the necessary function.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

As I have already mentioned in my comments for the patch 4, the final
version of "phy_led_set_brightness()" can appear here (without
an intermediate step with a dummy implementation).

Thanks,
Michal

>  drivers/net/phy/phy_device.c | 15 ++++++++++++---
>  include/linux/phy.h          | 11 +++++++++++
>  2 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index ee800f93c8c3..c7312a9e820d 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2967,11 +2967,18 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
>  	return phydrv->config_intr && phydrv->handle_interrupt;
>  }
>  
> -/* Dummy implementation until calls into PHY driver are added */
>  static int phy_led_set_brightness(struct led_classdev *led_cdev,
>  				  enum led_brightness value)
>  {
> -	return 0;
> +	struct phy_led *phyled = to_phy_led(led_cdev);
> +	struct phy_device *phydev = phyled->phydev;
> +	int err;
> +
> +	mutex_lock(&phydev->lock);
> +	err = phydev->drv->led_brightness_set(phydev, phyled->index, value);
> +	mutex_unlock(&phydev->lock);
> +
> +	return err;
>  }
>  
>  static int of_phy_led(struct phy_device *phydev,
> @@ -2988,12 +2995,14 @@ static int of_phy_led(struct phy_device *phydev,
>  		return -ENOMEM;
>  
>  	cdev = &phyled->led_cdev;
> +	phyled->phydev = phydev;
>  
>  	err = of_property_read_u32(led, "reg", &phyled->index);
>  	if (err)
>  		return err;
>  
> -	cdev->brightness_set_blocking = phy_led_set_brightness;
> +	if (phydev->drv->led_brightness_set)
> +		cdev->brightness_set_blocking = phy_led_set_brightness;
>  	cdev->max_brightness = 1;
>  	init_data.devicename = dev_name(&phydev->mdio.dev);
>  	init_data.fwnode = of_fwnode_handle(led);
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 88a77ff60be9..94fd21d5e145 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -832,15 +832,19 @@ struct phy_plca_status {
>   * struct phy_led: An LED driven by the PHY
>   *
>   * @list: List of LEDs
> + * @phydev: PHY this LED is attached to
>   * @led_cdev: Standard LED class structure
>   * @index: Number of the LED
>   */
>  struct phy_led {
>  	struct list_head list;
> +	struct phy_device *phydev;
>  	struct led_classdev led_cdev;
>  	u32 index;
>  };
>  
> +#define to_phy_led(d) container_of(d, struct phy_led, led_cdev)
> +
>  /**
>   * struct phy_driver - Driver structure for a particular PHY type
>   *
> @@ -1063,6 +1067,13 @@ struct phy_driver {
>  	/** @get_plca_status: Return the current PLCA status info */
>  	int (*get_plca_status)(struct phy_device *dev,
>  			       struct phy_plca_status *plca_st);
> +
> +	/* Set a PHY LED brightness. Index indicates which of the PHYs
> +	 * led should be set. Value follows the standard LED class meaning,
> +	 * e.g. LED_OFF, LED_HALF, LED_FULL.
> +	 */
> +	int (*led_brightness_set)(struct phy_device *dev,
> +				  u32 index, enum led_brightness value);
>  };
>  #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
>  				      struct phy_driver, mdiodrv)
> -- 
> 2.39.2
> 
