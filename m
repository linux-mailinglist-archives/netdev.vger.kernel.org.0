Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192976405C8
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiLBL1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiLBL1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:27:40 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6B2EBA;
        Fri,  2 Dec 2022 03:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669980456; x=1701516456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WXIE26D4q2xTrsSyvmLgYrZLvz/l/y7HZsHCj11NU1s=;
  b=HDgi1bMF9QC/oaStDsljMduOerHp8cTHylg5VO9m2GoTiniIh2tnnAQn
   gamTOQOmmi/LS20ArYt2PC8gPSodpDPOCcQV0DzB7UuzRKlY3BVEI8JtL
   VKEAAITZTXs1r3WpWp9NnVj7HcK3j0Rg7p12KpO+5pCTBTGQIGdoJpjOk
   1dmJieCJnE/p+9h+zQbRP8lYWfTeMdKwi5mKFKnN6FzwiIz3W6O25Ova0
   fO/rr2cpdFnS+wn5ZKVPOsTimlrgEtvthdLejJl/V9LrtwXIOS6j9Frx9
   6JrdrW7JgI7Jsz81A6tbO8b6XRHdkohr+rqBEoA/GKKUlOpz+lulhUFGC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317794242"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="317794242"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 03:27:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638726064"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="638726064"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 02 Dec 2022 03:27:35 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 03:27:35 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 03:27:35 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 03:27:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NH0a60X1OI23sXjSBE1WHOpbKJPCAuGpSUvFE8uT/pdWJZMfkN3NdUoPClUhrcCtB9jyU4Vs/1j/kuSdQjwCjsGrvhKUdQvi2TsIbwpUMgKo3a4k6CTDKV9yBSD5NY5S8jysNCcp9iRc6JL5J8976g41TssDOqM3Ec+tZw2uBy5gyLnktOzdyAuSFgb91ukyKZ8EBdLT3yNGLmaTYMizp2TlQwlCJTB6X1HIiU+S6Nyz5IWDQ044zq3t0Jy1fa2LCyVTM7laMa3Objj4OgzpcNm8CU+rS/pckoytoT+t/eeJg1idBgrN3DGoijRWmZ4YguUCN8BiO/gKXVdl7K3Nnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwxQtlYMDMUjpVvgfk//i3Q5Vj6pIAyMGuQIbbBrGuQ=;
 b=AKIFvdD6cpIYUXZ4vTZ3ktBXMejeTRjRiHFpoQoUqUiEm17l6tJ79k3iKlZ3UyT8itSzkvFh4VybmRx3b88rq3O08IOPggF/DiMzkQ8MsUkdrht3SESaA6/cw+qjGHqSPGbvJpGBtwQbONTGXfFkPr1+VQz7ejkgl+kRmq/uluctp/cY04ikOe9sb/xHszu2+N2awML2SNkHKP0k7aGlmyBDnWddE+S98wC78CysUrl9vgdahIhEXsWyBJLYxb0wgCcwJ9CTj1lk1m77LKBmN74eUP0gDYZr7Hddxl0YzmfrhEWU15MEALtrRDbAevcseHH38n3Iabo45bQtLPc/vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DS7PR11MB7806.namprd11.prod.outlook.com (2603:10b6:8:db::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.10; Fri, 2 Dec 2022 11:27:32 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 11:27:32 +0000
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
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Thread-Topic: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Thread-Index: AQHZBDry/jNi33oty0uFzAsT01mIf65XaZgAgAMHnuA=
Date:   Fri, 2 Dec 2022 11:27:32 +0000
Message-ID: <DM6PR11MB4657D9753412AD9DEE7FAB7D9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-5-vfedorenko@novek.ru> <Y4dPaHx1kT3A80n/@nanopsycho>
In-Reply-To: <Y4dPaHx1kT3A80n/@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DS7PR11MB7806:EE_
x-ms-office365-filtering-correlation-id: 0ac2486d-7215-4cb0-aed9-08dad458342c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jb/62a1DEjzsv3GLjOfhaRxyrHIiOvBD9micTPdH0/r5F2gMZRopXbO/AgmlXxuXxfczUcPz6F0HHDemnL2ClTnVZBqylbmRIlu91ImT0SRoAyrhdjvlZ8lA2TebUuwu3VtV15rqyjZ9fMxmuPQbhzkdclEswVQJkF9eQy07s6a3IET3Kitb1Iky8F5lHAXpGkOBo/nqAePrkZ/vFuikpLP/xyRM3PcgOQXRVdQ7AfClQknMXwJa2oJ6DfryJ08oxXFGtxG9777NzHSFukZs0v2JnQDLB7vWMwIef9Eds4T9ZHloFWGdwi8L0DpB7UgZuAM4oOmNYF7HmIvMoF/i6AN/tz5jMuNm+VMml2yrbOyokfnIo2yC3GarZyj6BYZAW6bTEzvhuVAKNav16LAZ5eEiguZ+Bp84MAzG5K+LGSOMEFKA5MMfc22WBvs3Oa+5Az+TW3nClQ5YTIwXTKR/QWno9gxfdFFK9o61tiwWYx+HoSB3NBrmEG371sxTAjQhrlUW1GhrXDJKvDsmMmMd9IwpYfsvryUHOmB9cZgM83zdt9d2R0bmgSgXjIskhxk0KJIuITQigLkp6iLR275p+CQ7+Yh3kUF1SlrlNOW/QbgDbRBXt8tHkN7kX5e/Xc8sZ+GOpNvyhWgoXfRfthjlNR4p2PAIW82UzQGhnlGoXyV42meM+m+s1EEXbQgtICYAkiJCAjEhUC+2mb1vEIThww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199015)(26005)(186003)(66446008)(71200400001)(6506007)(7696005)(8676002)(66476007)(64756008)(66556008)(66946007)(478600001)(4326008)(41300700001)(5660300002)(52536014)(8936002)(83380400001)(2906002)(76116006)(122000001)(82960400001)(9686003)(316002)(86362001)(54906003)(110136005)(38100700002)(33656002)(55016003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uoIsu/WZaec+ByBeKu13nUSvK1VTtiCnUJJLce4ColBoDe6qHeR6kyjQ6wsC?=
 =?us-ascii?Q?L/5RxzR501odrIKbCB2+Gk537JHOlcoxfidC4HcIGslT4mMtN6dkzmvMVfVE?=
 =?us-ascii?Q?5+hz888ELdTLASinRmEzUIowIguMAkc3eDzDhGawq+tn1wwBpdsLJet5vFxr?=
 =?us-ascii?Q?pZ8puYujPbXCsrpJH7I93bOIn+tT4xeijw68BZf2grKu9pU79ft78LCkiFmq?=
 =?us-ascii?Q?ibpiXUnR7PgHVDjVdUp/W5YTJprpidh9vg1Xxg7lOtweR9D5yN6MThaRCKcy?=
 =?us-ascii?Q?JCK1LaV5+tbbwUINyyqRKTFUQn5jVbg5Jr11Zfnf3U/HH1k+2+gIvjMCE3DF?=
 =?us-ascii?Q?+6Oe0EkfgKrfEwp00QSLlvFnuDRUQq0bk0MWMd34vuPvFOQ42lFsYSuMi9nE?=
 =?us-ascii?Q?cvfU2CQGYurrnVCtg0pqUNxcIRXi1q8B+Bcsro1xENf/XuRVtohia6tlbgqQ?=
 =?us-ascii?Q?dPr+ls3tzlgOHcH1g9DTjtKSo0bi4EAIIu7vHe66bfYWkUwc2gWHa9agNGs1?=
 =?us-ascii?Q?6dhaZxUp91y+Q7KS2WFIiHABBUrT1r77zHUCUQW3oeXcCx7s3t0eHPUasrEx?=
 =?us-ascii?Q?1BFXNexk4V9ljtobAi36tzDQrN74RwOGJ4wR1pL/vGk6gU3bbQ8lOddIECGs?=
 =?us-ascii?Q?jvloqiu961IWsB6883qftH6IJq7t8dNARCsJpzq6HyMeJshLegBCGfGcShHW?=
 =?us-ascii?Q?/6DCN7nCJuZaxVKZ0xPyfPOTvDKJbu+uP5yJ1aO4tUa5RiKX4sSOw8q6BfFs?=
 =?us-ascii?Q?L/XJqSvQElaVmZDfsoSJdkmj4gePNZ/IFDNbm/BE40QqWVzX/ke+qe5OuV2B?=
 =?us-ascii?Q?xpnFlwLpog7/0+/RcOQICEvQbhxjnsRDKeG7kcZtD2EMMUJI3GV6APqG4OHd?=
 =?us-ascii?Q?7TeLXhiG1L3x5Ef4qKOnCa8H2yaQekv35HzFV6rIGjZ2KOG8ZQdIZigD14ij?=
 =?us-ascii?Q?Vl8kiutcby1wUxUeLOywJCXhcQp4ZLMfd47VbeG3kpkOfFfP31XA1tA9jCf9?=
 =?us-ascii?Q?w4bAXZiAn9iZGOYmskJsay98yAN8ozOZSZC12odKQTzw/JAHFcstODAAi0l3?=
 =?us-ascii?Q?Pv2iFJsreQs1reC1a21B226HT6ucyf5g1jCTwpVf/w847Mz+xHwAnHQJtazh?=
 =?us-ascii?Q?suZ9e8AVxsq2GMLSE6SE0+nfWgnIpUiUcK8GfQO0P5va00LM8tKJyFGp9sFu?=
 =?us-ascii?Q?RJJzz+G85UqzDXln799qEfzR+thCILbof69TGBSszwAbZpME7+ceey9htQ9r?=
 =?us-ascii?Q?957LtRU9gSJa+HWDZke/mz3io7zQSxJdjRsAnFMgBKhtXf+yB48hF4yOG+WN?=
 =?us-ascii?Q?TY5RVUrtrqqHod1CwymOHabSe5WkuctnRsr6t0b8xFLKNT7S9ykAjDvGzg17?=
 =?us-ascii?Q?A7QU8lM5ygC/IEaVY7VlHAf5OBAobHzvCCHFsDfaGAETUWM3v0qzAGx4Cxts?=
 =?us-ascii?Q?BUV4CBEZbQpt6rVjCOG06wPEvBhZrTc7sgxovjDKMAtNZfUSHvMoR6KO/9KS?=
 =?us-ascii?Q?DSKi+708lb9LqYr2iquhoqB2Gf653LpIsisFuZVl4WxZlLpC9y3B1bTzFqfH?=
 =?us-ascii?Q?py+mkGVBA50GnQ1dHQXheAMBPn/Dyz9zG16dfMfBVoHYoekTo7MdnZDTdgjr?=
 =?us-ascii?Q?QQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac2486d-7215-4cb0-aed9-08dad458342c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 11:27:32.3744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jIZx/H+WYMRbWOK+5UQZ+lzwHcQNh6qA7qzJpnZw7dWyBcRqdhlQZB2eTkW5mJ/PAmGQ/49HNPWLlumEknwq1O9VgEwXAIDoGdhE9hsY+J4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7806
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Wednesday, November 30, 2022 1:41 PM
>
>Tue, Nov 29, 2022 at 10:37:24PM CET, vfedorenko@novek.ru wrote:
>>From: Vadim Fedorenko <vadfed@fb.com>
>>
>>Implement basic DPLL operations in ptp_ocp driver as the
>>simplest example of using new subsystem.
>>
>>Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>>---
>> drivers/ptp/Kconfig   |   1 +
>> drivers/ptp/ptp_ocp.c | 123 +++++++++++++++++++++++++++++-------------
>> 2 files changed, 87 insertions(+), 37 deletions(-)
>>
>>diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
>>index fe4971b65c64..8c4cfabc1bfa 100644
>>--- a/drivers/ptp/Kconfig
>>+++ b/drivers/ptp/Kconfig
>>@@ -177,6 +177,7 @@ config PTP_1588_CLOCK_OCP
>> 	depends on COMMON_CLK
>> 	select NET_DEVLINK
>> 	select CRC16
>>+	select DPLL
>> 	help
>> 	  This driver adds support for an OpenCompute time card.
>>
>>diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
>>index 154d58cbd9ce..605853ac4a12 100644
>>--- a/drivers/ptp/ptp_ocp.c
>>+++ b/drivers/ptp/ptp_ocp.c
>>@@ -23,6 +23,8 @@
>> #include <linux/mtd/mtd.h>
>> #include <linux/nvmem-consumer.h>
>> #include <linux/crc16.h>
>>+#include <linux/dpll.h>
>>+#include <uapi/linux/dpll.h>
>>
>> #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
>> #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
>>@@ -353,6 +355,7 @@ struct ptp_ocp {
>> 	struct ptp_ocp_signal	signal[4];
>> 	struct ptp_ocp_sma_connector sma[4];
>> 	const struct ocp_sma_op *sma_op;
>>+	struct dpll_device *dpll;
>> };
>>
>> #define OCP_REQ_TIMESTAMP	BIT(0)
>>@@ -835,18 +838,19 @@ static DEFINE_IDR(ptp_ocp_idr);
>> struct ocp_selector {
>> 	const char *name;
>> 	int value;
>>+	int dpll_type;
>> };
>>
>> static const struct ocp_selector ptp_ocp_clock[] =3D {
>>-	{ .name =3D "NONE",	.value =3D 0 },
>>-	{ .name =3D "TOD",	.value =3D 1 },
>>-	{ .name =3D "IRIG",	.value =3D 2 },
>>-	{ .name =3D "PPS",	.value =3D 3 },
>>-	{ .name =3D "PTP",	.value =3D 4 },
>>-	{ .name =3D "RTC",	.value =3D 5 },
>>-	{ .name =3D "DCF",	.value =3D 6 },
>>-	{ .name =3D "REGS",	.value =3D 0xfe },
>>-	{ .name =3D "EXT",	.value =3D 0xff },
>>+	{ .name =3D "NONE",	.value =3D 0,		.dpll_type =3D 0 },
>>+	{ .name =3D "TOD",	.value =3D 1,		.dpll_type =3D 0 },
>>+	{ .name =3D "IRIG",	.value =3D 2,		.dpll_type =3D 0 },
>>+	{ .name =3D "PPS",	.value =3D 3,		.dpll_type =3D 0 },
>>+	{ .name =3D "PTP",	.value =3D 4,		.dpll_type =3D 0 },
>>+	{ .name =3D "RTC",	.value =3D 5,		.dpll_type =3D 0 },
>>+	{ .name =3D "DCF",	.value =3D 6,		.dpll_type =3D 0 },
>>+	{ .name =3D "REGS",	.value =3D 0xfe,		.dpll_type =3D 0 },
>>+	{ .name =3D "EXT",	.value =3D 0xff,		.dpll_type =3D 0 },
>> 	{ }
>> };
>>
>>@@ -855,37 +859,37 @@ static const struct ocp_selector ptp_ocp_clock[] =
=3D {
>> #define SMA_SELECT_MASK		GENMASK(14, 0)
>>
>> static const struct ocp_selector ptp_ocp_sma_in[] =3D {
>>-	{ .name =3D "10Mhz",	.value =3D 0x0000 },
>>-	{ .name =3D "PPS1",	.value =3D 0x0001 },
>>-	{ .name =3D "PPS2",	.value =3D 0x0002 },
>>-	{ .name =3D "TS1",	.value =3D 0x0004 },
>>-	{ .name =3D "TS2",	.value =3D 0x0008 },
>>-	{ .name =3D "IRIG",	.value =3D 0x0010 },
>>-	{ .name =3D "DCF",	.value =3D 0x0020 },
>>-	{ .name =3D "TS3",	.value =3D 0x0040 },
>>-	{ .name =3D "TS4",	.value =3D 0x0080 },
>>-	{ .name =3D "FREQ1",	.value =3D 0x0100 },
>>-	{ .name =3D "FREQ2",	.value =3D 0x0200 },
>>-	{ .name =3D "FREQ3",	.value =3D 0x0400 },
>>-	{ .name =3D "FREQ4",	.value =3D 0x0800 },
>>-	{ .name =3D "None",	.value =3D SMA_DISABLE },
>>+	{ .name =3D "10Mhz",	.value =3D 0x0000,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_10_MHZ },
>>+	{ .name =3D "PPS1",	.value =3D 0x0001,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_1_PPS },
>>+	{ .name =3D "PPS2",	.value =3D 0x0002,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_1_PPS },
>>+	{ .name =3D "TS1",	.value =3D 0x0004,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "TS2",	.value =3D 0x0008,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "IRIG",	.value =3D 0x0010,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "DCF",	.value =3D 0x0020,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "TS3",	.value =3D 0x0040,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "TS4",	.value =3D 0x0080,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "FREQ1",	.value =3D 0x0100,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "FREQ2",	.value =3D 0x0200,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "FREQ3",	.value =3D 0x0400,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "FREQ4",	.value =3D 0x0800,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "None",	.value =3D SMA_DISABLE,	.dpll_type =3D 0 },
>> 	{ }
>> };
>>
>> static const struct ocp_selector ptp_ocp_sma_out[] =3D {
>>-	{ .name =3D "10Mhz",	.value =3D 0x0000 },
>>-	{ .name =3D "PHC",	.value =3D 0x0001 },
>>-	{ .name =3D "MAC",	.value =3D 0x0002 },
>>-	{ .name =3D "GNSS1",	.value =3D 0x0004 },
>>-	{ .name =3D "GNSS2",	.value =3D 0x0008 },
>>-	{ .name =3D "IRIG",	.value =3D 0x0010 },
>>-	{ .name =3D "DCF",	.value =3D 0x0020 },
>>-	{ .name =3D "GEN1",	.value =3D 0x0040 },
>>-	{ .name =3D "GEN2",	.value =3D 0x0080 },
>>-	{ .name =3D "GEN3",	.value =3D 0x0100 },
>>-	{ .name =3D "GEN4",	.value =3D 0x0200 },
>>-	{ .name =3D "GND",	.value =3D 0x2000 },
>>-	{ .name =3D "VCC",	.value =3D 0x4000 },
>>+	{ .name =3D "10Mhz",	.value =3D 0x0000,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_10_MHZ },
>>+	{ .name =3D "PHC",	.value =3D 0x0001,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "MAC",	.value =3D 0x0002,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "GNSS1",	.value =3D 0x0004,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_1_PPS },
>>+	{ .name =3D "GNSS2",	.value =3D 0x0008,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_1_PPS },
>>+	{ .name =3D "IRIG",	.value =3D 0x0010,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "DCF",	.value =3D 0x0020,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "GEN1",	.value =3D 0x0040,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "GEN2",	.value =3D 0x0080,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "GEN3",	.value =3D 0x0100,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "GEN4",	.value =3D 0x0200,	.dpll_type =3D
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>>+	{ .name =3D "GND",	.value =3D 0x2000,	.dpll_type =3D 0 },
>>+	{ .name =3D "VCC",	.value =3D 0x4000,	.dpll_type =3D 0 },
>> 	{ }
>> };
>>
>>@@ -4175,12 +4179,41 @@ ptp_ocp_detach(struct ptp_ocp *bp)
>> 	device_unregister(&bp->dev);
>> }
>>
>>+static int ptp_ocp_dpll_get_attr(struct dpll_device *dpll, struct
>dpll_attr *attr)
>>+{
>>+	struct ptp_ocp *bp =3D (struct ptp_ocp *)dpll_priv(dpll);
>>+	int sync;
>>+
>>+	sync =3D ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>>+	dpll_attr_lock_status_set(attr, sync ? DPLL_LOCK_STATUS_LOCKED :
>DPLL_LOCK_STATUS_UNLOCKED);
>
>get,set,confuse. This attr thing sucks, sorry :/

Once again, I feel obligated to add some explanations :)

getter is ops called by dpll subsystem, it requires data, so here value sha=
ll
be set for the caller, right?
Also have explained the reason why this attr struct and functions are done =
this
way in the response to cover letter concerns.

>
>
>>+
>>+	return 0;
>>+}
>>+
>>+static int ptp_ocp_dpll_pin_get_attr(struct dpll_device *dpll, struct
>dpll_pin *pin,
>>+				     struct dpll_pin_attr *attr)
>>+{
>>+	dpll_pin_attr_type_set(attr, DPLL_PIN_TYPE_EXT);
>
>This is exactly what I was talking about in the cover letter. This is
>const, should be put into static struct and passed to
>dpll_device_alloc().

Actually this type or some other parameters might change in the run-time,
depends on the device, it is up to the driver how it will handle any getter=
,
if driver knows it won't change it could also have some static member and c=
opy
the data with: dpll_pin_attr_copy(...);

>
>
>>+	return 0;
>>+}
>>+
>>+static struct dpll_device_ops dpll_ops =3D {
>>+	.get	=3D ptp_ocp_dpll_get_attr,
>>+};
>>+
>>+static struct dpll_pin_ops dpll_pin_ops =3D {
>>+	.get	=3D ptp_ocp_dpll_pin_get_attr,
>>+};
>>+
>> static int
>> ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>> {
>>+	const u8 dpll_cookie[DPLL_COOKIE_LEN] =3D { "OCP" };
>>+	char pin_desc[PIN_DESC_LEN];
>> 	struct devlink *devlink;
>>+	struct dpll_pin *pin;
>> 	struct ptp_ocp *bp;
>>-	int err;
>>+	int err, i;
>>
>> 	devlink =3D devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev-
>>dev);
>> 	if (!devlink) {
>>@@ -4230,6 +4263,20 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct
>pci_device_id *id)
>>
>> 	ptp_ocp_info(bp);
>> 	devlink_register(devlink);
>>+
>>+	bp->dpll =3D dpll_device_alloc(&dpll_ops, DPLL_TYPE_PPS, dpll_cookie,
>pdev->bus->number, bp, &pdev->dev);
>>+	if (!bp->dpll) {
>>+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>>+		goto out;
>>+	}
>>+	dpll_device_register(bp->dpll);
>
>You still have the 2 step init process. I believe it would be better to
>just have dpll_device_create/destroy() to do it in one shot.

For me either is ok, but due to pins alloc/register as explained below I wo=
uld
leave it as it is.

>
>
>>+
>>+	for (i =3D 0; i < 4; i++) {
>>+		snprintf(pin_desc, PIN_DESC_LEN, "sma%d", i + 1);
>>+		pin =3D dpll_pin_alloc(pin_desc, PIN_DESC_LEN);
>>+		dpll_pin_register(bp->dpll, pin, &dpll_pin_ops, bp);
>
>Same here, no point of having 2 step init.

The alloc of a pin is not required if the pin already exist and would be ju=
st
registered with another dpll.
Once we decide to entirely drop shared pins idea this could be probably don=
e,
although other kernel code usually use this twostep approach?

>
>
>>+	}
>>+
>> 	return 0;
>
>
>Btw, did you consider having dpll instance here as and auxdev? It would
>be suitable I believe. It is quite simple to do it. See following patch
>as an example:

I haven't think about it, definetly gonna take a look to see if there any
benefits in ice.

Thanks,
Arkadiusz

>
>commit bd02fd76d1909637c95e8ef13e7fd1e748af910d
>Author: Jiri Pirko <jiri@nvidia.com>
>Date:   Mon Jul 25 10:29:17 2022 +0200
>
>    mlxsw: core_linecards: Introduce per line card auxiliary device
>
>
>
>
>>
>> out:
>>@@ -4247,6 +4294,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
>> 	struct ptp_ocp *bp =3D pci_get_drvdata(pdev);
>> 	struct devlink *devlink =3D priv_to_devlink(bp);
>>
>>+	dpll_device_unregister(bp->dpll);
>>+	dpll_device_free(bp->dpll);
>> 	devlink_unregister(devlink);
>> 	ptp_ocp_detach(bp);
>> 	pci_disable_device(pdev);
>>--
>>2.27.0
>>
