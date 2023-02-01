Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5062686607
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjBAMgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjBAMgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:36:40 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBF15B595
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 04:36:37 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id me3so51006423ejb.7
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 04:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UG0+CbPKl+yc+rOVVgUYjitIGI/X5mZqO7Eu1sUc9pk=;
        b=sj8VF/6y8FqJEFfS5LWKl26EHboGDrVqumt4cfjJd1NPIGVsdyiRMDkSkVqlkIdy7O
         ajupPh4QVyggboOVJvbX2dw6xY6SB+xlzAvUuXvMlNNPrTlKnZKT5gBZ5xNCt/qRaRKI
         fOKnuUY1fzEQbcF6iP5Q3SQUzTMq2PliL+Y8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UG0+CbPKl+yc+rOVVgUYjitIGI/X5mZqO7Eu1sUc9pk=;
        b=nxnjL+gUUulfmqwbLTeb53rS4108SMVIRAqzK1PmHC5BxIrW34ok8K2ACROPyD79by
         v/4BypJnpoNPnpPvcj/2l+usZQ1iCZ/N1WkYkD2frswbUDNDmu8zqNch8zGzdLKh/WB6
         //Jt2sspyuhmOwVla1XXPI9rB76emsnh+2QAsZ9Bv/qAlgnbb2BybGmdmcWQvosQ7y78
         wyqwgkALJPA4j6X4Xw1dBWTJ5u54fy76xskpiW+xSce7C51mC+2HWJ9UJn/PGdG3RAdR
         cpjRApjHosicWRsg8LWlvGmIJkko0YgLLs/RU7Zj4kNkDPBlO+8zwCf2J6WL3BhUoirS
         zPVA==
X-Gm-Message-State: AO0yUKXN/G/um7jrV9DKAb4Kq+hYjufJ46zm01+/9kaLNJsExYbSe2bH
        vD1v7wud9AbosSkW1lNWd+Bhrg==
X-Google-Smtp-Source: AK7set8cgNtpP8ym9uEQjpSd9da0X2g2FDEmnwRraaDsncowbdnWvVfCMcAYTvHwaR/TacmF//efkg==
X-Received: by 2002:a17:906:1659:b0:88c:bc3e:de46 with SMTP id n25-20020a170906165900b0088cbc3ede46mr2203792ejd.34.1675254996014;
        Wed, 01 Feb 2023 04:36:36 -0800 (PST)
Received: from cloudflare.com (79.191.53.204.ipv4.supernova.orange.pl. [79.191.53.204])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906059100b0085fc3dec567sm10035066ejn.175.2023.02.01.04.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:36:35 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Alejandro Colomar <alx.manpages@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc:     linux-man@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: [PATCH] ip.7: Document IP_LOCAL_PORT_RANGE socket option
Date:   Wed,  1 Feb 2023 13:36:34 +0100
Message-Id: <20230201123634.284689-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux commit 91d0b78c5177 ("inet: Add IP_LOCAL_PORT_RANGE socket option")
introduced a new socket option available for AF_INET and AF_INET6 sockets.

Option will be available starting from Linux 6.3. Document it.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
Submitting this man page update as the author of the feature.

We did a technical review of the man page text together with the code [1].

[1]: https://lore.kernel.org/all/20221221-sockopt-port-range-v6-0-be255cc0e51f@cloudflare.com/
---
 man7/ip.7 | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/man7/ip.7 b/man7/ip.7
index f69af1b32..f166c3b57 100644
--- a/man7/ip.7
+++ b/man7/ip.7
@@ -439,6 +439,27 @@ and
 .B IP_TOS
 are ignored.
 .TP
+.BR IP_LOCAL_PORT_RANGE " (since Linux 6.3)"
+Set or get the per-socket default local port range. This option can be used to
+clamp down the global local port range, defined by the
+.I ip_local_port_range
+.I /proc
+interface described below, for a given socket.
+.IP
+The option takes an
+.I uint32_t
+value with the high 16 bits set to the upper range bound, and the low 16 bits
+set to the lower range bound. Range bounds are inclusive. The 16-bit values
+should be in host byte order.
+.IP
+The lower bound has to be less than the upper bound when both bounds are not
+zero. Otherwise, setting the option fails with EINVAL.
+.IP
+If either bound is outside of the global local port range, or is zero, then that
+bound has no effect.
+.IP
+To reset the setting, pass zero as both the upper and the lower bound.
+.TP
 .BR IP_MSFILTER " (since Linux 2.4.22 / 2.5.68)"
 This option provides access to the advanced full-state filtering API.
 Argument is an
-- 
2.39.1

