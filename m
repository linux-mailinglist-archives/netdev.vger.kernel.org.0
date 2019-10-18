Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457F4DD51D
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387908AbfJRWwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:52:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9926 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727430AbfJRWwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 18:52:16 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9IMoe8Q021333;
        Fri, 18 Oct 2019 15:50:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pBzsCUeUffUEUVjKG4/znE6MgrXuZnKXCLFoooGajGs=;
 b=T49l91NnF7DV9JAbAJPPJBnJPtQtlneDib5p/jQvWfocXiouKhRGpcGjGHjLXCkKw7nY
 B0X50lVQ+u0PkI8WUvuEQ6erDqprqlnuW7wTFvaYJX9yW2hDfKCfnkayHyi9frOv69K7
 U1dN+2HY/fU4JtE4ZZAB1OX4Q8q5e91znuA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vqgss9n3m-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 15:50:47 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 15:50:33 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 15:50:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhZsoG0FHXhgwUa33F1U3JVLmeM+5+9Hzpn+U/fHJktx7dNRAxwE4lr2LsL3Cwz+ZOo47N0BTeEw/aUh4A8wTU6/hST/bO7MkkmsnaNVo0qzi+sAvnGNgWPL0LUgFkmVaS/6TDkVNlmkoYP/Z64pf5mpNj26zNi5lgzXocqvK98G+NSR7yV/xtHnX11xy1VV4/uBBtVFZZY6gRwuuriZwaUOF+XVXfq6NGPFwi0XCWYdYRWmqUjOBM/v3/WLZrERCJeT5DzuVEZr5GGhHfJyQIOzp6WlP1YWjzBaAYQqggdt/fYPmy9BIpWTLuW4eu1Gz1Cx+oU7LHMMrbrLvyoNFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBzsCUeUffUEUVjKG4/znE6MgrXuZnKXCLFoooGajGs=;
 b=Op3UZwsngpE/yCuRpQZaHnBI2KuaQkqS0kc8LjR/nkBm/iE3VEg7NlZkzPmdxUpVVac+1Fwy+XdjzkLhKGE7s5L3rGObfPIaspNovzfv0EeBYYFKtdoVszjGE2cmS3Jt4gycqQw+2CVVZbIvPigx5LDgB5RP266dl6xphgDGyUMH/qZmfxGir8g+ulajvhM8qLL3RYFi5T/w6MacfjtyOQ5wqGjtDzuq5ISalchX+52ZFgg4WFS+omfzZyT3ACv2NNLba6My5C+Rhj0Qe02wT6+paT4WM73yiTP5yW+1qlYRI6ez74nojEG8FUSipX8mHamnpkUnkORliFTs854fzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBzsCUeUffUEUVjKG4/znE6MgrXuZnKXCLFoooGajGs=;
 b=BkoZ5ZXmKtI8pXCxPgKdBdZgfEUHS/a2UWmNuCrqF1EU35/rOymcTg/0M7gd2JOCx6pvxh0vfOtnm83Y4JHvIDVgVkk32ie7FiJ8jnE8xPRuspQmTb+n8POVpmStYPyCG252Lg53hhkukXDeOuIRLKRV3UNdbCjecV2HEF6XkXA=
Received: from BY5PR15MB3636.namprd15.prod.outlook.com (52.133.252.91) by
 BY5PR15MB3713.namprd15.prod.outlook.com (52.133.252.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 22:50:33 +0000
Received: from BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c]) by BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c%4]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 22:50:33 +0000
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
Thread-Index: AQHVgIJ8iNM2JFB8dkCGpaKji+MwkKdeE2WAgADjLwCAAIm8gP//mREAgAB8xoCAAP8DAA==
Date:   Fri, 18 Oct 2019 22:50:32 +0000
Message-ID: <529EF9B4-DFDE-4DB7-BE26-3AED8D814134@fb.com>
References: <20191011213027.2110008-1-vijaykhemka@fb.com>
 <3a1176067b745fddfc625bbd142a41913ee3e3a1.camel@kernel.crashing.org>
 <0C0BC813-5A84-403F-9C48-9447AAABD867@fb.com>
 <071cf1eeefcbfc14633a13bc2d15ad7392987a88.camel@kernel.crashing.org>
 <9AA81274-01F2-4803-8905-26F0521486CE@fb.com>
 <f6d5cb45a9aa167533135c5b218b45b1d210d31a.camel@kernel.crashing.org>
