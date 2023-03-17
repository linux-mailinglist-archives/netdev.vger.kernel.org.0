Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8C46BF05D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCQSGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjCQSGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:06:30 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CF7B06CF;
        Fri, 17 Mar 2023 11:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679076379; x=1710612379;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+J2yEXvDWpmmyEMHRtafyEOMmGct6BnhY6GiLHfe0HU=;
  b=him6SZCYuZAjhZiCEJYDOwyGKL9AVBIU8cVwBH5zkLoIMFkjaXJmQcI9
   l9yyZXndY98Fk/lnJsvuY2O4kY7k5QuxC+ypev9le/BA0Ia/fdrhw+q9V
   GJhEHPHa0TPkonPttm11qF82i6GNL4cD0OcN1nkALaWU2rWnl/zrUWMeo
   EvH827VhNeXFLCv0yTSs4x9KVFW0fovrn/uaLEIavsohVYhEfpzynL/zK
   qQcGRUtgQgXBET644NlRG41lVH9imQvNNba+eZvIQquv5K/LKWctvln2X
   aeYr8Wlhe7QiNBHoLlxrfiuLEcnHnRVsRzUKaJoogtHBh1vLH+as661RU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="400907578"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="400907578"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 11:06:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="854531325"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="854531325"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 17 Mar 2023 11:06:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 11:06:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 11:06:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 11:06:17 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 11:06:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUtacUpNIclbPH5HMYle85BXE5pS9fdrxNIwVQH9YK4FZW47/btJXXpajJkJFlCDQJxI4lMFMgsjJJ0FutPxX/rMIYcPYO8C3qFqZaQPRDzqtufrRGg1Fz/W8ycEdwl+kZzaXT2/q5iwEJP3Rr6z/ytJfvpNuhHe4AG9dG/FJ7oCTmTR448/pPu1aPDzVL/+JEsuFWUDXiWcXCFiNMRcMBI81MSIDnZTtktauPHmCF9k+QE1pzW8ZnJuGDqApm6KyX5wU4pw3XvNV4vgNLfc/UVCrzot42GmOhik0S1BUhRcfvxkku64ajoSqUqX2TdjtN5AGmCRuZuO2y95PkV/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UTnM4WgBIJ9i6KJrIpll4rbJy3YoI8vKif6fWO7N4w=;
 b=d69pydIAkdkDVLbEOmqCrsvMU/PFuqaeuAeSRf877Uqzf+CMNiNEFkhTjLGc4VKVF5T4cMKy9Gf3ZzXjupEAhx2D5C8zK1cGWU5pAclL5rctSnrJaTBiwbcOn9sfSofaUXt02AlqpzQH3ASNM534jXscRElkNZNW6YF7L6kuFinO2dDUv+X6V0lRYCbwEY1qVJRmhg4UPBs0FVI0u7ow/GyKmc0wbqTYqpivfkHJcJIjx8pd7GeWwoeAPZcZlei6eipqmEd4pQxdkcmtZVL3Wh4DcXdOg294Gg8iL0nv4706STfM96cYiVyRXa47zPRpy2HiKXyMDYZm9fbWFfSmIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SJ1PR11MB6228.namprd11.prod.outlook.com (2603:10b6:a03:459::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:06:14 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:06:13 +0000
Date:   Fri, 17 Mar 2023 19:05:57 +0100
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
Subject: Re: [net-next PATCH v4 02/14] net: dsa: qca8k: add LEDs basic support
Message-ID: <ZBSsBap/ThahJEt3@localhost.localdomain>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-3-ansuelsmth@gmail.com>
 <ZBRN563Zw9Z28aET@localhost.localdomain>
 <641472bb.1c0a0220.b0870.f070@mx.google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <641472bb.1c0a0220.b0870.f070@mx.google.com>
X-ClientProxiedBy: FR3P281CA0071.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::7) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SJ1PR11MB6228:EE_
X-MS-Office365-Filtering-Correlation-Id: 19a49c8a-6624-423a-9e29-08db27124b84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XnPfnnWB9zhp/IxNTGjSiWiXYdaZSOZKUGZYoymbIS2QrXmt1CH1W/zivzhxs4jGt15SHSXZWVlQD39G7q5SzR0sopfKZGF+ChP0tsrWeUQLGq6XzQ88iIwtxftJWW5vA05yKgLxMYN23s/f59a8o/5Ae6/p2Ayi6CNSkUZfixA/Vc9IMDW+OEBG0pwuW2ofsg5rcGl3d7YASC4B+kAOuhr91/VVZNsvnMS/2XOIcC+4a6Qe19dm3jvP8ogSaAtXocYL1cafreTgf2rv8+Ln6zW4wVBLBoCRoVK8eblq7Yk7ybtixiewjDnrrqjLNtdyWS1/kJ/Qavnw7/HOyq8ApIfmDos9EeSPtx/5Zo1E/IVepJfrIdZtH3GqiLa11tu7Y+ZS2cpaE6qwtufoXgs9IoUWb+wgdbDdx6svTuuFCEIti1cCdy3lSHCHs+jGmAXnaDbIh19RDUvqUSmRb5p/Ukv8hNUvAQzjalOTNbKH4tzXjawq8bH6kuphpgoJ79SJdHhlu+jVvfJXh6su4fk6/YrrPqttUUQjDIDK+HbXxDJOB3NiYs4W4iUFzrbAGI/veTm8Z9pfirYVso4T/inUlcXsJLjnp/Zpzl+SD+BHfhxMNWXvE+ecSg/MLk0uQN1PieFEQLXxeg9CWSk22fdX9QxAqkVFsXG1ThWFf2E22+P+wSlG9FkQF//Ow62xj1wH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199018)(316002)(6512007)(26005)(82960400001)(6506007)(2906002)(478600001)(54906003)(41300700001)(66556008)(66946007)(6916009)(4326008)(66476007)(8676002)(38100700002)(6666004)(5660300002)(9686003)(83380400001)(7416002)(30864003)(44832011)(8936002)(86362001)(186003)(6486002)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y217qGNXar7MvxJ/JrGXcLsSzsRR/TZ50/zPmTGmo2UEWV3j0mFoB/u5KSvM?=
 =?us-ascii?Q?TmXhie07pP+2B4kUuIhfMZLWIlsHKy95kHoFwPuiMvOQwvWali1bqHO8sVdS?=
 =?us-ascii?Q?t+G3CHUClmy6h4B/KSLKqRpdh0qrISUuCMlGegT5rdQkKg7nKlniZnUG7cQR?=
 =?us-ascii?Q?IGImJIIh5EB1z1KVYfmdRyYWNnQQSZ46JhwOageBE74NoisS5cQiHCUeKAsH?=
 =?us-ascii?Q?bSgYxkRYXuuEOL9WC3KdPpBCPnmjPGDXXHSoMDuzGTyswU1u912cnwhC6aw0?=
 =?us-ascii?Q?3FEo6rbKYshMf3+30sfPWTtxiyTY4OoLC+u5xh8QOLY/IkIloo7dFF7jKmqp?=
 =?us-ascii?Q?gR6ZfHp21m6WpyKTf4u4G0e+IpG+gjs9hkb7ea+c0lTt4xiUhcGQiQs6GewW?=
 =?us-ascii?Q?5EmZQXrrnm235QW9duGZCKLsoteCfD+sFbVHRNlMkJXNUzsDDL102Phk+vKJ?=
 =?us-ascii?Q?bcCqYPNJWl+YJxBAzZKEKImY3RLZ9+Rd95l+mJBydjRzmS/hE625y87G0kOV?=
 =?us-ascii?Q?pCq/u+EWAwKnxtxiOOa8bPlG4v032fsqwupmnM7x6y+ETUZmLtJXhQpYEqmG?=
 =?us-ascii?Q?N65BMfcA4rIjF6I10aBs4TUyI8bxvm0Qv3SlOgtPIygmn2B5IduOICZSePpj?=
 =?us-ascii?Q?rT29R2GSrDgmkDGhITnKwHJng1gdvT9b34Px91wUmXmG8Fx4HJb7DKRaipFE?=
 =?us-ascii?Q?NCbZiPVzt25tZALdLpvpAzpZzeTr2GwqOnVMYPAiq48oltSVfPqmY/i0txvH?=
 =?us-ascii?Q?sd9I4JG/OGsI4Ldhe9PYuQz9wAHt0B7cUfyTm2nsICydHBSCyZ+Ouoii/EFm?=
 =?us-ascii?Q?v7Qt9C3hoAO7uIhIPlGlGr/OBhLbgMQYDE8k9KmZHLSnNJz/RjdxLzAk0iJW?=
 =?us-ascii?Q?fgvMwd3Awi2+IotKduxC5wl38ZtuLAjUrlvDb4+1nr9C7COQX773hc0fcf/c?=
 =?us-ascii?Q?FRkxz8tTUUBdBi96N6BiTquU45LpyxB2yD2WeMZjYs9AnK2heZky2U+24FxJ?=
 =?us-ascii?Q?TJV6KZ1dx6+VESAF4PG7rCtjjaqdCRgHtTelvgSZtzcqa4xtDhShvb/LGaK6?=
 =?us-ascii?Q?LV1mOApvrIdhAGbMhxZwbNHAIQOezh7rqYna/k925b7zlxDwr4f2xea5jYpe?=
 =?us-ascii?Q?BK9ncBcefxaN6rH94JFXR4uIRRFrKXxEYnXZqxDDnb1EKDPNZvql/SsD/Y/o?=
 =?us-ascii?Q?Tf9Nmj4F3QP7VuZH4INdytbaSACdaCbZusPKSavErJstFUL4yjCKH/Z5Dcur?=
 =?us-ascii?Q?lSQTWfY24Rrv4rP/MR1FPiKT9ff+Bs/LUIasL8oRDZUPGmr+ysbUsNpIHZa2?=
 =?us-ascii?Q?kw4l/csRC+xPFAYBeReSTjCwMICjG8pLT2rIS8lafmIJkF44Jop7HS2Ngk7J?=
 =?us-ascii?Q?gLv0RWzLwieqLjRuinAphxSSt3JQs6UW510igldcvGTCwlL3bde8ZD9JK85H?=
 =?us-ascii?Q?GuLHBjYy8er03zV0C5HhmAEgV/trZAGQdsdQATC1gFaA9a3yU237iRaKHvR1?=
 =?us-ascii?Q?hwKYKvfvIfqWvuYxY6+56V2BPgC2y9fubR0xWYBLj06otTf7H1HVwiy6TeMQ?=
 =?us-ascii?Q?c1PXAQKk2pTlacsmDHJLqJA1uDgBm8bvROVHROx5Fmg004e8dfiE48gecd3v?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a49c8a-6624-423a-9e29-08db27124b84
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:06:13.6996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KlLw9ZLH9rfZGtqfIfSkIUZ5/94sTjtJOAdbNO7dffcSrZnH53Jpc7/2suEzDVmgPMyuAifetQsgeaOnxhXtUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6228
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

