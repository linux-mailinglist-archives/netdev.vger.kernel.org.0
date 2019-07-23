Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18CD722BA
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 01:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392538AbfGWXAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 19:00:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6918 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728418AbfGWXAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 19:00:50 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6NMuwDe001927;
        Tue, 23 Jul 2019 16:00:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jbucP9JwNJJ0gB3wFfWuRzH8Xd5FNvd3jQEaGRRB1zU=;
 b=TT2UnE97c9XxVgeN+fjLN5uTXLyj4qXKxhaaQVDDjJ2eaeeGuxa/TahzfO3uPB9PxJXf
 TEycnh6npjsCPjG/tZoAwSyFHhUxQuhk0vU4Zb0ah2N15TOxR1fAjcf1HUvXDcN+jBDu
 ehHMM9AFrcLY3bV/8lkMFB4bPIU4aHIct54= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tx613hcgy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jul 2019 16:00:30 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jul 2019 16:00:30 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 16:00:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzHdsuGLv+A3alys/R0Auhm414MJ8YJ1kDpD439beG3wZWjdE4/b3pM7dwKZRQP6fWcFX6sRNsec7Y5EtcYNav2NyHdHzlKEd2Sx9PK2fuiw0cRzszlhWDl4xqXqA+G2QoNXbvVQW3Y0i82zbAzt5plIHFBCQ3Jf7F5vCwFvGvnv5T0HubkPfRFKKh1+yvzkTUJk1JA1ym0YznM0JgEmhe1vhvwQZ/ZqEshWW6Y+3R8S+fhR2li+98wbJRlE0NelEnfRSyOTXcDOVwvnyHbSVEamV5qw3pYmz8xarcIANSvSqz0R3rM2Skcev6UtIta52R5KhOFb5jbltR7zHXOfSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbucP9JwNJJ0gB3wFfWuRzH8Xd5FNvd3jQEaGRRB1zU=;
 b=IYt2g5THwxYi95UHW3naksWBkxaV/PiuORBi7FD755Eb/b/oZImew2goDwuMUts00OH+PTda9vq38gbrtAVBUewpQVGyS47j82fX6TiQs7MMcj2pvjoSQqbP/UwkxlLuAlHWC/k+9WyJSvzWVC9MQNNXYp780/XBQlCu6+hMEfQiy4+Txbl7HizeRbQj8LSygADjWWRgGUPlOJwvMDhEZ31VYAnSbDnfKoev1rywrjqvPU1R6QNHIeGI1XJ7sHumOR8zoblr15GQ4hYGmcc+RMY91o35wLB8hdoj/tevKLyntjCgCEZvvQeqhwER2JX2xPCam8WlIZ2QBEIaLORamg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbucP9JwNJJ0gB3wFfWuRzH8Xd5FNvd3jQEaGRRB1zU=;
 b=bRtFscHHXqjgOfSMQo5MUg7Pj/8MRL0fsMXvKAODEh+H7ZO1Ejlg+aycbpFWlsQF87PoL30EDGXyphty7/l0IRcjd80MW3eOTPf7k8iPzqzQaS/mS1qwTb1Gmg0F58r6mJPIOlVcaa7OJ2+2BM9ktrvZCnnnRUPQFhVVbdJOXiE=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2550.namprd15.prod.outlook.com (20.179.155.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 23:00:29 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::b964:e4e:5b14:fa7]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::b964:e4e:5b14:fa7%6]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 23:00:29 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Song Liu <songliubraving@fb.com>, Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: provide more helpful message on
 uninitialized global var
Thread-Topic: [PATCH v2 bpf-next] libbpf: provide more helpful message on
 uninitialized global var
Thread-Index: AQHVQZtC9YSAmDIItkuvtd1TWhTZi6bYwbuAgAAP4YA=
Date:   Tue, 23 Jul 2019 23:00:28 +0000
Message-ID: <44ae07d3-7f53-8062-69e1-9fdf9b3ecc9e@fb.com>
References: <20190723211133.1666218-1-andriin@fb.com>
 <08DD65ED-34B4-47C0-B5ED-9A354CF5BA35@fb.com>
