Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB49BC8E56
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfJBQ1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:27:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34372 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbfJBQ1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:27:00 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x92G8JAQ006699;
        Wed, 2 Oct 2019 09:26:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=bpw8S45wcvbqvRzBs3ASJ5GiFm/qvxUakFHbmsDpbo8=;
 b=EHDFb7LwRefY7zNOgT9dW3CZLLAEqaQVkadllQPt0g34m73ceW4C0hcrkJ0VzMKnlbXU
 I1wPajXxkUpyzRxuEFTJojFhuZ5Nm2SZZ8YOdUxYFYIAAyolzuwv8g5+XG9nASwuQ0HB
 rxJE5nb9qrYybxGwNpRSUmZZOqE/tPI82fQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vc9fw5uts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Oct 2019 09:26:42 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 2 Oct 2019 09:26:41 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 2 Oct 2019 09:26:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZX2Q55lAO6OVRR2m0O3nTQ1x5xi1PiEx5KdHyfaGuIuGeQ1Jl0U16+S25Z5hLImcJRYg5jEUk54vpqAYvFoO0hZlucKYlcYKG92TdzpD7bnKkP1skeTvmVnEaUFoFOf0OsEfU8CjMes5xArGqIJbTAW+FohIYbyPcKffXy0ulQ8mdB6rDwBeWhsZebp+A9OdMUtd1uUL9/0H+w9bSmc90NiRGNGz/nmUMdZi5n/4iPuJ1inb3r5ZG9zoId3V3ZA84g368/XCwtUywlv7Iwr6zeFLDYVZPv7Qs3GWQvti1X+nG+2iXhsy/gf0HKmSkkujkddau9eCN01izS4cGermrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpw8S45wcvbqvRzBs3ASJ5GiFm/qvxUakFHbmsDpbo8=;
 b=DsqdZwZze4ORpNObfpbb63/iUMbNJHdE9wgCa+IAcPGic0hdXp9m8J5BTv1E2DEBFTcReIZX3ixexiRUzteVoIS2q104nCD49oLc90CFKRAs+lOpCnIzvo/6sHVyeCAuK+brRKGwfC1P5HB9szNMJlJFcMBQBAxp7DizU5Kc7N+Lx784jQhDfosJv9ct1JMUxEriVAS5VAxcznatwQsa87ZKQ824/NkUyqFqF+bSYo99fI0CFKva8HNeoGuMNcqF3CX4EfxGv7XR1B/ZtY7di9TsRPlw3LqXJBKv4nP5K03jyraONUdKXAqt/kJcPJrbS/PjYyzTC5dBobvL+CyvtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpw8S45wcvbqvRzBs3ASJ5GiFm/qvxUakFHbmsDpbo8=;
 b=Mjnc5GyTaTbPDZJYi9dpVQB0DSgMK0XPqx1fI2k4/+Hr+u3BTlYUqxpHqA60vrEfmDpxijBUyh62CRxP6NAiNSKsXoUKLDX54pU38CGhnNmNrdn8QrIfO6u1Y4DIce7p5EXYtu7IBui7NT6tHwSCNimd+ZNVa2fwnm7mDsPxy94=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1294.namprd15.prod.outlook.com (10.175.3.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.18; Wed, 2 Oct 2019 16:26:22 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.022; Wed, 2 Oct 2019
 16:26:22 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: add static to
 enable_all_controllers()
Thread-Topic: [PATCH bpf-next 1/2] selftests/bpf: add static to
 enable_all_controllers()
Thread-Index: AQHVeRmF75sgM0OJZ0udbRpVnDjTHadHig2A
Date:   Wed, 2 Oct 2019 16:26:22 +0000
Message-ID: <6BEEC14C-6F9D-44AE-91C9-AE04FE39D29F@fb.com>
References: <20191002120404.26962-1-ivan.khoronzhuk@linaro.org>
 <20191002120404.26962-2-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20191002120404.26962-2-ivan.khoronzhuk@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::2338]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a27a23d8-7939-4725-1609-08d7475543ab
