Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCA62EAC2D
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 14:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730331AbhAENo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 08:44:29 -0500
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:54020
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730161AbhAENo2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 08:44:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYZ6ni2RPZxX6bnGrIeWfhbaTKFRtZX29V9TFs59U/Dd4nnsiesjQyzmh69xBmcHMJslR423UhFXzaPXR+vLF7yoo2SZFTR0K4Y0RJRmK+4V7Brromh9YsuYUtN9SrEvD0Yug/zQ1hgu+G8pFhkuLYPhCC36HST4TdIg+npLhTi8nvV4cNuoGZR3FX4f3XOo1hm5MD1VgbDhD3WzpUa2jWs9IaHZRFap0d/EjBloyzQEm5e3n2yAer2/MgQ6tl0QqsY3E7dkzkO23f+8UrOe2/CG8Vl1BMAdku0eC/nClwq3Y8JCqMaSTikaXwUOOU5LOOFJ6POFf+rBOtsa3bqcnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuojyCcngk3MCxzqHuZaYn5Gvqe9d5KrUo+bx/97AsE=;
 b=D1MYiJSDiFPdiNUQUTe6OhjOY0NULxSs1XwK/LPl3Gj2A1dFhhEGJhp4GDuxAT7xru65TXbNwFwBh9+7dcoczwxBTVdMVCXMFhRgxcRDkITfTX2bm6bgBDFdY/feDEY9SRTLkz0WOeUDqATHyyP1c1Kmu+ZlVAtYo0TlMoo2WNif5Z7zSTaDscbDM0V/hYphGRVc8IAZN7sCybTV8rXoPL6SB/VAlbmJ0mJONOTTVW7VYT6hgjoybCM4ZoiEThpD7hQ+BEvsMiCPW1L+GahufVY+ZC2Xa2J+HXx4p4hqI4v3Z83sQSenGxQeuIsJCSFPnch3mHZtKS0fmg+wl2t7iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuojyCcngk3MCxzqHuZaYn5Gvqe9d5KrUo+bx/97AsE=;
 b=FDsq3PpdS7jfNXAM9i9HyZ4ourVeQ100ApCo4vyNynCG3F7vdZNucqW4AktL4tNYJWxVbxHO+FGfo7jgjTkxcNk1O5pV36pQI9jkEDLg6ZfXeu+rlMgaIaqWdo6+jVX4xsxZdp/Q0/8drsSnqMom1P8sPMaMnYDFRRifJAeK7dQ=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3769.eurprd04.prod.outlook.com (2603:10a6:8:f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 13:43:39 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%6]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 13:43:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: suspend/resume issue in stmmac driver
