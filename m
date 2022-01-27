Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF5649D796
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbiA0Boy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:44:54 -0500
Received: from mail-dm6nam11on2113.outbound.protection.outlook.com ([40.107.223.113]:37056
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229816AbiA0Boy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 20:44:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fai5aOuUitxWxXr138MC3tjUTR/IObR3d01rhux/OCmeiudUAgmg/+WZzvyqEXFx4T6Ye6Kx4mwurNNZLJSsVOndsP1UOwh0S1HNb4MutFj5OAReBwB69KOvliCZcuC/tItO2npX9zIvU4h8cw1FkgvM9XVIwQZT5Y0srxDkD6OthTEyJ8822b5RBzXMoHMWYhRc8/HWrqzPgNd3JvZlURP3evwhkeg9xQCOzONXc6z9i8BNT9mVNr0sxW68I4iRf6x2Bm13x6J9Rtb+U8gpxwCaoN8Sn6cABFPpqLFJUBjITIIzilIHzkXCeXhGy5pZ3sRPyC5vBmuOotdfyH5sgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtkk6zTchlmH1RqyxLYrhGvZSdnWL/Da0d3oQ1t2V/Q=;
 b=IjUqJGDt1ReZLBWjrxBFsVcxp2gCnmggD7tUW8rxQMMZzVDjDsOUdAv7k1SvGqtcZMT82nZzN/eTUn7Cs7IgpvxQ1BeY3mz+JMGPn1tKSbB1c0jxstCETee1ELLixLO/hvEYX9xK3e3ZOdyqAVupK3wu/1gT7vbjY0vQqNKxp62RSThUBmRxdy7aoMSWBkSDIMSQiusAu+6UMa1X/qxXMPY9jGJHSeZCfVGx8boi2tsiEkKEybejX/OUXGth583Rw2oL5WqrDkfBcZukDTN8W3/me8ertb+E3RTPUeqDxbI/SDJeRF1hQZ9MYrRUj4C9hFHXtcnpdK4Ec+5lOm+Ftw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtkk6zTchlmH1RqyxLYrhGvZSdnWL/Da0d3oQ1t2V/Q=;
 b=PrO+3UYYDfpksao3sXjbGPS4aSU3nhUftyqnoURWGVuDGI69MRu18HBpjrrgEZfnFG+pOZqspIMnKu6Uq23k7bNUhMSFF2eVTuvfC9GsyQJehHIVYf4dIS58rr96ET/kvlpZMN8UEeTCZC0r93xrndoVywChgqZQnASuwE3Z1H4=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by BY5PR13MB3395.namprd13.prod.outlook.com (2603:10b6:a03:1ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.5; Thu, 27 Jan
 2022 01:44:51 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::29e9:10e2:c954:f2b7]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::29e9:10e2:c954:f2b7%4]) with mapi id 15.20.4951.005; Thu, 27 Jan 2022
 01:44:51 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
CC:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH iproute2-next v1] tc: add skip_hw and skip_sw to control
 action offload
Thread-Topic: [PATCH iproute2-next v1] tc: add skip_hw and skip_sw to control
 action offload
Thread-Index: AQHYEdZABEDAaGD/KEG9Gakr7ffzE6xz2x0AgADnMXCAAHHSAIAA44GQ
Date:   Thu, 27 Jan 2022 01:44:51 +0000
Message-ID: <DM5PR1301MB2172E004C84738F8ACD946A9E7219@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <1643106363-20246-1-git-send-email-baowen.zheng@corigine.com>
 <CA+NMeC_BK65Oej=tL0ooyBhhEk6wK73HOaV5LR3QQkzXpbzNgQ@mail.gmail.com>
 <CY4PR1301MB2167AFCA2EC627B6789BFB6DE7209@CY4PR1301MB2167.namprd13.prod.outlook.com>
 <450375bd-6985-202c-7ad2-c11c97fe5b0c@mojatatu.com>
