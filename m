Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD4E586673
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 10:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiHAIhQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Aug 2022 04:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiHAIhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 04:37:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 279B72E6A2
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 01:37:13 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-60-CksiPPRtPA6w1mXQckakNQ-1; Mon, 01 Aug 2022 09:37:09 +0100
X-MC-Unique: CksiPPRtPA6w1mXQckakNQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Mon, 1 Aug 2022 09:37:04 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Mon, 1 Aug 2022 09:37:04 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stephen Hemminger' <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>, Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Xin Long <lucien.xin@gmail.com>,
        "Akhmat Karakotov" <hmukos@yandex-team.ru>,
        Antoine Tenart <atenart@kernel.org>,
        "Hans de Goede" <hdegoede@redhat.com>,
        Juergen Gross <jgross@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Xie Yongji <xieyongji@bytedance.com>,
        Chen Yu <yu.c.chen@intel.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        "Suma Hegde" <suma.hegde@amd.com>,
        =?iso-8859-1?Q?Pali_Roh=E1r?= <pali@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Scott Wood <oss@buserror.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Wang Qing" <wangqing@vivo.com>, Yu Zhe <yuzhe@nfschina.com>,
        Benjamin Poirier <bpoirier@nvidia.com>,
        Victor Erminpour <victor.erminpour@oracle.com>,
        "GONG, Ruiqi" <gongruiqi1@huawei.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Subject: RE: [RFC] Remove DECNET support from kernel
Thread-Topic: [RFC] Remove DECNET support from kernel
Thread-Index: AQHYpREB8DXx1AZd/0ac5Son0/agPK2ZuBOg
Date:   Mon, 1 Aug 2022 08:37:03 +0000
Message-ID: <c43f221d8e824cd2bf9746596423befc@AcuMS.aculab.com>
References: <20220731190646.97039-1-stephen@networkplumber.org>
In-Reply-To: <20220731190646.97039-1-stephen@networkplumber.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger
> Sent: 31 July 2022 20:06
> To: netdev@vger.kernel.org
> 
> Decnet is an obsolete network protocol that receives more attention
> from kernel janitors than users. It belongs in computer protocol
> history museum not in Linux kernel.
> 
> It has been Orphaned in kernel since 2010.
> And the documentation link on Sourceforge says it is abandoned there.

It was pretty much obsolete when I was writing ethernet drivers
in the early 1990's.
Sort of surprising support ever got into Linux in the first place!

Remember it requires the ethernet MAC address be set to a
locally assigned value that is the machine's 'node number'.

Does this remove some/most/all of the [gs]et_sockopt() calls
where the length is ignored/

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

