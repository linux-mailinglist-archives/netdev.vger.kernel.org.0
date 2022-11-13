Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DADA6271A5
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 19:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbiKMS1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 13:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiKMS1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 13:27:10 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8E7E09A;
        Sun, 13 Nov 2022 10:27:09 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso8690461pjc.5;
        Sun, 13 Nov 2022 10:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RczQK/rDbnu/hDjP0HeBJokJVVbkz5ikk2Qaau3txH0=;
        b=RxA9DZnlw2lOPhssrX6lixiVvRY0EoLQ29v7M/SbKWYrH7YW2AaRXD/LWz56jTzDCP
         Dbae+otDmgPoaqI/E/cVZvukRueGbx4mZad/FI2+hGfz1OrgdVukZBTheDOgmM+4i1bP
         Fm7Xu2hqBTeF0R8qzAgI20FMGD1zsEnp9lmgwVoFjSQUmYt8kOqjun+rlXLcqUplF84I
         xB470BEpUoDtb/YcSmX9ko0Rmiio4GAo6bCkxUO6GC4Uvjo2WggODrshR02JRhsrSCiK
         1aMcApli689mhB3cZ46Alvjg3jYDYCTBjLhsky9rZRpnmP7O4JoYL2klTDXavINleVNH
         e5fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RczQK/rDbnu/hDjP0HeBJokJVVbkz5ikk2Qaau3txH0=;
        b=4X5NBfbgAK92yK5i3/rGA5ih3sRndZYOQerxNMLFlyXfCI2d9vkfIM+n/as2g+KoKk
         f9VRbW187xb0R5Y76u+5lvrx7nc8Tto5l1iW2O1lcbOsXRAstA7AyGVDcVUmt4FuQ38P
         3yBCxFS07TvWUYPJCz5+jK4jjeTgSk/OWmWaznGl+xXdWu6YEYf6Ukt9TQOYpStzygww
         Msks5ppwkPDqWyVBnF6gZkhZ8MO9JnyIlB6k+RC+VW66uWDO0dShMUa4jooNdoV+YpwB
         etP8zEpPLtzEuFdVPyhxsY4xhQpcWyDVLXDJL5jvToT8mxylLHiqJZyERYYfF14fTu4F
         KLhg==
X-Gm-Message-State: ANoB5plUyIbu22z+oExcXSjoTippR0zeYdDSetvEXzDMNTgGH/TPxejs
        QFZtVgoZ7DC0X9vyrIUUCQvKc6TBBew=
X-Google-Smtp-Source: AA0mqf69opX+NuTMRJ0ADf73XQNNUrzsFSult65M7zTThXYHUvh+ue9IpBJuZxrwXu7Y2Xe08y/F5A==
X-Received: by 2002:a17:90a:d302:b0:20d:2f:709d with SMTP id p2-20020a17090ad30200b0020d002f709dmr10741432pju.40.1668364029312;
        Sun, 13 Nov 2022 10:27:09 -0800 (PST)
Received: from localhost ([98.97.44.106])
        by smtp.gmail.com with ESMTPSA id g17-20020aa79f11000000b0056da2bf607csm4956562pfr.214.2022.11.13.10.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 10:27:08 -0800 (PST)
Date:   Sun, 13 Nov 2022 10:27:06 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yonghong Song <yhs@meta.com>,
        John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
Message-ID: <637136faa95e5_2c136208dc@john.notmuch>
In-Reply-To: <86af974c-a970-863f-53f5-c57ebba9754e@meta.com>
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch>
 <aeb8688f-7848-84d2-9502-fad400b1dcdc@meta.com>
 <636d82206e7c_154599208b0@john.notmuch>
 <636d853a8d59_15505d20826@john.notmuch>
 <86af974c-a970-863f-53f5-c57ebba9754e@meta.com>
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
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

Yonghong Song wrote:
> 
> 
> On 11/10/22 3:11 PM, John Fastabend wrote:
> > John Fastabend wrote:
> >> Yonghong Song wrote:
> >>>
> >>>
> >>> On 11/9/22 6:17 PM, John Fastabend wrote:
> >>>> Yonghong Song wrote:
> >>>>>
> >>>>>
> >>>>> On 11/9/22 1:52 PM, John Fastabend wrote:
> >>>>>> Allow xdp progs to read the net_device structure. Its useful to extract
> >>>>>> info from the dev itself. Currently, our tracing tooling uses kprobes
> >>>>>> to capture statistics and information about running net devices. We use
> >>>>>> kprobes instead of other hooks tc/xdp because we need to collect
> >>>>>> information about the interface not exposed through the xdp_md structures.
> >>>>>> This has some down sides that we want to avoid by moving these into the
> >>>>>> XDP hook itself. First, placing the kprobes in a generic function in
> >>>>>> the kernel is after XDP so we miss redirects and such done by the
> >>>>>> XDP networking program. And its needless overhead because we are
> >>>>>> already paying the cost for calling the XDP program, calling yet
> >>>>>> another prog is a waste. Better to do everything in one hook from
> >>>>>> performance side.
> >>>>>>
> >>>>>> Of course we could one-off each one of these fields, but that would
> >>>>>> explode the xdp_md struct and then require writing convert_ctx_access
> >>>>>> writers for each field. By using BTF we avoid writing field specific
> >>>>>> convertion logic, BTF just knows how to read the fields, we don't
> >>>>>> have to add many fields to xdp_md, and I don't have to get every
> >>>>>> field we will use in the future correct.
> >>>>>>
> >>>>>> For reference current examples in our code base use the ifindex,
> >>>>>> ifname, qdisc stats, net_ns fields, among others. With this
> >>>>>> patch we can now do the following,
> >>>>>>
> >>>>>>            dev = ctx->rx_dev;
> >>>>>>            net = dev->nd_net.net;
> >>>>>>
> >>>>>> 	uid.ifindex = dev->ifindex;
> >>>>>> 	memcpy(uid.ifname, dev->ifname, NAME);
> >>>>>>            if (net)
> >>>>>> 		uid.inum = net->ns.inum;
> >>>>>>
> >>>>>> to report the name, index and ns.inum which identifies an
> >>>>>> interface in our system.
> >>>>>

[...]

> >> Yep.
> >>
> >> I'm fine doing it with bpf_get_kern_ctx() did you want me to code it
> >> the rest of the way up and test it?
> >>
> >> .John
> > 
> > Related I think. We also want to get kernel variable net_namespace_list,
> > this points to the network namespace lists. Based on above should
> > we do something like,
> > 
> >    void *bpf_get_kern_var(enum var_id);
> > 
> > then,
> > 
> >    net_ns_list = bpf_get_kern_var(__btf_net_namesapce_list);
> > 
> > would get us a ptr to the list? The other thought was to put it in the
> > xdp_md but from above seems better idea to get it through helper.
> 
> Sounds great. I guess my new proposed bpf_get_kern_btf_id() kfunc could
> cover such a use case as well.

Yes I think this should be good. The only catch is that we need to
get the kernel global var pointer net_namespace_list.

Then we can write iterators on network namespaces and net_devices
without having to do anything else. The usecase is to iterate
the network namespace and collect some subset of netdevices. Populate
a map with these and then keep it in sync from XDP with stats. We
already hook create/destroy paths so have built up maps that track
this and have some XDP stats but not everything we would want.

The other piece I would like to get out of the xdp ctx is the
rx descriptor of the device. I want to use this to pull out info
about the received buffer for debug mostly, but could also grab
some fields that are useful for us to track. That we can likely
do this,

  ctx->rxdesc

Recently had to debug an ugly hardware/driver bug where this would
have been very useful.

.John
