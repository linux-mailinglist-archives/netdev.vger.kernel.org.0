Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC3B58795F
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406675AbfHIMGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:06:15 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:15252 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbfHIMGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 08:06:15 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79C3Cgt002322;
        Fri, 9 Aug 2019 08:06:06 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2053.outbound.protection.outlook.com [104.47.46.53])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u7xkj6y5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 08:06:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FSxZW+0Ltt9Pjst2UoEOa4RjaOScBXgWnZLNhQdMOS8rpoE/2mV+CR9wB4ltxutq+CvXO4pN5+LacxbzmzzaPkUlVyXmhz4zqrv0TLi4PshxRDfVCB0HvsGG4ycWmJfHoLUvbUfg2XCRpsL1wvT7gKgFoIv3FVglVV3x3+mzAK54x2L0lvNMZoqwhIv/+sclb0sOGUFtHqFM+V1F6zPY94YZ3ywVeDfRT9tu6opc/sFhF5CRfaXTF+RX9g8tfCs2Jjoql67jyCxQboM8VRUEdyDg1rramHVCoc1wupwKEtAvWqINIXiL3kq0mBuM0D7hm2rw3UFcU62+pHknk0AB5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYjUb13BEwYKNQbrj7LS5e74mio+Xg3ZBpJd5G48mEo=;
 b=AbJNYoFCLXXnAME9l2WjVD+Gnk4PmNhXzz3TQqd+lzKxK59e1n9jgOJ7RCv+ourf6S1CUn/2g1bXEJQ02uBNjY40z1FBL/st3RCNLgE8Ldj99GFawyaU0DTgTANUAhK/XOqE8uKAiY2PG6s/WwQpGPr56FrWgMo7i0OSc0J37sGb1ni369RGr9mgW5FFEOP8SVBNB/sSL5CbjGnz7cOPy23PSJRl5pgW4B80xYeiR8tRTggyXgEOlJpNDnLKyRMsa5mjHCufa//OHS5SJI0MgPhOU9kaaDBpKuenqVBzYCyy6e0TPPX+ICjwJoarcyUkss+T+6dnPNHiuCnFaUkerg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYjUb13BEwYKNQbrj7LS5e74mio+Xg3ZBpJd5G48mEo=;
 b=N/ATjOdVY9/m53OoZZDVuBvBnSRz+Zq8cfUYJYnAVWoHvrqrDI8QpWrZ1qrz22J2ttfJqS7Gi8zhwI8dNuVzFUaiT7N5hRYcmg+/teUX05SBQLNKxFtGzjLxNbw7WXvY0n1y1PYidbQ3WwCeAxjnoLISMvvnB53QegYfCpExg4M=
