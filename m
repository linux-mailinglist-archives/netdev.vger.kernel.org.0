Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AFE60E296
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiJZNvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiJZNv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:51:29 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83951A0
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:26 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id h24so9876939qta.7
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DZRbHT2Big6/TykpdlIbM+/4aaOoF+Q6T6sGdWP+LLk=;
        b=E1Hy78wp0jIM5FLbGFiWjsa0oWFjxU4GMa4igqsgnyOtk75JycEcD4UnshzLoRTtpP
         zxxjO0HnU6VVlW0uVZmUQKKXFgo0Z5Rb5AxlHmjgK5+vc5nsi8lYaKIbP/QB0MgqpVGB
         tHXushmvHX3UwKNDwxDIJtHyrMkv4jynmjI973rf0umXTTYAOnoNZo7dz0GzbIhA0lCz
         l31TYv7XG8kO5BcmB/6E5F+67hFqXXXWgnto4pvZglJTXI/vMDBRPyQkgvqi5mHfc5PM
         q/m7+JgWOaoO+9P49NeWGPGcqCMd6tdEp8QF1n6eE/c0MQ4kV4EAA/ub2+VUxFcIxJhQ
         Uyuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DZRbHT2Big6/TykpdlIbM+/4aaOoF+Q6T6sGdWP+LLk=;
        b=75kg+uqjuQ74EucJpILF/PpUDSa7vdjbFoj9aeUCVeyQyL3bZ3bYI82KOgmaSN5m0T
         dUTzYS3HnWHVXnx01WvlLlu4lJS+OU7+gNWb6EDhEnZw/7uWQ7fndrIDx7tNmvVavile
         1HKMOP7eWdM3jIxBN/XsZdL/mXMocheowEf7el8v7mF1zdqrnubDwRarJnDbjFrvPAQf
         gMw3gawiG8xnEjMsIaasEv9fZ+vYrMYZUgubfJc0cojCK90blNFaJ+iXxdylGUYWu6g/
         wNWmvBCjpIx40VqLz+dGqpl6NndAf2F/132fHeJpAmqtpRHw3vcSV0XxH2zsD+auANNE
         zynw==
X-Gm-Message-State: ACrzQf0zGZD8OY+F1LTD4hPWcn/pAuUBhuk5ZbFQwdHrCyP+Fsd1l42f
        j4Mzvm/97wJMmes9ePfoid8=
X-Google-Smtp-Source: AMsMyM4p8rEV04UepCQFNgOUS4FcdGER3B9Yw8S+SFXJ1Hk4eLkTA//gGveXrmVULyWo/shZfdkD0Q==
X-Received: by 2002:ac8:7e84:0:b0:39d:fd1:5a1d with SMTP id w4-20020ac87e84000000b0039d0fd15a1dmr27687787qtj.169.1666792285482;
        Wed, 26 Oct 2022 06:51:25 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id b24-20020ac84f18000000b00397101ac0f2sm3211836qte.3.2022.10.26.06.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 06:51:24 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>
Subject: [PATCH net-next 0/5] Add PLB functionality to TCP
Date:   Wed, 26 Oct 2022 13:51:10 +0000
Message-Id: <20221026135115.3539398-1-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
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

 Documentation/networking/ip-sysctl.rst |  75 +++++++++++++++++
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
 net/ipv4/tcp_plb.c                     | 109 +++++++++++++++++++++++++
 13 files changed, 305 insertions(+), 2 deletions(-)
 create mode 100644 net/ipv4/tcp_plb.c

-- 
2.38.0.135.g90850a2211-goog

