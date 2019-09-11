Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A808DB02DC
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 19:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbfIKRpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 13:45:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54298 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729349AbfIKRpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 13:45:22 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8BHeVCl001307;
        Wed, 11 Sep 2019 10:44:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9OxxgqyxwATjBdv57AaRO2tmC6ELEdjpHgw6NAqg2n8=;
 b=qOB0qxHgErT1QbC1hZribwilhYf8cFXjOIXSXEGIpOOTxyuR2G6II5JSYnbvsLmSNZC1
 Vl8RQ/u8n0vBU33iO8GSTE9fBxwBQ6U4/BRjMXMbXHmYecASNTQo+8HMsFJmBeKdcVO7
 IHbd5vQ3lDkcOOQhjygk/fIA5EiAGtMCdLg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uxv0p2nak-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Sep 2019 10:44:11 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Sep 2019 10:44:07 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Sep 2019 10:44:07 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Sep 2019 10:44:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmgR5m/QKkXNaxZwHeUjIJvqjn2qmhTFj5dfBtNYTPE+4uDvKJpfWLtLap9NPDzB4W+PdEOc31d02kT0e/e1hAackMfuJ4MpPovA3YjzZxtPUO6OYkcQF2g6VwaHhANS+xiALyW7AoTeP/FV/evOPDWJoqUhWbT+fckB7qxN29k7aDrkxO6w/F7GENHBj1VgsF6qXgJjucfewIX+qKg1+9vYdDfgaRebVkt+jpX7TsX/Tfdms36l2KJx9CORpgmBb9X+fuLw2Q7KXaM8ECSBOsTsU1NKnxXr/3S7kpILxqJT9bM2slvld/RiKznAAs1GGC+ALvydDjUQRF54rhzFEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OxxgqyxwATjBdv57AaRO2tmC6ELEdjpHgw6NAqg2n8=;
 b=Lu6nypCOKLBw7aT/5h3Gfi/qS9Cp0PNZTIqn+cjtYPBjXnW8CNtZkoy7jBUj1wmlmawIuLG2VUKAgX7B1IMvxNirkt32v4Phdaa6Y6QINpupuzOZzXM1I8k9aELRYy1Hs/RBrhf2HDQyZmZGtuiLZqr5wruX7yYAjm1QBys6w+gw81QOgNXQmhhmp99p6DJzvSXUgwnKEkGqnZSpcxKELVgNoeWzAU+uF6GKCNb0ZDF+ts1NrOtc5nGq7hemsLdmiTqCWlPJLoe2Sfm4lEHP4uMizF+8edJwaY3R6gkDy5WxXAZ92VJp7LncHpA15urf4VJr98DWqBEbmS2huAeYUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OxxgqyxwATjBdv57AaRO2tmC6ELEdjpHgw6NAqg2n8=;
 b=KXTJAO9cCZfIHA/U2g54LkX+C0eBGxQSPyI80yqisD/gumfY4t8vY8vMyikhxjbg+cbVckQSpAlkQ080uc3CTBy/mALrR5wDY+q2hdnmOvcxp+P5FQTf5hM8WMmT9uLqWJXmcvlf0sv6tKUEmi52f4yyuRG0Vo2093DFw2Mkzb0=
Received: from CY4PR15MB1269.namprd15.prod.outlook.com (10.172.177.11) by
 CY4PR15MB1432.namprd15.prod.outlook.com (10.172.161.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Wed, 11 Sep 2019 17:44:05 +0000
Received: from CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b]) by CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b%7]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 17:44:05 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Joel Stanley <joel@jms.id.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Topic: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Index: AQHVaCL3HHZ/0IxjZ0GB2KAMVKzdAqcld28AgAEYWwD//7uYAA==
Date:   Wed, 11 Sep 2019 17:44:05 +0000
Message-ID: <A15F2B7E-3AC6-4C24-8AF3-9E47635FDC7F@fb.com>
References: <20190910213734.3112330-1-vijaykhemka@fb.com>
 <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
 <CACPK8XcS4iKfKigPbPg0BFbmjbT-kdyjiPDXjk1k5XaS5bCdAA@mail.gmail.com>
