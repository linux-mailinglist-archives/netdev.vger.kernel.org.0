Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43535ACBA5
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiIEHGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbiIEHGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:06:23 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EF63ED43;
        Mon,  5 Sep 2022 00:06:16 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u6so10034536eda.12;
        Mon, 05 Sep 2022 00:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=qJGQHEU+kpkmq4yTgrqxLlEfpOC+9A8WgA8wjMg1leM=;
        b=pUF8siy89b+MGGymtiGkNqrwC4vnL3rMbK6M5hEGaDrw5Xo58oAQM/yXQs2ULW4V6B
         ZL1YNAyZyiFgDVVxjFnKImUdzXuol60DLc+bpTOFcooqKzTt8yPJyjgpIvQj2abJZUJh
         yxnRwA9vuPeOaoNemcPtHYHrXXWfqNWndfV5dcea8/OPwo+nwQt6Il37H2sLMFCE/wwQ
         eaiIOVEwsYyv1qtAC+DqpoNGzfPdVCqQK4lnBIosUeLcD118rKcCxgVCI2LVAxEbnhJ/
         sb6ogC7n2Td/2zkjCtnalAiklP2MjipMDERXav1oE6FqGV6x9K90+P2K4284tGKhjvl7
         YLNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=qJGQHEU+kpkmq4yTgrqxLlEfpOC+9A8WgA8wjMg1leM=;
        b=c+pu6P24xKDkrirH2aU4/1bJdQuoKda+L8vxqDlaACfjF9cMJO5jqB4AqxM2if9D+/
         D/93NF/aiHJnOw2q6ZYXpJR8g8H378psoNm/GcQgESQyyWQatGIj+95iL2Yc4pao2w0e
         1XHWD1SAk0EpjsdbtWAf+mxYCuwtlElgq3BA9qroCJULiukZ9IFb3BlT+/p5ufgBv7Z5
         yPpKArPvUGL9w9eWTliDnWj8hzz9Jmt9lLA/uBRYjozaoBLnTey8Jqsc+QENOAzziZPc
         vV3Ov8u4uqH0waP+SMD2KNTwZNKhWYdAi4bH5DO5NpEJNIFBgpjGuobltkCIhWNulnro
         fW5g==
X-Gm-Message-State: ACgBeo3IUwI0Ez9ws5dmfS4B5CcDZyNeKXvaoOgYGHM94QhervEQyzem
        ar1ilc5P15ME+d5KfS6fTnE=
X-Google-Smtp-Source: AA6agR72jhRS3DrZ/TrRtkDOHAUeSnk94FZyiy5U67cVfLStk1Ph5IqwU01idVvSNI+nV3IFo3UFjg==
X-Received: by 2002:a05:6402:510a:b0:43d:ab25:7d68 with SMTP id m10-20020a056402510a00b0043dab257d68mr41786831edd.102.1662361574723;
        Mon, 05 Sep 2022 00:06:14 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:14 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
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
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 02/26] docs: Add user documentation for tcp_authopt
Date:   Mon,  5 Sep 2022 10:05:38 +0300
Message-Id: <abf7e01d39808143c4ded7c6633a8a5be7f19af4.1662361354.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662361354.git.cdleonard@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
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
index bacadd09e570..b134037c94ec 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -102,10 +102,11 @@ Contents:
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

