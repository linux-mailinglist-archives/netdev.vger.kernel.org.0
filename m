Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65DFDB4F13
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 15:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfIQNYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 09:24:39 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:46094 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727875AbfIQNYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 09:24:39 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8HDHilF029688;
        Tue, 17 Sep 2019 09:24:28 -0400
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2054.outbound.protection.outlook.com [104.47.42.54])
        by mx0a-00128a01.pphosted.com with ESMTP id 2v0w47ngfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 09:24:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvM03NGJ9sITPtzGv6p9DC3CVCVlj3bpKP56Qik6qR7FkeXpedCeaTeJ90KDdGsTH16ajvl5sAZ4ODrWkiIk3CVBuOg8G8OYo4AodYQNj6mtlyyyzgXkEuYoMBDGWY3XxPa2nC1WIWNmA/PAEpEWdjHrWQwmeqfbr5GFKmhkqOrksC3iBvH72XmCffbptXSvk1W9SWk8xGlsRa0hv65HzgrxyeZk3CReUA/fWo6ytv35MBr+b3q6SpBLmETKbWLdRUeBVzmCYGgIgvRgMgWexIUCfxlaBjkQKTj9xmnTOpwZHY5M8wGB0YM5EIdJ+hMKAi5pKV6ulPoasAfVAZUXCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOMtSM7BqPhmf1hVqHLxqlulfY6ipM2rRT1wT8LHBCI=;
 b=WahWvxZSf1E098i2Wfr4wNRsQmD14LUiwT8oqdTjSEKN9gN+qRUrxDSurnvJXpFpp1VVylL4Xl1vFvVkWOEvTYSxu0V1IplAUz6Bv1TShpBS6pNedt5Zr/VL/g+Mw4qf92OzBjL9ZvgpORpR+nbcXKz6kN4vXfYD3eLEdi9aH6kJMQjacbHXtvHUtSus6oTJJTkhewROK9BH3tVyM7bu7HzxlK29qCgHhQgz9Bq61MUGTzAeWyt+VHAI3XdEh+XWzbQCi2pJ5ojmRqt6qMDS/QVZrUMCMR1ayiGKQPKnftbgAEoZ7nmA9oQnxb6zeBLJNGHZ4IWYUmCYSOIQJjdInQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOMtSM7BqPhmf1hVqHLxqlulfY6ipM2rRT1wT8LHBCI=;
 b=Z212gLcUCLTS0zr9LJb4qEYWKay4lnCbVh+ilu6U4QYV7cipt+3JKPYok7l8LKPhlqAAjezfQyjXtPYwmAixhuSPFIGfOM8hb9gCeAqwQeuC/ImLZSV49RJxc/wx4jPY+QyIZtSjmG7sCQG2mgD4T9fO1qTU1qOl7bYgUdh+rW8=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5253.namprd03.prod.outlook.com (20.180.14.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Tue, 17 Sep 2019 13:24:27 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b%3]) with mapi id 15.20.2284.009; Tue, 17 Sep 2019
 13:24:27 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH] dt-bindings: net: dwmac: fix 'mac-mode' type
Thread-Topic: [PATCH] dt-bindings: net: dwmac: fix 'mac-mode' type
Thread-Index: AQHVbSndCzmJmrw9p02q7VSxl3N9q6cv0CMAgAA+RoA=
Date:   Tue, 17 Sep 2019 13:24:27 +0000
Message-ID: <ecb8d9183ebe666c92480dd37ddc21709dd14f76.camel@analog.com>
References: <20190917103052.13456-1-alexandru.ardelean@analog.com>
         <20190917124132.GG20778@lunn.ch>
