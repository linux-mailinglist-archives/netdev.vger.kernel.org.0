Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377631A6355
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 08:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgDMG7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 02:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbgDMG7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 02:59:08 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B85C008651;
        Sun, 12 Apr 2020 23:59:04 -0700 (PDT)
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 941A3C035D;
        Mon, 13 Apr 2020 06:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1586761144; bh=Q0jiQANGcT/dtRxrLun8OWlccU+m84ZxfhZwFZgtvvg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=CPFVfCpe9Sl7ofRAFW5ILPvJilloG/d04/vk18dAO5c2mhyQ230EVd6vWEIg+3nEj
         SPIUxKgYrLjjf2HDZvLuVhpKmISPHeYEqvb3Q7NiubncY/p2LJv/tw0hSJP8uBbR/O
         lpqL1RFFRdtqtzTLxihPsqAsYIUn1sEBZU/qyTGLdNLamnqCb7gBza2OpWl3E1KB/O
         vjsBy4WMXD2Jcffpoz9SdtTgCp1lQKrNZw15mJNnaCYFyx/PAdp+3751rBCJxBgr5q
         fAanI7bUNJVkikLpuKGeiURoH+ZRPxrr7O/hqd0WntE0i1DivbOP9rL98QvfFdqCA4
         fJ3Q5Wa5WBe1w==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C5C70A0080;
        Mon, 13 Apr 2020 06:59:02 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Sun, 12 Apr 2020 23:59:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Sun, 12 Apr 2020 23:56:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eA4a6Iboppwpwmo76attsRRMM+YlgMRZdbcDnOaLowMzUSWV5+hiKs/MzCIuOLuHPgughZwVCrP2A9eyOkoIZgB95Kji1auRO9P34J1ttmatV3LUgJrLCevP9YDUQyObKVCSgSdPrA89prCIv15iudiYsyE9c2Kdgikn3VOT+oxxr3fua90nvyisuHmPeg5pAMeDeaaJ9uL/W+GB4HyfGPpUxdXBMCRpzIi9fzVDUiVMrSB29oJEgcj3/S39w9Vc1PxZ0FsywVJJWbGc+QSUTnz2+5Pmm5A4RlvgFku24diBguHEFn0lZIQc4yPEHcTA52PV8bffSgE5o1vBoGqGmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0jiQANGcT/dtRxrLun8OWlccU+m84ZxfhZwFZgtvvg=;
 b=Gf+hkkRk1eQFxke6qvBtxjSR/Cb+n3axu0oGlH+HRTGMWsJc4yD2F8uLsNjA8/W3QNEE4jmbpZ2CmrOcO6iZkymmGQw7YZqJMEitI4DPgloAm7vNS/Wu2WPZzeLwKzr26k/QaplOIXeHKTzh6jPLK9RO57JI30RqanMYA7lugm617VqpPAQvYDbkVuCms3iBmATJViyBiRBRyIM/GgbL6dBq6Z3JiArTSjttsQEhRHY0S/ux851jLrrB7i9iHtsgA7/LEfemFpG8LyyJ8UEke3N3hpvMDnXD2q1+gPpT1zDASMbhlPlkzzbd6bIBcfwSS8HBU2cuy/EiBd9u3tmjPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0jiQANGcT/dtRxrLun8OWlccU+m84ZxfhZwFZgtvvg=;
 b=J+XztPbl0/a1VXXLn0E+3k3LVwtzoVpEc6UcP8iY7jA0Kw9DL4TojMaHD9j5nlSj0ebK7Bo64FsV1ycTCctUnRWLbSMyswVa9sFyS2BNt1m4PK3/Eg9Ibvj6nHmiH0ClvdU2SkbX5+rDlQDL7C77ldVKXUPfAypfnMQxvqkyoA0=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3364.namprd12.prod.outlook.com (2603:10b6:408:40::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Mon, 13 Apr
 2020 06:56:31 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 06:56:31 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Chen-Yu Tsai <wens@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net] net: stmmac: Guard against txfifosz=0
