Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47350CCE2A
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 06:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfJFEV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 00:21:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34140 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbfJFEV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 00:21:26 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x964J9bx005680;
        Sat, 5 Oct 2019 21:21:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/0SK05Az4fRzSCNvY17cXD/MOBpLKbRLTNn8WWwcBw0=;
 b=GAYpF6oNSDVUqsn4tWjBKjJ14XnUCzee2Wt1rxoPSBEog/Nau9aUWwfU+exFlXn9H6fh
 LGTym0zEaQto4MJ4NQ1113uM52dcB1B84+zYronMCPQJe+5IxD42CyYFphlDL8mBpcll
 Ls/WjgcHMcF4o/6QrUbcSdYu7hIYHq6May0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ves0gjw3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 05 Oct 2019 21:21:13 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 5 Oct 2019 21:21:10 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 5 Oct 2019 21:21:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuhCguImbiw+Okt3V6gKhZQkeKqtuctXggqj8J39T1gGzdQ3Wioh9F+G0Q01uUjc8qvwsZiym1yWtjXqd6OaqE3QMg1DJYPsLLbx38BGsxyzZHjOr727rondgGGyt5/sSlvX75r/f6G1ommG+8X59ldmyxKcuLcSYoTDECu4+Vl1RiWzugtuH6AP4k0uu41S+N37ODi2cFRVTZA+m310iPQ4xTvjJM3Jbs2OWjJgcldkwAeTlljt6D+pe8TciTh23f6xnQzMpCpPwUJWr2zG41hBfDq65asMt+CETFvWBm6cZWNl5NF5XHaGL1egVtwKmawEQRAfn7kZ8m96Z84cOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0SK05Az4fRzSCNvY17cXD/MOBpLKbRLTNn8WWwcBw0=;
 b=cYN56mRy/7c8u289ufBnc3n4sU2eUYizJFlpgUHNAM6NC/lmWQj7wjgWrw/iQysVADxUyRacXkV8HLd68h6IeEX24th6zYlzN3DMnObipa7p5SA3JkAv7mHTwA2OTmT0g8ZOwAWHffHGRvJ6/s3ixn8b9L0bII5POnuQj6NmWM/TYSyQr+I8Vqx2Gq8C4fmBa/zYvbguI7XhmwZMh/eIg67fqoo7zo9o+mGuVMThnq1WinhnHgtAdmS9Cl7ZF3xFDZ8imvBHhUVEstmdIrtE2+q+j7Ekv+ABrcDLgfSnzcSEf2aqIx/1YsxMiTgikM3JTCTOyrr6fJMkO0O6mqEQsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0SK05Az4fRzSCNvY17cXD/MOBpLKbRLTNn8WWwcBw0=;
 b=fJbH+crp1UdekMRreuQmp6thCbPlDlUiw/VEV0eYgoBvA8pRmGpF+pyGKnIEzcMtHnRcpm5axZTYlAkQhl1M7Vs0jzKD7r3zjC1/tJNx0aZUMzOijMJ5p1w3jcq9dVzo5HIQuegzR6JGwwK4PBGyZPn/hRLzeU6a22PyySH0iZg=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2565.namprd15.prod.outlook.com (20.179.155.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Sun, 6 Oct 2019 04:21:09 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.023; Sun, 6 Oct 2019
 04:21:09 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/3] scripts/bpf: teach bpf_helpers_doc.py to
 dump BPF helper definitions
Thread-Topic: [PATCH v2 bpf-next 2/3] scripts/bpf: teach bpf_helpers_doc.py to
 dump BPF helper definitions
Thread-Index: AQHVe/T9ywV1VaO68Uy0r1P7oxB/kKdNAwIA
Date:   Sun, 6 Oct 2019 04:21:09 +0000
Message-ID: <c2302e65-90e4-adc1-7e6d-7dc324a133c9@fb.com>
References: <20191006032008.2571427-1-andriin@fb.com>
 <20191006032008.2571427-3-andriin@fb.com>
In-Reply-To: <20191006032008.2571427-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0004.namprd17.prod.outlook.com
 (2603:10b6:301:14::14) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::3132]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b94b693a-e01d-40fe-d404-08d74a149d1d
x-ms-traffictypediagnostic: BYAPR15MB2565:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB25651FF0826F7FB00A9141D3D7980@BYAPR15MB2565.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-forefront-prvs: 0182DBBB05
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(39850400004)(136003)(366004)(376002)(199004)(189003)(6506007)(102836004)(386003)(229853002)(2906002)(76176011)(6116002)(53546011)(110136005)(186003)(81156014)(81166006)(6486002)(99286004)(31686004)(8676002)(52116002)(36756003)(446003)(11346002)(46003)(6436002)(486006)(476003)(2616005)(6512007)(8936002)(478600001)(5660300002)(71200400001)(71190400001)(54906003)(14444005)(6246003)(305945005)(14454004)(31696002)(2501003)(4326008)(25786009)(7736002)(316002)(2201001)(66476007)(66946007)(256004)(66556008)(4744005)(66446008)(86362001)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2565;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NiYhLlvUQGqI9Oad5mqn/PbSh2yu0K7pcWjdue6NTyljjYeUui4oKRp4VgRN3oAjAJMmPKhG+gZYzess8T8pnrVokeDFvFfqQ8VrONcneCG5veUL9B+iyb3xysJZv1rlCDPOdkeYTfwDgGKYPwPxfaM7m92CCUpCoL35WbRD8xeahzVYmGgo05V3+ZbOp5+EpjL5OCzD8/gk4yB3hTKR1Ue64uM/T5k8RqWjtco12m4YzFh1xAfK2Xbr/pSnnmsiV14UmE7zuz4foKygwX98wgeLrEs0krBgD+LnOQDz69hgS85iw/AvaHpWIi6+Z73EBySJOrK7hgga/1V7qdxxnrjy38iS01eLSZJMBEY17LS/E0yvdI/50A58tESRP1NGSidbZcE18TrT5vKXytfnBH5VbAwEvWI9R47UVdJ1zxk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C0C365D1003E947BE62C88B491A0A5A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b94b693a-e01d-40fe-d404-08d74a149d1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2019 04:21:09.4262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jDXbZeg8bOZLOKbgs9IBL3NaIdnyuCKhMNry5mXK38LNbD/SMnnG9+HyeaOT7QWk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2565
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-06_01:2019-10-03,2019-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0
 mlxlogscore=695 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910060042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvNS8xOSA4OjIwIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IEVuaGFuY2Ugc2Ny
aXB0cy9icGZfaGVscGVyc19kb2MucHkgdG8gZW1pdCBDIGhlYWRlciB3aXRoIEJQRiBoZWxwZXIN
Cj4gZGVmaW5pdGlvbnMgKHRvIGJlIGluY2x1ZGVkIGZyb20gbGliYnBmJ3MgYnBmX2hlbHBlcnMu
aCkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa288YW5kcmlpbkBmYi5jb20+
DQo+IC0tLQ0KPiAgIHNjcmlwdHMvYnBmX2hlbHBlcnNfZG9jLnB5ICAgICAgfCAgMTU1ICstDQo+
ICAgdG9vbHMvbGliL2JwZi9icGZfaGVscGVyX2RlZnMuaCB8IDI2NzcgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgMjgzMSBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL2xpYi9icGYvYnBm
X2hlbHBlcl9kZWZzLmgNCg0KcGF0Y2ggMiBhZGRzIGl0LiBwYXRjaCAzIGRlbGV0ZXMgaXQ/IHN0
cmVzcyB0ZXN0aW5nIGdpdD8gOykNCg==
