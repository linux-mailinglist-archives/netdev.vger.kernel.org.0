Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B6A1030C4
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfKTAcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:32:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15082 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727226AbfKTAcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:32:35 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAK0UfWo001806;
        Tue, 19 Nov 2019 16:32:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2MUhxlYe29kIITKiROIr5Or0Qafel8hR6Rp4P7dvU/8=;
 b=jwjYBYzgTq7TepFnRi+00RPTPsiPMkOQ7SuTmypejnvCefhF0Tdy0dBAfjLoQopXas6/
 WHNJizwwzX5Rnh3xda5yEatrzoPmtWQ/lXZNW10imt3trRy0XDQ3sIxqo4ulvsLmK0fw
 DMDLSUp5hsbtzzabv9FOcOeUDje6cE8n8zM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wcnrv1mvk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 19 Nov 2019 16:32:19 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 19 Nov 2019 16:32:18 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 19 Nov 2019 16:32:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMpZoRzwztfQdIsdBn/qZ7WgaqSHUGchNQ5QL3O2kkp8+NBXI/Yyd8sId/7eSM90W4Ay6zPjql07Vbh2tKNoaM+g9I64pqYoFSwDOriZAP4VYEYeICNviwiXhsqhJQzINkBiQ7J/3eZgCaEPzsXXP8NPRSE2kFj5/uAxLy5ZkTg9KlI5ggRE32EZl0ECHPymqoKGDKr6qVykshVg1TLf5LcKgS5tQhv0x7CBY3iGCTVuyA+yeSdxfTwpri+EYeY1dCieE1WsjnkTHRBYwlfseyeUCvE3G6D5ohnMXt2gcOj1w3HO1gk/ybRCzF4KCap+9or/YD9VuAnzbtSw+wbYIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MUhxlYe29kIITKiROIr5Or0Qafel8hR6Rp4P7dvU/8=;
 b=jbuk3i3oQjmpxmoyYkaQWUFc+q0VML4jXuHg16dvYPDWvy8MZlVs905Qzk1YQqXXwMYWtqF3KyC5NbuhDkzRWAV8mFa+gfOFRLqK/xNeqoFBW1NyYtIM21JlFryuCEybx+1TDNXorzjMlGzpq/hKF3eEvmpP6nJqUYuca5bu3OjF5cSkBH/CGYVZA2XONQ59mSW7JM7aWXCp8NwAJYvIwOowmXfwB6T3jOcWyhegGdOgEV42VDBdFaNATnKCbjvhon6pI8+9Aqp7HkK3oyHKCiAVsucF/Gj0I0l3Fis17gUGz1+a5AcQhddF8+qIwXdkd6ClIKvN2tHVeJ26J1fB8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MUhxlYe29kIITKiROIr5Or0Qafel8hR6Rp4P7dvU/8=;
 b=MVaTmcXiy0thmIsV0kKgsxAfzslHjc5U83I8Lt2/syXwvvfo9bCP6rAZkuOa44KPBs5HlM7IrTaoDlLhDKXloh684GymHpAzpo447h+YZO23TSXsSKjDsJhlhus/lEiOEV143zuKlwAzRAa0e5ylunR/gm62V0oTfTpiCBBnoCI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2551.namprd15.prod.outlook.com (20.179.155.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Wed, 20 Nov 2019 00:32:17 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680%4]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 00:32:17 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: enforce no-ALU32 for
 test_progs-no_alu32
Thread-Topic: [PATCH bpf-next] selftests/bpf: enforce no-ALU32 for
 test_progs-no_alu32
Thread-Index: AQHVnzkGTrRJWbdUC02GiMlVWPII1qeTNXYA
Date:   Wed, 20 Nov 2019 00:32:17 +0000
Message-ID: <7317c35c-d8f2-25d4-d40d-6d27b99a1c6e@fb.com>
References: <20191120002510.4130605-1-andriin@fb.com>
In-Reply-To: <20191120002510.4130605-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:300:129::14) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:f173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47042013-d760-4873-61a9-08d76d5118c6
x-ms-traffictypediagnostic: BYAPR15MB2551:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2551485ED2D9FD5E1166F841D34F0@BYAPR15MB2551.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(66476007)(66556008)(64756008)(52116002)(110136005)(386003)(6506007)(53546011)(2501003)(14454004)(81156014)(81166006)(8676002)(316002)(76176011)(54906003)(186003)(478600001)(8936002)(36756003)(46003)(446003)(11346002)(5660300002)(2616005)(476003)(486006)(31696002)(305945005)(71190400001)(6116002)(71200400001)(6436002)(31686004)(99286004)(102836004)(4744005)(7736002)(6246003)(6486002)(6512007)(86362001)(4326008)(229853002)(256004)(2201001)(25786009)(2906002)(66446008)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2551;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sy5mk8alKOkaBoJBjRs0EMWkC3lp/pw5177S+HesMlWKaeqrGcmX/hlvdVnV0wILeBAexO2tg0S1MgfleS9wSdiNFqs8JgsF5alyFc2wSBb0vlCzsXTaY0EPHmI7+4DwVBfmKlb2vJ+527h0p1X8+Z0uB+NDsWzQEHcs1hrvA96CXo9BTzYQW+i1m129PPgNwxJ3AYdJdLIW/iuGMIZYQTQHVBk7O69nuDtfMt8R4TkFK6iAka5zB8tW1fJNqgcyVHWgflkVa+awRaMD4LJFH0omLimAMHBb4r6HgDuSdK8KuvBm6VLXTWFn9cq7rUf2TyGjuN6maxSJzPYow5HrSQJeoPtV+AoFpaL8QfdVT96z6jnJ993qPSQOz6Y4dh1O4EGBJBL08wHYodHDG6HrrLwvTd3MCUkqq1yAZ2E62r5Kk8N6gYFUvUDXUM1r7Ch5
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CB4B88E0D47F141A8D61FF26137D713@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 47042013-d760-4873-61a9-08d76d5118c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 00:32:17.5575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6bhHp0osCuvOYCfamodkgMMfI1wk7RMev+YUdhDBmBIHrnqonlPW0iU86k5yMhb3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2551
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_08:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 mlxlogscore=861 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911200003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzE5LzE5IDQ6MjUgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gV2l0aCB0
aGUgbW9zdCByZWNlbnQgQ2xhbmcsIGFsdTMyIGlzIGVuYWJsZWQgYnkgZGVmYXVsdCBpZiAtbWNw
dT1wcm9iZSBvcg0KPiAtbWNwdT12MyBpcyBzcGVjaWZpZWQuIFVzZSBhIHNlcGFyYXRlIGJ1aWxk
IHJ1bGUgd2l0aCAtbWNwdT12MiB0byBlbmZvcmNlIG5vDQoNCkEgbGl0dGxlIGJpdCBjbGFyaWZp
Y2F0aW9uIC1tY3B1PXByb2JlIG1heSBub3QgZW5hYmxlIGFsdTMyIGZvciBvbGQgDQprZXJuZWxz
LiBhbHUzMiBlbmFibGVkIHdpdGggLW1jcHU9cHJvYmUgb25seSBpZiBrZXJuZWwgc3VwcG9ydHMg
am1wMzIsIA0Kd2hpY2ggaXMgbWVyZ2VkIGluIEphbnVhcnkgdGhpcyB5ZWFyLg0KDQo+IEFMVTMy
IG1vZGUuDQo+IA0KPiBTdWdnZXN0ZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQoNCldpdGgg
dGhlIGFib3ZlIG5pdCwNCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0K
