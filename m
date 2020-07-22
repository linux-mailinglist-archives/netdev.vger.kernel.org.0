Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95137229A79
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbgGVOpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:45:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4446 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728405AbgGVOpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:45:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MEKYr7020691;
        Wed, 22 Jul 2020 07:44:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=DyDQG0A25H7mwodK8ECXUYOwFzzAUyRxwKw2AczNGjo=;
 b=aheYud/+YnRpyIBDnsTFIMiQY9mosu3tomwZ4JLgv9fiuzsRvJTe7bWfNk8ODAeuoxkX
 R0A4NCnf41vgdCBiCKhhz4M5gVCLEG38g4MX68ej77ei1AV+FLO5ttUwaRgG80IlzR6z
 yZBdhkhjuljARS0m03LnwNELcNTqWpEZ/4KqIgTOkqPU990GLT9XYKGKIwSzQt26KfL8
 dPLoFhtO3ixBFXRKl3K3wywOC6ArSxLe3PPG7vki7yaxK5eh9gwyh4HWFRCtMQKIbRVd
 WlvRGLx74kafl+H/YXzQ+q8PGSIi4IJNNrL5evQ4rpU3MEEANnO8zCP0Vj+QBGfawQ2h zw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxens66u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 07:44:41 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 07:44:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 07:44:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=og0r/2OIxNEtx00DhqMCoLlowSLnQf6d7wY2Hq0ZihTZZ9MbU3+5kFwq5+TfEmL3X4eUbt66O8sL+pn9WA9RtWOrpmEhPs3v+bCMGxyxh9+IzFefdU0pvazHC572sb6fPNQxVljDGnqcV8IZWHjsTVNCvMU+P1TZNGmk+eaHb3E9gPGrApqs04cYYZTSLX183KTS1Bl8EsPkD0N5VzaLmvNZwbOh0jMmcxpQ4JZcynq6zAfbByiGKUC5e90k6nTk+w/3k3SjUcfryC4DaIbCCnlWATEsoyTwHLmlDP5xf2XFZk9P8vuYw46q5/5rYHHZJgTdcfU+WYL/QZ3uK37tbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DyDQG0A25H7mwodK8ECXUYOwFzzAUyRxwKw2AczNGjo=;
 b=ZLE6AnqLIPTeApyxLa5wG/AVyLrMZE/STGMxol1npNTis2EO7AVjEwyTbD8ZhitMb+p70YJ3BvpJjd7Tl5VKTEjEyEHxvKFrMKEA/RNbbYWaOJw40AykUcpNX0CVTsNiW6OzMTLKhiuG55O2ANiRTyQdsrqb7OuzdSNu6pluEf8pRAker1fcTlfeBIDGCstkCB+Bfp7SLW6sV2ytXhTinz+GHko0Y4qQnzPVOaHxZWqTTO5nXM7BkXN7LxBZRiBpBiG0ntxhn6Ma8Qh62EyIAlo3XSuTsCCyCN457zTOaIglu39ru3DWaGdGusbub1PCi1G0lIGNuxRzeyTT/0EFvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DyDQG0A25H7mwodK8ECXUYOwFzzAUyRxwKw2AczNGjo=;
 b=qAiFGVKKKSnqiy1fF7spqgrgqJPtUE+iY9NwToJVc2phHc+4n6zOUxjWZ5Lkx3lFO7i8XPfxlVzbfUjhzCcIDbBjanFH1/8zHey1KeojSiOLFNtHcrk+0LLUiEX0N+2F1fPppmnY1ycrtLrmB76FOQMokNxt3wQosdiGM3TeQIc=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW2PR18MB2091.namprd18.prod.outlook.com (2603:10b6:907:2::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Wed, 22 Jul
 2020 14:44:38 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 14:44:38 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v4 00/13] "Task_isolation" mode
