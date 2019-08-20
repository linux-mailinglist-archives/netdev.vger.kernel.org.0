Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA9A6957E0
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 09:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbfHTHIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 03:08:17 -0400
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:7520
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727006AbfHTHIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 03:08:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6/8sySMDJhFwrpykpVbNas5iQmyVbgjk+CcWzKPvoI0xbT+s7V9Mn/hjmlNsg3M2JowgziakzVSiFw0nIWJQN15FX67Mu/+D9QAEE81fAPXnjnSB0myByy/U/pI/Sdf6Jiwye5y4AAULzS0lm1XzUicRAoLO7x6So9vtUGS9hUsJuRHO53NhQxPhv0059cFOjrBbCDDx9iM9sS06ZShH3JPbcirsAVFDlfhabXfY7ifBTkNB2e5QZj59tx3WGfBb5iVpTSnrITZlTTThWB0OE/0pJZKZuzw8EeVWsy/8av1vB5I4dEHJvIE1xC90E5sjF+4u6kTrdAkjvi6qg+iSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6if/M9zmElOYCYASTEheg3R7AhgkJGcEil0QWoUS1c8=;
 b=a+ytRk5z/MZppEa6nephsr16et7WE3pdYowheuaBVD17LF4NdzmKYIaHmKiqRFVTcDmXCDfk9TsaLmwXbhNd3zSIxJ0lWg8cVsgxM4iMDC4aDni1W/Ih7hZfRYagQpZ3mv4evvSrdi5ozcR9epII60Jnfz38xmdRuOhWr3EWzd/2f54qz7+aYp7juMMNskhCQNDFHBAfmZVwHjs30N+JNL9dWtSozIiutETyeuu1jbfeR6dnkzEmSLqB7am4hUxroFUP2VRYRinIvlIiMKCS/j+d6ptbEai7gzOIcAfy+VIs36EcL3tyiijvQpcZ0yWQJSkZQIiRXLyDwbQuW+2FhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6if/M9zmElOYCYASTEheg3R7AhgkJGcEil0QWoUS1c8=;
 b=pvIn5GcSjepLVlMc4gYLcc59pG3JyJS5JWVR+0JQw9w14wh5PVov1hN29I1dzulE+Y/ZAWXCgYAMOJOBpIgmBcsYE8ElMl0hpfwlhOgjvCksFQIMzVtWLS+rqQDW/N6vIZUZJLQIKZlUvm9U4Y1HGpdw0mD4Of6SC8sPIfDDnHs=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3507.eurprd05.prod.outlook.com (10.171.190.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 07:08:13 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f%7]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 07:08:13 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Pravin Shelar <pshelar@ovn.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc
 chain
Thread-Topic: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc
 chain
Thread-Index: AQHVVd4vntP1emxsQEi9o1hhY1fsp6cCv0OAgADLdgCAABWVgA==
Date:   Tue, 20 Aug 2019 07:08:13 +0000
Message-ID: <1d63b690-ec8e-ceb9-a133-9189ad887da9@mellanox.com>
References: <1566144059-8247-1-git-send-email-paulb@mellanox.com>
 <20190819174241.GE2699@localhost.localdomain>
 <CAOrHB_ANDffyHx41TKEMGyrM25ZGuYBAqTqujS9BdRSDjRyFJA@mail.gmail.com>
