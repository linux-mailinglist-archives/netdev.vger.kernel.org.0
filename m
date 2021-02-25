Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF58325381
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhBYQ2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:28:14 -0500
Received: from mail-dm6nam12on2088.outbound.protection.outlook.com ([40.107.243.88]:19008
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232608AbhBYQ2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 11:28:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CONxBOFIzeKSKXsfeC/KSmX3VhLtoewCoU1zTuySy+U/qdLQYkbo1zxynZEzp3wGHHWf1GME/6twT22ODxUXQ0bY3OhQY5hLpByifzc8FVotHMJOp1RS5fVV//rnwxBh/9lG5XBKLx3arTcW7SPoK9EacOHKHog/HMW00HnI6Iz7naYYb2jdScU4a7f0JS/ICO0Ck1qvQkgSK9k1rnLuwUoSaH6fd/yXEkrsggmKEgY9o5Ur2cgmGlElXVHe08eidKOY0eRaSuI5TsVNGcw65cIgv/Dx/GkL99xGX3T2SLwP21+cMTPzWSfOLAtn2ZxXsDTmFf+Kx9ObwY1Drn7XsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CD5TsV9iF2XcrL+eR+Q50mJ1uJ8qz6LKZKvJxe8nS4Q=;
 b=k8jZGnxtfznZ5E/cwft2YuZnTO4vS5/4XKAtjwxBy/IYb65+oNTdlWC4VVvDddwy06kUZKNa7Wrj57SZK0/wgBiMPJxOAAoXN0LM09zXSuCcYTxra3Zi/w4frZujwb6K8lhONf++MtFVgDeaLHGPmuWiFD7B4STHSZBFM7sYizzyXmsTcTH+OJp99tThkrlHinFsEacw7wvo+8ttHMo71aeWu/OHLz5+IU+PM211H9YqJxG2pBrxLUOgmzE18AGX0Ndc0zXX0l6QMMXL9eg32pVstYuqGMyfQGokcnJYeaIPVcpQ6rvbEFKwmprCE6YtVl1cqYH9jNMEk+zdLJFeWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CD5TsV9iF2XcrL+eR+Q50mJ1uJ8qz6LKZKvJxe8nS4Q=;
 b=CYXDiXs7IDGJhltos0/eRSM88evYxzoAPjnn86THa94VQ9+ZfR6Y8BwGqJX0zVIP3Gi6smDBSLTH0Zub6VCXTko23hjw7BF8KcaBcc7TrTXQ0pNw/B0SFmQ2bGKJAqLmgbDYMUtWgMt4acn090gGo4ruL3PpeEopdIc82t43ibU=
Received: from DM5PR05MB3452.namprd05.prod.outlook.com (2603:10b6:4:41::11) by
 DM5PR05MB3609.namprd05.prod.outlook.com (2603:10b6:4:45::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.11; Thu, 25 Feb 2021 16:27:11 +0000
Received: from DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::6d72:f94:9524:f08]) by DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::6d72:f94:9524:f08%4]) with mapi id 15.20.3805.007; Thu, 25 Feb 2021
 16:27:11 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v5 04/19] af_vsock: implement SEQPACKET receive loop
