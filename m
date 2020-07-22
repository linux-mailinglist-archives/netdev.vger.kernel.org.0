Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2352290D5
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgGVGaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:30:46 -0400
Received: from mail-eopbgr80052.outbound.protection.outlook.com ([40.107.8.52]:54007
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728497AbgGVGap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 02:30:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sV1qk1Je6xBlinmvX1c8FFMiJstMwdqT7DR+4kHDv9s=;
 b=vTKQVACFYdxgVcJ/p8MM0eoSBRQidLiuV39CKh0JEnwU8/jbTEwpA5J4lUDr5knfJ99hI2P5JgxBf6Q0rSOCAC7RfbB8Cc8g7NpTP6YdME/ohwVoQUDEp6CDGOrACVG9LBLoAqZ3KSy9xVPMyTRjyL+KyLCA8AX4Bj1/HKwoUaY=
Received: from MR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:1::14) by
 AM5PR0801MB1891.eurprd08.prod.outlook.com (2603:10a6:203:4a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Wed, 22 Jul
 2020 06:30:42 +0000
Received: from VE1EUR03FT017.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:1:cafe::9d) by MR2P264CA0002.outlook.office365.com
 (2603:10a6:500:1::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend
 Transport; Wed, 22 Jul 2020 06:30:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT017.mail.protection.outlook.com (10.152.18.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.10 via Frontend Transport; Wed, 22 Jul 2020 06:30:41 +0000
Received: ("Tessian outbound 73b502bf693a:v62"); Wed, 22 Jul 2020 06:30:41 +0000
X-CR-MTA-TID: 64aa7808
Received: from 06a194621d9e.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E6362C60-BDE1-49F9-BA85-3298F852BEE8.1;
        Wed, 22 Jul 2020 06:30:36 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 06a194621d9e.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 22 Jul 2020 06:30:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFVk56PB1L5mBsvWJeBF1bZKdb9iuQU1/uS5/LyGVYljo/JVaNAI5ggwmscCiJA/ANbuydR72bFVAwddubCrKmTa6DkYF/SaFnwzxej0ztXEL9Y2UrEitj+GuIoI6y1QiWKC6BsGv4UCqofp3hsbRWTlhZxLx6SZUyundverI+8Yi8/4Otq8b8xLrAmahy6mNcuTLoClhnk5v4mG4rfWWkdRVfLxhlVP3Fh/QJKCj81kkwQgknK8mITPgbv0fLB0h3DQoe34uE/v+L18LE1Hn0C+vAJ9kICes5NVo17KMpJcwYrqba0iRVbfK29bFRJDRbBN5yvmlkG8CqMXcYrLcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sV1qk1Je6xBlinmvX1c8FFMiJstMwdqT7DR+4kHDv9s=;
 b=A9rkmsi5dzDwPeDL1OJf5NQIE6t6MuEDz+/gDAyz6OHdYS6eip8vqsgrfpsro6/1CBSozaEhJ6pPC7RV4KPU5V3HadCIGOLkqcizQlRndYCVAznsj+SGPmLAqvtUnwupK1cLTInx1jiirQfq61Yp1TdxlZLO0jCZySLz0ni4rh1bAoW0j9/JlJoKFL+prsRwpogYb1kf0/f3a0hHmlCiSPmgS1ZOKB87K0p6edFLCJbTMiOg2RzmPMuf7B6HLzrh8oXr3ijnSg0RsMong4yZjXwsIpNsjf8OJMEzyHPge+MCUdsfaxf/bmvRK5q1TMIjTSZXu8VutvRcRrhodd3dug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sV1qk1Je6xBlinmvX1c8FFMiJstMwdqT7DR+4kHDv9s=;
 b=vTKQVACFYdxgVcJ/p8MM0eoSBRQidLiuV39CKh0JEnwU8/jbTEwpA5J4lUDr5knfJ99hI2P5JgxBf6Q0rSOCAC7RfbB8Cc8g7NpTP6YdME/ohwVoQUDEp6CDGOrACVG9LBLoAqZ3KSy9xVPMyTRjyL+KyLCA8AX4Bj1/HKwoUaY=
Received: from AM6PR08MB3589.eurprd08.prod.outlook.com (2603:10a6:20b:46::17)
 by AM6PR08MB3255.eurprd08.prod.outlook.com (2603:10a6:209:43::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Wed, 22 Jul
 2020 06:30:32 +0000
Received: from AM6PR08MB3589.eurprd08.prod.outlook.com
 ([fe80::591a:d1ee:1e4:fb62]) by AM6PR08MB3589.eurprd08.prod.outlook.com
 ([fe80::591a:d1ee:1e4:fb62%3]) with mapi id 15.20.3216.020; Wed, 22 Jul 2020
 06:30:32 +0000
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        Song Zhu <Song.Zhu@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH bpf-next] bpf: Generate cookie for new non-initial net NS
Thread-Topic: [PATCH bpf-next] bpf: Generate cookie for new non-initial net NS
Thread-Index: AQHWXp+PqTUYBcJeokGqnFnohyvg1KkSes0AgACqVLA=
Date:   Wed, 22 Jul 2020 06:30:32 +0000
Message-ID: <AM6PR08MB3589E63AE14327C2544D6C2598790@AM6PR08MB3589.eurprd08.prod.outlook.com>
References: <20200720140919.22342-1-Jianlin.Lv@arm.com>
 <840a9007-3dcb-457f-8746-7f8e6fa209c5@iogearbox.net>
In-Reply-To: <840a9007-3dcb-457f-8746-7f8e6fa209c5@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 5695dcc7-b2d5-4c0b-8d2c-bf7dba86b1ae.1
x-checkrecipientchecked: true
Authentication-Results-Original: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: adc8e2af-3911-4f7c-b12f-08d82e08c1af
x-ms-traffictypediagnostic: AM6PR08MB3255:|AM5PR0801MB1891:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0801MB1891491829A4721BB47BC48198790@AM5PR0801MB1891.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: TN+hFgCcIMs2TKpEMseToPliIdFiE/BXuZOchkHV6QhqiIznaQwRA+87VdIdgPyfWZWxPKQpc2rA+Mvm/nlZILvs0tdtt6dnPTKhRxCIsWg1PPUEC1lSbpL6FtqNSpahhBHQddHGMUDe0KRd6iWJoY1GrmDWov6uaNUiH9WEOSmNG550MNFks2ueJmxj4loULg3vfSI6cre7Uf2vkr/ZcazPD79A9pUWU9YcFtTDGB77nbR050K3ui3SFHIFkDS2RXamIye6gDGeqTKitsqoLaaSDkx2kEFwFuv+Dho8eEPAZgSdvA/v/1YYyOMDIHKu3OxUvCAYjG7R+eMBpLdCXw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3589.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(39850400004)(136003)(396003)(478600001)(52536014)(71200400001)(9686003)(8676002)(55016002)(4326008)(5660300002)(8936002)(7696005)(54906003)(110136005)(316002)(2906002)(76116006)(64756008)(66446008)(66946007)(66476007)(66556008)(33656002)(53546011)(83380400001)(26005)(186003)(86362001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ps6ADCrVLy3e7XbuhijUEfl06RRWPhQQVRyKb/O2vsgWoffzM5xnPYUr4VQHgjxAleFVz4X8BH5VWcTDhY0RySawixDfRQ+bqULZ8F36nH+EJaLbWk7ag0Q2tyWa+N+Q4Nv1gWL8XlZdJ7Li6wQS159T/NTmn+jzc4asXLHIJOHl8BQnMSIrA1H9xEydomJ+b29OuWD03hUu0rI7zEay30BXMdYcWMMVCgdUIjt99njqW7KX69Y/wxnPRgOVGP+FE/9wD9LothgZN4JSPxn1oE7BHG8qGeX5aLKVh3J/ht7MJZbrPKQbRnxyS/qglrQPgPztgP68zaTpg/jO8/CGji2g26TF9KlFS7ATE4H7skWiVdLRPtbDqWFHEC6Jt6vqhKFlSpfv5T/cVVwa8EM0BckRVgxI1G2XvcNNHCGflQDLu3DJjAaHHGN+Q5sxXOWovj5vZNjvRrNYj588dhsvFVNTuEaN8jf07fKfoh35OE4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3255
Original-Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT017.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(46966005)(70206006)(70586007)(26005)(47076004)(316002)(54906003)(52536014)(83380400001)(9686003)(86362001)(110136005)(478600001)(55016002)(7696005)(336012)(6506007)(5660300002)(2906002)(82310400002)(4326008)(356005)(36906005)(81166007)(8676002)(82740400003)(33656002)(186003)(450100002)(8936002)(53546011);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: ba10ab8f-fab2-44e5-129c-08d82e08bc2a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3Y2uyvg1YhG6NfLItDtgjVB6349tdgxwgeptsfwQ7beUewJ0vxTTPCuGVcPRNbYDHN2msokJThkcdnZ+lDrpEJBN5uGA8xTTPph1xN/ZEeihN0Z+3qr/fbs5y2CRmn0Jdy8Pr6RDy6QJO0SuMC+2PkrtUKSoKw1gw5h3n+u9atQGlmBPPZWLXP1QrGicYlZpuzg3COO9DpktdpCafwFHbW0AYMx1jXun7kqSDXE4zm+3g0No4I0pWSLM/5m8GoRsSK9H5CAXkVf3B8DkGFNwNVcPe2/1CXYU6kH00fsBQsjYOXJyaUtpI+GzY7Z8Cl+JI/3ezDsHImAeJgopKExWfex002t4osDbCCohHSGO+Yov/ql8jhPRAX/m38CN90f5WjTyjYQ4ATzIcGaR6FN/w==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 06:30:41.4779
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adc8e2af-3911-4f7c-b12f-08d82e08c1af
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT017.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1891
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogYnBmLW93bmVyQHZnZXIu
a2VybmVsLm9yZyA8YnBmLW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24gQmVoYWxmDQo+IE9mIERh
bmllbCBCb3JrbWFubg0KPiBTZW50OiBXZWRuZXNkYXksIEp1bHkgMjIsIDIwMjAgNDoxOCBBTQ0K
PiBUbzogSmlhbmxpbiBMdiA8Smlhbmxpbi5MdkBhcm0uY29tPjsgYnBmQHZnZXIua2VybmVsLm9y
Zw0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBhc3RAa2VybmVs
Lm9yZzsgeWhzQGZiLmNvbTsNCj4gU29uZyBaaHUgPFNvbmcuWmh1QGFybS5jb20+OyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggYnBmLW5leHRdIGJwZjogR2VuZXJhdGUgY29va2llIGZvciBuZXcgbm9u
LWluaXRpYWwgbmV0IE5TDQo+DQo+IE9uIDcvMjAvMjAgNDowOSBQTSwgSmlhbmxpbiBMdiB3cm90
ZToNCj4gPiBGb3Igbm9uLWluaXRpYWwgbmV0d29yayBOUywgdGhlIG5ldCBjb29raWUgaXMgZ2Vu
ZXJhdGVkIHdoZW4NCj4gPiBicGZfZ2V0X25ldG5zX2Nvb2tpZV9zb2NrIGlzIGNhbGxlZCBmb3Ig
dGhlIGZpcnN0IHRpbWUsIGJ1dCBpdCBpcyBtb3JlDQo+ID4gcmVhc29uYWJsZSB0byBjb21wbGV0
ZSB0aGUgY29va2llIGdlbmVyYXRpb24gd29yayB3aGVuIGNyZWF0aW5nIGEgbmV3DQo+ID4gbmV0
d29yayBOUywganVzdCBsaWtlIGluaXRfbmV0Lg0KPiA+IG5ldF9nZW5fY29va2llKCkgYmUgbW92
ZWQgaW50byBzZXR1cF9uZXQoKSB0aGF0IGl0IGNhbiBzZXJ2ZSB0aGUNCj4gPiBpbml0aWFsIGFu
ZCBub24taW5pdGlhbCBuZXR3b3JrIG5hbWVzcGFjZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IEppYW5saW4gTHYgPEppYW5saW4uTHZAYXJtLmNvbT4NCj4NCj4gV2hhdCB1c2UtY2FzZSBhcmUg
eW91IHRyeWluZyB0byBzb2x2ZT8gV2h5IHNob3VsZCBpdCBiZSBkaWZmZXJlbnQgdGhhbiwgc2F5
LA0KPiBzb2NrZXQgY29va2llIGdlbmVyYXRpb24/IEknbSBjdXJyZW50bHkgbm90IHNlZWluZyBt
dWNoIG9mIGEgcG9pbnQgaW4gbW92aW5nDQo+IHRoaXMuIFdoZW4gaXQncyBub3QgdXNlZCBpbiB0
aGUgc3lzdGVtLCBpdCB3b3VsZCBhY3R1YWxseSBjcmVhdGUgbW9yZSB3b3JrLg0KDQpUaGlzIHBh
dGNoIGRvZXMgbm90IGNvbWUgZnJvbSB1c2UtY2FzZSwgYnV0IGJhc2VkIG9uIHRoZSBmb2xsb3dp
bmcgcG9pbnRzIHdlcmUgY29uc2lkZXJlZDoNCjEuIHNldHVwX25ldCgpIHJ1bnMgdGhlIGluaXRp
YWxpemVycyBmb3IgdGhlIG5ldHdvcmsgbmFtZXNwYWNlIG9iamVjdCwgbmV0X2Nvb2tpZSBpcyBh
IG1lbWJlciBvZiBzdHJ1Y3QgbmV0LCBhbmQgaXRzIGluaXRpYWxpemF0aW9uIGlzIG1vcmUgcmVh
c29uYWJsZSBpbiBzZXR1cF9uZXQoKTsNCjIuIEZvciBpbml0aWFsIG5ldHdvcmsgbmFtZXNwYWNl
cywgdGhpcyBwYXRjaCBkb2VzIG5vdCBpbnRyb2R1Y2UgYWRkaXRpb25hbCBidXJkZW47DQozLiBG
b3Igc3lzdGVtcyB0aGF0IGhhdmUgbm90IGNyZWF0ZWQgbm9uLWluaXRpYWwgbmV0d29yayBuYW1l
c3BhY2VzLCB0aGlzIHdpbGwgbm90IGludHJvZHVjZSBhZGRpdGlvbmFsIHdvcms7DQo0LiBGb3Ig
bmV3bHkgY3JlYXRlZCBub24taW5pdGlhbCBuZXR3b3JrIG5hbWVzcGFjZXMsIHRoZSBhZGRlZCBl
ZmZvcnQgb2YgbmV0X2dlbl9jb29raWUoKSBpcyB3ZWFrIGZvciB0aGUgZW50aXJlIG5ldHdvcmsg
bmFtZXNwYWNlcyBjcmVhdGlvbiBwcm9jZXNzLCBhbmQgbmV0X2Nvb2tpZSBpcyBvbmx5IHdyaXR0
ZW4gb25jZSBkdXJpbmcgdGhlIGVudGlyZSBsaWZlIGN5Y2xlIG9mIG5ldHdvcmsgbmFtZXNwYWNl
cy4NCg0KPg0KPiA+IC0tLQ0KPiA+ICAgbmV0L2NvcmUvbmV0X25hbWVzcGFjZS5jIHwgMiArLQ0K
PiA+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvbmV0X25hbWVzcGFjZS5jIGIvbmV0L2NvcmUvbmV0
X25hbWVzcGFjZS5jIGluZGV4DQo+ID4gZGNkNjFhY2EzNDNlLi41OTM3YmQwZGY1NmQgMTAwNjQ0
DQo+ID4gLS0tIGEvbmV0L2NvcmUvbmV0X25hbWVzcGFjZS5jDQo+ID4gKysrIGIvbmV0L2NvcmUv
bmV0X25hbWVzcGFjZS5jDQo+ID4gQEAgLTMzNiw2ICszMzYsNyBAQCBzdGF0aWMgX19uZXRfaW5p
dCBpbnQgc2V0dXBfbmV0KHN0cnVjdCBuZXQgKm5ldCwNCj4gc3RydWN0IHVzZXJfbmFtZXNwYWNl
ICp1c2VyX25zKQ0KPiA+ICAgaWRyX2luaXQoJm5ldC0+bmV0bnNfaWRzKTsNCj4gPiAgIHNwaW5f
bG9ja19pbml0KCZuZXQtPm5zaWRfbG9jayk7DQo+ID4gICBtdXRleF9pbml0KCZuZXQtPmlwdjQu
cmFfbXV0ZXgpOw0KPiA+ICtuZXRfZ2VuX2Nvb2tpZShuZXQpOw0KPiA+DQo+ID4gICBsaXN0X2Zv
cl9lYWNoX2VudHJ5KG9wcywgJnBlcm5ldF9saXN0LCBsaXN0KSB7DQo+ID4gICBlcnJvciA9IG9w
c19pbml0KG9wcywgbmV0KTsNCj4gPiBAQCAtMTEwMSw3ICsxMTAyLDYgQEAgc3RhdGljIGludCBf
X2luaXQgbmV0X25zX2luaXQodm9pZCkNCj4gPiAgIHBhbmljKCJDb3VsZCBub3QgYWxsb2NhdGUg
Z2VuZXJpYyBuZXRucyIpOw0KPiA+DQo+ID4gICByY3VfYXNzaWduX3BvaW50ZXIoaW5pdF9uZXQu
Z2VuLCBuZyk7DQo+ID4gLW5ldF9nZW5fY29va2llKCZpbml0X25ldCk7DQo+ID4NCj4gPiAgIGRv
d25fd3JpdGUoJnBlcm5ldF9vcHNfcndzZW0pOw0KPiA+ICAgaWYgKHNldHVwX25ldCgmaW5pdF9u
ZXQsICZpbml0X3VzZXJfbnMpKQ0KPiA+DQoNCklNUE9SVEFOVCBOT1RJQ0U6IFRoZSBjb250ZW50
cyBvZiB0aGlzIGVtYWlsIGFuZCBhbnkgYXR0YWNobWVudHMgYXJlIGNvbmZpZGVudGlhbCBhbmQg
bWF5IGFsc28gYmUgcHJpdmlsZWdlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lw
aWVudCwgcGxlYXNlIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5IGFuZCBkbyBub3QgZGlz
Y2xvc2UgdGhlIGNvbnRlbnRzIHRvIGFueSBvdGhlciBwZXJzb24sIHVzZSBpdCBmb3IgYW55IHB1
cnBvc2UsIG9yIHN0b3JlIG9yIGNvcHkgdGhlIGluZm9ybWF0aW9uIGluIGFueSBtZWRpdW0uIFRo
YW5rIHlvdS4NCg==
