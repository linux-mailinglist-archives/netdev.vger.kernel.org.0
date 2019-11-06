Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39C0F214C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfKFWCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:02:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15608 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726779AbfKFWCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:02:44 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA6LjSgn011768;
        Wed, 6 Nov 2019 14:02:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0YFG6AOg/TS4vejaHjb6iCQ8DvoDNp9uR9hBbadjwlM=;
 b=StUJ9vvxq0eLO7yN9Eu5ATl7AD2n39jaYi0MT9MYOwN8Yj2Cff6QHMsjnh+Tm3QazNoW
 Ebu5yzRcv1Vp2ln/oYR/xrP4pox61LR32Yew/N4kx8Qg+uYgs3pP/KIVfeXfTfdPFUEa
 xu9A7hgqx6tbzCaT4GmyhlnQWd3gI77FG+4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41uj9jkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Nov 2019 14:02:31 -0800
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 6 Nov 2019 14:02:30 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 6 Nov 2019 14:02:30 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 6 Nov 2019 14:02:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJFCNpkdhbNH5rWkBU1gxoCES9aBwG5DETq4IQVZxuad9I2a0PQwK7oKu9aTJvsGGF3Oo1822Oi84fzh+6z9Q/LRl4aF+b65X4VXBvmgzfO15oVWxVjZlikf8FPZmZuEhG4qeszrmV3wtt02l9KKTcIrb46SO0Coge7ePRH/7iLMrRfCw3Adm4XR8icWnJSLXOwdLb8VuwN80V3lh/TG/pypB5pMr+iM3PTZeww736vwJwileu7qywpgmMLQb7nTxcnlJ5Nmt0F9LbiAXDkzuzmyrfRE6VvEwm8qliiFgosnQpF1A/eEG8rP1tna7eDnSstMNCYMdvAsLCCGhX6oMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YFG6AOg/TS4vejaHjb6iCQ8DvoDNp9uR9hBbadjwlM=;
 b=BpRYGJz8xA3QuCEi2xnDQCtImJR/dgFGmo9PU/3blxwAi5IaSdF0hu+M4dL+/TfK7/NglrGJ3oLHYDffZf+gGUeYDVuSEx27zbnKjgwmwPOYojXkbiLi1/pFQMY37DNBLf9kjc1kOGTqffQd9i50pBsyV+aP6fC39gRwCSV8szmwfplYI3GHLGyFUF3ke/fZyiJ7klmziNtOh/iu/tNYhPX3UD5BGYZe2jZwt2O86mW7Wt+gW7wJdjCXyvsq8wiq2+aMzjKEyUhg5kl+YuF8idaCQJ0J5b7dwNjxT4MoJYRqvoHFkZyS39sp81g8rITbmHBsaapWiBnupaluBzDJ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YFG6AOg/TS4vejaHjb6iCQ8DvoDNp9uR9hBbadjwlM=;
 b=c6oJEgFzGtnm1mXuMA0Cg3NU6x7z9zn6xthFStDwzWjMSaB8rRTg469Dk4IrPUlHB/H+Pal7VPs8jMMrl3iL+xHZT+iY+st6st098lqDfZYrywanMB29q02c+gHbmg+CFJmTj//8rnh+1WWJcDx/OP7U1CtYCn++yGWlJriV9c8=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2454.namprd15.prod.outlook.com (52.135.196.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Wed, 6 Nov 2019 22:02:29 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2408.025; Wed, 6 Nov 2019
 22:02:29 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: simplify BPF_CORE_READ_BITFIELD_PROBED
 usage
Thread-Topic: [PATCH bpf-next] libbpf: simplify BPF_CORE_READ_BITFIELD_PROBED
 usage
Thread-Index: AQHVlN7mdqeCPuu5akK2gbR1A6tGyad+pcwAgAALEgCAAAEjAA==
Date:   Wed, 6 Nov 2019 22:02:28 +0000
Message-ID: <be6d2eea-6026-ab1f-2200-443a35d66762@fb.com>
References: <20191106201500.2582438-1-andriin@fb.com>
 <bdc51aac-6d39-13a6-f50e-8fca3d329b4b@fb.com>
 <CAADnVQ+EHbJ950L93Wa4ZxJDQ_PvPwv-re9+95GighudmN3iDQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+EHbJ950L93Wa4ZxJDQ_PvPwv-re9+95GighudmN3iDQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0202.namprd04.prod.outlook.com
 (2603:10b6:104:5::32) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:5052]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dd6e2e5-6793-4b48-62ec-08d7630503e7
