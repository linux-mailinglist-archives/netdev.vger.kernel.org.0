Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE4B31A97C
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhBMB3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:29:10 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:10279 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229648AbhBMB3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:29:08 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D1SGqj012914;
        Fri, 12 Feb 2021 20:28:16 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2058.outbound.protection.outlook.com [104.47.61.58])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hrw92smc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 20:28:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsJ7wM1bjpzoavosfWEnao9CDBZAYvOpWtlUXHu6cdv5Zl8zIcqeFMBIf6Ea6oRjvInJdkhCTy8H9Sm/8zT4oYXe9lRi/hxvDoCHLco4gN2jsYmU14CjZb/y7unPe1R5T9YvGbb5Wmmhu2hp7rGdsA2/tCzlykoxgOjIGr6dnTnfnhut9jTccoYRdMcwuYGeeBpkjJ9OrtISpe2DWrfMw2W6F/92aONUsc5u1jbvIcWr4j2JwcVaMFsmz+Ao+fm5GaGdXI8B6mVFDCAYbR5xAaoy2E1xRbo0kRcYb8CgEWN+Jo0Hmo67nspu3aL3EHxHvRhmZDc1aRppBWP/nRiEbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkifagxsq5ImZaxIle9hhcMaA5lbZh3yx1CJ0Yp1/hs=;
 b=kkZxFla/G3gFOW9yl3af7JQhxAAhOaLnkJghvLWS336Ed5oPxYII0bOnogfQ/2CScSfXPbkjMBrU6FrCvsG2mm41H1nipM/kQGiVMQ/UihKXUxXA6EEsW7mzLhG1lPZ00SHAzgFN6B17BlLgYBACg60zqrmtPwTyFJetRIr3Hgs4+nP+B/3RxKW3hzudTqVcxanwnEc+sVjcLzBdGijShhtpIxMHyBmH2mFplmBr8ml/fMcyO6Bjua+/du+SjKwC9V2rrGOZGj+gAlWJNIIH9TxM57dyCegydiPhOgtXuND200I6VcsHTXWhqQRYSTlvnGbBijeOS/DguyRHL4Qd6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkifagxsq5ImZaxIle9hhcMaA5lbZh3yx1CJ0Yp1/hs=;
 b=UbEqDWoxVFrGSQv+IomgSXO9LzVNQVxIqAmLPcvquuCNY2tghBj7aBMISN5hSA16PcXJIekJb2IN8oEc6H9A09FJFMWpUFKZ0UMMGmMkAfn6RwJGF9FTexkIQDoYfmpMMq1PgtLcNNWp8LrUjK8Hc43dCU0wz6MZotgxIkxqpOA=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTOPR0101MB1067.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:24::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sat, 13 Feb
 2021 01:28:14 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.037; Sat, 13 Feb 2021
 01:28:14 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: marvell: Ensure SGMII auto-negotiation
 is enabled for 88E1111
Thread-Topic: [PATCH net-next] net: phy: marvell: Ensure SGMII
 auto-negotiation is enabled for 88E1111
Thread-Index: AQHXAZ7q6OZ4ry+kc0WFGXoipoZDRapVRmoAgAAFVYA=
Date:   Sat, 13 Feb 2021 01:28:14 +0000
Message-ID: <7260052ec34b97e4b67dbf019955be90af49f32a.camel@calian.com>
References: <20210213002629.2557315-1-robert.hancock@calian.com>
         <20210213010908.GO1463@shell.armlinux.org.uk>
