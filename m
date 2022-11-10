Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0706238E9
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 02:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiKJBfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 20:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiKJBfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 20:35:24 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E6B1E71D;
        Wed,  9 Nov 2022 17:35:23 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so3501932pjc.3;
        Wed, 09 Nov 2022 17:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aBWVLQ8bpcmSVCI9/eRrlYiKEKS4ChABCKWm3hWCQDg=;
        b=WND2qg3NkTaTsQ8lEHsgRLDmkmUZAVv/AC3413t0qb54lb6POtCdQmiu87lwHHAedW
         OGmK6OdBNEjdbvchZPQk/9OIgHw7H0UcvOqg0AiexDghWa/Dk4564O7zHvZFRGRatE40
         BirfxSzbykucGYQ9dyjIRvH6d5H17C5rvOi82Z9j9DRZZgNGMOuq0I4HpwfLoCTbXZeH
         DDRDvDOp1G305SDGXvS3cu6wx1mkS/UmwbE3qXI6uq971LXVAruuEHNeNtu2EAYtQSS9
         hgj2qJ8a6BqOqiXMoyBCSLdSCcB/6ijxhk1rP2zEhesiQAf9x+m43I0KwTMC8B6cx7Ya
         HPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aBWVLQ8bpcmSVCI9/eRrlYiKEKS4ChABCKWm3hWCQDg=;
        b=Jx/+H0GAlX9IeOgJuqr2Ifpi8uJfpk/lt8NUKdz+8D4VI/ONEn7dEqCh7sOjNQHTd1
         1gvofzPXz1oH2imvxTCD1pItVlBuLcQHvu5CnC9rtneez59ondRYLXzyaSyZrWhvexqH
         SOS/EOuzz9OwJBVKk/UN05GBvu/1tBPDmbbC4lsxDs2DWfScx7/s2AWzQ//ca2NnfA4a
         jfDX+KobNCAuqxFSgB+a2N87Ux+W24XPNCc7wRTKKBoEq3jvOhNlJ2EoqTeRz89GyRmt
         VvVXgqDvi2zuBmImdsd0va4fxuRKa7jSdUzlFFr7QpGRN/1JkS0r3QphwG7EPcLa10i2
         rlVw==
X-Gm-Message-State: ANoB5pnT5WxQDEGdghO8BOPZEGoCUX5gKmjVHO0sPGVro/N1mk/G2FhZ
        8lswOhidP8Xpb+KiSmQ7PzM=
X-Google-Smtp-Source: AA0mqf6TRCn3ocObYvdfwHgBkIrFKVPceTIVdjm2HuYhQENpPOLxnlmnM7o0hD7CU6SJ1vEi32ewDQ==
X-Received: by 2002:a17:90a:fd0c:b0:217:cd6b:466 with SMTP id cv12-20020a17090afd0c00b00217cd6b0466mr19237426pjb.4.1668044123216;
        Wed, 09 Nov 2022 17:35:23 -0800 (PST)
Received: from localhost ([98.97.44.95])
        by smtp.gmail.com with ESMTPSA id o24-20020aa79798000000b0056a7486da77sm9143255pfp.13.2022.11.09.17.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 17:35:22 -0800 (PST)
Date:   Wed, 09 Nov 2022 17:35:21 -0800
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
Message-ID: <636c555942433_13ef3820861@john.notmuch>
In-Reply-To: <CAKH8qBvS9C5Z2L2dT4Ze-dz7YBSpw52VF6iZK5phcU2k4azN5A@mail.gmail.com>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-5-sdf@google.com>
 <636c4514917fa_13c168208d0@john.notmuch>
 <CAKH8qBvS9C5Z2L2dT4Ze-dz7YBSpw52VF6iZK5phcU2k4azN5A@mail.gmail.com>
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
> On Wed, Nov 9, 2022 at 4:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Stanislav Fomichev wrote:
> > > xskxceiver conveniently setups up veth pairs so it seems logical
> > > to use veth as an example for some of the metadata handling.
> > >
> > > We timestamp skb right when we "receive" it, store its
> > > pointer in new veth_xdp_buff wrapper and generate BPF bytecode to
> > > reach it from the BPF program.
> > >
> > > This largely follows the idea of "store some queue context in
> > > the xdp_buff/xdp_frame so the metadata can be reached out
> > > from the BPF program".
> > >
> >
> > [...]
> >
> > >       orig_data = xdp->data;
> > >       orig_data_end = xdp->data_end;
> > > +     vxbuf.skb = skb;
> > >
> > >       act = bpf_prog_run_xdp(xdp_prog, xdp);
> > >
> > > @@ -942,6 +946,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
> > >                       struct sk_buff *skb = ptr;
> > >
> > >                       stats->xdp_bytes += skb->len;
> > > +                     __net_timestamp(skb);
> >
> > Just getting to reviewing in depth a bit more. But we hit veth with lots of
> > packets in some configurations I don't think we want to add a __net_timestamp
> > here when vast majority of use cases will have no need for timestamp on veth
> > device. I didn't do a benchmark but its not free.
> >
> > If there is a real use case for timestamping on veth we could do it through
> > a XDP program directly? Basically fallback for devices without hw timestamps.
> > Anyways I need the helper to support hardware without time stamping.
> >
> > Not sure if this was just part of the RFC to explore BPF programs or not.
> 
> Initially I've done it mostly so I can have selftests on top of veth
> driver, but I'd still prefer to keep it to have working tests.

I can't think of a use for it though so its just extra cycles. There
is a helper to read the ktime.

> Any way I can make it configurable? Is there some ethtool "enable tx
> timestamping" option I can reuse?

There is a -T option for timestamping in ethtool. There are also the
socket controls for it. So you could spin up a socket and use it.
But that is a bit broken as well I think it would be better if the
timestamp came from the receiving physical nic?

I have some mlx nics here and a k8s cluster with lots of veth
devices so I could think a bit more. I'm just not sure why I would
want the veth to timestamp things off hand?

> 
> > >                       skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
> > >                       if (skb) {
> > >                               if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))


