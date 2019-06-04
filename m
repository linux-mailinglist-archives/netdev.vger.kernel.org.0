Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7EF33CAD
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 03:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFDBHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 21:07:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49432 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726102AbfFDBHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 21:07:41 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x540xCDM009700;
        Mon, 3 Jun 2019 18:07:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cdaZCPipD98JSeN+qIUi5iIJ5cRf61ZgSwMy6Y9Aftc=;
 b=fRptYF7Xf4+Df3AvqDpr16CG1S1OAZkd/GXN2uydv+fjnmsEcqUM1vrMrRCJzt6tXGow
 0g1FV/YP27pIirj657xQ7YJdSU4uCjCIbiCaDUGSU6J8dyGQk2IM3oHOlSVSpC1r/mWz
 5Ub2UlgksPwwgWA8Rx3vylhTPm0d1ozcH64= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2sw2u42hn2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 18:07:21 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 3 Jun 2019 18:07:18 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 3 Jun 2019 18:07:18 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 3 Jun 2019 18:07:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdaZCPipD98JSeN+qIUi5iIJ5cRf61ZgSwMy6Y9Aftc=;
 b=iNnoibn000DbG03x9CURjj6jB5JOguh+HjVrlmL3FE4BUt65GoJ4b5tD3NpngZxTiAX+AUh+rVyvoh+q9QzFaDXWhj3DEhwqx+BXVKRQdm7WR3FnNxwuRbcT3MrrGo/JC9mphIOE0ZnaZB77QfUFJk3txlndjAyHxE+tNamt1rI=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3159.namprd15.prod.outlook.com (20.178.207.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Tue, 4 Jun 2019 01:07:16 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 01:07:16 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
Thread-Topic: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map
 definitions using BTF
Thread-Index: AQHVF+6FIN4ypCqNSkaaeWcXaUexbKaFv76AgAAZLICABEsPAIAAXHQAgAAyMACAAAE1gA==
Date:   Tue, 4 Jun 2019 01:07:15 +0000
Message-ID: <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
References: <20190531202132.379386-1-andriin@fb.com>
 <20190531202132.379386-7-andriin@fb.com> <20190531212835.GA31612@mini-arch>
 <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch>
 <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
 <20190604010254.GB14556@mini-arch>
In-Reply-To: <20190604010254.GB14556@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0040.namprd04.prod.outlook.com
 (2603:10b6:300:ee::26) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:f892]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acb775d8-3a91-453b-6a70-08d6e888fba9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3159;
x-ms-traffictypediagnostic: BYAPR15MB3159:
x-microsoft-antispam-prvs: <BYAPR15MB31593DDFA1F8D12222B14DCDD7150@BYAPR15MB3159.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(189003)(199004)(14454004)(68736007)(2906002)(186003)(6486002)(6512007)(7736002)(229853002)(305945005)(6116002)(6436002)(476003)(46003)(36756003)(8676002)(446003)(81156014)(81166006)(73956011)(2616005)(53546011)(53936002)(64756008)(31686004)(66946007)(110136005)(8936002)(486006)(11346002)(256004)(76176011)(71190400001)(71200400001)(99286004)(14444005)(66556008)(386003)(6506007)(5660300002)(86362001)(54906003)(478600001)(52116002)(31696002)(558084003)(4326008)(25786009)(102836004)(316002)(6246003)(66476007)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3159;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CxNl+q48uMRKsyynLl8akjqdiLnb2SzN6bRxb6eBWORvgKePa830csH3zF2OfwRKxKUAvGPa0roM1iIQisFF+FI8ue8nHsxKwiwGU7+xKEccy4R/vAUEPGkm8JSc7AeXrtm+PN7SOyN37Bfe95+oirXCG/GJLGlI37MOZfLK5csbyQf0W5jhUbOFSwvHzKfpgA3MF7JbRCib+FkzbfQ8RP3x3P7tinHFWoXe5TPxHUnJaz0dtxP2BOrZBbtAQCvN3EylMBbz5YtAGfbE16t2Dk2BBeY23igE32JwQxYUWluu/xamcyxWbHTD1cfABQMs1l1s8YfanRkMBudEaUIIWaebOQFpUKYBIoelmWcAwm8utspbiBG55pA6OohoNlknKV/P7hCPu2hO/IU7vMzxDYPIQuaSeOa1sVA/gMo6f20=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A460F3CA7FFCB4BBAB7DEB0AF1B1E96@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: acb775d8-3a91-453b-6a70-08d6e888fba9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 01:07:15.8941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3159
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=771 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8zLzE5IDY6MDIgUE0sIFN0YW5pc2xhdiBGb21pY2hldiB3cm90ZToNCj4gRG8gd2Ugd2Fu
dCB0byBsb2NrIGV2ZXJ5b25lIG91dCBvZiBuZXcgbGliYnBmIGZlYXR1cmVzPw0KDQpCVEYgaXMg
bWFuZGF0b3J5IGZvciBfYW55XyBuZXcgZmVhdHVyZS4NCkl0J3MgZm9yIGludHJvc3BlY3Rpb24g
YW5kIGRlYnVnZ2FiaWxpdHkgaW4gdGhlIGZpcnN0IHBsYWNlLg0KR29vZCBkZWJ1Z2dpbmcgaXMg
bm90IG9wdGlvbmFsLg0K
