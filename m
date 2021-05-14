Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5F7381118
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 21:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhENTqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 15:46:55 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:56818 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230495AbhENTqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 15:46:52 -0400
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B5C25400E5;
        Fri, 14 May 2021 19:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1621021540; bh=XmG4n8vJxbRH7bBrVjUXsvPsTWs/midRcduQpFfikI0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=EbEeU8FKtL/UmcNdyOSAK6Qg7k4N1z2b6T9DoMNKXhBVvX+RwPpyMWpQ21GJNYZnu
         jUaOkIKGbLB6f8wGIKd1Xr2Eqpw9S/p5d/hr+wQ9sASVER4s8epDNb405MxXaraFMw
         6lOyCVi6X5ETslJJVjy3JCqDoeyHuMJ0wzAh2aB+t/gtH/wG50lcISuABeCehG1yMS
         moeu9Di2xjRTv9Od87ioybFzxiN+wVbCwR+bzOueFeJIHiWANK783loiizH6LXJ/0f
         baHiiFUo3bqjt4lMn0Bi1GO5L446Tnye7VTJL9STzgZMzSD8QmhgWH1bN3ikeb4KU7
         nWdLOkv0uXMFg==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7C07AA006A;
        Fri, 14 May 2021 19:45:30 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 3A359800C4;
        Fri, 14 May 2021 19:45:19 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=vgupta@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="pqbBrRsd";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g13J+ZE7cmd6aASpzItin32ziGymgtzESlEeEd8thP7kezQriRJHclLAlKPp8qskuY0fYRdAb+7+nOWeMNbwBtxqiealsifYm78UhORxMLi6auDwguOlbeKg5VIael9N4hzai87CLZuBWzmgEaCwpeP9Q4d28t7OxfogcLeEDHVi+cjK8SCu8cXF3DOHO/FOil0bv86osG79u4drogl+NaiQJW/YMtO4Vt2gFeQHxYJcQWDSWDkX7oh70gcI5E2l2zHR0sY/wJxymouSqNfCaQEOFP9fgnd7C3dbwsAmAJaP/eM4vjQIfUWNmKdTdkgWIlKY5XMk+hI9+dIVW47iEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmG4n8vJxbRH7bBrVjUXsvPsTWs/midRcduQpFfikI0=;
 b=iFGm0APjAMam7MLwEK5NzQT8lQdk22rwGZU1f0Zzyzq/QDv7vRfxkC1oRkLD6wx1y+IaaGWhSGJ4yRG171xFBv3MT3GDUARJVE8rfWikgC5YZBfr50OLXVQuR0r01u6/uQvdGC69haNnsUS0gnCpg5OyG7ZY/D3rnscn0kbfnHwVi4Uh+lpzyZj8ME1eKcVqPezdHdR6BvSe1QWiO8jdUWlGneY3K4TEU7xZMmTnzB37hileFSq6dRpk32IpcTgeWzktZTlg0tMELwjEHbig1yqPr+n6mHb5+ddAgY+iZCUoQb3Dd4R+Cprke35GahKHh5IOgODm/Axr8CA5qU0nww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmG4n8vJxbRH7bBrVjUXsvPsTWs/midRcduQpFfikI0=;
 b=pqbBrRsdzHkve5erFrn0KJX/6qveXM1TqPgoVVT1JKF5QGfHFgQobm8LxAzkmtYlamCs2rvx2LkcyWpscvLqwc8WYViqvo/9GrvVsFzHGnpiirxBi7JBVRLfZTNbkJ9NHSrdBUYoKth1xECtgiiP7Tj0pqzGJLeW34yDI9E48WI=
Received: from BYAPR12MB3479.namprd12.prod.outlook.com (2603:10b6:a03:dc::26)
 by BY5PR12MB4918.namprd12.prod.outlook.com (2603:10b6:a03:1df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Fri, 14 May
 2021 19:45:17 +0000
Received: from BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::d1a0:ed05:b9cc:e94d]) by BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::d1a0:ed05:b9cc:e94d%7]) with mapi id 15.20.4108.036; Fri, 14 May 2021
 19:45:17 +0000