Thread-Topic: [PATCH v4 00/13] "Task_isolation" mode
Thread-Index: AQHWYDagTVb+dYV8A0GKqxFlnWyBeA==
Date:   Wed, 22 Jul 2020 14:44:38 +0000
Message-ID: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0db35ee6-fb26-4280-f2a2-08d82e4dc2ca
x-ms-traffictypediagnostic: MW2PR18MB2091:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB2091065376E22D5B3AEE9750BC790@MW2PR18MB2091.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hgx0bgsSQNC3MHiOF1NIBr6J22icJue8dy7x/8Vd8YimX4TmBNNfNbZuffQPsC8rY10/FlLq8V01GS7IX3Nca+IY2Djro13tI7hctYchsvqP8YlGuJgJMNaEWIPPTdytFnQ1ANyqWnOk7rh9d8eQ5zyKJb9TktxabY+47qmD9mlcCsxnlnKX8Dtvje9OKMgbDPoe2BaxU5TJkrmPb1Xx6CC7YXTxXGSxwrPN4IK93Smeum49sqW/Ihe27WKSqtBcbT4Nlzwr50txLdRu5TyzO7fLVxAMgrmGBAff5dovARiR3UdL/bFko4g91sUAmkEM7ao+Lsv0K4MADArg/oH5Tv+E8+cdas08wG5Q4D2Re+fnLrrGHkuJMyt4TTGbNQ6v+pR1fDNNSJXjWpLyi9Iyvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(36756003)(71200400001)(2616005)(83380400001)(478600001)(5660300002)(186003)(4326008)(4744005)(26005)(86362001)(8936002)(6506007)(2906002)(316002)(966005)(110136005)(8676002)(66946007)(66446008)(64756008)(66556008)(66476007)(76116006)(91956017)(6512007)(7416002)(6486002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: F3S5w+SV6ig4BD4O2Xhj+siQKMOdTYNyzSOhrvutMPC30m2vFh3O4KKSvM5+b/jZo7kMItdSZK9hu0U3gjVzOfCacrOIlQZMcXWM1jpjM45UuI1nmbwNAxcOIzy/zAgkBHU8BXbLzA1+21RCLkQ9b2MOaxPMHLWvOE4lQPsM8f7iLAP+W+5xKpYtvk7KYhKsqHim1P1Lb4TY/NsAXJr42LhSyUHrRfs7smMrtapbStP2TGzWpfYcPCUBH/aty4SOwBIL0idCd9xiwFT01YgLK2T2LpgKQ9jn1fxfr9IUpdEwdR03/sHHSudeMc+5cnG/1Uwvldb33gqW0bdJpHqCx6JrWF/ulq+LNeQhhxGq0ePGjcczSm8qDQzR7hzPBHgX8kTzIQITo4fdo8aifXfu5FRTM+uyvmk/n0YzFiotHhB578fA6VZLsHE5FuwMFXgVdu/Iihymx0LcW2kVXR1hzhoUqk/hJ2vljr2qBu2Of/0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D5F23F66C03DB45B2B52ED1271588B2@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db35ee6-fb26-4280-f2a2-08d82e4dc2ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 14:44:38.7375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4KM39eEaex2MRh506DTv50IBwhK+7tv123eUCcQLJBEXZBzNlW2wseNVUK3Y6ADuJZbVwl0m7IAPkCVa6Y+Mcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2091
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_08:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBpcyBhIG5ldyB2ZXJzaW9uIG9mIHRhc2sgaXNvbGF0aW9uIGltcGxlbWVudGF0aW9uLiBQ
cmV2aW91cyB2ZXJzaW9uIGlzIGF0DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzA3YzI1
YzI0NmM1NTAxMjk4MWVjMDI5NmVlZTIzZTY4YzcxOTMzM2EuY2FtZWxAbWFydmVsbC5jb20vDQoN
Ck1vc3RseSB0aGlzIGNvdmVycyByYWNlIGNvbmRpdGlvbnMgcHJldmVudGlvbiBvbiBicmVha2lu
ZyBpc29sYXRpb24uIEVhcmx5IGFmdGVyIGtlcm5lbCBlbnRyeSwNCnRhc2tfaXNvbGF0aW9uX2Vu
dGVyKCkgaXMgY2FsbGVkIHRvIHVwZGF0ZSBmbGFncyB2aXNpYmxlIHRvIG90aGVyIENQVSBjb3Jl
cyBhbmQgdG8gcGVyZm9ybQ0Kc3luY2hyb25pemF0aW9uIGlmIG5lY2Vzc2FyeS4gQmVmb3JlIHRo
aXMgY2FsbCBvbmx5ICJzYWZlIiBvcGVyYXRpb25zIGhhcHBlbiwgYXMgbG9uZyBhcw0KQ09ORklH
X1RSQUNFX0lSUUZMQUdTIGlzIG5vdCBlbmFibGVkLg0KDQpUaGlzIGlzIGFsc28gaW50ZW5kZWQg
Zm9yIGZ1dHVyZSBUTEIgaGFuZGxpbmcgLS0gdGhlIGlkZWEgaXMgdG8gYWxzbyBpc29sYXRlIHRo
b3NlIENQVSBjb3JlcyBmcm9tDQpUTEIgZmx1c2hlcyB3aGlsZSB0aGV5IGFyZSBydW5uaW5nIGlz
b2xhdGVkIHRhc2sgaW4gdXNlcnNwYWNlLCBhbmQgZG8gb25lIGZsdXNoIG9uIGV4aXRpbmcsIGJl
Zm9yZQ0KYW55IGNvZGUgaXMgY2FsbGVkIHRoYXQgbWF5IHRvdWNoIGFueXRoaW5nIHVwZGF0ZWQu
DQoNClRoZSBmdW5jdGlvbmFsaXR5IGFuZCBpbnRlcmZhY2UgaXMgdW5jaGFuZ2VkLCBleGNlcHQg
Zm9yIC9zeXMvZGV2aWNlcy9zeXN0ZW0vY3B1L2lzb2xhdGlvbl9ydW5uaW5nDQpjb250YWluaW5n
IHRoZSBsaXN0IG9mIENQVXMgcnVubmluZyBpc29sYXRlZCB0YXNrcy4gVGhpcyBzaG91bGQgYmUg
dXNlZnVsIGZvciB1c2Vyc3BhY2UgaGVscGVyDQpsaWJyYXJpZXMuDQo=