Thread-Topic: [RFC PATCH v5 04/19] af_vsock: implement SEQPACKET receive loop
Thread-Index: AQHXBbhDY1P88uIQvUSGyWakwPpy+qppGq4A
Date:   Thu, 25 Feb 2021 16:27:10 +0000
Message-ID: <125822F8-C6D5-4892-BD32-A7189578B3DE@vmware.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053719.1067237-1-arseny.krasnov@kaspersky.com>
In-Reply-To: <20210218053719.1067237-1-arseny.krasnov@kaspersky.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kaspersky.com; dkim=none (message not signed)
 header.d=none;kaspersky.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [83.92.5.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ba55b41-1f66-4c21-ec06-08d8d9aa3414
x-ms-traffictypediagnostic: DM5PR05MB3609:
x-microsoft-antispam-prvs: <DM5PR05MB36094E5B094BD35A53992FFADA9E9@DM5PR05MB3609.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KgVrltxmX6yq8pjCRO7h1szUB38aay7x/vTbeAiKJqqFO+xGa/OYfkQwz52zbpgem9UMf3crWX7i1w+jbRrRcGda8mi6TjnWWAxXQNSx7PLi+XjQNEa/WDPwGB8W7cG6duvxExeRHTappAEN8pSHk66lFVLHgebPk6/VJnm0EuFMKvjRcTHf5togPDG0ttyb/2Q8bXpmUqaLk9bpGrZMptCWlATkTA0VgtwddhVmavQ28bROkpfsIscku6wSLpyJX6jYhG9uyT3BLAUPl/7oqgSaDhkxL6evBpx7Ie5uoHUf5Sp5vKdbrocrYVZUmb9oLl+Gbzox0at1yBJzXNgzP/l4iJM0qm1TV3VCp1rCDAAv2mTp/fpCkQV9h50We3m0JCtnR022eBS0atwnxtuZQF8q9c4D/qSs2CeF47NB9sgl3tAKlzd6d0Qve8xndFyMSVBp5gCL2n4GFOTYWsL5ZG8vpBlGiyJC+GX7xaLpQ74rzkLcBeFuBQXLXb4AGQPH5beWaudNjvwvBTkqgvxUh5BQWnyu3EGtC/4lfucZbHify0fJxBAHIHeqizVDvUPX5bzffGbpSHfRY44RKLuaZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR05MB3452.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(6916009)(6486002)(71200400001)(54906003)(83380400001)(66946007)(2906002)(76116006)(53546011)(91956017)(66556008)(6512007)(186003)(316002)(33656002)(478600001)(66476007)(7416002)(66446008)(8936002)(2616005)(36756003)(86362001)(6506007)(64756008)(5660300002)(4326008)(26005)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WjdCdHpaSjZndjV3SENYRndZalpST0w4YVNDVGhJUXRJdW5ZTmUxcU0wUGRs?=
 =?utf-8?B?K2x5dnlFSEtMZVZyVE9kMnA1cTd5ODJBNkwzVkxQMWdjQi9iVWEzMVd1cTRy?=
 =?utf-8?B?aW8zS29leVhrWEd3bnpiQ2ovSlhHTjhMa1JGYnpDWFBDRGQrMnhrS3ZmZGQv?=
 =?utf-8?B?NXNxajlCZTBSQ01WMEtBaEE2NWNhdFhCaFUzRmZFejRvWkVoYmxHektmcmw1?=
 =?utf-8?B?eFNnRjg1TGt0eDFwYlpIUkFsTVRNbFZWTVB5eG5IYnhSYU13WkJTbkhEK1I2?=
 =?utf-8?B?WkFiNjRiRW9hcmNKTXU4aFdqODBWVW4vY3ZndENic2xGL2NIUEhZV2ZNOGhV?=
 =?utf-8?B?aGhPdHhXYWVRYnV1SUZ3UjF5WWsvSS9BV0dNN1IzdmRBelBLVmx0V0tpMW12?=
 =?utf-8?B?SXJIdWZxZUV1UHR3RnRkemlxb0tFOHMwR2tnY25oaVJuMW9YTExGUE5kMm4r?=
 =?utf-8?B?bDEwbDRxeTd6MUw3UlJGd25kc0JoNmcwb3VldXI5N01CUVc2d2dUY091cXNw?=
 =?utf-8?B?V2J1S0wvSVU4K1p5Rjl2MjcyRTB2d1lMUVlpTHZWMDNmSHcwR0xHU0N2aWls?=
 =?utf-8?B?MzhmeVpSWVJld3lmMTZubnlyTk0wYm15WG1ZbTFUb2JjQ0tGdWtOaG9tVjBS?=
 =?utf-8?B?bkVUOGg4bGdwTHExU0JGRzFMWnplTWhYZDhCMis3ZWJYcTcrMkJ0VHNIbnA5?=
 =?utf-8?B?S0FHaEtlb09IRlcrWkROYzJCMW1LanZkcGNOaVhYRWNoZkhISmxCVW11d0V3?=
 =?utf-8?B?eWx3MVNreU1lSlFNbVVlaEkyVTJlUVIyU0liTWUyYXZHV0xvMHRld3lzTWt4?=
 =?utf-8?B?dHMvbHVVa3QrYkpra0Z5aTRCNEVCREFFajlGNXloWEUrcCtmbG5CY0lUQ012?=
 =?utf-8?B?U0t2SXdCT2UvQmRJWmt0bHowa3RRZ0NlTEwxUXV5ekNIWDRtbnk5Y1pwM2pU?=
 =?utf-8?B?V2JCNXcwQkdmbFJ2K0Z0SUJydG0wVWdzQWxweVlRakpYK2VjVEJzWHJXTW9V?=
 =?utf-8?B?eG5LdXN1VW1RSE1XUXNyZWY1aGhoZnZKUlJIZEpzNUNyRytMYmNhaWtOTER2?=
 =?utf-8?B?ZWRiUXhteWhoNzFZNWlUb0FFanBXVUFDbERlQTlLL0Y5dzJ4bG45MGhKZEd5?=
 =?utf-8?B?WVRaWWtjZlhzRFhmM3ZxRWk1Qy9oaWVUM0hZZ0R4UWNUenM3VEhEY25SVEVI?=
 =?utf-8?B?N3hsYmJjdFNEcXRzbjRlM3h4L0w5VFlVUHZJQURRQk5xQXZPN24wbjAzRGhh?=
 =?utf-8?B?RWlCQ0RDeEo4QlRhTkw2ZzJhSElCdE9PVGR6ZDlpZlJDY3F5UXQwcmR5K3FB?=
 =?utf-8?B?NUVjRnNwRytUdDFJUDJSaW1iSVI3TmNsNkVCTEVYenNQRkVCZytZT2h0Qmx1?=
 =?utf-8?B?K09jUnJ3OTRxRW1FOWlGYytVSjBnTWJTejVoS1B2dDdtOUdWY3hCbmRsUk9J?=
 =?utf-8?B?bmpsdzAxOVNLeFR4dHA1ekxrY0YxM1lNRk9EVkxjSGErZzNlS0R1NlJORldL?=
 =?utf-8?B?eGN2TFpUR3htVXFoNDZOc3h6STJ2RUgyR1pDQ3VIOGt4Ti8wL2ZaNGZCZFU4?=
 =?utf-8?B?MCtCTXQ2ZUo4ZDhGM2tFK1ZoNlZ3LzVkZ0NVV2xMMHpzVEJCWUNXakU5Q3dS?=
 =?utf-8?B?aHVocEZXRjJyRDBYM3dESkxOVUh6QWNWUnMxQmNZV0lvUUF4Vlh0Q2F4Y25w?=
 =?utf-8?B?M1g1NVN3d1NvSHlBSHY1M2FPd2E2ZWhoNEF2dCt2NjZjcU04QWdBUVgwZE52?=
 =?utf-8?Q?zNyh6IVVhv+WLOS0jf4dqR3GQ56hwu2FO/2uD9G?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <447BAF15702CFA438C41C02DBF32403F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR05MB3452.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ba55b41-1f66-4c21-ec06-08d8d9aa3414
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 16:27:11.0561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j9tKX/XRJpMiI/tp9T/ZnXJwltAhc12b6RWAFMEHNG4fbrcsX5BZaAQtDyWO327DQi3S+S2ag3HTbn+32du2kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR05MB3609
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTggRmViIDIwMjEsIGF0IDA2OjM3LCBBcnNlbnkgS3Jhc25vdiA8YXJzZW55LmtyYXNub3ZA
a2FzcGVyc2t5LmNvbT4gd3JvdGU6DQo+IA0KPiBUaGlzIGFkZHMgcmVjZWl2ZSBsb29wIGZvciBT
RVFQQUNLRVQuIEl0IGxvb2tzIGxpa2UgcmVjZWl2ZSBsb29wIGZvcg0KPiBTVFJFQU0sIGJ1dCB0
aGVyZSBpcyBhIGxpdHRsZSBiaXQgZGlmZmVyZW5jZToNCj4gMSkgSXQgZG9lc24ndCBjYWxsIG5v
dGlmeSBjYWxsYmFja3MuDQo+IDIpIEl0IGRvZXNuJ3QgY2FyZSBhYm91dCAnU09fU05ETE9XQVQn
IGFuZCAnU09fUkNWTE9XQVQnIHZhbHVlcywgYmVjYXVzZQ0KPiAgIHRoZXJlIGlzIG5vIHNlbnNl
IGZvciB0aGVzZSB2YWx1ZXMgaW4gU0VRUEFDS0VUIGNhc2UuDQo+IDMpIEl0IHdhaXRzIHVudGls
IHdob2xlIHJlY29yZCBpcyByZWNlaXZlZCBvciBlcnJvciBpcyBmb3VuZCBkdXJpbmcNCj4gICBy
ZWNlaXZpbmcuDQo+IDQpIEl0IHByb2Nlc3NlcyBhbmQgc2V0cyAnTVNHX1RSVU5DJyBmbGFnLg0K
PiANCj4gU28gdG8gYXZvaWQgZXh0cmEgY29uZGl0aW9ucyBmb3IgdHdvIHR5cGVzIG9mIHNvY2tl
dCBpbnNpZGUgb25lIGxvb3AsIHR3bw0KPiBpbmRlcGVuZGVudCBmdW5jdGlvbnMgd2VyZSBjcmVh
dGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQXJzZW55IEtyYXNub3YgPGFyc2VueS5rcmFzbm92
QGthc3BlcnNreS5jb20+DQo+IC0tLQ0KPiBpbmNsdWRlL25ldC9hZl92c29jay5oICAgfCAgNSAr
KysNCj4gbmV0L3Ztd192c29jay9hZl92c29jay5jIHwgOTcgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrLQ0KPiAyIGZpbGVzIGNoYW5nZWQsIDEwMSBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvYWZfdnNvY2su
aCBiL2luY2x1ZGUvbmV0L2FmX3Zzb2NrLmgNCj4gaW5kZXggYjFjNzE3Mjg2OTkzLi4wMTU2MzMz
OGNjMDMgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbmV0L2FmX3Zzb2NrLmgNCj4gKysrIGIvaW5j
bHVkZS9uZXQvYWZfdnNvY2suaA0KPiBAQCAtMTM1LDYgKzEzNSwxMSBAQCBzdHJ1Y3QgdnNvY2tf
dHJhbnNwb3J0IHsNCj4gCWJvb2wgKCpzdHJlYW1faXNfYWN0aXZlKShzdHJ1Y3QgdnNvY2tfc29j
ayAqKTsNCj4gCWJvb2wgKCpzdHJlYW1fYWxsb3cpKHUzMiBjaWQsIHUzMiBwb3J0KTsNCj4gDQo+
ICsJLyogU0VRX1BBQ0tFVC4gKi8NCj4gKwlzaXplX3QgKCpzZXFwYWNrZXRfc2VxX2dldF9sZW4p
KHN0cnVjdCB2c29ja19zb2NrICp2c2spOw0KPiArCWludCAoKnNlcXBhY2tldF9kZXF1ZXVlKShz
dHJ1Y3QgdnNvY2tfc29jayAqdnNrLCBzdHJ1Y3QgbXNnaGRyICptc2csDQo+ICsJCQkJICAgICBp
bnQgZmxhZ3MsIGJvb2wgKm1zZ19yZWFkeSk7DQo+ICsNCj4gCS8qIE5vdGlmaWNhdGlvbi4gKi8N
Cj4gCWludCAoKm5vdGlmeV9wb2xsX2luKShzdHJ1Y3QgdnNvY2tfc29jayAqLCBzaXplX3QsIGJv
b2wgKik7DQo+IAlpbnQgKCpub3RpZnlfcG9sbF9vdXQpKHN0cnVjdCB2c29ja19zb2NrICosIHNp
emVfdCwgYm9vbCAqKTsNCj4gZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svYWZfdnNvY2suYyBi
L25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KPiBpbmRleCBkMjc3ZGMxY2RiZGYuLmI3NTQ5Mjdh
NTU2YSAxMDA2NDQNCj4gLS0tIGEvbmV0L3Ztd192c29jay9hZl92c29jay5jDQo+ICsrKyBiL25l
dC92bXdfdnNvY2svYWZfdnNvY2suYw0KPiBAQCAtMTk3Miw2ICsxOTcyLDk4IEBAIHN0YXRpYyBp
bnQgX192c29ja19zdHJlYW1fcmVjdm1zZyhzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBtc2doZHIg
Km1zZywNCj4gCXJldHVybiBlcnI7DQo+IH0NCj4gDQo+ICtzdGF0aWMgaW50IF9fdnNvY2tfc2Vx
cGFja2V0X3JlY3Ztc2coc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3QgbXNnaGRyICptc2csDQo+ICsJ
CQkJICAgICBzaXplX3QgbGVuLCBpbnQgZmxhZ3MpDQo+ICt7DQo+ICsJY29uc3Qgc3RydWN0IHZz
b2NrX3RyYW5zcG9ydCAqdHJhbnNwb3J0Ow0KPiArCWNvbnN0IHN0cnVjdCBpb3ZlYyAqb3JpZ19p
b3Y7DQo+ICsJdW5zaWduZWQgbG9uZyBvcmlnX25yX3NlZ3M7DQo+ICsJYm9vbCBtc2dfcmVhZHk7
DQo+ICsJc3RydWN0IHZzb2NrX3NvY2sgKnZzazsNCj4gKwlzaXplX3QgcmVjb3JkX2xlbjsNCj4g
Kwlsb25nIHRpbWVvdXQ7DQo+ICsJaW50IGVyciA9IDA7DQo+ICsJREVGSU5FX1dBSVQod2FpdCk7
DQo+ICsNCj4gKwl2c2sgPSB2c29ja19zayhzayk7DQo+ICsJdHJhbnNwb3J0ID0gdnNrLT50cmFu
c3BvcnQ7DQo+ICsNCj4gKwl0aW1lb3V0ID0gc29ja19yY3Z0aW1lbyhzaywgZmxhZ3MgJiBNU0df
RE9OVFdBSVQpOw0KPiArCW9yaWdfbnJfc2VncyA9IG1zZy0+bXNnX2l0ZXIubnJfc2VnczsNCj4g
KwlvcmlnX2lvdiA9IG1zZy0+bXNnX2l0ZXIuaW92Ow0KPiArCW1zZ19yZWFkeSA9IGZhbHNlOw0K
PiArCXJlY29yZF9sZW4gPSAwOw0KPiArDQo+ICsJd2hpbGUgKDEpIHsNCj4gKwkJZXJyID0gdnNv
Y2tfd2FpdF9kYXRhKHNrLCAmd2FpdCwgdGltZW91dCwgTlVMTCwgMCk7DQo+ICsNCj4gKwkJaWYg
KGVyciA8PSAwKSB7DQo+ICsJCQkvKiBJbiBjYXNlIG9mIGFueSBsb29wIGJyZWFrKHRpbWVvdXQs
IHNpZ25hbA0KPiArCQkJICogaW50ZXJydXB0IG9yIHNodXRkb3duKSwgd2UgcmVwb3J0IHVzZXIg
dGhhdA0KPiArCQkJICogbm90aGluZyB3YXMgY29waWVkLg0KPiArCQkJICovDQo+ICsJCQllcnIg
PSAwOw0KPiArCQkJYnJlYWs7DQo+ICsJCX0NCj4gKw0KPiArCQlpZiAocmVjb3JkX2xlbiA9PSAw
KSB7DQo+ICsJCQlyZWNvcmRfbGVuID0NCj4gKwkJCQl0cmFuc3BvcnQtPnNlcXBhY2tldF9zZXFf
Z2V0X2xlbih2c2spOw0KPiArDQo+ICsJCQlpZiAocmVjb3JkX2xlbiA9PSAwKQ0KPiArCQkJCWNv
bnRpbnVlOw0KPiArCQl9DQo+ICsNCj4gKwkJZXJyID0gdHJhbnNwb3J0LT5zZXFwYWNrZXRfZGVx
dWV1ZSh2c2ssIG1zZywNCj4gKwkJCQkJZmxhZ3MsICZtc2dfcmVhZHkpOw0KPiArDQo+ICsJCWlm
IChlcnIgPCAwKSB7DQo+ICsJCQlpZiAoZXJyID09IC1FQUdBSU4pIHsNCj4gKwkJCQlpb3ZfaXRl
cl9pbml0KCZtc2ctPm1zZ19pdGVyLCBSRUFELA0KPiArCQkJCQkgICAgICBvcmlnX2lvdiwgb3Jp
Z19ucl9zZWdzLA0KPiArCQkJCQkgICAgICBsZW4pOw0KPiArCQkJCS8qIENsZWFyICdNU0dfRU9S
JyBoZXJlLCBiZWNhdXNlIGRlcXVldWUNCj4gKwkJCQkgKiBjYWxsYmFjayBhYm92ZSBzZXQgaXQg
YWdhaW4gaWYgaXQgd2FzDQo+ICsJCQkJICogc2V0IGJ5IHNlbmRlci4gVGhpcyAnTVNHX0VPUicg
aXMgZnJvbQ0KPiArCQkJCSAqIGRyb3BwZWQgcmVjb3JkLg0KPiArCQkJCSAqLw0KPiArCQkJCW1z
Zy0+bXNnX2ZsYWdzICY9IH5NU0dfRU9SOw0KPiArCQkJCXJlY29yZF9sZW4gPSAwOw0KPiArCQkJ
CWNvbnRpbnVlOw0KPiArCQkJfQ0KDQpTbyBhIHF1ZXN0aW9uIGZvciBteSB1bmRlcnN0YW5kaW5n
IG9mIHRoZSBmbG93IGhlcmUuIFNPQ0tfU0VRUEFDS0VUIGlzIHJlbGlhYmxlLCBzbw0Kd2hhdCBk
b2VzIGl0IG1lYW4gdG8gZHJvcCB0aGUgcmVjb3JkPyBJcyB0aGUgdHJhbnNwb3J0IHN1cHBvc2Vk
IHRvIHJvbGwgYmFjayB0byB0aGUNCmJlZ2lubmluZyBvZiB0aGUgY3VycmVudCByZWNvcmQ/IElm
IHRoZSBpbmNvbWluZyBkYXRhIGluIHRoZSB0cmFuc3BvcnQgZG9lc27igJl0IGZvbGxvdw0KdGhl
IHByb3RvY29sLCBhbmQgcGFja2V0cyBuZWVkIHRvIGJlIGRyb3BwZWQsIHNob3VsZG7igJl0IHRo
ZSBzb2NrZXQgYmUgcmVzZXQgb3Igc2ltaWxhcj8NCk1heWJlIHRoZXJlIGlzIHBvdGVudGlhbCBm
b3Igc2ltcGxpZnlpbmcgdGhlIGZsb3cgaWYgdGhhdCBpcyB0aGUgY2FzZS4NCg0KPiArDQo+ICsJ
CQllcnIgPSAtRU5PTUVNOw0KPiArCQkJYnJlYWs7DQo+ICsJCX0NCj4gKw0KPiArCQlpZiAobXNn
X3JlYWR5KQ0KPiArCQkJYnJlYWs7DQo+ICsJfQ0KPiArDQo+ICsJaWYgKHNrLT5za19lcnIpDQo+
ICsJCWVyciA9IC1zay0+c2tfZXJyOw0KPiArCWVsc2UgaWYgKHNrLT5za19zaHV0ZG93biAmIFJD
Vl9TSFVURE9XTikNCj4gKwkJZXJyID0gMDsNCj4gKw0KPiArCWlmIChtc2dfcmVhZHkpIHsNCj4g
KwkJLyogVXNlciBzZXRzIE1TR19UUlVOQywgc28gcmV0dXJuIHJlYWwgbGVuZ3RoIG9mDQo+ICsJ
CSAqIHBhY2tldC4NCj4gKwkJICovDQo+ICsJCWlmIChmbGFncyAmIE1TR19UUlVOQykNCj4gKwkJ
CWVyciA9IHJlY29yZF9sZW47DQo+ICsJCWVsc2UNCj4gKwkJCWVyciA9IGxlbiAtIG1zZy0+bXNn
X2l0ZXIuY291bnQ7DQo+ICsNCj4gKwkJLyogQWx3YXlzIHNldCBNU0dfVFJVTkMgaWYgcmVhbCBs
ZW5ndGggb2YgcGFja2V0IGlzDQo+ICsJCSAqIGJpZ2dlciB0aGFuIHVzZXIncyBidWZmZXIuDQo+
ICsJCSAqLw0KPiArCQlpZiAocmVjb3JkX2xlbiA+IGxlbikNCj4gKwkJCW1zZy0+bXNnX2ZsYWdz
IHw9IE1TR19UUlVOQzsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gZXJyOw0KPiArfQ0KPiArDQo+
IHN0YXRpYyBpbnQNCj4gdnNvY2tfY29ubmVjdGlibGVfcmVjdm1zZyhzdHJ1Y3Qgc29ja2V0ICpz
b2NrLCBzdHJ1Y3QgbXNnaGRyICptc2csIHNpemVfdCBsZW4sDQo+IAkJCSAgaW50IGZsYWdzKQ0K
PiBAQCAtMjAyNyw3ICsyMTE5LDEwIEBAIHZzb2NrX2Nvbm5lY3RpYmxlX3JlY3Ztc2coc3RydWN0
IHNvY2tldCAqc29jaywgc3RydWN0IG1zZ2hkciAqbXNnLCBzaXplX3QgbGVuLA0KPiAJCWdvdG8g
b3V0Ow0KPiAJfQ0KPiANCj4gLQllcnIgPSBfX3Zzb2NrX3N0cmVhbV9yZWN2bXNnKHNrLCBtc2cs
IGxlbiwgZmxhZ3MpOw0KPiArCWlmIChzay0+c2tfdHlwZSA9PSBTT0NLX1NUUkVBTSkNCj4gKwkJ
ZXJyID0gX192c29ja19zdHJlYW1fcmVjdm1zZyhzaywgbXNnLCBsZW4sIGZsYWdzKTsNCj4gKwll
bHNlDQo+ICsJCWVyciA9IF9fdnNvY2tfc2VxcGFja2V0X3JlY3Ztc2coc2ssIG1zZywgbGVuLCBm
bGFncyk7DQo+IA0KPiBvdXQ6DQo+IAlyZWxlYXNlX3NvY2soc2spOw0KPiAtLSANCj4gMi4yNS4x
DQo+IA0KDQo=
