Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B285DC2973
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbfI3W0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:26:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18538 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbfI3W0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:26:07 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8UMHs49026472;
        Mon, 30 Sep 2019 15:25:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mK+Dx0Lp/SlpwkyWqNcwPOyNTPQRpp46wTHwXGzuaVY=;
 b=J6A3BfIsMrktrBV6TS5Rov6vlfTTMxQwkBUSMb092G9zTteIDmywcIOkX+AhN1bVbvD/
 rhPsL3IWk0Qc5NuRTJjvgOq2Dbk52adUAL6LM08l5gLamYMAzMg1o/5dXtSwgHVLrcuA
 WcQUZDJLPbUmvlAtLrLudheonFW1IQF1AFY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vaqu67rt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 Sep 2019 15:25:52 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Sep 2019 15:25:51 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Sep 2019 15:25:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T84XvV3pj95N1c2B6+Xv/O8ntZDLql9Ef8Sz+qSrAx2U1Ze5KghZmweAfGYk4vU4JHBryvko5csz2nVOXoUeSENOVIUy8TLgYmHr8uPpaFDt68l9Z9NEpdZtmmERI75sUwTwlF9zDrklnbEOIKiY17VE48Py/2isqqoVVG97V6parkV4WptRrBJxiUZnJ72iZJKgBU2m7gRuUOjYfYi5tXo0aCLd31vuqrxQ+1A+BWfxLSFIzVTdAB1vY3Th6e4wlup2GI/Nn2ZeCWT+oai25yUsqo/BVw1k1Vw6XHRN9dhQ7xM/a8Cs9V0hSEaefiwiHCSEY/ftGi8Sh20d8QuKtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mK+Dx0Lp/SlpwkyWqNcwPOyNTPQRpp46wTHwXGzuaVY=;
 b=T64L4aLySDSWXmROfH1C4taCjZJP1BlsRYZ1mg0LzPX2KJ15vl58nLANz/i6vjLMI8EkmpiJgw4ZQbLQSxEn6UMY0R2q8eg+m9RZZu1qb9pSf1truCyObZEN0nLo+iVvdZ8xTVAX608teVSubn0XHgZX2rhS3QbzQ9F+CHA0cAkjsXvXSxNzSmhAnML9GPrGRDPn6MPPseFo/BEGtN2Kw7MPJPjQ+FuxkfL6w2zvRUyvWFkaQQz2qYHErfC176AqbafQTvUP/fxs0heZhsri3e2VrwpRBBAMGlwFNlHyJkD6nQ7cBApMJW943fPuw8iSQFGqHUsiHHSjzWohxWjJNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mK+Dx0Lp/SlpwkyWqNcwPOyNTPQRpp46wTHwXGzuaVY=;
 b=C+t2PX05hZ/ubXo+v+vnejWrkqeZA0oYFNydcw0cgdAa1wpGQDpWgpJxXZVMx2IkvbaZDhXKNFjcHp7YnxLOspowgoDfCVEhqUjgE1Xr4Y2rDnpXAkW/s/faejzcgtDFfpMOCtj7Fj5OHZ6oC0Y2rIGdyHesPjFnJ0aEwVNHpJM=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1239.namprd15.prod.outlook.com (10.172.181.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 22:25:50 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9%4]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 22:25:50 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: dump current version to v0.0.6
Thread-Topic: [PATCH bpf-next] libbpf: dump current version to v0.0.6
Thread-Index: AQHVd9y3XRi8JkGM2kSAtvxGnAAppqdEy0GAgAABCIA=
Date:   Mon, 30 Sep 2019 22:25:50 +0000
Message-ID: <fb971745-94ac-0cfd-eb5c-ab5128ef943c@fb.com>
References: <20190930221604.491942-1-andriin@fb.com>
 <E24A08DB-FAF5-4FB9-BB96-4B76E8CCF807@fb.com>
In-Reply-To: <E24A08DB-FAF5-4FB9-BB96-4B76E8CCF807@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0183.namprd04.prod.outlook.com
 (2603:10b6:104:5::13) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:4602]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4b0a6bb-a0fa-43aa-53a7-08d745f525b5
