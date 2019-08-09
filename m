Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC8987A33
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406799AbfHIMdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:33:12 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:51970 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406516AbfHIMdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 08:33:12 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79CSKB8016853;
        Fri, 9 Aug 2019 08:33:02 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2058.outbound.protection.outlook.com [104.47.44.58])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfqd5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 08:33:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eT+W4+ImJuQN4hpg6G0qQ+y/YbNFRhOXzI7H9G9e09dilboKWrL9HTRFc6+9kQAwDms7UJRYTiSSo+TM8TRI2iqrRq9r7WEz+y0t7xzm8wl3jriwOV7/IckSg85LCL3Ox7TD2HUr0O6Ro3pQDvxxC3lKTtPwpMRXaJwk6otH9WaR83DvwXNVHWwubaJ3d+ggBInxq2oPvd8QyTQQ1LUQt8/oczDZ/MnD1EPug7LZvlRc1i+1hsdVC3Sfgsj4YPdYYYwW3cArznmdskPnTS0a2KgvHcHTRPahZ9rSLq+AdobMjgt19R6gbjt0bi/rEenkj4+RQdMEw4D5avuj2RXBfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zcIaZ6+KFP8nEjThb0+lgzamIiLnYupVGY0V9OHkzg=;
 b=MCq3EGDxpl9oFapK9UDVaoh2XSQTJV0xohatVvzZyERWDCI7hDnFQmyM3oYBfx6plWXsNlKMZr5g4HI+rfbo0uh0ZpwI4driz50vGlqB60LRJgDwFlgUcjIcOEhs0MljpatBIaWFQf/69OaHUJBGxvvOmm0cqmK9iHnvWNf7kbKuaaBk6sx1wG3I5iFUlpT92AOX1xqRDq92mdFlF9dffr6Q+gOfrfamTPY7JOrq6kGZxyrb0yaOgZESyHs1F++ZtGUEBJklYV5Lq9J3MUlhZiEpzS23ryK1qVpI9RSH7l9WeyZRx6qzTWz9W5RfYwojJagiuZzg++zo+1G43Hp3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zcIaZ6+KFP8nEjThb0+lgzamIiLnYupVGY0V9OHkzg=;
 b=QZwdk3T/rt9NDoSPLfs6yN2GLt++76z06b0+HCemG2QQ7/WteTfRmka8B1m0VPPLCEZ5jkHWY3WKHwtvaH/R/emXDxVRwGDgE2RFHahodBGKveTK26+K9L3OoZPDpOQ23QHX4TMY522NxC269Cjo5qS9wI61juBJXys0uxb80DI=
