Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797537B503
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387686AbfG3VbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:31:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15832 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727417AbfG3VbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:31:08 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6ULRqf5018350;
        Tue, 30 Jul 2019 14:30:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=idJrbx3/gHPzc6ndL00k945qkUeIYIsKQuLJt4A15wQ=;
 b=SqdhGbj2EZ0JzYNhjGVQIFgLzA/+mzSMH2mxpK3ZJtVWSWGWUz9c9FTDs2xQ89vx/Ep2
 G95tSpl5DrGNJ7ARgotkBqTtmFHN3Mvieh5BJac+Af7nT4IBhFUuPgipePzZBW5RsfWp
 rDSgBEGZzvMUIXI2/BFNaSOApchX8qlrQuA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2we0g3j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jul 2019 14:30:57 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 14:30:57 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 14:30:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFAAPMVxkTBHO6OXdy/9WR+HhlFE0RxvtKA8UqI6eaiX1XtjxNkSl0VdhJcDiGPO/4dpIuyqJkFG+V0jodrVUwnl3Oxbm8DvXD3QbBqSapGXUuXsCyRZpd9LjWc9xvfmSvBBPc54qO8N+8yypY2XVMdMLmcCsaPG8e+TJq2QTB5VZPk2NErUQ9rVz2yeKRWxuXhgCEnX0BIQK3a1ZvhJ+yYjb8s0qEnFpS650tDtBV0VGvLKxJw7iLAEId56jea4Rdat0TEdWLphmyYlD7X2MVSfcsXWjhwbNF/sZArjaTybenVw+XDTdXi4qOzvnK21kiK9RGCQR9itdF5P1fmPTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idJrbx3/gHPzc6ndL00k945qkUeIYIsKQuLJt4A15wQ=;
 b=FOIE5KhaQtWsm/EEAlnwflQnlh2sQsGGkFGnKwLCq7dzwRuVxN37slvoiDzMHj11WASUU1LCYeOo39cLlBm0qOalWYy907ORbYWz7qnd1YBOo3DgH6qJscdRpovX2RKA5+v4cYU8Eb8GcZkHreyWErFUnk6nQylo5u0fFU0b8jRnszdqG9AXMctFme06fyFa604ojS4AaOzcZqq2D61fKedZxSKOFPgSo9Nr0px3rjF9UPV6hJuTR8tY7PfSitgdO5bwCso/hOGA2CnSTYtzBCZEWiLQjns7NPx9tXTBjXucSj3y+0B7m/VfcsbcSXdgGg/DXS4pAs0S4PME71+9bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idJrbx3/gHPzc6ndL00k945qkUeIYIsKQuLJt4A15wQ=;
 b=gDwGWXP2W3XvKPittVSSjnQ7T0NHUIUIL4D0WH0jT6hgHa0tcdkauFCOaUx44UU34ovAIQKAjipWla+u7WhGbKQ8isf1hJzE8khf5bg6BjOo2gGZ6ZRAV0QYbig0YakzhkZG5OJOJJg47hBPNRaFdyXHMKBxeKNBivYInyGUmu0=
