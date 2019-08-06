Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EB882BC5
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbfHFGiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:38:55 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:5856 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731560AbfHFGiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:38:55 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766X3RY018458;
        Tue, 6 Aug 2019 02:38:47 -0400
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2053.outbound.protection.outlook.com [104.47.49.53])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6yamrv48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:38:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9GfELpxlIrQnUvtAPJnLNq8iVkgYR3ZbdIS3j5ZDcZXg9R/p88zss/7gTJa6rLk9S2OEzuBnbs91IKAqbjf1ceNN+zTRp2GVOpFqz8lM71ROgKLx6KFIpIL4xAJkUZPp3oMrqF8Zqi67aXvn0sZQcmdm/ZTgUFBbCppFxUSUkOL23cF2KCuXym0d+A5AGfbqYPNvV3MdP7NAwgjZTSAvYy0bgkw9NS/aGmjiLTibQFCZgA63tgSjnRLcipMez8uQNNPULT/f5q9zet1gsz9Ut0RjHxlaaKccHNaAZV5HLenAnM6LugWST9etWNB/HBWHtdWD4xojd8aEEx0KsfDKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kAQTuroQ5lxHt9jusoQrIshS+PaQpNt1ue/gpIrmC8=;
 b=obqgJewS1rgZu4qIqWJ87FDs+qJ8kXlgyzGum8XRUWSZWsC9zkVziY8hkCQMMZBcCaiU3cF3OJOYh3p8Dnotq5YLu9uyvAYrxcNmtUjsgrw6xe7H1TLgum0PCKlU2/GffL9ypbsrSSp5BTUHblwhci074jT57n2UX2tdokL3lkk4ebkMXoZKltgUDHgJamH7iJhotdpbGm8uwhwWu/xvokjxX00/QQ3JYp4fzkYRj5CHJlCruvKXIW+Y0vIpmYaFRqcampplRu/uA9LzW6lk8xhQ4aXMC5OKmhas2lpSrd/Gr8DD9+Rf/lqLetS7RnS1GPhLRkSSE6TTrMWyXhWtTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kAQTuroQ5lxHt9jusoQrIshS+PaQpNt1ue/gpIrmC8=;
 b=8Ha0GnQAxxCgH9eh0QM1rEfcP0zjovbkKTbzcg47vpGe1ebkkIQKQcf2aFOgLrXdBHC+APSOpbJYwigwqGQs5UmLa2U69oyTEbh2GSmtO45BUVQrm5oZvd1AOWuytWqHeGyl1IDZjxVT9h1Kuhjl0QKaXmxHrgnmQlLJ1H4aWqI=
Received: from BL0PR03CA0016.namprd03.prod.outlook.com (2603:10b6:208:2d::29)
 by BN7PR03MB4499.namprd03.prod.outlook.com (2603:10b6:408:9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Tue, 6 Aug
 2019 06:38:45 +0000
Received: from BL2NAM02FT043.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::203) by BL0PR03CA0016.outlook.office365.com
 (2603:10b6:208:2d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.14 via Frontend
 Transport; Tue, 6 Aug 2019 06:38:45 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT043.mail.protection.outlook.com (10.152.77.95) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:38:45 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x766cjdU008862
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:38:45 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:38:45 -0400
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
Subject: Re: [PATCH 04/16] net: phy: adin: add {write,read}_mmd hooks
Thread-Topic: [PATCH 04/16] net: phy: adin: add {write,read}_mmd hooks
Thread-Index: AQHVS5VnyQk+O2/bxE25PzZK0Gmj4abs3xOAgAFCRwA=
Date:   Tue, 6 Aug 2019 06:38:44 +0000
Message-ID: <2e914a9f45ad2611e63bdc5c9b3ef5e366970a84.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-5-alexandru.ardelean@analog.com>
         <20190805142513.GK24275@lunn.ch>
In-Reply-To: <20190805142513.GK24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <ECBE225444475B46A23C3219EC3F93A6@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(136003)(376002)(346002)(396003)(2980300002)(199004)(189003)(246002)(6916009)(436003)(2486003)(7696005)(426003)(5660300002)(11346002)(23676004)(446003)(47776003)(50466002)(14454004)(229853002)(54906003)(2906002)(76176011)(70206006)(2351001)(2616005)(186003)(7736002)(7636002)(476003)(316002)(4744005)(336012)(70586007)(356004)(126002)(4326008)(478600001)(486006)(102836004)(6246003)(305945005)(36756003)(6116002)(86362001)(8676002)(1730700003)(3846002)(26005)(5640700003)(106002)(118296001)(8936002)(2501003)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR03MB4499;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20adc435-ba2f-4571-5722-08d71a38bb14
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BN7PR03MB4499;
X-MS-TrafficTypeDiagnostic: BN7PR03MB4499:
X-Microsoft-Antispam-PRVS: <BN7PR03MB4499F19F5EA01EAF8E01AC4CF9D50@BN7PR03MB4499.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: icxaGkOudhAN+FkLt6wuCdAryYyQgIcRM9DHYrsSP9zjhFGJpAB6UYChiWGZ/C8X5CQn1DekeFtPhJ9ZWpGn3vGTwtgPCgKAYjxcSaXrsvmATUKK/SVLXpT6V7irvr+wwCHJo+XNGn8qkiEZZQu1ak0QBTvWMxe257Ok399HHxUox7GB5CMr+GxJQTXKb+XMJvzJ8XRYH7pUZUT5ravMtmLBZgUKXFj1HrC3vr8hY0j5W6lCB9AoJBwwsgHmB/LcE1+rx1IsMfb5xL4Y5BAifwWEqJcFG3tkBRjq+bXaf30aGcvIUx1uVVS3TuSA3fgHxwVtc38NT2zNbc4ce0oYYncYeJ5U2y6vLot1qfZH+940oZmc98r21OzD7Oe8PSFTEEWraGEqHvPd7R/YQfPg/W5TTEhpAufoHtmdfZZH3yo=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:38:45.4406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20adc435-ba2f-4571-5722-08d71a38bb14
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB4499
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=961 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE2OjI1ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L2FkaW4uYyBi
L2RyaXZlcnMvbmV0L3BoeS9hZGluLmMNCj4gPiBpbmRleCBiNzVjNzIzYmRhNzkuLjNkZDlmZTUw
ZjRjOCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9waHkvYWRpbi5jDQo+ID4gKysrIGIv
ZHJpdmVycy9uZXQvcGh5L2FkaW4uYw0KPiA+IEBAIC0xNCw2ICsxNCw5IEBADQo+ID4gICNkZWZp
bmUgUEhZX0lEX0FESU4xMjAwCQkJCTB4MDI4M2JjMjANCj4gPiAgI2RlZmluZSBQSFlfSURfQURJ
TjEzMDAJCQkJMHgwMjgzYmMzMA0KPiA+ICANCj4gPiArI2RlZmluZSBBRElOMTMwMF9NSUlfRVhU
X1JFR19QVFIJCTB4MTANCj4gPiArI2RlZmluZSBBRElOMTMwMF9NSUlfRVhUX1JFR19EQVRBCQkw
eDExDQo+ID4gKw0KPiA+ICAjZGVmaW5lIEFESU4xMzAwX0lOVF9NQVNLX1JFRwkJCTB4MDAxOA0K
PiANCj4gUGxlYXNlIGJlIGNvbnNpc3RlbnQgd2l0aCByZWdpc3RlcnMuIEVpdGhlciB1c2UgNCBk
aWdpdHMsIG9yIDIgZGlnaXRzLg0KDQphY2s7DQoNCj4gDQo+ICAgICAgICBBbmRyZXcNCg==
