Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117E15F03F3
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 06:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiI3Ez2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 00:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiI3EzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 00:55:24 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FDB100AA8
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:04 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id i12so2209573qvs.2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=EAnVN0X6Uk5HC3tLrTi+m9SVbx4IgbYJgIUYrtkfTho=;
        b=ZPIxmmcLccXwjHLJ92BKb4dSUPI0lV5DQ2OYY57HtkhvcsZp8iqfjuaGpR9rDoycFt
         2Pg5VrsjX3yC5nm+mKXNu0/5OBMDsf4L9G61RUnALGZdlxlwH+z8XH2YG0OH9s5Y2jnt
         aaGxkjkdU2ZG0weIHHoD7+9DzLMwvNPk4elr8JJ2+z1SLlp3JhYXxMBxqQC9v+Qilubt
         5lEw0x6q6DYl+tt7qE/Lq8v+96x4VlvF4TMUY40y9s8btysSGB4JhUKaV+rgwVtit4L/
         44CsKVmCZDmlid5F+r8Fq7UkM98i/Jx74nzzJo01MR+/e6d3a3QjBer5rQS/qUTROjOm
         NycQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=EAnVN0X6Uk5HC3tLrTi+m9SVbx4IgbYJgIUYrtkfTho=;
        b=U+9T9ffBMOsd7ksF5B9c3greeEb3InVEtWe3AxT6jigD5e4I1ZZFC8b9UdXqAV94Am
         ioc9m7OKAF9wmMMX03oheN8SAbaDsgBD+kZOVsc3MOKTkXQaDuxH3nCCwhA/rl3WUZe4
         Y2oZfAmGwJ8cS+Nn1llnjqy1jAH7RGtP7lZ101gx04RTPCz5PwUyAkPHGX7Do0PdiL/e
         NWsJW0mCEz+JPftBhNX42pJt2p4RGz6veKnBS32dqrEMUJz7SaiShir3H7reMG91E/yd
         Z2LWzYGk706pZoEo33ODVsJaP0GjysXLz3sa/mZ+mxnFm2Atl2K+jHGHj1czrjHZn/am
         PUnw==
X-Gm-Message-State: ACrzQf1rX25en0dfR12A1hXTRdLrlBRpAvxl3HCKHcF2jgGusmnirzqb
        3t2mNDA/DB3f3GGjORse7Gw=
X-Google-Smtp-Source: AMsMyM76hg7A6zpbaQ35J7p2Y+OwJyP2wJr5KmJ+3d5pm0zNq5FFxx2Ho0kJvwB4hMIkB813Bd0Azg==
X-Received: by 2002:a05:6214:4005:b0:474:3c94:cdc2 with SMTP id kd5-20020a056214400500b004743c94cdc2mr5303324qvb.17.1664513616524;
        Thu, 29 Sep 2022 21:53:36 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id de9-20020a05620a370900b006bb82221013sm1550059qkb.0.2022.09.29.21.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 21:53:35 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>
Subject: [PATCH net-next v2 0/5] Add PLB functionality to TCP
Date:   Fri, 30 Sep 2022 04:53:15 +0000
Message-Id: <20220930045320.5252-1-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929142447.3821638-1-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mubashir Adnan Qureshi <mubashirq@google.com>

This patch series adds PLB (Protective Load Balancing) to TCP and hooks
it up to DCTCP. PLB is disabled by default and can be enabled using
relevant sysctls and support from underlying CC.

PLB (Protective Load Balancing) is a host based mechanism for load
balancing across switch links. It leverages congestion signals(e.g. ECN)
from transport layer to randomly change the path of the connection
experiencing congestion. PLB changes the path of the connection by
changing the outgoing IPv6 flow label for IPv6 connections (implemented
in Linux by calling sk_rethink_txhash()). Because of this implementation
mechanism, PLB can currently only work for IPv6 traffic. For more
information, see the SIGCOMM 2022 paper:
  https://doi.org/10.1145/3544216.3544226

Mubashir Adnan Qureshi (5):
  tcp: add sysctls for TCP PLB parameters
  tcp: add PLB functionality for TCP
  tcp: add support for PLB in DCTCP
  tcp: add u32 counter in tcp_sock and an SNMP counter for PLB
  tcp: add rcv_wnd and plb_rehash to TCP_INFO

 Documentation/networking/ip-sysctl.rst |  75 ++++++++++++++++++
 include/linux/tcp.h                    |   1 +
 include/net/netns/ipv4.h               |   5 ++
 include/net/tcp.h                      |  28 +++++++
 include/uapi/linux/snmp.h              |   1 +
 include/uapi/linux/tcp.h               |   6 ++
 net/ipv4/Makefile                      |   2 +-
 net/ipv4/proc.c                        |   1 +
 net/ipv4/sysctl_net_ipv4.c             |  43 ++++++++++
 net/ipv4/tcp.c                         |   5 ++
 net/ipv4/tcp_dctcp.c                   |  23 +++++-
 net/ipv4/tcp_ipv4.c                    |   8 ++
 net/ipv4/tcp_plb.c                     | 104 +++++++++++++++++++++++++
 13 files changed, 300 insertions(+), 2 deletions(-)
 create mode 100644 net/ipv4/tcp_plb.c

-- 
2.38.0.rc1.362.ged0d419d3c-goog

