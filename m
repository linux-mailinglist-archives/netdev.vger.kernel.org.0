Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7B8190E4D
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgCXNE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:04:26 -0400
Received: from mail-eopbgr30073.outbound.protection.outlook.com ([40.107.3.73]:41699
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727289AbgCXNE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:04:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+ZfH8xJv65uhz+i47O+vE5/sGUP1491kGu34bAmceJv1QN5azrt+FFyFk1o48gScK/nVqWBZMSzmQlrsqfB8FXlDxJKCPfPLr4+1mWrpPSar8comeAaMCDgexLfhmdI3zt4wOA3OIoG2wxW4/x/PnyRq6MQRQxUXIW9pLZU1oFPCenaF1QdvcHOYM8FoQ4W1c75MRw0KwrdB0PAqgNV7Yi16ptjCo7vRtoffwWJegHsmFvL3w5ImF4Y8iP33HWuZERGpa2mNTemyvX94Tmn2jj5ym1SAgFFIGX4+7jkxaQyJpGAKb06Tjs9gyCsUZDM7hW9MqggdgXvJRJvdHZP+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKrcy0i9F5RwtAAjWUotXhHyAzkc9iDyi0FIkAQlwyU=;
 b=oCrbGCliKG5Fp7Cj3uuq/uK4M/OEPx4vAcZ+S+pgSxHeGihygkMwGTSevwyt47V/Ztas0RHGgrT40LdEIdYL71cJtX/4RxjaK7mctflb35bra496wosBpy4wrvm1uvhPPVMmeLFWhZ6D0HCuJpfFLVKU7cIukO/Hlim+aQPKPBoD6/dFSXqW8e55JGspXCKRsQ28bqEwy9IpbouCRsLkmT1BHbqjaKPF2yFYViFl35U7ZEmTplAI0jiNQ1o5rJ9CkD8HfcLJut3VNI+PkYE4t4/dibeBxB3kpKMd5tYA5dtD3WUfDR1Wm2p/lvLnKPmrW83o3w9jHUIQ6F6yXYssDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKrcy0i9F5RwtAAjWUotXhHyAzkc9iDyi0FIkAQlwyU=;
 b=Kt/qrTKmPdumuVIfHlniJ47GzJ5lPcp0/1UBMxt+r9IEhqMedqloZLGNN5CtcEX5wqv+RvhUcJGlsLphygATKKyxTR/s4nLG7bGzFOdjgEsuJwWOeE3VJ0K2Fdy1jnUTA7Qjxr8Ed7T7KZkVHcBYg06LQuaea+LjwZyXMa+1+Uk=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6383.eurprd04.prod.outlook.com (20.179.232.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Tue, 24 Mar 2020 13:04:21 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 13:04:21 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: RE: [EXT] Re: [v1,net-next  1/5] net: qos offload add flow status
 with dropped count
Thread-Topic: [EXT] Re: [v1,net-next  1/5] net: qos offload add flow status
 with dropped count
Thread-Index: AQHWAZG6R8W/BcfQWUegQ5Yai2Mrt6hXg1AAgAAm4JA=
Date:   Tue, 24 Mar 2020 13:04:21 +0000
Message-ID: <VE1PR04MB6496CE41A2DDE48DF59BCC1D92F10@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200306125608.11717-11-Po.Liu@nxp.com>
 <20200324034745.30979-1-Po.Liu@nxp.com>
 <20200324034745.30979-2-Po.Liu@nxp.com>
 <20200324100146.GR11304@nanopsycho.orion>
In-Reply-To: <20200324100146.GR11304@nanopsycho.orion>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 68fc4e18-3714-4173-1f33-08d7cff3deb7
x-ms-traffictypediagnostic: VE1PR04MB6383:|VE1PR04MB6383:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6383EE58586196D4746373F192F10@VE1PR04MB6383.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03524FBD26
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(66556008)(81166006)(81156014)(6916009)(8676002)(66446008)(64756008)(44832011)(66946007)(9686003)(52536014)(66476007)(76116006)(71200400001)(55016002)(478600001)(8936002)(33656002)(86362001)(4326008)(2906002)(26005)(316002)(186003)(54906003)(7416002)(7696005)(53546011)(6506007)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6383;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BBf2XN/3LGKKQ9nQ+WTVEojGQxuWi4p/APhstGbiWwxMEjRQSLZR13DSuFNiZ/i1q9N7kfGJqgRvy6GAef8fYR9RgF2/DG82Aeok3XwjSbsI5AKh6Y93c1rx2DIVfS5AwTEz/hMJz3OVwEsBFdNSbzMy7KsCHbU0YYIvyHLwBkdAkUGf4SNA35eMTe8hdjaWzExe0CTq4cYDRiAuxwJmHVjdcQWUNqOB94TIkJRSufP1atoeOkg+cOeB/6g/DHEni90QncDMKyRPg3XvxZsL31L5m3rit/tT5q53PbxHIIpsl7DYQ5r6VK8zQVPHrFn8+WMgYtS+HnlOEsn4YW1DQo0ZvWj1e2zJSyfXUJ7fnMt2cviyviieNSRWEMxnSqMWFIxQjV0jutBzykouTkS7gfCzfstxU5uHrybKXq4v1mYAMGqrX5ES8zqmEuEmxoMk
x-ms-exchange-antispam-messagedata: YBRF4eqaUutq4+/RfuDSFCXqsQ/JtbVZfvSabN+YzA4LRK860SpB8pmcfWLXTJp8LkERthT5Od8xPnfeochz/8WytWNyUUdmaY4gMT3407uhy+T19Jmhas68smXWqUvShg80yfErPvs1m9Cbf7dPqg==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68fc4e18-3714-4173-1f33-08d7cff3deb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2020 13:04:21.4811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8mRN5LDPoK56yw2SApm31ld6/VBPbS/I8ylouLFGLPUPWdOMPLxGGAq7+smC1csC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmlyaSwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKaXJpIFBp
cmtvIDxqaXJpQHJlc251bGxpLnVzPg0KPiBTZW50OiAyMDIwxOoz1MIyNMjVIDE4OjAyDQo+IFRv
OiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgdmlu
aWNpdXMuZ29tZXNAaW50ZWwuY29tOyBDbGF1ZGl1IE1hbm9pbA0KPiA8Y2xhdWRpdS5tYW5vaWxA
bnhwLmNvbT47IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+Ow0KPiBB
bGV4YW5kcnUgTWFyZ2luZWFuIDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+OyBYaWFvbGlh
bmcgWWFuZw0KPiA8eGlhb2xpYW5nLnlhbmdfMUBueHAuY29tPjsgUm95IFphbmcgPHJveS56YW5n
QG54cC5jb20+OyBNaW5na2FpIEh1DQo+IDxtaW5na2FpLmh1QG54cC5jb20+OyBKZXJyeSBIdWFu
ZyA8amVycnkuaHVhbmdAbnhwLmNvbT47IExlbyBMaQ0KPiA8bGVveWFuZy5saUBueHAuY29tPjsg
bWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTsgdmlzaGFsQGNoZWxzaW8uY29tOw0KPiBzYWVlZG1A
bWVsbGFub3guY29tOyBsZW9uQGtlcm5lbC5vcmc7IGppcmlAbWVsbGFub3guY29tOw0KPiBpZG9z
Y2hAbWVsbGFub3guY29tOyBhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbTsNCj4gVU5HTGlu
dXhEcml2ZXJAbWljcm9jaGlwLmNvbTsga3ViYUBrZXJuZWwub3JnOyBqaHNAbW9qYXRhdHUuY29t
Ow0KPiB4aXlvdS53YW5nY29uZ0BnbWFpbC5jb207IHNpbW9uLmhvcm1hbkBuZXRyb25vbWUuY29t
Ow0KPiBwYWJsb0BuZXRmaWx0ZXIub3JnOyBtb3NoZUBtZWxsYW5veC5jb207IG0ta2FyaWNoZXJp
MkB0aS5jb207DQo+IGFuZHJlLmd1ZWRlc0BsaW51eC5pbnRlbC5jb207IHN0ZXBoZW5AbmV0d29y
a3BsdW1iZXIub3JnDQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbdjEsbmV0LW5leHQgMS81XSBuZXQ6
IHFvcyBvZmZsb2FkIGFkZCBmbG93IHN0YXR1cyB3aXRoDQo+IGRyb3BwZWQgY291bnQNCj4gDQo+
IENhdXRpb246IEVYVCBFbWFpbA0KPiANCj4gVHVlLCBNYXIgMjQsIDIwMjAgYXQgMDQ6NDc6MzlB
TSBDRVQsIFBvLkxpdUBueHAuY29tIHdyb3RlOg0KPiA+QWRkIHRoZSBoYXJkd2FyZSB0YyBmbG93
ZXIgb2ZmbG9hZGluZyB3aXRoIGRyb3BwZWQgZnJhbWUgY291bnRlciBmb3INCj4gPnN0YXR1cyB1
cGRhdGUuIGFjdGlvbiBvcHMtPnN0YXRzX3VwZGF0ZSBvbmx5IGxvYWRlZCBieSB0aGUNCj4gPnRj
Zl9leHRzX3N0YXRzX3VwZGF0ZSgpIGFuZCB0Y2ZfZXh0c19zdGF0c191cGRhdGUoKSBvbmx5IGxv
YWRlZCBieQ0KPiA+bWF0Y2hhbGwgYW5kIHRjIGZsb3dlciBoYXJkd2FyZSBmaWx0ZXIuIEJ1dCB0
aGUgc3RhdHNfdXBkYXRlIG9ubHkgc2V0DQo+ID50aGUgZHJvcHBlZCBjb3VudCBhcyBkZWZhdWx0
IGZhbHNlIGluIHRoZSBvcHMtPnN0YXRzX3VwZGF0ZS4gVGhpcyBwYXRjaA0KPiA+YWRkIHRoZSBk
cm9wcGVkIGNvdW50ZXIgdG8gYWN0aW9uIHN0YXRzIHVwZGF0ZS4gSXRzIGRyb3BwZWQgY291bnRl
cg0KPiA+dXBkYXRlIGJ5IHRoZSBoYXJkd2FyZSBvZmZsb2FkaW5nIGRyaXZlci4NCj4gPlRoaXMg
aXMgY2hhbmdlZCBieSByZXBsYWNpbmcgdGhlIGRyb3AgZmxhZyB3aXRoIGRyb3BwZWQgZnJhbWUg
Y291bnRlci4NCj4gDQo+IEkganVzdCByZWFkIHRoaXMgcGFyYWdyYXBoIDMgdGltZXMsIEknbSB1
bmFibGUgdG8gZGVjeXBoZXIgOigNCg0KU29ycnkgdG8gbWFrZSB5b3UgY29uZnVzaW5nLiBJIHdv
dWxkIG1ha2UgYSBjbGVhciBkZXNjcmlwdGlvbi4NCkJlZm9yZSB0aGF0LCBJIGp1c3QgdHJ5IHRv
IGV4cGxhaW4gd2hhdCB0aGUgcGF0Y2ggZG8gaGVyZSBzbyB5b3UgY2FuIHByb3ZpZGUgbW9yZSBz
dWdnZXN0aW9uLg0KDQpUbyBnZXQgdGhlIHN0YXRzIGluIHRoZSB0YyBmbG93ZXIgb2ZmbG9hZGlu
ZyhieSBmbGFnIEZMT1dfQ0xTX1NUQVRTKSwgaXQgc2F2ZXMgaW4gdGhlICdzdHJ1Y3QgZmxvd19z
dGF0cycgaW4gdGhlICcgc3RydWN0IGZsb3dfY2xzX29mZmxvYWQgJy4gQnV0IHRoZSAnIHN0cnVj
dCBmbG93X3N0YXRzICcgb25seSBpbmNsdWRlIHRoZSBwYWNrYWdlcyBudW1iZXJzLiBTb21lIGFj
dGlvbnMgbGlrZSBwb2xpY2luZyBhbHNvIHRoaXMgMDAwMi8wMDAzIHBhdGNoIGludHJvZHVjZSBz
dHJlYW0gZ2F0ZSBhY3Rpb24gd291bGQgcHJvZHVjZSBkcm9wcGVkIGZyYW1lcyB3aGljaCBpcyBp
bXBvcnRhbnQgZm9yIHVzZXIgZXZhbHVhdGlvbi4gVGhlIHBhY2thZ2VzIG51bWJlcihwa3RzIGlu
IHN0cnVjdCBmbG93X3N0YXRzKSBhbmQgZHJvcHBlZCBudW1iZXIgcmVsYXRpb24gc2hvdWxkIGJl
ICdwa3RzJyBpcyBob3cgbWFueSBmcmFtZXMgd2VyZSBmaWx0ZXJlZCwgYW5kICdkcm9wcGVkJyBu
dW1iZXIgaXMgaG93IG1hbnkgZnJhbWVzIGRyb3BwZWQgaW4gdGhvc2UgJ3BrdHMnLg0KRXZlbnR1
YWxseSwgdGhlIHN0YXRzIHVwZGF0ZWQgYnkgdGhlIHN0cnVjdCB0Y19hY3Rpb24gJ3Mgb3BlcmF0
aW9uIHN0YXRzX3VwZGF0ZSgpLiBUbyBpbXBsZW1lbnQgYWRkIGRyb3BwZWQgbnVtYmVyLCB0aGVu
IGFkZCBwYXJhbWV0ZXIgJ2Ryb3BwZWQnIGluIHRoZSByZWxhdGVkIGZ1bmN0aW9uczogb3BzLT5z
dGF0c191cGRhdGUvdGNmX2V4dHNfc3RhdHNfdXBkYXRlKCkgYW5kIGFsc28gdGhlIHRjZl9hY3Rp
b25fdXBkYXRlX3N0YXRzKCkuIFRoZXJlIGlzIGEgYm9vbCBwYXJhbWV0ZXIgJ2Ryb3AnIHdoaWNo
IGlzIHVzaW5nIG5vdywgY2FuIGJlIHVuZGVyc3RhbmQgdGhlIHN0YXRzIHVwZGF0aW5nIGlzIGZv
ciB1cGRhdGUgZm9yICdkcm9wJyBjb3VudCBvciBub3QuIEJ1dCB0aGlzIGZsYWcgaXMgbm90IHVz
ZWxlc3MgYXMgSSBjaGVja2VkIGluIGN1cnJlbnQga2VybmVsIGNvZGUoY29ycmVjdCBtZSBpZiBp
dCBpcyBub3QpLiBTbyByZXBsYWNlIHRoZSBib29sICdkcm9wJyBmbGFnIHdpdGggJ2Ryb3BwZWQn
IG51bWJlciBpbiB0Y2ZfYWN0aW9uX3VwZGF0ZV9zdGF0cygpLiBNYWtlIHRoZSB0Y2ZfYWN0aW9u
X3VwZGF0ZV9zdGF0cygpIHNob3dzIGhvdyBtYW55ICcgcGFja2V0cycgdXBkYXRlZCBhbmQgaG93
IG1hbnkgJ2Ryb3BwZWQnIG51bWJlciBpbiB0aGVzZSAncGFja2V0cycuDQpUaGFua3MhDQoNCj4g
DQo+IA0KPiANCj4gPg0KPiA+RHJpdmVyIHNpZGUgc2hvdWxkIHVwZGF0ZSBob3cgbWFueSAicGFj
a2V0cyIgaXQgZmlsdGVyZWQgYW5kIGhvdyBtYW55DQo+ID4iZHJvcHBlZCIgaW4gdGhvc2UgInBh
Y2tldHMiLg0KPiA+DQo+IA0KPiBbLi4uXQ0KPiANCj4gDQo+ID4gICAgICAgcmV0dXJuIGFjdGlv
bjsNCj4gPiB9DQo+ID4NCj4gPi1zdGF0aWMgdm9pZCB0Y2ZfZ2FjdF9zdGF0c191cGRhdGUoc3Ry
dWN0IHRjX2FjdGlvbiAqYSwgdTY0IGJ5dGVzLCB1MzINCj4gcGFja2V0cywNCj4gPi0gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHU2NCBsYXN0dXNlLCBib29sIGh3KQ0KPiA+K3N0YXRp
YyB2b2lkIHRjZl9nYWN0X3N0YXRzX3VwZGF0ZShzdHJ1Y3QgdGNfYWN0aW9uICphLCB1NjQgYnl0
ZXMsIHU2NA0KPiBwYWNrZXRzLA0KPiA+KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
dTY0IGxhc3R1c2UsIHU2NCBkcm9wcGVkLCBib29sIGh3KQ0KPiA+IHsNCj4gPiAgICAgICBzdHJ1
Y3QgdGNmX2dhY3QgKmdhY3QgPSB0b19nYWN0KGEpOw0KPiA+ICAgICAgIGludCBhY3Rpb24gPSBS
RUFEX09OQ0UoZ2FjdC0+dGNmX2FjdGlvbik7DQo+ID4gICAgICAgc3RydWN0IHRjZl90ICp0bSA9
ICZnYWN0LT50Y2ZfdG07DQo+ID4NCj4gPi0gICAgICB0Y2ZfYWN0aW9uX3VwZGF0ZV9zdGF0cyhh
LCBieXRlcywgcGFja2V0cywgYWN0aW9uID09IFRDX0FDVF9TSE9ULA0KPiBodyk7DQo+ID4rICAg
ICAgdGNmX2FjdGlvbl91cGRhdGVfc3RhdHMoYSwgYnl0ZXMsIHBhY2tldHMsDQo+ID4rICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKGFjdGlvbiA9PSBUQ19BQ1RfU0hPVCkgPyBwYWNrZXRz
IDogMCwNCj4gPisgaHcpOw0KPiANCj4gQXZvaWQgKClzIGhlcmUuDQoNCk9rLg0KDQo+IA0KPiAN
Cj4gPiAgICAgICB0bS0+bGFzdHVzZSA9IG1heF90KHU2NCwgdG0tPmxhc3R1c2UsIGxhc3R1c2Up
OyB9DQo+ID4NCg0KDQpCciwNClBvIExpdQ0KDQo=
