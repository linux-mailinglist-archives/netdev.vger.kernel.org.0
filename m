Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D67E8FAA0
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 08:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfHPGKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 02:10:09 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:15286 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726166AbfHPGKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 02:10:08 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7G62fV7001010;
        Fri, 16 Aug 2019 02:09:56 -0400
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2050.outbound.protection.outlook.com [104.47.33.50])
        by mx0a-00128a01.pphosted.com with ESMTP id 2udk948e4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 02:09:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/6uLvQ7+nRiYAhLhOUbLsxOSP5cythSb8suH87k93TS7KeXJ6TCRnczC8T+njXYqrLjQ9nEYILa8HCmMl1oNER8mUYAS/tTw+e8jcgJrQdCe76o4hZWNUwUFe/+KNRn4t0UYPWmkWQuKMGeW9BVhpBwdljKiGrJLdRmHUgd07Xe49Nmyca8QPQ+0SqsN5eeiifQpmZqa+3dvKHuN38PCfZv7fUeMdYSezfVkWIpXf2IF8tzk3wizHWSI7Sml5QTM3RXSSVYjgGdF2gkgGkCcg3t6UPRLa82iIn050GrUU/2fRb+harRLT2doXwhiXn7rfHxVIf4mCIPNjebAX76Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPpREuLMuBb0yx4V/v6W3y5FBPlLAQ7+Ay3+i3ESlng=;
 b=KF+Zq43/V0dW3mD1Yh3daCyJpHBtv7jhm24ZqRwYG+0RymUXKXE8Esh8BaerL7kYvQLWLQ4voPOjsX6IQT38cvv9/wKktq5MCNpCjIhCOQd79lwi0fVYmhqrH8c7O9zJPLjT4KMgpCgIrMDap2HTKLsTeck4g7UVXBrpQy1aoK7qFYnEMDB8uMI0r3rGiwRJiwj/GDuf4OnLCerSTt2pYr9C36peDMorhI1J/lcjTbJuwFLjozimJIsxyg/ys5aBcyVdHa0z2oO6Q8PcraGrTT1S8cVB8e2rFAdvyciNxOYNuM7gALn36QK33BJJ5jk61cHmUrcMRzbM6hAQbI8qmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=gmail.com smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPpREuLMuBb0yx4V/v6W3y5FBPlLAQ7+Ay3+i3ESlng=;
 b=a+NjJnbkoCkzR9Z+YKaun0vGcnt9LCmPCuYIWa/BQKKQJbn8deoYqtAjmLQdMADSlgJ9e3rA/21lo052wvfVQANgqHqRu4fMA89Xb2F5HTzL7rseR/PsScWS98P4G3uLemseX+cEkfAthoRGH87iuJbg34ZDhrg4SiwBSJ50X3M=
