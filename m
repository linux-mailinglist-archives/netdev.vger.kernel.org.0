Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282958CF0C
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbfHNJIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:08:16 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:20196 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbfHNJIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 05:08:15 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7E93K5W013090;
        Wed, 14 Aug 2019 05:08:04 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2057.outbound.protection.outlook.com [104.47.37.57])
        by mx0b-00128a01.pphosted.com with ESMTP id 2ubtf8uddj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 05:08:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1N+HmwYrHfJ8DFhab+hNKm7GUbD4/d16kPeD1rY6JtYtvOhlHNLV13sHCy04hIyhIbstSp43h0Lmcd9sxV75CtHyA3yF/0AhpHoR8k1JMpG0DOLYEu0V0CHPjqeYd7OBJlP79LTAe+2m2GMoQeUkkOE0FK9NDIGoIu5JdSv43ZNTwWhOIht6DeuZdwn5apNN64aJfDdTPGt3rCtulJFOQRb+LrFrZfGEqtI1JzVin0Ryxj7y2bYd/wmd9hqXUyjfzH1CfUmgaI6Sq/piCm49py8W84Zdfg6VyVspb21terKTXarPGd19y+IV4MA9w1lBP/AdkAQJaONDK3/10b31g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtZTN/t1ucaspf0aM2E7Y7Wz8oNWMobuMKyNfWpOhLs=;
 b=hEgk5NXL2cEM4J3KuRTI6Vd02ycU64V+yASuaJrcswlR2kMCzY7IKcuY2z7ckvimBu+XPX59pGBeOp1lwm9TYMc4jCRN3hOrBBmXNXim6r0b1NSxvpMp2BaAcg3Ep+VvnEQXPl0jTsfyPNVHQJ/I2eBg1uMQWWT4qMDW+tMExTj/KgL2itb34nbCW6ZxhFeWtUUjEYOg48NeuM/wCou6vPaSvcGBX00NLJ66VuTwmNa7vFg1N2psVEaNMcS9DrCs+z15G76GcriKOPY0lF4gJ/COQIwN0aOa4fiHLMTccp+npsquLc7LYJ2SHwvbB8oRFcnMp+Y8w/6zyD42geZVZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtZTN/t1ucaspf0aM2E7Y7Wz8oNWMobuMKyNfWpOhLs=;
 b=db/iiBZEhvPfCYbnVbENpMRFp2/qwxy8kX1+lbdYsV2ECyVpaWPaoTuAUQif5Us5zpX7r26wzRDFLotQBdWM+D4yV0j+qY05Wg7nkjODirRthIldJqMifcBUCG5Vj+TgxA1WWz/doCMAF7C3wURH8S0+6g69N+sfdV557xMP+Mo=
