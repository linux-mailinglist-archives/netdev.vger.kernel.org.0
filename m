Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3AAC9603
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 02:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfJCAvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 20:51:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28154 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725860AbfJCAvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 20:51:32 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x930lr7J027555;
        Wed, 2 Oct 2019 17:50:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=l3B+ctXWweXEJ5Odf5GslDfZjq8OLJfGsxv2OQvqJL8=;
 b=PEuMgEsgHOCa8va+31TzSTk6LK447XzR8kBxxJru2um1aJ/LfXJqStquhS9vEPcbt/Q/
 ijXUoy3RLamphjO0QrfWYSY4gy+8kxUH5ylSuPQv4oJ29YNxist6FilrqRcYd43wABkf
 1tJlluV5yW4YUlyqrUxfIUnvWeKpZnc5SQA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vcddnpspb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Oct 2019 17:50:14 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 2 Oct 2019 17:50:13 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 2 Oct 2019 17:50:13 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 2 Oct 2019 17:50:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3TB2AVHhSUuJSpoNSwDI1wSum1qSS/aHFHLK2Q2NbEeeZ9Wa1wSf++nbvVk+P98r+SD/uMr7FVHCmur00rBrq+LYjBif1KEEmC33W+4BxyVVzmRalMkAIv5JgCzIAs3yrAtdXTOuC6DGxAsYQv3uoMqXDahaYxp91/HnSVelmcC7txCx7y5vcTetj8nyT8Vih78nilWizpHmxWc8Lhm4wvFI9jrD6jgKWwgqRJ+d0LHiP4iUmc6dU8phbNbRba7awRsz6CUncjLUyYTK1SR8nM15t3y38XnrKWWfQBd7JYLev9A/ZhbtNRYtnhZHtt8MP3yp9JWg9fvInUttBS4PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3B+ctXWweXEJ5Odf5GslDfZjq8OLJfGsxv2OQvqJL8=;
 b=fn1wvo7fXvNYZ5Nww7xRi5zsJyP7dgSDaJxwbB50UVmGOcNJESlkHlzCOxsOUk6kUz0TXUqB8PI/bRUu2dn8JTknzQcYYBWL3D0QFrXxd18arOSwx3UbpLdwdwn34IkAWAhMq3axm4X1hDL99C2A/dUYbk90NjrZPCb43X9I36/qQqr6j/pK5x0noDz6X7MRRU3X5HuiKYUPaVEmm2z0WRQAkjYkcFobAMGdRzqMM/Cv4o1la/LDx1hhwzGurWFTQiQGzFsukf52P5ZB4KxyweK3Cc8Tkx9D1ObhSy/mbwiWqfZj0QsCU1dWp2itBybXbnVZBGOCyUUmS00afE6OHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3B+ctXWweXEJ5Odf5GslDfZjq8OLJfGsxv2OQvqJL8=;
 b=ej+44cqOKQfKkAY7mADq7oLOP+0Rlfn+Fmego++c6/RiE1mgFNO3maGBlFhk5EFui5Pl1hFZTvfmqymDO2JMQJ71GWEejul7xcnMFMxQhuQgJbF8lHNsBrkgsOjl465KgexWVS2lO93bFh2CDWBbnJqFEL72l+IjHXSHklSKtj4=
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com (52.132.150.23) by
 MW2PR1501MB1977.namprd15.prod.outlook.com (52.132.149.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 00:50:09 +0000
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::70c1:f658:218f:9cfa]) by MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::70c1:f658:218f:9cfa%5]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 00:50:09 +0000
From:   Julia Kartseva <hex@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "md@linux.it" <md@linux.it>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>
Subject: Re: libbpf distro packaging
Thread-Topic: libbpf distro packaging
Thread-Index: AQHVUUC6mSeRtrJxpEmiNjup7x1PAKcGJtMAgAJfWYCAAG7xgIAEG0SAgAIlyQCAAQdFgIA0IB+AgAABjwCAA5IKAA==
Date:   Thu, 3 Oct 2019 00:50:08 +0000
Message-ID: <8B38D651-7F77-485F-A054-0519AF3A9243@fb.com>
References: <20190813122420.GB9349@krava>
 <CAEf4BzbG29eAL7gUV+Vyrrft4u4Ss8ZBC6RMixJL_CYOTQ+F2w@mail.gmail.com>
 <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
 <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com> <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava> <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava> <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava> <20190930111305.GE602@krava>
 <A273A3DB-C63E-488F-BB0C-B7B2AB6D99BE@fb.com>
