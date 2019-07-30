Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5AE87A021
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 06:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbfG3ExA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 00:53:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48046 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728401AbfG3ExA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 00:53:00 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6U4nMdV013212;
        Mon, 29 Jul 2019 21:52:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nWqR+LfUdH/JW8UKiFnoiNAQSecWlQWODXLddqJ1MKg=;
 b=TNkmwdPouYOSJgsnWxnKKOfdCOikwhAKNOwNrO6bEnnuIpzzk1feD9DS+a0nf57x1X+/
 Hupl26JVAg/sfKn2gIi03HmlIK1CTSWKFuJ1S31ONpPZj+LMxwr92ULzEd00vxR4+lwj
 vcrINcbCT7UmVZJ7zKHl0CtYsrP6vQtgY4c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u27kwhdcr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jul 2019 21:52:40 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jul 2019 21:52:39 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jul 2019 21:52:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0BmFyzG/n6LZHhLqCyPjjwDv8+75pfra5Wxej4jFZxIdqkn45PHlEvgDtBgX2clsAN7ww7ADmf3UVX6KMn5iZ4MyJ+evvbGJZebOFVj5N+Kshlb2ru/W4MnQRcvRNoa3JrURNVHY2Q7/MFLPmsS3k58JMqnXinn+nnb7FwKmljrLRgC2qJKDn6oKCQ6+4u9Rbyos56y9rVWIla1r6WYHDhf1wqTqWP9iHm5EIcJkAVYh2hpzJT1RMQNMu4iIw0sej3h86NZWRFtdooUMdf/rKMiKi+NrOa4VOUvaTHFtcAljWanrZF1XqzryypnIv8dWUnN2apoS2h3a1Pr+D4U2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWqR+LfUdH/JW8UKiFnoiNAQSecWlQWODXLddqJ1MKg=;
 b=aFh9AJLmsKwEMGq6M/mJ+AA/sWVoQwIh1EFowMQWZvhPlyBuv9AzJuXcJhx1q4GpjUiZHGhVhAtvNNHlLPtGtTazdKpBLGBcdCqqe338MU0Iv3AfZfJbfUAEFijNTnGbGum5hKM8wI1dFCH83vkqnxzHbBwZXR3IGk0fj+dJRQmB+R6XNVnQNeBsatH+1KRVMFbCO94Kh3yZzl+y/yHfiNhKgE1CZTlizdEGsVAwrEuWzQeK5hWkAjovnYTmvI78VltqNVUF2uU68Bm/csEeiov/Bh1XFup6ZrbumVQkVp6tSvwey3SBfQP460QZmCbTDRpa3zMB+AUnol+UFaLhJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWqR+LfUdH/JW8UKiFnoiNAQSecWlQWODXLddqJ1MKg=;
 b=c0qsctZWIUri1LX2J1hIx2I9qWJn/A+rAqfoZV7+xvKVY8P6RedDdGTJQ47jEFA9u75aZx8oXu/OaIjr3CZtRDu70uabiakH+SqvBhkjdlA6WBzvcmHtMNBRFqMtyx8bHINOeO0Z8AIGLntCQwUE83uAoya+89NtI/WSxukwBU0=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1901.namprd15.prod.outlook.com (10.174.99.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 04:52:37 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c%8]) with mapi id 15.20.2136.010; Tue, 30 Jul 2019
 04:52:37 +0000
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
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Topic: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Index: AQHVRm4oHxOo2s4k1kyYCsigpkISsabiYHeAgAA34AA=
Date:   Tue, 30 Jul 2019 04:52:37 +0000
Message-ID: <3987251b-9679-dfbe-6e15-f991c2893bac@fb.com>
References: <20190730002549.86824-1-taoren@fb.com>
 <CA+h21hq1+E6-ScFx425hXwTPTZHTVZbBuAm7RROFZTBOFvD8vQ@mail.gmail.com>
