Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253E26A27ED
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 09:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjBYInR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 03:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBYInQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 03:43:16 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F49A158A0;
        Sat, 25 Feb 2023 00:43:14 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id l2-20020a05600c1d0200b003e1f6dff952so3882550wms.1;
        Sat, 25 Feb 2023 00:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UYNNVzYW2O2399EmY6tjSEr/i01X8SqBEP+DZYUA2aA=;
        b=Zr8gtb9c5UC9iEggiLc1zCtqleZojI3ZJ5PwbMBQG3dSicQwQyzFfI7cejYV/1DWI0
         z220MEc9kil7Hf0/AppEnQ1y6RKGwoa/cnypPqs/lKNi4gAVRaaK2WI8NADZ82JJPf4o
         Ka6hX5eVMyRIAI1CcDtiacNXUI/RoREdPPkBtncOKs0JUe8G76aWmQ8FqX/oroL+U3fx
         KEpuOsXZGj02czv9BDUDWsMQ9ly4Ai06FoAMhvJJ0EEMJ8yVXMux/5dYPPYdhiyKiZDd
         5MI4r5541DrZPOP812cqE7nNB9LyL+99NJt3WPYThvJ44kpfMHXXbVIQ8mPry1G7Adcy
         Wjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UYNNVzYW2O2399EmY6tjSEr/i01X8SqBEP+DZYUA2aA=;
        b=XO1JhTZmCJnt3D7hVX/2IhVIDwSFS8QAe9hV+IDjZb1EQzrVJ/OibiPLtBnmXd91Tg
         NBuky786koeZ1H8v5XMVSjG0sUNCsjCmeOG2+OzYLJhReiHosRSGxx+IjcENiQOCCS9a
         d6IE6bOWxvJ0h0sOM5CFTRGcFOgcxnWa7q0LWhmHJFFg6BBW1dUBeD+2AhJMeeTGev5N
         gnrsHex8Qm5G8HgVNj+yj3VO2GhB8oEikgFFLZFGYKi3u+BOyCZoMhPnVj0fUNKGr89A
         mUmJn84r8rgFgKe6iM4S13d1uhYp0uf20QwrNcoIPP6En7UoQQcAvCKKBMn/t63rp72v
         lXIg==
X-Gm-Message-State: AO0yUKWrfOWW41HCSWSLKt06CxCwT3xh2BT1NWmd7zfOPNSXzLLumblM
        RzXMKjTiM8b583iiD8favNWyTWgR3AbGKbIrjFA=
X-Google-Smtp-Source: AK7set9OuOCog2dYqDNzEBPnMi8kQ2C8kOyyLYCNMrjQ/CDVo9KpMt+WdHhw6B53Tw2NnWEEqymAiQIb3EBKPXNkRLs=
X-Received: by 2002:a05:600c:3b8d:b0:3df:97de:8bae with SMTP id
 n13-20020a05600c3b8d00b003df97de8baemr1942528wms.7.1677314592709; Sat, 25 Feb
 2023 00:43:12 -0800 (PST)
MIME-Version: 1.0
References: <20230214060634.427162-1-yanjun.zhu@intel.com> <0f33e8d9-1643-25bf-d508-692c628c381b@linux.dev>
In-Reply-To: <0f33e8d9-1643-25bf-d508-692c628c381b@linux.dev>
From:   Rain River <rain.1986.08.12@gmail.com>
Date:   Sat, 25 Feb 2023 16:43:04 +0800
Message-ID: <CAJr_XRAkisMbwKn1Bw7TQ45ze+PqC3BOzbOHddP8WT5pCBToUQ@mail.gmail.com>
Subject: Re: [PATCHv3 0/8] Fix the problem that rxe can not work in net namespace
To:     Zhu Yanjun <yanjun.zhu@linux.dev>
Cc:     Zhu Yanjun <yanjun.zhu@intel.com>, jgg@ziepe.ca, leon@kernel.org,
        zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, parav@nvidia.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 8:37 AM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
