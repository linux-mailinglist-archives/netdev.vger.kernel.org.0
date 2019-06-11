Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17A293C0B2
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 02:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390670AbfFKAwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 20:52:21 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33853 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390451AbfFKAwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 20:52:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so6288563pfc.1
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 17:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hhZ/KByUfrR3c40vnSKDoaexOoWUfOnCl7X+zK7kbKk=;
        b=AWHlsWE4yd/kKd4Cn+nMnOiRvv21OBsPmSrxhm2AqAT5BfY0fuGuSgDcg5Mry+9Mn3
         A3VUtLGgN+9+g1SYLbq1TP9gzRWPtfRtJX9uVad4Q368L9ar25tIJ3foObaREL9VxVPm
         /07G4itUzdHWAPTGSI+hgTV7bGzEtu+1BMsjQoVbW+wLfvp1RKn/IQS2r7TPPASwH9VO
         e6d/T2aSKgA4LCHH6XnFK+Df2MK4uGiBkNLw3Jlora5Fj+jfIMjRvKzdZhdMni86gkXs
         ThYe4XtV4HIl7XgQ8rtc9GjvNxyT46mDFVd9pQlCy/gelllRz7Dal6IdJG4ryZsAKa6c
         +owA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hhZ/KByUfrR3c40vnSKDoaexOoWUfOnCl7X+zK7kbKk=;
        b=fP8hwtB/zHmHEgFcFKHEq4FOejdonjOfgpYe63W+0JT1MT0CVF8uRkau4BsTwbmxpy
         3VoDWZTn0fGmfQLnRPRxeS+YItF1sAt2RfRLv5LPZiOw9jZwNGh6lgA+h0c5jRNQi7pj
         FEeQ+8LqhN1SCCqMdFLmN/1KMnBn42f//2fAiucDlKt/WaMxv8CNtYKfLzNVYje+3IN9
         PWeU0aW6k6N3sEoNdFL6NwO94+q2DAtjEUIs9xhdNpHcA3tJPMlQkIpkwAIXRHZLzy9g
         QR6c9fXHdiv+QxhbyAvwPWdVyWJpimqosSV6gcKbpGZs/SOGTT1IOEpA78fw1ZEktxwv
         v4rQ==
X-Gm-Message-State: APjAAAWYP7/h8y8ZkkhAbYT2FA36alp7oX2vzPWeJjJIj/Xcj4XtkYoX
        j5yz3t3xuwsxtPpIyaL8iI0Mra5u+K0Bw9r8fwo=
X-Google-Smtp-Source: APXvYqw/K9RmJuf7qaxHGgflhF+n2IO6su38HKBu/VAc4agSWIQL1rQ77ly5p02hFq0+jn3vDlBadXwevckQligUD8g=
X-Received: by 2002:a62:2e47:: with SMTP id u68mr77742229pfu.24.1560214339972;
 Mon, 10 Jun 2019 17:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559322531.git.dcaratti@redhat.com> <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
 <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
 <CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com>
 <82ec3877-8026-67f7-90d8-6e9988513fef@mellanox.com> <CAM_iQpXsGc2EpGkLq_3tcgiD+Mshe1GvGuURwcmeBEqpmQaiTw@mail.gmail.com>
 <d480caba-16e2-da3e-be33-ff4aeb5c6420@mellanox.com> <CAM_iQpXqQ_smFtY4E6Jefki=htih_jW+jNzB1XNuzY1BzWqveQ@mail.gmail.com>
 <464000e5-3cb0-c837-4edb-9dfcbfeffcec@mellanox.com>
In-Reply-To: <464000e5-3cb0-c837-4edb-9dfcbfeffcec@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 10 Jun 2019 17:52:08 -0700
Message-ID: <CAM_iQpX=KqnYP6O139WxH-ouF=vM2=42HS4WLK9PK0E76J-GGw@mail.gmail.com>
Subject: Re: [PATCH net v3 0/3] net/sched: fix actions reading the network
 header in case of QinQ packets
To:     Eli Britstein <elibr@mellanox.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 5, 2019 at 10:37 PM Eli Britstein <elibr@mellanox.com> wrote:
>
>
> On 6/6/2019 4:42 AM, Cong Wang wrote:
> > On Tue, Jun 4, 2019 at 11:19 AM Eli Britstein <elibr@mellanox.com> wrote:
> >>
> >> On 6/4/2019 8:55 PM, Cong Wang wrote:
> >>> On Sat, Jun 1, 2019 at 9:22 PM Eli Britstein <elibr@mellanox.com> wrote:
> >>>> I think that's because QinQ, or VLAN is not an encapsulation. There is
> >>>> no outer/inner packets, and if you want to mangle fields in the packet
> >>>> you can do it and the result is well-defined.
> >>> Sort of, perhaps VLAN tags are too short to be called as an
> >>> encapsulation, my point is that it still needs some endpoints to push
> >>> or pop the tags, in a similar way we do encap/decap.
> >>>
> >>>
> >>>> BTW, the motivation for my fix was a use case were 2 VGT VMs
> >>>> communicating by OVS failed. Since OVS sees the same VLAN tag, it
> >>>> doesn't add explicit VLAN pop/push actions (i.e pop, mangle, push). If
> >>>> you force explicit pop/mangle/push you will break such applications.
> >>>   From what you said, it seems act_csum is in the middle of packet
> >>> receive/transmit path. So, which is the one pops the VLAN tags in
> >>> this scenario? If the VM's are the endpoints, why not use act_csum
> >>> there?
> >> In a switchdev mode, we can passthru the VFs to VMs, and have their
> >> representors in the host, enabling us to manipulate the HW eswitch
> >> without knowledge of the VMs.
> >>
> >> To simplify it, consider the following setup:
> >>
> >> v1a <-> v1b and v2a <-> v2b are veth pairs.
> >>
> >> Now, we configure v1a.20 and v2a.20 as VLAN devices over v1a/v2a
> >> respectively (and put the "a" devs in separate namespaces).
> >>
> >> The TC rules are on the "b" devs, for example:
> >>
> >> tc filter add dev v1b ... action pedit ... action csum ... action
> >> redirect dev v2b
> >>
> >> Now, ping from v1a.20 to v1b.20. The namespaces transmit/receive tagged
> >> packets, and are not aware of the packet manipulation (and the required
> >> act_csum).
> > This is what I said, v1b is not the endpoint which pops the vlan tag,
> > v1b.20 is. So, why not simply move at least the csum action to
> > v1b.20? With that, you can still filter and redirect packets on v1b,
> > you still even modify it too, just defer the checksum fixup to the
> > endpoint.
>
> There are no vxb.20 ports:
>
> ns0:     v1a.20 ----(VLAN)---- v1a ns1:    v2a ---- (VLAN) ---- v2a.20
>
> |----(veth)---- v1b     <---- (TC) ---->    v2b ----(veth)----|


This diagram makes me even more confusing...

Can you explicitly explain why there is no vxb.20? Is it a router or
something?

By the way, even if it is router and you really want to checksum the
packet at that point, you still don't have to move the skb->data
pointer, you just need to parse the header and calculate the offset
without touching skb->data. This could at least avoid restoring
skb->data after it.

Thanks.
