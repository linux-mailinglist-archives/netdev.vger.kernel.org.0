Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E513F60EC91
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 01:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbiJZX2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 19:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiJZX16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 19:27:58 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11706371;
        Wed, 26 Oct 2022 16:27:28 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id bp11so28493887wrb.9;
        Wed, 26 Oct 2022 16:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XwaiR4O/rZjigAPWT1KoMEzhsR2kF/G+5vxIJc6wD5s=;
        b=Bu4bo56Jm6v4TfxmzjqZcJRChktHS1B0iE+RX3L0RFbVpDfbKrDXl/LiUc6r8zCQPl
         6dc9Jtrac8FLTRkKUgsaxBAHwXCNQtQw5VnD1SzHokOMIUfrOl+zw3rBW4MJ7ENzx7WA
         MyVN8JHW1wG0CVTk5Q+dCFY0NQ56f7nwsbv3V7l9d2YOQKZVolOnzib0tghIlCc0NZMm
         IF0rZYGWhKe8anumFRYzoPUWDepAYE85bXoJeGPnIsvpFb5svBQFf3GHgyBSPVkIxi4m
         jFHvLf03QJClqAP/JmjoHauOCoyMOHFLMpUMXhA7etYYCwAN4MEEmfjhfIf+u5S/F1nJ
         zDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XwaiR4O/rZjigAPWT1KoMEzhsR2kF/G+5vxIJc6wD5s=;
        b=a1FHr7bhYIUxr6omRUXlSEtH+tcqDMMldFNErbkhAHTFLfst7or5dcEX5TmsjR2GDC
         hMJUZwsbzkwK/hA9yeXYEqtd0oOmd01qJ7gshACbqWdSK6hLUY5zRuUgqKqV4bf6neS6
         vPbEBJgT0/SqHRLgIzwTOdlrPC8Oc5cy5BVItvr1RPB+adJwQgTLgvfOVPV+T8c+F+C3
         uiT4tiJ1idosrm2ujZQuWEH+XUDWk6/Qwc6DspIRIWPQdRR/QZk1isfqOH3KmKahW+zg
         LZByRZlq4LfmM8ltulSImjWlueVCm7gHfFZxaSQ3Hw4dzhhqoVt02WSHXHew77T9FSa1
         9oow==
X-Gm-Message-State: ACrzQf0MZGeCXl4J2dhU/RSpYmpo1AWC4/56HZB7u9XhtMVxq8//fC8j
        GtC5ZjFw6zQWod5gOYkoCtrvRwmr9IHuVw==
X-Google-Smtp-Source: AMsMyM4rQXMTCsG9gei9GXpVUvZWRKX7LWUzJRvZ8Q2ffYqX00rAdyk4Vjc8mzsmZIM9xBo9zd1d4A==
X-Received: by 2002:adf:e0cb:0:b0:22e:2e7e:e57d with SMTP id m11-20020adfe0cb000000b0022e2e7ee57dmr31101308wri.170.1666826847085;
        Wed, 26 Oct 2022 16:27:27 -0700 (PDT)
Received: from 127.0.0.1localhost (213-205-70-130.net.novis.pt. [213.205.70.130])
        by smtp.gmail.com with ESMTPSA id y4-20020adfd084000000b002368424f89esm4897526wrh.67.2022.10.26.16.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 16:27:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, io-uring@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        asml.silence@gmail.com
Subject: [PATCH net 0/4] a few corrections for SOCK_SUPPORT_ZC
Date:   Thu, 27 Oct 2022 00:25:55 +0100
Message-Id: <cover.1666825799.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
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

There are several places/cases that got overlooked in regards to
SOCK_SUPPORT_ZC. We're lacking the flag for IPv6 UDP sockets and
accepted TCP sockets. We also should clear the flag when someone
tries to hijack a socket by replacing the ->sk_prot callbacks.

Pavel Begunkov (3):
  udp: advertise ipv6 udp support for msghdr::ubuf_info
  net: remove SOCK_SUPPORT_ZC from sockmap
  net/ulp: remove SOCK_SUPPORT_ZC from tls sockets

Stefan Metzmacher (1):
  net: also flag accepted sockets supporting msghdr originated zerocopy

 include/net/sock.h  | 7 +++++++
 net/ipv4/af_inet.c  | 2 ++
 net/ipv4/tcp_bpf.c  | 4 ++--
 net/ipv4/tcp_ulp.c  | 3 +++
 net/ipv4/udp_bpf.c  | 4 ++--
 net/ipv6/udp.c      | 1 +
 net/unix/unix_bpf.c | 8 ++++----
 7 files changed, 21 insertions(+), 8 deletions(-)

-- 
2.38.0

