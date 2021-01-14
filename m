Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4192F61C5
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 14:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbhANNS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 08:18:26 -0500
Received: from mail-db8eur05on2090.outbound.protection.outlook.com ([40.107.20.90]:64320
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726315AbhANNS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 08:18:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2xF/wdQhs6XblQhYXhyF+zzKE1cWZ36jNMDkZxOj6bbXlL3iFo5m1UGf+ZipFmgemQ3TcJ75CcFQBwQzc/zO7Y/5Zx46uguRBYbjG5cLx0ThsgtEvUKxiNJTzDRIjZMcXMH9LMlUUhsTWKSs4b1NRBj/58fHcxIQS/AHlqYsgDA1J9RCyzJVK718BvbF26+qSCcps7ek7ZuAWpsxntYAKdGHCe/DoZiBkAQy8YvqwyvZ2+5voD8RfhN836iGgkI4CxpAz/zjlXcETGsu4S25BGUKsT2Oecl9HLE8wpjgQqZNUBSFSiDSQo7Fe5PuJSve3D9DfzFupZ9pfCr2zxDKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10ndG513HyiTSOB4+eD2rJXHCe8aYU/5fu+ZPc9+2QE=;
 b=FgztwxUhUu0Ldu+VRUhDJZg6AyZ6dKsjkXrZps1oJYCBqy14mVdKcxq+kqUyw/XR34fJKtiVSziLbo4k9swyBu9O1Jze4YlSNvTl5iQZw3FLCLi04uUijg09uhB2owoBhmjZa2t2Or5TN3dkRu4uIYCV3PP62ib8jMTTNZdUziWKWN4LeZb7SPG1TdlOXHqt/c7+fyQrgeykykNcGKAMKIhmRRPPfv/xZvpYB+K8NExIhUlyma3dECLi82iIBL5gWgq2IjRueWoe4c8015qK0CsdUL/M3CrQEweuO7d4rRCphLncIHvaFkF5xq0Glc7s4Lih0rjb2S90c1ChldLtmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10ndG513HyiTSOB4+eD2rJXHCe8aYU/5fu+ZPc9+2QE=;
 b=GojUMtKK42z4VcKXGf2vNPvcSuiKtwMudFitVtIueYKAb+tQB6vj/dP1rYTiVVMB8GcnZQJ8gbXftvpL+8fzFs/4EWq+q42hNLM9Q9mmP4yxVEWAZgbKDLV007e7Ya9VkYu3JeTVzFmJEV0oCEhsLMPatGt+UqBBECQwvMrLKbM=
Received: from (2603:10a6:7:2c::17) by
 HE1PR0701MB3002.eurprd07.prod.outlook.com (2603:10a6:3:4f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.6; Thu, 14 Jan 2021 13:17:37 +0000
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::e1f6:25bb:eee:8194]) by HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::e1f6:25bb:eee:8194%6]) with mapi id 15.20.3784.006; Thu, 14 Jan 2021
 13:17:37 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "dsahern@kernel.org" <dsahern@kernel.org>
Subject: iproute2 ss "RTNETLINK answers: Invalid argument" with 5.4 kernel
Thread-Topic: iproute2 ss "RTNETLINK answers: Invalid argument" with 5.4
 kernel
