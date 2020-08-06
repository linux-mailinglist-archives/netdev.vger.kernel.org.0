Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52A523D578
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 04:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgHFC2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 22:28:47 -0400
Received: from esa12.fujitsucc.c3s2.iphmx.com ([216.71.156.125]:45239 "EHLO
        esa12.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726774AbgHFC2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 22:28:43 -0400
IronPort-SDR: yjWIbBnHdQUjPV5cAZ5BdF9x1/zEU99OPG69aUm/WW5KwYPhdVi+e8PeQVwLuDTp30HBr0zhU3
 wmmMa460PlMRgWbaUmm65PS07bLjM7T7o4DyTUXJ72nCH8xzEu7WkxvA+PyODtQSAlhJJfKCoP
 EKgol305AWyLTghGiSCRORPPIYzviYXkP/Bbu00yeVYyVEf5wtoLO1hgmTvOw8usTmQKXaCWWi
 kj3h82B+6OfFmjH4VRkX92Qv4Nct9z8NUtizH0fBKFm005ws3eX8EDfnUQy1Uzoa1ENE7+BXFb
 6PY=
X-IronPort-AV: E=McAfee;i="6000,8403,9704"; a="16492307"
X-IronPort-AV: E=Sophos;i="5.75,440,1589209200"; 
   d="scan'208";a="16492307"
Received: from mail-os2jpn01lp2055.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.55])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2020 11:28:38 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cf615qe4u80LTVu56qM8L3hM2YtHf0K+11pp4ei6rYukcHkNebPXX1EEL3CJrHSdgVCKoF37GiPzBUVMz2JAfb2IDJp3iknCQpMg+rSz9MPPxYx027i/bjcx2kaUA3vIoSkE6LM3gW3B5hyi34/+c9mvq2o2uJqUhrCmgVyUGCsayHBxW+EdDy9agvGw4eWOvDXO53nIC+g5dm3VtogFKEgsfaGTp7Zg6sapswNY/dQofAJMPaG7T1ZhHPrUCipvvjRlGFX28kCW7tsvi52gmL6s9DqgAXMZGdgYmfZfn7ND2h9FQSt3ADfHdIBzb8kXdqVKzGFg/En58GPQgbZNwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVd5VJdDGXUqACWUiTdMAxeiAG/xdFckJ5Uo5kNHAXY=;
 b=Ti8xuxHSNbeUhH/pKRbdrI4XhpLixZij0FJrZxqTUKWGfY22UEL31Y6V4zw14R6DcbQ38K46nzHmNpf0ui/fY2ItGIRpDNJpgOrHiob7QHX+oATSxgherOiq55uM1QXxxLxuQQyjo7ytmVU3PyNEDtfrSwy6yi7w8rU5stAxpn11yIGxoO6i9UD5zkEh9v3yJe/RU2XgLfMc5a1vM2IrAlrGLMywUVOubZAxfqfpGuBCHPSoIrBlQJBMflxsdwPmeBOfO7ijqoDOPPOmP8MkZFcctdOWNLWGsgzn2gY0R2UJT7BglYCFNmSDKDIKgA3Ahu0U8IksVZWAK7924u0z4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVd5VJdDGXUqACWUiTdMAxeiAG/xdFckJ5Uo5kNHAXY=;
 b=Wv22R8Crp9VepmXgy0O20frAYpOwmyojQVcCEGrahi67DXiNfJhK6IkTPkeCU2iWYICsV7RSTBS1k6EppMXPVQhex1LRNca0MjaS/Z2NLET/71R1cd6DJg2f7d8RzGN00o9f7GKDcX0O6Aj2onsN/+nJcvbfWLtyoivw7yNRUFk=
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com (2603:1096:604:5d::13)
 by OSBPR01MB3333.jpnprd01.prod.outlook.com (2603:1096:604:2e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Thu, 6 Aug
 2020 02:28:36 +0000
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::d4d3:eba6:7557:dab6]) by OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::d4d3:eba6:7557:dab6%5]) with mapi id 15.20.3239.022; Thu, 6 Aug 2020
 02:28:36 +0000
