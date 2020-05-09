Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F091CC0C5
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 13:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgEILQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 07:16:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7542 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725920AbgEILQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 07:16:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049BF2HJ028103;
        Sat, 9 May 2020 04:16:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=RkV6TFzFEqkYQ7vcn0dOpQpgkF/Ghv5ZlAIv7Ul/xbU=;
 b=dG6WjDe2bnPqE987mOJioDfAHCeSYyYIQf2yVw+fiqovHtoEixbdrs+QWMVw9bDL26Nw
 UbjNgpCvTJJbLubV7bj7ZWwBC8hKlR0jQoFMNWlgulyay4zSVTHAXd8GwF+p/cXuwCZk
 MqhaVOZrv2xwBI5scKR2izokiTRaOtLmOiHILHcCWr2iaRRT+Ek6Mctcg4dE3LTkVIRn
 BZrptsRvZR2pj/FsQsVx2audMqo0RVXZ39imsyhcH/vb8pau8e59cuKCHEhKlLWY7O2x
 847QgFNnGfbXVC+ElMWvtlNEZXGFveZQyG/FxJaigR55q6CbAry4k+hISLSwJa5mGJhX yQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30wsvq87tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 09 May 2020 04:16:02 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 9 May
 2020 04:16:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 9 May 2020 04:16:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3Rn2fmSnT/yZyV6z3u3Kx53K82GqrXTghHxM8kpwgPaYEW3eVEjHjV9mjdQzCTOiXD8UYsn0Jbhfi/aXNilsHTROlbvfZNUheh8pkjHoMO1faB8VRfo0VaHOVnFOhRDSqhYBcVAFL7I+JuQy/a71hZUjjNGVdbrq4pUacG/VumEvB4o7wL0rQZB+uLQnd92p+rizvn2fyId4Hhory4ZFPot1aKqpB3lQtQeQniO3PpZkc6wononLyOhSHBYcWfJhlfWrpbyPGs/dP5aj9Hcy7IOhmUPIk3ksADns2x16Vy4AslXpDhjQfgISruBk/pbJgJGowCZT6ZTll37GXXlgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkV6TFzFEqkYQ7vcn0dOpQpgkF/Ghv5ZlAIv7Ul/xbU=;
 b=UohIpMu3+Z8Ya3O8kv+6cyZ95NyDmn9DZcHxAQ2z1iv6d0kBFRqDW4KIq6AQtrP1O7aKvCDN/wSAhO+iYyS677cybMDXo+QyhVrCbp/OrVCoWiFdJyRdSKYMMV7x2gsXRjZMBxm5+Lqdx9H0z+hDIFEjfCQWisf87safVS3wozwyrhPAVJfkMrhgSEbUGJhRIopnkbdlk7lu9TugrbEoO8RCU3PMnUfabdM5m+2VDj8oUqj0A8G//eJTZHrlLqLiaD97r/qiBva6CFqcdLaEWo4a2nWYe+muJCreq0vjfRmKw9MuSrN5xI7bn6wedMpOq9JQv1sRGaD36Wi25dCt4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkV6TFzFEqkYQ7vcn0dOpQpgkF/Ghv5ZlAIv7Ul/xbU=;
 b=VpUHhW6xZ4SHwNA5+BFfqRemZgNiziXjgFC0k1e3FkI5X0JJg9V67a6mv1+DLcnfVJ3Li/gtTQrjN7LjEigugTFj386SQkFJTawGo6+GIfThVnkTsSYlt+xX0RK1eIDavd0nFQRpHd36zDFO6qvsNo5l/DRkgWh7JKJ3SawFL20=