In-Reply-To: <CACPK8XcS4iKfKigPbPg0BFbmjbT-kdyjiPDXjk1k5XaS5bCdAA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::1:a2f5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17bcb530-1e56-4d91-f4fb-08d736dfa420
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1432;
x-ms-traffictypediagnostic: CY4PR15MB1432:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB143260F22068945BA4E56F36DDB10@CY4PR15MB1432.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(39860400002)(396003)(136003)(346002)(189003)(199004)(64756008)(8676002)(4326008)(2906002)(66946007)(91956017)(54906003)(66476007)(110136005)(316002)(66556008)(81166006)(186003)(6506007)(102836004)(99286004)(256004)(6116002)(76116006)(66446008)(5660300002)(71190400001)(71200400001)(11346002)(7416002)(2616005)(46003)(486006)(446003)(53546011)(476003)(33656002)(36756003)(229853002)(76176011)(81156014)(6486002)(53936002)(8936002)(6436002)(305945005)(478600001)(14454004)(7736002)(6246003)(25786009)(6512007)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1432;H:CY4PR15MB1269.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qvCVoZVIj+wuyIRO4CAmQQqcoZgNA00LB2XBcGFeDEB4M7ThW3ekQLpQLYSXeSKexscuAyqSmXBxhRZrGiLe3lzy2+kdX4z+iba+KMiHnwYs9wKRptUsiolRxyaDdE4Q2ylFXCbaG4JwNfPBED5tL0VkS32LS/YsiH2QXAPCexEtUfm3TG4PAHvrvzkU9SCIC53Kbrshe5LQAyuXhRt5iP//FVWiv6t+zLJYUtPGcg6TjDlv4GzngmGWGj4kGtsbxXWfu9Nk8kemO2J3PEMkGT0xe1HVE7I9+6g0V9GBrcPH8ILlvWwAx7gIwBfwjDyNNCLYZIikpXNn+3WyQJgwZIrXAMmvTSOMlZQtchzmXp11ckuYEYi3KbgeGositc6yddJtzj8ZeSheIV34ZczJcA/uBoZJ8+wBPNPCwkOE/M4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <687EF9F737F9564E8FB7C3725A80B3F8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 17bcb530-1e56-4d91-f4fb-08d736dfa420
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 17:44:05.4585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2vi6bb8ZNpHOEQx1FvRTVrG8WFRTZKh+ErKIKrDsAzcGIQeIr6GD98U5ab6IYCfHfwuHtyM/VcD1pf/y67n6eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1432
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-11_08:2019-09-11,2019-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 priorityscore=1501
 spamscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909110163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDkvMTEvMTksIDc6NDkgQU0sICJKb2VsIFN0YW5sZXkiIDxqb2VsQGptcy5pZC5h
