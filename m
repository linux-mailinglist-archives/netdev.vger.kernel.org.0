Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CE144252E
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhKBBjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhKBBjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:39:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7339C061714;
        Mon,  1 Nov 2021 18:36:57 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t11so13479818plq.11;
        Mon, 01 Nov 2021 18:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7wCH4P3iP0+2bqC7WwRxKqSXZkxKBG+1WV/udhyneOE=;
        b=GUaWmBzUKB5VwKBJt9t/GCCdA5MhwNFOTPZxe4m5iy83P8Vjqkuf8Znx8Dr6ZvFHjO
         xfaxsS5IelVmZFtw3lGVt6EUFNS2xDYlXCF+p+vG4pWGaaq9pGhODjbHvEaR0mAjnK6L
         UVzR2+cysrf6N58AAZbRadmJVezwftBuQspiOBP2ey0+PZ649sv3QjlI3NYSvTW/OYm2
         1N6DQFfpUxnZ5NXfPOLEFtMsH9o2SDaMcOEDYJW3ZYpYiS5hhXvAtE4WZODZbmv+xV/5
         zL1JcTcz/h4HAlZk7NF0FJ0MavtKxtJYqAEQ/OyxDxk2HH4wWJ59mryntPWR128BFAuf
         FU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7wCH4P3iP0+2bqC7WwRxKqSXZkxKBG+1WV/udhyneOE=;
        b=KhPSqzc400mG3KGwrm6wP08q2rxrp6h44n5IgfXtMpsRkJAZVxO5hMR59GYrNKUkr1
         ALsTZ6Ka+6ppto3G4M9wpb0Im8mndIc6vMkrfKo66c3u5h+NUAGcCFy9lMRdK2r3rCpj
         U62s01yvPOES4ipG08FCR0DnGs+jR6RFZMt8FxqAe/f23kfaXuJ/IsFyH+/BJWSougeM
         ob+NFjXgORQxjO5YZ/u9ftZn9V+v5/WQMGpESKn90DDOeERTx183TtdXkouB2HaXGtib
         AfWmxDBCsjorzbx5k3Op4F8FHJ3VD7yoKZ+hwLkEdmy+wllajFO1wVqfPxTsxcMT7vTg
         tuRg==
X-Gm-Message-State: AOAM532ZzQ+J07AdbWjLnBlVZ0/TUtuhk4hjNZWaFvJHXv1GhYcVzfc5
        //NFtLqlOtN7gF+ip6NDY3x3QJc7xKg=
X-Google-Smtp-Source: ABdhPJyLyPbbF9Xqn58Wum94pY9Bb7h3TrfbhV4mqD+dVgIb8eL4geQ1XOutGYF14gsHnXsdEhJ0nQ==
X-Received: by 2002:a17:90a:af92:: with SMTP id w18mr3034689pjq.76.1635817017173;
        Mon, 01 Nov 2021 18:36:57 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b16sm16867209pfm.58.2021.11.01.18.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 18:36:56 -0700 (PDT)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 0/5] kselftests/net: add missed tests to Makefile
Date:   Tue,  2 Nov 2021 09:36:31 +0800
Message-Id: <20211102013636.177411-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftest to another folder, some tests are missing
as they are not added in Makefile. e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

These pathset add them separately to make the Fixes tags less. It would
also make the stable tree or downstream backport easier.

If you think there is no need to add the Fixes tag for this minor issue.
I can repost a new patch and merge all the fixes together.

Thanks

v2: move toeplitz.sh/toeplitz_client.sh under TEST_PROGS_EXTENDED.

Hangbin Liu (5):
  kselftests/net: add missed icmp.sh test to Makefile
  kselftests/net: add missed setup_loopback.sh/setup_veth.sh to Makefile
  kselftests/net: add missed SRv6 tests
  kselftests/net: add missed vrf_strict_mode_test.sh test to Makefile
  kselftests/net: add missed toeplitz.sh/toeplitz_client.sh to Makefile

 tools/testing/selftests/net/Makefile | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
2.31.1

