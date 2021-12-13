Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677EC472158
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 08:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhLMHJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 02:09:10 -0500
Received: from mail-eopbgr10085.outbound.protection.outlook.com ([40.107.1.85]:22594
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231133AbhLMHJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 02:09:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8tMoKveRAJqKGPOWay5D8aLEGcX/0QkCoZ3Mj2ZwnT6hUfBWX32085VvOkcIllxp17OjcY63qtKReN9MnY6QpGjgacC69OG4wS9DomSaawEKHQQFZlg1h74vjVmSDhGNqbtvap/xtmhAB4TweA9q8W3/SN50As/pbvJ8kD4Klq3ToW6eYbpsctgu+w7PSmg0IsN8Ij+IZMiNqxtZGBtXFHF/b1U6aOe+w9k9ssrssx/CgdGuPYJYkRzHjsjFBn6ReT9pYLt7DL+NV8iEGzWWdIKm1gP+1+fT8Akl9pUQJkxZvAvc3RGNHsa8DbVaSkB6YJrlvxav4xpYGwZRUYpKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3FW/QaVhGsfGrZbyULkvFn7OWU4f/45xb7rQnjYYdjA=;
 b=NygzwKHgFyL/uoezYvIvGPaDiXdBNVnRD+NX+EGy3he9lJoD4zVZtT+TMu52/ac5shZTIyRFnGpMLJPVY1renFP4aiVH2W4g19sTtfJymiCjRx/M5eP+jIyydA+xZXElpcYrewTQZBQfUHTb2hcv5Nosm6cgetMZJN1/2Cg8pydL/J7BJ4xOjLjImjrkuvxa1/ChiHUZppXPmE7IfNV+c0Oj1r/Agkx+jiEICFRpfQ2KYW/GWbLTPgAC/Mcn45e9wVdJcmVOL6uQ4m0O8MNunESQ12oNwTxxVWpRo6agWZoopEhS8QhweUuG7qmtuFAHHK8QYVfSfvqDw8alMLKyyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FW/QaVhGsfGrZbyULkvFn7OWU4f/45xb7rQnjYYdjA=;
 b=es+788+nBYH0CGJZBcjxcQ1QRmVugwVKen3rclhBk9DXVj5onK1oDd/eUoBMOcBhBFPRUFnTlGpvtsfIyGbDVdnfYe9uFLOPqaaU2JnRoeELtLic/s95klBIhNYZUr2RaKFahfmdukZdSmMO5eCAgnSDxsRHu7xzZ5EM3WUkk/M=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7432.eurprd04.prod.outlook.com (2603:10a6:10:1a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Mon, 13 Dec
 2021 07:09:07 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 07:09:07 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "Yannick Vignon (OSS)" <yannick.vignon@oss.nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
CC:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: RE: [RFC net-next 2/4] net: stmmac: move to threaded IRQ
Thread-Topic: [RFC net-next 2/4] net: stmmac: move to threaded IRQ
Thread-Index: AQHX7gARe8XhFI6pgECMhOT5xAvRj6wwA3EA
Date:   Mon, 13 Dec 2021 07:09:06 +0000
Message-ID: <DB8PR04MB67950EE6E54896BD84EF8CE2E6749@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20211210193556.1349090-1-yannick.vignon@oss.nxp.com>
 <20211210193556.1349090-3-yannick.vignon@oss.nxp.com>
In-Reply-To: <20211210193556.1349090-3-yannick.vignon@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55bbd885-ed1c-47fd-ded2-08d9be077410
x-ms-traffictypediagnostic: DBAPR04MB7432:EE_
x-microsoft-antispam-prvs: <DBAPR04MB7432EAAD15C1EDC13C6FB577E6749@DBAPR04MB7432.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OtrX7NgYaz1P8RufJgPty74eu2Ncq51C7HMgXieDtrNP30iWhzMPEbnjhm6qh0Bu7UIs7cB3EQaJmO8SWRNYrxjTk7v/Jlvs9tV3TSxodHWal5QsvHQ3ffzssNl4f4WLjyELUENXlj4aJOvv4gJLnZmbbvbzoZg7/ThjtXedUVNTFvldH3yiz+eZCbb2F0E1t3v8XLUXm2As/bBdKrHFvBGhh8/u8C4IhJD9vFwFWIQtbrMD6qxRnKDuIgkz3phfUB3GHu+YlKyCpQJHCtj2z04cK8mN6986NxDc5IvQMylij2zBzF707/rU0VlXVa9GraCsz1MJB7hqdyFNmHmP66170DQ549VoGHsKytNLU7uKEsTizMu7LoAFzoJ6Zrsl8djs2XOx+cpq+jcgW99uqfNR5qOqOqIktiPNI/fWILthEBiRtHevx4BA6rkF9/xwICJ8tJrbhxAclHuIWgursqTak9pgz749M7cP31wmney7lv4RsUcDyV3FnHrc0mQ296lLUyHzd9tjXxZMPV2KmkFCIZRZkEf9IId48UIEJhZbs9sAciw7JcrDaUaMnC8Rb0+md4Ts+j4q+dxVVal1XqOgXkzMNUWKN9H7UiR8vj2jKuDWHOerKqNs4kSz855+uYAehnHIX0wC5F8Im/7yDuQ1pccj9REdE10Ektl8scxxfANBLUpHJiWUJaB1NIBEgTPxrtWyrSknfGFAEXgjotN7LJ82sSaV+UJ4O2aQzfA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(7696005)(8936002)(76116006)(2906002)(186003)(7416002)(66446008)(5660300002)(86362001)(66946007)(508600001)(8676002)(6506007)(4326008)(53546011)(66476007)(52536014)(26005)(6636002)(66556008)(83380400001)(921005)(9686003)(71200400001)(55016003)(38100700002)(33656002)(122000001)(110136005)(64756008)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Smp6c3c3MFp5VWFNdFJ5OW9CNFBKNkljcStDR1FPUjBjSVZVaGxaa1dHRXh3?=
 =?gb2312?B?TUl3a0NzbnJ4Mmk4Tm8vc0FxZjk3djJzUHlXdjRBNHFuc0RxcHMzZjhNMFg3?=
 =?gb2312?B?MUlvRnFYWDFyQS9SNHA5UmVzR0UySVZNTkVTQ25XWXVhaEM5NEx6ZW5nb2wv?=
 =?gb2312?B?NjBhVzhnODgvMGtCUCt5cjZBYXdHcUhXOVNvWllKZWxKVnpSMUR3ZkZxY2dS?=
 =?gb2312?B?Q2VIelVXWXd4cUZ3VVRMTHRBQnJ5Yk1IeGZFZ0xoU0dDd0lBSGlVQVlUVFBl?=
 =?gb2312?B?NDlQeE1Rc0dDNzhVWTJvRkJiOVRoWXpFL1JOVHE2YTVFRmN5ellUMXBHaTM2?=
 =?gb2312?B?MURWMUlldTQrNDdzWEhPQWZhaEphN0tnd3BLQ0FUVHVMV2tXM2MyWUZFK0FP?=
 =?gb2312?B?YzkwT0JiSVBmdFVydUNDTi83L0R6ZVBnVkVnZXBZb1RkaHorcDllbmppUml3?=
 =?gb2312?B?VkxwQ1hia2k2SjhJMEJ3eDFTZHlReHlHTlZqOWhxdURpL2plaWxycE9iTXo5?=
 =?gb2312?B?QWc3VXYzcnFDR1VRdURLamswdHljRnByaXM5RW9jSXlFbklKTVo5TDBHZ2gw?=
 =?gb2312?B?UVYzWGlwdXBmWmt6Y3BYY093NUNGaHk3WGFqdGFmUjlpY0RRVDJEaXZsWGUx?=
 =?gb2312?B?dTg3ek5aY2NURXJHTDlwWG9PVkZjOTlKNDFjSlhPd2c5dkdRU2F1UGkxbHNB?=
 =?gb2312?B?RE00NlVxVnI1bHF0dWVoQVBiR1pBbkswVkRKN0ZRWGVWM2NadzlvTGVqTzJF?=
 =?gb2312?B?eVNLSlJ5RTF0OUJVSlRMeGZ6SWQ4dmh5aksyTytraHA0c0dkRkxGWXN6aVJS?=
 =?gb2312?B?Z0Z3cTBEVlhDTEo2WlNNSmNReGl4bUJUR09kbEMvVEh5Mk90WUk5ODlsdjBH?=
 =?gb2312?B?THJpSENmcmxTYkN2OGVTeUFacFVqZlFSV3RGVitCM3h1bWRObC9ocW4ybC9K?=
 =?gb2312?B?NWNDc25paGhpVUZzVHc4b0pJNzM0TEl6bUUzTmlMVEZNOTBjd3RaNlNpR3E5?=
 =?gb2312?B?alZrN0pVL0xmMmpMMWRQdThkSWV2ZmpsNGs3MHExZWVoR1A3WE9uRVFMaFN6?=
 =?gb2312?B?c3pMTXRRRllEb0cyc0UrcmJLdFhJMUhYa1pPSlF1Ri8xenF5cnpSb3pGc1ZN?=
 =?gb2312?B?RGY5YUdXMkxkWHZ4T0duRXBUTUhaZDlRVTk2NHhnY0xoRG1iZnlSYXliZS9W?=
 =?gb2312?B?c0tZQm9KL1dhWW40Z1MzcVRUZm9wU0JKMDdKWUduQm9Qczl2STBFU0hISmFE?=
 =?gb2312?B?QjduVWdqRmR5cWFRVHhHVjZDNkdyYmlEb1ZRR1BXb1pvSGQ2Q2tXVnAwcDRp?=
 =?gb2312?B?U2FmUjJiMnVnQmJvaWp1ZEx0SFgxQ2g1dmM2Mk1wdGxuRnZEMkY5TEo5emZG?=
 =?gb2312?B?QUZUd283MjkzaC9Hd0ozVmo5dmVLZnlMUGtFZU1iajhwaXFPM21xNTZUcGhi?=
 =?gb2312?B?Mks5VXpkN2p0TXhBemVDYzA3LzkrSUpCNDZLcFdjazl0S2V3TWZ2bkh4aGtC?=
 =?gb2312?B?QTBEdFg3VTNpblFPYlE0eGVWTVo5SkNuaE93YzhqNW5ZUC9MZjR4QndsUC9P?=
 =?gb2312?B?ck1lakFVSmx4NlpYdHR6V2c5NlV2SjZyZzRBT3J2elRMaHhDS2wvTW4wUzA1?=
 =?gb2312?B?VkFwMVhCWDNYK0NpNVdvQ1RSSkNPbXRFNEZsdzgzVnl2LzNYc2xVYjQ5NGwx?=
 =?gb2312?B?b2Z0YUJvSzlFczFrTVErQTlKaVpRNEsyTVU2azdGWlQyNk5oMlE5UlAvdjAr?=
 =?gb2312?B?WVkzeVp3NEpsNy9nTVpjZ0VrRWcvbWJLczRVamtCS3pvcTQrR3lRb3pjNVU1?=
 =?gb2312?B?VVdhZ1QwSmNpWHJ4VVFDaVg1dXBMMEhFdlgrRkRCN2pSVmtMRExIN2Z4Mldz?=
 =?gb2312?B?N1llV3BOQkVNQWFvbzZLa3RkNWZIeUNPVys1QjR1Sm1aMDZHRXV6cmo0VUR6?=
 =?gb2312?B?VWU2ZHlhTjI3UHRSTHdtNUl4MXFFcFd5NDlVYUVVR3VXbjdiSXY1UEw3Y2VR?=
 =?gb2312?B?WFFmbU5JYjNOY2NueDdNYTFBYlZFRG1FeE05VEpua3Z0T1VXTVgzWDVXZnl6?=
 =?gb2312?B?YVZ1SFZYUVFuVlBCZzl6VndrOXJ1NWNoMlZlbys1QnNheStub24rSnE0TTVi?=
 =?gb2312?B?NC9UcWZrTkhYcUZnT2E3OXpXOHA4eURFMFNMOW5hMzRjM2JoVnYrV3FhaTRt?=
 =?gb2312?B?Qmc9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55bbd885-ed1c-47fd-ded2-08d9be077410
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 07:09:06.8647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IlNyeg1A8JBAutRQ0OhvpZAXQEeKDgb+WTt4iq2/9lgCGKVTj7qEtAW4ZwnMc9cxij2kQd0D7HC3sbNDGaI7fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBZYW5uaWNrLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFlh
bm5pY2sgVmlnbm9uIChPU1MpIDx5YW5uaWNrLnZpZ25vbkBvc3MubnhwLmNvbT4NCj4gU2VudDog
MjAyMcTqMTLUwjExyNUgMzozNg0KPiBUbzogR2l1c2VwcGUgQ2F2YWxsYXJvIDxwZXBwZS5jYXZh
bGxhcm9Ac3QuY29tPjsgQWxleGFuZHJlIFRvcmd1ZQ0KPiA8YWxleGFuZHJlLnRvcmd1ZUBzdC5j
b20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBPbmcgQm9vbiBMZW9uZw0KPiA8Ym9vbi5sZW9u
Zy5vbmdAaW50ZWwuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsN
Cj4gSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IEpvc2UgQWJyZXUgPGpvYWJyZXVA
c3lub3BzeXMuY29tPjsNCj4gRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgV2Vp
IFdhbmcgPHdlaXdhbkBnb29nbGUuY29tPjsNCj4gQWxleGFuZGVyIExvYmFraW4gPGFsZXhhbmRy
LmxvYmFraW5AaW50ZWwuY29tPjsgVmxhZGltaXIgT2x0ZWFuDQo+IDxvbHRlYW52QGdtYWlsLmNv
bT47IFhpYW9saWFuZyBZYW5nIDx4aWFvbGlhbmcueWFuZ18xQG54cC5jb20+Ow0KPiBNaW5na2Fp
IEh1IDxtaW5na2FpLmh1QG54cC5jb20+OyBKb2FraW0gWmhhbmcNCj4gPHFpYW5ncWluZy56aGFu
Z0BueHAuY29tPjsgU2ViYXN0aWVuIExhdmV6ZQ0KPiA8c2ViYXN0aWVuLmxhdmV6ZUBueHAuY29t
Pg0KPiBDYzogWWFubmljayBWaWdub24gPHlhbm5pY2sudmlnbm9uQG54cC5jb20+DQo+IFN1Ympl
Y3Q6IFtSRkMgbmV0LW5leHQgMi80XSBuZXQ6IHN0bW1hYzogbW92ZSB0byB0aHJlYWRlZCBJUlEN
Cj4gDQo+IEZyb206IFlhbm5pY2sgVmlnbm9uIDx5YW5uaWNrLnZpZ25vbkBueHAuY29tPg0KPiAN
Cj4gV0lQIChzZWVtcyB0byBnZW5lcmF0ZSB3YXJuaW5ncy9lcnJvciBvbiBzdGFydHVwKQ0KPiAN
Cj4gV2hlbiBhbiBJUlEgaXMgZm9yY2VkIHRocmVhZGVkLCBleGVjdXRpb24gb2YgdGhlIGhhbmRs
ZXIgcmVtYWlucyBwcm90ZWN0ZWQNCj4gYnkgbG9jYWxfYmhfZGlzYWJsZSgpL2xvY2FsX2JoX2Vu
YWJsZSgpIGNhbGxzIHRvIGtlZXAgdGhlIHNlbWFudGljcyBvZiB0aGUNCj4gSVJRIGNvbnRleHQg
YW5kIGF2b2lkIGRlYWRsb2Nrcy4gSG93ZXZlciwgdGhpcyBhbHNvIGNyZWF0ZXMgYSBjb250ZW50
aW9uDQo+IHBvaW50IHdoZXJlIGEgaGlnaGVyIHByaW8gaW50ZXJydXB0IGhhbmRsZXIgZ2V0cyBi
bG9ja2VkIGJ5IGEgbG93ZXIgcHJpbyB0YXNrDQo+IGFscmVhZHkgaG9sZGluZyB0aGUgbG9jay4g
RXZlbiB0aG91Z2ggcHJpb3JpdHkgaW5oZXJpdGFuY2Uga2lja3MgaW4gaW4gc3VjaCBhDQo+IGNh
c2UsIHRoZSBsb3dlciBwcmlvIHRhc2sgY2FuIHN0aWxsIGV4ZWN1dGUgZm9yIGFuIGluZGVmaW5p
dGUgdGltZS4NCj4gDQo+IE1vdmUgdGhlIHN0bW1hYyBpbnRlcnJ1cHRzIHRvIGJlIGV4cGxpY2l0
ZWx5IHRocmVhZGVkLCBzbyB0aGF0IGhpZ2ggcHJpb3JpdHkNCj4gdHJhZmZpYyBjYW4gYmUgcHJv
Y2Vzc2VkIHdpdGhvdXQgZGVsYXkgZXZlbiBpZiBhbm90aGVyIHBpZWNlIG9mIGNvZGUgd2FzDQo+
IGFscmVhZHkgcnVubmluZyB3aXRoIEJIIGRpc2FibGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
WWFubmljayBWaWdub24gPHlhbm5pY2sudmlnbm9uQG54cC5jb20+DQo+IC0tLQ0KPiAgLi4uL25l
dC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jIHwgMjggKysrKysrKysrLS0t
LS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3Rt
bWFjL3N0bW1hY19tYWluLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1h
Yy9zdG1tYWNfbWFpbi5jDQo+IGluZGV4IDc0ODE5NTY5N2U1YS4uOGJmMjQ5MDJiZTNjIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFp
bi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19t
YWluLmMNCj4gQEAgLTM0NjAsOCArMzQ2MCw4IEBAIHN0YXRpYyBpbnQgc3RtbWFjX3JlcXVlc3Rf
aXJxX211bHRpX21zaShzdHJ1Y3QNCj4gbmV0X2RldmljZSAqZGV2KQ0KPiAgCS8qIEZvciBjb21t
b24gaW50ZXJydXB0ICovDQo+ICAJaW50X25hbWUgPSBwcml2LT5pbnRfbmFtZV9tYWM7DQo+ICAJ
c3ByaW50ZihpbnRfbmFtZSwgIiVzOiVzIiwgZGV2LT5uYW1lLCAibWFjIik7DQo+IC0JcmV0ID0g
cmVxdWVzdF9pcnEoZGV2LT5pcnEsIHN0bW1hY19tYWNfaW50ZXJydXB0LA0KPiAtCQkJICAwLCBp
bnRfbmFtZSwgZGV2KTsNCj4gKwlyZXQgPSByZXF1ZXN0X3RocmVhZGVkX2lycShkZXYtPmlycSwg
TlVMTCwgc3RtbWFjX2ludGVycnVwdCwNCj4gKwkJCSAgSVJRRl9PTkVTSE9ULCBpbnRfbmFtZSwg
ZGV2KTsNCg0KV2h5IGNoYW5nZSBmcm9tIHN0bW1hY19tYWNfaW50ZXJydXB0KCkgdG8gc3RtbWFj
X2ludGVycnVwdCgpPyBBIGNvcHktcGFzdGUgaXNzdWU/DQoNCkJlc3QgUmVnYXJkcywNCkpvYWtp
bSBaaGFuZw0KPiAgCWlmICh1bmxpa2VseShyZXQgPCAwKSkgew0KPiAgCQluZXRkZXZfZXJyKHBy
aXYtPmRldiwNCj4gIAkJCSAgICIlczogYWxsb2MgbWFjIE1TSSAlZCAoZXJyb3I6ICVkKVxuIiwg
QEAgLTM0NzYsOSArMzQ3Niw5DQo+IEBAIHN0YXRpYyBpbnQgc3RtbWFjX3JlcXVlc3RfaXJxX211
bHRpX21zaShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiAgCWlmIChwcml2LT53b2xfaXJxID4g
MCAmJiBwcml2LT53b2xfaXJxICE9IGRldi0+aXJxKSB7DQo+ICAJCWludF9uYW1lID0gcHJpdi0+
aW50X25hbWVfd29sOw0KPiAgCQlzcHJpbnRmKGludF9uYW1lLCAiJXM6JXMiLCBkZXYtPm5hbWUs
ICJ3b2wiKTsNCj4gLQkJcmV0ID0gcmVxdWVzdF9pcnEocHJpdi0+d29sX2lycSwNCj4gLQkJCQkg
IHN0bW1hY19tYWNfaW50ZXJydXB0LA0KPiAtCQkJCSAgMCwgaW50X25hbWUsIGRldik7DQo+ICsJ
CXJldCA9IHJlcXVlc3RfdGhyZWFkZWRfaXJxKHByaXYtPndvbF9pcnEsDQo+ICsJCQkJICBOVUxM
LCBzdG1tYWNfbWFjX2ludGVycnVwdCwNCj4gKwkJCQkgIElSUUZfT05FU0hPVCwgaW50X25hbWUs
IGRldik7DQo+ICAJCWlmICh1bmxpa2VseShyZXQgPCAwKSkgew0KPiAgCQkJbmV0ZGV2X2Vycihw
cml2LT5kZXYsDQo+ICAJCQkJICAgIiVzOiBhbGxvYyB3b2wgTVNJICVkIChlcnJvcjogJWQpXG4i
LCBAQCAtMzQ5NCw5DQo+ICszNDk0LDkgQEAgc3RhdGljIGludCBzdG1tYWNfcmVxdWVzdF9pcnFf
bXVsdGlfbXNpKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpkZXYpDQo+ICAJaWYgKHByaXYtPmxwaV9p
cnEgPiAwICYmIHByaXYtPmxwaV9pcnEgIT0gZGV2LT5pcnEpIHsNCj4gIAkJaW50X25hbWUgPSBw
cml2LT5pbnRfbmFtZV9scGk7DQo+ICAJCXNwcmludGYoaW50X25hbWUsICIlczolcyIsIGRldi0+
bmFtZSwgImxwaSIpOw0KPiAtCQlyZXQgPSByZXF1ZXN0X2lycShwcml2LT5scGlfaXJxLA0KPiAt
CQkJCSAgc3RtbWFjX21hY19pbnRlcnJ1cHQsDQo+IC0JCQkJICAwLCBpbnRfbmFtZSwgZGV2KTsN
Cj4gKwkJcmV0ID0gcmVxdWVzdF90aHJlYWRlZF9pcnEocHJpdi0+bHBpX2lycSwNCj4gKwkJCQkg
IE5VTEwsIHN0bW1hY19tYWNfaW50ZXJydXB0LA0KPiArCQkJCSAgSVJRRl9PTkVTSE9ULCBpbnRf
bmFtZSwgZGV2KTsNCj4gIAkJaWYgKHVubGlrZWx5KHJldCA8IDApKSB7DQo+ICAJCQluZXRkZXZf
ZXJyKHByaXYtPmRldiwNCj4gIAkJCQkgICAiJXM6IGFsbG9jIGxwaSBNU0kgJWQgKGVycm9yOiAl
ZClcbiIsIEBAIC0zNjA1LDgNCj4gKzM2MDUsOCBAQCBzdGF0aWMgaW50IHN0bW1hY19yZXF1ZXN0
X2lycV9zaW5nbGUoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gIAllbnVtIHJlcXVlc3RfaXJx
X2VyciBpcnFfZXJyOw0KPiAgCWludCByZXQ7DQo+IA0KPiAtCXJldCA9IHJlcXVlc3RfaXJxKGRl
di0+aXJxLCBzdG1tYWNfaW50ZXJydXB0LA0KPiAtCQkJICBJUlFGX1NIQVJFRCwgZGV2LT5uYW1l
LCBkZXYpOw0KPiArCXJldCA9IHJlcXVlc3RfdGhyZWFkZWRfaXJxKGRldi0+aXJxLCBOVUxMLCBz
dG1tYWNfaW50ZXJydXB0LA0KPiArCQkJICBJUlFGX1NIQVJFRCB8IElSUUZfT05FU0hPVCwgZGV2
LT5uYW1lLCBkZXYpOw0KPiAgCWlmICh1bmxpa2VseShyZXQgPCAwKSkgew0KPiAgCQluZXRkZXZf
ZXJyKHByaXYtPmRldiwNCj4gIAkJCSAgICIlczogRVJST1I6IGFsbG9jYXRpbmcgdGhlIElSUSAl
ZCAoZXJyb3I6ICVkKVxuIiwgQEANCj4gLTM2MTksOCArMzYxOSw4IEBAIHN0YXRpYyBpbnQgc3Rt
bWFjX3JlcXVlc3RfaXJxX3NpbmdsZShzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqZGV2KQ0KPiAgCSAq
IGlzIHVzZWQgZm9yIFdvTA0KPiAgCSAqLw0KPiAgCWlmIChwcml2LT53b2xfaXJxID4gMCAmJiBw
cml2LT53b2xfaXJxICE9IGRldi0+aXJxKSB7DQo+IC0JCXJldCA9IHJlcXVlc3RfaXJxKHByaXYt
PndvbF9pcnEsIHN0bW1hY19pbnRlcnJ1cHQsDQo+IC0JCQkJICBJUlFGX1NIQVJFRCwgZGV2LT5u
YW1lLCBkZXYpOw0KPiArCQlyZXQgPSByZXF1ZXN0X3RocmVhZGVkX2lycShwcml2LT53b2xfaXJx
LCBOVUxMLA0KPiBzdG1tYWNfaW50ZXJydXB0LA0KPiArCQkJCSAgSVJRRl9TSEFSRUQgfCBJUlFG
X09ORVNIT1QsIGRldi0+bmFtZSwgZGV2KTsNCj4gIAkJaWYgKHVubGlrZWx5KHJldCA8IDApKSB7
DQo+ICAJCQluZXRkZXZfZXJyKHByaXYtPmRldiwNCj4gIAkJCQkgICAiJXM6IEVSUk9SOiBhbGxv
Y2F0aW5nIHRoZSBXb0wgSVJRICVkICglZClcbiIsIEBADQo+IC0zNjMyLDggKzM2MzIsOCBAQCBz
dGF0aWMgaW50IHN0bW1hY19yZXF1ZXN0X2lycV9zaW5nbGUoc3RydWN0IG5ldF9kZXZpY2UNCj4g
KmRldikNCj4gDQo+ICAJLyogUmVxdWVzdCB0aGUgSVJRIGxpbmVzICovDQo+ICAJaWYgKHByaXYt
PmxwaV9pcnEgPiAwICYmIHByaXYtPmxwaV9pcnEgIT0gZGV2LT5pcnEpIHsNCj4gLQkJcmV0ID0g
cmVxdWVzdF9pcnEocHJpdi0+bHBpX2lycSwgc3RtbWFjX2ludGVycnVwdCwNCj4gLQkJCQkgIElS
UUZfU0hBUkVELCBkZXYtPm5hbWUsIGRldik7DQo+ICsJCXJldCA9IHJlcXVlc3RfdGhyZWFkZWRf
aXJxKHByaXYtPmxwaV9pcnEsIE5VTEwsIHN0bW1hY19pbnRlcnJ1cHQsDQo+ICsJCQkJICBJUlFG
X1NIQVJFRCB8IElSUUZfT05FU0hPVCwgZGV2LT5uYW1lLCBkZXYpOw0KPiAgCQlpZiAodW5saWtl
bHkocmV0IDwgMCkpIHsNCj4gIAkJCW5ldGRldl9lcnIocHJpdi0+ZGV2LA0KPiAgCQkJCSAgICIl
czogRVJST1I6IGFsbG9jYXRpbmcgdGhlIExQSSBJUlEgJWQgKCVkKVxuIiwNCj4gLS0NCj4gMi4y
NS4xDQoNCg==
