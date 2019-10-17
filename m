Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411CFDB309
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440591AbfJQRMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:12:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56794 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728639AbfJQRMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 13:12:08 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9HHBvGt022930;
        Thu, 17 Oct 2019 10:12:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DZHc5lqghiWs7ihieiEY2nLKGdov1JSnCC9UA/rfskc=;
 b=H6jHjIdjh4Ch4Ayf6IswzkI6NoEl4riy+Fg+EWoi2IPJ1xwSQUIziOBE/jai7xhm+xGg
 X2NzD9eKKcLJDqQ57M3tJfS1YZFUQcroOy6rJGJxili20xagykRkeQJut9dyDVFfXQTB
 fgLIzmOq8hH6yZynJ81TlBQO+x7/jPrtk3I= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vprq996cy-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Oct 2019 10:12:05 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 17 Oct 2019 10:11:57 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Oct 2019 10:11:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fekA+TpqouZFeOh3WeELeiuQ9oS2XUIIRZx6ndkQG4oHPIxvfloOl0pie636cA29icNOnjUZLQULcG4enKhPj/DJ73zthG12j46Zu+bUublS/S+uG2LE98rtnh72tuokLL1wU3Rqt0AQhQUCtwq0EtovVgWERawF7+nwCcxKevv2eVQFFn0nZDFeManaAmhszWxhPo1hFRSS0/SR7RegCkg9fUn9y3z6SsnDBk0tPQ29kY0MZCcHvM3Is8G/BfEp/WgYwpt4iDwZq0EIV4uEJO2hhuXxjyfZEmwffkkMQf4+RCM4iYFyOVPEFOO2BgBMZf978P6Et+UvYhl06GZ1gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZHc5lqghiWs7ihieiEY2nLKGdov1JSnCC9UA/rfskc=;
 b=UDs0546gXnePKGEZ/Okmvbg20AQQOAIynFTTnutE7pam8NbW2L4ljgfOOX6FeokHNP6hl0A0TpdjE2fJubtGkOhe/msIx+WyEJxhGb5YoSf60PqpwYZOjfxwdXJW9DhsuHHkCeoK3C3lpDWXsXDJ9iQTUb4SCcG1hSDKEpVZlrlkb+Yq7ID4kPbRxPeITg2w0VNuGnU5hEpfWSMbvhYutIeqC8732Ia1yKkJu6tMw5Ck6OFd8qxRV534SIZLmCSQmr7SMABzZR3marivrJFljUIW7t/Oamko2kYgKSK7UkuxlyBagkYauM/zVcnmQBt2vckS375CT1xOZP83c1aC1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZHc5lqghiWs7ihieiEY2nLKGdov1JSnCC9UA/rfskc=;
 b=GE+V4fZckEywpJlu4L8UYFOMMm0xNmMOjT/SqLeeBNtGGlaWXiwHJ5DbddmgT9bcjt9eN7mR9MiKDSdlQvsj2K0B41kwq2rNLB1iSeG0dYgGTi02h5qKWDo2RHGs4AbnDDkJVnFEiRFW6SEB4hrBhIupXjOwFBG2jtkOAXUquiU=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1255.namprd15.prod.outlook.com (10.172.175.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Thu, 17 Oct 2019 17:11:56 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9%4]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 17:11:56 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next] scripts/bpf: Print an error when known types
 list needs updating
Thread-Topic: [PATCH bpf-next] scripts/bpf: Print an error when known types
 list needs updating
