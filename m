Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522F7DBA6F
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 02:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441863AbfJRAIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 20:08:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57306 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438886AbfJRAHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 20:07:45 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9I05H4l029086;
        Thu, 17 Oct 2019 17:06:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Rbp4Qq9554/grL3Vx6k2Wr74pTPjZT2gt2xuJmzCpvU=;
 b=aV96sueG3fTPp2CMJ6VSHJWVId88DWeSXDZ4/Gztb5n3ZddxRpWRoZfeCC+i5RB1bZKY
 HUiNX2xWPUV+2bw7Imy+qeqy5Gx/b7JPJ2LP6Ebg2KZonDOhL/7qdEuItxcsTXPdHsow
 ZDoDXl0mEBba0KJZETU31PigvUKQTcASd5s= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vpw9r9d0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Oct 2019 17:06:26 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 17 Oct 2019 17:06:25 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Oct 2019 17:06:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUt9PUGagkfHkEoEZv3eJUCOED2+MPod/c7gCgFeQaeduCjAbub8Kvdr6p25Kr6VAywv51mOUGLqfSFDKyRm1K3x159NEt8/Vf0xqWCPJOGkj32c/zwNSCSe5bH7CpGs/6AwfXKEbE3guiKvAJr4KcaWekM7x3oxQix89TaA3VPEbse8H+rAZOiXl7VBR+TeiIcCULUjopxGqiHUXGVWMWnPD102DNWTKzSJaVLaHDjgXkUEQGSHsN/fJ2jHImQjt8q96Mk9S7ClPaJ4p4l44TjFHky/odF8zs9+8vBYnSpxvHXJ++QmIj9OBcPkjo8cfBlscC+gqKC9VEaQnu2u5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rbp4Qq9554/grL3Vx6k2Wr74pTPjZT2gt2xuJmzCpvU=;
 b=Bb/nVPo1JS6XBEX6yoSSVvTco9iW1r++PBsUzHHDw1f1icFBvL49B52xAb9dIdH72iGG/dV6RQG2ORqxzVG+3u6w5EdKkhCsSVOUqOLDYeXfxi+U0XvVaLh2mW7sRC4x2YU6+CMqZbwE6ooS5/EXVnoDHImzFB1IKYlE8laGNFjA6zrQjk5ZLXi2NKLGrwNSB4qoBtMvl1nP+Uym5ednrTvUZB6ESmHtmeVRLKz95wtBp4RiBPagm7RrjJxZlKm0My6dYO8yz2BqVGwqWBoDRVYXtP/w5axetceNW7XIvn0gwqprNFAi6X3SAqBhs/n2I0BRdLqrPUSJsHHZy0xdWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rbp4Qq9554/grL3Vx6k2Wr74pTPjZT2gt2xuJmzCpvU=;
 b=QGuBvW+beD4MymUZ7ejEKKyEMOFQlYzqn5Ac2GLUhRPUfCw3jSMzd2tOlgM8JfoSETltaDpRaUn3nXvkv/9uopaAlkSMi/kfoZOaAuHDG8Mtlkd6JaIdZFlnr+Ym0vUUgKfqgOhCn0kkf2YDIeBkBK64XWoY+MBKPce23gzXY2c=
Received: from BY5PR15MB3636.namprd15.prod.outlook.com (52.133.252.91) by
 BY5PR15MB3683.namprd15.prod.outlook.com (52.133.255.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 00:06:23 +0000
Received: from BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c]) by BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c%4]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 00:06:23 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "Sven Van Asbroeck" <TheSven73@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Bhupesh Sharma" <bhsharma@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
Thread-Topic: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
Thread-Index: AQHVgIJ8iNM2JFB8dkCGpaKji+MwkKdeE2WAgADjLwCAAIm8gP//mREA
Date:   Fri, 18 Oct 2019 00:06:23 +0000
Message-ID: <9AA81274-01F2-4803-8905-26F0521486CE@fb.com>
References: <20191011213027.2110008-1-vijaykhemka@fb.com>
 <3a1176067b745fddfc625bbd142a41913ee3e3a1.camel@kernel.crashing.org>
 <0C0BC813-5A84-403F-9C48-9447AAABD867@fb.com>
 <071cf1eeefcbfc14633a13bc2d15ad7392987a88.camel@kernel.crashing.org>
