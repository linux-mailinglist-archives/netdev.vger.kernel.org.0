Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C83F4412AB
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 05:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhKAEJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 00:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhKAEJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 00:09:02 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0B3C061714;
        Sun, 31 Oct 2021 21:06:30 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso301904pjb.2;
        Sun, 31 Oct 2021 21:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a6qQ3h1Ch302HJfYHQZAmeh/lV7bJkSJ8DTpxUDtbRQ=;
        b=NROFMPdiJLI8UUTddBHWLZ4FLx2tkV5X6db5lQK80QV8z0JonCgjR84wihx8P+Iaax
         93+69bCdfyiKXqrsTed2UZ8+1dMkBJfGxt7MuH3DUcjgClZcGe+IZVuMFdDyVul5A31e
         ZEfDnKP1PgXhGM5yl4YkU1IDeIluwvPpqph2RP9nAEwHmh5T5TCnpsIi82676k04WSvS
         0b9EeR2c/E2YjDyfjTyPtdz2SD17I/GVYaP76dNWS1f5JC23G4AyZ5NephOTzqu9C2/F
         gEabOLj0euP21+B8e/muS55sBK+yWJQLFZDmqDcnG8ZyXsKGPEyQpRgGabJg2r3Yjmej
         RTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a6qQ3h1Ch302HJfYHQZAmeh/lV7bJkSJ8DTpxUDtbRQ=;
        b=veS6epXZYMrLrBJVPxkvszBO4ja5iMHS8PzJ6WxvoJvnvBpxvowiSKyfQ3zS6k7CwL
         VPLWNoRDXvL+drRg3wN/nXRSDhY7h0038KmYVKBp6QmQhUAqM07t6ALnndkz/VL1VN+t
         AfB5dVWouUZp5DN6yWM+bYjGpMfdVHhBcFJMjoV0cEW9h+g86WrT61nQjg6fsaJNpUBN
         tRCLu/RohXN1qatRJCFYJgIFuLwFoHrahkO99f2hwkv8RcvJOsGKz64krVD3Sk1aT86i
         6f3juONdIW06frpFfVLh1nVcKR4NQ49P9nSKLL6l7+AGxVO93GvfNwfnI2ziZlYKsCHT
         +s6Q==
X-Gm-Message-State: AOAM532pCEk8Q0tAMpAGgqkWo1Ma4EQqKdhJ41IhKBW+VPoO7xrwlKgk
        nJDCNeBeUrD09kUExx+jfY+A2DgFZ7Q=
X-Google-Smtp-Source: ABdhPJxgiivyLXTriUKIk4IGO2MI2JoC8J3Ev+9eV08gP36+p6KDKUzmag4eha52pwUFGEUfETBSeA==
X-Received: by 2002:a17:90b:1a85:: with SMTP id ng5mr35858952pjb.43.1635739589501;
        Sun, 31 Oct 2021 21:06:29 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v13sm11132231pgt.7.2021.10.31.21.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 21:06:29 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/5] kselftests/net: add missed setup_loopback.sh/setup_veth.sh to Makefile
Date:   Mon,  1 Nov 2021 12:06:06 +0800
Message-Id: <20211101040609.127729-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101040609.127729-1-liuhangbin@gmail.com>
References: <20211101040609.127729-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the include file
setup_loopback.sh/setup_veth.sh for gro.sh/gre_gro.sh are missing as
they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 7d1575014a63 ("selftests/net: GRO coalesce test")
Fixes: 9af771d2ec04 ("selftests/net: allow GRO coalesce test on veth")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9b1c2dfe1253..63ee01c1437b 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -28,7 +28,7 @@ TEST_PROGS += veth.sh
 TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
 TEST_PROGS += gre_gso.sh
-TEST_PROGS_EXTENDED := in_netns.sh
+TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
-- 
2.31.1

