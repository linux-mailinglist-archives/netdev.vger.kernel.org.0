Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC70D381010
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 20:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhENSxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 14:53:49 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:54806 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231166AbhENSxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 14:53:44 -0400
Received: from mailhost.synopsys.com (badc-mailhost4.synopsys.com [10.192.0.82])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8998840228;
        Fri, 14 May 2021 18:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1621018352; bh=hlhT9LqnygK41oShNkAbfp12nOBteIrA228h8aIkrQA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=NEjSRw9KUR8Kn8qDa7FLEaMSerIOho1TfKgXqP64e4ozQDUy8fAMb8ihl4IUs0P2W
         YiHIvACN9Mp3CcSzg1JA0ET5YIxbQE4Wvsbcn+mm4lwRq1vvBriUm7lvklWMC+12YN
         4TiedOuC42tHKsukOQmsNyzcfUs8nbAvoAwJCqJYwHIpsl/xY+ssAHOBF783bCZlQ+
         Jpxu3hDkZGp8VtuHIkXJ+7rBf5A/ipvZLmmCixr29Un8lUKp9ZtFMJYaPTR+xvS6Z/
         fHGUZVaf+AP7lt8pAhN7hPUrP2cLtw3Bluf8Pf1RRZx1wJg0snLAnJmsJgH9BGbSKj
         Mi5EeCjqTh2Xw==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id F2ADFA0060;
        Fri, 14 May 2021 18:52:11 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id D293640139;
        Fri, 14 May 2021 18:52:01 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=vgupta@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="KOBhVvri";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wij2GSqqBaiWQIOnJgX1byIdGb9tFRktvjOj4CbTj1ePyK97Y/hGH5fTd7UqW3g1nsDhYgYJm623hhN5WeS7CssiQGYi4rVgvZiLFF2y2vs7QhEUZ24sDuAzjcBHwMMsYCiPHmOM5KeYkfYRXh0bF7312KyZ8xvpwOWvn1kXxljkYCQd+CD2mhGM4iECfayLfi2wlavCDedEhLS2W+GiAI/8Pbz8QmyCHoW5RFyYmozOgcyPzt59T/j2eD95/pi3EeMVHVyw8PsXFeg1TUUMWhCgdGJmCG9BxKVv49Y0Cbd1zU4NPtpxUwKxxvIFfJjSg050UPXoJ/et1KmpRz+STA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlhT9LqnygK41oShNkAbfp12nOBteIrA228h8aIkrQA=;
 b=iG5Wn1gIElYQdsBSb6ryuPK9gvp4VwVKj4lpmI6j5ieCBSnyDdHutyV32aMkU/MUYlGMZZuB8VynF/RjTQUN9Whs6Wk+/62RqUZpdJh3rWnLY7eq8KYZdHt/ZMk1LkIHfHhml7xVBDzTBurPX/EuKUjViSHE84D+PNB/qxZCcCSHaHy+vk+vriC2EGOU5Eqk7vE8uhfMmgb1jfD7WkL0KM3Lad8obCYnayFRHVsW3XRP/Q+o+zUsl8yNukbN7We0uQfxNrfCBFtLB0Byimvv5FnFrm3eMRtRkO3URko636+yycZo55pv9oXPGfdBrIJF3F3vrtCjPR1y3Gpg64Pg0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlhT9LqnygK41oShNkAbfp12nOBteIrA228h8aIkrQA=;
 b=KOBhVvrihDHooW3XKKKpBWhcuGlulxUppCWglgUrRUHFkJkpNAmUJFn/BZY3xnb3O9cd9n7V2O9rxi8jJR9RapcnA2XPfavAYs+sAn0HFwT62qVBk96nWuFz9CElVVsiwqONJ0twPTxlDByE26xISXOtcAN9Fs8h4WsP7+/pgms=
Received: from BYAPR12MB3479.namprd12.prod.outlook.com (2603:10b6:a03:dc::26)
 by BYAPR12MB3016.namprd12.prod.outlook.com (2603:10b6:a03:dc::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Fri, 14 May
 2021 18:51:59 +0000
Received: from BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::d1a0:ed05:b9cc:e94d]) by BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::d1a0:ed05:b9cc:e94d%7]) with mapi id 15.20.4108.036; Fri, 14 May 2021
 18:51:59 +0000
