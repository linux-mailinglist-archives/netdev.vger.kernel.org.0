Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9C5E1052
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 05:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389500AbfJWDDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 23:03:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7674 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727960AbfJWDDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 23:03:40 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9N33UB1008171;
        Tue, 22 Oct 2019 20:03:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vIwXv/NQ3LcKw1irgDHjhymljLEWRTjZpsOahURiGH4=;
 b=HVbHvKoggJcaZXpCqepUxT58DfpJfb6lTHT7/G6cMvApUO0Wbd2JC4AmQSPHLciVJhlQ
 2y7DU2hoLB4bFPW0i7vhmz1B9vhqmxhcaRsfFjCLXbTGEEoFGDLlu3ZHyAfFv4RGFUDU
 Zfj6JRWIW533vYfOAOHSAHJG7FHlJofXrSs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vt9t6h3fv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Oct 2019 20:03:38 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 22 Oct 2019 20:03:36 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 22 Oct 2019 20:03:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+p4ZfIqU7RtBEPjjziU0IxPhZPAgHeqrCEqH8ygoKsnVCjsH2h9svKciV1RTenwc3isbr28tyC0JV0xgsa8AljpFexxCu0mwftFqhxwSI+ysY2RQqy2mZMQqCuQPFRtnoNeQCAa/dDJhGSfQT/IgWd7EQZSRp/v393091fzRP3C9dsTY2UwS7GwpJK0FUoJvnSPevsmJlSKbpxYWHxf6f7AHW4hKLE83SzpVe/UqMYTjP+dgq08oZ75vFC3yoIGs3doHq6Yv/P/M2z0WlqArk6eykmup3NeK9K0Y9GF8EXfPfliwFo2H3RakgUv5RjweF7I9xmcn4FQUteEUo6y0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIwXv/NQ3LcKw1irgDHjhymljLEWRTjZpsOahURiGH4=;
 b=NkR0+mYuXYIYxg2+0ohTS7w1gEUhDE83O0xcW6+SoQ55JU/+iC0uar7bOayTECf4dMHmQ2cha+fFDKGntMNS/ALtvXnXH9HoeVfSWXkwmv1EL8ZFICKVraMY3WzMAX1SXW3ZLumVzeRMvreDnm5qOFzLPmUPJ4YiVR13ybskMn6Amh89CjOC1N21Hlf4aBQTXyWab4evNrl4TOVI+2RCCEoRm2wgyoP0CX0/8fiKUbsCZqLmLZ6j/1yfqiO+ReNK6mqtTWmNQsLzCoWjnd4PUiu/w8+eMEhBjE6ZutlTT7vV1Arh9Jqc1N3mlw53axl2zNG3QclI961oR6Dn0BzMMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIwXv/NQ3LcKw1irgDHjhymljLEWRTjZpsOahURiGH4=;
 b=KWWk4Rst6d5vwh3BYgF5n0ZXhho+QcEptVtOZeBsRFMsDOHfSMsPiP966CCO7eUF4ik7yMBsSJH4LCJrL5KQHZEmyMxAeOYlStGC0/PzDtFLqQh/8on6LWkKHPdunKnY1DqNPou0eIDT4A2IkR2yczL+dcyeI1KMEDlRUskJG9c=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2456.namprd15.prod.outlook.com (52.135.193.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Wed, 23 Oct 2019 03:03:35 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.019; Wed, 23 Oct 2019
 03:03:35 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v15 5/5] bpf_helpers_doc.py: Add struct bpf_pidns_info to
 known types
Thread-Topic: [PATCH v15 5/5] bpf_helpers_doc.py: Add struct bpf_pidns_info to
 known types
Thread-Index: AQHViQ15YcZxH893BEGob/fU+NjkU6dnisoA
Date:   Wed, 23 Oct 2019 03:03:35 +0000
Message-ID: <94acffc3-5f37-a01f-e55a-4af2206a2730@fb.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
 <20191022191751.3780-6-cneirabustos@gmail.com>
In-Reply-To: <20191022191751.3780-6-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0057.namprd10.prod.outlook.com
 (2603:10b6:300:2c::19) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::b6b9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca66f6f8-d18b-496b-29ff-08d757659846
