Return-Path: <netdev+bounces-1685-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A8F6FECF8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:38:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 709CF2814BB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5604981F;
	Thu, 11 May 2023 07:38:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4260F371
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:38:17 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1491BF7;
	Thu, 11 May 2023 00:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683790693; x=1715326693;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OjuvdutZtyZ4ASxikVwyJo5mpFOAp1yWDIMRHoTWGUQ=;
  b=lXrDue5et/HYC4FddVmwl8DZpdWVdyYLAJXPJ/qph/f1aSVsZCbCtC6c
   pVIUaMQBgXqPb1S0GxdDesqWrvYWm0hNhzn8gOWi0ucPUshPibZExbMoO
   T/UTPrk0IlLyMTamWOJ5z1jRV3lMMj668Ny2mcoV9+u6FdUPh/6bN0A1R
   /XvwGRJ7zL3F4fetMykY+WLkQQs2oxisc4qilUT2Ey00jMiQw7+VfSxTC
   7Qf1JnLUFWVdOOEG1O6hlxgP/Cl/Bgq3gFr6o4usFp5U3SUuT/rO7ThvT
   8CCZN47v7cOEZPWWL39A092kBAcT/mHkq/m26dCENgr+KOh3GcJ70r96M
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334904567"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334904567"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:38:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="699607928"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699607928"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 11 May 2023 00:38:09 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 00:38:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 00:38:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 00:38:08 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 00:38:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3Fb9s/BA5StPlaPbqQqcgA91PmQgBBucQU9Kv59UZp1/BCAzwKlpjIseddiev6RNS9hZM0vK2Ce2ssbbl3eBN5N7gC6VGE4uysuE1GC9sEiRZEFRX77geUYEXB5faPtC4UKqrfnPmEllJjx1KTuu9U3cE9QJAxTAYcI3D2L4HtzlIJW7zwLXBA4yXMcSQUnY+6uScegAbf6S9ZqBV2CYgoM7dWuD0hYQmtlknaQ9jUHX988l+rFKQeoSfiEcDOS04ECmnoB6E8Vv16Q7vpxjK2afw6/Fn6mMApBEraruASe/sV5cnu3tReceHn+jaVwFKKVdqwwTgDiSAQRozd+Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0jTHWEwOsefEm69eZsvIuqi5y2uOazByDv0Z8YdylQ=;
 b=VeHlmdpwOQ76wUZZ0p316DzAcuB9fHmNUtQj9juPWx2m4h4ZrSTPlugZfKkj5lGoh51HU+DNAoaQjvcDXua7e5e/PSqi6o4ieSu6OowrBp82FkZX+KYagzPpHQlFxuswBDIuOHT71zGRilvpWf0+zPK+sQJPzYNk7WLFw0Baz+HHCw+YL5l4IDi8hsFPCuoRYijtRxNajHeKpEcQFhh60IPJcopPAG5vZ8HpI3xtNtRT3wrRknhuNxO4k/MbQi60JZySJPpnT1esTPMOpnAzzWyJjz7NQuTnv9u38wpHXbLWipItCYQY8LJEJ43ELbAfo30neZWHlWF4Qj8yVBiWSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4664.namprd11.prod.outlook.com (2603:10b6:208:26e::24)
 by SA2PR11MB4811.namprd11.prod.outlook.com (2603:10b6:806:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 07:38:05 +0000
Received: from MN2PR11MB4664.namprd11.prod.outlook.com
 ([fe80::62d1:43b3:3184:9824]) by MN2PR11MB4664.namprd11.prod.outlook.com
 ([fe80::62d1:43b3:3184:9824%7]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 07:38:04 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC: Jakub Kicinski <kuba@kernel.org>, Jonathan Lemon
	<jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, "Olech, Milena"
	<milena.olech@intel.com>, "Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZeWdNus9yie+T1ke/i4FdVA4f5K9KDcsAgAGJJEA=
Date: Thu, 11 May 2023 07:38:04 +0000
Message-ID: <MN2PR11MB466446F5594B3D90C7927E719B749@MN2PR11MB4664.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-2-vadfed@meta.com> <ZFOe1sMFtAOwSXuO@nanopsycho>
In-Reply-To: <ZFOe1sMFtAOwSXuO@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4664:EE_|SA2PR11MB4811:EE_
x-ms-office365-filtering-correlation-id: 5c7f87e1-8082-48c3-1b98-08db51f2a807
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IdbEiuUMGQtraWDw2wq540vHrIXhSI/FQEMwZjiKxNoC0rGGn8c7/B/AtEmxNOJUQHA0OmsPHSAP5zU2Azim0jT4/kF1Fw/vf/hod3bLHCRfR8mE6GR/6c5R2YKu8opYwBvPmD/tOYr5FGuMcrdXbh0hiH6pcxnGAWnmNe9n1T5/UDMuRIwP02/CEPkv+mqjouvkPVZ4SnUIXmm7BYkbkIboT14xFTmEEfwdPRPPGY49QPsqn5LXi01/Y2Iq0rjh+t7MffO6J8OeZD4iPDwnceBNH/wGvzdFerz8iBfmmEokcbLEV9u+JBcrETFVADWW7EkrdeheOJ5wi+sEAC2HIiHvX0Q+O1FKxcjfVo+iCLo5CeZp8n6AsVpDyJftUpLNMO8O+q6ciAZstp6kHg1gju+h31aEY8i6Cgv55cXALAOx17iUbAFT0qCqIogUpfala8LsQ+lN9K5q7eNRL3vjMHBQil4CJvBMqgmB3MCdsc/FOvuVJhmPoJzO4HE1JF0GivW2ITwcSp+E50wFboOW6E+ixRr/QzdsI6pgGdFSrsIjxdWpMwhCglwIog/8wWuvxS4JtsIpXWEe4HwOonyzP1TeovyjkYY5RSnImkk8gcTjzApO6UA2zkWz9fp6NOte
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4664.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199021)(4326008)(82960400001)(54906003)(110136005)(316002)(76116006)(83380400001)(52536014)(5660300002)(30864003)(2906002)(41300700001)(71200400001)(66446008)(66476007)(7696005)(66556008)(86362001)(66946007)(122000001)(64756008)(33656002)(26005)(6506007)(9686003)(38100700002)(8676002)(8936002)(55016003)(186003)(38070700005)(7416002)(478600001)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2HkK4qYLdPnGiA+MD7qclShRTFpFOR9uikhKtd3D55C4R6iEkWdjqvyNFpUy?=
 =?us-ascii?Q?kK22bLp1m7oUnAuCvZh7O8fo741IhHAauoqaBhfYpzDZt7MP1hYTtlkzm77/?=
 =?us-ascii?Q?DfKvOfRpP+0r5LZtx60Ri8QmFMW5SbClPD+Uo0sChjRHPR5pnRthx9L+BbNQ?=
 =?us-ascii?Q?5sKoBio70AYXxHk/KKASKczMoiwLZgK0XyY18YcYsvUAnH9cCSkfIqHlZvXc?=
 =?us-ascii?Q?Q44plGFs7IRi2WrvHEH+NbXDK605ZOxpjMGgfuUPLXLTPVjdQNhKTIuymN7B?=
 =?us-ascii?Q?p333KNp88Qka/Tkouh28UHof8Xs96D1/YjjpdRPgkykXAl+XibvCz+cYlwAD?=
 =?us-ascii?Q?aWHThC5RuxgZqblGwqMPgOx1XyGiWFQjM449xE1eKncuYg1pCXJduC9tcTn6?=
 =?us-ascii?Q?THZk6UCMJL1vH/acOzSmEF4ImMcm/ZrLjPgzjVesER+ZWLVNlJKNAn+tOqwd?=
 =?us-ascii?Q?/tL79bjyp/sbDI5e8KIpGbRHsbCULPUog39cRvl6XO5Ia4JdV+ZNYcKLc2/V?=
 =?us-ascii?Q?SsVOv4MWnbFjhckcvIuyK2soTitP+qSzFFVbybMqTsnj/DR5jjk7U4Eg4E9H?=
 =?us-ascii?Q?oSUcWzVcUqh+SAc/yLqdnQuqO74n3ntY4EwbJ4CqYLEwQ2dJ/Zx2wP1sW71K?=
 =?us-ascii?Q?P1yuJfpoD0aYGtMV2Rc+kYvkGE/SXFJxuO3Ctk75f8Dz3PWxgvAz1lH9kHXh?=
 =?us-ascii?Q?Nx1lK24x2Oflbj6SOgs+GX2ovI6Aee0VJtB6f5xdq55nhhTdrNs1DIj3mFCn?=
 =?us-ascii?Q?H5325ZgSoVv9RPnKG6kIoWaGImT8KuoSFW7mV5LJVlFD9Al2LutmAb2L+/D+?=
 =?us-ascii?Q?XYZjgn47UqKYcDzHk/mmA0RX98yVYCNmsFm0icIroy4CtysEvlakol8k3OiK?=
 =?us-ascii?Q?ObxOA457gG+qHNhJIAgTUwKl25q1BQFapmj8+YoV2m9mCBaFRuQ574xHFKKj?=
 =?us-ascii?Q?5gQyBul/6bXvjdHglE37DD+Lt2xWuAuUC8BdoIxHA0T6T+W65+gWGjZtQkQX?=
 =?us-ascii?Q?si7YKBqsXkFbsaemx9rCHkZiROLT5LGSyxyA6EgZeDp/82sCZ1nUBMx2GUkK?=
 =?us-ascii?Q?s7b/IhKz/1v6c6z70g+SZQyKuRGvqLYN5VtRHEf4pSk4J64S5+Qx3MHGJ8nh?=
 =?us-ascii?Q?Wv3E3Btk2XvbRNVwm9KUGWUUgJ3FPlpOdtCnHp/TzTNb7NXLDTI91JZgG22r?=
 =?us-ascii?Q?49DrYaXTDLbR785qzrPPZ9Y52uNiLu58odMHuHso/bAOXBPXw6CE2sKYmUCJ?=
 =?us-ascii?Q?hUqaTE48b4TDfjMKXhdhTz3M+Sep0IKNuob3FqJW/crCX2DzBs20Rk+9FmGi?=
 =?us-ascii?Q?g47dAP6dmGvwOhzZjTwhs9YIXAUYd0xBfNdLASxWHkA3PtNiXCTIyZOPbmNe?=
 =?us-ascii?Q?iJM4+Gnl5mDgpt5WTv/gy0hqVfpmM95nL1IME7Bvh7ryl/1iwxilMw4Uo1ra?=
 =?us-ascii?Q?dHGc+r6t6gJQ9Y3I8Pkx7o84fzs2tutyKkrp9GdGq60640bBj9QlcBvNjks5?=
 =?us-ascii?Q?sMNJQNBvmsf0Pq4kAIIDUmM4CAEdHqmjozQZU2jKzRpx21tUo8YAgMO7Blh6?=
 =?us-ascii?Q?w9p8oDppRjik9D7hNblZW2HU/+/pwCOBm0s3khQza8thQWPDSXuueS42z0Si?=
 =?us-ascii?Q?OQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4664.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7f87e1-8082-48c3-1b98-08db51f2a807
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 07:38:04.5630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1LjFDgiTXMQo0GzrcPrbWYr7iR6iSdKEvZPWaZ+a7ZdsRTxiSu0qpF5ikg0G13eLPCy9yh3hJ0ax3LzKNY42pyr02k4qWerBAgT6/zax24Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4811
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Thursday, May 4, 2023 2:03 PM
>
>Fri, Apr 28, 2023 at 02:20:02AM CEST, vadfed@meta.com wrote:
>>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>
>>Add a protocol spec for DPLL.
>>Add code generated from the spec.
>>
>>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>>---
>> Documentation/netlink/specs/dpll.yaml | 472 ++++++++++++++++++++++++++
>> drivers/dpll/dpll_nl.c                | 126 +++++++
>> drivers/dpll/dpll_nl.h                |  42 +++
>> include/uapi/linux/dpll.h             | 202 +++++++++++
>> 4 files changed, 842 insertions(+)
>> create mode 100644 Documentation/netlink/specs/dpll.yaml
>> create mode 100644 drivers/dpll/dpll_nl.c
>> create mode 100644 drivers/dpll/dpll_nl.h
>> create mode 100644 include/uapi/linux/dpll.h
>>
>>diff --git a/Documentation/netlink/specs/dpll.yaml
>>b/Documentation/netlink/specs/dpll.yaml
>>new file mode 100644
>>index 000000000000..67ca0f6cf2d5
>>--- /dev/null
>>+++ b/Documentation/netlink/specs/dpll.yaml
>>@@ -0,0 +1,472 @@
>>+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-
>>Clause)
>>+
>>+name: dpll
>>+
>>+doc: DPLL subsystem.
>>+
>>+definitions:
>>+  -
>>+    type: enum
>>+    name: mode
>>+    doc: |
>>+      working-modes a dpll can support, differentiate if and how dpll
>>selects
>>+      one of its sources to syntonize with it, valid values for DPLL_A_M=
ODE
>>+      attribute
>>+    entries:
>>+      -
>>+        name: unspec
>
>In general, why exactly do we need unspec values in enums and CMDs?
>What is the usecase. If there isn't please remove.
>

