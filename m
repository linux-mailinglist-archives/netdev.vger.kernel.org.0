Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C6F4D80BD
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 12:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238940AbiCNLdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 07:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238922AbiCNLdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 07:33:54 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72CF1F62E;
        Mon, 14 Mar 2022 04:32:44 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id z4so13470904pgh.12;
        Mon, 14 Mar 2022 04:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=92cFP1Q6pigG4NDAij7XXlgfkxnBaSgKOySsdGgapv0=;
        b=Qzb+b30IWzZ8yT1D98WbHHtNLsv83jEdHMCsP9EUJAF1by8QgRAwP2LL6Md6iu6Vur
         D4YMsevNUJ9EWCWod8CxNb5P4B/STl64lixHUrWLWnHhgg2vyIBkZzjB6oR1S52/1WG3
         lRvn28f43NvQuK8BkLpJUuq47vCPZIABxwGtaSaMw4qyWlHY+7fxuNUGASnVgepIOBha
         JTvr2BBuDsdYaCeTk5xUMhoTX6Z/rVzRq4AjBear/aASTqJdYM+AkUNhGbpW9inxInLo
         PPgOYeomYhGIOurDyymwO7Sa2GggnoluJOUanXBxjnh0h5p7t5lUP0PTFjpIxZdF41mV
         pUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=92cFP1Q6pigG4NDAij7XXlgfkxnBaSgKOySsdGgapv0=;
        b=eU98wAdHpv9bsnRFD2MqZzL5ItkVAItumcf+VXo3DBZZJhypHwMzYs7CoOZ9rRdCBV
         yh1Zjw/m98uQkBSzpVaa7ycB6FXQhqfzUkmh2WbHTmRE9o3V8trp8OWn/4b/6SgBJ8Sz
         cPs1rJxsXPp/9wzn1LkPa1TdAKT4abq0r+euTiWYbgnL8FZJbDynJvzKdGElw7xzK81u
         jXNeyJrOjhqpMwFFR+p3LCB9gdUHuO21KBVJgbKeWXv+qA9ZHyLKFKkFsdG6fhdK5ac7
         guJFtiX35oqTiypSySM38h5FF0pEBsvIW0zWebKtPd/d9RabftstscWVgWcTYpUIkAYq
         zLTA==
X-Gm-Message-State: AOAM530CkibfHHrPJEJ+s01DXdLVdU31IV3sfPjqvJBtKVnxXfQoBBmN
        VIixO7k9jnOUQG4FxBi9sQM=
X-Google-Smtp-Source: ABdhPJyi7Hh/JYtt3JY7Nf9mWH2uKnG7FDRGWWlHs6RzovzxGkZu9vokk/51i02aWNKfEJZi+jVOKQ==
X-Received: by 2002:a05:6a00:319e:b0:4f6:dedb:6c52 with SMTP id bj30-20020a056a00319e00b004f6dedb6c52mr23293271pfb.31.1647257564320;
        Mon, 14 Mar 2022 04:32:44 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.118])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004f7e3181a41sm2645197pfc.98.2022.03.14.04.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:32:43 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, alobakin@pm.me, dongli.zhang@oracle.com,
        pabeni@redhat.com, maze@google.com, aahringo@redhat.com,
        weiwan@google.com, yangbo.lu@nxp.com, fw@strlen.de,
        tglx@linutronix.de, rpalethorpe@suse.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] net: icmp: add skb drop reasons to icmp
Date:   Mon, 14 Mar 2022 19:32:22 +0800
Message-Id: <20220314113225.151959-1-imagedong@tencent.com>
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

In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()"),
we added the support of reporting the reasons of skb drops to kfree_skb
tracepoint. And in this series patches, reasons for skb drops are added
to ICMP protocol.

In order to report the reasons of skb drops in 'sock_queue_rcv_skb()',
the function 'sock_queue_rcv_skb_reason()' is introduced in the 1th
patch, which is used in the 2th patch.

In the 2th patch, we add skb drop reasons to ping_queue_rcv_skb().

In the 3th patch, we make ICMP message handler functions return drop
reasons, which means we change the return type of 'handler()' in
'struct icmp_control' from 'bool' to 'enum skb_drop_reason'. This
changed its original intention, as 'false' means failure, but
'SKB_NOT_DROPPED_YET', which is 0, means success now. Therefore, we
have to change all usages of these handler. Following "handler" functions
are involved:

icmp_unreach()
icmp_redirect()
icmp_echo()
icmp_timestamp()
icmp_discard()

And following drop reasons are added(what they mean can be see
in the document for them):

SKB_DROP_REASON_ICMP_CSUM
SKB_DROP_REASON_ICMP_TYPE
SKB_DROP_REASON_ICMP_BROADCAST

Menglong Dong (3):
  net: sock: introduce sock_queue_rcv_skb_reason()
  net: icmp: add skb drop reasons to ping_queue_rcv_skb()
  net: icmp: add reasons of the skb drops to icmp protocol

 include/linux/skbuff.h     |  5 +++
 include/net/ping.h         |  2 +-
 include/net/sock.h         |  9 ++++-
 include/trace/events/skb.h |  3 ++
 net/core/sock.c            | 30 ++++++++++++---
 net/ipv4/icmp.c            | 75 ++++++++++++++++++++++----------------
 net/ipv4/ping.c            | 21 ++++++-----
 net/ipv6/icmp.c            | 24 +++++++-----
 8 files changed, 112 insertions(+), 57 deletions(-)

-- 
2.35.1

