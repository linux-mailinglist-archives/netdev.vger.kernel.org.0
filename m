Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C5229243C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 11:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgJSJDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 05:03:22 -0400
Received: from mail-eopbgr40054.outbound.protection.outlook.com ([40.107.4.54]:58862
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729772AbgJSJDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 05:03:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lF2Dkr7l3lkuh06RVCz+39Ay5JrjmBQ5yqm87pjgyzN+goL4EumOpA7FxQiruaXuFxYGlEYGVLqUxRiNTN64uv0iJouVQFCM7HSXxZR37Ul5dLnOab/bwlim5aX/JSMPJD3QXFD41xuaM7oosoBB0qxSURLqVjQrXUMcZ6Q4NSVNA6iPrb4ZfveBtAktU98uagAqs1sQk+BS1163u6U0UHAjAgw/Ve4Fvcnab+NBEnYbmW18tr87rQJej9OvKjHhTnwFNrtSgLTySpxog0haYyugYfRBNkmU29vkNKMidufqvvSmxZvBS4Uxo5I/TOUGOqlmvjOb7gKGymgKNYsj6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pcFU4Spcnn+N2esTXDkYB/bUx5lVmuk1m809xlJmUp8=;
 b=Yh7U3vvXB2D62geA06steyTNbwQYQmU7VU9v5Ly49agu3BRnRuWoNWnwIkNUls8oFStmCeKyMwktlOxMAWjc8mlS6qPPMKkiCzjCaCiABggau6CXHGaZ2yWg69YcuWO4EKldCy82IlqdG4Yi2dQwmmPJo8B5pyMQzqj6nzXhDvVQko9UVSJ9TLUg2DsWM6H77dYEi/OTACNYoyYlCP+8cGabp4qKZt0RXUXdz6OoGFu6q+dQ2au4JGiSS6EKthlqcLRHowMZXcr0aW3hlALC0IlRBGlQEAVHYL229cfL6qLeerf8/d1BXotDvlQ/7ZuVGrUlJr5HGf0Au4HM/S4qiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pcFU4Spcnn+N2esTXDkYB/bUx5lVmuk1m809xlJmUp8=;
 b=LH8UU2Or8+4VkgQBsTIC4dP0zcmneLlt65LvLy3NuJwQOzIHcXJIFaBXSJUrcWUAGIsgCkLVBuNavJHEZ1Sp3VPWhX3DgHDda1zlv1XMUMaYrDhWJPLE5G/jA2v6rzZqjbQhoF6xKewLusa17NvDVwtHOR46dhWVpczTL34u8HA=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5497.eurprd04.prod.outlook.com (2603:10a6:10:8a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Mon, 19 Oct
 2020 09:03:13 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 09:03:13 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Aisheng Dong <aisheng.dong@nxp.com>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>, Ying Liu <victor.liu@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 8/8] can: flexcan: add CAN wakeup function for i.MX8QM
Thread-Topic: [PATCH V2 8/8] can: flexcan: add CAN wakeup function for i.MX8QM
Thread-Index: AQHWpe2XWfxDML5yskGVs3LoA/x/dKmelDOAgAACi3CAAATLAIAAAG5g
Date:   Mon, 19 Oct 2020 09:03:12 +0000
Message-ID: <DB8PR04MB67957F30D89ABFCF0801D741E61E0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
 <20201019155737.26577-9-qiangqing.zhang@nxp.com>
 <3ca1d3e9-ef13-283f-8301-68c657628e41@pengutronix.de>
 <DB8PR04MB679531F0491CB52DC05DE624E61E0@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0e871906-e179-a2ea-1379-d0194c9d58fe@pengutronix.de>
In-Reply-To: <0e871906-e179-a2ea-1379-d0194c9d58fe@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: aisheng.dong@nxp.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fea6c6fb-507a-43c5-3847-08d8740dcf21
x-ms-traffictypediagnostic: DB7PR04MB5497:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5497F934B446046E94A6F198E61E0@DB7PR04MB5497.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ry1CUIa+ssWoH5PZLfcuOrRpVuZngXAHjUzX2pq7Q+hlAmQCLTjfziS5FjH0VoJ/Ip+vjMZ5l5LaR8UMKlxKFxv+OVy39xa1DEWnWYcKfsHdpx9RjtQ91ooyf2a0aqeuaALRSjHoyUE/UQQQbiEc8FprqjXfocCgRb+vH7bwiIdgdkOUKKgqRl9mLsSBS1057youYSENoh8F9hKAFcGx6LWInyqpM4whldVuT2C12waNJ2bjFWLFXTqZuhqILulizHOwyQ0GIWvVKuXAAKrYPoQ/eIFnQU5tdUOy3X+IhQtltOVXHxghoU1wQHTfOAprlutN1OUn8j+SQKHpgMp0yQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(86362001)(478600001)(52536014)(8676002)(2906002)(4326008)(71200400001)(33656002)(8936002)(83380400001)(6506007)(53546011)(7696005)(5660300002)(6636002)(26005)(76116006)(64756008)(316002)(66446008)(186003)(66476007)(66946007)(66556008)(9686003)(110136005)(55016002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: r9xOp2FeGImgKS03+ANhe4ckEVon02uunKloLkvWjPP+Dt+CWPsSxeAMle1/5O/7JMGWv1Q5oW2mKfbOdWP38F8uv+bzJJ/25L4534ssEVIMt9Bv2BO72bOR7FlxhIVOJJDwqfe3V1ikxm5aYbP7TiyUv1rT3w6tj4wJIU34iHCB7u9rXZmrnExaQvTQpPsbg11h5i5cP/F+2Sf1iVU2yJe5otGR8lf1dfsj2fzCwCk6KGmpHjmWOp/v77zxV5FiK+KYba/CZS2m+VPgM6T7IF+Ps99qGYp3pcBgS0AjecA1lqEAyhcnUh8uHcWbyeY6o/38WAngKgGV7KTtrDDQEMSps2MTkyb9CXgVG0tNxPM3Z6Ypf4JekBJLk0wKq6uyU9B5x4mOE7n7HtWavy5yCc4VTZzS3une2g5w/aOyciHFOwFsg7wC006vnGnBoAmOkyYME7ewepdUCH+ilzY4m+tnGiq/8rJ8hVtKDA1s2ld9O0nqO3+IAf/VNKlWy+CW4bEHe5SO8mOvJ5jtb8oqT9D8zSYlceTCzy5oN5OFOrL59o5tZbpMHxprJlnGFTgHvkvjyHVNk5bQhAb3Yk/Q/+KzubdT+VJL1r24s/eFNcsaUWlWoPiGyo2z8DhPBrQaWlPA05Fx3aRk10XmFQuGtQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea6c6fb-507a-43c5-3847-08d8740dcf21
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 09:03:12.9292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VJarVpn/zIjbcbXWIJQREd/97IiGa/WjuuKot95bsSUb1BjWqQ6+yYUL6ZZTdUjJWJDu/snOcL5YJLjdMGjipg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5497
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXJjLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMg
S2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQxMOaciDE5
5pelIDE2OjQyDQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsg
cm9iaCtkdEBrZXJuZWwub3JnOw0KPiBzaGF3bmd1b0BrZXJuZWwub3JnOyBzLmhhdWVyQHBlbmd1
dHJvbml4LmRlDQo+IENjOiBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7IGRsLWxpbnV4LWlteCA8bGlu
dXgtaW14QG54cC5jb20+OyBZaW5nIExpdQ0KPiA8dmljdG9yLmxpdUBueHAuY29tPjsgbGludXgt
Y2FuQHZnZXIua2VybmVsLm9yZzsgUGFua2FqIEJhbnNhbA0KPiA8cGFua2FqLmJhbnNhbEBueHAu
Y29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYyIDgvOF0gY2FuOiBmbGV4Y2FuOiBhZGQgQ0FO
IHdha2V1cCBmdW5jdGlvbiBmb3INCj4gaS5NWDhRTQ0KPiANCj4gT24gMTAvMTkvMjAgMTA6Mzkg
QU0sIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPj4+ICsjZGVmaW5lIEZMRVhDQU5fSU1YX1NDX1Jf
Q0FOKHgpCQkoSU1YX1NDX1JfQ0FOXzAgKyAoeCkpDQo+ID4+DQo+ID4+IFdoeSBub3QgbW92ZSBp
dCBpbnRvIHRoZSBhcHByb3ByaWF0ZSBzdmMgaGVhZGVyIGZpbGU/DQo+ID4NCj4gPiBTb3JyeSwg
bm90IHF1aXRlIHVuZGVyc3RhbmQuIFdoaWNoIGZpbGUgZG8geW91IG1lYW4gdGhlIGFwcHJvcHJp
YXRlDQo+ID4gc3ZjIGhlYWRlciBmaWxlPyBJcyBpdCBpbmNsdWRlL2R0LWJpbmRpbmdzL2Zpcm13
YXJlL2lteC9yc3JjLmg/DQo+IA0KPiB5ZXMsIEkgbWVhbnQgdGhhdDoNCj4gDQo+ID4gaW5jbHVk
ZS9kdC1iaW5kaW5ncy9maXJtd2FyZS9pbXgvcnNyYy5oOjExMTojZGVmaW5lIElNWF9TQ19SX0NB
Tl8wDQo+IDEwNQ0KDQpBcyBJIGNhbiBzZWUgaW4gcnNyYy5oIGZpbGUsIGl0IGp1c3QgbGlzdCBl
YWNoIHJlc291cmNlIHNlcXVlbnRpYWxseSwgYW5kIHRoZXJlIGlzIGEgbm90ZSBpbiB0aGUgY29t
bWVudHM6DQoiTm90ZSBpdGVtcyBmcm9tIGxpc3Qgc2hvdWxkIG5ldmVyIGJlIGNoYW5nZWQgb3Ig
cmVtb3ZlZCAob25seSBhZGRlZCB0byBhdCB0aGUgZW5kIG9mIHRoZSBsaXN0KS4iDQpTbyB0aGUg
ZHJpdmVyIGF1dGhvciBkb2Vzbid0IHdhbnQgYW55IHNjdSB1c2VycyB0byBjaGFuZ2UgdGhlc2Ug
cmVzb3VyY2UgbWFjcm8uIElmIHdlIG9ubHkgZG8gYmVsb3cgY2hhbmdlIGZvciBDQU4sIGJ1dCBr
ZWVwIG90aGVyIGRldmljZXMgdW5jaGFuZ2VkLA0KSXQgd291bGQgYmUgdmVyeSBzdHJhbmdlLiBB
bmQgSSB0aGluayB0aGlzIGNvZGUgY2hhbmdlIGNvdWxkIG5vdCBiZSBhY2NlcHRlZC4gVGhlcmUg
bWF5IGJlIGFub3RoZXIgY29uc2lkZXJhdGlvbiwgbm93IHdlIG9ubHkgaGFzIDMgQ0FOIGluc3Rh
bmNlcywgaG93IGNhbiB3ZSBoYW5kbGUNCmlmIGxhdGVyIFNvQ3MgaGF2ZSBtb3JlIENBTiBpbnN0
YW5jZXMsIGFuZCB0aGV5IHN0aWxsIHdhbnQgdG8gcmV1c2UgdGhpcyBoZWFkZXIgZmlsZS4gVGhp
cyBpcyBhbHNvIHJlYXNvbiBJIHByZWZlciB0byB1c2UgdGhlc2UgZGVmaW5lZCBtYWNyb3MgZGly
ZWN0bHkgaW4gZmxleGNhbiBkcml2ZXIuIA0KDQotLS0gYS9pbmNsdWRlL2R0LWJpbmRpbmdzL2Zp
cm13YXJlL2lteC9yc3JjLmgNCisrKyBiL2luY2x1ZGUvZHQtYmluZGluZ3MvZmlybXdhcmUvaW14
L3JzcmMuaA0KQEAgLTEwOCw5ICsxMDgsNyBAQA0KICNkZWZpbmUgSU1YX1NDX1JfQURDXzEgICAg
ICAgICAgICAgICAgIDEwMg0KICNkZWZpbmUgSU1YX1NDX1JfRlRNXzAgICAgICAgICAgICAgICAg
IDEwMw0KICNkZWZpbmUgSU1YX1NDX1JfRlRNXzEgICAgICAgICAgICAgICAgIDEwNA0KLSNkZWZp
bmUgSU1YX1NDX1JfQ0FOXzAgICAgICAgICAgICAgICAgIDEwNQ0KLSNkZWZpbmUgSU1YX1NDX1Jf
Q0FOXzEgICAgICAgICAgICAgICAgIDEwNg0KLSNkZWZpbmUgSU1YX1NDX1JfQ0FOXzIgICAgICAg
ICAgICAgICAgIDEwNw0KKyNkZWZpbmUgSU1YX1NDX1JfQ0FOKHgpICAgICAgICAgICAgICAgICAo
MTA1ICsgKHgpKQ0KICNkZWZpbmUgSU1YX1NDX1JfRE1BXzFfQ0gwICAgICAgICAgICAgIDEwOA0K
ICNkZWZpbmUgSU1YX1NDX1JfRE1BXzFfQ0gxICAgICAgICAgICAgIDEwOQ0KICNkZWZpbmUgSU1Y
X1NDX1JfRE1BXzFfQ0gyICAgICAgICAgICAgIDExMA0KIA0KQWRkIEBBaXNoZW5nIERvbmcsIGNv
dWxkIGFib3ZlIGNvZGUgY2hhbmdlcyBjYW4gYmUgYWNjZXB0ZWQgYnkgeW91Pw0KDQpCZXN0IFJl
Z2FyZHMsDQpKb2FraW0gWmhhbmcNCg==
