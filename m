Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFC322B3ED
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgGWQvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:51:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1790 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726621AbgGWQvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 12:51:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NGihbU025252;
        Thu, 23 Jul 2020 09:50:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=veAKbFJuW0EIZJ9f0wwiqngzzZFMLettvWEXNy9Dafw=;
 b=l3qGB43253E6+F9Hqr9XUklaekKjZvcPSyCM6DC+SPgM63lGZcN+oCLIPbYUH4Z3zneR
 afTXottWkNLyQxHv3RoZQPJrB+xzvNQJEDLb9K+9578NeBENagVhxmDKTAr+JkXgY2e2
 3VOEbYGbZN6Smguu03WMY3N2EcmEpzLUhPXrI+V2okSlEnGGGx1f4UwVJUj/HC95NGrM
 XVZjTNsR60UkQwhRSejg1WudCErTPK+vk/cte4KzbgbA9Aif7AhkfpiAcatQ5kEtUJ/v
 wN7hamAzFR18NibxP8L7+H+SkqscTw9B1kcydFGx8r/x7IJ7EbGBsqqsRcZ2fsPnM7ls rA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxenxqvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 09:50:40 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jul
 2020 09:50:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 23 Jul 2020 09:50:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UV3QtKFjJv/YFGvV3/ken3HrAlSSNBG0gSz8LNXOE0UMfk+gU0ACCQJBq+C2ocRYd7ibXItIsUKvYxwWWXMFkRTMXOpj1+5ILBqomItQr2x/MxAK1aS5d2TzAxc58Zqo2IUw/4jbxocXYxsZFtA3OilVcqtHJ3wUV6+H1a57cP/1TGIr9c8gx9JA9vYahXNsWJM1xbngHcGkEFPRfeFmHn0+wEbM4bOqZOngoU740yXBCmrQa/FK4aEjveNGiQZL2itkj1p7FFXASZHLjzjsSqfxC7I27uxHAREPCLYKxmQo5eGZLq+ap/mDg5gaEM78PjP49DnHLxKoW5SUuCwTaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veAKbFJuW0EIZJ9f0wwiqngzzZFMLettvWEXNy9Dafw=;
 b=EPRSfvY5bG0GUknBNwSaJKjbHv/51I2MGBaUH2wNmlNDvh5sUjWVRF8trMTqBzjZfsb1sRLgbGw3Fv+MTi/H44QYAR7I3/6K5R/XoUZZKt6Ph5Ls6/2ePFogrfz7Z3v/nxdKQ48ldXhk486nSkcym8bBmUG3hq2Y+qowZs7x7FUpAiXijCENGFPJNJu0296K3dy+7WFPFtBr0tqB3X/8tTAVbSAbkwnX9FyeInzhem5JtRYCN+7YhOD45T/70IqW83hD8RcpfUSI8xj6PR16BrTdTYs9ZLZuS15WD3Zw15AN/bfeRlIvebhYOVbvUBL/Fkok/CRygMt4BD9Y36nWeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veAKbFJuW0EIZJ9f0wwiqngzzZFMLettvWEXNy9Dafw=;
 b=g2lA/oQzIMVr7X+ura20AJS0QpumpAyZoBmLK73OqvFaw+/c/5agCrvT6gSNkmTed2l45bI779NOrHJLCnDywQOp9vo8gn5qQ4INMKTyVA4PRsSMWCAvBJWa9Sc404ixsEhnpH0Hlos9imwhK9zVYvQ6BrRIwejLcS3tRXQPMkk=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR1801MB2046.namprd18.prod.outlook.com (2603:10b6:301:61::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Thu, 23 Jul
 2020 16:50:37 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Thu, 23 Jul 2020
 16:50:37 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 00/13] "Task_isolation" mode
Thread-Topic: [PATCH v4 00/13] "Task_isolation" mode
Thread-Index: AQHWYQSN+bm+zChO70Wsfble6+WsKakVT66AgAARDwA=
Date:   Thu, 23 Jul 2020 16:50:37 +0000
Message-ID: <3ff1383e669b543462737b0d12c0d1fb7d409e3e.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <87imeextf3.fsf@nanos.tec.linutronix.de>
         <831e023422aa0e4cb3da37ceef6fdcd5bc854682.camel@marvell.com>
         <20200723154933.GB709@worktop.programming.kicks-ass.net>
