Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCF0DCBF0
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408819AbfJRQwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:52:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14956 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390112AbfJRQwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:52:21 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9IGoQkL002666;
        Fri, 18 Oct 2019 09:52:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cyLOd6chwCVKNXWt2KArO0VXDR4SYSHy4jRiCbr9hIU=;
 b=qeg5fK1ZmLDzyUTZf2/rJ0xU6xQAYjRbrQB9oxTXBZD5aBUoorRhY8e1BQHw2GnakLkG
 KSTneb1hgRyb9jYEmlNLsowq8tv5f1zUWS7yShcc8Z+Cw468fQLfcbN1tLpGDY6AJFlB
 mRlBtVebcD4NwaduRS5K1fWKISkILzi2JU4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vq5d8atvf-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Oct 2019 09:52:08 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 18 Oct 2019 09:51:44 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 09:51:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vw5wwIBSf/Ln4fWLVKDNsVfbLRUk23Q9PeZUil01W3nxZSfL4FVbFWMy2sTkuWxXH2wfFKJ/2rQ9g9JV3OEf9Zh7V50B6Gzx8ySfj/jGRVp4bMmmivzxK3yZ9mjoUdrOFmRMvOVbJfIgKG4RX4wjXLfg4SAdxQm2GhNQU8Z8fIyyyHRtw9s1erWgxSh1VHiU3uCTOytvoOyRCKO5bF0Jnk5G3zw2e7+9774u8f5FbREhSh8bzrYAWtQrJmTjOHKQdSmKWYqF/mHb2MeQ65h5/ErDOF2A/yT/bBaz3vcDVTq5nrfEyco8HCRAFqbFsU59XglrnZSdHGXaNiQR9J+t8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyLOd6chwCVKNXWt2KArO0VXDR4SYSHy4jRiCbr9hIU=;
 b=cAZQ17co5z81z3YU2xHYKsSnwdmUO8Y/3zkfIlhtujfS/31HNwWlGeM5UXfiQJkfOP7e0heHHlkeqrACFrc3IFQl9GLAuljMnBpCdBfqPMaYywM33/z+pLZ0b/j72Rn2a11YJ6OiVZsoWabAfN+kvxuxbJVOHlzI3xIMPBAl3Yk09F8yVFjT3kUnZc3mD4DdzNBnTyBzrkVrBKjw3xhajME0ArC7gwq1fiG890IoozbTmNAYOnszaAfhPL5TjCDbvzaodY/7Tz/ATz3I/52+6yvCxqruxNjjvs4Gcw6B1KmLMRMtueepkAh6rDFZNA9f1XjarwTEILPLIHoXMPU6aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyLOd6chwCVKNXWt2KArO0VXDR4SYSHy4jRiCbr9hIU=;
 b=OHO9s+uY7bdb0uU1dw3T8dVgIYvXaG3rtKWUSjD5Fp3w43hcf3zHGiIxmeKdfVlWzG6cHhVFQdp5TdESgRtH8Ntrsbt6HiC6mdGnX81WLdO+CXTT3pyLa401+TZjvingGZ9uUwGyVJjVCu3ILDWsu5W7QmLXTQroHJ21kdTQc2Y=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1253.namprd15.prod.outlook.com (10.172.176.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 16:51:43 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9%4]) with mapi id 15.20.2347.023; Fri, 18 Oct 2019
 16:51:43 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [bpf-next PATCH] bpf: libbpf, add kernel version section parsing
 back
Thread-Topic: [bpf-next PATCH] bpf: libbpf, add kernel version section parsing
 back
Thread-Index: AQHVhcItF9kDOkJGs02ZqYP8aB13yKdgnRyA
Date:   Fri, 18 Oct 2019 16:51:43 +0000
Message-ID: <4da33f52-e857-9997-4226-4eae0f440df9@fb.com>
References: <157140968634.9073.6407090804163937103.stgit@john-XPS-13-9370>
In-Reply-To: <157140968634.9073.6407090804163937103.stgit@john-XPS-13-9370>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0057.namprd12.prod.outlook.com
 (2603:10b6:300:103::19) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ae05]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3728e9e4-b442-409d-0cc4-08d753eb7439
