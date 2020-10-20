Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4124D293596
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404888AbgJTHQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:16:34 -0400
Received: from mail-eopbgr40109.outbound.protection.outlook.com ([40.107.4.109]:10387
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404706AbgJTHQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:16:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8qmGAluYGzURmex3vDda/XsivnjH8PQtQcR/tLJUWdPas8ejqaKBagHE/yqYe0mZPhDdpNULLmFVAP1rHSacRaU/7LsnSlhyFXx/q7ezA9ZEQJzCFprgsB7XvZ0KFma1JTC7QEHrQbWpLSd8Xk/5WQXo7r8LxVemMUbQuvl1v73sqswqyPXkb/0eB5BFVDZFG5hsZFZGe4nXnc0w2bMHdvN1+8B1SxCsHgfqZJbKlAfn7usaePdCpkx5uit1BxxYgrrVoVray+iMV7ZZlUoX3iJBiB2eMWBR5l1f/0Rk3QA4Ebh5Q8/EME/G3KI5PEBLOFyT+LLNjYmCeptmWAkQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMjZ3BDEyu6+2aJ2mVgKnwgRNs9fBuz8sH2yp1fSanc=;
 b=eNsFDrdaku/eOmQLTxRb2BLoAHpFH9OlaAv5NRC5eZ1KQZyuuALR8RsrT2KQset8Ek0KnHCujaFL0JUqAMI8QVnyrC1GYFFZER9idk69iHnI27KH6bybGc0LbVnOdoYI+7xzOC7hLTQBJ9uRpa01InujxqrfWWE1SdNZz6BViZi2zmQoZkrNAFuZdcArZq0amIxRaj/Xkv7OVAZpFP1WosLh+KehV+2RvNobHTa2soKR/2G3qk5e1+6UERdXH4BTzlayzWJUK69KyguHjkpOhy7kx+tyidr8XIY+LUVwcHL2Oh1DD98cplWBRXNcoTDWwBOKILEtLfJTKzwbbXZraQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prodrive-technologies.com; dmarc=pass action=none
 header.from=prodrive-technologies.com; dkim=pass
 header.d=prodrive-technologies.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=prodrive-technologies.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMjZ3BDEyu6+2aJ2mVgKnwgRNs9fBuz8sH2yp1fSanc=;
 b=SOeCKn78nE3RkWLa/snaMohPWqamW5RxIA1yyKpgrtNDYSjiiCxXRacjZTHX+BgmHa13CtHE3q6TSM95GY4J69iyEcyT7Eyl85bYxEhRGFOb9K6QWPbhE7J+O2i27aeGnl9CI/aPE1BztbS8b2KdUemP4vfBJvu074LoPuZwdz8=
Received: from AM0PR02MB3716.eurprd02.prod.outlook.com (2603:10a6:208:40::21)
 by AM0PR02MB4546.eurprd02.prod.outlook.com (2603:10a6:208:ed::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.26; Tue, 20 Oct
 2020 07:16:28 +0000
Received: from AM0PR02MB3716.eurprd02.prod.outlook.com
 ([fe80::f108:787f:22cd:6f74]) by AM0PR02MB3716.eurprd02.prod.outlook.com
 ([fe80::f108:787f:22cd:6f74%5]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:16:28 +0000
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
Thread-Index: AQHWpgz5jo9GE3xLcU6eFbSXAImdyqmfC1yAgAAGm4CAAGmcgIAAmiyA
Date:   Tue, 20 Oct 2020 07:16:28 +0000
Message-ID: <8ed0fa80-cc75-88ec-6b17-3f9cc300e9bb@prodrive-technologies.com>
References: <20201019114229.52973-1-martijn.de.gouw@prodrive-technologies.com>
 <20201019152301.GC32403@fieldses.org>
 <834dc52b-34fc-fee5-0274-fdc8932040e6@prodrive-technologies.com>
 <20201019220439.GC6692@fieldses.org>
In-Reply-To: <20201019220439.GC6692@fieldses.org>
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
x-ms-office365-filtering-correlation-id: ffeb5e33-93f5-4ef2-e1e1-08d874c80fe7
x-ms-traffictypediagnostic: AM0PR02MB4546:
x-microsoft-antispam-prvs: <AM0PR02MB45462F060E39F12F508170B2F51F0@AM0PR02MB4546.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xgHltBy1PwlQq5ppXvnRNoAguwz3dEMCCG9ZN+vwUNxjYUs8h/tAUwTA8yTjGObj2e2Q1YLSzygqscuIGU2oKvWnBXpoeFTmtjjYO5sQY5yw4ZXAeqtXGInWcoq7I8meFydYchzroqjNnla5JJO4m36c86d5gmYTORSEUelWwGvOO3zIHa3RKSIYW/g0jaK5rV10TvapUEnHgQIMltOmhlTOWEVC3HjlZi0B6xn+Spxwx4xtG8y5zSXHAOywhi+pBHP+rFOvYp3UQS5iuIPLea48ggAgYKrM6CukIJbkWSyDY9ijaQCJkO721wDfF5xmlxOhygpecgGlBMEVBNmi82hOfEzDE3aSOS9jPwA4z6c7giz9UYeWAJgfQfsgdLS/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB3716.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39850400004)(136003)(396003)(8936002)(6512007)(54906003)(66946007)(316002)(76116006)(4326008)(8676002)(478600001)(83380400001)(31686004)(7416002)(6506007)(36756003)(66446008)(64756008)(66476007)(66556008)(86362001)(71200400001)(6486002)(6916009)(31696002)(2616005)(5660300002)(186003)(26005)(2906002)(53546011)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: J8kQ3Ec52w+Ob330U1e91Sy/Dm+861XpInbrf2TcwAFA77IzvSGQdbeJLSYL/Q4ZTuSP3mFia5TYgu7RY1FLs19W1UdGL2hpKL9T7mQjoYxF4GZicst4zm3UUw8u39wEQCBKHjoHr6mWMT1Ov9As429UPtConB8dQETeR3QgIsWQGuOtm4VpJRubpr2PfbwcIyf8PN+8eCIH+hBjgmEIl/JgVzy2gah1um7bFz2kO7D1THrboHuA/xkpXlelk93uqObzYGvtTwr6fphbXhHVSI8qAkaAcdd7eL1lgXdqG+qjN+AODM9m9v2Vkcinl2fnKSDTf3nLqH76gwzOBW7PlL17jTe1lEcTTrCUCRfjCdaRP7Jx1LkuKMWByrzm6agD5Ikr+k8JQNV/erPek23UO5wyffABUIAd8pLHTVBdwBrqc5T0x216Lnbg5471WYThdozRJqC85fj5Gox7DADkKfKB2JCk2tkwwS0Nt/cSayey/ZeOmDBYMPcNQfvJzrKFfEVMg6WFRPwV1OxpCwr6Pz9CTfINyPexADhFkMevgpQJAo63VZuh8oWWj3D/tJIQoh489BZOxAlEHTc0zay5jX+CX286GwsMHrBKquijRWwPwlc6SkuY8MYocqgTB6wMUiZHn9+g13UxvrLNJ44HsQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2898F976F9037B4687887D18696294C3@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prodrive-technologies.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB3716.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffeb5e33-93f5-4ef2-e1e1-08d874c80fe7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 07:16:28.0732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 612607c9-5af7-4e7f-8976-faf1ae77be60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zlP4Z5JuWfIA569R3GM6+Q4qtFM96MWogQWGtSvsP+EUFJ10TrlGuiwFYkgOEjtcmp8Gv+7o2uoZmURpraxDk2xcLxfnbGbVFjVsTPELuyif4GaDqJUp1pjAXhE31jPb4VhMfhLRrKksnzvP0iCH6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR02MB4546
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCk9uIDIwLTEwLTIwMjAgMDA6MDQsIEouIEJydWNlIEZpZWxkcyB3cm90ZToNCj4gT24g
TW9uLCBPY3QgMTksIDIwMjAgYXQgMDM6NDY6MzlQTSArMDAwMCwgTWFydGlqbiBkZSBHb3V3IHdy
b3RlOg0KPj4gSGkNCj4+DQo+PiBPbiAxOS0xMC0yMDIwIDE3OjIzLCBKLiBCcnVjZSBGaWVsZHMg
d3JvdGU6DQo+Pj4gT24gTW9uLCBPY3QgMTksIDIwMjAgYXQgMDE6NDI6MjdQTSArMDIwMCwgTWFy
dGlqbiBkZSBHb3V3IHdyb3RlOg0KPj4+PiBXaGVuIHRoZSBwYXNzZWQgdG9rZW4gaXMgbG9uZ2Vy
IHRoYW4gNDAzMiBieXRlcywgdGhlIHJlbWFpbmluZyBwYXJ0DQo+Pj4+IG9mIHRoZSB0b2tlbiBt
dXN0IGJlIGNvcGllZCBmcm9tIHRoZSBycXN0cC0+cnFfYXJnLnBhZ2VzLiBCdXQgdGhlDQo+Pj4+
IGNvcHkgbXVzdCBtYWtlIHN1cmUgaXQgaGFwcGVucyBpbiBhIGNvbnNlY3V0aXZlIHdheS4NCj4+
Pg0KPj4+IFRoYW5rcy4gIEFwb2xvZ2llcywgYnV0IEkgZG9uJ3QgaW1tZWRpYXRlbHkgc2VlIHdo
ZXJlIHRoZSBjb3B5IGlzDQo+Pj4gbm9uLWNvbnNlY3V0aXZlLiAgV2hhdCBleGFjdGx5IGlzIHRo
ZSBidWcgaW4gdGhlIGV4aXN0aW5nIGNvZGU/DQo+Pg0KPj4gSW4gdGhlIGZpcnN0IG1lbWNweSAn
bGVuZ3RoJyBieXRlcyBhcmUgY29waWVkIGZyb20gYXJndi0+aW9iYXNlLCBidXQNCj4+IHNpbmNl
IHRoZSBoZWFkZXIgaXMgaW4gZnJvbnQsIHRoaXMgbmV2ZXIgZmlsbHMgdGhlIHdob2xlIGZpcnN0
IHBhZ2Ugb2YNCj4+IGluX3Rva2VuLT5wYWdlcy4NCj4+DQo+PiBUaGUgbWVtY3B5IGluIHRoZSBs
b29wIGNvcGllcyB0aGUgZm9sbG93aW5nIGJ5dGVzLCBidXQgc3RhcnRzIHdyaXRpbmcgYXQNCj4+
IHRoZSBuZXh0IHBhZ2Ugb2YgaW5fdG9rZW4tPnBhZ2VzLiBUaGlzIGxlYXZlcyB0aGUgbGFzdCBi
eXRlcyBvZiBwYWdlIDANCj4+IHVud3JpdHRlbi4NCj4+DQo+PiBOZXh0IHRvIHRoYXQsIHRoZSBy
ZW1haW5pbmcgZGF0YSBpcyBpbiBwYWdlIDAgb2YgcnFzdHAtPnJxX2FyZy5wYWdlcywNCj4+IG5v
dCBwYWdlIDEuDQo+IA0KPiBHb3QgaXQsIHRoYW5rcy4gIExvb2tzIGxpa2UgdGhlIGN1bHByaXQg
bWlnaHQgYmUgYSBwYXRjaCBmcm9tIGEgeWVhciBhZ28NCj4gZnJvbSBDaHVjaywgNTg2NmVmYThj
YmZiICJTVU5SUEM6IEZpeCBzdmNhdXRoX2dzc19wcm94eV9pbml0KCkiPyAgQXQNCj4gbGVhc3Qs
IHRoYXQncyB0aGUgbGFzdCBtYWpvciBwYXRjaCB0byB0b3VjaCB0aGlzIGNvZGUuDQoNCkkgZm91
bmQgdGhpcyBpc3N1ZSB3aGVuIHNldHRpbmcgdXAgTkZTdjQgd2l0aCBBY3RpdmUgRGlyZWN0b3J5
IGFzIEtEQyANCmFuZCBnc3Nwcm94eS4gVXNlcnMgd2l0aCBtYW55IGdyb3VwcyB3aGVyZSBub3Qg
YWJsZSB0byBhY2Nlc3MgdGhlIE5GUyANCnNoYXJlcywgd2hpbGUgb3RoZXJzIGNvdWxkIGFjY2Vz
cyB0aGVtIGp1c3QgZmluZS4gRHVyaW5nIGRlYnVnZ2luZyBJIA0KZm91bmQgdGhhdCB0aGUgdG9r
ZW4gd2FzIG5vdCB0aGUgc2FtZSBvbiBib3RoIHNpZGVzLg0KDQpJIGRvIG5vdCBoYXZlIHRoZSBI
VyB0byBzZXR1cCBhIHJkbWEgdmVyc2lvbiBvZiBORlN2NCwgc28gSSdtIHVuYWJsZSB0byANCnRl
c3QgaWYgaXQgc3RpbGwgd29ya3MgdmlhIHJkbWEuDQoNClJlZ2FyZHMsIE1hcnRpam4NCg0KPiAN
Cj4gLS1iLg0KPiANCj4+DQo+PiBSZWdhcmRzLCBNYXJ0aWpuDQo+Pg0KPj4+DQo+Pj4gLS1iLg0K
Pj4+DQo+Pj4+DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IE1hcnRpam4gZGUgR291dyA8bWFydGlqbi5k
ZS5nb3V3QHByb2RyaXZlLXRlY2hub2xvZ2llcy5jb20+DQo+Pj4+IC0tLQ0KPj4+PiAgICBuZXQv
c3VucnBjL2F1dGhfZ3NzL3N2Y2F1dGhfZ3NzLmMgfCAyNyArKysrKysrKysrKysrKysrKy0tLS0t
LS0tLS0NCj4+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKyksIDEwIGRlbGV0
aW9ucygtKQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvbmV0L3N1bnJwYy9hdXRoX2dzcy9zdmNh
dXRoX2dzcy5jIGIvbmV0L3N1bnJwYy9hdXRoX2dzcy9zdmNhdXRoX2dzcy5jDQo+Pj4+IGluZGV4
IDI1OGIwNDM3MmY4NS4uYmQ0Njc4ZGI5ZDc2IDEwMDY0NA0KPj4+PiAtLS0gYS9uZXQvc3VucnBj
L2F1dGhfZ3NzL3N2Y2F1dGhfZ3NzLmMNCj4+Pj4gKysrIGIvbmV0L3N1bnJwYy9hdXRoX2dzcy9z
dmNhdXRoX2dzcy5jDQo+Pj4+IEBAIC0xMTQ3LDkgKzExNDcsOSBAQCBzdGF0aWMgaW50IGdzc19y
ZWFkX3Byb3h5X3ZlcmYoc3RydWN0IHN2Y19ycXN0ICpycXN0cCwNCj4+Pj4gICAgCQkJICAgICAg
IHN0cnVjdCBnc3NwX2luX3Rva2VuICppbl90b2tlbikNCj4+Pj4gICAgew0KPj4+PiAgICAJc3Ry
dWN0IGt2ZWMgKmFyZ3YgPSAmcnFzdHAtPnJxX2FyZy5oZWFkWzBdOw0KPj4+PiAtCXVuc2lnbmVk
IGludCBwYWdlX2Jhc2UsIGxlbmd0aDsNCj4+Pj4gLQlpbnQgcGFnZXMsIGksIHJlczsNCj4+Pj4g
LQlzaXplX3QgaW5sZW47DQo+Pj4+ICsJdW5zaWduZWQgaW50IGxlbmd0aCwgcGd0b19vZmZzLCBw
Z2Zyb21fb2ZmczsNCj4+Pj4gKwlpbnQgcGFnZXMsIGksIHJlcywgcGd0bywgcGdmcm9tOw0KPj4+
PiArCXNpemVfdCBpbmxlbiwgdG9fb2ZmcywgZnJvbV9vZmZzOw0KPj4+PiAgICANCj4+Pj4gICAg
CXJlcyA9IGdzc19yZWFkX2NvbW1vbl92ZXJmKGdjLCBhcmd2LCBhdXRocCwgaW5faGFuZGxlKTsN
Cj4+Pj4gICAgCWlmIChyZXMpDQo+Pj4+IEBAIC0xMTc3LDE3ICsxMTc3LDI0IEBAIHN0YXRpYyBp
bnQgZ3NzX3JlYWRfcHJveHlfdmVyZihzdHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3RwLA0KPj4+PiAgICAJ
bWVtY3B5KHBhZ2VfYWRkcmVzcyhpbl90b2tlbi0+cGFnZXNbMF0pLCBhcmd2LT5pb3ZfYmFzZSwg
bGVuZ3RoKTsNCj4+Pj4gICAgCWlubGVuIC09IGxlbmd0aDsNCj4+Pj4gICAgDQo+Pj4+IC0JaSA9
IDE7DQo+Pj4+IC0JcGFnZV9iYXNlID0gcnFzdHAtPnJxX2FyZy5wYWdlX2Jhc2U7DQo+Pj4+ICsJ
dG9fb2ZmcyA9IGxlbmd0aDsNCj4+Pj4gKwlmcm9tX29mZnMgPSBycXN0cC0+cnFfYXJnLnBhZ2Vf
YmFzZTsNCj4+Pj4gICAgCXdoaWxlIChpbmxlbikgew0KPj4+PiAtCQlsZW5ndGggPSBtaW5fdCh1
bnNpZ25lZCBpbnQsIGlubGVuLCBQQUdFX1NJWkUpOw0KPj4+PiAtCQltZW1jcHkocGFnZV9hZGRy
ZXNzKGluX3Rva2VuLT5wYWdlc1tpXSksDQo+Pj4+IC0JCSAgICAgICBwYWdlX2FkZHJlc3MocnFz
dHAtPnJxX2FyZy5wYWdlc1tpXSkgKyBwYWdlX2Jhc2UsDQo+Pj4+ICsJCXBndG8gPSB0b19vZmZz
ID4+IFBBR0VfU0hJRlQ7DQo+Pj4+ICsJCXBnZnJvbSA9IGZyb21fb2ZmcyA+PiBQQUdFX1NISUZU
Ow0KPj4+PiArCQlwZ3RvX29mZnMgPSB0b19vZmZzICYgflBBR0VfTUFTSzsNCj4+Pj4gKwkJcGdm
cm9tX29mZnMgPSBmcm9tX29mZnMgJiB+UEFHRV9NQVNLOw0KPj4+PiArDQo+Pj4+ICsJCWxlbmd0
aCA9IG1pbl90KHVuc2lnbmVkIGludCwgaW5sZW4sDQo+Pj4+ICsJCQkgbWluX3QodW5zaWduZWQg
aW50LCBQQUdFX1NJWkUgLSBwZ3RvX29mZnMsDQo+Pj4+ICsJCQkgICAgICAgUEFHRV9TSVpFIC0g
cGdmcm9tX29mZnMpKTsNCj4+Pj4gKwkJbWVtY3B5KHBhZ2VfYWRkcmVzcyhpbl90b2tlbi0+cGFn
ZXNbcGd0b10pICsgcGd0b19vZmZzLA0KPj4+PiArCQkgICAgICAgcGFnZV9hZGRyZXNzKHJxc3Rw
LT5ycV9hcmcucGFnZXNbcGdmcm9tXSkgKyBwZ2Zyb21fb2ZmcywNCj4+Pj4gICAgCQkgICAgICAg
bGVuZ3RoKTsNCj4+Pj4gICAgDQo+Pj4+ICsJCXRvX29mZnMgKz0gbGVuZ3RoOw0KPj4+PiArCQlm
cm9tX29mZnMgKz0gbGVuZ3RoOw0KPj4+PiAgICAJCWlubGVuIC09IGxlbmd0aDsNCj4+Pj4gLQkJ
cGFnZV9iYXNlID0gMDsNCj4+Pj4gLQkJaSsrOw0KPj4+PiAgICAJfQ0KPj4+PiAgICAJcmV0dXJu
IDA7DQo+Pj4+ICAgIH0NCj4+Pj4gLS0gDQo+Pj4+IDIuMjAuMQ0KPj4NCj4+IC0tIA0KPj4gTWFy
dGlqbiBkZSBHb3V3DQo+PiBEZXNpZ25lcg0KPj4gUHJvZHJpdmUgVGVjaG5vbG9naWVzDQo+PiBN
b2JpbGU6ICszMSA2MyAxNyA3NiAxNjENCj4+IFBob25lOiAgKzMxIDQwIDI2IDc2IDIwMA0KDQot
LSANCk1hcnRpam4gZGUgR291dw0KRGVzaWduZXINClByb2RyaXZlIFRlY2hub2xvZ2llcw0KTW9i
aWxlOiArMzEgNjMgMTcgNzYgMTYxDQpQaG9uZTogICszMSA0MCAyNiA3NiAyMDANCg==
