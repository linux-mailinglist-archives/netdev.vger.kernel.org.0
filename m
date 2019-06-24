Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E08451F2B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 01:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfFXXil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 19:38:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22046 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728436AbfFXXil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 19:38:41 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5ONXGHX002137;
        Mon, 24 Jun 2019 16:38:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=e4udN3M58PntMZDLQo8Ejp9WuH5dSQvAjRdLso0GS48=;
 b=WhD96cNlZikFHAlqulsRcpg92gDferEb7wqnFcxEIeiD6LdhZytuX+jz8j39vxPyiHIL
 CpMBob52bZPOMNs7LHEtshk5pPxhdQdHykE80BbjhaeHilpxSv833y+imQUrqRs6oIt3
 fDWmzXQx/RfNqXhOsaoSmbiYca0dd7nIQOc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tb56ugqx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Jun 2019 16:38:14 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 16:38:13 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 16:38:12 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 16:38:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4udN3M58PntMZDLQo8Ejp9WuH5dSQvAjRdLso0GS48=;
 b=c+1hVIyXNoqHQokvc/s9esBLR9y00n1G6VVfGbwD7T4iEv3+gCmgwAR1rC+n3jmh1m+3Bb2X+YSQZvPwvuNj3ksbjkmNjwCLi3juq81kn/3zh0Bca3aVAWLExohou3pz5E6I1zKGoQc0ELL7WDSYa0aqJmi/iu/CYMKQMAD8pQ4=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2198.namprd15.prod.outlook.com (52.135.196.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 23:38:11 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 23:38:11 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrey Ignatov <rdna@fb.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Topic: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Index: AQHVKIFy6hPwND0Mwky2apMHopnX+aaq33qAgAB9YoCAAAbxAIAAB5SAgAAPW4A=
Date:   Mon, 24 Jun 2019 23:38:11 +0000
Message-ID: <97b13eb6-43fb-8ee9-117d-a68f9825b866@fb.com>
References: <20190621223311.1380295-1-ctakshak@fb.com>
 <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
 <20190624145111.49176d8e@cakuba.netronome.com>
 <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
 <20190624154309.5ef3357b@cakuba.netronome.com>
In-Reply-To: <20190624154309.5ef3357b@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0179.namprd04.prod.outlook.com
 (2603:10b6:104:4::33) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:d5ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d34dacfa-bde6-4335-d318-08d6f8fd049d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2198;
x-ms-traffictypediagnostic: BYAPR15MB2198:
x-microsoft-antispam-prvs: <BYAPR15MB21989A01B96488BF275DEFFDD7E00@BYAPR15MB2198.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(346002)(376002)(39860400002)(199004)(189003)(316002)(305945005)(6486002)(5660300002)(256004)(99286004)(64756008)(7736002)(478600001)(71200400001)(71190400001)(66446008)(8936002)(66476007)(66556008)(14454004)(46003)(6116002)(11346002)(229853002)(446003)(73956011)(66946007)(25786009)(31696002)(476003)(6636002)(486006)(6506007)(386003)(2616005)(52116002)(4326008)(6436002)(8676002)(81156014)(81166006)(36756003)(68736007)(6246003)(86362001)(54906003)(2906002)(31686004)(53546011)(186003)(53936002)(6512007)(76176011)(110136005)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2198;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F8E19gIgu1N74jSj4G8HgwJxUWFs/x1BPfbzcz88rKxtG01h40iXtohEfOko7Z1E0gK1Ynf0ueBy7BDpVDIXc/R4BfWdGO6JG6j2llNhegM3rI+3HD+l8N60eLl/uTZ4twIhWpZbqOXKQjMmzrAuIxVNNh6+sskvvU8hORju1N2mN8ZULtZNZEIxB+HfRhxBZGff6dTEc2RJ4Um0OpmUZZYW7ua15MMw4TNZcI3udBKtetgpkK7G1fTRgrKp4MWBF/CrFoIU4VJggAaqmc3k534TdYKMe4dq+KhQcSrDYyG7tADTT+dzeZHvx+7VQF6lWtKI2H+PhQkv0RF/AXm5eEX0qdlM9A7cDgtMAhSHt+fUXEVvCeOE0rsPIlf7T2kYyjbmLWRWZ7dQSjjrfvTKTW8aGaBPlaKLMmFtY8kb2IM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A79620E60B59043AC87AEAB4FB270EC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d34dacfa-bde6-4335-d318-08d6f8fd049d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 23:38:11.2007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2198
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=837 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240186
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8yNC8xOSAzOjQzIFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gTW9uLCAyNCBK
dW4gMjAxOSAyMjoxNjowMiArMDAwMCwgQW5kcmV5IElnbmF0b3Ygd3JvdGU6DQo+PiBKYWt1YiBL
aWNpbnNraSA8amFrdWIua2ljaW5za2lAbmV0cm9ub21lLmNvbT4gW01vbiwgMjAxOS0wNi0yNCAx
NDo1MSAtMDcwMF06DQo+Pj4gVGhpcyBpcyBhIGNncm91cC1zcGVjaWZpYyBmbGFnLCByaWdodD8g
IEl0IHNob3VsZCBiZSBhIHBhcmFtZXRlcg0KPj4+IHRvIGNncm91cCBzaG93LCBub3QgYSBnbG9i
YWwgZmxhZy4gIENhbiB3ZSBwbGVhc2UgZHJvcCB0aGlzIHBhdGNoDQo+Pj4gZnJvbSB0aGUgdHJl
ZT8NCj4+DQo+PiBIZXkgSmFrdWIsDQo+Pg0KPj4gSSBoYWQgc2FtZSB0aG91Z2h0IGFib3V0IGNn
cm91cC1zcGVjaWZpYyBmbGFnIHdoaWxlIHJldmlld2luZyB0aGUgcGF0Y2gsDQo+PiBidXQgdGhl
biBmb3VuZCBvdXQgdGhhdCBhbGwgZmxhZ3MgaW4gYnBmdG9vbCBhcmUgbm93IGdsb2JhbCwgbm8g
bWF0ZXIgaWYNCj4+IHRoZXkncmUgc3ViLWNvbW1hbmQtc3BlY2lmaWMgb3Igbm90Lg0KPj4NCj4+
IEZvciBleGFtcGxlLCAtLW1hcGNvbXBhdCBpcyB1c2VkIG9ubHkgaW4gcHJvZy1zdWJjb21tYW5k
LCBidXQgdGhlIG9wdGlvbg0KPj4gaXMgZ2xvYmFsOyAtLWJwZmZzIGlzIHVzZWQgaW4gcHJvZy0g
YW5kIG1hcC1zdWJjb21tYW5kcywgYnV0IHRoZSBvcHRpb24NCj4+IGlzIGdsb2JhbCBhcyB3ZWxs
LCBldGMgKHRoZXJlIGFyZSBtb3JlIGV4YW1wbGVzKS4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgdGhl
c2UgYXJlIGVxdWl2YWxlbnQuICBCUEZfRl9RVUVSWV9FRkZFQ1RJVkUgaXMgYSBmbGFnDQo+IGZv
ciBhIHN5c2NhbGwgY29ycmVzcG9uZGluZyB0byBhIHN1YmNvbW1hbmQgcXVpdGUgY2xlYXJseS4N
Cj4gDQo+PiBJIGFncmVlIHRoYXQgbGltaXRpbmcgdGhlIHNjb3BlIG9mIGFuIG9wdGlvbiBpcyBh
IGdvb2QgaWRlYSBpbiB0aGUgbG9uZw0KPj4gdGVybSBhbmQgaXQnZCBiZSBncmVhdCB0byByZXdv
cmsgYWxsIGV4aXN0aW5nIG9wdGlvbnMgdG8gYmUgYXZhaWxhYmxlDQo+PiBvbmx5IGZvciBjb3Jy
ZXNwb25kaW5nIHN1Yi1jb21tYW5kcywgYnV0IEkgZG9uJ3Qgc2VlIGhvdyB0aGUgbmV3IGAtZWAN
Cj4+IG9wdGlvbnMgaXMgZGlmZmVyZW50IGZyb20gZXhpc3Rpbmcgb3B0aW9ucyBhbmQgd2h5IGl0
IHNob3VsZCBiZSBkcm9wcGVkLg0KPiANCj4gQWdyZWVkLCBUQkgsIGJ1dCB3ZSBjYW4ndCBjaGFu
Z2UgZXhpc3Rpbmcgb3B0aW9ucywgcGVvcGxlIG1heSBiZSB1c2luZw0KPiB0aGVtLiAgTGV0J3Mg
ZHJvcCB0aGUgcGF0Y2ggYW5kIG1ha2Ugc3VyZSB3ZSdyZSBub3QgbWFraW5nIHRoaXMgbWlzdGFr
ZQ0KPiBhZ2FpbiA6KQ0KDQpJIGRvbid0IHRoaW5rIHRoaXMgcGF0Y2ggc2hvdWxkIGJlIHBlbmFs
aXplZC4NCkknZCByYXRoZXIgc2VlIHdlIGZpeCB0aGVtIGFsbC4NCg==
