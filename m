Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E661E7F39
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 05:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbfJ2Ecp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 00:32:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23980 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbfJ2Eco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 00:32:44 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9T4Ts2q003620;
        Mon, 28 Oct 2019 21:32:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=D5GmkK58mAUFy4hMYMV4uOISlPbimg3ru/G7B/I1zPs=;
 b=P3X8XdNucSPSu4NvxbMSt+WSnWy4qKIBFgpvsL80RXBLNU+HkardUbm0ChhluEx4CG55
 D4p2Za0vjxRVnUCvmKUvgCDakGCnyYcHPmJ7gvvewtHGU3PV3AQj4RSnZgSC1FDWeU61
 FssyhuZxm6WyFQXyQkSiZR2ODaaQU5Khdm0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vw5teh30c-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Oct 2019 21:32:30 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 28 Oct 2019 21:32:23 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 28 Oct 2019 21:32:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4PY2hlRDfwJ2P+Xo4CpUQ4xlOAm34dKhVhp/PPvziVexsUF2jnJ+QL5nsftR87VciHyz/14odkMUxQD5XMGgWxPcKDnYBv+LcY7lhK9iLXPRzs4qtOLa0dqbqnLfgcP+ZhNNli5IF9BbKQxMvQ5awM99DV90/DACLfNDWk+lr2l2XjQB9WtyuxoSJYN/bFjCPbFQ4KaNI9DtuaO4VBpMXKjWS04/biCwF60RE9aOa6mZdaVL7/YqBDHJHcM2k0jR3lZWdmdsRAiZQUPSEOpe2f3oFfal+Pjym6He9DqICEEFaFYb62i1Rn+pfTbmGmHGErpvqqnr1HHQIbfRQA4OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5GmkK58mAUFy4hMYMV4uOISlPbimg3ru/G7B/I1zPs=;
 b=biqTPsuTonOK8YKbE/8s813HVGTp6/3Ne/Py5juJGOL+nklwqwVvmWBCpzFAKuPBsWgL/OpHUmtJ52MURjux9Hj3RSNCwbKfbfWYqrJg0Hv/NIlTeIj04gqij9SHrjdpSZduIxXuHd5MPVk6qbBq5TcWtBg72ekVp6JrbQ36MoGsGB48bSRWjzLA9dvNXDT1BzDEEDro6Hc7MxX/o2G+XpN5YEnuXJVnwW/SmnTTiIiPkzSEkWLfYSTf1DgpSl3XzquL8vzgC8Pclan59oToeHuXTyc3mRFMAcY86abh99SLHxlcwqYGdnxfP1f03H2NVNTwNDo8jTDrfES8HZSjUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5GmkK58mAUFy4hMYMV4uOISlPbimg3ru/G7B/I1zPs=;
 b=St0mVj7lQMkZHpKmag9p8zZO6zlDoV1YzTV6pReFP/2wXeqi4GfTz8Tv/acFiZjvWEiiy/qKMIPYLSjcqjwlg9GfqhBdOJ/3+YWsqYL76d7g2n1l3qewVv53XJXpiTRDln8j8OhGe963gsZwBrYNmbGiNpoc7Ub/4srIVFmdOg0=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1766.namprd15.prod.outlook.com (10.172.79.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.23; Tue, 29 Oct 2019 04:32:22 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9%4]) with mapi id 15.20.2387.025; Tue, 29 Oct 2019
 04:32:22 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: Enforce 'return 0' in BTF-enabled raw_tp
 programs
Thread-Topic: [PATCH bpf-next] bpf: Enforce 'return 0' in BTF-enabled raw_tp
 programs
Thread-Index: AQHVjghhROJ5+aIOHUydSUbUrMZDyadxB6KA
Date:   Tue, 29 Oct 2019 04:32:22 +0000
Message-ID: <7493d20b-9056-3a2a-5f89-5bb9b2b933cf@fb.com>
References: <20191029032426.1206762-1-ast@kernel.org>
In-Reply-To: <20191029032426.1206762-1-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0025.namprd02.prod.outlook.com
 (2603:10b6:301:74::38) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::2cc8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e321497-9583-430d-2dad-08d75c28fdd3
