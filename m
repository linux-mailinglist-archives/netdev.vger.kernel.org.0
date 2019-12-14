Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6A8411EF14
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfLNAUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:20:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11892 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbfLNAUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:20:24 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE0ALY9005251;
        Fri, 13 Dec 2019 16:20:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xmdD1PrlT7Vr/Zx3NMDriLN2slgN5xebzC0GkzxREO4=;
 b=Eg//q2wn68e3UHPQZSeOzUtK0+ep5sfr3NN5mkFAMIAJel3QzCrauwFbNA/WuntotzMP
 T9y986rd8eyujQg0z/fTx0LMwEP6XC0NCDFfBFk8sjOut8ioJKDaSDHgfKOPUkfcOOyk
 Z3+M5zQRiqIy/2VK02aABF1lqqep3YnyNGI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvjpr0man-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Dec 2019 16:20:10 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Dec 2019 16:20:10 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 16:20:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOsdr7sN4FEmoJxkQpLtQww0GwHmHufuuUb5+SPgoTxi+OjKId2NGqULNy7AHa4iLU7AZwAv/LUj8C5X1tpupODt9vsE9AyfDRWPcbzmwyJZqmJ8Jk5Dl5mTVgxRSvPv0rW1ViFfcAfA9RdmAIJ3ut5JCqtbmWafEoIw3s5OHGZVggzgOscReAm7MIznd7KDqDbgYoYTcwRydNCKOJmXY/GwL6+qypaOtQwGEB5ewwk0IwdDzOhNDvazEZYAqkkBE1Xh/CKjHyOvy4RpwFIn4XOVkD2wIvqO1Hfvs9fF29O6QWbLKzwV62C8e6ZCKO+auGH4H0c9AuD90h1H+Pedwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmdD1PrlT7Vr/Zx3NMDriLN2slgN5xebzC0GkzxREO4=;
 b=fJFAwpRfTONJyhU6ZZjp08ra0FRNHhS7dbJMeve1EqDRBOtNx4QeSzqWSNKvS8EhmnPYOFCxErtRn0WC/xuNWj48TcrtQI6/r2iw43QG2ilVNFbH030kfUG5VLKz6P7RJ8g39M51jBWxPZ6iyyb+KigHPuWx+TOUUTfuQiCQycxCUmDPmUhKD0H3/ecrshttPqBEQge2E0TaAImWWh+htwWjdS4osWwJdu5VBVd/I9yfpTp8HHR+bod0/aCbIaLBO71KPmBEkon6FmNylBOoJCEOjATQwd7+PGJcCcgNppA9qaM3DPNKmYUSyB4LAVcO4O24uuJI0PPoSVenRptXqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmdD1PrlT7Vr/Zx3NMDriLN2slgN5xebzC0GkzxREO4=;
 b=Mx27Nqk6sAiq+ynp605JQd5n69Zv7jRJFqC4WIiYz1pejSfq2Wnx9p4c2VTD4IuEgKwKAtvQdeqPkTfS4qPCXP4lEr9Cv5jCIS/rAuMQkrOL9llUv+dnPpOzMPG3Xqt22D30Xgui+lTEQ5utDUdEfF3PIC8vRG8Ojh7UdO/pTxU=
Received: from MWHPR15MB1678.namprd15.prod.outlook.com (10.175.137.19) by
 MWHPR15MB1279.namprd15.prod.outlook.com (10.175.4.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Sat, 14 Dec 2019 00:20:08 +0000
Received: from MWHPR15MB1678.namprd15.prod.outlook.com
 ([fe80::9496:6fad:96ac:4de8]) by MWHPR15MB1678.namprd15.prod.outlook.com
 ([fe80::9496:6fad:96ac:4de8%9]) with mapi id 15.20.2538.017; Sat, 14 Dec 2019
 00:20:08 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/4] libbpf: support libbpf-provided extern
 variables
Thread-Topic: [PATCH v3 bpf-next 2/4] libbpf: support libbpf-provided extern
 variables
Thread-Index: AQHVshBU3wN9WCarLEiMGQoLYjPRaae4xEiA
Date:   Sat, 14 Dec 2019 00:20:08 +0000
Message-ID: <e612995b-ee80-5d22-512c-dfe700c97865@fb.com>
References: <20191213235144.3063354-1-andriin@fb.com>
 <20191213235144.3063354-3-andriin@fb.com>
