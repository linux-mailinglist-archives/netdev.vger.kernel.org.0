Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEC382C3B
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 09:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732025AbfHFHDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 03:03:22 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:15544 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731557AbfHFHDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 03:03:22 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7671CAj012746;
        Tue, 6 Aug 2019 03:03:14 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2054.outbound.protection.outlook.com [104.47.44.54])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6yams2v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 03:03:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XW6b+Rd/ByrVcFQjEhIImbPddfbeNlKJAzBC81YKbtEVygR9P1LdF4orhM4J0l/9JE0wrJA3aIZstB1fMzj4iqi+bl4ck//DaYoA65KEPYD+msD5cvMM3YYcKHeglnuwVkCg+cDbt+v9Sopf6rrKHo9rajHEB5nOTuSQMYvvllcnRDk4z+dJfl3+FCG/9aQnLbvzBkGfbQfkMnMYcX3B9zl+GNsRyNWqZibhIgC0DwJL6RydHyZg+BizqcJ12jYa4iAr569TkRrmqIa+ilddpHQCkImLyr13hKDedUeZZ04Ny/7r0t05JmXBgdviTde1NSthvHCeaicYirJeNdhfgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ep+Y5OKCdBgzYCuwvDD74l8LPStthKlLrbLiIOjrcoE=;
 b=WpY4cIBDX1iBBPh87H4HQpgjT0jRXNWPuhulL35AQlmXu//mYsmOdExsuwxujXW8pOyv4dtgQ66rRsJbubIdpJCm2ivQnqHjeUbTIQvB5sSNKhSic5YYK5RWfIr5vyDBFB41X5npXOA/tBWgRQ7iyY3BX2+7T0L9gs5Lwan5JAc/4VAdMtKyaXgxH7nAXrHhp9+xuTEdQgBaR7jO/7qa/5yihlxJxBtbR13R2e8ZvQxxN/+OhCRrtpFgPQyjdmJNMd6NFH7MY5J8VPCiYshOfQ/Vxwrxli1hcS0JQ7+v98vnH1RJsGj6lyC6jB2Cc9y9gkOBWutfbsxYibQ4QXOaRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ep+Y5OKCdBgzYCuwvDD74l8LPStthKlLrbLiIOjrcoE=;
 b=C+/Sk1yj+UauhGAjxfIZqnRkSJH7KOb+xyp0aExoTPPJQ6uAqn+yCDDc9XeRX3zRmB003SEykCJxeZsKPz/GX3grQ7qsP4iD6qfSbGiHj4AwW4jACrbwbytZPrPDlQdprPuP1kS9pxWFM3oPK3SDVSw74cDqF0ETDZSKVbJN7sk=
