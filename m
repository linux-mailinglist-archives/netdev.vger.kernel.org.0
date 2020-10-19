Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236C8292AC0
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbgJSPqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:46:46 -0400
Received: from mail-eopbgr130091.outbound.protection.outlook.com ([40.107.13.91]:47623
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730098AbgJSPqq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 11:46:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwUe/LvsV9mDPLNt34t+kT94tAsdCYt1GkW07d92IvZWErj3kFoPE//smZ2jh0KcdXf2c9vSI4M0GpC1Xcv0EcmIzgAFopLV15TkdbqPWX35euUQHneHt07qnawscgDqh000G0EmbUjXXop7vjTfM2R9lmmx1XZdmTrPRdKxJ4d++/PSxK7hFvlWZ96lQhp6BOe+got6e+L2i7TfM5pfNZ+ITjDh3KYbzuJGyVj+Nr1LwituoBObfVL3Jazxz/rhcX8vGpQmViYDT6FnriVwpI+4dd8+CdrOWr69O44Er4x2f91FMyF/0a5C4x6wHxJHsBS7APNcD5e4SJvB91eSsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11QoMLtP5ZVPmzkj+dO+Grkiz+LMBjXZQDjuYDREKJQ=;
 b=MWTBtLsb+xlugoGWpbBCgcVEhE6ea5gMGYBQN1MdQg6iPVAuTg9XYSMttSIXPKgOAYc2bHjc7GsLRePYWZpttBTGhcv2AMpkNwCYdxPyHiPDPcxePyaa2fYYckeQjBOP0PUHfPENjxqeE878HdJQE4rmL0O0SLLu1R/v72ZtLdLEvzvQjXI09DxvMyh8xGNA7HAOPtpLiwc9fP0ozaPzXH3gVSG9ze/G8Mew3p7OdrXbEw7T7dxGkw2s+4LFJk2sJJEClugTbW/zOnNgNwVopYxNTiGsPoLM8vV1yN66/ia2uZfQUgJDjNuxLENjx3OFh1zXMQoOVYZA09iqXV/cog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prodrive-technologies.com; dmarc=pass action=none
 header.from=prodrive-technologies.com; dkim=pass
 header.d=prodrive-technologies.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=prodrive-technologies.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11QoMLtP5ZVPmzkj+dO+Grkiz+LMBjXZQDjuYDREKJQ=;
 b=mTMYlVeAaqMshBP0XdU2yw+BD4qypohV3CMR8/DVo8i1OgNKy+EvteywEojamo8R2q7M9ZQ9FE9iT3NIGjGfxkuNIWS7VLvcpEXvml7OcGMLFK+kMBwafTAXuEqQh0w9QOBqUyxY/Tl1HqRLyz3HgFOTGitB6Fqtc2zvXxzktfI=
Received: from AM0PR02MB3716.eurprd02.prod.outlook.com (2603:10a6:208:40::21)
 by AM4PR0202MB2771.eurprd02.prod.outlook.com (2603:10a6:200:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Mon, 19 Oct
 2020 15:46:40 +0000
Received: from AM0PR02MB3716.eurprd02.prod.outlook.com
 ([fe80::f108:787f:22cd:6f74]) by AM0PR02MB3716.eurprd02.prod.outlook.com
 ([fe80::f108:787f:22cd:6f74%5]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 15:46:40 +0000
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
To:     "J. Bruce Fields" <bfields@fieldses.org>
CC:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, NeilBrown <neilb@suse.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>,
        "open list:NFS, SUNRPC, AND LOCKD CLIENTS" 
        <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: fix copying of multiple pages in
 gss_read_proxy_verf()
Thread-Topic: [PATCH] SUNRPC: fix copying of multiple pages in
 gss_read_proxy_verf()
Thread-Index: AQHWpgz5jo9GE3xLcU6eFbSXAImdyqmfC1yAgAAGm4A=
Date:   Mon, 19 Oct 2020 15:46:39 +0000
Message-ID: <834dc52b-34fc-fee5-0274-fdc8932040e6@prodrive-technologies.com>
References: <20201019114229.52973-1-martijn.de.gouw@prodrive-technologies.com>
 <20201019152301.GC32403@fieldses.org>
In-Reply-To: <20201019152301.GC32403@fieldses.org>
Accept-Language: en-NL, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
authentication-results: fieldses.org; dkim=none (message not signed)
 header.d=none;fieldses.org; dmarc=none action=none
 header.from=prodrive-technologies.com;
x-originating-ip: [84.27.64.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb4e52eb-89e1-4cd3-e612-08d874462b92
x-ms-traffictypediagnostic: AM4PR0202MB2771:
x-microsoft-antispam-prvs: <AM4PR0202MB277110FB7BD2F3560A50ED48F51E0@AM4PR0202MB2771.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U5ulRiNnYdNt6bVxUWxjo9+oRraKunm9wV+HY22mD64CPuF4kUe2YtIAg4rA7DKV++WWnsD3lSO4Img5rTmFf48OSY6n1gY4iTEU7ArR+MFQz48GXwa2DS4IkFh5T9cKOWvTi4JmA34+jomfLV23+6qUy4OK9J1mdHYRaaek6rXGAKti5OaILEfhNQJkWXMbZrSz16E0DvnrhcEA+JaH1uMEGeKqGZNRs5puPvUimv+Ork3KITMHsM7C/ndjH3+dFxqhkR4oBcLsFJUBEzgFxlG8z6PoeClqy/pDXpCsoMk00asj0rJ4CYM1nA4D4lsg6aNMCPBkVl3WV+JmjYPE7twI1pRJkFPslfIYqWJRhr/QcYJGpS23UY4EqvNDZxdr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB3716.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39850400004)(396003)(346002)(136003)(6916009)(6486002)(86362001)(71200400001)(2616005)(5660300002)(7416002)(316002)(186003)(26005)(83380400001)(2906002)(6506007)(36756003)(54906003)(4326008)(53546011)(478600001)(66556008)(64756008)(66446008)(66476007)(6512007)(31696002)(66946007)(31686004)(8676002)(76116006)(8936002)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mylps8OQbGJ6r3BLs5khWBXn0JCdbBJkDCbKQNXMeEcKVcQelKCeRHpgn3N0kk6dstR61yu77La85eMNI3tKaOsNPsaihxAUp4JhG91kLTCr5wiTX2kHs/fC28186dvQXkwwsVrtb5tiuiuzTIjBWBxfT42AHDrO4We9E5ZLuTITwWM5YUe0N4E3v90T9UeElfoLiEuTS6YAo/BrGjSuJ6zd+6BX2INd23IuVbUWvo6Etsk5PtxTNIEfhf/vwVR4vdZ76f0+7lJujLSXellMoiXCRaGkYPN1waWiFm8Kon4gjoUurLNoSbNdSLUj3krdPhh5f2k1sGcvjxUftJTO6NzlNz7znVGtI49VrxARp3w2iFAsBPDLv3lbl/r2IKZv+VLb0A/K+ixLSf91sNe8im1fWvsKqks4QocnznQ17JxBMeKcHYbsEeM3SM+z8Qpnv2nz8V0i3Bxcdv47uDOgVOsAdrYJqG4Dje3d9zE7B4GJG7ovW3DpeK9yV8XxBw4WlwoTxiCVC1zQEKFVIJTw7wWbVTgCn8lPBpg3YjpvtJwKXmLYBxfaI8qaNGWy3Nii5GSybc1M7KeSrgwkbFwvUuygJpZ7n+RmhI0BrXSEcdg19kv0IT1YhvoXHctxJJnrJpHQP30xRzcqOMVSEGNFRg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <03FA26CE48753946ABF8EF88CC0E840C@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prodrive-technologies.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB3716.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb4e52eb-89e1-4cd3-e612-08d874462b92
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 15:46:39.9286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 612607c9-5af7-4e7f-8976-faf1ae77be60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +YjNyw8L1b1b4snNOcG7I4EX7P+eBdrobt6OTCAgLj4/0qZjZzo+6HATthiTpiceWo494BedotyTSlwPI4Tcbr+BtjAEYR13m6M5DAwU4ngKgC+O9GtRvFjc/cw1NNhUhuF5FlMrJ59Yjp7JfXl1sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0202MB2771
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkNCg0KT24gMTktMTAtMjAyMCAxNzoyMywgSi4gQnJ1Y2UgRmllbGRzIHdyb3RlOg0KPiBPbiBN
b24sIE9jdCAxOSwgMjAyMCBhdCAwMTo0MjoyN1BNICswMjAwLCBNYXJ0aWpuIGRlIEdvdXcgd3Jv
dGU6DQo+PiBXaGVuIHRoZSBwYXNzZWQgdG9rZW4gaXMgbG9uZ2VyIHRoYW4gNDAzMiBieXRlcywg
dGhlIHJlbWFpbmluZyBwYXJ0DQo+PiBvZiB0aGUgdG9rZW4gbXVzdCBiZSBjb3BpZWQgZnJvbSB0
aGUgcnFzdHAtPnJxX2FyZy5wYWdlcy4gQnV0IHRoZQ0KPj4gY29weSBtdXN0IG1ha2Ugc3VyZSBp
dCBoYXBwZW5zIGluIGEgY29uc2VjdXRpdmUgd2F5Lg0KPiANCj4gVGhhbmtzLiAgQXBvbG9naWVz
LCBidXQgSSBkb24ndCBpbW1lZGlhdGVseSBzZWUgd2hlcmUgdGhlIGNvcHkgaXMNCj4gbm9uLWNv
bnNlY3V0aXZlLiAgV2hhdCBleGFjdGx5IGlzIHRoZSBidWcgaW4gdGhlIGV4aXN0aW5nIGNvZGU/
DQoNCkluIHRoZSBmaXJzdCBtZW1jcHkgJ2xlbmd0aCcgYnl0ZXMgYXJlIGNvcGllZCBmcm9tIGFy
Z3YtPmlvYmFzZSwgYnV0IA0Kc2luY2UgdGhlIGhlYWRlciBpcyBpbiBmcm9udCwgdGhpcyBuZXZl
ciBmaWxscyB0aGUgd2hvbGUgZmlyc3QgcGFnZSBvZiANCmluX3Rva2VuLT5wYWdlcy4NCg0KVGhl
IG1lbWNweSBpbiB0aGUgbG9vcCBjb3BpZXMgdGhlIGZvbGxvd2luZyBieXRlcywgYnV0IHN0YXJ0
cyB3cml0aW5nIGF0IA0KdGhlIG5leHQgcGFnZSBvZiBpbl90b2tlbi0+cGFnZXMuIFRoaXMgbGVh
dmVzIHRoZSBsYXN0IGJ5dGVzIG9mIHBhZ2UgMCANCnVud3JpdHRlbi4NCg0KTmV4dCB0byB0aGF0
LCB0aGUgcmVtYWluaW5nIGRhdGEgaXMgaW4gcGFnZSAwIG9mIHJxc3RwLT5ycV9hcmcucGFnZXMs
IA0Kbm90IHBhZ2UgMS4NCg0KUmVnYXJkcywgTWFydGlqbg0KDQo+IA0KPiAtLWIuDQo+IA0KPj4N
Cj4+IFNpZ25lZC1vZmYtYnk6IE1hcnRpam4gZGUgR291dyA8bWFydGlqbi5kZS5nb3V3QHByb2Ry
aXZlLXRlY2hub2xvZ2llcy5jb20+DQo+PiAtLS0NCj4+ICAgbmV0L3N1bnJwYy9hdXRoX2dzcy9z
dmNhdXRoX2dzcy5jIHwgMjcgKysrKysrKysrKysrKysrKystLS0tLS0tLS0tDQo+PiAgIDEgZmls
ZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZm
IC0tZ2l0IGEvbmV0L3N1bnJwYy9hdXRoX2dzcy9zdmNhdXRoX2dzcy5jIGIvbmV0L3N1bnJwYy9h
dXRoX2dzcy9zdmNhdXRoX2dzcy5jDQo+PiBpbmRleCAyNThiMDQzNzJmODUuLmJkNDY3OGRiOWQ3
NiAxMDA2NDQNCj4+IC0tLSBhL25ldC9zdW5ycGMvYXV0aF9nc3Mvc3ZjYXV0aF9nc3MuYw0KPj4g
KysrIGIvbmV0L3N1bnJwYy9hdXRoX2dzcy9zdmNhdXRoX2dzcy5jDQo+PiBAQCAtMTE0Nyw5ICsx
MTQ3LDkgQEAgc3RhdGljIGludCBnc3NfcmVhZF9wcm94eV92ZXJmKHN0cnVjdCBzdmNfcnFzdCAq
cnFzdHAsDQo+PiAgIAkJCSAgICAgICBzdHJ1Y3QgZ3NzcF9pbl90b2tlbiAqaW5fdG9rZW4pDQo+
PiAgIHsNCj4+ICAgCXN0cnVjdCBrdmVjICphcmd2ID0gJnJxc3RwLT5ycV9hcmcuaGVhZFswXTsN
Cj4+IC0JdW5zaWduZWQgaW50IHBhZ2VfYmFzZSwgbGVuZ3RoOw0KPj4gLQlpbnQgcGFnZXMsIGks
IHJlczsNCj4+IC0Jc2l6ZV90IGlubGVuOw0KPj4gKwl1bnNpZ25lZCBpbnQgbGVuZ3RoLCBwZ3Rv
X29mZnMsIHBnZnJvbV9vZmZzOw0KPj4gKwlpbnQgcGFnZXMsIGksIHJlcywgcGd0bywgcGdmcm9t
Ow0KPj4gKwlzaXplX3QgaW5sZW4sIHRvX29mZnMsIGZyb21fb2ZmczsNCj4+ICAgDQo+PiAgIAly
ZXMgPSBnc3NfcmVhZF9jb21tb25fdmVyZihnYywgYXJndiwgYXV0aHAsIGluX2hhbmRsZSk7DQo+
PiAgIAlpZiAocmVzKQ0KPj4gQEAgLTExNzcsMTcgKzExNzcsMjQgQEAgc3RhdGljIGludCBnc3Nf
cmVhZF9wcm94eV92ZXJmKHN0cnVjdCBzdmNfcnFzdCAqcnFzdHAsDQo+PiAgIAltZW1jcHkocGFn
ZV9hZGRyZXNzKGluX3Rva2VuLT5wYWdlc1swXSksIGFyZ3YtPmlvdl9iYXNlLCBsZW5ndGgpOw0K
Pj4gICAJaW5sZW4gLT0gbGVuZ3RoOw0KPj4gICANCj4+IC0JaSA9IDE7DQo+PiAtCXBhZ2VfYmFz
ZSA9IHJxc3RwLT5ycV9hcmcucGFnZV9iYXNlOw0KPj4gKwl0b19vZmZzID0gbGVuZ3RoOw0KPj4g
Kwlmcm9tX29mZnMgPSBycXN0cC0+cnFfYXJnLnBhZ2VfYmFzZTsNCj4+ICAgCXdoaWxlIChpbmxl
bikgew0KPj4gLQkJbGVuZ3RoID0gbWluX3QodW5zaWduZWQgaW50LCBpbmxlbiwgUEFHRV9TSVpF
KTsNCj4+IC0JCW1lbWNweShwYWdlX2FkZHJlc3MoaW5fdG9rZW4tPnBhZ2VzW2ldKSwNCj4+IC0J
CSAgICAgICBwYWdlX2FkZHJlc3MocnFzdHAtPnJxX2FyZy5wYWdlc1tpXSkgKyBwYWdlX2Jhc2Us
DQo+PiArCQlwZ3RvID0gdG9fb2ZmcyA+PiBQQUdFX1NISUZUOw0KPj4gKwkJcGdmcm9tID0gZnJv
bV9vZmZzID4+IFBBR0VfU0hJRlQ7DQo+PiArCQlwZ3RvX29mZnMgPSB0b19vZmZzICYgflBBR0Vf
TUFTSzsNCj4+ICsJCXBnZnJvbV9vZmZzID0gZnJvbV9vZmZzICYgflBBR0VfTUFTSzsNCj4+ICsN
Cj4+ICsJCWxlbmd0aCA9IG1pbl90KHVuc2lnbmVkIGludCwgaW5sZW4sDQo+PiArCQkJIG1pbl90
KHVuc2lnbmVkIGludCwgUEFHRV9TSVpFIC0gcGd0b19vZmZzLA0KPj4gKwkJCSAgICAgICBQQUdF
X1NJWkUgLSBwZ2Zyb21fb2ZmcykpOw0KPj4gKwkJbWVtY3B5KHBhZ2VfYWRkcmVzcyhpbl90b2tl
bi0+cGFnZXNbcGd0b10pICsgcGd0b19vZmZzLA0KPj4gKwkJICAgICAgIHBhZ2VfYWRkcmVzcyhy
cXN0cC0+cnFfYXJnLnBhZ2VzW3BnZnJvbV0pICsgcGdmcm9tX29mZnMsDQo+PiAgIAkJICAgICAg
IGxlbmd0aCk7DQo+PiAgIA0KPj4gKwkJdG9fb2ZmcyArPSBsZW5ndGg7DQo+PiArCQlmcm9tX29m
ZnMgKz0gbGVuZ3RoOw0KPj4gICAJCWlubGVuIC09IGxlbmd0aDsNCj4+IC0JCXBhZ2VfYmFzZSA9
IDA7DQo+PiAtCQlpKys7DQo+PiAgIAl9DQo+PiAgIAlyZXR1cm4gMDsNCj4+ICAgfQ0KPj4gLS0g
DQo+PiAyLjIwLjENCg0KLS0gDQpNYXJ0aWpuIGRlIEdvdXcNCkRlc2lnbmVyDQpQcm9kcml2ZSBU
ZWNobm9sb2dpZXMNCk1vYmlsZTogKzMxIDYzIDE3IDc2IDE2MQ0KUGhvbmU6ICArMzEgNDAgMjYg
NzYgMjAwDQo=
