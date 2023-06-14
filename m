Return-Path: <netdev+bounces-10717-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 102B872FF03
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:48:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9B911C20926
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB07883E;
	Wed, 14 Jun 2023 12:48:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A26264F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:48:26 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E37E79;
	Wed, 14 Jun 2023 05:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686746904; x=1718282904;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V3FU4iHEmnYLa4Mu159eLnh6B4cv+Bf+DYhynBZoU1U=;
  b=Bykoic6wDSH8BURNjvkhLC8w404Uk0fu2pe1JFUungSmvry1B7bUg9Et
   utC7tmnfnVOzjTy6160SrHMwmgidUApmWnpREpICTXeIk2R4sVmGZFoam
   FltxSZQSAwppwiQBIADwkcJRx9nR97mrRgVimfCZfcahjDASnGZy/MT+9
   wYbK3pj4I1u9DXBRnA5NOovqekj+SzM4x44g7zWyG1hUupIHphxrcQZMA
   2F9AZC5qFWAcknza3lKcpIoiSlj87pjBBx2WZsakrZIgaJSWwHo9UzhQ3
   BzvO0EObSqrinZRIDZFiw2RIkH4GCyPpVKOQkAtcJPKJ1/c77sctmTVz1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="358603255"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="358603255"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 05:48:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="1042196997"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="1042196997"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 14 Jun 2023 05:48:23 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 05:48:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 05:48:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 05:48:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDm1seykXM4d4d1UER7jNZOgce9gz8RIP97lvQEWz9BuLbnUCGITRFK5SKcgwaZRH5s9nJW8iOvEDtkDT+oWIyLLTtwWwat4fBlJ9DaPLzM1ICGCAIHGgmSVj1c0hse6Dlmi5qWWILMJGAIJbEEbviW2G0dbBN6JBpXa8b2ZMez8+/yfUsQ0DR3FOiiP2v1IF6EaI54eocufLbIs5GInYnEzXC5R2oR0enEG17r3Ul50D3yTngJwIFNbqI3w+yBbkVu1lwyZ3KHT9ODefscIUaAai1O6S2HKdpQUMSoV+8W7lLnWWaDr9i+KbhflxXe89t/jUYmLxn8V9Ixn+VJ4Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TeZJvHWzXGBF/4vsnckFytbsm0WIHO8d+xmm80mj5Ic=;
 b=PIse0NYkJFlqib717wW1m3+Z8Zpg/m95a/XE+QL5KpGgqhWwuBdLLN9EPoMdTQCX9ORf0zCC4bishCZrgvjrTtsd3mbEGMXZ6gX9lPJSIi5HxBVhHFthFHcWaPFK4IOfedbpUa2NuMmTETex+Q68QxQqqcoJ/5O7KLThQvDx4puDigSQUQozLxq84pl1gtNU09y/ysemrV9qPu+tS5CGiw7qZTPN1mwEcV+SonFava1WNfWPDLW9dIRbh9TXFmplx+IIREwkdOS0LecljD332DhWnWjzUZDycQHFIsQYLXNbsqWtOal1POn2eVuothXgkFFHyW6FBThvUcaGRAcgEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB6556.namprd11.prod.outlook.com (2603:10b6:510:1aa::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.44; Wed, 14 Jun 2023 12:48:15 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 12:48:15 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "edumazet@google.com" <edumazet@google.com>,
	"chuck.lever@oracle.com" <chuck.lever@oracle.com>
Subject: RE: [PATCH net-next] tools: ynl-gen: generate docs for
 <name>_max/_mask enums
Thread-Topic: [PATCH net-next] tools: ynl-gen: generate docs for
 <name>_max/_mask enums
Thread-Index: AQHZnk2DP+viVSY2G0+N2yPHRycjpq+JelUAgADC5aA=
Date: Wed, 14 Jun 2023 12:48:14 +0000
Message-ID: <DM6PR11MB46570AEF7E10089E70CC1D019B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
	<20230613231709.150622-3-arkadiusz.kubalewski@intel.com>
 <20230613175928.4ea56833@kernel.org>
In-Reply-To: <20230613175928.4ea56833@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB6556:EE_
x-ms-office365-filtering-correlation-id: 5a43b121-2d23-419b-033c-08db6cd59ebc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LNprY7cjU7hY6lL5pdZ809tLBJcL+4xIN5GJZ+tJ8aGD5Ul/fSeIUHXFOWnAzPLWMi19J5+ySuvoMkHgWM52gfReQt7lnQ6HfgbwDi01wUAb1FDxj32YxrcV8VfQVUjfJSx8PEaQ6TuwciFbRIJVqLSDE/bNJ+nbnKyUNGFN5Xooqv+qJST6APRCCurue0nWXHZXCrJuwAnzWpMd7d7IOenQBUsBSJirobzK9s8iccS91Am5jEYGHqOniXGYZpfInsgkfpcTyPhjNCEMnqYWEF7wrxuTeqZAo4RXcqVtMkDzPEv1Dy5KjDKPjM3jFXndvvA09z7F0TIhcOTlWwvXnCHipF/8rgEglIYeDZIvM0AXU7DlidUj28fG6b9+aEjt7bcO4tAyz4nxYvz+IYlRQX0YegHtX32AMixbz8+n/s06XNb7eTzOt7azccSHZGWPyanb6PtfEBDGWXSYikbELwo99g+V8b2KdK1n3fANfphbbY4+BF+zvVIuIgeG0stoTnk0+Q5na7u6tYwCjWFG8yND8+bBpsfIwBnAeMng80h6ODEzTJ4NbXptTrbsfg1D5gly0gWgY5D4XeYxjer9vt/C50k4OcbipWtS/9Q/ZJBkRi98xodP8kKrI1Tl27Hi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199021)(55016003)(83380400001)(82960400001)(64756008)(66476007)(66556008)(66446008)(6916009)(4326008)(66946007)(76116006)(9686003)(71200400001)(7696005)(6506007)(26005)(478600001)(186003)(54906003)(86362001)(2906002)(8936002)(8676002)(52536014)(5660300002)(316002)(33656002)(122000001)(41300700001)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ByOsccwMEEbJxhiqVuhhuznFXe+0zy/hSCVudvfiL8/9gNVYccWShhvKxMeT?=
 =?us-ascii?Q?yq1dytsUQB0DgrNgirwmVamfgkzXtIf0rcbNQYkfOWcilCrDCW2QDkF9ky7t?=
 =?us-ascii?Q?XMUz6TaUPD1QQZTYEXxkEUv7Q7IWpEc1xqA0n2vE3313ktZ3ndHonLZRFud/?=
 =?us-ascii?Q?0jdbXIe3huzTE4wfgN2Y5qKBxSogJ/R+/DDQv1NzV7H+mkjz5MW2kcx6DxaL?=
 =?us-ascii?Q?9mV/QODxmlrfsoYI5bozQix0p9vfF8wWJ2ALK0Awg+A4e9OqtyAscOvdMbOm?=
 =?us-ascii?Q?Gs6kqeOrAFF/+Qr6tx8p+fmYxj8kYw6IxkQFzgtBGXkQVdxB1Ofm9cwFDI0B?=
 =?us-ascii?Q?Gm6k/MA7pngG9GuZhIv43BnvYfirKKPFcLzX4j3UhxbPSVoNHVLi4dyH08Zq?=
 =?us-ascii?Q?0/TRxFTjTKRjWns7adtwla9XmXbykLAmjIEUdUIgluuATGtuqeO11qns37dN?=
 =?us-ascii?Q?r2IG/D/AXMXfDjx7luRQptfjpUKzUGiGh/APU1hZGQwT9jhrPua/sjQ0TA6q?=
 =?us-ascii?Q?MS/ZMhlbdtPRzt6eKVYATyVo3tZu+FwpCBT0uYJ3YC21BfDM1DdK6oPCEpGs?=
 =?us-ascii?Q?XWLKj6PBReDubucQdtODjNSOrcrPd94R8F6fNyHYZYo2zS8FQ1+b2JEScwa2?=
 =?us-ascii?Q?x+3oryi3D3gggBib/t68GtoPVaZ9Trmsv0qQ5ZktApHC2XdY5nMYHn9s5aBr?=
 =?us-ascii?Q?lULbZwC9DsSzDV7fRJntJAtzuKT0lU0zF58cm8NVEXhYVou8R8JQEM472hbm?=
 =?us-ascii?Q?pW38oBRHwODr8ZNY0uS+ovD6vU6lWfuyoSNHK8yK9aBgOjc7uP4RjOc9bJMP?=
 =?us-ascii?Q?5jyCmK/hI1pZHNUnvsYMfinBlnHXaH4asYERiOuaV4p2Z6S6friOt7hm/ZG7?=
 =?us-ascii?Q?wqT12A5TQHD6/+amNfb2+zYdnbTydU6qe/QSVrSWn73N8ewJFzLopZ4WEcG+?=
 =?us-ascii?Q?0Vow3iOs4iNJRwXGyHU7yXCq7cvZK4rtsi4fAL6xyfJyhrdyraz6LXX8Rnbg?=
 =?us-ascii?Q?jTOJwceCC2jpLrfwvFMG3uOouDoNrDI99SjnCSbjGZ4/4i2EuX2jMiWVIr9T?=
 =?us-ascii?Q?BtmpN15t6bu39CMD3CUEKivyIhONOU3kOAWcFk+2Ym5AnS36yZPIJsR4fNhK?=
 =?us-ascii?Q?AMTY9ekyVoPXwh6FnwoFq5LqVxy6Xqv/7ZwDW2z3uA2caHXDRfUjMH9ivCbG?=
 =?us-ascii?Q?11zOdkNGsac/W/cK/n2KKVRq23wPny/EUm88iAQbu4BjcsZMYGr4K4XWxosv?=
 =?us-ascii?Q?9Je8zxCQWnR2cV5qPLXuskbzyK1ufU12ZkA56G3cvZ7BYShrEcxpw9YH2EkX?=
 =?us-ascii?Q?Q5lKPjTSFtko4YwU11+9SZJI3OK3S6RkwK1lrZ+vTwNqBBs3R1aaLoNHj/fW?=
 =?us-ascii?Q?tbTX9A6hj7ddXNvbVqvky0FDUkQVDrkH/mORaJeoMZ1eCJZ6tnDsV9kRV+1y?=
 =?us-ascii?Q?YVFicFeqR2K+vNyc9cyX5pOaMsl5Citdbwg6RWw9LkVPUmSEEP/WxRqMa7K9?=
 =?us-ascii?Q?MyBtR3Ey9jEKjuX4/3JxO6/vRshiLE88dH58WTDTG0YIKOh5H6GZiaL4kipH?=
 =?us-ascii?Q?G5e5rlwG1RfEBr5W5qnfmCQTn/dosmCWnRql8cWUKxteaWpFxF3cVc3qSAwq?=
 =?us-ascii?Q?ZQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a43b121-2d23-419b-033c-08db6cd59ebc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 12:48:14.9711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l+mh6OiZ9pdBb9TBqz82d+ApDDIaTOBn4xMDpdoKgwJWRY3nrZ6Qh4gjFF8iVFIdXkXEaLV0eglO06gKqBT9jToS7+Y1CuShtyZxoYvJhhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6556
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Wednesday, June 14, 2023 2:59 AM
>
>On Wed, 14 Jun 2023 01:17:09 +0200 Arkadiusz Kubalewski wrote:
>> Including ynl generated uapi header files into source kerneldocs
>> (rst files in Documentation/) produces warnings during documentation
>> builds (i.e. make htmldocs)
>>
>> Prevent warnings by generating also description for enums where
>> rander_max was selected.
>
>Do you reckon that documenting the meta-values makes sense, or should
>we throw a:
>
>/* private: */
>