In-Reply-To: <f6d5cb45a9aa167533135c5b218b45b1d210d31a.camel@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::7259]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f873410d-75bd-4d56-fae2-08d7541d9542
x-ms-traffictypediagnostic: BY5PR15MB3713:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3713B264D1FDBFDBBCC36406DD6C0@BY5PR15MB3713.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(136003)(366004)(376002)(39860400002)(189003)(199004)(14454004)(316002)(66476007)(91956017)(76116006)(71190400001)(33656002)(66946007)(66556008)(14444005)(66446008)(64756008)(6436002)(229853002)(6486002)(256004)(8676002)(305945005)(7736002)(7416002)(6116002)(4001150100001)(8936002)(71200400001)(81166006)(81156014)(76176011)(25786009)(476003)(2616005)(6246003)(486006)(478600001)(54906003)(46003)(11346002)(446003)(4326008)(86362001)(99286004)(2906002)(6512007)(2201001)(2501003)(186003)(6506007)(110136005)(5660300002)(36756003)(102836004)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR15MB3713;H:BY5PR15MB3636.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ATZBGr3ytHeQFoCr6x8uuuMr2bO0jfZp6Tacx01XYALJU/TJtKMbNswqm7ZStrYYEbvOFoN0r5O9ElIZSvi/n2Sr2g7pdI5eZTz/z/cBRx5Zw95ZsGqbqDPl0vRcvUy67XHEMxQHmHaz5eNhrZItUIoDjMqdTFnaMEckYDsKPhDOSbTkrS4sExyFGQ8zyH4MTCJ35FtVLviInJT8LbC27GbJMZ56I+9GGNRt5dUYoccNXnuihl5g7QmXk3NUu7OiUqhlp68Wn7UpERfhLyDwBzeAFrPbgPFXpL819VKKagKEiQGdQx6gh6IV5YLoEhnxDYvMgl31SuHry34W2tSVtUQoXMS1fmz9HYoD0H70qBAzTrBqcezX3M86fmQoISLtkF3CpVuB0CbQrOdcgLMcD6OblmeyJ39SVNVrAIxd3Eo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8980CE84C78B844E800D4637DC2761C1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f873410d-75bd-4d56-fae2-08d7541d9542
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 22:50:32.8295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HKwRV3nHUpBqMQz0Djtimns7pRwI6W4p/5KD+tiIqjAiwd32W3yB0ns6whL00HUKjikz7wgmtM/czpjXx5ga2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3713
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_05:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 impostorscore=0 adultscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180203
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDEwLzE3LzE5LCA1OjMzIFBNLCAiQmVuamFtaW4gSGVycmVuc2NobWlkdCIgPGJl
bmhAa2VybmVsLmNyYXNoaW5nLm9yZz4gd3JvdGU6DQoNCiAgICBPbiBGcmksIDIwMTktMTAtMTgg
YXQgMDA6MDYgKzAwMDAsIFZpamF5IEtoZW1rYSB3cm90ZToNCiAgICA+IA0KICAgID4gICAgID4g
VGhpcyBpcyBub3QgYSBtYXR0ZXIgb2YgdW5zdXBwb3J0ZWQgY3N1bSwgaXQgaXMgYnJva2VuIGh3
IGNzdW0uIA0KICAgID4gICAgID4gVGhhdCdzIHdoeSB3ZSBkaXNhYmxlIGh3IGNoZWNrc3VtLiBN
eSBndWVzcyBpcyBvbmNlIHdlIGRpc2FibGUNCiAgICA+ICAgICA+IEh3IGNoZWNrc3VtLCBpdCB3
aWxsIHVzZSBzdyBjaGVja3N1bS4gU28gSSBhbSBqdXN0IGRpc2FibGluZyBodyANCiAgICA+ICAg
ICA+IENoZWNrc3VtLg0KICAgID4gICAgIA0KICAgID4gICAgIEkgZG9uJ3QgdW5kZXJzdGFuZCB3
aGF0IHlvdSBhcmUgc2F5aW5nLiBZb3UgcmVwb3J0ZWQgYSBwcm9ibGVtIHdpdGgNCiAgICA+ICAg
ICBJUFY2IGNoZWNrc3VtcyBnZW5lcmF0aW9uLiBUaGUgSFcgZG9lc24ndCBzdXBwb3J0IGl0LiBX
aGF0J3MgIm5vdCBhDQogICAgPiAgICAgbWF0dGVyIG9mIHVuc3VwcG9ydGVkIGNzdW0iID8NCiAg
ICA+ICAgICANCiAgICA+ICAgICBZb3VyIHBhdGNoIHVzZXMgYSAqZGVwcmVjYXRlZCogYml0IHRv
IHRlbGwgdGhlIG5ldHdvcmsgc3RhY2sgdG8gb25seSBkbw0KICAgID4gICAgIEhXIGNoZWNrc3Vt
IGdlbmVyYXRpb24gb24gSVBWNC4NCiAgICA+ICAgICANCiAgICA+ICAgICBUaGlzIGJpdCBpcyBk
ZXByZWNhdGVkIGZvciBhIHJlYXNvbiwgYWdhaW4sIHNlZSBza2J1ZmYuaC4gVGhlIHJpZ2h0DQog
ICAgPiAgICAgYXBwcm9hY2gsICp3aGljaCB0aGUgZHJpdmVyIGFscmVhZHkgZG9lcyosIGlzIHRv
IHRlbGwgdGhlIHN0YWNrIHRoYXQgd2UNCiAgICA+ICAgICBzdXBwb3J0IEhXIGNoZWNrc3VtaW5n
IHVzaW5nIE5FVElGX0ZfSFdfQ1NVTSwgYW5kIHRoZW4sIGluIHRoZSB0cmFuc21pdA0KICAgID4g
ICAgIGhhbmRsZXIsIHRvIGNhbGwgc2tiX2NoZWNrc3VtX2hlbHAoKSB0byBoYXZlIHRoZSBTVyBj
YWxjdWxhdGUgdGhlDQogICAgPiAgICAgY2hlY2tzdW0gaWYgaXQncyBub3QgYSBzdXBwb3J0ZWQg
dHlwZS4NCiAgICA+IA0KICAgID4gTXkgdW5kZXJzdGFuZGluZyB3YXMgd2hlbiB3ZSBlbmFibGUg
TkVUSUZfRl9IV19DU1VNIG1lYW5zIG5ldHdvcmsgDQogICAgPiBzdGFjayBlbmFibGVzIEhXIGNo
ZWNrc3VtIGFuZCBkb2Vzbid0IGNhbGN1bGF0ZSBTVyBjaGVja3N1bS4gQnV0IGFzIHBlcg0KICAg
ID4gdGhpcyBzdXBwb3J0ZWQgdHlwZXMgSFcgY2hlY2tzdW0gYXJlIHVzZWQgb25seSBmb3IgSVBW
NCBhbmQgbm90IGZvciBJUFY2IGV2ZW4NCiAgICA+IHRob3VnaCBkcml2ZXIgZW5hYmxlZCBORVRJ
Rl9GX0hXX0NTVU0uIEZvciBJUFY2IGl0IGlzIGFsd2F5cyBhIFNXIGdlbmVyYXRlZA0KICAgID4g
Y2hlY2tzdW0sIHBsZWFzZSBjb3JyZWN0IG1lIGhlcmUuDQogICAgDQogICAgSGF2ZSB5b3UgYWN0
dWFsbHkgcmVhZCB0aGUgY29tbWVudHMgaW4gc2tidWZmLmggdGhhdCBJIHBvaW50ZWQgeW91IHRv
ID8NCiAgICANCiAgICBBbmQgdGhlIHJlc3Qgb2YgbXkgZW1haWwgZm9yIHRoYXQgbWF0dGVyID8N
Cg0KWWVzLCBJIHdlbnQgdGhyb3VnaCBjb21tZW50cyBpbiBza2J1ZmYuaCBhbmQgeW91ciBjb21t
ZW50cyBhcyB3ZWxsLiBJIGtuZXcgYWJvdXQNCnRoaXMgZGVwcmVjYXRlZCBiaXQgdGhhdCdzIHdo
eSBJIGhhdmUgZGlzYWJsZWQgTkVUSUZfRl9IV19DU1VNIGNvbXBsZXRlbHkgaW4gbXkNClYxIHBh
dGNoLiBUaGVuIEZsb3JpYW4gZ2F2ZSBhIGNvbW1lbnQgYW5kIGFza2VkIG1lIHRvIGRpc2FibGUg
b25seSBJUFY2IG5vdCBJUFY0DQphcyBpdCBpcyB3b3JraW5nIGZvciBJUFY0IGFuZCBpc3N1ZSB3
aXRoIG9ubHkgSVBWNi4gVGhhdCdzIHdoeSBJIHNlbnQgcGF0Y2ggVjIgDQphY2NvbW1vZGF0aW5n
IGhpcyBmZWVkYmFjay4NCg0KSSBkb24ndCBoYXZlIG11Y2ggdW5kZXJzdGFuZGluZyBvZiBJUCBT
dGFjayBidXQgSSB3ZW50IHRocm91Z2ggY29kZSBkZXRhaWxzIGFuZCANCnlvdSBhcmUgcmlnaHQg
YW5kIGZvdW5kIHRoYXQgaXQgc2hvdWxkIGZhbGxiYWNrIHRvIFNXIGNhbGN1bGF0aW9uIGZvciBJ
UFY2IGJ1dCBpdCBkb2Vzbid0DQpoYXBwZW4gYmVjYXVzZSBmdGdtYWMxMDBfaGFyZF9zdGFydF94
bWl0IGNoZWNrcyBmb3IgQ0hFQ0tTVU1fUEFSVElBTCBiZWZvcmUNCnNldHRpbmcgSFcgY2hlY2tz
dW0gYW5kIGNhbGxpbmcgZnRnbWFjMTAwX3ByZXBfdHhfY3N1bSBmdW5jdGlvbi4gQW5kIGluIG15
IA0KdW5kZXJzdGFuZGluZywgdGhpcyB2YWx1ZSBpcyBzZXQgQ0hFQ0tTVU1fUEFSVElBTCBpbiBJ
UCBzdGFjay4gSSBsb29rZWQgdXAgSVAgc3RhY2sgZm9yDQpJUFY2LCBmaWxlIG5ldC9pcHY2L2lw
Nl9vdXRwdXQuYywgZnVuY3Rpb24gX19pcDZfYXBwZW5kX2RhdGE6IGhlcmUgaXQgc2V0cyANCkNI
RUNLU1VNX1BBUlRJQUwgb25seSBmb3IgVURQIHBhY2tldHMgbm90IGZvciBUQ1AgcGFja2V0cy4g
UGxlYXNlIGxvb2sgYXQgbGluZQ0KIG51bWJlciAxODgwLiBUaGlzIGNvdWxkIGJlIGFuIGlzc3Vl
IHdlIGFyZSBzZWVpbmcgaGVyZSBhcyB3aHkNCmZ0Z21hYzEwMF9wcmVwX3R4X2NzdW0gaXMgbm90
IGdldHRpbmcgdHJpZ2dlcmVkIGZvciBJUFY2IHdpdGggVENQLiBQbGVhc2UgY29ycmVjdA0KbWUg
aWYgbXkgdW5kZXJzdGFuZGluZyBpcyB3cm9uZy4NCiAgICANCiAgICA+ICAgICBUaGlzIGlzIGV4
YWN0bHkgd2hhdCBmdGdtYWMxMDBfcHJlcF90eF9jc3VtKCkgZG9lcy4gSXQgb25seSBlbmFibGVz
IEhXDQogICAgPiAgICAgY2hlY2tzdW0gZ2VuZXJhdGlvbiBvbiBzdXBwb3J0ZWQgdHlwZXMgYW5k
IHVzZXMgc2tiX2NoZWNrc3VtX2hlbHAoKQ0KICAgID4gICAgIG90aGVyd2lzZSwgc3VwcG9ydGVk
IHR5cGVzIGJlaW5nIHByb3RvY29sIEVUSF9QX0lQIGFuZCBJUCBwcm90b2NvbA0KICAgID4gICAg
IGJlaW5nIHJhdyBJUCwgVENQIGFuZCBVRFAuDQogICAgPiANCiAgICA+ICAgICANCiAgICA+ICAg
ICBTbyB0aGlzICpzaG91bGQqIGhhdmUgZmFsbGVuIGJhY2sgdG8gU1cgZm9yIElQVjYuIFNvIGVp
dGhlciBzb21ldGhpbmcNCiAgICA+ICAgICBpbiBteSBjb2RlIHRoZXJlIGlzIG1ha2luZyBhbiBp
bmNvcnJlY3QgYXNzdW1wdGlvbiwgb3Igc29tZXRoaW5nIGlzDQogICAgPiAgICAgYnJva2VuIGlu
IHNrYl9jaGVja3N1bV9oZWxwKCkgZm9yIElQVjYgKHdoaWNoIEkgc29tZXdoYXQgZG91YnQpIG9y
DQogICAgPiAgICAgc29tZXRoaW5nIGVsc2UgSSBjYW4ndCB0aGluayBvZiwgYnV0IHNldHRpbmcg
YSAqZGVwcmVjYXRlZCogZmxhZyBpcw0KICAgID4gICAgIGRlZmluaXRlbHkgbm90IHRoZSByaWdo
dCBhbnN3ZXIsIG5laXRoZXIgaXMgY29tcGxldGVseSBkaXNhYmxpbmcgSFcNCiAgICA+ICAgICBj
aGVja3N1bW1pbmcuDQogICAgPiAgICAgDQogICAgPiAgICAgU28gY2FuIHlvdSBpbnZlc3RpZ2F0
ZSB3aGF0J3MgZ29pbmcgb24gYSBiaXQgbW9yZSBjbG9zZWx5IHBsZWFzZSA/IEkNCiAgICA+ICAg
ICBjYW4gdHJ5IG15c2VsZiwgdGhvdWdoIEkgaGF2ZSB2ZXJ5IGxpdHRsZSBleHBlcmllbmNlIHdp
dGggSVBWNiBhbmQNCiAgICA+ICAgICBwcm9iYWJseSB3b24ndCBoYXZlIHRpbWUgYmVmb3JlIG5l
eHQgd2Vlay4NCiAgICA+ICAgICANCiAgICA+ICAgICBDaGVlcnMsDQogICAgPiAgICAgQmVuLg0K
ICAgID4gICAgIA0KICAgID4gICAgID4gICAgIFRoZSBkcml2ZXIgc2hvdWxkIGhhdmUgaGFuZGxl
ZCB1bnN1cHBvcnRlZCBjc3VtIHZpYSBTVyBmYWxsYmFjaw0KICAgID4gICAgID4gICAgIGFscmVh
ZHkgaW4gZnRnbWFjMTAwX3ByZXBfdHhfY3N1bSgpDQogICAgPiAgICAgPiAgICAgDQogICAgPiAg
ICAgPiAgICAgQ2FuIHlvdSBjaGVjayB3aHkgdGhpcyBkaWRuJ3Qgd29yayBmb3IgeW91ID8NCiAg
ICA+ICAgICA+ICAgICANCiAgICA+ICAgICA+ICAgICBDaGVlcnMsDQogICAgPiAgICAgPiAgICAg
QmVuLg0KICAgID4gICAgID4gICAgIA0KICAgID4gICAgID4gICAgID4gU2lnbmVkLW9mZi1ieTog
VmlqYXkgS2hlbWthIDx2aWpheWtoZW1rYUBmYi5jb20+DQogICAgPiAgICAgPiAgICAgPiAtLS0N
CiAgICA+ICAgICA+ICAgICA+IENoYW5nZXMgc2luY2UgdjE6DQogICAgPiAgICAgPiAgICAgPiAg
RW5hYmxlZCBJUFY0IGh3IGNoZWNrc3VtIGdlbmVyYXRpb24gYXMgaXQgd29ya3MgZm9yIElQVjQu
DQogICAgPiAgICAgPiAgICAgPiANCiAgICA+ICAgICA+ICAgICA+ICBkcml2ZXJzL25ldC9ldGhl
cm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jIHwgMTMgKysrKysrKysrKysrLQ0KICAgID4gICAgID4g
ICAgID4gIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQog
ICAgPiAgICAgPiAgICAgPiANCiAgICA+ICAgICA+ICAgICA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAgPiAgICAgPiAgICAgPiBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMNCiAgICA+ICAgICA+ICAgICA+
IGluZGV4IDAzMGZlZDY1MzkzZS4uMDI1NWEyOGQyOTU4IDEwMDY0NA0KICAgID4gICAgID4gICAg
ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYw0KICAgID4g
ICAgID4gICAgID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAu
Yw0KICAgID4gICAgID4gICAgID4gQEAgLTE4NDIsOCArMTg0MiwxOSBAQCBzdGF0aWMgaW50IGZ0
Z21hYzEwMF9wcm9iZShzdHJ1Y3QNCiAgICA+ICAgICA+ICAgICA+IHBsYXRmb3JtX2RldmljZSAq
cGRldikNCiAgICA+ICAgICA+ICAgICA+ICAJLyogQVNUMjQwMCAgZG9lc24ndCBoYXZlIHdvcmtp
bmcgSFcgY2hlY2tzdW0gZ2VuZXJhdGlvbiAqLw0KICAgID4gICAgID4gICAgID4gIAlpZiAobnAg
JiYgKG9mX2RldmljZV9pc19jb21wYXRpYmxlKG5wLCAiYXNwZWVkLGFzdDI0MDAtbWFjIikpKQ0K
ICAgID4gICAgID4gICAgID4gIAkJbmV0ZGV2LT5od19mZWF0dXJlcyAmPSB+TkVUSUZfRl9IV19D
U1VNOw0KICAgID4gICAgID4gICAgID4gKw0KICAgID4gICAgID4gICAgID4gKwkvKiBBU1QyNTAw
IGRvZXNuJ3QgaGF2ZSB3b3JraW5nIEhXIGNoZWNrc3VtIGdlbmVyYXRpb24gZm9yIElQVjYNCiAg
ICA+ICAgICA+ICAgICA+ICsJICogYnV0IGl0IHdvcmtzIGZvciBJUFY0LCBzbyBkaXNhYmxpbmcg
aHcgY2hlY2tzdW0gYW5kIGVuYWJsaW5nDQogICAgPiAgICAgPiAgICAgPiArCSAqIGl0IGZvciBv
bmx5IElQVjQuDQogICAgPiAgICAgPiAgICAgPiArCSAqLw0KICAgID4gICAgID4gICAgID4gKwlp
ZiAobnAgJiYgKG9mX2RldmljZV9pc19jb21wYXRpYmxlKG5wLCAiYXNwZWVkLGFzdDI1MDAtbWFj
IikpKQ0KICAgID4gICAgID4gICAgID4gew0KICAgID4gICAgID4gICAgID4gKwkJbmV0ZGV2LT5o
d19mZWF0dXJlcyAmPSB+TkVUSUZfRl9IV19DU1VNOw0KICAgID4gICAgID4gICAgID4gKwkJbmV0
ZGV2LT5od19mZWF0dXJlcyB8PSBORVRJRl9GX0lQX0NTVU07DQogICAgPiAgICAgPiAgICAgPiAr
CX0NCiAgICA+ICAgICA+ICAgICA+ICsNCiAgICA+ICAgICA+ICAgICA+ICAJaWYgKG5wICYmIG9m
X2dldF9wcm9wZXJ0eShucCwgIm5vLWh3LWNoZWNrc3VtIiwgTlVMTCkpDQogICAgPiAgICAgPiAg
ICAgPiAtCQluZXRkZXYtPmh3X2ZlYXR1cmVzICY9IH4oTkVUSUZfRl9IV19DU1VNIHwNCiAgICA+
ICAgICA+ICAgICA+IE5FVElGX0ZfUlhDU1VNKTsNCiAgICA+ICAgICA+ICAgICA+ICsJCW5ldGRl
di0+aHdfZmVhdHVyZXMgJj0gfihORVRJRl9GX0hXX0NTVU0gfA0KICAgID4gICAgID4gICAgID4g
TkVUSUZfRl9SWENTVU0NCiAgICA+ICAgICA+ICAgICA+ICsJCQkJCSB8IE5FVElGX0ZfSVBfQ1NV
TSk7DQogICAgPiAgICAgPiAgICAgPiAgCW5ldGRldi0+ZmVhdHVyZXMgfD0gbmV0ZGV2LT5od19m
ZWF0dXJlczsNCiAgICA+ICAgICA+ICAgICA+ICANCiAgICA+ICAgICA+ICAgICA+ICAJLyogcmVn
aXN0ZXIgbmV0d29yayBkZXZpY2UgKi8NCiAgICA+ICAgICA+ICAgICANCiAgICA+ICAgICA+ICAg
ICANCiAgICA+ICAgICA+IA0KICAgID4gICAgIA0KICAgID4gICAgIA0KICAgID4gDQogICAgDQog
ICAgDQoNCg==
