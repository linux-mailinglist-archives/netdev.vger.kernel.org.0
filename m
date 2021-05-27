Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15710392F1C
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 15:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236369AbhE0NIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 09:08:14 -0400
Received: from mail-bn7nam10on2075.outbound.protection.outlook.com ([40.107.92.75]:51360
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236191AbhE0NIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 09:08:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PiRI75SuWeYUPqjpuBEnzPjtAWV6Q2QUMlEJai4gvrxxVMip8kartr2DhkH7sV/A/XcNceao7q8/Uyo8rg90W6D7VABIcfkN+ZP9YdxzF0kiBdDfMiT2couK4qHwibzPQ8M7RRR8aNkjnMmB4BNowHyFcpkOCruhbJWliMeKsx0h0dkjNeAI3AJfUTgzH13A33NzI86Jvy7+Ne9wYZkqvr3fELUkVwPxcNsVfYeVGt3y01RUNIkfoP2sCnNDtlDpMSD5bH88VCSr7atwhp4zy99hH+9c48XEBfuK6XmE0vdZMIy4pIxwPhZDDB/DvdyfFl3CfvYt3e3DVGBmyeJOYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpYwtwjGBnenfWn7N4ke9lWpVqVaf/czorOy6/TWY4M=;
 b=dd4APqFEFg8kbvvzi6q9isWZquQK9ST9NtNwuKL7iSyV8qPVcZhpF10+a4m6zrqI3tcrneRk26Q5Z9q9JtDSv6H6C0rRUtYDV0B17RIQKvAX0uEGhqYewhoi4XUUYl4QZyyT+2+MZE+6Sjzsb0Tg+ngsQo2Ufu1pdpS+RKDHq4Wm9JDkU12OkEt0VBJr3TfNgr2cG8Cef6peuAZ9e+B2Xc3p423qC1q/MU3Z382vbiyOTgOqc72HnfZGwy7w7rBj/eIQQdpBDSy5xzzmbhIGNUkgJpdi5jmFjzeiN2oCusX6xVMRDuO+cRpLWV6zi8VbZrPYwxduQ9Z7auBk4o8+mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpYwtwjGBnenfWn7N4ke9lWpVqVaf/czorOy6/TWY4M=;
 b=fPYV2osAZfPpjK9asgUC1nL0aovOutfUZfO1GFpcewf6ubf1liebDT1DiGJ4v+zCkgpl04/gTvnMt+S8h4LLQ4tO2muFEFVio24XdJVgVIO8YTm8WMXlfHrTqfAm3ZiGTMb2WiQtYJapeweaFhNGmXDclsk2O8hGvj8+bJxUTC2QUU/iynEfreDU/anqz2RvOG2F/hWow077cbjrCHQjPghovMTmAHJUeMBU2l2PHXzxSmyggXiNu/KMSBePuVKT2I8aYHnK7vfjPK78Gmcp54WNiegOaipdf8W7s6Rnmpj95xVsjNHllTORrZk50Bw4K5X+7yEcH+bIACJ3ncW61A==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4934.namprd12.prod.outlook.com (2603:10b6:a03:1db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Thu, 27 May
 2021 13:06:35 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a190:d045:87eb:8e55]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a190:d045:87eb:8e55%7]) with mapi id 15.20.4173.022; Thu, 27 May 2021
 13:06:35 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Karthik S <ksundara@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "karthik.sundaravel@gmail.com" <karthik.sundaravel@gmail.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        Veda Barrenkala <vbarrenk@redhat.com>,
        Vijay Chundury <vchundur@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [PATCH 0/1] net-next: Port Mirroring support for SR-IOV
Thread-Topic: [PATCH 0/1] net-next: Port Mirroring support for SR-IOV
Thread-Index: AQHXUuPGjY3587tPD0GAgLrNtBRXrqr3R9Yw
Date:   Thu, 27 May 2021 13:06:35 +0000
Message-ID: <BY5PR12MB43223DDB8011260DD65B9405DC239@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <ksundara@redhat.com>
 <20210527103318.801175-1-ksundara@redhat.com>
