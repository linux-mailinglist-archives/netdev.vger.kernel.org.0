Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B37197B963
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 08:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfGaGAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 02:00:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28748 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725911AbfGaGAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 02:00:37 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6V5wu1R005061;
        Tue, 30 Jul 2019 23:00:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9BNR0CfWPN36aH8+WibMCit0zYiwgNFRpvylOxYv2qQ=;
 b=o4OWkWOVHiC+ZVXI5nqSNJwwUJ97PshI5gzDMbYQ+KQWY0kbTpYUPI6KIrpGxTFbq9/B
 XRNthDjkW3ZfZcvMAcSA3Y9wlt3xro2mC8lobrWTrKdts/4GyA1UqCBRb5j4Hju6gpq6
 39UWmfB7wkflTJ07aT0jDR5WXLqSubR9wL8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2u31kwgjt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 30 Jul 2019 23:00:21 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 23:00:20 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 23:00:20 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 23:00:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pgx6/xAMw/NqBDrK/nnHF/UpOotiI7PTCV/o6G6UYe1i53pmHSJtOIwYezjq2NEDTOy0ifO1Yvaw7PLZFeDfjoOOdE2mm0qOdIWfFNP0UXM1XH96NzSqIos5AR4b3pIhhOJQL1+sR609WgqXgIkImFcyLSSnPCAcL2av1oHJHtNzsBHw14j059SgVAWnQxxPk3Hn5OpZwA1GAbXiY8DJP0tOcEidXLVW8iM0C4HF2N6rHCp9Gx0l3II5NK82B8b2kNutj2+VxbJbO1fXwu2xHDdJwtsnSV3MKNXHi2jsfiQAciMW1jq4iFjP5AnzpLFDR7tVBntQ+LxxOJWfiKSp/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BNR0CfWPN36aH8+WibMCit0zYiwgNFRpvylOxYv2qQ=;
 b=PHVGnF653RtEqspqj4tG9FEmycBscxNEKKwZ3NR6WoZGIvumOteLujcchbmmAX8Ef5j5AqBcmpvXwEgWEJu+osx2keNUJqO9a4OsPe31I814wspMwfGvK5kku1jPneDX6+hW4dIr5qNoJqHhmV5rTNfBloTmTpJuWttx3+RHpkfMmEuwK+CyxFhswL/bx3lErPXFuF7rMu302zWOhPLR/D/iqlVXRItGvgOVM5zzMnym5aQ8So2HLUn6YVfcr7rRQyzjK3IDZyv/UuGKff8NLDS81zlGOWYSbzLaJmggyd02DB1i0gMlKPp9kCRi9RNhjcRaOZIxB+6ZeX3Y+SSGmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BNR0CfWPN36aH8+WibMCit0zYiwgNFRpvylOxYv2qQ=;
 b=b8pbahoD2f3Nq+0cFWoYUN96x9ZjK1cJzrK5WJkHHwtA5i8Iub40/oZyQdgRGHXTK8pTYUh3lfXSjJFNmAn2It8XuXJ5/0S9Py7tbiuzhBy6I+TdYEra+xsE5mGyzZ0xzoUxTBwO74QE9kD837ztOEmJRK+BEoayGh3QXMKVsIo=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1822.namprd15.prod.outlook.com (10.174.98.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 06:00:19 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c%8]) with mapi id 15.20.2136.010; Wed, 31 Jul 2019
 06:00:19 +0000
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
Thread-Index: AQHVRm4tZSvvLl002ECU4Omi5U5C86bigvAA//+jr4CAAISsAIABMSsAgABfTQCAAAHUgA==
Date:   Wed, 31 Jul 2019 06:00:19 +0000
Message-ID: <fd179662-b9f9-4813-b9b5-91dbd796596e@fb.com>
References: <20190730002532.85509-1-taoren@fb.com>
 <20190730033558.GB20628@lunn.ch>
 <aff2728d-5db1-50fd-767c-29b355890323@fb.com>
 <bdfe07d3-66b4-061a-a149-aa2aef94b9b7@gmail.com>
 <f59c2ae9-ef44-1e1b-4ae2-216eb911e92e@fb.com>
 <41c1f898-aee8-d73a-386d-c3ce280c5a1b@gmail.com>
In-Reply-To: <41c1f898-aee8-d73a-386d-c3ce280c5a1b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0067.namprd10.prod.outlook.com
 (2603:10b6:300:2c::29) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:9911]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 165838f0-bb2d-405a-b0d5-08d7157c5db8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1822;
