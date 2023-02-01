Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5647F686228
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 09:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjBAIyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 03:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjBAIx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 03:53:59 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19D4460BA
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 00:53:57 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-4c24993965eso236428057b3.12
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 00:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HEmX5LD5z0Y0GbXo7MnSx8fsMfwqIdYBMkU3M2NcK7U=;
        b=om0EFiNbaoJyZrynvROQUhNzN4pxsZn/Crn8QkHK5UxDFcScXrvASeawdq0NO1fmmx
         8tzG01TBXc7PmstieHk3SK0dAozz82rCTIC2mrp5H37Qz9+VjwjY/Zw+fWJTQfy6RxWU
         oFJ3urjvB97bTjzs705ID0/EePgxuv+JgYOjtk/w4Rpdxh1YmX5hdlypkJfC2SLgYeqv
         fGYBrRRmAK2gHbMvVdcxcQZDT5DulV6A5MtqBQByqX++qoKma0Y4UsOd5s3WOTfcKnSz
         Z6j5sItlDG0ieMvoUUtJkO6qCRAr7g2HIEa68ZdgIwse7kWxSRX01dzSBEuuU702lGW6
         qIPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HEmX5LD5z0Y0GbXo7MnSx8fsMfwqIdYBMkU3M2NcK7U=;
        b=f+dQs2SHwVVKlisdsFSomZ5hltvhXfVfEGDYkU2rymG5/BE4wccNj/f9pnBI9J7EtN
         WC/+EvXr7Q55xebiUIeYpWJORVLvTVRu8N/yucl9kCHnO+INNBR3Ky0cXmJOsGVMAc1m
         YQSt0cQF2aVAv9slpSjCH4ucZpe1CcMdmFP2TAi//EzhDv1l6JRnBjaaQ3ZstraYvnci
         xnJ6JxNyniZm0q9vIYPUeh2pvI2EMMcX5vnvLyCPqV9Rqzy763boLRf8keA5mIxzzqii
         zEfyLa7WfCVMzu8+wuPFNRyAc12tPH50ocLKctYL0PDyxS5wzoNBRBMQtITPbHXCXZsZ
         xS2Q==
X-Gm-Message-State: AO0yUKUChEkk/UBX1sXSbPGGSeBhXYhncOXc21fiC5io5fUywskfUAHO
        anDN2n+zIimovbq2sMmYPnsLSiIO/ILJ9yVelEaVcQ==
X-Google-Smtp-Source: AK7set+w72WQ5IjTBIfvgTs9xqzu0uzQaqhVFpY9/pYsEiZFiQGbjyt+nAXeRX667iBZuTA/wKzDO5ThUv9/dM98sc0=
X-Received: by 2002:a81:ad24:0:b0:501:2069:ffb2 with SMTP id
 l36-20020a81ad24000000b005012069ffb2mr206009ywh.124.1675241636963; Wed, 01
 Feb 2023 00:53:56 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674921359.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1674921359.git.lucien.xin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Feb 2023 09:53:45 +0100
Message-ID: <CANn89i+rN=pcGquBONMruWUS8WG708rqMKD7TjS0OkBq+ev+Ew@mail.gmail.com>
Subject: Re: [PATCHv4 net-next 00/10] net: support ipv4 big tcp
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 4:58 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> This is similar to the BIG TCP patchset added by Eric for IPv6:
>
>   https://lwn.net/Articles/895398/
>
> Different from IPv6, IPv4 tot_len is 16-bit long only, and IPv4 header
> doesn't have exthdrs(options) for the BIG TCP packets' length. To make
> it simple, as David and Paolo suggested, we set IPv4 tot_len to 0 to
> indicate this might be a BIG TCP packet and use skb->len as the real
> IPv4 total length.
>
> This will work safely, as all BIG TCP packets are GSO/GRO packets and
> processed on the same host as they were created; There is no padding
> in GSO/GRO packets, and skb->len - network_offset is exactly the IPv4
> packet total length; Also, before implementing the feature, all those
> places that may get iph tot_len from BIG TCP packets are taken care
> with some new APIs:
>
> Patch 1 adds some APIs for iph tot_len setting and getting, which are
> used in all these places where IPv4 BIG TCP packets may reach in Patch
> 2-7, Patch 8 adds a GSO_TCP tp_status for af_packet users, and Patch 9
> add new netlink attributes to make IPv4 BIG TCP independent from IPv6
> BIG TCP on configuration, and Patch 10 implements this feature.
>
> Note that the similar change as in Patch 2-6 are also needed for IPv6
> BIG TCP packets, and will be addressed in another patchset.
>
> The similar performance test is done for IPv4 BIG TCP with 25Gbit NIC
> and 1.5K MTU:
>
> No BIG TCP:
> for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> 168          322          337          3776.49
> 143          236          277          4654.67
> 128          258          288          4772.83
> 171          229          278          4645.77
> 175          228          243          4678.93
> 149          239          279          4599.86
> 164          234          268          4606.94
> 155          276          289          4235.82
> 180          255          268          4418.95
> 168          241          249          4417.82
>
> Enable BIG TCP:
> ip link set dev ens1f0np0 gro_ipv4_max_size 128000 gso_ipv4_max_size 128000
> for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> 161          241          252          4821.73
> 174          205          217          5098.28
> 167          208          220          5001.43
> 164          228          249          4883.98
> 150          233          249          4914.90
> 180          233          244          4819.66
> 154          208          219          5004.92
> 157          209          247          4999.78
> 160          218          246          4842.31
> 174          206          217          5080.99
>
> Thanks for the feedback from Eric and David Ahern.
>
> v1->v2:
>   - remove the fixes and the selftest for IPv6 BIG TCP, will do it in
>     another patchset.
>   - add GSO_TCP for tp_status in packet sockets to tell the af_packet
>     users that this is a TCP GSO packet in Patch 8.
>   - also check skb_is_gso() when checking if it's a GSO TCP packet in
>     Patch 1.
> v2->v3:
>   - add gso/gro_ipv4_max_size per device and netlink attributes for them
>     in Patch 9, so that we can selectively enable BIG TCP for IPv6, and
>     not for IPv4, as Eric required.
>   - remove the selftest, as it requires userspace iproute2 change after
>     making IPv4 BIG TCP independent from IPv6 BIG TCP on configuration.
> v3->v4:
>   - put gso/gro_ipv4_max_size close to other related fields, so that we
>     do not need an extra cache line miss, as Eric suggested.
>   - also check ipv6_addr_v4mapped() when reading gso(_ipv4)_max_size in
>     sk_setup_caps(), as Eric noticed.

For the series:

Reviewed-by: Eric Dumazet <edumazet@google.com>

Please make sure to add needed changes to tcpdump/libpcap
