Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32CE4347E4
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhJTJbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhJTJbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 05:31:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913EDC06161C;
        Wed, 20 Oct 2021 02:29:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1md7ts-0001iL-VA; Wed, 20 Oct 2021 11:28:45 +0200
Date:   Wed, 20 Oct 2021 11:28:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 07/10] bpf: Add helpers to query conntrack info
Message-ID: <20211020092844.GI28644@breakpoint.cc>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-8-maximmi@nvidia.com>
 <20211020035622.lgrxnrwfeak2e75a@apollo.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020035622.lgrxnrwfeak2e75a@apollo.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> On Tue, Oct 19, 2021 at 08:16:52PM IST, Maxim Mikityanskiy wrote:
> > The new helpers (bpf_ct_lookup_tcp and bpf_ct_lookup_udp) allow to query
> > connection tracking information of TCP and UDP connections based on
> > source and destination IP address and port. The helper returns a pointer
> > to struct nf_conn (if the conntrack entry was found), which needs to be
> > released with bpf_ct_release.
> >
> > Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> The last discussion on this [0] suggested that stable BPF helpers for conntrack
> were not desired, hence the recent series [1] to extend kfunc support to modules
> and base the conntrack work on top of it, which I'm working on now (supporting
> both CT lookup and insert).

This will sabotage netfilter pipeline and the way things work more and
more 8-(

If you want to use netfilter with ebpf, please have a look at the RFC I
posted and lets work on adding a netfilter specific program type that
can run ebpf programs directly from any of the existing netfilter hook
points.

Thanks.
