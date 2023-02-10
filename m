Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E186691912
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 08:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjBJHYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 02:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjBJHYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 02:24:08 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2043.outbound.protection.outlook.com [40.107.8.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC36D47413;
        Thu,  9 Feb 2023 23:24:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9ZQJzztP/d3JknabmlyN9R5DpS9nE/k1PSNW8QcDuY2CGwja0XALHf1nSX36LYkpMCNYLKXnqomubM33kCPTxgh8Lmbe9gvM6aYmgiq01ybP5GotXBzMrwBvLJ44abWT4ljmwYe/Z9WIf5lAf0H2gDY2Qzu/HU9IcpAiQFr8Qo6BGE20Ze6iUldIygjkrWeW7ylOJJUn1djXaIl5cTMUJZ4kQpEwX74IpbS9TmnklgGuK35qnx0opuzVDJpWIqd7AO5i1Q8eIjFkK68gu2/aIbH5c38xG4OLp7HorUntgGO25nrrY8jhPeM6hqRus4x7n9XOjX8TSdWWqbSNyRtaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0OvDv0AuOlb255j/x4tR48R3AWZZPJfoTtlVQs0Gog=;
 b=DkQPg923iMZOPlC0XIcfDmjOPWDlGE/dcbNc8iot5hUoW+OZpZS+kZ+6A8pRI/t3+5cV1/Oe40rTVkUVl7q4Hgw4rTNn8XWK7nNRmVlzzXk81eLo5VZSwPqNqTikHON+uTOe1UTY3sbCg2Hm/CFTTEXI9JHkhTRzG5DrW9kXLvSfa4dMDQvYmxpPjOJjOrzA06WGqlQcNogtfE+RPPlY8zlT0f+v6ns90tSQLp5n6lhis8mHVt22Py3HggG+6mBcXNE7g4AjUnDiO7mUHsVBik4znzi1kM0fqJOOOo9m0AEoDwjvYIki0f2eTOSBvjlKDOKfpnntyRTZC7AxkGVLIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0OvDv0AuOlb255j/x4tR48R3AWZZPJfoTtlVQs0Gog=;
 b=QNcWtXPau6Aaq6gt1m+91MWhaT/EX0wwf0xWhuG1i6vFVx6eGUkvtm0VhEiDbx9g/MHzfWqKLl01VlYDwqzuDkGvgwH/GtWvzG3bdPC/RTTqGcs8NUA/HKOof0QoYcM214WKJrQVLus2gMHVPN+dAGCVAEZjluTf+8UfO4xm3HU=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AS8PR04MB8819.eurprd04.prod.outlook.com (2603:10a6:20b:42e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 07:24:04 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6086.018; Fri, 10 Feb 2023
 07:24:04 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: fec: add CBS offload support
Thread-Topic: [PATCH net-next] net: fec: add CBS offload support
Thread-Index: AQHZPGjDAN8AB0LseESjQjG6/rgk/q7GyjwAgAD9Y8A=
Date:   Fri, 10 Feb 2023 07:24:03 +0000
Message-ID: <DB9PR04MB8106EA847010C0A6CD5EB23588DE9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230209092422.1655062-1-wei.fang@nxp.com>
 <Y+UbzKvqbXwe9uxF@corigine.com>
In-Reply-To: <Y+UbzKvqbXwe9uxF@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|AS8PR04MB8819:EE_
x-ms-office365-filtering-correlation-id: 91ee0b0a-ed07-44b8-c15d-08db0b37c9db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 52Icey0GTqEWtNzRtU2yCnA7EJrE6UwaPdWlUU34DK+Y6/hXDmh1+PsuIkmCR2W+Rndzc16DVwAAyT3FPsFTzCbipopXNwURtZnbPSpZZRwSAKW9XA63hMmzFAuxKtX58fvVXB31R87rIbe0bgmHoCErr/4hZMwRyOtd5ClpCZ6JtpmyGIvWGix6jlG50FZUd8jw0fV6XmLrx701JmYAjN/NZMTZgz0Ovw/I5om0abiZApVyYs+Wj8WNurinQeDj69f6W5ldHVxqEXfWizI/+QsnknWihwnEtheIZQ7QKBNVR/NRXjl9UH0uORiA1qS/C/RBYJPEUGj4/LmvRrzII6KUr7zDPOiI3ioCJfaY8phvtjCN2fNad9d6VeHqBvsOZ4U0BS6Kj7VPKmtrwkpjrofIswZcHpuO4VfRDIFFt+VSXj2AMDrKp7DTh2TGRIEKxSo7FrC//bTkZNPqZMQP4fljlmc6DvpXTu3kTqHQ9c0L5NJE+qpKMeoT5BahRBYEVB3oKl7yEDDCm8e6e16X9dfvtCegljS9+KkQ++DgZi1c5SO96QE/SdVZJTn6K0pvhbPNqchlSCMTEcp0dbv/deitn3VNkr969StXg5PBvOEwblvCy0DuVvFeANoAck1fDg7GP2JYmNCONuJfWft+ewERtcNo6mTCMwpjprWB2ebK7aSzLpewTHyNC9UkqIJ0l6IGA+5HigfEAiIJRv92OA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199018)(86362001)(33656002)(66446008)(54906003)(8676002)(76116006)(6916009)(316002)(4326008)(66476007)(66556008)(64756008)(66946007)(478600001)(71200400001)(7696005)(2906002)(52536014)(8936002)(41300700001)(44832011)(5660300002)(83380400001)(122000001)(38100700002)(55016003)(186003)(26005)(53546011)(9686003)(6506007)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?OGRnSElWMjh6elJDR1JiYTNoNDM1L3kyMUJEbjhlbnJBSVNEa2pZMkE0ODhl?=
 =?gb2312?B?U3NaL3ZrWk80VE5CbWxaRHVmSSsyM2VUSEF2Z1JsZGFTejE2a2lZWGw3amRF?=
 =?gb2312?B?SUg4QkttWFFyMzBPU0tVV2M3ejVJR2E4bGFNR1JvK1cxQUJ5N09HOHovdmxC?=
 =?gb2312?B?WUJHZ0V4NFJpNXBQU3BKVEdja3lyNHpiSmRmUnRWT3NYMk5kRmppWkw4L1l1?=
 =?gb2312?B?N2NMU1NYYng2ZHcra3pRQVNKL1F1QlRNQ2hOQVErQ1pOWnlsNG1SZnV6Nlli?=
 =?gb2312?B?eU5XZlVETWtneGhycGtVZXhyY1cySW1MeWlDeFV6ZU5jWXFpOUVwa3ZEZlBL?=
 =?gb2312?B?QWxHTVlEYmdERzhzUnJOSWU4M0duVloyY3U0OUI2M21rRm1BZnNkOXp3Y1dh?=
 =?gb2312?B?VXg4YWEzQkV5QjhxYTFDM0k3NUZHOVF6dmpBOEw2Qk5tcWJVMi9QN1VJL09u?=
 =?gb2312?B?QldobDVqSndRNC96a0J3bzkzR211Q090U054aGIxSXljRDl5SFJkR0JFUWtC?=
 =?gb2312?B?Z2R0Q1R5UTNUbzhrQ09QcjEySW9wcTVtYWp4bnZ0U1pEWFZZejY0QXRiaW1D?=
 =?gb2312?B?UVB3VnB3SGhvcUFVVzN6VXlUYVBEcmJBeUQrak5UeXk1bzdablM0d0VXMkoz?=
 =?gb2312?B?cFVNT3BMRzBpREd4UEtuZE5yWGtuZU1Lam12S0RQRDZIcDF1eldZS24xZUM0?=
 =?gb2312?B?QVk5bWVaR0ZGbVltV2ZIQ1RIRy9GcE1ycExlT0I4UVdWSzVwSmlDZUVZYzVy?=
 =?gb2312?B?OUpuRFUzdExHRW9HbkZMTlRUME52RWxGWWxGM3BCdXdKZTByWXJHMk9kaFN4?=
 =?gb2312?B?WVNmWktPbnNSa2N5SlJocjlyNms1RTZWUjVyU2lOKy9nUUt2NWh3STRLc2NM?=
 =?gb2312?B?SFprNEIreERXK1pRQ2diOUQxTXl5T3JqcGpQV3N3TDZsbE83dlVXalJTaXJD?=
 =?gb2312?B?eklJdEE1cWtIZVg5eE01Wnk3bW5hUmxWSEl3RlltakhhbGlSSDZWaUlBQ3dw?=
 =?gb2312?B?NVVMRWR5ZmtScEVOMmxDbnpYa1ozZUdRa1FZWUsvSFMwSjNQV0tSa0R4a2gz?=
 =?gb2312?B?bjhhVG85NTdOblBkMEFZQXpPNG1kSWxCSnJOc1BRYWdCaWdpbytIeDhvZTk1?=
 =?gb2312?B?Z2pCWUN6S2RqME54bGRNS05lT0VLdmVSME1oVmlyN0dLNUtQR0ppVjJkajRl?=
 =?gb2312?B?d3JTMVBUQzlGQ0dWSUtxNjFsTEU1d2lpZ3p6bHBrREVWSFRKdFJsUlJCOVIv?=
 =?gb2312?B?ZG00L1ZCOU9NYVdPcjJHRFpQVkk0TUkwcGltaGRSZG1tU1AwVlRjRWY2WVpQ?=
 =?gb2312?B?UXJBMTdEZzIvWUNhWEFmVXFyNk1pSllyemk0cFJieWZBa1VMeDVka2M5bHdt?=
 =?gb2312?B?blM4aEFsak96OXB4Slg4aDJCd0RXbFNMM0kxTStsTU4vVlYwc3dSNGpiVjd0?=
 =?gb2312?B?NWp5a1pYWkxQRlVOejVFYkdKSnJwQTJjVGxBUXJzc2VqenZNNS9UNUlzbGNO?=
 =?gb2312?B?Y0ZEek5NYUQyREs5ZVFicmppL29OV2VSaVFPdmlkU0pvTjFJZkk0MTJ2Y2hk?=
 =?gb2312?B?bUh0Nkp0SkMwc0dvbjVsOHkzZGpWU0w5ZlZCNTlFU09EK1Z2azVEckVmSGVG?=
 =?gb2312?B?dVNKMzNNMlJIRGVsTEN4LzhRNTlVNUJHQUpqR1JsTVJra05RQlZ0YXEwL28x?=
 =?gb2312?B?b3B2a09xZlZJOGRKd3M1cTBYbFBUWUZYOG41Sm12eDViVDM5MEkvSmRoYTFU?=
 =?gb2312?B?MTNydXdoMzlSSmpZNlg0ckpNMnV0UXNXRW9rRGtlZXRaVHZyN3hJOW12OEo2?=
 =?gb2312?B?cnFLVFI1aUwvbFZtTXl5ZzRLUlpNRGlVaG83d2ZSNUw0SExZT1BGWWZyOU1h?=
 =?gb2312?B?ck1yME45a0E2akJ3bmVUS1VtRU52N1dabm5OdnVteDd4dlA3N2pLVzZKUlNC?=
 =?gb2312?B?cDJUTE01OHZ3eG9hdzR0d2xkR3g4TUFHcmVXTlJvOUVGczRjSUVORzU5cHU3?=
 =?gb2312?B?RkFSRzhuZGhiWkdVWXV3OW9BSFRORlBRa2JsSHJURk5DTVJoUWltUTg0S3FH?=
 =?gb2312?B?anZmRlBWaVB3MWgwV21GZmZhUG9VT29Gc1dpaUhGYjZoVkFZWFB5OGNuSXY3?=
 =?gb2312?Q?BqHM=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ee0b0a-ed07-44b8-c15d-08db0b37c9db
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 07:24:04.0473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hYmCaTOSDDaSywADQEbz7SjExcN5Ht+ue84Fr3Pv2l3rKC8ymoc7Aom8KnAk4+i+DcY3B7qvu5Db+Fpa+IjpcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8819
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTaW1vbiBIb3JtYW4gPHNpbW9u
Lmhvcm1hbkBjb3JpZ2luZS5jb20+DQo+IFNlbnQ6IDIwMjPE6jLUwjEwyNUgMDoxNA0KPiBUbzog
V2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+DQo+IENjOiBTaGVud2VpIFdhbmcgPHNoZW53ZWku
d2FuZ0BueHAuY29tPjsgQ2xhcmsgV2FuZw0KPiA8eGlhb25pbmcud2FuZ0BueHAuY29tPjsgZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsNCj4ga3ViYUBrZXJuZWwub3Jn
OyBwYWJlbmlAcmVkaGF0LmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14
DQo+IDxsaW51eC1pbXhAbnhwLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
U3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dF0gbmV0OiBmZWM6IGFkZCBDQlMgb2ZmbG9hZCBz
dXBwb3J0DQo+IA0KPiBPbiBUaHUsIEZlYiAwOSwgMjAyMyBhdCAwNToyNDoyMlBNICswODAwLCB3
ZWkuZmFuZ0BueHAuY29tIHdyb3RlOg0KPiA+IEZyb206IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAu
Y29tPg0KPiA+DQo+ID4gKw0KPiA+ICsJaWYgKGlkbGVfc2xvcGUgPj0gMTI4KSB7DQo+ID4gKwkJ
LyogRm9yIHZhbHVlcyBlcXVhbCB0byBvciBncmVhdGVyIHRoYW4gMTI4LCBpZGxlX3Nsb3BlID0g
MTI4ICogbSwNCj4gPiArCQkgKiB3aGVyZSBtID0gMSwgMiwgMywgLi4uMTIuIEhlcmUgd2UgdXNl
IHRoZSByb3VuZGluZyBtZXRob2QuDQo+ID4gKwkJICovDQo+IA0KPiAJUGVyaGFwcyB0aGUgZm9s
bG93aW5nIHdvdWxkIGJlIGNsZWFyZXI/DQo+IA0KPiAJIEZvciB2YWx1ZXMgZ3JlYXRlciB0aGFu
IG9yIGVxdWFsIHRvIDEyOCwNCj4gCSBpZGxlX3Nsb3BlIGlzIHJvdW5kZWQgdG8gdGhlIG5lYXJl
c3QgbXVsdGlwbGUgb2YgMTI4Lg0KPiANCj4gPiArCQlxdW90aWVudCA9IGlkbGVfc2xvcGUgLyAx
Mjg7DQo+ID4gKwkJaWYgKGlkbGVfc2xvcGUgPj0gcXVvdGllbnQgKiAxMjggKyA2NCkNCj4gPiAr
CQkJaWRsZV9zbG9wZSA9IDEyOCAqIChxdW90aWVudCArIDEpOw0KPiA+ICsJCWVsc2UNCj4gPiAr
CQkJaWRsZV9zbG9wZSA9IDEyOCAqIHF1b3RpZW50Ow0KPiANCj4gCU1heWJlIHRoZXJlIGlzIGEg
aGVscGVyIHRoYXQgZG9lcyB0aGlzLCBidXQgaWYNCj4gCW5vdCwgcGVyaGFwczoNCj4gDQo+IAlp
ZGxlX3Nsb3BlID0gRElWX1JPVU5EX0NMT1NFU1QoaWRsZV9zbG9wZSwgMTI4VSkgKiAxMjhVOw0K
PiANCj4gDQo+ID4gKw0KPiA+ICsJCWdvdG8gZW5kOw0KPiANCj4gTWF5YmUgcmV0dXJuIGhlcmUN
Cj4gDQo+ID4gKwl9DQo+IA0KPiBPciBhbiBlbHNlIGhlcmUgaXMgbmljZXI/DQo+IA0KPiA+ICsN
Cj4gPiArCS8qIEZvciB2YWx1ZXMgbGVzcyB0aGFuIDEyOCwgaWRsZV9zbG9wZSA9IDIgXiBuLCB3
aGVyZQ0KPiANCj4gCVBlcmhhcHMgdGhlIGZvbGxvd2luZyB3b3VsZCBiZSBjbGVhcmVyPw0KPiAN
Cj4gCSBGb3IgdmFsdWVzIGxlc3MgdGhhbiAxMjgsIGlkbGVfc2xvcGUgaXMgcm91bmRlZA0KPiAJ
IHRvIHRoZSBuZWFyZXN0IHBvd2VyIG9mIDIuDQo+IA0KPiA+ICsJICogbiA9IDAsIDEsIDIsIC4u
LjYuIEhlcmUgd2UgdXNlIHRoZSByb3VuZGluZyBtZXRob2QuDQo+IA0KPiAgICAgICAgICBuIGlz
IDcgZm9yIGlucHV0IGlkbGVfc2xvcGUgYXJvdW5kIDEyOCAoMl43KQ0KPiANCj4gPiArCSAqIFNv
IHRoZSBtaW5pbXVtIG9mIGlkbGVfc2xvcGUgaXMgMS4NCj4gPiArCSAqLw0KPiA+ICsJbXNiID0g
ZmxzKGlkbGVfc2xvcGUpOw0KPiA+ICsNCj4gPiArCWlmIChtc2IgPT0gMCB8fCBtc2IgPT0gMSkg
ew0KPiA+ICsJCWlkbGVfc2xvcGUgPSAxOw0KPiA+ICsJCWdvdG8gZW5kOw0KPiA+ICsJfQ0KPiAN
Cj4gbml0OiBtYXliZSB0aGlzIGlzIG5pY2VyDQo+IA0KPiAJaWYgKG1zYiA8PSAxKQ0KPiAJCXJl
dHVybiAxOw0KPiANCj4gPiArDQo+ID4gKwltc2IgLT0gMTsNCj4gPiArCWlmIChpZGxlX3Nsb3Bl
ID49ICgxIDw8IG1zYikgKyAoMSA8PCAobXNiIC0gMSkpKQ0KPiA+ICsJCWlkbGVfc2xvcGUgPSAx
IDw8IChtc2IgKyAxKTsNCj4gPiArCWVsc2UNCj4gPiArCQlpZGxlX3Nsb3BlID0gMSA8PCBtc2I7
DQo+IA0KPiAJSW4gdGhlIHNhbWUgdmVpbiBhcyB0aGUgc3VnZ2VzdGlvbiBmb3IgdGhlID49IDEy
OCBjYXNlLCBwZXJoYXBzOg0KPiANCj4gCXUzMiBkOw0KPiANCj4gCWQgPSBCSVQoZmxzKGlkbGVf
c2xvcGUpKTsNCj4gCWlkbGVfc2xvcGUgPSBESVZfUk9VTkRfQ0xPU0VTVChpZGxlX3Nsb3BlLCBk
KSAqIGQ7DQo+IA0KPiA+ICsNCj4gPiArZW5kOg0KPiA+ICsJcmV0dXJuIGlkbGVfc2xvcGU7DQo+
ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgZmVjX2VuZXRfc2V0dXBfdGNfY2JzKHN0cnVj
dCBuZXRfZGV2aWNlICpuZGV2LCB2b2lkDQo+ID4gKyp0eXBlX2RhdGEpIHsNCj4gPiArCXN0cnVj
dCBmZWNfZW5ldF9wcml2YXRlICpmZXAgPSBuZXRkZXZfcHJpdihuZGV2KTsNCj4gPiArCXN0cnVj
dCB0Y19jYnNfcW9wdF9vZmZsb2FkICpjYnMgPSB0eXBlX2RhdGE7DQo+ID4gKwlpbnQgcXVldWUg
PSAgY2JzLT5xdWV1ZTsNCj4gDQo+IG5pdDogZXh0cmEgc3BhY2UgYWZ0ZXIgJz0nDQo+IA0KPiA+
ICsJdTMyIHNwZWVkID0gZmVwLT5zcGVlZDsNCj4gPiArCXUzMiB2YWwsIGlkbGVfc2xvcGU7DQo+
ID4gKwl1OCBidzsNCj4gPiArDQo+ID4gKwlpZiAoIShmZXAtPnF1aXJrcyAmIEZFQ19RVUlSS19I
QVNfQVZCKSkNCj4gPiArCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ID4gKw0KPiA+ICsJLyogUXVl
dWUgMSBmb3IgQ2xhc3MgQSwgUXVldWUgMiBmb3IgQ2xhc3MgQiwgc28gdGhlIEVORVQgbXVzdCBo
YXMNCj4gDQo+IG5pdDogcy9oYXMvaGF2ZS8NCj4gDQo+ID4gKwkgKiB0aHJlZSBxdWV1ZXMuDQo+
ID4gKwkgKi8NCj4gPiArCWlmIChmZXAtPm51bV90eF9xdWV1ZXMgIT0gRkVDX0VORVRfTUFYX1RY
X1FTKQ0KPiA+ICsJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gPiArDQo+ID4gKwkvKiBRdWV1ZSAw
IGlzIG5vdCBBVkIgY2FwYWJsZSAqLw0KPiA+ICsJaWYgKHF1ZXVlIDw9IDAgfHwgcXVldWUgPj0g
ZmVwLT5udW1fdHhfcXVldWVzKQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiAr
CXZhbCA9IHJlYWRsKGZlcC0+aHdwICsgRkVDX1FPU19TQ0hFTUUpOw0KPiA+ICsJdmFsICY9IH5G
RUNfUU9TX1RYX1NIRU1FX01BU0s7DQo+ID4gKwlpZiAoIWNicy0+ZW5hYmxlKSB7DQo+ID4gKwkJ
dmFsIHw9IFJPVU5EX1JPQklOX1NDSEVNRTsNCj4gPiArCQl3cml0ZWwodmFsLCBmZXAtPmh3cCAr
IEZFQ19RT1NfU0NIRU1FKTsNCj4gPiArDQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKwl9DQo+ID4g
Kw0KPiA+ICsJdmFsIHw9IENSRURJVF9CQVNFRF9TQ0hFTUU7DQo+ID4gKwl3cml0ZWwodmFsLCBm
ZXAtPmh3cCArIEZFQ19RT1NfU0NIRU1FKTsNCj4gPiArDQo+ID4gKwkvKiBjYnMtPmlkbGVzbG9w
ZSBpcyBpbiBraWxvYml0cyBwZXIgc2Vjb25kLiBzcGVlZCBpcyB0aGUgcG9ydCByYXRlDQo+ID4g
KwkgKiBpbiBtZWdhYml0cyBwZXIgc2Vjb25kLiBTbyBiYW5kd2lkdGggcmF0aW8gYncgPSAoaWRs
ZXNsb3BlIC8NCj4gPiArCSAqIChzcGVlZCAqIDEwMDApKSAqIDEwMCwgdGhlIHVuaXQgaXMgcGVy
Y2VudGFnZS4NCj4gPiArCSAqLw0KPiANCj4gc3VnZ2VzdGlvbjoNCj4gDQo+IAkvKiBjYnMtPmlk
bGVzbG9wZSBpcyBpbiBraWxvYml0cyBwZXIgc2Vjb25kLg0KPiAJICogU3BlZWQgaXMgdGhlIHBv
cnQgcmF0ZSBpbiBtZWdhYml0cyBwZXIgc2Vjb25kLg0KPiAJICogU28gYmFuZHdpZHRoIHRoZSBy
YXRpbywgYncsIGlzIChpZGxlc2xvcGUgLyAoc3BlZWQgKiAxMDAwKSkgKiAxMDAuDQo+IAkgKiBU
aGUgdW5pdCBvZiBidyBpcyBhIHBlcmNlbnRhZ2UuDQo+IAkgKi8NCj4gDQo+ID4gKwlidyA9IGNi
cy0+aWRsZXNsb3BlIC8gKHNwZWVkICogMTBVTCk7DQo+ID4gKwkvKiBidyUgY2FuIG5vdCA+PSAx
MDAlICovDQo+ID4gKwlpZiAoYncgPj0gMTAwKQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiAN
Cj4gbml0OiBtYXliZSB0aGUgYWJvdmUgY2FsY3VsYXRpb24gYW5kIGNoZWNrIGZpdHMgYmV0dGVy
IGluc2lkZQ0KPiAgICAgIGZlY19lbmV0X2dldF9pZGxlX3Nsb3BlKCkNCj4gDQoNCllvdXIgc3Vn
Z2VzdGlvbnMgYXJlIHZlcnkgaGVscGZ1bCwgSSdsbCBhbWVuZCB0aGUgcGF0Y2ggaW4gdjIuDQpU
aGFua3MgYSBsb3QuDQo=
