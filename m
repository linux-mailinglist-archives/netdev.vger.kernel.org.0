Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6AD61233C4
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 18:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfLQRmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 12:42:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8984 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727198AbfLQRmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 12:42:05 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHHQZwI018485;
        Tue, 17 Dec 2019 09:41:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8+VFIB11xtUvAqe69t71G17k6ZIgWm/XkImpkNX4JUU=;
 b=nkkiqhS3l1W0OQ1/FVqnO7HvM4bUtXJ/jCd9/RpzSSgx3hZ1O8Yfsh8BNp1btu0m9jJm
 5bpUJNnDp7A0Sggk1p1PnL9TP8JfYZrpILQe6hHWaja67lNxi/IiCseg419vQFRJFXeo
 kHnInDVo4Q7Y6j/2MQQpyu3mLf2WrFFYWxA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxhkr4epw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Dec 2019 09:41:52 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Dec 2019 09:41:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 09:41:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYXcedoC9zCycl3hCgZZayemGtsKVnrGQX1GUtyElpkU+Wn1uKs6OBVpq9X8l6UDBb4A3I5qg8exQymhV3fJyKPDXsPIaxNrqxRUnx42Z5U6I5VAC9rPjIIk84YpHvHMu9/suK9zc3GaeupHd1r8rAB+X0TuxNEKlRbgaZraKCLroapoWSahsRQiypcdNrmUY8uJTE3/UvTfMpowgHXPF6szqjmrZFVTWTdBuDgy7ogU3txsaSCxOLgpmo2r+Zpd7zYys5aiMARDyQNX1YRefHXkVIznIeBBsDF3YMBB1DnCjSTO5uQFFWb/0LutXkOKrC39xVRcJsbtMch0mZipxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+VFIB11xtUvAqe69t71G17k6ZIgWm/XkImpkNX4JUU=;
 b=gV6x0L04+j5R3MqLKCSY58ry+4Lrf+gMog4qv7nP7gBaHWkfL4zW6kD7c7Is+jLOxHh70uCwS4ZcCm89kvA2xci6NKrQUaDxB4Zk8k01Nvn/A96tHGdA2ax7pb/e3ON5gWJ5VLRtFKbD75y8ThHgQHB1sS6CB9THJgUeUDdSwyM6feFNVT6qlNmvNny5n/bH0D2YhEXC2xp975Iuku/3QtoxdoJtJvLJ+Tk40Lqw/1JAmSTy8ztGjxSMT1ZTjNeBtSK3vqAcyxEG99KWwPw+VFkrWVE+QdBUxBlJeTOLPPXgaDKv+JHixnu/ExV6lI/F5ztvsrOcIR5TJ56NUSGmYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+VFIB11xtUvAqe69t71G17k6ZIgWm/XkImpkNX4JUU=;
 b=JTRJWblZS9NYhbcniaqEYJvOVDZXs+/RxjjQfsR7xilMTAbZu9UgfAfI0mw3GkbmuY/6BSn0QvSKwN1k3abQgJp/HQqCG48WXb3GSqU0ULutuIvxAxlLVWZPSuK5BU+Niw207lkuAQh9xsLbDrIn8zRBdTD3zZFch45T8g6G3mY=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1339.namprd15.prod.outlook.com (10.173.214.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Tue, 17 Dec 2019 17:41:49 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 17:41:49 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 08/13] bpf: Add BPF_FUNC_tcp_send_ack helper
Thread-Topic: [PATCH bpf-next 08/13] bpf: Add BPF_FUNC_tcp_send_ack helper
Thread-Index: AQHVshgt8ZOSXnb6KkSbqYyPsH+KZ6e+nlAA
Date:   Tue, 17 Dec 2019 17:41:48 +0000
Message-ID: <6df3df4e-06ac-b862-ac1d-58d568c843a1@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004755.1653250-1-kafai@fb.com>
In-Reply-To: <20191214004755.1653250-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0013.namprd19.prod.outlook.com
 (2603:10b6:300:d4::23) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:c02c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 420cca07-839a-4912-1d79-08d78318648e
x-ms-traffictypediagnostic: DM5PR15MB1339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1339D9BD62CEFFBADD46CE2ED3500@DM5PR15MB1339.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(31686004)(53546011)(478600001)(31696002)(6506007)(2616005)(86362001)(5660300002)(558084003)(186003)(81166006)(81156014)(6486002)(4326008)(8676002)(8936002)(316002)(110136005)(54906003)(66946007)(64756008)(66446008)(66556008)(66476007)(36756003)(6512007)(52116002)(2906002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1339;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7yxCfXQ/tEITU6042grq6B0NXfjLNfYrhJEYt6wASsFHO2IOuZ7YbVDS6tJ727Y9wYXK6OeNdazsgTmAPHwb5M4RB8OTk9WmjjrdzzUVAewwbxaYwxqBS5XU7xQANtAPDEd8dgQCOVHtdpA7P30iNgXXQfcbZeHaZ3Ck0xc9zPjbI21yBhPdkLe39zs+vJnknSEP1sKVFqAK/FXJcksgQSXMxK/0eHZASMCrykvayOT9Zdkja71KTCtLVWumK/25QMW5DU89kNVqzunJ/iCD9x+2etkW58aS3UMqZVfkj9Md5eRPXCtWy73e1/wvHvtC+edrOHrTSbzFeB+QJSswH9t6q+lj+O97bivMP5vqPKwJXsVqG/gnF2pLMMUKgcTFgxseIz3RjJ8zBEWjWNzz59OY6C0NTOECgc1lpjOczyfJ8F6PYam8CaL/Y8Z2VqNi
Content-Type: text/plain; charset="utf-8"
Content-ID: <71CEDD06515D87469F3C3DCAA47292C1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 420cca07-839a-4912-1d79-08d78318648e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 17:41:48.8482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KJ37JszY58SlsswBQU5NSbW5kKbGzCspCn0EBCbs5JHndXZSeBYhYiFKnDi8NGbk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1339
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_03:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=621 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912170138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEzLzE5IDQ6NDcgUE0sIE1hcnRpbiBLYUZhaSBMYXUgd3JvdGU6DQo+IEFkZCBh
IGhlbHBlciB0byBzZW5kIG91dCBhIHRjcC1hY2suICBJdCB3aWxsIGJlIHVzZWQgaW4gdGhlIGxh
dGVyDQo+IGJwZl9kY3RjcCBpbXBsZW1lbnRhdGlvbiB0aGF0IHJlcXVpcmVzIHRvIHNlbmQgb3V0
IGFuIGFjaw0KPiB3aGVuIHRoZSBDRSBzdGF0ZSBjaGFuZ2VkLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogTWFydGluIEthRmFpIExhdSA8a2FmYWlAZmIuY29tPg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcg
U29uZyA8eWhzQGZiLmNvbT4NCg==
