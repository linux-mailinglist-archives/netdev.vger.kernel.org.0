Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CCA2D782C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 15:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406319AbgLKOpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:45:31 -0500
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:12868
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405723AbgLKOpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 09:45:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfX4h1DwLG1fmWi5gVf+lYjys1bC+JzCCIrAjIlKwQULJosomPhOAyHVk2ABHGZG/Bj8D3xDVQP7nritFeUXQxI1sOZyY7oYeCjV8d5wsVztEsonmLWtdQAnIYsLkvvw9iXl1ovLbipZafdJiBzNBiLXIYQBxPsX23KLAFRNmnJy/2fAmojFMhxK/Gi3+sP7IRL7XF+5NVVdIfQ5Hyw3BNAyHDMJieOWrwJlW/gN3Ca9a2HHvxSu6S/nUnf09wgsRUM+LBsUUhQ83JyLYZ+JaEZaMuhS5Z/N6tLFVut1QzIdFX73rBRY/MSFqXgGjc5TpG7cSC2F1hn5sn25BOU5dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2KZhC9pQt+f2jihvAtgqstuvpikiBdqdrlM7qlYZzs=;
 b=I8ilDz+r9X3nSCZzasT3TT4myeqDVLeZvThVvQRHIyOzF/5yyJ0KP0pQh7gDy1x10A9ZQXPaFMBCZMQM6qS0UGoAhrV1caoeenbeEh4Fn1jBhsHu87sIxOLG6xbgDd6rhaQi0N1gGnndJoEK24Wxx4a6Mk7slh3LUCK7KjoKS9Quk7vP03PCNKTHJ9o4lBZu/ieCHwb3dhyRloKRYdVbPidj9mWefdgzkiaJWaA5Jbcr0OymFyrcwDVdWTJd7gnCdH8XUtmD+Rp5nt/kZ45EufCj9qQQxTY1IqZZUCABxSSH9tIfJP8lg0WC87oV1/AjeNXvgX55yFNIJTvGYkBDDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=siemens.onmicrosoft.com; s=selector1-siemens-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2KZhC9pQt+f2jihvAtgqstuvpikiBdqdrlM7qlYZzs=;
 b=cItzF4tRbXiUG2uR8CGNDUDJBFxCtLLRuVtkZ40QWP6zAP60u373JURg7yCKNbCfiC0XuOVsk41HsCCg9YUWyajTOKveMB2WTyBMvMeWZ7XbBpS0Tk62cqkAdUpnYX9S889eO3uv0pF5LeCcwzZBX/dQ81M5/njQqjmdL+hamjI=
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:7c::28)
 by VI1PR10MB3136.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:13e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Fri, 11 Dec
 2020 14:44:22 +0000
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c4f9:99d0:c75:bc2f]) by VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c4f9:99d0:c75:bc2f%7]) with mapi id 15.20.3654.013; Fri, 11 Dec 2020
 14:44:22 +0000
From:   "Geva, Erez" <erez.geva.ext@siemens.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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
        Vedang Patel <vedang.patel@intel.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler, Andreas" <andreas.zirkler@siemens.com>
Subject: Re: [PATCH 1/3] Add TX sending hardware timestamp.
Thread-Topic: [PATCH 1/3] Add TX sending hardware timestamp.
Thread-Index: AQHWzjjS+JtwwiLyJkKEw3ObDmZ1g6nu2GGAgAAIlICAACaHgIAAFaqAgAGXBoCAAAn5AIAAPmYAgAAP2ICAAOGyAA==
Date:   Fri, 11 Dec 2020 14:44:21 +0000
Message-ID: <VI1PR10MB24469F42655B66B16DF25B6DABCA0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
References: <20201209143707.13503-1-erez.geva.ext@siemens.com>
 <20201209143707.13503-2-erez.geva.ext@siemens.com>
 <CA+FuTScWkYn0Ur+aSuz1cREbQJO0fB6powOm8PFxze4v8JwBaw@mail.gmail.com>
 <VI1PR10MB244654C4B42E47DB5EBE0B05ABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CA+FuTSd7oB0qO707W6htvs=FOJn10cgSQ4_iGFz4Sk9URXtZiw@mail.gmail.com>
 <VI1PR10MB2446ACEACAE1F3671682407FABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CAF=yD-LkknU3GwJgG_OiMPFONZtO3ECHEX0QfTaUTTX_N0i-KA@mail.gmail.com>
 <VI1PR10MB24460D805E8091EB09F81199ABCB0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CAF=yD-Lf=JpkXvGs=AGtyhCEFcG_8_WgnNbg1cbGownohsHw8g@mail.gmail.com>
 <87r1nxxk3u.fsf@intel.com>
