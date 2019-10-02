Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F300C9135
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfJBSzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:55:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22642 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727685AbfJBSzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 14:55:15 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x92Iejbl015963;
        Wed, 2 Oct 2019 11:54:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=p4GzwkYUjNacvbZVUNTzCoAZlFTrl92awwQGfE3+oq4=;
 b=pqiwZe9Xj83qK+wsXtlyjz/qZSENBbQIek1rbRRuwMXXk3jsYV2YkmQaEnWC7RRRZZCp
 qJyqWut3QJRCdM+UOLqmjkNSq6tvv7TX98/6llPAUzVz/vMTwnNlc3urEJBuW6iUO5Ww
 MsrQkiz7FMZ7/OHF0X6iBlkMES0HVZxlW+Q= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vc8tay3ps-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Oct 2019 11:54:57 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 2 Oct 2019 11:54:56 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 2 Oct 2019 11:54:56 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 2 Oct 2019 11:54:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGYDSGR7/PgCvg8ET8yb7WqEAk9D2qPVsBchAqWSi3RjqWcJjgoha4arzOCRQlKRHSMgP3n1KI4I0cqswLvOvoY3lMbPQTKlmxvXsEsHCz9P+AQj0OGObha9o442fMEpak/A6O2FFYcm6y+r66cAoCx7qonZDvtl7rDVMZgA7TJ799VEvsbRMIp9uV9r5/tJgTVkt57yX2W6hzaRGy8gnUKzhYLXK43Nq0ZqjKfQW2ckb97pXUTxzvsC8he2TRK/Ej/DYb7MYkRau+TiqD8gXWbRbQQsa+tUIvG9aOS30dg/snDvqVGysHphwXhCIa4hNqRVqX3WsKT7cEUkS4EXRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4GzwkYUjNacvbZVUNTzCoAZlFTrl92awwQGfE3+oq4=;
 b=KiO7u9ut59Mz7FZNCtY/9A+yMGHNlXh/7AOmYYy6eISCfbxAnscBqwbkbhyD8HoCBXBLgJWG6Qb42Mjr+NtM06Bv3pdsebEttoPq1/Qu4zwpqUX8PILiiLQ3Q8YsKMnuJgxbbNUvd644/LtS5Hxp83vpKudt0QP3u/qOjprFkaDWZqD5A5ff4OO+OA+2dLzfdOZ0tbF/bf9J3osXwIWlldtu2QuSWltTV7OC9Qfne3z41zibjVIZnnzIn1aIYVsD2j5WVbh0UcBnGOFEoGQHs46LPptlGAwlHUKv3t694btP8t9U6/Urc+xI/tVVywUerY67bSe6TgiT9z5pjQP9yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4GzwkYUjNacvbZVUNTzCoAZlFTrl92awwQGfE3+oq4=;
 b=Pt+wKfXU+xEQdT+2EA3Fy8fvyyR0hA8cUZaLCaKLKZA6xLYqH++dJvwLsDeNwtmCTdFhXIwtjh+Ps5MRnIKXHB3wqNrjJDW4PBpfHm2vgnJYytX6R9DKXgrJDoCJA7rr0DI6oKg5R6HJDL+/D9zMvBXaEevLQlI39kFt17cN1w0=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1293.namprd15.prod.outlook.com (10.175.3.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Wed, 2 Oct 2019 18:54:55 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.022; Wed, 2 Oct 2019
 18:54:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Thread-Topic: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Thread-Index: AQHVeSWTQAdoySCg4UqxsTtsFl4XrqdHrwIAgAAEdAA=
Date:   Wed, 2 Oct 2019 18:54:55 +0000
Message-ID: <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com>
In-Reply-To: <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::2338]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8490f3f-c335-4663-1356-08d7476a03fa
x-ms-traffictypediagnostic: MWHPR15MB1293:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1293E0B800A927930A81DEFFB39C0@MWHPR15MB1293.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10001)(10019020)(346002)(39860400002)(376002)(396003)(136003)(366004)(199004)(189003)(7736002)(6116002)(229853002)(81166006)(54906003)(6916009)(71190400001)(66574012)(2906002)(86362001)(102836004)(8936002)(4326008)(71200400001)(186003)(8676002)(316002)(53546011)(81156014)(36756003)(256004)(14444005)(6506007)(305945005)(46003)(476003)(6486002)(486006)(25786009)(6512007)(5660300002)(6306002)(99286004)(2616005)(64756008)(966005)(6436002)(14454004)(66946007)(33656002)(66446008)(66556008)(66476007)(11346002)(446003)(76116006)(6246003)(478600001)(50226002)(76176011)(62610400005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1293;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SSVzyUTU9tKGb6tzOm4+khOytrBvatuNTEXby3imuB4wkWK0BySwWkXK8cHPb+ZcjIHL8Ew94WAJaPlQ4dtdfOejUAzqBd6xUl6y7rE9l1oQZTOEhyFsm5J0Wj05YLzcNRbtyCdmaTXiKm8psHh/RGPVto4mb83P90lgVb3bpV0Nq3W4VZZlTxz2x22pxcOYrXE03DQPI7gLBHjnUfi8mVltdSXiagmqEs6YBSmLdtK820VL1j9xc+5JNv1SE6uEroDBjoNEqk2TQH0ff7XjPz2BJjTPcLAw3agub5GeG9bMe1a9VoejCk8Zt5pRDSfsvqths+TBN35vVkCb+U/40VuW9P4dnzrgu6Tjn4bXf96ke1wzC/jhHUR2mGfNs6uHRiGvhmCrZmuqrGszWpSHceDXtuMkvB6G9IQzOELhXGzLRhpdH3FLIQsRzbKITrOeNTrGTEgQuEaKkPHJOsh7W2AZ/WtIypi0FFOFyToJJgg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C81F5FD8904F746AE01418E152DC5E3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e8490f3f-c335-4663-1356-08d7476a03fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 18:54:55.3231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /1T84jWF98KRYtKvrwA1vQ3vbFiZtwOdNtAeXAQ0C7FcCvubHHzDbOQpCd14SPU6sE9RvLJOJGKx5tMbneejWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1293
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_08:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910020150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gT2N0IDIsIDIwMTksIGF0IDExOjM4IEFNLCBTb25nIExpdSA8c29uZ2xpdWJyYXZp
bmdAZmIuY29tPiB3cm90ZToNCj4gDQo+IA0KPiANCj4+IE9uIE9jdCAyLCAyMDE5LCBhdCA2OjMw
IEFNLCBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gPHRva2VAcmVkaGF0LmNvbT4gd3JvdGU6DQo+
PiANCj4+IFRoaXMgc2VyaWVzIGFkZHMgc3VwcG9ydCBmb3IgZXhlY3V0aW5nIG11bHRpcGxlIFhE
UCBwcm9ncmFtcyBvbiBhIHNpbmdsZQ0KPj4gaW50ZXJmYWNlIGluIHNlcXVlbmNlLCB0aHJvdWdo
IHRoZSB1c2Ugb2YgY2hhaW4gY2FsbHMsIGFzIGRpc2N1c3NlZCBhdCB0aGUgTGludXgNCj4+IFBs
dW1iZXJzIENvbmZlcmVuY2UgbGFzdCBtb250aDoNCj4+IA0KPj4gaHR0cHM6Ly91cmxkZWZlbnNl
LnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19saW51eHBsdW1iZXJzY29uZi5vcmdf
ZXZlbnRfNF9jb250cmlidXRpb25zXzQ2MF8mZD1Ed0lEYVEmYz01VkQwUlR0TmxUaDN5Y2Q0MWIz
TVV3JnI9ZFI4NjkycTBfdWFpenkwamtyQkpRTTVrMmhmbTRDaUZ4WVQ4S2F5c0ZyZyZtPVlYcXFI
VEM1MXpYQnZpUEJFazU1eS1mUWpGUXdjWFdGbEgwSW9PcW0yS1Umcz1ORjR3M2VTUG1OaFNwSnIx
LTBGTHFxbHFmZ0VWOGdzQ1FiOVlxV1E5cC1rJmU9IA0KPj4gDQo+PiAjIEhJR0gtTEVWRUwgSURF
QQ0KPj4gDQo+PiBUaGUgYmFzaWMgaWRlYSBpcyB0byBleHByZXNzIHRoZSBjaGFpbiBjYWxsIHNl
cXVlbmNlIHRocm91Z2ggYSBzcGVjaWFsIG1hcCB0eXBlLA0KPj4gd2hpY2ggY29udGFpbnMgYSBt
YXBwaW5nIGZyb20gYSAocHJvZ3JhbSwgcmV0dXJuIGNvZGUpIHR1cGxlIHRvIGFub3RoZXIgcHJv
Z3JhbQ0KPj4gdG8gcnVuIGluIG5leHQgaW4gdGhlIHNlcXVlbmNlLiBVc2Vyc3BhY2UgY2FuIHBv
cHVsYXRlIHRoaXMgbWFwIHRvIGV4cHJlc3MNCj4+IGFyYml0cmFyeSBjYWxsIHNlcXVlbmNlcywg
YW5kIHVwZGF0ZSB0aGUgc2VxdWVuY2UgYnkgdXBkYXRpbmcgb3IgcmVwbGFjaW5nIHRoZQ0KPj4g
bWFwLg0KPj4gDQo+PiBUaGUgYWN0dWFsIGV4ZWN1dGlvbiBvZiB0aGUgcHJvZ3JhbSBzZXF1ZW5j
ZSBpcyBkb25lIGluIGJwZl9wcm9nX3J1bl94ZHAoKSwNCj4+IHdoaWNoIHdpbGwgbG9va3VwIHRo
ZSBjaGFpbiBzZXF1ZW5jZSBtYXAsIGFuZCBpZiBmb3VuZCwgd2lsbCBsb29wIHRocm91Z2ggY2Fs
bHMNCj4+IHRvIEJQRl9QUk9HX1JVTiwgbG9va2luZyB1cCB0aGUgbmV4dCBYRFAgcHJvZ3JhbSBp
biB0aGUgc2VxdWVuY2UgYmFzZWQgb24gdGhlDQo+PiBwcmV2aW91cyBwcm9ncmFtIElEIGFuZCBy
ZXR1cm4gY29kZS4NCj4+IA0KPj4gQW4gWERQIGNoYWluIGNhbGwgbWFwIGNhbiBiZSBpbnN0YWxs
ZWQgb24gYW4gaW50ZXJmYWNlIGJ5IG1lYW5zIG9mIGEgbmV3IG5ldGxpbmsNCj4+IGF0dHJpYnV0
ZSBjb250YWluaW5nIGFuIGZkIHBvaW50aW5nIHRvIGEgY2hhaW4gY2FsbCBtYXAuIFRoaXMgY2Fu
IGJlIHN1cHBsaWVkDQo+PiBhbG9uZyB3aXRoIHRoZSBYRFAgcHJvZyBmZCwgc28gdGhhdCBhIGNo
YWluIG1hcCBpcyBhbHdheXMgaW5zdGFsbGVkIHRvZ2V0aGVyDQo+PiB3aXRoIGFuIFhEUCBwcm9n
cmFtLg0KPiANCj4gSW50ZXJlc3Rpbmcgd29yayENCj4gDQo+IFF1aWNrIHF1ZXN0aW9uOiBjYW4g
d2UgYWNoaWV2ZSB0aGUgc2FtZSBieSBhZGRpbmcgYSAicmV0dmFsIHRvIGNhbGxfdGFpbF9uZXh0
IiANCj4gbWFwIHRvIGVhY2ggcHJvZ3JhbT8gSSB0aGluayBvbmUgaXNzdWUgaXMgaG93IHRvIGF2
b2lkIGxvb3AgbGlrZSBBLT5CLT5DLT5BLCANCj4gYnV0IHRoaXMgc2hvdWxkIGJlIHNvbHZhYmxl
PyANCg0KQWxzbywgY291bGQgeW91IHBsZWFzZSBzaGFyZSBhIHJlYWwgd29yZCBleGFtcGxlPyBJ
IHNhdyB0aGUgZXhhbXBsZSBmcm9tIExQQw0Kc2xpZGVzLCBidXQgSSBhbSBtb3JlIGN1cmlvdXMg
YWJvdXQgd2hhdCBkb2VzIGVhY2ggcHJvZ3JhbSBkbyBpbiByZWFsIHVzZSBjYXNlcy4NCg0KVGhh
bmtzLA0KU29uZw0KDQoNCg0KDQo=