Received: from BN6PR03CA0054.namprd03.prod.outlook.com (2603:10b6:404:4c::16)
 by CO2PR03MB2309.namprd03.prod.outlook.com (2603:10b6:102:a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13; Fri, 9 Aug
 2019 12:06:02 +0000
Received: from BL2NAM02FT044.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by BN6PR03CA0054.outlook.office365.com
 (2603:10b6:404:4c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.16 via Frontend
 Transport; Fri, 9 Aug 2019 12:06:02 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT044.mail.protection.outlook.com (10.152.77.35) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 12:06:02 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79C61li003564
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 05:06:01 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Fri, 9 Aug 2019 08:06:01 -0400
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
Subject: Re: [PATCH v2 13/15] net: phy: adin: configure downshift on
 config_init
Thread-Topic: [PATCH v2 13/15] net: phy: adin: configure downshift on
 config_init
Thread-Index: AQHVTeUhGVe2tUsWyUqMTCQQruRr26bx6QYAgAARAQCAAQLZgA==
Date:   Fri, 9 Aug 2019 12:06:00 +0000
Message-ID: <7c9e9cc9c8b1694a5641a60378a3b0d3a672ac4d.camel@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
         <20190808123026.17382-14-alexandru.ardelean@analog.com>
         <420c8e15-3361-a722-4ad1-3c448b1d3bc1@gmail.com>
         <20190808203932.GP27917@lunn.ch>
In-Reply-To: <20190808203932.GP27917@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC713A5D76EBD948BE5C12C294848747@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(2980300002)(189003)(199004)(186003)(7636002)(229853002)(14454004)(6246003)(2501003)(478600001)(4326008)(70206006)(70586007)(486006)(126002)(446003)(11346002)(476003)(2616005)(102836004)(53546011)(36756003)(50466002)(118296001)(336012)(8676002)(3846002)(23676004)(76176011)(7696005)(54906003)(6116002)(26005)(2486003)(110136005)(8936002)(106002)(356004)(436003)(2906002)(86362001)(426003)(47776003)(246002)(316002)(5660300002)(305945005)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR03MB2309;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23c0a64d-0714-4d77-af24-08d71cc1f2a5
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CO2PR03MB2309;
X-MS-TrafficTypeDiagnostic: CO2PR03MB2309:
X-Microsoft-Antispam-PRVS: <CO2PR03MB23099BB41FA20A02292F71E1F9D60@CO2PR03MB2309.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: J1OwEUG0IL+aK2lh9HJ4gjA8rWrCRTmbDi18Wh5LfzTS5WuyxZMEn8qI6A2TNz7/W46g8RDgoT1MsZI1GCCdCT6RYf7/kjepaA8np3E7LCySWpZDgXc41TaP5pntLxNduKFJFzZELKWT38RqYKZ9//kcSyL2G4L1bstQqrTbM81khGvpRF8gs9Idby7CxqaKpt6BSIqRoW2Wx5VpwTa/kUpPd684m+htJpJAUVNeE1O5jaTp6BSpgVUZbZaaGxDE7XSu+FC/BGn79zMhwdw6PlvO2qjN5gytfyEeFpUJC8YYjR0xwv9trGo3dXAawjjM6z9T+SM+W0plCDDoqlOJ/ZhFRyGOONL7o1oVicVhwKYiXxm7lI4xRcxhG5SA8Mz2tnn364/Y5I6aAt/zJXUKfl8IdcJpU4JhmEhL1PzNtW0=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 12:06:02.0494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c0a64d-0714-4d77-af24-08d71cc1f2a5
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR03MB2309
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTA4IGF0IDIyOjM5ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gVGh1LCBBdWcgMDgsIDIwMTkgYXQgMDk6Mzg6NDBQTSArMDIw
MCwgSGVpbmVyIEthbGx3ZWl0IHdyb3RlOg0KPiA+IE9uIDA4LjA4LjIwMTkgMTQ6MzAsIEFsZXhh
bmRydSBBcmRlbGVhbiB3cm90ZToNCj4gPiA+IERvd24tc3BlZWQgYXV0by1uZWdvdGlhdGlvbiBt
YXkgbm90IGFsd2F5cyBiZSBlbmFibGVkLCBpbiB3aGljaCBjYXNlIHRoZQ0KPiA+ID4gUEhZIHdv
bid0IGRvd24tc2hpZnQgdG8gMTAwIG9yIDEwIGR1cmluZyBhdXRvLW5lZ290aWF0aW9uLg0KPiA+
ID4gDQo+ID4gPiBUaGlzIGNoYW5nZSBlbmFibGVzIGRvd25zaGlmdCBhbmQgY29uZmlndXJlcyB0
aGUgbnVtYmVyIG9mIHJldHJpZXMgdG8NCj4gPiA+IGRlZmF1bHQgOCAobWF4aW11bSBzdXBwb3J0
ZWQgdmFsdWUpLg0KPiA+ID4gDQo+ID4gPiBUaGUgY2hhbmdlIGhhcyBiZWVuIGFkYXB0ZWQgZnJv
bSB0aGUgTWFydmVsbCBQSFkgZHJpdmVyLg0KPiA+ID4gDQo+ID4gSW5zdGVhZCBvZiBhIGZpeGVk
IGRvd25zaGlmdCBzZXR0aW5nIChsaWtlIGluIHRoZSBNYXJ2ZWxsIGRyaXZlcikgeW91DQo+ID4g
bWF5IGNvbnNpZGVyIHRvIGltcGxlbWVudCB0aGUgZXRodG9vbCBwaHktdHVuYWJsZSBFVEhUT09M
X1BIWV9ET1dOU0hJRlQuDQo+IA0KPiBIaSBBbGV4YW5kcnUNCj4gDQo+IFVwcHMsIHNvcnJ5LCBt
eSBiYWQuDQo+IA0KPiBJIGxvb2tlZCBhdCBtYXJ2ZWxsX3NldF9kb3duc2hpZnQoKSwgYW5kIGFz
c3VtZWQgaXQgd2FzIGNvbm5lY3RlZCB0bw0KPiB0aGUgcGh5LXR1bmFibGUuIEkgaGF2ZSBwYXRj
aGVzIHNvbWV3aGVyZSB3aGljaCBkb2VzIHRoYXQuIEJ1dCB0aGV5DQo+IGhhdmUgbm90IG1hZGUg
aXQgaW50byBtYWlubGluZSB5ZXQuDQo+IA0KPiA+IFNlZSB0aGUgQXF1YW50aWEgUEhZIGRyaXZl
ciBmb3IgYW4gZXhhbXBsZS4NCj4gDQo+IFllcywgdGhhdCBkb2VzIGhhdmUgYWxsIHRoZSB0dW5h
YmxlIHN0dWZmLg0KDQpBY2suDQpXaWxsIHVzZSB0aGF0DQoNCj4gDQo+ICAgICAgQW5kcmV3DQo=
