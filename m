Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA603C80A7
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238597AbhGNIvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:51:12 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.32]:57943 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238432AbhGNIvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 04:51:12 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-ve1eur03lp2055.outbound.protection.outlook.com [104.47.9.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0FDA14C006C;
        Wed, 14 Jul 2021 08:48:19 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhRMAFJQyaJaxe9M2rqY1o+DhTrdMEcJi6Wz5jucjOzFPnLAikksx58zMuuKVlsgG3r/njVDdS/7Rofb82UlzO8pPjApPeuuiNmH+khzBLIADW9LS07q7uH+ekCWGzahjtHp1GYDoWes3nlN+j2jEagfeltv/utBNutJQs/H9/CEPGCWuIC6rN/ulFwj+vQNZdUbfTCaKLaa5r9/QLTvEGyqTfmoFQtLKYNpBxn0bWggo/kq8G9R/sg5DcOedNBRWCgqo2X6m9wQLsz6pmXe1YxieVDcJF2TzS5+rTPUdMqGDSoyP/JbU8fKv2nCX/0krpmg4+TeUMEazn5GCkMC0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LTYWrPLkgykqsfj5P+SIK9h5UZRQ1muTiiIad6iH7Y=;
 b=SdO8dy+/aHG6V7Hn7nvGIc3CduTjqfym1Hd9unVa65IrvFcn5loOBwVF9NtSoJ/ct76PviPrNZIvbprJnmzoOGaWdRu0Vmxf7q6Xm0yMM/+rXSUsWF84jw1UEIuC3xwPkfj/x63t3SHSQLIZyRmrNYVRe9dMwXLsbpqHOZtq1WYKSGSQCcoJTBI0C2ey/nx/ixwPPpCOZkHX9tY9/+RP9AqrRvjA+ZmznOO/YKiJwmYbjAee43EHTfznVkEEMtX8brDzU57bIzGwCNMjAWfH8kOe5mkZ/PrPZhGUKucltvJsNG2SB4mNewnmSykV5A+JDQqcs2sVvw4Rf3OhinIa1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LTYWrPLkgykqsfj5P+SIK9h5UZRQ1muTiiIad6iH7Y=;
 b=BhRGARLcCFumvztfZMYnpP6GwxDvmHuGnwJVGzyefMMJJ8Rq/x5q0wipNKOr5sug0lpJl004RInpoQ+6BsylzyfwexwQIYmtcYJxmfSNI4Umh8OvaDjq8QeLb4wXW31UBBinNkRwzK1xNIyTPM6hZYY+idJ+s8ZZ9j6MZErQzNU=
Received: from PR3PR08MB5801.eurprd08.prod.outlook.com (2603:10a6:102:81::20)
 by PA4PR08MB6016.eurprd08.prod.outlook.com (2603:10a6:102:e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Wed, 14 Jul
 2021 08:48:17 +0000
Received: from PR3PR08MB5801.eurprd08.prod.outlook.com
 ([fe80::7d50:aa90:37a5:b185]) by PR3PR08MB5801.eurprd08.prod.outlook.com
 ([fe80::7d50:aa90:37a5:b185%5]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 08:48:17 +0000
From:   Lahav Daniel Schlesinger <lschlesinger@drivenets.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>
Subject: Re: Patch to fix 'ip' utility recvmsg with ancillary data
Thread-Topic: Patch to fix 'ip' utility recvmsg with ancillary data
Thread-Index: AQHXd750L39HqJKjSEyfrrg3LyotH6tBGUKAgAERO4A=
Date:   Wed, 14 Jul 2021 08:48:17 +0000
Message-ID: <D2E7CEEB-B195-4A02-8D09-6595D74A5812@drivenets.com>
References: <0644F993-A061-4133-B3AD-E7BEB129EFDD@drivenets.com>
 <8e3cbedf-0ac8-8599-f713-294733301680@gmail.com>
In-Reply-To: <8e3cbedf-0ac8-8599-f713-294733301680@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=drivenets.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc77e0c0-e0c5-44d9-fb92-08d946a42021
x-ms-traffictypediagnostic: PA4PR08MB6016:
x-microsoft-antispam-prvs: <PA4PR08MB601639F6966179CA23E92E5DCC139@PA4PR08MB6016.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XirYutatYm1aJToP4sz5fKxmHuCeOetVDuGqGehUTNFFycg6H7ckmCfCLCNESv16qsCjvQddDccTAg282cR7uiUkiw81PLdGkWd+95iSJ6m/O0XZ+QcCQHa/jgSEIP68xCf/XPbUtZMqDgsTbfyP0rhPsdaqq+GxNf9cazR5z04BKzRxYRG5noG7vPYvMWcS14OPbHXyoEW0wgwiKljMLoBSRRZmn6irxh92c9MIQXAfSgYIG7vz575B+G06Qri2N5vwybcROAgb6H7TxBnVRwx9ztHlzdSj5NbEjB5ZoMh+cqzzAwwmLuZvAtpr653zMLxMfmHIAmU8zZVHk6+Rwr+Wn9F/JMQmNh4WwWYq1u2zGspFPqwSdt/M0hzxA4FL3yErUv60LQI9zTSZgeJ4GhlEor4D1m2Y/m+H6L52ijmYrrd2/dRcaW2LcnwJXHGKET7MBDPmUJfw7iMVedH0gXUwGLgf4nnyEKnXvEO3MqfqWUJqKxBtuNoYVqMyyVeqMke8i7Jg5rK+BPRw4rvdurH2QUkhGlLeob51Zsx9l1+aoR2+6X1G3B6lNbADAhc89+Wf7QSJaoLD3To2X0b4HLtykaUfG86VUwVTFsyw408QZimO3tr/N7Ht5QSKSnA1RuEB1rYVQmvj4F3stFmv15hn0TQpYqreDkjFT2NqNeLBpNKyOBGNnjvRl7/+3pz3L4EQvLIyI1QhvLd26e8qwQcSlanIBGl9ADAWgpjIrPw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5801.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(376002)(39840400004)(2616005)(8676002)(38100700002)(26005)(54906003)(316002)(66446008)(83380400001)(76116006)(64756008)(66946007)(478600001)(6486002)(66476007)(66556008)(33656002)(86362001)(2906002)(36756003)(53546011)(122000001)(6506007)(6512007)(6916009)(5660300002)(71200400001)(186003)(4326008)(8936002)(45980500001)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjhHaE52NmJFcmsvUFlpNzB2c29ZSjBqbmZWZzlOb0ZrMVA3VmprNFRZYlgz?=
 =?utf-8?B?OHRsQ0V6K0MwWDRmTk0vL210eFZpZlNjdXpUYkp1dWQwcWpjNkN3bVUxOUNH?=
 =?utf-8?B?Q011dE5uVFpXYk5yY0w0TTI2QWdDRE9XNDZyeHVoWS8xYzRLR0g4RjJ5Tm1k?=
 =?utf-8?B?aUR6RlZCcklaS2dhWEN4TmRBSG9jaWZXVGVubUNwOGdSaXFDNDk2NGRjcmNk?=
 =?utf-8?B?RVV1NG1JQVVRVjVtRDg0aUd6UzgxSlBPR0RvNlBiNElBc0FwRlRUUTBqYUZn?=
 =?utf-8?B?bTJHUlN1b3BGMXNGd2tQRDRxeUU3M0tCeUxIcENueHYrdTJwZzFlSWkvV21S?=
 =?utf-8?B?ZnM3LzlaK2dueDIzZy9KL1g3K1ZXU01NK0V3bXJ0TlA0S2M5NG5PVlgzc3oy?=
 =?utf-8?B?TmswdW1xaDlwTG0zSGpTMktVRmJtdUlDVUlEY3RxZDI3MmFrU1hBTkw2WkpZ?=
 =?utf-8?B?dENwTTVUeWpPc2h1bFdtSnd2R0tQYVh3T0lRdXowYjdPSjJUQlFRWHZFZjZO?=
 =?utf-8?B?Z08zZERLbGNPNDJaaHB5L29qTkRWYVIraHE2Vktkak0xcW0xLy96cDIrSmpm?=
 =?utf-8?B?NC9wMUJPblEzdTcrcUUwTWFyRVpEOVducFJsdWJ6eTRDRlppTzBYL05NS1NJ?=
 =?utf-8?B?eEdMY2JmMStGKzFGWGcyMVlLS2thbVk2bTVabEM0REtNU1pycWJIUm9wN0xL?=
 =?utf-8?B?VTBWL2Zlei8zUDRBa2ZiYW50QllUMDcrRWc0N2hBNGF5YXpJTlNJcVlkQTVM?=
 =?utf-8?B?eWNVTEpSK2RNMkhUdktPanNydVNWclQvbUswMEMyYytMNmp0SUN3SVlDK00x?=
 =?utf-8?B?QWRwR1hsMm1kdENMNmJyamZHRFlROXdaNWJocUMvaVhrRGNmbmhhSWhkeUhi?=
 =?utf-8?B?cFVXTU5XMzlrYStESUtUcHUxbXJuUGQwcnlCT1Zlc05HTWFoSGN2MEVpQ0pO?=
 =?utf-8?B?NE5oQk8yY21SK3kxQ3ptWnlham84Z3BVbmRzZ1h3QWZLRFhqNGNFb1RicVFw?=
 =?utf-8?B?dDB3NU9iU3ZvN3FBUDU3dmh3WGxpQjNTK1p5ZDJqSlkrdkxCT2s5RDQ2YlQ0?=
 =?utf-8?B?NkdXaFdrdERBb2t0QW1EbXFscnA2T09QQnJOVDZQNDhPWHNNZ2QyK1lpQWd4?=
 =?utf-8?B?aElBSlQyOW9JaEpwUGtVdGlqWlNxSnpEVlhMY2tWdXdLZjFZQXp3UzlpUkVF?=
 =?utf-8?B?RXIzTmRORUdaK1llMEM3V2dsQWg4VVMrY0ppM0k3ZDRWMGZSeGZieWpzM0Vk?=
 =?utf-8?B?ZW5jb1Z5Q0FicFNBY3l4Q0dPYWMxemwyS2xKUEhqbVhudWtrai8yUDRMNmRl?=
 =?utf-8?B?Mm5tWkE1NDkyREJuTXlXZU1EZXJiTWJyLzJpNWxpVWY5RFpYRWtqaEtKeklL?=
 =?utf-8?B?bjBaQWRIRE5BMERscUZzdWVIMVhtRHVObDZ3cVo1ZXZLeHhtT2hMdnBEcFpa?=
 =?utf-8?B?cTBZTkFNM1ZLWmNLeEtaUkxPYjdyWk41a01YWDQveVlEcDVjUklsOG1sWEkz?=
 =?utf-8?B?blhORllOUk5vdSt2cHAvbDl2NmZKejBsdktRdVJEMThqRzdSMWlYcGlyaHky?=
 =?utf-8?B?NlJ6SHlKSUZRditVSkN4Nm10SCtGMHAwRmFlSlkyeDhCdHVjdUxyRGFzdW4r?=
 =?utf-8?B?N3pBU3pYUitoczRSVHJiTzBiYTBGcXYyYVIzYUpmUHUreG9vRHNaQTZpSmRJ?=
 =?utf-8?B?KzVRN01qdG9sdzB2UExLSFZIT1lGSUxKLzVaeTlLdmZLTnlObm8wN3dZdWJQ?=
 =?utf-8?Q?E0bWu45qKGKkYh1QOcfx7YsUYAk+ngcwH/OolK/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C17D1DC930AE4645865390BE70451627@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PR3PR08MB5801.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc77e0c0-e0c5-44d9-fb92-08d946a42021
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2021 08:48:17.6189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pV67Nv+3b9lZQgtD9LK6No/3qKSE/mb6IN22UNwDY/DWeEHO0yC/ywkRE7aSvBZJJE9GDHFHQmI8UM8nwFDgSJkIrye+8I4ef0YpzS9a9do=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6016
X-MDID: 1626252499-aj9NhZqCcXAB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsIHRoYW5rcyBmb3IgcmV2aWV3aW5nIHRoZSBwYXRjaCENCkhlcmUgaXMgdGhlIHVw
ZGF0ZWQgcGF0Y2gsIEkgaG9wZSBpdCdzIG9rYXkgbm93Og0KDQppcG1vbml0b3I6IEZpeCByZWN2
bXNnIHdpdGggYW5jaWxsYXJ5IGRhdGENCg0KQSBzdWNjZXNzZnVsIGNhbGwgdG8gcmVjdm1zZygp
IGNhdXNlcyBtc2cubXNnX2NvbnRyb2xsZW4gdG8gY29udGFpbiB0aGUgbGVuZ3RoDQpvZiB0aGUg
cmVjZWl2ZWQgYW5jaWxsYXJ5IGRhdGEuIEhvd2V2ZXIsIHRoZSBjdXJyZW50IGNvZGUgaW4gdGhl
ICdpcCcgdXRpbGl0eQ0KZG9lc24ndCByZXNldCB0aGlzIHZhbHVlIGFmdGVyIGVhY2ggcmVjdm1z
ZygpLg0KDQpUaGlzIG1lYW5zIHRoYXQgaWYgYSBjYWxsIHRvIHJlY3Ztc2coKSBkb2Vzbid0IGhh
dmUgYW5jaWxsYXJ5IGRhdGEsIHRoZW4NCidtc2cubXNnX2NvbnRyb2xsZW4nIHdpbGwgYmUgc2V0
IHRvIDAsIGNhdXNpbmcgZnV0dXJlIHJlY3Ztc2coKSB3aGljaCBkbw0KY29udGFpbiBhbmNpbGxh
cnkgZGF0YSB0byBnZXQgTVNHX0NUUlVOQyBzZXQgaW4gbXNnLm1zZ19mbGFncy4NCg0KVGhpcyBm
aXhlcyAnaXAgbW9uaXRvcicgcnVubmluZyB3aXRoIHRoZSBhbGwtbnNpZCBvcHRpb24gLSBXaXRo
IHRoaXMgb3B0aW9uIHRoZQ0Ka2VybmVsIHBhc3NlcyB0aGUgbnNpZCBhcyBhbmNpbGxhcnkgZGF0
YS4gSWYgd2hpbGUgJ2lwIG1vbml0b3InIGlzIHJ1bm5pbmcgYW4NCmV2ZW4gb24gdGhlIGN1cnJl
bnQgbmV0bnMgaXMgcmVjZWl2ZWQsIHRoZW4gbm8gYW5jaWxsYXJ5IGRhdGEgd2lsbCBiZSBzZW50
LA0KY2F1c2luZyAnbXNnLm1zZ19jb250cm9sbGVuJyB0byBiZSBzZXQgdG8gMCwgd2hpY2ggY2F1
c2VzICdpcCBtb25pdG9yJyB0bw0KaW5kZWZpbml0ZWx5IHByaW50ICJbbnNpZCBjdXJyZW50XSIg
aW5zdGVhZCBvZiB0aGUgcmVhbCBuc2lkLg0KDQpGaXhlczogNDQ5YjgyNGFkMTk2ICgiaXBtb25p
dG9yOiBhbGxvd3MgdG8gbW9uaXRvciBpbiBzZXZlcmFsIG5ldG5zIikNCkNjOiBOaWNvbGFzIERp
Y2h0ZWwgPG5pY29sYXMuZGljaHRlbEA2d2luZC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBMYWhhdiBT
Y2hsZXNpbmdlciA8bHNjaGxlc2luZ2VyQGRyaXZlbmV0cy5jb20+DQotLS0NCiBsaWIvbGlibmV0
bGluay5jIHwgMTAgKysrKystLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyks
IDUgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9saWIvbGlibmV0bGluay5jIGIvbGliL2xp
Ym5ldGxpbmsuYw0KaW5kZXggMmYyY2MxZmUuLjM5YTU1MmRmIDEwMDY0NA0KLS0tIGEvbGliL2xp
Ym5ldGxpbmsuYw0KKysrIGIvbGliL2xpYm5ldGxpbmsuYw0KQEAgLTExMzgsMTYgKzExMzgsMTYg
QEAgaW50IHJ0bmxfbGlzdGVuKHN0cnVjdCBydG5sX2hhbmRsZSAqcnRubCwNCiAgICBjaGFyICAg
YnVmWzE2Mzg0XTsNCiAgICBjaGFyICAgY21zZ2J1ZltCVUZTSVpdOw0KDQotICAgaWYgKHJ0bmwt
PmZsYWdzICYgUlROTF9IQU5ETEVfRl9MSVNURU5fQUxMX05TSUQpIHsNCi0gICAgICAgbXNnLm1z
Z19jb250cm9sID0gJmNtc2didWY7DQotICAgICAgIG1zZy5tc2dfY29udHJvbGxlbiA9IHNpemVv
ZihjbXNnYnVmKTsNCi0gICB9DQotDQogICAgaW92Lmlvdl9iYXNlID0gYnVmOw0KICAgIHdoaWxl
ICgxKSB7DQogICAgICAgIHN0cnVjdCBydG5sX2N0cmxfZGF0YSBjdHJsOw0KICAgICAgICBzdHJ1
Y3QgY21zZ2hkciAqY21zZzsNCg0KKyAgICAgICBpZiAocnRubC0+ZmxhZ3MgJiBSVE5MX0hBTkRM
RV9GX0xJU1RFTl9BTExfTlNJRCkgew0KKyAgICAgICAgICAgbXNnLm1zZ19jb250cm9sID0gJmNt
c2didWY7DQorICAgICAgICAgICBtc2cubXNnX2NvbnRyb2xsZW4gPSBzaXplb2YoY21zZ2J1Zik7
DQorICAgICAgIH0NCisNCiAgICAgICAgaW92Lmlvdl9sZW4gPSBzaXplb2YoYnVmKTsNCiAgICAg
ICAgc3RhdHVzID0gcmVjdm1zZyhydG5sLT5mZCwgJm1zZywgMCk7DQoNCg0KDQo+IE9uIDEzIEp1
bCAyMDIxLCBhdCAxOTozMCwgRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPiB3cm90ZToN
Cj4gDQo+IE9uIDcvMTMvMjEgMjowOSBBTSwgTGFoYXYgRGFuaWVsIFNjaGxlc2luZ2VyIHdyb3Rl
Og0KPj4gDQo+PiANCj4+IEEgc3VjY2Vzc2Z1bCBjYWxsIHRvIHJlY3Ztc2coKSBjYXVzZXMgbXNn
Lm1zZ19jb250cm9sbGVuIHRvIGNvbnRhaW4gdGhlIGxlbmd0aCBvZiB0aGUgcmVjZWl2ZWQgYW5j
aWxsYXJ5IGRhdGEuIEhvd2V2ZXIsIHRoZSBjdXJyZW50IGNvZGUgaW4gdGhlICdpcCcgdXRpbGl0
eSBkb2Vzbid0IHJlc2V0IHRoaXMgdmFsdWUgYWZ0ZXIgZWFjaCByZWN2bXNnKCkuDQo+PiANCj4+
IFRoaXMgbWVhbnMgdGhhdCBpZiBhIGNhbGwgdG8gcmVjdm1zZygpIGRvZXNuJ3QgaGF2ZSBhbmNp
bGxhcnkgZGF0YSwgdGhlbiBtc2cubXNnX2NvbnRyb2xsZW4gd2lsbCBiZSBzZXQgdG8gMCwgY2F1
c2luZyBmdXR1cmUgcmVjdm1zZygpIHdoaWNoIGRvIGNvbnRhaW4gYW5jaWxsYXJ5IGRhdGEgdG8g
Z2V0IE1TR19DVFJVTkMgc2V0IGluIG1zZy5tc2dfZmxhZ3MuDQo+PiANCj4+IFRoaXMgZml4ZXMg
J2lwIG1vbml0b3InIHJ1bm5pbmcgd2l0aCB0aGUgYWxsLW5zaWQgb3B0aW9uIC0gV2l0aCB0aGlz
IG9wdGlvbiB0aGUga2VybmVsIHBhc3NlcyB0aGUgbnNpZCBhcyBhbmNpbGxhcnkgZGF0YS4gSWYg
d2hpbGUgJ2lwIG1vbml0b3InIGlzIHJ1bm5pbmcgYW4gZXZlbiBvbiB0aGUgY3VycmVudCBuZXRu
cyBpcyByZWNlaXZlZCwgdGhlbiBubyBhbmNpbGxhcnkgZGF0YSB3aWxsIGJlIHNlbnQsIGNhdXNp
bmcgbXNnLm1zZ19jb250cm9sbGVuIHRvIGJlIHNldCB0byAwLCB3aGljaCBjYXVzZXMgJ2lwIG1v
bml0b3InIHRvIGluZGVmaW5pdGVseSBwcmludCAiW25zaWQgY3VycmVudF0iIGluc3RlYWQgb2Yg
dGhlIHJlYWwgbnNpZC4NCj4+IA0KPiANCj4gcGF0Y2ggbG9va3MgcmlnaHQuIENhbiB5b3Ugc2Vu
ZCBpdCBhcyBhIGZvcm1hbCBwYXRjaCB3aXRoIGEgY29tbWl0IGxvZw0KPiBtZXNzYWdlLCBTaWdu
ZWQtb2ZmLWJ5LCBldGMuIFNlZSAgJ2dpdCBsb2cnIGZvciBleHBlY3RlZCBmb3JtYXQgYW5kDQo+
IERvY3VtZW50YXRpb24vcHJvY2Vzcy9zdWJtaXR0aW5nLXBhdGNoZXMucnN0IGluIHRoZSBrZXJu
ZWwgdHJlZS4gTWFrZQ0KPiBzdXJlIHlvdSBhZGQ6DQo+IA0KPiBGaXhlczogNDQ5YjgyNGFkMTk2
ICjigJxpcG1vbml0b3I6IGFsbG93cyB0byBtb25pdG9yIGluIHNldmVyYWwgbmV0bnPigJ0pDQo+
IENjOiBOaWNvbGFzIERpY2h0ZWwgPG5pY29sYXMuZGljaHRlbEA2d2luZC5jb20+DQo+IA0KPiBh
bmQgbWFrZSBzdXJlIE5pY29sYXMgaXMgY2MnZWQgb24gdGhlIHNlbmQuDQoNCg==
