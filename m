Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD054663E9
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347391AbhLBMss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:48:48 -0500
Received: from mail-eopbgr50123.outbound.protection.outlook.com ([40.107.5.123]:51968
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347388AbhLBMsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 07:48:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edVT6/4pcZYHQhBY8lsH3cn45LEh3AIj+E7hfgxSMTY+RzVbAWAcrNqshLSOMvQuGC/BQ3uduc8h+RGwaoMO7kdFNlbI7HW6XIufo+feuclsFegMYhY5bRoOXcSr2PPGYecZ1l5XAS9d1RR1CsdCQvTDX20QSWxrhZBUPbIhPCVYAvSNovAtYCpvoAHH5FxHzd9BCMSsbdojEc2fi02Z5FCRQ3p0tgiXvV28YKF7fLA+o6r6cmljHoUjc3iUpwnRlYxNBWiJtgKaaE3ZJgcTKcZoQJdv523jYszBoVkbpyvITZIfhYu8s5m4Cc3Xnzqv/el6yicf099yZ5z0E4dWxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2n6eq2V6+2e9xhXbxjLse0i2AkShQMI7vZSWVGQdPP0=;
 b=fIx4HxOiJ+ZEYceckZzWbRsYrEeHacR0rQXgaHg7KZ1XgOqXU1x7mV3BuHKNxrCTrcePfDj7YmYx6D2RG6lHuWybH6Wm9dYX4Exw+v/a6N2K7RT3AIxVgR/FxMOfqgzMkXxsMBAv1jTl0rNoS4jiA5bABDEG3FQwAfhvYUcFAmKB150hzmzA45Bmj1nB4JLjv0V0UlYjVkSm91aztjxBBzISoUOPPCI1pdBRRqK4jp+dWFYGiNuKoXSxtSLCdZt/+Q0Y7rPQuq61MQQ17wVvHV/vaRG4i4/NXj6irMMi7NLmB3NsfXryIHjCBiWaTJZRTtHmSbml7KeXdCULl6Ptxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hitachienergy.com; dmarc=pass action=none
 header.from=hitachienergy.com; dkim=pass header.d=hitachienergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2n6eq2V6+2e9xhXbxjLse0i2AkShQMI7vZSWVGQdPP0=;
 b=lHAcGdENRzjbOVnYDo3dJlKjaDoQPDgr6c0QunOwqooXT84iLUJ2CLtNoZyIG0Xf97+0rb0SMbM5Gama9fjOq/6nfhtfEZ1PlCnY1VwznD9STzY/QAkDv80dg/XQtgzSlhHElYQ93yuEdNo8feqb2/7PWv1ozN1ttkUVNr1qB2AHxEPJaUmOVaGAHEIYC0lxzA8HCHTrrhICBMDUMZ1ZDav46vQBiQC58eLC3+snqTh4z19ykvAhUUa+N69RV0H7HlIGkdTT1+p3UsfwR7fbWTMxesVrkv0SqiIOt4hFrIBy6KTquh06gPwK2d+/Hqvf+7LVGGfczQQM9nD9od6HQg==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by AM9PR06MB7267.eurprd06.prod.outlook.com (2603:10a6:20b:2cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Thu, 2 Dec
 2021 12:45:17 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::845d:9ff2:f8d4:779]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::845d:9ff2:f8d4:779%6]) with mapi id 15.20.4734.024; Thu, 2 Dec 2021
 12:45:17 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [v2 1/2] Docs/devicetree: add serdes-output-amplitude-mv to
 marvell.txt
Thread-Topic: [v2 1/2] Docs/devicetree: add serdes-output-amplitude-mv to
 marvell.txt
Thread-Index: AQHX51NpWgvnRXtEgEqODDKYaFSAv6we7n+AgAA0cYA=
Date:   Thu, 2 Dec 2021 12:45:17 +0000
Message-ID: <AM0PR0602MB3666CB050086302087DB4184F7699@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20211202080527.18520-1-holger.brunck@hitachienergy.com>
 <20211202102541.06b4e361@thinkpad>
