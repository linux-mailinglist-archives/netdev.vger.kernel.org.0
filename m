Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C34B628842
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 19:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbiKNSXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 13:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbiKNSXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 13:23:05 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A483125C58;
        Mon, 14 Nov 2022 10:23:03 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id k15so11814343pfg.2;
        Mon, 14 Nov 2022 10:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dWk/FR4QZekTXFVksmzeI0cG+GSv/ciCEqMaTDLUwYk=;
        b=Lvss1+faAjNeYJfSqXXh9qeQqentX69RdX2A35CoieF+j8Rgsk89554aC5eU9Be3gR
         8EOYMI0VmFRHjEc5sBqXdk6G3A4gTo2jMeTcUfxUHBMVvfTeNAZ6UADEvEvJGt2C/LXf
         mSEzx3DeDzaVC2VSwQgh31q962mp2BWka6mppGd0flRNSkdRpyOie4+ejPWAGKH9YABl
         eFdxrhe9lrjqEtKR5+NrgMdN71zMaJMgs+XLLQDC+x4Pqriv89BXInRW8WWEyhvCUsHA
         7cAx7ziKFFb5mgHcTNcqjB7HKST/L7PEoUeeiEBJ2fSISswyP2ySzatrmal8TLh5wJb4
         ixmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dWk/FR4QZekTXFVksmzeI0cG+GSv/ciCEqMaTDLUwYk=;
        b=qL0GxWCh8SRw2cSMj1VVOB9ZZ10pG3rXGVPCwrfyTn+2A+4pG014m/FkxkZZezfNFb
         ZMpUTkJWwmMLGpYPEjgus+m25FC6leqvNFfcmolqolZaqLRLvIw9wyBNVtg+e3K9dqTw
         3hW24D4cvKB8xvMVhT2aq4C1p2a5p4SPtgD+dp2x8ic16oZ1fspO5ADw9Ts1T8vcFjFK
         tXteFX5UgkdHsM3q3Gkdfm0aRFupj0ylTUmwGDnsEgfCxZJSKIDC2voJILcxhBVzXaqU
         uHznzQwaBu46Vd/X96PNJCY55qsYSLMTOMBDj7egDcDO8tIcb3DmPDhHe7JJ1UXFcFlE
         jWBg==
X-Gm-Message-State: ANoB5pm33wj3C9UvdeoGEKQCvFweN2px0yyDe15Tho6FsnucmeQKrRqt
        lECzkv+neZHK/K7SvcQxV0c=
X-Google-Smtp-Source: AA0mqf52m7FkH9slafAgUNi/BT+yVRVvOMOcYoJu1I22EsU5/7dubBL/y1YuYXNxZKNIZd6QxRntjA==
X-Received: by 2002:a63:fc0f:0:b0:45f:88b2:1766 with SMTP id j15-20020a63fc0f000000b0045f88b21766mr12818499pgi.357.1668450182979;
        Mon, 14 Nov 2022 10:23:02 -0800 (PST)
Received: from localhost ([98.97.41.121])
        by smtp.gmail.com with ESMTPSA id ij25-20020a170902ab5900b00186f0f59d1esm7757652plb.192.2022.11.14.10.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 10:23:02 -0800 (PST)
Date:   Mon, 14 Nov 2022 10:23:00 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yonghong Song <yhs@meta.com>,
        John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
