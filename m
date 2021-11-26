Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4790F45EA7B
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 10:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376306AbhKZJjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 04:39:51 -0500
Received: from mail-eopbgr70113.outbound.protection.outlook.com ([40.107.7.113]:28612
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1376379AbhKZJhv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 04:37:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyKDW9eL3KbbTuUDZ7bsV/lG79T5RY/K3XF2oLTXLzO8TREyuuLYNMlINcRWRop4Ol+lURZueNzp25sidLpIq1WwqaUryX4hHXXqIAFIn0RHcYBAn2wLoACOvKTPZ7zry7dUa+ZVDmrrKpLb63flTw6IrZl7Z8nwweloshut0uPjht/E2zEzEF8r4gXD/pCNQ7Ph0U4W/DQ6c4O0Ddm/IvclMIf+t0iTgIqXqNMAKedhiyBWM2i8u3t+YJCloT9IILWONkXgbsaw0QaZUeYnaZdoojLm6qG8NjV+VguQhEufMtJt2WPKIjMZq6nVAUYrsZDMA4b/iE99QAzOG5oD3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGoyLFMABdMrlg/sccsXVcWHLCSx4DoG58U5GVxuP+o=;
 b=AqosIgZsxEyFdckJUQvC3xoRAcA9XHOHh13liMD6B8MdHoHMEnjSacJBm2I0PzjVyathT86Fshjb5LCpYcvoM6XEr81VzINk9KAxHVjFozUqRIf8/aWaGQmrz5hlDJZw/LGDE7UAxwCYuOtv4/lUXGTqVrHXLD2krwAl9Edjf8GTW3imA68zDPv4hVseYyJVCaKQNjrWm+I/6TVpMNhRN4kf+APlzHzE2PovJPfMycLdStPdi5mraroLcDd7P/dj3mUupsyo1w5b7ItrwU2TBBaycqAt6XMJk+tCQsDwOAxB9P3w7TfFH5jXx74tbM08S9uwkSPeZgnNxirkFL4o1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGoyLFMABdMrlg/sccsXVcWHLCSx4DoG58U5GVxuP+o=;
 b=F5NJz3fYOiXe2UoDYsJ8/aWovXdIKyxDk11jiEuF6QiQYRm1mvDpJQAJ3lhcBC1OxtQEIOzE82cpgL8R3RiL8j/2o5FkwjKFk+/Qj7uV2q6Tgv+5Wspql6sbl7a/Os7eTgID90bldlkqgxqgRc8YRW9B1jBO7APsZFBNKFNfyG8=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM5PR0301MB2466.eurprd03.prod.outlook.com (2603:10a6:203:a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.26; Fri, 26 Nov
 2021 09:34:35 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63%3]) with mapi id 15.20.4734.022; Fri, 26 Nov 2021
 09:34:35 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     "luizluca@gmail.com" <luizluca@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net: dsa: realtek-smi: fix indirect reg access for
 ports>3
Thread-Topic: [PATCH v2] net: dsa: realtek-smi: fix indirect reg access for
 ports>3
Thread-Index: AQHX4p12kyrI58zqf0uM40eqRKzWCKwVjGkA
Date:   Fri, 26 Nov 2021 09:34:35 +0000
Message-ID: <b2ba44bc-57fb-b756-d693-7d896de90f3d@bang-olufsen.dk>
References: <20211126063645.19094-1-luizluca@gmail.com>
 <20211126081252.32254-1-luizluca@gmail.com>
