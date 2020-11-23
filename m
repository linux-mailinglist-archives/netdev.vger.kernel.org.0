Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0502C12B7
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390585AbgKWR7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:59:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46840 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390562AbgKWR7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:59:19 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANHsitC021505;
        Mon, 23 Nov 2020 09:58:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=6sfi8us8khBcVaHLEcbGHrXGjcwBkTMGdxvJ+kVM7BE=;
 b=HcUYG0LEmGg7MdhLhn5gPrfw+jdPyuE7nJfKJgI7WA1q21mO17ZYUCCi6B9J+/Iyuqxn
 ILolWu21oJpWRX3dCh//BgjtJmPih8LwnVL/xCH+NFXMF/EG+DxSdxx9GjmBfZURsY0z
 jeje72ijdXZesOSNFY7YZKajlup9W+7R0tVO+cHV7sL995XZfYfgU3lUS9cGq+1aLmdo
 IJ6AklFV99CYdjqA/3kDiG5TFpvCrtEcyYpNLn1b7I3YzkUYDVQWu5mxSW+QaxMbusMx
 IaBLuFBAPNklT8KTBqHdtwNzYTAtfYpGDUwodgdYz/BMCIiRYeA2TPMkZxjCyAioLIX2 9g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39r6dph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 09:58:38 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:58:37 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:58:36 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 09:58:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STmRXFTjxsFnD8u8HCEy3tmAg0pz6I7ny2jVLBrZESd9bSnFSHtCk2BrpTYI7TrNrf8kwc1aIctsulSrJnktqqfJSDN2/lkJFvWi9riEHWrOuszvP0G5XrfMm49tfiJRbrHOogK+zCj8GnSGwsLNu3HgYAZOYe+nvOQIigBSArzcCRRjhPxPEUkx5XTkf9JQCa8E7ZoNANOn1+UcLN/lFobFZn07RvMbwkrppz3SYSMAQ7UCj/WB6IZaA8qGZ5WE3pWuNLjVjpNaJ27+rH3WB3Lbt64wMWNe6ZaAOkxuSf+1RVr9R3pgIwvT4BvrClzpiQzmo8CQmrPPJlBOus2YTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6sfi8us8khBcVaHLEcbGHrXGjcwBkTMGdxvJ+kVM7BE=;
 b=n6hP9jhmEdvaJRPYI7gRhy9yicR+YZDoBqzZLQfWmDvVP0cJ99uAXlNPNlVDrEKBrJjKchRQ/XN5aJJEsBFqWapSMuGY0rv9l8j1Q114wS8lG716LZfs6IrIoCuw/0rFeyaiimdI/dUUTJ/zWTUUU92C0SNN5ZW6TmawIoQ4272TB/7zfKScfY7xzKEigDjFIFRzL9QmPuMxIcl7qJHkjHh8t7Eqc0oPfigLNvhhh7A29BmAMaf4ztLB44RA9sy7aL3hzw5kfTC/7Ex6yrI1+8NdA+A7Zcsn1aLXB4iycYQKvFIXI3vxc5fj2PyoXQbzVMpq8eGtAL5EozCNGGFunw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6sfi8us8khBcVaHLEcbGHrXGjcwBkTMGdxvJ+kVM7BE=;
 b=PDnprjLvAq/9DlCxJb5IcpuQAQzMy9Duzr6UAV+nKKCKXo9F99QkQOwCxpGzmJ6ZTA899bogCszARhtgLrN3ew571xvqposqUE/wEA3tTWt89LC3uTnm3jXS2QF8NIc1iklM4Be3nV4/KbNz3KwmlQLDtW55/EYe6d781INK+4g=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW3PR18MB3530.namprd18.prod.outlook.com (2603:10b6:303:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 23 Nov
 2020 17:58:34 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703%4]) with mapi id 15.20.3564.039; Mon, 23 Nov 2020
 17:58:34 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "nitesh@redhat.com" <nitesh@redhat.com>,
        "frederic@kernel.org" <frederic@kernel.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v5 8/9] task_isolation: ringbuffer: don't interrupt CPUs
 running isolated tasks on buffer resize
Thread-Topic: [PATCH v5 8/9] task_isolation: ringbuffer: don't interrupt CPUs
 running isolated tasks on buffer resize