From:   "ashiduka@fujitsu.com" <ashiduka@fujitsu.com>
To:     'Sergei Shtylyov' <sergei.shtylyov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
Thread-Topic: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
Thread-Index: AQHWZliVF0gqbKeTM0q7YOFUctSlU6kiBTYAgAWoChA=
Date:   Thu, 6 Aug 2020 02:28:36 +0000
Message-ID: <OSAPR01MB384402DF70DE090C10BAB4F8DF480@OSAPR01MB3844.jpnprd01.prod.outlook.com>
References: <20200730035649.5940-1-ashiduka@fujitsu.com>
 <20200730100151.7490-1-ashiduka@fujitsu.com>
 <0e7d72fe-ea70-612c-7a50-ad1ff905ddf4@gmail.com>
In-Reply-To: <0e7d72fe-ea70-612c-7a50-ad1ff905ddf4@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: 1dd896f3a6b949f9acee9460a5234007
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [118.155.224.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da5ea92c-1174-4448-b677-08d839b06bf8
x-ms-traffictypediagnostic: OSBPR01MB3333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB33331CE343992CD71F36BE9EDF480@OSBPR01MB3333.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bD1FF6Ctk4Eb2WAUVXmmM8ogKOLQwWhCI9V1WwGAH1FTHyZR3zZnrO6ajlJM9QDB+pwmPu9EDGBt0Jy6eT0QRIVqDWKIw4tmTskJpXamP78/sTQgGoUMrUkMfTHL5kMbfTgX5TAG9pZmfWdFruB9IoE8lkQos/cJff2SOsFvz3r9RDPGcZ5nJ2FLAuO1l4NaTvTCIY2McxF6YfHMKp5GjfAWKRifXtQj5hwUK5Zl0OXhWHD/oNRZu8TVMt4P1WN3hjkfPB/jQk7dERTCcf7zn6jyNyDY/H9LyCJla8xRW9AnxcwG3f+bC2Ssfe6xKLfgsu6EctrofWiMXNelgipEeIRmF2pZoKijDRAMvhrrxFKmXfH58BE9mRPGEpSGW7bH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB3844.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(316002)(26005)(71200400001)(85182001)(4326008)(186003)(8936002)(33656002)(55016002)(52536014)(6506007)(2906002)(64756008)(86362001)(83380400001)(8676002)(66556008)(76116006)(6916009)(478600001)(7696005)(9686003)(54906003)(66476007)(66946007)(66446008)(5660300002)(777600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: aU0F39BOamjJJvcXTdMPnobyVtgwGjadsnB0VOxFJyT1LsqYvMyr7vYKel6ZnikSHM9avyGqqtj4cOfrbmk3LqB6vQDK83RikSPNOHhmxNgl9Z0Usw6+uqMQbc7R3rw5XRXRmkQKvT37UEdiLKxlGN4j8THO1znAZV1nAjmr54HUkYiNJS0dL+z0UCMJrJzfMKmeC+6OV1ElqavtYSdLkcV1hWipkuq1B+jHnUQ7eMeJCyHVjx7HUVFz8iIMVZO8U2/4QytGKfi7cRe1gSHmxTWULliHEOJPwrDBnqn3VXCZ2svHqUBOk0TQvKcu6OCwytMid8KrqIPxb6TI8CYoU02/0x/1KjYxWwGz8XPaYLDojqX1mY0TH8z8CvFN35+tTxM9U5HBr3hFH4l7Ay4EYg3VyLjIG0IbY39qUxvrTigUvrzXIilJu3G2WdsPqt3wMEjUPbbj8OF4sQSfM8C3nn7c6R+JVFl/O/eCCcuWS2tHI72D+QT/0gTeC6/82c8DaPeqjD0h9VyuUXNogbNL2L4eewIENxz5Q1uuE+I/m3SSf+PBSwr+/3N8y62zLpIsbZh3o2JN8KHVyLUSfSsrUg5bYL0kOVu0w1dSpCKm5pV1kl7RZEgXXDVxc/tDE1wvKbl8clJrMttMZ1vURklong==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB3844.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da5ea92c-1174-4448-b677-08d839b06bf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2020 02:28:36.1054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KVMEo7yUc4gFpuw9G0Zq9pj3wo8FuWF500dkJm7tWfT3U+Sel/4nIM8IFRfrI8Qpg6fowi30Gk2kyyxwImaXIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+ICAgIENDaW5nIERhdmVNIChhcyB5b3Ugc2hvdWxkIGhhdmUgZG9uZSBm
cm9tIHRoZSBzdGFydCkuLi4NCg0KVGhhbmsgeW91LiBJIGFwcHJlY2lhdGUgeW91ciBoZWxwLg0K
DQo+ICAgIERpZCB5b3UgYWxzbyBidWlsZCBtZGlvLWJpdGJhbmcuYyBhcyBhIG1vZHVsZT8NCg0K
WWVzLiBTdXJlLg0KDQo+IEZvciB0aGUgaW4ta2VybmFsIGRyaXZlciwgbm90IGJlaW5nIGFibGUg
dG8gcm1tb2QgdGhlICdyYXZiJyBvbmUgc291bmRzDQo+IGxvZ2ljYWwuIDotKQ0KDQpyb290QHJj
YXItZ2VuMzp+IyBsc21vZHxncmVwIHJhdmINCnJhdmIgICAgICAgICAgICAgICAgICAgNDA5NjAg
IDENCm1kaW9fYml0YmFuZyAgICAgICAgICAgMTYzODQgIDEgcmF2Yg0Kcm9vdEByY2FyLWdlbjM6
fiMgbW9kcHJvYmUgLXIgcmF2Yg0KbW9kcHJvYmU6IEZBVEFMOiBNb2R1bGUgcmF2YiBpcyBpbiB1
c2UuDQpyb290QHJjYXItZ2VuMzp+IyBtb2Rwcm9iZSAtciBtZGlvX2JpdGJhbmcNCm1vZHByb2Jl
OiBGQVRBTDogTW9kdWxlIG1kaW9fYml0YmFuZyBpcyBpbiB1c2UuDQoNCj4+IEZpeGVkIHRvIGV4
ZWN1dGUgbWRpb19pbml0KCkgYXQgb3BlbiBhbmQgZnJlZV9tZGlvKCkgYXQgY2xvc2UsIHRoZXJl
Ynkgcm1tb2QgaXMNCj4gICAgQ2FsbCByYXZiX21kaW9faW5pdCgpIGF0IG9wZW4gYW5kIGZyZWVf
bWRpb19iaXRiYW5nKCkgYXQgY2xvc2UuDQoNCk9LLiANCkluY2x1ZGUgdGhlIGV4YWN0IGZ1bmN0
aW9uIG5hbWUgaW4gdGhlIGNvbW1pdCBsb2csIG5vdCB0aGUgYWJicmV2aWF0ZWQgZnVuY3Rpb24g
bmFtZS4NCg0KPiAgIERhdmUsIHdvdWxkIHlvdSB0b2xlcmF0ZSB0aGUgZm9yd2FyZCBkZWNsYXJh
dGlvbnMgaGVyZSBpbnN0ZWFkICh0byBhdm9pZCB0aGUgZnVuY3Rpb24gbW92ZXMsIHRvIGJlIGxh
dGVyDQo+IGRvbmUgaW4gdGhlIG5ldC1uZXh0IHRyZWUpPw0KDQpXYWl0IGZvciBEYXZlJ3MgcmVw
bHkgZm9yIGEgd2hpbGUuDQooSWYgRGF2ZSdzIHJlcGx5IGlzIHNsb3csIEkgd2lsbCBvbmx5IGNv
cnJlY3QgU2VyZ2VpJ3MgaXNzdWUgYW5kIHBvc3QgaXQpDQoNClRoYW5rcyAmIEJlc3QgUmVnYXJk
cywNCll1dXN1a2UgQXNoaXp1a2EgPGFzaGlkdWthQGZ1aml0c3UuY29tPg0K
