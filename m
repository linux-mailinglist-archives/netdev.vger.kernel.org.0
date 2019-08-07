Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711958468D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 10:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387548AbfHGIBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 04:01:08 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:49308 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727331AbfHGIBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 04:01:08 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x777wQDq002420;
        Wed, 7 Aug 2019 04:00:57 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2059.outbound.protection.outlook.com [104.47.32.59])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6kb26u8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Aug 2019 04:00:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2Kqu6o9z9uluSaE7XR7qmXzm3PgofI+o8FO5dxipUEo61dY12dJW09guo0IlMwucUA3hKsIP+kpiC7jxMvtPChSij/4l82iPlt6iYgYXL1GyAW6xHS0tHn6tKJXk+NChsFqhBuOKSLbKhGTxscmA9wFSLH8VPlZu9HvtMyv9xaZJlxcoXVj0h2qAivxoLXQZsbE0UitUTSYv4IwSb9iHvjUaxMpGUYfXJxdH9xM+mp9QZAy6uzuXcbq2PuAZ23afRbDYTVp6PWMocIuaPI/UeNCoh81iR3IWFy0MrMFRBc6EBcjqApyz8bSvkZ3b8KfmrRPelWdENcl5iTbacrjdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EaiLou0IB/guU9MqYHz3ySobvJE6tBIUNzkI1PYd0s4=;
 b=LQaHMLCF3pC4+R6+2fZuq/ETXvwxjrw8WcDFarPmjn/9QKjGAJ75ivNAruU9HqXB52fBcw8YzHOTsRtRI7kAG0gRMPx2QbC0ETSnFuD8Ifp4hCQunilaCBXwnpbhy0e6NBqEeleBwoV0pYuisHp26rx6UU6Pyiieqrq6kEB6o8L0K0GXvZojJru9oW641xj8u8QXdPGAigLcQf9P9jdKqegj/4g7GdCl3jPgoAHzBFd2H0P+mAXJfqW3l2KkXMofApnMA+FPZe4tuH1XUILKKGMs3wIBI3fo40MD9Evx0pVVKz1oj7BYNP2raJHe75+mIYHF4lW5fHCELpLCZ2xKYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EaiLou0IB/guU9MqYHz3ySobvJE6tBIUNzkI1PYd0s4=;
 b=D3qB/gsnFJDZqRu2E0pH0M+ZbRSjEGMduDPkFLNLeZpodA0ONpFCTgA47WDwsMd6Skeetu8FkmIBYLbgfHvUUl7JG69Cjqhk9c95QCOuKw9+nwo5yTMfe9Nu8Kk2UCGnVVR77dIeZUZL/Fk3IMacWccIp8AwIWxKwleSlJCie6Q=