In-Reply-To: <20210527103318.801175-1-ksundara@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.211.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1acb57d-0a21-4938-d37b-08d921104195
x-ms-traffictypediagnostic: BY5PR12MB4934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4934A535409D0B52A46AB434DC239@BY5PR12MB4934.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4KRgQqGKezFqhxjwrEMDkEEd4xh1qbJ1DhgDhFVEnMxzMzYs1E7cUSbrKUiug2DCdhcq9ofea/t1kDauVMsMMr76P582eFJgdCBLO14K6f8nPkifcdoqLJYCdqVJ8oi7+wRe9Ce3Q/xxzMa5KLDMBx7HxscRsSh30f76ZG3DMA8Jh/OLItzKf1sSt/F/Ti9/qubDFb1wUOeUVWl9DkheQj9hF5qKuyMpbzECacZwwc2fs2XUflxyeotWLnjo0ZjFyIwlKVcDAiczbjaKnPgr4kVp+xW7uXMiTkL9KGqCAhm1POfEjv6VEKK2d1VhB/oSsmPguEeOoPV97udS5sDc06qvj1OocSF/6Ak5Drk6OaJbiY/qZkhf9qdJScsOSk6Exc5ztWjXAsYnnlOX0N0EYodE4kfVt6LGngZT78jLk2ciVokpV0JrOLiLtq1h1rI0teopa1esGU6vy5r3e7zzP+UHr/EmU35+Ui0TA6Hhvx7VCzn3koH3dKO2LK2e/BVZSiJgykfP4IiEwKqNzZPbRkR6f0cNKLxLo7NLDD8D7QI3FieXw/FVZIqRuWT+6o901JXliQdxWqCxMYvQucLbAS6VYW+bp0fAxFaaD7WEmkA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(52536014)(55236004)(66556008)(66476007)(64756008)(5660300002)(8936002)(33656002)(9686003)(66446008)(122000001)(2906002)(86362001)(186003)(38100700002)(26005)(7696005)(6506007)(76116006)(66946007)(71200400001)(83380400001)(110136005)(478600001)(55016002)(8676002)(6636002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?T3JHRjlTZVVEOUwrRTVCM2FxekEwY0lIcE15c3IvQ1RWdDBKd3kvaGwxOUYz?=
 =?utf-8?B?MjFrcU1RQkVJKzNiblN3VWs2b0VrVkVlL09PQTl1ajNhUkVFTVNIREJsN0Vk?=
 =?utf-8?B?T29za0NCcDNWd1dweDZjelp4TTg0WW5NRjBsSTh4cHlDcDYyNHdhU3Z5eVV4?=
 =?utf-8?B?OEJSZ0pTM3pMWEg5RTFaQTdteTJtSHI5bWhySGRqZUlFcnFqWlNmdTFuUVI1?=
 =?utf-8?B?U2lpVEp3c2pYK2dXNmRPeFVWOEdQajVRTS9waVN1aUZlV0ZIOVNpVXdraVd2?=
 =?utf-8?B?OWMzVkl5RGFQMUc2QnorVzdkc3VTQnZrN1RFOE40NkcrUSs3VWlIV2t4bTg4?=
 =?utf-8?B?eEJUeWQzY1VrbWl0dGNxN0JZS296NHIzeTlsZDJveXVSZThZeE1URU5nQTFE?=
 =?utf-8?B?NCtBS2syYXpqWlg2TC90anhHaU1TNEF6bmVEeUZBNnlsOXlTQWoxWEVKanp5?=
 =?utf-8?B?MnliYU5MTEJ0Ukp1UGZnY0l3RVJCVHhpWGdEOVV5blNFMW9jOHkwSWhBbjVL?=
 =?utf-8?B?Ym81SEp4Q2RTK3Jjbk1zRURnTEtTR2g4YVNKaFdicUdiSVBUZzVKeGdrK2xu?=
 =?utf-8?B?ckVGd0VQb0hKMmM3amVpdGQ2VEc3OVB4aHRaTDNxTjAyY3N6NGRhSHFzeTdE?=
 =?utf-8?B?NFQyTG1INWpGbTBCMVFTQXFidXlDcTFpM3o5VWNwZk5hTEJIakxlYzF0WkFR?=
 =?utf-8?B?a2pIeVZuRVBReUFqRC9HZVA0cHdKbW02N202YVY2RnkvSzZOM05TMDQrYVZ4?=
 =?utf-8?B?NHpZMjVHWFBJSVdRaTV0RTdkL3oyZ01ycDFWQVpmNnVWTllLS2NiNTRvMVZv?=
 =?utf-8?B?Mnh4U2t3UUs2ek5NclpPb2RvWlY1cTFrR0xUTm9PZzh3Z045QW9lNmdxektn?=
 =?utf-8?B?bmJoV0hTVkloejVKSHlVS3lQRTkzRzRJVi85Q2oxZmpRSVpacmpSa3NIOTNS?=
 =?utf-8?B?Sm9aUFY1QmZFMDBxOU8zVXArNXliSHVXaDRrUklyYW1WYWR2T05qWmZONmIv?=
 =?utf-8?B?SkdzWFdtdFViTWhGRVVMbDRaWGFONThUMzZ5ZitiODcxVi9ya2ZpdlJGa1Ev?=
 =?utf-8?B?RnViZVI3YUZJWTI0bUxJZ1dZVU1Oak9LT3hhYW1Dd1BVZW1RY1ZYQUxtcmJ6?=
 =?utf-8?B?VDdTY213NlNyME5FQVJXaDdVYVl2eTAzei9BeTU0cTdQUldNUU51eUtpTkJJ?=
 =?utf-8?B?R2pzTjZVU1kvR3UwY2Q5R3JCdllXclhXZDg3b3RNOFBJWUJXWENhcGNSTWJC?=
 =?utf-8?B?bXdvVzRDcDJTdlgxWXBGbGpGK3Z3Q2hBZkhIL1hRV1dYU0VHUkdjSG5OYity?=
 =?utf-8?B?THFybkhCOGpLUVpCdFVpS1ZVV2FGNG12ZTVJUUx2YXRLMVJ4S0U2djlCekt1?=
 =?utf-8?B?Nk9VbnZhMlFZYi9PbE9lSWtYbWFYMWFHaFQ1STVYaUM1M09LbXBKMmNLVXVk?=
 =?utf-8?B?N2w1SHRuNkdDWE0reW5sMDdRTnhuYy9ldmFIZ01hOGFhOExJcWxQc3RobHo4?=
 =?utf-8?B?TmpBaVpDR29Pc3F2dXR2bG5ONGlnM1p0bXRQV2QyRWxhMjh6T2V5R2VneStn?=
 =?utf-8?B?ditPVEg5bFFibEMwT0xUOVFQVE1CN0hOQWpWSjZKRlRvKzFiSXk5SU1NaGFl?=
 =?utf-8?B?eCtXc1h1Z0J4eThtTy9maWFVTDBueHMyczVhaEJsYjhwemRWYTlXSnZPRVVK?=
 =?utf-8?B?SkkrK3Z3T1VCYlVxMi81djZGS1lNSmQ3MHd3TFJqd1RNSWQzakJLcWlVUGxR?=
 =?utf-8?Q?hrz/sMmTp9+tohdHAi76+kvWl75R2+GiGNwkiFI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1acb57d-0a21-4938-d37b-08d921104195
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2021 13:06:35.0638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6WcrD9BTXmYQliZHDArgPI80W+WDdDiT/VXUFN7ENQvABdiGSsME/rfWy1il3ofGgMZ/kS01n4hSRxIsDuhJxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4934
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEthcnRoaWsgUyA8a3N1bmRhcmFAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1cnNk
YXksIE1heSAyNywgMjAyMSA0OjAzIFBNDQo+IA0KPiBUaGUgcHVycG9zZSBvZiB0aGlzIG1lc3Nh
Z2UgaXMgdG8gZ2F0aGVyIGZlZWRiYWNrIGZyb20gdGhlIE5ldGRldg0KPiBjb21tdW5pdHkgb24g
dGhlIGFkZGl0aW9uIG9mIFNSSU9WIHBvcnQgbWlycm9yaW5nIHRvIHRoZSBpcHJvdXRlMiBpcCBD
TEkuDQoNCj4gaXByb3V0ZTIgd2FzIGNob3NlbiBhcyB0aGUgZGVzaXJlZCBpbnRlcmZhY2UgYmVj
YXVzZSB0aGVyZSBpcyBhbHJlYWR5DQo+IGV4dGVuc2l2ZSBzdXBwb3J0IGZvciBTUklPViBjb25m
aWd1cmF0aW9uIGJ1aWx0IGluIGFuZCBtYW55IExpbnV4IHVzZXJzIGFyZQ0KPiBmYW1pbGlhciB3
aXRoIGl0IGZvciBjb25maWd1cmluZyBOZXR3b3JrIGZ1bmN0aW9uYWxpdHkgaW4gdGhlIGRyaXZl
ciB0aHVzIHBvcnQNCj4gbWlycm9yaW5nIG5hdHVyYWxseSBmaXRzIGludG8gdGhpcyBzY2hlbWEu
DQo+IA0KPiBQb3J0IG1pcnJvcmluZyBpbnZvbHZlcyBzZW5kaW5nIGEgY29weSBvZiBwYWNrZXRz
IGVudGVyaW5nIGFuZC9vciBsZWF2aW5nIG9uZQ0KPiBwb3J0IHRvIGFub3RoZXIgcG9ydCB3aGlj
aCBpcyB1c3VhbGx5IGRpZmZlcmVudCBmcm9tIHRoZSBvcmlnaW5hbCBkZXN0aW5hdGlvbg0KPiBv
ZiB0aGUgcGFja2V0cyBiZWluZyBtaXJyb3JlZC5IYXJkd2FyZSBQb3J0IE1pcnJvcmluZyBjYW4g
cHJvdmlkZSB0aGUNCj4gZm9sbG93aW5nIGJlbmVmaXRzIGZvciB1c2VyczoNCj4gMSkgTGl2ZSBk
ZWJ1Z2dpbmcgb2YgbmV0d29yayBpc3N1ZXMgd2l0aG91dCBicmluZ2luZyBhbnkgaW50ZXJmYWNl
IG9yDQo+IGNvbm5lY3Rpb24gZG93bg0KPiAyKSBObyBsYXRlbmN5IGFkZGl0aW9uIHdoZW4gcG9y
dCBtaXJyb3JpbmcgdGFwIGlzIGludHJvZHVjZWQNCj4gMykgTm8gZXh0cmEgQ1BVIHJlc291cmNl
cyBhcmUgcmVxdWlyZWQgdG8gcGVyZm9ybSB0aGlzIGZ1bmN0aW9uDQo+IA0KPiBUaGUgcHJvc3Bl
Y3RpdmUgaW1wbGVtZW50YXRpb24gd291bGQgcHJvdmlkZSB0aHJlZSBtb2RlcyBvZiBwYWNrZXQN
Cj4gbWlycm9yaW5nIChGb3IgRWdyZXNzIG9yIEluZ3Jlc3MpOg0KPiAxKSBQRiB0byBWRg0KPiAy
KSBWRiB0byBWRg0KPiAzKSBWTEFOIHRvIFZGDQo+IA0KPiBUaGUgc3VnZ2VzdGVkIGlwcm91dGUy
IGlwIGxpbmsgaW50ZXJmYWNlIGZvciBzZXR0aW5nIHVwIFBvcnQgTWlycm9yaW5nIGlzIGFzDQo+
IGZvbGxvd3M6DQoNCmlwIGxpbmsgdmYgc2V0IGNvbW1hbmRzIGFyZSBmb3IgbGVnYWN5IHNyaW92
IGltcGxlbWVudGF0aW9uIHRvIG15IGtub3dsZWRnZS4NCkl0IGlzIG5vdCB1c2FibGUgZm9yIGJl
bG93IDQgY2FzZXMuDQoxLiBzd2l0Y2hkZXYgc3Jpb3YgZGV2aWNlcw0KMi4gcGNpIHN1YmZ1bmN0
aW9ucyBzd2l0Y2hkZXYgZGV2aWNlcw0KMy4gc21hcnRuaWMgd2hlcmUgVkZzIGFuZCBlc3dpdGNo
IGFyZSBvbiBkaWZmZXJlbnQgUENJIGRldmljZS4NCjQuIFBDSSBQRiBvbiB0aGUgc21hcnRuaWMg
bWFuYWdlZCB2aWEgc2FtZSBzd2l0Y2hkZXYgY2Fubm90IGJlIG1pcnJvcmVkLg0KDQpXaXRoIHRo
ZSByaWNoIHN3aXRjaGRldiBmcmFtZXdvcmsgdmlhIFBGLFZGLCBTRiByZXByZXNlbnRvcnMsIHRj
IHNlZW1zIHRvIGJlIHJpZ2h0IGFwcHJvYWNoIHRvIG1lLg0KDQpTdWNoIGFzLCANCiQgdGMgZmls
dGVyIGFkZCBkZXYgdmYxX3JlcF9ldGgwIHBhcmVudCBmZmZmOiBcDQoJcHJvdG9jb2wgaXAgdTMy
IG1hdGNoIGlwIHByb3RvY29sIDEgMHhmZiBcDQoJYWN0aW9uIG1pcnJlZCBlZ3Jlc3MgbWlycm9y
IGRldiB2ZjJfcmVwX2V0aDENCg0KRmV3IGFkdmFudGFnZXMgb2YgdGMgSSBzZWUgYXJlOg0KMS4g
SXQgb3ZlcmNvbWVzIGxpbWl0YXRpb25zIG9mIGFsbCBhYm92ZSAjNCB1c2UgY2FzZXMNCg0KMi4g
dGMgZ2l2ZXMgdGhlIGFiaWxpdHkgdG8gbWlycm9yIHNwZWNpZmljIHRyYWZmaWMgYmFzZWQgb24g
bWF0Y2ggY3JpdGVyaWEgaW5zdGVhZCBvZiBwcm9wb3NlZCBfYWxsX3ZmXyB0cmFmZmljDQpUaGlz
IGlzIHVzZWZ1bCBhdCBoaWdoIHRocm91Z2hwdXQgVkZzIHdoZXJlIGZpbHRlciBpdHNlbGYgaGVs
cHMgdG8gbWlycm9yIHNwZWNpZmljIHBhY2tldHMuDQpBdCB0aGUgc2FtZSB0aW1lIG1hdGNoYWxs
IGNyaXRlcmlhIGFsc28gd29ya3MgbGlrZSB0aGUgcHJvcG9zZWQgQVBJLg0KDQpJIGRvIG5vdCBr
bm93IHRoZSBuZXRkZXYgZGlyZWN0aW9uIGZvciBub24gc3dpdGNoZGV2IChsZWdhY3kpIHNyaW92
IG5pY3MuDQo=
