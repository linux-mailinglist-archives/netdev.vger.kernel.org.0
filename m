Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725903CD135
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbhGSJLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 05:11:42 -0400
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:13472
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231928AbhGSJLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 05:11:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBh86WeZulnEel+x5PabHxaZivwAFBDucFv+LyDgl5rl1T8IZ4sYFxlzJX+Hbpvrx43GkIOWZFqdBX8/+zR2xl2l9zICL5emMbqToYI0sX2Y5SDpQvyHEQ3xAXKNPEXtIveZhXWERQNBKT6y2vFfNNwS2UR83PE0BXu3NLgL+lG4bCLFChUBdskS/PHfd8k/erw99io3r0i+2r1puGD0GTMoK4Wi9CVPbTcAH4CAishQyvS1DoUU/BnT8zOJ9J3tKaNilUmSIYEpe+HKiuYQAwxX99XnM3O3Ho+j7B5XpXPYeqkbG8yaXPkH23267TkVVLKZrGi56lVYdoTPyyTYwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bw23w9zdNptgZU/ZigaIMet8UePUNKAfiqBwFza/MUw=;
 b=ifmZ7sZnLflmq5abKd+sckKkVKmhnV8HFXFjwanP3BG3q69gOIQxjIDWTsT/xInT/QnkgQMGmmb4/LwXniWJIo2AQGobuCK/9YvBZColkzN4NSRwORRhnMOy4ixv+ALKKcsUtugxG1daoU5RRy28xnMjOseIz691SfFrbeSXx1Sv0Cx3BcObBGJnNAohzmHMo3a3fp5uVcOSZA3W3uwcfwZQJ6TS6JEOr8LC1Loq2gCubS6/YexXyQ1dW5a5Gl+VpzOvGoV0CEPG8hylFUIREuNcKE9A1FuzbwTlcV3aPTKVBWnqerptJ3hLAOeVV3QhnW4Zt6FmmfdfoShyW8nkOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bw23w9zdNptgZU/ZigaIMet8UePUNKAfiqBwFza/MUw=;
 b=Rovvlnty94dKrS6L5v//VGQ4w1MuLE4mwBtvWcrEMnmivXRAp//wiGejJSpD0Grw2qsL7OTXy3qOZaE/Q91Nfuq/Pj7111iPfNH2LOFgBlbu9ptHPIn9VDpyh8IoSX62hfjoRgLtvt526M7Yy4U2e/RqkYserG7RGk+QIyCyik8=
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VI1PR04MB5070.eurprd04.prod.outlook.com (2603:10a6:803:57::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Mon, 19 Jul
 2021 09:52:19 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::3046:abd6:b17f:6037]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::3046:abd6:b17f:6037%8]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 09:52:18 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Hao Chen <chenhaoa@uniontech.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>
CC:     "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4] net: stmmac: fix 'ethtool -P' return -EBUSY
Thread-Topic: [PATCH v4] net: stmmac: fix 'ethtool -P' return -EBUSY
Thread-Index: AQHXfIETDYlgcUwgXE69uBCWHrZutqtKDEug
Date:   Mon, 19 Jul 2021 09:52:18 +0000
Message-ID: <VI1PR04MB680027FEA266683089205D44E6E19@VI1PR04MB6800.eurprd04.prod.outlook.com>
References: <20210719093207.17343-1-chenhaoa@uniontech.com>
In-Reply-To: <20210719093207.17343-1-chenhaoa@uniontech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: uniontech.com; dkim=none (message not signed)
 header.d=none;uniontech.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b21cfb10-f065-44f4-f34c-08d94a9ae5bc
