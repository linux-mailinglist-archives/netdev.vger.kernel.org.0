Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A8E469699
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 14:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244158AbhLFNSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 08:18:44 -0500
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:25474
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243677AbhLFNSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 08:18:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRPsSgpxIpjMYpCX9mIeJKZK8P1CRbLpsL2oHkx+7C9R1DDKQfMfU6V2vhk6SQvD630ikTKCQ8/Dvzwi8HRCMz8stR+oLhutbb+yCulcZ2kU1thrqjiAsg4HI8KOeRpCGR+I4GnDinRlaq+9a+R9nO5Ad6maMVR+pToRZb8zLVdR03j+ZNZZEBF6/c0KVKUDmihmdXiWg8nJJfUQq/Xn6o/ncfn1RknjU7lY/yI9YSCOCfTtKh9aJgeMoRXPRInf26Rehe5qf7x7Z9SjAhfsoFxkcNFTLqP9On6Q2DjxECpYupw8/A6KWhh3AVdMu6iogS7QqbR524NvQ2eFd9pe1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQwFb6ySHIwvIVpys3IEfWhm4HGaPrh6muSk7yw1fLs=;
 b=TmXPmtkNpp0okADE9vjo2+9liY2K7iVTq+ccDRH/Ij/+SpegJLQ5g1qhREO9NwcA0OBFdWY7zmBq390UzShjsaGndhKlRj9hjJFUchxBJdaYrjIVoxZW7tzVzJcbqCe9XWtzOYgeIex/9M+KAXf/xk9jNfuVbqNC5CSWNjgaz9NGiduaO+fGOTcGlnR1y726M6rAQl8O1SrcIWS85S1XSZKqoZnXzCFGmIcZG8oxZjByoUuPAoqetNaCGsodLMGtBfjAC1+2vJNJ4bqIh+SxFhFxEd4DT57enRwuLmsPqYQ40yJLbNNUDl2WeSZTq6BG2iYrRT/kdSKG8hB+mJAgiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQwFb6ySHIwvIVpys3IEfWhm4HGaPrh6muSk7yw1fLs=;
 b=Sl5Eygw6PTVq/07NwRWFdEuSCb8XYtWGemPY2WBZTBufjy1F+2zkPYRK7mLA9FXCmHBOCNU7hmKXzW8cAot2oEprH95SMwIWNc7YbgQRVaYjLgsLcgbP8QF91fSEcZpONbxYdcGDoPNzeQSu5p5FwIk1iqPxBkAZ+JZCy+6tIkE=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6972.eurprd04.prod.outlook.com (2603:10a6:10:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 13:15:12 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 13:15:12 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Nicolas Diaz <nicolas.diaz@nxp.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] net: fec: only clear interrupt of handling queue in
 fec_enet_rx_queue()
Thread-Topic: [PATCH] net: fec: only clear interrupt of handling queue in
 fec_enet_rx_queue()
Thread-Index: AQHX6oB3yu32PPWCgEmGC+/OCy3b26wlbrKAgAAArQA=
Date:   Mon, 6 Dec 2021 13:15:12 +0000
Message-ID: <DB8PR04MB67955258FC58D75DF9E1F72CE66D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20211206090553.28615-1-qiangqing.zhang@nxp.com>
 <Ya4KcYlZypEDjQbC@lunn.ch>
