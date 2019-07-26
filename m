Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31CD47733C
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfGZVKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:10:34 -0400
Received: from mail-eopbgr40046.outbound.protection.outlook.com ([40.107.4.46]:55128
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726102AbfGZVKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 17:10:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NapvX+xnF9NJKLVrpfS8b2vsan2cgkNJ9eiAtFEmjDPpSMjt13Ipa+nRSCYJWn5spXUObRUPxoSVm+QxOkIaUVbZgSUBbv54a7pZZ3XdM/+5Qs6R4810SfoMnlRTEAi4OFNkPWsRFswZrdV7BHXhzSXEs/yX9CTdqXn2m+AHNWAMbuUVDKMDJbyR8DuK5hlAaXLeR4MIEQMHV5idR4oypVSMsofELdTCx9Y5zp6L2X3hEPzf/DutcOFXiYLYlvrtsPOG2fM+I125VtBx3frQGJ04Oa6fXJ3wP9xjCzNq0Gv2FuRW1/PtemrD9oXOEIgoy0FKjYT4a0MEkp+zRxQFIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ME8fXwO0N5+j6RHGwOcLeAvL/r1FlSA15m2CCp8Nm/U=;
 b=FysD2RngZYzjhVl4elx15ZrT6dmf8GZPkf0NZxGPmIosDkTCGIPOP4q4Q5zmJjyUc0v15MXQOB+rCY0Gss7CD01pQgPgRbQIp+p7aaSER9BnAxHAEmdKdkX4t00BYsNtatccylu607N/YRwpZCCE7GUtPg47e55aZmsiZrf6YLT2L4SOCMVT8TQt7bAKGxLq3BYWoWy+SnagUluogPLXnxNAmWzTfvR7x9VeQIiLDr24wJ0cP8FY7GxFu5eLzwk1reXDzJyvdCT6dO3BHvpRiV6FBNpm4Yl7XD46xStwakGFJYamBtlYqbvzIXj8s76gpHl9YY+q8iEOadOqjhvp5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ME8fXwO0N5+j6RHGwOcLeAvL/r1FlSA15m2CCp8Nm/U=;
 b=s2u4Uiiv8DYKz/vTPZ9b+krGmu8opoZQWc0RJ1DFqyd1xdUk5iwAmcBMJIY5oRyaa0asr/RZMHIxdbHkKHdPXH/8rxdkQ3icCwXWu7JxusB609RpbcfJIfxFsJhLEMrkXIy0EzDDVQeU4C0TWjenR4ktQXWxc5YrNfPuLDauezU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2198.eurprd05.prod.outlook.com (10.168.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Fri, 26 Jul 2019 21:10:29 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 21:10:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [PATCH net-next 2/2] mlx4/en_netdev: call notifiers when
 hw_enc_features change
Thread-Topic: [PATCH net-next 2/2] mlx4/en_netdev: call notifiers when
 hw_enc_features change
Thread-Index: AQHVQiiqTJlSndEpEUiixXCmHX0hZabaPY6AgAEGJICAAJdegIAA3U4AgACwaYA=
Date:   Fri, 26 Jul 2019 21:10:29 +0000
Message-ID: <a15230a7146b1f30b4d0ebe976cd561ff3081739.camel@mellanox.com>
References: <cover.1563976690.git.dcaratti@redhat.com>
         <e157af6e79d9385df37444d817cf3c166878c8f6.1563976690.git.dcaratti@redhat.com>
         <e007bac4c951486294d4e69d20f7c9ed7040172d.camel@mellanox.com>
         <73cd7a2a29db5a32d669273d367566cdf6652f4e.camel@redhat.com>
         <f9ca12ff3880f94d4576ab4e4239f072ed611293.camel@mellanox.com>
         <7ec40c37b843ebd3fd2ff5998bb382e13e45d816.camel@redhat.com>
In-Reply-To: <7ec40c37b843ebd3fd2ff5998bb382e13e45d816.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88e84205-03d1-484c-adf9-08d7120db031
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2198;
x-ms-traffictypediagnostic: DB6PR0501MB2198:
x-microsoft-antispam-prvs: <DB6PR0501MB2198C2156CF73CB241EC2DF7BEC00@DB6PR0501MB2198.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(346002)(39860400002)(136003)(189003)(43544003)(199004)(486006)(36756003)(256004)(76176011)(118296001)(2501003)(4326008)(561944003)(2906002)(102836004)(6116002)(66066001)(107886003)(81166006)(3846002)(25786009)(6486002)(5660300002)(316002)(53936002)(11346002)(7736002)(76116006)(99286004)(64756008)(8936002)(66556008)(446003)(6512007)(6246003)(81156014)(66946007)(476003)(186003)(71190400001)(478600001)(14444005)(6436002)(71200400001)(91956017)(305945005)(26005)(14454004)(6506007)(86362001)(229853002)(68736007)(58126008)(8676002)(110136005)(2616005)(66446008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2198;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BriLg80OQDZB3nwmWNWRY0PoJtbtZUKpc4r2gnzsEQfLB3wwvnXKJSQ/LRUHm+4BjCdowu+UTJ5/5cceaD7JlCl3Hc2WefD3CIfbRmER7eZCUkW/zEdsmHXRXRbufOrpZwYUqElLKl1wIaCL0y8XI4Os/r4vWhR5+fBP5youcACAlyHovMEWxH040X2Ru2a248L4KbMCff8YjcNSZYH+sw3eFx1nWW4fffHDSGt6DeDFSwDbAzIcgzYxRryjc7Y7pcAstndrk5MqIFqgfpaM1nTg4NyZNYIHOt4vag8N608rDkYOoD5Mv0v0KFa21HTGPmTqiBAz+lSJRcb3W382v1r32sv7y3uYgQxJeDsLdP6TZKvL1oi8b/bDCrVzjEkAHBlQmnwzzoNCzeIX05VahcNeIkpHIPbDuRvUYPYPb8s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B24E75F37ED19442BE1EFB04E341BF1E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e84205-03d1-484c-adf9-08d7120db031
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 21:10:29.4465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA3LTI2IGF0IDEyOjM5ICswMjAwLCBEYXZpZGUgQ2FyYXR0aSB3cm90ZToN
Cj4gT24gVGh1LCAyMDE5LTA3LTI1IGF0IDIxOjI3ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBPbiBUaHUsIDIwMTktMDctMjUgYXQgMTQ6MjUgKzAyMDAsIERhdmlkZSBDYXJhdHRp
IHdyb3RlOg0KPiA+ID4gT24gV2VkLCAyMDE5LTA3LTI0IGF0IDIwOjQ3ICswMDAwLCBTYWVlZCBN
YWhhbWVlZCB3cm90ZToNCj4gPiA+ID4gT24gV2VkLCAyMDE5LTA3LTI0IGF0IDE2OjAyICswMjAw
LCBEYXZpZGUgQ2FyYXR0aSB3cm90ZToNCj4gPiA+ID4gPiBlbnN1cmUgdG8gY2FsbCBuZXRkZXZf
ZmVhdHVyZXNfY2hhbmdlKCkgd2hlbiB0aGUgZHJpdmVyIGZsaXBzDQo+ID4gPiA+ID4gaXRzDQo+
ID4gPiA+ID4gaHdfZW5jX2ZlYXR1cmVzIGJpdHMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gU2ln
bmVkLW9mZi1ieTogRGF2aWRlIENhcmF0dGkgPGRjYXJhdHRpQHJlZGhhdC5jb20+DQo+ID4gPiA+
IA0KPiA+ID4gPiBUaGUgcGF0Y2ggaXMgY29ycmVjdCwgDQo+ID4gPiANCj4gPiA+IGhlbGxvIFNh
ZWVkLCBhbmQgdGhhbmtzIGZvciBsb29raW5nIGF0IHRoaXMhDQo+ID4gPiANCj4gPiA+ID4gYnV0
IGNhbiB5b3UgZXhwbGFpbiBob3cgZGlkIHlvdSBjb21lIHRvIHRoaXMgPyANCj4gPiA+ID4gZGlk
IHlvdSBlbmNvdW50ZXIgYW55IGlzc3VlIHdpdGggdGhlIGN1cnJlbnQgY29kZSA/DQo+ID4gPiA+
IA0KPiA+ID4gPiBJIGFtIGFza2luZyBqdXN0IGJlY2F1c2UgaSB0aGluayB0aGUgd2hvbGUgZHlu
YW1pYyBjaGFuZ2luZyBvZg0KPiA+ID4gPiBkZXYtDQo+ID4gPiA+ID4gaHdfZW5jX2ZlYXR1cmVz
IGlzIHJlZHVuZGFudCBzaW5jZSBtbHg0IGhhcyB0aGUNCj4gPiA+ID4gPiBmZWF0dXRyZXNfY2hl
Y2sNCj4gPiA+ID4gY2FsbGJhY2suDQo+ID4gPiANCj4gPiA+IHdlIG5lZWQgaXQgdG8gZW5zdXJl
IHRoYXQgdmxhbl90cmFuc2Zlcl9mZWF0dXJlcygpIHVwZGF0ZXMNCj4gPiA+IHRoZSAobmV3KSB2
YWx1ZSBvZiBod19lbmNfZmVhdHVyZXMgaW4gdGhlIG92ZXJseWluZyB2bGFuOg0KPiA+ID4gb3Ro
ZXJ3aXNlLA0KPiA+ID4gc2VnbWVudGF0aW9uIHdpbGwgaGFwcGVuIGFueXdheSB3aGVuIHNrYiBw
YXNzZXMgZnJvbSB2eGxhbiB0bw0KPiA+ID4gdmxhbiwNCj4gPiA+IGlmIHRoZQ0KPiA+ID4gdnhs
YW4gaXMgYWRkZWQgYWZ0ZXIgdGhlIHZsYW4gZGV2aWNlIGhhcyBiZWVuIGNyZWF0ZWQgKHNlZToN
Cj4gPiA+IDdkYWQ5OTM3ZTA2NA0KPiA+ID4gKCJuZXQ6IHZsYW46IGFkZCBzdXBwb3J0IGZvciB0
dW5uZWwgb2ZmbG9hZCIpICkuDQo+ID4gPiANCj4gPiANCj4gPiBidXQgaW4gcHJldmlvdXMgcGF0
Y2ggeW91IG1hZGUgc3VyZSB0aGF0IHRoZSB2bGFuIGFsd2F5cyBzZWVzIHRoZQ0KPiA+IGNvcnJl
Y3QgaHdfZW5jX2ZlYXR1cmVzIG9uIGRyaXZlciBsb2FkLCB3ZSBkb24ndCBuZWVkIHRvIGhhdmUg
dGhpcw0KPiA+IGR5bmFtaWMgdXBkYXRlIG1lY2hhbmlzbSwNCj4gDQo+IG9rLCBidXQgdGhlIG1s
eDQgZHJpdmVyIGZsaXBzIHRoZSB2YWx1ZSBvZiBod19lbmNfZmVhdHVyZXMgd2hlbiBWWExBTg0K
PiB0dW5uZWxzIGFyZSBhZGRlZCBvciByZW1vdmVkLiBTbywgYXNzdW1lIGV0aDAgaXMgYSBDeDMt
cHJvLCBhbmQgSSBkbzoNCj4gIA0KPiAgIyBpcCBsaW5rIGFkZCBuYW1lIHZsYW41IGxpbmsgZXRo
MCB0eXBlIHZsYW4gaWQgNQ0KPiAgIyBpcCBsaW5rIGFkZCBkZXYgdnhsYW42IHR5cGUgdnhsYW4g
aWQgNiAgWy4uLl0gIGRldiB2bGFuNQ0KPiAgDQo+IHRoZSB2YWx1ZSBvZiBkZXYtPmh3X2VuY19m
ZWF0dXJlcyBpcyAwIGZvciB2bGFuNSwgYW5kIGFzIGENCj4gY29uc2VxdWVuY2UNCj4gVlhMQU4g
b3ZlciBWTEFOIHRyYWZmaWMgYmVjb21lcyBzZWdtZW50ZWQgYnkgdGhlIFZMQU4sIGV2ZW4gaWYg
ZXRoMCwNCj4gYXQNCj4gdGhlIGVuZCBvZiB0aGlzIHNlcXVlbmNlLCBoYXMgdGhlICJyaWdodCIg
ZmVhdHVyZXMgYml0cy4NCj4gDQoNCnlvdXIgcGF0Y2ggaGFuZGxlZCB0aGlzIGlzc3VlIGFscmVh
ZHksIG5vIG5lZWQgZm9yIGZsaXBwaW5nIGFuZA0KdXBkYXRpbmcgZmVhdHVyZXMgaWYgZmVhdHVy
ZXMgY2hlY2sgbmRvIHdpbGwgY292ZXIgdGhlIGNhc2VzIHdlIGRvbid0DQpzdXBwb3J0Lg0KDQo+
ID4gZmVhdHVyZXNfY2hlY2sgbmRvIHNob3VsZCB0YWtlIGNhcmUgb2YNCj4gPiBwcm90b2NvbHMg
d2UgZG9uJ3Qgc3VwcG9ydC4NCj4gDQo+IEkganVzdCBoYWQgYSBsb29rIGF0IG1seDRfZW5fZmVh
dHVyZXNfY2hlY2soKSwgSSBzZWUgaXQgY2hlY2tzIGlmIHRoZQ0KPiBwYWNrZXQgaXMgdHVubmVs
ZWQgaW4gVlhMQU4gYW5kIHRoZSBkZXN0aW5hdGlvbiBwb3J0IG1hdGNoZXMgdGhlDQo+IGNvbmZp
Z3VyZWQgdmFsdWUgb2YgcHJpdi0+dnhsYW5fcG9ydCAod2hlbiB0aGF0IHZhbHVlIGlzIG5vdCB6
ZXJvKS4NCj4gTm93Og0KPiANCj4gT24gV2VkLCAyMDE5LTA3LTI0IGF0IDIwOjQ3ICswMDAwLCBT
YWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiBJIGFtIGFza2luZyBqdXN0IGJlY2F1c2UgaSB0aGlu
ayB0aGUgd2hvbGUgZHluYW1pYyBjaGFuZ2luZyBvZiANCj4gPiBkZXYtPiBod19lbmNfZmVhdHVy
ZXMgaXMgcmVkdW5kYW50IHNpbmNlIG1seDQgaGFzIHRoZQ0KPiA+IGZlYXR1dHJlc19jaGVjaw0K
PiA+IGNhbGxiYWNrLg0KPiANCj4gSSByZWFkIHlvdXIgaW5pdGlhbCBwcm9wb3NhbCBhZ2Fpbi4g
V291bGQgaXQgYmUgY29ycmVjdCBpZiBJIGp1c3QgdXNlDQo+IHBhdGNoIDEvMiwgd2hlcmUgSSBh
ZGQgYW4gYXNzaWdubWVudCBvZg0KPiANCj4gZGV2LT5od19lbmNfZmVhdHVyZXMgPSBORVRJRl9G
X0lQX0NTVU0gfCBORVRJRl9GX0lQVjZfQ1NVTSB8IFwNCj4gICAgICAgICAgICAgICAgICAgICAg
ICBORVRJRl9GX1JYQ1NVTSB8IFwNCj4gICAgICAgICAgICAgICAgICAgICAgICBORVRJRl9GX1RT
TyB8IE5FVElGX0ZfVFNPNiB8IFwNCj4gICAgICAgICAgICAgICAgICAgICAgICBORVRJRl9GX0dT
T19VRFBfVFVOTkVMIHwgXA0KPiAgICAgICAgICAgICAgICAgICAgICAgIE5FVElGX0ZfR1NPX1VE
UF9UVU5ORUxfQ1NVTSB8IFwNCj4gICAgICAgICAgICAgICAgICAgICAgICBORVRJRl9GX0dTT19Q
QVJUSUFMOw0KPiANCj4gaW4gbWx4NF9lbl9pbml0X25ldGRldigpLCBhbmQgdGhlbiByZW1vdmUg
dGhlIGNvZGUgdGhhdCBmbGlwcw0KPiBkZXYtPmh3X2VuY19mZWF0dXJlcyBpbiBtbHg0X2VuX2Fk
ZF92eGxhbl9vZmZsb2FkcygpIGFuZA0KPiBtbHg0X2VuX2RlbF92eGxhbl9vZmZsb2FkcygpID8N
Cj4gDQoNCnllcywgdGhpcyBpcyBleGFjdGx5IHdoYXQgSSBtZWFudC4NCg0KVGhhbmtzLA0KU2Fl
ZWQuDQo=
