Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 443C21C8E5
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 14:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfENMhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 08:37:55 -0400
Received: from mail-eopbgr730045.outbound.protection.outlook.com ([40.107.73.45]:55712
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbfENMhy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 08:37:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IMyhjLJwhtVXt/whEehB4rAyttSgUOsHCy5sCt6WORo=;
 b=MVhRmENXFM3sMSt8Q3M9fCzOmPa9p/k4H95+y4UDelRNi8BeCCGqcT69rZPKss/7GIR3BcLAfmQjZ4lHHydsxNaQ7vk6/PmbOKMsYwiKfGZzSZX+ArdluaRa0/r0b5jStBxFfvQVOT4zQ3O0ssqZ1g4duf9WW5k20pQ0LP0MQjQ=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB4011.namprd11.prod.outlook.com (20.176.125.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Tue, 14 May 2019 12:37:52 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::60da:b876:40f2:6a19]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::60da:b876:40f2:6a19%3]) with mapi id 15.20.1878.024; Tue, 14 May 2019
 12:37:52 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Oliver Neukum <oneukum@suse.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] aqc111: fix endianness issue in aqc111_change_mtu
Thread-Topic: [PATCH 1/3] aqc111: fix endianness issue in aqc111_change_mtu
Thread-Index: AQHVClHYc/Rm1zifJE6/xStgLG+vvg==
Date:   Tue, 14 May 2019 12:37:52 +0000
Message-ID: <694dacbe-f9a1-41ee-8131-d931dbd91b10@aquantia.com>
References: <20190509090818.9257-1-oneukum@suse.com>
In-Reply-To: <20190509090818.9257-1-oneukum@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR1001CA0021.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:3:f7::31) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dda5b8c9-fd8d-42b2-032e-08d6d868fb02
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB4011;
x-ms-traffictypediagnostic: DM6PR11MB4011:
x-microsoft-antispam-prvs: <DM6PR11MB401179E070566C18B695D34398080@DM6PR11MB4011.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(136003)(396003)(39850400004)(199004)(189003)(6486002)(66066001)(2906002)(44832011)(52116002)(6506007)(386003)(5660300002)(446003)(11346002)(305945005)(478600001)(31696002)(476003)(2616005)(86362001)(486006)(36756003)(7736002)(316002)(229853002)(71200400001)(71190400001)(53546011)(2501003)(72206003)(110136005)(102836004)(31686004)(64756008)(14454004)(99286004)(66946007)(73956011)(8936002)(8676002)(3846002)(6116002)(6512007)(81156014)(81166006)(76176011)(25786009)(6436002)(4744005)(6246003)(53936002)(14444005)(256004)(26005)(66446008)(186003)(66556008)(68736007)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB4011;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HVJg6+0gPxA+/5s+M/exMlqFIg9n8PmhliEQi+iaSMHX2eUWe2U9RIo44pEW/VpQCpuuKiHoB0Ud03vOly2sKKIrjjqBzxaNPmbZ7klD3ZXKpWQoxtsi28aMecXjVh4Cz4KKETZA1ugrPShF8FF9LiXYesQSEPCVeTzZLWtDVosL0G+bPUviNmQXZE8W8uI0p8FBcEuHsvfDlCKluX8cjPSTa37KWVHo2dzY+P36lSvyBynGgK8fDUOnQ8/L4Q1u75+staEAGKoARQO0Rw+HrPHIRk0vMMPQ2oepdTlYAwiQnmY3DIbadppbHkw4RGjb5gTW8Dpy0sGoCYhuF1jq+8rERe+/6jgl5esLoWQCTLDSFI+OxNeCm+IvhkMGjKfWLChyeOwY+VjaEkeBnlinqiMjx/L1n/zi8lUCvvkhtOQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC4BE2FA4F5613469F487EF8FDA02488@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dda5b8c9-fd8d-42b2-032e-08d6d868fb02
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 12:37:52.1867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4011
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDA5LjA1LjIwMTkgMTI6MDgsIE9saXZlciBOZXVrdW0gd3JvdGU6DQo+IElmIHRoZSBN
VFUgaXMgbGFyZ2UgZW5vdWdoLCB0aGUgZmlyc3Qgd3JpdGUgdG8gdGhlIGRldmljZQ0KPiBpcyBq
dXN0IHJlcGVhdGVkLiBPbiBCRSBhcmNoaXRlY3R1cmVzLCBob3dldmVyLCB0aGUgZmlyc3QNCj4g
d29yZCBvZiB0aGUgY29tbWFuZCB3aWxsIGJlIHN3YXBwZWQgYSBzZWNvbmQgdGltZSBhbmQgZ2Fy
YmFnZQ0KPiB3aWxsIGJlIHdyaXR0ZW4uIEF2b2lkIHRoYXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0
L3VzYi9hcWMxMTEuYyB8IDIgKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC91c2IvYXFjMTExLmMgYi9kcml2ZXJzL25l
dC91c2IvYXFjMTExLmMNCj4gaW5kZXggYWZmOTk1YmUyYTMxLi40MDhkZjJkMzM1ZTMgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3VzYi9hcWMxMTEuYw0KPiArKysgYi9kcml2ZXJzL25ldC91
c2IvYXFjMTExLmMNCj4gQEAgLTQ1Myw2ICs0NTMsOCBAQCBzdGF0aWMgaW50IGFxYzExMV9jaGFu
Z2VfbXR1KHN0cnVjdCBuZXRfZGV2aWNlICpuZXQsIGludCBuZXdfbXR1KQ0KPiAgCQlyZWcxNiA9
IDB4MTQyMDsNCj4gIAllbHNlIGlmIChkZXYtPm5ldC0+bXR1IDw9IDE2MzM0KQ0KPiAgCQlyZWcx
NiA9IDB4MUEyMDsNCj4gKwllbHNlDQo+ICsJCXJldHVybiAwOw0KPiAgDQo+ICAJYXFjMTExX3dy
aXRlMTZfY21kKGRldiwgQVFfQUNDRVNTX01BQywgU0ZSX1BBVVNFX1dBVEVSTFZMX0xPVywNCj4g
IAkJCSAgIDIsICZyZWcxNik7DQo+IA0KDQpTaW5jZSB3ZSBzcGVjaWZ5IG1heF9tdHUgYXQgYGJp
bmRgIHRpbWUsIHRoaXMgYGVsc2VgIHdpbGwgbmV2ZXIgaGFwcGVuLg0KT25seSBmb3IgcmVhZGFi
aWxpdHkgdGhhdCBjb3VsZCBiZSByZXdyaXR0ZW4gYXMNCg0KLSAgCWVsc2UgaWYgKGRldi0+bmV0
LT5tdHUgPD0gMTYzMzQpDQorCWVsc2UNCgkJcmVnMTYgPSAweDFBMjA7DQoNClJlZ2FyZHMsDQog
IElnb3INCg==
