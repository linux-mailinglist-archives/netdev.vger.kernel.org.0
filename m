Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B5417D14D
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 04:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgCHDz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 22:55:59 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10400 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbgCHDz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 22:55:59 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0283tAWQ026854;
        Sat, 7 Mar 2020 19:55:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=qdZ/vn3bHhysvv1QtgEvgFqxPoO4vvTNif9CUS4Xkc0=;
 b=VIk+Zcpd1gDYm0XqfFQZ5IBBnJM0hWXHHYohUrogszsIMO4TLDaUhg6/xnUJvqUWv4th
 hMM+vGNE1q7osuShuvY68DQIGu+akgOEoOZ/yXs/JemcvkZU1JPdEYE3tYkxP9ei42AB
 sg36SxNYsKM+9qp5AriIbLxVudrrzogM0NM2CR2/GMr4Zt45+/+19Y/K6R2BLrlz4u0Y
 2F3hzIuA/gogdimuFdyBAWKgks4K/6l/CYfy6ZJmKPtH+qPkhMskOGOfjXYnrIo4FnJt
 JgNGc4A9Kklur/fe/xJgplg+ehzcGIoCMs2Hz2bpsOdEUw+Ik31X9s0LyzhW4cCYldE2 uQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ymc0sj24f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 19:55:28 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:55:26 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 19:55:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6uupuh5/ZHrMp4BWEpqaiolF77uAduM43m9N8lIXxVf+liFwZBfz8ONf0LG79LH2ETcL3tm6ti/TZccWU4a/H7j6fP1wjuEdsBtpReL43F4GSLe3tOUwTJ3mHLzmMIq9bgcZFUM89R0xMHMy8a/vtJFLKsjC0Cw+wt9fE0aOOX+liJTSmyCOMF9LepRf4pJhUD/+LwrKBPhxYQ9Dsl50aVg3eHveEh+8Z/cWhbz8cQdQxKQja8yx6bA3yMWIdC6vrNpD4kqJyFWLcPYH1e6izaYfSTAINcrifl5VwoY3a1FJBbcdIDO2VGT+8dSnw45GrBpdN2Vd5f/iLhfQPiBWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdZ/vn3bHhysvv1QtgEvgFqxPoO4vvTNif9CUS4Xkc0=;
 b=XwCuE06Xn12upIYN8GHo5z/qd9b5aZ0guJLKTJ0O3znmgBS4yb0CTm3dnzbo6HwqOud4TaVf9DeWLETiZqcV8Mmyt4dkN3nZuZgte3HBoH0NuJdtsUmqvthK+gd0+0u1vpZg9iQZxDpkYqsm7UUKplO1cr7WKLkx1riDAyz/aXbJJOGAQdGc2+jWf5Fa/UW9ZpaFz5eA9ZqzvF9TuNXo7ZeGYqxq442AAlIxG5goWrQxae3RPeG9Z2r3EY4KFtO+fu1AOQ0X1e5rUq+fy21fsE80OVZhppxqJ2yPtqPGhzNTDLmDWFe4AK8RttqnW3GWqC29xpxQ1SctmaJXShWvwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdZ/vn3bHhysvv1QtgEvgFqxPoO4vvTNif9CUS4Xkc0=;
 b=WQNpW3dBMEj4T/4XY9zYZzjAX/djRBfZ5spBckvNdYi3UOY5/TwLdQ9xzFNVQy1uRCrGc8981m57HxDCvvwo8PohBn8P6wq/vck8f/CbwGrNl2Mv07CSs++Hp5yXk588TJYP8O+n5ZnPKpyT1YigC8TXhOacciAeMdNAQ8pHhgU=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2661.namprd18.prod.outlook.com (2603:10b6:a03:136::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Sun, 8 Mar
 2020 03:55:25 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 03:55:25 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>
Subject: [PATCH v2 10/12] task_isolation: ringbuffer: don't interrupt CPUs
 running isolated tasks on buffer resize
Thread-Topic: [PATCH v2 10/12] task_isolation: ringbuffer: don't interrupt
 CPUs running isolated tasks on buffer resize
Thread-Index: AQHV9P1lnq03GLPAlkGSNgjYIgfZQg==
Date:   Sun, 8 Mar 2020 03:55:24 +0000
Message-ID: <5add46d3bfbdac3fb42dcef6b6e4ea0e39abe11f.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
In-Reply-To: <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b52a88a-a37f-456f-a47a-08d7c3148868
x-ms-traffictypediagnostic: BYAPR18MB2661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2661752785E60C067A6C9154BCE10@BYAPR18MB2661.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39850400004)(346002)(376002)(189003)(199004)(36756003)(71200400001)(4326008)(86362001)(2906002)(54906003)(110136005)(316002)(2616005)(8936002)(81156014)(8676002)(81166006)(26005)(186003)(66446008)(66476007)(64756008)(66556008)(66946007)(5660300002)(76116006)(478600001)(7416002)(91956017)(6486002)(6512007)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2661;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pHI0fRpVX5NZyPb4d79CwPjPYOflsOWaMl9oUuul1CUZRwJD681Zsh91Qmz2pA8jiH+Oz4Du/2BIx3iEjSlv/nOShfM4/VZftY7h9yFzETiDm2Z1gO51YVu+upITaoyGmuQLj+1lLnubjnhaKWbO1W0FfKeV2JuW0lyEMFumpigXXfCueL0H4x8R9XA6M8i82MtVLMpN4p+Zk2TXquT2NH0W5d5EHmLWACoqKBlxoqA2ZMSSSAIyWdycA9fWNY+jVsInFEWreqk10iP7yyHHiSiQ4YD2JV4Dzc5l4N0hxo273z1hwdHkMdQXDZLVeV83gis9k/epAcHigHahT9hoIzEoPykZYXdvyjofGIG4fNR88LeGUYD6TMwlgShInoT4mtCuSQ68YU7GFeb+oZOEpqz8pi1XepbjfbqaLArTXc17nhG/V0A06t43v19Ec07K
x-ms-exchange-antispam-messagedata: 5/B5jPgGH3F5LXyL2WktlHPLgZc6r0RTrmWS3rftadfeDmO4hZNN9FJNFbWZTUF/W8BhSDiUcaRf3DMmCE5zCucaJXTqcaSDfmrPKPQuntgcOQbwEmMun/RQGbuNy+nZ2hnseVzGeO8euJK1i03JtQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <3896D0563E38F142822135338FAF4CA2@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b52a88a-a37f-456f-a47a-08d7c3148868
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 03:55:24.9437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cs/xat34kBHw6Q5eVwXhdA9GSVSZ8BbChTP1sBeYuLW3FP/OaamY5jusSKEaxVjIJTEMJ+vKHMxjONYaiTP7pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2661
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-07_09:2020-03-06,2020-03-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KDQpDUFVzIHJ1bm5pbmcgaXNv
bGF0ZWQgdGFza3MgYXJlIGluIHVzZXJzcGFjZSwgc28gdGhleSBkb24ndCBoYXZlIHRvDQpwZXJm
b3JtIHJpbmcgYnVmZmVyIHVwZGF0ZXMgaW1tZWRpYXRlbHkuIElmIHJpbmdfYnVmZmVyX3Jlc2l6
ZSgpDQpzY2hlZHVsZXMgdGhlIHVwZGF0ZSBvbiB0aG9zZSBDUFVzLCBpc29sYXRpb24gaXMgYnJv
a2VuLiBUbyBwcmV2ZW50DQp0aGF0LCB1cGRhdGVzIGZvciBDUFVzIHJ1bm5pbmcgaXNvbGF0ZWQg
dGFza3MgYXJlIHBlcmZvcm1lZCBsb2NhbGx5LA0KbGlrZSBmb3Igb2ZmbGluZSBDUFVzLg0KDQpB
IHJhY2UgY29uZGl0aW9uIGJldHdlZW4gdGhpcyB1cGRhdGUgYW5kIGlzb2xhdGlvbiBicmVha2lu
ZyBpcyBhdm9pZGVkDQphdCB0aGUgY29zdCBvZiBkaXNhYmxpbmcgcGVyX2NwdSBidWZmZXIgd3Jp
dGluZyBmb3IgdGhlIHRpbWUgb2YgdXBkYXRlDQp3aGVuIGl0IGNvaW5jaWRlcyB3aXRoIGlzb2xh
dGlvbiBicmVha2luZy4NCg0KU2lnbmVkLW9mZi1ieTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZl
bGwuY29tPg0KW2FiZWxpdHNAbWFydmVsbC5jb206IHVwZGF0ZWQgdG8gcHJldmVudCByYWNlIHdp
dGggaXNvbGF0aW9uIGJyZWFraW5nXQ0KU2lnbmVkLW9mZi1ieTogQWxleCBCZWxpdHMgPGFiZWxp
dHNAbWFydmVsbC5jb20+DQotLS0NCiBrZXJuZWwvdHJhY2UvcmluZ19idWZmZXIuYyB8IDYyICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tDQogMSBmaWxlIGNoYW5nZWQsIDU2
IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9rZXJuZWwvdHJh
Y2UvcmluZ19idWZmZXIuYyBiL2tlcm5lbC90cmFjZS9yaW5nX2J1ZmZlci5jDQppbmRleCA2MWYw
ZTkyYWNlOTkuLjU5M2VmZmU0MDE4MyAxMDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS9yaW5nX2J1
ZmZlci5jDQorKysgYi9rZXJuZWwvdHJhY2UvcmluZ19idWZmZXIuYw0KQEAgLTIxLDYgKzIxLDcg
QEANCiAjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0K
ICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0K
ICNpbmNsdWRlIDxsaW51eC9oYXNoLmg+DQogI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4NCiAjaW5j
bHVkZSA8bGludXgvY3B1Lmg+DQpAQCAtMTcwMSw2ICsxNzAyLDM3IEBAIHN0YXRpYyB2b2lkIHVw
ZGF0ZV9wYWdlc19oYW5kbGVyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAJY29tcGxldGUo
JmNwdV9idWZmZXItPnVwZGF0ZV9kb25lKTsNCiB9DQogDQorc3RhdGljIGJvb2wgdXBkYXRlX2lm
X2lzb2xhdGVkKHN0cnVjdCByaW5nX2J1ZmZlcl9wZXJfY3B1ICpjcHVfYnVmZmVyLA0KKwkJCSAg
ICAgICBpbnQgY3B1KQ0KK3sNCisJYm9vbCBydiA9IGZhbHNlOw0KKw0KKwlpZiAodGFza19pc29s
YXRpb25fb25fY3B1KGNwdSkpIHsNCisJCS8qDQorCQkgKiBDUFUgaXMgcnVubmluZyBpc29sYXRl
ZCB0YXNrLiBTaW5jZSBpdCBtYXkgbG9zZQ0KKwkJICogaXNvbGF0aW9uIGFuZCByZS1lbnRlciBr
ZXJuZWwgc2ltdWx0YW5lb3VzbHkgd2l0aA0KKwkJICogdGhpcyB1cGRhdGUsIGRpc2FibGUgcmVj
b3JkaW5nIHVudGlsIGl0J3MgZG9uZS4NCisJCSAqLw0KKwkJYXRvbWljX2luYygmY3B1X2J1ZmZl
ci0+cmVjb3JkX2Rpc2FibGVkKTsNCisJCS8qIE1ha2Ugc3VyZSwgdXBkYXRlIGlzIGRvbmUsIGFu
ZCBpc29sYXRpb24gc3RhdGUgaXMgY3VycmVudCAqLw0KKwkJc21wX21iKCk7DQorCQlpZiAodGFz
a19pc29sYXRpb25fb25fY3B1KGNwdSkpIHsNCisJCQkvKg0KKwkJCSAqIElmIENQVSBpcyBzdGls
bCBydW5uaW5nIGlzb2xhdGVkIHRhc2ssIHdlDQorCQkJICogY2FuIGJlIHN1cmUgdGhhdCBicmVh
a2luZyBpc29sYXRpb24gd2lsbA0KKwkJCSAqIGhhcHBlbiB3aGlsZSByZWNvcmRpbmcgaXMgZGlz
YWJsZWQsIGFuZCBDUFUNCisJCQkgKiB3aWxsIG5vdCB0b3VjaCB0aGlzIGJ1ZmZlciB1bnRpbCB0
aGUgdXBkYXRlDQorCQkJICogaXMgZG9uZS4NCisJCQkgKi8NCisJCQlyYl91cGRhdGVfcGFnZXMo
Y3B1X2J1ZmZlcik7DQorCQkJY3B1X2J1ZmZlci0+bnJfcGFnZXNfdG9fdXBkYXRlID0gMDsNCisJ
CQlydiA9IHRydWU7DQorCQl9DQorCQlhdG9taWNfZGVjKCZjcHVfYnVmZmVyLT5yZWNvcmRfZGlz
YWJsZWQpOw0KKwl9DQorCXJldHVybiBydjsNCit9DQorDQogLyoqDQogICogcmluZ19idWZmZXJf
cmVzaXplIC0gcmVzaXplIHRoZSByaW5nIGJ1ZmZlcg0KICAqIEBidWZmZXI6IHRoZSBidWZmZXIg
dG8gcmVzaXplLg0KQEAgLTE3ODQsMTMgKzE4MTYsMjIgQEAgaW50IHJpbmdfYnVmZmVyX3Jlc2l6
ZShzdHJ1Y3QgdHJhY2VfYnVmZmVyICpidWZmZXIsIHVuc2lnbmVkIGxvbmcgc2l6ZSwNCiAJCQlp
ZiAoIWNwdV9idWZmZXItPm5yX3BhZ2VzX3RvX3VwZGF0ZSkNCiAJCQkJY29udGludWU7DQogDQot
CQkJLyogQ2FuJ3QgcnVuIHNvbWV0aGluZyBvbiBhbiBvZmZsaW5lIENQVS4gKi8NCisJCQkvKg0K
KwkJCSAqIENhbid0IHJ1biBzb21ldGhpbmcgb24gYW4gb2ZmbGluZSBDUFUuDQorCQkJICoNCisJ
CQkgKiBDUFVzIHJ1bm5pbmcgaXNvbGF0ZWQgdGFza3MgZG9uJ3QgaGF2ZSB0bw0KKwkJCSAqIHVw
ZGF0ZSByaW5nIGJ1ZmZlcnMgdW50aWwgdGhleSBleGl0DQorCQkJICogaXNvbGF0aW9uIGJlY2F1
c2UgdGhleSBhcmUgaW4NCisJCQkgKiB1c2Vyc3BhY2UuIFVzZSB0aGUgcHJvY2VkdXJlIHRoYXQg
cHJldmVudHMNCisJCQkgKiByYWNlIGNvbmRpdGlvbiB3aXRoIGlzb2xhdGlvbiBicmVha2luZy4N
CisJCQkgKi8NCiAJCQlpZiAoIWNwdV9vbmxpbmUoY3B1KSkgew0KIAkJCQlyYl91cGRhdGVfcGFn
ZXMoY3B1X2J1ZmZlcik7DQogCQkJCWNwdV9idWZmZXItPm5yX3BhZ2VzX3RvX3VwZGF0ZSA9IDA7
DQogCQkJfSBlbHNlIHsNCi0JCQkJc2NoZWR1bGVfd29ya19vbihjcHUsDQotCQkJCQkJJmNwdV9i
dWZmZXItPnVwZGF0ZV9wYWdlc193b3JrKTsNCisJCQkJaWYgKCF1cGRhdGVfaWZfaXNvbGF0ZWQo
Y3B1X2J1ZmZlciwgY3B1KSkNCisJCQkJCXNjaGVkdWxlX3dvcmtfb24oY3B1LA0KKwkJCQkJJmNw
dV9idWZmZXItPnVwZGF0ZV9wYWdlc193b3JrKTsNCiAJCQl9DQogCQl9DQogDQpAQCAtMTgyOSwx
MyArMTg3MCwyMiBAQCBpbnQgcmluZ19idWZmZXJfcmVzaXplKHN0cnVjdCB0cmFjZV9idWZmZXIg
KmJ1ZmZlciwgdW5zaWduZWQgbG9uZyBzaXplLA0KIA0KIAkJZ2V0X29ubGluZV9jcHVzKCk7DQog
DQotCQkvKiBDYW4ndCBydW4gc29tZXRoaW5nIG9uIGFuIG9mZmxpbmUgQ1BVLiAqLw0KKwkJLyoN
CisJCSAqIENhbid0IHJ1biBzb21ldGhpbmcgb24gYW4gb2ZmbGluZSBDUFUuDQorCQkgKg0KKwkJ
ICogQ1BVcyBydW5uaW5nIGlzb2xhdGVkIHRhc2tzIGRvbid0IGhhdmUgdG8gdXBkYXRlDQorCQkg
KiByaW5nIGJ1ZmZlcnMgdW50aWwgdGhleSBleGl0IGlzb2xhdGlvbiBiZWNhdXNlIHRoZXkNCisJ
CSAqIGFyZSBpbiB1c2Vyc3BhY2UuIFVzZSB0aGUgcHJvY2VkdXJlIHRoYXQgcHJldmVudHMNCisJ
CSAqIHJhY2UgY29uZGl0aW9uIHdpdGggaXNvbGF0aW9uIGJyZWFraW5nLg0KKwkJICovDQogCQlp
ZiAoIWNwdV9vbmxpbmUoY3B1X2lkKSkNCiAJCQlyYl91cGRhdGVfcGFnZXMoY3B1X2J1ZmZlcik7
DQogCQllbHNlIHsNCi0JCQlzY2hlZHVsZV93b3JrX29uKGNwdV9pZCwNCisJCQlpZiAoIXVwZGF0
ZV9pZl9pc29sYXRlZChjcHVfYnVmZmVyLCBjcHVfaWQpKQ0KKwkJCQlzY2hlZHVsZV93b3JrX29u
KGNwdV9pZCwNCiAJCQkJCSAmY3B1X2J1ZmZlci0+dXBkYXRlX3BhZ2VzX3dvcmspOw0KLQkJCXdh
aXRfZm9yX2NvbXBsZXRpb24oJmNwdV9idWZmZXItPnVwZGF0ZV9kb25lKTsNCisJCQkJd2FpdF9m
b3JfY29tcGxldGlvbigmY3B1X2J1ZmZlci0+dXBkYXRlX2RvbmUpOw0KKwkJCX0NCiAJCX0NCiAN
CiAJCWNwdV9idWZmZXItPm5yX3BhZ2VzX3RvX3VwZGF0ZSA9IDA7DQotLSANCjIuMjAuMQ0KDQo=
