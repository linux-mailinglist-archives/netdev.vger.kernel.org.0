Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1EE8465D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 09:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbfHGHxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 03:53:16 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:50418 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727331AbfHGHxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 03:53:16 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x777mbN3028253;
        Wed, 7 Aug 2019 03:53:02 -0400
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2051.outbound.protection.outlook.com [104.47.38.51])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7aq4tpu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Aug 2019 03:53:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmTJMvccd2H8Mi3wIdG7Xhv/c2/4XWLjFiY+2QsJxiZVxqTXRSeSgKuWrwCLZksU6VF+EhmdELRyHG67cO3TgyUBuUVM6o6kDGQlJWEFzNSuUPsj0pz3HlJBdY2M/cTeUN0l8jUNHDX5845dqiTXGr+jl4B7OpSgLv/KNaZo7CSGfFeh7BtPJutgFAKFL/qej8dmLuij0m/A3RTZ/y2AXyOHtww0h8kOAiVroeINx2HppSxeXHyv3GCUH1ZRjx4Dpapmsn3k4FwsX+M2xNRuUZA2Q9bQPKqscSTtAx6yLjJDgfG4RSb+uhlawonCkrWJYi4Napo5lAfg9NL8mbOyaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jiloh1JSYPV847HKbtbXCh/acUjKRn8Kao4PIefqv0E=;
 b=QfLRyJUscdU0uHVttcTWkuCyQTiryHEbk0jmy7wbWgZ2dw8ob/8UGTquJgnVvYLfWeVIq7gbpuSN0RDnUlLIwPqJai+nEFY+j1IlgPKTSkqfKaeERXtA3z6OECfObrUekO6Gm2HcV4VK2oC3FNBpx1rFAkILK8Eu9W8VLcmlQqLHb9KrxZAKwc2PNAgr1NTCUCzP8Dwzva/uAURGOgJqObBzbzsT2IqX03nvjFob6/PVkwbv3PLdUS1d9ZQ554sdplIAwMD2TTykeW6h3Typx6BmfGBkZaAfdr1fiaNWtBBsGZ6BrB+HXiWbmDwiDC18uevZ9Jw1OzAFHxsv9BudtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jiloh1JSYPV847HKbtbXCh/acUjKRn8Kao4PIefqv0E=;
 b=sQIq+tLPP8sekhNtc32vW92BvtNqxkpwZo42/KkeeV5/EM2FezxdWhLR1oFl4BH5/D7Aeq6xOIAp1kDdl/I8JPIW61yYflRZW1py4wIC1z446PNnVP0dE0OIS2NoEpo6HOgSlbmSlWorLsq2h1g2UESQwDUNpkvLeoOMVmq8lUU=
Received: from CH2PR03CA0001.namprd03.prod.outlook.com (2603:10b6:610:59::11)
 by BN7PR03MB3650.namprd03.prod.outlook.com (2603:10b6:406:c9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2115.10; Wed, 7 Aug
 2019 07:52:59 +0000
Received: from BL2NAM02FT056.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::207) by CH2PR03CA0001.outlook.office365.com
 (2603:10b6:610:59::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13 via Frontend
 Transport; Wed, 7 Aug 2019 07:52:59 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT056.mail.protection.outlook.com (10.152.77.221) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Wed, 7 Aug 2019 07:52:59 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x777qtJj003251
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 7 Aug 2019 00:52:55 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Wed, 7 Aug 2019 03:52:58 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH 15/16] net: phy: adin: add ethtool get_stats support
Thread-Topic: [PATCH 15/16] net: phy: adin: add ethtool get_stats support
Thread-Index: AQHVS5V1fT5ht6Fx90STGsdhsWokyKbs8MQAgAE53oCAAF2dAIABDeYA
Date:   Wed, 7 Aug 2019 07:52:58 +0000
Message-ID: <9a5e8fe7b617f887c2308b00f8825cac447a099a.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-16-alexandru.ardelean@analog.com>
         <20190805152832.GT24275@lunn.ch>
         <ce952e3f8d927cdbccb268d708b4e47179d69b06.camel@analog.com>
         <20190806154658.GC20422@lunn.ch>
