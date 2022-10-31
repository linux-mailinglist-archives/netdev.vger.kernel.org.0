Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DF6613BDA
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 18:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbiJaRB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 13:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiJaRB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 13:01:26 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD2012D2A;
        Mon, 31 Oct 2022 10:01:22 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso10807796pjc.2;
        Mon, 31 Oct 2022 10:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H60ymyNbPnx76svqB8tIQXkHAoPHY8L+pbgNyeNrKZo=;
        b=hyl3KfPpNkYKNUmm1V9F7pzM7Ko/WT+IPabIZuAd4yJg0Tlo6ZliaxlokS5iSGnLU0
         qntHmgNNT3RJTjazFoeHAbf1HgyII4bfJVC6RkDCn+WjAhZicDDlNoEA7mpd5wHq6psv
         /Er/APajvhgvZuuraYBKVK+Cz78HoEeEA05rsX+IBNSRgAQHulC1Za6s1f7zZPcSVUs4
         k03Pi2yzIkBuGDcJjr7NMfKx92eytzhSkqhAcnHApN4U53dx+6cxKUAKGUIvJsEy+cza
         UlAdLfRxuY2pfbw6INB9rnjAxR13y6WNvrkv69gXUN2rSBjrKnPqrKxQ/CE6ubyf3qP2
         nwVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H60ymyNbPnx76svqB8tIQXkHAoPHY8L+pbgNyeNrKZo=;
        b=M4C/6xB5ZfnULw9Kj1IrjqI4vsHzJQEhq7s8/zlh0iQBenbBwtvMYlMl06G05MzRIA
         tMksvyN8NTR5gDmnYl6bOOK/NYNvPQha7j6waprJ0bxJtVZeRZTOv1DS6YNK9PV/jxSt
         AQ/Fv0h9CQbOR0X0WfXk3xdHMJy0opQU1udzbnwLcueZ02BFPuNVRUWTlLgA+3/BxVmH
         1+LAvS2sGj8cv73u7eL94K4z/xFiiGtTbyiBMT8VZEsob9y4Oib39DS97XCUq7OKoFSR
         dY3Pc3WndgB9RwZqWv9U52Z2v4g3Xy5Xs7RXlKkszto5jg3HJnZ45VUmR/ycHG8CwSoU
         YiRQ==
X-Gm-Message-State: ACrzQf3FxTO3chxL8ivmZdbExBe/amgUXobg6TlRn1R2aT9kxIg1BB/x
        kABAKPIOn8san0pZQFuSdkQ=
X-Google-Smtp-Source: AMsMyM6Ah1c7RKgG4GNdS2yCECceZrq0dwqq6csjbw7mtw1wMQf/I3HgvHaFor0Buvrxxzcr+AXVxw==
X-Received: by 2002:a17:90b:4c12:b0:213:d3e3:ba4c with SMTP id na18-20020a17090b4c1200b00213d3e3ba4cmr8288504pjb.22.1667235682179;
        Mon, 31 Oct 2022 10:01:22 -0700 (PDT)
Received: from localhost ([98.97.41.13])
        by smtp.gmail.com with ESMTPSA id 85-20020a621658000000b005609d3d3008sm4968928pfw.171.2022.10.31.10.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 10:01:21 -0700 (PDT)
Date:   Mon, 31 Oct 2022 10:01:20 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org,
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
Message-ID: <635fff602ec9d_febd20826@john.notmuch>
In-Reply-To: <20221028181431.05173968@kernel.org>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch>
 <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch>
 <20221028181431.05173968@kernel.org>
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

Jakub Kicinski wrote:
> On Fri, 28 Oct 2022 16:16:17 -0700 John Fastabend wrote:
> > > > And it's actually harder to abstract away inter HW generation
> > > > differences if the user space code has to handle all of it.  
> > 
> > I don't see how its any harder in practice though?
> 
> You need to find out what HW/FW/config you're running, right?
> And all you have is a pointer to a blob of unknown type.

Yep. I guess I'm in the position of already having to do this
somewhat to collect stats from the device. Although its maybe
a bit more involved here by vendors that are versioning the
descriptors.

Also nit, its not unknown type we know the full type by BTF.

> 
> Take timestamps for example, some NICs support adjusting the PHC 
> or doing SW corrections (with different versions of hw/fw/server
> platforms being capable of both/one/neither).

Its worse actually.

Having started to do this timestamping it is not at all consistent
across nics so I think we are stuck having to know hw specifics
here regardless. Also some nics will timestamp all RX pkts, some
specific pkts, some require configuration to decide which mode
to run in and so on. You then end up with a matrix of features
supported by hw/fw/sw and desired state and I can't see any way
around this.

