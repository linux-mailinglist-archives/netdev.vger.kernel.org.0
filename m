Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F65F3723ED
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 02:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhEDApT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 20:45:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:52303 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhEDApS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 20:45:18 -0400
IronPort-SDR: 6k3QdDPQX9LEJQd2R64k7n5P6MJxL09vUnjiGncnTpsedpxHGa/l9RoWRhUQObdKcoS1IGGVhY
 dUyrM2e7gY+Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9973"; a="197960764"
X-IronPort-AV: E=Sophos;i="5.82,271,1613462400"; 
   d="scan'208";a="197960764"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 17:44:23 -0700
IronPort-SDR: E86MsvZchussIBx4X+jpqyKSD4GTrX8gfw0fznrIyc6OXl6k8myChHT3ytDFiyaMuRgawEf6pm
 9H3JjEFZrs0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,271,1613462400"; 
   d="scan'208";a="538984671"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2021 17:44:23 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 3 May 2021 17:44:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 3 May 2021 17:44:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 3 May 2021 17:44:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRDC6K+6SEV/l+gAVDYcuK5NRE7fXYCupRg61vPuw5YYIS49CIXXFb4F0kNZquBc1M2/FyuKIpzugP1bOQau60FOuZlwBE3e0cFmpmOTgtbH28BUHsZFuylsB0ByqVeY9es625AY9l9/3Tat4S09CC/8qIiHStTOKno7SecREtH8RsfjpH6kJLXc8qpidaH3Je4+0u6dFooJXdo6R0eWwb02P2L1EtXWtDLZ66O7cbZN/t6D6NbEDCHbEdyksQpVlgyym0hb1RhrqWlBkSUQ5BxCu9PaenrCZAu3Mtaw0AaggM+rdGqRlxk2b/0j726brX5q58Q9MJblCaVOuI/ywg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dy2hj31n9eSl2TxDEjRPbZyCuANpXCwbKg28nch0bSk=;
 b=DOqHa3HbrlISJy3myXLKW3OE36qK5cVpHz134uWuIpRKWAL6MSPX8tBhmGu98aIRk+Yujr3P9q85sWJwJpSAVbVfwt2c2cXbCD47Rq3NCO1wW8c2ZKbGDMvWFGckj4bjeQRt1vcaiy35m0khxBZjbk71FpVawhGLLuvOwX+qskZQKZJfCTAi+gongaXjzcG0aCF9F/J5gtlaxRInVZM7dZpqrd0hkt4FNiDV3oXK9dj5wqQa7dUEoOuTtKWGx1n96jOpERmclNSb7/rlXNRbmBUyGi3IBpbg3Gd2+SpIQ2z9J1FSpe5EQlHKHEQoKbSRhcgeIR02Epn6QSwuHiQdaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dy2hj31n9eSl2TxDEjRPbZyCuANpXCwbKg28nch0bSk=;
 b=Tru8ViHJiPLgrMut9m9iNiDsY0BCAIHY98KbTcl2pYr/RTvc/jpLnbp3sb73HzlGyhJj6w4QRi8LJzfUTkZwPoKY9WphKxvpZSAcnLobdDS4fWfQ0FzRd3G0l4SHsB3wTgy+Z/6scDTjzKMP16Fr7G7vh1leGD55SDdwHl09Gu0=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4720.namprd11.prod.outlook.com (2603:10b6:806:72::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.38; Tue, 4 May
 2021 00:44:19 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 00:44:19 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "liwei.song@windriver.com" <liwei.song@windriver.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ice: set the value of global config lock timeout longer
Thread-Topic: [PATCH] ice: set the value of global config lock timeout longer
Thread-Index: AQHXNP7PFMlVALdkmU2CbzZRHsc87Kq+BJEAgAA9yoCAApragIARteCA
Date:   Tue, 4 May 2021 00:44:19 +0000
Message-ID: <fa7cd362645763d382719f8ab0e72f429156444b.camel@intel.com>
References: <20210419093106.6487-1-liwei.song@windriver.com>
         <7d85412de58342e4469efdfdc6196925ce770993.camel@intel.com>
         <fca32ba9-ad20-0994-de7c-b3bf8425a07b@windriver.com>
         <8d6eb1116cac38c764fce754a9fa272ac4509bbb.camel@intel.com>
In-Reply-To: <8d6eb1116cac38c764fce754a9fa272ac4509bbb.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fba62573-162a-4864-69d9-08d90e95c0c4
x-ms-traffictypediagnostic: SA0PR11MB4720:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB47207BD8789E210EA8CB2CE6C65A9@SA0PR11MB4720.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5yPYc7fEPd7osvUrIFecTDhEgLqupWdoxC2vDM9P0Dw5s63Y8u/CxfbFqVIgTqihTDlFj5PCK0r3s5V8evDaRnOCLIzYS0ICTODoZaafFQVBFxfEAQTaAWRcsfEDx1b6wgOUlOCUt+W7dXx3wSWCjnEMvu2X4x7RZqzCaKbG3LBia4Sza9peKtnBsUKd/Iv3gEq2qa1O59b27L51T3adr52tcv9cIbTbmERUn/3dvsaU1u0kUYZ73JPq6S1QCivEAYPUAHr97cK+zcNoHkRG+QF0g2ub8d952X3m1AiENSqCQryD69iIZoBL1RYJqxAFVA7dBjlHlrStSF7a3AVRgbt9Xbdede3PNoq/lRdHTaxKlD348upfiiu6b3DwNY2gUL6gWsiJavN6bGGQJ9mLDMAZxy8p4iPVno7iF8XzbCAW9+KSuUa40hMxf42p/TUyqiql07V5CmGkC1nM6+lUjfpQmApej5X0K8pWGAn9F08zmr10xtqXesWWbnMIFcPvTvxvWGqoKoWqMHoZ/31FCKthFXLp+nMjFfi37n7H1XZyEgB0p9mSWzCPsAM65BTat9au9/FavmViiSEl3mG5VKnhZJBiXSnz+qCut1SrVGBbkHKZ3mODScar+Ay7ZWrkrtUYHKoEK94I7pHy29YDeWVfeAXJICqSSb3vKX1WGr8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(346002)(376002)(396003)(64756008)(186003)(6636002)(2616005)(86362001)(66446008)(6506007)(66476007)(4326008)(53546011)(26005)(66946007)(76116006)(66556008)(2906002)(71200400001)(122000001)(478600001)(83380400001)(54906003)(5660300002)(36756003)(316002)(8936002)(8676002)(6486002)(38100700002)(110136005)(6512007)(91956017)(99106002)(148743002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NWppUUJ2R2xYQjdpS09QVnZTRzVaczczRDBEQlh3bzI4L013Ym5FTmFqMHZ3?=
 =?utf-8?B?WTlKTU4yVTFtUDl6a3FRVFdVQ0dWZjlWQzl4aFFKanJyYi9wRWFKSFNWYVVk?=
 =?utf-8?B?ZnU5a1BJZVRZSlMwZnc1d0FoU2QyZUk1aStUc2FMcGlvOHQvWmdjK09UZm9S?=
 =?utf-8?B?L1F5SW5PZlBtS1BXdDdjWFJndTVReUd2aFVTZ005bVM3VXFCaC9ZUWlxSGJP?=
 =?utf-8?B?OHZzTUZkZ1hiK1BoRHZIQ0VUVnRoZmpTZElEZ0V6SWRITGRwRnR4VjBEWGI3?=
 =?utf-8?B?MG03UVVwQ3NDVnJ3NlE0dEFKd0FTN21RL0F4d3dpL3gwb1BZYzJzaHpuTU1V?=
 =?utf-8?B?cytOWjhqNWxaSWdGWnVBdjhMUDkydnV5UnpRb1loOGZCbmNoTWZyK05HMXdH?=
 =?utf-8?B?TTNwVkNScXl4UVNMVTYvN0tSVUdlWWdoSVhWOFRBaDFieTNMLzN2NHhXNTRC?=
 =?utf-8?B?YWZ6dis4YXhEV2JLM3ZoRzR3UlRkSEkrS0JCbVlsWFpBUXoyZ3FzaWlKVFYy?=
 =?utf-8?B?cUdZUS94MDFRd3ZRYjlOUnUreC9JRXdLSlBBVkVqK1JQZEpONHQvcUJVYkxG?=
 =?utf-8?B?TjA4WENmczhUOUV5THJnc2FKTzExQkdzVkNFUGZycWJKRGVaWkc1VFlUcXNB?=
 =?utf-8?B?ZlZKbHdIVnpSNkJUN0U3K3BUSklnSVdBTU1xbm85dnAzOSs2MW16VHpxZ3Y1?=
 =?utf-8?B?TXlOTFlHdlJvS0dxZEl4dXQ0Ty9CM0xPNFgxVHp3bFZMME5DKy8yc1B5eFIz?=
 =?utf-8?B?WUZQVnllNTNmNThlZVEyZm03TncxbW1JNUhKbk5VSGRNd0dQRG56ejNHaFc5?=
 =?utf-8?B?VkxITlBGTW9NOWVwZFlJUXk3MkpxYlVsb0pVazFjTzNDMjZaNUlUTlFFQm5Z?=
 =?utf-8?B?STVYdWhISG9ZOXQxN2kweTFSbWlRYThUYlpTQkxnNFpWNWlFSzlQb3JVTncy?=
 =?utf-8?B?NzBYd3YrT0xXUHkrYW4vQm1mMmcwaGFRazNjZU83MmlyTmhXVDJJWmloV1FP?=
 =?utf-8?B?Zkg3cC8wUHZVMVQzSDJRZGhvTHhoN3Z5UmZBNUozOUpiOTdVZVZZajdvQk5o?=
 =?utf-8?B?VXhXQVRkTWtpbTlza3RuYlJDWVR1ZmRIQzgwNjJmbkR6K0ptOWEwS0JzUXNT?=
 =?utf-8?B?Wkp3Y0JrV0w2eitBWU9HZ1pwYWhHZGJGUDcwbHlkaEZKZUhQNHljajRTcDJI?=
 =?utf-8?B?OFdYWlQzL1p3TFJJSUxITUJGdUxBT3EyNG9EeG5YeTcrb1dNek5WeE5kdkk4?=
 =?utf-8?B?MXpTbEFtZHphMUJNWXFNMSs0SW15TEtwQmVtY1ZWNmFYaUFJNGNYTGtONCtT?=
 =?utf-8?B?YUM1WUl4c3ZtOE01bnpOdDFxQ2RRcDNMZHNPR2ZBQkdzbVBXYklKbWt2TzMv?=
 =?utf-8?B?OFpUWjNmTDV6QWI2N3VIQzJwbXpkV0xpMmc0WDBlQkUwemVxZmgzdnlONUp1?=
 =?utf-8?B?SVNnaE56dTVWVFJTa1ZJNVcwMnBmcnlFNXVpbW1rSXEvVldwZjgwVzhsb2tt?=
 =?utf-8?B?WkhxQXBLSEtqV2M2VHBLMHVxd3YvUmxnWUxyOURGVGJra0JTZi81NGUrQjRC?=
 =?utf-8?B?ZTRoYlNCc1d0eWhqb3J3a1piZ1dIVEFDQ24rbk5Ka1ZPbm5Pc3RJanp6c1JJ?=
 =?utf-8?B?UWJtb040dmRSRDgxcml3Zm1HZkN6TW5ER2xFWm1wMlR5dHdnUURKd2tUMUUw?=
 =?utf-8?B?SzRTaVBzUFY0ckZFQ2lNYURSUVAweXA5TkpZNlRhR0VKU0pkQjhnWWsya2pO?=
 =?utf-8?Q?iC3/dEBhVH1fkLfX5EqxIRi30+QZMwqWnKgqu9+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACD98A0E4378E14ABB0D673C8B8E3C81@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fba62573-162a-4864-69d9-08d90e95c0c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2021 00:44:19.5889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z4tSyzUH8VFGWgPz66gJq5NafkLNqUm2YvxxBFa2HOsymtO6GihHy+QXCERm9t9TdmQXMTGY8IXzJv4oSyTgKJMLE0x3vNOMvQq/4J+M+qY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4720
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA0LTIyIGF0IDExOjE2IC0wNzAwLCBUb255IE5ndXllbiB3cm90ZToNCj4g
T24gV2VkLCAyMDIxLTA0LTIxIGF0IDEwOjI5ICswODAwLCBMaXdlaSBTb25nIHdyb3RlOg0KPiA+
IA0KPiA+IE9uIDQvMjEvMjEgMDY6NDgsIE5ndXllbiwgQW50aG9ueSBMIHdyb3RlOg0KPiA+ID4g
T24gTW9uLCAyMDIxLTA0LTE5IGF0IDE3OjMxICswODAwLCBMaXdlaSBTb25nIHdyb3RlOg0KPiA+
ID4gPiBJdCBtYXkgbmVlZCBob2xkIEdsb2JhbCBDb25maWcgTG9jayBhIGxvbmdlciB0aW1lIHdo
ZW4gZG93bmxvYWQNCj4gPiA+ID4gRERQDQo+ID4gPiA+IHBhY2thZ2UgZmlsZSwgZXh0ZW5kIHRo
ZSB0aW1lb3V0IHZhbHVlIHRvIDUwMDBtcyB0byBlbnN1cmUgdGhhdA0KPiA+ID4gPiBkb3dubG9h
ZCBjYW4gYmUgZmluaXNoZWQgYmVmb3JlIG90aGVyIEFRIGNvbW1hbmQgZ290IHRpbWUgdG8NCj4g
PiA+ID4gcnVuLA0KPiA+ID4gPiB0aGlzIHdpbGwgZml4IHRoZSBpc3N1ZSBiZWxvdyB3aGVuIHBy
b2JlIHRoZSBkZXZpY2UsIDUwMDBtcyBpcw0KPiA+ID4gPiBhDQo+ID4gPiA+IHRlc3QNCj4gPiA+
ID4gdmFsdWUgdGhhdCB3b3JrIHdpdGggYm90aCBCYWNrcGxhbmUgYW5kIEJyZWFrb3V0Q2FibGUg
TlZNDQo+ID4gPiA+IGltYWdlOg0KPiA+ID4gPiANCj4gPiA+ID4gaWNlIDAwMDA6ZjQ6MDAuMDog
VlNJIDEyIGZhaWxlZCBsYW4gcXVldWUgY29uZmlnLCBlcnJvcg0KPiA+ID4gPiBJQ0VfRVJSX0NG
Rw0KPiA+ID4gPiBpY2UgMDAwMDpmNDowMC4wOiBGYWlsZWQgdG8gZGVsZXRlIFZTSSAxMiBpbiBG
VyAtIGVycm9yOg0KPiA+ID4gPiBJQ0VfRVJSX0FRX1RJTUVPVVQNCj4gPiA+ID4gaWNlIDAwMDA6
ZjQ6MDAuMDogcHJvYmUgZmFpbGVkIGR1ZSB0byBzZXR1cCBQRiBzd2l0Y2g6IC0xMg0KPiA+ID4g
PiBpY2U6IHByb2JlIG9mIDAwMDA6ZjQ6MDAuMCBmYWlsZWQgd2l0aCBlcnJvciAtMTINCj4gPiA+
IA0KPiA+ID4gSGkgTGl3ZWksDQo+ID4gPiANCj4gPiA+IFdlIGhhdmVuJ3QgZW5jb3VudGVyZWQg
dGhpcyBpc3N1ZSBiZWZvcmUuIENhbiB5b3UgcHJvdmlkZSBzb21lDQo+ID4gPiBtb3JlDQo+ID4g
PiBpbmZvIG9uIHlvdXIgc2V0dXAgb3IgaG93IHlvdSdyZSBjb21pbmcgYWNyb3NzIHRoaXMgaXNz
dWU/DQo+ID4gPiANCj4gPiA+IFBlcmhhcHMsIGxzcGNpIG91dHB1dCBhbmQgc29tZSBtb3JlIG9m
IHRoZSBkbWVzZyBsb2c/IFdlJ2QgbGlrZQ0KPiA+ID4gdG8NCj4gPiA+IHRyeQ0KPiA+ID4gdG8g
cmVwcm9kdWNlIHRoaXMgc28gd2UgY2FuIGludmVzaXRnYXRlIGl0IGZ1cnRoZXIuDQo+ID4gDQo+
ID4gSGkgVG9ueSwNCj4gPiANCj4gPiBNeSBib2FyZCBpcyBJZGF2aWxsZSBJQ0UtRCBwbGF0Zm9y
bSwgaXQgY2FuIGJlIHJlcHJvZHVjZWQgd2hlbg0KPiA+IHRoZXJlIGlzIG5vIFFTRlAgVHJhbnNj
ZWl2ZXIgTW9kdWxlIHNldHVwIG9uIGl0LCBpdCBpcyBub3QNCj4gPiBoYXBwZW5lZCBvbiBlYWNo
ICJtb2Rwcm9iZSBpY2UiLCBhYm91dCAxLzggcmF0ZSB0byBnb3QgdGhhdA0KPiA+IGVycm9yIG1l
c3NhZ2Ugd2hlbiBJIGxvb3AgcnVuICJtb2Rwcm9iZSAtciBpY2UgJiYgbW9kcHJvYmUgaWNlIi4N
Cj4gPiB0aGUgcG9ydCB0eXBlIGlzIEJhY2twbGFuZSwgYW5kIEkgaGF2ZW4ndCByZXByb2R1Y2UN
Cj4gPiBpdCB3aXRoIEJyZWFrb3V0IG1vZGUuIA0KPiANCj4gSGkgTGl3ZWksIA0KPiANCj4gVGhh
bmtzIGZvciB0aGUgYWRkaXRpb25hbCBpbmZvcm1hdGlvbi4gSSd2ZSBwcm92aWRlZCB0aGlzIHRv
IG91cg0KPiB2YWxpZGF0aW9uIHRlYW0gYW5kIGFza2VkIHRoZXkgdHJ5IHRvIHJlcHJvZHVjZSBz
byB3ZSBjYW4gbG9vayBpbnRvDQo+IGl0IGZ1cnRoZXIuDQoNCkhpIExpd2VpLA0KDQpXZSB3ZXJl
IGFibGUgdG8gcmVwcm9kdWNlIHRoZSBpc3N1ZS4gV2UgZm91bmQgdGhhdCB0aGlzIGRvZXNuJ3Qg
b2NjdXINCm9uIG5ld2VyIE5WTXMsIGhvd2V2ZXIsIGl0IHdpbGwgc3RpbGwgYmUgYXdoaWxlIHVu
dGlsIHRob3NlIG5ld2VyIG9uZXMNCmFyZSBhdmFpbGFibGUuDQoNCkluIHRoZSBpbnRlcmltLCBJ
J20gZ29pbmcgdG8gaGF2ZSB0aGlzIHBhdGNoIHRlc3RlZCB0byBlbnN1cmUgaXQNCmRvZXNuJ3Qg
Y2F1c2UgYW55IGlzc3Vlcy4gSWYgc28sIHdlJ2xsIHVzZSB0aGlzIHZhbHVlIHVudGlsIHRoZSBu
ZXcNCk5WTXMgYmVjb21lIGF2YWlsYWJsZS4NCg0KVGhhbmtzLA0KVG9ueQ0K
