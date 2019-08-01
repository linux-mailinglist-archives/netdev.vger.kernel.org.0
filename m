Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F6D7D4D5
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 07:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfHAFVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 01:21:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14482 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725379AbfHAFVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 01:21:25 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x715JRlv025404;
        Wed, 31 Jul 2019 22:21:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+KsMD+mrYgQX0qFFPtEvfVdIJ4jmNo/UpxFL9/vQlvQ=;
 b=oC1qt0algtDk1tdLMyTnInE+96Rm6YBA43FEO8RLpxYsqkxbdqqIoXvfnQJwPD5SrJJH
 ou9Xn/dUOe384wQ78O7J39n5HFbRuqluP2m0LOPVqF9MHYIgOSrrNksGm68zK82tuGhF
 MnA7zBxOWDiCOK8IpRpBSoJHkXbedVJUmnM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u3q5jgexg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 31 Jul 2019 22:21:12 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 22:21:11 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 31 Jul 2019 22:21:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5ijAAkICIzE+a3Brbnixmm5UmRvzyeEkWMslyJHSRBvo3ahE13Bc3uqjFiLgh8wXt8sT7fvcRGpewOIb0he8Htyy9SqR6WA3QY3FszA7+ArP9kqvnyVC60YKrnbL1GLuCTtEDuj1pvgJNNW3R4KJdrcR2Qn1bEfz6IErbUD9hkVP9gr8Fc2577SrWdu1f//zcCsK6Vc21gemKHB8yMEgWFmW22boKIiDUpvvqXS4KLrw1nZpU4bhz5U5PozUm1nDRbE1DPFBClSlXoY9MJ4OJnoIVYeo6BMeyl8o1IWnOktQbsJiXoJ7wDEPfSWlSf4l62pnT5g5Nh9M4ly+OeHnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KsMD+mrYgQX0qFFPtEvfVdIJ4jmNo/UpxFL9/vQlvQ=;
 b=Wv4ngiObY/f3MAvJ9oAxt6vtiK2nxfq1iytLOgNuEK5h36lsUXP6y1+fi1d3NMeUQGWieAFaMkS+AzLSxZd2LNOtHG+R4O22/1HWBLsiu/qwVbQ54ADiNypymdOZFYn88W6QimBfEeWimI2iskUsdsFUNoq8eO/pmxXvGvILtKJmTVj+PBnDlzv7NCEyzqVt5gW00Pe9Vv7nOJVz3MM0SquRpagq2iR/hMJTFRL23pVKqrs6S09d0pE58H3MxDdkzkGHUFuxezn2LEKJk19ww5u8suMY1WYFY/LZ8N6/9C0mBI78JfEFr7SqSLLJBucz/SeYKUXjwNCrsSVzrUsy2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KsMD+mrYgQX0qFFPtEvfVdIJ4jmNo/UpxFL9/vQlvQ=;
 b=gy4CMuopydIWJO8snhWPK0mhJdbWI66nwxCXstLPM1LTb0rqqoqc579I7XSZ7oESk8QC5CMdBK1qcg5shy4W5NeNOddCVwUFdP3NeobIFlrh7kG5gDK8Zc94U+DKYqDKg4ARIFKGwWE6+GLrV7EyVqXx5nlkXsZoVvDaQtaikrE=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1808.namprd15.prod.outlook.com (10.174.96.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 05:20:56 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c%8]) with mapi id 15.20.2136.010; Thu, 1 Aug 2019
 05:20:56 +0000
From:   Tao Ren <taoren@fb.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next 1/2] net: phy: broadcom: set features explicitly
 for BCM54616S
Thread-Topic: [PATCH net-next 1/2] net: phy: broadcom: set features explicitly
 for BCM54616S
