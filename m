Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D6E4C3EDE
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 08:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbiBYHTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 02:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiBYHTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 02:19:31 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F96253BF6;
        Thu, 24 Feb 2022 23:19:00 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id b22so4059408pls.7;
        Thu, 24 Feb 2022 23:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aY+XddXjw7LZh1zdvBioaCOUGi5CQTdoKQ2E5MS97TU=;
        b=Fdrw3FLu5zI4McxeGMrABkpROPrvt3P8COAeV2iufC74ESJPl3mrnrpRRrFIi2jmNN
         W9VJIaI/ZthyfLewq3hxAJrCRQ+YCx961chWpnhcJRbOl8FTF2Tb9cWrtQG3NhtKH6al
         qGc9jBMOziwwCC1l+alESVgfPV4VgniUtsiqgDfk59msmX9NISqG5zSKZur/NnrqeWTp
         /IUgM79SBWa6Aa3fWeilRBK5dVpMCWlM/fHKH3kHmpFtFV98FMsZ9G1SfoGbdAlwPtvx
         IOWFjve/FXWylwzrB8W/VXqj6E1XuHiVG6tnr0IDi/3f7qBwje4L240rBXFQREdKZYwF
         LSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aY+XddXjw7LZh1zdvBioaCOUGi5CQTdoKQ2E5MS97TU=;
        b=u/yqWuSfIJQt9UFxlxXIsu+bx7/iLoWcFzx+tiH8CI6VxOJRBUD87C6kPMqcAi8nHf
         6+HimP1E2tN3YPKomcEydDX6GfSAXHerjdKpdBFViO2EB7mQQgH6BgsOzNMAbUQJPAFn
         lm79yJcvSwTL2nLxl+j1SC9Z3VBhnzZnA7v8MVkAgp1ybCZh5HvQ6hRLpcGayhd0P5A/
         fZNgig+ynn2kIrK4cP9rxs6JJydS7QgESlFC75zY7E7MvoS3/Pgw+SR5Q9lyzwWlPqyW
         xgbdqQKsisAYioV/t3bYQwGv115b39Anf2HCSIsPgf69rQZDYL1v7bYu5+FqKSnArXs9
         M55A==
X-Gm-Message-State: AOAM533ZOQ/i41PgenZ0ttGWETdKf3wZNMWuIGeNYdGybvNgAtjeVCLg
        AhnZlFDHAY+RLjNJNgByVpg=
X-Google-Smtp-Source: ABdhPJyfCWU3wBIcB12TbUXk4HqCL/V66Y5U0UL1FZ/m6hYgDgfrMhVlkHPZQmr++ZgMjvprpyg6Xw==
X-Received: by 2002:a17:90a:578f:b0:1b9:b03f:c33c with SMTP id g15-20020a17090a578f00b001b9b03fc33cmr1925497pji.114.1645773539919;
        Thu, 24 Feb 2022 23:18:59 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id k20-20020a056a00135400b004ecc81067b8sm1970825pfu.144.2022.02.24.23.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 23:18:59 -0800 (PST)
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
Subject: [PATCH net-next v2 0/3] net: use kfree_skb_reason() for ip/neighbour
Date:   Fri, 25 Feb 2022 15:17:36 +0800
Message-Id: <20220225071739.1956657-1-imagedong@tencent.com>
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
SKB_DROP_REASON_NEIGH_CREATEFAIL

In the 2th and 3th patches, kfree_skb_reason() is used in neighbour
subsystem instead of kfree_skb(). __neigh_event_send() and
arp_error_report() are involed, and following new drop reasons are
introduced:

SKB_DROP_REASON_NEIGH_FAILED
SKB_DROP_REASON_NEIGH_QUEUEFULL
SKB_DROP_REASON_NEIGH_DEAD

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

