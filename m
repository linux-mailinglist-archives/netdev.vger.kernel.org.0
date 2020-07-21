Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54D3227A28
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 10:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgGUIFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 04:05:07 -0400
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:43662
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728410AbgGUIFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 04:05:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=borPaTWD/SCsFx9yARv1bsx/6J8eDuN0avMCG6kRCGBVDUm8a2VRqy3Wf/o/dunnqrxVQxKwy10r14y8equzpJ0+T7qT2dA6pYhcLeL9mKcfueYJ1Ax6GtE581Y9+vtFyBwERN7hUpTPCjTG63dT/Esl6wFMZj0EyF37TweScaRNOHVD53R+WqwDpBByPxXq+UHkwzj3dJpKPNtoXSM+1lABJ0Pst0TymwxkfqgsEOabUSIii0sBsLew52tx3RWZ2BJxxqLAJYtVglIB0KrjGlQkiWrGg4boeMJF1UYgunPtJBV5FSWbexicwxhwUqr83hUmhsfTlJ6ksCsPV09AMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llDb7qNI2ghYI44h7O5sEa43yBD2OFwWZPTGouC/xiI=;
 b=bt7pYV/4dJPp0fpuYtV+IsARarcb2QJk3uDSXsmJN3IeAHdy4+xbsZHbXhw0ODL/Z7kfeUIYbuiAqMcg4S3l8FF9MfZtqf+32Mhh+5rxq6NuHKUWq3HD16JGF249mx+fOpqfsgbxEGsBgzQOhQ/+E/UYT1+CAe5QNKx8I2+l3ol0t5GjPgf1gdtcvkogpaEuAKLdTVxiUI4raQsSfE1JxPIOC0kKFzA2i+aF8kBR6zlAG8gtXWJDxYywmKj0FTtuK3Zzlkh0HokAX2Qmsfw4o9pKrC9wKAF+NVDUPIcwZ7cHOYEwEtO2/eZp4XKpa4sBysModDcJeYbLEMu29/6WOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llDb7qNI2ghYI44h7O5sEa43yBD2OFwWZPTGouC/xiI=;
 b=ne5CPu09lIdAzVkFVEwDIHQnLr6unhCRlfcINKFoQiJH28ZQFfrU8ptpXJBEbjCFkz9TiIAjYNc3cH9VTJsg2b7x1hQKErBk+S/4ff5KrrwOwVDeLzDtZnyErScfVmbAKNXfRiuUQvQNWdAas8iMlYxp2bmKBcTmhOzno5sOST0=
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31)
 by DB7PR04MB4363.eurprd04.prod.outlook.com (2603:10a6:5:28::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 08:05:00 +0000
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::b05c:ed83:20b9:b2f9]) by DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::b05c:ed83:20b9:b2f9%6]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 08:05:00 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 6/6] enetc: Add adaptive interrupt coalescing
Thread-Topic: [PATCH net-next v2 6/6] enetc: Add adaptive interrupt coalescing
Thread-Index: AQHWXFAoZ+ojvBeYcUWdR5FbrDR1sqkMKMIAgAFuCACABBq1cA==
Date:   Tue, 21 Jul 2020 08:05:00 +0000
Message-ID: <DB8PR04MB6764A606445307CD726363F896780@DB8PR04MB6764.eurprd04.prod.outlook.com>
References: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
 <1595000224-6883-7-git-send-email-claudiu.manoil@nxp.com>
 <20200717123014.4a68dad4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <71e698b5-5e52-44fb-48e6-ed9ce94cd978@gmail.com>
