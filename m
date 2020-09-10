Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD8B265200
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgIJVGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:06:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:24523 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgIJVGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 17:06:30 -0400
IronPort-SDR: qyJLgoCSrF3GGSaOPlrZqMFNjAuXOrwr3nkfkdqLAtyfTpQOsOBYosF59Z9jD2ngyIig6iZjIX
 L+GqfYYB0Bsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="158674722"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="158674722"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 14:06:29 -0700
IronPort-SDR: VorSvB7lpqZRG6kEhqMD+OUhTP8BZiJBsm42dWNFAFcypo5KgLxQu2G0fYt02iei722e5ytCxd
 sdoEdlGn2Lfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="407881881"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 10 Sep 2020 14:06:29 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 10 Sep 2020 14:06:28 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 10 Sep 2020 14:06:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX151.amr.corp.intel.com (10.22.226.38) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 10 Sep 2020 14:06:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 10 Sep 2020 14:06:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVK3PAAJ8HG81erz0piqMJFsn+HpKXKp+9zkvZjd6e2y0+gcz8CTE1naM41NKJk9UpVabZy3/4gXABEmKQxUBHAoyRw3ydxYXiXsrsr7h+jzNVIgeZdlAhrh7Ept8QCtjc0uma++hMg39oo8Be5L6ZquGBfQ/oxwf2BLJLnnm0s0CYGAC622HFa/b9x5XDuLUPwP4fHLViYBo9PfliZGYIf/nfxFg95kvCwLX5MKODapA1lEw1tCC4iR1FAc1Vyb2cHJhB9AB8+asEhPcbNML9Lx0vADPFtcLxpUpyO3J2zjEWPREbMtVT3nZ7QPMKg4t5IzIzJBTeIu3i4KMws3IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3+nIpKIDeIIXxcZHf76hG3qCkpGmEe10YLAiugifKI=;
 b=gPjUHiKlBY52I2ll6Cg3Z8klesqFSyPoX46GtFKhF4ZZ4Ib64E0rxsRkvepZIfiEIJxene2KkUCVKe3n1g4KkHgGqCSoL0Bh4UnSYKvA+Ue4Oep73ozSjaFaIqD0exv34OoG44uoy5cRow5v91vw/rmA3mEYe8eHm6bXVmE09UfrvcCdQH4xCWWcIIeJKI01fenT3DRFZXWkLlIHX8qqm/rEa/QqnRZszutPiIctDOG8dtcaRIAEX2LE5k0hLUkqZ1Xrm7u9U0UqiDnBd4YlpIUM67AMPSd3L5jjbcwhPko9Ld1498Glhpj64L+4I3SDNLELa5nywpnJy4jAug3VXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3+nIpKIDeIIXxcZHf76hG3qCkpGmEe10YLAiugifKI=;
 b=qxjiSyyxloMVxUcKlQLmdJiLIsbs3dAENcoVoVtTbf6AzCD+POh7YHyAhEMQEnx0gnt7ApGJxUFPBWuC4o/nC4JiylrTH4Ki9vzgrt5aWL0/80hK+Pdr9GzonuEP22WH7AfVSuQmvWbGAiLIzgVB6IDA9ofQeC4tCP01RXpTp6g=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB0061.namprd11.prod.outlook.com (2603:10b6:301:65::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.25; Thu, 10 Sep
 2020 21:06:05 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3370.016; Thu, 10 Sep 2020
 21:06:05 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v5 01/15] virtchnl: Extend AVF ops
Thread-Topic: [net-next v5 01/15] virtchnl: Extend AVF ops
Thread-Index: AQHWejy3Eg1ZclplnkqJSXD3Pmlr5KlHqO+AgASNt7CAFjJp4A==
Date:   Thu, 10 Sep 2020 21:06:05 +0000
Message-ID: <MW3PR11MB4522BCE8D08A318E2EF2DF5E8F270@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-2-anthony.l.nguyen@intel.com>
 <20200824124231.61c1a04f@kicinski-fedora-PC1C0HJN>
 <MW3PR11MB4522EDF96406226D06C05CFF8F550@MW3PR11MB4522.namprd11.prod.outlook.com>