In-Reply-To: <20190917124132.GG20778@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55af11d1-997c-4cbb-79f4-08d73b725d40
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CH2PR03MB5253;
x-ms-traffictypediagnostic: CH2PR03MB5253:
x-microsoft-antispam-prvs: <CH2PR03MB5253298B6C1BE88E091E35E1F98F0@CH2PR03MB5253.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(376002)(346002)(136003)(51914003)(189003)(199004)(6246003)(2906002)(26005)(86362001)(229853002)(8936002)(6436002)(8676002)(1730700003)(81156014)(81166006)(5640700003)(6486002)(486006)(476003)(2501003)(6116002)(2616005)(71200400001)(3846002)(66066001)(6506007)(71190400001)(36756003)(76176011)(446003)(99286004)(11346002)(2351001)(14454004)(478600001)(5660300002)(6512007)(118296001)(316002)(54906003)(4326008)(102836004)(186003)(25786009)(66946007)(64756008)(66556008)(305945005)(6916009)(7736002)(256004)(66446008)(66476007)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5253;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ugGgFI5fvCVgleruWYPDUZI/3qsbisXIKeVvLqmqo5yx90wLwdVatIHgGnYGSU3lGkwcoB4ylyBN5baTubWQUQT6pr7W0Wm4CE7iEow0k4UGeQv6Pi2eG90bCwH6zXEatxWtbpIpPlinTwZWkRiZoH8dMYld/ihZ/tF6xzv93KzD0WkEermi0yhooFK8qun6Oc2igAvcJGHqRzni7J/d/nkLI7mbN4sne6miTWPXhSNI+jIY7oyIcgiIr6kAo9Oj+5g5NPRTm1ZIRr+TJiaLwmNGFV0HWFCOAqtBlFUM3ifjWrSz5/Ey8tVpYqDJuJPpw2hKNtGEJ/ezJXh6dMbHBbUh1p475T8wdEwqq78JLd/vxIeWPxF6p1I68FttLJi2bilBuoE5dUWEUzRsgA5Jw0GRBTkQSVJKvQyj+W0M+og=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5020DEEC3875546A466CEB1E350F39D@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55af11d1-997c-4cbb-79f4-08d73b725d40
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2019 13:24:27.1760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xoeXqeFvQnVFnmpQCYLPANWU3iUYqWi4uEyQAs6Mk2s/6H3x0fJM1baq7MGIn+jFxrzg4ChEq1EOsnEkXYZPP+oSUeMJFx2JFNB7LLbTOw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5253
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-17_06:2019-09-17,2019-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 mlxlogscore=692
 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909170131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA5LTE3IGF0IDE0OjQxICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gVHVlLCBTZXAgMTcsIDIwMTkgYXQgMDE6MzA6NTJQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFRoZSAnbWFjLW1vZGUnIHByb3BlcnR5
IGlzIHNpbWlsYXIgdG8gJ3BoeS1tb2RlJyBhbmQgJ3BoeS1jb25uZWN0aW9uLXR5cGUnLA0KPiA+
IHdoaWNoIGFyZSBlbnVtcyBvZiBtb2RlIHN0cmluZ3MuDQo+ID4gDQo+ID4gVGhlICdkd21hYycg
ZHJpdmVyIHN1cHBvcnRzIGFsbW9zdCBhbGwgbW9kZXMgZGVjbGFyZWQgaW4gdGhlICdwaHktbW9k
ZScNCj4gPiBlbnVtIChleGNlcHQgZm9yIDEgb3IgMikuIEJ1dCBpbiBnZW5lcmFsLCB0aGVyZSBt
YXkgYmUgYSBjYXNlIHdoZXJlDQo+ID4gJ21hYy1tb2RlJyBiZWNvbWVzIG1vcmUgZ2VuZXJpYyBh
bmQgaXMgbW92ZWQgYXMgcGFydCBvZiBwaHlsaWIgb3IgbmV0ZGV2Lg0KPiA+IA0KPiA+IEluIGFu
eSBjYXNlLCB0aGUgJ21hYy1tb2RlJyBmaWVsZCBzaG91bGQgYmUgbWFkZSBhbiBlbnVtLCBhbmQg
aXQgYWxzbyBtYWtlcw0KPiA+IHNlbnNlIHRvIGp1c3QgcmVmZXJlbmNlIHRoZSAncGh5LWNvbm5l
Y3Rpb24tdHlwZScgZnJvbQ0KPiA+ICdldGhlcm5ldC1jb250cm9sbGVyLnlhbWwnLiBUaGF0IHdp
bGwgYWxzbyBtYWtlIGl0IG1vcmUgZnV0dXJlLXByb29mIGZvciBuZXcNCj4gPiBtb2Rlcy4NCj4g
PiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcnUgQXJkZWxlYW4gPGFsZXhhbmRydS5hcmRl
bGVhbkBhbmFsb2cuY29tPg0KPiANCj4gSGkgQWxleGFuZHJ1DQo+IA0KPiBBZGRpbmcgYSBGaXhl
czogdGFnIHdvdWxkIGJlIGdvb2QuIEp1c3QgcmVwbHkgaW4gdGhpcyB0aHJlYWQsIGFuZA0KPiBw
YXRjaHdvcmsgd2lsbCBkbyBtYWdpYyB0byBhcHBlbmQgaXQgdG8gdGhlIHBhdGNoLg0KPiANCg0K
T29wcy4gR29vZCBwb2ludC4NClRoYW5rcyBmb3IgdGhlIHRpcC4NCg0KTGV0J3Mgc2VlIGlmIFJv
YiBhZ3JlZXMgYXMgd2VsbC4NCg0KRml4ZXM6IDljMTVkMzU5N2M2MiAoImR0LWJpbmRpbmdzOiBu
ZXQ6IGR3bWFjOiBkb2N1bWVudCAnbWFjLW1vZGUnIHByb3BlcnR5IikNCg0KPiBSZXZpZXdlZC1i
eTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiANCj4gICAgIEFuZHJldw0K
