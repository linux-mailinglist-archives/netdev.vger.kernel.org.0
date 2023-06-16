Return-Path: <netdev+bounces-11487-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E60E573352E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B15D2807AD
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1EAF19932;
	Fri, 16 Jun 2023 15:54:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE99B79E5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 15:54:09 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63317297E;
	Fri, 16 Jun 2023 08:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686930848; x=1718466848;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fLeOZ1ge4GWh87JVohKMOC8h2kUKa0c0NM2na3d/PaU=;
  b=bbWkFjTvvYP/tEnsKXZW5SAedpKr7eL69g63Qo87gCfr5hOXiWsIMVVy
   PeUDGIuIVfcj9BzA8yXFUqCg/wIHk42d6KeS1yqVMnFmQ0tnzuG3aIiMG
   fXtv2VAPRo8kvHbzf2kPcfc68I4UQNMOyIGt8w0PB6XHcQfunAxEpXwxD
   skigSwkpUP8td/taUxGikLGQsm8yXazaFkceGR5yTPXm70pVV/9X+vSlF
   8/E4G4dEJjlV6Z5P32CmOed1wUlcyMGRKFevF8bubjv4UD31SzR/W0EIM
   QcVOpLmpaKCHU6/2bTNdWojDFH6h+XGmm9GhwiZiKBpoBIC2hj270yEUG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="359252586"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="359252586"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 08:54:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="690289007"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="690289007"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 16 Jun 2023 08:54:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 08:54:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 08:54:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 08:54:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MH2COoB2iJOmUZqWz3TcA4swzDtLE+OlbhKuJA4hDsWH174hDAaZuipV5KmM+xdFw0XJdt63Fo2U0KGeMF3rj6m7GKGOltok82AtKs9x/lSqC6J/35ggXxDlPInaCXWWXXLfeMHODxCnX6oi5HF1Bx2HvyLF5MjreCKuo+5P50ZhxSBmPj6DsvJvfJjQrk0JTvjxkzUbJ0FWm/Ruisgiqt3l0ce6iC6untfnw/JXxeT80lFd6t7J0TSvGHYEKtlchy7iDmmxgzImBpEr1NjWZ8e40YMj6fmkDqn91nW70tdDXpc1/olfYuMLDZyPzIVROt+RAS/pf5E5b0TA1vzkJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fLeOZ1ge4GWh87JVohKMOC8h2kUKa0c0NM2na3d/PaU=;
 b=WMbWwspmo0oGMB6c9RHkfAizyEJ/frOmSaziI6b+RQuTlbhe5LSPFcmLrMOv0Jc6GzFrE9ipA9mlN9M/J9PwLfMCMJYbrRHb+xunXcq9c9n0i/En1qOQhaCE+WAAMeDiczaGMWMQ3CV2QOBIkTv+P4tBnaaRcI4nfuLQVsA2Kx1I6d84Ys8vS9dwB53cbSyP9KMV4jLYXlOAEdPxGvnz9/eB/ly08bMYCPi52cHMxDkHwndb9DFTu4DtKiJK32aGqSuz3Ogn1pf2ZFNEH/4ugqwCjVkXtKwsHN3yHDoVzq1vyhtc7qhan/6U7Zz2y8sRZiM2MesV69gRf6DqN+BP2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by MN2PR11MB4568.namprd11.prod.outlook.com (2603:10b6:208:266::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 15:53:58 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::dfd2:5a47:bfeb:aa2e]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::dfd2:5a47:bfeb:aa2e%4]) with mapi id 15.20.6477.037; Fri, 16 Jun 2023
 15:53:58 +0000
From: "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To: Florian Kauer <florian.kauer@linutronix.de>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Tan Tee
 Min" <tee.min.tan@linux.intel.com>, "Gunasekaran, Aravindhan"
	<aravindhan.gunasekaran@intel.com>, "Chilakala, Mallikarjuna"
	<mallikarjuna.chilakala@intel.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kurt@linutronix.de" <kurt@linutronix.de>
