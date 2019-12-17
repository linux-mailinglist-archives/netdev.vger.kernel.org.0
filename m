Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26141238E6
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbfLQVym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:54:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2150 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbfLQVym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:54:42 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHLsPVH024652;
        Tue, 17 Dec 2019 13:54:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6aV7AfQ2jZbiixS4gZLYUtPUkCsya/3HdciciRgE3Fk=;
 b=SvE8D8qu/3oh1O4LApkotY+JYqr07r5baJGSdz2bzob83jwm//CXy0o0un7n7TOySVDy
 LwkjNV0z7pS9zwYFns6AHVk3bYr0o3lWUvEcFNVWi3Ij6ny/FVx8KmtnLpebWE6+GmfF
 4LuD2yaeMREK2+jIwbmELR07hNmUnmQvZq4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxg74p357-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Dec 2019 13:54:28 -0800
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Dec 2019 13:54:27 -0800
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Dec 2019 13:54:26 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 13:54:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XACnXI+HKYAzPILxhiF4ksGAYpw70Pbae1En5nj9FsKZ9ycDlOYhNuVrY0ygAe5ahSFhW4HoxEfnrf0rgf725yxfD20Cg1GlnxPJoiFt/msVhUQN6NXSjUpXDa6HmpUfF0sds4JuDiNS3RagCjN4gAxniLAAFDgHsvpONXPfp0dFG5fpex4WAh05BNNNCMgctd3ojs6Utp3vP/cBhGd76C/TXNo95DzjQBmO37Skdj3NGi25jJT/g3IuRcYjXccV3k0ZK+btDkaqV8e4XfZOgl4hrlf3a2kTwG/PA5Lptut4Peski++uEZaKykVYACLtPWbDO8U2suG5AqqFvHSfjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6aV7AfQ2jZbiixS4gZLYUtPUkCsya/3HdciciRgE3Fk=;
 b=iRyR+RhONJTGXDgglHcwut70Mjsvv3e9b88OupxbaNLGnbmqVw6Kdjy7vxWraiz2CvYULZZiF95V2u4Wv6Nm2aim548pgKJ3oEw0VcnyQ6o8ELPZe/s5umLMCJsr5MTEDvLoTQNIn7Xfq1LLtPnKCy7f7Y8Nu54gHZ1faLDuX1ncrafA9t7JADkvcvFOL5v5zrSJUEdoInj5L7PVBkb/nyip8IckzkWq3hRCtru2ig7dJi/w/LI7N6EmIKoced5vhhDW0jXC3NVqNpAo9TLedS5xyxxE6oYP0ePWFkzLP8O0U/p9D4ilmrfZeeigF3mQ1STAAJavvSQLr1KCI/LFTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6aV7AfQ2jZbiixS4gZLYUtPUkCsya/3HdciciRgE3Fk=;
 b=PG0Y2WcE+Czk9NAAQpYIye43/dor1Nke6lqvvas4ev88CXtgeqmkRwSyfWqxZl9+WJ36Y3HYAOF19H0X+TiDQf75tgRQ+3j8PbT4j0Y9JFWtBb+DcsbUv4qNw2la6PjYZYHAbgfbn4C2oC1NiSnyT7Y3HDhHI7HKZZwk5PlcMeM=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1146.namprd15.prod.outlook.com (10.173.212.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 21:54:26 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 21:54:26 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: more succinct Makefile output
Thread-Topic: [PATCH bpf-next] selftests/bpf: more succinct Makefile output
Thread-Index: AQHVtSSMF81etZSdhkCiTWdLLPzH1w==
Date:   Tue, 17 Dec 2019 21:54:26 +0000
Message-ID: <b0e81ae2-9155-e878-1193-3e7ecfab1983@fb.com>
References: <20191217061425.2346359-1-andriin@fb.com>
In-Reply-To: <20191217061425.2346359-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0078.namprd05.prod.outlook.com
 (2603:10b6:102:2::46) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:406]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 925daa75-e9cb-4003-a5dd-08d7833baef6
