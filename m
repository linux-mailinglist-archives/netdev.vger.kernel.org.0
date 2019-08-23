Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD8C9B422
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387977AbfHWQBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:01:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46586 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387838AbfHWQBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:01:41 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7NFnecq003577;
        Fri, 23 Aug 2019 09:00:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JClZo6morMUeMDCjiEFM60DaeJt6TT1TONVDZa8s8Zo=;
 b=E1i7h765JHU9C0JKIPa0w8Z2Ntn4hrj9fbYtooOs95kqqLXIyFzs6AwJOvVeU//Y0xqp
 iP5ei4V0hsfuB3O0TtDNnVD5jJTaErk2wzcdRiBm+gI6nu2rWPmXCxBHC/KvFE8sVj6I
 qdOEacRljbojvsOSA0i59HuHfP25vpLOILI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ujjrs850f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 23 Aug 2019 09:00:18 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 23 Aug 2019 09:00:17 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 23 Aug 2019 09:00:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAnmBnAqxZS51Uyv2p4AmgoWLqvSeZSgbjxAZBOVtk/i3WRxXi3B52ROtvYeCHOSRiBT2G5RCrwc3tFzI7V6O26qgj/RZBzz+1cGjyEBSgtwkGfr8eudGT1e1fm/VavO1p86XZOkOPtmyxQ+3lqMF3gzjFGcUxOt9xeEIXNwlt0lXIToBer8zj8wcoPFJKRFv7s/43JiAglQhNH7fEQm4WFTVdxjXYFw3dKJftcMpWqkY8oWYiewu+QsZhOcv69/97hB82vrHGBFthW+C1qlUgcb5S1AiGNvt8BQ2Xmv9fo7dwAWozEgnnhp+0YTrQsPexgpe15FYfRDoMwq+JtG9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JClZo6morMUeMDCjiEFM60DaeJt6TT1TONVDZa8s8Zo=;
 b=D8h+bnyZOWWjzCtNqwNJa/p7z8QV/pZlhUs/NOhKf7G8rM8TldF+NZJFkohmAT0zitT7K3LzGTzheAK2pLmyMFU6TR+G3pf9a5l2XgTLlh+junPa7LzZXmcXHQ0IrDqgTj0fjfHif0sYxShqPr8D/KbB3f8Z4s7Iu2BqvRUad+x239nGvOQucNUeiRL4U+sx+oqpcHkjoWlKtu2w7ctH+l+WDGRXetgzCQizpZSRoUgxCSxCesvhyyyPfPqOtGBcf6xUCevnjQ/hrdIP7chDtfFgNh/GgwuBDZWd6B/j5yiLDRdxv5yNpfSQjr6I7zslWPk654k34DnvKG8xL5W1zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JClZo6morMUeMDCjiEFM60DaeJt6TT1TONVDZa8s8Zo=;
 b=AiHbXiaGo2Kn2spHfWBySmTnl4+IzkoaPbdAD06PoOQ3CB/JpRqyoV/JwX11NzO13T3fRdtd+Z7/XdzsfwBGX6317C6/9I6GpHxBbyFixhOu7yYRF0QIrp3/LsOy/hBWUdh0ueoPeqTxaIDVIuBp00NMge/Wyguhu+biLF+5YFg=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2981.namprd15.prod.outlook.com (20.178.237.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Fri, 23 Aug 2019 16:00:01 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c96d:9187:5a7b:288]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c96d:9187:5a7b:288%5]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 16:00:01 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>, Julia Kartseva <hex@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: libbpf distro packaging
Thread-Topic: libbpf distro packaging
Thread-Index: AQHVUUC6mSeRtrJxpEmiNjup7x1PAKcGJtMAgAJfWYCAAG7xgA==
Date:   Fri, 23 Aug 2019 16:00:01 +0000
Message-ID: <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
References: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com>
 <20190813122420.GB9349@krava>
 <CAEf4BzbG29eAL7gUV+Vyrrft4u4Ss8ZBC6RMixJL_CYOTQ+F2w@mail.gmail.com>
 <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
 <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com> <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava>
