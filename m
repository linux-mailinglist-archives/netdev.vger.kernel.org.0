Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3A34BCFB2
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 17:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244256AbiBTP7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 10:59:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243181AbiBTP7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 10:59:06 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF48434B0;
        Sun, 20 Feb 2022 07:58:44 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id om7so12794622pjb.5;
        Sun, 20 Feb 2022 07:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/HcbilQZQyLxjMVr9Hr3IidzgIzF7CIihK7dRYv/rdc=;
        b=Lhdn5CjSR0mlwF2/pUmagB9bOKTHi5YQqt4JbsuNRmYA6jUAgKmEoSLBwZu9MZAUAd
         cfUGMRpREyxsUR8nj/40sLuz/sH3AYOTk/zHvGTh8SPMkwU3c5SI+mDNmWcsG3SGGRkV
         HAmWKBT0bhVHdcynAII8fStMBUYoDRJ645kQItOVFqbyW2LiPe+hDVXWHvG2waOdPpQF
         MiAi7tovaPQ5rAumT/xVG1ZSDVhnBpEuoa5gU/Jh0GZ1w1T9zbd2uV5Y2Lc1HitGARe2
         E0ZU3U3Ly8UyNtgaJXlZmtuccBsL6sWpXv5jPYUu0L3y5cRqsbSgS08x1Y1kDe/zCB0R
         WXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/HcbilQZQyLxjMVr9Hr3IidzgIzF7CIihK7dRYv/rdc=;
        b=yhb0ZFgdXMPCpsxqmkicdEQ1cwGQqpKG+AEOJpDrIvn2/bGkj8idjgQAvWOU3qA/Pd
         iPzVM0dM+wSsgscPbQaRdOlOkvahS5D+OE4EsuH3hOPjJXgiyqKKJoxHT8UIiO8Lg3QJ
         T0qph5AQk53Kld62EKaROlD2FI1+MY1wB1dzgxsAkDe0CrV3GTAIcagtFcaewFnykPxm
         dNYcxJXSgyucnAno4OTaCskayUrwBDToHjBNLrL7wrFfUZKZxkIAk0xB17p2868XQ8x2
         0beq5v0H+7UWeh44UFYWDhyUEOyqYfVakqV/0D1xYKdR/Y0/ikvKR497O4lq4jGHozEi
         bXZw==
X-Gm-Message-State: AOAM530Kb59DcXmCMpZ5+t5gLHJQkgegrf8eSW85QMzYG3DixcCAvtY5
        DYwp91XXOP5U0OrKQIWG8c4=
X-Google-Smtp-Source: ABdhPJwhvG+NJafx+nhxjF5TQPdpcXccbf/OSZLylNJe+zvo838cPhX7PfuiV5r8bZ+PGu2d13qX6w==
X-Received: by 2002:a17:90a:e512:b0:1bc:30a4:8c3e with SMTP id t18-20020a17090ae51200b001bc30a48c3emr1784194pjy.69.1645372723455;
        Sun, 20 Feb 2022 07:58:43 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id o14sm5001927pfw.121.2022.02.20.07.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 07:58:42 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] net: use kfree_skb_reason() for ip/neighbour
Date:   Sun, 20 Feb 2022 23:57:02 +0800
Message-Id: <20220220155705.194266-1-imagedong@tencent.com>
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
SKB_DROP_REASON_IPV6DSIABLED

In the 2th and 3th patches, kfree_skb_reason() is used in neighbour
subsystem instead of kfree_skb(). __neigh_event_send() and
arp_error_report() are involed, and following new drop reasons are
introduced:

SKB_DROP_REASON_NEIGH_FAILED
SKB_DROP_REASON_NEIGH_QUEUEFULL


Menglong Dong (3):
  net: ip: add skb drop reasons for ip egress path
  net: neigh: use kfree_skb_reason() for __neigh_event_send()
  net: neigh: add skb drop reasons to arp_error_report()

 include/linux/skbuff.h     | 22 ++++++++++++++++++++++
 include/trace/events/skb.h |  6 ++++++
 net/core/neighbour.c       |  4 ++--
 net/ipv4/arp.c             |  2 +-
 net/ipv4/ip_output.c       |  6 +++---
 net/ipv6/ip6_output.c      |  6 +++---
 6 files changed, 37 insertions(+), 9 deletions(-)

-- 
2.35.1

