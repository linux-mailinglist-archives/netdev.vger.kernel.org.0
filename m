Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37552D1F0A
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 05:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732813AbfJJDnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 23:43:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60652 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbfJJDnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 23:43:35 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9A3TxkX028842;
        Wed, 9 Oct 2019 20:43:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=FN9bELBHiOIlhPMTEs4dEWY92g1a9ByOAbA21JGCC64=;
 b=dRUzG5R/OFoK82fepozrDWAolSkQuy9g0Baj+seR4EvSEXI2ILr10kUAX7tJfhkFrNM6
 cFHfsETmZ5Eva5RrFrKa58+/rDoGv0OijtJrbrK6Z91HANW66ZLp6Z+CKeG9fwLD5iLX
 eSkUpQu2+7B5nS4/pqFeKBmTyGLSBX/qn0Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vht50ggkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Oct 2019 20:43:16 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Oct 2019 20:43:15 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 9 Oct 2019 20:43:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuqsypFa/YWuIzOlmmkT+rx3qRXRATAjcOEJFEQIUulUxh9htgZfb/5EOv+2YJbqBh7Ipts1KgQ/IKGAoDAvhYphopMWwYSu+tELxHwkVsC4dr9BncBPPUCIE3Bzc0aKrFZLLVei5RhHhJcwuDy2xF3w4faL9jJ08k0Gw841T97HniieXrXVWlkR2C7YHuiRQGfsrCttfCWyWvUN2BMuBrEFrF4SwuKcqdsUBLkdQcLLoXOlRaJokJ5OuuSAE1cSi9bJcEkVG6Q1zqYFWQOPlzuwd9GTR03ZZI0q5fyu8E2briL1XzBpGszew9pSsvl/rCAPK1Ui6KbwdbAyH5FWkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FN9bELBHiOIlhPMTEs4dEWY92g1a9ByOAbA21JGCC64=;
 b=UEaaYBwBLmhAQr6tX4rsnKQHVIfq/jPhjULSIXqickovZ2jan9kT/IUIOkuoki81GvlO4UDrw48K+hNriQtE1FEA1xPhXgffvBP0OtN9IiqPFV1pdwVvSGuUNE9s1rWI/IndxInEXU6oNPG2bWfLy2iESHC82xqYCaUkmrHtJIXtnes8RRWnMLV5rRgWibiAWvt0d217NyJ/WpPwTy6WTjBLdPUz5uuNoM/Z1c5ONg/DgvMnNOLEIElBkIkc1wEH2PPnw+rmeMZVaz8lP1AKAN0t0e46gclz7pS4LkYGSb3Uolx4He61CdQpUpBLi0UsseIBkxbPUhU4gjLBkpb8ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FN9bELBHiOIlhPMTEs4dEWY92g1a9ByOAbA21JGCC64=;
 b=JDPxeklc5wAEUxm3I1SocfvgWxxFbg2oSOskNq5eIt1CBI0llMPzVIjEFDJELGgVEF++4bjGUU+fcVFPJtRZIum6zUCzfr6GezfM2nGTk0Tykx8HbAKdHwjHGOxWaYrF7JrLpz/SYlhKMs5wM6QRpOnFnUbrNzBU+tT3GonWawA=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2328.namprd15.prod.outlook.com (52.135.197.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 03:43:14 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Thu, 10 Oct 2019
 03:43:14 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 03/10] bpf: process in-kernel BTF
Thread-Topic: [PATCH bpf-next 03/10] bpf: process in-kernel BTF
Thread-Index: AQHVezpJsJvN7fIrL0O9h5D6mwAuEadS0FEAgABy5gA=
Date:   Thu, 10 Oct 2019 03:43:14 +0000
Message-ID: <8aaa8d21-24d7-cea3-0275-c063a213c13d@fb.com>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-4-ast@kernel.org>
 <20191009205152.kfdkm2pvbyiwfelf@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191009205152.kfdkm2pvbyiwfelf@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0105.namprd15.prod.outlook.com
 (2603:10b6:101:21::25) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::7c62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 847fb7f4-25dd-48a0-138f-08d74d33fa85
