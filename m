Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90A4441E50
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhKAQiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbhKAQiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:06 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDFAC061764;
        Mon,  1 Nov 2021 09:35:33 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id f4so8051315edx.12;
        Mon, 01 Nov 2021 09:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xTuLF9iVakUmuqWJrh4h5lRJip3NOmzubsD/v0KQcZA=;
        b=T8gIzMpdWGBM8kuxCSO4l070P9M6hFP1KV5ycRboUYiAyHs5+Eazlo2ln308KwaGC4
         RrtM9mvVe9/pcD5rzoJn3RxS4LdxrS45B55llXmQbsfXbqzJ54x6MY2O6Jy6a5fBTd0Y
         gTtO8gidgL0OzVpvqz77kC679fQN8w5xGReKOCGXE2KQF1EJpGWO6jpN+B3UCYN8vd63
         v0cA3oV1Awcbfqz34Vz8WnDNoX6t5LR6CmX9Ju4QG0ITMlB9trsGp6aQrSiS/7LWhbwm
         Yg5JfWIvwqxexZ8CCzyoJleuODx5CFn96ppw0UCQghtJK8HDWEnxjj8LWVBq8nx2qMUm
         OIVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xTuLF9iVakUmuqWJrh4h5lRJip3NOmzubsD/v0KQcZA=;
        b=yHh9o9objjWqWg0ybY/ifqwyD8Yy1cWhFIzkvgKUOHYi2jPgoieSe0PHnPcIiBFkHV
         M0vypFlACu9GnmUEU84Jmm/v8Q71bPfHqbpvhNvcBcqD1RIMnIs0+6jeheBEf3D1KYxe
         aCStpPxMB6qMVNdGsW+dYiY9m5+261pgU8yMzQsj8Z61rF/qIb3nKMxLXikxG59LkAfv
         8gF2OfYLP3+w2hwrxBNoXSMivL42X263AlM6dL3nFBBNppF6qnJBsMGRIv0xs5IF/cna
         YJQPBCTqZAXNN0FDumZMmNE4MxxD1Bebl4nP4hjcf06eeT64O8zG2Ryl+SuQcAcVmh9A
         pPog==
X-Gm-Message-State: AOAM533vP1My8I9OWB3qIAINCxDIukTzILZjrqCfpQDyRGqC27VQiUg2
        YRms8uKbDEj4n79BAkcDrCs=
X-Google-Smtp-Source: ABdhPJyODvLSsQ4JQXkU3p/4tllmQ+38niAeq7V4lwVgsOC8pBRcEc8SDGTVcvDdXqoUcamtz5vqYw==
X-Received: by 2002:a17:907:e94:: with SMTP id ho20mr37172507ejc.103.1635784531732;
        Mon, 01 Nov 2021 09:35:31 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:31 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/25] docs: Add user documentation for tcp_authopt
Date:   Mon,  1 Nov 2021 18:34:37 +0200
Message-Id: <19d25c794767ece0522133554577a7cb80fb588f.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .rst documentation contains a brief description of the user
interface and includes kernel-doc generated from uapi header.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/index.rst       |  1 +
 Documentation/networking/tcp_authopt.rst | 44 ++++++++++++++++++++++++
 2 files changed, 45 insertions(+)
 create mode 100644 Documentation/networking/tcp_authopt.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 58bc8cd367c6..f5c324a060d8 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -100,10 +100,11 @@ Contents:
    strparser
    switchdev
    sysfs-tagging
    tc-actions-env-rules
    tcp-thin
+   tcp_authopt
    team
    timestamping
    tipc
    tproxy
    tuntap
diff --git a/Documentation/networking/tcp_authopt.rst b/Documentation/networking/tcp_authopt.rst
new file mode 100644
index 000000000000..484f66f41ad5
--- /dev/null
+++ b/Documentation/networking/tcp_authopt.rst
@@ -0,0 +1,44 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+TCP Authentication Option
+=========================
+
+The TCP Authentication option specified by RFC5925 replaces the TCP MD5
+Signature option. It similar in goals but not compatible in either wire formats
+or ABI.
+
+Interface
+=========
+
+Individual keys can be added to or removed from a TCP socket by using
+TCP_AUTHOPT_KEY setsockopt and a ``struct tcp_authopt_key``. There is no
+support for reading back keys and updates always replace the old key. These
+structures represent "Master Key Tuples (MKTs)" as described by the RFC.
+
+Per-socket options can set or read using the TCP_AUTHOPT sockopt and a ``struct
+tcp_authopt``. This is optional: doing setsockopt TCP_AUTHOPT_KEY is
+sufficient to enable the feature.
+
+Configuration associated with TCP Authentication is indepedently attached to
+each TCP socket. After listen and accept the newly returned socket gets an
+independent copy of relevant settings from the listen socket.
+
+Key binding
+-----------
+
+Keys can be bound to remote addresses in a way that is similar to TCP_MD5.
+
+ * The full address must match (/32 or /128)
+ * Ports are ignored
+ * Address binding is optional, by default keys match all addresses
+
+RFC5925 requires that key ids do not overlap when tcp identifiers (addr/port)
+overlap. This is not enforced by linux, configuring ambiguous keys will result
+in packet drops and lost connections.
+
+ABI Reference
+=============
+
+.. kernel-doc:: include/uapi/linux/tcp.h
+   :identifiers: tcp_authopt tcp_authopt_flag tcp_authopt_key tcp_authopt_key_flag tcp_authopt_alg
-- 
2.25.1

