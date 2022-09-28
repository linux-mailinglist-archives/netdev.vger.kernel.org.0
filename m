Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD2D5EEA17
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 01:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiI1XVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 19:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiI1XV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 19:21:29 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B091431378
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 16:21:28 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id y2so8933111qtv.5
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 16:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=88dorG/WRQJB/XicIkfUTuz0A9yUzHdVFNlvpyOdr+Y=;
        b=n2+/wszcCWX38nnfqrROvCXZLwx1vlwlUniDxpseaUjUCssGuGceXNxjMoejXXzPWa
         xcynKl38c0+pBPn4A/6LIwJNdY3OuLxy7PLZkAmPTV1XEorx0iWtd/oY+q55fXYEzP32
         ZSR9V/VRW9prIVX6TRNdnSMbbfDiRayLQlubcYG2IV+R86OcH3OnG/2mm7j6zZM09mIe
         P98TTHbPmqjtjROPmC3vO8PA7hm20Dz5fz/k3dtWnXUSuF7tFe+Zz0yqygS233TBLgWh
         UoMRogLgA7YfFpC3JqjBI+ySK2/ltB1lyT2ueFW9QO4myd+U5ufVxYN6qffxeyUqdvND
         +nbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=88dorG/WRQJB/XicIkfUTuz0A9yUzHdVFNlvpyOdr+Y=;
        b=L653T5YwBuo2fKCy4eKWK8MB/Ec1gqJCiY1p3LPaWxHEmXTBdDVQCgI0K6vWZAbNU2
         LDQoLU6dWnWjUeIcT9ZT/2kd/ISWv8qNQe/hMmyUdvtLqqzwEosIx0Ja3JJDMheJ0KLA
         ABwyO0j0apZGopud2TtU2cuAx/Sqd9fL6AiG00CDa23o7GAS8a1awmFBIsT/zjftbuqP
         Pt7gsNyS3ol4xoVcIuhElLMoeUa+s0+/n/qZZSv2tYmdZSA0uEAhN5yyBDorodVAMDMi
         z1Y7fv6JKw7GuqfwkkHH8b2SM24Y6tMAet8675DDQLenRBHwp8zc5e96NHs9WXmAV5dk
         1Mxg==
X-Gm-Message-State: ACrzQf0pn6KbS+IP8x5WDJPkNVO3vCLumWW4bZzIQ3XbFFuwOcxgTpjw
        X8zMHU1O5FCo7vTtSojFPWsX8Ux3CY0=
X-Google-Smtp-Source: AMsMyM57fjI5W/rZ90NxLO+FHBEXyk3gpNTTdDaar5gUoRHv9Fj6khgOtmhjexgs3pcBOge14LkxKA==
X-Received: by 2002:ac8:5a15:0:b0:35d:ef5:811a with SMTP id n21-20020ac85a15000000b0035d0ef5811amr162253qta.667.1664407287783;
        Wed, 28 Sep 2022 16:21:27 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id t18-20020ac86a12000000b0035d43c82da8sm3919837qtr.80.2022.09.28.16.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 16:21:27 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>
Subject: [PATCH net-next 0/5] Add PLB functionality to TCP
Date:   Wed, 28 Sep 2022 23:20:46 +0000
Message-Id: <20220928232051.3728844-1-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
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
2.37.3.998.g577e59143f-goog

