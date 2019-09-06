Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666D3AB4AB
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 11:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404048AbfIFJM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 05:12:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53462 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730704AbfIFJM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 05:12:28 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8699Qjt022761;
        Fri, 6 Sep 2019 02:11:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BAozjhZxnlzjWJY2t0lFuzSHaFnKUh/NlmFHLPRAfio=;
 b=F8TdB1N1oqj5fZUQYgXYLb+n0wO635g5rwMWL2YyzNqNLBrOb9EECoSrJzejoVx5KMLg
 GU5iyYezoSw5RSHI7V0ETG65squ6gZ+SSzbcRashTvsAxzIT8iyiFiUlCT0mVtVu9itx
 l+lP3KTvEFOC9+NthgMKuMyzCjdhz4Rpi5I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uuepws6ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Sep 2019 02:11:57 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 6 Sep 2019 02:11:56 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 6 Sep 2019 02:11:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aog+MqwyyIJXBxv4f80/ftgLJSQrQRQkmAWEIKi6rB7sjJGsQ9k8kduZ6ryE5mJ/3SP5PzTcF1vIYjWvBaNX/QGRJkOzz8IPlqcp3ZGUSvt7fGzgRDjrAK5IOFjTH4kVHHN7GCTOCvRilF5kD9s+sXvo1BoYfwrz/vB3HqeZYo+xscc7H2301ufnxCT6/UxVL+ablLz0oHFsy9Sk6AaUp/diIUQnF1IDxv5qjHlaI1rYaRRCAu09AHU5y8OIpUliSyEuJaWJiL1O3oCKyMIAxrDdcidOhjuVlIdZtxNZUB0R4BdSh1F5Nv38Zw0ALpiU1ZiPvbC2SE0JMfwssfRe7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BAozjhZxnlzjWJY2t0lFuzSHaFnKUh/NlmFHLPRAfio=;
 b=kK15vCWjB6bkZmIMEePjzN/PujDnGgWyfw6fuj+Ro3RMIbaAQqARqDqKSY6ytQM5MRlAQqWQ8o6d7dSZsFNLgbmM2oGPBB7oc+klWGzM8uq4OpPDGEQsRf0c7v54X/4daPrqNSH69JSlkaPOrJzst8la5Syx8YXnIq/qg2y6pOowczy66o7d8fe6kE+686KmMbYZXH/EqxO12Xl36QnTEEqu7WFq4eANHN5R6hQ/SjlNp+1wJXbmDE8k9exnVj4XjVsplPWx3FLFvIqSoJ1gWa8EOlmZfpIGBFDISf7hwQkNIpLL21pL9rgfy6UUQ4AhbUup5cuwHOd4tbzhBzJ0Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BAozjhZxnlzjWJY2t0lFuzSHaFnKUh/NlmFHLPRAfio=;
 b=Xm/3dfC+7tCHe009G3PUTz57RmWYd40N8GmJ87TbCLph1nXeIR0tHcuOANGBZ1y9qd6LsmvKaHBotDFqVQ07eE/Hi+dr5MD3XFFrvvnu+aGbH7eXhxMpNyfobISDii7vnhphqszKWarTZcly7koUntXO9zVWh0yad80emU3CRGw=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1943.namprd15.prod.outlook.com (10.172.180.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Fri, 6 Sep 2019 09:11:55 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::c0da:c2ae:493b:11f2]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::c0da:c2ae:493b:11f2%11]) with mapi id 15.20.2241.014; Fri, 6 Sep 2019
 09:11:55 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Yonghong Song <yhs@fb.com>,
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
Thread-Index: AQHVZBPCW7VbNCMPfEmG3EKerF78hKcdw8YAgACaSoA=
Date:   Fri, 6 Sep 2019 09:11:54 +0000
Message-ID: <60fc2420-ffed-0c71-f8ad-77bfe16970a0@fb.com>
References: <20190905175938.599455-1-andriin@fb.com>
 <0a408cf0-1d18-6a39-84bd-31898de6c10d@fb.com>
