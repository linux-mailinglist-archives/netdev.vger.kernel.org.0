Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B436D935
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 04:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfGSCzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 22:55:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62266 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbfGSCzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 22:55:52 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6J2r8Yx028594;
        Thu, 18 Jul 2019 19:55:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WD9IIFuQ7ORP+GnVH124/fzf86aJuzMx/OFJplU2HhU=;
 b=HzcuApUg7tXC+rAr2eFUzUc4pqnL1Dx0DJnkBl/ENE4aQjm+8KU2VCL2tOtJ7s2zWihY
 YaHAuUugTifDTy1nBvg3MSzXFCgjQmYzqp6i8Ll/+4RjLPnOpxq5XjSBc+Y9naciOMbD
 F9iUtroSGSGbaBDp5Orlm+4W3j2d9d2Lj8Y= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ttv4aa97y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Jul 2019 19:55:47 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 18 Jul 2019 19:55:46 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 18 Jul 2019 19:55:45 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 18 Jul 2019 19:55:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llT11QJW7hMs2qr3C4qMHZ3MFNW9vT4iMmO4XV9DGOg0xo44FIllsHwUI8zqADIi6neKX0ZrXVcX8nFgYdReIWp57huVdL7TKJ/o8xKSpzhe8SAt7FBDnTpuztY5hv8vEd6Wcxjra4QDZFCOOjyZ3X8YsdOduBvBIENztUajuzg6B95hGLLKLyHrDxKZZ/NVlDJb4azmKIiVYoSfBnSlITCocWcWC59YAF/MTwhWxgo0xo61WXoNTPLBBN8PVkS4L1obLzuT7Pt3BCOAi0bfr4tj/LcBRw8hRvA3YwDqv4CCrAHZNYpKxJ3xw77NchHNYQeTUNJxJKnsS4wzUqgtgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WD9IIFuQ7ORP+GnVH124/fzf86aJuzMx/OFJplU2HhU=;
 b=fuOdO3BcwWPpbT4lukVIC9z3fz5uXRwNnA2ye8GxdY/pcIGdvWguGnLavyXDdg4aa/qjFTkdd0jv5l0ljmFwp7j5L9I2ZlwnDX7gV9NNSSlVrYmVkfgR7wSLRKX0l+AjT2lN4lMDJoEADbVkrQ8X57+GotANPWtag7maRbgr88PAOW3O0NotfhEJHmn9q6Gp6Yzt1hIPvBNM1EhM1xlTnCy1V1sqUHoA9GVfiB07nI/nMo2HnwlZ9a0vhlca45SxQ/QcAetoKTNR4mM9BqWBQfSVuobqHcc0/aihuu4afg/gCnq70vk+XRzHMjJayMV0Xco7l+2lqp1WZ8yv9DPOcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WD9IIFuQ7ORP+GnVH124/fzf86aJuzMx/OFJplU2HhU=;
 b=fHYYlyZlYeQcN0Kpb3IPt3hdaP3xSVpRPoKZgAcYgJPsxg6gW4Z1n/qQaNevsscm/J1TahSjEI8HOcc8yFaJKQwWvvlbotSJV+NnYdsceXkZQBF8qyjBLvo2bGIQW3y/1Fb14W2YGKBBPQOELI1SbUwrHukMPR5U21G9r1Jhrx0=
Received: from BYAPR15MB2311.namprd15.prod.outlook.com (52.135.197.145) by
 BYAPR15MB2357.namprd15.prod.outlook.com (52.135.198.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 02:55:44 +0000
Received: from BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::849a:6325:7aee:17de]) by BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::849a:6325:7aee:17de%6]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 02:55:44 +0000
From:   Lawrence Brakmo <brakmo@fb.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH net] tcp: fix tcp_set_congestion_control() use from bpf
 hook
Thread-Topic: [PATCH net] tcp: fix tcp_set_congestion_control() use from bpf
 hook
