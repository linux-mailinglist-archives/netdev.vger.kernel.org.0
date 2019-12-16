Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94CDC121BC6
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 22:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfLPVfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 16:35:09 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21856 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726610AbfLPVfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 16:35:08 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGLYL3g032154;
        Mon, 16 Dec 2019 13:34:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Kk97YVkrEoMlyZmq2BxDNMEeSV+OiZ730T2eHMq8DfY=;
 b=RiO/WjmoamVbG1HRdNqFtLeqOjWU0fJG5UADqk+PCxcOP0xNNdlAA+71zpGhCUVHQj6c
 Alb7JxxFgiYW6mFbqAQFVSP35kiImAWrLlhgkF2hkATGzGhuxqJiapJq6KKpAp4CJYd0
 vf3rCFXbkPy+RTTwHeM2gs5qDl0dqTm7T0s= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxcwy1mrh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 13:34:52 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 13:34:44 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 13:34:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWXnX78DWwj+A9vkYhqwR+00pMJLmFD6tvMt9eXhk+bZR/7H+0to1mox9/8JCcKgg/ciyToLKxMSJ1w/PvEpCU8679+ugiKyzutyCfjFnZ9Ri6+UAK5xbf3VilVUYiE379dkKzTiscV4YjKVXdiSSPySPAMqXy5JIt+EvCytvQc9otD0msku290cc5E4rY/6SPbGae3ggGWglPnjsIaVOOTtTNYP7t4J74x6f5MazllQTrNas9PjK2RsiHk7fsPpe9cgvKdD1ocQ3rb1H5RI6QVr4C2VaPY+d4MSsCs/z9SH4nZQUKyE+oBB2OP1bVgHhluxDNAeKEDy2K92F857Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kk97YVkrEoMlyZmq2BxDNMEeSV+OiZ730T2eHMq8DfY=;
 b=V+c8tNiaHRuajGynERxGUFOCmxIuEKHwmcky3+JUKEK81aSE4ua9QKVuGrpwq/QmryEsMJELo0PzWCRd4q3XrjOL3KzbNtLW77r9L262PGelP68NisRTMlGYrC4WJluSqIPnfAmdSjEIM2n9npcQ/1PcuPjPg+laYcHZLWZ6KaIexHVSuqKl6ag88/h3SvSEYxS7ty8wx0NEPm47Mcdodo2+ax7CDUyvUOcF6JNSVTJO20B42uC4h2LJzJuHiimMbg6qSfDvinezSKQWbRzfuB3f2YFpxOojoM4Fmisf1xwU7mi5AcV231Du2wNABkBiZYJi0N4c5jfKRlc/HJmukg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kk97YVkrEoMlyZmq2BxDNMEeSV+OiZ730T2eHMq8DfY=;
 b=VxSv69ZuF1s2ODlMtAHgS7EKaSfALpYW77GiQ8JZU5LSQvQYifCo4Chto4pjl2jgnqmaEsrupR4u83l2b89iofXXhdsBbnT0xyfxt8HHcgjWwO/eA5zv4/vgiTRxUST+w+GIDdPumIwWPc7yqAtd2FLle8k0hRbvo6wE5rxO2Y8=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1209.namprd15.prod.outlook.com (10.173.215.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 21:34:43 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 21:34:43 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 02/13] bpf: Avoid storing modifier to
 info->btf_id
Thread-Topic: [PATCH bpf-next 02/13] bpf: Avoid storing modifier to
 info->btf_id
Thread-Index: AQHVshgkEdIXhCT5LU2cUGDcMkKdmae9TQ4A
Date:   Mon, 16 Dec 2019 21:34:42 +0000
Message-ID: <7512535f-3c43-ab12-6035-fb97cea2edac@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004741.1652332-1-kafai@fb.com>
In-Reply-To: <20191214004741.1652332-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0071.namprd21.prod.outlook.com
 (2603:10b6:300:db::33) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::dd8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6eb22fca-dee3-400b-30bb-08d7826fc34a
x-ms-traffictypediagnostic: DM5PR15MB1209:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1209D26DE73B2C1487614D14D3510@DM5PR15MB1209.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(346002)(366004)(376002)(396003)(199004)(189003)(4744005)(71200400001)(186003)(8676002)(110136005)(54906003)(53546011)(6512007)(2906002)(52116002)(6486002)(2616005)(86362001)(478600001)(8936002)(316002)(6506007)(81166006)(31686004)(5660300002)(36756003)(81156014)(66446008)(66946007)(64756008)(66476007)(66556008)(4326008)(31696002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1209;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 812HeIIcWSgT/Sl/4P3Am7IpDDRE+CySU4ufY8ccEmKTi4k7I5h+joIS8vi4kt5U3SZeOpXSADoJCzarqdb3A6oO2oCGcjjQfbIlarYqe+UGYpYaYuuylFdBy9Nc0I0hnFDuPzQqZdfssiPOlzNk8fbK0YUsINRCmpTg5/dweNXeGs/5Eq8RG0N1R2XwAXIv/Y5ru58IvgJgkuR11aFRps1pW2vysxWxQsiPrT4VAyAuHcZCCAfJcUa62qhgPrgNZyOX47asNT2XZCOqAtz+CXTx0MQtmDfwtl+rkd7wuE2gF+ZZHgSSgkWCq1h0r57D0CVr07bISz1u/u7F9tT5/mr0kjibBL1V558pWY12VqLpBq02b70hQWpf+Ds9Xov4C33wZHm4ZAd2kCY+7PAJSOv46KjplHMKPF2PUx/D8i14FrVLYFfLaMXKKW3JAMUy
Content-Type: text/plain; charset="utf-8"
Content-ID: <9DFDDF2A728AD34A8A324A2498806FF2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb22fca-dee3-400b-30bb-08d7826fc34a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 21:34:42.8663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gCmOWxKzk3n8ToIXIXv7v+VmN5ncpSBkw5/DbXJHSY4IeD1BCyUd749zbzpuwsJv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1209
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=632 phishscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912160182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEzLzE5IDQ6NDcgUE0sIE1hcnRpbiBLYUZhaSBMYXUgd3JvdGU6DQo+IGluZm8t
PmJ0Zl9pZCBleHBlY3RzIHRoZSBidGZfaWQgb2YgYSBzdHJ1Y3QsIHNvIGl0IHNob3VsZA0KPiBz
dG9yZSB0aGUgZmluYWwgcmVzdWx0IGFmdGVyIHNraXBwaW5nIG1vZGlmaWVycyAoaWYgYW55KS4N
Cj4gDQo+IEl0IGFsc28gdGFrZXMgdGhpcyBjaGFuYWNlIHRvIGFkZCBhIG1pc3NpbmcgbmV3bGlu
ZSBpbiBvbmUgb2YgdGhlDQo+IGJwZl9sb2coKSBtZXNzYWdlcy4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IE1hcnRpbiBLYUZhaSBMYXUgPGthZmFpQGZiLmNvbT4NCg0KQWNrZWQtYnk6IFlvbmdob25n
IFNvbmcgPHloc0BmYi5jb20+DQo=