>
> =E5=9C=A8 2023/2/14 14:06, Zhu Yanjun =E5=86=99=E9=81=93:
> > From: Zhu Yanjun <yanjun.zhu@linux.dev>
> >
> > When run "ip link add" command to add a rxe rdma link in a net
> > namespace, normally this rxe rdma link can not work in a net
> > name space.
> >
> > The root cause is that a sock listening on udp port 4791 is created
> > in init_net when the rdma_rxe module is loaded into kernel. That is,
> > the sock listening on udp port 4791 is created in init_net. Other net
> > namespace is difficult to use this sock.
> >
> > The following commits will solve this problem.
> >
> > In the first commit, move the creating sock listening on udp port 4791
> > from module_init function to rdma link creating functions. That is,
> > after the module rdma_rxe is loaded, the sock will not be created.
> > When run "rdma link add ..." command, the sock will be created. So
> > when creating a rdma link in the net namespace, the sock will be
> > created in this net namespace.
> >
> > In the second commit, the functions udp4_lib_lookup and udp6_lib_lookup
> > will check the sock exists in the net namespace or not. If yes, rdma
> > link will increase the reference count of this sock, then continue othe=
r
> > jobs instead of creating a new sock to listen on udp port 4791. Since t=
he
> > network notifier is global, when the module rdma_rxe is loaded, this
> > notifier will be registered.
> >
> > After the rdma link is created, the command "rdma link del" is to
> > delete rdma link at the same time the sock is checked. If the reference
> > count of this sock is greater than the sock reference count needed by
> > udp tunnel, the sock reference count is decreased by one. If equal, it
> > indicates that this rdma link is the last one. As such, the udp tunnel
> > is shut down and the sock is closed. The above work should be
> > implemented in linkdel function. But currently no dellink function in
> > rxe. So the 3rd commit addes dellink function pointer. And the 4th
> > commit implements the dellink function in rxe.
> >
> > To now, it is not necessary to keep a global variable to store the sock
> > listening udp port 4791. This global variable can be replaced by the
> > functions udp4_lib_lookup and udp6_lib_lookup totally. Because the
> > function udp6_lib_lookup is in the fast path, a member variable l_sk6
> > is added to store the sock. If l_sk6 is NULL, udp6_lib_lookup is called
> > to lookup the sock, then the sock is stored in l_sk6, in the future,it
> > can be used directly.
> >
> > All the above work has been done in init_net. And it can also work in
> > the net namespace. So the init_net is replaced by the individual net
> > namespace. This is what the 6th commit does. Because rxe device is
> > dependent on the net device and the sock listening on udp port 4791,
> > every rxe device is in exclusive mode in the individual net namespace.
> > Other rdma netns operations will be considerred in the future.
> >
> > In the 7th commit, the register_pernet_subsys/unregister_pernet_subsys
> > functions are added. When a new net namespace is created, the init
> > function will initialize the sk4 and sk6 socks. Then the 2 socks will
> > be released when the net namespace is destroyed. The functions
> > rxe_ns_pernet_sk4/rxe_ns_pernet_set_sk4 will get and set sk4 in the net
> > namespace. The functions rxe_ns_pernet_sk6/rxe_ns_pernet_set_sk6 will
> > handle sk6. Then sk4 and sk6 are used in the previous commits.
> >
> > As the sk4 and sk6 in pernet namespace can be accessed, it is not
> > necessary to add a new l_sk6. As such, in the 8th commit, the l_sk6 is
> > replaced with the sk6 in pernet namespace.
> >
> > Test steps:
> > 1) Suppose that 2 NICs are in 2 different net namespaces.
> >
> >    # ip netns exec net0 ip link
> >    3: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state U=
P
> >       link/ether 00:1e:67:a0:22:3f brd ff:ff:ff:ff:ff:ff
> >       altname enp5s0
> >
> >    # ip netns exec net1 ip link
> >    4: eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel
> >       link/ether f8:e4:3b:3b:e4:10 brd ff:ff:ff:ff:ff:ff
> >
> > 2) Add rdma link in the different net namespace
> >      net0:
> >      # ip netns exec net0 rdma link add rxe0 type rxe netdev eno2
> >
> >      net1:
> >      # ip netns exec net1 rdma link add rxe1 type rxe netdev eno3
> >
> > 3) Run rping test.
> >      net0
> >      # ip netns exec net0 rping -s -a 192.168.2.1 -C 1&
> >      [1] 1737
> >      # ip netns exec net1 rping -c -a 192.168.2.1 -d -v -C 1
> >      verbose
> >      count 1
> >      ...
> >      ping data: rdma-ping-0: ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghij=
klmnopqr
> >      ...
> >
> > 4) Remove the rdma links from the net namespaces.
> >      net0:
> >      # ip netns exec net0 ss -lu
> >      State     Recv-Q    Send-Q    Local Address:Port    Peer Address:P=
ort    Process
> >      UNCONN    0         0         0.0.0.0:4791          0.0.0.0:*
> >      UNCONN    0         0         [::]:4791             [::]:*
> >
> >      # ip netns exec net0 rdma link del rxe0
> >
> >      # ip netns exec net0 ss -lu
> >      State     Recv-Q    Send-Q    Local Address:Port    Peer Address:P=
ort    Process
> >
> >      net1:
> >      # ip netns exec net0 ss -lu
> >      State     Recv-Q    Send-Q    Local Address:Port    Peer Address:P=
ort    Process
> >      UNCONN    0         0         0.0.0.0:4791          0.0.0.0:*
> >      UNCONN    0         0         [::]:4791             [::]:*
> >
> >      # ip netns exec net1 rdma link del rxe1
> >
> >      # ip netns exec net0 ss -lu
> >      State     Recv-Q    Send-Q    Local Address:Port    Peer Address:P=
ort    Process
> >
> > V2->V3: 1) Add "rdma link del" example in the cover letter, and use "ss=
 -lu" to
