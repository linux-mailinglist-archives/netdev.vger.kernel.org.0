Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F3B5788EC
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiGRRyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbiGRRyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:54:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A1E28724;
        Mon, 18 Jul 2022 10:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658166883; x=1689702883;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=k+gVYwgYbbsNq5gWh4xswOd2qa3iDuEgpbQfOHvr3os=;
  b=Atrp8pD0a9OuEmulApb6BAaO92A3iWQ924u2DyDMUhgKMGKTC+LvzSHG
   6iH2CkP+4aooQJQeZSmJVIbEPAKpmWddaBGA8aUBdT1Na5L/wIRY4z5Es
   FwIBQeiS5BFJHI4Anub9xFjdwGKGRULcdhhGnRTeX7y/wkmbgV9+6criY
   HCYF6xCjHKqOkEk3Jd39OIsZ8ddbKZojbZkxsaa7wIzV8nS6sb4edYO1I
   LpkiDwrie5fyPUFxuEGjFuTu1Xq4je8p6grR2PzBgvsiQvaqvVaUPCaE4
   NPxIppN1xSDMrSoc0VuXaVfxkZgm1TecLbBMQJ0dAOgKyZo4RDWLL4yaO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287025203"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="287025203"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 10:54:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="655387994"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jul 2022 10:54:37 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Jul 2022 10:54:37 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Jul 2022 10:54:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 18 Jul 2022 10:54:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Jul 2022 10:54:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZKd2OzDJBJpkORdud7kLcjfdN3nvwUXTJX4AysyCEyWaxfOrabNmhBsuPxOHmZuC4VZyJb+vt8hewm6RVrlnusVjdsDDNKVY8VicbSpxV0Oblnkn1BR4mj1VftnS/PcArAAsevPFK90MDtbkxTI9AIBhCj/YpYjlASx8ffcLnqFkV0FQTWPrDtw9AJUQLpYndL+xBIxMLtihKBosebKLPtExNo+AjB+oK9yJO9Bg6Q6o+Jrim/OC1ScodrFayIw5JMX1Knz2NwSUAjj5Vv//2s/3MjFbalVz27cKhtzBHVS0JE0kwdONdhkn48+xlYWdQ3a9oi4GWIRUhmx2bbt/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3Fz1k9nNbEix2mak3p2ppbBBNF1RdcazVHTqXQqAH4=;
 b=Z+P8n0pOHUkTfQz1c7zglgIM7V+5I1NOrtFfUZOYosrpnZsPyNMTbWVc/Ww86DlGSaV1vajea0phoPlltZlcrmiPza2ZLcHtk208BXYJMIqcdb1pBxBcHwrXVgTcdgTw91Zq4VfuqH0xR/TYHPDmCQSmCyI/VUgFF4+PPbukZPE1lwpCOssjzwgf3kFUtEfaMTBFJyliZmkLo3vOIJLSZFO2+rneiXA56PaW9wkBrxdyEETwLll9z2gPcgEuB2Sjv7ySED3begdRkhET1/AHmc2tA+qcO1Kk5hzZq4Ahw3JZVenC2eQb8rndULgv9L8C2YYrG/jKpaEnVV+AbjAGbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by MN2PR11MB4141.namprd11.prod.outlook.com (2603:10b6:208:13b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Mon, 18 Jul
 2022 17:54:32 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::8053:3c59:9f5d:b615]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::8053:3c59:9f5d:b615%9]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 17:54:32 +0000
Date:   Mon, 18 Jul 2022 13:54:24 -0400
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Dave Airlie <airlied@gmail.com>
CC:     <torvalds@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
        <linux-doc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel@ffwll.ch>, <mcgrof@kernel.org>,
        <alsa-devel@alsa-project.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <dri-devel@lists.sf.net>,
        Dave Airlie <airlied@redhat.com>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH] docs: driver-api: firmware: add driver firmware
 guidelines.
