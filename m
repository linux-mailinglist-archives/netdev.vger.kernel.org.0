Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA81A781D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 03:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfIDBki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 21:40:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26640 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbfIDBkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 21:40:37 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x841ccOm024730;
        Tue, 3 Sep 2019 18:39:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=lgWZ+h/QkS4tGCduO70JzkObnFrM14yPPcBFIqj6KUI=;
 b=bPgWq/G3KtajEVQUjnNsAawJ6sKFDOMv0ZSvsZdgzCkixvSCvSZ51U6aaa0Z75Cr9CIv
 nRrq9Fp+Y3L1H21pvPwY4TUo3UBEwE+vxbx/RzAv2DYU2pBnMeFxKqPFFG6ZXUqZdPMe
 tc7aZHfcD6vaRotBdiUJxMVS5jiXs11PRJQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2usq7ebfy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 18:39:32 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 3 Sep 2019 18:39:31 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 3 Sep 2019 18:39:31 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 3 Sep 2019 18:39:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LyhiadJM8MNNY9Bc3me93PCs03XGH+W3IFHRVt6hNQykMjmW044a9QGRVkbYe3/IuRj35E/6DHFjm8T0Aa4qwolN/AQ4WZNnLXWK8fsXYlXoq2DriUBa9vnFkZ9xrBtt7ImxybWlDIZzd2y7WDyk4powW7eFquuYQewr5DUw9CRjzdd0+Bee/r3e+YDWse7MEXg67Dw7CiSEDe3KvV3J2M6b4078u33zn8OpHystuYMRTKpEb8CtRnhUg5q4VwsuiugTEQNlCuqUHtTOPDdICq14+daNGVpx/ovYAd7SBOYTxjGnl6+YxQQKIENhLIqOV0n9zlBSWcR2YkYbYKWpvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgWZ+h/QkS4tGCduO70JzkObnFrM14yPPcBFIqj6KUI=;
 b=mTB9Ch+GM/kVAm3LRvDOVeth8xtDtrjXccnLvz9tjvNK+se3A6jJHRCukXfGgGLMBHX/CmbreY9273GbvQPFCTqUN9cJEbXOkPRkvBbAS7xWAY6KZT3e/hyZl6hztNg5TPqB9CSbTeL3cjKHn8VoVK/IDm1Hjx1d+J7vXIjf9Vd4BBQjaiP3jg9cIv+i39jOIQwIV2MyWu6mnImIKJ3ziclWGmHApNWLxVDuMKqu0n/wpaXfw5KKM0et2w84vYVoxCw3Zm2/naK7zF6w7wLKJPTn3CK22Hc150VWIKiFH/S6AezG76zWTrvNJTFLN77W9qjKmrO4wb4lFJ8I7M9vlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgWZ+h/QkS4tGCduO70JzkObnFrM14yPPcBFIqj6KUI=;
 b=BxOSiCmfwA2mrWPxsTPRs9Znqp4hXNzW29pKiYbnjORIvIEHb07OxvOKJK0epr0ac0jVAlvHytJskzBPCFQ6Z6/sq01s+hP7zTUbLhjOw9Tlo2pjeJegBrXksxQ+psTEp/RLg8Sj0IdIHEgEIwKpA400VKCa31t8/0dmfmKROeA=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3015.namprd15.prod.outlook.com (20.178.238.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Wed, 4 Sep 2019 01:39:29 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::65e2:8d24:46f3:fd3d]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::65e2:8d24:46f3:fd3d%7]) with mapi id 15.20.2220.021; Wed, 4 Sep 2019
 01:39:29 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Thread-Topic: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Thread-Index: AQHVXiiECXa58nNjTk27E4Nc66HXg6cSQZuAgAAhAoCAAW2TAIAG9qmA
Date:   Wed, 4 Sep 2019 01:39:28 +0000
Message-ID: <46df2c36-4276-33c0-626b-c51e77b3a04f@fb.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
 <ed8796f5-eaea-c87d-ddd9-9d624059e5ee@iogearbox.net>
 <20190829173034.up5g74onaekp53zd@ast-mbp.dhcp.thefacebook.com>
 <59ac111e-7ce7-5e00-32c9-9b55482fe701@6wind.com>
