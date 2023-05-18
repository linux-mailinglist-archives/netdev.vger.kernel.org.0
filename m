Return-Path: <netdev+bounces-3699-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24CA07085A4
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E22AF1C210BA
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B6223D6B;
	Thu, 18 May 2023 16:08:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C892C53A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:08:23 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629B1E5C;
	Thu, 18 May 2023 09:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684426086; x=1715962086;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ATnrSulniwtqbFQcLH+3qt4N5pknHTFySZOt2m89k+0=;
  b=fqSX+bAvM1/5FjzlbUoyPl40xaN06oQOs7QuZSZrW/v+VNGPmn9WpGhx
   J+3jld1DGcAKA+ykcCzbWSGUBLZU2I6vdI03fJKurNhGBKs9kbJ+D9mlb
   mbSSY236lZJQV9lXKjklzluT4puZCWi0FHE9eeWM9k3DPkol2fD2T0LN5
   pihjzIFLe+th9m9JEFFCgkNEe9gND3+6UZNDSEYcL5rcEKjn0Qym+ATMl
   zBvh6gRjRmn51Oc0XJ40fdUcjjlRrxtRns/1KjlrIgLGjJ86osrjewwM5
   CVe24v6KJo2zRKztSQEzLATuuFSk3PW+pxj+ryK++fpI/PA/x38e7Zo9K
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="350945471"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="350945471"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 09:08:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="767268634"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="767268634"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 18 May 2023 09:08:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 09:08:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 09:08:04 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 09:08:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNn98Cj1q2wlt7V04KdFR7BXL7RYAqDjJ1BVI+rwv3wNQCxS2fuxJ3D9HLaFmgcofYTUCPHaeCIzz28jgLec3mveMTwaZD9IEWmkPEsPIG1SS7Y45sKmbQJL8HT2oUBndQRSKoKnzGzg6Cd23OeeSlB35w1SV1bs5NPONk/P23WUZKEsyD5HaHJZzwh4dmaTPqH32or0FZoyi6w95hcbgWNUUxPOx0B+h5VVQWgfVIQXCTlFBnZJJmnm3g/qOYIv3sbZhB3JuSrbdTsaAUG0C9zqwtvHsiLV2zQStkZ0RrXHWtna3vtkboRSTGq6XKy7YZD1LWwzkxesfIPdFM/a/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZqAfsz3Y1rGlnz4UXADGJC+5C2qhxDswAWO4nMh91M=;
 b=aw8aAA9K60i+q+YzFGXzIwp/oiNMCn5lbOSL+cHNh5xTbuasBqmeEO+dx1CGlHvGRBcPHSMmJMvb2KgJPh9R0gRQqWM98xsPNXBd0t77EQ8xd9f0SZ2HtB67mnxH3YNAlBoLX4VKagRR9l0SoWVpNhY+e3FJp+jj1O5CzYxf68sZpLVPGJ7b3Cq+trQPCP4Bjq3I8X5F7Qn3/maDFhCS8B1J0Kb1oKjefycq01bl6dYRYxh/LR1yDB7RpjIdCXA1krVjrvwB3FkMZCQufQoRRkQUhcvX4I9VEEaF8xNvvkRXWHsTmiQHB/O0BPWQpDBL8l1ciTg6mAvVgvwN6cyxkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB6746.namprd11.prod.outlook.com (2603:10b6:510:1b4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Thu, 18 May
 2023 16:07:33 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%6]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 16:07:33 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Topic: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Index: AQHZeWdQDnOnlwLdVUynBqrraL/3s69brg0AgAEOquCAACiggIADbTAA
Date: Thu, 18 May 2023 16:07:33 +0000
Message-ID: <DM6PR11MB465765FA0C789D6D49B32C159B7F9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-6-vadfed@meta.com> <ZGJn/tKjzxNYcNKU@nanopsycho>
 <DM6PR11MB46570013B31FCCF1FCE0854D9B799@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGNtH1W3Y/pnx2Hk@nanopsycho>