x-ms-traffictypediagnostic: VI1PR04MB5070:
x-microsoft-antispam-prvs: <VI1PR04MB5070153BB7C4A10A2AC38116E6E19@VI1PR04MB5070.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wgWjTuLIIfJfK68GSECQfpcT4x7mN6UtLsC8XCHUZBFRcg4RdcCxZzwxRzBW+seyhsn9sm1joMTKDupfl5a55gXpngJY7tXoX8zrWVhSdALxmoIbul/8AhaKOJ6u/W4HIu/eUYAZHYjUqkKPAVDhVByxmMPKJX8FIYUsa+uC7EAQ5FKxBrXL0fBqd9F84QA+v586tjKQUrqOwF4FLS4vgoD1EWbWoDQ9vI7Kkz2AgziZ3o6lXMof1RuUPimSq9mEhpjd8J2PvCKpajlEaN8W5Sk/iCpSS4a0HKuMQelIiPOXAnVAsYU+g3VFP+kipk4ILkpma+onr6AIXgpHuVNebf1/5lFtrwVR2GeSgAU8R7U4bt1JtOx94p5mDAxXvy0+8+Jm1ha3A9vRb90gBEokLY16ydZ4FXoJI2t8SJHMxv1Z6QYndrkbYQHGLTGxixBKG06KFfcsiAOVPFmechVf6gfVN9fJQgC+P/cvFP4RWN06U+oNOWgtjNUhFiuMgWMeLxh/T3IYxSfP/YApFphcZXFx2C9jJ0p3bP7od+FZ6rWbTGu6J0IzyMrufi+0wb89eM1QQH9RGV9rGiRUTDNVeO+MMD2nL13/sQz9QR7yy1ezqBb4pJEna/oNQ28YZYSfGTo7bTYIccFoDObMh9A5DRSoH7dFobOn+NplkeAiQvAfPUjPLmI5JZza6dn+mfCyU6BPCMInc/PFNE/XcFYZrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(54906003)(66446008)(64756008)(55016002)(66574015)(66946007)(66556008)(71200400001)(9686003)(8936002)(38100700002)(86362001)(122000001)(76116006)(478600001)(66476007)(5660300002)(83380400001)(8676002)(4326008)(7696005)(52536014)(110136005)(2906002)(7416002)(316002)(53546011)(6506007)(33656002)(186003)(26005)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?OUp3SHB0TmlUNGhNSHZCNDZvSE1xUGNSTFphWFVMVngwSDN2Ui9VRGpGWkVa?=
 =?gb2312?B?bnp4eVI3aS8yeWNsRi9kUnI1UG1IRzBLb1k2SEdsTGlBeE4xanlrYmtZeHlE?=
 =?gb2312?B?NmRLRlRkZGh0ZHI3TnhVaEtaWlg1U1Q5QXZ6MmNGb05LWTljaDRFNUNaVms1?=
 =?gb2312?B?TlhBV29JclArMk1UTDgxbXZrbmFBRGkvS2FTdHBDV3M0TXkwazhmbmpudUJH?=
 =?gb2312?B?RTFpSXRZWkxJS2RRZ1o0UEo0UVlJY2FTdTVFRmcxakRoL3VwTXFOTGw2c3Zi?=
 =?gb2312?B?YUUyRlR2YlVYYU5mVjlVZ2dYWnV0eVBzd3R6VFMxRVJlallQc1RObFJncGIz?=
 =?gb2312?B?djhGSjhwYTFxQ0FJeHEzTnN4WnNid3hmVmNVaGJIWWJjcmh4VkpaTDRzUnRM?=
 =?gb2312?B?eUp0WVBvL1JPSmF0K2p2SzNtbStjb1l4ajlNd2Y3SGJUWVpNSElpY2lxbEw2?=
 =?gb2312?B?R2hST3pMR0lQQXFGVEFWS1lVRlBSdEs1L0tLMEQvUllDSHROdXc1RmJpclhD?=
 =?gb2312?B?SkdLUG84RG5Vd0JxdkNiWXVCOXh4bUlpVmE2OHl4YVNvZ0xDVG5lVE0xK1pN?=
 =?gb2312?B?enozTjIwbW85MG13M3BnS000WFgxNEFrMnpuY0FnUEpleHZxdjVNYXRxaEIv?=
 =?gb2312?B?V1I4ZVFhcHg3Lzg4UEVBdnV4b1NPeXE3Vk1VSzM4NWtoaTZ4OU84YlNVanZX?=
 =?gb2312?B?UENaMDlpclBRSElpMXROZjg1cUJzeWpBUGUzd3N4dVBqMEx0RGU4RXBkN0pS?=
 =?gb2312?B?a1k0WWdxUHMyNDNZeHdXQkhSN24zSUJud0lLZENhOGMxWFNWNTVIZFc3TEhV?=
 =?gb2312?B?dEV5OEo2VFQ0ZGhSVU5XcjJHQTdtMXFSbGhkSHFxZGtRcFk3UmNDbEFodC9k?=
 =?gb2312?B?eUpRVXBSazJidy9IRDFUWlhrSkdFdkpsR0hmenRZMHhvZWhZM3RPYTJLR0sz?=
 =?gb2312?B?bVZ2SzF4a3g5Snhua2Y4YTUzc1RXeWdEeU1xbGpVZnJKUDNIRHNTWFNjUEw0?=
 =?gb2312?B?NGFhRFB1RnhUUFZ1TGdSKy9qdnZVb1BHTS8zZjJ0bzNiMDJYQjdzYUFNd0wx?=
 =?gb2312?B?YzBqM1RoekhtQXgrbTN1WTJ2S1Ivbkx4NyszU3hoSDNLYS85cW51Q255YlBH?=
 =?gb2312?B?WkRTQjRYOWJha21yeG4rVGFsTFFDTXpNYTc1aHpNUFAzUzJBOUdvSGZ2RC9G?=
 =?gb2312?B?Tk5ucENBS1lYaUpZc1NKTllDWTdvRjdoeFREUFhwek1yREdmZmpzSW95akdJ?=
 =?gb2312?B?TGdLdW9VMndtZUVzb3FrVS9sRHdKYnZVckx3RjJUazF1N2kvUXNYTE1DN1BH?=
 =?gb2312?B?b0lXSXFkQ1VnTEVaekxWZFJRdkxqRVYzLzRXU1lXUFlNS1pRQXgyWEZCbWN4?=
 =?gb2312?B?QjhvNTZMVVBHMWJPOTdiVkYzbDlsMFNZdUY2bmR5WHRCMWJHaEUrUXF0Znoz?=
 =?gb2312?B?QVBPVjM1NlhtVmxPQ1gyckE3MDZONmhFcXFTVllSUTFiYXpCRC9XUFByYUg4?=
 =?gb2312?B?dkhSTUhxanRDYTcwdnRCcEwvUFJpamJiQWpHOXBmMitoQVNIYVM2ancrWXg1?=
 =?gb2312?B?dVZ2SUYrWUphRCtFTklOL2lCNDdSYXp6K255WVV4b3ppbDVyUjNxRG11QXdP?=
 =?gb2312?B?Z3YxTmlxMTEyaUtEdXZYV1RvUGZuVXdzSFBIUU83TmhRUXF3RktQZlF3NVJw?=
 =?gb2312?B?R0xQc2tRKzJrcktQU21ZNmwxT1o0SW9mRjFDRFRmbXB6b0cwemZxOFNjQ2lZ?=
 =?gb2312?Q?IO+ZHFRduclilXPd/mi8HLisg8zXnMtm12YTGnh?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b21cfb10-f065-44f4-f34c-08d94a9ae5bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 09:52:18.8026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0A8817Xm8DE8/g8270JzIS9UHcT5GzfGR08zNWo1nqkrKT61Y36+elYtxJurrwXD0t1I/fj2klh5Iiu5dOiN7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhhbyBDaGVuIDxjaGVuaGFv
