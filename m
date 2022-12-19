Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D1965064D
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 03:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiLSCV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 21:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiLSCVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 21:21:23 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2041.outbound.protection.outlook.com [40.107.22.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE1CB87D;
        Sun, 18 Dec 2022 18:21:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4gAJRzmzmXwVtQf2NIH8eAS1HC75du+Bmgn4WetTH50NiousLG3YmCNOdK0h7P5us9Q65/2rVZQf2DP6x+anqS8qmGfuz4HEjwyeu/J0ALRfqrGrFGEcFtO2oJbAQKKQj0TkdN2C+vdRrX7A+yQRU3Ddu5hhVil2qfLUPYKPVuLX2OOwf2W/wFmiAB2lOKnVOfPY7otGqS11bbA/CUdyKRVJgPFOA25rXmlYgN48VFVUI63kTjg7wbFd7IT4KQYBm9AA1J1INRAQ2SUsrpaqz8VWqkPVGet2cIY1bj/gOdPxiz8/KBLPTDNbISXQ/BmUFSqf5m/nj1A5Xwn3jklUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NQjZ2CwU382menQZAjaoi2jN2o37KEQXQDnPx5KddWw=;
 b=XPIshvKPAnusKTfPvx9kyxenmh+HLGxilZXT9KYJZOX97t6ToFgDlSlXsxzt4wGtmqqFPZN03ThqjjWEbCKo1Uecyc8w8r7paZviwG62pgHrOPUx0Hhzjy/3TXpzuzwpAqddG0Rrjvxis6aHDKcI9OlLpqvl3uMFNHHSLMdCDpguSp6jAYF/ja212dvrqZIpIUosbcQ7NSGfrVg9Uc81CP7MGdh2aNMa8jFeCRSmAwXIjOIVlfP9hQBIgzgq4XhmX26qoZCTFzaqWbVjnnGd/pkY5Pl9l9jJHTtsMu/bRVwoK0GNSxXfvN5g1pkOkUnmIpFZfVGXKUJSbqZMmdR9Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQjZ2CwU382menQZAjaoi2jN2o37KEQXQDnPx5KddWw=;
 b=HSKnGQe3mNWWmR4pbU1UqrMw8zxN7Dxa6do+TJU+5k8jDFedw7TmvolvDMKVywcEITXK2ju3pjx2PtqmpgYoiGnA7R7lmkcQyAc4cG2Ivu/F+xCu5ZJ5eWF1GywoCT+mzTloaKs7szXfjriFiDji9bvyCVfhp3Hy6DHOeA83LR0=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by PAXPR04MB8206.eurprd04.prod.outlook.com (2603:10a6:102:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 02:21:14 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::e9c1:3e78:4fc8:9b24]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::e9c1:3e78:4fc8:9b24%8]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 02:21:14 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: fec: Coverity issue: Dereference null return
 value
Thread-Topic: [PATCH net] net: fec: Coverity issue: Dereference null return
 value
Thread-Index: AQHZEGW9bKTp/R/BVEeUVTYzA4wn+65wpvCAgAPRdnA=
Date:   Mon, 19 Dec 2022 02:21:14 +0000
Message-ID: <DB9PR04MB8106CF1A1A6317D30A15583F88E59@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20221215091149.936369-1-wei.fang@nxp.com>
 <be98552a061f6249de558b210ff25de45e80d690.camel@gmail.com>
