Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF34726F4C0
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgIRDfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:35:18 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:16048 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgIRDfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 23:35:17 -0400
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f642af20000>; Fri, 18 Sep 2020 11:35:14 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 03:35:12 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 03:35:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJJ/Zw2ILt0bzg7n9UH3iGl5sGnAcSOWtrJ2Kxe2REQPbJwehns/6+ZmHMf+UAoRzr6QGrNuSzsJ5p12xq1KchIkjApwXXklRBx3BjerRm2vhQHAL+IMxwKrz3A9UOVVnrEw1pjHO4zfCJAchs+E8L3yO8bQXnCWIPeaeCKsPnOXuRfH1DzeHgevGvVkf7yiaQDZOzohPnC6e4t51iVjM0ydyhh40/qguYAhlzMbEi6HtyiceY8LK8/FHWnLEdSA/RwvcNd3DIsXp1h8ykaApyPE9Fn5e9nzdGFwrmEjQB5u+0N/60T7DggFWPL1FZclfiFJL/03GqeDF1da36Xj/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3qfsC10L452TrFUx0zuCGp7/rDdkTnHtTo+pcMJO+A=;
 b=DNupXOdXdPu52MNh76RiP3g0kfvT+JTx5IwWT3ve2TTJ+ChXGcQUmfcjl6k6tkXXzeuJhIwKseXmP6wcScct+tTDzdQpjhLEqsjfuigjd9ikeO9VhAljq3hunYpVYAOJjeX+8DFTC8HrQcON6jsaz5exVJIPKiut5TIXtcr2/UqigRHZCPkCXq9rtmTK8ebO7sCyUY4noMGh/Ol+FgqXSTlqYGMAd61DYVbUxR6x8KbntS8mO9/+bzyGDZjAz/DVDPVwvXTOJ6qWLRE6FcuAjtMjuOBZQE4I+cRTiNq2Y3A2pc4zpH5pMLXT033SdBdyOJfjiSFOnqMg01KaBhH9JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB4983.namprd12.prod.outlook.com (2603:10b6:a03:102::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Fri, 18 Sep
 2020 03:35:10 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 03:35:10 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 3/8] devlink: Prepare code to fill multiple
 port function attributes
Thread-Topic: [PATCH net-next v2 3/8] devlink: Prepare code to fill multiple
 port function attributes
Thread-Index: AQHWjRbe0yxrhyimLEag/sA5zdH96KltLvCAgACPt7A=
Date:   Fri, 18 Sep 2020 03:35:09 +0000
Message-ID: <BY5PR12MB4322D4FA0B0ED9E8537C72B3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-4-parav@nvidia.com>
 <0dc57740-48fb-d77f-dcdf-2607ef2dc545@intel.com>
