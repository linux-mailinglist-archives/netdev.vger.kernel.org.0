Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF7F123238
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbfLQQVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:21:08 -0500
Received: from mail-eopbgr680046.outbound.protection.outlook.com ([40.107.68.46]:59543
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726858AbfLQQOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmKOJCVzBShRQBz0yNZ2e16t+0Qn6jvOuQMYj0mY8WhlnRJJoqrX2Hvb+TSIQsCuj243n8/GqTZBXXJiSHuPr81k/q8XWTfczakSs4nGFeggzR9Ktja0vYRymZFGxQ+ObBjMR+DXqMETotK1Y0ymGa6UG3XFrqyJOvXlO01itu5GM2zJFo5kz3g1AM/IQZIScc/+XHcQ8DdSg3MInlTDjeIcTXguzNxZAWJkMeh646z7YqU4evc6/LEvwzesLMoIAx2pnI42OffJ/At4V3hQqqWilFfy1tZsAD2E8wNGlJLzPx6Z0B7byxSNtLiDiPTCLEB2Fedn76aoUMICkxp+NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRLMZCQ+5rhWTrLjUj6s2NJKPZPRMfxJgueobw2UHVc=;
 b=iiAxNS13NxPKeyny6jwZ+jK7Ga41BQFY6XihGYFbYKOrFKMsfDOZDadV91m6bSUNHObqyEM8uoh1xlKqDoa2UEzpFXngDlgIKy/za4PkSrInnCHG8MW2KqExtpTSfjzqZC8cQoai1+gDeedw4xdpEEsWmHOBNbkWvtlztf99aplAjAhsuErB33TIXy3zsqsUc3NfjhBjnUwRI/DtgH/VApWzbTs0rPZiey0Od9ONJZ5s42x72GJ/UWn9S80hj2ujyuTTyzTgQsVLvG8IgdHDHE92A4TAI6hblyCWT5aAINy40vkcQ9ZAN93wI/sJmWM4MtQlHeCVRKq3qvQWZYYOaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRLMZCQ+5rhWTrLjUj6s2NJKPZPRMfxJgueobw2UHVc=;
 b=H3d0rZNlTV5dQ7BhbPgIsoShWxI/fxcP+b7Q90tHDRHJhjRY043r/IhQgGHlpMhcMSCeKUUbfxv59H99omRaOTACak2PrhTLAy75+DaUzJNZ2JplUSXNWBYE1Pdzzl3jGmgVzuxQ13YNM8OmKTbFM7B/WH3LB43mYyNV6AtK8lc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3791.namprd11.prod.outlook.com (20.178.254.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:14:34 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:34 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 06/55] staging: wfx: fix rate control handling
Thread-Topic: [PATCH v2 06/55] staging: wfx: fix rate control handling
Thread-Index: AQHVtPUSV3snjZp3tk+yJwmm+q7V1g==
Date:   Tue, 17 Dec 2019 16:14:34 +0000
Message-ID: <20191217161318.31402-7-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12085b06-c95a-4b02-af7f-08d7830c34df
x-ms-traffictypediagnostic: MN2PR11MB3791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB37919B9AA9ADC9F87CF2294693500@MN2PR11MB3791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(2906002)(52116002)(107886003)(2616005)(86362001)(478600001)(6486002)(4326008)(64756008)(66556008)(66476007)(81156014)(66946007)(6506007)(1076003)(316002)(66446008)(8936002)(71200400001)(81166006)(5660300002)(36756003)(26005)(186003)(8676002)(85202003)(85182001)(110136005)(54906003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3791;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QHiAspH8YJXEBnUWd0EaXPuVQPerGCKcdrEUP6Av1R76PzsWw08w27qp9nf/cR8xm04zbEAlGGY3IEUAkR40MqavZRzpi4kqrjGR2sR6JHN1flF37MnK1dPGVN2s5/eSOqi9RA4/RxnqVuPLgxCGwVONTZQ5xY/OBwZAr0qSHny8547YHuVwrVcHTExRP6pMga/lrPQvB6ktON0+IEd7SdO0jdiT/v2zNaf5sEFsKQidZUVn6nOVm2uVEF9FhW4fnpATfVhMKK0VjHZ22plmee9WTdcISisZivmgJK5Ey+8lwkmVUPddtCA78me7xi8dH+asla/d0JEEGtfx+B8k5Ky7O1Du0Jyvkg3WFatQt78kPOFCrAx1bpt0TsRnQeSPQ/q2l8KoS2rf8QQE2HVEjSegy/aJ+yJCqad16lmKIfPTxVEkuHIeffkAQDRVNEPH
Content-Type: text/plain; charset="utf-8"
Content-ID: <E88A55FE2788654FA192BCC851473106@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12085b06-c95a-4b02-af7f-08d7830c34df
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:34.8324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qjPpXTFV4XXqMjbKDX8FnlzYBbWDi/zzfkBeoqb1pEbFECFVU1sxdcoxJBNHJnNOpa3tJlqYvVpyYacOdiE8Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQSB0
eF9yZXRyeV9wb2xpY3kgKHRoZSBlcXVpdmFsZW50IG9mIGEgbGlzdCBvZiBpZWVlODAyMTFfdHhf
cmF0ZSBpbgpoYXJkd2FyZSBBUEkpIGlzIG5vdCBhYmxlIHRvIGluY2x1ZGUgYSByYXRlIG11bHRp
cGxlIHRpbWUuIFNvIGN1cnJlbnRseSwKdGhlIGRyaXZlciBtZXJnZXMgdGhlIGlkZW50aWNhbCBy
YXRlcyBmcm9tIHRoZSBwb2xpY3kgcHJvdmlkZWQgYnkKbWluc3RyZWwgKGFuZCBpdCB0cnkgdG8g
ZG8gdGhlIGJlc3QgY2hvaWNlIGl0IGNhbiBpbiB0aGUgYXNzb2NpYXRlZApmbGFncykgYmVmb3Jl
IHRvIHNlbnQgaXQgdG8gZmlybXdhcmUuCgpVbnRpbCBub3csIHdoZW4gcmF0ZXMgYXJlIG1lcmdl
ZCwgZmllbGQgImNvdW50IiBpcyBzZXQgdG8KbWF4KGNvdW50MSwgY291bnQyKS4gQnV0LCBpdCBt
ZWFucyB0aGF0IHRoZSBzdW0gb2YgcmV0cmllcyBmb3IgYWxsIHJhdGVzCmNvdWxkIGJlIGZhciBs
ZXNzIHRoYW4gaW5pdGlhbCBudW1iZXIgb2YgcmV0cmllcy4gU28sIHRoaXMgcGF0Y2ggY2hhbmdl
cwp0aGUgdmFsdWUgb2YgZmllbGQgImNvdW50IiB0byBjb3VudDEgKyBjb3VudDIuIFRodXMsIHN1
bSBvZiBhbGwgcmV0cmllcwpmb3IgYWxsIHJhdGVzIHN0YXkgdGhlIHNhbWUuCgpTaWduZWQtb2Zm
LWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgfCA2ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2RhdGFfdHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCmluZGV4
IGI3MjZkZDVlNTlmMy4uNDZhZDgzYjk1ZjUyIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2RhdGFfdHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwpAQCAtNTI0
LDkgKzUyNCw5IEBAIHN0YXRpYyB2b2lkIHdmeF90eF9maXh1cF9yYXRlcyhzdHJ1Y3QgaWVlZTgw
MjExX3R4X3JhdGUgKnJhdGVzKQogCQlmb3IgKGkgPSAwOyBpIDwgSUVFRTgwMjExX1RYX01BWF9S
QVRFUyAtIDE7IGkrKykgewogCQkJaWYgKHJhdGVzW2kgKyAxXS5pZHggPT0gcmF0ZXNbaV0uaWR4
ICYmCiAJCQkgICAgcmF0ZXNbaV0uaWR4ICE9IC0xKSB7Ci0JCQkJcmF0ZXNbaV0uY291bnQgPQot
CQkJCQltYXhfdChpbnQsIHJhdGVzW2ldLmNvdW50LAotCQkJCQkgICAgICByYXRlc1tpICsgMV0u
Y291bnQpOworCQkJCXJhdGVzW2ldLmNvdW50ICs9IHJhdGVzW2kgKyAxXS5jb3VudDsKKwkJCQlp
ZiAocmF0ZXNbaV0uY291bnQgPiAxNSkKKwkJCQkJcmF0ZXNbaV0uY291bnQgPSAxNTsKIAkJCQly
YXRlc1tpICsgMV0uaWR4ID0gLTE7CiAJCQkJcmF0ZXNbaSArIDFdLmNvdW50ID0gMDsKIAotLSAK
Mi4yNC4wCgo=
