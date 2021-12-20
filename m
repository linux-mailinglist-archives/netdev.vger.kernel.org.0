Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EC147B2C0
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 19:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhLTSWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 13:22:41 -0500
Received: from mail-sn1anam02lp2049.outbound.protection.outlook.com ([104.47.57.49]:6205
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236184AbhLTSWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 13:22:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSjkweB69j/uw04zvHJN9rrbZ0y4kGVwjXOnV41EG0PF2DGL9GkFjxtWxfcryMOuPPIOnkDSTeecPnaPFdBDQeYFzZXiYH31AlxDtyu0TecARMnnl5LYxDcH9caCz3rwxUBRIjF2Wc0bzgmHOvIK2yfGEyVvPXietOQTCnzimAKzWqG4UzxtuE+qQeuMdCMVslSPuombEfEP4RPc3u7vHik9XKqkgJB4LbAvPLs8pUUm8ronYlfAn4ExxZrQrJiHLsk8GFa0tulLDqLwx+B5jl5vN8aR1Y+np+2YDTA9B+FT/WD7chhXLR98/swZBUxL5rDmXCIuQI9XHgE6DIQVBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5aobPowduKJ+fOnKO8zOP+lB2q0Bwnz3uK3+RR1A84=;
 b=Ao1XSQ2xwpbvvJB5zw6B6AoZ6r+EuRZCPZrTjQa26sKWt+QqMRsjaCcOHGhknXdofB7wKGMOCGuLCBwHP7+w4WHZG3SjqkrKHYrrTMSQCpbyrc+lL7vUC9e6w1+6yWPZm+rtLr5dbswH2or1mv0FPgnqPEBoD7mgDEB3I49vn0mQL3blU3D8raot/dO+FUiT5odKfQwXNuQaAojW0cj1YumRUub+M7fUkprxj37UsKhborHv8yU9Z0R4SVJmN1b2krt1/2MtfdGSt0Vziiv7SIFc3/NTgXWba6zXtcS+fbZsQn7Y/uzzfL8x3Ivk42wBqBCxwBdXQx5VS0fNZobVWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5aobPowduKJ+fOnKO8zOP+lB2q0Bwnz3uK3+RR1A84=;
 b=LB0F+UJGj87qaJX460Ai9KDMPvn46nOU461ydc8fYJvdvsHXfuko3q/oxCjCfJdnp/irBrwQYHdZuqYLLrswqTxrTTRtLjlGzjv/u4I4OtgdnlinwMjzjt3tdy1Lr7QBaEe1+HDlXRfTSyH4VkQi/jnJ9qVTEgSelBa0lgyVLPo=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by BY5PR13MB3111.namprd13.prod.outlook.com (2603:10b6:a03:183::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.14; Mon, 20 Dec
 2021 18:22:27 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::288c:e4f1:334a:a08]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::288c:e4f1:334a:a08%3]) with mapi id 15.20.4823.014; Mon, 20 Dec 2021
 18:22:27 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "cuibixuan@linux.alibaba.com" <cuibixuan@linux.alibaba.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "xiaoh.peixh@alibaba-inc.com" <xiaoh.peixh@alibaba-inc.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "wenan.mwa@alibaba-inc.com" <wenan.mwa@alibaba-inc.com>,
        "weipu.zy@alibaba-inc.com" <weipu.zy@alibaba-inc.com>,
        "pete.wl@alibaba-inc.com" <pete.wl@alibaba-inc.com>
Subject: Re: [PATCH -next] SUNRPC: Clean XPRT_CONGESTED of xprt->state when
 rpc task is killed
Thread-Topic: [PATCH -next] SUNRPC: Clean XPRT_CONGESTED of xprt->state when
 rpc task is killed
Thread-Index: AQHX8PIF1uk7AUWrmE+w9HCnnE9qfaw6xHsAgAD2qIA=
Date:   Mon, 20 Dec 2021 18:22:27 +0000
Message-ID: <c5d8fa4cfe87800afe588c4c3d54cd3178e04b47.camel@hammerspace.com>
References: <1639490018-128451-1-git-send-email-cuibixuan@linux.alibaba.com>
         <1639490018-128451-2-git-send-email-cuibixuan@linux.alibaba.com>
         <c5c17989-4c1e-35d2-5a75-a27e58cf6673@linux.alibaba.com>