x-ms-traffictypediagnostic: MWHPR15MB1822:
x-microsoft-antispam-prvs: <MWHPR15MB1822644EC892306C3A6AF723B2DF0@MWHPR15MB1822.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(346002)(396003)(376002)(366004)(40764003)(199004)(189003)(52116002)(6486002)(76176011)(8676002)(8936002)(81166006)(386003)(102836004)(5660300002)(81156014)(66946007)(6512007)(110136005)(66476007)(6506007)(6116002)(53936002)(256004)(25786009)(54906003)(66556008)(7416002)(64756008)(66446008)(7736002)(71190400001)(71200400001)(86362001)(6436002)(2906002)(99286004)(46003)(229853002)(53546011)(31696002)(68736007)(14444005)(65956001)(186003)(64126003)(316002)(476003)(36756003)(4326008)(65826007)(31686004)(305945005)(2616005)(486006)(65806001)(11346002)(446003)(478600001)(58126008)(6246003)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1822;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iTSFjFmqJiuCY4Gg7NPuVruSGubX55DsmzGhRBwQfBhleXQcdQmNGA9WhHzsRfKqG0l3pbXqQIGcw6d1dJSlniBDoVMkv873/87wjkHrwxZiVV/7wDIIM+EmD17//ypbu7SipBaWPY6k5IU4Ks/wVVAEwJ6tauni4bE6VYoHENXqbPnDfOlDb+g6b1kSs/5rmKk5DHNyt+4zCpNRTwQV6/iLueGDh6o+KrKXiymz59cRXxmuvyAEXgzhr8pg7NbT0vuiFjEtidr3FzM3sOvdToT+OTLkJN/jAiCRvKB+T62Gmqc+CmNFCEvhPrALC3Wc6/yqeHHwzxj2OrLrxsNXFQiXybjzVFG/D5/SX+5a8fdzlUCqPXKQaf6Ty3IXkcVihwskAfJaEjARwnCfjCn7U45soqFWwgUH7E3JwUFVtRk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <283D8FE9B438C541AAF9502D9435A442@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 165838f0-bb2d-405a-b0d5-08d7157c5db8
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 06:00:19.0458
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
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8zMC8xOSAxMDo1MyBQTSwgSGVpbmVyIEthbGx3ZWl0IHdyb3RlOg0KPiBPbiAzMS4wNy4y
MDE5IDAyOjEyLCBUYW8gUmVuIHdyb3RlOg0KPj4gT24gNy8yOS8xOSAxMTowMCBQTSwgSGVpbmVy
IEthbGx3ZWl0IHdyb3RlOg0KPj4+IE9uIDMwLjA3LjIwMTkgMDc6MDUsIFRhbyBSZW4gd3JvdGU6
DQo+Pj4+IE9uIDcvMjkvMTkgODozNSBQTSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+Pj4+PiBPbiBN
b24sIEp1bCAyOSwgMjAxOSBhdCAwNToyNTozMlBNIC0wNzAwLCBUYW8gUmVuIHdyb3RlOg0KPj4+
Pj4+IEJDTTU0NjE2UyBmZWF0dXJlICJQSFlfR0JJVF9GRUFUVVJFUyIgd2FzIHJlbW92ZWQgYnkg
Y29tbWl0IGRjZGVjZGNmZTFmYw0KPj4+Pj4+ICgibmV0OiBwaHk6IHN3aXRjaCBkcml2ZXJzIHRv
IHVzZSBkeW5hbWljIGZlYXR1cmUgZGV0ZWN0aW9uIikuIEFzIGR5bmFtaWMNCj4+Pj4+PiBmZWF0
dXJlIGRldGVjdGlvbiBkb2Vzbid0IHdvcmsgd2hlbiBCQ001NDYxNlMgaXMgd29ya2luZyBpbiBS
R01JSS1GaWJlcg0KPj4+Pj4+IG1vZGUgKGRpZmZlcmVudCBzZXRzIG9mIE1JSSBDb250cm9sL1N0
YXR1cyByZWdpc3RlcnMgYmVpbmcgdXNlZCksIGxldCdzDQo+Pj4+Pj4gc2V0ICJQSFlfR0JJVF9G
RUFUVVJFUyIgZm9yIEJDTTU0NjE2UyBleHBsaWNpdGx5Lg0KPj4+Pj4NCj4+Pj4+IEhpIFRhbw0K
Pj4+Pj4NCj4+Pj4+IFdoYXQgZXhhY3RseSBkb2VzIGl0IGdldCB3cm9uZz8NCj4+Pj4+DQo+Pj4+
PiAgICAgIFRoYW5rcw0KPj4+Pj4gCUFuZHJldw0KPj4+Pg0KPj4+PiBIaSBBbmRyZXcsDQo+Pj4+
DQo+Pj4+IEJDTTU0NjE2UyBpcyBzZXQgdG8gUkdNSUktRmliZXIgKDEwMDBCYXNlLVgpIG1vZGUg
b24gbXkgcGxhdGZvcm0sIGFuZCBub25lIG9mIHRoZSBmZWF0dXJlcyAoMTAwMEJhc2VULzEwMEJh
c2VULzEwQmFzZVQpIGNhbiBiZSBkZXRlY3RlZCBieSBnZW5waHlfcmVhZF9hYmlsaXRpZXMoKSwg
YmVjYXVzZSB0aGUgUEhZIG9ubHkgcmVwb3J0cyAxMDAwQmFzZVhfRnVsbHxIYWxmIGFiaWxpdHkg
aW4gdGhpcyBtb2RlLg0KPj4+Pg0KPj4+IEFyZSB5b3UgZ29pbmcgdG8gdXNlIHRoZSBQSFkgaW4g
Y29wcGVyIG9yIGZpYnJlIG1vZGU/DQo+Pj4gSW4gY2FzZSB5b3UgdXNlIGZpYnJlIG1vZGUsIHdo
eSBkbyB5b3UgbmVlZCB0aGUgY29wcGVyIG1vZGVzIHNldCBhcyBzdXBwb3J0ZWQ/DQo+Pj4gT3Ig
ZG9lcyB0aGUgUEhZIGp1c3Qgc3RhcnQgaW4gZmlicmUgbW9kZSBhbmQgeW91IHdhbnQgdG8gc3dp
dGNoIGl0IHRvIGNvcHBlciBtb2RlPw0KPj4NCj4+IEhpIEhlaW5lciwNCj4+DQo+PiBUaGUgcGh5
IHN0YXJ0cyBpbiBmaWJlciBtb2RlIGFuZCB0aGF0J3MgdGhlIG1vZGUgSSB3YW50Lg0KPj4gTXkg
b2JzZXJ2YXRpb24gaXM6IHBoeWRldi0+bGluayBpcyBhbHdheXMgMCAoTGluayBzdGF0dXMgYml0
IGlzIG5ldmVyIHNldCBpbiBNSUlfQk1TUikgYnkgdXNpbmcgZHluYW1pYyBhYmlsaXR5IGRldGVj
dGlvbiBvbiBteSBtYWNoaW5lLiBJIGNoZWNrZWQgcGh5ZGV2LT5zdXBwb3J0ZWQgYW5kIGl0J3Mg
c2V0IHRvICJBdXRvTmVnIHwgVFAgfCBNSUkgfCBQYXVzZSB8IEFzeW1fUGF1c2UiIGJ5IGR5bmFt
aWMgYWJpbGl0eSBkZXRlY3Rpb24uIElzIGl0IG5vcm1hbC9leHBlY3RlZD8gT3IgbWF5YmUgdGhl
IGZpeCBzaG91bGQgZ28gdG8gZGlmZmVyZW50IHBsYWNlcz8gVGhhbmsgeW91IGZvciB5b3VyIGhl
bHAuDQo+Pg0KPiANCj4gTm90IHN1cmUgd2hldGhlciB5b3Ugc3RhdGVkIGFscmVhZHkgd2hpY2gg
a2VybmVsIHZlcnNpb24geW91J3JlIHVzaW5nLg0KPiBUaGVyZSdzIGEgYnJhbmQtbmV3IGV4dGVu
c2lvbiB0byBhdXRvLWRldGVjdCAxMDAwQmFzZVg6DQo+IGYzMGUzM2JjZGFiOSAoIm5ldDogcGh5
OiBBZGQgbW9yZSAxMDAwQmFzZVggc3VwcG9ydCBkZXRlY3Rpb24iKQ0KPiBJdCdzIGluY2x1ZGVk
IGluIHRoZSA1LjMtcmMgc2VyaWVzLg0KDQpJJ20gcnVubmluZyBrZXJuZWwgNS4yLjAuIFRoYW5r
IHlvdSBmb3IgdGhlIHNoYXJpbmcgYW5kIEkgZGlkbid0IGtub3cgdGhlIHBhdGNoLiBMZXQgbWUg
Y2hlY2sgaXQgb3V0Lg0KDQo+IElmIGEgZmVhdHVyZSBjYW4gYmUgcmVhZCBmcm9tIGEgdmVuZG9y
LXNwZWNpZmljIHJlZ2lzdGVyIG9ubHksDQo+IHRoZW4gdGhlIHByZWZlcnJlZCB3YXkgaXM6IElt
cGxlbWVudCBjYWxsYmFjayBnZXRfZmVhdHVyZXMgaW4NCj4gdGhlIFBIWSBkcml2ZXIsIGNhbGwg
Z2VucGh5X3JlYWRfYWJpbGl0aWVzIGZvciB0aGUgYmFzaWMgZmVhdHVyZXMNCj4gYW5kIGNvbXBs
ZW1lbnQgaXQgd2l0aCByZWFkaW5nIHRoZSB2ZW5kb3Itc3BlY2lmaWMgcmVnaXN0ZXIocykuDQoN
CkdvdCBpdC4gTGV0IG1lIHVwZGF0ZSBteSBjb2RlIGFuZCB3aWxsIGNvbWUgYmFjayBzb29uLg0K
DQoNClRoYW5rcywNCg0KVGFvDQo=
