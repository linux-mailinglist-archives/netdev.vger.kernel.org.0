Return-Path: <netdev+bounces-8601-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D15FC724BB8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:48:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DB2E1C20B00
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E85A1ED5C;
	Tue,  6 Jun 2023 18:48:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759EF125CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:48:21 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF89F1712;
	Tue,  6 Jun 2023 11:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686077293; x=1717613293;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=24RMT1VqXUfw/tG/Q3j0Ks2VFnPGCmw6OgfXodgLXSY=;
  b=fXiGV8KMtebF0kcsBDsFKJ806TFSoA2GNledv6h9la6vbZRBZG/tA+3z
   9/v1mi4HLCOj+uj53bj0v83KjdqVzXvHWGadx8MrYGSAT24gX/wi/O/GZ
   EwyWwwIq2eM7BubOccRaTxd+9t29esnLJ9mLeL2OhYuAkupRlz4WKGMU+
   IQ9VzujJK12dTIeXygzdYwz2aDYv6Sdfu3G6ZzOPFMGwgZR2Cxqyn0F8e
   QpBT4VplneQZk9XtrQoSw8Il5bZdqYrc1oR1CYKcyiHKYyMldEQHKcUA9
   dTUifZPWeAX1CLMcqJzClGsi2Eo0SezFNey+nvIPkT9Hk53u8hIDy9l5v
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="360092253"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="360092253"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 11:48:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="686646319"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="686646319"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 06 Jun 2023 11:47:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 11:47:59 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 11:47:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 11:47:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 11:47:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONquOOs0P52qE0d67lm3CDnQBg0k4IYCaahuit+mgOjPjUJ1ep8DQzkvY+RAndMaPB0vjsHfqWROkZq1gUM31rTTqJJVYZDlj0psLq1w85muyi92qOc5MfgxjMeCbh9IRVkmopTAyKYiz4RLbvhnfdt4Sf5CN8XBmbSfoP8OKg0SYVu/wamSd91XRKJJeCPdnKHAB0QL1nSb4gaZv2Hskc9jCazvE8to3EEYmeYlda55sGXbJJwNik5JO96jEPT0CO+RPWrOHqVKJFkgPybl9OZhUDJcxTOBB8tEHD6IaQI1R6KBt7vvmyhg5nMVE1bPW/yAHjbieoFDUYfkrK5kuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IIdRK2AxhBP8EZtvthokcq26OkfwJBJ4itthDHTOZ8k=;
 b=oABvaQHrIF6RRvy9nGE70xEK3dDk+HfMuYowYTJzHHtnJOZhoUdsf8Jmj8D9P5GCLSBGeS8HkPEP/1M56wiwD/EQV2afeWZ3Wun3xhFIuOAsvNyvUsOZkIUtp/IH2RcEjHMESJrvMdwVExlVKkWMjQV1YUtrSy93sPDLuoDvY/wK7NdYwY18L0lvGqA31oZyDZ0HgBPAt+jRlPftsl/e0b/izPu9cUJQPYi2rRyOjMHYw6jS21YKiUdiAmY+HyhIcA6Qwr+fKsPnQlWdiwWGh93gR2fLyaUUM9U73psrgvWA010CsgArMkMut34L0Jl8xVUOe7WKXee4851TyA8nZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 LV2PR11MB5998.namprd11.prod.outlook.com (2603:10b6:408:17e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 18:47:53 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 18:47:53 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC: Jakub Kicinski <kuba@kernel.org>, Jonathan Lemon
	<jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, "Olech, Milena"
	<milena.olech@intel.com>, "Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Index: AQHZeWdERHWnlPmo9kOdLErcTLxvj69HJWEAgDc2ZsA=
Date: Tue, 6 Jun 2023 18:47:53 +0000
Message-ID: <DM6PR11MB46572BFDAAA78170AB4809539B52A@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-3-vadfed@meta.com> <ZFEuYEqZwJZ+aApI@nanopsycho>
In-Reply-To: <ZFEuYEqZwJZ+aApI@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|LV2PR11MB5998:EE_
x-ms-office365-filtering-correlation-id: 4f2f54d8-8936-4134-cb26-08db66be8946
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ulSPo+kEQ2x4Z4cciqBohT/j1brrT01PjeZUQrwzkWffqxI4Iop4bM2P4yINcEENnTGtYfgZSpJGOpYuNH0OVaIJ1Kt0/qxm9uQnk458YuNPkCkUZvQfG4/B8NY+yGbY7iJ76Multz3jh7kDoH4iegL+XfB/+06pnpPpfrpQvDeyyqw5QMAnZu9Axs2GnYyIVfli9Bm6pxmaFNw1p8qSkj4fM15i1Wjai/zkUIB4/gaL+A2EZ6qcuEpJ1DmJ1usUAG85isfqim57ZJJkbuAJa+Fcha95unXh+uXQRHgnYZIuV2WcCkhnPMOp4GGtgzVea1Wssf83M3Uqms+D/U8HV3IAIzlXcs6vC5exjI9pw971ltog7RcE3eX6JpswGU14r62t5LLp4yCCfLwNhwqZLKwuehop11rIiVUQzZo+wrTYettJcbkDchE/sKA9TpHSSxbAOjO/CgbaLwjooqT2CGtMtNOWlB+7X3o8jIBEOFfJF6j2gPdBrcC7fNQDJ7EwrhJ1tA3l9ZOikTrUV+TdMgcfYofiwVXZF/64Lm8SV12YpT4DtAeIBkgFNP+u0Iwp+Bnu8UE+x4h6At/XdPZYvk3wX0bCDO3Y4CtvC9r/w8dj0KnRX86rxUpPGNwrRkK1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199021)(86362001)(5660300002)(52536014)(186003)(26005)(71200400001)(110136005)(6506007)(9686003)(30864003)(2906002)(8936002)(316002)(7416002)(55016003)(8676002)(33656002)(41300700001)(38070700005)(4326008)(122000001)(38100700002)(82960400001)(76116006)(66946007)(66476007)(64756008)(66556008)(54906003)(7696005)(66446008)(478600001)(83380400001)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gKIPu92xjz97wMZWL+TTIn9CJxD3NRZq/HJG777JhWQsHU07XUF3Qy73p40U?=
 =?us-ascii?Q?QsQlsxSut9lOhfXdhqKOfuVLaMRJK3n2zd45tW8se7/l44qNY5IpO+ovQTRv?=
 =?us-ascii?Q?9EqcZ4psW8YTjLrM2y4oUJT5UfgxRNKkdyzfp7PBrAFqXR6iAnljDGeRS374?=
 =?us-ascii?Q?OtAipfgX8qUrDGBXrAprPqF2n5AREhfGa2Pv0VRiENy8pzxbHqxFEdHcoqjV?=
 =?us-ascii?Q?ToYgjJcLsgp+5yPUOp2aGloBHlxty4p6zXuHvHEAorDWM4lFpGceYKk9D0D7?=
 =?us-ascii?Q?/8tT/dI7+gne92RgVpPnYhdHJucSodbrPNSbc2Bse4dexMV2XuMIs9MXashz?=
 =?us-ascii?Q?MQ1iwQpYNg9fI4Ts1V3EfOGk9kOEXQ76tBTIRuXzv/xlNtj8rlVnKmi52fqa?=
 =?us-ascii?Q?eoCH7daWsRx7RcTq26Xd8u32t1XUBRyBOrlUSvvWW2gl38hEkehDKhdwS7a0?=
 =?us-ascii?Q?HD1ln6Qfvt5QlJJR6czNTnFk1hELZeAV/W0wH/8WciYkjF9aUxJ2EYwribbC?=
 =?us-ascii?Q?eOFOIUtQPt8LOUnaeY/JNW6Fw2cwQaxrdqMoyPCT48jQ+l93TvgumZ6OsQEV?=
 =?us-ascii?Q?FVeAYbC9V4J70aPZd2GK30/ebrxTFMCfuBsxzXZnmRL7p2bAKGgu6X58yZR3?=
 =?us-ascii?Q?zD8Ng47lpXcSPz0V2FI8GANkCjGTtsVEqXxBa2yoRkjkq3i/eWFaKLPSNZDB?=
 =?us-ascii?Q?0HcXbFaS/Oem4C/AHmqlqavLHysvlXcSMGgLLJFYuVC5HkqWW5IX7iV91DPM?=
 =?us-ascii?Q?3gQV8Jlkdrxd239tUMh486I/4cG3t9W/EZttrZeBI0iYl1k6cyGmgSsB7D3d?=
 =?us-ascii?Q?zVRqxgInoFksfW02NqcPXBdbQJSEMjqJKQHWrvq0sw0rB3mbIWoyYD1FGlaR?=
 =?us-ascii?Q?raihNXaKdgRrAyy0YZ5wZ7ST4t3f/FYk49SBIVshw5sQvHHn7YnDyjayUNz8?=
 =?us-ascii?Q?1u1Mt95QbUYbLeST+2K/eiS93MpgzhloTV2+yk5F4a3lq9imrYe7kCjcNtTx?=
 =?us-ascii?Q?aVp4GSlYJxpC9oucqmgfW7tH8drVejkU/nVz65aVgQhvq5NYv7qGhehbIyQg?=
 =?us-ascii?Q?jt8q1YjxlhXF7qz9FjLoH/Hs5VcWvEYs1YsjN6mMe48YnZFJCbeCg7LNihD8?=
 =?us-ascii?Q?qk2I2WG8NeM3rqZ0GRBM1ywqPlcon52x5VtC90ajB7NCuUwCejMRJ1zbur8A?=
 =?us-ascii?Q?ITaP0H7TvS1Jh3SNbGT+Hv5k/evjPgGFbi7JrYoX/n809ARUr2JUDMKlQuXZ?=
 =?us-ascii?Q?jyEmNqeS16XXJ1ccst3gqm0+pMfwZxByHvbUacm8xds8Fl5r5gRuF1zKg6EY?=
 =?us-ascii?Q?WQYKZaB+l2Rw7badgLb6wd44AGSEjmabZmKZXaAzasN8LleBHPviYhhNlNMI?=
 =?us-ascii?Q?BCAoecAUqkz9c+5qKh1I0xQXnFR9HIHOVU+ObyRB6+9101BLzNXazBtJ2FHP?=
 =?us-ascii?Q?aiQafcQx5NpCMJUDvZkiatlkTa/K/mjaRL+OLgTHdoOTx2pH3neeRNO1AXIQ?=
 =?us-ascii?Q?KSDl5Uh/QgUZLFRCjm0S4vvZ/co9wCNOIEo6oLLL6k4X00Yzq6axb52EtrqV?=
 =?us-ascii?Q?y2i0XFwaIz88fTaeJsOKcmK+6l/hjrkXSRYOTlgfuwQ4AFauNLTOwQ2Loh0C?=
 =?us-ascii?Q?ZA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f2f54d8-8936-4134-cb26-08db66be8946
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 18:47:53.5752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vVmRDb2ONCxBU2vZyjiBppch603eNsJ2sEnvyMs6pFbf9N/ezlP9wnUupOwLah3EPomGKLuFsi/ePJArg+UikWVWMB7AobmuzZ7WsWvsjbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5998
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, May 2, 2023 5:38 PM
>
>Fri, Apr 28, 2023 at 02:20:03AM CEST, vadfed@meta.com wrote:
>>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
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
>>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>>---
>> MAINTAINERS                 |   8 +
>> drivers/Kconfig             |   2 +
>> drivers/Makefile            |   1 +
>> drivers/dpll/Kconfig        |   7 +
>> drivers/dpll/Makefile       |  10 +
>> drivers/dpll/dpll_core.c    | 939 ++++++++++++++++++++++++++++++++++
>> drivers/dpll/dpll_core.h    | 113 +++++
>> drivers/dpll/dpll_netlink.c | 972 ++++++++++++++++++++++++++++++++++++
>> drivers/dpll/dpll_netlink.h |  27 +
>> include/linux/dpll.h        | 274 ++++++++++
>> include/uapi/linux/dpll.h   |   2 +
>> 11 files changed, 2355 insertions(+)
>> create mode 100644 drivers/dpll/Kconfig
>> create mode 100644 drivers/dpll/Makefile
>> create mode 100644 drivers/dpll/dpll_core.c
>> create mode 100644 drivers/dpll/dpll_core.h
>> create mode 100644 drivers/dpll/dpll_netlink.c
>> create mode 100644 drivers/dpll/dpll_netlink.h
>> create mode 100644 include/linux/dpll.h
>>
>>diff --git a/MAINTAINERS b/MAINTAINERS
>>index ebd26b3ca90e..710976c0737e 100644
>>--- a/MAINTAINERS
>>+++ b/MAINTAINERS
>>@@ -6302,6 +6302,14 @@ F:
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
>>index 968bd0a6fd78..453df9e1210d 100644
>>--- a/drivers/Kconfig
>>+++ b/drivers/Kconfig
>>@@ -241,4 +241,6 @@ source "drivers/peci/Kconfig"
>>
>> source "drivers/hte/Kconfig"
>>
>>+source "drivers/dpll/Kconfig"
>>+
>> endmenu
>>diff --git a/drivers/Makefile b/drivers/Makefile
>>index 20b118dca999..9ffb554507ef 100644
>>--- a/drivers/Makefile
>>+++ b/drivers/Makefile
>>@@ -194,3 +194,4 @@ obj-$(CONFIG_MOST)		+=3D most/
>> obj-$(CONFIG_PECI)		+=3D peci/
>> obj-$(CONFIG_HTE)		+=3D hte/
>> obj-$(CONFIG_DRM_ACCEL)		+=3D accel/
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
>>index 000000000000..803bb5db7793
>>--- /dev/null
>>+++ b/drivers/dpll/Makefile
>>@@ -0,0 +1,10 @@
>>+# SPDX-License-Identifier: GPL-2.0
>>+#
>>+# Makefile for DPLL drivers.
>>+#
>>+
>>+obj-$(CONFIG_DPLL)      +=3D dpll.o
>>+dpll-y                  +=3D dpll_core.o
>>+dpll-y                  +=3D dpll_netlink.o
>>+dpll-y                  +=3D dpll_nl.o
>>+
>>diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>>new file mode 100644
>>index 000000000000..8a2370740026
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_core.c
>>@@ -0,0 +1,939 @@
>>+// SPDX-License-Identifier: GPL-2.0
>>+/*
>>+ *  dpll_core.c - Generic DPLL Management class support.
>>+ *
>>+ *  Copyright (c) 2023 Meta Platforms, Inc. and affiliates
>>+ *  Copyright (c) 2023 Intel Corporation.
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
>>+DEFINE_MUTEX(dpll_xa_lock);
>
>Why this is called "xa_lock"? It protects much more than that. Call it
>dpll_big_lock while you are at it.
>

Sure, renamed to dpll_lock.

>
>>+
>>+DEFINE_XARRAY_FLAGS(dpll_device_xa, XA_FLAGS_ALLOC);
>>+DEFINE_XARRAY_FLAGS(dpll_pin_xa, XA_FLAGS_ALLOC);
>>+
>>+#define ASSERT_DPLL_REGISTERED(d) \
>>+	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>>+#define ASSERT_DPLL_NOT_REGISTERED(d) \
>>+	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>>+
>>+/**
>>+ * dpll_device_get_by_id - find dpll device by it's id
>>+ * @id: id of searched dpll
>>+ *
>>+ * Return:
>>+ * * dpll_device struct if found
>>+ * * NULL otherwise
>>+ */
>>+struct dpll_device *dpll_device_get_by_id(int id)
>>+{
>>+	if (xa_get_mark(&dpll_device_xa, id, DPLL_REGISTERED))
>>+		return xa_load(&dpll_device_xa, id);
>>+
>>+	return NULL;
>>+}
>>+
>>+/**
>>+ * dpll_device_get_by_name - find dpll device by it's id
>
>"by name" instead of "by id" ?
>

Function was removed.

>
>>+ * @bus_name: bus name of searched dpll
>>+ * @dev_name: dev name of searched dpll
>>+ *
>>+ * Return:
>>+ * * dpll_device struct if found
>>+ * * NULL otherwise
>>+ */
>>+struct dpll_device *
>>+dpll_device_get_by_name(const char *bus_name, const char *device_name)
>>+{
>>+	struct dpll_device *dpll, *ret =3D NULL;
>>+	unsigned long i;
>>+
>>+	xa_for_each_marked(&dpll_device_xa, i, dpll, DPLL_REGISTERED) {
>>+		if (!strcmp(dev_bus_name(&dpll->dev), bus_name) &&
>>+		    !strcmp(dev_name(&dpll->dev), device_name)) {
>>+			ret =3D dpll;
>>+			break;
>>+		}
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static struct dpll_pin_registration *
>>+dpll_pin_registration_find(struct dpll_pin_ref *ref,
>>+			   const struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	struct dpll_pin_registration *reg;
>>+
>>+	list_for_each_entry(reg, &ref->registration_list, list) {
>>+		if (reg->ops =3D=3D ops && reg->priv =3D=3D priv)
>>+			return reg;
>>+	}
>>+	return NULL;
>>+}
>>+
>>+/**
>>+ * dpll_xa_ref_pin_add - add pin reference to a given xarray
>>+ * @xa_pins: dpll_pin_ref xarray holding pins
>>+ * @pin: pin being added
>>+ * @ops: ops for a pin
>>+ * @priv: pointer to private data of owner
>>+ *
>>+ * Allocate and create reference of a pin and enlist a registration
>>+ * structure storing ops and priv pointers of a caller registant.
>>+ *
>>+ * Return:
>>+ * * 0 on success
>>+ * * -ENOMEM on failed allocation
>>+ */
>>+static int
>>+dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
>>+		    const struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	struct dpll_pin_registration *reg;
>>+	struct dpll_pin_ref *ref;
>>+	bool ref_exists =3D false;
>>+	unsigned long i;
>>+	int ret;
>>+
>>+	xa_for_each(xa_pins, i, ref) {
>>+		if (ref->pin !=3D pin)
>>+			continue;
>>+		reg =3D dpll_pin_registration_find(ref, ops, priv);
>>+		if (reg) {
>>+			refcount_inc(&ref->refcount);
>>+			return 0;
>>+		}
>>+		ref_exists =3D true;
>>+		break;
>>+	}
>>+
>>+	if (!ref_exists) {
>>+		ref =3D kzalloc(sizeof(*ref), GFP_KERNEL);
>>+		if (!ref)
>>+			return -ENOMEM;
>>+		ref->pin =3D pin;
>>+		INIT_LIST_HEAD(&ref->registration_list);
>>+		ret =3D xa_insert(xa_pins, pin->pin_idx, ref, GFP_KERNEL);
>>+		if (ret) {
>>+			kfree(ref);
>>+			return ret;
>>+		}
>>+		refcount_set(&ref->refcount, 1);
>>+	}
>>+
>>+	reg =3D kzalloc(sizeof(*reg), GFP_KERNEL);
>>+	if (!reg) {
>>+		if (!ref_exists)
>>+			kfree(ref);
>>+		return -ENOMEM;
>>+	}
>>+	reg->ops =3D ops;
>>+	reg->priv =3D priv;
>>+	if (ref_exists)
>>+		refcount_inc(&ref->refcount);
>>+	list_add_tail(&reg->list, &ref->registration_list);
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * dpll_xa_ref_pin_del - remove reference of a pin from xarray
>>+ * @xa_pins: dpll_pin_ref xarray holding pins
>>+ * @pin: pointer to a pin
>>+ *
>>+ * Decrement refcount of existing pin reference on given xarray.
>>+ * If all registrations are lifted delete the reference and free its mem=
ory.
>>+ *
>>+ * Return:
>>+ * * 0 on success
>>+ * * -EINVAL if reference to a pin was not found
>>+ */
>>+static int dpll_xa_ref_pin_del(struct xarray *xa_pins, struct dpll_pin *=
pin,
>>+			       const struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	struct dpll_pin_registration *reg;
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long i;
>>+
>>+	xa_for_each(xa_pins, i, ref) {
>>+		if (ref->pin !=3D pin)
>>+			continue;
>>+		reg =3D dpll_pin_registration_find(ref, ops, priv);
>>+		if (WARN_ON(!reg))
>>+			return -EINVAL;
>>+		if (refcount_dec_and_test(&ref->refcount)) {
>>+			list_del(&reg->list);
>>+			kfree(reg);
>>+			xa_erase(xa_pins, i);
>>+			WARN_ON(!list_empty(&ref->registration_list));
>>+			kfree(ref);
>>+		}
>>+		return 0;
>>+	}
>>+
>>+	return -EINVAL;
>>+}
>>+
>>+/**
>>+ * dpll_xa_ref_dpll_add - add dpll reference to a given xarray
>>+ * @xa_dplls: dpll_pin_ref xarray holding dplls
>>+ * @dpll: dpll being added
>>+ * @ops: pin-reference ops for a dpll
>>+ * @priv: pointer to private data of owner
>>+ *
>>+ * Allocate and create reference of a dpll-pin ops or increase refcount
>>+ * on existing dpll reference on given xarray.
>>+ *
>>+ * Return:
>>+ * * 0 on success
>>+ * * -ENOMEM on failed allocation
>>+ */
>>+static int
>>+dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
>>+		     const struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	struct dpll_pin_registration *reg;
>>+	struct dpll_pin_ref *ref;
>>+	bool ref_exists =3D false;
>>+	unsigned long i;
>>+	int ret;
>>+
>>+	xa_for_each(xa_dplls, i, ref) {
>>+		if (ref->dpll !=3D dpll)
>>+			continue;
>>+		reg =3D dpll_pin_registration_find(ref, ops, priv);
>>+		if (reg) {
>>+			refcount_inc(&ref->refcount);
>>+			return 0;
>>+		}
>>+		ref_exists =3D true;
>>+		break;
>>+	}
>>+
>>+	if (!ref_exists) {
>>+		ref =3D kzalloc(sizeof(*ref), GFP_KERNEL);
>>+		if (!ref)
>>+			return -ENOMEM;
>>+		ref->dpll =3D dpll;
>>+		INIT_LIST_HEAD(&ref->registration_list);
>>+		ret =3D xa_insert(xa_dplls, dpll->device_idx, ref, GFP_KERNEL);
>>+		if (ret) {
>>+			kfree(ref);
>>+			return ret;
>>+		}
>>+		refcount_set(&ref->refcount, 1);
>>+	}
>>+
>>+	reg =3D kzalloc(sizeof(*reg), GFP_KERNEL);
>>+	if (!reg) {
>>+		if (!ref_exists)
>>+			kfree(ref);
>>+		return -ENOMEM;
>>+	}
>>+	reg->ops =3D ops;
>>+	reg->priv =3D priv;
>>+	if (ref_exists)
>>+		refcount_inc(&ref->refcount);
>>+	list_add_tail(&reg->list, &ref->registration_list);
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * dpll_xa_ref_dpll_del - remove reference of a dpll from xarray
>>+ * @xa_dplls: dpll_pin_ref xarray holding dplls
>>+ * @dpll: pointer to a dpll to remove
>>+ *
>>+ * Decrement refcount of existing dpll reference on given xarray.
>>+ * If all references are dropped, delete the reference and free its memo=
ry.
>>+ */
>>+static void
>>+dpll_xa_ref_dpll_del(struct xarray *xa_dplls, struct dpll_device *dpll,
>>+		     const struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	struct dpll_pin_registration *reg;
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long i;
>>+
>>+	xa_for_each(xa_dplls, i, ref) {
>>+		if (ref->dpll !=3D dpll)
>>+			continue;
>>+		reg =3D dpll_pin_registration_find(ref, ops, priv);
>>+		if (WARN_ON(!reg))
>>+			return;
>>+		if (refcount_dec_and_test(&ref->refcount)) {
>>+			list_del(&reg->list);
>>+			kfree(reg);
>>+			xa_erase(xa_dplls, i);
>>+			WARN_ON(!list_empty(&ref->registration_list));
>>+			kfree(ref);
>>+		}
>>+		return;
>>+	}
>>+}
>>+
>>+/**
>>+ * dpll_xa_ref_dpll_find - find dpll reference on xarray
>>+ * @xa_dplls: dpll_pin_ref xarray holding dplls
>>+ * @dpll: pointer to a dpll
>>+ *
>>+ * Search for dpll-pin ops reference struct of a given dpll on given xar=
ray.
>>+ *
>>+ * Return:
>>+ * * pin reference struct pointer on success
>>+ * * NULL - reference to a pin was not found
>>+ */
>>+struct dpll_pin_ref *
>>+dpll_xa_ref_dpll_find(struct xarray *xa_refs, const struct dpll_device *=
dpll)
>>+{
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long i;
>>+
>>+	xa_for_each(xa_refs, i, ref) {
>>+		if (ref->dpll =3D=3D dpll)
>>+			return ref;
>>+	}
>>+
>>+	return NULL;
>>+}
>>+
>>+struct dpll_pin_ref *dpll_xa_ref_dpll_first(struct xarray *xa_refs)
>>+{
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long i =3D 0;
>>+
>>+	ref =3D xa_find(xa_refs, &i, ULONG_MAX, XA_PRESENT);
>>+	WARN_ON(!ref);
>>+	return ref;
>>+}
>>+
>>+/**
>>+ * dpll_device_alloc - allocate the memory for dpll device
>>+ * @clock_id: clock_id of creator
>>+ * @device_idx: id given by dev driver
>>+ * @module: reference to registering module
>>+ *
>>+ * Allocates memory and initialize dpll device, hold its reference on gl=
obal
>>+ * xarray.
>>+ *
>>+ * Return:
>>+ * * dpll_device struct pointer if succeeded
>>+ * * ERR_PTR(X) - failed allocation
>>+ */
>>+static struct dpll_device *
>>+dpll_device_alloc(const u64 clock_id, u32 device_idx, struct module *mod=
ule)
>>+{
>>+	struct dpll_device *dpll;
>>+	int ret;
>>+
>>+	dpll =3D kzalloc(sizeof(*dpll), GFP_KERNEL);
>>+	if (!dpll)
>>+		return ERR_PTR(-ENOMEM);
>>+	refcount_set(&dpll->refcount, 1);
>>+	INIT_LIST_HEAD(&dpll->registration_list);
>>+	dpll->device_idx =3D device_idx;
>>+	dpll->clock_id =3D clock_id;
>>+	dpll->module =3D module;
>>+	ret =3D xa_alloc(&dpll_device_xa, &dpll->id, dpll, xa_limit_16b,
>>+		       GFP_KERNEL);
>>+	if (ret) {
>>+		kfree(dpll);
>>+		return ERR_PTR(ret);
>>+	}
>>+	xa_init_flags(&dpll->pin_refs, XA_FLAGS_ALLOC);
>>+
>>+	return dpll;
>>+}
>>+
>>+/**
>>+ * dpll_device_get - find existing or create new dpll device
>>+ * @clock_id: clock_id of creator
>>+ * @device_idx: idx given by device driver
>>+ * @module: reference to registering module
>>+ *
>>+ * Get existing object of a dpll device, unique for given arguments.
>>+ * Create new if doesn't exist yet.
>>+ *
>>+ * Return:
>>+ * * valid dpll_device struct pointer if succeeded
>>+ * * ERR_PTR of an error
>>+ */
>>+struct dpll_device *
>>+dpll_device_get(u64 clock_id, u32 device_idx, struct module *module)
>>+{
>>+	struct dpll_device *dpll, *ret =3D NULL;
>>+	unsigned long index;
>>+
>>+	mutex_lock(&dpll_xa_lock);
>>+	xa_for_each(&dpll_device_xa, index, dpll) {
>>+		if (dpll->clock_id =3D=3D clock_id &&
>>+		    dpll->device_idx =3D=3D device_idx &&
>>+		    dpll->module =3D=3D module) {
>>+			ret =3D dpll;
>>+			refcount_inc(&ret->refcount);
>>+			break;
>>+		}
>>+	}
>>+	if (!ret)
>>+		ret =3D dpll_device_alloc(clock_id, device_idx, module);
>>+	mutex_unlock(&dpll_xa_lock);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_get);
>>+
>>+/**
>>+ * dpll_device_put - decrease the refcount and free memory if possible
>>+ * @dpll: dpll_device struct pointer
>>+ *
>>+ * Drop reference for a dpll device, if all references are gone, delete
>>+ * dpll device object.
>>+ */
>>+void dpll_device_put(struct dpll_device *dpll)
>>+{
>>+	if (!dpll)
>>+		return;
>>+	mutex_lock(&dpll_xa_lock);
>>+	if (refcount_dec_and_test(&dpll->refcount)) {
>>+		ASSERT_DPLL_NOT_REGISTERED(dpll);
>>+		WARN_ON_ONCE(!xa_empty(&dpll->pin_refs));
>>+		xa_destroy(&dpll->pin_refs);
>>+		xa_erase(&dpll_device_xa, dpll->id);
>>+		WARN_ON(!list_empty(&dpll->registration_list));
>>+		kfree(dpll);
>>+	}
>>+	mutex_unlock(&dpll_xa_lock);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_put);
>>+
>>+static struct dpll_device_registration *
>>+dpll_device_registration_find(struct dpll_device *dpll,
>>+			      const struct dpll_device_ops *ops, void *priv)
>>+{
>>+	struct dpll_device_registration *reg;
>>+
>>+	list_for_each_entry(reg, &dpll->registration_list, list) {
>>+		if (reg->ops =3D=3D ops && reg->priv =3D=3D priv)
>>+			return reg;
>>+	}
>>+	return NULL;
>>+}
>>+
>>+/**
>>+ * dpll_device_register - register the dpll device in the subsystem
>>+ * @dpll: pointer to a dpll
>>+ * @type: type of a dpll
>>+ * @ops: ops for a dpll device
>>+ * @priv: pointer to private information of owner
>>+ * @owner: pointer to owner device
>>+ *
>>+ * Make dpll device available for user space.
>>+ *
>>+ * Return:
>>+ * * 0 on success
>>+ * * -EINVAL on failure
>
>From what I see, this function returns "-EEXIST" as well. Btw, what
>benefit this "table" brings? Perhaps could be avoided in the whole code?
>

Fixed, tried to improve the doxygen all over this file.

>
>>+ */
>>+int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
>>+			 const struct dpll_device_ops *ops, void *priv,
>>+			 struct device *owner)
>>+{
>>+	struct dpll_device_registration *reg;
>>+	bool first_registration =3D false;
>>+
>>+	if (WARN_ON(!ops || !owner))
>>+		return -EINVAL;
>>+	if (WARN_ON(type <=3D DPLL_TYPE_UNSPEC || type > DPLL_TYPE_MAX))
>>+		return -EINVAL;
>>+
>>+	mutex_lock(&dpll_xa_lock);
>>+	reg =3D dpll_device_registration_find(dpll, ops, priv);
>>+	if (reg) {
>>+		mutex_unlock(&dpll_xa_lock);
>>+		return -EEXIST;
>>+	}
>>+
>>+	reg =3D kzalloc(sizeof(*reg), GFP_KERNEL);
>>+	if (!reg) {
>>+		mutex_unlock(&dpll_xa_lock);
>>+		return -EEXIST;
>>+	}
>>+	reg->ops =3D ops;
>>+	reg->priv =3D priv;
>>+
>>+	dpll->dev.bus =3D owner->bus;
>
>This is definitelly odd. You basicall take PCI bus for example and
>pretend some other device to be there. Why exactly this dev is needed at
>all? I don't see the need, you only abuse it to store strings you
>expose over Netlink.
>
>Please remove dpll->dev entirely. Expose module_name, clock_id and
>device_idx directly over Netlink as separate attributes.
>
>
>>+	dpll->parent =3D owner;
>
>
>You don't use dpll->parent. Please remove and remove also "owner" arg of
>this function.
>

Removed.

>
>
>>+	dpll->type =3D type;
>>+	dev_set_name(&dpll->dev, "%s/%llx/%d", module_name(dpll->module),
>>+		     dpll->clock_id, dpll->device_idx);
>>+
>>+	first_registration =3D list_empty(&dpll->registration_list);
>>+	list_add_tail(&reg->list, &dpll->registration_list);
>>+	if (!first_registration) {
>>+		mutex_unlock(&dpll_xa_lock);
>>+		return 0;
>>+	}
>>+
>>+	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>>+	mutex_unlock(&dpll_xa_lock);
>>+	dpll_notify_device_create(dpll);
>>+
>>+	return 0;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_register);
>>+
>>+/**
>>+ * dpll_device_unregister - deregister dpll device
>>+ * @dpll: registered dpll pointer
>>+ * @ops: ops for a dpll device
>>+ * @priv: pointer to private information of owner
>>+ *
>>+ * Deregister device, make it unavailable for userspace.
>>+ * Note: It does not free the memory
>>+ */
>>+void dpll_device_unregister(struct dpll_device *dpll,
>>+			    const struct dpll_device_ops *ops, void *priv)
>>+{
>>+	struct dpll_device_registration *reg;
>>+
>>+	mutex_lock(&dpll_xa_lock);
>>+	ASSERT_DPLL_REGISTERED(dpll);
>>+
>>+	reg =3D dpll_device_registration_find(dpll, ops, priv);
>>+	if (WARN_ON(!reg)) {
>>+		mutex_unlock(&dpll_xa_lock);
>>+		return;
>>+	}
>>+	list_del(&reg->list);
>>+	kfree(reg);
>>+
>>+	if (!list_empty(&dpll->registration_list)) {
>>+		mutex_unlock(&dpll_xa_lock);
>>+		return;
>>+	}
>>+	xa_clear_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>>+	mutex_unlock(&dpll_xa_lock);
>>+	dpll_notify_device_delete(dpll);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_unregister);
>>+
>>+/**
>>+ * dpll_pin_alloc - allocate the memory for dpll pin
>>+ * @clock_id: clock_id of creator
>>+ * @pin_idx: idx given by dev driver
>>+ * @module: reference to registering module
>>+ * @prop: dpll pin properties
>>+ *
>>+ * Return:
>>+ * valid allocated dpll_pin struct pointer if succeeded
>>+ * ERR_PTR of an error
>>+ */
>>+static struct dpll_pin *
>>+dpll_pin_alloc(u64 clock_id, u8 pin_idx, struct module *module,
>
>DPLL_A_PIN_IDX is u32, in struct dpll_pin it is u32.
>Why here you have only u8? Please sync.
>

Fixed.

>
>>+	       const struct dpll_pin_properties *prop)
>>+{
>>+	struct dpll_pin *pin;
>>+	int ret, fs_size;
>>+
>>+	pin =3D kzalloc(sizeof(*pin), GFP_KERNEL);
>>+	if (!pin)
>>+		return ERR_PTR(-ENOMEM);
>>+	pin->pin_idx =3D pin_idx;
>>+	pin->clock_id =3D clock_id;
>>+	pin->module =3D module;
>>+	refcount_set(&pin->refcount, 1);
>>+	if (WARN_ON(!prop->label)) {
>>+		ret =3D -EINVAL;
>>+		goto err;
>>+	}
>>+	pin->prop.label =3D kstrdup(prop->label, GFP_KERNEL);
>>+	if (!pin->prop.label) {
>>+		ret =3D -ENOMEM;
>>+		goto err;
>>+	}
>>+	if (WARN_ON(prop->type <=3D DPLL_PIN_TYPE_UNSPEC ||
>>+		    prop->type > DPLL_PIN_TYPE_MAX)) {
>>+		ret =3D -EINVAL;
>>+		goto err;
>>+	}
>>+	pin->prop.type =3D prop->type;
>>+	pin->prop.capabilities =3D prop->capabilities;
>
>Just assing the prop pointer to pin->prop and you are done, no. Why you
>need to copy the internals? Driver should behave and pass static const
>pointer here (it is common in cases like this).
>

Fixed.

>
>>+	if (prop->freq_supported_num) {
>>+		fs_size =3D sizeof(*pin->prop.freq_supported) *
>>+			  prop->freq_supported_num;
>>+		pin->prop.freq_supported =3D kzalloc(fs_size, GFP_KERNEL);
>>+		if (!pin->prop.freq_supported) {
>>+			ret =3D -ENOMEM;
>>+			goto err;
>>+		}
>>+		memcpy(pin->prop.freq_supported, prop->freq_supported, fs_size);
>>+		pin->prop.freq_supported_num =3D prop->freq_supported_num;
>>+	}
>>+	xa_init_flags(&pin->dpll_refs, XA_FLAGS_ALLOC);
>>+	xa_init_flags(&pin->parent_refs, XA_FLAGS_ALLOC);
>>+	ret =3D xa_alloc(&dpll_pin_xa, &pin->id, pin, xa_limit_16b, GFP_KERNEL)=
;
>>+	if (ret)
>>+		goto err;
>>+	return pin;
>>+err:
>>+	xa_destroy(&pin->dpll_refs);
>>+	xa_destroy(&pin->parent_refs);
>>+	kfree(pin->prop.label);
>>+	kfree(pin->rclk_dev_name);
>>+	kfree(pin);
>>+	return ERR_PTR(ret);
>>+}
>>+
>>+/**
>>+ * dpll_pin_get - find existing or create new dpll pin
>>+ * @clock_id: clock_id of creator
>>+ * @pin_idx: idx given by dev driver
>>+ * @module: reference to registering module
>>+ * @prop: dpll pin properties
>>+ *
>>+ * Get existing object of a pin (unique for given arguments) or create n=
ew
>>+ * if doesn't exist yet.
>>+ *
>>+ * Return:
>>+ * * valid allocated dpll_pin struct pointer if succeeded
>>+ * * ERR_PTR of an error
>>+ */
>>+struct dpll_pin *
>>+dpll_pin_get(u64 clock_id, u32 pin_idx, struct module *module,
>>+	     const struct dpll_pin_properties *prop)
>>+{
>>+	struct dpll_pin *pos, *ret =3D NULL;
>>+	unsigned long i;
>>+
>>+	xa_for_each(&dpll_pin_xa, i, pos) {
>>+		if (pos->clock_id =3D=3D clock_id &&
>>+		    pos->pin_idx =3D=3D pin_idx &&
>>+		    pos->module =3D=3D module) {
>>+			ret =3D pos;
>>+			refcount_inc(&ret->refcount);
>>+			break;
>>+		}
>>+	}
>>+	if (!ret)
>>+		ret =3D dpll_pin_alloc(clock_id, pin_idx, module, prop);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_get);
>>+
>>+/**
>>+ * dpll_pin_put - decrease the refcount and free memory if possible
>>+ * @dpll: dpll_device struct pointer
>>+ *
>>+ * Drop reference for a pin, if all references are gone, delete pin obje=
ct.
>>+ */
>>+void dpll_pin_put(struct dpll_pin *pin)
>>+{
>>+	if (!pin)
>>+		return;
>>+	if (refcount_dec_and_test(&pin->refcount)) {
>>+		xa_destroy(&pin->dpll_refs);
>>+		xa_destroy(&pin->parent_refs);
>>+		xa_erase(&dpll_pin_xa, pin->id);
>>+		kfree(pin->prop.label);
>>+		kfree(pin->prop.freq_supported);
>>+		kfree(pin->rclk_dev_name);
>>+		kfree(pin);
>>+	}
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_put);
>>+
>>+static int
>>+__dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		    const struct dpll_pin_ops *ops, void *priv,
>>+		    const char *rclk_device_name)
>>+{
>>+	int ret;
>>+
>>+	if (WARN_ON(!ops))
>>+		return -EINVAL;
>>+
>>+	if (rclk_device_name && !pin->rclk_dev_name) {
>>+		pin->rclk_dev_name =3D kstrdup(rclk_device_name, GFP_KERNEL);
>>+		if (!pin->rclk_dev_name)
>>+			return -ENOMEM;
>>+	}
>>+	ret =3D dpll_xa_ref_pin_add(&dpll->pin_refs, pin, ops, priv);
>>+	if (ret)
>>+		goto rclk_free;
>>+	ret =3D dpll_xa_ref_dpll_add(&pin->dpll_refs, dpll, ops, priv);
>>+	if (ret)
>>+		goto ref_pin_del;
>>+	else
>>+		dpll_pin_notify(dpll, pin, DPLL_A_PIN_IDX);
>>+
>>+	return ret;
>>+
>>+ref_pin_del:
>>+	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv);
>>+rclk_free:
>>+	kfree(pin->rclk_dev_name);
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * dpll_pin_register - register the dpll pin in the subsystem
>>+ * @dpll: pointer to a dpll
>>+ * @pin: pointer to a dpll pin
>>+ * @ops: ops for a dpll pin ops
>>+ * @priv: pointer to private information of owner
>>+ * @rclk_device: pointer to recovered clock device
>>+ *
>>+ * Return:
>>+ * * 0 on success
>>+ * * -EINVAL - missing dpll or pin
>
>Incorrect.
>

