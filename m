Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C345EF776
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbiI2OZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235319AbiI2OZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:25:07 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AC536866
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:25:03 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id g2so926277qkk.1
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=88dorG/WRQJB/XicIkfUTuz0A9yUzHdVFNlvpyOdr+Y=;
        b=APPXwF4NtZGSeDCsbSZtPn6RKhTGegIg3ygGqGCZdmmxzyED3TjrKtl1NxbxawHXQK
         5rd8La5YrkQibq3jGnLHhWnrWWAXfMRxCNM63FLe4q5lbv23ozvR1ss6ySPZgTokLVTe
         MyogOcgc8uXZOSllPaUFz23LE+9hcGuPc7UW3HR9Looyxhlh1mFg66yLT3uWF9t0o+06
         KRedo6PaEtgUnaPgOBsokOkmxXMx4W5aD0jjXqwBbZ46Wxc1xh7i+0PWzeo9euvGzlrY
         /xw/KqQPwK/l//cYXbArsMfLWZgyeMob06HJCVqv3hAcijW9slk/GSnT+HE087qlu4yI
         IeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=88dorG/WRQJB/XicIkfUTuz0A9yUzHdVFNlvpyOdr+Y=;
        b=wUuiI2lmE377PXp3SKDqGUzxNqZB+49gfDItgUySgnL6JCIeN0zjXuvEo+4Qd2rLPH
         LYMXRh0XFg0jXNGEUpVpeOXH2hsQXLes+Haw21fHoJY4vmYm7NO1hka1j9EaDynMrfU2
         CqbEcALuNFeo8wnKtyrJvOHrfmGvlHXz+D5g+wrSktP08wyugMtqN3M0KR2zUIpm2cPp
         Dlvkov9P8QyZ2xyyImAb9HmV47kj1vDU+O+4XdTnM1M0VAPej/+jwSoWPsiAEWsW4ean
         POEDwDij2M60asIUToQTvFuKCIEWlAkJf+d5E23uZun6lgfKbqLHygByDRl5aIkRSxto
         BFlg==
X-Gm-Message-State: ACrzQf1FnXpOCkyX/dV5r+GWbc4nClISZ1KWqG9Zz6qZU8h37W+tKOEI
        dVyIlcSeuWP58obwRnK4ifo=
X-Google-Smtp-Source: AMsMyM5K0f7FlUyqDA4s8+vVVXiIQ6UogOx6Tpg+6AW2B7SZElbDWJTlKCDYjvd6B1FXkQJnobPsAA==
X-Received: by 2002:a05:620a:b8d:b0:6ce:1be3:fee7 with SMTP id k13-20020a05620a0b8d00b006ce1be3fee7mr2325024qkh.725.1664461502716;
        Thu, 29 Sep 2022 07:25:02 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id z21-20020ac87f95000000b00342f8984348sm5889952qtj.87.2022.09.29.07.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 07:25:02 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>
Subject: [PATCH net-next 0/5] Add PLB functionality to TCP
Date:   Thu, 29 Sep 2022 14:24:42 +0000
Message-Id: <20220929142447.3821638-1-mubashirmaq@gmail.com>
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

