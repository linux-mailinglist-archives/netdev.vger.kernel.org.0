Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71BEA102568
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfKSN2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:28:49 -0500
Received: from mail-eopbgr20055.outbound.protection.outlook.com ([40.107.2.55]:31310
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfKSN2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 08:28:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lY7BouyFqdMMlhXu2iGqjL8EQQH2tW2N0u8lA7Al3V44plPSLN9zClvsUHfLnW0qDd2BP3aPLrVfnaKCxVij49x+nexKO9GiXPCgBfs2dVAuJdHnrW0Q5rZmShArS0xk3CHvesueMs2+slc31OiE6HrfZmwXBp4CHbmLsecjDuTMUuRHq/2HNEb+bTE9krHp6odayK6NDH95ShZq38TNKziXpnfwIi8vr3jJtzOjGR6Ozs4i4fxwP+Zzg2U1TQnOsZGLTfYoMdjlyDR8VwvvS30y9GGciKrpQVPxKr6r03zXGPJ3tneEscjC1ikmcgOa2/lJCWTRdCWMzQcjq3LXkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxJAMylv4lJc36kVg/tn1uMkeyjcllHrmH9TZPZsnpI=;
 b=WUuN2fP+FURAY5V5kR0KSyegnl2rn7PMVlVFdrkkSjcLAHUhf4l+kqo6n1LB8fIyjmTRY/aYa4KO1zwr3AstfUbLMLSc9W03TWR+ypYdOzAmaHmcOMtJYoNLL4DyG6UcE5Iy1iNRJZn+mOxRGCkwYD86r3th7QOEzK2ZV5sSsZIFrZogteqxkNew34PcbLhioo/Yc5gCOqwDFuBCNVlEoJ79N7CuoK77QO0RGSx8q8r4s+dHPlLIWcd0S4tQPylSw9w6aucPsN1bkl6Ua0eJxhGuxCjRpt177FVESJWreOhUiSNsMilccQq5JPybUFfdHZAltpSp6Apf19JCiWZKVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxJAMylv4lJc36kVg/tn1uMkeyjcllHrmH9TZPZsnpI=;
 b=IvP476jzFOt6W8f8AG0+U2VpwQNA9djGyGMPaYFXBkjuvpITrC4h3/v8KZasXyEc25fQonl8edimtbBz1Mo00TQ0dsNhkGLF9Qkly1hE+K6bhWm4BK0dwbASIoEBSHKlv9ZD678ojFScTBGtPfFg+tqWwNRByPNTtSI7qkT1OTE=
Received: from VI1PR05MB5680.eurprd05.prod.outlook.com (20.178.124.149) by
 VI1PR05MB4974.eurprd05.prod.outlook.com (20.177.49.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 19 Nov 2019 13:28:34 +0000
Received: from VI1PR05MB5680.eurprd05.prod.outlook.com
 ([fe80::b5cf:e640:40d3:b461]) by VI1PR05MB5680.eurprd05.prod.outlook.com
 ([fe80::b5cf:e640:40d3:b461%4]) with mapi id 15.20.2451.029; Tue, 19 Nov 2019
 13:28:34 +0000
From:   Shay Drory <shayd@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "lennart@poettering.net" <lennart@poettering.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        lorian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: Send SFP event from kernel driver to user space (UDEV)
Thread-Topic: Send SFP event from kernel driver to user space (UDEV)
Thread-Index: AQHVnTyemIrPi2KC+0KxDlDyt5FLmqeQJL4AgACuqICAAL9YAIAA7UQA
Date:   Tue, 19 Nov 2019 13:28:34 +0000
Message-ID: <43d837e2-5aec-5d77-2e2b-2b01cf82f98c@mellanox.com>
References: <a041bba0-83d1-331f-d263-c8cbb0509220@mellanox.com>
 <20191118012924.GC4084@lunn.ch>
 <7dc1a44f-d15c-4181-df45-ae93cfd95438@mellanox.com>
 <20191118231922.GB15395@lunn.ch>
In-Reply-To: <20191118231922.GB15395@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shayd@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2f546a7f-d25a-4718-5ab9-08d76cf460d8
x-ms-traffictypediagnostic: VI1PR05MB4974:|VI1PR05MB4974:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4974C195F980766F154F6609C24C0@VI1PR05MB4974.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(189003)(199004)(6506007)(446003)(6116002)(81166006)(3846002)(2906002)(81156014)(99286004)(31686004)(6916009)(8676002)(8936002)(478600001)(71190400001)(71200400001)(66476007)(64756008)(14454004)(66556008)(66446008)(76176011)(186003)(11346002)(76116006)(66066001)(5660300002)(486006)(31696002)(53546011)(476003)(6246003)(102836004)(2616005)(6486002)(26005)(256004)(305945005)(86362001)(229853002)(316002)(36756003)(7736002)(6436002)(25786009)(54906003)(4326008)(66946007)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4974;H:VI1PR05MB5680.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZmAUW+XQdE9moRtDZ3pEnkDFKYzlw3TY0NENe4ISPy4XEhwrKQwZk/7bVfmtohiMpAPtdtKX3tM6cJILnKWpXEe5muQfeVnlFAW/V2l/wjUb7YotHG+5dbONyEYUk680/kJM0QNY421TcggUsGS5Zbzudaj97JJbFf5wxCLYRcbc3bbt6GkTiLfO/J4dntPpuJpQ8eT5LONM5ZgepfrEOQthfLl2IMsML/MMUa1jGp1AuKeO6aBLRAcHLEU432lfU/+kc0Uhlhlx5uR7tW8wJ2RLQDSwNAeAcsErFxYKQr8dcrQbA8L7ksIXI5oZcfqi6lHEvj7qzR/ITq+PjnVn3smEENCGpZ//w7h00fYhRx8YKpre90VyuwPWn5WPOULmyc+2NWPPlbj58QFlNiUlgDf9P2pHWkPo2BYLlgRkkzvPiRqUgmhM3yAQAstboJrv
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF8847A728A0FF4CBE56EA911353688D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f546a7f-d25a-4718-5ab9-08d76cf460d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 13:28:34.8036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dPlaT/PKaA/O+oD1A+W0xjZ4GQdw5X+1IRBUBz4CNsOFEzCrke9KdGAZTJtqtt6bhhBJBOvqTZHeX90t8YTcAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4974
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMTkvMjAxOSAwMToxOSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IE9uIE1vbiwgTm92IDE4
LCAyMDE5IGF0IDExOjU0OjMxQU0gKzAwMDAsIFNoYXkgRHJvcnkgd3JvdGU6DQo+PiBPbiAxMS8x
OC8yMDE5IDAzOjI5LCBBbmRyZXcgTHVubiB3cm90ZToNCj4+PiBPbiBTdW4sIE5vdiAxNywgMjAx
OSBhdCAxMTo0NjoxNUFNICswMDAwLCBTaGF5IERyb3J5IHdyb3RlOg0KPj4+DQo+Pj4gSGkgU2hh
eQ0KPj4+DQo+Pj4gSXQgd291bGQgYmUgZ29vZCB0byBDYzogdGhlIGdlbmVyaWMgU0ZQIGNvZGUg
bWFpbnRhaW5lcnMuDQo+PiBUaGUgc3VnZ2VzdGVkIHNvbHV0aW9uIGlzIG5vdCB0YXJnZXRlZCBm
b3IgU0ZQIGRyaXZlcnMgKHNlZSBiZWxvdyksDQo+PiBidXQgSSBhZGRlZCB0aGVtIHRvIHRoZSBD
YyBsaXN0Lg0KPiBIaSBTaGF5DQo+DQo+IFNvIHlvdSBhcmUgcHJvcG9zaW5nIHNvbWV0aGluZyB3
aGljaCB3b24ndCB3b3JrIGZvciB0aGUgZ2VuZXJpYyBTRlANCj4gY29kZT8gIFRoYXQgc2hvdWxk
IGJlIGFuIGF1dG9tYXRpYyBOQUNLLiBXaGF0ZXZlciB5b3UgcHJvcG9zZSBuZWVkcyB0bw0KPiBi
ZSBnZW5lcmljIHNvIHRoYXQgaXQgY2FuIHdvcmsgZm9yIGFueSBOSUNzIHRoYXQgZG8gZmlybXdh
cmUgc3VwcG9ydA0KPiBmb3IgU0ZQcywgYW5kIHRob3NlIHdobyBsZXQgTGludXggaGFuZGxlIHRo
ZSBTRlAuDQoNClRoZSBzdWdnZXN0aW9uIGlzIHRhcmdldGVkIHRvIHN1cHBvcnQgYWxsIHR5cGVz
IG9mIE5JQ3MNCnRoYXQgZG8gZmlybXdhcmUgc3VwcG9ydCBmb3IgU0ZQcy4gQnV0IEkgd2FudCB0
byBkbyBpdCB2aWEgdGhlIGV0aHRvb2wtbmwNCmludGVyZmFjZSBhbmQgbm90IGJ5IHVzaW5nIHBo
eSBkcml2ZXJzLg0KDQo+DQo+PiBUaGUgZmVhdHVyZSBpcyB0YXJnZXRlZCB0byBuZXRkZXYgdXNl
cnMuIEl0IGlzIGV4cGVjdGVkIGZyb20gdGhlDQo+PiB1c2VyIHRvIHF1ZXJ5IGN1cnJlbnQgc3Rh
dGUgdmlhIGV0aHRvb2wgLW0gYW5kIGFmdGVyd2FyZHMgbW9uaXRvcg0KPj4gZm9yIGNoYW5nZXMg
b3ZlciBVREVWLg0KPiBXaGF0IGV4YWN0bHkgYXJlIHlvdSBpbnRlcmVzdGVkIGluPyBXaGF0IGFy
ZSB5b3VyIHVzZSBjYXNlcy4gV2hlbg0KPiBod21vbiBkZXZpY2VzIGFyZSBjcmVhdGVkLCB5b3Ug
c2hvdWxkIGdldCB1ZGV2IGV2ZW50cy4gTWF5YmUgdGhhdCBpcw0KPiBzdWZmaWNpZW50PyBPciBh
cmUgeW91IGludGVyZXN0ZWQgaW4gc29tZSBvdGhlciBwYXJ0cyBvZiB0aGUgU0ZQIHRoYW4NCj4g
dGhlIGRpYWdub3N0aWMgc2Vuc29ycz8NCg0KSXQgbG9va3MgbGlrZSB0aGUgaHdtb24gaXMgbm90
IHN1ZmZpY2llbnQgZm9yIG91dCBwdXJwb3NlLiBJIGFtIGludGVyZXN0aW5nDQppbiBnZXR0aW5n
IGV2ZW50cyB3aGVuIHRoZSBTRlAgaXMgaW5zZXJ0ZWQgb3IgcmVtb3ZlZC4NCg0KPg0KPj4+IFdv
dWxkIHlvdSBhZGQganVzdCBTRlAgaW5zZXJ0L2VqZWN0IHRvIFVERVYuIE9yIGFsbCB0aGUgZXZl
bnRzIHdoaWNoDQo+Pj4gZ2V0IHNlbnQgdmlhIG5ldGxpbms/IExpbmsgdXAvZG93biwgcm91dGUg
YWRkL3JlbW92ZSwgZXRjPw0KPj4gSXQgbWFrZXMgc2Vuc2UgdG8gbm90aWZ5IGFsbCBldmVudHMu
IFdoYXQgZG8geW91IHRoaW5rPw0KPiBJIGRvbid0IHBhcnRpY3VsYXJseSBsaWtlIHR3byB3YXlz
IHRvIGdldCB0aGUgc2FtZSBpbmZvcm1hdGlvbi4gSXQNCj4gbWVhbnMgd2UgaGF2ZSB0d28gQVBJ
cyB3ZSBuZWVkIHRvIG1haW50YWluIGZvcmV2ZXIsIHdoZW4ganVzdCBvbmUNCj4gc2hvdWxkIGJl
IHN1ZmZpY2llbnQuDQo+DQo+Pj4gSXMgVURFViBuYW1lIHNwYWNlIGF3YXJlPyBEbyB5b3UgcnVu
IGEgdWRldiBkYWVtb24gaW4gZWFjaCBuZXR3b3JrDQo+Pj4gbmFtZSBzcGFjZT8gSSBhc3N1bWUg
d2hlbiB5b3Ugb3BlbiBhIG5ldGxpbmsgc29ja2V0LCBpdCBpcyBmb3IganVzdA0KPj4+IHRoZSBj
dXJyZW50IG5ldHdvcmsgbmFtZXNwYWNlPw0KPj4gVURFViB3aWxsIGZvbGxvdyBuZXRsaW5rIG5h
bWUtc3BhY2UuDQo+IFNvIHlvdSBkbyBwbGFuIHRvIGhhdmUgYSB1ZGV2IGRhZW1vbiBydW5uaW5n
IGluIGV2ZXJ5IG5ldHdvcmsgbmFtZQ0KPiBzcGFjZS4gRG9lcyB1ZGV2IGV2ZW4gc3VwcG9ydCB0
aGF0Pw0KPg0KPiBJJ20gc2NlcHRpY2FsIHVzaW5nIHVkZXYgaXMgYSBnb29kIGlkZWEuIEJ1dCBo
YXZpbmcgbmV0bGluayBldmVudHMNCj4gZG9lcyBzb3VuZHMgcmVhc29uYWJsZS4gQW5kIGlmIHlv
dSBhcmUgd2lsbGluZyB0byB3YWl0IGEgd2hpbGUsDQo+IGV0aHRvb2wtbmwgZG9lcyBzZWVtIGxp
a2UgYSBnb29kIGZpdC4gQnV0IHBsZWFzZSBtYWtlIHN1cmUgeW91cg0KPiBzb2x1dGlvbiBpcyBn
ZW5lcmljLg0KPg0KPiAJIEFuZHJldw0KDQpUaGFua3MgZm9yIHlvdXIgY29tbWVudHMuIFRoZSB1
c2luZyBvZiBVZGV2IGlzIHVuZGVyIGludGVybmFsIGRpc2N1c3Npb24uDQoNCg==
