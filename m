Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 112708AF36
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfHMGH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:07:57 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:1276 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbfHMGH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:07:56 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7D62sAp027716;
        Tue, 13 Aug 2019 02:07:47 -0400
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2058.outbound.protection.outlook.com [104.47.34.58])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u9tj5y8fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 13 Aug 2019 02:07:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuTIrEFy8b6jNkhILf7t+6kP4xEmRgBIab2Gt56eKlWvb0n2coqxLz9LV9vPN3J5UAZfpwCMYvSOqcDiXgd1ZxlTX1mvIatHO6wvLBeWWhVVhntSb1CDWj1/Fubz7qHXReouZZEuHOo75OC0z6OJ6nMQCJGihin9doLHbpx75w8He/Bs1S0lYGOHSpSuV99orwU4B7N833ssgil7s1v4Ek+UkN8+5nN9eO6vOcGkJ8y7nZWiO3DvX3Mj4q9l1/sjnsUiVEnRPEAFinbrcARxFQTdRfh3NgHq/DUl/TDSVK1Upv5PIE41vk2PtkA4Ib2YmK5GmfBSUgZoS9WYR6wGEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0B+Ew7GmyxOp5jRdm7XGKPoJKSq6BMme89mdT5ndIoY=;
 b=ZJbs1QpdqA1vFXQ5T8TcrcHLwkXRxKVmSc1d6NgsRrKjLyIwLf3y4k+XiOCXmKlwtB345SyHvmZgH4ZjvPc5OEpbhnEE/JsfB7+AB4/DBFDlGiGdseC7uoEALOQRmp2bSWd7U6eVKDFjcnRrsK6VljFrH4qS3w9yZ1hSyaOIFx79YmwmTFnuIUbuY2CXawpejUpzjpcuoY9HV3qG5N6XYI/5uTEMP+VJ07tr66BnL0AiOpUNp4ecw0WhDQW2SVdbbOGFDikkSkYUsQIKc9XyUXTatMF+yQ4CUZiv7XR1cz46cWHPucGwSs6PHtOv7lKxAWQ8DRV4l9q7yjmbvrh0Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0B+Ew7GmyxOp5jRdm7XGKPoJKSq6BMme89mdT5ndIoY=;
 b=qOCgDTyjCKsR2PkrCkrjxsxKKYcJGquN/SHMj4q/lEMqiKk2YpMarKhR0ErCPzDVoA/iSm47b5hOeRA/aOD2kyfOZsOw74awU6BbmLuGFJPLRp798P0bbDvIB1+IOnf1zm2WRxmIHvMhy8NV8VPF8UzaqhW2vtImRvYPiU7qdY8=
