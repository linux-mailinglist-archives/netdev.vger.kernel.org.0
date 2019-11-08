Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBE0F57BF
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388708AbfKHThb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:37:31 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18810 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387561AbfKHTha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:37:30 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8JYW0a009803;
        Fri, 8 Nov 2019 11:37:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pfRPNSN2L7TWs/MO61i+lL6xzxGjfeRQ590HHryc3ew=;
 b=gahjwbAuTHGThr7FbrNZUcywE3FjV80L0yOR0RQpyhJmNvrDBhgETLcuEAkE1wvlUBtD
 FGKPvSl2h9b3rNhyvxQc82YutFNqPILtEZXpNIKmGgJrPneYY3mD1TXrc0EIjOhHOI8g
 /F7WGvkigBvSpwQY3q3bdtv9aqaLB192wHo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0w505-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Nov 2019 11:37:12 -0800
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 11:37:10 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 11:37:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlJpeb0wMBQuxTwNo8gghs2exFRVAc3XWflnLJNKT9piRjlADRC4iVOdLkBEQFTdxkA/DZcF7CCmVkeCm/HbmumnzKKSHTJwYvZnEPRpi/Nq7WOWNvYZ0N5Sjg4Dxeur39CTB38C28HkfYBrYqbVwc1QHAWULfWibIrc4JfBYBkXX6lLTsqlI0wVoevEVve9l5vq5gGLP5RW/cJE1wAhZRZ+zn0nXg8jcnILg/KSPY2H7f2wXOEAEYlQTw/9xrzeBZHoVf0RxfOmas8YZ2TTewUsI8wGwBbvvLolPnmM6E8Mi6cdUcfQiXnsRrxaIliy7sJDT9AFxweRPHO2OJ56Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfRPNSN2L7TWs/MO61i+lL6xzxGjfeRQ590HHryc3ew=;
 b=m6IhVAXUHyTiH567N2EWr9in+1NvbVTgJZHxRl4teW+DAHN+afElMjiGlkA5QIc8MDiKVFfM1UesK3W6Z8tbtNlCt/29+JfndDNDZ8en+uT1AeMUSLpQvEn+QsbYPe7WEc0TLjw1E9aIfjeAy+EsY/NnU4/fxAmtjGYwFroYfNL2pxpB37D3CddrWW+V2syMOqpFFeiBIDNwzyA+l4uo7s7gtV7/EPgHHHG7rA6J8F1IMcqcGyqVv7j+gzsmV4f+uz7xmTeprcxgWPbWqwCKNK/YTGKvFsDvuSC8KZhofApBLwx7Kkj/C8kdVIw48q8UkTog0aot93llkWx4x3h0Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfRPNSN2L7TWs/MO61i+lL6xzxGjfeRQ590HHryc3ew=;
 b=QUn5zZxFSYo9Enrn9o1IuqisWfKxWa/FExwMhNtLyfLEOUagNn43aYaYbdDj5sb6HghmzW6BABKempCt6xHtFl3d/WGyXpqrKadtrdqD5G1KmmLizwUj7rS2PKi3/iM9+YMwf4T8BTetIHG5fgwqpTHJxmzrEQL2imoYabjEZgM=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1565.namprd15.prod.outlook.com (10.173.235.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 19:37:09 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 19:37:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/6] libbpf: Use pr_warn() when printing netlink
 errors
Thread-Topic: [PATCH bpf-next 4/6] libbpf: Use pr_warn() when printing netlink
 errors
Thread-Index: AQHVlYu/pp0nmqZhhU2FreEh/9dAq6eBrLkA
Date:   Fri, 8 Nov 2019 19:37:09 +0000
Message-ID: <6E83C846-60D7-4289-B696-6982FC6CE26D@fb.com>
References: <157314553801.693412.15522462897300280861.stgit@toke.dk>
 <157314554255.693412.241635799002790913.stgit@toke.dk>
