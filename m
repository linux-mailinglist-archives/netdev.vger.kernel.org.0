Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F168F25B58
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 02:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfEVAuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 20:50:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53826 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbfEVAuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 20:50:23 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4M0n0bs024267;
        Tue, 21 May 2019 17:50:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pzNfV9aGVcxeRIZr3ypUnLlbrUH7xBURR/WCXBmVdIg=;
 b=k8PRvZT7SgW5swdyHpKJyEwFo2KVlMndENriJ/t2gupOKLrGiiGIwms9kcb+xSlNBkoH
 XjS618DgWVp7GDz2A5LcDR2Z5DL/1sFFwi59SDivT78tv8rDcq81oeLxHjIkUx+YaRYx
 VbzceRKWrXjcOp8VWphFJeErFXLAFoCMzio= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2smmucsm55-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 May 2019 17:50:00 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 May 2019 17:49:58 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 21 May 2019 17:49:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzNfV9aGVcxeRIZr3ypUnLlbrUH7xBURR/WCXBmVdIg=;
 b=ET46qRdB2mIgxVGvPLXmH7417VrqcWCmR8+IqEnvBa8mxMlrG/qFH+l6NLyp6A2mlWV3zylXZ/SDvc1/mSfNzcq9EjVmVjGQ4KfjEkoxMmexpWlaQp9Kjc68NUb4a+t0Y21h8JuxOElZ9ORGeSWD5aq86bCZgIUBNCt30RCfByM=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3141.namprd15.prod.outlook.com (20.178.239.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Wed, 22 May 2019 00:49:56 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::140e:9c62:f2d3:7f27]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::140e:9c62:f2d3:7f27%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 00:49:56 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add pyperf scale test
Thread-Topic: [PATCH bpf-next 3/3] selftests/bpf: add pyperf scale test
Thread-Index: AQHVECpeKJ9C/OkyjUO0/LnyTgDQ76Z2TI+AgAADpgA=
Date:   Wed, 22 May 2019 00:49:56 +0000
Message-ID: <2a067f93-c607-34fc-1c34-611ed4a8f6a0@fb.com>
References: <20190521230939.2149151-1-ast@kernel.org>
 <20190521230939.2149151-4-ast@kernel.org>
 <CAEf4BzZrK1Fw211ef9psBxOoP_vV9tH2Hre1DJSqUsp7iX7bSg@mail.gmail.com>
In-Reply-To: <CAEf4BzZrK1Fw211ef9psBxOoP_vV9tH2Hre1DJSqUsp7iX7bSg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0075.namprd15.prod.outlook.com
 (2603:10b6:101:20::19) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:1eff]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b097666-386e-4436-73c3-08d6de4f68c3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3141;