Thread-Index: AQHVRm4tZSvvLl002ECU4Omi5U5C86bigvAA//+jr4CAAISsAIABMSsAgABfTQD//4x8gIAB/KuA
Date:   Thu, 1 Aug 2019 05:20:56 +0000
Message-ID: <88f4d709-d9bb-943c-37a9-aeebe8ca0ebc@fb.com>
References: <20190730002532.85509-1-taoren@fb.com>
 <20190730033558.GB20628@lunn.ch>
 <aff2728d-5db1-50fd-767c-29b355890323@fb.com>
 <bdfe07d3-66b4-061a-a149-aa2aef94b9b7@gmail.com>
 <f59c2ae9-ef44-1e1b-4ae2-216eb911e92e@fb.com>
 <41c1f898-aee8-d73a-386d-c3ce280c5a1b@gmail.com>
 <fd179662-b9f9-4813-b9b5-91dbd796596e@fb.com>
In-Reply-To: <fd179662-b9f9-4813-b9b5-91dbd796596e@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0055.namprd02.prod.outlook.com
 (2603:10b6:301:73::32) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:ed2b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5a4a902-990b-4940-b903-08d7164007ad
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1808;
x-ms-traffictypediagnostic: MWHPR15MB1808:
x-microsoft-antispam-prvs: <MWHPR15MB180837CC8AE2EC1448E91965B2DE0@MWHPR15MB1808.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(396003)(39860400002)(366004)(189003)(199004)(40764003)(65826007)(8676002)(8936002)(14444005)(256004)(81166006)(81156014)(14454004)(6246003)(31686004)(6486002)(186003)(64126003)(7736002)(71200400001)(46003)(71190400001)(305945005)(316002)(68736007)(58126008)(446003)(53936002)(229853002)(110136005)(54906003)(478600001)(99286004)(6512007)(6436002)(66446008)(65806001)(65956001)(53546011)(6506007)(5660300002)(386003)(25786009)(102836004)(52116002)(4326008)(66556008)(76176011)(86362001)(11346002)(476003)(7416002)(2616005)(486006)(36756003)(6116002)(31696002)(2906002)(66946007)(64756008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1808;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: u1dkerU71pmpADGaRMYkbtXiYe0a8P5XPWz1Q+Tr66NfzqcHI/qt5f66mEVYc85Wk1lqfE/4e7OKIfsB5pItwobV6CRHZBMREKplKLTkrlLq8KTkVFJu8+H4ot1Nnerj2aHguw0m/0w00VShGoGI+14LKiRmUmkEwN5NNrPxaileFwK3D8oMdzjvWVOj+tKDMRiYA5NYCp+Fzwaqgalq473gi3dflbVYD5Q9QtAgjgdRhoN2E9ln8LXoNfeGUCdvaqpA4BjGCiUNF59pJgJToP0TtZk0naGpCzfRQJpQShTpVMaXCpUMTUQdVXf1qOtlAhwkGSm0hAFnTIP5cvs07cNRHDAUhjdUn/dDuJbUdBAnUw4veWPYdlxXJd+76b1iADRXjrpAwnOv7C1Xb1rtTYF4H9DYpvgOhHwkQiZz5K0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2E57299AF3A684DB55784790C163BF5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a4a902-990b-4940-b903-08d7164007ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 05:20:56.1060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1808
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-01_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908010051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8zMC8xOSAxMTowMCBQTSwgVGFvIFJlbiB3cm90ZToNCj4gT24gNy8zMC8xOSAxMDo1MyBQ
TSwgSGVpbmVyIEthbGx3ZWl0IHdyb3RlOg0KPj4gT24gMzEuMDcuMjAxOSAwMjoxMiwgVGFvIFJl
biB3cm90ZToNCj4+PiBPbiA3LzI5LzE5IDExOjAwIFBNLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6
DQo+Pj4+IE9uIDMwLjA3LjIwMTkgMDc6MDUsIFRhbyBSZW4gd3JvdGU6DQo+Pj4+PiBPbiA3LzI5
LzE5IDg6MzUgUE0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4+Pj4+IE9uIE1vbiwgSnVsIDI5LCAy
MDE5IGF0IDA1OjI1OjMyUE0gLTA3MDAsIFRhbyBSZW4gd3JvdGU6DQo+Pj4+Pj4+IEJDTTU0NjE2
UyBmZWF0dXJlICJQSFlfR0JJVF9GRUFUVVJFUyIgd2FzIHJlbW92ZWQgYnkgY29tbWl0IGRjZGVj
ZGNmZTFmYw0KPj4+Pj4+PiAoIm5ldDogcGh5OiBzd2l0Y2ggZHJpdmVycyB0byB1c2UgZHluYW1p
YyBmZWF0dXJlIGRldGVjdGlvbiIpLiBBcyBkeW5hbWljDQo+Pj4+Pj4+IGZlYXR1cmUgZGV0ZWN0
aW9uIGRvZXNuJ3Qgd29yayB3aGVuIEJDTTU0NjE2UyBpcyB3b3JraW5nIGluIFJHTUlJLUZpYmVy
DQo+Pj4+Pj4+IG1vZGUgKGRpZmZlcmVudCBzZXRzIG9mIE1JSSBDb250cm9sL1N0YXR1cyByZWdp
c3RlcnMgYmVpbmcgdXNlZCksIGxldCdzDQo+Pj4+Pj4+IHNldCAiUEhZX0dCSVRfRkVBVFVSRVMi
IGZvciBCQ001NDYxNlMgZXhwbGljaXRseS4NCj4+Pj4+Pg0KPj4+Pj4+IEhpIFRhbw0KPj4+Pj4+
DQo+Pj4+Pj4gV2hhdCBleGFjdGx5IGRvZXMgaXQgZ2V0IHdyb25nPw0KPj4+Pj4+DQo+Pj4+Pj4g
ICAgICBUaGFua3MNCj4+Pj4+PiAJQW5kcmV3DQo+Pj4+Pg0KPj4+Pj4gSGkgQW5kcmV3LA0KPj4+
Pj4NCj4+Pj4+IEJDTTU0NjE2UyBpcyBzZXQgdG8gUkdNSUktRmliZXIgKDEwMDBCYXNlLVgpIG1v
ZGUgb24gbXkgcGxhdGZvcm0sIGFuZCBub25lIG9mIHRoZSBmZWF0dXJlcyAoMTAwMEJhc2VULzEw
MEJhc2VULzEwQmFzZVQpIGNhbiBiZSBkZXRlY3RlZCBieSBnZW5waHlfcmVhZF9hYmlsaXRpZXMo
KSwgYmVjYXVzZSB0aGUgUEhZIG9ubHkgcmVwb3J0cyAxMDAwQmFzZVhfRnVsbHxIYWxmIGFiaWxp
dHkgaW4gdGhpcyBtb2RlLg0KPj4+Pj4NCj4+Pj4gQXJlIHlvdSBnb2luZyB0byB1c2UgdGhlIFBI
WSBpbiBjb3BwZXIgb3IgZmlicmUgbW9kZT8NCj4+Pj4gSW4gY2FzZSB5b3UgdXNlIGZpYnJlIG1v
ZGUsIHdoeSBkbyB5b3UgbmVlZCB0aGUgY29wcGVyIG1vZGVzIHNldCBhcyBzdXBwb3J0ZWQ/DQo+
Pj4+IE9yIGRvZXMgdGhlIFBIWSBqdXN0IHN0YXJ0IGluIGZpYnJlIG1vZGUgYW5kIHlvdSB3YW50
IHRvIHN3aXRjaCBpdCB0byBjb3BwZXIgbW9kZT8NCj4+Pg0KPj4+IEhpIEhlaW5lciwNCj4+Pg0K
Pj4+IFRoZSBwaHkgc3RhcnRzIGluIGZpYmVyIG1vZGUgYW5kIHRoYXQncyB0aGUgbW9kZSBJIHdh
bnQuDQo+Pj4gTXkgb2JzZXJ2YXRpb24gaXM6IHBoeWRldi0+bGluayBpcyBhbHdheXMgMCAoTGlu
ayBzdGF0dXMgYml0IGlzIG5ldmVyIHNldCBpbiBNSUlfQk1TUikgYnkgdXNpbmcgZHluYW1pYyBh
YmlsaXR5IGRldGVjdGlvbiBvbiBteSBtYWNoaW5lLiBJIGNoZWNrZWQgcGh5ZGV2LT5zdXBwb3J0
ZWQgYW5kIGl0J3Mgc2V0IHRvICJBdXRvTmVnIHwgVFAgfCBNSUkgfCBQYXVzZSB8IEFzeW1fUGF1
c2UiIGJ5IGR5bmFtaWMgYWJpbGl0eSBkZXRlY3Rpb24uIElzIGl0IG5vcm1hbC9leHBlY3RlZD8g
T3IgbWF5YmUgdGhlIGZpeCBzaG91bGQgZ28gdG8gZGlmZmVyZW50IHBsYWNlcz8gVGhhbmsgeW91
IGZvciB5b3VyIGhlbHAuDQo+Pj4NCj4+DQo+PiBOb3Qgc3VyZSB3aGV0aGVyIHlvdSBzdGF0ZWQg
YWxyZWFkeSB3aGljaCBrZXJuZWwgdmVyc2lvbiB5b3UncmUgdXNpbmcuDQo+PiBUaGVyZSdzIGEg
YnJhbmQtbmV3IGV4dGVuc2lvbiB0byBhdXRvLWRldGVjdCAxMDAwQmFzZVg6DQo+PiBmMzBlMzNi
Y2RhYjkgKCJuZXQ6IHBoeTogQWRkIG1vcmUgMTAwMEJhc2VYIHN1cHBvcnQgZGV0ZWN0aW9uIikN
Cj4+IEl0J3MgaW5jbHVkZWQgaW4gdGhlIDUuMy1yYyBzZXJpZXMuDQo+IA0KPiBJJ20gcnVubmlu
ZyBrZXJuZWwgNS4yLjAuIFRoYW5rIHlvdSBmb3IgdGhlIHNoYXJpbmcgYW5kIEkgZGlkbid0IGtu
b3cgdGhlIHBhdGNoLiBMZXQgbWUgY2hlY2sgaXQgb3V0Lg0KDQpJIGFwcGxpZWQgYWJvdmUgcGF0
Y2ggYW5kIGNhNzJlZmI2YmRjNyAoIm5ldDogcGh5OiBBZGQgZGV0ZWN0aW9uIG9mIDEwMDBCYXNl
WCBsaW5rIG1vZGUgc3VwcG9ydCIpIHRvIG15IDUuMi4wIHRyZWUgYnV0IGdvdCBmb2xsb3dpbmcg
d2FybmluZyB3aGVuIGJvb3RpbmcgdXAgbXkgbWFjaGluZToNCg0KIlBIWSBhZHZlcnRpc2luZyAo
MCwwMDAwMDIwMCwwMDAwNjJjMCkgbW9yZSBtb2RlcyB0aGFuIGdlbnBoeSBzdXBwb3J0cywgc29t
ZSBtb2RlcyBub3QgYWR2ZXJ0aXNlZCIuDQoNClRoZSBCQ001NDYxNlMgUEhZIG9uIG15IG1hY2hp
bmUgb25seSByZXBvcnRzIDEwMDAtWCBmZWF0dXJlcyBpbiBSR01JSS0+MTAwMEJhc2UtS1ggbW9k
ZS4gSXMgaXQgYSBrbm93biBwcm9ibGVtPw0KDQpBbnl3YXlzIGxldCBtZSBzZWUgaWYgSSBtaXNz
ZWQgc29tZSBkZXBlbmRlbmN5L2ZvbGxvdy11cCBwYXRjaGVzLi4NCg0KDQpDaGVlcnMsDQoNClRh
bw0K
