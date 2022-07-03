Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4281E564588
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 09:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbiGCHPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 03:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiGCHPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 03:15:22 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2115.outbound.protection.outlook.com [40.107.113.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8628E654C;
        Sun,  3 Jul 2022 00:15:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npOp/AgHb/JhFWP+UU8APUVT2sPjBI9Vu5LLSAeRyc5SwI4FkiH4TTbtCTeVizqHuBE/ckwisVTboGs0K+64cXlYkEI5TlG7/OxsoBSg6bcLttN/UjH/K5/RDHSA4v1qCfFHv3rvKtyRPMnuks31LfI3KMOQJt0PC5kku9Ssz4UEJD1uT506O8iKLl3M7BWehH8bwAKnyX31xHBAXHNvGd3vgFvoh32a35wOMeB+eiOrQZVth1xsKiQusPkmQ78UpnNb2QpNX7iNvixhGL6dL6q7uT7NS4O2Eny6yLzzoIhB6qjZE0GgvTeC/6GOYIyHme64BaY1xWbdeBdyjuAONA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4/LzHcHpmw8+AjcaYPmsTGIeALX2olHx7dDneVpnuA=;
 b=gLqAdpQU2qMBv5gl6zGBYc3dMxhXRMSKPq4x0/98Nl9R34vVB9tib+zmr4YU4AWSQqgZQHSM4TZGvc4y6YTPp8Q4CNLau+JSTj6gln0gk0joUFxqe6rTd7msX05DccnkDse7K95IBM5Ds4pKqt9wW6yW3ItXxYY0iePRH79lDJcl8lYNhH61albA0N/+e2+PBhWecIOV1+t3smjIjFdyXsav6D2RyFz35uAUk0Y9OI59za0veBoof3GnwdZeGKRTnXqhpC7mN9G3JyGMBodCqdJTnLbLExZRL2vARLXR653WlBGOe+tbb5LnJdi5OWTcfolnRxECeQPGkYc8RPWVlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4/LzHcHpmw8+AjcaYPmsTGIeALX2olHx7dDneVpnuA=;
 b=VNBlsQWQ4NUi0Y8T/cQXQEzy4MaSOIR2qcacuZMO5T6YmeFxKvQV8ZJCbpgltX7+/F9e6kzGDy2DL1RICQxbxYmoCexLNe9xMMv3cbNzSXxtmNRB2LtTmjZLTkvPDthf+auvybFY3C74sf8Up9ArROyncHjuMHI1tpmhD8idWcs=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB6624.jpnprd01.prod.outlook.com (2603:1096:400:9b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Sun, 3 Jul
 2022 07:15:18 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%9]) with mapi id 15.20.5395.019; Sun, 3 Jul 2022
 07:15:16 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "ukl@pengutronix.de" <ukl@pengutronix.de>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Thread-Topic: [PATCH 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Thread-Index: AQHYjhxRAU4FS3w2jke6iP64ezr8Wa1rSJoAgADvqqA=
Date:   Sun, 3 Jul 2022 07:15:16 +0000
Message-ID: <OS0PR01MB592277E660F0DAC3A614A7C286BF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-7-biju.das.jz@bp.renesas.com>
 <20220702164018.ztizq3ftto4lsabr@pengutronix.de>
In-Reply-To: <20220702164018.ztizq3ftto4lsabr@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10566c42-c1e2-4276-b320-08da5cc3c7d2
x-ms-traffictypediagnostic: TYCPR01MB6624:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XqzpbGItpQM7TMlCyuNLRdGJy4uQxQusLfm+qZb5Baf+kz7IMEl6+sEUjeeTUcdUDbvKSQTMq7mMUVWmlbq6aJMqwAzPI2lQ1joH+aeMfef02rMi3XXkZO86ShPCshxcRP3TQobhqTOkiXqA9LFVGSShJOcvm5ycyqjBKvqKeXUmJlAF1/ktpuuh+zv4i+cTWL+3quY4UP7VPN5XPW8intYhVg1URaCcflyVjOR5CTLejK7cWOdT+4sGXrYXC99UEz6jh2pyoRYDch0cAwzmkIiFF0sfY6/jbrMjQRY6/J3jwDUulTeSTMEucimjysLlBvuRXAi035qcXprgUqlkSBaTP3CigDtUsSv5D8zUxwd6UX3oHXjncKfOeHjPFrMlOdM4PUEimd38b49KAirjyOGXE/9vgO/fjRc7wJ0WO/5Qj8J3LKKNYVHkuIoIT+sjybqwpr7MVi6pzVBdo5HGAJJYd4GUEVHbL9gvl95Lh7LJ9AioUQRq9JCplbeIedcjQWwAlgh0PazEEvk63k/V0VqsoKm7/82Kp96IFk3e714JJ3agjLnqtaYDZWo9N9IzpCyIBqIgYzS2upZzkFJM1HrshFMfP3mec4wTfIQyhiWjTPiBZehQHR3g6gEEc3C9VDLwlgZy9p8Ejmaa+Cj9fl3nBtR0GOytzP6mavZCZiVyIu9mUYMRud2Ytxp3rNUG0zq7didYNJGMi/SeWr6TnG53IQjZPeWKjRJxUuG0vrsMlOaKNzL2h2i5vrEuyy+h5FnKkldBQaSOCfOBGznbuUoeijfbiY0qK/nxChyL691hnaDSkl9DIzBA+ZmV3lqe8D+H+NWZd0u5VgxXg1Qf8rptePL+9yxnwSGQMTVu8yw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(86362001)(7416002)(66946007)(71200400001)(53546011)(38100700002)(316002)(54906003)(6916009)(6506007)(7696005)(55016003)(33656002)(41300700001)(9686003)(83380400001)(26005)(186003)(478600001)(52536014)(64756008)(66476007)(66446008)(4326008)(5660300002)(8676002)(76116006)(122000001)(966005)(8936002)(66556008)(2906002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjN6eGpwR3J5YVhCaWc3NlhnbnJ1MFc4NkR0YjI4VWdxTHptYlFwMFREUkhy?=
 =?utf-8?B?YVlzc01RR2Zzekd2VlYvNVdaQWkyWFZBbnp6VWxtZmxUUEJ2T2YrQnNmS3Vx?=
 =?utf-8?B?TFphQlRscXNMMW9jTVBjVVBIRkVvVGVnMUlFbjkzcFFYYzZxVE5ud2tFc1Vj?=
 =?utf-8?B?WS9Ub1Q3bDBKaHhQdERISnJSa0VHY1VtaWhGWHRVMUJpM0dqVGtVTm5BSEZM?=
 =?utf-8?B?WGk0NWpFMElSbWNJV0lvNzh4eUxqckFrcU5lRnlGaFBibjRsWEYwanVtbFZB?=
 =?utf-8?B?NlRhS2loV29BTmEwZ05GOUhzV0JmeGtrUy9KQUdqR1lYU0JhVHR1Y1lJQzBB?=
 =?utf-8?B?OVBZalFOczdMbnQvZ21WVnI1MDU2Y3lZNVZDOGxDMktTUjBXcFZpTjZLT3dS?=
 =?utf-8?B?SVgwM242eThPeXpmUDBOWW0wWFVFTkRreHVHdllvdkVmbW1VRUxJT3lMS1J1?=
 =?utf-8?B?NE9rSG9QdUZUS241c3JuOER3ZDhYeXR5KzRzUTZPd0pJOC80djg2WWZXSDNj?=
 =?utf-8?B?OHVDZFBMWnA3UjBHcktqT25IRTNua2NQREhFOFd1Q1ZCZ2JoNUJzb3h2QS8r?=
 =?utf-8?B?OVRRdm5wTDVZWHJwc2N1K1pZUy9kc2dyMzBmeHJJK3NXcTQwTk9NNFBlcVNa?=
 =?utf-8?B?dEJaZUt5bXROQ2NyNndTM3VWSEJvUURhOGxhY0NSSHJNaUJQNnRLWnU4VG4r?=
 =?utf-8?B?SGFqdThDMzBkb2cvM245MFVUNzRtaEF5N0xSaXpVUkxpN3kzamJsaFRHaHRy?=
 =?utf-8?B?WDdlTXJ4WFYrbFhWTHRQMGJhR2lvbFQ5Ulo5ZFhyZXh6Z3dpUStPVFB1MVJS?=
 =?utf-8?B?SDcrOEFoS2hXOFo1OFJvdWl1NS9GSmMySy9VMmJLdXczbURPV05GQ25sR2Fp?=
 =?utf-8?B?bmZBdzVpZWt3NDlmck1HT25GaGhTRUIzOXd4SzlHZ0NVRmkySTJSQThqSC8z?=
 =?utf-8?B?WFh5SkpSeFk5Uk9iVzZUK0VVUUwzdzd1V1dwWC83M0FVN3I4M3BLNWJhUHQ5?=
 =?utf-8?B?cVJPTGkzQmhEdEZVRFpnUGdQQVlrOFM0QVhCeGVQUDRlQndTR3V1eTMzbjFT?=
 =?utf-8?B?WDZycjMyL2kzaTdGL04xMUJ2SFNDT1hpcW5MMGw5SVhiVEFtd0V5OWlVVjg5?=
 =?utf-8?B?Q2RkYWxYNGk3Z0dyVkJjdHpWeFlpTktxUlFCM00yUXJkTXFReWxnNDh1NXVy?=
 =?utf-8?B?ZzFWVmZuNExYR3J2bUlKUVdNSEt2SWJTZm1TbnlkYUdWRXZXcmlBaVhPMDhs?=
 =?utf-8?B?SU5LbnNOT2lJTWNBbjd5eFpYWXU4M245alZmKzJCcEo3aGczSUg4RStqbjZ3?=
 =?utf-8?B?b0dnZW96dnV3RHVIWmx2S3h2VXZHd29MMTdHdjB6QlNtS2J1TjRQMHJRU1Ru?=
 =?utf-8?B?SitkcGZCOG85cFlmQlM5RXdNMkNHSDVxQW5RdkdKR080RWR1OEtsN2h4QndS?=
 =?utf-8?B?UGo0ZVU2VUo1NVl6YkdLQzVNZVdScDMxeW1yUlFBenlCT3NEeU1QTFg3M2Yv?=
 =?utf-8?B?U1RJbm9NYjY0U3Y1S2hBdUpnSGdNY2FyRnVoVUo2a2M0MXFNdFg2U2hCeWRY?=
 =?utf-8?B?bFdzZkFKSFZjR0JCODdLQUZmK3RSVmp1TDVxaElMblVOSENlVlMvUk5IazN1?=
 =?utf-8?B?eDF5WTVvZmVWKzlNVXREWVA5RGhETnBYYmxyNklveWRjRjcwWUZNOFM4YnNV?=
 =?utf-8?B?NnBneXJYM2tJRlVhOGdXT0tDSGM2RENNNWRrVWU0bEhhTWFDTEpJelBwaTlK?=
 =?utf-8?B?TThXdm5kTEpWRzE3RFRscWdkdzdPRkdDU0RPR1lvd0lqK2NveVJzcHlrcEZM?=
 =?utf-8?B?OXNMdVFvUU9EUlBseFMzUUw0Mk94dVhJcE1RWUlMR0lCYUl5dTcxMXlXVWtI?=
 =?utf-8?B?QUt6SExKa0JEM2hDZDBseituQVFJVWRjVkJYclBqVjA3eEZyaHVlOXJTcStY?=
 =?utf-8?B?bk5rNm01bjJxR3l2RENuQWk1YjBtQVh5QTFpTXVPeWVCbHhqMzRndUY1dVU0?=
 =?utf-8?B?dmdOWXZ3MDB3WnFZTlc4YjZYaU1jWlYvUkdScDlLNnVOT3VwNXd1SFY5anFr?=
 =?utf-8?B?QnhiUFFJSWx3U1g0UHc5L3ZhbW9BUTh1SEZjTllmNUZhcE9rNnBKUUE5eUNx?=
 =?utf-8?B?OHdHY0h2VmZkUlhMajlkcWxWNkRPUzRPNmd6VXgzQVFkZmRCZTR0M1BtUFc2?=
 =?utf-8?B?cmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10566c42-c1e2-4276-b320-08da5cc3c7d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2022 07:15:16.6886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SMqQNoFbC/DHgp5hyz53llZIwJ0402E08hEBiZL+mcmIBlP7/PsOXfvNjtYAoiH6DxgfXYXzSwm4WvqBeemUn6+HBRWI8CmWcCLqeN/xadY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6624
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYyBhbmQgVXdlLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggNi82XSBjYW46IHNqYTEw
MDA6IEFkZCBzdXBwb3J0IGZvciBSWi9OMSBTSkExMDAwIENBTg0KPiBDb250cm9sbGVyDQo+IA0K
PiBPbiAwMi4wNy4yMDIyIDE1OjAxOjMwLCBCaWp1IERhcyB3cm90ZToNCj4gPiBUaGUgU0pBMTAw
MCBDQU4gY29udHJvbGxlciBvbiBSWi9OMSBTb0MgaGFzIHNvbWUgZGlmZmVyZW5jZXMgY29tcGFy
ZWQNCj4gPiB0byBvdGhlcnMgbGlrZSBpdCBoYXMgbm8gY2xvY2sgZGl2aWRlciByZWdpc3RlciAo
Q0RSKSBzdXBwb3J0IGFuZCBpdA0KPiA+IGhhcyBubyBIVyBsb29wYmFjayhIVyBkb2Vzbid0IHNl
ZSB0eCBtZXNzYWdlcyBvbiByeCkuDQo+ID4NCj4gPiBUaGlzIHBhdGNoIGFkZHMgc3VwcG9ydCBm
b3IgUlovTjEgU0pBMTAwMCBDQU4gQ29udHJvbGxlci4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJp
dmVycy9uZXQvY2FuL3NqYTEwMDAvc2phMTAwMF9wbGF0Zm9ybS5jIHwgMzQNCj4gPiArKysrKysr
KysrKysrKysrKystLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCA1
IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9zamEx
MDAwL3NqYTEwMDBfcGxhdGZvcm0uYw0KPiA+IGIvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2ph
MTAwMF9wbGF0Zm9ybS5jDQo+ID4gaW5kZXggNWYzZDM2MmUwZGE1Li44ZTYzYWY3NmEwMTMgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2phMTAwMF9wbGF0Zm9ybS5j
DQo+ID4gKysrIGIvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2phMTAwMF9wbGF0Zm9ybS5jDQo+
IFsuLi5dDQo+ID4gQEAgLTI2Miw2ICsyNzYsMTYgQEAgc3RhdGljIGludCBzcF9wcm9iZShzdHJ1
Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiA+ICAJcHJpdi0+cmVnX2Jhc2UgPSBhZGRyOw0K
PiA+DQo+ID4gIAlpZiAob2YpIHsNCj4gPiArCQljbGsgPSBkZXZtX2Nsa19nZXRfb3B0aW9uYWwo
JnBkZXYtPmRldiwgImNhbl9jbGsiKTsNCj4gPiArCQlpZiAoSVNfRVJSKGNsaykpDQo+ID4gKwkJ
CXJldHVybiBkZXZfZXJyX3Byb2JlKCZwZGV2LT5kZXYsIFBUUl9FUlIoY2xrKSwgIm5vIENBTg0K
PiBjbGsiKTsNCj4gPiArDQo+ID4gKwkJaWYgKGNsaykgew0KPiA+ICsJCQlwcml2LT5jYW4uY2xv
Y2suZnJlcSAgPSBjbGtfZ2V0X3JhdGUoY2xrKSAvIDI7DQo+ID4gKwkJCWlmICghcHJpdi0+Y2Fu
LmNsb2NrLmZyZXEpDQo+ID4gKwkJCQlyZXR1cm4gZGV2X2Vycl9wcm9iZSgmcGRldi0+ZGV2LCAt
RUlOVkFMLCAiWmVybw0KPiBDQU4gY2xrIHJhdGUiKTsNCj4gPiArCQl9DQo+IA0KPiBUaGVyZSdz
IG5vIGNsa19wcmVwYXJlX2VuYWJsZSBpbiB0aGUgZHJpdmVyLiBZb3UgbWlnaHQgZ28gdGhlIHF1
aWNrIGFuZA0KPiBkaXJ0eSB3YXkgYW4gZW5hYmxlIHRoZSBjbG9jayByaWdodCBoZXJlLiBJSVJD
IHRoZXJlJ3MgYSBuZXcgY29udmVuaWVuY2UNCj4gZnVuY3Rpb24gdG8gZ2V0IGFuZCBlbmFibGUg
YSBjbG9jaywgbWFuYWdlZCBiZWkgZGV2bS4gVXdlIChDYydlZCkgY2FuDQo+IHBvaW50IHlvdSBp
biB0aGUgcmlnaHQgZGlyZWN0aW9uLg0KDQogKyBjbGsNCg0KQXMgcGVyIHRoZSBwYXRjaCBoaXN0
b3J5IGRldm0gdmVyc2lvbiBmb3IgY2xrX3ByZXBhcmVfZW5hYmxlIGlzIHJlamVjdGVkWzFdLCBz
byB0aGUgaW5kaXZpZHVhbCBkcml2ZXJzIGltcGxlbWVudGVkIHRoZSBzYW1lIHVzaW5nIGRldm1f
YWRkX2FjdGlvbl9vcl9yZXNldCBbMl0uDQpTbyBzaGFsbCBJIGltcGxlbWVudCBkZXZtIHZlcnNp
b24gaGVyZSBhcyB3ZWxsPw0KDQpbMV1odHRwczovL2xrbWwuaXUuZWR1L2h5cGVybWFpbC9saW51
eC9rZXJuZWwvMjEwMy4xLzAxNTU2Lmh0bWwNCg0KWzJdIGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4u
Y29tL2xpbnV4L3Y1LjE5LXJjNC9zb3VyY2UvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9z
dG1tYWMvZHdtYWMtbWVzb244Yi5jI0wyNjYNCg0KQ2hlZXJzLA0KQmlqdQ0K