Message-ID: <YtWeUOJewho7p/vM@intel.com>
References: <20220718072144.2699487-1-airlied@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220718072144.2699487-1-airlied@gmail.com>
X-ClientProxiedBy: SJ0PR13CA0173.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::28) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 695a5838-6fca-42ec-ef08-08da68e69074
X-MS-TrafficTypeDiagnostic: MN2PR11MB4141:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yA4+vTiKckaMfR2aDZi43BUAH+hpXYs/5WLbcD8Ih0Rk8gfDHZlRPIa7FpboSw4j0BmkNT0xjxZhjwPLFDlVCjVL2RXI+jlQaCyVDuNQt+7oPvNuBGJ2Kw8JW14a1FlOVnvIFUdNaAn8Ifck1wFv+CB4mXrLLKaeZ0m3DyNMd+2JaUsw+Veao8C6O2plxUFKSoz8uIBdWsQgEXEpqgb+mazV68eOEooDeW7mwSBC7z2pTugHZkfnS8yq+nGciLFuD41WI5BOR1fx3gcRbbx/eynHLuskQ8/g/Q/BRYjpYZglmYQqa5oCPZJ6v0KcPcT4Q7xY+9rDmnsnRsYj/A4xie+IPhAALo/RXG/eeZDCbiq1mp39B8Si9brJvJCqUwv9RzcHZ/os484Xd8a61LoVwneSKAmDNuTsgkt3vgf3vzmllBTLCWVJJgyvUy+ktQloFHWdV1Te2wht3zsUtWdTdvt6Jq24j8r99nbpmTrkbnK8CnKojO6mggL/p54OxKjcvAIUIkZ5A1s1fb3Dn3NrN+YSapmVOhqG+Hrru70lz4BKsUeM6j5PorT3sFTePNfwYGDhDZ5Pr20t6ve5PUuWZc2SK4UPKdj96bUF3r40EncYyTIx9kJwILtV6jcgdox2aErDhrwyPSMxR+/DaOY5xYmo+TJVFjaH6ag3ImLKIPzCZSNlp/rCGds7bYmizXsj2RtCFMIALO4Lmn7wxfi7xAtAqJBV2AN8qO72fVQcT+No0o3VBQHQx5BHOxiqEAoQ5qrG7zdEneHpBZHnfyBPYzRCylK96fnjedmMtDGJbUQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(366004)(346002)(396003)(39860400002)(6916009)(4326008)(54906003)(5660300002)(8676002)(7416002)(316002)(66946007)(8936002)(66476007)(66556008)(44832011)(2906002)(83380400001)(82960400001)(38100700002)(86362001)(36756003)(6506007)(6666004)(186003)(26005)(41300700001)(6512007)(6486002)(966005)(2616005)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8TYlgShiLpBhypia71PZ+erJTGDsqrJehN4bHqzRHlJcN+pVOAFub21M4WJZ?=
 =?us-ascii?Q?ZKmayo9ztuZTlVE1D2nwAKzMG73wLTJ73aWKFJdfvJfn9E95YunYgeRHiRBl?=
 =?us-ascii?Q?vqOlQlCmCJBaocrlP9+iXAUCvYX4mgzCxrycynzXrReeMXq3WWppvt0nIaWy?=
 =?us-ascii?Q?+Tgh2acl27Pe8p5pv5viyi8dQgLOouPCgbtLMKkNyR5i4o5VXPivBGatLcVP?=
 =?us-ascii?Q?KpdgSnq0P0sLKRzx1q6BJn0nk5OE6SD1Ioe5TFWFJMTlo2/RdFeCN0WORe82?=
 =?us-ascii?Q?V6KA5Yy7YVA+ZOFVYeOyY4EL9w8jAE5YE8SqcQdteXAoTahqiVgE5jam8cuR?=
 =?us-ascii?Q?SAn/fK2eKTIFuCUUH8lupWLFC2jdwEs1ytF8oLOh86jSP42bGTHAS7rV0zwV?=
 =?us-ascii?Q?s5ctcJw8q4Q64mVEFnD3uLCxWhvHWFoMPSrH1mmf7AnWNctJm4yvpZrcBLxj?=
 =?us-ascii?Q?vJWVAfQNzwXKKIc+elkj/dMIzqH6F/iXZ9bnIn6vsbXB1E48Ocp/5e8LvWwr?=
 =?us-ascii?Q?X0/iEUM0N+uOOMySAmjLQoJOlPFVCjlTTZ0ecQZu6//Js/L6pLHUl+JZtpkD?=
 =?us-ascii?Q?TIiMjRyswogJRa59eNp61dCTSpQrxTJhY9XZTWPgL8T9niYw61Jt4XEdxiZm?=
 =?us-ascii?Q?G6BdHca6DmC/r84claYlDdHF+WtTBemTnFBCGFlEn/z7tvh0rWoohT2WSwbI?=
 =?us-ascii?Q?ysyzWYXeHZ946a+C0j6+EpXRB/ygcaGjslbresFPBHFh92+tR43ycFslDaVx?=
 =?us-ascii?Q?1ZA1vYeuUyHcJvAfaRTKKRnISRPe39BAFDiCQ/mlcsYWwa2uzU9dtgsohvTk?=
 =?us-ascii?Q?vn54OM8tK1QIaHNT6fB7i8eX3jbTEA0oClsxw7MjWx5ymae1vKluqnK+9xQn?=
 =?us-ascii?Q?rwqIZ6RlO1AYMvsUqBtQiS7TEpmt1h9FkWBkoJ5B8OmpkZ3/AaZNVdYOlX+S?=
 =?us-ascii?Q?ipo6TM4kPJHQqyR4WvV1agl+JyKouvGHozOhz9RyJW+2Ul7GSIEODNLeoWWF?=
 =?us-ascii?Q?584ttto2+64H7udBIoKs++Ek4l/isfNNd8kIAbfZhlqeO/2y71UeJ/3piYbH?=
 =?us-ascii?Q?ciorDamPKwgo87Hf43Al8ISvbSrdo6/dI8rgwwWBlUWCfRvNnLP/RKPE1FsJ?=
 =?us-ascii?Q?UEA7PuUvRdPbVhOElU2w1Y5Zj7OpZjvRpWetC0BnbyaqFtz6uUvHXWJ2RqZE?=
 =?us-ascii?Q?wm27jOg2L3K3XAxRqXqI4+GrMsnh2dNF6JExTXrbsBIJUu5sXbFAehbJDIxi?=
 =?us-ascii?Q?GJH+fcsotorbBlt2P5pl+YFSCrMy6TBFdkGY8P4je2L3tD7bMdLrsp2pCj8+?=
 =?us-ascii?Q?JTb4w82awBjO+Ns7wskotAq/6lblKDdsff3CpmXGmX/cPvHolRKHK26tK23j?=
 =?us-ascii?Q?RLfPrpP+3rTqP6HwjaqzmBr+AfItMSYfkQcqjuXXYLP088+nJlvHC5CdiNYL?=
 =?us-ascii?Q?vu9E4wi5sBPfFiXMka9SjQybWkTNn+VQN/pAII7nqKTV4FKetKW3XfZevd/Q?=
 =?us-ascii?Q?aFMELLdmHsW0AA7yZOqez97CI05dXoeIZ99Y61GkHnxRUX9QrY9MdHsFP1t8?=
 =?us-ascii?Q?Rx9Fs7MpKca81yjTA7MB2gxFzAlHf+2CHF+SU5Vzz8HVsSe5t/t6luPTyRn1?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 695a5838-6fca-42ec-ef08-08da68e69074
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 17:54:32.2017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zy8ugL0f/VW25DjJP86UNV3TDF6Y0c0Iw/EWN99xuz2bgb9LdxRNkAw9jByWyRlGU94W8S8A0MftVnGxr54chQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4141
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 05:21:44PM +1000, Dave Airlie wrote:
> From: Dave Airlie <airlied@redhat.com>
> 
> A recent snafu where Intel ignored upstream feedback on a firmware
> change, led to a late rc6 fix being required. In order to avoid this
> in the future we should document some expectations around
> linux-firmware.
> 
> I was originally going to write this for drm, but it seems quite generic
> advice.
> 
> I'm cc'ing this quite widely to reach subsystems which use fw a lot.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  Documentation/driver-api/firmware/core.rst    |  1 +
>  .../firmware/firmware-usage-guidelines.rst    | 34 +++++++++++++++++++
>  2 files changed, 35 insertions(+)
>  create mode 100644 Documentation/driver-api/firmware/firmware-usage-guidelines.rst
> 
> diff --git a/Documentation/driver-api/firmware/core.rst b/Documentation/driver-api/firmware/core.rst
> index 1d1688cbc078..803cd574bbd7 100644
> --- a/Documentation/driver-api/firmware/core.rst
> +++ b/Documentation/driver-api/firmware/core.rst
> @@ -13,4 +13,5 @@ documents these features.
>     direct-fs-lookup
>     fallback-mechanisms
>     lookup-order
> +   firmware-usage-guidelines
>  
> diff --git a/Documentation/driver-api/firmware/firmware-usage-guidelines.rst b/Documentation/driver-api/firmware/firmware-usage-guidelines.rst
> new file mode 100644
> index 000000000000..34d2412e78c6
> --- /dev/null
> +++ b/Documentation/driver-api/firmware/firmware-usage-guidelines.rst
> @@ -0,0 +1,34 @@
> +===================
> +Firmware Guidelines
> +===================
> +
> +Drivers that use firmware from linux-firmware should attempt to follow
> +the rules in this guide.
> +
> +* Firmware should be versioned with at least a major/minor version. It
> +  is suggested that the firmware files in linux-firmware be named with
> +  some device specific name, and just the major version. The
> +  major/minor/patch versions should be stored in a header in the
> +  firmware file for the driver to detect any non-ABI fixes/issues. The
> +  firmware files in linux-firmware should be overwritten with the newest
> +  compatible major version. Newer major version firmware should remain
> +  compatible with all kernels that load that major number.

would symbolic links be acceptable in the linux-firmware.git where
the <fmw>_<major>.bin is a sym link to <fwm>_<major>.<minor>.bin

or having the <fwm>_<major>.bin really to be the overwritten every minor
update?

> +
> +* Users should *not* have to install newer firmware to use existing
> +  hardware when they install a newer kernel.  If the hardware isn't
> +  enabled by default or under development, this can be ignored, until
> +  the first kernel release that enables that hardware.  This means no
> +  major version bumps without the kernel retaining backwards
> +  compatibility for the older major versions.  Minor version bumps
> +  should not introduce new features that newer kernels depend on
> +  non-optionally.
> +
> +* If a security fix needs lockstep firmware and kernel fixes in order to
> +  be successful, then all supported major versions in the linux-firmware
> +  repo should be updated with the security fix, and the kernel patches
> +  should detect if the firmware is new enough to declare if the security
> +  issue is fixed.  All communications around security fixes should point
> +  at both the firmware and kernel fixes. If a security fix requires
> +  deprecating old major versions, then this should only be done as a
> +  last option, and be stated clearly in all communications.

Everything makes sense to me. Thanks for writing this down.

Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

> +
> -- 
> 2.36.1
> 
> 
> 
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
