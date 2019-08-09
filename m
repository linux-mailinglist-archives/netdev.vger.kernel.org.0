Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8949E8792C
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406623AbfHIMAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:00:32 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:26482 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726259AbfHIMAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 08:00:32 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79Bvwqv030603;
        Fri, 9 Aug 2019 08:00:21 -0400
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2056.outbound.protection.outlook.com [104.47.34.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u7xkj6xkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 08:00:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaeDsmM7Ckm4uwgvGYLegbHP3OZ1u4XBnxTQhm4Da+Iga7dK43M0W1YXQz3Cfyg2KejiIPxMzKa3sX570+cXx/2/F7hfalOuLFhH5JvLEpWAuJxW0vRmjyxZ7Dv0tr6i6KqzilIOyTaeZLfbwhtVkaLV3b8e168oyoVBpqflEdkTzd0jaeRkimIUWiGlvPnSWSlPsWNSb9eff475i2yq8hgHZVUl8tyI+6qQJMEdNU2WHO6D7Uiov+Ha4Pn3bKK86n0DOFjQ8R9WPlfJTfvtDjxkaN+LbMtGEFrSk7P0+P1gr34n4RMeoM8h4aNVr5sfaZnl3oJ5KXLRAgtpEvWTbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxEypGi1XkNv3BqBikFW0Kq/OELFIyKZ14sfixDRWEE=;
 b=KjaiDNCanCsQKgXom0NnAr4mylL6+Up5YOdLG2YiEg5bihy4aMFJp5BtxWpw2vumC2x1ZBLKb+MtSWZRJ34bq+2/wZGeYd5LDgeSjfEE7DuWS7D+gEq+Hh6i7LL1m2NNYY6M2sVmgQvi5nc5l8VpoFH0E4PYL9ZwGzjSzuTCquO4J91baCv9dXx8ZiiFUsQjU2O4RlAZEbB7GM61Ho+zPDTrlkHuHe7h/zXQYW0+kwOBsZ7zm2NITWju2gcHQxIVNe9G67X7TdvX/wwAA0vJhPn0ITli2QLB3HjoutZ2fvuzExmOYmLpdoCPKndOuf3PtonPQLEX57MCRGTyGkvvlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxEypGi1XkNv3BqBikFW0Kq/OELFIyKZ14sfixDRWEE=;
 b=WChoXlbzEwDejoCudd1vltZxvdghNCt/4An04/kEvphdmLG0f+OydaXRs3dRUHvJ2qwN71wmC6i+jQ5lAxyQgvN1dMJvG3weEFHbSGVJONQYt+JfIw7FCMHmnUKaKc08UG52Veh0aiYH3ZSEafjVUjyfRWOQW/0IX9u6NRYZxOQ=
Received: from CY1PR03CA0003.namprd03.prod.outlook.com (2603:10b6:600::13) by
 BYAPR03MB4821.namprd03.prod.outlook.com (2603:10b6:a03:137::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16; Fri, 9 Aug
 2019 12:00:19 +0000
Received: from CY1NAM02FT009.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::203) by CY1PR03CA0003.outlook.office365.com
 (2603:10b6:600::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Fri, 9 Aug 2019 12:00:19 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT009.mail.protection.outlook.com (10.152.75.12) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 12:00:18 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x79C0FKw004515
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 05:00:15 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS7.ad.analog.com ([fe80::595b:ced1:cc03:539d%12]) with mapi id
 14.03.0415.000; Fri, 9 Aug 2019 08:00:17 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v2 02/15] net: phy: adin: hook genphy_read_abilities()
 to get_features
Thread-Topic: [PATCH v2 02/15] net: phy: adin: hook genphy_read_abilities()
 to get_features
Thread-Index: AQHVTeUU3XI/oJXhpEankJT584hyQKbxoeKAgABFi4CAARPZgA==
Date:   Fri, 9 Aug 2019 12:00:17 +0000
Message-ID: <16511bd0d6421549b2968a9419e971923c0d0146.camel@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
         <20190808123026.17382-3-alexandru.ardelean@analog.com>
         <20190808152403.GB27917@lunn.ch>
         <eeda87c9-bdba-8ef7-6043-85a16bd2cfc2@gmail.com>
In-Reply-To: <eeda87c9-bdba-8ef7-6043-85a16bd2cfc2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9DA33D6E6744C46A1BA73A0E11EF19D@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(396003)(39860400002)(376002)(136003)(2980300002)(199004)(189003)(50466002)(70586007)(70206006)(86362001)(102836004)(2906002)(6246003)(305945005)(7636002)(7736002)(478600001)(8676002)(36756003)(53546011)(229853002)(8936002)(246002)(118296001)(106002)(11346002)(2616005)(476003)(486006)(336012)(126002)(436003)(426003)(446003)(14454004)(47776003)(110136005)(6116002)(3846002)(5660300002)(316002)(356004)(54906003)(2501003)(76176011)(7696005)(2486003)(23676004)(4326008)(26005)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4821;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c761b1ef-5f1e-4d4f-141e-08d71cc12667
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR03MB4821;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4821:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4821C2099B551AE05DC50405F9D60@BYAPR03MB4821.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: N4ki/5syX6sLdoAz5OgmgJ4pNCnuMe2OV2I7gWYvCBQqOxHrcGbhzYK2oG3Naw0M4qKighzISx0dFSs3qJGHaMGiBU001RLWtcmN7Kkee3QS9LRR/vka1y68t951hjDUZQOhWUvELFWWbA+OZZe1BZDEA6zFKGGsQi9upaicKL7HjL8mW/B4qOgA7aYnD5LqxORsKO9bvc04HFNAPfy/ra0PJ58aWMx2L5eaPN6qVhovhX0itdCDUEKY/yih5PjTyynWg0PDUVFjLSVRZ9Iyyzgua5uvRySa1ahLum5Ia+EDvUZ5A2ZNkNWS0h4wk/BpqilUwkX7ociinmjDH15A+SRhhM+xtxsnu39OunyMGa2MZTytUI2LQla4LGYWtwrEd7lSwTb2b6+qSAm3GuZQUEfomKr72fwclOjZbZq74MM=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 12:00:18.9535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c761b1ef-5f1e-4d4f-141e-08d71cc12667
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4821
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=737 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090125
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTA4IGF0IDIxOjMyICswMjAwLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6
DQo+IFtFeHRlcm5hbF0NCj4gDQo+IE9uIDA4LjA4LjIwMTkgMTc6MjQsIEFuZHJldyBMdW5uIHdy
b3RlOg0KPiA+IE9uIFRodSwgQXVnIDA4LCAyMDE5IGF0IDAzOjMwOjEzUE0gKzAzMDAsIEFsZXhh
bmRydSBBcmRlbGVhbiB3cm90ZToNCj4gPiA+IFRoZSBBRElOIFBIWXMgY2FuIG9wZXJhdGUgd2l0
aCBDbGF1c2UgNDUsIGhvd2V2ZXIgdGhleSBhcmUgbm90IHR5cGljYWwgZm9yDQo+ID4gPiBob3cg
cGh5bGliIGNvbnNpZGVycyBDbGF1c2UgNDUgUEhZcy4NCj4gPiA+IA0KPiA+ID4gSWYgdGhlIGBm
ZWF0dXJlc2AgZmllbGQgJiB0aGUgYGdldF9mZWF0dXJlc2AgaG9vayBhcmUgdW5zcGVjaWZpZWQs
IGFuZCB0aGUNCj4gPiA+IGRldmljZSB3YW50cyB0byBvcGVyYXRlIHZpYSBDbGF1c2UgNDUsIGl0
IHdvdWxkIGFsc28gdHJ5IHRvIHJlYWQgZmVhdHVyZXMNCj4gPiA+IHZpYSB0aGUgYGdlbnBoeV9j
NDVfcG1hX3JlYWRfYWJpbGl0aWVzKClgLCB3aGljaCB3aWxsIHRyeSB0byByZWFkIFBNQSByZWdz
DQo+ID4gPiB0aGF0IGFyZSB1bnN1cHBvcnRlZC4NCj4gPiA+IA0KPiA+ID4gSG9va2luZyB0aGUg
YGdlbnBoeV9yZWFkX2FiaWxpdGllcygpYCBmdW5jdGlvbiB0byB0aGUgYGdldF9mZWF0dXJlc2Ag
aG9vaw0KPiA+ID4gd2lsbCBlbnN1cmUgdGhhdCB0aGlzIGRvZXMgbm90IGhhcHBlbiBhbmQgdGhl
IFBIWSBmZWF0dXJlcyBhcmUgcmVhZA0KPiA+ID4gY29ycmVjdGx5IHJlZ2FyZGxlc3Mgb2YgQ2xh
dXNlIDIyIG9yIENsYXVzZSA0NSBvcGVyYXRpb24uDQo+ID4gDQo+ID4gSSB0aGluayB3ZSBuZWVk
IHRvIHN0b3AgYW5kIHRoaW5rIGFib3V0IGEgUEhZIHdoaWNoIHN1cHBvcnRzIGJvdGggQzIyDQo+
ID4gYW5kIEM0NS4NCj4gPiANCj4gPiBIb3cgZG9lcyBidXMgZW51bWVyYXRpb24gd29yaz8gSXMg
aXQgZGlzY292ZXJlZCB0d2ljZT8gIEkndmUgYWx3YXlzDQo+ID4gY29uc2lkZXJlZCBwaHlkZXYt
PmlzX2M0NSBtZWFucyBldmVyeXRoaW5nIGlzIGM0NSwgbm90IHRoYXQgc29tZQ0KPiA+IHJlZ2lz
dGVycyBjYW4gYmUgYWNjZXNzZWQgdmlhIGM0NS4gQnV0IHRoZSBkcml2ZXIgaXMgbWl4aW5nIGMy
MiBhbmQNCj4gPiBjNDUuIERvZXMgdGhlIGRyaXZlciBhY3R1YWxseSByZXF1aXJlIGM0NT8gQXJl
IHNvbWUgZmVhdHVyZXMgd2hpY2ggYXJlDQo+ID4gb25seSBhY2Nlc3NpYmx5IHZpYSBDNDU/IFdo
YXQgZG9lcyBDNDUgYWN0dWFsbHkgYnJpbmcgdXMgZm9yIHRoaXMNCj4gPiBkZXZpY2U/DQo+ID4g
DQoNCkhtbSwgSSBjYW4ndCBhbnN3ZXIgW2FsbF0gdGhlc2UgcXVlc3Rpb25zLg0KDQpUaGVzZSBQ
SFlzIHNlZW0gdG8gYmUgYSBiaXQgZGlmZmVyZW50IGZyb20gdGhlIHJlc3QgdGhhdCBJIGxvb2tl
ZCBhdCBpbiBkcml2ZXJzL25ldC9waHkgd2l0aCByZWdhcmQgdG8gQzQ1ICYgQzIyLg0KQW5kIEM0
NSBzZWVtcyB0byBiZSBtb3JlL2Nsb3NlciByZWxhdGVkIHRvIDEwRyBQSFlzIFtmcm9tIHdoYXQg
SSBjYW4gdGVsbF0uDQoNClRoZSBBRElOIFBIWXMgY2FuIG9wZXJhdGUgb25seSBpbiBDMjIuDQpU
aGUgb25seSB0aGluZyB0aGF0IGlzIG5lZWRlZCBbYW5kIGEgYml0IHNwZWNpYWxdIGlzIEVFRSwg
d2hpY2ggW2ZvciBDMjJdIHJlcXVpcmVzIHRoZSB0cmFuc2xhdGlvbiBsYXllciB0byBjb252ZXJ0
IEM0NQ0KcmVnIGFkZHJlc3NlcyB0byBpbnRlcm5hbCBDMjIgZXF1aXZhbGVudC4NCg0KPiBnZW5w
aHlfYzQ1X3BtYV9yZWFkX2FiaWxpdGllcygpIGlzIG9ubHkgY2FsbGVkIGlmIHBoeWRldi0+aXNf
YzQ1IGlzIHNldC4NCj4gQW5kIHRoaXMgZmxhZyBtZWFucyB0aGF0IHRoZSBQSFkgY29tcGxpZXMg
d2l0aCBDbGF1c2UgNDUgaW5jbC4gYWxsIHRoZQ0KPiBzdGFuZGFyZCBkZXZpY2VzIGxpa2UgUE1B
LiBJbiB0aGUgY2FzZSBoZXJlIG9ubHkgc29tZSB2ZW5kb3Itc3BlY2lmaWMNCj4gcmVnaXN0ZXJz
IGNhbiBiZSBhY2Nlc3NlZCB2aWEgQ2xhdXNlIDQ1IGFuZCB0aGVyZWZvcmUgaXNfYzQ1IHNob3Vs
ZG4ndA0KPiBiZXQgc2V0LiBBcyBhIGNvbnNlcXVlbmNlIHRoaXMgcGF0Y2ggaXNuJ3QgbmVlZGVk
Lg0KDQphY2ssIHdpbGwgZHJvcCBwYXRjaA0KDQo+IA0KPiA+ICAgICAgQW5kcmV3DQo+ID4gDQo+
IEhlaW5lcg0KPiANCg==
