Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869925B2AD3
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 02:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiIIAMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 20:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIIAMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 20:12:54 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726744DB1D;
        Thu,  8 Sep 2022 17:12:53 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s206so78024pgs.3;
        Thu, 08 Sep 2022 17:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=/rQu6+5HnbgkUpyFYWUjucFn5iCQq5GOig/6aL/DsM4=;
        b=CzRV4phGzHFgvshS4W8VvvpdJtPpa0IDFhCM+Ewf6zzyp6OpicXuFUYozQMepOtEKo
         8lMIyCH9yjm2PxbNPr06CoOxlhMclsDaDnkthJLpHo5Ys1ZaOKE7SJmV4r/KezbFSx6D
         sPN2QAtVuc9D1sWEvxeyIufvC5dwc4NxBBjZaZUkqisDz8LSJ8Ug3UumDbOX1sfNtiqp
         ncxwl83QC100vu/0pntYW0DiwZg9TZ725OIVgXz18zyERYwkieY5Aq/kAFuHP/+uy+sf
         w4UOLeMAEOw8pO6GXa4VXxdTnc8kKBXkdNPWcriI80bgFNmkbbE/4S1EOuCAq1AydKZK
         OGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/rQu6+5HnbgkUpyFYWUjucFn5iCQq5GOig/6aL/DsM4=;
        b=gF9DliFiQlem5CkjyEpIdw0m9QB1F8Xg/bsG9p0bNiguB79DZGfEde/UXh5KN/62tI
         /w57AVEzEJEFfAhLv+UMMQrn2AXsTw+viS/psbE7hYAPMGo7U4QgJJxcL4rI9LAtttGJ
         2ADA/PLzN4OB5vx7PLqv41jjigZIu21veCooO7Cix6cAdrC/b3V5gx/JZOxeC3WZ5dSa
         niMWvfh/W/u5IGfzZXRhTbnKzyLWr69x/CJOWXNiWqhOshhTSfe3PWTsC0XLeVsAJYob
         ufyQWRhyFtyTwnTTGGE2V63AimHFKTgJSRYRgMEtTtPpmHb8GPcwgwvRY54vf5tJnltf
         7kbQ==
X-Gm-Message-State: ACgBeo3pyfj8fw4enHVtmh1YKstu8fjSKFH6w3ZcGmyJcXEe/2bvxs4Q
        pW91pDmf/JSER8Z4JwhVo94wWrzvu9mumA==
X-Google-Smtp-Source: AA6agR7nYWD98FDnPGbme+lBkIsUDkHL/tX8O7zjWjzsDBiQrGcKDr5McH/yH/pEJBcXS9pzifNJ5A==
X-Received: by 2002:aa7:80d3:0:b0:52b:9237:a355 with SMTP id a19-20020aa780d3000000b0052b9237a355mr11374235pfn.73.1662682372854;
        Thu, 08 Sep 2022 17:12:52 -0700 (PDT)
Received: from localhost (fwdproxy-prn-002.fbsv.net. [2a03:2880:ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id bv6-20020a17090af18600b0020036e008bcsm156680pjb.4.2022.09.08.17.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 17:12:52 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [net-next v4 0/6] net: support QUIC crypto
Date:   Thu,  8 Sep 2022 17:12:32 -0700
Message-Id: <20220909001238.3965798-1-adel.abushaev@gmail.com>
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
 Documentation/networking/quic.rst      |  215 ++++
 include/net/inet_sock.h                |    2 +
 include/net/netns/mib.h                |    3 +
 include/net/quic.h                     |   63 +
 include/net/snmp.h                     |    6 +
 include/net/udp.h                      |   33 +
 include/uapi/linux/quic.h              |   68 ++
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
 security/security.c                    |    1 +
 tools/testing/selftests/net/.gitignore |    1 +
 tools/testing/selftests/net/Makefile   |    3 +-
 tools/testing/selftests/net/quic.c     | 1369 +++++++++++++++++++++
 tools/testing/selftests/net/quic.sh    |   46 +
 24 files changed, 3636 insertions(+), 2 deletions(-)
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

