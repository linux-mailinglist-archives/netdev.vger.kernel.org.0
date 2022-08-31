Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E9A5A835A
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 18:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiHaQiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 12:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbiHaQh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 12:37:57 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852E0DA3C7;
        Wed, 31 Aug 2022 09:37:53 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q3so11415651pjg.3;
        Wed, 31 Aug 2022 09:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=NxmVqrM5Pi+9e/Cy40Ct9E7XOe5hUefDDxXAYP1Q9WY=;
        b=mqU+H3HUpS8oCwn7epXyCoEQ6szwL9gvMfKCVEkq4L3ESljz7KffQReRkvxK93NR8j
         Q0qwddEZJqRfiwYMKKSRUzVJzJ91OMlApc+RX7piGJzQQn1WvYipY+7W06vFerOTAhuU
         wxZ1V7sJhIXbXCxmmW9DaWmx7Hw25Mn+Kr5VPJ+APvCebK9Ame+ze34g/zijpQRQZphu
         qFD7ctq2C4Rr8qq7zOFC/ECW6438QUJaFRX3rrX9YYOFlk0EuW3xSzYrJJ1yD8D3GDK5
         6y2rCdqMHl+lYTTSBkcTTKIGQHSP8lC1+gejoE7RjuDAcKZIHy44mIWELmnbJ79jz/28
         PAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=NxmVqrM5Pi+9e/Cy40Ct9E7XOe5hUefDDxXAYP1Q9WY=;
        b=lY+UXjUpiJgY9vTLUC6sWNfyj/FGgXZDiXJTFnp/eivqiGHfVc6iW6He+HrmwVgayP
         bNT20At26elGTmrwPQW/cpeuE+RUTi3g3VtU6PrOxn4X9rQmRloW/byhsMvjNbzgPkzC
         vx5l6eFTKweJBv7RdNXZJz/0HeTOlg9mhP4DLNMLfRTW+yP3yS2VnTXBVtrrbxhvQdhb
         9tq9DTrxVaFffZcLjwf8bitx5Ai1s3tUc/qSLBI01deFPxNjWgUbAw3DTi88o9P2FqYQ
         hafw/8uFymWiKoW+72BrXcUBQQVazcWBRfwAt52HqLwtosG2DTwfxPFWrifQxisEPcZH
         8ogA==
X-Gm-Message-State: ACgBeo0pEuTTMfvnRIv3gVO7/td6aP7d89h/5vSCc2LEL/8roKMfjYEw
        JLMoSPG1AKAq5+HtjCwWeWnWmYE/BIqQckaoEVV6QTUXWwI=
X-Google-Smtp-Source: AA6agR4P0B+0OMM52ivNRVaRqVcQoOmziUqLK/uQTbBZGvxGx8UF5ww4jJ/tamjcKwwOX40F60V4J76an5P3jy2Ui9s=
X-Received: by 2002:a17:90b:3511:b0:1f4:e0cd:1e04 with SMTP id
 ls17-20020a17090b351100b001f4e0cd1e04mr4241129pjb.154.1661963872120; Wed, 31
 Aug 2022 09:37:52 -0700 (PDT)
MIME-Version: 1.0
From:   Aditi Ghag <aditivghag@gmail.com>
Date:   Wed, 31 Aug 2022 09:37:41 -0700
Message-ID: <CABG=zsBEh-P4NXk23eBJw7eajB5YJeRS7oPXnTAzs=yob4EMoQ@mail.gmail.com>
Subject: [RFC] Socket termination for policy enforcement and load-balancing
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an RFC for terminating sockets with intent. We have two
prominent use cases in Cilium [1] where we need a way to identify and
forcefully terminate a set of sockets so that they can reconnect.
Cilium uses eBPF cgroup hooks for load-balancing, where it translates
a service vip to one of the service backend ip addresses at socket
connect time for TCP and connected UDP. Client applications are likely
to be unaware of the remote containers that they are connected to
getting deleted, and are left hanging when the remotes go away
(long-running UDP applications, particularly). For the policy
enforcement use case, users may want to enforce policies on-the-fly
where they want all client applications traffic including established
connections to be redirected to a subset of destinations.

We evaluated following ways to identify, and forcefully terminate sockets:

- The sock_destroy API added for similar Android use cases is
effective in tearing down sockets. The API is behind the
CONFIG_INET_DIAG_DESTROY config that's disabled by default, and
currently exposed via SOCK_DIAG netlink infrastructure in userspace.
The sock destroy handlers for TCP and UDP protocols send ECONNABORTED
error code to sockets related to the abort state as mentioned in RFC
793.

- Add unreachable routes for deleted backends. I experimented with
this approach with my colleague, Nikolay Aleksandrov. We found that
TCP and connected UDP sockets in the established state simply ignore
the ICMP error messages, and continue to send data in the presence of
such routes. My read is that applications are ignoring the ICMP errors
reported on sockets [2].

- Use BPF (sockets) iterator to identify sockets connected to a
deleted backend. The BPF (sockets) iterator is network namespace aware
so we'll either need to enter every possible container network
namespace to identify the affected connections, or adapt the iterator
to be without netns checks [3]. This was discussed with my colleague
Daniel Borkmann based on the feedback he shared from the LSFMMBPF
conference discussions.

- Use INET_DIAG infrastructure to filter and destroy sockets connected
to stale backends. This approach involves first making a query to
filter sockets connecting to a destination ip address/port using
netlink messages with type SOCK_DIAG_BY_FAMILY, and then use the query
results to make another message of type SOCK_DESTROY to actually
destroy the sockets. The SOCK_DIAG infrastructure, similar to BPF
iterators, is network namespace aware.

We are currently leaning towards invoking the sock_destroy API
directly from BPF programs. This allows us to have an effective
mechanism without having to enter every possible container network
namespace on a node, and rely on the CONFIG_INET_DIAG_DESTROY config
with the right permissions. BPF programs attached to cgroup hooks can
store client sockets connected to a backend, and invoke destroy APIs
when backends are deleted.

To that end, I'm in the process of adding a new BPF helper for the
sock_destroy kernel function similar to the sock_diag_destroy function
[4], and am soliciting early feedback on the evaluated and selected
approaches. Happy to share more context.

[1] https://github.com/cilium/cilium
[2] https://github.com/torvalds/linux/blob/master/net/ipv4/tcp_ipv4.c#L464
[3] https://github.com/torvalds/linux/blob/master/net/ipv4/udp.c#L3011
[4] https://github.com/torvalds/linux/blob/master/net/core/sock_diag.c#L298
