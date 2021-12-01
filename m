Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3EA464498
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 02:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244362AbhLABoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 20:44:32 -0500
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:63297
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231186AbhLABob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 20:44:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=df9GOl+uwKD9bVjxp+krK3ZkT5odXQtEywDgaO8NUEd5XGqQBp0i/LDY7hpwyv/0A30qn+ggAb534T1CHNGLqE6bx4mpl3o7fHW8q0/KPgDbR5e0lpe0MMzoa4AOIP9lYS8TBk6IFsxkBLcj2LH9W6mIej3eMRYzTVChsck353FnQTwQlnlfumb0uUSEBvquXxiADpbJ0Ojy4It6prbswZesYaIl6vSlwoRklNGADxwx23ffN3RbnKY4i1+EQwHbRmG1iwwX+TGXyn4/XOE2/TY3kAouXxSvw/2KoicAtceD9dBIGwHm54ZLnqCL5RD9v0RURplDtS0IlWnf2ReNjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSHuR3dVNOtfWDmJ7MQ4AjR6G0mU3Ir75GCVZilMZSE=;
 b=U67R04SD011QQj0IalbpCXGTvv2t+FBYKAzOnfV9riXYlTs0QJ1rkcf2Ah670pG/0kw6e2Yqi4movwIrTjqliJ5N86BE5sb9xKScTJ5wZZuKe+HPTOzDgVxkm8oeUQK5mFXe6YuMTKxG2UwdMGDwBm76BD81mdx6Oqs30HuSQtfyE/51wDGueb/oDs3LnCAGf5qPtRMVNdu4bGfimTpCW6klNJzTrlwqUZNqMHsj+a+RA2H/FbPtjAxalM/QIEjyZF1YyXbZvXlcu1I9325rNxiuc1unPXQHvB/nVpAQA4GowjYunYHrk9a3CMLelJ+qIurFh0iwMb2o7kJI0eKfaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSHuR3dVNOtfWDmJ7MQ4AjR6G0mU3Ir75GCVZilMZSE=;
 b=U4Nyc1IAwjDdbf+TCcI2ULMeis20PvSLRy0R/FmQ0QbondAwMyfMwDrJ4BWjrhSnNRyHQ/Qg8Co1wEHcjGfXWkW2sIEsZROuEV8J5MsrzuKgb2obnAyWCr669nlHOQSaMIhmyy4HsZ68JN14XB/JKnjzvKQggUit1+c6RhuzRX4=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (20.179.12.22) by
 DBBPR04MB7900.eurprd04.prod.outlook.com (20.182.190.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.21; Wed, 1 Dec 2021 01:41:09 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::30f6:2b14:3433:c9bf]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::30f6:2b14:3433:c9bf%5]) with mapi id 15.20.4734.024; Wed, 1 Dec 2021
 01:41:09 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "Anson.Huang@nxp.com" <Anson.Huang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        Mingkai Hu <mingkai.hu@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: RE: [PATCH 1/2] arm64: dts: imx8mp-evk: configure multiple queues on
 eqos
Thread-Topic: [PATCH 1/2] arm64: dts: imx8mp-evk: configure multiple queues on
 eqos
