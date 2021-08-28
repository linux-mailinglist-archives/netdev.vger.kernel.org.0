Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37813FA4C7
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 11:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhH1JfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 05:35:19 -0400
Received: from mail-eopbgr1410103.outbound.protection.outlook.com ([40.107.141.103]:11765
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233550AbhH1JfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 05:35:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJwbs61EHhYugvtMb45tWqpD71mHvu9Wh5HXM7Vq8lV4X95lKP6DqWGmiYWhydMr0RDRA4OwQ3+q17r5WtqpS+ve29eF4cBn36vbkby62Rw1TbAmLOoQ+PCMDwRQU7TyazJ+tOL3qqGaap+YqkYS6rPbQZ/JNdHa7oxlPSggbpWnRQr8pEw7O6gU88OOmpCKTEe6orT+AeCOTaRi8wv+PokgcJMZvghq9RCE11VvgxKkx5rE4vKk8vqNX5vd2JaDumi/WELwLFcttdo/J83R3WQNn1v3mdPN/v68mRUHzuVHV7wMivkcqJKEuzcTLU2DD3mpNFpQT7iyA/V6jXgneQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wiagc3dq06InrSx7ItSNObtUJhwu1jyb/UzyyT1WYBs=;
 b=coOU4QtZgOrAyVf20d7eObhOREI0SXuJUhCmD0nnWpNW8ikfWXXgxoczfKFaBD2oc92sFrA8juFdQIlignH30VEZMWcsoQXqpcdCOv17WvudCQkha7OgHyxlZt6vfIM7G4wJ6s2V88RpgDmPICtKZp9Y6boxAHi0NiaeAFHLLW+HL+sA6ZN0zsFC/PvrBaKrB6vVTR6QdIUpuuxtMQNagpSEior8CDJJ0qPOjGg4LlgHtpaYSUMe4Et5JjOwCJKgJC8oH08TA7cAZDXNQdiAMubWpgEW+dyDrZsZBwOx8589tAa6Bk7WbOG8uIPoUZuOYUClxxcQ1BiFZj5db75QBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wiagc3dq06InrSx7ItSNObtUJhwu1jyb/UzyyT1WYBs=;
 b=ctxsuFPqzve+/hft3bziseGm422oGjKNRewXUYlDX0qpHPXMf6kQEWkUbgqo+W2AeICshQFsneIiz7upnVlpSdbtWzMEsYCth+9emeqoUc7MdIoBoyKaMP35el10QReszfvwL6aVL546Ttt6rV/75lyB1uwPO+wUO6NDejo06MU=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6486.jpnprd01.prod.outlook.com (2603:1096:604:e1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Sat, 28 Aug
 2021 09:34:24 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%4]) with mapi id 15.20.4457.023; Sat, 28 Aug 2021
 09:34:24 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next 12/13] ravb: Factorise ravb_emac_init function
Thread-Topic: [PATCH net-next 12/13] ravb: Factorise ravb_emac_init function
Thread-Index: AQHXmX80u5my7KF7n0uvL9mFOYNdFKuHxwgAgADkOzA=
Date:   Sat, 28 Aug 2021 09:34:23 +0000
Message-ID: <OS0PR01MB5922A5E5F7D0BBB81D3CCF6F86C99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-13-biju.das.jz@bp.renesas.com>
 <6d2a7dfa-94e7-bdc5-f437-8656c9921f29@omp.ru>
