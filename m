Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D595F6CD0
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiJFRWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiJFRWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:22:45 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90070.outbound.protection.outlook.com [40.107.9.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639BBAD981;
        Thu,  6 Oct 2022 10:22:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=age+G8iNIrVuEPOWbvb64N1s1USQwpQYHDphwTRYsk7f049KgAOO1CMxm4ATg/h6weCOn+Cch+cjG6aomqJCIrQ+VxvLQy9U2+qa1gX9LjsHKJKUI85NOkQoY7DfwcjGsxJ/tnNSbWj5g+zKuzpasAkQ2fJydPt7Qy6NH7ZFTMi4Rx2FyuJj7lUM55sOHx0g6wXXREUciyLu2hy6G0yOmrJJBulk28l0IB1yNcjNwNrRteOjGWocmSS5uVRAVzjXEkQT/YMi6cnKMAEZ9scUkH+xTp0WbK+3AFM2K1lOm70Zy10VIKgP788NzHFNcmphvrjNkmv5daS6s7sVtDoH9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEJ0X/HXgPcxrMfMufxKj+fUp6CJ4LGRqrwHihOttYA=;
 b=fmxfi2VsHrRf06I5XmIHvbcleiPcvX9xEIk7hk6RL094aW53m2G4QNcazT5IGEg4rk7G5IEVp3HgMEqw5dkNtnwEakokhJThToRlO+SlABDLeahGu2FYtE7FEO/GhgQZC8R1/Mm7XZTaseKj/yp5d5v95QTv5N5ICqV45PC8VDXuf9RZTms2kXiNRR/16NASEpzFw2x7xsVDwK3X+x/r0pHAUwDkf65ALopvVOTh1Kl20LT1PVxQ8MheAyBArLS/fx1N2RNd72WDafDgsZ6uv4KChOeOPrToSTiOwY7m1zvgWTtyZYrYqWVxzEEOrWdJpK9g8bVzJoC07qsp5TxDGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEJ0X/HXgPcxrMfMufxKj+fUp6CJ4LGRqrwHihOttYA=;
 b=KWPR9kmIvYrHOZR51enOBwSPam3mbYt06ZdSdr+fxLNhgcRYHFL6dlE/0HWfVYZ0ANwa2+IkVRIaKHjz8DOcqF0bZLKqZDOXzJ15Kac2whc++sQcqL4e34HoyQiCvgEohcbq4h/W2YfeL/s3LOy5Br3V4KjUCStapAEzmWaXOSVG+v/66SyNivqDxcX0vV/vnOrHAoUAL7lKVhjszgZDu2tA2a5KdAaSy3rnkI9KJ+9Mh16EKoyVaLLDZji4zPdTGP1RxKXQYdu7s59bHgWBSasS98QcOOWkJnkvnz7wp6XctpG1NbYX2/K35u5AJD+KauXRuXyZlPTq0gK0+/FBDg==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB2471.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1e2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.39; Thu, 6 Oct
 2022 17:22:41 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c854:380d:c901:45af]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c854:380d:c901:45af%5]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 17:22:41 +0000
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
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 4/5] treewide: use get_random_bytes when possible
Thread-Topic: [PATCH v3 4/5] treewide: use get_random_bytes when possible
Thread-Index: AQHY2aROlLqkBYztHUmTuAtdwYDXna4BnTAA
Date:   Thu, 6 Oct 2022 17:22:41 +0000
Message-ID: <0eea033d-7018-c777-f3e8-2239916aed9b@csgroup.eu>
References: <20221006165346.73159-1-Jason@zx2c4.com>
 <20221006165346.73159-5-Jason@zx2c4.com>