Sure, fixed.

>
>>+        doc: unspecified value
>>+      -
>>+        name: manual
>>+        doc: source can be only selected by sending a request to dpll
>>+      -
>>+        name: automatic
>>+        doc: highest prio, valid source, auto selected by dpll
>>+      -
>>+        name: holdover
>>+        doc: dpll forced into holdover mode
>>+      -
>>+        name: freerun
>>+        doc: dpll driven on system clk, no holdover available
>
>Remove "no holdover available". This is not a state, this is a mode
>configuration. If holdover is or isn't available, is a runtime info.
>

Fiexd.

>
>>+      -
>>+        name: nco
>>+        doc: dpll driven by Numerically Controlled Oscillator
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: lock-status
>>+    doc: |
>>+      provides information of dpll device lock status, valid values for
>>+      DPLL_A_LOCK_STATUS attribute
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: unspecified value
>>+      -
>>+        name: unlocked
>>+        doc: |
>>+          dpll was not yet locked to any valid source (or is in one of
>>+          modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>>+      -
>>+        name: calibrating
>>+        doc: dpll is trying to lock to a valid signal
>>+      -
>>+        name: locked
>>+        doc: dpll is locked
>>+      -
>>+        name: holdover
>>+        doc: |
>>+          dpll is in holdover state - lost a valid lock or was forced by
>>+          selecting DPLL_MODE_HOLDOVER mode
>
>Is it needed to mention the holdover mode. It's slightly confusing,
>because user might understand that the lock-status is always "holdover"
>in case of "holdover" mode. But it could be "unlocked", can't it?
>Perhaps I don't understand the flows there correctly :/
>

Yes, it could be unlocked even when user requests the 'holdover' mode, i.e.
when the dpll was not locked to a valid source before requesting the mode.
Improved the docs:
        name: holdover
        doc: |
          dpll is in holdover state - lost a valid lock or was forced
          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
	  if it was not, the dpll's lock-status will remain
          DPLL_LOCK_STATUS_UNLOCKED even if user requests
          DPLL_MODE_HOLDOVER)