In-Reply-To: <0a408cf0-1d18-6a39-84bd-31898de6c10d@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LNXP265CA0007.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::19) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c092:180::1:5dd3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12467301-1d82-4475-9427-08d732aa4320
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR15MB1943;
x-ms-traffictypediagnostic: CY4PR15MB1943:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB194348BBCB9BA23FA5C537A9C6BA0@CY4PR15MB1943.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(396003)(376002)(346002)(199004)(189003)(65956001)(65806001)(6436002)(4326008)(66946007)(6116002)(66476007)(52116002)(25786009)(64756008)(66446008)(66556008)(7736002)(71200400001)(76176011)(71190400001)(305945005)(53936002)(36756003)(8676002)(54906003)(8936002)(6246003)(2906002)(81156014)(81166006)(186003)(110136005)(31686004)(476003)(46003)(102836004)(256004)(486006)(14454004)(53546011)(99286004)(2616005)(14444005)(229853002)(6506007)(478600001)(2501003)(6512007)(386003)(11346002)(5660300002)(316002)(446003)(2201001)(6486002)(86362001)(31696002)(58126008)(228453006);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1943;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OS/cMc5O6TMD/zzqH0Nq4jCeargseQltW2c5kk8C9Y7sqswY8EnDX5K9GClTzcF+s/h4WKu4UnYi2YDUAmrz68/7n8TXmyz5lAccexxvtzCKYciaWX1nPknnSwfyTU4fH2klh93ClCU2ybMdygTemMiQ/P0qU3qazVfIQ8xILa+symIqofNeTkYCaJLGeWlmFEORjMGVefxb8oXgQh5gzz7xz1ZkSXfwOvBpmK9qbOeefcB6uCxRuqSdF9/DYKMaP/zDnr1Iah1G+MngWM3GgL7yf8/i4VHSGzgmZA4B7qHJ1RAxO2oRt+Tja5j4qCacvOSLxhN2BcBlJ+U6ctQGaSZ9VP4yoiVLa13m0MQN/BVGrumD0kFSFfaiah74FPP1VUg6Mq7prVROtaI1g+JHXoQFoP61W6ZJpb101EfgN8U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F90585B8A91BD479871CDA8EDB98013@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 12467301-1d82-4475-9427-08d732aa4320
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 09:11:54.9981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h64Gos20yYbIvZHNrdN+S1DZa9WPIJ2dDyOS4BrE3hMFxCGPflCD96KOi714huNZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1943
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_04:2019-09-04,2019-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909060097
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS82LzE5IDEyOjU5IEFNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPiANCj4gDQo+IE9uIDkv
NS8xOSAxMDo1OSBBTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPj4gJHtAOjJ9IGlzIEJBU0gt
c3BlY2lmaWMgZXh0ZW5zaW9uLCB3aGljaCBtYWtlcyBsaW5rLXZtbGludXguc2ggcmVseSBvbg0K
Pj4gQkFTSC4gVXNlIHNoaWZ0IGFuZCAke0B9IGluc3RlYWQgdG8gZml4IHRoaXMgaXNzdWUuDQo+
Pg0KPj4gUmVwb3J0ZWQtYnk6IFN0ZXBoZW4gUm90aHdlbGwgPHNmckBjYW5iLmF1dWcub3JnLmF1
Pg0KPj4gRml4ZXM6IDM0MWRmY2Y4ZDc4ZSAoImJ0ZjogZXhwb3NlIEJURiBpbmZvIHRocm91Z2gg
c3lzZnMiKQ0KPj4gQ2M6IFN0ZXBoZW4gUm90aHdlbGwgPHNmckBjYW5iLmF1dWcub3JnLmF1Pg0K
Pj4gQ2M6IE1hc2FoaXJvIFlhbWFkYSA8eWFtYWRhLm1hc2FoaXJvQHNvY2lvbmV4dC5jb20+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KPiANCj4g
VGVzdGVkIHdpdGggYmFzaC9zaC9jc2gsIGFsbCB3b3Jrcy4NCg0KVGhhbmtzIGZvciB0ZXN0aW5n
LCBZb25naG9uZyEgSW4gbXkgc3lzdGVtIHNoIGlzIGFuIGFsaWFzIHRvIGJhc2gsIHNvIGl0IA0K
c3RpbGwgYmVoYXZlZCBsaWtlIGJhc2ggYW5kIGRpZG4ndCBmYWlsIGV2ZW4gd2l0aCBleGlzdGlu
ZyBjb2RlLiBJIA0KZGlkbid0IGhhdmUgYW4gb3Bwb3J0dW5pdHkgdG8gaW5zdGFsbCBjc2ggYXQg
dGhhdCB0aW1lIGFuZCB0cnkgaXQsIHNvIA0KdGhhbmtzIGEgbG90IGZvciBjb25maXJtaW5nLiBJ
IGJhc2ljYWxseSByZWxpZWQgb24gZG9jdW1lbnRhdGlvbiB0byANCnZlcmlmeSBzaGlmdCBhbmQg
JEAgaXMgbm90IEJBU0gnaXNtLg0KDQo+IEFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIu
Y29tPg0KPiANCj4+IC0tLQ0KPj4gICAgc2NyaXB0cy9saW5rLXZtbGludXguc2ggfCAxNiArKysr
KysrKysrKy0tLS0tDQo+PiAgICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgNSBk
ZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvc2NyaXB0cy9saW5rLXZtbGludXguc2gg
Yi9zY3JpcHRzL2xpbmstdm1saW51eC5zaA0KPj4gaW5kZXggMGQ4ZjQxZGI4Y2Q2Li44YzU5OTcw
YTA5ZGMgMTAwNzU1DQo+PiAtLS0gYS9zY3JpcHRzL2xpbmstdm1saW51eC5zaA0KPj4gKysrIGIv
c2NyaXB0cy9saW5rLXZtbGludXguc2gNCj4+IEBAIC01NywxMiArNTcsMTYgQEAgbW9kcG9zdF9s
aW5rKCkNCj4+ICAgIA0KPj4gICAgIyBMaW5rIG9mIHZtbGludXgNCj4+ICAgICMgJHsxfSAtIG91
dHB1dCBmaWxlDQo+PiAtIyAke0A6Mn0gLSBvcHRpb25hbCBleHRyYSAubyBmaWxlcw0KPj4gKyMg
JHsyfSwgJHszfSwgLi4uIC0gb3B0aW9uYWwgZXh0cmEgLm8gZmlsZXMNCj4+ICAgIHZtbGludXhf
bGluaygpDQo+PiAgICB7DQo+PiAgICAJbG9jYWwgbGRzPSIke29ianRyZWV9LyR7S0JVSUxEX0xE
U30iDQo+PiArCWxvY2FsIG91dHB1dD0kezF9DQo+PiAgICAJbG9jYWwgb2JqZWN0cw0KPj4gICAg
DQo+PiArCSMgc2tpcCBvdXRwdXQgZmlsZSBhcmd1bWVudA0KPj4gKwlzaGlmdA0KPj4gKw0KPj4g
ICAgCWlmIFsgIiR7U1JDQVJDSH0iICE9ICJ1bSIgXTsgdGhlbg0KPj4gICAgCQlvYmplY3RzPSIt
LXdob2xlLWFyY2hpdmUJCQlcDQo+PiAgICAJCQkke0tCVUlMRF9WTUxJTlVYX09CSlN9CQkJXA0K
Pj4gQEAgLTcwLDkgKzc0LDEwIEBAIHZtbGludXhfbGluaygpDQo+PiAgICAJCQktLXN0YXJ0LWdy
b3VwCQkJCVwNCj4+ICAgIAkJCSR7S0JVSUxEX1ZNTElOVVhfTElCU30JCQlcDQo+PiAgICAJCQkt
LWVuZC1ncm91cAkJCQlcDQo+PiAtCQkJJHtAOjJ9Ig0KPj4gKwkJCSR7QH0iDQo+PiAgICANCj4+
IC0JCSR7TER9ICR7S0JVSUxEX0xERkxBR1N9ICR7TERGTEFHU192bWxpbnV4fSAtbyAkezF9CVwN
Cj4+ICsJCSR7TER9ICR7S0JVSUxEX0xERkxBR1N9ICR7TERGTEFHU192bWxpbnV4fQlcDQo+PiAr
CQkJLW8gJHtvdXRwdXR9CQkJCVwNCj4+ICAgIAkJCS1UICR7bGRzfSAke29iamVjdHN9DQo+PiAg
ICAJZWxzZQ0KPj4gICAgCQlvYmplY3RzPSItV2wsLS13aG9sZS1hcmNoaXZlCQkJXA0KPj4gQEAg
LTgxLDkgKzg2LDEwIEBAIHZtbGludXhfbGluaygpDQo+PiAgICAJCQktV2wsLS1zdGFydC1ncm91
cAkJCVwNCj4+ICAgIAkJCSR7S0JVSUxEX1ZNTElOVVhfTElCU30JCQlcDQo+PiAgICAJCQktV2ws
LS1lbmQtZ3JvdXAJCQkJXA0KPj4gLQkJCSR7QDoyfSINCj4+ICsJCQkke0B9Ig0KPj4gICAgDQo+
PiAtCQkke0NDfSAke0NGTEFHU192bWxpbnV4fSAtbyAkezF9CQkJXA0KPj4gKwkJJHtDQ30gJHtD
RkxBR1Nfdm1saW51eH0JCQkJXA0KPj4gKwkJCS1vICR7b3V0cHV0fQkJCQlcDQo+PiAgICAJCQkt
V2wsLVQsJHtsZHN9CQkJCVwNCj4+ICAgIAkJCSR7b2JqZWN0c30JCQkJXA0KPj4gICAgCQkJLWx1
dGlsIC1scnQgLWxwdGhyZWFkDQo+Pg0KDQo=
