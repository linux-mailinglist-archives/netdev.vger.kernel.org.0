Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68BF3E4E8A
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbhHIVgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbhHIVgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:36:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BEAC0613D3;
        Mon,  9 Aug 2021 14:35:51 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z11so26792688edb.11;
        Mon, 09 Aug 2021 14:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xTuLF9iVakUmuqWJrh4h5lRJip3NOmzubsD/v0KQcZA=;
        b=OBPJ0qXOXuC8Q2RURZH5gWPAOhnjSas8fv7kEniK06s2zzigGPhoNyIcuhNZmPQNWB
         cyDZWQg/C9ZcsTPGVkHVCSFZdGeRIlkqoKa08+ORKV9ZuFLidfau9O7JHQck/QXUhAeU
         4hTu4Gg1br5ghQ8ETMKeKvdboF+TudIEGDqGbG+vDwGGpE2Q0SGGw9Z/H0dxRCS2Yd8I
         7/UUmIGcdoyKTO9HW9Ol2NvZtFHyi7UTDSDmRpWbM8JVE9LXnT+hMfsvP4g60yczy620
         7yvnZd8DdLPR87xM98ncW2KAhQ2A4yL2kKStpa2JTCouu3otz3ErOVlMUMi8Ae2xkbFl
         WhdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xTuLF9iVakUmuqWJrh4h5lRJip3NOmzubsD/v0KQcZA=;
        b=E88f/J+xOJsQp0E9WQdd+l/IfcMbreXmuRjBMC1QKDE2nj3ZVyiMTMQRJ1htxfCmsG
         8Q8p3TlQZ5LKZwgwr2FHGHEX0yEbF3uxoX+Cb9icBJlrNg+VsqtAyL88sc+MonYPNsOd
         ymtP7/FPt8+wpIYgQgJzfsNpi5illhk0MhjAjfsAvfR6hAzJE3HZuBAghSci9gcUauBf
         kD9yqZJspTh9nc2QTlSsRDyAhcM3aJDa3hyiLDhFtYeouPCRWLuFlWbf46iyygpHJw7T
         AOKTv/pODJnbE0IahiMqiRyuq8w62jN6NAOoRPX1y1vFw1SqzM1xY7ktAr94y/f04MTe
         WuyA==
X-Gm-Message-State: AOAM5317SAt819thk8qivBx0h8LVJSPAt8fl/DJpGrsDJ5HAaBz1A7f8
        7+NGbAX54yKTVP/6JbAAGRHqwGXwbvJ2zdcBVY5Q0A==
X-Google-Smtp-Source: ABdhPJwTcFW1pOJ6TbegiE/FAa/N0N0L3ttk2Zvoqrtul5wnWl+kps21MPw1urobkzOMri+YY4xjnQ==
X-Received: by 2002:a05:6402:1591:: with SMTP id c17mr453524edv.15.1628544949721;
        Mon, 09 Aug 2021 14:35:49 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:688d:23e:82c6:84aa])
        by smtp.gmail.com with ESMTPSA id v24sm5542932edt.41.2021.08.09.14.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:35:49 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFCv2 2/9] docs: Add user documentation for tcp_authopt
Date:   Tue, 10 Aug 2021 00:35:31 +0300
Message-Id: <deeaa47d9aff25edc87e120fde76cd001cd47118.1628544649.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1628544649.git.cdleonard@gmail.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
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

