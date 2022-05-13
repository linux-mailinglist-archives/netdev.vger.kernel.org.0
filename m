Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301145259E8
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 05:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357209AbiEMDEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 23:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241045AbiEMDEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 23:04:49 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C28284908;
        Thu, 12 May 2022 20:04:47 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id i24so6522085pfa.7;
        Thu, 12 May 2022 20:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uPSFu801nJLOJ3tr69DHbRmzXfaEVytzaqlwAPFRnHk=;
        b=nNiPTY5mblZ5YqZ1sZfMMPoRuMg5shnmDsD7NRx9W/P6CHsSdPnJpTQSoQGg5hMuSO
         fu6i4rmb+Kydzp5buZ+lmhOEbcCDcFzDE6d1L2dHmhcXkohBkq54KW6p/TttreU2Ai2A
         KphHZ1r9p8iq7CxOtnMUEu8HDWsvRZKrK7H7Uk3MaT9MToG4bX4t5Lkde4qDmaDwN4Ud
         2wKG6eY0Uk6lQT6r5umtlXtGH/Xgk/+OjtPXok7yUDX25/G8GN0a5Y5HMotffo1Os4SL
         EgpCokHlKWB4R6EC9sgtS388o8gvPmc5CkgfkZneIUi5KWExqZsUg1XIpICZknn3jb7B
         Pzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uPSFu801nJLOJ3tr69DHbRmzXfaEVytzaqlwAPFRnHk=;
        b=ExJPa3LpEzjsgBmFoiaIWZq19PgxKkztAUUwu+UFq+/WVi3m3KkTXQXpcYa46lUXmN
         NKKvveGTY6mdZIiAvKa4m+GF3IcZqtpCZMWwUmxgAhDr5kUpTowbXuXgzqudJ5pMNU76
         CIuKYxLN6TspXx6LOuuosFyoV0LjbOtLX4ZlyH7UhXmHr7iIMspkPDRTlau7yMjkAsL2
         u+R60/HUR1WpAJQRGm6jwHLAQ0bSJdgHj3x7sW2vVFANnVaHa2cRkav1YB5xg/SkPK1r
         HbfsNSIquOlrrHeaXPwH5o39Iz2j7u0akMlSmrowHUbvNkIXFYsUNcTcXdxXa2Qg+LsS
         wezg==
X-Gm-Message-State: AOAM531hnDkYbNxClr14VXPluABiIbZT5r6xKGcS6X9sESchE9roKumP
        rmTJmO6VSYJW+zuuRJz9J+/mbGi1TMXZfw==
X-Google-Smtp-Source: ABdhPJz8qHb+faOKxdenJux2cqWQpavB4i0RYAJaNPdSueMShNJ/cZqCUt75KhJtd2VZ74JuMvlO8Q==
X-Received: by 2002:a05:6a00:23ce:b0:50d:823f:981 with SMTP id g14-20020a056a0023ce00b0050d823f0981mr2631761pfc.10.1652411087207;
        Thu, 12 May 2022 20:04:47 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.26])
        by smtp.gmail.com with ESMTPSA id b7-20020a170903228700b0015e8d4eb1f8sm638693plh.66.2022.05.12.20.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 20:04:46 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, asml.silence@gmail.com, willemb@google.com,
        vasily.averin@linux.dev, ilias.apalodimas@linaro.org,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/4] net: skb: check the boundrary of skb drop reason
Date:   Fri, 13 May 2022 11:03:35 +0800
Message-Id: <20220513030339.336580-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
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

In the commit 1330b6ef3313 ("skb: make drop reason booleanable"),
SKB_NOT_DROPPED_YET is added to the enum skb_drop_reason, which makes
the invalid drop reason SKB_NOT_DROPPED_YET can leak to the kfree_skb
tracepoint. Once this happen (it happened, as 4th patch says), it can
cause NULL pointer in drop monitor and result in kernel panic.

Therefore, check the boundrary of drop reason in both kfree_skb_reason
(2th patch) and drop monitor (1th patch) to prevent such case happens
again.

Meanwhile, fix the invalid drop reason passed to kfree_skb_reason() in
tcp_v4_rcv() and tcp_v6_rcv().

Changes since v2:
1/4 - don't reset the reason and print the debug warning only (Jakub
      Kicinski)
4/4 - remove new lines between tags

Changes since v1:
- consider tcp_v6_rcv() in the 4th patch


Menglong Dong (4):
  net: dm: check the boundary of skb drop reasons
  net: skb: check the boundrary of drop reason in kfree_skb_reason()
  net: skb: change the definition SKB_DR_SET()
  net: tcp: reset 'drop_reason' to NOT_SPCIFIED in tcp_v{4,6}_rcv()

 include/linux/skbuff.h  | 3 ++-
 net/core/drop_monitor.c | 2 +-
 net/core/skbuff.c       | 2 ++
 net/ipv4/tcp_ipv4.c     | 1 +
 net/ipv6/tcp_ipv6.c     | 1 +
 5 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.36.1