In-Reply-To: <157314554255.693412.241635799002790913.stgit@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8869a73c-ab42-417e-57f7-08d764830b8e
x-ms-traffictypediagnostic: MWHPR15MB1565:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1565F8E736B36FD354402133B37B0@MWHPR15MB1565.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(396003)(376002)(346002)(199004)(189003)(2906002)(71190400001)(446003)(66476007)(53546011)(66556008)(76116006)(4744005)(186003)(102836004)(2616005)(478600001)(81166006)(81156014)(33656002)(256004)(66946007)(5660300002)(11346002)(6506007)(66446008)(6246003)(8676002)(305945005)(8936002)(486006)(476003)(6436002)(6486002)(54906003)(50226002)(64756008)(25786009)(7736002)(99286004)(6916009)(46003)(6116002)(76176011)(316002)(86362001)(4326008)(71200400001)(229853002)(36756003)(6512007)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1565;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: emD251L9qkmYzAkwbIrk4+KF+EBH/TC+osLW1PkAuuPQoynVC3IsV5k75TpKTt5iunNzCgXUoR4vv7IQJD2MphZQvOHIfAT5Xvuwp14E1l6yywHaHIYYRfOZxa5pEAefTfYkFlw8cOb97nmU4tvWsLD9lHU1NyWYyY0o22sf1Qim6OP4NvzPZeAgzG1OfOIDZyf90+qNh5uleT1hfbc6vBXQ1ghxb/Ajd77v0HpkJZivcXu1j4Ics+uk1OHaTEDmmhTeD+iwUad/xW2YNB/O7ruzPSNX6E+fGmnQ9Dxwq7UQCRPjqAWMI3xBLktGhxM+Waj4QL2Mntput2+wqtBdkyIzc97YsGw49C+36XNuscUbD11MVRjR0W8qLFcCLlC/H55vL3qd+WzTllZIxCTkK4oOB3B5dUkxxycl8iotMvrkKgkUSd8nImD2pYmrQM9k
Content-Type: text/plain; charset="utf-8"
Content-ID: <A29D870028B3614F9A5ACCEE4CBC3370@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8869a73c-ab42-417e-57f7-08d764830b8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 19:37:09.2236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: osUwHn0XVFTCCZ2d67gNqUTuLyVFaB9mz4JsTuyHazyZgx5IcgAWNkgYAAiy87TiWSIZaHkbdAnSvrI3npQnkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1565
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_07:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=794
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080190
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTm92IDcsIDIwMTksIGF0IDg6NTIgQU0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNl
biA8dG9rZUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFRva2UgSMO4aWxhbmQtSsO4
cmdlbnNlbiA8dG9rZUByZWRoYXQuY29tPg0KPiANCj4gVGhlIG5ldGxpbmsgZnVuY3Rpb25zIHdl
cmUgdXNpbmcgZnByaW50ZihzdGRlcnIsICkgZGlyZWN0bHkgdG8gcHJpbnQgb3V0DQo+IGVycm9y
IG1lc3NhZ2VzLCBpbnN0ZWFkIG9mIGdvaW5nIHRocm91Z2ggdGhlIHVzdWFsIGxvZ2dpbmcgbWFj
cm9zLiBUaGlzDQo+IG1ha2VzIGl0IGltcG9zc2libGUgZm9yIHRoZSBjYWxsaW5nIGFwcGxpY2F0
aW9uIHRvIHNpbGVuY2Ugb3IgcmVkaXJlY3QNCj4gdGhvc2UgZXJyb3IgbWVzc2FnZXMuIEZpeCB0
aGlzIGJ5IHN3aXRjaGluZyB0byBwcl93YXJuKCkgaW4gbmxhdHRyLmMgYW5kDQo+IG5ldGxpbmsu
Yy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiA8dG9rZUBy
ZWRoYXQuY29tPg0KPiANCg0KQWNrZWQtYnk6IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5j
b20+DQoNCg==
