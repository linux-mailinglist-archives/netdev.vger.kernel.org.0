Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AAC440E00
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 13:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhJaMGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 08:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhJaMGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 08:06:03 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A96C061570
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 05:03:32 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id d63so18346633iof.4
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 05:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=diYwLX3tdtqO6QKGZeRlZpS4MeqyAkZlFjsGIXKnXN0=;
        b=dIbPGJFRT6RPseIw1wW5Bzek5ysYp1awoM2ECVkezanjsILVK9/qbXnLBpBrCHS2vN
         RLPU5Oo4LO+05EJolUHqS7gFz+X0mTlOwRsqtEhMfyhS0wOn7xr5C9F3mhWsZqO9PE8F
         BZWXlv6dwN+5c/fJOzXChtWOPc4iQaE4mFjerN1AcpVh2pc7z8mGrpa8n75iKYRppA2S
         LIDyOX+bbuL3jMrT8BwrsJ79xDIcjBfhzjEQjBtXlxKq7IQC6SQ3/UNkO4aJ35LWFzc0
         BH7ipDjyZ5Wak+AP/LHmS4io4BsS/E39PnIGO9XT+i1su5FU7T4w+vaCDpxf/Sy18Hct
         NLng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=diYwLX3tdtqO6QKGZeRlZpS4MeqyAkZlFjsGIXKnXN0=;
        b=UGzuKxZtOFJaIp2k5Ul5ljgzXodsQ/i0U956b/xzf53SOkYCQMjWrob3kHTfNngLnm
         Hlx1CMCPLLS73rdpzLG4tNmgwzHwK1CSvsE7WaOy4b3cUwgSbZAhlmS8z/BNtk0YC6HM
         zZ8EmhKTrwKC0zK26Om9LjnYeFw/ZYVeXu5j18SQtXhKQNkdawMK2C3pmoirNthlAEan
         8Na4RHCioxyrrLYbwXuNv4zzJqFdyAy/Kzfj1KQHrDspPAuQF2sIAVwGuq8JDUqLycA5
         URG0jymzc9n1FrdVRRFsUo+0bMRxMr43+Q+VElobs0tqa9ZubToJ3/plHviFyh8XJ4EQ
         f4XA==
X-Gm-Message-State: AOAM532S52K6W5esShEEETfGRV4YnmxbGchWhsZvq/Qy2cYGYI7ToA9R
        Pj1m/OBo/eSc8Qx+PP/qwI7p/HeREY7e8wBwlv4=
X-Google-Smtp-Source: ABdhPJza/dwSM0/lCBPJCYETSDF9+RsHzXlzxXEv5SnjtB65VK6y9aN6+4KKKWwMLWQxsSVqt34bC43ak5U1fEjw6ms=
X-Received: by 2002:a05:6602:2e05:: with SMTP id o5mr16212975iow.204.1635681811761;
 Sun, 31 Oct 2021 05:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <20211028110646.13791-1-simon.horman@corigine.com> <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
In-Reply-To: <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sun, 31 Oct 2021 05:03:19 -0700
Message-ID: <CAA93jw4VphJ17yoV1S6aDRg2=W7hg=02Yr3XcX_aEBTzAt0ezw@mail.gmail.com>
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 2:51 AM Oz Shlomo <ozsh@nvidia.com> wrote:
>
>
>
> On 10/28/2021 2:06 PM, Simon Horman wrote:
> > Baowen Zheng says:
> >
> > Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offl=
oad
> > tc actions independent of flows.
> >
> > The motivation for this work is to prepare for using TC police action
> > instances to provide hardware offload of OVS metering feature - which c=
alls
> > for policers that may be used by multiple flows and whose lifecycle is
> > independent of any flows that use them.
> >
> > This patch includes basic changes to offload drivers to return EOPNOTSU=
PP
> > if this feature is used - it is not yet supported by any driver.
> >
> > Tc cli command to offload and quote an action:
> >
> > tc qdisc del dev $DEV ingress && sleep 1 || true
> > tc actions delete action police index 99 || true
> >
> > tc qdisc add dev $DEV ingress
> > tc qdisc show dev $DEV ingress
> >
> > tc actions add action police index 99 rate 1mbit burst 100k skip_sw
> > tc actions list action police
> >
> > tc filter add dev $DEV protocol ip parent ffff:
> > flower ip_proto tcp action police index 99
> > tc -s -d filter show dev $DEV protocol ip parent ffff:
> > tc filter add dev $DEV protocol ipv6 parent ffff:
> > flower skip_sw ip_proto tcp action police index 99
> > tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
> > tc actions list action police
> >
> > tc qdisc del dev $DEV ingress && sleep 1
> > tc actions delete action police index 99
> > tc actions list action police
> >
>
> Actions are also (implicitly) instantiated when filters are created.
> In the following example the mirred action instance (created by the first=
 filter) is shared by the
