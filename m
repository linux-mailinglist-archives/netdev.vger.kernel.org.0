Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951E95F6D01
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiJFRbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJFRbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:31:08 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120041.outbound.protection.outlook.com [40.107.12.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E0CA4BA5;
        Thu,  6 Oct 2022 10:31:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfW8MtdiA2DmeGqBAF5zdAwT18ZMAjGIZ5u/br5Zk82+x8qgRFNjBYdqUoVm8BOO0k1hoaMYXXIwRu5xfb1K7tttqxLJcveCd+efePOGlE9Fwx47Mg/OcLtA9rIM75qbummrLwkGLyzP0dVnaXJWtmbZavWc/00UmslDsBj/jQ8LkHsvI+V4n4mc0rFK695VKljsFFrkZg5oa/7msx530Q2Qr6EsZNf72el3kKIHnZYISBVuFL78+MrroZMJ7nhXzYUG5jQvimWz/ekaO4UzDH4PEN8P2QUXrv1ATVSLK3g1IRKuV+d9UH8eLWfK40TwgrtP4gzPJ/vHcbkWKKWarw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kBHgSn82zhLNDnFsZGAKTpJQpnlYJOysvEC5qhsu2go=;
 b=aZy9qBL4N4cHnYB0Sum5nsaUjmOrLHfVP8kq9o5wVd4pjnfYQVTkz48sPdq0EjDA8MGD4Bjj7YXXoCcWybK+lVhYVXic0xzAxrz2N7NQOsZyn1TFqVhJrdStJ42mzbQ3YQpJbUzRPBUeAs7Y9lbQ97Yv4TzjwEtDhsaxrjy04TZAnp2ZUsaNEkiqYCTvYLOs383Pj02qf4Hh9RlpP8syKPqsc2tuqPsk8gVz1f5m6jZYx77RGXLdDp8qZmgtpxKNJ/awBKiuZMQN8BQ6B1cZC3Kt9mYWxJwy8FnDvlaeaVn4TT9cxWDBhPPw6bW7aGmb/f/xoegdyWyUQmkCbvPbOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBHgSn82zhLNDnFsZGAKTpJQpnlYJOysvEC5qhsu2go=;
 b=Nj1E7tRviuHTCh5OoRVT82L2cbUB8lYrwp5dt2epMOg+FD8odp5NSx1EZRLn5DDGwORC+k6RnBJsxrr/FSELsoyovZpxqb0lHJTUefGwkeDH7Bcv1jnfPN0WVPELLCROC/JurcKd3bArQ2SOvyCHBD6WTIQ+J6VFniupktXEi25eMMwWZsvsNbQeqBWu2R/c7G/m9r6T1jyiGesyT98kdio9OWsBqPJPq94Y2KSjsmvZUcMLd+WowMmxTjSycOgtjDdluKVf5iTRXy4krNsiOd7+U6/iWyrldAlZbLMlNLzYKbf5+lf/BIUf5ttPrd2U4SAMIb9V9intnJQ/c20wIw==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB1921.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.34; Thu, 6 Oct 2022 17:31:03 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c854:380d:c901:45af]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c854:380d:c901:45af%5]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 17:31:03 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Andreas Noever <andreas.noever@gmail.com>,
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
Thread-Index: AQHY2aRLUOmMOiRiqUe6k1BKDHReSa4BnNgAgAAAygCAAAHkAA==
Date:   Thu, 6 Oct 2022 17:31:03 +0000
Message-ID: <f10fcfbf-2da6-cf2d-6027-fbf8b52803e9@csgroup.eu>
References: <20221006165346.73159-1-Jason@zx2c4.com>
 <20221006165346.73159-4-Jason@zx2c4.com>
 <848ed24c-13ef-6c38-fd13-639b33809194@csgroup.eu>
 <CAHmME9raQ4E00r9r8NyWJ17iSXE_KniTG0onCNAfMmfcGar1eg@mail.gmail.com>
