Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45E2CBD65
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389191AbfJDOgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:36:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12672 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388975AbfJDOgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:36:22 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x94ES6FI019422;
        Fri, 4 Oct 2019 07:36:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=N3fSZswKyTJrTD/5aciNuxOxSJGny2fSwZOPrxsfY+8=;
 b=nKoCwqgWAGQ+3bwzqQWgh4qgj9A1ntkAzni8dABwB9pz7wh9/QQG8S4LM79y85lh7Ea/
 3a7qQfFDQIZt/71xMuKLAtDusIgsvZaFS0OoA7yCHSWHt0z+GjOdMOjooAdpqqtqNH68
 ooavtGbcUdYc21fmbGa7jjCR8nYmIehGlFI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vds1fka8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Oct 2019 07:36:08 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 4 Oct 2019 07:36:07 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 4 Oct 2019 07:36:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCvVCMbnS1ofF6dS0E/oL1bFosVRDckwaeipMNlPY6v/i5NJDKfUCP8zsala65xo7hEKeDJR5l+YYO+LwmsxBtUFQYYfXpCcE9Fapr9fFzwbgdctrdUOiTgm4idwJU0g71b0WbP+N+LSWlvKTBIZP2oWMppbxuuWsv1W+aAg6nSPKDhqxW9EUCACcjkZyi1Xu/mKyxWzqDGdlIL4C5M94DdDjzjPUJ6z5NCDgvP8Sw73AlSIur0WwEUdrQxEtts+m1LsIiklcJ8k7XA5z0qQIW6RXDJb1HwwvBclM0/i/NR4n6jKK8aGNrz2igMbSrx+jnoq8RhbUUa/0L3M9/CMSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3fSZswKyTJrTD/5aciNuxOxSJGny2fSwZOPrxsfY+8=;
 b=H9d6tUS1QR2OfI61jt3jfKRn5rvq8hA1PQRMWn6yxhLKWvBMYrnE8U7wUmiDjdAEFCCcpWN43BI1xpTOSeZYwzrshAaSQUVBTpkNKUEi2fI92lIuffunn+pTMqMkT0jmKA1kBZtjJ9X+fmAxgr2SdubDcAc8k1+vL4t28pX0qtR4ns4/S4bqPesIEge6sASoTKwY4KBScCnLHFw8lJDpkOeb5E7zCfcenFxjmHS+Lb1Zyu+LxIYLbwrqBKx/oSY5beCFytXe/FBlsNY94nK3fZ4sdi60zhqqn5wdlvfg4l/m+qfGWVxCLNcinZZjDrgeYDrbn7G9UABpho6xzn+fHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3fSZswKyTJrTD/5aciNuxOxSJGny2fSwZOPrxsfY+8=;
 b=N/k5uK37Y7a9j1ucTmJrL2Ok1OncyQZVRCHqq5k94HHyonlEuyGiP0h+IkKA87FJ8Fh7W41oLO7kRGxNad9jjm0NfAKVtVVGEeJn04wW7I4tE9xC9GHTfvLOiqmf2zlJUOw/tH88pb018ttIf3+h230gxCOUjZ8a932QQHupAfg=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2200.namprd15.prod.outlook.com (52.135.196.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Fri, 4 Oct 2019 14:36:06 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2305.023; Fri, 4 Oct 2019
 14:36:04 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: stop enforcing kern_version,
 populate it for users
Thread-Topic: [PATCH bpf-next 1/2] libbpf: stop enforcing kern_version,
 populate it for users
Thread-Index: AQHVel/8IctEDblBkkOJkNb5Sc/hWKdKhMEAgAAHsQCAAADkgA==
Date:   Fri, 4 Oct 2019 14:36:04 +0000
Message-ID: <fb67f98a-08b4-3184-22f8-7d3fb91c9515@fb.com>
References: <20191004030058.2248514-1-andriin@fb.com>
 <20191004030058.2248514-2-andriin@fb.com>
 <5d97519e9e7f3_4e6d2b183260e5bcbf@john-XPS-13-9370.notmuch>
 <CAEf4BzbP=k72O2UXA=Om+Gv1Laj+Ya4QaTNKy7AVkMze6GqLEw@mail.gmail.com>
In-Reply-To: <CAEf4BzbP=k72O2UXA=Om+Gv1Laj+Ya4QaTNKy7AVkMze6GqLEw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0058.namprd04.prod.outlook.com
 (2603:10b6:102:1::26) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2b76]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce11e032-7d3a-49fa-9785-08d748d82f8b