In-Reply-To: <20221006165346.73159-5-Jason@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PR0P264MB2471:EE_
x-ms-office365-filtering-correlation-id: e2a27763-3ea2-4f5b-fdf4-08daa7bf5fbe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 20r9Tx2pwuKezrfaWAbS82QYH8y7YVUeqQPOOI+bDEW8wTwryUJNqpp3xxMSnSjyNuIMQHothQsS7OsbwdxyN+OUMd6+xb/PATGsFKK4hxGhgvPt/AaYARMTFSRs+z9sOR5wJkY6jxnhzPyKe03cQZgvbw1ld+Hm/7aw0l9mhkA2mWhPD/pEEB3ppP7pVThHWxkB9E6n93DvgoSPqyi41EsXru5E85TK0qSdMqxV097wftKe/yd0agul3Pb/VH08M6qD3DX0wrYXm6HcAT6bs6EInM78nJE6wwWMac2JE1fnxYKH/Nq6ZQiypcRMeD8IayogbpYf1HVplqEfx9fogQG9whNChKSEX2TUGZFomY/j4VXqWYma13u/GVYQJmKBIYy0UR5Exa4epINzX0TIQXq4JgWyuPjR/nn5/an/q+Juw790UVQTv2eg1iaHjr0J6R7M+hxdLpJJ0a/xbh4jmNkSXRmcucY0lg9HxCWaX+1VxWDAoSY5bcOsNp005aZMSb46MC6fZyD4M5Xew0dun+LGfI7E0eBZF30z/Laz6oYr2NbfGVBUxAMoDuTazm3O6kdw0+9BCUQqDwZZgAtYo6tuE8GMQauG0/88bIBIyOFFn0kFCiouz0kLoK9WSLM09y55W2XXKPSRk+Yqt4FgpT3WCWZquCwVreH6YelVcjYTeM6OiJMWI+FIpATLQTeyf4s2XHK6iTbG0wz6KNucERq1HG7u08FnEbs+qbtN8lSDCd9hIErZ9IU0JEQWqEWgAHIF5KBiaM0zFqblqywltlsjBSWARMksHekBcnyxZpOHJvMUL/Qz+r/xhj7M1FBxOTazuGrmiYBPbZUmdcslUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199015)(83380400001)(186003)(2616005)(31696002)(38100700002)(38070700005)(66574015)(122000001)(4744005)(44832011)(7336002)(7366002)(7406005)(7416002)(2906002)(41300700001)(5660300002)(8936002)(6486002)(478600001)(26005)(6512007)(6506007)(8676002)(4326008)(64756008)(66476007)(66556008)(66946007)(76116006)(71200400001)(91956017)(316002)(54906003)(110136005)(86362001)(66446008)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnVzTlhtSTZPNE9wZ05ERFgwcGFIY0l6bXNKZGJqOVpGRjRDS1dua05SRmZh?=
 =?utf-8?B?UDE1UTQyTmpuUjk2VFJiYTYzc0pRN3hlSGpkK2t4ZGZMM0pPOEE1TmNpVFFa?=
 =?utf-8?B?S0FBL1d2dW1vK1NKR3VtbmZxQiswTUxXdFpBM2pjcHJJSGF4VlBUVlhmaWg4?=
 =?utf-8?B?WWE0Q244dWE2MndBRWRaSU01V0M5bG81Wis5SlJIcUJoTTFVSkN0RHk5cy83?=
 =?utf-8?B?QXFrNVovU2dmT3lza2tFaERZaHo5VTRrTkJoOVg4ODN6eUsxWGFpSDdkZnZM?=
 =?utf-8?B?MmQrTFBOaXNsbnpQVXEweUxEd2pjSzRlVUFrVGNLN3MzajJDbmwwZ2Y0dEtF?=
 =?utf-8?B?QmtOSkZqamZWcjk1RFM3RXUrWTBNN2NpVjAyNm5razRCNDVPZW8rbkgrdklF?=
 =?utf-8?B?anVqWkpDSklhMVpVd0htQXBZNFJtdDloU1dhaDg4cDEyTGcvZUpjaksxbzlR?=
 =?utf-8?B?RDNHV2NZSnZXNzFvcnN5WkVIT285cElNK0QyNitjLzFhaDBsWWZWOXVwV2E0?=
 =?utf-8?B?VGZvajNEbWNwZjlleG4zRmVhSmMzaWhzcFZsT0ZhTHlhbEJoK1lFT0VVVU90?=
 =?utf-8?B?MFlGcDZoVVNMN01GMG5NaFRYTUFGR2hieU5hMnlDZjllMDQvZlN4U01uSWlV?=
 =?utf-8?B?NHMva3h3SmgxcTRZZkxMUmx0YnZKRzJCZGloSUFQMVZqZ0JERzhxN3l1d0Rw?=
 =?utf-8?B?ZUpYdGZlWkoxcjNIUDJaQ3Rocms5NDB4SjIvWEVxOElROUlhZGRsQmJwaWgv?=
 =?utf-8?B?YkhRV2ZKSTUrQ0x3ajFFVWR0eUdJZnNjYU0rMmdSUVZqRFZpQTVjb3ZwaDJN?=
 =?utf-8?B?TUx0YnpjaG5kVmNKcVZhclIxcUhySVlzdCtkdzQvdWFOTVBva3d3Z2htbVZw?=
 =?utf-8?B?QzdGMExMVkZEUG9EYU0vWU9SekNqTFpVNTlTb3d6TVhwLzJmQWRucEhUY3I1?=
 =?utf-8?B?aDFqUDZlMkdSckdpYUJscy92K0x1UUhqY0dBZWhIdWdCS2hFN3RxdEJ3TE9U?=
 =?utf-8?B?bXd4azFpUXRzVVJRUGNYTnlJdGpEQ2Q1RVNkVkg4MHBnYlFodUNnZk85ekZV?=
 =?utf-8?B?NGVmUCtUYnFPeHBQM1NpOUJEZHBEb2pvaEJwZFVoVUYxQklwQyt4YkUvUUJn?=
 =?utf-8?B?VTNPdURMRXZ4cWZQa1Y3dloxSjBnZkNDdGFBYm9ka3FOeENaQThQbDNWbWUw?=
 =?utf-8?B?U2RXRmtpUmZ1Tk8yMk8wbmRMVjV6b01PNjdYVndsb25ub1BpN2pQdTF3Z3pw?=
 =?utf-8?B?K1FrVnhrazM1L0pwVWNHSUt1TWN3Z1UxVWFzR3lJYVZsZ3ZnR3Fnb0dPbDFZ?=
 =?utf-8?B?Z3RpUHVlL0JOV2FBK0VtdU9BZmgwNkZuRGRHZk8xL01GeWpSd2JJWDNWRzNY?=
 =?utf-8?B?M0NKV21nbjd2RzlPNXk4UHBXeG9jbGgveDdsL2FCckJvSjluY3pCSktPSzZX?=
 =?utf-8?B?RlBPcWErb3BibXFMRGEraFlyMlRwZUtvb2NpV1MwcmEweTVsVWppRGxJdy9h?=
 =?utf-8?B?TFB5LzlmN1R3YlozMUtlTDdwYm5JeWl4eTVabGR6MURQY0xtdUJJbm5mVFBW?=
 =?utf-8?B?dGs1RUFNcGRaSk83Zkw1MXorVjBuazc5WkVyd0JrSHBxcDZjcVpsQ1V4L29W?=
 =?utf-8?B?S0FNOTFDWUFPVElGUWRMU25LVCtsQVNyU0RDbnJvK2x5RlMxNVRaSnpqWjFT?=
 =?utf-8?B?ekJBdmw3bjlzMGVockJaRjVkRFEzeXVxai9td1pPb1d0RUFMU09vNFpNdjR6?=
 =?utf-8?B?TXB6aUhlSFdxVm1CRFh2ckRiR3J2cWxTaDg5ODlMa09sZnBkclZGWUhKakQ5?=
 =?utf-8?B?Y1h0TVZpVU9Sa3pUd2pIdnhOUGNiNnZFY0w2ZjI1THpRVzQ4YUpJWjhGT2F6?=
 =?utf-8?B?TW9hWnppSzIwYmNnelE0a2E3SnZ2K1FWQVd4OGpXeWh2bWJ5c1lvTGVybnc4?=
 =?utf-8?B?K01MbG1qbUM3N1ZhMnZsSHp2cUVWYTd1TXVOT09DMFFJc09JamN2amlxc2ZN?=
 =?utf-8?B?MmhCSzBZQmo3Q0lKdVUrZ1pRNmFNdi9PUTVPRVBnQzFYYmZvT0J0SGh2dGVp?=
 =?utf-8?B?OHRqSDUvQWtycnFFVXp4TnBnMWYySkhqUGdnNjlGY0dIS055T2NGL2UrZERI?=
 =?utf-8?B?cDlSbjAxdUNLQWUxSmNyRmV2K2ZMRyt0RDB1VjRhTnlKbVpFNis2bUZuUGNo?=
 =?utf-8?Q?pqY6jRBVOR0sNVmTO6IUDJw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <944C3E8CB2B01D44B74BB4038DDFEDBA@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a27763-3ea2-4f5b-fdf4-08daa7bf5fbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 17:22:41.3134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pTHm9BWHosgLsHe/r9X0INoJ+/FB5Kooii7fNm9KKWGwNrY4ZYq2KxYscZa7ptaYPFNiL9EevIzry/WEHTlBENklIU57c8mwdJeGgS2nL3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB2471
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
Og0KPiBUaGUgcHJhbmRvbV9ieXRlcygpIGZ1bmN0aW9uIGhhcyBiZWVuIGEgZGVwcmVjYXRlZCBp
bmxpbmUgd3JhcHBlciBhcm91bmQNCj4gZ2V0X3JhbmRvbV9ieXRlcygpIGZvciBzZXZlcmFsIHJl
bGVhc2VzIG5vdywgYW5kIGNvbXBpbGVzIGRvd24gdG8gdGhlDQo+IGV4YWN0IHNhbWUgY29kZS4g
UmVwbGFjZSB0aGUgZGVwcmVjYXRlZCB3cmFwcGVyIHdpdGggYSBkaXJlY3QgY2FsbCB0bw0KPiB0
aGUgcmVhbCBmdW5jdGlvbi4NCj4gDQo+IFJldmlld2VkLWJ5OiBLZWVzIENvb2sgPGtlZXNjb29r
QGNocm9taXVtLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogSmFzb24gQS4gRG9uZW5mZWxkIDxKYXNv
bkB6eDJjNC5jb20+DQoNClJldmlld2VkLWJ5OiBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhl
Lmxlcm95QGNzZ3JvdXAuZXU+IChQb3dlcnBjIHBhcnQpDQoNCj4gLS0tDQo+ICAgYXJjaC9wb3dl
cnBjL2NyeXB0by9jcmMtdnBtc3VtX3Rlc3QuYyAgICAgICB8ICAyICstDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC9wb3dlcnBjL2NyeXB0by9jcmMtdnBtc3VtX3Rlc3QuYyBiL2FyY2gvcG93ZXJw
Yy9jcnlwdG8vY3JjLXZwbXN1bV90ZXN0LmMNCj4gaW5kZXggYzFjMWVmOTQ1N2ZiLi4yNzNjNTI3
ODY4ZGIgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcG93ZXJwYy9jcnlwdG8vY3JjLXZwbXN1bV90ZXN0
LmMNCj4gKysrIGIvYXJjaC9wb3dlcnBjL2NyeXB0by9jcmMtdnBtc3VtX3Rlc3QuYw0KPiBAQCAt
ODIsNyArODIsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBjcmNfdGVzdF9pbml0KHZvaWQpDQo+ICAg
DQo+ICAgCQkJaWYgKGxlbiA8PSBvZmZzZXQpDQo+ICAgCQkJCWNvbnRpbnVlOw0KPiAtCQkJcHJh
bmRvbV9ieXRlcyhkYXRhLCBsZW4pOw0KPiArCQkJZ2V0X3JhbmRvbV9ieXRlcyhkYXRhLCBsZW4p
Ow0KPiAgIAkJCWxlbiAtPSBvZmZzZXQ7DQo+ICAgDQo+ICAgCQkJY3J5cHRvX3NoYXNoX3VwZGF0
ZShjcmN0MTBkaWZfc2hhc2gsIGRhdGErb2Zmc2V0LCBsZW4pOw==