Thread-Index: AQHW6neg85LT9F9EI02ibPT4X7onCQ==
Date:   Thu, 14 Jan 2021 13:17:37 +0000
Message-ID: <a94ad61d28b69cdaac3b524e4f837e8d63ba65b0.camel@nokia.com>
Accept-Language: en-150, fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [131.228.2.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 77435332-07c0-4262-9f36-08d8b88ec37c
x-ms-traffictypediagnostic: HE1PR0701MB3002:
x-microsoft-antispam-prvs: <HE1PR0701MB300283DEF5BEBE0AA41DAA11B4A80@HE1PR0701MB3002.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DTiEibN9+px/ceZCJl+5lt9sRcPxmQk07J7YWB00mLNyv44AEH+u09tIF7R30CNTV7UGM/rb69qRkVk1FQblsg7rH0noYgI4x9ldiUFIWC5y+GYPBtcqphlRoyaYo1NZzgy6hSXArU4nje/NVRpzf357pRyVAaGc/gbD7/De8Q8JrnZmhMD4WpyRsjKjFNG4uvpUkda2X7LZqRljmuCSWXopkqVaxzN3BV9HgbrjzIDLlqScWJePV/i+TyHYN/P5V/NM3gpNaQppSn/3kvhlR4vPTDawQ4ap/VWIEfk/f1NtF5o+/IDSzIr45iZ64EPC0eRUEGiQXyhtmgx8ykBQpnH6uOAFyBX5lHl81Jc7Ylh1RERrvvNKuAGUyiKjWpEQInr4XdKFkURzW8+lhiQaGGcbvKb3XC2BABp4n/bB9Yzxgrdz2w+09beja8EHXFoyPxoWzFkUNmFYSa+oyFtbDT7OSBP+ktfAae86ER3Tig3J5xI0kms+p/m7dCBMYf9KPtVUyn2oeIEb+WXWUlBYbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR07MB3450.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(66556008)(6512007)(8676002)(36756003)(5660300002)(110136005)(186003)(2616005)(66446008)(6506007)(66476007)(83380400001)(478600001)(76116006)(64756008)(66946007)(6486002)(2906002)(71200400001)(316002)(8936002)(86362001)(4326008)(4744005)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZWdIMHJyTTJXK1hrVE8yR3RYQkdmQ0ZkZk5oNVB5eWEvYUQ3OU5RSDI4Ti95?=
 =?utf-8?B?Rjg3Z2g5engrYmZWQWVBSFdTakFGWklQRzBJTk42bjljZzYwMzBRMDdVQWll?=
 =?utf-8?B?bzVKb2VVL29qL2lkRW1RaUJOMDhsNXo3U0FtNmVxMEwwSnM1a1RxbEVCK0g3?=
 =?utf-8?B?aDFhdUJHaUg1T0lUbUtNUDVtRy9xYlc3VURMMTMxRkgrQndUNzRKNUpxZ1o0?=
 =?utf-8?B?SW44TlhJbVZ4SlRQTTNzdzVxYkpLaGlNSis0NFVDZ3haZXlNWlJKdGNxWUJu?=
 =?utf-8?B?RWxraTJUS1Zpd1hiL0drVVJ1b1lTWUE3cGJRdWhMNlU5STdiUUJyU2R0aTcx?=
 =?utf-8?B?NVZSL2ZoVEZQMHc2NTY0OGM3K0Zxa1VWNDhZek1TTmFLRkRMblhIRjljYU9k?=
 =?utf-8?B?SEs5ajFaT0kxSk12Mm13WXNpZ1ROOURxYS9vRUxoYzBJbzl1NExPU203QnhI?=
 =?utf-8?B?cHg4anJ4QyszNS9meHFSVXFrVnVpM1czbjhKK1FqMmtzbDF4ZDdXNURuQXA2?=
 =?utf-8?B?dHJWSW1kVktqZmRqSzdmMWxEdEVFZ0dhM2dyTmRFYkREaXFHUTVBK2h6SlNU?=
 =?utf-8?B?LzBJd282N0JvL3BienBpa0dOYWYxdWo4c093dXhxbkdJaytXdHk4eWZia2xY?=
 =?utf-8?B?Q3ZqL1JDZUdXQ1YwWUFwY3dHNTZHS3A5TTlFeEhQNFJCQUt6MlJxS1lURm1x?=
 =?utf-8?B?TzFSd1UzWlJ5a1UzUlpDZkhkbWU4aUE4ZURVNHBNc1N5aUZIakdOUGVwNzRZ?=
 =?utf-8?B?bjhXMWJWT0t0VDQ1ZUVjK1N0bnFMRFhsekVMd2F1NERaZnRSblNkZk5aeTdv?=
 =?utf-8?B?TDk0QVVseklRMENMUDRySEs5eTBoanpnc0F5RTNhUmwyM0VLK2pzZ2NTQ3Ay?=
 =?utf-8?B?NUVtaHdidWd1eUZjUDFreUUzN2F5a0pnQno0T0J3dkprWGVRd2UweC9QL29R?=
 =?utf-8?B?Vk43Rm1MNW1USG5OQWtscnBrcTNaQ1FDZjhPanA1SmdsLzBaR0tPYmZwMll4?=
 =?utf-8?B?d3BJMEdzanZud3dCZ0Y2bjh3dHZJbG1OcDZ1M3VuUE9qaXJHT0N3S2grTG9N?=
 =?utf-8?B?elZDT04xNjk5N3NYRTM2L0lsMmRndW9ZVWJvQzMvaFBhbllKODg0R2wvemNG?=
 =?utf-8?B?Z2pqM3NySDJoOEdZMHZQT3JEdEwzUWpMS1kxTkg4RGYxSjgvODUxQXBETlB3?=
 =?utf-8?B?a24rb1g5bDU3aVNNVTcrbjB1cStVSVJ3eXJWQ1hyam1qc2M0aFREazJramlo?=
 =?utf-8?B?RTI0VERNcnhnbWNuWDR3MFFTM3ovRjFDL1IvYjNDTEw5V1huV2hrT1RKOTR3?=
 =?utf-8?Q?zNjQxyFQgcYqJYb+Aj5fH1tnTZjINd4/Pw?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <66098EB368F5C54B8E6046FBAD270CE2@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR07MB3450.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77435332-07c0-4262-9f36-08d8b88ec37c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 13:17:37.5927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ALr90mJUL1YuYmRq1aKfHFSRckncqDxtwhnHnideaalKjxBgJR7crs3goN8KMVN9BttACPAHf2KGOppY1P9iSXmn/hBYtsMwseiEm2MkSfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0701MB3002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNClNpbmNlIGlwcm91dGUyIHY1LjkuMCwgcnVubmluZyBzcyBvbiBMVFMga2VybmVscyAo
Zm9yIGV4YW1wbGUgNS40LnkpDQpwcm9kdWNlcyBlcnJvciBtZXNzYWdlIGluIHN0ZGVyciAoaXQn
cyB3b3JraW5nIG90aGVyd2lzZSBmaW5lLCBqdXN0IHByaW50aW5nDQp0aGlzIGV4dHJhIGVycm9y
KToNCg0KICAkIHNzDQogIFJUTkVUTElOSyBhbnN3ZXJzOiBJbnZhbGlkIGFyZ3VtZW50DQogIC4u
Lg0KDQpCaXNlY3RlZCB0bzoNCg0KY29tbWl0IDljM2JlMmMwZWVlMDFiZTc4MzJiNzkwMGE4YmU3
OThhMTljNjU5YTUNCkF1dGhvcjogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPg0KRGF0
ZTogICBGcmkgSnVsIDEwIDE1OjUyOjM1IDIwMjAgKzAyMDANCg0KICAgIHNzOiBtcHRjcDogYWRk
IG1zayBkaWFnIGludGVyZmFjZSBzdXBwb3J0DQoNCg0KQXMgNS40IGRvZXMgbm90IGhhdmUgYW55
IG1wdGNwIHN1cHBvcnQsIGl0J3Mgbm90IHN1cnByaXNpbmcgdGhhdCB0aGVyZSBpcw0Kc29tZSBF
SU5WQUwgZXJyb3IuIEFueSBuaWNlIHdheSB0byBnZXQgcmlkIG9mIHRoZSBlcnJvciBmb3IgTFRT
IGtlcm5lbA0KdXNlcnM/DQoNCi1Ub21taQ0KDQo=