In-Reply-To: <08DD65ED-34B4-47C0-B5ED-9A354CF5BA35@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0025.namprd12.prod.outlook.com
 (2603:10b6:301:2::11) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:46e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef16a9dd-d29b-45e4-80f6-08d70fc18e3c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2550;
x-ms-traffictypediagnostic: BYAPR15MB2550:
x-microsoft-antispam-prvs: <BYAPR15MB25504C24B485F852D3A2A4FDD7C70@BYAPR15MB2550.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:126;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(366004)(376002)(396003)(39860400002)(189003)(199004)(66556008)(66476007)(66946007)(5660300002)(81166006)(25786009)(81156014)(64756008)(4744005)(14454004)(66446008)(4326008)(256004)(15650500001)(86362001)(31696002)(99286004)(110136005)(6486002)(229853002)(54906003)(316002)(2906002)(8936002)(71200400001)(186003)(36756003)(6506007)(6116002)(53936002)(53546011)(76176011)(478600001)(52116002)(71190400001)(386003)(6246003)(102836004)(11346002)(446003)(305945005)(46003)(476003)(2616005)(68736007)(486006)(7736002)(31686004)(6436002)(8676002)(6636002)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2550;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SXLe+7Gg8RnNR1vr461Z22CKqSdJ2DmKiNe+HA7swEbEKcfSFIlGFiN6veXwVSQ9GkEBIYfj9n2fNzzDKv7GRkVKa3UlThQlrK0VUX9bKlEDTGaJaI3wjva2yQMLl4pIDnPHpfS4qR0kd0NKZBqb4QJKC2myOR9hADCi8IquurTzaS2mloCg2AHzFzAs8a3UKi5/2SylQi5OCZMKteJzl8wfzjbS157eQ37cqGd6U6OaJX5qYvvfZCA9SUmzG4v6A8914/S3MfvCCrmydPLYHEikL6ayj2EckgIO1Pshw2NWuy9WQ0Xq4w96ShJ4jBTebqIbY2uNE032PC8kqotv2adPppubsE/p/mIIzNtvEEjn0Tr5WHtq6VcNkqCyRqLRLERFpX0s8AUmFoyEXE4nLpdYeiXXcgeY0gaAdYLxgXk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F5488A90117B64EA41281875F4CAA9A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ef16a9dd-d29b-45e4-80f6-08d70fc18e3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 23:00:28.8547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2550
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=635 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907230235
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8yMy8xOSAzOjAzIFBNLCBTb25nIExpdSB3cm90ZToNCj4+IE9uIEp1bCAyMywgMjAxOSwg
YXQgMjoxMSBQTSwgQW5kcmlpIE5ha3J5aWtvPGFuZHJpaW5AZmIuY29tPiAgd3JvdGU6DQo+Pg0K
Pj4gV2hlbiBCUEYgcHJvZ3JhbSBkZWZpbmVzIHVuaW5pdGlhbGl6ZWQgZ2xvYmFsIHZhcmlhYmxl
LCBpdCdzIHB1dCBpbnRvDQo+PiBhIHNwZWNpYWwgQ09NTU9OIHNlY3Rpb24uIExpYmJwZiB3aWxs
IHJlamVjdCBzdWNoIHByb2dyYW1zLCBidXQgd2lsbA0KPj4gcHJvdmlkZSB2ZXJ5IHVuaGVscGZ1
bCBtZXNzYWdlIHdpdGggZ2FyYmFnZS1sb29raW5nIHNlY3Rpb24gaW5kZXguDQo+Pg0KPj4gVGhp
cyBwYXRjaCBkZXRlY3RzIHNwZWNpYWwgc2VjdGlvbiBjYXNlcyBhbmQgZ2l2ZXMgbW9yZSBleHBs
aWNpdCBlcnJvcg0KPj4gbWVzc2FnZS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFr
cnlpa288YW5kcmlpbkBmYi5jb20+DQo+IEFja2VkLWJ5OiBTb25nIExpdTxzb25nbGl1YnJhdmlu
Z0BmYi5jb20+DQo+IA0KDQpBcHBsaWVkLiBUaGFua3MNCg==
