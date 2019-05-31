Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449823173A
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfEaW37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:29:59 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43313 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfEaW37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 18:29:59 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn7so4526358plb.10
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 15:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aiQ5pjGX/M8+Woq5+sdXOH6S/bc4Oj85waYRZ1HqPvs=;
        b=UStqJAa5ItRaaOybsmJvUO9LGEZP+MxsJpNEE7IoSmOAz/dqkdxAK2B89Rl1ijAKcW
         57ywYzDzc1CORYtlvFGtGeyoC4vWnVpH8c/DKHY/BOy7UBfDey9SibQchZU/T/vXR12/
         btUIxdO/dHyBKPJj9u+pEPhef1bzm84mI1g1eatGfuPgH8kJxtHpt3CFykSNBQa692hp
         C/aq6St1BHQ5o4kaewEMRQIsMl1tRV6vYd86iJ0VRlJc6LG4czk2hqCHeQLLjy95eeYj
         EEUInBguxFiywqCFkiH5hUQJmk+MT+pfV+Hmm0xVc4aR6DsiHvZaLCP6yetjSVXYofDH
         zVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aiQ5pjGX/M8+Woq5+sdXOH6S/bc4Oj85waYRZ1HqPvs=;
        b=fl3o+kdI9QHYtYFSTQlAmx0qkwL8YWX0+jsf0ivBKyj2j2VlmC0khqTQ8qSKKupADG
         iAmruW/g4Hou8++Ha6ZGqNW+CY4eiI5LDiV7nRC5pVEM1JzN+q/estPJe3S+WcS2fD5B
         0uuupG/L8m9uP4owC9DkARIQGn6Z6eJ15cAi0YYaz5hUVCA09QhXBYa7q/PBFdXago8U
         MdXDfdVu0XPn7mJlrWIoirLThuWEIWgeWXU+G4z00U3bJDFSXARYX9CuG1R7E28iXyLw
         sznrXibvdiYCUvUIynPX0PS98NS7jwKgTbxmnF86S/ASSMYx9xV/saVLQMnb5c3fYw4T
         G82g==
X-Gm-Message-State: APjAAAUigsRpQv8qA1ROXkb4j0n4fQ+b5RCAy+4FWrDfcOmpTgmIFpKR
        tvB8DgxVD/lR7QV/xGPq/RA1Xy0snn3muzV9oT4=
X-Google-Smtp-Source: APXvYqxp874nSTX60iMK0uO/W21RKrVd/egjQBNpV+LL4dDLE09MUvfqhQ/8SMZOQJ0fnWzVSjwcg3chgZyAfD+Hubo=
X-Received: by 2002:a17:902:5c2:: with SMTP id f60mr12343477plf.61.1559341798302;
 Fri, 31 May 2019 15:29:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559322531.git.dcaratti@redhat.com> <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
 <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
In-Reply-To: <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 31 May 2019 15:29:46 -0700
Message-ID: <CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com>
Subject: Re: [PATCH net v3 0/3] net/sched: fix actions reading the network
 header in case of QinQ packets
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Eli Britstein <elibr@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 3:01 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> On Fri, 2019-05-31 at 11:42 -0700, Cong Wang wrote:
> > On Fri, May 31, 2019 at 10:26 AM Davide Caratti <dcaratti@redhat.com> wrote:
> > > 'act_csum' was recently fixed to mangle the IPv4/IPv6 header if a packet
> > > having one or more VLAN headers was processed: patch #1 ensures that all
> > > VLAN headers are in the linear area of the skb.
> > > Other actions might read or mangle the IPv4/IPv6 header: patch #2 and #3
> > > fix 'act_pedit' and 'act_skbedit' respectively.
> >
> > Maybe, just maybe, vlan tags are supposed to be handled by act_vlan?
> > Which means maybe users have to pipe act_vlan to these actions.
>
> but it's not possible with the current act_vlan code.
> Each 'vlan' action pushes or pops a single tag, so:
>
> 1) we don't know how many vlan tags there are in each packet, so I should
> put an (enough) high number of "pop" operations to ensure that a 'pedit'
> rule correctly mangles the TTL in a IPv4 packet having 1 or more 802.1Q
> tags in the L2 header.

Not true, we do know whether the last vlan tag is pop'ed by checking
the protocol. There was already a use case in netdev before:

tc filter add dev veth1 egress prio 100  protocol 802.1Q  matchall
action vlan pop continue #reclassify
tc filter add dev veth1 egress prio 200  protocol ip      u32 match ip
src 192.168.1.0/24  action drop
tc filter add dev veth1 egress prio 201  protocol ip      u32 match ip
dst 192.168.100.0/24  action drop

which is from a bug report.

>
> 2) after a vlan is popped with act_vlan, the kernel forgets about the VLAN
> ID and the VLAN type. So, if I want to just mangle the TTL in a QinQ
> packet, I need to reinject it in a place where both tags (including VLAN
> type *and* VLAN id) are restored in the packet.

It is forgotten by act_vlan only, the vlan info is still inside the
packet header.
Perhaps we just need some action to push it back.

>
> Clearly, act_vlan can't be used as is, because 'push' has hardcoded VLAN
> ID and ethertype. Unless we change act_vlan code to enable rollback of
> previous 'pop' operations, it's quite hard to pipe the correct sequence of
> vlan 'pop' and 'push'.

What about other encapsulations like VXLAN? What if I just want to
mangle the inner TTL of a VXLAN packet? You know the answer is setting
up TC filters and actions on VXLAN device instead of ethernet device.

IOW, why QinQ is so special that we have to take care of inside TC action
not the encapsulation endpoint?


>
> > From the code reuse perspective, you are adding TCA_VLAN_ACT_POP
> > to each of them.
>
> No, these patches don't pop VLAN tags. All tags are restored after the
> action completed his work, before returning a->tcfa_action.
>
> May I ask you to read it as a followup of commit 2ecba2d1e45b ("net:
> sched: act_csum: Fix csum calc for tagged packets"), where the 'csum'
> action was modified to mangle the checksum of IPv4 headers even when
> multiple 802.1Q tags were present?

Yes, I already read it and I think that commit should be reverted for the
same reason as I already stated above.


> With this series it becomes possible to mangle also the TTL field (with
> pedit), and assign the diffserv bits to skb->priority (with skbedit).

Sorry, I am not yet convinced why we should do it in TC.

Thanks.
