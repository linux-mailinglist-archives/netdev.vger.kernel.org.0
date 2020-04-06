Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7B119EF38
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 03:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgDFBvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 21:51:41 -0400
Received: from mail-eopbgr1320118.outbound.protection.outlook.com ([40.107.132.118]:64434
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726373AbgDFBvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Apr 2020 21:51:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBLpiJ0bvNQZS8utZgc8MvpN/pYt1poacotFvIoeuwJBdPi/R/8qkC7WfxRP4zXM4IwRJ0oXqmHhkyf5KRGtCPhSo6NTmSg/Gogrki7BMnefw9OblR8klC+jE+kfhNmkPPZKx93G/Y7b56BUMtp8QXAKUdv4B4ylx6u148zixa8QLJPDgor+rL18pZXVxN+8Uoscp2bfYkstQjKY5NXe6Yg1YgygDHOMZCXYCxqti2Hb2qkjpKfiqy6+VaYVz7QJivoIGI2Ph4pkBBLzUVHFJ1QfDXPwckpQCkQ48OeTp+O5p1uCVYJhgrbm+Qj0RLgR4Cnb8To+NuLWBzuUjq+yYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAis/pX2Od+aiPxhpkC+D6mMU3IPsmq5eXM5m6lk8YA=;
 b=nx/YvqKaoNhX0nUP0NBjlBb4PMVjgSSZBcq+OwHF1O4pUN664A95yr9COicsynmelj5MwdU+99EkR6LLPvlqMj3vuOSxAjQpCXSMIf4vroWdCMRplYWJQEa2qkxTl4kHJAAAhj3he/sPLgZTT92jZPElKKiF/lp1lRPjljzbMHynqEd9b2JzqVi1FZi5JoXWjuPGt7aF4urU+mQtdCSqBRnQmBtga3WGbDwI3qytfHdnvy92GZTJ/6aMUTKr+eXV/PVNEjzAx/EvwofnHx0zkLAOAg9qy7oIGTXgkWWQnuV/eBgzCwsWSMsR01fRjU9oPF2JKY3fbTTpOKm07zKX1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAis/pX2Od+aiPxhpkC+D6mMU3IPsmq5eXM5m6lk8YA=;
 b=dlQ6/PHFoYV9UIoYxu979sxE32RYvZnKeSSX1zQP1bDQ7e9ibLsxiygE4cNXTgmsvUcpTRsj83QJ4YY+THbOqUZLBhzZ4625POyGfzGS73tAvlDZeYk0iDNbhAp467/3vfkCuTBS8myivSRA9TiKSEg01a7fbFD0yn9rWp+mjrc=
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM (52.132.236.76) by
 HK0P153MB0322.APCP153.PROD.OUTLOOK.COM (52.132.237.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.3; Mon, 6 Apr 2020 01:51:35 +0000
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a]) by HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a%2]) with mapi id 15.20.2921.000; Mon, 6 Apr 2020
 01:51:35 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemb@google.com" <willemb@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "sdf@google.com" <sdf@google.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "fw@strlen.de" <fw@strlen.de>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "jeremy@azazel.net" <jeremy@azazel.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 net] skbuff.h: Improve the checksum related comments
Thread-Topic: [PATCH v2 net] skbuff.h: Improve the checksum related comments
Thread-Index: AQHWC7S1P+7SGhlHM0G3BTFuIPba1KhrU+3w
Date:   Mon, 6 Apr 2020 01:51:35 +0000
Message-ID: <HK0P153MB02738B53E62194DE1AF1752ABFC20@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
References: <1586136369-67251-1-git-send-email-decui@microsoft.com>
 <6efee6bb-d68d-0f83-d469-b173cf4f5d0f@infradead.org>
