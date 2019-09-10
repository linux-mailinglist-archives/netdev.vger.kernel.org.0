Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3447DAF309
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 00:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfIJWuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 18:50:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54754 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbfIJWuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 18:50:08 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8AMm2JZ019889;
        Tue, 10 Sep 2019 15:49:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OzGLYXHvpqCLF2z0njmKUnMBzEuAM3k6JeYG+CorpNs=;
 b=pcIknUmiQmNgU0kiZ9LVIz3fQESXZj5F4ls+sgFsBF0LrJRxpbWVJj9H6VyEPwlGpFmV
 blOExo1rrOt5jMkF+TGler533XbgjUEAi6WKWvO8WtXFdAfHfcESdO+76E5J1m1PvN83
 6JaIze2cXBAdxOjcR3ZnDMYeXRM6a7g/cYA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uxm1k885x-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Sep 2019 15:49:02 -0700
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 10 Sep 2019 15:48:59 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 10 Sep 2019 15:48:45 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Sep 2019 15:48:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CphlAtJPndqX4UNobm89dQwp95ZzDNIbEcuvqg/kZrCXIbDt92GjEC+6i6rYOzlUUP4VBek3R2A/3Tg+0r4RLJTZ0JlzlEYFB00uZtf220JLMcOfTYobxMW1tn1K91Y/Smgr8ypFaCD96/pyLkjfkoGKh5f7NkFFjulSE+PbH1rbk8+Qf3Ne+Ev0vO/xccuppx6NesoZA0+ZW5CP2ke0RG3xEAkfRnk/R8ke6SlZq+4kY1pz8pM3QB6XREYyqGUuGhz23L5qGn97m5CQxs3zc+CnMOcymaADO/jD3sc8ijcdb1wxSeMJ7hvUZIueZdvHt1Qnw3fKyjmMTjzrftstsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzGLYXHvpqCLF2z0njmKUnMBzEuAM3k6JeYG+CorpNs=;
 b=N7eIQWb23KUCtdXfBFdXVZk1CEHZllkak3Eh8FloOYSh0v9TJVnco8juXPVDKAToC921QWECEQISQ6JqjiznDaZ/8uB9Fs/5x/yZbAkJcMyRc2x/z1jPhHpjPq7v+hNOv6ntCb1f99yLqhZF/eqpO+II2cH2o4g0H/bSyylCse1XbsncEcocb6CK4sGxMKsIFiaYRDOL+ejPCjj7SotXeEewvIn2sro5Wb32AqUcFkEoG54hACm4lxmywV9yY7FPVP5RdpP9jqVG5YakF1qdTI1OhcvfxvdzgqnLLjkbWq+R3SxnMn9Ft4DKCAunF3ES7kuRqXksUhIhcqNf1f0kwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzGLYXHvpqCLF2z0njmKUnMBzEuAM3k6JeYG+CorpNs=;
 b=aJ2TA9cR8YjU1YNHJ3eT6JsAOQKQWXsAyC1aTacgH9D8hswfaN92blBr5q3jq1Ii8lnyWvb8Dsq0bpGQr2K8/dcn1wWZsa2OlJgj5Cb9ZcCuibfQQ0senjhd193hs+AllRBAywrA0uNCezoPy3W39FgxnP96EDGm6FvorOB0oKk=
Received: from CY4PR15MB1269.namprd15.prod.outlook.com (10.172.177.11) by
 CY4PR15MB1893.namprd15.prod.outlook.com (10.174.53.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Tue, 10 Sep 2019 22:48:43 +0000
Received: from CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b]) by CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b%7]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 22:48:43 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Topic: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Index: AQHVaCL3HHZ/0IxjZ0GB2KAMVKzdAqcld28A//+WvAA=
Date:   Tue, 10 Sep 2019 22:48:43 +0000
Message-ID: <0797B1F1-883D-4129-AC16-794957ACCF1B@fb.com>
References: <20190910213734.3112330-1-vijaykhemka@fb.com>
 <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