x-ms-traffictypediagnostic: CY4PR15MB1253:
x-microsoft-antispam-prvs: <CY4PR15MB12536D22EE20A874FB04F434C66C0@CY4PR15MB1253.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:350;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(376002)(366004)(39850400004)(136003)(189003)(199004)(81156014)(6512007)(66946007)(66476007)(66446008)(64756008)(66556008)(5660300002)(2906002)(478600001)(6436002)(4326008)(25786009)(305945005)(7736002)(81166006)(31686004)(8936002)(8676002)(6246003)(14444005)(256004)(46003)(2201001)(71200400001)(99286004)(52116002)(71190400001)(186003)(2501003)(86362001)(102836004)(316002)(14454004)(76176011)(53546011)(6506007)(386003)(54906003)(6486002)(110136005)(65956001)(6116002)(65806001)(36756003)(58126008)(486006)(229853002)(446003)(2616005)(11346002)(31696002)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1253;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wdfT3aZM5NyXkIcWDC064wsTQRm4i7QS0nbQaNK/PE0zrkZGeHt0R5gQd2KcWv4WQdRZvqGwzirx/ssdnVa/yVPywhbpnl0KUL2GObIKxj6lAbWotALj2U6lcLDGa+PB/An1tmY/UE4S01R9V8PB3up4b+TUY/r5wUWlSj6AEEi8skap+sRvhs4biDL6d1onx8BJQXs70l5pqdPtxW5Ykel7M0Cy2ASOmq15NoLylhL0+5XQl9PTzU9X2H9+m5ioZZ7R7Mbm9GlrtdhiIv1s/+objsz/rvXDUNi3Ju8Wcq1DCvZTloqpYmfimJxIDZWSj7nk8zhH5zie+wup0WRaPE83tkRM/P8q1H1NwAR95C1jsBIBvqmfL1Zgwup6f8Ft1pq1uGYALW2Mn2Zh1xUwlMEBoz6E7pWXRqU8bLDN4azjbLg0H0S2/Huu/qDhPbsf
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <33DD1E308C5C6540B06C1D9B938D959C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3728e9e4-b442-409d-0cc4-08d753eb7439
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 16:51:43.0569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mZ+KEzw+ZSp0HYq0M73IefTvj/lGsmnSVuseJADbGeaYFDVZibiIsyLgmCBAHfZv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1253
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 clxscore=1015 mlxscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910180153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTgvMTkgNzo0MSBBTSwgSm9obiBGYXN0YWJlbmQgd3JvdGU6DQo+IFdpdGggY29tbWl0
ICJsaWJicGY6IHN0b3AgZW5mb3JjaW5nIGtlcm5fdmVyc2lvbiwuLi4iIHdlIHJlbW92ZWQgdGhl
DQo+IGtlcm5lbCB2ZXJzaW9uIHNlY3Rpb24gcGFyc2luZyBpbiBmYXZvciBvZiBxdWVyeWluZyBm
b3IgdGhlIGtlcm5lbA0KPiB1c2luZyB1bmFtZSgpIGFuZCBwb3B1bGF0aW5nIHRoZSB2ZXJzaW9u
IHVzaW5nIHRoZSByZXN1bHQgb2YgdGhlDQo+IHF1ZXJ5LiBBZnRlciB0aGlzIGFueSB2ZXJzaW9u
IHNlY3Rpb25zIHdlcmUgc2ltcGx5IGlnbm9yZWQuDQo+IA0KPiBVbmZvcnR1bmF0ZWx5LCB0aGUg
d29ybGQgb2Yga2VybmVscyBpcyBub3Qgc28gZnJpZW5kbHkuIEkndmUgZm91bmQgc29tZQ0KPiBj
dXN0b21pemVkIGtlcm5lbHMgd2hlcmUgdW5hbWUoKSBkb2VzIG5vdCBtYXRjaCB0aGUgaW4ga2Vy
bmVsIHZlcnNpb24uDQo+IFRvIGZpeCB0aGlzIHNvIHByb2dyYW1zIGNhbiBsb2FkIGluIHRoaXMg
ZW52aXJvbm1lbnQgdGhpcyBwYXRjaCBhZGRzDQo+IGJhY2sgcGFyc2luZyB0aGUgc2VjdGlvbiBh
bmQgaWYgaXQgZXhpc3RzIHVzZXMgdGhlIHVzZXIgc3BlY2lmaWVkDQo+IGtlcm5lbCB2ZXJzaW9u
IHRvIG92ZXJyaWRlIHRoZSB1bmFtZSgpIHJlc3VsdC4gSG93ZXZlciwga2VlcCBtb3N0IHRoZQ0K
PiBrZXJuZWwgdW5hbWUoKSBkaXNjb3ZlcnkgYml0cyBzbyB1c2VycyBhcmUgbm90IHJlcXVpcmVk
IHRvIGluc2VydCB0aGUNCj4gdmVyc2lvbiBleGNlcHQgaW4gdGhlc2Ugb2RkIGNhc2VzLg0KPiAN
Cj4gRml4ZXM6IDVlNjFmMjcwNzAyOTIgKCJsaWJicGY6IHN0b3AgZW5mb3JjaW5nIGtlcm5fdmVy
c2lvbiwgcG9wdWxhdGUgaXQgZm9yIHVzZXJzIikNCj4gU2lnbmVkLW9mZi1ieTogSm9obiBGYXN0
YWJlbmQgPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbT4NCj4gLS0tDQoNCkluIHRoZSBuYW1lIG9m
IG5vdCBicmVha2luZyB1c2VycyBvZiB3ZWlyZCBrZXJuZWxzIDopDQoNCkFja2VkLWJ5OiBBbmRy
aWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KDQo+ICAgdG9vbHMvbGliL2JwZi9saWJicGYu
YyB8ICAgMjEgKysrKysrKysrKysrKysrKysrKystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIwIGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQoNClsuLi5dDQoNCg==
