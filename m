Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC9B2D4544
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgLIPWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:22:24 -0500
Received: from mail-eopbgr130054.outbound.protection.outlook.com ([40.107.13.54]:57710
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726515AbgLIPWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 10:22:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEmB+AnQQGia81Vxrta+IX3Sbj7wawvjKFH7Odj3+i5BFFq1sjvFayyukGEyysdBHu31X9eSWjdeU1kQN2RTeVhL4MgTXMKKJE82mQUgq8VayOCBq7kvhQwR7O54BzMba4BqcvNKPFsKoaqg4inuMOdwpaESHf9SNGSgDBt7p/j9GnItWwLR47xERGjK1CInb6bW4RJqEAXWf2urKT+MpAyVP4wvPkxA0sZOQwBEnYTV68jljXdz66jNPssQfnl4VqQURZsTrSoewW96lZguDIWUE36eOuYcJdbNVyoYGrL+qLq3cu/bRXPR2tfj9PTnx3edJCemn7qgUNlPgt7+2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfdKzJ2J/9lHkKkwMQ09okfnRezYeFc/RYEGSwfOLFs=;
 b=ehxczlHeCL2Rbk/oF4ptAOp6W8uvfZyrvImDDVFTLUPeAoD5n+ww1SXFyHGXiQL9DQxKwcatdAm1ArTskjROZohztAOB5rj6dPglMl872Od3Bl0JhHIzeEuT6UGNpFxeGyW9PtpwxN2LL4p/3zj+Ma0BMQwnH15eUFgngsGpSuqN4LeZM5PuVMXJgFlJ9Rxt+0+iYzm4xLWMAUpV3qWTW4PSUeUDZqcAtRvfOc5gljFzB2SHLzbz5kGKcOlmCae76TbXu/15Fntf1tyJTI1vejYhVpAgmi6zmcnb5DKKUFoFYoFUZVTWAlnHxfrPhEwqHS4Vzqu1jOWArIdFFbMjjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=siemens.onmicrosoft.com; s=selector1-siemens-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfdKzJ2J/9lHkKkwMQ09okfnRezYeFc/RYEGSwfOLFs=;
 b=JiFNeU7wMaO9KINtq+FKz2VUkS2Ia/1cPNdWQfwFRuBqcTNLhetXZsnp64DD2bS6gy49lZaUSPzRVAkf6JmbhouZqDYXs53Bb82RN8RoyTGEnDGhHpD3zM9zyMjnUn7JsBENRdGjDuUxRE+hG26j8UHYh9S9KqX6brcSgewPNeo=
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:7c::28)
 by VI1PR10MB3342.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:132::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Wed, 9 Dec
 2020 15:21:34 +0000
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c4f9:99d0:c75:bc2f]) by VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c4f9:99d0:c75:bc2f%7]) with mapi id 15.20.3654.013; Wed, 9 Dec 2020
 15:21:34 +0000
From:   "Geva, Erez" <erez.geva.ext@siemens.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Ogness <john.ogness@linutronix.de>,
        Jon Rosen <jrosen@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin KaFai Lau <kafai@fb.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Xie He <xie.he.0141@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Molzahn, Ines" <ines.molzahn@siemens.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "Bucher, Andreas" <andreas.bucher@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler, Andreas" <andreas.zirkler@siemens.com>,
        "Sakic, Ermin" <ermin.sakic@siemens.com>,
        "anninh.nguyen@siemens.com" <anninh.nguyen@siemens.com>,
        "Saenger, Michael" <michael.saenger@siemens.com>,
        "Maehringer, Bernd" <bernd.maehringer@siemens.com>,
        "gisela.greinert@siemens.com" <gisela.greinert@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Subject: Re: [PATCH 1/3] Add TX sending hardware timestamp.
