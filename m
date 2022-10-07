Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9E65F73C4
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 06:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiJGE5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 00:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJGE5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 00:57:30 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90054.outbound.protection.outlook.com [40.107.9.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D108D112AA2;
        Thu,  6 Oct 2022 21:57:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lh5j08N6jCfV2VeKBdJrJ+Z020WJWMrbJZs4LukNRoH37XN2UjgZvzVABR2xTnGkKxJykn+bpREHo5xxerR2b9PBDeexPhBQYVob6M1g6487HUkYCOtFsU6YfyGkKFDw76LYasEzSAaDYanvWNBu2wapvePeBBCZsHrELDpUxq8IRHpXnFkxrU7xb6D35AYZ8u+gLvEBWsasiqL3Ai4uyz8CLx7faJm1phibeFRS+sDu8yq8IS5TVFuiTqHWnUbfwefYcQvAqCdY4xwKsj6QrA80ViB2P1uvvMJmGfQK94DRadlvSpAGQ7L+UvTrhQRaBAo6SSOdNUVW5zwfa3W3vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oq4wMAaFj/7s0RVxjSrvoiqUcvKjXrV8XQwCN+AY2rs=;
 b=bSmA4b4wS+tsty+JFUvaxIvsY7bRnbSeCNiwybhPrLKeaoPTUbb0zCykaJcIMYIC8du+J6gWfrb+7U+ih9X5q/X7TeWQM7TeufbJL9r5Mae7pak4Dpihw7V6RGR/JdastkIG58KQwgWZ4nJOs8GZ+4fOEXyCN2C9NZtBT2WIbebwWV+2m/dvtnSM0MhQvKtjGe+AdY+cIp09jiL1cP1pfAc9pF1ROHgnafoovtccJYMibpSSQsbLA/wXsR8v2ri2GlFGIldDsa50lFkH/k5UEtzqL2S58LhY4CL8GX1XCFQCqebfhqWYrTy+cKHAD+2b8rL5w7HL8fK1GKUB7qL4nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oq4wMAaFj/7s0RVxjSrvoiqUcvKjXrV8XQwCN+AY2rs=;
 b=vvUxAKw3C5G8QkvwFz+9K6cBzdU3epT4Jf6xjHMxh4yl4SG8KaX/kErC5aerA/mUkd6rJ0z36XAowc8azfwB9o3nbI6QA5oFAmxEY1ZhCMfuLSzX6JrVow1KxOafssqmBqBRoABVRqGiW0zStJutvLSrWy8DsaKnwTA3RExYXOe+ZJ7sQ9nqLQCDvF3HX/oJ+pcENWPDl/qC4KoBiMCTf0L+v0a2p9m7ZEl0ADq6hMuZmxgB8GQvRbZJuM2waH38EgQ+ydeqBwIBwvvR0mFEdeRFFjnO1/n62CVy9fKdJSsuKtJ68OH9P+KcY0zroP8fDoLmVvhJlTbJCRTfyaWiDg==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRZP264MB2086.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 7 Oct
 2022 04:57:24 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c854:380d:c901:45af]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c854:380d:c901:45af%5]) with mapi id 15.20.5676.036; Fri, 7 Oct 2022
 04:57:24 +0000
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
Thread-Index: AQHY2aRLUOmMOiRiqUe6k1BKDHReSa4BnNgAgAAAygCAAAHkAIAAA1KAgABi4ACAAFmSgA==
Date:   Fri, 7 Oct 2022 04:57:24 +0000
Message-ID: <501b0fc3-6c67-657f-781e-25ee0283bc2e@csgroup.eu>
References: <20221006165346.73159-1-Jason@zx2c4.com>
 <20221006165346.73159-4-Jason@zx2c4.com>
 <848ed24c-13ef-6c38-fd13-639b33809194@csgroup.eu>
 <CAHmME9raQ4E00r9r8NyWJ17iSXE_KniTG0onCNAfMmfcGar1eg@mail.gmail.com>
 <f10fcfbf-2da6-cf2d-6027-fbf8b52803e9@csgroup.eu>
 <6396875c-146a-acf5-dd9e-7f93ba1b4bc3@csgroup.eu>
 <CAHmME9pE4saqnwxhsAwt-xegYGjsavPOGnHCbZhUXD7kaJ+GAA@mail.gmail.com>
