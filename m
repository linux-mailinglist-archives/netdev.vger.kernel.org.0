Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8C3E44F0
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437403AbfJYHzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:55:32 -0400
Received: from mail-eopbgr00050.outbound.protection.outlook.com ([40.107.0.50]:31904
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727275AbfJYHzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 03:55:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SI+52Eklg5XRtRVxCJla11Lsrgzy8qBZWB205aXFmrHnQbYOHV4JcLwBV7hoq3ovhkyyRe3YadSMI6wDSOVuNRbxAhJEc3oDbpz6PZWWPd82no5vsRFctt24VyOmy+tcikw1bKap6ty83LsxfaaezBewIonNg1yR6yN+iCDnX1mmZ1UnIXfLgkfIglvGYIRHwNCz4ebzdd3LBRyms+spyTAHDDQt53/3snpVbZ/Q9w6V/9pTc0wK8RFOBgD7LFxd4Y1igj1e40I7A8dFu44iGr70vSb12LdRRY18q0Ip2tTW/Qfd+7/0faGZeNqU7ZR14K1gierIH1hikxjpc+CDQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBTSy0bL6ISv0X1G/DsqRr63ptHihYCNrfZ8B7g1aFM=;
 b=RZeoWgjVjnOaWMpr+l5q7dFp8Sno6qZT4g6H+tX5i1DBKIyTG/H4eqZCR81TmxgALYVmRxkrvUWRaHSKhEc5+GAk5LHqDe/ZM+TuTpplRl7daewU3C2xi/6cW/vE7xWOELbKmrYoyrEiSmLdAuAxxRCaEeUvE7P0hbDsSVPLKarwdwqpkLSdqcVulT0gyw4FIwOYNYRBLcomswdhHWZ1A2gFZswBnEUNIG4BmzavzgLyQ7SAeMKMRnFldNVDcmKwLISKpueBpxtuUwHyXzZ4OVMnj0KVj4NGyzQS8iljK+j3Ovc2I8SDJEP2YttQFbKIHqLemStExVYZnOwojHABrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wolfvision.net; dmarc=pass action=none
 header.from=wolfvision.net; dkim=pass header.d=wolfvision.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolfvision.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBTSy0bL6ISv0X1G/DsqRr63ptHihYCNrfZ8B7g1aFM=;
 b=1JGuzi7xRdSfmlbwjDb3Kq1Mxsk3c0vNrUrJ1nbhq6TiGRKwOTDXu+SKr2I7zulMxY1RI+CXlwhM/H+Bdlpk5tpw9xiTVXRSRquA0wO7+nc6eJpO+HFqR4+vvRYi7K/kNkC6qOk/9RJI4XEVJ82jjpPnRGbdT34aPNg8wPYOzGw=
Received: from VI1PR08MB3358.eurprd08.prod.outlook.com (52.133.15.144) by
 VI1PR08MB3118.eurprd08.prod.outlook.com (52.133.15.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Fri, 25 Oct 2019 07:55:27 +0000
Received: from VI1PR08MB3358.eurprd08.prod.outlook.com
 ([fe80::8161:607a:cde6:dc5]) by VI1PR08MB3358.eurprd08.prod.outlook.com
 ([fe80::8161:607a:cde6:dc5%3]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 07:55:27 +0000
From:   =?utf-8?B?VGhvbWFzIEjDpG1tZXJsZQ==?= 
        <Thomas.Haemmerle@wolfvision.net>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "m.tretter@pengutronix.de" <m.tretter@pengutronix.de>
Subject: Re: [PATCH v2] net: phy: dp83867: support Wake on LAN
Thread-Topic: [PATCH v2] net: phy: dp83867: support Wake on LAN
Thread-Index: AQHViNmIBuwAQVqun0KwdtwDQqiwwqdqX86AgAChngA=
Date:   Fri, 25 Oct 2019 07:55:27 +0000
Message-ID: <a2ad0905-bcb8-5af5-4688-218617c790ca@wolfvision.net>
References: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
 <1571749572-9736-1-git-send-email-thomas.haemmerle@wolfvision.net>
 <20191024.151659.1029282183844084836.davem@davemloft.net>
In-Reply-To: <20191024.151659.1029282183844084836.davem@davemloft.net>
Accept-Language: de-AT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P195CA0008.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::18) To VI1PR08MB3358.eurprd08.prod.outlook.com
 (2603:10a6:803:47::16)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Haemmerle@wolfvision.net; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [91.118.163.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16fe6e42-e950-45bf-83c6-08d75920b32c
x-ms-traffictypediagnostic: VI1PR08MB3118:
x-microsoft-antispam-prvs: <VI1PR08MB3118530883773265602905BFED650@VI1PR08MB3118.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(39840400004)(396003)(136003)(189003)(199004)(31696002)(65806001)(66066001)(65956001)(6116002)(386003)(81156014)(81166006)(316002)(8936002)(58126008)(31686004)(85202003)(54906003)(229853002)(486006)(256004)(71190400001)(71200400001)(6916009)(6486002)(4744005)(8676002)(36756003)(476003)(11346002)(446003)(86362001)(2616005)(3846002)(7736002)(305945005)(6436002)(6246003)(85182001)(66446008)(66476007)(76176011)(66556008)(99286004)(4326008)(5660300002)(26005)(6512007)(186003)(53546011)(52116002)(508600001)(2906002)(6506007)(66946007)(14454004)(25786009)(102836004)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR08MB3118;H:VI1PR08MB3358.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wolfvision.net does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QmiIuuJLWfCLaWxt9rIooV2W2cVilOZsuMO8/IJnfDfg9iI9l//IWNdgQM2mdtAPwvi2PvrRIY8oCQgJxWtNyGPdj29tfSae5AxM4eVUeRmfTQHGV6OcmPTjZ6wHN12jcucc7zH3xJNKYsa0SY/Mxa/LFqvZoDtnYomA4RTb9RK5t46MhGdaHWCAc2EXclydJYc4l8bi9bqhHdQ7GV72mA0lkUbpAmiQa9XMFV5xG9kOOJkmmYZ5O1dP9SVKbCnKEituc+KHbF8Ol5UPZ0bKm6f1vhuAum/kGYBVLguv+ZFvlrdjITAgVe9QQol5vCe3TAn6Q0BirKP+W1w/yYxupgIwAuC3VF19KoH5Ux9ERJtKj5q9QvCaQNZP2NGrbJTDi5WRgvtg8dWS+CXanUM9utvdO8uoRCAnfuaL64C9bUiFRVLluTSb/gr2l64OXDRP
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FB8988CB0442E4B85C44ABC91906FFC@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wolfvision.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 16fe6e42-e950-45bf-83c6-08d75920b32c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 07:55:27.7528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e94ec9da-9183-471e-83b3-51baa8eb804f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /3nQRsJnAHgLSjqwQ2ercBEI0HkdWcu0l/Ga2TZ9QwNyrRbbCcY4Y91SLIB33ngh4fYCs7ueNc7Y0YFSsenwVpLE/wF25qL1tLFo0gZUpY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCk9uIDI1LjEwLjE5IDAwOjE3LCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+IEZy
b206IFRob21hcyBIw6RtbWVybGUgPFRob21hcy5IYWVtbWVybGVAd29sZnZpc2lvbi5uZXQ+DQo+
IERhdGU6IFR1ZSwgMjIgT2N0IDIwMTkgMTM6MDY6MzUgKzAwMDANCj4gDQo+PiArCWNvbnN0IHU4
ICptYWM7DQo+PiArDQo+PiArCXZhbF9yeGNmZyA9IHBoeV9yZWFkX21tZChwaHlkZXYsIERQODM4
NjdfREVWQUREUiwgRFA4Mzg2N19SWEZDRkcpOw0KPj4gKwl2YWxfbWljciA9IHBoeV9yZWFkKHBo
eWRldiwgTUlJX0RQODM4NjdfTUlDUik7DQo+PiArDQo+PiArCWlmICh3b2wtPndvbG9wdHMgJiAo
V0FLRV9NQUdJQyB8IFdBS0VfTUFHSUNTRUNVUkUgfCBXQUtFX1VDQVNUIHwNCj4+ICsJCQkgICAg
V0FLRV9CQ0FTVCkpIHsNCj4+ICsJCXZhbF9yeGNmZyB8PSBEUDgzODY3X1dPTF9FTkhfTUFDOw0K
Pj4gKwkJdmFsX21pY3IgfD0gTUlJX0RQODM4NjdfTUlDUl9XT0xfSU5UX0VOOw0KPj4gKw0KPj4g
KwkJaWYgKHdvbC0+d29sb3B0cyAmIFdBS0VfTUFHSUMpIHsNCj4+ICsJCQltYWMgPSAoY29uc3Qg
dTggKiluZGV2LT5kZXZfYWRkcjsNCj4gDQo+IFBsZWFzZSBkZWNsYXJlICdtYWMnIG5vbi1jb25z
dCBhbmQgZ2V0IHJpZCBvZiB0aGlzIGNhc3QsIGFzIHN1Z2dlc3RlZCBieSBIZWluZXIuDQo+IA0K
DQpJIGFncmVlIHdpdGggSGVpbmVyIGFuZCB5b3UsIGhvd2V2ZXIgc2luY2UgSSBmaXJzdCB0b29r
IGEgaW50byBvdGhlciBwaHkNCmRyaXZlcnMgKGF0ODAzeCwgZHA4MzgyMiwgZHA4M3RjODExKSBh
bmQgaG93IHNldF93b2woKSBpcyBkb25lIHRoZXJlLA0KSSd2ZSBpbXBsZW1lbnRlZCBpdCB0aGUg
c2FtZSB3YXkuDQoNClNvIG1heWJlIHdlIHNob3VsZCBhbHNvIGNoYW5nZSBpdCBpbiB0aGUgb3Ro
ZXIgZHJpdmVycy4NCg0KVGhvbWFzDQo=
