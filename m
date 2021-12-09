Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9FD46E8A9
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbhLIM5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:57:38 -0500
Received: from mail-eopbgr80091.outbound.protection.outlook.com ([40.107.8.91]:58232
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236200AbhLIM5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 07:57:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyHK6KPnO2Q8nBTdr37+CM6cTkVAvonsSXdEbjmzXUkHbjtxoATZVktLokbpbNEB4kWshZUtMpPjM7bp3k+aWw+fRFcOoDRNdm61ag6Rtpe4q8EkJfPJP0hk7UgnO3CF8nFtwnGijcaYqM3z7/3f/fiPwKU8H3XCoUdbIjY8kfOy2tdRL/1vcD9oufopOEwfDYvkUupSF8pIaUWrBWHGN85+b0QA27xNdz160XHbc332sUmPaBmayBg10oII6r3lzfS3s+WGUePZ/QboUHaWBLMWb3fzP/aGrn9k7f9dbXgHGMOE25pvyKtzfC+WI7YYO+MQ6qenCjM6TzWzrIYZlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1CPk5YpTwW2O8GJBrPQbGPk148EcU7x+cXP+dy/siZ4=;
 b=dXmyv4cZObf+yjRj6S8L25jWCpvMw5kM0iQuTIN/pCOuEh+DiP5kF0DL4ZJYg4X5aeZ1VHoYxJnXc3eZpdgIvlNPPjORqBn41kyBMxS/Rjjl5rK5et5JMyUPecoZ7xfw3BLqcWIHH2giJJ4a8LuIvtW2rZkImgleB+Z0KF+GWQK/MWYBc4ywLKQ6VKus93k73yvLBlJ2fipLW4TVlbqo2wjS9uyBZSPep+9e2IqCLVyfOuFLQRosRiFyBVKI90F5HsN9olqzgEM5vE6eQKCLGf/BI9MHx5ebx1SVP4NwT2l5YLYtFTb1gR0+x5y5k+QubMJt18BHnUWxTyagBD/ukA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=schleissheimer.de; dmarc=pass action=none
 header.from=schleissheimer.de; dkim=pass header.d=schleissheimer.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=schleissheimer.onmicrosoft.com; s=selector1-schleissheimer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1CPk5YpTwW2O8GJBrPQbGPk148EcU7x+cXP+dy/siZ4=;
 b=kPm3n+pKfKAFsjnW4NpO4tTqw5a39bfd40GHp+QsJrcXB5hxROJmxVVbDwrhTy7yavQx3q8Ar/SdFya2DVouI/VIQrEiokb5Vs31jms+6emAymbO0ykPFkEymxhmjXms7ZEN/py4A8nRm0By6ZJq+Np+mbwvC40SptrNuXrHUc0=
Received: from PA4P190MB1390.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:103::8)
 by PAXP190MB1613.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:1cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 12:53:57 +0000
