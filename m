Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5876882C73
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 09:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbfHFHS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 03:18:29 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:11514 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731807AbfHFHS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 03:18:29 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x767Hn92020125;
        Tue, 6 Aug 2019 03:18:18 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2053.outbound.protection.outlook.com [104.47.40.53])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u72vtgdf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 03:18:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDnUAZjANMfweeBBf9t0cHku5Ing8kkAwQ3p6TaUJl7nOVn+MVbKRzh2V6J0YCBtdzCDM16MxT6si+2J+ntf78tZSTUai8Qm7Obu+O10J6J2nyCdp/JQzu2Vu5NKVxrFhkBQmTZz/CpTDlHgjnHq3RKRuUrc33g+hthxwKgrELomwLY8ia53tCA0sEaKSBxODk3pmAA87s185pd2Hm9ZvFjjoLn/JWiXlyLiCUXZo5oSoBW6otYXXt9KK4msT5/udWkhGV4HeXlqOcEX7YOiycI6Sk7EcbitxduHr28F3R0x1DvdZWKkNs3RHhDURU/K+VEidY1WGXcxhUfo1upFYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kI6D0Eb8kg5hw83LQ6tGtNB1rrKDrLg8o6DqKhJYook=;
 b=lEkQ+ltc3GPP2poegJa74yOiZ9fEbXh9As7I5yPcZQ+T5xMXwWc929EliAMxMzIvkw8kkUqcVYb9M7lQp8n5j61yRgkAQDZ6xayjSx9A0CoWxZyZ0SiSdnHct6I3SrTKPTNTnhv4ZgIp8496EHmfQZHK37I6IyaZuyrULg24na68gx7iieWKW3LekeSWmYXTiu/Fu/lw/g9PiHW38uqz+zltCM1rNWQEwmZelNpSk2XGMlfEbQ5OkKGR3NXy2MFZOIgqHc2WkSV6qa4zSi+SVZ/eTwaTKPyZEWDmZRQnLKv2xGyM61DxM9hNyGfFzPUY+hufpKxZqDbnZFnrM04dtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kI6D0Eb8kg5hw83LQ6tGtNB1rrKDrLg8o6DqKhJYook=;
 b=M0s4H3jIiuXct94/YYs+dGpA1fBlYNcCKuNn7dkB0NNR527wKB+Z6w9G0SNHa5R94JvlHpQY3aJyrFCl8aRFHxVUIQoFQ7Z+5PnQe0fdbWg4Z5TY8986DQE1i3UlKgDqsZG8mihwtCk8SJOATyV3g+G0MvAnMRn7orTZul2E9z4=