dT4gd3JvdGU6DQoNCiAgICBIaSBCZW4sDQogICAgDQogICAgT24gVHVlLCAxMCBTZXAgMjAxOSBh
dCAyMjowNSwgRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+IHdyb3RlOg0K
ICAgID4NCiAgICA+IE9uIDkvMTAvMTkgMjozNyBQTSwgVmlqYXkgS2hlbWthIHdyb3RlOg0KICAg
ID4gPiBIVyBjaGVja3N1bSBnZW5lcmF0aW9uIGlzIG5vdCB3b3JraW5nIGZvciBBU1QyNTAwLCBz
cGVjaWFsbHkgd2l0aCBJUFY2DQogICAgPiA+IG92ZXIgTkNTSS4gQWxsIFRDUCBwYWNrZXRzIHdp
dGggSVB2NiBnZXQgZHJvcHBlZC4gQnkgZGlzYWJsaW5nIHRoaXMNCiAgICA+ID4gaXQgd29ya3Mg
cGVyZmVjdGx5IGZpbmUgd2l0aCBJUFY2Lg0KICAgID4gPg0KICAgID4gPiBWZXJpZmllZCB3aXRo
IElQVjYgZW5hYmxlZCBhbmQgY2FuIGRvIHNzaC4NCiAgICA+DQogICAgPiBIb3cgYWJvdXQgSVB2
NCwgZG8gdGhlc2UgcGFja2V0cyBoYXZlIHByb2JsZW0/IElmIG5vdCwgY2FuIHlvdSBjb250aW51
ZQ0KICAgID4gYWR2ZXJ0aXNpbmcgTkVUSUZfRl9JUF9DU1VNIGJ1dCB0YWtlIG91dCBORVRJRl9G
X0lQVjZfQ1NVTT8NCiAgICA+DQogICAgPiA+DQogICAgPiA+IFNpZ25lZC1vZmYtYnk6IFZpamF5
IEtoZW1rYSA8dmlqYXlraGVta2FAZmIuY29tPg0KICAgID4gPiAtLS0NCiAgICA+ID4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMgfCA1ICsrKy0tDQogICAgPiA+ICAx
IGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KICAgID4gPg0K
ICAgID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMx
MDAuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMNCiAgICA+ID4g
aW5kZXggMDMwZmVkNjUzOTNlLi41OTFjOTcyNTAwMmIgMTAwNjQ0DQogICAgPiA+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMNCiAgICA+ID4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYw0KICAgID4gPiBAQCAtMTgzOSw4
ICsxODM5LDkgQEAgc3RhdGljIGludCBmdGdtYWMxMDBfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2Rl
dmljZSAqcGRldikNCiAgICA+ID4gICAgICAgaWYgKHByaXYtPnVzZV9uY3NpKQ0KICAgID4gPiAg
ICAgICAgICAgICAgIG5ldGRldi0+aHdfZmVhdHVyZXMgfD0gTkVUSUZfRl9IV19WTEFOX0NUQUdf
RklMVEVSOw0KICAgID4gPg0KICAgID4gPiAtICAgICAvKiBBU1QyNDAwICBkb2Vzbid0IGhhdmUg
d29ya2luZyBIVyBjaGVja3N1bSBnZW5lcmF0aW9uICovDQogICAgPiA+IC0gICAgIGlmIChucCAm
JiAob2ZfZGV2aWNlX2lzX2NvbXBhdGlibGUobnAsICJhc3BlZWQsYXN0MjQwMC1tYWMiKSkpDQog
ICAgPiA+ICsgICAgIC8qIEFTVDI0MDAgIGFuZCBBU1QyNTAwIGRvZXNuJ3QgaGF2ZSB3b3JraW5n
IEhXIGNoZWNrc3VtIGdlbmVyYXRpb24gKi8NCiAgICA+ID4gKyAgICAgaWYgKG5wICYmIChvZl9k
ZXZpY2VfaXNfY29tcGF0aWJsZShucCwgImFzcGVlZCxhc3QyNDAwLW1hYyIpIHx8DQogICAgPiA+
ICsgICAgICAgICAgICAgICAgb2ZfZGV2aWNlX2lzX2NvbXBhdGlibGUobnAsICJhc3BlZWQsYXN0
MjUwMC1tYWMiKSkpDQogICAgDQogICAgRG8geW91IHJlY2FsbCB1bmRlciB3aGF0IGNpcmN1bXN0
YW5jZXMgd2UgbmVlZCB0byBkaXNhYmxlIGhhcmR3YXJlIGNoZWNrc3VtbWluZz8NCk1haW5seSwg
VENQIHBhY2tldHMgb3ZlciBJUFY2IGdldHRpbmcgZHJvcHBlZC4gQWZ0ZXIgZGlzYWJsaW5nIGl0
IHdhcyB3b3JraW5nLg0KICAgIA0KICAgIENoZWVycywNCiAgICANCiAgICBKb2VsDQogICAgDQog
ICAgPiA+ICAgICAgICAgICAgICAgbmV0ZGV2LT5od19mZWF0dXJlcyAmPSB+TkVUSUZfRl9IV19D
U1VNOw0KICAgID4gPiAgICAgICBpZiAobnAgJiYgb2ZfZ2V0X3Byb3BlcnR5KG5wLCAibm8taHct
Y2hlY2tzdW0iLCBOVUxMKSkNCiAgICA+ID4gICAgICAgICAgICAgICBuZXRkZXYtPmh3X2ZlYXR1
cmVzICY9IH4oTkVUSUZfRl9IV19DU1VNIHwgTkVUSUZfRl9SWENTVU0pOw0KICAgID4gPg0KICAg
ID4NCiAgICA+DQogICAgPiAtLQ0KICAgID4gRmxvcmlhbg0KICAgIA0KDQo=