In-Reply-To: <CAHmME9pE4saqnwxhsAwt-xegYGjsavPOGnHCbZhUXD7kaJ+GAA@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|MRZP264MB2086:EE_
x-ms-office365-filtering-correlation-id: ae4cff8a-e95b-42f1-753c-08daa8206d11
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ecYqdAkTmlRgnXmSnSqeTxHPrAmSWJdW2+ksYp/5CrlRUQSxGFELyDBnybCuCYO1HwmDqvagL4rCW/0eDX5lQxqdy9HPHHmqeQbB9VZNl1UV75r+sKm9PeEJ3/r0DW1agvZ6Rzdo0EmiF/z/ITM413QGiv9axIa+OznyfrjcSE4KhzzG68IvCYL8+ZlR33Dl6gW49Cnb8rJXvMjHDC8gwhZt6kcR28RTz7Q9O7wOGJL8U6drBpQhyFNsGeuq6Q/i+rR5dBMUx0Gc2mV3q/R3eGcVtij16JM7vgb1BlUYkejiszP3qyIqbVwMMpsVtksy1Gueic07MuZ/5Q8fXtyfavoHI5sDeFMSYr5HL8LrByALufIkd/GDXOr0UdJ2ArDeRWxZYIRvEGRHSrA75MciLIb+T0wGJTRm3otNH8DIwqCAS3zVBYICOITwedeehgRTLBrg5PVvkCZxip6ub1EW3F/zORDtVfvRHeWu3Bine1Xl6WnqYKqmQT3A6Bv7f1/J/2vGxamgAdEcAiQlIqlAi/NWuwo2zxULgu5lEz4dg8CIR6QZeacjjCgGHgL4sXpaPeFpo4R9/AKwyGp/30g9TgUh2iTwqdvqlcEv+NfGz8802SeG/NfGMJqwnhqRrMmsK/Te6aRg5Kh6NpMTPlB071ZRA9NmJacr8gGeGHS2BW/b9yLueEuNdcIcn7Pi4ZKc1Jxdctk/dzQGezS01UwQ2k6fN8e0ymuGVsvrx0VgmHDRZSLc7XcxboZfCTuQPJuTN70Txavto2+dzwH8n3PXMCZPDttLrBmBPOvty7xYYZ4HBYYbxuNpMRqKDELJYXfc0FftYEbKxk9H5ehAHpDOhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199015)(31686004)(8936002)(8676002)(5660300002)(7336002)(2906002)(36756003)(7366002)(7416002)(41300700001)(4326008)(7406005)(91956017)(31696002)(66446008)(54906003)(64756008)(66556008)(66476007)(76116006)(86362001)(316002)(66946007)(44832011)(6916009)(71200400001)(6486002)(478600001)(38070700005)(6506007)(26005)(53546011)(6512007)(66574015)(122000001)(2616005)(186003)(38100700002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjBiVnFrN3lGWlM0NXVKdGhSTDd4MVBDT2NmcUdkVy91MWFkNUpKdzZXWDJC?=
 =?utf-8?B?K3R6dFh5Q3lsbnRPS2JEL0lpM1o3M3ZzbzJGNkJraVZOeDVIVzRML3E0R0tW?=
 =?utf-8?B?bmN1dXE2eGpSRFJYRVVURUJHTEU0U21MT3MvL0VKdTdMT1cwenlRazFmK2hs?=
 =?utf-8?B?UDBuaEdES0hCRUw2akZzQm9hUUZPeUNES3hzbVg5SDhsVXJ1a0VnR3NKR3dp?=
 =?utf-8?B?MFZ5S29WMEF3OWVVR2JINzB0OW9VOHJ0aG5DZXJNQkgzTmU2c1NkZjI2WDBy?=
 =?utf-8?B?TDZrQldhL0YvVkcvTlF6c0NScVQyNlZHREdoS0ZMcnB4Yjk3cS96K05QN2xF?=
 =?utf-8?B?NDJHMnU0cG1JQlUvUjFiWFBKc1Zld1JpREpHaG0vaStpRm5WUG1uT1JpSXdr?=
 =?utf-8?B?SUttQUtqb2NJRzdjOWNWNVBqeWZPTGNlRlFlNXgyYy9aNTBWbitOZkJodTRB?=
 =?utf-8?B?dEYwYjFJODR1WlRlRE02d2dPUlJUNXRHZGJXMWtSRlRQaEFtKys4YWdLZGhw?=
 =?utf-8?B?TklpZWpoMjlwRFd4QnlYMjM2Q09SQ2lJWHVncXZKdERRNTkwc1pqYUczeC91?=
 =?utf-8?B?THIrVnppb2tIOGtKT2llUFJ3NHRTci9EOU5iVU1Sa2doQ0t6MzQyN0xRZW1j?=
 =?utf-8?B?VkU4Q08wVHdWUVI2Z2FlSW9nUVdPWUNXSEtIMTF4dEVkekVHY0ZuT1ErZWJ3?=
 =?utf-8?B?YVBMWkQ1ZEdJWEJlaFNKNU1KOGhRODAwU2I5UGYxVTV3T1NOTktrdVJ1MkZ2?=
 =?utf-8?B?TFF5dFlpL2s2TlFGdkR2QUFjYStKMS9oRjZmSVJ5OEZPd1Y3TGk1QWo2K2Rx?=
 =?utf-8?B?WkxZby9TMXBnUlNrdDM0TXVIMFF2aW9kRnFWRHRVa3F3dUl6WE81T2JJSThx?=
 =?utf-8?B?OFdUUkZoUGtZZHRYWi9KNjh5MXYrQ1RFQ1hydUZHNXAwSTRDZ0pUMmVsQWpt?=
 =?utf-8?B?amhveVFtalJlUnpLRXB5Nkd4R09sZUx5K3R6WUtHS21uamhOT3Q4OVFTcFY3?=
 =?utf-8?B?cW9qeEdVS2tJZ2JhNTNxNDk5ckhjVUduTVhOS0N1L1M4Tk9hWmJRZHEvdFlQ?=
 =?utf-8?B?SER3THhoZlJVeVg1T0s2TklZUWdodVZaWUpQMURJd1lTYTBJbXgyMkxlRGZl?=
 =?utf-8?B?YXNzZk92dTVqOEtJT21RYTFKUHNZSHEwQkJsc0cwekNlbm44RkpTb1hnZkox?=
 =?utf-8?B?c0lQOHVoTUY5TFlsNUxrU2tXa1hrNmU3OGlPVk1NeDI2YlpnNEExZVBqVTJG?=
 =?utf-8?B?L0Y2VEU4ekVocDJtOWMxTXF1QWZ5L3JDRGVRakllVnl3cS9hU1praEpWcVBN?=
 =?utf-8?B?MFhFb1d6NzhES3VFTWhkU001VW03NkI2K2JCeXkvK1plMFBqZzdSRFhQY2lC?=
 =?utf-8?B?ZSt6TVk0WWdzcmJDVlE2Vlg4MWp1Tld2b0M1dmR5N2h0RFZIVjBHaDQxdG01?=
 =?utf-8?B?UTRnc2cwb2pQQjhVK0ZpanJGVytiVHZwMkxvWGpHY0tlQTFvZDc2MW9ObFdW?=
 =?utf-8?B?RlNmZHV4TEpqQTZVZmRubE9pT3hqbHVDWkZ1Q2dLb05xUHRZVnF0Q2Q2bjNn?=
 =?utf-8?B?dllwZTRFNytEQm1uYnF3WDUzUHJOeUtDbXF3eklha1VxQm5yd3ZZNGU2eE55?=
 =?utf-8?B?MktpSlovRjdHbXlHdEtSTjJ6eFFwdkg2a1VrVm1ONm1UdCtIVkFNUE9VMkdt?=
 =?utf-8?B?Qm9oVzAvd1NWdkxPc29DTituOWdPQXVaSm0yaDdZL3pjQ043dThtYlhvNVAv?=
 =?utf-8?B?ejhwdkExOXBtMnJSdTVIbEc4dHRHUHJFTktTbGxyMmlOeE9id212Z2U3ajF5?=
 =?utf-8?B?MXJJUEZZank3cWphMmN3ZGFyZms2Z0xWU1R0NGZQVnBTRlZGM3pwRmhZWUFo?=
 =?utf-8?B?TlY1RFk4YkFzdllNSmRFOFdHb3lvYkNIODErWXpZZEo1WE54a2Vad0k1WVRM?=
 =?utf-8?B?bVd5aW5iMUhXUHhhUFFhWFp4clVoTDViYkxncjRLRmdMUm9tRFQ1Z2xiNGpZ?=
 =?utf-8?B?QTVoTjhxNk0vdDJjTU9EbVV5ZkVlaVN3ZVN6RUlhbUVwbFVrbHdiOW5scjNG?=
 =?utf-8?B?akE1MVVLZDlWeExuSk12MDJaOTRHM0hiRXk5dHVtNmE5ckVOWjNKNGs4WmIr?=
 =?utf-8?B?YS9GMER1ZlZPN0JUMWJObUVoSHlKMzVYWkFsV1FBaTdZNldyaW9hVk15VnBa?=
 =?utf-8?Q?AoqtEj+pAO/r5/nujYdg9vY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8277F4805BBBC64490B411D5CECB85D7@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4cff8a-e95b-42f1-753c-08daa8206d11
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2022 04:57:24.8002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cq1ecfOnhv4ymIgLNsdDILWsoBKaeYECzn9QuW4ShXFVtYbHn9+XhLVJ1f9K7Q6r2K8dxDM0MNT/5Y7NJ8vkQB91TU68Hdx5urMk3Ygdur8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB2086
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDA3LzEwLzIwMjIgw6AgMDE6MzYsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBPbiAxMC82LzIyLCBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3Jv
dXAuZXU+IHdyb3RlOg0KPj4NCj4+DQo+PiBMZSAwNi8xMC8yMDIyIMOgIDE5OjMxLCBDaHJpc3Rv
cGhlIExlcm95IGEgw6ljcml0IDoNCj4+Pg0KPj4+DQo+Pj4gTGUgMDYvMTAvMjAyMiDDoCAxOToy
NCwgSmFzb24gQS4gRG9uZW5mZWxkIGEgw6ljcml0IDoNCj4+Pj4gSGkgQ2hyaXN0b3BoZSwNCj4+
Pj4NCj4+Pj4gT24gVGh1LCBPY3QgNiwgMjAyMiBhdCAxMToyMSBBTSBDaHJpc3RvcGhlIExlcm95
DQo+Pj4+IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+IHdyb3RlOg0KPj4+Pj4gTGUgMDYv
MTAvMjAyMiDDoCAxODo1MywgSmFzb24gQS4gRG9uZW5mZWxkIGEgw6ljcml0IDoNCj4+Pj4+PiBU
aGUgcHJhbmRvbV91MzIoKSBmdW5jdGlvbiBoYXMgYmVlbiBhIGRlcHJlY2F0ZWQgaW5saW5lIHdy
YXBwZXIgYXJvdW5kDQo+Pj4+Pj4gZ2V0X3JhbmRvbV91MzIoKSBmb3Igc2V2ZXJhbCByZWxlYXNl
cyBub3csIGFuZCBjb21waWxlcyBkb3duIHRvIHRoZQ0KPj4+Pj4+IGV4YWN0IHNhbWUgY29kZS4g
UmVwbGFjZSB0aGUgZGVwcmVjYXRlZCB3cmFwcGVyIHdpdGggYSBkaXJlY3QgY2FsbCB0bw0KPj4+
Pj4+IHRoZSByZWFsIGZ1bmN0aW9uLiBUaGUgc2FtZSBhbHNvIGFwcGxpZXMgdG8gZ2V0X3JhbmRv
bV9pbnQoKSwgd2hpY2ggaXMNCj4+Pj4+PiBqdXN0IGEgd3JhcHBlciBhcm91bmQgZ2V0X3JhbmRv
bV91MzIoKS4NCj4+Pj4+Pg0KPj4+Pj4+IFJldmlld2VkLWJ5OiBLZWVzIENvb2sgPGtlZXNjb29r
QGNocm9taXVtLm9yZz4NCj4+Pj4+PiBBY2tlZC1ieTogVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu
IDx0b2tlQHRva2UuZGs+ICMgZm9yIHNjaF9jYWtlDQo+Pj4+Pj4gQWNrZWQtYnk6IENodWNrIExl
dmVyIDxjaHVjay5sZXZlckBvcmFjbGUuY29tPiAjIGZvciBuZnNkDQo+Pj4+Pj4gUmV2aWV3ZWQt
Ynk6IEphbiBLYXJhIDxqYWNrQHN1c2UuY3o+ICMgZm9yIGV4dDQNCj4+Pj4+PiBTaWduZWQtb2Zm
LWJ5OiBKYXNvbiBBLiBEb25lbmZlbGQgPEphc29uQHp4MmM0LmNvbT4NCj4+Pj4+PiAtLS0NCj4+
Pj4+DQo+Pj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9rZXJuZWwvcHJvY2Vzcy5jDQo+
Pj4+Pj4gYi9hcmNoL3Bvd2VycGMva2VybmVsL3Byb2Nlc3MuYw0KPj4+Pj4+IGluZGV4IDBmYmRh
ODljZDFiYi4uOWM0YzE1YWZiYmU4IDEwMDY0NA0KPj4+Pj4+IC0tLSBhL2FyY2gvcG93ZXJwYy9r
ZXJuZWwvcHJvY2Vzcy5jDQo+Pj4+Pj4gKysrIGIvYXJjaC9wb3dlcnBjL2tlcm5lbC9wcm9jZXNz
LmMNCj4+Pj4+PiBAQCAtMjMwOCw2ICsyMzA4LDYgQEAgdm9pZCBub3RyYWNlIF9fcHBjNjRfcnVu
bGF0Y2hfb2ZmKHZvaWQpDQo+Pj4+Pj4gICAgIHVuc2lnbmVkIGxvbmcgYXJjaF9hbGlnbl9zdGFj
ayh1bnNpZ25lZCBsb25nIHNwKQ0KPj4+Pj4+ICAgICB7DQo+Pj4+Pj4gICAgICAgICBpZiAoIShj
dXJyZW50LT5wZXJzb25hbGl0eSAmIEFERFJfTk9fUkFORE9NSVpFKSAmJg0KPj4+Pj4+IHJhbmRv
bWl6ZV92YV9zcGFjZSkNCj4+Pj4+PiAtICAgICAgICAgICAgIHNwIC09IGdldF9yYW5kb21faW50
KCkgJiB+UEFHRV9NQVNLOw0KPj4+Pj4+ICsgICAgICAgICAgICAgc3AgLT0gZ2V0X3JhbmRvbV91
MzIoKSAmIH5QQUdFX01BU0s7DQo+Pj4+Pj4gICAgICAgICByZXR1cm4gc3AgJiB+MHhmOw0KPj4+
Pj4NCj4+Pj4+IElzbid0IHRoYXQgYSBjYW5kaWRhdGUgZm9yIHByYW5kb21fdTMyX21heCgpID8N
Cj4+Pj4+DQo+Pj4+PiBOb3RlIHRoYXQgc3AgaXMgZGVlbWVkIHRvIGJlIDE2IGJ5dGVzIGFsaWdu
ZWQgYXQgYWxsIHRpbWUuDQo+Pj4+DQo+Pj4+IFllcywgcHJvYmFibHkuIEl0IHNlZW1lZCBub24t
dHJpdmlhbCB0byB0aGluayBhYm91dCwgc28gSSBkaWRuJ3QuIEJ1dA0KPj4+PiBsZXQncyBzZWUg
aGVyZS4uLiBtYXliZSBpdCdzIG5vdCB0b28gYmFkOg0KPj4+Pg0KPj4+PiBJZiBQQUdFX01BU0sg
aXMgYWx3YXlzIH4oUEFHRV9TSVpFLTEpLCB0aGVuIH5QQUdFX01BU0sgaXMNCj4+Pj4gKFBBR0Vf
U0laRS0xKSwgc28gcHJhbmRvbV91MzJfbWF4KFBBR0VfU0laRSkgc2hvdWxkIHlpZWxkIHRoZSBz
YW1lDQo+Pj4+IHRoaW5nPyBJcyB0aGF0IGFjY3VyYXRlPyBBbmQgaG9sZHMgYWNyb3NzIHBsYXRm
b3JtcyAodGhpcyBjb21lcyB1cCBhDQo+Pj4+IGZldyBwbGFjZXMpPyBJZiBzbywgSSdsbCBkbyB0
aGF0IGZvciBhIHY0Lg0KPj4+Pg0KPj4+DQo+Pj4gT24gcG93ZXJwYyBpdCBpcyBhbHdheXMgKGZy
b20gYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL3BhZ2UuaCkgOg0KPj4+DQo+Pj4gLyoNCj4+PiAg
ICAqIFN1YnRsZTogKDEgPDwgUEFHRV9TSElGVCkgaXMgYW4gaW50LCBub3QgYW4gdW5zaWduZWQg
bG9uZy4gU28gaWYgd2UNCj4+PiAgICAqIGFzc2lnbiBQQUdFX01BU0sgdG8gYSBsYXJnZXIgdHlw
ZSBpdCBnZXRzIGV4dGVuZGVkIHRoZSB3YXkgd2Ugd2FudA0KPj4+ICAgICogKGkuZS4gd2l0aCAx
cyBpbiB0aGUgaGlnaCBiaXRzKQ0KPj4+ICAgICovDQo+Pj4gI2RlZmluZSBQQUdFX01BU0sgICAg
ICAofigoMSA8PCBQQUdFX1NISUZUKSAtIDEpKQ0KPj4+DQo+Pj4gI2RlZmluZSBQQUdFX1NJWkUg
ICAgICAgICgxVUwgPDwgUEFHRV9TSElGVCkNCj4+Pg0KPj4+DQo+Pj4gU28gaXQgd291bGQgd29y
ayBJIGd1ZXNzLg0KPj4NCj4+IEJ1dCB0YWtpbmcgaW50byBhY2NvdW50IHRoYXQgc3AgbXVzdCBy
ZW1haW4gMTYgYnl0ZXMgYWxpZ25lZCwgd291bGQgaXQNCj4+IGJlIGJldHRlciB0byBkbyBzb21l
dGhpbmcgbGlrZSA/DQo+Pg0KPj4gCXNwIC09IHByYW5kb21fdTMyX21heChQQUdFX1NJWkUgPj4g
NCkgPDwgNDsNCj4+DQo+PiAJcmV0dXJuIHNwOw0KPiANCj4gRG9lcyB0aGlzIGFzc3VtZSB0aGF0
IHNwIGlzIGFscmVhZHkgYWxpZ25lZCBhdCB0aGUgYmVnaW5uaW5nIG9mIHRoZQ0KPiBmdW5jdGlv
bj8gSSdkIGFzc3VtZSBmcm9tIHRoZSBmdW5jdGlvbidzIG5hbWUgdGhhdCB0aGlzIGlzbid0IHRo
ZQ0KPiBjYXNlPw0KDQpBaCB5b3UgYXJlIHJpZ2h0LCBJIG92ZXJsb29rZWQgaXQuDQoNCkxvb2tp
bmcgaW4gbW9yZSBkZXRhaWxzLCBJIHNlZSB0aGF0IGFsbCBhcmNoaXRlY3R1cmVzIHRoYXQgaW1w
bGVtZW50IGl0IA0KaW1wbGVtZW50IGl0IGFsbW9zdCB0aGUgc2FtZSB3YXkuDQoNCkJ5IHRoZSB3
YXksIHRoZSBjb21tZW50IGluIGFyY2gvdW0va2VybmVsL3Byb2Nlc3MuYyBpcyBvdmVyZGF0ZWQu
DQoNCk1vc3QgYXJjaGl0ZWN0dXJlcyBBTkQgdGhlIHJhbmRvbSB2YWx1ZSB3aXRoIH5QQUdFX01B
U0ssIHg4NiBhbmQgdW0gdXNlIA0KJTgxOTIuIFNlZW1zIGxpa2UgYXQgdGhlIHRpbWUgMi42LjEy
IHdhcyBpbnRyb2R1Y2VkIGludG8gZ2l0LCBvbmx5IGkzODYgDQp4ODZfNjQgYW5kIHVtIGhhZCB0
aGF0IGZ1bmN0aW9uLg0KDQpNYXliZSBpdCBpcyB0aW1lIGZvciBhIGNsZWFudXAgYW5kIGEgcmVm
YWN0b3JpbmcgPyBBcmNoaXRlY3R1cmVzIHdvdWxkIA0KanVzdCBoYXZlIHRvIHByb3ZpZGUgU1RB
Q0tfQUxJR04ganVzdCBsaWtlIGxvb25nYXJjaCBkb2VzIHRvZGF5LCBhbmQgd2UgDQpjb3VsZCBn
ZXQgYSBnZW5lcmljIGFyY2hfYWxpZ25fc3RhY2soKSA/DQoNCkNocmlzdG9waGU=
