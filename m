Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6F317D149
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 04:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgCHDzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 22:55:04 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16808 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgCHDzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 22:55:03 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0283l0kG016589;
        Sat, 7 Mar 2020 19:54:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=7uwLq7YtkP35e1XF36deYTJy3st9hj5NfCBESg1sgqA=;
 b=aDxLXv6jI2gtvd/E1CpsJwgnEpZaHfpAJnR9ORoS2Gs7YV3/1xZ94C8gvMp4xVvoOSdt
 xaSgkd4gotoviYJ8MZxkZJ+qptO4A1qi0Z7hNu2EbWdfUt+g8gl2+A2T32nNnji1hjKM
 RYyEknKxGClj0qEcRqYNx3A2uoBlMuLaT98R5yi6uFY/NWuqdYDWTyJoGjnmYhTnIu9q
 POYx683Ut18A1jUUpFlZgAk3AMuKOOaw6bIa0hRNu6j3b9IfkefFvoNWLH2cTZUcoYQZ
 K6rD6oBSFa7Sm4kUBafHBcqrLsJ1uVhSnXs3JoPzw4eKIgx1jeDbFPcIxibPHDMcqcsb PA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ymc0sj233-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 19:54:36 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:54:34 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:54:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 19:54:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HetgxSTp4X6Sqaw2DfwlN+Xwc9peVZpEa2t1sTNnDOcp8ConfBdoYn/N7DRT8lHqfv7AE7/DMRddIrpRXG40vQCIcovAMnjHIbd9X5wCh5lo2TBl5k63hU/eFVrNKd6PNGydYHRAbdc867TK9v1VeWZeHmss6f8Eqv0bOVY6VFWhDOoVf/fzWoi+I1YKHmJE93UWtI9pOak6rz25fPW8b5QNUmmUW9NOrJb/tsShswKiWEjyVN5uP+VEywOtP7e+FNB7m5tQcMZBWedBP3lAcoZdz/G5qTXuxOhgWvSq0Pv165iveJMmzS5EuV8jMlqWa5iUrEgKCfhJ/wqv8c3l0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7uwLq7YtkP35e1XF36deYTJy3st9hj5NfCBESg1sgqA=;
 b=jVLv76X1loXtmQAAJnDcXNYIM8buuIvT/0mwwdNvGJnszTSsi4BaZzUOnMPWpy9yyzndMXJuAvifjmQ+JQhYDfldRPEBUZ3p57WJxxU+KxDIetyu+uv0EWN4+zxkc48O9CuyvQ9PhvYp5aUM2TKUgkocsU40P0L7lUiDiywX5G81nJB2pj4CZhgX89Ce/rtIRxjTzLDBIeprlal3XqhG9I/eREtDkyxuaRpkutGcSHXz7ke1/Cpd6Ei80Ru2dg3zGaXQvp//3thA535NWjXIuEOtJzf5kA6+XkFSxaLNMICgvmnZYevbzr9xoDeS6bQokzdFuUNnm4Mp5ruxiBp7Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7uwLq7YtkP35e1XF36deYTJy3st9hj5NfCBESg1sgqA=;
 b=HonBtHpCd+MEDbXxHLzfnezKlEffOrxfNnXwidTRJDhVb3C+eI9OGND+YeCQVRCJZxQl52AI5SflfM8zBe+iXugtKNGD6W8tMyqEvCEVIyZrYf3/4JLs/Nza9/5QFL1ElH7NJi7wy2auYbt9cQN9prc6kjrej36wsNOmGKoR238=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2661.namprd18.prod.outlook.com (2603:10b6:a03:136::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Sun, 8 Mar
 2020 03:54:32 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 03:54:32 +0000
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
Subject: [PATCH v2 09/12] task_isolation: net: don't flush backlog on CPUs
 running isolated tasks
Thread-Topic: [PATCH v2 09/12] task_isolation: net: don't flush backlog on
 CPUs running isolated tasks
Thread-Index: AQHV9P1GBrz1yVmd6UuxuMn6UClzgQ==
Date:   Sun, 8 Mar 2020 03:54:32 +0000
Message-ID: <541d4f371541b5085fb3519ae749d9ed8f056aeb.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
In-Reply-To: <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8999706-7442-4b2b-fb53-08d7c3146949
x-ms-traffictypediagnostic: BYAPR18MB2661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2661AFFF59E6D64014468D66BCE10@BYAPR18MB2661.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39850400004)(136003)(366004)(396003)(189003)(199004)(5660300002)(186003)(26005)(66946007)(66446008)(66476007)(64756008)(66556008)(6486002)(6506007)(6512007)(91956017)(478600001)(76116006)(7416002)(4326008)(2906002)(86362001)(36756003)(71200400001)(2616005)(8936002)(81156014)(8676002)(81166006)(54906003)(110136005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2661;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mu1sfgly1DrRSKkw/cBHFMYr5+Sj9Cs/L8HaKefOEMP9NODpmYnSXPnNr9zOyknnpKbuHufMJPWvvZnbUe8KLU7gMJF2aMJluGzuiswdA5NiAwArTN1Xcu6r7CC5ssnEikql9JNwZ8ggL7XfvgqjdSbg8TSrQeU+JB/bY36rhnUWZUC27QnHR0x+bhwr8BUuo7epsnRjX9EQfs/o6NhoHLJHMQz7mt7idFKyOiMv7WGN5LxCVSoFQdl9uCc5GT692VPLou8wgTa4ZKBdaBJzBOD9F6OADP43HUG0+2sCuZKiQWL0P011L6rUGEO6g4ytqhS0sMM7uG9SnvClT8vvDMe5A7QyjkRPcia63VttgKILQXxCLs4rubPVoOshGkEYZexO2F6c1ES/Y/VdUXMf10ShVSLyv1Uwo6/gNRFfprwI7oVLC7YiA4TGcM7/Hsrj
x-ms-exchange-antispam-messagedata: q94X6Ph4bEe5bpb0ppead4Gq6gMyET0mUaUi6WoVc2IrPfj0KG5dbTrsHg8n9bfFArFdyGK291beOMAJGYwgM9ASKQAeUB7lNS4t9Xpfhgzt18dmqHMK5D7SQlSTYW0xKtZ4oirDAIxjOpYDdkY9/Q==
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C9919D0E1E70145A8395AD0A6D070D1@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b8999706-7442-4b2b-fb53-08d7c3146949
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 03:54:32.7683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SlInwuUat97o68Y0AEahB/x+4LwoTzZ8iRUjYnb4eGWUnVPcHWkYKdSrh3FATmpe+D6BpK1rUVeDHyB790oTCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2661
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-07_09:2020-03-06,2020-03-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KDQpJZiBDUFUgcnVucyBpc29s
YXRlZCB0YXNrLCB0aGVyZSdzIG5vIGFueSBiYWNrbG9nIG9uIGl0LCBhbmQNCnNvIHdlIGRvbid0
IG5lZWQgdG8gZmx1c2ggaXQuIEN1cnJlbnRseSBmbHVzaF9hbGxfYmFja2xvZ3MoKQ0KZW5xdWV1
ZXMgY29ycmVzcG9uZGluZyB3b3JrIG9uIGFsbCBDUFVzIGluY2x1ZGluZyBvbmVzIHRoYXQgcnVu
DQppc29sYXRlZCB0YXNrcy4gSXQgbGVhZHMgdG8gYnJlYWtpbmcgdGFzayBpc29sYXRpb24gZm9y
IG5vdGhpbmcuDQoNCkluIHRoaXMgcGF0Y2gsIGJhY2tsb2cgZmx1c2hpbmcgaXMgZW5xdWV1ZWQg
b25seSBvbiBub24taXNvbGF0ZWQgQ1BVcy4NCg0KU2lnbmVkLW9mZi1ieTogWXVyaSBOb3JvdiA8
eW5vcm92QG1hcnZlbGwuY29tPg0KW2FiZWxpdHNAbWFydmVsbC5jb206IHVzZSBzYWZlIHRhc2tf
aXNvbGF0aW9uX29uX2NwdSgpIGltcGxlbWVudGF0aW9uXQ0KU2lnbmVkLW9mZi1ieTogQWxleCBC
ZWxpdHMgPGFiZWxpdHNAbWFydmVsbC5jb20+DQotLS0NCiBuZXQvY29yZS9kZXYuYyB8IDYgKysr
KystDQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpk
aWZmIC0tZ2l0IGEvbmV0L2NvcmUvZGV2LmMgYi9uZXQvY29yZS9kZXYuYw0KaW5kZXggYzZjOTg1
ZmU3YjFiLi42ZDMyYWJiMWYwNmQgMTAwNjQ0DQotLS0gYS9uZXQvY29yZS9kZXYuYw0KKysrIGIv
bmV0L2NvcmUvZGV2LmMNCkBAIC03NCw2ICs3NCw3IEBADQogI2luY2x1ZGUgPGxpbnV4L2NwdS5o
Pg0KICNpbmNsdWRlIDxsaW51eC90eXBlcy5oPg0KICNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4N
CisjaW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQogI2luY2x1ZGUgPGxpbnV4L2hhc2guaD4N
CiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KICNpbmNsdWRlIDxsaW51eC9zY2hlZC5oPg0KQEAg
LTU1MTgsOSArNTUxOSwxMiBAQCBzdGF0aWMgdm9pZCBmbHVzaF9hbGxfYmFja2xvZ3Modm9pZCkN
CiANCiAJZ2V0X29ubGluZV9jcHVzKCk7DQogDQotCWZvcl9lYWNoX29ubGluZV9jcHUoY3B1KQ0K
Kwlmb3JfZWFjaF9vbmxpbmVfY3B1KGNwdSkgew0KKwkJaWYgKHRhc2tfaXNvbGF0aW9uX29uX2Nw
dShjcHUpKQ0KKwkJCWNvbnRpbnVlOw0KIAkJcXVldWVfd29ya19vbihjcHUsIHN5c3RlbV9oaWdo
cHJpX3dxLA0KIAkJCSAgICAgIHBlcl9jcHVfcHRyKCZmbHVzaF93b3JrcywgY3B1KSk7DQorCX0N
CiANCiAJZm9yX2VhY2hfb25saW5lX2NwdShjcHUpDQogCQlmbHVzaF93b3JrKHBlcl9jcHVfcHRy
KCZmbHVzaF93b3JrcywgY3B1KSk7DQotLSANCjIuMjAuMQ0KDQo=
