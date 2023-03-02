Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53AB76A836C
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 14:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjCBNXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 08:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCBNXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 08:23:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1561421C;
        Thu,  2 Mar 2023 05:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MBSijBkL6qrcNLxK5wTEA5G9IQhSmVi9FlzoMJu1guM=; b=q5Iqf/wvr7dnc8RUnfJqJjgQSv
        7d9aK0GlNvEYZSF7M/VlM6Lr8W7eBHRVZmAk6Cbj4U0/0HxLnYN6uE+MMEGUg6vHNdUeeggQvMZe2
        o0Me9E80vG0jPQrVUpM4N5c77KBgHHb83w06uB8Fhe6VDE2X/LNVolzl56nftYaHr3yAGkaK8SF2u
        IO4bd5BMCUSguEkpxcVeWpXDykAiH1T4oI7l6yuYmo/ElJui+RmepSdI7slviWOGFHx16PIXpqVPt
        goPiBOQHymwTy8PR1qxvVnZ0NN1qiM1BDaE97GEqW7KxNNwPfB+/6q4YWaR678wjxl8HutKidg+Nc
        ccLnteWg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pXith-002QVV-P7; Thu, 02 Mar 2023 13:23:01 +0000
Date:   Thu, 2 Mar 2023 13:23:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     syzbot <syzbot+0adf31ecbba886ab504f@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, davem@davemloft.net, dvyukov@google.com,
        edumazet@google.com, elver@google.com, glider@google.com,
        hdanton@sina.com, kasan-dev@googlegroups.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] INFO: task hung in write_cache_pages (2)
Message-ID: <ZACjNSxGlVX6l39S@casper.infradead.org>
References: <000000000000e794f505f5e0029c@google.com>
 <00000000000099b9c905f5e9a820@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000099b9c905f5e9a820@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 04:06:28AM -0800, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 17bb55487988c5dac32d55a4f085e52f875f98cc
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Date:   Tue May 17 22:12:25 2022 +0000
> 
>     ntfs: Remove check for PageError

Syzbot has bisected to the wrong commit.  That code (a) isn't going
to be executed by this test, since it doesn't have an ntfs image and
(b) was dead.  Never could have been executed.

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13fd6e54c80000
> start commit:   489fa31ea873 Merge branch 'work.misc' of git://git.kernel...
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10036e54c80000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17fd6e54c80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cbfa7a73c540248d
> dashboard link: https://syzkaller.appspot.com/bug?extid=0adf31ecbba886ab504f
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16dc6960c80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f39d50c80000
> 
> Reported-by: syzbot+0adf31ecbba886ab504f@syzkaller.appspotmail.com
> Fixes: 17bb55487988 ("ntfs: Remove check for PageError")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
