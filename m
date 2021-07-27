Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C483D7260
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 11:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhG0Jwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 05:52:40 -0400
Received: from mail-eopbgr1300128.outbound.protection.outlook.com ([40.107.130.128]:22457
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236037AbhG0Jwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 05:52:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4lENnPDI3ww1q9X38QWJpR+IbYb9beC02AxaERImE4mXN3zOs/XQRNRtxQkmsotn/V9xVmWnJdmQgjdzfWxWyKGMvZAk6y7V2PnLz0stpM/VBEh1dnBaqkYJnqmH1t8UA1nt3omj/8311ROLqln/xFUyxKTbo35WEiBAYAwLi4v2qy4t9gYrsY35TcNxGcM9W1xQO0WQi2ziQZcHfeRN3xlPJ3Mehk08eUy7vTlofbB6aF1ZibUg+kcD7uq0y6PgayaziHMINTlHFyevT5dwb5afy9kObZ9QlFuv4vsONYM0FW4DAZHSa77PxS64Koc3jzFdlGumuAHc3S/jtKl7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpOpKN66RPygdMwd2LcDjZrmOQPGoidwk1hQstWyMQc=;
 b=D4yhN6mhUNHmNBgkzcZZ5IkPWC0jEje4IZxHRTle1pqAISpKQE7XOipLqfyVKStHC1IgBEZiZGdl2y2940pf40VdrSPQ0rvM/qE4n+PFUPf9hqlNEoR1G3Bn2riokRsvvlnmHobuGbPGdxL6/qgUT8SA4rIHyuf68Y2087OfZQf4ol4Fpwh2723IJ5D4lkTrfvYtKQgIRS+Oav5Nsmk9ByaAAT6tYnX6gwhAZ/2B0V+DXyvJ5F0bPjegKsfwUGThFnlXHNWQusyknAxPsecJ/hkLRxwHBzs0j5mcCcQxt5ZzlfQWeXkyGENnBocyZEZRtDNxRerrKxYwQ0yV9yJyNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpOpKN66RPygdMwd2LcDjZrmOQPGoidwk1hQstWyMQc=;
 b=bAmy8Cx7kbGkcEzbo2rcnHcRMLGttRAJod3zkoRFeXjo3obEVci9VClzdOxjHWzbvbEwH8gnx1Luoa/nQX7rDXcNOHA/OoqMZR5VWQ2E7CI44gCcKzdQ6FfWXZEVosKJsTf3swHCcJ1r9n9mHCodU9XrE4u+EtcChYRFUz2ffzY=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TY2PR01MB5241.jpnprd01.prod.outlook.com (2603:1096:404:117::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 09:52:31 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::7db6:310f:a5ed:82f6]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::7db6:310f:a5ed:82f6%3]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 09:52:31 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Ulrich Hecht <uli@fpond.eu>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "sergei.shtylyov@gmail.com" <sergei.shtylyov@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH 1/2] ravb: Fix descriptor counters' conditions
Thread-Topic: [PATCH 1/2] ravb: Fix descriptor counters' conditions
Thread-Index: AQHXgsB5GaHpXVz1002Y3b91ePZ6i6tWhNMAgAAFHoCAAAbxsA==
Date:   Tue, 27 Jul 2021 09:52:31 +0000
Message-ID: <TY2PR01MB3692E21E3D9C4F09D43BF4A2D8E99@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20210727082147.270734-1-yoshihiro.shimoda.uh@renesas.com>
 <20210727082147.270734-2-yoshihiro.shimoda.uh@renesas.com>
 <1879319092.816143.1627376136422@webmail.strato.com>
 <1863500318.822017.1627377235170@webmail.strato.com>
In-Reply-To: <1863500318.822017.1627377235170@webmail.strato.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fpond.eu; dkim=none (message not signed)
 header.d=none;fpond.eu; dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7b82981-67e8-4d11-4636-08d950e440c6