YUB1bmlvbnRlY2guY29tPg0KPiBTZW50OiAyMDIxxOo31MIxOcjVIDE3OjMyDQo+IFRvOiBwZXBw
ZS5jYXZhbGxhcm9Ac3QuY29tDQo+IENjOiBhbGV4YW5kcmUudG9yZ3VlQGZvc3Muc3QuY29tOyBq
b2FicmV1QHN5bm9wc3lzLmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwu
b3JnOyBtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tOw0KPiBsaW51eEBhcm1saW51eC5vcmcudWs7
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LXN0bTMyQHN0LW1kLW1haWxtYW4uc3Rv
cm1yZXBseS5jb207IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IEhhbyBDaGVuIDxj
aGVuaGFvYUB1bmlvbnRlY2guY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggdjRdIG5ldDogc3RtbWFj
OiBmaXggJ2V0aHRvb2wgLVAnIHJldHVybiAtRUJVU1kNCj4gDQo+IFRoZSBwZXJtYW5lbnQgbWFj
IGFkZHJlc3Mgc2hvdWxkIGJlIGF2YWlsYWJsZSBmb3IgcXVlcnkgd2hlbiB0aGUgZGV2aWNlIGlz
DQo+IG5vdCB1cC4NCj4gTmV0d29ya01hbmFnZXIsIHRoZSBzeXN0ZW0gbmV0d29yayBkYWVtb24s
IHVzZXMgJ2V0aHRvb2wgLVAnIHRvIG9idGFpbiB0aGUNCj4gcGVybWFuZW50IGFkZHJlc3MgYWZ0
ZXIgdGhlIGtlcm5lbCBzdGFydC4gV2hlbiB0aGUgbmV0d29yayBkZXZpY2UgaXMgbm90IHVwLA0K
PiBpdCB3aWxsIHJldHVybiB0aGUgZGV2aWNlIGJ1c3kgZXJyb3Igd2l0aCAnZXRodG9vbCAtUCcu
IEF0IHRoYXQgdGltZSwgaXQgaXMgdW5hYmxlIHRvDQo+IGFjY2VzcyB0aGUgSW50ZXJuZXQgdGhy
b3VnaCB0aGUgcGVybWFuZW50IGFkZHJlc3MgYnkgTmV0d29ya01hbmFnZXIuDQo+IEkgdGhpbmsg
dGhhdCB0aGUgJy5iZWdpbicgaXMgbm90IHVzZWQgdG8gY2hlY2sgaWYgdGhlIGRldmljZSBpcyB1
cC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEhhbyBDaGVuIDxjaGVuaGFvYUB1bmlvbnRlY2guY29t
Pg0KPiAtLS0NCj4gIC4uLi9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfZXRodG9vbC5j
ICB8IDE5ICsrKysrKysrKysrKysrKy0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRp
b25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19ldGh0b29sLmMNCj4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfZXRodG9vbC5jDQo+IGluZGV4IGQwY2U2MDhi
ODFjMy4uMjVjNDRjMWVjYmQ2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9z
dG1pY3JvL3N0bW1hYy9zdG1tYWNfZXRodG9vbC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19ldGh0b29sLmMNCj4gQEAgLTE1LDYgKzE1LDcgQEAN
Cj4gICNpbmNsdWRlIDxsaW51eC9waHlsaW5rLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvbmV0X3Rz
dGFtcC5oPg0KPiAgI2luY2x1ZGUgPGFzbS9pby5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L3BtX3J1
bnRpbWUuaD4NClBsZWFzZSBpbiBhbHBoYWJldGljYWwgb3JkZXIuDQoNCg0KPiAgI2luY2x1ZGUg
InN0bW1hYy5oIg0KPiAgI2luY2x1ZGUgImR3bWFjX2RtYS5oIg0KPiBAQCAtNDEwLDEzICs0MTEs
MjIgQEAgc3RhdGljIHZvaWQgc3RtbWFjX2V0aHRvb2xfc2V0bXNnbGV2ZWwoc3RydWN0DQo+IG5l
dF9kZXZpY2UgKmRldiwgdTMyIGxldmVsKQ0KPiANCj4gIH0NCj4gDQo+IC1zdGF0aWMgaW50IHN0
bW1hY19jaGVja19pZl9ydW5uaW5nKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ICtzdGF0aWMg
aW50IHN0bW1hY19ldGh0b29sX2JlZ2luKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ICB7DQo+
IC0JaWYgKCFuZXRpZl9ydW5uaW5nKGRldikpDQo+IC0JCXJldHVybiAtRUJVU1k7DQo+ICsJc3Ry
dWN0IHN0bW1hY19wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gKw0KPiArCXBtX3J1
bnRpbWVfZ2V0X3N5bmMocHJpdi0+ZGV2aWNlKTsNCj4gKw0KPiAgCXJldHVybiAwOw0KPiAgfQ0K
DQpBZGQgZXJyb3IgY2hlY2ssIGxpa2U6DQpyZXQgPSBwbV9ydW50aW1lX2dldF9zeW5jKHByaXYt
PmRldmljZSk7DQppZiAocmV0IDwgMCkgew0KCXBtX3J1bnRpbWVfcHV0X25vaWRsZShwcml2LT5k
ZXZpY2UpOw0KCXJldHVybiByZXQ7DQp9DQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0K
PiArc3RhdGljIHZvaWQgc3RtbWFjX2V0aHRvb2xfY29tcGxldGUoc3RydWN0IG5ldF9kZXZpY2Ug
KmRldikgew0KPiArCXN0cnVjdCBzdG1tYWNfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7
DQo+ICsNCj4gKwlwbV9ydW50aW1lX3B1dChwcml2LT5kZXZpY2UpOw0KPiArfQ0KPiArDQo+ICBz
dGF0aWMgaW50IHN0bW1hY19ldGh0b29sX2dldF9yZWdzX2xlbihzdHJ1Y3QgbmV0X2RldmljZSAq
ZGV2KSAgew0KPiAgCXN0cnVjdCBzdG1tYWNfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7
IEBAIC0xMDczLDcgKzEwODMsOCBAQA0KPiBzdGF0aWMgaW50IHN0bW1hY19zZXRfdHVuYWJsZShz
dHJ1Y3QgbmV0X2RldmljZSAqZGV2LCAgc3RhdGljIGNvbnN0IHN0cnVjdA0KPiBldGh0b29sX29w
cyBzdG1tYWNfZXRodG9vbF9vcHMgPSB7DQo+ICAJLnN1cHBvcnRlZF9jb2FsZXNjZV9wYXJhbXMg
PSBFVEhUT09MX0NPQUxFU0NFX1VTRUNTIHwNCj4gIAkJCQkgICAgIEVUSFRPT0xfQ09BTEVTQ0Vf
TUFYX0ZSQU1FUywNCj4gLQkuYmVnaW4gPSBzdG1tYWNfY2hlY2tfaWZfcnVubmluZywNCj4gKwku
YmVnaW4gPSBzdG1tYWNfZXRodG9vbF9iZWdpbiwNCj4gKwkuY29tcGxldGUgPSBzdG1tYWNfZXRo
dG9vbF9jb21wbGV0ZSwNCj4gIAkuZ2V0X2RydmluZm8gPSBzdG1tYWNfZXRodG9vbF9nZXRkcnZp
bmZvLA0KPiAgCS5nZXRfbXNnbGV2ZWwgPSBzdG1tYWNfZXRodG9vbF9nZXRtc2dsZXZlbCwNCj4g
IAkuc2V0X21zZ2xldmVsID0gc3RtbWFjX2V0aHRvb2xfc2V0bXNnbGV2ZWwsDQo+IC0tDQo+IDIu
MjAuMQ0KPiANCj4gDQoNCg==
