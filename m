Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6844A257F8B
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 19:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgHaRZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 13:25:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49836 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726927AbgHaRY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 13:24:59 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VHJEBX029090;
        Mon, 31 Aug 2020 10:24:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3x3Hof/MYjP3pwUkDz59bGBPFIle4peJNbYgPf4kgM8=;
 b=rp/x8EHbATpuXn3c8Vxgg7+/+ckAaO8JMn9ScoJfXb3ZKXGfSZqH9Q1P0OI2mBlruiIA
 7JxbWOUgg267s3/Hi1I0HmZ1e8kUOgtq5G6m8m/7lpOpzlVj9OFYJZajIQIkDOn5Ynd0
 AQ83+P2+AO3hHrB/PwuD8iKcm0JMeX4zJCA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 337muh0q5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 31 Aug 2020 10:24:43 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 10:24:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGm1V/ZfMgOi1kMAWbia5lr4nkaKsXNcVe7MO5ePSvzHRO8udpRy/SUUKgrhnncp34FOweSxU2t2JgJJ7Bta67AcIRiJsEHHQSSI1DlbN08novNqWosbJ3JF6S/5dY/UHiFum/XzdR/Z0qqyclJV/X6DPypUufxrLTKH46+60PMTH3clV/alGhs/JIuv/k3LBI4kkZoNAHQYoKr8l2MGY2YNv9Nuh0dO/8GzN6s9Yjf7a3nUkylgrKUFe6ekw/Kctkomct2eSFud4cD9+b3zB1ELotddl84Xe0kQ1YQXoABFChqn/qQXqFIkU/Ly3atTRqwc2k8KLSTvPOg19OSg/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3x3Hof/MYjP3pwUkDz59bGBPFIle4peJNbYgPf4kgM8=;
 b=iyuclP1uDT2s7UBDHtCOMYntpAi+b3ALP4mMMNXqrHD7DirTR4mUu2Jliu/x+dRpPGkSHS/nHqx1Bv3BbAmgabi9+2Q4dql9LrQA6dVjWDQkq88XK2p3n/B47NeMjrHmZ7LbHu3G+mhIB5LfgtM3DsgokwVNnGGvCPE4fgpZ58HQSlF0FVN93jN8CN2hGq7kzybuyE1WXG4bD2Vf5nN3P/w0l/plK6BXssxBCO9xQG0bNMer/FUh2pM8Lge9W7GJ6fxYvq0PA8h/G3p2EYrxUB38PqNddPqzr6eVyH0B+srD9s3kEmdAuTNq9sMHNoU1R0HxpCmzhELlHjLnLeb3Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3x3Hof/MYjP3pwUkDz59bGBPFIle4peJNbYgPf4kgM8=;
 b=SdKONZLIA/STU+LGUiMmBZhJH8iIA8JSf8EyCzajW0FezzHnCB3aiVQS+jlOVfhOnbPZ/l3FZcSHMcBueiY9+UxMVwSYwasu5EBgDSjiJ45Mtu9zTqMgEflXMnCtGzH1RrTe8Fa08bvTgXorsvdDjBVv2XS8AUDX3nojHbIfjhU=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB4087.namprd15.prod.outlook.com (2603:10b6:a02:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Mon, 31 Aug
 2020 17:24:38 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 17:24:38 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: Fix build without BPF_LSM.
Thread-Topic: [PATCH bpf-next] bpf: Fix build without BPF_LSM.
Thread-Index: AQHWf7Q2p+E1qYQYHkaZ4ci27gnDd6lSd8uA
Date:   Mon, 31 Aug 2020 17:24:38 +0000
Message-ID: <3669E0C5-8982-465C-8C33-87015F4D970D@fb.com>
References: <20200831163132.66521-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20200831163132.66521-1-alexei.starovoitov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:6d27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81e7a6d0-578a-4af9-6b86-08d84dd2bd6c
x-ms-traffictypediagnostic: BYAPR15MB4087:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB408781AEA35E54D7F50B9CD0B3510@BYAPR15MB4087.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lMQhjcgx6pJtwTL2NfxfdC+Aj9Kcw1FKZVLFK/lmanthtbTI87Ma0mDB/T6/4nTYowg6eac0KYbrwqD1lyybXOPYEcT5bPIY+RcbVXyt0BYbIrfxnKxlWZ71NwVggVa8szyC32RRfhTreFWzgNW38W2EhiCQeHDvij/8z/i8QTR6f9okulWgWr8MR5UOgFr5N2EAoZfSt+39qKvcru6nCARwpkqxngM3QVxYjnQg/zUtvM3SG9eK4juZpaBBMpLA7TOxbeVAXRuEndCF04vYMAcOZ8qFXPLXRLZrLGKYpmIGlGSL8wymwgYHBQ4OEeg1U6dSLsN3iOTdDNOY+W8VBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(39860400002)(376002)(4744005)(4326008)(2616005)(6916009)(33656002)(6512007)(5660300002)(86362001)(66946007)(66446008)(64756008)(66556008)(76116006)(66476007)(186003)(8676002)(478600001)(54906003)(36756003)(53546011)(71200400001)(8936002)(316002)(2906002)(6506007)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: STNDQcWMbQldk3NrVE7T1vzXuTboG6W7unUw6QOdtXPzahXaUSIVu/fdhdmQwpYqTIjwwrmN47O5rMgVSM2dQEocYOlG8bZUtb6lknOJruz2qauz0l3ry4AzqjNit2vQTKjB0kAw+hUiRBNCPEwc6wjqpKua9Poj3WQTa/K9OKZTjHY1lVSewgBpM2DUGMs9MNJvAiRmxDLg2QLidSGhZPBFoa2M7CMsy2xfEI+CA3ajbE3ZALmb3fwN6vXE+HhtCMSQExhoFcKY9s81v84JXoE1+9+op4IRuO73lXw0XGMmXsYmtTF6q5XMmgF6R9WlomYZQpdIxFtWaSPC+RgEMBFbhUpqebWgdJOMa6nqWtaWgkOmEoCHw0C9GeGdGwk113meru3782iLY1YoD0pPiG1l6E2Ax9plWdpPYKwA/TeoSsLJkhc9UrSmC4SQbbZDtwV7vEC5nB1j2y1aaQ9s8bvSUZ9IWmmGHZtEeTUSrS0YxAxhz9xyulx8NbP0iKtLkpnZ2rYKdyjpti4CosJoZgW2Ft7JtvHyDZAJDTm+uQg/lOWkaQ3l/f+pQCgNU6hfqHl896dEfMS3l9fl7fnvuWsRACsODJlaxYjrSnHziQcJ5AxvMp0Q8OM9H85c2B6P3mxqGhbqimDzJNxncBQKcTw5K8DjTt7MjTiFY6uOsOCNUq8OvnwzVdkDbQayHhp6
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDBC58234CFC5045A5B8C86FBCAE2A55@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e7a6d0-578a-4af9-6b86-08d84dd2bd6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2020 17:24:38.7836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tpUY96bPcxh1+SyH36rIhNCYpytJuE+Fsjiy+ntzgRikayckJBwB9z7Njg1jWCQfbXchzWHhxln2w1soZNZTgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4087
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_08:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 phishscore=0 adultscore=0 malwarescore=0 spamscore=0 clxscore=1011
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008310103
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gQXVnIDMxLCAyMDIwLCBhdCA5OjMxIEFNLCBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFs
ZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+IHdyb3RlOg0KPiANCj4gRnJvbTogQWxleGVpIFN0
YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4NCj4gDQo+IHJlc29sdmVfYnRmaWRzIGRvZXNuJ3Qg
bGlrZSBlbXB0eSBzZXQuIEFkZCB1bnVzZWQgSUQgd2hlbiBCUEZfTFNNIGlzIG9mZi4NCj4gDQo+
IFJlcG9ydGVkLWJ5OiBCasO2cm4gVMO2cGVsIDxiam9ybi50b3BlbEBnbWFpbC5jb20+DQo+IEZp
eGVzOiAxZTZjNjJhODgyMTUgKCJicGY6IEludHJvZHVjZSBzbGVlcGFibGUgQlBGIHByb2dyYW1z
IikNCj4gU2lnbmVkLW9mZi1ieTogQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4N
Cg0KVGhhbmtzIGZvciB0aGUgZml4IQ0KDQpUZXN0ZWQtYnk6IFNvbmcgTGl1IDxzb25nbGl1YnJh
dmluZ0BmYi5jb20+DQoNCg0KPiAtLS0NCj4ga2VybmVsL2JwZi92ZXJpZmllci5jIHwgMiArKw0K
PiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEva2Vy
bmVsL2JwZi92ZXJpZmllci5jIGIva2VybmVsL2JwZi92ZXJpZmllci5jDQo+IGluZGV4IDNlYmZk
YjdiZDQyNy4uYjRjMjJiNWNlNWEyIDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvYnBmL3ZlcmlmaWVy
LmMNCj4gKysrIGIva2VybmVsL2JwZi92ZXJpZmllci5jDQo+IEBAIC0xMTAwOCw2ICsxMTAwOCw4
IEBAIEJURl9TRVRfU1RBUlQoYnRmX3NsZWVwYWJsZV9sc21faG9va3MpDQo+ICNpZmRlZiBDT05G
SUdfQlBGX0xTTQ0KPiBCVEZfSUQoZnVuYywgYnBmX2xzbV9maWxlX21wcm90ZWN0KQ0KPiBCVEZf
SUQoZnVuYywgYnBmX2xzbV9icHJtX2NvbW1pdHRlZF9jcmVkcykNCj4gKyNlbHNlDQo+ICtCVEZf
SURfVU5VU0VEDQo+ICNlbmRpZg0KPiBCVEZfU0VUX0VORChidGZfc2xlZXBhYmxlX2xzbV9ob29r
cykNCj4gDQo+IC0tIA0KPiAyLjIzLjANCj4gDQoNCg==
