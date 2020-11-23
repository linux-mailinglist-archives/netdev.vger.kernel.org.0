Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23ED2C12B3
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390570AbgKWR7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:59:15 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48446 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390562AbgKWR7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:59:14 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANHteX0032523;
        Mon, 23 Nov 2020 09:58:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=BVwqlvoPhM/wuTJr+wxw3IWTjQZ6NEVvb6vvs5Ie2Bg=;
 b=N32Zmxq9JvqrpfyYB8MHByGZ4/L6QqGNOP5CBth2Q5qa7HuRQLv0kDwLRK8evwMv2xUP
 rlW4Hc+nfM2IFPQmrx1tDJ3z0XHpsLeQXd1m8LDE0wITRHqw8NFD5YBeKbQDDuj1RSKA
 V8RuBy+EjOP+GzhB7aVEJD9Gr9r648cof1Hs626ivR3nGm70mCEF+SkpM7RgVEdWCPNq
 5tju0/KEcEeza/KcOLhMT/Hk5kdFYltpzCz6/qupQRM4PapGhXbv7fllXggHrDTm7pR8
 daxtmW82PJhXA81nziWYPshkYbqX8hWq7a01bAuqNLdDG/HyxKFnsGUFj0T/U8uO4DOg hw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34y14u6u44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 09:58:44 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:58:43 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 09:58:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxZSWSVGuWLFMz6+Cc3wuEy93bPj4j123CHEp+hNDhnUnj4GaMEWpcxJwSa3n+wdWX7qdSDzF6+g8/exvJN2m+Zn8qAdEcOmKVVJuwZ0TeUzf6YeZUs5//JVxtZpyHcpM2f7Hf9PqyWI/faERK0tG5C0IRDwczdg7IfaTJJ4dUnwfVp2bvrTdlzEdiIfUYlTVjedfIWT8NEbhShOFJcqfl2n6Ya+4BGpGBcMrJ92VdPl73b1Q4amwdcDZU9odgFXiYWo0QgqOXWQUDeJuQC2FKEGWycTn308sVbAi3jMy2bIT3ho0vDJfy91Hzu6bmbURT2b/8Evme7UvGBXcQSW3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVwqlvoPhM/wuTJr+wxw3IWTjQZ6NEVvb6vvs5Ie2Bg=;
 b=jS4LmarhlpJ0Ui9dTOM/7LOnwqq+x16N3jiDGwpsU/KXA7FeBusE9lhw4om5dy5zDmHnf497wATJFEiivw/mgVH6T5RK39p8CXe9hhokAu2tc2SPh1i7ys+U9o9yDBUt73g6OY6tUylAF3c3Y2mQCAiT74ytJpU9KJFQoqP4LH26mOLpH6Z6LPnMrQnQU69S9LtoyeB6T1VA2XfiM4xSkIVnsPCVJx/iJ6ZCY/wdk8kYqevD+Idz/CExyDy1GC7/XycuFnz0N6HNsD5Jmd4OrTKeVj4202edAWJIGTeTFM3pcVSI1u/jdkTN/q3TDduPoVNponJ0XzZieSouYE5ynQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVwqlvoPhM/wuTJr+wxw3IWTjQZ6NEVvb6vvs5Ie2Bg=;
 b=VGv332Uysji/q4eXDp6SF02OLtuenqj7Yj4QkcJypepdZdrIVkTtMxSPTLZTqWHueyw9Ef3/W0D3MA1F8OXSM9I1dReKKKmqFaRzyXI5FaxZtjKSQKXQyTOMGVmt2JvTZZ3Y7LIen89ZSq9mXSDsgssxrXNHLaEIMPXRyRcpSAk=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by CO6PR18MB3954.namprd18.prod.outlook.com (2603:10b6:5:34d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 23 Nov
 2020 17:58:43 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703%4]) with mapi id 15.20.3564.039; Mon, 23 Nov 2020
 17:58:43 +0000
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
Subject: [PATCH v5 9/9] task_isolation: kick_all_cpus_sync: don't kick
 isolated cpus
Thread-Topic: [PATCH v5 9/9] task_isolation: kick_all_cpus_sync: don't kick
 isolated cpus
