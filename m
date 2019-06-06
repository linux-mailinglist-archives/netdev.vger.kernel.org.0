Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88A336896
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfFFADw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:03:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48370 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726532AbfFFADw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:03:52 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x55Nx3ew001907;
        Wed, 5 Jun 2019 17:03:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=N7PnQa0rjRYE0cQiSc326m54Qd5gWWNpMql9FoKqRzg=;
 b=P7dtukCAWfXK/ppK0Wg5QeXiKG4UOoYJFTkGnsN9ZiQ40l/7egJaSDSR245fqSEP8pv6
 I4qf68sUvCNXjCVdjlBiQo9wWgRu8pGBCzOP2zudfuqhXgNT39El48FlPVXgZKdEQ3go
 cYMNSlT2BZvmqWfpgZL9XfkNmy4HBZSPmB8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2sxptnr6x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 05 Jun 2019 17:03:31 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Jun 2019 17:03:31 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 5 Jun 2019 17:03:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7PnQa0rjRYE0cQiSc326m54Qd5gWWNpMql9FoKqRzg=;
 b=ia+9s0ciaSIEELPfxca+1iCdf6AY5IgsHWK7Tx27ztG/S72b1A77JYTHWABitD1zz2mwR9iz6zJouWNYWCBPLK7Po8fvV2f4UAjs8E0Oy7L7XEI3HAO+ea9urZAlr+zSDeRKDwRAegA1ie83QW2xRF3/xK7e9b8lGiEqfnD7lRc=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1760.namprd15.prod.outlook.com (10.174.97.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 00:03:29 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Thu, 6 Jun 2019
 00:03:29 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH bpf-next v2] samples: bpf: print a warning about
 headers_install
Thread-Topic: [PATCH bpf-next v2] samples: bpf: print a warning about
 headers_install
Thread-Index: AQHVG/kbVvomH55UD0ytjdsrNHeCQKaNvpQA
Date:   Thu, 6 Jun 2019 00:03:29 +0000
Message-ID: <20190606000326.mrgtzfud55a4kczj@kafai-mbp.dhcp.thefacebook.com>
References: <20190605234722.2291-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190605234722.2291-1-jakub.kicinski@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0100.namprd04.prod.outlook.com
 (2603:10b6:301:3a::41) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:b7bf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5418070-602a-4450-d9b7-08d6ea12676b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1760;
x-ms-traffictypediagnostic: MWHPR15MB1760:
x-microsoft-antispam-prvs: <MWHPR15MB1760631B837F263394B99ABCD5170@MWHPR15MB1760.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(396003)(346002)(366004)(136003)(189003)(199004)(8676002)(6512007)(9686003)(6506007)(81156014)(66556008)(386003)(6916009)(66476007)(102836004)(73956011)(66946007)(68736007)(14454004)(46003)(6246003)(64756008)(99286004)(8936002)(2906002)(486006)(76176011)(478600001)(52116002)(11346002)(446003)(4326008)(186003)(476003)(25786009)(256004)(6116002)(229853002)(5660300002)(66446008)(81166006)(6486002)(6436002)(1076003)(71200400001)(53936002)(316002)(305945005)(86362001)(4744005)(54906003)(71190400001)(14444005)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1760;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mdtBsjBLJ0PcK3qa7wubZK9uB6x9Dp9/bUZ+qQvtplIIVeYi6tmh7JJOy4tO23lEKbsooXM5xeGmohsY8+4tjzyEfhnjDOBmCpXjxclBFNAfmEKyxFMb1oyoo9TjJs3/Ly9DgPwNB64AKBVMeFXeRgxkyMVQSTvgODf+1vfZPrZh74Bj39OyuL1+jXHpGDVCZUH1hElQvkwuJ8C/1nrI6sD0zuz8I9uVFzM88urf2Ubmr+5drXLa0RhD35oDbTo1hMxlp7dCTsww0m3aNTXAVN0ISl4qGWYMXvaTJRvvodUv82w9jEnXdVL9iwT68NU5e3qUc8G/0vphvTT4UCmB96Of2kBgzktkxBXYOvGhYwaiw5NfMQPtZFSuOYyaB7kjQax9CV+hEZf71Wtf3vjpRSAg2py3s9Q3DrZYjbQr6g0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F48CBBD11DF1EE419E768291AB51D7EA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a5418070-602a-4450-d9b7-08d6ea12676b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 00:03:29.1141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1760
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=865 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906050152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBKdW4gMDUsIDIwMTkgYXQgMDQ6NDc6MjJQTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+IEl0IHNlZW1zIGxpa2UgcGVyaW9kaWNhbGx5IHNvbWVvbmUgcG9zdHMgcGF0Y2hl
cyB0byAiZml4Ig0KPiBoZWFkZXIgaW5jbHVkZXMuICBUaGUgaXNzdWUgaXMgdGhhdCBzYW1wbGVz
IGV4cGVjdCB0aGUNCj4gaW5jbHVkZSBwYXRoIHRvIGhhdmUgdGhlIHVBUEkgaGVhZGVycyAoZnJv
bSB1c3IvKSBmaXJzdCwNCj4gYW5kIHRoZW4gdG9vbHMvIGhlYWRlcnMsIHNvIHRoYXQgbG9jYWxs
eSBpbnN0YWxsZWQgdUFQSQ0KPiBoZWFkZXJzIHRha2UgcHJlY2VkZW5jZS4gIFRoaXMgbWVhbnMg
dGhhdCBpZiB1c2VycyBkaWRuJ3QNCj4gcnVuIGhlYWRlcnNfaW5zdGFsbCB0aGV5IHdpbGwgc2Vl
IGFsbCBzb3J0IG9mIHN0cmFuZ2UNCj4gY29tcGlsYXRpb24gZXJyb3JzLCBlLmcuOg0KPiANCj4g
ICBIT1NUQ0MgIHNhbXBsZXMvYnBmL3Rlc3RfbHJ1X2Rpc3QNCj4gICBzYW1wbGVzL2JwZi90ZXN0
X2xydV9kaXN0LmM6Mzk6ODogZXJyb3I6IHJlZGVmaW5pdGlvbiBvZiDigJhzdHJ1Y3QgbGlzdF9o
ZWFk4oCZDQo+ICAgIHN0cnVjdCBsaXN0X2hlYWQgew0KPiAgICAgICAgICAgXn5+fn5+fn5+DQo+
ICAgIEluIGZpbGUgaW5jbHVkZWQgZnJvbSBzYW1wbGVzL2JwZi90ZXN0X2xydV9kaXN0LmM6OTow
Og0KPiAgICAuLi90b29scy9pbmNsdWRlL2xpbnV4L3R5cGVzLmg6Njk6ODogbm90ZTogb3JpZ2lu
YWxseSBkZWZpbmVkIGhlcmUNCj4gICAgIHN0cnVjdCBsaXN0X2hlYWQgew0KPiAgICAgICAgICAg
IF5+fn5+fn5+fg0KPiANCj4gVHJ5IHRvIGRldGVjdCB0aGlzIHNpdHVhdGlvbiwgYW5kIHByaW50
IGEgaGVscGZ1bCB3YXJuaW5nLg0KQWNrZWQtYnk6IE1hcnRpbiBLYUZhaSBMYXUgPGthZmFpQGZi
LmNvbT4NCg==
