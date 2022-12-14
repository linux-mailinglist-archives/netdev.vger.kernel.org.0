Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC5964C194
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 02:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbiLNBAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 20:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbiLNBAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 20:00:43 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D0822298;
        Tue, 13 Dec 2022 17:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670979642; x=1702515642;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qTvkPfcV9PnGGJ3NBO+o6FhiL97sgsv4Bn+JWwh1L88=;
  b=E7f6A+YJK3XfsDwHBw9xiN3S9hoo2j8prF6bTPqz4x36BYyz+sziTjTD
   KamIGlYPYIOqe/sbOjiDIuG1VxRafcuGfTkytSByFfOBd4Xq5laLcaiwI
   oS/tudQpSUcBs50/AgcFAiD335mjzb1YjxMTGhJK2PNrc164nXQGPJNTy
   OXVvGCkM0sNxjFyDHmwbxQ6vIVGwrS1qZlV/MfgayKm73iGj0E5ZC775i
   WAaqg0opwlOqesA4LsBSFzP9qkCt0jA4xPWCZ7xYnTimP6bacMg0G1rZM
   NomNCLnbmtK0vGNZvg1gJstZj3hfwhjSMR5jRDb7IBrQdKoKP8XjurLz4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="316981686"
X-IronPort-AV: E=Sophos;i="5.96,243,1665471600"; 
   d="scan'208";a="316981686"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 17:00:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="642311568"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="642311568"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 13 Dec 2022 17:00:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 17:00:13 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 17:00:13 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 17:00:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXPMyT08Nd8OPTv97aB13+Xgvoz4nYzX366L2rja/yJg4lppOTo/sw8mBLc+8FAYBwjuRJtBz0t0JV7V3VduZC/g7JmxwXlTewn46N9ION0e2IRgax6U5Vz93HMpvWW6/pQW54RAuXTdr1jXH2dDe7FQlNZW9/jB4boEACKERKIQGFxl9ZTEE08j8dyEIXQL+7+vw53ep11OUtFRsTTImgBaLOBKnGy6DsBaI8kwICr6fIEGElS4mUfxVK97BAqJOGjeSkVML9eBo+PqAS+64qK4FchirCfIf9clrrDQh4q9WcUyCY1zgwC7/dP1zfPvbk+Dhxo4hggT35tXp1K7xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTvkPfcV9PnGGJ3NBO+o6FhiL97sgsv4Bn+JWwh1L88=;
 b=S/im/2cdcpjTl5VbBLdZGDUQDb6dCJ0DaOAtg6KcdoX6Rdrc6lTcQio0hSkwoV19G7aemJjQfUAr2sogVNLg2DcYbMAdt+yivIHqTtCbnfLmZMybqwEtcr+SW7s3BA9AiP5Z581bpdXoNPFLGXIuJYxCbm6EIloGTdpJFrs/+3BFJQ2f5qbyORBjeTfkM0cg8ygib7mImWWigG4bWMMbVDBdjES8wbqxu6cHkDqWJU2z4v0kGmjR4uc/NaaCHDPvxoBdgGfkPI/zqRXqEPR/QuIDwEERcs+G+dCaIuQfOLSnKrlHFSfDiimP6LRuQVgFjVgafI6qyVZlaZIliVFxEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA0PR11MB4526.namprd11.prod.outlook.com (2603:10b6:806:96::15)
 by SA0PR11MB4654.namprd11.prod.outlook.com (2603:10b6:806:98::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 01:00:11 +0000
Received: from SA0PR11MB4526.namprd11.prod.outlook.com
 ([fe80::7ec5:93b6:3b78:b6b8]) by SA0PR11MB4526.namprd11.prod.outlook.com
 ([fe80::7ec5:93b6:3b78:b6b8%9]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 01:00:11 +0000
From:   "Gix, Brian" <brian.gix@intel.com>
To:     "harshit.m.mogalapalli@oracle.com" <harshit.m.mogalapalli@oracle.com>
CC:     "darren.kenny@oracle.com" <darren.kenny@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "harshit.m.mogalapalli@gmail.com" <harshit.m.mogalapalli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "error27@gmail.com" <error27@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: Fix a buffer overflow in mgmt_mesh_add()
Thread-Topic: [PATCH] Bluetooth: Fix a buffer overflow in mgmt_mesh_add()
Thread-Index: AQHZDiryDAoTipdgwUu+ugu+1DNf7K5skn4A
Date:   Wed, 14 Dec 2022 01:00:11 +0000
Message-ID: <c4735e3004fe672890b7362ff3a9864d25d39cdf.camel@intel.com>
References: <20221212130828.988528-1-harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20221212130828.988528-1-harshit.m.mogalapalli@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2 (3.46.2-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR11MB4526:EE_|SA0PR11MB4654:EE_
x-ms-office365-filtering-correlation-id: 1041dca3-6129-486d-cd66-08dadd6e8d50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IRYXaqj92bRyWoZOT9O6b7BlSS2Cdv9x+uZR3HfOZ0mDCUinQqEiSGFOvxxT5kmMcmXd0i9rUa5/zbLsryeJ1Aw8XCUNRyiycZ82dxoubZlzJJU5jkvaBrpnkLSWgtf2aeMlTxwm6dgwwG3Ok0TXowhIR44DCfdsmdOARaqS38Ky0A5irqOTtTn7dr0kq957D+Qt+/ZbIFm66KxAaI9cS16EsNf4fH5bCZZyni/jkFZd4t9tUq5OeA0oxGW+ILZaYlL0XxM1RH2zMHt0MESCa+hDWYd3PAAbUnZ4HYjiPMDZ1r5/IHATrI6lgKA4Q2Z64Z0pxS49z1Y6J8y18Sy97Rx6zFa1t4f229CnMXya6I3qheeHgRkyDNUcjThXMdSA1bmzZXt+gxLlMTFG2gW5yV7hVOv+s/edSGtk9bE24Fgd+a78XajAvsE7YJIYwrD9iewq1d6343Q+EwNpn7nYypeDZI3I/NscdoUd/tcVVn1qiFAt2MgB+9E3wUl0OW619U2ZvDp9D51393RRqIOD4PyBvJ/YpOtWhcrHFlq9Adt4GPJwAV5so5OQHQn5o/Df32jL4d06oZW2rwjbSij1MdxsdIlf6p4sc6TANV8gSzkD4xRpJ5z94fJB2TKs90XpkWTp5gzsiGpobw1BjdD7UI/+LVUwExL2fgwwB2z9+u+qRfVqxV4icnQHOxITE2M2SgKfy2mqOvujJWJ3pFAWdDT56M4542WQXd6pWUdDnCOY3BdVmmXquXDJGiRuvcGTHE6kduStRMdtPaOePIQd2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR11MB4526.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199015)(7416002)(316002)(6916009)(4001150100001)(54906003)(2906002)(122000001)(41300700001)(38100700002)(478600001)(82960400001)(2616005)(6506007)(966005)(38070700005)(71200400001)(6486002)(8936002)(36756003)(5660300002)(83380400001)(66476007)(86362001)(4326008)(66946007)(186003)(76116006)(66446008)(66556008)(6512007)(91956017)(64756008)(26005)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHFiQ21RWkdIMG85RjB2YzludXUyNTJocFhqa0VhQmhVN0k0cVVsNlBvSWsy?=
 =?utf-8?B?UWFxL2o1UEdsTVBXTFhpNEt6YlZEUVhjMWhZb0ZMc0c3b1FSSHhpcHF0eExP?=
 =?utf-8?B?ZDVmd0s0TTI4TG4xSFRvZXBLZUdmTStyQUVCVTF1WFFpZGMzZ2FNRHU1emVD?=
 =?utf-8?B?ajhIUHFQMk95NWo1eUUwS0orUDYvcE56SHJVK21EckhVVTR2ckczNlp2VDlU?=
 =?utf-8?B?MVZDeS83ck8yUVp6M2NRZ0xFYUpDaGlvTHNJaWZ6bGJpSTBtcGZ3Wlg4WllX?=
 =?utf-8?B?dGlINm91L05iSkVGTW15L1FaN2FJd3JqdFpReWdFN0VCRnNEazNOb3JOcjJy?=
 =?utf-8?B?aERUaGVVc2tNRjNWVk1XVys4aUVDVUIwenljcTF1TEdzUG5ua2FudlJXT1FX?=
 =?utf-8?B?ekh5dFpBdDlrc1pMN21Vd0RuMXRrNDgwSndnN3NvcXp0endLMnIvNkJQc3Bw?=
 =?utf-8?B?bjNvNG5rMmZiam41S2toSzBVd1dLd1cvUU12R2VDNk5HbEtBdFpER2YwSXlH?=
 =?utf-8?B?SnRpSTFXenIzenFQa3lOZTAwWVJtYnB5dENzTk5mTWtYc1pneGJkQmU0WXVo?=
 =?utf-8?B?UnFqQ3NUOHpENXZRSWxHWGFKNG1GNmptYWtqTGJIY244VDVqUUR3NUdYVXhy?=
 =?utf-8?B?R1N3STc5Rk5kYi9KR3R0S3g3ZWh4bS9USlNxU3piSjBNejVQQlBPWUtUbHox?=
 =?utf-8?B?WFUzbTNWUnYwbG1BZ2JKNDF2bDNRL0Y0emx6akRodXprcU13aERqeTNXbS9s?=
 =?utf-8?B?QTlJaENHZy9IMWY2WTVlcExGVklIQkZCTGR2N0xDSndvWkZFNEJqMG8xL25S?=
 =?utf-8?B?d2JvaU8rWWlkVW1pTy9iWnVKRTlINDR0ZFpJVDhSV3pQUGt5eGZKOFZpMXJl?=
 =?utf-8?B?SmNMK3AxNDNvRmlRdGZ1ZUVITGY0aElVVVBjVjZmUmJYRklKQ2lMWWVzaUdO?=
 =?utf-8?B?NFlGVTJqWnd4ek5NbXFqaVJvY0xDeW9PcjljMW8vK3RHN0d1bEVPeHRDK091?=
 =?utf-8?B?bWdwWjAwWGJ1QTExakIyUXlnQ0hIUXgvKzdrSjlpWi9wRDZxRGlVbFZZZFI5?=
 =?utf-8?B?V2djZmVmd3pJRXRTcTNwWHVEc0pma3RqNW9XTlNxcUEwbVZQS1hGMnZPMWFG?=
 =?utf-8?B?Y29xN1ArZmFDTlUwWmxsN0p3N2tITFRUYlJwQmN2RHdXUHgvOXpRa2tuVHhz?=
 =?utf-8?B?UElmQWg5a0tDNVJYbzc0T3F3RjJFQlRncG5lc0RLdmpGNndXaUY4WGhvcytx?=
 =?utf-8?B?L0k5TzY1aXlLSVY1RXpTZjJMVldXemkzRnpjakJWdkxoZXBwUGFnM3FDSWsw?=
 =?utf-8?B?S1VuSnVIOGFhM3Z5M3p0TGhQK3BuSUwzUzlKbkNBSEhZRFEvaHFlZVRxVU1k?=
 =?utf-8?B?QWY2Y09TYmtYam02Y1p5UXhvYjBMbjY0Zmo1ZHpUSm84VXRxTGVaNzV0Ujlu?=
 =?utf-8?B?eDR3Uk92QUx4Z2NOZVBhSmhIaTdYSXM1VWtmY3MrWnFEbGsyQWN4RXAvRUlC?=
 =?utf-8?B?STRibGU4a1c3RGtqMnRWTGQrMElGR284RDJDTGl6SGJzR25pS2lGTHYrOWMr?=
 =?utf-8?B?ZHlub1BQRDFPUko4R2xKNWUwUURMTUxtSmI3cGtWUFFCNExlY0d5WGhPNHZQ?=
 =?utf-8?B?Vk5xbDVUdlNqZkl0Yng0eHNZOTIzQjVwZHdxZ1hudTBDYk8zdFkzUGFBdjNO?=
 =?utf-8?B?YjVxdWh5dGVQS2EvRFR2eENkS3YyWnJoWkwrWUNqM0RUZXpvUW9rT2Z2RzUw?=
 =?utf-8?B?ekhZVnJFaENNRHZSS29wTVRQUThOWEZWM0JJTGtHamRTVUV6ZDhVOFlpZDlY?=
 =?utf-8?B?cUdkM2dBNmpoMjJkQjRpZWZtTk9NSmJYbGpGd1ZOcUw2aXloK3RNWUlUN2x6?=
 =?utf-8?B?ZjltTUJWU0N4QTlOaGJvRjdHNUl4cEQrTjhRRHF1K1ZOOUphaXBLOFpjZFZn?=
 =?utf-8?B?QlZzUlhjdW95SDhmZngzc1dCMnRBK1FqNC9IOGdFZytuR3lvcXBMS0ZnNFFw?=
 =?utf-8?B?bXJSS1RaOFB0WkhZSnc0YjZCYUdoTEoxdm9kR0RkSjNIb0d5MFZ5Q05GOHRv?=
 =?utf-8?B?ZWw2N2FSTCtqQk5tcDZPWVdRc05TRjlKaVJ2NWlpQjZMREpUcUFYVm1BUkh0?=
 =?utf-8?Q?VAIy3O+KxgQIx5vNMs2lG/C9F?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C18CEDF0ABB1EA479C41309713EDF903@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR11MB4526.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1041dca3-6129-486d-cd66-08dadd6e8d50
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 01:00:11.3214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9efGNKzVPrBo4TnNAobHGJ/dKwYGsjAmKWUWY6sAE2/G1HyeAo9/LRqTviwoaCK6U2n3AWejwPdDKRx35GMtIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4654
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2lnbmVkLW9mZjogYnJpYW4uZ2l4QGludGVsLmNvbQ0KDQpPbiBNb24sIDIwMjItMTItMTIgYXQg
MDU6MDggLTA4MDAsIEhhcnNoaXQgTW9nYWxhcGFsbGkgd3JvdGU6DQo+IFNtYXRjaCBXYXJuaW5n
Og0KPiBuZXQvYmx1ZXRvb3RoL21nbXRfdXRpbC5jOjM3NSBtZ210X21lc2hfYWRkKCkgZXJyb3I6
IF9fbWVtY3B5KCkNCj4gJ21lc2hfdHgtPnBhcmFtJyB0b28gc21hbGwgKDQ4IHZzIDUwKQ0KPiAN
Cj4gQW5hbHlzaXM6DQo+IA0KPiAnbWVzaF90eC0+cGFyYW0nIGlzIGFycmF5IG9mIHNpemUgNDgu
IFRoaXMgaXMgdGhlIGRlc3RpbmF0aW9uLg0KPiB1OCBwYXJhbVtzaXplb2Yoc3RydWN0IG1nbXRf
Y3BfbWVzaF9zZW5kKSArIDI5XTsgLy8gMTkgKyAyOSA9IDQ4Lg0KPiANCj4gQnV0IGluIHRoZSBj
YWxsZXIgJ21lc2hfc2VuZCcgd2UgcmVqZWN0IG9ubHkgd2hlbiBsZW4gPiA1MC4NCj4gbGVuID4g
KE1HTVRfTUVTSF9TRU5EX1NJWkUgKyAzMSkgLy8gMTkgKyAzMSA9IDUwLg0KPiANCj4gRml4ZXM6
IGIzMzhkOTE3MDNmYSAoIkJsdWV0b290aDogSW1wbGVtZW50IHN1cHBvcnQgZm9yIE1lc2giKQ0K
PiBTaWduZWQtb2ZmLWJ5OiBIYXJzaGl0IE1vZ2FsYXBhbGxpIDxoYXJzaGl0Lm0ubW9nYWxhcGFs
bGlAb3JhY2xlLmNvbT4NCj4gLS0tDQo+IFRoaXMgaXMgYmFzZWQgb24gc3RhdGljIGFuYWx5c2lz
LCBJIGFtIHVuc3VyZSBpZiB3ZSBzaG91bGQgcHV0DQo+IGFuIHVwcGVyIGJvdW5kIHRvIGxlbig0
OCkgaW5zdGVhZC4NCj4gDQo+IFRoaXMgbGltaXQgb24gbGVuZ3RoIGNoYW5nZWQgYmV0d2VlbiB2
NCBhbmQgdjUgcGF0Y2hlcyBvZiBDb21taXQ6DQo+ICgiQmx1ZXRvb3RoOiBJbXBsZW1lbnQgc3Vw
cG9ydCBmb3IgTWVzaCIpIGluIGZ1bmN0aW9uIG1lc2hfc2VuZCgpDQo+IA0KPiB2NDoNCj4gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjIwNTExMTU1NDEyLjc0MDI0OS0yLWJyaWFuLmdp
eEBpbnRlbC5jb20vDQo+IHY1Og0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMjA3
MjAxOTQ1MTEuMzIwNzczLTItYnJpYW4uZ2l4QGludGVsLmNvbS8NCj4gLS0tDQo+IMKgbmV0L2Js
dWV0b290aC9tZ210X3V0aWwuaCB8IDIgKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvYmx1ZXRvb3RoL21n
bXRfdXRpbC5oIGIvbmV0L2JsdWV0b290aC9tZ210X3V0aWwuaA0KPiBpbmRleCA2YThiN2U4NDI5
M2QuLmJkZjk3ODYwNWQ1YSAxMDA2NDQNCj4gLS0tIGEvbmV0L2JsdWV0b290aC9tZ210X3V0aWwu
aA0KPiArKysgYi9uZXQvYmx1ZXRvb3RoL21nbXRfdXRpbC5oDQo+IEBAIC0yNyw3ICsyNyw3IEBA
IHN0cnVjdCBtZ210X21lc2hfdHggew0KPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHNvY2sgKnNr
Ow0KPiDCoMKgwqDCoMKgwqDCoMKgdTggaGFuZGxlOw0KPiDCoMKgwqDCoMKgwqDCoMKgdTggaW5z
dGFuY2U7DQo+IC3CoMKgwqDCoMKgwqDCoHU4IHBhcmFtW3NpemVvZihzdHJ1Y3QgbWdtdF9jcF9t
ZXNoX3NlbmQpICsgMjldOw0KPiArwqDCoMKgwqDCoMKgwqB1OCBwYXJhbVtzaXplb2Yoc3RydWN0
IG1nbXRfY3BfbWVzaF9zZW5kKSArIDMxXTsNCj4gwqB9Ow0KPiDCoA0KPiDCoHN0cnVjdCBtZ210
X3BlbmRpbmdfY21kIHsNCg0K
