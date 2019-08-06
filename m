Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F2582BB9
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731851AbfHFGfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:35:19 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:36970 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731594AbfHFGfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:35:19 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766X6U8030520;
        Tue, 6 Aug 2019 02:35:09 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2053.outbound.protection.outlook.com [104.47.40.53])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u5448uj3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:35:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkFKa5W/vZgQXRJmxjOaJYBttlDpjPmhOKcM7IqRqotTwHvuIzeNJP7nDRAjOxf7L7YnEgZOIMPxsFt4fhe9YDylBA2Lmx90j2IFHK3FAtr1ZbD4IuYJGeDeWcDWTq/hIbxusPJiolEaMG/l50mrSVzgqZb4dD0A6ZY0PQhCB1N/0ClaqukdVR/NaMMqYLo3vDfq6c/rpyyO3opG3E+Fl6QiBkzpuq2g4v11WrbSNwYND+XfrqFXioRGNx1q2ydPReEvLXPDFmvTymEpBqizCiV3uZ/0rbF004Rg33eAPhdcsOzoItiLToh/WdMMsJ9WFr6r3SA0HoqY1ddx48mGyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izaiPwYrrydCK5OejZJB7tPLdakvbeGB02MQdrQsVdw=;
 b=kjF76ugi+2PlE6U9kt2S6ObmjFt5ljN4bu9N/lfeolcSuwZM5J0AyJ9bC1HI6FOXHDsEY658c/3r/FBZd5Jhg3xdGFDpf8Js9uxgMw8OQw/w2v3vy3O8BJcQn6HcOQ1uc9PzK5XxQxmS2UfCdX+/TEb/T1rHwhGhTX7tsqk+reQ5jnNyBqgqAd7k4AGw/bEh48QkaTZz2ulAPNpp5TQ74Z9eu/XrZldXWQPoC+UDgA1AJ4YbUTMUtOVZj8AJJF9WtgrVvF1ddsl4zxiVbv3qmb4NTwsUCQxV8XDDQq7+3Sl5LF5eYOV8c3wLUu343XhxYRtkYMKf4pOqXGtrhyYtDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izaiPwYrrydCK5OejZJB7tPLdakvbeGB02MQdrQsVdw=;
 b=6Bs8CiQjMwsOxv8fCahBmHRK+TbN8rJUOZhRIN6qoDA3GLZxHz+229fpaW16H7pR8/ikraCQ0D/EH6XrnycTSfY9oukkbpTN9qheLEnicA3RwjSPuv3aKIeKzPtt0KZGV3rE8YGD4y1ziUpHChcp32yLuhB0jqHoASBWKBup3MU=