In-Reply-To: <c5c17989-4c1e-35d2-5a75-a27e58cf6673@linux.alibaba.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 136a5e73-9a78-43c3-7874-08d9c3e5ad40
x-ms-traffictypediagnostic: BY5PR13MB3111:EE_
x-microsoft-antispam-prvs: <BY5PR13MB311190D3ADA252745E2A50ADB87B9@BY5PR13MB3111.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wCQcZKUBlQNaCfF7dcsknD4JzhU9TwVw2TBpRxwOF7y/MwbpNNsJs07ac48Gc041Gmcw7zoMIEE33wyTDf2Yb5lq95Uw963kK4Ua2Kl4UIdLWzNtMqW4T2rgLy906oNNmyV8VQarmTikN3QGKpzvO1K7Q7DZpQEsn4VXdhjFc1qLrv/+fYqecyKnvffM8MixuZ44WZQwOy4Jtxitg56QGMXsnTOK/bSezhrEz/XDYOWdMfziCycA3smFCu4BOERSXwQ2iKllNyTYqvWzghT/T0UUm1dJDkZ2fpQU9Xa8P0Dgib1YHrebfxDtYK2RUyTg76hIwyq57aX0Wuq84fPiaonA9ayh/g/8d51lb+o8VSp2EY61W+HWssPAYJFPiO3Q424ESm9/DTOpJe17jiMzLqzgeGoihSG7T2F439mifp6REBpPi2kpSl1pAZZKCoFI/DpBGG+/U5P1CHfGUfHifG7CX9cNjVbS9wK4UPm4yaRwTLq7jmUH1nc2Ljn65u/GSNmqRAltV3La9c++ocsSI01INh6n9FFCNO4rZzdKJ1c1D/VpknZ7vgUQGf8vy5BcSJpjKfltWVdDMFuAm49k5PPZR5sh3CiINOM3stwglTz6PX+K1VjHpOf+Kpt8RjEC/p7JLsw7hF9tlIDWx2DewNtOU70PK6cHjLxX+WBwrhS4gf9A32Bv39KzfPEnscN1R9YIUbZHFBf34bkTg7VrNI9VaOL+LY1OSz34pcDD8PKmaQlBOhk9JvwIn36E7CZT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(396003)(39830400003)(346002)(376002)(2906002)(5660300002)(71200400001)(36756003)(7416002)(4001150100001)(508600001)(86362001)(38070700005)(8676002)(6486002)(2616005)(38100700002)(122000001)(66946007)(8936002)(66476007)(64756008)(6506007)(4326008)(76116006)(66446008)(66556008)(316002)(110136005)(54906003)(186003)(26005)(6512007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFM3NEhoMTZna3N3NWxVcU9ERGJyd0V2M3p4SVhKNXZTV0hkdFpLdnBsWExK?=
 =?utf-8?B?TTJObGs5bUNOMTlBVy9nNG1UOG50ZzJQdm9YVUp0cXpMbEY4dWE0YmJYK3Nl?=
 =?utf-8?B?N1ZPZXhPczN1RTFEZmc4dklodGlCdWtBdWpNcnU1NHYrUHZBNUROLzVKT2tE?=
 =?utf-8?B?OXhPUUdGN0RPQVRBTDRHRmN6K3Ftd3FrWldnWFNIMWNHK3orYndDSzFKdUg4?=
 =?utf-8?B?MXNMUlAveXAraFBSeGlmZXFTMnlZOGx1cDFPbUczWEJROTV4T2dXN1VSNmVJ?=
 =?utf-8?B?eitzV2ZBOTVBWSs1RVVYTVhReG1sZWRDNWUyTisvNjlZV0RHZ3NoTTFrcHVy?=
 =?utf-8?B?bG9yTS9uUnZ0c0FZOU5HRlB5TnlpY2ttb0pNOEpSVHJObTJBaFVZVXBEVmYz?=
 =?utf-8?B?ZU9ySU02MVc3WTV5SWsyaG9vTVZFcVRacWc5b0UxTjNFNU4yRUllczRPUEN4?=
 =?utf-8?B?eUdXNkVqUTRhWDlkc1l4WU9GbW1YNXFRbjNwWTZHWFI3Z0VBbGd5alZJeVUx?=
 =?utf-8?B?ZGRGMHYvMU1tNVJ4VUtKR3VFaE4ybzY5cWVFK240c1ZzVnRBR0RrS1VNT3pR?=
 =?utf-8?B?S1BsTXN2akFNclNEcjlFTm8vRytHS2Z0b0l2WFhKdFU3NUxnbkNrTmhQQTFP?=
 =?utf-8?B?bVZvaHRkNDFXZXVKK2hFcDJLSGJ4OVJRcCthOHNNS3hrOTBrN3A4bk4rUm9a?=
 =?utf-8?B?N2R6dkV6RXhLcERqNFFzMXJaZ0tPeElWdHYybEpyOVlWOXdOcEttS0hxc0xO?=
 =?utf-8?B?RkZlbUZxa1Q2RDE0Z3BhSzhoTEMrR3BaTlQwTVJyanNPRHNlZ2JEQjhCeVNT?=
 =?utf-8?B?SXVsOXFQZHpLR0VRVmN0UTM3S2hWZ2I4eXhpQ3p1MDBBQVVvd3k1QWJFVXdI?=
 =?utf-8?B?c2xjRkIwOHpxbFV6S1N0ZzFXQlFxaWlSeFhYOUtyOG9qRWRlL0VJZjVmeUFV?=
 =?utf-8?B?amV6aGRMK1c1MmlmTm5kSUcvSmRDdzFURnlvZVpDbWVIOGZnWGgwbGFNNFZO?=
 =?utf-8?B?ZUNFWEQ2ZkhaYzJ3ZlhyTzRzNzhLSkFON3VYOG9lTURSZ3dsVXlrVDlXUVZU?=
 =?utf-8?B?ekV0bkxuNklFZ2N6UVhpRWRxemJ0cW1rUkl5blo4WUFDWVM2SE1tUEc0eUtn?=
 =?utf-8?B?R2NYZHJvUlhUS3ZtcGpLUW5zOG5RN0REeVNuUUNPRlB2TWlrQmJ1TXpBL1Vs?=
 =?utf-8?B?Si9rL3c3UktZSDNHTDNQV0xabXdxcklaelNzSVVGK25zSTN6RkwxT3Q5a0lp?=
 =?utf-8?B?ZDhrbWVnKzV2VG9ISGRVM1Q5VlJqdWoxM2RMOE80dTgwYWhJeWJyTUpYNTRS?=
 =?utf-8?B?YUVsY0RXVGxxRFRBNDZodVNKd0xNcTdBOW13UExFQnhldDVrbzRVcTZRR1NU?=
 =?utf-8?B?a0NzT0c3M3pHWUkrZG45MDVuZHRhRGVJTzVSdkRaa3FZbWpMSWhmVkh5bHFJ?=
 =?utf-8?B?TVBVSUhteXAvUUZNMHBtVWdwUStZelAyb1FKTGU2UityMVNzWHJtaThkdXZM?=
 =?utf-8?B?NWdSWTg0Qk9FRDRUZ1V6VjY1OGpWd041ZmZCQ3ZyUXEvZFYyMEs4ZDBFcjJm?=
 =?utf-8?B?UGVTNlp4WkNOMFI0bks5eFJaTHVmd2ZaMitIVHJCWGtaUGd1RWNLTXNMUFBv?=
 =?utf-8?B?ZERoYWgyeGZySEhHMWFpTG9MRFFENzRWOGxKWnpCSzJTUXJZcm9QOEVscVV3?=
 =?utf-8?B?NXJTV0pyTW1Hais0clJ2OXUxZWRzMzNOQ0hGdlZNMDdzcTVPVzJJdEZHTW5Y?=
 =?utf-8?B?MWV4UU1LNEhRNStTdWdQU1E2SUtnNmErb3QzTDhDTTJuM1BEblhISW5GNWFK?=
 =?utf-8?B?dHhvSHN3YXczUllEWDU1UGUwaVo5dmRuL3NjdXFzZ1V6emhRSXpER0RYVUto?=
 =?utf-8?B?OFNOOTQyK20zazluTUJnL0NSeTlBcDRwYVdPeWY0NE1kcWJNOVpLUWdZbUNN?=
 =?utf-8?B?ektUSFFwU2t6RTlQS3BOSEo3ZjFTMW1MdDFmZm5idXAwQW9kVXRKNXpneTJW?=
 =?utf-8?B?K3M1N0pHOW5odVlCbFh2Qjh1MzRObnJYMzJmaE12cGc1OEpTeHN5RjZLOXhs?=
 =?utf-8?B?dkF1K3NPNXNSZ2Q2N1FjVEgrb0c2WXh0U2UwUUxmdnFnTEkvQzlCeEdIcnRt?=
 =?utf-8?B?Q1drSU1qNWJwM2JPb0tFT1ROVGhseXhGeHpoNDBqUjlKdmkwVzd2ZHU0cVpB?=
 =?utf-8?Q?JR7Arsaf0PbuqFaySJtztAI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A26B39FDEDC0D4E83E565CEC3365C8A@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 136a5e73-9a78-43c3-7874-08d9c3e5ad40
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2021 18:22:27.0240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JXs9q2uJOlxQz0gYXWQDdBLpI8TH8RwO8fDsmlsTQeAv6sU9FxBA6f/oMzUgRxGlpJ0AP9ovCmtO/da80mGVZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTEyLTIwIGF0IDExOjM5ICswODAwLCBCaXh1YW4gQ3VpIHdyb3RlOg0KPiBw
aW5nfg0KPiANCj4g5ZyoIDIwMjEvMTIvMTQg5LiL5Y2IOTo1MywgQml4dWFuIEN1aSDlhpnpgZM6
DQo+ID4gV2hlbiB0aGUgdmFsdWVzIG9mIHRjcF9tYXhfc2xvdF90YWJsZV9lbnRyaWVzIGFuZA0K
PiA+IHN1bnJwYy50Y3Bfc2xvdF90YWJsZV9lbnRyaWVzIGFyZSBsb3dlciB0aGFuIHRoZSBudW1i
ZXIgb2YgcnBjDQo+ID4gdGFza3MsDQo+ID4geHBydF9keW5hbWljX2FsbG9jX3Nsb3QoKSBpbiB4
cHJ0X2FsbG9jX3Nsb3QoKSB3aWxsIHJldHVybiAtRUFHQUlOLA0KPiA+IGFuZA0KPiA+IHRoZW4g
c2V0IHhwcnQtPnN0YXRlIHRvIFhQUlRfQ09OR0VTVEVEOg0KPiA+IMKgwqAgeHBydF9yZXRyeV9y
ZXNlcnZlDQo+ID4gwqDCoMKgwqAgLT54cHJ0X2RvX3Jlc2VydmUNCj4gPiDCoMKgwqDCoMKgwqAg
LT54cHJ0X2FsbG9jX3Nsb3QNCj4gPiDCoMKgwqDCoMKgwqDCoMKgIC0+eHBydF9keW5hbWljX2Fs
bG9jX3Nsb3QgLy8gcmV0dXJuIC1FQUdBSU4gYW5kIHRhc2stDQo+ID4gPnRrX3Jxc3RwIGlzIE5V
TEwNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtPnhwcnRfYWRkX2JhY2tsb2cgLy8gc2V0X2Jp
dChYUFJUX0NPTkdFU1RFRCwgJnhwcnQtDQo+ID4gPnN0YXRlKTsNCj4gPiANCj4gPiBXaGVuIHJw
YyB0YXNrIGlzIGtpbGxlZCwgWFBSVF9DT05HRVNURUQgYml0IG9mIHhwcnQtPnN0YXRlIHdpbGwg
bm90DQo+ID4gYmUNCj4gPiBjbGVhbmVkIHVwIGFuZCBuZnMgaGFuZ3M6DQo+ID4gwqDCoCBycGNf
ZXhpdF90YXNrDQo+ID4gwqDCoMKgwqAgLT54cHJ0X3JlbGVhc2UgLy8gaWYgKHJlcSA9PSBOVUxM
KSBpcyB0cnVlLCB0aGVuDQo+ID4gWFBSVF9DT05HRVNURUQNCj4gPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgLy8gYml0IG5vdCBjbGVhbg0KPiA+IA0KPiA+IEFkZCB4cHJ0
X3dha2VfdXBfYmFja2xvZyh4cHJ0KSB0byBjbGVhbiBYUFJUX0NPTkdFU1RFRCBiaXQgaW4NCj4g
PiB4cHJ0X3JlbGVhc2UoKS4NCg0KSSdtIG5vdCBzZWVpbmcgaG93IHRoaXMgZXhwbGFuYXRpb24g
bWFrZXMgc2Vuc2UuIElmIHRoZSB0YXNrIGRvZXNuJ3QNCmhvbGQgYSBzbG90LCB0aGVuIGZyZWVp
bmcgdGhhdCB0YXNrIGlzbid0IGdvaW5nIHRvIGNsZWFyIHRoZSBjb25nZXN0aW9uDQpjYXVzZWQg
YnkgYWxsIHRoZSBzbG90cyBiZWluZyBpbiB1c2UuDQoNCg0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QN
CkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVz
dEBoYW1tZXJzcGFjZS5jb20NCg0KDQo=
