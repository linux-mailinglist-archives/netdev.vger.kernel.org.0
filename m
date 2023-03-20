Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55CC6C1EA6
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjCTR4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjCTR4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:56:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83263B651;
        Mon, 20 Mar 2023 10:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679334642; x=1710870642;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RavQDPA98iCQ3T0XZLxeCDnROGXP3qxJWTB11WTO/aQ=;
  b=Gt4cV1KqWFd5ScGbKWXR69/csktjWQZfkZsGsxkzBKW93CyZXwZda2Uc
   ibq0o5vO9Za92DLPB7ZPka3hQ0PWPDJa56/8hsJPwtm/m7SvBS/Qlk7Ql
   H2NelBF/ve5S5P+X2Dcm1kbZAfehhKuuFLqxJ2ftL+FidzFw7+xI5z+bF
   /+KI38Ztg6INDuEoWJEVPfpTYTiaWURiWKO3qUiRhI7FewL5Z9Bbxmg9D
   6haZmayim4tSoHW7qO1zNFuSjN/J5UOm9B2NevLA3p6ODi9dYFyJWu+bU
   Cz691PQQFZ+UVvIc0jA1U1NHcqKGeSKsR79uXB5uDt5ufx2kHWNopq9Jz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="340279952"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="340279952"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 10:49:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="855336865"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="855336865"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 20 Mar 2023 10:49:25 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 10:49:25 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 10:49:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 10:49:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaEIQ/65EideeJht8FJd2MGpr+A9XCeS9CR8pg3JjVxxWXvekrRWu2YU90eF/5D1LOY/I+BgKg66Gc2cMyrneFrqrmv59bTXoKWHlIpttlh133mGdoNaxH/vsnqf3hU076HPCzkAyobqPM/ngkLsDnOY2+0E+2POISJ0aEW5HkKVZoL3hQvY2NK36L653D4GfwjEIMASAWxhwpQAmQD+MsyPVj25Ccbc3JtXZN5fOLHne8CyV2vC1tHhCfOzJ81GNGSETmw31XM4P7O8wqcumvBSA2yEG3Sym9DUPuPpRlaB4zHtFZfK+Bhyxfu07YjqT+hzqIPbpCJLYbZJsKGvVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1DLj0drSsXEkXGnMhnUsHI0seFX502tsZeoQVHcrHoM=;
 b=naLIQSdMkaywKrUfazm/BIZQvp0MIctoKE/JYXeRnQXmZ4sisRQok/nXYCseHhVkUqTzAm2kIIExo5ex8a9M8Qrnw4yzRl+gReBtk7SDEOGI85I8P0JYDmSnnq6Hbl5DhFU7PGe1+HvQCUb0FSL/eDUS3lz23NoB9DfsZpfiuk2Z5ThG6px+MPO41m8DrgB5ImP6NeXbwCYiuqjV6MG5H5CzbhHVTVO4oUIutu8tN5zNqvDzgDeqSPa7HWpEBg/FexuK64iVLkOG6wKKdmNjEd1GEGDli0y51VNoUwXCUiBCOF6OtWGGXTeqcLZoHjpY19TNF1aQ4/xhQms76wDTDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 MN0PR11MB6280.namprd11.prod.outlook.com (2603:10b6:208:3c0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:49:06 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:49:06 +0000
Date:   Mon, 20 Mar 2023 18:48:51 +0100
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
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: Re: [net-next PATCH v5 02/15] net: dsa: qca8k: add LEDs basic support
Message-ID: <ZBicg28JwVLugzqz@localhost.localdomain>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-3-ansuelsmth@gmail.com>
 <ZBiKDX/WJPfJey/+@localhost.localdomain>
 <64188af6.050a0220.c5fe1.1d96@mx.google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <64188af6.050a0220.c5fe1.1d96@mx.google.com>
X-ClientProxiedBy: FR2P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::19) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|MN0PR11MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: cc64fb90-9b50-4845-55a4-08db296b6690
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Pgp2wD7M7vYBT4YdDuDSqctM/T7TWekgBe+xAvPXfKu03S1Yub18VC6Hg+CrDB9Y/LsXH0LcqHxHFzyQw4HUjM2FyuJhbZYHTs9xUv+0fHrOY4M6vrWp1mFByMMnKDeliMehw52lZsTBOtOXbdYH9JKIx1LwlutV5jJOCpXKbMY+jSpnvRmqH2XjLOZgVJ5rge1Nrx3IXq9/DJi9QZfrszZuopWpquHHHDmhyOQsa8Eu3DSc0q5WNghHTIkAhKGiFE7ywpE6jt7CSKlL/Bpf0BLmc4+ms7LoDT35/5hjqooosA1FvT5BO5aQ7NHZtL1/1DI7cOXOB/KKjmN9eAEGyyT4wj2FB3Tw04PFeoaGjQcpOCPAmpi6K/PodEZm2YEFlYAaDG9PWU1GXsVDRB1Yz/4nDTM5s9QdecYbLKBfll2Wy1qmdoDoIpyR718/+8CnCExqa4pTiej1DdxlzcdfC5HZbKxzF5fSwdcRWd5140u0zI9a4fqp16f8g4dj7s3spCDIXHSG29u+oN34Vl1yYeXrsLT4Aac9qiQRPwcogORYCsa83NpHztOSFOknfWqcQSuXdMjRK0X2PSNG8EBclhBDs6VlVVqXg+5v4lqZlW+1Swu7ZwFSfLZqZyz0vQF1T7c5UQT0xCdUOzQKGXIKrac9+dM+f78hLINyzhFJ3IvjtNFlNd49tuTXcVMEH3x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199018)(41300700001)(4326008)(6916009)(8676002)(66556008)(66946007)(66476007)(38100700002)(82960400001)(2906002)(44832011)(8936002)(26005)(5660300002)(6512007)(6506007)(7416002)(6666004)(6486002)(186003)(86362001)(83380400001)(9686003)(316002)(478600001)(54906003)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?krMAT4DTGXc3aK8e6nFs7mCW/hifFPGLBHqee50OYOsFIv17AXj49ufFQ1mT?=
 =?us-ascii?Q?GkoizY4M7iTlHMHZzoA1X7iaH+yakgmcjcxfG6NG91ehGecbJHMTuJR/hWvc?=
 =?us-ascii?Q?VIEqQ+KT1QNydNzL8FuX0PvAuyQGVQPFkRdZ/HHZIr1GAEhsEu0laYuNiAzw?=
 =?us-ascii?Q?HKd/2XPBrBjVTFK884/67OY0cNc1Ok96B9KbtZcbYJ00KoPbJFlkGflJsp+Y?=
 =?us-ascii?Q?YrjyEf1tG08MpuqtwugecKJeA8RS5beDGHeY58IDPvGbTneeUVIherFIKl20?=
 =?us-ascii?Q?o72avzgRmLQP4Lu+iJ1tNRPPBMrvgIatVMqeKpxSb/Bd4Sk1YWLmMYh/aADq?=
 =?us-ascii?Q?AIFLUs4kGduqBrjm/YHl6AW7anyUj55Ttm6ykadl3Yt+NX5G0b31xc7Klqtx?=
 =?us-ascii?Q?GGAOzBonbgSadhhE2aRgFlvopyFD5W02H4EExAXEmPbxKFx012HDdp6QCW/K?=
 =?us-ascii?Q?7xJkrmpOx7aG6AVnDpPYJ+fgHz52/e9fCUNedtzQLZ9hzmxt/fpsPQdpclFQ?=
 =?us-ascii?Q?rrDvvgZq+VG27RLzTsT9aFhh1JxdtV/bm70lWhgslw15EPkLyGUeGd7u9gZX?=
 =?us-ascii?Q?x6sjiyDQ89Ivxb4vo9CkBT2CClYmBB5h1969zodLH+dP/0ssxQGiTxIh0SJ+?=
 =?us-ascii?Q?UEu2vBNDvXNHasMO8tzOxEjN6ScGmyEYCc6ELzrEb7/NU4TCa1jBAr6tHWfr?=
 =?us-ascii?Q?9RmIFVnoTjm62jzSW+5Q+8x6ZhexRFYMPdwp77vlWEWhueyOb0kG7N08aPrl?=
 =?us-ascii?Q?Yzwg+qWM95DCcGf0DdahqZ80B2br2Dl9MqPqEl+fVYiq0O0s2+mnwBGtVBhN?=
 =?us-ascii?Q?BVxMKfiNy1gdL6SX8x0uL9FPFUBv0oUXY7eHlFrgawH3Sw3LlP6SsS4MFH/D?=
 =?us-ascii?Q?8zYsscVAJG66tNLcZMtCJwbERLu+FMA99W80pZrdg2l9TTUQmICnwyoZhI43?=
 =?us-ascii?Q?NJ1I/DAAOQVYpYkY7EFMu9je1Xty7exCNddAVlbJxP1pZretV8mDMqzleq1s?=
 =?us-ascii?Q?cwWUWIqhouPschPMK1/KodY1Y2Kim9GgM74ptmQ4GM+1dTXrlyOumqhnzKO7?=
 =?us-ascii?Q?0EX6K9QTifNP78DuECfazKJ+wbiHlFJ9ef7UopIu6EMvulZdvPsPrEFAAswc?=
 =?us-ascii?Q?AmFuLwVXVVYgVKgybISncq3LT8udoIZ5MuGYy2u5K5dV/YSAORxgfdpoxEWg?=
 =?us-ascii?Q?X81ZdiG/LGP505LFrY33qT2fQ3s8CF7yP09APUyVYaCAcFPno4dke4gFkvtu?=
 =?us-ascii?Q?l0IooYG3MmzXg0w8X3oRWvJ08B8oYA1YS1IeJYTVhxE4TF6ArKeOHeUqWNaJ?=
 =?us-ascii?Q?XACV7J+ksB0zo7kKi4RwURb6+1aHX8frtttBnbhC/6k7jqPBbhAUdqii3nls?=
 =?us-ascii?Q?4kXnqQuZ6bAhEXBo8qc1E90KTB323D6uk+1YjX6muBwa3UWxoBECOysJYKiF?=
 =?us-ascii?Q?aiHex8z4VNttE2Rpy52G3ffnGIS/a+/ya/0mvPHXI6dVlCtub3cgu6ClCpU0?=
 =?us-ascii?Q?UY9MHmnYsNMOqiCaPGIA6A0bCmaebajBz8C/FUQSBUDT80MBzgdaWLSNoNGT?=
 =?us-ascii?Q?d2X1SebdkepmGlxW+j/nTJtrNudjlLgTWmNKh42Nw7lBVdIZ1U/0/RMTo9YF?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc64fb90-9b50-4845-55a4-08db296b6690
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 17:49:06.4375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZD23i9xb3Ba81g2sSIy3RTe45ut5Tni+fJbdLL4SlonRkpdwIRNJF+1DLCfpWr3zY+yHS03R8aHQMYMnhOjNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6280
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 05:33:56PM +0100, Christian Marangi wrote:
> 
> Btw ok for the description of the LED mapping? It's a bit complex so
> tried to do my best to describe them.
> 