In-Reply-To: <A273A3DB-C63E-488F-BB0C-B7B2AB6D99BE@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:69a8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df976983-13eb-47bd-bb71-08d7479ba3ee
x-ms-traffictypediagnostic: MW2PR1501MB1977:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB197774E86C7E45108F56E358C49F0@MW2PR1501MB1977.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(186003)(66446008)(6116002)(76116006)(66556008)(54906003)(14454004)(6916009)(316002)(7116003)(66946007)(64756008)(4744005)(5660300002)(3480700005)(7736002)(305945005)(2906002)(229853002)(81166006)(6486002)(86362001)(2616005)(476003)(486006)(25786009)(6306002)(6246003)(14444005)(66476007)(81156014)(8936002)(6512007)(256004)(11346002)(6436002)(99286004)(33656002)(71190400001)(71200400001)(76176011)(8676002)(966005)(36756003)(6506007)(46003)(4326008)(53546011)(102836004)(446003)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB1977;H:MW2PR1501MB2059.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: swItBT8AYcFQwfG2PSdN3JD5+ah86Qy4gG5CPAml9O6Njja4cSr5agNChyoW1tknNEvCYshMxqn74Au3Bk4dZCvNNI7uI6osmpsPAR4xZeJscdP7S6ASOovaQHRjgZdt6C5g9dgYcEdO2BTBKu3U6Ir2mDgAzl4tJXq8+gCu/boGLSeBijH9D4zQ61YWEJcV6NZYTr0SWFF5kPORtJPtpT4SGsPyG4R3VCsBfx+X29ebI7WjDB14BHmx7mlSn9svW4rgcwMGOIcfF52OEizQcP/vWd5xeT95yBNlRiosSHpR5oFd5vb3beWXXvoU8kSF9VmfeGQNaVc9jYhPVY228wpOSJ0eIj964KqoNCVAQwnP6yvjuFwkX1fAEjxjPjKTf5u8oKGmHqnu+2TrkpXgV7eAHxqgbPasyzc9ORqKuemjAdsWRERZclDBEgeSUCarNMrMbCNEU366HHUDD2tbWg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <324794386817F54EAB0EE658588BC282@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: df976983-13eb-47bd-bb71-08d7479ba3ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 00:50:09.0869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o3R+GGUewo/yMpAFbORrz15kA9O3lHC2DOvhqFdpUIgdL9ca3Vse2llTLVNDowfm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB1977
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_10:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=962 lowpriorityscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910030004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmlyaSwgDQoNCnYwLjAuNSBpcyBvdXQ6IFsxXSB3aGljaCBicmluZ3MgcXVlc3Rpb25zIHJl
Z2FyZGluZyBmdXJ0aGVyIG1haW50ZW5hbmNlIA0Kb2YgcnBtLiANCldobydsbCBtYWludGFpbiB0
aGUgbW9zdCByZWNlbnQgdmVyc2lvbiBvZiBycG0gdXAtdG8tZGF0ZT8gDQpBcmUgeW91IGxvb2tp
bmcgaW50byBtYWtpbmcgdGhlIHByb2NlZHVyZSBhdXRvbWF0ZWQgYW5kIGRvIHlvdSBuZWVkIGFu
eSANCmhlbHAgZnJvbSB0aGUgc2lkZSBvZiBsaWJicGYgZGV2cyBpZiBzbz8gSW4gcGFydGljdWxh
ciwgd2UgY2FuIGhhdmUgdGhlICouc3BlYyBmaWxlDQppbiBHSCBtaXJyb3Igc3luY2hyb25pemVk
IHdpdGggdGhlIG1vc3QgcmVjZW50IHRhZyBzbyB5b3UgY2FuIHRha2UgaXQgZnJvbSB0aGUgDQpt
aXJyb3IgYWxvbmcgd2l0aCB0YXJiYWxsLg0KVGhhbmtzISANCg0KWzFdIGh0dHBzOi8vZ2l0aHVi
LmNvbS9saWJicGYvbGliYnBmL3JlbGVhc2VzL3RhZy92MC4wLjUNCg0K77u/T24gOS8zMC8xOSwg
MTE6MTggQU0sICJKdWxpYSBLYXJ0c2V2YSIgPGhleEBmYi5jb20+IHdyb3RlOg0KDQo+IFRoYW5r
IHlvdSBKaXJpLCB0aGF0J3MgZ3JlYXQgbmV3cy4NCj4NCj4gPiBPbiA5LzMwLzE5LCA0OjEzIEFN
LCAiSmlyaSBPbHNhIiA8am9sc2FAcmVkaGF0LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBoZXlhLA0K
PiA+IEZZSSB3ZSBnb3QgaXQgdGhyb3VnaC4uIHRoZXJlJ3MgbGliYnBmLTAuMC4zIGF2YWlsYWJs
ZSBvbiBmZWRvcmEgMzAvMzEvMzINCj4gPiBJJ2xsIHVwZGF0ZSB0byAwLjAuNSB2ZXJzaW9uIGFz
IHNvb24gYXMgdGhlcmUncyB0aGUgdjAuMC41IHRhZyBhdmFpbGFibGUNCg0KDQoNCg==
