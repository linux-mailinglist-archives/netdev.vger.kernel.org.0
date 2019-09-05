Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5D8AAF6D
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 02:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389491AbfIFAAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 20:00:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48736 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388626AbfIFAAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 20:00:08 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85Nxabr014138;
        Thu, 5 Sep 2019 16:59:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=f+iXinyYUyS2fedPNQbbTgshTZz/WG6D78d74e0SogU=;
 b=Hy2Z6/HpsesmlOAZF17xSw86TwFLav2JiyfirQoActOQSLmLRCHufIqv0sZ2msnQtepN
 lKS7Dp2kd2nlJnVVqnNXnqHWpI7qVnpXnMXG7162FjIqkBRFLgGvT3EJ6b3xQw6qAHKc
 UmlcEh7E6ClXhR3l2SoV3ri18KqSoSfdQM4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2utqxfn3b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 05 Sep 2019 16:59:36 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Sep 2019 16:59:35 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Sep 2019 16:59:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7kH8qxMJnkmkGZpwyPu6j9dUU5vG3xh7iroDKRJApK9Gb8tXceRfYcRoYQNVclvUnBluIXOrlFEyquRY7EgTVi576PupqNCHjXr+miQHXKnqPI1EReFd8b+Zx9a2KxWCgRabuWeoWqcyZKB0KJdLXdfMvnALqv2IRyqhlbVk+2zU11JShVVTPpPF7WXtrmTKrKVfrWfIAHVaNqQLFo4gyxQ6eBZwP0qAWYWc0/nysrVdKpUOfDxI5sb1sFFQuMKW2emK0UQiVrx4b/g6b9ZH/AVsZa9ti0sbH1qJeP80UggqnumGDZCN6drPvZlDFPlzDNG1eue6jxbQTqCyHHejg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+iXinyYUyS2fedPNQbbTgshTZz/WG6D78d74e0SogU=;
 b=cnB6IFWZuwnF4jgnZLdFp0VR0UkCw0Iz4AXdo1E0uic930zr7O5t81M9t81saIwfYWObqFWFadV8i1aIUU2BpjHn7Ey2ruxLK61VNERtawRQtrARe8+Kouln9R3dY+j31GE07bLfdTdgBK/lJ7HRha3av6klyc4rHvRR4WpHxdPbA0HM495+vRFsOHaHDBw4d+A/nEMJzZ+VZ66DtpLLxEp9z03dvbdQQ8kN8uRX2udeiCN8pWYAmWQO8sTLnQUOGaOJp6Hd6+7s/rxH6f24RSQtV54elcw2OcMmVfrkhzC4aDr01y80i1mIceT72x5ecBGf2QvD+Rtiny5y0pe3uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+iXinyYUyS2fedPNQbbTgshTZz/WG6D78d74e0SogU=;
 b=HTzF4ji6ke2JvsXH1+pSBjuAdkQJTmlq0hnNkNmvNXX2eYslfIykRYF6wZldqfqPRslRGj235NOM5ZVmjszIw4S0dHAs7Ds/Mj1TK2TR2epUyOom+IoQ1MfWpLeO/VM1yUdXTJMs/YUlPa1EQvaXed0AzOl78DDSCYunqCY716s=
