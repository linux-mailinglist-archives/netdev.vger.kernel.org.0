Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF0B6A75F8
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 22:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjCAVL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 16:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCAVLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 16:11:53 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0009A2367D;
        Wed,  1 Mar 2023 13:11:51 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id nf5so10290333qvb.5;
        Wed, 01 Mar 2023 13:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHz/1l5Uvi1/potczqAeLBEMiZnRw+nlkp0cp7Wyv1g=;
        b=CEg4kC/2+bMY9afAEumj+vznuokAfBohzjH7oRUwhNus56O1O+gf2R7SQjxAJ4wr4W
         P9k0yiN/xReWVkDcMA7QvpLYwS1HrNBc58bBUHmeZrPX4Dp7XVMDQV6YmQjbdloBCrkq
         8M68dqtGyOIsmxWcsVh4YJByd9Sw/24boOfZJRluvh93OuDxy1mGTZLYIay2/NovwnqF
         QqU4sigg9K5VOKh6DX/+Jjr4SEL1RzwVMxiWn1zno0mfOJdnyvWMCPT0m6XPiiOfZc2j
         6PkpW4D1uownbUYB8ZjEhYS18hF2aS1nD218vqNrlouSjdFEAENqGvnHg2Y1WiQaCKr9
         5ATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHz/1l5Uvi1/potczqAeLBEMiZnRw+nlkp0cp7Wyv1g=;
        b=yslbg4PFse4kRG3vjTKfCjedGMPblGi1E+oJWyZA9sZvbEUAPCPWVUvDuJb6aNZ9Bi
         +Bue12J1qTOV0jnxfdV5P+/CXKyCsd75opuxSVdpbpEh4yWHmZzwMlOtMqM4oC3FQTNA
         ZlOTTDEpXt2TONHmJGh1JDNbMHLmlCmNQ8/7AE/exuh1LLK8hFJcJXkH74Ybt0LknRUS
         Bdyk9MwCGoSO7dgm+Bow3yoYfpmaikl/Ar/u8fas4vRscCpqv+wbZ+CB1RdaKcVdtdWW
         l5A96ux08gw8HHuaneuRJYNf+2bSC78vPFHpVopkb57KeUakaXF7LM1g87+9tHEy836T
         0+CA==
X-Gm-Message-State: AO0yUKVtVx6dIdJxggKMA37ldyvzu+pis0BEfgL68+Jt6Rre16wbjvZi
        g8l1wE0gDD1TGCUrFmgwBfex3oy10kg=
X-Google-Smtp-Source: AK7set99MoD/UaaCQiTn7b/98vS3UbsbnhUH9O+fZ/lTfYxzCuRDNLg4DAHvV6dROB3jLQlY8oAreg==
X-Received: by 2002:a05:6214:d49:b0:56e:c00c:bf5c with SMTP id 9-20020a0562140d4900b0056ec00cbf5cmr16079069qvr.31.1677705111156;
        Wed, 01 Mar 2023 13:11:51 -0800 (PST)
Received: from willemb.c.googlers.com.com (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id a12-20020ae9e80c000000b007423843d879sm9560442qkg.93.2023.03.01.13.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 13:11:50 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     linux-man@vger.kernel.org
Cc:     mtk.manpages@gmail.com, alx.manpages@gmail.com, pabeni@redhat.comm,
        netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Subject: [PATCH manpages 2/2] udp.7: add UDP_GRO
Date:   Wed,  1 Mar 2023 16:11:46 -0500
Message-Id: <20230301211146.1974507-2-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
In-Reply-To: <20230301211146.1974507-1-willemdebruijn.kernel@gmail.com>
References: <20230301211146.1974507-1-willemdebruijn.kernel@gmail.com>
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
 man7/udp.7 | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/man7/udp.7 b/man7/udp.7
index ec16306df605..b4cc06791e47 100644
--- a/man7/udp.7
+++ b/man7/udp.7
@@ -229,6 +229,18 @@ calls by passing it as a
 .BR cmsg(7).
 A value of zero disables the feature.
 This option should not be used in code intended to be portable.
+.TP
+.BR UDP_GRO " (since Linux 5.0)"
+Enables UDP receive offload.
+If enabled, the socket may receive multiple datagrams worth of data as
+a single large buffer, together with a
+.BR cmsg(7)
+that holds the segment size.
+This option is the inverse of segmentation offload.
+It reduces receive cost by handling multiple datagrams worth of data
+as a single large packet in the kernel receive path, even when that
+exceeds MTU.
+This option should not be used in code intended to be portable.
 .SS Ioctls
 These ioctls can be accessed using
 .BR ioctl (2).
-- 
2.39.2.722.g9855ee24e9-goog

