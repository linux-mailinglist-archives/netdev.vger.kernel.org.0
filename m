Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98D140A919
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhINIZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:25:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:17977 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhINIZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 04:25:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="201433310"
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="201433310"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 01:23:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="528619058"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 14 Sep 2021 01:23:52 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 14 Sep 2021 01:23:52 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 14 Sep 2021 01:23:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 14 Sep 2021 01:23:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 14 Sep 2021 01:23:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VF6HfEaoc6SVqIIbUsnBOy3OWaAsMzxGNkALsQ28zni9Q2iWA9WRSYmisbPbK+O++7hwFHqNsRkzy51SK4VTBi2IK7ML2T1KfKm+hlj/5zW5BCpTPIxRLO8WH0vaMRlKZ442iV5TdxhN6dV+Y1p/dxRy5aGjRI1ypQedcARE1f6pYGT72aPj1zkCLB2UhvICszkpMvPAldWFET0mrdPsJejOUSFrD6FwZnC7c/5Gp8xdNw8XPWM/SIdqred5S4Rpoo0Fj1W/xYboKpFf7XQc1SWe3xeTCYb2r4rxZpEnibkPjDMuoZQo0cyf5yQwR0XfVDIVyi17RIdKK0kSswcaCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rrsSBMJhq7FRzGm2/7VDYpvtioAw0Nd8sL35j1IPT+4=;
 b=Fp/yBz8DohlFhU77w509fI22YPRVnHx9etKgb0YngRj8d7TUUpvlWZ3ceaLCb3s/pDm7f7fJTtbxMoaPfkenFlkiDIxi50r+X+R4LPVkCM8AANWswtWtnDWauh2pCoBF5zOie9iwAog//eFENSfR2U8hYz0lArU/z/36Ivm3g9cRxSdSMc2R2BgLo7mKjjbZ361FK6QP5qnajBQtk7BMuvQWcDrFumkWXjNCf+YZHeG33I9gvTIxqaLrCWfSlNcfNgLh+NV0jtDmHkyvcHxvYA4QqT5sWDH1SfHOwH6s62c4sFSrq9cpCulgbgq6xW+8vKY5ZqKNYutU4xrif0hZVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrsSBMJhq7FRzGm2/7VDYpvtioAw0Nd8sL35j1IPT+4=;
 b=BPDtFK54MhQtwclF7jKYyibZaucQ9dfetGFl5RHfcGlx11swSkbhQ8ZtD+RMPNvq9ynGgVmEzyFNxo/bVeVtubQZJBV6r7IK0V7P2cYsWYdVLQlSUyerKRtPsUrnX2OL0GPqMQEzLi6OnLcFZ1eAc1fBFMRXH88oyi8ki1rb/Mw=
