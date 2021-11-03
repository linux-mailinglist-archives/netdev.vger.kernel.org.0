Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435EF443B86
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhKCCry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhKCCrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:47:53 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE25AC061205;
        Tue,  2 Nov 2021 19:45:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x16-20020a17090a789000b001a69735b339so308881pjk.5;
        Tue, 02 Nov 2021 19:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dGoyV4fCoRXNajtKo2OIimzU4swWF5wBMtUNN+o+twI=;
        b=SU1X0eLF2hkaqKyhr3DnPveNPN7affZegKXGUKTtUE1pTGlW2V+U3XyXzS5DzAjwJG
         AAQlPwYw6VMfJr7zd8TezOUSiKbtdJ0EHcUnmeyY+zQ2XUhrqlgALM/CRhBYJcuTb2Q+
         32PhjT1VwzASd4EzhyqbcF7NJ6eciNtUZaRQ7iwaG4eGULAcp6s2iIfQyq5qkUMe1M2L
         VGi8xg5BXKrmV18vvHTpvjocnCKp+XOqxeGXYrDDTtd9vPGNVeWBx3OXASS5wWXUpS5C
         ZaQc150t8loA93ZK8bdNs9MSbq0FUD2FB4OGekL8H146+vD7feuBaJVhgDW6Q6aq6prj
         k+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dGoyV4fCoRXNajtKo2OIimzU4swWF5wBMtUNN+o+twI=;
        b=iIE1XKVBGr4GcC49l4UKVqwplTuiXuIBnlii/1LcV6j4t9ZPdjU/nxYUFTnufChF2S
         pcNjXoDMITeJO6yyH8ag7QwydbJRtIrpNyUlZWkY6uH7Q3yy7kXqP1YRgsMjqq7c4uCR
         w0ufiArdm1xTqO7xr+pL8LyCXyGXGgFMG33C+uaoJo3s0W1W9MUIWZD1+6jxHi01ewCg
         VWFwCzSzXuql80PPjGUKvyYFNYJdcr6ZW9oU0v3iitGcOymZ+EDxPozRG4HhCIYwmNfW
         HLWjaX5w257aDYgCQqHo4rRhQEZ0gl0xC7vFf/hQ070hd7CvUsqT+wzmkMlKMMsz5dtR
         wzCA==
X-Gm-Message-State: AOAM531yWjS57bwY0CByA8b6hikhpXyscQYy6u35YYW/pU0hDGeeDeAo
        ahu3f4uXSsBJhtFwCQZYPNI9jNLQIwc=
X-Google-Smtp-Source: ABdhPJzcgM7C4V4h0LPRlkofLuh/XLVMxPTZatriYwVrOQpu6v7Usynvp/ak6PSrVRzNzn3XJyvqfw==
X-Received: by 2002:a17:90a:509:: with SMTP id h9mr11495517pjh.114.1635907517323;
        Tue, 02 Nov 2021 19:45:17 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t13sm348088pgn.94.2021.11.02.19.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 19:45:17 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 2/5] kselftests/net: add missed setup_loopback.sh/setup_veth.sh to Makefile
Date:   Wed,  3 Nov 2021 10:44:56 +0800
Message-Id: <20211103024459.224690-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103024459.224690-1-liuhangbin@gmail.com>
References: <20211103024459.224690-1-liuhangbin@gmail.com>
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
index 7b079b01aa1b..8c3d0709b870 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -30,7 +30,7 @@ TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
 TEST_PROGS += gre_gso.sh
 TEST_PROGS += cmsg_so_mark.sh
-TEST_PROGS_EXTENDED := in_netns.sh
+TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
-- 
2.31.1

