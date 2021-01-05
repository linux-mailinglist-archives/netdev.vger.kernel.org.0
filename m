Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA202EB0D0
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbhAERBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:01:30 -0500
Received: from us-smtp-delivery-181.mimecast.com ([216.205.24.181]:21007 "EHLO
        us-smtp-delivery-181.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728245AbhAERBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 12:01:30 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2021 12:01:28 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rbbn.com; s=mimecast20180816;
        t=1609866002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6b0mpSnuNsckP+vhQX0iDy/O+Ss8PYHAhd98i0DUaU=;
        b=igYti3uMORnH0gbFsJCUPxTWSYUYzj6WlMU3XDXRS9NYTBTM31CToZoTOIZOdR3dbQvV7G
        lLzA8ET4ahIa9NYt8ZEoWcjoSG4gZ7wbiAtQHha/JLq+k6C/rnjDxvXTOH6QsET7aTasba
        VDQrrlvpIU5KvWBog2ObI20MCReNGzc=
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-lqjfW53bPiKKb6GpQf1lxg-1; Tue, 05 Jan 2021 11:49:16 -0500
Received: from MN2PR03MB4752.namprd03.prod.outlook.com (2603:10b6:208:af::30)
 by BLAPR03MB5476.namprd03.prod.outlook.com (2603:10b6:208:29b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 16:49:15 +0000
Received: from MN2PR03MB4752.namprd03.prod.outlook.com
 ([fe80::e888:49b:bdd7:75df]) by MN2PR03MB4752.namprd03.prod.outlook.com
 ([fe80::e888:49b:bdd7:75df%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 16:49:14 +0000
From:   "Finer, Howard" <hfiner@rbbn.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     "andy@greyhouse.net" <andy@greyhouse.net>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: bonding driver issue when configured for active/backup and using
 ARP monitoring
Thread-Topic: bonding driver issue when configured for active/backup and using
 ARP monitoring
Thread-Index: AdbHQ00ZgN9FZpM9RKmwxP/JkIcJoADOsOqABhwSyFAAB9MUgAAa644Q
Date:   Tue, 5 Jan 2021 16:49:14 +0000
Message-ID: <MN2PR03MB4752185078C244A121CF71DCB7D10@MN2PR03MB4752.namprd03.prod.outlook.com>
References: <MN2PR03MB47526B686EF6E0F8D81A9397B7F50@MN2PR03MB4752.namprd03.prod.outlook.com>
 <14769.1607114585@famine>
 <MN2PR03MB47524C92E45EB4C1B70D595CB7D20@MN2PR03MB4752.namprd03.prod.outlook.com>
 <9069.1609815085@famine>
In-Reply-To: <9069.1609815085@famine>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [208.45.178.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68859273-e43a-4e4b-d221-08d8b199d5e6
x-ms-traffictypediagnostic: BLAPR03MB5476:
x-microsoft-antispam-prvs: <BLAPR03MB5476D8F2C513F40B1BE04806B7D10@BLAPR03MB5476.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: jxy64ZAxyXYMgvkzk2zSfhALAa9a51mRdOxzFJmyhKpoGyE1K7GBFS9wZXoyKbJ0A06AJx2dxJHxM1Hz54wx2m/EO0xSo2f0h4QmLtFDE6mJi9XjRpTnRh2hc5rx1GMaciBbnCQWf0kd8oxBIDAtVAQeL3EQaJUdwher/a1NGlJyUfJcqljDENLulpDYV4ms0MC+CqCaKffeu12OIqUeRGATi2ufSJyugLJhMwmGbq7xTl5+bYEcPk4nQxImlkPDqoVQ8VE5ZH47RHvU7AsK7pQ0Rre9HqIDag6kcK1yavEqpIPCFzYW7Dj4cyvkjIRsDXKY584AR95WwuUAuoXKOMTX0BlDUSQ+YlPyDHOFD0E/NWpbCYxxeWxd2rYRsV4V219pz32oWIRTivUjmouETTTTTgeGs7B/InrIjz5nfgTpw6wdWlqXeGjKMgRM5jucXoHi1oTMnWf95E2HjfZuBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR03MB4752.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(71200400001)(5660300002)(966005)(186003)(83380400001)(6506007)(2906002)(4326008)(86362001)(52536014)(54906003)(26005)(53546011)(66476007)(66556008)(6916009)(8676002)(55016002)(9686003)(316002)(66946007)(76116006)(33656002)(7696005)(478600001)(66446008)(64756008)(8936002);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: =?utf-8?B?Nnptc3NzeUxFV0Z3SVFzdkpxakF6OWVEeFNrbXUvQjhFUHJoOVFESDY4bXcx?=
 =?utf-8?B?ODlneTI5VFNoYlY5WEZ4OGxQNFNjcWNvREUwTXZGU3ZUL0RIYlkwbzZObVZY?=
 =?utf-8?B?R0tGaUJMQkFjNFE1MnpQa2dTQXpKbUZBeWtqaDBYSGdhUlhPWXVXeFk2MEEx?=
 =?utf-8?B?Mm1zaFJYbFpWVXl1K21Ic1kvWVZleEZCNmdqQTlnRnVGcWpmemlFRVBNb0VK?=
 =?utf-8?B?eHV6dndsandiUTh5L2VORnloT3dnNG9LaFQrd25SVXNFL1FFbW1jeWZ2YzFT?=
 =?utf-8?B?VGlEMUpDQnBaRWk2REg3YzRhdEFJVVlqazcvK2xXL0ZRMFgvaXJVbjJ5ZEhp?=
 =?utf-8?B?V1VTcmhlRTQ3RzJubEgxQkFiUE12RGhXODkzWE1yVWswY2FoM2xiUkM3U2ZQ?=
 =?utf-8?B?M3VUTkVGaWVyalN1TmlRVjlyYUU1N0MycjRwS1hQRUpaWWZ5WExUd1A4bWJu?=
 =?utf-8?B?UXB1WG10am9sY25qWU1VYWU2ZjVWTmZWTXo4NXRnVzVJdEk3bUY2ZWdEUjdR?=
 =?utf-8?B?a2ZxL1N1QnhOVUQwV0h4QVhPOWFDc3gxZE95MHlONkVvTnNKNXBMaUVGUW5z?=
 =?utf-8?B?YndBalkzUnNMYUtaZjczZ015bUVtdnZ1dlE2OW5sMHg0bWVRMmpyQ3F3RzBw?=
 =?utf-8?B?aWRSMmo0bGY3Zm1OaWUveUFkNWlFZlAzQ2JpVnZDZHhCK1JFdHk4R2V1RHo3?=
 =?utf-8?B?RFRFekYzdmtvdXFOQlE2YW1XVXg0aXdsUG8vaG81UVk2SzFCVzl2K3pNYnFy?=
 =?utf-8?B?RjZ4V0ZEeWV1elRQczFPcGppNTU5QXA3YjZyamRsT0szMFpsRWJqTHVZVVB0?=
 =?utf-8?B?U3RYSFY1S1lqcUxYTndiRkpRZDFDWXQyTE5TaVdkYTdRNUgxNWFrWU0wc1Rj?=
 =?utf-8?B?Q21HSmxocUZwZDIxSmlUZTdEVEUxWDdlZEc5UmZyMWt5R2gwc2VjRnhjelhF?=
 =?utf-8?B?UFYxaDNFT21aVmptalZvNUlNbnFuZnRDZnEwS1V2ZlVEa1BDRTc1M2d2ODZJ?=
 =?utf-8?B?OTdpbjgxamJ6MVNreVNOL3VKZFQxclV4NGtZT2duMWJZM1VmWlZDdWxZTUta?=
 =?utf-8?B?RWc3Ny8ybFh5K2w4eWdGdU1DSVYvT2pzWWduZElZN0crTXlCTGhBY3AySzRx?=
 =?utf-8?B?b1dZWkNpcndwaXdhTS9taU94N0t0UW9EMW9ZVU5SUEpGNGdpSjNWRG1ZWm1a?=
 =?utf-8?B?ZU1KbDArMUtPVjIvS0ZYMzFyVkt1bmtzOGwzRDFWOUxxc09UVXNERFVObXhB?=
 =?utf-8?B?YVZMcm0zU01LZ0RubUtmVWc5WGNkUlNQNGxJRU1uQ29xNCtia3pJeFB3cFZF?=
 =?utf-8?Q?R7nQJb4hOq82M=3D?=
x-ms-exchange-transport-forked: True
x-mc-unique: lqjfW53bPiKKb6GpQf1lxg-1
x-originatororg: rbbn.com
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: MN2PR03MB4752.namprd03.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: 68859273-e43a-4e4b-d221-08d8b199d5e6
x-ms-exchange-crosstenant-originalarrivaltime: 05 Jan 2021 16:49:14.9222 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 29a671dc-ed7e-4a54-b1e5-8da1eb495dc3
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: CQSXlZdP50oJzw7c3XvtNe7BJh43EsKt6uzDduO/QrS6aB8QvJLR4u5ykvwaW0iE
x-ms-exchange-transport-crosstenantheadersstamped: BLAPR03MB5476
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA81A106 smtp.mailfrom=hfiner@rbbn.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rbbn.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIEpheS4NCg0KIFRoaXMgaXMgYSBkZWRpY2F0ZWQgbGluayBiZXR3ZWVuIG91ciB0d28g
bWFjaGluZXMuICBUaGUgb25seSB0aGluZyBwcm92aXNpb25lZCBvbiBpdCBpcyB0aGUgYm9uZCBk
ZXZpY2UgYW5kIHRoZSBJUCBmb3IgdGhhdCBib25kIGRldmljZS4gIFRoZXJlIGFyZSBubyBvdGhl
ciBhZGRyZXNzZXMgb24gaXQgYW5kIG5vIFZMQU5zIGFib3ZlIGl0Lg0KDQpUaGUgYXJwX2lwX3Rh
cmdldCBpcyBub3QgcmVhY2hhYmxlIHZpYSBhbnkgb3RoZXIgaW50ZXJmYWNlLiAgRm9yIGV4YW1w
bGU6DQogIGlwIHJvdXRlIGdldCAxNjkuMjU0Ljg4LjENCiAgICAgIDE2OS4yNTQuODguMSBkZXYg
Ym9uZDAgIHNyYyAxNjkuMjU0Ljk5LjENCg0KDQpUaGFua3MsDQpIb3dhcmQNCg0KDQoNCkZyb206
IEpheSBWb3NidXJnaCA8amF5LnZvc2J1cmdoQGNhbm9uaWNhbC5jb20+DQpTZW50OiBNb25kYXks
IEphbnVhcnkgNCwgMjAyMSA5OjUxIFBNDQpUbzogRmluZXIsIEhvd2FyZCA8aGZpbmVyQHJiYm4u
Y29tPg0KQ2M6IGFuZHlAZ3JleWhvdXNlLm5ldDsgdmZhbGljb0BnbWFpbC5jb207IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBib25kaW5nIGRyaXZlciBpc3N1ZSB3aGVuIGNv
bmZpZ3VyZWQgZm9yIGFjdGl2ZS9iYWNrdXAgYW5kIHVzaW5nIEFSUCBtb25pdG9yaW5nDQoNCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCk5PVElDRTogVGhpcyBlbWFp
bCB3YXMgcmVjZWl2ZWQgZnJvbSBhbiBFWFRFUk5BTCBzZW5kZXINCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18NCg0KRmluZXIsIEhvd2FyZCA8bWFpbHRvOmhmaW5lckBy
YmJuLmNvbT4gd3JvdGU6DQoNCj5QbGVhc2UgYWR2aXNlIGlmIHRoZXJlIGlzIGFueSB1cGRhdGUg
aGVyZSwgYW5kIGlmIG5vdCBob3cgd2UgY2FuIGdvIGFib3V0DQo+Z2V0dGluZyBhbiB1cGRhdGUg
dG8gdGhlIGRyaXZlciB0byByZWN0aWZ5IHRoZSBpc3N1ZS4NCg0KQXMgaXQgaGFwcGVucywgSSd2
ZSBiZWVuIGxvb2tpbmcgYXQgdGhpcyB0b2RheSwgYW5kIGhhdmUgYQ0KY291cGxlIG9mIHF1ZXN0
aW9ucyBhYm91dCB5b3VyIGNvbmZpZ3VyYXRpb246DQoNCi0gSXMgdGhlcmUgYW4gSVAgYWRkcmVz
cyBvbiB0aGUgc2FtZSBzdWJuZXQgYXMgdGhlIGFycF9pcF90YXJnZXQNCmNvbmZpZ3VyZWQgZGly
ZWN0bHkgb24gdGhlIGJvbmQsIG9yIG9uIGEgVkxBTiBsb2dpY2FsbHkgYWJvdmUgdGhlIGJvbmQ/
DQoNCi0gSXMgdGhlICJhcnBfaXBfdGFyZ2V0IiBhZGRyZXNzIHJlYWNoYWJsZSB2aWEgYW4gaW50
ZXJmYWNlDQpvdGhlciB0aGFuIHRoZSBib25kIChvciBWTEFOIGFib3ZlIGl0KT8gVGhpcyBjYW4g
YmUgY2hlY2tlZCB2aWEgImlwDQpyb3V0ZSBnZXQgW2FycF9pcF90YXJnZXRdIiwgaS5lLiwgaWYg
dGhlIHRhcmdldCBhZGRyZXNzIGZvciBib25kMCBpcw0KaHR0cDovLzEuMi4zLjQsIHRoZSBjb21t
YW5kICJpcCByb3V0ZSBnZXQgaHR0cDovLzEuMi4zLjQiIHdpbGwgcmV0dXJuIHNvbWV0aGluZyBs
aWtlDQoNCmh0dHA6Ly8xLjIuMy40IGRldiBib25kMCBzcmMgWy4uLl0NCg0KSWYgYW4gaW50ZXJm
YWNlIG90aGVyIHRoYW4gYm9uZDAgKG9yIGEgVkxBTiBhYm92ZSBpdCkgaXMgbGlzdGVkLA0KdGhl
biB0aGVyZSdzIGEgcGF0aCB0byB0aGUgYXJwX2lwX3RhcmdldCB0aGF0IGRvZXNuJ3QgZ28gdGhy
b3VnaCB0aGUNCmJvbmQuDQoNClRoZSBBUlAgbW9uaXRvciBsb2dpYyBjYW4gb25seSBoYW5kbGUg
YSBsaW1pdGVkIHNldCBvZg0KY29uZmlndXJhdGlvbnMsIHNvIGlmIHlvdXIgY29uZmlndXJhdGlv
biBpcyBvdXRzaWRlIG9mIHRoYXQgaXQgY2FuDQptaXNiZWhhdmUgaW4gc29tZSB3YXlzLg0KDQot
Sg0KDQotLS0NCi1KYXkgVm9zYnVyZ2gsIG1haWx0bzpqYXkudm9zYnVyZ2hAY2Fub25pY2FsLmNv
bQ0K