In-Reply-To: <be98552a061f6249de558b210ff25de45e80d690.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|PAXPR04MB8206:EE_
x-ms-office365-filtering-correlation-id: 17f18202-35ce-40ac-3111-08dae167b430
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KW8HUCraq6WuI9JzXoN1P3uTVbDGG0kRAUI8/ey9kCJ4NVAymbkvgjB48zN+C3G4PIFRM90EXqx+qaH3+Ab5AOz2peXYb+KIFWX9KW90SaL5SkR+5kzZnBz+QXxzVCbByt8gUMLOMr4556a/hKEKplYDOFsfZ3GmKWf5hCfLnSfwD96FhxTlLLnHC7Y6pSyhHAixE+eNO3YEl+1RGiS0Sk4SM6lWHr8uooeixTAyly6iFDHDAO/f8UuNEN+PxEIGJm/B8M38Ylu3YL+8/iR6zSJDtk591M8kJlivHAbSDKgiPkyV6xPu8lTPqRAWC+8tBZ7UGS3VCGVWU+6QB4iBOJsI1uzTWY/QRE3CobyqB0uIHaFkKZvBjt3Liy3jCh82vk/ybtT3eYnJiSnyhaqQ51mRfJm5WsJ3kymN2aDW2zGLEp9OZ1TG8RcbeTaQU4yM9Ogl0qVXRwCj6+B0zFlYfBPeTJ6koHiCTp3WMtKcMW4JT7jBx4ZxiL+F16G0qIRaKq2Udx4n1d3fZwbChgDHMlS2XFfzNDk+86W9IEWGUssMEucgun4kdC34q67hlJt3i1/4w19aO2UT618v1/QhW8PEVt5j1dOx+4bgvjyxfasbIOGM3FLIs4V8zYML5y1EIXJGtxqu46P9JNjzQKrC108DZbW0rOxGv2j3+YpGflBvDz6zWYl0lD2YHXMnHqMlJgQKS7OEgHvg/EsIuVfl4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199015)(6506007)(316002)(7696005)(53546011)(26005)(186003)(9686003)(110136005)(478600001)(6636002)(54906003)(8936002)(8676002)(64756008)(66476007)(4326008)(66446008)(66556008)(76116006)(66946007)(52536014)(71200400001)(83380400001)(5660300002)(44832011)(4001150100001)(2906002)(41300700001)(55016003)(33656002)(38100700002)(122000001)(86362001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXlYdkdNL0JyZGlmWnVtemgvbDAxbHYxQk5NUGUwc3l2QnlPK1M1Z2RPbUtQ?=
 =?utf-8?B?WmN0ZHkvdUY0M1ZLd0JTVHVqWElSVVVBcUQveHhmdUNuY2VWaExEM0trM2lm?=
 =?utf-8?B?TmRBakxUQi90MVVDclZjMjJ0VmFkZVhkZlA1eXIzTkt5ZzlrWE84SEhYSzU4?=
 =?utf-8?B?K3N1ejhjUjVOUXlUbzJpaVpGNkc5eFdJMnRiQkRaOXkzN3BTL2Z0QXc1b0Y5?=
 =?utf-8?B?dm5neWordVl4N0xGRDA5Y0NTdFZQbG9rd0wzSUdwMy8xeW9HY1ZUbDdQZzY1?=
 =?utf-8?B?N1lOOS9tZWo2c0hTWVppVXo2WEpuNmZTdTBvTnl2TzN5NTJDSHlhUndCWWNR?=
 =?utf-8?B?OExsMk5xTk40b3B0V05hTVVmQTRabFI3VXdYSDdzTEhNK1dqaXNTUEZtTnRP?=
 =?utf-8?B?Wkp2eU8vdjBQS1Rta0l0SlVmKzZ6ZDVhbnFrMVlDWS9UNXpEREdBdWlWZDZS?=
 =?utf-8?B?ZjQ5WHVLSFZvSEdNeDZQekwyWjFVQ0d0VmNMRHpIV2JaNGY0TGZBcmhERWZ1?=
 =?utf-8?B?ZXRCeUN5RXFjY1hTNW5aT1orR1JwbnFJY2I1RDdRZ0ExUThQN0M4azZKOVg3?=
 =?utf-8?B?SnJKb241NEQrZzdHYVYxMlJNTFJ3bGIzcHJtRG8wc0d4N0hvVlZQaXRzMDM1?=
 =?utf-8?B?NUR1RXFOYmNocnZVUHFSTXNTeEIvc3BGVm5lUVEzNm5wV1ZBSXhnc1o4UXFk?=
 =?utf-8?B?Z2FyaW4yMFp1aTNRT0NIcHJhSTFQMnZ5d051ekRkOGJyYi8vU0ZYTmZXczY0?=
 =?utf-8?B?QVlTNXZvYWNJL3VhMVh2cGhUN09uWm1EWThvZHRzUlR2ekpOL2Jsd3N5UTZk?=
 =?utf-8?B?dGRQUHFCQXdOZXkvNm82SDRhWGhaSHVnVG5CNXVFMk1DanJNakVhSTdaMXd1?=
 =?utf-8?B?SFhVbnBZN2dGWjVVMDVXbStQMnRscnhOa01seVlPWVN6Y2liVUFsbk56WE4x?=
 =?utf-8?B?YjhmUk9YTDhjWnpjSEhOblBCMWpXZTNodWtBa1c2VmhoaURpZWJ1cjlrbVdX?=
 =?utf-8?B?TTVSTFJoTFVFNHpHU2JlNHV3aGxsYUVkRXZrZEt1cnZ0VmFScXVVbzRLMzMw?=
 =?utf-8?B?dVdaSWhKZ1lLa0p6Z050TzRoekFGOXBYNklaNks1NnVTLzlmbFhGcFNDM1Zp?=
 =?utf-8?B?ayt6UU9teWRtck5BbHo1eExYM3FycHNBMHZqM0o4VEhVaTM4cE0ydEZrMFdT?=
 =?utf-8?B?U0lPdEdnVmtEZ2RxM3ZnK05odUg5U0phM3p1SnE3RkZtWE5MNDJ2Vkl5MXly?=
 =?utf-8?B?ZXg2TklJanhMcndVRjRCVjdMUDRWTU9FVHdTellyV0E3ZDhpYis0amkyS2F4?=
 =?utf-8?B?ZHNiRFNzVlQrM2h4cTVPRVpkTi9XL3pSd2tWTW8vNksvMTFsUzRLeEUrcUhC?=
 =?utf-8?B?UUU0WFRsUGExR2d5QnhlNk50S0xWaXQ1MWRHaGNZVkNjN21JWUx6OGY0MzNF?=
 =?utf-8?B?VEMwdjd1eTE1SjcyWU9YbUpORG5mZnllZDlnNU0vWmdqWHpEK3l0MGphZDFJ?=
 =?utf-8?B?Qi9KVlNUOUsrcFZGTGdaRXY5U2xUdkVIc01jWnpZZVNkQlM2YlZ2bi94NGx4?=
 =?utf-8?B?c09oY09ySHRndUVjdTRxbHhyOE1zeEJLMlFmTmJ1VzlzQU9sU0hQZVpIZ3Bv?=
 =?utf-8?B?S000aDFrQjBxUGlRcmVtcTJFdzNBeXNPMU80K3dsWjV1Ym9Jd0o2cnVkV1dO?=
 =?utf-8?B?SXFERlNpUC80T0VyWlNBTnJJZWVhTkZPSTBvZEk2ZDRtM285MEhrZ1RBOWQx?=
 =?utf-8?B?UDlpa1hnVDg2aTJCRktsbTA1eFJkaVBiTk5vT0Q4RXVhQjBvZ0t6cmpad1lw?=
 =?utf-8?B?OElvS29ZbkpuUE1mWEQwT1R1UmxnZlJwRENpb2dncnNaRHQ2NDhaQjhYb0Vi?=
 =?utf-8?B?d21tZFFZdHloWjFVQ3lSNjVKallGTFhTY2VYRTBTYXdCd3R0STRzb1JPWWxX?=
 =?utf-8?B?MHZtREZ6S3grSFIxUzZVeG02SWhRdis2UU1xcnhOR0d1cGR3TEZ1T2pIcTgx?=
 =?utf-8?B?K3J5aW1jTzIybzIrSTdjYkVuR3ZIN0N4Wlk0bzhvRFNsaHBBVDZSc3pXWVhH?=
 =?utf-8?B?a0M3QXJuUVVYbHhmVmNJRENFdkVUK1lCZm8zcTlCdEJrV09vTVE5Qm52VjZk?=
 =?utf-8?Q?5628=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f18202-35ce-40ac-3111-08dae167b430
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 02:21:14.6816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L/2k+2LqT5wda8reI+hLiOuouDQicuSW3c6QF0qm2pEFMPmv1tqCTqICh/oadO1dKtw2RqaTL+otHiTMqMkk3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8206
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFsZXhhbmRlciBIIER1eWNr
IDxhbGV4YW5kZXIuZHV5Y2tAZ21haWwuY29tPg0KPiBTZW50OiAyMDIy5bm0MTLmnIgxNuaXpSAy
MzozNA0KPiBUbzogV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+OyBkYXZlbUBkYXZlbWxvZnQu
bmV0Ow0KPiBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRo
YXQuY29tOyBDbGFyayBXYW5nDQo+IDx4aWFvbmluZy53YW5nQG54cC5jb20+OyBTaGVud2VpIFdh
bmcgPHNoZW53ZWkud2FuZ0BueHAuY29tPjsNCj4gZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhw
LmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXRdIG5ldDogZmVjOiBDb3Zlcml0eSBp
c3N1ZTogRGVyZWZlcmVuY2UgbnVsbCByZXR1cm4gdmFsdWUNCj4gDQo+IE9uIFRodSwgMjAyMi0x
Mi0xNSBhdCAxNzoxMSArMDgwMCwgd2VpLmZhbmdAbnhwLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBX
ZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gPg0KPiA+IFRoZSBidWlsZF9za2IgbWlnaHQg
cmV0dXJuIGEgbnVsbCBwb2ludGVyIGJ1dCB0aGVyZSBpcyBubyBjaGVjayBvbiB0aGUNCj4gPiBy
ZXR1cm4gdmFsdWUgaW4gdGhlIGZlY19lbmV0X3J4X3F1ZXVlKCkuIFNvIGEgbnVsbCBwb2ludGVy
IGRlcmVmZXJlbmNlDQo+ID4gbWlnaHQgb2NjdXIuIFRvIGF2b2lkIHRoaXMsIHdlIGNoZWNrIHRo
ZSByZXR1cm4gdmFsdWUgb2YgYnVpbGRfc2tiLiBJZg0KPiA+IHRoZSByZXR1cm4gdmFsdWUgaXMg
YSBudWxsIHBvaW50ZXIsIHRoZSBkcml2ZXIgd2lsbCByZWN5Y2xlIHRoZSBwYWdlDQo+ID4gYW5k
IHVwZGF0ZSB0aGUgc3RhdGlzdGljIG9mIG5kZXYuIFRoZW4ganVtcCB0byByeF9wcm9jZXNzaW5n
X2RvbmUgdG8NCj4gPiBjbGVhciB0aGUgc3RhdHVzIGZsYWdzIG9mIHRoZSBCRCBzbyB0aGF0IHRo
ZSBoYXJkd2FyZSBjYW4gcmVjeWNsZSB0aGUgQkQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBX
ZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogU2hlbndlaSBXYW5n
IDxTaGVud2VpLndhbmdAbnhwLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMgfCAxMCArKysrKysrKysrDQo+ID4gIDEgZmlsZSBjaGFu
Z2VkLCAxMCBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+ID4gaW5kZXggNTUyOGIwYWY4MmFlLi5jNzhhYWE3ODA5
ODMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19t
YWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4u
Yw0KPiA+IEBAIC0xNjc0LDYgKzE2NzQsMTYgQEAgZmVjX2VuZXRfcnhfcXVldWUoc3RydWN0IG5l
dF9kZXZpY2UgKm5kZXYsIGludA0KPiBidWRnZXQsIHUxNiBxdWV1ZV9pZCkNCj4gPiAgCQkgKiBi
cmlkZ2luZyBhcHBsaWNhdGlvbnMuDQo+ID4gIAkJICovDQo+ID4gIAkJc2tiID0gYnVpbGRfc2ti
KHBhZ2VfYWRkcmVzcyhwYWdlKSwgUEFHRV9TSVpFKTsNCj4gPiArCQlpZiAodW5saWtlbHkoIXNr
YikpIHsNCj4gPiArCQkJcGFnZV9wb29sX3JlY3ljbGVfZGlyZWN0KHJ4cS0+cGFnZV9wb29sLCBw
YWdlKTsNCj4gPiArCQkJbmRldi0+c3RhdHMucnhfcGFja2V0cy0tOw0KPiA+ICsJCQluZGV2LT5z
dGF0cy5yeF9ieXRlcyAtPSBwa3RfbGVuOw0KPiA+ICsJCQluZGV2LT5zdGF0cy5yeF9kcm9wcGVk
Kys7DQo+IA0KPiBJJ20gbm90IHN1cmUgeW91IHJlYWxseSBuZWVkIHRvIGJvdGhlciB3aXRoIHJl
d2luZGluZyB0aGUgcnhfcGFja2V0cyBhbmQNCj4gcnhfYnl0ZXMgY291bnRlcnMuIEkga25vdyB0
aGF0IHRoZSByeF9kcm9wcGVkIHN0YXRpc3RpYyB3aWxsIGdldCBpbmNyZW1lbnRlZCBpbg0KPiB0
aGUgbmV0d29yayBzdGFjayBpbiB0aGUgZXZlbnQgb2YgYSBwYWNrZXQgZmFpbGluZyB0byBlbnF1
ZXVlIHRvIHRoZSBiYWNrbG9nLCBzbw0KPiBpdCBtaWdodCBiZSBiZXR0ZXIgdG8ganVzdCBsZWF2
ZSB0aGUgcnhfcGFja2V0cyBjb3VudGVyIGFzIGlzIGFuZCBhc3N1bWUgdGhlDQo+IGFjdHVhbCBw
YWNrZXQgY291bnQgaXMgcnhfcGFja2V0cyAtIHJ4X2Ryb3BwZWQuDQo+IA0KQWNjb3JkaW5nIHRv
IHlvdXIgYWR2aWNlLCBJIGxvb2tlZCB1cCB0aGUgTGludXggZG9jdW1lbnQsIGFjdHVhbGx5IGFz
IHlvdSBzYWlkLA0KdGhlIHJ4X3BhY2tldHMgc2hvdWxkIGluY2x1ZGUgcGFja2V0cyB3aGljaCBo
b3N0IGhhZCB0byBkcm9wIGF0IHZhcmlvdXMgc3RhZ2VzDQpvZiBwcm9jZXNzaW5nIChldmVuIGlu
IHRoZSBkcml2ZXIpLiBUaGFua3MgZm9yIHlvdXIgcmV2aWV3LCBJ4oCYbGwgYW1lbmQgdGhpcyBp
biB0aGUNCm5leHQgdmVyc2lvbi4NCg0KPiA+ICsNCj4gPiArCQkJbmV0ZGV2X2VycihuZGV2LCAi
YnVpbGRfc2tiIGZhaWxlZCFcbiIpOw0KPiANCj4gSW5zdGVhZCBvZiBuZXRkZXZfZXJyIHlvdSBt
YXkgd2FudCB0byBjb25zaWRlciBuZXRkZXZfZXJyX29uY2UgZm9yIHRoaXMuDQo+IEdlbmVyYWxs
eSBzcGVha2luZyB3aGVuIHdlIHN0YXJ0IHNlZWluZyBtZW1vcnkgYWxsb2NhdGlvbiBlcnJvciBp
c3N1ZXMgdGhleQ0KPiBjYW4gZ2V0IHZlcnkgbm9pc3kgdmVyeSBxdWlja2x5IGFzIHlvdSBhcmUg
bGlrZWx5IHRvIGZhaWwgdGhlIGFsbG9jYXRpb24gZm9yIGV2ZXJ5DQo+IHBhY2tldCBpbiBhIGdp
dmVuIHBvbGxpbmcgc2Vzc2lvbiwgYW5kIHNlc3Npb25zIHRvIGZvbGxvdy4NCj4gDQpZZXMsIGl0
J3MgYmV0dGVyIHRvIHVzZSBuZXRkZXZfZXJyX29uY2UgdGhhbiBuZXRkZXZfZXJyIGluIHRoZSBz
aXR1YXRpb24geW91IGRlc2NyaWJlLg0KVGhhbmtzIGFnYWluIQ0KDQo+ID4gKwkJCWdvdG8gcnhf
cHJvY2Vzc2luZ19kb25lOw0KPiA+ICsJCX0NCj4gPiArDQo+ID4gIAkJc2tiX3Jlc2VydmUoc2ti
LCBkYXRhX3N0YXJ0KTsNCj4gPiAgCQlza2JfcHV0KHNrYiwgcGt0X2xlbiAtIHN1Yl9sZW4pOw0K
PiA+ICAJCXNrYl9tYXJrX2Zvcl9yZWN5Y2xlKHNrYik7DQoNCg==
