Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F89F1E912A
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 14:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgE3M0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 08:26:47 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:47835
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728965AbgE3M0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 08:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jK9LBLNawFtr5YvewnNlM5CfMhIuN9pJxPOIWPlTQng=;
 b=qGH//i/oIPVd+0Qj6bN/EAxl/K6WO4rzAupz/WZD1Jcof7j+W9qFXZI/k/HswyJ86GV9XUCvs3zlXjWpQR0ComcKyv92uYV3FtkQqLUtZ02OynZDvTrj2xVeeDG/68tVyjBVh5C07HqRiDXPAkBr2tw/RzJjWuhE99fzP8m2aTQ=
Received: from AM5PR0101CA0010.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::23) by DB8PR08MB4090.eurprd08.prod.outlook.com
 (2603:10a6:10:ab::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Sat, 30 May
 2020 12:26:41 +0000
Received: from AM5EUR03FT061.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:16:cafe::16) by AM5PR0101CA0010.outlook.office365.com
 (2603:10a6:206:16::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend
 Transport; Sat, 30 May 2020 12:26:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT061.mail.protection.outlook.com (10.152.16.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Sat, 30 May 2020 12:26:41 +0000
Received: ("Tessian outbound 14e212f6ce41:v57"); Sat, 30 May 2020 12:26:41 +0000
X-CR-MTA-TID: 64aa7808
Received: from 21180d8591c6.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 9EF330C7-CE99-498D-8514-474A4AD5CA98.1;
        Sat, 30 May 2020 12:26:36 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 21180d8591c6.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Sat, 30 May 2020 12:26:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCllHWHJhvlMRolMujotroI//GCkdp6d+Lm7USXceTCai3PuJM2rKowMWotdr9G5ZstVXbMI9RdhNntwqHTGuQjQESC1VHhB+ETd5fUve/nI5w6XWxyQfLnAb+bcjb9BpLflkZIyp/Y/J6hjH3T0lWQVfjzX1ao6+FjF36lNXXvathjPod5hQtZUipuyBzO2KU0AtWeJKN1a6fYwtFtZQQQvIOhsa67QhNfqSOBxP4x2GqR55XcrwoLmoGeVMiSlVPyJrPyTMwNIY34zpnOQjV56LaNvx9/uFrNOVFmRQvPqQbAmzv8clJmc0/2B0RIHFtLUKR8yxMl815wIjsthCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jK9LBLNawFtr5YvewnNlM5CfMhIuN9pJxPOIWPlTQng=;
 b=ZLz2kHVngcnnNk/fzwkINVRpVgFVEvSB9wB31ZY/FhiijLoL9W6lKcGHETz4p7zVvVa+pCwn+Fn99kUtjUwPE29ZmG7pvraAIqXdjauOikPi6reGqpmpCSAREPCknW1nWVj1z7icVm6u4QyQYLKiIYZmXPijiP/jT1AR1xmidEIAvlOn9Wa2YYD7076yVwye54ei0XnpCZFKi19i3z0CMTDmcjyFdpALjBVw4AJEL6+cwdFo7R6aokpuyBKCWo5FnkGOCDmQk7R69wofzHvUuwfiMXf1cPcRbj6DyVFExlE+ZOa94wzCl84dGajAPtmGu3bZSCEFPQID5Fz3ceNsew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jK9LBLNawFtr5YvewnNlM5CfMhIuN9pJxPOIWPlTQng=;
 b=qGH//i/oIPVd+0Qj6bN/EAxl/K6WO4rzAupz/WZD1Jcof7j+W9qFXZI/k/HswyJ86GV9XUCvs3zlXjWpQR0ComcKyv92uYV3FtkQqLUtZ02OynZDvTrj2xVeeDG/68tVyjBVh5C07HqRiDXPAkBr2tw/RzJjWuhE99fzP8m2aTQ=
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com (2603:10a6:20b:af::32)
 by AM6PR08MB3350.eurprd08.prod.outlook.com (2603:10a6:209:45::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Sat, 30 May
 2020 12:26:33 +0000
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::8c97:9695:2f8d:3ae0]) by AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::8c97:9695:2f8d:3ae0%5]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 12:26:33 +0000
From:   Justin He <Justin.He@arm.com>
To:     Markus Elfring <Markus.Elfring@web.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kaly Xin <Kaly.Xin@arm.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: RE: [PATCH v3] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt()
Thread-Topic: [PATCH v3] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt()
Thread-Index: AQHWNm7Xf6F/C5P9d0yLicC2mOT31qjAjXEw
Date:   Sat, 30 May 2020 12:26:33 +0000
Message-ID: <AM6PR08MB4069DA3BA6B5F59094E2CCBAF78C0@AM6PR08MB4069.eurprd08.prod.outlook.com>
References: <7edeff0b-2dd8-aeae-aa96-73c98d581ece@web.de>
In-Reply-To: <7edeff0b-2dd8-aeae-aa96-73c98d581ece@web.de>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 13ae88bf-63a6-40ce-9971-aace638b1484.0
x-checkrecipientchecked: true
Authentication-Results-Original: web.de; dkim=none (message not signed)
 header.d=none;web.de; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 87b05494-f2b1-41cc-7767-08d80494b54a