Is that better?

>
>>+    render-max: true
>>+  -
>>+    type: const
>>+    name: temp-divider
>>+    value: 10
>>+    doc: |
>>+      temperature divider allowing userspace to calculate the
>>+      temperature as float with single digit precision.
>>+      Value of (DPLL_A_TEMP / DPLL_TEMP_DIVIDER) is integer part of
>>+      tempearture value.
>
>s/tempearture/temperature/
>
>Didn't checkpatch warn you?
>

Fixed, thanks!
No, I don't think it did.

>
>>+      Value of (DPLL_A_TEMP % DPLL_TEMP_DIVIDER) is fractional part of
>>+      temperature value.
>>+  -
>>+    type: enum
>>+    name: type
>>+    doc: type of dpll, valid values for DPLL_A_TYPE attribute
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: unspecified value
>>+      -
>>+        name: pps
>>+        doc: dpll produces Pulse-Per-Second signal
>>+      -
>>+        name: eec
>>+        doc: dpll drives the Ethernet Equipment Clock
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: pin-type
>>+    doc: |
>>+      defines possible types of a pin, valid values for DPLL_A_PIN_TYPE
>>+      attribute
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: unspecified value
>>+      -
>>+        name: mux
>>+        doc: aggregates another layer of selectable pins
>>+      -
>>+        name: ext
>>+        doc: external source
>>+      -
>>+        name: synce-eth-port
>>+        doc: ethernet port PHY's recovered clock
>>+      -
>>+        name: int-oscillator
>>+        doc: device internal oscillator
>
>Is this somehow related to the mode "nco" (Numerically Controlled
>Oscillator)?
>

Yes.