In-Reply-To: <0dc57740-48fb-d77f-dcdf-2607ef2dc545@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 490e6045-586e-476a-8565-08d85b83d846
x-ms-traffictypediagnostic: BYAPR12MB4983:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB4983A004B167F03DE46A1E6EDC3F0@BYAPR12MB4983.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rEGKba5mO2TA0Le9YmpI3KPHxRNt4EJ2OppzgEKeja67y11RwxfEC5x/s1tS3BpjBlKww2bf0JFLgK+v3yHV3EjHIwaZD0JNWjCHHVIIkxMoLW0MUJL+M4qYQOWa1Lr990NkTDHj1Ei2e/xXkAn5o3rEea2kNJ+fFPT0EUmzyil8kgp2vwlDFOAvITsYcg4B/4oMu9DkvTDe6J8TaC8pLrX/kssIRXWezBLaJucJtIBTHPw9TbR8XHQLxlIRQ2KAMeT8pH3w7zlakuVaqgTxA/Z99ajrEVjUfhDHfHIU/VbaYdULr1oK/X0mTqaIFCoE0BIqgUeUtXfGi3/VVGXEoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(6506007)(53546011)(2906002)(66556008)(66476007)(64756008)(66946007)(8936002)(66446008)(8676002)(71200400001)(7696005)(33656002)(5660300002)(107886003)(52536014)(4326008)(55016002)(186003)(76116006)(478600001)(55236004)(83380400001)(316002)(26005)(9686003)(86362001)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KFmdZlTVVNe5FUB3YseIpmWyIapjWc1/wupCF6rVOazqYZqB9Yo/zQrn8uBp2wJWRTxhCQjZwfwHbJ4lzFNz3qYfHs8K5EXnjQjLfPPp6ZpG1GXndGV7CRbNnfruy4vouNQNKGtm3oDYtEb0iUaYAmTZMtqm/58aTpKF0nwa986nadiPv1/FAmPLRIvNqSrQv4DLuPfbfZcJRp8Fh2VxGZefYBOAZBJTy4IXoT3X2YN9R/qkE5QUFOF1oLNCEXy4evDFAAv0Xew/xjz9lwKoGbCNcaEb67ynX4Zqq3WfChnO85CEGlRBvLCg0gipno/exQsP+BeTCGFnYS0pqbS9bt96CLVDGCYH6Haitmmw64uQdJgcql0ptNsDN8EsHidWDveqkTyQSm0ye54AlE1DqLdB6NnP39cdEmv746Ah/i5yKQ0YqH5HxiGQXBs3fbwqdM3NTHKSplIdTK2MY5BH7CsbVVTEyljUP6OPe2xc1NReims+qSqAtOF/hP2Dk7UUI4wLHB5sOZyEAzGHRYzl6W5FD9gGXhl6GLdnraVc76nHjY16BR4XBBRRz1z4tlP7/51/aOvsxbyIhQIdgg0tVGbM1DPKZz9Pv45aa0eTuvNFjYeFAEINy9wS0jkFXZBOnp4JiPWBi2g+I3m5n12Vgw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 490e6045-586e-476a-8565-08d85b83d846
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 03:35:09.8516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HK7jCqFqLIUJ5yGZJBCpiLYzMIQT3T6DxSMQIc1D4JWFrEwp3KFHv3iTD9WamDmGmk2wDUiN8mIhGUmVdb/MBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4983
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600400114; bh=P3qfsC10L452TrFUx0zuCGp7/rDdkTnHtTo+pcMJO+A=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=cMRbc2dNhIPP7i3/I/NLGXwS4TnzWCMokFsuDakCWakQrQ4JE4tyFgLZvNFhF7rBn
         C+lnUjKXXTQoINVnPv5ZTD4leTQFUYlghPSKZ+VTorPkiPxr7oCTWEi+HQXtctA22+
         ZOqD8C+/zjllleSKZ3QB7UMjwtz7dtdBmKEQOlTec0P7x8R83DBMxneQVUnpFRpNGV
         vQsneHzoslzcfNlparVxQhmjQ+EBhOdwnvfkicAsGsD6Ke0XdO3Dblpl9zcNzzAXc4
         gfbgzzObaXmjHuD3cPRYlNMV8pjsc70QQnQ1oSMsyjXW+VFrU2U5lfdr2xubjWkvGT
         xmKwK+JOA6d7Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFjb2IsDQoNCj4gRnJvbTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5j
