Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEA832045F
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 09:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhBTHyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 02:54:24 -0500
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:34007
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229470AbhBTHyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Feb 2021 02:54:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqbLBlVX7qIBRXYLPBQkvHwp6pusEpBL7/KqZKMQaX0uFk1bxCMDu1FqLy/tya1wemxvJyeLQRXoZ100QyRTL6AuCzm0J9eVRQFVmOPOtDFL0zdwBWVd4KzVSc3AoaOwgD+WnAwfRVRBAeLLPO0PfLicUcS6M+bMSpwTyr0HS4El0HzDT3RPDgsWr0XP4oh86aaog3U+BIX6YrpcpuuFURAdYpVBhXJGdEEwE03XGCA+bgulYobkxWKD6KHaqyesTJt52F/a/5VtZmiGyCnLK4r/6ESELNKXc699dQtiP2eloptkPaPU8e9/KK5M+mzNHDwEBEdCSv7B1I8lZnw5gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abWeJKxnY8gE0F3MzcWUBu5JX7dtFQJu9FExnyOtkp4=;
 b=Dn127A3S8E/uxTOHBi6jFokrfv7Hk2G0ytFtXquQ0EO/TYtTUjGg4gUTDKi7Dpa7EEwA4NsdlGptPr/+5u1eN3KGY23DyV+kUAzrggSPbHzMcrLBzU4RvKviiOiM4uisJd7czxVU4jE3wvQLYAV/bIq8108Zfd9CNRj6iyRTiCWdIU1lOsyhyV4HalkGrcXDdFeHJntOUX94m1n6VazEjkXFmdH9Yvwat5FG5RQsj3OAMqon3W1U/fKHO6ulAizPu19Yhyl7E/N1F3siScDLW7VSfTEoAbeJJ2part05V6LKi5oyXKxHUT91jHNuLqtf7pqOpbsiY34HYNtyJaLalw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abWeJKxnY8gE0F3MzcWUBu5JX7dtFQJu9FExnyOtkp4=;
 b=tCrMcvzomxbe+q/8gktV6H9tkamvxMHkzlqMn4dqpeUGjA1CtV9NiucwN1sisk/+YWpdyYwaBtckIHCQEN2Fzw9PqbSncEq4RvhhHqhkTXGVfK2H8p8jeA3jreN9XjadsWUBGb5mfG7RZ+qytU6lTecDGr1OPjXiTI7yNEti4Zo=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2503.eurprd04.prod.outlook.com (2603:10a6:4:35::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Sat, 20 Feb
 2021 07:52:46 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.042; Sat, 20 Feb 2021
 07:52:46 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V4 net 5/5] net: stmmac: re-init rx buffers when mac
 resume back
Thread-Topic: [PATCH V4 net 5/5] net: stmmac: re-init rx buffers when mac
 resume back
Thread-Index: AQHW+ufw6MNhK2q+g0+ufguVFACpL6pLmiyAgBUoM+A=
Date:   Sat, 20 Feb 2021 07:52:46 +0000
Message-ID: <DB8PR04MB67953DBABBB9B1B85759AE58E6839@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
        <20210204112144.24163-6-qiangqing.zhang@nxp.com>
 <20210206123815.213b27ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210206123815.213b27ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3cde5103-9127-429b-5d89-08d8d574834c