x-ms-traffictypediagnostic: BYAPR15MB2454:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB245432BFBD366CE84BAFB7A0D3790@BYAPR15MB2454.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(376002)(366004)(39860400002)(199004)(189003)(86362001)(2906002)(6486002)(6916009)(76176011)(52116002)(46003)(6116002)(6246003)(36756003)(4326008)(99286004)(6512007)(14454004)(71190400001)(316002)(6436002)(31696002)(229853002)(54906003)(71200400001)(478600001)(66476007)(66446008)(64756008)(66556008)(66946007)(186003)(25786009)(8676002)(5660300002)(102836004)(256004)(386003)(53546011)(305945005)(7736002)(6506007)(81166006)(8936002)(476003)(81156014)(2616005)(446003)(486006)(31686004)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2454;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GMjp3Lc+xGe55R7I9O6jMxrL/VYP1Og9xJ8dXD+KxDhEsnyVxypKFP1c6RgFvBOkXOqmNgSFLPchP+/dbhkGDfZG/sig8p53gtfjvU1G4ovgwwVklnfDgZxz4GrLioi0D//m2pYGbSFOaizq42TU1aFfaGqa8Xe4XLIgNpqJRHIaKnvFWtBNkD6EsX0rdYGf3ZZ46DSL3V4zSmu1VqUMpn5yraBI/OgZzrOLpzLm30ctFaY+k0++8tdFiYiH/B0pvmoishfUw3a+1/NBnZ0kmX3EUYtuWpMW1wyRwxrT1OlUw3Rw9wMy8g8Yyfnz9BvZ5I7GKluF/2b6G8sdLW6nRvqFBf9+gPkgG6KGTyRDaQ2++qo0aMy8mKiW6Vi1BwbzzoZSQVLjPEJLCNhzClokVyWey+EN9/8ihygspTma03Ykw4YLww8miJz9TGP/VLeA
Content-Type: text/plain; charset="utf-8"
Content-ID: <0019C35617A96946BB49D2B1540A8FDF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd6e2e5-6793-4b48-62ec-08d7630503e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 22:02:28.9975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AsgHqfc2/mLWdMUXowv4ceIQ3yxKiNKFcO8Yg0U9CMhMVHtixggzxufi9o9b9yD3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2454
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_07:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911060211
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzYvMTkgMTo1OCBQTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPiBPbiBX
ZWQsIE5vdiA2LCAyMDE5IGF0IDE6MjEgUE0gWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3Jv
dGU6DQo+Pg0KPj4NCj4+DQo+PiBPbiAxMS82LzE5IDEyOjE1IFBNLCBBbmRyaWkgTmFrcnlpa28g
d3JvdGU6DQo+Pj4gU3RyZWFtbGluZSBCUEZfQ09SRV9SRUFEX0JJVEZJRUxEX1BST0JFRCBpbnRl
cmZhY2UgdG8gZm9sbG93DQo+Pj4gQlBGX0NPUkVfUkVBRF9CSVRGSUVMRCAoZGlyZWN0KSBhbmQg
QlBGX0NPUkVfUkVBRCwgaW4gZ2VuZXJhbCwgaS5lLiwganVzdA0KPj4+IHJldHVybiByZWFkIHJl
c3VsdCBvciAwLCBpZiB1bmRlcmx5aW5nIGJwZl9wcm9iZV9yZWFkKCkgZmFpbGVkLg0KPj4+DQo+
Pj4gSW4gcHJhY3RpY2UsIHJlYWwgYXBwbGljYXRpb25zIHJhcmVseSBjaGVjayBicGZfcHJvYmVf
cmVhZCgpIHJlc3VsdCwgYmVjYXVzZQ0KPj4+IGl0IGhhcyB0byBhbHdheXMgd29yayBvciBvdGhl
cndpc2UgaXQncyBhIGJ1Zy4gU28gcHJvcGFnYXRpbmcgaW50ZXJuYWwNCj4+PiBicGZfcHJvYmVf
cmVhZCgpIGVycm9yIGZyb20gdGhpcyBtYWNybyBodXJ0cyB1c2FiaWxpdHkgd2l0aG91dCBwcm92
aWRpbmcgcmVhbA0KPj4+IGJlbmVmaXRzIGluIHByYWN0aWNlLiBUaGlzIHBhdGNoIGZpeGVzIHRo
ZSBpc3N1ZSBhbmQgc2ltcGxpZmllcyB1c2FnZSwNCj4+PiBub3RpY2VhYmxlIGV2ZW4gaW4gc2Vs
ZnRlc3QgaXRzZWxmLg0KPj4NCj4+IEFncmVlZC4gVGhpcyB3aWxsIGJlIGNvbnNpc3RlbnQgd2l0
aCBkaXJlY3QgcmVhZCB3aGVyZQ0KPj4gcmV0dXJuaW5nIHZhbHVlIHdpbGwgYmUgMCBpZiBhbnkg
ZmF1bHQgaGFwcGVucy4NCj4+DQo+PiBJbiByZWFsbHkgcmFyZSBjYXNlcywgaWYgdXNlciB3YW50
IHRvIGRpc3Rpbmd1aXNoIGdvb2QgdmFsdWUgMCBmcm9tDQo+PiBicGZfcHJvYmVfcmVhZCgpIHJl
dHVybmluZyBlcnJvciwgYWxsIGJ1aWxkaW5nIG1hY3JvcyBhcmUgaW4gdGhlIGhlYWRlcg0KPj4g
ZmlsZSwgdXNlciBjYW4gaGF2ZSBhIGN1c3RvbSBzb2x1dGlvbi4gQnV0IGxldCB1cyBoYXZlIEFQ
SSB3b3JrDQo+PiBmb3IgY29tbW9uIHVzZSBjYXNlIHdpdGggZ29vZCB1c2FiaWxpdHkuDQo+Pg0K
Pj4+DQo+Pj4gQ2M6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo+Pj4gU2lnbmVkLW9mZi1i
eTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4+DQo+PiBBY2tlZC1ieTogWW9u
Z2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCj4gDQo+IEFwcGxpZWQuIFRoYW5rcw0KPiANCj4gWW9u
Z2hvbmcsIHBsZWFzZSB0cmltIHlvdXIgcmVwbGllcy4NCg0KU29ycnksIGZvcmdvdCB0byBkby4g
V2lsbCByZW1lbWJlciBuZXh0IHRpbWUuDQo=
