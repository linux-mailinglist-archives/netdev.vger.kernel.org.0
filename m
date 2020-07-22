Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2D1229ACF
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732761AbgGVO6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:58:03 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31122 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730382AbgGVO6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:58:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MEml23012168;
        Wed, 22 Jul 2020 07:57:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=39S4vVNIusSsi2LuvNZmhBBhMhNTv0T4UrDYfmP6564=;
 b=EVJa0A16lfuFUlWKLZwXw+n8R881k/ZS22EehTrvAnPM66x6SDId+O0ZbNDXSmi0+T/0
 B757ZJwzBlKBCttui7WlyVvARBC7lrNUCEbfRcDKrXist3L4yVRGDhUz2q7XpDdZTbUi
 LH1FkhAETb7mfolgyHqVT5LNvd5hQZLuHe7l1jSGbd2q70wfiZEa/myKJJg10qCTVZQN
 R3Z2JyKusEtFW2a4DmD/ai7dXbzGnY5Z6eNeYvqm2BptvjP0nYM8PObbV9CglArzVxu/
 n4M0gyQCBnsoRDSQWlbTcNl/4X8dDFwlZSfA70nrjXSoKvDQK5T8qk5cKPxxB+wFkjBj pw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkrbpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 07:57:36 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 07:57:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 07:57:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tu4VdwZldBfUismKGfeOqVVBE1uc0BQl4NeXvxy/Aa8/eHi5efGhG7zKLvmEbOrFtTcKR4zT97RBX5jmV7UgRsVUz6U8hN+fnJUW1YN6Lkicuv0+K05S5qTLvfB1WtTIJmYkBF7SVYwaoKHVDevmiKWDa5kCLzNN8qeZ0KkyPf9uPX0GOxCYdFZ0rL6YR88go3H8SRkvpJ0DIwIKJgQumDo+OOeRTN6ih6kDQLQltdlj22i5KKh7/pzBQuP90Vj0yWLAnjKvwzEmAJZga42BqoanQM2Ie8lJ74sMFv0tT08zzjTMXKdqd3GVTiD6W70T272U8u6D67tNaXll0BDwww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39S4vVNIusSsi2LuvNZmhBBhMhNTv0T4UrDYfmP6564=;
 b=BDCt/f2IbSIw4jmK1W6+I8fadY3RDlv9TYDWAIRJ7MKjRB+yDmQ6vPnuLItVvQN51GTqat8DwBS6V0ZNIX6TXUNj8yvW/oWoanfmwvNknE0ugHHUauT3iCiL0ZaGz6FEtk9fTEm72C8EFwvddJuRii9gLlAUkkBnna0OHYqo/hRFXjo2IucoEqBMM5j2yYDCBxPIDVcrR3TUUcthZgAiS8ujrUheuiCKhdPwQ098ZlQc0+vUhmiyCnOSlPtviNcPvJc9zcM0aAH2NlIKiFIlQc277pw3e5kw1AFwWXzgWM3se35ql3a3NfhIiOzj/jZtxDli8kZ2XQUCmeQJnuSJug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39S4vVNIusSsi2LuvNZmhBBhMhNTv0T4UrDYfmP6564=;
 b=hk9Mbd9ca2K2qL1TZ55BgoIt9eD590LWokURNZkJ27imn4sFtN8H6utPmotL8ape1eojbbKqhpkiH97mbgRhqGgosYrv89KkJ/aICop50lttnoMeIRxO6RRpyFVahb6hofN3IBUTbkSLcyVcuQm85GPFDHh080IoJzZkJMNl87I=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW2PR18MB2156.namprd18.prod.outlook.com (2603:10b6:907:a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Wed, 22 Jul
 2020 14:57:33 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 14:57:33 +0000
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
Subject: [PATCH v4 10/13] task_isolation: don't interrupt CPUs with
 tick_nohz_full_kick_cpu()
Thread-Topic: [PATCH v4 10/13] task_isolation: don't interrupt CPUs with
 tick_nohz_full_kick_cpu()
Thread-Index: AQHWYDhuh3VfINlM20KwSBz5WuaF0Q==
Date:   Wed, 22 Jul 2020 14:57:33 +0000
Message-ID: <5acf7502c071c0d1365ba5e5940e003a7da6521f.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
In-Reply-To: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60530ab6-8501-4f78-a3db-08d82e4f90c8
x-ms-traffictypediagnostic: MW2PR18MB2156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB21569041D9529EFD3BAAA03FBC790@MW2PR18MB2156.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kAcENqRTVC5LJDNWTFi0gJmqH2I+N5X/pfX1V9oBWY4/qyx7ShZZPp5Dc/7ZIfLdcXeCQk2sxHyi7MsmO3DOlAhXRtgug7/EwIVwIxWPB0Or+BHjY0GbOVv3rJXlsFLnQn8iBomnc6kszGA9291xRqBV+SNEN958jtLcVIKkjWWZJ5ir2FVeRSRoJjuZv0Cub7G6iOVGhmPfTH3gh/HrVdfswglAzLCWWGu6W2f4c/H+btRK2P7LqmJu0mR2UNIS27TlGDqVY2eKvJFNJyH/xGOHDXF0YRtKsVu0BuXx9P78Tm8MMjWgwCTFA+tMDvsBAjLJUJYkG+fipYcaboYBnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(4744005)(110136005)(6486002)(2906002)(6506007)(54906003)(66476007)(478600001)(6512007)(8936002)(2616005)(8676002)(316002)(4326008)(66946007)(186003)(64756008)(86362001)(83380400001)(76116006)(91956017)(5660300002)(66446008)(36756003)(66556008)(26005)(71200400001)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hswFjFfQgQYiuGRCvgk40lPngN77FXIzxt8LURz8O65T+1PLG18Uk5zwZ8uvbF7Ik6iW8iwFxbooCp4hpDjR74dnQdtmSoIMz6cUUZl1EfByxnX/3QQ7eFJtQs0f4LAvSr4rZdSPJ+ZIVIngMoY62TH41L2XdsDRPVV9Beuep4CcH/L5M7uvtLUSLsRisW9rZ8UPjQgtqG/r3u2Dep3pvvPKkpI3fPAr6bI9ytvP7A/L8ognHyFMCtLV0S/s7XQYo2tFWi7wprYtipWgug5/y2oB0qVbLrfhpcaSs3SO7+QA4ZVv6xHKGQQUcuNtHDTKDp6yH6XrS5xHcHSWq9/yjHT+ak+P/Z2KWJWfFCBpdSCggpWm4GxGQ2NKGfJSCmW35Mo45a/+g/KhgQj22OkYQTuIHxj4CH/Jkv95prSKWmiWmlVjrgErrv1Ix8n23tnA9kemjK/Xz7brdP5HqKK0I9Ngn5XmS+yfBqy0bPovHQu4PRnnXF1V/haa7ZHWfARE
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D078BC1A3E6A443A62F85A300A63A00@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60530ab6-8501-4f78-a3db-08d82e4f90c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 14:57:33.8038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k1ncmc415f4yR0Orvm+hvx+HAnxoA9diUWrhilJ909VBki5tlOwBAVbVp/a0GwtRS+kh0xjjeGfj2mUUSdno+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2156
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_08:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KDQpGb3Igbm9oel9mdWxsIENQ
VXMgdGhlIGRlc2lyYWJsZSBiZWhhdmlvciBpcyB0byByZWNlaXZlIGludGVycnVwdHMNCmdlbmVy
YXRlZCBieSB0aWNrX25vaHpfZnVsbF9raWNrX2NwdSgpLiBCdXQgZm9yIGhhcmQgaXNvbGF0aW9u
IGl0J3MNCm9idmlvdXNseSBub3QgZGVzaXJhYmxlIGJlY2F1c2UgaXQgYnJlYWtzIGlzb2xhdGlv
bi4NCg0KVGhpcyBwYXRjaCBhZGRzIGNoZWNrIGZvciBpdC4NCg0KU2lnbmVkLW9mZi1ieTogWXVy
aSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KW2FiZWxpdHNAbWFydmVsbC5jb206IHVwZGF0
ZWQsIG9ubHkgZXhjbHVkZSBDUFVzIHJ1bm5pbmcgaXNvbGF0ZWQgdGFza3NdDQpTaWduZWQtb2Zm
LWJ5OiBBbGV4IEJlbGl0cyA8YWJlbGl0c0BtYXJ2ZWxsLmNvbT4NCi0tLQ0KIGtlcm5lbC90aW1l
L3RpY2stc2NoZWQuYyB8IDQgKysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYyBi
L2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYw0KaW5kZXggNmU0Y2Q4NDU5ZjA1Li4yZjgyYTZkYWY4
ZmMgMTAwNjQ0DQotLS0gYS9rZXJuZWwvdGltZS90aWNrLXNjaGVkLmMNCisrKyBiL2tlcm5lbC90
aW1lL3RpY2stc2NoZWQuYw0KQEAgLTIwLDYgKzIwLDcgQEANCiAjaW5jbHVkZSA8bGludXgvc2No
ZWQvY2xvY2suaD4NCiAjaW5jbHVkZSA8bGludXgvc2NoZWQvc3RhdC5oPg0KICNpbmNsdWRlIDxs
aW51eC9zY2hlZC9ub2h6Lmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0KICNpbmNs
dWRlIDxsaW51eC9tb2R1bGUuaD4NCiAjaW5jbHVkZSA8bGludXgvaXJxX3dvcmsuaD4NCiAjaW5j
bHVkZSA8bGludXgvcG9zaXgtdGltZXJzLmg+DQpAQCAtMjY4LDcgKzI2OSw4IEBAIHN0YXRpYyB2
b2lkIHRpY2tfbm9oel9mdWxsX2tpY2sodm9pZCkNCiAgKi8NCiB2b2lkIHRpY2tfbm9oel9mdWxs
X2tpY2tfY3B1KGludCBjcHUpDQogew0KLQlpZiAoIXRpY2tfbm9oel9mdWxsX2NwdShjcHUpKQ0K
KwlzbXBfcm1iKCk7DQorCWlmICghdGlja19ub2h6X2Z1bGxfY3B1KGNwdSkgfHwgdGFza19pc29s
YXRpb25fb25fY3B1KGNwdSkpDQogCQlyZXR1cm47DQogDQogCWlycV93b3JrX3F1ZXVlX29uKCZw
ZXJfY3B1KG5vaHpfZnVsbF9raWNrX3dvcmssIGNwdSksIGNwdSk7DQotLSANCjIuMjYuMg0KDQo=
