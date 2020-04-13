Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874631A632A
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 08:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgDMGmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 02:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbgDMGmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 02:42:16 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C42C008651;
        Sun, 12 Apr 2020 23:42:16 -0700 (PDT)
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AB1CD403BE;
        Mon, 13 Apr 2020 06:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1586760135; bh=LwhkAEte0hwl7z4WclZd8hlgf/pAq4y5l76Pd+zJlNY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Z4nIJ8NCPDW/X7sfijmXsRLSHHSQPDudjcYlxUgs4INe6ML2IDFFlDQp35bS/gcEa
         W47MAv4N0Biq+paw4m3L5YfzlU5/WIWugN3OTbnyxQGDMv2cw8t95EoHBAp4BMGqCe
         PQN3PdqN2v9O852B5x9zJw8P8517BGMErvcHifvlRC5rGgoxQHiW9Zo7VYWM4ZnEyK
         KmNn3t7XtRC9/8xNXoeGfdROAXDGu0Jzl0chpE6mekc5dSCA5JCgl+2qWQht+xbSVL
         i2d9FdvnLbABCGke2zh9YDEX3P+iAWl8fA3akn+/eNvQIw7Rv6u87sWp+K9mcPBPpV
         ZknU74lTw1t0Q==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7FB55A0069;
        Mon, 13 Apr 2020 06:42:09 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Sun, 12 Apr 2020 23:42:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Sun, 12 Apr 2020 23:42:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVu5U2ckGxYoLeKj3nl17zq6ZjfKRLPLnEcrGqtuiImEbYYL+SmVAheFGncHoKgXGwVSE9PPc0O2thmVJ6LQlcmCIyR5NmnxBEJ/rrMe0cmbrO3N0WdmVgS1vOTwIql/Ys5W8tj8XzEUNWKwdLx/xWZyZYXYehhkj2krzFbuzB8Qv+ZtZgyeA/tRcryLMDVV8kG98QvQGb8uh2KFq6EuRSzVSYDIT+fw8hYiTIiowJhohHLmi4dbaMqaWZApxiAD/zKexLnjiYOQ45cNIjNgNpwND678dckOEDF1bpp24LQ24YL2NUYtsuF42LoBWiQK5ViWUfR3+cAUeAYiTNZj9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwhkAEte0hwl7z4WclZd8hlgf/pAq4y5l76Pd+zJlNY=;
 b=WwR5t8rBwLZbdiZ23+ClGCXrfEr0X9KU41sJgrKvb/GOxVrQHvlWeD0DqdifNEEowtNHiEg65FKvo6M/G/iUmwrsUXrJbTmrWfCKNNlxGKmyLTARUG4L2tuoDiAy+i6zwuyt9/ehJRTaAW1bWMJ1kQwWGXmCZXMPFiwKZ6JrY7ZchXvUy6UJzS5QxDabIr/hMa5JiSzpriprrHamWWaBaNtDAo/Xv66Rg2bkAbx2sDGfZNbL/uIMO9aduDK43j1sY+PT9n/6zlaeS/r8uxZ8AOMDHca+qQl4DPtbCVr/kVGYr0AhgE10aJlsnLpQQ3eG0L6kBSh4g/YCK1aDlxmmmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwhkAEte0hwl7z4WclZd8hlgf/pAq4y5l76Pd+zJlNY=;
 b=chlN3BLduqVr7LTS6CKtIc5TW9TWMg8e/6rcb47bVOHl93rWOTkUXwvkTu2RLTP4f73SASxjjY6oDrc5lR2xtcvn/Kker9qAKJ2sUUczR5+526asHP6a89Iy7bOBrUgN8pGyPSIA9PKLG5hp4TNIPsXKr1KPzaLpjh4OY3HQBMk=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3090.namprd12.prod.outlook.com (2603:10b6:408:67::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Mon, 13 Apr
 2020 06:42:07 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 06:42:07 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: stmmac: Guard against txfifosz=0
Thread-Topic: [PATCH net] net: stmmac: Guard against txfifosz=0
Thread-Index: AQHWEH11lcj1LhRkfUiqKOYMl1gtAKh1zzAAgAABHYCAAMjRAA==
Date:   Mon, 13 Apr 2020 06:42:07 +0000
Message-ID: <BN8PR12MB3266A47DE93CEAEBDB4F288AD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200412034931.9558-1-f.fainelli@gmail.com>
 <20200412112756.687ff227@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ae06b4c6-6818-c053-6f33-55c96f88a4ae@gmail.com>
In-Reply-To: <ae06b4c6-6818-c053-6f33-55c96f88a4ae@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c2da273-6af1-4dfb-4dc7-08d7df75c94f
x-ms-traffictypediagnostic: BN8PR12MB3090:
x-microsoft-antispam-prvs: <BN8PR12MB30900E04FF9824EAF2B4D2C2D3DD0@BN8PR12MB3090.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(366004)(136003)(39850400004)(376002)(346002)(54906003)(2906002)(186003)(81156014)(8676002)(8936002)(316002)(110136005)(478600001)(66946007)(76116006)(86362001)(7696005)(53546011)(6506007)(66446008)(64756008)(66556008)(66476007)(26005)(9686003)(33656002)(55016002)(5660300002)(4326008)(7416002)(71200400001)(52536014);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gmC3Y717AZT9f8dWVlhpEWOQhZKtIBHEN9mccwc016fHn2T12tL+PT7bOhyGhoPVP/+lx/OTuMrkXBntKrTnt/CkMczgZmjviDX3wM60ZHIg3ttYwlXnBfiePbwOFMx7NNaZpMYxVPC8K8aT2vJbEMBczgCFQnR3jpmhdpcQJP5dsjSeDJM7+d/ktPVKdS70Gq8lB0Da+1PB1OJ6Okx31D9UwGUaDUqcEnnhwgpogCJHDd3GG7Vf/Ca59nAogID4ndNoqEMxdTBReRRc3bVjJkNtrD6oMz53zTqdljo2Lnj8HbthyLnzGvTvRKU8pdiubYXZse0/wXWI6ybgocWnY87ZEhvpuIWnfKclkhqkO9zbyGfrFGmgk/+Sr2bdWIPHudGO71j1mdJ8vU1u96VbolQ54zoBHvhUmACJ2L5OPxn7Kt3vjJ6maY+/heVp440V
x-ms-exchange-antispam-messagedata: 4MX2TyEhoKkHh7HvGq2dtHfDySOILoXGrw262Xbbav62SI42h0kTmlwlTtiKcvUeOU59AeKa4rb9ZnfHKahIC8YkSV8Mw+Ll1RhMJOVnw/R5rRs301cjqojFPCZoVnbuxf/9mXZ/ctZhoIF6M5HLPA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c2da273-6af1-4dfb-4dc7-08d7df75c94f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 06:42:07.6500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uogZiEcZ0XgLg96vj4TW0o1t+b15Ns+rmhIsPI49l7l/on6C+f0gGZ13dxLX++jniBPsiVJaqajrv+bXNvJG4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3090
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQpEYXRlOiBBcHIv
MTIvMjAyMCwgMTk6MzE6NTUgKFVUQyswMDowMCkNCg0KPiANCj4gDQo+IE9uIDQvMTIvMjAyMCAx
MToyNyBBTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gT24gU2F0LCAxMSBBcHIgMjAyMCAy
MDo0OTozMSAtMDcwMCBGbG9yaWFuIEZhaW5lbGxpIHdyb3RlOg0KPiA+PiBBZnRlciBjb21taXQg
YmZjYjgxMzIwM2U2MTlhODk2MGE4MTliZjUzM2FkMmExMDhkODEwNSAoIm5ldDogZHNhOg0KPiA+
PiBjb25maWd1cmUgdGhlIE1UVSBmb3Igc3dpdGNoIHBvcnRzIikgbXkgTGFtb2JvIFIxIHBsYXRm
b3JtIHdoaWNoIHVzZXMNCj4gPj4gYW4gYWxsd2lubmVyLHN1bjdpLWEyMC1nbWFjIGNvbXBhdGli
bGUgRXRoZXJuZXQgTUFDIHN0YXJ0ZWQgdG8gZmFpbA0KPiA+PiBieSByZWplY3RpbmcgYSBNVFUg
b2YgMTUzNi4gVGhlIHJlYXNvbiBmb3IgdGhhdCBpcyB0aGF0IHRoZSBETUENCj4gPj4gY2FwYWJp
bGl0aWVzIGFyZSBub3QgcmVhZGFibGUgb24gdGhpcyB2ZXJzaW9uIG9mIHRoZSBJUCwgYW5kIHRo
ZXJlIGlzDQo+ID4+IGFsc28gbm8gJ3R4LWZpZm8tZGVwdGgnIHByb3BlcnR5IGJlaW5nIHByb3Zp
ZGVkIGluIERldmljZSBUcmVlLiBUaGUNCj4gPj4gcHJvcGVydHkgaXMgZG9jdW1lbnRlZCBhcyBv
cHRpb25hbCwgYW5kIGlzIG5vdCBwcm92aWRlZC4NCj4gPj4NCj4gPj4gVGhlIG1pbmltdW0gTVRV
IHRoYXQgdGhlIG5ldHdvcmsgZGV2aWNlIGFjY2VwdHMgaXMgRVRIX1pMRU4gLSBFVEhfSExFTiwN
Cj4gPj4gc28gcmVqZWN0aW5nIHRoZSBuZXcgTVRVIGJhc2VkIG9uIHRoZSB0eGZpZm9zeiB2YWx1
ZSB1bmNoZWNrZWQgc2VlbXMgYQ0KPiA+PiBiaXQgdG9vIGhlYXZ5IGhhbmRlZCBoZXJlLg0KPiA+
IA0KPiA+IE9UT0ggaXMgaXQgc2FmZSB0byBhc3N1bWUgTVRVcyB1cCB0byAxNmsgYXJlIHZhbGlk
IGlmIGRldmljZSB0cmVlIGxhY2tzDQo+ID4gdGhlIG9wdGlvbmFsIHByb3BlcnR5PyBJcyB0aGlz
IGNoYW5nZSBwdXJlbHkgdG8gcHJlc2VydmUgYmFja3dhcmQNCj4gPiAoYnVnLXdhcmQ/KSBjb21w
YXRpYmlsaXR5LCBldmVuIGlmIGl0J3Mgbm90IGVudGlyZWx5IGNvcnJlY3QgdG8gYWxsb3cNCj4g
PiBoaWdoIE1UVSB2YWx1ZXM/IChJIHRoaW5rIHRoYXQnZCBiZSB3b3J0aCBzdGF0aW5nIGluIHRo
ZSBjb21taXQgbWVzc2FnZQ0KPiA+IG1vcmUgZXhwbGljaXRseS4pIElzIHRoZXJlIG5vICJyZWFz
b25hYmxlIGRlZmF1bHQiIHdlIGNvdWxkIHNlbGVjdCBmb3INCj4gPiB0eGZpZm9zeiBpZiBwcm9w
ZXJ0eSBpcyBtaXNzaW5nPw0KPiANCj4gVGhvc2UgYXJlIGdvb2QgcXVlc3Rpb25zLCBhbmQgSSBk
byBub3Qga25vdyBob3cgdG8gYW5zd2VyIHRoZW0gYXMgSSBhbQ0KPiBub3QgZmFtaWxpYXIgd2l0
aCB0aGUgc3RtbWFjIEhXIGRlc2lnbiwgYnV0IEkgYW0gaG9waW5nIEpvc2UgY2FuIHJlc3BvbmQN
Cj4gb24gdGhpcyBwYXRjaC4gSXQgZG9lcyBzb3VuZCBsaWtlIHByb3ZpZGluZyBhIGRlZmF1bHQg
VFggRklGTyBzaXplIHdvdWxkDQo+IHNvbHZlIHRoYXQgTVRVIHByb2JsZW0sIHRvbywgYnV0IHdp
dGhvdXQgYSAndHgtZmlmby1kZXB0aCcgcHJvcGVydHkNCj4gc3BlY2lmaWVkIGluIERldmljZSBU
cmVlLCBhbmQgd2l0aCB0aGUgImRtYV9jYXAiIGJlaW5nIGVtcHR5IGZvciB0aGlzDQo+IGNoaXAs
IEkgaGF2ZSBubyBpZGVhIHdoYXQgdG8gc2V0IGl0IHRvLg0KDQpVbmZvcnR1bmF0ZWx5LCBhbGx3
aW5uZXIgdXNlcyBHTUFDIHdoaWNoIGRvZXMgbm90IGhhdmUgYW55IG1lYW4gdG8gZGV0ZWN0IA0K
VFggRklGTyBTaXplLiBEZWZhdWx0IHZhbHVlIGluIEhXIGlzIDJrIGJ1dCB0aGlzIGNhbiBub3Qg
YmUgdGhlIGNhc2UgaW4gDQp0aGVzZSBwbGF0Zm9ybXMgaWYgSFcgdGVhbSBkZWNpZGVkIHRvIGNo
YW5nZSBpdC4NCg0KQW55d2F5LCB5b3VyIHBhdGNoIGxvb2tzIHNhbmUgdG8gbWUuIEJ1dCBpZiB5
b3Ugc3RhcnQgc2VlaW5nIFRYIFF1ZXVlIA0KVGltZW91dCBmb3IgaGlnaGVyIE1UVSB2YWx1ZXMg
dGhlbiB5b3UnbGwgbmVlZCB0byBhZGQgdHgtZmlmby1kZXB0aCANCnByb3BlcnR5Lg0KDQotLS0N
ClRoYW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=