>
>
>>+      -
>>+        name: gnss
>>+        doc: GNSS recovered clock
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: pin-direction
>>+    doc: |
>>+      defines possible direction of a pin, valid values for
>>+      DPLL_A_PIN_DIRECTION attribute
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: unspecified value
>>+      -
>>+        name: source
>>+        doc: pin used as a source of a signal
>>+      -
>>+        name: output
>>+        doc: pin used to output the signal
>>+    render-max: true
>>+  -
>>+    type: const
>>+    name: pin-frequency-1-hz
>>+    value: 1
>>+  -
>>+    type: const
>>+    name: pin-frequency-10-mhz
>>+    value: 10000000
>>+  -
>>+    type: enum
>>+    name: pin-state
>>+    doc: |
>>+      defines possible states of a pin, valid values for
>>+      DPLL_A_PIN_STATE attribute
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: unspecified value
>>+      -
>>+        name: connected
>>+        doc: pin connected, active source of phase locked loop
>>+      -
>>+        name: disconnected
>>+        doc: pin disconnected, not considered as a valid source
>>+      -
>>+        name: selectable
>>+        doc: pin enabled for automatic source selection
>>+    render-max: true
>>+  -
>>+    type: flags
>>+    name: pin-caps
>>+    doc: |
>>+      defines possible capabilities of a pin, valid flags on
>>+      DPLL_A_PIN_CAPS attribute
>>+    entries:
>>+      -
>>+        name: direction-can-change
>>+      -
>>+        name: priority-can-change
>>+      -
>>+        name: state-can-change
>>+  -
>>+    type: enum
>>+    name: event
>>+    doc: events of dpll generic netlink family
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: invalid event type
>>+      -
>>+        name: device-create
>>+        doc: dpll device created
>>+      -
>>+        name: device-delete
>>+        doc: dpll device deleted
>>+      -
>>+        name: device-change
>
>Please have a separate create/delete/change values for pins.
>

Makes sense, but details, pin creation doesn't occur from uAPI perspective,
as the pins itself are not visible to the user. They are visible after they
are registered with a device, thus we would have to do something like:
- pin-register
- pin-unregister
- pin-change

Does it make sense?

>
>>+        doc: |
>>+          attribute of dpll device or pin changed, reason is to be found
>>with
>>+          an attribute type (DPLL_A_*) received with the event
>>+
>>+
>>+attribute-sets:
>>+  -
>>+    name: dpll
>>+    enum-name: dplla
>>+    attributes:
>>+      -
>>+        name: device
>>+        type: nest
>>+        value: 1
>
>Why not 0?
>

Sorry I don't recall what exact technical reasons are behind it, but all
netlink attributes I have found have 0 value attribute unused/unspec.

>Also, Plese don't have this attr as a first one. It is related to
>PIN_GET/SET cmd, it should be somewhere among related attributes.
>
>Definitelly, the handle ATTR/ATTTs should be the first one/ones.
>

Sure, fixed.

>
>
>>+        multi-attr: true
>>+        nested-attributes: device
>>+      -
>>+        name: id
>>+        type: u32
>>+      -
>>+        name: dev-name
>>+        type: string
>>+      -
>>+        name: bus-name
>>+        type: string
>>+      -
>>+        name: mode
>>+        type: u8
>>+        enum: mode
>>+      -
>>+        name: mode-supported
>>+        type: u8
>>+        enum: mode
>>+        multi-attr: true
>>+      -
>>+        name: lock-status
>>+        type: u8
>>+        enum: lock-status
>>+      -
>>+        name: temp
>>+        type: s32
>>+      -
>>+        name: clock-id
>>+        type: u64
>>+      -
>>+        name: type
>>+        type: u8
>>+        enum: type
>>+      -
>>+        name: pin-idx
>>+        type: u32
>>+      -
>>+        name: pin-label
>>+        type: string
>>+      -
>>+        name: pin-type
>>+        type: u8
>>+        enum: pin-type
>>+      -
>>+        name: pin-direction
>>+        type: u8
>>+        enum: pin-direction
>>+      -
>>+        name: pin-frequency
>>+        type: u64
>>+      -
>>+        name: pin-frequency-supported
>>+        type: nest
>>+        multi-attr: true
>>+        nested-attributes: pin-frequency-range
>>+      -
>>+        name: pin-frequency-min
>>+        type: u64
>>+      -
>>+        name: pin-frequency-max
>>+        type: u64
>>+      -
>>+        name: pin-prio
>>+        type: u32
>>+      -
>>+        name: pin-state
>>+        type: u8
>>+        enum: pin-state
>>+      -
>>+        name: pin-parent
>>+        type: nest
>>+        multi-attr: true
>>+        nested-attributes: pin-parent
>>+      -
>>+        name: pin-parent-idx
>>+        type: u32
>>+      -
>>+        name: pin-rclk-device
>>+        type: string
>>+      -
>>+        name: pin-dpll-caps
>>+        type: u32
>>+  -
>>+    name: device
>>+    subset-of: dpll
>>+    attributes:
>>+      -
>>+        name: id
>>+        type: u32
>>+        value: 2
>>+      -
>>+        name: dev-name
>>+        type: string
>>+      -
>>+        name: bus-name
>>+        type: string
>>+      -
>>+        name: mode
>>+        type: u8
>>+        enum: mode
>>+      -
>>+        name: mode-supported
>>+        type: u8
>>+        enum: mode
>>+        multi-attr: true
>>+      -
>>+        name: lock-status
>>+        type: u8
>>+        enum: lock-status
>>+      -
>>+        name: temp
>>+        type: s32
>>+      -
>>+        name: clock-id
>>+        type: u64
>>+      -
>>+        name: type
>>+        type: u8
>>+        enum: type
>>+      -
>>+        name: pin-prio
>>+        type: u32
>>+        value: 19
>
>Do you still need to pass values for a subset? That is odd. Well, I
>think is is odd to pass anything other than names in subset definition,
>the rest of the info is in the original attribute set definition,
>isn't it?
>Jakub?
>

Yes it is fixed, I will remove those.

