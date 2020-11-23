Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7B72C12B0
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390555AbgKWR7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:59:02 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19450 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726817AbgKWR7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:59:00 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANHsiJi021464;
        Mon, 23 Nov 2020 09:58:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=XdATJSpoCgQBdRF9UUyxPd2r0o++/lQNfaFSdjxtaio=;
 b=BbhyOL8bI+qLInsoDEBV4Gh2RhZE6I8nG5iic6BNhBrnGPfKcxlQe2+321PeHialYBFJ
 kUSmTq57XTlmMVdpUX2l/efei25QJjeueQb/zL5GD8SCtmnu3cpwHXYeQxndVtBxTb52
 eGtKS8fCDh0q1nZ/41pn0OdZKUEXcSsMMl4QC4gaAvW2auanEBxTBntAaS0KfCb/Fk9p
 h0TZsRflp4CGw6qCbt0r16DL6P7dAUO8TzURXtNddraB9JIgf6n/1uDVLCYiC47Snfpy
 uUwsUi4KntTr4tJtDDKwU5cVU/bS7AfS55pdEB+DnaJzuaENul09lbsmSgVikOAXQCtK 5A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39r6dnj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 09:58:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:58:25 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:58:24 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 09:58:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuAxJmgA65qMso3rrvrDr1n7+75yRPhkcvaQcSRGedTTNl7GJAbcrpw+j8IPtwEzh8tdf8Raqt0l6h0gCEmHV2Dqa+JxTSa0zMkt4taqeFNFqnO63VR5YjdP5icdbfL+muK6L/e4JIvmLFBSvit3vhHgALd/g4dGzDpVtvisvUZyb91J7L2OKDa9ZCOdI0admNZYPvjtCqxyWtlbDHV2Jev/bqdKx0wof/RbFe4lxrLiopGcFxLwL0DYEFAmLmZHXLAov67aKuYJcjFYKPtNoXY9tup0Ku2aen/j0fWrLvGQZOKA7Ne7zMPcqdUhQ1Wd397nrCPPkMjLfX2hQexIFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdATJSpoCgQBdRF9UUyxPd2r0o++/lQNfaFSdjxtaio=;
 b=UcTgJSBwF3lXkz0NVHtkLVcAzm0DcLgojBQABjldmeHZc2bRZ1lxxvIOVJz82vkcecdO9VQk4OjZf3h3eoUlVgODc/EWCFkY6U9OjYQSQfjbQ4oh5OzP3X49UAoCCR4GTerM9/Gn9VyFbzRacyowPMPxrsxqwsR4ONNIZqHzDgFcvwQlZTO81bCS0N8PKnrdsWLGGmjzJ/UvDdbaQAgL1b9K5Sj0gO6XFBQFJCZYLdL6+nIy5Asbg9dJslOnL5h8nO/pJH3U6Nf75QyhqhjXncLlvzqUG36ym69NF1WPG1LPEUbqIgde20Y/0s9xvzs7LxijowcEMaSWYM/LvuxDVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdATJSpoCgQBdRF9UUyxPd2r0o++/lQNfaFSdjxtaio=;
 b=lOcVajSTeCkc/woZt0aYFJn7FrBX8L2sRFdlA3vSfEVojjWk/gAt1nr7TsbAsR1VSw3t/cOPkBIv3RKyXuy9gxle9NANEzrve3nm5DhWhQ+c4MrsUvuewNje284afdL/iJ4BTka5KuMIo8U4Etw6j07oBFXDREftlmVnziGRKg8=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW3PR18MB3530.namprd18.prod.outlook.com (2603:10b6:303:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 23 Nov
 2020 17:58:22 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703%4]) with mapi id 15.20.3564.039; Mon, 23 Nov 2020
 17:58:23 +0000
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
Subject: [PATCH v5 7/9] task_isolation: don't interrupt CPUs with
 tick_nohz_full_kick_cpu()
Thread-Topic: [PATCH v5 7/9] task_isolation: don't interrupt CPUs with
 tick_nohz_full_kick_cpu()