In-Reply-To: <6d2a7dfa-94e7-bdc5-f437-8656c9921f29@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e804c64-43ce-4454-63c3-08d96a070596
x-ms-traffictypediagnostic: OS3PR01MB6486:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB6486CFD03B9496C07A7C978986C99@OS3PR01MB6486.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oX/uokCYBhjRsBSmshtEKOSUAsffDZM4wOjBDpW+naY0wa7A55Ze5+KXqx2XaXtOEr10/suG58LTqYrbTKS9nMG53WnPfSemvTLKQW28NvvfAFJCrw7XG21Jn64IGDZ5kL9YDE8Y1Zk82hiKBpQ8ThTgPHs5CmaMjN5CEOD5wSusLRpPLdEWXnO2Ukp+gieTKOhFXaUzdPadiNG48TE5xsCXcDwSh9RCaA3HYHnDNl42UeSsJ+EaOyKBLuXuMFNJp/4x1VvQbyjnBA7aBsk5ZM1lptl5VWttGojwaWjVN1qWI2tOlep4Vt+e8tTwKyj6PSvXNMAogwvwlt/Salg4QpIsb+t54qMDU22D26XLUUq9C4vXQtOTU3YLf4ofmVVqZTjw8I+dkSs0od4FTR3DeCTVkCJVB5MihpyD3FYtXJySpU7sMeIbFgAGRQtY3KDS7RLJAeSkLWWgtBfAKG1srku9Z6sGkmsK0jpUEFzmXHz2p1D1dI2dygxf55udMpjR72HPZrldwxCcPhwyQqpUO88Gih05DrfHJoMMWq5LQQJjxSLmp3W+lqoRIv1Wx6WXgzcliCMMZk+9hpTYlGM17GpF9e5YJmAka2SbVx9LV4WjWEWMpC33pkBBkmqjLQFGqYEhhanUQO5SDAtAawbL91kziFkNHS1EoLpJp/mvAcTOl/qY1u847dCvmgg6QdLNgnM+Vr5jr6JjfqoKXHWKXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(8676002)(76116006)(316002)(6506007)(83380400001)(9686003)(53546011)(55016002)(71200400001)(478600001)(54906003)(52536014)(86362001)(122000001)(66476007)(66556008)(38070700005)(4326008)(110136005)(26005)(38100700002)(33656002)(66946007)(2906002)(186003)(7696005)(66446008)(107886003)(64756008)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzdwMmZRTXlWbi9jR0hheThhTHhYTDMyV0FTeG8zZFVWUE9WYzA5aHEyUkEy?=
 =?utf-8?B?djhoY1BmOFU1SHNsV0xtUXpnTUlGVzR3RXVQWVF3aDh4NnlNaldXZDl2WUQ4?=
 =?utf-8?B?alkwejVVemkrWFltWFQ0K0pBenZFV2pzRG8xdjVqQmsxWk5GanRsM0F2endl?=
 =?utf-8?B?RmZVeU4yZ1N1Ti9yMXdiVXY5cURmcnhZVit3eitQNVZsQkFIZEZGR0RyV1pR?=
 =?utf-8?B?STNmdFcyazRKR1NGWWNOVVBpc1BmTHMyZTJjOTg1dUkxalowVklxS2pURUVJ?=
 =?utf-8?B?VXQwem82bWNLSVltZFlGaVRudmlrK1lXbkVnYkd3Zm1VK3c0NmhPaGYza1J0?=
 =?utf-8?B?cllwaEZIRDlLWUFCbWhYL1lhZ2tsY2VDaFpHODFrTTVGVVpncDJHYVBNOVJr?=
 =?utf-8?B?TUhkSmtqUXRoTnk0d0tBenNCVW5HbTBMOHpjT0hCVVduV2wrTExRcDY5dktM?=
 =?utf-8?B?RWhYVTJsSlRHM2pYd2hMSkU3TXhzcjkzMTg3aE9UKzdSc0ozN2E4aTNKcWUv?=
 =?utf-8?B?YWI3Wk5rbzFxeFpxN3ZPY200dUxpbG85LzFKWWt4T3p0bDAvcXRPOU1hUVdO?=
 =?utf-8?B?Sm9YNVJGT1gveHY3cnhscy9CNGszUGE1NzJzbFZmMEp4cXk1S0pYc3dmazNw?=
 =?utf-8?B?M1BBdzFLbGRWVHpuWW5ObThPZVIxai82WFByR2tVdXVaQXFpemtHSmtUcm1C?=
 =?utf-8?B?dTkraE5wQ2J5MDZlejNJd2pnYmdlMW90STlidlJNVklYbFpDY3hFNUphSUdp?=
 =?utf-8?B?Q2xIZzgrdXRmNE4xVjBidWR6RXJzZ3hvZUdYNmR0ZXRVS2JKWHljOFo1SWV4?=
 =?utf-8?B?Sk5PNEtOaDh4cktNNGd6a1FEYXRkRDh4dU12KytaWUY1Vll3T1hkeTc0V21C?=
 =?utf-8?B?M3o1VnRJejFnelNOYUVNVjFaWjNnVnF2eGdxNjYrL0VOOWFma1ZsQnRQR01l?=
 =?utf-8?B?VGJ5M1Z6S3Q0b05tRnBuUWNubHdLWGh3bDFpNnFvSkliY3NUNGNndlYwRzkr?=
 =?utf-8?B?WWZTeVZQM3l5QzRIWGJNbzk5SXU4bElTU3QyVkVnOUlhYVlSeW4yMDFxb292?=
 =?utf-8?B?VlhWVFB0Qko4T212RVhyY3V4NlBZOUNVaHVPd0xjWjhWVzZlalRkdnJNRXdp?=
 =?utf-8?B?ckQ3cTRIbEVVa0ZpTUpJTWtrZ2lZdENENUpsdGx1N05HcU9idFFEcmJuM1RE?=
 =?utf-8?B?NG43L3Q0enFVVGNuTitTSEw4dXZxeVBaWk9uRkp3S3VBdk9Vdm02d2VnZW1L?=
 =?utf-8?B?TzE1QXgxWFJ3K1lPLzNmTkdkUUtyeFQwUWN3c0NITUpJZ2VtdGk0ckYvMmln?=
 =?utf-8?B?dWVWazdlN21oa1h6UFMyZVZjR3YyR2hNQm1ZUUt4b1hjWCs2N1VqV3ZzSUto?=
 =?utf-8?B?NG5qVGJzY1R0L1F1cHEvQ3pmVmVsT3U5NVkzRTZ2UXBOMzlnaFFaOWpTbmsw?=
 =?utf-8?B?OEdGMlRROEF0Z0pNak9QMXloeG9uM2IvM0o1YW9kdnd0eisrbkJBdjBXZWQ5?=
 =?utf-8?B?dWhwZFI5clpBMWpaTk1xYzZaeHBqSXhLV3FHa2VJVC9WTHJFa0UwYzRBZnUw?=
 =?utf-8?B?amgzNVcwS1NoWE91RDE1b3M3ait1R2wzT05HRTlPWVRycWN1NzRPbkh3cHRQ?=
 =?utf-8?B?ZkxsS28wMDdMYjdMVmtGTGVmNlBnc3FNWWsyaFlCU09Da3RLTjVaRURGdEh4?=
 =?utf-8?B?VFM2dUppRUdpMXF5TWw1MVh5NUNyZmhHdnc4cVdrM3RNRlZ6cllpV24rYmNS?=
 =?utf-8?Q?sPed+S41+ulQM7inWw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e804c64-43ce-4454-63c3-08d96a070596
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2021 09:34:23.8562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AfPQw8V0CmnCkngtTYYTRXBMHCUirmROicful8XjjIS3JYta7g3jyGKHYmAYyKqAgZuTBW1Okg+dzQquHe3/95gGJDdD8SKmMsub0Z/vgSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6486
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IDEyLzEzXSByYXZiOiBGYWN0b3Jpc2UgcmF2Yl9lbWFjX2luaXQNCj4g
ZnVuY3Rpb24NCj4gDQo+IE9uIDgvMjUvMjEgMTA6MDEgQU0sIEJpanUgRGFzIHdyb3RlOg0KPiAN
Cj4gPiBUaGUgRS1NQUMgSVAgb24gdGhlIFItQ2FyIEFWQiBtb2R1bGUgaGFzIGRpZmZlcmVudCBp
bml0aWFsaXphdGlvbg0KPiA+IHBhcmFtZXRlcnMgZm9yIFJYIGZyYW1lIHNpemUsIGR1cGxleCBz
ZXR0aW5ncywgZGlmZmVyZW50IG9mZnNldCBmb3INCj4gPiB0cmFuc2ZlciBzcGVlZCBzZXR0aW5n
IGFuZCBoYXMgbWFnaWMgcGFja2V0IGRldGVjdGlvbiBzdXBwb3J0IGNvbXBhcmVkDQo+ID4gdG8g
RS1NQUMgb24gUlovRzJMIEdpZ2FiaXQgRXRoZXJuZXQgbW9kdWxlLiBGYWN0b3Jpc2UgdGhlDQo+
ID4gcmF2Yl9lbWFjX2luaXQgZnVuY3Rpb24gdG8gc3VwcG9ydCB0aGUgbGF0ZXIgU29DLg0KPiAN
Cj4gICAgQWdhaW4sIGNvdWxkbid0IHdlIHJlc29sdmUgdGhlc2UgZGlmZmVyZW5jaWVzIGxpa2Ug
dGhlIHNoX2V0aCBkcml2ZXINCj4gZG9lcywgYnkgYWRkaW5nIHRoZSByZWdpc3RlciB2YWx1ZXMg
aW50byB0aGUgKnN0cnVjdCogcmF2Yl9od19pbmZvPw0KDQoNCkkgd2lsbCBldmFsdWF0ZSB5b3Vy
IHByb3Bvc2FsIGluIHRlcm1zIG9mIGNvZGUgc2l6ZSBhbmQgZGF0YSBzaXplDQpBbmQgd2l0aCB0
aGUgY3VycmVudCBjb2RlIGFuZCBzaGFyZSB0aGUgZGV0YWlscyBpbiBuZXh0IFJGQyBwYXRjaHNl
dA0KZm9yIHN1cHBvcnRpbmcgUlovRzJMIHdpdGggZW1hY19pbml0IGZ1bmN0aW9uLg0KQmFzZWQg
b24gdGhlIFJGQyBkaXNjdXNzaW9uLCB3ZSBjYW4gY29uY2x1ZGUgaXQuDQoNCkN1cnJlbnRseSBi
eSBsb29raW5nIGF0IHlvdXIgcHJvcG9zYWwsIEkgYW0gc2VlaW5nIGR1cGxpY2F0aW9uIG9mDQpE
YXRhIGluIFItQ2FyIEdlbjMgYW5kIFItQ2FyIEdlbjIuDQoNCk11bHRpcGxlIGlmIHN0YXRlbWVu
dCBmb3IgaGFuZGxpbmcgZHVwbGV4LCBpbml0aWFsaXNpbmcgQ1NSMChDaGVja3N1bSBvcGVyYXRp
bmcgbW9kZSByZWdpc3RlciksDQpDWFIzMShJbi1iYW5kIHN0YXR1cyByZWdpc3RlcikNCg0KDQpS
ZWdhcmRzLA0KQmlqdQ0KDQoNCj4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUu
ZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyIDxw
cmFiaGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+IFsuLi5dDQo+IA0KPiBN
QlIsIFNlcmdleQ0K