Thread-Index: AQHWwcJHihlNClCxdEOODDjRi5wCaA==
Date:   Mon, 23 Nov 2020 17:58:42 +0000
Message-ID: <3236b13f42679031960c5605be20664e90e75223.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: 7614d635-248f-4799-17b3-08d88fd96a81
x-ms-traffictypediagnostic: CO6PR18MB3954:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB395460FB2930A19B68618E30BCFC0@CO6PR18MB3954.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qER3sfnTTuDLLWWCARVG9rtl20GVKOxey6n1X/MREWonKNi2lKgmuan4dgsjilqAU2W/s1G5zlZhI9vIsACUq5d9njWfVYvk4lsy5mZyJ4ZvqMVbF5KBQ/PjklVkZFLuxiYLeH+qxsTZqMol8puOgbW9fp6TBEmrNkUSPD5j5W2zPoRcJvkP3pE6dFPkSCIwumiu6+vlH8ia+e4Qoc6EOTkKU/Rk2hMJceekVnNlb/lyI3a6FoBLSet01xwmB7nP2qJbLiTpKzAMJf8xsB/FWhhyf6ON+HPBM8PWu0sDO1Nzil3ZPYoE4EBhJJ5aTxArVgJyw4l9VJkV/jH/+YjPJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(2906002)(6506007)(6512007)(64756008)(8676002)(66476007)(66446008)(66556008)(7416002)(6486002)(4326008)(8936002)(71200400001)(26005)(36756003)(2616005)(478600001)(54906003)(66946007)(4744005)(86362001)(5660300002)(316002)(76116006)(83380400001)(91956017)(186003)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Uc++Q0zDoBBqFLkK/WIrBjb+jFlP7IHh/ZFMeGfIsegwpj1hQw/8gYS6hFc46iD9x7YqDPlnwppEm3LPAM+GzAYFf0qmQTSWJ1kqmLJ0yx8EZlyaRjWFwCO2NyCbhpOczuznUba8pY35TtZoG7a9K1Q9cvyTl85DQvmJrdyQkbfnOwOusHyoAitCX+eyac1WhLIKRgwKt/CT6xEPNQnc/QDScz7xqhbgkYLWrkcIx0s5CkQIQfarkUu9oh8ubMCO/g+iuZOeL1+niGZIoHgE6sxMroaRjEaOdO8EoOJK0F/crFFoXco89Yic/cgDva6q1bJZb4onS9G3PRpvDyY01c/kQ7n/cHak9r7Cvqz5th4F7gTuABRaPnOUix31QL3EikbLiRdXsDKMC8EC0JVoCgWdO2SWpUM52aKksT8mOTANc+JyY7XkXqZydIgFb7imwFXffQzrt7/y8q1nZm7NETLbVROH7OeIhu+n4JMQCpqBOBE9IKixO26qtkVEVQ/J4Tb8I8VaTMRt2hqUbI22UGJMd/nB1kJibNX88LfXFbJrlJUMaLsYDKH3M28wlTQJU8YbzloRQ/E5UkV+WYGh0x2C3zVy+MzJs36BMMOigHPdOu5wMowV4ePiFyWbdYXAATOj7hIHl1ikB7VHnqCuE8pHAQeLLxxd0oVGQwxhdgnPwb18iPs71h4hp9NycuUoOLClTIw9U1IxenMv37sPAfupFc0jBlgSveSQBD3132HOrZIFnJiX0L76P4UivkU1vrHfbgqLGkmQf9W+MtAXUw6EGi8JXkZPbABGge9NZ1jTLViTQYJirn5uTbYYmdR0TadKNh/1Rp9MHHZQUNdeDnxSwwSO5GD9JO5swljSwyjWlAeBRCB2N2PtT/3DlivpfcNp37f8xV2N2DMiBXWzzg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <2AE8B164648E7447927CA17247F364CF@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7614d635-248f-4799-17b3-08d88fd96a81
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 17:58:42.8436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qa2HetpZ00P+IutNvahZVG3iVBoBzCW4xalzAM/nlurAGq0rR7BbT/tS3MyRKsjrKePHL+JTz8VEiRYczmv0uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3954
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KDQpNYWtlIHN1cmUgdGhhdCBr
aWNrX2FsbF9jcHVzX3N5bmMoKSBkb2VzIG5vdCBjYWxsIENQVXMgdGhhdCBhcmUgcnVubmluZw0K
aXNvbGF0ZWQgdGFza3MuDQoNClNpZ25lZC1vZmYtYnk6IFl1cmkgTm9yb3YgPHlub3JvdkBtYXJ2
ZWxsLmNvbT4NClthYmVsaXRzQG1hcnZlbGwuY29tOiB1c2Ugc2FmZSB0YXNrX2lzb2xhdGlvbl9j
cHVtYXNrKCkgaW1wbGVtZW50YXRpb25dDQpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbGl0cyA8YWJl
bGl0c0BtYXJ2ZWxsLmNvbT4NCi0tLQ0KIGtlcm5lbC9zbXAuYyB8IDE0ICsrKysrKysrKysrKyst
DQogMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlm
ZiAtLWdpdCBhL2tlcm5lbC9zbXAuYyBiL2tlcm5lbC9zbXAuYw0KaW5kZXggNGQxNzUwMTQzM2Jl
Li5iMmZhZWNmNThlZDAgMTAwNjQ0DQotLS0gYS9rZXJuZWwvc21wLmMNCisrKyBiL2tlcm5lbC9z
bXAuYw0KQEAgLTkzMiw5ICs5MzIsMjEgQEAgc3RhdGljIHZvaWQgZG9fbm90aGluZyh2b2lkICp1
bnVzZWQpDQogICovDQogdm9pZCBraWNrX2FsbF9jcHVzX3N5bmModm9pZCkNCiB7DQorCXN0cnVj
dCBjcHVtYXNrIG1hc2s7DQorDQogCS8qIE1ha2Ugc3VyZSB0aGUgY2hhbmdlIGlzIHZpc2libGUg
YmVmb3JlIHdlIGtpY2sgdGhlIGNwdXMgKi8NCiAJc21wX21iKCk7DQotCXNtcF9jYWxsX2Z1bmN0
aW9uKGRvX25vdGhpbmcsIE5VTEwsIDEpOw0KKw0KKwlwcmVlbXB0X2Rpc2FibGUoKTsNCisjaWZk
ZWYgQ09ORklHX1RBU0tfSVNPTEFUSU9ODQorCWNwdW1hc2tfY2xlYXIoJm1hc2spOw0KKwl0YXNr
X2lzb2xhdGlvbl9jcHVtYXNrKCZtYXNrKTsNCisJY3B1bWFza19jb21wbGVtZW50KCZtYXNrLCAm
bWFzayk7DQorI2Vsc2UNCisJY3B1bWFza19zZXRhbGwoJm1hc2spOw0KKyNlbmRpZg0KKwlzbXBf
Y2FsbF9mdW5jdGlvbl9tYW55KCZtYXNrLCBkb19ub3RoaW5nLCBOVUxMLCAxKTsNCisJcHJlZW1w
dF9lbmFibGUoKTsNCiB9DQogRVhQT1JUX1NZTUJPTF9HUEwoa2lja19hbGxfY3B1c19zeW5jKTsN
CiANCi0tIA0KMi4yMC4xDQoNCg==
