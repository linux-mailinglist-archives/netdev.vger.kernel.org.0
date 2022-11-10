Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE29624877
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiKJRjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiKJRjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:39:51 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE02B67;
        Thu, 10 Nov 2022 09:39:49 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id z5-20020a17090a8b8500b00210a3a2364fso6175062pjn.0;
        Thu, 10 Nov 2022 09:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fkTtzlcKn1zOqGnjHVoAglRb+bpnOfFk7f1bH1VS+bI=;
        b=E/H26MqvD19wkzCRrCoi9WAUcjqZ6LB5dcvuUSzdz+++oV5eGErl9bHJt2ut5Jv/+z
         UZQNqQmqgookqeIxOgRW0a2c+jBBbzVM/PV7vmh5MMxWav2csXbuEkGDr1REPM5It3kz
         tFM31ZKla/P3G/OLKp0kXjc4PjtoV2qSg6iki5stUE5/tY7SrV+hSSu9sVbnr4qfoxZV
         Wud7yand+xWEHWekeXFlSd3CLkJ8nrCsokx/uMYfWhmteg8kdFs0TGIE3lSzPsx9n76D
         V75bZ8ZCv9Vp6CW0IiHkPKRMfYA/AzlvifqO8aCj/ZWy4EoSJN0E12Vj9zzowTGFlUky
         JKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fkTtzlcKn1zOqGnjHVoAglRb+bpnOfFk7f1bH1VS+bI=;
        b=NGp2Xf836lACcGR0gdVisxTArOqKZTgtdUDrpGPu7Sp4rQZHzjRvbr0pyk0cZmw3NT
         4U6MOFNQ3FNQ1u6ru7QFe+y1bNR9vvYfzCHm3/IC6RqZOn/t8NPOhtrSA0FM3EOE3dhe
         XegYWNfa+rSA6RC6/0lqwfgFvonFl+FN3HZ0STSAeOTHKDd1hxx5gp1NjVxfW2y3wpEE
         pTIViW6NTK11nbMpM9VeYwU9RKlm48Gr2EwfDVIWTST+UJyemORdRvRfN8MHK78lJy+b
         /we/b+tV/oMiym6Vh5Rzrdf8A2oh2kXBvW8e7h5bFkjhMrQ0omgP2t5bXeX20li0YuC3
         ABnw==
X-Gm-Message-State: ACrzQf0nmKkeaHT8LjrVjXpBcrLH8Jc8exQXonFcAP8g4O/PFgN21LZJ
        lGX1ZAOZTHZh544cwzj3Z68=
X-Google-Smtp-Source: AMsMyM7h+m8g/kR3FZwPRyYHexfKgIB4iRSITSAipaGu18VwJUuCBaw8vu4/fxEopJ0UgzNUgs7bgg==
X-Received: by 2002:a17:902:b609:b0:17f:7ed1:7da5 with SMTP id b9-20020a170902b60900b0017f7ed17da5mr1635007pls.101.1668101989199;
        Thu, 10 Nov 2022 09:39:49 -0800 (PST)
Received: from localhost ([98.97.42.169])
        by smtp.gmail.com with ESMTPSA id n4-20020a170902e54400b0017f73dc1549sm11563690plf.263.2022.11.10.09.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 09:39:48 -0800 (PST)
Date:   Thu, 10 Nov 2022 09:39:46 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Message-ID: <636d37629d5c4_145693208e6@john.notmuch>
In-Reply-To: <CAKH8qBtiNiwbupP-jvs5+nSJRJS4DfZGEPsaYFdQcPKu+8G30g@mail.gmail.com>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-5-sdf@google.com>
 <636c4514917fa_13c168208d0@john.notmuch>
 <CAKH8qBvS9C5Z2L2dT4Ze-dz7YBSpw52VF6iZK5phcU2k4azN5A@mail.gmail.com>
 <636c555942433_13ef3820861@john.notmuch>
 <CAKH8qBtiNiwbupP-jvs5+nSJRJS4DfZGEPsaYFdQcPKu+8G30g@mail.gmail.com>