x-ms-traffictypediagnostic: BYAPR15MB2200:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2200A22BA0C850F082A0A07FD79E0@BYAPR15MB2200.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(396003)(39860400002)(346002)(189003)(199004)(305945005)(446003)(46003)(476003)(11346002)(486006)(6486002)(54906003)(186003)(2616005)(2906002)(4326008)(5660300002)(14454004)(386003)(102836004)(71200400001)(6246003)(53546011)(6506007)(478600001)(81156014)(81166006)(71190400001)(8936002)(110136005)(316002)(14444005)(6436002)(6116002)(36756003)(52116002)(7736002)(256004)(86362001)(66946007)(4744005)(66476007)(31696002)(8676002)(66556008)(76176011)(6512007)(31686004)(99286004)(64756008)(66446008)(229853002)(25786009)(19860200003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2200;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l++YEjKkppoj6BSe9PdVhWgMJa5sDYwoUTzS+FBFjVWFlTAbPPFA0muwKhzxnh2KA5kuBAif6p1Uqo/f4qce+XnTIVeURUSYpzfEIq7853PF2PE7Oe3b4ferfs1oWo4DmmOtUIRhb1aRg7+hXmuRpbIfl7iSECVYoY/DZaTsGpx/qstc6phCmK1vsqP5lDAQ0yuAM1EBvLw/3iyGeZn3AIfW8DPn/2NWUOuw7k/FzUlEMl7JtU1Gtv9KfoqStXBVrCrefZ7cU+uPvAjSqvQYmbVnRiC9g5qnyBr5TaJTIewVwFrUikpYpWsKWuY8sCFY1dhApJ0u3q9mAR5YISc+qKdLXFkWpUkDRrM43B8ezz9vGm0dNmQ/9u2xgkNLSTbIzGvbM+mkNvnvdzrpimviAVsXxEYxMuDYmoJ6m80eciw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4145DE03C72E347B4A14D9524BFD570@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ce11e032-7d3a-49fa-9785-08d748d82f8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 14:36:04.6446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6bSKwhY+qWLjg5w+Ci8bJIIS5ZMtZH5qMBLaz5SIsZWfLXmoS6zvbpRFITla7ukw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_07:2019-10-03,2019-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 clxscore=1011 suspectscore=0 spamscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910040134
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvNC8xOSA3OjMyIEFNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+PiBJZiB3ZSBhcmUg
bm90IGdvaW5nIHRvIHZhbGlkYXRlIHRoZSBzZWN0aW9uIHNob3VsZCB3ZSBhbHNvIHNraXAgY29s
bGVjdCdpbmcgaXQ/DQo+IFdlbGwsIGlmIHVzZXIgc3VwcGxpZWQgdmVyc2lvbiwgd2Ugd2lsbCBw
YXJzZSBhbmQgdXNlIGl0IHRvIG92ZXJyaWRlDQo+IG91dCBwcmVwb3B1bGF0ZWQgb25lLCBzbyBp
biB0aGF0IHNlbnNlIHdlIGRvIGhhdmUgdmFsaWRhdGlvbi4NCj4gDQo+IEJ1dCBJIHRoaW5rIGl0
J3MgZmluZSBqdXN0IHRvIGRyb3AgaXQgYWx0b2dldGhlci4gV2lsbCBkbyBpbiB2My4NCj4gDQoN
CndoYXQgYWJvdXQgb2xkZXIga2VybmVsIHRoYXQgc3RpbGwgZW5mb3JjZSBpdD8NCk1heSBiZSBw
b3B1bGF0ZSBpdCBpbiBicGZfYXR0ciB3aGlsZSBsb2FkaW5nLCBidXQNCmRvbid0IGNoZWNrIGl0
IGluIGVsZiBmcm9tIGxpYmJwZj8NCg==