Received: from DM6PR03CA0001.namprd03.prod.outlook.com (2603:10b6:5:40::14) by
 SN6PR03MB4494.namprd03.prod.outlook.com (2603:10b6:805:fb::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Tue, 6 Aug 2019 06:35:07 +0000
Received: from SN1NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by DM6PR03CA0001.outlook.office365.com
 (2603:10b6:5:40::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.14 via Frontend
 Transport; Tue, 6 Aug 2019 06:35:07 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT031.mail.protection.outlook.com (10.152.72.116) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:35:06 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x766Z3a2012069
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:35:03 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:35:06 -0400
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
Subject: Re: [PATCH 01/16] net: phy: adin: add support for Analog Devices
 PHYs
Thread-Topic: [PATCH 01/16] net: phy: adin: add support for Analog Devices
 PHYs
Thread-Index: AQHVS5VjXT25F74l5kCSv2qgimoBNqbs7bYAgAEyn4A=
Date:   Tue, 6 Aug 2019 06:35:05 +0000
Message-ID: <57e021b94bf0a116a71f0c18fc28db9e1d42187e.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-2-alexandru.ardelean@analog.com>
         <20190805151736.GQ24275@lunn.ch>
In-Reply-To: <20190805151736.GQ24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D1C16E68C96FB40BE13821381F64BBF@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(396003)(346002)(2980300002)(199004)(189003)(316002)(76176011)(2906002)(7696005)(23676004)(2486003)(54906003)(102836004)(36756003)(7736002)(47776003)(7636002)(305945005)(14454004)(106002)(2616005)(86362001)(26005)(118296001)(478600001)(6116002)(476003)(126002)(486006)(3846002)(336012)(446003)(186003)(11346002)(246002)(426003)(436003)(5660300002)(8936002)(5640700003)(2351001)(356004)(50466002)(229853002)(1730700003)(2501003)(6916009)(4326008)(6246003)(8676002)(70206006)(70586007);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR03MB4494;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8067f9e9-6364-4709-f139-08d71a3838e8
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:SN6PR03MB4494;
X-MS-TrafficTypeDiagnostic: SN6PR03MB4494:
X-Microsoft-Antispam-PRVS: <SN6PR03MB44946E0129A5FD94BAF85D23F9D50@SN6PR03MB4494.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 9JJ16WR6SIOttS8qRgRMNlfhwSv8wHK8zq81IhooUm/i5czecZWN+lZ/XnD0EDxATMM2C8QN/rTfawGO9M1AERsnBR4aWpGW64lGMRZjYbpOwYGEqhssTHGQeNY2ANv8KyE9LJLjchjgeUEFuoE0QwL32ao/cOXVWgdaXeSwe2FJAN1wFoKV0/9ztjCxXWEvLT8TWc9Pulq82jwXmYQBabXzEEMLbbEPqW3ySRju20mO9tiIDGev6ptEgHeUQWo6EgnLtzP4QYedg7Rz4EoQoXBrHqQMMJBQKeDG5NKdLLj1FiOuk3ZSTztFsQFGWQM2wJGx2SnwweC2j8Gau6KGQq9Rlm815SnCEYvIrwIh5gs+fdWgSnpRBSq+7mVSjvgTJCtavmN/HrPs04sZucjssBbmMDnFafGqqOWXkyd7tWA=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:35:06.7332
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8067f9e9-6364-4709-f139-08d71a3838e8
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB4494
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE3OjE3ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gPiArc3RhdGljIHN0cnVjdCBwaHlfZHJpdmVyIGFkaW5fZHJpdmVy
W10gPSB7DQo+ID4gKwl7DQo+ID4gKwkJLnBoeV9pZAkJPSBQSFlfSURfQURJTjEyMDAsDQo+ID4g
KwkJLm5hbWUJCT0gIkFESU4xMjAwIiwNCj4gPiArCQkucGh5X2lkX21hc2sJPSAweGZmZmZmZmYw
LA0KPiA+ICsJCS5mZWF0dXJlcwk9IFBIWV9CQVNJQ19GRUFUVVJFUywNCj4gDQo+IERvIHlvdSBu
ZWVkIHRoaXM/IElmIHRoZSBkZXZpY2UgaW1wbGVtZW50cyB0aGUgcmVnaXN0ZXJzIGNvcnJlY3Rs
eSwNCj4gcGh5bGliIGNhbiBkZXRlcm1pbmUgdGhpcyBmcm9tIHRoZSByZWdpc3RlcnMuDQoNCmFj
azsNCndpbGwgdGFrZSBhIGxvb2s7DQoNCj4gDQo+ID4gKwkJLmNvbmZpZ19pbml0CT0gYWRpbl9j
b25maWdfaW5pdCwNCj4gPiArCQkuY29uZmlnX2FuZWcJPSBnZW5waHlfY29uZmlnX2FuZWcsDQo+
ID4gKwkJLnJlYWRfc3RhdHVzCT0gZ2VucGh5X3JlYWRfc3RhdHVzLA0KPiA+ICsJfSwNCj4gPiAr
CXsNCj4gPiArCQkucGh5X2lkCQk9IFBIWV9JRF9BRElOMTMwMCwNCj4gPiArCQkubmFtZQkJPSAi
QURJTjEzMDAiLA0KPiA+ICsJCS5waHlfaWRfbWFzawk9IDB4ZmZmZmZmZjAsDQo+ID4gKwkJLmZl
YXR1cmVzCT0gUEhZX0dCSVRfRkVBVFVSRVMsDQo+IA0KPiBzYW1lIGhlcmUuDQoNCmFjazsNCg0K
PiANCj4gPiArCQkuY29uZmlnX2luaXQJPSBhZGluX2NvbmZpZ19pbml0LA0KPiA+ICsJCS5jb25m
aWdfYW5lZwk9IGdlbnBoeV9jb25maWdfYW5lZywNCj4gPiArCQkucmVhZF9zdGF0dXMJPSBnZW5w
aHlfcmVhZF9zdGF0dXMsDQo+ID4gKwl9LA0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArbW9kdWxlX3Bo
eV9kcml2ZXIoYWRpbl9kcml2ZXIpOw0KPiA+ICsNCj4gPiArc3RhdGljIHN0cnVjdCBtZGlvX2Rl
dmljZV9pZCBfX21heWJlX3VudXNlZCBhZGluX3RibFtdID0gew0KPiA+ICsJeyBQSFlfSURfQURJ
TjEyMDAsIDB4ZmZmZmZmZjAgfSwNCj4gPiArCXsgUEhZX0lEX0FESU4xMzAwLCAweGZmZmZmZmYw
IH0sDQo+IA0KPiBQSFlfSURfTUFUQ0hfVkVORE9SKCkuDQoNCmFjazsNCg0KPiANCj4gCUFuZHJl
dw0K
