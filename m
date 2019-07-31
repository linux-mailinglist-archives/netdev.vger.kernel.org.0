Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6157B947
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 07:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfGaFzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 01:55:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725209AbfGaFzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 01:55:50 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V5sr9v032450;
        Tue, 30 Jul 2019 22:55:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=W88LgfjFa07AjZslWfc/p+UljO7Cmbisy0D9m25I71M=;
 b=Rib8e2mHV6tR2E7EqzmKCBj/f35iiZ0arqwJMInDohhyVTKufM/KBPbPWmfu8kJTB+W/
 IsCQE/rvMMVjRRBKjne43feFp+3/JTO8NZM0ic4V/31HKCnIyC90MAAd8am3J1emqyQE
 PO4YZHKg7y8lelVTrzKHWT/7/2X1vTZYF8g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2p9hk6nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jul 2019 22:55:34 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 22:55:33 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 22:55:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqUgieo7X8tL97gBerfFQIgnafNAYHD1MSqe8aEULIGktpsLQxWLN+NXjeZhlYvfkI+FobLH7irVrIHEjdyrSm4UpHL7KJZcubVJImBgM6t/PGjJklFdaL3iu4lKhi051QwyZXRouQarkLLJKXpg/WB/W+AaUdV3WtdtDmVSTI2CA1GH1p8FJP57JZh47ahIZVOkHNab4LWKTRS0VEp70K61sMNbqT9G9XQxT9+viSrxJEfljAXpgQRJGJuOl4JXJZAD87CZ9ZHEyk1bAt17OaYowkeZXZzhpRToDHl8Qnd1b0dtvFqh48pLtemoDvg2ccAcAdbs1McZxLS3c2g3pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W88LgfjFa07AjZslWfc/p+UljO7Cmbisy0D9m25I71M=;
 b=ihIS1QJBCc6j/xfDARVpvmoV5n1Zj3bozL83ckdFq4q41oWE2SHYIkTkPwKQcSLz3fUI8NH/1RGuXjqLM/2uGr2sWz0X628RDjXFsltXoWFG9VnxaV1CLZHYV7JUyJvAKiZWRfQFNky267SKfu8Nu10cLvZkoqBmphPjws5eEd5iVYNvP6h9kIiE/LBRAgl5sKAvRCfvdfwy0o4DeFSgi6SkcnKTO1tujKG+bSTIpw9E9KDx/9S+oslFYo2sbsfG2I5uOkVTUhy7l2altNnmjdrslYmHix5oF0qkzHv2HLqM+jWUq7xOxypoFyTb1U3rV7JCQbA9KZ7C6AtttnHQ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W88LgfjFa07AjZslWfc/p+UljO7Cmbisy0D9m25I71M=;
 b=aJfilwYxyMf+c/jl810iSxxE2Vk8PXezr7vu5EmIIeqk3n5rEMIyD3n5yzWAfslGeO1wXLH5coi1XE18W48xaub2hIRYuoTDCKm29MsmWIq8+TEdC5IYA9KPilKtawzun2GJ4tpS7cg9eUknxuFQlg5IfzGixbhrkHE3aMFS08o=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1822.namprd15.prod.outlook.com (10.174.98.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 05:55:32 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c%8]) with mapi id 15.20.2136.010; Wed, 31 Jul 2019
 05:55:32 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Topic: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Index: AQHVRm4oHxOo2s4k1kyYCsigpkISsabiYHeAgAA34ACAAFoWAIAA4hcAgAAfZwCAAAkVAIAABwmAgAA4N4A=
Date:   Wed, 31 Jul 2019 05:55:32 +0000
Message-ID: <08f55ccc-7d2a-996b-770b-a0f035889196@fb.com>
References: <20190730002549.86824-1-taoren@fb.com>
 <CA+h21hq1+E6-ScFx425hXwTPTZHTVZbBuAm7RROFZTBOFvD8vQ@mail.gmail.com>
 <3987251b-9679-dfbe-6e15-f991c2893bac@fb.com>
 <CA+h21ho1KOGS3WsNBHzfHkpSyE4k5HTE1tV9wUtnkZhjUZGeUw@mail.gmail.com>
 <e8f85ef3-1216-8efb-a54d-84426234fe82@fb.com>
 <20190731013636.GC25700@lunn.ch>
 <885e48dd-df5b-7f08-ef58-557fc2347fa6@fb.com> <20190731023417.GD9523@lunn.ch>
In-Reply-To: <20190731023417.GD9523@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0181.namprd04.prod.outlook.com
 (2603:10b6:104:5::11) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:9911]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edf2904e-296a-4834-94f9-08d7157bb2b2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1822;
