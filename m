Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A62742C0FD
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 10:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfE1INz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 04:13:55 -0400
Received: from mail-eopbgr150121.outbound.protection.outlook.com ([40.107.15.121]:42302
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbfE1INz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 04:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKBVMFXnImGG6mANCsXCynVxAYKF1x2ZOaNMvMg0yNg=;
 b=LWfhWYl+xMxIEEdvn4NaO4Mwnk+1aeXqt297l7DDrCoCm2X9CgLkTs669z1wo58eiPII230qqqCtTaC7dI9gewXMZ44L7G8FXr23E/GdbWuk1/mPCSOYPFm1a08yBfaT4amQcBs1sP5f+Oo0Ymp+R0vZzjfyKWL2C6K0q6FumWo=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB1581.EURPRD10.PROD.OUTLOOK.COM (10.165.191.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Tue, 28 May 2019 08:13:51 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 08:13:51 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: use of uninitialized value in mv88e6185_port_link_state
Thread-Topic: use of uninitialized value in mv88e6185_port_link_state
Thread-Index: AQHVFS1IvOqASGHPQEmcDecJlkh1DA==
Date:   Tue, 28 May 2019 08:13:50 +0000
Message-ID: <9dd8c118-c991-537b-acf2-2a07a07eb2b8@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0140.eurprd05.prod.outlook.com
 (2603:10a6:7:28::27) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97b03d14-8acc-44e3-d2ca-08d6e3446a69
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR10MB1581;
x-ms-traffictypediagnostic: VI1PR10MB1581:
x-microsoft-antispam-prvs: <VI1PR10MB1581B8A86DD40413880017858A1E0@VI1PR10MB1581.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39850400004)(366004)(346002)(376002)(396003)(189003)(199004)(256004)(2906002)(2616005)(31696002)(44832011)(486006)(71200400001)(476003)(36756003)(31686004)(4744005)(3846002)(6116002)(71190400001)(74482002)(66066001)(316002)(81166006)(5660300002)(72206003)(14454004)(8936002)(8676002)(81156014)(8976002)(68736007)(6436002)(52116002)(102836004)(6506007)(386003)(66946007)(53936002)(25786009)(99286004)(305945005)(73956011)(66476007)(66556008)(64756008)(66446008)(7736002)(42882007)(26005)(6512007)(110136005)(6486002)(186003)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB1581;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pnmMp7ad8xstXkExPCFwHU4eWRwvbpR/LjsR+thPhz2Hti+S6B5y2fQQmpS0nRYcYA+HChwuBcGs0GB4OB2hAb9bOZImadJd6fF9QBbfFkFpyBmQcqesOtEVplajkLaYZmAtDmY6zeVp4JwikqetFFUmTN9qM3HkDvLXYWXmJLKHzA9FzNl41M/pTzP59q0HPcLcqSgomAe/YjopB1xZp/Le3lvnO9Dn8RAZLUybe64EsydJGj2b15vZwgKZOaE6otRQupQ9EB8iTjKwBMoVESiQd6lrlMDIb7M2L2nkoFM+r7YnS6bFiJ2RvzLVQKbuB/wMFXkrop8xSBVZ7I+ODkfFEqM4DKbtUjijaV8s/WfWVO7oFbcfN90r1XOsXpWgwVKXhAT9LP7kvn/Sxt4dSpKIe0xnLDgiy+OOQBUmulU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B19EE46C703364A96B1EBFFD3EAF656@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 97b03d14-8acc-44e3-d2ca-08d6e3446a69
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 08:13:50.8771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB1581
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCm12ODhlNjE4NV9wb3J0X2xpbmtfc3RhdGUgc3RhcnRzIGJ5IGluc3BlY3Rpbmcgc3Rh
dGUtPmludGVyZmFjZS4gQUZBSUNULA0KaXQgY2FuIGJlIGNhbGxlZCBmcm9tIHR3byBwbGFjZXM6
DQoNCm12ODhlNnh4eF9saW5rX3N0YXRlIDwtDQpkc2Ffc2xhdmVfcGh5bGlua19tYWNfbGlua19z
dGF0ZSA8LQ0KcGh5bGlua19nZXRfbWFjX3N0YXRlDQoNCndoaWNoIGRvZXMgaW5pdGlhbGl6ZSBz
dGF0ZS0+aW50ZXJmYWNlIGJlZm9yZSBwYXNzaW5nIGl0LCBidXQgYWxzbyBmcm9tDQptdjg4ZTZ4
eHhfcG9ydF9zZXR1cF9tYWMsIHdoaWNoIHBhc3NlcyBhbiB1bmluaXRpYWxpemVkIHN0YWNrIHZh
cmlhYmxlLg0KVGhpcyBzZWVtcyBsaWtlIGEgYnVnLCBidXQgSSBkb24ndCBrbm93IHdoYXQgdGhl
IHByb3BlciBmaXggd291bGQgYmUuDQpTaW1wbHkgaW5pdGlhbGl6ZSBzdGF0ZS5pbnRlcmZhY2Ug
dG8gbW9kZT8NCg0KUmFzbXVzDQo=
