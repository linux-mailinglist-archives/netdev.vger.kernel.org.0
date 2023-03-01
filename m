Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B436A75F7
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 22:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCAVLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 16:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCAVLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 16:11:53 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FEB1B2FC;
        Wed,  1 Mar 2023 13:11:51 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id y10so11259489qtj.2;
        Wed, 01 Mar 2023 13:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LYRVxUnOeTppEiPbfUISwKkk8e/BBPxX9fPkCXak0EY=;
        b=pcPX0GUhh1yhCgpm3fJgSsoGP60VTIi1oFo5Q4QqHGF4UoHn6+iPPbXDtxjAt5vkwa
         aMRhcTljcSueS7FpCfVVbfuw95BAc0y/ZaTV4B/eICgaWfMb/4gmrWmsb3WDXWA33L5b
         9krjfP8nSrfeHLeW3+X8ZOqWUCNVgdU8dSCOE41A5p9ECutdruXJgvXavJITg0ke+jKt
         MMlNOVDnNydJv5b6Gvrlhbatkker/YzPM0HWdjuUndwggU+agP6iyHtd/045xqLUixmY
         oucauvLfESXXsrLxK/g3VTRbTK4+cTejt7gsSHJuelvoZcjEg7KZLdp3DnGo7F+V1MV9
         dQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LYRVxUnOeTppEiPbfUISwKkk8e/BBPxX9fPkCXak0EY=;
        b=nFsBUUUPFa65GwrRBgBwB+wkkkgY6zbMr6keH9EqkWj3dW9xpGrMyitWtlO2XDAeRP
         z4kknlaxqJGUZFyg12w53R+FYz4G9j7qi+lSeChR078KFHOOuTZfJRHnFNaGdhI+B17u
         +RbfvnLSVl0d++7QGhIcUNKPCsLSAwUWhIow81BrSeTv0qmZ5sHyb+azaDCadKQiJjXV
         Wlx+XFBtzpwfIMLWe3RMalKu6AAz2aAUpExH7dF+2w2gN8ephcHWVcLjvhfBxTBGYcoe
         paNcs9rfTgStpnkRW/9Lly5Kk/XiWtSryVeEKmhps5Pnh0Gwqq7LlfdNtnwneZBUSaKH
         oRag==
X-Gm-Message-State: AO0yUKUZSL76hcrR6i5I+8BkBDiQocPMkW23eMsCtsgTOWXCV9yQCGe0
        d/aFsRZ0bGAABo4dFlPTqMpSL8JAVto=
X-Google-Smtp-Source: AK7set8Y0eCcAZnhV65hqyvUmBnS2RUsJfnH9rJ8xhcQMW+xUCNYjrJ3+upuStHLu2QIw6oZioiHtQ==
X-Received: by 2002:a05:622a:110f:b0:3b4:79f8:26c3 with SMTP id e15-20020a05622a110f00b003b479f826c3mr12996650qty.33.1677705110565;
        Wed, 01 Mar 2023 13:11:50 -0800 (PST)
Received: from willemb.c.googlers.com.com (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id a12-20020ae9e80c000000b007423843d879sm9560442qkg.93.2023.03.01.13.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 13:11:50 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     linux-man@vger.kernel.org
Cc:     mtk.manpages@gmail.com, alx.manpages@gmail.com, pabeni@redhat.comm,
        netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Subject: [PATCH manpages 1/2] udp.7: add UDP_SEGMENT
Date:   Wed,  1 Mar 2023 16:11:45 -0500
Message-Id: <20230301211146.1974507-1-willemdebruijn.kernel@gmail.com>
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
 man7/udp.7 | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/man7/udp.7 b/man7/udp.7
index 5822bc551fdf..ec16306df605 100644
--- a/man7/udp.7
+++ b/man7/udp.7
@@ -204,6 +204,31 @@ portable.
 .\"     UDP_ENCAP_ESPINUDP draft-ietf-ipsec-udp-encaps-06
 .\"     UDP_ENCAP_L2TPINUDP rfc2661
 .\" FIXME Document UDP_NO_CHECK6_TX and UDP_NO_CHECK6_RX, added in Linux 3.16
+.TP
+.BR UDP_SEGMENT " (since Linux 4.18)"
+Enables UDP segmentation offload.
+Segmentation offload reduces
+.BR send(2)
+cost by transferring multiple datagrams worth of data as a single
+large packet through the kernel transmit path, even when that
+exceeds MTU.
+As late as possible, the large packet is split by segment size into a
+series of datagrams.
+This segmentation offload step is deferred to hardware if supported,
+else performed in software.
+This option takes a value between 0 and USHRT_MAX that sets the
+segment size: the size of datagram payload, excluding the UDP header.
+The segment size must be chosen such that at most 64 datagrams are
+sent in a single call and that the datagrams after segmentation meet
+the same MTU rules that apply to datagrams sent without this option.
+Segmentation offload depends on checksum offload, as datagram
+checksums are computed after segmentation.
+The option may also be set for individual
+.BR sendmsg(2)
+calls by passing it as a
+.BR cmsg(7).
+A value of zero disables the feature.
+This option should not be used in code intended to be portable.
 .SS Ioctls
 These ioctls can be accessed using
 .BR ioctl (2).
-- 
2.39.2.722.g9855ee24e9-goog

