Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD9B6552EC
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 17:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiLWQpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 11:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiLWQpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 11:45:13 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F62F15FEC;
        Fri, 23 Dec 2022 08:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671813910; x=1703349910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XNOjON5POKBX09bx91shxvTwrFkAZCXXdzhCkm8qhGo=;
  b=bJX6pk7EPzt1hUh1BIflccUqn0u2sCTwC6iRGEvWWDazbcFGcrLxnWcM
   Rdi2m7QWNTspqmwv5+9c4AhS2bhAG1HWxBkJ0dA3QnL4g+PKXpsGthQEb
   4z/d6e4H3r8WZZBlgwmyM3Cdi+apn/xRujr1+VUwR9bQQIp190DNykPs6
   bvlZTHbPIfsxY1mCYZF1R/EzW/ChK15rjyrlNydY3t3gAq9RwKUJQM+/r
   pKV/N8FiXMaJ2OR/i66JuI29j/z6sFXSV+b+FQqE5nOt5qThCreHqxK+p
   /OpkwsfZ3Jz8zfK2TfkwpFNLPferczRph5GD9Uo+wVPFWMg6nXkwhL+4a
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10570"; a="300691924"
X-IronPort-AV: E=Sophos;i="5.96,269,1665471600"; 
   d="scan'208";a="300691924"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2022 08:45:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10570"; a="980972288"
X-IronPort-AV: E=Sophos;i="5.96,269,1665471600"; 
   d="scan'208";a="980972288"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 23 Dec 2022 08:45:08 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 23 Dec 2022 08:45:08 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 23 Dec 2022 08:45:08 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 23 Dec 2022 08:45:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQtmapzEtbIbUohxb9ax0ut58aGrgNanVVWF0mvuoHkv57O8qwewAIddP0d6SZd6RNuzVwyG1OfRJJVSj14X2xK2hTWJFwq7ajIN7Gy+ApRKc55YJbgOo1RRxvEQYlKoxlG+3CsQqNKTybv00/43qyAjpaQAgpflLk2nxinBYChPOj5puS/1yutOBzlpnjN6Vt6/J3XW9GWctCtubediXIMjaOiLWmIl9CpRC80qsUqyF7EQ4+pinFSjf711uHB+yl4q0w1g0MN+r604dex2sxrt50D+Mf4u7DOGkI172SehbDIbUnbZeRnaX6L/M/no1bhzThXpUpSIZnLx4o7yeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2yMnEvP/pZjfrQqwGX5jWQHLa0nheaGrJkq8Ojmtsbs=;
 b=YxEhwHWtBYz9jpaDKRrj8w9rXPTzYI4opOba/cAeSKJ+v+ru9H6Qlpn/65sYXXXJpbiDehkLLs4dEHs58oKq3fUzLsLzcMpBHnf7LLCghkF29MNc77naWKSj1whTi47YM0AjyvUtyOHklLlHdPfg6mxzHLytMf232GeA2lbMU1qYwGxGRHUM/QPYz7GL2yzgraP8Ro1DpxRb6qc9eM4nUVIqHgsjIRORyGeTmd+9g3xd1xATvrr0orbug3IoW5L5nPn8KpcDrAVDl8abEKeyiZ4KwWQN2w+J9Za0e82QomQprNSVDfARzVgBocBQ+H21DGRg+4IJ55NTnaQVUJszeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.14; Fri, 23 Dec 2022 16:45:04 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%9]) with mapi id 15.20.5924.016; Fri, 23 Dec 2022
 16:45:04 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        Vadim Fedorenko <vfedorenko@novek.ru>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Thread-Index: AQHZBDrzHhOO6jCKv0uW33ic8hB1f65Xlk2AgCQ8fdA=