Received: from BN6PR03CA0007.namprd03.prod.outlook.com (2603:10b6:404:23::17)
 by CY1PR03MB2187.namprd03.prod.outlook.com (2a01:111:e400:c636::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15; Wed, 7 Aug
 2019 08:00:55 +0000
Received: from BL2NAM02FT039.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::207) by BN6PR03CA0007.outlook.office365.com
 (2603:10b6:404:23::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13 via Frontend
 Transport; Wed, 7 Aug 2019 08:00:54 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT039.mail.protection.outlook.com (10.152.77.152) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Wed, 7 Aug 2019 08:00:54 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7780sLi004082
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 7 Aug 2019 01:00:54 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS7.ad.analog.com ([fe80::595b:ced1:cc03:539d%12]) with mapi id
 14.03.0415.000; Wed, 7 Aug 2019 04:00:54 -0400
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
Subject: Re: [PATCH 06/16] net: phy: adin: support PHY mode converters
Thread-Topic: [PATCH 06/16] net: phy: adin: support PHY mode converters
Thread-Index: AQHVS5Vqk7PSp0S6xUqsUDBYjsprn6bs5k2AgAE9ZgCAAGJeAIABEkqA
Date:   Wed, 7 Aug 2019 08:00:53 +0000
Message-ID: <7747cb845a9122004b9565f444b4719170f74b35.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-7-alexandru.ardelean@analog.com>
         <20190805145105.GN24275@lunn.ch>
         <15cf5732415c313a7bfe610e7039e7c97b987073.camel@analog.com>
         <20190806153910.GB20422@lunn.ch>
In-Reply-To: <20190806153910.GB20422@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <134A0BE5A682A84CA3FF29E92A40ADAD@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(39860400002)(136003)(2980300002)(189003)(199004)(486006)(126002)(2906002)(7696005)(76176011)(476003)(2351001)(23676004)(2486003)(436003)(426003)(336012)(356004)(36756003)(478600001)(3846002)(6916009)(6116002)(446003)(50466002)(26005)(186003)(70206006)(70586007)(102836004)(2616005)(5640700003)(14454004)(229853002)(11346002)(47776003)(118296001)(316002)(305945005)(7636002)(7736002)(8676002)(246002)(2501003)(8936002)(106002)(5660300002)(4326008)(54906003)(1730700003)(6246003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR03MB2187;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35960d1f-28e3-4b7b-d5fc-08d71b0d5f7c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:CY1PR03MB2187;
X-MS-TrafficTypeDiagnostic: CY1PR03MB2187:
X-Microsoft-Antispam-PRVS: <CY1PR03MB21873630BDD72F3D99BE994CF9D40@CY1PR03MB2187.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 01221E3973
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ZiCpEjfGC4ODDXpLbk7stnK8TfA8bZbma1ozhHhh1v7zWUPtdcMbDE++0UULc7gXq9Aw2UNdvtewn9QUsvvTbX4XsHBtTQhlp9e192mcgRFrjBzDD3uDpz0RKrFWIqm9bpYnvxzKOibdlCiNVSkrD0yc1ygTM0oEMkXVUDX8WucEmMHw1yE7rVxFa+NQ6oHffB7hayYH3+3F2a8zI28xc0o3rbHaxlVOF1DszhrYqNUfFQtcrQKTnE7G3RKZHb0PmS1sh8eG3ZRKML6Bo2KPekdUTXXusNjr78254APIyPgFiB1XyjGz3iVQu2JsN0bDnisTN9885QFenPRV/aj7ZpdWQoajvCM3uyJLh6Q4z92mFwpmI8qOocwIuwf+9Xu8tqO7i+zOSWfjwEdClbwGZ50VKjnvrhV3+wKljcjiKRs=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2019 08:00:54.5745
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35960d1f-28e3-4b7b-d5fc-08d71b0d5f7c
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR03MB2187
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070086
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTA2IGF0IDE3OjM5ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gVHVlLCBBdWcgMDYsIDIwMTkgYXQgMDY6NDc6MDhBTSArMDAw
MCwgQXJkZWxlYW4sIEFsZXhhbmRydSB3cm90ZToNCj4gPiBPbiBNb24sIDIwMTktMDgtMDUgYXQg
MTY6NTEgKzAyMDAsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiA+ID4gW0V4dGVybmFsXQ0KPiA+ID4g
DQo+ID4gPiBPbiBNb24sIEF1ZyAwNSwgMjAxOSBhdCAwNzo1NDo0M1BNICswMzAwLCBBbGV4YW5k
cnUgQXJkZWxlYW4gd3JvdGU6DQo+ID4gPiA+IFNvbWV0aW1lcywgdGhlIGNvbm5lY3Rpb24gYmV0
d2VlbiBhIE1BQyBhbmQgUEhZIGlzIGRvbmUgdmlhIGENCj4gPiA+ID4gbW9kZS9pbnRlcmZhY2Ug
Y29udmVydGVyLiBBbiBleGFtcGxlIGlzIGEgR01JSS10by1SR01JSSBjb252ZXJ0ZXIsIHdoaWNo
DQo+ID4gPiA+IHdvdWxkIG1lYW4gdGhhdCB0aGUgTUFDIG9wZXJhdGVzIGluIEdNSUkgbW9kZSB3
aGlsZSB0aGUgUEhZIG9wZXJhdGVzIGluDQo+ID4gPiA+IFJHTUlJLiBJbiB0aGlzIGNhc2UgdGhl
cmUgaXMgYSBkaXNjcmVwYW5jeSBiZXR3ZWVuIHdoYXQgdGhlIE1BQyBleHBlY3RzICYNCj4gPiA+
ID4gd2hhdCB0aGUgUEhZIGV4cGVjdHMgYW5kIGJvdGggbmVlZCB0byBiZSBjb25maWd1cmVkIGlu
IHRoZWlyIHJlc3BlY3RpdmUNCj4gPiA+ID4gbW9kZXMuDQo+ID4gPiA+IA0KPiA+ID4gPiBTb21l
dGltZXMsIHRoaXMgY29udmVydGVyIGlzIHNwZWNpZmllZCB2aWEgYSBib2FyZC9zeXN0ZW0gY29u
ZmlndXJhdGlvbiAoaW4NCj4gPiA+ID4gdGhlIGRldmljZS10cmVlIGZvciBleGFtcGxlKS4gQnV0
LCBvdGhlciB0aW1lcyBpdCBjYW4gYmUgbGVmdCB1bnNwZWNpZmllZC4NCj4gPiA+ID4gVGhlIHVz
ZSBvZiB0aGVzZSBjb252ZXJ0ZXJzIGlzIGNvbW1vbiBpbiBib2FyZHMgdGhhdCBoYXZlIEZQR0Eg
b24gdGhlbS4NCj4gPiA+ID4gDQo+ID4gPiA+IFRoaXMgcGF0Y2ggYWxzbyBhZGRzIHN1cHBvcnQg
Zm9yIGEgYGFkaSxwaHktbW9kZS1pbnRlcm5hbGAgcHJvcGVydHkgdGhhdA0KPiA+ID4gPiBjYW4g
YmUgdXNlZCBpbiB0aGVzZSAoaW1wbGljaXQgY29udmVydCkgY2FzZXMuIFRoZSBpbnRlcm5hbCBQ
SFkgbW9kZSB3aWxsDQo+ID4gPiA+IGJlIHVzZWQgdG8gc3BlY2lmeSB0aGUgY29ycmVjdCByZWdp
c3RlciBzZXR0aW5ncyBmb3IgdGhlIFBIWS4NCj4gPiA+ID4gDQo+ID4gPiA+IGBmd25vZGVfaGFu
ZGxlYCBpcyB1c2VkLCBzaW5jZSB0aGlzIHByb3BlcnR5IG1heSBiZSBzcGVjaWZpZWQgdmlhIEFD
UEkgYXMNCj4gPiA+ID4gd2VsbCBpbiBvdGhlciBzZXR1cHMsIGJ1dCB0ZXN0aW5nIGhhcyBiZWVu
IGRvbmUgaW4gRFQgY29udGV4dC4NCj4gPiA+IA0KPiA+ID4gTG9va2luZyBhdCB0aGUgcGF0Y2gs
IHlvdSBzZWVtcyB0byBhc3N1bWUgcGh5LW1vZGUgaXMgd2hhdCB0aGUgTUFDIGlzDQo+ID4gPiB1
c2luZz8gVGhhdCBzZWVtcyByYXRoZXIgb2RkLCBnaXZlbiB0aGUgbmFtZS4gSXQgc2VlbXMgbGlr
ZSBhIGJldHRlcg0KPiA+ID4gc29sdXRpb24gd291bGQgYmUgdG8gYWRkIGEgbWFjLW1vZGUsIHdo
aWNoIHRoZSBNQUMgdXNlcyB0byBjb25maWd1cmUNCj4gPiA+IGl0cyBzaWRlIG9mIHRoZSBsaW5r
LiBUaGUgTUFDIGRyaXZlciB3b3VsZCB0aGVuIGltcGxlbWVudCB0aGlzDQo+ID4gPiBwcm9wZXJ0
eS4NCj4gPiA+IA0KPiA+IA0KPiA+IGFjdHVhbGx5LCB0aGF0J3MgYSBwcmV0dHkgZ29vZCBpZGVh
Ow0KPiA+IGkgZ3Vlc3MgaSB3YXMgbmFycm93LW1pbmRlZCB3aGVuIHdyaXRpbmcgdGhlIGRyaXZl
ciwgYW5kIGdvdCBzdHVjayBvbiBwaHkgc3BlY2lmaWNzLCBhbmQgZm9yZ290IGFib3V0IHRoZSBN
QUMtc2lkZTsNCj4gPiBbIGkgYWxzbyBjYXRjaCB0aGVzZSBkZXNpZ24gZWxlbWVudHMgd2hlbiBy
ZXZpZXdpbmcsIGJ1dCBpIGFsc28gc2VlbSB0byBtaXNzIHRoZW0gd2hlbiB3cml0aW5nIHN0dWZm
IHNvbWV0aW1lcyBdDQo+ID4gDQo+IA0KPiBIaSBBcmRlbGVhbg0KPiANCj4gV2Ugc2hvdWxkIGFs
c28gY29uc2lkZXIgdGhlIG1lZGlhIGNvbnZlcnRlciBpdHNlbGYuIEl0IGlzIHBhc3NpdmUsIG9y
DQo+IGRvZXMgaXQgbmVlZCBhIGRyaXZlci4gWW91IHNlZW1zIHRvIGJlIGNvbnNpZGVyaW5nIEdN
SUktdG8tUkdNSUkuIEJ1dA0KPiB3aGF0IGFib3V0IFJHTUlJIHRvIFNHTUlJPyBvciBSR01JSSB0
byAxMDAwQmFzZS1LWCBldGM/IElkZWFsbHkgd2UNCj4gd2FudCBhIGdlbmVyaWMgc29sdXRpb24g
YW5kIHdlIG5lZWQgdG8gdGhpbmsgYWJvdXQgYWxsIHRoZSBwYXJ0cyBpbg0KPiB0aGUgc3lzdGVt
Lg0KDQpJbiBvdXIgY2FzZSB0aGUgR01JSS10by1SR01JSSBjb252ZXJ0ZXIgaXMgcGFzc2l2ZSBh
bmQgZG9lcyBub3QgbmVlZCBhIGRyaXZlci4NCkl0J3MgYW4gSERML0ZQR0EgYmxvY2suDQpUaGVy
ZSBtYXkgYmUgb3RoZXIgY29udmVydGVycyB0aGF0IGRvIG5lZWQgYSBkcml2ZXIuDQpUbyBiZSBo
b25lc3QsIHRoZSBtdWx0aXR1ZGUgb2YgcG9zc2libGUgY29uZmlndXJhdGlvbnMgW2dpdmVuIHRo
YXQgaXQncyBGUEdBXSBjYW4gYmUuLi4gYSBsb3QuDQoNCkluIG9uZSBvZiBvdXIgY2FzZXMsIHNw
ZWNpZnlpbmcgdGhlIE1BQyBtb2RlIHRvIGJlIGRpZmZlcmVudCB0aGFuIFBIWSBtb2RlIFt3aGlj
aCBhc3N1bWVzIHRoYXQgdGhlcmUgaXMgYW4gaW1wbGljaXQNCnBhc3NpdmUgbWVkaWEgY29udmVy
dGVyIGluLWJldHdlZW5dIHdvcmtzLg0KDQpJIGFkbWl0IHRoYXQgYSBnZW5lcmljIHNvbHV0aW9u
IHdvdWxkIGJlIG5pY2UuDQpJcyBpdCBvayBpZiB3ZSBkZWZlciB0aGUgc29sdXRpb24gZm9yIHRo
aXMgZHJpdmVycy9wYXRjaHNldD8NCg0KSWYgeW91IHByb3Bvc2Ugc29tZXRoaW5nLCBJIGNhbiB0
YWtlIGEgbG9vayBhcyBwYXJ0IG9mIGEgZGlmZmVyZW50L25ldyBkaXNjdXNzaW9uLg0KDQpObyBn
dWFycmFudGVlcyBhYm91dCBob3cgc29vbiBpdCB3b3VsZCBiZSBpbXBsZW1lbnRlZC4NCg0KVGhh
bmtzDQpBbGV4DQoNCj4gDQo+ICAgICAgQW5kcmV3DQo=