Subject: Re: [RFC bpf-next v2 04/14] veth: Support rx timestamp metadata for
 xdp
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev wrote:
> On Wed, Nov 9, 2022 at 5:35 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Stanislav Fomichev wrote:
> > > On Wed, Nov 9, 2022 at 4:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > >
> > > > Stanislav Fomichev wrote:
> > > > > xskxceiver conveniently setups up veth pairs so it seems logical
> > > > > to use veth as an example for some of the metadata handling.
> > > > >
> > > > > We timestamp skb right when we "receive" it, store its
> > > > > pointer in new veth_xdp_buff wrapper and generate BPF bytecode to
> > > > > reach it from the BPF program.
> > > > >
> > > > > This largely follows the idea of "store some queue context in
> > > > > the xdp_buff/xdp_frame so the metadata can be reached out
> > > > > from the BPF program".
> > > > >
> > > >
> > > > [...]
> > > >
> > > > >       orig_data = xdp->data;
> > > > >       orig_data_end = xdp->data_end;
> > > > > +     vxbuf.skb = skb;
> > > > >
> > > > >       act = bpf_prog_run_xdp(xdp_prog, xdp);
> > > > >
> > > > > @@ -942,6 +946,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
> > > > >                       struct sk_buff *skb = ptr;
> > > > >
> > > > >                       stats->xdp_bytes += skb->len;
> > > > > +                     __net_timestamp(skb);
> > > >
> > > > Just getting to reviewing in depth a bit more. But we hit veth with lots of
> > > > packets in some configurations I don't think we want to add a __net_timestamp
> > > > here when vast majority of use cases will have no need for timestamp on veth
> > > > device. I didn't do a benchmark but its not free.
> > > >
> > > > If there is a real use case for timestamping on veth we could do it through
> > > > a XDP program directly? Basically fallback for devices without hw timestamps.
> > > > Anyways I need the helper to support hardware without time stamping.
> > > >
> > > > Not sure if this was just part of the RFC to explore BPF programs or not.
> > >
> > > Initially I've done it mostly so I can have selftests on top of veth
> > > driver, but I'd still prefer to keep it to have working tests.
> >
> > I can't think of a use for it though so its just extra cycles. There
> > is a helper to read the ktime.
> 
> As I mentioned in another reply, I wanted something SW-only to test
> this whole metadata story.

Yeah I see the value there. Also because this is in the veth_xdp_rcv
path we don't actually attach XDP programs to veths except for in
CI anyways. I assume though if someone actually does use this in
prod having an extra _net_timestamp there would be extra unwanted
cycles.

> The idea was:
> - veth rx sets skb->tstamp (otherwise it's 0 at this point)
> - veth kfunc to access rx_timestamp returns skb->tstamp
> - xsk bpf program verifies that the metadata is non-zero
> - the above shows end-to-end functionality with a software driver

Yep 100% agree very handy for testing just not sure we can add code
to hotpath just for testing.

> 
> > > Any way I can make it configurable? Is there some ethtool "enable tx
> > > timestamping" option I can reuse?
> >
> > There is a -T option for timestamping in ethtool. There are also the
> > socket controls for it. So you could spin up a socket and use it.
> > But that is a bit broken as well I think it would be better if the
> > timestamp came from the receiving physical nic?
> >
> > I have some mlx nics here and a k8s cluster with lots of veth
> > devices so I could think a bit more. I'm just not sure why I would
> > want the veth to timestamp things off hand?
> 
> -T is for dumping only it seems?
> 
> I'm probably using skb->tstamp in an unconventional manner here :-/
> Do you know if enabling timestamping on the socket, as you suggest,
> will get me some non-zero skb_hwtstamps with xsk?
> I need something to show how the kfunc can return this data and how
> can this data land in xdp prog / af_xdp chunk..

Take a look at ./Documentation/networking/timestamping.rst the 3.1
section is maybe relevant. But then you end up implementing a bunch
of random ioctls for no reason other than testing. Maybe worth doing
though for this not sure.

Using virtio driver might be actual useful and give you a test device.
Early XDP days I used it for testing a lot. Would require qemu to
setup though.
