Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1078E82BEB
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731905AbfHFGoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:44:05 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:28228 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731644AbfHFGoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:44:05 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766X2E2018445;
        Tue, 6 Aug 2019 02:43:55 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2058.outbound.protection.outlook.com [104.47.37.58])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6yamrvh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:43:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L27BjJ/C4VWAqSv2YKCuNOA1Jpe74OkOpBpV2rD0mz1Pd6+zKgmqArNn51H6WqiWl6Q4jqt7+ei5U7G1kkCojLtb0ANwD3x9r+TeBbUc+6PyjrZX78VzbnfzGv7DNEUaz1PZuiNbEOVezRVsdzyUrIRFCJowcvABd4XcWPuUfAHONGIso8El0w74z472yKsoBR7PhBbrsYX8C7gLzL0IYKIOugzb/rYR5OshMm4hFR2vpphA36gTnFmo4VZpeZlsfrQ+KcbwUbdAZnEyJ65AjJPlWHwLAOhbqvs3OiFqQmx7eukdJyyZdm7dBn15NrZyd5/gpBil8fFj6dzgoZX8oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/cl33dTBsiNrhu4e1inNcqRhSXIaQy84B/fIsgG1nw=;
 b=Xz/HGQzDdkoqXEB9Lmud8ba1lpL7vOsD1/7YbJXmK7SvwqaB6WZRizwM3Q5unTTITQ8VIG76EB3Z5nb4QQYFYI5InoVufd7/M1hb4DEOQhaTnrTSCqkBCDYTCJULR5D/TCoBxyq9ReV9WJVMJTSx9Z1xtE6fy8E7lgDhommJ70gWrjPx94KrU7UDjWkt5FwCYYBQbLSGeb3j/aKszzEnvkGAkEJFVo3QzKgpNaDSOeocMh9Y4/Szx2zHkKXqDkfGgeQuFQJhN7TIw0gL4nmsMtFsEqOSNQ7paHqvTQY/nZ5JOyjSglFhl9MVBYMrnHbo2pukZ0nOdufg7LBX95HO/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/cl33dTBsiNrhu4e1inNcqRhSXIaQy84B/fIsgG1nw=;
 b=+AcB3MH5iG/MU63HdAbvVWY7K88Ye9auhHuuZhjAIf9OkSgO0DAzdAQFssaYJLceAXSpF30SJaO3KZFB5HTq+3cxPz9p3REN37bVL1uS4kv9C9CTTOtN4eE6zFElkzxn8zLGvxuJCcGbVGdLYStrwq6dnFreuc6gcu50uD5yWno=