In-Reply-To: <Ya4KcYlZypEDjQbC@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0fcc645-5497-4cd5-da17-08d9b8ba6f7f
x-ms-traffictypediagnostic: DB8PR04MB6972:EE_
x-microsoft-antispam-prvs: <DB8PR04MB6972E93FADAF4C70E4E7E918E66D9@DB8PR04MB6972.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RUqUR6k54LFQndr5oZt3nrLpVqzIplvVcKhxBMxn13QYu6PCVo0cQM5opOJmrRjYxGZvpO3tDkUnpVbssD2Whcn/2ntlyTT4sQtY7DUDhbPRtExi7/XGOE1Rxeqfi4tPv74Kv7+CTsNck9K82Tt81E2KugeswVhMu1ONztypNkZZyVbKjFYK1bTOZW0RanXd7xBX36nZhUGId2uWpVYQBMk/YZYXlGptTTkhOdt9gQd00EoFG1Hl4YbhN8uCJ+nXO9tq+lI0aTyjlK4rjuYFfb/jhgtgdC61PLNumsFRxXBsZZ/ROGX+YfNWpcScGbHdkRXaNs0pC8JFe0ENhYncq45tVhurNiPJW2CmUak1leS7wgkbFVLZqGZk4+OVzqAtvJzdN4Vm/6TCnID/vySBbZ60MTF11jvG6G8EW0dcWNhhIiRRrJLiptiVc34fQgkk9iLWwPUyV6PNu+DrKddJ8AfJqcTaVepKw2cPLEanfqjAZvPbMHufGCh1Wu+6aUz3zOg1WDaR8KWYPRoNIRkbugcMAyDIvBsIqqz4ZSD/CkuU3E6PApNF9rPM1pa1OUT+Fc/kyf/J9xFcGjRTS9ut/DB9yQbhXnOwafSleAcKybdIJPWVszKxcQnpQG2I7c5xdWgyiPnWS1MqV0ekgwLj3C1dtL8aBrzooPIyp6MaT0GUQB2AJsGiB74yDT9NznTkOJ2pItMB6LCAAa2AZfZlbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(6506007)(316002)(71200400001)(8676002)(8936002)(186003)(52536014)(6916009)(122000001)(38100700002)(26005)(33656002)(54906003)(66946007)(66446008)(66556008)(64756008)(66476007)(5660300002)(7696005)(9686003)(83380400001)(4326008)(38070700005)(76116006)(86362001)(2906002)(508600001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bVhJZlZ0czkzSWxFTWxoRlpsMnlMVGZ2YXh5Z2V2a2VWTTVlN01zTUV0R2di?=
 =?gb2312?B?aUFQd0habTBzeHlnVUR0RHhWSktRaVlEeVdNdytTTGNnRjUxYVRuQUllS3R1?=
 =?gb2312?B?MC9sTWNHREszZkJyaFMwWXkzZC9ZdUI4NWU2dWVtdkJaOXhkajMvMWxYUEFN?=
 =?gb2312?B?OU4rWWoxY2tIaVVwMGgrZHN4cTIxSFZyWTRGaXo3bDUvdUI4ek5ZTHJUaElw?=
 =?gb2312?B?djRKU2pxNEIzTk1jNGdRbWJMWkNXbmFyVWw4akQwa2N6SThIRTE3dDFyUTVM?=
 =?gb2312?B?UDc5RUlXY1BlYkdXN3dzZWR6UFZxSmhSZFRvT2lKdUg3dzl2MXRFdnAyeGZn?=
 =?gb2312?B?ekVCNUN5eFUwbWRHZ1hnSHl6ZzJlV1hkT1lpMFZhMGF0OVYrQjBrTkJ5TFNF?=
 =?gb2312?B?WDZkWS9DeS9YZ3lkbTlpejFjWVFaNEM4RGpMYjIwbnl2UUFwVzRMQWRwK1hX?=
 =?gb2312?B?YVRkVDhjMzJKTDVvMWtTUCtPUEtrZ2UySjhMWlBheksyNUZJUkorQjBMNTJx?=
 =?gb2312?B?TjhtbEJxTXdHVXpMU2U2eERrOUZZdHQ5R1RtbFdoOThlUW5wVU5KUzlkR3ZM?=
 =?gb2312?B?NlZyL1Npa0E0WXZMZHZQZHhzYVRoS3o5dGxaWU1ZUll4N0RKQkRIcE8wNHYr?=
 =?gb2312?B?Q2JYS3Y4QW42bEtkWlc1YkpuZGE4WjJPWC83cURnVnZmVHJwdlgvRlpWZEJI?=
 =?gb2312?B?UmJ0VjhnZi9xMXluREpEMWt0QU9jcThZWXc0MDlKYjBxb3c3ODJpZWVSbEhE?=
 =?gb2312?B?VjhHQkRENHdGSllPdEk0YWFnaDNwT3gwQllSK2dtTUhsengxN2NjM0QrOWdj?=
 =?gb2312?B?QUZBTzVzN25DZmp0RWhocUNSUUV0cXZtMC9kZUdOZG1PSDRkNVZCWnFadzRt?=
 =?gb2312?B?SXRLVmhsTU5xakVxTnBvMjQ0aVpsOFdoOUthTnVDbFE3c0FEVDlieWxnRlJH?=
 =?gb2312?B?YzI5TTR2WmM1VThNWHkwUThMclNudEpzbVFVdVFVbVc5RDB0dUpCa24xWmU4?=
 =?gb2312?B?WTRqNTIrQWZNQWpORWtQbDJBdjVtN2hzeG1teU84M0FUcE1GbGNub0ZiOStU?=
 =?gb2312?B?QzZZUUo2UlZjZysyVkpXekhBKzMrVHJEdVB6eDNMZjhkQ0NSeitJeFZLajlq?=
 =?gb2312?B?c3Z4MnRpbm55eDE4bXNmcXFnekFveUp0cGVwTlZPOHZZa3BSRk1jS2RkbGxS?=
 =?gb2312?B?dEdVYjZMOVo5U3NTR0FoOUFvbjFNemlLYy8ybUxremZzWlQ2UWJxSVpJSFZ3?=
 =?gb2312?B?eU9RelFhb1V6dkJBTlp5aVo5R0xDT0FrTng4NE1BTmxwMWRvZm5qcXBzT0VW?=
 =?gb2312?B?U0haaDgrZFQ2TWc3b3BVS2thcTBWOU5GaW1KRjE2VlM1NUF4aG9XY2tNZzA5?=
 =?gb2312?B?dS84ekhpcG9XN0xlbHVlWGFlUXEyanNaQVh5eHE0KzVDclhGQ1hlTVlzMWpS?=
 =?gb2312?B?YmtTZWVzOXo1dnRpRC9PUktIMFFVUFR6c296eURubnVVa2JXOXdXQXAyVUg1?=
 =?gb2312?B?WVgxVUNwVmpWNWxLUkNBczZuQXVoWTZEaFMzUlYyMTByV3NvZVJkM1dpTnZh?=
 =?gb2312?B?aG9UOVhqek96eFNkVWoxNGFJelpneTVKb3ZweWR0eG94ZkkrendHc1BFQTZo?=
 =?gb2312?B?RDhBTDNnZkh1S0p4RVd5aFUrRDZzUnB6TGVPRkUwUXdqc1NSQ08zOEVGdmNR?=
 =?gb2312?B?eUNubm5CbG94ZThZVnZ6TEUzNjdtWWJ6K3lMYmlzVGF2dElhaWI4amoySFFa?=
 =?gb2312?B?dnQ1ZzQ0UjJvOGt3UGNFZ2hKZXJqSlZrSnVMY0lGeHJ3czN1bW1PbENiTUJW?=
 =?gb2312?B?MGNtekEyZFkxaWZkWHBpdXNET3dhQ210WmZRWndhWFBFYTc5RlV0RGE1SlZ2?=
 =?gb2312?B?QVdqYjNxZUFmd0J3a3U2VFdLVG8wR0RYdWdxcmpCNXB1cUpEcTlrcnZYT2pO?=
 =?gb2312?B?U2JURW9BTVJEV0VTc2RBY1FIRXJjcVJDcTJMT2UxdWxPKzFjdDBUM2JWRzJs?=
 =?gb2312?B?UmNCSHNwZUtvTEVqdmEvNGxMeFovdmQydnFhQ244dEFZTVFFYkFDcWVVeUxJ?=
 =?gb2312?B?aUpZMnZ0ekEwaklqcmlLdmxzc0tMZnd3N2ZWWGlNY0RtZG5lTEk5WVdqL1B5?=
 =?gb2312?B?dUg3V250Y3dnMmlIQlZUNUpNNVF2VGtoVlI4K05xL3hSTzZWaTRlRCt3aU5I?=
 =?gb2312?B?dVE9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0fcc645-5497-4cd5-da17-08d9b8ba6f7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2021 13:15:12.2678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LlzpzmPjkr7tpkVzm4jhbpwpFRIM0GrH8mGjLs/LLv2VF9oWLakEzPilR+95su2d+YVugprdzp/gyVbHUpCmGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6972
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIxxOoxMtTCNsjVIDIxOjA1DQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBOaWNvbGFzIERpYXoNCj4gPG5pY29sYXMu
ZGlhekBueHAuY29tPjsgcm1rK2tlcm5lbEBhcm0ubGludXgub3JnLnVrOw0KPiBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXgN
Cj4gPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBuZXQ6IGZlYzog
b25seSBjbGVhciBpbnRlcnJ1cHQgb2YgaGFuZGxpbmcgcXVldWUgaW4NCj4gZmVjX2VuZXRfcnhf
cXVldWUoKQ0KPiANCj4gT24gTW9uLCBEZWMgMDYsIDIwMjEgYXQgMDU6MDU6NTNQTSArMDgwMCwg
Sm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+IE9ubHkgY2xlYXIgaW50ZXJydXB0IG9mIGhhbmRsaW5n
IHF1ZXVlIGluIGZlY19lbmV0X3J4X3F1ZXVlKCksIHRvDQo+ID4gYXZvaWQgbWlzc2luZyBwYWNr
ZXRzIGNhdXNlZCBieSBjbGVhciBpbnRlcnJ1cHQgb2Ygb3RoZXIgcXVldWVzLg0KPiA+DQo+ID4g
U2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4g
PiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMgfCA3
ICsrKysrKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9mZWNfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21h
aW4uYw0KPiA+IGluZGV4IDA5ZGY0MzRiMmY4Ny4uZWVlZmVkMzA0M2FkIDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+ID4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gPiBAQCAtMTUwNiw3
ICsxNTA2LDEyIEBAIGZlY19lbmV0X3J4X3F1ZXVlKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0K
PiBpbnQgYnVkZ2V0LCB1MTYgcXVldWVfaWQpDQo+ID4gIAkJCWJyZWFrOw0KPiA+ICAJCXBrdF9y
ZWNlaXZlZCsrOw0KPiA+DQo+ID4gLQkJd3JpdGVsKEZFQ19FTkVUX1JYRiwgZmVwLT5od3AgKyBG
RUNfSUVWRU5UKTsNCj4gPiArCQlpZiAocXVldWVfaWQgPT0gMCkNCj4gPiArCQkJd3JpdGVsKEZF
Q19FTkVUX1JYRl8wLCBmZXAtPmh3cCArIEZFQ19JRVZFTlQpOw0KPiA+ICsJCWVsc2UgaWYgKHF1
ZXVlX2lkID09IDEpDQo+ID4gKwkJCXdyaXRlbChGRUNfRU5FVF9SWEZfMSwgZmVwLT5od3AgKyBG
RUNfSUVWRU5UKTsNCj4gPiArCQllbHNlDQo+ID4gKwkJCXdyaXRlbChGRUNfRU5FVF9SWEZfMiwg
ZmVwLT5od3AgKyBGRUNfSUVWRU5UKTsNCj4gDQo+IFRoZSBjaGFuZ2UgaXRzZWxmIHNlZW1zIGZp
bmQuDQo+IA0KPiBSZXZpZXdlZC1ieTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiAN
Cj4gQnV0IGNvdWxkIGl0IGJlIG1vdmVkIG91dCBvZiB0aGUgbG9vcD8gSWYgeW91IGhhdmUgYSBi
dWRnZXQgb2YgNjQsIGRvbid0IHlvdQ0KPiBjbGVhciB0aGlzIGJpdCA2NCB0aW1lcz8gQ2FuIHlv
dSBqdXN0IGNsZWFyaW5nIGl0IG9uY2Ugb24gZXhpdD8NCg0KQXBvbG9naXplIGZpcnN0LCBJIGhh
dmUgYSBmb3JtYWwgcGF0Y2ggYnV0IHNlbmQgb3V0IHRoZSBpbmZvcm1hbCBvbmUsIEkgd2lsbCBy
ZS1zZW5kIGxhdGVyLCBzb3JyeSBmb3IgaW5jb252ZW5pZW5jZS4NCg0KQWJvdXQgeW91IHF1ZXN0
aW9uLCB5ZXMsIHdlIG5lZWQgdG8gY2xlYXIgdGhpcyBiaXQgZWFjaCB0aW1lLCB0aGUgYmxhbWVk
IHBhdGNoIGludHJvZHVjZWQgdG8gYXZvaWRpbmcgaW50ZXJydXB0IGZsb29kaW5nLg0KDQo+ICAg
ICBBbmRyZXcNCg==
