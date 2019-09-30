Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAE9C2556
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732341AbfI3QnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:43:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20492 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732183AbfI3QnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:43:09 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8UGdxJ9002034;
        Mon, 30 Sep 2019 09:42:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WT4Oz61/teIj78A8uBjYof18cNfXGMSI4z7v5dYwLZk=;
 b=YM06mCE8hlOLrw2/eYeZjDY/qU16fq8mAneMH7XqlrnHLdGMUEVTES9r4wEJqBd8U5Kq
 0IY/28I9ykOMnA3l7SvqqP10H6+3BFj50tvLFy9S6xYV+mwEkxbdRYwUAY3l6Jy6z169
 LXqikR9g87jKh0wopLjA/wXF91miBKBa8Ww= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2va310srws-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Sep 2019 09:42:51 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 09:42:51 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 09:42:50 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Sep 2019 09:42:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFErJtmdR7fkuvoKXk7GCbau7YNClL0SrXy/+hNZt/qLJ71q56/jN4Z5WgWNqoTsP7ixbx9L7hqy6l4ZRQXt2ot3Ib7j/EbTVsj9WqJIROCXVRwW0E/6u5878s2NjcVsYXBqxe1K6+r8a5kZGKlJtXDmbWx1NXp0ALbaUpNeqCpnqmF6zHaRrX/XCwapJtPcU7NCthA4VjB9p9jeDvydIeQ9CLeMVF7Onwj5Puqf7zvOZ8XHvzUs6rkRPeEm1/DhzgF5jUD7oeKli+bhYH8WoZ2T73IFabr0jtRdqUxulfOoj0TohPqKZiXB76+jHxDo8QbiYrTQrZQXbY5Hba3xBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT4Oz61/teIj78A8uBjYof18cNfXGMSI4z7v5dYwLZk=;
 b=m3AGh0mrLezFVegd6XaB7CoarkwMbu/zEytRE7RGI/VPbx4WftgCQCQUyeb20LuLpmBRdgNhv3JPI7/FoOpAMU9Uh/BKiu6WyGBwpb1BGQKIZ3ddrRrNOvrmXKfNxNNyCiPDU9iwZ+sFEWy8riKgeJ26IYJRY9OZ5Xz5NxP3XeE5IkOB327ItiTfQ54EHeAqOOPedNe7Y/z/O6rBqMFITJAfH6X1wt8JKzRG2rJMQCjcnGYmR8peyxalP3bkrOCYdORlyfR2ljIKrW0ieCzDJCdr8neB+mwPb0vX+u/RSgVfVDd0KNVzZsKcq310ypQy2tZe+SezhcH63iG+z5FXOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT4Oz61/teIj78A8uBjYof18cNfXGMSI4z7v5dYwLZk=;
 b=WDRy1QIK4EieJRi/J20kt1IMS8kSavcbXNw3U/df3fMCnxAD4+djZ6ptpuriW4upIIbFjhGTwvNAi7/1PVUABm2G7Q0r3zV7VLsVzj2+m/76Loo9dgDGJChSnPvbZc4s3+sDX6Iqz3nR8V6Ou1mYNi3LkStO7MQV4bfWdLG+V5Q=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3061.namprd15.prod.outlook.com (20.178.238.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Mon, 30 Sep 2019 16:42:48 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 16:42:48 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Kevin Laatz <kevin.laatz@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf v3] libbpf: handle symbol versioning properly for
 libbpf.a
Thread-Topic: [PATCH bpf v3] libbpf: handle symbol versioning properly for
 libbpf.a
Thread-Index: AQHVd6xB7FHrP/dEpUWrsxPulh60AKdEbNQA
Date:   Mon, 30 Sep 2019 16:42:48 +0000
Message-ID: <b23d1e1f-6912-33eb-e7d7-c1e47015cb4c@fb.com>
References: <20190930162922.2169975-1-yhs@fb.com>
In-Reply-To: <20190930162922.2169975-1-yhs@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0031.namprd21.prod.outlook.com
 (2603:10b6:300:129::17) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::c799]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86f3b49c-224b-471b-bd7e-08d745c53a34
