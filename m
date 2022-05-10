Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8001A5221AB
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245312AbiEJQxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244940AbiEJQxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:53:16 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80094.outbound.protection.outlook.com [40.107.8.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F2B293B5A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 09:49:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEPoaRoZuNysqTYKAmOMLUDi5KNGj36IqXSCvs6bGElpXZSY7oE3x7+JkuyzPjpTQrvfVYgjY65A6Aoahj6r52NTTBekbm6IsHOTBZ4E4OvHdVL6N0tNPjympBtYefOVOFMoM0v2L1quDsiUgb2W/e8yuYEoEeHA94zypQ9vD15dnBcKZp/Uhz7wnOO5/COLDSdVV61dR6axyxA2/TRLltVFUi+HCXMG7tPR05E9IpDPEL3dKnm1yuZLnIapOriT7taCvkvo4Yf/dwirR0kYsh8k5vEP9KniXhS7q5Y8BcZIf5XgYa1ccPJUMQwp8jczQmdmDzF5muaYRilb20DvhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DVU+Cb0zgM9h8A+kdfj7GaS1prm4IqiVGCvPGNEhD3g=;
 b=jfxz7y+caXvrgMp3ZuKDiXyAiJ4lJdd32tBy+AcDzeJKXLIKmRVOLLGwYyE8Z5yOAtXo8tgmW+vt66j6MbyIe1vUYq3QFSX4KZ2uXFv4M5Jvg+YHSUp46xHoVSed3bptyEfQBqJqyHfL8Qe82JxbFS0VhXo5zbYLjjgdlx12HQjYanolphwwOs8TBkgQKbPITJosRmOw5n37Cs0NRKMOOdi5a73LEsSpjeE2V6gBSdsPb5+KqQuMvrKh2sQ0uLL1VeYpK00cjNftDoMq2a199qH/YgUr8Sp2XDzz85eKF/bS6EdKzJZPVeP/kvt1dp7HvvFHRhbE2U9c36gv/RfrcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DVU+Cb0zgM9h8A+kdfj7GaS1prm4IqiVGCvPGNEhD3g=;
 b=BK+WNMcylXrQze/9Ug+0kMJlVeqeDAhBN7Dx1dvVK0qWAVKE+grS5UQYNQcQfL+R77wkOoA5A/fQq+mlbFTZCmEoH4c2GAzWaP9HOfT6upQ6SL6VDhDOFcWqdSNoa+FqzJoFL3DspHDPOsq/xUTHhpMNVMKxl8lNEQOrj6Z6Npg=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM4PR0302MB2676.eurprd03.prod.outlook.com (2603:10a6:200:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 16:49:14 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::e5d4:b044:7949:db96]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::e5d4:b044:7949:db96%3]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:49:14 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Hauke Mehrtens <hauke@hauke-m.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 3/4] net: dsa: realtek: rtl8365mb: Add setting MTU