x-ms-traffictypediagnostic: BYAPR15MB2328:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2328BE464CDB5F7D4D3F260FD7940@BYAPR15MB2328.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(39860400002)(396003)(376002)(189003)(199004)(386003)(478600001)(25786009)(64756008)(14454004)(5660300002)(4744005)(2616005)(476003)(486006)(6116002)(36756003)(46003)(446003)(66556008)(66476007)(66946007)(66446008)(11346002)(31696002)(186003)(2906002)(305945005)(76176011)(53546011)(6506007)(7736002)(102836004)(256004)(52116002)(99286004)(4326008)(71190400001)(71200400001)(86362001)(6246003)(6486002)(229853002)(316002)(110136005)(31686004)(8676002)(81166006)(8936002)(81156014)(6512007)(6436002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2328;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Ddn/IfbTxvocKrpxaUg+HvIi1TjxPob4TUZ4VaD22oaoleZPJmmBkeaUcabFu2ZVhBvmJFFWIpjTALEyLYMOcGAT/Ru5QO7QgM+KTlT3rcQ3KdDYRPMmExyI1It2n6nrct0/4jPzbBjx+fwFSCK8SxIGRBplPvyc38D90LnoNARBM2+JjoCkvmcrwuDAwoZKqsiXagB264vrBUCvXwTuhqJA5QQUXOmV7Eo1O1ELnDPcrmerdxNdknIkyKPRuaRg9bfHFvlfXCp3BThiiI+XqDh/apHr2UpgucUhXx3VMPtMEiLfX6urXZieJ+G4FZ0/lhnHSG/9F5kZqeyzzzYW4uvdREIuXGsTFrAo3mZxf24qhDYrK7jEzQcgWICxlP7HYz0yNLFgQkF3Ap5BTg4YabFPTTxbPWdeYG6iZzguRU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <664549603086934B8A70C5DD30C855B8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 847fb7f4-25dd-48a0-138f-08d74d33fa85
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 03:43:14.0619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jXLB6JiTuBcvO78ETLH+WydcJin7c0QgvpTdmZYVuC7B6OCDLu4HYwFTzJXLbkKm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2328
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_01:2019-10-08,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 mlxlogscore=911 phishscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100031
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvOS8xOSAxOjUxIFBNLCBNYXJ0aW4gTGF1IHdyb3RlOg0KPj4gZXJyID0gYnRmX2NoZWNr
X2FsbF9tZXRhcyhlbnYpOw0KPj4gKwlpZiAoZXJyKQ0KPj4gKwkJZ290byBlcnJvdXQ7DQo+PiAr
DQo+IENvbnNpZGVyaW5nIGJ0Zl92bWxpbnV4IGlzIGFscmVhZHkgc2FmZSwgYW55IGNvbmNlcm4g
aW4gbWFraW5nIGFuIGV4dHJhDQo+IGNhbGwgdG8gYnRmX2NoZWNrX2FsbF90eXBlcygpPw0KDQpP
bmx5IGNvbmNlcm4gaXMgYWRkaXRpb25hbCBtZW1vcnkgcmVzb2x2ZWRfKiBhcnJheXMgd2lsbCB0
YWtlLg0KVGhlIHVzdWFsIGNwdSB2cyBtZW1vcnkgdHJhZGUgb2ZmLg0KRm9yIHRoaXMgc2V0IEkg
dGhpbmsgZXh0cmEgd2hpbGUgbG9vcCB0byBza2lwIGJ0ZiBtb2RpZmllcnMNCmlzIGJldHRlciB0
aGFuIGV4dHJhIGFycmF5Lg0KWW91cnMgY291bGQgYmUgZGlmZmVyZW50LiBBbmQgdGhhdCdzIG9r
Lg0K
