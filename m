Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704BB1904DC
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 06:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgCXFWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 01:22:34 -0400
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:22980
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725867AbgCXFWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 01:22:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1RPrb96BCvS3UrWBSDbkb+ztfPtSpi9Jy45tev8fSqAlxEPFJ40Y8RslAGbfkb1LBv8n7CYXeMk+ReWCqtAquJ5xfZMWgh6n8tOq3136hJ6vmAbbToO+OfUl9pfdLxdEf+hhuovHuA5jlLw4Ntgs0mSbfjieUDdJer6sW1Ko5DbZ1MvDe9OugGRdqgrmPLKYW4uTaUImP+79XhQRLukGu7Jg3ifVfacFzg3AjAgRCLqAr7KV3fWS7FOWeSCo9FyRGQF6LNJJcdFGRt6P1L9Ft8eUA3ZTxFnoCx4U3cn6bcywvvuBkSBbn4Nw/EmPbkY3PQgRexw4o02BKL2iCANwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YX4ULWrUpyd0RhEfeUk2FBWJShTEQUBYybcoV85zhJ4=;
 b=MHvc1ZK7ym+UOGPwhzk3cq08BL39tRkmkZ+y6ogGsXjtDLle6BmLJ9dl7C0GLFKoz4aMcm6GxiunA4EE8yInFdGxxAbNX36nd6SWqLQMgxXyQPNybijajVZQSiHnyXIIMCGhJLsf3bzB4Gtq7TgEosBTQoEicmWf7Dtgu3IPTYoyBIiu1dSUGRBNT5Fr+AL7+B8HxAlxbxtTlD3C6wARqzF4xliRIR6yxyrBp7QgYriq+pfmj6CHOVOrXeMqGQ384QvrEMnbZaXN6SA0TdwL92t+pTfS0p7XbMTBtr9eogmXTwZ3AtCiHedgYlCphN3SHwrQov24pRSr4WCnX5/lHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YX4ULWrUpyd0RhEfeUk2FBWJShTEQUBYybcoV85zhJ4=;
 b=cuF5Jae3tzKyw9IzH4AcsZx7wRY1Iqo3LIdlhA+McttwrdrPupHWd/JDvXXJXFyT2ljr8NdTKr1rfXpylPSU7JriWlHC5InYg/SmYYdfE/3DhsN1FeVsQbNsj9n9lJ0RMUl2eUFkxpxpPgRSfF3i7F6m+K2ypZlvEdknfz2x07Y=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB6791.eurprd04.prod.outlook.com (10.141.171.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Tue, 24 Mar 2020 05:21:27 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94%2]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 05:21:27 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
CC:     lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Thread-Topic: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Thread-Index: AQHV/qQWBIiKj5A/T0WD8BjMeGVxRqhRd2EAgAW7PoA=
Date:   Tue, 24 Mar 2020 05:21:27 +0000
Message-ID: <AM7PR04MB6885A8C98CA60FC435024647F8F10@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com>
 <CA+h21hoBwDuWCFbO70u1FAERB8zc5F+H5URBkn=2_bpRRRz1oA@mail.gmail.com>