b20+DQo+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDE4LCAyMDIwIDEyOjI5IEFNDQo+IA0KPiAN
Cj4gT24gOS8xNy8yMDIwIDEwOjIwIEFNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gUHJlcGFy
ZSBjb2RlIHRvIGZpbGwgemVybyBvciBtb3JlIHBvcnQgZnVuY3Rpb24gb3B0aW9uYWwgYXR0cmli
dXRlcy4NCj4gPiBTdWJzZXF1ZW50IHBhdGNoIG1ha2VzIHVzZSBvZiB0aGlzIHRvIGZpbGwgbW9y
ZSBwb3J0IGZ1bmN0aW9uDQo+ID4gYXR0cmlidXRlcy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogSmlyaSBQ
aXJrbyA8amlyaUBudmlkaWEuY29tPg0KPiA+IC0tLQ0KPiA+ICBuZXQvY29yZS9kZXZsaW5rLmMg
fCA1Mw0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0N
Cj4gPiAgMSBmaWxlIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKyksIDI0IGRlbGV0aW9ucygtKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL2RldmxpbmsuYyBiL25ldC9jb3JlL2Rldmxp
bmsuYyBpbmRleA0KPiA+IGU5MzczMDA2NWM1Ny4uZDE1MjQ4OWU0OGRhIDEwMDY0NA0KPiA+IC0t
LSBhL25ldC9jb3JlL2RldmxpbmsuYw0KPiA+ICsrKyBiL25ldC9jb3JlL2RldmxpbmsuYw0KPiA+
IEBAIC01NzAsNiArNTcwLDMxIEBAIHN0YXRpYyBpbnQgZGV2bGlua19ubF9wb3J0X2F0dHJzX3B1
dChzdHJ1Y3Qgc2tfYnVmZg0KPiAqbXNnLA0KPiA+ICAJcmV0dXJuIDA7DQo+ID4gIH0NCj4gPg0K
PiA+ICtzdGF0aWMgaW50DQo+ID4gK2RldmxpbmtfcG9ydF9mdW5jdGlvbl9od19hZGRyX2ZpbGwo
c3RydWN0IGRldmxpbmsgKmRldmxpbmssIGNvbnN0IHN0cnVjdA0KPiBkZXZsaW5rX29wcyAqb3Bz
LA0KPiA+ICsJCQkJICAgc3RydWN0IGRldmxpbmtfcG9ydCAqcG9ydCwgc3RydWN0IHNrX2J1ZmYN
Cj4gKm1zZywNCj4gPiArCQkJCSAgIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjaywgYm9v
bA0KPiAqbXNnX3VwZGF0ZWQpIHsNCj4gPiArCXU4IGh3X2FkZHJbTUFYX0FERFJfTEVOXTsNCj4g
PiArCWludCBod19hZGRyX2xlbjsNCj4gPiArCWludCBlcnI7DQo+ID4gKw0KPiA+ICsJaWYgKCFv
cHMtPnBvcnRfZnVuY3Rpb25faHdfYWRkcl9nZXQpDQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0K
PiA+ICsJZXJyID0gb3BzLT5wb3J0X2Z1bmN0aW9uX2h3X2FkZHJfZ2V0KGRldmxpbmssIHBvcnQs
IGh3X2FkZHIsDQo+ICZod19hZGRyX2xlbiwgZXh0YWNrKTsNCj4gPiArCWlmIChlcnIpIHsNCj4g
PiArCQlpZiAoZXJyID09IC1FT1BOT1RTVVBQKQ0KPiA+ICsJCQlyZXR1cm4gMDsNCj4gPiArCQly
ZXR1cm4gZXJyOw0KPiA+ICsJfQ0KPiA+ICsJZXJyID0gbmxhX3B1dChtc2csIERFVkxJTktfUE9S
VF9GVU5DVElPTl9BVFRSX0hXX0FERFIsDQo+IGh3X2FkZHJfbGVuLCBod19hZGRyKTsNCj4gPiAr
CWlmIChlcnIpDQo+ID4gKwkJcmV0dXJuIGVycjsNCj4gPiArCSptc2dfdXBkYXRlZCA9IHRydWU7
DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgc3RhdGljIGludA0KPiA+ICBk
ZXZsaW5rX25sX3BvcnRfZnVuY3Rpb25fYXR0cnNfcHV0KHN0cnVjdCBza19idWZmICptc2csIHN0
cnVjdCBkZXZsaW5rX3BvcnQNCj4gKnBvcnQsDQo+ID4gIAkJCQkgICBzdHJ1Y3QgbmV0bGlua19l
eHRfYWNrICpleHRhY2spIEBAIC01NzcsMzYNCj4gKzYwMiwxNiBAQA0KPiA+IGRldmxpbmtfbmxf
cG9ydF9mdW5jdGlvbl9hdHRyc19wdXQoc3RydWN0IHNrX2J1ZmYgKm1zZywgc3RydWN0IGRldmxp
bmtfcG9ydA0KPiAqcG9yDQo+ID4gIAlzdHJ1Y3QgZGV2bGluayAqZGV2bGluayA9IHBvcnQtPmRl
dmxpbms7DQo+ID4gIAljb25zdCBzdHJ1Y3QgZGV2bGlua19vcHMgKm9wczsNCj4gPiAgCXN0cnVj
dCBubGF0dHIgKmZ1bmN0aW9uX2F0dHI7DQo+ID4gLQlib29sIGVtcHR5X25lc3QgPSB0cnVlOw0K
PiA+IC0JaW50IGVyciA9IDA7DQo+ID4gKwlib29sIG1zZ191cGRhdGVkID0gZmFsc2U7DQo+ID4g
KwlpbnQgZXJyOw0KPiA+DQo+ID4gIAlmdW5jdGlvbl9hdHRyID0gbmxhX25lc3Rfc3RhcnRfbm9m
bGFnKG1zZywNCj4gREVWTElOS19BVFRSX1BPUlRfRlVOQ1RJT04pOw0KPiA+ICAJaWYgKCFmdW5j
dGlvbl9hdHRyKQ0KPiA+ICAJCXJldHVybiAtRU1TR1NJWkU7DQo+ID4NCj4gPiAgCW9wcyA9IGRl
dmxpbmstPm9wczsNCj4gPiAtCWlmIChvcHMtPnBvcnRfZnVuY3Rpb25faHdfYWRkcl9nZXQpIHsN
Cj4gPiAtCQlpbnQgaHdfYWRkcl9sZW47DQo+ID4gLQkJdTggaHdfYWRkcltNQVhfQUREUl9MRU5d
Ow0KPiA+IC0NCj4gPiAtCQllcnIgPSBvcHMtPnBvcnRfZnVuY3Rpb25faHdfYWRkcl9nZXQoZGV2
bGluaywgcG9ydCwgaHdfYWRkciwNCj4gJmh3X2FkZHJfbGVuLCBleHRhY2spOw0KPiA+IC0JCWlm
IChlcnIgPT0gLUVPUE5PVFNVUFApIHsNCj4gPiAtCQkJLyogUG9ydCBmdW5jdGlvbiBhdHRyaWJ1
dGVzIGFyZSBvcHRpb25hbCBmb3IgYSBwb3J0LiBJZg0KPiBwb3J0IGRvZXNuJ3QNCj4gPiAtCQkJ
ICogc3VwcG9ydCBmdW5jdGlvbiBhdHRyaWJ1dGUsIHJldHVybmluZyAtRU9QTk9UU1VQUCBpcw0K
PiBub3QgYW4gZXJyb3IuDQo+ID4gLQkJCSAqLw0KPiANCj4gV2UgbG9zdCB0aGlzIGNvbW1lbnQg
aW4gdGhlIG1vdmUgaXQgbG9va3MgbGlrZS4gSSB0aGluayBpdCdzIHN0aWxsIHVzZWZ1bCB0byBr
ZWVwIGZvcg0KPiBjbGFyaXR5IG9mIHdoeSB3ZSdyZSBjb252ZXJ0aW5nIC1FT1BOT1RTVVBQIGlu
IHRoZSByZXR1cm4uDQpZb3UgYXJlIHJpZ2h0LiBJdCBpcyBhIHVzZWZ1bCBjb21tZW50Lg0KSG93
ZXZlciwgaXQgaXMgYWxyZWFkeSBjb3ZlcmVkIGluIGluY2x1ZGUvbmV0L2RldmxpbmsuaCBpbiB0
aGUgc3RhbmRhcmQgY29tbWVudCBvZiB0aGUgY2FsbGJhY2sgZnVuY3Rpb24uDQpGb3IgbmV3IGRy
aXZlciBpbXBsZW1lbnRhdGlvbiwgbG9va2luZyB0aGVyZSB3aWxsIGJlIG1vcmUgdXNlZnVsLg0K
U28gSSBndWVzcyBpdHMgb2sgdG8gZHJvcCBmcm9tIGhlcmUuDQoNCj4gDQo+ID4gLQkJCWVyciA9
IDA7DQo+ID4gLQkJCWdvdG8gb3V0Ow0KPiA+IC0JCX0gZWxzZSBpZiAoZXJyKSB7DQo+ID4gLQkJ
CWdvdG8gb3V0Ow0KPiA+IC0JCX0NCj4gPiAtCQllcnIgPSBubGFfcHV0KG1zZywNCj4gREVWTElO
S19QT1JUX0ZVTkNUSU9OX0FUVFJfSFdfQUREUiwgaHdfYWRkcl9sZW4sIGh3X2FkZHIpOw0KPiA+
IC0JCWlmIChlcnIpDQo+ID4gLQkJCWdvdG8gb3V0Ow0KPiA+IC0JCWVtcHR5X25lc3QgPSBmYWxz
ZTsNCj4gPiAtCX0NCj4gPiAtDQo+ID4gLW91dDoNCj4gPiAtCWlmIChlcnIgfHwgZW1wdHlfbmVz
dCkNCj4gPiArCWVyciA9IGRldmxpbmtfcG9ydF9mdW5jdGlvbl9od19hZGRyX2ZpbGwoZGV2bGlu
aywgb3BzLCBwb3J0LCBtc2csDQo+IGV4dGFjaywgJm1zZ191cGRhdGVkKTsNCj4gPiArCWlmIChl
cnIgfHwgIW1zZ191cGRhdGVkKQ0KPiA+ICAJCW5sYV9uZXN0X2NhbmNlbChtc2csIGZ1bmN0aW9u
X2F0dHIpOw0KPiA+ICAJZWxzZQ0KPiA+ICAJCW5sYV9uZXN0X2VuZChtc2csIGZ1bmN0aW9uX2F0
dHIpOw0KPiA+DQo=