In-Reply-To: <20190806154658.GC20422@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8C2C7551A30B74FA21E355ED40FF30F@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(396003)(376002)(2980300002)(189003)(199004)(76176011)(8676002)(1730700003)(11346002)(6246003)(446003)(2351001)(8936002)(7736002)(229853002)(246002)(478600001)(7636002)(5640700003)(50466002)(6116002)(102836004)(118296001)(4326008)(3846002)(186003)(2501003)(86362001)(26005)(5660300002)(316002)(6916009)(14454004)(486006)(2906002)(36756003)(305945005)(54906003)(106002)(70586007)(23676004)(70206006)(126002)(336012)(2486003)(476003)(436003)(2616005)(7696005)(47776003)(356004)(426003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR03MB3650;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bd3fef1-3799-472d-5d2d-08d71b0c4428
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BN7PR03MB3650;
X-MS-TrafficTypeDiagnostic: BN7PR03MB3650:
X-Microsoft-Antispam-PRVS: <BN7PR03MB3650AD38E0D5B8AEBD6AFDF5F9D40@BN7PR03MB3650.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 01221E3973
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: IJlewhdkJ1anhTc1X+HqcvtplgLyrU3sYdRnE512sQPzWEsBz2z87w33ED4zAqhpSNV2O8+VwBh+/F5BBudmLPSwKYDxVkgDt9Cb/MWliBbpjhz/6Ayu3Q1zmkEH9OrgiMYmjxWFn/fmEjoDPdoJ9wZVyjX7Y1UTc6uXYLVVDgWFK08BhsGkG0B/Crk0mBIZ1yW0InFhLFQ+pbHzFiGb5qicFbs4xPB46JR1VrdyTUwTJeP1AMg3abCw9pxBIFrvQqNbikeD3MET+T7lv6kSpgMyuGPyH343u4Sd/vh0ymm0b13pCMiIglkbGT5ILcpFgk2pvdaqPGtkzw6hZpoO1j2R8sU87DUWceZjhVBMn84erAxN8qLe9vOm2Ug7dNf53vL9ef153aMVydryMLc3mb6mCE6b8gvgVMJ5vcTFZl0=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2019 07:52:59.2247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd3fef1-3799-472d-5d2d-08d71b0c4428
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB3650
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTA2IGF0IDE3OjQ2ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gVHVlLCBBdWcgMDYsIDIwMTkgYXQgMDc6MTE6NTdBTSArMDAw
MCwgQXJkZWxlYW4sIEFsZXhhbmRydSB3cm90ZToNCj4gPiBPbiBNb24sIDIwMTktMDgtMDUgYXQg
MTc6MjggKzAyMDAsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiA+ID4gW0V4dGVybmFsXQ0KPiA+ID4g
DQo+ID4gPiA+ICtzdHJ1Y3QgYWRpbl9od19zdGF0IHsNCj4gPiA+ID4gKwljb25zdCBjaGFyICpz
dHJpbmc7DQo+ID4gPiA+ICtzdGF0aWMgdm9pZCBhZGluX2dldF9zdHJpbmdzKHN0cnVjdCBwaHlf
ZGV2aWNlICpwaHlkZXYsIHU4ICpkYXRhKQ0KPiA+ID4gPiArew0KPiA+ID4gPiArCWludCBpOw0K
PiA+ID4gPiArDQo+ID4gPiA+ICsJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoYWRpbl9od19z
dGF0cyk7IGkrKykgew0KPiA+ID4gPiArCQltZW1jcHkoZGF0YSArIGkgKiBFVEhfR1NUUklOR19M
RU4sDQo+ID4gPiA+ICsJCSAgICAgICBhZGluX2h3X3N0YXRzW2ldLnN0cmluZywgRVRIX0dTVFJJ
TkdfTEVOKTsNCj4gPiA+IA0KPiA+ID4gWW91IGRlZmluZSBzdHJpbmcgYXMgYSBjaGFyICouIFNv
IGl0IHdpbGwgYmUgb25seSBhcyBsb25nIGFzIGl0IHNob3VsZA0KPiA+ID4gYmUuIEhvd2V2ZXIg
bWVtY3B5IGFsd2F5cyBjb3BpZXMgRVRIX0dTVFJJTkdfTEVOIGJ5dGVzLCBkb2luZyBvZmYgdGhl
DQo+ID4gPiBlbmQgb2YgdGhlIHN0cmluZyBhbmQgaW50byB3aGF0ZXZlciBmb2xsb3dzLg0KPiA+
ID4gDQo+ID4gDQo+ID4gaG1tLCB3aWxsIHVzZSBzdHJsY3B5KCkNCj4gPiBpIGJsaW5kZWRseSBj
b3BpZWQgbWVtY3B5KCkgZnJvbSBzb21lIG90aGVyIGRyaXZlcg0KPiANCj4gSG9wZWZ1bGx5IHRo
YXQgZHJpdmVyIHVzZWQgY29uc3QgY2hhciBzdHJpbmdbRVRIX0dTVFJJTkdfTEVOXS4gVGhlbiBh
DQo+IG1lbWNweSBpcyBzYWZlLiBJZiBub3QsIHBsZWFzZSBsZXQgbWUga25vdyB3aGF0IGRyaXZl
ciB5b3UgY29waWVkLg0KDQpJdCB3YXMgYW4gb2xkZXIgTWFydmVsbCBQSFkgZHJpdmVyIChtYXJ2
ZWxsLmMpIDsgaW4gdmVyc2lvbiA0LjE0Lg0KSSB1c2VkIHRoYXQgYXMgYW4gaW5pdGlhbCB3b3Jr
LWJhc2UgZm9yIHdyaXRpbmcgdGhlIGRyaXZlci4NClRoZW4gSSBkaWQgdGhlIGNvbnZlcnNpb24g
dG8gYSBuZXdlciBrZXJuZWwsIHRoZW4gSSBhbHNvIGhhZCB0byBhbHNvIGNvbnNpZGVyIGFuIG9s
ZGVyIGtlcm5lbCwgdGhlbiBJIGdvdCBjb25mdXNlZCA6KQ0KDQpXZWxsLCBpbiBhbnkgY2FzZSwg
SSBhbSBzb2xlbHkgY29uc2lkZXJpbmcgbmV0LW5leHQgbWFzdGVyIChub3cpIGZvciB1cHN0cmVh
bWluZyB0aGlzLg0KDQo+IA0KPiA+IGknbSBhZnJhaWQgaSBkb24ndCB1bmRlcnN0YW5kIGFib3V0
IHRoZSBzbmFwc2hvdCBmZWF0dXJlIHlvdSBhcmUgbWVudGlvbmluZzsNCj4gPiBpLmUuIGkgZG9u
J3QgcmVtZW1iZXIgc2VlaW5nIGl0IGluIG90aGVyIGNoaXBzOw0KPiANCj4gSXQgaXMgZnJlcXVl
bmN5IGRvbmUgYXQgdGhlIE1BQyBsYXllciBmb3Igc3RhdGlzdGljcy4gWW91IHRlbGwgdGhlDQo+
IGhhcmR3YXJlIHRvIHNuYXBzaG90IGFsbCB0aGUgc3RhdGlzdGljcy4gSXQgYXRvbWljYWxseSBt
YWtlcyBhIGNvcHkgb2YNCj4gYWxsIHRoZSBzdGF0aXN0aWNzIGludG8gYSBzZXQgb2YgcmVnaXN0
ZXJzLiBUaGVzZSB2YWx1ZXMgYXJlIHRoZW4NCj4gc3RhdGljLCBhbmQgY29uc2lzdGVudCBiZXR3
ZWVuIGNvdW50ZXJzLiBZb3UgY2FuIHJlYWQgdGhlbSBvdXQga25vd2luZw0KPiB0aGV5IGFyZSBu
b3QgZ29pbmcgdG8gY2hhbmdlLg0KPiANCj4gPiByZWdhcmRpbmcgdGhlIGRhbmdlciB0aGF0IHN0
YXQtPnJlZzEgcm9sbHMgb3ZlciwgaSBndWVzcyB0aGF0IGlzDQo+ID4gcG9zc2libGUsIGJ1dCBp
dCdzIGEgYml0IGhhcmQgdG8gZ3VhcmQgYWdhaW5zdDsNCj4gDQo+IFRoZSBub3JtYWwgc29sdXRp
b24gaXMgdGhlIHJlYWQgdGhlIE1TQiwgdGhlIExTQiBhbmQgdGhlbiB0aGUgTVNCDQo+IGFnYWlu
LiBJZiB0aGUgTVNCIHZhbHVlIGhhcyBjaGFuZ2VkIGJldHdlZW4gdGhlIHR3byByZWFkcywgeW91
IGtub3cgYQ0KPiByb2xsIG92ZXIgaGFzIGhhcHBlbmVkLCBhbmQgeW91IG5lZWQgdG8gZG8gaXQg
YWxsIGFnYWluLg0KDQpobW07IG9rDQpJJ2xsIHRyeSB0byBsb29rIGZvciBhbiBleGlzdGluZyBl
eGFtcGxlIGZvciB0aGlzLg0KDQo+IA0KPiAgICAgIEFuZHJldw0K
