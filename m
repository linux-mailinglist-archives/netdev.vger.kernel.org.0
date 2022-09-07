Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F414E5AF91B
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 02:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiIGAtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 20:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIGAtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 20:49:47 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EC8286EB;
        Tue,  6 Sep 2022 17:49:46 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p18so12924391plr.8;
        Tue, 06 Sep 2022 17:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=ICzw1FfKchRebdUezT3tx3j+y8ZDKeGNq7iW51YsKEY=;
        b=b0yaSApvbWwmy6NGs7G/zTBaUcmCmcUXu7hWODPO/kVYxHLu4RadTuLI+M7MZMLgZF
         KIZtj6o65Ez/IbPGiOwQaBTvQ5jLJNEgpVH5KRKh4jv45KPq9yUW8iq1iaqWPtb8FO9K
         OZzI1jujiGutOhT0zgfWN68uFUndKBgb7zl0PtV45AsdVE5Pkbd7mENkUhkBri0SRwv3
         0gW0VeXv69BirBgLnCFzpqKNoSxAjPdSRlGOi+acK9v1zH2RzloS8JhPqXdIKGqao4hs
         bB0SZt0WBrPJbfrqG1nLkKJ/SYPuiiHMkNwSzA8XPGmHK+A5lJhy7XW5jVr66ghVmj4k
         VZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ICzw1FfKchRebdUezT3tx3j+y8ZDKeGNq7iW51YsKEY=;
        b=n96IDqfEnRo288b+SmUoLA8aj32sx6hjNm2pmHjQSA1es9Xx4dmziGkwHBlwKgp5/n
         e1B5Dp2RdYfuh71IWLKWNTNk6oJtQBaLtq3NvLNIh0KkIf0kwvD64Lkqy2vurQT9sHdB
         fF0HEt5Go6nwK2yQ2xdvmqC7n3+VrCJdGDhzKdTlHT8o7VUFlQpbGJSm9a4Io9ilQyrf
         k8TWH+fY1/gqHLTRPAbmZMrHg7E2e2vPsh+cht0G8al8my05hW/Lv39ZYvsJSmLq4fzm
         4Mfp0KkPNHEwf99orLd+Dm56qrG6x+jK4zfRYLAbfqM9WcaUWbrsbbINS0mUdnq3bfy/
         M3oA==
X-Gm-Message-State: ACgBeo3+zIc+hdroPiFgtZH9z9BTR+MUNNVn0BmCxSAIkvYyeQmK3xAY
        nv/xtkKXffxIZlpUAxE7Skk=
X-Google-Smtp-Source: AA6agR55GFyoNi+VQtTHA4mYvUfWFQKgNzYCTubeTqE/5MI+IEgFVVCQ8+hyGkSic1HbNvFeeJdwoQ==
X-Received: by 2002:a17:90b:4a06:b0:200:8997:c292 with SMTP id kk6-20020a17090b4a0600b002008997c292mr1143215pjb.145.1662511785497;
        Tue, 06 Sep 2022 17:49:45 -0700 (PDT)
Received: from localhost (fwdproxy-prn-008.fbsv.net. [2a03:2880:ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id p186-20020a625bc3000000b00535d3caa66fsm10901400pfb.197.2022.09.06.17.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 17:49:44 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [net-next v3 0/6] net: support QUIC crypto
Date:   Tue,  6 Sep 2022 17:49:29 -0700
Message-Id: <20220907004935.3971173-1-adel.abushaev@gmail.com>
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

Adel Abouchaev (6):
  Documentation on QUIC kernel Tx crypto.
  Define QUIC specific constants, control and data plane structures
  Add UDP ULP operations, initialization and handling prototype
    functions.
  Implement QUIC offload functions
  Add flow counters and Tx processing error counter
  Add self tests for ULP operations, flow setup and crypto tests

 Documentation/networking/index.rst     |    1 +
 Documentation/networking/quic.rst      |  211 ++++
 include/net/inet_sock.h                |    2 +
 include/net/netns/mib.h                |    3 +
 include/net/quic.h                     |   63 +
 include/net/snmp.h                     |    6 +
 include/net/udp.h                      |   33 +
 include/uapi/linux/quic.h              |   66 +
 include/uapi/linux/snmp.h              |    9 +
 include/uapi/linux/udp.h               |    4 +
 net/Kconfig                            |    1 +
 net/Makefile                           |    1 +
 net/ipv4/Makefile                      |    3 +-
 net/ipv4/udp.c                         |   15 +
 net/ipv4/udp_ulp.c                     |  192 +++
 net/quic/Kconfig                       |   16 +
 net/quic/Makefile                      |    8 +
 net/quic/quic_main.c                   | 1533 ++++++++++++++++++++++++
 net/quic/quic_proc.c                   |   45 +
 tools/testing/selftests/net/.gitignore |    1 +
 tools/testing/selftests/net/Makefile   |    3 +-
 tools/testing/selftests/net/quic.c     | 1370 +++++++++++++++++++++
 tools/testing/selftests/net/quic.sh    |   46 +
 23 files changed, 3630 insertions(+), 2 deletions(-)
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

