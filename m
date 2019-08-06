Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E8C82C64
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 09:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732058AbfHFHMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 03:12:13 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:38146 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731711AbfHFHMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 03:12:13 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x767Ajks014988;
        Tue, 6 Aug 2019 03:12:02 -0400
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2051.outbound.protection.outlook.com [104.47.42.51])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u72vtgd5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 03:12:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqC1sqJrv5aNSQwy8pgH6mX10RpYhFTs1QEpkQExO7teZqTUBMP25n/5+BHBhGSIPKpGxDjAaJJ/K8Jrq9h7RnPiZlUDHXj8Ruy48fgOfvWPP+6LC43BtJ3rJVncNNDJGq8tos2ddidR2gLQksBhaLZHmJaOugj1goGHiAZS07/9+ZK7HvGWXXADwr+zOIXiF0fs7zj4sleaaezH/YGukvydbIZJ4cGLSLitioY9Dn37Tl+Llt6pS75oDKvNWzurQhiCUbqDl6um34VPSJxAozqv3r5zN6EbEMxCFfZh4CcZmi55Hb1he+rzdK+8HqPpYB1tWqtXicqEYAvFNjC4Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eT4AHAONQ8AY/xzQ2AOBoU2sqcEvLH+AjyGVUv8nXTY=;
 b=HOI2Q27nMQqtQCCv9t3BpWBoy8U+yaOAdtq/vX4GKl8HEYVAEUF1AlbwoQwMqSc7GdEN6OdKeIDWUsUmwt8SePPm44Umn+IWpux1Jh9rvm+IPc4CMzq8iwcsLx1db0o+4LXUeBlB61SJ1jzzYvMUf1CPwv1j92rZpKTQgIio4zrr3HWd/n5dAdP3srsfUK2zE0Iz7WH7C2x/XKZ/L1V7zQSaTL2UFIW3xWzVw4Te+8bhY4jvKkoBF7QPoT0+GUH0E/wiFbEAq4MgIGSMl5YN/ze7EckPmxY8nteQpP5FqRUCyQIAjsV1QPY+sH7oW5uxJ3+HTnAWqb9hdbNBCMtuDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eT4AHAONQ8AY/xzQ2AOBoU2sqcEvLH+AjyGVUv8nXTY=;
 b=MxGb35rHY0VMExJkDNI+Wxt1W0VUzNSdSV3MLf6XmIhJZavH9YUBVxSqzlrHJ+qEHLmEa7GgWP452xoLtfvjO4U99svrlH2ljNgseIPQyRG79IW2r2h+Q0eKKfWVJ9ncEu0gvH0XG7stQBo1kvksXejkrlPR3QPrTejXv/h886s=
