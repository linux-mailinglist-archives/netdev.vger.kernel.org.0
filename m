Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3DCD9242
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 15:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393567AbfJPNTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 09:19:35 -0400
Received: from mail-eopbgr750047.outbound.protection.outlook.com ([40.107.75.47]:45058
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388141AbfJPNTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 09:19:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9CBXMv3lCiW3rycdFeVnrDxmAFW8OVZy9p0eyUzeTyiCv2pxjC9AODxaS4YijUdePHAQAqFgbNNJ67wmw+HhqesjHjq+VyivWacwpss3gNVov5xbL4Gsw5cnAf0EoajNod7LQNO5GS1KR2ed9xDA/SvUuQjWhi9Ja5URyzR1c6IHFQc/N3o+jKnWLHr9ifDFGuq2Xv3VvTlgy8d316D64B2wbWLtwTCK6z9Cf4fdgZnD4MsPtm0qFj6BqjCJNs943beWJbLJWLKNg+GjvoZv69ZjZ+sChnCDax7NV2MIgvSFpgbrl6myXwBTGNUxNSl3Fd33q0spAaoncuKVzGNYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKpqgBDq9/q8ZrBNIkXYWQAfgx+SzxZeltN61NZO9ro=;
 b=awflCi5nTUuJFfuhWaWOEEre8PFMC2k9wPwMfpEeWMp8dUtlQhoz7yHgJct7i58TfoDJGXN7RV1ctbualMI8iRVmTv8IwmRCUYgjlNm1KWXPF0JAnJBlGUrwKZyZPbkrp35IvnSBbhOc1joYdcNanGyp1oMGhnbmDV0JtvloHMdLmEhlxQ6Y1zAC27P/0Uh9qIizBpx22zOvRgRJjNLZ6HjQO2F5+nhWiBvmLrlsklTMQ3OD4EYV4b9AeiN4mhXVUXQmEmNm/BOQRP8he5VmX65HdOwzQx7exubmOu3cBz9y35SABL2Bq6PlQJkw+QILgI9JHiWplXab8BbSwxR7oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKpqgBDq9/q8ZrBNIkXYWQAfgx+SzxZeltN61NZO9ro=;
 b=llM+/XyHLa4BHjiTszXAAUGluAFTP4FMg+zXpu/PiJd6Hz9vOKq0DfvoRiYDhnWZZ78L4LXUy9FKE5Z/mZXl2WwSuPHw5GXzCx8SZQ8+JJ1RuIMG6yYCNQg+rVVzbYv2NTIW3iCfgGS9NafNWecpsBl4J1IvVFPc3Dz3Rh8JfLQ=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3665.namprd11.prod.outlook.com (20.178.222.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Wed, 16 Oct 2019 13:19:31 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 13:19:31 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 net 2/4] net: aquantia: when cleaning hw cache it
 should be toggled
Thread-Topic: [PATCH v2 net 2/4] net: aquantia: when cleaning hw cache it
 should be toggled
Thread-Index: AQHVgDof48Tbq5/7JkCldRfrcGfLJA==
Date:   Wed, 16 Oct 2019 13:19:30 +0000
Message-ID: <e39ae93c-60eb-7991-3b15-70a05aca3377@aquantia.com>
References: <cover.1570787323.git.igor.russkikh@aquantia.com>
 <d89180cd7ddf6981310179108b37a8d15c44c02f.1570787323.git.igor.russkikh@aquantia.com>
 <20191015113317.6413f912@cakuba.netronome.com>
In-Reply-To: <20191015113317.6413f912@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0028.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::16) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f501c08-88b8-400d-ace0-08d7523b7a7d
x-ms-traffictypediagnostic: BN8PR11MB3665:
x-microsoft-antispam-prvs: <BN8PR11MB3665151274A23FA554D1544598920@BN8PR11MB3665.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(376002)(346002)(396003)(136003)(189003)(199004)(386003)(36756003)(66066001)(2906002)(476003)(11346002)(229853002)(44832011)(186003)(5660300002)(102836004)(6916009)(26005)(31696002)(508600001)(446003)(486006)(54906003)(316002)(6506007)(2616005)(71190400001)(6512007)(86362001)(76176011)(6116002)(66556008)(256004)(3846002)(66476007)(31686004)(6246003)(6486002)(71200400001)(66446008)(64756008)(99286004)(6436002)(66946007)(14444005)(14454004)(8676002)(81166006)(25786009)(81156014)(7736002)(4326008)(8936002)(305945005)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3665;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n2SoyxNuLargWVPLN++6N/zDB7AuyxSmaS9rnFwWah4W5i2Jc2qj+8PVsK9LkDcqgyXkawlCfMkntvUjz92Mzo7GZUnaZy2WbUfnuJ3bx9efLLqG18aK7isSc/YKQCLBPjIIKQu+K/kHgwAuEl4lXzny1qPXD/EpHU9aM20PD9qt+YoqweyhnxpukGlAkz47+U6vLmwM4lUyBvzj2AalmaFW4c8DEWbmR8FpPF6F87thP9Ibq+8xBPUXxDTvh/35h/BNrC+C16GpleqgXHvKxJ8UpcU8K4Nodnzd+bKYStDM4V9HP1fQiBpfgnQ4fD/5JDUSKJxSsCIQfsVlS0/AClhEfwk5fg6vLSKfcZrWzCQSZkQ5ES88ipR+WRU0RS0tuxB2z3aPjPHEbR23tHohKY3vqNAA/z9qojUmKiYi8t4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCACFF1458D02E42AF2CE1473A55C108@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f501c08-88b8-400d-ace0-08d7523b7a7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 13:19:30.9338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: puhYc0kNt4dULIRj1z/CgEX6XdM5aD6wutOi9GVOYForxmk9oRhEEXXOtLTX9f/lqifLWuJcd6ulesk+gUWNHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3665
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gSmFrdWIsDQoNCj4+IHdvcmthcm91bmQgd2hlbiBzdG9wcGluZyB0aGUgZGV2aWNlKSwg
cmVnaXN0ZXIgYml0IHNob3VsZCBhY3R1YWxseQ0KPj4gYmUgdG9nZ2xlZC4NCj4gDQo+IERvZXMg
dGhlIGJpdCBnZXQgc2V0IGJ5IHRoZSBkcml2ZXIgb3IgSFc/DQo+IA0KPiBJZiBpdCBnZXRzIHNl
dCBieSBIVyB0aGVyZSBpcyBzdGlsbCBhIHRpbnkgcmFjZSBmcm9tIHJlYWRpbmcgdG8NCj4gd3Jp
dGluZy4uIFBlcmhhcHMgZG9pbmcgdHdvIHdyaXRlcyAtPiB0byAwIGFuZCB0byAxIHdvdWxkIGJl
IGEgYmV0dGVyDQo+IG9wdGlvbj8gIA0KDQpObywgc2V0IGlzIGRvbmUgYnkgdGhlIGRyaXZlciwg
bm90IEhXLiBIVyBqdXN0IHRyYWNrcyBmb3IgdGhlIHRvZ2dsZS4NCg0KPj4gSXQgd2FzIHByZXZp
b3NseSBhbHdheXMganVzdCBzZXQuIER1ZSB0byB0aGUgd2F5IGRyaXZlciBzdG9wcyBIVyB0aGlz
DQo+PiBuZXZlciBhY3R1YWxseSBjYXVzZWQgYW55IGlzc3VlcywgYnV0IGl0IHN0aWxsIG1heSwg
c28gY2xlYW5pbmcgdGhpcyB1cC4NCj4gDQo+IEhtLiBTbyBpcyBpdCBhIGNsZWFudXAgb2YgZml4
PyBEb2VzIHRoZSB3YXkgY29kZSBpcyB3cml0dGVuIGd1YXJhbnRlZQ0KPiBpdCB3aWxsIG5ldmVy
IGNhdXNlIGlzc3Vlcz8NCg0KWWVzLCB0aGF0cyBhIGNsZWFudXAuIFdlIGp1c3QgaGFkIG90aGVy
IHByb2R1Y3RzIHdoZXJlIHRoaXMgY2FjaGUgcmVzZXQgaGFkIHRvDQpiZSBkb25lIG11bHRpcGxl
IHRpbWVzLiBPYnZpb3VzbHkgZG9pbmcgdGhhdCBzZWNvbmQgdGltZSB3YXMganVzdCBuby1vcCBm
b3INCmhhcmR3YXJlIDspDQpPbiBsaW51eCB0aGlzIGFsd2F5cyBnZXRzIGNhbGxlZCBvbiBkZWlu
aXQgb25seSBvbmNlIC0gdGh1cyBpdCB3YXMgc2FmZS4NCldlIGp1c3QgYWxpZ25pbmcgaGVyZSB0
aGUgbGludXggZHJpdmVyIHdpdGggYWN0dWFsIEhXIHNwZWNpZmljYXRpb24uDQoNCj4+ICsJaWYg
KGVycikNCj4+ICsJCWdvdG8gZXJyX2V4aXQ7DQo+PiArDQo+PiArCXJlYWR4X3BvbGxfdGltZW91
dF9hdG9taWMoaHdfYXRsX3JkbV9yeF9kbWFfZGVzY19jYWNoZV9pbml0X2RvbmVfZ2V0LA0KPj4g
KwkJCQkgIHNlbGYsIHZhbCwgdmFsID09IDEsIDEwMDBVLCAxMDAwMFUpOw0KPiANCj4gSXQncyBh
IGxpdHRsZSBzdHJhbmdlIHRvIHRvZ2dsZSwgeWV0IHdhaXQgZm9yIGl0IHRvIGJlIG9mIGEgc3Bl
Y2lmaWMNCj4gdmFsdWUuLg0KDQpOb3RpY2UgdGhhdHMgYSBkaWZmZXJlbnQgdmFsdWUgLSAnY2Fj
aGVfaW5pdF9kb25lJyBiaXQuDQpUaGlzIGlzIHVzZWQgYnkgSFcgdG8gaW5kaWNhdGUgY29tcGxl
dGlvbiBvZiBjYWNoZSByZXNldCBvcGVyYXRpb24uDQoNCj4+ICtlcnJfZXhpdDoNCj4+ICsJcmV0
dXJuIGVycjsNCj4gDQo+IEp1c3QgcmV0dXJuIGVyciBpbnN0ZWFkIG9mIGRvaW5nIHRoaXMgcG9p
bnRsZXNzIGdvdG8uIEl0IG1ha2UgdGhlIGNvZGUNCj4gaGFyZGVyIHRvIGZvbGxvdy4NCg0KU3Vy
ZQ0KDQo+PiArI2RlZmluZSBSRE1fUlhfRE1BX0RFU0NfQ0FDSEVfSU5JVF9ET05FX0RFRkFVTFQg
MHgwDQo+PiArDQo+PiArDQo+IA0KPiB0d28gZW1wdHkgbGluZXMgaGVyZT8NCg0KV2lsbCBmaXgu
DQoNClJlZ2FyZHMsDQogIElnb3INCg==
