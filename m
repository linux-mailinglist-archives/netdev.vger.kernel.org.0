Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B621746D267
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhLHLlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhLHLlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:41:37 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDE0C0698D1;
        Wed,  8 Dec 2021 03:38:02 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g14so7307822edb.8;
        Wed, 08 Dec 2021 03:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xTuLF9iVakUmuqWJrh4h5lRJip3NOmzubsD/v0KQcZA=;
        b=KIfVSl/0ggPg/bXLh4ZZRzQW73Rnp7fzeTUKk1TxyW1y9EsIgRoAsUIT+zNW1n/M5P
         Fb9RG5geL+Xuc0RDNCmvEOkdfwILkpGW+jC9+jTY3ma7zq8EtrlLtb9o/4aKGBbUPCnK
         2uTiPYsZ2OHoOM0cXRpd2gPqPysdcZFiFSZGbI60mC2xSyjna2PZQnA3Mpppe5L4JCB0
         a2TqrJFMz8fbIqlu6E2smxpjlC7KHMPlIisFodAD8SSKqR5lYbJ9G1hKqfH50KvSVr83
         XaBJHs2xcNxyAl/Mlt+dkyhnC0fDI1HQltku6chU+dwGNHDtpGh8K3iwoVq+MiWZ3X/j
         IKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xTuLF9iVakUmuqWJrh4h5lRJip3NOmzubsD/v0KQcZA=;
        b=jO8qqoF4VOe6qn4t249g31YFPr+2NiPADOENegOUQFx6jV8sKCfZ4SkL0yHQjK6Wyg
         egQ1Ef5pRlgELEp8RzFZ8gw2V15hy/ZEqGUOw0FxNYnw7XSlrJOUAIfPbwTvof3Xwve/
         XCbGtKoegNYqU4h2p/cUK5lHn5Zzdi/YJz8/7QTNeBTbW0KWipTZ4S2AI4TsONUhkKGe
         c71sGjJeOyfZdACztTiK4f4jvJYqgsYOTIpTU76pYLUjXDKj9Gs52WOjIFtXuavW2dAi
         wzBL+c4cbeBeWT2bpJepwfOK7DlnYknmgpG72mY6wDbRm3vo6+tcRdw/9mKt56kZz+8r
         vcYg==
X-Gm-Message-State: AOAM531fIBVoAOXrSkJsGkbSY5S+a9ajXM9dTasiJltY5sO88zArN5sa
        Nrv1x8TCrDqi9SiG+DJOl3I=
X-Google-Smtp-Source: ABdhPJyhRgpHRFpduR3FDN2QSQ40EB4LNJfuphjQc+fRsVQhe4ljyVhRXsXKcnOkuhcGjTX7cqMjMQ==
X-Received: by 2002:a17:907:3d88:: with SMTP id he8mr6750259ejc.565.1638963480952;
        Wed, 08 Dec 2021 03:38:00 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:00 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/18] docs: Add user documentation for tcp_authopt
Date:   Wed,  8 Dec 2021 13:37:17 +0200
Message-Id: <e07953d5afd10bae67df09db351123ef57779172.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
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