In-Reply-To: <ZGNtH1W3Y/pnx2Hk@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB6746:EE_
x-ms-office365-filtering-correlation-id: ff418966-f9d4-4cf5-a93d-08db57b9fd84
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qd4BHx/u6MxYxB6RNjVaDlcc+lRdeBh0g4ZMgNgwFpKDpvvI7t2QKWfhAtwkClBDFlaeqPQtrryvO+mfW9c+j87/aVVmYzXuP6QvmyQXzBVMQIdadz5RxGJA1QMFYRoDm25024DERXlL5hpnD2TDcJWO6FT7fIeJo6onnu+6avbVnloj8NRgIJtCEjaIG7Hdu/WigFcJ0OVi2AsBHrn+weHMiimhIT40Dbp3ODQMxyYr2pe52rbmb01BXHLoiBaFf+ZbRWieMbCiV47KlfElHvIWErTE+AO6UjX5fFsw0YLqSxq5SZj6tcPwJRP6QjpQgy1JavtAXEZxjc0HguFfgNe506yQAgOuAWvAmlfXXVmbhO+W3wmyCOFIi3qL9cFeeEXUUa6PP0a9ieqf1c7taqe4QPbjCVJtwl4Exae40jAFXoNFGqsrbhNVJK96NWb3AiXiW4w1bqpPy6hAJSbd1C/1vsglAh2PrMd5KY3CmaGn5zP3N0s8p9r6fWACAXDB6BLWUPDOsId0Tiong17gGhZkpy943v5GUO+Jk5S9pFjUEemaCIrochBgvwgWeVeH9WMAY9J7m2Onhgroqgcne7+yoG8hLryQQ2Totb5DWDSAUA9DTlpJ2zUWEPKc7leS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199021)(52536014)(122000001)(9686003)(8676002)(8936002)(86362001)(66946007)(83380400001)(38070700005)(55016003)(82960400001)(38100700002)(6916009)(4326008)(316002)(64756008)(41300700001)(66476007)(5660300002)(66446008)(6506007)(66556008)(26005)(7696005)(54906003)(478600001)(33656002)(76116006)(71200400001)(186003)(2906002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JgutcTc9dpTWprvhEyKRO78YBd18z7ViQ8Kk1mQFXdzD1ByqJnHOhE/9Mu6S?=
 =?us-ascii?Q?3uKTFl5I5TfKDSms2YrazAbA27A64jkTxFKGno06HEfofAmkw3+07ffUCQ3Q?=
 =?us-ascii?Q?M3IH4uHcQjyiwMXA8hn7/c1Q/wLJ6yIqKekcmAAAa6tEMdIDVYH9wpV1B4zY?=
 =?us-ascii?Q?qSU5/Eh/d3H2djkvzAqpCLJrZ+0A3OPio9AGiyK9LCulnPZ/FU6u024AtS9N?=
 =?us-ascii?Q?KzOr8ujoUORTzjCRgXbG+Ac3XZMetpxg+l8uzcHY9cHE1fADmnNs/ohidQab?=
 =?us-ascii?Q?MbiHwWoWalAWf0wO9F+lxf0M1zTtkKdON79xhDq2UQbDvel6DcQZeAwWI06V?=
 =?us-ascii?Q?sHZRuaL+yrDQG9Vy1uvPCkzQW0BXJBK/Q4iv9uJVwEtg0BJ44CKFi8khHxyT?=
 =?us-ascii?Q?ZB9RX+PpyujZ2vXNeRAN37vl6faBTsHMABiM0ZzHXYqeYl4G2U8ofxJ2CAja?=
 =?us-ascii?Q?9DYw+9L2GBqhKxx8sU7DeKy9DzVuhlqCYd+MUSnVdhoR4czFdMizEPNe6mPh?=
 =?us-ascii?Q?ElIIRLnjmU233CvIeTtBlshRAVMQfa022usRsRgRH47aLVWQJBSG8n9eeMAW?=
 =?us-ascii?Q?GfppQ6jseUsBzOW6fIYa2ciS6/EMiHZWTFb1Rc/WIRQX4eeqpiILuY4zHS9i?=
 =?us-ascii?Q?+1UkCYxR4dgK4e4x1VS+NH56EtEssNkyYQzrF3FSct3PBsWXYp5dk2LyUo8R?=
 =?us-ascii?Q?U2/kF3WZ2zFoIs/V1OftpDFLXirDzDTKtIX+CAVLH4MJz/qhqhOG/qB4n4QR?=
 =?us-ascii?Q?zkvJCsmmaFhWWYNMYhkKD2cniMCGAb9uRkycHb/0l3NNY3w/9cEGhbEWS5Gl?=
 =?us-ascii?Q?zs9z1WloJ+gsLJ6DJby6UX6hj3d+Xlkb/+kvEgvqTEaE0a1gUuB5zViwAwid?=
 =?us-ascii?Q?ZTNSgXPPpfalKUlW/hLlavR7G0+YK2tycTyiNZyh01HUNMpxrnpqvwOx0wBa?=
 =?us-ascii?Q?xBiZ5c7TNB47eeBctGNZ0Qmat9GV6Sy17ft9CtAtAekQIgvL2g+wJvKyNsvW?=
 =?us-ascii?Q?znU1S8pXshpnspd5YDkhAfOLK5DB6Z6h/TSL02s4nyX39App4h7V43EuGX6x?=
 =?us-ascii?Q?eBHON/23Rp6T0oXFfYIcz2ivhsfPk9m5zkH9tBjXUjesIybz5jytO6uhsqU6?=
 =?us-ascii?Q?aS4hzY/AxVKLQIZGlLlx35adZUXQneHAoiP2ix4pGShRXYpr3eeOYgU1v92+?=
 =?us-ascii?Q?b4qMU+qmQ0ePKkm88Asrk0UwzmjUmqxpizS97VuvlUFa4U0ZBStuAHlg7WS/?=
 =?us-ascii?Q?qXysX4qzBoRxVf2MgwJbQy5fLt0J7lRsdq2K1hYwRElsju5CHeZBDMdIORj7?=
 =?us-ascii?Q?utM98rLR1UZfxB7m4drK8aGlSGAf1V7ALUfwzrJnYXjA/cNV3Mnzf+wkmeDA?=
 =?us-ascii?Q?zeS4Ktz/s6aj5gNj9EA328Je0OXgGF6LDUrHgRSDhleXELYgE517NkDv5m1J?=
 =?us-ascii?Q?1d5Ys9BSvPH10mjbGdURlfFDfg9oLz+QUMydYZxb5ZS3+TEKNN05qa0OIcix?=
 =?us-ascii?Q?u2+ejXD2YzK4CUG1zaRN5wWjWaiZ2PPsb2PgyJJK1NOo8GtpraJQRT3h+NHd?=
 =?us-ascii?Q?SPKM1ggpXkXydi1B1L8aSpiKIOTNDvkjrqcySOfuxG1F9w9KtqeUfD5ddMzZ?=
 =?us-ascii?Q?KQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ff418966-f9d4-4cf5-a93d-08db57b9fd84
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 16:07:33.6418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 21T/l21bKoSXDRv+zWfZIbRwBC8k8NTz93fsf2h8QT10/duBRhxFxl604o1d/1Q0IKTJBZ3jNIzf6IxU3zKHnkwDP0/4Sktbxrb8MzPCPpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6746
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, May 16, 2023 1:47 PM
>
>Tue, May 16, 2023 at 11:22:37AM CEST, arkadiusz.kubalewski@intel.com wrote=
:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Monday, May 15, 2023 7:13 PM
>>>
>>>Fri, Apr 28, 2023 at 02:20:06AM CEST, vadfed@meta.com wrote:
>>>
>>>[...]
>>>
>>>>+static const enum dpll_lock_status
>>>>+ice_dpll_status[__DPLL_LOCK_STATUS_MAX] =3D {
>>>>+	[ICE_CGU_STATE_INVALID] =3D DPLL_LOCK_STATUS_UNSPEC,
>>>>+	[ICE_CGU_STATE_FREERUN] =3D DPLL_LOCK_STATUS_UNLOCKED,
>>>>+	[ICE_CGU_STATE_LOCKED] =3D DPLL_LOCK_STATUS_CALIBRATING,
>>>
>>>This is a bit confusing to me. You are locked, yet you report
>>>calibrating? Wouldn't it be better to have:
>>>DPLL_LOCK_STATUS_LOCKED
>>>DPLL_LOCK_STATUS_LOCKED_HO_ACQ
>>>
>>>?
>>>
>>
>>Sure makes sense, will add this state.
>
>Do you need "calibrating" then? I mean, the docs says:
>  ``LOCK_STATUS_CALIBRATING``   dpll device calibrates to lock to the
>                                source pin signal
>
>Yet you do: [ICE_CGU_STATE_LOCKED] =3D DPLL_LOCK_STATUS_CALIBRATING
>Seems like you should have:
>[ICE_CGU_STATE_LOCKED] =3D DPLL_LOCK_STATUS_LOCKED
>[ICE_CGU_STATE_LOCKED_HO_ACQ] =3D DPLL_LOCK_STATUS_LOCKED_HO_ACQ,
>
>and remove DPLL_LOCK_STATUS_CALIBRATING as it would be unused?
>
>Also, as a sidenote, could you use the whole names of enum value names
>in documentation? Simple reason, greppability.
>

Yes, removed CALIBRATING.
Fixed the docs.

Thank you!
Arkadiusz

>Thanks!
>
>
>>
>>>
>>>>+	[ICE_CGU_STATE_LOCKED_HO_ACQ] =3D DPLL_LOCK_STATUS_LOCKED,
>>>>+	[ICE_CGU_STATE_HOLDOVER] =3D DPLL_LOCK_STATUS_HOLDOVER,
>>>>+};
>>>
>>>[...]