In-Reply-To: <20211202102541.06b4e361@thinkpad>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a2ec3e1-d0fc-43ea-35c3-08d9b591981f
x-ms-traffictypediagnostic: AM9PR06MB7267:
x-microsoft-antispam-prvs: <AM9PR06MB7267532F48182FF1C5094A82F7699@AM9PR06MB7267.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pgmUemJ+sKbk7feAdBeO/JEinqKP9lYPKxIUrbBLAohueFO+l4acp5JKz8ABUANZzxQiCffZG+0IOBrpRBXdgnazy4UHfzPQG0APSRFPybeGuC2m7b6rp6l1F1Pv408ueSVmMis8ip3C5iaEvyvqbvhCREq7nbNXWEQDdeUTZXhfNyOtrD0lJVjXf82njvh0ukFjxh40JQgHEAvLPSS3oLaL5zPsWFfObmeLIgWLQT/RD1w6whA/8emXWU1F+rKq8TF+39XavFEPXFC3Z1uEzN5ydlIBJYL3yBA/EE07Xwq7qig32NZAqU1FXMuC2IWCdJ4oGYGiyTY6krPpuTmj1HSxGA+XgEEn6RdXqKMIfybn2+1Hn4q2IiLm0nq+Ui2H1t+CGY35LScinwNu9IGFQtDfzmVDFmdYxkk37KhEp9Qe3G8f6nMdjWika6Nt76d59QT/ts/zhYzdbt8G31T6W+lZe4Ns37irfSloQ0UNP1u4oojTTOlmOJJGzi6EXzrUyysp0Uz7kIg+zZ/PNz2PnCqV4lb/8rEz6eIrwJBCKPUu63lAQ7fkg0J2RwYpblsxh0WyMnMq2n1wpHNqGcRkTEJ/D/bJgZj9Q+3FzVWLa0dfwEK0MJy49QwQ4p30en3qsn5fRpU7tbawT7K62LAIkvMlsOZZ85oZXFgtkkWjVmnhaGsAQNlX8mPUg+ySRTS9wU9Igo/t1+P4iN9+s4G1Zw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(110136005)(76116006)(26005)(66476007)(316002)(2906002)(52536014)(54906003)(44832011)(66446008)(33656002)(71200400001)(66946007)(64756008)(38070700005)(4326008)(55016003)(66556008)(66574015)(9686003)(82960400001)(8936002)(186003)(6506007)(8676002)(86362001)(38100700002)(7696005)(122000001)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGFtNFdoV3JXY2o2TGl4OFpiQ0RFdW1CdFNyNm4wQ0FBMEdHY0F3L0oxS1pL?=
 =?utf-8?B?emVEYmU5MHNJcnhxSUFqaldBL1hpb3IwQ25iZnoySWdsbnQxQ0tMdjRFcGQ1?=
 =?utf-8?B?TXJZakZyOHYrZHZXRjNQTlA4Q1B4UHBsR0t5eDRXNnlFS3lGV2ZkVGIvYVVR?=
 =?utf-8?B?bUFsUlVzWitDNUp5Tm5TUFBpMUFDcHoxNEg0d2NmK1hZSnhKN293MFEyaHdh?=
 =?utf-8?B?MDFQODhyaFByRGRoNllkN2l4NXEyNzlocUdEUUpFeEVuazRRdm1YclN3OHNO?=
 =?utf-8?B?bStHN1FkZU9SdWNoRnk3WVJsL1pPajJwS1NCSXoySmgzeXRHRzBXL3FLd2dy?=
 =?utf-8?B?cDRQMDBHa2hSMktZOEdVUGJ0UDY5dFZMa2RBdHBWSDh0aGp5Zk9NaEhtb0sz?=
 =?utf-8?B?OXVhbSsxcVM3a3VVODc1dFpQcGE1RGdmOGNmZTRQb1ZWUTBuM1JhQlNiMmJj?=
 =?utf-8?B?emN0VTUwNVA5c1ZwNDJUSmEvSFQ5SE11WTNxYXJIWUkzV0IyU0d5NVA1RXlx?=
 =?utf-8?B?RnZDaU9GT2xEd2FWaEJINzVMNERhYU1ndUtrZ1pCN2s0MFZPTjNmMnlxMm5u?=
 =?utf-8?B?eVZqWmtWc3ZFME54ZFF2RzBWVm1aeWN4aWd5SlAxTEZLTjlTa2cxT1FmNWln?=
 =?utf-8?B?OUlIbnBRa1lodmVXR3ByakhrVnNTaE5oUys0VjRmT1o2elNYcEd2MXI4ajZZ?=
 =?utf-8?B?ejk2SWlrM2ZQUkFENVI3d2NLeEtUNm9iQzQ4MlJKVFpLRE9oZ1c0WE11T2tv?=
 =?utf-8?B?Mlcycis2NFVHRW5xZnlNYkg2alZma1RLWG1JakJOd3QvSUlJaHdjNVhDSWxj?=
 =?utf-8?B?aVVSYkwweHE0TENWMFRDaEVNRUZYME5YUHNhcG1zbVFRWGo4bE1Fdy93VEx5?=
 =?utf-8?B?YnpNcGZCNlNnK0RuL3BRN0VYeE5CcEVZdWpvSzN0WXI3RTcrUVpYMUhJeTlZ?=
 =?utf-8?B?czVqNUJkVmF0THJ4bFFVUmUzMnBQdmJmSE83aHF2TUFBaGpLcEdBaklDSVBt?=
 =?utf-8?B?UmQ4TE42TExoMWVsWkdWREhoY2J3bVU0SnVQZGRsWXh1MlczL3p1bjhLVEgz?=
 =?utf-8?B?WmN6VENnMjRsZVdhVCtCTlZUTlNFYXlJRTNDQlRFc2UwRkZtRDRhdHNNb3A5?=
 =?utf-8?B?OHdxYUVYTjZyZUNodGc1WGdGajZPTHdtQlA1NTZQZDdHbW9CSk9ieDYzOHha?=
 =?utf-8?B?NEFROERHeFBPNjNtV3V1MmV2ZDhEalBDZ2JsZmRtRFZSbzE5SlJBc24vaXkw?=
 =?utf-8?B?NUE2QkRNc3VSNElrcXN4N254YlRDQVcyRDh1cS9XaVRCNXg1Q2UzR2pxY1o0?=
 =?utf-8?B?VFhIVEtMUmxNOUkwOFVoZWFPYnhkOExVVTllTkZZajlWRkpyd3BDRDJ2MkMv?=
 =?utf-8?B?RDV6ck5wRXdKOWFuMm1PL05XaDRxV3ZnZWVDaVVDanpIK2E2M09WOVcvTm0y?=
 =?utf-8?B?RS9wdkU0Ly9nY3l0WjBGVFNBSkEzdFlvcmljazR6enR0QmpuZzloclN1NlFQ?=
 =?utf-8?B?dStuSmFHRmxiL1Q1K2RFQ0VKaWZpUTdDN1ljUjdjdlJWZC8yZ1JPOHROZHYv?=
 =?utf-8?B?L3c3UFNWaUpmQUxIb1IwV0NmaXlpTitqWjlXZ2lpT1JJc3B2NytSK2l4dUY0?=
 =?utf-8?B?cU5KMzRzeWQ5RHh1UHpGZG9IOG5zN09KRFJmQWdOOXdjbUVuTHk0d0tyb3FZ?=
 =?utf-8?B?YW5BMkd4NHFKVnd4VXJyaU9ST0taLzg4dWJacTA4Q0htOXp3S1BOMUlwQVJq?=
 =?utf-8?B?TnZjOWx3MUNEWEtHM1NTdW5GdDlscnBXRVIrRkw4TzN2K21EYzBiaFVSU2RG?=
 =?utf-8?B?dGQ1Snp3Q2VMdmd0Z1BlWERzaHBST0Q0UlVndkhZUzlabFh1Y005U21odEht?=
 =?utf-8?B?M1owSkFDNlRKZ0RIN1JPSTNQYzBsSnZtUlVvWGExRysycHVTK1RicXB4Z05r?=
 =?utf-8?B?dVlRTTRTNTdOd2ZKNkRLdHRyQW9XeFh3VFpYYXAyeGsvTTA3VXRMWXgvbzRS?=
 =?utf-8?B?Q1pmdm82OUVGdk1hdDV4c3hiaExKbGswcy9OOFcrdDVQUnVKY1pNOE5hekUr?=
 =?utf-8?B?enUzSk96cFIwQWNJbkxZR0VMSmVRM3VpZjlNK3haODFYZzJvY1ZBMWFPQUZX?=
 =?utf-8?B?TzJaM3ZTZjZCRkhRRGUrOXFiWVJVS3djcFRRMXdueFdRblM5QVdnMXhhekxq?=
 =?utf-8?B?MkdRTi9JU0hyV2xkMVgzTHpOeEpYQjhUTlFaNFRhMHNVL1dIREtJQldCMC9q?=
 =?utf-8?B?bWdrV0ZUZW9DSkdoTjJyVFZKRUhRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a2ec3e1-d0fc-43ea-35c3-08d9b591981f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 12:45:17.5763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GyM7i4n2B8G5WfcEhwEjx1OaAud0p1+jTom4mPUqz3/Cr87M7RkwVkImql7Jz7su8EW6wVwxwJpxUXy4cG2ZVah0MQ6zWuWPu+KBrcDQYEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR06MB7267
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBUaHUsICAyIERlYyAyMDIxIDA5OjA1OjI2ICswMTAwDQo+IEhvbGdlciBCcnVuY2sgPGhv
bGdlci5icnVuY2tAaGl0YWNoaWVuZXJneS5jb20+IHdyb3RlOg0KPiANCj4gPiBUaGlzIGNhbiBi
ZSBjb25maWd1cmVkIGZyb20gdGhlIGRldmljZSB0cmVlLiBBZGQgdGhpcyBwcm9wZXJ0eSB0byB0
aGUNCj4gPiBkb2N1bWVudGF0aW9uIGFjY29yZGluZ2x5LiBUaGlzIGlzIGEgcHJvcGVydHkgb2Yg
dGhlIHBvcnQgbm9kZSwgd2hpY2gNCj4gPiBuZWVkcyB0byBiZSBzcGVjaWZpZWQgaW4gbWlsbGl2
b2x0cw0KPiA+DQo+ID4gQ0M6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gPiBDQzog
SmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gPiBDQzogTWFyZWsgQmVow7puIDxr
YWJlbEBrZXJuZWwub3JnPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEhvbGdlciBCcnVuY2sgPGhvbGdl
ci5icnVuY2tAaGl0YWNoaWVuZXJneS5jb20+DQo+ID4gLS0tDQo+ID4gIERvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL21hcnZlbGwudHh0IHwgNSArKysrKw0KPiA+ICAx
IGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvbWFydmVsbC50eHQNCj4gPiBi
L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL21hcnZlbGwudHh0DQo+
ID4gaW5kZXggMjM2M2I0MTI0MTBjLi45MjkyYjZmOTYwZGYgMTAwNjQ0DQo+ID4gLS0tIGEvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvbWFydmVsbC50eHQNCj4gPiAr
KysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tYXJ2ZWxsLnR4
dA0KPiA+IEBAIC00Niw2ICs0NiwxMSBAQCBPcHRpb25hbCBwcm9wZXJ0aWVzOg0KPiA+ICAtIG1k
aW8/ICAgICAgICAgICAgICA6IENvbnRhaW5lciBvZiBQSFlzIGFuZCBkZXZpY2VzIG9uIHRoZSBl
eHRlcm5hbCBNRElPDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgYnVzLiBUaGUgbm9kZSBt
dXN0IGNvbnRhaW5zIGEgY29tcGF0aWJsZSBzdHJpbmcgb2YNCj4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICAibWFydmVsbCxtdjg4ZTZ4eHgtbWRpby1leHRlcm5hbCINCj4gPiArLSBzZXJkZXMt
b3V0cHV0LWFtcGxpdHVkZS1tdjogQ29uZmlndXJlIHRoZSBvdXRwdXQgYW1wbGl0dWRlIG9mIHRo
ZSBzZXJkZXMNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50ZXJmYWNlIGluIG1p
bGxpdm9sdHMuIFRoaXMgb3B0aW9uIGNhbiBiZQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBzZXQgaW4gdGhlIHBvcnRzIG5vZGUgYXMgaXQgaXMgYSBwcm9wZXJ0eSBvZg0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0aGUgcG9ydC4NCj4gPiArICAgIHNlcmRl
cy1vdXRwdXQtYW1wbGl0dWRlLW12ID0gPDIxMD47DQo+IA0KPiBUaGUgc3VmZml4IHNob3VsZCBi
ZSBtaWxsaXZvbHQsIGFzIGNhbiBiZSBzZWVuIGluIG90aGVyIGJpbmRpbmdzLg0KPiANCj4gQWxz
byBJIHRoaW5rIG1heWJlIHVzZSAidHgiIGluc3RlYWQgb2YgIm91dHB1dCI/IEl0IGlzIG1vcmUg
Y29tbW9uIHRvIHJlZmVyZSB0bw0KPiBzZXJkZXMgcGFpcnMgYXMgcngvdHggaW5zdGVhZCBvZiBp
bnB1dC9vdXRwdXQ6DQo+IA0KPiAgIHNlcmRlcy10eC1hbXBsaXR1ZGUtbWlsbGl2b2x0DQo+IA0K
DQpJIGNhbiBjaGFuZ2UgdGhhdC4gVGhlIG5hbWluZyBvdXRwdXQtYW1wbGl0dWRlIHdhcyBjaG9z
ZW4gYmVjYXVzZSB0aGUNCnJlZ2lzdGVyIGluIHRoZSBkYXRhc2hlZXQgaXMgbmFtZWQgICJTR01J
SS9GaWJlck91dHB1dCBBbXBsaXR1ZGUiLg0KSWYgSSBjaGFuZ2UgaXQsICBpdCB3b3VsZCBtYWtl
IHNlbnNlIHRoYXQgSSBhbHNvIHJlbmFtZSB0aGUNCmZ1bmN0aW9uIGFuZCB2YXJpYWJsZSBuYW1l
cyB0byBtYWtlIGl0IGNvbnNpc3RlbnQgSU1ITy4NCg0KQmVzdCByZWdhcmRzDQpIb2xnZXINCg==
