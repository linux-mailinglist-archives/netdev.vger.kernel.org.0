Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F28E8AEE7
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 07:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfHMFnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 01:43:21 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:9608 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbfHMFnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 01:43:21 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7D5h09F008764;
        Tue, 13 Aug 2019 01:43:07 -0400
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2056.outbound.protection.outlook.com [104.47.38.56])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u9tj5y73w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Aug 2019 01:43:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0PfSf3tdRSCWvMDreWm/MBxB3blfxyGwAZfeJokHiQBmaSbfgQ3GqnNB+FCO+yoEoJ/rAoLgEfX50wMpu+GKC4IhgFLhq7hMYuWN31iFSMrHEol0sw37cBU7No992iRp4Cmao1b30sZGKlV3L0G1HTDkHQs9yoesAh5Uzv8VZLNRqrZVSxBa6DWGDHWIPEANt8Amporx0TcX2n4S3n873idvYbW2J3Yqkpod1czzhxjQqAdcINOFecwf1KvMrzrEEI9KbEzMq5v6rQxUbosXOOewR3NTF8xlLC6oGaWrLIMifKqa3i42dpQNtK3z5OSetzFwPDSzPLXdJy3BMiPNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOVxGM0CLBsKRxUgUq/f/4xyZkQJKuT6MtOIEoV29Ng=;
 b=LJJkv6j87VrAL30N4Yx3vBV4q9CtxoLqhw9agHMTo/hOChqjgK4O7ORjqWY+K592Zit9YrP+rpVID/bsdPvSGwFxNBOd0csb/bJkGt+cs1V50Dhu3HO2Mah8R3X8oeYuq7dpB5v3r+tduFiu3kT+3Ql7KMVwVeDn+3aNaCB6r1uyonWKr0Bjau+mZUDQpDyQLW14bNy4Xlszan63yYEcfrPa669P6CeH7T96uNNQBPFjMsXhL7rfZFFBxi4mP7YADXXLgrrxpKZIyPoD1Hh4RSPKY4E9uahAE2qVm1VCBNbydzV0dqCPDLeVGrgZj48yWVWs6GgaTaJQ3qaCWAs0ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOVxGM0CLBsKRxUgUq/f/4xyZkQJKuT6MtOIEoV29Ng=;
 b=w1N0jNZJMlFfn4lUV5IZy6H8B/wa8LVJkYszEfi3i79s57esZz0BRJRhDO5AsrkOoSewE/rDPIpoVdAahXqqclcuvU4+NSup1Pa4Dmhj972DNntnEmL7wDUNsc+WWqbyZ02vphKHqQuXqFfcyYw5kEaZigV+Azv1UgvWKyqc9wM=
