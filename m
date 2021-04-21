Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD1A3663CB
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 04:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhDUCvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 22:51:44 -0400
Received: from mail-vi1eur05on2071.outbound.protection.outlook.com ([40.107.21.71]:40065
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233956AbhDUCvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 22:51:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiPI4fbLHZKl3uOztvtl5zKQ1colK1Bdl+9bgM5IUaI70YVHc+Wf2ZBAOCg3nsl7Yk06cyltTNb6xx/kNBxp+8nfDqaI6iG11x00iOZ6IAOdulKc2RtoOEanQPqXyE/QuzeeQZXZ8nOr8eJNjhBAp1rXONZWqVVULGWuTDr1woWpQ3iTogbOagUyfg1OkoFr7mbwdgciSnut68cTs4k9ZVGaCO16V6l7DzWuTKcmxz27OlmT7nyNdiRz1Y1NNz/deZ9eQhaiAfgey4spBrAXI/uIMTv5iMr2Pf8K9ALK14yvWtsUFEfm3v1KXZSEJwr5iWmsyA6oBjrnPlv65sd3FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3wFYZd/uKAQOWFh8oWfffdX9mgvUJVNBRQILy+sa4U=;
 b=T2ej1EXSWdjGosphuc8dqA3Vbebv3r/EhyJyFN5A3cZA/e15p1IL7dEQdZM5chlG1XrfgMX3L4tgqBp/sPuDWIFOaS5ZYY7OcZrwn7tWXoEwRxgcqSuNDNlW/0NF/24SiyT6sK6b5kBaFzdggcafGGFKf4WZNraVDfjlITVrFtA/w5CFVRV7vEiJZvNJXREukTvzgXsAv3zQQ13Bxij7gngkDMpEUai5Ew13S5wsbkr2zVTMdIzp6P97q/QlFEp3LeTMypVUE2ZHda8RBsPkKmmzSYLlXyfDKMJm2FCPBQuLeZee/FUbrN6Wba1zrEGbXKXxI91EZfRxUYHnKu3jaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3wFYZd/uKAQOWFh8oWfffdX9mgvUJVNBRQILy+sa4U=;
 b=oURpFr/hQR50m/5csKQFvOQFehsp3JSmAxqGHJbnwq+jeMNQrmVtXbMkuu5l6dyrtEEd8zTxUg8vi2Q2AdrxOemFrSOdsElpSQcAAUlPcWhDC+5TWyB1+ERaPm2Fp1D9pCqQxYxnVrPToK1ACfzd+xnj5uAuwPZhOm6wAESD4Us=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DBBPR04MB7833.eurprd04.prod.outlook.com (2603:10a6:10:1ef::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Wed, 21 Apr
 2021 02:51:09 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::8403:eeba:4caf:88d6]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::8403:eeba:4caf:88d6%7]) with mapi id 15.20.4065.020; Wed, 21 Apr 2021
 02:51:09 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        Po Liu <po.liu@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [net-next] net: dsa: felix: disable always guard band
 bit for TAS config
Thread-Topic: [EXT] Re: [net-next] net: dsa: felix: disable always guard band
 bit for TAS config
Thread-Index: AQHXNQV6cbEkHp2uw0G0oLH1EhbdIaq7x7yAgADvIJCAAFzVAIAAAeSwgAAg2ICAAANNAIABBefA
Date:   Wed, 21 Apr 2021 02:51:09 +0000
Message-ID: <DB8PR04MB5785A811DEB1D683E868D675F0479@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210419123825.oicleie44ms6zcve@skbuf>
 <DB8PR04MB5785E8D0499961D6C046092AF0489@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210420082632.3fy4y3ftkhwrj7nm@skbuf>
 <AM6PR04MB5782BC6E45B98FDFBFB2EB1CF0489@AM6PR04MB5782.eurprd04.prod.outlook.com>
 <20210420103051.iikzsbf7khm27r7s@skbuf>
 <20210420104240.xdu6476c2etj5ex4@skbuf>