Received: from CY4PR15MB1463.namprd15.prod.outlook.com (10.172.159.10) by
 CY4PR15MB1589.namprd15.prod.outlook.com (10.172.162.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Tue, 30 Jul 2019 21:30:55 +0000
Received: from CY4PR15MB1463.namprd15.prod.outlook.com
 ([fe80::84cb:3f:7d6a:40a8]) by CY4PR15MB1463.namprd15.prod.outlook.com
 ([fe80::84cb:3f:7d6a:40a8%8]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 21:30:55 +0000
From:   Jens Axboe <axboe@fb.com>
To:     David Miller <davem@davemloft.net>
CC:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/3 net-next] Finish conversion of skb_frag_t to
 bio_vec
Thread-Topic: [PATCH v2 0/3 net-next] Finish conversion of skb_frag_t to
 bio_vec
Thread-Index: AQHVRuTI2uZuTGFjC0y0p/cGUGkqgKbjoqWAgAAJZACAAAJNAA==
Date:   Tue, 30 Jul 2019 21:30:55 +0000
Message-ID: <d576168e-2893-d48e-3baa-b5e49f65e3b5@fb.com>
References: <20190730144034.444022-1-jonathan.lemon@gmail.com>
 <1d34658b-a807-44ae-756a-d55dead27f94@fb.com>
 <20190730.142238.1475873068715429404.davem@davemloft.net>
In-Reply-To: <20190730.142238.1475873068715429404.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0042.namprd11.prod.outlook.com
 (2603:10b6:a03:80::19) To CY4PR15MB1463.namprd15.prod.outlook.com
 (2603:10b6:903:fa::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [66.29.164.166]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 463ba535-c1d7-41a1-1406-08d715353483
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1589;
x-ms-traffictypediagnostic: CY4PR15MB1589:
x-microsoft-antispam-prvs: <CY4PR15MB15890A632CBFB5C0A8744B5CC0DC0@CY4PR15MB1589.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:272;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(11346002)(6506007)(476003)(2616005)(6246003)(71200400001)(53936002)(71190400001)(6486002)(229853002)(5660300002)(486006)(8936002)(4744005)(478600001)(81166006)(6916009)(31686004)(6512007)(6436002)(8676002)(256004)(6116002)(81156014)(446003)(14454004)(36756003)(3846002)(102836004)(7736002)(76176011)(99286004)(2906002)(68736007)(31696002)(66066001)(54906003)(66946007)(66446008)(64756008)(66556008)(66476007)(52116002)(25786009)(86362001)(26005)(186003)(386003)(4326008)(305945005)(316002)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1589;H:CY4PR15MB1463.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LFyk7lEEFnIz8gbzpVSAnkKBQJ2QZrkuyfzbBXIOOJQHIbKR7BGHqbQ7mOSKTksTzuEhfIoEhsgx03HBgmRSm0qQQ9VkVOcml0iZzpkrjwnckj9Mr+edKhPhox1+B/4PSDgqlIBRyDBrGNvvNAEJ6yULtrAiVaqtvDkIA6mNAb0JBkTY+y+WsSx8PGAtLV0eMIdws7wQreUWXHLRwin6WOb4XIPTYemflGOA2QG5fGqCiRzKbWTXFIMTj72P5BEedAYv/5TR5b8x0U1jJy1oIbufSHIiQYhKAy6pOgHgrXl6TRlbqy2FPP80pE2JSG3a7LE7e9iMese525GJqM4DPUGTc87fdiLKQw34WZUZ150TvLYTuDaLmdtzOpY+SAoZTaqZLoRm68ynSN+Aw1yzV81vnIeyb9BYUmf0lQ1zmdI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C056695AE334F444ABA8E3FE0FA83168@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 463ba535-c1d7-41a1-1406-08d715353483
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 21:30:55.6209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: axboe@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1589
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300213
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8zMC8xOSAzOjIyIFBNLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+IEZyb206IEplbnMgQXhi
b2UgPGF4Ym9lQGZiLmNvbT4NCj4gRGF0ZTogVHVlLCAzMCBKdWwgMjAxOSAyMDo0OTowOSArMDAw
MA0KPiANCj4+IFByZXR0eSBhcHBhbGxlZCB0byBzZWUgdGhpcyBhYm9taW5hdGlvbjoNCj4+DQo+
PiBuZXQ6IENvbnZlcnQgc2tiX2ZyYWdfdCB0byBiaW9fdmVjDQo+Pg0KPj4gVGhlcmUgYXJlIGEg
bG90IG9mIHVzZXJzIG9mIGZyYWctPnBhZ2Vfb2Zmc2V0LCBzbyB1c2UgYSB1bmlvbg0KPj4gdG8g
YXZvaWQgY29udmVydGluZyB0aG9zZSB1c2VycyB0b2RheS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5
OiBNYXR0aGV3IFdpbGNveCAoT3JhY2xlKSA8d2lsbHlAaW5mcmFkZWFkLm9yZz4NCj4+IFNpZ25l
ZC1vZmYtYnk6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4+DQo+PiBz
aG93IHVwIGluIHRoZSBuZXQgdHJlZSB3aXRob3V0IGV2ZW4gaGF2aW5nIGJlZW4gcG9zdGVkIG9u
IGENCj4+IGJsb2NrIGxpc3QuLi4NCj4+DQo+PiBBdCBsZWFzdCB0aGlzIGtpbGxzIHRoaXMgdWds
eSB0aGluZy4NCj4gDQo+IFNvcnJ5IGFib3V0IHRoYXQgSmVucywgYnV0IGF0IGxlYXN0IGFzIHlv
dSBzYXkgaXQncyBnb25lIG5vdy4NCg0KWWVhaCBhbGwgZ29vZCBub3csIHRoYW5rcy4NCg0KLS0g
DQpKZW5zIEF4Ym9lDQoNCg==