Thread-Topic: [PATCH 3/4] net: dsa: realtek: rtl8365mb: Add setting MTU
Thread-Index: AQHYYy3mP+EB3angdEaWFFual/bKVK0YVWWA
Date:   Tue, 10 May 2022 16:49:14 +0000
Message-ID: <20220510164913.trpkw6yt7rdxqht4@bang-olufsen.dk>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <20220508224848.2384723-4-hauke@hauke-m.de>
In-Reply-To: <20220508224848.2384723-4-hauke@hauke-m.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f5c5b98-b597-4cda-f54a-08da32a50404
x-ms-traffictypediagnostic: AM4PR0302MB2676:EE_
x-microsoft-antispam-prvs: <AM4PR0302MB2676982F73C34A57D6A01DE883C99@AM4PR0302MB2676.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: igWZ0R0K5D0F3Xn0spjpRhUSqHA6H0B2zk0rm3evgynA2ww/0hankUkOove9YWdX+Kw3p3zUIE6ga76C8U5XxZvm6VneOMvXdIpFztaj5vAVonHr73C5RHoHjAjgP97LPvI1LmTQplmE4TPWJxBcGyNBVvwafRJechS/dwnYGgXq5QFYzdGIXk2BKj0d7olQhzUb9A4pUbJCpXebW9RQvFMdBrt8UeeyAzBnINeUDgaxRdv0AQl0XRxliqhj1ydRifw3JJ7jxnj6vOJ4TXGxZYHXwSo7aB44Ulu2taSpFAk2+FEv9bJ2XT7vYE9a1NyfXz2iveXM5sToLiOy5Z4BjE5k476uhS0VoNOeCOWo5O0iYJf6kOJyvfnAX5GMEhpF4D7bLJHtIG1daerVwEb/gMeftyn3YkOC7TY4hduYvE07G3ptVsAapxSdPUnuI2gNjs1BqNYgifN7T+7Ra/f8mvm4E48UU607+ysXdTkz8oX/5TwiL9A6RRxmrqrQ0kYwuobQD7aPS6xclisgRlN+CqQSzpxTaD2wtFLkf5qyZGaGBwEDq4xppvTX9iIqeVWeIIGVveIQM1qmKfuJArzmD5c15XKodv0lhak6HM59zShLA2PmTGljA7l3U7kPdD+tYOkl/3BTnzHeSFiQP0MURQ4xFw38HK/CXK0hpzt4SCKo2Ny8xZ3HtPNDf2W/6kx0WAXfn+qH7MKz8Is7N7SgGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(186003)(38070700005)(5660300002)(1076003)(36756003)(86362001)(66476007)(83380400001)(66556008)(85202003)(76116006)(91956017)(38100700002)(66946007)(316002)(6916009)(122000001)(85182001)(2616005)(64756008)(26005)(6512007)(71200400001)(66446008)(4326008)(8676002)(8976002)(8936002)(6486002)(508600001)(6506007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cE55WXBCY1JtcFRyL1h3MWVPNlFGWkhhbVlXUmhtOXcva1VaenBZRGR2ckdM?=
 =?utf-8?B?bTVwQmdGSldMcm83ZGR6T0FwdzFteCtWLzBaeHBBSTJFNDdPV3dPRy9jejE1?=
 =?utf-8?B?ekNwdzhhT0k0Ky92czRoc3kwM25VUkxvMjY4T0EyOXYyR203TEdkbVNWRFpk?=
 =?utf-8?B?cytySWZnblRxWGJvNFJzNFQzK3Y4MStGQjZldnJXc0ZpZnQ0eWg1NFU5L3N3?=
 =?utf-8?B?L2IwOGM0U0tiV3g5L3Y4WkZBc3M0cC9IUnVJSDlaRld2RU82WTEvRWtaeHRM?=
 =?utf-8?B?TDcxVTF4UHUwTERaSEV3a2tOYW0rZ0pwQWMwVUo5RVZBdlZram4yNUVhMU5m?=
 =?utf-8?B?NGRPRkFzWVpxS09BcnBEUWNIZW1qUnFSaHg0eHlDWkJWLzBRNjB5TG9nTTR2?=
 =?utf-8?B?MkdnVzhuSUUyL1Fyanc4WEJoVDUrV3VCd2U5NDZQTHFUVEF1ZHBwNEI0T2VR?=
 =?utf-8?B?TjJnWmVYRjJuR2JMZGJlbWdsNHdqVVhWR20rNDNGODBHejZ0aitybTZTdnNM?=
 =?utf-8?B?VGJ6ZmhBbzY4VTRGemZRMGhiYzFNa2JZeDhrWVJJcEJ2SklGWEQzUHdEN3Ez?=
 =?utf-8?B?Y2lET09UWVIvYXFFOUpmdDJJOHhITVVxU20xRWJ5T0U4ajduYnErcm0zaDBD?=
 =?utf-8?B?YWY4SHZocENhbGlLOXFMWHpLeGwydGVOSnBCaFJIK1JZdlBHdVV3QWhxcEtU?=
 =?utf-8?B?WGJDMFRJT1piZUFTNkc1Vi9uQncvU3hZS1VMRnYxMFM1NGptZUZhOGR4Z2ZT?=
 =?utf-8?B?U0l3Mjl3ZFQyeWlhcVZKbXlhMUIveXdheHZGYWFhKzRUalVwVGtranBlMFhL?=
 =?utf-8?B?aTJvOGcycVlKSFVWV1JTMGV2Rk03akk1VitqSEFnZXhnTG15WG1CT3BSUzJB?=
 =?utf-8?B?UXo5a09iK1NaS2lyVFpJVFZ6VTNVRGI3TkpPaytXc0t4ZFhGOTJFRVlya3lm?=
 =?utf-8?B?TmNiS2kydy8wTU5QOEUxaTNrWUdtRWNDOUtXZFNZTXhUN2tsQlluOUhFV1M0?=
 =?utf-8?B?Qy9BQS9uVE9ocGgySWdaM25zd0pNY0NNSjZGR2pzV1VHZ2E1Tm9JQmJ2dThG?=
 =?utf-8?B?V0VzbUh6QjhqMFpwdjVkaTNBNzFaT2hjYVlwZWpvcHZmTDg3Y1QrOFNhODNh?=
 =?utf-8?B?WENQdGdVazBMdStJblhrRFdXQjJhV2dRN245a1NIblVBaUYrV05QRHBBOEZ4?=
 =?utf-8?B?eDczVlluL2J4SG5qZk9rRW9Vdzd5bGd5dmVjY1k4Y3dTcXJob21aNVg1Q2pa?=
 =?utf-8?B?OTlCL3Y4L1ZkQ0d1bmEzbUliYjVCK2VUeGs2ZUhiUm1YYVYxMmdDZ2RUQ0lh?=
 =?utf-8?B?dmFZdjNOQk0rZUhHUERTSXV0Z1NPUU1sWUpWTnNYd3FLcDdTam5UVllWN213?=
 =?utf-8?B?WjB6eVBZWklwTUFSSVBzUHdQVVVRNEFlazdpM1FyZzkvWEVjYzlsc3poYXht?=
 =?utf-8?B?TjA3ZWhxejlZNElzK3lYRWRKbk1pcFBXOGprdzN0MEV3M0RwMk1IU0hSTEpM?=
 =?utf-8?B?enBHNFAxVVF6bld1ZlQ1bTZiUE1xZFhvbnBISUk5Z20xU09OQUpaZXp1T1NL?=
 =?utf-8?B?NTJ3YlBqQ2MxOUwyWEdZbW5GZHdpYk8yQmg1UUtzcTBVaHVkV0NXN3llTVAy?=
 =?utf-8?B?WVBwUXBkSzU1RlVoZFlUUDh2Y0VHY0h5ajk0bGtONEw0MzJkeFZOZC9sc0Iv?=
 =?utf-8?B?eXl0NDZvWXlWMVJzTXJ4VmVoR1dvYUVHbFVQTXh5UStjNk5YLy8vY3lOYS9O?=
 =?utf-8?B?ZGlPTUZwRVFkcWs1VjBUTkFGcmdFTDUxN2puQ1ZNUHJjZUYxMkhHVUcvaDYw?=
 =?utf-8?B?M0hiTCtDVVE0Zzh3Y3pkNm5zWTBZODlOenFOUWlaNUQydzRmdTBWb2EzVE1w?=
 =?utf-8?B?Q1N2cEk2VWdZVkYwZ29yNklGaldSc2pMSnJsd0NiVzJNN0NjNFJWU2kwV1hz?=
 =?utf-8?B?NnZKZm5vTFZYZ096UUdXWHpqVVQ3a0ZQd2pkUE1NdDROaTJkV0RpRHBEdnIy?=
 =?utf-8?B?bDJPNE1uVEltYUptbDR2NzlONkJzYjF4RWRSaTZhQ3pMSksvZ0NYM0xvTWJ3?=
 =?utf-8?B?WERYQTZOaFpucDZTVkhPRi9CWThPUnVTYzlWN2FpNUxybldiVGs1ZUdFYk90?=
 =?utf-8?B?dEFxWUpNUENnUTU0N0VFcmRwTGo4emxpVzNtYlc1Y3dieVhLZTQxUW14U3JI?=
 =?utf-8?B?RkRtZFB6UlZocjVoUW1Sem9LRG9WUzFQeFp4L0lvclM5djFSY3FhWm14R29X?=
 =?utf-8?B?bjBPWHZEMWpDOEdxeUcxUFFSOTM5aWpkK01KaEs2ZHFVQmdaUE1meGJ5NFdN?=
 =?utf-8?B?cmI2VkZtYUxBTDFBcTc4aWJzNXVSVVBwdmFJdHFCRzdBY1hJc2Jqak9pSjAx?=
 =?utf-8?Q?2Uk16SXbvWiajLsM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68ACE2BA4D2E164982730E86F4152873@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f5c5b98-b597-4cda-f54a-08da32a50404
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 16:49:14.4616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: blJnvko5VB8g+BXBcA4ijnn8r+UAILue0Q7Qvfr6MjETkXBhZH3Qo49RGlff/i6Er7RYVWaHxEGce2dyOvzdQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0302MB2676
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBNYXkgMDksIDIwMjIgYXQgMTI6NDg6NDdBTSArMDIwMCwgSGF1a2UgTWVocnRlbnMg
d3JvdGU6DQo+IFRoZSBzd2l0Y2ggZG9lcyBub3Qgc3VwcG9ydCBwZXIgcG9ydCBNVFUgc2V0dGlu
ZywgYnV0IG9ubHkgYSBNUlUNCj4gc2V0dGluZy4gSW1wbGVtZW50IHRoaXMgYnkgc2V0dGluZyB0
aGUgTVRVIG9uIHRoZSBDUFUgcG9ydC4NCj4gDQo+IFdpdGhvdXQgdGhpcyBwYXRjaCB0aGUgTVJV
IHdhcyBhbHdheXMgc2V0IHRvIDE1MzYsIG5vdCBpdCBpcyBzZXQgYnkgdGhlDQoNCnMvbm90L25v
dy8NCg0KPiBEU0Egc3Vic3lzdGVtIGFuZCB0aGUgdXNlciBzY2FuIGNoYW5nZSBpdC4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IEhhdWtlIE1laHJ0ZW5zIDxoYXVrZUBoYXVrZS1tLmRlPg0KPiAtLS0N
Cj4gIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIHwgNDMgKysrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzNiBpbnNlcnRpb25zKCspLCA3
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVr
L3J0bDgzNjVtYi5jIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1iLmMNCj4gaW5k
ZXggYmU2NGNmZGVjY2M3Li5mOWI2OTAyNTExNTUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0
L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVr
L3J0bDgzNjVtYi5jDQo+IEBAIC0xMTMyLDYgKzExMzIsMzggQEAgc3RhdGljIGludCBydGw4MzY1
bWJfcG9ydF9zZXRfaXNvbGF0aW9uKHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYsIGludCBwb3J0
LA0KPiAgCXJldHVybiByZWdtYXBfd3JpdGUocHJpdi0+bWFwLCBSVEw4MzY1TUJfUE9SVF9JU09M
QVRJT05fUkVHKHBvcnQpLCBtYXNrKTsNCj4gIH0NCj4gIA0KPiArc3RhdGljIGludCBydGw4MzY1
bWJfcG9ydF9jaGFuZ2VfbXR1KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+ICsJ
CQkJICAgICBpbnQgbmV3X210dSkNCj4gK3sNCj4gKwlzdHJ1Y3QgZHNhX3BvcnQgKmRwID0gZHNh
X3RvX3BvcnQoZHMsIHBvcnQpOw0KPiArCXN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYgPSBkcy0+
cHJpdjsNCj4gKwlpbnQgbGVuZ3RoOw0KPiArDQo+ICsJLyogV2hlbiBhIG5ldyBNVFUgaXMgc2V0
LCBEU0EgYWx3YXlzIHNldCB0aGUgQ1BVIHBvcnQncyBNVFUgdG8gdGhlDQoNCnMvc2V0L3NldHMv
DQoNCj4gKwkgKiBsYXJnZXN0IE1UVSBvZiB0aGUgc2xhdmUgcG9ydHMuIEJlY2F1c2UgdGhlIHN3
aXRjaCBvbmx5IGhhcyBhIGdsb2JhbA0KPiArCSAqIFJYIGxlbmd0aCByZWdpc3Rlciwgb25seSBh
bGxvd2luZyBDUFUgcG9ydCBoZXJlIGlzIGVub3VnaC4NCj4gKwkgKi8NCj4gKwlpZiAoIWRzYV9p
c19jcHVfcG9ydChkcywgcG9ydCkpDQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICsJbGVuZ3RoID0g
bmV3X210dSArIEVUSF9ITEVOICsgRVRIX0ZDU19MRU47DQo+ICsJbGVuZ3RoICs9IGRwLT50YWdf
b3BzLT5uZWVkZWRfaGVhZHJvb207DQo+ICsJbGVuZ3RoICs9IGRwLT50YWdfb3BzLT5uZWVkZWRf
dGFpbHJvb207DQo+ICsNCj4gKwlpZiAobGVuZ3RoID4gUlRMODM2NU1CX0NGRzBfTUFYX0xFTl9N
QVNLKQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKw0KPiArCXJldHVybiByZWdtYXBfdXBkYXRl
X2JpdHMocHJpdi0+bWFwLCBSVEw4MzY1TUJfQ0ZHMF9NQVhfTEVOX1JFRywNCj4gKwkJCQkgIFJU
TDgzNjVNQl9DRkcwX01BWF9MRU5fTUFTSywNCj4gKwkJCQkgIEZJRUxEX1BSRVAoUlRMODM2NU1C
X0NGRzBfTUFYX0xFTl9NQVNLLA0KPiArCQkJCQkgICAgIGxlbmd0aCkpOw0KPiArfQ0KPiArDQo+
ICtzdGF0aWMgaW50IHJ0bDgzNjVtYl9wb3J0X21heF9tdHUoc3RydWN0IGRzYV9zd2l0Y2ggKmRz
LCBpbnQgcG9ydCkNCj4gK3sNCj4gKwlyZXR1cm4gUlRMODM2NU1CX0NGRzBfTUFYX0xFTl9NQVNL
IC0gRVRIX0hMRU4gLSBFVEhfRkNTX0xFTiAtIDg7DQoNCklzIHRoaXMgOCBiZWNhdXNlIG9mIHRo
ZSBSZWFsdGVrIENQVSB0YWcgbGVuZ3RoPyBMdWl6IGFuZCBBbmRyZXcgaGFkIHNvbWUgZ29vZA0K
Y29tbWVudHMgcmVnYXJkaW5nIHRoaXMuIE90aGVyd2lzZSBJIHRoaW5rIHRoZSBwYXRjaCBpcyBP
Sy4NCg0KPiArfQ0KPiArDQo+ICBzdGF0aWMgaW50IHJ0bDgzNjVtYl9taWJfY291bnRlcl9yZWFk
KHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYsIGludCBwb3J0LA0KPiAgCQkJCSAgICAgIHUzMiBv
ZmZzZXQsIHUzMiBsZW5ndGgsIHU2NCAqbWlidmFsdWUpDQo+ICB7DQo+IEBAIC0xOTI4LDEzICsx
OTYwLDYgQEAgc3RhdGljIGludCBydGw4MzY1bWJfc2V0dXAoc3RydWN0IGRzYV9zd2l0Y2ggKmRz
KQ0KPiAgCQlwLT5pbmRleCA9IGk7DQo+ICAJfQ0KPiAgDQo+IC0JLyogU2V0IG1heGltdW0gcGFj
a2V0IGxlbmd0aCB0byAxNTM2IGJ5dGVzICovDQo+IC0JcmV0ID0gcmVnbWFwX3VwZGF0ZV9iaXRz
KHByaXYtPm1hcCwgUlRMODM2NU1CX0NGRzBfTUFYX0xFTl9SRUcsDQo+IC0JCQkJIFJUTDgzNjVN
Ql9DRkcwX01BWF9MRU5fTUFTSywNCj4gLQkJCQkgRklFTERfUFJFUChSVEw4MzY1TUJfQ0ZHMF9N
QVhfTEVOX01BU0ssIDE1MzYpKTsNCj4gLQlpZiAocmV0KQ0KPiAtCQlnb3RvIG91dF90ZWFyZG93
bl9pcnE7DQo+IC0NCj4gIAlpZiAocHJpdi0+c2V0dXBfaW50ZXJmYWNlKSB7DQo+ICAJCXJldCA9
IHByaXYtPnNldHVwX2ludGVyZmFjZShkcyk7DQo+ICAJCWlmIChyZXQpIHsNCj4gQEAgLTIwODAs
NiArMjEwNSw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHNhX3N3aXRjaF9vcHMgcnRsODM2NW1i
X3N3aXRjaF9vcHNfc21pID0gew0KPiAgCS5waHlsaW5rX21hY19saW5rX2Rvd24gPSBydGw4MzY1
bWJfcGh5bGlua19tYWNfbGlua19kb3duLA0KPiAgCS5waHlsaW5rX21hY19saW5rX3VwID0gcnRs
ODM2NW1iX3BoeWxpbmtfbWFjX2xpbmtfdXAsDQo+ICAJLnBvcnRfc3RwX3N0YXRlX3NldCA9IHJ0
bDgzNjVtYl9wb3J0X3N0cF9zdGF0ZV9zZXQsDQo+ICsJLnBvcnRfY2hhbmdlX210dSA9IHJ0bDgz
NjVtYl9wb3J0X2NoYW5nZV9tdHUsDQo+ICsJLnBvcnRfbWF4X210dSA9IHJ0bDgzNjVtYl9wb3J0
X21heF9tdHUsDQo+ICAJLmdldF9zdHJpbmdzID0gcnRsODM2NW1iX2dldF9zdHJpbmdzLA0KPiAg
CS5nZXRfZXRodG9vbF9zdGF0cyA9IHJ0bDgzNjVtYl9nZXRfZXRodG9vbF9zdGF0cywNCj4gIAku
Z2V0X3NzZXRfY291bnQgPSBydGw4MzY1bWJfZ2V0X3NzZXRfY291bnQsDQo+IEBAIC0yMTAxLDYg
KzIxMjgsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGRzYV9zd2l0Y2hfb3BzIHJ0bDgzNjVtYl9z
d2l0Y2hfb3BzX21kaW8gPSB7DQo+ICAJLnBoeV9yZWFkID0gcnRsODM2NW1iX2RzYV9waHlfcmVh
ZCwNCj4gIAkucGh5X3dyaXRlID0gcnRsODM2NW1iX2RzYV9waHlfd3JpdGUsDQo+ICAJLnBvcnRf
c3RwX3N0YXRlX3NldCA9IHJ0bDgzNjVtYl9wb3J0X3N0cF9zdGF0ZV9zZXQsDQo+ICsJLnBvcnRf
Y2hhbmdlX210dSA9IHJ0bDgzNjVtYl9wb3J0X2NoYW5nZV9tdHUsDQo+ICsJLnBvcnRfbWF4X210
dSA9IHJ0bDgzNjVtYl9wb3J0X21heF9tdHUsDQo+ICAJLmdldF9zdHJpbmdzID0gcnRsODM2NW1i
X2dldF9zdHJpbmdzLA0KPiAgCS5nZXRfZXRodG9vbF9zdGF0cyA9IHJ0bDgzNjVtYl9nZXRfZXRo
dG9vbF9zdGF0cywNCj4gIAkuZ2V0X3NzZXRfY291bnQgPSBydGw4MzY1bWJfZ2V0X3NzZXRfY291
bnQsDQo+IC0tIA0KPiAyLjMwLjINCj4=