x-ms-traffictypediagnostic: MWHPR15MB1822:
x-microsoft-antispam-prvs: <MWHPR15MB18229046AE0AFA8D4296E72BB2DF0@MWHPR15MB1822.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(346002)(136003)(39860400002)(189003)(199004)(36756003)(476003)(2616005)(486006)(305945005)(65826007)(4326008)(31686004)(186003)(64126003)(316002)(6246003)(14454004)(65806001)(11346002)(446003)(478600001)(58126008)(6916009)(6512007)(53936002)(256004)(25786009)(6116002)(6506007)(66476007)(5660300002)(81166006)(102836004)(386003)(8936002)(6486002)(52116002)(8676002)(76176011)(81156014)(66946007)(68736007)(31696002)(53546011)(229853002)(14444005)(65956001)(19627235002)(71200400001)(71190400001)(7736002)(86362001)(66556008)(54906003)(7416002)(66446008)(64756008)(2906002)(46003)(99286004)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1822;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ag8rcsGMaZF0rWMvjgTFooQkD1KxLUbyy3q8xF9DPkgVzi4l+qchEOHggzIwQnCMQqLAo0WXNoyfLVPK86N7AHsLnKwuLUUE9d/MJImhDWh+umXwI3vV5xVmO1HrOjuhHUj8S3rbN+wh84uwpyyERnnpbTi5fmGuU+dfBUlfa6R119Lwgr9gba5AcAiN1Z13itQhRiYyW1lgSP42MJNrCBC0f6RlxrIlKcubVVlf6p2bU3dlHOC+rFYSN5y8zhMvtLNXwaSPhelJ8OTbtcoiGswbDahxUyjp2oudm/GSx1UrVkH9xEaBbIdEQk3fhf5n2QFCd2vB4+8nV324+EaWDpN0hNi14VMjzG1LteULpyfMPgHUI9cREG1T2J+FveXI2SFQOT4XW5oMLjWK6eaVwELMZqV6hE9de4GcB0jVnzQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <00E48AFB27809D44BFCCBF248298298E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: edf2904e-296a-4834-94f9-08d7157bb2b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 05:55:32.1965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1822
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310062
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8zMC8xOSA3OjM0IFBNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+IEhpIEFuZHJldywNCj4+
DQo+PiBUaGUgQkNNNTQ2MTZTIFBIWSBvbiBteSBtYWNoaW5lIGlzIGNvbm5lY3RlZCB0byBhIEJD
TTUzOTYgc3dpdGNoIGNoaXAgb3ZlciBiYWNrcGxhbmUgKDEwMDBCYXNlLUtYKS4NCj4gDQo+IEFo
LCB0aGF0IGlzIGRpZmZlcmVudC4gU28gdGhlIGJvYXJkIGlzIHVzaW5nIGl0IGZvciBSR01JSSB0
byAxMDAwQmFzZS1LWD8NCj4gDQo+IHBoeS1tb2RlIGlzIGFib3V0IHRoZSBNQUMtUEhZIGxpbmsu
IFNvIGluIHRoaXMgY2FzZSBSR01JSS4NCg0KWWVzLiBJdCdzIFJHTUlJIHRvIDEwMDBCYXNlLUtY
Lg0KDQo+IFRoZXJlIGlzIG5vIERUIHdheSB0byBjb25maWd1cmUgdGhlIFBIWS1Td2l0Y2ggbGlu
ay4gSG93ZXZlciwgaXQNCj4gc291bmRzIGxpa2UgeW91IGhhdmUgdGhlIFBIWSBzdHJhcHBlZCBz
byBpdCBpcyBkb2luZyAxMDAwQmFzZVggb24gdGhlDQo+IFBIWS1Td2l0Y2ggbGluay4gU28gZG8g
eW91IGFjdHVhbGx5IG5lZWQgdG8gY29uZmlndXJlIHRoaXM/DQoNClRoZSBQSFkgaXMgc3RyYXBw
ZWQgaW4gUkdNSUktRmliZXIgTW9kZSAodGhlIHRlcm0gdXNlZCBpbiBkYXRhc2hlZXQpLCBidXQg
YmVzaWRlcyAxMDAwQmFzZVgsIDEwMEJhc2UtRlggaXMgYWxzbyBzdXBwb3J0ZWQgaW4gdGhpcyBt
b2RlLg0KVGhlIGRhdGFzaGVldCBkb2Vzbid0IHNheSB3aGljaCBsaW5rIHR5cGUgKDEwMDBCYXNl
WCBvciAxMDBCYXNlLUZYKSBpcyBhY3RpdmUgYWZ0ZXIgcmVzZXQgYW5kIEkgY2Fubm90IGZpbmQg
YSB3YXkgdG8gYXV0by1kZXRlY3QgdGhlIGxpbmsgdHlwZSwgZWl0aGVyLg0KDQpCZWxvdyBhcmUg
YSBmZXcgbW9yZSBkZXRhaWxzIGFib3V0IDEwMDBCYXNlLVggYW5kIDEwMEJhc2UtRlggaW4gQkNN
NTQ2MTZTIGRhdGFzaGVldC4NCg0KLSAxMDAwQmFzZVg6IA0KICBUaGUgMTAwMEJhc2VYIHJlZ2lz
dGVyIHNldCAoTUlJIHJlZ2lzdGVycyAwMC0wRikgbmVlZHMgdG8gYmUgZW5hYmxlZCBieSBzZXR0
aW5nIGJpdCAwIG9mIE1vZGUgQ29udHJvbCBSZWdpc3Rlci4NCiAgQWx0aG91Z2ggdGhlIHJlZ2lz
dGVyIGFkZHJlc3MgaXMgdGhlIHNhbWUgYmV0d2VlbiAxMDAwQmFzZVggYW5kIDEwMDBCYXNlVC8x
MDBCYXNlVC8xMEJhc2VUIHJlZ2lzdGVycywgc29tZSBiaXQgZmllbGRzIGluIDEwMDBCYXNlWCBy
ZWdpc3RlcnMgYXJlIGRpZmZlcmVudDogZm9yIGV4YW1wbGUsIHNwZWVkIGZpZWxkIGlzIG5vdCBh
dmFpbGFibGUgaW4gMTAwMEJhc2VYIHN0YXR1cyByZWdpc3Rlci4NCg0KLSAxMDBCYXNlLUZYOg0K
ICAxMDBCYXNlLUZYIHJlZ2lzdGVycyBuZWVkIHRvIGJlIGVuYWJsZWQgYnkgd3JpdGluZyAxIHRv
IFNlckRlcyAxMDBGWCBDb250cm9sIFJlZ2lzdGVyLg0KICAxMDBCYXNlLUZYIENvbnRyb2wgYW5k
IFN0YXR1cyByZWdpc3RlcnMgYXJlIGluIHNoYWRvdyByZWdpc3RlciAxQ2gsIGluc3RlYWQgb2Yg
TUlJIHJlZ2lzdGVyIDAwaCBhbmQgMDFoLg0KDQo+IFlvdSByZXBvcnQgeW91IG5ldmVyIHNlZSBs
aW5rIHVwPyBTbyBtYXliZSB0aGUgcHJvYmxlbSBpcyBhY3R1YWxseSBpbg0KPiByZWFkX3N0YXR1
cz8gV2hlbiBpbiAxMDAwQmFzZVggbW9kZSwgZG8geW91IG5lZWQgdG8gcmVhZCB0aGUgbGluaw0K
PiBzdGF0dXMgZnJvbSBzb21lIG90aGVyIHJlZ2lzdGVyPyBUaGUgTWFydmVsbCBQSFlzIHVzZSBh
IHNlY29uZCBwYWdlDQo+IGZvciAxMDAwQmFzZVguDQoNCnJlYWRfc3RhdHVzIGNhbGxiYWNrIG5l
ZWRzIHRvIGJlIHVwZGF0ZWQgdG8gcmVwb3J0IGNvcnJlY3QgbGluayBzcGVlZCBpbiBteSBjYXNl
LiBCdXQgYXMgSSBjYW5ub3QgdGVsbCB3aGljaCBsaW5rIHR5cGUgKDEwMDBCYXNlWCBvciAxMDBC
YXNlLUZYKSBpcyBhY3RpdmUsIGl0IGJlY29tZXMgaGFyZCB0byBhY2Nlc3MgcmVnaXN0ZXJzIGlu
IHJlYWRfc3RhdHVzIG1ldGhvZC4gQW55IHN1Z2dlc3Rpb25zPw0KDQpCVFcsIGxpbmstbmV2ZXIt
dXAgaXNzdWUgc2VlbXMgdG8gYmUgY2F1c2VkIGJ5IHN0YXRpYy9keW5hbWljIGZlYXR1cmUgZGV0
ZWN0aW9uLiBJJ20gc3RpbGwgdHJhY2luZyBkb3duIHRoZSBpc3N1ZSBhbmQgaXQncyBiZWluZyB0
cmFja2VkIGluIHBhdGNoICMxIG9mIHRoZSBzZXJpZXMuDQoNCg0KVGhhbmtzLA0KDQpUYW8NCg==