Date:   Fri, 23 Dec 2022 16:45:03 +0000
Message-ID: <DM6PR11MB4657A1AB8BCBBD63C38F09B29BE99@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-3-vfedorenko@novek.ru> <Y4d06WPsKwqeYesC@nanopsycho>
In-Reply-To: <Y4d06WPsKwqeYesC@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DM8PR11MB5591:EE_
x-ms-office365-filtering-correlation-id: d0ad80bd-860f-4d21-395b-08dae5050a73
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xWeaAKEiJe5Tm1p6GL9KzoTjkTjg7BR2rilYtRP8cM7whSiVt4jRCuSwUSHhGW23PvQjcbAvL2IoyYo2XPKaY3G38IWNgTYi42eFc/SDgj//COyBm7lZCnY3csoVf2ZRsnYzkasz+6Pru3SjWUivNFfkTyXWNuGh/JfudQgZZUWnYIS/mD9cdpmrVpQgtrZStDhVi0CB37Oebz6X7gVbG1fSIPNkEr7MsKaRpvKWn1VPlStWLDjuZYKBMkWyekOTKEsf8QtIVJH95PV78dUE38WqmoV8LsaxutQ2ClkS/akeN19ZKGLadriLhJw+atqzyuaVHJ2wLl2RivJ6lrlZjNtHj09YnAt1lPC1OZW8yyk0D9DAcY0nClQWwexpODOEC7GSqeV4/OZKcN57NAdelcmVF/VVM7N1ARlRzQSR3tfm+2ddzKnfVt4f39lNSwGCLpjfTmN1N000iaWJGk5XMEjpuwe7fKvKoCTvEoQhHOZ53XfTfPNw1Vao6kSjePfGww26yvQtYZe1TVVB56jhXWZ+gH/vgnueW9jwxktAtPRYk0ObM86dZZpSPUYeqbYoSywptHVdaB8Nvr6x3/v13H7Kp3Etw+VlS4yuvM8G2Hby309RmJUl6Xs0Zg/W74e8yIHwmKZqRPQcT8+1XiByTT8izDZze7kI07lAEamxsCr+hdVDNX9Z0fWGBjeRDPI9jYYyQgKTPtj2SWhzGj/fYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199015)(7696005)(30864003)(71200400001)(107886003)(5660300002)(76116006)(316002)(186003)(26005)(9686003)(38100700002)(122000001)(478600001)(54906003)(2906002)(82960400001)(33656002)(110136005)(6506007)(38070700005)(41300700001)(86362001)(55016003)(83380400001)(4326008)(8676002)(8936002)(66946007)(64756008)(66446008)(66476007)(66556008)(52536014)(579004)(559001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CfZBjt4oeeBbvrG+dHeSB8bYF3izisPiV+qqxIbQRpFa74OuUxUfgwXhVRaM?=
 =?us-ascii?Q?VELVLJF7bOydbUoCv3HddTssCF+wLgBiszldIE/jzowch9ubH2p+D/DS8Odk?=
 =?us-ascii?Q?vVtVWLZp8E2GWaQky7I5mOwbTInHYXQSlnWSjFAJTh0S3K6jdGYHdoOE3KCf?=
 =?us-ascii?Q?zpAoMqlE+UE6Ma9Ob/2q0YkPOGL7dcAW9i22WDe1n/fS0rDPN3C5gg0StlGU?=
 =?us-ascii?Q?rmgriBiwSbUehNYP4PKHOTz67OtYlTGKZbKPLJ0MiicsOrN4rSshpOhKMBlq?=
 =?us-ascii?Q?Bj7oyjiisvcW0wltI8HMdPAJJUXPAmGZqZz+4Ub0vypymPudNgsJdJFbLavw?=
 =?us-ascii?Q?OHt9FyALsnAt3wE+mx0civksZU3adjsvAziuzvdZfrZnBSOU4LfXt3QolQkZ?=
 =?us-ascii?Q?8bXs1kuavRZId8FYaLykghU7Nbq2LqzYolbNc43tOgNiQkz6KfhXuAMFYCic?=
 =?us-ascii?Q?wxE3j377vv5kddldsIc6WsKMs2qsy87n8rpijLOG+u+5BBjw+Tkv3+4/CTtm?=
 =?us-ascii?Q?4nRRF/FYWePTW/YJVnJ9W9jL9gPPBc9K7xtkYkdmL8DwmDhBOznQcGlkxcXT?=
 =?us-ascii?Q?zSjkKMeIgZZU091SS5+XeQZvgRCMvIuSksNgnNa4sBTTcBmOB6yDo+1TYI/6?=
 =?us-ascii?Q?wCywaQSuzpLEGaMKPLxdnx02o46v5vRO/IA/PAXOe/S1nU2cCn8dcUu3iVb1?=
 =?us-ascii?Q?YTUdPEW8UsmTT7a0jKdQbPTnycsjPB0YYIFuo85LRQj1RfVNb0C0fRNa03Xn?=
 =?us-ascii?Q?Fr+cSTdbe9oRq35fu2pkTwxSoGj8ffzIL03uu/aJ8j3Fjt8ULMxcS+E5q9yI?=
 =?us-ascii?Q?pUcl/RBotT8kpQf3SLNmtZPFF0PWp34FOm7QNx7/xdO5V8BHE0Btzxs/zBFe?=
 =?us-ascii?Q?TdtfBzk+vURODvvsjLX+exoTmK518Hgl1ci+W2a+T6XcXst93kHPCqYVxZR9?=
 =?us-ascii?Q?SHq7VXmWbVuAbEtRzcVIrEmiIE5RFE2D/MsuUVrtnBFmlm609IuSuKtRGX0a?=
 =?us-ascii?Q?7OCnqkngPZx7DXH6EuelFl9LYF7mqIxf6hHBFFgy82amDYpxmHZ1Yvan3cjM?=
 =?us-ascii?Q?cbptwNSbuLrkENsmm6a6F79K2f70e8X6r17gqiS8opS2ZcxW1DC9/4N4E60A?=
 =?us-ascii?Q?3k/G1xiwJVoFRjsoQv3DW9J4DzJJwYHT4gq0N/aQLYfP0CTg35Mvuri4RIlq?=
 =?us-ascii?Q?PnmjJo/jjGH+guiJkiEF9qesujwK6/MfQGAAum2OrxPzqJlxSAUs1vxPJnte?=
 =?us-ascii?Q?CcHeN9G/dUkRzosFqq+OmtMKcBl2dwCisx3QvDEfbLvxUJeOF27e33KLd/at?=
 =?us-ascii?Q?GkJCynJAcr1kdbm/5hNGYHaWOuNvYCBOd7STYI356deXo/4Qx+oT++B22DYI?=
 =?us-ascii?Q?66hc/DlvAYQPsacz/Xhp0oFcMPoNA2l25RSCgEjQ45K0hctFvcuQvO80e9lV?=
 =?us-ascii?Q?4sUJTVzuUuBgo+PqsnYNqib9/F9L1ZNc3VcxP8hK3tnaawPnXLFblElrxxZG?=
 =?us-ascii?Q?eAxb6YkPCn8/AoUUJO7JDCx8phjJR3Qx4OXQMb74GqFT19/v78IRU/u3DhGO?=
 =?us-ascii?Q?2TYRWLb3d5MFQz00YePaWFEVtjtA+SrWY673+koHaAPVdb5FBWdRKbNYDdFy?=
 =?us-ascii?Q?iA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ad80bd-860f-4d21-395b-08dae5050a73
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2022 16:45:03.8642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Aww5hlbpirQuhwDEQIRvHfHhFoddgExtOoyadMACkCi2vSPp7XPEVQRegie6nSYU+kGqdFfG2z+tTH9raNkwZQY8X9apz5bDZty2OJyPKW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5591
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Wednesday, November 30, 2022 4:21 PM
>
>Tue, Nov 29, 2022 at 10:37:22PM CET, vfedorenko@novek.ru wrote:
>>From: Vadim Fedorenko <vadfed@fb.com>
>>
>>DPLL framework is used to represent and configure DPLL devices
>>in systems. Each device that has DPLL and can configure sources
>>and outputs can use this framework. Netlink interface is used to
>>provide configuration data and to receive notification messages
>>about changes in the configuration or status of DPLL device.
>>Inputs and outputs of the DPLL device are represented as special
>>objects which could be dynamically added to and removed from DPLL
>>device.
>>
>>Co-developed-by: Milena Olech <milena.olech@intel.com>
>>Signed-off-by: Milena Olech <milena.olech@intel.com>
>>Co-developed-by: Michal Michalik <michal.michalik@intel.com>
>>Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>>Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>>---
>> MAINTAINERS                 |   8 +
>> drivers/Kconfig             |   2 +
>> drivers/Makefile            |   1 +
>> drivers/dpll/Kconfig        |   7 +
>> drivers/dpll/Makefile       |  11 +
>> drivers/dpll/dpll_core.c    | 760 ++++++++++++++++++++++++++++
>> drivers/dpll/dpll_core.h    | 176 +++++++
>> drivers/dpll/dpll_netlink.c | 963 ++++++++++++++++++++++++++++++++++++
>> drivers/dpll/dpll_netlink.h |  24 +
>> include/linux/dpll.h        | 261 ++++++++++
>> include/uapi/linux/dpll.h   | 263 ++++++++++
>> 11 files changed, 2476 insertions(+)
>> create mode 100644 drivers/dpll/Kconfig
>> create mode 100644 drivers/dpll/Makefile
>> create mode 100644 drivers/dpll/dpll_core.c
>> create mode 100644 drivers/dpll/dpll_core.h
>> create mode 100644 drivers/dpll/dpll_netlink.c
>> create mode 100644 drivers/dpll/dpll_netlink.h
>> create mode 100644 include/linux/dpll.h
>> create mode 100644 include/uapi/linux/dpll.h
>>
>>diff --git a/MAINTAINERS b/MAINTAINERS
>>index 61fe86968111..79b76cca9620 100644
>>--- a/MAINTAINERS
>>+++ b/MAINTAINERS
>>@@ -6343,6 +6343,14 @@ F:
>	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/swit
>ch-drive
>> F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
>> F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
>>
>>+DPLL CLOCK SUBSYSTEM
>>+M:	Vadim Fedorenko <vadfed@fb.com>
>>+L:	netdev@vger.kernel.org
>>+S:	Maintained
>>+F:	drivers/dpll/*
>>+F:	include/net/dpll.h
>>+F:	include/uapi/linux/dpll.h
>>+
>> DRBD DRIVER
>> M:	Philipp Reisner <philipp.reisner@linbit.com>
>> M:	Lars Ellenberg <lars.ellenberg@linbit.com>
>>diff --git a/drivers/Kconfig b/drivers/Kconfig
>>index 19ee995bd0ae..a3e00294a995 100644
>>--- a/drivers/Kconfig
>>+++ b/drivers/Kconfig
>>@@ -239,4 +239,6 @@ source "drivers/peci/Kconfig"
>>
>> source "drivers/hte/Kconfig"
>>
>>+source "drivers/dpll/Kconfig"
>>+
>> endmenu
>>diff --git a/drivers/Makefile b/drivers/Makefile
>>index bdf1c66141c9..7cbee58bc692 100644
>>--- a/drivers/Makefile
>>+++ b/drivers/Makefile
>>@@ -189,3 +189,4 @@ obj-$(CONFIG_COUNTER)		+=3D counter/
>> obj-$(CONFIG_MOST)		+=3D most/
>> obj-$(CONFIG_PECI)		+=3D peci/
>> obj-$(CONFIG_HTE)		+=3D hte/
>>+obj-$(CONFIG_DPLL)		+=3D dpll/
>>diff --git a/drivers/dpll/Kconfig b/drivers/dpll/Kconfig
>>new file mode 100644
>>index 000000000000..a4cae73f20d3
>>--- /dev/null
>>+++ b/drivers/dpll/Kconfig
>>@@ -0,0 +1,7 @@
>>+# SPDX-License-Identifier: GPL-2.0-only
>>+#
>>+# Generic DPLL drivers configuration
>>+#
>>+
>>+config DPLL
>>+  bool
>>diff --git a/drivers/dpll/Makefile b/drivers/dpll/Makefile
>>new file mode 100644
>>index 000000000000..3391deb08014
>>--- /dev/null
>>+++ b/drivers/dpll/Makefile
>>@@ -0,0 +1,11 @@
>>+# SPDX-License-Identifier: GPL-2.0
>>+#
>>+# Makefile for DPLL drivers.
>>+#
>>+
>>+obj-$(CONFIG_DPLL)          +=3D dpll_sys.o
>>+dpll_sys-y                  +=3D dpll_attr.o
>>+dpll_sys-y                  +=3D dpll_core.o
>>+dpll_sys-y                  +=3D dpll_netlink.o
>>+dpll_sys-y                  +=3D dpll_pin_attr.o
>>+
>>diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>>new file mode 100644
>>index 000000000000..013ac4150583
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_core.c
>>@@ -0,0 +1,760 @@
>>+// SPDX-License-Identifier: GPL-2.0
>>+/*
>>+ *  dpll_core.c - Generic DPLL Management class support.
>>+ *
>>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>+ */
>>+
>>+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>+
>>+#include <linux/device.h>
>>+#include <linux/err.h>
>>+#include <linux/slab.h>
>>+#include <linux/string.h>
>>+
>>+#include "dpll_core.h"
>>+
>>+/**
>>+ * struct dpll_pin - structure for a dpll pin
>>+ * @idx:		unique id number for each pin
>>+ * @parent_pin:		parent pin
>>+ * @type:		type of the pin
>>+ * @ops:		operations this &dpll_pin supports
>>+ * @priv:		pointer to private information of owner
>>+ * @ref_dplls:		array of registered dplls
>>+ * @description:	name to distinguish the pin
>>+ */
>>+struct dpll_pin {
>>+	u32 idx;
>>+	struct dpll_pin *parent_pin;
>>+	enum dpll_pin_type type;
>>+	struct dpll_pin_ops *ops;
>>+	void *priv;
>>+	struct xarray ref_dplls;
>>+	char description[PIN_DESC_LEN];
>>+};
>>+
>>+/**
>>+ * struct dpll_device - structure for a DPLL device
>>+ * @id:		unique id number for each device
>>+ * @dev:	struct device for this dpll device
>>+ * @parent:	parent device
>>+ * @ops:	operations this &dpll_device supports
>>+ * @lock:	mutex to serialize operations
>>+ * @type:	type of a dpll
>>+ * @priv:	pointer to private information of owner
>>+ * @pins:	list of pointers to pins registered with this dpll
>>+ * @cookie:	unique identifier (cookie) of a dpll
>>+ * @dev_driver_idx: provided by driver for
>>+ */
>>+struct dpll_device {
>
>Just "dpll" please. Device somehow indicates this is managing device on
>the bus. It is misleading.
>

Left as asked in follow up email.

>
>>+	u32 id;
>>+	struct device dev;
>>+	struct device *parent;
>>+	struct dpll_device_ops *ops;
>>+	struct mutex lock;
>>+	enum dpll_type type;
>>+	void *priv;
>>+	struct xarray pins;
>>+	u8 cookie[DPLL_COOKIE_LEN];
>>+	u8 dev_driver_idx;
>>+};
>>+
>>+static DEFINE_MUTEX(dpll_device_xa_lock);
>>+
>>+static DEFINE_XARRAY_FLAGS(dpll_device_xa, XA_FLAGS_ALLOC);
>>+#define DPLL_REGISTERED		XA_MARK_1
>>+#define PIN_REGISTERED		XA_MARK_1
>>+
>>+#define ASSERT_DPLL_REGISTERED(d)
>\
>>+	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>>+#define ASSERT_DPLL_NOT_REGISTERED(d)
>\
>>+	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>>+
>>+struct pin_ref_dpll {
>
>Namespace
>

Gonna fix in next version.

>
>>+	struct dpll_device *dpll;
>>+	struct dpll_pin_ops *ops;
>>+	void *priv;
>>+};
>>+
>>+struct dpll_device *dpll_device_get_by_id(int id)
>>+{
>>+	struct dpll_device *dpll =3D NULL;
>>+
>>+	if (xa_get_mark(&dpll_device_xa, id, DPLL_REGISTERED))
>>+		dpll =3D xa_load(&dpll_device_xa, id);
>>+
>>+	return dpll;
>>+}
>>+
>>+struct dpll_device *dpll_device_get_by_name(const char *name)
>>+{
>>+	struct dpll_device *dpll, *ret =3D NULL;
>>+	unsigned long index;
>>+
>>+	mutex_lock(&dpll_device_xa_lock);
>>+	xa_for_each_marked(&dpll_device_xa, index, dpll, DPLL_REGISTERED) {
>>+		if (!strcmp(dev_name(&dpll->dev), name)) {
>>+			ret =3D dpll;
>>+			break;
>>+		}
>>+	}
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+
>>+	return ret;
>>+}
>>+
>>+struct dpll_device *dpll_device_get_by_cookie(u8 cookie[DPLL_COOKIE_LEN]=
,
>>+					      enum dpll_type type, u8 idx)
>>+{
>>+	struct dpll_device *dpll, *ret =3D NULL;
>>+	unsigned long index;
>>+
>>+	mutex_lock(&dpll_device_xa_lock);
>>+	xa_for_each_marked(&dpll_device_xa, index, dpll, DPLL_REGISTERED) {
>>+		if (!memcmp(dpll->cookie, cookie, DPLL_COOKIE_LEN)) {
>>+			if (dpll->type =3D=3D type) {
>>+				if (dpll->dev_driver_idx =3D=3D idx) {
>>+					ret =3D dpll;
>>+					break;
>>+				}
>>+			}
>>+		}
>>+	}
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_get_by_cookie);
>>+
>>+static void dpll_device_release(struct device *dev)
>>+{
>>+	struct dpll_device *dpll;
>>+
>>+	dpll =3D to_dpll_device(dev);
>>+
>>+	dpll_device_unregister(dpll);
>>+	dpll_device_free(dpll);
>>+}
>>+
>>+static struct class dpll_class =3D {
>>+	.name =3D "dpll",
>>+	.dev_release =3D dpll_device_release,
>>+};
>>+
>>+static const char *dpll_type_name[__DPLL_TYPE_MAX] =3D {
>>+	[DPLL_TYPE_UNSPEC] =3D "",
>>+	[DPLL_TYPE_PPS] =3D "PPS",
>>+	[DPLL_TYPE_EEC] =3D "EEC",
>>+};
>>+
>>+static const char *dpll_type_str(enum dpll_type type)
>>+{
>>+	if (type >=3D DPLL_TYPE_UNSPEC && type <=3D DPLL_TYPE_MAX)
>>+		return dpll_type_name[type];
>>+	else
>>+		return "";
>>+}
>>+
>>+struct dpll_device
>>+*dpll_device_alloc(struct dpll_device_ops *ops, enum dpll_type type,
>>+		   const u8 cookie[DPLL_COOKIE_LEN], u8 idx,
>
>This cooking thing should be removed alongside with the getter. Driver
>should not need it.
>

Gonna fix in next version. Will replace with clock_id.

>
>>+		   void *priv, struct device *parent)
>>+{
>>+	struct dpll_device *dpll;
>>+	int ret;
>>+
>>+	dpll =3D kzalloc(sizeof(*dpll), GFP_KERNEL);
>>+	if (!dpll)
>>+		return ERR_PTR(-ENOMEM);
>>+
>>+	mutex_init(&dpll->lock);
>>+	dpll->ops =3D ops;
>>+	dpll->dev.class =3D &dpll_class;
>>+	dpll->parent =3D parent;
>>+	dpll->type =3D type;
>>+	dpll->dev_driver_idx =3D idx;
>>+	memcpy(dpll->cookie, cookie, sizeof(dpll->cookie));
>>+
>>+	mutex_lock(&dpll_device_xa_lock);
>>+	ret =3D xa_alloc(&dpll_device_xa, &dpll->id, dpll,
>
>You have idx and id? Why?
>

id is system id, idx is given by driver registering it, as for now one driv=
er
can allocate many dplls with the same type and clock_id.

>
>>+		       xa_limit_16b, GFP_KERNEL);
>>+	if (ret)
>>+		goto error;
>>+	dev_set_name(&dpll->dev, "dpll-%s-%s-%s%d",
>dev_driver_string(parent),
>>+		     dev_name(parent), type ? dpll_type_str(type) : "", idx);
>
>Odd. You encode parent device name into a name. What do we have device
>hierarchy for? Also, why to encode "type_str"? Does no make sense to me.
>

Gonna fix in next version.

>
>>+	dpll->priv =3D priv;
>>+	xa_init_flags(&dpll->pins, XA_FLAGS_ALLOC);
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+	dpll_notify_device_create(dpll);
>>+
>>+	return dpll;
>>+
>>+error:
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+	kfree(dpll);
>>+	return ERR_PTR(ret);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_alloc);
>>+
>>+void dpll_device_free(struct dpll_device *dpll)
>>+{
>>+	WARN_ON_ONCE(!dpll);
>>+	WARN_ON_ONCE(!xa_empty(&dpll->pins));
>>+	xa_destroy(&dpll->pins);
>>+	mutex_destroy(&dpll->lock);
>>+	kfree(dpll);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_free);
>>+
>>+void dpll_device_register(struct dpll_device *dpll)
>>+{
>>+	ASSERT_DPLL_NOT_REGISTERED(dpll);
>>+
>>+	mutex_lock(&dpll_device_xa_lock);
>>+	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_register);
>>+
>>+void dpll_device_unregister(struct dpll_device *dpll)
>>+{
>>+	ASSERT_DPLL_REGISTERED(dpll);
>>+
>>+	mutex_lock(&dpll_device_xa_lock);
>>+	xa_erase(&dpll_device_xa, dpll->id);
>>+	dpll_notify_device_delete(dpll);
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_unregister);
>>+
>>+u32 dpll_id(struct dpll_device *dpll)
>>+{
>>+	return dpll->id;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_id);
>>+
>>+u32 dpll_pin_idx(struct dpll_device *dpll, struct dpll_pin *pin)
>
>This is odd. You just need pin here, no need to pass dpll.
>

It is needed for "dpll_pin_ref dance".

>
>>+{
>>+	struct dpll_pin *pos;
>>+	unsigned long index;
>>+
>>+	xa_for_each_marked(&dpll->pins, index, pos, PIN_REGISTERED) {
>>+		if (pos =3D=3D pin)
>>+			return pin->idx;
>>+	}
>>+
>>+	return PIN_IDX_INVALID;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_idx);
>>+
>>+const char *dpll_dev_name(struct dpll_device *dpll)
>>+{
>>+	return dev_name(&dpll->dev);
>
>General comment to this getter helpers. Why do you need them? Why the
>driver cares about name, abou idx and other attributes. Why driver needs
>to iterate over pins?
>This should not be needed, please remove.
>

All is required to share a dplls and pins.
Separated driver instances shall be able to find dpll or pin of the other
instance.

>
>
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_dev_name);
>>+
>>+struct dpll_pin *dpll_pin_alloc(const char *description, size_t desc_len=
)
>
>
>Why do you need description? In your pps example, you pass "SMA". Isn't
>that rather a pin type? Const attribute of a pin?
>I can understand a need for "label", if you have 2 SMA connectors
>labeled "port 1" and "port 2", pass that.

What about U.FL? We probably could add signal types like:
- DPLL_PIN_SIGNAL_TYPE_EXT_SMA,
- DPLL_PIN_SIGNAL_TYPE_EXT_UFL.
Maybe more if there are some other viable connectors..
Then pass label/description as you suggested.

>
>Also, it's a string, you don't need len.
>Also, you can have this as vararg to make caller's live easier.
>

Sure, we are rather safe to remove desc_len, but I don't get how vararg wou=
ld
be beneficial here?

>
>
>>+{
>>+	struct dpll_pin *pin =3D kzalloc(sizeof(struct dpll_pin), GFP_KERNEL);
>>+
>>+	if (!pin)
>>+		return ERR_PTR(-ENOMEM);
>>+	if (desc_len > PIN_DESC_LEN)
>>+		return ERR_PTR(-EINVAL);
>>+
>>+	strncpy(pin->description, description, PIN_DESC_LEN);
>>+	if (desc_len =3D=3D PIN_DESC_LEN)
>>+		pin->description[PIN_DESC_LEN - 1] =3D '\0';
>>+	xa_init_flags(&pin->ref_dplls, XA_FLAGS_ALLOC);
>>+
>>+	return pin;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_alloc);
>>+
>>+static int dpll_alloc_pin_on_xa(struct xarray *pins, struct dpll_pin
>*pin)
>>+{
>>+	struct dpll_pin *pos;
>>+	unsigned long index;
>>+	int ret;
>>+
>>+	xa_for_each(pins, index, pos) {
>>+		if (pos =3D=3D pin ||
>>+		    !strncmp(pos->description, pin->description, PIN_DESC_LEN))
>>+			return -EEXIST;
>>+	}
>>+
>>+	ret =3D xa_alloc(pins, &pin->idx, pin, xa_limit_16b, GFP_KERNEL);
>>+	if (!ret)
>>+		xa_set_mark(pins, pin->idx, PIN_REGISTERED);
>>+
>>+	return ret;
>>+}
>>+
>>+static int pin_ref_dpll_add(struct dpll_pin *pin, struct dpll_device
>*dpll,
>>+			    struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	struct pin_ref_dpll *ref, *pos;
>>+	unsigned long index;
>>+	u32 idx;
>>+
>>+	ref =3D kzalloc(sizeof(struct pin_ref_dpll), GFP_KERNEL);
>>+	if (!ref)
>>+		return -ENOMEM;
>>+	ref->dpll =3D dpll;
>>+	ref->ops =3D ops;
>>+	ref->priv =3D priv;
>>+	if (!xa_empty(&pin->ref_dplls)) {
>>+		xa_for_each(&pin->ref_dplls, index, pos) {
>>+			if (pos->dpll =3D=3D ref->dpll)
>>+				return -EEXIST;
>>+		}
>>+	}
>>+
>>+	return xa_alloc(&pin->ref_dplls, &idx, ref, xa_limit_16b,
>GFP_KERNEL);
>>+}
>>+
>>+static void pin_ref_dpll_del(struct dpll_pin *pin, struct dpll_device
>*dpll)
>>+{
>>+	struct pin_ref_dpll *pos;
>>+	unsigned long index;
>>+
>>+	xa_for_each(&pin->ref_dplls, index, pos) {
>>+		if (pos->dpll =3D=3D dpll) {
>>+			WARN_ON_ONCE(pos !=3D xa_erase(&pin->ref_dplls, index));
>>+			break;
>>+		}
>>+	}
>>+}
>
>As I wrote in the reply to the cover, I believe the sharing of pins
>between instances is wrong, then you can avoid this ref dance.
>

