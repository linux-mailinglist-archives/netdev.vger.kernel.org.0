Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CEC6BE8A6
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCQLzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCQLzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:55:13 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD5FD306;
        Fri, 17 Mar 2023 04:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679054110; x=1710590110;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nXhykB7Uwt2G/ncZtaK4HezXlTf+gYMi9mSSxeb+EBM=;
  b=m8qCSO6bhmBhsXf5kK+eVesXO0ajwYD/3BT29xOdNm4p6XUT88gnogBx
   IoGmTxtPItmF1DDk7NIXW0rrKZtubWFAf04Aq9uUdCayciC8qOVoLBFPS
   XrTs7bs/lwxBLLmyWt1dtNlpGnUBEp4h5X8EurJT5KnHyYz84XAY6y5vR
   RoeqGXjcoGHI77V70rCu6jEvDC4/Qg1Jme6VuiffrgpqhKQzETeBagWer
   69OcWNFZuPOr2RYE6rHryL/OjuVtXhexifsNrYQvtDMCLsrlPFUhRBkZY
   PLocQWH43pFMEU9SB7DOCYP6pwAsGfcG4JeeMHz1XwHsWSjk3fPAMlUY6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="403111599"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="403111599"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 04:55:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="712726497"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="712726497"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 17 Mar 2023 04:55:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 04:55:07 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 04:55:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 04:55:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 04:54:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6Ecrtel/HVRkThA4a4T88/jIXvTH0x8YbM12wJNbtCVHjKTZI72gRZc5NVD2turdGHec2RyxNZfNY18RpDEnc5dWnUWmooSQzS9WzaX8CuvBNDP3pn/sMRZT+wcvnbpXemsN1rBCTSQVMWZd7rKpLRXCaML4Ne9acY+70M0TFkx3QwEVLPSV0luVGeof2IDNMUGY+zcXXjz6+YWoTcAlFjgTpeS0NdA3g9d746n/75irxkIHcTdvi35BWcHOZb4CFwc5SimhwAk873nK8ZalNR9LIMn986pdFliln+M6sIz/nCdU2oP890SqCx6g6LXf2BXnymS1nF9fdgO/qxQiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SG+O9V4YMVAKuD2ERKzMzCyCsM0Sl3xB8AoQfxbDRUA=;
 b=hUWzvxa7bK9Q1xsW4LIfZCc2Y6IvSn9Tey02bvvEnCK6J6kM18YLhnYd1m7bW6OJ0gd6djqUCsWIC91prkEvkjkfKJUB6vv7XM28CXFVSyP5eSRIPLJAGI+msDdkI9iuSPaRiI4xXn4q1plir3gIjXAlS+kSlJFfhRIFTYfZMYFZQ4Av1zGYtznnQQj+meEKaRcu7smDzS/TUi25Whp26pRhu85QJgD7j3UAgYLlbdQpEEfQXJWMWjg71rbQOSEVNRmWyza1J4AOndoMdWwlmvl0xSSGpCbXgqJumi3LAxhEO+PJUYp0SI0PMLxl1h6enrFHMVmE9qPoMfwOkiunkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SA3PR11MB7979.namprd11.prod.outlook.com (2603:10b6:806:2f9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.31; Fri, 17 Mar 2023 11:54:29 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 11:54:29 +0000
Date:   Fri, 17 Mar 2023 12:54:09 +0100
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
Subject: Re: [net-next PATCH v4 03/14] net: dsa: qca8k: add LEDs blink_set()
 support
Message-ID: <ZBRU4Xx3kCwbD3Eg@localhost.localdomain>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-4-ansuelsmth@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230317023125.486-4-ansuelsmth@gmail.com>
X-ClientProxiedBy: DB6P193CA0001.EURP193.PROD.OUTLOOK.COM (2603:10a6:6:29::11)
 To DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SA3PR11MB7979:EE_
X-MS-Office365-Filtering-Correlation-Id: b736aefe-eb35-485c-72cd-08db26de5d2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +PgYLu5gl8skDhyushZDwkM5D/TGYqllZwojReafjBbgRK683qkpriaOXXqU3aeJIUw4FPSRRwTVWnH1ErYuK6Wj+1aUyLSpN/Dbw1Icn1i2DqaDyp5GCnDiE6O4fGcEgGz4cq1ob5U7NzfVoMufB0b2LffQdugaosdABQ+f4w8M8Q28rCKJO5+wIj9UsDb5YlTYNwklwkt5RbwbppRobSu8XPoBj46EbQMjuP8WRGTmplbtzzgVKmpTIudif83R8OVrCFTXWV7f5HbBl+vVyZoO+tJKQvTUxJT33Ifh6W6nmHqR8Gzq3c/Dln0IsXou2EOONcDFkkX/yJpcCdpfo+Jz35jMFI9K8OSgl41nmS7gbD99mF37t10GFSZXvD/w9kKWNPQX6t/5B0O7B0xF2EwkygMMSRBe5MvOIQzcGcNC4msqQ9RjnBVQ5Gm1cs1EeAKJAiTYYAbJoTosRUcIVxkIp6vqg6y78X/H4qv+1UFv4KStwJpDM5nj9+QdcUH4k9ZAuPKvNFWQPBLAyc0Q8G1WA/xfr1Qo2yJ9aSD5xKhJd0qEbenj+RoNQs80XEv+5rfO4I8BR8vWTanFzf9Zq0vXIbEzn1zRygL9dAwQS6jvZvsjuXtp0jL2wNOIsAZ6gRjQPj10FlB/u7n7qexTbFhyqzEtMPVWHdU+vnPaLwDuUzrm31Xm5OSvHsUNZIQQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199018)(66476007)(7416002)(186003)(5660300002)(66556008)(66946007)(8676002)(6486002)(4326008)(86362001)(478600001)(54906003)(316002)(6916009)(41300700001)(82960400001)(2906002)(38100700002)(9686003)(6666004)(26005)(6512007)(8936002)(6506007)(83380400001)(44832011)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OsylApcdvDoCEgyh+ne0gcDw8RGHI8Nhk1q2P5ytg1UMBFtnHyUVTO3a10mO?=
 =?us-ascii?Q?ukJct75Z61p//RjYw0qi2GDjPji3adpYPTnRV1Je2Dcfof4KUm3zNsvXFE6n?=
 =?us-ascii?Q?7P2zykuk8AJkC+mUix93yDDSAdM73pzZfMkNMrBIUbLGP1CFqxWxOXilmlTP?=
 =?us-ascii?Q?5C4r31DD0sziPeXqaFDEg3nKJorpLKO3moeAVTavsN00gse0hOSdKki4NNIk?=
 =?us-ascii?Q?kylj5CSKFqhC8XxGopUajNDP70T859ComvT/zw4k3vmJWPPjZRXnVu1hDpHv?=
 =?us-ascii?Q?gR00DO7GgGjriIcsTvCKf83wrgRboU1pUOF9PjS7x1aOX3PU/Xzzjo104i5v?=
 =?us-ascii?Q?B6Ql5BDifiwX2d3s2/39ZKsIeVKN1hU6YSELzAI/fyVFFOcD8rJA9oapu3dP?=
 =?us-ascii?Q?YnXvbQ+V6HXcwjfXs1bO6mV3b9ibLdgKFDFeb37RMdPWF5wmBzVsud73Yawt?=
 =?us-ascii?Q?bpK1FPkFGm2WDZ8JmrqK3WEr+hlLqba2CDpjwr15yIPlrYMO0rI75nbcQS+3?=
 =?us-ascii?Q?MnS4DCTQEl6iPMOMsSRJt/lqfKAozh5f3klhnyyE7xCHbpucU1GngTy5px/K?=
 =?us-ascii?Q?I5FoMBdW+8r5r9TDTlOW2bzSzreRfU3QE02ujifL0XYzJ+cK5GTdMPuYA2IK?=
 =?us-ascii?Q?1h9T34cAg/YdtRUOJRI6fQo5sWlTfGG9zZi7TVP1eQRM3saDoPjzqsOdF9LA?=
 =?us-ascii?Q?KN9ODTar8M0BQxSjI1lGACaw1puaALngGGF3+EjExoMwdSOz0qOs5EiHLYuJ?=
 =?us-ascii?Q?2Sz75WIbk5sN/e+snIdM1ovw3EDAm+5w7N3Kjb0kcE63AQQbDPdlkZdZUI+n?=
 =?us-ascii?Q?lX35vLwEriB4TXN+lHzkqCk59W2ciwS9BmHT1gxpQfo4k2cA8hTEoiVdEAxE?=
 =?us-ascii?Q?nH6nDS4/eQXvpZlaensfYaxiOsAjq5wsctgBxgQVi35Wmym1j/jLz9mzuvC9?=
 =?us-ascii?Q?3xe/ibo8kaAsofa7+5N7K5vIqPR6D9G8Uc58u1OkJtxhGEHAcL/UcGVHYG/G?=
 =?us-ascii?Q?fwqWOP+dwRzLgParhMCoShUvC7UKLgm2OuXXrJQtMNnAdobr3iXWhB0+1D6k?=
 =?us-ascii?Q?DSzgWfw4nh4+aY0MV9GX1/ehphGaVKVXuivNsOYjeziWqb6PkSbaut9mGcGI?=
 =?us-ascii?Q?9LIfLFw+VpD3SH4OV6I5TQOJbHMQXcXq8DxXdApVh7qBFvnV9qgeneCNt0kx?=
 =?us-ascii?Q?cQBYXwQnbrUlOjLwzzq5z62Oz8GfCQu4l2Dyd6LEHaeVUIciP7nChUrvBl5O?=
 =?us-ascii?Q?0boaQGdYZvyOBYlSb64QwJDWd4Kua1gaj2zz/3gUr6cAqagr5tSXFwJF4svk?=
 =?us-ascii?Q?Yl/7c6+R7ukCdejdkNgNj32KG4OMJAApJbUCoENFMIYCMtG1emOQ84zKXj/o?=
 =?us-ascii?Q?QlrjfDzL14/uk7ochq9CNpkHR0PNCqKP9zNGNlSPsVDybsGEkmDVFLwXQ8LI?=
 =?us-ascii?Q?0pHvSZXRTFj1j6kGPHnc0sh3/RSNR8GV/gGwzTlouOUfcgfGQHeSI5Oum+kw?=
 =?us-ascii?Q?avkor01+Eyr4TsmqBa/OycIl2JRhcZvt4Hdk5aWA6PIbKkH5t7xwV0zHYNVc?=
 =?us-ascii?Q?Apo3cMojwiyxrMygulHp85fLM6ftgNCFfifc0rBO/DILExNEaSlbpYTn6QZD?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b736aefe-eb35-485c-72cd-08db26de5d2d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 11:54:29.2474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5iDdR1/Z9Ju0X/I6PQBKISXCSOkQr+9JuA7jK00f5NenLzT3l7BWg82b8lXgSYaNplHjPMZ9aJ6hZ9KkNv2b9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7979
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:31:14AM +0100, Christian Marangi wrote:
> Add LEDs blink_set() support to qca8k Switch Family.
> These LEDs support hw accellerated blinking at a fixed rate
> of 4Hz.
> 
> Reject any other value since not supported by the LEDs switch.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/qca/qca8k-leds.c | 38 ++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
> index adbe7f6e2994..c229575c7e8c 100644
> --- a/drivers/net/dsa/qca/qca8k-leds.c
> +++ b/drivers/net/dsa/qca/qca8k-leds.c
> @@ -92,6 +92,43 @@ qca8k_led_brightness_get(struct qca8k_led *led)
>  	return val == QCA8K_LED_ALWAYS_ON;
>  }
>  
> +static int
> +qca8k_cled_blink_set(struct led_classdev *ldev,
> +		     unsigned long *delay_on,
> +		     unsigned long *delay_off)
> +{
> +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> +	u32 mask, val = QCA8K_LED_ALWAYS_BLINK_4HZ;
> +	struct qca8k_led_pattern_en reg_info;
> +	struct qca8k_priv *priv = led->priv;
> +
> +	if (*delay_on == 0 && *delay_off == 0) {
> +		*delay_on = 125;
> +		*delay_off = 125;
> +	}
> +
> +	if (*delay_on != 125 || *delay_off != 125) {
> +		/* The hardware only supports blinking at 4Hz. Fall back
> +		 * to software implementation in other cases.
> +		 */
> +		return -EINVAL;
> +	}
> +
> +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> +
> +	if (led->port_num == 0 || led->port_num == 4) {
> +		mask = QCA8K_LED_PATTERN_EN_MASK;
> +		val <<= QCA8K_LED_PATTERN_EN_SHIFT;
> +	} else {
> +		mask = QCA8K_LED_PHY123_PATTERN_EN_MASK;
> +	}

Could you add a comment as to why the HW requires different approaches for
inner and outer ports?

> +
> +	regmap_update_bits(priv->regmap, reg_info.reg, mask << reg_info.shift,
> +			   val << reg_info.shift);
> +
> +	return 0;
> +}
> +
>  static int
>  qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
>  {
> @@ -149,6 +186,7 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
>  
>  		port_led->cdev.max_brightness = 1;
>  		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
> +		port_led->cdev.blink_set = qca8k_cled_blink_set;
>  		init_data.default_label = ":port";
>  		init_data.devicename = "qca8k";
>  		init_data.fwnode = led;
> -- 
> 2.39.2
> 


Thanks,
Michal