>
>>+      -
>>+        name: pin-state
>>+        type: u8
>>+        enum: pin-state
>>+  -
>>+    name: pin-parent
>>+    subset-of: dpll
>>+    attributes:
>>+      -
>>+        name: pin-state
>>+        type: u8
>>+        value: 20
>>+        enum: pin-state
>>+      -
>>+        name: pin-parent-idx
>>+        type: u32
>>+        value: 22
>>+      -
>>+        name: pin-rclk-device
>>+        type: string
>>+  -
>>+    name: pin-frequency-range
>>+    subset-of: dpll
>>+    attributes:
>>+      -
>>+        name: pin-frequency-min
>>+        type: u64
>>+        value: 17
>>+      -
>>+        name: pin-frequency-max
>>+        type: u64
>>+
>>+operations:
>>+  list:
>>+    -
>>+      name: unspec
>>+      doc: unused
>>+
>>+    -
>>+      name: device-get
>>+      doc: |
>>+        Get list of DPLL devices (dump) or attributes of a single dpll
>>device
>>+      attribute-set: dpll
>>+      flags: [ admin-perm ]
>
>I may be missing something, but why do you enforce adming perm for
>get/dump cmds?
>

Yes, security reasons, we don't want regular users to spam-query the driver
ops. Also explained in docs:
All netlink commands require ``GENL_ADMIN_PERM``. This is to prevent
any spamming/D.o.S. from unauthorized userspace applications.

>
>>+
>>+      do:
>>+        pre: dpll-pre-doit
>>+        post: dpll-post-doit
>>+        request:
>>+          attributes:
>>+            - id
>>+            - bus-name
>>+            - dev-name
>>+        reply:
>>+          attributes:
>>+            - device
>>+
>>+      dump:
>>+        pre: dpll-pre-dumpit
>>+        post: dpll-post-dumpit
>>+        reply:
>>+          attributes:
>>+            - device
>
>I might be missing something, but this means "device" netdev attribute
>DPLL_A_DEVICE, right? If yes, that is incorrect and you should list all
>the device attrs.
>

Actually this means that attributes expected in response to this command ar=
e
from `device` subset.
But I see your point, will make `device` subset only for pin's nested
attributes, and here will list device attributes.

>
>>+
>>+    -
>>+      name: device-set
>>+      doc: Set attributes for a DPLL device
>>+      attribute-set: dpll
>>+      flags: [ admin-perm ]
>>+
>>+      do:
>>+        pre: dpll-pre-doit
>>+        post: dpll-post-doit
>>+        request:
>>+          attributes:
>>+            - id
>>+            - bus-name
>>+            - dev-name
>>+            - mode
>>+
>>+    -
>>+      name: pin-get
>>+      doc: |
>>+        Get list of pins and its attributes.
>>+        - dump request without any attributes given - list all the pins
>>in the system
>>+        - dump request with target dpll - list all the pins registered
>>with a given dpll device
>>+        - do request with target dpll and target pin - single pin attrib=
utes
>>+      attribute-set: dpll
>>+      flags: [ admin-perm ]
>>+
>>+      do:
>>+        pre: dpll-pin-pre-doit
>>+        post: dpll-pin-post-doit
>>+        request:
>>+          attributes:
>>+            - id
>>+            - bus-name
>>+            - dev-name
>>+            - pin-idx
>>+        reply: &pin-attrs
>>+          attributes:
>>+            - pin-idx
>>+            - pin-label
>>+            - pin-type
>>+            - pin-direction
>>+            - pin-frequency
>>+            - pin-frequency-supported
>>+            - pin-parent
>>+            - pin-rclk-device
>>+            - pin-dpll-caps
>>+            - device
>>+
>>+      dump:
>>+        pre: dpll-pin-pre-dumpit
>>+        post: dpll-pin-post-dumpit
>>+        request:
>>+          attributes:
>>+            - id
>>+            - bus-name
>>+            - dev-name
>>+        reply: *pin-attrs
>>+
>>+    -
>>+      name: pin-set
>>+      doc: Set attributes of a target pin
>>+      attribute-set: dpll
>>+      flags: [ admin-perm ]
>>+
>>+      do:
>>+        pre: dpll-pin-pre-doit
>>+        post: dpll-pin-post-doit
>>+        request:
>>+          attributes:
>>+            - id
>>+            - bus-name
>>+            - dev-name
>>+            - pin-idx
>>+            - pin-frequency
>>+            - pin-direction
>>+            - pin-prio
>>+            - pin-state
>>+            - pin-parent-idx
>>+
>>+mcast-groups:
>>+  list:
>>+    -
>>+      name: monitor
>>diff --git a/drivers/dpll/dpll_nl.c b/drivers/dpll/dpll_nl.c
>>new file mode 100644
>>index 000000000000..2f8643f401b0
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_nl.c
>>@@ -0,0 +1,126 @@
>>+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-
>>Clause)
>>+/* Do not edit directly, auto-generated from: */
>>+/*	Documentation/netlink/specs/dpll.yaml */
>>+/* YNL-GEN kernel source */
>>+
>>+#include <net/netlink.h>
>>+#include <net/genetlink.h>
>>+
>>+#include "dpll_nl.h"
>>+
>>+#include <linux/dpll.h>
>>+
>>+/* DPLL_CMD_DEVICE_GET - do */
>>+static const struct nla_policy dpll_device_get_nl_policy[DPLL_A_BUS_NAME
>>+ 1] =3D {
>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+};
>>+
>>+/* DPLL_CMD_DEVICE_SET - do */
>>+static const struct nla_policy dpll_device_set_nl_policy[DPLL_A_MODE + 1=
]
>>=3D {
>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_MODE] =3D NLA_POLICY_MAX(NLA_U8, 5),
>
>I know it is a matter of the generator script, still have to note it
>hurts my eyes to see "5" here :)
>

Yes, that's true.

Thanks!
Arkadiusz