Thread-Index: AQHWwcI7UCf8Z8jL1UuRW32Ea/eUhA==
Date:   Mon, 23 Nov 2020 17:58:22 +0000
Message-ID: <76ed0b222d2f16fb5aebd144ac0222a7f3b87fa1.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: cea56759-e00c-492c-c81a-08d88fd95e8f
x-ms-traffictypediagnostic: MW3PR18MB3530:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB353074AA903BE50AA8C123BABCFC0@MW3PR18MB3530.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bLDrjD+9lnjmxV9F+EySYhTlotHp0FjHcIrUjdVoLAAQB42DwvoeHFRaze9tSdD9xhLp6rrPvcOB3gfcpBLiT6/FzHK/Gy3OcyBHqDtg/0rlusiRnAkWp5msAAors4tcvLB5rlAVta1bsYvtgjAPpCkGmW4j2AFWzwZpIK/4auTBrCEwg2wGf7imgb+LlQMtGG1xvRSmcOgheJPx4rArZeVqMWg8hzA4bHpJ/LEu4oUcScONx0oFG4RfxChgZXVVugMFcYajRWbQ4y23MWqd58rYdpZS+awTylWWLq4e1Ot2oWLt76QR6GAoN6l/HibttQFndlK7CgeSRYoIq/UugQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(2906002)(2616005)(71200400001)(5660300002)(6512007)(83380400001)(110136005)(26005)(54906003)(6486002)(186003)(6506007)(36756003)(66946007)(8676002)(316002)(478600001)(8936002)(86362001)(7416002)(66476007)(66556008)(64756008)(66446008)(91956017)(76116006)(4744005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KG7oxR91hDBvUIpN/2hA7AWWFm21HMzpjBYEyEtwZ0Hn2AfNKwSwP230FCAD3dhUmRlpTtRUWy7hjBVi03wmPPo3l+F2xa16XqLnQkCroM9l23UbsrBZbC3myP12inA5SvdpNk2SFXPJpfkXMlX4GDZF2cxsLw0Ohv7ObMkkK9wMkkIx+HmKI3E46vhQGwKYgURyzxRCo5zNS4DmjKqs4WjtkORl/049IMVWfd1GjEDe2IqA0RV3JCvq4kLwUr+3O4FpCwjww4HWsAxCIcmaRHF+ife8+ROpi7+0JHbwb3NyGtZjV2zonoqJdSZ3pheggfRdFXulX91fgpraB94Ms/J6AOuwriZrISpooNG24MELYjh2fWowg4bUxiWC6G33VqcEp59y7ajuj/UmoeQ1PFuZsWTzy9U0GVHDpVA7O8XEvt5C3zja7wDRobQYhistVdYhIArC7O8DWZzq8fZ/fKKniCxC0K6PudyE73s34eHDBjvyKYTBrUQTPSJYaGlWfserIDxtfbz9VnGtPL1QiNHURD+lVU6QvkXbdjAqvNDxmBhMJa9Rla8UrPMTIPasJeAlDl1ssh15gJJYRqxXvtkOZjIpvs06buQHmS2LcJudkvo3NxbgzDC3CKUSXFpoXR/tFIucg7lcb3MeJp8d9iBZ8uLM6V8tIddqkErrC3G4d8pRNaAlrhzSCl4wSaBDKhCs2VpdWNNZYkKa8epYMHWBzSLCXQ37hYHjci2BA8q6iIsUkLccjmT8DebECsSrkE/c7dsCeyfE/SGQ3RlEBhVnIfZvTWX6HlxFXC+7YfG0i+wIbrGoIdzqsy0AcuFTpcTlEL6Nn4+JXd5bYjd890or7iVzLIzyyf6gq2x/kk4MHY6775rf/Q4EenIQJcuBnOJPuaFr52O4pCrIm7bCcw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B210837B09A36F488B1E5C6799E94518@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cea56759-e00c-492c-c81a-08d88fd95e8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 17:58:22.8372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zDAfApfUXSDuufDXRJM2KfzvBkMCj8DhqrMEZsiXfnjqCpS/9SI3IthFoAh3bRarU9naR263bnE32olvyY5aug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3530
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
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
L2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYw0KaW5kZXggYTIxMzk1MjU0MWRiLi42Yzg2NzllMjAw
ZjAgMTAwNjQ0DQotLS0gYS9rZXJuZWwvdGltZS90aWNrLXNjaGVkLmMNCisrKyBiL2tlcm5lbC90
aW1lL3RpY2stc2NoZWQuYw0KQEAgLTIwLDYgKzIwLDcgQEANCiAjaW5jbHVkZSA8bGludXgvc2No
ZWQvY2xvY2suaD4NCiAjaW5jbHVkZSA8bGludXgvc2NoZWQvc3RhdC5oPg0KICNpbmNsdWRlIDxs
aW51eC9zY2hlZC9ub2h6Lmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0KICNpbmNs
dWRlIDxsaW51eC9tb2R1bGUuaD4NCiAjaW5jbHVkZSA8bGludXgvaXJxX3dvcmsuaD4NCiAjaW5j
bHVkZSA8bGludXgvcG9zaXgtdGltZXJzLmg+DQpAQCAtMjY4LDcgKzI2OSw4IEBAIHN0YXRpYyB2
b2lkIHRpY2tfbm9oel9mdWxsX2tpY2sodm9pZCkNCiAgKi8NCiB2b2lkIHRpY2tfbm9oel9mdWxs
X2tpY2tfY3B1KGludCBjcHUpDQogew0KLQlpZiAoIXRpY2tfbm9oel9mdWxsX2NwdShjcHUpKQ0K
KwlzbXBfcm1iKCk7DQorCWlmICghdGlja19ub2h6X2Z1bGxfY3B1KGNwdSkgfHwgdGFza19pc29s
YXRpb25fb25fY3B1KGNwdSkpDQogCQlyZXR1cm47DQogDQogCWlycV93b3JrX3F1ZXVlX29uKCZw
ZXJfY3B1KG5vaHpfZnVsbF9raWNrX3dvcmssIGNwdSksIGNwdSk7DQotLSANCjIuMjAuMQ0KDQo=