In-Reply-To: <20191213235144.3063354-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR13CA0045.namprd13.prod.outlook.com
 (2603:10b6:300:95::31) To MWHPR15MB1678.namprd15.prod.outlook.com
 (2603:10b6:300:11e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::7ad7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7af7f6ea-da62-4390-31e4-08d7802b600c
x-ms-traffictypediagnostic: MWHPR15MB1279:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB127928FED660FFCB518E7E21D7570@MWHPR15MB1279.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 025100C802
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(376002)(346002)(396003)(39860400002)(189003)(199004)(316002)(31696002)(31686004)(110136005)(8936002)(54906003)(186003)(2906002)(4326008)(86362001)(71200400001)(52116002)(2616005)(6506007)(6512007)(36756003)(53546011)(6486002)(4744005)(66446008)(66476007)(478600001)(8676002)(66556008)(64756008)(5660300002)(66946007)(81156014)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1279;H:MWHPR15MB1678.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x+XH4qYjsF1VOy5Xpp4QmJYn2uXmysAk5nEF+lDuDxRFpaJ2w+MyEVYqOVPuTHu6AF/os9gVBVhAVrdsmhOTUoOhkQqgWdqTRHxTqRxqHFswc2dv3aqgOBDIl2Fl3u4Xn9iMDeD+pS9oTdT/MFXAiuX2EyISF855xtiWu1wIHIK/BPFROoIhaC4lGQb6JUj0KWN7vM9wh5wlMaOGlMApjc13aRLrH9VczwLxQq+PWKmxXxKXrqOiHAtHslO5d2O8SSt/r/BcWsMZ3VZbfdjQMuw3lOuLQ91iJcWkh33+ezOZvrb+G6Llm7VUralKuJstEDKC7d+GxGrxmJAGFl9pnDrj7hvrKgK1tg+3oQ6iREWNtIXWb7CoYf7ClJMJ4j8hRhdGEHSkNLJyGTI6ywqifnO5rwb3fj8A5i24WF6o7VUW+jn8DlK1X6idzMaJfpDB
Content-Type: text/plain; charset="utf-8"
Content-ID: <14C7E58D116E11448A144B8D47D223AD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af7f6ea-da62-4390-31e4-08d7802b600c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2019 00:20:08.1394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 69dPJZafZ1DFKEsf82pkonajhQgGbjEOOv4KaxwBxNxWh6ZK2CHnBJ8CZiyECtug
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1279
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912140000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTMvMTkgMzo1MSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiAgIHN0YXRpYyBp
bnQNCj4gICBicGZfb2JqZWN0X19pbml0X2ludGVybmFsX21hcChzdHJ1Y3QgYnBmX29iamVjdCAq
b2JqLCBlbnVtIGxpYmJwZl9tYXBfdHlwZSB0eXBlLA0KPiAtCQkJICAgICAgaW50IHNlY19pZHgs
IEVsZl9EYXRhICpkYXRhKQ0KPiArCQkJICAgICAgaW50IHNlY19pZHgsIHZvaWQgKmRhdGEsIHNp
emVfdCBkYXRhX3N6KQ0KDQp0aGUgcHJldmlvdXMgcGF0Y2ggc2V0IGRpZDoNCiAgYnBmX29iamVj
dF9faW5pdF9pbnRlcm5hbF9tYXAoc3RydWN0IGJwZl9vYmplY3QgKm9iaiwgZW51bSANCmxpYmJw
Zl9tYXBfdHlwZSB0eXBlLA0KLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50IHNlY19p
ZHgsIEVsZl9EYXRhICpkYXRhLCB2b2lkICoqZGF0YV9idWZmKQ0KKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgaW50IHNlY19pZHgsIEVsZl9EYXRhICpkYXRhKQ0KDQphbmQgbm93IHRoaXMg
cGF0Y2ggc2V0IHJlZmFjdG9ycyBpdCBhZ2FpbiBmcm9tIEVsZl9EYXRhIGludG8NCnR3byBpbmRp
dmlkdWFsIGFyZ3VtZW50cy4NCkNvdWxkIHlvdSBkbyB0aGlzIHJpZ2h0IGF3YXkgaW4gdGhlIHBy
ZXZpb3VzIHNldCBhbmQgYXZvaWQgdGhpcyBjaHVybj8NCk5vdCBhIHN0cm9uZyBvcGluaW9uIHRo
b3VnaC4NCkp1c3Qgb2RkIHRvIHNlZSB0aGUgZnVuY3Rpb24gYmVpbmcgY2hhbmdlZCBiYWNrIHRv
IGJhY2suDQpUaGFua2Z1bGx5IHRoYXQncyBpbnRlcm5hbCBpbiAuYyBmaWxlLg0K
