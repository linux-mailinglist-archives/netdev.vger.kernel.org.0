Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DAD5A88BA
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiHaWCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiHaWCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:02:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315CDD4F79
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:02:11 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j192-20020a638bc9000000b0042b23090b15so7505398pge.16
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=r9j9UaaDE9X/fY022QlBZ5udCV7NoZgyGORt+9AxKm0=;
        b=Y/1MS+x26c6iPkEkuv0QMTJorex6WIyuyWIiBPEAMsuUvgYO8C1+JHOmQ8X/NlbOV0
         1rsYQT5EKz8nj0Y9adeen0XCiMeU83iHpIGCtHf7EcuP6LR+LyGfMZzcuxRWmT8KO6Sg
         P3YirDsxLGB188mIeXn92fw45m4toftVW8Rw0MoRcQ37XFt9ExyPF/p6dy2ODdJxbJaw
         Up75/dGHEaAeKWUj2+onPosc8XjhcXU0rCOWHZ+W8ZJnLxIjo+Fea2xZjk3ypF6HCLxW
         SFyvG1pS5iXLOLXi4j+ez8jx2yA03P3pBNuCwpRfNculrm4+vsHLoESmPU0Ho8dhFO4o
         jICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=r9j9UaaDE9X/fY022QlBZ5udCV7NoZgyGORt+9AxKm0=;
        b=xTYimSJpUxOvyQ0XS1jB6aTUkUDY2Gi8T6KEsUdRKxFPwuLrW0UoGlIvPE+qENzOyK
         LpPkAAW2YjJzM0gfSnZA9TE1Mdx6RihWm1IdLO228Ky+eXePaxyahk+JM6WhU1uyj3Yw
         ZRw75wwZkyv4bE77XQ6MFH1PcX+4cSHpjXTXOc/e8Cb8VXxNemndHJODiubXgVCo1lBU
         QBKMeVCaneiNgjYdYLvU0E8rEzv27zTHgeXop5yl3+vkC3PEg116c3gSdA3gRAE9FCr2
         zepecl6KX5r+x3fNYC+jv6/LwYUMgOVZlYdLw3DfFcfkUIObyVA8SSTvJE0hZwM6dgJA
         H4og==
X-Gm-Message-State: ACgBeo3RNMzv08kfSCsHvVeCAgqfI9QX77dKnJ/ik6XYVf+ZH1X2CICY
        6Et/xZ54aDl927a9aRlesPI2rEY=
X-Google-Smtp-Source: AA6agR49drocjZ0i2QppRHAYciWa4wRqWZV+P2gTJMtFvBQ+0bmrqsnZM1oN5+OWxpO6NHX/hEUf40E=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr309305pje.0.1661983330118; Wed, 31 Aug
 2022 15:02:10 -0700 (PDT)
Date:   Wed, 31 Aug 2022 15:02:08 -0700
In-Reply-To: <CABG=zsBEh-P4NXk23eBJw7eajB5YJeRS7oPXnTAzs=yob4EMoQ@mail.gmail.com>
Mime-Version: 1.0
References: <CABG=zsBEh-P4NXk23eBJw7eajB5YJeRS7oPXnTAzs=yob4EMoQ@mail.gmail.com>
Message-ID: <Yw/aYIR3mBABN75G@google.com>
Subject: Re: [RFC] Socket termination for policy enforcement and load-balancing
From:   sdf@google.com
To:     Aditi Ghag <aditivghag@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/31, Aditi Ghag wrote:
> This is an RFC for terminating sockets with intent. We have two
> prominent use cases in Cilium [1] where we need a way to identify and
> forcefully terminate a set of sockets so that they can reconnect.
> Cilium uses eBPF cgroup hooks for load-balancing, where it translates
> a service vip to one of the service backend ip addresses at socket
> connect time for TCP and connected UDP. Client applications are likely
> to be unaware of the remote containers that they are connected to
> getting deleted, and are left hanging when the remotes go away
> (long-running UDP applications, particularly). For the policy
> enforcement use case, users may want to enforce policies on-the-fly
> where they want all client applications traffic including established
> connections to be redirected to a subset of destinations.

> We evaluated following ways to identify, and forcefully terminate sockets:

> - The sock_destroy API added for similar Android use cases is
> effective in tearing down sockets. The API is behind the
> CONFIG_INET_DIAG_DESTROY config that's disabled by default, and
> currently exposed via SOCK_DIAG netlink infrastructure in userspace.
> The sock destroy handlers for TCP and UDP protocols send ECONNABORTED
> error code to sockets related to the abort state as mentioned in RFC
> 793.

> - Add unreachable routes for deleted backends. I experimented with
> this approach with my colleague, Nikolay Aleksandrov. We found that
> TCP and connected UDP sockets in the established state simply ignore
> the ICMP error messages, and continue to send data in the presence of
> such routes. My read is that applications are ignoring the ICMP errors
> reported on sockets [2].

[..]

> - Use BPF (sockets) iterator to identify sockets connected to a
> deleted backend. The BPF (sockets) iterator is network namespace aware
> so we'll either need to enter every possible container network
> namespace to identify the affected connections, or adapt the iterator
> to be without netns checks [3]. This was discussed with my colleague
> Daniel Borkmann based on the feedback he shared from the LSFMMBPF
> conference discussions.

Maybe something worth fixing as well even if you end up using netlink?
Having to manually go over all networking namespaces (if I want
to iterate over all sockets on the host) doesn't seem feasible?

> - Use INET_DIAG infrastructure to filter and destroy sockets connected
> to stale backends. This approach involves first making a query to
> filter sockets connecting to a destination ip address/port using
> netlink messages with type SOCK_DIAG_BY_FAMILY, and then use the query
> results to make another message of type SOCK_DESTROY to actually
> destroy the sockets. The SOCK_DIAG infrastructure, similar to BPF
> iterators, is network namespace aware.

> We are currently leaning towards invoking the sock_destroy API
> directly from BPF programs. This allows us to have an effective
> mechanism without having to enter every possible container network
> namespace on a node, and rely on the CONFIG_INET_DIAG_DESTROY config
> with the right permissions. BPF programs attached to cgroup hooks can
> store client sockets connected to a backend, and invoke destroy APIs
> when backends are deleted.

> To that end, I'm in the process of adding a new BPF helper for the
> sock_destroy kernel function similar to the sock_diag_destroy function
> [4], and am soliciting early feedback on the evaluated and selected
> approaches. Happy to share more context.

> [1] https://github.com/cilium/cilium
> [2] https://github.com/torvalds/linux/blob/master/net/ipv4/tcp_ipv4.c#L464
> [3] https://github.com/torvalds/linux/blob/master/net/ipv4/udp.c#L3011
> [4]  
> https://github.com/torvalds/linux/blob/master/net/core/sock_diag.c#L298