X-SNPS-Relay: synopsys.com
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@kernel.org>
CC:     linux-arch <linux-arch@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Borislav Petkov <bp@alien8.de>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morris <jmorris@namei.org>, Jens Axboe <axboe@kernel.dk>,
        John Johansen <john.johansen@canonical.com>,
        Jonas Bonn <jonas@southpole.se>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rich Felker <dalias@libc.org>,
        "Richard Russon (FlatCap)" <ldm@flatcap.org>,
        Russell King <linux@armlinux.org.uk>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Stafford Horne <shorne@gmail.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "openrisc@lists.librecores.org" <openrisc@lists.librecores.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-sparc <sparclinux@vger.kernel.org>,
        "linux-ntfs-dev@lists.sourceforge.net" 
        <linux-ntfs-dev@lists.sourceforge.net>,
        linux-block <linux-block@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 00/13] Unify asm/unaligned.h around struct helper
Thread-Topic: [PATCH v2 00/13] Unify asm/unaligned.h around struct helper
Thread-Index: AQHXSKg19FKoFxcBX0+yXT8p8kMtfqrjPPKAgAAWKgA=
Date:   Fri, 14 May 2021 18:51:59 +0000
Message-ID: <2408c893-4ae7-4f53-f58c-497c91f5b034@synopsys.com>
References: <20210514100106.3404011-1-arnd@kernel.org>
 <CAHk-=whGObOKruA_bU3aPGZfoDqZM1_9wBkwREp0H0FgR-90uQ@mail.gmail.com>
