Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE846116B6
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiJ1QB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiJ1P7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 11:59:24 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A734214676;
        Fri, 28 Oct 2022 08:58:21 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id j12so5204888plj.5;
        Fri, 28 Oct 2022 08:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPod5ndPOv0oSFct3GyH+g0wky70ySwoeB7HbqNiQI0=;
        b=OXGUih7t0uIroLzyvHKvhRDVpUTuY//XQGG3v9fQRpMoHLXYOb46RoxBbF4CGSMyHq
         0THHhO1NfVvDQoQAUePDX2lyFzJCv9Yna4n7ItsTH6H6w4fIcKIvEAC7ZFUa8YrQV+WF
         vohBojbVnrfk+r3w1YSpfhDoz2XKBpaC28KEfsfwg4bWDVuYImQGXgJH1wE//Xr04eY7
         Nzhtwcisb03EPEScnqDnpbDyZxSVQwYn5jDsiOrqys6GoLfItrL5NafcflIuNXkYnrk0
         SM71sUNZcrnV12jFFXhHQ05wuWaF6rMJYmti+iYkjYSFoJeyIC2XNWSLTy9Dt0He3eOj
         QPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VPod5ndPOv0oSFct3GyH+g0wky70ySwoeB7HbqNiQI0=;
        b=qknq88pEiLBcQfRoN5IPeYnBgrwPq+xdqbYcN8FRBKEl5GjkiM0Z+Ornde51Jvx2eu
         MEK/XRIq/46KKi0ZjBg99lMCygJgelk0iXjjoLLIysnx7EefX0tXOXqhM6BlMRwJaGeH
         ZNKqrD5nbChwz+iZys8JIKn3QvHtPTPukpVmYuvcq/4Cct29WRNfRjV6YRnKvaieI/nA
         FSnkYW36AcwJuRO5qzymSYqSCgQh250mBlLdCWM4h+/B4Z8awOqyeVTpX/nVAWw5yO5I
         AquZIAGpJTkTjQmFkHNrbUetIaxXHCCUcB4S2b9uNPOuMDlDpE2n4c0xnlaY/WDYSOP3
         MY+g==
X-Gm-Message-State: ACrzQf0uU3mtnJxXN6PLRJ+N1TQO8/OGiTH6A+mn/xt7Lvs23x7XJdCC
        lmodXM97q9LnSioQ06QHlzE=
X-Google-Smtp-Source: AMsMyM6HnJcalWdNuY759SOZt5tYWP0UjYWa4m8USb7xqZQJFxCcswvx6jtdSWka9f6kCXZ3OZjUaQ==
X-Received: by 2002:a17:90b:1d90:b0:213:26f1:87a9 with SMTP id pf16-20020a17090b1d9000b0021326f187a9mr17084346pjb.103.1666972701400;
        Fri, 28 Oct 2022 08:58:21 -0700 (PDT)
Received: from localhost ([98.97.41.13])
        by smtp.gmail.com with ESMTPSA id w35-20020a631623000000b00462ae17a1c4sm2904482pgl.33.2022.10.28.08.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 08:58:20 -0700 (PDT)
Date:   Fri, 28 Oct 2022 08:58:18 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Message-ID: <635bfc1a7c351_256e2082f@john.notmuch>
In-Reply-To: <20221027200019.4106375-1-sdf@google.com>
References: <20221027200019.4106375-1-sdf@google.com>
Subject: RE: [RFC bpf-next 0/5] xdp: hints via kfuncs
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
> This is an RFC for the alternative approach suggested by Martin and
> Jakub. I've tried to CC most of the people from the original discussion,
> feel free to add more if you think I've missed somebody.
> 
> Summary:
> - add new BPF_F_XDP_HAS_METADATA program flag and abuse
>   attr->prog_ifindex to pass target device ifindex at load time
> - at load time, find appropriate ndo_unroll_kfunc and call
>   it to unroll/inline kfuncs; kfuncs have the default "safe"
>   implementation if unrolling is not supported by a particular
>   device
> - rewrite xskxceiver test to use C bpf program and extend
>   it to export rx_timestamp (plus add rx timestamp to veth driver)
> 
> I've intentionally kept it small and hacky to see whether the approach is
> workable or not.

Hi,

I need RX timestamps now as well so was going to work on some code
next week as well.