In-Reply-To: <071cf1eeefcbfc14633a13bc2d15ad7392987a88.camel@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::3:f653]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29293bc6-7e91-4b5c-78b2-08d7535f031e
x-ms-traffictypediagnostic: BY5PR15MB3683:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB368333D398071CCC51B3F337DD6C0@BY5PR15MB3683.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(6246003)(11346002)(76176011)(229853002)(6486002)(86362001)(2201001)(25786009)(2501003)(99286004)(2906002)(8936002)(33656002)(5660300002)(6436002)(66946007)(76116006)(91956017)(71200400001)(6512007)(81156014)(71190400001)(66446008)(64756008)(66556008)(46003)(36756003)(8676002)(66476007)(81166006)(4001150100001)(14444005)(6116002)(102836004)(305945005)(446003)(7416002)(256004)(53546011)(186003)(316002)(110136005)(54906003)(14454004)(7736002)(4326008)(486006)(6506007)(476003)(2616005)(478600001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR15MB3683;H:BY5PR15MB3636.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ufHheQ/Oh9HQc7sQh4KwZIP0/e52Vk1LsFzdsHHT4EcqEvN9GPK78l7hI1yeNGkLapg/ez7rnq/PMpkBwEzcKpBr1XG4BtctWVP8DULcxSw5cw4JbfL5AGcVVx+WJuTo9XYXbER/nxg0UHnRg2YrAPd5EwnOa6qDYG/QYGT3EjGedKEUYD3WDMgGw+1mkcUk8fbxixL/wRuq9xDx5Kem5D/aB8+DHcIrg5jeMnyJdsmq63gk1inTDDYPwAq7sFane7Cc6ghI6WxmFF40CHtWz4I7zdr5co1w7fgxX/7f75dxiPCYqFlUkdCG467h2g1fMYPfS0s0EhJnNSEq7YDiQW8VwXRMu5XwyEcDkBEqejBSR3ws22KzoWnRBY+5Ry7vsD9zr6uaz8upY2V4FzzRKosGMGo0STLFXmHG6eZTDr0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B707CD5D0301A42A8FA26CEFBB29C05@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 29293bc6-7e91-4b5c-78b2-08d7535f031e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 00:06:23.4222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Pd0rnq5dcqAMTaDBUcwGPTG8ec3mhvirIDkclROT+kajqawbA/YnRM/0zNx1c4qWukItBNq1TAVgy8j/tf/OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3683
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-17_07:2019-10-17,2019-10-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 suspectscore=0 phishscore=0 clxscore=1015
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910170214
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDEwLzE3LzE5LCA0OjE1IFBNLCAiQmVuamFtaW4gSGVycmVuc2NobWlkdCIgPGJl
bmhAa2VybmVsLmNyYXNoaW5nLm9yZz4gd3JvdGU6DQoNCiAgICBPbiBUaHUsIDIwMTktMTAtMTcg
YXQgMjI6MDEgKzAwMDAsIFZpamF5IEtoZW1rYSB3cm90ZToNCiAgICA+IA0KICAgID4gT24gMTAv
MTYvMTksIDY6MjkgUE0sICJCZW5qYW1pbiBIZXJyZW5zY2htaWR0IiA8YmVuaEBrZXJuZWwuY3Jh
c2hpbmcub3JnPiB3cm90ZToNCiAgICA+IA0KICAgID4gICAgIE9uIEZyaSwgMjAxOS0xMC0xMSBh
dCAxNDozMCAtMDcwMCwgVmlqYXkgS2hlbWthIHdyb3RlOg0KICAgID4gICAgID4gSFcgY2hlY2tz
dW0gZ2VuZXJhdGlvbiBpcyBub3Qgd29ya2luZyBmb3IgQVNUMjUwMCwgc3BlY2lhbGx5IHdpdGgN
CiAgICA+ICAgICA+IElQVjYNCiAgICA+ICAgICA+IG92ZXIgTkNTSS4gQWxsIFRDUCBwYWNrZXRz
IHdpdGggSVB2NiBnZXQgZHJvcHBlZC4gQnkgZGlzYWJsaW5nIHRoaXMNCiAgICA+ICAgICA+IGl0
IHdvcmtzIHBlcmZlY3RseSBmaW5lIHdpdGggSVBWNi4gQXMgaXQgd29ya3MgZm9yIElQVjQgc28g
ZW5hYmxlZA0KICAgID4gICAgID4gaHcgY2hlY2tzdW0gYmFjayBmb3IgSVBWNC4NCiAgICA+ICAg
ICA+IA0KICAgID4gICAgID4gVmVyaWZpZWQgd2l0aCBJUFY2IGVuYWJsZWQgYW5kIGNhbiBkbyBz
c2guDQogICAgPiAgICAgDQogICAgPiAgICAgU28gd2hpbGUgdGhpcyBwcm9iYWJseSB3b3Jrcywg
SSBkb24ndCB0aGluayB0aGlzIGlzIHRoZSByaWdodA0KICAgID4gICAgIGFwcHJvYWNoLCBhdCBs
ZWFzdCBhY2NvcmRpbmcgdG8gdGhlIGNvbW1lbnRzIGluIHNrYnVmZi5oDQogICAgPiANCiAgICA+
IFRoaXMgaXMgbm90IGEgbWF0dGVyIG9mIHVuc3VwcG9ydGVkIGNzdW0sIGl0IGlzIGJyb2tlbiBo
dyBjc3VtLiANCiAgICA+IFRoYXQncyB3aHkgd2UgZGlzYWJsZSBodyBjaGVja3N1bS4gTXkgZ3Vl
c3MgaXMgb25jZSB3ZSBkaXNhYmxlDQogICAgPiBIdyBjaGVja3N1bSwgaXQgd2lsbCB1c2Ugc3cg
Y2hlY2tzdW0uIFNvIEkgYW0ganVzdCBkaXNhYmxpbmcgaHcgDQogICAgPiBDaGVja3N1bS4NCiAg
ICANCiAgICBJIGRvbid0IHVuZGVyc3RhbmQgd2hhdCB5b3UgYXJlIHNheWluZy4gWW91IHJlcG9y
dGVkIGEgcHJvYmxlbSB3aXRoDQogICAgSVBWNiBjaGVja3N1bXMgZ2VuZXJhdGlvbi4gVGhlIEhX
IGRvZXNuJ3Qgc3VwcG9ydCBpdC4gV2hhdCdzICJub3QgYQ0KICAgIG1hdHRlciBvZiB1bnN1cHBv
cnRlZCBjc3VtIiA/DQogICAgDQogICAgWW91ciBwYXRjaCB1c2VzIGEgKmRlcHJlY2F0ZWQqIGJp
dCB0byB0ZWxsIHRoZSBuZXR3b3JrIHN0YWNrIHRvIG9ubHkgZG8NCiAgICBIVyBjaGVja3N1bSBn
ZW5lcmF0aW9uIG9uIElQVjQuDQogICAgDQogICAgVGhpcyBiaXQgaXMgZGVwcmVjYXRlZCBmb3Ig
YSByZWFzb24sIGFnYWluLCBzZWUgc2tidWZmLmguIFRoZSByaWdodA0KICAgIGFwcHJvYWNoLCAq
d2hpY2ggdGhlIGRyaXZlciBhbHJlYWR5IGRvZXMqLCBpcyB0byB0ZWxsIHRoZSBzdGFjayB0aGF0
IHdlDQogICAgc3VwcG9ydCBIVyBjaGVja3N1bWluZyB1c2luZyBORVRJRl9GX0hXX0NTVU0sIGFu
ZCB0aGVuLCBpbiB0aGUgdHJhbnNtaXQNCiAgICBoYW5kbGVyLCB0byBjYWxsIHNrYl9jaGVja3N1
bV9oZWxwKCkgdG8gaGF2ZSB0aGUgU1cgY2FsY3VsYXRlIHRoZQ0KICAgIGNoZWNrc3VtIGlmIGl0
J3Mgbm90IGEgc3VwcG9ydGVkIHR5cGUuDQoNCk15IHVuZGVyc3RhbmRpbmcgd2FzIHdoZW4gd2Ug
ZW5hYmxlIE5FVElGX0ZfSFdfQ1NVTSBtZWFucyBuZXR3b3JrIA0Kc3RhY2sgZW5hYmxlcyBIVyBj
aGVja3N1bSBhbmQgZG9lc24ndCBjYWxjdWxhdGUgU1cgY2hlY2tzdW0uIEJ1dCBhcyBwZXINCnRo
aXMgc3VwcG9ydGVkIHR5cGVzIEhXIGNoZWNrc3VtIGFyZSB1c2VkIG9ubHkgZm9yIElQVjQgYW5k
IG5vdCBmb3IgSVBWNiBldmVuDQp0aG91Z2ggZHJpdmVyIGVuYWJsZWQgTkVUSUZfRl9IV19DU1VN
LiBGb3IgSVBWNiBpdCBpcyBhbHdheXMgYSBTVyBnZW5lcmF0ZWQNCmNoZWNrc3VtLCBwbGVhc2Ug
Y29ycmVjdCBtZSBoZXJlLg0KICAgIA0KICAgIFRoaXMgaXMgZXhhY3RseSB3aGF0IGZ0Z21hYzEw
MF9wcmVwX3R4X2NzdW0oKSBkb2VzLiBJdCBvbmx5IGVuYWJsZXMgSFcNCiAgICBjaGVja3N1bSBn
ZW5lcmF0aW9uIG9uIHN1cHBvcnRlZCB0eXBlcyBhbmQgdXNlcyBza2JfY2hlY2tzdW1faGVscCgp
DQogICAgb3RoZXJ3aXNlLCBzdXBwb3J0ZWQgdHlwZXMgYmVpbmcgcHJvdG9jb2wgRVRIX1BfSVAg
YW5kIElQIHByb3RvY29sDQogICAgYmVpbmcgcmF3IElQLCBUQ1AgYW5kIFVEUC4NCg0KICAgIA0K
ICAgIFNvIHRoaXMgKnNob3VsZCogaGF2ZSBmYWxsZW4gYmFjayB0byBTVyBmb3IgSVBWNi4gU28g
ZWl0aGVyIHNvbWV0aGluZw0KICAgIGluIG15IGNvZGUgdGhlcmUgaXMgbWFraW5nIGFuIGluY29y
cmVjdCBhc3N1bXB0aW9uLCBvciBzb21ldGhpbmcgaXMNCiAgICBicm9rZW4gaW4gc2tiX2NoZWNr
c3VtX2hlbHAoKSBmb3IgSVBWNiAod2hpY2ggSSBzb21ld2hhdCBkb3VidCkgb3INCiAgICBzb21l
dGhpbmcgZWxzZSBJIGNhbid0IHRoaW5rIG9mLCBidXQgc2V0dGluZyBhICpkZXByZWNhdGVkKiBm
bGFnIGlzDQogICAgZGVmaW5pdGVseSBub3QgdGhlIHJpZ2h0IGFuc3dlciwgbmVpdGhlciBpcyBj
b21wbGV0ZWx5IGRpc2FibGluZyBIVw0KICAgIGNoZWNrc3VtbWluZy4NCiAgICANCiAgICBTbyBj
YW4geW91IGludmVzdGlnYXRlIHdoYXQncyBnb2luZyBvbiBhIGJpdCBtb3JlIGNsb3NlbHkgcGxl
YXNlID8gSQ0KICAgIGNhbiB0cnkgbXlzZWxmLCB0aG91Z2ggSSBoYXZlIHZlcnkgbGl0dGxlIGV4
cGVyaWVuY2Ugd2l0aCBJUFY2IGFuZA0KICAgIHByb2JhYmx5IHdvbid0IGhhdmUgdGltZSBiZWZv
cmUgbmV4dCB3ZWVrLg0KICAgIA0KICAgIENoZWVycywNCiAgICBCZW4uDQogICAgDQogICAgPiAg
ICAgVGhlIGRyaXZlciBzaG91bGQgaGF2ZSBoYW5kbGVkIHVuc3VwcG9ydGVkIGNzdW0gdmlhIFNX
IGZhbGxiYWNrDQogICAgPiAgICAgYWxyZWFkeSBpbiBmdGdtYWMxMDBfcHJlcF90eF9jc3VtKCkN
CiAgICA+ICAgICANCiAgICA+ICAgICBDYW4geW91IGNoZWNrIHdoeSB0aGlzIGRpZG4ndCB3b3Jr
IGZvciB5b3UgPw0KICAgID4gICAgIA0KICAgID4gICAgIENoZWVycywNCiAgICA+ICAgICBCZW4u
DQogICAgPiAgICAgDQogICAgPiAgICAgPiBTaWduZWQtb2ZmLWJ5OiBWaWpheSBLaGVta2EgPHZp
amF5a2hlbWthQGZiLmNvbT4NCiAgICA+ICAgICA+IC0tLQ0KICAgID4gICAgID4gQ2hhbmdlcyBz
aW5jZSB2MToNCiAgICA+ICAgICA+ICBFbmFibGVkIElQVjQgaHcgY2hlY2tzdW0gZ2VuZXJhdGlv
biBhcyBpdCB3b3JrcyBmb3IgSVBWNC4NCiAgICA+ICAgICA+IA0KICAgID4gICAgID4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMgfCAxMyArKysrKysrKysrKystDQog
ICAgPiAgICAgPiAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkNCiAgICA+ICAgICA+IA0KICAgID4gICAgID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMNCiAgICA+ICAgICA+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYw0KICAgID4gICAgID4gaW5kZXggMDMwZmVkNjUzOTNl
Li4wMjU1YTI4ZDI5NTggMTAwNjQ0DQogICAgPiAgICAgPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAgPiAgICAgPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAgPiAgICAgPiBAQCAtMTg0Miw4ICsxODQy
LDE5IEBAIHN0YXRpYyBpbnQgZnRnbWFjMTAwX3Byb2JlKHN0cnVjdA0KICAgID4gICAgID4gcGxh
dGZvcm1fZGV2aWNlICpwZGV2KQ0KICAgID4gICAgID4gIAkvKiBBU1QyNDAwICBkb2Vzbid0IGhh
dmUgd29ya2luZyBIVyBjaGVja3N1bSBnZW5lcmF0aW9uICovDQogICAgPiAgICAgPiAgCWlmIChu
cCAmJiAob2ZfZGV2aWNlX2lzX2NvbXBhdGlibGUobnAsICJhc3BlZWQsYXN0MjQwMC1tYWMiKSkp
DQogICAgPiAgICAgPiAgCQluZXRkZXYtPmh3X2ZlYXR1cmVzICY9IH5ORVRJRl9GX0hXX0NTVU07
DQogICAgPiAgICAgPiArDQogICAgPiAgICAgPiArCS8qIEFTVDI1MDAgZG9lc24ndCBoYXZlIHdv
cmtpbmcgSFcgY2hlY2tzdW0gZ2VuZXJhdGlvbiBmb3IgSVBWNg0KICAgID4gICAgID4gKwkgKiBi
dXQgaXQgd29ya3MgZm9yIElQVjQsIHNvIGRpc2FibGluZyBodyBjaGVja3N1bSBhbmQgZW5hYmxp
bmcNCiAgICA+ICAgICA+ICsJICogaXQgZm9yIG9ubHkgSVBWNC4NCiAgICA+ICAgICA+ICsJICov
DQogICAgPiAgICAgPiArCWlmIChucCAmJiAob2ZfZGV2aWNlX2lzX2NvbXBhdGlibGUobnAsICJh
c3BlZWQsYXN0MjUwMC1tYWMiKSkpDQogICAgPiAgICAgPiB7DQogICAgPiAgICAgPiArCQluZXRk
ZXYtPmh3X2ZlYXR1cmVzICY9IH5ORVRJRl9GX0hXX0NTVU07DQogICAgPiAgICAgPiArCQluZXRk
ZXYtPmh3X2ZlYXR1cmVzIHw9IE5FVElGX0ZfSVBfQ1NVTTsNCiAgICA+ICAgICA+ICsJfQ0KICAg
ID4gICAgID4gKw0KICAgID4gICAgID4gIAlpZiAobnAgJiYgb2ZfZ2V0X3Byb3BlcnR5KG5wLCAi
bm8taHctY2hlY2tzdW0iLCBOVUxMKSkNCiAgICA+ICAgICA+IC0JCW5ldGRldi0+aHdfZmVhdHVy
ZXMgJj0gfihORVRJRl9GX0hXX0NTVU0gfA0KICAgID4gICAgID4gTkVUSUZfRl9SWENTVU0pOw0K
ICAgID4gICAgID4gKwkJbmV0ZGV2LT5od19mZWF0dXJlcyAmPSB+KE5FVElGX0ZfSFdfQ1NVTSB8
DQogICAgPiAgICAgPiBORVRJRl9GX1JYQ1NVTQ0KICAgID4gICAgID4gKwkJCQkJIHwgTkVUSUZf
Rl9JUF9DU1VNKTsNCiAgICA+ICAgICA+ICAJbmV0ZGV2LT5mZWF0dXJlcyB8PSBuZXRkZXYtPmh3
X2ZlYXR1cmVzOw0KICAgID4gICAgID4gIA0KICAgID4gICAgID4gIAkvKiByZWdpc3RlciBuZXR3
b3JrIGRldmljZSAqLw0KICAgID4gICAgIA0KICAgID4gICAgIA0KICAgID4gDQogICAgDQogICAg
DQoNCg==