> 
> Sure you can extract all this info with tracing and careful
> inspection via uAPI. But I don't think that's _easier_.
> And the vendors can't run the results thru their validation 
> (for whatever that's worth).

I think you hit our point of view differences below. See I
don't want to depend on the vendor. I want access to the
fields otherwise I'm stuck working with vendors on their
time frames. You have the other perspective of supporting the
NIC and ability to update kernels where as I still live with
4.18/4.19 kernels (even 4.14 sometimes). So what we land now
needs to work in 5 years still.

> 
> > > I've had the same concern:
> > > 
> > > Until we have some userspace library that abstracts all these details,
> > > it's not really convenient to use. IIUC, with a kptr, I'd get a blob
> > > of data and I need to go through the code and see what particular type
> > > it represents for my particular device and how the data I need is
> > > represented there. There are also these "if this is device v1 -> use
> > > v1 descriptor format; if it's a v2->use this another struct; etc"
> > > complexities that we'll be pushing onto the users. With kfuncs, we put
> > > this burden on the driver developers, but I agree that the drawback
> > > here is that we actually have to wait for the implementations to catch
> > > up.  
> > 
> > I agree with everything there, you will get a blob of data and then
> > will need to know what field you want to read using BTF. But, we
> > already do this for BPF programs all over the place so its not a big
> > lift for us. All other BPF tracing/observability requires the same
> > logic. I think users of BPF in general perhaps XDP/tc are the only
> > place left to write BPF programs without thinking about BTF and
> > kernel data structures.
> > 
> > But, with proposed kptr the complexity lives in userspace and can be
> > fixed, added, updated without having to bother with kernel updates, etc.
> > From my point of view of supporting Cilium its a win and much preferred
> > to having to deal with driver owners on all cloud vendors, distributions,
> > and so on.
> > 
> > If vendor updates firmware with new fields I get those immediately.
> 
> Conversely it's a valid concern that those who *do* actually update
> their kernel regularly will have more things to worry about.

I'm not sure if a kptr_func is any harder to write than a user space
relocation for that func? In tetragon and cilium we've done userspace
rewrites for some time. Happy to generalize that infra into kernel
repo if that helps. IMO having a libhw.h in kernel tree ./tools/bpf
directory would work.

> 
> > > Jakub mentions FW and I haven't even thought about that; so yeah, bpf
> > > programs might have to take a lot of other state into consideration
> > > when parsing the descriptors; all those details do seem like they
> > > belong to the driver code.  
> > 
> > I would prefer to avoid being stuck on requiring driver writers to
> > be involved. With just a kptr I can support the device and any
> > firwmare versions without requiring help.
> 
> 1) where are you getting all those HW / FW specs :S

Most are public docs of course vendors have internal docs with more
details but what can you do. Also source code has the structs.

> 2) maybe *you* can but you're not exactly not an ex-driver developer :S

Sure :) but we put a libhw.h file in kernel and test with selftests
(which will be hard without hardware) and then not everyone needs
to be a driver internals expert.

> 
> > > Feel free to send it early with just a handful of drivers implemented;
> > > I'm more interested about bpf/af_xdp/user api story; if we have some
> > > nice sample/test case that shows how the metadata can be used, that
> > > might push us closer to the agreement on the best way to proceed.  
> > 
> > I'll try to do a intel and mlx implementation to get a cross section.
> > I have a good collection of nics here so should be able to show a
> > couple firmware versions. It could be fine I think to have the raw
> > kptr access and then also kfuncs for some things perhaps.
> > 
> > > > I'd prefer if we left the door open for new vendors. Punting descriptor
> > > > parsing to user space will indeed result in what you just said - major
> > > > vendors are supported and that's it.  
> > 
> > I'm not sure about why it would make it harder for new vendors? I think
> > the opposite, 
> 
> TBH I'm only replying to the email because of the above part :)
> I thought this would be self evident, but I guess our perspectives 
> are different.

Yep.

> 
> Perhaps you look at it from the perspective of SW running on someone
> else's cloud, an being able to move to another cloud, without having 
> to worry if feature X is available in xdp or just skb.

Exactly. I have SW running in a data center or cloud for a security
team or ops team and they don't own the platform usually. Anyways
the platform team is going to stay on a LTS kernel for at least a
year or two most likely. I maintain the SW and some 3rd party
nic vendor may not even know about my SW (cilium/tetragon).

> 
> I look at it from the perspective of maintaining a cloud, with people
> writing random XDP applications. If I swap a NIC from an incumbent to a
> (superior) startup, and cloud users are messing with raw descriptor -
> I'd need to go find every XDP program out there and make sure it
> understands the new descriptors.

I get it. Its interesting that you wouldn't tell the XDP programmers
to deal with it which is my case. My $.02 is a userspace lib could
abstract this easier than a kernel func and also add new features
without rolling new kernels.

> 
> There is a BPF foundation or whatnot now - what about starting a
> certification program for cloud providers and making it clear what
> features must be supported to be compatible with XDP 1.0, XDP 2.0 etc?

Maybe but still stuck on kernel versions.

> 
> > it would be easier because I don't need vendor support at all.
> 
> Can you support the enfabrica NIC on day 1? :) To an extent, its just
> shifting the responsibility from the HW vendor to the middleware vendor.

Yep. With important detail that I can run new features on old kernels
even if vendor didn't add rxhash or timestamp out the gate.

Nothing stops the hw vendor from contributing to this in kernel
source bpf lib with the features though.

> 
> > Thinking it over seems there could be room for both.
> 
> Are you thinking more or less Stan's proposal but with one of 
> the callbacks being "give me the raw thing"? Probably as a ro dynptr?
> Possible, but I don't think we need to hold off Stan's work.

Yeah that was my thinking. Both could coexist. OTOH doing it in
BPF program lib side seems cleaner to me from a kernel maitenance
and hardware support. We've had trouble getting drivers to support
XDP features so adding more requirements of entry seems problematic
to me when we can avoid it.