Yes, now it is much easier to understand the logic behind LED mapping.
Thanks for adding that! I think it will save some time for anyone who
will be working with that code in the future.

The only thing I still do not understand is the initial 14 bit shift:

>	if (led->port_num == 0 || led->port_num == 4) {
>		mask = QCA8K_LED_PATTERN_EN_MASK;
>		val <<= QCA8K_LED_PATTERN_EN_SHIFT;

For example, according to the code above, for port 4:
	- the value is shifted by 14 bits - to bits (15,14)
	- mask is also set to bits (15,14)
	- then, both mask and value are shifted again by 16 bits:

>		return regmap_update_bits(priv->regmap, reg_info.reg,
>					  mask << reg_info.shift,
>					  val << reg_info.shift);

because reg_info.shift == QCA8K_LED_PHY4_CONTROL_RULE_SHIFT == 16 for
port_num == 4.

It means, in fact, for controlling port 4 we use bits (31,30) which
seems to be inconsistent with your comment below.

>	 * To control port 4:
>	 * - the 2 bit (17, 16) of:
>	 *   - QCA8K_LED_CTRL0_REG for led1
>	 *   - QCA8K_LED_CTRL1_REG for led2
>	 *   - QCA8K_LED_CTRL2_REG for led3
>	 *

Are values for ports 0 and 4 correct in your description in
"qca8k_led_brightness_set()"?

Thanks,
Michal
