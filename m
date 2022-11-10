Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA35623C0F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 07:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiKJGof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 01:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbiKJGo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 01:44:27 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB0B2BB2C
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 22:44:26 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id 11so620651iou.0
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 22:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xZWmNl+s6/+ylHCRYLaklnEjUiNAAHp+iYnGFNfbckI=;
        b=jqGCrUUeORBVFvIhuhYXguszWe3kzU+uRddjl4wfCsd5FUpX9G3AsfXU8kW3L7niLM
         Q/H0jOz6lwyvwZ2Xfrb/c4lk8K/cyY7wIQE9HtUxguZUd8g5cveme+DgbYoThaVmKRsA
         ozuLwBCfYf0q90R/BMt+g/lHDbdmJKLD6Y29Y8YCNUO8QcS5f1oomHaWwfBNMq6oIU0i
         2KTzdK9StUoDhDp9XSSvh5YAc8P+C3USV3URKUlDP7bSyWPGsvHZejCmphblhUYmD5nS
         yPJkxpq54M1yCk+k395mmx9zQLuqT6t8ShFtF2ycBKKB68Pihjgj/oQc4tHMranNROxs
         mREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZWmNl+s6/+ylHCRYLaklnEjUiNAAHp+iYnGFNfbckI=;
        b=NmWwrfdwjG/hsKw0JktxBnQlgntg/8ShGBdywD/mR2TnadbKWa9J5HkmxcXeTdsgHg
         OVnTuGxYLPr9F0Rm1uLh6S+BD7WuFXl9nRXwJTfPT24mpg0wjLzOu6M8jzq0e/55224B
         qlcWvo7rirPH0lXBmmJfWAYdX+B/imXVHDFg6I8jvw5OHkvh3f0PBbMneob5/wD7PGRM
         BmZK7LBiNU8RkNrJZgbELOQ9E2glaWDnRmxyHd9VRMKnXfEilDU95NglTXEqKAfGFdcb
         EsNBfI+lKynijF9eZS+CTK4wt4/C3aoRqArYz6wI99jwfZ9y8ZA0IN0AXrHcHRtmG11G
         14dA==
X-Gm-Message-State: ACrzQf2kjBo/cxFz5A1NRcERLKGBjQdJle35h4YFxeV73p3cRFC4h4OP
        RfgPs5rfTxyX5pzUaCsB7NyMP9kQNCIWCd+ABW3AOA==
X-Google-Smtp-Source: AMsMyM5B7R9Y20dOwR14OA9MjHTec76QNVAumQfhA5+n1UZkrhpfHgz4ZoJdt+WYkbHF88uHjHXDl8kt0ZRQm4DVbxM=
X-Received: by 2002:a6b:580e:0:b0:6c0:db74:7be1 with SMTP id
 m14-20020a6b580e000000b006c0db747be1mr2414409iob.92.1668062665318; Wed, 09
 Nov 2022 22:44:25 -0800 (PST)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-5-sdf@google.com>
 <636c4514917fa_13c168208d0@john.notmuch> <CAKH8qBvS9C5Z2L2dT4Ze-dz7YBSpw52VF6iZK5phcU2k4azN5A@mail.gmail.com>
 <636c555942433_13ef3820861@john.notmuch>
In-Reply-To: <636c555942433_13ef3820861@john.notmuch>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 9 Nov 2022 22:44:14 -0800
Message-ID: <CAKH8qBtiNiwbupP-jvs5+nSJRJS4DfZGEPsaYFdQcPKu+8G30g@mail.gmail.com>
Subject: Re: [RFC bpf-next v2 04/14] veth: Support rx timestamp metadata for xdp
To:     John Fastabend <john.fastabend@gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 9, 2022 at 5:35 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Stanislav Fomichev wrote:
> > On Wed, Nov 9, 2022 at 4:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Stanislav Fomichev wrote:
> > > > xskxceiver conveniently setups up veth pairs so it seems logical
> > > > to use veth as an example for some of the metadata handling.
> > > >
> > > > We timestamp skb right when we "receive" it, store its
> > > > pointer in new veth_xdp_buff wrapper and generate BPF bytecode to
> > > > reach it from the BPF program.
> > > >
> > > > This largely follows the idea of "store some queue context in
> > > > the xdp_buff/xdp_frame so the metadata can be reached out
> > > > from the BPF program".
> > > >
> > >
> > > [...]
> > >
> > > >       orig_data = xdp->data;
> > > >       orig_data_end = xdp->data_end;
> > > > +     vxbuf.skb = skb;
> > > >
> > > >       act = bpf_prog_run_xdp(xdp_prog, xdp);
> > > >
> > > > @@ -942,6 +946,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
> > > >                       struct sk_buff *skb = ptr;
> > > >
> > > >                       stats->xdp_bytes += skb->len;
> > > > +                     __net_timestamp(skb);
> > >
> > > Just getting to reviewing in depth a bit more. But we hit veth with lots of
> > > packets in some configurations I don't think we want to add a __net_timestamp
> > > here when vast majority of use cases will have no need for timestamp on veth
> > > device. I didn't do a benchmark but its not free.
> > >
> > > If there is a real use case for timestamping on veth we could do it through
> > > a XDP program directly? Basically fallback for devices without hw timestamps.
> > > Anyways I need the helper to support hardware without time stamping.
> > >
> > > Not sure if this was just part of the RFC to explore BPF programs or not.
> >
> > Initially I've done it mostly so I can have selftests on top of veth
> > driver, but I'd still prefer to keep it to have working tests.
>
> I can't think of a use for it though so its just extra cycles. There
> is a helper to read the ktime.

As I mentioned in another reply, I wanted something SW-only to test
this whole metadata story.
The idea was:
- veth rx sets skb->tstamp (otherwise it's 0 at this point)
- veth kfunc to access rx_timestamp returns skb->tstamp
- xsk bpf program verifies that the metadata is non-zero
- the above shows end-to-end functionality with a software driver

> > Any way I can make it configurable? Is there some ethtool "enable tx
> > timestamping" option I can reuse?
>
> There is a -T option for timestamping in ethtool. There are also the
> socket controls for it. So you could spin up a socket and use it.
> But that is a bit broken as well I think it would be better if the
> timestamp came from the receiving physical nic?
>
> I have some mlx nics here and a k8s cluster with lots of veth
> devices so I could think a bit more. I'm just not sure why I would
> want the veth to timestamp things off hand?

-T is for dumping only it seems?

I'm probably using skb->tstamp in an unconventional manner here :-/
Do you know if enabling timestamping on the socket, as you suggest,
will get me some non-zero skb_hwtstamps with xsk?
I need something to show how the kfunc can return this data and how
can this data land in xdp prog / af_xdp chunk..


> >
> > > >                       skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
> > > >                       if (skb) {
> > > >                               if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))
>
>