> second filter:
>
> tc filter add dev $DEV1 proto ip parent ffff: flower \
>         ip_proto tcp action mirred egress redirect dev $DEV3
>
> tc filter add dev $DEV2 proto ip parent ffff: flower \
>         ip_proto tcp action mirred index 1
>
>
> > Changes compared to v2 patches:
> >
> > * Made changes according to the review comments.
> > * Delete in_hw and not_in_hw flag and user can judge if the action is
> >    offloaded to any hardware by in_hw_count.
> > * Split the main patch of the action offload to three single patch to
> > facilitate code review.
> >
> > Posting this revision of the patchset as an RFC as while we feel it is
> > ready for review we would like an opportunity to conduct further testin=
g
> > before acceptance into upstream.
> >
> > Baowen Zheng (8):
> >    flow_offload: fill flags to action structure
> >    flow_offload: reject to offload tc actions in offload drivers
> >    flow_offload: allow user to offload tc action to net device
> >    flow_offload: add skip_hw and skip_sw to control if offload the acti=
on
> >    flow_offload: add process to update action stats from hardware
> >    net: sched: save full flags for tc action
> >    flow_offload: add reoffload process to update hw_count
> >    flow_offload: validate flags of filter and actions
> >
> >   drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
> >   .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
> >   .../ethernet/netronome/nfp/flower/offload.c   |   3 +
> >   include/linux/netdevice.h                     |   1 +
> >   include/net/act_api.h                         |  34 +-
> >   include/net/flow_offload.h                    |  17 +
> >   include/net/pkt_cls.h                         |  61 ++-
> >   include/uapi/linux/pkt_cls.h                  |   9 +-
> >   net/core/flow_offload.c                       |  48 +-
> >   net/sched/act_api.c                           | 440 +++++++++++++++++=
-
> >   net/sched/act_bpf.c                           |   2 +-
> >   net/sched/act_connmark.c                      |   2 +-
> >   net/sched/act_ctinfo.c                        |   2 +-
> >   net/sched/act_gate.c                          |   2 +-
> >   net/sched/act_ife.c                           |   2 +-
> >   net/sched/act_ipt.c                           |   2 +-
> >   net/sched/act_mpls.c                          |   2 +-
> >   net/sched/act_nat.c                           |   2 +-
> >   net/sched/act_pedit.c                         |   2 +-
> >   net/sched/act_police.c                        |   2 +-
> >   net/sched/act_sample.c                        |   2 +-
> >   net/sched/act_simple.c                        |   2 +-
> >   net/sched/act_skbedit.c                       |   2 +-
> >   net/sched/act_skbmod.c                        |   2 +-
> >   net/sched/cls_api.c                           |  55 ++-
> >   net/sched/cls_flower.c                        |   3 +-
> >   net/sched/cls_matchall.c                      |   4 +-
> >   net/sched/cls_u32.c                           |   7 +-
> >   28 files changed, 661 insertions(+), 54 deletions(-)
> >

Just as an on-going grump: It has been my hope that policing as a
technique would have died a horrible death by now. Seeing it come back
as an "easy to offload" operation here - fresh from the 1990s! does
not mean it's a good idea, and I'd rather like it if we were finding
ways to
offload newer things that work better, such as modern aqm, fair
queuing, and shaping technologies that are in pie, fq_codel, and cake.

policing leads to bursty loss, especially at higher rates, BBR has a
specific mode designed to defeat it, and I ripped it out of
wondershaper
long ago for very good reasons:
https://www.bufferbloat.net/projects/bloat/wiki/Wondershaper_Must_Die/

I did a long time ago start working on a better policing idea based on
some good aqm ideas like AFD, but dropped it figuring that policing
was going to vanish
from the planet. It's baaaaaack.

--=20
I tried to build a better future, a few times:
https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org

Dave T=C3=A4ht CEO, TekLibre, LLC