Thread-Topic: [PATCH 1/3] Add TX sending hardware timestamp.
Thread-Index: AQHWzjjS+JtwwiLyJkKEw3ObDmZ1g6nu2GGAgAAIlIA=
Date:   Wed, 9 Dec 2020 15:21:34 +0000
Message-ID: <VI1PR10MB244654C4B42E47DB5EBE0B05ABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
References: <20201209143707.13503-1-erez.geva.ext@siemens.com>
 <20201209143707.13503-2-erez.geva.ext@siemens.com>
 <CA+FuTScWkYn0Ur+aSuz1cREbQJO0fB6powOm8PFxze4v8JwBaw@mail.gmail.com>
In-Reply-To: <CA+FuTScWkYn0Ur+aSuz1cREbQJO0fB6powOm8PFxze4v8JwBaw@mail.gmail.com>
Accept-Language: en-GB, en-DE, he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Enabled=true;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SetDate=2020-12-09T15:21:31Z;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Method=Standard;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Name=restricted-default;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ActionId=3c36d3b6-b31c-4e53-91ab-9e6b087913e7;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ContentBits=0
document_confidentiality: Restricted
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=siemens.com;
x-originating-ip: [165.225.26.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0fb51a82-ecd4-457f-b25c-08d89c561d2c
x-ms-traffictypediagnostic: VI1PR10MB3342:
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR10MB334234AEB81ACE2661584677ABCC0@VI1PR10MB3342.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RIfp9dc8reD+jLyGGNk+ze/tXqcLfJBu4DrKTZLymlNETetARns+oppZ8UCHHD2MlANf06LCPzi53aQD98luaw9xSgkh1CLqWVX+kHhevTecQgfao8Ggx5AFVElk3+VELcmx9y/DnEki9eTu0WP27YTiWh9JoZqZjIxXMrUqT7ctyahq2K1KKZjRB+GJC4lpNj04VFtb4+zTsG1wO8az2YWF3qYmEAtHBuKvrhal5ZdGNRmz+ijuycEXACORLVlpT6X1EoXoz9pTa1E79eIa+cvNRMTYJvLb89VEG0Wu40y1NmMKNRGdlr+JOcrgdUz6NJwx0BW1QEMq5FHkOJkgnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(8936002)(66446008)(66946007)(66476007)(64756008)(66556008)(7696005)(26005)(53546011)(508600001)(6506007)(55236004)(76116006)(55016002)(8676002)(7416002)(7406005)(2906002)(71200400001)(9686003)(86362001)(6916009)(5660300002)(54906003)(83380400001)(4326008)(186003)(52536014)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VStMZm1FUWR6WktzUGxzdWRBcEZwNGUxM2FhUDAyN1Y4a2E3UE00cGpVUndX?=
 =?utf-8?B?KzdLb2g0YkNYbVNYOVNkVkZRL2p0S2puU1FRNHY4ajU2U0RnaXFlb21LTWZt?=
 =?utf-8?B?TEhHTVBJY1Z3OGZEcGtxSzVVL3B5UWFld0JCaXU4SXRsN1hpY09TZ3orWU1H?=
 =?utf-8?B?VzFadHFyaW1HVkNOdFlQMkc1ajU0NFUrcVBpbXpvMi9rYVhrTGpJaVpIZ2xa?=
 =?utf-8?B?SHAvY3lPOVl0UG9VMXN2bEV5Zkg0VURmRW91NFlYMjR4VlRaU2ZlUEh5SkY5?=
 =?utf-8?B?cjlCYUhEM1RXWUt6bmJxRlh1S09UMktON1pwREdzZE1WdHNZR1NNRkx6TW5I?=
 =?utf-8?B?NXdaQUNOaVhpd3Q2TUhWdGZPZUp0THFYQkMyN2JHd3h0ZTh1U05tSVloM2pV?=
 =?utf-8?B?K2NnNmI0a21mc0lwKzJNdm9yUTE4ayttMmZYTVJ2cXNUQXJpM2ZLSG9qSkJh?=
 =?utf-8?B?UEYzTjN2c3Y2YmZ4K0dkTDRDa0JpNHRBa1NxMXlmRkRRZTlLdHVWV1RzNmNV?=
 =?utf-8?B?WXF5bkdCb2x2WVZiNWlhMDdoQ0pta3RPNTRoMlk3YUp0WTVsaGlUaW5mdFlw?=
 =?utf-8?B?cVVDUS9NUGhlN1lBT2V2NG43NDdMdWRrZFFDazJVNkhRYTJsNGNHdVZvcTUv?=
 =?utf-8?B?QVhtYzN2N0pVOXQxOEgySG0yRjZNNEQweTlnSDFvSXJoYkVKUUlDbUxhUXBO?=
 =?utf-8?B?b3k2R0lLSWlnbm1sY1hNMXViNlJtd2NocFBSeTgvaEh5K1IwazhTRitKcnpm?=
 =?utf-8?B?STJRVFFjR0pzanZRTWp2WU4yU0hIS1FIM1lIbGx3M1VTZG81eUxjNmRpR0NR?=
 =?utf-8?B?NHJpdm8zY0xrQ0xWZXZvSGtnY3BBMmxNWlJBQTUrdlRTQ3ZIYk5BbkR1V1Yz?=
 =?utf-8?B?Q0hHckhiOXd0eU1NektucHA0eHE1VUlXZkduL0lDR1VpRUZSTmNTNHcrZ1l3?=
 =?utf-8?B?a05UcFIwd3lnNWdiLzF3N25RbmFid0ZqRGgxbWtpSlZpOHh0ekpnUDJUYWQ3?=
 =?utf-8?B?OWlwYkhKVGtnaEZUNUQ3ZHBEOTkvUlBlb2xOQVM4eHBnUTdRcGxUd0pvMUZi?=
 =?utf-8?B?SFNpV3lDNFFISXR4R2ovL1I0ZzU4eU9zbGhpY3RHQm9ZUlNlbm9PRGJQbVcz?=
 =?utf-8?B?em9WZVQzL0pKUG9mZFJiNHNKWVVtUnFmRFVZMEplaHBpZm16NjBUeUc3Zm14?=
 =?utf-8?B?dHJLWFdhSGJxRlV4cUJLTEgvK2JtQmxLcjVoOFNsZjdua3p4MjFyRzU5cDIz?=
 =?utf-8?B?UnVFRm0wS2FqdGx2dDFUUWIwQ1RWNDRaYmlNWHRHcEVGa213OFNNM0F5SGpu?=
 =?utf-8?Q?DV9+y9YuEkrv0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07CE9D19B50E974892854D8D7B1A3632@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb51a82-ecd4-457f-b25c-08d89c561d2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 15:21:34.1775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wa4o/B5fFflCdyi87hxisro+yC8vTIp071Zm+8Y6iX0ni9gTJkpWGu6YUhbUNcwPcL64W8Zla4SXBwmU8bzkZocVS0aNk6D39enL5K8UyZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB3342
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAwOS8xMi8yMDIwIDE1OjQ4LCBXaWxsZW0gZGUgQnJ1aWpuIHdyb3RlOg0KPiBPbiBXZWQs
IERlYyA5LCAyMDIwIGF0IDk6MzcgQU0gRXJleiBHZXZhIDxlcmV6LmdldmEuZXh0QHNpZW1lbnMu
Y29tPiB3cm90ZToNCj4+DQo+PiBDb25maWd1cmUgYW5kIHNlbmQgVFggc2VuZGluZyBoYXJkd2Fy
ZSB0aW1lc3RhbXAgZnJvbQ0KPj4gICB1c2VyIHNwYWNlIGFwcGxpY2F0aW9uIHRvIHRoZSBzb2Nr
ZXQgbGF5ZXIsDQo+PiAgIHRvIHByb3ZpZGUgdG8gdGhlIFRDIEVUQyBRZGlzYywgYW5kIHBhc3Mg
aXQgdG8NCj4+ICAgdGhlIGludGVyZmFjZSBuZXR3b3JrIGRyaXZlci4NCj4+DQo+PiAgIC0gTmV3
IGZsYWcgZm9yIHRoZSBTT19UWFRJTUUgc29ja2V0IG9wdGlvbi4NCj4+ICAgLSBOZXcgYWNjZXNz
IGF1eGlsaWFyeSBkYXRhIGhlYWRlciB0byBwYXNzIHRoZQ0KPj4gICAgIFRYIHNlbmRpbmcgaGFy
ZHdhcmUgdGltZXN0YW1wLg0KPj4gICAtIEFkZCB0aGUgaGFyZHdhcmUgdGltZXN0YW1wIHRvIHRo
ZSBzb2NrZXQgY29va2llLg0KPj4gICAtIENvcHkgdGhlIFRYIHNlbmRpbmcgaGFyZHdhcmUgdGlt
ZXN0YW1wIHRvIHRoZSBzb2NrZXQgY29va2llLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEVyZXog
R2V2YSA8ZXJlei5nZXZhLmV4dEBzaWVtZW5zLmNvbT4NCj4gDQo+IEhhcmR3YXJlIG9mZmxvYWQg
b2YgcGFjaW5nIGlzIGRlZmluaXRlbHkgdXNlZnVsLg0KPiANClRoYW5rcyBmb3IgeW91ciBjb21t
ZW50Lg0KSSBhZ3JlZSwgaXQgaXMgbm90IGxpbWl0ZWQgb2YgdXNlLg0KDQo+IEkgZG9uJ3QgdGhp
bmsgdGhpcyBuZWVkcyBhIG5ldyBzZXBhcmF0ZSBoL3cgdmFyaWFudCBvZiBTT19UWFRJTUUuDQo+
IA0KSSBvbmx5IGV4dGVuZCBTT19UWFRJTUUuDQoNCj4gSW5kZWVkLCB3ZSB3YW50IHBhY2luZyBv
ZmZsb2FkIHRvIHdvcmsgZm9yIGV4aXN0aW5nIGFwcGxpY2F0aW9ucy4NCj4gDQpBcyB0aGUgY29u
dmVyc2lvbiBvZiB0aGUgUEhDIGFuZCB0aGUgc3lzdGVtIGNsb2NrIGlzIGR5bmFtaWMgb3ZlciB0
aW1lLg0KSG93IGRvIHlvdSBwcm9wc2UgdG8gYWNoaXZlIGl0Pw0KDQo+IEl0IG9ubHkgcmVxdWly
ZXMgdGhhdCBwYWNpbmcgcWRpc2NzLCBib3RoIHNjaF9ldGYgYW5kIHNjaF9mcSwNCj4gb3B0aW9u
YWxseSBza2lwIHF1ZXVpbmcgaW4gdGhlaXIgLmVucXVldWUgY2FsbGJhY2sgYW5kIGluc3RlYWQg
YWxsb3cNCj4gdGhlIHNrYiB0byBwYXNzIHRvIHRoZSBkZXZpY2UgZHJpdmVyIGFzIGlzLCB3aXRo
IHNrYi0+dHN0YW1wIHNldC4gT25seQ0KPiB0byBkZXZpY2VzIHRoYXQgYWR2ZXJ0aXNlIHN1cHBv
cnQgZm9yIGgvdyBwYWNpbmcgb2ZmbG9hZC4NCj4gDQpJIGRpZCBub3QgdXNlICJGYWlyIFF1ZXVl
IHRyYWZmaWMgcG9saWNpbmciLg0KQXMgZm9yIEVURiwgaXQgaXMgYWxsIGFib3V0IG9yZGVyaW5n
IHBhY2tldHMgZnJvbSBkaWZmZXJlbnQgYXBwbGljYXRpb25zLg0KSG93IGNhbiB3ZSBhY2hpdmUg
aXQgd2l0aCBza2lwaW5nIHF1ZXVpbmc/DQpDb3VsZCB5b3UgZWxhYm9yYXRlIG9uIHRoaXMgcG9p
bnQ/DQoNClRoYW5rcw0KRXJleg0K