In-Reply-To: <CAOrHB_ANDffyHx41TKEMGyrM25ZGuYBAqTqujS9BdRSDjRyFJA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MRXP264CA0012.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::24) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a4637d4-0e74-4f6e-6b38-08d7253d2aa2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR05MB3507;
x-ms-traffictypediagnostic: AM4PR05MB3507:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB35071BBB19F8F10565030658CFAB0@AM4PR05MB3507.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(189003)(199004)(4326008)(2906002)(7736002)(71190400001)(71200400001)(305945005)(36756003)(99286004)(256004)(14444005)(8936002)(8676002)(81156014)(81166006)(6246003)(107886003)(66446008)(64756008)(66556008)(66476007)(31686004)(3846002)(6116002)(53936002)(6512007)(25786009)(54906003)(110136005)(76176011)(31696002)(66946007)(86362001)(14454004)(52116002)(316002)(478600001)(26005)(186003)(66066001)(229853002)(11346002)(2616005)(446003)(486006)(476003)(5660300002)(6436002)(102836004)(53546011)(6506007)(386003)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3507;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oc+4xCO2EDByozayF7zIQ3HSV+7La3Kwb3iXGNN3IBGtSGmmNoLQVFIp9rXfTbQmI8m59tihgwLyvmsAybGuzaqR8QQOsz8wOStYERNWv8TRYHn9vMeQeDbG6j1GPGB6bLhZrkFb6vloAOhc2BRaJoZsCQwVLnW2zbAo9hTgc9pb+93lI6PDja/4bz3lq/LaWTmPBhmDYNqhms3oyBhRr+RCyxyZkxWJecbrq+aegoqh5PQQECs2ilPpjqhcWynR2uq0Ye+YxWbPjapplue0ZAhrxtibWzOWFfIpMr949D3uUqXvFxTaRznWNyfRkMcaIzNJleyEjvJtS73bY4iHkdflJ9cmql5XRgEfMNyOYmEhHJuZnxCnfJ7s5liQyFfRGZZPM/4LjUD8AYL0hlLPG0K3OeQq3a0ge22TijMI2BA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD92720BA066F444B8098307D715A891@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a4637d4-0e74-4f6e-6b38-08d7253d2aa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 07:08:13.6883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZzHMk7D0FVnT1LdpnycA6DlWkyD99ex5OunAPTm4WxP/FfRTfbrDgFipXbpY0PeJ89a1Ur5r+tcHbs4D6MR2CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3507
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA4LzIwLzIwMTkgODo1MCBBTSwgUHJhdmluIFNoZWxhciB3cm90ZToNCj4gT24gTW9uLCBB
dWcgMTksIDIwMTkgYXQgMTA6NDIgQU0gTWFyY2VsbyBSaWNhcmRvIExlaXRuZXINCj4gPG1hcmNl
bG8ubGVpdG5lckBnbWFpbC5jb20+IHdyb3RlOg0KPj4gT24gU3VuLCBBdWcgMTgsIDIwMTkgYXQg
MDc6MDA6NTlQTSArMDMwMCwgUGF1bCBCbGFrZXkgd3JvdGU6DQo+Pj4gV2hhdCBkbyB5b3UgZ3V5
cyBzYXkgYWJvdXQgdGhlIGZvbGxvd2luZyBkaWZmIG9uIHRvcCBvZiB0aGUgbGFzdCBvbmU/DQo+
Pj4gVXNlIHN0YXRpYyBrZXksIGFuZCBhbHNvIGhhdmUgT1ZTX0RQX0NNRF9TRVQgY29tbWFuZCBw
cm9iZS9lbmFibGUgdGhlIGZlYXR1cmUuDQo+Pj4NCj4+PiBUaGlzIHdpbGwgYWxsb3cgdXNlcnNw
YWNlIHRvIHByb2JlIHRoZSBmZWF0dXJlLCBhbmQgc2VsZWN0aXZseSBlbmFibGUgaXQgdmlhIHRo
ZQ0KPj4+IE9WU19EUF9DTURfU0VUIGNvbW1hbmQuDQo+PiBJJ20gbm90IGNvbnZpbmNlZCB5ZXQg
dGhhdCB3ZSBuZWVkIHNvbWV0aGluZyBsaWtlIHRoaXMuIEJlZW4NCj4+IHdvbmRlcmluZywgc2ti
X2V4dF9maW5kKCkgYmVsb3cgaXMgbm90IHRoYXQgZXhwZW5zaXZlIGlmIG5vdCBpbiB1c2UuDQo+
PiBJdCdzIGp1c3QgYSBiaXQgY2hlY2sgYW5kIHRoYXQncyBpdCwgaXQgcmV0dXJucyBOVUxMLg0K
Pj4NCj4+IEFuZCBkcml2ZXJzIHdpbGwgb25seSBiZSBzZXR0aW5nIHRoaXMgaWYgdGhleSBoYXZl
IHRjLW9mZmxvYWRpbmcNCj4+IGVuYWJsZWQgKGFzc3VtaW5nIHRoZXkgd29uJ3QgYmUgc2VlaW5n
IGl0IGZvciBjaGFpbiAwIGFsbCB0aGUgdGltZSkuDQo+PiBPbiB3aGljaCBjYXNlLCB3aXRoIHRj
IG9mZmxvYWRpbmcsIHdlIG5lZWQgdGhpcyBpbiBvcmRlciB0byB3b3JrDQo+PiBwcm9wZXJseS4N
Cj4+DQo+PiBJcyB0aGUgYml0IGNoZWNraW5nIHJlYWxseSB0aGF0IHdvcnJ5c29tZT8NCj4+DQo+
IFBvaW50IGlzIHRoaXMgd291bGQgYmUgY29tcGxldGVseSB1bm5lY2Vzc2FyeSBjaGVjayBmb3Ig
c29mdHdhcmUgb25seQ0KPiBjYXNlcywgdGhhdCBpcyB3aGF0IHN0YXRpYyBrZXkgaXMgdXNlZCBm
b3IsIHdoZW4geW91IGhhdmUgYSBmZWF0dXJlIGluDQo+IGRhdGFwYXRoIHRoYXQgaXMgbm90IHVz
ZWQgYnkgbWFqb3JpdHkgb2YgdXNlcnMuIFNvIEkgZG8gbm90IHNlZSBhbnkNCj4gZG93bnNpZGUg
b2YgaGF2aW5nIHRoaXMgc3RhdGljIGtleS4NCg0KQWxzbyBpdCdzIGdvb2QgdGhhdCBJIGNhbiBu
b3cgcHJvYmUga2VybmVsIHN1cHBvcnQgdmlhIE9WU19EUF9DTURfU0VULg0KDQpTaW5jZSB1c2Vy
IGNhbiBkaXNhYmxlIHRoZSBrZXJuZWwgc3VwcG9ydCBvciBldmVuIHVzZSBhIGRpZmZlcmVudCAN
CnZlcnNpb24gb2YgdGhlIGRhdGFwYXRoIG1vZHVsZSwgaXQgd291bGQgc2lsZW50bHkgYnVnIG9u
IG1pc3NlcyBmcm9tIHRjLg0KDQpOb3cgSSBjYW4gc2V0IHRoZSByZWNpcmMgc2hhcmluZyBmZWF0
dXJlIGluIHVzZXJfZmVhdHVyZSB2aWEgU0VUIG9wLCBhbmQgDQpjaGVjayB0aGUgcmV0dXJuZWQg
bmV3IHVzZXJfZmVhdHVyZXMgb3IgYW4gZXJyb3IgY29kZS4NCg0KSWYgbm8gZXJyb3IsIGFuZCB1
c2VyX2ZlYXR1cmVzIGNvbnRhaW5zIHRoZSBmbGFnICh3b24ndCBiZSB0aGVyZSBmb3IgDQpvbGRl
ciBEUHMgdGhhdCB3b24ndCByZXR1cm4gZXJyb3IpLCB0aGVuIERQIHN1cHBvcnRzIHRoaXMgZmVh
dHVyZSBhbmQNCg0Ka2VybmVsIGNvbmZpZyBpcyBlbmFibGVkLg0KDQoNCg0K
