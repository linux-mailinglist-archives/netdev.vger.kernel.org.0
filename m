Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35E96BEC9A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjCQPM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjCQPM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:12:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B2AAF28A;
        Fri, 17 Mar 2023 08:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679065956; x=1710601956;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qmU8kcPV4pN5prld2zz4uUcFJXg1EpiKHraJRPFuHaY=;
  b=HJCcrFJ0bRwvdvApRStY+XNhML3Z0WNc8ebUFwH5LTLaV8jXwX74fo+W
   STDnydZNivbracIzg7yCImlE9pz3FxFxhODMLpW8OXl2qnVoDyGRqzTTU
   jgKUVmHBf4KqMnEX2vuK/b6d6QhL/dXqGM/Z3FDstxtTNwsacv227uTcG
   Gvq/tiI9kSYkW+l2448PqCP3EF9jVMQqjMNhTmJdVjHEWBrfyn8i6Y60p
   rbA3OS7VZQiUbLm48ruRosspFvyc86yuREotOCqpG7T/BDDsARNpTbtNt
   xq9zrynJtmpX9gZKIAhoqk0fuK1LgLdN9AKCBAwIPy9IvbeTUfeQyb752
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="338301086"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="338301086"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 08:12:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="673585619"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="673585619"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2023 08:12:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 08:12:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 08:12:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 08:12:29 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 08:12:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCjCT4zpReeN1/M5VWwZ5KTa6GT4XsMZn5vxutWuvFF/2GRmqtmtkHzNh6jNqBcXcDKMum4DCdXkVLWL12rpHtaENIGVLZ4lPqCglRCAavTrxzKT1PpZs26roO+sBzDRKFGKli/JT1VwLTRBGShfMFOgPyH8HvH95qhs5p9LiAZSDnKgf7fXFjp8ItV8Z/MRfIYjoISyCWFojcYV6xBm/Sm6qPehgJYv2fJJTqQLnQHGND+07orMQcdJq3upLjVW5GD9w0ArhV9TH91TgfjQA1V1mu0UVzdk6ZBSZ+sQFYVJgfDIwlxDixMMN2VUo+dxiUktZYYWUQ1O/YEoW6Bu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYIhqnUZVrLeFnUb4H8IIgMWCSy5YHTZRSK3a+b7HZI=;
 b=A6LF4dHBage/2Co8sxdqMBCJ+UMPEIzWFYftRrrgjHy4LCIV6SM+FhlWoZXrFBehloLa+nx24ukT8vFQcm1DeKnndfBHTEzh7jV2TatL0cQBMXUwGUIXxcnQvzFygw77xgpz+N5lu38jeLtVjyKLCw/MPueHtWwmmv27ZvGHU4KJItDe4eEFwzL2Kv9InG3NirQ47qw9iIqR+a7ZARkknZcZhUOtboyD7m7s0vN5rMIkUQOEQNH80QAdvO3MxWRHy/8W498daHGkxjazz5tRcI6jN4Jz2FLx3Sgi010w6L3a8nN4p5JSjmyrTvkcsvffRW0MiG/dZXa/5zdlz/Q7FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SJ1PR11MB6153.namprd11.prod.outlook.com (2603:10b6:a03:488::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 15:12:22 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 15:12:22 +0000
Date:   Fri, 17 Mar 2023 16:12:07 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
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
Message-ID: <ZBSDRw5MF431wxz1@localhost.localdomain>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-5-ansuelsmth@gmail.com>
 <ZBRtRw8pg0mcRxbZ@localhost.localdomain>
 <f292505c-ab74-47f4-be7f-18dd4a7e2903@lunn.ch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f292505c-ab74-47f4-be7f-18dd4a7e2903@lunn.ch>
X-ClientProxiedBy: FR3P281CA0182.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::17) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SJ1PR11MB6153:EE_
X-MS-Office365-Filtering-Correlation-Id: 588d2904-56f7-472e-ac96-08db26fa01e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rzHB/GlZH6H9t0yjdk26H/zIScf7LpZhbqqvtk3208mor3MHvSMwkcOE08vULwGKLDbrV3YsK6YKBERJ7Jh5uljC5CGBS832vH+kkET7nz2c8zXW6PW0+GxRxwY5NVOTCgnzoIwVHOIqXKoh1gWM3lmhPPHeCAwP8ibzc0SvFyAh425mhlJil1+XeNBpO7Oe41QqCo3pavo1OlpNqaKVob5Yeu18Nep7OcA2ALK1SzWZt6lgW/zkhQBvZCl3LXnKeHYC4hB69HUxoYNGR0vUXzTBQxWVpajot5JW8+lQHYYAOaPhN6EXncRre/yrsa1zAKSk/snSdSP6TR6HXxu+O6yrN0Z4oOYgBifLdeQ7e4b8R1tUxlk9SHgVaT0aJBpT2dlooK7IJeK/Du2+uDYVCSK/z9HbaI6dHP+e5Xq3I4b9yq9IqBm6hQ4X/19G9rRmP6q5/34cb4ycBcSxbChMG/2My7EA+GZOgXr7imYCJO+q6TvuGgBcwp8jBRtXA0BZOb4qbOOu5ks9St65nP2QLjLFfb1hzVr/NmEB65r1SU35RF6swnYaOhaC64usLHxSZZdPFxuwYdxs/D5v33c0k4y4WtWi3Mp16sXT18373lQoAw1EZWuTURzHtFgeUVabkOk3ZV+klNWmlDBjTFjAeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199018)(6486002)(86362001)(186003)(9686003)(7416002)(8936002)(66946007)(4326008)(82960400001)(2906002)(8676002)(6916009)(66556008)(41300700001)(44832011)(26005)(5660300002)(6666004)(66476007)(6512007)(6506007)(54906003)(316002)(38100700002)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zv+0U5xmlDTL62z/vwuvNuxwT1Sy4V+qjBaKqLqfdc/t3Suan8+sNf6QMDvy?=
 =?us-ascii?Q?vuHbkGOVcrjAApisAvuRX2kdZYKbzZnmUWy2DLBgMNQEnFZMgTW/yiG1hRpo?=
 =?us-ascii?Q?odcmlPVAdMKeefaIqXtfIy7eQtXkSsdB9nS4AbzKGSP+hhW8h5HuMlp/y4Dd?=
 =?us-ascii?Q?mAWIi+w3lNU2xfHpWNXKPawTkuzK4Puj0Srq33yuWqwpODNTA4LY63Rwgn2J?=
 =?us-ascii?Q?fyPWBrao4hx10ebLI8ejiDE5X0bptRSmqCYBJj5jmqSnLVbJGOb7u9HDk4SJ?=
 =?us-ascii?Q?V/k052EWrnaIdUzB9AzwQvTzAh25AFsOjCs2/f9WZW2j0gfy6C749/sJzj1S?=
 =?us-ascii?Q?MrJxftrcodEwG/7FJyi24aBTRzNdJzIfMIvQHJPK5TztTASy2GqrqdRD8shX?=
 =?us-ascii?Q?6ziZbCGl2UMuiAPwvgriLyImMnYfsQfL6iA4cjiCXFZ/ZzwYUf17ZAIxsABf?=
 =?us-ascii?Q?rkKFJ1D22Jhs4kvyZOMUjKSIh0+HpMMMonADV/B2F4xhU5FEAh7P6h4Uvv4i?=
 =?us-ascii?Q?v90PbVsH9PVCVkk8rbBlPOy8YmUasrGY65D5ooQ9pvE02GfaJznZSc83cDHA?=
 =?us-ascii?Q?HkKAcXdAEd9ORu1oPnzx+irc7vYLnxF+2v5q+61K2Vq/sN36TnoAdEoyDjLQ?=
 =?us-ascii?Q?T1orEtcji7gWC2tTW6EeE8s+LjHvW673WDId3W0QRxm3HnJ+mltXpchvgTqR?=
 =?us-ascii?Q?1OG+Lq1Pl7mNaUV69UndccgIdE4eng/OW3gEqOm/Yi5Hk7F5p/Qu6yA/qxyq?=
 =?us-ascii?Q?knr02cT5KV5CLogFX9AUFVC3f8ybnGXiVQWEwfVJPP+WbkMjv9F3OeGyHBj0?=
 =?us-ascii?Q?JIrOhpYJ/xx7VUFFGxk8BmMjMwBKNY9Y+2Rszq8LF/X486klsPXl6WNs95cJ?=
 =?us-ascii?Q?ASzUaubblRcN1BSL+MgIuAwQ4e/ugWwYSwV+YCKaYXYfM802Vs/M+U3IAzqQ?=
 =?us-ascii?Q?3B+U0Cppz58kAycwtAC0vC4l33ZX7g51/p7CIT3J1ZcO14mBXf86uWTjpwlk?=
 =?us-ascii?Q?Zt1NFUuDZWbvtcRiXBBuMLGun9A4MtswhkhVgmy+QeR+OuEuKglAerT7GPZ6?=
 =?us-ascii?Q?ixPB9GLaxkXY6/iodMT0RGGMPWCoZFm0wsNWE1xIGMhTPigEh0rbezSCF+Aa?=
 =?us-ascii?Q?L/5iEieybScS7QZAzN+F/0UsoQ2Mav6sQa4L35b3kTyg0MQHkIkKK/olfHs7?=
 =?us-ascii?Q?X+oaLnoWGejMRRqpBgRsGXuu/m8XV3X0IN2oq0oyD80miqUdGgL1qMllMW40?=
 =?us-ascii?Q?ys8gzD6Txh2YvRaJirl20tO0zi87rfUINLaDOlw4EVpjKfBO0hVcAv4+usZB?=
 =?us-ascii?Q?oEf9W48G0H28aYtZejNLXnbQ+StGzyn+rLpSta6ZnrXd78EO/J+QgNew1QJb?=
 =?us-ascii?Q?uuAZsjh7FloCwAm13IAyPgyXiOC+5XPrSt9v9TCujhvYS4ztGf7vh8WlXar1?=
 =?us-ascii?Q?eM2gMMPL3sTItMSIbOenb4uOv71bAtIKBP4DtPnVPVlR0iVg58K3qWJYBW7B?=
 =?us-ascii?Q?+OVH4fcCvwKMwdqKnQv2Jo7Z5UsVBnDf+ZnR0XXSTmzrGuV3sOobtKXamYCK?=
 =?us-ascii?Q?mh0mYIGXlKEFojPOSQ13d43bUNrjFxxO998/8a8RurxJVurKbGdgU3Vh3Rb+?=
 =?us-ascii?Q?Hg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 588d2904-56f7-472e-ac96-08db26fa01e3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 15:12:22.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /JCB8qGONY1iAMawpw1KEYhi0phDOKtOD1SawrBv6AaAn/rwgujmxrn5wel+MJUuHcU5nlCDc2kf18/C+S2uiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6153
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