x-ms-traffictypediagnostic: DM5PR15MB1146:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB114693B692807CBC6A381582D3500@DM5PR15MB1146.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(39860400002)(346002)(376002)(199004)(189003)(66556008)(478600001)(64756008)(53546011)(2616005)(6506007)(52116002)(81156014)(5660300002)(71200400001)(6512007)(81166006)(8936002)(4326008)(186003)(110136005)(6486002)(2906002)(4744005)(36756003)(31686004)(66946007)(54906003)(31696002)(66446008)(66476007)(8676002)(316002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1146;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +RhfYRytCYwpy3rDQgm1bGLWCYIGU4lJ7LZtOUH86Q6gZ8bC3xZ0bWZjqR4vU+eJljyDfJwR40LpxALw2VDwGMXqO5EN/kX8XaQquVlkzKRgLv0qv4zA9coR1AZORx3dfexTL2nUL5YMg+L2pm4yKxiU7LyOyK9vDQrY96CzDJFb2XEjvtKd6FPoQHrRNKzx+nPgdo/ZTcMCwC50ZCTRygkODoe0Lu5gTu/imJCB76hbNj8/mNxkoBKxwT3uejVQx0OFUHRpF8OyW1WE9Fpww5sFE6iTvvDK/8/tPklMolgheAf1dPKMsVYqr1nTJ+T1ednooBGb4FVDQtv1ajzG9BhJBXSONyYfRwMf12ZtK/89p34dH+QoYbqZz11aXPatX0iTgCsfeE/H7CRmMm+aZw54WQIkikzVo+zp90fHpuYs4o37/UONKd2CdfCNU8E5
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1BD5AC0A1F3504EAD4AC8230D6C4177@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 925daa75-e9cb-4003-a5dd-08d7833baef6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 21:54:26.0452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I+Rf3sL11KwabCC5eSR0HEJ/6km0v01klR8EAURLb+W4zb9aAzX9F8+hV6mdOiAq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1146
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 mlxlogscore=817 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912170174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE2LzE5IDEwOjE0IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IFNpbWls
YXJseSB0byBicGZ0b29sL2xpYmJwZiBvdXRwdXQsIG1ha2Ugc2VsZnRlc3RzL2JwZiBvdXRwdXQg
c3VjY2luY3QNCj4gcGVyLWl0ZW0gb3V0cHV0IGxpbmUuIE91dHB1dCBpcyByb3VnaGx5IGFzIGZv
bGxvd3M6DQo+IA0KPiAkIG1ha2UNCj4gLi4uDQo+ICAgIENMQU5HLUxMQyBbdGVzdF9tYXBzXSBw
eXBlcmY2MDAubw0KPiAgICBDTEFORy1MTEMgW3Rlc3RfbWFwc10gc3Ryb2JlbWV0YS5vDQo+ICAg
IENMQU5HLUxMQyBbdGVzdF9tYXBzXSBweXBlcmYxMDAubw0KPiAgICBFWFRSQS1PQkogW3Rlc3Rf
cHJvZ3NdIGNncm91cF9oZWxwZXJzLm8NCj4gICAgRVhUUkEtT0JKIFt0ZXN0X3Byb2dzXSB0cmFj
ZV9oZWxwZXJzLm8NCj4gICAgICAgQklOQVJZIHRlc3RfYWxpZ24NCj4gICAgICAgQklOQVJZIHRl
c3RfdmVyaWZpZXJfbG9nDQo+ICAgICBHRU4tU0tFTCBbdGVzdF9wcm9nc10gZmV4aXRfYnBmMmJw
Zi5za2VsLmgNCj4gICAgIEdFTi1TS0VMIFt0ZXN0X3Byb2dzXSB0ZXN0X2dsb2JhbF9kYXRhLnNr
ZWwuaA0KPiAgICAgR0VOLVNLRUwgW3Rlc3RfcHJvZ3NdIHNlbmRtc2c2X3Byb2cuc2tlbC5oDQo+
IC4uLg0KPiANCj4gVG8gc2VlIHRoZSBhY3R1YWwgY29tbWFuZCBpbnZvY2F0aW9uLCB2ZXJib3Nl
IG1vZGUgY2FuIGJlIHR1cm5lZCBvbiB3aXRoIFY9MQ0KPiBhcmd1bWVudDoNCj4gDQo+ICQgbWFr
ZSBWPTENCj4gDQo+IC4uLiB2ZXJ5IHZlcmJvc2Ugb3V0cHV0IC4uLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCg0KQWNrZWQtYnk6IFlvbmdo
b25nIFNvbmcgPHloc0BmYi5jb20+DQo=
