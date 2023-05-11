Return-Path: <netdev+bounces-1686-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B946FED10
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 519282811EE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E92C81F;
	Thu, 11 May 2023 07:43:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448A8371
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:43:15 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F1A83E4;
	Thu, 11 May 2023 00:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683790986; x=1715326986;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4WV4I+QLgWtw+4Z3t0nKU8jz1LIQ0MmBPfl2cL/mZ+A=;
  b=O/FamyiBU8Oyefjp20MtMEE02LwaPs3s+94W8BQJF5T/xRaXRgcAxoTS
   ndsHadEE6YJZsnIZ7RUMytQBfub96pv6mZuCS66OZZio2ktwiGahs9LKg
   eUFtMunWDBJnAClxGW3yPvgnbU6+xv44m8Si6OiRIUxtXehFaCBjoBfWm
   QZPYuHujP2dR2ybP7kYIeFweyjat/TSqtIdEcGtAlzEbqubeTcnctTxUD
   lfFCA3KEO8E6GLMTKVhGElgSfhA1Rp6Ct6Lw9ogiuVnZRGFfsK5MVSqpk
   5Ib4Xd9TT+XmB2NDGWHGSIDAhB+IV4nvR13iMoFSotgKbc4t6JJGo7rqS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="378544307"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="378544307"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:40:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="702636498"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="702636498"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 11 May 2023 00:40:36 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 00:40:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 00:40:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 00:40:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 00:40:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlV0E2T2SrUXZvETeOL5jX8aG2uZ3EeSm9JpqWyc6m5RuPJqy4DQPzfHau2zEwSoBTI++HvObhCmXGq3a3aDdy3WNtUyPMoRbY/qC9KryN9iCjASAxIMH621PI143fmOU3JRLg6w7qGeCU+u4PK05Zs6VaHOmBw79VyVzVDDWBwVQy19jC4j7HadyCWnREaqSSldwk7KqA/FpjGbDoqqZ2ksH2lbD41hI+ewghPDyX9EbGCENiIvqLX2qSVqrBe/HZl5MpepIo2+9O/yDrikoMbIqFwv6ggzUQtWJWcEjT82S1l1Q8pDVSCnmqO9G87jfIgGmcKgPfY7kwcXsRjz0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vywQAuxy3xOn8KLQdIZ014ZU0ZbOA0EgAOUyFmd6+4=;
 b=Rb2Ed0yexawucnSpoVnQxEOjHeAHFZDLAq4ORzuv0otUMyDIax2Rk/ePSdZuVdfPxFbeN/3NEk04313GlrdAMdoDFlsm80JD4motDySdtex+dYFNWGXFOpiwaRu+8ej0c4tustkbWxHUkbRS3OorUPtcbpalG2QHkDNXiCqORTzs/BjKPt8OaIOvo58AP72WW2rHUbN2yuTE8SUfRODT7tyc3P8ISq7nX0hl0B1YK6eW5gW0qOotJeixuJhQpxoea6hUpnNKnAqFEvy2m1/dnkxWF9je2c22O1+9c2Mon/GODbb2E27nvhsN0LyeS9QAWCNA/SLBCTW4Xz+jvEty6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4664.namprd11.prod.outlook.com (2603:10b6:208:26e::24)
 by SA2PR11MB4811.namprd11.prod.outlook.com (2603:10b6:806:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 07:40:26 +0000
Received: from MN2PR11MB4664.namprd11.prod.outlook.com
 ([fe80::62d1:43b3:3184:9824]) by MN2PR11MB4664.namprd11.prod.outlook.com
 ([fe80::62d1:43b3:3184:9824%7]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 07:40:26 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@meta.com>
CC: Jiri Pirko <jiri@resnulli.us>, Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>, "Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZeWdNus9yie+T1ke/i4FdVA4f5K9KDcsAgACdH4CAChnlwA==
Date: Thu, 11 May 2023 07:40:26 +0000
Message-ID: <MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-2-vadfed@meta.com>	<ZFOe1sMFtAOwSXuO@nanopsycho>
 <20230504142451.4828bbb5@kernel.org>
In-Reply-To: <20230504142451.4828bbb5@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4664:EE_|SA2PR11MB4811:EE_
x-ms-office365-filtering-correlation-id: 0c8996f2-1628-4804-f89d-08db51f2fcc7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xbuWeWvwzwy1Y2FXMdqeyP4PY0uBygYird7wr7FM9bkaaPLarKg11Pia2xOifGDzj+RzmZU8ckGfyRVghu/9ZpjTcRZnV96U3jT4KnBq0TcLqpMnCbtfs4nCjVPmej8zBiJeaMAbNbHJ7T7Dhp7Pu4dzWg10dIf54zEBe90SWwFMvm2ME8IoBOWqFy5MNvLIKs3xwCuY2CY4ctCLIviFnXbLimHyFgwNy2deEQiPyWDloPJaV/e+vkE9pkQ+Zfnezt9rWqYbs+AjH72v5VbNh+rSe2PZ52ZRDnpxTHRlAhkHHDSjO19RBR9fKG+o7eqRM2iSSO36uNqAr0DqvKTEtZ5p/anxdXstP0TCpgbrIOsTNboMdh+zJoNY3eDXvCpQFaqxm8WTiaWsjlCIM3WhxTxrwk0Md/WOyXN4PK8K8hW2kzYwayPU6r5N8CDSWat9l/aAbNGqGE4yD5d4BZlqgLu4RShRhWmh+b5AWcewqfL2zLqEHYnhIvueKvDI6CgZh3lSg3JWsNF+dcGYpGqrr7dA2iDlJqCta2sMgaBF9eF3RGU0UAhtBEDn1eNFqvI9I6ssTZmTAfoAUOxiENyVYG6FkdIMaB95h0XiydAiyI+juHe/kCMje5Ph8WDCMa4j
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4664.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199021)(4326008)(82960400001)(54906003)(110136005)(316002)(76116006)(83380400001)(52536014)(5660300002)(2906002)(41300700001)(71200400001)(66446008)(66476007)(7696005)(66556008)(86362001)(66946007)(122000001)(64756008)(33656002)(26005)(6506007)(9686003)(38100700002)(8676002)(8936002)(55016003)(186003)(38070700005)(7416002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iJg0zJHnLzqHLSijnfUkvsEdEinX6Ny3+pzx0zyokIngzVzSwDfngX7TrvwG?=
 =?us-ascii?Q?efhV5YYfAWYmiD9WP54fV+SZHxERjB3tfcpO0f/frX3C00pNVoklnlJv6NKD?=
 =?us-ascii?Q?vWCoG19D88gSifrxJdhjwMz1yPHbDtJyHs7itXbOjqyd2rfCNwy4UaG0PasR?=
 =?us-ascii?Q?hzSSfVN9nivqIBdbqWBHf1T09LHUGfWYi9rjkRkNbBzfo7GTNJFVU7to3FLW?=
 =?us-ascii?Q?Z1/yDIH5RupONvw6JbdM3MEKXdlI1kN0OVEXTUUawA7RIMOkg7ttHPVfxPOZ?=
 =?us-ascii?Q?SSi2KXYHdT/khuROx/rbc+NHNlJVWeXX8EgwmLXjqbWImRPo5p1d8lEvWTpo?=
 =?us-ascii?Q?YD4csVfN0+D3FoMI2q4IgmGYo4KE/bs9z8Dq0Qo/mKrO7aKoGlfvfi/sJtcn?=
 =?us-ascii?Q?C53W/B9lms6g4S1YTmK5C/1grZPxsLynVzsPoj6mFNTDASeqPyW7FjsnjBfn?=
 =?us-ascii?Q?VmiIysLJIlLnlnBMCr8nFn6aHMv9qbhjZmPef9fdvHVNgZ3y5gL8JH5qGnFK?=
 =?us-ascii?Q?wa55sfyKlFSnVKTLBCrVA0OszxU1U3z9e9FnZEY9ZDUhNkjRTl4uP/D+XYSX?=
 =?us-ascii?Q?fYmoKhFCQqKZAyZtHm9O9zf0a6iXj+osb3L9WyLjNojO+MEclpvPXbr8KQjU?=
 =?us-ascii?Q?IQCmIRDDdOLSOS6IWB2tcsn9GoxWDzq8B/uvhj4Mx34VH2gC997cI3Lw3ta1?=
 =?us-ascii?Q?IGI5nWugzywSZFQq+NQJJLHCW1u+SEpeg60FXnlo6HNgvSeyNxHWctzpMdAh?=
 =?us-ascii?Q?A7z96CBmXzDVaqslB29GW2XtHzeiAOVh89+J/pZ+/U3YBQ9+JjeKyokiW6fw?=
 =?us-ascii?Q?xCkaOv6kW4FZ0UWjMouqI5Dy3KOYpWcLRoXjaYjlBWDt2fTQ8ense0da+cvi?=
 =?us-ascii?Q?r/4T0hO/lFowb48LChYIy91pFUtoxe+4koPhe1tKmyMmfHDAoKwxVc++ZKee?=
 =?us-ascii?Q?n7cLGcKvsptl2lOJtejGVBuk532OqRjevs7XCgFE8j2qp9Sh5btM0CV5QqS9?=
 =?us-ascii?Q?c6Dnh47dhyV1pUTYjCQYiwo4aNgT1tkJszvQdbELex9D7R+jaBU6NpcG3rB4?=
 =?us-ascii?Q?5cU33RBTNlJNToyFVySfAcLP6hYAq2WDJ5o0AOqvSbppiUvGF6jmZ13V6oWp?=
 =?us-ascii?Q?t+K8kPL9g9btly+k+9dyUaMBoNe5T8eilvyImY2bCq3h/rd6XuDHzLU0DlTN?=
 =?us-ascii?Q?4J+DkuNX49elx7MCcAJ5IMJ+OUhAE33QUDuXu6w54udTZWECDu54LfcqaHUo?=
 =?us-ascii?Q?JCAKZSNgRj4VJZCyI3lquJxB3n5oSBi+KoSZ8fIQDoeu7BsEjqWZK8k5dxwT?=
 =?us-ascii?Q?TZhWz4xafFJHIC1ooEVil6YUOrSlNH9qZmMCTQ3q6AprjB4FrEx4xyJd2D1R?=
 =?us-ascii?Q?mBnW1O3ZCIYHqsUwNB0pk0Gnhqzh1xrSvNgL9TrYTP8OeE3kenlc2GafZy/d?=
 =?us-ascii?Q?/HCf6U0pVfCFRqUDAW49uA/qW8S01/ywZMNAaf4YwQTssYswIUuQeVaPc5w7?=
 =?us-ascii?Q?bA6cQr4zf2S3vpzwJNaOE/lg3P5hyY7SPpj8RWeeS7Bxe9ItxfFRBfKHRAZO?=
 =?us-ascii?Q?0oxWwWWGVJMSS3srX/tSf+FkfbMdRiTomxnwI+9uRc1GQNeeUtI28o7WbbfC?=
 =?us-ascii?Q?1Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c8996f2-1628-4804-f89d-08db51f2fcc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 07:40:26.7569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xqvumlEIlOFCsfhUFfyrQOmcTuPabGR2TrejOpqM50J2EAqCBnUI3QL9QQDkc2kBaQ8H9BH5xDQ1x8DxgVSmZziguzLb7mhcRRsonE+GhwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4811
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Thursday, May 4, 2023 11:25 PM
>
>On Thu, 4 May 2023 14:02:30 +0200 Jiri Pirko wrote:
>> >+definitions:
>> >+  -
>> >+    type: enum
>> >+    name: mode
>> >+    doc: |
>> >+      working-modes a dpll can support, differentiate if and how dpll
>>selects
>> >+      one of its sources to syntonize with it, valid values for
>>DPLL_A_MODE
>> >+      attribute
>> >+    entries:
>> >+      -
>> >+        name: unspec
>>
>> In general, why exactly do we need unspec values in enums and CMDs?
>> What is the usecase. If there isn't please remove.
>
>+1
>

Sure, fixed.

>> >+        doc: unspecified value
>> >+      -
>> >+        name: manual
>
>I think the documentation calls this "forced", still.
>

Yes, good catch, fixed docs.

>> >+        doc: source can be only selected by sending a request to dpll
>> >+      -
>> >+        name: automatic
>> >+        doc: highest prio, valid source, auto selected by dpll
>> >+      -
>> >+        name: holdover
>> >+        doc: dpll forced into holdover mode
>> >+      -
>> >+        name: freerun
>> >+        doc: dpll driven on system clk, no holdover available
>>
>> Remove "no holdover available". This is not a state, this is a mode
>> configuration. If holdover is or isn't available, is a runtime info.
>
>Agreed, seems a little confusing now. Should we expose the system clk
>as a pin to be able to force lock to it? Or there's some extra magic
>at play here?

In freerun you cannot lock to anything it, it just uses system clock from
one of designated chip wires (which is not a part of source pins pool) to f=
eed
the dpll. Dpll would only stabilize that signal and pass it further.
Locking itself is some kind of magic, as it usually takes at least ~15 seco=
nds
before it locks to a signal once it is selected.

>
>> >+      -
>> >+        name: nco
>> >+        doc: dpll driven by Numerically Controlled Oscillator
>
>Noob question, what is NCO in terms of implementation?
>We source the signal from an arbitrary pin and FW / driver does
>the control? Or we always use system refclk and then tune?
>

Documentation of chip we are using, stated NCO as similar to FREERUN, and i=
t
runs on a SYSTEM CLOCK provided to the chip (plus some stabilization and
dividers before it reaches the output).
It doesn't count as an source pin, it uses signal form dedicated wire for
SYSTEM CLOCK.
In this case control over output frequency is done by synchronizer chip
firmware, but still it will not lock to any source pin signal.

>> >+    render-max: true
>> >+  -
>> >+    type: enum
>> >+    name: lock-status
>> >+    doc: |
>> >+      provides information of dpll device lock status, valid values fo=
r
>> >+      DPLL_A_LOCK_STATUS attribute
>> >+    entries:
>> >+      -
>> >+        name: unspec
>> >+        doc: unspecified value
>> >+      -
>> >+        name: unlocked
>> >+        doc: |
>> >+          dpll was not yet locked to any valid source (or is in one of
>> >+          modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>> >+      -
>> >+        name: calibrating
>> >+        doc: dpll is trying to lock to a valid signal
>> >+      -
>> >+        name: locked
>> >+        doc: dpll is locked
>> >+      -
>> >+        name: holdover
>> >+        doc: |
>> >+          dpll is in holdover state - lost a valid lock or was forced =
by
>> >+          selecting DPLL_MODE_HOLDOVER mode
>>
>> Is it needed to mention the holdover mode. It's slightly confusing,
>> because user might understand that the lock-status is always "holdover"
>> in case of "holdover" mode. But it could be "unlocked", can't it?
>> Perhaps I don't understand the flows there correctly :/
>
>Hm, if we want to make sure that holdover mode must result in holdover
>state then we need some extra atomicity requirements on the SET
>operation. To me it seems logical enough that after setting holdover
>mode we'll end up either in holdover or unlocked status, depending on
>lock status when request reached the HW.
>

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

What extra atomicity you have on your mind?
Do you suggest to validate and allow (in dpll_netlink.c) only for 'unlocked=
'
or 'holdover' states of dpll, once DPLL_MODE_HOLDOVER was successfully
requested by the user?

>> >+    render-max: true
>> >+  -
>> >+    type: const
>> >+    name: temp-divider
>> >+    value: 10
>> >+    doc: |
>> >+      temperature divider allowing userspace to calculate the
>> >+      temperature as float with single digit precision.
>> >+      Value of (DPLL_A_TEMP / DPLL_TEMP_DIVIDER) is integer part of
>> >+      tempearture value.
>>
>> s/tempearture/temperature/
>>
>> Didn't checkpatch warn you?
>
>Also can we give it a more healthy engineering margin?
>DPLL_A_TEMP is u32, silicon melts at around 1400C,
>so we really can afford to make the divisor 1000.
>

Sure, fixed.

>> >+    name: device
>> >+    subset-of: dpll
>> >+    attributes:
>> >+      -
>> >+        name: id
>> >+        type: u32
>> >+        value: 2
>> >+      -
>> >+        name: dev-name
>> >+        type: string
>> >+      -
>> >+        name: bus-name
>> >+        type: string
>> >+      -
>> >+        name: mode
>> >+        type: u8
>> >+        enum: mode
>> >+      -
>> >+        name: mode-supported
>> >+        type: u8
>> >+        enum: mode
>> >+        multi-attr: true
>> >+      -
>> >+        name: lock-status
>> >+        type: u8
>> >+        enum: lock-status
>> >+      -
>> >+        name: temp
>> >+        type: s32
>> >+      -
>> >+        name: clock-id
>> >+        type: u64
>> >+      -
>> >+        name: type
>> >+        type: u8
>> >+        enum: type
>> >+      -
>> >+        name: pin-prio
>> >+        type: u32
>> >+        value: 19
>>
>> Do you still need to pass values for a subset? That is odd. Well, I
>> think is is odd to pass anything other than names in subset definition,
>> the rest of the info is in the original attribute set definition,
>> isn't it?
>> Jakub?
>
>Probably stale code, related bug was fixed in YNL a few months back.
>Explicit value should no longer be needed.

Yes, checked it works without them, I am removing values for next version.

Thanks!
Arkadiusz