x-ms-traffictypediagnostic: CY4PR15MB1766:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB176650E6F0879503D556EBF6C6610@CY4PR15MB1766.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(346002)(396003)(366004)(199004)(189003)(2501003)(46003)(4326008)(5660300002)(316002)(36756003)(66476007)(66946007)(66446008)(64756008)(66556008)(6512007)(31696002)(71190400001)(6246003)(71200400001)(102836004)(86362001)(76176011)(14454004)(110136005)(54906003)(53546011)(486006)(58126008)(256004)(25786009)(5024004)(186003)(386003)(6506007)(52116002)(478600001)(2906002)(6116002)(6436002)(31686004)(81156014)(6486002)(11346002)(476003)(2616005)(7736002)(99286004)(229853002)(81166006)(8936002)(65806001)(65956001)(305945005)(446003)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1766;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4b7Gs7+PhSEY0kS7c6AGMYr/wXmUDDAkM6RTLjt2boLFUlkJO0Tha2VYEmMwedeVT3edehtZzZqAIEkiWWbyAzmUS969ru3faDMoAKzi33uQgVB7ekyF225OuHBmmU9auZ7smqf9Rf42UtAIrfFEP/w2GjPxzrjk6WRj+pfhoeYF6UrrLmfVZeLZBuECFvQ0mHAafSdxIx14YEyyDa6y836Cm/u9OfqtpAMwWaFCNpC2UeR7IPtPhuFS7Q9TkMQkFRTlSYkYp+SmDYpDoZ/vBT4086KogJUN7xnldzERsZ91EV/AVwxDVKqEb/GyI5C3S1zV0PLZBVzBLAIayd8HI8vvq7LYYHCtXna5b7/I4oEYVgTZRJOIGLiYPzZ7R2zeZRZkt7AyEa5n4XGluOne56zGPmfqTRfG2/rXgceAO827OeCi4pHygI+xqe7z6zWs
Content-Type: text/plain; charset="utf-8"
Content-ID: <F87338C42480B24B91A9C079553260AA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e321497-9583-430d-2dad-08d75c28fdd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 04:32:22.4636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LDuiuqnaSavcqEz2irnuRzmF0iixONM0f2ySVGcKTphfZXzF65drA4w6lUSjzmSg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1766
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-29_02:2019-10-28,2019-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910290047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMjgvMTkgODoyNCBQTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPiBUaGUgcmV0
dXJuIHZhbHVlIG9mIHJhd190cCBwcm9ncmFtcyBpcyBpZ25vcmVkIGJ5IF9fYnBmX3RyYWNlX3J1
bigpDQo+IHRoYXQgY2FsbHMgdGhlbS4gVGhlIHZlcmlmaWVyIGFsc28gYWxsb3dzIGFueSB2YWx1
ZSB0byBiZSByZXR1cm5lZC4NCj4gRm9yIEJURi1lbmFibGVkIHJhd190cCBsZXRzIGVuZm9yY2Ug
J3JldHVybiAwJywgc28gdGhhdCByZXR1cm4gdmFsdWUNCj4gY2FuIGJlIHVzZWQgZm9yIHNvbWV0
aGluZyBpbiB0aGUgZnV0dXJlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxleGVpIFN0YXJvdm9p
dG92IDxhc3RAa2VybmVsLm9yZz4NCj4gLS0tDQoNCkxvb2tzIGdvb2QsIGlmIHRoZSByZXR1cm4g
dmFsdWUgaXMgaWdub3JlZCwgbm8gbmVlZCB0byBzcGVjaWZ5IGFueXRoaW5nIA0KYnV0IDAgZm9y
IG5vdy4NCg0KQWNrZWQtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQoNCj4g
ICBrZXJuZWwvYnBmL3ZlcmlmaWVyLmMgfCA1ICsrKysrDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDUg
aW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvdmVyaWZpZXIuYyBi
L2tlcm5lbC9icGYvdmVyaWZpZXIuYw0KPiBpbmRleCBjNTk3NzhjMGZjNGQuLjZiMGRlMDRmOGI5
MSAxMDA2NDQNCj4gLS0tIGEva2VybmVsL2JwZi92ZXJpZmllci5jDQo+ICsrKyBiL2tlcm5lbC9i
cGYvdmVyaWZpZXIuYw0KPiBAQCAtNjI3OSw2ICs2Mjc5LDExIEBAIHN0YXRpYyBpbnQgY2hlY2tf
cmV0dXJuX2NvZGUoc3RydWN0IGJwZl92ZXJpZmllcl9lbnYgKmVudikNCj4gICAJY2FzZSBCUEZf
UFJPR19UWVBFX0NHUk9VUF9TWVNDVEw6DQo+ICAgCWNhc2UgQlBGX1BST0dfVFlQRV9DR1JPVVBf
U09DS09QVDoNCj4gICAJCWJyZWFrOw0KPiArCWNhc2UgQlBGX1BST0dfVFlQRV9SQVdfVFJBQ0VQ
T0lOVDoNCj4gKwkJaWYgKCFlbnYtPnByb2ctPmF1eC0+YXR0YWNoX2J0Zl9pZCkNCj4gKwkJCXJl
dHVybiAwOw0KPiArCQlyYW5nZSA9IHRudW1fY29uc3QoMCk7DQo+ICsJCWJyZWFrOw0KPiAgIAlk
ZWZhdWx0Og0KPiAgIAkJcmV0dXJuIDA7DQo+ICAgCX0NCj4gDQoNCg==
