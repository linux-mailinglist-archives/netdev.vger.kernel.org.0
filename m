Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C87D8487
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388162AbfJOXlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:41:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52524 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388122AbfJOXlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 19:41:35 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9FNdQkn020102;
        Tue, 15 Oct 2019 16:41:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SC7VFqGx9cP/XjTWv6Ki6pe8urN+ZLEIffJczTvT3H0=;
 b=EIsj+iy1lIpK/Gm44Nq2cSHpPC10pnCO7MUkfjKvb41H3t83TYp8Dxm+s36+bPJZ0Ftt
 VVJvjoEZsPpCFFAkyuvk7zt5oGPnwJeiwCkbgF6MPQ9bd3f8gwEo9sPCL0B0esAsyDaU
 DvS3a3NNvDa/RY0Ek2cHuPUqTSwl25Rycqs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vmtajfvcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 16:41:22 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 15 Oct 2019 16:41:20 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 15 Oct 2019 16:41:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHe10JfP6adnWv1k9Jkg40Om6SLykX1nln/2OlbS3Yz//60PM0mGFPKm9wUpw6PpQfGs3tD+zBtuueyghiCvkKPDd/U4gKmjZ5M5kDeC1rt9+w+fCFF3VKpd74XtqBZvFiE5T8KraDRDM/M8/v+eR0+2fu0Dv5v5qEUjkq2C60FWgEMIz6A0oaGRSYT//vBDtSay0N+YNMBUhSFnFwmrpxrt3UoJ/pIjSUMsMGrdmjEC2Ux/+w24o+eKcvS23vZaLWgzUbf7r6trM9w0b3DbNskbc8UJPzum+PhN0zV0u6MFy8wJaQpyP4XzWkCENkXpGG68F8K5fR6g83qC7wus9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC7VFqGx9cP/XjTWv6Ki6pe8urN+ZLEIffJczTvT3H0=;
 b=PBXbSv3Da2P39lA8w7efkLT7E60wLZ3xMmIZqW6agFpDdQLwCXPkDTnLSVgIrCrlwC7412mNVSgwYdcYrZhEIvPfV83PMn6nZe5shhvl6RwLYj03IWzHJAui2tqifwSDnaT0vHJjO74XaSRpyN566Q2IYKLpl7nmEK8+BCbQmGHvJQ7y6NFrEQYLlLGGs5E3CmIovdNE2QDURdne2mXPOqKk40LDKlPcB5LnDmIO3w5K03z/tFkD4/MLSgOjuItPQb+DSOfAzYy9PPdOwgDexjIQIKinyslOkLGcMVekPY2TYKAZ+kNuGqfiUzts6mLFD6ZFuMjmXqgF67n7a/2H7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC7VFqGx9cP/XjTWv6Ki6pe8urN+ZLEIffJczTvT3H0=;
 b=B2bd29PHUWivbJqPpvZqribzhfVx1wlPRrzlq3JCs0uskttFrCFTb7kBCgALeyzL1bxoF+4xRKPvGzXqkgxNZiqKA/NLU1I1+JuaL0F7GoEGf1/0bDnfZO0+WR5Gf+RK5J+QVUWG4zhBWBLe6CiXOBrjbQJO97gAN25X3SDpV5Y=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2503.namprd15.prod.outlook.com (52.135.196.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 23:41:20 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 23:41:20 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 5/6] selftests/bpf: replace test_progs and
 test_maps w/ general rule
Thread-Topic: [PATCH bpf-next 5/6] selftests/bpf: replace test_progs and
 test_maps w/ general rule
Thread-Index: AQHVg6SGtmhp9wWhJ0e8/+ScwUNbladcXMkA
Date:   Tue, 15 Oct 2019 23:41:19 +0000
Message-ID: <ca129d11-f243-8e46-38df-df0a52cb9c97@fb.com>
References: <20191015220352.435884-1-andriin@fb.com>
 <20191015220352.435884-6-andriin@fb.com>
In-Reply-To: <20191015220352.435884-6-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0071.namprd12.prod.outlook.com
 (2603:10b6:300:103::33) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::4cc1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c18477ee-de01-43a0-249f-08d751c92ded
