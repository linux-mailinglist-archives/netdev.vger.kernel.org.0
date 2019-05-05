Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118DE13EDB
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfEEKcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:32:20 -0400
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:11621
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbfEEKcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 06:32:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yei/+/M5/j2Pg6KMJoTCC7LbkU4bfvCBHzNTIa4qDhQ=;
 b=IP+qS1BnIdolu/+MovM7muTLvu1wbPNUi4uDjIJVb7UzEKBBiXom8tXLLIIcaKifoV3lzxBaKicJUKSww4T69BUbFentOTmWS+cuIHJNHWVw5ZUFgi4rpkamopjf36PFkEYP74itVg/CLe7a534o72875MDWxe86R1S0J5utaNY=
Received: from AM4PR0302MB2739.eurprd03.prod.outlook.com (10.171.85.142) by
 AM4PR0302MB2659.eurprd03.prod.outlook.com (10.171.86.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Sun, 5 May 2019 10:32:15 +0000
Received: from AM4PR0302MB2739.eurprd03.prod.outlook.com
 ([fe80::ed44:f56b:72e1:f766]) by AM4PR0302MB2739.eurprd03.prod.outlook.com
 ([fe80::ed44:f56b:72e1:f766%5]) with mapi id 15.20.1856.012; Sun, 5 May 2019
 10:32:15 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Greg KH <greg@kroah.com>
CC:     "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
Subject: Re: [net-next v2] net: sched: Introduce act_ctinfo action
Thread-Topic: [net-next v2] net: sched: Introduce act_ctinfo action
Thread-Index: AQHVAyt/SC3QmOI5f0a3vJokwFo61aZcUsEAgAACgwA=
Date:   Sun, 5 May 2019 10:32:15 +0000
Message-ID: <B6426224-12CC-417B-9A38-6DDBE574A85C@darbyshire-bryant.me.uk>
References: <CAM_iQpXnXyfLZ2+gjDufbdMrZLgtf9uKbzbUf50Xm-2Go7maVw@mail.gmail.com>
 <20190505101523.48425-1-ldir@darbyshire-bryant.me.uk>
 <20190505102314.GA12761@kroah.com>
In-Reply-To: <20190505102314.GA12761@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1240:ee00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7efc574-f1e0-4f3d-db5e-08d6d144f10d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM4PR0302MB2659;
x-ms-traffictypediagnostic: AM4PR0302MB2659:
x-microsoft-antispam-prvs: <AM4PR0302MB2659B05C235B452A368A0C45C9370@AM4PR0302MB2659.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:549;
x-forefront-prvs: 00286C0CA6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(39830400003)(396003)(366004)(189003)(199004)(51914003)(25786009)(33656002)(99286004)(4326008)(66556008)(86362001)(76176011)(76116006)(91956017)(66446008)(64756008)(66946007)(66476007)(73956011)(6916009)(71190400001)(71200400001)(83716004)(8936002)(82746002)(68736007)(316002)(229853002)(74482002)(6116002)(14454004)(46003)(6486002)(6512007)(305945005)(508600001)(186003)(53936002)(8676002)(486006)(7736002)(54906003)(476003)(2616005)(2906002)(446003)(11346002)(5660300002)(6506007)(53546011)(6246003)(102836004)(6436002)(256004)(4744005)(81156014)(81166006)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0302MB2659;H:AM4PR0302MB2739.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1Rq99rmCA8RVw8JReFskRNE2TiSJa3q+J9wWGwkZHY6I1RSG4I9rg9oMtMP5e6lJxT/N01bmCeDpRzwBaVztAuDeueHa3jPQYZRBRSIRS7OY8b+wDG2RocC/5kRlhA081+NdHRA0KqC77jOHys0jLBYG5kwvkFXDbErNZCNk3jPyT+i7mG1JvnRAvU3VqXYnuRibg2v7KnlGBV1Vuc9t2+dyn9nilo67+nuUkw5y6WqK9sKn2xvSO9QDdvnhe/5EZjLbWDTsYWmiSgB6D42q1KrJmpOs/4afGI2H43WuGfZGBByAh1jqCoJ732x6Vd4gFECf5qRtlzPb0qTFAO+JygKVEsbeknY+BoYElY/7B/unh22imwJj/H0sXY0UrSbpRxooKKrdVhgICFJ4pBvXozV4uMfLfRqBinMBXXcZBKg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8741B9DAE7D6A46BAD3338B68FCB923@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: a7efc574-f1e0-4f3d-db5e-08d6d144f10d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2019 10:32:15.0641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0302MB2659
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gNSBNYXkgMjAxOSwgYXQgMTE6MjMsIEdyZWcgS0ggPGdyZWdAa3JvYWguY29tPiB3
cm90ZToNCj4gDQo+IE9uIFN1biwgTWF5IDA1LCAyMDE5IGF0IDEwOjE1OjQzQU0gKzAwMDAsIEtl
dmluICdsZGlyJyBEYXJieXNoaXJlLUJyeWFudCB3cm90ZToNCj4+IC0tLSAvZGV2L251bGwNCj4+
ICsrKyBiL25ldC9zY2hlZC9hY3RfY3RpbmZvLmMNCj4+IEBAIC0wLDAgKzEsNDA3IEBADQo+PiAr
Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgV0lUSCBMaW51eC1zeXNjYWxsLW5v
dGUNCj4gDQoNCkhleSBHcmVnLCB0aGFua3MgZm9yIHRoZSByZXZpZXcuDQoNCj4gSG93IGNhbiBh
IC5jIGZpbGUsIGJ1cmllZCBpbiB0aGUga2VybmVsIHRyZWUsIGhhdmUgYSBMaW51eC1zeXNjYWxs
LW5vdGUNCj4gZXhjZXB0aW9uIHRvIGl0Pw0KDQpCZWNhdXNlIEnigJltIGEgbW9yb24gYW5kIG5v
Ym9keSBlbHNlIHNwb3R0ZWQgaXQuDQo+IA0KPiBBcmUgeW91IF9zdXJlXyB0aGF0IGlzIG9rPyAg
VGhhdCBsaWNlbnNlIHNob3VsZCBvbmx5IGJlIGZvciBmaWxlcyBpbiB0aGUNCj4gdWFwaSBoZWFk
ZXIgZGlyZWN0b3J5Lg0KDQpFeHBlY3QgYSB2MyBzaG9ydGx5LiAgSSBzaGFsbCB3ZWFyIHlvdXIg
Y2hhc3Rpc2VtZW50IHdpdGggaG9ub3VyIDotKQ0KDQoNCkNoZWVycywNCg0KS2V2aW4gRC1CDQoN
CmdwZzogMDEyQyBBQ0IyIDI4QzYgQzUzRSA5Nzc1ICA5MTIzIEIzQTIgMzg5QiA5REUyIDMzNEEN
Cg0K