In-Reply-To: <71e698b5-5e52-44fb-48e6-ed9ce94cd978@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.66.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 57489009-c954-489a-752a-08d82d4cc42c
x-ms-traffictypediagnostic: DB7PR04MB4363:
x-microsoft-antispam-prvs: <DB7PR04MB43637954427CD45FB3EE2D9996780@DB7PR04MB4363.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eDWVip8ejZaIQLZJdUGpFMhK2bViCzTx6DWCKUZm633JzNHslFwPmQxumiEaKP92nmz82tI05v9hNJxSAL7DcYOFTuqJXBH/i1Z/KH3i3aBBuLZgTjESC2tNSd9GYm8UdogUWCR+wJwqRLLfvotuxhctBJjFZOJez+AdokPMsNB8FHa9MIH/1JpGbtGX5jEQmZgSGB8DqGSD65S7Zod/E2n7KeAwWySusiEIcOQUE65CHd/PLoNqx5rQ2skdUP5X1R6EhGdtm01zn6/8uyYOLBuYnuYbO3Ta69Pp5wyoZ1nwJssI5KzXtcX5dI/Dg4eB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6764.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(4326008)(54906003)(44832011)(6506007)(33656002)(316002)(83380400001)(8676002)(55016002)(26005)(478600001)(66476007)(76116006)(5660300002)(8936002)(2906002)(7696005)(86362001)(71200400001)(9686003)(6916009)(66556008)(66946007)(186003)(52536014)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: llUh4jKLgtrVXqYQJKL8u3sXQXmD+16kX3F1sQQKADdsVp4CDSulQcgCF9XPNFFD15RXdQfC0MJVglj4kgb0d/VAosj/GQNjNeZkbFKuq+nB32PYWnnzbDQqh40WbzRcxRhEoN/oeXMlhkVk6blLxZkDcnk+vzJO7mzzzxis7erj30+EiYRBxRGNM2jpKMBn13rQ400KMHywga+96/3hT/1ONH8caENrEFU7kPbtKCKUC3EYYqCayodIty4S8cOoQQa7F5nNmacTtcqHSVBtGr1MMbaWP9BrvJGpxf0A9s92MV3FKrSUbWh4V+PI3XY7t/cNojodvQZ22bKpr4RXyupu8FlEkYVSH+dBGjFkEqsAi1jsyieOzIO/b3zbIr5clSNZQJs1uDHQcWsTpSTcD23po8kKEuUeOyEtyR1khI/TiPx//GbFlFiGRQNOR6ZJ8Ok1DinPm6jQbp0YzMwU5MVkaBIBh+cqkg5FrZ0zZ/4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6764.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57489009-c954-489a-752a-08d82d4cc42c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 08:05:00.3748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EdTAj3UTU7rnxISZ9ZVIaMHoUzcqWLu1ep2P1nhd1I3ouAV0IcD/PEIvHyZ3acBFo9meBscOK0D+mh1omk9PSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4363
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogQ2xhdWRpdSBNYW5vaWwgPGNsYXVk
aXUubWFub2lsQGdtYWlsLmNvbT4NCj5TZW50OiBTYXR1cmRheSwgSnVseSAxOCwgMjAyMCA4OjIw
IFBNDQpbLi4uXQ0KPlN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjIgNi82XSBlbmV0Yzog
QWRkIGFkYXB0aXZlIGludGVycnVwdCBjb2FsZXNjaW5nDQo+DQo+DQo+T24gMTcuMDcuMjAyMCAy
MjozMCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+PiBPbiBGcmksIDE3IEp1bCAyMDIwIDE4OjM3
OjA0ICswMzAwIENsYXVkaXUgTWFub2lsIHdyb3RlOg0KPj4+ICsJaWYgKHR4X2ljdHQgPT0gRU5F
VENfVFhJQ19USU1FVEhSKQ0KPj4+ICsJCWljX21vZGUgfD0gRU5FVENfSUNfVFhfT1BUSU1BTDsN
Cj4+DQo+PiBEb2Vzbid0IHNlZW0geW91IGV2ZXIgcmVhZC9jaGVjayB0aGUgRU5FVENfSUNfVFhf
T1BUSU1BTCBmbGFnPw0KPj4NCj4NCj5JdCdzIHVzZWQgaW1wbGljaXRseSB0aG91Z2ggOyksIGFz
IGl0IHNpZ25hbHMgYSBzdGF0ZSBjaGFuZ2Ugd2hlbg0KPnRoZSB1c2VyIGNoYW5nZXMgdGhlIGRl
ZmF1bHQgdmFsdWUgb2YgdGhlIHR4IHRpbWUgdGhyZXNob2xkLA0KPnRyaWdnZXJpbmcgdGhlIGRl
dmljZSByZWNvZmlndXJhdGlvbiB3aXRoIHRoZSBuZXcgdmFsdWUuIFRydWUgdGhhdA0KPnRoZSBz
YWlkIHJlY29uZmlndXJhdGlvbiBjb3VsZCBiZSBhbHNvIHBlcmZvcm1lZCBpbiB0aGUgJ01BTlVB
TCcgc3RhdGUuDQo+SSBhZGRlZCB0aGUgZXh0cmEgc3RhdGUgY2FsbGVkICdPUFRJTUFMJyB0byBt
YWtlIHRoZSBjb2RlIG1vcmUgZWFzaWVyIHRvDQo+Zm9sbG93IGFjdHVhbGx5LiBJIG1lYW4sIGl0
J3MgZWFzeSB0byBmb2xsb3cgdGhhdCB0aGUgdHggY29hbGVzY2luZw0KPnN0YXRlIHN0YXJ0cyBp
biB0aGUgIk9QVElNQUwiIG1vZGUsIHcvIHRoZSBwcmVjb25maWd1cmVkICJvcHRpbWFsIg0KPnZh
bHVlLiBUaGVuIGlmIHRoZSB1c2VyIGNoYW5nZXMgdGhlIHZhbHVlLCBkb2luZyBzb21lIG1hbnVh
bCB0dW5pbmcgb2YNCj50eC11c2VjcywgaXQgbW92ZXMgaW50byB0aGUgJ01BTlVBTCcgbW9kZSwg
cmV0dXJuaW5nIHRvIHRoZSAnT1BUSU1BTCcNCj5tb2RlIGlmIHRoZSB1c2VyIGdvZXMgYmFjayB0
byB0aGUgb3B0aW1hbCB2YWx1ZS4NCj5UaGlzIGhhbmRsaW5nIGNvdWxkIGFsc28gYmUgZG9uZSBp
biB0aGUgJ01BTlVBTCcgbW9kZSBhbG9uZSwgc28gaWYgeW91DQo+d2FudCBtZSB0byBtYWtlIHRo
aXMgY2hhbmdlIHBscyBsZXQgbWUga25vdy4NCj4NCg0KUmVtb3ZlZCB0aGUgJ09QVElNQUwnIGZs
YWcsIHRoZSBjb2RlIGxvb2tzIHNpbXBsZXIgKGZld2VyIGxpbmVzKSwgYW5kDQpJJ20gb2sgd2l0
aCBpdC4gIFVwZGF0ZWQgaW4gdjMuDQo=
