Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C5319EF15
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 03:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgDFBZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 21:25:35 -0400
Received: from mail-eopbgr1300100.outbound.protection.outlook.com ([40.107.130.100]:58832
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbgDFBZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Apr 2020 21:25:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IydFnFJUpqp7t89DlPNXrChb0XngPT5ooOUYKAXBQ2jizNSukJgDGafQ0r9Pg+OAqnpdKhmuQiggbt9EIgcYcdUgH6UKspWeTYBzFCM+/Tuy3AKEVvZ8kBSiD9wnPETlpi5yWZBEF96RgGrHSxvPbsnG6vPmMCqWk43EChCM+6KGUjH4CVTXdNbaOcPmgfpg0mIMcxFB+TJHJxuwAKE5bFSyRJ+3Tr1vPsB4eSgSoq7a4OFXlELJZtszKt02CrNFwoXP2G9JOs9mr3HRXb3HF8T1G4iaa0PamUb4U1YU0nwIBn+hFCWOqyXJ8OoYHknkxhKnOaZ7XoYMKB5BnfR02A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dh1rqsC+0nitz316nIsHyE5viq//V+L/v3QZE7rGYsc=;
 b=UJ/kcSk1hmylpizL9cslyezYo9UHqreElSYPOa2gXhqHrrHv7tb4qjfrpfTBkSqM+l5PBzr5eO2mYoWxNKOL0k+zn++6msen5YmAVLSVAdnxkppobz/QyXoYxF4gWKsTM8HLoxNqA6C12pln6HB8YJBkI503QOSt7CDnvuHHJcm5Gxv7SZFPuvDKVTeyuEAqOKSenfD6BGxcjHUmSoqc5Pd3s75uuKvICNRriV1dz4YwBx7PecDWZP1+xPTc9wRVis52NW72RQydZmH2WbkNSI9lM9AjJGtABY208eloWx37iQnm+1nDd3A8pQsXteFYYcMDFEHQOsbvHzb8DYZUuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dh1rqsC+0nitz316nIsHyE5viq//V+L/v3QZE7rGYsc=;
 b=PbCo0CeuF7jK+ltmixPpsi7RpmxQ+Ms3pexJUVwR7u5DUHdlyxMFR7jZ3DEHNbR+yExDCCPbdrXYdnFHhubco4o8797Z1qWg2k9tkRXrswPbynBuho7pbiIvW38gC7j3a3GbMZb5b+WQMiR1NGUqC5WPCGROBguTc4KmdtsRl4A=
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM (52.132.236.76) by
 HK0P153MB0163.APCP153.PROD.OUTLOOK.COM (52.133.156.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.4; Mon, 6 Apr 2020 01:25:29 +0000
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a]) by HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a%2]) with mapi id 15.20.2921.000; Mon, 6 Apr 2020
 01:25:29 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemb@google.com" <willemb@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "sdf@google.com" <sdf@google.com>,
        "john.hurley@netronome.com" <john.hurley@netronome.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "fw@strlen.de" <fw@strlen.de>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "jeremy@azazel.net" <jeremy@azazel.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] skbuff.h: Improve the checksum related comments
Thread-Topic: [PATCH net] skbuff.h: Improve the checksum related comments
Thread-Index: AQHWCzYPXZ/PsAZ8AU+mHH+wagcwgqhqsF3ggAALTQCAAJGscA==
Date:   Mon, 6 Apr 2020 01:25:29 +0000
Message-ID: <HK0P153MB027337B6ABF4891AC49091E6BFC20@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
References: <1586071063-51656-1-git-send-email-decui@microsoft.com>
 <20200405103618.GV21484@bombadil.infradead.org>
 <HK0P153MB027363A6F5A5AACC366B11A3BFC50@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
 <7a0df207-8ad3-3731-c372-146a19befc02@infradead.org>
