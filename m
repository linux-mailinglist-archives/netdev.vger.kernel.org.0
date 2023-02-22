Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0994B69EF57
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 08:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjBVHbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 02:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjBVHbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 02:31:22 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB7B305C3
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 23:31:21 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id o14so5287293wms.1
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 23:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=6pJtrQ/65KX23//MIne8dJj1PzfYgaFBp44xuJ1iPKY=;
        b=RmnrL6Wr6DQ61uF5y7IIBcbD5yD8zi8Hb/5LxljzMWQCfHQYphreOjxzMr4l9/ZQWF
         aAbfYH16Qmg7JxsPFZ9rve+rnvIYUg1zDjR8+XO2x30tsTYAUtE6F77DEIfc41X2bSHi
         DL76/KoVTyONAkrrHp+jivHwRjKrc+UTLASuJtB+QWaIIeT7Khn3wL9CKFDQSHqKvBTP
         0feObZbNB4pgu8vtZEMs3grOuKWJGhPkGEEz7FTEsNJ1M55s6LZzJHsjzNnj5cgQ+A9t
         e2krrMTeuelVUgeAC4rT/ZkVYYi5m6m2mcWsstDoSGGs5BF/bRQME/S983v2ly3G6Zdy
         j3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6pJtrQ/65KX23//MIne8dJj1PzfYgaFBp44xuJ1iPKY=;
        b=ov9jx81jjEXD/s/3prbRVJZpQ0deYlW+N/6PUqLwy1dvfyl4D03wPXUMo2MW6ANSEo
         aXpg8Bvt+WUd9WzYjfFsVSbiNWVM93FaDhdnqC7vJCk0rjx8IcP28myeApiZmiRC//8t
         gnkx2UvKDcoMhjbKjaOQfKfj1qsnGJx188Jo/odjMWPIo5yQjbps1bjcB2YnFs1YDvFH
         0CW67blixYmG0rr13CPFzK3zgMNPUiWG7zHCRae+VYdSCKN3CWt5LYRQ2blxWfcRJV/p
         +ijuT2C4b/T3jOLxo8f7kH0MPp+vXIEiqZYt4UdGPg+2R7q5/PV7PhC2U20jW+RfeGNO
         1Vhg==
X-Gm-Message-State: AO0yUKXItSWriu4r1w8Q0NnHIiQK12knIz176ryK50AGdDeERYlK/H+J
        XlGgfrF1FYhp8KLH8VvpFlG1pXpvCshTnenl
X-Google-Smtp-Source: AK7set+qpqvXGIzxP1v7aalTuKwANG/OaLH9exMQH5FTwg0tZc+pArrX9DPjBrtxT4ETua2SbfVpFw==
X-Received: by 2002:a05:600c:1818:b0:3e8:96d9:579f with SMTP id n24-20020a05600c181800b003e896d9579fmr1895101wmp.40.1677051078843;
        Tue, 21 Feb 2023 23:31:18 -0800 (PST)
Received: from thomas-OptiPlex-7090.nmg.localnet (d528f5fc4.static.telenet.be. [82.143.95.196])
        by smtp.gmail.com with ESMTPSA id h13-20020a05600c314d00b003e2059c7978sm6553841wmo.36.2023.02.21.23.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 23:31:18 -0800 (PST)
Sender: Thomas Devoogdt <thomas.devoogdt@gmail.com>
From:   Thomas Devoogdt <thomas@devoogdt.com>
X-Google-Original-From: Thomas Devoogdt <thomas.devoogdt@barco.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Thomas Devoogdt <thomas.devoogdt@barco.com>
Subject: [PATCH ethtool] uapi: if.h: fix linux/libc-compat.h include on Linux < 3.12
Date:   Wed, 22 Feb 2023 08:31:10 +0100
Message-Id: <20230222073110.511698-1-thomas.devoogdt@barco.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

./uapi/linux/if.h:23:10: fatal error: linux/libc-compat.h: No such file or directory
. #include <linux/libc-compat.h>          /* for compatibility with glibc */
          ^~~~~~~~~~~~~~~~~~~~~

https://github.com/torvalds/linux/commit/cfd280c91253cc28e4919e349fa7a813b63e71e8

Signed-off-by: Thomas Devoogdt <thomas.devoogdt@barco.com>
---
 uapi/linux/if.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/uapi/linux/if.h b/uapi/linux/if.h
index b287b2a..8861497 100644
--- a/uapi/linux/if.h
+++ b/uapi/linux/if.h
@@ -20,7 +20,12 @@
 #ifndef _LINUX_IF_H
 #define _LINUX_IF_H
 
+#include <linux/version.h>
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 12, 0)
 #include <linux/libc-compat.h>          /* for compatibility with glibc */
+#endif
+
 #include <linux/types.h>		/* for "__kernel_caddr_t" et al	*/
 #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
 		/* for "__user" et al           */
-- 
2.39.2