In-Reply-To: <20210213010908.GO1463@shell.armlinux.org.uk>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-16.el8) 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e52c972-9332-4c81-e5d5-08d8cfbea20f
x-ms-traffictypediagnostic: YTOPR0101MB1067:
x-microsoft-antispam-prvs: <YTOPR0101MB1067A983BF55DA6B1D78B2BAEC8A9@YTOPR0101MB1067.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XOI9DEXFj6Y+9MdbFsEI1X5Vvk+dfrBYdKVlyc50mOhz4/6k2E3HR6yUOyLEz9GiCtXHIN+9Ocq5AWwK+YLmN/lUFf8IEHQav+B1+0Fjpis4ykMFU7IqUnXCm0CVSuCOMwjpQxvB4UBCsGvLqk0MAPbu3zF/7GgkjUW0UWNHejeNX626crQAc8vm9RW4qdGgQMiv9ubE5xYJcoy0l26MGiuB1OtNmXEu8HHLOz45RLrTmt4kpUm7vc3QXrZ8V524VLdl+DefJptHoMtch9HlNcm+1p6AoRsXjs7uchkQCWGCCwexDDWi9b6MpkVjxFQQarW9WiSsAP1uwjxOGPI5we58nTTtRC4QW3hZIAJYotCuzOkGGvG4EFZDGFebBkXe1Jw9pflMpCcDxznm/qsxvO9koT2mH3GdQe5s8xRAxOqpesqy5Ew7XY+1E9ia1iGfJinKsi4FzjmIlrCNcq180+KZ1V9JKaZtHCZgsVTjJvP7L/dEhtg/raznv8yx+aXsg8jMwBNO620yBr1QByBWRSmao6mdlAUP5eq+ilzlxNUmNWNLZThI9k4Is3hQuU8WZ9jEbt8hB/hKdWK6QCCFUkEBdYPRSsi2Yv2VXVLZZlYIdSbl6vLgcmPl107sC7c5u+DF0JXS7Kt/2RfmHunjpzYEWUMEhm+vCnIpZ5O+KtpkG/DjQAe69BbEn0NPD3AX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39850400004)(376002)(346002)(186003)(6486002)(6512007)(2906002)(36756003)(6916009)(2616005)(4326008)(6506007)(26005)(5660300002)(8676002)(71200400001)(8936002)(66446008)(44832011)(91956017)(66946007)(86362001)(83380400001)(15974865002)(66476007)(478600001)(66556008)(316002)(54906003)(76116006)(64756008)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SnFkZXNQTG9VRXNXVWR3bElRY3RHUlV6NmFKWWVWVnBsbFZwclR3bTFUZ0lC?=
 =?utf-8?B?VWZFVGdBWjJOSUtVZGd6eC9kRVkxZkRsRkV3Qy9CTklzUFNGOG0xNjE1cnVN?=
 =?utf-8?B?OHdPQlIzaHNBRnNLMkNubEJieUYwM2J6T2dkSXc4NzZBRGxxYUZuOXNYWGJh?=
 =?utf-8?B?ZFc4bDAzaTV2TzdrSGcxT1FhYU5Kc3dOSld6R29vMTRHZDVyR3VJclF5Nlht?=
 =?utf-8?B?K3RjWUtTa2wzai9id2s3TnpiTU5qbWxZUzFwb1VFaldpeHk5UUswOHhVWGZ6?=
 =?utf-8?B?ZGdERHV6bUZwVlRjWWFOOU9zdzVZM0o0ZjlpTy8ySHZBVWV4VFhNNHJmL1ZB?=
 =?utf-8?B?SzN3aDl4ekJIL0lTcTZkS09LU3dBcXlPcVdUYnhaWXY4UlpxWTZZaCtVNjhM?=
 =?utf-8?B?YkErV0N3eStub0RKd2wrTGpiSlk1VzZNd21aM2NaMEVDZUE0UFFIaHUyQnJp?=
 =?utf-8?B?K25kNWlRTGtxcHJMKzdqQ0oxVG1vYmU4NHBocE1ZS2pkVGtwUU9uRnpBZVdv?=
 =?utf-8?B?VXp6VTlzUEtBRWNnV2NXR28rK3orMDJzMzhvNE5BNjhia1o4TTF6UXZ3V0hH?=
 =?utf-8?B?Zmp1SjZEcjNoQ2NIaFdRb3V5anRXYVViR3VDQ0ljT3RQQjJlWGZlNGZuS1d3?=
 =?utf-8?B?ZUthU00vZ2RJYk1xQ09MOGtNdnV4bEV3SFloMGkxWjhJa2M3V0JObzVrOGhJ?=
 =?utf-8?B?RXVRMzliUExIcldBT3d4QkcremRSSElCaFdtUzEzNE5LMDRNV01HSm9ZVEt5?=
 =?utf-8?B?bGVYTnR5OUowc2R3cHJtUGdPblNTTjFCR3lPMkFtd3VEYnl5Z3JYS3JlajF5?=
 =?utf-8?B?VXNzc3NoTmJ3VzFiS0JhbXFzNzV6VWVEUktEM0FrbHJZTGE3bmNOekMxbFV1?=
 =?utf-8?B?c1QrUVF2M0pjRkFxNGdVTnczYXNPYmRieDBWZWZrUUdwZ3dsQ0hHUFJDSmFk?=
 =?utf-8?B?ajcvU0pEdlI4UTZRSThhZGhSN1Zab3NEWXQ3bDRicGtwT3IwYTFNcTEvT1NY?=
 =?utf-8?B?aytGaGtaeTZLMUpzMlpHTFB2TjN2L3l6OVRWS0hWWTVyZXF0a1pKaURPTlA3?=
 =?utf-8?B?bUJadkdhcVdOUmd0TXJBeFZQTTVHRDhUckNwV3hVQWdMcU9Tb2xaTnVyREd5?=
 =?utf-8?B?NlpnNi9OS1J0VXN5UXhEbUM0czBCQW1mcXUyQlE5OWVjNUVUd3o2VEZnSDhQ?=
 =?utf-8?B?Y2xMOU1UeUhvT1RmWGxpSDhzSktVT1hyNkdEY1poV0t6d0ZoQUFqSjZRV2Q5?=
 =?utf-8?B?NE1VamY1bzVwK3RHTlpJLzlsT01haVMxQUZjUVg3NHZvV2x0MFpFOFlTZEVk?=
 =?utf-8?B?ODJtZ09idk9Obm84SkxkdHFjZlBVSzRZeHF6dFY1c05hWFZSVTI4UzBMK2Rw?=
 =?utf-8?B?b3VPYkcrL25LU0tJV1dBL2trUkVUeFJlOUhyTHVrWjBYZ2JRS243OTJtbk5H?=
 =?utf-8?B?TSs2MnBpeUhRU2hxNHlXckhGOWNPMTA5OVFsZEJoNFNQbW5ETlVsZC9IcTFR?=
 =?utf-8?B?MW1raU9KYi9mZml4OGNLTFZ1V3ZsWDlKYUZQTmFQMG4zN3FXbVFIZlZLN1h4?=
 =?utf-8?B?dlh3NE1lL3dDVk5IN0pWTWtFVnVGODJQQnd2d2dNamhHalR4VXd0ZnE3SGpi?=
 =?utf-8?B?SjdqQzVqMTlCaThsZTE1Y0dKci9HTjZqK0EvOUd5eTgwNy9vVjM1YmZVZ2h5?=
 =?utf-8?B?NHNMaU8xZUxWTTFaRm5NTjlkMEdkN2hmMWxORE5QbEcyZVhQUWFBNzNtVEMy?=
 =?utf-8?Q?WIBl2fj0djAKiMeo5kWzl4d4vLqawQmQ5BJJZhj?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFF672669047834BA170CDBF150EFD2E@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e52c972-9332-4c81-e5d5-08d8cfbea20f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2021 01:28:14.1542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TEngrqVz9+yQrx0v4N/+focMyszxKQmJAJXlVrjgweEhDC5hk7V8SxOHf+fZWc00WDI4el9Jzf3Cn6+k99IApwDC/OP3iHrVtGRzG3gZclI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB1067
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=464 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102130010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTAyLTEzIGF0IDAxOjA5ICswMDAwLCBSdXNzZWxsIEtpbmcgLSBBUk0gTGlu
dXggYWRtaW4gd3JvdGU6DQo+IE9uIEZyaSwgRmViIDEyLCAyMDIxIGF0IDA2OjI2OjI5UE0gLTA2
MDAsIFJvYmVydCBIYW5jb2NrIHdyb3RlOg0KPiA+IFdoZW4gODhFMTExIGlzIG9wZXJhdGluZyBp
biBTR01JSSBtb2RlLCBhdXRvLW5lZ290aWF0aW9uIHNob3VsZCBiZSBlbmFibGVkDQo+IA0KPiA4
OEUxMTExLg0KDQp5dXAuLg0KDQo+IA0KPiA+IG9uIHRoZSBTR01JSSBzaWRlIHNvIHRoYXQgdGhl
IGxpbmsgd2lsbCBjb21lIHVwIHByb3Blcmx5IHdpdGggUENTZXMgd2hpY2gNCj4gPiBub3JtYWxs
eSBoYXZlIGF1dG8tbmVnb3RpYXRpb24gZW5hYmxlZC4gVGhpcyBpcyBub3JtYWxseSB0aGUgY2Fz
ZSB3aGVuIHRoZQ0KPiA+IFBIWSBkZWZhdWx0cyB0byBTR01JSSBtb2RlIGF0IHBvd2VyLXVwLCBo
b3dldmVyIGlmIHdlIHN3aXRjaGVkIGl0IGZyb20gc29tZQ0KPiA+IG90aGVyIG1vZGUgbGlrZSAx
MDAwQmFzZVgsIGFzIG1heSBoYXBwZW4gaW4gc29tZSBTRlAgbW9kdWxlIHNpdHVhdGlvbnMsDQo+
ID4gaXQgbWF5IG5vdCBiZS4NCj4gDQo+IERvIHlvdSBhY3R1YWxseSBoYXZlIGEgbW9kdWxlIHdo
ZXJlIHRoaXMgYXBwbGllcz8NCj4gDQo+IEkgaGF2ZSBtb2R1bGVzIHRoYXQgZG8gY29tZSB1cCBp
biAxMDAwYmFzZS1YIG1vZGUsIGJ1dCBkbyBzd2l0Y2ggdG8NCj4gU0dNSUkgbW9kZSB3aXRoIEFO
IGp1c3QgZmluZS4gU28gSSdtIHdvbmRlcmluZyB3aGF0IHRoZSBkaWZmZXJlbmNlIGlzLg0KDQpJ
IHNhdyB0aGlzIHdpdGggYSBGaW5pc2FyIEZDTEY4NTIwUDJCVEwsIHdoaWNoIGRlZmF1bHRzIHRv
IDEwMDBCYXNlLVggd2l0aA0KaG9zdC1zaWRlIGF1dG8tbmVnb3RpYXRpb24gZGlzYWJsZWQuIFNv
IHByZXN1bWFibHkgdGhlIGF1dG8tbmVnb3RpYXRpb24NCmRpc2FibGVkIHN0YXRlIGNhcnJpZXMg
b3ZlciB3aGVuIGl0IGlzIHN3aXRjaGVkIHRvIFNHTUlJIG1vZGUuIEkgcHJldmlvdXNseQ0Kd3Jv
dGUgYSBwYXRjaCAoIm5ldDogcGh5OiBtYXJ2ZWxsOiBhZGQgc3BlY2lhbCBoYW5kbGluZyBvZiBG
aW5pc2FyIG1vZHVsZXMgd2l0aA0KODhFMTExMSIpIHdoaWNoIGVuYWJsZWQgYXV0by1uZWdvdGlh
dGlvbiBmb3IgMTAwMEJhc2UtWCBtb2RlLCBidXQgd2UgYXJlIHRyeWluZw0KdG8gc3dpdGNoIG92
ZXIgdG8gdXNpbmcgU0dNSUkgd2l0aCB0aGVzZSBub3cuDQoNCj4gDQotLSANClJvYmVydCBIYW5j
b2NrDQpTZW5pb3IgSGFyZHdhcmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dp
ZXMNCnd3dy5jYWxpYW4uY29tDQo=