Received: from DM5PR18MB1146.namprd18.prod.outlook.com (2603:10b6:3:2c::15) by
 DM5PR18MB1355.namprd18.prod.outlook.com (2603:10b6:3:14a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.33; Sat, 9 May 2020 11:15:59 +0000
Received: from DM5PR18MB1146.namprd18.prod.outlook.com
 ([fe80::51c3:5502:21c2:f515]) by DM5PR18MB1146.namprd18.prod.outlook.com
 ([fe80::51c3:5502:21c2:f515%12]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 11:15:59 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Matteo Croce <mcroce@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "Russell King - ARM Linux admin" <linux@armlinux.org.uk>
Subject: RE: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
Thread-Topic: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
Thread-Index: AQHWGZC7cQmjD8WUCU6s0i6IN8JFgKie+g2AgAC4ufA=
Date:   Sat, 9 May 2020 11:15:58 +0000
Message-ID: <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com>
 <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk>
 <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
In-Reply-To: <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.83.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36b77b11-4e8a-4491-cd6b-08d7f40a59f9
x-ms-traffictypediagnostic: DM5PR18MB1355:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB135570936218B1E98171C77FB0A30@DM5PR18MB1355.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03982FDC1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j9rLrFVaiMngMiG7pf194lCPsrfqBFE7+vZMS5Ph3/gTwDquoN5QkFH+RVMpqHJmisZa6cRFkayWRemwqztUoBcqqjxSTDlV8wm2NOV2c21GpNwF/x/muwSgDxYO2AJPGCiuBjZj2T7/259OqRUm0TgSxdwo66uUL2YVYnI2uWgaxVW0JVIP0FCJ4tlDrvpGA7yNnv3N5qAi+oVNbmmPKdXJypD+8EDxs0sljPBEB4Nha1glxHogJ7Eg/Snby6un2lmVO2MmrNPoFwT/1dsYVQXXuR7eelwtvpG5cd4+gNDduI01nM7jAH6NiLRiGfRBewfJP41MRO4hXqcV/PoBWVUCK7bY1ZHgo9wYLaPy/ECsfHRGiK5NQXrQh2FbREG8tHRBkZ5FVwp4OFvIjruuk56jMkPNDfgJcZC0yEZ/Jajh911GRKKpup+l4E+zQqM9eQ1NKzVdO9kiIX8doPjkVvr89w25zMJZWbYxbC6GsSi9N9F7qr+/G8E/wGXrMQFMHt+Yk5x/z5OLLAorKAyLNvyZv586ERkGzUIYG8pFurWD4YbLg79Tt9nDMIcxmOxFTf5yHFQX0d5ku6xrUg7WffhG+18OjaEDMg9C3Tm4f+I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR18MB1146.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(376002)(39850400004)(136003)(33430700001)(8936002)(53546011)(26005)(5660300002)(6506007)(9686003)(186003)(33440700001)(2906002)(7696005)(8676002)(66946007)(66476007)(86362001)(55016002)(66556008)(52536014)(54906003)(71200400001)(316002)(110136005)(64756008)(7416002)(966005)(76116006)(4326008)(478600001)(66446008)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RJ5XKLIdLiyekOBxzUFEqwvYx/5TWJN+CFO/QAGaE/Plmu2mHs7CT1lq5zZvpobG8A0kETRltoPcJ1SsvuI1OU1uayEiml/QVivyQEH/XzFu7iX/KFMt7TzaNnZKZDaw7MQ6cE4aBgJbEvtdLxP9/zcw/Gu2HRyG2IOkxGp3f1eZn6fMZK0utGjgJamU4R+JbRdPBLV+57sgMV1YBHpmEFhiMaJCs6+xTBmbzGbHoYuuMFynhpleqsCSzUqh239CPsNWX6JxxxcvFvEF7qBY+c1C224oszbtON1nyfyJcw57Y3EvqAJzWrzpSZPTvcm3IvUSQun3raxXfkp87Y2AwewU3kHscFK1uPdV7HNlUQdFX1vWQWylJomNswuxZqm7KTOX3zviPC4FkptVF5FoF7gLcnmNgvC3nJ3iOGp+c8Hm/z+DsUlliPJBI9RSLr8hwBEGBeuFYp9aagx+k/e6Htx3nWBJtc5y4h7pOi+xiBI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b77b11-4e8a-4491-cd6b-08d7f40a59f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2020 11:15:58.9789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qf5jSd3hRRHsLNC2hhMdnbS7UyZV10j3qf2lUozTspAMpBqLvisxvRhPTT6RIcw+ugq4HEWES8n7L2aelZLxiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1355
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_03:2020-05-08,2020-05-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWF0dGVvIENyb2NlIDxt
Y3JvY2VAcmVkaGF0LmNvbT4NCj4gU2VudDogU2F0dXJkYXksIE1heSA5LCAyMDIwIDM6MTMgQU0N
Cj4gVG86IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IENjOiBNYXhp
bWUgQ2hldmFsbGllciA8bWF4aW1lLmNoZXZhbGxpZXJAYm9vdGxpbi5jb20+OyBuZXRkZXYNCj4g
PG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBMS01MIDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnPjsgQW50b2luZQ0KPiBUZW5hcnQgPGFudG9pbmUudGVuYXJ0QGJvb3RsaW4uY29tPjsgVGhv
bWFzIFBldGF6em9uaQ0KPiA8dGhvbWFzLnBldGF6em9uaUBib290bGluLmNvbT47IGdyZWdvcnku
Y2xlbWVudEBib290bGluLmNvbTsNCj4gbWlxdWVsLnJheW5hbEBib290bGluLmNvbTsgTmFkYXYg
SGFrbGFpIDxuYWRhdmhAbWFydmVsbC5jb20+OyBTdGVmYW4NCj4gQ2h1bHNraSA8c3RlZmFuY0Bt
YXJ2ZWxsLmNvbT47IE1hcmNpbiBXb2p0YXMgPG13QHNlbWloYWxmLmNvbT47IExpbnV4DQo+IEFS
TSA8bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnPjsgUnVzc2VsbCBLaW5nIC0g
QVJNIExpbnV4IGFkbWluDQo+IDxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+IFN1YmplY3Q6IFtF
WFRdIFJlOiBbUEFUQ0ggbmV0LW5leHQgMy81XSBuZXQ6IG12cHAyOiBjbHM6IFVzZSBSU1MgY29u
dGV4dHMgdG8NCj4gaGFuZGxlIFJTUyB0YWJsZXMNCj4gDQo+IEV4dGVybmFsIEVtYWlsDQo+IA0K
PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQo+IE9uIFRodSwgQXByIDIzLCAyMDIwIGF0IDc6MDAgUE0gUnVzc2Vs
bCBLaW5nIC0gQVJNIExpbnV4IGFkbWluDQo+IDxsaW51eEBhcm1saW51eC5vcmcudWs+IHdyb3Rl
Og0KPiA+DQo+ID4gT24gVHVlLCBBcHIgMTQsIDIwMjAgYXQgMDE6NDM6MDJBTSArMDIwMCwgTWF0
dGVvIENyb2NlIHdyb3RlOg0KPiA+ID4gT24gVHVlLCBBcHIgMTQsIDIwMjAgYXQgMToyMSBBTSBN
YXhpbWUgQ2hldmFsbGllcg0KPiA+ID4gPG1heGltZS5jaGV2YWxsaWVyQGJvb3RsaW4uY29tPiB3
cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4gVGhlIFBQdjIgY29udHJvbGxlciBoYXMgOCBSU1MgdGFi
bGVzIHRoYXQgYXJlIHNoYXJlZCBhY3Jvc3MgYWxsDQo+ID4gPiA+IHBvcnRzIG9uIGEgZ2l2ZW4g
UFB2MiBpbnN0YW5jZS4gVGhlIHByZXZpb3VzIGltcGxlbWVudGF0aW9uDQo+ID4gPiA+IGFsbG9j
YXRlZCBvbmUgdGFibGUgcGVyIHBvcnQsIGxlYXZpbmcgb3RoZXJzIHVudXNlZC4NCj4gPiA+ID4N
Cj4gPiA+ID4gQnkgdXNpbmcgUlNTIGNvbnRleHRzLCB3ZSBjYW4gbWFrZSB1c2Ugb2YgbXVsdGlw
bGUgUlNTIHRhYmxlcyBwZXINCj4gPiA+ID4gcG9ydCwgb25lIGJlaW5nIHRoZSBkZWZhdWx0IHRh
YmxlIChhbHdheXMgaWQgMCksIHRoZSBvdGhlciBvbmVzDQo+ID4gPiA+IGJlaW5nIHVzZWQgYXMg
ZGVzdGluYXRpb25zIGZvciBmbG93IHN0ZWVyaW5nLCBpbiB0aGUgc2FtZSB3YXkgYXMgcnggcmlu
Z3MuDQo+ID4gPiA+DQo+ID4gPiA+IFRoaXMgY29tbWl0IGludHJvZHVjZXMgUlNTIGNvbnRleHRz
IG1hbmFnZW1lbnQgaW4gdGhlIFBQdjIgZHJpdmVyLg0KPiA+ID4gPiBXZSBhbHdheXMgcmVzZXJ2
ZSBvbmUgdGFibGUgcGVyIHBvcnQsIGFsbG9jYXRlZCB3aGVuIHRoZSBwb3J0IGlzIHByb2JlZC4N
Cj4gPiA+ID4NCj4gPiA+ID4gVGhlIGdsb2JhbCB0YWJsZSBsaXN0IGlzIHN0b3JlZCBpbiB0aGUg
c3RydWN0IG12cHAyLCBhcyBpdCdzIGENCj4gPiA+ID4gZ2xvYmFsIHJlc291cmNlLiBFYWNoIHBv
cnQgdGhlbiBtYWludGFpbnMgYSBsaXN0IG9mIGluZGljZXMgaW4NCj4gPiA+ID4gdGhhdCBnbG9i
YWwgdGFibGUsIHRoYXQgd2F5IGVhY2ggcG9ydCBjYW4gaGF2ZSBpdCdzIG93biBudW1iZXJpbmcN
Cj4gPiA+ID4gc2NoZW1lIHN0YXJ0aW5nIGZyb20gMC4NCj4gPiA+ID4NCj4gPiA+ID4gT25lIGxp
bWl0YXRpb24gdGhhdCBzZWVtcyB1bmF2b2lkYWJsZSBpcyB0aGF0IHRoZSBoYXNoaW5nDQo+ID4g
PiA+IHBhcmFtZXRlcnMgYXJlIHNoYXJlZCBhY3Jvc3MgYWxsIFJTUyBjb250ZXh0cyBmb3IgYSBn
aXZlbiBwb3J0Lg0KPiA+ID4gPiBIYXNoaW5nIHBhcmFtZXRlcnMgZm9yIGN0eCAwIHdpbGwgYmUg
YXBwbGllZCB0byBhbGwgY29udGV4dHMuDQo+ID4gPiA+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6
IE1heGltZSBDaGV2YWxsaWVyIDxtYXhpbWUuY2hldmFsbGllckBib290bGluLmNvbT4NCj4gPiA+
DQo+ID4gPiBIaSBhbGwsDQo+ID4gPg0KPiA+ID4gSSBub3RpY2VkIHRoYXQgZW5hYmxpbmcgcnho
YXNoIGJsb2NrcyB0aGUgUlggb24gbXkgTWFjY2hpYXRvYmluLiBJdA0KPiA+ID4gd29ya3MgZmlu
ZSB3aXRoIHRoZSAxMEcgcG9ydHMgKHRoZSBSWCByYXRlIGdvZXMgNHggdXApIGJ1dCBpdA0KPiA+
ID4gY29tcGxldGVseSBraWxscyB0aGUgZ2lnYWJpdCBpbnRlcmZhY2UuDQo+ID4gPg0KPiA+ID4g
IyAxMEcgcG9ydA0KPiA+ID4gcm9vdEBtYWNjaGlhdG9iaW46fiMgaXBlcmYzIC1jIDE5Mi4xNjgu
MC4yIENvbm5lY3RpbmcgdG8gaG9zdA0KPiA+ID4gMTkyLjE2OC4wLjIsIHBvcnQgNTIwMSBbICA1
XSBsb2NhbCAxOTIuMTY4LjAuMSBwb3J0IDQyMzk0IGNvbm5lY3RlZA0KPiA+ID4gdG8gMTkyLjE2
OC4wLjIgcG9ydCA1MjAxDQo+ID4gPiBbIElEXSBJbnRlcnZhbCAgICAgICAgICAgVHJhbnNmZXIg
ICAgIEJpdHJhdGUgICAgICAgICBSZXRyICBDd25kDQo+ID4gPiBbICA1XSAgIDAuMDAtMS4wMCAg
IHNlYyAgIDk0MSBNQnl0ZXMgIDcuODkgR2JpdHMvc2VjICA0MDMwICAgIDI1MCBLQnl0ZXMNCj4g
PiA+IFsgIDVdICAgMS4wMC0yLjAwICAgc2VjICAgOTMzIE1CeXRlcyAgNy44MiBHYml0cy9zZWMg
IDQzOTMgICAgMjQwIEtCeXRlcw0KPiA+ID4gcm9vdEBtYWNjaGlhdG9iaW46fiMgZXRodG9vbCAt
SyBldGgwIHJ4aGFzaCBvbiByb290QG1hY2NoaWF0b2Jpbjp+Iw0KPiA+ID4gaXBlcmYzIC1jIDE5
Mi4xNjguMC4yIENvbm5lY3RpbmcgdG8gaG9zdCAxOTIuMTY4LjAuMiwgcG9ydCA1MjAxIFsNCj4g
PiA+IDVdIGxvY2FsIDE5Mi4xNjguMC4xIHBvcnQgNDIzOTggY29ubmVjdGVkIHRvIDE5Mi4xNjgu
MC4yIHBvcnQgNTIwMQ0KPiA+ID4gWyBJRF0gSW50ZXJ2YWwgICAgICAgICAgIFRyYW5zZmVyICAg
ICBCaXRyYXRlICAgICAgICAgUmV0ciAgQ3duZA0KPiA+ID4gWyAgNV0gICAwLjAwLTEuMDAgICBz
ZWMgICA4NjAgTUJ5dGVzICA3LjIxIEdiaXRzL3NlYyAgNDI4ICAgIDQxMCBLQnl0ZXMNCj4gPiA+
IFsgIDVdICAgMS4wMC0yLjAwICAgc2VjICAgODU5IE1CeXRlcyAgNy4yMCBHYml0cy9zZWMgIDE4
NSAgICA1NjMgS0J5dGVzDQo+ID4gPg0KPiA+ID4gIyBnaWdhYml0IHBvcnQNCj4gPiA+IHJvb3RA
bWFjY2hpYXRvYmluOn4jIGlwZXJmMyAtYyB0dXJibyBDb25uZWN0aW5nIHRvIGhvc3QgdHVyYm8s
IHBvcnQNCj4gPiA+IDUyMDEgWyAgNV0gbG9jYWwgMTkyLjE2OC44NS40MiBwb3J0IDQ1MTQ0IGNv
bm5lY3RlZCB0byAxOTIuMTY4Ljg1LjYNCj4gPiA+IHBvcnQgNTIwMQ0KPiA+ID4gWyBJRF0gSW50
ZXJ2YWwgICAgICAgICAgIFRyYW5zZmVyICAgICBCaXRyYXRlICAgICAgICAgUmV0ciAgQ3duZA0K
PiA+ID4gWyAgNV0gICAwLjAwLTEuMDAgICBzZWMgICAxMTMgTUJ5dGVzICAgOTQ4IE1iaXRzL3Nl
YyAgICAwICAgIDQwNyBLQnl0ZXMNCj4gPiA+IFsgIDVdICAgMS4wMC0yLjAwICAgc2VjICAgMTEy
IE1CeXRlcyAgIDk0MiBNYml0cy9zZWMgICAgMCAgICA0MjggS0J5dGVzDQo+ID4gPiByb290QG1h
Y2NoaWF0b2Jpbjp+IyBldGh0b29sIC1LIGV0aDIgcnhoYXNoIG9uIHJvb3RAbWFjY2hpYXRvYmlu
On4jDQo+ID4gPiBpcGVyZjMgLWMgdHVyYm8NCj4gPiA+IGlwZXJmMzogZXJyb3IgLSB1bmFibGUg
dG8gY29ubmVjdCB0byBzZXJ2ZXI6IFJlc291cmNlIHRlbXBvcmFyaWx5DQo+ID4gPiB1bmF2YWls
YWJsZQ0KPiA+ID4NCj4gPiA+IEkndmUgYmlzZWN0ZWQgYW5kIGl0IHNlZW1zIHRoYXQgdGhpcyBj
b21taXQgY2F1c2VzIHRoZSBpc3N1ZS4gSQ0KPiA+ID4gdHJpZWQgdG8gcmV2ZXJ0IGl0IG9uIG5l
eC1uZXh0IGFzIGEgc2Vjb25kIHRlc3QsIGJ1dCB0aGUgY29kZSBoYXMNCj4gPiA+IGNoYW5nZWQg
YSBsb3QgbXVjaCBzaW5jZSwgZ2VuZXJhdGluZyB0b28gbXVjaCBjb25mbGljdHMuDQo+ID4gPiBD
YW4geW91IGhhdmUgYSBsb29rIGludG8gdGhpcz8NCj4gPg0KPiA+IFRoaXMgYmVoYXZpb3VyIG9u
IGV0aDIgaXMgY29uZmlybWVkIGhlcmUgb24gdjUuNi4gIFR1cm5pbmcgb24gcnhoYXNoDQo+ID4g
YXBwZWFycyB0byBwcmV2ZW50IGV0aDIgd29ya2luZy4NCj4gPg0KPiA+IE1heGltZSwgcGxlYXNl
IGxvb2sgaW50byB0aGlzIHJlZ3Jlc3Npb24sIHRoYW5rcy4NCj4gPg0KPiA+IC0tDQo+ID4gUk1L
J3MgUGF0Y2ggc3lzdGVtOg0KPiA+IGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92
Mi91cmw/dT1odHRwcy0zQV9fd3d3LmFybWxpbnV4Lm9yZy4NCj4gPg0KPiB1a19kZXZlbG9wZXJf
cGF0Y2hlc18mZD1Ed0lCYVEmYz1uS2pXZWMyYjZSMG1PeVBhejd4dGZRJnI9RERRM2RLDQo+IHdr
VEl4Sw0KPiA+IEFsNl9CczdHTXg0emhKQXJyWEtOMm1ETU9YR2g3bGcmbT1udFQ3V0ttemxhNjVW
V1ZQWk1DcjItDQo+IDhiVEdxNGNYZEoxUlJMDQo+ID4gZ3FGa21VYyZzPWpoS1JvaGx5VTBYdFgw
VTBSanQ2WHZKZ01LTHlfSGVkYUZWU0p3R1l1RDgmZT0NCj4gPiBGVFRDIGJyb2FkYmFuZCBmb3Ig
MC44bWlsZSBsaW5lIGluIHN1YnVyYmlhOiBzeW5jIGF0IDEwLjJNYnBzIGRvd24NCj4gPiA1ODdr
YnBzIHVwDQo+ID4NCj4gDQo+IEhpLA0KPiANCj4gV2hhdCBkbyB5b3UgdGhpbmsgYWJvdXQgdGVt
cG9yYXJpbHkgZGlzYWJsaW5nIGl0IGxpa2UgdGhpcz8NCj4gDQo+IC0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21hcnZlbGwvbXZwcDIvbXZwcDJfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21hcnZlbGwvbXZwcDIvbXZwcDJfbWFpbi5jDQo+IEBAIC01Nzc1LDcgKzU3NzUs
OCBAQCBzdGF0aWMgaW50IG12cHAyX3BvcnRfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZQ0K
PiAqcGRldiwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgIE5FVElGX0ZfSFdfVkxBTl9D
VEFHX0ZJTFRFUjsNCj4gDQo+ICAgICAgICAgaWYgKG12cHAyMl9yc3NfaXNfc3VwcG9ydGVkKCkp
IHsNCj4gLSAgICAgICAgICAgICAgIGRldi0+aHdfZmVhdHVyZXMgfD0gTkVUSUZfRl9SWEhBU0g7
DQo+ICsgICAgICAgICAgICAgICBpZiAocG9ydC0+cGh5X2ludGVyZmFjZSAhPSBQSFlfSU5URVJG
QUNFX01PREVfU0dNSUkpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGRldi0+aHdfZmVhdHVy
ZXMgfD0gTkVUSUZfRl9SWEhBU0g7DQo+ICAgICAgICAgICAgICAgICBkZXYtPmZlYXR1cmVzIHw9
IE5FVElGX0ZfTlRVUExFOw0KPiAgICAgICAgIH0NCj4gDQo+IA0KPiBEYXZpZCwgaXMgdGhpcyAi
d29ya2Fyb3VuZCIgdG9vIGJhZCB0byBnZXQgYWNjZXB0ZWQ/DQoNCk5vdCBzdXJlIHRoYXQgUlNT
IHJlbGF0ZWQgdG8gcGh5c2ljYWwgaW50ZXJmYWNlKFNHTUlJKSwgYmV0dGVyIGp1c3QgcmVtb3Zl
IE5FVElGX0ZfUlhIQVNIIGFzICJ3b3JrYXJvdW5kIi4NCg0KU3RlZmFuLg0K
