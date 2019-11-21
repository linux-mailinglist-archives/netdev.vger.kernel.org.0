Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF131049B1
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 05:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfKUEkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 23:40:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7194 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725842AbfKUEkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 23:40:05 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAL4bcJT012095;
        Wed, 20 Nov 2019 20:39:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qjs4VYgMTzMQZNlBPF6RXc7vhklcpZBPPGNwDuP8/bs=;
 b=lyzqfdbrucY3LNNQC0idfAqzyCo9xi1J/T0Zd7kfOooGRpTT5zu8TqEA3qK+oK6LjFIX
 2V9tpczQbAjUo6itadA2ML4+hez7ip/loxQQnICBhBw/faDJgkjGtbtzGtYaGvpYYYgs
 8GpVZQ+l+vmsxlzyTebsOXlDHot5LjguDTo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2wchf7agxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 20 Nov 2019 20:39:52 -0800
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 Nov 2019 20:39:51 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 20 Nov 2019 20:39:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7ZY2w+GO7rQK3ObG01p0zrxSjRFWt/dul/KVe4mYYgqJURxL8Kczdt6DQM/c1TxCICJKTYob9YbJhGBE4y3jYVokLSm/ml2GsGphwNHKkOzmBTQVuj6yKBMj+ZEFU8enURatGN61tMXmtzKNs8JpSrO9IlodbFQevBQnQGGWdQtgEGsylhNxMYtIts45whb9rDS/ApG3dZ/8Htf3nTfUq6sQf3NJZhCStL4EIsofMggLq7v38ehXEuN7asMZ8eatTC4LIEi7D0qCkbV2o2PUxBp9d+o5SmZU5fsQj9FMlTeM3FKWKH0BvfifeRczLZU8An4b5n/NyYKH0MhT/qVlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjs4VYgMTzMQZNlBPF6RXc7vhklcpZBPPGNwDuP8/bs=;
 b=LXeeZhmXKwAsiewVEMlpjmbs7zRyp9gpt4avZwDSTOWukPQhCgwnwlhWERKEUh3/N6kG+7uD12AaORHklyvDlrBwsfQ+v0YCo/cPSbcu1Ti92akKwIrwyN1uwgVGfu3VyQIvXeSk969d15o7851ZF0KA5tAQ4oGVGeWxaxByvOHDXmFVgHUQaFyYx0nK8TM30i6170Kr58MBwAt5lyNPbPdh0+sspeQk/4e5F4beDPbL37QGyTY3tcnNje73C2MDnvcncKPanUYJJ5Rqw/V1uH6Y18b13F63b9FnJr4umaul7t6TfHvQIherfNN0djTqc5hPJf9n9ua9o9e187M0lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjs4VYgMTzMQZNlBPF6RXc7vhklcpZBPPGNwDuP8/bs=;
 b=QG4aW8WbimUmKayYpWGn8NCIyZJ4QTfr0dVBR3s9AT4xiCEd6qevAxEpCxJX4cS1kYIxAuPtsqlMZF+c8gcFEIwVkJXhDYP/03spfm/+fzmw5V3BRfEmMsDF9KWrhcSuMGMzHfqu0HE+txjcnA7dmluLHdQ4iiCg1mvPii6jRdQ=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2727.namprd15.prod.outlook.com (20.179.158.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Thu, 21 Nov 2019 04:39:48 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2451.029; Thu, 21 Nov 2019
 04:39:48 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern
 variables
Thread-Topic: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern
 variables
Thread-Index: AQHVnRXP1WCUmtit50O/zE+NHNTys6eR1rKAgAA8PYCAAJK8AIAABJUAgADFMgCAASxFAIAAEzkAgAAZN4CAACBWgIAAKLsA
Date:   Thu, 21 Nov 2019 04:39:47 +0000
Message-ID: <6c317a63-3204-d4e3-6a7c-66aa79723019@fb.com>
References: <20191117070807.251360-1-andriin@fb.com>
 <20191117070807.251360-6-andriin@fb.com>
 <20191119032127.hixvyhvjjhx6mmzk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaNEU_vpa98QF1Ko_AFVX=3ncykEtWy0kiTNW9agsO+xg@mail.gmail.com>
 <CAEf4Bza1T6h+MWadVjuCrPCY7pkyK9kw-fPdaRx2v3yzSsmcbg@mail.gmail.com>
 <7012feeb-c1e8-1228-c8ce-464ea252799c@fb.com>
 <CAEf4BzaW4-XTxZTt2ZLvzuc2UsmmPa3Bkoej7B0pUJWcM--eVQ@mail.gmail.com>
 <11d4fde2-6cf5-72eb-9c04-b424f7314672@fb.com>
 <CAEf4BzakAJ5dEF35+g7RBgieXfVzjKQHm_Dej-9f_K_qXNuG2Q@mail.gmail.com>
 <20191121001811.eyksi2acyhvy4skr@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaT=UhR0yDOTa_Q8KcZ0G0i9fYWTfdoW8qZCkcTNjxDRg@mail.gmail.com>
In-Reply-To: <CAEf4BzaT=UhR0yDOTa_Q8KcZ0G0i9fYWTfdoW8qZCkcTNjxDRg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR18CA0030.namprd18.prod.outlook.com
 (2603:10b6:320:31::16) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9b19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fd3f0ee-110f-4843-8b2f-08d76e3cd6cc
x-ms-traffictypediagnostic: BYAPR15MB2727:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB27272AE459F58A939A45F935D74E0@BYAPR15MB2727.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(396003)(346002)(376002)(366004)(199004)(189003)(7736002)(6512007)(8936002)(52116002)(76176011)(66446008)(478600001)(305945005)(66556008)(6436002)(256004)(46003)(31686004)(11346002)(2906002)(14454004)(81166006)(2616005)(558084003)(8676002)(64756008)(229853002)(486006)(86362001)(476003)(31696002)(66946007)(81156014)(446003)(6486002)(102836004)(386003)(6506007)(6116002)(53546011)(99286004)(110136005)(54906003)(186003)(25786009)(66476007)(6246003)(4326008)(71190400001)(36756003)(5660300002)(316002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2727;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PjXYCTnNBfNfcmXT/flbAUZOwQzCGOnLx7JFCxo+e7MSbvliPxrRdA/NTyPHn0Py5lIzuKohXlxBNFoeN0y3EvCT3PsEClNHKevD1uqXGMT+mduVeEKB3Vta/V/sKifFhd2KtYeviZuvHwV4Rgn4oUlUI35ey1/tVqUgr8zEot8tWzGRTMl+ft6NTOFiLu4EfqmorVcXdDBS5dLkX4vfRWnGhMRreTbuE9PsGYmGR5/d2ljw7UCRApDy9jKgQAZLMFI36ElRGgiBgJZhPKuB3rkqMRulqz5nBYiii1EKQ4kVWetWx0sS4NDhIZ0mYnLXnxZRQz9A4xELxn89zp2nGzD9KyO8Sej8m9mt9L72Py8q3pGlCZd1d+8nTzMJ8Kp+rFnuBVe9xyqMuZ3c38P7YQsa90Ujn7/U6TvKVJGIB2eCYHhvBYY8UgkMJlE5zyTt
Content-Type: text/plain; charset="utf-8"
Content-ID: <321991CEB3876644A20BA8AB7092FDF1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd3f0ee-110f-4843-8b2f-08d76e3cd6cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 04:39:47.9565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UlHGqYrKG24c0l9IAWWkCReuCs3OwOqd0JafvJIGzypbxnWbzX4Ti9BjCLCOw9us
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_08:2019-11-20,2019-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1015 mlxlogscore=807 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMjAvMTkgNjoxMyBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBXZSBzaG91bGQg
anVzdCBzYXkgbm8gdW50aWwgd2UgaGF2ZSB0eXBlcy4NCg0KT2suIEknbSBjb252aW5jZWQuIE5v
bmUgb2YgdGhlIHByb3Bvc2FscyBhcmUgY2xlYW4gZW5vdWdoDQp1bnRpbCB3ZSBoYXZlIEJURiB3
aXRoIGV4dGVybnMuDQo=
