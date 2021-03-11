Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30723371FC
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhCKME6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:04:58 -0500
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:48449
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232978AbhCKMEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 07:04:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRyoW3jI/4veYHKPdjc2QfpHN/+WuPyyVbSZKVOwx31QkSNJO82rVB/2FB+/oYxRD4YJW2oEW7P8uaJ1APNzczGOElZjwy+LawsMgjcDyhP0H2Gz56LMw/ehpJA4qJWFEbLNU0botuokmbsFqdSN8Xa2bQowhWzZiieMh6e1dA3owEddmwlZBtTWaQC4ydLp4B8/XmpEAV3Z4hI3HotEkdNCJm1AC2n0sy6sk+bOs5dLekR4ZL+GjZM9ucPpbBKKb/TGuYLS2Uo9OjV2+QB09nMVxJaJM17J9B6hf3K1LtC1f1IksdceJTHrBBb98LEzOFBEEHFU0iM5haDLuDRW2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7Hcr0tH0h9iPsd35l9Jg4/AX1zXyENp3lQL7LSiPyk=;
 b=j9RckyEeFXSyeD4n3+KXIWFQWywEPupnj4ZwNebwzXfBuwzZtWmSWnNnDbDP0dfgqdGg3xfi90DREf/g7twKdTg9J4kpMtAbD+tbPqHLu9gyovOK2qBiz5UbSSQa8BM8k02Y90O4Lv+bVhNym7SKA7A5/fNLiiAWRyVotJcQEx54muXFWe4V/FCmojKX0YmQ5PGxxozPnIwxXXhYba5K2o/wcQCFmc8tnwIVSO9d8Ipy65sDxNYtT+dRZNdPT+BjKjdWQlhrgrMJECHBeiKFej6KOA9T6tdiDJwry2Od7M1LV+koo1anGhXpvZURSq1jLm480qsL3/uVP4q3+RKyOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7Hcr0tH0h9iPsd35l9Jg4/AX1zXyENp3lQL7LSiPyk=;
 b=fb0uFXyc0N4Kl85OFuH8PNObD035m6aRsYK9mxJ5/AiyDGyawPSYFerfMlEsDqnJ33YA6okqBGeTlnOl77RG2QgBfr6pJANxectYoFJuUgFCHiPFFWtt7hVNX/5NQsWYi6X5QsVvZfYurTS2xhV8JHQbFDjLnjsIOGjiG16KoMs=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4283.eurprd04.prod.outlook.com (2603:10a6:5:27::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Thu, 11 Mar
 2021 12:04:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 12:04:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: stmmac driver timeout issue
Thread-Topic: stmmac driver timeout issue
Thread-Index: AdcQ9/Umlq/KuFvES3u+uwMRD4Mb7wAXn2MAAK9w8SAADAxMAACJiG2w
Date:   Thu, 11 Mar 2021 12:04:28 +0000
Message-ID: <DB8PR04MB6795BCB93919DF684CA8DA79E6909@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <DB8PR04MB679570F30CC2E4FEAFE942C5E6979@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8a996459-fc77-2e98-cc0c-91defffc7f29@gmail.com>
 <DB8PR04MB6795BB20842D377DF285BB5FE6939@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <49fedeb2-b25b-10d0-575f-f9808a537124@gmail.com>
In-Reply-To: <49fedeb2-b25b-10d0-575f-f9808a537124@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 441c38bd-50dd-4d5a-3775-08d8e485d231
x-ms-traffictypediagnostic: DB7PR04MB4283:
x-microsoft-antispam-prvs: <DB7PR04MB42834B188DF79A093D3A4AC2E6909@DB7PR04MB4283.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n/Nl7hefuyso24os63zRFsDOdixOrNzcrgWOwqvhPhahr2iDHyjcwglOJW/J8iCnxnjiBA7Jp+uhTfy60xzZZpHe0bZ/eZgG6J5KnSGEG6VPdV1gKso5sfOI/lzfhqiu9BpTJ9zKpl7e984xTk95TZTc94herUNrEgABcoAWow233Qww969Mx8I6F9fAWZ1g+7ywroUg/qL6rw7g2ClBH5eIGMUv4LzHv7sCwlXBpJci2lLKTzWL7DOOl0hf52OwIOVXxwQDrKfcV0W/lCa0HO6T9zXWBw327lEcYC/wWD4LPA60dcX543p/2PKES4p2WQEIYftGzU2vuVP11KsQGawamOZev/NDOoGvq9HtUZHJUuFuZjnk+dFd8ezgNH8PmvCLU+/28rJtleJEkcFThaRH6ZZWQFmgxwgL4jBYDZ10HICB3JiX4iGtaoMPWV3NUZ+BptlIHn9eO2dObUkRmzcSfcAD2KeUgSw0FNRgFEPEkD9GJcnCIG/UfvieJ6yFquZjXgYxcV/8zL4trKPoMrhGLFevHFm75l0G2mOjzd+0kmrFqw0kksMDikQWWh+h2MDjycQHNfhkEKB/00B+bsjoQY3x1ygN61y/SWJegAc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(66476007)(8936002)(316002)(478600001)(2906002)(966005)(33656002)(6506007)(8676002)(4326008)(71200400001)(76116006)(55016002)(66946007)(83380400001)(5660300002)(186003)(7696005)(110136005)(45080400002)(53546011)(26005)(86362001)(3480700007)(9686003)(52536014)(64756008)(66446008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?WlZrR2ZSQVFrZlR1dTBLSERGWnZ1SUxCbmI0TGZnbFBNWmF2cVAzREJjU1VT?=
 =?gb2312?B?N3FGNEFPT0JSeGFTR0htcVRiL3gyT2RNcWVrMGQxQy9pWFUxYkM3R1RTNkdE?=
 =?gb2312?B?SkRKUlNRU3pUT2dOajgzMFNoWllXaTdjNUwrV1BLckNRd2w2d2JUVE5iRDV6?=
 =?gb2312?B?UG43T0NlNlVRNHVWcUE2dTE5dFNNQ1NBSGhMVVhWbzcvQ0ZvVk5PR2ZHTXN6?=
 =?gb2312?B?ZkpVbWlDWjZIZGw3M2pQN1NQUmUzTDJiWmc0QWUyRSt2cDJ0ZjZFUFBrblVl?=
 =?gb2312?B?RmVFd2l1a3NQNEk4OHBZc3ljS3UzTkFZcUd0N2l5bHBnaFRONXhkcDFzYWdK?=
 =?gb2312?B?ZXhHWC9tUHM1dzZUZnVSdCtqak5nOTFHUXFhU3M0ZGp0V0tUQ0ZMRWZFamFY?=
 =?gb2312?B?aVdZbWMzN2ZweFlyeDZBTno2b25nZlF0aXFsY3B5WTV3SXV4QWxsZzQwRHZm?=
 =?gb2312?B?aDBqTk1CQzNzUWNDVXBMdFg0TVBKNUJVVmZLVEs1ais4bnVJS1ZTMjlQRENt?=
 =?gb2312?B?YzdUVURNWmZ3NnY3SkdZMGQ0eFltODJuc2tKVEtZRWZyVGNFNnVHOGJ5Q3kz?=
 =?gb2312?B?N0F3S3o3OW1zWDhZQlgyRmtFK3NHSUxNY29BNElOY1lUZHdISytqK0Z0QzJP?=
 =?gb2312?B?UVRzaGVib25RUEVHVmRIbnNZdngwWjB5aWtKWXVnZ1RyaFBxamM0UGNhTjB0?=
 =?gb2312?B?UTdnZEJpS1hZZGFLSkpNOWZyMXdlMWpRdUxUZ2Z4VEtwRVI2eHpYcVBhc1d2?=
 =?gb2312?B?K2djTkthU091dnRXS0NNRlRoM0crREorTUdCWHY1UmdBd0RNNXNaUVorR3JL?=
 =?gb2312?B?bWZQTmNrMDVUQUtiQWVSQ1VZMWZYdWtRenVubHovSmUzeGRUTnZ5UnlTcFBK?=
 =?gb2312?B?eDFkV0NTd1JYV2cvcThsQ01OZ3R2bXlpSytQWWtSdVBNQlp1RElPcGlBc2pT?=
 =?gb2312?B?Y3A4WUluWTJua3liWkZPY0JGK1c5SkN4bmxXUHhJWGQ5UXFjQnZUaWtDY2RW?=
 =?gb2312?B?Z0hEM0p2T3Q2Si8xejMvbW1Ka1Z5d09oRVNMenpBVXJJMyt6cmVNQjdyWUN3?=
 =?gb2312?B?WHBleVlsNlYxdUFvWmgvOHNlOXBvakg4ak9wSmpYSC9BUHJZVnVRTXNhUURq?=
 =?gb2312?B?N0gxbEhnNy91YStMc3AyaE9vNjM1RWpFRXl4Z1pPcExiNGU3ZW9BZXRocVRH?=
 =?gb2312?B?M09VSkRNWFMyWE96eHphZmhuaDZtZGxoK0duZTBqZ3FWVkk5VjlDaDBwWnRD?=
 =?gb2312?B?d2dOZHY2UGY1OVdFQWZLakc2RjFEMmZaRGJKS0Exa1lQaWpwNHdVdWhjb2hq?=
 =?gb2312?B?cFIwZmhGMStSaE51dnB3eUQwZU5QT1RudjVMUmJTaDhibVRhLzF0bGtOQzVZ?=
 =?gb2312?B?U1NBUGExT2xMemFCZVZhdUI3dzBaU2VjMEFwZE1lSWdsbjFqaWhnVW1LcGNz?=
 =?gb2312?B?UkZKTnRGVlBFN2xCWEhlc2gzSkh0WHlFY0hnK1FoMThtVHR4L3R1cUZCZjNW?=
 =?gb2312?B?V29kek1UL0Y5Z2VUWVNTUFU5QmJUOEZ1SEpyeUlrMU42aWZ6b090RU9qTndS?=
 =?gb2312?B?c0hlSmY1QlBMWkROa1ZPRTZUZ01LTVdtQ0UwREU2Ym95NTFOODFyMTh1VWJC?=
 =?gb2312?B?Zk82ODlWek5yNkE1NnFESkYvUnVOYUJsVG9BYk1HekVhV0hJdzB1UTVkc3lw?=
 =?gb2312?B?Z1kxMnNYYUYyZmlmUmNPM0RoWUpxZnJUeTdDV3Z4UnNqbnphQ1RXTXhOUG93?=
 =?gb2312?Q?NaWvgN/jyGl4QHAFjXQOZfk/nuZtuVpPaEqLApE?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 441c38bd-50dd-4d5a-3775-08d8e485d231
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 12:04:28.0681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQavyOhew8P9LYkinpKDf1xUNPnwUh0FGNICMXy3xI4Uth7ZyqUgdlfJJcCZELgfo4B74HugaSoDMVKDY+gsuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4283
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZsb3JpYW4gRmFpbmVsbGkg
PGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiAyMDIxxOoz1MI5yNUgMTo1Nw0KPiBUbzog
Sm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IEpha3ViIEtpY2luc2tpDQo+
IDxrdWJhQGtlcm5lbC5vcmc+OyBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+IENjOiBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBzdG1tYWMgZHJpdmVyIHRpbWVv
dXQgaXNzdWUNCj4gDQo+IE9uIDMvOC8yMSA0OjQ1IEFNLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+
ID4NCj4gPiBIaSBGbG9yaWFuLCBBbmRyZXcsDQo+ID4NCj4gPiBUaGFua3MgZm9yIHlvdXIgaGVs
cCwgYWZ0ZXIgZGVidWcsIEl0IHNlZW1zIHJlbGF0ZWQgdG8gUEhZKFJUTDgyMTFGREkpLiBJdA0K
PiBzdG9wIG91dHB1dCBSWEMgY2xvY2sgZm9yIGRvemVucyB0byBodW5kcmVkcyBtaWxsaXNlY29u
ZHMgZHVyaW5nDQo+IGF1dG8tbmVnb3RpYXRpb24sIGFuZCB0aGVyZSBpcyBubyBzdWNoIGlzc3Vl
IHdpdGggQVI4MDMxLg0KPiA+IFdoZW4gZG8gaWZ1cC9pZmRvd24gdGVzdCBvciBzeXN0ZW0gc3Vz
cGVuZC9yZXN1bWUgdGVzdCwgaXQgd2lsbA0KPiA+IHN1c3BlbmQgdGhlbiByZXN1bWUgcGh5IHdo
aWNoIGRvIHBvd2VyIGRvd24gYW5kIHRoZW4gY2hhbmdlIHRvIG5vcm1hbA0KPiA+IG9wZXJhdGlv
bi4oc3dpdGNoIGZyb20gcG93ZXIgdG8gbm9ybWFsIG9wZXJhdGlvbikNCj4gPg0KPiA+IFRoZXJl
IGlzIGEgbm90ZSBpbiBSVEw4MjExRkRJIGRhdGFzaGVldDoNCj4gPiBOb3RlIDI6IFdoZW4gdGhl
IFJUTDgyMTFGKEkpL1JUTDgyMTFGRChJKSBpcyBzd2l0Y2hlZCBmcm9tIHBvd2VyIHRvDQo+IG5v
cm1hbCBvcGVyYXRpb24sIGEgc29mdHdhcmUgcmVzZXQgYW5kIHJlc3RhcnQgYXV0by1uZWdvdGlh
dGlvbiBpcyBwZXJmb3JtZWQsDQo+IGV2ZW4gaWYgYml0cyBSZXNldCgwLjE1KSBhbmQgUmVzdGFy
dF9BTigwLjkpIGFyZSBub3Qgc2V0IGJ5IHRoZSB1c2Vycy4NCj4gPg0KPiA+IEZvcm0gYWJvdmUg
bm90ZSwgaXQgd2lsbCB0cmlnZ2VyIGF1dG8tbmVnb3RpYXRpb24gd2hlbiBkbyBpZnVwL2lmZG93
biB0ZXN0IG9yDQo+IHN5c3RlbSBzdXNwZW5kL3Jlc3VtZSwgc28gd2Ugd2lsbCBtZWV0IFJYQyBj
bG9jayBpcyBzdG9wIGlzc3VlIG9uDQo+IFJUTDgyMTFGREkuIE15IHF1ZXN0aW9uIGlzIHRoYXQs
IElzIHRoaXMgYSBub3JtYWwgYmVoYXZpb3IsIGFsbCBQSFlzIHdpbGwNCj4gcGVyZm9ybSB0aGlz
IGJlaGF2aW9yPyBBbmQgTGludXggUEhZIGZyYW1lIHdvcmsgY2FuIGhhbmRsZSB0aGlzIGNhc2Us
IHRoZXJlIGlzDQo+IG5vIGNvbmZpZ19pbml0IGFmdGVyIHJlc3VtZSwgd2lsbCB0aGUgY29uZmln
IGJlIHJlc2V0Pw0KPiANCj4gSSBkbyBub3QgaGF2ZSBleHBlcmllbmNlIHdpdGggUmVhbHRlayBQ
SFlzIGhvd2V2ZXIgd2hhdCB5b3UgZGVzY3JpYmUgZG9lcw0KPiBub3Qgc291bmQgY29tcGxldGVs
eSBmYXIgb2ZmIGZyb20gd2hhdCBCcm9hZGNvbSBQSFlzIHdvdWxkIGRvIHdoZW4NCj4gYXV0by1w
b3dlciBkb3duIGlzIGVuYWJsZWQgYW5kIHdoZW4gdGhlIGxpbmsgaXMgZHJvcHBlZCBlaXRoZXIg
YmVjYXVzZSB0aGUNCj4gUEhZIHdhcyBwb3dlcmVkIGRvd24gb3IgYXV0by1uZWdvdGlhdGlvbiB3
YXMgcmVzdGFydGVkIHdoaWNoIHRoZW4gbGVhZHMgdG8NCj4gdGhlIFJYQy9UWEMgY2xvY2tzIGJl
aW5nIGRpc2FibGVkLg0KPiANCj4gRm9yIFJHTUlJIHRoYXQgY29ubmVjdHMgdG8gYW4gYWN0dWFs
IFBIWSB5b3UgY2FuIHByb2JhYmx5IHVzZSB0aGUgc2FtZQ0KPiB0ZWNobmlxdWUgdGhhdCBEb3Vn
IGhhZCBpbXBsZW1lbnRlZCBmb3IgR0VORVQgd2hlcmVieSB5b3UgcHV0IGl0IGluIGlzb2xhdGUN
Cj4gbW9kZSBhbmQgaXQgbWFpbnRhaW5zIGl0cyBSWEMgd2hpbGUgeW91IGRvIHRoZSByZXNldC4g
VGhlIHByb2JsZW0gaXMgdGhhdCB0aGlzDQo+IHJlYWxseSBvbmx5IHdvcmsgZm9yIGFuIFJHTUlJ
IGNvbm5lY3Rpb24gYW5kIGEgUEhZLCBpZiB5b3UgY29ubmVjdCB0byBhIE1BQw0KPiB5b3UgY291
bGQgY3JlYXRlIGNvbnRlbnRpb24gb24gdGhlIHBpbnMuIEkgYW0gYWZyYWlkIHRoZXJlIGlzIG5v
IGZvb2wgcHJvb2YNCj4gc2l0dWF0aW9uIGJ1dCBtYXliZSB5b3UgY2FuIGZpbmQgYSB3YXkgdG8g
Y29uZmlndXJlIHRoZSBTVE1NQUMgc28gYXMgdG8gcm91dGUNCj4gYW5vdGhlciBpbnRlcm5hbCBj
bG9jayB0aGF0IGl0IGdlbmVyYXRlcyBhcyBhIHZhbGlkIFJYQyBqdXN0IGZvciB0aGUgdGltZSB5
b3UNCj4gbmVlZCBpdD8NCj4gDQo+IFdpdGggcmVzcGVjdCB0byB5b3VyIG9yaWdpbmFsIHByb2Js
ZW0sIGxvb2tzIGxpa2UgaXQgbWF5IGJlIGZpeGVkIHdpdGg6DQo+IA0KPiBodHRwczovL2V1cjAx
LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZnaXQu
a2Vybg0KPiBlbC5vcmclMkZuZXRkZXYlMkZuZXQlMkZjJTJGOWE3YjM5NTBjN2UxJmFtcDtkYXRh
PTA0JTdDMDElN0NxaWFuDQo+IGdxaW5nLnpoYW5nJTQwbnhwLmNvbSU3Q2I3ZTgzNjcxYjAxODQ0
NzEwMjA3MDhkOGUyNWI4Y2E2JTdDNjg2ZWENCj4gMWQzYmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1
JTdDMCU3QzAlN0M2Mzc1MDgyMzAxMTM0NDIwOTYlN0NVbmsNCj4gbm93biU3Q1RXRnBiR1pzYjNk
OGV5SldJam9pTUM0d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxDQo+IGhhV3dp
TENKWFZDSTZNbjAlM0QlN0MxMDAwJmFtcDtzZGF0YT1MUFk0ZmF6dUpGQU9hbm5jdUdsbDFqR0s4
Vw0KPiBieGlSMmlaNUtmdXVhQWs5OCUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiANCj4gb3IgbWF5YmUg
dGhpcyBvbmx5IHdvcmtzIG9uIHRoZSBzcGVjaWZpYyBJbnRlbCBwbGF0Zm9ybT8NCg0KVGhhbmtz
IEZsb3JpYW4sIEkgYWxzbyBub3RpY2VkIHRoYXQgcGF0Y2gsIGJ1dCB0aGF0IHNob3VsZCB3b3Jr
IGZvciBkcml2ZXIgcmVtb3ZlLiBUaGUga2V5IGlzIFJYQyBub3Qgc3RhYmxlIHdoZW4gYXV0by1u
ZWdvIGF0IG15IHNpZGUuDQoNCkkgaGF2ZSBhIHF1ZXN0aW9uIGFib3V0IFBIWSBmcmFtZXdvcmss
IHBsZWFzZSBwb2ludCBtZSBpZiBzb21ldGhpbmcgSSBtaXN1bmRlcnN0YW5kaW5nLg0KVGhlcmUg
YXJlIG1hbnkgc2NlbmFyaW9zIGZyb20gUEhZIGZyYW1ld29yayB3b3VsZCB0cmlnZ2VyIGF1dG8t
bmVnbywgc3VjaCBhcyBzd2l0Y2ggZnJvbSBwb3dlciBkb3duIHRvIG5vcm1hbCBvcGVyYXRpb24s
IGJ1dCBpdCBuZXZlciBwb2xsaW5nIHRoZSBhY2sgb2YgYXV0by1uZWdvIChwaHlfcG9sbF9hbmVn
X2RvbmUpLCBpcyB0aGVyZSBhbnkgc3BlY2lhbCByZWFzb25zPyBJcyBpdCBwb3NzaWJsZSBhbmQg
cmVhc29uYWJsZSBmb3IgTUFDIGNvbnRyb2xsZXIgZHJpdmVyIHRvIHBvbGwgdGhpcyBhY2ssIGlm
IHllcywgYXQgbGVhc3Qgd2UgaGF2ZSBhIHN0YWJsZSBSWEMgYXQgdGhhdCB0aW1lLg0KDQpCZXN0
IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gLS0NCj4gRmxvcmlhbg0K
