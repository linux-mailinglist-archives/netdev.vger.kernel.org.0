Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D7B1499C1
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgAZJNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:13:16 -0500
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:44449
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbgAZJNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 04:13:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Id3Gj5NQKwW/hWN1rLWbemZzCnAZIjbnw/OYa+J4LhKK9b0ODMeyPTmUj9jvcVvSEYQoBO4WD0FQ1aut0fza4M8tbziYavBCKMYftFTIdGGKms2yTKq0HIpycIxctbcaftCt8qXefM7PA4EnLncCwB9yVh4EMW4Xu45ERPjwyjXF0NV3jMRlzy/Fo+f/Lls6FwVI1BDh5OzlHzXkuJrvtY4mJGuFYJG8R0VhlswemQ69WgkTaP+1IKh2nOFoHUMqG338Fmt3p4Rb8BMyiG8/IMMF9+5D4RLVA7YF9J9gVm43J5uDlwNi5AjTfP0Kgsq0ICuefLOlr2ioc3kagiMXsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuPOgVIJP8dtopJYLz32Qt3k3Z0Ds8d0y4oyg1a42xQ=;
 b=bd0zrxq1VeZnZgEMU9S13mGMfUvTfgscuMsR/QP49HUEKOoQmDpG9oZSuCfTLZmHMgVEYlaT3kWZvD+NVkGzBMJizwfCoDrduNaGcQFPmwoPS63GUuPzvu0ryuMRNmLmPt1umTcyeRPQdZFgO7f3meDL3E7QIW6hR2qBjlSbyVQbT8/FdfloLcPuh6zOlxRPF/zpePFZ+WOUO/OgTCEDnZY2dljAr42oltnRG99nFb7CHBcNeKYQuKafE08Cobm35TYJUxTGPLoZEDY74mGqDi+HSKUTUXwkVKtzmbOACXUr5ONOUODUWfo7bK4ZEJ87h0Qe/vI+npfoHw9v1waBZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuPOgVIJP8dtopJYLz32Qt3k3Z0Ds8d0y4oyg1a42xQ=;
 b=X9a2l2bJAsbCYLEcOfYSOZeafEmk5D1ESpW8kgMeptOrCSDtLY/3IqXQaTBjrFbNwDA64Mee57dR2CZU0RIm5QF36UnGCfX8cqfbEluI+IDbnAxFQ2COgTaDkEHXn7Fa6OFIK/HijLlpFw96cz0eWp8t2PFYvUfPTSBiNFsYxAM=
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com (20.179.44.85) by
 DBBPR05MB6473.eurprd05.prod.outlook.com (20.179.42.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.23; Sun, 26 Jan 2020 09:13:10 +0000
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::8cbf:61ca:bad4:aa6d]) by DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::8cbf:61ca:bad4:aa6d%4]) with mapi id 15.20.2665.017; Sun, 26 Jan 2020
 09:13:10 +0000
Received: from [10.80.2.208] (193.47.165.251) by ZRAP278CA0007.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.19 via Frontend Transport; Sun, 26 Jan 2020 09:13:08 +0000
From:   Aya Levin <ayal@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [net-next V2 11/14] ethtool: Add support for low latency RS FEC
Thread-Topic: [net-next V2 11/14] ethtool: Add support for low latency RS FEC
Thread-Index: AQHV0z30ajcTKuM5OkyAKcqTmAvIXqf7yCaAgAAXzwCAAMsyAA==
Date:   Sun, 26 Jan 2020 09:13:10 +0000
Message-ID: <3648a1a9-8bf5-1823-03a3-61dd0431cf1e@mellanox.com>
References: <20200125051039.59165-1-saeedm@mellanox.com>
 <20200125051039.59165-12-saeedm@mellanox.com>
 <20200125114037.203e63ca@cakuba> <20200125210550.GH18311@lunn.ch>
