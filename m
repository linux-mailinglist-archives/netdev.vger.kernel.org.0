Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCF7DFA0E
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 03:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbfJVBQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 21:16:50 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36574 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVBQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 21:16:50 -0400
Received: by mail-oi1-f195.google.com with SMTP id k20so12776410oih.3
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 18:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZouudMw3ht6kahpLNjT3aAR2Ms80A6g7Oj0EFtNV+H4=;
        b=jW0iS1tZWCulAnJ8UqTojcEGRLEztJgkt/cf9R8PmXPDGehWSsIc86GFtt2m1OY8oQ
         xGw6IlnPbn4GuuWtv/9IDxSbP8x6GWF6Jwm0PN0XOE/eoMwvqCfzrpnlUMoeGRbNsXdG
         ZgN/hvmD6cDKVlzncJtlo65nxKSTlXh+Ido2745mh+6skKueszf6HzUu0sVEaHIbwkjY
         JR81HBOQ2VHGkrKWNTM+ZKNd6jCRxZ5Zx6uV3YYUaqagRw/ebBAze51+rwToN9VeXBrl
         9AQqr8aHin/4/4ignbizgtd3WthSAkm+DVuQfFx1Neok0KxnnKRARwI3Dv3lLBFobpOk
         mKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZouudMw3ht6kahpLNjT3aAR2Ms80A6g7Oj0EFtNV+H4=;
        b=HU+eh3Untbejb5V9DDj4aZ1kyordfLXNSLRRxRrOqD8nZFl0el71o+243HSOQt4zLh
         SJkvntdCaq9izlnWZSVHL+JhIQbLqkCWWGoS7nNgP10Q2czmCpT5Nz1uuL8EbgGLtAAA
         uX9L8YdcIDYwA8K124RxKg+AdS/XThR/5wREwMrsAr4IScJ9YNmDVgA7DRh+2Dr2a5Vw
         1fF/BOdP0NPqulAMGEyT6Zc7Rbqxl5LBmz0Pvr43aA3TYSgqbV3btlnEAdVDbrZbmR1Y
         GsHeZFhsSwREC+bnJYUt6xczCTv958a0CQsG4aiqnpIBcXb8MMjo651xrBxWXZ1PDzH+
         K7YA==
X-Gm-Message-State: APjAAAV6jy23XnBBv4UwzuIJjN45vrICL0LI3HAzceL2F4C6D9n3ZR0T
        qWe8QedBwTwHj0Dm7e+5Txv8OrTQPX8h+NQZKo8=
X-Google-Smtp-Source: APXvYqwKdnbv3One/YYgR579oH9o59xG7IPeAsJpjQ0TsJ1AxD0tRQExLO+1ps4JKrNybKggV4rBHAPKUYDS6Dc1Uo4=
X-Received: by 2002:a05:6808:2c3:: with SMTP id a3mr793341oid.40.1571707008969;
 Mon, 21 Oct 2019 18:16:48 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com> <CALDO+SZib59P3qmQNWGNjKnrn_+DsFnu+QoPE0gfqRLVRpDk+Q@mail.gmail.com>
In-Reply-To: <CALDO+SZib59P3qmQNWGNjKnrn_+DsFnu+QoPE0gfqRLVRpDk+Q@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 22 Oct 2019 09:16:12 +0800
Message-ID: <CAMDZJNVea1MZG2CRgi9KR1yf6r3x3RnonA0b_ZvEu9B_v5z1Lw@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 00/10] optimize openvswitch flow
 looking up
To:     William Tu <u9012063@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 1:14 AM William Tu <u9012063@gmail.com> wrote:
>
> On Wed, Oct 16, 2019 at 5:50 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This series patch optimize openvswitch for performance or simplify
> > codes.
> >
> > Patch 1, 2, 4: Port Pravin B Shelar patches to
> > linux upstream with little changes.
>
> btw, should we keep Pravin as the author of the above three patches?
Agree=EF=BC=8C but how i can to that, these patches should be sent by Pravi=
n ?
> Regards,
> William
>
> >
> > Patch 5, 6, 7: Optimize the flow looking up and
> > simplify the flow hash.
> >
> > Patch 8, 9: are bugfix.
> >
> > The performance test is on Intel Xeon E5-2630 v4.
> > The test topology is show as below:
> >
> > +-----------------------------------+
> > |   +---------------------------+   |
> > |   | eth0   ovs-switch    eth1 |   | Host0
> > |   +---------------------------+   |
> > +-----------------------------------+
> >       ^                       |
> >       |                       |
> >       |                       |
> >       |                       |
> >       |                       v
> > +-----+----+             +----+-----+
> > | netperf  | Host1       | netserver| Host2
> > +----------+             +----------+
> >
> > We use netperf send the 64B packets, and insert 255+ flow-mask:
> > $ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=3D00:01:00:00:00:00=
/ff:ff:ff:ff:ff:01),eth_type(0x0800),ipv4(frag=3Dno)" 2
> > ...
> > $ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=3D00:ff:00:00:00:00=
/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=3Dno)" 2
> > $
> > $ netperf -t UDP_STREAM -H 2.2.2.200 -l 40 -- -m 18
> >
> > * Without series patch, throughput 8.28Mbps
> > * With series patch, throughput 46.05Mbps
> >
> > v3->v4:
> > access ma->count with READ_ONCE/WRITE_ONCE API. More information,
> > see patch 5 comments.
> >
> > v2->v3:
> > update ma point when realloc mask_array in patch 5.
> >
> > v1->v2:
> > use kfree_rcu instead of call_rcu
> >
> > Tonghao Zhang (10):
> >   net: openvswitch: add flow-mask cache for performance
> >   net: openvswitch: convert mask list in mask array
> >   net: openvswitch: shrink the mask array if necessary
> >   net: openvswitch: optimize flow mask cache hash collision
> >   net: openvswitch: optimize flow-mask looking up
> >   net: openvswitch: simplify the flow_hash
> >   net: openvswitch: add likely in flow_lookup
> >   net: openvswitch: fix possible memleak on destroy flow-table
> >   net: openvswitch: don't unlock mutex when changing the user_features
> >     fails
> >   net: openvswitch: simplify the ovs_dp_cmd_new
> >
> >  net/openvswitch/datapath.c   |  65 +++++----
> >  net/openvswitch/flow.h       |   1 -
> >  net/openvswitch/flow_table.c | 316 +++++++++++++++++++++++++++++++++++=
++------
> >  net/openvswitch/flow_table.h |  19 ++-
> >  4 files changed, 329 insertions(+), 72 deletions(-)
> >
> > --
> > 1.8.3.1
> >
> > _______________________________________________
> > dev mailing list
> > dev@openvswitch.org
> > https://mail.openvswitch.org/mailman/listinfo/ovs-dev
