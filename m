Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DFF1299C3
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 19:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLWSKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 13:10:52 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61178 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726766AbfLWSKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 13:10:51 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNI5YJm012486;
        Mon, 23 Dec 2019 10:10:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+0J+AFcRp/x7vbD6v/GyPXQm5xhACJHd0KJJEQFprBE=;
 b=ZZJUiCYgx2/TN0qdmwQA0ZI5Vtl/4KbnHfDKNYaEDRXIBYg8yRoHOiteyD60QQXbXpg+
 x0zEdJYHTHhsmTnGjau6yosacpNH3LUSRaCXmD9mhueO0kMnr+qckqGt6me/A/a72eu5
 O0jKSC4s5d9a6et/fvowkpGwBwXfwFPWGtw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x23tvnd0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Dec 2019 10:10:38 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 23 Dec 2019 10:10:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAbKISVE0EwCJoyMOtmGTEjIS9yunjoaeRrUy1Ef5WJLuaWaLzW9PH+0WgzU+gM/X1rvk/uCyIAa7O/996euJmFzrv/Bq+x+FR/eEoJgPILfUWGuLx4r1wUGDHcvfIeR49vK0Y2tL8wtRsXaKlV4pZP+tZpic1hlnAfNEJWXKnaSEkGJ7bzbaUS6BsrK7w53y6bZAISOvKNN8zRUhOB0RwH4W/8zHz52BTUFI/gYWO/uP0E42mlF+DQINkqK5JM4uzw2shzq7smZ7onMcq9yR9TrjwPNFvmS80c9YmRiBiPsBn4A8yKlZ6dt58TJgKuMP5LRh7LL6KWUB99dcz24iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0J+AFcRp/x7vbD6v/GyPXQm5xhACJHd0KJJEQFprBE=;
 b=Ffs7QGdO+ZbGndOafy7tHewyB+XDDXiSd6v50rab/tR/O1nx2rBf+0LK/uqlV0iz5s30SSjr5Av6sIzv9zB63hpeT43KDd25ww9wjVqGJ9AbE7ponbgJh5ONKLEa8HB5cnQxK+wyILpyeBFH9etkPUPM6725He/tU8BjgfCLQCeiCVHMyhb8xQPvQWA/7qxNlgoMFSKxvQ48am4A8eKMQj1h/3roU/21cKQ3vGZ56gsrAj93CX8KOfcy6OPQxV8cYgiynAvUeuBLnb0p2CQWCA6giDid/zyCdYtHHLvhfeGXzhJ01Sjiq6LvnkLyoIu62R+KHfhVQVFep9xM6Dkwrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0J+AFcRp/x7vbD6v/GyPXQm5xhACJHd0KJJEQFprBE=;
 b=VPC2RWB+EE6tMwQjncS30l6qfwYmLet1nAr9dsEtX62pLZ/Pa++apIzffsGOAYDKorqF8Ck5oNoMrjWQbfotUTI3lpGp3IHIoVMUnCT7L89rc5K6VVlNtCsoNZ5F+qV9AYJyjVcljSuZbrtMtmcp3uRxN9Lhvn2ZbEsHvvUcLGQ=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1945.namprd15.prod.outlook.com (10.173.215.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 18:10:36 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 18:10:36 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::4a23) by MWHPR12CA0029.namprd12.prod.outlook.com (2603:10b6:301:2::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Mon, 23 Dec 2019 18:10:35 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: support CO-RE relocations for
 LDX/ST/STX instructions
Thread-Topic: [PATCH v2 bpf-next] libbpf: support CO-RE relocations for
 LDX/ST/STX instructions
Thread-Index: AQHVubtC4z++ChceEUmHI0HUG13ijqfIBRKA
Date:   Mon, 23 Dec 2019 18:10:36 +0000
Message-ID: <c8e07d16-9b7e-5847-b8a8-853f4aaf620f@fb.com>
References: <20191223180305.86417-1-andriin@fb.com>
In-Reply-To: <20191223180305.86417-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:301:2::15) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::4a23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05ccaf78-9956-4c42-3cf1-08d787d3688f
x-ms-traffictypediagnostic: DM5PR15MB1945:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB19450930E54DBAEEAEE69D38D32E0@DM5PR15MB1945.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(2906002)(6486002)(8936002)(2616005)(81166006)(6506007)(53546011)(36756003)(81156014)(52116002)(8676002)(4326008)(16526019)(186003)(6512007)(5660300002)(31686004)(478600001)(71200400001)(66946007)(54906003)(66446008)(966005)(64756008)(86362001)(66476007)(66556008)(31696002)(316002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1945;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wwbDJR3nxzf/MTX89lIPBeop+Do0E/rlUMGMYxDIPBiGhBbi3mYpnDChdjBp3mTWDKDTvgUjZ+EgN4LBK7jLRe2+eEg2k5iTV/KjM54TzcGu7rcXBpXOI9hebHVb/vwVEyM/G9ipWJoaDEG5XtEitvT4wQPd/NFEwD/sYGqFL8kIefiBGTJ0+pI93FgXkvLk3imHrmW/3+dvvQ8Y34ahP2rxXiXsW2JcHZyTZSLURXUmu4NfIa5WzZ4ICJoVMiRqWg/asR4+M7D/n2UT3l8QGQsEYN5ASc6GjOvMeJ7ZEHhTGbobRkXv0CgoQEavt+WDlC4rNsFtJD6t0yi90oA4pfaUAy6Ds7xXM5SXWABNMAwSTVnQy6mW5Ef+4tav7GihycckpYOWXj/VB3jmZLS8cyIzQbkEJbP5H8KDa//BooyEDVkj1IkdWOzzuEr8vX0Z1b7/qgGuinQtr2ldwSWsXcNXP7uY+UZsB169uxTTAaI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CBBE4004B8CC7A46A8D226E5B53EE258@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ccaf78-9956-4c42-3cf1-08d787d3688f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 18:10:36.1120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6M8ZJhtWRKEitJMf8HhXf5N1/8Nxuejoq+WvFylC2IUtzNgbUJHfbkq5M5n49hMf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1945
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_07:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0 adultscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzIzLzE5IDEwOjAzIEFNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IENsYW5n
IHBhdGNoIFswXSBlbmFibGVzIGVtaXR0aW5nIHJlbG9jYXRhYmxlIGdlbmVyaWMgQUxVL0FMVTY0
IGluc3RydWN0aW9ucw0KPiAoaS5lLCBzaGlmdHMgYW5kIGFyaXRobWV0aWMgb3BlcmF0aW9ucyks
IGFzIHdlbGwgYXMgZ2VuZXJpYyBsb2FkL3N0b3JlDQo+IGluc3RydWN0aW9ucy4gVGhlIGZvcm1l
ciBvbmVzIGFyZSBhbHJlYWR5IHN1cHBvcnRlZCBieSBsaWJicGYgYXMgaXMuIFRoaXMNCj4gcGF0
Y2ggYWRkcyBmdXJ0aGVyIHN1cHBvcnQgZm9yIGxvYWQvc3RvcmUgaW5zdHJ1Y3Rpb25zLiBSZWxv
Y2F0YWJsZSBmaWVsZA0KPiBvZmZzZXQgaXMgZW5jb2RlZCBpbiBCUEYgaW5zdHJ1Y3Rpb24ncyAx
Ni1iaXQgb2Zmc2V0IHNlY3Rpb24gYW5kIGFyZSBhZGp1c3RlZA0KPiBieSBsaWJicGYgYmFzZWQg
b24gdGFyZ2V0IGtlcm5lbCBCVEYuDQo+IA0KPiBUaGVzZSBDbGFuZyBjaGFuZ2VzIGFuZCBjb3Jy
ZXNwb25kaW5nIGxpYmJwZiBjaGFuZ2VzIGFsbG93IGZvciBtb3JlIHN1Y2NpbmN0DQo+IGdlbmVy
YXRlZCBCUEYgY29kZSBieSBlbmNvZGluZyByZWxvY2F0YWJsZSBmaWVsZCByZWFkcyBhcyBhIHNp
bmdsZQ0KPiBTVC9MRFgvU1RYIGluc3RydWN0aW9uLiBJdCBhbHNvIGVuYWJsZXMgcmVsb2NhdGFi
bGUgYWNjZXNzIHRvIEJQRiBjb250ZXh0Lg0KPiBQcmV2aW91c2x5LCBpZiBjb250ZXh0IHN0cnVj
dCAoZS5nLiwgX19za19idWZmKSB3YXMgYWNjZXNzZWQgd2l0aCBDTy1SRQ0KPiByZWxvY2F0aW9u
cyAoZS5nLiwgZHVlIHRvIHByZXNlcnZlX2FjY2Vzc19pbmRleCBhdHRyaWJ1dGUpLCBpdCB3b3Vs
ZCBiZQ0KPiByZWplY3RlZCBieSBCUEYgdmVyaWZpZXIgZHVlIHRvIG1vZGlmaWVkIGNvbnRleHQg
cG9pbnRlciBkZXJlZmVyZW5jZS4gV2l0aA0KPiBDbGFuZyBwYXRjaCwgc3VjaCBjb250ZXh0IGFj
Y2Vzc2VzIGFyZSBib3RoIHJlbG9jYXRhYmxlIGFuZCBoYXZlIGEgZml4ZWQNCj4gb2Zmc2V0IGZy
b20gdGhlIHBvaW50IG9mIHZpZXcgb2YgQlBGIHZlcmlmaWVyLg0KPiANCj4gICAgWzBdIGh0dHBz
Oi8vcmV2aWV3cy5sbHZtLm9yZy9ENzE3OTANCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJpaSBO
YWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZi
LmNvbT4NCg==