Thread-Index: AQHVPdmpGv4UAJPa20qU5dFRJps4XqbQyd4A
Date:   Fri, 19 Jul 2019 02:55:44 +0000
Message-ID: <2B90C3B0-0A52-4D0A-ADA7-63AAC3C4414D@fb.com>
References: <20190719022814.233056-1-edumazet@google.com>
In-Reply-To: <20190719022814.233056-1-edumazet@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1a.0.190609
x-originating-ip: [2620:10d:c090:200::3:f18e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 611f3dbc-ebba-4af8-0b4d-08d70bf49818
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2357;
x-ms-traffictypediagnostic: BYAPR15MB2357:
x-microsoft-antispam-prvs: <BYAPR15MB2357400A57E7A5914E98CCD1A9CB0@BYAPR15MB2357.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(39860400002)(136003)(366004)(199004)(189003)(14454004)(68736007)(6486002)(8676002)(8936002)(305945005)(7736002)(110136005)(71200400001)(71190400001)(6436002)(186003)(99286004)(66476007)(66556008)(64756008)(66446008)(81156014)(81166006)(36756003)(54906003)(476003)(2906002)(66946007)(91956017)(76116006)(446003)(256004)(6512007)(86362001)(478600001)(11346002)(53936002)(486006)(46003)(76176011)(2616005)(25786009)(6506007)(4326008)(229853002)(53546011)(58126008)(316002)(6116002)(6246003)(102836004)(33656002)(5660300002)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2357;H:BYAPR15MB2311.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EyWXobUxQaHFXZYzPIu3NRAvjqvqDWQCGA/7Lgk6ttuetCJFkdbxC6WE9ze1Ik0+Sew8VVN/W6vJ8PLQ9LzfktvNvIL6UFwxLRc5Es4STUzRh9M8c0oCbhhlNMVk3+HeuRBT2Zu7KJjjHF8EbWOfbjTH4Y/QIBlwd6sNEs1V8FKll1AiD51hJJvnxEdQNRXi91+bT5pL2HaAbT2ylBcrdW6jDERaufGmescCbewbAhIbvVVKRr+Uion5Xd1AL6lrP0Dh9lBEYDdXvvVt4U+ez7JoZBfcS1FTVuJ4paBPo0Z2aVTkR6Z1rWpf+RjvIc88j8FJG1spj91n2jJmgs5RFK2dCeK1oYvcwZrrtdSBGdn4DSDVJ3GtSxeNGzodPGslyq1SJu/myhI72lvEp6UkgAiH5kWpukdHTgRvjCKYNpg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59F51B52FF53BA42BF6E01C719F2BECD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 611f3dbc-ebba-4af8-0b4d-08d70bf49818
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 02:55:44.6033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: brakmo@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2357
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-19_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=748 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907190031
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8xOC8xOSwgNzoyOCBQTSwgIkVyaWMgRHVtYXpldCIgPGVkdW1hemV0QGdvb2dsZS5jb20+
IHdyb3RlOg0KDQogICAgTmVhbCByZXBvcnRlZCBpbmNvcnJlY3QgdXNlIG9mIG5zX2NhcGFibGUo
KSBmcm9tIGJwZiBob29rLg0KICAgIA0KICAgIGJwZl9zZXRzb2Nrb3B0KC4uLlRDUF9DT05HRVNU
SU9OLi4uKQ0KICAgICAgLT4gdGNwX3NldF9jb25nZXN0aW9uX2NvbnRyb2woKQ0KICAgICAgIC0+
IG5zX2NhcGFibGUoc29ja19uZXQoc2spLT51c2VyX25zLCBDQVBfTkVUX0FETUlOKQ0KICAgICAg
ICAtPiBuc19jYXBhYmxlX2NvbW1vbigpDQogICAgICAgICAtPiBjdXJyZW50X2NyZWQoKQ0KICAg
ICAgICAgIC0+IHJjdV9kZXJlZmVyZW5jZV9wcm90ZWN0ZWQoY3VycmVudC0+Y3JlZCwgMSkNCiAg
ICANCiAgICBBY2Nlc3NpbmcgJ2N1cnJlbnQnIGluIGJwZiBjb250ZXh0IG1ha2VzIG5vIHNlbnNl
LCBzaW5jZSBwYWNrZXRzDQogICAgYXJlIHByb2Nlc3NlZCBmcm9tIHNvZnRpcnEgY29udGV4dC4N
CiAgICANCiAgICBBcyBOZWFsIHN0YXRlZCA6IFRoZSBjYXBhYmlsaXR5IGNoZWNrIGluIHRjcF9z
ZXRfY29uZ2VzdGlvbl9jb250cm9sKCkNCiAgICB3YXMgd3JpdHRlbiBhc3N1bWluZyBhIHN5c3Rl
bSBjYWxsIGNvbnRleHQsIGFuZCB0aGVuIHdhcyByZXVzZWQgZnJvbQ0KICAgIGEgQlBGIGNhbGwg
c2l0ZS4NCiAgICANCiAgICBUaGUgZml4IGlzIHRvIGFkZCBhIG5ldyBwYXJhbWV0ZXIgdG8gdGNw
X3NldF9jb25nZXN0aW9uX2NvbnRyb2woKSwNCiAgICBzbyB0aGF0IHRoZSBuc19jYXBhYmxlKCkg
Y2FsbCBpcyBvbmx5IHBlcmZvcm1lZCB1bmRlciB0aGUgcmlnaHQNCiAgICBjb250ZXh0Lg0KICAg
IA0KICAgIEZpeGVzOiA5MWI1YjIxYzdjMTYgKCJicGY6IEFkZCBzdXBwb3J0IGZvciBjaGFuZ2lu
ZyBjb25nZXN0aW9uIGNvbnRyb2wiKQ0KICAgIFNpZ25lZC1vZmYtYnk6IEVyaWMgRHVtYXpldCA8
ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCiAgICBDYzogTGF3cmVuY2UgQnJha21vIDxicmFrbW9AZmIu
Y29tPg0KICAgIFJlcG9ydGVkLWJ5OiBOZWFsIENhcmR3ZWxsIDxuY2FyZHdlbGxAZ29vZ2xlLmNv
bT4NCiAgICAtLS0NCg0KQWNrZWQtYnk6IExhd3JlbmNlIEJyYWttbyA8YnJha21vQGZiLmNvbT4N
ClRoYW5rcywgRXJpYyENCiANCg0K