x-ms-traffictypediagnostic: CY4PR15MB1239:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1239FF5C80E4D1523E7B9662C6820@CY4PR15MB1239.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(346002)(396003)(366004)(189003)(199004)(66446008)(64756008)(14454004)(8936002)(71200400001)(71190400001)(65956001)(5660300002)(478600001)(4744005)(65806001)(6506007)(53546011)(386003)(81166006)(99286004)(102836004)(81156014)(486006)(8676002)(66946007)(76176011)(66556008)(52116002)(476003)(66476007)(256004)(11346002)(46003)(446003)(2616005)(186003)(31686004)(316002)(54906003)(6862004)(37006003)(6116002)(6486002)(6436002)(58126008)(4326008)(36756003)(31696002)(86362001)(6636002)(229853002)(6512007)(305945005)(25786009)(7736002)(2906002)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1239;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: saEOVT9EI8mpUnIuzASqLdIKL8zt5VBmCGR2DE/ytmu+wfggcpTftzFXdU7F3qXAm4FO6v7BMOOm/YZ+mKWPidxW7WQPaS8mgSoz/XQYeQR4RlNfRK0JCpJ0iFq5S6KoF77X+eUxX8j0/plU0SY8x5naUzW+m47IDYW5Nqjkpr/xHMBaXSOJw/vtSX+nBBO9OIB6tx2J2M0ql/0JTWWPNVYgE2jedtgwI+0CWF6MxiC6ILrmrvWsbza5Ix/6rU6BVosJb/Wwzq1A98XJiGxU/fH0CWOxX+L3u/YoODUgVETAgfsA4evsEO87H9Q9v55dy3svAwgDEl2W7dulKZf7ohjHFmwfW6roYVxasXIquhpuXlBpHwlpDDzDgboRjlxKAeoi8PIMu83umWopYYWRvezznHRPWsPIbPkaYfTpbgU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5FCA0AE0C3491447BD500F55C90450BF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b0a6bb-a0fa-43aa-53a7-08d745f525b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 22:25:50.0927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mpq/EpTkhJH0eJCLkzjBQIwDBCSlDOEoz3OUnJLpJYDOJmRpxOnwkH87lLDKg+jb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1239
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_12:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300184
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8zMC8xOSAzOjIyIFBNLCBTb25nIExpdSB3cm90ZToNCj4gDQo+IA0KPj4gT24gU2VwIDMw
LCAyMDE5LCBhdCAzOjE2IFBNLCBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPiB3cm90
ZToNCj4+DQo+PiBOZXcgcmVsZWFzZSBjeWNsZSBzdGFydGVkLCBsZXQncyBidW1wIHRvIHYwLjAu
NiBwcm9hY3RpdmVseS4NCj4gDQo+IG5pdDogVHlwbyAiZHVtcCIgaW4gc3ViamVjdC4NCg0KRG9o
Li4uIGJlY2F1c2UgZXZlbiB0cml2aWFsIHBhdGNoZXMgY2FuIGJlIHNjcmV3ZWQgdXAgOikgVGhh
bmtzIQ0KDQpTZW50IHYyLg0KDQo+IA0KPiBBY2tlZC1ieTogU29uZyBMaXUgPHNvbmdsaXVicmF2
aW5nQGZiLmNvbT4NCj4gDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxh
bmRyaWluQGZiLmNvbT4NCj4+IC0tLQ0KPj4gdG9vbHMvbGliL2JwZi9saWJicGYubWFwIHwgMyAr
KysNCj4+IDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0
IGEvdG9vbHMvbGliL2JwZi9saWJicGYubWFwIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+
PiBpbmRleCBkMDRjN2NiNjIzZWQuLjhkMTBjYTAzZDc4ZCAxMDA2NDQNCj4+IC0tLSBhL3Rvb2xz
L2xpYi9icGYvbGliYnBmLm1hcA0KPj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+
PiBAQCAtMTkwLDMgKzE5MCw2IEBAIExJQkJQRl8wLjAuNSB7DQo+PiAJZ2xvYmFsOg0KPj4gCQli
cGZfYnRmX2dldF9uZXh0X2lkOw0KPj4gfSBMSUJCUEZfMC4wLjQ7DQo+PiArDQo+PiArTElCQlBG
XzAuMC42IHsNCj4+ICt9IExJQkJQRl8wLjAuNTsNCj4+IC0tIA0KPj4gMi4xNy4xDQo+Pg0KPiAN
Cg0K