x-ms-traffictypediagnostic: AM6PR08MB3350:|DB8PR08MB4090:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB4090BB31020DF4AEB4CB89E8F78C0@DB8PR08MB4090.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:639;OLM:10000;
x-forefront-prvs: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 9ZPfXQLbHODoa7/ttNBnrfideBGvNl52J0qViF+bEEdtc8rwW3Exsmmrb6VAm9siQwetBTbSyjObcaMFude6wK9PGQPesbQd0C3ehlO2C3umX3I9Gr5VDndw83N9DdDv+iKQd2+KjnGQNNMhwQlr3osyIzr5TJNmX1/JnuNUkA3J/32xlcbg8I5ZMjaG8FiZ4+gO2CshMGLLVmhoqlBMlTpv486Zeln+AYLKBO/A/jdQdsZwj3d2NoVFWMVlY89Ql+MHGN2vQkXYkoPsTspGvnUg9k3X8zauhvScw2EMdydF3TL+FWHVJPjJVVnMO8GNEwIXXe2KRUCQLjpS+jb4GA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4069.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(4326008)(55016002)(7416002)(9686003)(64756008)(66946007)(66556008)(66476007)(66446008)(5660300002)(53546011)(76116006)(6506007)(110136005)(26005)(54906003)(316002)(2906002)(33656002)(186003)(7696005)(71200400001)(52536014)(86362001)(8936002)(83380400001)(8676002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 5AMqjxiJY450v38XRfvTiNcjlu5C5apeJ6IGzAWmywleRSiuwc3/tcvrO9T+lV2L8sILHkyh+2vO/H7JSQs+oX1dDwflg4IvOysUDcwDNb9bgk2xY9p0Qgl3KsGlAh7faWXBfug45vJPSvYCvuWq0MF7533l1Fx+D4AtJn4qC9obHt0WDT3Qd1PTT5H72fL2eYfr90u16dk/fwnVyrBu39w5UcAn5MC1PFJV5J0uVlM3GclCvyMW4FszyY3ZPPKY1uISxFrTkNWTkNGTS8xZPpfKR3/CvwJqojntynNgsrUnYZ8v7Yv7h3hW5jXxaBAGXg5UvQL325PmE2e1GhFMO+KzyYYV41x1oLMDLHUrs9rfgyjN9mrU17oqpbCet5LyF0/UNKO5o1m/xZhQC6ceP3O7pMAt7m5pgimkW4ve3p1NiM3q4I236wKUff59IJSQJH/cwolHY4RxhHaZ2+TlUqvDA7la30Z7GK1lINNSzZs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3350
Original-Authentication-Results: web.de; dkim=none (message not signed)
 header.d=none;web.de; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT061.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(39860400002)(346002)(396003)(46966005)(26005)(8936002)(81166007)(5660300002)(6506007)(83380400001)(53546011)(86362001)(2906002)(450100002)(36906005)(54906003)(316002)(107886003)(7696005)(110136005)(4326008)(82310400002)(8676002)(55016002)(33656002)(356005)(9686003)(478600001)(186003)(82740400003)(70206006)(70586007)(336012)(47076004)(52536014);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 57140de5-6fbd-494b-88e1-08d80494b07d
X-Forefront-PRVS: 041963B986
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdua6nC2b8H/hMWyjLVTwMn+QXrOemh5j1aNdoNsb/M0To0g/OBWrNDqx5vcRcHDRRP+qac48faXMONj4t5H0STbpVNLYdTv4ql1WcID2wexB8VnwYWfzX/lc/zv91K3XxCpl9wpoQmjIKW7bcCAiKlWDxtERQ0QoFLX0rK2afWP5wTh+OjmEtKBvwdYugr17jkCQDSbld74ps6yo+hitRjq8XtChO49q19Irz1JrP84SHoJqQSnIy+3NmIdY3SFdnum5xEwKVKdsmvhjkbLlNeZ586DRqc9RiNxsdHLBw1a/Fod5zo12LCZDi2UmjkccMEVmvw7ZAz3/S1Yr2/VRIm7pz2vrIX2FLdtFN9dMjV8eLicSzhnVUIumCDYjKEUMAe42QzKleOBbk4AaDKbFA==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 12:26:41.4703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b05494-f2b1-41cc-7767-08d80494b54a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFya3VzDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFya3Vz
IEVsZnJpbmcgPE1hcmt1cy5FbGZyaW5nQHdlYi5kZT4NCj4gU2VudDogU2F0dXJkYXksIE1heSAz
MCwgMjAyMCA2OjQxIFBNDQo+IFRvOiBKdXN0aW4gSGUgPEp1c3Rpbi5IZUBhcm0uY29tPjsga3Zt
QHZnZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgdmlydHVhbGl6YXRp
b25AbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmcNCj4gQ2M6IGtlcm5lbC1qYW5pdG9yc0B2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmc7IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3Vi
DQo+IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBLYWx5IFhpbiA8S2FseS5YaW5AYXJtLmNv
bT47IFN0ZWZhbiBIYWpub2N6aQ0KPiA8c3RlZmFuaGFAcmVkaGF0LmNvbT47IFN0ZWZhbm8gR2Fy
emFyZWxsYSA8c2dhcnphcmVAcmVkaGF0LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2M10g
dmlydGlvX3Zzb2NrOiBGaXggcmFjZSBjb25kaXRpb24gaW4NCj4gdmlydGlvX3RyYW5zcG9ydF9y
ZWN2X3BrdCgpDQo+DQo+ID4gVGhpcyBmaXhlcyBpdCBieSBjaGVja2luZyBzay0+c2tfc2h1dGRv
d24oc3VnZ2VzdGVkIGJ5IFN0ZWZhbm8pIGFmdGVyDQo+ID4gbG9ja19zb2NrIHNpbmNlIHNrLT5z
a19zaHV0ZG93biBpcyBzZXQgdG8gU0hVVERPV05fTUFTSyB1bmRlciB0aGUNCj4gPiBwcm90ZWN0
aW9uIG9mIGxvY2tfc29ja19uZXN0ZWQuDQo+DQo+IEhvdyBkbyB5b3UgdGhpbmsgYWJvdXQgYSB3
b3JkaW5nIHZhcmlhbnQgbGlrZSB0aGUgZm9sbG93aW5nPw0KPg0KPiAgIFRodXMgY2hlY2sgdGhl
IGRhdGEgc3RydWN0dXJlIG1lbWJlciDigJxza19zaHV0ZG93buKAnSAoc3VnZ2VzdGVkIGJ5IFN0
ZWZhbm8pDQo+ICAgYWZ0ZXIgYSBjYWxsIG9mIHRoZSBmdW5jdGlvbiDigJxsb2NrX3NvY2vigJ0g
c2luY2UgdGhpcyBmaWVsZCBpcyBzZXQgdG8NCj4gICDigJxTSFVURE9XTl9NQVNL4oCdIHVuZGVy
IHRoZSBwcm90ZWN0aW9uIG9mIOKAnGxvY2tfc29ja19uZXN0ZWTigJ0uDQo+DQpPa2F5LCB3aWxs
IHVwZGF0ZSB0aGUgY29tbWl0IG1zZy4NCg0KPg0KPiBXb3VsZCB5b3UgbGlrZSB0byBhZGQgdGhl
IHRhZyDigJxGaXhlc+KAnSB0byB0aGUgY29tbWl0IG1lc3NhZ2U/DQpTdXJlLg0KDQpUaGFua3MN
Cg0KDQotLQ0KQ2hlZXJzLA0KSnVzdGluIChKaWEgSGUpDQoNCg0KPg0KPiBSZWdhcmRzLA0KPiBN
YXJrdXMNCklNUE9SVEFOVCBOT1RJQ0U6IFRoZSBjb250ZW50cyBvZiB0aGlzIGVtYWlsIGFuZCBh
bnkgYXR0YWNobWVudHMgYXJlIGNvbmZpZGVudGlhbCBhbmQgbWF5IGFsc28gYmUgcHJpdmlsZWdl
ZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgcGxlYXNlIG5vdGlmeSB0
aGUgc2VuZGVyIGltbWVkaWF0ZWx5IGFuZCBkbyBub3QgZGlzY2xvc2UgdGhlIGNvbnRlbnRzIHRv
IGFueSBvdGhlciBwZXJzb24sIHVzZSBpdCBmb3IgYW55IHB1cnBvc2UsIG9yIHN0b3JlIG9yIGNv
cHkgdGhlIGluZm9ybWF0aW9uIGluIGFueSBtZWRpdW0uIFRoYW5rIHlvdS4NCg==