In-Reply-To: <CAHk-=whGObOKruA_bU3aPGZfoDqZM1_9wBkwREp0H0FgR-90uQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
authentication-results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=synopsys.com;
x-originating-ip: [149.117.75.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 687cc2a5-d804-4fb1-684b-08d917095ae4
x-ms-traffictypediagnostic: BYAPR12MB3016:
x-microsoft-antispam-prvs: <BYAPR12MB3016131C9A9D0112DE57094BB6509@BYAPR12MB3016.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8XTc0fd9c2qK5R9/x2oghiB3tZ/3cjoD3/oLzvBXiOko2msHr5UjgEHaf+II4FYEo0+BWMGanxhrtD+9xxFlgDUjYw409QhW4gHHcNff9TIszBZROPOPCJUaPP62mqy9QTb4KH5y0z3joi1GeJLFTB+zAFxfFu5FuG/NBguxv/78X+giEIhtkvLVLoola+BjeGyXlwSBo7cj5nTH5cAeM6Hmfb5eWsqloXSl62CaUBHQevzQtdhO6cULbEYFzCXKa4m4rnaOZMi+OEeH8OYgtB2yvRDoAhZAd1VuNvLwXfMHKRB2SVh+0+xXT4g4Ur/FHtyBIIVMenEwAt7Hdtvrhz24a1yTAK3tjY0hJfo3JxrpuZERH1fvOdf1UOcp4g9q1JtgWjCMz+fwnRMD/SquPRPojvfx1PiYrlXaptx8V7moesYBNoIEFAMvG9FfLtpbUB2LO6JjKqqTbzQ+DAPgxSh+BSsmPeXfSGSlVCnScSzQ2BLQyz2wwkz7j25INWGmLaNovVf3cmpzRVf/L+ad5Cr4HjErKqayKOAx5qjrnAvz9PZQwywg2IkuTM00GqWq6q/pw2QQNe83B+UXOJ8I+HLPQ1E9XQqTFkXVLqHA9BLgMtzow6WJdrBIhc6LfjTeDoC9y/pqDs949UQAXFk3S1TYo6yMYIxWxAf9eoUqHeU+xbGms2eNp7V5rQ952GgB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3479.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(136003)(39860400002)(366004)(186003)(38100700002)(6486002)(66446008)(76116006)(66946007)(64756008)(66556008)(122000001)(7416002)(6512007)(36756003)(71200400001)(478600001)(66476007)(2906002)(8676002)(31696002)(8936002)(26005)(6506007)(316002)(53546011)(2616005)(4744005)(54906003)(110136005)(5660300002)(31686004)(7406005)(4326008)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UmlpeERtclhWK3Y0blYzNmFPWlFxK2YzWlZNK0xvOUdhNWtJbVNUWFJZSTVH?=
 =?utf-8?B?WE5aMUFRTFV6Q3FHZ05RYU4wMk1aYzJLVXZBVnJCNitIT0FYWTZXanl5VEJr?=
 =?utf-8?B?RVFQb0VqaWNmZmNzdEhVdGhFK2I5N21mRWJxYmxYR0RSbE1KRk9VOXZDS25w?=
 =?utf-8?B?Wjd0RzZhVUZxYy9mVUpRbFdXOXhEL0hrRDdQL2V0ZnhpUFdQUlpTSXcxRjZu?=
 =?utf-8?B?QTN1TlJsNGtiUU5XODFNcXZod211NUtvb2hMZ2lvQ0J4ZFRtamVMZVRWK2FY?=
 =?utf-8?B?ajc1WVJuQWNKMWQvRXJ1dnpab0tuZWVBTU9mQjZRbHlLMldGRzIzUytZSjdI?=
 =?utf-8?B?SHU1VWhZVVdwd1lpemJON0FFNitWTW0xWFJZVmFuVkgxY2xZMUk5c0IvWGFJ?=
 =?utf-8?B?SE9uZ1lZOUhDSTZnbFdnaDQxU1ZKV3VOdjlCam9OblZXaTA5NzNvZ1VTK1lZ?=
 =?utf-8?B?UXBiNWZhZ3IvNXkvd3h2aWwzbm1tR0NPSlU1b0QwSmlXdHpvUXlrcWtGenV0?=
 =?utf-8?B?REc1VUdWQTRPdHJaWEpMMXdXQU5adGJBVlQ1NXpYUW84V2dCUERjZzVSTXUv?=
 =?utf-8?B?MnprUDdQaDFiL0owSUcrL0d5K2UxS1FWZGFoL0laeDNFWVNOWFcvZ1VqUWNx?=
 =?utf-8?B?OXR4T2kySEVmWnZkazBESGZoUmZ4bC9IblprMUtLbUY3UWFtalY3SjdqYjFm?=
 =?utf-8?B?YzA3RGF5ZGRoc0VCY2dLNkpKM1poVktxU1lWUVIrTG1mOXEyK1FPcTYxd0NT?=
 =?utf-8?B?UzdoTEJxOGhadzU3dGYveGpPaUFpUGgxam5MRVk4NG1CZmQ2QmlDQUFCOVVQ?=
 =?utf-8?B?QnUyVUpyUkxmKzE5cFhpajlVRnllSHJPMHllNUd5QjhQQUFCMHZ5WFRsNmZP?=
 =?utf-8?B?cUVNejd5UjA1b054aWczbzgwSFkvSVlVVEZvdGc5bE9EZlpzWmdUdG1FVktw?=
 =?utf-8?B?aEtvclUrY2ZQS1pYWWV1dXdhLzhSM1VsWTNHQzRlMG1vbTRVOWYwaWhOWThC?=
 =?utf-8?B?WFZGbGdEZXFBWnJFeVVlYjl6a3lHWmxIVmdpVS90MEU0ODh3NnlRK3M4NVg1?=
 =?utf-8?B?eUsvaitoUFRRWHVqa1FqWXlscTNndHFER1Z6KysxYXBTK2poa0lzSG5EZU93?=
 =?utf-8?B?SmVjRHdNNUxrY3NlbDhrWGxONGtOaEo2WENlUXBJQUNCM2N1VmdoeTlhR2dl?=
 =?utf-8?B?a1lTb0VhTzIzOHo0OHdlR3ZtWFpDQ2NFOTJrMG02MTNvVWhUMlpkR0JGYzdI?=
 =?utf-8?B?V1lITy90OEhzZlZlV2dYM1E3THNmL21HMzFpU2lkRE9rdlp3S2xOd3JhYjI4?=
 =?utf-8?B?ZE14V1VTQ3dwS2dZcFdpWU5OTEVZRmNQSlRsbzBkRGRuZzA3Yzk2RjNoNUdL?=
 =?utf-8?B?TWFhTXpOSllFejJXYVh0THFtY0l6M0Fka3JVNFFSSHlrZlYvdlNKLytmb3U1?=
 =?utf-8?B?MlZHUFloa1d6aHQrb1B1TVM3SW5xcDFjMHhpR1YzRU90MWF2Nk1xQ3ptVm13?=
 =?utf-8?B?MFJmMlpCd2pxSW9MbGtiT1lYMEtiNkxOU3FJdHFlTk91UTdrcVE4RHhwdzFG?=
 =?utf-8?B?VnRTYVRVc1FiNUpPUXRPNytGdCtJbkpFVnRBMTUrY1pQK1ErZ05kY1Z0MjJ2?=
 =?utf-8?B?Qjkrc0drcGU4dnhXb1l3emE3WFZNUnBuRGViRVlvYTBlWmdTUnlkb1BCK0xH?=
 =?utf-8?B?Ukg1TERhMEo5M1dSSWlwSlZwR01Zelhodm1WcGRLVmYyUVZJWjVmZE5CaHA1?=
 =?utf-8?Q?HelmnC35e2YsiNjtaU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB23825F53490341B1251C0CE0EEE735@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3479.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 687cc2a5-d804-4fb1-684b-08d917095ae4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 18:51:59.6079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ztLBGcXQ2/T2mgWX21qDVqcEJzLhQK2EzE14Ok2mAoW5YjMKli7UONOB6DhBOIzt9/vJ5mqCIvNvP9Ss5zyRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS8xNC8yMSAxMDozMiBBTSwgTGludXMgVG9ydmFsZHMgd3JvdGU6DQo+IE9uIEZyaSwgTWF5
IDE0LCAyMDIxIGF0IDM6MDIgQU0gQXJuZCBCZXJnbWFubiA8YXJuZEBrZXJuZWwub3JnPiB3cm90
ZToNCj4+IEkndmUgaW5jbHVkZWQgdGhpcyB2ZXJzaW9uIGluIHRoZSBhc20tZ2VuZXJpYyB0cmVl
IGZvciA1LjE0IGFscmVhZHksDQo+PiBhZGRyZXNzaW5nIHRoZSBmZXcgaXNzdWVzIHRoYXQgd2Vy
ZSBwb2ludGVkIG91dCBpbiB0aGUgUkZDLiBJZiB0aGVyZQ0KPj4gYXJlIGFueSByZW1haW5pbmcg
cHJvYmxlbXMsIEkgaG9wZSB0aG9zZSBjYW4gYmUgYWRkcmVzc2VkIGFzIGZvbGxvdy11cA0KPj4g
cGF0Y2hlcy4NCj4gVGhpcyBjb250aW51ZXMgdG8gbG9vayBncmVhdCB0byBtZSwgYW5kIG5vdyBo
YXMgdGhlIGV2ZW4gc2ltcGxlcg0KPiByZW1haW5pbmcgaW1wbGVtZW50YXRpb24uDQo+DQo+IEkn
ZCBiZSB0ZW1wdGVkIHRvIGp1c3QgcHVsbCBpdCBpbiBmb3IgNS4xMywgYnV0IEkgZ3Vlc3Mgd2Ug
ZG9uJ3QNCj4gYWN0dWFsbHkgaGF2ZSBhbnkgX291dHN0YW5kaW5nXyBidWcgaW4gdGhpcyBhcmVh
ICh0aGUgYnVnIHdhcyBpbiBvdXINCj4gemxpYiBjb2RlLCByZXF1aXJlZCAtTzMgdG8gdHJpZ2dl
ciwgaGFzIGJlZW4gZml4ZWQgbm93LA0KDQpXYXNuJ3QgdGhlIG5ldyB6bGliIGNvZGUgc2xhdGVk
IGZvciA1LjE0LiBJIGRvbid0IHNlZSBpdCBpbiB5b3VyIG1hc3RlciB5ZXQNCg0KPiAgIGFuZCB0
aGUgYmlnZ3kNCj4gY2FzZSBkaWRuJ3QgZXZlbiB1c2UgImdldF91bmFsaWduZWQoKSIpLg0KDQpJ
bmRlZWQgdGhpcyBzZXJpZXMgaXMgc29ydCBvZiBvcnRob2dvbmFsIHRvIHRoYXQgYnVnLCBidXQg
SU1PIHRoYXQgYnVnIA0Kc3RpbGwgZXhpc3RzIGluIDUuMTMgZm9yIC1PMyBidWlsZCwgZ3JhbnRl
ZCB0aGF0IGlzIG5vdCBlbmFibGVkIGZvciAhQVJDLg0KDQotVmluZWV0DQoNCj4NCj4gU28gSSBn
dWVzcyB5b3VyIDUuMTQgdGltaW5nIGlzIHRoZSByaWdodCB0aGluZyB0byBkby4NCj4NCj4gICAg
ICAgICAgTGludXMNCg0K
