Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BADF830F1
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 13:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfHFLsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 07:48:06 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:8184 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726036AbfHFLsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 07:48:06 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x76BcW6M017021;
        Tue, 6 Aug 2019 07:47:56 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2053.outbound.protection.outlook.com [104.47.44.53])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6yamspwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 07:47:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JdIsTWuCqtFgZEwSxdyF5JOGzdRCZLqI9hihvWodWrKhIflSByX2OK7MEPR3XKc/G4oABqzKYhA29vTYU3RG3uQ18r5Urk6clrJvDjbSQPevZM5rcYp7n5lSptSlvMpwmFF6cO/wg7K8Dk8EIlxrjhMMkSygUe3xIBjYiuDRSE31CiP06ZmhXvf1ciznXpOBfANpB6pkQVacgGGCbNNFlX9HLqEbjCO5nOm+bGxYiVK4PRqjJ1YGKJkU0E7jXrbdzqzSTW7xMA+CC7qSl51aBdLgt+ll6tRMg1wyR3nX7qZs6E1ZX3la/UYcS2vxKF2MkZ+rTibHZB97Xr1ePfw8Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJBIvbu6npINpnqxqiBL6an32T00oM2zFdpaRRdJnaY=;
 b=UwlyFQe2AfUrSKPb4cxlYEHJFyq7GVtYM5Ao3oNSkVRnK2pO/RiIlCE6hH4m+V6eKQnP9MP2T8PwXmF3QklO/bH0yY8QHBLy1xr05TLl3tADJhkBsh3L0+1zoS62PyZZK2rUamQSQcwSejokCDta4QOsZzeSyY/mktwJYcWhiNhPVOSWnXKxLATLyEvJNeJpiwv2ZLlkUjtaHnP63hQgjp7ubQysJsBUj+8qdOo7FXXfTCfV7SDU3sGIlW8E8LQHd03ul/LUNLPPoPCZUdrE17ystBtgIQOKd0PnRxqHbTO2wfjec6TnHQaHgn7/ZrHqgbQbDTzmrvvBbCQaTZ9qVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJBIvbu6npINpnqxqiBL6an32T00oM2zFdpaRRdJnaY=;
 b=EQPCYlT/sC0wRXeT+SaXoL4KHgKExnwRzAsf5TGe7ayMgoIQdcelHZOoSiRVcJyObWL7Ju04dCyRp1/NglRsvgDEsC2P8+MDc5AiNhd8DOMibZ+iUTiC9t69tk3Od5cdWY2fsgOUrjT08noHPYsP9abf9jWO6YuCImVp9N6uFew=
