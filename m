Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35B65F6CB3
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiJFRVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJFRVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:21:31 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120044.outbound.protection.outlook.com [40.107.12.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBEAABD7A;
        Thu,  6 Oct 2022 10:21:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRoWTW7pFSXDoezeLFWI45o7NPUHlsDL5IAF/y6dQy84WqOvRojWubvIbwFcVn/tLGicLc8o8Vnhk/D2tugHTFG8WumBGMzvjdjzH7wBY8jYzdr6AdoJ7Tyzhs/+e0WA9d3Bhz8E0dXGSAWJhManGyy8D3kWrnoR5iKAK3eDZSaztzFqBMCDlLnIpdQ37QIcCN+10Lc8WTuYEQPwML/W7YaDG7yplpFtxzfY2jhnsdOAZ0K/D/0T3KLg4g0EV17qYRWA6LvNX7QhNTtHo+UAS7XlbckwbOKrzuiMhcEYU6AbvX+Ob8a5lTCsIfmblb6c4BSAMoRODvO0uWjj/+uPhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjkjH08M4BavjCLQpBhfFzbbLl1J2iit9rB7l3k/q9Y=;
 b=cXWq0Q7CNJsEuF9NJ93OLaBaz+AhyZnYIF+5wc95uRH2IjSx75ULFSmCBXXgRw/sPDz/PxOwGSF9UDIMcC4ZSLpCOAZwHs+K5i4ULVI/jbm6eXIlhOl+PLQ28f9tHMf1Tsf8qtUkszokwkiyGT+4DEdbwkE/LJ7xPKkhpt78w+7VOq+8PFo71YuqbX93owo3pI8dkLOtxdaGDMXcLfI4XxF/MmJ5rom5lgw6YLe9OWca9zo07022iLhtQYwdW3PI00C+argrXR91v78AsJtmvnd4TnbSjtalFVYmj9wQexDaEalqjKKEeS3/jRDZj9Zdo8mq1nqQMuG8zGbB5E6Lxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjkjH08M4BavjCLQpBhfFzbbLl1J2iit9rB7l3k/q9Y=;
 b=znWL7iOzXuQKNC2cU0tcAL19esC1EJ4ruvA8EPlVEXxn7qUWvfvzdcHj6zaTHHk/2HLtAJqklrG9x9JHaQ5SjGxPONDo11wVeOKKHYFt6LJbirL3+HLD2iCamrAv3AHvc/AR3FpVUSfFvnKZasn2FWD42wt+3IHxT+3V36Fsgz77LE2gNqtkyyVKj0i+2dNu9mMp9cls7MD25JB+8Go2/b9TKq0C05dHz6vuIJk5iHt+6p5oKHy50b22H2O/BBNH6SV7oOjY9q+hfMjjdX/W6VK5FkvL1DfNCB7v6u42FA+RWY+JzwKUTeVkyT7tEUXZl06VFvUOYQmLqF0bw/IVEA==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB3324.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:144::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 17:21:27 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c854:380d:c901:45af]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c854:380d:c901:45af%5]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 17:21:27 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>
CC:     Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?utf-8?B?Q2hyaXN0b3BoIELDtmhtd2FsZGVy?= 
        <christoph.boehmwalder@linbit.com>, Christoph Hellwig <hch@lst.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Airlie <airlied@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Huacai Chen <chenhuacai@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Russell King <linux@armlinux.org.uk>,
        Theodore Ts'o <tytso@mit.edu>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        WANG Xuerui <kernel@xen0n.name>, Will Deacon <will@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 3/5] treewide: use get_random_u32() when possible
Thread-Topic: [PATCH v3 3/5] treewide: use get_random_u32() when possible
Thread-Index: AQHY2aRLUOmMOiRiqUe6k1BKDHReSa4BnNgA
Date:   Thu, 6 Oct 2022 17:21:27 +0000
Message-ID: <848ed24c-13ef-6c38-fd13-639b33809194@csgroup.eu>
References: <20221006165346.73159-1-Jason@zx2c4.com>
 <20221006165346.73159-4-Jason@zx2c4.com>
