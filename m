Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E8C5077D9
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357049AbiDSSZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356979AbiDSSWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:22:33 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E6A2DC7
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 11:14:50 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id x200so32471048ybe.13
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 11:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b2WuvKPZQOyv6SOaDJj4KyJ7C8mCfys7lbOjp0Zr5j4=;
        b=R7AJ2UGSyXuUwxRrg7WbvFWlJEoyevFAPrUb8FOgtfo4nofqpsv9xFh2Et3Q1X9rGE
         89kU/Hevu14Zne1NLIDRPKNcpY0YzWf9yjrlcDKnIEC8ih0yDhaF6ZiGbFmGb8iphE2m
         1Lpv3QqymXtlsfY9sG8d+wekY1EK4xIHRL7Qi8M2qNrs9s26s8v5SOCUTPyzyeNpjfCY
         Z1V5kB7SLOlPptgF1xeEJxolnYxIz6nxF/sr7GNlG78+hO+/5GZKg4IRNMGe4mEkcLu5
         eY16BlBMf2erfYcFkB9c/FUEQxRS/c39cZwinaL3jQJggTBcvy2SGrXfBtf77/mQtQcO
         LG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b2WuvKPZQOyv6SOaDJj4KyJ7C8mCfys7lbOjp0Zr5j4=;
        b=Dj+b3I7GN6ngeTgS+FC3wYoE726TcQ7foE6EqaHnOVqJ6pS03qJKIfmEAS3gytRGX9
         47jrrbpQP5XvRVSvR35+acD/poiwNiifu2jyLnvZMYb/sq9s2+Sfsh1NcQ9YND8DLfPD
         5/7JXf+ak3alEpVf2gS+4i/jGTbjAvyMKIy5BwJaJJn/2F8dWbVpBQ01bzQva3mp9Kg2
         82JIokfYvccpmpQMn1MGMl3t7GmQx23TO5CmrC5+1OwTt0GgVlJBa6gN20gj4iICD3mk
         kLvYz2IMMHJg2gqlRkPWlg+FePdyY1L4K8GUlSpruMQiSAFjDINu3c20UvG2z9wfvCcf
         5sLQ==
X-Gm-Message-State: AOAM533y4FOVpUyzaOLwttadpm3tPnhs8HLbVwpIjhIeuAjhOjJ2Ji2M
        S2Fpb7xCrcTMnpHjvCT5uyS30G+/gz+iDSNnB4E=
X-Google-Smtp-Source: ABdhPJwURKnT15yDtkLFv3CrQ2W6GmUtBcW+vQRn0vdU25jShujZg0aaCkrgYIyVnAwbcMRab7kyGKwZY372IFF++FE=
X-Received: by 2002:a25:8d90:0:b0:634:7136:4570 with SMTP id
 o16-20020a258d90000000b0063471364570mr16298630ybl.582.1650392089622; Tue, 19
 Apr 2022 11:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210809070455.21051-1-liuhangbin@gmail.com> <162850320655.31628.17692584840907169170.git-patchwork-notify@kernel.org>
 <CAHsH6GuZciVLrn7J-DR4S+QU7Xrv422t1kfMyA7r=jADssNw+A@mail.gmail.com> <CALnP8ZackbaUGJ_31LXyZpk3_AVi2Z-cDhexH8WKYZjjKTLGfw@mail.gmail.com>
In-Reply-To: <CALnP8ZackbaUGJ_31LXyZpk3_AVi2Z-cDhexH8WKYZjjKTLGfw@mail.gmail.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 19 Apr 2022 21:14:38 +0300
Message-ID: <CAHsH6GvoDr5qOKsvvuShfHFi4CsCfaC-pUbxTE6OfYWhgTf9bg@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: act_mirred: Reset ct info when
 mirror/redirect skb
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, ahleihel@redhat.com,
        dcaratti@redhat.com, aconole@redhat.com, roid@nvidia.com,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Apr 19, 2022 at 8:26 PM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
>
> Hi,
>
> On Tue, Apr 19, 2022 at 07:50:38PM +0300, Eyal Birger wrote:
> > Hi,
> >
> > On Mon, Aug 9, 2021 at 1:29 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
> > >
> > > Hello:
> > >
> > > This patch was applied to netdev/net.git (refs/heads/master):
> > >
> > > On Mon,  9 Aug 2021 15:04:55 +0800 you wrote:
> > > > When mirror/redirect a skb to a different port, the ct info should be reset
> > > > for reclassification. Or the pkts will match unexpected rules. For example,
> > > > with following topology and commands:
> > > >
> > > >     -----------
> > > >               |
> > > >        veth0 -+-------
> > > >               |
> > > >        veth1 -+-------
> > > >               |
> > > >
> > > > [...]
> > >
> > > Here is the summary with links:
> > >   - [net] net: sched: act_mirred: Reset ct info when mirror/redirect skb
> > >     https://git.kernel.org/netdev/net/c/d09c548dbf3b
> >
> > Unfortunately this commit breaks DNAT when performed before going via mirred
> > egress->ingress.
> >
> > The reason is that connection tracking is lost and therefore a new state
> > is created on ingress.
> >
> > This breaks existing setups.
> >
> > See below a simplified script reproducing this issue.
>
> I guess I can understand why the reproducer triggers it, but I fail to
> see the actual use case you have behind it. Can you please elaborate
> on it?

One use case we use mirred egress->ingress redirect for is when we want to
reroute a packet after applying some change to the packet which would affect
its routing. for example consider a bpf program running on tc ingress (after
mirred) setting the skb->mark based on some criteria.

So you have something like:

packet routed to dummy device based on some criteria ->
  mirred redirect to ingress ->
    classification by ebpf logic at tc ingress ->
       packet routed again

We have a setup where DNAT is performed before this flow in that case the
ebpf logic needs to see the packet after the NAT.

Eyal.

>
> >
> > Therefore I suggest this commit be reverted and a knob is introduced to mirred
> > for clearing ct as needed.
> >
> > Eyal.
> >
> > Reproduction script:
> >
> > #!/bin/bash
> >
> > ip netns add a
> > ip netns add b
> >
> > ip netns exec a sysctl -w net.ipv4.conf.all.forwarding=1
> > ip netns exec a sysctl -w net.ipv4.conf.all.accept_local=1
> >
> > ip link add veth0 netns a type veth peer name veth0 netns b
> > ip -net a link set veth0 up
> > ip -net a addr add dev veth0 198.51.100.1/30
> >
> > ip -net a link add dum0 type dummy
> > ip -net a link set dev dum0 up
> > ip -net a addr add dev dum0 198.51.100.2/32
> >
> > ip netns exec a iptables -t nat -I OUTPUT -d 10.0.0.1 -j DNAT
> > --to-destination 10.0.0.2
> > ip -net a route add default dev dum0
> > ip -net a rule add pref 50 iif dum0 lookup 1000
> > ip -net a route add table 1000 default dev veth0
> >
> > ip netns exec a tc qdisc add dev dum0 clsact
> > ip netns exec a tc filter add dev dum0 parent ffff:fff3 prio 50 basic
> > action mirred ingress redirect dev dum0
> >
> > ip -net b link set veth0 up
> > ip  -net b addr add 10.0.0.2/32 dev veth0
> > ip  -net b addr add 198.51.100.3/30 dev veth0
> >
> > ip netns exec a ping 10.0.0.1
> > >
> > > You are awesome, thank you!
> > > --
> > > Deet-doot-dot, I am a bot.
> > > https://korg.docs.kernel.org/patchwork/pwbot.html
> > >
> > >
> >
>