In-Reply-To: <MW3PR11MB4522EDF96406226D06C05CFF8F550@MW3PR11MB4522.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37cd8f2f-d595-47c4-c6d6-08d855cd551d
x-ms-traffictypediagnostic: MWHPR11MB0061:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB00612979FEEA00449D76BAF18F270@MWHPR11MB0061.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d4w711FV1GT+YR8kt8V86K8hv3VpAZIx4U9KmHnlHU8tVnAawxwbQ696Wgz/Y7UNfJM5lByiLcMpj1Zbl5vOrCvnoYFk+s+exFGyD2jWKqjrbHBTcYwjHZ/b7i4g8DxYqQQrNtnOMPz/NjZ4C+rY384LThC2vBz/pnSV2i5lbR1rbNP7UnCTIMG/obS6S272l1j1QwodI5bq54HM/Un68idtyTar2YxfxfY9vDOSW+32BNki/ovQmoaJH48L7L0hF3a0+0+wfXYFnDTgUTGJ+23IyzZ9olKrEWU4kyGed2AdoYa06X4TLLnlvxu8eYy5+qEksM2v8R8wbMfPmRBUdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(66476007)(2906002)(5660300002)(66556008)(64756008)(66446008)(71200400001)(66946007)(76116006)(52536014)(6636002)(478600001)(54906003)(8936002)(8676002)(53546011)(110136005)(26005)(9686003)(86362001)(33656002)(186003)(6506007)(107886003)(55016002)(316002)(4326008)(83380400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mNYBksJpsHlEgx2wQZHcZm1N15lRyrKdzS7O7xtG+KXwLorqUIEi6gMPqsGm9OkJbmca6trxF6/OSuYyCLT8GZYvFi/W9/O74atmqZMDxsBvFF3UnltiTBiP3f+lyX1T98Ol1qupTFf9BDFzgHAsBblBSgoSUfJo+ZaXJ1GcH+jjF6gJJvrG0eAsFZqSZJ6fOZEQI3cnjUBWqiVEPUVUcQA3FHGfqneED1hGavXSp50FhJizhlWCi/R5R3XjkHIAKGiYDZYY6oUInnjy4S5W9WIVCpX3L8DUwtzWiJiD4MBVywaV3GZWgvIBX8B4+ASCaqnf6HfOKIXuclM2GsKsPXFD3QABsiYZNbOyG962ZA8GFj4yOrlH/JmEN00h+pRFBKDQVbrvowK0xjuG7vA6tgZaeBmF+JmC3/y6hzxR4nEbm1qzOIYvB2sCcrB242jA4XH1eENL7aVPqXsGUNM1DxkAvUnXqNEZtxgM35E/gwxu8QM1kKKUBQKNp+vfJArX4GEGDt0LNiYaZ6Izfx3NaNca7UqGvtJf+NKJ2oP6O/RaryT8Y2gXeme7kcvq3GqAsVEOZE+Vcs4hX7PN3YbiyRUmIw+j0t2POpXvqVDdtuX82kzfvyYVN3Ih0d4vz8+MGtjTulJsnIeecXQHmakIsA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37cd8f2f-d595-47c4-c6d6-08d855cd551d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2020 21:06:05.4261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OCcxrBusarb7RU7wuq8a5GQf1DWhURF9ReB4/hPW5fpQkkp9QzjjrdTOMOtfulLVyuaYryzOcqh3YWDOGvchCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0061
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCcmFkeSwgQWxhbg0KPiBTZW50
OiBUaHVyc2RheSwgQXVndXN0IDI3LCAyMDIwIDEwOjE2IEFNDQo+IFRvOiBKYWt1YiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPjsgTmd1eWVuLCBBbnRob255IEwNCj4gPGFudGhvbnkubC5uZ3V5
ZW5AaW50ZWwuY29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgTWljaGFlbCwgQWxpY2Ug
PEFsaWNlLk1pY2hhZWxAaW50ZWwuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbmhv
cm1hbkByZWRoYXQuY29tOyBzYXNzbWFubkByZWRoYXQuY29tOw0KPiBLaXJzaGVyLCBKZWZmcmV5
IFQgPGplZmZyZXkudC5raXJzaGVyQGludGVsLmNvbT47IEJ1cnJhLCBQaGFuaSBSDQo+IDxwaGFu
aS5yLmJ1cnJhQGludGVsLmNvbT47IEhheSwgSm9zaHVhIEEgPGpvc2h1YS5hLmhheUBpbnRlbC5j
b20+OyBDaGl0dGltLA0KPiBNYWRodSA8bWFkaHUuY2hpdHRpbUBpbnRlbC5jb20+OyBMaW5nYSwg
UGF2YW4gS3VtYXINCj4gPFBhdmFuLkt1bWFyLkxpbmdhQGludGVsLmNvbT47IFNraWRtb3JlLCBE
b25hbGQgQw0KPiA8ZG9uYWxkLmMuc2tpZG1vcmVAaW50ZWwuY29tPjsgQnJhbmRlYnVyZywgSmVz
c2UNCj4gPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgU2FtdWRyYWxhLCBTcmlkaGFyDQo+
IDxzcmlkaGFyLnNhbXVkcmFsYUBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJFOiBbbmV0LW5leHQg
djUgMDEvMTVdIHZpcnRjaG5sOiBFeHRlbmQgQVZGIG9wcw0KPiANCj4gPiAtLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KPiA+IEZyb206IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+
DQo+ID4gU2VudDogTW9uZGF5LCBBdWd1c3QgMjQsIDIwMjAgMTI6NDMgUE0NCj4gPiBUbzogTmd1
eWVuLCBBbnRob255IEwgPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPg0KPiA+IENjOiBkYXZl
bUBkYXZlbWxvZnQubmV0OyBNaWNoYWVsLCBBbGljZSA8YWxpY2UubWljaGFlbEBpbnRlbC5jb20+
Ow0KPiA+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IG5ob3JtYW5AcmVkaGF0LmNvbTsgc2Fzc21h
bm5AcmVkaGF0LmNvbTsNCj4gPiBLaXJzaGVyLCBKZWZmcmV5IFQgPGplZmZyZXkudC5raXJzaGVy
QGludGVsLmNvbT47IEJyYWR5LCBBbGFuDQo+ID4gPGFsYW4uYnJhZHlAaW50ZWwuY29tPjsgQnVy
cmEsIFBoYW5pIFIgPHBoYW5pLnIuYnVycmFAaW50ZWwuY29tPjsgSGF5LA0KPiA+IEpvc2h1YSBB
IDxqb3NodWEuYS5oYXlAaW50ZWwuY29tPjsgQ2hpdHRpbSwgTWFkaHUNCj4gPiA8bWFkaHUuY2hp
dHRpbUBpbnRlbC5jb20+OyBMaW5nYSwgUGF2YW4gS3VtYXINCj4gPiA8cGF2YW4ua3VtYXIubGlu
Z2FAaW50ZWwuY29tPjsgU2tpZG1vcmUsIERvbmFsZCBDDQo+ID4gPGRvbmFsZC5jLnNraWRtb3Jl
QGludGVsLmNvbT47IEJyYW5kZWJ1cmcsIEplc3NlDQo+ID4gPGplc3NlLmJyYW5kZWJ1cmdAaW50
ZWwuY29tPjsgU2FtdWRyYWxhLCBTcmlkaGFyDQo+ID4gPHNyaWRoYXIuc2FtdWRyYWxhQGludGVs
LmNvbT4NCj4gPiBTdWJqZWN0OiBSZTogW25ldC1uZXh0IHY1IDAxLzE1XSB2aXJ0Y2hubDogRXh0
ZW5kIEFWRiBvcHMNCj4gPg0KPiA+IE9uIE1vbiwgMjQgQXVnIDIwMjAgMTA6MzI6NTIgLTA3MDAg
VG9ueSBOZ3V5ZW4gd3JvdGU6DQo+ID4gPiArc3RydWN0IHZpcnRjaG5sX3Jzc19oYXNoIHsNCj4g
PiA+ICsJdTY0IGhhc2g7DQo+ID4gPiArCXUxNiB2cG9ydF9pZDsNCj4gPiA+ICt9Ow0KPiA+ID4g
Kw0KPiA+ID4gK1ZJUlRDSE5MX0NIRUNLX1NUUlVDVF9MRU4oMTYsIHZpcnRjaG5sX3Jzc19oYXNo
KTsNCj4gPg0KPiA+IEkndmUgYWRkZWQgMzJiaXQgYnVpbGRzIHRvIG15IGxvY2FsIHNldHVwIHNp
bmNlIHY0IHdhcyBwb3N0ZWQgLSBsb29rcw0KPiA+IGxpa2UgdGhlcmUncyBhIG51bWJlciBvZiBl
cnJvcnMgaGVyZS4gWW91IGNhbid0IGFzc3VtZSB1NjQgZm9yY2VzIGENCj4gPiA2NGJpdCBhbGln
bm1lbnQuIEJlc3QgdG8gc3BlY2lmeSB0aGUgcGFkZGluZyBleHBsaWNpdGx5Lg0KPiA+DQo+ID4g
RldJVyB0aGVzZSBhcmUgdGhlIGVycm9ycyBJIGdvdCBidXQgdGhlcmUgbWF5IGJlIG1vcmU6DQo+
ID4NCj4gDQo+IEl0IHNlZW1zIGxpa2UgdGhlc2UgYXJlIHRyaWdnZXJpbmcgb24gb2xkIG1lc3Nh
Z2VzIHRvbywgY3VyaW91cyB3aHkgdGhpcyB3YXNuJ3QNCj4gY2F1Z2h0IHNvb25lci4gIFdpbGwg
Zml4LCB0aGFua3MuDQo+IA0KPiAtQWxhbg0KDQpJIG1hbmFnZWQgdG8gZ2V0IGEgMzItYml0IGJ1
aWxkIGVudmlyb25tZW50IHNldHVwIGFuZCBmb3VuZCB0aGF0IHdlIGRvIGluZGVlZCBoYXZlIGFs
aWdubWVudCBpc3N1ZXMgdGhlcmUgb24gMzIgYml0IHN5c3RlbXMgZm9yIHNvbWUgb2YgdGhlIG5l
dyBvcHMgd2UgYWRkZWQgd2l0aCB0aGUgc2VyaWVzLiAgSG93ZXZlciwgSSB0aGluayBJJ20gc3Rp
bGwgbWlzc2luZyBzb21ldGhpbmcgYXMgaXQgbG9va3MgbGlrZSB5b3UgaGF2ZSBlcnJvcnMgdHJp
Z2dlcmluZyBvbiBtdWNoIG1vcmUgdGhhbiBJIGZvdW5kIGFuZCBJJ20gc3VzcGVjdGluZyB0aGVy
ZSBtaWdodCBiZSBhIGNvbXBpbGUgb3B0aW9uIEknbSBtaXNzaW5nIG9yIHBlcmhhcHMgbXkgR0ND
IHZlcnNpb24gaXMgb2xkZXIgdGhhbiB5b3Vycy4gIEUuZy4sIEkgZm91bmQgaXNzdWVzIGluIHZp
cnRjaG5sX3R4cV9pbmZvX3YyLCB2aXJ0Y2hubF9yeHFfaW5mb192MiwgdmlydGNobmxfY29uZmln
X3J4X3F1ZXVlcywgYW5kIHZpcnRjaG5sX3Jzc19oYXNoLiAgSXQgYXBwZWFycyB5b3UgaGF2ZSBj
b21waWxlIGlzc3VlcyBpbiB2aXJ0Y2hubF9nZXRfY2FwYWJpbGl0aWVzIChhbW9uZyBvdGhlcnMp
IGhvd2V2ZXIgd2hpY2ggZGlkIG5vdCB0cmlnZ2VyIG9uIG1pbmUuICBNYW51YWwgaW5zcGVjdGlv
biBpbmRpY2F0ZXMgdGhhdCBpdCBfc2hvdWxkXyBiZSB0cmlnZ2VyaW5nIGEgZmFpbHVyZSBhbmQg
dGhhdCB5b3VyIHNldHVwIGlzIG1vcmUgY29ycmVjdCB0aGFuIG1pbmUuICBJJ20gZ3Vlc3Npbmcg
c29tZSBleHRyYSBwYWRkaW5nIGlzIGdldHRpbmcgaW5jbHVkZWQgaW4gc29tZSBwbGFjZXMgYW5k
IGNhdXNpbmcgYSBmYWxzZSBwb3NpdGl2ZSBvbiB0aGUgb3RoZXIgYWxpZ25tZW50IGlzc3Vlcy4g
IEFyZSB0aGVyZSBhbnkgaGludHMgeW91IGNhbiBwcm92aWRlIG1lIHRoYXQgbWlnaHQgaGVscCBt
ZSBtb3JlIGFjY3VyYXRlbHkgcmVwcm9kdWNlIHRoaXM/DQoNCi1BbGFuDQo=