Received: from DM6PR15MB3387.namprd15.prod.outlook.com (20.179.51.80) by
 DM6PR15MB3066.namprd15.prod.outlook.com (20.179.16.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Thu, 5 Sep 2019 23:59:34 +0000
Received: from DM6PR15MB3387.namprd15.prod.outlook.com
 ([fe80::6145:2a97:12be:e75d]) by DM6PR15MB3387.namprd15.prod.outlook.com
 ([fe80::6145:2a97:12be:e75d%6]) with mapi id 15.20.2241.014; Thu, 5 Sep 2019
 23:59:34 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Masahiro Yamada" <yamada.masahiro@socionext.com>
Subject: Re: [PATCH bpf-next] kbuild: replace BASH-specific ${@:2} with shift
 and ${@}
Thread-Topic: [PATCH bpf-next] kbuild: replace BASH-specific ${@:2} with shift
 and ${@}
Thread-Index: AQHVZBPIG0lupYXitESC8G6mSNKOi6cdw8OA
Date:   Thu, 5 Sep 2019 23:59:34 +0000
Message-ID: <0a408cf0-1d18-6a39-84bd-31898de6c10d@fb.com>
References: <20190905175938.599455-1-andriin@fb.com>
In-Reply-To: <20190905175938.599455-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0008.namprd14.prod.outlook.com
 (2603:10b6:301:4b::18) To DM6PR15MB3387.namprd15.prod.outlook.com
 (2603:10b6:5:16d::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:fc2d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31fffaa9-bee4-4496-c49c-08d7325d19e9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR15MB3066;
x-ms-traffictypediagnostic: DM6PR15MB3066:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB30668926F6E1AB8153DE64E2D3BB0@DM6PR15MB3066.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:248;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(376002)(39860400002)(136003)(396003)(199004)(189003)(53936002)(7736002)(8936002)(99286004)(71190400001)(71200400001)(256004)(6116002)(36756003)(66446008)(66476007)(66556008)(14454004)(64756008)(66946007)(386003)(2501003)(8676002)(478600001)(6506007)(53546011)(5660300002)(31686004)(110136005)(2906002)(6512007)(446003)(6486002)(54906003)(476003)(31696002)(316002)(46003)(11346002)(2616005)(6246003)(6436002)(186003)(102836004)(81156014)(81166006)(76176011)(25786009)(52116002)(305945005)(4326008)(486006)(229853002)(86362001)(2201001)(228453006);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3066;H:DM6PR15MB3387.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +WVEj656OslR9hm2dNnCDr71LDNbDemVJnzsoO5T3mBQty0cNW6VZUYMN4nGjuRinkn+PJt/dR4gWSIK1oOiskyoveR/uGiypvR2Za+Idvobqv49CxDvp56uXTr+X7mk3DWBrWFxQCdlxecv18Ws2qEzKUmQy/0wWeBWz7m5c+D7iunIY2WsfM1V6nJ5YriMzva9/ixFLCMckj4QxLIzhem815saTFsWgyYetF0SFCv6RNx9sF9yQXo5Q++9C3O+OzX33SnkYe5upNK5PVxrrQ9qK9ceCCem+raPSCkGb3tf1EnWgZizScQWH4Z6N//ytH18Lb0czPRjJ4u9pJSMnpDKxgpe6hs49x1cwUfFVl5qqfGFJgUSxQuf9ckHvXvPL69pSBgvD0K/+qsbP97niJqiGeQTCgiDZOwjxzRer2E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE885FECE590054096BC25AE285A9106@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 31fffaa9-bee4-4496-c49c-08d7325d19e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 23:59:34.6801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9YGIUFglyQ+HM2BDVzTYBqwifiicZyhHzybBhk1igI6Mc4LrB+NCYGhD9YBJ+I+E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3066
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_10:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=851
 spamscore=0 clxscore=1011 adultscore=0 impostorscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909050224
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvNS8xOSAxMDo1OSBBTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiAke0A6Mn0g
aXMgQkFTSC1zcGVjaWZpYyBleHRlbnNpb24sIHdoaWNoIG1ha2VzIGxpbmstdm1saW51eC5zaCBy
ZWx5IG9uDQo+IEJBU0guIFVzZSBzaGlmdCBhbmQgJHtAfSBpbnN0ZWFkIHRvIGZpeCB0aGlzIGlz
c3VlLg0KPiANCj4gUmVwb3J0ZWQtYnk6IFN0ZXBoZW4gUm90aHdlbGwgPHNmckBjYW5iLmF1dWcu
b3JnLmF1Pg0KPiBGaXhlczogMzQxZGZjZjhkNzhlICgiYnRmOiBleHBvc2UgQlRGIGluZm8gdGhy
b3VnaCBzeXNmcyIpDQo+IENjOiBTdGVwaGVuIFJvdGh3ZWxsIDxzZnJAY2FuYi5hdXVnLm9yZy5h
dT4NCj4gQ2M6IE1hc2FoaXJvIFlhbWFkYSA8eWFtYWRhLm1hc2FoaXJvQHNvY2lvbmV4dC5jb20+
DQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQoNClRl
c3RlZCB3aXRoIGJhc2gvc2gvY3NoLCBhbGwgd29ya3MuDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29u
ZyA8eWhzQGZiLmNvbT4NCg0KPiAtLS0NCj4gICBzY3JpcHRzL2xpbmstdm1saW51eC5zaCB8IDE2
ICsrKysrKysrKysrLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwg
NSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9zY3JpcHRzL2xpbmstdm1saW51eC5z
aCBiL3NjcmlwdHMvbGluay12bWxpbnV4LnNoDQo+IGluZGV4IDBkOGY0MWRiOGNkNi4uOGM1OTk3
MGEwOWRjIDEwMDc1NQ0KPiAtLS0gYS9zY3JpcHRzL2xpbmstdm1saW51eC5zaA0KPiArKysgYi9z
Y3JpcHRzL2xpbmstdm1saW51eC5zaA0KPiBAQCAtNTcsMTIgKzU3LDE2IEBAIG1vZHBvc3RfbGlu
aygpDQo+ICAgDQo+ICAgIyBMaW5rIG9mIHZtbGludXgNCj4gICAjICR7MX0gLSBvdXRwdXQgZmls
ZQ0KPiAtIyAke0A6Mn0gLSBvcHRpb25hbCBleHRyYSAubyBmaWxlcw0KPiArIyAkezJ9LCAkezN9
LCAuLi4gLSBvcHRpb25hbCBleHRyYSAubyBmaWxlcw0KPiAgIHZtbGludXhfbGluaygpDQo+ICAg
ew0KPiAgIAlsb2NhbCBsZHM9IiR7b2JqdHJlZX0vJHtLQlVJTERfTERTfSINCj4gKwlsb2NhbCBv
dXRwdXQ9JHsxfQ0KPiAgIAlsb2NhbCBvYmplY3RzDQo+ICAgDQo+ICsJIyBza2lwIG91dHB1dCBm
aWxlIGFyZ3VtZW50DQo+ICsJc2hpZnQNCj4gKw0KPiAgIAlpZiBbICIke1NSQ0FSQ0h9IiAhPSAi
dW0iIF07IHRoZW4NCj4gICAJCW9iamVjdHM9Ii0td2hvbGUtYXJjaGl2ZQkJCVwNCj4gICAJCQkk
e0tCVUlMRF9WTUxJTlVYX09CSlN9CQkJXA0KPiBAQCAtNzAsOSArNzQsMTAgQEAgdm1saW51eF9s
aW5rKCkNCj4gICAJCQktLXN0YXJ0LWdyb3VwCQkJCVwNCj4gICAJCQkke0tCVUlMRF9WTUxJTlVY
X0xJQlN9CQkJXA0KPiAgIAkJCS0tZW5kLWdyb3VwCQkJCVwNCj4gLQkJCSR7QDoyfSINCj4gKwkJ
CSR7QH0iDQo+ICAgDQo+IC0JCSR7TER9ICR7S0JVSUxEX0xERkxBR1N9ICR7TERGTEFHU192bWxp
bnV4fSAtbyAkezF9CVwNCj4gKwkJJHtMRH0gJHtLQlVJTERfTERGTEFHU30gJHtMREZMQUdTX3Zt
bGludXh9CVwNCj4gKwkJCS1vICR7b3V0cHV0fQkJCQlcDQo+ICAgCQkJLVQgJHtsZHN9ICR7b2Jq
ZWN0c30NCj4gICAJZWxzZQ0KPiAgIAkJb2JqZWN0cz0iLVdsLC0td2hvbGUtYXJjaGl2ZQkJCVwN
Cj4gQEAgLTgxLDkgKzg2LDEwIEBAIHZtbGludXhfbGluaygpDQo+ICAgCQkJLVdsLC0tc3RhcnQt
Z3JvdXAJCQlcDQo+ICAgCQkJJHtLQlVJTERfVk1MSU5VWF9MSUJTfQkJCVwNCj4gICAJCQktV2ws
LS1lbmQtZ3JvdXAJCQkJXA0KPiAtCQkJJHtAOjJ9Ig0KPiArCQkJJHtAfSINCj4gICANCj4gLQkJ
JHtDQ30gJHtDRkxBR1Nfdm1saW51eH0gLW8gJHsxfQkJCVwNCj4gKwkJJHtDQ30gJHtDRkxBR1Nf
dm1saW51eH0JCQkJXA0KPiArCQkJLW8gJHtvdXRwdXR9CQkJCVwNCj4gICAJCQktV2wsLVQsJHts
ZHN9CQkJCVwNCj4gICAJCQkke29iamVjdHN9CQkJCVwNCj4gICAJCQktbHV0aWwgLWxydCAtbHB0
aHJlYWQNCj4gDQo=
