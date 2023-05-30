Return-Path: <netdev+bounces-6342-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACBF2715D61
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CF851C20B68
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C3117AD7;
	Tue, 30 May 2023 11:38:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90F417AB6
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:38:06 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2129.outbound.protection.outlook.com [40.107.113.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEEDEA;
	Tue, 30 May 2023 04:38:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPUYoX+PVfT1HaxXNt7K/FKgLv+Y2jPs56GkJpVonmPqlcRwdrA1YAlCSVJb5u3PMXoNbdePp3ua5n0NjszcHCrVsyLS6KS+NLvJWJuwVzkqvfpzjtYqAZGK2/MBHHBpzex3TtMRzbX4yu/YnbFSk85LaxoYsiNHvvqvEgZrB8tm5QoSj/miCEVmOckWphJw8Rq9khUL5mt3pI3UTIp4jifTzdZudiIqSgf04YnFQuPagWeKhRSRbHSsXXLeDFXSXvHUskwAdOzk1GarbZJqJj8h/bjpa1N84SdM8xq0RUnUE8KPjBdT0koEWG5xe1ziAKT/kjclGZDgi2tBa6Dqvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ORbDgaYnh50NVrQxyed8BOOqGoN17c0btThfizPVHI=;
 b=dyJ5n4jYatlZom7NswrwIbdQhT/WEzPSyZR7RGBe+H2SJzwIIn3deg2d79lZ4q8bfD5zbt2pSMLOFWnfEeEbVokgEdfzE4HdDRdnEn2kRHzq+qYWYN/M/nIninPwDg6igT0MmwWQqNF/nOr5N/i/NYt8tNx0xY0CXnsKsIuvoW6bwdW0c8M6x9wDeCLujRpXMaa+ezqTEinTsjhvoI82CtZxF9vL4Ou8F6wRq2Ilo2lMvWMrsmQzzFRl11pE77haySUeJLCC4RH5faF7hy2XA0ggOycoZXiMjTdbue2vTghbEvPCr7Gq1Xg6xBX4f5gH1OpZqPg/E/gjRe90CYHufg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ORbDgaYnh50NVrQxyed8BOOqGoN17c0btThfizPVHI=;
 b=eGTl8qi3X14El5KnWqD7PqZEE2jZRCQWuscn7xLsiu60YcpwGMWohdpp2d1G5zRZj+bTiuBBKfLZgt7riK0flIwQjfrUvMO9P22n0SLYVBOymRK2tqkFU/BN1v16JVRb3UnPRSD/a5xue+iqZTH5dpQi4xEWLUjuY6nfcBPqZvU=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB10346.jpnprd01.prod.outlook.com
 (2603:1096:400:24a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 11:37:58 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5198:fdcf:d9b1:6003]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5198:fdcf:d9b1:6003%6]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 11:37:58 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "geert+renesas@glider.be"
	<geert+renesas@glider.be>, "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next 2/5] net: renesas: rswitch: Rename GWCA related
 definitions
Thread-Topic: [PATCH net-next 2/5] net: renesas: rswitch: Rename GWCA related
 definitions
Thread-Index: AQHZkgTOsSSPxPlyv0+hscrkXzIy2q9yaaAAgABDmiA=
Date: Tue, 30 May 2023 11:37:58 +0000
Message-ID:
 <TYBPR01MB5341170818E3104408B2A56AD84B9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
 <20230529080840.1156458-3-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdV2nRAnW+bMBtO45=VMjCuCOVcyizD-OF4HUidCS8dSTw@mail.gmail.com>
In-Reply-To:
 <CAMuHMdV2nRAnW+bMBtO45=VMjCuCOVcyizD-OF4HUidCS8dSTw@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB10346:EE_