In-Reply-To: <20210420104240.xdu6476c2etj5ex4@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f435cdf8-8d1b-41be-f040-08d904705122
x-ms-traffictypediagnostic: DBBPR04MB7833:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB78332C77218E08A2E06ADCF0F0479@DBBPR04MB7833.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w8pVem2n/ZodG6zb2hxcy5Tt0eI0Wqc3DDkZ0DlZqdgHguwJZhxfLd9SVF7VqOPvcX/Xja/5gfKVBqf0W4xB9tsKGWiobP25e2gzheljHaC9auFlioMlxKY7lmFfgsohsUcFgRiEOvLHWIiTpHLxSrSacJkyF9BJxM/9MNdXTl2aaVro4hWEz5RX7HvGnGNpQCD8SHEJnbkMGYtbWMqv+bzP29JF7oeR+ZM0eMCwaeheddlrQQVEjHzkean1ACd0lPdTt16ULkQyVu3Ln5Koe7kbdYKlLK3wbbK+UkLAlFgBfBf7K0nbNzVmYdnA4p/OLhIL04EWz8B0SqgtudZQUjNk9dNO9IwOAxl5blp61IPK1xkg/LArGinySSO8ZIVGo99CEEqjmsD2FMZag5PKXtwHmC3JrpBykXpFwwHIDnl3F0IHOSr5iVK1ykPcNMUqYKhNSdU6unuKjd7MbIsqD8cHJqOybc1QOQUSHIsMCvRS+H1o1DDmeYo7mDA3j4gtxEkZ7j3MjSFSZlQrCrn5m4oHD3BMscRq4LtRAlnzsHGjmflgyIZT6XPjwn81h7EwY2QoT4Zqi9oXdKbVsTuAYjhCjT34Edwyo7DaCEiBKfc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(5660300002)(66476007)(122000001)(316002)(54906003)(55016002)(8676002)(64756008)(9686003)(66556008)(6916009)(83380400001)(66946007)(71200400001)(76116006)(66446008)(7416002)(52536014)(26005)(33656002)(4326008)(186003)(7696005)(6506007)(86362001)(8936002)(478600001)(38100700002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?akd1cUNzQUtMc3k5K1FucXZURVRXUHFpZjJhRkNGbXNEV1gzQ093azJYajd0?=
 =?utf-8?B?ajJ0Yit4VHNaT1FTVzB1dm5CWVZMcGNMWVZvMGljS3ZWRythKzlXKytTLytN?=
 =?utf-8?B?WEdIWVp4Vk9RdW9UOGF0VG40Y25zMTFvT211eDR0bWd4NnFicnZRckhWZ0Js?=
 =?utf-8?B?L3ZtcmRteFRmQWk5R200bjNoVzE3d3MzWUYzd1lhYTNFWnllR21scmJiRnl5?=
 =?utf-8?B?MnU5L3JiR0NrdmNmdm5tYThzMnVRaDdqRVUzNXNWWmVCSVRLREg2ZXBOdmlV?=
 =?utf-8?B?V3RxNmNpMjlGMis3UkttZWdiOTJpZGdHS0pmbUdzOG90YUdjL1BIdzdzSkpQ?=
 =?utf-8?B?endWYmNDM0dvaVJMeFdLM1E0Vy9YMWZ0b1g2ajAzTjdBU2ZncEZvZG1iZHkv?=
 =?utf-8?B?Ri8ralZ2WVJhSm4zM2hlV1dDQTEwU29ieFR0bmNhOUtwUkMvOWZsSXNKbkhx?=
 =?utf-8?B?U0g4aUMwMTZnOTNtbHozZitiVWpGZHpucW1TTGF1SUdhNG53VUtabHB3UTFL?=
 =?utf-8?B?TzdaRklQM2JrTVY5elFjcUh2dnNlYTZlcjkzeEZEam5mTHdtRVg4U2svOXox?=
 =?utf-8?B?SVZSMGRSNXpRU2pxSE1ZMlU0dnVERUxyVG9acGx2SGRsb2Rod04weDZ2VHJl?=
 =?utf-8?B?M2Z1d0NsRURXSjU5VFFTVEtacVd4c2pBZ1gyYkhSTExqcC9OTzBkUWYvaTJ4?=
 =?utf-8?B?ckplUjI4Ky84T3diRUVrRlNnUUoyMUduZy9iLy9SQTgwSUtRdUpkU3paMW9n?=
 =?utf-8?B?YzBHeGJoR3hzSEJlOUN1ckplYXFQU08yNVdLYXgrMnMyUUJnL2IwS0pqSWE4?=
 =?utf-8?B?WUxmTkxZcDZ5QWswN3UvLzhRcUhzOHVudHBsUE5SSkRGYTdWaWNkT1k0R0dn?=
 =?utf-8?B?REo2dlJ0TVZRdVJSZDNBVnBrOC94a1hkY2ZsUUdwZUh5czFKRlhXUjhpMW91?=
 =?utf-8?B?enU5MUtNM1JzUTM3dWc0RytmVzl2WCtFRnNNYTVvb2t5TjlnMGdhanJoWmNa?=
 =?utf-8?B?dVMza0hUS0c2WHpXQmJjREs3Y3JHcERrOTFxYkFHZGxtZEdaZlVWN294Rnhz?=
 =?utf-8?B?YkM3SHd6REY2UVhkRmtEeUEzQ0lZZkpTNFRsNEhDWm5JSG5na28wcVQweUgy?=
 =?utf-8?B?QkkwVklpMXhXcmhiRFBPY1hUK01TVWw5bnpKalNuQjk2TWR6SjQvMmtwcFVY?=
 =?utf-8?B?Vmw2dXl1dXlGYTRaU0hvSUc5ODIwZnRKaGZveGo4N0ZZOFRaWkxOaHNYTUNV?=
 =?utf-8?B?b2ducHVBckVhQUtqRDVtUW54eFlSU1lQcXRTY25YL2tjclBhTHZKYzNyZ1RL?=
 =?utf-8?B?Y2lIUW4raGZvVkZXQ2h5OVQwalBWNy9QdmlxYS9uME85VGJ1YXkrOGhSSjUw?=
 =?utf-8?B?ZG1MRHR2aHZaRUdxQ3VZYmg4UmNsQ1lTaDRsRFVJMnY3MU1uVUkrNjFiVExi?=
 =?utf-8?B?WXB5T0NUQStBOElOcWc3TXJ2Tm1RaDdIWFIwdzMvSDMxZjkxVVNON2xGRFZP?=
 =?utf-8?B?Q0hNZ0hYUXBwMzhDVk04bkhPbGtoeVVmckNoN21NcGNWa3YxdE8xQ3Rhcmcx?=
 =?utf-8?B?L01ZQ2NuVE5KQ0h4TnNhRlVxajVmZDBKY3hvNlRrampkV0ZSYWE3dUFyUkRS?=
 =?utf-8?B?blVxMWV3U3ErMFpPdFVWUzZ2Q0tiK3NVdmJqeE03T2NvQnkraWxGUDVZUGJl?=
 =?utf-8?B?NlZPWU1hU3crb0VDR1JMTmsrV1h4T0FKd1BEcWVxRFJLUjZkRWptKzNham1i?=
 =?utf-8?Q?ppX+B5EYzPiECv4T20yvMiot1UO4XzmDl2OIih8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f435cdf8-8d1b-41be-f040-08d904705122
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 02:51:09.2249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y5WMLP0nsEUN27LiLhD7TBf60v0UpXO/XFuBCcdTBga6jCHRu/e/1qBRMcZOvr4t0DUj5PXa/fznYcbakBkeslB5ZKsddZm0FoEl7sFWkHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7833
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIFR1ZSwgQXByIDIwLCAyMDIxIGF0IDAxOjMwOjUxUE0gKzAzMDAs
IFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4gT25lIHF1ZXN0aW9uIHRob3VnaC4gSSBrbm93IHRo
YXQgRmVsaXggb3ZlcnJ1bnMgdGhlIHRpbWUgZ2F0ZSwgaS5lLiB3aGVuIHRoZSB0aW1lIGludGVy
dmFsIGhhcyBhbnkgdmFsdWUgbGFyZ2VyIHRoYW4gMzIgbnMsDQo+IHRoZSBzd2l0Y2ggcG9ydCBp
cyBoYXBweSB0byBzZW5kIGFueSBwYWNrZXQgb2YgYW55IHNpemUsIHJlZ2FyZGxlc3Mgb2Ygd2hl
dGhlciB0aGUgZHVyYXRpb24gb2YgdHJhbnNtaXNzaW9uIGV4Y2VlZHMgdGhlDQo+IGdhdGUgc2l6
ZSBvciBub3QuIEluIGRvaW5nIHNvLCBpdCB2aW9sYXRlcyB0aGlzIHJlcXVpcmVtZW50IGZyb20g
SUVFRSA4MDIuMVEtMjAxOCBjbGF1c2UgOC42LjguNCBFbmhhbmNlbWVudHMgZm9yDQo+IHNjaGVk
dWxlZCB0cmFmZmljOg0KPg0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLVsgY3V0IGhl
cmUgXS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIA0KPg0KPiBJbiBhZGRpdGlvbiB0byB0
aGUgb3RoZXIgY2hlY2tzIGNhcnJpZWQgb3V0IGJ5IHRoZSB0cmFuc21pc3Npb24gc2VsZWN0aW9u
IGFsZ29yaXRobSwgYSBmcmFtZSBvbiBhIHRyYWZmaWMgY2xhc3MgcXVldWUgaXMgbm90DQo+IGF2
YWlsYWJsZSBmb3IgdHJhbnNtaXNzaW9uIFthcyByZXF1aXJlZCBmb3IgdGVzdHMgKGEpIGFuZCAo
YikgaW4gOC42LjhdIGlmIHRoZSB0cmFuc21pc3Npb24gZ2F0ZSBpcyBpbiB0aGUgY2xvc2VkIHN0
YXRlIG9yIGlmDQo+IHRoZXJlIGlzIGluc3VmZmljaWVudCB0aW1lIGF2YWlsYWJsZSB0byB0cmFu
c21pdCB0aGUgZW50aXJldHkgb2YgdGhhdCBmcmFtZSBiZWZvcmUgdGhlIG5leHQgZ2F0ZS1jbG9z
ZSBldmVudCAoMy45NykNCj4gYXNzb2NpYXRlZCB3aXRoIHRoYXQgcXVldWUuIEEgcGVyLXRyYWZm
aWMgY2xhc3MgY291bnRlciwgVHJhbnNtaXNzaW9uT3ZlcnJ1biAoMTIuMjkuMS4xLjIpLCBpcyBp
bmNyZW1lbnRlZCBpZiB0aGUNCj4gaW1wbGVtZW50YXRpb24gZGV0ZWN0cyB0aGF0IGEgZnJhbWUg
ZnJvbSBhIGdpdmVuIHF1ZXVlIGlzIHN0aWxsIGJlaW5nIHRyYW5zbWl0dGVkIGJ5IHRoZSBNQUMg
d2hlbiB0aGUgZ2F0ZS1jbG9zZSBldmVudCANCj4gZm9yIHRoYXQgcXVldWUgb2NjdXJzLg0KPg0K
PiBOT1RFIDHigJRJdCBpcyBhc3N1bWVkIHRoYXQgdGhlIGltcGxlbWVudGF0aW9uIGhhcyBrbm93
bGVkZ2Ugb2YgdGhlIHRyYW5zbWlzc2lvbiBvdmVyaGVhZHMgdGhhdCBhcmUgaW52b2x2ZWQgaW4g
DQo+IHRyYW5zbWl0dGluZyBhIGZyYW1lIG9uIGEgZ2l2ZW4gUG9ydCBhbmQgY2FuIHRoZXJlZm9y
ZSBkZXRlcm1pbmUgaG93IGxvbmcgdGhlIHRyYW5zbWlzc2lvbiBvZiBhIGZyYW1lIHdpbGwgdGFr
ZS4NCj4gSG93ZXZlciwgdGhlcmUgY2FuIGJlIHJlYXNvbnMgd2h5IHRoZSBmcmFtZSBzaXplLCBh
bmQgdGhlcmVmb3JlIHRoZSBsZW5ndGggb2YgdGltZSBuZWVkZWQgZm9yIGl0cyB0cmFuc21pc3Np
b24sIGlzIA0KPiB1bmtub3duOyBmb3IgZXhhbXBsZSwgd2hlcmUgY3V0LXRocm91Z2ggaXMgc3Vw
cG9ydGVkLCBvciB3aGVyZSBmcmFtZSBwcmVlbXB0aW9uIGlzIHN1cHBvcnRlZCBhbmQgdGhlcmUg
aXMgbm8gd2F5IG9mIA0KPiB0ZWxsaW5nIGluIGFkdmFuY2UgaG93IG1hbnkgdGltZXMgYSBnaXZl
biBmcmFtZSB3aWxsIGJlIHByZWVtcHRlZCBiZWZvcmUgaXRzIHRyYW5zbWlzc2lvbiBpcyBjb21w
bGV0ZS4gSXQgaXMgZGVzaXJhYmxlIA0KPiB0aGF0IHRoZSBzY2hlZHVsZSBmb3Igc3VjaCB0cmFm
ZmljIGlzIGRlc2lnbmVkIHRvIGFjY29tbW9kYXRlIHRoZSBpbnRlbmRlZCBwYXR0ZXJuIG9mIHRy
YW5zbWlzc2lvbiB3aXRob3V0IG92ZXJydW5uaW5nIA0KPiB0aGUgbmV4dCBnYXRlLWNsb3NlIGV2
ZW50IGZvciB0aGUgdHJhZmZpYyBjbGFzc2VzIGNvbmNlcm5lZC4NCj4gLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
Pg0KPiBJcyB0aGlzIG5vdCB0aGUgcmVhc29uIHdoeSB0aGUgZ3VhcmQgYmFuZHMgd2VyZSBhZGRl
ZCwgdG8gbWFrZSB0aGUgc2NoZWR1bGVyIHN0b3Agc2VuZGluZyBhbnkgZnJhbWUgZm9yIDEgTUFY
X1NEVSBpbiANCj4gYWR2YW5jZSBvZiB0aGUgZ2F0ZSBjbG9zZSBldmVudCwgc28gdGhhdCBpdCBk
b2Vzbid0IG92ZXJydW4gdGhlIGdhdGU/DQoNClllcywgdGhlIGd1YXJkIGJhbmQgcmVzZXJ2ZWQg
YSBNQVhfU0RVIHRpbWUgdG8gZW5zdXJlIHRoZXJlIGlzIG5vIHBhY2tldCB0cmFuc21pc3Npb24g
d2hlbiBnYXRlIGNsb3NlLiBCdXQgaXQncyBub3QgbmVjZXNzYXJ5IHRvIHJlc2VydmUgdGhlIGd1
YXJkIGJhbmQgYXQgZWFjaCBvZiBHQ0wgZW50cnkuIFVzZXJzIGNhbiBtYW51YWxseSBhZGQgZ3Vh
cmQgYmFuZCB0aW1lIGF0IGFueSBzY2hlZHVsZSBxdWV1ZSBpbiB0aGVpciBjb25maWd1cmF0aW9u
IGlmIHRoZXkgd2FudC4gRm9yIGV4YW1wbGUsIGlmIHRoZXkgd2FudCB0byBwcm90ZWN0IG9uZSBx
dWV1ZSwgdGhleSBjYW4gYWRkIGEgZ3VhcmQgYmFuZCBHQ0wgZW50cnkgYmVmb3JlIHRoZSBwcm90
ZWN0IHF1ZXVlIG9wZW4uIExpa2UgdGhlIG5vdGUgeW91IG1lbnRpb25lZDogIkl0IGlzIGRlc2ly
YWJsZSB0aGF0IHRoZSBzY2hlZHVsZSBmb3Igc3VjaCB0cmFmZmljIGlzIGRlc2lnbmVkIHRvIGFj
Y29tbW9kYXRlIHRoZSBpbnRlbmRlZCBwYXR0ZXJuIG9mIHRyYW5zbWlzc2lvbiB3aXRob3V0IG92
ZXJydW5uaW5nIHRoZSBuZXh0IGdhdGUtY2xvc2UgZXZlbnQgZm9yIHRoZSB0cmFmZmljIGNsYXNz
ZXMgY29uY2VybmVkLiINCg0KVGhhbmtzLA0KWGlhb2xpYW5nIFlhbmcNCg==
