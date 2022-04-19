Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175115075BC
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 19:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356608AbiDSRDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 13:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355547AbiDSRCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 13:02:24 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FE53EF2F
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 09:50:51 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p65so32100504ybp.9
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 09:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fdnLyHFr6tX25lDCYj/ocTCK7A8XBtiyKi3YdmSqiLo=;
        b=POQBZJ7k69ekGjNVV4WGFz428UQA2xyVZhm8ZN74+Ks3OFQIFTxoYWDtT/mBNcVHgr
         yAG7+kjuEExeo3WQDAOOwouhbPRDoxo926WEyQerc9gIX/vDAvulLy6do+2B5mbSBg68
         gIc2Bx59iKZhKEKG9WjMB89EEWsz4iRmRbi3wbGFUZCQ1BDJuBDWopMN8/nEgMqj9www
         zDAHV4GkTyvdbNqsH8kk9hiTokZVF61ykhspJ8XkOvsQZ2nkVCDD0ZunBhmuDGa4r51m
         PLX35FC7MLpY7+dzeTbG+1+ZSn/RvXt9FJYI3rs22GRvFQDF3b2d6eSXucgEn7+OYy/H
         g3Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fdnLyHFr6tX25lDCYj/ocTCK7A8XBtiyKi3YdmSqiLo=;
        b=QFCdBnYvqF3KvVOJGCF+zbJK82KUXvhtyEfd9RYX6blnH0AbNPAcJaLRDq7Hzwsdak
         58DIJ0BPByWIBdxFKsqqbVm+PB4l5gWPDaw2PxHN96qjxNoCBx5ewgsooYJN5XepVOcC
         Jtzb31n+QyBShU99hDc/PHzZ4+ZR37NjgOsZ1Xy9Y/G0ny2EgdEL502X58KxBtrQdQku
         th2jWNyngN7qMY0u5Eq+ixd1SbOWgB4rDGbo8LI63D4TwYrfhzGfGJ4XYejcyn7PZXmB
         VKpEDFpHM+yB7h2sEDlGcKPB6tEDHBshRSsdlpD3HKzxv4dcGKNcZnOmkUHm7fY8rDJf
         4CyA==
X-Gm-Message-State: AOAM530T+ebY/i4ZZL+BFvBzwxXzw0hHu3FSImVd1egm0ZGkG9Jul0AG
        +iUxEx75+C5G5x2P1miuyhk+cj0ooJeab5rHxzU=
X-Google-Smtp-Source: ABdhPJzmtjSmel7a70sdRjThE4jWjTL6VvB03q5kfmLO4PsBwAwO06WgS5Ea5GRy8OjJiP81Jpx32vAcNX/u/pX/DPo=
X-Received: by 2002:a25:8d90:0:b0:634:7136:4570 with SMTP id
 o16-20020a258d90000000b0063471364570mr15877675ybl.582.1650387049568; Tue, 19
 Apr 2022 09:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210809070455.21051-1-liuhangbin@gmail.com> <162850320655.31628.17692584840907169170.git-patchwork-notify@kernel.org>
In-Reply-To: <162850320655.31628.17692584840907169170.git-patchwork-notify@kernel.org>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 19 Apr 2022 19:50:38 +0300
Message-ID: <CAHsH6GuZciVLrn7J-DR4S+QU7Xrv422t1kfMyA7r=jADssNw+A@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: act_mirred: Reset ct info when
 mirror/redirect skb
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        mleitner@redhat.com, ahleihel@redhat.com, dcaratti@redhat.com,
        aconole@redhat.com, roid@nvidia.com,
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

On Mon, Aug 9, 2021 at 1:29 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to netdev/net.git (refs/heads/master):
>
> On Mon,  9 Aug 2021 15:04:55 +0800 you wrote:
> > When mirror/redirect a skb to a different port, the ct info should be reset
> > for reclassification. Or the pkts will match unexpected rules. For example,
> > with following topology and commands:
> >
> >     -----------
> >               |
> >        veth0 -+-------
> >               |
> >        veth1 -+-------
> >               |
> >
> > [...]
>
> Here is the summary with links:
>   - [net] net: sched: act_mirred: Reset ct info when mirror/redirect skb
>     https://git.kernel.org/netdev/net/c/d09c548dbf3b

Unfortunately this commit breaks DNAT when performed before going via mirred
egress->ingress.

The reason is that connection tracking is lost and therefore a new state
is created on ingress.

This breaks existing setups.

See below a simplified script reproducing this issue.

Therefore I suggest this commit be reverted and a knob is introduced to mirred
for clearing ct as needed.

Eyal.

Reproduction script:

#!/bin/bash

ip netns add a
ip netns add b

ip netns exec a sysctl -w net.ipv4.conf.all.forwarding=1
ip netns exec a sysctl -w net.ipv4.conf.all.accept_local=1

ip link add veth0 netns a type veth peer name veth0 netns b
ip -net a link set veth0 up
ip -net a addr add dev veth0 198.51.100.1/30

ip -net a link add dum0 type dummy
ip -net a link set dev dum0 up
ip -net a addr add dev dum0 198.51.100.2/32

ip netns exec a iptables -t nat -I OUTPUT -d 10.0.0.1 -j DNAT
--to-destination 10.0.0.2
ip -net a route add default dev dum0
ip -net a rule add pref 50 iif dum0 lookup 1000
ip -net a route add table 1000 default dev veth0

ip netns exec a tc qdisc add dev dum0 clsact
ip netns exec a tc filter add dev dum0 parent ffff:fff3 prio 50 basic
action mirred ingress redirect dev dum0

ip -net b link set veth0 up
ip  -net b addr add 10.0.0.2/32 dev veth0
ip  -net b addr add 198.51.100.3/30 dev veth0

ip netns exec a ping 10.0.0.1
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>
>