Received: from PA4P190MB1390.EURP190.PROD.OUTLOOK.COM
 ([fe80::8c49:c17b:a3a1:f12d]) by PA4P190MB1390.EURP190.PROD.OUTLOOK.COM
 ([fe80::8c49:c17b:a3a1:f12d%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 12:53:57 +0000
From:   Sven Schuchmann <schuchmann@schleissheimer.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "Thomas.Kopp@microchip.com" <Thomas.Kopp@microchip.com>,
        "pavel.modilaynen@volvocars.com" <pavel.modilaynen@volvocars.com>,
        "drew@beagleboard.org" <drew@beagleboard.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "menschel.p@posteo.de" <menschel.p@posteo.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "will@macchina.cc" <will@macchina.cc>
Subject: AW: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Topic: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Index: AQHX63m5RC9thyxmT0S34SqWhDegYawp9YdggAAPg6CAAAOYAIAAFwsA
Date:   Thu, 9 Dec 2021 12:53:56 +0000
Message-ID: <PA4P190MB1390EEE7C7B2BB17410D653BD9709@PA4P190MB1390.EURP190.PROD.OUTLOOK.COM>
References: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
 <PA4P190MB1390F869654448440F869BCBD9709@PA4P190MB1390.EURP190.PROD.OUTLOOK.COM>
 <20211209112748.yixzz4xskw6qm7bw@pengutronix.de>
In-Reply-To: <20211209112748.yixzz4xskw6qm7bw@pengutronix.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=schleissheimer.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce61f3e5-674f-4770-2047-08d9bb12f6a8
x-ms-traffictypediagnostic: PAXP190MB1613:EE_
x-microsoft-antispam-prvs: <PAXP190MB1613A4DDAD480C3DF1535763D9709@PAXP190MB1613.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q5jcavmfO14AYhlaK3seOCJMTO2/hJvBWHNUpJMtjkMFmleSThPGxCU2xDaAPsykBmC19aKQ8OyapVsJic8ifD+9qnLpbSeVW1IxuRMQFO9M+wUQlDV3Tmi+lo9mgjpxOJ25nJCdIQFP13vN78bMzZbGKRMBZog9TudDVyn4dNElNVGlsuuiOjhCBTb2SEfnBql9qG5nvqUMFztZwIllwbt5G7AhWqud/tOaQU14VgzfIm1LVGO7uEaBc7Pgd0pJMQccANf0Onr7kxslpc6F7T2LqCXXCVgSNzuNEnPGv2/Xp0tBAxqr2Cj0qnEn3+59RPZqIP2dUqfRrJ/jtZhwnZgnVPTXgFjEckkeTBNZTqcDc4rZZxeqDruiQcIbl36RAnaRmYab0FQHbjHyudFzxpJAgoRpipN5GrN2V63lv+zbR3f7GkCS6W5HcmFgvyZ96wvJaqwhyLhZRjpbT6SeBf2nStl0Ycx2cqACxUcbgUjbHXDn38xHKQk73j+lVITYxQ+HK01SIaObx+HiGsyjOhZLXJYtG+OMolTO8Rpmslj46/3KeE3c5uoMbeMmqvaXFYk7aawowu8dt75faTylwHDm6VJuFVBAUGBi7XSRoY9OaoHaQfKfE6HsNvEQR7iAuiIye6A6JX3CLn9y+sDxKG4EEJiayTEsYM/r95wc3jBR4mGjXXop8Fu7iUzbX0Tw9HpEOYlBjdEV4IbJZ0CeXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4P190MB1390.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39830400003)(366004)(66946007)(186003)(9686003)(508600001)(7696005)(53546011)(54906003)(76116006)(66446008)(6506007)(66476007)(26005)(83380400001)(8676002)(4326008)(55016003)(66556008)(64756008)(33656002)(38070700005)(86362001)(6916009)(38100700002)(71200400001)(8936002)(122000001)(52536014)(316002)(2906002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGJrREEySXZHR0JaUkwrOGg1R0piZUhueU5aZm1FUjdGNGF6K2xRWTFyc0pJ?=
 =?utf-8?B?UUMyUnJYOWFGOGpWem8yMUVsclNCRUY5Sjd0ZXd6bld3U1BYQVQwTFNReU5o?=
 =?utf-8?B?MXdLaktWRHgyb3pZK0FUbHVTcHB0QXhZcG5QRVpTTHpQeHVZajliZzQrSGxx?=
 =?utf-8?B?Slo5c0pHL2x5Y2lHdzRHd2ZrZlczbi9XTnFiSzZwMWVhOXRrbXRnbnFlOVd3?=
 =?utf-8?B?ZURpZXlhdi8zS2svMHdMWldQYlZNWkpKYTdPcFNGd09GaS94d0xzZ2JzRTRX?=
 =?utf-8?B?eEpaZDl0R0xFbjhBbFdzbSt3Q0xWQkRqODI2dXJHbG5NZWNQbDAxa2t0V2wv?=
 =?utf-8?B?SFlpZlhGWmpZeFA1SVVxMGlXeXRLVjVPcTBRd3BlV0srZk8zWFI5RXA0MkQ4?=
 =?utf-8?B?WEFEYjd5VVI2bjFyRk9qNjg5M2RTbzNta3NRbHlldFV4QjNBV3RRR0djTU9S?=
 =?utf-8?B?UFNNTHBlNkN4OElWUmcxR1J4d05NQXFQZ0JLYmZFVFBiMnE2NDM2LzUxVDV4?=
 =?utf-8?B?UjIzTEo4S1piUzJyRDFCTWVJRUc1bkRaZTI1TEpQN3dzZjY1OCtSR2xWbDJD?=
 =?utf-8?B?M3RQVEhUT0xLK3JYWHB6amIwODJVZHVqdXYwQkd2NzgyMEs0T2VDQVUzdTRI?=
 =?utf-8?B?VzZGWHNUL2ZkTE1TTDlqeGl3ei9MZkJvOTZHVktxdHdBTmhtNVpZUnJzSFlm?=
 =?utf-8?B?ZExlK013c0UrWEhabXk0c1lyYTYvcFU0dUJNNlJFajFjb2w2VEJjNXVDYWg2?=
 =?utf-8?B?WXNGaDR2V1FwQUt6Nmc4Q3FiVzArVUFqK2x1L1puVUhGR1g2NHM0ZkhpNUdR?=
 =?utf-8?B?bllUT0JkalF6clBGS1dhbWIrdnRGZDJjZWdiL0x2RytsYU51ckJTaVFucG1Z?=
 =?utf-8?B?K1pTb0lDUFpBd2c4b08vdktoWXBGL0ZXK0p1RWtiRFAxSElkelNxL0JyZ0Uz?=
 =?utf-8?B?L3lkS1gwNGhaQy9tRWtmT01SWUthbEt5NlRha09seFJnVGtYRlp0THE2MnF6?=
 =?utf-8?B?b0Q2YVlVWW9adG1pWnRIWXVkUUlnd0hnelNGUDZjbG1xQ2pMaVVjbkorTUZO?=
 =?utf-8?B?RTU3czR5aGVsbVB1emYzZ2JwTy93K0FIc20rT3o4L0x4VW9rREk4QURDZjJW?=
 =?utf-8?B?ZEZNcmFCZ3RwR0NOdW9oa3RjU1licG13S1VOVlNEYnRGY243S1JTd3JmMGxC?=
 =?utf-8?B?SmNHR2pXWDMyNFBBcldqSytQUjVGS1RjQ0Z4U1BlS0FqdDE4cFhuYnJES3h1?=
 =?utf-8?B?ajBPZnZhMFR4WS9IMldwci9sV2hXZFo2QXBWcVE4QWRIdmlQaVJ5WlRXOWJt?=
 =?utf-8?B?aUJKSXV5RnBsNDBBc2Jqc09mbzZlMHp3ZGF4ZHIwaWJ3SnJGQUIrVTdvbys2?=
 =?utf-8?B?RkVCa0JmVTl0Z2JwaDBnTEJRYjNDM3pxYVdnZTlha1d5ZExETWEwUHhIdmd3?=
 =?utf-8?B?S2ZHZWVuQktYTkplMWhDM01iL3ZaWlQyRnBkZUFyWjBGQlNEdkk2U21VUXRK?=
 =?utf-8?B?TGNpYVByclkrRndaNmlpYzVnbGdaajR5VnoyV1YwWEhhb25wOTRvY2s3NjFQ?=
 =?utf-8?B?dml2Q0NsVVRFZlA5ZTVaY3hnRmp3bTZvN3JsK2E3b2NtTnVrcTgrMGllWTZQ?=
 =?utf-8?B?a3QxZzFvK0k3TnRCT3c4dGZQY2JxNkp5dGMyRHJqSjI4Nkwvd3lCVS9tSllm?=
 =?utf-8?B?OWN1bUVxS0VXZ0tmTVExbW9qT0ZxZlZhOGRMMGN6b081MGdpcFR0NEYzQmFr?=
 =?utf-8?B?eXRmY2s0UnQvY3NTcWFYZDVweUJNVmJ4cUFjenN3TC9CZkZpcU1MdW5hQjYw?=
 =?utf-8?B?NjJmblJjWjNZSVJkMWRKM1lHQnBaY3ppaVU4YkdxRlgxYVNZRU9tbW8yV1Rx?=
 =?utf-8?B?VmRYRXZsVVRjZ0N2R3h1QnVSTGtzbU1aR2V0ekpjOXE5cXZKSWs0eE1FZFF0?=
 =?utf-8?B?RDNqS29Pc2p4Nk84RkxHRDN1emJ3aDY5RnlqZy8rcW1FLzYvMmRjVkVyYzZ0?=
 =?utf-8?B?emZhaEtaQ2hlWmQrSGVwbEVHcnFkSDhyYmFBQnJZejJTRGF4NExEeWZZZlZk?=
 =?utf-8?B?UUF3ck45MHg2VmVCY21FQ3psR1NNR3hRM2pvdHRVazU1SWlwTE14ZE5icGR1?=
 =?utf-8?B?VExWUHpQcFo2bTZLRll2RGMwMjdMMDVvYnFudVVJQkRqSDRzZTZlMnVNcVFh?=
 =?utf-8?B?b3JPd0krb1lmZTZycG84QjVyT2JXbWpweGo0Z1FKVnBEOGRsSmIrM2c5WjFU?=
 =?utf-8?B?TjRpVUI4anErTnhLV1NUdG96LzZ3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: schleissheimer.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4P190MB1390.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ce61f3e5-674f-4770-2047-08d9bb12f6a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 12:53:56.9623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ba05321a-a007-44df-8805-c7e62d5887b5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xaa2PaAtfX0CMLx7tICWRkiArJgJ0NAloE0KEYiBrZ868qjBIqDjENO6KxjK78TWlthQiyg4vwPtYwP4ENwQwbDd4RJUni92R4KkXqSF9A0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP190MB1613
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gTWFyYywNCg0KPiBWb246IE1hcmMgS2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXgu
ZGU+DQo+IEdlc2VuZGV0OiBEb25uZXJzdGFnLCA5LiBEZXplbWJlciAyMDIxIDEyOjI4DQo+IEFu
OiBTdmVuIFNjaHVjaG1hbm4gPHNjaHVjaG1hbm5Ac2NobGVpc3NoZWltZXIuZGU+DQo+IA0KPiBP
biAwOS4xMi4yMDIxIDExOjE3OjA5LCBTdmVuIFNjaHVjaG1hbm4gd3JvdGU6DQo+ID4gd2UgYXJl
IGFsc28gc2VlaW5nIHRoZSBDUkMgRXJyb3JzIGluIG91ciBzZXR1cCAocnBpNCwgS2VybmVsIDUu
MTAueCkNCj4gPiBmcm9tIHRpbWUgdG8gdGltZS4gSSBqdXN0IHdhbnRlZCB0byBwb3N0IGhlcmUg
d2hhdCBJIGFtIHNlZWluZywgbWF5YmUNCj4gPiBpdCBoZWxwcy4uLg0KPiA+DQo+ID4gWyAgICA2
Ljc2MTcxMV0gc3BpX21hc3RlciBzcGkxOiB3aWxsIHJ1biBtZXNzYWdlIHB1bXAgd2l0aCByZWFs
dGltZSBwcmlvcml0eQ0KPiA+IFsgICAgNi43NzgwNjNdIG1jcDI1MXhmZCBzcGkxLjAgY2FuMTog
TUNQMjUxOEZEIHJldjAuMCAoLVJYX0lOVCAtTUFCX05PX1dBUk4gK0NSQ19SRUcNCj4gK0NSQ19S
WCArQ1JDX1RYICtFQ0MgLUhEIGM6NDAuMDBNSHogbToyMC4wME1IeiByOjE3LjAwTUh6IGU6MTYu
NjZNSHopIHN1Y2Nlc3NmdWxseQ0KPiBpbml0aWFsaXplZC4NCj4gPg0KPiA+IFsgNDMyNy4xMDc4
NTZdIG1jcDI1MXhmZCBzcGkxLjAgY2FuZmQxOiBDUkMgcmVhZCBlcnJvciBhdCBhZGRyZXNzIDB4
MDAxMCAobGVuZ3RoPTQsDQo+IGRhdGE9MDAgY2MgNjIgYzQsIENSQz0weGEzYTApIHJldHJ5aW5n
Lg0KPiA+IFsgNzc3MC4xNjMzMzVdIG1jcDI1MXhmZCBzcGkxLjAgY2FuZmQxOiBDUkMgcmVhZCBl
cnJvciBhdCBhZGRyZXNzIDB4MDAxMCAobGVuZ3RoPTQsDQo+IGRhdGE9MDAgYmYgMTYgZDUsIENS
Qz0weDlkM2MpIHJldHJ5aW5nLg0KPiA+IFsgODAwMC41NjU5NTVdIG1jcDI1MXhmZCBzcGkxLjAg
Y2FuZmQxOiBDUkMgcmVhZCBlcnJvciBhdCBhZGRyZXNzIDB4MDAxMCAobGVuZ3RoPTQsDQo+IGRh
dGE9MDAgNDAgNjYgZmEsIENSQz0weDMxZDcpIHJldHJ5aW5nLg0KPiA+IFsgOTc1My42NTgxNzNd
IG1jcDI1MXhmZCBzcGkxLjAgY2FuZmQxOiBDUkMgcmVhZCBlcnJvciBhdCBhZGRyZXNzIDB4MDAx
MCAobGVuZ3RoPTQsDQo+IGRhdGE9ODAgZTkgMDEgNGUsIENSQz0weGU4NjIpIHJldHJ5aW5nLg0K
PiANCj4gWW91IGFyZSB1c2luZyB0aGUgYSBiYWNrIHBvcnQgb2YgbXkgSFcgdGltZXN0YW1wIGlu
IHlvdXIgdjUuMTAgYnJhbmNoLg0KPiBTbyBldmVyeSA0NSBzZWNvbmRzIHRoZSBUQkMgcmVnaXN0
ZXIgKGFkZHJlc3MgMHgwMDEwKSBpcyByZWFkLA0KPiBhZGRpdGlvbmFsbHkgZm9yIGV2ZXJ5IENB
TiBlcnJvciBmcmFtZS4NCj4NCj4gSW4gdGhlIG1lYW4gdGltZSwgSSd2ZSBpbXBsZW1lbnRlZCBh
IHdvcmthcm91bmQgZm9yIHRoZSBDUkMgcmVhZCBlcnJvcnM6DQo+IA0KPiB8IGM3ZWI5MjNjM2Nh
ZiBjYW46IG1jcDI1MXhmZDogbWNwMjUxeGZkX3JlZ21hcF9jcmNfcmVhZCgpOiB3b3JrIGFyb3Vu
ZCBicm9rZW4gQ1JDIG9uIFRCQw0KPiByZWdpc3Rlcg0KPiB8IGVmN2E4YzNlNzU5OSBjYW46IG1j
cDI1MXhmZDogbWNwMjUxeGZkX3JlZ21hcF9jcmNfcmVhZF9vbmUoKTogRmFjdG9yIG91dCBjcmMg
Y2hlY2sgaW50bw0KPiBzZXBhcmF0ZSBmdW5jdGlvbg0KPiANCj4gSXQgZml4ZXMgdGhlIENSQyBy
ZWFkIGVycm9yLCBpZiB0aGUgZmlyc3QgZGF0YSBieXRlIGlzIDB4MDAgb3IgMHg4MC4NCj4gDQo+
IFRoZXNlIG1lc3NhZ2VzIHNob3VsZCBkaXNhcHBlYXIsIGlmIHlvdSBjaGVycnktcGljayB0aGUg
YWJvdmUgcGF0Y2hlcy4NCg0KU29ycnkgZm9yIHRoZSBjb25mdXNpb24sIHlvdSBhcmUgcmlnaHQu
DQpJIHBpY2tlZCB0aGUgdHdvIHBhdGNoZXMgYW5kIHNvIGZhciBubyBtb3JlIENSQyByZWFkIGVy
cm9ycy4NClRoYW5rcyBhIGxvdC4NCg0KU3Zlbg0K