In-Reply-To: <CA+h21hq1+E6-ScFx425hXwTPTZHTVZbBuAm7RROFZTBOFvD8vQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0053.namprd15.prod.outlook.com
 (2603:10b6:101:1f::21) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:a8ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afbf9065-b1a9-48ef-5383-08d714a9be89
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1901;
x-ms-traffictypediagnostic: MWHPR15MB1901:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR15MB1901E8A29AD96A0AC119E816B2DC0@MWHPR15MB1901.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(136003)(346002)(376002)(396003)(43544003)(189003)(199004)(6486002)(8676002)(478600001)(81156014)(68736007)(8936002)(81166006)(65956001)(71190400001)(71200400001)(14444005)(256004)(1411001)(486006)(6916009)(31686004)(86362001)(5660300002)(229853002)(65806001)(64126003)(6436002)(2906002)(52116002)(966005)(53546011)(99286004)(6506007)(386003)(36756003)(54906003)(316002)(25786009)(305945005)(58126008)(6306002)(76176011)(66446008)(6512007)(53936002)(64756008)(66556008)(66476007)(65826007)(14454004)(31696002)(7416002)(102836004)(186003)(66946007)(7736002)(446003)(46003)(2616005)(11346002)(6246003)(6116002)(476003)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1901;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LtoT295bfAt3ZhKYeXEQUzD5PVM1YGYaEJOo3tOGHhF5SPzW/ZooBwr5Q9FzCpbcK2xcvXjnIPDcK10ax4ptul9Qkb0N8eTQeg+R80R1MwKINV40EKEd0doXMCdR2byVRS+fuQIDhmyZQhB+zAQNALnGliKjUAhLQs0KWvhnQaD9CoRxS/VsdPchoRKKAhsinS82zpPik3tuuPL/FVnwgKlHlmbAox8yxmswYuOT5pD7REN5wAmDDRBA2FjnvYuRgOJbxJwfhB3mXJHMWusbg282THzv2SqCa6qdubc1//PGTdueXTm8V14X+Hgp6r8tLNJcCRau/AqUIdXQjNSK8IFp5R3wmLRZiRhYW5ndBVGZ9OgJqT+QYnxZwPXJrfeP+Myw6qb69CUSlKP7Xv0TS2tkavBoDJd6WdbLF+wB3W0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D66EC4BF942BE9478DC81497A95A9872@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: afbf9065-b1a9-48ef-5383-08d714a9be89
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 04:52:37.6815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1901
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8yOS8xOSA2OjMyIFBNLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+IEhpIFRhbywNCj4g
DQo+IE9uIFR1ZSwgMzAgSnVsIDIwMTkgYXQgMDM6MzEsIFRhbyBSZW4gPHRhb3JlbkBmYi5jb20+
IHdyb3RlOg0KPj4NCj4+IENvbmZpZ3VyZSB0aGUgQkNNNTQ2MTZTIGZvciAxMDAwQmFzZS1YIG1v
ZGUgd2hlbiAiYnJjbS1waHktbW9kZS0xMDAwYngiDQo+PiBpcyBzZXQgaW4gZGV2aWNlIHRyZWUu
IFRoaXMgaXMgbmVlZGVkIHdoZW4gdGhlIFBIWSBpcyB1c2VkIGZvciBmaWJlciBhbmQNCj4+IGJh
Y2twbGFuZSBjb25uZWN0aW9ucy4NCj4+DQo+PiBUaGUgcGF0Y2ggaXMgaW5zcGlyZWQgYnkgY29t
bWl0IGNkOWFmM2RhYzZkMSAoIlBIWUxJQjogQWRkIDEwMDBCYXNlLVgNCj4+IHN1cHBvcnQgZm9y
IEJyb2FkY29tIGJjbTU0ODIiKS4NCj4gDQo+IEFzIGZhciBhcyBJIGNhbiBzZWUsIGZvciB0aGUg
Y29tbWl0IHlvdSByZWZlcmVuY2VkLA0KPiBQSFlfQkNNX0ZMQUdTX01PREVfMTAwMEJYIGlzIHJl
ZmVyZW5jZWQgZnJvbSBub3doZXJlIGluIHRoZSBlbnRpcmUNCj4gbWFpbmxpbmUga2VybmVsOg0K
PiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2Vs
aXhpci5ib290bGluLmNvbV9saW51eF9sYXRlc3RfaWRlbnRfUEhZLTVGQkNNLTVGRkxBR1MtNUZN
T0RFLTVGMTAwMEJYJmQ9RHdJQmFRJmM9NVZEMFJUdE5sVGgzeWNkNDFiM01VdyZyPWlZRWxUN0hD
NzdwUlozYnlWdlc4bmcmbT1neTZZLTNZbG1lLV9HUWNHRjRmdk9YMTBpcmdBVDR4aDI1M1dlbzBu
cDM4JnM9S0xfX0UyYnZzbXZVTC1oQkw5aFVtT1M1dnlQUTkyRU1qNmZFZkJ5bjh0OCZlPSANCj4g
KGl0IGlzIHN1cHBvc2VkIHRvIGJlIHB1dCBieSB0aGUgTUFDIGRyaXZlciBpbiBwaHlkZXYtPmRl
dl9mbGFncyBwcmlvcg0KPiB0byBjYWxsaW5nIHBoeV9jb25uZWN0KS4gQnV0IEkgZG9uJ3Qgc2Vl
IHRoZSBwb2ludCB0byB0aGlzIC0gY2FuJ3QgeW91DQo+IGNoZWNrIGZvciBwaHlkZXYtPmludGVy
ZmFjZSA9PSBQSFlfSU5URVJGQUNFX01PREVfMTAwMEJBU0VYPw0KPiBUaGlzIGhhcyB0aGUgYWR2
YW50YWdlIHRoYXQgbm8gTUFDIGRyaXZlciB3aWxsIG5lZWQgdG8ga25vdyB0aGF0IGl0J3MNCj4g
dGFsa2luZyB0byBhIEJyb2FkY29tIFBIWS4gQWRkaXRpb25hbGx5LCBubyBjdXN0b20gRFQgYmlu
ZGluZ3MgYXJlDQo+IG5lZWRlZC4NCj4gQWxzbywgZm9yIGJhY2twbGFuZSBjb25uZWN0aW9ucyB5
b3UgcHJvYmFibHkgd2FudCAxMDAwQmFzZS1LWCB3aGljaA0KPiBoYXMgaXRzIG93biBBTi9MVCwg
bm90IHBsYWluIDEwMDBCYXNlLVguDQoNClRoYW5rIHlvdSBWbGFkaW1pciBmb3IgdGhlIHF1aWNr
IHJldmlldyENClBlcmhhcHMgSSBtaXN1bmRlcnN0b29kIHRoZSBwdXJwb3NlIG9mIHBoeWRldi0+
aW50ZXJmYWNlLCBhbmQgSSB0aG91Z2h0IGl0IHdhcyB1c3VhbGx5IHVzZWQgdG8gZGVmaW5lZCB0
aGUgaW50ZXJmYWNlIGJldHdlZW4gTUFDIGFuZCBQSFkuIEZvciBleGFtcGxlLCBpZiBJIG5lZWQg
dG8gcGFzcyBib3RoICJyZ21paS1pZCIgYW5kICIxMDAwYmFzZS14IiBmcm9tIE1BQyB0byBQSFkg
ZHJpdmVyLCB3aGF0IHdvdWxkIGJlIHRoZSBwcmVmZXJyZWQgd2F5Pw0KDQo+PiBTaWduZWQtb2Zm
LWJ5OiBUYW8gUmVuIDx0YW9yZW5AZmIuY29tPg0KPj4gLS0tDQo+PiAgZHJpdmVycy9uZXQvcGh5
L2Jyb2FkY29tLmMgfCA1OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLQ0K
Pj4gIGluY2x1ZGUvbGludXgvYnJjbXBoeS5oICAgIHwgIDQgKy0tDQo+PiAgMiBmaWxlcyBjaGFu
Z2VkLCA1NiBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9waHkvYnJvYWRjb20uYyBiL2RyaXZlcnMvbmV0L3BoeS9icm9hZGNvbS5j
DQo+PiBpbmRleCAyYjRlNDFhOWQzNWEuLjZjMjJhYzNhODQ0YiAxMDA2NDQNCj4+IC0tLSBhL2Ry
aXZlcnMvbmV0L3BoeS9icm9hZGNvbS5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9waHkvYnJvYWRj
b20uYw0KPj4gQEAgLTM4Myw5ICszODMsOSBAQCBzdGF0aWMgaW50IGJjbTU0ODJfY29uZmlnX2lu
aXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+ICAgICAgICAgICAgICAgICAvKg0KPj4g
ICAgICAgICAgICAgICAgICAqIFNlbGVjdCAxMDAwQkFTRS1YIHJlZ2lzdGVyIHNldCAocHJpbWFy
eSBTZXJEZXMpDQo+PiAgICAgICAgICAgICAgICAgICovDQo+PiAtICAgICAgICAgICAgICAgcmVn
ID0gYmNtX3BoeV9yZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0ODJfU0hEX01PREUpOw0KPj4gLSAg
ICAgICAgICAgICAgIGJjbV9waHlfd3JpdGVfc2hhZG93KHBoeWRldiwgQkNNNTQ4Ml9TSERfTU9E
RSwNCj4+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZWcgfCBCQ001NDgy
X1NIRF9NT0RFXzEwMDBCWCk7DQo+PiArICAgICAgICAgICAgICAgcmVnID0gYmNtX3BoeV9yZWFk
X3NoYWRvdyhwaHlkZXYsIEJDTTU0WFhfU0hEX01PREUpOw0KPj4gKyAgICAgICAgICAgICAgIGJj
bV9waHlfd3JpdGVfc2hhZG93KHBoeWRldiwgQkNNNTRYWF9TSERfTU9ERSwNCj4+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZWcgfCBCQ001NFhYX1NIRF9NT0RFXzEwMDBC
WCk7DQo+Pg0KPj4gICAgICAgICAgICAgICAgIC8qDQo+PiAgICAgICAgICAgICAgICAgICogTEVE
MT1BQ1RJVklUWUxFRCwgTEVEMz1MSU5LU1BEWzJdDQo+PiBAQCAtNDUxLDYgKzQ1MSwzNCBAQCBz
dGF0aWMgaW50IGJjbTU0ODFfY29uZmlnX2FuZWcoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikN
Cj4+ICAgICAgICAgcmV0dXJuIHJldDsNCj4+ICB9DQo+Pg0KPj4gK3N0YXRpYyBpbnQgYmNtNTQ2
MTZzX2NvbmZpZ19pbml0KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+PiArew0KPj4gKyAg
ICAgICBpbnQgZXJyLCByZWc7DQo+PiArICAgICAgIHN0cnVjdCBkZXZpY2Vfbm9kZSAqbnAgPSBw
aHlkZXYtPm1kaW8uZGV2Lm9mX25vZGU7DQo+PiArDQo+PiArICAgICAgIGVyciA9IGJjbTU0eHhf
Y29uZmlnX2luaXQocGh5ZGV2KTsNCj4+ICsNCj4+ICsgICAgICAgaWYgKG9mX3Byb3BlcnR5X3Jl
YWRfYm9vbChucCwgImJyY20tcGh5LW1vZGUtMTAwMGJ4IikpIHsNCj4+ICsgICAgICAgICAgICAg
ICAvKiBTZWxlY3QgMTAwMEJBU0UtWCByZWdpc3RlciBzZXQuICovDQo+PiArICAgICAgICAgICAg
ICAgcmVnID0gYmNtX3BoeV9yZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0WFhfU0hEX01PREUpOw0K
Pj4gKyAgICAgICAgICAgICAgIGJjbV9waHlfd3JpdGVfc2hhZG93KHBoeWRldiwgQkNNNTRYWF9T
SERfTU9ERSwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZWcgfCBC
Q001NFhYX1NIRF9NT0RFXzEwMDBCWCk7DQo+PiArDQo+PiArICAgICAgICAgICAgICAgLyogQXV0
by1uZWdvdGlhdGlvbiBkb2Vzbid0IHNlZW0gdG8gd29yayBxdWl0ZSByaWdodA0KPj4gKyAgICAg
ICAgICAgICAgICAqIGluIHRoaXMgbW9kZSwgc28gd2UgZGlzYWJsZSBpdCBhbmQgZm9yY2UgaXQg
dG8gdGhlDQo+PiArICAgICAgICAgICAgICAgICogcmlnaHQgc3BlZWQvZHVwbGV4IHNldHRpbmcu
ICBPbmx5ICdsaW5rIHN0YXR1cycNCj4+ICsgICAgICAgICAgICAgICAgKiBpcyBpbXBvcnRhbnQu
DQo+PiArICAgICAgICAgICAgICAgICovDQo+PiArICAgICAgICAgICAgICAgcGh5ZGV2LT5hdXRv
bmVnID0gQVVUT05FR19ESVNBQkxFOw0KPj4gKyAgICAgICAgICAgICAgIHBoeWRldi0+c3BlZWQg
PSBTUEVFRF8xMDAwOw0KPj4gKyAgICAgICAgICAgICAgIHBoeWRldi0+ZHVwbGV4ID0gRFVQTEVY
X0ZVTEw7DQo+PiArDQo+IA0KPiAxMDAwQmFzZS1YIEFOIGRvZXMgbm90IGluY2x1ZGUgc3BlZWQg
bmVnb3RpYXRpb24sIHNvIGhhcmRjb2RpbmcNCj4gU1BFRURfMTAwMCBpcyBwcm9iYWJseSBjb3Jy
ZWN0Lg0KPiBXaGF0IGlzIHdyb25nIHdpdGggdGhlIEFOIG9mIGR1cGxleCBzZXR0aW5ncz8NCg0K
RlVMTF9EVVBMRVggYml0IGlzIHNldCBvbiBteSBwbGF0Zm9ybSBieSBkZWZhdWx0LiBMZXQgbWUg
ZW5hYmxlIEFOIGFuZCB0ZXN0IGl0IG91dDsgd2lsbCBzaGFyZSB5b3UgcmVzdWx0cyB0b21vcnJv
dy4NCg0KPj4gKyAgICAgICAgICAgICAgIHBoeWRldi0+ZGV2X2ZsYWdzIHw9IFBIWV9CQ01fRkxB
R1NfTU9ERV8xMDAwQlg7DQo+PiArICAgICAgIH0NCj4+ICsNCj4+ICsgICAgICAgcmV0dXJuIGVy
cjsNCj4+ICt9DQo+PiArDQo+PiAgc3RhdGljIGludCBiY201NDYxNnNfY29uZmlnX2FuZWcoc3Ry
dWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+ICB7DQo+PiAgICAgICAgIGludCByZXQ7DQo+PiBA
QCAtNDY0LDYgKzQ5MiwyNyBAQCBzdGF0aWMgaW50IGJjbTU0NjE2c19jb25maWdfYW5lZyhzdHJ1
Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPj4gICAgICAgICByZXR1cm4gcmV0Ow0KPj4gIH0NCj4+
DQo+PiArc3RhdGljIGludCBiY201NDYxNnNfcmVhZF9zdGF0dXMoc3RydWN0IHBoeV9kZXZpY2Ug
KnBoeWRldikNCj4+ICt7DQo+PiArICAgICAgIGludCByZXQ7DQo+PiArDQo+PiArICAgICAgIHJl
dCA9IGdlbnBoeV9yZWFkX3N0YXR1cyhwaHlkZXYpOw0KPj4gKyAgICAgICBpZiAocmV0IDwgMCkN
Cj4+ICsgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPj4gKw0KPj4gKyAgICAgICBpZiAocGh5
ZGV2LT5kZXZfZmxhZ3MgJiBQSFlfQkNNX0ZMQUdTX01PREVfMTAwMEJYKSB7DQo+PiArICAgICAg
ICAgICAgICAgLyogT25seSBsaW5rIHN0YXR1cyBtYXR0ZXJzIGZvciAxMDAwQmFzZS1YIG1vZGUs
IHNvIGZvcmNlDQo+PiArICAgICAgICAgICAgICAgICogMTAwMCBNYml0L3MgZnVsbC1kdXBsZXgg
c3RhdHVzLg0KPj4gKyAgICAgICAgICAgICAgICAqLw0KPj4gKyAgICAgICAgICAgICAgIGlmIChw
aHlkZXYtPmxpbmspIHsNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHBoeWRldi0+c3BlZWQg
PSBTUEVFRF8xMDAwOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgcGh5ZGV2LT5kdXBsZXgg
PSBEVVBMRVhfRlVMTDsNCj4+ICsgICAgICAgICAgICAgICB9DQo+PiArICAgICAgIH0NCj4+ICsN
Cj4+ICsgICAgICAgcmV0dXJuIDA7DQo+PiArfQ0KPj4gKw0KPj4gIHN0YXRpYyBpbnQgYnJjbV9w
aHlfc2V0Yml0cyhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2LCBpbnQgcmVnLCBpbnQgc2V0KQ0K
Pj4gIHsNCj4+ICAgICAgICAgaW50IHZhbDsNCj4+IEBAIC02NTEsOCArNzAwLDkgQEAgc3RhdGlj
IHN0cnVjdCBwaHlfZHJpdmVyIGJyb2FkY29tX2RyaXZlcnNbXSA9IHsNCj4+ICAgICAgICAgLnBo
eV9pZF9tYXNrICAgID0gMHhmZmZmZmZmMCwNCj4+ICAgICAgICAgLm5hbWUgICAgICAgICAgID0g
IkJyb2FkY29tIEJDTTU0NjE2UyIsDQo+PiAgICAgICAgIC5mZWF0dXJlcyAgICAgICA9IFBIWV9H
QklUX0ZFQVRVUkVTLA0KPj4gLSAgICAgICAuY29uZmlnX2luaXQgICAgPSBiY201NHh4X2NvbmZp
Z19pbml0LA0KPj4gKyAgICAgICAuY29uZmlnX2luaXQgICAgPSBiY201NDYxNnNfY29uZmlnX2lu
aXQsDQo+PiAgICAgICAgIC5jb25maWdfYW5lZyAgICA9IGJjbTU0NjE2c19jb25maWdfYW5lZywN
Cj4+ICsgICAgICAgLnJlYWRfc3RhdHVzICAgID0gYmNtNTQ2MTZzX3JlYWRfc3RhdHVzLA0KPj4g
ICAgICAgICAuYWNrX2ludGVycnVwdCAgPSBiY21fcGh5X2Fja19pbnRyLA0KPj4gICAgICAgICAu
Y29uZmlnX2ludHIgICAgPSBiY21fcGh5X2NvbmZpZ19pbnRyLA0KPj4gIH0sIHsNCj4+IGRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L2JyY21waHkuaCBiL2luY2x1ZGUvbGludXgvYnJjbXBoeS5o
DQo+PiBpbmRleCA2ZGIyZDlhNmU1MDMuLjgyMDMwMTU1NTU4YyAxMDA2NDQNCj4+IC0tLSBhL2lu
Y2x1ZGUvbGludXgvYnJjbXBoeS5oDQo+PiArKysgYi9pbmNsdWRlL2xpbnV4L2JyY21waHkuaA0K
Pj4gQEAgLTIwMCw4ICsyMDAsOCBAQA0KPj4gICNkZWZpbmUgQkNNNTQ4Ml9TSERfU1NEICAgICAg
ICAgICAgICAgIDB4MTQgICAgLyogMTAxMDA6IFNlY29uZGFyeSBTZXJEZXMgY29udHJvbCAqLw0K
Pj4gICNkZWZpbmUgQkNNNTQ4Ml9TSERfU1NEX0xFRE0gICAweDAwMDggIC8qIFNTRCBMRUQgTW9k
ZSBlbmFibGUgKi8NCj4+ICAjZGVmaW5lIEJDTTU0ODJfU0hEX1NTRF9FTiAgICAgMHgwMDAxICAv
KiBTU0QgZW5hYmxlICovDQo+PiAtI2RlZmluZSBCQ001NDgyX1NIRF9NT0RFICAgICAgIDB4MWYg
ICAgLyogMTExMTE6IE1vZGUgQ29udHJvbCBSZWdpc3RlciAqLw0KPj4gLSNkZWZpbmUgQkNNNTQ4
Ml9TSERfTU9ERV8xMDAwQlggICAgICAgIDB4MDAwMSAgLyogRW5hYmxlIDEwMDBCQVNFLVggcmVn
aXN0ZXJzICovDQo+PiArI2RlZmluZSBCQ001NFhYX1NIRF9NT0RFICAgICAgIDB4MWYgICAgLyog
MTExMTE6IE1vZGUgQ29udHJvbCBSZWdpc3RlciAqLw0KPj4gKyNkZWZpbmUgQkNNNTRYWF9TSERf
TU9ERV8xMDAwQlggICAgICAgIDB4MDAwMSAgLyogRW5hYmxlIDEwMDBCQVNFLVggcmVnaXN0ZXJz
ICovDQo+IA0KPiBUaGVzZSByZWdpc3RlcnMgYXJlIGFsc28gcHJlc2VudCBvbiBteSBCQ001NDY0
LCBwcm9iYWJseSBzYWZlIHRvDQo+IGFzc3VtZSB0aGV5J3JlIGdlbmVyaWMgZm9yIHRoZSBlbnRp
cmUgZmFtaWx5Lg0KPiBTbyBpZiB5b3UgbWFrZSB0aGUgcmVnaXN0ZXJzIGRlZmluaXRpb25zIGNv
bW1vbiwgeW91IGNhbiBwcm9iYWJseSBtYWtlDQo+IHRoZSAxMDAwQmFzZS1YIGNvbmZpZ3VyYXRp
b24gY29tbW9uIGFzIHdlbGwuDQoNCklmIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHksIHlvdXIgcmVj
b21tZW5kYXRpb24gaXMgdG8gYWRkIGEgY29tbW9uIGZ1bmN0aW9uIChzdWNoIGFzICJiY201NHh4
X2NvbmZpZ18xMDAwYngiKSBzbyBpdCBjYW4gYmUgdXNlZCBieSBvdGhlciBCQ00gY2hpcHM/IFN1
cmUsIEkgd2lsbCB0YWtlIGNhcmUgb2YgaXQuDQoNCg0KVGhhbmtzLA0KDQpUYW8NCg==
