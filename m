Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEFA290377
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 12:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395477AbgJPKqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 06:46:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:30281 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395473AbgJPKqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 06:46:19 -0400
IronPort-SDR: WfXlmQT3JGZa0+yc5SmRUYj7tWce6BIqVYz0/s+5TrHwL9g75G8vDzHaNzuViCQf+bCOxrYcXI
 OdRc3psqxtog==
X-IronPort-AV: E=McAfee;i="6000,8403,9775"; a="154379183"
X-IronPort-AV: E=Sophos;i="5.77,382,1596524400"; 
   d="scan'208";a="154379183"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 03:46:17 -0700
IronPort-SDR: 4Fnpmfmm103a/qElXorvtgXphRGX49FKwDO/WywwAFzvHpkV5tvujBrB6CCp5rDO7Zox7Z4s7G
 gDpXRCTmBNIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,382,1596524400"; 
   d="scan'208";a="314858731"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 16 Oct 2020 03:46:17 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 16 Oct 2020 03:46:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 16 Oct 2020 03:46:15 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.50) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 16 Oct 2020 03:46:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxcYDk0w92V2Xa5s/GsP5BYBvypAFgTU80HFa10g0aFSMaWXVuvY1nFp2IrEssWJFZHAi5YXADjUN8tUfc025mjuxO+PtCL1wSwkZHeKXdz6H2SrsZuGOWQ/Bhhaz0BhUYcvJIVrWTKjiItdmbQWPiYEuBT3zH2PIzVraK5l7I4c/NN4HTb8O1BU4VBzSAz37OS3ePWrCKSXCN3tlXIhjyR2T7GivyDYgke5QoYnpA/qUy5YZFZks8lATUSaDiVFEASl5hbEcRqURVamgJvZsASxlHUh5DOBhCPdHAyosp9ExZqCcv8MgkSzhe9k9MjLIgmCXGHOCCVmt4MujppTRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpFeWK7PzleQKmfdJJQh/JkKxAIzsPvBrm8XCDF8Myc=;
 b=AW8KSV0nVGUuGzh/6fW9BKc1UEymhdBZjZhx9zYZyEKJSmuiI1mumTu1YYL9v1lg4MwtCM2BGhs3oiZJ1LxmFPjjDB5HCxn4VabLEpWvIQ5Eyvx3ZfQaziDa7zaw6xr8z4GaicDFPofOOUTZauTkIcqHPCIQTGLNrKqvQuwngIgsbq/nViAOsvb3KjQ4gbud/zf0NmCdxafzgKqR6Uk0fTLgK3oa176ObSD1Ii2RaIs52WNnwvsf6zV3Vc75/poyuCbnEIZ9cfWlL33kXxC1SB2Hy4Z617V9dtetid+54WHtF9lC6cfAWHvI/MrtX/LOrtH7Maq9YS3QhrDLsrA7vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpFeWK7PzleQKmfdJJQh/JkKxAIzsPvBrm8XCDF8Myc=;
 b=oApXAkg0bZ7u4LcC3vtQ1Emf8vCKy+JnT0x9u+UH01wEewgV2QoFq82SNKsyFhUOLxaGOw0lrayomcYp0R2FmfNaPR0805Sm95BO5Ifjy9SYtvoui1PiaKHHApdEZiiIFyjuxMJKhtL1kDVuKBG7DY2HY/7mm4AmZQXdv/HG9Io=
Received: from DM6PR11MB2876.namprd11.prod.outlook.com (2603:10b6:5:c1::16) by
 DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.21; Fri, 16 Oct 2020 10:46:05 +0000
Received: from DM6PR11MB2876.namprd11.prod.outlook.com
 ([fe80::c85a:d98e:fbf3:9f8c]) by DM6PR11MB2876.namprd11.prod.outlook.com
 ([fe80::c85a:d98e:fbf3:9f8c%5]) with mapi id 15.20.3477.025; Fri, 16 Oct 2020
 10:46:05 +0000
From:   "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: RE: [net-next 2/3] i40e: Fix MAC address setting for a VF via Host/VM
Thread-Topic: [net-next 2/3] i40e: Fix MAC address setting for a VF via
 Host/VM