Received: from CH2PR03CA0022.namprd03.prod.outlook.com (2603:10b6:610:59::32)
 by BYAPR03MB4886.namprd03.prod.outlook.com (2603:10b6:a03:13a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Tue, 6 Aug
 2019 11:47:54 +0000
Received: from BL2NAM02FT046.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::204) by CH2PR03CA0022.outlook.office365.com
 (2603:10b6:610:59::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.17 via Frontend
 Transport; Tue, 6 Aug 2019 11:47:53 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT046.mail.protection.outlook.com (10.152.76.118) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 11:47:53 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x76BlrN8015987
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 6 Aug 2019 04:47:53 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS7.ad.analog.com ([fe80::595b:ced1:cc03:539d%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 07:47:52 -0400
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
Thread-Index: AQHVS5V2ZSE3cdVgKEeipKzrb+Dq2Kbs2xoAgAFqVoA=
Date:   Tue, 6 Aug 2019 11:47:52 +0000
Message-ID: <264c84e1c8fc25594472c24b7fbba6502de1e3c9.camel@analog.com>
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
Content-ID: <5FB240558E3F0746A8B700871D56B416@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(376002)(346002)(2980300002)(199004)(189003)(86362001)(4326008)(5660300002)(6246003)(14444005)(1730700003)(8676002)(478600001)(47776003)(229853002)(6916009)(118296001)(11346002)(336012)(14454004)(436003)(2501003)(2616005)(8936002)(186003)(476003)(50466002)(126002)(486006)(5640700003)(26005)(446003)(36756003)(23676004)(2906002)(246002)(316002)(7696005)(70586007)(70206006)(106002)(54906003)(426003)(76176011)(356004)(6116002)(2351001)(3846002)(2486003)(102836004)(305945005)(7736002)(7636002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4886;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d5206c4-bcff-4d21-bb89-08d71a63eab7
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BYAPR03MB4886;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4886:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4886A5CFEC8BF94063C7BB25F9D50@BYAPR03MB4886.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: uOHJZ+EfRvQTmMNzIR8SzqFZqgMgahRHYxKzfVHt7rrSZ8S5aIbl8zhuQ8k/+KuB6oinhpUIqlSuQxlfCxqsn0Y0yWaxZk0Z4MUIQlg5eeC3wUaf04L5ZNcS2ZtJ/X1yp2GjiRO6451hptnSjUm8170eY2agY04X0g/OzJkjFOkeMSwmO+EY3c19dZZSIPu0T9MBkbeSb2EaMqmADLt8PqQvVZGjigDriNVOp5JKvVQxsvc4uFQ/lxlQYxkXe1/z8tJRvaCkQ5p4mSSnM+Phb9qbjEeyTBxiEVOgfv3fxIwEtdT/FuqXKuBbNxuzkZWS82aSdsiIbjSHTwDpBum3VCH+wJx4lb+P8r53V430ls269k7pii9aHCxQyawaOe8t+Zv34PmindMjaIfbdkG5Pw23YH8DZu6e4F5E/eIQqxk=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 11:47:53.7187
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5206c4-bcff-4d21-bb89-08d71a63eab7
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4886
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=902 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060119
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
YW1lIHRoZSBwcm9wZXJ0eSBhZGkscngtaW50ZXJuYWwtZGVsYXktbnMuDQo+IA0KDQpJIGp1c3Qg
cmVhbGl6ZWQ6IHRoaXMgd2lsbCBwcm9iYWJseSBoYXZlIHRvIGJlIHBpY28tc2Vjb25kcy4NClNv
bWUgZGVsYXlzIGFyZSAxLjYwIG5zLCB3aGljaCBhcmUgbm90IGVhc3kgdG8gcmVwcmVzZW50IGlu
IGluIG5zIGluIERULg0KDQpUaGUgdmFsdWVzIGhlcmUgYXJlIGFjdHVhbGx5IHRoZSByZWdpc3Rl
ciB2YWx1ZXMgY29ycmVzcG9uZGluZyB0byB0aGUgZGVsYXlzLg0KDQo+ID4gKw0KPiA+ICsgIGFk
aSx0eC1pbnRlcm5hbC1kZWxheToNCj4gPiArICAgICRyZWY6IC9zY2hlbWFzL3R5cGVzLnlhbWwj
L2RlZmluaXRpb25zL3VpbnQzMg0KPiA+ICsgICAgZGVzY3JpcHRpb246IHwNCj4gPiArICAgICAg
UkdNSUkgVFggQ2xvY2sgRGVsYXkgdXNlZCBvbmx5IHdoZW4gUEhZIG9wZXJhdGVzIGluIFJHTUlJ
IG1vZGUgKHBoeS1tb2RlDQo+ID4gKyAgICAgIGlzICJyZ21paS1pZCIsICJyZ21paS1yeGlkIiwg
InJnbWlpLXR4aWQiKSBzZWUgYGR0LWJpbmRpbmdzL25ldC9hZGluLmhgDQo+ID4gKyAgICAgIGRl
ZmF1bHQgdmFsdWUgaXMgMCAod2hpY2ggcmVwcmVzZW50cyAyIG5zKQ0KPiA+ICsgICAgZW51bTog
WyAwLCAxLCAyLCA2LCA3IF0NCj4gDQo+IFNhbWUgaGVyZS4NCj4gDQo+ID4gKw0KPiA+ICsgIGFk
aSxmaWZvLWRlcHRoOg0KPiA+ICsgICAgJHJlZjogL3NjaGVtYXMvdHlwZXMueWFtbCMvZGVmaW5p
dGlvbnMvdWludDMyDQo+ID4gKyAgICBkZXNjcmlwdGlvbjogfA0KPiA+ICsgICAgICBXaGVuIG9w
ZXJhdGluZyBpbiBSTUlJIG1vZGUsIHRoaXMgb3B0aW9uIGNvbmZpZ3VyZXMgdGhlIEZJRk8gZGVw
dGguDQo+ID4gKyAgICAgIFNlZSBgZHQtYmluZGluZ3MvbmV0L2FkaW4uaGAuDQo+ID4gKyAgICBl
bnVtOiBbIDAsIDEsIDIsIDMsIDQsIDUgXQ0KPiANCj4gVW5pdHM/IFlvdSBzaG91bGQgcHJvYmFi
bHkgcmVuYW1lIHRoaXMgYWRpLGZpZm8tZGVwdGgtYml0cyBhbmQgbGlzdA0KPiB0aGUgdmFsaWQg
dmFsdWVzIGluIGJpdHMuDQo+IA0KPiA+ICsNCj4gPiArICBhZGksZWVlLWVuYWJsZWQ6DQo+ID4g
KyAgICBkZXNjcmlwdGlvbjogfA0KPiA+ICsgICAgICBBZHZlcnRpc2UgRUVFIGNhcGFiaWxpdGll
cyBvbiBwb3dlci11cC9pbml0IChkZWZhdWx0IGRpc2FibGVkKQ0KPiA+ICsgICAgdHlwZTogYm9v
bGVhbg0KPiANCj4gSXQgaXMgbm90IHRoZSBQSFkgd2hpY2ggZGVjaWRlcyB0aGlzLiBUaGUgTUFD
IGluZGljYXRlcyBpZiBpdCBpcyBFRUUNCj4gY2FwYWJsZSB0byBwaHlsaWIuIHBoeWxpYiBsb29r
cyBpbnRvIHRoZSBQSFkgcmVnaXN0ZXJzIHRvIGRldGVybWluZSBpZg0KPiB0aGUgUEhZIHN1cHBv
cnRzIEVFRS4gcGh5bGliIHdpbGwgdGhlbiBlbmFibGUgRUVFDQo+IGFkdmVydGlzZW1lbnQuIFBs
ZWFzZSByZW1vdmUgdGhpcywgYW5kIGVuc3VyZSBFRUUgaXMgZGlzYWJsZWQgYnkNCj4gZGVmYXVs
dC4NCj4gDQo+IAlBbmRyZXcNCg==