I see this differently, as sharing pins and dplls is beneficial for complex
hardware designs, leaving for now.

>
>
>>+
>>+static int pin_deregister_from_xa(struct xarray *xa_pins, struct dpll_pi=
n
>*pin)
>>+{
>>+	struct dpll_pin *pos;
>>+	unsigned long index;
>>+
>>+	xa_for_each(xa_pins, index, pos) {
>>+		if (pos =3D=3D pin) {
>>+			WARN_ON_ONCE(pos !=3D xa_erase(xa_pins, index));
>>+			return 0;
>>+		}
>>+	}
>>+
>>+	return -ENXIO;
>>+}
>>+
>>+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		      struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	int ret;
>>+
>>+	if (!pin || !ops)
>>+		return -EINVAL;
>>+
>>+	mutex_lock(&dpll->lock);
>>+	ret =3D dpll_alloc_pin_on_xa(&dpll->pins, pin);
>>+	if (!ret) {
>>+		ret =3D pin_ref_dpll_add(pin, dpll, ops, priv);
>>+		if (ret)
>>+			pin_deregister_from_xa(&dpll->pins, pin);
>>+	}
>>+	mutex_unlock(&dpll->lock);
>>+	if (!ret)
>>+		dpll_notify_device_change(dpll, DPLL_CHANGE_PIN_ADD, pin);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_register);
>>+
>>+int
>>+dpll_shared_pin_register(struct dpll_device *dpll_pin_owner,
>>+			 struct dpll_device *dpll, u32 pin_idx,
>>+			 struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	struct dpll_pin *pin;
>>+	int ret;
>>+
>>+	mutex_lock(&dpll_pin_owner->lock);
>>+	pin =3D dpll_pin_get_by_idx(dpll_pin_owner, pin_idx);
>>+	if (!pin) {
>>+		ret =3D -EINVAL;
>>+		goto unlock;
>>+	}
>>+	ret =3D dpll_pin_register(dpll, pin, ops, priv);
>>+unlock:
>>+	mutex_unlock(&dpll_pin_owner->lock);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_shared_pin_register);
>>+
>>+int dpll_pin_deregister(struct dpll_device *dpll, struct dpll_pin *pin)
>>+{
>>+	int ret =3D 0;
>>+
>>+	if (xa_empty(&dpll->pins))
>>+		return -ENOENT;
>>+
>>+	mutex_lock(&dpll->lock);
>>+	ret =3D pin_deregister_from_xa(&dpll->pins, pin);
>>+	if (!ret)
>>+		pin_ref_dpll_del(pin, dpll);
>>+	mutex_unlock(&dpll->lock);
>>+	if (!ret)
>>+		dpll_notify_device_change(dpll, DPLL_CHANGE_PIN_DEL, pin);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_deregister);
>>+
>>+void dpll_pin_free(struct dpll_pin *pin)
>>+{
>>+	if (!xa_empty(&pin->ref_dplls))
>>+		return;
>>+
>>+	xa_destroy(&pin->ref_dplls);
>>+	kfree(pin);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_free);
>>+
>>+int dpll_muxed_pin_register(struct dpll_device *dpll,
>>+			    struct dpll_pin *parent_pin, struct dpll_pin *pin,
>>+			    struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	int ret;
>>+
>>+	if (!parent_pin || !pin)
>>+		return -EINVAL;
>>+
>>+	mutex_lock(&dpll->lock);
>>+	ret =3D dpll_alloc_pin_on_xa(&dpll->pins, pin);
>>+	if (!ret)
>>+		ret =3D pin_ref_dpll_add(pin, dpll, ops, priv);
>>+	if (!ret)
>>+		pin->parent_pin =3D parent_pin;
>>+	mutex_unlock(&dpll->lock);
>>+	if (!ret)
>>+		dpll_notify_device_change(dpll, DPLL_CHANGE_PIN_ADD, pin);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_muxed_pin_register);
>>+
>>+struct dpll_pin
>>+*dpll_pin_get_by_description(struct dpll_device *dpll, const char
>*description)
>
>Why on earth would driver need this helper? If it does, something is
>wrong. Please remove.
>

I.e. The driver wants to add it's recovered clock as a source for the MUX t=
ype
pin. It finds dpll, finds a MUX type pin, allocates new pin, registers it w=
ith
previously found MUX type pin.

Searching for DPLL will be done now with a clock_id (previously cookie), ty=
pe
of dpll and index (all provided by driver on dpll device allocation).

For searching of a pin, I think I am going to remove it, instead will modif=
y:
int dpll_muxed_pin_register(struct dpll_device *dpll,
                            struct dpll_pin *parent_pin, struct dpll_pin *p=
in,
                            struct dpll_pin_ops *ops, void *priv)
Letting the user register with MUX-type pin label, instead of its pointer.
This way searching of the pin won't be needed anymore.

>
>>+{
>>+	struct dpll_pin *pos, *pin =3D NULL;
>>+	unsigned long index;
>>+
>>+	mutex_lock(&dpll->lock);
>>+	xa_for_each(&dpll->pins, index, pos) {
>>+		if (!strncmp(pos->description, description, PIN_DESC_LEN)) {
>>+			pin =3D pos;
>>+			break;
>>+		}
>>+	}
>>+	mutex_unlock(&dpll->lock);
>>+
>>+	return pin;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_get_by_description);
>>+
>>+static struct dpll_pin
>>+*dpll_pin_get_by_idx_from_xa(struct xarray *xa_pins, int idx)
>>+{
>>+	struct dpll_pin *pos;
>>+	unsigned long index;
>>+
>>+	xa_for_each_marked(xa_pins, index, pos, PIN_REGISTERED) {
>>+		if (pos->idx =3D=3D idx)
>>+			return pos;
>>+	}
>>+
>>+	return NULL;
>>+}
>>+
>>+struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, int idx)
>>+{
>>+	return dpll_pin_get_by_idx_from_xa(&dpll->pins, idx);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_get_by_idx);
>
>Again, please remove these heplers. Driver should be happy only with
>opaque struct dpll and struct dpll_pin
>

This won't be exported anymore.