x-ms-traffictypediagnostic: TY2PR01MB5241:
x-microsoft-antispam-prvs: <TY2PR01MB5241A2E7ACE5BD3E978A191ED8E99@TY2PR01MB5241.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 67BuYUyBJ+1CTqgp3KmiR08ig+s3GXhpAzW6zoKhDjHjafHB0pAqioPipanPGkyJWOOnO+TMpxdyTjLNaj80mV4/gQ0l6vGlB9OVSyk6s/Nu72SSMgqIUAEK/htPSYSNJtAygI7kX3xznv1+E9uMMdpuQoLgcl33DIM/Y1wyAOYyQYXYnKaS+5Yti9dnlht1ZxXO0+eMHMhigVgjSSYeKj1DothM/sP2yDT7a+PtY7U996uvISHxkiZ9vDE1BD5PxhQY7UV0NFmMeini18aI2I/3wVhv4e1UP0t2IGRfTKFa/ztFgAaX1ACngqjSz3Izs6Zjdf5zsTwOECobiAlZ0PnA/ENxpB1CermIJ1j2p6d1/KKYyf+hOuU8Sr7YiogXC+yPcptjGGsafjqFhlh1vvOp4dLTgGcs5F04WLWhiWtVnrH0ED0p9LZJGatNSCo1vDZBfO3oeUMVKvHXQkT/fHEsFy6Xde8upM7/IVC9/H85UnGoo/TugyQ+dtVCDIfYc0IgDu1J0ZNGoRJl9k7nAnN/1rkZUf2ASMROqcs7+h+inSNTdtRdtKuzRVB0bSvhMMsrslsbSa2iRt7bJFl/AktB6oUC/dPNHyGxEdrwlGxrA0rjCEEboY9fiQTyBmwGOgimAWpY0DVBfcsSMdTxSKWVwDbbxyecjx4DMP9MJak0GQ7XTSmRvOBkCqsl2hmCyYkl/nc0oWDT10B/mfhqzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(122000001)(478600001)(66476007)(38100700002)(7696005)(52536014)(2906002)(186003)(71200400001)(9686003)(8936002)(55016002)(83380400001)(8676002)(53546011)(5660300002)(54906003)(6916009)(6506007)(33656002)(86362001)(316002)(66556008)(66446008)(64756008)(66946007)(4326008)(76116006)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ellUODhOZlZXQ1BraDRVZGJURlFKMHZKdW1VM3RUWWZXdlliSlZ1QzA5aWNz?=
 =?utf-8?B?S1VHSXBMMGs3RnlqL2hURTFSN0tPSjczWGFnSXoxNFRQOG5NRUlOVDBFT0tY?=
 =?utf-8?B?T1Vha0xxRUl1WEZxMGVnaktwdzRpTlRGempuem5QT3krT085bVNNekpQcFpn?=
 =?utf-8?B?ZnFwRDNuc25kNWNlMFlEVmlESElNNEVaeklZQ244dHRoTTV5K1l4NGRIeVIx?=
 =?utf-8?B?Q0EvcFBxTFdUa3lpLzRaMDFvYjVUOXRNbnJRbXA3bDR3bTlGTmlHSGkwYzNY?=
 =?utf-8?B?VWxWd3lWbGhpbHJmUlNDcGxFbVBleEhtSkZUajBqdncybnZRVlpFaVg1bk1X?=
 =?utf-8?B?enltdGwvVUdzK2RuNTBwYUNwbFFDNlZTY05OTnZHM1ZnRnB4VlFQai9tY0tS?=
 =?utf-8?B?QmJDM3dDVHB5bVNnamorZlBPaGNuWTUyTVVBQzVydzVIK2E4ZnlQWDZHbFQr?=
 =?utf-8?B?SmppQUJVR1JsVlI1M1RJOEpiTlordFVoS0czcW9qWm9sOEpncERnSUd5YzFZ?=
 =?utf-8?B?dzVUN21pb3pYVFViV3NlU3FaQTAzcGVrWUtYTjlHWUNnM0Z4OVpZS1oyZFkw?=
 =?utf-8?B?dDJvR21WRUxieGRHc3IyRHNBNTBseUwvQndvbUtzS0kyQStrTXh6a2hIemJ5?=
 =?utf-8?B?K25kaWd0bU9xMFNYci95djhid0JNSWQzOGZiSm9pTERyTERlTUwxb2JiQks2?=
 =?utf-8?B?RUZ1MkhpS2ZQYk1NZWxCYTl0SnNQd0VRU3ZaTTBlanFIS3pkcDNkNW1wSFJ6?=
 =?utf-8?B?alp6WndabmxRbGRZM1M0MzRFTzl5Q2FYcGxsSVN4RXQxWlFrK2ZQVHhMMHpm?=
 =?utf-8?B?ZzNHa2FGdWFvUERkOWw4OGFkRk9mR1U1VzhlbW96ams3S0hQelhmU0ExdWhr?=
 =?utf-8?B?VVpXRjdweWRSR1Nsc1J3d0VyQ3NMNHFzM1lubVgza2U5Zm1TdkZ0eWg4bnJ5?=
 =?utf-8?B?cFl5UkJCRVVlYjFRVUF2UlliM0xwSEpkMWN3TW81NGFoanlFbHRydnNQemVx?=
 =?utf-8?B?ZVl3Ni9vQ1EvK0lzTU9QblhoZkVlRjlxZGxyenZlbEprZ1dhK3hiZWEwa0U5?=
 =?utf-8?B?MC9NSWRya2F6OXdUSFY0NStZOXViQnJRbFV0RlViWDF4ZHNMTm5hTE1VNUlM?=
 =?utf-8?B?bGJLVzFKTlptYnlDNXV4c215S2hLRStkSnlGZ0E5ZTd2VVJuNm9ld3JxamVs?=
 =?utf-8?B?aTc2c09ma3B5TmJEMzR1TnozK2UyanRqRytwaTVTbjl5MkRRbzluLzhYbitu?=
 =?utf-8?B?WEhVU3pYT3lncHpVYWZsVUV4SHowWllGOUJ4eThEblVqN09KOE5IYnd1MjBu?=
 =?utf-8?B?ZGE5MngxbFNlZnh3SEpoRmpLMXN5SFd6b3BzRkhEYXZRVlVIYzhTTkwxcUtD?=
 =?utf-8?B?TWdtR3F0SjBhT3dycjIwVTFFQ0VxbFlMM1VrM2I0VitxNTRJQ1N3eXJUVlFt?=
 =?utf-8?B?a2tndEdxSlkwM25hb0Z0VXlqdHZzNk0zZzZ0SVFxdTQ5WGFMQ1cxaXZ6MXBt?=
 =?utf-8?B?emJzZFBaVWRMcnY3ZnhXblg0MHBSRmVaMXNYLzcraUZOTVZycU83NkJpYXJY?=
 =?utf-8?B?SmRTVnhlUTFCVnVLL1ptRXpRdlM3YkltRUFkRjdlOHdwR0Q4YzA5TFNWK0Fs?=
 =?utf-8?B?Vysrdkh2ZU9Sd1dMb2xDK0JLM09TelZJUnBrWThsV0R4ZENISUR1VHc5alJS?=
 =?utf-8?B?NHlOVWpNQldBL21VaXQ2NTg1S3Y3a3dGR1l4em9vMGNUVDc1MUplTjFnVHQ2?=
 =?utf-8?B?MnRYeXNZUUVybTVGZlQvdVp1djc4NFEwTEFNc3YzY3hZTW5VL3Ntdmw5eS96?=
 =?utf-8?Q?Dhtn8kV5Q4ibnHeFlEf5pI+hc8XTxWBECAa10=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b82981-67e8-4d11-4636-08d950e440c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2021 09:52:31.7778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HVNnRIWxTSG1uElxvtAkGMt3ytKY0E3yQRUzYcZMVuDjPj3ZZ58U5PwehAH4Zpnja39q3BwUKkiVAQsmZhKcE9LlHqg8MvFVC/1xL96WgT+oCOJnEqV+TIJkrJYzHldR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB5241
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVWxyaWNoLXNhbiwNCg0KPiBGcm9tOiBVbHJpY2ggSGVjaHQsIFNlbnQ6IFR1ZXNkYXksIEp1
bHkgMjcsIDIwMjEgNjoxNCBQTQ0KPiANCj4gPiBPbiAwNy8yNy8yMDIxIDEwOjU1IEFNIFVscmlj
aCBIZWNodCA8dWxpQGZwb25kLmV1PiB3cm90ZToNCj4gPg0KPiA+DQo+ID4gPiBPbiAwNy8yNy8y
MDIxIDEwOjIxIEFNIFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5l
c2FzLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4NCj4gPiA+IFRoZSBkZXNjcmlwdG9yIGNvdW50
ZXJzICh7Y3VyLGRpcnR5fV9bcnRdeCkgYWN0cyBhcyBmcmVlIGNvdW50ZXJzDQo+ID4gPiBzbyB0
aGF0IGNvbmRpdGlvbnMgYXJlIHBvc3NpYmxlIHRvIGJlIGluY29ycmVjdCB3aGVuIGEgbGVmdCB2
YWx1ZQ0KPiA+ID4gd2FzIG92ZXJmbG93ZWQuDQo+ID4gPg0KPiA+ID4gU28sIGZvciBleGFtcGxl
LCByYXZiX3R4X2ZyZWUoKSBjb3VsZCBub3QgZnJlZSBhbnkgZGVzY3JpcHRvcnMNCj4gPiA+IGJl
Y2F1c2UgdGhlIGZvbGxvd2luZyBjb25kaXRpb24gd2FzIGNoZWNrZWQgYXMgYSBzaWduZWQgdmFs
dWUsDQo+ID4gPiBhbmQgdGhlbiAiTkVUREVWIFdBVENIRE9HIiBoYXBwZW5lZDoNCj4gPiA+DQo+
ID4gPiAgICAgZm9yICg7IHByaXYtPmN1cl90eFtxXSAtIHByaXYtPmRpcnR5X3R4W3FdID4gMDsg
cHJpdi0+ZGlydHlfdHhbcV0rKykgew0KPiA+ID4NCj4gPiA+IFRvIGZpeCB0aGUgaXNzdWUsIGFk
ZCBnZXRfbnVtX2Rlc2MoKSB0byBjYWxjdWxhdGUgbnVtYmVycyBvZg0KPiA+ID4gcmVtYWluaW5n
IGRlc2NyaXB0b3JzLg0KPiA+ID4NCj4gPiA+IEZpeGVzOiBjMTU2NjMzZjEzNTMgKCJSZW5lc2Fz
IEV0aGVybmV0IEFWQiBkcml2ZXIgcHJvcGVyIikNCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFlvc2hp
aGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT4NCj4gPiA+IC0t
LQ0KPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCAyMiAr
KysrKysrKysrKysrKystLS0tLS0tDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlv
bnMoKyksIDcgZGVsZXRpb25zKC0pDQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiBpbmRleCA4MDUzOTcwODg4NTAuLjcwZmJhYzU3MjAz
NiAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9t
YWluLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMNCj4gPiA+IEBAIC0xNzIsNiArMTcyLDE0IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbWRpb2Ji
X29wcyBiYl9vcHMgPSB7DQo+ID4gPiAgCS5nZXRfbWRpb19kYXRhID0gcmF2Yl9nZXRfbWRpb19k
YXRhLA0KPiA+ID4gIH07DQo+ID4gPg0KPiA+ID4gK3N0YXRpYyB1MzIgZ2V0X251bV9kZXNjKHUz
MiBmcm9tLCB1MzIgc3VidHJhY3QpDQo+ID4gPiArew0KPiA+ID4gKwlpZiAoZnJvbSA+PSBzdWJ0
cmFjdCkNCj4gPiA+ICsJCXJldHVybiBmcm9tIC0gc3VidHJhY3Q7DQo+ID4gPiArDQo+ID4gPiAr
CXJldHVybiBVMzJfTUFYIC0gc3VidHJhY3QgKyAxICsgZnJvbTsNCj4gPiA+ICt9DQo+ID4NCj4g
PiBUaGlzIGlzIGEgdmVyeSByb3VuZGFib3V0IHdheSB0byBpbXBsZW1lbnQgYW4gdW5zaWduZWQg
c3VidHJhY3Rpb24uIDopDQoNCkkgYWdyZWUgOikgSG93ZXZlci4uLg0KDQo+ID4gSSB0aGluayBp
dCB3b3VsZCBtYWtlIG1vcmUgc2Vuc2UgdG8gc2ltcGx5IHJldHVybiAwIGlmICJzdWJ0cmFjdCIg
aXMgbGFyZ2VyIHRoYW4gImZyb20iLg0KPiA+IChMaWtld2lzZSBmb3Igc2hfZXRoKS4NCj4gDQo+
IC4uLmFuZCB0aGUgdGVzdHMgZm9yICI+IDAiIHNob3VsZCBiZSByZXdyaXR0ZW4gYXMgIiE9IDAi
LiBTb3JyeSwgbm90IGZ1bGx5IGF3YWtlIHlldC4NCg0Kc3VjaCBhIGNoYW5nZSBjb3VsZCBub3Qg
Zml4IHRoZSBpc3N1ZSwgSUlVQy4NCg0KY3VyX3R4ICAgPSAweDAwMDAwMDAwDQpkaXJ0eV90eCA9
IDB4ZmZmZmZmZmYgDQoNCkluIHRoYXQgY2FzZSwgbnVtYmVycyBvZiByZW1haW5pbmcgZGVzY3Jp
cHRvcnMgaXMgMS4gU28sIHRoZSBwYXRjaCBjYW4gcmV0dXJuIDEuDQpIb3dldmVyLCBpZiB0aGUg
ZnVuY3Rpb24gcmV0dXJuIDAsIHRoaXMgY291bGQgbm90IGZpeCB0aGUgaXNzdWUgYmVjYXVzZQ0K
dGhlIGNvZGUgY291bGQgbm90IHJ1biBpbnRvIHRoZSBmb3Igc3RhdGVtZW50Lg0KLS0tDQorCWZv
ciAoOyBnZXRfbnVtX2Rlc2MocHJpdi0+Y3VyX3R4W3FdLCBwcml2LT5kaXJ0eV90eFtxXSkgIT0g
MDsgcHJpdi0+ZGlydHlfdHhbcV0rKykgew0KIAkJYm9vbCB0eGVkOw0KIA0KIAkJZW50cnkgPSBw
cml2LT5kaXJ0eV90eFtxXSAlIChwcml2LT5udW1fdHhfcmluZ1txXSAqDQotLS0NCg0KSSBndWVz
cyByZXR1cm5pbmcgMSBpbnN0ZWFkIGlzIHBvc3NpYmxlIHRvIGJlIHNpbXBsZS4gQnV0LCB0aGUg
Zm9sbG93aW5nIGNvbmRpdGlvbiByZXF1aXJlcw0KYWN0dWFsIG51bWJlcnMgb2YgZGVzY3JpcHRv
cnMgc28gdGhhdCB0aGUgY3VycmVudCBwYXRjaCBpcyBiZXR0ZXIsIEkgYmVsaWV2ZS4uLg0KLS0t
DQorCWlmIChnZXRfbnVtX2Rlc2MocHJpdi0+Y3VyX3R4W3FdLCBwcml2LT5kaXJ0eV90eFtxXSkg
Pg0KKwkgICAgKHByaXYtPm51bV90eF9yaW5nW3FdIC0gMSkgKiBudW1fdHhfZGVzYykgew0KIAkJ
bmV0aWZfZXJyKHByaXYsIHR4X3F1ZXVlZCwgbmRldiwNCiAJCQkgICJzdGlsbCB0cmFuc21pdHRp
bmcgd2l0aCB0aGUgZnVsbCByaW5nIVxuIik7DQogCQluZXRpZl9zdG9wX3N1YnF1ZXVlKG5kZXYs
IHEpOw0KLS0tDQoNCkJlc3QgcmVnYXJkcywNCllvc2hpaGlybyBTaGltb2RhDQoNCg==