On Fri, Mar 17, 2023 at 03:03:32PM +0100, Andrew Lunn wrote:

> > Hi Andrew,
> > 
> > Personally, I see no good reason to provide a dummy implementation
> > of "phy_led_set_brightness", especially if you implement it in the next
> > patch. You only use that function only the function pointer in
> > "led_classdev". I think you can just skip it in this patch.
> 
> Hi Michal
> 
> The basic code for this patch has been sitting in my tree for a long
> time. It used to be, if you did not have a set_brightness method in
> cdev, the registration failed. That made it hard to test this patch on
> its own during development work, did i have the link list correct, can
> i unload the PHY driver without it exploding etc. I need to check if
> it is still mandatory.
> 

Thank you for the explanation. I was not aware of failing registration
in case of undefined "cdev->brightness_set_blocking". I think it is
a good reason of defining the dummy function. (The only alternative
would be to squash two commits, but I think it is easier to review
smaller chunks of code).


> > > +static int of_phy_led(struct phy_device *phydev,
> > > +		      struct device_node *led)
> > > +{
> > > +	struct device *dev = &phydev->mdio.dev;
> > > +	struct led_init_data init_data = {};
> > > +	struct led_classdev *cdev;
> > > +	struct phy_led *phyled;
> > > +	int err;
> > > +
> > > +	phyled = devm_kzalloc(dev, sizeof(*phyled), GFP_KERNEL);
> > > +	if (!phyled)
> > > +		return -ENOMEM;
> > > +
> > > +	cdev = &phyled->led_cdev;
> > > +
> > > +	err = of_property_read_u32(led, "reg", &phyled->index);
> > > +	if (err)
> > > +		return err;
> > 
> > Memory leak. 'phyled' is not freed in case of error.
> 
> devm_ API, so it gets freed when the probe fails.
> 
> > > +
> > > +	cdev->brightness_set_blocking = phy_led_set_brightness;
> > 
> > Please move this initialization to the patch where you are actually
> > implementing this callback.
> > 
> > > +	cdev->max_brightness = 1;
> > > +	init_data.devicename = dev_name(&phydev->mdio.dev);
> > > +	init_data.fwnode = of_fwnode_handle(led);
> > > +
> > > +	err = devm_led_classdev_register_ext(dev, cdev, &init_data);
> > > +	if (err)
> > > +		return err;
> > 
> > Another memory leak.
> 
> Ah, maybe you don't know about devm_ ? devm_ allocations and actions
> register an action to be taken when the device is removed, either
> because the probe failed, or when the device is unregistered. For
> memory allocation, the memory is freed automagically. For actions like
> registering an LED, requesting an interrupt etc, an unregister/release
> is performed. This makes cleanup less buggy since the core does it.
> 
>    Andrew


Yeah, it is my fault, I apologize for that.
I didn't consider neither the probe() context, nor the lifetime of the
list. You are right - I had no experience with using this devm_ API,
so I looked at it as a standard memory allocation.
Thank you for your patience and this piece of knowledge.

Thanks,
Michal


