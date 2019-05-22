Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC5225BA2
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 03:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfEVB0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 21:26:22 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36544 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfEVB0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 21:26:21 -0400
Received: by mail-oi1-f196.google.com with SMTP id y124so368181oiy.3
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 18:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8PCdpg+gIsFowJO6gMKDeIqNQxZ3kcU2/Nzvi+lM0r4=;
        b=plCpToAtMhlFSfTfhsn1xD77Ct9IvqsBfDD/N8aaVdmoYnNae3NwVLJmQAiaukswiG
         SBoFf1tLsLF0I7BTuyPwkslUk02zIMqHU5/KlQ/+bvWDS2fPeQ5IJgyCHSmlDQf2nObZ
         d5eDBHSQUjmrnYviDDOFICc9LGHGqVMTZUEbciHDJHZfoCdFyqkv64KAyuqG75r0P/s4
         n+YwmcB+e7IaFPruHkHyBqUM1+F1CYvPFnfn4+IJKZLI3dB8ymWBCBKpcI6EO5Xh7gWZ
         3bUFqDFV+Wbhll5bV9+aFSl2Ljglnl8NtM9R6MWWqmI/0S5m/WIbR6SLDjQxnKVtr05o
         XASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8PCdpg+gIsFowJO6gMKDeIqNQxZ3kcU2/Nzvi+lM0r4=;
        b=bAYzquRiiutVZpSgph3c2vuqB1OwcAg6IhKB9Yfrg5R/QW8WmU2Fj1qCDjDo8fTCEs
         epTRWAhsqI68yaceYzQ+Krb7fsEVgootyGVcNOzubYHlnrE4AnTfj/UVxEIWxnZtLgbc
         y164t1e+xtzNgaRraDx6Lxyak1WQgYsiBlksik6akkcBw0v+WVsPL4xOaCLVgboLfEPd
         t7VKUtZ2VwXro5L91PIgAEu3Xdnue432hjD6KOdOFrmn/ICTUFevgLl49Dag2D6IvzmC
         sosO4yjRpY28hRg9BPvbMcr0rFXopS2HvjgU2HIGRHa545qSlYo+Jf6lXonFs1TXfu8r
         gkpg==
X-Gm-Message-State: APjAAAWatTif1C11Yl5U/GBAu3UtWgVHgVwtTIUBQ3zemfxzH6OA7epk
        HbpzTEn70HJkLA6ylIZ9zwkluqDoBEKHoVollMY=
X-Google-Smtp-Source: APXvYqyAeTVPBnF+2wf3FpIuK35HDSgP9xT5H2hThZUCwLQZEzYa5g5sBfgar+OtHplM5w1XNTMoTnNv4oZfmjq6Vdk=
X-Received: by 2002:aca:ac43:: with SMTP id v64mr5737682oie.40.1558488381108;
 Tue, 21 May 2019 18:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <1558140881-91716-1-git-send-email-xiangxia.m.yue@gmail.com>
 <CAJ3xEMhAEMBBW=s_iWA=qD23w8q4PWzWT-QowGBNtCJJzHUysA@mail.gmail.com>
 <CAMDZJNV6S5Wk5jsS5DiHMYGywU2df0Lyey9QYzcdwGZDJbjSeg@mail.gmail.com> <CAJ3xEMgc6j=+AxRUwdYOT6_cP69fY-ThVVbF+4EqtZGQ+-Sjnw@mail.gmail.com>
In-Reply-To: <CAJ3xEMgc6j=+AxRUwdYOT6_cP69fY-ThVVbF+4EqtZGQ+-Sjnw@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 22 May 2019 09:25:45 +0800
Message-ID: <CAMDZJNU=8BHZJs95knTzuCv=7X3BXbqHrZAznOOcK2m_7QO2Pw@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Allow removing representors netdev to other namespace
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 12:45 AM Or Gerlitz <gerlitz.or@gmail.com> wrote:
>
> On Tue, May 21, 2019 at 7:36 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > On Tue, May 21, 2019 at 4:24 AM Or Gerlitz <gerlitz.or@gmail.com> wrote:
> > >
> > > On Mon, May 20, 2019 at 3:19 PM <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > At most case, we use the ConnectX-5 NIC on compute node for VMs,
> > > > but we will offload forwarding rules to NICs on gateway node.
> > > > On the gateway node, we will install multiple NICs and set them to
> > > > different dockers which contain different net namespace, different
> > > > routing table. In this way, we can specify the agent process on one
> > > > docker. More dockers mean more high throughput.
> > >
> > > The vport (uplink and VF) representor netdev stands for the e-switch
> > > side of things. If you put different
> > > vport devices to different namespaces, you will not be able to forward
> > > between them. It's the NIC side of things
> > > (VF netdevice) which can/should be put to namespaces.
> > >
> > > For example, with SW veth devices, suppose I we have two pairs
> > > (v0,v1), (v2, v3) -- we create
> > > a SW switch (linux bridge, ovs) with the uplink and v0/v2 as ports all
> > > in a single name space
> > > and we map v1 and v3 into application containers.
> > >
> > > I am missing how can you make any use with vport reps belonging to the
> > > same HW e-switch
> > > on different name-spaces, maybe send chart?
> >    +---------------------------------------------------------+
> >    |                                                         |
> >    |                                                         |
> >    |       docker01                 docker02                 |
> >    |                                                         |
> >    | +-----------------+      +------------------+           |
> >    | |    NIC (rep/vf) |      |       NIC        |           |
> >    | |                 |      |                  |   host    |
> >    | |   +--------+    |      |   +---------+    |           |
> >    | +-----------------+      +------------------+           |
> >    |     |        |               |         |                |
> >    +---------------------------------------------------------+
> >          |        |               |         |
> >          |        |         phy_port2       | phy_port3
> >          |        |               |         |
> >          |        |               |         |
> > phy_port0|        |phy_port1      |         |
> >          |        |               |         |
> >          v        +               v         +
> >
> > For example, there are two NIC(4 phy ports) on the host, we set the
> > one NIC to docker01(all rep and vf of this nic are set to docker01).
> > and other one NIC are set to docker02. The docker01/docker02 run our
> > agent which use the tc command to offload the rule. The NIC of
> > docker01 will receive packets from phy_port1
> > and do the QoS , NAT(pedit action) and then forward them to phy_port0.
> > The NIC of docker02 do this in the same way.
>
> I see, so in the case you described about, you are going to move **all** the
> representors of a certain e-switch into **one** name-space -- this is something
> we don't have to block. However, I think we did wanted to disallow moving
> sub-set of the port reps into a name-space. Should look into that.
I review the reps of netronome nfp codes,  nfp does't set the
NETIF_F_NETNS_LOCAL to netdev->features.
And I changed the OFED codes which used for our product environment,
and then send this patch to upstream.
> Or.
