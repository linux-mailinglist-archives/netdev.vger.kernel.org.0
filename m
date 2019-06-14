Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A894549D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 08:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbfFNGVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 02:21:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44168 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbfFNGVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 02:21:08 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5E6J5pX014884;
        Thu, 13 Jun 2019 23:20:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SdRm9LJtlDPfQjDxJsYOagSAQLkvcNxAMUBn8cTk8vM=;
 b=gYH/XIFhAXBkOc2kNZtAH22qfFJUtxa5tmltxX93nlIieesXYqwo/mAAGKNeS9xXTKVV
 KDvnd05xGW6h2RwBRr3Tdo6G6iQAIC05UpzE1MnD6mdmsCnEU8b1+kgiwNLOxqg5SI0z
 bLYegPfuRmWgVuJQK1zHrcMMMlA69sB7cDk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3py22ygg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 23:20:44 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 13 Jun 2019 23:20:42 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 13 Jun 2019 23:20:42 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 13 Jun 2019 23:20:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdRm9LJtlDPfQjDxJsYOagSAQLkvcNxAMUBn8cTk8vM=;
 b=RbMWI/TOdAX5NstdWr+1Lp5VZ2utEgxqE13JQA4AyTXxYRmM+5sjRGi+DZaDG04S9aMbwjNQfbdNdHkIqfhyNEoh33Ad858BazPMxiLfYPpD2aR2ZzODOL80z34bWcxZWEJUx7N74stf9outn4yCS9mTohYKPaxWfdXhYDbH6+c=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2535.namprd15.prod.outlook.com (20.179.154.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Fri, 14 Jun 2019 06:20:24 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 06:20:24 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Edward Cree <ecree@solarflare.com>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, Jann Horn <jannh@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 8/9] selftests/bpf: add realistic loop tests
Thread-Topic: [PATCH bpf-next 8/9] selftests/bpf: add realistic loop tests
Thread-Index: AQHVIZ9dVDgRE0+DOUWNL0P6I611xKaaPaaAgABxlgA=
Date:   Fri, 14 Jun 2019 06:20:23 +0000
Message-ID: <6f86e9ab-76e4-52f3-11a9-0e7d2ffb305d@fb.com>
References: <20190613042003.3791852-1-ast@kernel.org>
 <20190613042003.3791852-9-ast@kernel.org>
 <CAEf4BzYZ2ke46j4Rg_e=PsFB3e36PguCk2+-oRR0FQk4n-tnag@mail.gmail.com>
In-Reply-To: <CAEf4BzYZ2ke46j4Rg_e=PsFB3e36PguCk2+-oRR0FQk4n-tnag@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0070.namprd04.prod.outlook.com
 (2603:10b6:300:6c::32) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:f6f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dadc86ed-d7b7-4850-b54d-08d6f0906247
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2535;
x-ms-traffictypediagnostic: BYAPR15MB2535:
x-microsoft-antispam-prvs: <BYAPR15MB25359354DABEF00643DE676DD7EE0@BYAPR15MB2535.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(366004)(39860400002)(346002)(199004)(189003)(102836004)(186003)(76176011)(6486002)(52116002)(14454004)(110136005)(66946007)(64756008)(99286004)(86362001)(66556008)(66446008)(71190400001)(71200400001)(66476007)(256004)(73956011)(316002)(68736007)(31696002)(2906002)(6506007)(386003)(54906003)(53546011)(36756003)(4326008)(25786009)(81166006)(8936002)(6116002)(305945005)(5660300002)(6246003)(4744005)(53936002)(81156014)(6512007)(478600001)(6436002)(229853002)(31686004)(46003)(8676002)(7416002)(7736002)(446003)(476003)(2616005)(486006)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2535;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SaQld7W+thYcZD28P5feHq1hT4S+Qh/lqzS3k34oXKgooqddkZn41BkWODp+NY3JVUzPpsekJ4hhfghei7fMlDxr7sR9KhtkcpzFtGhtXHMZYT2kA3aFosNAFwR+BA7Z+YepcwExAA/xpUzEE77ED1TbeKysYOb/hh9HSwpe2+sHpqtsYLjbM76Ua+k51PWuk9m6kBfUdlbhdQY3FguXnfY2XL80xj7ANl3HWReEb9EqjaB8vDCWKg2XQtufJ6rUiW9uAJgPmEEnqHTKr3a/DhDsgFVeOmWZu6kQjbq85zQgDRQZdyj8uE5grskwnsJ+UMU4vaYw+OgPKs5tAQqn55A4+UcbZqT/QC0zJWzqQTIol75ND1lMhoB/I9WinDuizcLMrlEJVveJoRDZmbJaC3jlhiV26T4azPGOS39nzNU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15ED2F116FB6854EBE1357D63FE4E08F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dadc86ed-d7b7-4850-b54d-08d6f0906247
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 06:20:23.8994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2535
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=793 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140052
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8xMy8xOSA0OjMzIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+PiArKysgYi90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3Mvc3Ryb2JlbWV0YS5oDQo+PiBAQCAtMCwwICsx
LDUyOCBAQA0KPj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+IExldCdz
IG1ha2UgdGhpcyAoTEdQTC0yLjEgT1IgQlNELTItQ2xhdXNlKSA/DQo+IA0KDQpub3BlLiBpdCdz
IGdwbC0yLg0KDQpDb3VsZCB5b3UgcGxlYXNlIHRyaW0geW91ciByZXBsaWVzPw0KSSBhY2NpZGVu
dGFsbHkgbm90aWNlZCB0aGF0IHlvdXIgcmV2aWV3IGhhcyB0aGUgcXVlc3Rpb24gYWJvdmUNCmJl
eW9uZCBhY2sgaW4gdGhlIGJlZ2lubmluZyBvZiB0aGUgZW1haWwuDQo=
