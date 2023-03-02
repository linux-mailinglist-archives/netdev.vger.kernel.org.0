Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C565B6A858B
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 16:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjCBPsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 10:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjCBPsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 10:48:13 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03DD6EBC;
        Thu,  2 Mar 2023 07:48:12 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id ks17so11920269qvb.6;
        Thu, 02 Mar 2023 07:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4KNdpY7mZZeDMkNs/8ZHD716EPWzyrnrEKXe+qhTR3c=;
        b=FNM6gfaaMuXxpfs5roJYZVjl8ioiJANcydrINN6kG4maAyuA+d1qkZvVrYwKrWWZFP
         wH5c3OqVNYgS+Jdiw9OyfH43c8eq9bGnAsfEOMJvK9z9hk7ydYpJSf618Bi2tCpOcNpx
         P1BOJmGH3OPAZVZI7RBiLmBTyZ14k/ERcXvj4lH6UcCTUQ+8ydQ0zjzoFHSkX/rNU+7E
         Y3teVJvg4/IwEHr/6GpggJJi6NtE+yYwyoc88hYk54cQYTLTuKZkcpiDLCz44EMNGt1q
         TdWZYlGIKY3WUi9vd9eKTyZUsV16738cwhhTE/U3odFMeCcg9SAWy7qNw3c+Z7vrdO9J
         p3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KNdpY7mZZeDMkNs/8ZHD716EPWzyrnrEKXe+qhTR3c=;
        b=BvKavR5BWkio1sY1kRt4A/4fpTtl2pauT1ByN1Ye9QCE6LF7tbYu/wsmubPAMX1xxO
         AWDUYMoNo5CdqYaE/mWjH4qlfx7xDYYc3EvNxRf8gwx/4cdpiUq6u7Z4F3TOVaYWS2nz
         RkgnkCTOTqjaoFrvathrUcLmYzQwztZjeO2ir48+6wihoAt7k2zmOZFdQOe7IkQ5n64+
         qyRR3NjLrUSRgE/TS6b3UVWwM/oo9E3vwsNdRGJlAcITVsym8vn6U1nDcTbvihfIXmIF
         kY63K4zd8ZJ8qIa4lyhstIbZvNVNRS/+01sCmLBlaoDyuuZts4mK3Mjke474ia3AouCv
         tNbw==
X-Gm-Message-State: AO0yUKXLF6OGZht2styqnl7Uw9sQQ1sGtxDOkIul2F0hhdwroY3BZoVS
        ZSOjQQ8mcca7bdxa/yxnyDKyMkOQxSk=
X-Google-Smtp-Source: AK7set8vHj0UySoAa9aQkTdwfIxwW6/G3k6RYJV6mH6EJucH9wEsq9N5AUoHpBcRzw2iExz0GjyPHw==
X-Received: by 2002:a05:6214:2589:b0:56b:7cb:bdcd with SMTP id fq9-20020a056214258900b0056b07cbbdcdmr22386104qvb.39.1677772091950;
        Thu, 02 Mar 2023 07:48:11 -0800 (PST)
Received: from willemb.c.googlers.com.com (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id s72-20020a37454b000000b007417e60f621sm11097113qka.126.2023.03.02.07.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 07:48:11 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     linux-man@vger.kernel.org
Cc:     mtk.manpages@gmail.com, alx.manpages@gmail.com, pabeni@redhat.com,
        netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Subject: [PATCH manpages v2 2/2] udp.7: add UDP_GRO
Date:   Thu,  2 Mar 2023 10:48:08 -0500
Message-Id: <20230302154808.2139031-2-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
In-Reply-To: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
References: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
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

From: Willem de Bruijn <willemb@google.com>

UDP_GRO was added in commit e20cf8d3f1f7
("udp: implement GRO for plain UDP sockets.")

    $ git describe --contains e20cf8d3f1f7
    linux/v5.0-rc1~129^2~379^2~8

Kernel source has example code in tools/testing/selftests/net/udpgro*

Per https://www.kernel.org/doc/man-pages/patches.html,
"Describe how you obtained the information in your patch":
I reviewed the relevant UDP_GRO patches.

Signed-off-by: Willem de Bruijn <willemb@google.com>

---

Changes v1->v2
  - semantic newlines: also break on comma
  - remove bold: section number following function name
---
 man7/udp.7 | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/man7/udp.7 b/man7/udp.7
index 6646c1e96bb0..a350a40da340 100644
--- a/man7/udp.7
+++ b/man7/udp.7
@@ -232,6 +232,20 @@ calls by passing it as a
 .BR cmsg (7).
 A value of zero disables the feature.
 This option should not be used in code intended to be portable.
+.TP
+.BR UDP_GRO " (since Linux 5.0)"
+Enables UDP receive offload.
+If enabled,
+the socket may receive multiple datagrams worth of data as a single large
+buffer,
+together with a
+.BR cmsg (7)
+that holds the segment size.
+This option is the inverse of segmentation offload.
+It reduces receive cost by handling multiple datagrams worth of data
+as a single large packet in the kernel receive path,
+even when that exceeds MTU.
+This option should not be used in code intended to be portable.
 .SS Ioctls
 These ioctls can be accessed using
 .BR ioctl (2).
-- 
2.39.2.722.g9855ee24e9-goog