Received: from MWHPR03CA0020.namprd03.prod.outlook.com (2603:10b6:300:117::30)
 by CY4PR03MB2662.namprd03.prod.outlook.com (2603:10b6:903:71::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.19; Tue, 6 Aug
 2019 07:03:12 +0000
Received: from SN1NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::206) by MWHPR03CA0020.outlook.office365.com
 (2603:10b6:300:117::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.16 via Frontend
 Transport; Tue, 6 Aug 2019 07:03:11 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT031.mail.protection.outlook.com (10.152.72.116) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 07:03:11 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x76737MR017338
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 6 Aug 2019 00:03:07 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS7.ad.analog.com ([fe80::595b:ced1:cc03:539d%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 03:03:10 -0400
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
Subject: Re: [PATCH 16/16] dt-bindings: net: add bindings for ADIN PHY driver
Thread-Topic: [PATCH 16/16] dt-bindings: net: add bindings for ADIN PHY
 driver
Thread-Index: AQHVS5V2ZSE3cdVgKEeipKzrb+Dq2Kbs2xoAgAFNE4A=
Date:   Tue, 6 Aug 2019 07:03:09 +0000
Message-ID: <c57fbc2348c4d93f1fbf53abd3252722ed02af68.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-17-alexandru.ardelean@analog.com>
         <20190805141100.GG24275@lunn.ch>
In-Reply-To: <20190805141100.GG24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2799503657AE7B49A3B233ED66A074C6@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(39860400002)(2980300002)(189003)(199004)(2616005)(70206006)(5660300002)(476003)(54906003)(11346002)(4326008)(486006)(2486003)(7696005)(446003)(436003)(426003)(336012)(76176011)(23676004)(8676002)(229853002)(6246003)(36756003)(316002)(106002)(1730700003)(5640700003)(126002)(7736002)(7636002)(305945005)(8936002)(478600001)(70586007)(2501003)(118296001)(6116002)(3846002)(246002)(86362001)(14444005)(47776003)(186003)(2906002)(102836004)(26005)(6916009)(14454004)(50466002)(2351001)(356004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB2662;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c902621a-38c0-4027-cb90-08d71a3c24f3
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:CY4PR03MB2662;
X-MS-TrafficTypeDiagnostic: CY4PR03MB2662:
X-Microsoft-Antispam-PRVS: <CY4PR03MB2662A5EDE0789F75CDB7CE08F9D50@CY4PR03MB2662.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: U1MtQELUsTlNlRdC0TtAMAvpT39/bNiwug6bX7A/ykHseTKGLzTqe9wj6qx9actm3EgW5+Xx1rb8UWyh+wS2Ddy1LhOTzeoFJRL9AN6udLKZn18mljvScaIEYiWPntWf7Nwt2DPUBlHnO8bXFblGFC0aBjedfC81nbaGACNK0VIa742XVwSa4qjggNdsyL//LZn8IJzKBgZTlw4By4MnthLBsg5LeXPQEox/XjOx24HNmaQm72QS58nM9+tfwhoSZ+ap9yuF3pCrGLYkjna8Nd0RHW7RaF2vNqraU5a8+yvt7krEUSKSUZ3E1tkIvf0qM+3F+btdCxUkTOIzr090mbnem8Si8DpxcbksPrZkocHUA6Vtmjt3h+G1Ki/rwPUGT7H5qpVpzT1VUu1iZTmWDGQeEq8cAhIYEupqkecLdEY=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 07:03:11.1369
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c902621a-38c0-4027-cb90-08d71a3c24f3
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB2662
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=960 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE2OjExICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gPiArICBhZGkscngtaW50ZXJuYWwtZGVsYXk6DQo+ID4gKyAgICAk
cmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy91aW50MzINCj4gPiArICAgIGRl
c2NyaXB0aW9uOiB8DQo+ID4gKyAgICAgIFJHTUlJIFJYIENsb2NrIERlbGF5IHVzZWQgb25seSB3
aGVuIFBIWSBvcGVyYXRlcyBpbiBSR01JSSBtb2RlIChwaHktbW9kZQ0KPiA+ICsgICAgICBpcyAi
cmdtaWktaWQiLCAicmdtaWktcnhpZCIsICJyZ21paS10eGlkIikgc2VlIGBkdC1iaW5kaW5ncy9u
ZXQvYWRpbi5oYA0KPiA+ICsgICAgICBkZWZhdWx0IHZhbHVlIGlzIDAgKHdoaWNoIHJlcHJlc2Vu
dHMgMiBucykNCj4gPiArICAgIGVudW06IFsgMCwgMSwgMiwgNiwgNyBdDQo+IA0KPiBXZSB3YW50
IHRoZXNlIG51bWJlcnMgdG8gYmUgaW4gbnMuIFNvIHRoZSBkZWZhdWx0IHZhbHVlIHdvdWxkIGFj
dHVhbGx5DQo+IGJlIDIuIFRoZSBkcml2ZXIgbmVlZHMgdG8gY29udmVydCB0aGUgbnVtYmVyIGlu
IERUIHRvIGEgdmFsdWUgdG8gcG9rZQ0KPiBpbnRvIGEgUEhZIHJlZ2lzdGVyLiBQbGVhc2UgcmVu
YW1lIHRoZSBwcm9wZXJ0eSBhZGkscngtaW50ZXJuYWwtZGVsYXktbnMuDQoNCmFjazsNCmFsc28s
IGdvb2QgcG9pbnQgYWJvdXQgbnMgdW5pdHMgYW5kIFBIWSBkcml2ZXIgdG8gY29udmVydCBpdCB0
byByZWcgdmFsdWVzOw0KDQo+IA0KPiA+ICsNCj4gPiArICBhZGksdHgtaW50ZXJuYWwtZGVsYXk6
DQo+ID4gKyAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy91aW50MzIN
Cj4gPiArICAgIGRlc2NyaXB0aW9uOiB8DQo+ID4gKyAgICAgIFJHTUlJIFRYIENsb2NrIERlbGF5
IHVzZWQgb25seSB3aGVuIFBIWSBvcGVyYXRlcyBpbiBSR01JSSBtb2RlIChwaHktbW9kZQ0KPiA+
ICsgICAgICBpcyAicmdtaWktaWQiLCAicmdtaWktcnhpZCIsICJyZ21paS10eGlkIikgc2VlIGBk
dC1iaW5kaW5ncy9uZXQvYWRpbi5oYA0KPiA+ICsgICAgICBkZWZhdWx0IHZhbHVlIGlzIDAgKHdo
aWNoIHJlcHJlc2VudHMgMiBucykNCj4gPiArICAgIGVudW06IFsgMCwgMSwgMiwgNiwgNyBdDQo+
IA0KPiBTYW1lIGhlcmUuDQo+IA0KPiA+ICsNCj4gPiArICBhZGksZmlmby1kZXB0aDoNCj4gPiAr
ICAgICRyZWY6IC9zY2hlbWFzL3R5cGVzLnlhbWwjL2RlZmluaXRpb25zL3VpbnQzMg0KPiA+ICsg
ICAgZGVzY3JpcHRpb246IHwNCj4gPiArICAgICAgV2hlbiBvcGVyYXRpbmcgaW4gUk1JSSBtb2Rl
LCB0aGlzIG9wdGlvbiBjb25maWd1cmVzIHRoZSBGSUZPIGRlcHRoLg0KPiA+ICsgICAgICBTZWUg
YGR0LWJpbmRpbmdzL25ldC9hZGluLmhgLg0KPiA+ICsgICAgZW51bTogWyAwLCAxLCAyLCAzLCA0
LCA1IF0NCj4gDQo+IFVuaXRzPyBZb3Ugc2hvdWxkIHByb2JhYmx5IHJlbmFtZSB0aGlzIGFkaSxm
aWZvLWRlcHRoLWJpdHMgYW5kIGxpc3QNCj4gdGhlIHZhbGlkIHZhbHVlcyBpbiBiaXRzLg0KDQp1
bml0cyBhcmUgYml0czsNCndpbGwgYWRhcHQgdGhpcw0KDQo+IA0KPiA+ICsNCj4gPiArICBhZGks
ZWVlLWVuYWJsZWQ6DQo+ID4gKyAgICBkZXNjcmlwdGlvbjogfA0KPiA+ICsgICAgICBBZHZlcnRp
c2UgRUVFIGNhcGFiaWxpdGllcyBvbiBwb3dlci11cC9pbml0IChkZWZhdWx0IGRpc2FibGVkKQ0K
PiA+ICsgICAgdHlwZTogYm9vbGVhbg0KPiANCj4gSXQgaXMgbm90IHRoZSBQSFkgd2hpY2ggZGVj
aWRlcyB0aGlzLiBUaGUgTUFDIGluZGljYXRlcyBpZiBpdCBpcyBFRUUNCj4gY2FwYWJsZSB0byBw
aHlsaWIuIHBoeWxpYiBsb29rcyBpbnRvIHRoZSBQSFkgcmVnaXN0ZXJzIHRvIGRldGVybWluZSBp
Zg0KPiB0aGUgUEhZIHN1cHBvcnRzIEVFRS4gcGh5bGliIHdpbGwgdGhlbiBlbmFibGUgRUVFDQo+
IGFkdmVydGlzZW1lbnQuIFBsZWFzZSByZW1vdmUgdGhpcywgYW5kIGVuc3VyZSBFRUUgaXMgZGlz
YWJsZWQgYnkNCj4gZGVmYXVsdC4NCg0KYWNrOw0Kd2lsbCByZW1vdmUNCg0KPiANCj4gCUFuZHJl
dw0K