> >             verify rdma link is removed.
> >          2) Add register_pernet_subsys/unregister_pernet_subsys net nam=
espace
> >          3) Replace l_sk6 with sk6 of pernet_name_space

Thanks,

Tested-by: Rain River <rain.1986.08.12@gmail.com>

> >
> > V1->V2: Add the explicit initialization of sk6.
>
> Add netdev@vger.kernel.org.
>
> Zhu Yanjun
>
> >
> > Zhu Yanjun (8):
> >    RDMA/rxe: Creating listening sock in newlink function
> >    RDMA/rxe: Support more rdma links in init_net
> >    RDMA/nldev: Add dellink function pointer
> >    RDMA/rxe: Implement dellink in rxe
> >    RDMA/rxe: Replace global variable with sock lookup functions
> >    RDMA/rxe: add the support of net namespace
> >    RDMA/rxe: Add the support of net namespace notifier
> >    RDMA/rxe: Replace l_sk6 with sk6 in net namespace
> >
> >   drivers/infiniband/core/nldev.c     |   6 ++
> >   drivers/infiniband/sw/rxe/Makefile  |   3 +-
> >   drivers/infiniband/sw/rxe/rxe.c     |  35 +++++++-
> >   drivers/infiniband/sw/rxe/rxe_net.c | 113 +++++++++++++++++-------
> >   drivers/infiniband/sw/rxe/rxe_net.h |   9 +-
> >   drivers/infiniband/sw/rxe/rxe_ns.c  | 128 +++++++++++++++++++++++++++=
+
> >   drivers/infiniband/sw/rxe/rxe_ns.h  |  11 +++
> >   include/rdma/rdma_netlink.h         |   2 +
> >   8 files changed, 267 insertions(+), 40 deletions(-)
> >   create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.c
> >   create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.h
> >
>
