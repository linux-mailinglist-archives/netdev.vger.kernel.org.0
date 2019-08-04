Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48108098B
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 06:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbfHDEs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 00:48:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39012 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbfHDEsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 00:48:55 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x744mV2W031839;
        Sat, 3 Aug 2019 21:48:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nXrWHWDEqJI5pgRy3hUHNZCZvyYs4KLtNWZLdx+LUjQ=;
 b=hhFGIqqwd+hYITrDqW9ESef8bjGfShdGtOKcNezdnH8bEOjZ8xgWoUQxPFSYlDCfdqIC
 iPyLHhz9ELiRpggt4eCDftNDbPWmhJtuAymIpYN2CM0jrcLWdtEDyFYhSw/Ldi5DgtbR
 vBrCur3nm64hXZTL9ZQXIHqPNjvzKy+FGKc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u59jkt26j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 03 Aug 2019 21:48:30 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 3 Aug 2019 21:48:29 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 3 Aug 2019 21:48:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KxqXyt/jKIumR63IMrCz344zy2FX1+2AfI+XM73R33i4Oxl69nBCpqcE3OtKJOpZHT2IOVVBys42hKOi9b4MtSXWgTfGJZGFfD9bH5LY+UmDCffG/OjBLQH9Ts4FXNWp6n5j1INHgPguj9mWXjRQRy6P/N2Xnz+l2e8uF7Mae41xNoB+c60cjZXZ+WBCPe/L6JGVI1HXShVVWrHbX8k7zzlTrjsSLMAdzPURabnOjRFaZCQYlZLmZdL7aaPPMp1tHr04j5wq3chx+j6pOFASb+HIoI1jek38XfPsmTONlwelF4RQ7UtBSHBnJVCXSQNnhQdS2cdVjKXSWa49ugzbBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXrWHWDEqJI5pgRy3hUHNZCZvyYs4KLtNWZLdx+LUjQ=;
 b=Bxfwr06CII7Iim61IbOTpIS1TtaTF/BpFXIeCcD7yaCMMOUGMDvFy2r6UBnpmoDauJ2QFuq0GNtXCYbgUX1LuWCff6NeriqGylZBkXUHXivucWv3u9r7khWc3a8qGhhvL4GkJmYYcVHPxBpusEnyJRtszan7T7zc0dX2Uqi8ddWZSyY4LPfK0237SYcy0xlrOX5DH+hZXHObtOH38qscI9Vvmf8Fh9fj5LDvPifDpC8ixI+QVkH3wM6iHX/P7lcBppVWCkdXu9ofsst9DgEggdBGlSUkLAvxhvrrADXvqVr+t5F490psw6KOC1zDcwKBQ4LMtEbw3BvfhMEtjOcvkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXrWHWDEqJI5pgRy3hUHNZCZvyYs4KLtNWZLdx+LUjQ=;
 b=b86cOeTJp/cx4LtsjulL/RhgcaDe7HY9oZwGgVPfhfFPIz0+x+txrK5lnDLtx7V2YtVX8sMdBqNeApZbjchXD707ZHQk+5gKjL9MLFsdlVPtAFMNMckR1NLZE8B0+cFhO2yiLR9PTe1PRxFCVam59aDwHnh7CF0fe3nRa1W667M=
