Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC07611E01
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 01:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJ1XQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 19:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJ1XQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 19:16:21 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2DC247E0A;
        Fri, 28 Oct 2022 16:16:20 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q71so6056344pgq.8;
        Fri, 28 Oct 2022 16:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IUOiX00m8ejZoyEon6oMk0664H+Bpb1REmC9tKD9Xqk=;
        b=AtZSbLDYIu7hlp7eJLTdRXfImd9l/A6jyYjkK2jCLbOvSjTyJitPsATA7E45MMiBaD
         AoRaCLVQloHT3xS0yjrOCT6j57bVheVD6gv8q/fAqwXCdzcOBrambpUem31DWhb8Ai28
         qK5dlYu5e70AHru52bXKbdfcygMsrrBjCFVqL7jgoQaH5q5S1IpKUnmaCj4EtNgk2Qgy
         NLQIMFORumAz6HUIUSvYU1TLZ0SvLzGlGYN5eMf4FvqLL1eFAdDCkzJZr2MGytoI56N1
         49xXia/N8v4cgbjv/XlAh6x9/jI7iP84hJ0ZbVUV4eB2/Rrvz94S8Agf5EnX0NRkbNiC
         guuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IUOiX00m8ejZoyEon6oMk0664H+Bpb1REmC9tKD9Xqk=;
        b=OKJO3MlI/lzrYB2M6SdEjXP66Y0u6Jg+7QkZzx4E0VDOflHQau+ZcDmc/q3X1DpXG1
         YQAHYEfI25LTDkyKZGEgMGb6gkrL6HNBq8imlxi0qoMEK6TC6Kp0z97C2jdpuzD9hje1
         e0TOT9UO5WXOXxIsD9OE1l5X4W+wSQiuNdfXPRgRlUPrawnY/sO//s4cAggZ6H15eGcj
         7nshPYeDnNuQNfWN3cWLJDWlQ+GOzwcmnKNdJHLs17jEeI46Td8SfQwQyQnyR0fjoyo/
         ZzDJ55xftEnfZQTprIErWoDgORZE+r5h7cSsC/mjFHs5HMp9Z4tT+29bwQHlGChsmhZ+
         JU6A==
X-Gm-Message-State: ACrzQf1sRgiSGyhUWjxLPLwyQoI0uLZFeLNxv4dEidMsI/pMb2tJuun7
        fc+q+7cmkFa5sv8XFcyABm8=
X-Google-Smtp-Source: AMsMyM6SGBG8WOY4bIB66GQyfSQgAkkktEKQX7jIgApBzbaKNG8RAUyhcxe/LB3+TYICIElvO4wIpg==
X-Received: by 2002:a05:6a00:78c:b0:56d:2:db06 with SMTP id g12-20020a056a00078c00b0056d0002db06mr1661016pfu.42.1666998979659;
        Fri, 28 Oct 2022 16:16:19 -0700 (PDT)
Received: from localhost ([98.97.41.13])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b001769e6d4fafsm4857plb.57.2022.10.28.16.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 16:16:19 -0700 (PDT)
Date:   Fri, 28 Oct 2022 16:16:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Message-ID: <635c62c12652d_b1ba208d0@john.notmuch>
In-Reply-To: <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch>
 <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
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
> On Fri, Oct 28, 2022 at 11:05 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 28 Oct 2022 08:58:18 -0700 John Fastabend wrote:
> > > A bit of extra commentary. By exposing the raw kptr to the rx
> > > descriptor we don't need driver writers to do anything.
> > > And can easily support all the drivers out the gate with simple
> > > one or two line changes. This pushes the interesting parts
> > > into userspace and then BPF writers get to do the work without
> > > bother driver folks and also if its not done today it doesn't
> > > matter because user space can come along and make it work
> > > later. So no scattered kernel dependencies which I really
> > > would like to avoid here. Its actually very painful to have
> > > to support clusters with N kernels and M devices if they
> > > have different features. Doable but annoying and much nicer
> > > if we just say 6.2 has support for kptr rx descriptor reading
> > > and all XDP drivers support it. So timestamp, rxhash work
> > > across the board.
> >
> > IMHO that's a bit of wishful thinking. Driver support is just a small
> > piece, you'll have different HW and FW versions, feature conflicts etc.
> > In the end kernel version is just one variable and there are many others
> > you'll already have to track.

Agree.

> >
> > And it's actually harder to abstract away inter HW generation
> > differences if the user space code has to handle all of it.

I don't see how its any harder in practice though?

> 
> I've had the same concern:
> 
> Until we have some userspace library that abstracts all these details,
> it's not really convenient to use. IIUC, with a kptr, I'd get a blob
> of data and I need to go through the code and see what particular type
> it represents for my particular device and how the data I need is
> represented there. There are also these "if this is device v1 -> use
> v1 descriptor format; if it's a v2->use this another struct; etc"
> complexities that we'll be pushing onto the users. With kfuncs, we put
> this burden on the driver developers, but I agree that the drawback
> here is that we actually have to wait for the implementations to catch
> up.

I agree with everything there, you will get a blob of data and then
will need to know what field you want to read using BTF. But, we
already do this for BPF programs all over the place so its not a big
lift for us. All other BPF tracing/observability requires the same
logic. I think users of BPF in general perhaps XDP/tc are the only
place left to write BPF programs without thinking about BTF and
kernel data structures.

But, with proposed kptr the complexity lives in userspace and can be
fixed, added, updated without having to bother with kernel updates, etc.
From my point of view of supporting Cilium its a win and much preferred
to having to deal with driver owners on all cloud vendors, distributions,
and so on.

If vendor updates firmware with new fields I get those immediately.

> 
> Jakub mentions FW and I haven't even thought about that; so yeah, bpf
> programs might have to take a lot of other state into consideration
> when parsing the descriptors; all those details do seem like they
> belong to the driver code.

I would prefer to avoid being stuck on requiring driver writers to
be involved. With just a kptr I can support the device and any
firwmare versions without requiring help.

> 
> Feel free to send it early with just a handful of drivers implemented;
> I'm more interested about bpf/af_xdp/user api story; if we have some
> nice sample/test case that shows how the metadata can be used, that
> might push us closer to the agreement on the best way to proceed.

I'll try to do a intel and mlx implementation to get a cross section.
I have a good collection of nics here so should be able to show a
couple firmware versions. It could be fine I think to have the raw
kptr access and then also kfuncs for some things perhaps.


> 
> 
> 
> > > To find the offset of fields (rxhash, timestamp) you can use
> > > standard BTF relocations we have all this machinery built up
> > > already for all the other structs we read, net_devices, task
> > > structs, inodes, ... so its not a big hurdle at all IMO. We
> > > can add userspace libs if folks really care, but its just a read so
> > > I'm not even sure that is helpful.
> > >
> > > I think its nicer than having kfuncs that need to be written
> > > everywhere. My $.02 although I'll poke around with below
> > > some as well. Feel free to just hang tight until I have some
> > > code at the moment I have intel, mellanox drivers that I
> > > would want to support.
> >
> > I'd prefer if we left the door open for new vendors. Punting descriptor
> > parsing to user space will indeed result in what you just said - major
> > vendors are supported and that's it.

I'm not sure about why it would make it harder for new vendors? I think
the opposite, it would be easier because I don't need vendor support
at all. Thinking it over seems there could be room for both.


Thanks!