In-Reply-To: <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:1b73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1b28913-7c7f-4a0f-92d8-08d736410860
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1893;
x-ms-traffictypediagnostic: CY4PR15MB1893:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB18931BB2DCE395617414D917DDB60@CY4PR15MB1893.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(346002)(376002)(396003)(39860400002)(199004)(189003)(2616005)(76116006)(6436002)(6506007)(316002)(6512007)(305945005)(478600001)(5660300002)(2906002)(76176011)(46003)(66476007)(110136005)(8676002)(8936002)(99286004)(2201001)(446003)(486006)(11346002)(476003)(81156014)(81166006)(4326008)(66556008)(64756008)(66446008)(33656002)(7736002)(7416002)(25786009)(6116002)(14444005)(256004)(86362001)(36756003)(71190400001)(71200400001)(53546011)(6486002)(14454004)(186003)(2501003)(53936002)(229853002)(66946007)(102836004)(91956017)(54906003)(6246003)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1893;H:CY4PR15MB1269.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IgVCWsROkr4MNUBNaNM/DgWtrjcTbutaoaEIgzVT55atD4+hPUWBVKLN6XZpwnz/UYWM2YayEo00jCc9xUzLq3/qiLeJTpMn6aJ7k+i01HP4okWwBlPqNoKAxPdBhCLbvnDGJuPxS5MPRxxNOT96Gouk3iTVk/v9viAXnG2pcmJfmajpFvVmpKrfo9Y/4hPiD3UxYeJS3fF/6fYnBMuGc1E1vuMaV3YLFqsSoys7iRWfhV0UlnAn1L+HN6j8QO5Umn6ypmfxoADA3AsfnPfYp2AfMADlcH9PzSlrmRZvY3Jc6SOqQDOSbhShL1nfBwKXnbrKJBxWoRSXNe9Zs00FlqpEbL+pqB61XDnqTFcFAIbwJBGKrHrw+H7uZm2TaaktAXnTui88YAVEDyW6iJmAHnzYYHcFwC90dYvH8lrsnjM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D389ED39BF51C4895FEB95883E407AE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b28913-7c7f-4a0f-92d8-08d736410860
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 22:48:43.5916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hrJy8e3cD3JHw0cUdr2zQJelvVy0ub4vqf+0IcK0O9KwF3KDRYPSWk+grmK3+Rh+T2CiKlooUDrN164a0DBHig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1893
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-10_12:2019-09-10,2019-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909100212
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDkvMTAvMTksIDM6MDUgUE0sICJGbG9yaWFuIEZhaW5lbGxpIiA8Zi5mYWluZWxs
aUBnbWFpbC5jb20+IHdyb3RlOg0KDQogICAgT24gOS8xMC8xOSAyOjM3IFBNLCBWaWpheSBLaGVt
a2Egd3JvdGU6DQogICAgPiBIVyBjaGVja3N1bSBnZW5lcmF0aW9uIGlzIG5vdCB3b3JraW5nIGZv
ciBBU1QyNTAwLCBzcGVjaWFsbHkgd2l0aCBJUFY2DQogICAgPiBvdmVyIE5DU0kuIEFsbCBUQ1Ag
cGFja2V0cyB3aXRoIElQdjYgZ2V0IGRyb3BwZWQuIEJ5IGRpc2FibGluZyB0aGlzDQogICAgPiBp
dCB3b3JrcyBwZXJmZWN0bHkgZmluZSB3aXRoIElQVjYuDQogICAgPiANCiAgICA+IFZlcmlmaWVk
IHdpdGggSVBWNiBlbmFibGVkIGFuZCBjYW4gZG8gc3NoLg0KICAgIA0KICAgIEhvdyBhYm91dCBJ
UHY0LCBkbyB0aGVzZSBwYWNrZXRzIGhhdmUgcHJvYmxlbT8gSWYgbm90LCBjYW4geW91IGNvbnRp
bnVlDQogICAgYWR2ZXJ0aXNpbmcgTkVUSUZfRl9JUF9DU1VNIGJ1dCB0YWtlIG91dCBORVRJRl9G
X0lQVjZfQ1NVTT8NCg0KSSBjaGFuZ2VkIGNvZGUgZnJvbSAobmV0ZGV2LT5od19mZWF0dXJlcyAm
PSB+TkVUSUZfRl9IV19DU1VNKSB0byANCihuZXRkZXYtPmh3X2ZlYXR1cmVzICY9IH5ORVRJRl9G
XyBJUFY2X0NTVU0pLiBBbmQgaXQgaXMgbm90IHdvcmtpbmcuIA0KRG9uJ3Qga25vdyB3aHkuIElQ
VjQgd29ya3Mgd2l0aG91dCBhbnkgY2hhbmdlIGJ1dCBJUHY2IG5lZWRzIEhXX0NTVU0NCkRpc2Fi
bGVkLg0KICAgIA0KICAgID4gDQogICAgPiBTaWduZWQtb2ZmLWJ5OiBWaWpheSBLaGVta2EgPHZp
amF5a2hlbWthQGZiLmNvbT4NCiAgICA+IC0tLQ0KICAgID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L2ZhcmFkYXkvZnRnbWFjMTAwLmMgfCA1ICsrKy0tDQogICAgPiAgMSBmaWxlIGNoYW5nZWQsIDMg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCiAgICA+IA0KICAgID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAgPiBpbmRleCAwMzBmZWQ2NTM5M2UuLjU5
MWM5NzI1MDAyYiAxMDA2NDQNCiAgICA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFk
YXkvZnRnbWFjMTAwLmMNCiAgICA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkv
ZnRnbWFjMTAwLmMNCiAgICA+IEBAIC0xODM5LDggKzE4MzksOSBAQCBzdGF0aWMgaW50IGZ0Z21h
YzEwMF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KICAgID4gIAlpZiAocHJp
di0+dXNlX25jc2kpDQogICAgPiAgCQluZXRkZXYtPmh3X2ZlYXR1cmVzIHw9IE5FVElGX0ZfSFdf
VkxBTl9DVEFHX0ZJTFRFUjsNCiAgICA+ICANCiAgICA+IC0JLyogQVNUMjQwMCAgZG9lc24ndCBo
YXZlIHdvcmtpbmcgSFcgY2hlY2tzdW0gZ2VuZXJhdGlvbiAqLw0KICAgID4gLQlpZiAobnAgJiYg
KG9mX2RldmljZV9pc19jb21wYXRpYmxlKG5wLCAiYXNwZWVkLGFzdDI0MDAtbWFjIikpKQ0KICAg
ID4gKwkvKiBBU1QyNDAwICBhbmQgQVNUMjUwMCBkb2Vzbid0IGhhdmUgd29ya2luZyBIVyBjaGVj
a3N1bSBnZW5lcmF0aW9uICovDQogICAgPiArCWlmIChucCAmJiAob2ZfZGV2aWNlX2lzX2NvbXBh
dGlibGUobnAsICJhc3BlZWQsYXN0MjQwMC1tYWMiKSB8fA0KICAgID4gKwkJICAgb2ZfZGV2aWNl
X2lzX2NvbXBhdGlibGUobnAsICJhc3BlZWQsYXN0MjUwMC1tYWMiKSkpDQogICAgPiAgCQluZXRk
ZXYtPmh3X2ZlYXR1cmVzICY9IH5ORVRJRl9GX0hXX0NTVU07DQogICAgPiAgCWlmIChucCAmJiBv
Zl9nZXRfcHJvcGVydHkobnAsICJuby1ody1jaGVja3N1bSIsIE5VTEwpKQ0KICAgID4gIAkJbmV0
ZGV2LT5od19mZWF0dXJlcyAmPSB+KE5FVElGX0ZfSFdfQ1NVTSB8IE5FVElGX0ZfUlhDU1VNKTsN
CiAgICA+IA0KICAgIA0KICAgIA0KICAgIC0tIA0KICAgIEZsb3JpYW4NCiAgICANCg0K