X-SNPS-Relay: synopsys.com
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC:     Arnd Bergmann <arnd@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
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
Thread-Index: AQHXSKg19FKoFxcBX0+yXT8p8kMtfqrjPPKAgAAWKgCAAAiYAIAABkwA
Date:   Fri, 14 May 2021 19:45:16 +0000
Message-ID: <14016937-b9c3-c131-db18-f97081806c7f@synopsys.com>
References: <20210514100106.3404011-1-arnd@kernel.org>
 <CAHk-=whGObOKruA_bU3aPGZfoDqZM1_9wBkwREp0H0FgR-90uQ@mail.gmail.com>
 <2408c893-4ae7-4f53-f58c-497c91f5b034@synopsys.com>
 <CAHk-=wih8UHDwJ8x6m-p0PQ7o4S4gOBwGNs=w=q10GNY7A-70w@mail.gmail.com>
In-Reply-To: <CAHk-=wih8UHDwJ8x6m-p0PQ7o4S4gOBwGNs=w=q10GNY7A-70w@mail.gmail.com>
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
x-ms-office365-filtering-correlation-id: 5aff8a86-dc2f-4587-f7be-08d91710ccd4
x-ms-traffictypediagnostic: BY5PR12MB4918:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB49187A75ECC97544DAF92C2AB6509@BY5PR12MB4918.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BYaXSC3TslWRkzsViqCiF1+Wxp9ZRdRQeChNpCHqFojES9rxJcWKNb0aQn3ba1j1eHw1lhWLivOzkP7ST7eqae7VyAlocuyIm7zFVSWFwC573EHkc9ysVGP1OT57JYg4lhGRB+zUL/QN8/gxAlW3aaTN25UIc4zo9QJaEY8IJ1oNRP483/bqXJ6e0eGRvrtLBSxI7qGscKgJPnAA7+LXqcHlvCU/1JbMMmbNA2EpRvk3ANPp6HhgROzFjtSQxpov1LbDn7uf7vd5G954cpAp/ByoLyLc0a7eX1tUb7Ts9aUhxpLmHAmpsX8ZlUg0dpGrXYKdPQUqmXhYgaBjZlTphwRh1VCD/pQ+v3DGwN1USDB8meAh8zTuVBMY8cF8/6TZdvVeConeAGm7YRuAKJKTGbSyF8Qe4IuODHZxB8AZJshJo+SLxmLhjieKUtfnRe18hx1fvpxNjMuy9pvUMdBJGHgxPLuJ/oSro+muliSqkS9peSV5ftb4i4VrCXhE/qx81Uw9T9fWlTX9BadBDKUY183cgt25W3InSN4DApd8UlTYN03fUPxaC0wMIwIbkMaFgAeZICX+/tXpb16+gLxh/mO68owoJcmkIhFDzzvY9xb6vJWCFIBPZr1fh8S0X7LvxseKYAcuO3UK8dhxg4/X9M+Qk1+9pLtWuW2iFA2BiHFNEvGWGetGFVRrYuQaj2aq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3479.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(376002)(396003)(39850400004)(31696002)(36756003)(86362001)(38100700002)(66946007)(66476007)(83380400001)(26005)(7416002)(7406005)(66556008)(71200400001)(64756008)(2616005)(2906002)(4326008)(54906003)(316002)(6512007)(110136005)(122000001)(6486002)(8676002)(186003)(478600001)(66446008)(8936002)(31686004)(6506007)(53546011)(5660300002)(76116006)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eXpKSWxoSEtpUWlxU0x0OElweWd4YnlKVGNubEVaZDI1OTBKTTNXdGFNR1RZ?=
 =?utf-8?B?R01Kcnd5MEhXbldycDlDNDdla050UmJmNkc5WnBBTFZXYXVVVUhpUnM3VGty?=
 =?utf-8?B?OGNFOVVkZ2pTVm1NZ2dIckt0TTdyUHhDa2ZKRGp4M0krckJRYnlZOHUwQ1Yr?=
 =?utf-8?B?UlRBZktOQlFQNHB5VlkzcEZrclB5U25Mcjl3U1ZBM0RFYVJiOGtyL1NzQWMr?=
 =?utf-8?B?OEFsTFdzNTd0T0xVazZPM0Z1NWR2Z0JldnFkOUpLZlgySGl0LzFxcXJlNFBL?=
 =?utf-8?B?ejlwU05tMjkzcGozNkFwWFBFa3A3RzN4elloa1VKenRya3dpWE9NN0szWFlu?=
 =?utf-8?B?ZTFXN1VLaHdRdmdYRFltN3B3dHZxOWNZaFF2UEYwcjk1bkI0cEV6cDF6ZWVo?=
 =?utf-8?B?dGRqMS8rK0R5NU15d1VWM1BZME04MTZ6QVg4N1doUndhKy9lQlp2Q2M2TmVC?=
 =?utf-8?B?aldpQk5YUEsrS2FCMEhSd2ZmajNJRnBDR0xPdW55RXhTanNXUEllTGpDa2pU?=
 =?utf-8?B?ZnlicW51dlBxRGFJUDNXRU9EVitiSTBGcXgxWG9TYTV0eDFXVmI2MmcwS2FY?=
 =?utf-8?B?VUlUTnlaN3JPR0NFOGhoeDhheWxUdTNJUjdoZ2l2L2FqcFkyQTlhaGppV0lr?=
 =?utf-8?B?b1RPdldzSHZIYXI0MUFxMmVkanhTNjNCZUJnOHE3cERLU2doT01kZytBV1p2?=
 =?utf-8?B?aldhZjBkWitsQndUMkhuMXhuUlVNNzk4RlJhVVc2Z1F4RXAvUVI5ODJLaXNh?=
 =?utf-8?B?K25kR0xBbHdIZndOazdYdk9FN0VjOGdndks5SUc5UExic0M2SWJqSkM3SHAr?=
 =?utf-8?B?NTRKOGxUakVJSy9ZSVNId1I3M0M2aTVDOEZNSUxDVlpzeCtBWS8zWDk5YXVR?=
 =?utf-8?B?YVY0dS9Nem0xVEVQUmUxbjlLRGtOeE50QzdrRnpzbWV2TnI3OWMzc3Z6eDB6?=
 =?utf-8?B?UllDUlRJaVhCSGJ5MHRqeXNQSDRJN2tZblkzVE00M1ZzaXhaaTU4Tk5MS042?=
 =?utf-8?B?eU9JcFpySk15WUx2SXQ2K1diQWZnZjhoLzRmRTN6U2R2N0NndFVMUHBzb0k2?=
 =?utf-8?B?VUZ0TnFkYW5sN1dWYURpWjBuM0VjQVRtNkdib2VqNGlCaTVKZGdKUVBLc0VN?=
 =?utf-8?B?K1NxYnF4NUVQOVc4RWM5NjR0a0dzNUVGY1ZQYTdSZzdyUGMyRWdibmFmaGZB?=
 =?utf-8?B?NWhNMFpyNmtiRzFPckR0blBiSnpqMWhrVXpnTnZ0OC9KRTgxV01iaTUzRTJq?=
 =?utf-8?B?VEJuYTgrQkNJTVVhek83REQ3ZE04N3NFUStUS2JYZmZ5M0E4Wm0yTDhDZy80?=
 =?utf-8?B?OFZKcFZKaFBZLzdXcEdVYlBUb1N5NVo2S2w3di85SWpNWnVhb1BQZ1pDQXZX?=
 =?utf-8?B?L3k5d2F3QURTMW1USVNqWmt5WS93QWhOa0dVeW5PQnlQYXplYzI4MGN1VlJB?=
 =?utf-8?B?VVI5cmNJTllLZVZrZE4xbEhkSUZCaWlqZ3poV2c1R1ZTRUlDWVNSOHV5bDY2?=
 =?utf-8?B?T0tnV1N0Z0s0L284TUNTaWtSVVRzalRJQThBd2hVSm9jSDJnMEFzbGFsZXVD?=
 =?utf-8?B?dXlMR3hPVGpsQ1hobmdHdXVPMTUxOEtmeUUrQWVCdUtqZFdlUmN0blluN2la?=
 =?utf-8?B?ZUVsUjJteHdKSmxQRlRWR0ErVE84aGM5bGlseHhqN0FKR1JrejRpa010KzN2?=
 =?utf-8?B?cHlCUmswbXhIbEhrd3dSbkZZUldHWGtISUl1Ry94Zi9yNGV5MjVZcTlRZnI0?=
 =?utf-8?Q?EObv19a7YEYIAM6Ebg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <280212593F4F8844BA7CA332FCBE0B2A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3479.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aff8a86-dc2f-4587-f7be-08d91710ccd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 19:45:16.9872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VNdnXkbVpoFAdxneSiaJHaxdJz58kbCGlzZbu2j6F9WUrz8DCRRNO202snd5252dKG1PqcAqjBeu5v4ac9n/IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4918
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS8xNC8yMSAxMjoyMiBQTSwgTGludXMgVG9ydmFsZHMgd3JvdGU6DQo+IE9uIEZyaSwgTWF5
IDE0LCAyMDIxIGF0IDExOjUyIEFNIFZpbmVldCBHdXB0YQ0KPiA8VmluZWV0Lkd1cHRhMUBzeW5v
cHN5cy5jb20+IHdyb3RlOg0KPj4gV2Fzbid0IHRoZSBuZXcgemxpYiBjb2RlIHNsYXRlZCBmb3Ig
NS4xNC4gSSBkb24ndCBzZWUgaXQgaW4geW91ciBtYXN0ZXIgeWV0DQo+IFlvdSdyZSByaWdodCwg
SSBuZXZlciBhY3R1YWxseSBjb21taXR0ZWQgaXQsIHNpbmNlIGl0IHdhcyBzcGVjaWZpYyB0bw0K
PiBBUkMgYW5kIC1PMw0KDQpXZWxsLCBub3QgcmVhbGx5LCB0aGUgaXNzdWUgbWFuaWZlc3RlZCBp
biBBUkMgTzMgdGVzdGluZywgYnV0IEkgc2hvd2VkIA0KdGhlIHByb2JsZW0gZXhpc3RlZCBmb3Ig
YXJtNjQgZ2NjIHRvby4NCg0KPiBhbmQgSSB3YXNuJ3QgZW50aXJlbHkgaGFwcHkgd2l0aCB0aGUg
YW1vdW50IG9mIHRlc3RpbmcgaXQNCj4gZ290ICh3aXRoIEhlaWtvIHBvaW50aW5nIG91dCB0aGF0
IHRoZSBzMzkwIHN0dWZmIG5lZWRlZCBtb3JlIGZpeGVzIGZvcg0KPiB0aGUgY2hhbmdlKS4NCg0K
V2l0aCBoaXMgYWRkb24gcGF0Y2ggZXZlcnl0aGluZyBzZWVtZWQgaHVua3kgZG9yeS4NCg0KPiBU
aGUgcGF0Y2ggYmVsb3cgaXMgcmVxdWlyZWQgb24gdG9wIG9mIHlvdXIgcGF0Y2ggdG8gbWFrZSBp
dCBjb21waWxlDQo+IGZvciBzMzkwIGFzIHdlbGwuDQo+IFRlc3RlZCB3aXRoIGtlcm5lbCBpbWFn
ZSBkZWNvbXByZXNzaW9uLCBhbmQgYWxzbyBidHJmcyB3aXRoIGZpbGUNCj4gY29tcHJlc3Npb247
IGJvdGggc29mdHdhcmUgYW5kIGhhcmR3YXJlIGNvbXByZXNzaW9uLg0KPiBFdmVyeXRoaW5nIHNl
ZW1zIHRvIHdvcmsuDQoNCj4gU28gaW4gZmFjdCBpdCdzIG5vdCBldmVuIHF1ZXVlZCB1cCBmb3Ig
NS4xNCBkdWUgdG8gdGhpcyBhbGwsIEkganVzdCBkcm9wcGVkIGl0Lg0KDQpCdXQgV2h5LiBDYW4n
dCB3ZSB0aHJvdyBpdCBpbiBsaW51eC1uZXh0IGZvciA1LjE0LiBJIHByb21pc2UgdG8gdGVzdCBp
dCANCi0gYW5kIHdpbGwgbGlrZWx5IGhpdCBhbnkgY29ybmVyIGNhc2VzLiBBbHNvIGZvciB0aGUg
dGltZSBiZWluZyB3ZSBjb3VsZCANCmZvcmNlIGp1c3QgdGhhdCBmaWxlL2ZpbGVzIHRvIGJ1aWxk
IGZvciAtTzMgdG8gc3RyZXNzIHRlc3QgdGhlIGFzcGVjdHMgDQp0aGF0IHdlcmUgZnJhZ2lsZS4N
Cg0KPj4+ICAgIGFuZCB0aGUgYmlnZ3kNCj4+PiBjYXNlIGRpZG4ndCBldmVuIHVzZSAiZ2V0X3Vu
YWxpZ25lZCgpIikuDQo+PiBJbmRlZWQgdGhpcyBzZXJpZXMgaXMgc29ydCBvZiBvcnRob2dvbmFs
IHRvIHRoYXQgYnVnLCBidXQgSU1PIHRoYXQgYnVnDQo+PiBzdGlsbCBleGlzdHMgaW4gNS4xMyBm
b3IgLU8zIGJ1aWxkLCBncmFudGVkIHRoYXQgaXMgbm90IGVuYWJsZWQgZm9yICFBUkMuDQo+IFJp
Z2h0LCB0aGUgemxpYiBidWcgaXMgc3RpbGwgdGhlcmUuDQo+DQo+IEJ1dCBBcm5kJ3Mgc2VyaWVz
IHdvdWxkbid0IGV2ZW4gZml4IGl0OiByaWdodCBub3cgaW5mZmFzdCBoYXMgaXRzIG93bg0KPiAt
IHVnbHkgYW5kIHNsb3cgLSBzcGVjaWFsIDItYnl0ZS1vbmx5IHZlcnNpb24gb2YgImdldF91bmFs
aWduZWQoKSIsDQo+IGNhbGxlZCAiZ2V0X3VuYWxpZ25lZDE2KCkiLg0KDQpJIGtub3cgdGhhdCdz
IHdoeSBzYWlkIHRoZXkgYXJlIG9ydGhvZ29uYWwuDQoNCg0KPiBBbmQgYmVjYXVzZSBpdCdzIHVn
bHkgYW5kIHNsb3csIGl0J3Mgbm90IGFjdHVhbGx5IHVzZWQgZm9yDQo+IENPTkZJR19IQVZFX0VG
RklDSUVOVF9VTkFMSUdORURfQUNDRVNTLg0KPg0KPiBWaW5lZXQgLSBtYXliZSB0aGUgZml4IGlz
IHRvIG5vdCB0YWtlIG15IHBhdGNoIHRvIHVwZGF0ZSB0byBhIG5ld2VyDQo+IHpsaWIsIGJ1dCB0
byBqdXN0IGZpeCBpbmZmYXN0IHRvIHVzZSB0aGUgcHJvcGVyIGdldF91bmFsaWduZWQoKS4gVGhl
bg0KPiBBcm5kJ3Mgc2VyaWVzIF93b3VsZF8gYWN0dWFsbHkgZml4IGFsbCB0aGlzLi4NCg0KT0sg
aWYgeW91IHNheSBzby4NCg0KLVZpbmVldA0K
