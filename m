Return-Path: <netdev+bounces-8606-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2059724BE1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:55:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 536241C20B54
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1FB22E2C;
	Tue,  6 Jun 2023 18:55:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD03125CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:55:22 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889D783;
	Tue,  6 Jun 2023 11:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686077721; x=1717613721;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=naGwk1NO/SaTFRbJnEkix+ThXsoLCn/dUck1hluV6ro=;
  b=nklrrwu94D1s0lu5C8JCsGGjIgLVyF/lZMlmwclR2LpualXAtZ5F9yPx
   Fov5kQ7OpRMNkp3K/s6yaTrleDvmfhQz958B/aY4Modq5J5ZxSy/kEKld
   OwGhFxVJjiBtOpSmNokDUuhxatRQK8d7tnVT2vqHkjbv1lQntkFL1fmyc
   tUtnai7it/+8YU/PsJNxFbOYtRWC0LdXMsk7N4wLbDmu8GQ4xyZH9/0+4
   Hkz3jpQfQU75ZKeMPYl7viUHyhzU3yoUj/s+/uSursEOIUQy01bVXuebu
   fF+ZdpmHnn6zgC51EkimBA+tmnt1ot9FwQgILX87zb2Ri0emsPocJtPpR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="360094231"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="360094231"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 11:55:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="883459782"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="883459782"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2023 11:55:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 11:55:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 11:55:20 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 11:55:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJTZPXT/MmMk7jbTAFITxtV5JH07KYuDKxooGbDATzTyuRLUUNmGjOSkemC+FivYD6Mm1DJ+wToofR18XGlcTjELfnjQITwR1MnbAs1B7c4myYVUxaGWOmeDFcEdbuB/SwMHhlN8gijd/b96IJhoD8AY9wLteqYXTEZdKw0VKHUb63I3ETNnFQ3cvO3/abZ10mwO6uqjTNo6Ev+31Cnv/fd0wQV6rLqn+uQKXoD5xk9LnL9fSapTprGlhIm9d2S6QUHclnj28VyAYeVhmHBvlz00hmUoXHHaYZX8XBR4AreJdbu4a//nBV+FaCJcsiwy++zhWMWCTH5AJN937HGNBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1/1q94427uIFOYbv0Ta9BD/lgoE37aICVjGE1mCXBs=;
 b=M8U8mUg2WfDGfJsWSfRKIFj72b4ooLWDD7HnR7J0L8WlwV8CcCmDMysLG6aRdDLpesX3nspGUan9qK0xWchFjcuyph9ensIHJPtYUt5ZeoWyUFYGy3BAxZvRbjVj0NGrdQBPBSO+nZg4FMbL6njaOGy36YK/pbTEpjn3hQKlZHCpBdbLXAZdPI8MHB1Rr/pnwaEslQnAzf6q8Kewk3xwp1rasZNC6FR3m3eNcKvTYQBcVKGZ0To4PdfclriTxhAPSZqYw3gL9YXqkyiFsNBbtgWOn5j1XYtkBNvo1YgE+3B4bFDCEB1ty9bUnuiVyoj0Emfvxv5ApoXXl3Ej+g8fbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SN7PR11MB6704.namprd11.prod.outlook.com (2603:10b6:806:267::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Tue, 6 Jun 2023 18:55:16 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 18:55:16 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@meta.com>
CC: Jiri Pirko <jiri@resnulli.us>, Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>, "Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Index: AQHZeWdERHWnlPmo9kOdLErcTLxvj69KAZeAgACZWQCAM7ziIA==
Date: Tue, 6 Jun 2023 18:55:16 +0000
Message-ID: <DM6PR11MB4657A72115D17EB5ED702C999B52A@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-3-vadfed@meta.com>	<ZFOUmViuAiCaHBfc@nanopsycho>
 <20230504132740.30e19bba@kernel.org>
In-Reply-To: <20230504132740.30e19bba@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SN7PR11MB6704:EE_
x-ms-office365-filtering-correlation-id: 2333c8f8-17b8-4f8b-26aa-08db66bf9147
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E+c2ysXIZCwwuWBt4A3mSYpNxFlqAfNELMht/VuFgaZA+leKQ3GIAl8hLqOmpGtVthyhYGKOjksArHBRN5+klVrn/ONgmajxhRG3y5nwgQgzqANYG6RTYy5PbtPeyx3NVS8KVOMYd1h+8+mD+Ow2l17aYO1WxVd0EsKm5fEoj1Lgsdaru1amAbnOoeiYa2mtAsku32APFjD+WbE9AyDVhU9IevytWXgh/r8WOWfg9ETOnQdGGPV/bVgksAmteefZ3hCG4X8FUuRIlZL8fnykvzIHs+57sfE91S496Uuckm9I51CHykA3hjGvaPhlBKQom0+0pI8RVIOUEojyeHCD9OA3WHlGqcVHTPL/ohHAQbMnjjeXVgyM8JiXR/88TRhu64zO9DOWFBbvvPI84LXMNTHUZfqqtljGZoIlM6qnw8G0kga3WAC9dejiBdHpJc+n8pCmr4jLqz8c2fgcUN+efnfQR5WKfJ43LxCrSqYFxWR800WLrbdwXfwQcDqpmvxepCz1iKcbuH5U68ZWyy6vZ/6eX5LdJ7nBNjVPOQoLbElRf4cT/pHn/i+USCbYL5HZw1wB4XPH9VRNb2XjS0FPv4DPQU190pHb8m1XlWiRSOGFRJ1XHvgA7qIGAtpXEScp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(366004)(39860400002)(396003)(451199021)(110136005)(4744005)(2906002)(54906003)(38070700005)(71200400001)(478600001)(33656002)(86362001)(52536014)(38100700002)(7416002)(41300700001)(8936002)(8676002)(5660300002)(82960400001)(55016003)(316002)(66556008)(4326008)(64756008)(122000001)(66476007)(66946007)(76116006)(66446008)(6506007)(9686003)(26005)(186003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yYS143m/4RMWtfqk1lAgOlUUbDFHrwQ55h8p57KgUMC0AUd9ddDsiKpLSVGg?=
 =?us-ascii?Q?nrzYnVfX2JFlEPRtLMrkp5+UOnKRjM7QGDCZl3OagdN9quhfPsjiWidgXWWJ?=
 =?us-ascii?Q?IaUq4bPMyZ3iDAqyrZxLUVbr8y4kP3jdsGyUBvY7j7+iJAfHarMcfQg6bUJ7?=
 =?us-ascii?Q?pXCmzavKi0A0fkGFifgINgW8UHkdESX/OOJyaSVeh2RdR69Y/IZbwbp6sU0u?=
 =?us-ascii?Q?IPbxzKGmBLtOeIKPzCR6MoJrjtJLbI4oYnCzJlHscPujmyUqCFIKRZa+yfJA?=
 =?us-ascii?Q?tGlItx4/HDNOfQDuFEukboq/Jy+Qyzta5O12+jWNepZp0h5/FNEHjLVwj2FY?=
 =?us-ascii?Q?UL0NCWm85iLtAybe1/9s89EniuNehdpD+aUkdH7YGRFBLGHrILZn8QwKOnb+?=
 =?us-ascii?Q?eOseKNJMsQkIxuWrCEpiLYo+2BNXF/TUsmG5Vx+isyVkvVMtpDAOKbRDECMX?=
 =?us-ascii?Q?nAMkyFb2j7tUsUmCe9yosMgYPBbU4ScoSsWxHNAFmn1DhoxqVTDy6rV+QJQS?=
 =?us-ascii?Q?20t3WI/B+gP8y9PwELbab8xSuzgUWOgv/R+euT3TbQgELQp4W3qQ3rAFtWR7?=
 =?us-ascii?Q?00zdlrDo4zSKFWKxtQb6ULdVl1OwerkgBRe9s2u+cfnk42/KNRs6rY+aVQ9e?=
 =?us-ascii?Q?hCZNHnC+/T+889ZLGgi7aT3kxCTyQpnDRo4dnNkmeE+Y92k5eFAasm34f79G?=
 =?us-ascii?Q?lQw5WuMXGM6cqX6nNTabjwTopjIf7hXU5J/7idM5AVoAvGa+Cp0SSAMQjOTx?=
 =?us-ascii?Q?U0btIoQAplJmg1MAIBfvIdS5F1zqtQhvb+InNsWL4V0f4Q2Vy3o5e4P9Ltkk?=
 =?us-ascii?Q?eLVu+dbul6cjfDwrFJsRCmai3t04S6HqMFmp+c+PAS7h6hjkFLQfm7KdskQ7?=
 =?us-ascii?Q?6zfsKXO8ETxRpuHj2Kcyc0Z3SUzZQw4fkwNM4fspBRFRRfSSMd6vK6DG4PQf?=
 =?us-ascii?Q?iuQvao6+dwlmBjFxQcluj56nYcC2e4nDuDWm6DQwQkbUILt0C+gnpcwtT5hS?=
 =?us-ascii?Q?fgRtZcM2CQO6VAYAKCRhZ33zbF56OY3vxwCPD6nAzEnGv+UojvCt4BEcOO5h?=
 =?us-ascii?Q?+g2N/xlD6AwM5mmid2HmlSV3L866r8nvqMDfCEThD1JMoHcZehLsITO479Ys?=
 =?us-ascii?Q?Sa6F1egxbHV5+z2mAQ0STtoy2dh1dPH2j9lttRhuAk1L9t3anRSHdlqdjxEj?=
 =?us-ascii?Q?vSmqAoL4shZbzVebTgURbHoMTQ+w/mc+dCMT+nvjWhdoC4whcyS1LPnVZBXi?=
 =?us-ascii?Q?WdqZvaSOyNK/6a7vgNMWgwovF+vCfzLT6Uv+VLptjPQtpLiEmdpRqlhCJg4M?=
 =?us-ascii?Q?dbVrzKi6dPfx1G5MSePvnQj4cNRLnI/wqJcjVkvY4Xj4Mg0PT57QSGOEYQK+?=
 =?us-ascii?Q?ShQkY89g7W3ew0X4yjIcyM/LHwBJGJyaik5joAQfGQ1TF6nJbNc+IOMAPyDj?=
 =?us-ascii?Q?/BtBR1nO0LTxf7t4l98FzqweeZ1b+Xo234Sexd8X/KUIDWq4SETEXSXm7HFY?=
 =?us-ascii?Q?Sed1pUiNBogrMY3iH5OPNDqbgHx1SYpZhtjMX1zvJMOt5QBbD1B0DOlP2jMG?=
 =?us-ascii?Q?gu/n12qTt4KaKIUZuSC8dw678BSgTL2KhAz7QumLXvmm3a+DuYapV4qPQA4O?=
 =?us-ascii?Q?7w=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2333c8f8-17b8-4f8b-26aa-08db66bf9147
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 18:55:16.4722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6xp7ipNv6IlQRhKBwRtnOHyUqsdVJaGzN6Zd6LqrsMH8LvtIB8SkAvCAMg/oKbOn9CemeaJWBd7iLH74j6TQGAlam6RGSS8PRef9TMpUjZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6704
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Thursday, May 4, 2023 10:28 PM
>
>On Thu, 4 May 2023 13:18:49 +0200 Jiri Pirko wrote:
>> >diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>> >index e188bc189754..75eeaa4396eb 100644
>> >--- a/include/uapi/linux/dpll.h
>> >+++ b/include/uapi/linux/dpll.h
>> >@@ -111,6 +111,8 @@ enum dpll_pin_direction {
>> >
>> > #define DPLL_PIN_FREQUENCY_1_HZ		1
>> > #define DPLL_PIN_FREQUENCY_10_MHZ	10000000
>> >+#define DPLL_PIN_FREQUENCY_10_KHZ	10000
>> >+#define DPLL_PIN_FREQUENCY_77_5_KHZ	77500
>>
>> This should be moved to patch #1.
>> please convert to enum, could be unnamed.
>
>+1, you can't edit the YNL-generated files at all.

Fixed.

Thank you,
Arkadiusz