Received: from BN6PR03CA0087.namprd03.prod.outlook.com (2603:10b6:405:6f::25)
 by SN6PR03MB4112.namprd03.prod.outlook.com (2603:10b6:805:be::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.23; Wed, 14 Aug
 2019 09:08:02 +0000
Received: from BL2NAM02FT014.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::205) by BN6PR03CA0087.outlook.office365.com
 (2603:10b6:405:6f::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.14 via Frontend
 Transport; Wed, 14 Aug 2019 09:08:02 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT014.mail.protection.outlook.com (10.152.76.154) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Wed, 14 Aug 2019 09:08:02 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7E981HB011016
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 14 Aug 2019 02:08:02 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Wed, 14 Aug 2019 05:08:01 -0400
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
Thread-Index: AQHVUQB9ToIHSOhtHEuH64MPKOTzBKb31s2AgAD/0ACAAcn1AA==
Date:   Wed, 14 Aug 2019 09:08:00 +0000
Message-ID: <2175a95d818172153e839f6bcf6d3d61a3e23dd8.camel@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
         <20190812112350.15242-14-alexandru.ardelean@analog.com>
         <20190812143315.GS14290@lunn.ch>
         <c3fdb21c40900dae0e52b02b98fe27924a76c256.camel@analog.com>
In-Reply-To: <c3fdb21c40900dae0e52b02b98fe27924a76c256.camel@analog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <801D42DBC9E2284CA5C33AF41B7E129C@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(396003)(346002)(2980300002)(54534003)(199004)(189003)(426003)(436003)(476003)(2616005)(70206006)(446003)(70586007)(14454004)(126002)(356004)(50466002)(11346002)(14444005)(102836004)(76176011)(118296001)(36756003)(336012)(486006)(186003)(5660300002)(2501003)(26005)(6116002)(316002)(246002)(2351001)(1730700003)(3846002)(54906003)(7696005)(305945005)(7736002)(7636002)(6246003)(8676002)(8936002)(106002)(23676004)(2486003)(4326008)(86362001)(478600001)(966005)(47776003)(229853002)(6916009)(6306002)(2906002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR03MB4112;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0a301d6-7f15-48f2-4699-08d72096e92a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:SN6PR03MB4112;
X-MS-TrafficTypeDiagnostic: SN6PR03MB4112:
X-MS-Exchange-PUrlCount: 1
X-Microsoft-Antispam-PRVS: <SN6PR03MB4112B0B99C67563AE4EE5915F9AD0@SN6PR03MB4112.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 01294F875B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: aiTwZvV0XwZ0HrPw/6I2deW9koYm7k7Q88DfVK8N09BpS3d2qTYS7u8eoG5Rl5/nvEosllCQTS30D6o1DMVTOt+dUYM4CZye6xNFtatplwFko6AbO33xXHh7TYCXxOAlRFVvCJdphA7xM3YW2wJGUnjFMNeRoOMVX9iDkFq1prgEigBv2L8SL5LlKn5cFCr36RtUYqL2HCZBtUaYyPWB4YDa2Mw5iQBB+HzqotRM5rS4H+dolYRiJBzMLms47CJs9ZmQJ5vp643A85LAU4Uwb+srg47P581iWlItpNs5JUV0eOr7jotYQn4BREcVkkqpSKR1k2NRTHVxgoVbCqyz3mb4TWGw7MnhRiKrQPbBeQnmbc4QkcDkxkANPM6+3+KMo/RGL3TKkBzofhV7Dulzx1hKr/Zdej0V1Wp07w9Uzqk=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2019 09:08:02.4298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a301d6-7f15-48f2-4699-08d72096e92a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB4112
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908140091
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTEzIGF0IDA4OjQ4ICswMzAwLCBBbGV4YW5kcnUgQXJkZWxlYW4gd3Jv
dGU6DQo+IE9uIE1vbiwgMjAxOS0wOC0xMiBhdCAxNjozMyArMDIwMCwgQW5kcmV3IEx1bm4gd3Jv
dGU6DQo+ID4gW0V4dGVybmFsXQ0KPiA+IA0KPiA+ID4gK3N0YXRpYyBpbnQgYWRpbl9yZWFkX21t
ZF9zdGF0X3JlZ3Moc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldiwNCj4gPiA+ICsJCQkJICAgc3Ry
dWN0IGFkaW5faHdfc3RhdCAqc3RhdCwNCj4gPiA+ICsJCQkJICAgdTMyICp2YWwpDQo+ID4gPiAr
ew0KPiA+ID4gKwlpbnQgcmV0Ow0KPiA+ID4gKw0KPiA+ID4gKwlyZXQgPSBwaHlfcmVhZF9tbWQo
cGh5ZGV2LCBNRElPX01NRF9WRU5EMSwgc3RhdC0+cmVnMSk7DQo+ID4gPiArCWlmIChyZXQgPCAw
KQ0KPiA+ID4gKwkJcmV0dXJuIHJldDsNCj4gPiA+ICsNCj4gPiA+ICsJKnZhbCA9IChyZXQgJiAw
eGZmZmYpOw0KPiA+ID4gKw0KPiA+ID4gKwlpZiAoc3RhdC0+cmVnMiA9PSAwKQ0KPiA+ID4gKwkJ
cmV0dXJuIDA7DQo+ID4gPiArDQo+ID4gPiArCXJldCA9IHBoeV9yZWFkX21tZChwaHlkZXYsIE1E
SU9fTU1EX1ZFTkQxLCBzdGF0LT5yZWcyKTsNCj4gPiA+ICsJaWYgKHJldCA8IDApDQo+ID4gPiAr
CQlyZXR1cm4gcmV0Ow0KPiA+ID4gKw0KPiA+ID4gKwkqdmFsIDw8PSAxNjsNCj4gPiA+ICsJKnZh
bCB8PSAocmV0ICYgMHhmZmZmKTsNCj4gPiA+ICsNCj4gPiA+ICsJcmV0dXJuIDA7DQo+ID4gPiAr
fQ0KPiA+IA0KPiA+IEl0IHN0aWxsIGxvb2tzIGxpa2UgeW91IGhhdmUgbm90IGRlYWx0IHdpdGgg
b3ZlcmZsb3cgZnJvbSB0aGUgTFNCIGludG8NCj4gPiB0aGUgTVNCIGJldHdlZW4gdGhlIHR3byBy
ZWFkcy4NCj4gDQo+IEFwb2xvZ2llcyBmb3IgZm9yZ2V0dGluZyB0byBhZGRyZXNzIHRoaXMuDQo+
IEkgZGlkIG5vdCBpbnRlbnRpb25hbGx5IGxlYXZlIGl0IG91dDsgdGhpcyBpdGVtIGdvdCBsb3N0
IGFmdGVyIFYxIFt3aGljaCBoYWQgdGhlIG1vc3QgcmVtYXJrc10uDQo+IENoYW5nZWxvZyBWMSAt
PiBWMiB3YXMgcXVpdGUgYnVsa3ksIGFuZCBJIGRpZCBub3QgbG9vayBhdCBWMSByZW1hcmtzIGFm
dGVyIEkgZmluaXNoZWQgVjIuDQo+IA0KPiBUaGFua3MgZm9yIHNuaXBwZXQuDQoNClNvLCBJIGhh
dmUgdG8gYXBvbG9naXplIGFnYWluIGhlcmUuDQpJIGd1ZXNzIEkgd2FzIGFuIGlkaW90L24wMGIg
YWJvdXQgdGhpcy4NCg0KVGhlIFBIWSBzdGF0cyBkbyBzdXBwb3J0IHNuYXBzaG90LCBhbmQgSSBz
eW5jLWVkIHdpdGggc29tZW9uZSBmcm9tIHRoZSBjaGlwLXRlYW0gdG8gY29uZmlybS4NCg0KQWxz
bywgZnJvbSB0aGUgZGF0YXNoZWV0WzFdIChwYWdlIDI5IC0gRlJBTUUgR0VORVJBVE9SIEFORCBD
SEVDS0VSIC0gNXRoIHBhcmFncmFwaCk6DQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KVGhlIGZyYW1lIGNoZWNrZXIgY291bnRz
IHRoZSBudW1iZXIgb2YgQ1JDIGVycm9ycyBhbmQgdGhlc2UgDQphcmUgcmVwb3J0ZWQgaW4gdGhl
IHJlY2VpdmUgZXJyb3IgY291bnRlciByZWdpc3RlciAoUnhFcnJDbnQgDQpyZWdpc3RlciwgIGFk
ZHJlc3MgMHgwMDE0KS4gVG8gZW5zdXJlIHN5bmNocm9uaXphdGlvbiBiZXR3ZWVuIA0KdGhlIGZy
YW1lIGNoZWNrZXIgZXJyb3IgY291bnRlciBhbmQgZnJhbWUgY2hlY2tlciBmcmFtZSBjb3VudGVy
cywNCmFsbCBvZiB0aGUgY291bnRlcnMgYXJlIGxhdGNoZWQgb25jZSB0aGUgcmVjZWl2ZSBlcnJv
ciBjb3VudGVyDQpyZWdpc3RlciBpcyByZWFkLiBIZW5jZSB3aGVuIHVzaW5nIHRoZSBmcmFtZSBj
aGVja2VyLCB0aGUNCnJlY2VpdmUgZXJyb3IgY291bnRlciBzaG91bGQgYmUgcmVhZCBmaXJzdCBh
bmQgdGhlbiBhbGwgdGhlIG90aGVyDQpmcmFtZSBjb3VudGVycyBhbmQgZXJyb3IgY291bnRlcnMg
c2hvdWxkIGJlIHJlYWQuIEEgbGF0Y2hlZCBjb3B5DQpvZiB0aGUgcmVjZWl2ZSBmcmFtZSBjb3Vu
dGVyIHJlZ2lzdGVyIGlzIGF2YWlsYWJsZSBpbiB0aGUNCkZjRnJtQ250SCBhbmQgRmNGcm1DbnRM
IHJlZ2lzdGVycyAocmVnaXN0ZXIgYWRkcmVzc2VzIDB4MUUuMHg5NDBBDQphbmQgMHgxRS4weDk0
MEIpLg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KDQpUaGVuIGluIHRoZSBkZXNjcmlwdGlvbiBvZiB0aGVzZSByZWdzLCBpdCBt
ZW50aW9ucyAocmVwZXRlYWRseSk6DQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpUaGlzIHJlZ2lzdGVyIGlzIGEgbGF0Y2hlZCBj
b3B5IG9mIGJpdHMgMzE6MTYgb2YgdGhlIDMyLWJpdA0KcmVjZWl2ZSBmcmFtZSBjb3VudGVyIHJl
Z2lzdGVyLiBXaGVuIHRoZSByZWNlaXZlIGVycm9yIGNvdW50ZXINCihSeEVyckNudCByZWdpc3Rl
ciBhZGRyZXNzIDB4MDAxNCkgaXMgcmVhZCwgdGhlIHJlY2VpdmUNCmZyYW1lDQpjb3VudGVyIHJl
Z2lzdGVyIGlzIGxhdGNoZWQuIEEgY29weSBvZiB0aGUgcmVjZWl2ZSBmcmFtZSBjb3VudGVyDQpy
ZWdpc3RlciBpcyBsYXRjaGVkIHdoZW4gUnhFcnJDbnQgaXMgcmVhZCBzbyB0aGF0DQp0aGUgZXJy
b3IgY291bnQNCmFuZCByZWNlaXZlIGZyYW1lIGNvdW50IGFyZSBzeW5jaHJvbml6ZWQNCi0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0N
Cg0KSSdsbCByZS1zcGluIHRoaXMgd2l0aCB0aGUgcmVuYW1lIG9mIHRoZSBzdHJpbmdzLCBhbmQg
bWF5YmUgZG8gYSBtaW5vciBwb2xpc2ggb2YgdGhlIGNvZGUuDQoNClRoYW5rcyAmIHNvcnJ5IGZv
ciB0aGUgbm9pc2UvdHJvdWJsZQ0KQWxleA0KDQpbMV0gaHR0cHM6Ly93d3cuYW5hbG9nLmNvbS9t
ZWRpYS9lbi90ZWNobmljYWwtZG9jdW1lbnRhdGlvbi9kYXRhLXNoZWV0cy9BRElOMTMwMC5wZGYN
Cg0KDQo+IA0KPiA+IAlkbyB7DQo+ID4gCQloaTEgPSBwaHlfcmVhZF9tbWQocGh5ZGV2LCBNRElP
X01NRF9WRU5EMSwgc3RhdC0+cmVnMik7DQo+ID4gCQlpZiAoaGkxIDwgMCkNCj4gPiAJCQlyZXR1
cm4gaGkxOw0KPiA+IAkJDQo+ID4gCQlsb3cgPSBwaHlfcmVhZF9tbWQocGh5ZGV2LCBNRElPX01N
RF9WRU5EMSwgc3RhdC0+cmVnMSk7DQo+ID4gCQlpZiAobG93IDwgMCkNCj4gPiAJCQlyZXR1cm4g
bG93Ow0KPiA+IA0KPiA+IAkJaGkyID0gcGh5X3JlYWRfbW1kKHBoeWRldiwgTURJT19NTURfVkVO
RDEsIHN0YXQtPnJlZzIpOw0KPiA+IAkJaWYgKGhpMiA8IDApDQo+ID4gCQkJcmV0dXJuIGhpMTsN
Cj4gPiAJfSB3aGlsZSAoaGkxICE9IGhpMikNCj4gPiANCj4gPiAJcmV0dXJuIGxvdyB8IChoaSA8
PCAxNik7DQo+ID4gDQo+ID4gCUFuZHJldw0K
