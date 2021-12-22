Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABCD47CDCB
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 09:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243173AbhLVIB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 03:01:56 -0500
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:1934
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243161AbhLVIBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 03:01:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMqnqLg8ORze9felyAeW4g009+1Lm9DBI6yO9sef+cwZs4iID60uNJw85VNVjApFFtYPeADaTDaW31EO9TPWi49p4u+F4UI5zbpl4+l36QGZXntmReSCvurFJQWPl9Ytl9Q9Kfbts3GZ0v3Y8nv8oE+Ng+6KdVNO5a1nKyU7d3lKAR1eqZGZne9uvU0ltQWYzRGdBLJYyumRTZZz51NDaF+AODjZIVif0tXfy9uNfjJNikCQ9Eark243xu+Hjb/U9qFd7LTrItLFUs50ZjeHbo3i+itDvS1L65XG/AeFzjSjoxhBkkpHSwi4bkyEbmjanwxMEhvNkZekD3pIvad6Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yg50UBKvNp+oS+tXPh65j5H9S3W9ECV1d+CxDvmolMw=;
 b=ZaNLgjCo0dCnZF7u3CV49NW3TP6vcwxpN2UPd8Up1kjnGTNI7YvYqJf3gdAzLCZ93suXjOAfyo1AJjJI9wPn7cF2Mq+YKFBAYL8Ds6o9OY+KIjBgvPl9XFZ50X/Mex8L7Ts3wMkw0CgjDF+/jl3OtDtY40fYvvK0k9GJiokUOcXoalqAfdzmVwN1R+ph7u/QOoMEP1K0sN8dVKk2vutllaylcwdcP0JN8Rhz9s7mF1Z3g+yI0iTQS+k9CerXF/tG+Ia61s8e8MQkRjbBKoAyAjn95yVhI6L7KwazrK2+Zl3YVVSzM86K8Y/Tagy3HCCr8lLzSvM2SkbQSPdZSWZVgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yg50UBKvNp+oS+tXPh65j5H9S3W9ECV1d+CxDvmolMw=;
 b=gZA3jfZKgeM1CUS8ydvxOkwAUNOnbgaKo7s8DLBpP987XZcAWj0vz91u8MJB24tdPemLUIjmtVcTIEQPkoXItCx3KuxZgVb7ko9QF1XvsbCZQdeqKuMlN3WiAFQBEK8mBXqy7OZYIGlZKuJLOWgEne/TeozLpkQF3zpqJIKyZ2Q=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8429.eurprd04.prod.outlook.com (2603:10a6:10:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Wed, 22 Dec
 2021 08:01:53 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4801.020; Wed, 22 Dec 2021
 08:01:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Kegl Rohit <keglrohit@gmail.com>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: RE: net: fec: memory corruption caused by err_enet_mii_probe error
 path
Thread-Topic: net: fec: memory corruption caused by err_enet_mii_probe error
 path
Thread-Index: AQHX9wJwpZa+NCOeL0CnUi9XwRhob6w+IuGg
Date:   Wed, 22 Dec 2021 08:01:52 +0000
Message-ID: <DB8PR04MB679571AF60C377BB1242D26BE67D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <CAMeyCbj93LvTu9RjVXD+NcT0JYoA42BC7pSHumtNJfniSobAqA@mail.gmail.com>
In-Reply-To: <CAMeyCbj93LvTu9RjVXD+NcT0JYoA42BC7pSHumtNJfniSobAqA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e31fc8e4-fbd6-4bf5-e927-08d9c52150df
x-ms-traffictypediagnostic: DB9PR04MB8429:EE_
x-microsoft-antispam-prvs: <DB9PR04MB8429435900123CEB3EDDB144E67D9@DB9PR04MB8429.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RlHYL8w0zjHKhOgsDPffohCsUvwo2iSHgSh4SLuJdz/z6fATLCZi00V1WWq4l1QI7vgnjrn3OTr+GtcwaLb0WqMI37/odxBYk3yCAfbVxsAEuSDriVgCFJdZG7Oa3yvQ9WyXX1PlthkloeJSjpc1dWsb2YH8t10F4WiQjYY5EjmefZCJ0lnqnxOBpnAPEUVv1sJ1wMoGv/i+ZA9Dbnvypat7oazoCAOFREOi09elpIbSz1uhYzCDcUbaMkAwqxqXAxrlxGnxtYEXYV6sfnHhAciE492+00DQZX47CrkFUUDYv+VLzMu0hN6r8/t0/WlYKQ5yajRX83XDHk1CshCTvDcZbrVZtMi/nuXLieZto5/xJUBerngA9zwdb1WAkNPRoBzvlHMpPZVIc1943Ufv1Qt4DHoe9KAFRTwgoWucWG4QU27L8JrP6GeWxdq4bIgvNMSqX4SiniQnZ5OPqVlFotAXck2DchUacFRaEwNx4zXIIJVN7R3KQH2LXc59bba3bwSl9W244yFOxbPGngYBnkM8Eq+AujB0bVoFVlfcChULBt8dbEnswFbdisM9fH/hntgt6Y4kTZPrfEI6XOZjM48CaVZHhWWssKWe428kINX6XqAJ6YRfL4G1YQ/TVzIG0nhdOG555FfNMWMqcZn4KO9iuaf8lHtBpRYhqtJOgv0YDVgl+SrqqVNONeHsso9G5p5dZHKWutNtm//ZjuG2u98oYlp/qPUleE2QZHI1HWqvDxrWF8CLIywx32SUtSbmAKDOTN7dI3w25KtqIca3Wpto5PCWQkCYSseIVOcy+2U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(122000001)(5660300002)(83380400001)(38100700002)(52536014)(64756008)(66446008)(66476007)(76116006)(66946007)(66556008)(508600001)(26005)(7696005)(966005)(6506007)(53546011)(186003)(2906002)(316002)(55016003)(110136005)(33656002)(71200400001)(8936002)(8676002)(38070700005)(45080400002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bjRJTDZ6dHlWRkZ0UWNIQTdmdUIraVRraUpxT3VnN1U2TVI0NFlGYXNzQS9o?=
 =?gb2312?B?TWJHUHVOQnY2b245MTByWUl0b2piaWNianRUT2lzMFlmVGpNVy9iTnl0MVhF?=
 =?gb2312?B?K3ZXKzJNcEhaMnJEOSsrRkd3N3pPRzRiM1BrYmVXMDBDeGVSZzBZMzBtckpo?=
 =?gb2312?B?M05QalRsN1FFQ0Jsd1JyMFZNYVROanRIMmNadHRjK3E2UEFtSCtUaXBkVGZo?=
 =?gb2312?B?MXRNMHFCZndKcUl3MjJvUWtvQXovM1JxcXVtMFZXc0NGK2FsSDVvMGdEU0M4?=
 =?gb2312?B?ZUxZVENCeGVZd0RxUVlBNllsRTBSbFo3THNPS2dxMHFhZGdrUXF6MnFXZCsv?=
 =?gb2312?B?aVF2ZmRweTdwbE9kVzZuYlYycUdpQkxaNEdaNnF4NlAxVUJsZnZtbk9jRE5Q?=
 =?gb2312?B?L01jTU8yNkJxcjNZaTRwcEFTalZPN3lQS0VwcDJJZ0Q4QkhoRjRodzdtKzZV?=
 =?gb2312?B?eVBCcXIvVXAzbDd5bkgzMU1SN1BBZlU2aFhMdVNZUXZva1c3eGsyU2tackxk?=
 =?gb2312?B?K2F2NlhObFY0RHNDV3BWUDJTU2xiM3R3MWI5b0kzeSs1cjZRUi9qenFHOFlQ?=
 =?gb2312?B?cEMvYWwrNnVVUUFDTnNnN2F4UEw1RndnWGtnZ2NCUitySkRPcS8wLzJuazRu?=
 =?gb2312?B?ZzVySjhsdVkvc2RtZGNXN0RZMzkyUG9pNHFFUC9vcDdZN1BQWTY2ZnVianpu?=
 =?gb2312?B?NU1ITHVTUUp4RjF0VDFGWUdUT3A1ZFFtUkNDT2FjQktxdzVMOUpYUElid0Yw?=
 =?gb2312?B?dDc4YUhSTDVpaFBWcVNtVDVZTHhTU3drdUhYeHRuN2VLUGl2SW5tcFhuRmFz?=
 =?gb2312?B?VFdTSmdKcHA4U0ZNVE0zYURCSVVuQ0g0QnF6dTIyV2NRZXJuN1pKZHBMYXFk?=
 =?gb2312?B?YnV3L1BFODErempzbkg0dTBvb0YwNm1aSzZpVmhLcStVSFd1dHBuZjV2cS9v?=
 =?gb2312?B?QXo1aFFWY3dmUHk3UElTclBkYVJqRlBzZVIwV1k2aDFZckIyZjBEUFBNMVdB?=
 =?gb2312?B?TW14cEpEOEw5b2pGVE92c0liSzV4bDJZRngyMk5VLzl0bGZBbm1OY09iK05J?=
 =?gb2312?B?Q3MwRzlSOVMraEJ4cUVJRU5wZ09oQ0hVQXlMMDFYQnhtbTZ6ZWhWclhITWRE?=
 =?gb2312?B?a3A2bGlONVoxZ1kzTXRPRkRYMUJ4SGl0ejZXK1Y2MGpVN0NKRDVzSmRRSEsx?=
 =?gb2312?B?bEMyUDFVOGwzbVFKNW5CMHVETXJVK2R5dFZSdlFsVHA4YkR0S3ZhMjJDcHFr?=
 =?gb2312?B?L21mYnVhS3YxUTV2aStMUDhzc1pTc3VnRU05QjRENmNkV2x4Z3dXUk1HT25l?=
 =?gb2312?B?TDJVdEZKMXNIejFnMUl0NnJYamxwVERKejBOOFNwdVdCYzVqV0NtZVg5U2Qr?=
 =?gb2312?B?cmRQREJIbXh2YVk1Z2RLNVB6d29YNm93aHMxMnM1WFlCdjFrNEpvUEZkUHhn?=
 =?gb2312?B?MXYvbHB6MnNFQUhBTHl6Y1Q1QkNXbHNYbWdUMWFwT3NpWFZnbVQxSExxTmhS?=
 =?gb2312?B?M1RuUERDT2Y2Z2ZmeUxDWndMVXhIUjAvUzY4RGJSWlpTZU95eWM0eW9iczBO?=
 =?gb2312?B?Wjljck91T2o5Qkp4ajFmYTJGbW8wekZXaS9ta2dvVE9LN3ZZaHppTytLNHdy?=
 =?gb2312?B?a2ZzRW95TXpua2NpZDEzNXQ3Y3FxODE2dEQwZmZ0QUtSTnVISFR3ak5NVGJN?=
 =?gb2312?B?dmFSUmk0SEYrVWhNZ1JnWUZmQVZnc3NnU2JJTXdYQi80SmQvWlY1U3d1TERz?=
 =?gb2312?B?V1M0MExwemsvWW00emNkUVBKV3NVZlQ5TW1pTW5TRFVMUVFlU1ZUZXNHV2kr?=
 =?gb2312?B?enVCcFhhT1JwTWI5THE4dkRtS3QrQ2ZJeGtTM3gvaDAxZm9tVjhGRkVYNU0x?=
 =?gb2312?B?UXJEV1ppejJ5a1hMdG5CYm44SUxRQjcvQytGbytmb3krMGxCNDBreEc3STlN?=
 =?gb2312?B?VzZOVWxnbVYxWThmcjNlMll4aktDY3RvLzVHZGdORVRmcUsxeXpEeFlKQzQ5?=
 =?gb2312?B?WjQ3U1FtSXpIQ1BMTDRYdG93V0JRWjFGTS92R1lyejJyYThkUTdUMWxEMllU?=
 =?gb2312?B?bGNtUFo1MWM3bTFkOEtWMjB4MHFPQnpyQyt6MG1jL2QvbUsvNWZSSmhPODha?=
 =?gb2312?B?TDFWOVk5TkttT0pwSVhHRVcwNW44VFEycWw1YWh3YWJEUUpXajNFbk1HSnpW?=
 =?gb2312?B?Z1E9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e31fc8e4-fbd6-4bf5-e927-08d9c52150df
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 08:01:52.9905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AF0KKhiNo9GyumQV4Vc5dctYtHjXDgJ2c/fxBCVswgQ5xercExjt+Jyl5Wl3dSRP7/UfBitqQKUyn+8MxDtslw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBLZWdsLA0KDQpSZW1vdmluZyBBbmR5IER1YW4sIHNpbmNlIGhlIGhhcyBsZWZ0IE5YUCwg
YW5kIG1haWwgaXMgdW5hdmFpbGFibGUgYW55IGxvbmdlciwgdG8gYXZvaWQgbm9pc2UuDQoNCj4g
LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS2VnbCBSb2hpdCA8a2VnbHJvaGl0
QGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqMTLUwjIyyNUgMTU6MDYNCj4gVG86IG5ldGRldiA8
bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4NCj4gQ2M6IEFuZHkgRHVhbiA8ZnVnYW5nLmR1YW5Abnhw
LmNvbT4NCj4gU3ViamVjdDogbmV0OiBmZWM6IG1lbW9yeSBjb3JydXB0aW9uIGNhdXNlZCBieSBl
cnJfZW5ldF9taWlfcHJvYmUgZXJyb3INCj4gcGF0aA0KPiANCj4gSGVsbG8hDQo+IA0KPiBUaGVy
ZSBpcyBhbiBpc3N1ZSB3aXRoIHRoZSBlcnJvciBwYXRoIG9mIGZlY19lbmV0X21paV9wcm9iZSBp
bg0KPiBmZWNfZW5ldF9vcGVuKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KSB3aGljaCBsZWFkcyB0
byByYW5kb20gbWVtb3J5DQo+IGNvcnJ1cHRpb24uDQo+IA0KPiBJbiBvcGVuKCkgdGhlIGJ1ZmZl
cnMgYXJlIGluaXRpYWxpemVkOg0KPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9u
Lm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZnaXRodQ0KPiBiLmNvbSUyRnRvcnZhbGRz
JTJGbGludXglMkZibG9iJTJGdjUuMTAlMkZkcml2ZXJzJTJGbmV0JTJGZXRoZXJuZXQNCj4gJTJG
ZnJlZXNjYWxlJTJGZmVjX21haW4uYyUyM0wzMDAxJmFtcDtkYXRhPTA0JTdDMDElN0NxaWFuZ3Fp
bmcuemgNCj4gYW5nJTQwbnhwLmNvbSU3Q2M3NTExODI2ZDk2ODRlMmI5ZDM1MDhkOWM1MTk5MWQw
JTdDNjg2ZWExZDNiYzJiDQo+IDRjNmZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzElN0M2Mzc3NTc1
MzU4NzI5ODU2MDclN0NVbmtub3duJTdDDQo+IFRXRnBiR1pzYjNkOGV5SldJam9pTUM0d0xqQXdN
REFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxaGFXd2lMDQo+IENKWFZDSTZNbjAlM0QlN0Mz
MDAwJmFtcDtzZGF0YT1Gb3ZPYzR6M1JJdWF0RXJhV1dPOGxnY284c0llYThCMA0KPiAzUlZLTmQ4
M1FaYyUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiANCj4gVGhlbiBmZWNfcmVzdGFydCB3aWxsIHN0YXJ0
IHRoZSBETUEgZW5naW5lcy4NCj4gaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5v
dXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGZ2l0aHUNCj4gYi5jb20lMkZ0b3J2YWxkcyUy
RmxpbnV4JTJGYmxvYiUyRnY1LjEwJTJGZHJpdmVycyUyRm5ldCUyRmV0aGVybmV0DQo+ICUyRmZy
ZWVzY2FsZSUyRmZlY19tYWluLmMlMjNMMzAwNiZhbXA7ZGF0YT0wNCU3QzAxJTdDcWlhbmdxaW5n
LnpoDQo+IGFuZyU0MG54cC5jb20lN0NjNzUxMTgyNmQ5Njg0ZTJiOWQzNTA4ZDljNTE5OTFkMCU3
QzY4NmVhMWQzYmMyYg0KPiA0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MxJTdDNjM3NzU3NTM1
ODcyOTg1NjA3JTdDVW5rbm93biU3Qw0KPiBUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURB
aUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpTA0KPiBDSlhWQ0k2TW4wJTNEJTdDMzAw
MCZhbXA7c2RhdGE9RkFFYjlNQUdWbVZZdjRnZGlKcndoVDdrNFB5czgNCj4gVWxSTG55ZHBBSjZO
OTQlM0QmYW1wO3Jlc2VydmVkPTANCj4gDQo+IE5vdyBpZiBmZWNfZW5ldF9taWlfcHJvYmUgZmFp
bHMgKGUuZy4gcGh5IGRpZCBub3QgcmVzcG9uZCB2aWEgbWlpKSB0aGUNCj4gZXJyX2VuZXRfbWlp
X3Byb2JlIGVycm9yIHBhdGggd2lsbCBiZSB1c2VkDQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtz
LnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmdpdGh1DQo+IGIuY29t
JTJGdG9ydmFsZHMlMkZsaW51eCUyRmJsb2IlMkZ2NS4xMCUyRmRyaXZlcnMlMkZuZXQlMkZldGhl
cm5ldA0KPiAlMkZmcmVlc2NhbGUlMkZmZWNfbWFpbi5jJTIzTDMwMzEmYW1wO2RhdGE9MDQlN0Mw
MSU3Q3FpYW5ncWluZy56aA0KPiBhbmclNDBueHAuY29tJTdDYzc1MTE4MjZkOTY4NGUyYjlkMzUw
OGQ5YzUxOTkxZDAlN0M2ODZlYTFkM2JjMmINCj4gNGM2ZmE5MmNkOTljNWMzMDE2MzUlN0MwJTdD
MSU3QzYzNzc1NzUzNTg3Mjk4NTYwNyU3Q1Vua25vd24lN0MNCj4gVFdGcGJHWnNiM2Q4ZXlKV0lq
b2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazFoYVd3aUwNCj4gQ0pYVkNJ
Nk1uMCUzRCU3QzMwMDAmYW1wO3NkYXRhPVFMVDklMkJjT2tINyUyQmRSU1p6ZEl6cDZvcTByYw0K
PiB3bk95MHZmVk43U2E0WVRBTSUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiANCj4gZXJyX2VuZXRfbWlp
X3Byb2JlOg0KPiBmZWNfZW5ldF9mcmVlX2J1ZmZlcnMobmRldik7DQo+IGVycl9lbmV0X2FsbG9j
Og0KPiBmZWNfZW5ldF9jbGtfZW5hYmxlKG5kZXYsIGZhbHNlKTsNCj4gY2xrX2VuYWJsZToNCj4g
cG1fcnVudGltZV9tYXJrX2xhc3RfYnVzeSgmZmVwLT5wZGV2LT5kZXYpOw0KPiBwbV9ydW50aW1l
X3B1dF9hdXRvc3VzcGVuZCgmZmVwLT5wZGV2LT5kZXYpOw0KPiBwaW5jdHJsX3BtX3NlbGVjdF9z
bGVlcF9zdGF0ZSgmZmVwLT5wZGV2LT5kZXYpOw0KPiByZXR1cm4gcmV0Ow0KPiANCj4gVGhpcyBl
cnJvciBwYXRoIGZyZWVzIHRoZSBETUEgYnVmZmVycywgQlVUIGFzIGZhciBJIGNvdWxkIHNlZSBp
dCBkb2VzIG5vdCBzdG9wDQo+IHRoZSBETUEgZW5naW5lcy4NCj4gPT4gb3BlbigpIGZhaWxzID0+
IGZyZWVzIGJ1ZmZlcnMgPT4gRE1BIHN0aWxsIGFjdGl2ZSA9PiBNQUMgcmVjZWl2ZXMgbmV0d29y
aw0KPiBwYWNrZXQgPT4gRE1BIHN0YXJ0cyA9PiByYW5kb20gbWVtb3J5IGNvcnJ1cHRpb24gKHVz
ZSBhZnRlcg0KPiBmcmVlKSA9PiByYW5kb20ga2VybmVsIHBhbmljcw0KDQpBIHF1ZXN0aW9uIGhl
cmUsIHdoeSByZWNlaXZlIHBhdGggc3RpbGwgYWN0aXZlPyBNQUMgaGFzIG5vdCBjb25uZWN0ZWQg
dG8gUEhZIHdoZW4gdGhpcyBmYWlsdXJlIGhhcHBlbmVkLCBzaG91bGQgbm90IHNlZSBuZXR3b3Jr
IGFjdGl2aXRpZXMuDQoNCj4gU28gbWF5YmUgZmVjX3N0b3AoKSBhcyBjb3VudGVycGFydCB0byBm
ZWNfcmVzdGFydCgpIGlzIG1pc3NpbmcgYmVmb3JlIGZyZWVpbmcNCj4gdGhlIGJ1ZmZlcnM/DQo+
IGVycl9lbmV0X21paV9wcm9iZToNCj4gZmVjX3N0b3AobmRldik7DQo+IGZlY19lbmV0X2ZyZWVf
YnVmZmVycyhuZGV2KTsNCj4NCj4gSXNzdWUgaGFwcGVuZCB3aXRoIDUuMTAuODMgYW5kIHNob3Vs
ZCBhbHNvIGFsc28gaGFwcGVuIHdpdGggY3VycmVudCBtYXN0ZXIuDQoNCkl0J3MgZmluZSBmb3Ig
bWUsIHBsZWFzZSBzZWUgaWYgYW55b25lIGVsc2UgaGFzIHNvbWUgY29tbWVudHMuIElmIG5vdCwg
cGxlYXNlIGNvb2sgYSBmb3JtYWwgcGF0Y2gsIHRoYW5rcy4NCg0KQmVzdCBSZWdhcmRzLA0KSm9h
a2ltIFpoYW5nDQo=