In-Reply-To: <CA+h21hoBwDuWCFbO70u1FAERB8zc5F+H5URBkn=2_bpRRRz1oA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3986b722-75c9-4941-c3e4-08d7cfb333e1
x-ms-traffictypediagnostic: AM7PR04MB6791:|AM7PR04MB6791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB6791A851016751B39F6202EEF8F10@AM7PR04MB6791.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03524FBD26
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(4326008)(2906002)(71200400001)(55016002)(9686003)(110136005)(54906003)(316002)(53546011)(6506007)(26005)(8936002)(33656002)(86362001)(7696005)(186003)(52536014)(66946007)(5660300002)(66446008)(45080400002)(966005)(7416002)(81166006)(81156014)(66556008)(478600001)(8676002)(76116006)(64756008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB6791;H:AM7PR04MB6885.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /waUudYvxYOOv2F4jzpIbnow6WrQRTabhMPJdZskxtwzyRBn8x8i2i2dZPhRXSrymwRm/stpTcCULWwkDjvXyc3JhNOVAys6fgbK+83bO6av2cpkUc94q4LbrYq3oXxqlcqw33sPWCrFeqFAyWjuSXpQ5RQ0f5JNXJUVLjL1eAysEXpM4ojn+ztStEfeYXdt40GFK+BrsPbHbyRfy44r/sWpP3R3I89XuURadnZDR6bQxrWyqJBwxMrvZq9h4KP4gw5pjwPaYpr/ij8WaRL3LF3/y4Z9iymT/SfQgSLQ5Hzv08PgUqvbz01AXBLLuwBjgE2GjFh4ttbdZwR8b99BxFjodjEp0I8Xn8ZK58VpfrWZH1s0CpLdGjQmkFW6gqjWdehiuDtmLyv62Xd0JjnxPVdwd6/d0xP7rRadefOHlmaC642FxlB+wvQByugB+9clUuaf+1lHCjAuhzLtozMHRI8mxgx7N3c4uNHT2p9iIYE+2JcWCDw9vgkN36EVmRzaH3QRCNk2BQnBaXjNd1PXpQ==
x-ms-exchange-antispam-messagedata: EZcEVtX78OgonNd6ZpJWeORrAppUZx5EaT0cwOLowXGRCJMZCzAKSZgTXu0QhqaboHQ4vx8NbmsEq3cof+ZeqU22o7MoZcTBCV6Ij6k7nGKT/P0bmLg34EM1S9j+wZIcTnfBPsqcTROTZsNkW4y2Fw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3986b722-75c9-4941-c3e4-08d7cfb333e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2020 05:21:27.2236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Z2fF/9hHEgRzA0E2pwGKrbb5ohJ6/kzK1SDKAXuUW3Gql10tOjn1hKq4vV+lvmTSTXVC+Lh9xMExEr8NCLcLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIgYW5kIFJpY2hhcmQsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
Cj4gRnJvbTogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCj4gU2VudDogRnJp
ZGF5LCBNYXJjaCAyMCwgMjAyMCA5OjIxIFBNDQo+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhw
LmNvbT4NCj4gQ2M6IGxrbWwgPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBuZXRkZXYg
PG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+Ow0KPiBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZl
bWxvZnQubmV0PjsgUmljaGFyZCBDb2NocmFuDQo+IDxyaWNoYXJkY29jaHJhbkBnbWFpbC5jb20+
OyBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsNCj4gQ2xhdWRpdSBN
YW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4u
Y2g+Ow0KPiBWaXZpZW4gRGlkZWxvdCA8dml2aWVuLmRpZGVsb3RAZ21haWwuY29tPjsgRmxvcmlh
biBGYWluZWxsaQ0KPiA8Zi5mYWluZWxsaUBnbWFpbC5jb20+OyBBbGV4YW5kcmUgQmVsbG9uaSA8
YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb20+Ow0KPiBNaWNyb2NoaXAgTGludXggRHJpdmVy
IFN1cHBvcnQgPFVOR0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggNi82XSBwdHBfb2NlbG90OiBzdXBwb3J0IDQgcHJvZ3JhbW1hYmxlIHBpbnMNCj4gDQo+
IEhpIFlhbmdibywNCj4gDQo+IE9uIEZyaSwgMjAgTWFyIDIwMjAgYXQgMTI6NDIsIFlhbmdibyBM
dSA8eWFuZ2JvLmx1QG54cC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gU3VwcG9ydCA0IHByb2dyYW1t
YWJsZSBwaW5zIGZvciBvbmx5IG9uZSBmdW5jdGlvbiBwZXJpb2RpYw0KPiA+IHNpZ25hbCBmb3Ig
bm93LiBTaW5jZSB0aGUgaGFyZHdhcmUgaXMgbm90IGFibGUgdG8gc3VwcG9ydA0KPiA+IGFic29s
dXRlIHN0YXJ0IHRpbWUsIGRyaXZlciBzdGFydHMgcGVyaW9kaWMgc2lnbmFsIGltbWVkaWF0ZWx5
Lg0KPiA+DQo+IA0KPiBBcmUgeW91IGFic29sdXRlbHkgc3VyZSBpdCBkb2Vzbid0IHN1cHBvcnQg
YWJzb2x1dGUgc3RhcnQgdGltZT8NCj4gQmVjYXVzZSB0aGF0IHdvdWxkIG1lYW4gaXQncyBwcmV0
dHkgdXNlbGVzcyBpZiB0aGUgcGhhc2Ugb2YgdGhlIFBUUA0KPiBjbG9jayBzaWduYWwgaXMgb3V0
IG9mIGNvbnRyb2wuDQoNCkknbSBhYnNvbHV0ZWx5IHN1cmUgdGhhdCBhYnNvbHV0ZSBzdGFydCB0
aW1lIGlzIG5vdCBzdXBwb3J0ZWQgZm9yIHBlcmlvZGljIGNsb2NrIHVubGVzcyByZWZlcmVuY2Ug
bWFudWFsIGlzIHdyb25nLg0KQW5kIEkgZG9u4oCZdCB0aGluayB3ZSBuZWVkIHRvIGNvbnNpZGVy
IHBoYXNlIGZvciBwZXJpb2RpYyBjbG9jayB3aGljaCBpcyB3aXRoIGEgc3BlY2lmaWVkIHBlcmlv
ZC4NCg0KQnV0IFBQUyBpcyBkaWZmZXJlbnQuIFB1bHNlIHNob3VsZCBiZSBnZW5lcmF0ZWQgbXVz
dCBhZnRlciBzZWNvbmRzIGluY3JlYXNlZC4NClRoZSB3YXZlZm9ybV9oaWdoL2xvdyBzaG91bGQg
YmUgY29uZmlndXJhYmxlIGZvciBwaGFzZSBhbmQgcHVsc2Ugd2lkdGggaWYgc3VwcG9ydGVkLg0K
VGhpcyBpcyBzdXBwb3J0ZWQgYnkgaGFyZHdhcmUgYnV0IHdhcyBub3QgaW1wbGVtZW50ZWQgYnkg
dGhpcyBwYXRjaC4gSSB3YXMgY29uc2lkZXJpbmcgdG8gYWRkIGxhdGVyLg0KDQpJbiBteSBvbmUg
cHJldmlvdXMgcGF0Y2gsIEkgd2FzIHN1Z2dlc3RlZCB0byBpbXBsZW1lbnQgUFBTIHdpdGggcHJv
Z3JhbW1hYmxlIHBpbiBwZXJpb2RpYyBjbG9jayBmdW5jdGlvbi4NCkJ1dCBJIGRpZG7igJl0IGZp
bmQgaG93IHNob3VsZCBQUFMgYmUgaW1wbGVtZW50ZWQgd2l0aCBwZXJpb2RpYyBjbG9jayBmdW5j
dGlvbiBhZnRlciBjaGVja2luZyBwdHAgZHJpdmVyLg0KaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJz
Lm9yZy9wYXRjaC8xMjE1NDY0Lw0KDQpWbGFkaW1pciB0YWxrZWQgd2l0aCBtZSwgZm9yIHRoZSBz
cGVjaWFsIFBQUyBjYXNlLCB3ZSBtYXkgY29uc2lkZXIsDQppZiAocmVxLnBlcm91dC5wZXJpb2Qu
c2VjID09MSAmJiByZXEucGVyb3V0LnBlcmlvZC5uc2VjID09IDApIGFuZCBjb25maWd1cmUgV0FW
RUZPUk1fTE9XIHRvIGJlIGVxdWFsIHRvIHJlcV9wZXJvdXQuc3RhcnQubnNlYy4NCg0KUmljaGFy
ZCwgZG8geW91IHRoaW5rIGlzIGl0IG9rPw0KDQpBbmQgYW5vdGhlciBwcm9ibGVtIEkgYW0gZmFj
aW5nIGlzLCBpbiAuZW5hYmxlKCkgY2FsbGJhY2sgKFBUUF9DTEtfUkVRX1BFUk9VVCByZXF1ZXN0
KSBJIGRlZmluZWQuDQogICAgICAgICAgICAgICAgLyoNCiAgICAgICAgICAgICAgICAgKiBUT0RP
OiBzdXBwb3J0IGRpc2FibGluZyBmdW5jdGlvbg0KICAgICAgICAgICAgICAgICAqIFdoZW4gcHRw
X2Rpc2FibGVfcGluZnVuYygpIGlzIHRvIGRpc2FibGUgZnVuY3Rpb24sDQogICAgICAgICAgICAg
ICAgICogaXQgaGFzIGFscmVhZHkgaGVsZCBwaW5jZmdfbXV4Lg0KICAgICAgICAgICAgICAgICAq
IEhvd2V2ZXIgcHRwX2ZpbmRfcGluKCkgaW4gLmVuYWJsZSgpIGNhbGxlZCBhbHNvIG5lZWRzDQog
ICAgICAgICAgICAgICAgICogdG8gaG9sZCBwaW5jZmdfbXV4Lg0KICAgICAgICAgICAgICAgICAq
IFRoaXMgY2F1c2VzIGRlYWQgbG9jay4gU28sIGp1c3QgcmV0dXJuIGZvciBmdW5jdGlvbg0KICAg
ICAgICAgICAgICAgICAqIGRpc2FibGluZywgYW5kIHRoaXMgbmVlZHMgZml4LXVwLg0KICAgICAg
ICAgICAgICAgICAqLw0KSG9wZSBzb21lIHN1Z2dlc3Rpb25zIGhlcmUuDQpUaGFua3MgYSBsb3Qu
DQoNCj4gDQo+IEkgdGVzdGVkIHlvdXIgcGF0Y2ggb24gdGhlIExTMTAyOEEtUkRCIGJvYXJkIHVz
aW5nIHRoZSBmb2xsb3dpbmcgY29tbWFuZHM6DQo+IA0KPiAjIFNlbGVjdCBQRVJPVVQgZnVuY3Rp
b24gYW5kIGFzc2lnbiBhIGNoYW5uZWwgdG8gZWFjaCBvZiBwaW5zDQo+IFNXSVRDSF8xNTg4X0RB
VDAgYW5kIFNXSVRDSF8xNTg4X0RBVDENCj4gZWNobyAnMiAwJyA+IC9zeXMvY2xhc3MvcHRwL3B0
cDEvcGlucy9zd2l0Y2hfMTU4OF9kYXQwDQo+IGVjaG8gJzIgMScgPiAvc3lzL2NsYXNzL3B0cC9w
dHAxL3BpbnMvc3dpdGNoXzE1ODhfZGF0MQ0KPiAjIEdlbmVyYXRlIHB1bHNlcyB3aXRoIDEgc2Vj
b25kIHBlcmlvZCBvbiBjaGFubmVsIDANCj4gZWNobyAnMCAwIDAgMSAwJyA+IC9zeXMvY2xhc3Mv
cHRwL3B0cDEvcGVyaW9kDQo+ICMgR2VuZXJhdGUgcHVsc2VzIHdpdGggMSBzZWNvbmQgcGVyaW9k
IG9uIGNoYW5uZWwgMQ0KPiBlY2hvICcxIDAgMCAxIDAnID4gL3N5cy9jbGFzcy9wdHAvcHRwMS9w
ZXJpb2QNCj4gDQo+IEFuZCBoZXJlIGlzIHdoYXQgSSBnZXQ6DQo+IGh0dHBzOi8vZXVyMDEuc2Fm
ZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmRyaXZlLmcN
Cj4gb29nbGUuY29tJTJGb3BlbiUzRmlkJTNEMUVyV3VmSkwwVFd2NmhLRFFkRjFwUkw1Z240aG40
WC1yJmFtcDsNCj4gZGF0YT0wMiU3QzAxJTdDeWFuZ2JvLmx1JTQwbnhwLmNvbSU3Q2JkM2U2NWJk
YWFiYjQ5OTk3MzdkMDhkN2MNCj4gY2QxN2VlZSU3QzY4NmVhMWQzYmMyYjRjNmZhOTJjZDk5YzVj
MzAxNjM1JTdDMCU3QzAlN0M2MzcyMDMwNw0KPiAyNDU3MTI0NDY4JmFtcDtzZGF0YT00RDk3RDla
b0ElMkZESmVTQU4lMkZoYTR6TnVaTDZHd1JMTnhwTlkNCj4gUWlMc09zeU0lM0QmYW1wO3Jlc2Vy
dmVkPTANCj4gDQo+IFNvIHRoZSBwZXJpb2RpYyBvdXRwdXQgcmVhbGx5IHN0YXJ0cyAnbm93JyBq
dXN0IGxpa2UgdGhlIHByaW50IHNheXMsDQo+IHNvIHRoZSBvdXRwdXQgZnJvbSBEQVQwIGlzIG5v
dCBldmVuIGluIHN5bmMgd2l0aCBEQVQxLg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBZYW5nYm8g
THUgPHlhbmdiby5sdUBueHAuY29tPg0KPiA+IC0tLQ0KPiANCj4gVGhhbmtzLA0KPiAtVmxhZGlt
aXINCg==