In-Reply-To: <20200723154933.GB709@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a52b9d7-8fc8-4952-adac-08d82f288659
x-ms-traffictypediagnostic: MWHPR1801MB2046:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB204627D0370580789527BDFABC760@MWHPR1801MB2046.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +3+RdEW/7j8dbt0nz55+IHF6zrWvohSNewljlzdL5UWdm+f7FKFNLVuZDscQ1U/ifSkP2+sgXOojhGdGPeip7kFEidFPHIv6J0hpRDjA1VR44iqhJGaapFTBjMn6bBxLfBBv0QkDa6WwqEcyDNnWTaMJzBwHORGySkt9xnrQ+1N74zZUJtJUPuEorYe6KhWlI/mbpKLR9Klo3FKv9z7S3GyOd0eypEq4BTg3XRL+U/uRCwiGs2yeMTz6PFTyGLTk9EHp8mwXwrP2kCxvyoY6MwgDaUCP1eVFioNVRt+XCndPwibeHCv7ufOqd6izWxCFbmBoOP/5Seel6Pe8rHQOuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(136003)(376002)(396003)(39850400004)(2616005)(26005)(478600001)(6506007)(186003)(6486002)(66476007)(64756008)(66446008)(66556008)(83380400001)(71200400001)(8936002)(4326008)(316002)(6916009)(86362001)(7416002)(54906003)(4744005)(76116006)(5660300002)(36756003)(6512007)(66946007)(91956017)(8676002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: mKLbLh2Kc5LOf9uYMmM58rjDKzfQm5tagA+enwZ04GZQ0BZ05dgd6umTAet05Z0HEs7e6/h/Z1PUt+zM82VUAsB4PRJedKJTC3tKjCH4IFj+HDzupTuDSmuMLqMa82p/lgRuVVegFNj5UbBvVSTGNRfMlV4jrKyMmx9V1dSNFt2z+teFjJCQ+oIpDPaLOoaCchYvDBCT+/gJOte0sqY/Fzov7I4N+QUwL7I1WjzIdtAdh+HWP4F9gPYkSgY1SapJSYCRAEc5ZHpX2pmolgBI7tv4vSE80h0+8IYbH6nBGtREYAkAlL7f9IAH5IyEsoiS6ODShBAlz6ILV+K0KQloTc7qRhe3Q5VqLav45gS/1n2s2JJiigjBv5zthzs7E20b7WtLlCqSwg+XMZOwH0+rudjrThPNNt7kWBzzsqWxYTUxlsrJpYGOsrt4EuJRYI3S3ky3LDQlMpB8IzptuANLQVqqdhZNW9WYdMIaFNn9rrA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCCF4D921554A94295135240AB2C05F4@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a52b9d7-8fc8-4952-adac-08d82f288659
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 16:50:37.0497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3OWOp6S0u844rKRNbJ36wZ8v1VtmNRcSwniRk20YBoyFKmlUgeGMoRduo8boi+KLY1ZciACKa6cCEavac+sK1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB2046
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_09:2020-07-23,2020-07-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUaHUsIDIwMjAtMDctMjMgYXQgMTc6NDkgKzAyMDAsIFBldGVyIFppamxzdHJhIHdyb3Rl
Og0KPiANCj4gJ1doYXQgZG9lcyBub2luc3RyIG1lYW4/IGFuZCB3aHkgZG8gd2UgaGF2ZSBpdCIg
LS0gZG9uJ3QgZGFyZSB0b3VjaA0KPiB0aGUNCj4gZW50cnkgY29kZSB1bnRpbCB5b3UgY2FuIGFu
c3dlciB0aGF0Lg0KDQpub2luc3RyIGRpc2FibGVzIGluc3RydW1lbnRhdGlvbiwgc28gdGhlcmUg
d291bGQgbm90IGJlIGNhbGxzIGFuZA0KZGVwZW5kZW5jaWVzIG9uIG90aGVyIHBhcnRzIG9mIHRo
ZSBrZXJuZWwgd2hlbiBpdCdzIG5vdCB5ZXQgc2FmZSB0bw0KY2FsbCB0aGVtLiBSZWxldmFudCBm
dW5jdGlvbnMgYWxyZWFkeSBoYXZlIGl0LCBhbmQgSSBhZGQgYW4gaW5saW5lIGNhbGwNCnRvIHBl
cmZvcm0gZmxhZ3MgdXBkYXRlIGFuZCBzeW5jaHJvbml6YXRpb24uIFVubGVzcyBzb21ldGhpbmcg
ZWxzZSBpcw0KaW52b2x2ZWQsIHRob3NlIG9wZXJhdGlvbnMgYXJlIHNhZmUsIHNvIEkgYW0gbm90
IGFkZGluZyBhbnl0aGluZyB0aGF0DQpjYW4gYnJlYWsgdGhvc2UuDQoNCi0tIA0KQWxleA0K