In-Reply-To: <20221006165346.73159-4-Jason@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PR0P264MB3324:EE_
x-ms-office365-filtering-correlation-id: b435e492-bfe5-4766-80db-08daa7bf33c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aFKb6j0sF9l/sHpq/IwjAhRbihgR9YM2vTrg9tD8u8O4xs83zA/tlTOlJSQtPnbuBBRuJZ8JpW2RC9YvuOEz6I4z9oR+GKHvPeMMxfcF1I6STjqVgOUxncHVEE6hmVv2OqPVzT8CKvB69n/wDHyXxw1bRB6Eux0E6Id0f8C9BEiyEKy9X6QvkJd1Si0f/bBX6jdbKwiqpupDmd+WFvD/+rWWiMsLgTJwWPH2wGTGwIdCEIdXtJ+PER/OhM7G1QyjkNruT58PBvKsosv0t53rX0QlYlEU9B7LSo+5E1WXZEsjUA/DprtrvD5J8VtazIOkS7mFE+RcQnsbzy+YB17rtmUyLpMP+mp0pYqf6nPhJ/faZMNTA1xZjG9eMb9zFjw5s2m4XeAcOWRMtlIqkLwTdqr88htplPlSqzFtPiy/tjDhE4orewHtSoQP7uBDWSzgHLbZj2PWfv3j7xCMgBsIkeihdW1zUC8OuKY8nELfsKO2dyx5kwMEFh+TJJPhs3HWfLejkS2ZGdliwrCquflClZLwGTZv45DolPMRIlPj4a+XiP60aqwGf6otpH2nNpm3HZI/3ZWDhfuN8+qiEK/sA53iVUkyZVbLBMnGCQ/TSwKUmw2xQOmfyS8Tv1dCTEW3AzyzKoU81pnAIWRxWu+zcRrJTK9VkcsG/SkVfvxeKIFaxCZYk6GJ1TCpBgeG3gX3hgbCpPwToJk6H6xvNTp7P0GbeBAPBTrOeeX+gfRLRTHUYhBoiR/BjQKcgNWkhZ42rdiHMPQMJsXmMvfdvsE8huQB+kVHXnZKE4ZBAZSiAVOwFh3s5UBUomlYBzeGfq0VC5P2MalnhZfAanyxB2Kplw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199015)(316002)(2906002)(122000001)(2616005)(76116006)(7366002)(8936002)(44832011)(38070700005)(7416002)(7336002)(186003)(41300700001)(66446008)(7406005)(5660300002)(26005)(6506007)(38100700002)(66556008)(478600001)(66476007)(6512007)(71200400001)(6486002)(66946007)(8676002)(4326008)(64756008)(31686004)(36756003)(91956017)(86362001)(54906003)(110136005)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elpRVEpISzd2QnVpRkVsU1ZtK1Z0YXFYRnIvRVpMa0QvLy9HcWdUZ3dxUXB5?=
 =?utf-8?B?S2ZETlpJM2lJZTJ4M0pOVjNzODQ5d2hQNlhYMEFjYVBscDFXY2FCVGsxRXRG?=
 =?utf-8?B?YWNPNTM0bTZkc1pjOHcvN3duTjRMQm92eHIzaVZxRkdwSS9vU0Y0Tmg2UlB4?=
 =?utf-8?B?L3l4SG1Pdk1SaEtjTmx1bWxCdjNycW0ya3phM1kvNkFhV0lrdmQ1NktlRXF2?=
 =?utf-8?B?aGNCZ29TN3NJd1pDWjJDamVZTThUSFRMV0JrUi9TalFvNWdhL25RQVlZSkNB?=
 =?utf-8?B?ZUhHOFFjTmRDVW5qZmhMOWUzV2lqSTIxNUZRZFFIYU91eDRDdll5RTBZTmIv?=
 =?utf-8?B?b0F0S2Uxcy9sN1NLT25zS3A4N1BqbXhtb082RFN2NFFpbE1tQ3hvdmI4bTM3?=
 =?utf-8?B?VE9UVTJkSmxhTTJQaU4wV1FtYmlzNHY0NFUrV1p4YVdraCt5SkFoeHBpTkZr?=
 =?utf-8?B?L0hpdHI5ZmpjTkhqbHF2TFlsQ1NjbEgrTzZ1NjJ5OFVxd2FjZ3ZnM2YyY0dO?=
 =?utf-8?B?dlptZnJLd1d3MmNOOTJKQWFwOC9BRmpmSmlYTVJCOWJVNzdXMnBVMlg4R3N3?=
 =?utf-8?B?dlFOUkV4RWRlVThZeFVqUTE0c3RVWFg2TEpuY0kzZzV2STJVdFA1SnE2LzlM?=
 =?utf-8?B?dlp5bGZCOGRuVVdkak1RelNMTVFNYUY1anRCZUFZS09YTUxkYS9Na2I4OWlE?=
 =?utf-8?B?cy8wYmNUMDFiODFxcktKbEhvenNrbWRqVThSQ2UzdVdRUE55ek9zaENVVlRm?=
 =?utf-8?B?c1ltQ05sU01PTnRuWDRTZ3ptTnhPWmNCWDJ6L3k1NElFV05iM1kydk92MEZS?=
 =?utf-8?B?Y2lBK0J0d1RSc2hFcFl3QkxpU3lmZUYwQ2kyYjBSZUZVZHQzZGYyQXRaUEMw?=
 =?utf-8?B?MGJMTitsZVBiMlFQTjV2d3N5Zzc4Rzd4MXlybC9ZclJpaUg4djlXcmtjM3gr?=
 =?utf-8?B?ZnJlWlg0aHVIc2RlVU1DQUJmaVZELzdLZk50Q0NlNlRzc2FtTHJ4NlppdDln?=
 =?utf-8?B?Y1NXL1hKVHRmVjNuYmF1OU8yWHhVYnFsSkVIZnhyMXMxWGpwR09tOEtoTEIy?=
 =?utf-8?B?SnFsUTZueUlFN2RwaHNmZmc5STN3VTdpb3VhNHYvaklyVzZONjJhT0JDWGtJ?=
 =?utf-8?B?a1h3UG9DYjlCZ0VSSTJ4SndFUFdLU2NjMkwweUdVa1IrZzc4bXc2QTlBU0JJ?=
 =?utf-8?B?SWROSEZVcDdDY2lZMVpTTTMxSlpLRDJPYm9Vcjk5OWdOYUNmMjJTc0x2YW5y?=
 =?utf-8?B?NGJzdlEyZm5rWW1VRnhJWE1LMDllbDVPRVA4dTJwWFZvMEFLcGxwWU9zV0hn?=
 =?utf-8?B?VHczbVBXNkhVVHRMZUwrR001ajRZMCtwN0EyN2ZHbTVUUHJKcERFWVoxVzdM?=
 =?utf-8?B?bGpHbmFKZlJ0YjVTU3lMWTJxZ1JvUkxaZkRMc2gxeFU5SEREbEI5M0lCUlVW?=
 =?utf-8?B?M3A4VzdWUGZvZ214cWxkSnBrNUlxbTFHZmkzQmxYczYvTTI0QlMwVnlGWW1z?=
 =?utf-8?B?aG82MllKaHhFcU1mYmIwb3hDL3crc1NoVXdUWHM2YjNxUFdiS3BiVnk1Nk5t?=
 =?utf-8?B?MUNMc0g5bFZvZDV5NmdldjAxaHpDQk5wQVNFWmtyM2Q4cVpybzRndE1HZE95?=
 =?utf-8?B?eHVCZk93OTFRd0QyUi9VUVZHV0g5NEZ5dVBVUE85UDlCMzI2S2J2Ryt5cnhD?=
 =?utf-8?B?RVFCK0tPY1I3blhBQ3duaENNM251bDl3NUZCajQwc09KSytWTTNPOUJKSGor?=
 =?utf-8?B?UEpjamo1cGRxZkpBdXFxemkvSXErOVhSQ2FraThiTCthTHRNWXVmMkN0dUpi?=
 =?utf-8?B?QTFGSEV2T2FoMmNPbGM0WC9YbExISklleTU1ZDMzNUN5MGd0MVJDT05kUS9a?=
 =?utf-8?B?NkVBbzd1SXFBVzFYZ2QxYll0L001YS9sbWdMaFRFVmt6NUxmQzRiUkZMalZs?=
 =?utf-8?B?NzZsUjlpWE5hSURxTEJvK1FwcW1sZXRlVis5WmJsQnJpZUgvVzIwanlRaEE5?=
 =?utf-8?B?QytxY0F3dzRGMGEydUt6Z1l6UVpNUE5LS1FQQUNmNThOekxKa3BwY3RzOHNW?=
 =?utf-8?B?N1A4b0lRQ0tqU1RhUlBlSDVNeWpFYnVWOHgzUkNoQ054LzEwSFpiK1JMcjBN?=
 =?utf-8?B?ZXBHcEVMSGVMNnkybFozY1BtRHRGbGZ5VVhtSHBhaE1ja0RXaGZKVzZKUUVL?=
 =?utf-8?Q?bVGw61IQfN57I5nqkFsm1+g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B07B745AE1A6904EBF61E3986BE3C1D1@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b435e492-bfe5-4766-80db-08daa7bf33c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 17:21:27.5495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LyUr5KK+XMmusbQ6YhVGYUYpg2PKOd6bQCvUFRBHYW1Zq91JkHALJ9q3O1VfoqyQV/qNEBNf2qgeOfKWWYBk8HXZNXcwdIKJ3Zm4KWakpb4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB3324
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDA2LzEwLzIwMjIgw6AgMTg6NTMsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBUaGUgcHJhbmRvbV91MzIoKSBmdW5jdGlvbiBoYXMgYmVlbiBhIGRlcHJlY2F0ZWQgaW5s
aW5lIHdyYXBwZXIgYXJvdW5kDQo+IGdldF9yYW5kb21fdTMyKCkgZm9yIHNldmVyYWwgcmVsZWFz
ZXMgbm93LCBhbmQgY29tcGlsZXMgZG93biB0byB0aGUNCj4gZXhhY3Qgc2FtZSBjb2RlLiBSZXBs
YWNlIHRoZSBkZXByZWNhdGVkIHdyYXBwZXIgd2l0aCBhIGRpcmVjdCBjYWxsIHRvDQo+IHRoZSBy
ZWFsIGZ1bmN0aW9uLiBUaGUgc2FtZSBhbHNvIGFwcGxpZXMgdG8gZ2V0X3JhbmRvbV9pbnQoKSwg
d2hpY2ggaXMNCj4ganVzdCBhIHdyYXBwZXIgYXJvdW5kIGdldF9yYW5kb21fdTMyKCkuDQo+IA0K
PiBSZXZpZXdlZC1ieTogS2VlcyBDb29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+DQo+IEFja2Vk
LWJ5OiBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gPHRva2VAdG9rZS5kaz4gIyBmb3Igc2NoX2Nh
a2UNCj4gQWNrZWQtYnk6IENodWNrIExldmVyIDxjaHVjay5sZXZlckBvcmFjbGUuY29tPiAjIGZv
ciBuZnNkDQo+IFJldmlld2VkLWJ5OiBKYW4gS2FyYSA8amFja0BzdXNlLmN6PiAjIGZvciBleHQ0
DQo+IFNpZ25lZC1vZmYtYnk6IEphc29uIEEuIERvbmVuZmVsZCA8SmFzb25AengyYzQuY29tPg0K
PiAtLS0NCg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9wcm9jZXNzLmMgYi9h
cmNoL3Bvd2VycGMva2VybmVsL3Byb2Nlc3MuYw0KPiBpbmRleCAwZmJkYTg5Y2QxYmIuLjljNGMx
NWFmYmJlOCAxMDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9wcm9jZXNzLmMNCj4g
KysrIGIvYXJjaC9wb3dlcnBjL2tlcm5lbC9wcm9jZXNzLmMNCj4gQEAgLTIzMDgsNiArMjMwOCw2
IEBAIHZvaWQgbm90cmFjZSBfX3BwYzY0X3J1bmxhdGNoX29mZih2b2lkKQ0KPiAgIHVuc2lnbmVk
IGxvbmcgYXJjaF9hbGlnbl9zdGFjayh1bnNpZ25lZCBsb25nIHNwKQ0KPiAgIHsNCj4gICAJaWYg
KCEoY3VycmVudC0+cGVyc29uYWxpdHkgJiBBRERSX05PX1JBTkRPTUlaRSkgJiYgcmFuZG9taXpl
X3ZhX3NwYWNlKQ0KPiAtCQlzcCAtPSBnZXRfcmFuZG9tX2ludCgpICYgflBBR0VfTUFTSzsNCj4g
KwkJc3AgLT0gZ2V0X3JhbmRvbV91MzIoKSAmIH5QQUdFX01BU0s7DQo+ICAgCXJldHVybiBzcCAm
IH4weGY7DQoNCklzbid0IHRoYXQgYSBjYW5kaWRhdGUgZm9yIHByYW5kb21fdTMyX21heCgpID8N
Cg0KTm90ZSB0aGF0IHNwIGlzIGRlZW1lZCB0byBiZSAxNiBieXRlcyBhbGlnbmVkIGF0IGFsbCB0
aW1lLg0KDQoNCkNocmlzdG9waGU=
