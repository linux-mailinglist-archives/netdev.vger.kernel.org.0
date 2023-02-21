Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFFF69D812
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 02:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbjBUBkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 20:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbjBUBko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 20:40:44 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2055.outbound.protection.outlook.com [40.107.21.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002F32312C;
        Mon, 20 Feb 2023 17:40:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmTiiW7ylOqIu5SRcOoPNf4AEzBemxR+tSlx3k6/vyiZ5iPOKn/FZRo/LhjbsLiLUPo0dWxzQhshWiMLOwfxDwttBVqBkAcqsUOIP/pRx1B96oWV1/RG5eFknY24XeziaHJLG16T46CJ+KE4VgawKSX2JVnc/aqsUP+TzklXtnSzLwvvCfwiRgJN1BXibzBs/bdWL+e+Gqy7cX0FsHYd96kf9EoSlr9YTXEH7wTvaLKa5BOcfiFK+RXYC/fkfoXm9XPPkVv/qGK3YlRqrVeuim7s3LB8fgg7iWLIUw3ipQGdN12+ad7dxHtNUfT/pA2lUFSpTT3cI02dgYfSTPKMbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGYz9Z0+e+ewu59bXLUXMkwGmw+nk5doSQ7F0K0Aoio=;
 b=FFII/7gxORwspHSyuqhgYaUaOGnilGJa3excvtwmZezbSqMzRmPBCZjdnWrbQtWl0b06y1hxmcClMNsojibILk0x2aavSGL7JBHjVOy7kjxglQOPzPCOT+JFzfkC05klI9l+5CHKwXOoNG5Qzowp/bpMuFpcwvqnKFLH4pfEmze1BeSdM7woGOQUJrApIXfj3vFZSt1rjPtVJjHltads2t6FIe9mxz08aSaQKrR0ooiBrMWXIM5Zy5hi2nnlPPl+KIfFijraFPAOQstiDqSwhe1rqUyj1B9FjXYiRmpzUkcCLifNNg0Zamkf17BWVH4+EMTF0jcX5o8vLqpIGRxCKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGYz9Z0+e+ewu59bXLUXMkwGmw+nk5doSQ7F0K0Aoio=;
 b=GlH5VN8kGSBE1pslQGOKgKcIyi0GPsns0P5fJfoxelkED/JdnBffmODfh6rcXavtNXKOb+oAwUKr1UjULyUWCTCSc934c0gEXT8LsUPcoHfA1DT8LLH2aGcWokZv+0u3KaXIJPo7Hdrvo2PAbIqb8op4S4xZ4wn7V543jVhH6RE=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM9PR04MB8274.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 01:40:39 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 01:40:38 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Richard Weinberger <richard@nod.at>
CC:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        pabeni <pabeni@redhat.com>, kuba <kuba@kernel.org>,
        edumazet <edumazet@google.com>, davem <davem@davemloft.net>,
        dl-linux-imx <linux-imx@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: RE: [PATCH] [RFC] net: fec: Allow turning off IRQ coalescing
Thread-Topic: [PATCH] [RFC] net: fec: Allow turning off IRQ coalescing
Thread-Index: AQHZQ+Gy2VXqw+BDuEeU3ZeJCH1tfq7XFCgQXmSDC7z9DmmEgA==
Date:   Tue, 21 Feb 2023 01:40:38 +0000
Message-ID: <DB9PR04MB81060AB7E965446151C0F20E88A59@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230218214037.16977-1-richard@nod.at>
 <PAXPR04MB81093DB4BF1F6A6B3F8F895088A49@PAXPR04MB8109.eurprd04.prod.outlook.com>
 <1448370281.155186.1676924115387.JavaMail.zimbra@nod.at>
In-Reply-To: <1448370281.155186.1676924115387.JavaMail.zimbra@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|AM9PR04MB8274:EE_
x-ms-office365-filtering-correlation-id: 2d7cc79d-711e-4522-db4a-08db13aca2be
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E6dm2Xw7i4WDZVKE2Zm8SRVo1F9qiA+tJcDtpsniJAzE+JIXWJ9MlNH5qtY+/vc9Vx4gfXAOnW7+WS8Elyh/A5HcnOM3ycLiHIchJVT0EvqGa4yHGeM9vr2AYzvBhEdvQvtMN5eh5KtjIUb5LiKfHshrrBLySEjz6bkek/iqeVON6LNxlpR19kkJzxRJ4Lba8LU4xM4I5cZrc3JRUiVRokBZ3N69SQG5sKf6ycjh+FfQjEMkbZ0syfwzNbBDxWl1njxUrAR6M0irgZZ4V1jVEtvjYlPwUcGehEAsbSFMDjjgqayib0OMTIXcd97i/nL22WYtfbdJSMWbncebcdiqIcwZDGxkt41cfF1O4kq9n6BbiZHXLuGUkrhKp7ruVbOmimi3seADlhPdoUcj2smjpqpe8ANQZ4PRYdnE5zuIu01SE0OxWzpLK9zYYypYzb89BSR9MGAg8T95rBiI6mdokdKUviBDxHCnUsLv65bfs6oV+3UAh1sJgLiG+y8sxq9OmSKrE8NEC95fwHEVlg4Uvu7NPnYBMqLZvNW6Png0vyxuSK1ZV6VnLm9NKc5m5PwEbpqnD5z3ejp/fHmHsmOc4krtizyxGuQCMAfKbAUnpNdCsB13IXuiqYEy64jntQ8J1BR6HBOs1rXzYxhXZpLt5wwDHMVK7Es3dsJFj+BPMtp9xyH4MzntZRRvuF8JNDteno+KV3+ek2slpMh0XnDc4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199018)(44832011)(5660300002)(122000001)(38100700002)(52536014)(38070700005)(8936002)(41300700001)(2906002)(66446008)(66556008)(66476007)(8676002)(76116006)(64756008)(86362001)(33656002)(478600001)(4326008)(6916009)(66946007)(54906003)(83380400001)(316002)(6506007)(26005)(53546011)(9686003)(7696005)(71200400001)(186003)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUIveExzZzRpZjErb3d6SEM1dVVlOXpLMGkrQjRuL1Z6UE1KRFY5YkZLUzNa?=
 =?utf-8?B?QnZvUE5DRk1pZ3lWWDRtSDRRNFFocEExZXNKM1E2L2FPQ1JseDZ4QmVpZmNO?=
 =?utf-8?B?Q25hQkVVNDNJT2c3Z0RwY0ZlclJEMGliTU5wZFdHUFhDK2VOclFMOGFNSWZH?=
 =?utf-8?B?NFhLRzhvTjlldjA2b3QrYW9jNWFmRWFJcWIrRmNvd0htOS9PZkxXTzkycGly?=
 =?utf-8?B?ZDJqMzM4NlE5c3FoWWExMnpld1FmMVpBQkZ6YTdWeDRxWVNOR01GTXF3Ri9G?=
 =?utf-8?B?QWVjdDFQZ0hFeXJObDlTdFdTZnBlVTFOdjJxMVdEa2ZnWjdlUjFPcTRHRGFw?=
 =?utf-8?B?eDFLMWF5eERycklla0svWUxTYXF5cTBsOGRFWVVoOHdBWk52ZjVYSitPdFFL?=
 =?utf-8?B?OTI1Z1N0bHNHNlA3eXFrL1JKV3NjQ1B3U0lMN1ZJVXZCT2V1S1BmRHFkREdR?=
 =?utf-8?B?TTh0UmdXQXcrQ2NNOEJBSm9pSitsMzlyamFNSWtZbTRUb2Ywc3lzamJkSmJB?=
 =?utf-8?B?UXU0UVB3VlBDUFV6aFBSR1JVWUhUbkpFSXJhUGJiK0drbndZTkVYckRyOWJM?=
 =?utf-8?B?emNUbmlkMVpYdGlLTzE1bUFzK3V3R3ZxaUd0NHNoN0l3S0hiUGxKV0xnczRG?=
 =?utf-8?B?cEJMZE5HN3BhcUd4b0VUZkxoNGJ2UTZRakRZU1U4Z0tnMnhPVllhaXF6cDRG?=
 =?utf-8?B?RnR5dlFXZEc3U0hoTjVHRTYwTFhYaWE1ZitjclRhZTc0ZCtYZ1QwaEY5K3BU?=
 =?utf-8?B?eHV5Y0ZKdjQ3ZmVEVVY1NXN4TG5GZjY5M1BVUU5UaGd4RExVeTVyYlpBRm9I?=
 =?utf-8?B?N05iSFB0QkhJZm5oaG1qTTUzVWtQVmtndzh3bGpuVUlqVDZEdDl2VHF4SmM3?=
 =?utf-8?B?aUpLNVRsdlkySUVUOXhMWVNHTmN6V0JrYlNOZ0FjaTEwSytTT09iWWw4bVFM?=
 =?utf-8?B?ejFZWnh6NHl3QThib0tEcVA3MkdrMFBKUnNrZExHK1UyT09TL3pYeGhSam9F?=
 =?utf-8?B?SFZTd3JFM09KN2o5aTZFU1NVelJYd1ZyTzVST3VweUJyMkdUOHZ1d2V3aXBu?=
 =?utf-8?B?b2RvVFhUMjRoVlVBZytKQWNjQUg0VW90dW5DeHV2ZHJ3R3dzbU0vcUVNUGYz?=
 =?utf-8?B?czNTMURGb0NWV1pXSlltV3QxOFRSWSt2T2VzTTlLRWs0SmhjeHRJdTY0SUxl?=
 =?utf-8?B?dC9OTHpIdSs3VmR1M2tNOEpONGJxNm5NMnliNmdaWG5CUDBjOFVteUxoSlpB?=
 =?utf-8?B?bGlkWDlTQWFpOUxKM3lEMjAvQ3VxWklvSmVCbWd2ejBZYTNUVHNLdzIwcW9r?=
 =?utf-8?B?SWJ1eHhCcGhmckRjWWlnNkdHYTljR2F6QUs4Vnc4L2Z6OXJxOVpPWUFYY1pR?=
 =?utf-8?B?YzY3Z0g4bjluVTluZC9IcjZMZElNTmNSL0dYOXJsazJ5dkxPQm5yMUFtdDdw?=
 =?utf-8?B?WGIveXgvRDNPejB0bk56VkgvZWxCWkEyRTJQRjMwSkRyYlBqNnhXdnpGYU5X?=
 =?utf-8?B?N0lJUVZvM1IyUzk3U2tmNVZCZ1JrN0hNTVJFNFV2dTFUaFc3WXl5WjFiZ0lK?=
 =?utf-8?B?VTZ2Zm0zWDhaUUNJN0k1a3N1RnNDaTY0dTc1VkRvaEZCN2FmZ2tYcUFBd0I3?=
 =?utf-8?B?TDdldzlxYzJMS0Z0aHVhQ0U2U0J3eWx0LzUvM2pFOFNrN1U3YVpYWVZvYllj?=
 =?utf-8?B?SXluZW9CMy9HWjdJUVRXTEdBRlFKWUpWeVlwN1BKNEU4WVBHc2V1RjFjM3Ny?=
 =?utf-8?B?ZStTNlZIQWQ2UHByWDZ4Skk4NjhxME1vVVFtcVBvTFRsSFFPd0d4ZXFzZDEw?=
 =?utf-8?B?RnNZcUZkejBGZVpEc2g5aVRZWVBKZldPblNtTDF4T2E5SzdxMXp5VjhSTUxv?=
 =?utf-8?B?NVY0Q1luQzd1N1BMR0dMODVpLy9vTkJFV3ZJRFBCMHdid3FpM2FYMTQ2ckJS?=
 =?utf-8?B?NlBqNTNieXVqQlZRaHZEZm10cFlZTFd1RThZc00waS9aUXdkNmplR09sRmpE?=
 =?utf-8?B?YXhYQ3dKUUFzdGVMN2x0cXVJNndCY3d2dkgxRmp4WHNpckxDMTdHZ1JUVUQw?=
 =?utf-8?B?TXU0ZGl4VjhUSE9zdHlIS04zdlhMQU1STHN3bVAyenV2c3hJOEFwZUlkdzgw?=
 =?utf-8?Q?zP4U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7cc79d-711e-4522-db4a-08db13aca2be
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 01:40:38.8151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pz6hoMfjL2Y3JLzs8YdXPSgXJEzWSjssVkJE3zD1yV7v+8YOG60gRlARA+Of4CIIKn6GzM03g72n9rGqInTfYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8274
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIFdlaW5iZXJnZXIg
PHJpY2hhcmRAbm9kLmF0Pg0KPiBTZW50OiAyMDIz5bm0MuaciDIx5pelIDQ6MTUNCj4gVG86IFdl
aSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogbmV0ZGV2IDxuZXRkZXZAdmdlci5rZXJu
ZWwub3JnPjsgbGludXgta2VybmVsDQo+IDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsg
cGFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IGt1YmENCj4gPGt1YmFAa2VybmVsLm9yZz47IGVk
dW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgZGF2ZW0NCj4gPGRhdmVtQGRhdmVtbG9mdC5u
ZXQ+OyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgQ2xhcmsgV2FuZw0KPiA8eGlh
b25pbmcud2FuZ0BueHAuY29tPjsgU2hlbndlaSBXYW5nIDxzaGVud2VpLndhbmdAbnhwLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSF0gW1JGQ10gbmV0OiBmZWM6IEFsbG93IHR1cm5pbmcgb2Zm
IElSUSBjb2FsZXNjaW5nDQo+IA0KPiBXZWkgRmFuZywNCj4gDQo+IC0tLS0tIFVyc3Byw7xuZ2xp
Y2hlIE1haWwgLS0tLS0NCj4gPiBWb246ICJ3ZWkgZmFuZyIgPHdlaS5mYW5nQG54cC5jb20+DQo+
ID4+ICAvKiBTZXQgdGhyZXNob2xkIGZvciBpbnRlcnJ1cHQgY29hbGVzY2luZyAqLyAtc3RhdGlj
IHZvaWQNCj4gPj4gZmVjX2VuZXRfaXRyX2NvYWxfc2V0KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2
KQ0KPiA+PiArc3RhdGljIGludCBmZWNfZW5ldF9pdHJfY29hbF9zZXQoc3RydWN0IG5ldF9kZXZp
Y2UgKm5kZXYpDQo+ID4+ICB7DQo+ID4+ICsJYm9vbCBkaXNhYmxlX3J4X2l0ciA9IGZhbHNlLCBk
aXNhYmxlX3R4X2l0ciA9IGZhbHNlOw0KPiA+PiAgCXN0cnVjdCBmZWNfZW5ldF9wcml2YXRlICpm
ZXAgPSBuZXRkZXZfcHJpdihuZGV2KTsNCj4gPiBkaXNhYmxlX3J4X2l0ciBzaG91bGQgYmUgZGVm
aW5lZCBiZWxvdyBmZXAgdG8gZm9sbG93IHRoZSBzdHlsZSBvZiB0aGUNCj4gPiByZXZlcnNlIENo
cmlzdG1hcyB0cmVlLg0KPiANCj4gT2YgY291cnNlLCB3aWxsIGZpeCBpbiB2Mi4NCj4gDQo+ID4+
IC0JaW50IHJ4X2l0ciwgdHhfaXRyOw0KPiA+PiArCXN0cnVjdCBkZXZpY2UgKmRldiA9ICZmZXAt
PnBkZXYtPmRldjsNCj4gPj4gKwlpbnQgcnhfaXRyID0gMCwgdHhfaXRyID0gMDsNCj4gPj4NCj4g
Pj4gLQkvKiBNdXN0IGJlIGdyZWF0ZXIgdGhhbiB6ZXJvIHRvIGF2b2lkIHVucHJlZGljdGFibGUg
YmVoYXZpb3IgKi8NCj4gPj4gLQlpZiAoIWZlcC0+cnhfdGltZV9pdHIgfHwgIWZlcC0+cnhfcGt0
c19pdHIgfHwNCj4gPj4gLQkgICAgIWZlcC0+dHhfdGltZV9pdHIgfHwgIWZlcC0+dHhfcGt0c19p
dHIpDQo+ID4+IC0JCXJldHVybjsNCj4gPj4gKwlpZiAoIWZlcC0+cnhfdGltZV9pdHIgfHwgIWZl
cC0+cnhfcGt0c19pdHIpIHsNCj4gPj4gKwkJaWYgKGZlcC0+cnhfdGltZV9pdHIgfHwgZmVwLT5y
eF9wa3RzX2l0cikgew0KPiA+DQo+ID4gSSB0aGluayB0aGUgYmVsb3cgc2hvdWxkIGJlIGJldHRl
cjoNCj4gPiBpZiAoISFmZXAtPnJ4X3RpbWVfaXRyID09ICEgZmVwLT5yeF9wa3RzX2l0cikNCj4g
DQo+IEF0IGxlYXN0IGl0J3Mgc2hvcnRlci4gOi0pDQo+IEknbSBub3Qgc3VyZSB3aGljaCB2YXJp
YW50IGlzIGVhc2llciB0byB1bmRlcnN0YW5kLCB0aG91Z2guDQo+IA0KPiBCdXQgaW4gZ2VuZXJh
bCB5b3UgYXJlIGZpbmUgd2l0aCByZXR1cm5pbmcgLUVJTlZBTCBpbiB0aGlzIGNhc2U/DQo+IEkn
bSBhc2tpbmcgYmVjYXVzZSB0aGF0IGEgdXNlcnNwYWNlIHZpc2libGUgY2hhbmdlLg0KPiANCkkg
dGhpbmsgaXQncyBmaW5lIHRvIHJldHVybiAtRUlOVkFMLiBGb3IgaGFyZHdhcmUsIG9uZSBvZiB0
aGUgdHdvIHBhcmFtZXRlcnMNCmlzIDAgaXMgYW4gaW52YWxpZCB2YWx1ZSB3aXRoIHRoZSBpbnRl
cnJ1cHQgY29hbGVzY2luZyBlbmFibGVkLCBhbmQgdGhlIGJlaGF2aW9yDQpvZiBoYXJkd2FyZSBp
cyB1bnByZWRpY3RhYmxlLg0KDQo=
