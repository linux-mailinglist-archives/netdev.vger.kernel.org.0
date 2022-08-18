Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0D7598D46
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345715AbiHRUBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiHRUAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:22 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4ECD11C8;
        Thu, 18 Aug 2022 13:00:21 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id kb8so5194619ejc.4;
        Thu, 18 Aug 2022 13:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=6LjuhIC/pbHS+8spopbsWARAYbdtibeJdvNxgS2b0Q0=;
        b=DnEEg/NVdSgE+1sW6RKuwbjtxKGZpWutEE0ukCallUqZPOtl5DGAY/60C/teKchf9B
         jMwhuG22I9Ro7Xhqu4aM1nDNACE70KAeTQOgM1050z/FQ5AtSNyfdJXQuZUu6Wko3aur
         c4kdKHPUSPJpYLF4YppAyrsKg+Yu6dbzXmZ1DhtX7j3YCGIJMoVb53guIlO2VtJOpA2F
         jQNml7DfIPOTBaKwhiOR6pw+px3KYtbsw0jNW/P+l2M+n6DiE00uQ5HKKxGwtkKR3FF3
         HLoPu5AZjj+DONA0RrTp2w7EtjcVAYJD/ddZUT9vB35pr/PO5SIG4rVAd9IVd40+63vs
         x+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=6LjuhIC/pbHS+8spopbsWARAYbdtibeJdvNxgS2b0Q0=;
        b=KuA5VDrkdz9lBzETOK5EQeP/yh1sHAJ6hf6UAmV9Y3QlB2dKz2YQM71p2PCPpVIXsv
         JCkoMEdoRkBRkh+CzvsTAo1aOaOr3TU6QWCZ6CbayrdFp4kk7fxMoKlKfMh7T6v0KK1j
         GTgpjkgK8qSS154BdWFLjS0w2+CPbumfc5ZYNEWb0FyiaYfQnuH4u5BCq06IgZZtMbQw
         xHZbN8Zzz5qp8N/TnzFDvAksN7qVtmPRkGD1zH2jwPWeYDHbC6NzdK3nP5gOwfTYB62J
         yxEEIDBW8RgxaA9T0jiqqtDuFLqk8P7vY3D2kG3uu7Xmtc7PSZVOr3nmc2I+1HN2KbH4
         Cp0A==
X-Gm-Message-State: ACgBeo2P+vEL/Q+KXHuToJ4d5+oe22qvG0Vmx0173KPp3qfCYup2Q/Lj
        Z03a1AaUcM8EuchUztfz4sw=
X-Google-Smtp-Source: AA6agR7pucv+3lef3sfcTrOznJ+6O5RQdTj3b/E418awSUW7na9pwOsT7lFDV/VmSwVA0AfCvoxARQ==
X-Received: by 2002:a17:907:a40f:b0:730:c4ce:631c with SMTP id sg15-20020a170907a40f00b00730c4ce631cmr2743974ejc.362.1660852820274;
        Thu, 18 Aug 2022 13:00:20 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:19 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 02/26] docs: Add user documentation for tcp_authopt
Date:   Thu, 18 Aug 2022 22:59:36 +0300
Message-Id: <8594c8d9de865b7d4d6ec3a783758fec23a70104.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
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

The .rst documentation contains a brief description of the user
interface and includes kernel-doc generated from uapi header.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/index.rst       |  1 +
 Documentation/networking/tcp_authopt.rst | 51 ++++++++++++++++++++++++
 2 files changed, 52 insertions(+)
 create mode 100644 Documentation/networking/tcp_authopt.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 03b215bddde8..294b87137cd2 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -103,10 +103,11 @@ Contents:
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
index 000000000000..72adb7a891ce
--- /dev/null
+++ b/Documentation/networking/tcp_authopt.rst
@@ -0,0 +1,51 @@
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
+Individual keys can be added to or removed through an TCP socket by using
+TCP_AUTHOPT_KEY setsockopt and a struct tcp_authopt_key. There is no
+support for reading back keys and updates always replace the old key. These
+structures represent "Master Key Tuples (MKTs)" as described by the RFC.
+
+Per-socket options can set or read using the TCP_AUTHOPT sockopt and a struct
+tcp_authopt. This is optional: doing setsockopt TCP_AUTHOPT_KEY is sufficient to
+enable the feature.
+
+Configuration associated with TCP Authentication is global for each network
+namespace, this means that all sockets for which TCP_AUTHOPT is enabled will
+be affected by the same set of keys.
+
+Manipulating keys requires ``CAP_NET_ADMIN``.
+
+Key binding
+-----------
+
+Keys can be bound to remote addresses in a way that is somewhat similar to
+``TCP_MD5SIG``. By default a key matches all connections but matching criteria can
+be specified as fields inside struct tcp_authopt_key together with matching
+flags in tcp_authopt_key.flags. The sort of these "matching criteria" can
+expand over time by increasing the size of `struct tcp_authopt_key` and adding
+new flags.
+
+ * Address binding is optional, by default keys match all addresses
+ * Local address is ignored, matching is done by remote address
+ * Ports are ignored
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

