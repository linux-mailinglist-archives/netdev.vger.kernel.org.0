Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F1746AF0A
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378300AbhLGAZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378305AbhLGAZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:25:10 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402A9C0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:21:41 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id d10so36144427ybe.3
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XB+gMw2XPIB6d2anw8a/blMCNlLvNFmxKzwQSFKnGW8=;
        b=eJznjy2lGc6dPpHGBvOm7kPk6Yr4b8/Qu+2i6/vOHL2A3D0J57PmTfZmsfQ8Ib7aBO
         p6iPmGex+aL27zh5wWfNsog9vxfVGRZoaCBo0rqq4KklYlHglR+9g2w9DOV48YB4npG4
         KNCcTWS/qadwFmKojVtZyDGuhj1AR110G1sekoivSLmBHm0ZlhrR/fRVKbL/QVCKQyn6
         AeA/aKwlcTERdzwQFHMliPiLf3/9B+U73aaBeXPrLiyi72O/4q7MsP5JhRGrY7/sg59n
         0lCHlMXjSYTNjsVzDcL7NHLzhk1qZkXJCrI80+oRAoKlz3Zx5mjqO1EaKxv0HmfEsm1f
         W6lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XB+gMw2XPIB6d2anw8a/blMCNlLvNFmxKzwQSFKnGW8=;
        b=ZGq2dZzAGcep0M2YsQ8xrrNKadm1D7sS0KrYGWEBZJD9RZmhsWDtMN0dv2zWRw74FW
         I1nIGG3hhfW7N8dJATlJyiGsSMkg1/UL6yLCt1ILeVj8fxiavQRwIKX4Fhnm25Y9JQ5n
         kHk388SddY+B/GGvOE4hwLfNHmg7YKe3HLPWvL5L0/Rvey0mHlSqFFbiOt+Me8vnBlJ5
         X9qnVa6EAS6KIjz1SexnZQJzOJQ2Bs1pMG0do/2kjhkjHsZ6LPfsLvmIsXe3lt2lEm1e
         S5NyYe9dxOgtesRGAIriuqCddI0wEk5sbkcWPnhlVPgHv+FR+hzIIS5xMQ1Uh4eFVUia
         qhEw==
X-Gm-Message-State: AOAM531iqbTkJ9n1LNJ+nvKj98o2X5MZkW3B9HnOVEPU77bzy6OEeDp5
        6Vtc9abPVB/vx6nTOVad3UiDYe1sWwuFkQiEApRIhA==
X-Google-Smtp-Source: ABdhPJxLvleFuM4gMA3rXPLn6Sqx/Rp9zy79YO7YcI7Vot40zd8QSaa0Q7++4sdQSlYSfVkfUvSOzK2kKidzlqIq4W4=
X-Received: by 2002:a25:9d82:: with SMTP id v2mr7647245ybp.383.1638836500195;
 Mon, 06 Dec 2021 16:21:40 -0800 (PST)
MIME-Version: 1.0
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <Ya6bj2nplJ57JPml@lunn.ch> <CANn89iLPSianJ7TjzrpOw+a0PTgX_rpQmiNYbgxbn2K-PNouFg@mail.gmail.com>
 <Ya6kJhUtJt5c8tEk@lunn.ch> <CANn89iL4nVf+N1R=XV5VRSm4193CcU1N8XTNZzpBV9-mS3vxig@mail.gmail.com>
 <Ya6m1kIqVo52FkLV@lunn.ch> <CANn89i+b_6R820Om9ZjK-E5DyvnNUKXxYODpmt1B6UHM1q7eoQ@mail.gmail.com>
In-Reply-To: <CANn89i+b_6R820Om9ZjK-E5DyvnNUKXxYODpmt1B6UHM1q7eoQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Dec 2021 16:21:29 -0800
Message-ID: <CANn89iJOc3i6Kps0N1ABN9qRNLJW3mpDKSzRd5v==9fugif6_g@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount tracking
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 4:17 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Dec 6, 2021 at 4:12 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> >
> > Hard to say. It looks like some sort of race condition. Sometimes when
> > i shut down the GNS3 simulation, i get the issues, sometimes not. I
> > don't have a good enough feeling to say either way, is it an existing
> > problem, or it is my code which is triggering it.
>
> OK got it.
>
> I think it might be premature to use ref_tracker yet, until we also
> have the netns one.
> (Seeing the netns change path from your report, this might be relevant)
>
> Path series adding netns tracking:
>
> 1fe7f3e6bf91 net: add networking namespace refcount tracker
> 14d34ec0eaad net: add netns refcount tracker to struct sock
> 648e1c8128a1 net: add netns refcount tracker to struct seq_net_private
> fa5ec9628f3e net: sched: add netns refcount tracker to struct tcf_exts
> fa9f11a0a627 netfilter: nfnetlink: add netns refcount tracker to
> struct nfulnl_instance
> 8e3bbdc619d0 l2tp: add netns refcount tracker to l2tp_dfs_seq_data
> 323fd18ce64c ppp: add netns refcount tracker
> d01d6c0df780 netfilter: nf_nat_masquerade: add netns refcount tracker
> to masq_dev_work
> 1b7051234a99 SUNRPC: add netns refcount tracker to struct svc_xprt
> 44721a730a24 SUNRPC: add netns refcount tracker to struct gss_auth
> 648e8fd765b7 SUNRPC: add netns refcount tracker to struct rpc_xprt
> c1d5973f3af0 net: initialize init_net earlier
> 75285dbd40cd net: add netns refcount tracker to struct nsproxy
> 0fbde1282785 vfs: add netns refcount tracker to struct fs_context
> 5a0c6bd0445f audit: add netns refcount tracker to struct audit_net
> 145f70501bfb audit: add netns refcount tracker to struct audit_reply
> b5af80d1c341 audit: add netns refcount tracker to struct audit_netlink_list

And remaining of netdev tracking patches would be

b445498bdb7a net: eql: add net device refcount tracker
2702cdbf4a6d vlan: add net device refcount tracker
1f1ef25dabe9 net: bridge: add net device refcount tracker
e418e7268655 net: watchdog: add net device refcount tracker
b08577d21d47 net: switchdev: add net device refcount tracker
57f014dc36db inet: add net device refcount tracker to struct fib_nh_common
a51ab6e951ea ax25: add net device refcount tracker
cd494c182dcb llc: add net device refcount tracker
9572141ddb29 pktgen add net device refcount tracker
d0b171bbc275 net/smc: add net device tracker to struct smc_pnetentry
c335545a38c0 netlink: add net device refcount tracker to struct ethnl_req_info
4bb89c4fef19 openvswitch: add net device refcount tracker to struct vport
86957122aab2 net: sched: act_mirred: add net device refcount tracker

I think the most important one for the leaks would be the " inet: add
net device refcount tracker to struct fib_nh_common"