Thread-Index: AQHVhM99Y5sw/AlKqkOpxiX2giDEdqdfElKA
Date:   Thu, 17 Oct 2019 17:11:55 +0000
Message-ID: <1651dcc4-51a8-dfb2-a4ba-87c61fc0e2b4@fb.com>
References: <20191017094416.7688-1-jakub@cloudflare.com>
In-Reply-To: <20191017094416.7688-1-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:102:2::32) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:c388]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df3104a7-4e04-4854-7426-08d753251cae
x-ms-traffictypediagnostic: CY4PR15MB1255:
x-microsoft-antispam-prvs: <CY4PR15MB125562256C02D09594C6615CC66D0@CY4PR15MB1255.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:229;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(396003)(346002)(366004)(199004)(189003)(4326008)(65806001)(14444005)(65956001)(66946007)(71190400001)(71200400001)(66476007)(66446008)(66556008)(64756008)(6246003)(256004)(6116002)(25786009)(52116002)(76176011)(99286004)(14454004)(478600001)(86362001)(305945005)(7736002)(110136005)(476003)(54906003)(31696002)(102836004)(2616005)(8676002)(446003)(486006)(81166006)(31686004)(386003)(46003)(81156014)(58126008)(316002)(53546011)(2501003)(8936002)(186003)(5660300002)(36756003)(11346002)(6512007)(229853002)(6436002)(2906002)(6486002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1255;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZheZK4xEGvzouz52XuDq02VabwXrxFlSD/8a4z95DsdreCTDnRUXG3N5F63b+CCi88usYke1Lwps79sq0wrK96tBfmOlhjmLD82qEtUO7j6HQSSxPD0DUeV303x6k2LVVTNVUgajsE3PMSYYxD9qoQD0EBj/Ecy5Q9SQS+Mhae/v1jtt9vY4grefi1T+XN8xETe45E+KAXFtqnsyr4hpId8xA7kHf7C0yOzyydhaC7tArOflVBsQsOQIA9INzIHNntAyYXnm2RL8xFEuquvHpdn7n+ItNHTG9EuYNvgdjeW3zKVq2//pQ/FnKdJ7xJIuK6O6/XeF4M5kvt82WESLWE1joKZeVbhMBxVMDu2eG2UVa32T/eMY83bIQg788pVMuHImJXQobRwepd3hsZqloZNgwgC+am+HVTaDSZOdzMM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1FA4CEE38471EC47888869698E402642@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: df3104a7-4e04-4854-7426-08d753251cae
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 17:11:55.9003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LTFddmz9wZC/fzVskzp8tSWvGaOvBWBh0GwLQxvfxZUYObDxCS3Ye2wgKXIojJ74
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1255
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-17_05:2019-10-17,2019-10-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 clxscore=1011 suspectscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910170154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTcvMTkgMjo0NCBBTSwgSmFrdWIgU2l0bmlja2kgd3JvdGU6DQo+IERvbid0IGdlbmVy
YXRlIGEgYnJva2VuIGJwZl9oZWxwZXJfZGVmcy5oIGhlYWRlciBpZiB0aGUgaGVscGVyIHNjcmlw
dCBuZWVkcw0KPiB1cGRhdGluZyBiZWNhdXNlIGl0IGRvZXNuJ3QgcmVjb2duaXplIGEgbmV3bHkg
YWRkZWQgdHlwZS4gSW5zdGVhZCBwcmludCBhbg0KPiBlcnJvciB0aGF0IGV4cGxhaW5zIHdoeSB0
aGUgYnVpbGQgaXMgZmFpbGluZyBhbmQgc3RvcC4NCj4gDQo+IEZpeGVzOiA0NTZhNTEzYmI1ZDQg
KCJzY3JpcHRzL2JwZjogRW1pdCBhbiAjZXJyb3IgZGlyZWN0aXZlIGtub3duIHR5cGVzIGxpc3Qg
bmVlZHMgdXBkYXRpbmciKQ0KPiBTdWdnZXN0ZWQtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlp
bkBmYi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEpha3ViIFNpdG5pY2tpIDxqYWt1YkBjbG91ZGZs
YXJlLmNvbT4NCj4gLS0tDQo+ICAgc2NyaXB0cy9icGZfaGVscGVyc19kb2MucHkgfCA0ICsrLS0N
Cj4gICB0b29scy9saWIvYnBmL01ha2VmaWxlICAgICB8IDMgKystDQo+ICAgMiBmaWxlcyBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
c2NyaXB0cy9icGZfaGVscGVyc19kb2MucHkgYi9zY3JpcHRzL2JwZl9oZWxwZXJzX2RvYy5weQ0K
PiBpbmRleCAwODMwMGJjMDI0ZGEuLjc1NDg1NjllODA3NiAxMDA3NTUNCj4gLS0tIGEvc2NyaXB0
cy9icGZfaGVscGVyc19kb2MucHkNCj4gKysrIGIvc2NyaXB0cy9icGZfaGVscGVyc19kb2MucHkN
Cj4gQEAgLTQ4OCw4ICs0ODgsOCBAQCBjbGFzcyBQcmludGVySGVscGVycyhQcmludGVyKToNCj4g
ICAgICAgICAgICAgICByZXR1cm4gdA0KPiAgICAgICAgICAgaWYgdCBpbiBzZWxmLm1hcHBlZF90
eXBlczoNCj4gICAgICAgICAgICAgICByZXR1cm4gc2VsZi5tYXBwZWRfdHlwZXNbdF0NCj4gLSAg
ICAgICAgcHJpbnQoIiIpDQo+IC0gICAgICAgIHByaW50KCIjZXJyb3IgXCJVbnJlY29nbml6ZWQg
dHlwZSAnJXMnLCBwbGVhc2UgYWRkIGl0IHRvIGtub3duIHR5cGVzIVwiIiAlIHQpDQo+ICsgICAg
ICAgIHByaW50KCJVbnJlY29nbml6ZWQgdHlwZSAnJXMnLCBwbGVhc2UgYWRkIGl0IHRvIGtub3du
IHR5cGVzISIgJSB0LA0KPiArICAgICAgICAgICAgICBmaWxlPXN5cy5zdGRlcnIpDQoNClRoaXMg
bG9va3MgZ29vZCwgdGhhbmtzIQ0KDQo+ICAgICAgICAgICBzeXMuZXhpdCgxKQ0KPiAgIA0KPiAg
ICAgICBzZWVuX2hlbHBlcnMgPSBzZXQoKQ0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9N
YWtlZmlsZSBiL3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUNCj4gaW5kZXggNzViNTM4NTc3YzE3Li4y
NmMyMDIyNjFjNWYgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUNCj4gKysr
IGIvdG9vbHMvbGliL2JwZi9NYWtlZmlsZQ0KPiBAQCAtMTY5LDcgKzE2OSw4IEBAICQoQlBGX0lO
KTogZm9yY2UgZWxmZGVwIGJwZmRlcCBicGZfaGVscGVyX2RlZnMuaA0KPiAgIA0KPiAgIGJwZl9o
ZWxwZXJfZGVmcy5oOiAkKHNyY3RyZWUpL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPiAgIAkk
KFEpJChzcmN0cmVlKS9zY3JpcHRzL2JwZl9oZWxwZXJzX2RvYy5weSAtLWhlYWRlciAJCVwNCj4g
LQkJLS1maWxlICQoc3JjdHJlZSkvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oID4gYnBmX2hlbHBl
cl9kZWZzLmgNCj4gKwkJLS1maWxlICQoc3JjdHJlZSkvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5o
ID4gJEAudG1wDQo+ICsJQG12ICRALnRtcCAkQA0KDQpUaGlzIGlzIHVubmVjZXNzYXJ5LiBMZXQn
cyBhZGQgIi5ERUxFVEVfT05fRVJST1I6IiBhdCB0aGUgZW5kIE1ha2VmaWxlIA0KaW5zdGVhZCB0
byB0cmlnZ2VyIHRoaXMgYXV0by1kZWxldGlvbiBvZiBmYWlsZWQgdGFyZ2V0cyBhdXRvbWF0aWNh
bGx5Lg0KDQo+ICAgDQo+ICAgJChPVVRQVVQpbGliYnBmLnNvOiAkKE9VVFBVVClsaWJicGYuc28u
JChMSUJCUEZfVkVSU0lPTikNCj4gICANCj4gDQoNCg==