Received: from CY1PR03CA0021.namprd03.prod.outlook.com (2603:10b6:600::31) by
 DM6PR03MB5371.namprd03.prod.outlook.com (2603:10b6:5:24c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 12:33:01 +0000
Received: from BL2NAM02FT030.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by CY1PR03CA0021.outlook.office365.com
 (2603:10b6:600::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Fri, 9 Aug 2019 12:33:00 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT030.mail.protection.outlook.com (10.152.77.172) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 12:33:00 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x79CWvNT013132
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 05:32:57 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS7.ad.analog.com ([fe80::595b:ced1:cc03:539d%12]) with mapi id
 14.03.0415.000; Fri, 9 Aug 2019 08:33:00 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH v2 00/15] net: phy: adin: add support for Analog Devices
 PHYs
Thread-Topic: [PATCH v2 00/15] net: phy: adin: add support for Analog
 Devices PHYs
Thread-Index: AQHVTeUQ6709knvDyk+00n5WA4151abx1E6AgAEwG4A=
Date:   Fri, 9 Aug 2019 12:32:59 +0000
Message-ID: <b5bce55e4c19e0cd0b848f14c413586ef5c53514.camel@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
         <20190808.112431.1358324079415442430.davem@davemloft.net>
In-Reply-To: <20190808.112431.1358324079415442430.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E4521D3B1665946A42C0E06EA68FCA8@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(346002)(396003)(2980300002)(189003)(199004)(50466002)(126002)(7696005)(47776003)(11346002)(2616005)(476003)(446003)(426003)(336012)(436003)(86362001)(486006)(5660300002)(2501003)(356004)(23676004)(102836004)(6246003)(4326008)(26005)(2486003)(229853002)(8936002)(76176011)(186003)(478600001)(118296001)(246002)(70586007)(70206006)(5640700003)(966005)(316002)(106002)(3846002)(6116002)(2906002)(36756003)(1730700003)(6916009)(8676002)(2351001)(6306002)(14454004)(54906003)(305945005)(7636002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB5371;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb99609d-39ce-4ea3-9839-08d71cc5b755
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:DM6PR03MB5371;
X-MS-TrafficTypeDiagnostic: DM6PR03MB5371:
X-MS-Exchange-PUrlCount: 2
X-Microsoft-Antispam-PRVS: <DM6PR03MB5371A9CBE0702B236F40AD65F9D60@DM6PR03MB5371.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 1UurWGloNHnYKArDW/3in0IMOFQKbwlI5YkwSjIQcT6cdMGt9faLUYfOkscfEHO4aAiTmiL+EH/3bb3xYi7R9N1f62iWPtg56aoAlS02YVtnSkcufxVoKmSErZFu+iAMEngQcdaAqqx0OzvijF01nQpvMC13jypDdHIqvUSwdt8L9uPRyUq+ch+Z26JEuFaLzmBXxGB/9MAlrU/c0cIuS5prARtPXm+jZR1gsmoZoTHNB6IfHRI1xotpY9Xdjirfq2DXGmhyECryq0U418lMw5b2aWPlvm8hv+Rhg+BGQUUGWCQ2cQCMqMr9WIejwz6x/l6VwDTvvU0yotAvvrCMrpL1qHMJ36UGrKtRo3s1X1pGIk8PdwrANcLSsN00DHCKHti+miawkFDBA+WkPpzvdvjxCe76ZeOp/ynU5/dS7s4=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 12:33:00.5078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb99609d-39ce-4ea3-9839-08d71cc5b755
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5371
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTA4IGF0IDExOjI0IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IFtFeHRlcm5hbF0NCj4gDQo+IEZyb206IEFsZXhhbmRydSBBcmRlbGVhbiA8YWxleGFuZHJ1LmFy
ZGVsZWFuQGFuYWxvZy5jb20+DQo+IERhdGU6IFRodSwgOCBBdWcgMjAxOSAxNTozMDoxMSArMDMw
MA0KPiANCj4gPiBUaGlzIGNoYW5nZXNldCBhZGRzIHN1cHBvcnQgZm9yIEFuYWxvZyBEZXZpY2Vz
IEluZHVzdHJpYWwgRXRoZXJuZXQgUEhZcy4NCj4gPiBQYXJ0aWN1bGFybHkgdGhlIFBIWXMgdGhp
cyBkcml2ZXIgYWRkcyBzdXBwb3J0IGZvcjoNCj4gPiAgKiBBRElOMTIwMCAtIFJvYnVzdCwgSW5k
dXN0cmlhbCwgTG93IFBvd2VyIDEwLzEwMCBFdGhlcm5ldCBQSFkNCj4gPiAgKiBBRElOMTMwMCAt
IFJvYnVzdCwgSW5kdXN0cmlhbCwgTG93IExhdGVuY3kgMTAvMTAwLzEwMDAgR2lnYWJpdA0KPiA+
ICAgIEV0aGVybmV0IFBIWQ0KPiA+IA0KPiA+IFRoZSAyIGNoaXBzIGFyZSBwaW4gJiByZWdpc3Rl
ciBjb21wYXRpYmxlIHdpdGggb25lIGFub3RoZXIuIFRoZSBtYWluDQo+ID4gZGlmZmVyZW5jZSBi
ZWluZyB0aGF0IEFESU4xMjAwIGRvZXNuJ3Qgb3BlcmF0ZSBpbiBnaWdhYml0IG1vZGUuDQo+ID4g
DQo+ID4gVGhlIGNoaXBzIGNhbiBiZSBvcGVyYXRlZCBieSB0aGUgR2VuZXJpYyBQSFkgZHJpdmVy
IGFzIHdlbGwgdmlhIHRoZQ0KPiA+IHN0YW5kYXJkIElFRUUgUEhZIHJlZ2lzdGVycyAoMHgwMDAw
IC0gMHgwMDBGKSB3aGljaCBhcmUgc3VwcG9ydGVkIGJ5IHRoZQ0KPiA+IGtlcm5lbCBhcyB3ZWxs
LiBUaGlzIGFzc3VtZXMgdGhhdCBjb25maWd1cmF0aW9uIG9mIHRoZSBQSFkgaGFzIGJlZW4gZG9u
ZQ0KPiA+IGNvbXBsZXRlbHkgaW4gSFcsIGFjY29yZGluZyB0byBzcGVjLCBpLmUuIG5vIGV4dHJh
IFNXIGNvbmZpZ3VyYXRpb24NCj4gPiByZXF1aXJlZC4NCj4gPiANCj4gPiBUaGlzIGNoYW5nZXNl
dCBhbHNvIGltcGxlbWVudHMgdGhlIGFiaWxpdHkgdG8gY29uZmlndXJlIHRoZSBjaGlwcyB2aWEg
U1cNCj4gPiByZWdpc3RlcnMuDQo+ID4gDQo+ID4gRGF0YXNoZWV0czoNCj4gPiAgIGh0dHBzOi8v
d3d3LmFuYWxvZy5jb20vbWVkaWEvZW4vdGVjaG5pY2FsLWRvY3VtZW50YXRpb24vZGF0YS1zaGVl
dHMvQURJTjEzMDAucGRmDQo+ID4gICBodHRwczovL3d3dy5hbmFsb2cuY29tL21lZGlhL2VuL3Rl
Y2huaWNhbC1kb2N1bWVudGF0aW9uL2RhdGEtc2hlZXRzL0FESU4xMjAwLnBkZg0KPiA+IA0KPiA+
IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRydSBBcmRlbGVhbiA8YWxleGFuZHJ1LmFyZGVsZWFuQGFu
YWxvZy5jb20+DQo+IA0KPiBJIHRoaW5rLCBhdCBhIG1pbmltdW0sIHRoZSBjMjIgdnMuIGM0NSBp
c3N1ZXMgbmVlZCB0byBiZSBkaXNjdXNzZWQgbW9yZQ0KPiBhbmQgZXZlbiBpZiBubyBjb2RlIGNo
YW5nZXMgb2NjdXIgdGhlcmUgaXMgZGVmaW5pdGVseSBzb21lIGFkanVzdG1lbnRzDQo+IGFuZCBj
bGFpcmlmaWNhdGlvbnMgdGhhdCBuZWVkIHRvIG9jY3VyIG9uIHRoaXMgaXNzdWUgaW4gdGhlIGNv
bW1pdA0KPiBtZXNzYWdlcyBhbmQvb3IgZG9jdW1lbnRhdGlvbi4NCg0KSSBndWVzcyBJJ2xsIGRy
b3AvZGVmZXIgc29tZSBvZiB0aGUgQzQ1IHN0dWZmIGZvciBub3cuDQpJIGRvbid0IGtub3cgaG93
IGRlY2lzaW9ucyB3ZXJlIGRvbmUgd2hlbiB0aGUgY2hpcHMgd2VyZSBjcmVhdGVkLg0KSSBhbSB0
b2xkIHRoYXQgQzQ1IHdvcmtzLCBidXQgSSBtYXkgbmVlZCB0byBmaW5kIG91dCBtb3JlIG9uIG15
IGVuZCwgc2luY2UgSSBhbSBhbHNvIG5ldyB0by91bmNsZWFyIG9uIHNvbWUgaXRlbXMuDQoNCltN
eSBwZXJzb25hbCBmZWVsaW5nIGFib3V0IHRoaXNdDQpJIHRoaW5rIHRoZXJlIGFyZSBzb21lIGNv
bmZ1c2lvbnMgW2ludGVybmFsbHkgb24gb3VyIHNpZGVdIGFib3V0IHdoYXQgQzQ1IGlzIGFuZCBo
b3cgaXQgc2hvdWxkIGJlIGRvbmUuDQpJIGd1ZXNzIGl0J3MgcGFydCBvZiBkZXZlbG9waW5nIGtu
b3dsZWRnZS9za2lsbHMgZm9yIGRldmVsb3BpbmcgUEhZcyBhcyBhIGNvbXBhbnkuDQpUaGVyZSdz
IHBsZW50eSBvZiBrbm93bGVkZ2UgZm9yIGhvdyB0byBkbyB0aGUgZWxlY3RyaWNhbCwgbG93LXBv
d2VyLXN0dWZmLCBldGMsIGFuZCBldmVuIHRoZSBkYXRhc2hlZXQgc29tZXRpbWVzIGZlZWxzDQps
aWtlIGl0J3MgZm9yIGFuIEFEQy9EQUMuDQpbTXkgcGVyc29uYWwgZmVlbGluZyBhYm91dCB0aGlz
XQ0KDQpUaGFua3MNCkFsZXgNCg==