x-ms-office365-filtering-correlation-id: b6ed52ab-634c-4083-439b-08db61025121
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ps2/cGaRQq56eVrJsdxoSIkpq9LrBC+mpRHOS/tBb52oSQmfzEePMWREEHpHNr5QImxs/DBzUwb+BfN9AH8tF93W+W4zbK1+3unNcbV36VBsbLn/ND4opLz19RT2kODPfltWlddu2sYc0mGVT3rY02wok1lg9HTHr2RcI40xfsQonQpmTFF9HhgvAc6KWc4ji6Aqx9W02Nd9Gbe6s0NpbIdBu6wLwmcgYvNXb5ogVndzdxCsz7GWIuE6aqdhP+ATDS3ZAlsSZPZijQ7Wvgca6bgMfmM98SbcmjVL2RFZUxpKV9kSQNZ4sJBKcd5W4AIpbIbzqugIdVK4ggup/u/awARzI/buNyexkSoeu9YJB4596Z3m53/0Gi3l2DfGc4in+EGoGJUNBJFKJIz6kj8cLQ9a4xSVu3XoTSlPysDsaJtS/ZdoxhdgfVsraG7OUXsqkv5ETFaqB4LU29cmHNfZUih9xezYBcJks93JWfzt/mrT3h61W8RQ2vHRfja0J8jCSjrk+WDSYNiOuiScIYT5yk90mMommIQun2vbnaTMzo60j9iqGRbA8D4JtspOo17nwk3ByUu6x3yQSjB3tK0AKsPTYuKPP9QN2PcPYKx6YrLvFNSZDBs6NUahzS9omomt
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(451199021)(71200400001)(478600001)(54906003)(8676002)(8936002)(52536014)(7416002)(5660300002)(33656002)(38070700005)(2906002)(86362001)(66476007)(6916009)(4326008)(66946007)(122000001)(64756008)(66556008)(66446008)(76116006)(316002)(55016003)(38100700002)(41300700001)(186003)(6506007)(53546011)(26005)(9686003)(7696005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R29qS29TTFR5MFA0aGRNZldGWktiRGc4WVVua3hyVWx5bGVHcVBJS0xUcnd4?=
 =?utf-8?B?SFB3N0Z5eXplVldUWXBkMjRJRTNYQlI4UThtdmUxaUJyWWo1bjd0MGh2MSt6?=
 =?utf-8?B?elVZTGNqQzZuaVMyQlFLUjhFWTNFbnRFVmdEK1F6eW5hRFowNzNsKzdYWU8y?=
 =?utf-8?B?MkdxWE9IZ2FYRks4UVpuamVPdjlocjhrQURyZll3bWVMa0VSZHgyZUV4L3hZ?=
 =?utf-8?B?NHF0V3J6M1BGOFdmQnVZVEdLQUhjbWl5ZWtVQWtNd3kyQTRMdWdScmQ0V2pi?=
 =?utf-8?B?Q1VFVWI1dnNaQlFoZEdJSDUrejBqME5MNFVNTmR4WlZLYTh0cU0zSGJwTXpZ?=
 =?utf-8?B?M2d0VnVwWUpJN1dNemdCZEJtRFZqZXBjWW1NRHBkc1U4U3NCWTNvTHI3WW1q?=
 =?utf-8?B?d2lMWUlOcnFVMDFES0N6M2dEUjJBaDYrRUs3eHZQK2g5NFVCSVJMMmFwTnBU?=
 =?utf-8?B?MGJweUh1MG5ZM2lwNmhyS2d2Q3FPUk95MW9tTU5zR1NhN3c4RlRKN0JaVHVK?=
 =?utf-8?B?eEVldThsUUs1cFgyNVZZd0diSlBWc1U5bFhyc3FDaVhrMU5NOU5VdUJhV3Jh?=
 =?utf-8?B?dTFQdkMySjVqNXR4RkMvMGEvK1lXVU9NUnNCdWhiTXNWdVFWZmtQSUM4cFJZ?=
 =?utf-8?B?dlBmbFo4YTdTMnU3VjI5amZzRDAxRnB2NGRiUmcrRENrbjhOQVN0ZHJERGZu?=
 =?utf-8?B?M3BQa3hBaUxHVWdkTWdqVi9RdUdSaFMyZ2czaE4vOVBIYUxNdTRMSkVBNWx4?=
 =?utf-8?B?K3l5VVBoc1kxUkw2MFNpd0ViTXhwWDhiRG1sUU9OcDB6clJxU0kyT0l0bFRy?=
 =?utf-8?B?TE9ObmJPRis3RUdPU0QxajJjZmdZU293UldvS203MzJZL0t2SXM2NzNabmtL?=
 =?utf-8?B?VzQwcHlDK3BhRnEvVjVCVGl6YnNxRitFVXNJeVBxUjk4aVk2OVVsSnR2a2l2?=
 =?utf-8?B?WklzUVZMRlRjUmRrVEsvR3ZHOW9pQndGYm8rM3hETlo5VFZ1NndyUiswRHEz?=
 =?utf-8?B?aGdCc3lrR1FxazVNZlFyR2dYakxKeHNXNU5OSXhGNGh6NzZaZm1WZ05lUXNr?=
 =?utf-8?B?RFRPK3RRVmVBckdQbDJzY0JRaWk4NHB0SjdYVEdEb3VrMkxUZGg3aWdQVTBR?=
 =?utf-8?B?a1d0V1FLWlVVUlNPQTl2dXlPS3BaSTlMQWZJNW5zcnYyOXlLNHczVDlhS3Zu?=
 =?utf-8?B?UnBmT1hieXZiVzIrbThxTTJnaVVrUzkrQ0ZIY0Q1RkhFczE4K21NdUdZKzIy?=
 =?utf-8?B?cU9WSVlSM280NU8wdENVR0p0TitJREhLL2hNbTRSRlBBRUc1cWdibmZGQWh5?=
 =?utf-8?B?Ky9vMy9qc0pFTkVscm51YVhrRGZZSEFBQzZ6dE5aS1paV0hEdHcvcjZ5a0t0?=
 =?utf-8?B?Zmd5SXRoVFJJbU5DekFSaWZhWUVUVXpkK3BaYTlnYVhxck4vOWFMUFIzdkZ5?=
 =?utf-8?B?Q05mWDBvN24rUWN4N2VmK0doZXRILzYzNy90eUpOZ05WcmY4RG9SSmNzVE90?=
 =?utf-8?B?bzA0ZWFIVG94S09PMEoxRG1HSzdpTGpid0JxViswdktLMXBaZUFkbWRremtO?=
 =?utf-8?B?REZIU0xWOUlmcnlkNDBiOVVoa1BoYjYxNVNjUVVXajBUeVZwYW1XTGFRTmRG?=
 =?utf-8?B?d0FqQlY3bkpBTWZtcmlBSzJGSVB1a1pJZDJ2djl1cUJ2QkNxNSt1ZjZGVDR5?=
 =?utf-8?B?ai9oUFdUOHRyMnRpdGM3S1Q2ZmNFUGF1U3h2ZFp3ZTNFdDhJeEpnRURBMWMv?=
 =?utf-8?B?b1ZXQ1RGcUxTMmxZWmJJWUM4WWFRWVdETHRGWkpJejFNR2NpdnFEdlZzelpl?=
 =?utf-8?B?ejRnTGpQSVBQR0FsOWpJNGhvWEU2b0J2c0RvZCtSczB2anEweDBabVp1Zm4z?=
 =?utf-8?B?NnN6TEc4dnExRnZmNnFOa0VXaDFabzhIRUxKMWtQYmkyNDN1YkpCa3F0Rjhi?=
 =?utf-8?B?dXRTQmo5SllUcVNoNHBGbnl2cTlkNzZlOG5ORnJTeE1QOG8weHlZOXFlanZz?=
 =?utf-8?B?TUh2M2M3Nkkyb1ZyczRZWndUanMwREpwLy81VGFTenlSMEIzcS9DOHhLdUhw?=
 =?utf-8?B?WWtMdVVpWHNaLzZLbmNuK2R5MGpKQ0RLeWVrZnpITys2L1Nzd2swSENxNUpm?=
 =?utf-8?B?c3h3RnlRU0JrdkFhS0EwN3VvYS81aFFTbzFzWTNjaUdPaXJmcUZrUDVubTdR?=
 =?utf-8?B?S3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6ed52ab-634c-4083-439b-08db61025121
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 11:37:58.1579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +9R8sjeqfFGtENSOCtGRSFFkHIqPess+Zf2JMUtIGNy/oW29PP2OcqE8sLdYKEidZreM/F5HCJheiOtXnXKZ5UXsAXkqylFI5/AezEvWkGUL4/hbxg0R3QmOkdptBDYk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10346
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogVHVlc2Rh
eSwgTWF5IDMwLCAyMDIzIDQ6MTggUE0NCj4gDQo+IEhpIFNoaW1vZGEtc2FuLA0KPiANCj4gT24g
TW9uLCBNYXkgMjksIDIwMjMgYXQgMTA6MDjigK9BTSBZb3NoaWhpcm8gU2hpbW9kYQ0KPiA8eW9z
aGloaXJvLnNoaW1vZGEudWhAcmVuZXNhcy5jb20+IHdyb3RlOg0KPiA+IFJlbmFtZSBHV0NBIHJl
bGF0ZWQgZGVmaW5pdGlvbnMgdG8gaW1wcm92ZSByZWFkYWJpbGl0eS4NCj4gPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2Fz
LmNvbT4NCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBwYXRjaCENCj4gDQo+ID4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3Jzd2l0Y2guaA0KPiANCj4gPiBAQCAtOTU5LDkgKzk1OSw5IEBAIHN0
cnVjdCByc3dpdGNoX2d3Y2Egew0KPiA+ICAgICAgICAgaW50IG51bV9xdWV1ZXM7DQo+ID4gICAg
ICAgICBzdHJ1Y3QgcnN3aXRjaF9nd2NhX3F1ZXVlIHRzX3F1ZXVlOw0KPiA+ICAgICAgICAgc3Ry
dWN0IGxpc3RfaGVhZCB0c19pbmZvX2xpc3Q7DQo+ID4gLSAgICAgICBERUNMQVJFX0JJVE1BUCh1
c2VkLCBSU1dJVENIX01BWF9OVU1fUVVFVUVTKTsNCj4gPiAtICAgICAgIHUzMiB0eF9pcnFfYml0
c1tSU1dJVENIX05VTV9JUlFfUkVHU107DQo+ID4gLSAgICAgICB1MzIgcnhfaXJxX2JpdHNbUlNX
SVRDSF9OVU1fSVJRX1JFR1NdOw0KPiA+ICsgICAgICAgREVDTEFSRV9CSVRNQVAodXNlZCwgR1dD
QV9BWElfQ0hBSU5fTik7DQo+ID4gKyAgICAgICB1MzIgdHhfaXJxX2JpdHNbR1dDQV9OVU1fSVJR
X1JFR1NdOw0KPiA+ICsgICAgICAgdTMyIHJ4X2lycV9iaXRzW0dXQ0FfTlVNX0lSUV9SRUdTXTsN
Cj4gDQo+IE5vdCBkaXJlY3RseSByZWxhdGVkIHRvIHRoaXMgcGF0Y2gsIGJ1dCBpcyB0aGVyZSBh
IHNwZWNpZmljIHJlYXNvbiB3aHkNCj4gdHhfaXJxX2JpdHMgYW5kIHJ4X2lycV9iaXRzIGFyZSBh
cnJheXMgaW5zdGVhZCBvZiBiaXRtYXBzIGRlY2xhcmVkDQo+IHVzaW5nIERFQ0xBUkVfQklUTUFQ
KCk/ICBJIHRoaW5rIHlvdSBjYW4gc2ltcGxpZnkgdGhlIGNvZGUgdGhhdCBhY2Nlc3Nlcw0KPiB0
aGVtIGJ5IHVzaW5nIHRoZSBiaXRtYXAgQVBJcy4NCg0KVXNpbmcgYXJyYXlzIGlzIGVhc3kgdG8g
dW5kZXJzdGFuZCB0byBtZSBhYm91dCBHV0RJW0VTXWkgcmVnaXN0ZXJzJyBoYW5kbGluZw0KaW4g
dGhlIGZvbGxvd2luZyBmdW5jdGlvbnM6DQotIHJzd2l0Y2hfaXNfYW55X2RhdGFfaXJxKCkNCi0g
cnN3aXRjaF9nZXRfZGF0YV9pcnFfc3RhdHVzKCkNCi0gcnN3aXRjaF9kYXRhX2lycSgpDQoNCkhv
d2V2ZXIsIHVzaW5nIGJpdG1hcHMgY2FuIGF2b2lkIGNhbGN1bGF0aW9uIG9mIGluZGV4IGFuZCBi
aXQgYnkgZGl2aXNpb24gYW5kIG1vZHVsby4NClNvLCBpdCBzZWVtcyBiZXR0ZXIuDQoNCkFuZCwg
dGhpcyBpcyBhbHNvIG5vdCByZWxhdGVkIHRvIHRoaXMgcGF0Y2ggdGhvdWdoLCBJIHJlYWxpemVk
IHRoYXQgc2VwYXJhdGluZw0KdHhfaXJxX2JpdHMgYW5kIGd3Y2EucnhfaXJxX2JpdHMgaXMgbm90
IG5lZWRlZC4NCg0KQmVzdCByZWdhcmRzLA0KWW9zaGloaXJvIFNoaW1vZGENCg0KPiA+ICAgICAg
ICAgaW50IHNwZWVkOw0KPiA+ICB9Ow0KPiANCj4gR3J7b2V0amUsZWV0aW5nfXMsDQo+IA0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICBHZWVydA0KPiANCj4gLS0NCj4gR2VlcnQgVXl0dGVyaG9l
dmVuIC0tIFRoZXJlJ3MgbG90cyBvZiBMaW51eCBiZXlvbmQgaWEzMiAtLSBnZWVydEBsaW51eC1t
NjhrLm9yZw0KPiANCj4gSW4gcGVyc29uYWwgY29udmVyc2F0aW9ucyB3aXRoIHRlY2huaWNhbCBw
ZW9wbGUsIEkgY2FsbCBteXNlbGYgYSBoYWNrZXIuIEJ1dA0KPiB3aGVuIEknbSB0YWxraW5nIHRv
IGpvdXJuYWxpc3RzIEkganVzdCBzYXkgInByb2dyYW1tZXIiIG9yIHNvbWV0aGluZyBsaWtlIHRo
YXQuDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLS0gTGludXMgVG9ydmFsZHMN
Cg==

