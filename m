Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0306C653E
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjCWKh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjCWKhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:37:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFD922113
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 03:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679567630; x=1711103630;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h4WtN3cloQ1hgK/pcqrTT2ao4rTCpscByWfCrWAD2sA=;
  b=W+eqM5zz2ZRk/1M+QvCHp34xjL3s5W2XR23fEbb4IbtBt3i4aWldWoib
   0NwDZTdoibcgFg0mgPOEWKXZn6AWpIo23m7BFtSvyLLkRCyMLcKAT2JFi
   qXZL6C2gfVf9nsX8F2djbXE0GMIMw9kmg27vu1+EHc/p/iEi46IeGqg6G
   +lGVkUeXts1hOj/3xL+0JNoJ9DpgMisN5hYDVufcpd3mzX3TwFRJqA584
   407HtJlnbx+c00eOCWRzioLvZ6SbaaMNbo1CNRjy5hi4U452POs0hmYeH
   GL3YaXZvjPmIxT6TzCJI89pppOcaBlYWbVBzcTduYXeInWA7Lbj9Dwlmi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="319839406"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="319839406"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 03:33:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="682261190"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="682261190"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 23 Mar 2023 03:33:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 03:33:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 03:33:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 03:33:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 03:33:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwoIgx2kH5m5IMK1hNUSmyfYd+RBzic3TkSAN6jsLFp31iUbHCKx98huxT1KEk4K8/xlpfbqtpsgzS409CIvSs8iyVN/5ejMJhMmJ2PUsFDyxiv6ygB8Y0LCp90KKzh/EQLwnVRFVQPrjTiuJXUelJyIf+AMNi2BgXU3izUmJ4FOY2JQiWlpkJpAsb4mhFhJZV+f8lUW7820XjRy4KMD7DoPJiHpaOxcX9maluFsksc5OTb2XnFyPYd6Uj1FQ7ICT+bvZRlg3yzDM5Tvlw0oRTPo/PYL3C2OXYNCOsdPK4CTrYa2AU9IlpCe0dgjy1Rz8Y2YaDIPmKCuaF0AHktpIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4WtN3cloQ1hgK/pcqrTT2ao4rTCpscByWfCrWAD2sA=;
 b=TnOkLqrUZhPpYyTnIhoonH7KrlMs7zxhUysyXm9ELx+Zv68xLT/K9NGrtolfEtwITPh3VGn//8+UZUxGW0xrL9S4dO55lvdHRazUGEMBm1b6aYnoNG3r5lOAEvFDRhzFNF76oUvVTyj8xoGEP7Jut/wqjgoWD7VhrkzMr0HS2/mC8seYes7fGqbwHRhZu/l+zxrCT30YAgd2Pw2gWTj89bhs6PFQbVIFTc5uJ5YuY8WrEqQWHJtxlyCX/UONw4pq51Gi9dRu3Ya9Ry9fG8kGsr6p8pvyqZLnv9ikFuJGZEe+RDMgbnacPg0Jw3DyK6wAWWMq4PEOXkiSe3UcoJZl6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB4177.namprd11.prod.outlook.com (2603:10b6:405:83::31)
 by IA1PR11MB8246.namprd11.prod.outlook.com (2603:10b6:208:445::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 10:33:44 +0000
Received: from BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::d4fb:c4c1:d85f:c8dc]) by BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::d4fb:c4c1:d85f:c8dc%7]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 10:33:43 +0000
From:   "Michalik, Michal" <michal.michalik@intel.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Subject: RE: [PATCH net] tools: ynl: add the Python requirements.txt file
Thread-Topic: [PATCH net] tools: ynl: add the Python requirements.txt file
Thread-Index: AQHZVo86gIA/ksfkVkeNfFQzyDEwlK781aYAgAc5rKCAADa0gIAA787wgABYvYCAABDcAIACl2fQ
Date:   Thu, 23 Mar 2023 10:33:42 +0000
Message-ID: <BN6PR11MB4177900926AF2BDDB3F6A7DEE3879@BN6PR11MB4177.namprd11.prod.outlook.com>
References: <20230314160758.23719-1-michal.michalik@intel.com>
 <20230315214008.2536a1b4@kernel.org>
 <BN6PR11MB41772BEF5321C0ECEE4B0A2BE3809@BN6PR11MB4177.namprd11.prod.outlook.com>
 <560bd227-e0a9-5c01-29d8-1b71dc42f155@gmail.com>
 <BN6PR11MB41770D6527882D26403EF628E3819@BN6PR11MB4177.namprd11.prod.outlook.com>
 <20230321105203.0dfc7a00@kernel.org>
 <46b182e9-bff5-2e5d-e3d6-27eb466657ef@gmail.com>