On Fri, Mar 17, 2023 at 03:01:28PM +0100, Christian Marangi wrote:
> On Fri, Mar 17, 2023 at 12:24:23PM +0100, Michal Kubiak wrote:
> > On Fri, Mar 17, 2023 at 03:31:13AM +0100, Christian Marangi wrote:
> > > Add LEDs basic support for qca8k Switch Family by adding basic
> > > brightness_set() support.
> > > 
> > > Since these LEDs refelect port status, the default label is set to
> > > ":port". DT binding should describe the color, function and number of
> > > the leds using standard LEDs api.
> > > 
> > > These LEDs supports only blocking variant of the brightness_set()
> > > function since they can sleep during access of the switch leds to set
> > > the brightness.
> > > 
> > > While at it add to the qca8k header file each mode defined by the Switch
> > > Documentation for future use.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > 
> > Hi Christian,
> > 
> > Please find my comments inline.
> > 
> > Thanks,
> > Michal
> > 
> > > ---
> > >  drivers/net/dsa/qca/Kconfig      |   8 ++
> > >  drivers/net/dsa/qca/Makefile     |   3 +
> > >  drivers/net/dsa/qca/qca8k-8xxx.c |   5 +
> > >  drivers/net/dsa/qca/qca8k-leds.c | 192 +++++++++++++++++++++++++++++++
> > >  drivers/net/dsa/qca/qca8k.h      |  59 ++++++++++
> > >  drivers/net/dsa/qca/qca8k_leds.h |  16 +++
> > >  6 files changed, 283 insertions(+)
> > >  create mode 100644 drivers/net/dsa/qca/qca8k-leds.c
> > >  create mode 100644 drivers/net/dsa/qca/qca8k_leds.h
> > > 
> > > diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
> > > index ba339747362c..7a86d6d6a246 100644
> > > --- a/drivers/net/dsa/qca/Kconfig
> > > +++ b/drivers/net/dsa/qca/Kconfig
> > > @@ -15,3 +15,11 @@ config NET_DSA_QCA8K
> > >  	help
> > >  	  This enables support for the Qualcomm Atheros QCA8K Ethernet
> > >  	  switch chips.
> > > +
> > > +config NET_DSA_QCA8K_LEDS_SUPPORT
> > > +	bool "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
> > > +	depends on NET_DSA_QCA8K
> > > +	depends on LEDS_CLASS
> > > +	help
> > > +	  This enabled support for LEDs present on the Qualcomm Atheros
> > > +	  QCA8K Ethernet switch chips.
> > > diff --git a/drivers/net/dsa/qca/Makefile b/drivers/net/dsa/qca/Makefile
> > > index 701f1d199e93..ce66b1984e5f 100644
> > > --- a/drivers/net/dsa/qca/Makefile
> > > +++ b/drivers/net/dsa/qca/Makefile
> > > @@ -2,3 +2,6 @@
> > >  obj-$(CONFIG_NET_DSA_AR9331)	+= ar9331.o
> > >  obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
> > >  qca8k-y 			+= qca8k-common.o qca8k-8xxx.o
> > > +ifdef CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT
> > > +qca8k-y				+= qca8k-leds.o
> > > +endif
> > > diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
> > > index 8dfc5db84700..5decf6fe3832 100644
> > > --- a/drivers/net/dsa/qca/qca8k-8xxx.c
> > > +++ b/drivers/net/dsa/qca/qca8k-8xxx.c
> > > @@ -22,6 +22,7 @@
> > >  #include <linux/dsa/tag_qca.h>
> > >  
> > >  #include "qca8k.h"
> > > +#include "qca8k_leds.h"
> > >  
> > >  static void
> > >  qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
> > > @@ -1727,6 +1728,10 @@ qca8k_setup(struct dsa_switch *ds)
> > >  	if (ret)
> > >  		return ret;
> > >  
> > > +	ret = qca8k_setup_led_ctrl(priv);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > >  	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
> > >  	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
> > >  
> > > diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
> > > new file mode 100644
> > > index 000000000000..adbe7f6e2994
> > > --- /dev/null
> > > +++ b/drivers/net/dsa/qca/qca8k-leds.c
> > > @@ -0,0 +1,192 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <linux/regmap.h>
> > > +#include <net/dsa.h>
> > > +
> > > +#include "qca8k.h"
> > > +#include "qca8k_leds.h"
> > > +
> > > +static int
> > > +qca8k_get_enable_led_reg(int port_num, int led_num, struct qca8k_led_pattern_en *reg_info)
> > > +{
> > > +	switch (port_num) {
> > > +	case 0:
> > > +		reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
> > > +		reg_info->shift = QCA8K_LED_PHY0123_CONTROL_RULE_SHIFT;
> > > +		break;
> > > +	case 1:
> > > +	case 2:
> > > +	case 3:
> > > +		/* Port 123 are controlled on a different reg */
> > > +		reg_info->reg = QCA8K_LED_CTRL_REG(3);
> > > +		reg_info->shift = QCA8K_LED_PHY123_PATTERN_EN_SHIFT(port_num, led_num);
> > > +		break;
> > > +	case 4:
> > > +		reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
> > > +		reg_info->shift = QCA8K_LED_PHY4_CONTROL_RULE_SHIFT;
> > > +		break;
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int
> > > +qca8k_led_brightness_set(struct qca8k_led *led,
> > > +			 enum led_brightness brightness)
> > > +{
> > > +	struct qca8k_led_pattern_en reg_info;
> > > +	struct qca8k_priv *priv = led->priv;
> > > +	u32 mask, val = QCA8K_LED_ALWAYS_OFF;
> > 
> > Nitpick: RCT
> > 
> > > +
> > > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > > +
> > > +	if (brightness)
> > > +		val = QCA8K_LED_ALWAYS_ON;
> > > +
> > > +	if (led->port_num == 0 || led->port_num == 4) {
> > > +		mask = QCA8K_LED_PATTERN_EN_MASK;
> > > +		val <<= QCA8K_LED_PATTERN_EN_SHIFT;
> > > +	} else {
> > > +		mask = QCA8K_LED_PHY123_PATTERN_EN_MASK;
> > > +	}
> > > +
> > > +	return regmap_update_bits(priv->regmap, reg_info.reg,
> > > +				  mask << reg_info.shift,
> > > +				  val << reg_info.shift);
> > > +}
> > > +
> > > +static int
> > > +qca8k_cled_brightness_set_blocking(struct led_classdev *ldev,
> > > +				   enum led_brightness brightness)
> > > +{
> > > +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> > > +
> > > +	return qca8k_led_brightness_set(led, brightness);
> > > +}
> > > +
> > > +static enum led_brightness
> > > +qca8k_led_brightness_get(struct qca8k_led *led)
> > > +{
> > > +	struct qca8k_led_pattern_en reg_info;
> > > +	struct qca8k_priv *priv = led->priv;
> > > +	u32 val;
> > > +	int ret;
> > > +
> > > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > > +
> > > +	ret = regmap_read(priv->regmap, reg_info.reg, &val);
> > > +	if (ret)
> > > +		return 0;
> > > +
> > > +	val >>= reg_info.shift;
> > > +
> > > +	if (led->port_num == 0 || led->port_num == 4) {
> > > +		val &= QCA8K_LED_PATTERN_EN_MASK;
> > > +		val >>= QCA8K_LED_PATTERN_EN_SHIFT;
> > > +	} else {
> > > +		val &= QCA8K_LED_PHY123_PATTERN_EN_MASK;
> > > +	}
> > > +
> > > +	/* Assume brightness ON only when the LED is set to always ON */
> > > +	return val == QCA8K_LED_ALWAYS_ON;
> > > +}
> > > +
> > > +static int
> > > +qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
> > > +{
> > > +	struct fwnode_handle *led = NULL, *leds = NULL;
> > > +	struct led_init_data init_data = { };
> > > +	enum led_default_state state;
> > > +	struct qca8k_led *port_led;
> > > +	int led_num, port_index;
> > > +	int ret;
> > > +
> > > +	leds = fwnode_get_named_child_node(port, "leds");
> > > +	if (!leds) {
> > > +		dev_dbg(priv->dev, "No Leds node specified in device tree for port %d!\n",
> > > +			port_num);
> > > +		return 0;
> > > +	}
> > > +
> > > +	fwnode_for_each_child_node(leds, led) {
> > > +		/* Reg represent the led number of the port.
> > > +		 * Each port can have at least 3 leds attached
> > > +		 * Commonly:
> > > +		 * 1. is gigabit led
> > > +		 * 2. is mbit led
> > > +		 * 3. additional status led
> > > +		 */
> > > +		if (fwnode_property_read_u32(led, "reg", &led_num))
> > > +			continue;
> > > +
> > > +		if (led_num >= QCA8K_LED_PORT_COUNT) {
> > > +			dev_warn(priv->dev, "Invalid LED reg defined %d", port_num);
> > > +			continue;
> > > +		}
> > 
> > In the comment above you say "each port can have AT LEAST 3 leds".
> > However, now it seems that if the port has more than 3 leds, all the
> > remaining leds are not initialized.
> > Is this intentional? If so, maybe it is worth describing in the comment
> > that for ports with more than 3 leds, only the first 3 leds are
> > initialized?
> > 
> > According to the code it looks like the port can have up to 3 leds.
> >
> 
> Think I should rework the comments and make them more direct/simple.
> 
> qca8k switch have a max of 5 port.
> 
> each port CAN have a max of 3 leds connected.
> 
> It's really a limitation of pin on the switch chip and hw regs so the
> situation can't happen.

OK, so it looks like a misunderstanding.
I interpreted the sentence:
	"each port can have AT LEAST 3 leds"
as
	"each port can a MIN of 3 leds connected".

Most likely it is just a typo and it is a matter of changing "at
least" to "at most" in the comment :-).

> 
> > > +
> > > +		port_index = 3 * port_num + led_num;
> > 
> > Can QCA8K_LED_PORT_COUNT be used instead of "3"? I guess it is the number
> > of LEDs per port.
> > 
> 
> This variable it's really to make it easier to reference the led in the
> priv struct. If asked I can rework this to an array of array (one per
> port and each port out of 3 possigle LED).

I wasn't probably clear. I just wanted to ask if you can use the constant
"QCA8K_LED_PORT_COUNT" instead of a raw number "3".

BTW, I agree that "array of array" option seems too complex solution for
a simple thing :-).

> 
> > > +
> > > +		port_led = &priv->ports_led[port_index];
> > 
> > Also, the name of the "port_index" variable seems confusing to me. It is
> > not an index of the port, but rather a unique index of the LED across
> > all ports, right?
> > 
> 
> As said above, they are unique index that comes from port and LED of the
> port. Really something to represent the code easier internally.

Got it. I was just sharing my impression of the name "port_index" itself.
Maybe, "led_index" would be better because it actually indexes leds, not
ports?

> 
> > > +		port_led->port_num = port_num;
> > > +		port_led->led_num = led_num;
> > > +		port_led->priv = priv;
> > > +
> > > +		state = led_init_default_state_get(led);
> > > +		switch (state) {
> > > +		case LEDS_DEFSTATE_ON:
> > > +			port_led->cdev.brightness = 1;
> > > +			qca8k_led_brightness_set(port_led, 1);
> > > +			break;
> > > +		case LEDS_DEFSTATE_KEEP:
> > > +			port_led->cdev.brightness =
> > > +					qca8k_led_brightness_get(port_led);
> > > +			break;
> > > +		default:
> > > +			port_led->cdev.brightness = 0;
> > > +			qca8k_led_brightness_set(port_led, 0);
> > > +		}
> > > +
> > > +		port_led->cdev.max_brightness = 1;
> > > +		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
> > > +		init_data.default_label = ":port";
> > > +		init_data.devicename = "qca8k";
> > > +		init_data.fwnode = led;
> > > +
> > > +		ret = devm_led_classdev_register_ext(priv->dev, &port_led->cdev, &init_data);
> > > +		if (ret)
> > > +			dev_warn(priv->dev, "Failed to int led");
> > 
> > Typo: "init".
> > How about adding an index of the LED that could not be initialized?
> > 
> 
> Ok will add more info in the port and led that failed to init.

Thanks, but it's just my suggestion.

> 
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +int
> > > +qca8k_setup_led_ctrl(struct qca8k_priv *priv)
> > > +{
> > > +	struct fwnode_handle *ports, *port;
> > > +	int port_num;
> > > +	int ret;
> > > +
> > > +	ports = device_get_named_child_node(priv->dev, "ports");
> > > +	if (!ports) {
> > > +		dev_info(priv->dev, "No ports node specified in device tree!\n");
> > > +		return 0;
> > > +	}
> > > +
> > > +	fwnode_for_each_child_node(ports, port) {
> > > +		if (fwnode_property_read_u32(port, "reg", &port_num))
> > > +			continue;
> > > +
> > > +		/* Each port can have at least 3 different leds attached.

"at least" -> "at most"

> > > +		 * Switch port starts from 0 to 6, but port 0 and 6 are CPU
> > > +		 * port. The port index needs to be decreased by one to identify
> > > +		 * the correct port for LED setup.
> > > +		 */
> > 
> > Again, are there really "at least 3 different leds" per port?
> > It's confusing a little bit, because  QCA8K_LED_PORT_COUNT == 3, so I
> > would say it cannot have more than 3.
> > 
> > > +		ret = qca8k_parse_port_leds(priv, port, qca8k_port_to_phy(port_num));
> > 
> > As I checked, the function "qca8k_port_to_phy()" can return all 0xFFs
> > for port_num == 0. Then, this value is implicitly casted to int (as the
> > last parameter of "qca8k_parse_port_leds()"). Internally, in
> > "qca8k_parse_port_leds()" this parameter can be used to do some
> > computing - that looks dangerous.
> > In summary, I think a special check for CPU port_num == 0 should be
> > added.
> > (I guess the LED configuration i only makes sense for non-CPU ports? It
> > seems you want to configure up to 15 LEDs in total for 5 ports).
> > 
> 
> IMHO for this, we can ignore handling this corner case. The hw doesn't
> supports leds for port0 and port6 (the 2 CPU port) so the case won't
> ever apply. But if asked I can add the case, not that it will cause any
> problem in how the regs and shift are referenced in the code.

OK, got it. So, as I understand, the previous call in this loop
"fwnode_property_read_u32()" will never return port_num == 0 (or we fall
into "continue")?

> 
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> > > index 4e48e4dd8b0f..3c3c072fa9c2 100644
> > > --- a/drivers/net/dsa/qca/qca8k.h
> > > +++ b/drivers/net/dsa/qca/qca8k.h
> > > @@ -11,6 +11,7 @@
> > >  #include <linux/delay.h>
> > >  #include <linux/regmap.h>
> > >  #include <linux/gpio.h>
> > > +#include <linux/leds.h>
> > >  #include <linux/dsa/tag_qca.h>
> > >  
> > >  #define QCA8K_ETHERNET_MDIO_PRIORITY			7
> > > @@ -85,6 +86,50 @@
> > >  #define   QCA8K_MDIO_MASTER_DATA(x)			FIELD_PREP(QCA8K_MDIO_MASTER_DATA_MASK, x)
> > >  #define   QCA8K_MDIO_MASTER_MAX_PORTS			5
> > >  #define   QCA8K_MDIO_MASTER_MAX_REG			32
> > > +
> > > +/* LED control register */
> > > +#define QCA8K_LED_COUNT					15
> > > +#define QCA8K_LED_PORT_COUNT				3
> > > +#define QCA8K_LED_RULE_COUNT				6
> > > +#define QCA8K_LED_RULE_MAX				11
> > > +
> > > +#define QCA8K_LED_PHY123_PATTERN_EN_SHIFT(_phy, _led)	((((_phy) - 1) * 6) + 8 + (2 * (_led)))
> > > +#define QCA8K_LED_PHY123_PATTERN_EN_MASK		GENMASK(1, 0)
> > > +
> > > +#define QCA8K_LED_PHY0123_CONTROL_RULE_SHIFT		0
> > > +#define QCA8K_LED_PHY4_CONTROL_RULE_SHIFT		16
> > > +
> > > +#define QCA8K_LED_CTRL_REG(_i)				(0x050 + (_i) * 4)
> > > +#define QCA8K_LED_CTRL0_REG				0x50
> > > +#define QCA8K_LED_CTRL1_REG				0x54
> > > +#define QCA8K_LED_CTRL2_REG				0x58
> > > +#define QCA8K_LED_CTRL3_REG				0x5C
> > > +#define   QCA8K_LED_CTRL_SHIFT(_i)			(((_i) % 2) * 16)
> > > +#define   QCA8K_LED_CTRL_MASK				GENMASK(15, 0)
> > > +#define QCA8K_LED_RULE_MASK				GENMASK(13, 0)
> > > +#define QCA8K_LED_BLINK_FREQ_MASK			GENMASK(1, 0)
> > > +#define QCA8K_LED_BLINK_FREQ_SHITF			0
> > > +#define   QCA8K_LED_BLINK_2HZ				0
> > > +#define   QCA8K_LED_BLINK_4HZ				1
> > > +#define   QCA8K_LED_BLINK_8HZ				2
> > > +#define   QCA8K_LED_BLINK_AUTO				3
> > > +#define QCA8K_LED_LINKUP_OVER_MASK			BIT(2)
> > > +#define QCA8K_LED_TX_BLINK_MASK				BIT(4)
> > > +#define QCA8K_LED_RX_BLINK_MASK				BIT(5)
> > > +#define QCA8K_LED_COL_BLINK_MASK			BIT(7)
> > > +#define QCA8K_LED_LINK_10M_EN_MASK			BIT(8)
> > > +#define QCA8K_LED_LINK_100M_EN_MASK			BIT(9)
> > > +#define QCA8K_LED_LINK_1000M_EN_MASK			BIT(10)
> > > +#define QCA8K_LED_POWER_ON_LIGHT_MASK			BIT(11)
> > > +#define QCA8K_LED_HALF_DUPLEX_MASK			BIT(12)
> > > +#define QCA8K_LED_FULL_DUPLEX_MASK			BIT(13)
> > > +#define QCA8K_LED_PATTERN_EN_MASK			GENMASK(15, 14)
> > > +#define QCA8K_LED_PATTERN_EN_SHIFT			14
> > > +#define   QCA8K_LED_ALWAYS_OFF				0
> > > +#define   QCA8K_LED_ALWAYS_BLINK_4HZ			1
> > > +#define   QCA8K_LED_ALWAYS_ON				2
> > > +#define   QCA8K_LED_RULE_CONTROLLED			3
> > > +
> > >  #define QCA8K_GOL_MAC_ADDR0				0x60
> > >  #define QCA8K_GOL_MAC_ADDR1				0x64
> > >  #define QCA8K_MAX_FRAME_SIZE				0x78
> > > @@ -383,6 +428,19 @@ struct qca8k_pcs {
> > >  	int port;
> > >  };
> > >  
> > > +struct qca8k_led_pattern_en {
> > > +	u32 reg;
> > > +	u8 shift;
> > > +};
> > > +
> > > +struct qca8k_led {
> > > +	u8 port_num;
> > > +	u8 led_num;
> > > +	u16 old_rule;
> > > +	struct qca8k_priv *priv;
> > > +	struct led_classdev cdev;
> > > +};
> > > +
> > >  struct qca8k_priv {
> > >  	u8 switch_id;
> > >  	u8 switch_revision;
> > > @@ -407,6 +465,7 @@ struct qca8k_priv {
> > >  	struct qca8k_pcs pcs_port_0;
> > >  	struct qca8k_pcs pcs_port_6;
> > >  	const struct qca8k_match_data *info;
> > > +	struct qca8k_led ports_led[QCA8K_LED_COUNT];
> > >  };
> > >  
> > >  struct qca8k_mib_desc {
> > > diff --git a/drivers/net/dsa/qca/qca8k_leds.h b/drivers/net/dsa/qca/qca8k_leds.h
> > > new file mode 100644
> > > index 000000000000..ab367f05b173
> > > --- /dev/null
> > > +++ b/drivers/net/dsa/qca/qca8k_leds.h
> > > @@ -0,0 +1,16 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > +
> > > +#ifndef __QCA8K_LEDS_H
> > > +#define __QCA8K_LEDS_H
> > > +
> > > +/* Leds Support function */
> > > +#ifdef CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT
> > > +int qca8k_setup_led_ctrl(struct qca8k_priv *priv);
> > > +#else
> > > +static inline int qca8k_setup_led_ctrl(struct qca8k_priv *priv)
> > > +{
> > > +	return 0;
> > > +}
> > > +#endif
> > > +
> > > +#endif /* __QCA8K_LEDS_H */
> > > -- 
> > > 2.39.2
> > > 
> 
> -- 
> 	Ansuel


Thanks,
Michal