Received: from BN8PR03CA0028.namprd03.prod.outlook.com (2603:10b6:408:94::41)
 by DM6PR03MB5164.namprd03.prod.outlook.com (2603:10b6:5:247::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.15; Tue, 6 Aug
 2019 06:43:53 +0000
Received: from CY1NAM02FT022.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by BN8PR03CA0028.outlook.office365.com
 (2603:10b6:408:94::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.13 via Frontend
 Transport; Tue, 6 Aug 2019 06:43:52 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT022.mail.protection.outlook.com (10.152.75.185) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:43:52 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x766hmPU013713
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:43:48 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:43:51 -0400
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
Subject: Re: [PATCH 05/16] net: phy: adin: configure RGMII/RMII/MII modes on
 config
Thread-Topic: [PATCH 05/16] net: phy: adin: configure RGMII/RMII/MII modes
 on config
Thread-Index: AQHVS5Vp0Zwne0AafUq2LM7GF1G9hqbs4xaAgAE/sQA=
Date:   Tue, 6 Aug 2019 06:43:50 +0000
Message-ID: <9e87a6c32b0426c66ba9fb7181083fab38f0b12f.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-6-alexandru.ardelean@analog.com>
         <20190805143935.GM24275@lunn.ch>
In-Reply-To: <20190805143935.GM24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BD9931A6D2B984F8F91BEED26737FB8@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(376002)(396003)(2980300002)(189003)(199004)(8936002)(70206006)(6116002)(229853002)(86362001)(6916009)(2351001)(76176011)(2906002)(14454004)(2501003)(305945005)(8676002)(1730700003)(7636002)(246002)(3846002)(36756003)(6246003)(70586007)(7736002)(186003)(106002)(54906003)(5640700003)(316002)(4326008)(486006)(126002)(476003)(2616005)(336012)(446003)(436003)(426003)(11346002)(50466002)(478600001)(7696005)(356004)(47776003)(23676004)(5660300002)(118296001)(26005)(102836004)(14444005)(2486003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB5164;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1ef12b4-91f7-42cd-6035-08d71a39722d
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:DM6PR03MB5164;
X-MS-TrafficTypeDiagnostic: DM6PR03MB5164:
X-Microsoft-Antispam-PRVS: <DM6PR03MB5164AD0B2850B142B8B25A45F9D50@DM6PR03MB5164.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: drpH4AxeiqEjB3t/Af9R/+XZLJIYubs6bvXofcOHMmP2wz8zQsjAWMto1eld25QSPSU1PeCy6sXwc8o747edBeK9yDHThSaLIELAeMl+rrFpE58lprKh/Joe5Y7kdzurgWMI9RToSOAj/gIgM0L1FlD4edX7PjLsXlbH2Tjpbm9p+rGAJUI3H0aiCK/VFTXX60FcsUTDQg/gnNZozlN6aYKYBZvJbchuQEm18S5E7QisT1/j2yOuuHT2pMn7R2WXbPRyISP7pzNfCsNxWOUZW0Hyu8A4Tgpz4iDbf0nd7p/bMG75VBFNIHL3oucJndPJcmkPT2YRJ4AH0yPm3PzDvrwPMY/S/Qq7sBpRd2Kfoq65FEub8R3cC3hoeNAG5ojfSFxM2XwmCzSYTViWOXrDYlBlDqNC5V19/1YtBRkTLYY=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:43:52.2054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ef12b4-91f7-42cd-6035-08d71a39722d
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5164
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

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE2OjM5ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gTW9uLCBBdWcgMDUsIDIwMTkgYXQgMDc6NTQ6NDJQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFRoZSBBRElOMTMwMCBjaGlwIHN1cHBv
cnRzIFJHTUlJLCBSTUlJICYgTUlJIG1vZGVzLiBEZWZhdWx0IChpZg0KPiA+IHVuY29uZmlndXJl
ZCkgaXMgUkdNSUkuDQo+ID4gVGhpcyBjaGFuZ2UgYWRkcyBzdXBwb3J0IGZvciBjb25maWd1cmlu
ZyB0aGVzZSBtb2RlcyB2aWEgdGhlIGRldmljZQ0KPiA+IHJlZ2lzdGVycy4NCj4gPiANCj4gPiBG
b3IgUkdNSUkgd2l0aCBpbnRlcm5hbCBkZWxheXMgKG1vZGVzIFJHTUlJX0lELFJHTUlJX1RYSUQs
IFJHTUlJX1JYSUQpLA0KPiANCj4gSXQgd291bGQgYmUgbmljZSB0byBhZGQgdGhlIG1pc3Npbmcg
c3BhY2UuDQo+IA0KPiA+IHRoZSBkZWZhdWx0IGRlbGF5IGlzIDIgbnMuIFRoaXMgY2FuIGJlIGNv
bmZpZ3VyYWJsZSBhbmQgd2lsbCBiZSBkb25lIGluDQo+ID4gYSBzdWJzZXF1ZW50IGNoYW5nZS4N
Cj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcnUgQXJkZWxlYW4gPGFsZXhhbmRydS5h
cmRlbGVhbkBhbmFsb2cuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9waHkvYWRpbi5j
IHwgNzkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCA3OCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9hZGluLmMgYi9kcml2ZXJzL25ldC9waHkvYWRp
bi5jDQo+ID4gaW5kZXggM2RkOWZlNTBmNGM4Li5kYmRiOGY2MDc0MWMgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9uZXQvcGh5L2FkaW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9hZGlu
LmMNCj4gPiBAQCAtMzMsMTQgKzMzLDkxIEBADQo+ID4gIAkgQURJTjEzMDBfSU5UX0hXX0lSUV9F
TikNCj4gPiAgI2RlZmluZSBBRElOMTMwMF9JTlRfU1RBVFVTX1JFRwkJCTB4MDAxOQ0KPiA+ICAN
Cj4gPiArI2RlZmluZSBBRElOMTMwMF9HRV9SR01JSV9DRkdfUkVHCQkweGZmMjMNCj4gPiArI2Rl
ZmluZSAgIEFESU4xMzAwX0dFX1JHTUlJX1JYSURfRU4JCUJJVCgyKQ0KPiA+ICsjZGVmaW5lICAg
QURJTjEzMDBfR0VfUkdNSUlfVFhJRF9FTgkJQklUKDEpDQo+ID4gKyNkZWZpbmUgICBBRElOMTMw
MF9HRV9SR01JSV9FTgkJCUJJVCgwKQ0KPiA+ICsNCj4gPiArI2RlZmluZSBBRElOMTMwMF9HRV9S
TUlJX0NGR19SRUcJCTB4ZmYyNA0KPiA+ICsjZGVmaW5lICAgQURJTjEzMDBfR0VfUk1JSV9FTgkJ
CUJJVCgwKQ0KPiA+ICsNCj4gPiArc3RhdGljIGludCBhZGluX2NvbmZpZ19yZ21paV9tb2RlKHN0
cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYsDQo+ID4gKwkJCQkgIHBoeV9pbnRlcmZhY2VfdCBpbnRm
KQ0KPiA+ICt7DQo+ID4gKwlpbnQgcmVnOw0KPiA+ICsNCj4gPiArCXJlZyA9IHBoeV9yZWFkX21t
ZChwaHlkZXYsIE1ESU9fTU1EX1ZFTkQxLCBBRElOMTMwMF9HRV9SR01JSV9DRkdfUkVHKTsNCj4g
PiArCWlmIChyZWcgPCAwKQ0KPiA+ICsJCXJldHVybiByZWc7DQo+ID4gKw0KPiA+ICsJaWYgKCFw
aHlfaW50ZXJmYWNlX21vZGVfaXNfcmdtaWkoaW50ZikpIHsNCj4gPiArCQlyZWcgJj0gfkFESU4x
MzAwX0dFX1JHTUlJX0VOOw0KPiA+ICsJCWdvdG8gd3JpdGU7DQo+ID4gKwl9DQo+ID4gKw0KPiA+
ICsJcmVnIHw9IEFESU4xMzAwX0dFX1JHTUlJX0VOOw0KPiA+ICsNCj4gPiArCWlmIChpbnRmID09
IFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSV9JRCB8fA0KPiA+ICsJICAgIGludGYgPT0gUEhZX0lO
VEVSRkFDRV9NT0RFX1JHTUlJX1JYSUQpIHsNCj4gPiArCQlyZWcgfD0gQURJTjEzMDBfR0VfUkdN
SUlfUlhJRF9FTjsNCj4gPiArCX0gZWxzZSB7DQo+ID4gKwkJcmVnICY9IH5BRElOMTMwMF9HRV9S
R01JSV9SWElEX0VOOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCWlmIChpbnRmID09IFBIWV9JTlRF
UkZBQ0VfTU9ERV9SR01JSV9JRCB8fA0KPiA+ICsJICAgIGludGYgPT0gUEhZX0lOVEVSRkFDRV9N
T0RFX1JHTUlJX1RYSUQpIHsNCj4gPiArCQlyZWcgfD0gQURJTjEzMDBfR0VfUkdNSUlfVFhJRF9F
TjsNCj4gPiArCX0gZWxzZSB7DQo+ID4gKwkJcmVnICY9IH5BRElOMTMwMF9HRV9SR01JSV9UWElE
X0VOOw0KPiA+ICsJfQ0KPiANCj4gTmljZS4gT2Z0ZW4gZHJpdmVyIHdyaXRlcnMgZm9yZ2V0IHRv
IGNsZWFyIHRoZSBkZWxheSwgdGhleSBvbmx5IHNldA0KPiBpdC4gTm90IHNvIGhlcmUuDQo+IA0K
PiBIb3dldmVyLCBpcyBjaGVja3BhdGNoIGhhcHB5IHdpdGggdGhpcz8gRWFjaCBoYWxmIG9mIHRo
ZSBpZi9lbHNlIGlzIGENCj4gc2luZ2xlIHN0YXRlbWVudCwgc28gdGhlIHt9IGFyZSBub3QgbmVl
ZGVkLg0KDQppdCBkaWQgbm90IGNvbXBsYWluOw0KdGhpcyB3aG9sZSBzZXJpZXMgaXMgY2hlY2tw
YXRjaCBmcmllbmRseSBbd2l0aCB0aGUgdmVyc2lvbiBvZiBjaGVja3BhdGNoIGluIG5ldC1uZXh0
XQ0KaSB0aGluayBpdCBjb21wbGFpbmVkIGFib3V0IHVuLWJhbGFuY2VkIGlmLWJsb2NrOyBzb21l
dGhpbmcgbGlrZToNCg0KYGBgDQppZiAoKSB7DQoNCn0gZWxzZQ0KICBzaW5nbGUtc3RhdGVtZW50
DQpgYGANCg0KYnV0IGNoZWNrcGF0Y2ggaXMgYWxzbyBhIG1vdmluZyB0YXJnZXQ7DQpzbyDCr1xf
KOODhClfL8KvDQoNCj4gDQo+ID4gKw0KPiA+ICt3cml0ZToNCj4gPiArCXJldHVybiBwaHlfd3Jp
dGVfbW1kKHBoeWRldiwgTURJT19NTURfVkVORDEsDQo+ID4gKwkJCSAgICAgQURJTjEzMDBfR0Vf
UkdNSUlfQ0ZHX1JFRywgcmVnKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGludCBhZGlu
X2NvbmZpZ19ybWlpX21vZGUoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldiwNCj4gPiArCQkJCSBw
aHlfaW50ZXJmYWNlX3QgaW50ZikNCj4gPiArew0KPiA+ICsJaW50IHJlZzsNCj4gPiArDQo+ID4g
KwlyZWcgPSBwaHlfcmVhZF9tbWQocGh5ZGV2LCBNRElPX01NRF9WRU5EMSwgQURJTjEzMDBfR0Vf
Uk1JSV9DRkdfUkVHKTsNCj4gPiArCWlmIChyZWcgPCAwKQ0KPiA+ICsJCXJldHVybiByZWc7DQo+
ID4gKw0KPiA+ICsJaWYgKGludGYgIT0gUEhZX0lOVEVSRkFDRV9NT0RFX1JNSUkpIHsNCj4gPiAr
CQlyZWcgJj0gfkFESU4xMzAwX0dFX1JNSUlfRU47DQo+ID4gKwkJZ290byB3cml0ZTsNCj4gDQo+
IGdvdG8/IFJlYWxseT8NCg0KeWVwOw0KcGVyc29uYWxseSwgaSB1c2VkIHRvIG5vdCBsaWtlIGl0
IGFsbCB0aGF0IG11Y2ggdXAgdW50aWwgYSBmZXcgeWVhcnMsIGJ1dCBzb21ldGltZXMgaXQgZmVl
bHMgaXQgY2FuIGhlbHAgd2l0aCBjcmVhdGluZw0KY2xlYW5lciBwYXRjaGVzIGluIGNlcnRhaW4g
Y29udGV4dHM7DQoNCmknbGwgcmUtc3BpbiB3aXRob3V0IGl0Ow0KDQo+IA0KPiA+ICsJfQ0KPiA+
ICsNCj4gPiArCXJlZyB8PSBBRElOMTMwMF9HRV9STUlJX0VOOw0KPiA+ICsNCj4gPiArd3JpdGU6
DQo+ID4gKwlyZXR1cm4gcGh5X3dyaXRlX21tZChwaHlkZXYsIE1ESU9fTU1EX1ZFTkQxLA0KPiA+
ICsJCQkgICAgIEFESU4xMzAwX0dFX1JNSUlfQ0ZHX1JFRywgcmVnKTsNCj4gPiArfQ0KPiA+ICsN
Cj4gPiAgc3RhdGljIGludCBhZGluX2NvbmZpZ19pbml0KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlk
ZXYpDQo+ID4gIHsNCj4gPiAtCWludCByYzsNCj4gPiArCXBoeV9pbnRlcmZhY2VfdCBpbnRlcmZh
Y2UsIHJjOw0KPiANCj4gZ2VucGh5X2NvbmZpZ19pbml0KCkgZG9lcyBub3QgcmV0dXJuIGEgcGh5
X2ludGVyZmFjZV90IQ0KDQpnb29kIHBvaW50Ow0Kd2lsbCBjaGVjazsNCg0KPiANCj4gPiAgDQo+
ID4gIAlyYyA9IGdlbnBoeV9jb25maWdfaW5pdChwaHlkZXYpOw0KPiA+ICAJaWYgKHJjIDwgMCkN
Cj4gPiAgCQlyZXR1cm4gcmM7DQo+ID4gIA0KPiA+ICsJaW50ZXJmYWNlID0gcGh5ZGV2LT5pbnRl
cmZhY2U7DQo+ID4gKw0KPiA+ICsJcmMgPSBhZGluX2NvbmZpZ19yZ21paV9tb2RlKHBoeWRldiwg
aW50ZXJmYWNlKTsNCj4gPiArCWlmIChyYyA8IDApDQo+ID4gKwkJcmV0dXJuIHJjOw0KPiA+ICsN
Cj4gPiArCXJjID0gYWRpbl9jb25maWdfcm1paV9tb2RlKHBoeWRldiwgaW50ZXJmYWNlKTsNCj4g
PiArCWlmIChyYyA8IDApDQo+ID4gKwkJcmV0dXJuIHJjOw0KPiA+ICsNCj4gPiArCWRldl9pbmZv
KCZwaHlkZXYtPm1kaW8uZGV2LCAiUEhZIGlzIHVzaW5nIG1vZGUgJyVzJ1xuIiwNCj4gPiArCQkg
cGh5X21vZGVzKHBoeWRldi0+aW50ZXJmYWNlKSk7DQo+IA0KPiBwaHlkZXZfZGJnKCksIG9yIG5v
dCBhdCBhbGwuDQoNCmFjaw0KDQo+IA0KPiAJICAgICAgQW5kcmV3DQo=