Fixed.

>
>>+ * * -ENOMEM - failed to allocate memory
>>+ */
>>+int
>>+dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		  const struct dpll_pin_ops *ops, void *priv,
>>+		  struct device *rclk_device)
>>+{
>>+	const char *rclk_name =3D rclk_device ? dev_name(rclk_device) : NULL;
>>+	int ret;
>>+
>>+	mutex_lock(&dpll_xa_lock);
>
>You have to make sure that dpll and pin are created with same module and
>clock_id. Check and WARN_ON& bail out here.
>

Sure, makes sense, fixed.

>
>>+	ret =3D __dpll_pin_register(dpll, pin, ops, priv, rclk_name);
>>+	mutex_unlock(&dpll_xa_lock);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_register);
>>+
>>+static void
>>+__dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		      const struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv);
>>+	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll, ops, priv);
>>+}
>>+
>>+/**
>>+ * dpll_pin_unregister - deregister dpll pin from dpll device
>>+ * @dpll: registered dpll pointer
>>+ * @pin: pointer to a pin
>>+ * @ops: ops for a dpll pin
>>+ * @priv: pointer to private information of owner
>>+ *
>>+ * Note: It does not free the memory
>>+ */
>>+void dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
>>+			 const struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	if (WARN_ON(xa_empty(&dpll->pin_refs)))
>>+		return;
>>+
>>+	mutex_lock(&dpll_xa_lock);
>>+	__dpll_pin_unregister(dpll, pin, ops, priv);
>>+	mutex_unlock(&dpll_xa_lock);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_unregister);
>>+
>>+/**
>>+ * dpll_pin_on_pin_register - register a pin with a parent pin
>>+ * @parent: pointer to a parent pin
>>+ * @pin: pointer to a pin
>>+ * @ops: ops for a dpll pin
>>+ * @priv: pointer to private information of owner
>>+ * @rclk_device: pointer to recovered clock device
>>+ *
>>+ * Register a pin with a parent pin, create references between them and
>>+ * between newly registered pin and dplls connected with a parent pin.
>>+ *
>>+ * Return:
>>+ * * 0 on success
>>+ * * -EINVAL missing pin or parent
>>+ * * -ENOMEM failed allocation
>>+ * * -EPERM if parent is not allowed
>>+ */
>>+int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *p=
in,
>>+			     const struct dpll_pin_ops *ops, void *priv,
>>+			     struct device *rclk_device)
>>+{
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long i, stop;
>>+	int ret;
>>+
>>+	if (WARN_ON(parent->prop.type !=3D DPLL_PIN_TYPE_MUX))
>>+		return -EINVAL;
>>+	ret =3D dpll_xa_ref_pin_add(&pin->parent_refs, parent, ops, priv);
>>+	if (ret)
>>+		goto unlock;
>>+	refcount_inc(&pin->refcount);
>>+	xa_for_each(&parent->dpll_refs, i, ref) {
>>+		mutex_lock(&dpll_xa_lock);
>>+		ret =3D __dpll_pin_register(ref->dpll, pin, ops, priv,
>>+					  rclk_device ?
>>+					  dev_name(rclk_device) : NULL);
>>+		mutex_unlock(&dpll_xa_lock);
>>+		if (ret) {
>>+			stop =3D i;
>>+			goto dpll_unregister;
>>+		}
>>+		dpll_pin_parent_notify(ref->dpll, pin, parent, DPLL_A_PIN_IDX);
>>+	}
>>+
>>+	return ret;
>>+
>>+dpll_unregister:
>>+	xa_for_each(&parent->dpll_refs, i, ref) {
>>+		if (i < stop) {
>>+			mutex_lock(&dpll_xa_lock);
>>+			__dpll_pin_unregister(ref->dpll, pin, ops, priv);
>>+			mutex_unlock(&dpll_xa_lock);
>>+		}
>>+	}
>>+	refcount_dec(&pin->refcount);
>>+	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv);
>>+unlock:
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_on_pin_register);
>>+
>>+/**
>>+ * dpll_pin_on_pin_unregister - deregister dpll pin from a parent pin
>>+ * @parent: pointer to a parent pin
>>+ * @pin: pointer to a pin
>>+ * @ops: ops for a dpll pin
>>+ * @priv: pointer to private information of owner
>>+ *
>>+ * Note: It does not free the memory
>>+ */
>>+void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin
>>*pin,
>>+				const struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long i;
>>+
>>+	mutex_lock(&dpll_xa_lock);
>>+	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv);
>>+	refcount_dec(&pin->refcount);
>>+	xa_for_each(&pin->dpll_refs, i, ref) {
>>+		__dpll_pin_unregister(ref->dpll, pin, ops, priv);
>>+		dpll_pin_parent_notify(ref->dpll, pin, parent,
>>+				       DPLL_A_PIN_IDX);
>>+	}
>>+	mutex_unlock(&dpll_xa_lock);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_on_pin_unregister);
>>+
>>+static struct dpll_device_registration *
>>+dpll_device_registration_first(struct dpll_device *dpll)
>>+{
>>+	struct dpll_device_registration *reg;
>>+
>>+	reg =3D list_first_entry_or_null((struct list_head *) &dpll-
>>registration_list,
>>+				       struct dpll_device_registration, list);
>>+	WARN_ON(!reg);
>>+	return reg;
>>+}
>>+
>>+/**
>>+ * dpll_priv - get the dpll device private owner data
>>+ * @dpll:      registered dpll pointer
>>+ *
>>+ * Return: pointer to the data
>>+ */
>>+void *dpll_priv(const struct dpll_device *dpll)
>
>I don't see where you call this with const *. Avoid const here which
>will allow you to remove the cast below.
>

