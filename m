Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D454CC443
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbiCCRtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiCCRtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:49:07 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384E055227;
        Thu,  3 Mar 2022 09:48:21 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id d17so5355676pfl.0;
        Thu, 03 Mar 2022 09:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DWgo+Jyh9HNlFj03oyr40rqSHaNpbhrExburNx9Vpkw=;
        b=kSQUhMu5yuqyHz/OCTt4rXjFkBdVCHlBTyhEuNalsz+cKJyB4s2ZZ07jrsUAiBJK1S
         SVe7/9uDGyyPa/SGynl4cNP5Jf4rjwImfNdvdNARuS9z8MiJOPSdJaVkRQ1aUVciVeh4
         Lxg6q4YgqnlcxiGVdDGwr2APOvYx24Jysb6K/pwa7LROp/VnTcs2vVEgedtjresmbBbG
         iw5FjqmmPRblwIgcHSOiRCzpwed+oOif9A+kwJ8H1VABDTwkT6/ARUuac4rwiy8XWDWT
         ZKYxQjUyF56oP9M8pS4rjydPZjjtipXsIEHQm8zEcbK+bJPpFj4Vcs9oHyrKsJe+NYtR
         Ql0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DWgo+Jyh9HNlFj03oyr40rqSHaNpbhrExburNx9Vpkw=;
        b=Xwy7CuMEdUfNme4Gdx6T19M2HlVA2DhhA27f1s0OAfen6vzTmMFHGgK7cjXjmwQxhw
         6b0NkOuDcq94AQSImbcl2U2p44vMaTMaJ5x1FcVpYrHFs8oefFI4S6wpqxoAXCMXiibf
         ugYa4OmcBFdNdLdTX9OIf0x5hN/Yq4lOatrZN4FIM/+s6JXyXdMl5eRXOgyRBWb0Lw23
         yplt7rtAXw+/N1fwv/meIZmuQQ960zcogy5k36qRWs3AgPzEYEREd4hoT8VL22EiB/tB
         XBMAZji1+tnc3DfgQ6t7wYqNUXTdFdWN1q26Yy8KalknI9rykdrIxkjavkZBAv7rLxqr
         mBgA==
X-Gm-Message-State: AOAM532kOewKyMlNnCMBOoeXkE9Iat8oFMBm8E8PXwOUhCp9bLIfFChL
        hQminyQm0VYKLm6SIoe0Q9c=
X-Google-Smtp-Source: ABdhPJwNfqVoyFjxKcFMzuf/BBbRvC4r94aov9WO7W4ncBMoWcEO5TpSJ9wSrk7htFbPWpKLwiRX3w==
X-Received: by 2002:a62:7ad5:0:b0:4e1:5bda:823b with SMTP id v204-20020a627ad5000000b004e15bda823bmr39246215pfc.75.1646329700710;
        Thu, 03 Mar 2022 09:48:20 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f0f0f852a4sm3209395pfx.77.2022.03.03.09.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 09:48:20 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        edumazet@google.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, memxor@gmail.com, arnd@arndb.de,
        pabeni@redhat.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next 0/7] net: dev: add skb drop reasons to net/core/dev.c
Date:   Fri,  4 Mar 2022 01:47:00 +0800
Message-Id: <20220303174707.40431-1-imagedong@tencent.com>
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
to the link layer, which means that 'net/core/dev.c' is our target.

Following functions are processed:

sch_handle_egress()
__dev_xmit_skb()
enqueue_to_backlog()
do_xdp_generic()
sch_handle_ingress()
__netif_receive_skb_core()

and following new drop reasons are added (what they mean can be see in
the document of them):

SKB_DROP_REASON_QDISC_EGRESS
SKB_DROP_REASON_QDISC_DROP
SKB_DROP_REASON_CPU_BACKLOG
SKB_DROP_REASON_XDP
SKB_DROP_REASON_QDISC_INGRESS
SKB_DROP_REASON_PTYPE_ABSENT

In order to add skb drop reasons to kfree_skb_list(), the function
kfree_skb_list_reason() is introduced in the 2th patch, which will be
used in __dev_xmit_skb() in the 3th patch.


Menglong Dong (7):
  net: dev: use kfree_skb_reason() for sch_handle_egress()
  net: skb: introduce the function kfree_skb_list_reason()
  net: dev: add skb drop reasons to __dev_xmit_skb()
  net: dev: use kfree_skb_reason() for enqueue_to_backlog()
  net: dev: use kfree_skb_reason() for do_xdp_generic()
  net: dev: use kfree_skb_reason() for sch_handle_ingress()
  net: dev: use kfree_skb_reason() for __netif_receive_skb_core()

 include/linux/skbuff.h     | 32 +++++++++++++++++++++++++++++++-
 include/trace/events/skb.h |  5 +++++
 net/core/dev.c             | 25 ++++++++++++++++---------
 net/core/skbuff.c          |  7 ++++---
 4 files changed, 56 insertions(+), 13 deletions(-)

-- 
2.35.1

