Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC37677E4E
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjAWOoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbjAWOox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:44:53 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CA49029
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:44:50 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v10so14805811edi.8
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hTniH4Dvk0yVMZYSwbLw+aiFQNH9bAZOy/N7aUDmDrI=;
        b=srnqwoMw/gTja6VsjZXrkUpFWP/J6qmlkRJ9+3BnyA0DluOJL8ioAL8ceE5AeX6rJL
         nJKEV1lFJ+Afjx0SxX+Tv/aSiL1bfuuvtVmxsZrBk1WUKlVrRTrDf+nsqWHVETU/QPbA
         JfhN2HoOpLC9wtP+Fz0XuzFgT9VIZ17d3Rz4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hTniH4Dvk0yVMZYSwbLw+aiFQNH9bAZOy/N7aUDmDrI=;
        b=1GoU5V1q1YjJeN+A56cOkARlJSwJMDFxMd3ZvIjNn/QXHTvk9xDt/xzY/n0A4/1bCy
         vt7u6Lp8BfGwcRUKhP0Bq/f6NUlyYZKnu7PeVu34tNaMn3u3WbSoqnwryUEiYSPp7ghY
         w9wgWMznfk+e2frVFdpvSv9soChT+suiTDEmoMJ3Empix7MJBLCzNuN5YudHcTc8VeEh
         X3YSbfKEPnR4eVvknr44KAvmYpRaO3l5SLsqfM5SdW5KOJdiZT09tbMn/MT3P8x70faB
         MCsdJ3lIpu3585l7GJhhJx19bAwhLF16ONiTQzCz6Tcew395CsE35acWt69KPZZdlKS1
         BiIg==
X-Gm-Message-State: AFqh2krP1O44yetjGaKIR04fu20an6c7l0b/H1c+UDmwcQrXAgozgTp3
        aRRqyk7X9XlB7I1gTltq7Yz5HA==
X-Google-Smtp-Source: AMrXdXviXFtFKl75x9pXMhixMadL8IgtaFtRCPVA9sq4aW+R0iYMh1gc87zQgViPz/Qvb8uOpnSW4g==
X-Received: by 2002:a05:6402:35c1:b0:46f:f36b:a471 with SMTP id z1-20020a05640235c100b0046ff36ba471mr35568295edc.22.1674485089264;
        Mon, 23 Jan 2023 06:44:49 -0800 (PST)
Received: from cloudflare.com (79.191.179.97.ipv4.supernova.orange.pl. [79.191.179.97])
        by smtp.gmail.com with ESMTPSA id i12-20020aa7dd0c000000b0047021294426sm21467952edv.90.2023.01.23.06.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 06:44:48 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
Subject: [PATCH net-next v4 0/2] Add IP_LOCAL_PORT_RANGE socket option
Date:   Mon, 23 Jan 2023 15:44:39 +0100
Message-Id: <20221221-sockopt-port-range-v4-0-d7d2f2561238@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFedzmMC/4WOwQ7CIBBEf8VwFgOU1tST/2E8FNi1xAoNYKMx/
 Xc3XDWa7GV2dt7si2VIHjI7bF4sweKzj4GE3m6YHYdwAe4daaaEUpKG52ivcS58jqnwVC9AauVg
 LwRqxyhohgzckGdHiob7NNFyToD+UZtOLEDhAR6FnckZfS4xPesLi6z+r7ZFcsFBGdFr0wlEd7R
 TvDuchgQ7G2+Vuaj/HEUc6VqUUhvs1P4rp/nPaYjTdDi02PZ9h/qDs67rG9pqm5RoAQAA
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Neal Cardwell <ncardwell@google.com>, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@cloudflare.com,
        Marek Majkowski <marek@cloudflare.com>
X-Mailer: b4 0.11.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is a follow up to the "How to share IPv4 addresses by
partitioning the port space" talk given at LPC 2022 [1].

Please see patch #1 for the motivation & the use case description.
Patch #2 adds tests exercising the new option in various scenarios.

Documentation
-------------

Proposed update to the ip(7) man-page:

       IP_LOCAL_PORT_RANGE (since Linux X.Y)
              Set or get the per-socket default local  port  range.  This
              option  can  be  used  to  clamp down the global local port
              range, defined by the ip_local_port_range  /proc  interface
              described below, for a given socket.

              The  option  takes  an uint32_t value with the high 16 bits
              set to the upper range bound, and the low 16  bits  set  to
              the  lower  range  bound.  Range  bounds are inclusive. The
              16-bit values should be in host byte order.

              The lower bound has to be less than the  upper  bound  when
              both  bounds  are  not  zero. Otherwise, setting the option
              fails with EINVAL.

              If either bound is outside of the global local port  range,
              or is zero, then that bound has no effect.

              To  reset  the setting, pass zero as both the upper and the
              lower bound.

Interaction with SELinux bind() hook
------------------------------------

SELinux bind() hook - selinux_socket_bind() - performs a permission check
if the requested local port number lies outside of the netns ephemeral port
range.

The proposed socket option cannot be used change the ephemeral port range
to extend beyond the per-netns port range, as set by
net.ipv4.ip_local_port_range.

Hence, there is no interaction with SELinux, AFAICT.
	      
Changelog:
---------

v3 -> v4:
v3: https://lore.kernel.org/r/20221221-sockopt-port-range-v3-0-36fa5f5996f4@cloudflare.com

 * Highlight that port bounds should be in host byte order. (Neal)

v2 -> v3:
v2: https://lore.kernel.org/r/20221221-sockopt-port-range-v2-0-1d5f114bf627@cloudflare.com

 * Describe interaction considerations with SELinux.
 * Code changes called out in individual patches.

v1 -> v2:
v1: https://lore.kernel.org/netdev/20221221-sockopt-port-range-v1-0-e2b094b60ffd@cloudflare.com/

 * Fix the corner case when the per-socket range doesn't overlap with the
   per-netns range. Fallback correctly to the per-netns range. (Kuniyuki)

 * selftests: Instead of iterating over socket families (ip4, ip6) and types
   (tcp, udp), generate tests for each combo from a template. This keeps the
   code indentation level down and makes tests more granular.

 * Rewrite man-page prose:
   - explain how to unset the option,
   - document when EINVAL is returned.

RFC -> v1
RFC: https://lore.kernel.org/netdev/20220912225308.93659-1-jakub@cloudflare.com/

 * Allow either the high bound or the low bound, or both, to be zero
 * Add getsockopt support
 * Add selftests

Links:
------

[1]: https://lpc.events/event/16/contributions/1349/

To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: selinux@vger.kernel.org
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: kernel-team@cloudflare.com
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

---
Jakub Sitnicki (2):
      inet: Add IP_LOCAL_PORT_RANGE socket option
      selftests/net: Cover the IP_LOCAL_PORT_RANGE socket option

 include/net/inet_sock.h                            |   4 +
 include/net/ip.h                                   |   3 +-
 include/uapi/linux/in.h                            |   1 +
 net/ipv4/inet_connection_sock.c                    |  25 +-
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/ip_sockglue.c                             |  18 +
 net/ipv4/udp.c                                     |   2 +-
 net/sctp/socket.c                                  |   2 +-
 tools/testing/selftests/net/Makefile               |   2 +
 tools/testing/selftests/net/ip_local_port_range.c  | 447 +++++++++++++++++++++
 tools/testing/selftests/net/ip_local_port_range.sh |   5 +
 11 files changed, 505 insertions(+), 6 deletions(-)