x-ms-traffictypediagnostic: BYAPR15MB3141:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR15MB3141F1C4EF92D81F040D26D4D7000@BYAPR15MB3141.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(39860400002)(366004)(396003)(199004)(189003)(86362001)(71200400001)(71190400001)(25786009)(6246003)(36756003)(6116002)(4326008)(6436002)(31696002)(229853002)(6486002)(2906002)(5660300002)(14454004)(14444005)(256004)(53936002)(316002)(7736002)(31686004)(305945005)(486006)(102836004)(386003)(6506007)(53546011)(99286004)(54906003)(2616005)(476003)(186003)(76176011)(52116002)(966005)(478600001)(110136005)(81156014)(81166006)(8676002)(6512007)(66446008)(64756008)(66556008)(66476007)(6306002)(66946007)(73956011)(46003)(446003)(11346002)(8936002)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3141;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6iNfanklkuZAQ2z0zoStvDo5u2O4MW0fK15MN9cich5beb7JNqBOTbWwNNCnoL+ZsB1q4VyRJwPcFxWizoTVV0da5tARmtPXmWwyhj05uC/HkaEBduWrmBg46zUI+TF8RnBGsv9foyYt20vJnqkK5lZalLLAfj7fYWTJP3INzuncw9z/OKcNMIczuQlXBtufshlgoFldMk7viz4M8GdVZzj5+ipxkzrqHkYRVD8HtuEM5zxP34bhnNS3kyUM96J4gVMuPN4HI4DMvYzl+mq0dXCPAYA5OZ8HobE2Ej8W3nNqzqO81Q6msAEKmXtEkTb+6/mpfzmk6k3QhQifWsTcXu01yKhI8rWn5HmEcCInINV7zEfEtxcku1v0kTQFU9SQPUDY+zynQPHFrrbRP0HEVW9+BH2g96y73tlTJDbutyU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <32B8D5D129B43B44A45D123C187F3CB5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b097666-386e-4436-73c3-08d6de4f68c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 00:49:56.4064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3141
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS8yMS8xOSA1OjM2IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+PiAtLS0gL2Rldi9u
dWxsDQo+PiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvcHlwZXJmLmgN
Cj4+IEBAIC0wLDAgKzEsMjY4IEBADQo+PiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQ
TC0yLjANCj4+ICsvLyBDb3B5cmlnaHQgKGMpIDIwMTkgRmFjZWJvb2sNCj4gDQo+IE1heWJlIGxl
dCdzIGluY2x1ZGUgYSBsaW5rIHRvIGFuIHVwLXRvLWRhdGUgcmVhbCB0b29sLCB0aGF0IHdhcyB1
c2VkDQo+IHRvIGNyZWF0ZSB0aGlzIHNjYWxlIHRlc3QgaW4gQkNDOg0KPiBodHRwczovL2dpdGh1
Yi5jb20vaW92aXNvci9iY2MvYmxvYi9tYXN0ZXIvZXhhbXBsZXMvY3BwL3B5cGVyZi9QeVBlcmZC
UEZQcm9ncmFtLmNjDQoNCkkgdGhvdWdodCBhYm91dCBpdCwgYnV0IGRlY2lkZWQgbm90IHRvLA0K
c2luY2UgdGhpcyBoYWNrIGlzIG5vdCBleGFjdGx5IHRoZSBzYW1lLg0KSSB0cmllZCB0byBrZWVw
IGFuIGlkZWEgb2YgdGhlIGxvb3AgdGhvdWdoDQp3aXRoIHJvdWdobHkgdGhlIHNhbWUgbnVtYmVy
IG9mIHByb2JlX3JlYWRzDQphbmQgJ2lmJyBjb25kaXRpb25zLCBidXQgd2FzIGNob3BwaW5nIGFs
bCBiY2MtaXNtIG91dCBvZiBpdC4NCkluIHRoZSBjb21taXQgbG9nOiAiQWRkIGEgc25pcHBldCBv
ZiBweXBlcmYgYnBmIHByb2dyYW0iDQpCeSAiYSBzbmlwcGV0IiBJIG1lYW50IHRoYXQgaXQncyBu
b3QgdGhlIHNhbWUgdGhpbmcsDQpidXQgY2xvc2UgZW5vdWdoIGZyb20gdmVyaWZpZXIgY29tcGxl
eGl0eSBwb2ludCBvZiB2aWV3Lg0KRXhpc3RpbmcgcHlwZXJmIHdvcmtzIGFyb3VuZCB0aGUgbGFj
ayBvZiBsb29wcyB3aXRoIHRhaWwtY2FsbHMgOigNCkknbSB0aGlua2luZyB0byByZXVzZSB0aGlz
IGhhY2sgYXMgZnV0dXJlIGJvdW5kZWQgbG9vcCB0ZXN0IHRvby4NCg0KQW5vdGhlciByZWFzb24g
dG8gYXZvaWQgdGhlIGxpbmsgaXMgSSdtIGhvcGluZyB0aGF0IHB5cGVyZg0Kd2lsbCBtb3ZlIGZy
b20gJ2V4YW1wbGVzJyBkaXJlY3RvcnkgdGhlcmUgaW50byBwcm9wZXIgdG9vbCwNCnNvIHRoZSBs
aW5rIHdpbGwgYmVjb21lIGJyb2tlbi4NCg==
