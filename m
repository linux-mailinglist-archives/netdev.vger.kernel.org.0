Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBDC6C1C12
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjCTQkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjCTQjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:39:43 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF5D2736;
        Mon, 20 Mar 2023 09:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679330085; x=1710866085;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+m+/laE82kuitrpk7ifFyXhG61Z9hnudH+XuBs/23sc=;
  b=gyxBkUAJ1yTd2YVjer/z+3ycZj0bVkdOO79ertJtkEcjLkxGnx6ZARKS
   djkhWTNXP0x3RuvzcSIUMVZpNY5FyFkCEUUNVsysVFjpdxx86dGcbmcLJ
   OL65ohzBtCaCwXoz7oaAYepn1d1DKX/zxH8VVwMIYPtKHpdehevR0JUds
   S2XaacB/aE67pJVdO5UqJMVYIQbfcckdQ80dizc+eL5l6rFFRwpMsdsto
   wf0nDeo5LcGWZF+I4xAuQ6yNO4kJ89xF3YOgZGclStPXY2Fqlvwk1Mn5P
   ss+Tobp1zHtFFmZnmEg6tLepKZhc/+/qIfudVlOpa+tlCYeV7e4AatUPU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="337429557"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="337429557"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 09:34:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="855323975"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="855323975"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 20 Mar 2023 09:34:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 09:34:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 09:34:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 09:34:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 09:34:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEiJ3qhy1how5+gwr6HKXkpPaLkHadLJbF8kT2pmWz7nz1QrlfTfsrs0SQiaEqOpxuT1TkU+xL75rXorxfEm4GYs2ibVSo/d6aov05UxMqsIBoKzuu5FQ6JyarESbehqAEYnuhMGb7Ljcp8pJZG4Cj8Ir3yRkq0vuN2TN0qe4rOEb/TBY30SZl1GbjV5y8l6hjskMgGtJrtqBbZKUs84sd/gG08/2YO0bouuRdBlzvdm8M1ybtSft3ukIFo+7d/+eqr6Xo+x4Bloz7avzKjHDEbT8lWVyQxIvf5YXY5TgKm4TlmIRHWAr1AtF/2/+P22TnAP3xpSAqtXjA1RvwhUGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIx2bsn8UYYktQKFzIMS/nSw7DngfJ8Pybkinb4oa6E=;
 b=Hbg8Ky+BU4sA/WiSSNyHoyQXdalVrMEl/wzKGLuaqdU9DiVmim+dPESWz6s0pcO/VRESn6RvQ2TgfWKxIqdGbP6RqUZ4XutPUy5CmTU8UqMfx1Mb4qcgPSSyjabyA+nYJV7i4omBrG06zBtEAvxkp3OG+PxUC0Qr8j7zrnHWETBzvWLzyXZ+r2yddvriatV6UlOfEyD4YMuxtvcpLBPdMp2919xYVnF6V9hN8tSEEU94M0fU50u7gDY3pn/WVTDFumd0LQG9rxB65OeLO8l7KuQ7GtX7u38PtPEbqFg37IwmOIVEr/ZF5KPYt+goEA5eZcfKnFzfqh7nS8oOo9BDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 DM6PR11MB4625.namprd11.prod.outlook.com (2603:10b6:5:2a8::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Mon, 20 Mar 2023 16:34:40 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:34:40 +0000
Date:   Mon, 20 Mar 2023 17:34:31 +0100
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
Subject: Re: [net-next PATCH v5 05/15] net: phy: Add a binding for PHY LEDs
Message-ID: <ZBiLF3qfnxiZlTkF@localhost.localdomain>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-6-ansuelsmth@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-6-ansuelsmth@gmail.com>
X-ClientProxiedBy: DB8PR04CA0028.eurprd04.prod.outlook.com
 (2603:10a6:10:110::38) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|DM6PR11MB4625:EE_
X-MS-Office365-Filtering-Correlation-Id: 2806b78c-4246-435b-28e4-08db29610080
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SIrMGRhq+Q6r/DK/RtIriBafl3NSL1HZE2ejNcAguoShxpejwnJEvh50CynNNyh0/3T55FNUXRPPw7RbtX2ZV12oLiwA1ueuBEwcIpWwK/LV5CNYK2p6SrS1fWvVqU/RXvwIL7DuHR8bJqs0w+/84LRQKT5waGTc5jQe44gDse42dUfQwfjLGGeVZIg7eot6TTJaqyySkDNDEB2GCPFPsTJrpNCiitqHvigl1OZIQ/l0lS81w3+Nnhh3dstsyex1EnuBaVFU35xbcs+D3ufq4Za5JEUhHiM07ekA05FirSoJyJ8oR5lxHZ6P9K6ONi88DJcalo1tOUDPyDdXrKZdxyYz58ROJTktpF0ANs/vv++kiGGwwypwOPaOktDK6tYrhqjjOI+Btw/8e7Aoo0wCYJOXmSyQiXphlUXimikjdyfKNXXWUkfLVsxQ0I9olJ07zblOr3kJPDUbzuTd6lF+fbzsLfZk6guShAsHVzc+FQI0083e35KSy9LWuURWsOnWOZvNwaBKmWQx5fV4O5xuBdSGMX7he8BoN7HRLEZtgSJ01esnATcAq3rDzjluhKejj8vchqRNMmY3C6Rkt66dG7V+5Sqxg8KXkyDQNroSqKmWQSyZZ4uxHo3YCTdvO+mWM3oClR7QEsr9MLmhPIRWnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199018)(8936002)(5660300002)(44832011)(7416002)(4744005)(41300700001)(86362001)(38100700002)(82960400001)(2906002)(4326008)(6486002)(478600001)(6666004)(186003)(26005)(6506007)(6512007)(9686003)(54906003)(66476007)(316002)(8676002)(66946007)(66556008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EDbI2yDlQ+c9MU5SKmnqrTdQA5x5LFxymtVN0rWolr38Hd/UZTLFM9W2QDJP?=
 =?us-ascii?Q?rS04hyMzPdi3r4Dm8pWma/ns7Fv86wUU17nrdb34MKHcyctzXbt5lAov4Gxx?=
 =?us-ascii?Q?eidLcvF4TOR9kppvKi+gQP9OEQinS+JEQDgvybH4O3gBmXeAw+6hu1jP7G5Q?=
 =?us-ascii?Q?IncCX/CtodVyLqZpexJPyTVJdvvIULrEqTh2IQoCdmP1mhc+bP/cLCJUz19X?=
 =?us-ascii?Q?2/toJ40Pu8QVSwR7xR0rXjw7ewk/Ie88JbU3+hflA9gt4R2C5yLMI6FUAiN0?=
 =?us-ascii?Q?6qM42iHkQ3EoN7+S0SzGLG9N7V6Z5IRXdxEyzDxUfEvOVf9x4MCTCq3rbP7K?=
 =?us-ascii?Q?Dg6Vk/zmGYa5dF8gCid3LsiVSpkIPAW43ZntJrvQwmdKRkRsRrGMUmQr0axy?=
 =?us-ascii?Q?8rkpU8UL123DMcv+g/9Uz6LX8K8+Kc9Va3OrFtKt62YnPYy1DNQBSXBBE8Fm?=
 =?us-ascii?Q?15UvLRSazNJ2JAK2s7C7eTkmBMuzfQVP52s9hYil+jcspRlIL+45zMgGIuFI?=
 =?us-ascii?Q?btlY+Uaq76ZwaljxIR0jO89riyTr139MGZ8KpNQl7DBqHK3Izp2xxmOnmff7?=
 =?us-ascii?Q?b30ITw90mN0De3tJ5jgUb8AQ2+weoede/MN+ZBoi87YvQcaQH11ABh+E/nG/?=
 =?us-ascii?Q?WygUDj52WDmIMdK3cXXbgWlnmx3vK2bWcKwGzld9lmUMYfiS07A7EovqrLzL?=
 =?us-ascii?Q?yEMjUPV6R2ycQtNE/GEvKkwJ56uxUx0zyd9GzQEoKF307pZdJ9nacG2NjUJk?=
 =?us-ascii?Q?9vYKiMIdLfUjCmRHz1XOX7pra3CRcjyDHMqohSda+tL60IEmF61wXlTJvGun?=
 =?us-ascii?Q?u+45QPkqlOXRaqrzp8DjJGNmzZ3briODgugQe6wZEwYrWno5QqE+LgnEjlns?=
 =?us-ascii?Q?L5NNnrapCcFaDN3XAJHXrmTKlQkHYa/vI9Xwj7i93631NcGpoK7i5QguTgm7?=
 =?us-ascii?Q?bVhZ9mMnNBf3GxBexJ5WK8hQ5ei3ryj8QRpnYHx7lTXC+wkahUDtZ+XhE2Mq?=
 =?us-ascii?Q?v8u8ucfnhx6oLpZ8Ygg14b93KDkzQFUwSp1sz/mbnFaQz7qIpH3xagrlH6be?=
 =?us-ascii?Q?VNPJfC5q9o7hsjP8uspPk7k+/23nrjlCyAo+2ZdRMcqgzkqcZNVe4GuMjsAP?=
 =?us-ascii?Q?vzv2/bCdcoKHeOhlekRR0ftV8sKIylSgtYKF+ZRWGx4I5YOfW+3wjOONRpFV?=
 =?us-ascii?Q?Fez/8LoZ7hZBlpmUakHNHWRbdp9PXv/iv0/Wi4k+5PcH/Z3uxPsc6FoYZGnn?=
 =?us-ascii?Q?ypYJ0ybRfecilOvG2Bh/+dNxfyqdcQ2jqA46hO5zaAiZbKSSkLll4oOc8LwG?=
 =?us-ascii?Q?5FQ9PPA6nV0aNQ78MFgUwHAboiRdrGU/tFnWcHqjpLTQyjIXy2MpjH6RuUUv?=
 =?us-ascii?Q?jxg2Ao+HVvsT6z7XKGY7OJOofYgSDFGgwgJZBMTNERyab94UuIy+unZ2tgH8?=
 =?us-ascii?Q?JCdc3i5HIj2kwH4JRn26mYUA6FondetcKjw6Y1WhgyO6rm1l/eFpzEwapR57?=
 =?us-ascii?Q?DIvA9hUqzuowa5CTCZVA7ME83ppQ9ZQoH8lt1Fzdfewzs0zId64sJR8x1L/v?=
 =?us-ascii?Q?saNqFKZvlGlRPtz0+n2IjckKl70lHzvmVYuvCF//pCDt4/KcYxa+Nttz9739?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2806b78c-4246-435b-28e4-08db29610080
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:34:40.2835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuhLBky4qLtHsJ7YkwYlwspoPKH5SCd99AkSoBlEq+b4119zdPibbg7SvWnRG7fH5oG4mWvDZL1/FQiitTJJ2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4625
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 08:18:04PM +0100, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Define common binding parsing for all PHY drivers with LEDs using
> phylib. Parse the DT as part of the phy_probe and add LEDs to the
> linux LED class infrastructure. For the moment, provide a dummy
> brightness function, which will later be replaced with a call into the
> PHY driver.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