Thread-Topic: [PATCH net] net: stmmac: Guard against txfifosz=0
Thread-Index: AQHWEH11lcj1LhRkfUiqKOYMl1gtAKh1zzAAgAABHYCAAMjRAIAABZ+AgAAA9RA=
Date:   Mon, 13 Apr 2020 06:56:31 +0000
Message-ID: <BN8PR12MB32667D9FEB2FBC9657C16183D3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200412034931.9558-1-f.fainelli@gmail.com>
 <20200412112756.687ff227@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ae06b4c6-6818-c053-6f33-55c96f88a4ae@gmail.com>
 <BN8PR12MB3266A47DE93CEAEBDB4F288AD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <CAGb2v65wjtphcN4DEM4mfv+=U5KUmsTujVoPb9L0idwy=ysDZw@mail.gmail.com>
In-Reply-To: <CAGb2v65wjtphcN4DEM4mfv+=U5KUmsTujVoPb9L0idwy=ysDZw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a4a3c69-75f9-4e51-ac54-08d7df77cc3c
x-ms-traffictypediagnostic: BN8PR12MB3364:
x-microsoft-antispam-prvs: <BN8PR12MB3364D24EFC1713B1F6BF9F64D3DD0@BN8PR12MB3364.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(396003)(346002)(136003)(39850400004)(366004)(66476007)(66556008)(64756008)(8936002)(71200400001)(8676002)(52536014)(5660300002)(66446008)(478600001)(76116006)(66946007)(81156014)(86362001)(33656002)(54906003)(55016002)(4326008)(9686003)(53546011)(110136005)(316002)(7696005)(26005)(2906002)(6506007)(186003)(7416002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MLzCxwSUPwRx1cSQYK5BvxzkUfT08LmL1d6XSi2SoTxQfOWhOCt4paga6XN1a9mDzE0jvxEKxD0f2rCoxf6oKobreQ6WU7YhtFZfe+tSJIhG6qF/d741tl5cObRBuo6i6Lr5imW23qjma/3jC7u7voHA8vKHkglYby8vnOoJpT75fSk40XohHcs4V+CtwCeIxkBCBXmgXZUKzy+yndupPYTapG18SZ6FgPVG0RttMNFuqLs/cV1T2gDoqSOg/dZfu244EBxvTR7Vk2PwViQmvcqkfq/ThNzPQs5O9NhHQkWzCU468YwvcKTXK6igDqFInQNmOb93Mta986sMUR5OH/miewmBFK+BB8DVLFB7EdvqxbDUKhQkCjTzHOz8nKp3c+qsviw8514jc8mskkkt4FzF4uINrGdnfVMZTjAunNORoEQ0gLwnRh3L3xju1Ctz
x-ms-exchange-antispam-messagedata: 2mdR+PABWaftLa4hKj4l+zwStx333Gi1NEDl/J0J+sCAszRKe6ryNe+NqWNqAKiWuMssVRe9O65rfdeuTwsMxkrdXMrTF7SS9Bc4yLZ0qehWbCN0C0HTXmFkn5eHEBbydI/hVNeVVwsONWrRwCHuLA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a4a3c69-75f9-4e51-ac54-08d7df77cc3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 06:56:31.6245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oLisMvE7wBob7cg7oMJl50/cVeKfMcCbg2MzjIwOAdTV630favYg88SiGcLPNL00Gcc2kOrRtWNgS4jjhCUqgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3364
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hlbi1ZdSBUc2FpIDx3ZW5zQGtlcm5lbC5vcmc+DQpEYXRlOiBBcHIvMTMvMjAyMCwg
MDc6NTA6NDcgKFVUQyswMDowMCkNCg0KPiBPbiBNb24sIEFwciAxMywgMjAyMCBhdCAyOjQyIFBN
IEpvc2UgQWJyZXUgPEpvc2UuQWJyZXVAc3lub3BzeXMuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZy
b206IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiA+IERhdGU6IEFw
ci8xMi8yMDIwLCAxOTozMTo1NSAoVVRDKzAwOjAwKQ0KPiA+DQo+ID4gPg0KPiA+ID4NCj4gPiA+
IE9uIDQvMTIvMjAyMCAxMToyNyBBTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gPiA+IE9u
IFNhdCwgMTEgQXByIDIwMjAgMjA6NDk6MzEgLTA3MDAgRmxvcmlhbiBGYWluZWxsaSB3cm90ZToN
Cj4gPiA+ID4+IEFmdGVyIGNvbW1pdCBiZmNiODEzMjAzZTYxOWE4OTYwYTgxOWJmNTMzYWQyYTEw
OGQ4MTA1ICgibmV0OiBkc2E6DQo+ID4gPiA+PiBjb25maWd1cmUgdGhlIE1UVSBmb3Igc3dpdGNo
IHBvcnRzIikgbXkgTGFtb2JvIFIxIHBsYXRmb3JtIHdoaWNoIHVzZXMNCj4gPiA+ID4+IGFuIGFs
bHdpbm5lcixzdW43aS1hMjAtZ21hYyBjb21wYXRpYmxlIEV0aGVybmV0IE1BQyBzdGFydGVkIHRv
IGZhaWwNCj4gPiA+ID4+IGJ5IHJlamVjdGluZyBhIE1UVSBvZiAxNTM2LiBUaGUgcmVhc29uIGZv
ciB0aGF0IGlzIHRoYXQgdGhlIERNQQ0KPiA+ID4gPj4gY2FwYWJpbGl0aWVzIGFyZSBub3QgcmVh
ZGFibGUgb24gdGhpcyB2ZXJzaW9uIG9mIHRoZSBJUCwgYW5kIHRoZXJlIGlzDQo+ID4gPiA+PiBh
bHNvIG5vICd0eC1maWZvLWRlcHRoJyBwcm9wZXJ0eSBiZWluZyBwcm92aWRlZCBpbiBEZXZpY2Ug
VHJlZS4gVGhlDQo+ID4gPiA+PiBwcm9wZXJ0eSBpcyBkb2N1bWVudGVkIGFzIG9wdGlvbmFsLCBh
bmQgaXMgbm90IHByb3ZpZGVkLg0KPiA+ID4gPj4NCj4gPiA+ID4+IFRoZSBtaW5pbXVtIE1UVSB0
aGF0IHRoZSBuZXR3b3JrIGRldmljZSBhY2NlcHRzIGlzIEVUSF9aTEVOIC0gRVRIX0hMRU4sDQo+
ID4gPiA+PiBzbyByZWplY3RpbmcgdGhlIG5ldyBNVFUgYmFzZWQgb24gdGhlIHR4Zmlmb3N6IHZh
bHVlIHVuY2hlY2tlZCBzZWVtcyBhDQo+ID4gPiA+PiBiaXQgdG9vIGhlYXZ5IGhhbmRlZCBoZXJl
Lg0KPiA+ID4gPg0KPiA+ID4gPiBPVE9IIGlzIGl0IHNhZmUgdG8gYXNzdW1lIE1UVXMgdXAgdG8g
MTZrIGFyZSB2YWxpZCBpZiBkZXZpY2UgdHJlZSBsYWNrcw0KPiA+ID4gPiB0aGUgb3B0aW9uYWwg
cHJvcGVydHk/IElzIHRoaXMgY2hhbmdlIHB1cmVseSB0byBwcmVzZXJ2ZSBiYWNrd2FyZA0KPiA+
ID4gPiAoYnVnLXdhcmQ/KSBjb21wYXRpYmlsaXR5LCBldmVuIGlmIGl0J3Mgbm90IGVudGlyZWx5
IGNvcnJlY3QgdG8gYWxsb3cNCj4gPiA+ID4gaGlnaCBNVFUgdmFsdWVzPyAoSSB0aGluayB0aGF0
J2QgYmUgd29ydGggc3RhdGluZyBpbiB0aGUgY29tbWl0IG1lc3NhZ2UNCj4gPiA+ID4gbW9yZSBl
eHBsaWNpdGx5LikgSXMgdGhlcmUgbm8gInJlYXNvbmFibGUgZGVmYXVsdCIgd2UgY291bGQgc2Vs
ZWN0IGZvcg0KPiA+ID4gPiB0eGZpZm9zeiBpZiBwcm9wZXJ0eSBpcyBtaXNzaW5nPw0KPiA+ID4N
Cj4gPiA+IFRob3NlIGFyZSBnb29kIHF1ZXN0aW9ucywgYW5kIEkgZG8gbm90IGtub3cgaG93IHRv
IGFuc3dlciB0aGVtIGFzIEkgYW0NCj4gPiA+IG5vdCBmYW1pbGlhciB3aXRoIHRoZSBzdG1tYWMg
SFcgZGVzaWduLCBidXQgSSBhbSBob3BpbmcgSm9zZSBjYW4gcmVzcG9uZA0KPiA+ID4gb24gdGhp
cyBwYXRjaC4gSXQgZG9lcyBzb3VuZCBsaWtlIHByb3ZpZGluZyBhIGRlZmF1bHQgVFggRklGTyBz
aXplIHdvdWxkDQo+ID4gPiBzb2x2ZSB0aGF0IE1UVSBwcm9ibGVtLCB0b28sIGJ1dCB3aXRob3V0
IGEgJ3R4LWZpZm8tZGVwdGgnIHByb3BlcnR5DQo+ID4gPiBzcGVjaWZpZWQgaW4gRGV2aWNlIFRy
ZWUsIGFuZCB3aXRoIHRoZSAiZG1hX2NhcCIgYmVpbmcgZW1wdHkgZm9yIHRoaXMNCj4gPiA+IGNo
aXAsIEkgaGF2ZSBubyBpZGVhIHdoYXQgdG8gc2V0IGl0IHRvLg0KPiA+DQo+ID4gVW5mb3J0dW5h
dGVseSwgYWxsd2lubmVyIHVzZXMgR01BQyB3aGljaCBkb2VzIG5vdCBoYXZlIGFueSBtZWFuIHRv
IGRldGVjdA0KPiA+IFRYIEZJRk8gU2l6ZS4gRGVmYXVsdCB2YWx1ZSBpbiBIVyBpcyAyayBidXQg
dGhpcyBjYW4gbm90IGJlIHRoZSBjYXNlIGluDQo+ID4gdGhlc2UgcGxhdGZvcm1zIGlmIEhXIHRl
YW0gZGVjaWRlZCB0byBjaGFuZ2UgaXQuDQo+IA0KPiBJIGxvb2tlZCBhdCBhbGwgdGhlIHB1Ymxp
Y2x5IGF2YWlsYWJsZSBkYXRhc2hlZXRzIGFuZCBBbGx3aW5uZXIgdXNlcw0KPiA0SyBUWCBGSUZP
IGFuZCAxNksgUlggRklGTyBpbiBhbGwgU29Dcy4gTm90IHN1cmUgaWYgdGhpcyB3b3VsZCBoZWxw
Lg0KDQpZZXMsIHRoYW5rcyBmb3IgZmluZGluZyB0aGlzIQ0KDQpTbywgSSB0aGluayBjb3JyZWN0
IGZpeCBpcyB0aGVuIHRvIGhhcmQtY29kZSB0aGVzZSB2YWx1ZXMgaW4gZHdtYWMtc3VueGkuYyAN
CnByb2JlIGZ1bmN0aW9uIHVzaW5nIHRoZSBhbHJlYWR5IGF2YWlsYWJsZSBwbGF0Zm9ybSBkYXRh
IHN0cnVjdHVyZS4NCg0KLS0tDQpUaGFua3MsDQpKb3NlIE1pZ3VlbCBBYnJldQ0K
