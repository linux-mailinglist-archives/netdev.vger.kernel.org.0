Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804BE49F45C
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346813AbiA1Hdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242692AbiA1Hdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:33:46 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B6AC061714;
        Thu, 27 Jan 2022 23:33:46 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id z131so4476623pgz.12;
        Thu, 27 Jan 2022 23:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B8tMpG+tnSHKk9q7aoQpG1aih0nJ6Wa+B2x2HTN3gO4=;
        b=Ks3QwAahRU3Dvrq0QLU3Xr+lWweSjd0SnqGvlXxdHUQ+DODFkZzJgTUbBYeHvVk44n
         qgVb+ENsLez5ygYFHclrwXTLtL3KLzQbvSmOYCyX70TG9+Ywzk4OGbYkohVewFbnw4Dq
         b9Ve0AnrYGcwwFgqM67PYDOEE/FJU+xdiFjs8fBwIwSf8GP0OanonBpWi1K4PHUR5WUN
         Zp5K/WazfsNaf+XoxUw+joWLu12Bv+74y8JaNpjxid8zmHd2tE7r5fNCOyB2WkVQFIRi
         P+l3GopXDFYvoQ1xIw3ReGtJnAYDCaOsKJEUTwRb3FRTuAPvzTSJHftAR/6IClx4siM+
         FAKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B8tMpG+tnSHKk9q7aoQpG1aih0nJ6Wa+B2x2HTN3gO4=;
        b=riHCkwV4rDZvfkoH6zRw8Ng5tqEx/Rkc+PV+aQp8Y4ZypGEnZnFYuGiPqt7AAx0XP6
         iDqOwXbD+9CELKwZb2XjKDtOztbL5CHCpwPsq32uI6d+OilP2XjIPIJ/PZyGOL8vv/gD
         J/rNK+w7aEor4VxGTE5L4hTOLdeg7O+WkqM517A02LhxmzJTLTkidVTAYVHldpQ0bWHw
         2nYR6tC/3HG2snGW5YCooM2DD+pFZdJENTmSaJDiYetVV+O1UeK9kSGXqGra3oCrufB2
         JfShxAJQrT1zLcckmdufN9ZZ7oW0hGHzrHImiKlw9AdbeQ0lerJkpMhjpMyupbbbvPRa
         XlTQ==
X-Gm-Message-State: AOAM531bjD9KST9BLDukvLyFUQIvs1r+kPI9YpEIkbs9W7PI9qNAn6p8
        wErxUbYKEWvJYrUWrT1i9LQ=
X-Google-Smtp-Source: ABdhPJwlwbmWxqFhIfJnFbmHbX/vaSKE4miPmU9BRUFWQ+EB7kN3o7niGKVEWf7NpyX/RfYJ+Hn0Iw==
X-Received: by 2002:a05:6a00:80d:: with SMTP id m13mr6838777pfk.48.1643355225635;
        Thu, 27 Jan 2022 23:33:45 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id q17sm8548846pfu.160.2022.01.27.23.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 23:33:45 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, imagedong@tencent.com, edumazet@google.com,
        alobakin@pm.me, paulb@nvidia.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v3 net-next 0/7] net: use kfree_skb_reason() for ip/udp packet receive
Date:   Fri, 28 Jan 2022 15:33:12 +0800
Message-Id: <20220128073319.1017084-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In this series patches, kfree_skb() is replaced with kfree_skb_reason()
during ipv4 and udp4 packet receiving path, and following drop reasons
are introduced:

SKB_DROP_REASON_SOCKET_FILTER
SKB_DROP_REASON_NETFILTER_DROP
SKB_DROP_REASON_OTHERHOST
SKB_DROP_REASON_IP_CSUM
SKB_DROP_REASON_IP_INHDR
SKB_DROP_REASON_IP_RPFILTER
SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST
SKB_DROP_REASON_XFRM_POLICY
SKB_DROP_REASON_IP_NOPROTO
SKB_DROP_REASON_SOCKET_RCVBUFF
SKB_DROP_REASON_PROTO_MEM

TCP is more complex, so I left it in the next series.

I just figure out how __print_symbolic() works. It doesn't base on the
array index, but searching for symbols by loop. So I'm a little afraid
it's performance.

Changes since v2:
- use SKB_DROP_REASON_PKT_TOO_SMALL for a path in ip_rcv_core()

Changes since v1:
- add document for all drop reasons, as David advised
- remove unreleated cleanup
- remove EARLY_DEMUX and IP_ROUTE_INPUT drop reason
- replace {UDP, TCP}_FILTER with SOCKET_FILTER


Menglong Dong (7):
  net: skb_drop_reason: add document for drop reasons
  net: netfilter: use kfree_drop_reason() for NF_DROP
  net: ipv4: use kfree_skb_reason() in ip_rcv_core()
  net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
  net: ipv4: use kfree_skb_reason() in ip_protocol_deliver_rcu()
  net: udp: use kfree_skb_reason() in udp_queue_rcv_one_skb()
  net: udp: use kfree_skb_reason() in __udp_queue_rcv_skb()

 include/linux/skbuff.h     | 38 ++++++++++++++++++++++++++++++++------
 include/trace/events/skb.h | 11 +++++++++++
 net/ipv4/ip_input.c        | 31 +++++++++++++++++++++++--------
 net/ipv4/udp.c             | 22 ++++++++++++++++------
 net/netfilter/core.c       |  3 ++-
 5 files changed, 84 insertions(+), 21 deletions(-)

-- 
2.27.0

