Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C052C2E05E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfE2O7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:59:04 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54704 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfE2O7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 10:59:04 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hW02W-0006AC-Rs; Wed, 29 May 2019 22:58:52 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hW02P-0004f6-Qx; Wed, 29 May 2019 22:58:45 +0800
Date:   Wed, 29 May 2019 22:58:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Thomas Graf <tgraf@suug.ch>,
        syzbot <syzbot+bc5ab0af2dbf3b0ae897@syzkaller.appspotmail.com>,
        bridge@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: use-after-free Read in br_mdb_ip_get
Message-ID: <20190529145845.bcvuc5ows4dedqh3@gondor.apana.org.au>
References: <000000000000862b160580765e94@google.com>
 <3c44c1ff-2790-ec06-35c6-3572b92170c7@cumulusnetworks.com>
 <CACT4Y+ZA8gBURbeZaDtrt5NoqFy8a8W3jyaWbs34Qjic4Bu+DA@mail.gmail.com>
 <20190220102327.lq2zyqups2fso75z@gondor.apana.org.au>
 <CACT4Y+bUTWcvqEebNjoagw0JtM77NXwVu+i3cYmhgnntZRWyfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+bUTWcvqEebNjoagw0JtM77NXwVu+i3cYmhgnntZRWyfg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry:

On Thu, Feb 21, 2019 at 11:54:42AM +0100, Dmitry Vyukov wrote:
>
> Taking into account that this still happened only once, I tend to
> write it off onto a previous silent memory corruption (we have dozens
> of known bugs that corrupt memory). So if several people already
> looked at it and don't see the root cause, it's probably time to stop
> spending time on this until we have more info.
> 
> Although, there was also this one:
> https://groups.google.com/d/msg/syzkaller-bugs/QfCCSxdB1aM/y2cn9IZJCwAJ
> I have not checked if it can be the root cause of this report, but it
> points suspiciously close to this stack and when I looked at it, it
> the report looked legit.

Have you had any more reports of this kind coming from br_multicast?

It looks like

ommit 1515a63fc413f160d20574ab0894e7f1020c7be2
Author: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date:   Wed Apr 3 23:27:24 2019 +0300

    net: bridge: always clear mcast matching struct on reports and leaves

may have at least fixed the uninitialised value error.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