x-ms-traffictypediagnostic: MWHPR15MB1294:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB12940FE4B38218B7E680301BB39C0@MWHPR15MB1294.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:359;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(396003)(136003)(39860400002)(189003)(199004)(316002)(54906003)(186003)(446003)(2906002)(6486002)(81156014)(81166006)(50226002)(476003)(11346002)(8676002)(486006)(8936002)(46003)(6506007)(256004)(14444005)(229853002)(102836004)(86362001)(53546011)(25786009)(6436002)(76176011)(71200400001)(71190400001)(33656002)(4326008)(76116006)(4744005)(7736002)(6512007)(6916009)(2616005)(14454004)(99286004)(478600001)(6246003)(6116002)(5660300002)(66446008)(36756003)(305945005)(66946007)(64756008)(66556008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1294;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: phUrxxrJu1Gcq0K8ZaKGiFeOakt7yQz4iz84DoAkGNpAglaSFeooI12snpXv9eNJAww6tgLuErgg1fUnR48grX5u7g9epzyou9y0B5KiRgFbq+gtfOTvMVtNa6Zs3XpyK8xqkQafE0wr7Fcb3B7HkMeenDqxUe1eCyMiO2IsPZIV8jEp1ATu0Gfb06q6+/x6sl4RaqHAhpfgucBfrVYakViUJd9/Tm6LfutwturVxc9uaGHTx9GBPrqpo6oAxvww9wL2WTUEwyrQY+VqrVRtbaMep2wolK4qXDaxYJouHgUwOhJK68JhJoASStYKqGN94WXN4gsnnbPGDqlrVBaZHNwXXgXM7KU5fpqLJlYZ8cY9h5FSNO7VAcwdp0v+aNH8CjHYiCO1JmzHklzQaIq6Y7jVXkuR0h2W22LcqQLFMsg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B5740A93705E54DAFAFB4BE14929D7B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a27a23d8-7939-4725-1609-08d7475543ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 16:26:22.6753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1BylASdekPzQfFmnDtqRbm36+zCCI6ncvaLwTYgQFGOOxaN3gTefNfas3yDQ8fAfR+Hce9wqDqc4CQoobC4t5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1294
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_07:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1011 adultscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910020142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gT2N0IDIsIDIwMTksIGF0IDU6MDQgQU0sIEl2YW4gS2hvcm9uemh1ayA8aXZhbi5r
aG9yb256aHVrQGxpbmFyby5vcmc+IHdyb3RlOg0KPiANCj4gQWRkIHN0YXRpYyB0byBlbmFibGVf
YWxsX2NvbnRyb2xsZXJzKCkgdG8gZ2V0IHJpZCBmcm9tIGFubm95aW5nIHdhcm46DQo+IA0KPiBz
YW1wbGVzL2JwZi8uLi8uLi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvY2dyb3VwX2hlbHBl
cnMuYzo0NDo1Og0KPiB3YXJuaW5nOiBubyBwcmV2aW91cyBwcm90b3R5cGUgZm9yIOKAmGVuYWJs
ZV9hbGxfY29udHJvbGxlcnPigJkNCj4gWy1XbWlzc2luZy1wcm90b3R5cGVzXQ0KPiBpbnQgZW5h
YmxlX2FsbF9jb250cm9sbGVycyhjaGFyICpjZ3JvdXBfcGF0aCkNCj4gDQo+IHdoaWxlIHNhbXBs
ZXMvYnBmIGJ1aWxkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSXZhbiBLaG9yb256aHVrIDxpdmFu
Lmtob3JvbnpodWtAbGluYXJvLm9yZz4NCg0KQWNrZWQtYnk6IFNvbmcgTGl1IDxzb25nbGl1YnJh
dmluZ0BmYi5jb20+IA0KDQo=
