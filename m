Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56005890A4
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbiHCQk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiHCQk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:40:56 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FAA13CD9;
        Wed,  3 Aug 2022 09:40:55 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c139so16959285pfc.2;
        Wed, 03 Aug 2022 09:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=plBH5pz1kX322+xbVZ52UtO9XzB3g5pnJVIVfiUhluQ=;
        b=KvdwfZGxKAj7YuLChZ56WyD9qv4UcBjE4HFQxqIobbSpUZ5R3nToqHka89cWqPYAnt
         FxeDjyilVe8bvEuKbQDpa2dFfxqasjS7xWbv4b9yyhFHp6Oy/4WaPerT9KtaHVDlZcig
         zTxvnk1h4dLLyvGdpRxap0jwLzhmqodEnbV0MUI8TvHY9ka1+YBfPeEXWs9eTwOlxqiD
         dMnWaTW87CGWHNfbxAoqi7L5max1iKLLE7nx7QV8NNEmy6kPDJUQErkGGPSBa0343oFh
         kBzrtQUrSN9Z2kHBLk2I4tRc/jNC1LTc8hZvT/4VO+26inb4PTJTGJoiEeCdZtVRHVxV
         C9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=plBH5pz1kX322+xbVZ52UtO9XzB3g5pnJVIVfiUhluQ=;
        b=YOwdFE+++TQJWU1qVGXdNbhVw1aLlFFT1tKYJucboNkBvz1tuE2gzADHUvbBZjEM3P
         p4MzpyaNDfMs16V+G4M5Hd19jiDakxYsGHGoe0mxk5HAte7E2WLZQ8zsFvZFZxZE3FRa
         hqJXqRj2OWnC1Ws49NdrN1B6w8KsfSlgobv9+QWI9/bJrl2XcTM/zr+KwKQDxE0Kreeb
         MVBdyUvRbFCBWyQV0IoU7f4oNsHRCZT/PyUj6CqzUkJIYbDcbN5Am63GET7OT1hb1E/a
         YCVz9kQV8QyWMLpd6pfSkBPkJkVeNhb8nOqLt4nj3BfeMFiJtkeqWEIQ6S2493aqOj6X
         p5NA==
X-Gm-Message-State: AJIora8Y0Qjxyi/RVpNaz8F8cDDF0ZHKsxiswk+QCsrOlGO4pnk/q0Wi
        uCkRSW4hv+3kV6c/g8ffRGpZKtdTlt5fTnAO
X-Google-Smtp-Source: AGRyM1tPRq9StTkyP8E5BpBDQnpGfYSyLpJvuqlbuSZmRLGpcEtlRZ1o0OGknQAgZKhjmkUWRlMfiw==
X-Received: by 2002:a05:6a00:a11:b0:52b:fb6f:b614 with SMTP id p17-20020a056a000a1100b0052bfb6fb614mr26242645pfh.33.1659544855312;
        Wed, 03 Aug 2022 09:40:55 -0700 (PDT)
Received: from localhost (fwdproxy-prn-009.fbsv.net. [2a03:2880:ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902d50a00b0016dc1df9bf7sm2219695plg.27.2022.08.03.09.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:40:55 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC net-next 0/6] net: support QUIC crypto
Date:   Wed,  3 Aug 2022 09:40:39 -0700
Message-Id: <20220803164045.3585187-1-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <Adel Abouchaev <adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
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

 Documentation/networking/quic.rst      |  176 +++
 include/net/inet_sock.h                |    2 +
 include/net/netns/mib.h                |    3 +
 include/net/quic.h                     |   59 +
 include/net/snmp.h                     |    6 +
 include/net/udp.h                      |   33 +
 include/uapi/linux/quic.h              |   61 +
 include/uapi/linux/snmp.h              |   11 +
 include/uapi/linux/udp.h               |    4 +
 net/Kconfig                            |    1 +
 net/Makefile                           |    1 +
 net/ipv4/Makefile                      |    3 +-
 net/ipv4/udp.c                         |   14 +
 net/ipv4/udp_ulp.c                     |  190 ++++
 net/quic/Kconfig                       |   16 +
 net/quic/Makefile                      |    8 +
 net/quic/quic_main.c                   | 1446 ++++++++++++++++++++++++
 net/quic/quic_proc.c                   |   45 +
 tools/testing/selftests/net/.gitignore |    1 +
 tools/testing/selftests/net/Makefile   |    2 +-
 tools/testing/selftests/net/quic.c     | 1024 +++++++++++++++++
 tools/testing/selftests/net/quic.sh    |   45 +
 22 files changed, 3149 insertions(+), 2 deletions(-)
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

