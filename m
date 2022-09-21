Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4D35E55C9
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 00:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiIUWAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 18:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiIUWAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 18:00:03 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2117.outbound.protection.outlook.com [40.107.105.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CE660689
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:59:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZW8VMv0z+1TScZG1ygVH7hMWTu1V7YOiBAaIt58bS5IFGASSkYsmSNyrC8JJdFaS4nhD+DYos/HO354XOuvtqTsjuWYGpp9TA5CBRClbGSYIVrYOhzCDstcZrjBpC8IPPsJ83/AISMOGsVB4KgSzAq/2C+mnFXc4Qo76TRZsP8t/d0JcN4tPogP9s+hOhThkeCH4rn4TPfHntWwm2p2/I9mfwaShexFeKNFte00S7QFrAJ6ebbedx6Ty+TRJWPJRJO171E+wbxJsTKo3ibYINGIAKZMIYeNAAlnA7RTPBaj/iTcWfqNtIt98pgwAdj0JJeF5jkyEBmOzmQkeKTa5qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUAyGUnuHGhlhA7kXIAdOY4EnVt22NXtGdM9hA10IKo=;
 b=CasFq4qdcQzdaVbVQcvmoFCWt16X7HYgtcm6sFkvBLEkQYrajMeo5gHsa44hadXdLYyedSkw8F7ck7QSJGRXZ0MrqLjsGESNSMGR6CF4ltLtFnGgvtrlqtZg/+PhwJOuVb/3viCCQEh78f9FCD1aqlDjcSo8Mf8wnhVnazdM7uGt+UdXoYWj0hsTQUvh2+JjaB6HQncn7UztcqOGrvmDXuk6dko4Fej3rtSkJfqMrapeLcovKK1J9sRewhkYc5HDKrh8/Ojd0QM9MDcNb6ZHaUWRf+/59bY4OOLj1+h1KTYgt7TPVD/0Mso8AKzim0t3+af+qG0Pxviu++hfx3ohJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUAyGUnuHGhlhA7kXIAdOY4EnVt22NXtGdM9hA10IKo=;
 b=hsBCM0i5BVh7OUszCqeCUovFfF3PnWRdsD1BPBXg6yoAscK5+NAGCqMln0H6umklYIwpRBVvh0nffKbU77hi/5O4a7EvWuYJk4EdlCo4AO3tcS0odse5ufqkr4fUYoHV/s9GmWIKITW/Wg8lwYGAfM4ELSbceNPlMgkIpSa+ZK0=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PAVPR03MB9773.eurprd03.prod.outlook.com (2603:10a6:102:314::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 21:59:56 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5654.016; Wed, 21 Sep 2022
 21:59:56 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Yang Yingliang <yangyingliang@huawei.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        "sean.wang@mediatek.com" <sean.wang@mediatek.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "clement.leger@bootlin.com" <clement.leger@bootlin.com>,
        "george.mccollister@gmail.com" <george.mccollister@gmail.com>
Subject: Re: [PATCH net-next 14/18] net: dsa: realtek: remove unnecessary
 set_drvdata()
Thread-Topic: [PATCH net-next 14/18] net: dsa: realtek: remove unnecessary
 set_drvdata()
Thread-Index: AQHYzgV8nIumYk/lkk2ErEtF1zoYjw==
Date:   Wed, 21 Sep 2022 21:59:56 +0000
Message-ID: <20220921215955.6ctuk4yyagog4n4o@bang-olufsen.dk>
References: <20220921140524.3831101-1-yangyingliang@huawei.com>
 <20220921140524.3831101-15-yangyingliang@huawei.com>
In-Reply-To: <20220921140524.3831101-15-yangyingliang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|PAVPR03MB9773:EE_
x-ms-office365-filtering-correlation-id: d8463198-5e1d-4d87-9d31-08da9c1c9ed8
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: neFvrgwpIIIfVv+mosLR5fOhOFDFDTST/OQZ3IYLKQysCKJNtb27qNGILjxTxjv6hya1meT5sFhtP69Qd/PnJi0MviLrOZy+mh8dc/Qk6YdZJd/OktFdFDmoOJ49Em06XAwjCvC/y1uZJ95EvZmEe5vSH9smPnG6vZQsQuECY4bmdm5qLPIrmC4f3StIFTDou9GJRaLA0UAlJ9/9xaTVEsj0Jtt0+I+a0ul1aWzgJLmadI5E6OP41dKRJxy8Od4tMxDpfKs06u2pOjWZ0fxuWnEAJWX4UAj7qdFXAX0syXdESt0pQj4mDr5iJS+w8hX8GFlsv8NGF3/qmvnsCqMtO3BAW/sPovAFcz4s/YzOPISMBD6fD+SeN1m6r9Ewq6BMFkVt9Om9CWOBqonS8QQ0n4c4VcXZkoGIRWY4/j3EhJ8Itn6tcpmuFXZcrGDlLuSLMoNuof8i03GzZQXmAKvKb+73RgocwpWoQ4zKrjwVG7aEMAYNAJWbo+MyqELc+4MCB/xj46qx6MCmg1U1nGg4rYPVB7MHBcw2WePHB/QD+sNMra2gCDvsd0OYDflR9TRQqr8bmLqbvfYX6UmeMr5zMJTUe0/Y4A1294C7UrL/srBSHNQ//kw4hzd/+nGaEY1znd2cLUUHK79hx+t+7e2QS3wKEG6kRB90F/DkzsMIJXIKT4kQmFvkRmtfwGDgzPRDW3bFf6xZHTXCHxjXKTjk1HVpun/Cn821B4PwPZ8E+QtKon2yT8WAyoSFXV6WkD+8P/KVy+vcxkCObmOnUkuW9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199015)(2906002)(54906003)(2616005)(38070700005)(66446008)(41300700001)(66556008)(85202003)(8676002)(76116006)(91956017)(4326008)(6506007)(66946007)(66476007)(83380400001)(36756003)(316002)(6916009)(64756008)(71200400001)(6486002)(1076003)(85182001)(86362001)(186003)(5660300002)(478600001)(7416002)(8976002)(8936002)(6512007)(26005)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MzhwcmFBclV5cFJWR2RiSUZqNFhhdVdTVElsbUhNdVhpZzNNcVJIbnJvMVVT?=
 =?utf-8?B?eDI5Unhaa3pPYWcwTjVBaDJrWlNpUUFHSW1EQ2lIR1Y5U0ttaHVOTThlR0dT?=
 =?utf-8?B?c2VOalZBL1lob1crN0FIT0lDeUF6YzhnbWRWNHdwdWlNRHBPY2FZR09qcmk5?=
 =?utf-8?B?STNLSmZKK01xNitXNHpycDNUZlpYakY3SXdZQjJvQThvc2tUOFlLM1h5SFFi?=
 =?utf-8?B?UmFSZ3FsNnprbnl3YmgvRmkrbUZDU08yQU1sdFBIaTlXZ0d3VzIrVkRxbEJN?=
 =?utf-8?B?dFpKemFvaksvZTRvclM4UmtkdjZXcktZaXlRQlpwa1FKRzFRdUtQbGhpVGl3?=
 =?utf-8?B?cDhYMHFSZG5JYit3SzA1TnFmVy8wQkRzaHp5WDJlNmNQRzdFMFhDT25OV25N?=
 =?utf-8?B?ZW9YVW5YK2o0V2Rmazk5UXpuY2preG5zZHF1M0JoblBTa1RVNzRmeWltZkhv?=
 =?utf-8?B?eGN5dldOWkxNMlV4cVRqWTd6Z3N2WS9jSytBRGZRbkI4Sm1IVDZCWFVzNGdw?=
 =?utf-8?B?L2E3TWVjc04xVDUyZjUwYklxTU9mTDNiQmlPanlpWG1vK2RZMm1Jczh1NkZQ?=
 =?utf-8?B?RFp4MnZ1cHRNUXFjRjdQOVdBTUFwVS9ZNkdTc0x0ZFRWcGwwNHduaDBKRnZW?=
 =?utf-8?B?UWdvMjNpSFppVDY2eVRxZW04K3U2Q1ZwRmtUSWx2MFJKTjFPb3pOY3ZvbVFS?=
 =?utf-8?B?c1FPN3dvOVhXZG9TaG81eWs1V3NLcUt1aDVHazJna2tnM3QxaGNsa1h4RERr?=
 =?utf-8?B?b1N1QUtHbDB6MnZXQ0NMcTBZZFd2UUwxa2lrY2gxeWN1VTlralRUcHU5c0lL?=
 =?utf-8?B?WmFuRlZVYUFSbmVmVUtSdm10ZFBRcVNtbWFzWjN2eno5TTFBRlBKeGdtdS9R?=
 =?utf-8?B?ZUEyWFdiYTk4NmVOcGZIMk9vNEZoNCtwdE0rRDM2VVZVV1g0N1RrQWl1WGps?=
 =?utf-8?B?aytmUkFpR0hzYm1vcG9uU1F3blF0SlFtMVZyTzcyb1ZZMTIyRkZGNnVkUFhY?=
 =?utf-8?B?L29OWExUZFJ6OXVCb0lPYm1GOVBaOE1ZdGRra3VGMjhYRGRZYW5sS3I5ekdL?=
 =?utf-8?B?WjZtRnlBMHlsaFE0QWNGUVI2NXMvUmlWdDY0eStNQWE0WEZNUEtFck9HNHlu?=
 =?utf-8?B?a1dUVmUwbkxOak9VNkFjWmxTbG5CNlBJQkxvS3pmSWtEVGJyWWcyN2JMUjNl?=
 =?utf-8?B?RUY4SDhQbFNKeG53TUdYWE5UR0UrejlGTWpkaVhETy9ERXlJRDZOakdyM3Ex?=
 =?utf-8?B?dXdIcXhQcUJZQ2V4dzliT3h3cXRPa2R6SHFtc0lvREtZL05NK005MXFvZzlH?=
 =?utf-8?B?eXZaaTducTRTNHpKMXgycys0Y09CQmIwejdzd3R0anF1QzlrdVFjOFVtdjZl?=
 =?utf-8?B?akY1Vm5yWGxub0ZidU9sYUwyV1ZsUUtvRllRNnVkR0o3bEREZkdQWjZjUlQv?=
 =?utf-8?B?cFNLSy96cjU0bXV5ckNnOVQwUVdGTmpCb0pSZ1g0WSs1ei9yWDhSZzJhREh0?=
 =?utf-8?B?MEhrK09MWW8xZXpoZkxqaDA2Uk40Z0ZWcVlpRU5hSkRwblBtNFNyUlh4R0ZN?=
 =?utf-8?B?WHNjZ3VROGU1YWRxd1RlbVh1NkJsNTdNbEw5UytZVkRhdnJSaEdVQTJudnV5?=
 =?utf-8?B?b3NQaU12N0JTT1VQYUVKRmVRSG5sdjVlZ3FybnJ4d1I2Wkl5ZVBLejNxMlVn?=
 =?utf-8?B?TU9zNS9Zem9ldENEK3BHRG1hSlpQemlRdWpNTDg0R1JkeVJpU3YwaVZrbUE4?=
 =?utf-8?B?d0N4ZmZUckl3Vm5idmJYdUNzUjZpYXF3Qm9GREdQR3ZZV0k1cWoyZlBnaUln?=
 =?utf-8?B?dlJqOEgzd0laVFdyTXBjTVJqYTNSRVYzUGQrOHJ4NE9vS0FhWWJHSzZ3TmRM?=
 =?utf-8?B?c1VzY1A3MEU5WGk4UGhMbDN2c1hpRUMwazJ1YlRXbUNvb0lLTzRXU0ZpT1Vo?=
 =?utf-8?B?NGF4WnBEMEVwYXNoUHEwRHFYcjhWTnhYNXp2ZndEaFlIWnJQWU9kbGVIYUZp?=
 =?utf-8?B?d1BkZG15UHNJRHp1S0ZwYjBsWVIrKzlyTGQ2RHpOZnY3Y3BFQi85ZDJwcklC?=
 =?utf-8?B?d0pWekduQ1FyM1RGZG1zYW50OVlFNVRKeW9xRDZMM1ZMNHZ3Y0o4NkdXcVVL?=
 =?utf-8?Q?UCorm0NIeWwLRCA+9cm6Xt/YE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFCFEA20198B344895F5F52EE7844D57@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8463198-5e1d-4d87-9d31-08da9c1c9ed8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 21:59:56.4047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M4u1wrhgojq7FmqZiLtf5anTJiY9t4yU8RL1Lt/PK0bE9QjOexN5POzZmgoL3E1JgkFhvBWiT0619dSMgibgKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR03MB9773
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgMTA6MDU6MjBQTSArMDgwMCwgWWFuZyBZaW5nbGlhbmcg
d3JvdGU6DQo+IFJlbW92ZSB1bm5lY2Vzc2FyeSBzZXRfZHJ2ZGF0YShOVUxMKSBmdW5jdGlvbiBp
biAtPnJlbW92ZSgpLA0KPiB0aGUgZHJpdmVyX2RhdGEgd2lsbCBiZSBzZXQgdG8gTlVMTCBpbiBk
ZXZpY2VfdW5iaW5kX2NsZWFudXAoKQ0KPiBhZnRlciBjYWxsaW5nIC0+cmVtb3ZlKCkuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBZYW5nIFlpbmdsaWFuZyA8eWFuZ3lpbmdsaWFuZ0BodWF3ZWkuY29t
Pg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWstbWRpby5jIHwgMiAt
LQ0KPiAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1zbWkuYyAgfCAyIC0tDQo+ICAy
IGZpbGVzIGNoYW5nZWQsIDQgZGVsZXRpb25zKC0pDQoNCkFja2VkLWJ5OiBBbHZpbiDFoGlwcmFn
YSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQoNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9kc2EvcmVhbHRlay9yZWFsdGVrLW1kaW8uYyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3Jl
YWx0ZWstbWRpby5jDQo+IGluZGV4IGM1OGY0OWQ1NThkMi4uM2U1NGZhYzVmOTAyIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLW1kaW8uYw0KPiArKysgYi9k
cml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLW1kaW8uYw0KPiBAQCAtMjQ1LDggKzI0NSw2
IEBAIHN0YXRpYyB2b2lkIHJlYWx0ZWtfbWRpb19yZW1vdmUoc3RydWN0IG1kaW9fZGV2aWNlICpt
ZGlvZGV2KQ0KPiAgCS8qIGxlYXZlIHRoZSBkZXZpY2UgcmVzZXQgYXNzZXJ0ZWQgKi8NCj4gIAlp
ZiAocHJpdi0+cmVzZXQpDQo+ICAJCWdwaW9kX3NldF92YWx1ZShwcml2LT5yZXNldCwgMSk7DQo+
IC0NCj4gLQlkZXZfc2V0X2RydmRhdGEoJm1kaW9kZXYtPmRldiwgTlVMTCk7DQo+ICB9DQo+ICAN
Cj4gIHN0YXRpYyB2b2lkIHJlYWx0ZWtfbWRpb19zaHV0ZG93bihzdHJ1Y3QgbWRpb19kZXZpY2Ug
Km1kaW9kZXYpDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVr
LXNtaS5jIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1zbWkuYw0KPiBpbmRleCA0
NTk5MmY3OWVjOGQuLjFiNDQ3ZDk2YjljNCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNh
L3JlYWx0ZWsvcmVhbHRlay1zbWkuYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9y
ZWFsdGVrLXNtaS5jDQo+IEBAIC01MjIsOCArNTIyLDYgQEAgc3RhdGljIGludCByZWFsdGVrX3Nt
aV9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIAlpZiAocHJpdi0+cmVz
ZXQpDQo+ICAJCWdwaW9kX3NldF92YWx1ZShwcml2LT5yZXNldCwgMSk7DQo+ICANCj4gLQlwbGF0
Zm9ybV9zZXRfZHJ2ZGF0YShwZGV2LCBOVUxMKTsNCj4gLQ0KPiAgCXJldHVybiAwOw0KPiAgfQ0K
PiAgDQo+IC0tIA0KPiAyLjI1LjENCj4=
