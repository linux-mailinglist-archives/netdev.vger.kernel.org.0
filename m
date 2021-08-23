Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C263F510D
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhHWTLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhHWTLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 15:11:21 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1A4C061575;
        Mon, 23 Aug 2021 12:10:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mIFL7-0004q7-4Q; Mon, 23 Aug 2021 21:10:33 +0200
Date:   Mon, 23 Aug 2021 21:10:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: Suspicious pattern for use of function xt_register_template()
Message-ID: <20210823191033.GA23869@breakpoint.cc>
References: <CAKXUXMzdGdyQg9CXJ2AZStrBk3J10r5r=gyiAuU4WimnoQNyvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKXUXMzdGdyQg9CXJ2AZStrBk3J10r5r=gyiAuU4WimnoQNyvA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
> Dear Florian, dear netfilter maintainers,
> 
> Commit fdacd57c79b ("netfilter: x_tables: never register tables by
> default") on linux-next
> introduces the function xt_register_template() and in all cases but
> one, the calls to that function are followed by:
> 
>     if (ret < 0)
>         return ret;
> 
> All these checks were also added with the commit above.
> 
> In the one case, for iptable_mangle_init() in
> ./net/ipv4/netfilter/iptable_mangle.c, this pattern was not followed.

Thats a bug, the error test is missing.