x-ms-traffictypediagnostic: BYAPR15MB2456:
x-microsoft-antispam-prvs: <BYAPR15MB24562635BA20E7F9AC458E74D36B0@BYAPR15MB2456.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:361;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(478600001)(14454004)(5660300002)(54906003)(31686004)(6246003)(316002)(6436002)(66946007)(6486002)(229853002)(31696002)(25786009)(64756008)(66556008)(4326008)(66476007)(4744005)(6512007)(76176011)(36756003)(2501003)(99286004)(476003)(2906002)(8936002)(52116002)(486006)(6506007)(305945005)(186003)(7736002)(2616005)(6116002)(386003)(71200400001)(46003)(110136005)(86362001)(446003)(102836004)(66446008)(256004)(8676002)(11346002)(81166006)(81156014)(71190400001)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2456;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oWCIYiLocB3rVe806sRKVPc3FH8Ymprs4DEDUJ/ojx4H6JUcQP5xkiFJfp5UtFDaCX7fAo7V0bp+T7u6pd9P5bDKGU9IELsUYII1zCm4NT/Y2jKtuBOFFmDsCqNAByAe4ISLjtT333krM0KT1lSpaJVIJw+K5gxJH5vyh/kxWT6F2tFyJV3Gr6OE2apVzgdQS2WrfXZVirsKTZqfwXl3MxkytjI9ZPr0ZBmOWSFlR3qciPtvm66c2lOTc6wnlc9h7O6eXTCoER7PvGxeCv7LvAO0wjWBaXGG5Cqx3GLvYzvlZNffsGZ1JQ5ZxvAxFtxEM+glhxkuSWSQBd0PACrdbHlld75LaZMQOkNhnUAgyFovGMLMWK5AVlfI6qTJrPO3z2pV9odIXcijSCd0BABEQDM/j6MHftAes82H8r1IhNkE/rrBpA2KnwmPAwr4jpAy
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F55F58481E82AB4BAF72BFF41D775073@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ca66f6f8-d18b-496b-29ff-08d757659846
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 03:03:35.7201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fk/awpIoMvw3Ojm0ohgEJBx+lJY5an2RVKVrBJTK02ItT2iNiQb4ddn907lP6m44
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2456
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-23_01:2019-10-22,2019-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 mlxlogscore=805
 adultscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910230030
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzIyLzE5IDEyOjE3IFBNLCBDYXJsb3MgTmVpcmEgd3JvdGU6DQo+IEFkZCBzdHJ1
Y3QgYnBmX3BpZG5zX2luZm8gdG8ga25vd24gdHlwZXMNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENh
cmxvcyBOZWlyYSA8Y25laXJhYnVzdG9zQGdtYWlsLmNvbT4NCg0KQWNrZWQtYnk6IFlvbmdob25n
IFNvbmcgPHloc0BmYi5jb20+DQoNCj4gLS0tDQo+ICAgc2NyaXB0cy9icGZfaGVscGVyc19kb2Mu
cHkgfCAxICsNCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYg
LS1naXQgYS9zY3JpcHRzL2JwZl9oZWxwZXJzX2RvYy5weSBiL3NjcmlwdHMvYnBmX2hlbHBlcnNf
ZG9jLnB5DQo+IGluZGV4IDc1NDg1NjllODA3Ni4uMDIxY2MzODdkNDE0IDEwMDc1NQ0KPiAtLS0g
YS9zY3JpcHRzL2JwZl9oZWxwZXJzX2RvYy5weQ0KPiArKysgYi9zY3JpcHRzL2JwZl9oZWxwZXJz
X2RvYy5weQ0KPiBAQCAtNDM3LDYgKzQzNyw3IEBAIGNsYXNzIFByaW50ZXJIZWxwZXJzKFByaW50
ZXIpOg0KPiAgICAgICAgICAgICAgICdzdHJ1Y3QgYnBmX2ZpYl9sb29rdXAnLA0KPiAgICAgICAg
ICAgICAgICdzdHJ1Y3QgYnBmX3BlcmZfZXZlbnRfZGF0YScsDQo+ICAgICAgICAgICAgICAgJ3N0
cnVjdCBicGZfcGVyZl9ldmVudF92YWx1ZScsDQo+ICsgICAgICAgICAgICAnc3RydWN0IGJwZl9w
aWRuc19pbmZvJywNCj4gICAgICAgICAgICAgICAnc3RydWN0IGJwZl9zb2NrJywNCj4gICAgICAg
ICAgICAgICAnc3RydWN0IGJwZl9zb2NrX2FkZHInLA0KPiAgICAgICAgICAgICAgICdzdHJ1Y3Qg
YnBmX3NvY2tfb3BzJywNCj4gDQo=
