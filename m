Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5766AE7EDF
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 04:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbfJ2D3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 23:29:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32966 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726411AbfJ2D3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 23:29:16 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9T3RtAu005058;
        Mon, 28 Oct 2019 20:29:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1cwE6wyeIj6W/9HsIMFfdnxE3ISE4N6KRYcYOorFTr8=;
 b=EaL100WCyh+B7Rg9qlfnl0MnPOeixv3/Bh2ZPDFebnrPPYnZtiDuwMG3rA8DA2e2w6wo
 RUU4OgMIHVUTU59//04fnbu9mqCJCl8bmvHycf9FhZ+kNN5OWSS2p8hp4EidBiFieryu
 2EycOiMua2N+BWEXYzms/Gi71GT+knMw9Tk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vvhtpmbhr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Oct 2019 20:29:04 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 28 Oct 2019 20:29:02 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 28 Oct 2019 20:29:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIBPD8iBvgz9xNdy97UWqKGAFf2HqRF35uehZRoLM2U5jcj91wuBxAl+ogbqnsbAjxFAVyc2RGHO+Rghfdbvp0vSjFL5juinQtvKwsIDbAkcUv2s49mbQblkvG2a+guqbHLT+VfvOwxfNfPJlJttuDave3503Y+2gHmRCKl3HnD0Bxowh37kUx9/B+4sdumLkx5DtPqSlNCQwqyswyB9mhYH1ehEuuiQlwjMHwhOkzCVHAr6zGM8xgtRqEkaouNUhIuMrEvOJMZBihvU2/IIuzfktqCikJXFKMmjvvtjpmQhKJeGEL3Xn0dAkfV+J4twMV/+s59PrgIJf/Sz7nM8ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cwE6wyeIj6W/9HsIMFfdnxE3ISE4N6KRYcYOorFTr8=;
 b=hTKpf+CQOQ8z9GwJ82XWJKBsvP6CPVm/KoCcJutNf3mGvkfUvg3mOrIFZy4gSlgAAXkZezuzDC1njnypxyPB4swKqI7RRJqPSo2GYV4LJ1Do2RIq6W6XlVfxlLACwFUYdMPll6MRjrnCkkR5q/y0wf/77zavUbZekxaYmr5DwTFFF8g9bd1PZ6A5BArKB1OzrrCacY6gDLTEIBRfR4kj1GduP7IJN9CmFt5jMcna+SZLLmVorVzWs4K/AzdN31yHnuDkSEVaZg4ickIoaKwwb7s7oevBsaI8u5/hiaa2VcUZHeudWTri5cRmCX4c1sGAWmH0vtwaC8a4k5fpWFs6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cwE6wyeIj6W/9HsIMFfdnxE3ISE4N6KRYcYOorFTr8=;
 b=UzsLPkOvAk7iyM3PGaUeClsKldYlu2480wkB9ZqGjctHAjbgmsCiH5D+e6Dcr2PjJRSV50qNLgfoBq6IHQuKf9UIKkjsH2n+uD1d3Btq0L6OEB52n4tV72kqz4I3tdFIL+ZJ5wpxq6R8Y9Pt08naOUCBi2XDtSr6fa4tXRPui9k=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3493.namprd15.prod.outlook.com (20.179.56.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Tue, 29 Oct 2019 03:29:01 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::707c:3161:d472:18c5]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::707c:3161:d472:18c5%4]) with mapi id 15.20.2387.025; Tue, 29 Oct 2019
 03:29:00 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: fix off-by-one error in ELF sanity check
Thread-Topic: [PATCH bpf-next] libbpf: fix off-by-one error in ELF sanity
 check