Most probably it doesn't..
Tried this:
/*
 [ other values description ]
 * private:
 * @__<NAME>_MAX
 */
and this:
/*
 [ other values description ]
 * private: @__<NAME>_MAX
 */

Both are not working as we would expect.

Do you mean to have double comments for enums? like:
/*
 [ other values description ]
 */
/*
 * private:
 * @__<NAME>_MAX
 */
=20
>comment in front of them so that kdoc ignores them? Does user space
>have any use for those? If we want to document them...
>

Hmm, do you recall where I can find proper format of such ignore enum comme=
nt
for kdoc generation?
Or maybe we need to also submit patch to some kdoc build process to actuall=
y
change the current behavior?

>> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
>> index 639524b59930..d78f7ae95092 100644
>> --- a/include/uapi/linux/netdev.h
>> +++ b/include/uapi/linux/netdev.h
>> @@ -24,6 +24,7 @@
>>   *   XDP buffer support in the driver napi callback.
>>   * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implemen=
ts
>>   *   non-linear XDP buffer support in ndo_xdp_xmit callback.
>> + * @NETDEV_XDP_ACT_MASK: valid values mask
>
>... I think we need to include some sort of indication that the value
>will change as the uAPI is extended. Unlike the other values which are
>set in stone, so to speak. "mask of currently defines values" ? Dunno.
>

