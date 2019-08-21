Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 033059779E
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 12:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfHUKx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 06:53:26 -0400
Received: from mail-eopbgr10117.outbound.protection.outlook.com ([40.107.1.117]:1089
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726389AbfHUKxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 06:53:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gW5xSffWhj7BouYaJMeO8dfcZLJwjihOCS6UmRys77hbDU0Eu/0JgfDoNvG3S6CzZOUmFbmhKfzNsUxPNS29nraofNJdR9RVR51TXtNEZqSatvKwNp8QaEe0yG65ih/vm6bARX/vspUUK0xqyXnA31Or67np6jOHaHUFcEPRDGcEpxQz6mD9iFvg4hXFhqHk1SaZ2fAstNv4hhmjRhcNshPt66KzFZAAVl7pneaRL65HlPKUAfmApDnaMiDM0LG2xyN0E8TOiAVZw5n25+ynG16jV2+niPatkYJyhIzU8ji7zETpq9j88gFcwEt5KG5x3FeVJPYS+rspQ1RFAwYHbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTGwTFGMyPoOX/IW6AtCQ3kqKN6vMWllKPdvyhsRRLI=;
 b=Vz/vFOMYeHOXOE6cQi2NJfGbTehxenFPSqbMHCqxXipR+NcQXBrzdzenFwYmsICtxyNjAzFZM2hTTWiDeuKr5PvqjfsNAYOLAWycTjvvfq5mmGHC1mpTgbid+pcEkM5dOkyhYL/lJzK0IW0iAinH76kn+cdxPtSrlfsTF4I5yzhe+8SZaGCYm7rJ7gXBsTB/+LfQ47RUkKi3Abqq19IHRTnsxMNZay4T36bh5xhfLSVc8yVG6MufdtnjMsaWgZeAIVz+VQLDLT7kUCl/p1UrZQpRKF6vRDYaRhx5YVd4XrsVpNCJC+kyQmc/YvXXsztGmg2k3UK/l6KCaoSzjYKD/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTGwTFGMyPoOX/IW6AtCQ3kqKN6vMWllKPdvyhsRRLI=;
 b=DgKFVMscJ94Jig8KqDQSS+DL3/rBAkgwwUekmwu1tPeHlmnA+23cvHZ+HYMYVjbS8eZEy3XUtekhgGjS/Wdtw6PnN7+3zRmZgKY4WBP61OlT5DGQfOuUxRuD9N54AhdfRvn44YJO7l7odF2bRqXpebssiOf0chfqiCHaZCFhTJg=
Received: from AM0PR07MB4819.eurprd07.prod.outlook.com (20.178.19.14) by
 AM0PR07MB6083.eurprd07.prod.outlook.com (20.178.113.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.12; Wed, 21 Aug 2019 10:53:21 +0000
Received: from AM0PR07MB4819.eurprd07.prod.outlook.com
 ([fe80::3855:624c:a577:48dd]) by AM0PR07MB4819.eurprd07.prod.outlook.com
 ([fe80::3855:624c:a577:48dd%4]) with mapi id 15.20.2199.011; Wed, 21 Aug 2019
 10:53:21 +0000
From:   "Tilmans, Olivier (Nokia - BE/Antwerp)" 
        <olivier.tilmans@nokia-bell-labs.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Olga Albisser <olga@albisser.org>,
        "De Schepper, Koen (Nokia - BE/Antwerp)" 
        <koen.de_schepper@nokia-bell-labs.com>,
        Bob Briscoe <research@bobbriscoe.net>,
        Henrik Steen <henrist@henrist.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4] sched: Add dualpi2 qdisc
Thread-Topic: [PATCH net-next v4] sched: Add dualpi2 qdisc
Thread-Index: AQHVV/rXfx5/9MypUUqy4U+vAsfo3acFaYuA
Date:   Wed, 21 Aug 2019 10:53:20 +0000
Message-ID: <20190821103947.kxb2mixecndcelb6@nokia-bell-labs.com>
References: <20190821081150.31838-1-olivier.tilmans@nokia-bell-labs.com>
In-Reply-To: <20190821081150.31838-1-olivier.tilmans@nokia-bell-labs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0048.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::36) To AM0PR07MB4819.eurprd07.prod.outlook.com
 (2603:10a6:208:f3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=olivier.tilmans@nokia-bell-labs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [131.228.32.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b42fca15-0fcf-450a-2a2a-08d72625c807
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR07MB6083;
x-ms-traffictypediagnostic: AM0PR07MB6083:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR07MB6083E4225D16B3C0E0CE3FCEE0AA0@AM0PR07MB6083.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(189003)(199004)(53936002)(6246003)(25786009)(229853002)(7416002)(8676002)(386003)(81166006)(102836004)(486006)(6506007)(186003)(2201001)(26005)(81156014)(476003)(2616005)(6116002)(86362001)(446003)(11346002)(3846002)(71200400001)(71190400001)(256004)(66066001)(8936002)(52116002)(99286004)(76176011)(5660300002)(2906002)(7736002)(478600001)(305945005)(6512007)(6436002)(2501003)(6486002)(1076003)(66946007)(66556008)(66476007)(66446008)(64756008)(14454004)(36756003)(316002)(110136005)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR07MB6083;H:AM0PR07MB4819.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:0;
received-spf: None (protection.outlook.com: nokia-bell-labs.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +isfXFcTTs+LQcFkYQlz0RMo2yUEpGXhUFXJwiMCn2bUv/YiyrJTQK+9ipV5asLmV/FXpPHc60XHPSKfOIi4pC2oHuGweYBoNcBaUXSkFZO+w/rWO0UipsLLOiqeFEPRn/qpgppzc9Fp2jDNYnKcGpVy1J9udqLebGi9F9YW8LGGWJrHHlVoIIZfaYdihAL9jeOwOpGQcnIr7+Xv/nu3nnU6NETK4HiNq1/4rNhe7E6+5c4OOB/TB1PFAZGnLtMvmdtds+aAmEEbeAFV6pwPxT5yC0lwVsFWnwCPwoXbimBVNyX77d5NdAACqfkhV+St4v+ksSf1KBrg1Q7jemJqKBnGtyXewfl6WyRlVFXyRLVWHJTdepwTOkVi8t+g7J3prr1DyMURaxYUhc/T3cAo487YCaktup/kjilY6QDno/4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D48B55A59CCF0438950FF20F80DC7AD@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b42fca15-0fcf-450a-2a2a-08d72625c807
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 10:53:21.0714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T6j5f8wrRqPIjaHw8l+o0dTAf/dh0kHIXHiW3/V4829YiwZ7hIoe05LfGoK+B8zkr0achDdY8UjZ+PsvztImmIfcjT+f6caCXYlRRkLj8MSRff7e2T/q5BzENnTrq4+m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB6083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiArc3RhdGljIHM2NCBfX3NjYWxlX2RlbHRhKHM2NCBkaWZmKQ0KPiArew0KPiArCWRvX2Rpdihk
aWZmLCAoMSA8PCAoQUxQSEFfQkVUQV9HUkFOVUxBUklUWSArIDEpKSAtIDEpOw0KPiArCXJldHVy
biBkaWZmOw0KPiArfQ0KWy4uLl0NCj4gKwlkZWx0YSA9IF9fc2NhbGVfZGVsdGEoKChzNjQpcWRl
bGF5IC0gcS0+cGkyLnRhcmdldCkgKiBxLT5waTIuYWxwaGEpOw0KPiArCWRlbHRhICs9IF9fc2Nh
bGVfZGVsdGEoKChzNjQpcWRlbGF5IC0gcWRlbGF5X29sZCkgKiBxLT5waTIuYmV0YSk7DQoNCkkg
anVzdCBub3RpY2VkIHRoYXQgZW5zdXJpbmcgNjRiIGRpdmlkZSBjb21wYXRpYmlsaXR5IGFjcm9z
cyBwbGF0Zm9ybXMgDQp1c2luZyBkb19kaXYoKSBpbnRyb2R1Y2VkIHRoaXMgYnVnLCBhcyBkb19k
aXYoKSB3b3JrcyB3aXRoIHVuc2lnbmVkIG9wZXJhbmRzLg0KDQpUaGlzIHdpbGwgYmUgZml4ZWQg
aW4gYSBsYXRlciB2NSB3aXRoIHRoZSBmb2xsb3dpbmcgcGF0Y2g6DQoNCi0tLQ0KIG5ldC9zY2hl
ZC9zY2hfZHVhbHBpMi5jIHwgMTQgKysrKysrKystLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgOCBp
bnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL3Nj
aF9kdWFscGkyLmMgYi9uZXQvc2NoZWQvc2NoX2R1YWxwaTIuYw0KaW5kZXggYTY0NTJhYTgyMDE4
Li5jNmM4NTE0OTlkMzUgMTAwNjQ0DQotLS0gYS9uZXQvc2NoZWQvc2NoX2R1YWxwaTIuYw0KKysr
IGIvbmV0L3NjaGVkL3NjaF9kdWFscGkyLmMNCkBAIC0zODUsNyArMzg1LDcgQEAgc3RhdGljIHN0
cnVjdCBza19idWZmICpkdWFscGkyX3FkaXNjX2RlcXVldWUoc3RydWN0IFFkaXNjICpzY2gpDQog
CXJldHVybiBza2I7DQogfQ0KIA0KLXN0YXRpYyBzNjQgX19zY2FsZV9kZWx0YShzNjQgZGlmZikN
CitzdGF0aWMgczY0IF9fc2NhbGVfZGVsdGEodTY0IGRpZmYpDQogew0KIAlkb19kaXYoZGlmZiwg
KDEgPDwgKEFMUEhBX0JFVEFfR1JBTlVMQVJJVFkgKyAxKSkgLSAxKTsNCiAJcmV0dXJuIGRpZmY7
DQpAQCAtNDA2LDE2ICs0MDYsMTggQEAgc3RhdGljIHUzMiBjYWxjdWxhdGVfcHJvYmFiaWxpdHko
c3RydWN0IFFkaXNjICpzY2gpDQogCS8qIEFscGhhIGFuZCBiZXRhIHRha2UgYXQgbW9zdCAzMmIs
IGkuZSwgdGhlIGRlbGF5IGRpZmZlcmVuY2Ugd291bGQNCiAJICogb3ZlcmZsb3cgZm9yIHF1ZXVl
aW5nIGRlbGF5IGRpZmZlcmVuY2VzID4gfjQuMnNlYy4NCiAJICovDQotCWRlbHRhID0gX19zY2Fs
ZV9kZWx0YSgoKHM2NClxZGVsYXkgLSBxLT5waTIudGFyZ2V0KSAqIHEtPnBpMi5hbHBoYSk7DQot
CWRlbHRhICs9IF9fc2NhbGVfZGVsdGEoKChzNjQpcWRlbGF5IC0gcWRlbGF5X29sZCkgKiBxLT5w
aTIuYmV0YSk7DQotCW5ld19wcm9iID0gZGVsdGEgKyBxLT5waTIucHJvYjsNCisJZGVsdGEgPSAo
KHM2NClxZGVsYXkgLSBxLT5waTIudGFyZ2V0KSAqIHEtPnBpMi5hbHBoYTsNCisJZGVsdGEgKz0g
KChzNjQpcWRlbGF5IC0gcWRlbGF5X29sZCkgKiBxLT5waTIuYmV0YTsNCiAJLyogUHJldmVudCBv
dmVyZmxvdyAqLw0KIAlpZiAoZGVsdGEgPiAwKSB7DQorCQluZXdfcHJvYiA9IF9fc2NhbGVfZGVs
dGEoZGVsdGEpICsgcS0+cGkyLnByb2I7DQogCQlpZiAobmV3X3Byb2IgPCBxLT5waTIucHJvYikN
CiAJCQluZXdfcHJvYiA9IE1BWF9QUk9COw0KKwl9IGVsc2Ugew0KKwkJbmV3X3Byb2IgPSBxLT5w
aTIucHJvYiAtIF9fc2NhbGVfZGVsdGEoZGVsdGEgKiAtMSk7DQogCQkvKiBQcmV2ZW50IHVuZGVy
ZmxvdyAqLw0KLQl9IGVsc2UgaWYgKG5ld19wcm9iID4gcS0+cGkyLnByb2IpIHsNCi0JCW5ld19w
cm9iID0gMDsNCisJCWlmIChuZXdfcHJvYiA+IHEtPnBpMi5wcm9iKQ0KKwkJCW5ld19wcm9iID0g
MDsNCiAJfQ0KIAkvKiBJZiB3ZSBkbyBub3QgZHJvcCBvbiBvdmVybG9hZCwgZW5zdXJlIHdlIGNh
cCB0aGUgTDRTIHByb2JhYmlsaXR5IHRvDQogCSAqIDEwMCUgdG8ga2VlcCB3aW5kb3cgZmFpcm5l
c3Mgd2hlbiBvdmVyZmxvd2luZy4NCi0tIA0KDQpTb3JyeSBmb3IgdGhpcy4NCg0KDQpCZXN0LA0K
T2xpdmllcg0K