Fixed.

>
>>+{
>>+	struct dpll_device_registration *reg;
>>+
>>+	reg =3D dpll_device_registration_first((struct dpll_device *) dpll);
>>+	return reg->priv;
>>+}
>>+
>>+const struct dpll_device_ops *dpll_device_ops(struct dpll_device *dpll)
>>+{
>>+	struct dpll_device_registration *reg;
>>+
>>+	reg =3D dpll_device_registration_first(dpll);
>>+	return reg->ops;
>>+}
>>+
>>+static struct dpll_pin_registration *
>>+dpll_pin_registration_first(struct dpll_pin_ref *ref)
>>+{
>>+	struct dpll_pin_registration *reg;
>>+
>>+	reg =3D list_first_entry_or_null(&ref->registration_list,
>>+				       struct dpll_pin_registration, list);
>>+	WARN_ON(!reg);
>>+	return reg;
>>+}
>>+
>>+/**
>>+ * dpll_pin_on_dpll_priv - get the dpll device private owner data
>>+ * @dpll:      registered dpll pointer
>>+ * @pin:       pointer to a pin
>>+ *
>>+ * Return: pointer to the data
>>+ */
>>+void *dpll_pin_on_dpll_priv(const struct dpll_device *dpll,
>>+			    const struct dpll_pin *pin)
>>+{
>>+	struct dpll_pin_registration *reg;
>>+	struct dpll_pin_ref *ref;
>>+
>>+	ref =3D xa_load((struct xarray *)&dpll->pin_refs, pin->pin_idx);
>
>IDK, this sort of "unconst" cast always spells. Could you please
>avoid them in the entire code?
>

Fixed.

>
>>+	if (!ref)
>>+		return NULL;
>>+	reg =3D dpll_pin_registration_first(ref);
>>+	return reg->priv;
>>+}
>>+
>>+/**
>>+ * dpll_pin_on_pin_priv - get the dpll pin private owner data
>>+ * @parent: pointer to a parent pin
>>+ * @pin: pointer to a pin
>>+ *
>>+ * Return: pointer to the data
>>+ */
>>+void *dpll_pin_on_pin_priv(const struct dpll_pin *parent,
>>+			   const struct dpll_pin *pin)
>>+{
>>+	struct dpll_pin_registration *reg;
>>+	struct dpll_pin_ref *ref;
>>+
>>+	ref =3D xa_load((struct xarray *)&pin->parent_refs, parent->pin_idx);
>>+	if (!ref)
>>+		return NULL;
>>+	reg =3D dpll_pin_registration_first(ref);
>>+	return reg->priv;
>>+}
>>+
>>+const struct dpll_pin_ops *dpll_pin_ops(struct dpll_pin_ref *ref)
>>+{
>>+	struct dpll_pin_registration *reg;
>>+
>>+	reg =3D dpll_pin_registration_first(ref);
>>+	return reg->ops;
>>+}
>>+
>>+static int __init dpll_init(void)
>>+{
>>+	int ret;
>>+
>>+	ret =3D dpll_netlink_init();
>>+	if (ret)
>>+		goto error;
>>+
>>+	return 0;
>>+
>>+error:
>>+	mutex_destroy(&dpll_xa_lock);
>>+	return ret;
>>+}
>>+subsys_initcall(dpll_init);
>>diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
>>new file mode 100644
>>index 000000000000..e905c1088568
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_core.h
>>@@ -0,0 +1,113 @@
>>+/* SPDX-License-Identifier: GPL-2.0 */
>>+/*
>>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>+ */
>>+
>>+#ifndef __DPLL_CORE_H__
>>+#define __DPLL_CORE_H__
>>+
>>+#include <linux/dpll.h>
>>+#include <linux/list.h>
>>+#include <linux/refcount.h>
>>+#include "dpll_netlink.h"
>>+
>>+#define DPLL_REGISTERED		XA_MARK_1
>>+
>>+struct dpll_device_registration {
>>+	struct list_head list;
>>+	const struct dpll_device_ops *ops;
>>+	void *priv;
>>+};
>>+
>>+/**
>>+ * struct dpll_device - structure for a DPLL device
>>+ * @id:			unique id number for each device
>>+ * @dev_driver_id:	id given by dev driver
>>+ * @clock_id:		unique identifier (clock_id) of a dpll
>>+ * @module:		module of creator
>>+ * @dev:		struct device for this dpll device
>>+ * @parent:		parent device
>>+ * @ops:		operations this &dpll_device supports
>>+ * @lock:		mutex to serialize operations
>>+ * @type:		type of a dpll
>>+ * @pins:		list of pointers to pins registered with this dpll
>>+ * @mode_supported_mask: mask of supported modes
>>+ * @refcount:		refcount
>>+ * @priv:		pointer to private information of owner
>>+ **/
>>+struct dpll_device {
>>+	u32 id;
>>+	u32 device_idx;
>>+	u64 clock_id;
>>+	struct module *module;
>>+	struct device dev;
>>+	struct device *parent;
>>+	enum dpll_type type;
>>+	struct xarray pin_refs;
>>+	unsigned long mode_supported_mask;
>>+	refcount_t refcount;
>>+	struct list_head registration_list;
>>+};
>>+
>>+/**
>>+ * struct dpll_pin - structure for a dpll pin
>>+ * @idx:		unique idx given by alloc on global pin's XA
>>+ * @dev_driver_id:	id given by dev driver
>>+ * @clock_id:		clock_id of creator
>>+ * @module:		module of creator
>>+ * @dpll_refs:		hold referencees to dplls that pin is registered
>>with
>>+ * @pin_refs:		hold references to pins that pin is registered with
>>+ * @prop:		properties given by registerer
>>+ * @rclk_dev_name:	holds name of device when pin can recover clock
>>from it
>>+ * @refcount:		refcount
>>+ **/
>>+struct dpll_pin {
>>+	u32 id;
>>+	u32 pin_idx;
>>+	u64 clock_id;
>>+	struct module *module;
>>+	struct xarray dpll_refs;
>>+	struct xarray parent_refs;
>>+	struct dpll_pin_properties prop;
>>+	char *rclk_dev_name;
>>+	refcount_t refcount;
>>+};
>>+
>>+struct dpll_pin_registration {
>>+	struct list_head list;
>>+	const struct dpll_pin_ops *ops;
>>+	void *priv;
>>+};
>>+
>>+/**
>>+ * struct dpll_pin_ref - structure for referencing either dpll or pins
>>+ * @dpll:		pointer to a dpll
>>+ * @pin:		pointer to a pin
>>+ * @registration_list	list of ops and priv data registered with the ref
>>+ * @refcount:		refcount
>>+ **/
>>+struct dpll_pin_ref {
>>+	union {
>>+		struct dpll_device *dpll;
>>+		struct dpll_pin *pin;
>>+	};
>>+	struct list_head registration_list;
>>+	refcount_t refcount;
>>+};
>>+
>>+void *dpll_priv(const struct dpll_device *dpll);
>>+void *dpll_pin_on_dpll_priv(const struct dpll_device *dpll,
>>+			    const struct dpll_pin *pin);
>>+void *dpll_pin_on_pin_priv(const struct dpll_pin *parent,
>>+			   const struct dpll_pin *pin);
>>+
>>+const struct dpll_device_ops *dpll_device_ops(struct dpll_device *dpll);
>>+struct dpll_device *dpll_device_get_by_id(int id);
>>+struct dpll_device *dpll_device_get_by_name(const char *bus_name,
>>+					    const char *dev_name);
>>+const struct dpll_pin_ops *dpll_pin_ops(struct dpll_pin_ref *ref);
>>+struct dpll_pin_ref *dpll_xa_ref_dpll_first(struct xarray *xa_refs);
>>+extern struct xarray dpll_device_xa;
>>+extern struct xarray dpll_pin_xa;
>>+extern struct mutex dpll_xa_lock;
>>+#endif
>>diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>>new file mode 100644
>>index 000000000000..1eb0b4a2fce4
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_netlink.c
>>@@ -0,0 +1,972 @@
>>+// SPDX-License-Identifier: GPL-2.0
>>+/*
>>+ * Generic netlink for DPLL management framework
>>+ *
>>+ * Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>
>It's 2023. You still live in the past :)
>
>

Fixed.

>
>>+ *
>>+ */
>>+#include <linux/module.h>
>>+#include <linux/kernel.h>
>>+#include <net/genetlink.h>
>>+#include "dpll_core.h"
>>+#include "dpll_nl.h"
>>+#include <uapi/linux/dpll.h>
>>+
>>+struct dpll_dump_ctx {
>>+	unsigned long idx;
>>+};
>>+
>>+static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback *=
cb)
>>+{
>>+	return (struct dpll_dump_ctx *)cb->ctx;
>>+}
>>+
>>+static int
>>+dpll_msg_add_dev_handle(struct sk_buff *msg, struct dpll_device *dpll)
>>+{
>>+	if (nla_put_u32(msg, DPLL_A_ID, dpll->id))
>>+		return -EMSGSIZE;
>>+	if (nla_put_string(msg, DPLL_A_BUS_NAME, dev_bus_name(&dpll->dev)))
>>+		return -EMSGSIZE;
>>+	if (nla_put_string(msg, DPLL_A_DEV_NAME, dev_name(&dpll->dev)))
>
>In this version, only ID is a handle.
>

Fixed.

>
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_mode(struct sk_buff *msg, struct dpll_device *dpll,
>>+		  struct netlink_ext_ack *extack)
>>+{
>>+	const struct dpll_device_ops *ops =3D dpll_device_ops(dpll);
>>+	enum dpll_mode mode;
>>+
>>+	if (WARN_ON(!ops->mode_get))
>>+		return -EOPNOTSUPP;
>>+	if (ops->mode_get(dpll, dpll_priv(dpll), &mode, extack))
>>+		return -EFAULT;
>>+	if (nla_put_u8(msg, DPLL_A_MODE, mode))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_lock_status(struct sk_buff *msg, struct dpll_device *dpll,
>>+			 struct netlink_ext_ack *extack)
>>+{
>>+	const struct dpll_device_ops *ops =3D dpll_device_ops(dpll);
>>+	enum dpll_lock_status status;
>>+
>>+	if (WARN_ON(!ops->lock_status_get))
>>+		return -EOPNOTSUPP;
>>+	if (ops->lock_status_get(dpll, dpll_priv(dpll), &status, extack))
>>+		return -EFAULT;
>>+	if (nla_put_u8(msg, DPLL_A_LOCK_STATUS, status))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_temp(struct sk_buff *msg, struct dpll_device *dpll,
>>+		  struct netlink_ext_ack *extack)
>>+{
>>+	const struct dpll_device_ops *ops =3D dpll_device_ops(dpll);
>>+	s32 temp;
>>+
>>+	if (!ops->temp_get)
>>+		return -EOPNOTSUPP;
>>+	if (ops->temp_get(dpll, dpll_priv(dpll), &temp, extack))
>>+		return -EFAULT;
>>+	if (nla_put_s32(msg, DPLL_A_TEMP, temp))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_prio(struct sk_buff *msg, const struct dpll_pin *pin,
>>+		      struct dpll_pin_ref *ref,
>>+		      struct netlink_ext_ack *extack)
>>+{
>>+	const struct dpll_pin_ops *ops =3D dpll_pin_ops(ref);
>>+	const struct dpll_device *dpll =3D ref->dpll;
>>+	u32 prio;
>>+
>>+	if (!ops->prio_get)
>>+		return -EOPNOTSUPP;
>>+	if (ops->prio_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>>+			  dpll_priv(dpll), &prio, extack))
>>+		return -EFAULT;
>>+	if (nla_put_u32(msg, DPLL_A_PIN_PRIO, prio))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_on_dpll_state(struct sk_buff *msg, const struct dpll_pi=
n
>>*pin,
>>+			       struct dpll_pin_ref *ref,
>>+			       struct netlink_ext_ack *extack)
>>+{
>>+	const struct dpll_pin_ops *ops =3D dpll_pin_ops(ref);
>>+	const struct dpll_device *dpll =3D ref->dpll;
>>+	enum dpll_pin_state state;
>>+
>>+	if (!ops->state_on_dpll_get)
>>+		return -EOPNOTSUPP;
>>+	if (ops->state_on_dpll_get(pin, dpll_pin_on_dpll_priv(dpll, pin),
>>dpll,
>>+				   dpll_priv(dpll), &state, extack))
>>+		return -EFAULT;
>>+	if (nla_put_u8(msg, DPLL_A_PIN_STATE, state))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_direction(struct sk_buff *msg, const struct dpll_pin
>>*pin,
>>+			   struct dpll_pin_ref *ref,
>>+			   struct netlink_ext_ack *extack)
>>+{
>>+	const struct dpll_pin_ops *ops =3D dpll_pin_ops(ref);
>>+	const struct dpll_device *dpll =3D ref->dpll;
>>+	enum dpll_pin_direction direction;
>>+
>>+	if (!ops->direction_get)
>>+		return -EOPNOTSUPP;
>>+	if (ops->direction_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>>+			       dpll_priv(dpll), &direction, extack))
>>+		return -EFAULT;
>>+	if (nla_put_u8(msg, DPLL_A_PIN_DIRECTION, direction))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_freq(struct sk_buff *msg, const struct dpll_pin *pin,
>>+		      struct dpll_pin_ref *ref, struct netlink_ext_ack *extack,
>>+		      bool dump_freq_supported)
>>+{
>>+	const struct dpll_pin_ops *ops =3D dpll_pin_ops(ref);
>>+	const struct dpll_device *dpll =3D ref->dpll;
>>+	struct nlattr *nest;
>>+	u64 freq;
>>+	int fs;
>>+
>>+	if (!ops->frequency_get)
>>+		return -EOPNOTSUPP;
>>+	if (ops->frequency_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>>+			       dpll_priv(dpll), &freq, extack))
>>+		return -EFAULT;
>>+	if (nla_put_64bit(msg, DPLL_A_PIN_FREQUENCY, sizeof(freq), &freq, 0))
>>+		return -EMSGSIZE;
>>+	if (!dump_freq_supported)
>>+		return 0;
>>+	for (fs =3D 0; fs < pin->prop.freq_supported_num; fs++) {
>>+		nest =3D nla_nest_start(msg, DPLL_A_PIN_FREQUENCY_SUPPORTED);
>>+		if (!nest)
>>+			return -EMSGSIZE;
>>+		freq =3D pin->prop.freq_supported[fs].min;
>>+		if (nla_put_64bit(msg, DPLL_A_PIN_FREQUENCY_MIN, sizeof(freq),
>>+				   &freq, 0)) {
>>+			nla_nest_cancel(msg, nest);
>>+			return -EMSGSIZE;
>>+		}
>>+		freq =3D pin->prop.freq_supported[fs].max;
>>+		if (nla_put_64bit(msg, DPLL_A_PIN_FREQUENCY_MAX, sizeof(freq),
>>+				   &freq, 0)) {
>>+			nla_nest_cancel(msg, nest);
>>+			return -EMSGSIZE;
>>+		}
>>+		nla_nest_end(msg, nest);
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_parents(struct sk_buff *msg, struct dpll_pin *pin,
>>+			 struct netlink_ext_ack *extack)
>>+{
>>+	enum dpll_pin_state state;
>>+	struct dpll_pin_ref *ref;
>>+	struct dpll_pin *ppin;
>>+	struct nlattr *nest;
>>+	unsigned long index;
>>+	int ret;
>>+
>>+	xa_for_each(&pin->parent_refs, index, ref) {
>>+		const struct dpll_pin_ops *ops =3D dpll_pin_ops(ref);
>>+
>>+		ppin =3D ref->pin;
>>+
>>+		if (WARN_ON(!ops->state_on_pin_get))
>>+			return -EFAULT;
>>+		ret =3D ops->state_on_pin_get(pin,
>>+					    dpll_pin_on_pin_priv(ppin, pin),
>>+					    ppin, &state, extack);
>>+		if (ret)
>>+			return -EFAULT;
>>+		nest =3D nla_nest_start(msg, DPLL_A_PIN_PARENT);
>>+		if (!nest)
>>+			return -EMSGSIZE;
>>+		if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX, ppin->pin_idx)) {
>>+			ret =3D -EMSGSIZE;
>>+			goto nest_cancel;
>>+		}
>>+		if (nla_put_u8(msg, DPLL_A_PIN_STATE, state)) {
>>+			ret =3D -EMSGSIZE;
>>+			goto nest_cancel;
>>+		}
>>+		nla_nest_end(msg, nest);
>>+	}
>>+
>>+	return 0;
>>+
>>+nest_cancel:
>>+	nla_nest_cancel(msg, nest);
>>+	return ret;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_dplls(struct sk_buff *msg, struct dpll_pin *pin,
>>+		       struct netlink_ext_ack *extack)
>>+{
>>+	struct dpll_pin_ref *ref;
>>+	struct nlattr *attr;
>>+	unsigned long index;
>>+	int ret;
>>+
>>+	xa_for_each(&pin->dpll_refs, index, ref) {
>>+		attr =3D nla_nest_start(msg, DPLL_A_DEVICE);
>>+		if (!attr)
>>+			return -EMSGSIZE;
>>+		ret =3D dpll_msg_add_dev_handle(msg, ref->dpll);
>>+		if (ret)
>>+			goto nest_cancel;
>>+		ret =3D dpll_msg_add_pin_on_dpll_state(msg, pin, ref, extack);
>>+		if (ret && ret !=3D -EOPNOTSUPP)
>>+			goto nest_cancel;
>>+		ret =3D dpll_msg_add_pin_prio(msg, pin, ref, extack);
>>+		if (ret && ret !=3D -EOPNOTSUPP)
>>+			goto nest_cancel;
>>+		nla_nest_end(msg, attr);
>>+	}
>>+
>>+	return 0;
>>+
>>+nest_cancel:
>>+	nla_nest_end(msg, attr);
>>+	return ret;
>>+}
>>+
>>+static int
>>+dpll_cmd_pin_fill_details(struct sk_buff *msg, struct dpll_pin *pin,
>>+			  struct dpll_pin_ref *ref, struct netlink_ext_ack
>>*extack)
>>+{
>>+	int ret;
>>+
>>+	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->pin_idx))
>>+		return -EMSGSIZE;
>>+	if (nla_put_string(msg, DPLL_A_PIN_LABEL, pin->prop.label))
>>+		return -EMSGSIZE;
>>+	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
>>+		return -EMSGSIZE;
>>+	if (nla_put_u32(msg, DPLL_A_PIN_DPLL_CAPS, pin->prop.capabilities))
>>+		return -EMSGSIZE;
>>+	ret =3D dpll_msg_add_pin_direction(msg, pin, ref, extack);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_freq(msg, pin, ref, extack, true);
>>+	if (ret && ret !=3D -EOPNOTSUPP)
>>+		return ret;
>>+	if (pin->rclk_dev_name)
>>+		if (nla_put_string(msg, DPLL_A_PIN_RCLK_DEVICE,
>>+				   pin->rclk_dev_name))
>>+			return -EMSGSIZE;
>>+	return 0;
>>+}
>>+
>>+static int
>>+__dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_pin *pin,
>>+			struct netlink_ext_ack *extack)
>>+{
>>+	struct dpll_pin_ref *ref;
>>+	int ret;
>>+
>>+	ref =3D dpll_xa_ref_dpll_first(&pin->dpll_refs);
>>+	if (!ref)
>>+		return -EFAULT;
>>+	ret =3D dpll_cmd_pin_fill_details(msg, pin, ref, extack);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_parents(msg, pin, extack);
>>+	if (ret)
>>+		return ret;
>>+	if (!xa_empty(&pin->dpll_refs)) {
>>+		ret =3D dpll_msg_add_pin_dplls(msg, pin, extack);
>>+		if (ret)
>>+			return ret;
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_device_get_one(struct dpll_device *dpll, struct sk_buff *msg,
>>+		    struct netlink_ext_ack *extack)
>>+{
>>+	enum dpll_mode mode;
>>+	int ret;
>>+
>>+	ret =3D dpll_msg_add_dev_handle(msg, dpll);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_temp(msg, dpll, extack);
>>+	if (ret && ret !=3D -EOPNOTSUPP)
>>+		return ret;
>>+	ret =3D dpll_msg_add_lock_status(msg, dpll, extack);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_mode(msg, dpll, extack);
>>+	if (ret)
>>+		return ret;
>>+	for (mode =3D DPLL_MODE_UNSPEC + 1; mode <=3D DPLL_MODE_MAX; mode++)
>>+		if (test_bit(mode, &dpll->mode_supported_mask))
>>+			if (nla_put_s32(msg, DPLL_A_MODE_SUPPORTED, mode))
>>+				return -EMSGSIZE;
>>+	if (nla_put_64bit(msg, DPLL_A_CLOCK_ID, sizeof(dpll->clock_id),
>>+			  &dpll->clock_id, 0))
>>+		return -EMSGSIZE;
>>+	if (nla_put_u8(msg, DPLL_A_TYPE, dpll->type))
>>+		return -EMSGSIZE;
>>+
>>+	return ret;
>>+}
>>+
>>+static bool dpll_pin_is_freq_supported(struct dpll_pin *pin, u32 freq)
>>+{
>>+	int fs;
>>+
>>+	for (fs =3D 0; fs < pin->prop.freq_supported_num; fs++)
>>+		if (freq >=3D  pin->prop.freq_supported[fs].min &&
>>+		    freq <=3D  pin->prop.freq_supported[fs].max)
>>+			return true;
>>+	return false;
>>+}
>>+
>>+static int
>>+dpll_pin_freq_set(struct dpll_pin *pin, struct nlattr *a,
>>+		  struct netlink_ext_ack *extack)
>>+{
>>+	u64 freq =3D nla_get_u64(a);
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long i;
>>+	int ret;
>>+
>>+	if (!dpll_pin_is_freq_supported(pin, freq))
>>+		return -EINVAL;
>>+
>>+	xa_for_each(&pin->dpll_refs, i, ref) {
>>+		const struct dpll_pin_ops *ops =3D dpll_pin_ops(ref);
>>+		struct dpll_device *dpll =3D ref->dpll;
>>+
>>+		ret =3D ops->frequency_set(pin, dpll_pin_on_dpll_priv(dpll, pin),
>>+					 dpll, dpll_priv(dpll), freq, extack);
>>+		if (ret)
>>+			return -EFAULT;
>>+		dpll_pin_notify(dpll, pin, DPLL_A_PIN_FREQUENCY);
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_pin_on_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin=
,
>>+			  u32 parent_idx, enum dpll_pin_state state,
>>+			  struct netlink_ext_ack *extack)
>>+{
>>+	const struct dpll_pin_ops *ops;
>>+	struct dpll_pin_ref *pin_ref, *parent_ref;
>>+
>>+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop.capabilities))
>>+		return -EOPNOTSUPP;
>>+	parent_ref =3D xa_load(&pin->parent_refs, parent_idx);
>>+	       //	dpll_pin_get_by_idx(dpll, parent_idx);
>
>Leftover?

Fixed.

>
>
>
>>+	if (!parent_ref)
>>+		return -EINVAL;
>>+	pin_ref =3D xa_load(&dpll->pin_refs, pin->pin_idx);
>>+	if (!pin_ref)
>>+		return -EINVAL;
>>+	ops =3D dpll_pin_ops(pin_ref);
>>+	if (!ops->state_on_pin_set)
>>+		return -EOPNOTSUPP;
>>+	if (ops->state_on_pin_set(pin_ref->pin,
>>+				  dpll_pin_on_pin_priv(parent_ref->pin,
>>+						       pin_ref->pin),
>>+				  parent_ref->pin, state, extack))
>>+		return -EFAULT;
>>+	dpll_pin_parent_notify(dpll, pin_ref->pin, parent_ref->pin,
>>+			       DPLL_A_PIN_STATE);
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		   enum dpll_pin_state state,
>>+		   struct netlink_ext_ack *extack)
>>+{
>>+	const struct dpll_pin_ops *ops;
>>+	struct dpll_pin_ref *ref;
>>+
>>+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop.capabilities))
>>+		return -EOPNOTSUPP;
>>+	ref =3D xa_load(&pin->dpll_refs, dpll->device_idx);
>>+	if (!ref)
>>+		return -EFAULT;
>>+	ops =3D dpll_pin_ops(ref);
>>+	if (!ops->state_on_dpll_set)
>>+		return -EOPNOTSUPP;
>>+	if (ops->state_on_dpll_set(pin, dpll_pin_on_dpll_priv(dpll, pin),
>>dpll,
>>+				   dpll_priv(dpll), state, extack))
>>+		return -EINVAL;
>>+	dpll_pin_notify(dpll, pin, DPLL_A_PIN_STATE);
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_pin_prio_set(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		  struct nlattr *prio_attr, struct netlink_ext_ack *extack)
>>+{
>>+	const struct dpll_pin_ops *ops;
>>+	struct dpll_pin_ref *ref;
>>+	u32 prio =3D nla_get_u8(prio_attr);
>>+
>>+	if (!(DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE & pin->prop.capabilities))
>>+		return -EOPNOTSUPP;
>>+	ref =3D xa_load(&pin->dpll_refs, dpll->device_idx);
>>+	if (!ref)
>>+		return -EFAULT;
>>+	ops =3D dpll_pin_ops(ref);
>>+	if (!ops->prio_set)
>>+		return -EOPNOTSUPP;
>>+	if (ops->prio_set(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>>+			  dpll_priv(dpll), prio, extack))
>>+		return -EINVAL;
>>+	dpll_pin_notify(dpll, pin, DPLL_A_PIN_PRIO);
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_pin_direction_set(struct dpll_pin *pin, struct nlattr *a,
>>+		       struct netlink_ext_ack *extack)
>>+{
>>+	enum dpll_pin_direction direction =3D nla_get_u8(a);
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long i;
>>+
>>+	if (!(DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE & pin->prop.capabilities))
>>+		return -EOPNOTSUPP;
>>+
>>+	xa_for_each(&pin->dpll_refs, i, ref) {
>>+		const struct dpll_pin_ops *ops =3D dpll_pin_ops(ref);
>>+		struct dpll_device *dpll =3D ref->dpll;
>>+
>>+		if (ops->direction_set(pin, dpll_pin_on_dpll_priv(dpll, pin),
>>+				       dpll, dpll_priv(dpll), direction,
>>+				       extack))
>>+			return -EFAULT;
>>+		dpll_pin_notify(dpll, pin, DPLL_A_PIN_DIRECTION);
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_pin_set_from_nlattr(struct dpll_device *dpll,
>>+			 struct dpll_pin *pin, struct genl_info *info)
>>+{
>>+	enum dpll_pin_state state =3D DPLL_PIN_STATE_UNSPEC;
>>+	bool parent_present =3D false;
>>+	int rem, ret =3D -EINVAL;
>>+	struct nlattr *a;
>>+	u32 parent_idx;
>>+
>>+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>>+			  genlmsg_len(info->genlhdr), rem) {
>>+		switch (nla_type(a)) {
>>+		case DPLL_A_PIN_FREQUENCY:
>>+			ret =3D dpll_pin_freq_set(pin, a, info->extack);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLL_A_PIN_DIRECTION:
>>+			ret =3D dpll_pin_direction_set(pin, a, info->extack);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLL_A_PIN_PRIO:
>>+			ret =3D dpll_pin_prio_set(dpll, pin, a, info->extack);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLL_A_PIN_PARENT_IDX:
>
>See my comment for dpll_pin_pre_doit(), please change this to
>PIN_PARENT_ID and use uniqueue xarray id handle for parent pin.
>

This has changed already, now parent comes as nested attribute
DPLL_A_PIN_PARENT and uses DPLL_A_ID or DPLL_A_PIN_ID, depending
if provides info on parent dpll or pin.

>
>>+			parent_present =3D true;
>>+			parent_idx =3D nla_get_u32(a);
>>+			break;
>>+		case DPLL_A_PIN_STATE:
>>+			state =3D nla_get_u8(a);
>>+			break;
>>+		default:
>>+			break;
>>+		}
>
>
>Why do you have to iterate here? Why simple
>	if (attr_x)
>		ret =3D dpll_pin_x_set()
>
>is not enough?
>
>Is it because of state? if yes:
>	if (attr_state)
>		if (attr_parent)
>			dpll_pin_on_pin_state_set()
>		else
>			dpll_pin_state_set()
>
>

Fixed.

>
>
>>+	}
>>+	if (state !=3D DPLL_PIN_STATE_UNSPEC) {
>>+		if (!parent_present) {
>>+			ret =3D dpll_pin_state_set(dpll, pin, state,
>>+						 info->extack);
>>+			if (ret)
>>+				return ret;
>>+		} else {
>>+			ret =3D dpll_pin_on_pin_state_set(dpll, pin, parent_idx,
>>+							state, info->extack);
>>+			if (ret)
>>+				return ret;
>>+		}
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+int dpll_nl_pin_set_doit(struct sk_buff *skb, struct genl_info *info)
>>+{
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+	struct dpll_pin *pin =3D info->user_ptr[1];
>>+
>>+	return dpll_pin_set_from_nlattr(dpll, pin, info);
>>+}
>>+
>>+int dpll_nl_pin_get_doit(struct sk_buff *skb, struct genl_info *info)
>>+{
>>+	struct dpll_pin *pin =3D info->user_ptr[1];
>>+	struct sk_buff *msg;
>>+	struct nlattr *hdr;
>>+	int ret;
>>+
>>+	if (!pin)
>>+		return -ENODEV;
>>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>+	if (!msg)
>>+		return -ENOMEM;
>>+	hdr =3D genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
>>+				DPLL_CMD_PIN_GET);
>>+	if (!hdr)
>>+		return -EMSGSIZE;
>>+	ret =3D __dpll_cmd_pin_dump_one(msg, pin, info->extack);
>>+	if (ret) {
>>+		nlmsg_free(msg);
>>+		return ret;
>>+	}
>>+	genlmsg_end(msg, hdr);
>>+
>>+	return genlmsg_reply(msg, info);
>>+}
>>+
>>+int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback =
*cb)
>>+{
>>+	struct dpll_dump_ctx *ctx =3D dpll_dump_context(cb);
>>+	struct dpll_pin *pin;
>>+	struct nlattr *hdr;
>>+	unsigned long i;
>>+	int ret =3D 0;
>>+
>>+	xa_for_each_start(&dpll_pin_xa, i, pin, ctx->idx) {
>>+		if (xa_empty(&pin->dpll_refs))
>>+			continue;
>>+		hdr =3D genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
>>+				  cb->nlh->nlmsg_seq,
>>+				  &dpll_nl_family, NLM_F_MULTI,
>>+				  DPLL_CMD_PIN_GET);
>>+		if (!hdr) {
>>+			ret =3D -EMSGSIZE;
>>+			break;
>>+		}
>>+		ret =3D __dpll_cmd_pin_dump_one(skb, pin, cb->extack);
>>+		if (ret) {
>>+			genlmsg_cancel(skb, hdr);
>>+			break;
>>+		}
>>+		genlmsg_end(skb, hdr);
>>+	}
>>+	if (ret =3D=3D -EMSGSIZE) {
>>+		ctx->idx =3D i;
>>+		return skb->len;
>>+	}
>>+	return ret;
>>+}
>>+
>>+static int
>>+dpll_set_from_nlattr(struct dpll_device *dpll, struct genl_info *info)
>>+{
>>+	const struct dpll_device_ops *ops =3D dpll_device_ops(dpll);
>>+	struct nlattr *attr;
>>+	enum dpll_mode mode;
>>+	int rem, ret =3D 0;
>>+
>>+	nla_for_each_attr(attr, genlmsg_data(info->genlhdr),
>>+			  genlmsg_len(info->genlhdr), rem) {
>>+		switch (nla_type(attr)) {
>>+		case DPLL_A_MODE:
>
>Again, why loop? I don't see any sane reason, is there any?
>

No, no reason now, will remove it.

>
>
>>+			mode =3D nla_get_u8(attr);
>>+
>>+			ret =3D ops->mode_set(dpll, dpll_priv(dpll), mode,
>>+					    info->extack);
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
>>+int dpll_nl_device_set_doit(struct sk_buff *skb, struct genl_info *info)
>>+{
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+
>>+	return dpll_set_from_nlattr(dpll, info);
>>+}
>>+
>>+int dpll_nl_device_get_doit(struct sk_buff *skb, struct genl_info *info)
>>+{
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+	struct sk_buff *msg;
>>+	struct nlattr *hdr;
>>+	int ret;
>>+
>>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>+	if (!msg)
>>+		return -ENOMEM;
>>+	hdr =3D genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
>>+				DPLL_CMD_DEVICE_GET);
>>+	if (!hdr)
>>+		return -EMSGSIZE;
>>+
>>+	ret =3D dpll_device_get_one(dpll, msg, info->extack);
>>+	if (ret) {
>>+		nlmsg_free(msg);
>>+		return ret;
>>+	}
>>+	genlmsg_end(msg, hdr);
>>+
>>+	return genlmsg_reply(msg, info);
>>+}
>>+
>>+int dpll_nl_device_get_dumpit(struct sk_buff *skb, struct netlink_callba=
ck
>>*cb)
>>+{
>>+	struct dpll_dump_ctx *ctx =3D dpll_dump_context(cb);
>>+	struct dpll_device *dpll;
>>+	struct nlattr *hdr;
>>+	unsigned long i;
>>+	int ret =3D 0;
>>+
>>+	xa_for_each_start(&dpll_device_xa, i, dpll, ctx->idx) {
>>+		if (!xa_get_mark(&dpll_device_xa, i, DPLL_REGISTERED))
>>+			continue;
>>+		hdr =3D genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
>>+				  cb->nlh->nlmsg_seq, &dpll_nl_family,
>>+				  NLM_F_MULTI, DPLL_CMD_DEVICE_GET);
>>+		if (!hdr) {
>>+			ret =3D -EMSGSIZE;
>>+			break;
>>+		}
>>+		ret =3D dpll_device_get_one(dpll, skb, cb->extack);
>>+		if (ret) {
>>+			genlmsg_cancel(skb, hdr);
>>+			break;
>>+		}
>>+		genlmsg_end(skb, hdr);
>>+	}
>>+	if (ret =3D=3D -EMSGSIZE) {
>>+		ctx->idx =3D i;
>>+		return skb->len;
>>+	}
>>+	return ret;
>>+}
>>+
>>+int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>>+		  struct genl_info *info)
>>+{
>>+	struct dpll_device *dpll_id =3D NULL;
>>+	u32 id;
>>+
>>+	if (!info->attrs[DPLL_A_ID])
>>+		return -EINVAL;
>>+
>>+	mutex_lock(&dpll_xa_lock);
>>+	id =3D nla_get_u32(info->attrs[DPLL_A_ID]);
>>+
>>+	dpll_id =3D dpll_device_get_by_id(id);
>>+	if (!dpll_id)
>>+		goto unlock;
>>+	info->user_ptr[0] =3D dpll_id;
>>+	return 0;
>>+unlock:
>>+	mutex_unlock(&dpll_xa_lock);
>>+	return -ENODEV;
>>+}
>>+
>>+void dpll_post_doit(const struct genl_split_ops *ops, struct sk_buff *sk=
b,
>>+		    struct genl_info *info)
>>+{
>>+	mutex_unlock(&dpll_xa_lock);
>>+}
>>+
>>+int dpll_pre_dumpit(struct netlink_callback *cb)
>>+{
>>+	mutex_lock(&dpll_xa_lock);
>>+
>>+	return 0;
>>+}
>>+
>>+int dpll_post_dumpit(struct netlink_callback *cb)
>>+{
>>+	mutex_unlock(&dpll_xa_lock);
>>+
>>+	return 0;
>>+}
>>+
>>+int dpll_pin_pre_doit(const struct genl_split_ops *ops, struct sk_buff *=
skb,
>>+		      struct genl_info *info)
>>+{
>>+	int ret =3D dpll_pre_doit(ops, skb, info);
>>+	struct dpll_pin_ref *pin_ref;
>>+	struct dpll_device *dpll;
>>+
>>+	if (ret)
>>+		return ret;
>>+	dpll =3D info->user_ptr[0];
>>+	if (!info->attrs[DPLL_A_PIN_IDX]) {
>>+		ret =3D -EINVAL;
>>+		goto unlock_dev;
>>+	}
>>+	pin_ref =3D xa_load(&dpll->pin_refs,
>>+			  nla_get_u32(info->attrs[DPLL_A_PIN_IDX]));
>
>This is inconsistent, also incorrect.
>
>You use DPLL_A_ID that is stored in dpll_device_xa as a handle for device.
>That is fine if we consider Jakub's desire to have this randomly
>generated id as a handle (I find is questinable, but can live with it).
>
>But pins are independent on a single DPLL and could be attached to
>multiple ones. Using a single DPLL_A_ID as handle here (dpll_pre_doit)
>for all operations is plain wrong.
>
>For example for frequency or direction set, you don't need it in code as
>you iterate over all attacheds DPLL devices. Confusing to require DPLL
>device handle for that operation when you change setup for all of them.
>That is wrong.
>
>Also, you have global dpll_pin_xa. Yet you don't expose this ID over
>netlink. To be consistent with device handle, you should:
>1) expose pin->id over DPLL_A_PIN_ID
>2) use this DPLL_A_PIN_ID as a sole pin handle for dpll_pin_xa lookup.
>
>For DPLL-PIN tuple operations (prio_set and state_on_dpll_set)
>you should process the dpll device handle (DPLL_A_ID) where it is needed
>In the similar way you process parent id now where is it needed
>(state_on_pin_set)
>
>For GET/DUMP command, this does not also make sense.
>Check out __dpll_cmd_pin_dump_one()
>
>You just use the "first dpll" for the handle. Just use the pin->id as I
>suggested above.
>
>Makes sense?
>
>Please make sure you maintain the same handle attrs in the notification
>messages as well.
>
>

Yeah, with the changes to the other thread, this works now as you described=
.

>
>>+	if (!pin_ref) {
>>+		ret =3D -ENODEV;
>>+		goto unlock_dev;
>>+	}
>>+	info->user_ptr[1] =3D pin_ref->pin;
>>+
>>+	return 0;
>>+
>>+unlock_dev:
>>+	mutex_unlock(&dpll_xa_lock);
>>+	return ret;
>>+}
>>+
>>+void dpll_pin_post_doit(const struct genl_split_ops *ops, struct sk_buff
>>*skb,
>>+			struct genl_info *info)
>>+{
>>+	dpll_post_doit(ops, skb, info);
>>+}
>>+
>>+int dpll_pin_pre_dumpit(struct netlink_callback *cb)
>>+{
>>+	return dpll_pre_dumpit(cb);
>>+}
>>+
>>+int dpll_pin_post_dumpit(struct netlink_callback *cb)
>>+{
>>+	return dpll_post_dumpit(cb);
>>+}
>>+
>>+static int
>>+dpll_event_device_change(struct sk_buff *msg, struct dpll_device *dpll,
>>+			 struct dpll_pin *pin, struct dpll_pin *parent,
>>+			 enum dplla attr)
>>+{
>>+	int ret =3D dpll_msg_add_dev_handle(msg, dpll);
>>+	struct dpll_pin_ref *ref =3D NULL;
>
>Pointless init.
>

Fixed.

>
>>+	enum dpll_pin_state state;
>>+
>>+	if (ret)
>>+		return ret;
>>+	if (pin && nla_put_u32(msg, DPLL_A_PIN_IDX, pin->pin_idx))
>>+		return -EMSGSIZE;
>>+
>>+	switch (attr) {
>>+	case DPLL_A_MODE:
>>+		ret =3D dpll_msg_add_mode(msg, dpll, NULL);
>>+		break;
>>+	case DPLL_A_LOCK_STATUS:
>>+		ret =3D dpll_msg_add_lock_status(msg, dpll, NULL);
>>+		break;
>>+	case DPLL_A_TEMP:
>>+		ret =3D dpll_msg_add_temp(msg, dpll, NULL);
>>+		break;
>>+	case DPLL_A_PIN_FREQUENCY:
>>+		ref =3D xa_load(&pin->dpll_refs, dpll->device_idx);
>>+		if (!ref)
>>+			return -EFAULT;
>>+		ret =3D dpll_msg_add_pin_freq(msg, pin, ref, NULL, false);
>>+		break;
>>+	case DPLL_A_PIN_PRIO:
>>+		ref =3D xa_load(&pin->dpll_refs, dpll->device_idx);
>>+		if (!ref)
>>+			return -EFAULT;
>>+		ret =3D dpll_msg_add_pin_prio(msg, pin, ref, NULL);
>
>Why exactly did you ignore my request I put in the previous version
>review asking to maintain the same nesting scheme for GET cmd and
>notification messages? Honestly, the silent ignores I'm getting
>all along the review of this patchset is very frustrating. Please don't
>do it. Either ack and change or provide exaplanation why your code is
>fine.
>
>So could you please fix this?
>Again, please make sure that the notification messages have attributes
>in exactly the same place as GET cmd (think of it as the rest of the
>attrs in the message is filtered out). Makes possible to use the same
>userspace parsing code both messages.
>
>

Fixed.

>
>>+		break;
>>+	case DPLL_A_PIN_STATE:
>>+		if (parent) {
>>+			const struct dpll_pin_ops *ops;
>>+			void *priv =3D dpll_pin_on_pin_priv(parent, pin);
>>+
>>+			ref =3D xa_load(&pin->parent_refs, parent->pin_idx);
>>+			if (!ref)
>>+				return -EFAULT;
>>+			ops =3D dpll_pin_ops(ref);
>>+			if (!ops->state_on_pin_get)
>>+				return -EOPNOTSUPP;
>>+			ret =3D ops->state_on_pin_get(pin, priv, parent,
>>+						    &state, NULL);
>>+			if (ret)
>>+				return ret;
>>+			if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
>>+					parent->pin_idx))
>>+				return -EMSGSIZE;
>>+		} else {
>>+			ref =3D xa_load(&pin->dpll_refs, dpll->device_idx);
>>+			if (!ref)
>>+				return -EFAULT;
>>+			ret =3D dpll_msg_add_pin_on_dpll_state(msg, pin, ref,
>>+							     NULL);
>>+			if (ret)
>>+				return ret;
>>+		}
>>+		break;
>>+	default:
>>+		break;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static int
>>+dpll_send_event_create(enum dpll_event event, struct dpll_device *dpll)
>>+{
>>+	struct sk_buff *msg;
>>+	int ret =3D -EMSGSIZE;
>>+	void *hdr;
>>+
>>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>+	if (!msg)
>>+		return -ENOMEM;
>>+
>>+	hdr =3D genlmsg_put(msg, 0, 0, &dpll_nl_family, 0, event);
>>+	if (!hdr)
>>+		goto out_free_msg;
>>+
>>+	ret =3D dpll_msg_add_dev_handle(msg, dpll);
>>+	if (ret)
>>+		goto out_cancel_msg;
>>+	genlmsg_end(msg, hdr);
>>+	genlmsg_multicast(&dpll_nl_family, msg, 0, 0, GFP_KERNEL);
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
>>+static int
>>+dpll_send_event_change(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		       struct dpll_pin *parent, enum dplla attr)
>>+{
>>+	struct sk_buff *msg;
>>+	int ret =3D -EMSGSIZE;
>>+	void *hdr;
>>+
>>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>+	if (!msg)
>>+		return -ENOMEM;
>>+
>>+	hdr =3D genlmsg_put(msg, 0, 0, &dpll_nl_family, 0,
>>+			  DPLL_EVENT_DEVICE_CHANGE);
>>+	if (!hdr)
>>+		goto out_free_msg;
>>+
>>+	ret =3D dpll_event_device_change(msg, dpll, pin, parent, attr);
>>+	if (ret)
>>+		goto out_cancel_msg;
>>+	genlmsg_end(msg, hdr);
>>+	genlmsg_multicast(&dpll_nl_family, msg, 0, 0, GFP_KERNEL);
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
>>+	return dpll_send_event_create(DPLL_EVENT_DEVICE_CREATE, dpll);
>>+}
>>+
>>+int dpll_notify_device_delete(struct dpll_device *dpll)
>>+{
>>+	return dpll_send_event_create(DPLL_EVENT_DEVICE_DELETE, dpll);
>
>Quite odd. Consider rename of dpll_send_event_create()
>

This has already changed.

>
>>+}
>>+
>>+int dpll_device_notify(struct dpll_device *dpll, enum dplla attr)
>>+{
>>+	if (WARN_ON(!dpll))
>>+		return -EINVAL;
>>+
>>+	return dpll_send_event_change(dpll, NULL, NULL, attr);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_notify);
>>+
>>+int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		    enum dplla attr)
>>+{
>>+	return dpll_send_event_change(dpll, pin, NULL, attr);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_notify);
>>+
>>+int dpll_pin_parent_notify(struct dpll_device *dpll, struct dpll_pin
>>*pin,
>>+			   struct dpll_pin *parent, enum dplla attr)
>>+{
>>+	return dpll_send_event_change(dpll, pin, parent, attr);
>>+}
>>+
>>+int __init dpll_netlink_init(void)
>>+{
>>+	return genl_register_family(&dpll_nl_family);
>>+}
>>+
>>+void dpll_netlink_finish(void)
>>+{
>>+	genl_unregister_family(&dpll_nl_family);
>>+}
>>+
>>+void __exit dpll_netlink_fini(void)
>>+{
>>+	dpll_netlink_finish();
>>+}
>>diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>>new file mode 100644
>>index 000000000000..952e0335595e
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_netlink.h
>>@@ -0,0 +1,27 @@
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
>>+int dpll_pin_parent_notify(struct dpll_device *dpll, struct dpll_pin *pi=
n,
>>+			   struct dpll_pin *parent, enum dplla attr);
>>+
>>+int __init dpll_netlink_init(void);
>>+void dpll_netlink_finish(void);
>>diff --git a/include/linux/dpll.h b/include/linux/dpll.h
>>new file mode 100644
>>index 000000000000..5194efaf55a8
>>--- /dev/null
>>+++ b/include/linux/dpll.h
>>@@ -0,0 +1,274 @@
>>+/* SPDX-License-Identifier: GPL-2.0 */
>>+/*
>>+ *  Copyright (c) 2023 Meta Platforms, Inc. and affiliates
>>+ *  Copyright (c) 2023 Intel and affiliates
>>+ */
>>+
>>+#ifndef __DPLL_H__
>>+#define __DPLL_H__
>>+
>>+#include <uapi/linux/dpll.h>
>>+#include <linux/device.h>
>>+#include <linux/netlink.h>
>>+
>>+struct dpll_device;
>>+struct dpll_pin;
>>+
>>+struct dpll_device_ops {
>>+	int (*mode_get)(const struct dpll_device *dpll, void *dpll_priv,
>>+			enum dpll_mode *mode, struct netlink_ext_ack *extack);
>>+	int (*mode_set)(const struct dpll_device *dpll, void *dpll_priv,
>>+			const enum dpll_mode mode,
>>+			struct netlink_ext_ack *extack);
>>+	bool (*mode_supported)(const struct dpll_device *dpll, void *dpll_priv,
>>+			       const enum dpll_mode mode,
>>+			       struct netlink_ext_ack *extack);
>>+	int (*source_pin_idx_get)(const struct dpll_device *dpll,
>>+				  void *dpll_priv,
>>+				  u32 *pin_idx,
>>+				  struct netlink_ext_ack *extack);
>>+	int (*lock_status_get)(const struct dpll_device *dpll, void *dpll_priv,
>>+			       enum dpll_lock_status *status,
>>+			       struct netlink_ext_ack *extack);
>>+	int (*temp_get)(const struct dpll_device *dpll, void *dpll_priv,
>>+			s32 *temp, struct netlink_ext_ack *extack);
>>+};
>>+
>>+struct dpll_pin_ops {
>>+	int (*frequency_set)(const struct dpll_pin *pin, void *pin_priv,
>>+			     const struct dpll_device *dpll, void *dpll_priv,
>>+			     const u64 frequency,
>>+			     struct netlink_ext_ack *extack);
>>+	int (*frequency_get)(const struct dpll_pin *pin, void *pin_priv,
>>+			     const struct dpll_device *dpll, void *dpll_priv,
>>+			     u64 *frequency, struct netlink_ext_ack *extack);
>>+	int (*direction_set)(const struct dpll_pin *pin, void *pin_priv,
>>+			     const struct dpll_device *dpll, void *dpll_priv,
>>+			     const enum dpll_pin_direction direction,
>>+			     struct netlink_ext_ack *extack);
>>+	int (*direction_get)(const struct dpll_pin *pin, void *pin_priv,
>>+			     const struct dpll_device *dpll, void *dpll_priv,
>>+			     enum dpll_pin_direction *direction,
>>+			     struct netlink_ext_ack *extack);
>>+	int (*state_on_pin_get)(const struct dpll_pin *pin, void *pin_priv,
>>+				const struct dpll_pin *parent_pin,
>>+				enum dpll_pin_state *state,
>>+				struct netlink_ext_ack *extack);
>>+	int (*state_on_dpll_get)(const struct dpll_pin *pin, void *pin_priv,
>>+				 const struct dpll_device *dpll,
>>+				 void *dpll_priv, enum dpll_pin_state *state,
>>+				 struct netlink_ext_ack *extack);
>>+	int (*state_on_pin_set)(const struct dpll_pin *pin, void *pin_priv,
>>+				const struct dpll_pin *parent_pin,
>>+				const enum dpll_pin_state state,
>>+				struct netlink_ext_ack *extack);
>>+	int (*state_on_dpll_set)(const struct dpll_pin *pin, void *pin_priv,
>>+				 const struct dpll_device *dpll,
>>+				 void *dpll_priv,
>>+				 const enum dpll_pin_state state,
>>+				 struct netlink_ext_ack *extack);
>>+	int (*prio_get)(const struct dpll_pin *pin,  void *pin_priv,
>>+			const struct dpll_device *dpll,  void *dpll_priv,
>>+			u32 *prio, struct netlink_ext_ack *extack);
>>+	int (*prio_set)(const struct dpll_pin *pin, void *pin_priv,
>>+			const struct dpll_device *dpll, void *dpll_priv,
>>+			const u32 prio, struct netlink_ext_ack *extack);
>>+};
>>+
>>+struct dpll_pin_frequency {
>>+	u64 min;
>>+	u64 max;
>>+};
>>+
>>+#define DPLL_PIN_FREQUENCY_RANGE(_min, _max)	\
>>+	{					\
>>+		.min =3D _min,			\
>>+		.max =3D _max,			\
>>+	}
>>+
>>+#define DPLL_PIN_FREQUENCY(_val) DPLL_PIN_FREQUENCY_RANGE(_val, _val)
>>+#define DPLL_PIN_FREQUENCY_1PPS \
>>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_1_HZ)
>>+#define DPLL_PIN_FREQUENCY_10MHZ \
>>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_10_MHZ)
>>+#define DPLL_PIN_FREQUENCY_IRIG_B \
>>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_10_KHZ)
>>+#define DPLL_PIN_FREQUENCY_DCF77 \
>>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_77_5_KHZ)
>>+
>>+struct dpll_pin_properties {
>>+	const char *label;
>>+	enum dpll_pin_type type;
>>+	unsigned long capabilities;
>>+	u32 freq_supported_num;
>>+	struct dpll_pin_frequency *freq_supported;
>>+};
>>+
>>+/**
>>+ * dpll_device_get - find or create dpll_device object
>>+ * @clock_id: a system unique number for a device
>>+ * @dev_driver_id: index of dpll device on parent device
>>+ * @module: register module
>>+ *
>>+ * Returns:
>>+ * * pointer to initialized dpll - success
>>+ * * NULL - memory allocation fail
>>+ */
>>+struct dpll_device
>>+*dpll_device_get(u64 clock_id, u32 dev_driver_id, struct module *module)=
;
>>+
>>+/**
>>+ * dpll_device_put - caller drops reference to the device, free resource=
s
>>+ * @dpll: dpll device pointer
>>+ *
>>+ * If all dpll_device_get callers drops their reference, the dpll device
>>+ * resources are freed.
>>+ */
>>+void dpll_device_put(struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_device_register - register device, make it visible in the
>>subsystem.
>>+ * @dpll: reference previously allocated with dpll_device_get
>>+ * @type: type of dpll
>>+ * @ops: callbacks
>>+ * @priv: private data of registerer
>>+ * @owner: device struct of the owner
>>+ *
>>+ */
>>+int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
>>+			 const struct dpll_device_ops *ops, void *priv,
>>+			 struct device *owner);
>>+
>>+/**
>>+ * dpll_device_unregister - deregister registered dpll
>>+ * @dpll: pointer to dpll
>>+ * @ops: ops for a dpll device
>>+ * @priv: pointer to private information of owner
>>+ *
>>+ * Unregister the dpll from the subsystem, make it unavailable for netli=
nk
>>+ * API users.
>>+ */
>>+void dpll_device_unregister(struct dpll_device *dpll,
>>+			    const struct dpll_device_ops *ops, void *priv);
>>+
>>+/**
>>+ * dpll_pin_get - get reference or create new pin object
>>+ * @clock_id: a system unique number of a device
>>+ * @@dev_driver_id: index of dpll device on parent device
>>+ * @module: register module
>>+ * @pin_prop: constant properities of a pin
>>+ *
>>+ * find existing pin with given clock_id, @dev_driver_id and module, or
>>create new
>>+ * and returen its reference.
>>+ *
>>+ * Returns:
>>+ * * pointer to initialized pin - success
>>+ * * NULL - memory allocation fail
>>+ */
>>+struct dpll_pin
>>+*dpll_pin_get(u64 clock_id, u32 dev_driver_id, struct module *module,
>>+	      const struct dpll_pin_properties *prop);
>>+
>>+/**
>>+ * dpll_pin_register - register pin with a dpll device
>>+ * @dpll: pointer to dpll object to register pin with
>>+ * @pin: pointer to allocated pin object being registered with dpll
>>+ * @ops: struct with pin ops callbacks
>>+ * @priv: private data pointer passed when calling callback ops
>>+ * @rclk_device: pointer to device struct if pin is used for recovery of
>>a clock
>>+ * from that device
>>+ *
>>+ * Register previously allocated pin object with a dpll device.
>>+ *
>>+ * Return:
>>+ * * 0 - if pin was registered with a parent pin,
>>+ * * -ENOMEM - failed to allocate memory,
>>+ * * -EEXIST - pin already registered with this dpll,
>>+ * * -EBUSY - couldn't allocate id for a pin.
>>+ */
>
>I don't follow. In one of the previous version reviews I asked if you
>can have the function docs only in one place, preferably in .c. But you
>have there here in .h as well. Why? They are inconsistent. Could you
>please remove them from .h?
>