Thread-Index: AQHWnP8n633I34ZiUE2PnyoZmL43hamPjkmAgAqGIpA=
Date:   Fri, 16 Oct 2020 10:46:05 +0000
Message-ID: <DM6PR11MB28768492F2D085ADA9ECBFFAE5030@DM6PR11MB2876.namprd11.prod.outlook.com>
References: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
 <20201007231050.1438704-3-anthony.l.nguyen@intel.com>
 <CA+FuTSfX55yiPHZ-Pf051RqMkKbyvHWT86HFB135Tb4kjm6PjQ@mail.gmail.com>
In-Reply-To: <CA+FuTSfX55yiPHZ-Pf051RqMkKbyvHWT86HFB135Tb4kjm6PjQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [80.238.108.122]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d387b850-fd58-4ad3-04a1-08d871c0aef5
x-ms-traffictypediagnostic: DM6PR11MB3371:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3371BBEAAC6D3D2D0B8783B4E5030@DM6PR11MB3371.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RghTBed4tbGCMIrc1y4yZnwqUr5gVGiGGbKJns1/e4ng2Cr0Goo0KCMgrLY1SMVteQeEprq75BHG4ZFve6/jDVSVbndH+/DDlQ6DvCMQaXEZvV5D0vxP4mdV+B7KIBbv9vgavXcsqKdh0cwnlfhlJ9bWbHKOOkHnJqiss3HkWFbsWtmvzkVRbDF8Qj9h7M5RFDNdgPjJcYRwp7RCOGM8KI5Qgbkb8ap8yDd0JUYAhfnCYpnctB7i3xsK+wtM+apWcW2f7YFZw5QMMiQ+OCSKY9D5AwuK7dVUHkHd+/9hz7eMNYpT4sIdNF6EsFBbCPBk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2876.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(9686003)(54906003)(186003)(110136005)(55016002)(53546011)(316002)(6506007)(26005)(478600001)(4326008)(6636002)(71200400001)(83380400001)(107886003)(76116006)(86362001)(8936002)(8676002)(7696005)(33656002)(66556008)(66946007)(52536014)(66446008)(66476007)(64756008)(2906002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: gPYtHXT/Cy/KLjUy2su5f3xBCQDdmmc1L7k+5u1sgBFhHhhKhAvjogD3CBG4j/wv3catF4WJ+zlAVV2i3PQM+RHZjwYDOTt+qt3BaLrwss8lIZaSRj0nX0qmb7/7xUPGiFw7EsILftR9ou8EGUB12GaWr1NvKiuxkOVVRVFktoZ9n43rJwiD/tcEuVhCLeRmFVs5tM3y4ouEVnCAFb6849bEce7URx5WJ2ne0oDBFe4DTPe6HhiNMntMstL8VU2r44XRjCEZ6U/LAKHm5a9hzOvbzvtXZTZCCpeH0JlFGzCGCmYuwD9JiujoDfQnJhlVmNvVarmCvu8KZO1QZsoTpGReV+zdo9qTZ//jhdEDoy3cpy/FlQWlLKJAgmQnTly4Zvej4tRaiK+OQsdpLMZRpkldf8+YM1Z1XxUteJmYyl+1aB54kiwuzX7p9PIr9UITg+xFcAZnqwLLWQaWHwCuxRpmlbL0UCqPY3PwXqIKVIhROoUXNkfC1Een5fBGZpyhKx5ieQqU+V6zcBBLAx9WEn+xY55afdcIupX4wQSuaN5icxp7IRytNt6oIzjWbzq4DKmUcbXvCxEBbt4jIg59X21Fe8gjdrK6xyfkw76oXLL3DzBEhOoy0LtDy9pUjYMZLGmJIL2Xgl1SnaZZJtU+xw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2876.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d387b850-fd58-4ad3-04a1-08d871c0aef5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 10:46:05.3898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CaRswjqW/1M1ajHBecp4P1dwdCKJHoHb/mJB1nBoeeqj6y0mAIDBmT9QLDrCb810+0Zehd/AucbzXgVwRyA9p2ZWtHFRLkQyniDCT3LAjSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R29vZCBkYXkgV2lsbGVtDQoNClRoZSBpc3N1ZSBwYXRjaCBmaXhlcyBoYXMgYmVlbiBpbnRyb2R1
Y2VkIGZyb20gdGhlIHZlcnkgYmVnaW5uaW5nLg0KU28gYXMgZml4ZXMgdGFnIEkgY2FuIHN1Z2dl
c3QgdGhlIHZlcnkgZmlyc3QgY29tbWl0IDVjM2M0OGFjNmJmNTYzNjdjNGU4OWY2NDUzY2QyZDYx
ZTUwMzc1YmQgICJpNDBlOiBpbXBsZW1lbnQgdmlydHVhbCBkZXZpY2UgaW50ZXJmYWNlIg0KDQoN
CldpdGggdGhlIGJlc3QgcmVnYXJkcw0KQWxleA0KTkQgSVRQIExpbnV4IDQwRyBiYXNlIGRyaXZl
ciBUTCANCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFdpbGxlbSBkZSBCcnVp
am4gPHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+IA0KU2VudDogRnJpZGF5LCBPY3Rv
YmVyIDksIDIwMjAgNzo0NyBQTQ0KVG86IE5ndXllbiwgQW50aG9ueSBMIDxhbnRob255Lmwubmd1
eWVuQGludGVsLmNvbT4NCkNjOiBEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBK
YWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgTG9rdGlvbm92LCBBbGVrc2FuZHIgPGFs
ZWtzYW5kci5sb2t0aW9ub3ZAaW50ZWwuY29tPjsgTmV0d29yayBEZXZlbG9wbWVudCA8bmV0ZGV2
QHZnZXIua2VybmVsLm9yZz47IG5ob3JtYW5AcmVkaGF0LmNvbTsgc2Fzc21hbm5AcmVkaGF0LmNv
bTsgS3ViYWxld3NraSwgQXJrYWRpdXN6IDxhcmthZGl1c3oua3ViYWxld3NraUBpbnRlbC5jb20+
OyBBbmRyZXcgQm93ZXJzIDxhbmRyZXd4LmJvd2Vyc0BpbnRlbC5jb20+DQpTdWJqZWN0OiBSZTog
W25ldC1uZXh0IDIvM10gaTQwZTogRml4IE1BQyBhZGRyZXNzIHNldHRpbmcgZm9yIGEgVkYgdmlh
IEhvc3QvVk0NCg0KT24gV2VkLCBPY3QgNywgMjAyMCBhdCA3OjExIFBNIFRvbnkgTmd1eWVuIDxh
bnRob255Lmwubmd1eWVuQGludGVsLmNvbT4gd3JvdGU6DQo+DQo+IEZyb206IEFsZWtzYW5kciBM
b2t0aW9ub3YgPGFsZWtzYW5kci5sb2t0aW9ub3ZAaW50ZWwuY29tPg0KPg0KPiBGaXggTUFDIHNl
dHRpbmcgZmxvdyBmb3IgdGhlIFBGIGRyaXZlci4NCj4NCj4gV2l0aG91dCB0aGlzIGNoYW5nZSB0
aGUgTUFDIGFkZHJlc3Mgc2V0dGluZyB3YXMgaW50ZXJwcmV0ZWQgDQo+IGluY29ycmVjdGx5IGlu
IHRoZSBmb2xsb3dpbmcgdXNlIGNhc2VzOg0KPiAxKSBQcmludCBpbmNvcnJlY3QgVkYgTUFDIG9y
IHplcm8gTUFDDQo+IGlwIGxpbmsgc2hvdyBkZXYgJHBmDQo+IDIpIERvbid0IHByZXNlcnZlIE1B
QyBiZXR3ZWVuIGRyaXZlciByZWxvYWQgcm1tb2QgaWF2ZjsgbW9kcHJvYmUgaWF2Zg0KPiAzKSBV
cGRhdGUgVkYgTUFDIHdoZW4gbWFjdmxhbiB3YXMgc2V0DQo+IGlwIGxpbmsgYWRkIGxpbmsgJHZm
IGFkZHJlc3MgJG1hYyAkdmYuMSB0eXBlIG1hY3ZsYW4NCj4gNCkgRmFpbGVkIHRvIHVwZGF0ZSBt
YWMgYWRkcmVzcyB3aGVuIFZGIHdhcyB0cnVzdGVkIGlwIGxpbmsgc2V0IGRldiANCj4gJHZmIGFk
ZHJlc3MgJG1hYw0KPg0KPiBUaGlzIGluY2x1ZGVzIGFsbCBvdGhlciBjb25maWd1cmF0aW9ucyBp
bmNsdWRpbmcgYWJvdmUgY29tbWFuZHMuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IEFsZWtzYW5kciBM
b2t0aW9ub3YgPGFsZWtzYW5kci5sb2t0aW9ub3ZAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBBcmthZGl1c3ogS3ViYWxld3NraSA8YXJrYWRpdXN6Lmt1YmFsZXdza2lAaW50ZWwuY29tPg0K
PiBUZXN0ZWQtYnk6IEFuZHJldyBCb3dlcnMgPGFuZHJld3guYm93ZXJzQGludGVsLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogVG9ueSBOZ3V5ZW4gPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPg0K
DQpJZiB0aGlzIGlzIGEgZml4LCBzaG91bGQgaXQgdGFyZ2V0IG5ldCBhbmQvb3IgaXMgdGhlcmUg
YSBjb21taXQgZm9yIGEgRml4ZXMgdGFnPw0KDQo+IEBAIC0yNzQwLDYgKzI3NDQsNyBAQCBzdGF0
aWMgaW50IGk0MGVfdmNfZGVsX21hY19hZGRyX21zZyhzdHJ1Y3QgDQo+IGk0MGVfdmYgKnZmLCB1
OCAqbXNnKSAgew0KPiAgICAgICAgIHN0cnVjdCB2aXJ0Y2hubF9ldGhlcl9hZGRyX2xpc3QgKmFs
ID0NCj4gICAgICAgICAgICAgKHN0cnVjdCB2aXJ0Y2hubF9ldGhlcl9hZGRyX2xpc3QgKiltc2c7
DQo+ICsgICAgICAgYm9vbCB3YXNfdW5pbWFjX2RlbGV0ZWQgPSBmYWxzZTsNCj4gICAgICAgICBz
dHJ1Y3QgaTQwZV9wZiAqcGYgPSB2Zi0+cGY7DQo+ICAgICAgICAgc3RydWN0IGk0MGVfdnNpICp2
c2kgPSBOVUxMOw0KPiAgICAgICAgIGk0MGVfc3RhdHVzIHJldCA9IDA7DQo+IEBAIC0yNzU5LDYg
KzI3NjQsOCBAQCBzdGF0aWMgaW50IGk0MGVfdmNfZGVsX21hY19hZGRyX21zZyhzdHJ1Y3QgaTQw
ZV92ZiAqdmYsIHU4ICptc2cpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IEk0MEVf
RVJSX0lOVkFMSURfTUFDX0FERFI7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZXJy
b3JfcGFyYW07DQo+ICAgICAgICAgICAgICAgICB9DQo+ICsgICAgICAgICAgICAgICBpZiAoZXRo
ZXJfYWRkcl9lcXVhbChhbC0+bGlzdFtpXS5hZGRyLCB2Zi0+ZGVmYXVsdF9sYW5fYWRkci5hZGRy
KSkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgd2FzX3VuaW1hY19kZWxldGVkID0gdHJ1ZTsN
Cj4gICAgICAgICB9DQo+ICAgICAgICAgdnNpID0gcGYtPnZzaVt2Zi0+bGFuX3ZzaV9pZHhdOw0K
Pg0KPiBAQCAtMjc3OSwxMCArMjc4NiwyNSBAQCBzdGF0aWMgaW50IGk0MGVfdmNfZGVsX21hY19h
ZGRyX21zZyhzdHJ1Y3QgaTQwZV92ZiAqdmYsIHU4ICptc2cpDQo+ICAgICAgICAgICAgICAgICBk
ZXZfZXJyKCZwZi0+cGRldi0+ZGV2LCAiVW5hYmxlIHRvIHByb2dyYW0gVkYgJWQgTUFDIGZpbHRl
cnMsIGVycm9yICVkXG4iLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICB2Zi0+dmZfaWQsIHJl
dCk7DQo+DQo+ICsgICAgICAgaWYgKHZmLT50cnVzdGVkICYmIHdhc191bmltYWNfZGVsZXRlZCkg
ew0KPiArICAgICAgICAgICAgICAgc3RydWN0IGk0MGVfbWFjX2ZpbHRlciAqZjsNCj4gKyAgICAg
ICAgICAgICAgIHN0cnVjdCBobGlzdF9ub2RlICpoOw0KPiArICAgICAgICAgICAgICAgdTggKm1h
Y2FkZHIgPSBOVUxMOw0KPiArICAgICAgICAgICAgICAgaW50IGJrdDsNCj4gKw0KPiArICAgICAg
ICAgICAgICAgLyogc2V0IGxhc3QgdW5pY2FzdCBtYWMgYWRkcmVzcyBhcyBkZWZhdWx0ICovDQo+
ICsgICAgICAgICAgICAgICBzcGluX2xvY2tfYmgoJnZzaS0+bWFjX2ZpbHRlcl9oYXNoX2xvY2sp
Ow0KPiArICAgICAgICAgICAgICAgaGFzaF9mb3JfZWFjaF9zYWZlKHZzaS0+bWFjX2ZpbHRlcl9o
YXNoLCBia3QsIGgsIGYsIGhsaXN0KSB7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGlmIChp
c192YWxpZF9ldGhlcl9hZGRyKGYtPm1hY2FkZHIpKQ0KPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIG1hY2FkZHIgPSBmLT5tYWNhZGRyOw0KDQpuaXQ6IGNvdWxkIGJyZWFrIGhlcmUN
Ci0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQpJbnRlbCBUZWNobm9sb2d5IFBvbGFuZCBzcC4geiBvLm8uCnVsLiBTb3dh
Y2tpZWdvIDE3MyB8IDgwLTI5OCBHZGFzayB8IFNkIFJlam9ub3d5IEdkYXNrIFBub2MgfCBWSUkg
V3lkemlhIEdvc3BvZGFyY3p5IEtyYWpvd2VnbyBSZWplc3RydSBTZG93ZWdvIC0gS1JTIDEwMTg4
MiB8IE5JUCA5NTctMDctNTItMzE2IHwgS2FwaXRhIHpha2Fkb3d5IDIwMC4wMDAgUExOLgpUYSB3
aWFkb21vIHdyYXogeiB6YWN6bmlrYW1pIGplc3QgcHJ6ZXpuYWN6b25hIGRsYSBva3JlbG9uZWdv
IGFkcmVzYXRhIGkgbW9lIHphd2llcmEgaW5mb3JtYWNqZSBwb3VmbmUuIFcgcmF6aWUgcHJ6eXBh
ZGtvd2VnbyBvdHJ6eW1hbmlhIHRlaiB3aWFkb21vY2ksIHByb3NpbXkgbyBwb3dpYWRvbWllbmll
IG5hZGF3Y3kgb3JheiB0cndhZSBqZWogdXN1bmljaWU7IGpha2lla29sd2llayBwcnplZ2xkYW5p
ZSBsdWIgcm96cG93c3plY2huaWFuaWUgamVzdCB6YWJyb25pb25lLgpUaGlzIGUtbWFpbCBhbmQg
YW55IGF0dGFjaG1lbnRzIG1heSBjb250YWluIGNvbmZpZGVudGlhbCBtYXRlcmlhbCBmb3IgdGhl
IHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNpcGllbnQocykuIElmIHlvdSBhcmUgbm90IHRo
ZSBpbnRlbmRlZCByZWNpcGllbnQsIHBsZWFzZSBjb250YWN0IHRoZSBzZW5kZXIgYW5kIGRlbGV0
ZSBhbGwgY29waWVzOyBhbnkgcmV2aWV3IG9yIGRpc3RyaWJ1dGlvbiBieSBvdGhlcnMgaXMgc3Ry
aWN0bHkgcHJvaGliaXRlZC4KIAo=

