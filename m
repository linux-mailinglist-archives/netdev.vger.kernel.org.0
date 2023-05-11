Return-Path: <netdev+bounces-1687-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A0B6FED17
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:44:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 474BF280E8D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B311B8FC;
	Thu, 11 May 2023 07:44:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3028D371
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:44:39 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A661BF6;
	Thu, 11 May 2023 00:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683791077; x=1715327077;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1695o9HRJ81MJ35H2IEUI9B1cZKAqgPdFtIoZZQSZj8=;
  b=YIGxqL3jowb1zN2ELWWMnx4xd+/81QDrsT7YXhgFhhFy+M7G8Fs2yIwu
   xOPf9pVJpLTKo6ww0ZfExLxw4K4NxAT3CaSGUcATk7xkSrXmi3tx28J20
   AUXerlEspfyVCJs6Xab0u/2bdBrvxQM3RUcsEPv+6iNJ2KqINDvcIDaR3
   891eR+basKvDHgWH+TOrCj5jdCjSkrkZgmplDq86tlHHf8O2g2b0/0JBf
   2WBJIUZt+v/tj6f3rogOCxNolnc2hWFiLjlmaMpowik8LQPFQ/eW8mHIH
   vyG/rCKkvToU8gF8xA8+cTgmNErs2EjU3kTHXZ5O1rLjL8NVQm9EK3Bh0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="436756813"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="436756813"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:44:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="730235738"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="730235738"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2023 00:44:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 00:44:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 00:44:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 00:44:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLKKmHDViCSE5QY0+0aeOtg/XgIgWvHFkRt4YCWT6IsLsFFbvMs/XksnTaXUj2L2cZIM8VtMcxUrS/Sf57Yrw87YyH0CpoyJEllY256lXjRdsf7It1VgL9wQqAXeWSZbPKDfliCU9qOGd71s3Xmlkv4GLG+MVXg6voU6wA12GePcV9PjPlHDyAfGnOaX/EptnZoS8MPIabk17JlIEWduEv0MPLIohNgDZcPVT+nqnmdx2+Z/lMuUbd/ZdcpJzQklhsD1P62GxHQsqq/B0jUVqeovbLYszWlcmRfET70ivY7JLopGDjFxPRwCWUolqjv7dX5b7OFMGRS6pJbTFu458Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1J48e/Nvn/5+Is+CfXrfZYj8pkAufo8k072DiDgKtkU=;
 b=bEWG+s5mXnTFyy9DSmLA1xYRI9sa5R7ixMoaCrXUxLMfqf5HJAYjSSud1gZbwiBf5nu/qJ8KOCsf4g3UUaO6nHuiikmKdpa6EkKOP/uXV3ZEWzZW1DBHz1SuG6HgL1VLGItJrz9Bkb/FNquEhImhJ1ccS7noPOwQR7F58fbdpEcm6uqXQLmnZyafCMgZbCOYzySh8umZa4pz5MMEYiMuXyHNi2jUETPNIpPzy0Reix9EqQvRuOKV5ZGBdk4EMdFUAFWyOp5q9QQn4/A7qN+nRdA+XBixjUwx2ZiOL3krqwz6EqQpdnOriAshZyKgB5vB61taaqwPp/WBvP8sfemaGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4664.namprd11.prod.outlook.com (2603:10b6:208:26e::24)
 by SA2PR11MB4811.namprd11.prod.outlook.com (2603:10b6:806:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 07:44:30 +0000
Received: from MN2PR11MB4664.namprd11.prod.outlook.com
 ([fe80::62d1:43b3:3184:9824]) by MN2PR11MB4664.namprd11.prod.outlook.com
 ([fe80::62d1:43b3:3184:9824%7]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 07:44:30 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC: Vadim Fedorenko <vadfed@meta.com>, Jonathan Lemon
	<jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, "Olech, Milena"
	<milena.olech@intel.com>, "Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZeWdNus9yie+T1ke/i4FdVA4f5K9KDcsAgACdH4CAANtdgIAJPuag
Date: Thu, 11 May 2023 07:44:30 +0000
Message-ID: <MN2PR11MB4664357BAEC609040CF480C69B749@MN2PR11MB4664.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-2-vadfed@meta.com> <ZFOe1sMFtAOwSXuO@nanopsycho>
 <20230504142451.4828bbb5@kernel.org> <ZFTap8tIHWdbzGwp@nanopsycho>
In-Reply-To: <ZFTap8tIHWdbzGwp@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4664:EE_|SA2PR11MB4811:EE_
x-ms-office365-filtering-correlation-id: d15ce067-5984-45f4-a06d-08db51f38df2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zI+kS5Kcy4xwG9HXRdoCGP3DDQfe3PBI0KOFc9R0CD54OXUzhTPw5Y8EZ2fHwjGKPefa/C+bLZ7S6gYeSrMlcKaz6pIT/+G2nQAMTOPjAMKJeJ3TXwNscz2WdrM3xBdo/v6p7BNgAXHRIc8G7WUzTTemb1M8MdJRPgglVQKd8qzvSoRaVmtl95QSTCqVwkd3qnWxwZstT49bug3/+DpdGcj9jaBzMmOM51E5KycDRFY1XnlEY0M/c9oln5FS7w+ptbg4RH1JrEqOv04EXpFDI/7HzIecrNHkU/PUHea4/IrnaiCMhQYM9K3dl/USiUvKCiLV0NazaRpkvEYgC0xbOdccxz3xXOCVeLk/ov80pElUknfa6dl4lR5HHyCJ5YmhE5hzKruYol3JxZu+epX2/RpB9PYkCkvYKQnvZqIwcZYKkYNlVkIPtVakFCOK9kp8/SLl+G7Fzmz7D/FsK/KykvgEKz6ysEhjjBJGA+TpGZdBBxAAo0tbHHDkwosRMme88BDgWUZXUrgxBeCrvXEo1mFDno57UAe0/ABCIFnk9rGgTsnDebFZWXm950sW0DBvXW52gKFMD+GaPAHpRZWRp4uf5YAdx0frvCVXkf58nZhKhqWu4slPRXc7QDkeX9Nv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4664.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199021)(4326008)(82960400001)(54906003)(110136005)(316002)(76116006)(83380400001)(52536014)(5660300002)(2906002)(41300700001)(71200400001)(66446008)(66476007)(7696005)(66556008)(86362001)(66946007)(122000001)(64756008)(33656002)(26005)(6506007)(9686003)(38100700002)(8676002)(8936002)(55016003)(186003)(38070700005)(7416002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VdWVYMKCTFYpmwQ8LKeH28zzfZIfT5Pxj3FZ/M2AchRfk8tTKQgp62kWxqoX?=
 =?us-ascii?Q?pY34SbhdFcGieNHgIvQcoJsz3VyNp3q//2oMKqSBKMANmhUb5UN2sowthmT5?=
 =?us-ascii?Q?mYz72JBAZzMO62ouarnGhYDVQ/yXWB+9RDYAMc068n1II81emj7bemtXMz8b?=
 =?us-ascii?Q?z4Msr4AWK4NsO13g4RvukdgWQj4nUiZmyIwVJFklkNAbn0QiQrQF8OP3xfiw?=
 =?us-ascii?Q?5njuTW6HW/A4u7hnpLtEAn/TrOoJTDEIB2uEVdD3kj5wZj8S+YHTAlRZCIOI?=
 =?us-ascii?Q?fBm9kIqsV0hBjHfJ2hN5yArG5zXyWj9WN32KUUQeyZdRM3u+fia+5HcuYIQh?=
 =?us-ascii?Q?0pdwUH+qGXf+EJ+MwV4z8sIz/CcogL/BBAHz0/a9tiTsOCuK8rSTSmnISTh6?=
 =?us-ascii?Q?tLLlV4r5Z4WvtLWUlwfwKR566M3foD2CsCM1F5ciLqyk0zDkm0fVYx4TvH5n?=
 =?us-ascii?Q?J54PoKaaYY998jupubJBDavW63xh2gSFnVB06qA0eAvJPRjWgEkyrBEWz1Y2?=
 =?us-ascii?Q?0nncjYz0cNv4kzYjXz5aByMn1zMqh3gKS8k+XDYigJ5w2JM6GuAXGt4x0mUH?=
 =?us-ascii?Q?FfcaA1uw0kepkVcFXp3qExHRXaiyYSjJHJF9SaPxRC7sdnDjV6B8q1rJQy3F?=
 =?us-ascii?Q?opnkU1iJdpCqMfoQonq4JmfHamJtvju2fsIMuwOpOHsoKlR3iSyROK2jnN/p?=
 =?us-ascii?Q?V/3LS2XJNyaR15VAkXCnHNnu8GcBKmOITI108QDXCmUiPC7QJMZL4dCgNkHz?=
 =?us-ascii?Q?loRCcpGz5DnG5KSNs//RqJGohfLJWrpOyolE2o3Ir8RbgvTBm5rYpd1jErym?=
 =?us-ascii?Q?a3F5yoQVHQWtcA2QBorLz0R7lGHJ436t9HVlvG9Cx/DLO4Go8OUjzFqy/FEW?=
 =?us-ascii?Q?EjfE5hsiBf+XNQ0wkaUD4qtKiGI1YD+m3qeFqwITDcWDiO/m5LycQe8DAZry?=
 =?us-ascii?Q?Zwm26WvQp5gf8J2RxU6zLUUoiR2ByRvm7pMjB7pCz0nITA2Ez5jiE6vSp+rI?=
 =?us-ascii?Q?i3g1T2V/l8GThP6wwX1kWPX9JYBUZPT68Q6ZfPsjx0gK7XjRTJqPOSWZWHZb?=
 =?us-ascii?Q?iW0MgCqpJnJFoZLR3GwrkYHOS9LRkpsipHrXziVn4lOYFlD1oP3CbX10nwDH?=
 =?us-ascii?Q?tjP6X4vMD5f9jZJpmNlsvSram/tU1fJOB91Zv9OfTbqSTflGe/faZP7As3BV?=
 =?us-ascii?Q?GPGjmO7UmgAckMLFteTPy+S9EjeYb9Eh1sN7apwyYT1GyDW739gkDSlGBbZO?=
 =?us-ascii?Q?plyYRMmNq8cru6VcUb+fxCw+a/arq9ogqCar9r643Lg7ucXMMEW0cAN3uEql?=
 =?us-ascii?Q?Tn9w4U6Y2EZMJgjRO/VbBMfBd2NhfqzMac+jmG8f+Pv79AOvnit2CxEKCt90?=
 =?us-ascii?Q?Cvy29yRyX629eYIhblA6TmN5jrGBqygoZYBem82GrWqQt21DG6sRP9IGzMZO?=
 =?us-ascii?Q?FK8S0OBKvRhhMSOCQCTpZR9s2DnBZEEGYUEl/dDOKGIIvCBUz4UCETCsJaPe?=
 =?us-ascii?Q?SPmHMWxjgfd9ZpC5+0au52GWg1JPrLHuG8Jc2pk9eMz6H3H0EmJSbReffS4H?=
 =?us-ascii?Q?z0vtWg4K9OpGeWdVSIucqhjwrwVx5pobY6KFfwbcXHJvBYxojxlaFLziqEle?=
 =?us-ascii?Q?dg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d15ce067-5984-45f4-a06d-08db51f38df2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 07:44:30.2842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BL++1eRp1yXt/tCQy1plejHgYO8mZJMKuxMdYVN52Y4H5bXfGL3ZpNjEpuAtP6bcsDTMmhR3/sNJgybm2cFLRqDgSZsPuUC1FLyeuwdnE3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4811
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Friday, May 5, 2023 12:30 PM
>
>Thu, May 04, 2023 at 11:24:51PM CEST, kuba@kernel.org wrote:
>>On Thu, 4 May 2023 14:02:30 +0200 Jiri Pirko wrote:
>
>[...]
>
>>
>>> >+    name: device
>>> >+    subset-of: dpll
>>> >+    attributes:
>>> >+      -
>>> >+        name: id
>>> >+        type: u32
>>> >+        value: 2
>>> >+      -
>>> >+        name: dev-name
>>> >+        type: string
>>> >+      -
>>> >+        name: bus-name
>>> >+        type: string
>>> >+      -
>>> >+        name: mode
>>> >+        type: u8
>>> >+        enum: mode
>>> >+      -
>>> >+        name: mode-supported
>>> >+        type: u8
>>> >+        enum: mode
>>> >+        multi-attr: true
>>> >+      -
>>> >+        name: lock-status
>>> >+        type: u8
>>> >+        enum: lock-status
>>> >+      -
>>> >+        name: temp
>>> >+        type: s32
>>> >+      -
>>> >+        name: clock-id
>>> >+        type: u64
>>> >+      -
>>> >+        name: type
>>> >+        type: u8
>>> >+        enum: type
>>> >+      -
>>> >+        name: pin-prio
>>> >+        type: u32
>>> >+        value: 19
>>>
>>> Do you still need to pass values for a subset? That is odd. Well, I
>>> think is is odd to pass anything other than names in subset definition,
>>> the rest of the info is in the original attribute set definition,
>>> isn't it?
>>> Jakub?
>>
>>Probably stale code, related bug was fixed in YNL a few months back.
>>Explicit value should no longer be needed.
>
>What about the rest, like type, enum, multi-attr etc. Are they needed
>for subset? If yes, why?
>
>

It seems the name and type is needed. Without type generation scripts fails=
.
For now fixed with having only name/type on subset attributes.

Thanks!
Arkadiusz