Fixed.

>
>
>>+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		      const struct dpll_pin_ops *ops, void *priv,
>>+		      struct device *rclk_device);
>
>As I asked in the previous version, could you please remove this
>rclk_device
>pointer. This is replaced by my patch allowing to expose dpll pin for
>netdev over RTnetlink.
>
>

Fixed.

>
>>+
>>+/**
>>+ * dpll_pin_unregister - deregister pin from a dpll device
>>+ * @dpll: pointer to dpll object to deregister pin from
>>+ * @pin: pointer to allocated pin object being deregistered from dpll
>>+ * @ops: ops for a dpll pin ops
>>+ * @priv: pointer to private information of owner
>>+ *
>>+ * Deregister previously registered pin object from a dpll device.
>>+ *
>>+ */
>>+void dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
>>+			 const struct dpll_pin_ops *ops, void *priv);
>>+
>>+/**
>>+ * dpll_pin_put - drop reference to a pin acquired with dpll_pin_get
>>+ * @pin: pointer to allocated pin
>>+ *
>>+ * Pins shall be deregistered from all dpll devices before putting them,
>>+ * otherwise the memory won't be freed.
>>+ */
>>+void dpll_pin_put(struct dpll_pin *pin);
>>+
>>+/**
>>+ * dpll_pin_on_pin_register - register a pin to a muxed-type pin
>>+ * @parent: parent pin pointer
>>+ * @pin: pointer to allocated pin object being registered with a parent =
pin
>>+ * @ops: struct with pin ops callbacks
>>+ * @priv: private data pointer passed when calling callback ops
>>+ * @rclk_device: pointer to device struct if pin is used for recovery of
>>a clock
>>+ * from that device
>>+ *
>>+ * In case of multiplexed pins, allows registring them under a single
>>+ * parent pin.
>>+ *
>>+ * Return:
>>+ * * 0 - if pin was registered with a parent pin,
>>+ * * -ENOMEM - failed to allocate memory,
>>+ * * -EEXIST - pin already registered with this parent pin,
>>+ */
>>+int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *p=
in,
>>+			     const struct dpll_pin_ops *ops, void *priv,
>>+			     struct device *rclk_device);
>>+
>>+/**
>>+ * dpll_pin_on_pin_register - register a pin to a muxed-type pin
>>+ * @parent: parent pin pointer
>>+ * @pin: pointer to allocated pin object being registered with a parent =
pin
>>+ * @ops: struct with pin ops callbacks
>>+ * @priv: private data pointer passed when calling callback ops
>>+ * @rclk_device: pointer to device struct if pin is used for recovery of
>>a clock
>>+ * from that device
>>+ *
>>+ * In case of multiplexed pins, allows registring them under a single
>>+ * parent pin.
>>+ *
>>+ * Return:
>>+ * * 0 - if pin was registered with a parent pin,
>>+ * * -ENOMEM - failed to allocate memory,
>>+ * * -EEXIST - pin already registered with this parent pin,
>>+ */
>>+void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin
>>*pin,
>>+				const struct dpll_pin_ops *ops, void *priv);
>>+
>>+/**
>>+ * dpll_device_notify - notify on dpll device change
>>+ * @dpll: dpll device pointer
>>+ * @attr: changed attribute
>>+ *
>>+ * Broadcast event to the netlink multicast registered listeners.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error
>>+ */
>>+int dpll_device_notify(struct dpll_device *dpll, enum dplla attr);
>>+
>>+int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		    enum dplla attr);
>>+
>>+
>>+
>>+#endif
>>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>>index e188bc189754..75eeaa4396eb 100644
>>--- a/include/uapi/linux/dpll.h
>>+++ b/include/uapi/linux/dpll.h
>>@@ -111,6 +111,8 @@ enum dpll_pin_direction {
>>
>> #define DPLL_PIN_FREQUENCY_1_HZ		1
>> #define DPLL_PIN_FREQUENCY_10_MHZ	10000000
>>+#define DPLL_PIN_FREQUENCY_10_KHZ	10000
>>+#define DPLL_PIN_FREQUENCY_77_5_KHZ	77500
>>
>> /**
>>  * enum dpll_pin_state - defines possible states of a pin, valid values =
for
>>--
>>2.34.1
>>