In-Reply-To: <46b182e9-bff5-2e5d-e3d6-27eb466657ef@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB4177:EE_|IA1PR11MB8246:EE_
x-ms-office365-filtering-correlation-id: 46e57735-c366-4930-9846-08db2b8a1305
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: otcBTVTdqjj4oVxvFmHfDZxFn1mXuhmLCJAHZx19/d2nGlLE31dfaZ5z3Hnz8O4k71mino0bxC+SbIkA7ISnehan+LNOVqMH4+7PaWCJLwx3vjd+RBLraXhgNVuFWueUoQIcPpMvZ51JC6Zt+1ZPijhwNV5jrt0XyxlnCGADvLlqpwKRihO33/H8oeolimwFDK6E1HiGrPgnxJ1/zaXfvlKip9MhOxg2GJeUmSeO50aOlwxqQ/f6AKR3oOpHACvqYYTuv3rS3Ai/qJdqCVMLE7yUP80gTZNikvY4idSbh2Je/p21uxhJrKjZ8IAVDN17FzmBOXkaR18pdxxl17A9Iq5whACeni/h4PMu2WqZOng5P/bjUWv2aQNBqJ1VAkgbIoUz3KIKGQE84g0L73XFGZ1jJ72I9VdYj5FdIdiTWrmzI4Q+noO08TDVEXfSJOy4oBa2zwCeC+NRCaj+EdxMWs1myaSlwjA1gzdvPo7Xn5mEQ0GYow7BdouVaTrR9UmeVMBYfL5+ymATuQbSRDTFHSwUCkSDtWxOApTyCFVU3Dn77l4DTfCbW1dj56ZVfvbZK06TCZNuDmxWdc7tcAQEwOn6thcKBCs5/Snxt/6CECOSZPKuwghgdIossoSgIz+Gu8AjCAlgI2LG2u7491T7b92IhCl5zdMFvdPs88oGVfGiFVC1awZr4MjfI6ZT6PYvFneYknlwjDm7TZJZP7um1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199018)(86362001)(55016003)(33656002)(66556008)(478600001)(71200400001)(316002)(76116006)(4326008)(52536014)(66446008)(64756008)(8676002)(9686003)(54906003)(66946007)(186003)(66476007)(26005)(110136005)(53546011)(6506007)(107886003)(38100700002)(38070700005)(7696005)(4744005)(41300700001)(8936002)(5660300002)(122000001)(2906002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L25heGJFNmNIeWNwR2pLS3JvcENLaU8rMmJMU3Q3c2FNYTQySWZBZzhHbEt2?=
 =?utf-8?B?WVZNYnJCTVZKZTRwVTcvRU93NEdrMktOcmx5eDFDdFl6cWYwdEZIbmp6ek1t?=
 =?utf-8?B?U3QrKzYvNVBQV2NNNU5pTTFzNDIxb0hFNFdUYmdPWStqQjhKWHZZS2JaMDRo?=
 =?utf-8?B?ZHVQUklsRVFEQ0xiZWt4a3BGZU1OQ2FoUm9oWFBvQlQrc0gxam1pQStVd3JL?=
 =?utf-8?B?N3VMdE9qYjhTVTR6dzlValh4YVc0SjVXNmlOaU1qQWtzaFA0VFJXbk9uZ2Q3?=
 =?utf-8?B?TmxSZThxWGo3WWhSSHVpNzV4a3d6ek5wZTN1WmtBcmtHRGMrZ2NKRHZrZGcv?=
 =?utf-8?B?MUxYUnkvRkkrUE1DRTM5QktHdlA4ZHcrK1V2anBRMmRsd0czWWMxSnROOTVZ?=
 =?utf-8?B?WVAzMW8xTC9lZnZqSkIzQXZSNkhjYmxVUUtEdng2SVU4c2g2TllmRE1yRXlE?=
 =?utf-8?B?UEt6MzJEazBXY2FFVmlDeGZQbHM5bFJwOGlmYWZNWnNYMkNFSjl3Y0hDb0Fp?=
 =?utf-8?B?YVlxWkFwTHduV2ZpaitXUUxZR3JKa2xvcGhDYkNGSElyL1ZuNnBPN2hHNkFy?=
 =?utf-8?B?OTJUT2tlY3F0aXR1TStyVmNyYmxRbW5xdWJ1bm4wNEhyb1FQQ0tzMENKTnJ0?=
 =?utf-8?B?OXVmTVJ2NjVsWGZJdkJpQmNobXQ2SzN4ZFZ6V0dnMXl2RmlNcEYwcDMyV1BL?=
 =?utf-8?B?dmdETlFmVFJFYjJ1SC8xU3dJRjRYcjVmeW1zK2dHMU5HUHlmZUVNWEs2WGkx?=
 =?utf-8?B?TndybVdOVjdQaHZnM2I0ZFhDMzNINVR6UlRSeVZpaXFLbE1aK056TkVRdFRW?=
 =?utf-8?B?R2UwSkNYbUZSWWI5Q24wckQyQk40MTRuRFo2cG5CbkRRMVdZWkljUCtrNmVj?=
 =?utf-8?B?TG54NVpUcTVGWVI3dFVkYUx4T0JYaTlUTTA3NU45U2dyM2FpYXNSTVBIVXU3?=
 =?utf-8?B?QXQ3RU9QVkM2NkFhSjNBU3FqUEc5aDVXUUFVT1B4SFJsNnZYZWxYUEJqMlhI?=
 =?utf-8?B?RUlWVnBmQW5uQ1JsbjBkcVFpeWNOdThmN29KYmZuQTBUU05jai90RmFNTlNG?=
 =?utf-8?B?V2JpckcxY3lEczZpUzJCUk55UjI2eVhDYzFiR2VhTm84VW1PTEErYmhmeDBR?=
 =?utf-8?B?ajE5U09vUzBIc25aNUoxZjVTWFdzSXZlUGlicGNCcGltRXhCelRUS08xbXRL?=
 =?utf-8?B?SW5DNTlFT3RiNVJPOXpVSzNNeThiVGIxeUhBa25YdmRqY1JnMnltT1RPdVZM?=
 =?utf-8?B?djBDZXVwblA2bXJjY2UvbnQ0cmpDVGRqaVlrS1AyVzNOTldXNk1RbjFENHJB?=
 =?utf-8?B?ZWJ0TVpMekNLeWI5b010UkxmRWNlSnkxejhRZzRacEY3UXllQ2J6Mk1wZ3ZH?=
 =?utf-8?B?dm53VTh3V0I5eEplUU45RUxFV2dBeHRnbG1adzlteTkxV2Y0eXN2WldLczRu?=
 =?utf-8?B?U3BzdFg4SXpDbnY3ZHcvc1NqNll1MTNSUUxWb2N5cEZ0ZjlQT1krS0NDOGxJ?=
 =?utf-8?B?eGEwa0ZpT1VXaVZ6azdZWFZIMVlvNmdudndzTHpWNUQxNkgxdUVnRjhpNjh0?=
 =?utf-8?B?MHc3Uk43eTVRMUJBSlZHeDMyZDZrVndIc2dBWlllVnEyZjdIanRzbXExczhq?=
 =?utf-8?B?Tlk0V1BzZUQ2UzJ0bU4rT3hiTUllcmlUbHZ6Um1YSkVoc2NDeGJ6S1Z5dTZQ?=
 =?utf-8?B?ZjJ6Q2QvMkdadWhvUXRkZHM5djFKdlA2L0NlOERWQWszQlFNNzhCNnZUUk1l?=
 =?utf-8?B?djFyQTVKM3lnTVJiejI4bmZpbEdNVVRsOTkwS2JCRTA4Wm5DWUdUU2YzKy9G?=
 =?utf-8?B?bC9wbDcreDZXVkVobUdCVER1Wm9sOW5iQ21mOTRHdWVTZnRTNTdlNlFSdTJJ?=
 =?utf-8?B?bnBqRFY0alJHdTc1UTBCN3pZT0ZoYVFUQVBBdVNLUng4TGU2SG8rd0dFUDdP?=
 =?utf-8?B?bkxUSUdTaXNNVmNQT29ySk83Z2hGaG1YOFVlY3EvUzFGZW1GWUlmMlc1bHJZ?=
 =?utf-8?B?alpDVG9JNjVMdU9zUHd4SkZjYVpubDkzYzhIMDZqdzBFbzMyQ0RnWnJ0ZElX?=
 =?utf-8?B?NW8zMW0rb3V4Q05tQUZkMGV2U2J2RW9SZWwrZEVLRHR6Vy9kTFUzeVpZcExz?=
 =?utf-8?B?T0RGRmRjSUJST2ltUWdnMXorbG42ZkhtU3VHUnVqQzdQcTlFcHozZC9JK3ls?=
 =?utf-8?B?OEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46e57735-c366-4930-9846-08db2b8a1305
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 10:33:42.7203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fv20x0Os8zXxN82qfuqsspkaP4eVodUpef/86xkYaW4P+AsHwy38hEkHiETKluHFOhDayIAGibwtjiKYdOVvftlvEP45dNNVTxG0PrLJLiE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8246
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjEgTWFyY2ggMjAyMyA3OjUyIFBNIENFVCwgRWR3YXJkIENyZWUgd3JvdGU6DQo+IA0KPiBP
biAyMS8wMy8yMDIzIDE3OjUyLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4+IEdpdmVuIHRoZSAi
c3lzdGVtIHNjcmlwdCIgbmF0dXJlIG9mIHRoZSBwcm9qZWN0ICh2cyAiZnVsbCBhcHBsaWNhdGlv
biIpDQo+PiBJIGRvbid0IGZpbmQgdGhlIHJlcXVpcmVtZW50cyB0byBiZSBuZWNlc3Nhcnkgcmln
aHQgbm93Lg0KPiANCj4gSSdkIHNheSBpdCdzIGdvb2QgdG8gZG9jdW1lbnQgdGhlIGRlcGVuZGVu
Y2llcywgYmVjYXVzZSBvdGhlcndpc2UNCj4gIGdldHRpbmcgaXQgdG8gcnVuIGNvdWxkIGJlIGEg
UElUQSBmb3IgdGhlIHVzZXI7IHBva2luZyBhcm91bmQgSQ0KPiAgZG9uJ3Qgc2VlIGEgY29udmVu
aWVudCByZWFkbWUgdGhhdCBjb3VsZCBoYXZlIGEgbm90ZSBhZGRlZCBsaWtlDQo+ICAiVGhpcyB0
b29sIHJlcXVpcmVzIHRoZSBQeVlBTUwgYW5kIGpzb25zY2hlbWEgbGlicmFyaWVzIi4NCj4gQW5k
IGlmIHlvdSdyZSBnb2luZyB0byBhZGQgYSBkb2N1bWVudCBqdXN0IGZvciB0aGlzIHRoZW4gaXQg
Km1heQ0KPiAgYXMgd2VsbCogYmUgaW4gdGhlIG1hY2hpbmUtcmVhZGFibGUgZm9ybWF0IHRoYXQg
cGlwIGluc3RhbGwgY2FuDQo+ICBjb25zdW1lLg0KPiANCg0KVGhhbmtzIC0gSSB3aWxsIHByZXBh
cmUgdGhlIG5ldyB2ZXJzaW9uIHdoaWNoIGltcGxlbWVudHMgeW91ciBzdWdnZXN0aW9ucw0KdG8g
YmUgbGVzcyBzcGVjaWZpYyBhYm91dCBwYWNrYWdlcyB2ZXJzaW9ucyBhbmQgcmVtb3ZlIGl0J3Mg
ZGVwZW5kZW5jaWVzLg0KDQo+PiBCdXQgSSBkb24ndCBrbm93IG11Y2ggYWJvdXQgUHl0aG9uLCBz
byBtYXliZSBFZCBjYW4gbWFrZSBhIGNhbGw/IDpEDQo+IA0KPiBJJ20gbm90IGV4YWN0bHkgYW4g
ZXhwZXJ0IGVpdGhlciA6RA0KDQpTdGlsbCBJIGxlYXJuZWQgdXNlZnVsIHRoaW5ncyAtIHJlYWxs
eSBhcHByZWNpYXRlIHRoYXQhDQoNCkJSLA0KTV4yDQoNCg0K
