Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F1FD4BD6
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 03:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfJLB37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 21:29:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21090 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726829AbfJLB37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 21:29:59 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9C1Th5Z026101;
        Fri, 11 Oct 2019 18:29:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wk1l1XFJbCP+Isf26DXhkMLC5pdYSaiTBOC1Dv8Udk8=;
 b=nKHTksTHVoIZx8tJSUyXNeuCER8OclMBRTjsI8H5hBGH9LRc4DtDnBVn4Lgt5tOVJ7uQ
 G1EjkwfciW1hoTTf7C6OnGYkj9M7rrSAcubNQdomkVzX0FvSYCIScQhOdWrjngUw+rEI
 vH22s/pgqA2P44R6WolgeX5FZE+5jo25nIw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vk0vegw63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 18:29:43 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 18:29:42 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 18:29:41 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Oct 2019 18:29:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHX36yj9PzEpm5xuablnWC/PVSyXFMFO9iaEyvTLB3F+QjaI1iUgiMxko8J2lWe8pvx93KFXpiwKKzSMj+m18nxmrf71yYYM1+pu3GAqrLtywg+7OA7FXkHis/dkZVZslGzBts7SXeehHlaiSWSCYXQ9iwy6wFQRrVybou5dBNLqEWxYHhYkt9sy8JM8skOarc1D5wtNmZVw5S1icyLVdjSoixkEGFXdTGLFBHznXwi4pSNCAaGTLYyKRpT9TtSWusGpkCopb3rHTcRKtsz3XOswnMeWb3G6N48fmGhUlbi1W3h2v/sqoVQKJ3lONwYM/sMAf2nP567pPOcjG0uNIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wk1l1XFJbCP+Isf26DXhkMLC5pdYSaiTBOC1Dv8Udk8=;
 b=W5vv4/EiyTBLtF8FOmpNerAPO4A15xpSAZdFgRnjfwexMjKCP1fOmPXWsBUIGMGKntwmTTMq2irEOM2oKRFY1I3P0XUIL6so0N0fH7AdWa/Iia+ECRKFUyvSc++ztwrvWIgmNdEFBbEKUI1klr6WX6d+jX/zn0o9KUSuRbqC1rIhMyHnamoBAM/7Qu6w9G5pLP33BAlv5uzv0mOb9E8H7l8AxrisbdZIbUr47aCZxk8drDFQ1pED8z5wc6PEvjiax5+/6ugaqm4ZXo7iMPujfTLvfxcJsZcVTxbsmrZ7rVrUnivybbqwXWkMaEIwtnGj8KyaEqfHPTvEtXRjFnCDlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wk1l1XFJbCP+Isf26DXhkMLC5pdYSaiTBOC1Dv8Udk8=;
 b=Uzl2jGIxS6ERCb48LjxFja0Wq6HlGhiErh8z2aC7vXch0RbQbVGLZPq1CA00Q9Im9PiVaX/I84xj+b4WIXyShIIarplkLhnoMXMN+/0Am/2uTZ2+F177h4eFtKRxUxnzGV8mxjdmZrBBzYGrdEpdYsyloiw+oZQW2Z/dapw5eMI=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2470.namprd15.prod.outlook.com (52.135.192.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Sat, 12 Oct 2019 01:29:40 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2347.021; Sat, 12 Oct 2019
 01:29:40 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 05/12] libbpf: auto-detect btf_id of
 raw_tracepoint
Thread-Topic: [PATCH v2 bpf-next 05/12] libbpf: auto-detect btf_id of
 raw_tracepoint
Thread-Index: AQHVfyFTTiLEwIVqQE6co+EkPTXoLKdVvxuAgABt1ACAAA3QgA==
Date:   Sat, 12 Oct 2019 01:29:39 +0000
Message-ID: <ec2ca725-6228-b9e9-e9fc-34e4b34d8a1a@fb.com>
References: <20191010041503.2526303-1-ast@kernel.org>
 <20191010041503.2526303-6-ast@kernel.org>
 <CAEf4BzZxQDUzYYjF091135d+O_fwZVdK9Dqw5H4_z=5QBqueYg@mail.gmail.com>
 <0dbf83e8-10ec-cc17-c575-949639a7f018@fb.com>