In-Reply-To: <87r1nxxk3u.fsf@intel.com>
Accept-Language: en-GB, en-DE, he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Enabled=true;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SetDate=2020-12-11T14:44:19Z;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Method=Standard;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Name=restricted-default;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ActionId=556f42b3-cd79-4e43-9d68-89a47ea98444;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ContentBits=0
document_confidentiality: Restricted
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=siemens.com;
x-originating-ip: [165.225.26.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 22c27694-8cea-448c-f2a3-08d89de33f76
x-ms-traffictypediagnostic: VI1PR10MB3136:
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR10MB3136762434BAA17ED4AD64DEABCA0@VI1PR10MB3136.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OgkWiCLf1r3R5+7CnxQmviQRffHYgOzuHtjwijZtLlyJPi02FRQB0O58GJ5l3xZqVtD3CFwnIezEQBeWORIoll6woZtBgc31C/xUM2XMiQbrR9d/UK6fDq0oj8wkSDj0fb+7ijO8UJrhROEadCtt+4pTJXhED5YBQwXIFAILCh5bTAEokPsZazP1H4ZxUXn7rTBkR5odqd9uD1zAOxy9LStJNutR7JfJBYdZH4Kr1DO2FFd+zZvUjs5TMAnL+WhUIBk7tHwlJ8eslhhNJMTpczdS22ILpCG49idVOZGs9uECWkZSIZG0iQMrrG6m7v3eV7G/XJqUqdtQqg+r9nnyXBkRFwSiLlQtI68i9kfOL3Ph/UxVe/c8xJfroi4xxGf+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(6506007)(8676002)(66476007)(83380400001)(7406005)(107886003)(66446008)(110136005)(7696005)(186003)(52536014)(5660300002)(2906002)(86362001)(76116006)(316002)(8936002)(66946007)(55016002)(478600001)(71200400001)(4326008)(54906003)(53546011)(26005)(66556008)(64756008)(55236004)(7416002)(9686003)(33656002)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cnBRUW5UNERzYk9XNmVaeFRRUVhqa3BxL0xGTkZVbCtqUmZaaGk4TzRWblFI?=
 =?utf-8?B?S0xuZnAwTmNaMEloTGZNcTkybjN6ZXFtcVJSMlhOMmlpMTdWY2FjY01jdWZQ?=
 =?utf-8?B?dGhpaUZ1VDdlanFiZHNVa1JVdWRyd3JPTjNvRlJiNTAzbTNmbHdQbXZkaWw3?=
 =?utf-8?B?RzdwdSsvUFdWckY4T0w4OTJiVzZNYmJXWm0wUXluckpQSHYwWGlqNUR4bitZ?=
 =?utf-8?B?TFMzTUZsRXFDVlU1RGNMQmpOOVo1Tm84aktqSmxkN1VQeWJ5R1YrOEh1bHRr?=
 =?utf-8?B?TjVBcmh6QzJ0dlprR2tPRUZtMzFHN2lyUTZWYTZiWWs5NDBFRDU5d3JSREpV?=
 =?utf-8?B?WHJITi81S1F3WTV3NkI5SjliV0dtKzZsaFdGb0JPODRFQTR4WjBGeGFjR3Fu?=
 =?utf-8?B?QXFmZk93RlhYL1M1Zi94TDNHL29rYUtTSVdIaTdaZlk5NS9SVHRUTEcyVG1w?=
 =?utf-8?B?Y0FIakJ0NHc4RVcxM1FjanZaaHFWcU9QYW91Ry9PRUNqM2dBNXhuVHo5V3Zu?=
 =?utf-8?B?cUtKbUhYamVmRUNPTXZaV2liMGxpZ1lWVzh2L3JUN0NyZUNWd1VYNmNvMGFt?=
 =?utf-8?B?Rlhnd2VrcjFkYkc0ZnVSWnVBa0hXQTVnRFl0aVRFUDFCS1Nac0JuNTZRRzFx?=
 =?utf-8?B?bVJTRFEyU1IyNnV3eHp1cHhFTndaSlhSZ1U5eSthNHFpbzZSU1d6Yk5pRERS?=
 =?utf-8?B?ZFAyaVJ6QTVRS1pTc0xKUG4yQjJmak9jNGJDZSthWkxQa00veTIwRC9FYnpq?=
 =?utf-8?B?Vms1WjFjZ3l3SEpXY0JmTVJWWXk0enEzdnd5bnBqZnlTdWJNbFZLaENqZDZ3?=
 =?utf-8?B?REl0a1ZPa2ZtSGtZVy9uZUtGdVZiWWg0MEhYdHpiRk1PZ1VEQVUxZ0Jkc0ZV?=
 =?utf-8?B?R0w0N3BzTk5VaEhNdUF2V1UyUDFzZ29IUTd1Y2JyRllkalYrRG9Zd3NtaStI?=
 =?utf-8?B?OTRDMUp4V050Y0x4c1dlaGdFS0I1RVk1cGlvNW9uWlM0THRVSk5adkhHOGhr?=
 =?utf-8?B?a0V1L3FhcDZzQWRyM2JIVDNTeS96VnZGd3hQWVkrTjFmbHpnZE40eWFlK0pU?=
 =?utf-8?B?dTdzeDQ2bVAxSHo4ZDFrbU90L3hDWkovbkFTa3pvdjI2b28xUTI0TDd3M2g1?=
 =?utf-8?B?ZVNuWnVpZXNya3l6bFgwM2tXbFIwY3VPRG5aNjI3S3VrS3IzWno0YUFLMkxF?=
 =?utf-8?B?WmtLbXN3b1BwWE5EbUVLSE4vTm10Y1FnMVpLaGhVTnU0cUZuamRMSjVaVWRJ?=
 =?utf-8?B?L0pOWjgrcWtBTWVYNkFwMit2d1ZHTy9DMmpJYTdIQWFCckNNZTFubGt4dVNL?=
 =?utf-8?Q?6w9efTAg+pxDE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B854A251D02C0E4DB4F247601B897464@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 22c27694-8cea-448c-f2a3-08d89de33f76
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2020 14:44:21.7863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HSM22NaRLJLI3fEHWaKIjx4Dr0qLUgqOPJngPikhiS29nVTXthytDd2qLxFxCjpSUkhyW6N7Xuqr79hadrC48pnn1EetCzWy5zxS5GsfJ7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB3136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxMS8xMi8yMDIwIDAxOjI3LCBWaW5pY2l1cyBDb3N0YSBHb21lcyB3cm90ZToNCj4gV2ls
bGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT4gd3JpdGVzOg0K
Pg0KPj4+PiBJZiBJIHVuZGVyc3RhbmQgY29ycmVjdGx5LCB5b3UgYXJlIHRyeWluZyB0byBhY2hp
ZXZlIGEgc2luZ2xlIGRlbGl2ZXJ5IHRpbWUuDQo+Pj4+IFRoZSBuZWVkIGZvciB0d28gc2VwYXJh
dGUgdGltZXN0YW1wcyBwYXNzZWQgYWxvbmcgaXMgb25seSBiZWNhdXNlIHRoZQ0KPj4+PiBrZXJu
ZWwgaXMgdW5hYmxlIHRvIGRvIHRoZSB0aW1lIGJhc2UgY29udmVyc2lvbi4NCj4+Pg0KPj4+IFll
cywgYSBjb3JyZWN0IHBvaW50Lg0KPj4+DQo+Pj4+DQo+Pj4+IEVsc2UsIEVURiBjb3VsZCBwcm9n
cmFtIHRoZSBxZGlzYyB3YXRjaGRvZyBpbiBzeXN0ZW0gdGltZSBhbmQgbGF0ZXIsDQo+Pj4+IG9u
IGRlcXVldWUsIGNvbnZlcnQgc2tiLT50c3RhbXAgdG8gdGhlIGgvdyB0aW1lIGJhc2UgYmVmb3Jl
DQo+Pj4+IHBhc3NpbmcgaXQgdG8gdGhlIGRldmljZS4NCj4+Pg0KPj4+IE9yIHRoZSBza2ItPnRz
dGFtcCBpcyBIVyB0aW1lLXN0YW1wIGFuZCB0aGUgRVRGIGNvbnZlcnQgaXQgdG8gc3lzdGVtIGNs
b2NrIGJhc2VkLg0KPj4+DQo+Pj4+DQo+Pj4+IEl0J3Mgc3RpbGwgbm90IGVudGlyZWx5IGNsZWFy
IHRvIG1lIHdoeSB0aGUgcGFja2V0IGhhcyB0byBiZSBoZWxkIGJ5DQo+Pj4+IEVURiBpbml0aWFs
bHkgZmlyc3QsIGlmIGl0IGlzIGhlbGQgdW50aWwgZGVsaXZlcnkgdGltZSBieSBoYXJkd2FyZQ0K
Pj4+PiBsYXRlci4gQnV0IG1vcmUgb24gdGhhdCBiZWxvdy4NCj4+Pg0KPj4+IExldCBwbG90IGEg
c2ltcGxlIHNjZW5hcmlvLg0KPj4+IEFwcCBBIHNlbmQgYSBwYWNrZXQgd2l0aCB0aW1lLXN0YW1w
IDEwMC4NCj4+PiBBZnRlciBhcnJpdmUgYSBzZWNvbmQgcGFja2V0IGZyb20gQXBwIEIgd2l0aCB0
aW1lLXN0YW1wIDkwLg0KPj4+IFdpdGhvdXQgRVRGLCB0aGUgc2Vjb25kIHBhY2tldCB3aWxsIGhh
dmUgdG8gd2FpdCB0aWxsIHRoZSBpbnRlcmZhY2UgaGFyZHdhcmUgc2VuZCB0aGUgZmlyc3QgcGFj
a2V0IG9uIDEwMC4NCj4+PiBNYWtpbmcgdGhlIHNlY29uZCBwYWNrZXQgbGF0ZSBieSAxMCArIGZp
cnN0IHBhY2tldCBzZW5kIHRpbWUuDQo+Pj4gT2J2aW91c2x5IG90aGVyICJub3JtYWwiIHBhY2tl
dHMgYXJlIHNlbmQgdG8gdGhlIG5vbi1FVEYgcXVldWUsIHRob3VnaCB0aGV5IGRvIG5vdCBibG9j
ayBFVEYgcGFja2V0cw0KPj4+IFRoZSBFVEYgZGVsdGEgaXMgYSBiYXJyaWVyIHRoYXQgdGhlIGFw
cGxpY2F0aW9uIGhhdmUgdG8gc2VuZCB0aGUgcGFja2V0IGJlZm9yZSB0byBlbnN1cmUgdGhlIHBh
Y2tldCBkbyBub3QgdG9zc2VkLg0KPj4NCj4+IEdvdCBpdC4gVGhlIGFzc3VtcHRpb24gaGVyZSBp
cyB0aGF0IGRldmljZXMgYXJlIEZJRk8uIFRoYXQgaXMgbm90DQo+PiBuZWNlc3NhcmlseSB0aGUg
Y2FzZSwgYnV0IEkgZG8gbm90IGtub3cgd2hldGhlciBpdCBpcyBpbiBwcmFjdGljZSwNCj4+IGUu
Zy4sIG9uIHRoZSBpMjEwLg0KPg0KPiBPbiB0aGUgaTIxMCBhbmQgaTIyNSwgdGhhdCdzIGluZGVl
ZCB0aGUgY2FzZSwgaS5lLiBvbmx5IHRoZSBsYXVuY2ggdGltZQ0KPiBvZiB0aGUgcGFja2V0IGF0
IHRoZSBmcm9udCBvZiB0aGUgcXVldWUgaXMgY29uc2lkZXJlZC4NCj4NCj4gWy4uLl0NCj4NCj4+
Pj4+Pj4+IEl0IG9ubHkgcmVxdWlyZXMgdGhhdCBwYWNpbmcgcWRpc2NzLCBib3RoIHNjaF9ldGYg
YW5kIHNjaF9mcSwNCj4+Pj4+Pj4+IG9wdGlvbmFsbHkgc2tpcCBxdWV1aW5nIGluIHRoZWlyIC5l
bnF1ZXVlIGNhbGxiYWNrIGFuZCBpbnN0ZWFkIGFsbG93DQo+Pj4+Pj4+PiB0aGUgc2tiIHRvIHBh
c3MgdG8gdGhlIGRldmljZSBkcml2ZXIgYXMgaXMsIHdpdGggc2tiLT50c3RhbXAgc2V0LiBPbmx5
DQo+Pj4+Pj4+PiB0byBkZXZpY2VzIHRoYXQgYWR2ZXJ0aXNlIHN1cHBvcnQgZm9yIGgvdyBwYWNp
bmcgb2ZmbG9hZC4NCj4+Pj4+Pj4+DQo+Pj4+Pj4+IEkgZGlkIG5vdCB1c2UgIkZhaXIgUXVldWUg
dHJhZmZpYyBwb2xpY2luZyIuDQo+Pj4+Pj4+IEFzIGZvciBFVEYsIGl0IGlzIGFsbCBhYm91dCBv
cmRlcmluZyBwYWNrZXRzIGZyb20gZGlmZmVyZW50IGFwcGxpY2F0aW9ucy4NCj4+Pj4+Pj4gSG93
IGNhbiB3ZSBhY2hpdmUgaXQgd2l0aCBza2lwaW5nIHF1ZXVpbmc/DQo+Pj4+Pj4+IENvdWxkIHlv
dSBlbGFib3JhdGUgb24gdGhpcyBwb2ludD8NCj4+Pj4+Pg0KPj4+Pj4+IFRoZSBxZGlzYyBjYW4g
b25seSBkZWZlciBwYWNpbmcgdG8gaGFyZHdhcmUgaWYgaGFyZHdhcmUgY2FuIGVuc3VyZSB0aGUN
Cj4+Pj4+PiBzYW1lIGludmFyaWFudHMgb24gb3JkZXJpbmcsIG9mIGNvdXJzZS4NCj4+Pj4+DQo+
Pj4+PiBZZXMsIHRoaXMgaXMgd2h5IHdlIHN1Z2dlc3QgRVRGIG9yZGVyIHBhY2tldHMgdXNpbmcg
dGhlIGhhcmR3YXJlIHRpbWUtc3RhbXAuDQo+Pj4+PiBBbmQgcGFzcyB0aGUgcGFja2V0IGJhc2Vk
IG9uIHN5c3RlbSB0aW1lLg0KPj4+Pj4gU28gRVRGIHF1ZXJ5IHRoZSBzeXN0ZW0gY2xvY2sgb25s
eSBhbmQgbm90IHRoZSBQSEMuDQo+Pj4+DQo+Pj4+IE9uIHdoaWNoIG5vdGU6IHdpdGggdGhpcyBw
YXRjaCBzZXQgYWxsIGFwcGxpY2F0aW9ucyBoYXZlIHRvIGFncmVlIHRvDQo+Pj4+IHVzZSBoL3cg
dGltZSBiYXNlIGluIGV0Zl9lbnF1ZXVlX3RpbWVzb3J0ZWRsaXN0LiBJbiBwcmFjdGljZSB0aGF0
DQo+Pj4+IG1ha2VzIHRoaXMgaC93IG1vZGUgYSBxZGlzYyB1c2VkIGJ5IGEgc2luZ2xlIHByb2Nl
c3M/DQo+Pj4NCj4+PiBBIHNpbmdsZSBwcm9jZXNzIHRoZW9yZXRpY2FsbHkgZG9lcyBub3QgbmVl
ZCBFVEYsIGp1c3Qgc2V0IHRoZSBza2ItPiB0c3RhbXAgYW5kIHVzZSBhIHBhc3MgdGhyb3VnaCBx
dWV1ZS4NCj4+PiBIb3dldmVyIHRoZSBvbmx5IHdheSBub3cgdG8gc2V0IFRDX1NFVFVQX1FESVND
X0VURiBpbiB0aGUgZHJpdmVyIGlzIHVzaW5nIEVURi4NCj4+DQo+PiBZZXMsIGFuZCBJJ2QgbGlr
ZSB0byBldmVudHVhbGx5IGdldCByaWQgb2YgdGhpcyBjb25zdHJhaW50Lg0KPj4NCj4NCj4gSSdt
IGludGVyZXN0ZWQgaW4gdGhlc2Uga2luZCBvZiBpZGVhcyA6LSkNCj4NCj4gV2hhdCB3b3VsZCBi
ZSB5b3VyIGVuZCBnb2FsPyBTb21ldGhpbmcgbGlrZToNCj4gICAtIEFueSBhcHBsaWNhdGlvbiBp
cyBhYmxlIHRvIHNldCBTT19UWFRJTUU7DQo+ICAgLSBXZSB3b3VsZCBoYXZlIGEgYmVzdCBlZmZv
cnQgc3VwcG9ydCBmb3Igc2NoZWR1bGluZyBwYWNrZXRzIGJhc2VkIG9uDQo+ICAgdGhlaXIgdHJh
bnNtaXNzaW9uIHRpbWUgZW5hYmxlZCBieSBkZWZhdWx0Ow0KPiAgIC0gSWYgdGhlIGhhcmR3YXJl
IHN1cHBvcnRzLCB0aGVyZSB3b3VsZCBiZSBhICJvZmZsb2FkIiBmbGFnIHRoYXQgY291bGQNCj4g
ICBiZSBlbmFibGVkOw0KPg0KPiBNb3JlIG9yIGxlc3MgdGhpcz8NCg0KQWN0aXZhdGUgdGhlIFNP
X1RYVElNRSBpcyB3aGF0IGNhdXNlIHRoZSBTS0IgdG8gZW50ZXIgdGhlIG1hdGNoaW5nIEVURiBR
RElTQy4NCklmIHRoZSBFVEYgUURJU0MgaXMgbm90IHNldCB0aGUgU0tCIHdpbGwgcGFzcyBkaXJl
Y3RseSB0byB0aGUgZHJpdmVyLg0KT3IgaWYgdGhlIFNPX1RYVElNRSBDbG9jayBJRCBpcyBub3Qg
VEFJLg0KU28gYXBwbGljYXRpb24gY2FuIHVzZSB0aGUgU09fVFhUSU1FIGFzIGlzIGFuZCBzZXQg
dGhlIHNrYi0+IHRzdGFtcC4NCk5vIG5lZWQgdG8gY2hhbmdlIGFueXRoaW5nIGZvciBTT19UWFRJ
TUUuDQoNCkFzIGZvciBzZXR0aW5nIFRDX1NFVFVQX1FESVNDX0VURiBvbiBhIGRyaXZlciBxdWV1
ZS4NCldlIGNhbiBhZGQgbmV0LWxpbmsgbWVzc2FnZSB1c2luZyB0aGUgbmV0LWxpbmsgcHJvdG9j
b2wuDQpIb3cgYWJvdXQgb3RoZXIgVENfU0VUVVBfUURJU0NfWFhYIGxpa2UgQ0JTPw0KDQo+DQo+
DQo+IENoZWVycy4NCj4NCg==