Received: from BN6PR03CA0087.namprd03.prod.outlook.com (2603:10b6:405:6f::25)
 by BL0PR03MB4212.namprd03.prod.outlook.com (2603:10b6:208:69::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13; Tue, 13 Aug
 2019 05:42:59 +0000
Received: from CY1NAM02FT036.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by BN6PR03CA0087.outlook.office365.com
 (2603:10b6:405:6f::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Tue, 13 Aug 2019 05:42:59 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT036.mail.protection.outlook.com (10.152.75.124) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Tue, 13 Aug 2019 05:42:58 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7D5guuO018088
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 22:42:58 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Tue, 13 Aug 2019 01:42:56 -0400
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
Subject: Re: [PATCH v4 10/14] net: phy: adin: implement PHY subsystem
 software reset
Thread-Topic: [PATCH v4 10/14] net: phy: adin: implement PHY subsystem
 software reset
Thread-Index: AQHVUQB6s7FqfPTLWEC4Ig8ANUc2zKb30xIAgAEB4AA=
Date:   Tue, 13 Aug 2019 05:42:55 +0000
Message-ID: <916a477bb97aef904bdd1d84e85c92f6318b30df.camel@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
         <20190812112350.15242-11-alexandru.ardelean@analog.com>
         <20190812141954.GP14290@lunn.ch>
In-Reply-To: <20190812141954.GP14290@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0FF1E0F736A8B4389AC1EE977E5A777@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(346002)(136003)(2980300002)(189003)(199004)(5640700003)(186003)(2501003)(2616005)(4326008)(336012)(476003)(126002)(70586007)(118296001)(70206006)(6246003)(478600001)(229853002)(36756003)(2906002)(11346002)(446003)(14454004)(486006)(6916009)(86362001)(1730700003)(356004)(2351001)(5660300002)(76176011)(47776003)(7696005)(2486003)(23676004)(106002)(50466002)(316002)(8676002)(3846002)(246002)(54906003)(426003)(436003)(6116002)(102836004)(26005)(8936002)(7736002)(305945005)(7636002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR03MB4212;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 202d94a8-0004-473f-d494-08d71fb11990
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BL0PR03MB4212;
X-MS-TrafficTypeDiagnostic: BL0PR03MB4212:
X-Microsoft-Antispam-PRVS: <BL0PR03MB4212A3C8195C8B55C2B34D59F9D20@BL0PR03MB4212.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 01283822F8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: mcZuJieD0H9zxD9L003m1sCiXMYUSjVc5iv9m74u8Hz8ckDWs2lOIa056/iACQ490LSxaM6QSbd6JuCEcguQ97xGX293ZIPB5hjQzHp2uzr5i82JoTmVtCWuaQwy144em+ojOrMFSmuaNuyMqeDxHzWa+VmnVWmpjnGr8p2zKMA6Gh5HeIKS0ER4nt8XTa4B39GRTQwjbvyTNF54petdUeehJ5yeYRXVlLyq1yu9FD0TcRXGvg8VwgCWDYrbMJ3yoxzG6k7TDKi/z5LlD4036OaENSfv7J45WE27ODX8v5EBdKY9sz7COLx+KlyfEiNcynm9FX+yKWR5M1dYm28PKvwgplGBffbmKr3ZdjktkshJtr0sCG7gJc0DfFB0qURJO6iODn40KsSD8hE13pl4X92H1D9DxWoPrQ1efT2+GQ4=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2019 05:42:58.9504
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 202d94a8-0004-473f-d494-08d71fb11990
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR03MB4212
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=589 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTEyIGF0IDE2OjE5ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gPiArc3RhdGljIGludCBhZGluX3Jlc2V0KHN0cnVjdCBwaHlfZGV2
aWNlICpwaHlkZXYpDQo+ID4gK3sNCj4gPiArCS8qIElmIHRoZXJlIGlzIGEgcmVzZXQgR1BJTyBq
dXN0IGV4aXQgKi8NCj4gPiArCWlmICghSVNfRVJSX09SX05VTEwocGh5ZGV2LT5tZGlvLnJlc2V0
X2dwaW8pKQ0KPiA+ICsJCXJldHVybiAwOw0KPiANCj4gSSdtIG5vdCBzbyBoYXBweSB3aXRoIHRo
aXMuDQo+IA0KPiBGaXJzdCBvZmYsIHRoZXJlIGFyZSB0d28gcG9zc2libGUgR1BJTyBjb25maWd1
cmF0aW9ucy4gVGhlIEdQSU8gY2FuIGJlDQo+IGFwcGxpZWQgdG8gYWxsIFBIWXMgb24gdGhlIE1E
SU8gYnVzLiBUaGF0IEdQSU8gaXMgdXNlZCB3aGVuIHRoZSBidXMgaXMNCj4gcHJvYmVkLiBUaGVy
ZSBjYW4gYWxzbyBiZSBhIHBlciBQSFkgR1BJTywgd2hpY2ggaXMgd2hhdCB5b3UgYXJlDQo+IGxv
b2tpbmcgYXQgaGVyZS4NCj4gDQo+IFRoZSBpZGVhIG9mIHB1dHRpbmcgdGhlIEdQSU8gaGFuZGxp
bmcgaW4gdGhlIGNvcmUgaXMgdGhhdCBQSFlzIGRvbid0DQo+IG5lZWQgdG8gd29ycnkgYWJvdXQg
aXQuIEhvdyBtdWNoIG9mIGEgZGlmZmVyZW5jZSBkb2VzIGl0IG1ha2UgaWYgdGhlDQo+IFBIWSBp
cyBib3RoIHJlc2V0IHZpYSBHUElPIGFuZCB0aGVuIGFnYWluIGluIHNvZnR3YXJlPyBIb3cgc2xv
dyBpcyB0aGUNCj4gc29mdHdhcmUgcmVzZXQ/IE1heWJlIGp1c3QgdW5jb25kaXRpb25hbGx5IGRv
IHRoZSByZXNldCwgaWYgaXQgaXMgbm90DQo+IHRvbyBzbG93Lg0KPiANCg0KQWNrLg0KV2lsbCBk
byBpdCB1bmNvbmRpdGlvbmFsbHkuDQpUaGUgcmVzZXQgaXMgbm90IHRvbyBzbG93Lg0KDQoNCj4g
PiArDQo+ID4gKwkvKiBSZXNldCBQSFkgY29yZSByZWdzICYgc3Vic3lzdGVtIHJlZ3MgKi8NCj4g
PiArCXJldHVybiBhZGluX3N1YnN5dGVtX3NvZnRfcmVzZXQocGh5ZGV2KTsNCj4gPiArfQ0KPiA+
ICsNCj4gPiArc3RhdGljIGludCBhZGluX3Byb2JlKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYp
DQo+ID4gK3sNCj4gPiArCXJldHVybiBhZGluX3Jlc2V0KHBoeWRldik7DQo+ID4gK30NCj4gDQo+
IFdoeSBkaWQgeW91IGRlY2lkZSB0byBkbyB0aGlzIGFzIHBhcnQgb2YgcHJvYmUsIGFuZCBub3Qg
dXNlIHRoZQ0KPiAuc29mdF9yZXNldCBtZW1iZXIgb2YgcGh5X2RyaXZlcj8NCg0KSG1tbS4NClRo
aXMgaXMgYSBsZWZ0LW92ZXIgZnJvbSB3aGVuIEkgaGFkIHRoZSBHUElPIGhhbmRsaW5nIGluIHRo
aXMgUEhZIGRyaXZlci4NCkl0J3MgYWxzbyBhIGhhYml0IHBpY2tlZCB1cCBmcm9tIHdyaXRpbmcg
SUlPIGRyaXZlcnMsIHdoZXJlIHRoZXJlIGlzIG5vIHtzb2Z0X31yZXNldCBob29rLg0KVHlwaWNh
bGx5LCB0aGUgcmVzZXQgaXMgZG9uZSBpbiB0aGUgcHJvYmUuDQoNCj4gDQo+ID4gKw0KPiA+ICBz
dGF0aWMgc3RydWN0IHBoeV9kcml2ZXIgYWRpbl9kcml2ZXJbXSA9IHsNCj4gPiAgCXsNCj4gPiAg
CQlQSFlfSURfTUFUQ0hfTU9ERUwoUEhZX0lEX0FESU4xMjAwKSwNCj4gPiAgCQkubmFtZQkJPSAi
QURJTjEyMDAiLA0KPiA+ICAJCS5jb25maWdfaW5pdAk9IGFkaW5fY29uZmlnX2luaXQsDQo+ID4g
KwkJLnByb2JlCQk9IGFkaW5fcHJvYmUsDQo+ID4gIAkJLmNvbmZpZ19hbmVnCT0gYWRpbl9jb25m
aWdfYW5lZywNCj4gPiAgCQkucmVhZF9zdGF0dXMJPSBhZGluX3JlYWRfc3RhdHVzLA0KPiA+ICAJ
CS5hY2tfaW50ZXJydXB0CT0gYWRpbl9waHlfYWNrX2ludHIsDQo+ID4gQEAgLTQ2MSw2ICs1MDMs
NyBAQCBzdGF0aWMgc3RydWN0IHBoeV9kcml2ZXIgYWRpbl9kcml2ZXJbXSA9IHsNCj4gPiAgCQlQ
SFlfSURfTUFUQ0hfTU9ERUwoUEhZX0lEX0FESU4xMzAwKSwNCj4gPiAgCQkubmFtZQkJPSAiQURJ
TjEzMDAiLA0KPiA+ICAJCS5jb25maWdfaW5pdAk9IGFkaW5fY29uZmlnX2luaXQsDQo+ID4gKwkJ
LnByb2JlCQk9IGFkaW5fcHJvYmUsDQo+ID4gIAkJLmNvbmZpZ19hbmVnCT0gYWRpbl9jb25maWdf
YW5lZywNCj4gPiAgCQkucmVhZF9zdGF0dXMJPSBhZGluX3JlYWRfc3RhdHVzLA0KPiA+ICAJCS5h
Y2tfaW50ZXJydXB0CT0gYWRpbl9waHlfYWNrX2ludHIsDQo+IA0KPiBUaGFua3MNCj4gCUFuZHJl
dw0K