In-Reply-To: <0dbf83e8-10ec-cc17-c575-949639a7f018@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:301:60::14) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::3d03]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e794c5c-6371-4dca-0d93-08d74eb3a69b
x-ms-traffictypediagnostic: BYAPR15MB2470:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2470F69B990D2A49833A866FD7960@BYAPR15MB2470.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0188D66E61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(396003)(39860400002)(366004)(346002)(199004)(189003)(86362001)(6116002)(6506007)(46003)(5024004)(14444005)(71190400001)(71200400001)(31686004)(478600001)(102836004)(229853002)(2906002)(6486002)(386003)(31696002)(99286004)(186003)(6436002)(8936002)(53546011)(81156014)(81166006)(8676002)(36756003)(7736002)(64756008)(66556008)(66446008)(6512007)(256004)(66946007)(66476007)(52116002)(6246003)(5660300002)(76176011)(446003)(110136005)(14454004)(316002)(54906003)(4326008)(25786009)(2616005)(11346002)(476003)(486006)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2470;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VSg1KPx4iOXSlg72Zoh50dnp0WYPS+0osgnlbE7VZjxc+lchVNuk8d4GuPx7XQqUYUxVCg0jU1VFWru6vcfcSHB6LyPwx7YlefXebt+G+P0W7gk2CszasHB+jI4lwAXh4PWVvYJHjkgeRsyjFiRL/CxuyM9wiXl1foehp2sRuDl/iSgrWoh/p8N/iYcsLmX4HCQxSQRcIPhEcxSUohVdAY65zbCpjyG3gpxNZTSC2VPD7CqMqn+RKFXcpwDOuLiVYaPMB4QrSmjBxjlGZEOQnCJfil/tuARWvQAb94ny4s6ZP+0IZxrjgooSZzvmasxvOa8HChtPC24i2gVCivHoyE9g3Rnsqt9CJYbA+90DjgyIFJOvpYNJ+Lfhd0yNRLuuvcaVLnRwDRYvPPM7LE6M8EG+Y2tscAi1EIFppkopAbk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9FCBB8A15E666428D4636489AC23721@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e794c5c-6371-4dca-0d93-08d74eb3a69b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2019 01:29:39.9775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LjE/Zj5Gb6Qhn02A+Xy7qifJMHuWwe6iqWKARWndF/pArawuqi8LbDuD6bUPV9SX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2470
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_12:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=913 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910120006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTEvMTkgNTo0MCBQTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPj4gQnV0IGV2
ZW4gaWYga2VybmVsIHN1cHBvcnRzIGF0dGFjaF9idGZfaWQsIEkgdGhpbmsgdXNlcnMgc3RpbGwg
bmVlZCB0bw0KPj4gb3B0IGluIGludG8gc3BlY2lmeWluZyBhdHRhY2hfYnRmX2lkIGJ5IGxpYmJw
Zi4gVGhpbmsgYWJvdXQgZXhpc3RpbmcNCj4+IHJhd190cCBwcm9ncmFtcyB0aGF0IGFyZSB1c2lu
ZyBicGZfcHJvYmVfcmVhZCgpIGJlY2F1c2UgdGhleSB3ZXJlIG5vdA0KPj4gY3JlYXRlZCB3aXRo
IHRoaXMga2VybmVsIGZlYXR1cmUgaW4gbWluZC4gVGhleSB3aWxsIHN1ZGRlbmx5IHN0b3ANCj4+
IHdvcmtpbmcgd2l0aG91dCBhbnkgb2YgdXNlcidzIGZhdWx0Lg0KPiANCj4gVGhpcyBvbmUgaXMg
ZXhjZWxsZW50IGNhdGNoLg0KPiBsb29wMS5jIHNob3VsZCBoYXZlIGNhdWdodCBpdCwgc2luY2Ug
aXQgaGFzDQo+IFNFQygicmF3X3RyYWNlcG9pbnQva2ZyZWVfc2tiIikNCj4gew0KPiAgwqAgaW50
IG5lc3RlZF9sb29wcyh2b2xhdGlsZSBzdHJ1Y3QgcHRfcmVncyogY3R4KQ0KPiAgwqDCoCAuLiA9
IFBUX1JFR1NfUkMoY3R4KTsNCj4gDQo+IGFuZCB2ZXJpZmllciB3b3VsZCBoYXZlIHJlamVjdGVk
IGl0Lg0KPiBCdXQgdGhlIHdheSB0aGUgdGVzdCBpcyB3cml0dGVuIGl0J3Mgbm90IHVzaW5nIGxp
YmJwZidzIGF1dG9kZXRlY3QNCj4gb2YgcHJvZ3JhbSB0eXBlLCBzbyBldmVyeXRoaW5nIGlzIHBh
c3NpbmcuDQoNCldpdGg6DQpkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBm
L3Byb2dfdGVzdHMvYnBmX3ZlcmlmX3NjYWxlLmMgDQpiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi9wcm9nX3Rlc3RzL2JwZl92ZXJpZl9zY2FsZS5jDQppbmRleCAxYzAxZWUyNjAwYTkuLmUy
NzE1NmRjZTEwZCAxMDA2NDQNCi0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
X3Rlc3RzL2JwZl92ZXJpZl9zY2FsZS5jDQorKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9i
cGYvcHJvZ190ZXN0cy9icGZfdmVyaWZfc2NhbGUuYw0KQEAgLTY3LDcgKzY3LDcgQEAgdm9pZCB0
ZXN0X2JwZl92ZXJpZl9zY2FsZSh2b2lkKQ0KICAgICAgICAgICAgICAgICAgKi8NCiAgICAgICAg
ICAgICAgICAgeyAicHlwZXJmNjAwX25vdW5yb2xsLm8iLCBCUEZfUFJPR19UWVBFX1JBV19UUkFD
RVBPSU5UIH0sDQoNCi0gICAgICAgICAgICAgICB7ICJsb29wMS5vIiwgQlBGX1BST0dfVFlQRV9S
QVdfVFJBQ0VQT0lOVCB9LA0KKyAgICAgICAgICAgICAgIHsgImxvb3AxLm8iLCBCUEZfUFJPR19U
WVBFX1VOU1BFQ30sDQogICAgICAgICAgICAgICAgIHsgImxvb3AyLm8iLCBCUEZfUFJPR19UWVBF
X1JBV19UUkFDRVBPSU5UIH0sDQoNCmxpYmJwZiBwcm9nIGF1dG8tZGV0ZWN0aW9uIGtpY2tzIGlu
IGFuZCAuLi4NCiMgLi90ZXN0X3Byb2dzIC1uIDMvMTANCmxpYmJwZjogbG9hZCBicGYgcHJvZ3Jh
bSBmYWlsZWQ6IFBlcm1pc3Npb24gZGVuaWVkDQpsaWJicGY6IC0tIEJFR0lOIERVTVAgTE9HIC0t
LQ0KbGliYnBmOg0KcmF3X3RwICdrZnJlZV9za2InIGRvZXNuJ3QgaGF2ZSAxMC10aCBhcmd1bWVu
dA0KaW52YWxpZCBicGZfY29udGV4dCBhY2Nlc3Mgb2ZmPTgwIHNpemU9OA0KDQpHb29kIDopIFRo
ZSB2ZXJpZmllciBpcyBkb2luZyBpdHMgam9iLg0K