Sure can fix this.

>>   */
>>  enum netdev_xdp_act {
>>  	NETDEV_XDP_ACT_BASIC =3D 1,
>> diff --git a/tools/include/uapi/linux/netdev.h
>>b/tools/include/uapi/linux/netdev.h
>> index 639524b59930..d78f7ae95092 100644
>> --- a/tools/include/uapi/linux/netdev.h
>> +++ b/tools/include/uapi/linux/netdev.h
>> @@ -24,6 +24,7 @@
>>   *   XDP buffer support in the driver napi callback.
>>   * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev
>>implements
>>   *   non-linear XDP buffer support in ndo_xdp_xmit callback.
>> + * @NETDEV_XDP_ACT_MASK: valid values mask
>>   */
>>  enum netdev_xdp_act {
>>  	NETDEV_XDP_ACT_BASIC =3D 1,
>> diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
>> index 0b5e0802a9a7..0d396bf98c27 100755
>> --- a/tools/net/ynl/ynl-gen-c.py
>> +++ b/tools/net/ynl/ynl-gen-c.py
>> @@ -2011,6 +2011,7 @@ def render_uapi(family, cw):
>>          # Write kdoc for enum and flags (one day maybe also structs)
>>          if const['type'] =3D=3D 'enum' or const['type'] =3D=3D 'flags':
>>              enum =3D family.consts[const['name']]
>> +            name_pfx =3D const.get('name-prefix', f"{family.name}-
>>{const['name']}-")
>>
>>              if enum.has_doc():
>>                  cw.p('/**')
>> @@ -2022,10 +2023,18 @@ def render_uapi(family, cw):
>>                      if entry.has_doc():
>>                          doc =3D '@' + entry.c_name + ': ' + entry['doc'=
]
>>                          cw.write_doc_line(doc)
>> +                if const.get('render-max', False):
>> +                    if const['type'] =3D=3D 'flags':
>> +                        doc =3D '@' + c_upper(name_pfx + 'mask') + ':
>>valid values mask'
>> +                        cw.write_doc_line(doc)
>> +                    else:
>> +                        doc =3D '@' + c_upper(name_pfx + 'max') + ': ma=
x
>>valid value'
>> +                        cw.write_doc_line(doc)
>> +                        doc =3D '@__' + c_upper(name_pfx + 'max') + ': =
do
>>not use'
>
>This one is definitely a candidate for /* private: */

Yep, makes sense, trying to find some way...

Thank you,
Arkadiusz

>
>> +                        cw.write_doc_line(doc)
>>                  cw.p(' */')
>>
>>              uapi_enum_start(family, cw, const, 'name')
>> -            name_pfx =3D const.get('name-prefix', f"{family.name}-
>{const['name']}-")
>>              for entry in enum.entries.values():
>>                  suffix =3D ','
>>                  if entry.value_change:
>
>--
>pw-bot: cr

