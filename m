Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292754AA761
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 08:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiBEHry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 02:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiBEHry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 02:47:54 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947ADC061346;
        Fri,  4 Feb 2022 23:47:52 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id v4so1942359pjh.2;
        Fri, 04 Feb 2022 23:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TvKVmfFUdXxOOdxxrcTCTu1sCDVD75UVE6UHl7eAXTo=;
        b=k2QpbtFl+dO8bSEaT+gazl+kbNzsf40jdf1SwIbdKORCJjYvFjQQWuQH55uIxUgqbh
         0NvvLC4jQKjw6PaMPNxs+n4Qq92rClobkbmMxaF38xhBkIOn+dZBnYFgEoU+S5hWFB02
         jij5CTLUISd/+8UTSPSa6KugZRXAQcxeV3cNVWL/mrPwA/gz+/CLzRlqdAo+Fz6bb/eS
         R2zdz/p81inPmjOWaGYQqRVGidqWaqnzybwg8bLhcg6FeFRBd+duiyUMi8ZA4vnpuuYv
         4Rw2p5wmSuFC9pKzXHJGmQZzJ+zY09Hlgobtz96iuAbYiXeZl7lRE2pW8omPEVAtQ1g9
         DpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TvKVmfFUdXxOOdxxrcTCTu1sCDVD75UVE6UHl7eAXTo=;
        b=urXoQNjBqEab6z3gyTtwcGx68DjtWBqzwCie52wbW4wE4rlvX5Kr3Z4peWpr1Mxetr
         f1DuoFoPhlucSiYsqBVLdzKSxZTAMytUWqj7Q73ydGe4/C6hbii6w7HJfYmChByfg3io
         StFKofKjMIhUkNxVXpCesAmAg2gHVyARxMkj1uI1EhY2ATs/WyxKTp8SetcugBfVoRPg
         FXiDLWNi7NwiTGN9xCbBuYwrgr7smeiyvpFoZNqKoXEkOh5qgVR/GwgYKRD++R3gGd0o
         dtoYrNi2S0JpGB/vZfZPkclLtTTiKvHpP4Sg1IbIfqIfIFBMAqXOMHYWy+tOhJ1jnC5Y
         Z5pA==
X-Gm-Message-State: AOAM530+OccAhGa7objGD7UpNQ4n2Ub87ynOUP5Ts6enzRU9Z4qc2B6r
        efDHCO0PnS90Vkgq/Khux3Y=
X-Google-Smtp-Source: ABdhPJzThzJLqDjg3OoiMIuL6og+I4Gy091jyg2JnfDS2/M+QGuY2A8Qc3zkIsITL3jk2KLlIST+qQ==
X-Received: by 2002:a17:90b:33ca:: with SMTP id lk10mr3080485pjb.45.1644047272117;
        Fri, 04 Feb 2022 23:47:52 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id p21sm5165844pfh.89.2022.02.04.23.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 23:47:51 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, edumazet@google.com, alobakin@pm.me, ast@kernel.org,
        imagedong@tencent.com, pabeni@redhat.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        paulb@nvidia.com, cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v4 net-next 0/7] net: use kfree_skb_reason() for ip/udp packet receive
Date:   Sat,  5 Feb 2022 15:47:32 +0800
Message-Id: <20220205074739.543606-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
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

Changes since v3:
- fix some small problems in the third patch (net: ipv4: use
  kfree_skb_reason() in ip_rcv_core()), as David Ahern said

Changes since v2:
- use SKB_DROP_REASON_PKT_TOO_SMALL for a path in ip_rcv_core()

Changes since v1:
- add document for all drop reasons, as David advised
- remove unreleated cleanup
- remove EARLY_DEMUX and IP_ROUTE_INPUT drop reason
- replace {UDP, TCP}_FILTER with SOCKET_FILTER


Alex Elder (6):
  net: ipa: allocate transaction in replenish loop
  net: ipa: don't use replenish_backlog
  net: ipa: introduce gsi_channel_trans_idle()
  net: ipa: kill replenish_backlog
  net: ipa: replenish after delivering payload
  net: ipa: determine replenish doorbell differently

Menglong Dong (1):
  net: drop_monitor: support drop reason

-- 
2.27.0