x-ms-traffictypediagnostic: BYAPR15MB2503:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB25036963E9A062F987D7A980D7930@BYAPR15MB2503.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(136003)(346002)(366004)(189003)(199004)(2501003)(2906002)(102836004)(486006)(31686004)(5660300002)(4326008)(6436002)(6512007)(476003)(446003)(2616005)(25786009)(6116002)(11346002)(229853002)(6486002)(478600001)(6246003)(305945005)(71200400001)(71190400001)(36756003)(46003)(186003)(31696002)(316002)(256004)(14454004)(66946007)(7736002)(66446008)(64756008)(66476007)(66556008)(53546011)(6506007)(52116002)(86362001)(81156014)(8676002)(8936002)(386003)(81166006)(76176011)(99286004)(110136005)(2201001)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2503;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AzNAK+X8p+gqPBolVKawprjLVIs9WsgVviREZknEF4vQwlO5Ex8zkGE0WP2ndOG++UzNlec7L6mq1ZyrOob3gffr3clX+FzanqXTqcRzuAy7qweERgQldE/IXoGkOAxAHS6EYS7j99N1q0dMPC5I85p05P0mhzinSL+0c2f812xZxJ6E0VFx8MNXy1zZedKbxpylWSHP3NEoH4Y71POs232ZKfP3oFSzLVyMhAMFvyQ7FCp6UijSq1p02X2ttiFmk5hxbIQ1SxN4LK8wo+hVh2AABOWY+Uo+t7VW6tAz88f8N1F2hwo2JiFDwEX3iWmMf8txX0hKpSuJJWWejmZ4Vt6ZiQx65ZUpPjAwzishuI7q43VGOG/ODd7wMIOaZa0S/+/h1XwNxmTAZxqscgyU/VzHYo7WO11ijTB+tD+cToo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75CE676DFFDA774B838C18697B7BBDE0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c18477ee-de01-43a0-249f-08d751c92ded
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 23:41:19.9745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x5nYn49cpc+v2qkjfQqvvzZSdvefBn47spYotQPqQasJUDkpvp+RQtukBFfHC8WY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2503
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-15_08:2019-10-15,2019-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910150201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTUvMTkgMzowMyBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBEZWZpbmUgdGVz
dCBydW5uZXIgZ2VuZXJhdGlvbiBtZXRhLXJ1bGUgdGhhdCBjb2RpZmllcyBkZXBlbmRlbmNpZXMN
Cj4gYmV0d2VlbiB0ZXN0IHJ1bm5lciwgaXRzIHRlc3RzLCBhbmQgaXRzIGRlcGVuZGVudCBCUEYg
cHJvZ3JhbXMuIFVzZSB0aGF0DQo+IGZvciBkZWZpbmluZyB0ZXN0X3Byb2dzIGFuZCB0ZXN0X21h
cHMgdGVzdC1ydW5uZXJzLiBBbHNvIGFkZGl0aW9uYWxseSBkZWZpbmUNCj4gMyBmbGF2b3JzIG9m
IHRlc3RfcHJvZ3M6DQo+IC0gYWx1MzIsIHdoaWNoIGJ1aWxkcyBCUEYgcHJvZ3JhbXMgd2l0aCAz
Mi1iaXQgcmVnaXN0ZXJzIGNvZGVnZW47DQo+IC0gYnBmX2djYywgd2hpY2ggYnVpbGQgQlBGIHBy
b2dyYW1zIHVzaW5nIEdDQywgaWYgaXQgc3VwcG9ydHMgQlBGIHRhcmdldDsNCj4gLSBuYXRpdmUs
IHdoaWNoIHVzZXMgYSBtaXggb2YgbmF0aXZlIENsYW5nIHRhcmdldCBhbmQgQlBGIHRhcmdldCBm
b3IgTExDLg0KDQpHcmVhdCBpbXByb3ZlbWVudCwgYnV0IGl0J3MgdGFraW5nIGl0IHRvbyBmYXIu
DQooY2xhbmcgIC1JLiAtSS9kYXRhL3VzZXJzL2FzdC9uZXQtbmV4dC90b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9icGYgLWcgDQotRF9fVEFSR0VUX0FSQ0hfeDg2IC1JLiAtSS4vaW5jbHVkZS91YXBp
IA0KLUkvZGF0YS91c2Vycy9hc3QvbmV0LW5leHQvdG9vbHMvaW5jbHVkZS91YXBpIA0KLUkvZGF0
YS91c2Vycy9hc3QvbmV0LW5leHQvdG9vbHMvbGliL2JwZiANCi1JL2RhdGEvdXNlcnMvYXN0L25l
dC1uZXh0L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL3Vzci9pbmNsdWRlIA0KLWlkaXJhZnRlciAv
dXNyL2xvY2FsL2luY2x1ZGUgLWlkaXJhZnRlciANCi9kYXRhL3VzZXJzL2FzdC9sbHZtL2JsZC9s
aWIvY2xhbmcvMTAuMC4wL2luY2x1ZGUgLWlkaXJhZnRlciANCi91c3IvaW5jbHVkZSAtV25vLWNv
bXBhcmUtZGlzdGluY3QtcG9pbnRlci10eXBlcyAtTzIgLWVtaXQtbGx2bSAtYyANCnByb2dzL3Rl
c3RfY29yZV9yZWxvY19leGlzdGVuY2UuYyAtbyAtIHx8IGVjaG8gIkJQRiBvYmogY29tcGlsYXRp
b24gDQpmYWlsZWQiKSB8IGxsYyAtbWFyY2g9YnBmIC1tY3B1PXByb2JlICAgLWZpbGV0eXBlPW9i
aiAtbyANCi9kYXRhL3VzZXJzL2FzdC9uZXQtbmV4dC90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9i
cGYvbmF0aXZlL3Rlc3RfY29yZV9yZWxvY19leGlzdGVuY2Uubw0KcHJvZ3MvdGVzdF9jb3JlX3Jl
bG9jX2V4aXN0ZW5jZS5jOjQ3OjE4OiBlcnJvcjogdXNlIG9mIHVua25vd24gYnVpbHRpbiANCidf
X2J1aWx0aW5fcHJlc2VydmVfZmllbGRfaW5mbycgWy1XaW1wbGljaXQtZnVuY3Rpb24tZGVjbGFy
YXRpb25dDQogICAgICAgICBvdXQtPmFfZXhpc3RzID0gYnBmX2NvcmVfZmllbGRfZXhpc3RzKGlu
LT5hKTsNCg0KbmF0aXZlIGNsYW5nICsgbGxjIGlzIHVzZWZ1bCBmb3Igb2xkIHNjaG9vbCB0cmFj
aW5nIG9ubHkgKGJlZm9yZSBDTy1SRSkuDQo=
