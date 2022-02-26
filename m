Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDD44C53A8
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 05:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiBZEUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 23:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiBZEUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 23:20:04 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E26B21F5F7;
        Fri, 25 Feb 2022 20:19:31 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id q8-20020a17090a178800b001bc299b8de1so6633629pja.1;
        Fri, 25 Feb 2022 20:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XBc42KiEH0ZqSsAnd5QTMSEnqgbSPHQ0VDRmghw+J9o=;
        b=BeabZG0azwuXZL6CcAlHLcXzHMy+RuDYRXcv2gc7Omw/jDHi5JEZVVeybXmH0ka3ty
         RHEOruSQEu0AjfHtak/OZVfDHsl11bOFhTRDmQEgyS5yeK1c65YAnMiY1Bg6wWWgwFLI
         qvDvs9Ow1V0FojK7YDzgIfxL/0OAfCeUqIlIGcPs8ng2Cl/+kUf/tXyJ7HbZia41Z/WH
         1ezmXR0zXSY9zN6QDBWAdHX2waQfFbDKYArRQdU//gAm3mkM0cgDEoJcH7sfkAVWrYoA
         YNeMgVfyXnQj1t8vOlS8RKP5YYvjAlOpBnbteIfMkhndc20as7dg8jWjkq4TBjemOBBg
         +vmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XBc42KiEH0ZqSsAnd5QTMSEnqgbSPHQ0VDRmghw+J9o=;
        b=3ofcGG1o9SpFjX3QslETHNZkm3lxbKW2EijBRWb671vOSPV35uddq6nuVLcx0KoHiL
         a9o0UGuJGK3uGmstA0yfeKVmWb7nRqBqc+PUfeadvDSy8yJwVhUTzAl4pzi5TjW5KGsm
         pD9DC8/xM+h9vC0k+pswyjD5GVc6Xw2CXmMQZX0ahpaAE8W9nXGQqWIPhbi+wAK0ImJa
         id7ZWpvj1qC9AXZW5K/kM2n9lV6sOeJmR1z6DJ/Fgq+Q9L31UiNekqSFbE7JPrqSrhxs
         tKF9yCCeV0f5COzC1DHRJIPJyN8P6p70+DmX/Sha0FNlMDaMfg9c8cLK5pRlFl9CgDvj
         xfYA==
X-Gm-Message-State: AOAM531v4ZJxWaCK+mp0/2isKPKQ2Ew8NhmmHXsuV+rFhneRI+82oDpZ
        bV2xbvZIKaOZ920BXlgKtOs=
X-Google-Smtp-Source: ABdhPJxMQDHQn1YHFhSJ1ccAFfvQM1vZRKNn8RM5XLxUS4NU0QW+dy+vCL4ccEMXykzgM0V1YciR5A==
X-Received: by 2002:a17:902:d706:b0:14d:5b6f:5421 with SMTP id w6-20020a170902d70600b0014d5b6f5421mr10335632ply.96.1645849170541;
        Fri, 25 Feb 2022 20:19:30 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004f1335c8889sm4896193pff.7.2022.02.25.20.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 20:19:29 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/3] net: use kfree_skb_reason() for ip/neighbour
Date:   Sat, 26 Feb 2022 12:18:28 +0800
Message-Id: <20220226041831.2058437-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In the series "net: use kfree_skb_reason() for ip/udp packet receive",
reasons for skb drops are added to the packet receive process of IP
layer. Link:

https://lore.kernel.org/netdev/20220205074739.543606-1-imagedong@tencent.com/

And in the first patch of this series, skb drop reasons are added to
the packet egress path of IP layer. As kfree_skb() is not used frequent,
I commit these changes at once and didn't create a patch for every
functions that involed. Following functions are handled:

__ip_queue_xmit()
ip_finish_output()
ip_mc_finish_output()
ip6_output()
ip6_finish_output()
ip6_finish_output2()

Following new drop reasons are introduced (what they mean can be seen
in the document of them):

SKB_DROP_REASON_IP_OUTNOROUTES
SKB_DROP_REASON_BPF_CGROUP_EGRESS
SKB_DROP_REASON_IPV6DISABLED
SKB_DROP_REASON_NEIGH_CREATEFAIL

In the 2th and 3th patches, kfree_skb_reason() is used in neighbour
subsystem instead of kfree_skb(). __neigh_event_send() and
arp_error_report() are involed, and following new drop reasons are
introduced:

SKB_DROP_REASON_NEIGH_FAILED
SKB_DROP_REASON_NEIGH_QUEUEFULL
SKB_DROP_REASON_NEIGH_DEAD

Changes since v2:
- fix typo in the 1th patch of 'SKB_DROP_REASON_IPV6DSIABLED' reported
  by Roman

Changes since v1:
- introduce SKB_DROP_REASON_NEIGH_CREATEFAIL for some path in the 1th
  patch
- introduce SKB_DROP_REASON_NEIGH_DEAD in the 2th patch
- simplify the document for the new drop reasons, as David Ahern
  suggested

Menglong Dong (3):
  net: ip: add skb drop reasons for ip egress path
  net: neigh: use kfree_skb_reason() for __neigh_event_send()
  net: neigh: add skb drop reasons to arp_error_report()

 include/linux/skbuff.h     | 14 ++++++++++++++
 include/trace/events/skb.h |  7 +++++++
 net/core/neighbour.c       |  6 +++---
 net/ipv4/arp.c             |  2 +-
 net/ipv4/ip_output.c       |  8 ++++----
 net/ipv6/ip6_output.c      |  6 +++---
 6 files changed, 32 insertions(+), 11 deletions(-)

-- 
2.35.1

