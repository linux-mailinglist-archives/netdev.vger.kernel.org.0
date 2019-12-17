Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135E41230BF
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfLQPqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:46:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58408 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727972AbfLQPqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 10:46:01 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHFW9v1013855;
        Tue, 17 Dec 2019 07:45:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PstP4vgqH67LC/lwkpaC6mCOLanG6l2IvePLepKlQMA=;
 b=R3weNVvVfA9q10WS0YzGvRo8gPsFXIVHHaZbVe9O3v+pt+wx5pTZneAzReYq1UPgH/YT
 HLV7eQSFF6l+N1YXT35GKaboZlBWvKREKP/Q4JM+DaRZiPXi1uhtlBN6PESG4TsBw40f
 SrgMiBfxsStWyXIt/m9JkJorRIyYQqCgobE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxupthms6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 07:45:48 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Dec 2019 07:45:47 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 07:45:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8kCH5ltloikN9+rJvaeuf9SthEKdwAE2OYtgvCL2S8szB5i4mrpmWe4pqYit6qhyppja7ddnZB96uI68ru42DEXhM5HBchgUhrA797WNbHZ2hHZATnjWY8LuG/2FmAOF2K4Hj+eNLkKW8OgJ0wisBrAr04xZMtft7UyoQZg5uzZhTz6ymXNXy8hiPEOM/wLi5An3sZuJ48hVZ2JNjWLVNrNhKLygBR+ZUH/myHa6AQUEcrqdmSWRBxQAQaDtf4JWxJn82bBR1v/btI4yLKbQrZmkndaIy9tZP2lCc5heMdguC13MOhIKNWJYOFHq0wY4+JY54GNJjbn+OdGVlu42Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PstP4vgqH67LC/lwkpaC6mCOLanG6l2IvePLepKlQMA=;
 b=ULat89LYiBLbAF0ENM1N4NGLQeyEuVsxeFm5KFQbgn0Q42ycA92rfDBE1UZhu82TwLpdbl3ZEdhh9aPBj5ERyXY1A3najPMvWXKPH2empyXLurBxTZbPOy6mRP0qb23WA3SlI0kWUPIWDtDh9gsctkc2cdUIoEmR3MpNWnFmwn561XDX/3urWg/h9lHYZLhx+YcVIrEcvjKrro0cWxg6JQmJnNdCInR9QlOdgbErUsrVjAp23zij98eIrFJWdnof9vyEFYiecm8lJ+bTR46YwNzikt8uUhlD1LKsNYGOaZaTLdc5aoJilSoUzA9BZegxl1HD3YS0uTmfXD47QgU+hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PstP4vgqH67LC/lwkpaC6mCOLanG6l2IvePLepKlQMA=;
 b=SPepGMDYfNZMIzNcsxR+rt1+7j1oF804WiZctM5ud8Fhky5XDr1xV1yv9HV16+s+sNTFS0q8Da0sraRQN+pYtBATYoeLTjmn4kr5wMcNc+blmAhp0A0PhTmwrbPq3FusBmxKULvS4YDpH3FSzSBT/HvvDuD02OOKqboeKE+uXuE=