In-Reply-To: <7a0df207-8ad3-3731-c372-146a19befc02@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-06T01:25:26.5916755Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=44442bf7-547f-40e3-9b10-2eeee719a8ad;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:ac71:2d80:3165:3247]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 95efa1a1-d88a-4fbe-f704-08d7d9c964cf
x-ms-traffictypediagnostic: HK0P153MB0163:
x-microsoft-antispam-prvs: <HK0P153MB0163A25DE8A711A58BC811AABFC20@HK0P153MB0163.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0365C0E14B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0273.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(8936002)(8676002)(81156014)(81166006)(316002)(478600001)(7696005)(186003)(54906003)(4744005)(5660300002)(86362001)(76116006)(7416002)(82950400001)(82960400001)(8990500004)(53546011)(64756008)(66556008)(66446008)(66946007)(6506007)(66476007)(33656002)(52536014)(10290500003)(9686003)(4326008)(71200400001)(55016002)(2906002)(110136005);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2ZlG5p0ZX7MC07oclyqKE91mIpA1dIPnr5ENSGPbHgAJwghpvmKhs9qf7C0C7vw2ycNugTRWvWCqQbdYOaOq+Yz74/0IRq7vaWZiCB+rK2BU1RFABH4Y2SLFFR6Oe0u8+tEXyHuc9xgdJDe4pCLrgYXLNc+Prfe3lwQ9179Ht3QC/4YpcDIUumMMyd5JuzFJdX3ul5qnFrtOXTVCOjuEeRUh2OMSZoptN2cjAnSJugq6S+ozXIOTpU/n4hl4h/DiT7631M1W+tztksT+9oscxpf2AVFQ9ALr3ed1At0FQyzZdTcgAS4Bmr74AMJ8Hhzs5UY+kzXv76nxxvhoe0e11Jr82rryNyf+7cFG1Gn+Gm1dSp81e84pxwMm+P6V2iN7pXVJYBOrEcDu3Y6Eh5JCpUyNFoGpgxNTdypvLumdSya/pgkLmgihJGo280kA9fD0
x-ms-exchange-antispam-messagedata: 56cduMsIOyVZF5q3RL0QHGJg3GejZajtHvS+I0Ed18DQ2uaUGGg0Zvh5DvRdrKgMDa0bnhocJNcITQpOxBB4FOr9kKw02cZoCz24lDnwJgu4vftpf1lAFds916UgM9WsBMlsfeGxBwXl5oGYIbNXHsmhwdP9o0Ld9vtoaQdj0o7/eIhjpTkYqXDxw3H+/XneNhT4wMfVtEha3zQ4WC46eA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95efa1a1-d88a-4fbe-f704-08d7d9c964cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2020 01:25:29.5181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9b2mmwIe45kBnvGqPKgYspttZE/STaB7U0GfWlPnTrOUyqsQhAHChq88MNDArkPP/TZAEBWPiPQZ+Yfgv3YSjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBSYW5keSBEdW5sYXAgPHJkdW5sYXBAaW5mcmFkZWFkLm9yZz4NCj4gU2VudDogU3Vu
ZGF5LCBBcHJpbCA1LCAyMDIwIDk6NDEgQU0NCj4gVG86IERleHVhbiBDdWkgPGRlY3VpQG1pY3Jv
c29mdC5jb20+OyBNYXR0aGV3IFdpbGNveA0KPiA+PiBXaHkgdGhlIGNhcGl0YWxpc2F0aW9uIG9m
ICdBTkQnPw0KPiA+IC4uLg0KPiA+IFRoZSBjb21tYSBhZnRlciB0aGUgIkNIRUNLU1VNX1BBUlRJ
QUwiIHNlZW1zIHN1c3BpY2lvdXMgdG8gbWUuIEkgZmVlbA0KPiA+IHdlIHNob3VsZCBhZGQgYW4g
ImFuZCIgYWZ0ZXIgdGhlIGNvbW1hLCBvciByZXBsYWNlIHRoZSBjb21tYSB3aXRoICJhbmQiLA0K
PiA+IGJ1dCBlaXRoZXIgd2F5IHdlJ2xsIGhhdmUgIi4uLiBhbmQgY3N1bV9zdGFydCBhbmQgY3N1
bV9vZmZzZXQuLi4iLCB3aGljaCANCj4gPiBzZWVtcyBhIGxpdHRsZSB1bm5hdHVyYWwgdG8gbWUg
c2luY2Ugd2UgaGF2ZSAyICdhbmQncyBoZXJlLi4uIFNvIEkgdHJpZWQgdG8gDQo+ID4gbWFrZSBp
dCBhIGxpdHRsZSBuYXR1cmFsIGJ5IHJlcGxhY2luZyB0aGUgZmlyc3QgJ2FuZCcgd2l0aCAnQU5E
Jywgd2hpY2ggDQo+ID4gb2J2aW91c2x5IGNhdXNlcyBjb25mdXNpb24gdG8geW91Lg0KPiANCj4g
bWF5YmUgImJvdGggY3N1bV9zdGFydCBhbmQgY3N1bV9vZmZzZXQgYXJlIHNldCB0byByZWZlciB0
byIuDQo+IH5SYW5keQ0KDQpMb29rcyBnb29kLiBJJ2xsIHBvc3QgYSB2MiBzaG9ydGx5LiBUaGFu
ayB5b3UgYm90aCENCg0KVGhhbmtzLA0KLS0gRGV4dWFuDQo=