Thread-Index: AQHVje//2Io4QtScMUyUGlobiBgmzadw9heA
Date:   Tue, 29 Oct 2019 03:29:00 +0000
Message-ID: <fd09a18e-812a-4996-bfe0-6d8bb79de788@fb.com>
References: <20191028233727.1286699-1-andriin@fb.com>
In-Reply-To: <20191028233727.1286699-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:102:2::16) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f43e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3264fe17-def9-4f60-dca5-08d75c2023af
x-ms-traffictypediagnostic: BYAPR15MB3493:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB34930744800B062D892F2BE3D7610@BYAPR15MB3493.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(136003)(39860400002)(366004)(199004)(189003)(386003)(102836004)(53546011)(25786009)(36756003)(256004)(99286004)(2501003)(64756008)(66556008)(66476007)(486006)(66446008)(476003)(66946007)(76176011)(186003)(478600001)(46003)(4744005)(446003)(2616005)(5660300002)(71200400001)(71190400001)(52116002)(6506007)(31686004)(4326008)(8936002)(2906002)(6116002)(31696002)(14454004)(305945005)(7736002)(6436002)(316002)(6512007)(86362001)(6486002)(2201001)(54906003)(8676002)(229853002)(81156014)(6246003)(81166006)(110136005)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3493;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fHGW4Qw9O+mdcpH50XM8PNw+i3JAzQ1jpXlpBFGvO0Psmfz8p1xqwX7hMNfmGpnoaBor6cOMRiohU6LOeS0n5UXX6SQsIZ1oKfmNxjvTEiM08sKy36AfDXtxBCDQhedJ4a8sy7kPnOFyQzephbnjXU3VyDYEXawxBZeCFuPelzHYjymCGQcbzjoiaLJqdvkwVlVMAHIU93YsmzXjDQ5xyf+K1bbrbRg0mzYd3HDgiIL4wskW9kkqKf8uT9D42Q5xaVPWM9dkm9KFbMcKavg/30CJO5ZVl4uUW04K/zIKEPOxYyl/PRPjArBZy8l9mAmtut0W6L9FQx7kf5BwiXcqa64gBBc9SUazUPkvLowybIlfAy1V0asO1aBaak+7Z4stVoZisprIWg046ZRNfWv1ENFouDl9MkjhVNMaaiiU414VPOohA5FWfpTyBHHSUUTV
Content-Type: text/plain; charset="utf-8"
Content-ID: <A45C5A4568D9BB4BB34C7798D6B87735@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3264fe17-def9-4f60-dca5-08d75c2023af
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 03:29:00.7478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H0dz1T5+9ZB7zTEScHMcT/QtVxYiXAk/SvPuv4WSQkJDmq/TyL/3nXiGqeVRr/3s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3493
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_07:2019-10-28,2019-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910290036
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMjgvMTkgNDozNyBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBsaWJicGYncyBi
cGZfb2JqZWN0X19lbGZfY29sbGVjdCgpIGRvZXMgc2ltcGxlIHNhbml0eSBjaGVjayBhZnRlciBp
dGVyYXRpbmcNCj4gb3ZlciBhbGwgRUxGIHNlY3Rpb25zLCBpZiBjaGVja3MgdGhhdCAuc3RydGFi
IGluZGV4IGlzIGNvcnJlY3QuIFVuZm9ydHVuYXRlbHksDQo+IGR1ZSB0byBzZWN0aW9uIGluZGlj
ZXMgYmVpbmcgMS1iYXNlZCwgdGhlIGNoZWNrIGJyZWFrcyBmb3IgY2FzZXMgd2hlbiAuc3RydGFi
DQo+IGVuZHMgdXAgYmVpbmcgdGhlIHZlcnkgbGFzdCBzZWN0aW9uIGluIEVMRi4NCj4gDQo+IEZp
eGVzOiA3N2JhOWE1YjQ4YTcgKCJ0b29scyBsaWIgYnBmOiBGZXRjaCBtYXAgbmFtZXMgZnJvbSBj
b3JyZWN0IHN0cnRhYiIpDQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlp
bkBmYi5jb20+DQoNCjQgeWVhciBvbGQgYnVnLiBOaWNlIQ0KQXBwbGllZC4gVGhhbmtzLg0K