Received: from DM5PR15MB1211.namprd15.prod.outlook.com (10.173.210.138) by
 DM5PR15MB1755.namprd15.prod.outlook.com (10.174.108.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Sun, 4 Aug 2019 04:48:28 +0000
Received: from DM5PR15MB1211.namprd15.prod.outlook.com
 ([fe80::98c4:c8ef:ad1c:90db]) by DM5PR15MB1211.namprd15.prod.outlook.com
 ([fe80::98c4:c8ef:ad1c:90db%5]) with mapi id 15.20.2136.010; Sun, 4 Aug 2019
 04:48:28 +0000
From:   Tao Ren <taoren@fb.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Topic: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Index: AQHVSX02YDtqShAJZEiiuBTkPN0xlKbpcXQAgAD7QwA=
Date:   Sun, 4 Aug 2019 04:48:27 +0000
Message-ID: <53e18a01-3d08-3023-374f-2c712c4ee9ea@fb.com>
References: <20190802215419.313512-1-taoren@fb.com>
 <CA+h21hrOEape89MTqCUyGFt=f6ba7Q-2KcOsN_Vw2Qv8iq86jw@mail.gmail.com>
In-Reply-To: <CA+h21hrOEape89MTqCUyGFt=f6ba7Q-2KcOsN_Vw2Qv8iq86jw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1301CA0010.namprd13.prod.outlook.com
 (2603:10b6:301:29::23) To DM5PR15MB1211.namprd15.prod.outlook.com
 (2603:10b6:3:b5::10)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::e689]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58cd09a3-e0c2-44e2-b0a7-08d71896fdba
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1755;
x-ms-traffictypediagnostic: DM5PR15MB1755:
x-microsoft-antispam-prvs: <DM5PR15MB17558F86B1F3A317B546184CB2DB0@DM5PR15MB1755.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0119DC3B5E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(396003)(376002)(346002)(366004)(189003)(199004)(66556008)(386003)(53936002)(66476007)(64756008)(1411001)(53546011)(6916009)(316002)(46003)(36756003)(6506007)(54906003)(86362001)(186003)(486006)(52116002)(11346002)(256004)(305945005)(68736007)(76176011)(7736002)(446003)(65806001)(65826007)(14454004)(5024004)(102836004)(65956001)(99286004)(14444005)(31696002)(58126008)(4326008)(229853002)(25786009)(8936002)(476003)(71200400001)(6486002)(2906002)(478600001)(31686004)(8676002)(81166006)(2616005)(71190400001)(66946007)(5660300002)(81156014)(7416002)(6246003)(6512007)(64126003)(6436002)(6116002)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1755;H:DM5PR15MB1211.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6SYu9KU1TKd4+sWtlxgrkT3QFkujGnzb8lBkmiKMlraoHeWPfdaqAxAqDHvw/ZX4+ydt6f2UpWCi2lmOIQkvDjWXt5wqmSmlZZYu4tOANM6wjuwx/6qp6cQASlmo/crxA3sayN4X5lDuHOUS7Onx6jZMMoWSmvrlbAhkfA9CzmpWsPMLFs9uYEykesh3cygro421urrhYLnvqeXFGK2uzzcA2rfe/pDEQxy0kpRivlrNS19bNC0EPiwEzhdtSyS+L92JrwxPBQzTBsiojosl5YOmNrpdLgAQoRjtqyAkwe6YFT98xRVE5y3qzmdf0/WbtVB3iM2bf5LH6cz5qWWiOljZlu8HGqHExC+iUOCnTSKmZHJ18QfoFnDgn6OFPOHbHXRSZc6itMbbxsv+xn0raHBUzxm5j3MCEjZbDNtJw/Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3CDA1772430AA40BB3A4E535851DB42@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 58cd09a3-e0c2-44e2-b0a7-08d71896fdba
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2019 04:48:27.9864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1755
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-04_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=870 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908040055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIDgvMy8xOSA2OjQ5IEFNLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEhpIFRhbywNCj4gDQo+IE9uIFNhdCwgMyBBdWcgMjAxOSBhdCAwMDo1NiwgVGFvIFJlbiA8
dGFvcmVuQGZiLmNvbT4gd3JvdGU6DQo+Pg0KPj4gZ2VucGh5X3JlYWRfc3RhdHVzKCkgY2Fubm90
IHJlcG9ydCBjb3JyZWN0IGxpbmsgc3BlZWQgd2hlbiBCQ001NDYxNlMgUEhZDQo+PiBpcyBjb25m
aWd1cmVkIGluIFJHTUlJLT4xMDAwQmFzZS1LWCBtb2RlIChmb3IgZXhhbXBsZSwgb24gRmFjZWJv
b2sgQ01NDQo+PiBCTUMgcGxhdGZvcm0pLCBhbmQgaXQgaXMgYmVjYXVzZSBzcGVlZC1yZWxhdGVk
IGZpZWxkcyBpbiBNSUkgcmVnaXN0ZXJzDQo+PiBhcmUgYXNzaWduZWQgZGlmZmVyZW50IG1lYW5p
bmdzIGluIDEwMDBYIHJlZ2lzdGVyIHNldC4gQWN0dWFsbHkgdGhlcmUNCj4+IGlzIG5vIHNwZWVk
IGZpZWxkIGluIDEwMDBYIHJlZ2lzdGVyIHNldCBiZWNhdXNlIGxpbmsgc3BlZWQgaXMgYWx3YXlz
DQo+PiAxMDAwIE1iL3MuDQo+Pg0KPj4gVGhlIHBhdGNoIGFkZHMgInByb2JlIiBjYWxsYmFjayB0
byBkZXRlY3QgUEhZJ3Mgb3BlcmF0aW9uIG1vZGUgYmFzZWQgb24NCj4+IElOVEVSRl9TRUxbMTow
XSBwaW5zIGFuZCAxMDAwWC8xMDBGWCBzZWxlY3Rpb24gYml0IGluIFNlckRFUyAxMDAtRlgNCj4+
IENvbnRyb2wgcmVnaXN0ZXIuIEJlc2lkZXMsIGxpbmsgc3BlZWQgaXMgbWFudWFsbHkgc2V0IHRv
IDEwMDAgTWIvcyBpbg0KPj4gInJlYWRfc3RhdHVzIiBjYWxsYmFjayBpZiBQSFktc3dpdGNoIGxp
bmsgaXMgMTAwMEJhc2UtWC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBUYW8gUmVuIDx0YW9yZW5A
ZmIuY29tPg0KPj4gLS0tDQo+PiAgQ2hhbmdlcyBpbiB2MzoNCj4+ICAgLSByZW5hbWUgYmNtNTQ4
Ml9yZWFkX3N0YXR1cyB0byBiY201NHh4X3JlYWRfc3RhdHVzIHNvIHRoZSBjYWxsYmFjayBjYW4N
Cj4+ICAgICBiZSBzaGFyZWQgYnkgQkNNNTQ4MiBhbmQgQkNNNTQ2MTZTLg0KPj4gIENoYW5nZXMg
aW4gdjI6DQo+PiAgIC0gQXV0by1kZXRlY3QgUEhZIG9wZXJhdGlvbiBtb2RlIGluc3RlYWQgb2Yg
cGFzc2luZyBEVCBub2RlLg0KPj4gICAtIG1vdmUgUEhZIG1vZGUgYXV0by1kZXRlY3QgbG9naWMg
ZnJvbSBjb25maWdfaW5pdCB0byBwcm9iZSBjYWxsYmFjay4NCj4+ICAgLSBvbmx5IHNldCBzcGVl
ZCAobm90IGluY2x1ZGluZyBkdXBsZXgpIGluIHJlYWRfc3RhdHVzIGNhbGxiYWNrLg0KPj4gICAt
IHVwZGF0ZSBwYXRjaCBkZXNjcmlwdGlvbiB3aXRoIG1vcmUgYmFja2dyb3VuZCB0byBhdm9pZCBj
b25mdXNpb24uDQo+PiAgIC0gcGF0Y2ggIzEgaW4gdGhlIHNlcmllcyAoIm5ldDogcGh5OiBicm9h
ZGNvbTogc2V0IGZlYXR1cmVzIGV4cGxpY2l0bHkNCj4+ICAgICBmb3IgQkNNNTQ2MTYiKSBpcyBk
cm9wcGVkOiB0aGUgZml4IHNob3VsZCBnbyB0byBnZXRfZmVhdHVyZXMgY2FsbGJhY2sNCj4+ICAg
ICB3aGljaCBtYXkgcG90ZW50aWFsbHkgZGVwZW5kIG9uIHRoaXMgcGF0Y2guDQo+Pg0KPj4gIGRy
aXZlcnMvbmV0L3BoeS9icm9hZGNvbS5jIHwgNDEgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrLS0tLS0NCj4+ICBpbmNsdWRlL2xpbnV4L2JyY21waHkuaCAgICB8IDEwICsrKysrKysr
LS0NCj4+ICAyIGZpbGVzIGNoYW5nZWQsIDQ0IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0p
DQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9icm9hZGNvbS5jIGIvZHJpdmVy
cy9uZXQvcGh5L2Jyb2FkY29tLmMNCj4+IGluZGV4IDkzN2QwMDU5ZThhYy4uZWNhZDhhMjAxYTA5
IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L2Jyb2FkY29tLmMNCj4+ICsrKyBiL2Ry
aXZlcnMvbmV0L3BoeS9icm9hZGNvbS5jDQo+PiBAQCAtMzgzLDkgKzM4Myw5IEBAIHN0YXRpYyBp
bnQgYmNtNTQ4Ml9jb25maWdfaW5pdChzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPj4gICAg
ICAgICAgICAgICAgIC8qDQo+PiAgICAgICAgICAgICAgICAgICogU2VsZWN0IDEwMDBCQVNFLVgg
cmVnaXN0ZXIgc2V0IChwcmltYXJ5IFNlckRlcykNCj4+ICAgICAgICAgICAgICAgICAgKi8NCj4+
IC0gICAgICAgICAgICAgICByZWcgPSBiY21fcGh5X3JlYWRfc2hhZG93KHBoeWRldiwgQkNNNTQ4
Ml9TSERfTU9ERSk7DQo+PiAtICAgICAgICAgICAgICAgYmNtX3BoeV93cml0ZV9zaGFkb3cocGh5
ZGV2LCBCQ001NDgyX1NIRF9NT0RFLA0KPj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHJlZyB8IEJDTTU0ODJfU0hEX01PREVfMTAwMEJYKTsNCj4+ICsgICAgICAgICAgICAg
ICByZWcgPSBiY21fcGh5X3JlYWRfc2hhZG93KHBoeWRldiwgQkNNNTRYWF9TSERfTU9ERSk7DQo+
PiArICAgICAgICAgICAgICAgYmNtX3BoeV93cml0ZV9zaGFkb3cocGh5ZGV2LCBCQ001NFhYX1NI
RF9NT0RFLA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJlZyB8IEJD
TTU0WFhfU0hEX01PREVfMTAwMEJYKTsNCj4+DQo+PiAgICAgICAgICAgICAgICAgLyoNCj4+ICAg
ICAgICAgICAgICAgICAgKiBMRUQxPUFDVElWSVRZTEVELCBMRUQzPUxJTktTUERbMl0NCj4+IEBA
IC00MDksNyArNDA5LDcgQEAgc3RhdGljIGludCBiY201NDgyX2NvbmZpZ19pbml0KHN0cnVjdCBw
aHlfZGV2aWNlICpwaHlkZXYpDQo+PiAgICAgICAgIHJldHVybiBlcnI7DQo+PiAgfQ0KPj4NCj4+
IC1zdGF0aWMgaW50IGJjbTU0ODJfcmVhZF9zdGF0dXMoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRl
dikNCj4+ICtzdGF0aWMgaW50IGJjbTU0eHhfcmVhZF9zdGF0dXMoc3RydWN0IHBoeV9kZXZpY2Ug
KnBoeWRldikNCj4+ICB7DQo+PiAgICAgICAgIGludCBlcnI7DQo+Pg0KPj4gQEAgLTQ2NCw2ICs0
NjQsMzUgQEAgc3RhdGljIGludCBiY201NDYxNnNfY29uZmlnX2FuZWcoc3RydWN0IHBoeV9kZXZp
Y2UgKnBoeWRldikNCj4+ICAgICAgICAgcmV0dXJuIHJldDsNCj4+ICB9DQo+Pg0KPj4gK3N0YXRp
YyBpbnQgYmNtNTQ2MTZzX3Byb2JlKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+PiArew0K
Pj4gKyAgICAgICBpbnQgdmFsLCBpbnRmX3NlbDsNCj4+ICsNCj4+ICsgICAgICAgdmFsID0gYmNt
X3BoeV9yZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0WFhfU0hEX01PREUpOw0KPj4gKyAgICAgICBp
ZiAodmFsIDwgMCkNCj4+ICsgICAgICAgICAgICAgICByZXR1cm4gdmFsOw0KPj4gKw0KPj4gKyAg
ICAgICAvKiBUaGUgUEhZIGlzIHN0cmFwcGVkIGluIFJHTUlJIHRvIGZpYmVyIG1vZGUgd2hlbiBJ
TlRFUkZfU0VMWzE6MF0NCj4+ICsgICAgICAgICogaXMgMDFiLg0KPj4gKyAgICAgICAgKi8NCj4+
ICsgICAgICAgaW50Zl9zZWwgPSAodmFsICYgQkNNNTRYWF9TSERfSU5URl9TRUxfTUFTSykgPj4g
MTsNCj4+ICsgICAgICAgaWYgKGludGZfc2VsID09IDEpIHsNCj4+ICsgICAgICAgICAgICAgICB2
YWwgPSBiY21fcGh5X3JlYWRfc2hhZG93KHBoeWRldiwgQkNNNTQ2MTZTX1NIRF8xMDBGWF9DVFJM
KTsNCj4+ICsgICAgICAgICAgICAgICBpZiAodmFsIDwgMCkNCj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiB2YWw7DQo+PiArDQo+PiArICAgICAgICAgICAgICAgLyogQml0IDAgb2Yg
dGhlIFNlckRlcyAxMDAtRlggQ29udHJvbCByZWdpc3Rlciwgd2hlbiBzZXQNCj4+ICsgICAgICAg
ICAgICAgICAgKiB0byAxLCBzZXRzIHRoZSBNSUkvUkdNSUkgLT4gMTAwQkFTRS1GWCBjb25maWd1
cmF0aW9uLg0KPj4gKyAgICAgICAgICAgICAgICAqIFdoZW4gdGhpcyBiaXQgaXMgc2V0IHRvIDAs
IGl0IHNldHMgdGhlIEdNSUkvUkdNSUkgLT4NCj4+ICsgICAgICAgICAgICAgICAgKiAxMDAwQkFT
RS1YIGNvbmZpZ3VyYXRpb24uDQo+PiArICAgICAgICAgICAgICAgICovDQo+PiArICAgICAgICAg
ICAgICAgaWYgKCEodmFsICYgQkNNNTQ2MTZTXzEwMEZYX01PREUpKQ0KPj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgcGh5ZGV2LT5kZXZfZmxhZ3MgfD0gUEhZX0JDTV9GTEFHU19NT0RFXzEwMDBC
WDsNCj4+ICsgICAgICAgfQ0KPj4gKw0KPj4gKyAgICAgICByZXR1cm4gMDsNCj4+ICt9DQo+PiAr
DQo+PiAgc3RhdGljIGludCBicmNtX3BoeV9zZXRiaXRzKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlk
ZXYsIGludCByZWcsIGludCBzZXQpDQo+PiAgew0KPj4gICAgICAgICBpbnQgdmFsOw0KPj4gQEAg
LTY1NSw2ICs2ODQsOCBAQCBzdGF0aWMgc3RydWN0IHBoeV9kcml2ZXIgYnJvYWRjb21fZHJpdmVy
c1tdID0gew0KPj4gICAgICAgICAuY29uZmlnX2FuZWcgICAgPSBiY201NDYxNnNfY29uZmlnX2Fu
ZWcsDQo+PiAgICAgICAgIC5hY2tfaW50ZXJydXB0ICA9IGJjbV9waHlfYWNrX2ludHIsDQo+PiAg
ICAgICAgIC5jb25maWdfaW50ciAgICA9IGJjbV9waHlfY29uZmlnX2ludHIsDQo+PiArICAgICAg
IC5yZWFkX3N0YXR1cyAgICA9IGJjbTU0eHhfcmVhZF9zdGF0dXMsDQo+PiArICAgICAgIC5wcm9i
ZSAgICAgICAgICA9IGJjbTU0NjE2c19wcm9iZSwNCj4+ICB9LCB7DQo+PiAgICAgICAgIC5waHlf
aWQgICAgICAgICA9IFBIWV9JRF9CQ001NDY0LA0KPj4gICAgICAgICAucGh5X2lkX21hc2sgICAg
PSAweGZmZmZmZmYwLA0KPj4gQEAgLTY4OSw3ICs3MjAsNyBAQCBzdGF0aWMgc3RydWN0IHBoeV9k
cml2ZXIgYnJvYWRjb21fZHJpdmVyc1tdID0gew0KPj4gICAgICAgICAubmFtZSAgICAgICAgICAg
PSAiQnJvYWRjb20gQkNNNTQ4MiIsDQo+PiAgICAgICAgIC8qIFBIWV9HQklUX0ZFQVRVUkVTICov
DQo+PiAgICAgICAgIC5jb25maWdfaW5pdCAgICA9IGJjbTU0ODJfY29uZmlnX2luaXQsDQo+PiAt
ICAgICAgIC5yZWFkX3N0YXR1cyAgICA9IGJjbTU0ODJfcmVhZF9zdGF0dXMsDQo+PiArICAgICAg
IC5yZWFkX3N0YXR1cyAgICA9IGJjbTU0eHhfcmVhZF9zdGF0dXMsDQo+PiAgICAgICAgIC5hY2tf
aW50ZXJydXB0ICA9IGJjbV9waHlfYWNrX2ludHIsDQo+PiAgICAgICAgIC5jb25maWdfaW50ciAg
ICA9IGJjbV9waHlfY29uZmlnX2ludHIsDQo+PiAgfSwgew0KPj4gZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvYnJjbXBoeS5oIGIvaW5jbHVkZS9saW51eC9icmNtcGh5LmgNCj4+IGluZGV4IDZk
YjJkOWE2ZTUwMy4uYjQ3NWU3ZjIwZDI4IDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS9saW51eC9i
cmNtcGh5LmgNCj4+ICsrKyBiL2luY2x1ZGUvbGludXgvYnJjbXBoeS5oDQo+PiBAQCAtMjAwLDkg
KzIwMCwxNSBAQA0KPj4gICNkZWZpbmUgQkNNNTQ4Ml9TSERfU1NEICAgICAgICAgICAgICAgIDB4
MTQgICAgLyogMTAxMDA6IFNlY29uZGFyeSBTZXJEZXMgY29udHJvbCAqLw0KPj4gICNkZWZpbmUg
QkNNNTQ4Ml9TSERfU1NEX0xFRE0gICAweDAwMDggIC8qIFNTRCBMRUQgTW9kZSBlbmFibGUgKi8N
Cj4+ICAjZGVmaW5lIEJDTTU0ODJfU0hEX1NTRF9FTiAgICAgMHgwMDAxICAvKiBTU0QgZW5hYmxl
ICovDQo+PiAtI2RlZmluZSBCQ001NDgyX1NIRF9NT0RFICAgICAgIDB4MWYgICAgLyogMTExMTE6
IE1vZGUgQ29udHJvbCBSZWdpc3RlciAqLw0KPj4gLSNkZWZpbmUgQkNNNTQ4Ml9TSERfTU9ERV8x
MDAwQlggICAgICAgIDB4MDAwMSAgLyogRW5hYmxlIDEwMDBCQVNFLVggcmVnaXN0ZXJzICovDQo+
Pg0KPj4gKy8qIDEwMDExOiBTZXJEZXMgMTAwLUZYIENvbnRyb2wgUmVnaXN0ZXIgKi8NCj4+ICsj
ZGVmaW5lIEJDTTU0NjE2U19TSERfMTAwRlhfQ1RSTCAgICAgICAweDEzDQo+PiArI2RlZmluZSAg
ICAgICAgQkNNNTQ2MTZTXzEwMEZYX01PREUgICAgICAgICAgICBCSVQoMCkgIC8qIDEwMC1GWCBT
ZXJEZXMgRW5hYmxlICovDQo+PiArDQo+PiArLyogMTExMTE6IE1vZGUgQ29udHJvbCBSZWdpc3Rl
ciAqLw0KPj4gKyNkZWZpbmUgQkNNNTRYWF9TSERfTU9ERSAgICAgICAgICAgICAgIDB4MWYNCj4+
ICsjZGVmaW5lIEJDTTU0WFhfU0hEX0lOVEZfU0VMX01BU0sgICAgICBHRU5NQVNLKDIsIDEpICAg
LyogSU5URVJGX1NFTFsxOjBdICovDQo+PiArI2RlZmluZSBCQ001NFhYX1NIRF9NT0RFXzEwMDBC
WCAgICAgICAgICAgICAgICBCSVQoMCkgIC8qIEVuYWJsZSAxMDAwLVggcmVnaXN0ZXJzICovDQo+
Pg0KPj4gIC8qDQo+PiAgICogRVhQQU5TSU9OIFNIQURPVyBBQ0NFU1MgUkVHSVNURVJTLiAgKFBI
WSBSRUcgMHgxNSwgMHgxNiwgYW5kIDB4MTcpDQo+PiAtLQ0KPj4gMi4xNy4xDQo+Pg0KPiANCj4g
VGhlIHBhdGNoc2V0IGxvb2tzIGJldHRlciBub3cuIEJ1dCBpcyBpdCBvaywgSSB3b25kZXIsIHRv
IGtlZXANCj4gUEhZX0JDTV9GTEFHU19NT0RFXzEwMDBCWCBpbiBwaHlkZXYtPmRldl9mbGFncywg
Y29uc2lkZXJpbmcgdGhhdA0KPiBwaHlfYXR0YWNoX2RpcmVjdCBpcyBvdmVyd3JpdGluZyBpdD8N
Cg0KSSBjaGVja2VkIGZ0Z21hYzEwMCBkcml2ZXIgKHVzZWQgb24gbXkgbWFjaGluZSkgYW5kIGl0
IGNhbGxzIHBoeV9jb25uZWN0X2RpcmVjdCB3aGljaCBwYXNzZXMgcGh5ZGV2LT5kZXZfZmxhZ3Mg
d2hlbiBjYWxsaW5nIHBoeV9hdHRhY2hfZGlyZWN0OiB0aGF0IGV4cGxhaW5zIHdoeSB0aGUgZmxh
ZyBpcyBub3QgY2xlYXJlZCBpbiBteSBjYXNlLg0KDQpDYW4geW91IGdpdmUgbWUgc29tZSBzdWdn
ZXN0aW9ucyBzaW5jZSBkZXZfZmxhZ3MgbWF5IGJlIG92ZXJyaWRlIGluIG90aGVyIGNhbGxpbmcg
cGF0aHM/IEZvciBleGFtcGxlLCBpcyBpdCBnb29kIGlkZWEgdG8gbW92ZSB0aGUgYXV0by1kZXRl
Y3QgbG9naWMgZnJvbSBwcm9iZSB0byBjb25maWdfaW5pdD8gT3IgYXJlIHRoZXJlIG90aGVyIGZp
ZWxkcyBpbiBwaHlfZGV2aWNlIHN0cnVjdHVyZSB0aGF0IGNhbiBiZSB1c2VkIHRvIHN0b3JlIFBI
WS1zd2l0Y2ggbGluayB0eXBlPyBPciBtYXliZSBJIHNob3VsZCBqdXN0IGluY2x1ZGUgdGhlIGF1
dG8tZGV0ZWN0IGxvZ2ljIGluIHJlYWRfc3RhdHVzIGNhbGxiYWNrPw0KDQoNClRoYW5rcywNCg0K
VGFvDQo=