Received: from CH2PR03CA0030.namprd03.prod.outlook.com (2603:10b6:610:59::40)
 by BN6PR03MB2817.namprd03.prod.outlook.com (2603:10b6:404:111::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.13; Tue, 6 Aug
 2019 07:18:16 +0000
Received: from CY1NAM02FT058.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by CH2PR03CA0030.outlook.office365.com
 (2603:10b6:610:59::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.14 via Frontend
 Transport; Tue, 6 Aug 2019 07:18:16 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT058.mail.protection.outlook.com (10.152.74.149) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 07:18:15 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x767IFus017074
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 6 Aug 2019 00:18:15 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 03:18:14 -0400
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
Subject: Re: [PATCH 15/16] net: phy: adin: add ethtool get_stats support
Thread-Topic: [PATCH 15/16] net: phy: adin: add ethtool get_stats support
Thread-Index: AQHVS5V1fT5ht6Fx90STGsdhsWokyKbs8XIAgAE68IA=
Date:   Tue, 6 Aug 2019 07:18:13 +0000
Message-ID: <19cfaeab46460333d22a4174eca25e7dd903bd0b.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-16-alexandru.ardelean@analog.com>
         <20190805153058.GU24275@lunn.ch>
In-Reply-To: <20190805153058.GU24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9679A834A7BAB741AFB1C344B4648DE0@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(376002)(39860400002)(2980300002)(189003)(199004)(6916009)(316002)(4326008)(54906003)(2906002)(478600001)(76176011)(3846002)(6116002)(86362001)(6246003)(5640700003)(446003)(426003)(336012)(229853002)(436003)(126002)(11346002)(486006)(2616005)(106002)(476003)(14454004)(118296001)(50466002)(36756003)(305945005)(7636002)(1730700003)(2351001)(8676002)(2501003)(5660300002)(70586007)(8936002)(356004)(246002)(7736002)(7696005)(102836004)(70206006)(186003)(26005)(47776003)(23676004)(2486003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR03MB2817;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f8f5e20-22e9-4636-7e8f-08d71a3e4010
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BN6PR03MB2817;
X-MS-TrafficTypeDiagnostic: BN6PR03MB2817:
X-Microsoft-Antispam-PRVS: <BN6PR03MB2817530081DDE11AB1D2AB31F9D50@BN6PR03MB2817.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: +5hDg0MUAufi4m/pRuLRWurvgosD6Z2R5oQVPC8pH/dGH1AsoPGIEeM04t7i8V6syoe0blZGOdq6GgNi8bITvLYg6vasQba357KARjBacY9MIQjzcMsAGuCc2tnzCjLlJ4kFbVRN6Qe//x+KTPONMl6HLtx8K4KL2ETvJK+9JAgTRBnCA5A4/NrDN8zBxOe/ne/YcJjhzS9e9pcgbL//0XWXvaI91B8JnCmb0pPOaZ21GVmU+GNvPYpEHiO+fiB4n8rIYRe7IxEr89T8bQkNTeARFW6z7Jg1/cyZNuaRAERuH2Bq4l7u/CikkIa99k5VoBilSegF1tXw4kXd3grH7EA0TSyOJyLv7AjmrQFCjhknmpyPXeRtIta3QF4LU/cAYpHXmhsTmIL1sg0YFctTfYADO/1+JvM0Ci60NFATzsY=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 07:18:15.6157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8f5e20-22e9-4636-7e8f-08d71a3e4010
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2817
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060081
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE3OjMwICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gTW9uLCBBdWcgMDUsIDIwMTkgYXQgMDc6NTQ6NTJQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFRoaXMgY2hhbmdlIGltcGxlbWVudHMg
cmV0cmlldmluZyBhbGwgdGhlIGVycm9yIGNvdW50ZXJzIGZyb20gdGhlIFBIWS4NCj4gPiBUaGUg
UEhZIHN1cHBvcnRzIHNldmVyYWwgZXJyb3IgY291bnRlcnMvc3RhdHMuIFRoZSBgTWVhbiBTcXVh
cmUgRXJyb3JzYA0KPiA+IHN0YXR1cyB2YWx1ZXMgYXJlIG9ubHkgdmFsaWUgd2hlbiBhIGxpbmsg
aXMgZXN0YWJsaXNoZWQsIGFuZCBzaG91bGRuJ3QgYmUNCj4gPiBpbmNyZW1lbnRlZC4gVGhlc2Ug
dmFsdWVzIGNoYXJhY3Rlcml6ZSB0aGUgcXVhbGl0eSBvZiBhIHNpZ25hbC4NCj4gDQo+IEkgdGhp
bmsgeW91IG1lYW4gYWNjdW11bGF0ZWQsIG5vdCBpbmNyZW1lbnRlZD8NCg0KYWNjdW11bGF0ZWQg
c291bmRzIGJldHRlcjsNCg0KDQo+ID4gVGhlIHJlc3Qgb2YgdGhlIGVycm9yIGNvdW50ZXJzIGFy
ZSBzZWxmLWNsZWFyaW5nIG9uIHJlYWQuDQo+ID4gTW9zdCBvZiB0aGVtIGFyZSByZXBvcnRzIGZy
b20gdGhlIEZyYW1lIENoZWNrZXIgZW5naW5lIHRoYXQgdGhlIFBIWSBoYXMuDQo+ID4gDQo+ID4g
Tm90IHJldHJpZXZpbmcgdGhlIGBMUEkgV2FrZSBFcnJvciBDb3VudCBSZWdpc3RlcmAgaGVyZSwg
c2luY2UgdGhhdCBpcyB1c2VkDQo+ID4gYnkgdGhlIFBIWSBmcmFtZXdvcmsgdG8gY2hlY2sgZm9y
IGFueSBFRUUgZXJyb3JzLiBBbmQgdGhhdCByZWdpc3RlciBpcw0KPiA+IHNlbGYtY2xlYXJpbmcg
d2hlbiByZWFkIChhcyBwZXIgSUVFRSBzcGVjKS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBB
bGV4YW5kcnUgQXJkZWxlYW4gPGFsZXhhbmRydS5hcmRlbGVhbkBhbmFsb2cuY29tPg0KPiA+IC0t
LQ0KPiA+ICBkcml2ZXJzL25ldC9waHkvYWRpbi5jIHwgMTA4ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMDggaW5zZXJ0aW9u
cygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvYWRpbi5jIGIvZHJp
dmVycy9uZXQvcGh5L2FkaW4uYw0KPiA+IGluZGV4IGExZjM0NTZhODUwNC4uMDQ4OTY1NDdkYWM4
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9hZGluLmMNCj4gPiArKysgYi9kcml2
ZXJzL25ldC9waHkvYWRpbi5jDQo+ID4gQEAgLTEwMyw2ICsxMDMsMzIgQEAgc3RhdGljIHN0cnVj
dCBjbGF1c2UyMl9tbWRfbWFwIGNsYXVzZTIyX21tZF9tYXBbXSA9IHsNCj4gPiAgCXsgTURJT19N
TURfUENTLCBNRElPX1BDU19FRUVfV0tfRVJSLAlBRElOMTMwMF9MUElfV0FLRV9FUlJfQ05UX1JF
RyB9LA0KPiA+ICB9Ow0KPiA+ICANCj4gPiArc3RydWN0IGFkaW5faHdfc3RhdCB7DQo+ID4gKwlj
b25zdCBjaGFyICpzdHJpbmc7DQo+ID4gKwl1MTYgcmVnMTsNCj4gPiArCXUxNiByZWcyOw0KPiA+
ICsJYm9vbCBkb19ub3RfaW5jOw0KPiANCj4gZG9fbm90X2FjY3VtdWxhdGU/IG9yIHJldmVyc2Ug
aXRzIG1lYW5pbmcsIGNsZWFyX29uX3JlYWQ/DQoNCmRvX25vdF9hY2N1bXVsYXRlIHdvcmtzOw0K
dGhlcmUgYXJlIG9ubHkgNCByZWdzIHRoYXQgbmVlZCB0aGlzIHByb3BlcnR5IHNldCB0byB0cnVl
DQoNCj4gDQo+ICAgIEFuZHJldw0K