In-Reply-To: <6efee6bb-d68d-0f83-d469-b173cf4f5d0f@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-06T01:51:33.0595972Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ac878895-ae42-4f98-a0e1-fb2722b398b3;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:ac71:2d80:3165:3247]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0f890298-092b-4a5a-8d5d-08d7d9cd0a09
x-ms-traffictypediagnostic: HK0P153MB0322:
x-microsoft-antispam-prvs: <HK0P153MB0322A51918455F74041F8DC2BFC20@HK0P153MB0322.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0365C0E14B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0273.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(55016002)(66556008)(81166006)(81156014)(66946007)(186003)(4744005)(76116006)(4326008)(66476007)(9686003)(10290500003)(71200400001)(53546011)(52536014)(7696005)(6506007)(316002)(82950400001)(82960400001)(8676002)(66446008)(64756008)(5660300002)(478600001)(86362001)(8990500004)(110136005)(33656002)(2906002)(7416002)(8936002)(921003)(1121003);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gONmB0gAMbM6YoaDt4YHizTFrTDR6EtVzFbSqefzOQnP80Es/jJFvhT6wp1ecKrpBVEd2XqtuxLr98B/Hs3i3jiVH6UtjK7P+BbXLhU0DdrHXwSZjJ+67arQLZYRNfq1PHr1nr67VbqEfjhSldHNDZs3Rmxyk5NY6wcXrklmwDoJwxDRHr6vhv9BDMmmByXaWrokdtrWm/qOv1JLdPIRfY0EzbxPIshqn+dYivqVhou/Ff4rr9CmDG9rsGp+ZU5kXlCoaSJeDHhT0gAW/s8pQpWaQr2SnUyBKRpn0pdHD1CubUVWhM3S9XHn7QMIdjyYaHUTrVr1qGISyIok/OBvtdGCs5hB93Ni9t+3vjkacYzVjr7lJq5DT2CSaPW4jXiTNN4smcySyjpx+gsj9pzYMz4M7WBvv09MhOCS2KYRkJnxAgbLrebE3cYr/WFj/xDJDIF14fuVWRUPfU6vAwcLxzO0+zgI6UfSK2ws5zx3uU4RCKMJjnrGOeVAYbDOiNBC
x-ms-exchange-antispam-messagedata: Jz58qllvMmy9GUCyb2WQU0drLnnnWffZx/VeGAxsH2nl5JlhH6dJXcjwiB18cnGiWZ5leFmDOj5OnfJ6SaF1WwsO5o+Du4snt7cG8DB6U4EIjA5Ex4Ke59GTMEYpiE6B/pjw75GEl/hjLjVQlJ1YqLzg4zRpzQknJdGImemgA8Intn2Uh7JiaLiTW+cx7Eo76u0xtr8Eg9cyJPy9jYRHfw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f890298-092b-4a5a-8d5d-08d7d9cd0a09
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2020 01:51:35.1868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: svGmAxD27nt4f0C7APyZgTZhlw5coyzP61qjThl/ufHLi5TSOVe2XwqQP7ncS+IN7Dpd/lkzdIgJo50oIj2baA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0322
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBSYW5keSBEdW5sYXAgPHJkdW5sYXBAaW5mcmFkZWFkLm9yZz4NCj4gU2VudDogU3Vu
ZGF5LCBBcHJpbCA1LCAyMDIwIDY6NDMgUE0NCj4gT24gNC81LzIwIDY6MjYgUE0sIERleHVhbiBD
dWkgd3JvdGU6DQo+ID4gQEAgLTIxMSw5ICsyMTEsOSBAQA0KPiA+ICAgKiBpcyBpbXBsaWVkIGJ5
IHRoZSBTS0JfR1NPXyogZmxhZ3MgaW4gZ3NvX3R5cGUuIE1vc3Qgb2J2aW91c2x5LCBpZiB0aGUN
Cj4gPiAgICogZ3NvX3R5cGUgaXMgU0tCX0dTT19UQ1BWNCBvciBTS0JfR1NPX1RDUFY2LCBUQ1Ag
Y2hlY2tzdW0gb2ZmbG9hZA0KPiBhcw0KPiA+ICAgKiBwYXJ0IG9mIHRoZSBHU08gb3BlcmF0aW9u
IGlzIGltcGxpZWQuIElmIGEgY2hlY2tzdW0gaXMgYmVpbmcgb2ZmbG9hZGVkDQo+ID4gLSAqIHdp
dGggR1NPIHRoZW4gaXBfc3VtbWVkIGlzIENIRUNLU1VNX1BBUlRJQUwsIGNzdW1fc3RhcnQgYW5k
DQo+IGNzdW1fb2Zmc2V0DQo+ID4gLSAqIGFyZSBzZXQgdG8gcmVmZXIgdG8gdGhlIG91dGVybW9z
dCBjaGVja3N1bSBiZWluZyBvZmZsb2FkICh0d28gb2ZmbG9hZGVkDQo+ID4gLSAqIGNoZWNrc3Vt
cyBhcmUgcG9zc2libGUgd2l0aCBVRFAgZW5jYXBzdWxhdGlvbikuDQo+ID4gKyAqIHdpdGggR1NP
IHRoZW4gaXBfc3VtbWVkIGlzIENIRUNLU1VNX1BBUlRJQUwsIGFuZCBib3RoIGNzdW1fc3RhcnQN
Cj4gYW5kDQo+ID4gKyAqIGNzdW1fb2Zmc2V0IGFyZSBzZXQgdG8gcmVmZXIgdG8gdGhlIG91dGVy
bW9zdCBjaGVja3N1bSBiZWluZyBvZmZsb2FkDQo+ICh0d28NCj4gDQo+IA0KPiBiZWluZyBvZmZs
b2FkZWQNCg0KVGhhbmtzIGZvciBzcG90dGluZyB0aGlzISA6LSkNCg0KPiANCj4gUmV2aWV3ZWQt
Ynk6IFJhbmR5IER1bmxhcCA8cmR1bmxhcEBpbmZyYWRlYWQub3JnPg0KPiAtLQ0KPiB+UmFuZHkN
Cg0KV2lsbCBwb3N0IGEgdjMgc2hvcnRseS4NCg0KVGhhbmtzLA0KLS0gRGV4dWFuDQo=