In-Reply-To: <20200125210550.GH18311@lunn.ch>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZRAP278CA0007.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::17) To DBBPR05MB6299.eurprd05.prod.outlook.com
 (2603:10a6:10:d1::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ayal@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3242f351-f960-4e95-8cd1-08d7a23ff682
x-ms-traffictypediagnostic: DBBPR05MB6473:|DBBPR05MB6473:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR05MB6473538517A1E376C10E4A56B0080@DBBPR05MB6473.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02945962BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(199004)(189003)(956004)(6666004)(2616005)(16576012)(54906003)(110136005)(186003)(316002)(16526019)(5660300002)(71200400001)(4744005)(966005)(31686004)(26005)(8676002)(81156014)(52116002)(53546011)(4326008)(2906002)(478600001)(8936002)(81166006)(31696002)(66446008)(86362001)(36756003)(6486002)(66946007)(66476007)(64756008)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6473;H:DBBPR05MB6299.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VVst13xJIp8YNTKqtl8Dce0jK33o2GYGEjpu+73soIiv15/5ixwMoPoXt+NaNZq3DGSfWwEa2K4jSNPn7TgA126wz/5uRqor1BSiTxrLZGZrTycZKBxkqId9202nvpSOrCm9HxYQp35m8XhbuqngH6U8Mo0ctN8yn78WWyhlYe+sZ0+pSj+TO0LemI9+oCrjCy37sXni3uPhtzveEV+24LZI6Khod4xfMI5p+aMQd2IKBLJvolRXW6xNDggC03WHqomIbrfRl14Lo9hjLUnhD/GjXBtxA97AxhHm6LV3WOYcJMRhprehh1uJYV8TLNjBwaL5S6Miyug5kvCWOOCIfkotn4xHKItsztDkm6FM1otBR5rv611paMrEota2oVmuJfA8xB9j8rZznxUHKeVWSz6QtntE9o4YZULMGdDlHkoOFi+A+raesKdCmlCL6qVvxUAKy1KC7L8LMR4j9xWAFzCQxBb9zAmM6Q62jXx6SDY=
x-ms-exchange-antispam-messagedata: nDPovHrLZ8ql9HtTUzg/XqXXyWRHU/kqqwHqhOX+mx8AgADj2kLzilbeswlG7/7Qd7+quvwSCbdPp5ylUwTSFhV+AV4HRz7f4vlo41Dbi9JOdP8vPc/o2C6jHqaGGYinQfB/dvOMNfSLwduEJxUwkg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <C011768717944F48B674C4B18B1737F6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3242f351-f960-4e95-8cd1-08d7a23ff682
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2020 09:13:10.0433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UjlLos5JG9+kPpxJmp/TE+pzV1DFKRqgD0oymRJrNOc61AqtBSzH78DTUAqf2i/VAD31J0M683EBryGCp0BR4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6473
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvMjUvMjAyMCAxMTowNSBQTSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IE9uIFNhdCwg
SmFuIDI1LCAyMDIwIGF0IDExOjQwOjM3QU0gLTA4MDAsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0K
Pj4gT24gU2F0LCAyNSBKYW4gMjAyMCAwNToxMTo1MiArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3Jv
dGU6DQo+Pj4gRnJvbTogQXlhIExldmluIDxheWFsQG1lbGxhbm94LmNvbT4NCj4+Pg0KPj4+IEFk
ZCBzdXBwb3J0IGZvciBsb3cgbGF0ZW5jeSBSZWVkIFNvbG9tb24gRkVDIGFzIExMUlMuDQo+Pj4N
Cj4+PiBTaWduZWQtb2ZmLWJ5OiBBeWEgTGV2aW4gPGF5YWxAbWVsbGFub3guY29tPg0KPj4+IFJl
dmlld2VkLWJ5OiBFcmFuIEJlbiBFbGlzaGEgPGVyYW5iZUBtZWxsYW5veC5jb20+DQo+Pj4gU2ln
bmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+Pg0KPj4g
VGhpcyBpcyBraW5kIG9mIGJ1cmllZCBpbiB0aGUgbWlkc3Qgb2YgdGhlIGRyaXZlciBwYXRjaGVz
Lg0KPj4gSXQnZCBwcmVmZXJhYmx5IGJlIGEgc21hbGwgc2VyaWVzIG9mIGl0cyBvd24uDQo+PiBM
ZXQncyBhdCBsZWFzdCB0cnkgdG8gQ0MgUEhZIGZvbGsgbm93Lg0KPiANCj4gVGhhbmtzIEpha3V2
DQo+IA0KPj4gSXMgdGhpcyBmcm9tIHNvbWUgc3RhbmRhcmQ/DQo+IA0KPiBBIHJlZmVyZW5jZSB3
b3VsZCBiZSBnb29kLg0KaHR0cHM6Ly8yNWdldGhlcm5ldC5vcmcvDQoyNUcgY29uc29ydGl1bQ0K
PiANCj4gSSBhc3N1bWUgdGhlIGV4aXN0aW5nIEVUSFRPT0xfTElOS19NT0RFX0ZFQ19SU19CSVQg
aXMgZm9yIENsYXVzZSA5MS4NCkl0IGlzIGZvciBib3RoIENsYXVzZTkxIGFuZCBmb3IgQ2x1YXNl
IDEzNCBmb3IgNTBHQkFTRS1SIFBIWXMNCj4gV2hhdCBjbGF1c2UgZG9lcyB0aGlzIExMUlMgcmVm
ZXIgdG8/DQpUaGUgTEwtRkVDICBpcyBkZWZpbmVkIGluIHRoZSBkb2N1bWVudCB0aXRsZWQgIkxv
dyBMYXRlbmN5IFJlZWQgU29sb21vbg0KRm9yd2FyZCBFcnJvciBDb3JyZWN0aW9uIiwgaW4gaHR0
cHM6Ly8yNWdldGhlcm5ldC5vcmcvDQo+IA0KPiBUaGFua3MNCj4gCUFuZHJldw0KPiANCg==