In-Reply-To: <20211126081252.32254-1-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47ca2daf-cad8-40a6-1003-08d9b0bff588
x-ms-traffictypediagnostic: AM5PR0301MB2466:
x-microsoft-antispam-prvs: <AM5PR0301MB24664AE785B3F1E03D45219183639@AM5PR0301MB2466.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: He7D7QOhV9EKzw3ZLT57rtHprlouNXynsfCJ823pi0Kv4aG17ISWG4NYOdsSkBRquCy/r5ZQ+hDp9VFJNSuJdEPn+039EXQgFvnmkD22X5iO9YAdnmilrak0hJvfustqc5njocrJkvV1lbtCbdUp1rAkPnpYWnoPzP179dPtpcy6kxaFGWLr0yOlrZ4wr2qtYb6KOs+0LBcgw5X1SZzM5N4zsekwGueNcvZOCOxHo1NHUJ+2tVRVmke9uTzZTASMRoD7NJPu6H6S8++qyigHbxRoGbTMouAUOeVTZWTKeUkV03jkqjg0SAfFx3BggMtuQUfaj/mVGCIMps0TY5thrpDZ5R2m7ZFBbi3FU3ICxVpG6R/co2hEMjv2ZnxHCu7MCB62scxV3b/0Ikv7F/yYRPdRfchsCPnFoOONUixqBSeLLwYQm1kREcy7SIDz/GBPlvma8VwbYBN+2GmSNl13WyGmF0dlBfYTYsF9mRpDT+lWAz4gKCk1xOytHH0r59LyObBkMnLGQupHAFet+J4zt6WIy7wnvdoo+GpnlInmp97/guo8Mrxz9XjGLEzoi/lKPLttNAo15x4aB+0PgZeQtdy5RqAvkE4DzE8AVYUXB9qTjhSxswjlfETHpIqgli8hcqHqaeqy455fYdDGE+HDkc7KoZCaWX4tSb+aMWs3jGQYIcwSSuKuwOQp/YTkdPdKmAS+EAnMza4IoGOgzeaQ0WgQD1WRfn+s8RmVtfF1C1k6p3IFLPejlOwWzYfkm5PYUdI+WqlcMAcy9fll/qpfQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(38070700005)(76116006)(38100700002)(6916009)(66556008)(66446008)(64756008)(5660300002)(66476007)(83380400001)(91956017)(508600001)(6512007)(53546011)(36756003)(71200400001)(6486002)(54906003)(85182001)(316002)(8936002)(26005)(85202003)(186003)(8976002)(2906002)(86362001)(2616005)(31686004)(4326008)(122000001)(8676002)(66946007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2NyWUJFMXRXS2RnZk93MXlxaVdOY2dIMGI2SjVRWXpNRkp1dGZsUUFWRFhq?=
 =?utf-8?B?L1JFVmpCdTAveXZhdStqNkhmVmcvTkN2ZFF0WWxkM3pOa3FrR05xb1dZTVJU?=
 =?utf-8?B?SGJkOUxTTGhiTnozbW5iSTdaaUZ3bDVvOWNNSzlUMXpWalpoNDBNaFB1RzJi?=
 =?utf-8?B?Y1dBOEJINmxUYk5hNkhJcjMwTGFxUFVUVmI3b0ZGWk8reWRwNTloSU5IVEdT?=
 =?utf-8?B?Y3oyalI4aytEbHIwdHE2bk9wK2FmYzYvSmcwbW0wMXhGMlFsWVlQRmtBeGdq?=
 =?utf-8?B?UkVmSTJJVm84ZUY3alhrSjRDWFJweVQxRXdZcENhQzBqQ3VUelJ5eTErVkxh?=
 =?utf-8?B?dzQwKzU0Vm9XeFNIanVlTUd1VVpxMkg3T0hWcHNuNnpkM3k1cS9BbXhjVjBs?=
 =?utf-8?B?dnVZUklQQ0dzdldCemZXOEE4T3NTYjdWWi9Ic3JRS1lQV21TNkJ5Z0U1bzkr?=
 =?utf-8?B?K1lWS08wZWJkN1FVYmt4QTQ2a0ZPNHBycExIdG5Mbkw1SGZRc09UaGIyTjE1?=
 =?utf-8?B?MnVGRVNzZmQzWTExU3E1NTVNczNWc2dZQjIzaFhEZEI1THNtdU5TUDNneTYr?=
 =?utf-8?B?RFRDUnlqUXN3REZ4MFcvdTZ2OTU4a3k4RnlQMEVPdkwzbmkwMU10NElJd0Mw?=
 =?utf-8?B?S2k3NzVGZnloVE5IbGZDbFJZalZJcG81aWlZcDRjWHZEd2QvU29KSm1NRklF?=
 =?utf-8?B?TFNjWGwrZFFPeHJ4Znp3RHlmcDBVTTVnSzZFNWZsTXpRVGQ5VjBFSWtJcW44?=
 =?utf-8?B?a1BCSXRXc2MyQWR5TERqVHM0WUd2UjZ6RDFIOWZFMEM1OFNKc1JlblJ2M2xV?=
 =?utf-8?B?ckpQeUM0bDRFUEJlNmF5blZ4RkM5Y1cvN1ROZnUzcVdZTXhYeGhSemF1eEto?=
 =?utf-8?B?RDJnVUNZbDVUMkRPNHdJVkdJN0FkalBRdDBMSFpZWjFpWUQ3Z09kblFxY0t6?=
 =?utf-8?B?Q3IvTTFhb3JzODJIeUhRNDl3bGZIZ3JBVzNvSVFLczZXWXF0UEFzazVDSzRI?=
 =?utf-8?B?bDkxMHEzOVBEOUcrV1grcSt0cUFpb0llYmFianhaU1h0cTJ6RHZLWTlhUWRP?=
 =?utf-8?B?OUo2Q3NKaHVmRkpxeGx6c3RyVFphT05hQUg2TmM3MS82T01YU3JSZjJWVnZz?=
 =?utf-8?B?bGhacEFwRGgyczFPb2JzUFM1c2FSTWthNmJQWkI1a3Q0d1hLMHBtV2FXWDZN?=
 =?utf-8?B?UnhmMHZVd0JiYW5aOEJVTjN4akZLV3M4anFXZXdXZHZKcGdzTEdvZFFtOU04?=
 =?utf-8?B?MUc0YnZQMkRtTm1wbzlJMnZEZGl4QXFvRVVHUUEyYVRoMkd6cEo5NUxlcGFj?=
 =?utf-8?B?WDdWbE5OZHFGdjFaTnd6TWtlbW9zMEo0WWFONEd5SXJIcktwczhYT3R2Rk9G?=
 =?utf-8?B?N0FnbDJJUXhrNElLdS9Ha3pjNlJraVFxRDFNVHZOZm1hb1ZidVJ5aThCVXRm?=
 =?utf-8?B?Y3FBcmRyQytqN0FZb1Nmcnc1VU1ENTR5WUY0bWlReEJNSHduU2R1Q3ZKV3RI?=
 =?utf-8?B?VncyWFBCM3dRTk9MMjZRL2owVUZpaVFSTWJEakJjWGJuSEtlNXpHRVZZYjRE?=
 =?utf-8?B?YVQ5R3pKZ3l3YVZjdno3SlhsTjNlU3h4ODhxVHh4NUR6OXYyOGRUdGh0SnJw?=
 =?utf-8?B?bzhXMm5pck1nUFQ2N2ZEQmZQUkd1L1E4ZW1GSmN3MEJPZWZvWHlJcEd3ZzZx?=
 =?utf-8?B?NXhka2dVZGVTdCtpRndTTStJaVgwZ2V6U1ZtdVNoK3NJZTAvelZ5dThvM0xL?=
 =?utf-8?B?WERJa3Y5UnEvZmNxS3dMSUVpRGJmRThOUnVMMTMxN2hxM0w2aEFVWGs1OE9h?=
 =?utf-8?B?SHZTaWNqN2FHc3ZZd2U0V1lMNHhudWJab0xmdVl4WnpOVHpQOEp1ejd0TDZE?=
 =?utf-8?B?TUFXVmZPUGczdjNCNnhIVG80WnJjeURDVTQ1eWJXbXBTVUFKZ0xLM2tINVY4?=
 =?utf-8?B?V0h6Z1Q0RzRmOTFlWE02NE1jWldSR2RjWDJ0Uzd2NWNtb043MXNOUjlJQUFl?=
 =?utf-8?B?WWNZY3lkS0tlWHMwY05XZDBGdFJHeXlINXFwNkQ5c2ZJemNNNDZzaXdvd2th?=
 =?utf-8?B?MXpqcElpVDFiUVFjcnZ5TjZRbW93ZjdPbXhHYm1aaTBjMGpTU2hDeXBnWkRh?=
 =?utf-8?B?aEV1WENUQnNzQ2ZXT2w3bUtRVDZBVkNSV0VuRUV6S2VEUUE0V3U5aDRTc2dj?=
 =?utf-8?Q?ZkIRzAQgaJ9ujvzW5IUMzvE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F753311339E9845A9F4E8BCFDF0D2BE@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ca2daf-cad8-40a6-1003-08d9b0bff588
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 09:34:35.3043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /HD6m4WJ+CBBqr8wdCc1mENLTDTYUG/ZwOq8OMNgnqQ8NP8hRooqYNdDI6M175SrpRMChT9xgIhQXtmM5QtyAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0301MB2466
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTHVpeiwNCg0KVGhhbmtzIGZvciB5b3VyIHBhdGNoLg0KDQpZb3UgbmVlZG4ndCBjYyB0aGUg
c3RhYmxlIGxpc3QsIHNpbmNlIHJ0bDgzNjVtYiBkb2Vzbid0IGV4aXN0IGluIGFueSANCnN0YWJs
ZSByZWxlYXNlIGp1c3QgeWV0LiBJZiB5b3Ugc2VuZCBhIHYzLCBqdXN0IHRhcmdldCBuZXQ6DQoN
CltQQVRDSCBuZXQgdjNdIG5ldDogZHNhOiAuLi4NCg0KVGhlbiB0aGUgZml4IHdpbGwgbGFuZCBp
biA1LjE2LiA6LSkNCg0KT24gMTEvMjYvMjEgMDk6MTIsIGx1aXpsdWNhQGdtYWlsLmNvbSB3cm90
ZToNCj4gRnJvbTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29t
Pg0KPiANCj4gVGhpcyBzd2l0Y2ggZmFtaWx5IGNhbiBoYXZlIHVwIHRvIDggcG9ydHMgezAuLjd9
LiBIb3dldmVyLA0KPiBJTkRJUkVDVF9BQ0NFU1NfQUREUkVTU19QSFlOVU1fTUFTSyB3YXMgdXNp
bmcgMiBiaXRzIGluc3RlYWQgb2YgMywNCj4gZHJvcHBpbmcgdGhlIG1vc3Qgc2lnbmlmaWNhbnQg
Yml0IGR1cmluZyBpbmRpcmVjdCByZWdpc3RlciByZWFkcyBhbmQNCj4gd3JpdGVzLiBSZWFkaW5n
IG9yIHdyaXRpbmcgcG9ydHMgNCwgNSwgNiwgYW5kIDcgcmVnaXN0ZXJzIHdhcyBhY3R1YWxseQ0K
PiBtYW5pcHVsYXRpbmcsIHJlc3BlY3RpdmVseSwgcG9ydHMgMCwgMSwgMiwgYW5kIDMgcmVnaXN0
ZXJzLg0KDQpOaWNlIGNhdGNoLiBPdXQgb2YgY3VyaW9zaXR5IGNhbiB5b3Ugc2hhcmUgd2hhdCBz
d2l0Y2ggeW91IGFyZSB0ZXN0aW5nPyANClNvIGZhciB0aGUgZHJpdmVyIG9ubHkgYWR2ZXJ0aXNl
cyBzdXBwb3J0IGZvciBSVEw4MzY1TUItVkMuIFNpbmNlIHRoYXQgDQpzd2l0Y2ggb25seSB1c2Vz
IFBIWSBhZGRyZXNzZXMgMH4zLCBpdCBzaG91bGRuJ3QgYmUgYWZmZWN0ZWQgYnkgYSANCm5hcnJv
d2VyICgyLWJpdCkgUEhZTlVNX01BU0ssIHJpZ2h0PyBBcmUgeW91IGFibGUgdG8gYWRkIHdvcmRz
IHRvIHRoZSANCmVmZmVjdCBvZiAiLi4uIG5vdyB0aGlzIGZpeGVzIHRoZSBkcml2ZXIgdG8gd29y
ayB3aXRoIFJUTDgzeHh4eCI/DQoNClRoZSBjaGFuZ2UgaXMgT0sgZXhjZXB0IGZvciBzb21lIGNv
bW1lbnRzIGJlbG93Og0KDQo+IA0KPiBydGw4MzY1bWJfcGh5X3tyZWFkLHdyaXRlfSB3aWxsIG5v
dyByZXR1cm5zIC1FSU5WQUwgaWYgcGh5IGlzIGdyZWF0ZXINCj4gdGhhbiA3Lg0KDQpJIGRvbid0
IHRoaW5rIHRoaXMgaXMgcmVhbGx5IG5lY2Vzc2FyeTogYSB2YWxpZCAoZGV2aWNlIHRyZWUpIA0K
Y29uZmlndXJhdGlvbiBzaG91bGQgbmV2ZXIgc3BlY2lmeSBhIFBIWSB3aXRoIGFkZHJlc3MgZ3Jl
YXRlciB0aGFuIDcuIE9yIA0KYW0gSSBtaXNzaW5nIHNvbWV0aGluZz8NCg0KPiANCj4gdjI6DQo+
IC0gZml4IGFmZmVjdGVkIHBvcnRzIGluIGNvbW1pdCBtZXNzYWdlDQoNClRoZSBjaGFuZ2Vsb2cg
c2hvdWxkbid0IGVuZCB1cCBpbiB0aGUgZmluYWwgY29tbWl0IG1lc3NhZ2UgLSBwbGVhc2UgbW92
ZSANCml0IG91dCBpbiB2My4NCg0KPiANCj4gRml4ZXM6IDRhZjI5NTBjNTBjOCAoIm5ldDogZHNh
OiByZWFsdGVrLXNtaTogYWRkIHJ0bDgzNjVtYiBzdWJkcml2ZXIgZm9yIFJUTDgzNjVNQi1WQyIp
DQo+IFNpZ25lZC1vZmYtYnk6IEx1aXogQW5nZWxvIERhcm9zIGRlIEx1Y2EgPGx1aXpsdWNhQGdt
YWlsLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvZHNhL3J0bDgzNjVtYi5jIHwgNyArKysr
KystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9ydGw4MzY1bWIuYyBiL2RyaXZlcnMv
bmV0L2RzYS9ydGw4MzY1bWIuYw0KPiBpbmRleCBiYWFhZTk3MjgzYzUuLmY0NDE0YWM3NGI2MSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjVtYi5jDQo+ICsrKyBiL2RyaXZl
cnMvbmV0L2RzYS9ydGw4MzY1bWIuYw0KPiBAQCAtMTA3LDYgKzEwNyw3IEBADQo+ICAgI2RlZmlu
ZSBSVEw4MzY1TUJfTEVBUk5fTElNSVRfTUFYXzgzNjVNQl9WQwkyMTEyDQo+ICAgDQo+ICAgLyog
RmFtaWx5LXNwZWNpZmljIGRhdGEgYW5kIGxpbWl0cyAqLw0KPiArI2RlZmluZSBSVEw4MzY1TUJf
UEhZQUREUk1BWAk3DQo+ICAgI2RlZmluZSBSVEw4MzY1TUJfTlVNX1BIWVJFR1MJMzINCj4gICAj
ZGVmaW5lIFJUTDgzNjVNQl9QSFlSRUdNQVgJKFJUTDgzNjVNQl9OVU1fUEhZUkVHUyAtIDEpDQo+
ICAgI2RlZmluZSBSVEw4MzY1TUJfTUFYX05VTV9QT1JUUwkoUlRMODM2NU1CX0NQVV9QT1JUX05V
TV84MzY1TUJfVkMgKyAxKQ0KPiBAQCAtMTc2LDcgKzE3Nyw3IEBADQo+ICAgI2RlZmluZSBSVEw4
MzY1TUJfSU5ESVJFQ1RfQUNDRVNTX1NUQVRVU19SRUcJCQkweDFGMDENCj4gICAjZGVmaW5lIFJU
TDgzNjVNQl9JTkRJUkVDVF9BQ0NFU1NfQUREUkVTU19SRUcJCQkweDFGMDINCj4gICAjZGVmaW5l
ICAgUlRMODM2NU1CX0lORElSRUNUX0FDQ0VTU19BRERSRVNTX09DUEFEUl81XzFfTUFTSwlHRU5N
QVNLKDQsIDApDQo+IC0jZGVmaW5lICAgUlRMODM2NU1CX0lORElSRUNUX0FDQ0VTU19BRERSRVNT
X1BIWU5VTV9NQVNLCQlHRU5NQVNLKDYsIDUpDQo+ICsjZGVmaW5lICAgUlRMODM2NU1CX0lORElS
RUNUX0FDQ0VTU19BRERSRVNTX1BIWU5VTV9NQVNLCQlHRU5NQVNLKDcsIDUpDQo+ICAgI2RlZmlu
ZSAgIFJUTDgzNjVNQl9JTkRJUkVDVF9BQ0NFU1NfQUREUkVTU19PQ1BBRFJfOV82X01BU0sJR0VO
TUFTSygxMSwgOCkNCj4gICAjZGVmaW5lICAgUlRMODM2NU1CX1BIWV9CQVNFCQkJCQkweDIwMDAN
Cj4gICAjZGVmaW5lIFJUTDgzNjVNQl9JTkRJUkVDVF9BQ0NFU1NfV1JJVEVfREFUQV9SRUcJCTB4
MUYwMw0KPiBAQCAtNjc5LDYgKzY4MCw4IEBAIHN0YXRpYyBpbnQgcnRsODM2NW1iX3BoeV9yZWFk
KHN0cnVjdCByZWFsdGVrX3NtaSAqc21pLCBpbnQgcGh5LCBpbnQgcmVnbnVtKQ0KPiAgIAl1MTYg
dmFsOw0KPiAgIAlpbnQgcmV0Ow0KPiAgIA0KPiArCWlmIChwaHkgPiBSVEw4MzY1TUJfUEhZQURE
Uk1BWCkNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICAgCWlmIChyZWdudW0gPiBSVEw4MzY1TUJf
UEhZUkVHTUFYKQ0KDQpJZiB5b3UgZGVjaWRlIHRvIGtlZXAgdGhlc2UgY2hlY2ssIHBsZWFzZSBh
ZGQgYSBuZXdsaW5lIGFmdGVyIHlvdXIgcmV0dXJucy4NCg0KPiAgIAkJcmV0dXJuIC1FSU5WQUw7
DQo+ICAgDQo+IEBAIC03MDQsNiArNzA3LDggQEAgc3RhdGljIGludCBydGw4MzY1bWJfcGh5X3dy
aXRlKHN0cnVjdCByZWFsdGVrX3NtaSAqc21pLCBpbnQgcGh5LCBpbnQgcmVnbnVtLA0KPiAgIAl1
MzIgb2NwX2FkZHI7DQo+ICAgCWludCByZXQ7DQo+ICAgDQo+ICsJaWYgKHBoeSA+IFJUTDgzNjVN
Ql9QSFlBRERSTUFYKQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gICAJaWYgKHJlZ251bSA+IFJU
TDgzNjVNQl9QSFlSRUdNQVgpDQo+ICAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gICANCj4gDQoNCg==