Received: from DM3PR03CA0013.namprd03.prod.outlook.com (2603:10b6:0:50::23) by
 BN6PR03MB2545.namprd03.prod.outlook.com (2603:10b6:404:5a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Fri, 16 Aug 2019 06:09:54 +0000
Received: from SN1NAM02FT041.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by DM3PR03CA0013.outlook.office365.com
 (2603:10b6:0:50::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.18 via Frontend
 Transport; Fri, 16 Aug 2019 06:09:54 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT041.mail.protection.outlook.com (10.152.72.217) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 06:09:53 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x7G69lCn019782
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 15 Aug 2019 23:09:48 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Fri, 16 Aug 2019 02:09:51 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: Re: [PATCH v4 11/14] net: phy: adin: implement Energy Detect
 Powerdown mode
Thread-Topic: [PATCH v4 11/14] net: phy: adin: implement Energy Detect
 Powerdown mode
Thread-Index: AQHVUQB7crmJOGjtUUW8G0zRgVdFY6b7NHuAgAJe9wA=
Date:   Fri, 16 Aug 2019 06:09:49 +0000
Message-ID: <f5d3dc7e4e919427e82ccb637bd757393296047a.camel@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
         <20190812112350.15242-12-alexandru.ardelean@analog.com>
         <f13feaee-0bad-a774-5527-296b6f74c91b@gmail.com>
In-Reply-To: <f13feaee-0bad-a774-5527-296b6f74c91b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC1D4EDC47E24F4488C47E4AF165016E@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(396003)(39860400002)(346002)(136003)(2980300002)(189003)(199004)(305945005)(476003)(14454004)(14444005)(2501003)(2616005)(7636002)(36756003)(102836004)(26005)(6116002)(446003)(7696005)(336012)(86362001)(246002)(4326008)(3846002)(2486003)(2201001)(7736002)(186003)(126002)(6246003)(47776003)(478600001)(76176011)(8676002)(23676004)(486006)(53546011)(11346002)(2906002)(436003)(426003)(316002)(356004)(54906003)(110136005)(8936002)(50466002)(229853002)(4744005)(106002)(70586007)(70206006)(5660300002)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR03MB2545;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84b114fb-33e4-41f2-0b7b-08d722105b05
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BN6PR03MB2545;
X-MS-TrafficTypeDiagnostic: BN6PR03MB2545:
X-Microsoft-Antispam-PRVS: <BN6PR03MB2545B0E6E0E06937CFA4D024F9AF0@BN6PR03MB2545.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: xgPT2ULpmudjMRkb7fek5ulij8As5JL7m7ki0hKRY9ns/L01+tps57OZzu4yfMFaEi2HWzNzZQcrNZly/LJtgzoYozxjH4eeqVPuQ4OOsJ6EXIiL3UbMm7fumQuFVk71n2JuzhZRXwaPif4F6cjEq3QpWCOhaJoxsZwFAbB/4N71qvigM6CAvn1Gjv5PfXl80AvkHoq3Ds66tELWZDXPqF9N7pdSWMfsSf49gyy924Dsh1PScDCjKZaJubG8mCpEZS52sk4bfGhf/sRnJSftlDfwvoWggjmUeU6Jme+mNEqXZsJ3WHMDCK9VzGbpc1JgiBNA+1Gs9vY4i1vJjSX8yHRPaYulwi80v07gvTFOuOvpa9K4TEp139oqFN3Z6yCQL6GEU72S0wzfM2zZvQck73kKekBL/yPVlTs9RfYF6ng=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 06:09:53.3629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b114fb-33e4-41f2-0b7b-08d722105b05
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2545
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA4LTE0IGF0IDEwOjU3IC0wNzAwLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3Rl
Og0KPiBbRXh0ZXJuYWxdDQo+IA0KPiANCj4gDQo+IE9uIDgvMTIvMjAxOSA0OjIzIEFNLCBBbGV4
YW5kcnUgQXJkZWxlYW4gd3JvdGU6DQo+ID4gVGhlIEFESU4gUEhZcyBzdXBwb3J0IEVuZXJneSBE
ZXRlY3QgUG93ZXJkb3duIG1vZGUsIHdoaWNoIHB1dHMgdGhlIFBIWSBpbnRvDQo+ID4gYSBsb3cg
cG93ZXIgbW9kZSB3aGVuIHRoZXJlIGlzIG5vIHNpZ25hbCBvbiB0aGUgd2lyZSAodHlwaWNhbGx5
IGNhYmxlDQo+ID4gdW5wbHVnZ2VkKS4NCj4gPiBUaGlzIGJlaGF2aW9yIGlzIGVuYWJsZWQgYnkg
ZGVmYXVsdCwgYnV0IGNhbiBiZSBkaXNhYmxlZCB2aWEgZGV2aWNlDQo+ID4gcHJvcGVydHkuDQo+
IA0KPiBXZSBjb3VsZCBjb25zaWRlciBhZGRpbmcgYSBQSFkgdHVuYWJsZSwgaGF2aW5nIHRoaXMg
YXMgYSBEZXZpY2UgVHJlZQ0KPiBwcm9wZXJ0eSBhbW91bnRzIHRvIHB1dHRpbmcgYSBwb2xpY3kg
aW5zaWRlIERULCB3aGljaCBpcyBmcm93bmVkIHVwb24uDQoNClRoYXQgd291bGQgYmUgaW50ZXJl
c3RpbmcgYWN0dWFsbHksIGFuZCBJIHdvdWxkIGFsc28gcHJlZmVyIGl0IG92ZXIgc3RhdGljIERU
Lg0KTWF5YmUgZm9yIHRoaXMgcGF0Y2gsIEknbGwganVzdCBlbmFibGUgRURQRCBieSBkZWZhdWx0
IGFuZCBzZWUgYWJvdXQgYSB0dW5hIG9wdGlvbi4NCg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBB
bGV4YW5kcnUgQXJkZWxlYW4gPGFsZXhhbmRydS5hcmRlbGVhbkBhbmFsb2cuY29tPg0KPiANCj4g
T3RoZXIgdGhhbiB0aGF0LCB0aGUgY29kZSBsb29rcyBmaW5lOg0KPiANCj4gUmV2aWV3ZWQtYnk6
IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0K