Received: from DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) by
 DM6PR11MB3372.namprd11.prod.outlook.com (2603:10b6:5:8::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.14; Tue, 14 Sep 2021 08:23:47 +0000
Received: from DM6PR11MB3371.namprd11.prod.outlook.com
 ([fe80::ade9:932c:827d:895]) by DM6PR11MB3371.namprd11.prod.outlook.com
 ([fe80::ade9:932c:827d:895%5]) with mapi id 15.20.4500.018; Tue, 14 Sep 2021
 08:23:47 +0000
From:   "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "pwaskiewicz@jumptrading.com" <pwaskiewicz@jumptrading.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pjwaskiewicz@gmail.com" <pjwaskiewicz@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Topic: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Index: AQHXmsiBRJTk/bztnkiJewAWaKSBqquMjXAAgAGS54CAFFexAIAAD6UAgADBxBA=
Date:   Tue, 14 Sep 2021 08:23:47 +0000
Message-ID: <DM6PR11MB3371A3D1F314F3B8541FAF03E6DA9@DM6PR11MB3371.namprd11.prod.outlook.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
         <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
         <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
         <MW4PR14MB4796AE05A868B47FE4F6E12AA1D99@MW4PR14MB4796.namprd14.prod.outlook.com>
 <bebb58f34ed68025e95f8bc060af58a24333374b.camel@intel.com>
In-Reply-To: <bebb58f34ed68025e95f8bc060af58a24333374b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e5ea5ef-8b67-4172-73c2-08d97758f976
x-ms-traffictypediagnostic: DM6PR11MB3372:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3372FBED3FD102D322F8E972E6DA9@DM6PR11MB3372.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GLyPPc05V1cMEKdrClonU1Y5NsbCeVukCxbktleN6U7IWMqFX74vzCvMQB8M0zDxoGjzuoza1htgagW3SvU/eoIUjV1e1CI0ahu1lvbW2T2YStUQLkBzUrbn31RohD1Uppj5JWuqzNqHA5yYH0knUtcqKmU4hBlmjclJAxsxn4Xx1fmIUiv5LWuMm8krNByQCRF6laXRz9Pk9V7DcKwRuBWSx6f5wNXUJ6Z0lJYSg/XLxOMe2btUn57s0irtM9n/pWbgW4qvTrToDjxEIi2S/sluOm4pZXcHVROOhtwPfD1c4vQokhD64ajOIyb0BR/rY3Td8nGN1QG0e/h6PgIPA+wKrHQtXjJDzhr3nA34yuCw5iOQoFGmAk4mSZh+yQLysxj1I4ULi/8v4CvkZawpFiGhtU/yQVVM6O/54VXsgVxxgGc/ppB9MuoEDP4AcmPMBXwkvWx9WOQsmmNQ1yY82UlcQruJIfoO+BJKNdCSjsmgCGlBJiXpFvjHnQHBVP/iekJRJrfD4Q7spDr9rZQCzIKylkQVJo9uau3T/APDbXCCrM/ulbfkHC/lwZjhr2eldW0olct9/tORR8s0bw6sbkt++upVMaFhm43GLiFIOelJvDipw9kalfB0c1X1fbkH9V/1nftLiWgCidKFn5LybCDcX3haVQDoUBzQIMya3CU6G7+9APbvXiQNt9DFXLxP1bJ+1x5W6mqnONExUaQXkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3371.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(316002)(54906003)(110136005)(64756008)(66556008)(76116006)(478600001)(86362001)(2906002)(33656002)(4326008)(71200400001)(83380400001)(6506007)(53546011)(7696005)(8936002)(26005)(52536014)(5660300002)(38100700002)(9686003)(66446008)(66476007)(186003)(122000001)(8676002)(38070700005)(55016002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3VURmQzVWNLUUpwc2tTc1E3STlzcWY5L2F3T01TZHRJOUNmS2xGQzgyMjNU?=
 =?utf-8?B?aGZyQ1l2SGhhbE9La1AyWGltSk9JaDdxbkNvVVQxeThkR2NYRmgwbENxeWFv?=
 =?utf-8?B?VFNhT1F0ZmN4RERpTFh4Nm5kdkxjU294MUlMR2F0NkJGc09kcndxQVBvV3Ro?=
 =?utf-8?B?U2l4Y0F4aWcvUzV1UDZTTndMdXJ4Zy8rMThWRnJ1Ym8vWTM3UGh5cHhTVlZF?=
 =?utf-8?B?MnErdHpTNkZ4MllXT0FiT0I2OXkzeWRlVzdBdVlOTkFOQXdUR0RwSU9lUjhH?=
 =?utf-8?B?WjhLZUwwZVFZYlkrNnBpUEt2SWF4RFU2R01oWkVoNVBGcm5CK2FlZm5TOUVv?=
 =?utf-8?B?c2FhaE1qTUJqT3B5dDhFeHhGRU9EM0dIaWRtdVVmcjJYd3ZqOVV2UlFrTDN1?=
 =?utf-8?B?MnZUc2MxSnhQT0pSdGpQOUVrTGxIZzJCdlphZnc0eTVCbmViNXprWWhmWnZt?=
 =?utf-8?B?RC9ybVNETHUyZzAydUhZbk1jc0F4S1BtNzY2TFJaRG1zYm4wVnFsODllbVlF?=
 =?utf-8?B?OWxXM3M1OHpOaFpHUFpDS3NKdzM2NTVxWFV3UGgrbFJFKzM0KzRybVZxalRO?=
 =?utf-8?B?RUhibG5jRkwyUWM0N2h1U1R1R1JUTlhZa3dxTnlNMDJ6THJxRHlZY2paekV5?=
 =?utf-8?B?S0ZFM2V1YUtGTlNIZkwwMS9HVFpGL3gvZXpTNUlML1lWaWZqc1ByY2dxODRO?=
 =?utf-8?B?aDg2b2ljV3RzUjZRWkd5ZktYSkYwWHN0YlhMOUtJUjBEdjRJR0VsUEdwM0xq?=
 =?utf-8?B?K2NpVEV5WHIxN3dpRGJoK3ZETGsrTmlEdWYxQUxGV2pTOVZyOGNSZ29Ra2dy?=
 =?utf-8?B?SG9pK3BkMW1aYjcwTDh2TFE3RGtVTGtNMWo0bWV5MGRlY2dVaGJNelVFbVAr?=
 =?utf-8?B?NWljWXJLU3M5cDNhcXhwWS8wb1BpZmM1WVM0blRPTk1BNm1LaUtSbHhrRDE0?=
 =?utf-8?B?QjE3ajB3OXZIVVYydkQwQ3hBNHN3U3ByWng3a0JJcHo0Wk1yZUd2YXk1MEQ3?=
 =?utf-8?B?KzhtS2pYbmhqaGhHeTFEVDJicHlnQURMYVY4cWVOVXVIMy85SWxuOE9XNk1h?=
 =?utf-8?B?V1RLazRkZ2xrUWwxVEtIUlNWNGc1Rk9zNk51azBQR2FaWXJncDNqNDFObkxj?=
 =?utf-8?B?SHljbm5IOVJUcjVFL1FoN0JlN2dNOHhPSm1ITlV1Mm05SUhndi9NZzU0azBX?=
 =?utf-8?B?eDBkN1E3VFkrWHcrZHNrWWpSL0UxZzNVTXo0WWh5bWxtTGlZSzBqKzdUT2E5?=
 =?utf-8?B?ZExCY3NWSHdCTkhiY2g1azE5cUUyakgwWVlTU0huZHhrU3Q0MEQrYW4yYTIx?=
 =?utf-8?B?Slc1N3VRb21naEhpY1RXUGlHcm8wWmc3S1BVTGhyZkZKVG9WRUJ1U2wvbVho?=
 =?utf-8?B?aGR4dEx1YWFBeWhqNUxXOVp3cDJXODlldE5IVXZWMk16VXhMaE5VSWgrb0xt?=
 =?utf-8?B?U1RYSWVZa0l0VWFJQ2M5djBydDd0QWR0eWdSSjJWa3orTllobXRTVG1sczN5?=
 =?utf-8?B?T1hoZjQzQTBySVV2WjRQNE05cjlZZllaSEVLdFlrNSswTGlYVURQM1hnY3ZO?=
 =?utf-8?B?cDhlQmNRUFE1ZnB3Uktoalc3MDRMMlFhUWZIUWdrTk9HVjl4Q0djRTI2NkNE?=
 =?utf-8?B?SDNzYkZHSU5adE5lbGt4Y2R3MmRnRElsczF5Wnp4VEZMMDRrZThjV0k0WTNr?=
 =?utf-8?B?ZXRTV3YvaDdjeVRHbzVMY2h1SEFyVUErMGI5bjdsZFU2S2RlZDhiTUQxWDhB?=
 =?utf-8?Q?uzXGQYU+jObpF3sj9Wua6D6gbhbzjtko4tBE7fF?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3371.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e5ea5ef-8b67-4172-73c2-08d97758f976
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 08:23:47.3614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NiyfqRE9WlbvkI0zpaw5c0u5pxV4qX/QSR5YfwrbtseLSiAnoXEV0JlqZzyXAyoXjBcmFQ0etgQqaJMQzTTnq1ZQDTWM91RNy2tcPVFGxx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3372
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBNb24sIDIwMjEtMDktMTMgYXQgMTk6MzcgKzAwMDAsIFBKIFdhc2tpZXdpY3ogd3JvdGU6
DQo+ID4gSGkgVG9ueSwNCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
PiA+IEZyb206IFBKIFdhc2tpZXdpY3ogPHB3YXNraWV3aWN6QGp1bXB0cmFkaW5nLmNvbT4NCj4g
PiA+IFNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCAzMSwgMjAyMSAxOjU5IFBNDQo+ID4gPiBUbzogTmd1
eWVuLCBBbnRob255IEwgPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPg0KPiA+ID4gQ2M6IGlu
dGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBwandhc2tpZXdpY3pAZ21haWwuY29tOw0K
PiA+ID4gTG9rdGlvbm92LCBBbGVrc2FuZHIgPGFsZWtzYW5kci5sb2t0aW9ub3ZAaW50ZWwuY29t
PjsgRmlqYWxrb3dza2ksDQo+ID4gPiBNYWNpZWogPG1hY2llai5maWphbGtvd3NraUBpbnRlbC5j
b20+OyBEemllZHppdWNoLCBTeWx3ZXN0ZXJYDQo+ID4gPiA8c3lsd2VzdGVyeC5kemllZHppdWNo
QGludGVsLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IEJyYW5kZWJ1cmcsDQo+ID4gPiBKZXNz
ZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBQ
Sg0KPiA+ID4gV2Fza2lld2ljeiA8cHdhc2tpZXdpY3pAanVtcHRyYWRpbmcuY29tPg0KPiA+ID4g
U3ViamVjdDogUmU6IFtQQVRDSCAxLzFdIGk0MGU6IEF2b2lkIGRvdWJsZSBJUlEgZnJlZSBvbiBl
cnJvciBwYXRoDQo+ID4gPiBpbiBwcm9iZSgpDQo+ID4gPg0KPiA+ID4gT24gTW9uLCBBdWcgMzAs
IDIwMjEgYXQgMDg6NTI6NDFQTSArMDAwMCwgTmd1eWVuLCBBbnRob255IEwgd3JvdGU6DQo+ID4g
PiA+IE9uIFRodSwgMjAyMS0wOC0yNiBhdCAxNzoxOSAtMDUwMCwgUEogV2Fza2lld2ljeiB3cm90
ZToNCj4gPiA+ID4gPiBUaGlzIGZpeGVzIGFuIGVycm9yIHBhdGggY29uZGl0aW9uIHdoZW4gcHJv
YmUoKSBmYWlscyBkdWUgdG8gdGhlDQo+ID4gPiA+ID4gZGVmYXVsdCBWU0kgbm90IGJlaW5nIGF2
YWlsYWJsZSBvciBvbmxpbmUgeWV0IGluIHRoZSBmaXJtd2FyZS4NCj4gPiA+ID4gPiBJZg0KPiA+
ID4gPiA+IHRoYXQgaGFwcGVucywgdGhlIHByZXZpb3VzIHRlYXJkb3duIHBhdGggd291bGQgY2xl
YXIgdGhlDQo+ID4gPiA+ID4gaW50ZXJydXB0IHNjaGVtZSwgd2hpY2ggYWxzbyBmcmVlZCB0aGUg
SVJRcyB3aXRoIHRoZSBPUy4gVGhlbg0KPiA+ID4gPiA+IHRoZSBlcnJvciBwYXRoIGZvciB0aGUg
c3dpdGNoIHNldHVwIChwcmUtVlNJKSB3b3VsZCBhdHRlbXB0IHRvDQo+ID4gPiA+ID4gZnJlZSB0
aGUgT1MgSVJRcyBhcyB3ZWxsLg0KPiA+ID4gPg0KPiA+ID4gPiBIaSBQSiwNCj4gPiA+DQo+ID4g
PiBIaSBUb255LA0KPiA+ID4NCj4gPiA+ID4gVGhlc2UgY29tbWVudHMgYXJlIGZyb20gdGhlIGk0
MGUgdGVhbS4NCj4gPiA+ID4NCj4gPiA+ID4gWWVzIGluIGNhc2Ugd2UgZmFpbCBhbmQgZ28gdG8g
ZXJyX3ZzaXMgbGFiZWwgaW4gaTQwZV9wcm9iZSgpIHdlDQo+ID4gPiA+IHdpbGwgY2FsbCBpNDBl
X3Jlc2V0X2ludGVycnVwdF9jYXBhYmlsaXR5IHR3aWNlIGJ1dCB0aGlzIGlzIG5vdCBhDQo+ID4g
PiA+IHByb2JsZW0uDQo+ID4gPiA+IFRoaXMgaXMgYmVjYXVzZSBwY2lfZGlzYWJsZV9tc2kvcGNp
X2Rpc2FibGVfbXNpeCB3aWxsIGJlIGNhbGxlZA0KPiA+ID4gPiBvbmx5IGlmIGFwcHJvcHJpYXRl
IGZsYWdzIGFyZSBzZXQgb24gUEYgYW5kIGlmIHRoaXMgZnVuY3Rpb24gaXMNCj4gPiA+ID4gY2Fs
bGVkIG9uZXMgaXQgd2lsbCBjbGVhciB0aG9zZSBmbGFncy4gU28gZXZlbiBpZiB3ZSBjYWxsDQo+
ID4gPiA+IGk0MGVfcmVzZXRfaW50ZXJydXB0X2NhcGFiaWxpdHkgdHdpY2Ugd2Ugd2lsbCBub3Qg
ZGlzYWJsZSBtc2kNCj4gPiA+ID4gdmVjdG9ycyB0d2ljZS4NCj4gPiA+ID4NCj4gPiA+ID4gVGhl
IGlzc3VlIGhlcmUgaXMgZGlmZmVyZW50IGhvd2V2ZXIuIEl0IGlzIGZhaWxpbmcgaW4gZnJlZV9p
cnENCj4gPiA+ID4gYmVjYXVzZSB3ZSBhcmUgdHJ5aW5nIHRvIGZyZWUgYWxyZWFkeSBmcmVlIHZl
Y3Rvci4gVGhpcyBpcyBiZWNhdXNlDQo+ID4gPiA+IHNldHVwIG9mIG1pc2MgaXJxIHZlY3RvcnMg
aW4gaTQwZV9wcm9iZSBpcyBkb25lIGFmdGVyDQo+ID4gPiA+IGk0MGVfc2V0dXBfcGZfc3dpdGNo
LiBJZiBpNDBlX3NldHVwX3BmX3N3aXRjaCBmYWlscyB0aGVuIHdlIHdpbGwNCj4gPiA+ID4ganVt
cCB0byBlcnJfdnNpcyBhbmQgY2FsbCBpNDBlX2NsZWFyX2ludGVycnVwdF9zY2hlbWUgd2hpY2gg
d2lsbA0KPiA+ID4gPiB0cnkgdG8gZnJlZSB0aG9zZSBtaXNjIGlycSB2ZWN0b3JzIHdoaWNoIHdl
cmUgbm90IHlldCBhbGxvY2F0ZWQuDQo+ID4gPiA+IFdlIHNob3VsZCBoYXZlIHRoZSBwcm9wZXIg
Zml4IGZvciB0aGlzIHJlYWR5IHNvb24uDQo+ID4gPg0KPiA+ID4gWWVzLCBJJ20gYXdhcmUgb2Yg
d2hhdCdzIGhhcHBlbmluZyBoZXJlIGFuZCB3aHkgaXQncyBmYWlsaW5nLg0KPiA+ID4gU2FkbHks
IEkgYW0NCj4gPiA+IHByZXR0eSBzdXJlIEkgd3JvdGUgdGhpcyBjb2RlIGJhY2sgaW4gbGlrZSAy
MDExIG9yIDIwMTIsIGFuZCBiZWluZw0KPiA+ID4gYW4gZXJyb3IgcGF0aCwgaXQgaGFzbid0IHJl
YWxseSBiZWVuIHRlc3RlZC4NCj4gPiA+DQo+ID4gPiBJIGRvbid0IHJlYWxseSBjYXJlIGhvdyB0
aGlzIGdldHMgZml4ZWQgdG8gYmUgaG9uZXN0LiBXZSBoaXQgdGhpcyBpbg0KPiA+ID4gcHJvZHVj
dGlvbiB3aGVuIG91ciBMT00sIGZvciB3aGF0ZXZlciByZWFzb24sIGZhaWxlZCB0byBpbml0aWFs
aXplDQo+ID4gPiB0aGUgaW50ZXJuYWwgc3dpdGNoIG9uIGhvc3QgYm9vdC4gV2UgZXNjYWxhdGVk
IHRvIG91ciBkaXN0cm8gdmVuZG9yLA0KPiA+ID4gdGhleSBkaWQgZXNjYWxhdGUgdG8gSW50ZWws
IGFuZCBpdCB3YXNuJ3QgcmVhbGx5IHByaW9yaXRpemVkLiBTbyBJDQo+ID4gPiBzZW50IGEgcGF0
Y2ggdGhhdCBkb2VzIGZpeCB0aGUgaXNzdWUuDQo+ID4gPg0KPiA+ID4gSWYgdGhlIHRlYW0gd2Fu
dHMgdG8gcmVzcGluIHRoaXMgc29tZWhvdywgZ28gYWhlYWQuIEJ1dCB0aGlzIGRvZXMNCj4gPiA+
IGZpeCB0aGUgaW1tZWRpYXRlIGlzc3VlIHRoYXQgd2hlbiBiYWlsaW5nIG91dCBpbiBwcm9iZSgp
IGR1ZSB0byB0aGUNCj4gPiA+IG1haW4gVlNJIG5vdCBiZWluZyBvbmxpbmUgZm9yIHdoYXRldmVy
IHJlYXNvbiwgdGhlIGRyaXZlciBibGluZGx5DQo+ID4gPiBhdHRlbXB0cyB0byBjbGVhbiB1cCB0
aGUgbWlzYyBNU0ktWCB2ZWN0b3IgdHdpY2UuIFRoaXMgY2hhbmdlIGZpeGVzDQo+ID4gPiB0aGF0
IGJlaGF2aW9yLiBJJ2QgbGlrZSB0aGlzIHRvIG5vdCBsYW5ndWlzaCB3YWl0aW5nIGZvciBhIGRp
ZmZlcmVudA0KPiA+ID4gZml4LCBzaW5jZSBJJ2QgbGlrZSB0byBwb2ludCBvdXIgZGlzdHJvIHZl
bmRvciB0byB0aGlzIChvciBhbm90aGVyKQ0KPiA+ID4gcGF0Y2ggdG8gY2hlcnJ5LXBpY2ssIHNv
IHdlIGNhbiBnZXQgdGhpcyBpbnRvIHByb2R1Y3Rpb24uDQo+ID4gPiBPdGhlcndpc2Ugb3VyIHBs
YXRmb3JtIHJvbGxvdXQgaGl0dGluZyB0aGlzIHByb2JsZW0gaXMgZ29pbmcgdG8gYmUNCj4gPiA+
IHF1aXRlIGJ1bXB5LCB3aGljaCBpcyB2ZXJ5IG11Y2ggbm90IGlkZWFsLg0KPiA+DQo+ID4gSXQn
cyBiZWVuIDIgd2Vla3Mgc2luY2UgSSByZXBsaWVkLiAgQW55IHVwZGF0ZSBvbiB0aGlzPyAgTWFj
aWVqIGhhZA0KPiA+IGFscmVhZHkgcmV2aWV3ZWQgdGhlIHBhdGNoLCBzbyBob3Bpbmcgd2UgY2Fu
IGp1c3QgbW92ZSBhbG9uZyB3aXRoIGl0LA0KPiA+IG9yIGdldCBzb21ldGhpbmcgZWxzZSBvdXQg
c29vbj8NCj4gPg0KPiA+IEknZCByZWFsbHkgbGlrZSB0aGlzIHRvIG5vdCBqdXN0IGZhbGwgaW50
byBhIHZvaWQgd2FpdGluZyBmb3IgYQ0KPiA+IGRpZmZlcmVudCBwYXRjaCB3aGVuIHRoaXMgZml4
ZXMgdGhlIGlzc3VlLg0KPiANCj4gSGkgUEosDQo+IA0KPiBJIGhhdmVuJ3Qgc2VlbiBhIHJlY2Vu
dCB1cGRhdGUgb24gdGhpcy4gSSdtIGFza2luZyBmb3IgYW4gdXBkYXRlLg0KPiBPdGhlcndpc2Us
IEFsZXggYW5kIFN5bHdlc3RlciBhcmUgb24gdGhpcyB0aHJlYWQ7IHBlcmhhcHMgdGhleSBoYXZl
IHNvbWUNCj4gaW5mby4NCj4gDQo+IFRoYW5rcywNCj4gVG9ueQ0KPiANCg0KSGVsbG8sDQoNClRo
ZSBkcml2ZXIgZG9lcyBub3QgYmxpbmRseSB0cnkgdG8gZnJlZSBNU0ktWCB2ZWN0b3IgdHdpY2Ug
aGVyZS4gVGhpcyBpcyBndWFyZGVkIGJ5IEk0MEVfRkxBR19NU0lYX0VOQUJMRUQgYW5kIEk0MEVf
RkxBR19NU0lfRU5BQkxFRCBmbGFncy4gT25seSBpZiB0aG9zZSBmbGFncyBhcmUgc2V0IHdlIHdp
bGwgdHJ5IHRvIGZyZWUgTVNJL01TSS1YIHZlY3RvcnMgaW4gaTQwZV9yZXNldF9pbnRlcnJ1cHRf
Y2FwYWJpbGl0eSgpLiBBZGRpdGlvbmFsbHkgaTQwZV9yZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0
eSgpIGNsZWFycyB0aG9zZSBmbGFncyBldmVyeSB0aW1lIGl0IGlzIGNhbGxlZCBzbyBldmVuIGlm
IHdlIGNhbGwgaXQgdHdpY2UgaW4gYSByb3cgdGhlIGRyaXZlciB3aWxsIG5vdCBmcmVlIHRoZSB2
ZWN0b3JzIHR3aWNlLiBJIHJlYWxseSBjYW4ndCBzZWUgaG93IHRoaXMgcGF0Y2ggaXMgZml4aW5n
IGFueXRoaW5nIGFzIHRoZSBpc3N1ZSBoZXJlIGlzIG5vdCB3aXRoIE1TSSB2ZWN0b3JzIGJ1dCB3
aXRoIG1pc2MgSVJRIHZlY3RvcnMuIFdlIGhhdmUgYSBwcm9wZXIgcGF0Y2ggZm9yIHRoaXMgcmVh
ZHkgaW4gT09UIGFuZCB3ZSB3aWxsIHVwc3RyZWFtIGl0IHNvb24uIFRoZSBwcm9ibGVtIGhlcmUg
aXMgdGhhdCBpbiBpNDBlX2NsZWFyX2ludGVycnVwdF9zY2hlbWUoKSBkcml2ZXIgY2FsbHMgaTQw
ZV9mcmVlX21pc2NfdmVjdG9yKCkgYnV0IGluIGNhc2UgVlNJIHNldHVwIGZhaWxzIG1pc2MgdmVj
dG9yIGlzIG5vdCBhbGxvY2F0ZWQgeWV0IGFuZCB3ZSBnZXQgYSBjYWxsIHRyYWNlIGluIGZyZWVf
aXJxIHRoYXQgd2UgYXJlIHRyeWluZyB0byBmcmVlIElSUSB0aGF0IGhhcyBub3QgYmVlbiBhbGxv
Y2F0ZWQgeWV0Lg0KDQpSZWdhcmRzDQpTeWx3ZXN0ZXIgRHppZWR6aXVjaCANCg0KPiA+IC1QSg0K
PiA+DQo+ID4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCj4gPg0KPiA+IE5vdGU6
IFRoaXMgZW1haWwgaXMgZm9yIHRoZSBjb25maWRlbnRpYWwgdXNlIG9mIHRoZSBuYW1lZA0KPiA+
IGFkZHJlc3NlZShzKSBvbmx5IGFuZCBtYXkgY29udGFpbiBwcm9wcmlldGFyeSwgY29uZmlkZW50
aWFsLCBvcg0KPiA+IHByaXZpbGVnZWQgaW5mb3JtYXRpb24gYW5kL29yIHBlcnNvbmFsIGRhdGEu
IElmIHlvdSBhcmUgbm90IHRoZQ0KPiA+IGludGVuZGVkIHJlY2lwaWVudCwgeW91IGFyZSBoZXJl
Ynkgbm90aWZpZWQgdGhhdCBhbnkgcmV2aWV3LA0KPiA+IGRpc3NlbWluYXRpb24sIG9yIGNvcHlp
bmcgb2YgdGhpcyBlbWFpbCBpcyBzdHJpY3RseSBwcm9oaWJpdGVkLCBhbmQNCj4gPiByZXF1ZXN0
ZWQgdG8gbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkgYW5kIGRlc3Ryb3kgdGhpcyBlbWFp
bCBhbmQNCj4gPiBhbnkgYXR0YWNobWVudHMuIEVtYWlsIHRyYW5zbWlzc2lvbiBjYW5ub3QgYmUg
Z3VhcmFudGVlZCB0byBiZSBzZWN1cmUNCj4gPiBvciBlcnJvci1mcmVlLiBUaGUgQ29tcGFueSwg
dGhlcmVmb3JlLCBkb2VzIG5vdCBtYWtlIGFueSBndWFyYW50ZWVzIGFzDQo+ID4gdG8gdGhlIGNv
bXBsZXRlbmVzcyBvciBhY2N1cmFjeSBvZiB0aGlzIGVtYWlsIG9yIGFueSBhdHRhY2htZW50cy4N
Cj4gPiBUaGlzIGVtYWlsIGlzIGZvciBpbmZvcm1hdGlvbmFsIHB1cnBvc2VzIG9ubHkgYW5kIGRv
ZXMgbm90IGNvbnN0aXR1dGUNCj4gPiBhIHJlY29tbWVuZGF0aW9uLCBvZmZlciwgcmVxdWVzdCwg
b3Igc29saWNpdGF0aW9uIG9mIGFueSBraW5kIHRvIGJ1eSwNCj4gPiBzZWxsLCBzdWJzY3JpYmUs
IHJlZGVlbSwgb3IgcGVyZm9ybSBhbnkgdHlwZSBvZiB0cmFuc2FjdGlvbiBvZiBhDQo+ID4gZmlu
YW5jaWFsIHByb2R1Y3QuIFBlcnNvbmFsIGRhdGEsIGFzIGRlZmluZWQgYnkgYXBwbGljYWJsZSBk
YXRhDQo+ID4gcHJvdGVjdGlvbiBhbmQgcHJpdmFjeSBsYXdzLCBjb250YWluZWQgaW4gdGhpcyBl
bWFpbCBtYXkgYmUgcHJvY2Vzc2VkDQo+ID4gYnkgdGhlIENvbXBhbnksIGFuZCBhbnkgb2YgaXRz
IGFmZmlsaWF0ZWQgb3IgcmVsYXRlZCBjb21wYW5pZXMsIGZvcg0KPiA+IGxlZ2FsLCBjb21wbGlh
bmNlLCBhbmQvb3IgYnVzaW5lc3MtcmVsYXRlZCBwdXJwb3Nlcy4gWW91IG1heSBoYXZlDQo+ID4g
cmlnaHRzIHJlZ2FyZGluZyB5b3VyIHBlcnNvbmFsIGRhdGE7IGZvciBpbmZvcm1hdGlvbiBvbiBl
eGVyY2lzaW5nDQo+ID4gdGhlc2UgcmlnaHRzIG9yIHRoZSBDb21wYW554oCZcyB0cmVhdG1lbnQg
b2YgcGVyc29uYWwgZGF0YSwgcGxlYXNlIGVtYWlsDQo+ID4gZGF0YXJlcXVlc3RzQGp1bXB0cmFk
aW5nLmNvbS4NCg==
