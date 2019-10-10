Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7BAD3144
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfJJTV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:21:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43262 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726007AbfJJTV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 15:21:59 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9AJKl0l018832;
        Thu, 10 Oct 2019 12:20:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CtuJMgqo2Cig8rUli1Nw4yCWXPq4Gyxvx7EgNxsGafk=;
 b=EBdZHKH3dtPgVxYaMJB5vAqno6SP6372f4jguje/mp2aQJbMkpsIPM3c4594mv8KHRhw
 IZL3X4E15yFx1WsYhDV7hHNaJoWpjOfkbuyjolHAnikQF+0hESOX2VdTU99C5YtHSPcI
 CFzpr3+R9xUaSs7/vpvPSuSSVZZCjSrBPYY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vj65f9u2q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Oct 2019 12:20:50 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 10 Oct 2019 12:20:49 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 10 Oct 2019 12:20:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHu6Kw0usGdwMN0eJW+c3qZHAZzpkHTB+9UW6ndkZqbvo5KZQ9yOZdoMTvKC/nWkigl3ItD+F6od8g5qz80ufFA9OK4kows5Syb8hZCkw8t/4RZM1fFlEadPGPMrxluBOL+qGfiWI8yKiW4Y5vxSMP1Bh7A652mPaZqWUhWASDuIRWDu9tvt7BxWrRuiRW0C+ng16O2LJEZwZodFmbbJSD44V6Yp6SjSh9/04jOTMOpIEl3kg4m1J9XG9cXySHXIw9Do1Lk6hsJjLe4QZ3ZIVwg+409a2tdwnVMBt51UY1Qi9D9R3l3Pf7bVUTz7ey+gu+xDttrrhAZlfDur5aaDdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtuJMgqo2Cig8rUli1Nw4yCWXPq4Gyxvx7EgNxsGafk=;
 b=b23BNG8D9hAEu0b+XtMH2GP/cnvinoiyvkCDxjXRWKS8Wcqq8cDbARzx9HPKDcGH2yLREJ+P+FHAcEELRNPvcCUmvUHm7SlUDMZ7kOfL9JHEMIGW8kGyFDvDk5Gm4q3pGECOkfcXaS286VygLsVm3IV0jnB/jkg7rNQnwCk550Uy3YYQUfIVltRIjEPxlqDPU9gO/xdS/Jg1U612MU2Wynx3rhBytQKiqSBv3APyLqcma9hU+m7WaZ3wfPA7C6Z1tDj/+zG86vGbN8c3NvfQoA1zO9Fcb2ZOOab5Z/e5tMmXCdgoZucDpMuCqRiONU87D0TH5BF5Fyza+jyWweS3cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtuJMgqo2Cig8rUli1Nw4yCWXPq4Gyxvx7EgNxsGafk=;
 b=IWvSjZaKdcEyWzkZpwXVf4oq9N9kPM3PqMC4rBBIlCSu/eA9QkLZdRYC7nJ3GBbxDlPsh3rLjMDX+50iEpUi892hvOezISotpzH51YMObRRIK9eSRlKbl9UyuuTTiq5XT6P72DkW5jiUWIvXxX5mqrz2jf8DDeepdzmYrqgqNqg=