In-Reply-To: <CAHmME9raQ4E00r9r8NyWJ17iSXE_KniTG0onCNAfMmfcGar1eg@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|MR1P264MB1921:EE_
x-ms-office365-filtering-correlation-id: fde2a9ab-0ffb-48ec-6c82-08daa7c08b1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UsDRemlJL2LCwhr0DPfizsHS0RDWofpRVxb2/DxfeFldzJBJszaIIRCLJEEhhqdPMP5cAggvOG8Ifrj0MvMWsP5I/puOI5rgdLf7sjZVyqKsjTjFlt8MTdmzWJtIiz4r3OouMkC+yL9KGxjeEs3lAUQqJhnhLFwa/ybQprjdyUnR1dB9L1B4PEBVUpygDNaN6Cd/sgaRCCzCUmrJV0rl23q6m2w1JAXM+Qse2+zm26qWkVwc7XdurkhJabcum9cpSTMwN+JiwXwT+inQrjtgOWvR0v9lBeBznTau8e9zSJHp4fvXO8ZYI0DLdvRpOsiVO90qAhi0lsd4Ec/Tc58tjEQ7vXtyt7oPQyP5RHcWkx56mqxKp4a/7eX9h8gVDdjrC73xo+HpPSX8iNsEWlAo6J9egg8+F5NeTpE/Cx+aNYPKlFxhij6fMLrKcpWGCuuKNWGdHJPuRQcssi18S33ULeTmNlw/RkF7byvBNeUdhkoYBqPhReSF5CjcBy9X8LZICccr9seqg9db841IyNhBuOEgibABV4yWmlrOhI8zhKnn06QBvnd5IhugrqoU1jttXpNInRt85nTdsAJAZKATJtdr9vchvlD4zGsGQapCVIHy1gUCd9iJgnfQev7O9B/hOiKLPYfOWPZnwLh3FHxcWluw4SEffaQfjGjoCkzAwn0tgFyhfh6cWQtbftwCUfHt1aW0w42Tcd518X+jsVyycgpdDzZXkb2uT9+Hl6zZMPbxmYFuiLBsq7P7/tyyElwXKu8Wt87MKfb22r8BVJtopiwhQw9qYPf/SDHCtKsUjQ/IkV6EFgFVz71BAvtIgTI+l+RbZIsfmFRHTTzfJDx5yQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199015)(6506007)(31686004)(6512007)(53546011)(6486002)(2906002)(76116006)(478600001)(26005)(91956017)(4326008)(8676002)(6916009)(71200400001)(54906003)(316002)(7366002)(66446008)(66556008)(7336002)(7406005)(8936002)(41300700001)(64756008)(44832011)(7416002)(66476007)(66946007)(5660300002)(36756003)(38100700002)(122000001)(31696002)(86362001)(38070700005)(2616005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXRyeGxoZ3RXd1lTSDlKcUlJd1ROTnNTbUYwQWp0OUxPTzE4ZXJUaEw5eVBq?=
 =?utf-8?B?ZVYwUVRkMVFJSWNERU5mQS9yWjdlbU9HcnZMN2FjSlZwQ2srL1pqS3k1UE5F?=
 =?utf-8?B?U2EyQ0IvRzBDbktOSmtwOEwvZ3crZGl2NW1nY2YzWnppTjF1d0dZa1BHcjhW?=
 =?utf-8?B?ajlYV3JLdGJINlRWeCthZjUxSlZhcUNYLzVQK1YvWjVubXc2aktZOFVxWHJu?=
 =?utf-8?B?T21GcjBMVTVGcGpGejFEMXdKU0tXWHZ6b1JoblNsYVVmaGFoQVJZWnl0ckU1?=
 =?utf-8?B?a3dTcnVYeXdJcUpQOWlpNC9kNUU3dVlDUWdnMDZ4eWIyc0x1ZlBjWTBqU0po?=
 =?utf-8?B?ZUdQQnNTRnJPeXRnNkFqWWxsUnZJcHZDa3JPWDZ4Mm5yNEdaVUlCZGc1WnFl?=
 =?utf-8?B?QTVRSGMyMkI5eEhuSFNQc1J0bFJheTRTd0pFVFU0L0ZPcEhTMlhSeG12Q1hJ?=
 =?utf-8?B?a2M5UStQdFZkcVVacU0ySWxHdG1TREtvU3RwNWt1Z2pSaEVDOG5HZXRtT3R2?=
 =?utf-8?B?NElOU2oxK1V1cGZkMjlkTmxFTUk0eGVJdFdNbXJKbGtPWGIrajNzN1kwMUFR?=
 =?utf-8?B?dGV2KzFpNkNKbUtrWXJIK0x5Wllla0FkUE1oRDZ6NVFqKzZ1QjBGcnBhcVpl?=
 =?utf-8?B?cUt4VUllUHQ5ZkRXa0RSek1yVlg3MG1CTS96MDk5RXN6QUVIaVFUeVdwWXV1?=
 =?utf-8?B?dldDYzdwSzNSei9VekIwK0pxVE1yRjNLV2NQSEhSY1FzcXFFc3lSUUpCL3Vr?=
 =?utf-8?B?eFBCUVpidTdmUjRRL1g5MGRMTWowTWsyZko3aGxTSG5JSE1BUTdxQVdJc0ts?=
 =?utf-8?B?RzhMNTYyM2pGL21oeVQzbkxOcHNWeXA0SDg2NkxJelQzbkF1c0NkcEU4dDVm?=
 =?utf-8?B?VWs0bFNWeUNvUGRCV2JQdHRPQTcwY2ZpMXR4ZTFTVjZtZmczOFM0d2VGaHdK?=
 =?utf-8?B?cnJiN3RqYTRIeU10Zm50b25UZHlPclA0UzFRcy92eXBZdGZQdGRxWU9GRkRJ?=
 =?utf-8?B?RDNVaURsdTc2bEk4NnBwTFk3aDZBdEdHMW5PdU0vMDJaRW1DQU5sd1V1VXZC?=
 =?utf-8?B?ajlndkVGamQyUk81cHo0T05zT2t2TmljT3gxM0tFekMrNGFBYWErVExla2po?=
 =?utf-8?B?SG1DMTJCbmk2VW5OUUdXY2JtQVBTTWNjLzJSRXo2NGl6ZzkySDEwL1VZOGpZ?=
 =?utf-8?B?V0RyVCs0WGJ4RThGN0NIVlBwSU1PTnIvQm5Qd0lZSGhwbExEK3QrU0tnOVdF?=
 =?utf-8?B?UTNHNEpwb0lwcnk0L1gwZzZONlo3UTNXd2g5Z28xWWxqaUpCRVBaVmhrWEJ5?=
 =?utf-8?B?bHFLMVpqaUtGdklGdkFwOXRBd0d0SUlyazRsenlmZUJHc0ZHN2x0MysvbGlO?=
 =?utf-8?B?Rk5VNTN3RmVQaWRZWlEzb0IzcitXRUlBbjRnSXk4VzZkZTdodnhEVzBnSDRR?=
 =?utf-8?B?WVNkdHN3OHhTbUxjSlZhY2NhcXhSeUJ1ZHp4RXJHTTNDVlBhdVo1SHJDbkND?=
 =?utf-8?B?TERQWXIwNXo2a0w0K3hwa0k2NTFMdHBDcGFkYmw5ajVnVnlQRkhIeUdPK2xh?=
 =?utf-8?B?dm5tWEtWcU5RdUxKcEVEZi9GdHNtVU9mUWlYY0NjREhXa1RJT3dvWGpVNFY1?=
 =?utf-8?B?Z2k2bkVKbEtlZ0dkQWdlVFFSSHg5VGowZ1hpc1Q3YS9ublZtdGhCK2dhWng4?=
 =?utf-8?B?cUNLT2t2TUNjMWl0amNlNFpPYmJYdmZRZmQ4a2w1UXYzZlZTN3JRd1lueHRH?=
 =?utf-8?B?R00vOW1PdVdjQ3JQMC9SdDZwVEpOYkdxK2QzNXdPTTl4dnFVUkZpemR5WnBB?=
 =?utf-8?B?cmtsNmZ3RUVhWTRwdldIdGFjTmtKVks2R2t2M1RtWHpqaGJxTkh2bTV3azFk?=
 =?utf-8?B?REVDTllReVpRNE4xd29UeDlJaGxtM21YcElaQ1ZGY1RTVTg0Y0ZCWUdMdWgy?=
 =?utf-8?B?bGFiOXpIVm1ZKzBxREpzSENHNTBRdmE4c2dNN0JIaFZBaEN6ZlkybEdKaWRy?=
 =?utf-8?B?S3paUEtvMkZwM25tNFlGZzhWZE43ZURMREc4QzFFQXhibnB5enFnenk1aVkr?=
 =?utf-8?B?aytLUndlRGlkaWpiSnlGbjdmRGpITFJocU4rYUltMnRrOGpiVWMwTXloVUll?=
 =?utf-8?B?NHovTU8rS0kxYlc0SmJtSCs0UlRrQ3NZeHBTdXdscGd6ZElpaFVvMmpxT2Qy?=
 =?utf-8?Q?6H2vxALwWdClO2lEkzBkhMs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A4B84F46BBE6042B54970B24A722C5C@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: fde2a9ab-0ffb-48ec-6c82-08daa7c08b1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 17:31:03.5645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: neRWjdjuRnBwVq1QMlO4rqYLbb8Jwd1wlMJVaRE1QRTu08F0tgVgoIK9mVx3edwxYRe1nOYw4YSn/6bU7I4jKW1Tz5OEBLxxLLtrGQCLlR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB1921
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDA2LzEwLzIwMjIgw6AgMTk6MjQsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBIaSBDaHJpc3RvcGhlLA0KPiANCj4gT24gVGh1LCBPY3QgNiwgMjAyMiBhdCAxMToyMSBB
TSBDaHJpc3RvcGhlIExlcm95DQo+IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+IHdyb3Rl
Og0KPj4gTGUgMDYvMTAvMjAyMiDDoCAxODo1MywgSmFzb24gQS4gRG9uZW5mZWxkIGEgw6ljcml0
IDoNCj4+PiBUaGUgcHJhbmRvbV91MzIoKSBmdW5jdGlvbiBoYXMgYmVlbiBhIGRlcHJlY2F0ZWQg
aW5saW5lIHdyYXBwZXIgYXJvdW5kDQo+Pj4gZ2V0X3JhbmRvbV91MzIoKSBmb3Igc2V2ZXJhbCBy
ZWxlYXNlcyBub3csIGFuZCBjb21waWxlcyBkb3duIHRvIHRoZQ0KPj4+IGV4YWN0IHNhbWUgY29k
ZS4gUmVwbGFjZSB0aGUgZGVwcmVjYXRlZCB3cmFwcGVyIHdpdGggYSBkaXJlY3QgY2FsbCB0bw0K
Pj4+IHRoZSByZWFsIGZ1bmN0aW9uLiBUaGUgc2FtZSBhbHNvIGFwcGxpZXMgdG8gZ2V0X3JhbmRv
bV9pbnQoKSwgd2hpY2ggaXMNCj4+PiBqdXN0IGEgd3JhcHBlciBhcm91bmQgZ2V0X3JhbmRvbV91
MzIoKS4NCj4+Pg0KPj4+IFJldmlld2VkLWJ5OiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVt
Lm9yZz4NCj4+PiBBY2tlZC1ieTogVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHRva2Uu
ZGs+ICMgZm9yIHNjaF9jYWtlDQo+Pj4gQWNrZWQtYnk6IENodWNrIExldmVyIDxjaHVjay5sZXZl
ckBvcmFjbGUuY29tPiAjIGZvciBuZnNkDQo+Pj4gUmV2aWV3ZWQtYnk6IEphbiBLYXJhIDxqYWNr
QHN1c2UuY3o+ICMgZm9yIGV4dDQNCj4+PiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBBLiBEb25lbmZl
bGQgPEphc29uQHp4MmM0LmNvbT4NCj4+PiAtLS0NCj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gv
cG93ZXJwYy9rZXJuZWwvcHJvY2Vzcy5jIGIvYXJjaC9wb3dlcnBjL2tlcm5lbC9wcm9jZXNzLmMN
Cj4+PiBpbmRleCAwZmJkYTg5Y2QxYmIuLjljNGMxNWFmYmJlOCAxMDA2NDQNCj4+PiAtLS0gYS9h
cmNoL3Bvd2VycGMva2VybmVsL3Byb2Nlc3MuYw0KPj4+ICsrKyBiL2FyY2gvcG93ZXJwYy9rZXJu
ZWwvcHJvY2Vzcy5jDQo+Pj4gQEAgLTIzMDgsNiArMjMwOCw2IEBAIHZvaWQgbm90cmFjZSBfX3Bw
YzY0X3J1bmxhdGNoX29mZih2b2lkKQ0KPj4+ICAgIHVuc2lnbmVkIGxvbmcgYXJjaF9hbGlnbl9z
dGFjayh1bnNpZ25lZCBsb25nIHNwKQ0KPj4+ICAgIHsNCj4+PiAgICAgICAgaWYgKCEoY3VycmVu
dC0+cGVyc29uYWxpdHkgJiBBRERSX05PX1JBTkRPTUlaRSkgJiYgcmFuZG9taXplX3ZhX3NwYWNl
KQ0KPj4+IC0gICAgICAgICAgICAgc3AgLT0gZ2V0X3JhbmRvbV9pbnQoKSAmIH5QQUdFX01BU0s7
DQo+Pj4gKyAgICAgICAgICAgICBzcCAtPSBnZXRfcmFuZG9tX3UzMigpICYgflBBR0VfTUFTSzsN
Cj4+PiAgICAgICAgcmV0dXJuIHNwICYgfjB4ZjsNCj4+DQo+PiBJc24ndCB0aGF0IGEgY2FuZGlk
YXRlIGZvciBwcmFuZG9tX3UzMl9tYXgoKSA/DQo+Pg0KPj4gTm90ZSB0aGF0IHNwIGlzIGRlZW1l
ZCB0byBiZSAxNiBieXRlcyBhbGlnbmVkIGF0IGFsbCB0aW1lLg0KPiANCj4gWWVzLCBwcm9iYWJs
eS4gSXQgc2VlbWVkIG5vbi10cml2aWFsIHRvIHRoaW5rIGFib3V0LCBzbyBJIGRpZG4ndC4gQnV0
DQo+IGxldCdzIHNlZSBoZXJlLi4uIG1heWJlIGl0J3Mgbm90IHRvbyBiYWQ6DQo+IA0KPiBJZiBQ
QUdFX01BU0sgaXMgYWx3YXlzIH4oUEFHRV9TSVpFLTEpLCB0aGVuIH5QQUdFX01BU0sgaXMNCj4g
KFBBR0VfU0laRS0xKSwgc28gcHJhbmRvbV91MzJfbWF4KFBBR0VfU0laRSkgc2hvdWxkIHlpZWxk
IHRoZSBzYW1lDQo+IHRoaW5nPyBJcyB0aGF0IGFjY3VyYXRlPyBBbmQgaG9sZHMgYWNyb3NzIHBs
YXRmb3JtcyAodGhpcyBjb21lcyB1cCBhDQo+IGZldyBwbGFjZXMpPyBJZiBzbywgSSdsbCBkbyB0
aGF0IGZvciBhIHY0Lg0KPiANCg0KT24gcG93ZXJwYyBpdCBpcyBhbHdheXMgKGZyb20gYXJjaC9w
b3dlcnBjL2luY2x1ZGUvYXNtL3BhZ2UuaCkgOg0KDQovKg0KICAqIFN1YnRsZTogKDEgPDwgUEFH
RV9TSElGVCkgaXMgYW4gaW50LCBub3QgYW4gdW5zaWduZWQgbG9uZy4gU28gaWYgd2UNCiAgKiBh
c3NpZ24gUEFHRV9NQVNLIHRvIGEgbGFyZ2VyIHR5cGUgaXQgZ2V0cyBleHRlbmRlZCB0aGUgd2F5
IHdlIHdhbnQNCiAgKiAoaS5lLiB3aXRoIDFzIGluIHRoZSBoaWdoIGJpdHMpDQogICovDQojZGVm
aW5lIFBBR0VfTUFTSyAgICAgICh+KCgxIDw8IFBBR0VfU0hJRlQpIC0gMSkpDQoNCiNkZWZpbmUg
UEFHRV9TSVpFCQkoMVVMIDw8IFBBR0VfU0hJRlQpDQoNCg0KU28gaXQgd291bGQgd29yayBJIGd1
ZXNzLg0KDQpDaHJpc3RvcGhl
