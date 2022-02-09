Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33D34AFF74
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbiBIVvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:51:40 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiBIVvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:51:39 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB9BDF48F03
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:51:41 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b187-20020a251bc4000000b0061e15c5024fso7492262ybb.4
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 13:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4L0MEMaNHntIH/lbqaOHXp5JEUPlYZIIuiOMk7sX484=;
        b=gfvn2927hswhQgJbKtYk6uapfF6ticibP+9W1t8S/LCzQHN7ZhbDeWRWUIu0ojkBVv
         W18aVd8AycGqvuXWeSOtf4Jv21+eUYXzWXiQ5G0Pe6iJ8wlzqvPbYhHJSrCnZhsQZQtY
         Gg/ty5hSeRWOoO/u1Z3zqfMNq74WorLzoH9wXnq29LoIBYQo4bZjBaq8TFONHVO4vsD+
         qneNx7gGgOipkK8ijCU9WDsqkx6nt9ZyDU70QuNImTOplIy6HaLEM30Yub/ffwlq4fXF
         UCPDZzSa13f2Eo3YH++ifHXPej7bQUiLxehMPo/PbAxwgJhkSx7PTZ5KlD4Nr6OZVwTY
         tYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4L0MEMaNHntIH/lbqaOHXp5JEUPlYZIIuiOMk7sX484=;
        b=ZbpAbl0zHQaSKHGKh4XHjWrbMInN8GZSQ24dDPYnRfXlcKSA+xfLRpu2dwYzRwql0/
         A3uwaKOgku+pcZE/uRSNqXE4L/9UXiEOywYFwqSBDQWG2dm7OUTeg13qRWPxiKL2uMhX
         vDZw5vXG1XwsiNnka2THfSMcurgTvTTdyLSW+fvKccDinCH6t8IiUtYLbEsJmug91gdm
         tETZq0BrJhbEu96CSYZx/ms+hy36ODr+7Rbm25QfpSqEjQdv5EDFpDCpGx4kRB76Vbmd
         eWoEQrNtYILIJCNRpAqtSlltrSJjBaZLKdlX5DJhQ4qVzbkM0flbHIAjHo4dyd5x4MX0
         IEPA==
X-Gm-Message-State: AOAM5325Q/df10ENnlcs3XrMXyj0okZ41/J6wNHu0FMu5PQpwDMWvjkv
        A94Zg5Rbp9+88IoamLry4YGKpPo=
X-Google-Smtp-Source: ABdhPJyge6KTX44exBB4X0yo6f4Vf0tnyOK8NYUkf0XDiwzZB+aXkuNbUrFN5Y0Hn4GdHv1++xafZlA=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:4d3:1afe:7eeb:c0e6])
 (user=sdf job=sendgmr) by 2002:a81:c709:: with SMTP id m9mr4356228ywi.247.1644443500503;
 Wed, 09 Feb 2022 13:51:40 -0800 (PST)
Date:   Wed, 9 Feb 2022 13:51:38 -0800
In-Reply-To: <20220209210207.dyhi6queg223tsuy@kafai-mbp.dhcp.thefacebook.com>
Message-Id: <YgQ3au11pALDjyub@google.com>
Mime-Version: 1.0
References: <YgPz8akQ4+qBz7nf@google.com> <20220209210207.dyhi6queg223tsuy@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: Override default socket policy per cgroup
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/09, Martin KaFai Lau wrote:
> On Wed, Feb 09, 2022 at 09:03:45AM -0800, sdf@google.com wrote:
> > Let's say I want to set some default sk_priority for all sockets in a
> > specific cgroup. I can do it right now using cgroup/sock_create, but it
> > applies only to AF_INET{,6} sockets. I'd like to do the same for raw
> > (AF_PACKET) sockets and cgroup/sock_create doesn't trigger for them :-(
> Other than AF_PACKET and INET[6], do you have use cases for other  
> families?

No, I only need AF_PACKET for now. But I feel like we should create
a more extensible hook point this time (if we go this route).

> > (1) My naive approach would be to add another cgroup/sock_post_create
> > which runs late from __sock_create and triggers on everything.
> >
> > (2) Another approach might be to move BPF_CGROUP_RUN_PROG_INET_SOCK and
> > make it work with AF_PACKET. This might be not 100% backwards compatible
> > but I'd assume that most users should look at the socket family before
> > doing anything. (in this case it feels like we can extend
> > sock_bind/release for af_packets as well, just for accounting purposes,
> > without any way to override the target ifindex).
> If adding a hook at __sock_create, I think having a new  
> CGROUP_POST_SOCK_CREATE
> may be better instead of messing with the current inet assumption
> in CGROUP_'INET'_SOCK_CREATE.  Running all CGROUP_*_SOCK_CREATE at
> __sock_create could be a nice cleanup such that a few lines can be
> removed from inet[6]_create but an extra family check will be needed.

SG. Hopefully I can at least reuse exiting progtype and just introduce
new hook point in __sock_create.

> The bpf prog has both bpf_sock->family and bpf_sock->protocol field to
> check with, so it should be able to decide the sk type if it is run
> at __sock_create.  All bpf_sock fields should make sense or at least 0
> to all families (?), please check.

Yeah, that's what I think as well, existing bpf_sock should work
as is (it might show empty ip/port for af_packet), but I'll do verify
that.

> For af_packet bind, the ip[46]/port probably won't be useful?  What
> the bpf prog will need?

For AF_PACKET bind we would need new ifindex and new protocol. I was  
thinking
maybe new bpf_packet_sock type+helper to convert from bpf_sock is the
way to go here.

For AF_PACKET bind we actually have another use-case where I think
generic bind hook might be helpful. I have a working prototype with  
fmod_ret,
but feels like per-cgroup hook is better (let's me access cgroup local
storage):
We'd like to have a cgroup-enforced TX-only form of raw socket (grant
CAP_NET_RAW+restrict RX path). For AF_INET{,6} it means allow only
socket(AF_INET{,6}, SOCK_RAW, IPPROTO_RAW); that's easily enforcible with
the current hooks. For AF_PACKET it means allow only
socket(AF_PACKET, SOCK_RAW, 0 == ETH_P_NONE) and prohibit bind to  
protocol !=
0.
