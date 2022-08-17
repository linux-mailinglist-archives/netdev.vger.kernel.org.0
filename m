Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F036597790
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 22:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbiHQUJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 16:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238004AbiHQUJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 16:09:48 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3101707C;
        Wed, 17 Aug 2022 13:09:47 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id r15-20020a17090a1bcf00b001fabf42a11cso1665106pjr.3;
        Wed, 17 Aug 2022 13:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=OMLQK+bB28GP1BYxwXfZjj/ffD/QvSECuf9uKxzzyg8=;
        b=oG9fUL3NelPte1UzZGQfj8810HxQpzvC+JvheiCHU1a26N0A5543ttHw50UjbGoeII
         lycIfnI08TQH9Nv+h7p+q9sCPRpEXRLL+XAraL86FPUJAfm89KTn/s6A0IMZfqYC9fh3
         1/SjUL6ySk6O8kwg4j9t5m+2fWI4FRPc8yM6IGhkNujPFdXRxHJ+dYxhV4EaAcYDNRGC
         H8YX8E08aYNvMvUclnwzIOk9XeWwhIlBwSrFk2zJ/6SV08kxVlqiKAuKghf4yO24yKxC
         peg+b1Sd0QH8dw2u29ZTwdbsQCcOUspZLHyMaufwZtEXm9GxN6ea9BAAPu6MmU3sL+Ih
         xT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=OMLQK+bB28GP1BYxwXfZjj/ffD/QvSECuf9uKxzzyg8=;
        b=3UpuuD6gAx9DR/7vBBalY2om3Hzg+WJtYIMk/0dl09Di7aa4LXqdUaGFZABkfKVNyQ
         BqA772Kf1LEgLp4iXTpLEvPtKw/BAfLqX/wzlFugV9Tq56h8hJ47bnq+YZuHQGqBR4bb
         mZjeZl/RCz3l8gIaD84c6A1szGB6UUx7JeppHSTnba564w+JqkSLqDZPziDcREy4Xdt0
         wf8srjwHiH8rQNzzPTDx0x28JJrs+0Cy7GlmPmyaU/elsGgA28W0l1Xr+NwIOt0rEcyA
         y932z0VuK7RUaHi+iiyFbYAT8m0/7B8yg7opKRhNlMQTnTAWkTKIosVPlZ1PZ+Wwd80W
         Fgew==
X-Gm-Message-State: ACgBeo2N4V7zw8WR9TE+RD0g52i7gka1epw31fGLmc9mZdIhWx9NtyMf
        QTvM6EGnwDNJ9BzKrGKMLKc=
X-Google-Smtp-Source: AA6agR6TfJAgaWebzxeSTK6qvngdSuLxfysK21V1xKujdVtIa3GoYs5OGuiYdlC82cSySphWzGCD5w==
X-Received: by 2002:a17:90a:1912:b0:1f7:8c6c:4fde with SMTP id 18-20020a17090a191200b001f78c6c4fdemr5466437pjg.8.1660766986529;
        Wed, 17 Aug 2022 13:09:46 -0700 (PDT)
Received: from localhost (fwdproxy-prn-002.fbsv.net. [2a03:2880:ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id b23-20020aa79517000000b0052bae7b2af8sm10876830pfp.201.2022.08.17.13.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:09:46 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [net-next v2 0/6] net: support QUIC crypto
Date:   Wed, 17 Aug 2022 13:09:34 -0700
Message-Id: <20220817200940.1656747-1-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <Adel Abouchaev <adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

Adel Abouchaev (6):
  Documentation on QUIC kernel Tx crypto.
  Define QUIC specific constants, control and data plane structures
  Add UDP ULP operations, initialization and handling prototype
    functions.
  Implement QUIC offload functions
  Add flow counters and Tx processing error counter
  Add self tests for ULP operations, flow setup and crypto tests

 Documentation/networking/index.rst     |    1 +
 Documentation/networking/quic.rst      |  185 ++++
 include/net/inet_sock.h                |    2 +
 include/net/netns/mib.h                |    3 +
 include/net/quic.h                     |   63 ++
 include/net/snmp.h                     |    6 +
 include/net/udp.h                      |   33 +
 include/uapi/linux/quic.h              |   60 +
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
 tools/testing/selftests/net/.gitignore |    4 +-
 tools/testing/selftests/net/Makefile   |    3 +-
 tools/testing/selftests/net/quic.c     | 1153 +++++++++++++++++++
 tools/testing/selftests/net/quic.sh    |   46 +
 23 files changed, 3267 insertions(+), 3 deletions(-)
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


base-commit: fd78d07c7c35de260eb89f1be4a1e7487b8092ad
-- 
2.30.2

