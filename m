Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03081BF4E5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgD3KGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:06:41 -0400
Received: from mail-am6eur05on2060.outbound.protection.outlook.com ([40.107.22.60]:16910
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726127AbgD3KGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 06:06:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/15wCriyDx23lNAOS34WhqkcI8MEfBFw68ouxLtTT8=;
 b=q99+PjqIJiuyqpBC709MmibQ/TPdS2HOJiLZZNPTXqMxzKrSJFhoCyCtyDMA5tIdq6+D3qyCdGlS9DrbfuWl7Jz4HJ4pIwFKVjx8PkpOyPhLXaet89Bj00ATwRDWdN47XWsEyV6H7I901thQZPDcf6GUTM6+TL+HOSnRiSHgJc8=
Received: from AM6P193CA0132.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::37)
 by DB6PR0802MB2135.eurprd08.prod.outlook.com (2603:10a6:4:82::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 10:06:34 +0000
Received: from AM5EUR03FT056.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:85:cafe::ac) by AM6P193CA0132.outlook.office365.com
 (2603:10a6:209:85::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend
 Transport; Thu, 30 Apr 2020 10:06:34 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT056.mail.protection.outlook.com (10.152.17.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 10:06:33 +0000
Received: ("Tessian outbound b3a67fbfbb1f:v54"); Thu, 30 Apr 2020 10:06:33 +0000
X-CR-MTA-TID: 64aa7808
Received: from 7cc604ee4a14.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 9D41387B-895C-4219-8F57-32E11EC2E7F3.1;
        Thu, 30 Apr 2020 10:06:28 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 7cc604ee4a14.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 30 Apr 2020 10:06:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZB6CT/V0LarB1rYSA6bm2JtmMPlVkxpCMnkXOGLbQf2sqeYdKi3jqWTfHJRofuOTReFk7wHg3aCDhE2UjrvqAwFgykypsYgpA9oKtwFROd/IKR7Y7S+i/xY/MjQhy8YLsYeadorFPcLr5pSXuRIRTgtvR3aFmOeE4YhUxdGMv8Axul7uf3C3wgzNCtYP+E8a5mH6bjA8ZS/I0X9q2t/xga0Ehpx9nGM4ysGlmGt19EFOhuwU3oOUqdZKG+3Bnm8ytabbyUl7H8qDmzRrWFLhwP0joFgcEfrjg4GtJ+r7nWlAkOpdq909cMiK6x8/FWT+EI8rKeqFi+LUZExI+TJRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/15wCriyDx23lNAOS34WhqkcI8MEfBFw68ouxLtTT8=;
 b=fcL1buVZfoky+gBxGhLj2XkoAQAMKQFY2bzGjO1tq7tMxDiz6i+8CKFvxAbP5Hv1uQ5ETa6/jfmfQIv66JYvZ7fppLhd/E19Gi78Cz2LNoZIUbf07Qdha+I0eu1Bo5u/JWmPQXR/Lc8t+6B1MUKd89A6AFT8Hrt18yQ7Z0Q8Zp74EEQ5YNLY9NCFcbPLq4vFamO07ilZ02ErFlhEXd68zrJ9W454yV/Ugf0o5MFAhC9VQH/ZHiv6PH8DD4peg5Djt5X5Z5hPUH7hRfqlzHtgVlUSZbtTD3ahepOoEnL9qIsioO9JCtQCEA0ItefPDIDir19aY80k7uqocBK7/Rz/xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/15wCriyDx23lNAOS34WhqkcI8MEfBFw68ouxLtTT8=;
 b=q99+PjqIJiuyqpBC709MmibQ/TPdS2HOJiLZZNPTXqMxzKrSJFhoCyCtyDMA5tIdq6+D3qyCdGlS9DrbfuWl7Jz4HJ4pIwFKVjx8PkpOyPhLXaet89Bj00ATwRDWdN47XWsEyV6H7I901thQZPDcf6GUTM6+TL+HOSnRiSHgJc8=
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com (2603:10a6:20b:af::32)
 by AM6PR08MB3047.eurprd08.prod.outlook.com (2603:10a6:209:4c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 10:06:27 +0000
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::60b6:c319:1c9b:8919]) by AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::60b6:c319:1c9b:8919%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 10:06:27 +0000
From:   Justin He <Justin.He@arm.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kaly Xin <Kaly.Xin@arm.com>
Subject: RE: [PATCH] vhost: vsock: don't send pkt when vq is not started
Thread-Topic: [PATCH] vhost: vsock: don't send pkt when vq is not started
Thread-Index: AQHWHpT4qCgDaysQ6EO3lKGynDU9vaiRVNQAgAAaECA=
Date:   Thu, 30 Apr 2020 10:06:26 +0000
Message-ID: <AM6PR08MB4069D4AB611B8C8180DC4B9CF7AA0@AM6PR08MB4069.eurprd08.prod.outlook.com>
References: <20200430021314.6425-1-justin.he@arm.com>
 <20200430082608.wbtqgglmtnd7e5ci@steredhat>
In-Reply-To: <20200430082608.wbtqgglmtnd7e5ci@steredhat>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 5af177db-94c9-4b46-951c-6e3f2e5830b2.0
x-checkrecipientchecked: true
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7d625f2a-5ff1-4ab5-7302-08d7ecee296b
x-ms-traffictypediagnostic: AM6PR08MB3047:|AM6PR08MB3047:|DB6PR0802MB2135:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB21356F9639E9E49512FC7A52F7AA0@DB6PR0802MB2135.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:10000;
x-forefront-prvs: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: St2YLJbXJuauOksUwWQHnVG/WtLNlm4K/68Ygll5KSl8Zhq4RPDcPqng0VvjCJTt6BvvUhPDuBUhm94nKyvksB7EbtLQ0kV1udNmya6yPJbSA62wW3WEc8zp87Z2bs8CgV6yy72AmxUkXQf/sis7O979y2I+tPxaR0ukHeLmsldzkSZlhFsbXmMCKw1tCTrtQeJMlQ+B25+qSdi8ogDjpp8WU8+SNYmOyHMlqcR7nYJ0jmFvdEq4GLNEQ8sk99wKjJsTTrKXeoTn51hKGs3o1YAQYngMaEoTCQb2ddOTd+DDiwKSJqoV40Y/zkNygfX+ce/3ypbaO52uyW62kyqeMKgfzqzaL06+AMETaFvRdlnf/WpxgJrKqeMONEzlzAcpvlZr0ueFa5XkKK4/REJKkvojjBkb8SWPxrajliUWCe0+44HlDNtzT0+IKbo34TKFQM23NbFXJ4jIwWUlThZk95DwjpsfeGugYe+llVbKoq9RDFrNRZfrgFxqBPvRLcqBkG3ARF5POVxQHRArCqjJSA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4069.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(54906003)(2906002)(316002)(7696005)(8676002)(8936002)(52536014)(64756008)(5660300002)(66446008)(76116006)(66476007)(66556008)(66946007)(9686003)(55016002)(4326008)(86362001)(71200400001)(478600001)(55236004)(53546011)(33656002)(6916009)(6506007)(966005)(186003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RfrF58a5/w+TRK7gCMEjMGpOYoRf2SwqF2k0DFZZ6Vy39ohjXNBpcR7EZFYZ9UUpYYh9pWJ9aoo0VcEWtZ2f/o9bLbVAiOfAYInwoP9e2IQ/K5DLTR0YSILwFrOaSqUtAwMQwpvFWpEabsyrqn5irEUEG4CBTZRXR0wdCq1kpj26Vq4r/nxl6RXxkJ0XF+cPyD4WK5yTFOusAXdxoxie0oBiDY67tGQ2CFRq4m5VApQsYGDiLO97bSDESXl67rQLtSfYoxN5QGG6CAfHTchLC171hgFMLYeDhDzGo56skvgb33P1pMZG1jixp7kb+ZwGexqj652VUfFfw4GgEgTSSrwAB3ureBX7P70z1nKwohHpiZ9Mi0eBG0Ac+g2P3z9SRsIzuu/VMxfkdDyO9TXPgiZHdFHO2i575FmFF9FC0B8rPnEDR3/6PyG0Pi7Er0emmclvR2ropCrcW97lON5ZjdX7eFBkRkP4NRXkOpSBGt4btb7y4qG0Z92ntrf9i2nhLm9OIiEcm0U4nHnntVA/If+yakLIDv/jTvNXTc58VsSz7jDmxvh0FM0Ot+3ShupOFs0AkOyp49DbYbcDiNrAky9ghfwcGHkN2jO194j+LDiX9J0DPBZarz3PUa7fQr/8wFSFB9q9VMxCtz7J47yQvHgHIYAr9aSg/0GLnF7LZ4aty6FPLnTSwKJtzZ2B3VVEncA4ujyMJhIIN7iKiaKpIkdVCAWrKAhLfbVP9+4DuPjZwZjDAzRXKn0JK+q2KP6Ox5aFxngoi5Mv3VYMF7ZR1WOScn6lBM0FxTpCow+DkQ4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3047
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT056.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(46966005)(4326008)(5660300002)(54906003)(316002)(36906005)(86362001)(7696005)(33656002)(8676002)(6862004)(70206006)(9686003)(478600001)(55016002)(70586007)(966005)(8936002)(6506007)(53546011)(186003)(336012)(26005)(450100002)(52536014)(356005)(2906002)(81166007)(82310400002)(82740400003)(47076004);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 321c4d21-c010-4316-29d9-08d7ecee2572
X-Forefront-PRVS: 0389EDA07F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZC0LjFFJmYi+QBCgfr9cuecIu19HMhWJ8q2Fpof0og9iRFIY7OjqhKeZtfum0hxr/IjqhdGRULbIB9Hm3idQ2sqzzIjobBWuzUlyj/KFMvrKnFZ3n0iuFKSRRf/yEN5i5KPtumwv7TJgGlSSF9OjOSuejiIyLQs8T89ic1jybzBhbK3sMi2GWzlvChLx582MaCjqZs0Dca9Z1KGo2Q1Xv0QYrgZHq75kTcKJN2O+WVrOc605naJ8W4zZryM7X7TYO6D17/UMD9xWlj/Y1HGVPOCud5djKbOL7/17BVHnk8uddhpDubPFNc3KtR36wIHd172tP6GO0qaS8uoPAm8BgZExwXWJw7MiE7uOTrds0kjgjEhLDHY3ufarjnUaoSiCaW+k4PXO9vwuc/rmGkid1EOn0vHSm+emRwAgQaM/C0GOJerd3U5TVYRoTRh9roUWcX45iXwA/iPi51PdwAnVuoyHoyEWgGkJJTN31Z1G+yYjXa6Ns2ncsd5/cuq3iFuWp8zlI4KF7A2zjhfyCtmvgdjzuKVMVC0EMIle/bD8kaB4SmLZkZnXlDaWgn3mOpbrLRFEoXP4aSvrpJWjjuzAGw==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 10:06:33.6444
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d625f2a-5ff1-4ab5-7302-08d7ecee296b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RlZmFubw0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFN0ZWZh
bm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEFw
cmlsIDMwLCAyMDIwIDQ6MjYgUE0NCj4gVG86IEp1c3RpbiBIZSA8SnVzdGluLkhlQGFybS5jb20+
DQo+IENjOiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+OyBNaWNoYWVsIFMu
IFRzaXJraW4NCj4gPG1zdEByZWRoYXQuY29tPjsgSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0
LmNvbT47DQo+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4
LWZvdW5kYXRpb24ub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOyBLYWx5IFhpbg0KPiA8S2FseS5YaW5AYXJtLmNvbT4NCj4gU3ViamVj
dDogUmU6IFtQQVRDSF0gdmhvc3Q6IHZzb2NrOiBkb24ndCBzZW5kIHBrdCB3aGVuIHZxIGlzIG5v
dCBzdGFydGVkDQo+DQo+IEhpIEppYSwNCj4gdGhhbmtzIGZvciB0aGUgcGF0Y2gsIHNvbWUgY29t
bWVudHMgYmVsb3c6DQo+DQo+IE9uIFRodSwgQXByIDMwLCAyMDIwIGF0IDEwOjEzOjE0QU0gKzA4
MDAsIEppYSBIZSB3cm90ZToNCj4gPiBOaW5nIEJvIHJlcG9ydGVkIGFuIGFibm9ybWFsIDItc2Vj
b25kIGdhcCB3aGVuIGJvb3RpbmcgS2F0YSBjb250YWluZXINCj4gWzFdLg0KPiA+IFRoZSB1bmNv
bmRpdGlvbmFsIHRpbWVvdXQgaXMgY2F1c2VkIGJ5DQo+IFZTT0NLX0RFRkFVTFRfQ09OTkVDVF9U
SU1FT1VUIG9mDQo+ID4gY29ubmVjdCBhdCBjbGllbnQgc2lkZS4gVGhlIHZob3N0IHZzb2NrIGNs
aWVudCB0cmllcyB0byBjb25uZWN0IGFuDQo+ID4gaW5pdGxpemluZyB2aXJ0aW8gdnNvY2sgc2Vy
dmVyLg0KPiA+DQo+ID4gVGhlIGFibm9ybWFsIGZsb3cgbG9va3MgbGlrZToNCj4gPiBob3N0LXVz
ZXJzcGFjZSAgICAgICAgICAgdmhvc3QgdnNvY2sgICAgICAgICAgICAgICAgICAgICAgIGd1ZXN0
IHZzb2NrDQo+ID4gPT09PT09PT09PT09PT0gICAgICAgICAgID09PT09PT09PT09ICAgICAgICAg
ICAgICAgICAgICAgICA9PT09PT09PT09PT0NCj4gPiBjb25uZWN0KCkgICAgIC0tLS0tLS0tPiAg
dmhvc3RfdHJhbnNwb3J0X3NlbmRfcGt0X3dvcmsoKSAgIGluaXRpYWxpemluZw0KPiA+ICAgIHwg
ICAgICAgICAgICAgICAgICAgICB2cS0+cHJpdmF0ZV9kYXRhPT1OVUxMDQo+ID4gICAgfCAgICAg
ICAgICAgICAgICAgICAgIHdpbGwgbm90IGJlIHF1ZXVlZA0KPiA+ICAgIFYNCj4gPiBzY2hlZHVs
ZV90aW1lb3V0KDJzKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICB2aG9zdF92c29ja19z
dGFydCgpICA8LS0tLS0tLS0tICAgZGV2aWNlIHJlYWR5DQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgICAgIHNldCB2cS0+cHJpdmF0ZV9kYXRhDQo+ID4NCj4gPiB3YWl0IGZvciAycyBhbmQgZmFp
bGVkDQo+ID4NCj4gPiBjb25uZWN0KCkgYWdhaW4gICAgICAgICAgdnEtPnByaXZhdGVfZGF0YSE9
TlVMTCAgICAgICAgICByZWN2IGNvbm5lY3RpbmcgcGt0DQo+ID4NCj4gPiAxLiBob3N0IHVzZXJz
cGFjZSBzZW5kcyBhIGNvbm5lY3QgcGt0LCBhdCB0aGF0IHRpbWUsIGd1ZXN0IHZzb2NrIGlzIHVu
ZGVyDQo+ID4gaW5pdGlhbGl6aW5nLCBoZW5jZSB0aGUgdmhvc3RfdnNvY2tfc3RhcnQgaGFzIG5v
dCBiZWVuIGNhbGxlZC4gU28NCj4gPiB2cS0+cHJpdmF0ZV9kYXRhPT1OVUxMLCBhbmQgdGhlIHBr
dCBpcyBub3QgYmVlbiBxdWV1ZWQgdG8gc2VuZCB0byBndWVzdC4NCj4gPiAyLiB0aGVuIGl0IHNs
ZWVwcyBmb3IgMnMNCj4gPiAzLiBhZnRlciBndWVzdCB2c29jayBmaW5pc2hlcyBpbml0aWFsaXpp
bmcsIHZxLT5wcml2YXRlX2RhdGEgaXMgc2V0Lg0KPiA+IDQuIFdoZW4gaG9zdCB1c2Vyc3BhY2Ug
d2FrZXMgdXAgYWZ0ZXIgMnMsIHNlbmQgY29ubmVjdGluZyBwa3QgYWdhaW4sDQo+ID4gZXZlcnl0
aGluZyBpcyBmaW5lLg0KPiA+DQo+ID4gVGhpcyBmaXhlcyBpdCBieSBjaGVja2luZyB2cS0+cHJp
dmF0ZV9kYXRhIGluIHZob3N0X3RyYW5zcG9ydF9zZW5kX3BrdCwNCj4gPiBhbmQgcmV0dXJuIGF0
IG9uY2UgaWYgIXZxLT5wcml2YXRlX2RhdGEuIFRoaXMgbWFrZXMgdXNlciBjb25uZWN0KCkNCj4g
PiBiZSByZXR1cm5lZCB3aXRoIEVDT05OUkVGVVNFRC4NCj4gPg0KPiA+IEFmdGVyIHRoaXMgcGF0
Y2gsIGthdGEtcnVudGltZSAod2l0aCB2c29jayBlbmFibGVkKSBib290dGltZSByZWR1Y2VzIGZy
b20NCj4gPiAzcyB0byAxcyBvbiBUaHVuZGVyWDIgYXJtNjQgc2VydmVyLg0KPiA+DQo+ID4gWzFd
IGh0dHBzOi8vZ2l0aHViLmNvbS9rYXRhLWNvbnRhaW5lcnMvcnVudGltZS9pc3N1ZXMvMTkxNw0K
PiA+DQo+ID4gUmVwb3J0ZWQtYnk6IE5pbmcgQm8gPG4uYkBsaXZlLmNvbT4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBKaWEgSGUgPGp1c3Rpbi5oZUBhcm0uY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJz
L3Zob3N0L3Zzb2NrLmMgfCA4ICsrKysrKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2Vy
dGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMgYi9k
cml2ZXJzL3Zob3N0L3Zzb2NrLmMNCj4gPiBpbmRleCBlMzZhYWY5YmE3YmQuLjY3NDc0MzM0ZGQ4
OCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMNCj4gPiArKysgYi9kcml2
ZXJzL3Zob3N0L3Zzb2NrLmMNCj4gPiBAQCAtMjQxLDYgKzI0MSw3IEBAIHZob3N0X3RyYW5zcG9y
dF9zZW5kX3BrdChzdHJ1Y3QgdmlydGlvX3Zzb2NrX3BrdA0KPiAqcGt0KQ0KPiA+ICB7DQo+ID4g
IHN0cnVjdCB2aG9zdF92c29jayAqdnNvY2s7DQo+ID4gIGludCBsZW4gPSBwa3QtPmxlbjsNCj4g
PiArc3RydWN0IHZob3N0X3ZpcnRxdWV1ZSAqdnE7DQo+ID4NCj4gPiAgcmN1X3JlYWRfbG9jaygp
Ow0KPiA+DQo+ID4gQEAgLTI1Miw2ICsyNTMsMTMgQEAgdmhvc3RfdHJhbnNwb3J0X3NlbmRfcGt0
KHN0cnVjdCB2aXJ0aW9fdnNvY2tfcGt0DQo+ICpwa3QpDQo+ID4gIHJldHVybiAtRU5PREVWOw0K
PiA+ICB9DQo+ID4NCj4gPiArdnEgPSAmdnNvY2stPnZxc1tWU09DS19WUV9SWF07DQo+ID4gK2lm
ICghdnEtPnByaXZhdGVfZGF0YSkgew0KPg0KPiBJIHRoaW5rIGlzIGJldHRlciB0byB1c2Ugdmhv
c3RfdnFfZ2V0X2JhY2tlbmQoKToNCj4NCj4gaWYgKCF2aG9zdF92cV9nZXRfYmFja2VuZCgmdnNv
Y2stPnZxc1tWU09DS19WUV9SWF0pKSB7DQo+IC4uLg0KPg0KPiBUaGlzIGZ1bmN0aW9uIHNob3Vs
ZCBiZSBjYWxsZWQgd2l0aCAndnEtPm11dGV4JyBhY3F1aXJlZCBhcyBleHBsYWluZWQgaW4NCj4g
dGhlIGNvbW1lbnQsIGJ1dCBoZXJlIHdlIGNhbiBhdm9pZCB0aGF0LCBiZWNhdXNlIHdlIGFyZSBu
b3QgdXNpbmcgdGhlIHZxLA0KPiBzbyBpdCBpcyBzYWZlLCBiZWNhdXNlIGluIHZob3N0X3RyYW5z
cG9ydF9kb19zZW5kX3BrdCgpIHdlIGNoZWNrIGl0IGFnYWluLg0KPg0KPiBQbGVhc2UgYWRkIGEg
Y29tbWVudCBleHBsYWluaW5nIHRoYXQuDQo+DQoNClRoYW5rcywgdmhvc3RfdnFfZ2V0X2JhY2tl
bmQgaXMgYmV0dGVyLiBJIGNob3NlIGEgNS4zIGtlcm5lbCB0byBkZXZlbG9wDQphbmQgbWlzc2Vk
IHRoaXMgaGVscGVyLg0KPg0KPiBBcyBhbiBhbHRlcm5hdGl2ZSB0byB0aGlzIHBhdGNoLCBzaG91
bGQgd2Uga2ljayB0aGUgc2VuZCB3b3JrZXIgd2hlbiB0aGUNCj4gZGV2aWNlIGlzIHJlYWR5Pw0K
Pg0KPiBJSVVDIHdlIHJlYWNoIHRoZSB0aW1lb3V0IGJlY2F1c2UgdGhlIHNlbmQgd29ya2VyICh0
aGF0IHJ1bnMNCj4gdmhvc3RfdHJhbnNwb3J0X2RvX3NlbmRfcGt0KCkpIGV4aXRzIGltbWVkaWF0
ZWx5IHNpbmNlICd2cS0+cHJpdmF0ZV9kYXRhJw0KPiBpcyBOVUxMLCBhbmQgbm8gb25lIHdpbGwg
cmVxdWV1ZSBpdC4NCj4NCj4gTGV0J3MgZG8gaXQgd2hlbiB3ZSBrbm93IHRoZSBkZXZpY2UgaXMg
cmVhZHk6DQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMgYi9kcml2ZXJz
L3Zob3N0L3Zzb2NrLmMNCj4gaW5kZXggZTM2YWFmOWJhN2JkLi4yOTViNTg2Nzk0NGYgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvdmhvc3QvdnNvY2suYw0KPiArKysgYi9kcml2ZXJzL3Zob3N0L3Zz
b2NrLmMNCj4gQEAgLTU0Myw2ICs1NDMsMTEgQEAgc3RhdGljIGludCB2aG9zdF92c29ja19zdGFy
dChzdHJ1Y3Qgdmhvc3RfdnNvY2sNCj4gKnZzb2NrKQ0KPiAgICAgICAgICAgICAgICAgbXV0ZXhf
dW5sb2NrKCZ2cS0+bXV0ZXgpOw0KPiAgICAgICAgIH0NCj4NCj4gKyAgICAgICAvKiBTb21lIHBh
Y2tldHMgbWF5IGhhdmUgYmVlbiBxdWV1ZWQgYmVmb3JlIHRoZSBkZXZpY2Ugd2FzIHN0YXJ0ZWQs
DQo+ICsgICAgICAgICogbGV0J3Mga2ljayB0aGUgc2VuZCB3b3JrZXIgdG8gc2VuZCB0aGVtLg0K
PiArICAgICAgICAqLw0KPiArICAgICAgIHZob3N0X3dvcmtfcXVldWUoJnZzb2NrLT5kZXYsICZ2
c29jay0+c2VuZF9wa3Rfd29yayk7DQo+ICsNClllcywgaXQgd29ya3MuDQpCdXQgZG8geW91IHRo
aW5rIGEgdGhyZXNob2xkIHNob3VsZCBiZSBzZXQgaGVyZSB0byBwcmV2ZW50IHRoZSBxdWV1ZQ0K
ZnJvbSBiZWluZyB0b28gbG9uZz8gRS5nLiB0aGUgY2xpZW50IHVzZXIgc2VuZHMgdG9vIG1hbnkg
Y29ubmVjdCBwa3RzDQppbiBhIHNob3J0IHRpbWUgYmVmb3JlIHRoZSBzZXJ2ZXIgaXMgY29tcGxl
dGVseSByZWFkeS4NCg0KPiAgICAgICAgIG11dGV4X3VubG9jaygmdnNvY2stPmRldi5tdXRleCk7
DQo+ICAgICAgICAgcmV0dXJuIDA7DQo+DQo+IEkgZGlkbid0IHRlc3QgaXQsIGNhbiB5b3UgdHJ5
IGlmIGl0IGZpeGVzIHRoZSBpc3N1ZT8NCj4NCj4gSSdtIG5vdCBzdXJlIHdoaWNoIGlzIGJldHRl
ci4uLg0KSSBkb24ndCBrbm93LCBlaXRoZXIuIFdhaXQgZm9yIG1vcmUgY29tbWVudHMg8J+Yig0K
DQotLQ0KQ2hlZXJzLA0KSnVzdGluIChKaWEgSGUpDQpJTVBPUlRBTlQgTk9USUNFOiBUaGUgY29u
dGVudHMgb2YgdGhpcyBlbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBjb25maWRlbnRpYWwg
YW5kIG1heSBhbHNvIGJlIHByaXZpbGVnZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZCBy
ZWNpcGllbnQsIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseSBhbmQgZG8gbm90
IGRpc2Nsb3NlIHRoZSBjb250ZW50cyB0byBhbnkgb3RoZXIgcGVyc29uLCB1c2UgaXQgZm9yIGFu
eSBwdXJwb3NlLCBvciBzdG9yZSBvciBjb3B5IHRoZSBpbmZvcm1hdGlvbiBpbiBhbnkgbWVkaXVt
LiBUaGFuayB5b3UuDQo=