In-Reply-To: <20190823092253.GA20775@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0018.namprd02.prod.outlook.com
 (2603:10b6:301:74::31) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9aac]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c1112eb-bb53-4728-5a6f-08d727e2f406
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2981;
x-ms-traffictypediagnostic: BYAPR15MB2981:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2981CCD82695747A636FE677D7A40@BYAPR15MB2981.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(346002)(376002)(39860400002)(366004)(136003)(396003)(189003)(199004)(4326008)(102836004)(305945005)(186003)(7736002)(4744005)(386003)(6506007)(53546011)(3480700005)(81156014)(76176011)(6636002)(14454004)(6486002)(6512007)(229853002)(66946007)(8676002)(99286004)(52116002)(316002)(66446008)(25786009)(66476007)(66556008)(64756008)(6436002)(54906003)(81166006)(110136005)(446003)(6246003)(11346002)(2616005)(486006)(478600001)(6116002)(71200400001)(71190400001)(36756003)(2906002)(86362001)(31696002)(53936002)(476003)(46003)(5660300002)(8936002)(256004)(7116003)(31686004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2981;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: w7QWEU7dDqaB8HTW2oHCtVMeH1LFknFRIxuy8roHsH24JjagTrNIJpaOyP5FUC4qpcPW9FytimPa87Esyw6h3pSprKfq/tuxxtY0R/Omta6W1z8VYuVdnGq2Ekls1Qcv54r3WXYZsvPxk0YlrfctOES39f3TwG45CvIUVKAiDyxaBvszWjUc65Au9MWrxGt2iBCdO+4H3ahywV24IVwY9TWCjXqbR8vZ3XDdfeM1OSvdY5M8I74578640MxTAw/GBK7r05/NRxJEz/evz6yCQGSun7pW3I0m5cOBcKrVxIwHNTJEWiE1/lEghYoJXhe9i+jWYMBwgk5uh/ZdBtmbPKlNeltBc72g7+o800K4rqaauKw1WzT2c2E9yMIMSWnWqabLUKdtuJM7EZqSznDoxvWkEsx5z0w7+RWJvsx5mDE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEC7288450529F44A8DA96EFAE138F1B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c1112eb-bb53-4728-5a6f-08d727e2f406
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 16:00:01.2860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ygap23WFSEYYvR0aysGfVkLeTtS1K83gultpzRG+rShtpVLbPuE9Di5b0EkjMboq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2981
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=962 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908230160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yMy8xOSAyOjIyIEFNLCBKaXJpIE9sc2Egd3JvdGU6DQo+IGJ0dywgdGhlIGxpYmJwZiBH
SCByZXBvIHRhZyB2MC4wLjQgaGFzIDAuMC4zIHZlcnNpb24gc2V0IGluIE1ha2VmaWxlOg0KPiAN
Cj4gICAgVkVSU0lPTiA9IDANCj4gICAgUEFUQ0hMRVZFTCA9IDANCj4gICAgRVhUUkFWRVJTSU9O
ID0gMw0KPiANCj4gY3VycmVudCBjb2RlIHRha2VzIHZlcnNpb24gZnJvbSBsaWJicGYubWFwIHNv
IGl0J3MgZmluZSwNCj4gYnV0IHdvdWxkIGJlIGdyZWF0IHRvIHN0YXJ0IGZyb20gMC4wLjUgc28g
d2UgZG9uJ3QgbmVlZCB0bw0KPiBib3RoZXIgd2l0aCBycG0gcGF0Y2hlcy4uIGlzIDAuMC41IHBs
YW5uZWQgc29vbj8NCg0KVGVjaG5pY2FsbHkgd2UgY2FuIGJ1bXAgaXQgYXQgYW55IHRpbWUuDQpU
aGUgZ29hbCB3YXMgdG8gYnVtcCBpdCBvbmx5IHdoZW4gbmV3IGtlcm5lbCBpcyByZWxlYXNlZA0K
dG8gY2FwdHVyZSBhIGNvbGxlY3Rpb24gb2YgbmV3IEFQSXMgaW4gYSBnaXZlbiAwLjAuWCByZWxl
YXNlLg0KU28gdGhhdCBsaWJicGYgdmVyc2lvbnMgYXJlIHN5bmNocm9uaXplZCB3aXRoIGtlcm5l
bCB2ZXJzaW9ucw0KaW4gc29tZSB3aGF0IGxvb3NlIHdheS4NCkluIHRoaXMgY2FzZSB3ZSBjYW4g
bWFrZSBhbiBleGNlcHRpb24gYW5kIGJ1bXAgaXQgbm93Lg0K