Thread-Index: AQHX5ktoNLZxkixqLUaTmyPeuqvCIawc2vhw
Date:   Wed, 1 Dec 2021 01:41:09 +0000
Message-ID: <DB8PR04MB57853E3EB5431A09BD22FDFDF0689@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20211201004750.49010-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20211201004750.49010-1-xiaoliang.yang_1@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8b6f4f1-0cc4-40d1-7b63-08d9b46ba62f
x-ms-traffictypediagnostic: DBBPR04MB7900:
x-microsoft-antispam-prvs: <DBBPR04MB790072F045B9399FE4E43FAFF0689@DBBPR04MB7900.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ejQpfDDVxvSIoF/A27C6mdRNLKkG1qzJg1ewgP8jN7S4LXc3qmQjwKlRWUcd+cbw1MysHtFFGifCIm9K4+iRDMKAH0ESPxY/dZM84qonVoJjzaBIEmL1zjAaSgHdf5STU1ZVvfKu5GfsAoEADZuRovy/PflBhf4Up7nzlnm6GekIBhez4jupE5/ZL5Mg0tV6nmGmnJRzUibHw5WudHceBjr3GbYpA7FdG+y0uDoAzSAjhwyg9iVTCDgnVtUrQ+b9jxTIuI8CIRUqv3x1y4B9dDy4BnsFWxXgOQmxAJYjw6UWn5slHylePS+PsBsEalSVc3reaJcd91I3i8q0EmtMRN2LCEnPT0lKentR7T0vr+9ygqLPIdN63MwknA+SM6TwZPD8wAEe7FDMYxsvC+hPsfo7xBKF0Fd97u/W+PcmsEdRqd/08yAX88FWHcNM+ZMca2806s1sfrXH5NHPFub7uUOv3Rq0RI+cRwak9Rc11kRfSLIqRCA6evDyfttsLl3qOVLu1roOh/Q4/vCkO7eD2XwUzuFJvn9iJpYEfPRL6we2jSGEGUvGy8kkSAjkP5CE4OBTfc/HzApe728Ghxx/Fy8YyTw5Qugp0we/ktkAml9FF373NoP0QgGDLlWF9jHmDDIKzsLrcxAIlp7HLFRCEuQ1QkQl+M6SGF5SiEyzG/RZv16ymQ9DqdebmABtP69NQwhJd5hrbmjLg53l2i3i6j4llfOB9oqro6N7qXYe+8w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(6506007)(26005)(5660300002)(86362001)(38070700005)(2906002)(186003)(38100700002)(7696005)(508600001)(9686003)(52536014)(4326008)(55016003)(7416002)(110136005)(54906003)(122000001)(8676002)(66556008)(66446008)(64756008)(66476007)(76116006)(66946007)(316002)(8936002)(33656002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bWYrYUlnVDBkcTNJckZ3R3NXMFBrS2p1WEdsZkhXeXJBai9ZTVNwanFBVlVM?=
 =?gb2312?B?RlhjcnpBWGhGeURhWTA4MzdrS2o1Q2ZnRGNoaDdGL084YzBHTHQ1ZVY1Y1Ix?=
 =?gb2312?B?b0NVZkxQWmpCM21uenNsdVE2NVNTSEJ5b0FyZUJOWHNTRWovRXhlb3VJVUxy?=
 =?gb2312?B?MDBrZkFjMTRyeVJNdExzSDh4RU85T3N4UGd4Z21KbUdBYkxsMzgvNzVWc3JI?=
 =?gb2312?B?OGNaNmF1QlhKTzJCZkpJMjNoeThuTk9SQjdoRnFMcHVDUTlJNkdxazRJMmlY?=
 =?gb2312?B?eThWVmdTQWNpNWZ4NEJ5SUkwczJqNnVNeVpjZmlJZFdlY2tYMjUraGcva2l4?=
 =?gb2312?B?Rkp0SVgvZXlGN2FoRGJrMUtoRUIwWjNPcmdpMHlVKzRNeTRzVngyVld3Tk1R?=
 =?gb2312?B?QnBRS3Z1ZXpNM0tycnI1VXpFdUcxZE81MXdNcVp1OXJXbFdtNGxNS1ZCbnhW?=
 =?gb2312?B?cVRQSHcreUZGZlo4MTlGYXNJQXFpVWlyZS9MR1BpY0NibzhlblFpTUVZTno5?=
 =?gb2312?B?U2NOMFlTbC9NU1NUYjZrTlFvL2h6eEE0VnVVL1Z0QnplbjM2Ly9lQUV5QTlo?=
 =?gb2312?B?b0NnYlpTNDhqeEpVSmpLanBVeVlLUm1CVFdDSk4yQWs3NnU2OW9LZjgxaDl4?=
 =?gb2312?B?Y1dLbU9POU5rVkpMNHdpL2ZETGhzazZudGdBbXFBODMzUWNtSG42SDBlR21F?=
 =?gb2312?B?dmR5S1FpellYWFFERWVVYmp5Vit6dXRtaWIzYjBabFd4YmViSGFLbUtmSjRl?=
 =?gb2312?B?OTl6QW01b1JUNWkvaExIQXhhRTA2dTNicGxDTHFYS0h0RWQ3c3NUWU5XcUQ1?=
 =?gb2312?B?eFRXbjh5STNEaXB5V3FsVTEvYi9ibzRhTTVzajRmL1hudmhLWGIwdkhsd01n?=
 =?gb2312?B?ZStoNHpSUVJ6R1NvV1ZUZkY5ejJrVUY1NXFDcUhEL05aQWdsVGtDYXNoYnAx?=
 =?gb2312?B?aGdFeTVUbGZkdnRlYUw2K2Z2dWJpTFhERTRZa3dldnM0dDlyRWVMQ0xRYk1m?=
 =?gb2312?B?K1VzeWhQZVBFLzJudXBGU0JSNkNpQWgxNEFLWWNJTjlmUStRWXVEdCt1MHdL?=
 =?gb2312?B?NDBCcTdrZmRsb0l1L0J3K1pqcVFIRWIvL0Q1aElSbWl4MzhpN0pONTV1Y3Fk?=
 =?gb2312?B?WGtBMVRxSVRRQk5JUzdGVGw0L1dWcGtFb3p4UmJsOUgxcnhLamVIQzVmblpC?=
 =?gb2312?B?RHI2TXc2WXZISWZnVmtZeEl4S3JnZFRJUExRNy90N2FBeCtCb1p5Lzd0dXFQ?=
 =?gb2312?B?SFZoRWZibXNTT0tuMWVEUFg5R2hQU0M4SE1KM0k5Z2VjbEdKK2syM1duU3pL?=
 =?gb2312?B?L0loU3pCaUs0elN4QUZMdzBscENweGxRRXpwbTd2eFNqelNPT3JUTllRcktu?=
 =?gb2312?B?cDdTY0ZKRFozeCt2bjlOblBQRUFHdDNNZlNiU3lMWk0vVjRNMm1RTU5xc2ty?=
 =?gb2312?B?MzRSQm13YjVhRVpVK1daSnZjVGdQYVh2NzM1U1V4ZCtUc24rUW9vb05qZUlS?=
 =?gb2312?B?dURGU01XMXVXMVdEVkxxZE9yWUFZbkhFem9wWjNodmFaR1g0cHl5UFVuQ1Qv?=
 =?gb2312?B?RjRwakNJNGpyM2ZpME13M0gwMUhyVjFBRS8yMEVYMHdRYmRWa3FTYmpNVHhR?=
 =?gb2312?B?ZVdaSHA3U21QNU96Uk5xQ0EwRC84VUtScGtoeCtVbUJ3b1o1MUVOeEVTdTJp?=
 =?gb2312?B?aDZFUUNCSHVyU3ZjVHFaMTg1TndZeFhlTFEyWk1Kdmh3UUhPZExCWlpETUpD?=
 =?gb2312?B?MHAwTDZHMlJYMFVpdlZyc3N3cG0wZ0huZDVGQy9XK2dLTXppMmY3eHlRQmRa?=
 =?gb2312?B?YUxrVWxFekh3NitkWWxzNXJZT1I0ZG9YaUhkUTRLWlVPL1Bob2lxbmtSRVVk?=
 =?gb2312?B?dHplTEY5d0FvMEpScG1HdTRjeG1kZERuNmRRWFVXYnNZVEZabGFUSVVJdDR3?=
 =?gb2312?B?d3BPYndobjVMNDhqamRwdmNOOGo0S2lzNWdTREZOSU1Ed2J6N0duelRhUUlC?=
 =?gb2312?B?OTdDcUlHcWQ0ZGx2ZmVVcnUvRVJMZkVLMjBjeEx2TjQ1YkJkc2V0eFFXMHh4?=
 =?gb2312?B?a0VEUSt0cXRwQVhjK0NrQ0pJdk9PZElWR3hwMmg1c3dOT0JjYzFrdzlmSjB4?=
 =?gb2312?B?M1poU1E4bkt0SUl6alBrT0NmRGlFT2VNV3l5MUV6bDFjMHRYbk9nejg4U2lM?=
 =?gb2312?B?NG1Edlpibk5sN2hyb29zbmZYb3dXNWxCVG1ONjRkK29XS09yby8rZ1lxdUp4?=
 =?gb2312?B?eXp6WHJmWkNkcXBjYitLa0w2ZVlBPT0=?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b6f4f1-0cc4-40d1-7b63-08d9b46ba62f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2021 01:41:09.0276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vytskIZVqWALgRA5PcpbvQ0Vh9sGv247IP9vZu0a1owmoaGjQaG4xtKkam0tUR75ZTY3jzc8HV3CCIPtuVRX6jIfH2c6kBI3vOrDmzB2vWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7900
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U29ycnksIHRoaXMgcGF0Y2ggaXMgbWlzc2luZyB0aGUgbmV0LW5leHQgcHJlZml4IGFuZCBzZXJp
ZXMgZGVzY3JpcHRpb26jrHBsZWFzZSByZWplY3QgaXQuIEkgc2VudCBhIG5ldyBvbmUuDQoNCj4g
RXFvcyBldGhlcm5ldCBzdXBwb3J0IGZpdmUgcXVldWVzIG9uIGhhcmR3YXJlLCBlbmFibGUgdGhl
c2UgcXVldWVzIGFuZA0KPiBjb25maWd1cmUgdGhlIHByaW9yaXR5IG9mIGVhY2ggcXVldWUuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBYaWFvbGlhbmcgWWFuZyA8eGlhb2xpYW5nLnlhbmdfMUBueHAu
Y29tPg0KPiAtLS0NCj4gIGFyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDhtcC1ldmsu
ZHRzIHwgNDENCj4gKysrKysrKysrKysrKysrKysrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA0MSBp
bnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9ib290L2R0cy9mcmVl
c2NhbGUvaW14OG1wLWV2ay5kdHMNCj4gYi9hcmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9p
bXg4bXAtZXZrLmR0cw0KPiBpbmRleCA3Yjk5ZmFkNmU0ZDYuLjFlNTIzYjNkMTIyYiAxMDA2NDQN
Cj4gLS0tIGEvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OG1wLWV2ay5kdHMNCj4g
KysrIGIvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OG1wLWV2ay5kdHMNCj4gQEAg
LTg2LDYgKzg2LDkgQEANCj4gIAlwaW5jdHJsLTAgPSA8JnBpbmN0cmxfZXFvcz47DQo+ICAJcGh5
LW1vZGUgPSAicmdtaWktaWQiOw0KPiAgCXBoeS1oYW5kbGUgPSA8JmV0aHBoeTA+Ow0KPiArCXNu
cHMsZm9yY2VfdGhyZXNoX2RtYV9tb2RlOw0KPiArCXNucHMsbXRsLXR4LWNvbmZpZyA9IDwmbXRs
X3R4X3NldHVwPjsNCj4gKwlzbnBzLG10bC1yeC1jb25maWcgPSA8Jm10bF9yeF9zZXR1cD47DQo+
ICAJc3RhdHVzID0gIm9rYXkiOw0KPiANCj4gIAltZGlvIHsNCj4gQEAgLTk5LDYgKzEwMiw0NCBA
QA0KPiAgCQkJZWVlLWJyb2tlbi0xMDAwdDsNCj4gIAkJfTsNCj4gIAl9Ow0KPiArDQo+ICsJbXRs
X3R4X3NldHVwOiB0eC1xdWV1ZXMtY29uZmlnIHsNCj4gKwkJc25wcyx0eC1xdWV1ZXMtdG8tdXNl
ID0gPDU+Ow0KPiArCQlxdWV1ZTAgew0KPiArCQkJc25wcyxwcmlvcml0eSA9IDwweDA+Ow0KPiAr
CQl9Ow0KPiArCQlxdWV1ZTEgew0KPiArCQkJc25wcyxwcmlvcml0eSA9IDwweDE+Ow0KPiArCQl9
Ow0KPiArCQlxdWV1ZTIgew0KPiArCQkJc25wcyxwcmlvcml0eSA9IDwweDI+Ow0KPiArCQl9Ow0K
PiArCQlxdWV1ZTMgew0KPiArCQkJc25wcyxwcmlvcml0eSA9IDwweDM+Ow0KPiArCQl9Ow0KPiAr
CQlxdWV1ZTQgew0KPiArCQkJc25wcyxwcmlvcml0eSA9IDwweDQ+Ow0KPiArCQl9Ow0KPiArCX07
DQo+ICsNCj4gKwltdGxfcnhfc2V0dXA6IHJ4LXF1ZXVlcy1jb25maWcgew0KPiArCQlzbnBzLHJ4
LXF1ZXVlcy10by11c2UgPSA8NT47DQo+ICsJCXF1ZXVlMCB7DQo+ICsJCQlzbnBzLHByaW9yaXR5
ID0gPDB4MD47DQo+ICsJCX07DQo+ICsJCXF1ZXVlMSB7DQo+ICsJCQlzbnBzLHByaW9yaXR5ID0g
PDB4MT47DQo+ICsJCX07DQo+ICsJCXF1ZXVlMiB7DQo+ICsJCQlzbnBzLHByaW9yaXR5ID0gPDB4
Mj47DQo+ICsJCX07DQo+ICsJCXF1ZXVlMyB7DQo+ICsJCQlzbnBzLHByaW9yaXR5ID0gPDB4Mz47
DQo+ICsJCX07DQo+ICsJCXF1ZXVlNCB7DQo+ICsJCQlzbnBzLHByaW9yaXR5ID0gPDB4ND47DQo+
ICsJCX07DQo+ICsJfTsNCj4gIH07DQo+IA0KPiAgJmZlYyB7DQo+IC0tDQo+IDIuMTcuMQ0KDQpU
aGFua3MsDQpYaWFvbGlhbmcNCg==
