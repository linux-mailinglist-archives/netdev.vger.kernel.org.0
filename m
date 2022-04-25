Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB98350E9BC
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 21:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245031AbiDYTuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 15:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236319AbiDYTuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 15:50:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C472E0A6;
        Mon, 25 Apr 2022 12:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CDpUuIHBz9utme4HYmnPB9jlX5wAYTkIatIIrYSgRaU=; b=bPti1CJxxbB4Apc+Rukia3Ksuy
        diAS613hAvsUgO0pjPsGXYmvH/+yBxeQ98DlxDxgmn+7p0PfO0XjLKMg7Oh9LxUENgfUZ9Pe6U0DI
        rEJmPjC6Vk/izJJksWttViwnIoFFFRwznTabprUjOTz2gyCXulqgMzYOqKFoQ3Mdh47Oc06rkX5eP
        CA79G6auAIOQVeys+731iCZIyVJQjVT+3PLsmplXWFsL+kHcFageB1fgRyd32WiPZOei1QtyNJ2zP
        h+YPhjp5Wn+16AYI38y38JKl8RVyIb0lfYJLdzDGZ/JgWusR6lnMAQ+1X4vIS+LjIfCTEGDPLblQK
        AvtPm/Qw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nj4fq-00B6wz-Jr; Mon, 25 Apr 2022 19:47:06 +0000
Date:   Mon, 25 Apr 2022 12:47:06 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [net-next v4 0/3] use standard sysctl macro
Message-ID: <Ymb6ukQNDh6VBT59@bombadil.infradead.org>
References: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
 <YmK/PM2x5PTG2b+c@bombadil.infradead.org>
 <20220422124340.2382da79@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422124340.2382da79@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 12:43:40PM -0700, Jakub Kicinski wrote:
> On Fri, 22 Apr 2022 07:44:12 -0700 Luis Chamberlain wrote:
> > On Fri, Apr 22, 2022 at 03:01:38PM +0800, xiangxia.m.yue@gmail.com wrote:
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > 
> > > This patchset introduce sysctl macro or replace var
> > > with macro.
> > > 
> > > Tonghao Zhang (3):
> > >   net: sysctl: use shared sysctl macro
> > >   net: sysctl: introduce sysctl SYSCTL_THREE
> > >   selftests/sysctl: add sysctl macro test  
> > 
> > I see these are based on net-next, to avoid conflicts with
> > sysctl development this may be best based on sysctl-next
> > though. Jakub?
> 
> I guess the base should be whatever we are going to use as
> a base for a branch, the branch we can both pull in?
> 
> How many patches like that do you see flying around, tho?
> I feel like I've seen at least 3 - netfilter, net core and bpf.
> It's starting to feel like we should have one patch that adds all 
> the constants and self test, put that in a branch anyone can pull in,
> and then do the conversions in separate patches..
> 
> Option number two - rename the statics in the subsystems to SYSCTL_x,
> and we can do a much smaller cleanup in the next cycle which would
> replace those with a centralized instances? That should have minimal
> chance of conflicts so no need to do special branches.
> 
> Option number three defer all this until the merge window.

I have a better option. I checked to see the diff stat between
the proposed patch to see what the chances of a conflict are
and so far I don't see any conflict so I think this patchset
should just go through your tree.

So feel free to take it in! Let me know if that's OK!

The proposed pathset diffstat:

  fs/proc/proc_sysctl.c                    |  2 +-
  include/linux/sysctl.h                   |  9 ++---
  lib/test_sysctl.c                        | 21 ++++++++++++
  net/core/sysctl_net_core.c               | 13 +++----
  net/ipv4/sysctl_net_ipv4.c               | 16 ++++-----
  net/ipv6/sysctl_net_ipv6.c               |  6 ++--
  net/netfilter/ipvs/ip_vs_ctl.c           |  4 +--
  tools/testing/selftests/sysctl/sysctl.sh | 43 ++++++++++++++++++++++++
  8 files changed, 84 insertions(+), 30 deletions(-)

The sysctl-next diff stat:

 fs/proc/proc_sysctl.c        |  88 ++++++-----
 include/linux/acct.h         |   1 -
 include/linux/delayacct.h    |   3 -
 include/linux/ftrace.h       |   3 -
 include/linux/initrd.h       |   2 -
 include/linux/latencytop.h   |   3 -
 include/linux/lockdep.h      |   4 -
 include/linux/oom.h          |   4 -
 include/linux/panic.h        |   6 -
 include/linux/reboot.h       |   4 -
 include/linux/sched/sysctl.h |  41 -----
 include/linux/writeback.h    |  15 --
 init/do_mounts_initrd.c      |  22 ++-
 kernel/acct.c                |  22 ++-
 kernel/bpf/syscall.c         |  87 ++++++++++
 kernel/delayacct.c           |  22 ++-
 kernel/latencytop.c          |  41 +++--
 kernel/locking/lockdep.c     |  35 ++++-
 kernel/panic.c               |  26 ++-
 kernel/rcu/rcu.h             |   2 +
 kernel/reboot.c              |  34 +++-
 kernel/sched/core.c          |  69 +++++---
 kernel/sched/deadline.c      |  42 ++++-
 kernel/sched/fair.c          |  32 +++-
 kernel/sched/rt.c            |  63 +++++++-
 kernel/sched/sched.h         |   7 +
 kernel/sched/topology.c      |  25 ++-
 kernel/sysctl.c              | 366 -------------------------------------------
 kernel/trace/ftrace.c        | 101 +++++++-----
 mm/oom_kill.c                |  38 ++++-
 mm/page-writeback.c          | 104 ++++++++++--
 31 files changed, 718 insertions(+), 594 deletions(-)

   Luis