Message-ID: <63728784e2d15_43f25208be@john.notmuch>
In-Reply-To: <10b5eb96-5200-0ffe-a1ba-6d8a16ac4ebe@meta.com>
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch>
 <aeb8688f-7848-84d2-9502-fad400b1dcdc@meta.com>
 <636d82206e7c_154599208b0@john.notmuch>
 <636d853a8d59_15505d20826@john.notmuch>
 <86af974c-a970-863f-53f5-c57ebba9754e@meta.com>
 <637136faa95e5_2c136208dc@john.notmuch>
 <10b5eb96-5200-0ffe-a1ba-6d8a16ac4ebe@meta.com>
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
> On 11/13/22 10:27 AM, John Fastabend wrote:
> > Yonghong Song wrote:
> >>
> >>
> >> On 11/10/22 3:11 PM, John Fastabend wrote:
> >>> John Fastabend wrote:
> >>>> Yonghong Song wrote:
> >>>>>
> >>>>>
> >>>>> On 11/9/22 6:17 PM, John Fastabend wrote:
> >>>>>> Yonghong Song wrote:
> >>>>>>>
> >>>>>>>
> >>>>>>> On 11/9/22 1:52 PM, John Fastabend wrote:
> >>>>>>>> Allow xdp progs to read the net_device structure. Its useful to extract
> >>>>>>>> info from the dev itself. Currently, our tracing tooling uses kprobes
> >>>>>>>> to capture statistics and information about running net devices. We use
> >>>>>>>> kprobes instead of other hooks tc/xdp because we need to collect
> >>>>>>>> information about the interface not exposed through the xdp_md structures.
> >>>>>>>> This has some down sides that we want to avoid by moving these into the
> >>>>>>>> XDP hook itself. First, placing the kprobes in a generic function in
> >>>>>>>> the kernel is after XDP so we miss redirects and such done by the
> >>>>>>>> XDP networking program. And its needless overhead because we are
> >>>>>>>> already paying the cost for calling the XDP program, calling yet
> >>>>>>>> another prog is a waste. Better to do everything in one hook from
> >>>>>>>> performance side.
> >>>>>>>>
> >>>>>>>> Of course we could one-off each one of these fields, but that would
> >>>>>>>> explode the xdp_md struct and then require writing convert_ctx_access
> >>>>>>>> writers for each field. By using BTF we avoid writing field specific
> >>>>>>>> convertion logic, BTF just knows how to read the fields, we don't
> >>>>>>>> have to add many fields to xdp_md, and I don't have to get every
> >>>>>>>> field we will use in the future correct.
> >>>>>>>>
> >>>>>>>> For reference current examples in our code base use the ifindex,
> >>>>>>>> ifname, qdisc stats, net_ns fields, among others. With this
> >>>>>>>> patch we can now do the following,
> >>>>>>>>
> >>>>>>>>             dev = ctx->rx_dev;
> >>>>>>>>             net = dev->nd_net.net;
> >>>>>>>>
> >>>>>>>> 	uid.ifindex = dev->ifindex;
> >>>>>>>> 	memcpy(uid.ifname, dev->ifname, NAME);
> >>>>>>>>             if (net)
> >>>>>>>> 		uid.inum = net->ns.inum;
> >>>>>>>>
> >>>>>>>> to report the name, index and ns.inum which identifies an
> >>>>>>>> interface in our system.
> >>>>>>>
> > 
> > [...]
> > 
> >>>> Yep.
> >>>>
> >>>> I'm fine doing it with bpf_get_kern_ctx() did you want me to code it
> >>>> the rest of the way up and test it?
> >>>>
> >>>> .John
> >>>
> >>> Related I think. We also want to get kernel variable net_namespace_list,
> >>> this points to the network namespace lists. Based on above should
> >>> we do something like,
> >>>
> >>>     void *bpf_get_kern_var(enum var_id);
> >>>
> >>> then,
> >>>
> >>>     net_ns_list = bpf_get_kern_var(__btf_net_namesapce_list);
> >>>
> >>> would get us a ptr to the list? The other thought was to put it in the
> >>> xdp_md but from above seems better idea to get it through helper.
> >>
> >> Sounds great. I guess my new proposed bpf_get_kern_btf_id() kfunc could
> >> cover such a use case as well.
> > 
> > Yes I think this should be good. The only catch is that we need to
> > get the kernel global var pointer net_namespace_list.
> 
> Currently, the kernel supports percpu variable, but
> not other global var like net_namespace_list. Currently, there is
> an effort to add global var to BTF:
>  
> https://lore.kernel.org/bpf/20221104231103.752040-1-stephen.s.brennan@oracle.com/
> 
> > 
> > Then we can write iterators on network namespaces and net_devices
> > without having to do anything else. The usecase is to iterate
> > the network namespace and collect some subset of netdevices. Populate
> > a map with these and then keep it in sync from XDP with stats. We
> > already hook create/destroy paths so have built up maps that track
> > this and have some XDP stats but not everything we would want.
> 
> the net_namespace_list is defined as:
>    struct list_head net_namespace_list;
> So it is still difficult to iterate with bpf program. But we
> could have a bpf_iter (similar to task, task_file, etc.)
> for net namespaces and it can provide enough context
> for the bpf program for each namespace to satisfy your
> above need.

Considered having bpf iter programs for net_namespace and then
net_device, but these are protected by RCU so figured rather
than create a bunch of iterators we could just use BPF directly.

> 
> You can also with a bounded loop to traverse net_namespace_list
> in the bpf program, but it may incur complicated codes...

This was going to be my first approach. I'll try to write a test
program that walks the net namespace and collect all the net
devs in a hashmap this would be more or less what our programs
do today.

Seems nicer to me to simply use native BPF codes vs iterators.
We already have mechanisms in Tetragon to run BPF code on
timers so could just wire it up there. If it doesn't work 
we can add the iterators.

> 
> > 
> > The other piece I would like to get out of the xdp ctx is the
> > rx descriptor of the device. I want to use this to pull out info
> > about the received buffer for debug mostly, but could also grab
> > some fields that are useful for us to track. That we can likely
> > do this,
> > 
> >    ctx->rxdesc
> 
> I think it is possible. Adding rxdesc to xdp_buff as
>      unsigned char *rxdesc;
> or
>      void *rxdesc;
> 
> and using bpf_get_kern_btf_id(kctx->rxdesc, expected_btf_id)
> to get a btf id for rxdesc. Here we assume there is
> a struct available for rxdesc in vmlinux.h.
> Then you can trace through rxdesc with direct memory
> access.

The trickest part here is that the rxdesc btf_id depends on 
what device we are attached to. So would need something to
resolve the btf_id from attached device.

> 
> I have a RFC patch
>    https://lore.kernel.org/bpf/20221114162328.622665-1-yhs@fb.com/
> please help take a look.

Will do thanks!
