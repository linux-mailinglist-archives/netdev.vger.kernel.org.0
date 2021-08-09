Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98C43E4EA5
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhHIVkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhHIVky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:40:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE45AC0613D3;
        Mon,  9 Aug 2021 14:40:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mDD0V-0003Bz-D7; Mon, 09 Aug 2021 23:40:27 +0200
Date:   Mon, 9 Aug 2021 23:40:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot <syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Write in nft_ct_tmpl_put_pcpu
Message-ID: <20210809214027.GQ607@breakpoint.cc>
References: <000000000000b720b705c8f8599f@google.com>
 <cdb5f0c9-1ad9-dd9d-b24d-e127928ada98@gmail.com>
 <20210809203916.GP607@breakpoint.cc>
 <2d002841-402c-2bc3-2b33-3e6d1cd14c23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d002841-402c-2bc3-2b33-3e6d1cd14c23@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> wrote:
> Dumb question: why per_cpu() will return 2 different pointers for CPU 1 and
> CPU 0? As I understand for_each_possible_cpu() will iterate over all
> CPUs which could ever be enabled. So, we can hit situation when 2 concurrent
> processes call per_cpu() with same cpu value (*).

Yes, that is what I was trying to say, the race is that we can have > 1
processes here ever since the global transaction mutex was removed in 2018.

> Anyway, I think, moving locking a bit higher is good here, let's test it. I
> will prepare a patch, if it will pass syzbot testing, thanks!

It looks correct to me, thanks.