In-Reply-To: <450375bd-6985-202c-7ad2-c11c97fe5b0c@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1654bdfd-84a3-4bdd-e39f-08d9e1369c32
x-ms-traffictypediagnostic: BY5PR13MB3395:EE_
x-microsoft-antispam-prvs: <BY5PR13MB3395B8DA088497102BFA25FBE7219@BY5PR13MB3395.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZLXI2Q13up7xEF12em0D4xQcENZ57AEbdtQ52ZhOfR16VhwxzPMRz7YfYPndsuxGbn7v3n80bb1eZpamraq1HBO/tvhKjSgUZ1/1xtF6kA6DPBhNFUm54GfFXQIuvgBlqV2R56MZ056tanFq8agvrffBtJqmlYz0UioB9cJWNVas+NNo84l6sQgP4pynedsWJyOOOz4RnYsNoT3hjnkj76ERqOAvvRZXgiei+HPYIXnb1I/4FIVl8KpMBjefW36EKkowgW1bY6aqlNdurLlCi0XtGiPxPCSajVryg/U+FWxMRpGnf8/+NlvkdpnCiwFKbarGD+NqDGIg7OT7o0hAOmksUwfaUkC9YKRiXHoYHpbH6PCYSsMu23SH7J/plEdFS/wyk65cNHQD8xy6WCXebXyp977ufMe8p0w8rz3YYx4oBn10IWkLI7+K+FKaZis4HSO2YNJzf8hokP+migh8XUNjHUPHd21IMQubSawgBZ2FKfwTHe05RgZzUU+rTKyrK3WG5yz/yjmuAgxUvvnjBpqHR6MO9BWLEDKvE6zxaZOS+z3goQ6FYw/KQa7Y6Xe3RipWFHZtRPlaBOoTTxu2M3ZMarXWRziGCv034otwsNXp4El/A8dkOfr2Sgd0Igg8zyi6npiWuUp0sohIrIaVF5NxEg9Vlc5hUJJoOCnmBQXi9KtvwgrsjnQHyQP5yvv8JlA6y8YxfK4zVZsnzzlWAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(346002)(136003)(366004)(376002)(52536014)(7696005)(6506007)(38100700002)(110136005)(9686003)(122000001)(316002)(54906003)(107886003)(53546011)(44832011)(5660300002)(4744005)(71200400001)(66946007)(64756008)(508600001)(4326008)(86362001)(83380400001)(186003)(26005)(33656002)(76116006)(38070700005)(55016003)(66446008)(66476007)(66556008)(8676002)(8936002)(2906002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QW94RkRLZUJZclJCVGhMZ1ZCYmFqcUtMUkJVVnU2NHppc2ZqV0tldU5rRDZU?=
 =?utf-8?B?M2lHZER2OFlsUFhVT2dBNjVmVTY1dm1pT1NFRjNmWW1qZGQzVUFNZFNBQ0pC?=
 =?utf-8?B?SkhFend4OHZHS0dZa2l2Qk1aYzBDMkFjSkVZUnpsT3k3WDlCc24wUkxQMExV?=
 =?utf-8?B?NjVGZGZocVMrUmxudDYzM0pZSHNhbVU3RjYxeHpkM0pOdnE3elRRWHNRRUEy?=
 =?utf-8?B?eEtoelBCQzcxUzB5SHFLR01leTc4M2xYNE12cERYSFc5Vld0bVlLTElIUllR?=
 =?utf-8?B?ZHJjQmRMZUxhYTdDUW82MVF3ck10ZDViRncvSDdvZlMwTkVjUkU3UkVsdUZj?=
 =?utf-8?B?MG82SDI5N1FqUHBpRlRZYlovUU5kNldDb1pHcGdidmx2RlhlemtFcWhxb0U1?=
 =?utf-8?B?bmp3ajlTMFBYKzFUS0lKSWEvMCtHcFpQT0xDT0Rjbm1jem05N1k1WVZMS1o5?=
 =?utf-8?B?QzVqYkxDRHBROUhPZXNUbHh5eXFGRkwwbzhuWVhDTzNHdmFMRWswY09Yd05B?=
 =?utf-8?B?TURHVVJBem1ONkhodkNCc1FVWGp0QnZoM2FUaFRJOWZmTmlmUWVCeXdpRG1I?=
 =?utf-8?B?WnBTdmd6NGh6dXJ6Y2YzR2drSTlpVlZpK2UyUTdDbi9FMjEvc05LSjVla1dI?=
 =?utf-8?B?QSsrVExnQlRCcE9ycStvVnM4TlFIQ2l3MjNSemNleVRUTFlUNy93eklwS2NQ?=
 =?utf-8?B?cTVEd0dsbG9hUmkyWEdQb1IzRll1WER2bkxCZnpPQVBKUGpScDBNYWJCU1ZS?=
 =?utf-8?B?RVNSSndFaGFhVFhmaEJFY2xYekF1VzdlbUpzbGtycjNqblNEU3F4UVF1anFn?=
 =?utf-8?B?aTRGOVlrTUt0dzI1WjN3SFIrSE80NnJORXNXZVJGdmdwYmVrbktvb2Y3TEpx?=
 =?utf-8?B?TFdHeTF6S0s1ZE1Uak1uTndnRTlGcjJMcEw5YUNrM0d0SW9IZSt3WTBtYTJO?=
 =?utf-8?B?ekkxcnRmKzIwcStBRW02L1p0dHg1YjU2bjBpTWNGMjFsb0Z4YllWLzRTTkxk?=
 =?utf-8?B?UEtZcTJHUWpFbDZZdmtMSWxhL0Z6U1dINlNlckZiNjAxZmxZYStyckZXcGpD?=
 =?utf-8?B?NjM0UUthY1RlRi8rcEFEY1NreTlLM3BReFZEV0h5R3JQWUwzY3JPbUdDMUZU?=
 =?utf-8?B?b0FJbWhoaE1VWUsyWGdUenlSTllCeXl2V0pBblFrZStLTzRrYUlGQlBpUEhs?=
 =?utf-8?B?ejJGanZSQmtrRitVRVZOTm4wb0tFN2RIUE5xU1FKWEtIa2ZxRUM1M1J5WHZm?=
 =?utf-8?B?dkNVOU02c1EzV2tKaVZKOGhaM0k0dlpYNzBzKytIbkJaUEtNOC95bEdxbHZS?=
 =?utf-8?B?MXcwNnZiYTU4WFdxTVkydisvSDQvdTArZ3ErcWkwVHd4RG5DNERUNHJwSXNR?=
 =?utf-8?B?dWx6Q2RCZGs3ODcrM3N4dkVjOFpBd21FMHFxbTZsMjZpU0huVlhGQ25GNFNW?=
 =?utf-8?B?ak03QUE2akFDMlRyM1NBbSs4QmQwUENwYk5aWExVL0xUNWJtNWIrSGVodUtz?=
 =?utf-8?B?TmVSS3B2TUhhS3hFTjM4RmVYcC9yOUR2VWtkZXpFcGZTM2hPOE9rcmxacHlS?=
 =?utf-8?B?c1dMZGZ4SmxXQWJPWmwvMmR4ckJVOXRTTS9IcDVwbXVaRWoyaGVYcWFOOCtR?=
 =?utf-8?B?bjRKaDUvU2dlTVpkV1lKR3ZneTlRcGdTSFVSKzFHMk9oaGpROW1ZT1IrQTMz?=
 =?utf-8?B?OVo2bTlXaXBJMzNQSzlzdWdtQWNoc3c5UUdpdTd2eVByYUphbm1BcTBTN1JK?=
 =?utf-8?B?UnNWREZFSFJKR0xVL2V1akI4N3haRUN6RjUyeVRVdEk5NDV1TFBRT0xIQllk?=
 =?utf-8?B?TlZHSkZVbnlIN1ZGMGozQVFHUnRLUU5WRXNpQ3I5aTluMDh1cUNVbjNnaGVX?=
 =?utf-8?B?dmw4M05SU3k5bEdSUk13b01rTHF6SE1VU0MxV2JzQjYrNDZYakJoMHUyc0FS?=
 =?utf-8?B?cFZhU3AvaWZ5WWxjOWEyTjIxMkVjeks5WWlwQ09PZnFJd256NHJxNGUxUVh2?=
 =?utf-8?B?Z2lVcGhpaWliZlFSM05oajVkSUdTVkVhdzdxMzFHSmpScThvTHZBVk9Ob2NI?=
 =?utf-8?B?Yytpa0R0TGV1ckx3SWx1TjJ6aThuSzZGNHJSS2RPVElTQkpkK01ONll3R2g4?=
 =?utf-8?B?Y0JFdXgyeTY0WWd0SmVXWHBxRHdNYytqNUlINm9Ed0U3OFd2Q2RmLzVETEVu?=
 =?utf-8?B?eFpBYnRDbVRiYm90MkY0M0V4eVFXZGtiN1ZMUjhYOWJraEUraERzWlpSYVZO?=
 =?utf-8?B?SnZEcStpNVAwNDd4YTg0TlN1ajZRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1654bdfd-84a3-4bdd-e39f-08d9e1369c32
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 01:44:51.4075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aP3FA6a0V5A1nG5I2J1x+0+gjnCREdm0SsYcbyXfgBvsFdpjTMXFhdBc3N+Rd3rRP7ARCUenDDYYCO9gMIMoSNLS+ewx91KXyGCRXVbZc9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3395
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFtYWwsIA0KU29ycnkgSSBkaWQgbWFrZSBteXNlbGYgY2xlYXIsIEkgbWVhbiBvdXIgVjIg
cGF0Y2ggd2lsbCBmaXggdGhlIHZsYW4gYnJlYWthZ2UgaXNzdWUsIEkgc2hvdWxkIHNlbmQgdGhp
cyBtYWlsIGJlZm9yZSBJIHNlbmQgdGhlIFYyIHBhdGNoLiANClRoYW5rcyBmb3IgY2xhcmlmaWNh
dGlvbiBhYm91dCB0aGUgcnVsZSwgSSBydW4gdGhlIHRkYyB0ZXN0IGJlZm9yZSB0aGUgVjIgcGF0
Y2ggdG8gYmUgc2VudC4gDQoNCk9uIFdlZG5lc2RheSwgSmFudWFyeSAyNiwgMjAyMiA3OjU4IFBN
LCBKYW1hbDoNCj5IaSBCYW93ZW4sDQo+SSBkaWRudCBmb2xsb3cgd2hhdCAibmV4dCBwYXRjaCIg
bWVhbnMgYmVjYXVzZSBqdXN0IHByaW9yIHRvIHRoaXMgZW1haWwgeW91DQo+c2VudCBhIHYyLg0K
Pg0KPkFzIGEgZ2VuZXJhbCBydWxlOg0KPllvdSBoYXZlIHRvIHJ1biB0aGUgdGRjIHRlc3RzIGFu
ZCBpZiB5b3VyIGlwcm91dGUyIHBhdGNoIGlzIGJyZWFraW5nIHNvbWV0aGluZw0KPnRoYXQgd2Fz
IHdvcmtpbmcgZmluZSBiZWZvcmUgeW91ciBwYXRjaCB0aGVuIGl0IG5lZWRzIHRvIGJlIGZpeGVk
IGZpcnN0Lg0KPlBlcmhhcHMgdGhhdHMgd2hhdCB5b3UgbWVhbnQgaXMgeW91ciB2MiBmaXhlcyB0
aGUgdmxhbiBicmVha2FnZS4NCj4NCj5jaGVlcnMsDQo+amFtYWwNCj4NCj5PbiAyMDIyLTAxLTI2
IDAzOjE0LCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+PiBIaSBWaWN0b3IsIHRoYW5rcyB2ZXJ5IG11
Y2ggdG8gYnJpbmcgdGhpcyBpc3N1ZSB0byB1cywgd2Ugd2lsbCBtYWtlIGEgY2hlY2sNCj5hbmQg
Zml4IHRoaXMgaXNzdWUgaW4gbmV4dCBwYXRjaC4NCj4+DQo+PiBPbiBUdWVzZGF5LCBKYW51YXJ5
IDI1LCAyMDIyIDExOjIzIFBNLCBWaWN0b3Igd3JvdGU6DQo+Pj4gSGkgQmFvd2VuLA0KPj4+DQo+
Pj4gSSBhcHBsaWVkIHlvdXIgcGF0Y2gsIHJhbiB0ZGMuc2ggYW5kIGluIHBhcnRpY3VsYXIgdGhl
IHZsYW4gdGVzdHMgYnJva2UuDQo+Pj4NCj4+PiBjaGVlcnMsDQo+Pj4gVmljdG9yDQo=