Subject: RE: [PATCH net-next 0/6] igc: Fix corner cases for TSN offload
Thread-Topic: [PATCH net-next 0/6] igc: Fix corner cases for TSN offload
Thread-Index: AQHZnsmr6RJrKMVwJEipSQnMpRCh9K+Nl7Hg
Date: Fri, 16 Jun 2023 15:53:58 +0000
Message-ID: <SJ1PR11MB6180B5C87699252B91FB7EE1B858A@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20230614140714.14443-1-florian.kauer@linutronix.de>
In-Reply-To: <20230614140714.14443-1-florian.kauer@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|MN2PR11MB4568:EE_
x-ms-office365-filtering-correlation-id: d07d8fce-8732-442b-b60d-08db6e81e555
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x+w8Vf2rbh/dB93uUfhJQkpcawrfCPlkgMTV4ISyHeOsAvk4lNRugwlZ3DE+hRIVNP8TetHJd9TZ5UtgCeu/3o6JTEf9/T5H56GV6NERSHb3Q8Hoqc+eUA1IhQ8bJwXHZtN7Cpt5luQUJ93KEYhPNj3anzP2Q5x6LMyGWe0fP/3whRbVUF4xWc4Konm+ddHtIcmnHygv4nPhd+sunbfU1Ls9CzuCBoVkI334RiWjyexW0syIYuKoMRRVBdBqwHd1MrYsmBobxp08dRNgf2gsWrkjyYUOZk2Qfe3+vmGZebCca7X04HgZyQkhc8SvbXtmOVyF0HKH4qMzegQxbKZaQ4SJydDzwvCWsEiCLDv+XKGvCZ+NCm8NCeVc9Zbwzhy3HMK1lE26wnOAWfFbtbLyWNXl20a0qXDgIWdoc9Ic5uKR+gX5sancBQLL2wc4nIIuS00XEPZQGClzAUBA/OVgpa1VlAZ0zbMkSFKVsfdydkOU9qgsywOgmrEHSTRp3XrxefDMG7pylgLw+G/byVMTV2CVorolTEfG06o8GCBwqchB03TyHzBXec4143fikPVkgEMa8lz+n2UhXJ560XwMC8S7S39cOgJDcLJqrlroCngYriZgNZZdIVZVvDlX1WxDtiOcSnlGL3QVCMsXJSRncg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199021)(110136005)(54906003)(41300700001)(8676002)(86362001)(7696005)(64756008)(66946007)(66476007)(66556008)(66446008)(8936002)(316002)(33656002)(71200400001)(4326008)(6636002)(76116006)(38070700005)(478600001)(7416002)(9686003)(55016003)(26005)(5660300002)(52536014)(83380400001)(6506007)(53546011)(2906002)(186003)(82960400001)(38100700002)(122000001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUs3WThNQ3pkNmlVK3hPNUpEM3kxQUMybEppOGZ3Z212MnVqYUFlQ3o2TEdu?=
 =?utf-8?B?Q0lneXFYdGtsUy9YVHhJbmh2dFBvMVpPNWE5dmxTUzNGaFptWE5mWXo3RlBV?=
 =?utf-8?B?Y0F2VEh2dzFxYjB0OXlvYUtQSlZvck1aeC9DUW83OEdOcGJaQkp2VC9nblRo?=
 =?utf-8?B?M1JHZmNVSmNKWDYvUlRkZ1YzLzNhQmxKSTVWYlhHQzNHaEZodWJlZkJpeDBV?=
 =?utf-8?B?WHJ6MEYzNU9RNFVHdGN1YlY1QThzcGpXYVNVeERwcS9JcnVwK1Y1aG5LYUs5?=
 =?utf-8?B?aHdvSjlkUTFicjZ2ZnpFdFhmTVUrcHdlYis0dmhVSlM5azZKR3ZteXMwQ1Rv?=
 =?utf-8?B?eEdQOW5nWnBwclM2eE5OdTNneHFFdnFxTUE1a3JjV1FjNmhObFRHZTJmSUpF?=
 =?utf-8?B?WU9hOVdiMVh1Y01tU2tkaDA3NDBKYnlyZENSbHdUcE03djZFV094anZ1SE5s?=
 =?utf-8?B?cUZ0UE5MNXByVUlQZTdlZEVqdks1UzNHNmpFRzJEcnRseGlsNHBQUGRmMnd1?=
 =?utf-8?B?djRSTGxGZ3oxcSs2ODZkUTRpOGhjWkhhMVFSZXBONmppajVydFg3dTdBM0dx?=
 =?utf-8?B?TFVzWXJZMWZWUUVVTmhzYnZtMW0vckhWei9TS1M5R25aK0NHdjg2eVZDaUVE?=
 =?utf-8?B?djZ4Z1dYZHVLTmJqOHBSczJUcDBUSWRZSzAvM0MzWS8rQ2pTc2FhQ2lSTlZl?=
 =?utf-8?B?aGRvemhaODV2NXE2bk9GR1QxN2VmQU5oSk1vRnM2aFJFMkwwTm1FVFdmK010?=
 =?utf-8?B?QWMvM0RTMm5YTWZaTWxETzk5MUluWENjKzdTaWkzdkdUa3lUQUVCVWREZzBX?=
 =?utf-8?B?NUc1Z2FWMlgxbk8wVE14U0hYU1lpUnlKRUhNdGdUb0EzWnNuZzFBNFdlMmVD?=
 =?utf-8?B?RmZQSTdIYUpQUjhaSVo4RXBPN1BaekcwWUFnWTVnS1kwOE9oWWl4aXBlQSsv?=
 =?utf-8?B?YkM5RnpFZUNjTHVoeVBiRUc2RTIza3dhRFMrUUZQcHZ4UDZpZFd1TndXcGJh?=
 =?utf-8?B?dGZKTXc1MG9yNndwZTBHcWxCNklxMkw3U1o0OEJYbHl5S0twQ1pXMjQ5ZThl?=
 =?utf-8?B?QW90Mkw2VThOMXUzZ0I1dC9wUm5mWmNRUm9pZ0RkbFVjelB1RCtvNlBIOWZw?=
 =?utf-8?B?YWJTUDlKNGZEQ3JRMVpQVU1NaXVWdEdTVGwzd1VUSU5UTUpjam93bVZIKzlr?=
 =?utf-8?B?WDJhaFpsbUw2VGdrZHdsWTIwTmw5NTg3aEtuRHBTTzdnc2Nib1BCTGQySjlL?=
 =?utf-8?B?WHcyVHdyRXVDL252UmUycWVRMVRTMEdKRjNkaFV5ZnFQUmNtaWhDeisyc0sr?=
 =?utf-8?B?WVNvcVZCWjh3Tzg5MUZuT2JsQ2FSeWZRNlFUNGVVN3dRNGlNUTdDQnJQV3Nz?=
 =?utf-8?B?S2lxamlBYmdTcmpUcTBLbHBNbzlQTU1JdGs1Uys1M1dPYU5SbjR6S3o3MTRN?=
 =?utf-8?B?VGVoei9aK2VXNjNmbEhLWTA1WU5td2Q4dG1rdktkekxjT3lzYlNUbTZnUEo4?=
 =?utf-8?B?TmdKYURWSDZYRGk1SjJWQmVRZlpkc2dMTEY5NXJwaDlrN1g0WW1DbUZmWDZZ?=
 =?utf-8?B?TUJDYVVQTEtKQUNYZ1hwYVcwZk80cjFHYmFpRU9KQ3hWWUhoalFiNlVGTDRK?=
 =?utf-8?B?NTR1WEYvTDF6OFp5cG82bVpIczdLWFROWEsvKzRCWjVBak9QaVlVV1pjQ0h2?=
 =?utf-8?B?TE43ZUhSdjlQRUlJdTQ3N2t6VlRlbzhYYlBiS1htVmtUMHE1V29zL3lPNHZm?=
 =?utf-8?B?U3lNL2d2V3YvVWt2R0lBSUNOWm9mSHdIMVRaOTBpeGN4cEg4WjNYcTlwb0Q3?=
 =?utf-8?B?RVc5L0tjM2VvSStzVk5ObTc5UzlvYmRFUU9YY1FlejJ5QmNWZ2xIdkZaT3Zn?=
 =?utf-8?B?Q0NnQlFiZXVmSGMzbDMydDI4alE4Q3dJRWdSbkJpZ0tFTi8yS1JrTUZ6UUw5?=
 =?utf-8?B?eXFxM2pkd21xWGhVeU1WL09TRkE4OWxzditOdEU1RWM4UlMrU1JnNTRheDYz?=
 =?utf-8?B?RkE3NDRqeG16eEE0QldRS2tTZkNvWVFUVFBXaFM0VkNlN0c4ZWJTVS9MWkhI?=
 =?utf-8?B?TWJpRW02aFpRb2xCSWgwNjlWM2hlbGw2dTd1UHV2MllFb2JRVjN0QTRQV2t4?=
 =?utf-8?B?c1BSUWFtaHkySjJNc3Fqd0c0M2NZTWlGR3R2UTgxdVNXTm0wYnlZZEY3Vktz?=
 =?utf-8?Q?AsLURPi+aUb4RVlPGTf8vuE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d07d8fce-8732-442b-b60d-08db6e81e555
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 15:53:58.0149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4a5DYf71g2EB5CBzYzyE3bJ5dxdQ6NFttWPUAK+RfbWKuIA8kZpN2O13TIfN+uKwVYeO+8JS3MkH4p0Kikzu2LCsNJWyvKVO4b/1li6Qqt53ZHyZVAOr7Twbv3Z63bJY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4568
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

RGVhciBGbG9yaWFuLA0KDQpUaGFua3MgZm9yIHRoZSBwYXRjaCBzZXJpZXMg8J+Yig0KDQo+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZsb3JpYW4gS2F1ZXIgPGZsb3JpYW4u
a2F1ZXJAbGludXRyb25peC5kZT4NCj4gU2VudDogV2VkbmVzZGF5LCAxNCBKdW5lLCAyMDIzIDEw
OjA3IFBNDQo+IFRvOiBCcmFuZGVidXJnLCBKZXNzZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5j
b20+OyBOZ3V5ZW4sIEFudGhvbnkgTA0KPiA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+OyBH
b21lcywgVmluaWNpdXMgPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT47DQo+IERhdmlkIFMgLiBN
aWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBFcmljIER1bWF6ZXQNCj4gPGVkdW1hemV0QGdv
b2dsZS5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkN
Cj4gPHBhYmVuaUByZWRoYXQuY29tPjsgVGFuIFRlZSBNaW4gPHRlZS5taW4udGFuQGxpbnV4Lmlu
dGVsLmNvbT47IFp1bGtpZmxpLA0KPiBNdWhhbW1hZCBIdXNhaW5pIDxtdWhhbW1hZC5odXNhaW5p
Lnp1bGtpZmxpQGludGVsLmNvbT47IEd1bmFzZWthcmFuLA0KPiBBcmF2aW5kaGFuIDxhcmF2aW5k
aGFuLmd1bmFzZWthcmFuQGludGVsLmNvbT47IENoaWxha2FsYSwgTWFsbGlrYXJqdW5hDQo+IDxt
YWxsaWthcmp1bmEuY2hpbGFrYWxhQGludGVsLmNvbT4NCj4gQ2M6IGludGVsLXdpcmVkLWxhbkBs
aXN0cy5vc3Vvc2wub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVs
QHZnZXIua2VybmVsLm9yZzsga3VydEBsaW51dHJvbml4LmRlOyBmbG9yaWFuLmthdWVyQGxpbnV0
cm9uaXguZGUNCj4gU3ViamVjdDogW1BBVENIIG5ldC1uZXh0IDAvNl0gaWdjOiBGaXggY29ybmVy
IGNhc2VzIGZvciBUU04gb2ZmbG9hZA0KPiANCj4gVGhlIGlnYyBkcml2ZXIgc3VwcG9ydHMgc2V2
ZXJhbCBkaWZmZXJlbnQgb2ZmbG9hZGluZyBjYXBhYmlsaXRpZXMgcmVsZXZhbnQgaW4gdGhlDQo+
IFRTTiBjb250ZXh0LiBSZWNlbnQgcGF0Y2hlcyBpbiB0aGlzIGFyZWEgaW50cm9kdWNlZCByZWdy
ZXNzaW9ucyBmb3IgY2VydGFpbg0KPiBjb3JuZXIgY2FzZXMgdGhhdCBhcmUgZml4ZWQgaW4gdGhp
cyBzZXJpZXMuDQo+IA0KPiBFYWNoIG9mIHRoZSBwYXRjaGVzIChleGNlcHQgdGhlIGZpcnN0IG9u
ZSkgYWRkcmVzc2VzIGEgZGlmZmVyZW50IHJlZ3Jlc3Npb24gdGhhdA0KPiBjYW4gYmUgc2VwYXJh
dGVseSByZXByb2R1Y2VkLiBTdGlsbCwgdGhleSBoYXZlIG92ZXJsYXBwaW5nIGNvZGUgY2hhbmdl
cyBzbyB0aGV5DQo+IHNob3VsZCBub3QgYmUgc2VwYXJhdGVseSBhcHBsaWVkLg0KPiANCj4gRXNw
ZWNpYWxseSAjNCBhbmQgIzYgYWRkcmVzcyB0aGUgc2FtZSBvYnNlcnZhdGlvbiwgYnV0IGJvdGgg
bmVlZCB0byBiZSBhcHBsaWVkDQo+IHRvIGF2b2lkIFRYIGhhbmcgb2NjdXJyZW5jZXMgaW4gdGhl
IHNjZW5hcmlvIGRlc2NyaWJlZCBpbiB0aGUgcGF0Y2hlcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IEZsb3JpYW4gS2F1ZXIgPGZsb3JpYW4ua2F1ZXJAbGludXRyb25peC5kZT4NCj4gUmV2aWV3ZWQt
Ynk6IEt1cnQgS2FuemVuYmFjaCA8a3VydEBsaW51dHJvbml4LmRlPg0KPiANCj4gRmxvcmlhbiBL
YXVlciAoNik6DQo+ICAgaWdjOiBSZW5hbWUgcWJ2X2VuYWJsZSB0byB0YXByaW9fb2ZmbG9hZF9l
bmFibGUNCj4gICBpZ2M6IERvIG5vdCBlbmFibGUgdGFwcmlvIG9mZmxvYWQgZm9yIGludmFsaWQg
YXJndW1lbnRzDQo+ICAgaWdjOiBIYW5kbGUgYWxyZWFkeSBlbmFibGVkIHRhcHJpbyBvZmZsb2Fk
IGZvciBiYXNldGltZSAwDQo+ICAgaWdjOiBObyBzdHJpY3QgbW9kZSBpbiBwdXJlIGxhdW5jaHRp
bWUvQ0JTIG9mZmxvYWQNCj4gICBpZ2M6IEZpeCBsYXVuY2h0aW1lIGJlZm9yZSBzdGFydCBvZiBj
eWNsZQ0KPiAgIGlnYzogRml4IGluc2VydGluZyBvZiBlbXB0eSBmcmFtZSBmb3IgbGF1bmNodGlt
ZQ0KDQpBbGwgc2l4IHBhdGNoZXMsIGFzIGZhciBhcyBJIGNhbiBzZWUgaGVyZSwgaGF2ZSB0aGUg
Rml4ZXMgdGFnLiBTaG91bGQgdGhleSBnbyB0byBOZXQgaW5zdGVhZCBvZiBOZXQtTmV4dD8NCg0K
PiANCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2MuaCAgICAgIHwgIDIgKy0N
Cj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFpbi5jIHwgMjQgKysrKysr
KystLS0tLS0tLS0tLS0tDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfdHNu
LmMgIHwgMjYgKysrKysrKysrKysrKysrKysrKystLS0NCj4gIDMgZmlsZXMgY2hhbmdlZCwgMzMg
aW5zZXJ0aW9ucygrKSwgMTkgZGVsZXRpb25zKC0pDQo+IA0KPiAtLQ0KPiAyLjM5LjINCg0K