Received: from BN6PR03CA0073.namprd03.prod.outlook.com (2603:10b6:405:6f::11)
 by BN7PR03MB4564.namprd03.prod.outlook.com (2603:10b6:408:c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Tue, 6 Aug
 2019 07:12:00 +0000
Received: from CY1NAM02FT015.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::201) by BN6PR03CA0073.outlook.office365.com
 (2603:10b6:405:6f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.16 via Frontend
 Transport; Tue, 6 Aug 2019 07:12:00 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT015.mail.protection.outlook.com (10.152.75.146) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 07:11:59 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x767Buso019336
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 6 Aug 2019 00:11:56 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS7.ad.analog.com ([fe80::595b:ced1:cc03:539d%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 03:11:58 -0400
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
Thread-Index: AQHVS5V1fT5ht6Fx90STGsdhsWokyKbs8MQAgAE53oA=
Date:   Tue, 6 Aug 2019 07:11:57 +0000
Message-ID: <ce952e3f8d927cdbccb268d708b4e47179d69b06.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-16-alexandru.ardelean@analog.com>
         <20190805152832.GT24275@lunn.ch>
In-Reply-To: <20190805152832.GT24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <058EE176BC63FD498260CBC4F3D29F2E@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(39860400002)(136003)(2980300002)(199004)(189003)(26005)(1730700003)(54906003)(186003)(70206006)(8936002)(70586007)(86362001)(478600001)(356004)(7736002)(305945005)(6916009)(5640700003)(6246003)(8676002)(229853002)(5660300002)(106002)(7636002)(14454004)(2501003)(3846002)(316002)(76176011)(2906002)(6116002)(336012)(246002)(436003)(426003)(486006)(50466002)(2351001)(36756003)(11346002)(476003)(126002)(2486003)(446003)(118296001)(47776003)(7696005)(4326008)(23676004)(102836004)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR03MB4564;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19b8fa9d-ffdd-431e-a4dc-08d71a3d5feb
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BN7PR03MB4564;
X-MS-TrafficTypeDiagnostic: BN7PR03MB4564:
X-Microsoft-Antispam-PRVS: <BN7PR03MB456423495A45A9FB63752D72F9D50@BN7PR03MB4564.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: h1ipAVbMCMMRng+lk3bxutqQpTyu6rFbh2TPP1JE5BXv7XtXhZoAH9iyv61p557yLhSYHCXGgQakVOkdPssLgi7n9sC2fEVW75vZRGHgymb7cocVGzh1l3j1P+jUCFASbTBuXZMGrqQo+MtrnRyZJch288KLmhq6gr8FSeAVkGtDT4fgJxQAn5YsnGyCWQjr3xisTXcHVVP7tLFD5Jp57cfRH8Zza8L8QgvIt8XMP2OxYeG7Va8vGacGfolFih5bYxukw4J1PyFA8bssB+DyEQL+UAfNMqv6Gxgsm4DvV23+H6DUjhZA0I5Se5KV1QGrtKR3StbIzb5XmPln8eZfWEgzYn5NuHKg6Dk7X/vOvLFUPVuAicJuTgRa1h6sLhYeYr2cUYlpGGHkdOiloJ8KzNroNSeIk02y1iqCkvKMLfY=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 07:11:59.4970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b8fa9d-ffdd-431e-a4dc-08d71a3d5feb
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB4564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060079
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE3OjI4ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gPiArc3RydWN0IGFkaW5faHdfc3RhdCB7DQo+ID4gKwljb25zdCBj
aGFyICpzdHJpbmc7DQo+ID4gK3N0YXRpYyB2b2lkIGFkaW5fZ2V0X3N0cmluZ3Moc3RydWN0IHBo
eV9kZXZpY2UgKnBoeWRldiwgdTggKmRhdGEpDQo+ID4gK3sNCj4gPiArCWludCBpOw0KPiA+ICsN
Cj4gPiArCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKGFkaW5faHdfc3RhdHMpOyBpKyspIHsN
Cj4gPiArCQltZW1jcHkoZGF0YSArIGkgKiBFVEhfR1NUUklOR19MRU4sDQo+ID4gKwkJICAgICAg
IGFkaW5faHdfc3RhdHNbaV0uc3RyaW5nLCBFVEhfR1NUUklOR19MRU4pOw0KPiANCj4gWW91IGRl
ZmluZSBzdHJpbmcgYXMgYSBjaGFyICouIFNvIGl0IHdpbGwgYmUgb25seSBhcyBsb25nIGFzIGl0
IHNob3VsZA0KPiBiZS4gSG93ZXZlciBtZW1jcHkgYWx3YXlzIGNvcGllcyBFVEhfR1NUUklOR19M
RU4gYnl0ZXMsIGRvaW5nIG9mZiB0aGUNCj4gZW5kIG9mIHRoZSBzdHJpbmcgYW5kIGludG8gd2hh
dGV2ZXIgZm9sbG93cy4NCj4gDQoNCmhtbSwgd2lsbCB1c2Ugc3RybGNweSgpDQppIGJsaW5kZWRs
eSBjb3BpZWQgbWVtY3B5KCkgZnJvbSBzb21lIG90aGVyIGRyaXZlcg0KDQo+IA0KPiA+ICsJfQ0K
PiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IGFkaW5fcmVhZF9tbWRfc3RhdF9yZWdzKHN0
cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYsDQo+ID4gKwkJCQkgICBzdHJ1Y3QgYWRpbl9od19zdGF0
ICpzdGF0LA0KPiA+ICsJCQkJICAgdTMyICp2YWwpDQo+ID4gK3sNCj4gPiArCWludCByZXQ7DQo+
ID4gKw0KPiA+ICsJcmV0ID0gcGh5X3JlYWRfbW1kKHBoeWRldiwgTURJT19NTURfVkVORDEsIHN0
YXQtPnJlZzEpOw0KPiA+ICsJaWYgKHJldCA8IDApDQo+ID4gKwkJcmV0dXJuIHJldDsNCj4gPiAr
DQo+ID4gKwkqdmFsID0gKHJldCAmIDB4ZmZmZik7DQo+ID4gKw0KPiA+ICsJaWYgKHN0YXQtPnJl
ZzIgPT0gMCkNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArDQo+ID4gKwlyZXQgPSBwaHlfcmVhZF9t
bWQocGh5ZGV2LCBNRElPX01NRF9WRU5EMSwgc3RhdC0+cmVnMik7DQo+ID4gKwlpZiAocmV0IDwg
MCkNCj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+ICsNCj4gPiArCSp2YWwgPDw9IDE2Ow0KPiA+ICsJ
KnZhbCB8PSAocmV0ICYgMHhmZmZmKTsNCj4gDQo+IERvZXMgdGhlIGhhcmR3YXJlIGhhdmUgYSBz
bmFwc2hvdCBmZWF0dXJlPyBJcyB0aGVyZSBhIGRhbmdlciB0aGF0DQo+IGJldHdlZW4gdGhlIHR3
byByZWFkcyBzdGF0LT5yZWcxIHJvbGxzIG92ZXIgYW5kIHlvdSBlbmQgdXAgd2l0aCB0b28NCj4g
YmlnIGEgdmFsdWU/DQoNCmknbSBhZnJhaWQgaSBkb24ndCB1bmRlcnN0YW5kIGFib3V0IHRoZSBz
bmFwc2hvdCBmZWF0dXJlIHlvdSBhcmUgbWVudGlvbmluZzsNCmkuZS4gaSBkb24ndCByZW1lbWJl
ciBzZWVpbmcgaXQgaW4gb3RoZXIgY2hpcHM7DQoNCnJlZ2FyZGluZyB0aGUgZGFuZ2VyIHRoYXQg
c3RhdC0+cmVnMSByb2xscyBvdmVyLCBpIGd1ZXNzIHRoYXQgaXMgcG9zc2libGUsIGJ1dCBpdCdz
IGEgYml0IGhhcmQgdG8gZ3VhcmQgYWdhaW5zdDsNCmkgZ3Vlc3MgaWYgaXQgZW5kcyB1cCBpbiB0
aGF0IHNjZW5hcmlvLCBbZm9yIG1hbnkgY291bnRlcnNdIHRoaW5ncyB3b3VsZCBiZSBob3JyaWJs
eSBiYWQsIGFuZCB0aGUgY2hpcCwgb3IgY2FibGluZyB3b3VsZA0KYmUgdW51c2FibGU7DQoNCm5v
dCBzdXJlIGlmIHRoaXMgYW5zd2VyIGlzIHN1ZmZpY2llbnQvc2F0aXNmYWN0b3J5Ow0KDQp0aGFu
a3MNCg0KPiANCj4gICAgIEFuZHJldw0K