In-Reply-To: <59ac111e-7ce7-5e00-32c9-9b55482fe701@6wind.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0147.namprd04.prod.outlook.com (2603:10b6:104::25)
 To BYAPR15MB2501.namprd15.prod.outlook.com (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:58a9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9aa81fad-cd02-4512-0f4c-08d730d8ba00
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3015;
x-ms-traffictypediagnostic: BYAPR15MB3015:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB30152F6E7D4427C6B70077F5D7B80@BYAPR15MB3015.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(376002)(136003)(366004)(189003)(199004)(229853002)(14454004)(66476007)(99286004)(4326008)(102836004)(52116002)(25786009)(476003)(186003)(446003)(386003)(6506007)(110136005)(76176011)(7416002)(53546011)(6246003)(86362001)(54906003)(2501003)(6436002)(316002)(6512007)(2906002)(6486002)(6116002)(486006)(81166006)(8936002)(31686004)(8676002)(36756003)(4744005)(66946007)(53936002)(31696002)(2616005)(478600001)(46003)(66574012)(256004)(14444005)(5660300002)(7736002)(71200400001)(71190400001)(66446008)(64756008)(11346002)(81156014)(305945005)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3015;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mBUk+e8/xN85mEEf6CtC6cD8GmaSHtkc6BCHHrGKKCevvQTgasJNyGzGtdGgohMtG29JfxlY6rKm3+T8zk4UX0SJwmvs/XBsRCNqrnf0euhPrASH5P7nvHGiPcuomUg38DkAyTpOgDpOLkRfT/cwAARWhr6q8ddtpbC9hUOjM8pLmLD2EyGcD3FxPDq848XXKc1YzhBhY4QMcyxwAIjpulUyCyJ8VxEDjKzrLKaBuK0y85VW+BeNC15py1DOD9cuDzr9NQwRc/aEM4sNOsDjnSrkJpRjaR0nc7vmYB9j4KQrLoStBELRPT4yMEKK2hmsGCpWPEDkyJXP1jP70FpHyXn+8RES2jSq7kUIMBuaNvF/FbyD7FRcm2UdiqDWRLn2Iwx/LRrkHLpWPtOdtVWW1Ll2RXPDjRWub63xMFrTPC0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <032BE727726D484FB96AD8BCF8C8DC4F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa81fad-cd02-4512-0f4c-08d730d8ba00
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 01:39:28.9878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qOJfDq2DSFNs/KvvyW6HoPS01EMNOysUWgO+qTEf/vtUy8eA3lgbaFYZZ/qms3s7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3015
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_05:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=962 mlxscore=0 clxscore=1011 phishscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909040015
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8zMC8xOSA4OjE5IEFNLCBOaWNvbGFzIERpY2h0ZWwgd3JvdGU6DQo+IExlIDI5LzA4LzIw
MTkgw6AgMTk6MzAsIEFsZXhlaSBTdGFyb3ZvaXRvdiBhIMOpY3JpdMKgOg0KPiBbc25pcF0NCj4+
IFRoZXNlIGFyZSB0aGUgbGlua3MgdGhhdCBzaG93aW5nIHRoYXQgazggY2FuIGRlbGVnYXRlcyBj
YXBzLg0KPj4gQXJlIHlvdSBzYXlpbmcgdGhhdCB5b3Uga25vdyBvZiBmb2xrcyB3aG8gc3BlY2lm
aWNhbGx5DQo+PiBkZWxlZ2F0ZSBjYXBfc3lzX2FkbWluIGFuZCBjYXBfbmV0X2FkbWluIF9vbmx5
XyB0byBhIGNvbnRhaW5lciB0byBydW4gYnBmIGluIHRoZXJlPw0KPj4NCj4gWWVzLCB3ZSBuZWVk
IGNhcF9zeXNfYWRtaW4gb25seSB0byBsb2FkIGJwZjoNCj4gdGMgZmlsdGVyIGFkZCBkZXYgZXRo
MCBpbmdyZXNzIG1hdGNoYWxsIGFjdGlvbiBicGYgb2JqIC4vdGNfdGVzdF9rZXJuLm8gc2VjIHRl
c3QNCj4gDQo+IEknbSBub3Qgc3VyZSB0byB1bmRlcnN0YW5kIHdoeSBjYXBfbmV0X2FkbWluIGlz
IG5vdCBlbm91Z2ggdG8gcnVuIHRoZSBwcmV2aW91cw0KPiBjb21tYW5kIChpZSB3aHkgbG9hZCBp
cyBmb3JiaWRkZW4pLg0KDQpiZWNhdXNlIGJwZiBzeXNjYWxsIHByb2dfbG9hZCBjb21tYW5kIHJl
cXVpcmVzIGNhcF9zeXNfYWRtaW4gaW4NCnRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uLg0KDQo+
IEkgd2FudCB0byBhdm9pZCBzeXNfYWRtaW4sIHRodXMgY2FwX2JwZiB3aWxsIGJlIG9rLiBCdXQg
d2UgbmVlZCB0byBtYW5hZ2UgdGhlDQo+IGJhY2t3YXJkIGNvbXBhdGliaWxpdHkuDQoNCnJlOiBi
YWNrd2FyZCBjb21wYXRpYmlsaXR5Li4uDQpkbyB5b3Uga25vdyBvZiBhbnkgY2FzZSB3aGVyZSB0
YXNrIGlzIHJ1bm5pbmcgdW5kZXIgdXNlcmlkPW5vYm9keQ0Kd2l0aCBjYXBfc3lzX2FkbWluIGFu
ZCBjYXBfbmV0X2FkbWluIGluIG9yZGVyIHRvIGRvIGJwZiA/DQoNCklmIG5vdCB0aGVuIHdoYXQg
aXMgdGhlIGNvbmNlcm4gYWJvdXQgY29tcGF0aWJpbGl0eT8NCg==