x-ms-traffictypediagnostic: DB6PR0401MB2503:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0401MB2503B024FF16E5D8748F9C98E6839@DB6PR0401MB2503.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O+VKOFM3UxHp9J1HIZafDuq3ojhZgHknZ7zC+rYI8rjzyBPZeobephKOFSMwuRimUR4GNJbCcLsbMj90Azr6P5kc+V2u0Am1TiEFk7d8f5KtpNENqUXhkcI1y7LpD9oFOyNFq2D7cSC8VXeIfrbhnLG+JOpb8M7u3c6RZGJFT0u9kvHv8JKL0k/9+ouZDheI3h+jFkJzJWp9IcBdVJCJhecK/3pTN28s2pqy6eF6RuOaQDi3Z6YmCkcnOmxtI8XL/M/8jWPUTPMcjBAgl+w0WByEUVOpZH37To7sCuXtlZbJoM90erDdyBBKSEFbR9U3GiKzKY9n7DaNSvUwhNCFX5w1nh6TTu4PbjHBJrAmnYQHKUsnbGA8uEWn4c8ile+609eIQQ/1KS/HfjtrZEgvJr5J72tQYWB3owo0Q1U6W1N9iGqPkH+Bn5aL85dzR/lmUm67N0R3Qn4LzOQNvLPIFuV2U1CblBmRvP195EhuVUEgxPbnv0S8Du7X12dh8sAMnMus2e25YfKVtnlKejM7lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(83380400001)(186003)(5660300002)(54906003)(6506007)(4326008)(86362001)(6916009)(478600001)(53546011)(55016002)(2906002)(66556008)(9686003)(64756008)(76116006)(66446008)(66476007)(33656002)(71200400001)(52536014)(26005)(8676002)(7696005)(8936002)(316002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?OFI3OWw3cmVrUTV6Q1FlM1kxYVNuWElkbHdHR0grd0g1c1JaZjRLaUV4Q0FP?=
 =?gb2312?B?NEs4VG8rcHE5QnU2QVlPNjZtOTljdWJhVVhmdTJvQjZRWUJhZHd3TFN6dVox?=
 =?gb2312?B?VlNENFdmZ0JIY0dhZWI3RGR3eFlpN3lsazFjdEYra1Y4UG82ZW9qcHNRaThR?=
 =?gb2312?B?WE9KTFVQeGd5ak53aXhlWmdLRFpSSUFENUdYaGRUT0t6Q3JIc0JlVUdZMjU4?=
 =?gb2312?B?azFGc0xDTGoxOGN3YThpdUNYcHZFMTMzR1FTcHdmMXJEbnVZYUZ0cFVIMWVI?=
 =?gb2312?B?VGY3b2FkMG5BRGlJYStqaml3cE5peTlseUZSK255TVE1bGRBdSs4L3oza0dV?=
 =?gb2312?B?b0RWUTJuZUt0SmM4YWhQZ3lJQjBSbk9vQ0piY1RIVW0rdGZ4NHBIbFBKOHV6?=
 =?gb2312?B?Vkw2R0c0d05UVlFmdytURWdWTnlvcjYxb1UwZHpSN2NneEVEZzU5VjR5UWN2?=
 =?gb2312?B?aEJiMGoxd2lxdUtTMHhOUTB2OVlxc2YrUmNQQzlMSTkrMEU5Q1FXQUc5NW4w?=
 =?gb2312?B?Vk50ME1XTjFGVEZreFVKMCsvaVJYUGxIdWlTS2Yzb2FzYWhnbVQzVVlYbUVj?=
 =?gb2312?B?M0h4OHg2TEJjUFZoTlNTZHFZemtZOFUwWjl0enFQWGV2YXpLaTAvMEZGc0I4?=
 =?gb2312?B?ak1LVjd6RW4zOHhqaGdoUkNzLzZwcUgzR3F6NUlZeDFhVTVFcVBCSDFBV1Ew?=
 =?gb2312?B?UVN4YWlUSmh6bVIzQWE4QTRlTThRRnREeHNmNkRLdnowaElGdXpSL2NFZjFa?=
 =?gb2312?B?WFhCS2F3MzRXRVo3OVcweFFXWVJDZmUyMC9mdHFRLzFiQjRkNURPNmZnRlFr?=
 =?gb2312?B?b0pvQlQyREZhcFZYdzRiYVBXd2V3em1nOTI5L2w5bkFKd0ZWOWEwR3l2L25l?=
 =?gb2312?B?ajZGaTIvUWRmUkRYSzF1SjNwYVl1Z3VwN0U3RUtQMncwL1NmenJtWXYzRG9o?=
 =?gb2312?B?ZElrZWovSVVQeiswankzMFM5ejI5RUxRRmU5M3FyYXJIVitwKzhkY0JJMnJt?=
 =?gb2312?B?cklRRm1CN2NadmhYeVc0UmNNK3Z5aVVYMEhmOEo4a0ZUMHdoK0dRdUlNbUlK?=
 =?gb2312?B?c3NMQmFnOXUyUUE4SUoyZE81eFRQZXNrU0tiY1lqMUxqemlqK1Q2akxDQTQy?=
 =?gb2312?B?ZVpBaVRFMDBwMG8zeStJVHNrNXJkSGxCZXBscTgzdlRiWTBRS05WZVdEd2RF?=
 =?gb2312?B?bTBnTjJvNDVJeXZwbVBaNWEyOEJ0SkdmbytVeHRsQzZBaUM5cTM1LzBGdlNN?=
 =?gb2312?B?OTFQYTE0K0syVk5vbHFWMldKaGg0ODR5enhkQnFRemJ2Uml5ajNKUDVLVHpM?=
 =?gb2312?B?WktXTnZwcVJIVC9zbDBoUkZVQ3ZyTlBsSnlOMTJqaEt4U1p1ckU0VG9CUVV0?=
 =?gb2312?B?NnJjc1g0eWtwWWd1MVc2Nm1qbmk2NTh4RmxDVlFpbEpRSUQyd21FL092VUpp?=
 =?gb2312?B?RmkrdVJtcDFTUkVESU1hNFprbWhtdW1kVnQ5a1ZQeXhnR3B4L0dZVExzb0Ra?=
 =?gb2312?B?Ukw3Y05obWkwRmxRQ3hwM3JvNy9JdXBsc3RYeFF4dEl2UGE1SUdLWkUxKzdC?=
 =?gb2312?B?VXRwemlFQUpVSU1ZTzErY01PUGxVYkN6ZS9pVG85WUlVUHJ5dWVzc0cxSXdU?=
 =?gb2312?B?Zm5SSzdCRmltcUhBSHhsbm15YzR0RkJkMUVhdFQxUnF1cUpkVms1em0wQnlo?=
 =?gb2312?B?RVZFdGZtL2EyWlZVMDVpNTZWM3RRNWdMWWdHMlBuSGVtT01sVkJMU3lyM21n?=
 =?gb2312?Q?vdhbv6UTIRd+2mvHgmcedU/gfStz6q+5AtfhPYy?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cde5103-9127-429b-5d89-08d8d574834c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2021 07:52:46.6099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o5bfDYSNAhUS8ODKdBwUtYh792PEbmCYbCW58eWcdkal5/t0JGcFycG8kU6b3hukFGlRBSaFeocblljjBkofMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2503
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjHE6jLUwjfI1SA0OjM4DQo+IFRvOiBKb2FraW0g
WmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogcGVwcGUuY2F2YWxsYXJvQHN0
LmNvbTsgYWxleGFuZHJlLnRvcmd1ZUBzdC5jb207DQo+IGpvYWJyZXVAc3lub3BzeXMuY29tOyBk
YXZlbUBkYXZlbWxvZnQubmV0OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBkbC1saW51eC1p
bXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFY0IG5ldCA1LzVd
IG5ldDogc3RtbWFjOiByZS1pbml0IHJ4IGJ1ZmZlcnMgd2hlbiBtYWMNCj4gcmVzdW1lIGJhY2sN
Cj4gDQo+IE9uIFRodSwgIDQgRmViIDIwMjEgMTk6MjE6NDQgKzA4MDAgSm9ha2ltIFpoYW5nIHdy
b3RlOg0KPiA+ICtlcnJfcmVpbml0X3J4X2J1ZmZlcnM6DQo+ID4gKwl3aGlsZSAocXVldWUgPj0g
MCkgew0KPiA+ICsJCXdoaWxlICgtLWkgPj0gMCkNCj4gPiArCQkJc3RtbWFjX2ZyZWVfcnhfYnVm
ZmVyKHByaXYsIHF1ZXVlLCBpKTsNCj4gPiArDQo+ID4gKwkJaWYgKHF1ZXVlID09IDApDQo+ID4g
KwkJCWJyZWFrOw0KPiA+ICsNCj4gPiArCQlpID0gcHJpdi0+ZG1hX3J4X3NpemU7DQo+ID4gKwkJ
cXVldWUtLTsNCj4gPiArCX0NCj4gDQo+IG5pdDoNCj4gDQo+IAlkbyB7DQo+IAkJLi4uDQo+IAl9
IHdoaWxlIChxdWV1ZS0tID4gMCk7DQoNCk9LLCB3aWxsIGNoYW5nZSBpdC4NCg0KPiA+ICsNCj4g
PiArCXJldHVybiAtRU5PTUVNOw0KPiANCj4gdGhlIGNhbGxlciBpZ25vcmVzIHRoZSByZXR1cm4g
dmFsdWUgYW55d2F5LCBzbyB5b3UgbWFrZSBtYWtlIHRoaXMgZnVuY3Rpb24NCj4gdm9pZC4NCg0K
T0suDQoNCj4gSSdtIG5vdCBzdXJlIHdoeSB5b3UgcmVjeWNsZSBhbmQgcmVhbGxvY2F0ZSBldmVy
eSBidWZmZXIuIElzbid0IGl0IGVub3VnaCB0bw0KPiByZWluaXRpYWxpemUgdGhlIGRlc2NyaXB0
b3JzIHdpdGggdGhlIGJ1ZmZlcnMgd2hpY2ggYXJlIGFscmVhZHkgYWxsb2NhdGVkPw0KDQpBcyBJ
IGtub3csIHRoZSByZWNlaXZlIGJ1ZmZlciBhZGRyZXNzIGlzIG5vdCBmaXhlZCBhZnRlciBhbGxv
Y2F0ZWQsIGl0IHdpbGwgcmVjeWNsZSBhbmQgcmUtYWxsb2NhdGUgaW4gc3RtbWFjX3J4KCksIHdo
ZXJlIHRvIGhhbmRsZSB0aGUgcmVjZWl2ZSBidWZmZXJzLg0KSXQgc2hvdWxkIGJlIGVub3VnaCB0
byByZS1pbml0aWFsaXplIHRoZSBkZXNjcmlwdG9ycyB3aXRoIHRoZSBidWZmZXJzIGlmIGl0IGlz
IHBvc3NpYmxlLiBDb3VsZCB5b3UgcG9pbnQgbWUgaG93IHRvIGRvIGl0Pw0KDQpCZXN0IFJlZ2Fy
ZHMsDQpKb2FraW0gWmhhbmcNCg==