x-ms-traffictypediagnostic: BYAPR15MB3061:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB306164D0E89EF3E8F5813C55D7820@BYAPR15MB3061.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(366004)(396003)(346002)(39860400002)(189003)(199004)(102836004)(31686004)(486006)(6436002)(2616005)(76176011)(316002)(66476007)(11346002)(6506007)(386003)(53546011)(99286004)(6486002)(446003)(229853002)(4326008)(478600001)(66446008)(64756008)(2501003)(6116002)(66946007)(66556008)(186003)(2201001)(86362001)(256004)(46003)(476003)(31696002)(52116002)(8936002)(2906002)(6246003)(71200400001)(7736002)(5660300002)(54906003)(36756003)(14454004)(71190400001)(305945005)(81156014)(81166006)(4744005)(25786009)(110136005)(6512007)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3061;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jXJwymVE1JBQgF0btliZJO19G+vHxTzMeAbgSk7L8F4NoOYZVDiuhmz9/xlGJN1c1viQlwmn8Nwvl83T+fiGxFXPopjOHQsQaUDKy0xt0CIJkoVb2atFd7gb2Ipzt9Ie7le88oO6/Y9Rig4Jvg8iDdRLA+dQtvRbBbB5O+Djtyzr8bUXcpgq10aUdn8GqMkHbVZhDOg7s3jKWRiCYofd/v9xb9F0k2ekHbplEDeFtSnp+6kzAi1bAHTNKQN1KV8DB7oV5sACbPsaY0lUCuuEnhjFxXWpNhgSN+QpfAW0ayLPb8hx1EeEqSDRVaNoANuvqj+cdEtw7VGMk6bnBmwsNAyLY8xl4wT71F3PJNjkjxnIeNkyl5jlluLpXci8Hiph7FSgrR+OieJpoEE5x2Yuxg1W4HqxI3tGSkxAG97qRtg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65BEF0B294FD1A429C9064359DE0E07D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f3b49c-224b-471b-bd7e-08d745c53a34
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 16:42:48.5782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PXKZcqE635FuqyJBdQAOpdnidHXsh496JAisFViEACh18BCnc1RXycv5pAIdF+Tq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3061
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_10:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=857 malwarescore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1011
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8zMC8xOSA5OjI5IEFNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPiArT0xEX1ZFUlNJT04o
eHNrX3VtZW1fX2NyZWF0ZV92MF8wXzIsIHhza191bWVtX19jcmVhdGUsIExJQkJQRl8wLjAuMikN
Cj4gK05FV19WRVJTSU9OKHhza191bWVtX19jcmVhdGVfdjBfMF80LCB4c2tfdW1lbV9fY3JlYXRl
LCBMSUJCUEZfMC4wLjQpDQoNCmhvdyB0aGlzIHdpbGwgbG9vayB3aGVuIHlldCBhbm90aGVyIHZl
cnNpb24gb2YgdGhpcyBmdW5jdGlvbiBpcyANCmludHJvZHVjZWQsIHNheSBpbiAwLjAuNiA/DQoN
Ck9MRF9WRVJTSU9OKHhza191bWVtX19jcmVhdGVfdjBfMF8yLCB4c2tfdW1lbV9fY3JlYXRlLCBM
SUJCUEZfMC4wLjIpDQpPTERfVkVSU0lPTih4c2tfdW1lbV9fY3JlYXRlX3YwXzBfNCwgeHNrX3Vt
ZW1fX2NyZWF0ZSwgTElCQlBGXzAuMC40KQ0KTkVXX1ZFUlNJT04oeHNrX3VtZW1fX2NyZWF0ZV92
MF8wXzYsIHhza191bWVtX19jcmVhdGUsIExJQkJQRl8wLjAuNikNCg0KMC4wLjQgd2lsbCBiZSBy
ZW5hbWVkIHRvIE9MRF8gYW5kIHRoZSBsYXRlc3QgYWRkaXRpb24gTkVXXyA/DQpUaGUgbWFjcm8g
bmFtZSBmZWVscyBhIGJpdCBjb25mdXNpbmcuIE1heSBiZSBpbnN0ZWFkIG9mIE5FV18NCmNhbGwg
aXQgQ1VSUkVOVF8gPyBvciBERUZBVUxUXyA/DQpORVdfIHdpbGwgYmVjb21lIG5vdCBzbyAnbmV3
JyBmZXcgbW9udGhzIGZyb20gbm93Lg0K