My plan was to simply put a kptr to the rx descriptor in the xdp
buffer. If I can read the rx descriptor I can read the timestamp,
the rxhash and any other metadata the NIC has completed. All the
drivers I've looked at stash the data here.

I'll inline pro/cons compared to this below as I see it.

> 
> Pros:
> - we avoid BTF complexity; the BPF programs themselves are now responsible
>   for agreeing on the metadata layout with the AF_XDP consumer

Same no BTF is needed in kernel side. Userspace and BPF progs get
to sort it out.

> - the metadata is free if not used

Same.

> - the metadata should, in theory, be cheap if used; kfuncs should be
>   unrolled to the same code as if the metadata was pre-populated and
>   passed with a BTF id

Same its just a kptr at this point. Also one more advantage would
be ability to read the data without copying it.

> - it's not all or nothing; users can use small subset of metadata which
>   is more efficient than the BTF id approach where all metadata has to be
>   exposed for every frame (and selectively consumed by the users)

Same.

> 
> Cons:
> - forwarding has to be handled explicitly; the BPF programs have to
>   agree on the metadata layout (IOW, the forwarding program
>   has to be aware of the final AF_XDP consumer metadata layout)

Same although IMO this is a PRO. You only get the bytes you need
and care about and can also augment it with extra good stuff so
calculation only happen once.

> - TX picture is not clear; but it's not clear with BTF ids as well;
>   I think we've agreed that just reusing whatever we have at RX
>   won't fly at TX; seems like TX XDP program might be the answer
>   here? (with a set of another tx kfuncs to "expose" bpf/af_xdp metatata
>   back into the kernel)


Agree TX is not addressed.


A bit of extra commentary. By exposing the raw kptr to the rx
descriptor we don't need driver writers to do anything. And
can easily support all the drivers out the gate with simple
one or two line changes. This pushes the interesting parts
into userspace and then BPF writers get to do the work without
bother driver folks and also if its not done today it doesn't
matter because user space can come along and make it work
later. So no scattered kernel dependencies which I really
would like to avoid here. Its actually very painful to have
to support clusters with N kernels and M devices if they
have different features. Doable but annoying and much nicer
if we just say 6.2 has support for kptr rx descriptor reading
and all XDP drivers support it. So timestamp, rxhash work
across the board.

To find the offset of fields (rxhash, timestamp) you can use
standard BTF relocations we have all this machinery built up
already for all the other structs we read, net_devices, task
structs, inodes, ... so its not a big hurdle at all IMO. We
can add userspace libs if folks really care, but its just
a read so I'm not even sure that is helpful.

I think its nicer than having kfuncs that need to be written
everywhere. My $.02 although I'll poke around with below
some as well. Feel free to just hang tight until I have some
code at the moment I have intel, mellanox drivers that I
would want to support.

> 
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> 
> Stanislav Fomichev (5):
>   bpf: Support inlined/unrolled kfuncs for xdp metadata
>   veth: Support rx timestamp metadata for xdp
>   libbpf: Pass prog_ifindex via bpf_object_open_opts
>   selftests/bpf: Convert xskxceiver to use custom program
>   selftests/bpf: Test rx_timestamp metadata in xskxceiver
> 
>  drivers/net/veth.c                            |  31 +++++
>  include/linux/bpf.h                           |   1 +
>  include/linux/btf.h                           |   1 +
>  include/linux/btf_ids.h                       |   4 +
>  include/linux/netdevice.h                     |   3 +
>  include/net/xdp.h                             |  22 ++++
>  include/uapi/linux/bpf.h                      |   5 +
>  kernel/bpf/syscall.c                          |  28 ++++-
>  kernel/bpf/verifier.c                         |  60 +++++++++
>  net/core/dev.c                                |   7 ++
>  net/core/xdp.c                                |  28 +++++
>  tools/include/uapi/linux/bpf.h                |   5 +
>  tools/lib/bpf/libbpf.c                        |   1 +
>  tools/lib/bpf/libbpf.h                        |   6 +-
>  tools/testing/selftests/bpf/Makefile          |   1 +
>  .../testing/selftests/bpf/progs/xskxceiver.c  |  43 +++++++
>  tools/testing/selftests/bpf/xskxceiver.c      | 119 +++++++++++++++---
>  tools/testing/selftests/bpf/xskxceiver.h      |   5 +-
>  18 files changed, 348 insertions(+), 22 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/xskxceiver.c
> 
> -- 
> 2.38.1.273.g43a17bfeac-goog
> 