Received: from BN3PR03CA0116.namprd03.prod.outlook.com (2603:10b6:400:4::34)
 by SN6PR03MB3693.namprd03.prod.outlook.com (2603:10b6:805:42::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Tue, 13 Aug
 2019 06:07:45 +0000
Received: from CY1NAM02FT027.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by BN3PR03CA0116.outlook.office365.com
 (2603:10b6:400:4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15 via Frontend
 Transport; Tue, 13 Aug 2019 06:07:45 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT027.mail.protection.outlook.com (10.152.75.159) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Tue, 13 Aug 2019 06:07:44 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7D67hdA022694
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 23:07:43 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Tue, 13 Aug 2019 02:07:43 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH v4 13/14] net: phy: adin: add ethtool get_stats support
Thread-Topic: [PATCH v4 13/14] net: phy: adin: add ethtool get_stats support
Thread-Index: AQHVUQB9ToIHSOhtHEuH64MPKOTzBKb31POAgAEG7IA=
Date:   Tue, 13 Aug 2019 06:07:42 +0000
Message-ID: <3d020fd22f253f32622b6d150a4387ed0707f587.camel@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
         <20190812112350.15242-14-alexandru.ardelean@analog.com>
         <20190812142637.GR14290@lunn.ch>
In-Reply-To: <20190812142637.GR14290@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D338A71FCC7B44D874882A971DDBE26@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(136003)(376002)(2980300002)(189003)(199004)(2351001)(426003)(316002)(436003)(8676002)(118296001)(54906003)(336012)(1730700003)(486006)(126002)(106002)(2906002)(11346002)(7636002)(6116002)(2616005)(476003)(3846002)(446003)(305945005)(76176011)(86362001)(7736002)(6916009)(229853002)(478600001)(4326008)(5640700003)(23676004)(2486003)(14454004)(47776003)(2501003)(26005)(70586007)(5660300002)(70206006)(186003)(356004)(50466002)(7696005)(246002)(36756003)(14444005)(6246003)(102836004)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR03MB3693;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f8608b7-bc66-4c22-c428-08d71fb48ee2
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:SN6PR03MB3693;
X-MS-TrafficTypeDiagnostic: SN6PR03MB3693:
X-Microsoft-Antispam-PRVS: <SN6PR03MB36935B65BA9289D118F131ABF9D20@SN6PR03MB3693.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 01283822F8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: G2WoUbkOIWvI3F2jkO+bsVuASV5va8+StfBkpD5vMvFNGy3vGyNfoWnT6h9T7+cioahXHM5gX0UxxmVQD6L7XdAOV3/7Y2sAG8YR35IH3OwOGWasHrSWmPWQI/o5lK0M/G2AFwYiWOTnXp9fI69rJ8XWehgPMQ9hYKqm8Q2QjBu8oIlff0fO9ZoyWhJGjbhaoBSV95FMkR7u8JlAV9tcr9NJwzBRLV8apwl7ZF9nUyrJ9fNIZTkNrKbymLn8yGuB6D4DCrQdz0lZfEZs6BBsXuZzf0vvgOVIKLshudpUf4xjJ/riBi3FZuqne6BdOjkH+f6zf38/ZCVIBxUcq14jfmnd0Tc+GFFXUy9RZzNe2gjnPmD7TPt+/XsjPzLb/Nsu0oWfYG/al3PYijK/eRWBzhSUV0cS5oo7i7cdg6aLV+I=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2019 06:07:44.2490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f8608b7-bc66-4c22-c428-08d71fb48ee2
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB3693
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTEyIGF0IDE2OjI2ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gPiArLyogTmFtZWQganVzdCBsaWtlIGluIHRoZSBkYXRhc2hlZXQg
Ki8NCj4gPiArc3RhdGljIHN0cnVjdCBhZGluX2h3X3N0YXQgYWRpbl9od19zdGF0c1tdID0gew0K
PiA+ICsJeyAiUnhFcnJDbnQiLAkJMHgwMDE0LAl9LA0KPiA+ICsJeyAiTXNlQSIsCQkweDg0MDIs
CTAsCXRydWUgfSwNCj4gPiArCXsgIk1zZUIiLAkJMHg4NDAzLAkwLAl0cnVlIH0sDQo+ID4gKwl7
ICJNc2VDIiwJCTB4ODQwNCwJMCwJdHJ1ZSB9LA0KPiA+ICsJeyAiTXNlRCIsCQkweDg0MDUsCTAs
CXRydWUgfSwNCj4gPiArCXsgIkZjRnJtQ250IiwJCTB4OTQwQSwgMHg5NDBCIH0sIC8qIEZjRnJt
Q250SCArIEZjRnJtQ250TCAqLw0KPiA+ICsJeyAiRmNMZW5FcnJDbnQiLAkweDk0MEMgfSwNCj4g
PiArCXsgIkZjQWxnbkVyckNudCIsCTB4OTQwRCB9LA0KPiA+ICsJeyAiRmNTeW1iRXJyQ250IiwJ
MHg5NDBFIH0sDQo+ID4gKwl7ICJGY09zekNudCIsCQkweDk0MEYgfSwNCj4gPiArCXsgIkZjVXN6
Q250IiwJCTB4OTQxMCB9LA0KPiA+ICsJeyAiRmNPZGRDbnQiLAkJMHg5NDExIH0sDQo+ID4gKwl7
ICJGY09kZFByZUNudCIsCTB4OTQxMiB9LA0KPiA+ICsJeyAiRmNEcmliYmxlQml0c0NudCIsCTB4
OTQxMyB9LA0KPiA+ICsJeyAiRmNGYWxzZUNhcnJpZXJDbnQiLAkweDk0MTQgfSwNCj4gDQo+IEkg
c2VlIHNvbWUgdmFsdWUgaW4gdXNpbmcgdGhlIG5hbWVzIGZyb20gdGhlIGRhdGFzaGVldC4gSG93
ZXZlciwgaQ0KPiBmb3VuZCBpdCBxdWl0ZSBoYXJkIHRvIG5vdyB3aGF0IHRoZXNlIGNvdW50ZXJz
IHJlcHJlc2VudCBnaXZlbiB0aGVyZQ0KPiBjdXJyZW50IG5hbWUuIFdoYXQgaXMgTXNlPyBIb3cg
ZG9lcyBNc2VBIGRpZmZlciBmcm9tIE1zZUI/IFlvdSBoYXZlIHVwDQo+IHRvIEVUSF9HU1RSSU5H
X0xFTiBjaGFyYWN0ZXJzLCBzbyBtYXliZSBsb25nZXIgbmFtZXMgd291bGQgYmUgYmV0dGVyPw0K
DQpJJ2xsIGV4cGFuZCB0aGUgbmFtZXMuDQoNClJlZ2FyZGluZyBNc2VBL0IvQy9ELCBJJ2xsIGFk
bWl0IEkgYW0gYWxzbyBhIGJpdCBmdXp6eSBhYm91dCB0aGVtLg0KVGhleSBkZXNjcmliZSBsaW5r
LXF1YWxpdHkgc2V0dGluZ3MsIGFuZCB0aGUgdmFsdWVzIGhhdmUgc29tZSBtZWFuaW5nIHRvIHRo
ZSBjaGlwIGd1eXMgW3doZW4gSSB0YWxrZWQgd2l0aHQgdGhlbSBhYm91dA0KaXRdLCBidXQgSSBk
aWQgbm90IGluc2lzdCBvbiBnZXR0aW5nIGEgZGVlcCBleHBsYW5hdGlvbiBhYm91dCB0aGVtIFth
bmQgd2hhdCB0aGVpciB2YWx1ZXMgcmVwcmVzZW50XS4NCkkgZ3Vlc3MgZm9yIHRoaXMgUEhZIGRy
aXZlciwgd2UgY291bGQgZHJvcCB0aGVtLCBhbmQgaWYgdGhleSdyZSBuZWVkZWQgdGhleSBjYW4g
YmUgYWNjZXNzZWQgdmlhIHBoeXRvb2wsIGFuZCBpZiB0aGV5J3JlDQpyZWFsbHkgbmVlZGVkLCBJ
IGNhbiB0cnkgdG8gYWRkIHRoZW0gbGF0ZXIgd2l0aCBtb3JlIGNvbXBsZXRlIGRldGFpbCBbYWJv
dXQgdGhlbSBhbmQgdGhlaXIgdXNlL3ZhbHVlXS4NCg0KSSBpbmNsdWRlZCB0aGVtIGhlcmUsIGJl
Y2F1c2UgdGhleSBhcmUgbGlzdGVkIGluIHRoZSBlcnJvci1jb3VudGVyIHJlZ2lzdGVyICJncm91
cCIgW2luIHRoZSBkYXRhc2hlZXRdLCBhbmQgSSBpbmVydGlhbGx5DQphZGRlZCB0aGVtLg0KDQo+
IA0KPiAgICBBbmRyZXcNCg==
