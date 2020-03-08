Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35EC17D144
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 04:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgCHDyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 22:54:05 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55008 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726138AbgCHDyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 22:54:05 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0283l1im010585;
        Sat, 7 Mar 2020 19:53:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=VshAxQlrpDGqLX3Ub9gD9awNJkWKsqMZMcz/QPzm4d0=;
 b=c+cPXSlvmKl0zbzWE2DqoQrEsqoCQjZ6/cG75qffbYZy7RpRSw8SiajIDjEUCJVDsqQ+
 hRIB46QGdBppsChhFAeTOZ9Jzivh+Gcp+qPwPO8JA/dQvVl+pGWRcaMxtS4yaH+5BCTO
 mOed1WDuYofkvEYwhMvsqD/hWPbwzH+YfDehzL7IBJOUNl6v5Uxmn6JqNcmbdmGKuVTV
 rqmBj23ll9nmUukWG6L8drJJOvNykxG/ctewH1kM13DPT1Dn/WrPwjSMmipTLzJstBF7
 snxpejZty5ZRxPum9ojoFHaDQ6F+xJHxqIU/3EUHqL5u30SUlCWsd/urbimf3lfn2MGf FQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwavc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 19:53:38 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:53:37 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 19:53:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iId1pAbZNQ8JgSQg06mNPFAsZmhu7RvxI6UwFck/+zGUNaOJisQ1tvcxSXt1oJp360cPo04cXn1vUxZSIC1QLJG3k2bPgwah9enZmLuPwKJ+CYHat3YEMwmb7ol31aPCT8nFeMZ31nKf8++yTF12icmyRLOUFcAFlUqc4o6ifA5c9i+JV4BscOF5dRfnDt1oVlPWuqpJWDv0HXs6U5xKt0atdvLvl7ABxmHFeeqYUhBPIQlknHmB9rYdE4Tr8M6uh5tfmH3u3ZnfJfzgiexkDLWDi7HiPH3rNJzHZDMZ+WOvjWfzOUGbxXg6POLPT2dCKp6mcucwClll0MupCnuePA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VshAxQlrpDGqLX3Ub9gD9awNJkWKsqMZMcz/QPzm4d0=;
 b=GvBCODgI6XaMsttxXL48Ygdc571+f3VuvpQV0Na4io1ySgDkwKGansBL5tB3yrROg+xKj3oPDM2emCOi/XXW/s6ZUYH+6hxsIEh0zb+8TXbX22nvkBRy6cJfHjV/wGN6brd+ghYDH9hGGqpVtubkhpuDys/9Rc7cIGl0MdoZDFJa5rcTk5rDc+CqId7K0OEFxfs/g6P5F1Ogv2WiwfyAfN5Z23A83r/kHHAYwE768HLwx6vitZ6nNXXvY2UPmodD2EndTZNeXebuxeMZlZdNV+EYmOSk3un9bwjfc0WmFdIlaFsXbMQh8feFWnSsiBR4PkYWPwqA8GK6WTWYsZb1ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VshAxQlrpDGqLX3Ub9gD9awNJkWKsqMZMcz/QPzm4d0=;
 b=m0s/rxSsSgxsdO4SdB6qtiBowW+sMpUAlNTQBFQL3mAKbqhrI5qApQoOMUwQfxysaUe5zSRnkarnuXgNTvWufSuywapH+KSeiVv8F2DbeBG15g0/ZARj4Iw73IEBaOJVC6JkX8ifBdovHYYeSluxVn+TNSc9c9sX2iIZIyiKhqc=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2661.namprd18.prod.outlook.com (2603:10b6:a03:136::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Sun, 8 Mar
 2020 03:53:35 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 03:53:35 +0000
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
Subject: [PATCH v2 08/12] task_isolation: don't interrupt CPUs with
 tick_nohz_full_kick_cpu()
Thread-Topic: [PATCH v2 08/12] task_isolation: don't interrupt CPUs with
 tick_nohz_full_kick_cpu()
Thread-Index: AQHV9P0k4GMnIbRPmkShfBNP7hpH9A==
Date:   Sun, 8 Mar 2020 03:53:35 +0000
Message-ID: <0b4615be96008d1031efd3ed309437c05d564019.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
In-Reply-To: <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e45a13b-7eaa-444d-32e0-08d7c3144730
x-ms-traffictypediagnostic: BYAPR18MB2661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2661306AAC3B05F416AF05B3BCE10@BYAPR18MB2661.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39850400004)(136003)(366004)(396003)(189003)(199004)(5660300002)(186003)(26005)(66946007)(66446008)(66476007)(64756008)(66556008)(6486002)(6506007)(6512007)(91956017)(478600001)(76116006)(7416002)(4326008)(2906002)(86362001)(36756003)(4744005)(71200400001)(2616005)(8936002)(81156014)(8676002)(81166006)(54906003)(110136005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2661;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w9bPIUUzRiYavzQsGz27feKKQf8amrol5kYqO7iXcCaEp8nzSy1wJS3UM6lmsNKetDMCHDMxfksjTTHV+JqDDeeVF9iyV20xul+ZVXK6WXkamgAlQ0+cWFqIxoDZEhmHXWBfBkBtiCC1XtXsn0rZGcmG8W9+XthgjRby9V0kDV1BrCwjfBZI9aMLTsDUWwCDWqWSJNO7xEHN3cI9GdardtUE/2nIBkiDStouejbC6aIGa+8fgQISTS4Nycq1FtiXQeGw6zMCPpRnUZwwmpMG8dZPM9hh1KYvH4Ni/2rlPVqHK7paDSHn3M3hMKcf3tkFSNiX3PCsWFx0AjeKlopfzA1FJbdFcxN9RccNRn7pYQVxFaMrQK9QRnEmu6d9VAHNfcJ/Lso7q1flujlkcbqWoGCfb28l1Wk6jQONikJtedVMVGx5icynODpZWFm6bI0b
x-ms-exchange-antispam-messagedata: wyFtbJwbo6uu250MoBQgzm7ZNyMUyGQO2/miTojm5/qyvw0WKKMRBHvmyOacwPPdqHRInbiCNY4K8slZeUaN1624bOfG6jpax/sC/Y1XGp319fM8pDRyNspFPiMfq82wcrsWLWiwTuhsIHWvfwwJvg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <12BFA578C199064E880E6064C4B51C83@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e45a13b-7eaa-444d-32e0-08d7c3144730
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 03:53:35.5828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: niHMUmcgY/fF4N9xHpXroHTwFYtzu4p3oiRGrstz1DZ7DXcdet+XUAxR0dX5qMW6MyQERa6y8/fum4Mdq6j+ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2661
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-07_09:2020-03-06,2020-03-07 signatures=0
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
L3RpY2stc2NoZWQuYyB8IDMgKystDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEva2VybmVsL3RpbWUvdGljay1zY2hlZC5jIGIv
a2VybmVsL3RpbWUvdGljay1zY2hlZC5jDQppbmRleCAxZDRkZWM5ZDNlZTcuLmZlNDUwM2JhMTMx
NiAxMDA2NDQNCi0tLSBhL2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYw0KKysrIGIva2VybmVsL3Rp
bWUvdGljay1zY2hlZC5jDQpAQCAtMjAsNiArMjAsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9zY2hl
ZC9jbG9jay5oPg0KICNpbmNsdWRlIDxsaW51eC9zY2hlZC9zdGF0Lmg+DQogI2luY2x1ZGUgPGxp
bnV4L3NjaGVkL25vaHouaD4NCisjaW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQogI2luY2x1
ZGUgPGxpbnV4L21vZHVsZS5oPg0KICNpbmNsdWRlIDxsaW51eC9pcnFfd29yay5oPg0KICNpbmNs
dWRlIDxsaW51eC9wb3NpeC10aW1lcnMuaD4NCkBAIC0yNjIsNyArMjYzLDcgQEAgc3RhdGljIHZv
aWQgdGlja19ub2h6X2Z1bGxfa2ljayh2b2lkKQ0KICAqLw0KIHZvaWQgdGlja19ub2h6X2Z1bGxf
a2lja19jcHUoaW50IGNwdSkNCiB7DQotCWlmICghdGlja19ub2h6X2Z1bGxfY3B1KGNwdSkpDQor
CWlmICghdGlja19ub2h6X2Z1bGxfY3B1KGNwdSkgfHwgdGFza19pc29sYXRpb25fb25fY3B1KGNw
dSkpDQogCQlyZXR1cm47DQogDQogCWlycV93b3JrX3F1ZXVlX29uKCZwZXJfY3B1KG5vaHpfZnVs
bF9raWNrX3dvcmssIGNwdSksIGNwdSk7DQotLSANCjIuMjAuMQ0KDQo=