Received: from BY5PR15MB3636.namprd15.prod.outlook.com (52.133.252.91) by
 BY5PR15MB3684.namprd15.prod.outlook.com (52.133.254.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 19:20:48 +0000
Received: from BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c]) by BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c%4]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 19:20:47 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
Thread-Topic: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
Thread-Index: AQHVaNxN2w/kFAC/x0er+VWda7SKWKdT+JGA
Date:   Thu, 10 Oct 2019 19:20:47 +0000
Message-ID: <4B7340B5-C35C-4B18-8D8C-B5B8D16BA551@fb.com>
References: <20190911194453.2595021-1-vijaykhemka@fb.com>
In-Reply-To: <20190911194453.2595021-1-vijaykhemka@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::3:7710]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01fcd662-9a91-40b2-bcb8-08d74db6f4a1
x-ms-traffictypediagnostic: BY5PR15MB3684:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3684684B346FFA5F49A66267DD940@BY5PR15MB3684.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(346002)(376002)(396003)(189003)(199004)(229853002)(86362001)(81166006)(81156014)(8936002)(2201001)(478600001)(5660300002)(4326008)(8676002)(66946007)(66446008)(64756008)(66556008)(91956017)(66476007)(305945005)(76116006)(2501003)(7416002)(33656002)(316002)(99286004)(2906002)(6486002)(6246003)(6436002)(76176011)(7736002)(71190400001)(71200400001)(6512007)(25786009)(102836004)(6116002)(256004)(2616005)(14444005)(14454004)(476003)(446003)(11346002)(486006)(110136005)(186003)(46003)(54906003)(36756003)(6506007)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR15MB3684;H:BY5PR15MB3636.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vrfNZGj+oug4Y2l+LaBPlbpwv1CYprlONG2yBtRMzaK4qUGexJ7JhmZQCoGTn6hMZ8mnERxMKuqYS5hv2QGhQbdaCbDUsDu12Ch4bRw1ykvPoEwDRmsiJpir8tcIpSKkEZKfeXJ7AAmrqkw8uRAciPhrbAR+Hg842CtoiPPQmA4rADb9Pp/B7HQF48bsEzJYUh892C0iv2PvvD3TFUCIu6UAQN1CewpbvLpFKZ6dMErKfl8eA5cvq7Jt9h0M0Yw5WYxFlOboWqyUBtddwUon/NScJD0xQwVJHtOE8km7om7FkKEPdNGnk/wnNBQNxV0R+DTU3wnn6lCQrdAIsCwUMJ36GL7FyTZ90C9HmpeVgvcZi0nbasV8AAI0+dW8jAbu9n0qpTuEssWGVs8RWUNiipD7hSH7OPGI03HBTks4WvU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CCE41598029CB449AB06264B4FB55B5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fcd662-9a91-40b2-bcb8-08d74db6f4a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 19:20:47.8252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2RxLeIRm2kp9vhbNTEV5CpH1gwyBXdMcY+/Z3jzEKHlhIDGXoDta5P5pzGhfHdvz6jO/QfbllmWcJE/Kj6Ykhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3684
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_06:2019-10-10,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 mlxscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=854 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVzZW5kaW5nIHRoaXMgcGF0Y2ggYWdhaW4uIA0KDQrvu79PbiA5LzExLzE5LCAxOjA1IFBNLCAi
VmlqYXkgS2hlbWthIiA8dmlqYXlraGVta2FAZmIuY29tPiB3cm90ZToNCg0KICAgIEhXIGNoZWNr
c3VtIGdlbmVyYXRpb24gaXMgbm90IHdvcmtpbmcgZm9yIEFTVDI1MDAsIHNwZWNpYWxseSB3aXRo
IElQVjYNCiAgICBvdmVyIE5DU0kuIEFsbCBUQ1AgcGFja2V0cyB3aXRoIElQdjYgZ2V0IGRyb3Bw
ZWQuIEJ5IGRpc2FibGluZyB0aGlzDQogICAgaXQgd29ya3MgcGVyZmVjdGx5IGZpbmUgd2l0aCBJ
UFY2LiBBcyBpdCB3b3JrcyBmb3IgSVBWNCBzbyBlbmFibGVkDQogICAgaHcgY2hlY2tzdW0gYmFj
ayBmb3IgSVBWNC4NCiAgICANCiAgICBWZXJpZmllZCB3aXRoIElQVjYgZW5hYmxlZCBhbmQgY2Fu
IGRvIHNzaC4NCiAgICANCiAgICBTaWduZWQtb2ZmLWJ5OiBWaWpheSBLaGVta2EgPHZpamF5a2hl
bWthQGZiLmNvbT4NCiAgICAtLS0NCiAgICBDaGFuZ2VzIHNpbmNlIHYxOg0KICAgICBFbmFibGVk
IElQVjQgaHcgY2hlY2tzdW0gZ2VuZXJhdGlvbiBhcyBpdCB3b3JrcyBmb3IgSVBWNC4NCiAgICAN
CiAgICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYyB8IDEzICsrKysr
KysrKysrKy0NCiAgICAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkNCiAgICANCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRh
eS9mdGdtYWMxMDAuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMN
CiAgICBpbmRleCAwMzBmZWQ2NTM5M2UuLjAyNTVhMjhkMjk1OCAxMDA2NDQNCiAgICAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAgKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYw0KICAgIEBAIC0xODQyLDggKzE4NDIs
MTkgQEAgc3RhdGljIGludCBmdGdtYWMxMDBfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAq
cGRldikNCiAgICAgCS8qIEFTVDI0MDAgIGRvZXNuJ3QgaGF2ZSB3b3JraW5nIEhXIGNoZWNrc3Vt
IGdlbmVyYXRpb24gKi8NCiAgICAgCWlmIChucCAmJiAob2ZfZGV2aWNlX2lzX2NvbXBhdGlibGUo
bnAsICJhc3BlZWQsYXN0MjQwMC1tYWMiKSkpDQogICAgIAkJbmV0ZGV2LT5od19mZWF0dXJlcyAm
PSB+TkVUSUZfRl9IV19DU1VNOw0KICAgICsNCiAgICArCS8qIEFTVDI1MDAgZG9lc24ndCBoYXZl
IHdvcmtpbmcgSFcgY2hlY2tzdW0gZ2VuZXJhdGlvbiBmb3IgSVBWNg0KICAgICsJICogYnV0IGl0
IHdvcmtzIGZvciBJUFY0LCBzbyBkaXNhYmxpbmcgaHcgY2hlY2tzdW0gYW5kIGVuYWJsaW5nDQog
ICAgKwkgKiBpdCBmb3Igb25seSBJUFY0Lg0KICAgICsJICovDQogICAgKwlpZiAobnAgJiYgKG9m
X2RldmljZV9pc19jb21wYXRpYmxlKG5wLCAiYXNwZWVkLGFzdDI1MDAtbWFjIikpKSB7DQogICAg
KwkJbmV0ZGV2LT5od19mZWF0dXJlcyAmPSB+TkVUSUZfRl9IV19DU1VNOw0KICAgICsJCW5ldGRl
di0+aHdfZmVhdHVyZXMgfD0gTkVUSUZfRl9JUF9DU1VNOw0KICAgICsJfQ0KICAgICsNCiAgICAg
CWlmIChucCAmJiBvZl9nZXRfcHJvcGVydHkobnAsICJuby1ody1jaGVja3N1bSIsIE5VTEwpKQ0K
ICAgIC0JCW5ldGRldi0+aHdfZmVhdHVyZXMgJj0gfihORVRJRl9GX0hXX0NTVU0gfCBORVRJRl9G
X1JYQ1NVTSk7DQogICAgKwkJbmV0ZGV2LT5od19mZWF0dXJlcyAmPSB+KE5FVElGX0ZfSFdfQ1NV
TSB8IE5FVElGX0ZfUlhDU1VNDQogICAgKwkJCQkJIHwgTkVUSUZfRl9JUF9DU1VNKTsNCiAgICAg
CW5ldGRldi0+ZmVhdHVyZXMgfD0gbmV0ZGV2LT5od19mZWF0dXJlczsNCiAgICAgDQogICAgIAkv
KiByZWdpc3RlciBuZXR3b3JrIGRldmljZSAqLw0KICAgIC0tIA0KICAgIDIuMTcuMQ0KICAgIA0K
ICAgIA0KDQo=
