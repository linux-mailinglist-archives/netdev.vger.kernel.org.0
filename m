Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104CA3CD3F1
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 13:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbhGSKwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 06:52:40 -0400
Received: from mail-eopbgr70108.outbound.protection.outlook.com ([40.107.7.108]:20000
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232156AbhGSKwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 06:52:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huhUWh6f9pIax2alrY0L4AZnfLDmvl9HK2fAMqa+5uSKC7q/Mqp6jRIBzMdEVvvksDzfirDM1Wnz9dRSeFO9jgd/7YRzDZZi86wLifda3NxVwbULiwTTKLkhEbGAXEUgKH8oPsdTkVaJpdXX2bc7FylgUg1MwdXzQsxtfdFMzcaxPlNijf3T0k+JEaUNRUJZGj8LskOce9cft6BN6x/Pq3ohTtiB6ymnYHq6f4WhgwfRXIMzrIMgHmHsE+I9QHM6S5FxYaHRxsHLIoREDQEIyhnQAp0FDgSZrq99PfN/FLonn+jWWZss4291gAPpOB44QS5c8KVAED6uVCECoG7aEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dS5a4c2ZKFzE8zL4AeAbXR18mkQsM5YX1LneI7g1I6o=;
 b=Qwx942aEqBEsYbk6sBr8oS3fgXsXdRsntYtidZpmCVZiuSB1EMD+VUwxRDNyG6G96RnR418W0JcSeAmvdP/mhHIWE0tgWIEDNYym2fFHhM2Rckx9oxO3gR96Tyb/jtVRaxQDq3cAVwR5q5pVu8QZOrEKciHFXy1/4pLBvFS4Gt2RNMr9oAiih1ci/p5H4EIlfCiBXbnjclGqASo3Nd1WAEULiJM0FNxt611+QzGIDX99OqJa1mjJEwRzmzBF4bjqhpDoc4npFhVaPvshprybKNfN/n6z8A/YeCr01aK5qEETMhPvfRMzEYbO8wH4Pv2zRzQteAjM/7hBiNqNYuyxYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hbkworld.com; dmarc=pass action=none header.from=hbkworld.com;
 dkim=pass header.d=hbkworld.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hbkworld.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dS5a4c2ZKFzE8zL4AeAbXR18mkQsM5YX1LneI7g1I6o=;
 b=dt2FBAWr+tvDsUF2Gp2eud1G/0cx6XBHRfWsowUnhO7WJowA8hOuku15hOrjwBeo84tsEb01NWVwGQLL6aEL9rJ6yj7BthgMJAZ6gY50nW6ZFB56q9wltDwp/ur6U27WnYuQlDtLuEhj7PSFcHQmKuWwr1cVkz/BofN3ZfeJU47xS3IcDmqGXp5kJiZvX200xA3HBMh+g9GkXa64qXNp1E6ItV9bZBlj0FQaZPNDotI7otf8Y9YYiNtEw8LrQIYXEwIaOvulZ4WoFBSWsqVorFWQ7v0t/TntNS5a3M9v2hRXYZYLUzpEos2R6zw2TBOOp94H4GaltHww/gGizazy3w==
Received: from AM0PR09MB4276.eurprd09.prod.outlook.com (2603:10a6:20b:166::10)
 by AM8PR09MB5228.eurprd09.prod.outlook.com (2603:10a6:20b:3db::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Mon, 19 Jul
 2021 11:33:17 +0000
Received: from AM0PR09MB4276.eurprd09.prod.outlook.com
 ([fe80::4d88:bf9c:b655:7a92]) by AM0PR09MB4276.eurprd09.prod.outlook.com
 ([fe80::4d88:bf9c:b655:7a92%7]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 11:33:17 +0000
From:   Ruud Bos <ruud.bos@hbkworld.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: [PATCH net-next 1/4 resend] igb: move SDP config initialization to
 separate function
Thread-Topic: [PATCH net-next 1/4 resend] igb: move SDP config initialization
 to separate function
Thread-Index: Add8kFEBf7R8NvzVR1qaYQ8/VtYXhA==
Date:   Mon, 19 Jul 2021 11:33:17 +0000
Message-ID: <AM0PR09MB4276B00E3C1D69347EC244BCF0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Enabled=true;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_SetDate=2021-07-19T11:33:16Z;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Method=Privileged;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Name=Unrestricted;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_SiteId=6cce74a3-3975-45e0-9893-b072988b30b6;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_ActionId=80a0f707-28de-48c1-9f90-f80f8b6a5765;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_ContentBits=2
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=hbkworld.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c303a7d-3bc5-4d63-ad33-08d94aa900f0
x-ms-traffictypediagnostic: AM8PR09MB5228:
x-microsoft-antispam-prvs: <AM8PR09MB5228DD53D97BC9CE731E53AEF0E19@AM8PR09MB5228.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KXmiOwASyn3KfYEri6XKz5hDWg77ZFcP0jifDuxciL+DrSv+KVcRRnsu2Wmv+JWOyDj4up5RCn+ycCssFaRS1TFH4giUGE6lKrQRSwewWOvioiEcn4Ce859wCRj4j66f87QfVBA1OQNY+/wtly4oYZ0Fg9p7iB05x5JsARNjyAiqn6BXdeWWLrB1L2Gr7RtfS0QDEj/2qb8urp1/3Ma+1Q//9PQByz69GG9/uPIzkbpwGWNR6NL+XnUbE9SQ9Yu/IUu2px5P25W3QwzQEhsiHugbAD0MjbboyP3F1BtDlZ1O4Qx6SSvxGh0kqNUtuJC20ELRI79LmjzoaVlbdpFbA9abYwyEQtiCn1BA5lLLiVbjAMJ2mwIx+GbLkLLJq9iOAotSFCksu3XNd2xKm2aUj479JKGQbO5sI123rywQPg6Vh1eVZAdsNWNSSyP2UolE1JSWesO0RiN5WAz+EqiZUAXC869MIDMwmJbDQNTOKh3aOE2BInFoqZppCW5rx5FtGryoUgLBgwzyE6ckKdMbVs30lNnWi878TLnFexe1hCJPhiZZr90q3wG2ynFx9nCIXmLEuGsZGkx/mLF2YLHix0RhE2895yiw1l1Dl6JuueSS0WlEfCq291juXM/NGYXvVHkIZfllV/dL7xIg54nh9iveYqiTjoJpig5+Q4nAD/+0E4NC8ksPETVk6ZNG4ZcXav/EvxK83CnjxofvR4twYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR09MB4276.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(396003)(346002)(376002)(8936002)(8676002)(5660300002)(6916009)(55016002)(33656002)(52536014)(83380400001)(38100700002)(2906002)(44832011)(122000001)(26005)(9686003)(54906003)(86362001)(186003)(15974865002)(66446008)(64756008)(66556008)(66476007)(4326008)(316002)(71200400001)(66946007)(478600001)(76116006)(7696005)(6506007)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ci8xK0pOMi8xZWlDbEd4YXNTL3hSVkZsVVRJcGt4MmlHRm9SdURzbll4Q2ZJ?=
 =?utf-8?B?bHVMVHI5cFpXelRHSVdsSUM5VzNEdzRQL2FBTXd1aEZJbU5laTAyTkRLajgw?=
 =?utf-8?B?dG1kVm5VdS9vbGZOY2pnZ3ZIWXNFb0xhQzFDM2NpS1JxYW04Rloyek1EZ2tY?=
 =?utf-8?B?ZnZEd0s4OTdzRlpHdmxTbFdOazluMkoybXRWbVlHYzFQQU9PRXc4bXBuTXJF?=
 =?utf-8?B?UlhnOG9SYlVpMkNaaTIwQm80a1RxR1ZxeVpiRTNkVEZGK3d6b2xYbUhHdy80?=
 =?utf-8?B?VitNUHV6Qy9HbTlHQkFTOE5JZU5jWlAwRHdTS1poZkd2dXhnOUpoWDBRN3ZY?=
 =?utf-8?B?c0Q1OSs3UUV3S0JtbkNuZVVoMjVFempFdHlUa2ViZVp3azcyaTF6clR4SWd4?=
 =?utf-8?B?UEhiYmkvSTNQTE5sMkczR2ZHbUh1MTAzdEx1SGpLU25BbUNmQ2lQWGxPYk4r?=
 =?utf-8?B?ZDcyNW1lTGhyelNpSXhJakowUHN0Mm9TdXVsV3NGTno5OEpybzB3QzNwRURm?=
 =?utf-8?B?aDI3OWFXT3ZLdm9uSmZKbGRqOTlYQnlTcUpWRGp0TmVocFhEcWVlMzZjWjN2?=
 =?utf-8?B?Y0JwenlKTDdWTWhkVzAreUR0aHVtcGpscDJubThURXAvQzAxL2tzNGFERjNR?=
 =?utf-8?B?ZlEwWEhUNU1QSlBvckdDZ0M3Q0p2L0tieWVOM2w3dG5YbFdoNWorOWdOVGhw?=
 =?utf-8?B?dU9XWmU4V3EybDVIelc2Uk1weWtUVUtxK0lCMVBWN0FNMUY2VWhHSmxPaThU?=
 =?utf-8?B?WEd2ZGxneURjeVd1dlU3RlpXS0VEU1NaQk9tUlNvRzRuNXY0SzZCRFVuMUFT?=
 =?utf-8?B?YXhrckNFSWhPVVVabTBVdUNUSTRlT0ZwRU01NTF0OVNSVFVHNVhsWjZuVlln?=
 =?utf-8?B?NU1ZMXoxVExPN3F0azNpQ2tzdEgvcEwyRElleXNTemM3TWwzNEpSWHRKSjh4?=
 =?utf-8?B?YU5aajNtUGx4UHd1aVBhQ3hwYkxXNTJZc3B5MVNWbi9pVWpaTDVzYTZ3TExs?=
 =?utf-8?B?TklSbWZkZEtiVDhsZnlleGgycHZCMlRiWEROUGl3blc3L1RNL01WYW9NVlA1?=
 =?utf-8?B?UXZwdE9saXl4UnIwczhqam1TVEpLMHB1cWREYXhQbkJFNk0rRXJkMHl2UGk3?=
 =?utf-8?B?ZTAvd1pVMGo4VnlmZi9aelpRT2VGR2o5UnMxd1I1R0d5N0dDOHZMRW5DSTNu?=
 =?utf-8?B?NmhKWWxFT1czb0hKZzlWNEIxYUNRNEx6OG5yczZNZDh5UnpoN2pINHJxbTZp?=
 =?utf-8?B?d3EwU3h5UWhGZTdVVjhUZWpyeFBJdk9CeVNYcExscVJENmluTmpza3ZXY09B?=
 =?utf-8?B?QXRjWGtaNGVycng2c09CTlp6SXhxNHdNdUhEOTQ2eThtWldOeUwrUGhGSFpK?=
 =?utf-8?B?ZGlIRzluNEZNSFh2WDUwbkVyZ3N3Q2laajdIY1RvR3ptOGtMenVlb1ZsbTdT?=
 =?utf-8?B?STg0REpXR3ZHWHVLU2NsWEM1ZHc4UUNzNDBuYU03UUFBNXNOQUd6RUV6eXY0?=
 =?utf-8?B?eXNWZ1dxOHlvNnlBVlpxMldoc3ZWM0ptaFlpUGtOblM4cmdISE5kN3ZYUlY0?=
 =?utf-8?B?TUZuM0FCSzdydVFvbjhwemJwQ25oeDRqMFp0V1g5RUtUT2w0UHJoTHZNbXM4?=
 =?utf-8?B?U1pkVER2NWpQOEFGMHV5T3ZpbFdoa1liSE56T0w5Q0ZDQ0Nxa2VZZWlQTGR0?=
 =?utf-8?B?N1NidzJVcllmMkxzWnNieGxQSE1XNHZqcUZYWGpYRkVvSng5dXpoRGxCQ1Ur?=
 =?utf-8?Q?l05jqzRqcBWWum/Z88=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hbkworld.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR09MB4276.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c303a7d-3bc5-4d63-ad33-08d94aa900f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 11:33:17.4032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6cce74a3-3975-45e0-9893-b072988b30b6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: emqpzrKoZZm4fNCCHNc8UVby5unv3Ewv9iw6Vz8RFSLIJpH2HdhcInrwliSz+HT6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR09MB5228
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWxsb3cgcmV1c2Ugb2YgU0RQIGNvbmZpZyBzdHJ1Y3QgaW5pdGlhbGl6YXRpb24gYnkgbW92aW5n
IGl0IHRvIGENCnNlcGFyYXRlIGZ1bmN0aW9uLg0KDQpTaWduZWQtb2ZmLWJ5OiBSdXVkIEJvcyA8
cnV1ZC5ib3NAaGJrd29ybGQuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWdiL2lnYl9wdHAuYyB8IDI3ICsrKysrKysrKysrKysrKysrLS0tLS0tLQ0KIDEgZmlsZSBjaGFu
Z2VkLCAxOSBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9wdHAuYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2lnYi9pZ2JfcHRwLmMNCmluZGV4IDAwMTFiMTVlNjc4Yy4uYzc4ZDBjMmE1MzQx
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9wdHAuYw0K
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9wdHAuYw0KQEAgLTY5LDYg
KzY5LDcgQEANCiAjZGVmaW5lIElHQl9OQklUU184MjU4MCAgICAgICAgICAgICAgICAgICAgICAg
IDQwDQoNCiBzdGF0aWMgdm9pZCBpZ2JfcHRwX3R4X2h3dHN0YW1wKHN0cnVjdCBpZ2JfYWRhcHRl
ciAqYWRhcHRlcik7DQorc3RhdGljIHZvaWQgaWdiX3B0cF9zZHBfaW5pdChzdHJ1Y3QgaWdiX2Fk
YXB0ZXIgKmFkYXB0ZXIpOw0KDQogLyogU1lTVElNIHJlYWQgYWNjZXNzIGZvciB0aGUgODI1NzYg
Ki8NCiBzdGF0aWMgdTY0IGlnYl9wdHBfcmVhZF84MjU3Nihjb25zdCBzdHJ1Y3QgY3ljbGVjb3Vu
dGVyICpjYykNCkBAIC0xMTkyLDcgKzExOTMsNiBAQCB2b2lkIGlnYl9wdHBfaW5pdChzdHJ1Y3Qg
aWdiX2FkYXB0ZXIgKmFkYXB0ZXIpDQogew0KICAgICAgICBzdHJ1Y3QgZTEwMDBfaHcgKmh3ID0g
JmFkYXB0ZXItPmh3Ow0KICAgICAgICBzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2ID0gYWRhcHRl
ci0+bmV0ZGV2Ow0KLSAgICAgICBpbnQgaTsNCg0KICAgICAgICBzd2l0Y2ggKGh3LT5tYWMudHlw
ZSkgew0KICAgICAgICBjYXNlIGUxMDAwXzgyNTc2Og0KQEAgLTEyMzMsMTMgKzEyMzMsNyBAQCB2
b2lkIGlnYl9wdHBfaW5pdChzdHJ1Y3QgaWdiX2FkYXB0ZXIgKmFkYXB0ZXIpDQogICAgICAgICAg
ICAgICAgYnJlYWs7DQogICAgICAgIGNhc2UgZTEwMDBfaTIxMDoNCiAgICAgICAgY2FzZSBlMTAw
MF9pMjExOg0KLSAgICAgICAgICAgICAgIGZvciAoaSA9IDA7IGkgPCBJR0JfTl9TRFA7IGkrKykg
ew0KLSAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHB0cF9waW5fZGVzYyAqcHBkID0gJmFk
YXB0ZXItPnNkcF9jb25maWdbaV07DQotDQotICAgICAgICAgICAgICAgICAgICAgICBzbnByaW50
ZihwcGQtPm5hbWUsIHNpemVvZihwcGQtPm5hbWUpLCAiU0RQJWQiLCBpKTsNCi0gICAgICAgICAg
ICAgICAgICAgICAgIHBwZC0+aW5kZXggPSBpOw0KLSAgICAgICAgICAgICAgICAgICAgICAgcHBk
LT5mdW5jID0gUFRQX1BGX05PTkU7DQotICAgICAgICAgICAgICAgfQ0KKyAgICAgICAgICAgICAg
IGlnYl9wdHBfc2RwX2luaXQoYWRhcHRlcik7DQogICAgICAgICAgICAgICAgc25wcmludGYoYWRh
cHRlci0+cHRwX2NhcHMubmFtZSwgMTYsICIlcG0iLCBuZXRkZXYtPmRldl9hZGRyKTsNCiAgICAg
ICAgICAgICAgICBhZGFwdGVyLT5wdHBfY2Fwcy5vd25lciA9IFRISVNfTU9EVUxFOw0KICAgICAg
ICAgICAgICAgIGFkYXB0ZXItPnB0cF9jYXBzLm1heF9hZGogPSA2MjQ5OTk5OTsNCkBAIC0xMjg0
LDYgKzEyNzgsMjMgQEAgdm9pZCBpZ2JfcHRwX2luaXQoc3RydWN0IGlnYl9hZGFwdGVyICphZGFw
dGVyKQ0KICAgICAgICB9DQogfQ0KDQorLyoqDQorICogaWdiX3B0cF9zZHBfaW5pdCAtIHV0aWxp
dHkgZnVuY3Rpb24gd2hpY2ggaW5pdHMgdGhlIFNEUCBjb25maWcgc3RydWN0cw0KKyAqIEBhZGFw
dGVyOiBCb2FyZCBwcml2YXRlIHN0cnVjdHVyZS4NCisgKiovDQordm9pZCBpZ2JfcHRwX3NkcF9p
bml0KHN0cnVjdCBpZ2JfYWRhcHRlciAqYWRhcHRlcikNCit7DQorICAgICAgIGludCBpOw0KKw0K
KyAgICAgICBmb3IgKGkgPSAwOyBpIDwgSUdCX05fU0RQOyBpKyspIHsNCisgICAgICAgICAgICAg
ICBzdHJ1Y3QgcHRwX3Bpbl9kZXNjICpwcGQgPSAmYWRhcHRlci0+c2RwX2NvbmZpZ1tpXTsNCisN
CisgICAgICAgICAgICAgICBzbnByaW50ZihwcGQtPm5hbWUsIHNpemVvZihwcGQtPm5hbWUpLCAi
U0RQJWQiLCBpKTsNCisgICAgICAgICAgICAgICBwcGQtPmluZGV4ID0gaTsNCisgICAgICAgICAg
ICAgICBwcGQtPmZ1bmMgPSBQVFBfUEZfTk9ORTsNCisgICAgICAgfQ0KK30NCisNCiAvKioNCiAg
KiBpZ2JfcHRwX3N1c3BlbmQgLSBEaXNhYmxlIFBUUCB3b3JrIGl0ZW1zIGFuZCBwcmVwYXJlIGZv
ciBzdXNwZW5kDQogICogQGFkYXB0ZXI6IEJvYXJkIHByaXZhdGUgc3RydWN0dXJlDQotLQ0KMi4z
MC4yDQoNCg0KVU5SRVNUUklDVEVEDQpIQksgQmVuZWx1eCBCLlYuLCBTY2h1dHdlZyAxNWEsIE5M
LTUxNDUgTlAgV2FhbHdpamssIFRoZSBOZXRoZXJsYW5kcyB3d3cuaGJrd29ybGQuY29tIFJlZ2lz
dGVyZWQgYXMgQi5WLiAoRHV0Y2ggbGltaXRlZCBsaWFiaWxpdHkgY29tcGFueSkgaW4gdGhlIER1
dGNoIGNvbW1lcmNpYWwgcmVnaXN0ZXIgMDgxODMwNzUgMDAwMCBDb21wYW55IGRvbWljaWxlZCBp
biBXYWFsd2lqayBNYW5hZ2luZyBEaXJlY3RvcnMgOiBBbGV4YW5kcmEgSGVsbGVtYW5zLCBKZW5z
IFdpZWdhbmQsIEpvcm4gQmFnaWpuIFRoZSBpbmZvcm1hdGlvbiBpbiB0aGlzIGVtYWlsIGlzIGNv
bmZpZGVudGlhbC4gSXQgaXMgaW50ZW5kZWQgc29sZWx5IGZvciB0aGUgYWRkcmVzc2VlLiBJZiB5
b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50LCBwbGVhc2UgbGV0IG1lIGtub3cgYW5k
IGRlbGV0ZSB0aGlzIGVtYWlsLg0K
