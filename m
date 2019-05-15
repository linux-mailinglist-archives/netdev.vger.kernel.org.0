Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235151F64B
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 16:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfEOOQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 10:16:15 -0400
Received: from mail-eopbgr790078.outbound.protection.outlook.com ([40.107.79.78]:25824
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726766AbfEOOQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 10:16:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zl6hRBGXxxE7fxRVeG6T79UPCgrCxlyVYgFUC/oxZ/E=;
 b=Xw99763zRQWXOFhauuxT+Um8BabrqKIEh+gCrAXejf6r/cEecdb+1bo81p8J17VQP6AQwIW2WBwEg3bX1MbG61xv0gtst2ybzyfN3nxjolgSlSxXJi11oxhAG+VTVTYdkm3Ragi7s/dHqDuKoK3IZhSQtXeXi2SdaGBnZ5g4X/0=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB2924.namprd11.prod.outlook.com (20.177.216.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Wed, 15 May 2019 14:16:12 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1900.010; Wed, 15 May 2019
 14:16:12 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Oliver Neukum <oneukum@suse.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/3] aqc111: fix writing to the phy on BE
Thread-Topic: [PATCH 2/3] aqc111: fix writing to the phy on BE
Thread-Index: AQHVCk4goKWxhGgVDkycPKGnEFaexQ==
Date:   Wed, 15 May 2019 14:16:11 +0000
Message-ID: <00719f72-280b-418f-235d-8bf0215d484e@aquantia.com>
References: <20190509090818.9257-1-oneukum@suse.com>
 <20190509090818.9257-2-oneukum@suse.com>
 <cd6754c6-8384-a65c-1c0e-0e3d2eaaa66b@aquantia.com>
 <1557839644.11261.4.camel@suse.com>
In-Reply-To: <1557839644.11261.4.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0218.eurprd05.prod.outlook.com
 (2603:10a6:3:fa::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43adc73f-fced-48ed-28f6-08d6d93fe1ff
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB2924;
x-ms-traffictypediagnostic: DM6PR11MB2924:
x-microsoft-antispam-prvs: <DM6PR11MB29243F78471F8CC3B42556CF98090@DM6PR11MB2924.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(366004)(136003)(39850400004)(376002)(199004)(189003)(6246003)(14454004)(8936002)(8676002)(76176011)(110136005)(6512007)(31696002)(6506007)(386003)(305945005)(66066001)(86362001)(7736002)(72206003)(3846002)(6116002)(99286004)(81166006)(81156014)(53936002)(52116002)(5660300002)(26005)(25786009)(2616005)(6436002)(36756003)(11346002)(2501003)(66946007)(2906002)(478600001)(4744005)(31686004)(186003)(73956011)(68736007)(229853002)(256004)(486006)(66476007)(14444005)(66556008)(71200400001)(476003)(71190400001)(64756008)(66446008)(102836004)(446003)(44832011)(316002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB2924;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8boo9LoKbPSMKOCKx5M7OzfeRrwKO5QufI7Ld2gxpXCWZ3Zn60W8jyGg/HxAok2mbBdSnU9M9+aZFXaapjbhAIdZNp/X+8UtcaKawh3I/s4G1NY9BP6TuiAdjGXgyN46+BVu+WAwCyz8Wqph/50ishca5FKLaunBI0rAc16IWrsSBr0m5C13v84e2hKGBZFg/vgZgdHMbdevTTwS2etNjWXerPfwZUPX6sOQqt1yD9gaC1xhanEPdV8zZf/GQgTeYbdSo+ANm+GS9KkYWyIwXgJpFar6FOsmLvE+uFGK8QAaoAw93a29EFd6oQKjMRxd0qTnhViDx4AHj7CYr9u2MuTSd+7VJ1Jh/P6OxNiFf3D7Gqhtroe8WizVxJCEFeqpkV7cyjbC3uF+lAHMfSwIJjxyvviIu+43+J1rCbLGpc8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAB7AF815D9C8A4B9E69A873DED84329@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43adc73f-fced-48ed-28f6-08d6d93fe1ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 14:16:12.0304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2924
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+Pj4gLQlhcWMxMTFfd3JpdGUzMl9jbWQoZGV2LCBBUV9QSFlfT1BTLCAwLCAwLCAmYXFjMTEx
X2RhdGEtPnBoeV9jZmcpOw0KPj4+ICsJcGh5X29uX3RoZV93aXJlID0gYXFjMTExX2RhdGEtPnBo
eV9jZmc7DQo+Pj4gKwlhcWMxMTFfd3JpdGUzMl9jbWQoZGV2LCBBUV9QSFlfT1BTLCAwLCAwLCAm
cGh5X29uX3RoZV93aXJlKTsNCj4+DQo+PiBIaSBPbGl2ZXIsDQo+Pg0KPj4gSSBzZWUgYWxsIHdy
aXRlMzJfY21kIGFuZCB3cml0ZTE2X2NtZCBhcmUgdXNpbmcgYSB0ZW1wb3JhcnkgdmFyaWFibGUg
dG8gZG8gYW4NCj4+IGludGVybmFsIGNwdV90b19sZTMyLiBXaHkgdGhpcyBleHRyYSB0ZW1wb3Jh
cnkgc3RvcmFnZSBpcyBuZWVkZWQ/DQo+Pg0KPj4gVGhlIHF1ZXN0aW9uIGlzIGFjdHVhbGx5IGZv
ciBib3RoIDJuZCBhbmQgdGhpcmQgcGF0Y2guDQo+PiBJbiBhbGwgdGhlIGNhc2VzIEJFIG1hY2hp
bmUgd2lsbCBzdG9yZSB0ZW1wb3JhcnkgYnN3YXAgY29udmVyc2lvbiBpbiB0bXANCj4+IHZhcmlh
YmxlIGFuZCB3aWxsIG5vdCBhY3R1YWxseSB0b3VjaCBhY3R1YWwgZmllbGQuDQo+IA0KPiBIaSwN
Cj4gDQo+IEkgYW0gbW9zdCB0ZXJyaWJseSBzb3JyeS4gSSBvdmVybG9va2VkIHRoZSBjb3B5LiBT
aGFsbCBJIHJldmVydCBvciB3aWxsDQo+IHlvdS4NCj4gDQo+IAlTb3JyeQ0KPiAJCU9saXZlcg0K
DQpIaSBPbGl2ZXIsDQoNCkknbGwgc3VibWl0IHRoZSByZXZlcnRzLg0KDQpSZWdhcmRzLA0KICBJ
Z29yDQo=