>
>>+
>>+struct dpll_pin *dpll_pin_first(struct dpll_device *dpll, unsigned long
>*index)
>>+{
>>+	*index =3D 0;
>>+
>>+	return xa_find(&dpll->pins, index, LONG_MAX, PIN_REGISTERED);
>>+}
>>+
>>+struct dpll_pin *dpll_pin_next(struct dpll_device *dpll, unsigned long
>*index)
>>+{
>>+	return xa_find_after(&dpll->pins, index, LONG_MAX, PIN_REGISTERED);
>>+}
>>+
>>+struct dpll_device *dpll_first(unsigned long *index)
>>+{
>>+	*index =3D 0;
>>+
>>+	return xa_find(&dpll_device_xa, index, LONG_MAX, DPLL_REGISTERED);
>>+}
>>+
>>+struct dpll_device *dpll_next(unsigned long *index)
>>+{
>>+	return xa_find_after(&dpll_device_xa, index, LONG_MAX,
>DPLL_REGISTERED);
>>+}
>>+
>>+static int
>>+dpll_notify_pin_change_attr(struct dpll_device *dpll, struct dpll_pin
>*pin,
>>+			    const struct dpll_pin_attr *attr)
>>+{
>>+	enum dpll_event_change change;
>>+	int ret =3D 0;
>>+
>>+	if (dpll_pin_attr_valid(DPLLA_PIN_TYPE, attr)) {
>>+		change =3D DPLL_CHANGE_PIN_TYPE;
>>+		ret =3D dpll_notify_device_change(dpll, change, pin);
>>+	}
>>+	if (!ret && dpll_pin_attr_valid(DPLLA_PIN_SIGNAL_TYPE, attr)) {
>>+		change =3D DPLL_CHANGE_PIN_SIGNAL_TYPE;
>>+		ret =3D dpll_notify_device_change(dpll, change, pin);
>>+	}
>>+	if (!ret && dpll_pin_attr_valid(DPLLA_PIN_CUSTOM_FREQ, attr)) {
>>+		change =3D DPLL_CHANGE_PIN_CUSTOM_FREQ;
>>+		ret =3D dpll_notify_device_change(dpll, change, pin);
>>+	}
>>+	if (!ret && dpll_pin_attr_valid(DPLLA_PIN_STATE, attr)) {
>>+		change =3D DPLL_CHANGE_PIN_STATE;
>>+		ret =3D dpll_notify_device_change(dpll, change, pin);
>>+	}
>>+	if (!ret && dpll_pin_attr_valid(DPLLA_PIN_PRIO, attr)) {
>>+		change =3D DPLL_CHANGE_PIN_PRIO;
>>+		ret =3D dpll_notify_device_change(dpll, change, pin);
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_notify_device_change_attr(struct dpll_device *dpll,
>>+					  const struct dpll_attr *attr)
>>+{
>>+	int ret =3D 0;
>>+
>>+	if (dpll_attr_valid(DPLLA_MODE, attr))
>>+		ret =3D dpll_notify_device_change(dpll, DPLL_CHANGE_MODE, NULL);
>>+	if (!ret && dpll_attr_valid(DPLLA_SOURCE_PIN_IDX, attr))
>>+		ret =3D dpll_notify_device_change(dpll, DPLL_CHANGE_SOURCE_PIN,
>>+						NULL);
>>+	return ret;
>>+}
>>+
>>+static struct pin_ref_dpll
>>+*dpll_pin_find_ref(struct dpll_device *dpll, struct dpll_pin *pin)
>>+{
>>+	struct pin_ref_dpll *ref;
>>+	unsigned long index;
>>+
>>+	xa_for_each(&pin->ref_dplls, index, ref) {
>>+		if (ref->dpll !=3D dpll)
>>+			continue;
>>+		else
>>+			return ref;
>>+	}
>>+
>>+	return NULL;
>>+}
>>+
>>+static int
>>+dpll_pin_set_attr_single_ref(struct dpll_device *dpll, struct dpll_pin
>*pin,
>>+			     const struct dpll_pin_attr *attr)
>>+{
>>+	struct pin_ref_dpll *ref =3D dpll_pin_find_ref(dpll, pin);
>>+	int ret;
>>+
>>+	mutex_lock(&ref->dpll->lock);
>>+	ret =3D ref->ops->set(ref->dpll, pin, attr);
>>+	if (!ret)
>>+		dpll_notify_pin_change_attr(dpll, pin, attr);
>>+	mutex_unlock(&ref->dpll->lock);
>>+
>>+	return ret;
>>+}
>>+
>>+static int
>>+dpll_pin_set_attr_all_refs(struct dpll_pin *pin,
>>+			   const struct dpll_pin_attr *attr)
>>+{
>>+	struct pin_ref_dpll *ref;
>>+	unsigned long index;
>>+	int ret;
>>+
>>+	xa_for_each(&pin->ref_dplls, index, ref) {
>>+		if (!ref->dpll)
>>+			return -EFAULT;
>>+		if (!ref || !ref->ops || !ref->ops->set)
>>+			return -EOPNOTSUPP;
>>+		mutex_lock(&ref->dpll->lock);
>>+		ret =3D ref->ops->set(ref->dpll, pin, attr);
>>+		mutex_unlock(&ref->dpll->lock);
>>+		if (!ret)
>>+			dpll_notify_pin_change_attr(ref->dpll, pin, attr);
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+int dpll_pin_set_attr(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		      const struct dpll_pin_attr *attr)
>>+{
>>+	struct dpll_pin_attr *tmp_attr;
>>+	int ret;
>>+
>>+	tmp_attr =3D dpll_pin_attr_alloc();
>>+	if (!tmp_attr)
>>+		return -ENOMEM;
>>+	ret =3D dpll_pin_attr_prep_common(tmp_attr, attr);
>>+	if (ret < 0)
>>+		goto tmp_free;
>>+	if (ret =3D=3D PIN_ATTR_CHANGE) {
>>+		ret =3D dpll_pin_set_attr_all_refs(pin, tmp_attr);
>>+		if (ret)
>>+			goto tmp_free;
>>+	}
>>+
>>+	ret =3D dpll_pin_attr_prep_exclusive(tmp_attr, attr);
>>+	if (ret < 0)
>>+		goto tmp_free;
>>+	if (ret =3D=3D PIN_ATTR_CHANGE)
>>+		ret =3D dpll_pin_set_attr_single_ref(dpll, pin, tmp_attr);
>>+
>>+tmp_free:
>>+	dpll_pin_attr_free(tmp_attr);
>>+	return ret;
>>+}
>>+
>>+int dpll_pin_get_attr(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		      struct dpll_pin_attr *attr)
>>+{
>>+	struct pin_ref_dpll *ref =3D dpll_pin_find_ref(dpll, pin);
>>+	int ret;
>>+
>>+	if (!ref)
>>+		return -ENODEV;
>>+	if (!ref->ops || !ref->ops->get)
>>+		return -EOPNOTSUPP;
>>+
>>+	ret =3D ref->ops->get(dpll, pin, attr);
>>+	if (ret)
>>+		return -EAGAIN;
>>+
>>+	return ret;
>>+}
>>+
>>+const char *dpll_pin_get_description(struct dpll_pin *pin)
>>+{
>>+	return pin->description;
>>+}
>>+
>>+struct dpll_pin *dpll_pin_get_parent(struct dpll_pin *pin)
>>+{
>>+	return pin->parent_pin;
>>+}
>
>These helpers should not exist. Not needed for anything good.
>

Will be removed as no longer needed to find a pin "externally".

>
>
>>+
>>+int dpll_set_attr(struct dpll_device *dpll, const struct dpll_attr *attr=
)
>>+{
>>+	int ret;
>>+
>>+	if (dpll_attr_valid(DPLLA_SOURCE_PIN_IDX, attr)) {
>>+		struct pin_ref_dpll *ref;
>>+		struct dpll_pin *pin;
>>+		u32 source_idx;
>>+
>>+		ret =3D dpll_attr_source_idx_get(attr, &source_idx);
>>+		if (ret)
>>+			return -EINVAL;
>>+		pin =3D dpll_pin_get_by_idx(dpll, source_idx);
>>+		if (!pin)
>>+			return -ENXIO;
>>+		ref =3D dpll_pin_find_ref(dpll, pin);
>>+		if (!ref || !ref->ops)
>>+			return -EFAULT;
>>+		if (!ref->ops->select)
>>+			return -ENODEV;
>>+		dpll_lock(ref->dpll);
>>+		ret =3D ref->ops->select(ref->dpll, pin);
>>+		dpll_unlock(ref->dpll);
>>+		if (ret)
>>+			return -EINVAL;
>>+		dpll_notify_device_change_attr(dpll, attr);
>>+	}
>>+
>>+	if (dpll_attr_valid(DPLLA_MODE, attr)) {
>>+		dpll_lock(dpll);
>>+		ret =3D dpll->ops->set(dpll, attr);
>>+		dpll_unlock(dpll);
>>+		if (ret)
>>+			return -EINVAL;
>>+	}
>>+	dpll_notify_device_change_attr(dpll, attr);
>>+
>>+	return ret;
>>+}
>>+
>>+int dpll_get_attr(struct dpll_device *dpll, struct dpll_attr *attr)
>>+{
>>+	if (!dpll)
>>+		return -ENODEV;
>>+	if (!dpll->ops || !dpll->ops->get)
>>+		return -EOPNOTSUPP;
>>+	if (dpll->ops->get(dpll, attr))
>>+		return -EAGAIN;
>>+
>>+	return 0;
>>+}
>>+
>>+void dpll_lock(struct dpll_device *dpll)
>>+{
>>+	mutex_lock(&dpll->lock);
>>+}
>>+
>>+void dpll_unlock(struct dpll_device *dpll)
>>+{
>>+	mutex_unlock(&dpll->lock);
>>+}
>>+
>>+void *dpll_priv(struct dpll_device *dpll)
>>+{
>>+	return dpll->priv;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_priv);
>
>Why do you need this?
>

Called from registering module inside of callback functions to obtain corre=
ct
driver instance data.

>
>>+
>>+void *dpll_pin_priv(struct dpll_device *dpll, struct dpll_pin *pin)
>>+{
>>+	struct pin_ref_dpll *ref =3D dpll_pin_find_ref(dpll, pin);
>>+
>>+	if (!ref)
>>+		return NULL;
>>+
>>+	return ref->priv;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_priv);
>
>And this.
>

Same as above.

>
>>+
>>+static int __init dpll_init(void)
>>+{
>>+	int ret;
>>+
>>+	ret =3D dpll_netlink_init();
>>+	if (ret)
>>+		goto error;
>>+
>>+	ret =3D class_register(&dpll_class);
>>+	if (ret)
>>+		goto unregister_netlink;
>>+
>>+	return 0;
>>+
>>+unregister_netlink:
>>+	dpll_netlink_finish();
>>+error:
>>+	mutex_destroy(&dpll_device_xa_lock);
>>+	return ret;
>>+}
>>+subsys_initcall(dpll_init);
>>diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
>>new file mode 100644
>>index 000000000000..9cefecdfc47b
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_core.h
>>@@ -0,0 +1,176 @@
>>+/* SPDX-License-Identifier: GPL-2.0 */
>>+/*
>>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>+ */
>>+
>>+#ifndef __DPLL_CORE_H__
>>+#define __DPLL_CORE_H__
>>+
>>+#include <linux/dpll.h>
>>+
>>+#include "dpll_netlink.h"
>>+
>>+#define to_dpll_device(_dev) \
>>+	container_of(_dev, struct dpll_device, dev)
>>+
>>+#define for_each_pin_on_dpll(dpll, pin, i)			\
>>+	for (pin =3D dpll_pin_first(dpll, &i); pin !=3D NULL;	\
>>+	     pin =3D dpll_pin_next(dpll, &i))
>>+
>>+#define for_each_dpll(dpll, i)				\
>>+	for (dpll =3D dpll_first(&i); dpll !=3D NULL;	\
>>+	     dpll =3D dpll_next(&i))
>>+
>>+
>>+/**
>>+ * dpll_device_get_by_id - find dpll device by it's id
>>+ * @id: dpll id
>>+ *
>>+ * Return: dpll_device struct if found, NULL otherwise.
>>+ */
>
>Please move the functions comments into .c file.
>

OK, will do.

>
>>+struct dpll_device *dpll_device_get_by_id(int id);
>>+
>>+/**
>>+ * dpll_device_get_by_name - find dpll device by it's id
>>+ * @name: dpll name
>>+ *
>>+ * Return: dpll_device struct if found, NULL otherwise.
>>+ */
>>+struct dpll_device *dpll_device_get_by_name(const char *name);
>>+
>>+/**
>>+ * dpll_pin_first - get first registered pin
>>+ * @dpll: registered dpll pointer
>>+ * @index: found pin index (out)
>>+ *
>>+ * Return: dpll_pin struct if found, NULL otherwise.
>>+ */
>>+struct dpll_pin *dpll_pin_first(struct dpll_device *dpll, unsigned long
>*index);
>>+
>>+/**
>>+ * dpll_pin_next - get next registered pin to the relative pin
>>+ * @dpll: registered dpll pointer
>>+ * @index: relative pin index (in and out)
>>+ *
>>+ * Return: dpll_pin struct if found, NULL otherwise.
>>+ */
>>+struct dpll_pin *dpll_pin_next(struct dpll_device *dpll, unsigned long
>*index);
>>+
>>+/**
>>+ * dpll_first - get first registered dpll device
>>+ * @index: found dpll index (out)
>>+ *
>>+ * Return: dpll_device struct if found, NULL otherwise.
>>+ */
>>+struct dpll_device *dpll_first(unsigned long *index);
>>+
>>+/**
>>+ * dpll_pin_next - get next registered dpll device to the relative pin
>>+ * @index: relative dpll index (in and out)
>>+ *
>>+ * Return: dpll_pin struct if found, NULL otherwise.
>>+ */
>>+struct dpll_device *dpll_next(unsigned long *index);
>>+
>>+/**
>>+ * dpll_device_unregister - unregister dpll device
>>+ * @dpll: registered dpll pointer
>>+ *
>>+ * Note: It does not free the memory
>>+ */
>>+void dpll_device_unregister(struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_id - return dpll id
>>+ * @dpll: registered dpll pointer
>>+ *
>>+ * Return: dpll id.
>>+ */
>>+u32 dpll_id(struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_pin_idx - return dpll name
>>+ * @dpll: registered dpll pointer
>>+ *
>>+ * Return: dpll name.
>>+ */
>>+const char *dpll_dev_name(struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_lock - locks the dpll using internal mutex
>>+ * @dpll: registered dpll pointer
>>+ */
>>+void dpll_lock(struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_unlock - unlocks the dpll using internal mutex
>>+ * @dpll: registered dpll pointer
>>+ */
>>+void dpll_unlock(struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_set_attr - handler for dpll subsystem: dpll set attributes
>>+ * @dpll: registered dpll pointer
>>+ * @attr: dpll attributes
>>+ *
>>+ * Return: 0 if succeeds, error code otherwise.
>>+ */
>>+int dpll_set_attr(struct dpll_device *dpll, const struct dpll_attr
>*attr);
>>+
>>+/**
>>+ * dpll_get_attr - handler for dpll subsystem: dpll get attributes
>>+ * @dpll: registered dpll pointer
>>+ * @attr: dpll attributes
>>+ *
>>+ * Return: 0 if succeeds, error code otherwise.
>>+ */
>>+int dpll_get_attr(struct dpll_device *dpll, struct dpll_attr *attr);
>>+
>>+/**
>>+ * dpll_pin_idx - return dpll id
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ *
>>+ * Return: dpll id.
>>+ */
>>+u32 dpll_pin_idx(struct dpll_device *dpll, struct dpll_pin *pin);
>>+
>>+/**
>>+ * dpll_pin_get_attr - handler for dpll subsystem: dpll pin get
>attributes
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @attr: dpll pin attributes
>>+ *
>>+ * Return: 0 if succeeds, error code otherwise.
>>+ */
>>+int dpll_pin_get_attr(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		      struct dpll_pin_attr *attr);
>>+
>>+/**
>>+ * dpll_pin_get_description - provide pin's description string
>>+ * @pin: registered pin pointer
>>+ *
>>+ * Return: pointer to a description string.
>>+ */
>>+const char *dpll_pin_get_description(struct dpll_pin *pin);
>>+
>>+/**
>>+ * dpll_pin_get_parent - provide pin's parent pin if available
>>+ * @pin: registered pin pointer
>>+ *
>>+ * Return: pointer to aparent if found, NULL otherwise.
>>+ */
>>+struct dpll_pin *dpll_pin_get_parent(struct dpll_pin *pin);
>>+
>>+/**
>>+ * dpll_pin_set_attr - handler for dpll subsystem: dpll pin get
>attributes
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @attr: dpll pin attributes
>>+ *
>>+ * Return: 0 if succeeds, error code otherwise.
>>+ */
>>+int dpll_pin_set_attr(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		      const struct dpll_pin_attr *attr);
>>+
>>+#endif
>>diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>>new file mode 100644
>>index 000000000000..9a1f682a42ac
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_netlink.c
>>@@ -0,0 +1,963 @@
>>+// SPDX-License-Identifier: GPL-2.0
>>+/*
>>+ * Generic netlink for DPLL management framework
>>+ *
>>+ * Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>+ *
>>+ */
>>+#include <linux/module.h>
>>+#include <linux/kernel.h>
>>+#include <net/genetlink.h>
>>+#include "dpll_core.h"
>>+
>>+#include <uapi/linux/dpll.h>
>>+
>>+static const struct genl_multicast_group dpll_mcgrps[] =3D {
>>+	{ .name =3D DPLL_MONITOR_GROUP_NAME,  },
>>+};
>>+
>>+static const struct nla_policy dpll_cmd_device_get_policy[] =3D {
>>+	[DPLLA_ID]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_NAME]		=3D { .type =3D NLA_STRING,
>>+				    .len =3D DPLL_NAME_LEN },
>>+	[DPLLA_DUMP_FILTER]	=3D { .type =3D NLA_U32 },
>>+	[DPLLA_NETIFINDEX]	=3D { .type =3D NLA_U32 },
>>+};
>>+
>>+static const struct nla_policy dpll_cmd_device_set_policy[] =3D {
>>+	[DPLLA_ID]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_NAME]		=3D { .type =3D NLA_STRING,
>>+				    .len =3D DPLL_NAME_LEN },
>>+	[DPLLA_MODE]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_SOURCE_PIN_IDX]	=3D { .type =3D NLA_U32 },
>>+};
>>+
>>+static const struct nla_policy dpll_cmd_pin_set_policy[] =3D {
>>+	[DPLLA_ID]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_IDX]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_TYPE]	=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_SIGNAL_TYPE]	=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_CUSTOM_FREQ] =3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_STATE]	=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_PRIO]	=3D { .type =3D NLA_U32 },
>>+};
>>+
>>+struct dpll_param {
>>+	struct netlink_callback *cb;
>>+	struct sk_buff *msg;
>>+	struct dpll_device *dpll;
>>+	struct dpll_pin *pin;
>>+	enum dpll_event_change change_type;
>>+};
>>+
>>+struct dpll_dump_ctx {
>>+	int dump_filter;
>>+};
>>+
>>+typedef int (*cb_t)(struct dpll_param *);
>>+
>>+static struct genl_family dpll_gnl_family;
>>+
>>+static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback
>*cb)
>>+{
>>+	return (struct dpll_dump_ctx *)cb->ctx;
>>+}
>>+
>>+static int dpll_msg_add_id(struct sk_buff *msg, u32 id)
>>+{
>>+	if (nla_put_u32(msg, DPLLA_ID, id))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_name(struct sk_buff *msg, const char *name)
>>+{
>>+	if (nla_put_string(msg, DPLLA_NAME, name))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int __dpll_msg_add_mode(struct sk_buff *msg, enum dplla msg_type,
>>+			       enum dpll_mode mode)
>>+{
>>+	if (nla_put_s32(msg, msg_type, mode))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_mode(struct sk_buff *msg, const struct dpll_attr
>*attr)
>>+{
>>+	enum dpll_mode m =3D dpll_attr_mode_get(attr);
>>+
>>+	if (m =3D=3D DPLL_MODE_UNSPEC)
>>+		return 0;
>>+
>>+	return __dpll_msg_add_mode(msg, DPLLA_MODE, m);
>>+}
>>+
>>+static int dpll_msg_add_modes_supported(struct sk_buff *msg,
>>+					const struct dpll_attr *attr)
>>+{
>>+	enum dpll_mode i;
>>+	int  ret =3D 0;
>>+
>>+	for (i =3D DPLL_MODE_UNSPEC + 1; i <=3D DPLL_MODE_MAX; i++) {
>>+		if (dpll_attr_mode_supported(attr, i)) {
>>+			ret =3D __dpll_msg_add_mode(msg, DPLLA_MODE_SUPPORTED, i);
>>+			if (ret)
>>+				return -EMSGSIZE;
>>+		}
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_msg_add_source_pin(struct sk_buff *msg, struct dpll_attr
>*attr)
>>+{
>>+	u32 source_idx;
>>+
>>+	if (dpll_attr_source_idx_get(attr, &source_idx))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_SOURCE_PIN_IDX, source_idx))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_netifindex(struct sk_buff *msg, struct dpll_attr
>*attr)
>>+{
>>+	unsigned int netifindex; // TODO: Should be u32?
>>+
>>+	if (dpll_attr_netifindex_get(attr, &netifindex))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_NETIFINDEX, netifindex))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_lock_status(struct sk_buff *msg, struct dpll_att=
r
>*attr)
>>+{
>>+	enum dpll_lock_status s =3D dpll_attr_lock_status_get(attr);
>>+
>>+	if (s =3D=3D DPLL_LOCK_STATUS_UNSPEC)
>>+		return 0;
>>+	if (nla_put_s32(msg, DPLLA_LOCK_STATUS, s))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_temp(struct sk_buff *msg, struct dpll_attr *attr=
)
>>+{
>>+	s32 temp;
>>+
>>+	if (dpll_attr_temp_get(attr, &temp))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_TEMP, temp))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_idx(struct sk_buff *msg, u32 pin_idx)
>>+{
>>+	if (nla_put_u32(msg, DPLLA_PIN_IDX, pin_idx))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_description(struct sk_buff *msg,
>>+					const char *description)
>>+{
>>+	if (nla_put_string(msg, DPLLA_PIN_DESCRIPTION, description))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_parent_idx(struct sk_buff *msg, u32
>parent_idx)
>>+{
>>+	if (nla_put_u32(msg, DPLLA_PIN_PARENT_IDX, parent_idx))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int __dpll_msg_add_pin_type(struct sk_buff *msg, enum dplla attr,
>>+				   enum dpll_pin_type type)
>>+{
>>+	if (nla_put_s32(msg, attr, type))
>>+		return -EMSGSIZE;
>
>
>Please avoid these pointless helpers and call nla_put_*() directly.
>
>
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_type(struct sk_buff *msg, const struct dpll_pin_attr
>*attr)
>>+{
>>+	enum dpll_pin_type t =3D dpll_pin_attr_type_get(attr);
>>+
>>+	if (t =3D=3D DPLL_PIN_TYPE_UNSPEC)
>>+		return 0;
>>+
>>+	return __dpll_msg_add_pin_type(msg, DPLLA_PIN_TYPE, t);
>>+}
>>+
>>+static int dpll_msg_add_pin_types_supported(struct sk_buff *msg,
>>+					    const struct dpll_pin_attr *attr)
>>+{
>>+	enum dpll_pin_type i;
>>+	int ret;
>>+
>>+	for (i =3D DPLL_PIN_TYPE_UNSPEC + 1; i <=3D DPLL_PIN_TYPE_MAX; i++) {
>>+		if (dpll_pin_attr_type_supported(attr, i)) {
>>+			ret =3D __dpll_msg_add_pin_type(msg,
>>+						      DPLLA_PIN_TYPE_SUPPORTED,
>>+						      i);
>>+			if (ret)
>>+				return ret;
>>+		}
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int __dpll_msg_add_pin_signal_type(struct sk_buff *msg,
>>+					  enum dplla attr,
>>+					  enum dpll_pin_signal_type type)
>>+{
>>+	if (nla_put_s32(msg, attr, type))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_signal_type(struct sk_buff *msg,
>>+					const struct dpll_pin_attr *attr)
>>+{
>>+	enum dpll_pin_signal_type t =3D dpll_pin_attr_signal_type_get(attr);
>>+
>>+	if (t =3D=3D DPLL_PIN_SIGNAL_TYPE_UNSPEC)
>>+		return 0;
>>+
>>+	return __dpll_msg_add_pin_signal_type(msg, DPLLA_PIN_SIGNAL_TYPE, t);
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_signal_types_supported(struct sk_buff *msg,
>>+					const struct dpll_pin_attr *attr)
>>+{
>>+	const enum dplla da =3D DPLLA_PIN_SIGNAL_TYPE_SUPPORTED;
>>+	enum dpll_pin_signal_type i;
>>+	int ret;
>>+
>>+	for (i =3D DPLL_PIN_SIGNAL_TYPE_UNSPEC + 1;
>>+	     i <=3D DPLL_PIN_SIGNAL_TYPE_MAX; i++) {
>>+		if (dpll_pin_attr_signal_type_supported(attr, i)) {
>>+			ret =3D __dpll_msg_add_pin_signal_type(msg, da, i);
>>+			if (ret)
>>+				return ret;
>>+		}
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_custom_freq(struct sk_buff *msg,
>>+					const struct dpll_pin_attr *attr)
>>+{
>>+	u32 freq;
>>+
>>+	if (dpll_pin_attr_custom_freq_get(attr, &freq))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_PIN_CUSTOM_FREQ, freq))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_states(struct sk_buff *msg,
>>+				   const struct dpll_pin_attr *attr)
>>+{
>>+	enum dpll_pin_state i;
>>+
>>+	for (i =3D DPLL_PIN_STATE_UNSPEC + 1; i <=3D DPLL_PIN_STATE_MAX; i++)
>>+		if (dpll_pin_attr_state_enabled(attr, i))
>>+			if (nla_put_s32(msg, DPLLA_PIN_STATE, i))
>>+				return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_states_supported(struct sk_buff *msg,
>>+					     const struct dpll_pin_attr *attr)
>>+{
>>+	enum dpll_pin_state i;
>>+
>>+	for (i =3D DPLL_PIN_STATE_UNSPEC + 1; i <=3D DPLL_PIN_STATE_MAX; i++)
>>+		if (dpll_pin_attr_state_supported(attr, i))
>>+			if (nla_put_s32(msg, DPLLA_PIN_STATE_SUPPORTED, i))
>>+				return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_prio(struct sk_buff *msg, const struct dpll_pin_attr
>*attr)
>>+{
>>+	u32 prio;
>>+
>>+	if (dpll_pin_attr_prio_get(attr, &prio))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_PIN_PRIO, prio))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_netifindex(struct sk_buff *msg, const struct
>dpll_pin_attr *attr)
>>+{
>>+	unsigned int netifindex; // TODO: Should be u32?
>>+
>>+	if (dpll_pin_attr_netifindex_get(attr, &netifindex))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_PIN_NETIFINDEX, netifindex))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_event_change_type(struct sk_buff *msg,
>>+			       enum dpll_event_change event)
>>+{
>>+	if (nla_put_s32(msg, DPLLA_CHANGE_TYPE, event))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+__dpll_cmd_device_dump_one(struct sk_buff *msg, struct dpll_device *dpll=
)
>>+{
>>+	int ret =3D dpll_msg_add_id(msg, dpll_id(dpll));
>>+
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_name(msg, dpll_dev_name(dpll));
>>+
>>+	return ret;
>>+}
>>+
>>+static int
>>+__dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_device *dpll,
>>+			struct dpll_pin *pin)
>>+{
>>+	struct dpll_pin_attr *attr =3D dpll_pin_attr_alloc();
>>+	struct dpll_pin *parent =3D NULL;
>>+	int ret;
>>+
>>+	if (!attr)
>>+		return -ENOMEM;
>>+	ret =3D dpll_msg_add_pin_idx(msg, dpll_pin_idx(dpll, pin));
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_description(msg,
>dpll_pin_get_description(pin));
>>+	if (ret)
>>+		goto out;
>>+	parent =3D dpll_pin_get_parent(pin);
>>+	if (parent) {
>>+		ret =3D dpll_msg_add_pin_parent_idx(msg, dpll_pin_idx(dpll,
>>+								    parent));
>>+		if (ret)
>>+			goto out;
>>+	}
>>+	ret =3D dpll_pin_get_attr(dpll, pin, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_type(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_types_supported(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_signal_type(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_signal_types_supported(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_custom_freq(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_states(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_states_supported(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_prio(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_netifindex(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+out:
>>+	dpll_pin_attr_free(attr);
>>+
>>+	return ret;
>>+}
>>+
>>+static int __dpll_cmd_dump_pins(struct sk_buff *msg, struct dpll_device
>*dpll)
>>+{
>>+	struct dpll_pin *pin;
>>+	struct nlattr *attr;
>>+	unsigned long i;
>>+	int ret =3D 0;
>>+
>>+	for_each_pin_on_dpll(dpll, pin, i) {
>>+		attr =3D nla_nest_start(msg, DPLLA_PIN);
>>+		if (!attr) {
>>+			ret =3D -EMSGSIZE;
>>+			goto nest_cancel;
>>+		}
>>+		ret =3D __dpll_cmd_pin_dump_one(msg, dpll, pin);
>>+		if (ret)
>>+			goto nest_cancel;
>>+		nla_nest_end(msg, attr);
>>+	}
>>+
>>+	return ret;
>>+
>>+nest_cancel:
>>+	nla_nest_cancel(msg, attr);
>>+	return ret;
>>+}
>>+
>>+static int
>>+__dpll_cmd_dump_status(struct sk_buff *msg, struct dpll_device *dpll)
>>+{
>>+	struct dpll_attr *attr =3D dpll_attr_alloc();
>>+	int ret =3D dpll_get_attr(dpll, attr);
>>+
>>+	if (ret)
>>+		return -EAGAIN;
>>+	if (dpll_msg_add_source_pin(msg, attr))
>>+		return -EMSGSIZE;
>>+	if (dpll_msg_add_temp(msg, attr))
>>+		return -EMSGSIZE;
>>+	if (dpll_msg_add_lock_status(msg, attr))
>>+		return -EMSGSIZE;
>>+	if (dpll_msg_add_mode(msg, attr))
>>+		return -EMSGSIZE;
>>+	if (dpll_msg_add_modes_supported(msg, attr))
>>+		return -EMSGSIZE;
>>+	if (dpll_msg_add_netifindex(msg, attr))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_device_dump_one(struct dpll_device *dpll, struct sk_buff *msg,
>>+		     int dump_filter)
>>+{
>>+	int ret;
>>+
>>+	dpll_lock(dpll);
>>+	ret =3D __dpll_cmd_device_dump_one(msg, dpll);
>>+	if (ret)
>>+		goto out_unlock;
>>+
>>+	if (dump_filter & DPLL_DUMP_FILTER_STATUS) {
>>+		ret =3D __dpll_cmd_dump_status(msg, dpll);
>>+		if (ret)
>>+			goto out_unlock;
>>+	}
>>+	if (dump_filter & DPLL_DUMP_FILTER_PINS)
>>+		ret =3D __dpll_cmd_dump_pins(msg, dpll);
>>+	dpll_unlock(dpll);
>>+
>>+	return ret;
>>+out_unlock:
>>+	dpll_unlock(dpll);
>>+	return ret;
>>+}
>>+
>>+static enum dpll_pin_type dpll_msg_read_pin_type(struct nlattr *a)
>>+{
>>+	return nla_get_s32(a);
>
>
>No need to have this pointless boilerplate helpers, just call nla_get_x()
>directly.
>
They read correct type from nlattr and return right type for each attribute=
,
thus all are not pointless.
But I will remove them as they are not reused anywhere.

>
>>+}
>>+
>>+static enum dpll_pin_signal_type dpll_msg_read_pin_sig_type(struct nlatt=
r
>*a)
>>+{
>>+	return nla_get_s32(a);
>>+}
>>+
>>+static u32 dpll_msg_read_pin_custom_freq(struct nlattr *a)
>>+{
>>+	return nla_get_u32(a);
>>+}
>>+
>>+static enum dpll_pin_state dpll_msg_read_pin_state(struct nlattr *a)
>>+{
>>+	return nla_get_s32(a);
>>+}
>>+
>>+static u32 dpll_msg_read_pin_prio(struct nlattr *a)
>>+{
>>+	return nla_get_u32(a);
>>+}
>>+
>>+static u32 dpll_msg_read_dump_filter(struct nlattr *a)
>>+{
>>+	return nla_get_u32(a);
>>+}
>>+
>>+static int
>>+dpll_pin_attr_from_nlattr(struct dpll_pin_attr *pa, struct genl_info
>*info)
>>+{
>>+	enum dpll_pin_signal_type st;
>>+	enum dpll_pin_state state;
>>+	enum dpll_pin_type t;
>>+	struct nlattr *a;
>>+	int rem, ret =3D 0;
>>+	u32 prio, freq;
>>+
>>+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>>+			  genlmsg_len(info->genlhdr), rem) {
>>+		switch (nla_type(a)) {
>>+		case DPLLA_PIN_TYPE:
>
>Does not make sense to me. Why do you allow to set the pin type? That
>should be something constant, according to the hardware architecture.
>

Changed as suggested, if multiple pin types are possible on the hardware, t=
hey
shall be handled with MUX-type pin and multiple pins connected to it.

>
>>+			t =3D dpll_msg_read_pin_type(a);
>>+			ret =3D dpll_pin_attr_type_set(pa, t);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_PIN_SIGNAL_TYPE:
>>+			st =3D dpll_msg_read_pin_sig_type(a);
>>+			ret =3D dpll_pin_attr_signal_type_set(pa, st);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_PIN_CUSTOM_FREQ:
>>+			freq =3D dpll_msg_read_pin_custom_freq(a);
>>+			ret =3D dpll_pin_attr_custom_freq_set(pa, freq);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_PIN_STATE:
>>+			state =3D dpll_msg_read_pin_state(a);
>>+			ret =3D dpll_pin_attr_state_set(pa, state);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_PIN_PRIO:
>>+			prio =3D dpll_msg_read_pin_prio(a);
>>+			ret =3D dpll_pin_attr_prio_set(pa, prio);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		default:
>>+			break;
>>+		}
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_cmd_pin_set(struct sk_buff *skb, struct genl_info *info)
>>+{
>>+	struct dpll_pin_attr *old =3D NULL, *new =3D NULL, *delta =3D NULL;
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+	struct nlattr **attrs =3D info->attrs;
>>+	struct dpll_pin *pin;
>>+	int ret, pin_id;
>>+
>>+	if (!attrs[DPLLA_PIN_IDX])
>>+		return -EINVAL;
>>+	pin_id =3D nla_get_u32(attrs[DPLLA_PIN_IDX]);
>>+	old =3D dpll_pin_attr_alloc();
>>+	new =3D dpll_pin_attr_alloc();
>>+	delta =3D dpll_pin_attr_alloc();
>>+	if (!old || !new || !delta) {
>>+		ret =3D -ENOMEM;
>>+		goto mem_free;
>>+	}
>>+	dpll_lock(dpll);
>>+	pin =3D dpll_pin_get_by_idx(dpll, pin_id);
>>+	if (!pin) {
>>+		ret =3D -ENODEV;
>>+		goto mem_free_unlock;
>>+	}
>>+	ret =3D dpll_pin_get_attr(dpll, pin, old);
>>+	if (ret)
>>+		goto mem_free_unlock;
>>+	ret =3D dpll_pin_attr_from_nlattr(new, info);
>>+	if (ret)
>>+		goto mem_free_unlock;
>>+	ret =3D dpll_pin_attr_delta(delta, new, old);
>>+	dpll_unlock(dpll);
>>+	if (!ret)
>>+		ret =3D dpll_pin_set_attr(dpll, pin, delta);
>>+	else
>>+		ret =3D -EINVAL;
>>+
>>+	dpll_pin_attr_free(delta);
>>+	dpll_pin_attr_free(new);
>>+	dpll_pin_attr_free(old);
>>+
>>+	return ret;
>>+
>>+mem_free_unlock:
>>+	dpll_unlock(dpll);
>>+mem_free:
>>+	dpll_pin_attr_free(delta);
>>+	dpll_pin_attr_free(new);
>>+	dpll_pin_attr_free(old);
>>+	return ret;
>>+}
>>+
>>+enum dpll_mode dpll_msg_read_mode(struct nlattr *a)
>>+{
>>+	return nla_get_s32(a);
>>+}
>>+
>>+u32 dpll_msg_read_source_pin_id(struct nlattr *a)
>>+{
>>+	return nla_get_u32(a);
>>+}
>>+
>>+static int
>>+dpll_attr_from_nlattr(struct dpll_attr *dpll, struct genl_info *info)
>>+{
>>+	enum dpll_mode m;
>>+	struct nlattr *a;
>>+	int rem, ret =3D 0;
>>+	u32 source_pin;
>>+
>>+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>>+			  genlmsg_len(info->genlhdr), rem) {
>>+		switch (nla_type(a)) {
>>+		case DPLLA_MODE:
>>+			m =3D dpll_msg_read_mode(a);
>>+
>>+			ret =3D dpll_attr_mode_set(dpll, m);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_SOURCE_PIN_IDX:
>>+			source_pin =3D dpll_msg_read_source_pin_id(a);
>>+
>>+			ret =3D dpll_attr_source_idx_set(dpll, source_pin);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		default:
>>+			break;
>>+		}
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_cmd_device_set(struct sk_buff *skb, struct genl_info
>*info)
>>+{
>>+	struct dpll_attr *old =3D NULL, *new =3D NULL, *delta =3D NULL;
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+	int ret;
>>+
>>+	old =3D dpll_attr_alloc();
>>+	new =3D dpll_attr_alloc();
>>+	delta =3D dpll_attr_alloc();
>>+	if (!old || !new || !delta) {
>>+		ret =3D -ENOMEM;
>>+		goto mem_free;
>>+	}
>>+	dpll_lock(dpll);
>>+	ret =3D dpll_get_attr(dpll, old);
>>+	dpll_unlock(dpll);
>>+	if (!ret) {
>>+		dpll_attr_from_nlattr(new, info);
>>+		ret =3D dpll_attr_delta(delta, new, old);
>>+		if (!ret)
>>+			ret =3D dpll_set_attr(dpll, delta);
>>+	}
>>+
>>+mem_free:
>>+	dpll_attr_free(old);
>>+	dpll_attr_free(new);
>>+	dpll_attr_free(delta);
>>+
>>+	return ret;
>>+}
>>+
>>+static int
>>+dpll_cmd_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>+{
>>+	struct dpll_dump_ctx *ctx =3D dpll_dump_context(cb);
>>+	struct dpll_device *dpll;
>>+	struct nlattr *hdr;
>>+	unsigned long i;
>>+	int ret;
>>+
>>+	hdr =3D genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh-
>>nlmsg_seq,
>>+			  &dpll_gnl_family, 0, DPLL_CMD_DEVICE_GET);
>>+	if (!hdr)
>>+		return -EMSGSIZE;
>>+
>>+	for_each_dpll(dpll, i) {
>>+		ret =3D dpll_device_dump_one(dpll, skb, ctx->dump_filter);
>>+		if (ret)
>>+			break;
>>+	}
>>+
>>+	if (ret)
>>+		genlmsg_cancel(skb, hdr);
>>+	else
>>+		genlmsg_end(skb, hdr);
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_cmd_device_get(struct sk_buff *skb, struct genl_info
>*info)
>>+{
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+	struct nlattr **attrs =3D info->attrs;
>>+	struct sk_buff *msg;
>>+	int dump_filter =3D 0;
>>+	struct nlattr *hdr;
>>+	int ret;
>>+
>>+	if (attrs[DPLLA_DUMP_FILTER])
>
>It's not a "dump" filter for "get" callback. Btw, why do you need this
>filtering at all? Do you expect some significant amount of pins assigned
>to dpll so you need to filter them out? If not, leave the filtering
>mechanism out for now to make things easier.
>

It works for both, will change name to DPLLA_FILTER for less confusion.

IMHO most important is to be able to separate DPLL status from the pins,
dumping the pins can be intensive, but once everything is configured user
would most likely just need dpll status.

>
>
>>+		dump_filter =3D
>>+			dpll_msg_read_dump_filter(attrs[DPLLA_DUMP_FILTER]);
>>+
>>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>+	if (!msg)
>>+		return -ENOMEM;
>>+	hdr =3D genlmsg_put_reply(msg, info, &dpll_gnl_family, 0,
>>+				DPLL_CMD_DEVICE_GET);
>>+	if (!hdr)
>>+		return -EMSGSIZE;
>>+
>>+	ret =3D dpll_device_dump_one(dpll, msg, dump_filter);
>>+	if (ret)
>>+		goto out_free_msg;
>>+	genlmsg_end(msg, hdr);
>>+
>>+	return genlmsg_reply(msg, info);
>>+
>>+out_free_msg:
>>+	nlmsg_free(msg);
>>+	return ret;
>>+
>>+}
>>+
>>+static int dpll_cmd_device_get_start(struct netlink_callback *cb)
>>+{
>>+	const struct genl_dumpit_info *info =3D genl_dumpit_info(cb);
>>+	struct dpll_dump_ctx *ctx =3D dpll_dump_context(cb);
>>+	struct nlattr *attr =3D info->attrs[DPLLA_DUMP_FILTER];
>>+
>>+	if (attr)
>>+		ctx->dump_filter =3D dpll_msg_read_dump_filter(attr);
>>+	else
>>+		ctx->dump_filter =3D 0;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buf=
f
>*skb,
>>+			 struct genl_info *info)
>>+{
>>+	struct dpll_device *dpll_id =3D NULL, *dpll_name =3D NULL;
>>+
>>+	if (!info->attrs[DPLLA_ID] &&
>>+	    !info->attrs[DPLLA_NAME])
>>+		return -EINVAL;
>>+
>>+	if (info->attrs[DPLLA_ID]) {
>>+		u32 id =3D nla_get_u32(info->attrs[DPLLA_ID]);
>>+
>>+		dpll_id =3D dpll_device_get_by_id(id);
>
>You are missing some locking here. What is protecting the driver from
>unregistering the instance right at the time you have this
>pointer returned?
>
>You need some reference counting and locking scheme to be defined and
>used.

True, we need a fix here.

>
>
>>+		if (!dpll_id)
>>+			return -ENODEV;
>>+		info->user_ptr[0] =3D dpll_id;
>>+	}
>>+	if (info->attrs[DPLLA_NAME]) {
>>+		const char *name =3D nla_data(info->attrs[DPLLA_NAME]);
>
>I still think that we should have 1 handle for dpll.
>We don't need DPLLA_ID. It is not stable, not sure anyone will use it.
>Why don't you have bus/name handle tuple similar to how we do it in
>devlink? It proved to be working good over the years. Check out:
>DEVLINK_ATTR_BUS_NAME
>DEVLINK_ATTR_DEV_NAME
>

Well, don't have strong opinion here.

>
>>+
>>+		dpll_name =3D dpll_device_get_by_name(name);
>>+		if (!dpll_name)
>>+			return -ENODEV;
>>+
>>+		if (dpll_id && dpll_name !=3D dpll_id)
>>+			return -EINVAL;
>>+		info->user_ptr[0] =3D dpll_name;
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static const struct genl_ops dpll_ops[] =3D {
>>+	{
>>+		.cmd	=3D DPLL_CMD_DEVICE_GET,
>>+		.flags  =3D GENL_UNS_ADMIN_PERM,
>>+		.start	=3D dpll_cmd_device_get_start,
>>+		.dumpit	=3D dpll_cmd_device_dump,
>>+		.doit	=3D dpll_cmd_device_get,
>>+		.policy	=3D dpll_cmd_device_get_policy,
>>+		.maxattr =3D ARRAY_SIZE(dpll_cmd_device_get_policy) - 1,
>>+	},
>>+	{
>>+		.cmd	=3D DPLL_CMD_DEVICE_SET,
>>+		.flags	=3D GENL_UNS_ADMIN_PERM,
>>+		.doit	=3D dpll_cmd_device_set,
>>+		.policy	=3D dpll_cmd_device_set_policy,
>>+		.maxattr =3D ARRAY_SIZE(dpll_cmd_device_set_policy) - 1,
>>+	},
>>+	{
>>+		.cmd	=3D DPLL_CMD_PIN_SET,
>>+		.flags	=3D GENL_UNS_ADMIN_PERM,
>>+		.doit	=3D dpll_cmd_pin_set,
>>+		.policy	=3D dpll_cmd_pin_set_policy,
>>+		.maxattr =3D ARRAY_SIZE(dpll_cmd_pin_set_policy) - 1,
>>+	},
>>+};
>>+
>>+static struct genl_family dpll_family __ro_after_init =3D {
>>+	.hdrsize	=3D 0,
>>+	.name		=3D DPLL_FAMILY_NAME,
>>+	.version	=3D DPLL_VERSION,
>>+	.ops		=3D dpll_ops,
>>+	.n_ops		=3D ARRAY_SIZE(dpll_ops),
>>+	.mcgrps		=3D dpll_mcgrps,
>>+	.n_mcgrps	=3D ARRAY_SIZE(dpll_mcgrps),
>>+	.pre_doit	=3D dpll_pre_doit,
>>+	.parallel_ops   =3D true,
>>+};
>>+
>>+static int dpll_event_device_id(struct dpll_param *p)
>>+{
>>+	int ret =3D dpll_msg_add_id(p->msg, dpll_id(p->dpll));
>>+
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_name(p->msg, dpll_dev_name(p->dpll));
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_event_device_change(struct dpll_param *p)
>>+{
>>+	int ret =3D dpll_msg_add_id(p->msg, dpll_id(p->dpll));
>>+
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_event_change_type(p->msg, p->change_type);
>>+	if (ret)
>>+		return ret;
>>+	switch (p->change_type)	{
>>+	case DPLL_CHANGE_PIN_ADD:
>>+	case DPLL_CHANGE_PIN_DEL:
>>+	case DPLL_CHANGE_PIN_TYPE:
>>+	case DPLL_CHANGE_PIN_SIGNAL_TYPE:
>>+	case DPLL_CHANGE_PIN_STATE:
>>+	case DPLL_CHANGE_PIN_PRIO:
>>+		ret =3D dpll_msg_add_pin_idx(p->msg, dpll_pin_idx(p->dpll, p-
>>pin));
>>+		break;
>>+	default:
>>+		break;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static const cb_t event_cb[] =3D {
>>+	[DPLL_EVENT_DEVICE_CREATE]	=3D dpll_event_device_id,
>>+	[DPLL_EVENT_DEVICE_DELETE]	=3D dpll_event_device_id,
>>+	[DPLL_EVENT_DEVICE_CHANGE]	=3D dpll_event_device_change,
>>+};
>>+
>>+/*
>>+ * Generic netlink DPLL event encoding
>>+ */
>>+static int dpll_send_event(enum dpll_event event, struct dpll_param *p)
>>+{
>>+	struct sk_buff *msg;
>>+	int ret =3D -EMSGSIZE;
>>+	void *hdr;
>>+
>>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>+	if (!msg)
>>+		return -ENOMEM;
>>+	p->msg =3D msg;
>>+
>>+	hdr =3D genlmsg_put(msg, 0, 0, &dpll_family, 0, event);
>>+	if (!hdr)
>>+		goto out_free_msg;
>>+
>>+	ret =3D event_cb[event](p);
>>+	if (ret)
>>+		goto out_cancel_msg;
>>+
>>+	genlmsg_end(msg, hdr);
>>+
>>+	genlmsg_multicast(&dpll_family, msg, 0, 0, GFP_KERNEL);
>>+
>>+	return 0;
>>+
>>+out_cancel_msg:
>>+	genlmsg_cancel(msg, hdr);
>>+out_free_msg:
>>+	nlmsg_free(msg);
>>+
>>+	return ret;
>>+}
>>+
>>+int dpll_notify_device_create(struct dpll_device *dpll)
>>+{
>>+	struct dpll_param p =3D { .dpll =3D dpll };
>>+
>>+	return dpll_send_event(DPLL_EVENT_DEVICE_CREATE, &p);
>>+}
>>+
>>+int dpll_notify_device_delete(struct dpll_device *dpll)
>>+{
>>+	struct dpll_param p =3D { .dpll =3D dpll };
>>+
>>+	return dpll_send_event(DPLL_EVENT_DEVICE_DELETE, &p);
>>+}
>>+
>>+int dpll_notify_device_change(struct dpll_device *dpll,
>>+			      enum dpll_event_change event,
>>+			      struct dpll_pin *pin)
>>+{
>>+	struct dpll_param p =3D { .dpll =3D dpll,
>>+				.change_type =3D event,
>>+				.pin =3D pin };
>>+
>>+	return dpll_send_event(DPLL_EVENT_DEVICE_CHANGE, &p);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_notify_device_change);
>>+
>>+int __init dpll_netlink_init(void)
>>+{
>>+	return genl_register_family(&dpll_family);
>>+}
>>+
>>+void dpll_netlink_finish(void)
>>+{
>>+	genl_unregister_family(&dpll_family);
>>+}
>>+
>>+void __exit dpll_netlink_fini(void)
>>+{
>>+	dpll_netlink_finish();
>>+}
>>diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>>new file mode 100644
>>index 000000000000..8e50b2493027
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_netlink.h
>>@@ -0,0 +1,24 @@
>>+/* SPDX-License-Identifier: GPL-2.0 */
>>+/*
>>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>+ */
>>+
>>+/**
>>+ * dpll_notify_device_create - notify that the device has been created
>>+ * @dpll: registered dpll pointer
>>+ *
>>+ * Return: 0 if succeeds, error code otherwise.
>>+ */
>>+int dpll_notify_device_create(struct dpll_device *dpll);
>>+
>>+
>>+/**
>>+ * dpll_notify_device_delete - notify that the device has been deleted
>>+ * @dpll: registered dpll pointer
>>+ *
>>+ * Return: 0 if succeeds, error code otherwise.
>>+ */
>>+int dpll_notify_device_delete(struct dpll_device *dpll);
>>+
>>+int __init dpll_netlink_init(void);
>>+void dpll_netlink_finish(void);
>>diff --git a/include/linux/dpll.h b/include/linux/dpll.h
>>new file mode 100644
>>index 000000000000..a9cbf260624d
>>--- /dev/null
>>+++ b/include/linux/dpll.h
>>@@ -0,0 +1,261 @@
>>+/* SPDX-License-Identifier: GPL-2.0 */
>>+/*
>>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>+ */
>>+
>>+#ifndef __DPLL_H__
>>+#define __DPLL_H__
>>+
>>+#include <uapi/linux/dpll.h>
>>+#include <linux/dpll_attr.h>
>>+#include <linux/device.h>
>>+
>>+struct dpll_device;
>>+struct dpll_pin;
>>+
>>+#define DPLL_COOKIE_LEN		10
>>+#define PIN_IDX_INVALID		((u32)ULONG_MAX)
>
>Plese maintain the namespace prefix.
>

Sure.

>
>>+struct dpll_device_ops {
>>+	int (*get)(struct dpll_device *dpll, struct dpll_attr *attr);
>>+	int (*set)(struct dpll_device *dpll, const struct dpll_attr *attr);
>>+};
>>+
>>+struct dpll_pin_ops {
>>+	int (*get)(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		   struct dpll_pin_attr *attr);
>>+	int (*set)(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		   const struct dpll_pin_attr *attr);
>>+	int (*select)(struct dpll_device *dpll, struct dpll_pin *pin);
>>+};
>>+
>>+enum dpll_type {
>>+	DPLL_TYPE_UNSPEC,
>
>You are not in UAPI, no need of unspec here.
>

Will move into uapi as this value would be part of generated dpll
device name, thus seems useful for userspace.

>
>>+	DPLL_TYPE_PPS,
>>+	DPLL_TYPE_EEC,
>
>What exactly are these? Some comment would be really good here.
>

Sure.

>
>
>>+
>>+	__DPLL_TYPE_MAX
>>+};
>>+#define DPLL_TYPE_MAX	(__DPLL_TYPE_MAX - 1)
>>+
>>+/**
>>+ * dpll_device_alloc - allocate memory for a new dpll_device object
>>+ * @ops: pointer to dpll operations structure
>>+ * @type: type of a dpll being allocated
>>+ * @cookie: a system unique number for a device
>>+ * @dev_driver_idx: index of dpll device on parent device
>>+ * @priv: private data of a registerer
>>+ * @parent: device structure of a module registering dpll device
>>+ *
>>+ * Allocate memory for a new dpll and initialize it with its type, name,
>>+ * callbacks and private data pointer.
>>+ *
>>+ * Name is generated based on: cookie, type and dev_driver_idx.
>>+ * Finding allocated and registered dpll device is also possible with
>>+ * the: cookie, type and dev_driver_idx. This way dpll device can be
>>+ * shared by multiple instances of a device driver.
>>+ *
>>+ * Returns:
>>+ * * pointer to initialized dpll - success
>>+ * * NULL - memory allocation fail
>>+ */
>>+struct dpll_device
>>+*dpll_device_alloc(struct dpll_device_ops *ops, enum dpll_type type,
>>+		   const u8 cookie[DPLL_COOKIE_LEN], u8 dev_driver_idx,
>>+		   void *priv, struct device *parent);
>>+
>>+/**
>>+ * dpll_device_register - registers allocated dpll
>>+ * @dpll: pointer to dpll
>>+ *
>>+ * Register the dpll on the dpll subsystem, make it available for netlin=
k
>>+ * API users.
>>+ */
>>+void dpll_device_register(struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_device_unregister - unregister registered dpll
>>+ * @dpll: pointer to dpll
>>+ *
>>+ * Unregister the dpll from the subsystem, make it unavailable for
>netlink
>>+ * API users.
>>+ */
>>+void dpll_device_unregister(struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_device_free - free dpll memory
>>+ * @dpll: pointer to dpll
>>+ *
>>+ * Free memory allocated with ``dpll_device_alloc(..)``
>>+ */
>>+void dpll_device_free(struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_priv - get private data
>>+ * @dpll: pointer to dpll
>>+ *
>>+ * Obtain private data pointer passed to dpll subsystem when allocating
>>+ * device with ``dpll_device_alloc(..)``
>>+ */
>>+void *dpll_priv(struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_pin_priv - get private data
>>+ * @dpll: pointer to dpll
>>+ *
>>+ * Obtain private pin data pointer passed to dpll subsystem when pin
>>+ * was registered with dpll.
>>+ */
>>+void *dpll_pin_priv(struct dpll_device *dpll, struct dpll_pin *pin);
>>+
>>+/**
>>+ * dpll_pin_idx - get pin idx
>>+ * @dpll: pointer to dpll
>>+ * @pin: pointer to a pin
>>+ *
>>+ * Obtain pin index of given pin on given dpll.
>>+ *
>>+ * Return: PIN_IDX_INVALID - if failed to find pin, otherwise pin index
>>+ */
>>+u32 dpll_pin_idx(struct dpll_device *dpll, struct dpll_pin *pin);
>>+
>>+
>>+/**
>>+ * dpll_shared_pin_register - share a pin between dpll devices
>>+ * @dpll_pin_owner: a dpll already registered with a pin
>>+ * @dpll: a dpll being registered with a pin
>>+ * @pin_idx: index of a pin on dpll device (@dpll_pin_owner)
>>+ *	     that is being registered on new dpll (@dpll)
>>+ * @ops: struct with pin ops callbacks
>>+ * @priv: private data pointer passed when calling callback ops
>>+ *
>>+ * Register a pin already registered with different dpll device.
>>+ * Allow to share a single pin within multiple dpll instances.
>>+ *
>>+ * Returns:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+int
>>+dpll_shared_pin_register(struct dpll_device *dpll_pin_owner,
>>+			 struct dpll_device *dpll, u32 pin_idx,
>>+			 struct dpll_pin_ops *ops, void *priv);
>>+
>>+/**
>>+ * dpll_pin_alloc - allocate memory for a new dpll_pin object
>>+ * @description: pointer to string description of a pin with max length
>>+ * equal to PIN_DESC_LEN
>>+ * @desc_len: number of chars in description
>>+ *
>>+ * Allocate memory for a new pin and initialize its resources.
>>+ *
>>+ * Returns:
>>+ * * pointer to initialized pin - success
>>+ * * NULL - memory allocation fail
>>+ */
>>+struct dpll_pin *dpll_pin_alloc(const char *description, size_t
>desc_len);
>>+
>>+
>>+/**
>>+ * dpll_pin_register - register pin with a dpll device
>>+ * @dpll: pointer to dpll object to register pin with
>>+ * @pin: pointer to allocated pin object being registered with dpll
>>+ * @ops: struct with pin ops callbacks
>>+ * @priv: private data pointer passed when calling callback ops
>>+ *
>>+ * Register previously allocated pin object with a dpll device.
>>+ *
>>+ * Return:
>>+ * * 0 - if pin was registered with a parent pin,
>>+ * * -ENOMEM - failed to allocate memory,
>>+ * * -EEXIST - pin already registered with this dpll,
>>+ * * -EBUSY - couldn't allocate id for a pin.
>>+ */
>>+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		      struct dpll_pin_ops *ops, void *priv);
>>+
>>+/**
>>+ * dpll_pin_deregister - deregister pin from a dpll device
>>+ * @dpll: pointer to dpll object to deregister pin from
>>+ * @pin: pointer to allocated pin object being deregistered from dpll
>>+ *
>>+ * Deregister previously registered pin object from a dpll device.
>>+ *
>>+ * Return:
>>+ * * 0 - pin was successfully deregistered from this dpll device,
>>+ * * -ENXIO - given pin was not registered with this dpll device,
>>+ * * -EINVAL - pin pointer is not valid.
>>+ */
>>+int dpll_pin_deregister(struct dpll_device *dpll, struct dpll_pin *pin);
>>+
>>+/**
>>+ * dpll_pin_free - free memory allocated for a pin
>>+ * @pin: pointer to allocated pin object being freed
>>+ *
>>+ * Shared pins must be deregistered from all dpll devices before freeing
>them,
>>+ * otherwise the memory won't be freed.
>>+ */
>>+void dpll_pin_free(struct dpll_pin *pin);
>>+
>>+/**
>>+ * dpll_muxed_pin_register - register a pin to a muxed-type pin
>>+ * @parent_pin: pointer to object to register pin with
>>+ * @pin: pointer to allocated pin object being deregistered from dpll
>>+ * @ops: struct with pin ops callbacks
>>+ * @priv: private data pointer passed when calling callback ops*
>>+ *
>>+ * In case of multiplexed pins, allows registring them under a single
>>+ * parent pin.
>>+ *
>>+ * Return:
>>+ * * 0 - if pin was registered with a parent pin,
>>+ * * -ENOMEM - failed to allocate memory,
>>+ * * -EEXIST - pin already registered with this parent pin,
>>+ * * -EBUSY - couldn't assign id for a pin.
>>+ */
>>+int dpll_muxed_pin_register(struct dpll_device *dpll,
>>+			    struct dpll_pin *parent_pin, struct dpll_pin *pin,
>>+			    struct dpll_pin_ops *ops, void *priv);
>>+/**
>>+ * dpll_device_get_by_cookie - find a dpll by its cookie
>>+ * @cookie: cookie of dpll to search for, as given by driver on
>>+ *	    ``dpll_device_alloc``
>>+ * @type: type of dpll, as given by driver on ``dpll_device_alloc``
>>+ * @idx: index of dpll, as given by driver on ``dpll_device_alloc``
>>+ *
>>+ * Allows multiple driver instances using one physical DPLL to find
>>+ * and share already registered DPLL device.
>>+ *
>>+ * Return: pointer if device was found, NULL otherwise.
>>+ */
>>+struct dpll_device *dpll_device_get_by_cookie(u8 cookie[DPLL_COOKIE_LEN]=
,
>>+					      enum dpll_type type, u8 idx);
>>+
>>+/**
>>+ * dpll_pin_get_by_description - find a pin by its description
>>+ * @dpll: dpll device pointer
>>+ * @description: string description of pin
>>+ *
>>+ * Allows multiple driver instances using one physical DPLL to find
>>+ * and share pin already registered with existing dpll device.
>>+ *
>>+ * Return: pointer if pin was found, NULL otherwise.
>>+ */
>>+struct dpll_pin *dpll_pin_get_by_description(struct dpll_device *dpll,
>>+					     const char *description);
>>+
>>+/**
>>+ * dpll_pin_get_by_idx - find a pin by its index
>>+ * @dpll: dpll device pointer
>>+ * @idx: index of pin
>>+ *
>>+ * Allows multiple driver instances using one physical DPLL to find
>>+ * and share pin already registered with existing dpll device.
>>+ *
>>+ * Return: pointer if pin was found, NULL otherwise.
>>+ */
>>+struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, int idx);
>>+
>>+int dpll_notify_device_change(struct dpll_device *dpll,
>>+			      enum dpll_event_change event,
>>+			      struct dpll_pin *pin);
>>+#endif
>>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>>new file mode 100644
>>index 000000000000..16278618d59d
>>--- /dev/null
>>+++ b/include/uapi/linux/dpll.h
>>@@ -0,0 +1,263 @@
>>+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>+#ifndef _UAPI_LINUX_DPLL_H
>>+#define _UAPI_LINUX_DPLL_H
>>+
>>+#define DPLL_NAME_LEN		32
>>+#define DPLL_DESC_LEN		20
>>+#define PIN_DESC_LEN		20
>>+
>>+/* Adding event notification support elements */
>>+#define DPLL_FAMILY_NAME		"dpll"
>>+#define DPLL_VERSION			0x01
>>+#define DPLL_MONITOR_GROUP_NAME		"monitor"
>>+
>>+#define DPLL_DUMP_FILTER_PINS	1
>>+#define DPLL_DUMP_FILTER_STATUS	2
>>+
>>+/* dplla - Attributes of dpll generic netlink family
>>+ *
>>+ * @DPLLA_UNSPEC - invalid attribute
>>+ * @DPLLA_ID - ID of a dpll device (unsigned int)
>>+ * @DPLLA_NAME - human-readable name (char array of DPLL_NAME_LENGTH
>size)
>>+ * @DPLLA_MODE - working mode of dpll (enum dpll_mode)
>>+ * @DPLLA_MODE_SUPPORTED - list of supported working modes (enum
>dpll_mode)
>>+ * @DPLLA_SOURCE_PIN_ID - ID of source pin selected to drive dpll
>>+ *	(unsigned int)
>>+ * @DPLLA_LOCK_STATUS - dpll's lock status (enum dpll_lock_status)
>>+ * @DPLLA_TEMP - dpll's temperature (signed int - Celsius degrees)
>>+ * @DPLLA_DUMP_FILTER - filter bitmask (int, sum of DPLL_DUMP_FILTER_*
>defines)
>>+ * @DPLLA_NETIFINDEX - related network interface index
>>+ * @DPLLA_PIN - nested attribute, each contains single pin attributes
>>+ * @DPLLA_PIN_IDX - index of a pin on dpll (unsigned int)
>>+ * @DPLLA_PIN_DESCRIPTION - human-readable pin description provided by
>driver
>>+ *	(char array of PIN_DESC_LEN size)
>>+ * @DPLLA_PIN_TYPE - current type of a pin (enum dpll_pin_type)
>>+ * @DPLLA_PIN_TYPE_SUPPORTED - pin types supported (enum dpll_pin_type)
>>+ * @DPLLA_PIN_SIGNAL_TYPE - current type of a signal
>>+ *	(enum dpll_pin_signal_type)
>>+ * @DPLLA_PIN_SIGNAL_TYPE_SUPPORTED - pin signal types supported
>>+ *	(enum dpll_pin_signal_type)
>>+ * @DPLLA_PIN_CUSTOM_FREQ - freq value for
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ
>>+ *	(unsigned int)
>>+ * @DPLLA_PIN_STATE - state of pin's capabilities (enum dpll_pin_state)
>>+ * @DPLLA_PIN_STATE_SUPPORTED - available pin's capabilities
>>+ *	(enum dpll_pin_state)
>>+ * @DPLLA_PIN_PRIO - priority of a pin on dpll (unsigned int)
>>+ * @DPLLA_PIN_PARENT_IDX - if of a parent pin (unsigned int)
>>+ * @DPLLA_CHANGE_TYPE - type of device change event
>>+ *	(enum dpll_change_type)
>>+ * @DPLLA_PIN_NETIFINDEX - related network interface index for the pin
>>+ **/
>>+enum dplla {
>>+	DPLLA_UNSPEC,
>>+	DPLLA_ID,
>>+	DPLLA_NAME,
>>+	DPLLA_MODE,
>>+	DPLLA_MODE_SUPPORTED,
>>+	DPLLA_SOURCE_PIN_IDX,
>>+	DPLLA_LOCK_STATUS,
>>+	DPLLA_TEMP,
>>+	DPLLA_DUMP_FILTER,
>>+	DPLLA_NETIFINDEX,
>>+	DPLLA_PIN,
>>+	DPLLA_PIN_IDX,
>>+	DPLLA_PIN_DESCRIPTION,
>>+	DPLLA_PIN_TYPE,
>>+	DPLLA_PIN_TYPE_SUPPORTED,
>>+	DPLLA_PIN_SIGNAL_TYPE,
>>+	DPLLA_PIN_SIGNAL_TYPE_SUPPORTED,
>>+	DPLLA_PIN_CUSTOM_FREQ,
>>+	DPLLA_PIN_STATE,
>>+	DPLLA_PIN_STATE_SUPPORTED,
>>+	DPLLA_PIN_PRIO,
>>+	DPLLA_PIN_PARENT_IDX,
>>+	DPLLA_CHANGE_TYPE,
>>+	DPLLA_PIN_NETIFINDEX,
>>+	__DPLLA_MAX,
>>+};
>>+
>>+#define DPLLA_MAX (__DPLLA_MAX - 1)
>>+
>>+/* dpll_lock_status - DPLL status provides information of device status
>>+ *
>>+ * @DPLL_LOCK_STATUS_UNSPEC - unspecified value
>>+ * @DPLL_LOCK_STATUS_UNLOCKED - dpll was not yet locked to any valid (or
>is in
>>+ *	DPLL_MODE_FREERUN/DPLL_MODE_NCO modes)
>>+ * @DPLL_LOCK_STATUS_CALIBRATING - dpll is trying to lock to a valid
>signal
>>+ * @DPLL_LOCK_STATUS_LOCKED - dpll is locked
>>+ * @DPLL_LOCK_STATUS_HOLDOVER - dpll is in holdover state - lost a valid
>lock
>>+ *	or was forced by DPLL_MODE_HOLDOVER mode)
>>+ **/
>>+enum dpll_lock_status {
>>+	DPLL_LOCK_STATUS_UNSPEC,
>>+	DPLL_LOCK_STATUS_UNLOCKED,
>>+	DPLL_LOCK_STATUS_CALIBRATING,
>>+	DPLL_LOCK_STATUS_LOCKED,
>>+	DPLL_LOCK_STATUS_HOLDOVER,
>
>Good.
>
>
>>+
>>+	__DPLL_LOCK_STATUS_MAX,
>>+};
>>+
>>+#define DPLL_LOCK_STATUS_MAX (__DPLL_LOCK_STATUS_MAX - 1)
>>+
>>+/* dpll_pin_type - signal types
>>+ *
>>+ * @DPLL_PIN_TYPE_UNSPEC - unspecified value
>>+ * @DPLL_PIN_TYPE_MUX - mux type pin, aggregates selectable pins
>
>As I wrote in the reply to the cover letter, I don't think we should
>have this.
>

For now leaving.

>
>>+ * @DPLL_PIN_TYPE_EXT - external source
>
>Why "source" ? It could be an output too.
>
>
>>+ * @DPLL_PIN_TYPE_SYNCE_ETH_PORT - ethernet port PHY's recovered clock
>>+ * @DPLL_PIN_TYPE_INT_OSCILLATOR - device internal oscillator
>
>I don't follow why this is a PIN. It is internal clock of DPLL. It
>should not be exposed as a pin.
>

May be a good point, I am leaving it but let Vadim or Jakub confirm it is
not needed for them.
In ice dpll doesn't have internal oscillator, as it is located externally t=
o
dpll. But at the same time we don't expose this pin to the user.

>
>>+ * @DPLL_PIN_TYPE_GNSS - GNSS recovered clock
>>+ **/
>>+enum dpll_pin_type {
>>+	DPLL_PIN_TYPE_UNSPEC,
>>+	DPLL_PIN_TYPE_MUX,
>>+	DPLL_PIN_TYPE_EXT,
>>+	DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>+	DPLL_PIN_TYPE_INT_OSCILLATOR,
>>+	DPLL_PIN_TYPE_GNSS,
>>+
>>+	__DPLL_PIN_TYPE_MAX,
>>+};
>>+
>>+#define DPLL_PIN_TYPE_MAX (__DPLL_PIN_TYPE_MAX - 1)
>>+
>>+/* dpll_pin_signal_type - signal types
>>+ *
>>+ * @DPLL_PIN_SIGNAL_TYPE_UNSPEC - unspecified value
>>+ * @DPLL_PIN_SIGNAL_TYPE_1_PPS - a 1Hz signal
>>+ * @DPLL_PIN_SIGNAL_TYPE_10_MHZ - a 10 MHz signal
>>+ * @DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ - custom frequency signal, value
>defined
>>+ *	with pin's DPLLA_PIN_SIGNAL_TYPE_CUSTOM_FREQ attribute
>>+ **/
>>+enum dpll_pin_signal_type {
>>+	DPLL_PIN_SIGNAL_TYPE_UNSPEC,
>>+	DPLL_PIN_SIGNAL_TYPE_1_PPS,
>
>1HZ
>
>>+	DPLL_PIN_SIGNAL_TYPE_10_MHZ,
>
>10000000Hz

IMHO it is better now.

>
>>+	DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ,
>
>XHz
>
>Why don't we have this at all? There could be just u64 ATTR that carries
>frequency in Hz.
>

May be a good point, but again let the other say the word.

>
>We are missing signal type for SYNCE_ETH_PORT pin type. Is it supposed
>to be DPLL_PIN_SIGNAL_TYPE_UNSPEC? I think it might be if we stick with
>having this enum.
>

I would say DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ, or we can add something new.

>
>>+
>>+	__DPLL_PIN_SIGNAL_TYPE_MAX,
>>+};
>>+
>>+#define DPLL_PIN_SIGNAL_TYPE_MAX (__DPLL_PIN_SIGNAL_TYPE_MAX - 1)
>>+
>>+/* dpll_pin_state - available pin states
>>+ *
>>+ * @DPLL_PIN_STATE_UNSPEC - unspecified value
>>+ * @DPLL_PIN_STATE_CONNECTED - pin connected
>>+ * @DPLL_PIN_STATE_DISCONNECTED - pin disconnected
>>+ * @DPLL_PIN_STATE_SOURCE - pin used as an input pin
>>+ * @DPLL_PIN_STATE_OUTPUT - pin used as an output pin
>>+ **/
>>+enum dpll_pin_state {
>>+	DPLL_PIN_STATE_UNSPEC,
>>+	DPLL_PIN_STATE_CONNECTED,
>>+	DPLL_PIN_STATE_DISCONNECTED,
>>+	DPLL_PIN_STATE_SOURCE,
>>+	DPLL_PIN_STATE_OUTPUT,
>
>The pin can be "connected" and "source" at the same time. How do you
>expose that. I think we should remove "connected and just have:
>	DPLL_PIN_STATE_DISCONNECTED,
>	DPLL_PIN_STATE_SOURCE,
>	DPLL_PIN_STATE_OUTPUT,

Userspace will get stream of attributes with the same id:
   DPLLA_PIN_IDX=3D19
        DPLLA_PIN_DESCRIPTION=3DC827_0-RCLKA-3
        DPLLA_PIN_TYPE=3D3
        DPLLA_PIN_PARENT_IDX=3D2
        DPLLA_PIN_SIGNAL_TYPE=3D3
        DPLLA_PIN_SIGNAL_TYPE_SUPPORTED=3D3
        DPLLA_PIN_STATE=3D1
        DPLLA_PIN_STATE=3D3
        DPLLA_PIN_STATE_SUPPORTED=3D1
        DPLLA_PIN_STATE_SUPPORTED=3D2
        DPLLA_PIN_STATE_SUPPORTED=3D3

>
>"state" also sound odd here, as it is not really a state. It is a "mode"
>of a pin which is controlled by the user. Could you call it "MODE"?
>

Sure, seems legit. will try.

>
>
>>+
>>+	__DPLL_PIN_STATE_MAX,
>>+};
>>+
>>+#define DPLL_PIN_STATE_MAX (__DPLL_PIN_STATE_MAX - 1)
>>+
>>+/**
>>+ * dpll_event - Events of dpll generic netlink family
>>+ *
>>+ * @DPLL_EVENT_UNSPEC - invalid event type
>>+ * @DPLL_EVENT_DEVICE_CREATE - dpll device created
>>+ * @DPLL_EVENT_DEVICE_DELETE - dpll device deleted
>>+ * @DPLL_EVENT_DEVICE_CHANGE - attribute of dpll device or pin changed
>>+ **/
>>+enum dpll_event {
>>+	DPLL_EVENT_UNSPEC,
>>+	DPLL_EVENT_DEVICE_CREATE,
>>+	DPLL_EVENT_DEVICE_DELETE,
>>+	DPLL_EVENT_DEVICE_CHANGE,
>>+
>>+	__DPLL_EVENT_MAX,
>>+};
>>+
>>+#define DPLL_EVENT_MAX (__DPLL_EVENT_MAX - 1)
>>+
>>+/**
>>+ * dpll_change_type - values of events in case of device change event
>>+ * (DPLL_EVENT_DEVICE_CHANGE)
>>+ *
>>+ * @DPLL_CHANGE_UNSPEC - invalid event type
>>+ * @DPLL_CHANGE_MODE - mode changed
>>+ * @DPLL_CHANGE_LOCK_STATUS - lock status changed
>>+ * @DPLL_CHANGE_SOURCE_PIN - source pin changed,
>>+ * @DPLL_CHANGE_TEMP - temperature changed
>>+ * @DPLL_CHANGE_PIN_ADD - source pin added,
>>+ * @DPLL_CHANGE_PIN_DEL - source pin deleted,
>>+ * @DPLL_CHANGE_PIN_TYPE - pin type cahnged,
>>+ * @DPLL_CHANGE_PIN_SIGNAL_TYPE pin signal type changed
>>+ * @DPLL_CHANGE_PIN_CUSTOM_FREQ custom frequency changed
>>+ * @DPLL_CHANGE_PIN_STATE - pin state changed
>>+ * @DPLL_CHANGE_PIN_PRIO - pin prio changed
>>+ **/
>>+enum dpll_event_change {
>>+	DPLL_CHANGE_UNSPEC,
>>+	DPLL_CHANGE_MODE,
>>+	DPLL_CHANGE_LOCK_STATUS,
>>+	DPLL_CHANGE_SOURCE_PIN,
>>+	DPLL_CHANGE_TEMP,
>>+	DPLL_CHANGE_PIN_ADD,
>>+	DPLL_CHANGE_PIN_DEL,
>>+	DPLL_CHANGE_PIN_TYPE,
>>+	DPLL_CHANGE_PIN_SIGNAL_TYPE,
>>+	DPLL_CHANGE_PIN_CUSTOM_FREQ,
>>+	DPLL_CHANGE_PIN_STATE,
>>+	DPLL_CHANGE_PIN_PRIO,
>
>I think it is odd to have this. With every future added attribute, you
>are going to add a value here as well. Basically you have 1:1
>relationship.
>
>I have to say I didn't see this concept in any other netlink usecase.
>Did you?
>
>Why exactly do you need it? Userspace usually maintains the internal
>object instance anyway, it can compare incoming message with that.
>

Heven't looked for it.
If there is no other opinion we can remove most of them.

>
>
>>+
>>+	__DPLL_CHANGE_MAX,
>>+};
>>+
>>+#define DPLL_CHANGE_MAX (__DPLL_CHANGE_MAX - 1)
>>+
>>+/**
>>+ * dpll_cmd - Commands supported by the dpll generic netlink family
>>+ *
>>+ * @DPLL_CMD_UNSPEC - invalid message type
>>+ * @DPLL_CMD_DEVICE_GET - Get list of dpll devices (dump) or attributes
>of
>>+ *	single dpll device and it's pins
>>+ * @DPLL_CMD_DEVICE_SET - Set attributes for a dpll
>>+ * @DPLL_CMD_PIN_SET - Set attributes for a pin
>>+ **/
>>+enum dpll_cmd {
>>+	DPLL_CMD_UNSPEC,
>>+	DPLL_CMD_DEVICE_GET,
>>+	DPLL_CMD_DEVICE_SET,
>>+	DPLL_CMD_PIN_SET,
>>+
>>+	__DPLL_CMD_MAX,
>>+};
>>+
>>+#define DPLL_CMD_MAX (__DPLL_CMD_MAX - 1)
>>+
>>+/**
>>+ * dpll_mode - Working-modes a dpll can support. Modes differentiate how
>>+ * dpll selects one of its sources to syntonize with a source.
>>+ *
>>+ * @DPLL_MODE_UNSPEC - invalid
>>+ * @DPLL_MODE_FORCED - source can be only selected by sending a request
>to dpll
>
>I would probably go rather for "MODE_MANUAL". "forced" does not sound
>correct there.
>

Sure.

>
>>+ * @DPLL_MODE_AUTOMATIC - highest prio, valid source, auto selected by
>dpll
>>+ * @DPLL_MODE_HOLDOVER - dpll forced into holdover mode
>
>Well, when user sets this, he basically tells the device to freerun.
>What would be different between setting this and DPLL_MODE_FREERUN?
>

We took it from ZL80032 specification:
In freerun the dpll is not doing any synchronization with any reference inp=
uts,
output signal is based on the device's system clock frequency offset only.
The freerun accuracy of the output clock is equal to the accuracy of the sy=
stem
clock.

HOLDOVER (actually FORCED HOLDOVER) is possible when there was a valid sign=
al
and after requesting this mode: references are ignored and the DPLL must go=
 to
holdover (at the frequency offset of the most recent selected reference)

>
>>+ * @DPLL_MODE_FREERUN - dpll driven on system clk, no holdover available
>>+ * @DPLL_MODE_NCO - dpll driven by Numerically Controlled Oscillator
>
>I'm clueless what this is. Isn't this Freerun too?

NCO is a freerun but it possible to control frequency, user can request
different frequency than the one of the system clock.


Thanks,
Arkadiusz
>
>
>>+ **/
>>+enum dpll_mode {
>>+	DPLL_MODE_UNSPEC,
>>+	DPLL_MODE_FORCED,
>>+	DPLL_MODE_AUTOMATIC,
>>+	DPLL_MODE_HOLDOVER,
>>+	DPLL_MODE_FREERUN,
>>+	DPLL_MODE_NCO,
>>+
>>+	__DPLL_MODE_MAX,
>>+};
>>+
>>+#define DPLL_MODE_MAX (__DPLL_MODE_MAX - 1)
>>+
>>+#endif /* _UAPI_LINUX_DPLL_H */
>>--
>>2.27.0
>>
