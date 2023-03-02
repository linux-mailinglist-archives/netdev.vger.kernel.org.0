Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2306A858A
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 16:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjCBPsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 10:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCBPsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 10:48:13 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEED193C2;
        Thu,  2 Mar 2023 07:48:12 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id d7so18399522qtr.12;
        Thu, 02 Mar 2023 07:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OQkiJND02BK/IXx43D/6SWtx0ejjMuFojMoaAG3gPWQ=;
        b=Kmv5Z9EesMZzu6NKbOpKGZKLADvdtBnDEbDoxdsbw6Lib1WTNhqahAziVKjahTDTun
         Pv972CHmYjqZG2TUOS09QD2fCzvNiuuR5G2E/aV27SbzVzgJMk5wKbLAZcNKsBsyy/K+
         rIfqZQSGHZ2ob+j5MP2atFMYZxlAjSHYVzM2SooQx8WtmYP7NHqV6D3vECmfsh7/OIRd
         jzl68Ua+YrU2EtYG+AExN1CPxe1G9eNoACegPEcW/jRg5c44tfi0VZsV0iFrRc+If9FW
         CVrr+RuvLfdhR+bWJphB67kMCMWGd3dRG7AusQtqWQAzBvCJ75tJnTAey9R7vXwVjIX9
         pbdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OQkiJND02BK/IXx43D/6SWtx0ejjMuFojMoaAG3gPWQ=;
        b=6gR8DbGYj2HA4Psaa74llcSXNXqnfyUS/Yt2nxECZrCsV9zUNKweP1afgoCBy1ahxc
         PeLE25ywhz3+ygkyvtH7u83RT3qsktShCg54u/f6SVzZz8up7xFL6589WYd01mG0p7sO
         SCjSgEON4x3L7phm4AKAolhuywyJTPo50vreBVPoUGxfP8iog4EwZ80NEFiFd3TMk64V
         DwFU4cc60xSQ5SiNKc5mi9A4cuk2V6GbXC/HiSGYQHc/xu+lIl8a7A3JIlYM7x0O7PSA
         rqU5BrlvEu8566Zb8m9JnjzRbzXOYb4T9OYkIaHEDZAGuVaIY/ue1cDRV5EvKjy5rVQj
         2uMw==
X-Gm-Message-State: AO0yUKXYODLUE/affmdgvVMqCDnfdhoij832/HpJTzeP92JLQWf7yyKC
        I3ZKmkkluhe7iEU2lWEareIRLiP+jY4=
X-Google-Smtp-Source: AK7set93WhOxbqAThjFxYgvJAJzjliza/f79qldeP6f1q5EDaxzX6P6kKyYwUrDi1HhgfY8Wx44PVg==
X-Received: by 2002:a05:622a:11c3:b0:3b9:bd8d:bb22 with SMTP id n3-20020a05622a11c300b003b9bd8dbb22mr4279873qtk.14.1677772091443;
        Thu, 02 Mar 2023 07:48:11 -0800 (PST)
Received: from willemb.c.googlers.com.com (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id s72-20020a37454b000000b007417e60f621sm11097113qka.126.2023.03.02.07.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 07:48:11 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     linux-man@vger.kernel.org
Cc:     mtk.manpages@gmail.com, alx.manpages@gmail.com, pabeni@redhat.com,
        netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Subject: [PATCH manpages v2 1/2] udp.7: add UDP_SEGMENT
Date:   Thu,  2 Mar 2023 10:48:07 -0500
Message-Id: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
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

UDP_SEGMENT was added in commit bec1f6f69736
("udp: generate gso with UDP_SEGMENT")

    $ git describe --contains bec1f6f69736
    linux/v4.18-rc1~114^2~377^2~8

Kernel source has example code in tools/testing/selftests/net/udpgso*

Per https://www.kernel.org/doc/man-pages/patches.html,
"Describe how you obtained the information in your patch":
I am the author of the above commit and follow-ons.

Signed-off-by: Willem de Bruijn <willemb@google.com>

---

Changes v1->v2
  - semantic newlines: also break on comma and colon
  - remove bold: section number following function name
  - add bold: special macro USHRT_MAX
---
 man7/udp.7 | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/man7/udp.7 b/man7/udp.7
index 5822bc551fdf..6646c1e96bb0 100644
--- a/man7/udp.7
+++ b/man7/udp.7
@@ -204,6 +204,34 @@ portable.
 .\"     UDP_ENCAP_ESPINUDP draft-ietf-ipsec-udp-encaps-06
 .\"     UDP_ENCAP_L2TPINUDP rfc2661
 .\" FIXME Document UDP_NO_CHECK6_TX and UDP_NO_CHECK6_RX, added in Linux 3.16
+.TP
+.BR UDP_SEGMENT " (since Linux 4.18)"
+Enables UDP segmentation offload.
+Segmentation offload reduces
+.BR send (2)
+cost by transferring multiple datagrams worth of data as a single large
+packet through the kernel transmit path,
+even when that exceeds MTU.
+As late as possible,
+the large packet is split by segment size into a series of datagrams.
+This segmentation offload step is deferred to hardware if supported,
+else performed in software.
+This option takes a value between 0 and
+.BR USHRT_MAX
+that sets the segment size:
+the size of datagram payload,
+excluding the UDP header.
+The segment size must be chosen such that at most 64 datagrams are sent in
+a single call and that the datagrams after segmentation meet the same MTU
+rules that apply to datagrams sent without this option.
+Segmentation offload depends on checksum offload,
+as datagram checksums are computed after segmentation.
+The option may also be set for individual
+.BR sendmsg (2)
+calls by passing it as a
+.BR cmsg (7).
+A value of zero disables the feature.
+This option should not be used in code intended to be portable.
 .SS Ioctls
 These ioctls can be accessed using
 .BR ioctl (2).
-- 
2.39.2.722.g9855ee24e9-goog

