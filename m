Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1174CF5A7F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfKHWBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:01:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24534 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfKHWBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:01:00 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8M0fSX004394;
        Fri, 8 Nov 2019 14:00:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Lw+rT5aG/ibQhxR43DqQXqJ1USNzGEkmo/gnqsrGh6s=;
 b=HBCsvhM2n5WJq2HJgaKN2q7Ie7O9a1kAlQoNDO4Dg8JkrB8GVeSqqS005fpGfWD3aTp4
 RL7YssC5mmtS4PsTCJWhF8cVNAle/KEht6bTCAL6bYRVycFPK3ay8PfXjMqGINF7a0si
 KWGC5BOX1KFdq3wm24yAAx6OHLB8XMDxUt8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5bryhpvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Nov 2019 14:00:44 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 14:00:43 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 14:00:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJD/jH5iBaX8sksOQzgFdBvIUtRR6FoSi5+pBc69C/CttfUsMMNL7kG6h/9sKbLXG9Waj7Db9tVUKHZWhMKLDhgBymGQHo2/yVTf+p0Gjvu2nIrQiws7k3/RpY4p56Or4JD+3T8rPz0D3fP2CWqqRHVQKIsxlfq0iQTihlBvLaYI9jMWcY5zUXry9AcveimcX9CmbD0iLabyjCm7Cm7w8Dh53bL3GDoHjD33IlIdwQWSh19aRmcZmoCjbiIHlaDXLz5xpAR2XaZTABjOOspu/39HqS89i4T+OYgnivtCJVE8lP7Y3m27BEikQpD+nZ1Kd+Mwyp8zG5H6DLtAy2LdvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lw+rT5aG/ibQhxR43DqQXqJ1USNzGEkmo/gnqsrGh6s=;
 b=l1TAxUhFCAce+S8Qsdfza17vMp2VSXMf6RlS34GPoo7h3SCF10meurd6NWMujct/0TqVE1fQCTZBo//oDsW/KsB/U0z6V2lhEZhxClF9X8NKftNKLJCkgz+epyHngHcm++qPNGC4+WzwTgVpCx999PLXVrboYuK56OHuqpH+Zn7o+HIDkBJGmO5VCM1+ktR6aR4tI6Vk29I7L4BC20sy1gNMYwe0ATbdnIwZ8zGryvHtAscaQkK8+8x3xeztXGA5ZRaP1uDvH5IiWkpL0rlQShjT3/S9gqUUTK/BTYIKcDnpxWbSWFgD69KW5XLzo0UwX8faR9B6KH8SNbd/bCgq3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lw+rT5aG/ibQhxR43DqQXqJ1USNzGEkmo/gnqsrGh6s=;
 b=GR3Bok7JHe1ohul/j4xCgCYew4UScmscNIuycxcqN805wcsfnjk2HdxBakqub2EB+yyPp2aQ5/kY9uYoiin7xz1S8BGswmdkDuKH9HFjcLAdL3eJJjldrX/DQqqx/MGI5JVXPy5Eg6k7a7BM2uQKKjm8W05HVu+X8z45z0OtiQ8=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1695.namprd15.prod.outlook.com (10.175.142.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 22:00:42 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 22:00:41 +0000
From:   Song Liu <songliubraving@fb.com>
To:     David Miller <davem@davemloft.net>
CC:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>, "Martin Lau" <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 2/6] selftests/bpf: Add tests for automatic
 map unpinning on load failure
Thread-Topic: [PATCH bpf-next v2 2/6] selftests/bpf: Add tests for automatic
 map unpinning on load failure
Thread-Index: AQHVlnwvmk21n9vqbEq+456ORL+ZiaeBzbOAgAAFQIA=
Date:   Fri, 8 Nov 2019 22:00:41 +0000
Message-ID: <61A78400-E3E8-4153-8ACD-4FB313C5D2D0@fb.com>
References: <157324878503.910124.12936814523952521484.stgit@toke.dk>
 <157324878734.910124.13947548477668878554.stgit@toke.dk>
 <20191108.134153.1710494153341797450.davem@davemloft.net>
In-Reply-To: <20191108.134153.1710494153341797450.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5576234-2696-443e-a005-08d764971909
x-ms-traffictypediagnostic: MWHPR15MB1695:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB16954586294AF95CF6146FE0B37B0@MWHPR15MB1695.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(136003)(39860400002)(366004)(376002)(189003)(199004)(36756003)(76116006)(6916009)(66556008)(6436002)(305945005)(4326008)(6246003)(5660300002)(14444005)(7736002)(14454004)(8676002)(25786009)(66946007)(256004)(64756008)(81166006)(11346002)(99286004)(478600001)(102836004)(81156014)(66446008)(66476007)(2616005)(486006)(476003)(2906002)(33656002)(8936002)(4744005)(229853002)(6116002)(316002)(66574012)(86362001)(446003)(54906003)(6512007)(6506007)(46003)(53546011)(186003)(71190400001)(71200400001)(50226002)(76176011)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1695;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RgtAX5zxNNIoNu5SB11xGLS0WTR+goBWH8lV0Jio+Bow2wuL6rBqo7/p1uIzd6MDTJ8Jje4A3GXIyKAmCeIQ5jhDnxdTVUs2XEZ4UvBpYvBAch0IJUEJMiuD+DD6pRANLP/N2a/rW8AzAp/PUiE/eDcFPVytq2A/6LV03oFksjPYSdjbBAHkHTqB4fekzqt1RYhmldIqtAL32yX5U5aldB3OPJm0uW1Fkm2egsJ0Nwy3UW0sMpYuR3JsY5IHqHWll4su+tmDUwtMKOKVufGIPkwprGySONZQdBYV1AlTvbKzjSNPeupFGQqQjqwABTUjVLUcRysgxcUvdyTA6vIweWNgaTAJIOlgOg+6FpoW8lgSBCxQzxpPUAFT3yAvjs8Rqf4I2W+RRRT4Y4pk6vvCRHeeEeYCrgAOrZjOq9J73IhmnrVh/s7FeJKfQXr5NPjw
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE8DE0D9D919F14995B99FA514D3E98B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b5576234-2696-443e-a005-08d764971909
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 22:00:41.7545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p0RUEpPs57qStn2Zi6+BaxLcYbFy7ME8GFGNyaK2skIZtIIt/ymQ9S/BnttP5QmYERrDwPVqheryHvA/GnUBwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1695
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_08:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 adultscore=0 spamscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=872 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080211
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTm92IDgsIDIwMTksIGF0IDE6NDEgUE0sIERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD4gd3JvdGU6DQo+IA0KPiBGcm9tOiBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4g
PHRva2VAcmVkaGF0LmNvbT4NCj4gRGF0ZTogRnJpLCAwOCBOb3YgMjAxOSAyMjozMzowNyArMDEw
MA0KPiANCj4+IEZyb206IFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiA8dG9rZUByZWRoYXQuY29t
Pg0KPj4gDQo+PiBUaGlzIGFkZCB0ZXN0cyBmb3IgdGhlIGRpZmZlcmVudCB2YXJpYXRpb25zIG9m
IGF1dG9tYXRpYyBtYXAgdW5waW5uaW5nIG9uDQo+PiBsb2FkIGZhaWx1cmUuDQo+PiANCj4+IFNp
Z25lZC1vZmYtYnk6IFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiA8dG9rZUByZWRoYXQuY29tPg0K
PiANCj4gQWNrZWQtYnk6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCg0K
QWNrZWQtYnk6IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+