Received: from MWHPR15MB1678.namprd15.prod.outlook.com (10.175.137.19) by
 MWHPR15MB1853.namprd15.prod.outlook.com (10.174.255.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 15:45:45 +0000
Received: from MWHPR15MB1678.namprd15.prod.outlook.com
 ([fe80::9496:6fad:96ac:4de8]) by MWHPR15MB1678.namprd15.prod.outlook.com
 ([fe80::9496:6fad:96ac:4de8%9]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 15:45:45 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Thread-Topic: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Thread-Index: AQHVrvd2/m3dkWuPP0q/OedznGUuXKe82MkAgABNoACAAUAEgIAAHbiA
Date:   Tue, 17 Dec 2019 15:45:45 +0000
Message-ID: <76684eef-072c-70bb-ed4e-9d23a60eb917@fb.com>
References: <20191210011438.4182911-1-andriin@fb.com>
 <20191210011438.4182911-12-andriin@fb.com>
 <20191216141608.GE14887@linux.fritz.box>
 <CAEf4Bzb2=R0+D0XXrH0N1n1X+7i6aFkACS2gb0xAQFwcBHjVQA@mail.gmail.com>
 <448ba7d2-40c7-5175-c295-8ac123c40a84@iogearbox.net>
In-Reply-To: <448ba7d2-40c7-5175-c295-8ac123c40a84@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0064.namprd14.prod.outlook.com
 (2603:10b6:300:81::26) To MWHPR15MB1678.namprd15.prod.outlook.com
 (2603:10b6:300:11e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:45c8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd957fcf-362a-4ee7-d58b-08d783082e00
x-ms-traffictypediagnostic: MWHPR15MB1853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB18536E23CBC02F11175A21C4D7500@MWHPR15MB1853.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(366004)(346002)(396003)(39860400002)(189003)(199004)(8676002)(66556008)(110136005)(2906002)(6512007)(31686004)(64756008)(54906003)(66476007)(36756003)(5660300002)(66446008)(6486002)(52116002)(71200400001)(86362001)(81156014)(81166006)(2616005)(316002)(478600001)(8936002)(4326008)(53546011)(66946007)(4744005)(31696002)(186003)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1853;H:MWHPR15MB1678.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EkzJX6NoubWxMziMozM2LLnaH4DjoHtuKK7HYGwf6N85WKU1PbA3OI5sBWvfCXjTw5K3WIHl4ivA7heW1P6BfjTiyIC/aYKeAPFRdghHOjXD1ZhYZHeS//3Cl8VcP3dMK6FK7KwbZy+EGq/C1d7nicWNkItq1W7QOz95J+icW1e3P4iNnjGJ4C5vfnLl1EpD607CvOT4IHNHYYiYa9ga7OH/hEtxuPQRUI0xW1NUap7wsEMu3rll2x/TAdfC72+TgL6klDARGYEeqcWxsb2u5z7rXd79ABsCCV7W+E7unOKmICTLWe4lnUMWTKz1hMPeyVgyEf8S4Ratm1kzsA59BH+KXDC/jQD2+LEgFOYuI6zLMnQRItj/TBE+uDM1EJabtNcOYDnEi/ICeUGhVd5GSPIcCys/3+zh1t+4npHjzwBiYPP1palPwzfO5ltVGu0W
Content-Type: text/plain; charset="utf-8"
Content-ID: <2EFDD5C23DB13B47B85457A1C3CAD23D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fd957fcf-362a-4ee7-d58b-08d783082e00
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 15:45:45.4866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WYJxAMNKve0Lf4HFEiHTISI1LlXm0ItbadKofcbZUI2FjPOPU+LDybXEwhb8ZYXn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1853
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_02:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0
 mlxlogscore=558 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912170131
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTcvMTkgNTo1OSBBTSwgRGFuaWVsIEJvcmttYW5uIHdyb3RlOg0KPiBHaXZlbiB0aGlz
IGlzIG1lcmUgb3V0cHV0IG9mIHRoZSBwcm9ncmFtIGFuZCBub3QgZGVyaXZhdGl2ZSB3b3JrIG9m
IGJwZnRvb2wNCj4gaXRzZWxmLCBhcyBpbiBicGZ0b29sIGNvcHlpbmcgY2h1bmtzIG9mIGl0cyBv
d24gY29kZSBpbnRvIHRoZSBnZW5lcmF0ZWQgDQo+IG9uZSwNCj4gdGhpcyBzaG91bGQgbm90IG5l
ZWQgYW55IHJlc3RyaWN0aW9uLCBidXQgdGhlbiB5b3UnZCBzdGlsbCBuZWVkIGxpbmtpbmcNCj4g
YWdhaW5zdCBsaWJicGYgaXRzZWxmIHRvIG1ha2UgZXZlcnl0aGluZyB3b3JrLg0KDQpidHcgZ2Vu
ZXJhdGluZyBzdHVmZiBpcyB0aGUgc2FtZSBhcyBjb21waWxhdGlvbi4gVGhlIGxpY2Vuc2Ugb2Yg
dGhlDQp0b29sIHRoYXQgaXMgZG9pbmcgaXQgaGFzIG5vIGJlYXJpbmcgb24gdGhlIGdlbmVyYXRl
ZCBvdXRwdXQuDQpMaW5raW5nIHdpdGggbGliYnBmIGlzIGRpZmZlcmVudCB0aG91Z2gsIHNpbmNl
IGl0J3MgYSBkZXBlbmRlbmN5IG9mIHRoZSANCm91dHB1dC4gSGVuY2UgbWF0Y2hpbmcgaXQgdG8g
bGliYnBmJ3MgbGljZW5zZSBpcyB0aGUgYmVzdC4NCg==
