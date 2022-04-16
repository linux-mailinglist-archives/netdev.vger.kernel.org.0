Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05C050332C
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiDPANg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237328AbiDPANf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:13:35 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8C541FA3
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:05 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so9413948pjk.4
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XzK4bNEzXmCRl01gV9aCElJul5MH3xEfuz3y7xUF8lE=;
        b=eJ4UFyXr7enHI69LA3n37mQ79VLh+OHM2GLNsB/pEg05kiXzdG1jwbpUwPvhbJNCAL
         r5NkJLjzKUTJfPm/mVWCBiUNnXQH02FM6GFxxy6LrzxH0XaytRXjUzYuSzUYE76f0JRd
         3Yy1wL103D79Fl2ucpLPDSWLbcrWacuDb01Dm4MysIc36c+Ds4n0s56V5OMjBMJxD2jH
         or8/C5gGGPFNc9D5tVdQbAG8TlIZnlb3lW0VrmwdBOCjvUvF1CcY75DAeLwtt1evsJ/8
         /N1OR0YzlepANIunmSkUHQB9VC6+VYP/Ag4f77taPx5GTUuZlSnTGcEeIOSHKzJNtgHa
         0jOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XzK4bNEzXmCRl01gV9aCElJul5MH3xEfuz3y7xUF8lE=;
        b=8MSPyvQPA/7bBExSMQYscNev4jTZHQbFWNZ+S/rFLVvciYT6+QYqN8ikZeo7lF9cxj
         gq4wKRthCv4zgX2xrcErNZi181ZnEJ91D+NJ9CnrbZuP4cBD6GnpTo7lGrTwsv/K4TYq
         VNIrrsxb5qxz2Amglg/471bijN4MmZHpXQpE6rXlTWywPn+2GNlbImCrakc3Tuy18HIl
         Kd9UUYP9b8+FXMGQ4AfDsCcSXwfna6dh1OB2COckkP2x1sp3iVQ01UdmLG4CPi4hvmoa
         6v3SCq7OTIQn5yZAZBNmlLu/boNxG45xzl7uzaWD8JXhWcsWUYHuoy4R861iUWvdcoYB
         5jAA==
X-Gm-Message-State: AOAM531Qg69tdxES+F3hlXR61dWmYb/C5ZcB3s7Nee4c6pezYgfekHxV
        bfJcM+iebNdusH9LkPhuJqU=
X-Google-Smtp-Source: ABdhPJweI+5JN/6lBSVy74JwrTFKF6bsMetpMTZ27RhRPbyXzEWv61ifXIFu+eiflKO29/tdnt2O+w==
X-Received: by 2002:a17:903:20c:b0:154:b58:d424 with SMTP id r12-20020a170903020c00b001540b58d424mr1297360plh.45.1650067864725;
        Fri, 15 Apr 2022 17:11:04 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm5729514pjf.23.2022.04.15.17.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:11:03 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 00/10] tcp: drop reason additions
Date:   Fri, 15 Apr 2022 17:10:38 -0700
Message-Id: <20220416001048.2218911-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
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

From: Eric Dumazet <edumazet@google.com>

Currently, TCP is either missing drop reasons,
or pretending that some useful packets are dropped.

This patch series makes "perf record -a -e skb:kfree_skb"
much more usable.

Eric Dumazet (10):
  tcp: consume incoming skb leading to a reset
  tcp: get rid of rst_seq_match
  tcp: add drop reason support to tcp_validate_incoming()
  tcp: make tcp_rcv_state_process() drop monitor friendly
  tcp: add drop reasons to tcp_rcv_state_process()
  tcp: add two drop reasons for tcp_ack()
  tcp: add drop reason support to tcp_prune_ofo_queue()
  tcp: make tcp_rcv_synsent_state_process() drop monitor friend
  tcp: add drop reasons to tcp_rcv_synsent_state_process()
  tcp: add drop reason support to tcp_ofo_queue()

 include/linux/skbuff.h     |  13 ++++
 include/trace/events/skb.h |  14 ++++
 net/ipv4/tcp_input.c       | 127 +++++++++++++++++++++----------------
 3 files changed, 100 insertions(+), 54 deletions(-)

-- 
2.36.0.rc0.470.gd361397f0d-goog