>
>>+};
>>+
>>+/* DPLL_CMD_PIN_GET - do */
>>+static const struct nla_policy dpll_pin_get_do_nl_policy[DPLL_A_PIN_IDX =
+
>>1] =3D {
>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_PIN_IDX] =3D { .type =3D NLA_U32, },
>>+};
>>+
>>+/* DPLL_CMD_PIN_GET - dump */
>>+static const struct nla_policy
>>dpll_pin_get_dump_nl_policy[DPLL_A_BUS_NAME + 1] =3D {
>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+};
>>+
>>+/* DPLL_CMD_PIN_SET - do */
>>+static const struct nla_policy
>>dpll_pin_set_nl_policy[DPLL_A_PIN_PARENT_IDX + 1] =3D {
>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_PIN_IDX] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_PIN_FREQUENCY] =3D { .type =3D NLA_U64, },
>>+	[DPLL_A_PIN_DIRECTION] =3D NLA_POLICY_MAX(NLA_U8, 2),
>>+	[DPLL_A_PIN_PRIO] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_PIN_STATE] =3D NLA_POLICY_MAX(NLA_U8, 3),
>>+	[DPLL_A_PIN_PARENT_IDX] =3D { .type =3D NLA_U32, },
>>+};
>>+
>>+/* Ops table for dpll */
>>+static const struct genl_split_ops dpll_nl_ops[] =3D {
>>+	{
>>+		.cmd		=3D DPLL_CMD_DEVICE_GET,
>>+		.pre_doit	=3D dpll_pre_doit,
>>+		.doit		=3D dpll_nl_device_get_doit,
>>+		.post_doit	=3D dpll_post_doit,
>>+		.policy		=3D dpll_device_get_nl_policy,
>>+		.maxattr	=3D DPLL_A_BUS_NAME,
>>+		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>>+	},
>>+	{
>>+		.cmd	=3D DPLL_CMD_DEVICE_GET,
>>+		.start	=3D dpll_pre_dumpit,
>>+		.dumpit	=3D dpll_nl_device_get_dumpit,
>>+		.done	=3D dpll_post_dumpit,
>>+		.flags	=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
>>+	},
>>+	{
>>+		.cmd		=3D DPLL_CMD_DEVICE_SET,
>>+		.pre_doit	=3D dpll_pre_doit,
>>+		.doit		=3D dpll_nl_device_set_doit,
>>+		.post_doit	=3D dpll_post_doit,
>>+		.policy		=3D dpll_device_set_nl_policy,
>>+		.maxattr	=3D DPLL_A_MODE,
>>+		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>>+	},
>>+	{
>>+		.cmd		=3D DPLL_CMD_PIN_GET,
>>+		.pre_doit	=3D dpll_pin_pre_doit,
>>+		.doit		=3D dpll_nl_pin_get_doit,
>>+		.post_doit	=3D dpll_pin_post_doit,
>>+		.policy		=3D dpll_pin_get_do_nl_policy,
>>+		.maxattr	=3D DPLL_A_PIN_IDX,
>>+		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>>+	},
>>+	{
>>+		.cmd		=3D DPLL_CMD_PIN_GET,
>>+		.start		=3D dpll_pin_pre_dumpit,
>>+		.dumpit		=3D dpll_nl_pin_get_dumpit,
>>+		.done		=3D dpll_pin_post_dumpit,
>>+		.policy		=3D dpll_pin_get_dump_nl_policy,
>>+		.maxattr	=3D DPLL_A_BUS_NAME,
>>+		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
>>+	},
>>+	{
>>+		.cmd		=3D DPLL_CMD_PIN_SET,
>>+		.pre_doit	=3D dpll_pin_pre_doit,
>>+		.doit		=3D dpll_nl_pin_set_doit,
>>+		.post_doit	=3D dpll_pin_post_doit,
>>+		.policy		=3D dpll_pin_set_nl_policy,
>>+		.maxattr	=3D DPLL_A_PIN_PARENT_IDX,
>>+		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>>+	},
>>+};
>>+
>>+static const struct genl_multicast_group dpll_nl_mcgrps[] =3D {
>>+	[DPLL_NLGRP_MONITOR] =3D { "monitor", },
>>+};
>>+
>>+struct genl_family dpll_nl_family __ro_after_init =3D {
>>+	.name		=3D DPLL_FAMILY_NAME,
>>+	.version	=3D DPLL_FAMILY_VERSION,
>>+	.netnsok	=3D true,
>>+	.parallel_ops	=3D true,
>>+	.module		=3D THIS_MODULE,
>>+	.split_ops	=3D dpll_nl_ops,
>>+	.n_split_ops	=3D ARRAY_SIZE(dpll_nl_ops),
>>+	.mcgrps		=3D dpll_nl_mcgrps,
>>+	.n_mcgrps	=3D ARRAY_SIZE(dpll_nl_mcgrps),
>>+};
>>diff --git a/drivers/dpll/dpll_nl.h b/drivers/dpll/dpll_nl.h
>>new file mode 100644
>>index 000000000000..57ab2da562ba
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_nl.h
>>@@ -0,0 +1,42 @@
>>+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-
>>Clause) */
>>+/* Do not edit directly, auto-generated from: */
>>+/*	Documentation/netlink/specs/dpll.yaml */
>>+/* YNL-GEN kernel header */
>>+
>>+#ifndef _LINUX_DPLL_GEN_H
>>+#define _LINUX_DPLL_GEN_H
>>+
>>+#include <net/netlink.h>
>>+#include <net/genetlink.h>
>>+
>>+#include <linux/dpll.h>
>>+
>>+int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>>+		  struct genl_info *info);
>>+int dpll_pin_pre_doit(const struct genl_split_ops *ops, struct sk_buff *=
skb,
>>+		      struct genl_info *info);
>>+void
>>+dpll_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>>+	       struct genl_info *info);
>>+void
>>+dpll_pin_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb=
,
>>+		   struct genl_info *info);
>>+int dpll_pre_dumpit(struct netlink_callback *cb);
>>+int dpll_pin_pre_dumpit(struct netlink_callback *cb);
>>+int dpll_post_dumpit(struct netlink_callback *cb);
>>+int dpll_pin_post_dumpit(struct netlink_callback *cb);
>>+
>>+int dpll_nl_device_get_doit(struct sk_buff *skb, struct genl_info *info)=
;
>>+int dpll_nl_device_get_dumpit(struct sk_buff *skb, struct
>>netlink_callback *cb);
>>+int dpll_nl_device_set_doit(struct sk_buff *skb, struct genl_info *info)=
;
>>+int dpll_nl_pin_get_doit(struct sk_buff *skb, struct genl_info *info);
>>+int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback
>>*cb);
>>+int dpll_nl_pin_set_doit(struct sk_buff *skb, struct genl_info *info);
>>+
>>+enum {
>>+	DPLL_NLGRP_MONITOR,
>>+};
>>+
>>+extern struct genl_family dpll_nl_family;
>>+
>>+#endif /* _LINUX_DPLL_GEN_H */
>>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>>new file mode 100644
>>index 000000000000..e188bc189754
>>--- /dev/null
>>+++ b/include/uapi/linux/dpll.h
>>@@ -0,0 +1,202 @@
>>+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-
>>Clause) */
>>+/* Do not edit directly, auto-generated from: */
>>+/*	Documentation/netlink/specs/dpll.yaml */
>>+/* YNL-GEN uapi header */
>>+
>>+#ifndef _UAPI_LINUX_DPLL_H
>>+#define _UAPI_LINUX_DPLL_H
>>+
>>+#define DPLL_FAMILY_NAME	"dpll"
>>+#define DPLL_FAMILY_VERSION	1
>>+
>>+/**
>>+ * enum dpll_mode - working-modes a dpll can support, differentiate if a=
nd
>>how
>>+ *   dpll selects one of its sources to syntonize with it, valid values =
for
>>+ *   DPLL_A_MODE attribute
>>+ * @DPLL_MODE_UNSPEC: unspecified value
>>+ * @DPLL_MODE_MANUAL: source can be only selected by sending a request t=
o
>>dpll
>>+ * @DPLL_MODE_AUTOMATIC: highest prio, valid source, auto selected by dp=
ll
>>+ * @DPLL_MODE_HOLDOVER: dpll forced into holdover mode
>>+ * @DPLL_MODE_FREERUN: dpll driven on system clk, no holdover available
>>+ * @DPLL_MODE_NCO: dpll driven by Numerically Controlled Oscillator
>>+ */
>>+enum dpll_mode {
>>+	DPLL_MODE_UNSPEC,
>>+	DPLL_MODE_MANUAL,
>>+	DPLL_MODE_AUTOMATIC,
>>+	DPLL_MODE_HOLDOVER,
>>+	DPLL_MODE_FREERUN,
>>+	DPLL_MODE_NCO,
>>+
>>+	__DPLL_MODE_MAX,
>>+	DPLL_MODE_MAX =3D (__DPLL_MODE_MAX - 1)
>>+};
>>+
>>+/**
>>+ * enum dpll_lock_status - provides information of dpll device lock
>>status,
>>+ *   valid values for DPLL_A_LOCK_STATUS attribute
>>+ * @DPLL_LOCK_STATUS_UNSPEC: unspecified value
>>+ * @DPLL_LOCK_STATUS_UNLOCKED: dpll was not yet locked to any valid
>>source (or
>>+ *   is in one of modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>>+ * @DPLL_LOCK_STATUS_CALIBRATING: dpll is trying to lock to a valid
>>signal
>>+ * @DPLL_LOCK_STATUS_LOCKED: dpll is locked
>>+ * @DPLL_LOCK_STATUS_HOLDOVER: dpll is in holdover state - lost a valid
>>lock or
>>+ *   was forced by selecting DPLL_MODE_HOLDOVER mode
>>+ */
>>+enum dpll_lock_status {
>>+	DPLL_LOCK_STATUS_UNSPEC,
>>+	DPLL_LOCK_STATUS_UNLOCKED,
>>+	DPLL_LOCK_STATUS_CALIBRATING,
>>+	DPLL_LOCK_STATUS_LOCKED,
>>+	DPLL_LOCK_STATUS_HOLDOVER,
>>+
>>+	__DPLL_LOCK_STATUS_MAX,
>>+	DPLL_LOCK_STATUS_MAX =3D (__DPLL_LOCK_STATUS_MAX - 1)
>>+};
>>+
>>+#define DPLL_TEMP_DIVIDER	10
>>+
>>+/**
>>+ * enum dpll_type - type of dpll, valid values for DPLL_A_TYPE attribute
>>+ * @DPLL_TYPE_UNSPEC: unspecified value
>>+ * @DPLL_TYPE_PPS: dpll produces Pulse-Per-Second signal
>>+ * @DPLL_TYPE_EEC: dpll drives the Ethernet Equipment Clock
>>+ */
>>+enum dpll_type {
>>+	DPLL_TYPE_UNSPEC,
>>+	DPLL_TYPE_PPS,
>>+	DPLL_TYPE_EEC,
>>+
>>+	__DPLL_TYPE_MAX,
>>+	DPLL_TYPE_MAX =3D (__DPLL_TYPE_MAX - 1)
>>+};
>>+
>>+/**
>>+ * enum dpll_pin_type - defines possible types of a pin, valid values fo=
r
>>+ *   DPLL_A_PIN_TYPE attribute
>>+ * @DPLL_PIN_TYPE_UNSPEC: unspecified value
>>+ * @DPLL_PIN_TYPE_MUX: aggregates another layer of selectable pins
>>+ * @DPLL_PIN_TYPE_EXT: external source
>>+ * @DPLL_PIN_TYPE_SYNCE_ETH_PORT: ethernet port PHY's recovered clock
>>+ * @DPLL_PIN_TYPE_INT_OSCILLATOR: device internal oscillator
>>+ * @DPLL_PIN_TYPE_GNSS: GNSS recovered clock
>>+ */
>>+enum dpll_pin_type {
>>+	DPLL_PIN_TYPE_UNSPEC,
>>+	DPLL_PIN_TYPE_MUX,
>>+	DPLL_PIN_TYPE_EXT,
>>+	DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>+	DPLL_PIN_TYPE_INT_OSCILLATOR,
>>+	DPLL_PIN_TYPE_GNSS,
>>+
>>+	__DPLL_PIN_TYPE_MAX,
>>+	DPLL_PIN_TYPE_MAX =3D (__DPLL_PIN_TYPE_MAX - 1)
>>+};
>>+
>>+/**
>>+ * enum dpll_pin_direction - defines possible direction of a pin, valid
>>values
>>+ *   for DPLL_A_PIN_DIRECTION attribute
>>+ * @DPLL_PIN_DIRECTION_UNSPEC: unspecified value
>>+ * @DPLL_PIN_DIRECTION_SOURCE: pin used as a source of a signal
>>+ * @DPLL_PIN_DIRECTION_OUTPUT: pin used to output the signal
>>+ */
>>+enum dpll_pin_direction {
>>+	DPLL_PIN_DIRECTION_UNSPEC,
>>+	DPLL_PIN_DIRECTION_SOURCE,
>>+	DPLL_PIN_DIRECTION_OUTPUT,
>>+
>>+	__DPLL_PIN_DIRECTION_MAX,
>>+	DPLL_PIN_DIRECTION_MAX =3D (__DPLL_PIN_DIRECTION_MAX - 1)
>>+};
>>+
>>+#define DPLL_PIN_FREQUENCY_1_HZ		1
>>+#define DPLL_PIN_FREQUENCY_10_MHZ	10000000
>>+
>>+/**
>>+ * enum dpll_pin_state - defines possible states of a pin, valid values =
for
>>+ *   DPLL_A_PIN_STATE attribute
>>+ * @DPLL_PIN_STATE_UNSPEC: unspecified value
>>+ * @DPLL_PIN_STATE_CONNECTED: pin connected, active source of phase
>locked loop
>>+ * @DPLL_PIN_STATE_DISCONNECTED: pin disconnected, not considered as a v=
alid
>>+ *   source
>>+ * @DPLL_PIN_STATE_SELECTABLE: pin enabled for automatic source selectio=
n
>>+ */
>>+enum dpll_pin_state {
>>+	DPLL_PIN_STATE_UNSPEC,
>>+	DPLL_PIN_STATE_CONNECTED,
>>+	DPLL_PIN_STATE_DISCONNECTED,
>>+	DPLL_PIN_STATE_SELECTABLE,
>>+
>>+	__DPLL_PIN_STATE_MAX,
>>+	DPLL_PIN_STATE_MAX =3D (__DPLL_PIN_STATE_MAX - 1)
>>+};
>>+
>>+/**
>>+ * enum dpll_pin_caps - defines possible capabilities of a pin, valid
>>flags on
>>+ *   DPLL_A_PIN_CAPS attribute
>>+ */
>>+enum dpll_pin_caps {
>>+	DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE =3D 1,
>>+	DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE =3D 2,
>>+	DPLL_PIN_CAPS_STATE_CAN_CHANGE =3D 4,
>>+};
>>+
>>+/**
>>+ * enum dpll_event - events of dpll generic netlink family
>>+ * @DPLL_EVENT_UNSPEC: invalid event type
>>+ * @DPLL_EVENT_DEVICE_CREATE: dpll device created
>>+ * @DPLL_EVENT_DEVICE_DELETE: dpll device deleted
>>+ * @DPLL_EVENT_DEVICE_CHANGE: attribute of dpll device or pin changed,
>>reason
>>+ *   is to be found with an attribute type (DPLL_A_*) received with the
>>event
>>+ */
>>+enum dpll_event {
>>+	DPLL_EVENT_UNSPEC,
>>+	DPLL_EVENT_DEVICE_CREATE,
>>+	DPLL_EVENT_DEVICE_DELETE,
>>+	DPLL_EVENT_DEVICE_CHANGE,
>>+};
>>+
>>+enum dplla {
>>+	DPLL_A_DEVICE =3D 1,
>>+	DPLL_A_ID,
>>+	DPLL_A_DEV_NAME,
>>+	DPLL_A_BUS_NAME,
>>+	DPLL_A_MODE,
>>+	DPLL_A_MODE_SUPPORTED,
>>+	DPLL_A_LOCK_STATUS,
>>+	DPLL_A_TEMP,
>>+	DPLL_A_CLOCK_ID,
>>+	DPLL_A_TYPE,
>>+	DPLL_A_PIN_IDX,
>>+	DPLL_A_PIN_LABEL,
>>+	DPLL_A_PIN_TYPE,
>>+	DPLL_A_PIN_DIRECTION,
>>+	DPLL_A_PIN_FREQUENCY,
>>+	DPLL_A_PIN_FREQUENCY_SUPPORTED,
>>+	DPLL_A_PIN_FREQUENCY_MIN,
>>+	DPLL_A_PIN_FREQUENCY_MAX,
>>+	DPLL_A_PIN_PRIO,
>>+	DPLL_A_PIN_STATE,
>>+	DPLL_A_PIN_PARENT,
>>+	DPLL_A_PIN_PARENT_IDX,
>>+	DPLL_A_PIN_RCLK_DEVICE,
>>+	DPLL_A_PIN_DPLL_CAPS,
>>+
>>+	__DPLL_A_MAX,
>>+	DPLL_A_MAX =3D (__DPLL_A_MAX - 1)
>>+};
>>+
>>+enum {
>>+	DPLL_CMD_UNSPEC =3D 1,
>>+	DPLL_CMD_DEVICE_GET,
>>+	DPLL_CMD_DEVICE_SET,
>>+	DPLL_CMD_PIN_GET,
>>+	DPLL_CMD_PIN_SET,
>>+
>>+	__DPLL_CMD_MAX,
>>+	DPLL_CMD_MAX =3D (__DPLL_CMD_MAX - 1)
>>+};
>>+
>>+#define DPLL_MCGRP_MONITOR	"monitor"
>>+
>>+#endif /* _UAPI_LINUX_DPLL_H */
>>--
>>2.34.1
>>

