Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0C458B2F3
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 02:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241368AbiHFAMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 20:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiHFAMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 20:12:08 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1691CF;
        Fri,  5 Aug 2022 17:12:07 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f65so3877179pgc.12;
        Fri, 05 Aug 2022 17:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=2OPxgYF4D6h5wjZImTyJGUOKy1Actvd35pc3Pp0CfsA=;
        b=R6IiMOxo6nk166hYodD1UaZKm62f3UMNK0sHQqoMGpQwCRijpo/+vByx5eX2BrBTpn
         MKQvZGR/cQDsnP/falppuXzOQok0zRedWFlFdvXzqfGs8uUbCR0W2Uam8ZSl4xPdP9Ns
         gwsYu/6EkvrWbish+OX9oN9y0NtFsfB9ynwvAkGNSjkKQ3dhb8mwnHWMuK6Yfbzt9c08
         YAPggUW2LmSjveSWAs1hOR1ZsIAzEOTgYZMWqus8McB3r6i5W64vA/9OWd6+dezj8SB+
         noOivZ/WwpsUvFUNrzcToIeVtkzI+rwRKROu2Gv+rFuSrEVCpBiFPhLf4RVk/nqsf3Kp
         kbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=2OPxgYF4D6h5wjZImTyJGUOKy1Actvd35pc3Pp0CfsA=;
        b=QCcO8u/v5LgqTfIZobVOi96783JrAQAJSFUBovKB9SnZumY7J3uZ+Au23L8KO17dLW
         eoEkVvNn7SJeib/h9qLBKwxbi/iknYRg9dUvL5YkSHqRhnHDcbgN95mKmPCpqsZswgeF
         3+8W82p9cwcVYHOsb+sc4SFx1GrkwUjH0BJHsilok9ioUkP1bBI4p/Hf5kkgAeXleJYt
         /6mnqiIsPjo0oY9wpZF8u+yTfdIPPL2wfL4YQH2hvDbUZu6QmdJ0oU+sBCyfkbg0tNd5
         NzL6EUgh7XnTs9YOJFL7qxF04JDQZsa0ZECiCb6ItaBBhD0xj5bqtbpLCzSJBwyQp/YJ
         7erg==
X-Gm-Message-State: ACgBeo37OXArbr2U2MHKK+SzLThOodnIZQB3Xj0FgHKYV6uVbhv+xHYt
        OIoKkI4cddtqcuKDECkoH1A=
X-Google-Smtp-Source: AA6agR6hAeAi+xVVv9gTwp9NeZdxhn/kJD4CsCtYZ4lChRjbLM6AQC27qNZLx/sDI9IPUQZSrkuD/Q==
X-Received: by 2002:a65:5644:0:b0:41c:5b91:9ba with SMTP id m4-20020a655644000000b0041c5b9109bamr7522931pgs.553.1659744727155;
        Fri, 05 Aug 2022 17:12:07 -0700 (PDT)
Received: from localhost (fwdproxy-prn-116.fbsv.net. [2a03:2880:ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id m14-20020a170902f64e00b0016dc0a6f576sm3541026plg.250.2022.08.05.17.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 17:12:06 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC net-next v2 0/6] net: support QUIC crypto
Date:   Fri,  5 Aug 2022 17:11:47 -0700
Message-Id: <20220806001153.1461577-1-adel.abushaev@gmail.com>
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
  v2: Moved the inner QUIC Kconfig from the ULP patch to QUIC patch.
  v2: Updated the tests to match the uAPI context structure fields.
  v2: Formatted the quic.rst document.

 Documentation/networking/index.rst     |    1 +
 Documentation/networking/quic.rst      |  186 +++
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
 tools/testing/selftests/net/.gitignore |    3 +-
 tools/testing/selftests/net/Makefile   |    2 +-
 tools/testing/selftests/net/quic.c     | 1024 +++++++++++++++++
 tools/testing/selftests/net/quic.sh    |   45 +
 23 files changed, 3161 insertions(+), 3 deletions(-)
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

