Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFE887962
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406687AbfHIMGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:06:42 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:39130 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726091AbfHIMGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 08:06:41 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79C3Ch2002322;
        Fri, 9 Aug 2019 08:06:33 -0400
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2058.outbound.protection.outlook.com [104.47.41.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u7xkj6y75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 08:06:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qx3zuvFJu4/cISagPpLsrnWmi09r5M9tvgUTsLzRgzJIlwt2WF0Oh+3tT/5rSUrdK6g3F7uDWTcz19nc33LggQieDS/gBzBXfCzUCj6GluDkfwA/mA9tO8aJlu/GgY+D2zTQkHDfdCjtUVCZAIWHsHpL0TJfGaJi8KFQCG6140WkBg663F58ksIUxKgQHS2RlPzD0k8o+qac9Q1TtY+SfYL/tboepxAX1pPc0IGTQZQVqG8m6Cjd7CxTsmtoEQfkbjMhLbY7n7HRWSu1YCj+a+LB5PNi19U2aBv+AZFdk8YlvJJDo63Fcf/CqcVTwpeL1IuKZr+sqYST8DK+2Tj7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWdWhZru65KJAvEXRKINLKJ6mYUm81z6bENw0kHkdXA=;
 b=HmKpLNGpZy710Vidfd2yYCmD56p10EoJqGh+biC/xGtVO9wsbEsVkCZNQ1P834HM1+X5IYdplEq1cembw8Efmq922rO8S4UH7Q5jOKdgbsN0rIIwddayCHj9efopj/nQ1Ah/Bssl78/cwN4QVn2InFZfSBOOYgxO08uo9Ygkl6v1n9NaCo/vefWftGa7OitQFUtFrwy1Fxx08GC0Q/NZS5qpGS1i08jmfN6Ew50Sr0+UzOOnPsOjvXxv49Yv9AjsWDz1yxSDXv2RFsNxUKnOozY9YxLzHgY+miA3bfI/qYJDDGYJbzGCmSz83WgXjHjwIdczq0/Y+Pg8JHlUcdnlwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWdWhZru65KJAvEXRKINLKJ6mYUm81z6bENw0kHkdXA=;
 b=J3pyjHHXUo0RT4OS1/SdtTYEx8N/W/XThdVrUyqaUPnntUTkfGciTnenStKYtIrn9atu4xb3kZp0ayemb+JZA7mXuwjTlyMgheS8LQphouRVaBJL4Xu9lEQdzPeh8rvHqhXuZYv4Nv2mogR/ktmd5V8fAe+gix8JTPDse84ohOo=
Received: from BN8PR03CA0024.namprd03.prod.outlook.com (2603:10b6:408:94::37)
 by CY4PR03MB2773.namprd03.prod.outlook.com (2603:10b6:903:68::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.13; Fri, 9 Aug
 2019 12:06:31 +0000
Received: from BL2NAM02FT022.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::209) by BN8PR03CA0024.outlook.office365.com
 (2603:10b6:408:94::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Fri, 9 Aug 2019 12:06:31 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT022.mail.protection.outlook.com (10.152.77.153) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 12:06:31 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x79C6S84006601
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 05:06:28 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Fri, 9 Aug 2019 08:06:31 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "robh+dt@kernel.org" <robh+dt@kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 15/15] dt-bindings: net: add bindings for ADIN PHY
 driver
Thread-Topic: [PATCH v2 15/15] dt-bindings: net: add bindings for ADIN PHY
 driver
Thread-Index: AQHVTeUj6D70I3Sr2EaIM6MLy0GPNqbyIjQAgADazwA=
Date:   Fri, 9 Aug 2019 12:06:30 +0000
Message-ID: <8d5742f6dfb7208d2cf0721d5e32cb015a716d29.camel@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
         <20190808123026.17382-16-alexandru.ardelean@analog.com>
         <CAL_Jsq+zH9cL5-8aDARzPar+xoD71WbESTckGjzaUTodu-+Trg@mail.gmail.com>
In-Reply-To: <CAL_Jsq+zH9cL5-8aDARzPar+xoD71WbESTckGjzaUTodu-+Trg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8A27DE4AD1E7E49A293076B5A48C532@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(346002)(136003)(39860400002)(2980300002)(199004)(189003)(966005)(446003)(23676004)(7696005)(70206006)(356004)(486006)(126002)(476003)(11346002)(6306002)(50466002)(3846002)(4326008)(6116002)(2486003)(76176011)(53376002)(47776003)(186003)(436003)(426003)(14454004)(2616005)(106002)(336012)(478600001)(6246003)(2906002)(54906003)(229853002)(316002)(70586007)(26005)(102836004)(7636002)(8676002)(246002)(53546011)(305945005)(36756003)(5660300002)(7736002)(86362001)(8936002)(14444005)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB2773;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7cbaae6-27fe-4300-7ee8-08d71cc2042a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:CY4PR03MB2773;
X-MS-TrafficTypeDiagnostic: CY4PR03MB2773:
X-MS-Exchange-PUrlCount: 3
X-Microsoft-Antispam-PRVS: <CY4PR03MB2773AEDA615B6489D3EC0D0AF9D60@CY4PR03MB2773.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 2WQKWqpV4YVG5YDK0U3xRMyQkwvkg90X5/RUP+yD7zcYJ0IUXd15jw2QvFZujb6iUunSQS4umQjK3Qjm5a7hefMaSKrfGmju9yJhWqmYzQK3s+nADbsq3JV2SBVz55GqjJ7qXYr5/do7n+h3ZcvJ4IRbNq0pS9fD5kgU0W7t1gWG/VWj/pVBy21qUSOh03UwWzJa4tB+j9RZ6VNt7isdgeXUFBMgjhuvR8rvdj3l7qIxzNfTH1vCnhvQPlLSiVYaiPIHt4fPz59BXDZFKgrImbYE4pEwzMf1ibInPbpxmFeXWVdATK79uQchQrrlcC2404PzHMXI4N78hAWbTRgY8pjGEvqnLdqqhzt5VwgHf/e6WDz//fNoEAZMTxAXgu6UDp4yb+2nOwq3m5rZQKF27XDEORowl8WDPzpcCjUcFnM=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 12:06:31.4396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7cbaae6-27fe-4300-7ee8-08d71cc2042a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB2773
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTA4IGF0IDE3OjAzIC0wNjAwLCBSb2IgSGVycmluZyB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gVGh1LCBBdWcgOCwgMjAxOSBhdCA2OjMxIEFNIEFsZXhhbmRy
dSBBcmRlbGVhbg0KPiA8YWxleGFuZHJ1LmFyZGVsZWFuQGFuYWxvZy5jb20+IHdyb3RlOg0KPiA+
IFRoaXMgY2hhbmdlIGFkZHMgYmluZGluZ3MgZm9yIHRoZSBBbmFsb2cgRGV2aWNlcyBBRElOIFBI
WSBkcml2ZXIsIGRldGFpbGluZw0KPiA+IGFsbCB0aGUgcHJvcGVydGllcyBpbXBsZW1lbnRlZCBi
eSB0aGUgZHJpdmVyLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRydSBBcmRlbGVh
biA8YWxleGFuZHJ1LmFyZGVsZWFuQGFuYWxvZy5jb20+DQo+ID4gLS0tDQo+ID4gIC4uLi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC9hZGksYWRpbi55YW1sICAgICB8IDc2ICsrKysrKysrKysrKysr
KysrKysNCj4gPiAgTUFJTlRBSU5FUlMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHwgIDEgKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDc3IGluc2VydGlvbnMoKykNCj4gPiAgY3Jl
YXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvYWRp
LGFkaW4ueWFtbA0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvbmV0L2FkaSxhZGluLnlhbWwNCj4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvYWRpLGFkaW4ueWFtbA0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0
DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi44NjE3N2M4ZmUyM2ENCj4gPiAtLS0gL2Rldi9udWxs
DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9hZGksYWRp
bi55YW1sDQo+ID4gQEAgLTAsMCArMSw3NiBAQA0KPiA+ICsjIFNQRFgtTGljZW5zZS1JZGVudGlm
aWVyOiBHUEwtMi4wKw0KPiA+ICslWUFNTCAxLjINCj4gPiArLS0tDQo+ID4gKyRpZDogaHR0cDov
L2RldmljZXRyZWUub3JnL3NjaGVtYXMvbmV0L2FkaSxhZGluLnlhbWwjDQo+ID4gKyRzY2hlbWE6
IGh0dHA6Ly9kZXZpY2V0cmVlLm9yZy9tZXRhLXNjaGVtYXMvY29yZS55YW1sIw0KPiA+ICsNCj4g
PiArdGl0bGU6IEFuYWxvZyBEZXZpY2VzIEFESU4xMjAwL0FESU4xMzAwIFBIWQ0KPiA+ICsNCj4g
PiArbWFpbnRhaW5lcnM6DQo+ID4gKyAgLSBBbGV4YW5kcnUgQXJkZWxlYW4gPGFsZXhhbmRydS5h
cmRlbGVhbkBhbmFsb2cuY29tPg0KPiA+ICsNCj4gPiArZGVzY3JpcHRpb246IHwNCj4gPiArICBC
aW5kaW5ncyBmb3IgQW5hbG9nIERldmljZXMgSW5kdXN0cmlhbCBFdGhlcm5ldCBQSFlzDQo+ID4g
Kw0KPiA+ICthbGxPZjoNCj4gPiArICAtICRyZWY6IGV0aGVybmV0LXBoeS55YW1sIw0KPiA+ICsN
Cj4gPiArcHJvcGVydGllczoNCj4gPiArICBhZGkscngtaW50ZXJuYWwtZGVsYXktcHM6DQo+ID4g
KyAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy91aW50MzINCj4gPiAr
ICAgIGRlc2NyaXB0aW9uOiB8DQo+ID4gKyAgICAgIFJHTUlJIFJYIENsb2NrIERlbGF5IHVzZWQg
b25seSB3aGVuIFBIWSBvcGVyYXRlcyBpbiBSR01JSSBtb2RlIHdpdGgNCj4gPiArICAgICAgaW50
ZXJuYWwgZGVsYXkgKHBoeS1tb2RlIGlzICdyZ21paS1pZCcgb3IgJ3JnbWlpLXJ4aWQnKSBpbiBw
aWNvLXNlY29uZHMuDQo+ID4gKyAgICBlbnVtOiBbIDE2MDAsIDE4MDAsIDIwMDAsIDIyMDAsIDI0
MDAgXQ0KPiA+ICsgICAgZGVmYXVsdDogMjAwMA0KPiANCj4gVGhpcyBkb2Vzbid0IGFjdHVhbGx5
IGRvIHdoYXQgeW91IHRoaW5rLiBUaGUgJyRyZWYnIGhhcyB0byBiZSB1bmRlciBhbg0KPiAnYWxs
T2YnIHRvIHdvcmsuIEl0J3MgYW4gb2RkaXR5IG9mIGpzb24tc2NoZW1hLiBIb3dldmVyLCBhbnl0
aGluZyB3aXRoDQo+IGEgc3RhbmRhcmQgdW5pdCBzdWZmaXggYWxyZWFkeSBoYXMgYSBzY2hlbWEg
dG8gZGVmaW5lIHRoZSB0eXBlLCBzbyB5b3UNCj4gZG9uJ3QgbmVlZCB0byBoZXJlIGFuZCBjYW4g
anVzdCBkcm9wICRyZWYuDQoNCmFjaw0Kd2lsbCBkcm9wDQoNCj4gDQo+ID4gKw0KPiA+ICsgIGFk
aSx0eC1pbnRlcm5hbC1kZWxheS1wczoNCj4gPiArICAgICRyZWY6IC9zY2hlbWFzL3R5cGVzLnlh
bWwjL2RlZmluaXRpb25zL3VpbnQzMg0KPiA+ICsgICAgZGVzY3JpcHRpb246IHwNCj4gPiArICAg
ICAgUkdNSUkgVFggQ2xvY2sgRGVsYXkgdXNlZCBvbmx5IHdoZW4gUEhZIG9wZXJhdGVzIGluIFJH
TUlJIG1vZGUgd2l0aA0KPiA+ICsgICAgICBpbnRlcm5hbCBkZWxheSAocGh5LW1vZGUgaXMgJ3Jn
bWlpLWlkJyBvciAncmdtaWktdHhpZCcpIGluIHBpY28tc2Vjb25kcy4NCj4gPiArICAgIGVudW06
IFsgMTYwMCwgMTgwMCwgMjAwMCwgMjIwMCwgMjQwMCBdDQo+ID4gKyAgICBkZWZhdWx0OiAyMDAw
DQo+ID4gKw0KPiA+ICsgIGFkaSxmaWZvLWRlcHRoLWJpdHM6DQo+ID4gKyAgICAkcmVmOiAvc2No
ZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy91aW50MzINCj4gPiArICAgIGRlc2NyaXB0aW9u
OiB8DQo+ID4gKyAgICAgIFdoZW4gb3BlcmF0aW5nIGluIFJNSUkgbW9kZSwgdGhpcyBvcHRpb24g
Y29uZmlndXJlcyB0aGUgRklGTyBkZXB0aC4NCj4gPiArICAgIGVudW06IFsgNCwgOCwgMTIsIDE2
LCAyMCwgMjQgXQ0KPiA+ICsgICAgZGVmYXVsdDogOA0KPiA+ICsNCj4gPiArICBhZGksZGlzYWJs
ZS1lbmVyZ3ktZGV0ZWN0Og0KPiA+ICsgICAgZGVzY3JpcHRpb246IHwNCj4gPiArICAgICAgRGlz
YWJsZXMgRW5lcmd5IERldGVjdCBQb3dlcmRvd24gTW9kZSAoZGVmYXVsdCBkaXNhYmxlZCwgaS5l
IGVuZXJneSBkZXRlY3QNCj4gPiArICAgICAgaXMgZW5hYmxlZCBpZiB0aGlzIHByb3BlcnR5IGlz
IHVuc3BlY2lmaWVkKQ0KPiA+ICsgICAgdHlwZTogYm9vbGVhbg0KPiA+ICsNCj4gPiArZXhhbXBs
ZXM6DQo+ID4gKyAgLSB8DQo+ID4gKyAgICBldGhlcm5ldCB7DQo+ID4gKyAgICAgICAgI2FkZHJl
c3MtY2VsbHMgPSA8MT47DQo+ID4gKyAgICAgICAgI3NpemUtY2VsbHMgPSA8MD47DQo+ID4gKw0K
PiA+ICsgICAgICAgIHBoeS1tb2RlID0gInJnbWlpLWlkIjsNCj4gPiArDQo+ID4gKyAgICAgICAg
ZXRoZXJuZXQtcGh5QDAgew0KPiA+ICsgICAgICAgICAgICByZWcgPSA8MD47DQo+ID4gKw0KPiA+
ICsgICAgICAgICAgICBhZGkscngtaW50ZXJuYWwtZGVsYXktcHMgPSA8MTgwMD47DQo+ID4gKyAg
ICAgICAgICAgIGFkaSx0eC1pbnRlcm5hbC1kZWxheS1wcyA9IDwyMjAwPjsNCj4gPiArICAgICAg
ICB9Ow0KPiA+ICsgICAgfTsNCj4gPiArICAtIHwNCj4gPiArICAgIGV0aGVybmV0IHsNCj4gPiAr
ICAgICAgICAjYWRkcmVzcy1jZWxscyA9IDwxPjsNCj4gPiArICAgICAgICAjc2l6ZS1jZWxscyA9
IDwwPjsNCj4gPiArDQo+ID4gKyAgICAgICAgcGh5LW1vZGUgPSAicm1paSI7DQo+ID4gKw0KPiA+
ICsgICAgICAgIGV0aGVybmV0LXBoeUAxIHsNCj4gPiArICAgICAgICAgICAgcmVnID0gPDE+Ow0K
PiA+ICsNCj4gPiArICAgICAgICAgICAgYWRpLGZpZm8tZGVwdGgtYml0cyA9IDwxNj47DQo+ID4g
KyAgICAgICAgICAgIGFkaSxkaXNhYmxlLWVuZXJneS1kZXRlY3Q7DQo+ID4gKyAgICAgICAgfTsN
Cj4gPiArICAgIH07DQo+ID4gZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMN
Cj4gPiBpbmRleCBlOGFhOGE2Njc4NjQuLmZkOWFiNjFjMjY3MCAxMDA2NDQNCj4gPiAtLS0gYS9N
QUlOVEFJTkVSUw0KPiA+ICsrKyBiL01BSU5UQUlORVJTDQo+ID4gQEAgLTk0NCw2ICs5NDQsNyBA
QCBMOiAgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiA+ICBXOiAgICAgaHR0cDovL2V6LmFuYWxv
Zy5jb20vY29tbXVuaXR5L2xpbnV4LWRldmljZS1kcml2ZXJzDQo+ID4gIFM6ICAgICBTdXBwb3J0
ZWQNCj4gPiAgRjogICAgIGRyaXZlcnMvbmV0L3BoeS9hZGluLmMNCj4gPiArRjogICAgIERvY3Vt
ZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvYWRpLGFkaW4ueWFtbA0KPiA+IA0KPiA+
ICBBTkFMT0cgREVWSUNFUyBJTkMgQURJUyBEUklWRVIgTElCUkFSWQ0KPiA+ICBNOiAgICAgQWxl
eGFuZHJ1IEFyZGVsZWFuIDxhbGV4YW5kcnUuYXJkZWxlYW5AYW5hbG9nLmNvbT4NCj4gPiAtLQ0K
PiA+IDIuMjAuMQ0KPiA+IA0K