Thread-Topic: suspend/resume issue in stmmac driver
Thread-Index: AdbjaAEgRGVfkAJ/SnOy7AGFKHPsnA==
Date:   Tue, 5 Jan 2021 13:43:39 +0000
Message-ID: <DB8PR04MB67950F82563DF00432D4E56AE6D10@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 10b52210-8e79-4a68-d894-08d8b17fe87f
x-ms-traffictypediagnostic: DB3PR0402MB3769:
x-microsoft-antispam-prvs: <DB3PR0402MB37696A5333F1D831C6947472E6D10@DB3PR0402MB3769.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k4Nj7PKChjLtAEnPVWt2VUUHYhkjP6KLnleukMzJefUzS7FEdEoSk2y5Ikoy2RrNV4QPu5Yd1vqIi9fI9l9UASygAGUIfYJ2BXb/DIjDQVaV8WT7/eQu5NLEKrb+UPiqaKSQFm2eVw/rKBw0Ro4ltyQQ6gikpW+N+Q+67S58J+0Bs4JTwAD0SjMvsPszEpUxPO6cHpmrdNcelhndAKf6sdB8X47sIa7iLEyLg4RGeqyKOEwmjYsAVC0tl8jm0nTkesuQSZ1Bww+BabRrvHz5H6x5k6Fxwg1kjRRSrrvUG+OOcde51BVI6cDEDym3X1njyn4uORsyk5+O/viG+JtbuwyuUtopj0RUsidYaObs3ltWkeCXnzMKW8r4SV6booHas3Wcrbtuv+nRU0MgLp29/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(39850400004)(376002)(54906003)(76116006)(66556008)(2906002)(55016002)(66946007)(83380400001)(64756008)(66446008)(8936002)(52536014)(110136005)(186003)(9686003)(316002)(15650500001)(6506007)(26005)(86362001)(5660300002)(66476007)(478600001)(7696005)(33656002)(4326008)(71200400001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MGFQeEpZdWUveExlbFBVamxQekRyOTZuRjNYbVdpVTVuYXJOSG1CK255cU9a?=
 =?utf-8?B?V050dFdBRGZoa1Y4S0V2b2hGRm1NamdBSVpqbzFXektNdi9rZ041aUEvdStV?=
 =?utf-8?B?a1grRWtDOXZRUlVNcytCZTFxWFZJVVdURmd6N1NlbG9GMktNRDN0cGR1Rzcz?=
 =?utf-8?B?RHpjY0VoNHQ3UGl0eThwbGhmVmZBc0hWUkdTdDIvQk5HR0NtWUdWTlVlRHdm?=
 =?utf-8?B?V1FUQXNObEErR3N2N3ZLZEp2ZWJWcUhnWjhpTW0vRmcvL0pQMEhOVnQyUG56?=
 =?utf-8?B?ejZOTzdkdjA2emorSzFtS3JSdVBrWHpoMEx5V2ZndUwyaXlFQWdBYUF3Qkpn?=
 =?utf-8?B?RWhCMENqMy84WWVjcmNwcjZwekFEUmNOZXE4LzVKaExrMWQvYzRzc2VxUVVY?=
 =?utf-8?B?ZUtTVlF4NzdoY1ovbEE4SjFTVmxIS01ZSTBGV05FSmJyb1FkT1c0ZDJvU0Fs?=
 =?utf-8?B?SkE3U2J3R3VBSFR0SFg2Z2xrZGtucDNBNlBLRU5HWXFxZVY0bzhob01KVnVs?=
 =?utf-8?B?dGtrQnkxdC9ZTmowYWZYNUlEVVEwLzVwYVAxUEd0UjNKaXVZZnNTVHR4TjV6?=
 =?utf-8?B?L2FNakk1cEdvcmZ6SFhEOWFnb3hPWXJnRTVVUEZSSXVxT2poWjBmRHpFeW5H?=
 =?utf-8?B?aTZncnFxUko0N2h3bzU0bTNHTzFHczhxM3BvbVpHbWU1R0NNUTdoaW96anZT?=
 =?utf-8?B?dGpoWkliSWczbnBINEZxSFZLWFdWeEhOVmN6bzEyeEE3Vk1zeWpEWTNUb0ln?=
 =?utf-8?B?MFM2YUFUbzJzN1NGMFBIMTFIbkxGenBxbjkyWWF1MGNjbG9tWEJ4Z0N5TFpO?=
 =?utf-8?B?R21zM0l2QmJZQmhHTWd3bGNWaHZOZnVCY0kzUEVYQU5zSkRuWXFmK3VxV01U?=
 =?utf-8?B?bmJWOE9IK3M0Qko2K3Y1QVBBaHo1d1Ywa21vRnRxVVdiREpQeE1XYTZXeDJv?=
 =?utf-8?B?azBLNHg5Tnhwa2pQM3lHKzY3Z094K1JXa2hGcjYyVFQ3K1g1YzkvVy9pMFE0?=
 =?utf-8?B?QklNMC9RSmxhbnZoUTA5M1M4NVptY0dpYURDS3lvYndCOUg1Q3RmdmpUMkJx?=
 =?utf-8?B?OFZPV1UxM0ZhcVBnb2lYOG5nQ3YrcW1NMzRqRmlwand0Y1Q3ejNVMFF1MjhX?=
 =?utf-8?B?TWNPZDJEK3pmRHJLMHUwK3p0eTJib0RaTFRkRG5pbTl2MnhXcUtFOVMxNndh?=
 =?utf-8?B?M0ViQ2lUTHNqbFJWZlV6VzZEOGVUR2VXTkd5NXV3aWs2aDd4TkxqcytUUTFQ?=
 =?utf-8?B?eGxCaG96WFVYejNSKy9LN3hqOWZ4bWorY2NjSCtLdElmL2xMVmYwb29mNG1T?=
 =?utf-8?Q?xpIrR9/6/ZtLw=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b52210-8e79-4a68-d894-08d8b17fe87f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 13:43:39.2172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8FXev4bo3zieM34iIZP8h+tm4Dh3YN1tVTQTnnA4vFVJS/rb0Z1OGLF35Ado3+gSqGT754sAd1AUCcVgFZW0ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3769
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBndXlzLA0KDQpXaGVuIEkgZG8gc3VzcGVuZC9yZXN1bWUgc3RyZXNzIHRlc3Qgd2l0aCBz
dG1tYWMgZHJpdmVyLCBJIGVuY291bnRlcmVkIHNvbWUgdHJpY2t5IGlzc3Vlcy4gRFdDIEVRT1Mg
dmVyc2lvbiBpcyA1LjEwLCBMaW51eCBrZXJuZWwgdmVyc2lvbiBpcyA1LjEwLg0KDQoxLiBUaGUg
Zmlyc3QgaXNzdWUgaXMgbmV0IHdhdGNoZG9nIHRpbWVvdXQuDQpzdG1tYWNfeG1pdCgpIGNhbGwg
c3RtbWFjX3R4X3RpbWVyX2FybSgpIGF0IHRoZSBlbmQgdG8gbW9kaWZ5IGEgdGltZXIgdG8gZG8g
dGhlIHRyYW5zbWlzc2lvbiBjbGVhbnVwIHdvcmsuIEltYWdpbmUgc3VjaCBhIHNpdHVhdGlvbiwg
c3RtbWFjIGVudGVycyBzdXNwZW5kIGltbWVkaWF0ZWx5IGFmdGVyIHN0bW1hY194bWl0KCkgbW9k
aWZ5IHR4IHRpbWVyLA0Kc3RtbWFjX3R4X2NsZWFuKCkgd291bGQgbm90IGJlIGludm9rZWQsIHRo
aXMgY291bGQgYWZmZWN0IEJRTChJIHN0aWxsIGRvbid0IGtub3cgdGhlIHNwZWNpZmljIHJlYXNv
biksIHNpbmNlIG5ldGRldl90eF9jb21wbGV0ZWRfcXVldWUoKSBoYXZlIG5vdCBiZWVuIGludm9s
dmVkLCBhbmQgdGhlbiBkcWxfYXZhaWwoJmRldl9xdWV1ZS0+ZHFsKSBmaW5hbGx5IGFsd2F5cyBy
ZXR1cm4gYSBuZWdhdGl2ZSB2YWx1ZS4NCglfX2Rldl94bWl0X3NrYigpIC0+IHFkaXNjX3J1bigp
IC0+IF9fcWRpc2NfcnVuKCkgLT4gcWRpc2NfcmVzdGFydCgpIC0+IGRlcXVldWVfc2tiKCk6DQog
ICAgICAgICBpZiAoKHEtPmZsYWdzICYgVENRX0ZfT05FVFhRVUVVRSkgJiYNCiAgICAgICAgICAg
ICBuZXRpZl94bWl0X2Zyb3plbl9vcl9zdG9wcGVkKHR4cSkpICAvLyBfX1FVRVVFX1NUQVRFX1NU
QUNLX1hPRkYgYml0IGlzIHNldA0KQWZ0ZXIgY2hlY2tpbmcgdGhpcywgbmV0IGNvcmUgd2lsbCBz
dG9wIHRyYW5zbWl0dGluZyBhbnkgbW9yZS4gQXMgYSByZXN1bHQsIG5ldCB3YXRjaGRvbmcgd291
bGQgdGltZW91dC4gVG8gZml4IHRoaXMgaXNzdWUsIHdlIHNob3VsZCBjYWxsIG5ldGRldl90eF9y
ZXNldF9xdWV1ZSgpIGluIHN0bW1hY19yZXN1bWUoKS4NCg0KMi4gVGhlIHNlY29uZCBpc3N1ZSBp
cyBSeCBjaGFubmVsIGZhdGFsIGJ1cyBlcnJvci4NCkR1cmluZyBzdXNwZW5kL3Jlc3VtZSB0ZXN0
LCBSeCBjaGFubmVsIHJlcG9ydCBmYXRhbCBidXMgZXJyb3IgYXQgYSBoaWdoIHBvc3NpYmlsaXR5
KGFuZCByZXBvcnQgbWFueSB0aW1lcyksIGJ1dCB0aGVyZSBpcyBubyBoYW5kbGVyIGZvciB0aGlz
IHNpdHVhdGlvbiBpbiBzdG1tYWMgZHJpdmVyLiBEbyB5b3Uga25vdyB3aGF0IHdvdWxkIGNhdXNl
IFJ4IGNoYW5uZWwgZmF0YWwgZXJyb3I/IEFuZCBob3cgdG8gaGFuZGxlIGl0Pw0KSSBkaWQgc29t
ZSB3b3JrLCBidXQgbm93IHN0aWxsIGNhbid0IGZpeCBpdC4NCg0KVGhhbmtzIGEgbG90IGluIGFk
dmFuY2UuIPCfmIoNCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQoNCg==