Thread-Index: AQHWwcJCaZAYvgqyU0uLj2p5N5OAJA==
Date:   Mon, 23 Nov 2020 17:58:34 +0000
Message-ID: <f6f83445a5c8214ded2e39909c719a67ec076b63.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
In-Reply-To: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ea533cc-7124-4083-3063-08d88fd965a1
x-ms-traffictypediagnostic: MW3PR18MB3530:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB35302216D7D66EDEA40F586BBCFC0@MW3PR18MB3530.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ltrLKCokWctmzGqeKU3Dhh8h22z5mBJzfk6nVTXlGS8z3Yek8fIf+hTdLD6vPwzTRj+172kH/Y+TPmp99CpN01T7I2KEweM4bOLYZFBCQrEn6wS4MVLPgqgCTfr3GCmNAyhB+e+WDte5rmhydS9jJeX2mI2SvP6+ceXLtkz+0upo9xID/I69u0PmasiyG+id7AVuwRnC00dyBEZgNNNRVdso38B0gbYy7quueqdXdQexuKdFBFMocfniBGPWvITnx80MLCh1UukjZeHKLf9ZT+G+D4OSZf/iGElLN0n41L1zybZH1EQapyCSW9tLpucvxbZ9t5Gxr4xjHbDMF2w0jw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(2906002)(2616005)(71200400001)(5660300002)(6512007)(83380400001)(110136005)(26005)(54906003)(6486002)(186003)(6506007)(36756003)(66946007)(8676002)(316002)(478600001)(8936002)(86362001)(7416002)(66476007)(66556008)(64756008)(66446008)(91956017)(76116006)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZlO9Y1FX87Fky2QnkKBlk6HdmUqs+cTdJ3gFccetqIaZcOM/DouXCSwrrsrpncpwA0rsfjxgna4MnKaXkoLE4x4t590yCErrIqbP1Bwa4slLzSmId4Zsc2uOtEZdsjlZ5G1VzHgbl44tID8V3oG3g3pWeIxT3346bwrsD8ZVholJyZgWPStMhKJ+8bJL3ZesmGBMBZ3iwrwuUkOgcjttlH16LVKsF5y8de4Hu8iqJ2U+lv5EphDqYDzoFxyDiftZRRHUy1iWVW0rdVjVeXWmAIiV/qS79B2ZyVtJzjn7k5CiSvAnuaEVJmz4QnDopc+/nGprhY4Ygl/UPswgK17PpRIvbv2yyR0WrJzyEckZpFIZKYnjHzYKzd4JBqe7x4QOxOwFLCFBb8uLYkuBLZPT6OzdYkkg5sJ0iebAiNKtrKdYSW2hMey/6brzRbQnAHyUVmMqy+lMOnDquaZIgmNNkYWe4MzHQQcy/3yh1FbcRmTpgcfberkdTof18Ilb+w35CeSn9BbJnrxjxfBeUkmoLKpcnWwZQCNbz2UfnjkSPtGeAL0Ef/NA5OWc3/cXdNMdZPV0n+4pEiB4DueETNyJoqhGK/XeG4tXLVmiFIJdtIbw94S5B0+gxvh91INWUMU5HwKZhzOUqZ9RQd3m4FsxFDZSJhp832WgoTrdz9s8r0zFUflrz0I08EWHExPDd32xDAFvAr6R9PnxdNlratTfJA6b+yFmieoS1f7GwL75d0PfenFjztKdaYROH6XpOgKy346XFexPbHKzCH5D+95ed/9bYViqkxs6nZBg6nPOtFBKaJbMppSqKRsiUlv5nqSmZorQmQe0rF9XEd8OEUY27imoldJkvyfsiNrwN16ua1VdiW8sKsScufLtTI37Kl9gbWvO9id418Twf1njOaSazQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <79CB53C96CF18B418B712DFEDA3F74B1@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ea533cc-7124-4083-3063-08d88fd965a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 17:58:34.6903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLwRSqj8L0DPkKrUz7rkl/wZBvMJoC4tkggCKOQfSP8Ut4BW27alTAxLq6ubKqD9U//VvRtazEj7CaXWp1pNmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3530
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
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
dHNAbWFydmVsbC5jb20+DQotLS0NCiBrZXJuZWwvdHJhY2UvcmluZ19idWZmZXIuYyB8IDYzICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tDQogMSBmaWxlIGNoYW5nZWQsIDU3
IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9rZXJuZWwvdHJh
Y2UvcmluZ19idWZmZXIuYyBiL2tlcm5lbC90cmFjZS9yaW5nX2J1ZmZlci5jDQppbmRleCBkYzgz
YjNmYTlmZTcuLjllNGZiM2VkMmFmMCAxMDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS9yaW5nX2J1
ZmZlci5jDQorKysgYi9rZXJuZWwvdHJhY2UvcmluZ19idWZmZXIuYw0KQEAgLTIxLDYgKzIxLDcg
QEANCiAjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0K
ICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0K
ICNpbmNsdWRlIDxsaW51eC9oYXNoLmg+DQogI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4NCiAjaW5j
bHVkZSA8bGludXgvY3B1Lmg+DQpAQCAtMTkzOSw2ICsxOTQwLDM4IEBAIHN0YXRpYyB2b2lkIHVw
ZGF0ZV9wYWdlc19oYW5kbGVyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAJY29tcGxldGUo
JmNwdV9idWZmZXItPnVwZGF0ZV9kb25lKTsNCiB9DQogDQorc3RhdGljIGJvb2wgdXBkYXRlX2lm
X2lzb2xhdGVkKHN0cnVjdCByaW5nX2J1ZmZlcl9wZXJfY3B1ICpjcHVfYnVmZmVyLA0KKwkJCSAg
ICAgICBpbnQgY3B1KQ0KK3sNCisJYm9vbCBydiA9IGZhbHNlOw0KKw0KKwlzbXBfcm1iKCk7DQor
CWlmICh0YXNrX2lzb2xhdGlvbl9vbl9jcHUoY3B1KSkgew0KKwkJLyoNCisJCSAqIENQVSBpcyBy
dW5uaW5nIGlzb2xhdGVkIHRhc2suIFNpbmNlIGl0IG1heSBsb3NlDQorCQkgKiBpc29sYXRpb24g
YW5kIHJlLWVudGVyIGtlcm5lbCBzaW11bHRhbmVvdXNseSB3aXRoDQorCQkgKiB0aGlzIHVwZGF0
ZSwgZGlzYWJsZSByZWNvcmRpbmcgdW50aWwgaXQncyBkb25lLg0KKwkJICovDQorCQlhdG9taWNf
aW5jKCZjcHVfYnVmZmVyLT5yZWNvcmRfZGlzYWJsZWQpOw0KKwkJLyogTWFrZSBzdXJlLCB1cGRh
dGUgaXMgZG9uZSwgYW5kIGlzb2xhdGlvbiBzdGF0ZSBpcyBjdXJyZW50ICovDQorCQlzbXBfbWIo
KTsNCisJCWlmICh0YXNrX2lzb2xhdGlvbl9vbl9jcHUoY3B1KSkgew0KKwkJCS8qDQorCQkJICog
SWYgQ1BVIGlzIHN0aWxsIHJ1bm5pbmcgaXNvbGF0ZWQgdGFzaywgd2UNCisJCQkgKiBjYW4gYmUg
c3VyZSB0aGF0IGJyZWFraW5nIGlzb2xhdGlvbiB3aWxsDQorCQkJICogaGFwcGVuIHdoaWxlIHJl
Y29yZGluZyBpcyBkaXNhYmxlZCwgYW5kIENQVQ0KKwkJCSAqIHdpbGwgbm90IHRvdWNoIHRoaXMg
YnVmZmVyIHVudGlsIHRoZSB1cGRhdGUNCisJCQkgKiBpcyBkb25lLg0KKwkJCSAqLw0KKwkJCXJi
X3VwZGF0ZV9wYWdlcyhjcHVfYnVmZmVyKTsNCisJCQljcHVfYnVmZmVyLT5ucl9wYWdlc190b191
cGRhdGUgPSAwOw0KKwkJCXJ2ID0gdHJ1ZTsNCisJCX0NCisJCWF0b21pY19kZWMoJmNwdV9idWZm
ZXItPnJlY29yZF9kaXNhYmxlZCk7DQorCX0NCisJcmV0dXJuIHJ2Ow0KK30NCisNCiAvKioNCiAg
KiByaW5nX2J1ZmZlcl9yZXNpemUgLSByZXNpemUgdGhlIHJpbmcgYnVmZmVyDQogICogQGJ1ZmZl
cjogdGhlIGJ1ZmZlciB0byByZXNpemUuDQpAQCAtMjAyOCwxMyArMjA2MSwyMiBAQCBpbnQgcmlu
Z19idWZmZXJfcmVzaXplKHN0cnVjdCB0cmFjZV9idWZmZXIgKmJ1ZmZlciwgdW5zaWduZWQgbG9u
ZyBzaXplLA0KIAkJCWlmICghY3B1X2J1ZmZlci0+bnJfcGFnZXNfdG9fdXBkYXRlKQ0KIAkJCQlj
b250aW51ZTsNCiANCi0JCQkvKiBDYW4ndCBydW4gc29tZXRoaW5nIG9uIGFuIG9mZmxpbmUgQ1BV
LiAqLw0KKwkJCS8qDQorCQkJICogQ2FuJ3QgcnVuIHNvbWV0aGluZyBvbiBhbiBvZmZsaW5lIENQ
VS4NCisJCQkgKg0KKwkJCSAqIENQVXMgcnVubmluZyBpc29sYXRlZCB0YXNrcyBkb24ndCBoYXZl
IHRvDQorCQkJICogdXBkYXRlIHJpbmcgYnVmZmVycyB1bnRpbCB0aGV5IGV4aXQNCisJCQkgKiBp
c29sYXRpb24gYmVjYXVzZSB0aGV5IGFyZSBpbg0KKwkJCSAqIHVzZXJzcGFjZS4gVXNlIHRoZSBw
cm9jZWR1cmUgdGhhdCBwcmV2ZW50cw0KKwkJCSAqIHJhY2UgY29uZGl0aW9uIHdpdGggaXNvbGF0
aW9uIGJyZWFraW5nLg0KKwkJCSAqLw0KIAkJCWlmICghY3B1X29ubGluZShjcHUpKSB7DQogCQkJ
CXJiX3VwZGF0ZV9wYWdlcyhjcHVfYnVmZmVyKTsNCiAJCQkJY3B1X2J1ZmZlci0+bnJfcGFnZXNf
dG9fdXBkYXRlID0gMDsNCiAJCQl9IGVsc2Ugew0KLQkJCQlzY2hlZHVsZV93b3JrX29uKGNwdSwN
Ci0JCQkJCQkmY3B1X2J1ZmZlci0+dXBkYXRlX3BhZ2VzX3dvcmspOw0KKwkJCQlpZiAoIXVwZGF0
ZV9pZl9pc29sYXRlZChjcHVfYnVmZmVyLCBjcHUpKQ0KKwkJCQkJc2NoZWR1bGVfd29ya19vbihj
cHUsDQorCQkJCQkmY3B1X2J1ZmZlci0+dXBkYXRlX3BhZ2VzX3dvcmspOw0KIAkJCX0NCiAJCX0N
CiANCkBAIC0yMDgzLDEzICsyMTI1LDIyIEBAIGludCByaW5nX2J1ZmZlcl9yZXNpemUoc3RydWN0
IHRyYWNlX2J1ZmZlciAqYnVmZmVyLCB1bnNpZ25lZCBsb25nIHNpemUsDQogDQogCQlnZXRfb25s
aW5lX2NwdXMoKTsNCiANCi0JCS8qIENhbid0IHJ1biBzb21ldGhpbmcgb24gYW4gb2ZmbGluZSBD
UFUuICovDQorCQkvKg0KKwkJICogQ2FuJ3QgcnVuIHNvbWV0aGluZyBvbiBhbiBvZmZsaW5lIENQ
VS4NCisJCSAqDQorCQkgKiBDUFVzIHJ1bm5pbmcgaXNvbGF0ZWQgdGFza3MgZG9uJ3QgaGF2ZSB0
byB1cGRhdGUNCisJCSAqIHJpbmcgYnVmZmVycyB1bnRpbCB0aGV5IGV4aXQgaXNvbGF0aW9uIGJl
Y2F1c2UgdGhleQ0KKwkJICogYXJlIGluIHVzZXJzcGFjZS4gVXNlIHRoZSBwcm9jZWR1cmUgdGhh
dCBwcmV2ZW50cw0KKwkJICogcmFjZSBjb25kaXRpb24gd2l0aCBpc29sYXRpb24gYnJlYWtpbmcu
DQorCQkgKi8NCiAJCWlmICghY3B1X29ubGluZShjcHVfaWQpKQ0KIAkJCXJiX3VwZGF0ZV9wYWdl
cyhjcHVfYnVmZmVyKTsNCiAJCWVsc2Ugew0KLQkJCXNjaGVkdWxlX3dvcmtfb24oY3B1X2lkLA0K
KwkJCWlmICghdXBkYXRlX2lmX2lzb2xhdGVkKGNwdV9idWZmZXIsIGNwdV9pZCkpDQorCQkJCXNj
aGVkdWxlX3dvcmtfb24oY3B1X2lkLA0KIAkJCQkJICZjcHVfYnVmZmVyLT51cGRhdGVfcGFnZXNf
d29yayk7DQotCQkJd2FpdF9mb3JfY29tcGxldGlvbigmY3B1X2J1ZmZlci0+dXBkYXRlX2RvbmUp
Ow0KKwkJCQl3YWl0X2Zvcl9jb21wbGV0aW9uKCZjcHVfYnVmZmVyLT51cGRhdGVfZG9uZSk7DQor
CQkJfQ0KIAkJfQ0KIA0KIAkJY3B1X2J1ZmZlci0+bnJfcGFnZXNfdG9fdXBkYXRlID0gMDsNCi0t
IA0KMi4yMC4xDQoNCg==
