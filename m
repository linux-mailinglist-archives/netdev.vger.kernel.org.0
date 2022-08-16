Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B34596223
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbiHPSMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbiHPSME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:12:04 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5958604A;
        Tue, 16 Aug 2022 11:12:02 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 202so9920497pgc.8;
        Tue, 16 Aug 2022 11:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=liFs8n6Lu/HzFlGmuOa4aEOuz72eCnja5P6CZ/iawUM=;
        b=aV4JihLkSCrkWQ2WWHYbPCPzv7n3RSeOUJaHn7iVLr+xNzx29iKuztxQrcZA/xsIgA
         nU2JJ0B7zHIyzixGHxr4d36Y9zxRvrID2K+3+mOV1QcvxStJb6OGYLyV5gyKfIkydEpa
         79SAIfFYaB6VPpm50coHxQkaPECf7fUoCKi+azbuvZyjUdMmFLcC1bYs59gIyYVF7bWS
         icEvSnQOz67E3peRWmriGZTWCZ6ld8QHkZAvDNGVUoku6aigVaqzfanBY4u+WkQ8AfvQ
         dC6/tIg47f0BkBhrVar9vCOprGTuqcNVaEl3SMnTU51S/ueynAMrRvyaB/MQvNHSu1K0
         4c4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=liFs8n6Lu/HzFlGmuOa4aEOuz72eCnja5P6CZ/iawUM=;
        b=hqAciZr0D98dw4ieoyWHWj2E6MkDLhrj1VLb/GFFy7hyvJyMPWy/uftAreNjArCPIw
         bbzzSatPtzd9hh0Kj3L1KcE75hGy31f8O20z0DvYwsQE30LA8etsuOE5ibxPkmwf5kjk
         7Ojgm3BcPIph9w+fPcYgoDGxNE2EMR9lc2D8B+7+us/AMJid41R9qRpxqF3qypU3a6CH
         VuM4VEFiz1RG56eX7lUzH9sJnQDd9X1gKO1Cbb1Z9q82Duo2TyQQypGiVTupGtfma6+8
         6tA0fQwTkuLdTr/+x5s+fybDuv+yreDMk09/QoQllxp+eIa1GjMZ0Uh0tsjgCQaNngpr
         u9sA==
X-Gm-Message-State: ACgBeo1cBGsGMTAg9CVdx6zW+6MGYw079lTQKSsZmaYjR7c6U5+Pf8eq
        l5h+OC5Ko3Dzl8gE7mCY1oE=
X-Google-Smtp-Source: AA6agR5ILd5+mXTO48PnM3UaXgY2+suY+krd3+eqTRDJt/8MkJAX66nEdnNAC9xU9nFoZkaatrsoYw==
X-Received: by 2002:a63:e25:0:b0:41c:30f7:c39c with SMTP id d37-20020a630e25000000b0041c30f7c39cmr18672757pgl.147.1660673522381;
        Tue, 16 Aug 2022 11:12:02 -0700 (PDT)
Received: from localhost (fwdproxy-prn-008.fbsv.net. [2a03:2880:ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id f6-20020aa79686000000b0052a198c2046sm8751989pfk.203.2022.08.16.11.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:12:01 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [net-next 0/6] net: support QUIC crypto
Date:   Tue, 16 Aug 2022 11:11:44 -0700
Message-Id: <20220816181150.3507444-1-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <Adel Abouchaev <adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
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

QUIC requires end to end encryption of the data. The application usually
prepares the data in clear text, encrypts and calls send() which implies
multiple copies of the data before the packets hit the networking stack.
Similar to kTLS, QUIC kernel offload of cryptography reduces the memory
pressure by reducing the number of copies.

The scope of kernel support is limited to the symmetric cryptography,
leaving the handshake to the user space library. For QUIC in particular,
the application packets that require symmetric cryptography are the 1RTT
packets with short headers. Kernel will encrypt the application packets
on transmission and decrypt on receive. This series implements Tx only,
because in QUIC server applications Tx outweighs Rx by orders of
magnitude.

Supporting the combination of QUIC and GSO requires the application to
correctly place the data and the kernel to correctly slice it. The
encryption process appends an arbitrary number of bytes (tag) to the end
of the message to authenticate it. The GSO value should include this
overhead, the offload would then subtract the tag size to parse the
input on Tx before chunking and encrypting it.

With the kernel cryptography, the buffer copy operation is conjoined
with the encryption operation. The memory bandwidth is reduced by 5-8%.
When devices supporting QUIC encryption in hardware come to the market,
we will be able to free further 7% of CPU utilization which is used
today for crypto operations.

*** BLURB HERE ***

Adel Abouchaev (6):
  Documentation on QUIC kernel Tx crypto.
  Define QUIC specific constants, control and data plane structures
  Add UDP ULP operations, initialization and handling prototype
    functions.
  Implement QUIC offload functions
  Add flow counters and Tx processing error counter
  Add self tests for ULP operations, flow setup and crypto tests

 Documentation/networking/index.rst     |    1 +
 Documentation/networking/quic.rst      |  186 ++++
 include/net/inet_sock.h                |    2 +
 include/net/netns/mib.h                |    3 +
 include/net/quic.h                     |   63 ++
 include/net/snmp.h                     |    6 +
 include/net/udp.h                      |   33 +
 include/uapi/linux/quic.h              |   61 +
 include/uapi/linux/snmp.h              |    9 +
 include/uapi/linux/udp.h               |    4 +
 net/Kconfig                            |    1 +
 net/Makefile                           |    1 +
 net/ipv4/Makefile                      |    3 +-
 net/ipv4/udp.c                         |   15 +
 net/ipv4/udp_ulp.c                     |  192 ++++
 net/quic/Kconfig                       |   16 +
 net/quic/Makefile                      |    8 +
 net/quic/quic_main.c                   | 1417 ++++++++++++++++++++++++
 net/quic/quic_proc.c                   |   45 +
 tools/testing/selftests/net/.gitignore |    3 +-
 tools/testing/selftests/net/Makefile   |    3 +-
 tools/testing/selftests/net/quic.c     | 1153 +++++++++++++++++++
 tools/testing/selftests/net/quic.sh    |   46 +
 23 files changed, 3268 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/quic.rst
 create mode 100644 include/net/quic.h
 create mode 100644 include/uapi/linux/quic.h
 create mode 100644 net/ipv4/udp_ulp.c
 create mode 100644 net/quic/Kconfig
 create mode 100644 net/quic/Makefile
 create mode 100644 net/quic/quic_main.c
 create mode 100644 net/quic/quic_proc.c
 create mode 100644 tools/testing/selftests/net/quic.c
 create mode 100755 tools/testing/selftests/net/quic.sh

--
2.30.2

